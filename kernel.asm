
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
8010002d:	b8 d0 3b 10 80       	mov    $0x80103bd0,%eax
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
8010003d:	68 98 a0 10 80       	push   $0x8010a098
80100042:	68 a0 e6 10 80       	push   $0x8010e6a0
80100047:	e8 72 68 00 00       	call   801068be <initlock>
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
801000c1:	e8 1a 68 00 00       	call   801068e0 <acquire>
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
8010010c:	e8 36 68 00 00       	call   80106947 <release>
80100111:	83 c4 10             	add    $0x10,%esp
        return b;
80100114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100117:	e9 98 00 00 00       	jmp    801001b4 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011c:	83 ec 08             	sub    $0x8,%esp
8010011f:	68 a0 e6 10 80       	push   $0x8010e6a0
80100124:	ff 75 f4             	pushl  -0xc(%ebp)
80100127:	e8 26 55 00 00       	call   80105652 <sleep>
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
80100188:	e8 ba 67 00 00       	call   80106947 <release>
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
801001aa:	68 9f a0 10 80       	push   $0x8010a09f
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
801001e2:	e8 67 2a 00 00       	call   80102c4e <iderw>
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
80100204:	68 b0 a0 10 80       	push   $0x8010a0b0
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
80100223:	e8 26 2a 00 00       	call   80102c4e <iderw>
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
80100243:	68 b7 a0 10 80       	push   $0x8010a0b7
80100248:	e8 19 03 00 00       	call   80100566 <panic>

  acquire(&bcache.lock);
8010024d:	83 ec 0c             	sub    $0xc,%esp
80100250:	68 a0 e6 10 80       	push   $0x8010e6a0
80100255:	e8 86 66 00 00       	call   801068e0 <acquire>
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
801002b9:	e8 6d 55 00 00       	call   8010582b <wakeup>
801002be:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c1:	83 ec 0c             	sub    $0xc,%esp
801002c4:	68 a0 e6 10 80       	push   $0x8010e6a0
801002c9:	e8 79 66 00 00       	call   80106947 <release>
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
801003e2:	e8 f9 64 00 00       	call   801068e0 <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 be a0 10 80       	push   $0x8010a0be
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
801004cd:	c7 45 ec c7 a0 10 80 	movl   $0x8010a0c7,-0x14(%ebp)
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
8010055b:	e8 e7 63 00 00       	call   80106947 <release>
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
8010058b:	68 ce a0 10 80       	push   $0x8010a0ce
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
801005aa:	68 dd a0 10 80       	push   $0x8010a0dd
801005af:	e8 12 fe ff ff       	call   801003c6 <cprintf>
801005b4:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005b7:	83 ec 08             	sub    $0x8,%esp
801005ba:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005bd:	50                   	push   %eax
801005be:	8d 45 08             	lea    0x8(%ebp),%eax
801005c1:	50                   	push   %eax
801005c2:	e8 d2 63 00 00       	call   80106999 <getcallerpcs>
801005c7:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005d1:	eb 1c                	jmp    801005ef <panic+0x89>
    cprintf(" %p", pcs[i]);
801005d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005d6:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005da:	83 ec 08             	sub    $0x8,%esp
801005dd:	50                   	push   %eax
801005de:	68 df a0 10 80       	push   $0x8010a0df
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
801006ca:	68 e3 a0 10 80       	push   $0x8010a0e3
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
801006f7:	e8 06 65 00 00       	call   80106c02 <memmove>
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
80100721:	e8 1d 64 00 00       	call   80106b43 <memset>
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
801007b6:	e8 63 7f 00 00       	call   8010871e <uartputc>
801007bb:	83 c4 10             	add    $0x10,%esp
801007be:	83 ec 0c             	sub    $0xc,%esp
801007c1:	6a 20                	push   $0x20
801007c3:	e8 56 7f 00 00       	call   8010871e <uartputc>
801007c8:	83 c4 10             	add    $0x10,%esp
801007cb:	83 ec 0c             	sub    $0xc,%esp
801007ce:	6a 08                	push   $0x8
801007d0:	e8 49 7f 00 00       	call   8010871e <uartputc>
801007d5:	83 c4 10             	add    $0x10,%esp
801007d8:	eb 0e                	jmp    801007e8 <consputc+0x56>
  } else
    uartputc(c);
801007da:	83 ec 0c             	sub    $0xc,%esp
801007dd:	ff 75 08             	pushl  0x8(%ebp)
801007e0:	e8 39 7f 00 00       	call   8010871e <uartputc>
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
8010082a:	e8 b1 60 00 00       	call   801068e0 <acquire>
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
801009d4:	e8 52 4e 00 00       	call   8010582b <wakeup>
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
801009f7:	e8 4b 5f 00 00       	call   80106947 <release>
801009fc:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100a03:	74 05                	je     80100a0a <consoleintr+0x211>
    procdump();  // now call procdump() wo. cons.lock held
80100a05:	e8 10 50 00 00       	call   80105a1a <procdump>
  }
  if (f) {
80100a0a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100a0e:	74 05                	je     80100a15 <consoleintr+0x21c>
    free_length();
80100a10:	e8 7d 54 00 00       	call   80105e92 <free_length>
  }
  if (r) {
80100a15:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80100a19:	74 05                	je     80100a20 <consoleintr+0x227>
    display_ready();
80100a1b:	e8 fe 54 00 00       	call   80105f1e <display_ready>
  }
  if (s) {
80100a20:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100a24:	74 05                	je     80100a2b <consoleintr+0x232>
    display_sleep();
80100a26:	e8 e6 55 00 00       	call   80106011 <display_sleep>
  }
  if (z) {
80100a2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100a2f:	74 05                	je     80100a36 <consoleintr+0x23d>
    display_zombie();
80100a31:	e8 95 56 00 00       	call   801060cb <display_zombie>
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
80100a5b:	e8 80 5e 00 00       	call   801068e0 <acquire>
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
80100a7d:	e8 c5 5e 00 00       	call   80106947 <release>
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
80100aaa:	e8 a3 4b 00 00       	call   80105652 <sleep>
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
80100b28:	e8 1a 5e 00 00       	call   80106947 <release>
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
80100b66:	e8 75 5d 00 00       	call   801068e0 <acquire>
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
80100ba8:	e8 9a 5d 00 00       	call   80106947 <release>
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
80100bcc:	68 f6 a0 10 80       	push   $0x8010a0f6
80100bd1:	68 00 d6 10 80       	push   $0x8010d600
80100bd6:	e8 e3 5c 00 00       	call   801068be <initlock>
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
80100c01:	e8 66 36 00 00       	call   8010426c <picenable>
80100c06:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100c09:	83 ec 08             	sub    $0x8,%esp
80100c0c:	6a 00                	push   $0x0
80100c0e:	6a 01                	push   $0x1
80100c10:	e8 06 22 00 00       	call   80102e1b <ioapicenable>
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
80100c24:	e8 65 2c 00 00       	call   8010388e <begin_op>
  if((ip = namei(path)) == 0){
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	ff 75 08             	pushl  0x8(%ebp)
80100c2f:	e8 c1 1a 00 00       	call   801026f5 <namei>
80100c34:	83 c4 10             	add    $0x10,%esp
80100c37:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100c3a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100c3e:	75 0f                	jne    80100c4f <exec+0x34>
    end_op();
80100c40:	e8 d5 2c 00 00       	call   8010391a <end_op>
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
80100d18:	e8 56 8b 00 00       	call   80109873 <setupkvm>
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
80100d9e:	e8 77 8e 00 00       	call   80109c1a <allocuvm>
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
80100dd1:	e8 6d 8d 00 00       	call   80109b43 <loaduvm>
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
80100e12:	e8 03 2b 00 00       	call   8010391a <end_op>
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
80100e40:	e8 d5 8d 00 00       	call   80109c1a <allocuvm>
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
80100e64:	e8 d7 8f 00 00       	call   80109e40 <clearpteu>
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
80100e9d:	e8 ee 5e 00 00       	call   80106d90 <strlen>
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
80100eca:	e8 c1 5e 00 00       	call   80106d90 <strlen>
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
80100ef0:	e8 02 91 00 00       	call   80109ff7 <copyout>
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
80100f8c:	e8 66 90 00 00       	call   80109ff7 <copyout>
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
80100fdd:	e8 64 5d 00 00       	call   80106d46 <safestrcpy>
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
80101057:	e8 fe 88 00 00       	call   8010995a <switchuvm>
8010105c:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
8010105f:	83 ec 0c             	sub    $0xc,%esp
80101062:	ff 75 cc             	pushl  -0x34(%ebp)
80101065:	e8 36 8d 00 00       	call   80109da0 <freevm>
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
801010a2:	e8 f9 8c 00 00       	call   80109da0 <freevm>
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
801010be:	e8 57 28 00 00       	call   8010391a <end_op>
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
801010d3:	68 fe a0 10 80       	push   $0x8010a0fe
801010d8:	68 60 28 11 80       	push   $0x80112860
801010dd:	e8 dc 57 00 00       	call   801068be <initlock>
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
801010f6:	e8 e5 57 00 00       	call   801068e0 <acquire>
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
80101123:	e8 1f 58 00 00       	call   80106947 <release>
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
80101146:	e8 fc 57 00 00       	call   80106947 <release>
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
80101163:	e8 78 57 00 00       	call   801068e0 <acquire>
80101168:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
8010116b:	8b 45 08             	mov    0x8(%ebp),%eax
8010116e:	8b 40 04             	mov    0x4(%eax),%eax
80101171:	85 c0                	test   %eax,%eax
80101173:	7f 0d                	jg     80101182 <filedup+0x2d>
    panic("filedup");
80101175:	83 ec 0c             	sub    $0xc,%esp
80101178:	68 05 a1 10 80       	push   $0x8010a105
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
80101199:	e8 a9 57 00 00       	call   80106947 <release>
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
801011b4:	e8 27 57 00 00       	call   801068e0 <acquire>
801011b9:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
801011bc:	8b 45 08             	mov    0x8(%ebp),%eax
801011bf:	8b 40 04             	mov    0x4(%eax),%eax
801011c2:	85 c0                	test   %eax,%eax
801011c4:	7f 0d                	jg     801011d3 <fileclose+0x2d>
    panic("fileclose");
801011c6:	83 ec 0c             	sub    $0xc,%esp
801011c9:	68 0d a1 10 80       	push   $0x8010a10d
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
801011f4:	e8 4e 57 00 00       	call   80106947 <release>
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
80101242:	e8 00 57 00 00       	call   80106947 <release>
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
80101261:	e8 6f 32 00 00       	call   801044d5 <pipeclose>
80101266:	83 c4 10             	add    $0x10,%esp
80101269:	eb 21                	jmp    8010128c <fileclose+0xe6>
  else if(ff.type == FD_INODE){
8010126b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010126e:	83 f8 02             	cmp    $0x2,%eax
80101271:	75 19                	jne    8010128c <fileclose+0xe6>
    begin_op();
80101273:	e8 16 26 00 00       	call   8010388e <begin_op>
    iput(ff.ip);
80101278:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010127b:	83 ec 0c             	sub    $0xc,%esp
8010127e:	50                   	push   %eax
8010127f:	e8 5b 0a 00 00       	call   80101cdf <iput>
80101284:	83 c4 10             	add    $0x10,%esp
    end_op();
80101287:	e8 8e 26 00 00       	call   8010391a <end_op>
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
8010131a:	e8 5e 33 00 00       	call   8010467d <piperead>
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
80101391:	68 17 a1 10 80       	push   $0x8010a117
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
801013d3:	e8 a7 31 00 00       	call   8010457f <pipewrite>
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
80101418:	e8 71 24 00 00       	call   8010388e <begin_op>
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
8010147e:	e8 97 24 00 00       	call   8010391a <end_op>

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
80101494:	68 20 a1 10 80       	push   $0x8010a120
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
801014ca:	68 30 a1 10 80       	push   $0x8010a130
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
80101502:	e8 fb 56 00 00       	call   80106c02 <memmove>
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
80101548:	e8 f6 55 00 00       	call   80106b43 <memset>
8010154d:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101550:	83 ec 0c             	sub    $0xc,%esp
80101553:	ff 75 f4             	pushl  -0xc(%ebp)
80101556:	e8 6b 25 00 00       	call   80103ac6 <log_write>
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
8010162a:	e8 97 24 00 00       	call   80103ac6 <log_write>
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
801016af:	68 3c a1 10 80       	push   $0x8010a13c
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
80101742:	68 52 a1 10 80       	push   $0x8010a152
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
8010177a:	e8 47 23 00 00       	call   80103ac6 <log_write>
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
8010179f:	68 65 a1 10 80       	push   $0x8010a165
801017a4:	68 80 32 11 80       	push   $0x80113280
801017a9:	e8 10 51 00 00       	call   801068be <initlock>
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
801017f8:	68 6c a1 10 80       	push   $0x8010a16c
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
80101871:	e8 cd 52 00 00       	call   80106b43 <memset>
80101876:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101879:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010187c:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
80101880:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101883:	83 ec 0c             	sub    $0xc,%esp
80101886:	ff 75 f0             	pushl  -0x10(%ebp)
80101889:	e8 38 22 00 00       	call   80103ac6 <log_write>
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
801018d9:	68 bf a1 10 80       	push   $0x8010a1bf
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
801019a7:	e8 56 52 00 00       	call   80106c02 <memmove>
801019ac:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
801019af:	83 ec 0c             	sub    $0xc,%esp
801019b2:	ff 75 f4             	pushl  -0xc(%ebp)
801019b5:	e8 0c 21 00 00       	call   80103ac6 <log_write>
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
801019dc:	e8 ff 4e 00 00       	call   801068e0 <acquire>
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
80101a2a:	e8 18 4f 00 00       	call   80106947 <release>
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
80101a63:	68 d1 a1 10 80       	push   $0x8010a1d1
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
80101aa0:	e8 a2 4e 00 00       	call   80106947 <release>
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
80101abb:	e8 20 4e 00 00       	call   801068e0 <acquire>
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
80101ada:	e8 68 4e 00 00       	call   80106947 <release>
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
80101b00:	68 e1 a1 10 80       	push   $0x8010a1e1
80101b05:	e8 5c ea ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101b0a:	83 ec 0c             	sub    $0xc,%esp
80101b0d:	68 80 32 11 80       	push   $0x80113280
80101b12:	e8 c9 4d 00 00       	call   801068e0 <acquire>
80101b17:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
80101b1a:	eb 13                	jmp    80101b2f <ilock+0x48>
    sleep(ip, &icache.lock);
80101b1c:	83 ec 08             	sub    $0x8,%esp
80101b1f:	68 80 32 11 80       	push   $0x80113280
80101b24:	ff 75 08             	pushl  0x8(%ebp)
80101b27:	e8 26 3b 00 00       	call   80105652 <sleep>
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
80101b55:	e8 ed 4d 00 00       	call   80106947 <release>
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
80101c2a:	e8 d3 4f 00 00       	call   80106c02 <memmove>
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
80101c60:	68 e7 a1 10 80       	push   $0x8010a1e7
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
80101c93:	68 f6 a1 10 80       	push   $0x8010a1f6
80101c98:	e8 c9 e8 ff ff       	call   80100566 <panic>

  acquire(&icache.lock);
80101c9d:	83 ec 0c             	sub    $0xc,%esp
80101ca0:	68 80 32 11 80       	push   $0x80113280
80101ca5:	e8 36 4c 00 00       	call   801068e0 <acquire>
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
80101cc4:	e8 62 3b 00 00       	call   8010582b <wakeup>
80101cc9:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101ccc:	83 ec 0c             	sub    $0xc,%esp
80101ccf:	68 80 32 11 80       	push   $0x80113280
80101cd4:	e8 6e 4c 00 00       	call   80106947 <release>
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
80101ced:	e8 ee 4b 00 00       	call   801068e0 <acquire>
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
80101d35:	68 fe a1 10 80       	push   $0x8010a1fe
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
80101d58:	e8 ea 4b 00 00       	call   80106947 <release>
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
80101d8d:	e8 4e 4b 00 00       	call   801068e0 <acquire>
80101d92:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101d95:	8b 45 08             	mov    0x8(%ebp),%eax
80101d98:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101d9f:	83 ec 0c             	sub    $0xc,%esp
80101da2:	ff 75 08             	pushl  0x8(%ebp)
80101da5:	e8 81 3a 00 00       	call   8010582b <wakeup>
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
80101dc4:	e8 7e 4b 00 00       	call   80106947 <release>
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
80101ee6:	e8 db 1b 00 00       	call   80103ac6 <log_write>
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
80101f04:	68 08 a2 10 80       	push   $0x8010a208
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
801021c3:	e8 3a 4a 00 00       	call   80106c02 <memmove>
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
80102315:	e8 e8 48 00 00       	call   80106c02 <memmove>
8010231a:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
8010231d:	83 ec 0c             	sub    $0xc,%esp
80102320:	ff 75 f0             	pushl  -0x10(%ebp)
80102323:	e8 9e 17 00 00       	call   80103ac6 <log_write>
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
80102395:	e8 fe 48 00 00       	call   80106c98 <strncmp>
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
801023b5:	68 1b a2 10 80       	push   $0x8010a21b
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
801023e4:	68 2d a2 10 80       	push   $0x8010a22d
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
801024b9:	68 2d a2 10 80       	push   $0x8010a22d
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
801024f4:	e8 f5 47 00 00       	call   80106cee <strncpy>
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
80102520:	68 3a a2 10 80       	push   $0x8010a23a
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
80102596:	e8 67 46 00 00       	call   80106c02 <memmove>
8010259b:	83 c4 10             	add    $0x10,%esp
8010259e:	eb 26                	jmp    801025c6 <skipelem+0x95>
  else {
    memmove(name, s, len);
801025a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801025a3:	83 ec 04             	sub    $0x4,%esp
801025a6:	50                   	push   %eax
801025a7:	ff 75 f4             	pushl  -0xc(%ebp)
801025aa:	ff 75 0c             	pushl  0xc(%ebp)
801025ad:	e8 50 46 00 00       	call   80106c02 <memmove>
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
80102732:	e8 57 11 00 00       	call   8010388e <begin_op>
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
8010274e:	e8 c7 11 00 00       	call   8010391a <end_op>
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
80102790:	e8 85 11 00 00       	call   8010391a <end_op>
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
801027a2:	e8 e7 10 00 00       	call   8010388e <begin_op>
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
801027be:	e8 57 11 00 00       	call   8010391a <end_op>
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
80102800:	e8 15 11 00 00       	call   8010391a <end_op>
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
80102812:	e8 77 10 00 00       	call   8010388e <begin_op>
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
8010282e:	e8 e7 10 00 00       	call   8010391a <end_op>
    return -1;
80102833:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102838:	eb 64                	jmp    8010289e <chmod_helper+0x92>
  } else {
    ilock(in);
8010283a:	83 ec 0c             	sub    $0xc,%esp
8010283d:	ff 75 f4             	pushl  -0xc(%ebp)
80102840:	e8 a2 f2 ff ff       	call   80101ae7 <ilock>
80102845:	83 c4 10             	add    $0x10,%esp
    if (in->mode.as_int == mode) {
80102848:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010284b:	8b 50 1c             	mov    0x1c(%eax),%edx
8010284e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102851:	39 c2                	cmp    %eax,%edx
80102853:	75 1a                	jne    8010286f <chmod_helper+0x63>
      iunlock(in);
80102855:	83 ec 0c             	sub    $0xc,%esp
80102858:	ff 75 f4             	pushl  -0xc(%ebp)
8010285b:	e8 0d f4 ff ff       	call   80101c6d <iunlock>
80102860:	83 c4 10             	add    $0x10,%esp
      end_op();
80102863:	e8 b2 10 00 00       	call   8010391a <end_op>
      return -1;
80102868:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010286d:	eb 2f                	jmp    8010289e <chmod_helper+0x92>
    } else {
      in->mode.as_int = mode; 
8010286f:	8b 55 0c             	mov    0xc(%ebp),%edx
80102872:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102875:	89 50 1c             	mov    %edx,0x1c(%eax)
      iupdate(in);
80102878:	83 ec 0c             	sub    $0xc,%esp
8010287b:	ff 75 f4             	pushl  -0xc(%ebp)
8010287e:	e8 62 f0 ff ff       	call   801018e5 <iupdate>
80102883:	83 c4 10             	add    $0x10,%esp
    }
  }
  iunlock(in);
80102886:	83 ec 0c             	sub    $0xc,%esp
80102889:	ff 75 f4             	pushl  -0xc(%ebp)
8010288c:	e8 dc f3 ff ff       	call   80101c6d <iunlock>
80102891:	83 c4 10             	add    $0x10,%esp
  end_op();
80102894:	e8 81 10 00 00       	call   8010391a <end_op>
  return 0;
80102899:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010289e:	c9                   	leave  
8010289f:	c3                   	ret    

801028a0 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801028a0:	55                   	push   %ebp
801028a1:	89 e5                	mov    %esp,%ebp
801028a3:	83 ec 14             	sub    $0x14,%esp
801028a6:	8b 45 08             	mov    0x8(%ebp),%eax
801028a9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ad:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801028b1:	89 c2                	mov    %eax,%edx
801028b3:	ec                   	in     (%dx),%al
801028b4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801028b7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801028bb:	c9                   	leave  
801028bc:	c3                   	ret    

801028bd <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801028bd:	55                   	push   %ebp
801028be:	89 e5                	mov    %esp,%ebp
801028c0:	57                   	push   %edi
801028c1:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801028c2:	8b 55 08             	mov    0x8(%ebp),%edx
801028c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801028c8:	8b 45 10             	mov    0x10(%ebp),%eax
801028cb:	89 cb                	mov    %ecx,%ebx
801028cd:	89 df                	mov    %ebx,%edi
801028cf:	89 c1                	mov    %eax,%ecx
801028d1:	fc                   	cld    
801028d2:	f3 6d                	rep insl (%dx),%es:(%edi)
801028d4:	89 c8                	mov    %ecx,%eax
801028d6:	89 fb                	mov    %edi,%ebx
801028d8:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801028db:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801028de:	90                   	nop
801028df:	5b                   	pop    %ebx
801028e0:	5f                   	pop    %edi
801028e1:	5d                   	pop    %ebp
801028e2:	c3                   	ret    

801028e3 <outb>:

static inline void
outb(ushort port, uchar data)
{
801028e3:	55                   	push   %ebp
801028e4:	89 e5                	mov    %esp,%ebp
801028e6:	83 ec 08             	sub    $0x8,%esp
801028e9:	8b 55 08             	mov    0x8(%ebp),%edx
801028ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801028ef:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801028f3:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028f6:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801028fa:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801028fe:	ee                   	out    %al,(%dx)
}
801028ff:	90                   	nop
80102900:	c9                   	leave  
80102901:	c3                   	ret    

80102902 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
80102902:	55                   	push   %ebp
80102903:	89 e5                	mov    %esp,%ebp
80102905:	56                   	push   %esi
80102906:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
80102907:	8b 55 08             	mov    0x8(%ebp),%edx
8010290a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010290d:	8b 45 10             	mov    0x10(%ebp),%eax
80102910:	89 cb                	mov    %ecx,%ebx
80102912:	89 de                	mov    %ebx,%esi
80102914:	89 c1                	mov    %eax,%ecx
80102916:	fc                   	cld    
80102917:	f3 6f                	rep outsl %ds:(%esi),(%dx)
80102919:	89 c8                	mov    %ecx,%eax
8010291b:	89 f3                	mov    %esi,%ebx
8010291d:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102920:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102923:	90                   	nop
80102924:	5b                   	pop    %ebx
80102925:	5e                   	pop    %esi
80102926:	5d                   	pop    %ebp
80102927:	c3                   	ret    

80102928 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102928:	55                   	push   %ebp
80102929:	89 e5                	mov    %esp,%ebp
8010292b:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010292e:	90                   	nop
8010292f:	68 f7 01 00 00       	push   $0x1f7
80102934:	e8 67 ff ff ff       	call   801028a0 <inb>
80102939:	83 c4 04             	add    $0x4,%esp
8010293c:	0f b6 c0             	movzbl %al,%eax
8010293f:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102942:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102945:	25 c0 00 00 00       	and    $0xc0,%eax
8010294a:	83 f8 40             	cmp    $0x40,%eax
8010294d:	75 e0                	jne    8010292f <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010294f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102953:	74 11                	je     80102966 <idewait+0x3e>
80102955:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102958:	83 e0 21             	and    $0x21,%eax
8010295b:	85 c0                	test   %eax,%eax
8010295d:	74 07                	je     80102966 <idewait+0x3e>
    return -1;
8010295f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102964:	eb 05                	jmp    8010296b <idewait+0x43>
  return 0;
80102966:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010296b:	c9                   	leave  
8010296c:	c3                   	ret    

8010296d <ideinit>:

void
ideinit(void)
{
8010296d:	55                   	push   %ebp
8010296e:	89 e5                	mov    %esp,%ebp
80102970:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
80102973:	83 ec 08             	sub    $0x8,%esp
80102976:	68 42 a2 10 80       	push   $0x8010a242
8010297b:	68 40 d6 10 80       	push   $0x8010d640
80102980:	e8 39 3f 00 00       	call   801068be <initlock>
80102985:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
80102988:	83 ec 0c             	sub    $0xc,%esp
8010298b:	6a 0e                	push   $0xe
8010298d:	e8 da 18 00 00       	call   8010426c <picenable>
80102992:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
80102995:	a1 80 49 11 80       	mov    0x80114980,%eax
8010299a:	83 e8 01             	sub    $0x1,%eax
8010299d:	83 ec 08             	sub    $0x8,%esp
801029a0:	50                   	push   %eax
801029a1:	6a 0e                	push   $0xe
801029a3:	e8 73 04 00 00       	call   80102e1b <ioapicenable>
801029a8:	83 c4 10             	add    $0x10,%esp
  idewait(0);
801029ab:	83 ec 0c             	sub    $0xc,%esp
801029ae:	6a 00                	push   $0x0
801029b0:	e8 73 ff ff ff       	call   80102928 <idewait>
801029b5:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
801029b8:	83 ec 08             	sub    $0x8,%esp
801029bb:	68 f0 00 00 00       	push   $0xf0
801029c0:	68 f6 01 00 00       	push   $0x1f6
801029c5:	e8 19 ff ff ff       	call   801028e3 <outb>
801029ca:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
801029cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801029d4:	eb 24                	jmp    801029fa <ideinit+0x8d>
    if(inb(0x1f7) != 0){
801029d6:	83 ec 0c             	sub    $0xc,%esp
801029d9:	68 f7 01 00 00       	push   $0x1f7
801029de:	e8 bd fe ff ff       	call   801028a0 <inb>
801029e3:	83 c4 10             	add    $0x10,%esp
801029e6:	84 c0                	test   %al,%al
801029e8:	74 0c                	je     801029f6 <ideinit+0x89>
      havedisk1 = 1;
801029ea:	c7 05 78 d6 10 80 01 	movl   $0x1,0x8010d678
801029f1:	00 00 00 
      break;
801029f4:	eb 0d                	jmp    80102a03 <ideinit+0x96>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801029f6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801029fa:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
80102a01:	7e d3                	jle    801029d6 <ideinit+0x69>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
80102a03:	83 ec 08             	sub    $0x8,%esp
80102a06:	68 e0 00 00 00       	push   $0xe0
80102a0b:	68 f6 01 00 00       	push   $0x1f6
80102a10:	e8 ce fe ff ff       	call   801028e3 <outb>
80102a15:	83 c4 10             	add    $0x10,%esp
}
80102a18:	90                   	nop
80102a19:	c9                   	leave  
80102a1a:	c3                   	ret    

80102a1b <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102a1b:	55                   	push   %ebp
80102a1c:	89 e5                	mov    %esp,%ebp
80102a1e:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
80102a21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102a25:	75 0d                	jne    80102a34 <idestart+0x19>
    panic("idestart");
80102a27:	83 ec 0c             	sub    $0xc,%esp
80102a2a:	68 46 a2 10 80       	push   $0x8010a246
80102a2f:	e8 32 db ff ff       	call   80100566 <panic>
  if(b->blockno >= FSSIZE)
80102a34:	8b 45 08             	mov    0x8(%ebp),%eax
80102a37:	8b 40 08             	mov    0x8(%eax),%eax
80102a3a:	3d cf 07 00 00       	cmp    $0x7cf,%eax
80102a3f:	76 0d                	jbe    80102a4e <idestart+0x33>
    panic("incorrect blockno");
80102a41:	83 ec 0c             	sub    $0xc,%esp
80102a44:	68 4f a2 10 80       	push   $0x8010a24f
80102a49:	e8 18 db ff ff       	call   80100566 <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
80102a4e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102a55:	8b 45 08             	mov    0x8(%ebp),%eax
80102a58:	8b 50 08             	mov    0x8(%eax),%edx
80102a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a5e:	0f af c2             	imul   %edx,%eax
80102a61:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102a64:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102a68:	7e 0d                	jle    80102a77 <idestart+0x5c>
80102a6a:	83 ec 0c             	sub    $0xc,%esp
80102a6d:	68 46 a2 10 80       	push   $0x8010a246
80102a72:	e8 ef da ff ff       	call   80100566 <panic>
  
  idewait(0);
80102a77:	83 ec 0c             	sub    $0xc,%esp
80102a7a:	6a 00                	push   $0x0
80102a7c:	e8 a7 fe ff ff       	call   80102928 <idewait>
80102a81:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102a84:	83 ec 08             	sub    $0x8,%esp
80102a87:	6a 00                	push   $0x0
80102a89:	68 f6 03 00 00       	push   $0x3f6
80102a8e:	e8 50 fe ff ff       	call   801028e3 <outb>
80102a93:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a99:	0f b6 c0             	movzbl %al,%eax
80102a9c:	83 ec 08             	sub    $0x8,%esp
80102a9f:	50                   	push   %eax
80102aa0:	68 f2 01 00 00       	push   $0x1f2
80102aa5:	e8 39 fe ff ff       	call   801028e3 <outb>
80102aaa:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
80102aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102ab0:	0f b6 c0             	movzbl %al,%eax
80102ab3:	83 ec 08             	sub    $0x8,%esp
80102ab6:	50                   	push   %eax
80102ab7:	68 f3 01 00 00       	push   $0x1f3
80102abc:	e8 22 fe ff ff       	call   801028e3 <outb>
80102ac1:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102ac7:	c1 f8 08             	sar    $0x8,%eax
80102aca:	0f b6 c0             	movzbl %al,%eax
80102acd:	83 ec 08             	sub    $0x8,%esp
80102ad0:	50                   	push   %eax
80102ad1:	68 f4 01 00 00       	push   $0x1f4
80102ad6:	e8 08 fe ff ff       	call   801028e3 <outb>
80102adb:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
80102ade:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102ae1:	c1 f8 10             	sar    $0x10,%eax
80102ae4:	0f b6 c0             	movzbl %al,%eax
80102ae7:	83 ec 08             	sub    $0x8,%esp
80102aea:	50                   	push   %eax
80102aeb:	68 f5 01 00 00       	push   $0x1f5
80102af0:	e8 ee fd ff ff       	call   801028e3 <outb>
80102af5:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80102af8:	8b 45 08             	mov    0x8(%ebp),%eax
80102afb:	8b 40 04             	mov    0x4(%eax),%eax
80102afe:	83 e0 01             	and    $0x1,%eax
80102b01:	c1 e0 04             	shl    $0x4,%eax
80102b04:	89 c2                	mov    %eax,%edx
80102b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102b09:	c1 f8 18             	sar    $0x18,%eax
80102b0c:	83 e0 0f             	and    $0xf,%eax
80102b0f:	09 d0                	or     %edx,%eax
80102b11:	83 c8 e0             	or     $0xffffffe0,%eax
80102b14:	0f b6 c0             	movzbl %al,%eax
80102b17:	83 ec 08             	sub    $0x8,%esp
80102b1a:	50                   	push   %eax
80102b1b:	68 f6 01 00 00       	push   $0x1f6
80102b20:	e8 be fd ff ff       	call   801028e3 <outb>
80102b25:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
80102b28:	8b 45 08             	mov    0x8(%ebp),%eax
80102b2b:	8b 00                	mov    (%eax),%eax
80102b2d:	83 e0 04             	and    $0x4,%eax
80102b30:	85 c0                	test   %eax,%eax
80102b32:	74 30                	je     80102b64 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102b34:	83 ec 08             	sub    $0x8,%esp
80102b37:	6a 30                	push   $0x30
80102b39:	68 f7 01 00 00       	push   $0x1f7
80102b3e:	e8 a0 fd ff ff       	call   801028e3 <outb>
80102b43:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102b46:	8b 45 08             	mov    0x8(%ebp),%eax
80102b49:	83 c0 18             	add    $0x18,%eax
80102b4c:	83 ec 04             	sub    $0x4,%esp
80102b4f:	68 80 00 00 00       	push   $0x80
80102b54:	50                   	push   %eax
80102b55:	68 f0 01 00 00       	push   $0x1f0
80102b5a:	e8 a3 fd ff ff       	call   80102902 <outsl>
80102b5f:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102b62:	eb 12                	jmp    80102b76 <idestart+0x15b>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, IDE_CMD_WRITE);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102b64:	83 ec 08             	sub    $0x8,%esp
80102b67:	6a 20                	push   $0x20
80102b69:	68 f7 01 00 00       	push   $0x1f7
80102b6e:	e8 70 fd ff ff       	call   801028e3 <outb>
80102b73:	83 c4 10             	add    $0x10,%esp
  }
}
80102b76:	90                   	nop
80102b77:	c9                   	leave  
80102b78:	c3                   	ret    

80102b79 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102b79:	55                   	push   %ebp
80102b7a:	89 e5                	mov    %esp,%ebp
80102b7c:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102b7f:	83 ec 0c             	sub    $0xc,%esp
80102b82:	68 40 d6 10 80       	push   $0x8010d640
80102b87:	e8 54 3d 00 00       	call   801068e0 <acquire>
80102b8c:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102b8f:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102b94:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102b97:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b9b:	75 15                	jne    80102bb2 <ideintr+0x39>
    release(&idelock);
80102b9d:	83 ec 0c             	sub    $0xc,%esp
80102ba0:	68 40 d6 10 80       	push   $0x8010d640
80102ba5:	e8 9d 3d 00 00       	call   80106947 <release>
80102baa:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
80102bad:	e9 9a 00 00 00       	jmp    80102c4c <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bb5:	8b 40 14             	mov    0x14(%eax),%eax
80102bb8:	a3 74 d6 10 80       	mov    %eax,0x8010d674

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bc0:	8b 00                	mov    (%eax),%eax
80102bc2:	83 e0 04             	and    $0x4,%eax
80102bc5:	85 c0                	test   %eax,%eax
80102bc7:	75 2d                	jne    80102bf6 <ideintr+0x7d>
80102bc9:	83 ec 0c             	sub    $0xc,%esp
80102bcc:	6a 01                	push   $0x1
80102bce:	e8 55 fd ff ff       	call   80102928 <idewait>
80102bd3:	83 c4 10             	add    $0x10,%esp
80102bd6:	85 c0                	test   %eax,%eax
80102bd8:	78 1c                	js     80102bf6 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
80102bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bdd:	83 c0 18             	add    $0x18,%eax
80102be0:	83 ec 04             	sub    $0x4,%esp
80102be3:	68 80 00 00 00       	push   $0x80
80102be8:	50                   	push   %eax
80102be9:	68 f0 01 00 00       	push   $0x1f0
80102bee:	e8 ca fc ff ff       	call   801028bd <insl>
80102bf3:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80102bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bf9:	8b 00                	mov    (%eax),%eax
80102bfb:	83 c8 02             	or     $0x2,%eax
80102bfe:	89 c2                	mov    %eax,%edx
80102c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c03:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
80102c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c08:	8b 00                	mov    (%eax),%eax
80102c0a:	83 e0 fb             	and    $0xfffffffb,%eax
80102c0d:	89 c2                	mov    %eax,%edx
80102c0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c12:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80102c14:	83 ec 0c             	sub    $0xc,%esp
80102c17:	ff 75 f4             	pushl  -0xc(%ebp)
80102c1a:	e8 0c 2c 00 00       	call   8010582b <wakeup>
80102c1f:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
80102c22:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102c27:	85 c0                	test   %eax,%eax
80102c29:	74 11                	je     80102c3c <ideintr+0xc3>
    idestart(idequeue);
80102c2b:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102c30:	83 ec 0c             	sub    $0xc,%esp
80102c33:	50                   	push   %eax
80102c34:	e8 e2 fd ff ff       	call   80102a1b <idestart>
80102c39:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
80102c3c:	83 ec 0c             	sub    $0xc,%esp
80102c3f:	68 40 d6 10 80       	push   $0x8010d640
80102c44:	e8 fe 3c 00 00       	call   80106947 <release>
80102c49:	83 c4 10             	add    $0x10,%esp
}
80102c4c:	c9                   	leave  
80102c4d:	c3                   	ret    

80102c4e <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102c4e:	55                   	push   %ebp
80102c4f:	89 e5                	mov    %esp,%ebp
80102c51:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102c54:	8b 45 08             	mov    0x8(%ebp),%eax
80102c57:	8b 00                	mov    (%eax),%eax
80102c59:	83 e0 01             	and    $0x1,%eax
80102c5c:	85 c0                	test   %eax,%eax
80102c5e:	75 0d                	jne    80102c6d <iderw+0x1f>
    panic("iderw: buf not busy");
80102c60:	83 ec 0c             	sub    $0xc,%esp
80102c63:	68 61 a2 10 80       	push   $0x8010a261
80102c68:	e8 f9 d8 ff ff       	call   80100566 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80102c6d:	8b 45 08             	mov    0x8(%ebp),%eax
80102c70:	8b 00                	mov    (%eax),%eax
80102c72:	83 e0 06             	and    $0x6,%eax
80102c75:	83 f8 02             	cmp    $0x2,%eax
80102c78:	75 0d                	jne    80102c87 <iderw+0x39>
    panic("iderw: nothing to do");
80102c7a:	83 ec 0c             	sub    $0xc,%esp
80102c7d:	68 75 a2 10 80       	push   $0x8010a275
80102c82:	e8 df d8 ff ff       	call   80100566 <panic>
  if(b->dev != 0 && !havedisk1)
80102c87:	8b 45 08             	mov    0x8(%ebp),%eax
80102c8a:	8b 40 04             	mov    0x4(%eax),%eax
80102c8d:	85 c0                	test   %eax,%eax
80102c8f:	74 16                	je     80102ca7 <iderw+0x59>
80102c91:	a1 78 d6 10 80       	mov    0x8010d678,%eax
80102c96:	85 c0                	test   %eax,%eax
80102c98:	75 0d                	jne    80102ca7 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
80102c9a:	83 ec 0c             	sub    $0xc,%esp
80102c9d:	68 8a a2 10 80       	push   $0x8010a28a
80102ca2:	e8 bf d8 ff ff       	call   80100566 <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102ca7:	83 ec 0c             	sub    $0xc,%esp
80102caa:	68 40 d6 10 80       	push   $0x8010d640
80102caf:	e8 2c 3c 00 00       	call   801068e0 <acquire>
80102cb4:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102cb7:	8b 45 08             	mov    0x8(%ebp),%eax
80102cba:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102cc1:	c7 45 f4 74 d6 10 80 	movl   $0x8010d674,-0xc(%ebp)
80102cc8:	eb 0b                	jmp    80102cd5 <iderw+0x87>
80102cca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ccd:	8b 00                	mov    (%eax),%eax
80102ccf:	83 c0 14             	add    $0x14,%eax
80102cd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102cd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cd8:	8b 00                	mov    (%eax),%eax
80102cda:	85 c0                	test   %eax,%eax
80102cdc:	75 ec                	jne    80102cca <iderw+0x7c>
    ;
  *pp = b;
80102cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80102ce4:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
80102ce6:	a1 74 d6 10 80       	mov    0x8010d674,%eax
80102ceb:	3b 45 08             	cmp    0x8(%ebp),%eax
80102cee:	75 23                	jne    80102d13 <iderw+0xc5>
    idestart(b);
80102cf0:	83 ec 0c             	sub    $0xc,%esp
80102cf3:	ff 75 08             	pushl  0x8(%ebp)
80102cf6:	e8 20 fd ff ff       	call   80102a1b <idestart>
80102cfb:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102cfe:	eb 13                	jmp    80102d13 <iderw+0xc5>
    sleep(b, &idelock);
80102d00:	83 ec 08             	sub    $0x8,%esp
80102d03:	68 40 d6 10 80       	push   $0x8010d640
80102d08:	ff 75 08             	pushl  0x8(%ebp)
80102d0b:	e8 42 29 00 00       	call   80105652 <sleep>
80102d10:	83 c4 10             	add    $0x10,%esp
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102d13:	8b 45 08             	mov    0x8(%ebp),%eax
80102d16:	8b 00                	mov    (%eax),%eax
80102d18:	83 e0 06             	and    $0x6,%eax
80102d1b:	83 f8 02             	cmp    $0x2,%eax
80102d1e:	75 e0                	jne    80102d00 <iderw+0xb2>
    sleep(b, &idelock);
  }

  release(&idelock);
80102d20:	83 ec 0c             	sub    $0xc,%esp
80102d23:	68 40 d6 10 80       	push   $0x8010d640
80102d28:	e8 1a 3c 00 00       	call   80106947 <release>
80102d2d:	83 c4 10             	add    $0x10,%esp
}
80102d30:	90                   	nop
80102d31:	c9                   	leave  
80102d32:	c3                   	ret    

80102d33 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102d33:	55                   	push   %ebp
80102d34:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102d36:	a1 54 42 11 80       	mov    0x80114254,%eax
80102d3b:	8b 55 08             	mov    0x8(%ebp),%edx
80102d3e:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102d40:	a1 54 42 11 80       	mov    0x80114254,%eax
80102d45:	8b 40 10             	mov    0x10(%eax),%eax
}
80102d48:	5d                   	pop    %ebp
80102d49:	c3                   	ret    

80102d4a <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102d4a:	55                   	push   %ebp
80102d4b:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102d4d:	a1 54 42 11 80       	mov    0x80114254,%eax
80102d52:	8b 55 08             	mov    0x8(%ebp),%edx
80102d55:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102d57:	a1 54 42 11 80       	mov    0x80114254,%eax
80102d5c:	8b 55 0c             	mov    0xc(%ebp),%edx
80102d5f:	89 50 10             	mov    %edx,0x10(%eax)
}
80102d62:	90                   	nop
80102d63:	5d                   	pop    %ebp
80102d64:	c3                   	ret    

80102d65 <ioapicinit>:

void
ioapicinit(void)
{
80102d65:	55                   	push   %ebp
80102d66:	89 e5                	mov    %esp,%ebp
80102d68:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102d6b:	a1 84 43 11 80       	mov    0x80114384,%eax
80102d70:	85 c0                	test   %eax,%eax
80102d72:	0f 84 a0 00 00 00    	je     80102e18 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102d78:	c7 05 54 42 11 80 00 	movl   $0xfec00000,0x80114254
80102d7f:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102d82:	6a 01                	push   $0x1
80102d84:	e8 aa ff ff ff       	call   80102d33 <ioapicread>
80102d89:	83 c4 04             	add    $0x4,%esp
80102d8c:	c1 e8 10             	shr    $0x10,%eax
80102d8f:	25 ff 00 00 00       	and    $0xff,%eax
80102d94:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102d97:	6a 00                	push   $0x0
80102d99:	e8 95 ff ff ff       	call   80102d33 <ioapicread>
80102d9e:	83 c4 04             	add    $0x4,%esp
80102da1:	c1 e8 18             	shr    $0x18,%eax
80102da4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102da7:	0f b6 05 80 43 11 80 	movzbl 0x80114380,%eax
80102dae:	0f b6 c0             	movzbl %al,%eax
80102db1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102db4:	74 10                	je     80102dc6 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102db6:	83 ec 0c             	sub    $0xc,%esp
80102db9:	68 a8 a2 10 80       	push   $0x8010a2a8
80102dbe:	e8 03 d6 ff ff       	call   801003c6 <cprintf>
80102dc3:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102dc6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102dcd:	eb 3f                	jmp    80102e0e <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102dcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102dd2:	83 c0 20             	add    $0x20,%eax
80102dd5:	0d 00 00 01 00       	or     $0x10000,%eax
80102dda:	89 c2                	mov    %eax,%edx
80102ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ddf:	83 c0 08             	add    $0x8,%eax
80102de2:	01 c0                	add    %eax,%eax
80102de4:	83 ec 08             	sub    $0x8,%esp
80102de7:	52                   	push   %edx
80102de8:	50                   	push   %eax
80102de9:	e8 5c ff ff ff       	call   80102d4a <ioapicwrite>
80102dee:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102df1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102df4:	83 c0 08             	add    $0x8,%eax
80102df7:	01 c0                	add    %eax,%eax
80102df9:	83 c0 01             	add    $0x1,%eax
80102dfc:	83 ec 08             	sub    $0x8,%esp
80102dff:	6a 00                	push   $0x0
80102e01:	50                   	push   %eax
80102e02:	e8 43 ff ff ff       	call   80102d4a <ioapicwrite>
80102e07:	83 c4 10             	add    $0x10,%esp
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102e0a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102e11:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102e14:	7e b9                	jle    80102dcf <ioapicinit+0x6a>
80102e16:	eb 01                	jmp    80102e19 <ioapicinit+0xb4>
ioapicinit(void)
{
  int i, id, maxintr;

  if(!ismp)
    return;
80102e18:	90                   	nop
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102e19:	c9                   	leave  
80102e1a:	c3                   	ret    

80102e1b <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102e1b:	55                   	push   %ebp
80102e1c:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102e1e:	a1 84 43 11 80       	mov    0x80114384,%eax
80102e23:	85 c0                	test   %eax,%eax
80102e25:	74 39                	je     80102e60 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102e27:	8b 45 08             	mov    0x8(%ebp),%eax
80102e2a:	83 c0 20             	add    $0x20,%eax
80102e2d:	89 c2                	mov    %eax,%edx
80102e2f:	8b 45 08             	mov    0x8(%ebp),%eax
80102e32:	83 c0 08             	add    $0x8,%eax
80102e35:	01 c0                	add    %eax,%eax
80102e37:	52                   	push   %edx
80102e38:	50                   	push   %eax
80102e39:	e8 0c ff ff ff       	call   80102d4a <ioapicwrite>
80102e3e:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102e41:	8b 45 0c             	mov    0xc(%ebp),%eax
80102e44:	c1 e0 18             	shl    $0x18,%eax
80102e47:	89 c2                	mov    %eax,%edx
80102e49:	8b 45 08             	mov    0x8(%ebp),%eax
80102e4c:	83 c0 08             	add    $0x8,%eax
80102e4f:	01 c0                	add    %eax,%eax
80102e51:	83 c0 01             	add    $0x1,%eax
80102e54:	52                   	push   %edx
80102e55:	50                   	push   %eax
80102e56:	e8 ef fe ff ff       	call   80102d4a <ioapicwrite>
80102e5b:	83 c4 08             	add    $0x8,%esp
80102e5e:	eb 01                	jmp    80102e61 <ioapicenable+0x46>

void
ioapicenable(int irq, int cpunum)
{
  if(!ismp)
    return;
80102e60:	90                   	nop
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
80102e61:	c9                   	leave  
80102e62:	c3                   	ret    

80102e63 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102e63:	55                   	push   %ebp
80102e64:	89 e5                	mov    %esp,%ebp
80102e66:	8b 45 08             	mov    0x8(%ebp),%eax
80102e69:	05 00 00 00 80       	add    $0x80000000,%eax
80102e6e:	5d                   	pop    %ebp
80102e6f:	c3                   	ret    

80102e70 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102e76:	83 ec 08             	sub    $0x8,%esp
80102e79:	68 da a2 10 80       	push   $0x8010a2da
80102e7e:	68 60 42 11 80       	push   $0x80114260
80102e83:	e8 36 3a 00 00       	call   801068be <initlock>
80102e88:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102e8b:	c7 05 94 42 11 80 00 	movl   $0x0,0x80114294
80102e92:	00 00 00 
  freerange(vstart, vend);
80102e95:	83 ec 08             	sub    $0x8,%esp
80102e98:	ff 75 0c             	pushl  0xc(%ebp)
80102e9b:	ff 75 08             	pushl  0x8(%ebp)
80102e9e:	e8 2a 00 00 00       	call   80102ecd <freerange>
80102ea3:	83 c4 10             	add    $0x10,%esp
}
80102ea6:	90                   	nop
80102ea7:	c9                   	leave  
80102ea8:	c3                   	ret    

80102ea9 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102ea9:	55                   	push   %ebp
80102eaa:	89 e5                	mov    %esp,%ebp
80102eac:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102eaf:	83 ec 08             	sub    $0x8,%esp
80102eb2:	ff 75 0c             	pushl  0xc(%ebp)
80102eb5:	ff 75 08             	pushl  0x8(%ebp)
80102eb8:	e8 10 00 00 00       	call   80102ecd <freerange>
80102ebd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102ec0:	c7 05 94 42 11 80 01 	movl   $0x1,0x80114294
80102ec7:	00 00 00 
}
80102eca:	90                   	nop
80102ecb:	c9                   	leave  
80102ecc:	c3                   	ret    

80102ecd <freerange>:

void
freerange(void *vstart, void *vend)
{
80102ecd:	55                   	push   %ebp
80102ece:	89 e5                	mov    %esp,%ebp
80102ed0:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102ed3:	8b 45 08             	mov    0x8(%ebp),%eax
80102ed6:	05 ff 0f 00 00       	add    $0xfff,%eax
80102edb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ee3:	eb 15                	jmp    80102efa <freerange+0x2d>
    kfree(p);
80102ee5:	83 ec 0c             	sub    $0xc,%esp
80102ee8:	ff 75 f4             	pushl  -0xc(%ebp)
80102eeb:	e8 1a 00 00 00       	call   80102f0a <kfree>
80102ef0:	83 c4 10             	add    $0x10,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102ef3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102efd:	05 00 10 00 00       	add    $0x1000,%eax
80102f02:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102f05:	76 de                	jbe    80102ee5 <freerange+0x18>
    kfree(p);
}
80102f07:	90                   	nop
80102f08:	c9                   	leave  
80102f09:	c3                   	ret    

80102f0a <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102f0a:	55                   	push   %ebp
80102f0b:	89 e5                	mov    %esp,%ebp
80102f0d:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102f10:	8b 45 08             	mov    0x8(%ebp),%eax
80102f13:	25 ff 0f 00 00       	and    $0xfff,%eax
80102f18:	85 c0                	test   %eax,%eax
80102f1a:	75 1b                	jne    80102f37 <kfree+0x2d>
80102f1c:	81 7d 08 7c 79 11 80 	cmpl   $0x8011797c,0x8(%ebp)
80102f23:	72 12                	jb     80102f37 <kfree+0x2d>
80102f25:	ff 75 08             	pushl  0x8(%ebp)
80102f28:	e8 36 ff ff ff       	call   80102e63 <v2p>
80102f2d:	83 c4 04             	add    $0x4,%esp
80102f30:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102f35:	76 0d                	jbe    80102f44 <kfree+0x3a>
    panic("kfree");
80102f37:	83 ec 0c             	sub    $0xc,%esp
80102f3a:	68 df a2 10 80       	push   $0x8010a2df
80102f3f:	e8 22 d6 ff ff       	call   80100566 <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102f44:	83 ec 04             	sub    $0x4,%esp
80102f47:	68 00 10 00 00       	push   $0x1000
80102f4c:	6a 01                	push   $0x1
80102f4e:	ff 75 08             	pushl  0x8(%ebp)
80102f51:	e8 ed 3b 00 00       	call   80106b43 <memset>
80102f56:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102f59:	a1 94 42 11 80       	mov    0x80114294,%eax
80102f5e:	85 c0                	test   %eax,%eax
80102f60:	74 10                	je     80102f72 <kfree+0x68>
    acquire(&kmem.lock);
80102f62:	83 ec 0c             	sub    $0xc,%esp
80102f65:	68 60 42 11 80       	push   $0x80114260
80102f6a:	e8 71 39 00 00       	call   801068e0 <acquire>
80102f6f:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102f72:	8b 45 08             	mov    0x8(%ebp),%eax
80102f75:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102f78:	8b 15 98 42 11 80    	mov    0x80114298,%edx
80102f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f81:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102f86:	a3 98 42 11 80       	mov    %eax,0x80114298
  if(kmem.use_lock)
80102f8b:	a1 94 42 11 80       	mov    0x80114294,%eax
80102f90:	85 c0                	test   %eax,%eax
80102f92:	74 10                	je     80102fa4 <kfree+0x9a>
    release(&kmem.lock);
80102f94:	83 ec 0c             	sub    $0xc,%esp
80102f97:	68 60 42 11 80       	push   $0x80114260
80102f9c:	e8 a6 39 00 00       	call   80106947 <release>
80102fa1:	83 c4 10             	add    $0x10,%esp
}
80102fa4:	90                   	nop
80102fa5:	c9                   	leave  
80102fa6:	c3                   	ret    

80102fa7 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102fa7:	55                   	push   %ebp
80102fa8:	89 e5                	mov    %esp,%ebp
80102faa:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102fad:	a1 94 42 11 80       	mov    0x80114294,%eax
80102fb2:	85 c0                	test   %eax,%eax
80102fb4:	74 10                	je     80102fc6 <kalloc+0x1f>
    acquire(&kmem.lock);
80102fb6:	83 ec 0c             	sub    $0xc,%esp
80102fb9:	68 60 42 11 80       	push   $0x80114260
80102fbe:	e8 1d 39 00 00       	call   801068e0 <acquire>
80102fc3:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102fc6:	a1 98 42 11 80       	mov    0x80114298,%eax
80102fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102fce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102fd2:	74 0a                	je     80102fde <kalloc+0x37>
    kmem.freelist = r->next;
80102fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102fd7:	8b 00                	mov    (%eax),%eax
80102fd9:	a3 98 42 11 80       	mov    %eax,0x80114298
  if(kmem.use_lock)
80102fde:	a1 94 42 11 80       	mov    0x80114294,%eax
80102fe3:	85 c0                	test   %eax,%eax
80102fe5:	74 10                	je     80102ff7 <kalloc+0x50>
    release(&kmem.lock);
80102fe7:	83 ec 0c             	sub    $0xc,%esp
80102fea:	68 60 42 11 80       	push   $0x80114260
80102fef:	e8 53 39 00 00       	call   80106947 <release>
80102ff4:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102ff7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102ffa:	c9                   	leave  
80102ffb:	c3                   	ret    

80102ffc <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80102ffc:	55                   	push   %ebp
80102ffd:	89 e5                	mov    %esp,%ebp
80102fff:	83 ec 14             	sub    $0x14,%esp
80103002:	8b 45 08             	mov    0x8(%ebp),%eax
80103005:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103009:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
8010300d:	89 c2                	mov    %eax,%edx
8010300f:	ec                   	in     (%dx),%al
80103010:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103013:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103017:	c9                   	leave  
80103018:	c3                   	ret    

80103019 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80103019:	55                   	push   %ebp
8010301a:	89 e5                	mov    %esp,%ebp
8010301c:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
8010301f:	6a 64                	push   $0x64
80103021:	e8 d6 ff ff ff       	call   80102ffc <inb>
80103026:	83 c4 04             	add    $0x4,%esp
80103029:	0f b6 c0             	movzbl %al,%eax
8010302c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
8010302f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103032:	83 e0 01             	and    $0x1,%eax
80103035:	85 c0                	test   %eax,%eax
80103037:	75 0a                	jne    80103043 <kbdgetc+0x2a>
    return -1;
80103039:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010303e:	e9 23 01 00 00       	jmp    80103166 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80103043:	6a 60                	push   $0x60
80103045:	e8 b2 ff ff ff       	call   80102ffc <inb>
8010304a:	83 c4 04             	add    $0x4,%esp
8010304d:	0f b6 c0             	movzbl %al,%eax
80103050:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80103053:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
8010305a:	75 17                	jne    80103073 <kbdgetc+0x5a>
    shift |= E0ESC;
8010305c:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103061:	83 c8 40             	or     $0x40,%eax
80103064:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
    return 0;
80103069:	b8 00 00 00 00       	mov    $0x0,%eax
8010306e:	e9 f3 00 00 00       	jmp    80103166 <kbdgetc+0x14d>
  } else if(data & 0x80){
80103073:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103076:	25 80 00 00 00       	and    $0x80,%eax
8010307b:	85 c0                	test   %eax,%eax
8010307d:	74 45                	je     801030c4 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010307f:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103084:	83 e0 40             	and    $0x40,%eax
80103087:	85 c0                	test   %eax,%eax
80103089:	75 08                	jne    80103093 <kbdgetc+0x7a>
8010308b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010308e:	83 e0 7f             	and    $0x7f,%eax
80103091:	eb 03                	jmp    80103096 <kbdgetc+0x7d>
80103093:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103096:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80103099:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010309c:	05 20 b0 10 80       	add    $0x8010b020,%eax
801030a1:	0f b6 00             	movzbl (%eax),%eax
801030a4:	83 c8 40             	or     $0x40,%eax
801030a7:	0f b6 c0             	movzbl %al,%eax
801030aa:	f7 d0                	not    %eax
801030ac:	89 c2                	mov    %eax,%edx
801030ae:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801030b3:	21 d0                	and    %edx,%eax
801030b5:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
    return 0;
801030ba:	b8 00 00 00 00       	mov    $0x0,%eax
801030bf:	e9 a2 00 00 00       	jmp    80103166 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
801030c4:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801030c9:	83 e0 40             	and    $0x40,%eax
801030cc:	85 c0                	test   %eax,%eax
801030ce:	74 14                	je     801030e4 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801030d0:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
801030d7:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801030dc:	83 e0 bf             	and    $0xffffffbf,%eax
801030df:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  }

  shift |= shiftcode[data];
801030e4:	8b 45 fc             	mov    -0x4(%ebp),%eax
801030e7:	05 20 b0 10 80       	add    $0x8010b020,%eax
801030ec:	0f b6 00             	movzbl (%eax),%eax
801030ef:	0f b6 d0             	movzbl %al,%edx
801030f2:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
801030f7:	09 d0                	or     %edx,%eax
801030f9:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  shift ^= togglecode[data];
801030fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103101:	05 20 b1 10 80       	add    $0x8010b120,%eax
80103106:	0f b6 00             	movzbl (%eax),%eax
80103109:	0f b6 d0             	movzbl %al,%edx
8010310c:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
80103111:	31 d0                	xor    %edx,%eax
80103113:	a3 7c d6 10 80       	mov    %eax,0x8010d67c
  c = charcode[shift & (CTL | SHIFT)][data];
80103118:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
8010311d:	83 e0 03             	and    $0x3,%eax
80103120:	8b 14 85 20 b5 10 80 	mov    -0x7fef4ae0(,%eax,4),%edx
80103127:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010312a:	01 d0                	add    %edx,%eax
8010312c:	0f b6 00             	movzbl (%eax),%eax
8010312f:	0f b6 c0             	movzbl %al,%eax
80103132:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80103135:	a1 7c d6 10 80       	mov    0x8010d67c,%eax
8010313a:	83 e0 08             	and    $0x8,%eax
8010313d:	85 c0                	test   %eax,%eax
8010313f:	74 22                	je     80103163 <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80103141:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80103145:	76 0c                	jbe    80103153 <kbdgetc+0x13a>
80103147:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
8010314b:	77 06                	ja     80103153 <kbdgetc+0x13a>
      c += 'A' - 'a';
8010314d:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80103151:	eb 10                	jmp    80103163 <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80103153:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80103157:	76 0a                	jbe    80103163 <kbdgetc+0x14a>
80103159:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
8010315d:	77 04                	ja     80103163 <kbdgetc+0x14a>
      c += 'a' - 'A';
8010315f:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80103163:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103166:	c9                   	leave  
80103167:	c3                   	ret    

80103168 <kbdintr>:

void
kbdintr(void)
{
80103168:	55                   	push   %ebp
80103169:	89 e5                	mov    %esp,%ebp
8010316b:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
8010316e:	83 ec 0c             	sub    $0xc,%esp
80103171:	68 19 30 10 80       	push   $0x80103019
80103176:	e8 7e d6 ff ff       	call   801007f9 <consoleintr>
8010317b:	83 c4 10             	add    $0x10,%esp
}
8010317e:	90                   	nop
8010317f:	c9                   	leave  
80103180:	c3                   	ret    

80103181 <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103181:	55                   	push   %ebp
80103182:	89 e5                	mov    %esp,%ebp
80103184:	83 ec 14             	sub    $0x14,%esp
80103187:	8b 45 08             	mov    0x8(%ebp),%eax
8010318a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010318e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103192:	89 c2                	mov    %eax,%edx
80103194:	ec                   	in     (%dx),%al
80103195:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103198:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010319c:	c9                   	leave  
8010319d:	c3                   	ret    

8010319e <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010319e:	55                   	push   %ebp
8010319f:	89 e5                	mov    %esp,%ebp
801031a1:	83 ec 08             	sub    $0x8,%esp
801031a4:	8b 55 08             	mov    0x8(%ebp),%edx
801031a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801031aa:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801031ae:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801031b1:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801031b5:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801031b9:	ee                   	out    %al,(%dx)
}
801031ba:	90                   	nop
801031bb:	c9                   	leave  
801031bc:	c3                   	ret    

801031bd <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
801031bd:	55                   	push   %ebp
801031be:	89 e5                	mov    %esp,%ebp
801031c0:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801031c3:	9c                   	pushf  
801031c4:	58                   	pop    %eax
801031c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801031c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801031cb:	c9                   	leave  
801031cc:	c3                   	ret    

801031cd <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
801031cd:	55                   	push   %ebp
801031ce:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
801031d0:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801031d5:	8b 55 08             	mov    0x8(%ebp),%edx
801031d8:	c1 e2 02             	shl    $0x2,%edx
801031db:	01 c2                	add    %eax,%edx
801031dd:	8b 45 0c             	mov    0xc(%ebp),%eax
801031e0:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
801031e2:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801031e7:	83 c0 20             	add    $0x20,%eax
801031ea:	8b 00                	mov    (%eax),%eax
}
801031ec:	90                   	nop
801031ed:	5d                   	pop    %ebp
801031ee:	c3                   	ret    

801031ef <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
801031ef:	55                   	push   %ebp
801031f0:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
801031f2:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801031f7:	85 c0                	test   %eax,%eax
801031f9:	0f 84 0b 01 00 00    	je     8010330a <lapicinit+0x11b>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
801031ff:	68 3f 01 00 00       	push   $0x13f
80103204:	6a 3c                	push   $0x3c
80103206:	e8 c2 ff ff ff       	call   801031cd <lapicw>
8010320b:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
8010320e:	6a 0b                	push   $0xb
80103210:	68 f8 00 00 00       	push   $0xf8
80103215:	e8 b3 ff ff ff       	call   801031cd <lapicw>
8010321a:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
8010321d:	68 20 00 02 00       	push   $0x20020
80103222:	68 c8 00 00 00       	push   $0xc8
80103227:	e8 a1 ff ff ff       	call   801031cd <lapicw>
8010322c:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
8010322f:	68 80 96 98 00       	push   $0x989680
80103234:	68 e0 00 00 00       	push   $0xe0
80103239:	e8 8f ff ff ff       	call   801031cd <lapicw>
8010323e:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80103241:	68 00 00 01 00       	push   $0x10000
80103246:	68 d4 00 00 00       	push   $0xd4
8010324b:	e8 7d ff ff ff       	call   801031cd <lapicw>
80103250:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80103253:	68 00 00 01 00       	push   $0x10000
80103258:	68 d8 00 00 00       	push   $0xd8
8010325d:	e8 6b ff ff ff       	call   801031cd <lapicw>
80103262:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80103265:	a1 9c 42 11 80       	mov    0x8011429c,%eax
8010326a:	83 c0 30             	add    $0x30,%eax
8010326d:	8b 00                	mov    (%eax),%eax
8010326f:	c1 e8 10             	shr    $0x10,%eax
80103272:	0f b6 c0             	movzbl %al,%eax
80103275:	83 f8 03             	cmp    $0x3,%eax
80103278:	76 12                	jbe    8010328c <lapicinit+0x9d>
    lapicw(PCINT, MASKED);
8010327a:	68 00 00 01 00       	push   $0x10000
8010327f:	68 d0 00 00 00       	push   $0xd0
80103284:	e8 44 ff ff ff       	call   801031cd <lapicw>
80103289:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
8010328c:	6a 33                	push   $0x33
8010328e:	68 dc 00 00 00       	push   $0xdc
80103293:	e8 35 ff ff ff       	call   801031cd <lapicw>
80103298:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
8010329b:	6a 00                	push   $0x0
8010329d:	68 a0 00 00 00       	push   $0xa0
801032a2:	e8 26 ff ff ff       	call   801031cd <lapicw>
801032a7:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
801032aa:	6a 00                	push   $0x0
801032ac:	68 a0 00 00 00       	push   $0xa0
801032b1:	e8 17 ff ff ff       	call   801031cd <lapicw>
801032b6:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
801032b9:	6a 00                	push   $0x0
801032bb:	6a 2c                	push   $0x2c
801032bd:	e8 0b ff ff ff       	call   801031cd <lapicw>
801032c2:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
801032c5:	6a 00                	push   $0x0
801032c7:	68 c4 00 00 00       	push   $0xc4
801032cc:	e8 fc fe ff ff       	call   801031cd <lapicw>
801032d1:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801032d4:	68 00 85 08 00       	push   $0x88500
801032d9:	68 c0 00 00 00       	push   $0xc0
801032de:	e8 ea fe ff ff       	call   801031cd <lapicw>
801032e3:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
801032e6:	90                   	nop
801032e7:	a1 9c 42 11 80       	mov    0x8011429c,%eax
801032ec:	05 00 03 00 00       	add    $0x300,%eax
801032f1:	8b 00                	mov    (%eax),%eax
801032f3:	25 00 10 00 00       	and    $0x1000,%eax
801032f8:	85 c0                	test   %eax,%eax
801032fa:	75 eb                	jne    801032e7 <lapicinit+0xf8>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
801032fc:	6a 00                	push   $0x0
801032fe:	6a 20                	push   $0x20
80103300:	e8 c8 fe ff ff       	call   801031cd <lapicw>
80103305:	83 c4 08             	add    $0x8,%esp
80103308:	eb 01                	jmp    8010330b <lapicinit+0x11c>

void
lapicinit(void)
{
  if(!lapic) 
    return;
8010330a:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
8010330b:	c9                   	leave  
8010330c:	c3                   	ret    

8010330d <cpunum>:

int
cpunum(void)
{
8010330d:	55                   	push   %ebp
8010330e:	89 e5                	mov    %esp,%ebp
80103310:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80103313:	e8 a5 fe ff ff       	call   801031bd <readeflags>
80103318:	25 00 02 00 00       	and    $0x200,%eax
8010331d:	85 c0                	test   %eax,%eax
8010331f:	74 26                	je     80103347 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80103321:	a1 80 d6 10 80       	mov    0x8010d680,%eax
80103326:	8d 50 01             	lea    0x1(%eax),%edx
80103329:	89 15 80 d6 10 80    	mov    %edx,0x8010d680
8010332f:	85 c0                	test   %eax,%eax
80103331:	75 14                	jne    80103347 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80103333:	8b 45 04             	mov    0x4(%ebp),%eax
80103336:	83 ec 08             	sub    $0x8,%esp
80103339:	50                   	push   %eax
8010333a:	68 e8 a2 10 80       	push   $0x8010a2e8
8010333f:	e8 82 d0 ff ff       	call   801003c6 <cprintf>
80103344:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80103347:	a1 9c 42 11 80       	mov    0x8011429c,%eax
8010334c:	85 c0                	test   %eax,%eax
8010334e:	74 0f                	je     8010335f <cpunum+0x52>
    return lapic[ID]>>24;
80103350:	a1 9c 42 11 80       	mov    0x8011429c,%eax
80103355:	83 c0 20             	add    $0x20,%eax
80103358:	8b 00                	mov    (%eax),%eax
8010335a:	c1 e8 18             	shr    $0x18,%eax
8010335d:	eb 05                	jmp    80103364 <cpunum+0x57>
  return 0;
8010335f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103364:	c9                   	leave  
80103365:	c3                   	ret    

80103366 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103366:	55                   	push   %ebp
80103367:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103369:	a1 9c 42 11 80       	mov    0x8011429c,%eax
8010336e:	85 c0                	test   %eax,%eax
80103370:	74 0c                	je     8010337e <lapiceoi+0x18>
    lapicw(EOI, 0);
80103372:	6a 00                	push   $0x0
80103374:	6a 2c                	push   $0x2c
80103376:	e8 52 fe ff ff       	call   801031cd <lapicw>
8010337b:	83 c4 08             	add    $0x8,%esp
}
8010337e:	90                   	nop
8010337f:	c9                   	leave  
80103380:	c3                   	ret    

80103381 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103381:	55                   	push   %ebp
80103382:	89 e5                	mov    %esp,%ebp
}
80103384:	90                   	nop
80103385:	5d                   	pop    %ebp
80103386:	c3                   	ret    

80103387 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103387:	55                   	push   %ebp
80103388:	89 e5                	mov    %esp,%ebp
8010338a:	83 ec 14             	sub    $0x14,%esp
8010338d:	8b 45 08             	mov    0x8(%ebp),%eax
80103390:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103393:	6a 0f                	push   $0xf
80103395:	6a 70                	push   $0x70
80103397:	e8 02 fe ff ff       	call   8010319e <outb>
8010339c:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
8010339f:	6a 0a                	push   $0xa
801033a1:	6a 71                	push   $0x71
801033a3:	e8 f6 fd ff ff       	call   8010319e <outb>
801033a8:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
801033ab:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801033b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801033b5:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801033ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
801033bd:	83 c0 02             	add    $0x2,%eax
801033c0:	8b 55 0c             	mov    0xc(%ebp),%edx
801033c3:	c1 ea 04             	shr    $0x4,%edx
801033c6:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801033c9:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801033cd:	c1 e0 18             	shl    $0x18,%eax
801033d0:	50                   	push   %eax
801033d1:	68 c4 00 00 00       	push   $0xc4
801033d6:	e8 f2 fd ff ff       	call   801031cd <lapicw>
801033db:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801033de:	68 00 c5 00 00       	push   $0xc500
801033e3:	68 c0 00 00 00       	push   $0xc0
801033e8:	e8 e0 fd ff ff       	call   801031cd <lapicw>
801033ed:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801033f0:	68 c8 00 00 00       	push   $0xc8
801033f5:	e8 87 ff ff ff       	call   80103381 <microdelay>
801033fa:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
801033fd:	68 00 85 00 00       	push   $0x8500
80103402:	68 c0 00 00 00       	push   $0xc0
80103407:	e8 c1 fd ff ff       	call   801031cd <lapicw>
8010340c:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
8010340f:	6a 64                	push   $0x64
80103411:	e8 6b ff ff ff       	call   80103381 <microdelay>
80103416:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103419:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103420:	eb 3d                	jmp    8010345f <lapicstartap+0xd8>
    lapicw(ICRHI, apicid<<24);
80103422:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103426:	c1 e0 18             	shl    $0x18,%eax
80103429:	50                   	push   %eax
8010342a:	68 c4 00 00 00       	push   $0xc4
8010342f:	e8 99 fd ff ff       	call   801031cd <lapicw>
80103434:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103437:	8b 45 0c             	mov    0xc(%ebp),%eax
8010343a:	c1 e8 0c             	shr    $0xc,%eax
8010343d:	80 cc 06             	or     $0x6,%ah
80103440:	50                   	push   %eax
80103441:	68 c0 00 00 00       	push   $0xc0
80103446:	e8 82 fd ff ff       	call   801031cd <lapicw>
8010344b:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
8010344e:	68 c8 00 00 00       	push   $0xc8
80103453:	e8 29 ff ff ff       	call   80103381 <microdelay>
80103458:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010345b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010345f:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103463:	7e bd                	jle    80103422 <lapicstartap+0x9b>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80103465:	90                   	nop
80103466:	c9                   	leave  
80103467:	c3                   	ret    

80103468 <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
80103468:	55                   	push   %ebp
80103469:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
8010346b:	8b 45 08             	mov    0x8(%ebp),%eax
8010346e:	0f b6 c0             	movzbl %al,%eax
80103471:	50                   	push   %eax
80103472:	6a 70                	push   $0x70
80103474:	e8 25 fd ff ff       	call   8010319e <outb>
80103479:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010347c:	68 c8 00 00 00       	push   $0xc8
80103481:	e8 fb fe ff ff       	call   80103381 <microdelay>
80103486:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
80103489:	6a 71                	push   $0x71
8010348b:	e8 f1 fc ff ff       	call   80103181 <inb>
80103490:	83 c4 04             	add    $0x4,%esp
80103493:	0f b6 c0             	movzbl %al,%eax
}
80103496:	c9                   	leave  
80103497:	c3                   	ret    

80103498 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103498:	55                   	push   %ebp
80103499:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
8010349b:	6a 00                	push   $0x0
8010349d:	e8 c6 ff ff ff       	call   80103468 <cmos_read>
801034a2:	83 c4 04             	add    $0x4,%esp
801034a5:	89 c2                	mov    %eax,%edx
801034a7:	8b 45 08             	mov    0x8(%ebp),%eax
801034aa:	89 10                	mov    %edx,(%eax)
  r->minute = cmos_read(MINS);
801034ac:	6a 02                	push   $0x2
801034ae:	e8 b5 ff ff ff       	call   80103468 <cmos_read>
801034b3:	83 c4 04             	add    $0x4,%esp
801034b6:	89 c2                	mov    %eax,%edx
801034b8:	8b 45 08             	mov    0x8(%ebp),%eax
801034bb:	89 50 04             	mov    %edx,0x4(%eax)
  r->hour   = cmos_read(HOURS);
801034be:	6a 04                	push   $0x4
801034c0:	e8 a3 ff ff ff       	call   80103468 <cmos_read>
801034c5:	83 c4 04             	add    $0x4,%esp
801034c8:	89 c2                	mov    %eax,%edx
801034ca:	8b 45 08             	mov    0x8(%ebp),%eax
801034cd:	89 50 08             	mov    %edx,0x8(%eax)
  r->day    = cmos_read(DAY);
801034d0:	6a 07                	push   $0x7
801034d2:	e8 91 ff ff ff       	call   80103468 <cmos_read>
801034d7:	83 c4 04             	add    $0x4,%esp
801034da:	89 c2                	mov    %eax,%edx
801034dc:	8b 45 08             	mov    0x8(%ebp),%eax
801034df:	89 50 0c             	mov    %edx,0xc(%eax)
  r->month  = cmos_read(MONTH);
801034e2:	6a 08                	push   $0x8
801034e4:	e8 7f ff ff ff       	call   80103468 <cmos_read>
801034e9:	83 c4 04             	add    $0x4,%esp
801034ec:	89 c2                	mov    %eax,%edx
801034ee:	8b 45 08             	mov    0x8(%ebp),%eax
801034f1:	89 50 10             	mov    %edx,0x10(%eax)
  r->year   = cmos_read(YEAR);
801034f4:	6a 09                	push   $0x9
801034f6:	e8 6d ff ff ff       	call   80103468 <cmos_read>
801034fb:	83 c4 04             	add    $0x4,%esp
801034fe:	89 c2                	mov    %eax,%edx
80103500:	8b 45 08             	mov    0x8(%ebp),%eax
80103503:	89 50 14             	mov    %edx,0x14(%eax)
}
80103506:	90                   	nop
80103507:	c9                   	leave  
80103508:	c3                   	ret    

80103509 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
80103509:	55                   	push   %ebp
8010350a:	89 e5                	mov    %esp,%ebp
8010350c:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010350f:	6a 0b                	push   $0xb
80103511:	e8 52 ff ff ff       	call   80103468 <cmos_read>
80103516:	83 c4 04             	add    $0x4,%esp
80103519:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
8010351c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010351f:	83 e0 04             	and    $0x4,%eax
80103522:	85 c0                	test   %eax,%eax
80103524:	0f 94 c0             	sete   %al
80103527:	0f b6 c0             	movzbl %al,%eax
8010352a:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
8010352d:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103530:	50                   	push   %eax
80103531:	e8 62 ff ff ff       	call   80103498 <fill_rtcdate>
80103536:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103539:	6a 0a                	push   $0xa
8010353b:	e8 28 ff ff ff       	call   80103468 <cmos_read>
80103540:	83 c4 04             	add    $0x4,%esp
80103543:	25 80 00 00 00       	and    $0x80,%eax
80103548:	85 c0                	test   %eax,%eax
8010354a:	75 27                	jne    80103573 <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
8010354c:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010354f:	50                   	push   %eax
80103550:	e8 43 ff ff ff       	call   80103498 <fill_rtcdate>
80103555:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
80103558:	83 ec 04             	sub    $0x4,%esp
8010355b:	6a 18                	push   $0x18
8010355d:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103560:	50                   	push   %eax
80103561:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103564:	50                   	push   %eax
80103565:	e8 40 36 00 00       	call   80106baa <memcmp>
8010356a:	83 c4 10             	add    $0x10,%esp
8010356d:	85 c0                	test   %eax,%eax
8010356f:	74 05                	je     80103576 <cmostime+0x6d>
80103571:	eb ba                	jmp    8010352d <cmostime+0x24>

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
80103573:	90                   	nop
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103574:	eb b7                	jmp    8010352d <cmostime+0x24>
    fill_rtcdate(&t1);
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
80103576:	90                   	nop
  }

  // convert
  if (bcd) {
80103577:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010357b:	0f 84 b4 00 00 00    	je     80103635 <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103581:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103584:	c1 e8 04             	shr    $0x4,%eax
80103587:	89 c2                	mov    %eax,%edx
80103589:	89 d0                	mov    %edx,%eax
8010358b:	c1 e0 02             	shl    $0x2,%eax
8010358e:	01 d0                	add    %edx,%eax
80103590:	01 c0                	add    %eax,%eax
80103592:	89 c2                	mov    %eax,%edx
80103594:	8b 45 d8             	mov    -0x28(%ebp),%eax
80103597:	83 e0 0f             	and    $0xf,%eax
8010359a:	01 d0                	add    %edx,%eax
8010359c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
8010359f:	8b 45 dc             	mov    -0x24(%ebp),%eax
801035a2:	c1 e8 04             	shr    $0x4,%eax
801035a5:	89 c2                	mov    %eax,%edx
801035a7:	89 d0                	mov    %edx,%eax
801035a9:	c1 e0 02             	shl    $0x2,%eax
801035ac:	01 d0                	add    %edx,%eax
801035ae:	01 c0                	add    %eax,%eax
801035b0:	89 c2                	mov    %eax,%edx
801035b2:	8b 45 dc             	mov    -0x24(%ebp),%eax
801035b5:	83 e0 0f             	and    $0xf,%eax
801035b8:	01 d0                	add    %edx,%eax
801035ba:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801035bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801035c0:	c1 e8 04             	shr    $0x4,%eax
801035c3:	89 c2                	mov    %eax,%edx
801035c5:	89 d0                	mov    %edx,%eax
801035c7:	c1 e0 02             	shl    $0x2,%eax
801035ca:	01 d0                	add    %edx,%eax
801035cc:	01 c0                	add    %eax,%eax
801035ce:	89 c2                	mov    %eax,%edx
801035d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801035d3:	83 e0 0f             	and    $0xf,%eax
801035d6:	01 d0                	add    %edx,%eax
801035d8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801035db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035de:	c1 e8 04             	shr    $0x4,%eax
801035e1:	89 c2                	mov    %eax,%edx
801035e3:	89 d0                	mov    %edx,%eax
801035e5:	c1 e0 02             	shl    $0x2,%eax
801035e8:	01 d0                	add    %edx,%eax
801035ea:	01 c0                	add    %eax,%eax
801035ec:	89 c2                	mov    %eax,%edx
801035ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801035f1:	83 e0 0f             	and    $0xf,%eax
801035f4:	01 d0                	add    %edx,%eax
801035f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801035f9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801035fc:	c1 e8 04             	shr    $0x4,%eax
801035ff:	89 c2                	mov    %eax,%edx
80103601:	89 d0                	mov    %edx,%eax
80103603:	c1 e0 02             	shl    $0x2,%eax
80103606:	01 d0                	add    %edx,%eax
80103608:	01 c0                	add    %eax,%eax
8010360a:	89 c2                	mov    %eax,%edx
8010360c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010360f:	83 e0 0f             	and    $0xf,%eax
80103612:	01 d0                	add    %edx,%eax
80103614:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
80103617:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010361a:	c1 e8 04             	shr    $0x4,%eax
8010361d:	89 c2                	mov    %eax,%edx
8010361f:	89 d0                	mov    %edx,%eax
80103621:	c1 e0 02             	shl    $0x2,%eax
80103624:	01 d0                	add    %edx,%eax
80103626:	01 c0                	add    %eax,%eax
80103628:	89 c2                	mov    %eax,%edx
8010362a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010362d:	83 e0 0f             	and    $0xf,%eax
80103630:	01 d0                	add    %edx,%eax
80103632:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103635:	8b 45 08             	mov    0x8(%ebp),%eax
80103638:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010363b:	89 10                	mov    %edx,(%eax)
8010363d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103640:	89 50 04             	mov    %edx,0x4(%eax)
80103643:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103646:	89 50 08             	mov    %edx,0x8(%eax)
80103649:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010364c:	89 50 0c             	mov    %edx,0xc(%eax)
8010364f:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103652:	89 50 10             	mov    %edx,0x10(%eax)
80103655:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103658:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
8010365b:	8b 45 08             	mov    0x8(%ebp),%eax
8010365e:	8b 40 14             	mov    0x14(%eax),%eax
80103661:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103667:	8b 45 08             	mov    0x8(%ebp),%eax
8010366a:	89 50 14             	mov    %edx,0x14(%eax)
}
8010366d:	90                   	nop
8010366e:	c9                   	leave  
8010366f:	c3                   	ret    

80103670 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103670:	55                   	push   %ebp
80103671:	89 e5                	mov    %esp,%ebp
80103673:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103676:	83 ec 08             	sub    $0x8,%esp
80103679:	68 14 a3 10 80       	push   $0x8010a314
8010367e:	68 a0 42 11 80       	push   $0x801142a0
80103683:	e8 36 32 00 00       	call   801068be <initlock>
80103688:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
8010368b:	83 ec 08             	sub    $0x8,%esp
8010368e:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103691:	50                   	push   %eax
80103692:	ff 75 08             	pushl  0x8(%ebp)
80103695:	e8 3f de ff ff       	call   801014d9 <readsb>
8010369a:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
8010369d:	8b 45 ec             	mov    -0x14(%ebp),%eax
801036a0:	a3 d4 42 11 80       	mov    %eax,0x801142d4
  log.size = sb.nlog;
801036a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801036a8:	a3 d8 42 11 80       	mov    %eax,0x801142d8
  log.dev = dev;
801036ad:	8b 45 08             	mov    0x8(%ebp),%eax
801036b0:	a3 e4 42 11 80       	mov    %eax,0x801142e4
  recover_from_log();
801036b5:	e8 b2 01 00 00       	call   8010386c <recover_from_log>
}
801036ba:	90                   	nop
801036bb:	c9                   	leave  
801036bc:	c3                   	ret    

801036bd <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801036bd:	55                   	push   %ebp
801036be:	89 e5                	mov    %esp,%ebp
801036c0:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036c3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036ca:	e9 95 00 00 00       	jmp    80103764 <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801036cf:	8b 15 d4 42 11 80    	mov    0x801142d4,%edx
801036d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036d8:	01 d0                	add    %edx,%eax
801036da:	83 c0 01             	add    $0x1,%eax
801036dd:	89 c2                	mov    %eax,%edx
801036df:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801036e4:	83 ec 08             	sub    $0x8,%esp
801036e7:	52                   	push   %edx
801036e8:	50                   	push   %eax
801036e9:	e8 c8 ca ff ff       	call   801001b6 <bread>
801036ee:	83 c4 10             	add    $0x10,%esp
801036f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801036f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036f7:	83 c0 10             	add    $0x10,%eax
801036fa:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
80103701:	89 c2                	mov    %eax,%edx
80103703:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103708:	83 ec 08             	sub    $0x8,%esp
8010370b:	52                   	push   %edx
8010370c:	50                   	push   %eax
8010370d:	e8 a4 ca ff ff       	call   801001b6 <bread>
80103712:	83 c4 10             	add    $0x10,%esp
80103715:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80103718:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010371b:	8d 50 18             	lea    0x18(%eax),%edx
8010371e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103721:	83 c0 18             	add    $0x18,%eax
80103724:	83 ec 04             	sub    $0x4,%esp
80103727:	68 00 02 00 00       	push   $0x200
8010372c:	52                   	push   %edx
8010372d:	50                   	push   %eax
8010372e:	e8 cf 34 00 00       	call   80106c02 <memmove>
80103733:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
80103736:	83 ec 0c             	sub    $0xc,%esp
80103739:	ff 75 ec             	pushl  -0x14(%ebp)
8010373c:	e8 ae ca ff ff       	call   801001ef <bwrite>
80103741:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
80103744:	83 ec 0c             	sub    $0xc,%esp
80103747:	ff 75 f0             	pushl  -0x10(%ebp)
8010374a:	e8 df ca ff ff       	call   8010022e <brelse>
8010374f:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103752:	83 ec 0c             	sub    $0xc,%esp
80103755:	ff 75 ec             	pushl  -0x14(%ebp)
80103758:	e8 d1 ca ff ff       	call   8010022e <brelse>
8010375d:	83 c4 10             	add    $0x10,%esp
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103760:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103764:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103769:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010376c:	0f 8f 5d ff ff ff    	jg     801036cf <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
80103772:	90                   	nop
80103773:	c9                   	leave  
80103774:	c3                   	ret    

80103775 <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
80103775:	55                   	push   %ebp
80103776:	89 e5                	mov    %esp,%ebp
80103778:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
8010377b:	a1 d4 42 11 80       	mov    0x801142d4,%eax
80103780:	89 c2                	mov    %eax,%edx
80103782:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103787:	83 ec 08             	sub    $0x8,%esp
8010378a:	52                   	push   %edx
8010378b:	50                   	push   %eax
8010378c:	e8 25 ca ff ff       	call   801001b6 <bread>
80103791:	83 c4 10             	add    $0x10,%esp
80103794:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103797:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010379a:	83 c0 18             	add    $0x18,%eax
8010379d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
801037a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037a3:	8b 00                	mov    (%eax),%eax
801037a5:	a3 e8 42 11 80       	mov    %eax,0x801142e8
  for (i = 0; i < log.lh.n; i++) {
801037aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801037b1:	eb 1b                	jmp    801037ce <read_head+0x59>
    log.lh.block[i] = lh->block[i];
801037b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801037b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801037b9:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801037bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801037c0:	83 c2 10             	add    $0x10,%edx
801037c3:	89 04 95 ac 42 11 80 	mov    %eax,-0x7feebd54(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
801037ca:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801037ce:	a1 e8 42 11 80       	mov    0x801142e8,%eax
801037d3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801037d6:	7f db                	jg     801037b3 <read_head+0x3e>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
801037d8:	83 ec 0c             	sub    $0xc,%esp
801037db:	ff 75 f0             	pushl  -0x10(%ebp)
801037de:	e8 4b ca ff ff       	call   8010022e <brelse>
801037e3:	83 c4 10             	add    $0x10,%esp
}
801037e6:	90                   	nop
801037e7:	c9                   	leave  
801037e8:	c3                   	ret    

801037e9 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801037e9:	55                   	push   %ebp
801037ea:	89 e5                	mov    %esp,%ebp
801037ec:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801037ef:	a1 d4 42 11 80       	mov    0x801142d4,%eax
801037f4:	89 c2                	mov    %eax,%edx
801037f6:	a1 e4 42 11 80       	mov    0x801142e4,%eax
801037fb:	83 ec 08             	sub    $0x8,%esp
801037fe:	52                   	push   %edx
801037ff:	50                   	push   %eax
80103800:	e8 b1 c9 ff ff       	call   801001b6 <bread>
80103805:	83 c4 10             	add    $0x10,%esp
80103808:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
8010380b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010380e:	83 c0 18             	add    $0x18,%eax
80103811:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
80103814:	8b 15 e8 42 11 80    	mov    0x801142e8,%edx
8010381a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010381d:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
8010381f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103826:	eb 1b                	jmp    80103843 <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103828:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010382b:	83 c0 10             	add    $0x10,%eax
8010382e:	8b 0c 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%ecx
80103835:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103838:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010383b:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
8010383f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103843:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103848:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010384b:	7f db                	jg     80103828 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
8010384d:	83 ec 0c             	sub    $0xc,%esp
80103850:	ff 75 f0             	pushl  -0x10(%ebp)
80103853:	e8 97 c9 ff ff       	call   801001ef <bwrite>
80103858:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
8010385b:	83 ec 0c             	sub    $0xc,%esp
8010385e:	ff 75 f0             	pushl  -0x10(%ebp)
80103861:	e8 c8 c9 ff ff       	call   8010022e <brelse>
80103866:	83 c4 10             	add    $0x10,%esp
}
80103869:	90                   	nop
8010386a:	c9                   	leave  
8010386b:	c3                   	ret    

8010386c <recover_from_log>:

static void
recover_from_log(void)
{
8010386c:	55                   	push   %ebp
8010386d:	89 e5                	mov    %esp,%ebp
8010386f:	83 ec 08             	sub    $0x8,%esp
  read_head();      
80103872:	e8 fe fe ff ff       	call   80103775 <read_head>
  install_trans(); // if committed, copy from log to disk
80103877:	e8 41 fe ff ff       	call   801036bd <install_trans>
  log.lh.n = 0;
8010387c:	c7 05 e8 42 11 80 00 	movl   $0x0,0x801142e8
80103883:	00 00 00 
  write_head(); // clear the log
80103886:	e8 5e ff ff ff       	call   801037e9 <write_head>
}
8010388b:	90                   	nop
8010388c:	c9                   	leave  
8010388d:	c3                   	ret    

8010388e <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010388e:	55                   	push   %ebp
8010388f:	89 e5                	mov    %esp,%ebp
80103891:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
80103894:	83 ec 0c             	sub    $0xc,%esp
80103897:	68 a0 42 11 80       	push   $0x801142a0
8010389c:	e8 3f 30 00 00       	call   801068e0 <acquire>
801038a1:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
801038a4:	a1 e0 42 11 80       	mov    0x801142e0,%eax
801038a9:	85 c0                	test   %eax,%eax
801038ab:	74 17                	je     801038c4 <begin_op+0x36>
      sleep(&log, &log.lock);
801038ad:	83 ec 08             	sub    $0x8,%esp
801038b0:	68 a0 42 11 80       	push   $0x801142a0
801038b5:	68 a0 42 11 80       	push   $0x801142a0
801038ba:	e8 93 1d 00 00       	call   80105652 <sleep>
801038bf:	83 c4 10             	add    $0x10,%esp
801038c2:	eb e0                	jmp    801038a4 <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801038c4:	8b 0d e8 42 11 80    	mov    0x801142e8,%ecx
801038ca:	a1 dc 42 11 80       	mov    0x801142dc,%eax
801038cf:	8d 50 01             	lea    0x1(%eax),%edx
801038d2:	89 d0                	mov    %edx,%eax
801038d4:	c1 e0 02             	shl    $0x2,%eax
801038d7:	01 d0                	add    %edx,%eax
801038d9:	01 c0                	add    %eax,%eax
801038db:	01 c8                	add    %ecx,%eax
801038dd:	83 f8 1e             	cmp    $0x1e,%eax
801038e0:	7e 17                	jle    801038f9 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801038e2:	83 ec 08             	sub    $0x8,%esp
801038e5:	68 a0 42 11 80       	push   $0x801142a0
801038ea:	68 a0 42 11 80       	push   $0x801142a0
801038ef:	e8 5e 1d 00 00       	call   80105652 <sleep>
801038f4:	83 c4 10             	add    $0x10,%esp
801038f7:	eb ab                	jmp    801038a4 <begin_op+0x16>
    } else {
      log.outstanding += 1;
801038f9:	a1 dc 42 11 80       	mov    0x801142dc,%eax
801038fe:	83 c0 01             	add    $0x1,%eax
80103901:	a3 dc 42 11 80       	mov    %eax,0x801142dc
      release(&log.lock);
80103906:	83 ec 0c             	sub    $0xc,%esp
80103909:	68 a0 42 11 80       	push   $0x801142a0
8010390e:	e8 34 30 00 00       	call   80106947 <release>
80103913:	83 c4 10             	add    $0x10,%esp
      break;
80103916:	90                   	nop
    }
  }
}
80103917:	90                   	nop
80103918:	c9                   	leave  
80103919:	c3                   	ret    

8010391a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
8010391a:	55                   	push   %ebp
8010391b:	89 e5                	mov    %esp,%ebp
8010391d:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103920:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
80103927:	83 ec 0c             	sub    $0xc,%esp
8010392a:	68 a0 42 11 80       	push   $0x801142a0
8010392f:	e8 ac 2f 00 00       	call   801068e0 <acquire>
80103934:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80103937:	a1 dc 42 11 80       	mov    0x801142dc,%eax
8010393c:	83 e8 01             	sub    $0x1,%eax
8010393f:	a3 dc 42 11 80       	mov    %eax,0x801142dc
  if(log.committing)
80103944:	a1 e0 42 11 80       	mov    0x801142e0,%eax
80103949:	85 c0                	test   %eax,%eax
8010394b:	74 0d                	je     8010395a <end_op+0x40>
    panic("log.committing");
8010394d:	83 ec 0c             	sub    $0xc,%esp
80103950:	68 18 a3 10 80       	push   $0x8010a318
80103955:	e8 0c cc ff ff       	call   80100566 <panic>
  if(log.outstanding == 0){
8010395a:	a1 dc 42 11 80       	mov    0x801142dc,%eax
8010395f:	85 c0                	test   %eax,%eax
80103961:	75 13                	jne    80103976 <end_op+0x5c>
    do_commit = 1;
80103963:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
8010396a:	c7 05 e0 42 11 80 01 	movl   $0x1,0x801142e0
80103971:	00 00 00 
80103974:	eb 10                	jmp    80103986 <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103976:	83 ec 0c             	sub    $0xc,%esp
80103979:	68 a0 42 11 80       	push   $0x801142a0
8010397e:	e8 a8 1e 00 00       	call   8010582b <wakeup>
80103983:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
80103986:	83 ec 0c             	sub    $0xc,%esp
80103989:	68 a0 42 11 80       	push   $0x801142a0
8010398e:	e8 b4 2f 00 00       	call   80106947 <release>
80103993:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
80103996:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010399a:	74 3f                	je     801039db <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
8010399c:	e8 f5 00 00 00       	call   80103a96 <commit>
    acquire(&log.lock);
801039a1:	83 ec 0c             	sub    $0xc,%esp
801039a4:	68 a0 42 11 80       	push   $0x801142a0
801039a9:	e8 32 2f 00 00       	call   801068e0 <acquire>
801039ae:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
801039b1:	c7 05 e0 42 11 80 00 	movl   $0x0,0x801142e0
801039b8:	00 00 00 
    wakeup(&log);
801039bb:	83 ec 0c             	sub    $0xc,%esp
801039be:	68 a0 42 11 80       	push   $0x801142a0
801039c3:	e8 63 1e 00 00       	call   8010582b <wakeup>
801039c8:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801039cb:	83 ec 0c             	sub    $0xc,%esp
801039ce:	68 a0 42 11 80       	push   $0x801142a0
801039d3:	e8 6f 2f 00 00       	call   80106947 <release>
801039d8:	83 c4 10             	add    $0x10,%esp
  }
}
801039db:	90                   	nop
801039dc:	c9                   	leave  
801039dd:	c3                   	ret    

801039de <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801039de:	55                   	push   %ebp
801039df:	89 e5                	mov    %esp,%ebp
801039e1:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801039e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801039eb:	e9 95 00 00 00       	jmp    80103a85 <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801039f0:	8b 15 d4 42 11 80    	mov    0x801142d4,%edx
801039f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801039f9:	01 d0                	add    %edx,%eax
801039fb:	83 c0 01             	add    $0x1,%eax
801039fe:	89 c2                	mov    %eax,%edx
80103a00:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103a05:	83 ec 08             	sub    $0x8,%esp
80103a08:	52                   	push   %edx
80103a09:	50                   	push   %eax
80103a0a:	e8 a7 c7 ff ff       	call   801001b6 <bread>
80103a0f:	83 c4 10             	add    $0x10,%esp
80103a12:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80103a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a18:	83 c0 10             	add    $0x10,%eax
80103a1b:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
80103a22:	89 c2                	mov    %eax,%edx
80103a24:	a1 e4 42 11 80       	mov    0x801142e4,%eax
80103a29:	83 ec 08             	sub    $0x8,%esp
80103a2c:	52                   	push   %edx
80103a2d:	50                   	push   %eax
80103a2e:	e8 83 c7 ff ff       	call   801001b6 <bread>
80103a33:	83 c4 10             	add    $0x10,%esp
80103a36:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103a39:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103a3c:	8d 50 18             	lea    0x18(%eax),%edx
80103a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a42:	83 c0 18             	add    $0x18,%eax
80103a45:	83 ec 04             	sub    $0x4,%esp
80103a48:	68 00 02 00 00       	push   $0x200
80103a4d:	52                   	push   %edx
80103a4e:	50                   	push   %eax
80103a4f:	e8 ae 31 00 00       	call   80106c02 <memmove>
80103a54:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
80103a57:	83 ec 0c             	sub    $0xc,%esp
80103a5a:	ff 75 f0             	pushl  -0x10(%ebp)
80103a5d:	e8 8d c7 ff ff       	call   801001ef <bwrite>
80103a62:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
80103a65:	83 ec 0c             	sub    $0xc,%esp
80103a68:	ff 75 ec             	pushl  -0x14(%ebp)
80103a6b:	e8 be c7 ff ff       	call   8010022e <brelse>
80103a70:	83 c4 10             	add    $0x10,%esp
    brelse(to);
80103a73:	83 ec 0c             	sub    $0xc,%esp
80103a76:	ff 75 f0             	pushl  -0x10(%ebp)
80103a79:	e8 b0 c7 ff ff       	call   8010022e <brelse>
80103a7e:	83 c4 10             	add    $0x10,%esp
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103a81:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103a85:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103a8a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103a8d:	0f 8f 5d ff ff ff    	jg     801039f0 <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103a93:	90                   	nop
80103a94:	c9                   	leave  
80103a95:	c3                   	ret    

80103a96 <commit>:

static void
commit()
{
80103a96:	55                   	push   %ebp
80103a97:	89 e5                	mov    %esp,%ebp
80103a99:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103a9c:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103aa1:	85 c0                	test   %eax,%eax
80103aa3:	7e 1e                	jle    80103ac3 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103aa5:	e8 34 ff ff ff       	call   801039de <write_log>
    write_head();    // Write header to disk -- the real commit
80103aaa:	e8 3a fd ff ff       	call   801037e9 <write_head>
    install_trans(); // Now install writes to home locations
80103aaf:	e8 09 fc ff ff       	call   801036bd <install_trans>
    log.lh.n = 0; 
80103ab4:	c7 05 e8 42 11 80 00 	movl   $0x0,0x801142e8
80103abb:	00 00 00 
    write_head();    // Erase the transaction from the log
80103abe:	e8 26 fd ff ff       	call   801037e9 <write_head>
  }
}
80103ac3:	90                   	nop
80103ac4:	c9                   	leave  
80103ac5:	c3                   	ret    

80103ac6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103ac6:	55                   	push   %ebp
80103ac7:	89 e5                	mov    %esp,%ebp
80103ac9:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103acc:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103ad1:	83 f8 1d             	cmp    $0x1d,%eax
80103ad4:	7f 12                	jg     80103ae8 <log_write+0x22>
80103ad6:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103adb:	8b 15 d8 42 11 80    	mov    0x801142d8,%edx
80103ae1:	83 ea 01             	sub    $0x1,%edx
80103ae4:	39 d0                	cmp    %edx,%eax
80103ae6:	7c 0d                	jl     80103af5 <log_write+0x2f>
    panic("too big a transaction");
80103ae8:	83 ec 0c             	sub    $0xc,%esp
80103aeb:	68 27 a3 10 80       	push   $0x8010a327
80103af0:	e8 71 ca ff ff       	call   80100566 <panic>
  if (log.outstanding < 1)
80103af5:	a1 dc 42 11 80       	mov    0x801142dc,%eax
80103afa:	85 c0                	test   %eax,%eax
80103afc:	7f 0d                	jg     80103b0b <log_write+0x45>
    panic("log_write outside of trans");
80103afe:	83 ec 0c             	sub    $0xc,%esp
80103b01:	68 3d a3 10 80       	push   $0x8010a33d
80103b06:	e8 5b ca ff ff       	call   80100566 <panic>

  acquire(&log.lock);
80103b0b:	83 ec 0c             	sub    $0xc,%esp
80103b0e:	68 a0 42 11 80       	push   $0x801142a0
80103b13:	e8 c8 2d 00 00       	call   801068e0 <acquire>
80103b18:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103b1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103b22:	eb 1d                	jmp    80103b41 <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b27:	83 c0 10             	add    $0x10,%eax
80103b2a:	8b 04 85 ac 42 11 80 	mov    -0x7feebd54(,%eax,4),%eax
80103b31:	89 c2                	mov    %eax,%edx
80103b33:	8b 45 08             	mov    0x8(%ebp),%eax
80103b36:	8b 40 08             	mov    0x8(%eax),%eax
80103b39:	39 c2                	cmp    %eax,%edx
80103b3b:	74 10                	je     80103b4d <log_write+0x87>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80103b3d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103b41:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103b46:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b49:	7f d9                	jg     80103b24 <log_write+0x5e>
80103b4b:	eb 01                	jmp    80103b4e <log_write+0x88>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
80103b4d:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103b4e:	8b 45 08             	mov    0x8(%ebp),%eax
80103b51:	8b 40 08             	mov    0x8(%eax),%eax
80103b54:	89 c2                	mov    %eax,%edx
80103b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b59:	83 c0 10             	add    $0x10,%eax
80103b5c:	89 14 85 ac 42 11 80 	mov    %edx,-0x7feebd54(,%eax,4)
  if (i == log.lh.n)
80103b63:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103b68:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103b6b:	75 0d                	jne    80103b7a <log_write+0xb4>
    log.lh.n++;
80103b6d:	a1 e8 42 11 80       	mov    0x801142e8,%eax
80103b72:	83 c0 01             	add    $0x1,%eax
80103b75:	a3 e8 42 11 80       	mov    %eax,0x801142e8
  b->flags |= B_DIRTY; // prevent eviction
80103b7a:	8b 45 08             	mov    0x8(%ebp),%eax
80103b7d:	8b 00                	mov    (%eax),%eax
80103b7f:	83 c8 04             	or     $0x4,%eax
80103b82:	89 c2                	mov    %eax,%edx
80103b84:	8b 45 08             	mov    0x8(%ebp),%eax
80103b87:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103b89:	83 ec 0c             	sub    $0xc,%esp
80103b8c:	68 a0 42 11 80       	push   $0x801142a0
80103b91:	e8 b1 2d 00 00       	call   80106947 <release>
80103b96:	83 c4 10             	add    $0x10,%esp
}
80103b99:	90                   	nop
80103b9a:	c9                   	leave  
80103b9b:	c3                   	ret    

80103b9c <v2p>:
80103b9c:	55                   	push   %ebp
80103b9d:	89 e5                	mov    %esp,%ebp
80103b9f:	8b 45 08             	mov    0x8(%ebp),%eax
80103ba2:	05 00 00 00 80       	add    $0x80000000,%eax
80103ba7:	5d                   	pop    %ebp
80103ba8:	c3                   	ret    

80103ba9 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103ba9:	55                   	push   %ebp
80103baa:	89 e5                	mov    %esp,%ebp
80103bac:	8b 45 08             	mov    0x8(%ebp),%eax
80103baf:	05 00 00 00 80       	add    $0x80000000,%eax
80103bb4:	5d                   	pop    %ebp
80103bb5:	c3                   	ret    

80103bb6 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103bb6:	55                   	push   %ebp
80103bb7:	89 e5                	mov    %esp,%ebp
80103bb9:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80103bbc:	8b 55 08             	mov    0x8(%ebp),%edx
80103bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80103bc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103bc5:	f0 87 02             	lock xchg %eax,(%edx)
80103bc8:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
80103bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80103bce:	c9                   	leave  
80103bcf:	c3                   	ret    

80103bd0 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103bd0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103bd4:	83 e4 f0             	and    $0xfffffff0,%esp
80103bd7:	ff 71 fc             	pushl  -0x4(%ecx)
80103bda:	55                   	push   %ebp
80103bdb:	89 e5                	mov    %esp,%ebp
80103bdd:	51                   	push   %ecx
80103bde:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80103be1:	83 ec 08             	sub    $0x8,%esp
80103be4:	68 00 00 40 80       	push   $0x80400000
80103be9:	68 7c 79 11 80       	push   $0x8011797c
80103bee:	e8 7d f2 ff ff       	call   80102e70 <kinit1>
80103bf3:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
80103bf6:	e8 2a 5d 00 00       	call   80109925 <kvmalloc>
  mpinit();        // collect info about this machine
80103bfb:	e8 43 04 00 00       	call   80104043 <mpinit>
  lapicinit();
80103c00:	e8 ea f5 ff ff       	call   801031ef <lapicinit>
  seginit();       // set up segments
80103c05:	e8 c4 56 00 00       	call   801092ce <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103c0a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103c10:	0f b6 00             	movzbl (%eax),%eax
80103c13:	0f b6 c0             	movzbl %al,%eax
80103c16:	83 ec 08             	sub    $0x8,%esp
80103c19:	50                   	push   %eax
80103c1a:	68 58 a3 10 80       	push   $0x8010a358
80103c1f:	e8 a2 c7 ff ff       	call   801003c6 <cprintf>
80103c24:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103c27:	e8 6d 06 00 00       	call   80104299 <picinit>
  ioapicinit();    // another interrupt controller
80103c2c:	e8 34 f1 ff ff       	call   80102d65 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
80103c31:	e8 8d cf ff ff       	call   80100bc3 <consoleinit>
  uartinit();      // serial port
80103c36:	e8 ef 49 00 00       	call   8010862a <uartinit>
  pinit();         // process table
80103c3b:	e8 5d 0b 00 00       	call   8010479d <pinit>
  tvinit();        // trap vectors
80103c40:	e8 e1 45 00 00       	call   80108226 <tvinit>
  binit();         // buffer cache
80103c45:	e8 ea c3 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103c4a:	e8 7b d4 ff ff       	call   801010ca <fileinit>
  ideinit();       // disk
80103c4f:	e8 19 ed ff ff       	call   8010296d <ideinit>
  if(!ismp)
80103c54:	a1 84 43 11 80       	mov    0x80114384,%eax
80103c59:	85 c0                	test   %eax,%eax
80103c5b:	75 05                	jne    80103c62 <main+0x92>
    timerinit();   // uniprocessor timer
80103c5d:	e8 15 45 00 00       	call   80108177 <timerinit>
  startothers();   // start other processors
80103c62:	e8 7f 00 00 00       	call   80103ce6 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103c67:	83 ec 08             	sub    $0x8,%esp
80103c6a:	68 00 00 00 8e       	push   $0x8e000000
80103c6f:	68 00 00 40 80       	push   $0x80400000
80103c74:	e8 30 f2 ff ff       	call   80102ea9 <kinit2>
80103c79:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103c7c:	e8 0d 0d 00 00       	call   8010498e <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
80103c81:	e8 1a 00 00 00       	call   80103ca0 <mpmain>

80103c86 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103c86:	55                   	push   %ebp
80103c87:	89 e5                	mov    %esp,%ebp
80103c89:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103c8c:	e8 ac 5c 00 00       	call   8010993d <switchkvm>
  seginit();
80103c91:	e8 38 56 00 00       	call   801092ce <seginit>
  lapicinit();
80103c96:	e8 54 f5 ff ff       	call   801031ef <lapicinit>
  mpmain();
80103c9b:	e8 00 00 00 00       	call   80103ca0 <mpmain>

80103ca0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103ca0:	55                   	push   %ebp
80103ca1:	89 e5                	mov    %esp,%ebp
80103ca3:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103ca6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103cac:	0f b6 00             	movzbl (%eax),%eax
80103caf:	0f b6 c0             	movzbl %al,%eax
80103cb2:	83 ec 08             	sub    $0x8,%esp
80103cb5:	50                   	push   %eax
80103cb6:	68 6f a3 10 80       	push   $0x8010a36f
80103cbb:	e8 06 c7 ff ff       	call   801003c6 <cprintf>
80103cc0:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
80103cc3:	e8 bf 46 00 00       	call   80108387 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103cc8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103cce:	05 a8 00 00 00       	add    $0xa8,%eax
80103cd3:	83 ec 08             	sub    $0x8,%esp
80103cd6:	6a 01                	push   $0x1
80103cd8:	50                   	push   %eax
80103cd9:	e8 d8 fe ff ff       	call   80103bb6 <xchg>
80103cde:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
80103ce1:	e8 bd 15 00 00       	call   801052a3 <scheduler>

80103ce6 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103ce6:	55                   	push   %ebp
80103ce7:	89 e5                	mov    %esp,%ebp
80103ce9:	53                   	push   %ebx
80103cea:	83 ec 14             	sub    $0x14,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103ced:	68 00 70 00 00       	push   $0x7000
80103cf2:	e8 b2 fe ff ff       	call   80103ba9 <p2v>
80103cf7:	83 c4 04             	add    $0x4,%esp
80103cfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103cfd:	b8 8a 00 00 00       	mov    $0x8a,%eax
80103d02:	83 ec 04             	sub    $0x4,%esp
80103d05:	50                   	push   %eax
80103d06:	68 4c d5 10 80       	push   $0x8010d54c
80103d0b:	ff 75 f0             	pushl  -0x10(%ebp)
80103d0e:	e8 ef 2e 00 00       	call   80106c02 <memmove>
80103d13:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
80103d16:	c7 45 f4 a0 43 11 80 	movl   $0x801143a0,-0xc(%ebp)
80103d1d:	e9 90 00 00 00       	jmp    80103db2 <startothers+0xcc>
    if(c == cpus+cpunum())  // We've started already.
80103d22:	e8 e6 f5 ff ff       	call   8010330d <cpunum>
80103d27:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103d2d:	05 a0 43 11 80       	add    $0x801143a0,%eax
80103d32:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103d35:	74 73                	je     80103daa <startothers+0xc4>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103d37:	e8 6b f2 ff ff       	call   80102fa7 <kalloc>
80103d3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103d3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d42:	83 e8 04             	sub    $0x4,%eax
80103d45:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103d48:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103d4e:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103d50:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d53:	83 e8 08             	sub    $0x8,%eax
80103d56:	c7 00 86 3c 10 80    	movl   $0x80103c86,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103d5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d5f:	8d 58 f4             	lea    -0xc(%eax),%ebx
80103d62:	83 ec 0c             	sub    $0xc,%esp
80103d65:	68 00 c0 10 80       	push   $0x8010c000
80103d6a:	e8 2d fe ff ff       	call   80103b9c <v2p>
80103d6f:	83 c4 10             	add    $0x10,%esp
80103d72:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
80103d74:	83 ec 0c             	sub    $0xc,%esp
80103d77:	ff 75 f0             	pushl  -0x10(%ebp)
80103d7a:	e8 1d fe ff ff       	call   80103b9c <v2p>
80103d7f:	83 c4 10             	add    $0x10,%esp
80103d82:	89 c2                	mov    %eax,%edx
80103d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d87:	0f b6 00             	movzbl (%eax),%eax
80103d8a:	0f b6 c0             	movzbl %al,%eax
80103d8d:	83 ec 08             	sub    $0x8,%esp
80103d90:	52                   	push   %edx
80103d91:	50                   	push   %eax
80103d92:	e8 f0 f5 ff ff       	call   80103387 <lapicstartap>
80103d97:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103d9a:	90                   	nop
80103d9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d9e:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103da4:	85 c0                	test   %eax,%eax
80103da6:	74 f3                	je     80103d9b <startothers+0xb5>
80103da8:	eb 01                	jmp    80103dab <startothers+0xc5>
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
    if(c == cpus+cpunum())  // We've started already.
      continue;
80103daa:	90                   	nop
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80103dab:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103db2:	a1 80 49 11 80       	mov    0x80114980,%eax
80103db7:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103dbd:	05 a0 43 11 80       	add    $0x801143a0,%eax
80103dc2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103dc5:	0f 87 57 ff ff ff    	ja     80103d22 <startothers+0x3c>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
80103dcb:	90                   	nop
80103dcc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103dcf:	c9                   	leave  
80103dd0:	c3                   	ret    

80103dd1 <p2v>:
80103dd1:	55                   	push   %ebp
80103dd2:	89 e5                	mov    %esp,%ebp
80103dd4:	8b 45 08             	mov    0x8(%ebp),%eax
80103dd7:	05 00 00 00 80       	add    $0x80000000,%eax
80103ddc:	5d                   	pop    %ebp
80103ddd:	c3                   	ret    

80103dde <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
80103dde:	55                   	push   %ebp
80103ddf:	89 e5                	mov    %esp,%ebp
80103de1:	83 ec 14             	sub    $0x14,%esp
80103de4:	8b 45 08             	mov    0x8(%ebp),%eax
80103de7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103deb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103def:	89 c2                	mov    %eax,%edx
80103df1:	ec                   	in     (%dx),%al
80103df2:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103df5:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103df9:	c9                   	leave  
80103dfa:	c3                   	ret    

80103dfb <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103dfb:	55                   	push   %ebp
80103dfc:	89 e5                	mov    %esp,%ebp
80103dfe:	83 ec 08             	sub    $0x8,%esp
80103e01:	8b 55 08             	mov    0x8(%ebp),%edx
80103e04:	8b 45 0c             	mov    0xc(%ebp),%eax
80103e07:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103e0b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103e0e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103e12:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103e16:	ee                   	out    %al,(%dx)
}
80103e17:	90                   	nop
80103e18:	c9                   	leave  
80103e19:	c3                   	ret    

80103e1a <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103e1a:	55                   	push   %ebp
80103e1b:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103e1d:	a1 84 d6 10 80       	mov    0x8010d684,%eax
80103e22:	89 c2                	mov    %eax,%edx
80103e24:	b8 a0 43 11 80       	mov    $0x801143a0,%eax
80103e29:	29 c2                	sub    %eax,%edx
80103e2b:	89 d0                	mov    %edx,%eax
80103e2d:	c1 f8 02             	sar    $0x2,%eax
80103e30:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103e36:	5d                   	pop    %ebp
80103e37:	c3                   	ret    

80103e38 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103e38:	55                   	push   %ebp
80103e39:	89 e5                	mov    %esp,%ebp
80103e3b:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103e3e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103e45:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103e4c:	eb 15                	jmp    80103e63 <sum+0x2b>
    sum += addr[i];
80103e4e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103e51:	8b 45 08             	mov    0x8(%ebp),%eax
80103e54:	01 d0                	add    %edx,%eax
80103e56:	0f b6 00             	movzbl (%eax),%eax
80103e59:	0f b6 c0             	movzbl %al,%eax
80103e5c:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
80103e5f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103e66:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103e69:	7c e3                	jl     80103e4e <sum+0x16>
    sum += addr[i];
  return sum;
80103e6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103e6e:	c9                   	leave  
80103e6f:	c3                   	ret    

80103e70 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103e70:	55                   	push   %ebp
80103e71:	89 e5                	mov    %esp,%ebp
80103e73:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103e76:	ff 75 08             	pushl  0x8(%ebp)
80103e79:	e8 53 ff ff ff       	call   80103dd1 <p2v>
80103e7e:	83 c4 04             	add    $0x4,%esp
80103e81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103e84:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e8a:	01 d0                	add    %edx,%eax
80103e8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103e92:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103e95:	eb 36                	jmp    80103ecd <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103e97:	83 ec 04             	sub    $0x4,%esp
80103e9a:	6a 04                	push   $0x4
80103e9c:	68 80 a3 10 80       	push   $0x8010a380
80103ea1:	ff 75 f4             	pushl  -0xc(%ebp)
80103ea4:	e8 01 2d 00 00       	call   80106baa <memcmp>
80103ea9:	83 c4 10             	add    $0x10,%esp
80103eac:	85 c0                	test   %eax,%eax
80103eae:	75 19                	jne    80103ec9 <mpsearch1+0x59>
80103eb0:	83 ec 08             	sub    $0x8,%esp
80103eb3:	6a 10                	push   $0x10
80103eb5:	ff 75 f4             	pushl  -0xc(%ebp)
80103eb8:	e8 7b ff ff ff       	call   80103e38 <sum>
80103ebd:	83 c4 10             	add    $0x10,%esp
80103ec0:	84 c0                	test   %al,%al
80103ec2:	75 05                	jne    80103ec9 <mpsearch1+0x59>
      return (struct mp*)p;
80103ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ec7:	eb 11                	jmp    80103eda <mpsearch1+0x6a>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103ec9:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103ecd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ed0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ed3:	72 c2                	jb     80103e97 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103ed5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103eda:	c9                   	leave  
80103edb:	c3                   	ret    

80103edc <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103edc:	55                   	push   %ebp
80103edd:	89 e5                	mov    %esp,%ebp
80103edf:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103ee2:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103eec:	83 c0 0f             	add    $0xf,%eax
80103eef:	0f b6 00             	movzbl (%eax),%eax
80103ef2:	0f b6 c0             	movzbl %al,%eax
80103ef5:	c1 e0 08             	shl    $0x8,%eax
80103ef8:	89 c2                	mov    %eax,%edx
80103efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103efd:	83 c0 0e             	add    $0xe,%eax
80103f00:	0f b6 00             	movzbl (%eax),%eax
80103f03:	0f b6 c0             	movzbl %al,%eax
80103f06:	09 d0                	or     %edx,%eax
80103f08:	c1 e0 04             	shl    $0x4,%eax
80103f0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103f0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103f12:	74 21                	je     80103f35 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103f14:	83 ec 08             	sub    $0x8,%esp
80103f17:	68 00 04 00 00       	push   $0x400
80103f1c:	ff 75 f0             	pushl  -0x10(%ebp)
80103f1f:	e8 4c ff ff ff       	call   80103e70 <mpsearch1>
80103f24:	83 c4 10             	add    $0x10,%esp
80103f27:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103f2a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103f2e:	74 51                	je     80103f81 <mpsearch+0xa5>
      return mp;
80103f30:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f33:	eb 61                	jmp    80103f96 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103f35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f38:	83 c0 14             	add    $0x14,%eax
80103f3b:	0f b6 00             	movzbl (%eax),%eax
80103f3e:	0f b6 c0             	movzbl %al,%eax
80103f41:	c1 e0 08             	shl    $0x8,%eax
80103f44:	89 c2                	mov    %eax,%edx
80103f46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103f49:	83 c0 13             	add    $0x13,%eax
80103f4c:	0f b6 00             	movzbl (%eax),%eax
80103f4f:	0f b6 c0             	movzbl %al,%eax
80103f52:	09 d0                	or     %edx,%eax
80103f54:	c1 e0 0a             	shl    $0xa,%eax
80103f57:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103f5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103f5d:	2d 00 04 00 00       	sub    $0x400,%eax
80103f62:	83 ec 08             	sub    $0x8,%esp
80103f65:	68 00 04 00 00       	push   $0x400
80103f6a:	50                   	push   %eax
80103f6b:	e8 00 ff ff ff       	call   80103e70 <mpsearch1>
80103f70:	83 c4 10             	add    $0x10,%esp
80103f73:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103f76:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103f7a:	74 05                	je     80103f81 <mpsearch+0xa5>
      return mp;
80103f7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103f7f:	eb 15                	jmp    80103f96 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103f81:	83 ec 08             	sub    $0x8,%esp
80103f84:	68 00 00 01 00       	push   $0x10000
80103f89:	68 00 00 0f 00       	push   $0xf0000
80103f8e:	e8 dd fe ff ff       	call   80103e70 <mpsearch1>
80103f93:	83 c4 10             	add    $0x10,%esp
}
80103f96:	c9                   	leave  
80103f97:	c3                   	ret    

80103f98 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103f98:	55                   	push   %ebp
80103f99:	89 e5                	mov    %esp,%ebp
80103f9b:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103f9e:	e8 39 ff ff ff       	call   80103edc <mpsearch>
80103fa3:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103fa6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103faa:	74 0a                	je     80103fb6 <mpconfig+0x1e>
80103fac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103faf:	8b 40 04             	mov    0x4(%eax),%eax
80103fb2:	85 c0                	test   %eax,%eax
80103fb4:	75 0a                	jne    80103fc0 <mpconfig+0x28>
    return 0;
80103fb6:	b8 00 00 00 00       	mov    $0x0,%eax
80103fbb:	e9 81 00 00 00       	jmp    80104041 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103fc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fc3:	8b 40 04             	mov    0x4(%eax),%eax
80103fc6:	83 ec 0c             	sub    $0xc,%esp
80103fc9:	50                   	push   %eax
80103fca:	e8 02 fe ff ff       	call   80103dd1 <p2v>
80103fcf:	83 c4 10             	add    $0x10,%esp
80103fd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103fd5:	83 ec 04             	sub    $0x4,%esp
80103fd8:	6a 04                	push   $0x4
80103fda:	68 85 a3 10 80       	push   $0x8010a385
80103fdf:	ff 75 f0             	pushl  -0x10(%ebp)
80103fe2:	e8 c3 2b 00 00       	call   80106baa <memcmp>
80103fe7:	83 c4 10             	add    $0x10,%esp
80103fea:	85 c0                	test   %eax,%eax
80103fec:	74 07                	je     80103ff5 <mpconfig+0x5d>
    return 0;
80103fee:	b8 00 00 00 00       	mov    $0x0,%eax
80103ff3:	eb 4c                	jmp    80104041 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103ff5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ff8:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103ffc:	3c 01                	cmp    $0x1,%al
80103ffe:	74 12                	je     80104012 <mpconfig+0x7a>
80104000:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104003:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80104007:	3c 04                	cmp    $0x4,%al
80104009:	74 07                	je     80104012 <mpconfig+0x7a>
    return 0;
8010400b:	b8 00 00 00 00       	mov    $0x0,%eax
80104010:	eb 2f                	jmp    80104041 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80104012:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104015:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80104019:	0f b7 c0             	movzwl %ax,%eax
8010401c:	83 ec 08             	sub    $0x8,%esp
8010401f:	50                   	push   %eax
80104020:	ff 75 f0             	pushl  -0x10(%ebp)
80104023:	e8 10 fe ff ff       	call   80103e38 <sum>
80104028:	83 c4 10             	add    $0x10,%esp
8010402b:	84 c0                	test   %al,%al
8010402d:	74 07                	je     80104036 <mpconfig+0x9e>
    return 0;
8010402f:	b8 00 00 00 00       	mov    $0x0,%eax
80104034:	eb 0b                	jmp    80104041 <mpconfig+0xa9>
  *pmp = mp;
80104036:	8b 45 08             	mov    0x8(%ebp),%eax
80104039:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010403c:	89 10                	mov    %edx,(%eax)
  return conf;
8010403e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80104041:	c9                   	leave  
80104042:	c3                   	ret    

80104043 <mpinit>:

void
mpinit(void)
{
80104043:	55                   	push   %ebp
80104044:	89 e5                	mov    %esp,%ebp
80104046:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80104049:	c7 05 84 d6 10 80 a0 	movl   $0x801143a0,0x8010d684
80104050:	43 11 80 
  if((conf = mpconfig(&mp)) == 0)
80104053:	83 ec 0c             	sub    $0xc,%esp
80104056:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104059:	50                   	push   %eax
8010405a:	e8 39 ff ff ff       	call   80103f98 <mpconfig>
8010405f:	83 c4 10             	add    $0x10,%esp
80104062:	89 45 f0             	mov    %eax,-0x10(%ebp)
80104065:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104069:	0f 84 96 01 00 00    	je     80104205 <mpinit+0x1c2>
    return;
  ismp = 1;
8010406f:	c7 05 84 43 11 80 01 	movl   $0x1,0x80114384
80104076:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80104079:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010407c:	8b 40 24             	mov    0x24(%eax),%eax
8010407f:	a3 9c 42 11 80       	mov    %eax,0x8011429c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104084:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104087:	83 c0 2c             	add    $0x2c,%eax
8010408a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010408d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104090:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80104094:	0f b7 d0             	movzwl %ax,%edx
80104097:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010409a:	01 d0                	add    %edx,%eax
8010409c:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010409f:	e9 f2 00 00 00       	jmp    80104196 <mpinit+0x153>
    switch(*p){
801040a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040a7:	0f b6 00             	movzbl (%eax),%eax
801040aa:	0f b6 c0             	movzbl %al,%eax
801040ad:	83 f8 04             	cmp    $0x4,%eax
801040b0:	0f 87 bc 00 00 00    	ja     80104172 <mpinit+0x12f>
801040b6:	8b 04 85 c8 a3 10 80 	mov    -0x7fef5c38(,%eax,4),%eax
801040bd:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
801040bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
801040c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
801040c8:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801040cc:	0f b6 d0             	movzbl %al,%edx
801040cf:	a1 80 49 11 80       	mov    0x80114980,%eax
801040d4:	39 c2                	cmp    %eax,%edx
801040d6:	74 2b                	je     80104103 <mpinit+0xc0>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
801040d8:	8b 45 e8             	mov    -0x18(%ebp),%eax
801040db:	0f b6 40 01          	movzbl 0x1(%eax),%eax
801040df:	0f b6 d0             	movzbl %al,%edx
801040e2:	a1 80 49 11 80       	mov    0x80114980,%eax
801040e7:	83 ec 04             	sub    $0x4,%esp
801040ea:	52                   	push   %edx
801040eb:	50                   	push   %eax
801040ec:	68 8a a3 10 80       	push   $0x8010a38a
801040f1:	e8 d0 c2 ff ff       	call   801003c6 <cprintf>
801040f6:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
801040f9:	c7 05 84 43 11 80 00 	movl   $0x0,0x80114384
80104100:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80104103:	8b 45 e8             	mov    -0x18(%ebp),%eax
80104106:	0f b6 40 03          	movzbl 0x3(%eax),%eax
8010410a:	0f b6 c0             	movzbl %al,%eax
8010410d:	83 e0 02             	and    $0x2,%eax
80104110:	85 c0                	test   %eax,%eax
80104112:	74 15                	je     80104129 <mpinit+0xe6>
        bcpu = &cpus[ncpu];
80104114:	a1 80 49 11 80       	mov    0x80114980,%eax
80104119:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010411f:	05 a0 43 11 80       	add    $0x801143a0,%eax
80104124:	a3 84 d6 10 80       	mov    %eax,0x8010d684
      cpus[ncpu].id = ncpu;
80104129:	a1 80 49 11 80       	mov    0x80114980,%eax
8010412e:	8b 15 80 49 11 80    	mov    0x80114980,%edx
80104134:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
8010413a:	05 a0 43 11 80       	add    $0x801143a0,%eax
8010413f:	88 10                	mov    %dl,(%eax)
      ncpu++;
80104141:	a1 80 49 11 80       	mov    0x80114980,%eax
80104146:	83 c0 01             	add    $0x1,%eax
80104149:	a3 80 49 11 80       	mov    %eax,0x80114980
      p += sizeof(struct mpproc);
8010414e:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80104152:	eb 42                	jmp    80104196 <mpinit+0x153>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80104154:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104157:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
8010415a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010415d:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80104161:	a2 80 43 11 80       	mov    %al,0x80114380
      p += sizeof(struct mpioapic);
80104166:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
8010416a:	eb 2a                	jmp    80104196 <mpinit+0x153>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010416c:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80104170:	eb 24                	jmp    80104196 <mpinit+0x153>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80104172:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104175:	0f b6 00             	movzbl (%eax),%eax
80104178:	0f b6 c0             	movzbl %al,%eax
8010417b:	83 ec 08             	sub    $0x8,%esp
8010417e:	50                   	push   %eax
8010417f:	68 a8 a3 10 80       	push   $0x8010a3a8
80104184:	e8 3d c2 ff ff       	call   801003c6 <cprintf>
80104189:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
8010418c:	c7 05 84 43 11 80 00 	movl   $0x0,0x80114384
80104193:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80104196:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104199:	3b 45 ec             	cmp    -0x14(%ebp),%eax
8010419c:	0f 82 02 ff ff ff    	jb     801040a4 <mpinit+0x61>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
801041a2:	a1 84 43 11 80       	mov    0x80114384,%eax
801041a7:	85 c0                	test   %eax,%eax
801041a9:	75 1d                	jne    801041c8 <mpinit+0x185>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
801041ab:	c7 05 80 49 11 80 01 	movl   $0x1,0x80114980
801041b2:	00 00 00 
    lapic = 0;
801041b5:	c7 05 9c 42 11 80 00 	movl   $0x0,0x8011429c
801041bc:	00 00 00 
    ioapicid = 0;
801041bf:	c6 05 80 43 11 80 00 	movb   $0x0,0x80114380
    return;
801041c6:	eb 3e                	jmp    80104206 <mpinit+0x1c3>
  }

  if(mp->imcrp){
801041c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801041cb:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
801041cf:	84 c0                	test   %al,%al
801041d1:	74 33                	je     80104206 <mpinit+0x1c3>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
801041d3:	83 ec 08             	sub    $0x8,%esp
801041d6:	6a 70                	push   $0x70
801041d8:	6a 22                	push   $0x22
801041da:	e8 1c fc ff ff       	call   80103dfb <outb>
801041df:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801041e2:	83 ec 0c             	sub    $0xc,%esp
801041e5:	6a 23                	push   $0x23
801041e7:	e8 f2 fb ff ff       	call   80103dde <inb>
801041ec:	83 c4 10             	add    $0x10,%esp
801041ef:	83 c8 01             	or     $0x1,%eax
801041f2:	0f b6 c0             	movzbl %al,%eax
801041f5:	83 ec 08             	sub    $0x8,%esp
801041f8:	50                   	push   %eax
801041f9:	6a 23                	push   $0x23
801041fb:	e8 fb fb ff ff       	call   80103dfb <outb>
80104200:	83 c4 10             	add    $0x10,%esp
80104203:	eb 01                	jmp    80104206 <mpinit+0x1c3>
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
80104205:	90                   	nop
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
80104206:	c9                   	leave  
80104207:	c3                   	ret    

80104208 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80104208:	55                   	push   %ebp
80104209:	89 e5                	mov    %esp,%ebp
8010420b:	83 ec 08             	sub    $0x8,%esp
8010420e:	8b 55 08             	mov    0x8(%ebp),%edx
80104211:	8b 45 0c             	mov    0xc(%ebp),%eax
80104214:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80104218:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010421b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010421f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80104223:	ee                   	out    %al,(%dx)
}
80104224:	90                   	nop
80104225:	c9                   	leave  
80104226:	c3                   	ret    

80104227 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80104227:	55                   	push   %ebp
80104228:	89 e5                	mov    %esp,%ebp
8010422a:	83 ec 04             	sub    $0x4,%esp
8010422d:	8b 45 08             	mov    0x8(%ebp),%eax
80104230:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80104234:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104238:	66 a3 00 d0 10 80    	mov    %ax,0x8010d000
  outb(IO_PIC1+1, mask);
8010423e:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104242:	0f b6 c0             	movzbl %al,%eax
80104245:	50                   	push   %eax
80104246:	6a 21                	push   $0x21
80104248:	e8 bb ff ff ff       	call   80104208 <outb>
8010424d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80104250:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80104254:	66 c1 e8 08          	shr    $0x8,%ax
80104258:	0f b6 c0             	movzbl %al,%eax
8010425b:	50                   	push   %eax
8010425c:	68 a1 00 00 00       	push   $0xa1
80104261:	e8 a2 ff ff ff       	call   80104208 <outb>
80104266:	83 c4 08             	add    $0x8,%esp
}
80104269:	90                   	nop
8010426a:	c9                   	leave  
8010426b:	c3                   	ret    

8010426c <picenable>:

void
picenable(int irq)
{
8010426c:	55                   	push   %ebp
8010426d:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
8010426f:	8b 45 08             	mov    0x8(%ebp),%eax
80104272:	ba 01 00 00 00       	mov    $0x1,%edx
80104277:	89 c1                	mov    %eax,%ecx
80104279:	d3 e2                	shl    %cl,%edx
8010427b:	89 d0                	mov    %edx,%eax
8010427d:	f7 d0                	not    %eax
8010427f:	89 c2                	mov    %eax,%edx
80104281:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80104288:	21 d0                	and    %edx,%eax
8010428a:	0f b7 c0             	movzwl %ax,%eax
8010428d:	50                   	push   %eax
8010428e:	e8 94 ff ff ff       	call   80104227 <picsetmask>
80104293:	83 c4 04             	add    $0x4,%esp
}
80104296:	90                   	nop
80104297:	c9                   	leave  
80104298:	c3                   	ret    

80104299 <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80104299:	55                   	push   %ebp
8010429a:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
8010429c:	68 ff 00 00 00       	push   $0xff
801042a1:	6a 21                	push   $0x21
801042a3:	e8 60 ff ff ff       	call   80104208 <outb>
801042a8:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
801042ab:	68 ff 00 00 00       	push   $0xff
801042b0:	68 a1 00 00 00       	push   $0xa1
801042b5:	e8 4e ff ff ff       	call   80104208 <outb>
801042ba:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
801042bd:	6a 11                	push   $0x11
801042bf:	6a 20                	push   $0x20
801042c1:	e8 42 ff ff ff       	call   80104208 <outb>
801042c6:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
801042c9:	6a 20                	push   $0x20
801042cb:	6a 21                	push   $0x21
801042cd:	e8 36 ff ff ff       	call   80104208 <outb>
801042d2:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
801042d5:	6a 04                	push   $0x4
801042d7:	6a 21                	push   $0x21
801042d9:	e8 2a ff ff ff       	call   80104208 <outb>
801042de:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
801042e1:	6a 03                	push   $0x3
801042e3:	6a 21                	push   $0x21
801042e5:	e8 1e ff ff ff       	call   80104208 <outb>
801042ea:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
801042ed:	6a 11                	push   $0x11
801042ef:	68 a0 00 00 00       	push   $0xa0
801042f4:	e8 0f ff ff ff       	call   80104208 <outb>
801042f9:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
801042fc:	6a 28                	push   $0x28
801042fe:	68 a1 00 00 00       	push   $0xa1
80104303:	e8 00 ff ff ff       	call   80104208 <outb>
80104308:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
8010430b:	6a 02                	push   $0x2
8010430d:	68 a1 00 00 00       	push   $0xa1
80104312:	e8 f1 fe ff ff       	call   80104208 <outb>
80104317:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
8010431a:	6a 03                	push   $0x3
8010431c:	68 a1 00 00 00       	push   $0xa1
80104321:	e8 e2 fe ff ff       	call   80104208 <outb>
80104326:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80104329:	6a 68                	push   $0x68
8010432b:	6a 20                	push   $0x20
8010432d:	e8 d6 fe ff ff       	call   80104208 <outb>
80104332:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
80104335:	6a 0a                	push   $0xa
80104337:	6a 20                	push   $0x20
80104339:	e8 ca fe ff ff       	call   80104208 <outb>
8010433e:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80104341:	6a 68                	push   $0x68
80104343:	68 a0 00 00 00       	push   $0xa0
80104348:	e8 bb fe ff ff       	call   80104208 <outb>
8010434d:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80104350:	6a 0a                	push   $0xa
80104352:	68 a0 00 00 00       	push   $0xa0
80104357:	e8 ac fe ff ff       	call   80104208 <outb>
8010435c:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
8010435f:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80104366:	66 83 f8 ff          	cmp    $0xffff,%ax
8010436a:	74 13                	je     8010437f <picinit+0xe6>
    picsetmask(irqmask);
8010436c:	0f b7 05 00 d0 10 80 	movzwl 0x8010d000,%eax
80104373:	0f b7 c0             	movzwl %ax,%eax
80104376:	50                   	push   %eax
80104377:	e8 ab fe ff ff       	call   80104227 <picsetmask>
8010437c:	83 c4 04             	add    $0x4,%esp
}
8010437f:	90                   	nop
80104380:	c9                   	leave  
80104381:	c3                   	ret    

80104382 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104382:	55                   	push   %ebp
80104383:	89 e5                	mov    %esp,%ebp
80104385:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
80104388:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
8010438f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104392:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104398:	8b 45 0c             	mov    0xc(%ebp),%eax
8010439b:	8b 10                	mov    (%eax),%edx
8010439d:	8b 45 08             	mov    0x8(%ebp),%eax
801043a0:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801043a2:	e8 41 cd ff ff       	call   801010e8 <filealloc>
801043a7:	89 c2                	mov    %eax,%edx
801043a9:	8b 45 08             	mov    0x8(%ebp),%eax
801043ac:	89 10                	mov    %edx,(%eax)
801043ae:	8b 45 08             	mov    0x8(%ebp),%eax
801043b1:	8b 00                	mov    (%eax),%eax
801043b3:	85 c0                	test   %eax,%eax
801043b5:	0f 84 cb 00 00 00    	je     80104486 <pipealloc+0x104>
801043bb:	e8 28 cd ff ff       	call   801010e8 <filealloc>
801043c0:	89 c2                	mov    %eax,%edx
801043c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801043c5:	89 10                	mov    %edx,(%eax)
801043c7:	8b 45 0c             	mov    0xc(%ebp),%eax
801043ca:	8b 00                	mov    (%eax),%eax
801043cc:	85 c0                	test   %eax,%eax
801043ce:	0f 84 b2 00 00 00    	je     80104486 <pipealloc+0x104>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801043d4:	e8 ce eb ff ff       	call   80102fa7 <kalloc>
801043d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801043dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801043e0:	0f 84 9f 00 00 00    	je     80104485 <pipealloc+0x103>
    goto bad;
  p->readopen = 1;
801043e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e9:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801043f0:	00 00 00 
  p->writeopen = 1;
801043f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f6:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801043fd:	00 00 00 
  p->nwrite = 0;
80104400:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104403:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010440a:	00 00 00 
  p->nread = 0;
8010440d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104410:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104417:	00 00 00 
  initlock(&p->lock, "pipe");
8010441a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010441d:	83 ec 08             	sub    $0x8,%esp
80104420:	68 dc a3 10 80       	push   $0x8010a3dc
80104425:	50                   	push   %eax
80104426:	e8 93 24 00 00       	call   801068be <initlock>
8010442b:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
8010442e:	8b 45 08             	mov    0x8(%ebp),%eax
80104431:	8b 00                	mov    (%eax),%eax
80104433:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80104439:	8b 45 08             	mov    0x8(%ebp),%eax
8010443c:	8b 00                	mov    (%eax),%eax
8010443e:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104442:	8b 45 08             	mov    0x8(%ebp),%eax
80104445:	8b 00                	mov    (%eax),%eax
80104447:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010444b:	8b 45 08             	mov    0x8(%ebp),%eax
8010444e:	8b 00                	mov    (%eax),%eax
80104450:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104453:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104456:	8b 45 0c             	mov    0xc(%ebp),%eax
80104459:	8b 00                	mov    (%eax),%eax
8010445b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104461:	8b 45 0c             	mov    0xc(%ebp),%eax
80104464:	8b 00                	mov    (%eax),%eax
80104466:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010446a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010446d:	8b 00                	mov    (%eax),%eax
8010446f:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104473:	8b 45 0c             	mov    0xc(%ebp),%eax
80104476:	8b 00                	mov    (%eax),%eax
80104478:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010447b:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
8010447e:	b8 00 00 00 00       	mov    $0x0,%eax
80104483:	eb 4e                	jmp    801044d3 <pipealloc+0x151>
  p = 0;
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
80104485:	90                   	nop
  (*f1)->pipe = p;
  return 0;

//PAGEBREAK: 20
 bad:
  if(p)
80104486:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010448a:	74 0e                	je     8010449a <pipealloc+0x118>
    kfree((char*)p);
8010448c:	83 ec 0c             	sub    $0xc,%esp
8010448f:	ff 75 f4             	pushl  -0xc(%ebp)
80104492:	e8 73 ea ff ff       	call   80102f0a <kfree>
80104497:	83 c4 10             	add    $0x10,%esp
  if(*f0)
8010449a:	8b 45 08             	mov    0x8(%ebp),%eax
8010449d:	8b 00                	mov    (%eax),%eax
8010449f:	85 c0                	test   %eax,%eax
801044a1:	74 11                	je     801044b4 <pipealloc+0x132>
    fileclose(*f0);
801044a3:	8b 45 08             	mov    0x8(%ebp),%eax
801044a6:	8b 00                	mov    (%eax),%eax
801044a8:	83 ec 0c             	sub    $0xc,%esp
801044ab:	50                   	push   %eax
801044ac:	e8 f5 cc ff ff       	call   801011a6 <fileclose>
801044b1:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801044b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801044b7:	8b 00                	mov    (%eax),%eax
801044b9:	85 c0                	test   %eax,%eax
801044bb:	74 11                	je     801044ce <pipealloc+0x14c>
    fileclose(*f1);
801044bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801044c0:	8b 00                	mov    (%eax),%eax
801044c2:	83 ec 0c             	sub    $0xc,%esp
801044c5:	50                   	push   %eax
801044c6:	e8 db cc ff ff       	call   801011a6 <fileclose>
801044cb:	83 c4 10             	add    $0x10,%esp
  return -1;
801044ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801044d3:	c9                   	leave  
801044d4:	c3                   	ret    

801044d5 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801044d5:	55                   	push   %ebp
801044d6:	89 e5                	mov    %esp,%ebp
801044d8:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801044db:	8b 45 08             	mov    0x8(%ebp),%eax
801044de:	83 ec 0c             	sub    $0xc,%esp
801044e1:	50                   	push   %eax
801044e2:	e8 f9 23 00 00       	call   801068e0 <acquire>
801044e7:	83 c4 10             	add    $0x10,%esp
  if(writable){
801044ea:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801044ee:	74 23                	je     80104513 <pipeclose+0x3e>
    p->writeopen = 0;
801044f0:	8b 45 08             	mov    0x8(%ebp),%eax
801044f3:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801044fa:	00 00 00 
    wakeup(&p->nread);
801044fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104500:	05 34 02 00 00       	add    $0x234,%eax
80104505:	83 ec 0c             	sub    $0xc,%esp
80104508:	50                   	push   %eax
80104509:	e8 1d 13 00 00       	call   8010582b <wakeup>
8010450e:	83 c4 10             	add    $0x10,%esp
80104511:	eb 21                	jmp    80104534 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80104513:	8b 45 08             	mov    0x8(%ebp),%eax
80104516:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
8010451d:	00 00 00 
    wakeup(&p->nwrite);
80104520:	8b 45 08             	mov    0x8(%ebp),%eax
80104523:	05 38 02 00 00       	add    $0x238,%eax
80104528:	83 ec 0c             	sub    $0xc,%esp
8010452b:	50                   	push   %eax
8010452c:	e8 fa 12 00 00       	call   8010582b <wakeup>
80104531:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104534:	8b 45 08             	mov    0x8(%ebp),%eax
80104537:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
8010453d:	85 c0                	test   %eax,%eax
8010453f:	75 2c                	jne    8010456d <pipeclose+0x98>
80104541:	8b 45 08             	mov    0x8(%ebp),%eax
80104544:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010454a:	85 c0                	test   %eax,%eax
8010454c:	75 1f                	jne    8010456d <pipeclose+0x98>
    release(&p->lock);
8010454e:	8b 45 08             	mov    0x8(%ebp),%eax
80104551:	83 ec 0c             	sub    $0xc,%esp
80104554:	50                   	push   %eax
80104555:	e8 ed 23 00 00       	call   80106947 <release>
8010455a:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
8010455d:	83 ec 0c             	sub    $0xc,%esp
80104560:	ff 75 08             	pushl  0x8(%ebp)
80104563:	e8 a2 e9 ff ff       	call   80102f0a <kfree>
80104568:	83 c4 10             	add    $0x10,%esp
8010456b:	eb 0f                	jmp    8010457c <pipeclose+0xa7>
  } else
    release(&p->lock);
8010456d:	8b 45 08             	mov    0x8(%ebp),%eax
80104570:	83 ec 0c             	sub    $0xc,%esp
80104573:	50                   	push   %eax
80104574:	e8 ce 23 00 00       	call   80106947 <release>
80104579:	83 c4 10             	add    $0x10,%esp
}
8010457c:	90                   	nop
8010457d:	c9                   	leave  
8010457e:	c3                   	ret    

8010457f <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
8010457f:	55                   	push   %ebp
80104580:	89 e5                	mov    %esp,%ebp
80104582:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
80104585:	8b 45 08             	mov    0x8(%ebp),%eax
80104588:	83 ec 0c             	sub    $0xc,%esp
8010458b:	50                   	push   %eax
8010458c:	e8 4f 23 00 00       	call   801068e0 <acquire>
80104591:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
80104594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010459b:	e9 ad 00 00 00       	jmp    8010464d <pipewrite+0xce>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801045a0:	8b 45 08             	mov    0x8(%ebp),%eax
801045a3:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801045a9:	85 c0                	test   %eax,%eax
801045ab:	74 0d                	je     801045ba <pipewrite+0x3b>
801045ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045b3:	8b 40 24             	mov    0x24(%eax),%eax
801045b6:	85 c0                	test   %eax,%eax
801045b8:	74 19                	je     801045d3 <pipewrite+0x54>
        release(&p->lock);
801045ba:	8b 45 08             	mov    0x8(%ebp),%eax
801045bd:	83 ec 0c             	sub    $0xc,%esp
801045c0:	50                   	push   %eax
801045c1:	e8 81 23 00 00       	call   80106947 <release>
801045c6:	83 c4 10             	add    $0x10,%esp
        return -1;
801045c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045ce:	e9 a8 00 00 00       	jmp    8010467b <pipewrite+0xfc>
      }
      wakeup(&p->nread);
801045d3:	8b 45 08             	mov    0x8(%ebp),%eax
801045d6:	05 34 02 00 00       	add    $0x234,%eax
801045db:	83 ec 0c             	sub    $0xc,%esp
801045de:	50                   	push   %eax
801045df:	e8 47 12 00 00       	call   8010582b <wakeup>
801045e4:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801045e7:	8b 45 08             	mov    0x8(%ebp),%eax
801045ea:	8b 55 08             	mov    0x8(%ebp),%edx
801045ed:	81 c2 38 02 00 00    	add    $0x238,%edx
801045f3:	83 ec 08             	sub    $0x8,%esp
801045f6:	50                   	push   %eax
801045f7:	52                   	push   %edx
801045f8:	e8 55 10 00 00       	call   80105652 <sleep>
801045fd:	83 c4 10             	add    $0x10,%esp
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104600:	8b 45 08             	mov    0x8(%ebp),%eax
80104603:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104609:	8b 45 08             	mov    0x8(%ebp),%eax
8010460c:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104612:	05 00 02 00 00       	add    $0x200,%eax
80104617:	39 c2                	cmp    %eax,%edx
80104619:	74 85                	je     801045a0 <pipewrite+0x21>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010461b:	8b 45 08             	mov    0x8(%ebp),%eax
8010461e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104624:	8d 48 01             	lea    0x1(%eax),%ecx
80104627:	8b 55 08             	mov    0x8(%ebp),%edx
8010462a:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104630:	25 ff 01 00 00       	and    $0x1ff,%eax
80104635:	89 c1                	mov    %eax,%ecx
80104637:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010463a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010463d:	01 d0                	add    %edx,%eax
8010463f:	0f b6 10             	movzbl (%eax),%edx
80104642:	8b 45 08             	mov    0x8(%ebp),%eax
80104645:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80104649:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010464d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104650:	3b 45 10             	cmp    0x10(%ebp),%eax
80104653:	7c ab                	jl     80104600 <pipewrite+0x81>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80104655:	8b 45 08             	mov    0x8(%ebp),%eax
80104658:	05 34 02 00 00       	add    $0x234,%eax
8010465d:	83 ec 0c             	sub    $0xc,%esp
80104660:	50                   	push   %eax
80104661:	e8 c5 11 00 00       	call   8010582b <wakeup>
80104666:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104669:	8b 45 08             	mov    0x8(%ebp),%eax
8010466c:	83 ec 0c             	sub    $0xc,%esp
8010466f:	50                   	push   %eax
80104670:	e8 d2 22 00 00       	call   80106947 <release>
80104675:	83 c4 10             	add    $0x10,%esp
  return n;
80104678:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010467b:	c9                   	leave  
8010467c:	c3                   	ret    

8010467d <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010467d:	55                   	push   %ebp
8010467e:	89 e5                	mov    %esp,%ebp
80104680:	53                   	push   %ebx
80104681:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
80104684:	8b 45 08             	mov    0x8(%ebp),%eax
80104687:	83 ec 0c             	sub    $0xc,%esp
8010468a:	50                   	push   %eax
8010468b:	e8 50 22 00 00       	call   801068e0 <acquire>
80104690:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104693:	eb 3f                	jmp    801046d4 <piperead+0x57>
    if(proc->killed){
80104695:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010469b:	8b 40 24             	mov    0x24(%eax),%eax
8010469e:	85 c0                	test   %eax,%eax
801046a0:	74 19                	je     801046bb <piperead+0x3e>
      release(&p->lock);
801046a2:	8b 45 08             	mov    0x8(%ebp),%eax
801046a5:	83 ec 0c             	sub    $0xc,%esp
801046a8:	50                   	push   %eax
801046a9:	e8 99 22 00 00       	call   80106947 <release>
801046ae:	83 c4 10             	add    $0x10,%esp
      return -1;
801046b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046b6:	e9 bf 00 00 00       	jmp    8010477a <piperead+0xfd>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801046bb:	8b 45 08             	mov    0x8(%ebp),%eax
801046be:	8b 55 08             	mov    0x8(%ebp),%edx
801046c1:	81 c2 34 02 00 00    	add    $0x234,%edx
801046c7:	83 ec 08             	sub    $0x8,%esp
801046ca:	50                   	push   %eax
801046cb:	52                   	push   %edx
801046cc:	e8 81 0f 00 00       	call   80105652 <sleep>
801046d1:	83 c4 10             	add    $0x10,%esp
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801046d4:	8b 45 08             	mov    0x8(%ebp),%eax
801046d7:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801046dd:	8b 45 08             	mov    0x8(%ebp),%eax
801046e0:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801046e6:	39 c2                	cmp    %eax,%edx
801046e8:	75 0d                	jne    801046f7 <piperead+0x7a>
801046ea:	8b 45 08             	mov    0x8(%ebp),%eax
801046ed:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801046f3:	85 c0                	test   %eax,%eax
801046f5:	75 9e                	jne    80104695 <piperead+0x18>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801046f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801046fe:	eb 49                	jmp    80104749 <piperead+0xcc>
    if(p->nread == p->nwrite)
80104700:	8b 45 08             	mov    0x8(%ebp),%eax
80104703:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104709:	8b 45 08             	mov    0x8(%ebp),%eax
8010470c:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104712:	39 c2                	cmp    %eax,%edx
80104714:	74 3d                	je     80104753 <piperead+0xd6>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104716:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104719:	8b 45 0c             	mov    0xc(%ebp),%eax
8010471c:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010471f:	8b 45 08             	mov    0x8(%ebp),%eax
80104722:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104728:	8d 48 01             	lea    0x1(%eax),%ecx
8010472b:	8b 55 08             	mov    0x8(%ebp),%edx
8010472e:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104734:	25 ff 01 00 00       	and    $0x1ff,%eax
80104739:	89 c2                	mov    %eax,%edx
8010473b:	8b 45 08             	mov    0x8(%ebp),%eax
8010473e:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
80104743:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104745:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010474c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010474f:	7c af                	jl     80104700 <piperead+0x83>
80104751:	eb 01                	jmp    80104754 <piperead+0xd7>
    if(p->nread == p->nwrite)
      break;
80104753:	90                   	nop
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80104754:	8b 45 08             	mov    0x8(%ebp),%eax
80104757:	05 38 02 00 00       	add    $0x238,%eax
8010475c:	83 ec 0c             	sub    $0xc,%esp
8010475f:	50                   	push   %eax
80104760:	e8 c6 10 00 00       	call   8010582b <wakeup>
80104765:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104768:	8b 45 08             	mov    0x8(%ebp),%eax
8010476b:	83 ec 0c             	sub    $0xc,%esp
8010476e:	50                   	push   %eax
8010476f:	e8 d3 21 00 00       	call   80106947 <release>
80104774:	83 c4 10             	add    $0x10,%esp
  return i;
80104777:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010477a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010477d:	c9                   	leave  
8010477e:	c3                   	ret    

8010477f <hlt>:
}

// hlt() added by Noah Zentzis, Fall 2016.
static inline void
hlt()
{
8010477f:	55                   	push   %ebp
80104780:	89 e5                	mov    %esp,%ebp
  asm volatile("hlt");
80104782:	f4                   	hlt    
}
80104783:	90                   	nop
80104784:	5d                   	pop    %ebp
80104785:	c3                   	ret    

80104786 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104786:	55                   	push   %ebp
80104787:	89 e5                	mov    %esp,%ebp
80104789:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010478c:	9c                   	pushf  
8010478d:	58                   	pop    %eax
8010478e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104791:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104794:	c9                   	leave  
80104795:	c3                   	ret    

80104796 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104796:	55                   	push   %ebp
80104797:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104799:	fb                   	sti    
}
8010479a:	90                   	nop
8010479b:	5d                   	pop    %ebp
8010479c:	c3                   	ret    

8010479d <pinit>:
static int promote_list(struct proc** list);
#endif

void
pinit(void)
{
8010479d:	55                   	push   %ebp
8010479e:	89 e5                	mov    %esp,%ebp
801047a0:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801047a3:	83 ec 08             	sub    $0x8,%esp
801047a6:	68 e4 a3 10 80       	push   $0x8010a3e4
801047ab:	68 a0 49 11 80       	push   $0x801149a0
801047b0:	e8 09 21 00 00       	call   801068be <initlock>
801047b5:	83 c4 10             	add    $0x10,%esp
}
801047b8:	90                   	nop
801047b9:	c9                   	leave  
801047ba:	c3                   	ret    

801047bb <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801047bb:	55                   	push   %ebp
801047bc:	89 e5                	mov    %esp,%ebp
801047be:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801047c1:	83 ec 0c             	sub    $0xc,%esp
801047c4:	68 a0 49 11 80       	push   $0x801149a0
801047c9:	e8 12 21 00 00       	call   801068e0 <acquire>
801047ce:	83 c4 10             	add    $0x10,%esp
  #else
  // Check to make sure the ptable has free procs available
  // remove from list wont return a negative number in this
  // case because we check p and the list against null before
  // passing it in to the function. 
  p = ptable.pLists.free;
801047d1:	a1 d4 70 11 80       	mov    0x801170d4,%eax
801047d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (p) {
801047d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801047dd:	0f 84 86 00 00 00    	je     80104869 <allocproc+0xae>
    remove_from_list(&ptable.pLists.free, p);
801047e3:	83 ec 08             	sub    $0x8,%esp
801047e6:	ff 75 f4             	pushl  -0xc(%ebp)
801047e9:	68 d4 70 11 80       	push   $0x801170d4
801047ee:	e8 37 1a 00 00       	call   8010622a <remove_from_list>
801047f3:	83 c4 10             	add    $0x10,%esp
    assert_state(p, UNUSED);
801047f6:	83 ec 08             	sub    $0x8,%esp
801047f9:	6a 00                	push   $0x0
801047fb:	ff 75 f4             	pushl  -0xc(%ebp)
801047fe:	e8 06 1a 00 00       	call   80106209 <assert_state>
80104803:	83 c4 10             	add    $0x10,%esp
    goto found;
80104806:	90                   	nop
  #endif
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104807:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010480a:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  #ifdef CS333_P3P4
  // Process is checked against null before it reaches this function
  // so this function won't fail at this point.
  add_to_list(&ptable.pLists.embryo, EMBRYO, p);
80104811:	83 ec 04             	sub    $0x4,%esp
80104814:	ff 75 f4             	pushl  -0xc(%ebp)
80104817:	6a 01                	push   $0x1
80104819:	68 d8 70 11 80       	push   $0x801170d8
8010481e:	e8 b3 1a 00 00       	call   801062d6 <add_to_list>
80104823:	83 c4 10             	add    $0x10,%esp
  #endif
  p->pid = nextpid++;
80104826:	a1 04 d0 10 80       	mov    0x8010d004,%eax
8010482b:	8d 50 01             	lea    0x1(%eax),%edx
8010482e:	89 15 04 d0 10 80    	mov    %edx,0x8010d004
80104834:	89 c2                	mov    %eax,%edx
80104836:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104839:	89 50 10             	mov    %edx,0x10(%eax)
  release(&ptable.lock);
8010483c:	83 ec 0c             	sub    $0xc,%esp
8010483f:	68 a0 49 11 80       	push   $0x801149a0
80104844:	e8 fe 20 00 00       	call   80106947 <release>
80104849:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010484c:	e8 56 e7 ff ff       	call   80102fa7 <kalloc>
80104851:	89 c2                	mov    %eax,%edx
80104853:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104856:	89 50 08             	mov    %edx,0x8(%eax)
80104859:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010485c:	8b 40 08             	mov    0x8(%eax),%eax
8010485f:	85 c0                	test   %eax,%eax
80104861:	0f 85 88 00 00 00    	jne    801048ef <allocproc+0x134>
80104867:	eb 1a                	jmp    80104883 <allocproc+0xc8>
    remove_from_list(&ptable.pLists.free, p);
    assert_state(p, UNUSED);
    goto found;
  } 
  #endif
  release(&ptable.lock);
80104869:	83 ec 0c             	sub    $0xc,%esp
8010486c:	68 a0 49 11 80       	push   $0x801149a0
80104871:	e8 d1 20 00 00       	call   80106947 <release>
80104876:	83 c4 10             	add    $0x10,%esp
  return 0;
80104879:	b8 00 00 00 00       	mov    $0x0,%eax
8010487e:	e9 09 01 00 00       	jmp    8010498c <allocproc+0x1d1>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    acquire(&ptable.lock);
80104883:	83 ec 0c             	sub    $0xc,%esp
80104886:	68 a0 49 11 80       	push   $0x801149a0
8010488b:	e8 50 20 00 00       	call   801068e0 <acquire>
80104890:	83 c4 10             	add    $0x10,%esp
    #ifdef CS333_P3P4
    remove_from_list(&ptable.pLists.embryo, p);
80104893:	83 ec 08             	sub    $0x8,%esp
80104896:	ff 75 f4             	pushl  -0xc(%ebp)
80104899:	68 d8 70 11 80       	push   $0x801170d8
8010489e:	e8 87 19 00 00       	call   8010622a <remove_from_list>
801048a3:	83 c4 10             	add    $0x10,%esp
    assert_state(p, EMBRYO);
801048a6:	83 ec 08             	sub    $0x8,%esp
801048a9:	6a 01                	push   $0x1
801048ab:	ff 75 f4             	pushl  -0xc(%ebp)
801048ae:	e8 56 19 00 00       	call   80106209 <assert_state>
801048b3:	83 c4 10             	add    $0x10,%esp
    #endif
    p->state = UNUSED;
801048b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048b9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    #ifdef CS333_P3P4
    add_to_list(&ptable.pLists.free, UNUSED, p);
801048c0:	83 ec 04             	sub    $0x4,%esp
801048c3:	ff 75 f4             	pushl  -0xc(%ebp)
801048c6:	6a 00                	push   $0x0
801048c8:	68 d4 70 11 80       	push   $0x801170d4
801048cd:	e8 04 1a 00 00       	call   801062d6 <add_to_list>
801048d2:	83 c4 10             	add    $0x10,%esp
    #endif
    release(&ptable.lock);
801048d5:	83 ec 0c             	sub    $0xc,%esp
801048d8:	68 a0 49 11 80       	push   $0x801149a0
801048dd:	e8 65 20 00 00       	call   80106947 <release>
801048e2:	83 c4 10             	add    $0x10,%esp
    return 0;
801048e5:	b8 00 00 00 00       	mov    $0x0,%eax
801048ea:	e9 9d 00 00 00       	jmp    8010498c <allocproc+0x1d1>
  }
  sp = p->kstack + KSTACKSIZE;
801048ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801048f2:	8b 40 08             	mov    0x8(%eax),%eax
801048f5:	05 00 10 00 00       	add    $0x1000,%eax
801048fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801048fd:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
80104901:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104904:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104907:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
8010490a:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
8010490e:	ba d4 81 10 80       	mov    $0x801081d4,%edx
80104913:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104916:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
80104918:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
8010491c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010491f:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104922:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104925:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104928:	8b 40 1c             	mov    0x1c(%eax),%eax
8010492b:	83 ec 04             	sub    $0x4,%esp
8010492e:	6a 14                	push   $0x14
80104930:	6a 00                	push   $0x0
80104932:	50                   	push   %eax
80104933:	e8 0b 22 00 00       	call   80106b43 <memset>
80104938:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
8010493b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010493e:	8b 40 1c             	mov    0x1c(%eax),%eax
80104941:	ba 0c 56 10 80       	mov    $0x8010560c,%edx
80104946:	89 50 10             	mov    %edx,0x10(%eax)

  p->start_ticks = ticks; // My code Allocate start ticks to global ticks variable
80104949:	8b 15 20 79 11 80    	mov    0x80117920,%edx
8010494f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104952:	89 50 7c             	mov    %edx,0x7c(%eax)
  p->cpu_ticks_total = 0; // My code p2
80104955:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104958:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
8010495f:	00 00 00 
  p->cpu_ticks_in = 0;    // My code p2
80104962:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104965:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
8010496c:	00 00 00 
  #ifdef CS333_P3P4
  p->priority = 0;        // My code p4
8010496f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104972:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104979:	00 00 00 
  p->budget = DEFBUDGET;  // My code p4 TEST VAL
8010497c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010497f:	c7 80 94 00 00 00 f4 	movl   $0x1f4,0x94(%eax)
80104986:	01 00 00 
  #endif
  return p;
80104989:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010498c:	c9                   	leave  
8010498d:	c3                   	ret    

8010498e <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010498e:	55                   	push   %ebp
8010498f:	89 e5                	mov    %esp,%ebp
80104991:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  acquire(&ptable.lock);
80104994:	83 ec 0c             	sub    $0xc,%esp
80104997:	68 a0 49 11 80       	push   $0x801149a0
8010499c:	e8 3f 1f 00 00       	call   801068e0 <acquire>
801049a1:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.free = 0;
801049a4:	c7 05 d4 70 11 80 00 	movl   $0x0,0x801170d4
801049ab:	00 00 00 
  ptable.pLists.embryo = 0;
801049ae:	c7 05 d8 70 11 80 00 	movl   $0x0,0x801170d8
801049b5:	00 00 00 
  ptable.pLists.running = 0;
801049b8:	c7 05 f4 70 11 80 00 	movl   $0x0,0x801170f4
801049bf:	00 00 00 
  ptable.pLists.sleep = 0;
801049c2:	c7 05 f8 70 11 80 00 	movl   $0x0,0x801170f8
801049c9:	00 00 00 
  ptable.pLists.zombie = 0;
801049cc:	c7 05 fc 70 11 80 00 	movl   $0x0,0x801170fc
801049d3:	00 00 00 
  for (int i = 0; i < MAX+1; i++)
801049d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801049dd:	eb 17                	jmp    801049f6 <userinit+0x68>
    ptable.pLists.ready[i] = 0;
801049df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049e2:	05 cc 09 00 00       	add    $0x9cc,%eax
801049e7:	c7 04 85 ac 49 11 80 	movl   $0x0,-0x7feeb654(,%eax,4)
801049ee:	00 00 00 00 
  ptable.pLists.free = 0;
  ptable.pLists.embryo = 0;
  ptable.pLists.running = 0;
  ptable.pLists.sleep = 0;
  ptable.pLists.zombie = 0;
  for (int i = 0; i < MAX+1; i++)
801049f2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801049f6:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
801049fa:	7e e3                	jle    801049df <userinit+0x51>
    ptable.pLists.ready[i] = 0;

  // Loop through ptable adding procs to free
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801049fc:	c7 45 f4 d4 49 11 80 	movl   $0x801149d4,-0xc(%ebp)
80104a03:	eb 1c                	jmp    80104a21 <userinit+0x93>
    add_to_list(&ptable.pLists.free, UNUSED, p);  
80104a05:	83 ec 04             	sub    $0x4,%esp
80104a08:	ff 75 f4             	pushl  -0xc(%ebp)
80104a0b:	6a 00                	push   $0x0
80104a0d:	68 d4 70 11 80       	push   $0x801170d4
80104a12:	e8 bf 18 00 00       	call   801062d6 <add_to_list>
80104a17:	83 c4 10             	add    $0x10,%esp
  ptable.pLists.zombie = 0;
  for (int i = 0; i < MAX+1; i++)
    ptable.pLists.ready[i] = 0;

  // Loop through ptable adding procs to free
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a1a:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80104a21:	81 7d f4 d4 70 11 80 	cmpl   $0x801170d4,-0xc(%ebp)
80104a28:	72 db                	jb     80104a05 <userinit+0x77>
    add_to_list(&ptable.pLists.free, UNUSED, p);  

  ptable.promote_at_time = TICKS_TO_PROMOTE;                         // P4: Init promote time to 5 seconds..
80104a2a:	c7 05 00 71 11 80 20 	movl   $0x320,0x80117100
80104a31:	03 00 00 
  release(&ptable.lock);
80104a34:	83 ec 0c             	sub    $0xc,%esp
80104a37:	68 a0 49 11 80       	push   $0x801149a0
80104a3c:	e8 06 1f 00 00       	call   80106947 <release>
80104a41:	83 c4 10             	add    $0x10,%esp
  
  p = allocproc();
80104a44:	e8 72 fd ff ff       	call   801047bb <allocproc>
80104a49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a4f:	a3 88 d6 10 80       	mov    %eax,0x8010d688
  if((p->pgdir = setupkvm()) == 0)
80104a54:	e8 1a 4e 00 00       	call   80109873 <setupkvm>
80104a59:	89 c2                	mov    %eax,%edx
80104a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a5e:	89 50 04             	mov    %edx,0x4(%eax)
80104a61:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a64:	8b 40 04             	mov    0x4(%eax),%eax
80104a67:	85 c0                	test   %eax,%eax
80104a69:	75 0d                	jne    80104a78 <userinit+0xea>
    panic("userinit: out of memory?");
80104a6b:	83 ec 0c             	sub    $0xc,%esp
80104a6e:	68 eb a3 10 80       	push   $0x8010a3eb
80104a73:	e8 ee ba ff ff       	call   80100566 <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80104a78:	ba 2c 00 00 00       	mov    $0x2c,%edx
80104a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a80:	8b 40 04             	mov    0x4(%eax),%eax
80104a83:	83 ec 04             	sub    $0x4,%esp
80104a86:	52                   	push   %edx
80104a87:	68 20 d5 10 80       	push   $0x8010d520
80104a8c:	50                   	push   %eax
80104a8d:	e8 3b 50 00 00       	call   80109acd <inituvm>
80104a92:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a98:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aa1:	8b 40 18             	mov    0x18(%eax),%eax
80104aa4:	83 ec 04             	sub    $0x4,%esp
80104aa7:	6a 4c                	push   $0x4c
80104aa9:	6a 00                	push   $0x0
80104aab:	50                   	push   %eax
80104aac:	e8 92 20 00 00       	call   80106b43 <memset>
80104ab1:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104ab4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab7:	8b 40 18             	mov    0x18(%eax),%eax
80104aba:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104ac0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac3:	8b 40 18             	mov    0x18(%eax),%eax
80104ac6:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104acc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104acf:	8b 40 18             	mov    0x18(%eax),%eax
80104ad2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ad5:	8b 52 18             	mov    0x18(%edx),%edx
80104ad8:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104adc:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae3:	8b 40 18             	mov    0x18(%eax),%eax
80104ae6:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ae9:	8b 52 18             	mov    0x18(%edx),%edx
80104aec:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104af0:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80104af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af7:	8b 40 18             	mov    0x18(%eax),%eax
80104afa:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104b01:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b04:	8b 40 18             	mov    0x18(%eax),%eax
80104b07:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b11:	8b 40 18             	mov    0x18(%eax),%eax
80104b14:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  p->uid = DEFAULTUID; // p2
80104b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1e:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80104b25:	00 00 00 
  p->gid = DEFAULTGID; // p2
80104b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b2b:	c7 80 84 00 00 00 00 	movl   $0x0,0x84(%eax)
80104b32:	00 00 00 

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b38:	83 c0 6c             	add    $0x6c,%eax
80104b3b:	83 ec 04             	sub    $0x4,%esp
80104b3e:	6a 10                	push   $0x10
80104b40:	68 04 a4 10 80       	push   $0x8010a404
80104b45:	50                   	push   %eax
80104b46:	e8 fb 21 00 00       	call   80106d46 <safestrcpy>
80104b4b:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
80104b4e:	83 ec 0c             	sub    $0xc,%esp
80104b51:	68 0d a4 10 80       	push   $0x8010a40d
80104b56:	e8 9a db ff ff       	call   801026f5 <namei>
80104b5b:	83 c4 10             	add    $0x10,%esp
80104b5e:	89 c2                	mov    %eax,%edx
80104b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b63:	89 50 68             	mov    %edx,0x68(%eax)

  #ifdef CS333_P3P4
  acquire(&ptable.lock);
80104b66:	83 ec 0c             	sub    $0xc,%esp
80104b69:	68 a0 49 11 80       	push   $0x801149a0
80104b6e:	e8 6d 1d 00 00       	call   801068e0 <acquire>
80104b73:	83 c4 10             	add    $0x10,%esp
  remove_from_list(&ptable.pLists.embryo, p);
80104b76:	83 ec 08             	sub    $0x8,%esp
80104b79:	ff 75 f4             	pushl  -0xc(%ebp)
80104b7c:	68 d8 70 11 80       	push   $0x801170d8
80104b81:	e8 a4 16 00 00       	call   8010622a <remove_from_list>
80104b86:	83 c4 10             	add    $0x10,%esp
  assert_state(p, EMBRYO);
80104b89:	83 ec 08             	sub    $0x8,%esp
80104b8c:	6a 01                	push   $0x1
80104b8e:	ff 75 f4             	pushl  -0xc(%ebp)
80104b91:	e8 73 16 00 00       	call   80106209 <assert_state>
80104b96:	83 c4 10             	add    $0x10,%esp
  #endif
  p->state = RUNNABLE;
80104b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b9c:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #ifdef CS333_P3P4
  // Since it is the first process to be made I directly add to
  // the front of the ready list. Ocurrences after this use the
  // add to ready function.
  ptable.pLists.ready[0] = p;
80104ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ba6:	a3 dc 70 11 80       	mov    %eax,0x801170dc
  p->next = 0;
80104bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bae:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
80104bb5:	00 00 00 
  release(&ptable.lock);
80104bb8:	83 ec 0c             	sub    $0xc,%esp
80104bbb:	68 a0 49 11 80       	push   $0x801149a0
80104bc0:	e8 82 1d 00 00       	call   80106947 <release>
80104bc5:	83 c4 10             	add    $0x10,%esp
  #endif
}
80104bc8:	90                   	nop
80104bc9:	c9                   	leave  
80104bca:	c3                   	ret    

80104bcb <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
80104bcb:	55                   	push   %ebp
80104bcc:	89 e5                	mov    %esp,%ebp
80104bce:	83 ec 18             	sub    $0x18,%esp
  uint sz;
  
  sz = proc->sz;
80104bd1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bd7:	8b 00                	mov    (%eax),%eax
80104bd9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
80104bdc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104be0:	7e 31                	jle    80104c13 <growproc+0x48>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104be2:	8b 55 08             	mov    0x8(%ebp),%edx
80104be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104be8:	01 c2                	add    %eax,%edx
80104bea:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bf0:	8b 40 04             	mov    0x4(%eax),%eax
80104bf3:	83 ec 04             	sub    $0x4,%esp
80104bf6:	52                   	push   %edx
80104bf7:	ff 75 f4             	pushl  -0xc(%ebp)
80104bfa:	50                   	push   %eax
80104bfb:	e8 1a 50 00 00       	call   80109c1a <allocuvm>
80104c00:	83 c4 10             	add    $0x10,%esp
80104c03:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104c06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104c0a:	75 3e                	jne    80104c4a <growproc+0x7f>
      return -1;
80104c0c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c11:	eb 59                	jmp    80104c6c <growproc+0xa1>
  } else if(n < 0){
80104c13:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104c17:	79 31                	jns    80104c4a <growproc+0x7f>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
80104c19:	8b 55 08             	mov    0x8(%ebp),%edx
80104c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c1f:	01 c2                	add    %eax,%edx
80104c21:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c27:	8b 40 04             	mov    0x4(%eax),%eax
80104c2a:	83 ec 04             	sub    $0x4,%esp
80104c2d:	52                   	push   %edx
80104c2e:	ff 75 f4             	pushl  -0xc(%ebp)
80104c31:	50                   	push   %eax
80104c32:	e8 ac 50 00 00       	call   80109ce3 <deallocuvm>
80104c37:	83 c4 10             	add    $0x10,%esp
80104c3a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104c3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104c41:	75 07                	jne    80104c4a <growproc+0x7f>
      return -1;
80104c43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c48:	eb 22                	jmp    80104c6c <growproc+0xa1>
  }
  proc->sz = sz;
80104c4a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c50:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c53:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
80104c55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c5b:	83 ec 0c             	sub    $0xc,%esp
80104c5e:	50                   	push   %eax
80104c5f:	e8 f6 4c 00 00       	call   8010995a <switchuvm>
80104c64:	83 c4 10             	add    $0x10,%esp
  return 0;
80104c67:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c6c:	c9                   	leave  
80104c6d:	c3                   	ret    

80104c6e <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104c6e:	55                   	push   %ebp
80104c6f:	89 e5                	mov    %esp,%ebp
80104c71:	57                   	push   %edi
80104c72:	56                   	push   %esi
80104c73:	53                   	push   %ebx
80104c74:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
80104c77:	e8 3f fb ff ff       	call   801047bb <allocproc>
80104c7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104c7f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104c83:	75 0a                	jne    80104c8f <fork+0x21>
    return -1;
80104c85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c8a:	e9 4d 02 00 00       	jmp    80104edc <fork+0x26e>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104c8f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c95:	8b 10                	mov    (%eax),%edx
80104c97:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c9d:	8b 40 04             	mov    0x4(%eax),%eax
80104ca0:	83 ec 08             	sub    $0x8,%esp
80104ca3:	52                   	push   %edx
80104ca4:	50                   	push   %eax
80104ca5:	e8 d7 51 00 00       	call   80109e81 <copyuvm>
80104caa:	83 c4 10             	add    $0x10,%esp
80104cad:	89 c2                	mov    %eax,%edx
80104caf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104cb2:	89 50 04             	mov    %edx,0x4(%eax)
80104cb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104cb8:	8b 40 04             	mov    0x4(%eax),%eax
80104cbb:	85 c0                	test   %eax,%eax
80104cbd:	0f 85 b4 00 00 00    	jne    80104d77 <fork+0x109>
    kfree(np->kstack);
80104cc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104cc6:	8b 40 08             	mov    0x8(%eax),%eax
80104cc9:	83 ec 0c             	sub    $0xc,%esp
80104ccc:	50                   	push   %eax
80104ccd:	e8 38 e2 ff ff       	call   80102f0a <kfree>
80104cd2:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104cd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104cd8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    #ifdef CS333_P3P4
    acquire(&ptable.lock);
80104cdf:	83 ec 0c             	sub    $0xc,%esp
80104ce2:	68 a0 49 11 80       	push   $0x801149a0
80104ce7:	e8 f4 1b 00 00       	call   801068e0 <acquire>
80104cec:	83 c4 10             	add    $0x10,%esp
    int code = remove_from_list(&ptable.pLists.embryo, np);
80104cef:	83 ec 08             	sub    $0x8,%esp
80104cf2:	ff 75 e0             	pushl  -0x20(%ebp)
80104cf5:	68 d8 70 11 80       	push   $0x801170d8
80104cfa:	e8 2b 15 00 00       	call   8010622a <remove_from_list>
80104cff:	83 c4 10             	add    $0x10,%esp
80104d02:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (code < 0)
80104d05:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
80104d09:	79 0d                	jns    80104d18 <fork+0xaa>
      panic("ERROR: Couldn't remove from embryo.");
80104d0b:	83 ec 0c             	sub    $0xc,%esp
80104d0e:	68 10 a4 10 80       	push   $0x8010a410
80104d13:	e8 4e b8 ff ff       	call   80100566 <panic>
    assert_state(np, EMBRYO);
80104d18:	83 ec 08             	sub    $0x8,%esp
80104d1b:	6a 01                	push   $0x1
80104d1d:	ff 75 e0             	pushl  -0x20(%ebp)
80104d20:	e8 e4 14 00 00       	call   80106209 <assert_state>
80104d25:	83 c4 10             	add    $0x10,%esp
    #endif
    np->state = UNUSED;
80104d28:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d2b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    #ifdef CS333_P3P4
    int code2 = add_to_list(&ptable.pLists.free, UNUSED, np);
80104d32:	83 ec 04             	sub    $0x4,%esp
80104d35:	ff 75 e0             	pushl  -0x20(%ebp)
80104d38:	6a 00                	push   $0x0
80104d3a:	68 d4 70 11 80       	push   $0x801170d4
80104d3f:	e8 92 15 00 00       	call   801062d6 <add_to_list>
80104d44:	83 c4 10             	add    $0x10,%esp
80104d47:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if (code2 < 0)
80104d4a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80104d4e:	79 0d                	jns    80104d5d <fork+0xef>
      panic("ERROR: Couldn't add process back to free.");
80104d50:	83 ec 0c             	sub    $0xc,%esp
80104d53:	68 34 a4 10 80       	push   $0x8010a434
80104d58:	e8 09 b8 ff ff       	call   80100566 <panic>
    release(&ptable.lock);
80104d5d:	83 ec 0c             	sub    $0xc,%esp
80104d60:	68 a0 49 11 80       	push   $0x801149a0
80104d65:	e8 dd 1b 00 00       	call   80106947 <release>
80104d6a:	83 c4 10             	add    $0x10,%esp
    #endif
    return -1;
80104d6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d72:	e9 65 01 00 00       	jmp    80104edc <fork+0x26e>
  }
  np->sz = proc->sz;
80104d77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d7d:	8b 10                	mov    (%eax),%edx
80104d7f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d82:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
80104d84:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d8e:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104d91:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104d94:	8b 50 18             	mov    0x18(%eax),%edx
80104d97:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d9d:	8b 40 18             	mov    0x18(%eax),%eax
80104da0:	89 c3                	mov    %eax,%ebx
80104da2:	b8 13 00 00 00       	mov    $0x13,%eax
80104da7:	89 d7                	mov    %edx,%edi
80104da9:	89 de                	mov    %ebx,%esi
80104dab:	89 c1                	mov    %eax,%ecx
80104dad:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  // I'm pretty sure that this is where we put the uid/gid copy
  np -> uid = proc -> uid; // p2
80104daf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104db5:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80104dbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104dbe:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  np -> gid = proc -> gid; // p2
80104dc4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dca:	8b 90 84 00 00 00    	mov    0x84(%eax),%edx
80104dd0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104dd3:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104dd9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ddc:	8b 40 18             	mov    0x18(%eax),%eax
80104ddf:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104de6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104ded:	eb 43                	jmp    80104e32 <fork+0x1c4>
    if(proc->ofile[i])
80104def:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104df5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104df8:	83 c2 08             	add    $0x8,%edx
80104dfb:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104dff:	85 c0                	test   %eax,%eax
80104e01:	74 2b                	je     80104e2e <fork+0x1c0>
      np->ofile[i] = filedup(proc->ofile[i]);
80104e03:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e09:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104e0c:	83 c2 08             	add    $0x8,%edx
80104e0f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104e13:	83 ec 0c             	sub    $0xc,%esp
80104e16:	50                   	push   %eax
80104e17:	e8 39 c3 ff ff       	call   80101155 <filedup>
80104e1c:	83 c4 10             	add    $0x10,%esp
80104e1f:	89 c1                	mov    %eax,%ecx
80104e21:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e24:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104e27:	83 c2 08             	add    $0x8,%edx
80104e2a:	89 4c 90 08          	mov    %ecx,0x8(%eax,%edx,4)
  np -> gid = proc -> gid; // p2

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104e2e:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104e32:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
80104e36:	7e b7                	jle    80104def <fork+0x181>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
80104e38:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e3e:	8b 40 68             	mov    0x68(%eax),%eax
80104e41:	83 ec 0c             	sub    $0xc,%esp
80104e44:	50                   	push   %eax
80104e45:	e8 63 cc ff ff       	call   80101aad <idup>
80104e4a:	83 c4 10             	add    $0x10,%esp
80104e4d:	89 c2                	mov    %eax,%edx
80104e4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e52:	89 50 68             	mov    %edx,0x68(%eax)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104e55:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e5b:	8d 50 6c             	lea    0x6c(%eax),%edx
80104e5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e61:	83 c0 6c             	add    $0x6c,%eax
80104e64:	83 ec 04             	sub    $0x4,%esp
80104e67:	6a 10                	push   $0x10
80104e69:	52                   	push   %edx
80104e6a:	50                   	push   %eax
80104e6b:	e8 d6 1e 00 00       	call   80106d46 <safestrcpy>
80104e70:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
80104e73:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e76:	8b 40 10             	mov    0x10(%eax),%eax
80104e79:	89 45 d4             	mov    %eax,-0x2c(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104e7c:	83 ec 0c             	sub    $0xc,%esp
80104e7f:	68 a0 49 11 80       	push   $0x801149a0
80104e84:	e8 57 1a 00 00       	call   801068e0 <acquire>
80104e89:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.embryo, np);
80104e8c:	83 ec 08             	sub    $0x8,%esp
80104e8f:	ff 75 e0             	pushl  -0x20(%ebp)
80104e92:	68 d8 70 11 80       	push   $0x801170d8
80104e97:	e8 8e 13 00 00       	call   8010622a <remove_from_list>
80104e9c:	83 c4 10             	add    $0x10,%esp
  assert_state(np, EMBRYO);
80104e9f:	83 ec 08             	sub    $0x8,%esp
80104ea2:	6a 01                	push   $0x1
80104ea4:	ff 75 e0             	pushl  -0x20(%ebp)
80104ea7:	e8 5d 13 00 00       	call   80106209 <assert_state>
80104eac:	83 c4 10             	add    $0x10,%esp
  #endif
  np->state = RUNNABLE;
80104eaf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104eb2:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #ifdef CS333_P3P4
  add_to_ready(np, RUNNABLE);
80104eb9:	83 ec 08             	sub    $0x8,%esp
80104ebc:	6a 03                	push   $0x3
80104ebe:	ff 75 e0             	pushl  -0x20(%ebp)
80104ec1:	e8 51 14 00 00       	call   80106317 <add_to_ready>
80104ec6:	83 c4 10             	add    $0x10,%esp
  #endif
  release(&ptable.lock);
80104ec9:	83 ec 0c             	sub    $0xc,%esp
80104ecc:	68 a0 49 11 80       	push   $0x801149a0
80104ed1:	e8 71 1a 00 00       	call   80106947 <release>
80104ed6:	83 c4 10             	add    $0x10,%esp
  return pid;
80104ed9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
80104edc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104edf:	5b                   	pop    %ebx
80104ee0:	5e                   	pop    %esi
80104ee1:	5f                   	pop    %edi
80104ee2:	5d                   	pop    %ebp
80104ee3:	c3                   	ret    

80104ee4 <exit>:
}

#else
void
exit(void)
{
80104ee4:	55                   	push   %ebp
80104ee5:	89 e5                	mov    %esp,%ebp
80104ee7:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int fd;

  if (proc == initproc)
80104eea:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ef1:	a1 88 d6 10 80       	mov    0x8010d688,%eax
80104ef6:	39 c2                	cmp    %eax,%edx
80104ef8:	75 0d                	jne    80104f07 <exit+0x23>
    panic("init exiting");
80104efa:	83 ec 0c             	sub    $0xc,%esp
80104efd:	68 5e a4 10 80       	push   $0x8010a45e
80104f02:	e8 5f b6 ff ff       	call   80100566 <panic>

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++) {
80104f07:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104f0e:	eb 48                	jmp    80104f58 <exit+0x74>
    if(proc->ofile[fd]) {
80104f10:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f16:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f19:	83 c2 08             	add    $0x8,%edx
80104f1c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104f20:	85 c0                	test   %eax,%eax
80104f22:	74 30                	je     80104f54 <exit+0x70>
      fileclose(proc->ofile[fd]);
80104f24:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f2d:	83 c2 08             	add    $0x8,%edx
80104f30:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104f34:	83 ec 0c             	sub    $0xc,%esp
80104f37:	50                   	push   %eax
80104f38:	e8 69 c2 ff ff       	call   801011a6 <fileclose>
80104f3d:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
80104f40:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f46:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104f49:	83 c2 08             	add    $0x8,%edx
80104f4c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80104f53:	00 

  if (proc == initproc)
    panic("init exiting");

  // Close all open files.
  for (fd = 0; fd < NOFILE; fd++) {
80104f54:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80104f58:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
80104f5c:	7e b2                	jle    80104f10 <exit+0x2c>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
80104f5e:	e8 2b e9 ff ff       	call   8010388e <begin_op>
  iput(proc->cwd);
80104f63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f69:	8b 40 68             	mov    0x68(%eax),%eax
80104f6c:	83 ec 0c             	sub    $0xc,%esp
80104f6f:	50                   	push   %eax
80104f70:	e8 6a cd ff ff       	call   80101cdf <iput>
80104f75:	83 c4 10             	add    $0x10,%esp
  end_op();
80104f78:	e8 9d e9 ff ff       	call   8010391a <end_op>
  proc->cwd = 0;
80104f7d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f83:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104f8a:	83 ec 0c             	sub    $0xc,%esp
80104f8d:	68 a0 49 11 80       	push   $0x801149a0
80104f92:	e8 49 19 00 00       	call   801068e0 <acquire>
80104f97:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104f9a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104fa0:	8b 40 14             	mov    0x14(%eax),%eax
80104fa3:	83 ec 0c             	sub    $0xc,%esp
80104fa6:	50                   	push   %eax
80104fa7:	e8 12 08 00 00       	call   801057be <wakeup1>
80104fac:	83 c4 10             	add    $0x10,%esp

  // Run exit helper to check process parents against the
  // currently running process. 
  exit_helper(&ptable.pLists.embryo);
80104faf:	83 ec 0c             	sub    $0xc,%esp
80104fb2:	68 d8 70 11 80       	push   $0x801170d8
80104fb7:	e8 2c 14 00 00       	call   801063e8 <exit_helper>
80104fbc:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < MAX+1; i++)
80104fbf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80104fc6:	eb 23                	jmp    80104feb <exit+0x107>
    exit_helper(&ptable.pLists.ready[i]);
80104fc8:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104fcb:	05 cc 09 00 00       	add    $0x9cc,%eax
80104fd0:	c1 e0 02             	shl    $0x2,%eax
80104fd3:	05 a0 49 11 80       	add    $0x801149a0,%eax
80104fd8:	83 c0 0c             	add    $0xc,%eax
80104fdb:	83 ec 0c             	sub    $0xc,%esp
80104fde:	50                   	push   %eax
80104fdf:	e8 04 14 00 00       	call   801063e8 <exit_helper>
80104fe4:	83 c4 10             	add    $0x10,%esp
  wakeup1(proc->parent);

  // Run exit helper to check process parents against the
  // currently running process. 
  exit_helper(&ptable.pLists.embryo);
  for (int i = 0; i < MAX+1; i++)
80104fe7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80104feb:	83 7d ec 05          	cmpl   $0x5,-0x14(%ebp)
80104fef:	7e d7                	jle    80104fc8 <exit+0xe4>
    exit_helper(&ptable.pLists.ready[i]);
  exit_helper(&ptable.pLists.running);
80104ff1:	83 ec 0c             	sub    $0xc,%esp
80104ff4:	68 f4 70 11 80       	push   $0x801170f4
80104ff9:	e8 ea 13 00 00       	call   801063e8 <exit_helper>
80104ffe:	83 c4 10             	add    $0x10,%esp
  exit_helper(&ptable.pLists.sleep);
80105001:	83 ec 0c             	sub    $0xc,%esp
80105004:	68 f8 70 11 80       	push   $0x801170f8
80105009:	e8 da 13 00 00       	call   801063e8 <exit_helper>
8010500e:	83 c4 10             	add    $0x10,%esp

  // Search zombie list separately due to the potential need
  // to wake up initproc as well.
  p = ptable.pLists.zombie;
80105011:	a1 fc 70 11 80       	mov    0x801170fc,%eax
80105016:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
80105019:	eb 39                	jmp    80105054 <exit+0x170>
    if (p->parent == proc) {
8010501b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010501e:	8b 50 14             	mov    0x14(%eax),%edx
80105021:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105027:	39 c2                	cmp    %eax,%edx
80105029:	75 1d                	jne    80105048 <exit+0x164>
      p->parent = initproc;
8010502b:	8b 15 88 d6 10 80    	mov    0x8010d688,%edx
80105031:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105034:	89 50 14             	mov    %edx,0x14(%eax)
      wakeup1(initproc);
80105037:	a1 88 d6 10 80       	mov    0x8010d688,%eax
8010503c:	83 ec 0c             	sub    $0xc,%esp
8010503f:	50                   	push   %eax
80105040:	e8 79 07 00 00       	call   801057be <wakeup1>
80105045:	83 c4 10             	add    $0x10,%esp
    }
    p = p->next;
80105048:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010504b:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105051:	89 45 f4             	mov    %eax,-0xc(%ebp)
  exit_helper(&ptable.pLists.sleep);

  // Search zombie list separately due to the potential need
  // to wake up initproc as well.
  p = ptable.pLists.zombie;
  while (p) {
80105054:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105058:	75 c1                	jne    8010501b <exit+0x137>
      wakeup1(initproc);
    }
    p = p->next;
  }

  remove_from_list(&ptable.pLists.running, proc);
8010505a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105060:	83 ec 08             	sub    $0x8,%esp
80105063:	50                   	push   %eax
80105064:	68 f4 70 11 80       	push   $0x801170f4
80105069:	e8 bc 11 00 00       	call   8010622a <remove_from_list>
8010506e:	83 c4 10             	add    $0x10,%esp
  assert_state(proc, RUNNING);
80105071:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105077:	83 ec 08             	sub    $0x8,%esp
8010507a:	6a 04                	push   $0x4
8010507c:	50                   	push   %eax
8010507d:	e8 87 11 00 00       	call   80106209 <assert_state>
80105082:	83 c4 10             	add    $0x10,%esp
  proc->state = ZOMBIE;
80105085:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010508b:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  add_to_list(&ptable.pLists.zombie, ZOMBIE, proc);
80105092:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105098:	83 ec 04             	sub    $0x4,%esp
8010509b:	50                   	push   %eax
8010509c:	6a 05                	push   $0x5
8010509e:	68 fc 70 11 80       	push   $0x801170fc
801050a3:	e8 2e 12 00 00       	call   801062d6 <add_to_list>
801050a8:	83 c4 10             	add    $0x10,%esp
  sched();
801050ab:	e8 6d 03 00 00       	call   8010541d <sched>
  panic("zombie exit");
801050b0:	83 ec 0c             	sub    $0xc,%esp
801050b3:	68 6b a4 10 80       	push   $0x8010a46b
801050b8:	e8 a9 b4 ff ff       	call   80100566 <panic>

801050bd <wait>:
}

#else
int
wait(void)
{
801050bd:	55                   	push   %ebp
801050be:	89 e5                	mov    %esp,%ebp
801050c0:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int havekids, pid;

  acquire(&ptable.lock);
801050c3:	83 ec 0c             	sub    $0xc,%esp
801050c6:	68 a0 49 11 80       	push   $0x801149a0
801050cb:	e8 10 18 00 00       	call   801068e0 <acquire>
801050d0:	83 c4 10             	add    $0x10,%esp
  for(;;) {
    // Scan through table looking for zombie children
    havekids = 0;
801050d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

    // Search zombie list separately due to the potential need
    // to deallocate the process and move it to the free list.
    p = ptable.pLists.zombie;
801050da:	a1 fc 70 11 80       	mov    0x801170fc,%eax
801050df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
801050e2:	e9 f7 00 00 00       	jmp    801051de <wait+0x121>
      if (p->parent == proc) {
801050e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050ea:	8b 50 14             	mov    0x14(%eax),%edx
801050ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801050f3:	39 c2                	cmp    %eax,%edx
801050f5:	0f 85 d7 00 00 00    	jne    801051d2 <wait+0x115>
        havekids = 1;
801050fb:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
        // Found one.
        pid = p->pid;
80105102:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105105:	8b 40 10             	mov    0x10(%eax),%eax
80105108:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
8010510b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010510e:	8b 40 08             	mov    0x8(%eax),%eax
80105111:	83 ec 0c             	sub    $0xc,%esp
80105114:	50                   	push   %eax
80105115:	e8 f0 dd ff ff       	call   80102f0a <kfree>
8010511a:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
8010511d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105120:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80105127:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010512a:	8b 40 04             	mov    0x4(%eax),%eax
8010512d:	83 ec 0c             	sub    $0xc,%esp
80105130:	50                   	push   %eax
80105131:	e8 6a 4c 00 00       	call   80109da0 <freevm>
80105136:	83 c4 10             	add    $0x10,%esp
        remove_from_list(&ptable.pLists.zombie, p);
80105139:	83 ec 08             	sub    $0x8,%esp
8010513c:	ff 75 f4             	pushl  -0xc(%ebp)
8010513f:	68 fc 70 11 80       	push   $0x801170fc
80105144:	e8 e1 10 00 00       	call   8010622a <remove_from_list>
80105149:	83 c4 10             	add    $0x10,%esp
        assert_state(p, ZOMBIE);
8010514c:	83 ec 08             	sub    $0x8,%esp
8010514f:	6a 05                	push   $0x5
80105151:	ff 75 f4             	pushl  -0xc(%ebp)
80105154:	e8 b0 10 00 00       	call   80106209 <assert_state>
80105159:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
8010515c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010515f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80105166:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105169:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80105170:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105173:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
8010517a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010517d:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80105181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105184:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        p->priority = 0;
8010518b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010518e:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80105195:	00 00 00 
        p->budget = 0;
80105198:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010519b:	c7 80 94 00 00 00 00 	movl   $0x0,0x94(%eax)
801051a2:	00 00 00 
        add_to_list(&ptable.pLists.free, UNUSED, p);
801051a5:	83 ec 04             	sub    $0x4,%esp
801051a8:	ff 75 f4             	pushl  -0xc(%ebp)
801051ab:	6a 00                	push   $0x0
801051ad:	68 d4 70 11 80       	push   $0x801170d4
801051b2:	e8 1f 11 00 00       	call   801062d6 <add_to_list>
801051b7:	83 c4 10             	add    $0x10,%esp
        release(&ptable.lock);
801051ba:	83 ec 0c             	sub    $0xc,%esp
801051bd:	68 a0 49 11 80       	push   $0x801149a0
801051c2:	e8 80 17 00 00       	call   80106947 <release>
801051c7:	83 c4 10             	add    $0x10,%esp
        return pid;
801051ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
801051cd:	e9 cf 00 00 00       	jmp    801052a1 <wait+0x1e4>
      }
      p = p->next;
801051d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051d5:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801051db:	89 45 f4             	mov    %eax,-0xc(%ebp)
    havekids = 0;

    // Search zombie list separately due to the potential need
    // to deallocate the process and move it to the free list.
    p = ptable.pLists.zombie;
    while (p) {
801051de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801051e2:	0f 85 ff fe ff ff    	jne    801050e7 <wait+0x2a>
    }

    // Run wait helper function to search each list and check
    // if process parent is the currently running process and
    // set havekids to 1 if that is the case.
    wait_helper(&ptable.pLists.embryo, &havekids);
801051e8:	83 ec 08             	sub    $0x8,%esp
801051eb:	8d 45 e8             	lea    -0x18(%ebp),%eax
801051ee:	50                   	push   %eax
801051ef:	68 d8 70 11 80       	push   $0x801170d8
801051f4:	e8 30 12 00 00       	call   80106429 <wait_helper>
801051f9:	83 c4 10             	add    $0x10,%esp
    for (int i = 0; i < MAX+1; i++)
801051fc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80105203:	eb 27                	jmp    8010522c <wait+0x16f>
      wait_helper(&ptable.pLists.ready[i], &havekids);
80105205:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105208:	05 cc 09 00 00       	add    $0x9cc,%eax
8010520d:	c1 e0 02             	shl    $0x2,%eax
80105210:	05 a0 49 11 80       	add    $0x801149a0,%eax
80105215:	8d 50 0c             	lea    0xc(%eax),%edx
80105218:	83 ec 08             	sub    $0x8,%esp
8010521b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010521e:	50                   	push   %eax
8010521f:	52                   	push   %edx
80105220:	e8 04 12 00 00       	call   80106429 <wait_helper>
80105225:	83 c4 10             	add    $0x10,%esp

    // Run wait helper function to search each list and check
    // if process parent is the currently running process and
    // set havekids to 1 if that is the case.
    wait_helper(&ptable.pLists.embryo, &havekids);
    for (int i = 0; i < MAX+1; i++)
80105228:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
8010522c:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
80105230:	7e d3                	jle    80105205 <wait+0x148>
      wait_helper(&ptable.pLists.ready[i], &havekids);
    wait_helper(&ptable.pLists.running, &havekids);
80105232:	83 ec 08             	sub    $0x8,%esp
80105235:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105238:	50                   	push   %eax
80105239:	68 f4 70 11 80       	push   $0x801170f4
8010523e:	e8 e6 11 00 00       	call   80106429 <wait_helper>
80105243:	83 c4 10             	add    $0x10,%esp
    wait_helper(&ptable.pLists.sleep, &havekids);
80105246:	83 ec 08             	sub    $0x8,%esp
80105249:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010524c:	50                   	push   %eax
8010524d:	68 f8 70 11 80       	push   $0x801170f8
80105252:	e8 d2 11 00 00       	call   80106429 <wait_helper>
80105257:	83 c4 10             	add    $0x10,%esp

    // No point waiting if we don't have any children
    if (!havekids || proc->killed) {
8010525a:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010525d:	85 c0                	test   %eax,%eax
8010525f:	74 0d                	je     8010526e <wait+0x1b1>
80105261:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105267:	8b 40 24             	mov    0x24(%eax),%eax
8010526a:	85 c0                	test   %eax,%eax
8010526c:	74 17                	je     80105285 <wait+0x1c8>
      release(&ptable.lock);
8010526e:	83 ec 0c             	sub    $0xc,%esp
80105271:	68 a0 49 11 80       	push   $0x801149a0
80105276:	e8 cc 16 00 00       	call   80106947 <release>
8010527b:	83 c4 10             	add    $0x10,%esp
      return -1;
8010527e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105283:	eb 1c                	jmp    801052a1 <wait+0x1e4>
    }

    // Wait for children to exit. (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80105285:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010528b:	83 ec 08             	sub    $0x8,%esp
8010528e:	68 a0 49 11 80       	push   $0x801149a0
80105293:	50                   	push   %eax
80105294:	e8 b9 03 00 00       	call   80105652 <sleep>
80105299:	83 c4 10             	add    $0x10,%esp
  }
8010529c:	e9 32 fe ff ff       	jmp    801050d3 <wait+0x16>
}
801052a1:	c9                   	leave  
801052a2:	c3                   	ret    

801052a3 <scheduler>:
}

#else
void
scheduler(void)
{
801052a3:	55                   	push   %ebp
801052a4:	89 e5                	mov    %esp,%ebp
801052a6:	83 ec 18             	sub    $0x18,%esp
  struct proc* p = 0;
801052a9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  int idle;  // for checking if processor is idle

  for(;;) {

    // Enable interrupts on this processor.
    sti();
801052b0:	e8 e1 f4 ff ff       	call   80104796 <sti>
    idle = 1;   // assume idle unless we schedule a process
801052b5:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    
    acquire(&ptable.lock); 
801052bc:	83 ec 0c             	sub    $0xc,%esp
801052bf:	68 a0 49 11 80       	push   $0x801149a0
801052c4:	e8 17 16 00 00       	call   801068e0 <acquire>
801052c9:	83 c4 10             	add    $0x10,%esp

    for (int i = 0; i < MAX+1; i++) {
801052cc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801052d3:	e9 12 01 00 00       	jmp    801053ea <scheduler+0x147>
      if (!ptable.pLists.ready[i])
801052d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052db:	05 cc 09 00 00       	add    $0x9cc,%eax
801052e0:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
801052e7:	85 c0                	test   %eax,%eax
801052e9:	0f 84 f6 00 00 00    	je     801053e5 <scheduler+0x142>
        continue;
      if (ticks == ptable.promote_at_time) {
801052ef:	8b 15 00 71 11 80    	mov    0x80117100,%edx
801052f5:	a1 20 79 11 80       	mov    0x80117920,%eax
801052fa:	39 c2                	cmp    %eax,%edx
801052fc:	75 14                	jne    80105312 <scheduler+0x6f>
        priority_promotion();
801052fe:	e8 ca 13 00 00       	call   801066cd <priority_promotion>
        ptable.promote_at_time = ticks + TICKS_TO_PROMOTE;
80105303:	a1 20 79 11 80       	mov    0x80117920,%eax
80105308:	05 20 03 00 00       	add    $0x320,%eax
8010530d:	a3 00 71 11 80       	mov    %eax,0x80117100
      }

      p = ptable.pLists.ready[i];                                              // P4 changes
80105312:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105315:	05 cc 09 00 00       	add    $0x9cc,%eax
8010531a:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
80105321:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(p) {
80105324:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80105328:	0f 84 b8 00 00 00    	je     801053e6 <scheduler+0x143>
        remove_from_list(&ptable.pLists.ready[i], p);
8010532e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105331:	05 cc 09 00 00       	add    $0x9cc,%eax
80105336:	c1 e0 02             	shl    $0x2,%eax
80105339:	05 a0 49 11 80       	add    $0x801149a0,%eax
8010533e:	83 c0 0c             	add    $0xc,%eax
80105341:	83 ec 08             	sub    $0x8,%esp
80105344:	ff 75 ec             	pushl  -0x14(%ebp)
80105347:	50                   	push   %eax
80105348:	e8 dd 0e 00 00       	call   8010622a <remove_from_list>
8010534d:	83 c4 10             	add    $0x10,%esp
        assert_state(p, RUNNABLE);
80105350:	83 ec 08             	sub    $0x8,%esp
80105353:	6a 03                	push   $0x3
80105355:	ff 75 ec             	pushl  -0x14(%ebp)
80105358:	e8 ac 0e 00 00       	call   80106209 <assert_state>
8010535d:	83 c4 10             	add    $0x10,%esp
        idle = 0;  // not idle this timeslice
80105360:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        proc = p;
80105367:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010536a:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
        switchuvm(p);
80105370:	83 ec 0c             	sub    $0xc,%esp
80105373:	ff 75 ec             	pushl  -0x14(%ebp)
80105376:	e8 df 45 00 00       	call   8010995a <switchuvm>
8010537b:	83 c4 10             	add    $0x10,%esp
        p->state = RUNNING;
8010537e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105381:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
        add_to_list(&ptable.pLists.running, RUNNING, p);
80105388:	83 ec 04             	sub    $0x4,%esp
8010538b:	ff 75 ec             	pushl  -0x14(%ebp)
8010538e:	6a 04                	push   $0x4
80105390:	68 f4 70 11 80       	push   $0x801170f4
80105395:	e8 3c 0f 00 00       	call   801062d6 <add_to_list>
8010539a:	83 c4 10             	add    $0x10,%esp
        p->cpu_ticks_in = ticks;  // My code p3
8010539d:	8b 15 20 79 11 80    	mov    0x80117920,%edx
801053a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801053a6:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
        swtch(&cpu->scheduler, proc->context);
801053ac:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801053b2:	8b 40 1c             	mov    0x1c(%eax),%eax
801053b5:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801053bc:	83 c2 04             	add    $0x4,%edx
801053bf:	83 ec 08             	sub    $0x8,%esp
801053c2:	50                   	push   %eax
801053c3:	52                   	push   %edx
801053c4:	e8 ee 19 00 00       	call   80106db7 <swtch>
801053c9:	83 c4 10             	add    $0x10,%esp
        switchkvm();
801053cc:	e8 6c 45 00 00       	call   8010993d <switchkvm>
    
        // Process is done running for now.
        // It should have changed its p->state before coming back.
        proc = 0; 
801053d1:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801053d8:	00 00 00 00 
        i = -1; // Set i to -1 so it increments to 0 and begins with the first queue again
801053dc:	c7 45 f0 ff ff ff ff 	movl   $0xffffffff,-0x10(%ebp)
801053e3:	eb 01                	jmp    801053e6 <scheduler+0x143>
    
    acquire(&ptable.lock); 

    for (int i = 0; i < MAX+1; i++) {
      if (!ptable.pLists.ready[i])
        continue;
801053e5:	90                   	nop
    sti();
    idle = 1;   // assume idle unless we schedule a process
    
    acquire(&ptable.lock); 

    for (int i = 0; i < MAX+1; i++) {
801053e6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801053ea:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
801053ee:	0f 8e e4 fe ff ff    	jle    801052d8 <scheduler+0x35>
        proc = 0; 
        i = -1; // Set i to -1 so it increments to 0 and begins with the first queue again
      }
    }

    release(&ptable.lock);
801053f4:	83 ec 0c             	sub    $0xc,%esp
801053f7:	68 a0 49 11 80       	push   $0x801149a0
801053fc:	e8 46 15 00 00       	call   80106947 <release>
80105401:	83 c4 10             	add    $0x10,%esp
    if (idle) {
80105404:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105408:	0f 84 a2 fe ff ff    	je     801052b0 <scheduler+0xd>
      sti();
8010540e:	e8 83 f3 ff ff       	call   80104796 <sti>
      hlt();
80105413:	e8 67 f3 ff ff       	call   8010477f <hlt>
    }
  }
80105418:	e9 93 fe ff ff       	jmp    801052b0 <scheduler+0xd>

8010541d <sched>:
  cpu->intena = intena;
}
#else
void
sched(void)
{
8010541d:	55                   	push   %ebp
8010541e:	89 e5                	mov    %esp,%ebp
80105420:	53                   	push   %ebx
80105421:	83 ec 14             	sub    $0x14,%esp
  int intena;

  if(!holding(&ptable.lock))
80105424:	83 ec 0c             	sub    $0xc,%esp
80105427:	68 a0 49 11 80       	push   $0x801149a0
8010542c:	e8 e2 15 00 00       	call   80106a13 <holding>
80105431:	83 c4 10             	add    $0x10,%esp
80105434:	85 c0                	test   %eax,%eax
80105436:	75 0d                	jne    80105445 <sched+0x28>
    panic("sched ptable.lock");
80105438:	83 ec 0c             	sub    $0xc,%esp
8010543b:	68 77 a4 10 80       	push   $0x8010a477
80105440:	e8 21 b1 ff ff       	call   80100566 <panic>
  if(cpu->ncli != 1)
80105445:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010544b:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80105451:	83 f8 01             	cmp    $0x1,%eax
80105454:	74 0d                	je     80105463 <sched+0x46>
    panic("sched locks");
80105456:	83 ec 0c             	sub    $0xc,%esp
80105459:	68 89 a4 10 80       	push   $0x8010a489
8010545e:	e8 03 b1 ff ff       	call   80100566 <panic>
  if(proc->state == RUNNING)
80105463:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105469:	8b 40 0c             	mov    0xc(%eax),%eax
8010546c:	83 f8 04             	cmp    $0x4,%eax
8010546f:	75 0d                	jne    8010547e <sched+0x61>
    panic("sched running");
80105471:	83 ec 0c             	sub    $0xc,%esp
80105474:	68 95 a4 10 80       	push   $0x8010a495
80105479:	e8 e8 b0 ff ff       	call   80100566 <panic>
  if(readeflags()&FL_IF)
8010547e:	e8 03 f3 ff ff       	call   80104786 <readeflags>
80105483:	25 00 02 00 00       	and    $0x200,%eax
80105488:	85 c0                	test   %eax,%eax
8010548a:	74 0d                	je     80105499 <sched+0x7c>
    panic("sched interruptible");
8010548c:	83 ec 0c             	sub    $0xc,%esp
8010548f:	68 a3 a4 10 80       	push   $0x8010a4a3
80105494:	e8 cd b0 ff ff       	call   80100566 <panic>
  intena = cpu->intena;
80105499:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010549f:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801054a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  proc->cpu_ticks_total += ticks - proc->cpu_ticks_in; // My code p2
801054a8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801054ae:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801054b5:	8b 8a 88 00 00 00    	mov    0x88(%edx),%ecx
801054bb:	8b 1d 20 79 11 80    	mov    0x80117920,%ebx
801054c1:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801054c8:	8b 92 8c 00 00 00    	mov    0x8c(%edx),%edx
801054ce:	29 d3                	sub    %edx,%ebx
801054d0:	89 da                	mov    %ebx,%edx
801054d2:	01 ca                	add    %ecx,%edx
801054d4:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
  swtch(&proc->context, cpu->scheduler);
801054da:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801054e0:	8b 40 04             	mov    0x4(%eax),%eax
801054e3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801054ea:	83 c2 1c             	add    $0x1c,%edx
801054ed:	83 ec 08             	sub    $0x8,%esp
801054f0:	50                   	push   %eax
801054f1:	52                   	push   %edx
801054f2:	e8 c0 18 00 00       	call   80106db7 <swtch>
801054f7:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
801054fa:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105500:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105503:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105509:	90                   	nop
8010550a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010550d:	c9                   	leave  
8010550e:	c3                   	ret    

8010550f <yield>:
#endif

// Give up the CPU for one scheduling round.
void
yield(void)
{
8010550f:	55                   	push   %ebp
80105510:	89 e5                	mov    %esp,%ebp
80105512:	53                   	push   %ebx
80105513:	83 ec 04             	sub    $0x4,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80105516:	83 ec 0c             	sub    $0xc,%esp
80105519:	68 a0 49 11 80       	push   $0x801149a0
8010551e:	e8 bd 13 00 00       	call   801068e0 <acquire>
80105523:	83 c4 10             	add    $0x10,%esp
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.running, proc);
80105526:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010552c:	83 ec 08             	sub    $0x8,%esp
8010552f:	50                   	push   %eax
80105530:	68 f4 70 11 80       	push   $0x801170f4
80105535:	e8 f0 0c 00 00       	call   8010622a <remove_from_list>
8010553a:	83 c4 10             	add    $0x10,%esp
  assert_state(proc, RUNNING);
8010553d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105543:	83 ec 08             	sub    $0x8,%esp
80105546:	6a 04                	push   $0x4
80105548:	50                   	push   %eax
80105549:	e8 bb 0c 00 00       	call   80106209 <assert_state>
8010554e:	83 c4 10             	add    $0x10,%esp
  #endif
  proc->state = RUNNABLE;
80105551:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105557:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  #ifdef CS333_P3P4
  proc->budget = proc->budget - (ticks - proc->cpu_ticks_in);
8010555e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105564:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010556b:	8b 8a 94 00 00 00    	mov    0x94(%edx),%ecx
80105571:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105578:	8b 9a 8c 00 00 00    	mov    0x8c(%edx),%ebx
8010557e:	8b 15 20 79 11 80    	mov    0x80117920,%edx
80105584:	29 d3                	sub    %edx,%ebx
80105586:	89 da                	mov    %ebx,%edx
80105588:	01 ca                	add    %ecx,%edx
8010558a:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
  if (proc->budget <= 0 && proc->priority < MAX) {
80105590:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105596:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010559c:	85 c0                	test   %eax,%eax
8010559e:	75 3d                	jne    801055dd <yield+0xce>
801055a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055a6:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
801055ac:	83 f8 04             	cmp    $0x4,%eax
801055af:	77 2c                	ja     801055dd <yield+0xce>
    proc->priority = proc->priority+1;
801055b1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055b7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801055be:	8b 92 90 00 00 00    	mov    0x90(%edx),%edx
801055c4:	83 c2 01             	add    $0x1,%edx
801055c7:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    proc->budget = DEFBUDGET;
801055cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055d3:	c7 80 94 00 00 00 f4 	movl   $0x1f4,0x94(%eax)
801055da:	01 00 00 
  }
  add_to_ready(proc, RUNNABLE);
801055dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055e3:	83 ec 08             	sub    $0x8,%esp
801055e6:	6a 03                	push   $0x3
801055e8:	50                   	push   %eax
801055e9:	e8 29 0d 00 00       	call   80106317 <add_to_ready>
801055ee:	83 c4 10             	add    $0x10,%esp
  #endif
  sched();
801055f1:	e8 27 fe ff ff       	call   8010541d <sched>
  release(&ptable.lock);
801055f6:	83 ec 0c             	sub    $0xc,%esp
801055f9:	68 a0 49 11 80       	push   $0x801149a0
801055fe:	e8 44 13 00 00       	call   80106947 <release>
80105603:	83 c4 10             	add    $0x10,%esp
}
80105606:	90                   	nop
80105607:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010560a:	c9                   	leave  
8010560b:	c3                   	ret    

8010560c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
8010560c:	55                   	push   %ebp
8010560d:	89 e5                	mov    %esp,%ebp
8010560f:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80105612:	83 ec 0c             	sub    $0xc,%esp
80105615:	68 a0 49 11 80       	push   $0x801149a0
8010561a:	e8 28 13 00 00       	call   80106947 <release>
8010561f:	83 c4 10             	add    $0x10,%esp

  if (first) {
80105622:	a1 20 d0 10 80       	mov    0x8010d020,%eax
80105627:	85 c0                	test   %eax,%eax
80105629:	74 24                	je     8010564f <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
8010562b:	c7 05 20 d0 10 80 00 	movl   $0x0,0x8010d020
80105632:	00 00 00 
    iinit(ROOTDEV);
80105635:	83 ec 0c             	sub    $0xc,%esp
80105638:	6a 01                	push   $0x1
8010563a:	e8 54 c1 ff ff       	call   80101793 <iinit>
8010563f:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80105642:	83 ec 0c             	sub    $0xc,%esp
80105645:	6a 01                	push   $0x1
80105647:	e8 24 e0 ff ff       	call   80103670 <initlog>
8010564c:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
8010564f:	90                   	nop
80105650:	c9                   	leave  
80105651:	c3                   	ret    

80105652 <sleep>:
// Reacquires lock when awakened.
// 2016/12/28: ticklock removed from xv6. sleep() changed to
// accept a NULL lock to accommodate.
void
sleep(void *chan, struct spinlock *lk)
{
80105652:	55                   	push   %ebp
80105653:	89 e5                	mov    %esp,%ebp
80105655:	53                   	push   %ebx
80105656:	83 ec 04             	sub    $0x4,%esp
  if(proc == 0)
80105659:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010565f:	85 c0                	test   %eax,%eax
80105661:	75 0d                	jne    80105670 <sleep+0x1e>
    panic("sleep");
80105663:	83 ec 0c             	sub    $0xc,%esp
80105666:	68 b7 a4 10 80       	push   $0x8010a4b7
8010566b:	e8 f6 ae ff ff       	call   80100566 <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){
80105670:	81 7d 0c a0 49 11 80 	cmpl   $0x801149a0,0xc(%ebp)
80105677:	74 24                	je     8010569d <sleep+0x4b>
    acquire(&ptable.lock);
80105679:	83 ec 0c             	sub    $0xc,%esp
8010567c:	68 a0 49 11 80       	push   $0x801149a0
80105681:	e8 5a 12 00 00       	call   801068e0 <acquire>
80105686:	83 c4 10             	add    $0x10,%esp
    if (lk) release(lk);
80105689:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010568d:	74 0e                	je     8010569d <sleep+0x4b>
8010568f:	83 ec 0c             	sub    $0xc,%esp
80105692:	ff 75 0c             	pushl  0xc(%ebp)
80105695:	e8 ad 12 00 00       	call   80106947 <release>
8010569a:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
8010569d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056a3:	8b 55 08             	mov    0x8(%ebp),%edx
801056a6:	89 50 20             	mov    %edx,0x20(%eax)
  #ifdef CS333_P3P4
  remove_from_list(&ptable.pLists.running, proc);
801056a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056af:	83 ec 08             	sub    $0x8,%esp
801056b2:	50                   	push   %eax
801056b3:	68 f4 70 11 80       	push   $0x801170f4
801056b8:	e8 6d 0b 00 00       	call   8010622a <remove_from_list>
801056bd:	83 c4 10             	add    $0x10,%esp
  assert_state(proc, RUNNING);
801056c0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056c6:	83 ec 08             	sub    $0x8,%esp
801056c9:	6a 04                	push   $0x4
801056cb:	50                   	push   %eax
801056cc:	e8 38 0b 00 00       	call   80106209 <assert_state>
801056d1:	83 c4 10             	add    $0x10,%esp
  #endif
  proc->state = SLEEPING;
801056d4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056da:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  #ifdef CS333_P3P4
  proc->budget = proc->budget - (ticks - proc->cpu_ticks_in);
801056e1:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056e7:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801056ee:	8b 8a 94 00 00 00    	mov    0x94(%edx),%ecx
801056f4:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801056fb:	8b 9a 8c 00 00 00    	mov    0x8c(%edx),%ebx
80105701:	8b 15 20 79 11 80    	mov    0x80117920,%edx
80105707:	29 d3                	sub    %edx,%ebx
80105709:	89 da                	mov    %ebx,%edx
8010570b:	01 ca                	add    %ecx,%edx
8010570d:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
  if (proc->budget <= 0 && proc->priority < MAX) {
80105713:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105719:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010571f:	85 c0                	test   %eax,%eax
80105721:	75 3d                	jne    80105760 <sleep+0x10e>
80105723:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105729:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010572f:	83 f8 04             	cmp    $0x4,%eax
80105732:	77 2c                	ja     80105760 <sleep+0x10e>
    proc->priority = proc->priority+1;
80105734:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010573a:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80105741:	8b 92 90 00 00 00    	mov    0x90(%edx),%edx
80105747:	83 c2 01             	add    $0x1,%edx
8010574a:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    proc->budget = DEFBUDGET;
80105750:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105756:	c7 80 94 00 00 00 f4 	movl   $0x1f4,0x94(%eax)
8010575d:	01 00 00 
  }
  add_to_list(&ptable.pLists.sleep, SLEEPING, proc);
80105760:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105766:	83 ec 04             	sub    $0x4,%esp
80105769:	50                   	push   %eax
8010576a:	6a 02                	push   $0x2
8010576c:	68 f8 70 11 80       	push   $0x801170f8
80105771:	e8 60 0b 00 00       	call   801062d6 <add_to_list>
80105776:	83 c4 10             	add    $0x10,%esp
  #endif
  sched();
80105779:	e8 9f fc ff ff       	call   8010541d <sched>

  // Tidy up.
  proc->chan = 0;
8010577e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105784:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){ 
8010578b:	81 7d 0c a0 49 11 80 	cmpl   $0x801149a0,0xc(%ebp)
80105792:	74 24                	je     801057b8 <sleep+0x166>
    release(&ptable.lock);
80105794:	83 ec 0c             	sub    $0xc,%esp
80105797:	68 a0 49 11 80       	push   $0x801149a0
8010579c:	e8 a6 11 00 00       	call   80106947 <release>
801057a1:	83 c4 10             	add    $0x10,%esp
    if (lk) acquire(lk);
801057a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801057a8:	74 0e                	je     801057b8 <sleep+0x166>
801057aa:	83 ec 0c             	sub    $0xc,%esp
801057ad:	ff 75 0c             	pushl  0xc(%ebp)
801057b0:	e8 2b 11 00 00       	call   801068e0 <acquire>
801057b5:	83 c4 10             	add    $0x10,%esp
  }
}
801057b8:	90                   	nop
801057b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801057bc:	c9                   	leave  
801057bd:	c3                   	ret    

801057be <wakeup1>:
      p->state = RUNNABLE;
}
#else
static void
wakeup1(void *chan)
{
801057be:	55                   	push   %ebp
801057bf:	89 e5                	mov    %esp,%ebp
801057c1:	83 ec 18             	sub    $0x18,%esp
  struct proc* p = ptable.pLists.sleep;
801057c4:	a1 f8 70 11 80       	mov    0x801170f8,%eax
801057c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
801057cc:	eb 54                	jmp    80105822 <wakeup1+0x64>
    if (p->chan == chan) {
801057ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057d1:	8b 40 20             	mov    0x20(%eax),%eax
801057d4:	3b 45 08             	cmp    0x8(%ebp),%eax
801057d7:	75 3d                	jne    80105816 <wakeup1+0x58>
      remove_from_list(&ptable.pLists.sleep, p);
801057d9:	83 ec 08             	sub    $0x8,%esp
801057dc:	ff 75 f4             	pushl  -0xc(%ebp)
801057df:	68 f8 70 11 80       	push   $0x801170f8
801057e4:	e8 41 0a 00 00       	call   8010622a <remove_from_list>
801057e9:	83 c4 10             	add    $0x10,%esp
      assert_state(p, SLEEPING);
801057ec:	83 ec 08             	sub    $0x8,%esp
801057ef:	6a 02                	push   $0x2
801057f1:	ff 75 f4             	pushl  -0xc(%ebp)
801057f4:	e8 10 0a 00 00       	call   80106209 <assert_state>
801057f9:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNABLE;
801057fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801057ff:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      add_to_ready(p, RUNNABLE);
80105806:	83 ec 08             	sub    $0x8,%esp
80105809:	6a 03                	push   $0x3
8010580b:	ff 75 f4             	pushl  -0xc(%ebp)
8010580e:	e8 04 0b 00 00       	call   80106317 <add_to_ready>
80105813:	83 c4 10             	add    $0x10,%esp
    }
    p = p->next;
80105816:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105819:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010581f:	89 45 f4             	mov    %eax,-0xc(%ebp)
#else
static void
wakeup1(void *chan)
{
  struct proc* p = ptable.pLists.sleep;
  while (p) {
80105822:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105826:	75 a6                	jne    801057ce <wakeup1+0x10>
      p->state = RUNNABLE;
      add_to_ready(p, RUNNABLE);
    }
    p = p->next;
  }
}
80105828:	90                   	nop
80105829:	c9                   	leave  
8010582a:	c3                   	ret    

8010582b <wakeup>:
#endif

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
8010582b:	55                   	push   %ebp
8010582c:	89 e5                	mov    %esp,%ebp
8010582e:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80105831:	83 ec 0c             	sub    $0xc,%esp
80105834:	68 a0 49 11 80       	push   $0x801149a0
80105839:	e8 a2 10 00 00       	call   801068e0 <acquire>
8010583e:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80105841:	83 ec 0c             	sub    $0xc,%esp
80105844:	ff 75 08             	pushl  0x8(%ebp)
80105847:	e8 72 ff ff ff       	call   801057be <wakeup1>
8010584c:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
8010584f:	83 ec 0c             	sub    $0xc,%esp
80105852:	68 a0 49 11 80       	push   $0x801149a0
80105857:	e8 eb 10 00 00       	call   80106947 <release>
8010585c:	83 c4 10             	add    $0x10,%esp
}
8010585f:	90                   	nop
80105860:	c9                   	leave  
80105861:	c3                   	ret    

80105862 <kill>:
}

#else
int
kill(int pid)
{
80105862:	55                   	push   %ebp
80105863:	89 e5                	mov    %esp,%ebp
80105865:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;

  acquire(&ptable.lock);
80105868:	83 ec 0c             	sub    $0xc,%esp
8010586b:	68 a0 49 11 80       	push   $0x801149a0
80105870:	e8 6b 10 00 00       	call   801068e0 <acquire>
80105875:	83 c4 10             	add    $0x10,%esp
  // Search through embryo
  p = ptable.pLists.embryo;
80105878:	a1 d8 70 11 80       	mov    0x801170d8,%eax
8010587d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
80105880:	eb 3d                	jmp    801058bf <kill+0x5d>
    if (p->pid == pid) {
80105882:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105885:	8b 50 10             	mov    0x10(%eax),%edx
80105888:	8b 45 08             	mov    0x8(%ebp),%eax
8010588b:	39 c2                	cmp    %eax,%edx
8010588d:	75 24                	jne    801058b3 <kill+0x51>
      p->killed = 1;
8010588f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105892:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      release(&ptable.lock);
80105899:	83 ec 0c             	sub    $0xc,%esp
8010589c:	68 a0 49 11 80       	push   $0x801149a0
801058a1:	e8 a1 10 00 00       	call   80106947 <release>
801058a6:	83 c4 10             	add    $0x10,%esp
      return 0;
801058a9:	b8 00 00 00 00       	mov    $0x0,%eax
801058ae:	e9 65 01 00 00       	jmp    80105a18 <kill+0x1b6>
    }
    p = p->next;
801058b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058b6:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801058bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  struct proc* p;

  acquire(&ptable.lock);
  // Search through embryo
  p = ptable.pLists.embryo;
  while (p) {
801058bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801058c3:	75 bd                	jne    80105882 <kill+0x20>
      return 0;
    }
    p = p->next;
  }
  // Search through ready
  for (int i = 0; i < MAX+1; i++) {                 // P4 changes
801058c5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
801058cc:	eb 5b                	jmp    80105929 <kill+0xc7>
    p = ptable.pLists.ready[i];
801058ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058d1:	05 cc 09 00 00       	add    $0x9cc,%eax
801058d6:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
801058dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (p) {
801058e0:	eb 3d                	jmp    8010591f <kill+0xbd>
      if (p->pid == pid) {
801058e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058e5:	8b 50 10             	mov    0x10(%eax),%edx
801058e8:	8b 45 08             	mov    0x8(%ebp),%eax
801058eb:	39 c2                	cmp    %eax,%edx
801058ed:	75 24                	jne    80105913 <kill+0xb1>
        p->killed = 1;
801058ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058f2:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
        release(&ptable.lock);
801058f9:	83 ec 0c             	sub    $0xc,%esp
801058fc:	68 a0 49 11 80       	push   $0x801149a0
80105901:	e8 41 10 00 00       	call   80106947 <release>
80105906:	83 c4 10             	add    $0x10,%esp
        return 0;
80105909:	b8 00 00 00 00       	mov    $0x0,%eax
8010590e:	e9 05 01 00 00       	jmp    80105a18 <kill+0x1b6>
      }
      p = p->next;
80105913:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105916:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010591c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = p->next;
  }
  // Search through ready
  for (int i = 0; i < MAX+1; i++) {                 // P4 changes
    p = ptable.pLists.ready[i];
    while (p) {
8010591f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105923:	75 bd                	jne    801058e2 <kill+0x80>
      return 0;
    }
    p = p->next;
  }
  // Search through ready
  for (int i = 0; i < MAX+1; i++) {                 // P4 changes
80105925:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80105929:	83 7d f0 05          	cmpl   $0x5,-0x10(%ebp)
8010592d:	7e 9f                	jle    801058ce <kill+0x6c>
      }
      p = p->next;
    }
  }
  // Search through embryo
  p = ptable.pLists.running;
8010592f:	a1 f4 70 11 80       	mov    0x801170f4,%eax
80105934:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
80105937:	eb 3d                	jmp    80105976 <kill+0x114>
    if (p->pid == pid) {
80105939:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010593c:	8b 50 10             	mov    0x10(%eax),%edx
8010593f:	8b 45 08             	mov    0x8(%ebp),%eax
80105942:	39 c2                	cmp    %eax,%edx
80105944:	75 24                	jne    8010596a <kill+0x108>
      p->killed = 1;
80105946:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105949:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      release(&ptable.lock);
80105950:	83 ec 0c             	sub    $0xc,%esp
80105953:	68 a0 49 11 80       	push   $0x801149a0
80105958:	e8 ea 0f 00 00       	call   80106947 <release>
8010595d:	83 c4 10             	add    $0x10,%esp
      return 0;
80105960:	b8 00 00 00 00       	mov    $0x0,%eax
80105965:	e9 ae 00 00 00       	jmp    80105a18 <kill+0x1b6>
    }
    p = p->next;
8010596a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010596d:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105973:	89 45 f4             	mov    %eax,-0xc(%ebp)
      p = p->next;
    }
  }
  // Search through embryo
  p = ptable.pLists.running;
  while (p) {
80105976:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010597a:	75 bd                	jne    80105939 <kill+0xd7>
      return 0;
    }
    p = p->next;
  }
  // Search through embryo
  p = ptable.pLists.sleep;
8010597c:	a1 f8 70 11 80       	mov    0x801170f8,%eax
80105981:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (p) {
80105984:	eb 77                	jmp    801059fd <kill+0x19b>
    if (p->pid == pid) {
80105986:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105989:	8b 50 10             	mov    0x10(%eax),%edx
8010598c:	8b 45 08             	mov    0x8(%ebp),%eax
8010598f:	39 c2                	cmp    %eax,%edx
80105991:	75 5e                	jne    801059f1 <kill+0x18f>
      p->killed = 1;
80105993:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105996:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      remove_from_list(&ptable.pLists.sleep, p);
8010599d:	83 ec 08             	sub    $0x8,%esp
801059a0:	ff 75 f4             	pushl  -0xc(%ebp)
801059a3:	68 f8 70 11 80       	push   $0x801170f8
801059a8:	e8 7d 08 00 00       	call   8010622a <remove_from_list>
801059ad:	83 c4 10             	add    $0x10,%esp
      assert_state(p, SLEEPING);
801059b0:	83 ec 08             	sub    $0x8,%esp
801059b3:	6a 02                	push   $0x2
801059b5:	ff 75 f4             	pushl  -0xc(%ebp)
801059b8:	e8 4c 08 00 00       	call   80106209 <assert_state>
801059bd:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNABLE;
801059c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059c3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      add_to_ready(p, RUNNABLE);
801059ca:	83 ec 08             	sub    $0x8,%esp
801059cd:	6a 03                	push   $0x3
801059cf:	ff 75 f4             	pushl  -0xc(%ebp)
801059d2:	e8 40 09 00 00       	call   80106317 <add_to_ready>
801059d7:	83 c4 10             	add    $0x10,%esp
      release(&ptable.lock);
801059da:	83 ec 0c             	sub    $0xc,%esp
801059dd:	68 a0 49 11 80       	push   $0x801149a0
801059e2:	e8 60 0f 00 00       	call   80106947 <release>
801059e7:	83 c4 10             	add    $0x10,%esp
      return 0;
801059ea:	b8 00 00 00 00       	mov    $0x0,%eax
801059ef:	eb 27                	jmp    80105a18 <kill+0x1b6>
    }
    p = p->next;
801059f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801059f4:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801059fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    p = p->next;
  }
  // Search through embryo
  p = ptable.pLists.sleep;
  while (p) {
801059fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a01:	75 83                	jne    80105986 <kill+0x124>
      return 0;
    }
    p = p->next;
  }

  release(&ptable.lock);
80105a03:	83 ec 0c             	sub    $0xc,%esp
80105a06:	68 a0 49 11 80       	push   $0x801149a0
80105a0b:	e8 37 0f 00 00       	call   80106947 <release>
80105a10:	83 c4 10             	add    $0x10,%esp
  return -1;
80105a13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a18:	c9                   	leave  
80105a19:	c3                   	ret    

80105a1a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80105a1a:	55                   	push   %ebp
80105a1b:	89 e5                	mov    %esp,%ebp
80105a1d:	53                   	push   %ebx
80105a1e:	83 ec 54             	sub    $0x54,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  cprintf("%s\t %s\t\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "Prio", "State", "Elapsed", "CPU", "PCs");
80105a21:	83 ec 04             	sub    $0x4,%esp
80105a24:	68 e7 a4 10 80       	push   $0x8010a4e7
80105a29:	68 eb a4 10 80       	push   $0x8010a4eb
80105a2e:	68 ef a4 10 80       	push   $0x8010a4ef
80105a33:	68 f7 a4 10 80       	push   $0x8010a4f7
80105a38:	68 fd a4 10 80       	push   $0x8010a4fd
80105a3d:	68 02 a5 10 80       	push   $0x8010a502
80105a42:	68 07 a5 10 80       	push   $0x8010a507
80105a47:	68 0b a5 10 80       	push   $0x8010a50b
80105a4c:	68 0f a5 10 80       	push   $0x8010a50f
80105a51:	68 14 a5 10 80       	push   $0x8010a514
80105a56:	68 18 a5 10 80       	push   $0x8010a518
80105a5b:	e8 66 a9 ff ff       	call   801003c6 <cprintf>
80105a60:	83 c4 30             	add    $0x30,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105a63:	c7 45 f0 d4 49 11 80 	movl   $0x801149d4,-0x10(%ebp)
80105a6a:	e9 31 02 00 00       	jmp    80105ca0 <procdump+0x286>
    if(p->state == UNUSED)
80105a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a72:	8b 40 0c             	mov    0xc(%eax),%eax
80105a75:	85 c0                	test   %eax,%eax
80105a77:	0f 84 1b 02 00 00    	je     80105c98 <procdump+0x27e>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80105a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a80:	8b 40 0c             	mov    0xc(%eax),%eax
80105a83:	83 f8 05             	cmp    $0x5,%eax
80105a86:	77 23                	ja     80105aab <procdump+0x91>
80105a88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a8b:	8b 40 0c             	mov    0xc(%eax),%eax
80105a8e:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105a95:	85 c0                	test   %eax,%eax
80105a97:	74 12                	je     80105aab <procdump+0x91>
      state = states[p->state];
80105a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105a9c:	8b 40 0c             	mov    0xc(%eax),%eax
80105a9f:	8b 04 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%eax
80105aa6:	89 45 ec             	mov    %eax,-0x14(%ebp)
80105aa9:	eb 07                	jmp    80105ab2 <procdump+0x98>
    else
      state = "???";
80105aab:	c7 45 ec 41 a5 10 80 	movl   $0x8010a541,-0x14(%ebp)
    uint seconds = (ticks - p->start_ticks)/100;
80105ab2:	8b 15 20 79 11 80    	mov    0x80117920,%edx
80105ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105abb:	8b 40 7c             	mov    0x7c(%eax),%eax
80105abe:	29 c2                	sub    %eax,%edx
80105ac0:	89 d0                	mov    %edx,%eax
80105ac2:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105ac7:	f7 e2                	mul    %edx
80105ac9:	89 d0                	mov    %edx,%eax
80105acb:	c1 e8 05             	shr    $0x5,%eax
80105ace:	89 45 e8             	mov    %eax,-0x18(%ebp)
    uint partial_seconds = (ticks - p->start_ticks)%100;
80105ad1:	8b 15 20 79 11 80    	mov    0x80117920,%edx
80105ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ada:	8b 40 7c             	mov    0x7c(%eax),%eax
80105add:	89 d1                	mov    %edx,%ecx
80105adf:	29 c1                	sub    %eax,%ecx
80105ae1:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105ae6:	89 c8                	mov    %ecx,%eax
80105ae8:	f7 e2                	mul    %edx
80105aea:	89 d0                	mov    %edx,%eax
80105aec:	c1 e8 05             	shr    $0x5,%eax
80105aef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105af2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105af5:	6b c0 64             	imul   $0x64,%eax,%eax
80105af8:	29 c1                	sub    %eax,%ecx
80105afa:	89 c8                	mov    %ecx,%eax
80105afc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    cprintf("%d\t %s\t\t %d\t %d\t", p->pid, p->name, p->uid, p->gid);
80105aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b02:	8b 88 84 00 00 00    	mov    0x84(%eax),%ecx
80105b08:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b0b:	8b 90 80 00 00 00    	mov    0x80(%eax),%edx
80105b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b14:	8d 58 6c             	lea    0x6c(%eax),%ebx
80105b17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b1a:	8b 40 10             	mov    0x10(%eax),%eax
80105b1d:	83 ec 0c             	sub    $0xc,%esp
80105b20:	51                   	push   %ecx
80105b21:	52                   	push   %edx
80105b22:	53                   	push   %ebx
80105b23:	50                   	push   %eax
80105b24:	68 45 a5 10 80       	push   $0x8010a545
80105b29:	e8 98 a8 ff ff       	call   801003c6 <cprintf>
80105b2e:	83 c4 20             	add    $0x20,%esp
    if (p->parent)
80105b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b34:	8b 40 14             	mov    0x14(%eax),%eax
80105b37:	85 c0                	test   %eax,%eax
80105b39:	74 1c                	je     80105b57 <procdump+0x13d>
      cprintf(" %d\t", p->parent->pid);
80105b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b3e:	8b 40 14             	mov    0x14(%eax),%eax
80105b41:	8b 40 10             	mov    0x10(%eax),%eax
80105b44:	83 ec 08             	sub    $0x8,%esp
80105b47:	50                   	push   %eax
80105b48:	68 56 a5 10 80       	push   $0x8010a556
80105b4d:	e8 74 a8 ff ff       	call   801003c6 <cprintf>
80105b52:	83 c4 10             	add    $0x10,%esp
80105b55:	eb 17                	jmp    80105b6e <procdump+0x154>
    else
      cprintf(" %d\t", p->pid);
80105b57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b5a:	8b 40 10             	mov    0x10(%eax),%eax
80105b5d:	83 ec 08             	sub    $0x8,%esp
80105b60:	50                   	push   %eax
80105b61:	68 56 a5 10 80       	push   $0x8010a556
80105b66:	e8 5b a8 ff ff       	call   801003c6 <cprintf>
80105b6b:	83 c4 10             	add    $0x10,%esp
    cprintf(" %d\t %s\t %d.", p->priority, state, seconds);
80105b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b71:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105b77:	ff 75 e8             	pushl  -0x18(%ebp)
80105b7a:	ff 75 ec             	pushl  -0x14(%ebp)
80105b7d:	50                   	push   %eax
80105b7e:	68 5b a5 10 80       	push   $0x8010a55b
80105b83:	e8 3e a8 ff ff       	call   801003c6 <cprintf>
80105b88:	83 c4 10             	add    $0x10,%esp
    if (partial_seconds < 10)
80105b8b:	83 7d e4 09          	cmpl   $0x9,-0x1c(%ebp)
80105b8f:	77 10                	ja     80105ba1 <procdump+0x187>
	cprintf("0");
80105b91:	83 ec 0c             	sub    $0xc,%esp
80105b94:	68 68 a5 10 80       	push   $0x8010a568
80105b99:	e8 28 a8 ff ff       	call   801003c6 <cprintf>
80105b9e:	83 c4 10             	add    $0x10,%esp
    cprintf("%d\t", partial_seconds);
80105ba1:	83 ec 08             	sub    $0x8,%esp
80105ba4:	ff 75 e4             	pushl  -0x1c(%ebp)
80105ba7:	68 6a a5 10 80       	push   $0x8010a56a
80105bac:	e8 15 a8 ff ff       	call   801003c6 <cprintf>
80105bb1:	83 c4 10             	add    $0x10,%esp
    uint cpu_seconds = p->cpu_ticks_total/100;
80105bb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bb7:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105bbd:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105bc2:	f7 e2                	mul    %edx
80105bc4:	89 d0                	mov    %edx,%eax
80105bc6:	c1 e8 05             	shr    $0x5,%eax
80105bc9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    uint cpu_partial_seconds = p->cpu_ticks_total%100;
80105bcc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105bcf:	8b 88 88 00 00 00    	mov    0x88(%eax),%ecx
80105bd5:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
80105bda:	89 c8                	mov    %ecx,%eax
80105bdc:	f7 e2                	mul    %edx
80105bde:	89 d0                	mov    %edx,%eax
80105be0:	c1 e8 05             	shr    $0x5,%eax
80105be3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105be6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105be9:	6b c0 64             	imul   $0x64,%eax,%eax
80105bec:	29 c1                	sub    %eax,%ecx
80105bee:	89 c8                	mov    %ecx,%eax
80105bf0:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if (cpu_partial_seconds < 10)
80105bf3:	83 7d dc 09          	cmpl   $0x9,-0x24(%ebp)
80105bf7:	77 18                	ja     80105c11 <procdump+0x1f7>
      cprintf("  %d.0%d\t", cpu_seconds, cpu_partial_seconds);
80105bf9:	83 ec 04             	sub    $0x4,%esp
80105bfc:	ff 75 dc             	pushl  -0x24(%ebp)
80105bff:	ff 75 e0             	pushl  -0x20(%ebp)
80105c02:	68 6e a5 10 80       	push   $0x8010a56e
80105c07:	e8 ba a7 ff ff       	call   801003c6 <cprintf>
80105c0c:	83 c4 10             	add    $0x10,%esp
80105c0f:	eb 16                	jmp    80105c27 <procdump+0x20d>
    else
      cprintf("  %d.%d\t", cpu_seconds, cpu_partial_seconds);
80105c11:	83 ec 04             	sub    $0x4,%esp
80105c14:	ff 75 dc             	pushl  -0x24(%ebp)
80105c17:	ff 75 e0             	pushl  -0x20(%ebp)
80105c1a:	68 78 a5 10 80       	push   $0x8010a578
80105c1f:	e8 a2 a7 ff ff       	call   801003c6 <cprintf>
80105c24:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80105c27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c2a:	8b 40 0c             	mov    0xc(%eax),%eax
80105c2d:	83 f8 02             	cmp    $0x2,%eax
80105c30:	75 54                	jne    80105c86 <procdump+0x26c>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105c32:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c35:	8b 40 1c             	mov    0x1c(%eax),%eax
80105c38:	8b 40 0c             	mov    0xc(%eax),%eax
80105c3b:	83 c0 08             	add    $0x8,%eax
80105c3e:	89 c2                	mov    %eax,%edx
80105c40:	83 ec 08             	sub    $0x8,%esp
80105c43:	8d 45 b4             	lea    -0x4c(%ebp),%eax
80105c46:	50                   	push   %eax
80105c47:	52                   	push   %edx
80105c48:	e8 4c 0d 00 00       	call   80106999 <getcallerpcs>
80105c4d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105c50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105c57:	eb 1c                	jmp    80105c75 <procdump+0x25b>
        cprintf(" %p", pc[i]);
80105c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c5c:	8b 44 85 b4          	mov    -0x4c(%ebp,%eax,4),%eax
80105c60:	83 ec 08             	sub    $0x8,%esp
80105c63:	50                   	push   %eax
80105c64:	68 81 a5 10 80       	push   $0x8010a581
80105c69:	e8 58 a7 ff ff       	call   801003c6 <cprintf>
80105c6e:	83 c4 10             	add    $0x10,%esp
      cprintf("  %d.0%d\t", cpu_seconds, cpu_partial_seconds);
    else
      cprintf("  %d.%d\t", cpu_seconds, cpu_partial_seconds);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105c71:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105c75:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105c79:	7f 0b                	jg     80105c86 <procdump+0x26c>
80105c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c7e:	8b 44 85 b4          	mov    -0x4c(%ebp,%eax,4),%eax
80105c82:	85 c0                	test   %eax,%eax
80105c84:	75 d3                	jne    80105c59 <procdump+0x23f>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105c86:	83 ec 0c             	sub    $0xc,%esp
80105c89:	68 85 a5 10 80       	push   $0x8010a585
80105c8e:	e8 33 a7 ff ff       	call   801003c6 <cprintf>
80105c93:	83 c4 10             	add    $0x10,%esp
80105c96:	eb 01                	jmp    80105c99 <procdump+0x27f>
  uint pc[10];
  
  cprintf("%s\t %s\t\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "Prio", "State", "Elapsed", "CPU", "PCs");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
80105c98:	90                   	nop
  struct proc *p;
  char *state;
  uint pc[10];
  
  cprintf("%s\t %s\t\t %s\t %s\t %s\t %s\t %s\t %s  %s\t %s\n", "PID", "Name", "UID", "GID", "PPID", "Prio", "State", "Elapsed", "CPU", "PCs");
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105c99:	81 45 f0 9c 00 00 00 	addl   $0x9c,-0x10(%ebp)
80105ca0:	81 7d f0 d4 70 11 80 	cmpl   $0x801170d4,-0x10(%ebp)
80105ca7:	0f 82 c2 fd ff ff    	jb     80105a6f <procdump+0x55>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80105cad:	90                   	nop
80105cae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cb1:	c9                   	leave  
80105cb2:	c3                   	ret    

80105cb3 <getproc_helper>:

int
getproc_helper(int m, struct uproc* table)
{
80105cb3:	55                   	push   %ebp
80105cb4:	89 e5                	mov    %esp,%ebp
80105cb6:	83 ec 18             	sub    $0x18,%esp
  struct proc* p;
  int i = 0;
80105cb9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for (p = ptable.proc; p < &ptable.proc[NPROC] && i < m; p++)
80105cc0:	c7 45 f4 d4 49 11 80 	movl   $0x801149d4,-0xc(%ebp)
80105cc7:	e9 ac 01 00 00       	jmp    80105e78 <getproc_helper+0x1c5>
  {
    if (p->state == RUNNING || p->state == RUNNABLE || p->state == SLEEPING)
80105ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ccf:	8b 40 0c             	mov    0xc(%eax),%eax
80105cd2:	83 f8 04             	cmp    $0x4,%eax
80105cd5:	74 1a                	je     80105cf1 <getproc_helper+0x3e>
80105cd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105cda:	8b 40 0c             	mov    0xc(%eax),%eax
80105cdd:	83 f8 03             	cmp    $0x3,%eax
80105ce0:	74 0f                	je     80105cf1 <getproc_helper+0x3e>
80105ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ce5:	8b 40 0c             	mov    0xc(%eax),%eax
80105ce8:	83 f8 02             	cmp    $0x2,%eax
80105ceb:	0f 85 80 01 00 00    	jne    80105e71 <getproc_helper+0x1be>
    {
      table[i].pid = p->pid;
80105cf1:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105cf4:	89 d0                	mov    %edx,%eax
80105cf6:	01 c0                	add    %eax,%eax
80105cf8:	01 d0                	add    %edx,%eax
80105cfa:	c1 e0 05             	shl    $0x5,%eax
80105cfd:	89 c2                	mov    %eax,%edx
80105cff:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d02:	01 c2                	add    %eax,%edx
80105d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d07:	8b 40 10             	mov    0x10(%eax),%eax
80105d0a:	89 02                	mov    %eax,(%edx)
      table[i].uid = p->uid;
80105d0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d0f:	89 d0                	mov    %edx,%eax
80105d11:	01 c0                	add    %eax,%eax
80105d13:	01 d0                	add    %edx,%eax
80105d15:	c1 e0 05             	shl    $0x5,%eax
80105d18:	89 c2                	mov    %eax,%edx
80105d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d1d:	01 c2                	add    %eax,%edx
80105d1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d22:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
80105d28:	89 42 04             	mov    %eax,0x4(%edx)
      table[i].gid = p->gid;
80105d2b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d2e:	89 d0                	mov    %edx,%eax
80105d30:	01 c0                	add    %eax,%eax
80105d32:	01 d0                	add    %edx,%eax
80105d34:	c1 e0 05             	shl    $0x5,%eax
80105d37:	89 c2                	mov    %eax,%edx
80105d39:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d3c:	01 c2                	add    %eax,%edx
80105d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d41:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
80105d47:	89 42 08             	mov    %eax,0x8(%edx)
      if (p->parent)
80105d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d4d:	8b 40 14             	mov    0x14(%eax),%eax
80105d50:	85 c0                	test   %eax,%eax
80105d52:	74 21                	je     80105d75 <getproc_helper+0xc2>
        table[i].ppid = p->parent->pid;
80105d54:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d57:	89 d0                	mov    %edx,%eax
80105d59:	01 c0                	add    %eax,%eax
80105d5b:	01 d0                	add    %edx,%eax
80105d5d:	c1 e0 05             	shl    $0x5,%eax
80105d60:	89 c2                	mov    %eax,%edx
80105d62:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d65:	01 c2                	add    %eax,%edx
80105d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d6a:	8b 40 14             	mov    0x14(%eax),%eax
80105d6d:	8b 40 10             	mov    0x10(%eax),%eax
80105d70:	89 42 0c             	mov    %eax,0xc(%edx)
80105d73:	eb 1c                	jmp    80105d91 <getproc_helper+0xde>
      else
        table[i].ppid = p->pid;
80105d75:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d78:	89 d0                	mov    %edx,%eax
80105d7a:	01 c0                	add    %eax,%eax
80105d7c:	01 d0                	add    %edx,%eax
80105d7e:	c1 e0 05             	shl    $0x5,%eax
80105d81:	89 c2                	mov    %eax,%edx
80105d83:	8b 45 0c             	mov    0xc(%ebp),%eax
80105d86:	01 c2                	add    %eax,%edx
80105d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d8b:	8b 40 10             	mov    0x10(%eax),%eax
80105d8e:	89 42 0c             	mov    %eax,0xc(%edx)
      table[i].priority = p->priority;
80105d91:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105d94:	89 d0                	mov    %edx,%eax
80105d96:	01 c0                	add    %eax,%eax
80105d98:	01 d0                	add    %edx,%eax
80105d9a:	c1 e0 05             	shl    $0x5,%eax
80105d9d:	89 c2                	mov    %eax,%edx
80105d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
80105da2:	01 c2                	add    %eax,%edx
80105da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105da7:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105dad:	89 42 10             	mov    %eax,0x10(%edx)
      table[i].elapsed_ticks = (ticks - p->start_ticks);
80105db0:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105db3:	89 d0                	mov    %edx,%eax
80105db5:	01 c0                	add    %eax,%eax
80105db7:	01 d0                	add    %edx,%eax
80105db9:	c1 e0 05             	shl    $0x5,%eax
80105dbc:	89 c2                	mov    %eax,%edx
80105dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80105dc1:	01 c2                	add    %eax,%edx
80105dc3:	8b 0d 20 79 11 80    	mov    0x80117920,%ecx
80105dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dcc:	8b 40 7c             	mov    0x7c(%eax),%eax
80105dcf:	29 c1                	sub    %eax,%ecx
80105dd1:	89 c8                	mov    %ecx,%eax
80105dd3:	89 42 14             	mov    %eax,0x14(%edx)
      table[i].CPU_total_ticks = p->cpu_ticks_total;
80105dd6:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105dd9:	89 d0                	mov    %edx,%eax
80105ddb:	01 c0                	add    %eax,%eax
80105ddd:	01 d0                	add    %edx,%eax
80105ddf:	c1 e0 05             	shl    $0x5,%eax
80105de2:	89 c2                	mov    %eax,%edx
80105de4:	8b 45 0c             	mov    0xc(%ebp),%eax
80105de7:	01 c2                	add    %eax,%edx
80105de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105dec:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
80105df2:	89 42 18             	mov    %eax,0x18(%edx)
      table[i].size = p->sz;
80105df5:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105df8:	89 d0                	mov    %edx,%eax
80105dfa:	01 c0                	add    %eax,%eax
80105dfc:	01 d0                	add    %edx,%eax
80105dfe:	c1 e0 05             	shl    $0x5,%eax
80105e01:	89 c2                	mov    %eax,%edx
80105e03:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e06:	01 c2                	add    %eax,%edx
80105e08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e0b:	8b 00                	mov    (%eax),%eax
80105e0d:	89 42 3c             	mov    %eax,0x3c(%edx)
      strncpy(table[i].state, states[p->state], sizeof(p->state)+1);
80105e10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e13:	8b 40 0c             	mov    0xc(%eax),%eax
80105e16:	8b 0c 85 08 d0 10 80 	mov    -0x7fef2ff8(,%eax,4),%ecx
80105e1d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e20:	89 d0                	mov    %edx,%eax
80105e22:	01 c0                	add    %eax,%eax
80105e24:	01 d0                	add    %edx,%eax
80105e26:	c1 e0 05             	shl    $0x5,%eax
80105e29:	89 c2                	mov    %eax,%edx
80105e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e2e:	01 d0                	add    %edx,%eax
80105e30:	83 c0 1c             	add    $0x1c,%eax
80105e33:	83 ec 04             	sub    $0x4,%esp
80105e36:	6a 05                	push   $0x5
80105e38:	51                   	push   %ecx
80105e39:	50                   	push   %eax
80105e3a:	e8 af 0e 00 00       	call   80106cee <strncpy>
80105e3f:	83 c4 10             	add    $0x10,%esp
      strncpy(table[i].name, p->name, sizeof(p->name)+1);
80105e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e45:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105e48:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e4b:	89 d0                	mov    %edx,%eax
80105e4d:	01 c0                	add    %eax,%eax
80105e4f:	01 d0                	add    %edx,%eax
80105e51:	c1 e0 05             	shl    $0x5,%eax
80105e54:	89 c2                	mov    %eax,%edx
80105e56:	8b 45 0c             	mov    0xc(%ebp),%eax
80105e59:	01 d0                	add    %edx,%eax
80105e5b:	83 c0 40             	add    $0x40,%eax
80105e5e:	83 ec 04             	sub    $0x4,%esp
80105e61:	6a 11                	push   $0x11
80105e63:	51                   	push   %ecx
80105e64:	50                   	push   %eax
80105e65:	e8 84 0e 00 00       	call   80106cee <strncpy>
80105e6a:	83 c4 10             	add    $0x10,%esp
      i++;
80105e6d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
int
getproc_helper(int m, struct uproc* table)
{
  struct proc* p;
  int i = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC] && i < m; p++)
80105e71:	81 45 f4 9c 00 00 00 	addl   $0x9c,-0xc(%ebp)
80105e78:	81 7d f4 d4 70 11 80 	cmpl   $0x801170d4,-0xc(%ebp)
80105e7f:	73 0c                	jae    80105e8d <getproc_helper+0x1da>
80105e81:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e84:	3b 45 08             	cmp    0x8(%ebp),%eax
80105e87:	0f 8c 3f fe ff ff    	jl     80105ccc <getproc_helper+0x19>
      strncpy(table[i].state, states[p->state], sizeof(p->state)+1);
      strncpy(table[i].name, p->name, sizeof(p->name)+1);
      i++;
    }
  }
  return i;  
80105e8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105e90:	c9                   	leave  
80105e91:	c3                   	ret    

80105e92 <free_length>:

// Counts the number of procs in the free list when ctrl-f is pressed
void
free_length(void)
{
80105e92:	55                   	push   %ebp
80105e93:	89 e5                	mov    %esp,%ebp
80105e95:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105e98:	83 ec 0c             	sub    $0xc,%esp
80105e9b:	68 a0 49 11 80       	push   $0x801149a0
80105ea0:	e8 3b 0a 00 00       	call   801068e0 <acquire>
80105ea5:	83 c4 10             	add    $0x10,%esp
  struct proc* f = ptable.pLists.free;
80105ea8:	a1 d4 70 11 80       	mov    0x801170d4,%eax
80105ead:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int count = 0;
80105eb0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if (!f) {
80105eb7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ebb:	75 35                	jne    80105ef2 <free_length+0x60>
    cprintf("Free List Size: %d\n", count);
80105ebd:	83 ec 08             	sub    $0x8,%esp
80105ec0:	ff 75 f0             	pushl  -0x10(%ebp)
80105ec3:	68 87 a5 10 80       	push   $0x8010a587
80105ec8:	e8 f9 a4 ff ff       	call   801003c6 <cprintf>
80105ecd:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80105ed0:	83 ec 0c             	sub    $0xc,%esp
80105ed3:	68 a0 49 11 80       	push   $0x801149a0
80105ed8:	e8 6a 0a 00 00       	call   80106947 <release>
80105edd:	83 c4 10             	add    $0x10,%esp
  }
  while (f)
80105ee0:	eb 10                	jmp    80105ef2 <free_length+0x60>
  {
    ++count;
80105ee2:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
    f = f->next;
80105ee6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ee9:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105eef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  int count = 0;
  if (!f) {
    cprintf("Free List Size: %d\n", count);
    release(&ptable.lock);
  }
  while (f)
80105ef2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ef6:	75 ea                	jne    80105ee2 <free_length+0x50>
  {
    ++count;
    f = f->next;
  }
  cprintf("Free List Size: %d\n", count);
80105ef8:	83 ec 08             	sub    $0x8,%esp
80105efb:	ff 75 f0             	pushl  -0x10(%ebp)
80105efe:	68 87 a5 10 80       	push   $0x8010a587
80105f03:	e8 be a4 ff ff       	call   801003c6 <cprintf>
80105f08:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80105f0b:	83 ec 0c             	sub    $0xc,%esp
80105f0e:	68 a0 49 11 80       	push   $0x801149a0
80105f13:	e8 2f 0a 00 00       	call   80106947 <release>
80105f18:	83 c4 10             	add    $0x10,%esp
}
80105f1b:	90                   	nop
80105f1c:	c9                   	leave  
80105f1d:	c3                   	ret    

80105f1e <display_ready>:

// Displays the PIDs of all processes in the ready list
void
display_ready(void)
{
80105f1e:	55                   	push   %ebp
80105f1f:	89 e5                	mov    %esp,%ebp
80105f21:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80105f24:	83 ec 0c             	sub    $0xc,%esp
80105f27:	68 a0 49 11 80       	push   $0x801149a0
80105f2c:	e8 af 09 00 00       	call   801068e0 <acquire>
80105f31:	83 c4 10             	add    $0x10,%esp
  cprintf("Ready List Processes:\n");
80105f34:	83 ec 0c             	sub    $0xc,%esp
80105f37:	68 9b a5 10 80       	push   $0x8010a59b
80105f3c:	e8 85 a4 ff ff       	call   801003c6 <cprintf>
80105f41:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < MAX+1; i++) {
80105f44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105f4b:	e9 a4 00 00 00       	jmp    80105ff4 <display_ready+0xd6>
    cprintf("Queue %d: ", i);
80105f50:	83 ec 08             	sub    $0x8,%esp
80105f53:	ff 75 f4             	pushl  -0xc(%ebp)
80105f56:	68 b2 a5 10 80       	push   $0x8010a5b2
80105f5b:	e8 66 a4 ff ff       	call   801003c6 <cprintf>
80105f60:	83 c4 10             	add    $0x10,%esp
    struct proc* r = ptable.pLists.ready[i];
80105f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f66:	05 cc 09 00 00       	add    $0x9cc,%eax
80105f6b:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
80105f72:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!r) {
80105f75:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f79:	75 6f                	jne    80105fea <display_ready+0xcc>
      cprintf("\n");
80105f7b:	83 ec 0c             	sub    $0xc,%esp
80105f7e:	68 85 a5 10 80       	push   $0x8010a585
80105f83:	e8 3e a4 ff ff       	call   801003c6 <cprintf>
80105f88:	83 c4 10             	add    $0x10,%esp
      continue;
80105f8b:	eb 63                	jmp    80105ff0 <display_ready+0xd2>
    }
    while (r) {
      if (!r->next)
80105f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f90:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105f96:	85 c0                	test   %eax,%eax
80105f98:	75 23                	jne    80105fbd <display_ready+0x9f>
        cprintf("(%d, %d)\n", r->pid, r->budget);
80105f9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f9d:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80105fa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fa6:	8b 40 10             	mov    0x10(%eax),%eax
80105fa9:	83 ec 04             	sub    $0x4,%esp
80105fac:	52                   	push   %edx
80105fad:	50                   	push   %eax
80105fae:	68 bd a5 10 80       	push   $0x8010a5bd
80105fb3:	e8 0e a4 ff ff       	call   801003c6 <cprintf>
80105fb8:	83 c4 10             	add    $0x10,%esp
80105fbb:	eb 21                	jmp    80105fde <display_ready+0xc0>
      else
        cprintf("(%d, %d) -> ", r->pid, r->budget);
80105fbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc0:	8b 90 94 00 00 00    	mov    0x94(%eax),%edx
80105fc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc9:	8b 40 10             	mov    0x10(%eax),%eax
80105fcc:	83 ec 04             	sub    $0x4,%esp
80105fcf:	52                   	push   %edx
80105fd0:	50                   	push   %eax
80105fd1:	68 c7 a5 10 80       	push   $0x8010a5c7
80105fd6:	e8 eb a3 ff ff       	call   801003c6 <cprintf>
80105fdb:	83 c4 10             	add    $0x10,%esp
      r = r->next;
80105fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fe1:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80105fe7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct proc* r = ptable.pLists.ready[i];
    if (!r) {
      cprintf("\n");
      continue;
    }
    while (r) {
80105fea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105fee:	75 9d                	jne    80105f8d <display_ready+0x6f>
void
display_ready(void)
{
  acquire(&ptable.lock);
  cprintf("Ready List Processes:\n");
  for (int i = 0; i < MAX+1; i++) {
80105ff0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105ff4:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
80105ff8:	0f 8e 52 ff ff ff    	jle    80105f50 <display_ready+0x32>
      else
        cprintf("(%d, %d) -> ", r->pid, r->budget);
      r = r->next;
    }
  }
  release(&ptable.lock);
80105ffe:	83 ec 0c             	sub    $0xc,%esp
80106001:	68 a0 49 11 80       	push   $0x801149a0
80106006:	e8 3c 09 00 00       	call   80106947 <release>
8010600b:	83 c4 10             	add    $0x10,%esp
  return;
8010600e:	90                   	nop
}
8010600f:	c9                   	leave  
80106010:	c3                   	ret    

80106011 <display_sleep>:

// Displays the PIDs of all processes in the sleep list
void
display_sleep(void)
{
80106011:	55                   	push   %ebp
80106012:	89 e5                	mov    %esp,%ebp
80106014:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
80106017:	83 ec 0c             	sub    $0xc,%esp
8010601a:	68 a0 49 11 80       	push   $0x801149a0
8010601f:	e8 bc 08 00 00       	call   801068e0 <acquire>
80106024:	83 c4 10             	add    $0x10,%esp
  struct proc* s = ptable.pLists.sleep;
80106027:	a1 f8 70 11 80       	mov    0x801170f8,%eax
8010602c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!s) {
8010602f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106033:	75 22                	jne    80106057 <display_sleep+0x46>
    cprintf("No processes currently in sleep.\n");
80106035:	83 ec 0c             	sub    $0xc,%esp
80106038:	68 d4 a5 10 80       	push   $0x8010a5d4
8010603d:	e8 84 a3 ff ff       	call   801003c6 <cprintf>
80106042:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
80106045:	83 ec 0c             	sub    $0xc,%esp
80106048:	68 a0 49 11 80       	push   $0x801149a0
8010604d:	e8 f5 08 00 00       	call   80106947 <release>
80106052:	83 c4 10             	add    $0x10,%esp
    return;
80106055:	eb 72                	jmp    801060c9 <display_sleep+0xb8>
  }
  cprintf("Sleep List Processes:\n");
80106057:	83 ec 0c             	sub    $0xc,%esp
8010605a:	68 f6 a5 10 80       	push   $0x8010a5f6
8010605f:	e8 62 a3 ff ff       	call   801003c6 <cprintf>
80106064:	83 c4 10             	add    $0x10,%esp
  while (s) {
80106067:	eb 49                	jmp    801060b2 <display_sleep+0xa1>
    if (!s->next)
80106069:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010606c:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80106072:	85 c0                	test   %eax,%eax
80106074:	75 19                	jne    8010608f <display_sleep+0x7e>
      cprintf("%d\n", s->pid);
80106076:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106079:	8b 40 10             	mov    0x10(%eax),%eax
8010607c:	83 ec 08             	sub    $0x8,%esp
8010607f:	50                   	push   %eax
80106080:	68 0d a6 10 80       	push   $0x8010a60d
80106085:	e8 3c a3 ff ff       	call   801003c6 <cprintf>
8010608a:	83 c4 10             	add    $0x10,%esp
8010608d:	eb 17                	jmp    801060a6 <display_sleep+0x95>
    else
      cprintf("%d -> ", s->pid);
8010608f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106092:	8b 40 10             	mov    0x10(%eax),%eax
80106095:	83 ec 08             	sub    $0x8,%esp
80106098:	50                   	push   %eax
80106099:	68 11 a6 10 80       	push   $0x8010a611
8010609e:	e8 23 a3 ff ff       	call   801003c6 <cprintf>
801060a3:	83 c4 10             	add    $0x10,%esp
    s = s->next;
801060a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060a9:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801060af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("No processes currently in sleep.\n");
    release(&ptable.lock);
    return;
  }
  cprintf("Sleep List Processes:\n");
  while (s) {
801060b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060b6:	75 b1                	jne    80106069 <display_sleep+0x58>
      cprintf("%d\n", s->pid);
    else
      cprintf("%d -> ", s->pid);
    s = s->next;
  }
  release(&ptable.lock);
801060b8:	83 ec 0c             	sub    $0xc,%esp
801060bb:	68 a0 49 11 80       	push   $0x801149a0
801060c0:	e8 82 08 00 00       	call   80106947 <release>
801060c5:	83 c4 10             	add    $0x10,%esp
  return;
801060c8:	90                   	nop
}
801060c9:	c9                   	leave  
801060ca:	c3                   	ret    

801060cb <display_zombie>:

// Displays the PID/PPID of processes in the zombie list
void display_zombie(void)
{
801060cb:	55                   	push   %ebp
801060cc:	89 e5                	mov    %esp,%ebp
801060ce:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
801060d1:	83 ec 0c             	sub    $0xc,%esp
801060d4:	68 a0 49 11 80       	push   $0x801149a0
801060d9:	e8 02 08 00 00       	call   801068e0 <acquire>
801060de:	83 c4 10             	add    $0x10,%esp
  struct proc* z = ptable.pLists.zombie;
801060e1:	a1 fc 70 11 80       	mov    0x801170fc,%eax
801060e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!z) {
801060e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060ed:	75 25                	jne    80106114 <display_zombie+0x49>
    cprintf("No processes currently in zombie.\n");
801060ef:	83 ec 0c             	sub    $0xc,%esp
801060f2:	68 18 a6 10 80       	push   $0x8010a618
801060f7:	e8 ca a2 ff ff       	call   801003c6 <cprintf>
801060fc:	83 c4 10             	add    $0x10,%esp
    release(&ptable.lock);
801060ff:	83 ec 0c             	sub    $0xc,%esp
80106102:	68 a0 49 11 80       	push   $0x801149a0
80106107:	e8 3b 08 00 00       	call   80106947 <release>
8010610c:	83 c4 10             	add    $0x10,%esp
    return;
8010610f:	e9 f3 00 00 00       	jmp    80106207 <display_zombie+0x13c>
  }
  cprintf("Zombie List Processes(/PPIDs)\n");
80106114:	83 ec 0c             	sub    $0xc,%esp
80106117:	68 3c a6 10 80       	push   $0x8010a63c
8010611c:	e8 a5 a2 ff ff       	call   801003c6 <cprintf>
80106121:	83 c4 10             	add    $0x10,%esp
  while (z) {
80106124:	e9 c3 00 00 00       	jmp    801061ec <display_zombie+0x121>
    if (!z->next) {
80106129:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010612c:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80106132:	85 c0                	test   %eax,%eax
80106134:	75 56                	jne    8010618c <display_zombie+0xc1>
      cprintf("(%d", z->pid);
80106136:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106139:	8b 40 10             	mov    0x10(%eax),%eax
8010613c:	83 ec 08             	sub    $0x8,%esp
8010613f:	50                   	push   %eax
80106140:	68 5b a6 10 80       	push   $0x8010a65b
80106145:	e8 7c a2 ff ff       	call   801003c6 <cprintf>
8010614a:	83 c4 10             	add    $0x10,%esp
      if (z->parent)
8010614d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106150:	8b 40 14             	mov    0x14(%eax),%eax
80106153:	85 c0                	test   %eax,%eax
80106155:	74 1c                	je     80106173 <display_zombie+0xa8>
        cprintf(", %d)\n", z->parent->pid);
80106157:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010615a:	8b 40 14             	mov    0x14(%eax),%eax
8010615d:	8b 40 10             	mov    0x10(%eax),%eax
80106160:	83 ec 08             	sub    $0x8,%esp
80106163:	50                   	push   %eax
80106164:	68 5f a6 10 80       	push   $0x8010a65f
80106169:	e8 58 a2 ff ff       	call   801003c6 <cprintf>
8010616e:	83 c4 10             	add    $0x10,%esp
80106171:	eb 6d                	jmp    801061e0 <display_zombie+0x115>
      else
        cprintf(", %d)\n", z->pid);
80106173:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106176:	8b 40 10             	mov    0x10(%eax),%eax
80106179:	83 ec 08             	sub    $0x8,%esp
8010617c:	50                   	push   %eax
8010617d:	68 5f a6 10 80       	push   $0x8010a65f
80106182:	e8 3f a2 ff ff       	call   801003c6 <cprintf>
80106187:	83 c4 10             	add    $0x10,%esp
8010618a:	eb 54                	jmp    801061e0 <display_zombie+0x115>
    }
    else {
      cprintf("(%d", z->pid);
8010618c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010618f:	8b 40 10             	mov    0x10(%eax),%eax
80106192:	83 ec 08             	sub    $0x8,%esp
80106195:	50                   	push   %eax
80106196:	68 5b a6 10 80       	push   $0x8010a65b
8010619b:	e8 26 a2 ff ff       	call   801003c6 <cprintf>
801061a0:	83 c4 10             	add    $0x10,%esp
      if (z->parent)
801061a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061a6:	8b 40 14             	mov    0x14(%eax),%eax
801061a9:	85 c0                	test   %eax,%eax
801061ab:	74 1c                	je     801061c9 <display_zombie+0xfe>
        cprintf(", %d) -> ", z->parent->pid);
801061ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061b0:	8b 40 14             	mov    0x14(%eax),%eax
801061b3:	8b 40 10             	mov    0x10(%eax),%eax
801061b6:	83 ec 08             	sub    $0x8,%esp
801061b9:	50                   	push   %eax
801061ba:	68 66 a6 10 80       	push   $0x8010a666
801061bf:	e8 02 a2 ff ff       	call   801003c6 <cprintf>
801061c4:	83 c4 10             	add    $0x10,%esp
801061c7:	eb 17                	jmp    801061e0 <display_zombie+0x115>
      else
        cprintf(", %d) -> ", z->pid);
801061c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061cc:	8b 40 10             	mov    0x10(%eax),%eax
801061cf:	83 ec 08             	sub    $0x8,%esp
801061d2:	50                   	push   %eax
801061d3:	68 66 a6 10 80       	push   $0x8010a666
801061d8:	e8 e9 a1 ff ff       	call   801003c6 <cprintf>
801061dd:	83 c4 10             	add    $0x10,%esp
    }
    z = z->next;
801061e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061e3:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801061e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("No processes currently in zombie.\n");
    release(&ptable.lock);
    return;
  }
  cprintf("Zombie List Processes(/PPIDs)\n");
  while (z) {
801061ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061f0:	0f 85 33 ff ff ff    	jne    80106129 <display_zombie+0x5e>
      else
        cprintf(", %d) -> ", z->pid);
    }
    z = z->next;
  }
  release(&ptable.lock);
801061f6:	83 ec 0c             	sub    $0xc,%esp
801061f9:	68 a0 49 11 80       	push   $0x801149a0
801061fe:	e8 44 07 00 00       	call   80106947 <release>
80106203:	83 c4 10             	add    $0x10,%esp
  return;
80106206:	90                   	nop
}
80106207:	c9                   	leave  
80106208:	c3                   	ret    

80106209 <assert_state>:

// Implementation of assert_state function
static void
assert_state(struct proc* p, enum procstate state)
{
80106209:	55                   	push   %ebp
8010620a:	89 e5                	mov    %esp,%ebp
8010620c:	83 ec 08             	sub    $0x8,%esp
  if (p->state == state)
8010620f:	8b 45 08             	mov    0x8(%ebp),%eax
80106212:	8b 40 0c             	mov    0xc(%eax),%eax
80106215:	3b 45 0c             	cmp    0xc(%ebp),%eax
80106218:	74 0d                	je     80106227 <assert_state+0x1e>
    return;
  panic("ERROR: States do not match.");
8010621a:	83 ec 0c             	sub    $0xc,%esp
8010621d:	68 70 a6 10 80       	push   $0x8010a670
80106222:	e8 3f a3 ff ff       	call   80100566 <panic>
// Implementation of assert_state function
static void
assert_state(struct proc* p, enum procstate state)
{
  if (p->state == state)
    return;
80106227:	90                   	nop
  panic("ERROR: States do not match.");
}
80106228:	c9                   	leave  
80106229:	c3                   	ret    

8010622a <remove_from_list>:

// Implementation of remove_from_list
static int
remove_from_list(struct proc** sList, struct proc* p)
{
8010622a:	55                   	push   %ebp
8010622b:	89 e5                	mov    %esp,%ebp
8010622d:	83 ec 10             	sub    $0x10,%esp
  if (!p)
80106230:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106234:	75 0a                	jne    80106240 <remove_from_list+0x16>
    return -1;
80106236:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010623b:	e9 94 00 00 00       	jmp    801062d4 <remove_from_list+0xaa>
  if (!sList)
80106240:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80106244:	75 0a                	jne    80106250 <remove_from_list+0x26>
    return -1;
80106246:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010624b:	e9 84 00 00 00       	jmp    801062d4 <remove_from_list+0xaa>
  struct proc* curr = *sList;
80106250:	8b 45 08             	mov    0x8(%ebp),%eax
80106253:	8b 00                	mov    (%eax),%eax
80106255:	89 45 fc             	mov    %eax,-0x4(%ebp)
  struct proc* prev;
  if (p == curr) {
80106258:	8b 45 0c             	mov    0xc(%ebp),%eax
8010625b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
8010625e:	75 62                	jne    801062c2 <remove_from_list+0x98>
    *sList = p->next;
80106260:	8b 45 0c             	mov    0xc(%ebp),%eax
80106263:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
80106269:	8b 45 08             	mov    0x8(%ebp),%eax
8010626c:	89 10                	mov    %edx,(%eax)
    p->next = 0;
8010626e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106271:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
80106278:	00 00 00 
    return 1;
8010627b:	b8 01 00 00 00       	mov    $0x1,%eax
80106280:	eb 52                	jmp    801062d4 <remove_from_list+0xaa>
  }
  while (curr->next) {
    prev = curr;
80106282:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106285:	89 45 f8             	mov    %eax,-0x8(%ebp)
    curr = curr->next;
80106288:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010628b:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80106291:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (p == curr) {
80106294:	8b 45 0c             	mov    0xc(%ebp),%eax
80106297:	3b 45 fc             	cmp    -0x4(%ebp),%eax
8010629a:	75 26                	jne    801062c2 <remove_from_list+0x98>
      prev->next = p->next;
8010629c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010629f:	8b 90 98 00 00 00    	mov    0x98(%eax),%edx
801062a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
801062a8:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
      p->next = 0;
801062ae:	8b 45 0c             	mov    0xc(%ebp),%eax
801062b1:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
801062b8:	00 00 00 
      return 1;
801062bb:	b8 01 00 00 00       	mov    $0x1,%eax
801062c0:	eb 12                	jmp    801062d4 <remove_from_list+0xaa>
  if (p == curr) {
    *sList = p->next;
    p->next = 0;
    return 1;
  }
  while (curr->next) {
801062c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801062c5:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801062cb:	85 c0                	test   %eax,%eax
801062cd:	75 b3                	jne    80106282 <remove_from_list+0x58>
      prev->next = p->next;
      p->next = 0;
      return 1;
    }
  }
  return -1;
801062cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801062d4:	c9                   	leave  
801062d5:	c3                   	ret    

801062d6 <add_to_list>:

// Implementation of add_to_list
static int
add_to_list(struct proc** sList, enum procstate state, struct proc* p)
{
801062d6:	55                   	push   %ebp
801062d7:	89 e5                	mov    %esp,%ebp
801062d9:	83 ec 08             	sub    $0x8,%esp
  if (!p)
801062dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801062e0:	75 07                	jne    801062e9 <add_to_list+0x13>
    return -1;
801062e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062e7:	eb 2c                	jmp    80106315 <add_to_list+0x3f>
  assert_state(p, state);
801062e9:	83 ec 08             	sub    $0x8,%esp
801062ec:	ff 75 0c             	pushl  0xc(%ebp)
801062ef:	ff 75 10             	pushl  0x10(%ebp)
801062f2:	e8 12 ff ff ff       	call   80106209 <assert_state>
801062f7:	83 c4 10             	add    $0x10,%esp
  p->next = *sList;
801062fa:	8b 45 08             	mov    0x8(%ebp),%eax
801062fd:	8b 10                	mov    (%eax),%edx
801062ff:	8b 45 10             	mov    0x10(%ebp),%eax
80106302:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
  *sList = p;
80106308:	8b 45 08             	mov    0x8(%ebp),%eax
8010630b:	8b 55 10             	mov    0x10(%ebp),%edx
8010630e:	89 10                	mov    %edx,(%eax)
  return 0;
80106310:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106315:	c9                   	leave  
80106316:	c3                   	ret    

80106317 <add_to_ready>:

// Implementation of add_to_ready
static int
add_to_ready(struct proc* p, enum procstate state)
{
80106317:	55                   	push   %ebp
80106318:	89 e5                	mov    %esp,%ebp
8010631a:	83 ec 18             	sub    $0x18,%esp
  if (!p)
8010631d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80106321:	75 0a                	jne    8010632d <add_to_ready+0x16>
    return -1;
80106323:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106328:	e9 b9 00 00 00       	jmp    801063e6 <add_to_ready+0xcf>
  assert_state(p, state);
8010632d:	83 ec 08             	sub    $0x8,%esp
80106330:	ff 75 0c             	pushl  0xc(%ebp)
80106333:	ff 75 08             	pushl  0x8(%ebp)
80106336:	e8 ce fe ff ff       	call   80106209 <assert_state>
8010633b:	83 c4 10             	add    $0x10,%esp
  if (!ptable.pLists.ready[p->priority]) {
8010633e:	8b 45 08             	mov    0x8(%ebp),%eax
80106341:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106347:	05 cc 09 00 00       	add    $0x9cc,%eax
8010634c:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
80106353:	85 c0                	test   %eax,%eax
80106355:	75 3e                	jne    80106395 <add_to_ready+0x7e>
    p->next = ptable.pLists.ready[p->priority];
80106357:	8b 45 08             	mov    0x8(%ebp),%eax
8010635a:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106360:	05 cc 09 00 00       	add    $0x9cc,%eax
80106365:	8b 14 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%edx
8010636c:	8b 45 08             	mov    0x8(%ebp),%eax
8010636f:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
    ptable.pLists.ready[p->priority] = p;
80106375:	8b 45 08             	mov    0x8(%ebp),%eax
80106378:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010637e:	8d 90 cc 09 00 00    	lea    0x9cc(%eax),%edx
80106384:	8b 45 08             	mov    0x8(%ebp),%eax
80106387:	89 04 95 ac 49 11 80 	mov    %eax,-0x7feeb654(,%edx,4)
    return 1;
8010638e:	b8 01 00 00 00       	mov    $0x1,%eax
80106393:	eb 51                	jmp    801063e6 <add_to_ready+0xcf>
  }
  struct proc* t = ptable.pLists.ready[p->priority];
80106395:	8b 45 08             	mov    0x8(%ebp),%eax
80106398:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
8010639e:	05 cc 09 00 00       	add    $0x9cc,%eax
801063a3:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
801063aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while (t->next)
801063ad:	eb 0c                	jmp    801063bb <add_to_ready+0xa4>
    t = t->next;
801063af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063b2:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801063b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p->next = ptable.pLists.ready[p->priority];
    ptable.pLists.ready[p->priority] = p;
    return 1;
  }
  struct proc* t = ptable.pLists.ready[p->priority];
  while (t->next)
801063bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063be:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801063c4:	85 c0                	test   %eax,%eax
801063c6:	75 e7                	jne    801063af <add_to_ready+0x98>
    t = t->next;
  t->next = p;
801063c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063cb:	8b 55 08             	mov    0x8(%ebp),%edx
801063ce:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
  p->next = 0;
801063d4:	8b 45 08             	mov    0x8(%ebp),%eax
801063d7:	c7 80 98 00 00 00 00 	movl   $0x0,0x98(%eax)
801063de:	00 00 00 
  return 0;
801063e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063e6:	c9                   	leave  
801063e7:	c3                   	ret    

801063e8 <exit_helper>:

// Implementation of exit helper function
static void
exit_helper(struct proc** sList)
{
801063e8:	55                   	push   %ebp
801063e9:	89 e5                	mov    %esp,%ebp
801063eb:	83 ec 10             	sub    $0x10,%esp
  struct proc* p = *sList;
801063ee:	8b 45 08             	mov    0x8(%ebp),%eax
801063f1:	8b 00                	mov    (%eax),%eax
801063f3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (p) {
801063f6:	eb 28                	jmp    80106420 <exit_helper+0x38>
    if (p->parent == proc)
801063f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801063fb:	8b 50 14             	mov    0x14(%eax),%edx
801063fe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106404:	39 c2                	cmp    %eax,%edx
80106406:	75 0c                	jne    80106414 <exit_helper+0x2c>
      p->parent = initproc;
80106408:	8b 15 88 d6 10 80    	mov    0x8010d688,%edx
8010640e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106411:	89 50 14             	mov    %edx,0x14(%eax)
    p = p->next;
80106414:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106417:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010641d:	89 45 fc             	mov    %eax,-0x4(%ebp)
// Implementation of exit helper function
static void
exit_helper(struct proc** sList)
{
  struct proc* p = *sList;
  while (p) {
80106420:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106424:	75 d2                	jne    801063f8 <exit_helper+0x10>
    if (p->parent == proc)
      p->parent = initproc;
    p = p->next;
  }
}
80106426:	90                   	nop
80106427:	c9                   	leave  
80106428:	c3                   	ret    

80106429 <wait_helper>:

// Implementation of wait helper function
static void
wait_helper(struct proc** sList, int* hk)
{
80106429:	55                   	push   %ebp
8010642a:	89 e5                	mov    %esp,%ebp
8010642c:	83 ec 10             	sub    $0x10,%esp
  struct proc* p = *sList;
8010642f:	8b 45 08             	mov    0x8(%ebp),%eax
80106432:	8b 00                	mov    (%eax),%eax
80106434:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (p) {
80106437:	eb 25                	jmp    8010645e <wait_helper+0x35>
    if (p->parent == proc)
80106439:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010643c:	8b 50 14             	mov    0x14(%eax),%edx
8010643f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106445:	39 c2                	cmp    %eax,%edx
80106447:	75 09                	jne    80106452 <wait_helper+0x29>
      *hk = 1;
80106449:	8b 45 0c             	mov    0xc(%ebp),%eax
8010644c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
    p = p->next;
80106452:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106455:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
8010645b:	89 45 fc             	mov    %eax,-0x4(%ebp)
// Implementation of wait helper function
static void
wait_helper(struct proc** sList, int* hk)
{
  struct proc* p = *sList;
  while (p) {
8010645e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
80106462:	75 d5                	jne    80106439 <wait_helper+0x10>
    if (p->parent == proc)
      *hk = 1;
    p = p->next;
  }
}
80106464:	90                   	nop
80106465:	c9                   	leave  
80106466:	c3                   	ret    

80106467 <set_priority>:

#ifdef CS333_P3P4
// Implementation of helper for set priority system call
int
set_priority(int pid, int priority)
{
80106467:	55                   	push   %ebp
80106468:	89 e5                	mov    %esp,%ebp
8010646a:	83 ec 18             	sub    $0x18,%esp
  if (pid < 0)
8010646d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80106471:	79 0a                	jns    8010647d <set_priority+0x16>
    return -1;
80106473:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106478:	e9 fd 00 00 00       	jmp    8010657a <set_priority+0x113>
  if (priority < 0 || priority > MAX)
8010647d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106481:	78 06                	js     80106489 <set_priority+0x22>
80106483:	83 7d 0c 05          	cmpl   $0x5,0xc(%ebp)
80106487:	7e 0a                	jle    80106493 <set_priority+0x2c>
    return -2;
80106489:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
8010648e:	e9 e7 00 00 00       	jmp    8010657a <set_priority+0x113>

  int hold = holding(&ptable.lock);
80106493:	83 ec 0c             	sub    $0xc,%esp
80106496:	68 a0 49 11 80       	push   $0x801149a0
8010649b:	e8 73 05 00 00       	call   80106a13 <holding>
801064a0:	83 c4 10             	add    $0x10,%esp
801064a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if (!hold) acquire(&ptable.lock);
801064a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064aa:	75 10                	jne    801064bc <set_priority+0x55>
801064ac:	83 ec 0c             	sub    $0xc,%esp
801064af:	68 a0 49 11 80       	push   $0x801149a0
801064b4:	e8 27 04 00 00       	call   801068e0 <acquire>
801064b9:	83 c4 10             	add    $0x10,%esp
  if (search_and_set(&ptable.pLists.running, pid, priority) == 0) {
801064bc:	83 ec 04             	sub    $0x4,%esp
801064bf:	ff 75 0c             	pushl  0xc(%ebp)
801064c2:	ff 75 08             	pushl  0x8(%ebp)
801064c5:	68 f4 70 11 80       	push   $0x801170f4
801064ca:	e8 ad 00 00 00       	call   8010657c <search_and_set>
801064cf:	83 c4 10             	add    $0x10,%esp
801064d2:	85 c0                	test   %eax,%eax
801064d4:	75 20                	jne    801064f6 <set_priority+0x8f>
    if (!hold) release(&ptable.lock);
801064d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064da:	75 10                	jne    801064ec <set_priority+0x85>
801064dc:	83 ec 0c             	sub    $0xc,%esp
801064df:	68 a0 49 11 80       	push   $0x801149a0
801064e4:	e8 5e 04 00 00       	call   80106947 <release>
801064e9:	83 c4 10             	add    $0x10,%esp
    return 0;
801064ec:	b8 00 00 00 00       	mov    $0x0,%eax
801064f1:	e9 84 00 00 00       	jmp    8010657a <set_priority+0x113>
  }
  if (search_and_set(&ptable.pLists.sleep, pid, priority) == 0) {
801064f6:	83 ec 04             	sub    $0x4,%esp
801064f9:	ff 75 0c             	pushl  0xc(%ebp)
801064fc:	ff 75 08             	pushl  0x8(%ebp)
801064ff:	68 f8 70 11 80       	push   $0x801170f8
80106504:	e8 73 00 00 00       	call   8010657c <search_and_set>
80106509:	83 c4 10             	add    $0x10,%esp
8010650c:	85 c0                	test   %eax,%eax
8010650e:	75 1d                	jne    8010652d <set_priority+0xc6>
    if (!hold) release(&ptable.lock);
80106510:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106514:	75 10                	jne    80106526 <set_priority+0xbf>
80106516:	83 ec 0c             	sub    $0xc,%esp
80106519:	68 a0 49 11 80       	push   $0x801149a0
8010651e:	e8 24 04 00 00       	call   80106947 <release>
80106523:	83 c4 10             	add    $0x10,%esp
    return 0;
80106526:	b8 00 00 00 00       	mov    $0x0,%eax
8010652b:	eb 4d                	jmp    8010657a <set_priority+0x113>
  }
  if (search_and_set_ready(pid, priority) == 0) {
8010652d:	83 ec 08             	sub    $0x8,%esp
80106530:	ff 75 0c             	pushl  0xc(%ebp)
80106533:	ff 75 08             	pushl  0x8(%ebp)
80106536:	e8 ae 00 00 00       	call   801065e9 <search_and_set_ready>
8010653b:	83 c4 10             	add    $0x10,%esp
8010653e:	85 c0                	test   %eax,%eax
80106540:	75 1d                	jne    8010655f <set_priority+0xf8>
    if (!hold) release(&ptable.lock);
80106542:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106546:	75 10                	jne    80106558 <set_priority+0xf1>
80106548:	83 ec 0c             	sub    $0xc,%esp
8010654b:	68 a0 49 11 80       	push   $0x801149a0
80106550:	e8 f2 03 00 00       	call   80106947 <release>
80106555:	83 c4 10             	add    $0x10,%esp
    return 0;
80106558:	b8 00 00 00 00       	mov    $0x0,%eax
8010655d:	eb 1b                	jmp    8010657a <set_priority+0x113>
  }
  if (!hold) release(&ptable.lock);
8010655f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106563:	75 10                	jne    80106575 <set_priority+0x10e>
80106565:	83 ec 0c             	sub    $0xc,%esp
80106568:	68 a0 49 11 80       	push   $0x801149a0
8010656d:	e8 d5 03 00 00       	call   80106947 <release>
80106572:	83 c4 10             	add    $0x10,%esp
  return -1; // Failed to find process with PID matching arg pid
80106575:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010657a:	c9                   	leave  
8010657b:	c3                   	ret    

8010657c <search_and_set>:
// Searches a list for a proc with PID pid and sets its priority
// to the value passed in via prio argument
// NEVER USED OUTSIDE OF A LOCKED SECTION OF CODE
static int 
search_and_set(struct proc** sList, int pid, int prio)
{
8010657c:	55                   	push   %ebp
8010657d:	89 e5                	mov    %esp,%ebp
8010657f:	83 ec 10             	sub    $0x10,%esp
  if (!sList)
80106582:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80106586:	75 07                	jne    8010658f <search_and_set+0x13>
    return -1; // Null list
80106588:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010658d:	eb 58                	jmp    801065e7 <search_and_set+0x6b>
  struct proc* p = *sList;
8010658f:	8b 45 08             	mov    0x8(%ebp),%eax
80106592:	8b 00                	mov    (%eax),%eax
80106594:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (p) {
80106597:	eb 43                	jmp    801065dc <search_and_set+0x60>
    if (p->pid == pid) {
80106599:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010659c:	8b 50 10             	mov    0x10(%eax),%edx
8010659f:	8b 45 0c             	mov    0xc(%ebp),%eax
801065a2:	39 c2                	cmp    %eax,%edx
801065a4:	75 2a                	jne    801065d0 <search_and_set+0x54>
      if (p->priority == prio)
801065a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065a9:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
801065af:	8b 45 10             	mov    0x10(%ebp),%eax
801065b2:	39 c2                	cmp    %eax,%edx
801065b4:	75 07                	jne    801065bd <search_and_set+0x41>
        return 1; // No change necessary 
801065b6:	b8 01 00 00 00       	mov    $0x1,%eax
801065bb:	eb 2a                	jmp    801065e7 <search_and_set+0x6b>
      else {
        p->priority = prio;
801065bd:	8b 55 10             	mov    0x10(%ebp),%edx
801065c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065c3:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
        return 0; // Success!
801065c9:	b8 00 00 00 00       	mov    $0x0,%eax
801065ce:	eb 17                	jmp    801065e7 <search_and_set+0x6b>
      }
    }
    p = p->next;
801065d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801065d3:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801065d9:	89 45 fc             	mov    %eax,-0x4(%ebp)
search_and_set(struct proc** sList, int pid, int prio)
{
  if (!sList)
    return -1; // Null list
  struct proc* p = *sList;
  while (p) {
801065dc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801065e0:	75 b7                	jne    80106599 <search_and_set+0x1d>
        return 0; // Success!
      }
    }
    p = p->next;
  }
  return -2; // Not found
801065e2:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
}
801065e7:	c9                   	leave  
801065e8:	c3                   	ret    

801065e9 <search_and_set_ready>:
// Specifically handles the ready list since the process also needs
// to be moved to a different ready queue.
// NEVER USED OUTSIDE OF A LOCKED SECTION OF CODE
static int
search_and_set_ready(int pid, int prio)
{
801065e9:	55                   	push   %ebp
801065ea:	89 e5                	mov    %esp,%ebp
801065ec:	83 ec 18             	sub    $0x18,%esp
  for (int i = 0; i < MAX+1; i++) {
801065ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801065f6:	e9 c1 00 00 00       	jmp    801066bc <search_and_set_ready+0xd3>
    if (!ptable.pLists.ready[i])
801065fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801065fe:	05 cc 09 00 00       	add    $0x9cc,%eax
80106603:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
8010660a:	85 c0                	test   %eax,%eax
8010660c:	0f 84 a5 00 00 00    	je     801066b7 <search_and_set_ready+0xce>
      continue;
    struct proc* p = ptable.pLists.ready[i];
80106612:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106615:	05 cc 09 00 00       	add    $0x9cc,%eax
8010661a:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
80106621:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (p) {
80106624:	e9 82 00 00 00       	jmp    801066ab <search_and_set_ready+0xc2>
      if (p->pid == pid) {
80106629:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010662c:	8b 50 10             	mov    0x10(%eax),%edx
8010662f:	8b 45 08             	mov    0x8(%ebp),%eax
80106632:	39 c2                	cmp    %eax,%edx
80106634:	75 69                	jne    8010669f <search_and_set_ready+0xb6>
        if (p->priority == prio)
80106636:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106639:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
8010663f:	8b 45 0c             	mov    0xc(%ebp),%eax
80106642:	39 c2                	cmp    %eax,%edx
80106644:	75 07                	jne    8010664d <search_and_set_ready+0x64>
          return 1; // No changes need to be made since prio already matches
80106646:	b8 01 00 00 00       	mov    $0x1,%eax
8010664b:	eb 7e                	jmp    801066cb <search_and_set_ready+0xe2>
        else {
          p->priority = prio;
8010664d:	8b 55 0c             	mov    0xc(%ebp),%edx
80106650:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106653:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
          remove_from_list(&ptable.pLists.ready[i], p);
80106659:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010665c:	05 cc 09 00 00       	add    $0x9cc,%eax
80106661:	c1 e0 02             	shl    $0x2,%eax
80106664:	05 a0 49 11 80       	add    $0x801149a0,%eax
80106669:	83 c0 0c             	add    $0xc,%eax
8010666c:	ff 75 f0             	pushl  -0x10(%ebp)
8010666f:	50                   	push   %eax
80106670:	e8 b5 fb ff ff       	call   8010622a <remove_from_list>
80106675:	83 c4 08             	add    $0x8,%esp
          assert_state(p, RUNNABLE);
80106678:	83 ec 08             	sub    $0x8,%esp
8010667b:	6a 03                	push   $0x3
8010667d:	ff 75 f0             	pushl  -0x10(%ebp)
80106680:	e8 84 fb ff ff       	call   80106209 <assert_state>
80106685:	83 c4 10             	add    $0x10,%esp
          add_to_ready(p, RUNNABLE);
80106688:	83 ec 08             	sub    $0x8,%esp
8010668b:	6a 03                	push   $0x3
8010668d:	ff 75 f0             	pushl  -0x10(%ebp)
80106690:	e8 82 fc ff ff       	call   80106317 <add_to_ready>
80106695:	83 c4 10             	add    $0x10,%esp
          return 0;
80106698:	b8 00 00 00 00       	mov    $0x0,%eax
8010669d:	eb 2c                	jmp    801066cb <search_and_set_ready+0xe2>
        }
      }
      p = p->next;  
8010669f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066a2:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801066a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
{
  for (int i = 0; i < MAX+1; i++) {
    if (!ptable.pLists.ready[i])
      continue;
    struct proc* p = ptable.pLists.ready[i];
    while (p) {
801066ab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066af:	0f 85 74 ff ff ff    	jne    80106629 <search_and_set_ready+0x40>
801066b5:	eb 01                	jmp    801066b8 <search_and_set_ready+0xcf>
static int
search_and_set_ready(int pid, int prio)
{
  for (int i = 0; i < MAX+1; i++) {
    if (!ptable.pLists.ready[i])
      continue;
801066b7:	90                   	nop
// to be moved to a different ready queue.
// NEVER USED OUTSIDE OF A LOCKED SECTION OF CODE
static int
search_and_set_ready(int pid, int prio)
{
  for (int i = 0; i < MAX+1; i++) {
801066b8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801066bc:	83 7d f4 05          	cmpl   $0x5,-0xc(%ebp)
801066c0:	0f 8e 35 ff ff ff    	jle    801065fb <search_and_set_ready+0x12>
        }
      }
      p = p->next;  
    }
  }
  return -2;
801066c6:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
}
801066cb:	c9                   	leave  
801066cc:	c3                   	ret    

801066cd <priority_promotion>:
#endif

#ifdef CS333_P3P4
static int 
priority_promotion()
{
801066cd:	55                   	push   %ebp
801066ce:	89 e5                	mov    %esp,%ebp
801066d0:	83 ec 18             	sub    $0x18,%esp
  int hold = holding(&ptable.lock);
801066d3:	83 ec 0c             	sub    $0xc,%esp
801066d6:	68 a0 49 11 80       	push   $0x801149a0
801066db:	e8 33 03 00 00       	call   80106a13 <holding>
801066e0:	83 c4 10             	add    $0x10,%esp
801066e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if (!hold) acquire(&ptable.lock);
801066e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801066ea:	75 10                	jne    801066fc <priority_promotion+0x2f>
801066ec:	83 ec 0c             	sub    $0xc,%esp
801066ef:	68 a0 49 11 80       	push   $0x801149a0
801066f4:	e8 e7 01 00 00       	call   801068e0 <acquire>
801066f9:	83 c4 10             	add    $0x10,%esp
  if (MAX == 0)     // Only one list so simple round robin scheduler
    return -1;
  promote_list(&ptable.pLists.running);
801066fc:	83 ec 0c             	sub    $0xc,%esp
801066ff:	68 f4 70 11 80       	push   $0x801170f4
80106704:	e8 25 01 00 00       	call   8010682e <promote_list>
80106709:	83 c4 10             	add    $0x10,%esp
  promote_list(&ptable.pLists.sleep);
8010670c:	83 ec 0c             	sub    $0xc,%esp
8010670f:	68 f8 70 11 80       	push   $0x801170f8
80106714:	e8 15 01 00 00       	call   8010682e <promote_list>
80106719:	83 c4 10             	add    $0x10,%esp
  for (int i = 0; i < MAX; i++) {
8010671c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106723:	e9 df 00 00 00       	jmp    80106807 <priority_promotion+0x13a>
    if (!ptable.pLists.ready[i+1])
80106728:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010672b:	83 c0 01             	add    $0x1,%eax
8010672e:	05 cc 09 00 00       	add    $0x9cc,%eax
80106733:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
8010673a:	85 c0                	test   %eax,%eax
8010673c:	0f 84 c0 00 00 00    	je     80106802 <priority_promotion+0x135>
      continue;
    promote_list(&ptable.pLists.ready[i+1]);
80106742:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106745:	83 c0 01             	add    $0x1,%eax
80106748:	05 cc 09 00 00       	add    $0x9cc,%eax
8010674d:	c1 e0 02             	shl    $0x2,%eax
80106750:	05 a0 49 11 80       	add    $0x801149a0,%eax
80106755:	83 c0 0c             	add    $0xc,%eax
80106758:	83 ec 0c             	sub    $0xc,%esp
8010675b:	50                   	push   %eax
8010675c:	e8 cd 00 00 00       	call   8010682e <promote_list>
80106761:	83 c4 10             	add    $0x10,%esp
    struct proc* p = ptable.pLists.ready[i];
80106764:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106767:	05 cc 09 00 00       	add    $0x9cc,%eax
8010676c:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
80106773:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!p) {
80106776:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010677a:	75 46                	jne    801067c2 <priority_promotion+0xf5>
      ptable.pLists.ready[i] = ptable.pLists.ready[i+1];
8010677c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010677f:	83 c0 01             	add    $0x1,%eax
80106782:	05 cc 09 00 00       	add    $0x9cc,%eax
80106787:	8b 04 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%eax
8010678e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106791:	81 c2 cc 09 00 00    	add    $0x9cc,%edx
80106797:	89 04 95 ac 49 11 80 	mov    %eax,-0x7feeb654(,%edx,4)
      ptable.pLists.ready[i+1] = 0;
8010679e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067a1:	83 c0 01             	add    $0x1,%eax
801067a4:	05 cc 09 00 00       	add    $0x9cc,%eax
801067a9:	c7 04 85 ac 49 11 80 	movl   $0x0,-0x7feeb654(,%eax,4)
801067b0:	00 00 00 00 
801067b4:	eb 4d                	jmp    80106803 <priority_promotion+0x136>
    } else {
      while (p->next)
        p = p->next;
801067b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067b9:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801067bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct proc* p = ptable.pLists.ready[i];
    if (!p) {
      ptable.pLists.ready[i] = ptable.pLists.ready[i+1];
      ptable.pLists.ready[i+1] = 0;
    } else {
      while (p->next)
801067c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067c5:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
801067cb:	85 c0                	test   %eax,%eax
801067cd:	75 e7                	jne    801067b6 <priority_promotion+0xe9>
        p = p->next;
      p->next = ptable.pLists.ready[i+1];
801067cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067d2:	83 c0 01             	add    $0x1,%eax
801067d5:	05 cc 09 00 00       	add    $0x9cc,%eax
801067da:	8b 14 85 ac 49 11 80 	mov    -0x7feeb654(,%eax,4),%edx
801067e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801067e4:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
      ptable.pLists.ready[i+1] = 0;
801067ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067ed:	83 c0 01             	add    $0x1,%eax
801067f0:	05 cc 09 00 00       	add    $0x9cc,%eax
801067f5:	c7 04 85 ac 49 11 80 	movl   $0x0,-0x7feeb654(,%eax,4)
801067fc:	00 00 00 00 
80106800:	eb 01                	jmp    80106803 <priority_promotion+0x136>
    return -1;
  promote_list(&ptable.pLists.running);
  promote_list(&ptable.pLists.sleep);
  for (int i = 0; i < MAX; i++) {
    if (!ptable.pLists.ready[i+1])
      continue;
80106802:	90                   	nop
  if (!hold) acquire(&ptable.lock);
  if (MAX == 0)     // Only one list so simple round robin scheduler
    return -1;
  promote_list(&ptable.pLists.running);
  promote_list(&ptable.pLists.sleep);
  for (int i = 0; i < MAX; i++) {
80106803:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106807:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
8010680b:	0f 8e 17 ff ff ff    	jle    80106728 <priority_promotion+0x5b>
        p = p->next;
      p->next = ptable.pLists.ready[i+1];
      ptable.pLists.ready[i+1] = 0;
    }
  }
  if (!hold) release(&ptable.lock);
80106811:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80106815:	75 10                	jne    80106827 <priority_promotion+0x15a>
80106817:	83 ec 0c             	sub    $0xc,%esp
8010681a:	68 a0 49 11 80       	push   $0x801149a0
8010681f:	e8 23 01 00 00       	call   80106947 <release>
80106824:	83 c4 10             	add    $0x10,%esp
  return 1; 
80106827:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010682c:	c9                   	leave  
8010682d:	c3                   	ret    

8010682e <promote_list>:
#endif

#ifdef CS333_P3P4
static int 
promote_list(struct proc** list)
{
8010682e:	55                   	push   %ebp
8010682f:	89 e5                	mov    %esp,%ebp
80106831:	83 ec 10             	sub    $0x10,%esp
  if (!list)
80106834:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80106838:	75 07                	jne    80106841 <promote_list+0x13>
    return -1;
8010683a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010683f:	eb 43                	jmp    80106884 <promote_list+0x56>

  struct proc* p = *list;
80106841:	8b 45 08             	mov    0x8(%ebp),%eax
80106844:	8b 00                	mov    (%eax),%eax
80106846:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while (p) {
80106849:	eb 2e                	jmp    80106879 <promote_list+0x4b>
    if (p->priority > 0)
8010684b:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010684e:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106854:	85 c0                	test   %eax,%eax
80106856:	74 15                	je     8010686d <promote_list+0x3f>
      p->priority = p->priority-1;
80106858:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010685b:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80106861:	8d 50 ff             	lea    -0x1(%eax),%edx
80106864:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106867:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
    p = p->next;
8010686d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106870:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80106876:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  if (!list)
    return -1;

  struct proc* p = *list;
  while (p) {
80106879:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010687d:	75 cc                	jne    8010684b <promote_list+0x1d>
    if (p->priority > 0)
      p->priority = p->priority-1;
    p = p->next;
  }
  return 0;
8010687f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106884:	c9                   	leave  
80106885:	c3                   	ret    

80106886 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80106886:	55                   	push   %ebp
80106887:	89 e5                	mov    %esp,%ebp
80106889:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010688c:	9c                   	pushf  
8010688d:	58                   	pop    %eax
8010688e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80106891:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106894:	c9                   	leave  
80106895:	c3                   	ret    

80106896 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80106896:	55                   	push   %ebp
80106897:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80106899:	fa                   	cli    
}
8010689a:	90                   	nop
8010689b:	5d                   	pop    %ebp
8010689c:	c3                   	ret    

8010689d <sti>:

static inline void
sti(void)
{
8010689d:	55                   	push   %ebp
8010689e:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801068a0:	fb                   	sti    
}
801068a1:	90                   	nop
801068a2:	5d                   	pop    %ebp
801068a3:	c3                   	ret    

801068a4 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801068a4:	55                   	push   %ebp
801068a5:	89 e5                	mov    %esp,%ebp
801068a7:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801068aa:	8b 55 08             	mov    0x8(%ebp),%edx
801068ad:	8b 45 0c             	mov    0xc(%ebp),%eax
801068b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
801068b3:	f0 87 02             	lock xchg %eax,(%edx)
801068b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801068b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801068bc:	c9                   	leave  
801068bd:	c3                   	ret    

801068be <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801068be:	55                   	push   %ebp
801068bf:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801068c1:	8b 45 08             	mov    0x8(%ebp),%eax
801068c4:	8b 55 0c             	mov    0xc(%ebp),%edx
801068c7:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801068ca:	8b 45 08             	mov    0x8(%ebp),%eax
801068cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801068d3:	8b 45 08             	mov    0x8(%ebp),%eax
801068d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801068dd:	90                   	nop
801068de:	5d                   	pop    %ebp
801068df:	c3                   	ret    

801068e0 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801068e0:	55                   	push   %ebp
801068e1:	89 e5                	mov    %esp,%ebp
801068e3:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801068e6:	e8 52 01 00 00       	call   80106a3d <pushcli>
  if(holding(lk))
801068eb:	8b 45 08             	mov    0x8(%ebp),%eax
801068ee:	83 ec 0c             	sub    $0xc,%esp
801068f1:	50                   	push   %eax
801068f2:	e8 1c 01 00 00       	call   80106a13 <holding>
801068f7:	83 c4 10             	add    $0x10,%esp
801068fa:	85 c0                	test   %eax,%eax
801068fc:	74 0d                	je     8010690b <acquire+0x2b>
    panic("acquire");
801068fe:	83 ec 0c             	sub    $0xc,%esp
80106901:	68 8c a6 10 80       	push   $0x8010a68c
80106906:	e8 5b 9c ff ff       	call   80100566 <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
8010690b:	90                   	nop
8010690c:	8b 45 08             	mov    0x8(%ebp),%eax
8010690f:	83 ec 08             	sub    $0x8,%esp
80106912:	6a 01                	push   $0x1
80106914:	50                   	push   %eax
80106915:	e8 8a ff ff ff       	call   801068a4 <xchg>
8010691a:	83 c4 10             	add    $0x10,%esp
8010691d:	85 c0                	test   %eax,%eax
8010691f:	75 eb                	jne    8010690c <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80106921:	8b 45 08             	mov    0x8(%ebp),%eax
80106924:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010692b:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
8010692e:	8b 45 08             	mov    0x8(%ebp),%eax
80106931:	83 c0 0c             	add    $0xc,%eax
80106934:	83 ec 08             	sub    $0x8,%esp
80106937:	50                   	push   %eax
80106938:	8d 45 08             	lea    0x8(%ebp),%eax
8010693b:	50                   	push   %eax
8010693c:	e8 58 00 00 00       	call   80106999 <getcallerpcs>
80106941:	83 c4 10             	add    $0x10,%esp
}
80106944:	90                   	nop
80106945:	c9                   	leave  
80106946:	c3                   	ret    

80106947 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80106947:	55                   	push   %ebp
80106948:	89 e5                	mov    %esp,%ebp
8010694a:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
8010694d:	83 ec 0c             	sub    $0xc,%esp
80106950:	ff 75 08             	pushl  0x8(%ebp)
80106953:	e8 bb 00 00 00       	call   80106a13 <holding>
80106958:	83 c4 10             	add    $0x10,%esp
8010695b:	85 c0                	test   %eax,%eax
8010695d:	75 0d                	jne    8010696c <release+0x25>
    panic("release");
8010695f:	83 ec 0c             	sub    $0xc,%esp
80106962:	68 94 a6 10 80       	push   $0x8010a694
80106967:	e8 fa 9b ff ff       	call   80100566 <panic>

  lk->pcs[0] = 0;
8010696c:	8b 45 08             	mov    0x8(%ebp),%eax
8010696f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80106976:	8b 45 08             	mov    0x8(%ebp),%eax
80106979:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
80106980:	8b 45 08             	mov    0x8(%ebp),%eax
80106983:	83 ec 08             	sub    $0x8,%esp
80106986:	6a 00                	push   $0x0
80106988:	50                   	push   %eax
80106989:	e8 16 ff ff ff       	call   801068a4 <xchg>
8010698e:	83 c4 10             	add    $0x10,%esp

  popcli();
80106991:	e8 ec 00 00 00       	call   80106a82 <popcli>
}
80106996:	90                   	nop
80106997:	c9                   	leave  
80106998:	c3                   	ret    

80106999 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80106999:	55                   	push   %ebp
8010699a:	89 e5                	mov    %esp,%ebp
8010699c:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
8010699f:	8b 45 08             	mov    0x8(%ebp),%eax
801069a2:	83 e8 08             	sub    $0x8,%eax
801069a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801069a8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801069af:	eb 38                	jmp    801069e9 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801069b1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801069b5:	74 53                	je     80106a0a <getcallerpcs+0x71>
801069b7:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801069be:	76 4a                	jbe    80106a0a <getcallerpcs+0x71>
801069c0:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801069c4:	74 44                	je     80106a0a <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
801069c6:	8b 45 f8             	mov    -0x8(%ebp),%eax
801069c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801069d0:	8b 45 0c             	mov    0xc(%ebp),%eax
801069d3:	01 c2                	add    %eax,%edx
801069d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801069d8:	8b 40 04             	mov    0x4(%eax),%eax
801069db:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801069dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801069e0:	8b 00                	mov    (%eax),%eax
801069e2:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801069e5:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801069e9:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801069ed:	7e c2                	jle    801069b1 <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801069ef:	eb 19                	jmp    80106a0a <getcallerpcs+0x71>
    pcs[i] = 0;
801069f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801069f4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801069fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801069fe:	01 d0                	add    %edx,%eax
80106a00:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80106a06:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80106a0a:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80106a0e:	7e e1                	jle    801069f1 <getcallerpcs+0x58>
    pcs[i] = 0;
}
80106a10:	90                   	nop
80106a11:	c9                   	leave  
80106a12:	c3                   	ret    

80106a13 <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80106a13:	55                   	push   %ebp
80106a14:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80106a16:	8b 45 08             	mov    0x8(%ebp),%eax
80106a19:	8b 00                	mov    (%eax),%eax
80106a1b:	85 c0                	test   %eax,%eax
80106a1d:	74 17                	je     80106a36 <holding+0x23>
80106a1f:	8b 45 08             	mov    0x8(%ebp),%eax
80106a22:	8b 50 08             	mov    0x8(%eax),%edx
80106a25:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a2b:	39 c2                	cmp    %eax,%edx
80106a2d:	75 07                	jne    80106a36 <holding+0x23>
80106a2f:	b8 01 00 00 00       	mov    $0x1,%eax
80106a34:	eb 05                	jmp    80106a3b <holding+0x28>
80106a36:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106a3b:	5d                   	pop    %ebp
80106a3c:	c3                   	ret    

80106a3d <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80106a3d:	55                   	push   %ebp
80106a3e:	89 e5                	mov    %esp,%ebp
80106a40:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
80106a43:	e8 3e fe ff ff       	call   80106886 <readeflags>
80106a48:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80106a4b:	e8 46 fe ff ff       	call   80106896 <cli>
  if(cpu->ncli++ == 0)
80106a50:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80106a57:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80106a5d:	8d 48 01             	lea    0x1(%eax),%ecx
80106a60:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80106a66:	85 c0                	test   %eax,%eax
80106a68:	75 15                	jne    80106a7f <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80106a6a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106a70:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106a73:	81 e2 00 02 00 00    	and    $0x200,%edx
80106a79:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80106a7f:	90                   	nop
80106a80:	c9                   	leave  
80106a81:	c3                   	ret    

80106a82 <popcli>:

void
popcli(void)
{
80106a82:	55                   	push   %ebp
80106a83:	89 e5                	mov    %esp,%ebp
80106a85:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80106a88:	e8 f9 fd ff ff       	call   80106886 <readeflags>
80106a8d:	25 00 02 00 00       	and    $0x200,%eax
80106a92:	85 c0                	test   %eax,%eax
80106a94:	74 0d                	je     80106aa3 <popcli+0x21>
    panic("popcli - interruptible");
80106a96:	83 ec 0c             	sub    $0xc,%esp
80106a99:	68 9c a6 10 80       	push   $0x8010a69c
80106a9e:	e8 c3 9a ff ff       	call   80100566 <panic>
  if(--cpu->ncli < 0)
80106aa3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106aa9:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80106aaf:	83 ea 01             	sub    $0x1,%edx
80106ab2:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
80106ab8:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106abe:	85 c0                	test   %eax,%eax
80106ac0:	79 0d                	jns    80106acf <popcli+0x4d>
    panic("popcli");
80106ac2:	83 ec 0c             	sub    $0xc,%esp
80106ac5:	68 b3 a6 10 80       	push   $0x8010a6b3
80106aca:	e8 97 9a ff ff       	call   80100566 <panic>
  if(cpu->ncli == 0 && cpu->intena)
80106acf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106ad5:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80106adb:	85 c0                	test   %eax,%eax
80106add:	75 15                	jne    80106af4 <popcli+0x72>
80106adf:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80106ae5:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80106aeb:	85 c0                	test   %eax,%eax
80106aed:	74 05                	je     80106af4 <popcli+0x72>
    sti();
80106aef:	e8 a9 fd ff ff       	call   8010689d <sti>
}
80106af4:	90                   	nop
80106af5:	c9                   	leave  
80106af6:	c3                   	ret    

80106af7 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
80106af7:	55                   	push   %ebp
80106af8:	89 e5                	mov    %esp,%ebp
80106afa:	57                   	push   %edi
80106afb:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80106afc:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106aff:	8b 55 10             	mov    0x10(%ebp),%edx
80106b02:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b05:	89 cb                	mov    %ecx,%ebx
80106b07:	89 df                	mov    %ebx,%edi
80106b09:	89 d1                	mov    %edx,%ecx
80106b0b:	fc                   	cld    
80106b0c:	f3 aa                	rep stos %al,%es:(%edi)
80106b0e:	89 ca                	mov    %ecx,%edx
80106b10:	89 fb                	mov    %edi,%ebx
80106b12:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106b15:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106b18:	90                   	nop
80106b19:	5b                   	pop    %ebx
80106b1a:	5f                   	pop    %edi
80106b1b:	5d                   	pop    %ebp
80106b1c:	c3                   	ret    

80106b1d <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80106b1d:	55                   	push   %ebp
80106b1e:	89 e5                	mov    %esp,%ebp
80106b20:	57                   	push   %edi
80106b21:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80106b22:	8b 4d 08             	mov    0x8(%ebp),%ecx
80106b25:	8b 55 10             	mov    0x10(%ebp),%edx
80106b28:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b2b:	89 cb                	mov    %ecx,%ebx
80106b2d:	89 df                	mov    %ebx,%edi
80106b2f:	89 d1                	mov    %edx,%ecx
80106b31:	fc                   	cld    
80106b32:	f3 ab                	rep stos %eax,%es:(%edi)
80106b34:	89 ca                	mov    %ecx,%edx
80106b36:	89 fb                	mov    %edi,%ebx
80106b38:	89 5d 08             	mov    %ebx,0x8(%ebp)
80106b3b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80106b3e:	90                   	nop
80106b3f:	5b                   	pop    %ebx
80106b40:	5f                   	pop    %edi
80106b41:	5d                   	pop    %ebp
80106b42:	c3                   	ret    

80106b43 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80106b43:	55                   	push   %ebp
80106b44:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80106b46:	8b 45 08             	mov    0x8(%ebp),%eax
80106b49:	83 e0 03             	and    $0x3,%eax
80106b4c:	85 c0                	test   %eax,%eax
80106b4e:	75 43                	jne    80106b93 <memset+0x50>
80106b50:	8b 45 10             	mov    0x10(%ebp),%eax
80106b53:	83 e0 03             	and    $0x3,%eax
80106b56:	85 c0                	test   %eax,%eax
80106b58:	75 39                	jne    80106b93 <memset+0x50>
    c &= 0xFF;
80106b5a:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80106b61:	8b 45 10             	mov    0x10(%ebp),%eax
80106b64:	c1 e8 02             	shr    $0x2,%eax
80106b67:	89 c1                	mov    %eax,%ecx
80106b69:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b6c:	c1 e0 18             	shl    $0x18,%eax
80106b6f:	89 c2                	mov    %eax,%edx
80106b71:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b74:	c1 e0 10             	shl    $0x10,%eax
80106b77:	09 c2                	or     %eax,%edx
80106b79:	8b 45 0c             	mov    0xc(%ebp),%eax
80106b7c:	c1 e0 08             	shl    $0x8,%eax
80106b7f:	09 d0                	or     %edx,%eax
80106b81:	0b 45 0c             	or     0xc(%ebp),%eax
80106b84:	51                   	push   %ecx
80106b85:	50                   	push   %eax
80106b86:	ff 75 08             	pushl  0x8(%ebp)
80106b89:	e8 8f ff ff ff       	call   80106b1d <stosl>
80106b8e:	83 c4 0c             	add    $0xc,%esp
80106b91:	eb 12                	jmp    80106ba5 <memset+0x62>
  } else
    stosb(dst, c, n);
80106b93:	8b 45 10             	mov    0x10(%ebp),%eax
80106b96:	50                   	push   %eax
80106b97:	ff 75 0c             	pushl  0xc(%ebp)
80106b9a:	ff 75 08             	pushl  0x8(%ebp)
80106b9d:	e8 55 ff ff ff       	call   80106af7 <stosb>
80106ba2:	83 c4 0c             	add    $0xc,%esp
  return dst;
80106ba5:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106ba8:	c9                   	leave  
80106ba9:	c3                   	ret    

80106baa <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80106baa:	55                   	push   %ebp
80106bab:	89 e5                	mov    %esp,%ebp
80106bad:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
80106bb0:	8b 45 08             	mov    0x8(%ebp),%eax
80106bb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
80106bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
80106bb9:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
80106bbc:	eb 30                	jmp    80106bee <memcmp+0x44>
    if(*s1 != *s2)
80106bbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106bc1:	0f b6 10             	movzbl (%eax),%edx
80106bc4:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106bc7:	0f b6 00             	movzbl (%eax),%eax
80106bca:	38 c2                	cmp    %al,%dl
80106bcc:	74 18                	je     80106be6 <memcmp+0x3c>
      return *s1 - *s2;
80106bce:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106bd1:	0f b6 00             	movzbl (%eax),%eax
80106bd4:	0f b6 d0             	movzbl %al,%edx
80106bd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106bda:	0f b6 00             	movzbl (%eax),%eax
80106bdd:	0f b6 c0             	movzbl %al,%eax
80106be0:	29 c2                	sub    %eax,%edx
80106be2:	89 d0                	mov    %edx,%eax
80106be4:	eb 1a                	jmp    80106c00 <memcmp+0x56>
    s1++, s2++;
80106be6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106bea:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80106bee:	8b 45 10             	mov    0x10(%ebp),%eax
80106bf1:	8d 50 ff             	lea    -0x1(%eax),%edx
80106bf4:	89 55 10             	mov    %edx,0x10(%ebp)
80106bf7:	85 c0                	test   %eax,%eax
80106bf9:	75 c3                	jne    80106bbe <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
80106bfb:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c00:	c9                   	leave  
80106c01:	c3                   	ret    

80106c02 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80106c02:	55                   	push   %ebp
80106c03:	89 e5                	mov    %esp,%ebp
80106c05:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
80106c08:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c0b:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80106c0e:	8b 45 08             	mov    0x8(%ebp),%eax
80106c11:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80106c14:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106c17:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106c1a:	73 54                	jae    80106c70 <memmove+0x6e>
80106c1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106c1f:	8b 45 10             	mov    0x10(%ebp),%eax
80106c22:	01 d0                	add    %edx,%eax
80106c24:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106c27:	76 47                	jbe    80106c70 <memmove+0x6e>
    s += n;
80106c29:	8b 45 10             	mov    0x10(%ebp),%eax
80106c2c:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80106c2f:	8b 45 10             	mov    0x10(%ebp),%eax
80106c32:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80106c35:	eb 13                	jmp    80106c4a <memmove+0x48>
      *--d = *--s;
80106c37:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80106c3b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80106c3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106c42:	0f b6 10             	movzbl (%eax),%edx
80106c45:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106c48:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
80106c4a:	8b 45 10             	mov    0x10(%ebp),%eax
80106c4d:	8d 50 ff             	lea    -0x1(%eax),%edx
80106c50:	89 55 10             	mov    %edx,0x10(%ebp)
80106c53:	85 c0                	test   %eax,%eax
80106c55:	75 e0                	jne    80106c37 <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80106c57:	eb 24                	jmp    80106c7d <memmove+0x7b>
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
      *d++ = *s++;
80106c59:	8b 45 f8             	mov    -0x8(%ebp),%eax
80106c5c:	8d 50 01             	lea    0x1(%eax),%edx
80106c5f:	89 55 f8             	mov    %edx,-0x8(%ebp)
80106c62:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106c65:	8d 4a 01             	lea    0x1(%edx),%ecx
80106c68:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80106c6b:	0f b6 12             	movzbl (%edx),%edx
80106c6e:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80106c70:	8b 45 10             	mov    0x10(%ebp),%eax
80106c73:	8d 50 ff             	lea    -0x1(%eax),%edx
80106c76:	89 55 10             	mov    %edx,0x10(%ebp)
80106c79:	85 c0                	test   %eax,%eax
80106c7b:	75 dc                	jne    80106c59 <memmove+0x57>
      *d++ = *s++;

  return dst;
80106c7d:	8b 45 08             	mov    0x8(%ebp),%eax
}
80106c80:	c9                   	leave  
80106c81:	c3                   	ret    

80106c82 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80106c82:	55                   	push   %ebp
80106c83:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
80106c85:	ff 75 10             	pushl  0x10(%ebp)
80106c88:	ff 75 0c             	pushl  0xc(%ebp)
80106c8b:	ff 75 08             	pushl  0x8(%ebp)
80106c8e:	e8 6f ff ff ff       	call   80106c02 <memmove>
80106c93:	83 c4 0c             	add    $0xc,%esp
}
80106c96:	c9                   	leave  
80106c97:	c3                   	ret    

80106c98 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80106c98:	55                   	push   %ebp
80106c99:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80106c9b:	eb 0c                	jmp    80106ca9 <strncmp+0x11>
    n--, p++, q++;
80106c9d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106ca1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
80106ca5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80106ca9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106cad:	74 1a                	je     80106cc9 <strncmp+0x31>
80106caf:	8b 45 08             	mov    0x8(%ebp),%eax
80106cb2:	0f b6 00             	movzbl (%eax),%eax
80106cb5:	84 c0                	test   %al,%al
80106cb7:	74 10                	je     80106cc9 <strncmp+0x31>
80106cb9:	8b 45 08             	mov    0x8(%ebp),%eax
80106cbc:	0f b6 10             	movzbl (%eax),%edx
80106cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
80106cc2:	0f b6 00             	movzbl (%eax),%eax
80106cc5:	38 c2                	cmp    %al,%dl
80106cc7:	74 d4                	je     80106c9d <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
80106cc9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106ccd:	75 07                	jne    80106cd6 <strncmp+0x3e>
    return 0;
80106ccf:	b8 00 00 00 00       	mov    $0x0,%eax
80106cd4:	eb 16                	jmp    80106cec <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
80106cd6:	8b 45 08             	mov    0x8(%ebp),%eax
80106cd9:	0f b6 00             	movzbl (%eax),%eax
80106cdc:	0f b6 d0             	movzbl %al,%edx
80106cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ce2:	0f b6 00             	movzbl (%eax),%eax
80106ce5:	0f b6 c0             	movzbl %al,%eax
80106ce8:	29 c2                	sub    %eax,%edx
80106cea:	89 d0                	mov    %edx,%eax
}
80106cec:	5d                   	pop    %ebp
80106ced:	c3                   	ret    

80106cee <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80106cee:	55                   	push   %ebp
80106cef:	89 e5                	mov    %esp,%ebp
80106cf1:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106cf4:	8b 45 08             	mov    0x8(%ebp),%eax
80106cf7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
80106cfa:	90                   	nop
80106cfb:	8b 45 10             	mov    0x10(%ebp),%eax
80106cfe:	8d 50 ff             	lea    -0x1(%eax),%edx
80106d01:	89 55 10             	mov    %edx,0x10(%ebp)
80106d04:	85 c0                	test   %eax,%eax
80106d06:	7e 2c                	jle    80106d34 <strncpy+0x46>
80106d08:	8b 45 08             	mov    0x8(%ebp),%eax
80106d0b:	8d 50 01             	lea    0x1(%eax),%edx
80106d0e:	89 55 08             	mov    %edx,0x8(%ebp)
80106d11:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d14:	8d 4a 01             	lea    0x1(%edx),%ecx
80106d17:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106d1a:	0f b6 12             	movzbl (%edx),%edx
80106d1d:	88 10                	mov    %dl,(%eax)
80106d1f:	0f b6 00             	movzbl (%eax),%eax
80106d22:	84 c0                	test   %al,%al
80106d24:	75 d5                	jne    80106cfb <strncpy+0xd>
    ;
  while(n-- > 0)
80106d26:	eb 0c                	jmp    80106d34 <strncpy+0x46>
    *s++ = 0;
80106d28:	8b 45 08             	mov    0x8(%ebp),%eax
80106d2b:	8d 50 01             	lea    0x1(%eax),%edx
80106d2e:	89 55 08             	mov    %edx,0x8(%ebp)
80106d31:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80106d34:	8b 45 10             	mov    0x10(%ebp),%eax
80106d37:	8d 50 ff             	lea    -0x1(%eax),%edx
80106d3a:	89 55 10             	mov    %edx,0x10(%ebp)
80106d3d:	85 c0                	test   %eax,%eax
80106d3f:	7f e7                	jg     80106d28 <strncpy+0x3a>
    *s++ = 0;
  return os;
80106d41:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d44:	c9                   	leave  
80106d45:	c3                   	ret    

80106d46 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80106d46:	55                   	push   %ebp
80106d47:	89 e5                	mov    %esp,%ebp
80106d49:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80106d4c:	8b 45 08             	mov    0x8(%ebp),%eax
80106d4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80106d52:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106d56:	7f 05                	jg     80106d5d <safestrcpy+0x17>
    return os;
80106d58:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106d5b:	eb 31                	jmp    80106d8e <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
80106d5d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80106d61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80106d65:	7e 1e                	jle    80106d85 <safestrcpy+0x3f>
80106d67:	8b 45 08             	mov    0x8(%ebp),%eax
80106d6a:	8d 50 01             	lea    0x1(%eax),%edx
80106d6d:	89 55 08             	mov    %edx,0x8(%ebp)
80106d70:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d73:	8d 4a 01             	lea    0x1(%edx),%ecx
80106d76:	89 4d 0c             	mov    %ecx,0xc(%ebp)
80106d79:	0f b6 12             	movzbl (%edx),%edx
80106d7c:	88 10                	mov    %dl,(%eax)
80106d7e:	0f b6 00             	movzbl (%eax),%eax
80106d81:	84 c0                	test   %al,%al
80106d83:	75 d8                	jne    80106d5d <safestrcpy+0x17>
    ;
  *s = 0;
80106d85:	8b 45 08             	mov    0x8(%ebp),%eax
80106d88:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80106d8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106d8e:	c9                   	leave  
80106d8f:	c3                   	ret    

80106d90 <strlen>:

int
strlen(const char *s)
{
80106d90:	55                   	push   %ebp
80106d91:	89 e5                	mov    %esp,%ebp
80106d93:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80106d96:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80106d9d:	eb 04                	jmp    80106da3 <strlen+0x13>
80106d9f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106da3:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106da6:	8b 45 08             	mov    0x8(%ebp),%eax
80106da9:	01 d0                	add    %edx,%eax
80106dab:	0f b6 00             	movzbl (%eax),%eax
80106dae:	84 c0                	test   %al,%al
80106db0:	75 ed                	jne    80106d9f <strlen+0xf>
    ;
  return n;
80106db2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106db5:	c9                   	leave  
80106db6:	c3                   	ret    

80106db7 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
80106db7:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80106dbb:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
80106dbf:	55                   	push   %ebp
  pushl %ebx
80106dc0:	53                   	push   %ebx
  pushl %esi
80106dc1:	56                   	push   %esi
  pushl %edi
80106dc2:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80106dc3:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80106dc5:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
80106dc7:	5f                   	pop    %edi
  popl %esi
80106dc8:	5e                   	pop    %esi
  popl %ebx
80106dc9:	5b                   	pop    %ebx
  popl %ebp
80106dca:	5d                   	pop    %ebp
  ret
80106dcb:	c3                   	ret    

80106dcc <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80106dcc:	55                   	push   %ebp
80106dcd:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
80106dcf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106dd5:	8b 00                	mov    (%eax),%eax
80106dd7:	3b 45 08             	cmp    0x8(%ebp),%eax
80106dda:	76 12                	jbe    80106dee <fetchint+0x22>
80106ddc:	8b 45 08             	mov    0x8(%ebp),%eax
80106ddf:	8d 50 04             	lea    0x4(%eax),%edx
80106de2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106de8:	8b 00                	mov    (%eax),%eax
80106dea:	39 c2                	cmp    %eax,%edx
80106dec:	76 07                	jbe    80106df5 <fetchint+0x29>
    return -1;
80106dee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106df3:	eb 0f                	jmp    80106e04 <fetchint+0x38>
  *ip = *(int*)(addr);
80106df5:	8b 45 08             	mov    0x8(%ebp),%eax
80106df8:	8b 10                	mov    (%eax),%edx
80106dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
80106dfd:	89 10                	mov    %edx,(%eax)
  return 0;
80106dff:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106e04:	5d                   	pop    %ebp
80106e05:	c3                   	ret    

80106e06 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80106e06:	55                   	push   %ebp
80106e07:	89 e5                	mov    %esp,%ebp
80106e09:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80106e0c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e12:	8b 00                	mov    (%eax),%eax
80106e14:	3b 45 08             	cmp    0x8(%ebp),%eax
80106e17:	77 07                	ja     80106e20 <fetchstr+0x1a>
    return -1;
80106e19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106e1e:	eb 46                	jmp    80106e66 <fetchstr+0x60>
  *pp = (char*)addr;
80106e20:	8b 55 08             	mov    0x8(%ebp),%edx
80106e23:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e26:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80106e28:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e2e:	8b 00                	mov    (%eax),%eax
80106e30:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80106e33:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e36:	8b 00                	mov    (%eax),%eax
80106e38:	89 45 fc             	mov    %eax,-0x4(%ebp)
80106e3b:	eb 1c                	jmp    80106e59 <fetchstr+0x53>
    if(*s == 0)
80106e3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e40:	0f b6 00             	movzbl (%eax),%eax
80106e43:	84 c0                	test   %al,%al
80106e45:	75 0e                	jne    80106e55 <fetchstr+0x4f>
      return s - *pp;
80106e47:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80106e4d:	8b 00                	mov    (%eax),%eax
80106e4f:	29 c2                	sub    %eax,%edx
80106e51:	89 d0                	mov    %edx,%eax
80106e53:	eb 11                	jmp    80106e66 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80106e55:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80106e59:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106e5c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80106e5f:	72 dc                	jb     80106e3d <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80106e61:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e66:	c9                   	leave  
80106e67:	c3                   	ret    

80106e68 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80106e68:	55                   	push   %ebp
80106e69:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80106e6b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106e71:	8b 40 18             	mov    0x18(%eax),%eax
80106e74:	8b 40 44             	mov    0x44(%eax),%eax
80106e77:	8b 55 08             	mov    0x8(%ebp),%edx
80106e7a:	c1 e2 02             	shl    $0x2,%edx
80106e7d:	01 d0                	add    %edx,%eax
80106e7f:	83 c0 04             	add    $0x4,%eax
80106e82:	ff 75 0c             	pushl  0xc(%ebp)
80106e85:	50                   	push   %eax
80106e86:	e8 41 ff ff ff       	call   80106dcc <fetchint>
80106e8b:	83 c4 08             	add    $0x8,%esp
}
80106e8e:	c9                   	leave  
80106e8f:	c3                   	ret    

80106e90 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
80106e96:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106e99:	50                   	push   %eax
80106e9a:	ff 75 08             	pushl  0x8(%ebp)
80106e9d:	e8 c6 ff ff ff       	call   80106e68 <argint>
80106ea2:	83 c4 08             	add    $0x8,%esp
80106ea5:	85 c0                	test   %eax,%eax
80106ea7:	79 07                	jns    80106eb0 <argptr+0x20>
    return -1;
80106ea9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106eae:	eb 3b                	jmp    80106eeb <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80106eb0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106eb6:	8b 00                	mov    (%eax),%eax
80106eb8:	8b 55 fc             	mov    -0x4(%ebp),%edx
80106ebb:	39 d0                	cmp    %edx,%eax
80106ebd:	76 16                	jbe    80106ed5 <argptr+0x45>
80106ebf:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106ec2:	89 c2                	mov    %eax,%edx
80106ec4:	8b 45 10             	mov    0x10(%ebp),%eax
80106ec7:	01 c2                	add    %eax,%edx
80106ec9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ecf:	8b 00                	mov    (%eax),%eax
80106ed1:	39 c2                	cmp    %eax,%edx
80106ed3:	76 07                	jbe    80106edc <argptr+0x4c>
    return -1;
80106ed5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106eda:	eb 0f                	jmp    80106eeb <argptr+0x5b>
  *pp = (char*)i;
80106edc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106edf:	89 c2                	mov    %eax,%edx
80106ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
80106ee4:	89 10                	mov    %edx,(%eax)
  return 0;
80106ee6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106eeb:	c9                   	leave  
80106eec:	c3                   	ret    

80106eed <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80106eed:	55                   	push   %ebp
80106eee:	89 e5                	mov    %esp,%ebp
80106ef0:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
80106ef3:	8d 45 fc             	lea    -0x4(%ebp),%eax
80106ef6:	50                   	push   %eax
80106ef7:	ff 75 08             	pushl  0x8(%ebp)
80106efa:	e8 69 ff ff ff       	call   80106e68 <argint>
80106eff:	83 c4 08             	add    $0x8,%esp
80106f02:	85 c0                	test   %eax,%eax
80106f04:	79 07                	jns    80106f0d <argstr+0x20>
    return -1;
80106f06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f0b:	eb 0f                	jmp    80106f1c <argstr+0x2f>
  return fetchstr(addr, pp);
80106f0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
80106f10:	ff 75 0c             	pushl  0xc(%ebp)
80106f13:	50                   	push   %eax
80106f14:	e8 ed fe ff ff       	call   80106e06 <fetchstr>
80106f19:	83 c4 08             	add    $0x8,%esp
}
80106f1c:	c9                   	leave  
80106f1d:	c3                   	ret    

80106f1e <syscall>:
};
#endif 

void
syscall(void)
{
80106f1e:	55                   	push   %ebp
80106f1f:	89 e5                	mov    %esp,%ebp
80106f21:	53                   	push   %ebx
80106f22:	83 ec 14             	sub    $0x14,%esp
  int num;

  num = proc->tf->eax;
80106f25:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f2b:	8b 40 18             	mov    0x18(%eax),%eax
80106f2e:	8b 40 1c             	mov    0x1c(%eax),%eax
80106f31:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80106f34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106f38:	7e 30                	jle    80106f6a <syscall+0x4c>
80106f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f3d:	83 f8 21             	cmp    $0x21,%eax
80106f40:	77 28                	ja     80106f6a <syscall+0x4c>
80106f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f45:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106f4c:	85 c0                	test   %eax,%eax
80106f4e:	74 1a                	je     80106f6a <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80106f50:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f56:	8b 58 18             	mov    0x18(%eax),%ebx
80106f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106f5c:	8b 04 85 40 d0 10 80 	mov    -0x7fef2fc0(,%eax,4),%eax
80106f63:	ff d0                	call   *%eax
80106f65:	89 43 1c             	mov    %eax,0x1c(%ebx)
80106f68:	eb 34                	jmp    80106f9e <syscall+0x80>
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80106f6a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f70:	8d 50 6c             	lea    0x6c(%eax),%edx
80106f73:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
// some code goes here
    #ifdef PRINT_SYSCALLS
    cprintf("%s -> %d\n", syscallnames[num], proc->tf->eax);
    #endif
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80106f79:	8b 40 10             	mov    0x10(%eax),%eax
80106f7c:	ff 75 f4             	pushl  -0xc(%ebp)
80106f7f:	52                   	push   %edx
80106f80:	50                   	push   %eax
80106f81:	68 ba a6 10 80       	push   $0x8010a6ba
80106f86:	e8 3b 94 ff ff       	call   801003c6 <cprintf>
80106f8b:	83 c4 10             	add    $0x10,%esp
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80106f8e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106f94:	8b 40 18             	mov    0x18(%eax),%eax
80106f97:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80106f9e:	90                   	nop
80106f9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106fa2:	c9                   	leave  
80106fa3:	c3                   	ret    

80106fa4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80106fa4:	55                   	push   %ebp
80106fa5:	89 e5                	mov    %esp,%ebp
80106fa7:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80106faa:	83 ec 08             	sub    $0x8,%esp
80106fad:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106fb0:	50                   	push   %eax
80106fb1:	ff 75 08             	pushl  0x8(%ebp)
80106fb4:	e8 af fe ff ff       	call   80106e68 <argint>
80106fb9:	83 c4 10             	add    $0x10,%esp
80106fbc:	85 c0                	test   %eax,%eax
80106fbe:	79 07                	jns    80106fc7 <argfd+0x23>
    return -1;
80106fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106fc5:	eb 50                	jmp    80107017 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80106fc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fca:	85 c0                	test   %eax,%eax
80106fcc:	78 21                	js     80106fef <argfd+0x4b>
80106fce:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106fd1:	83 f8 0f             	cmp    $0xf,%eax
80106fd4:	7f 19                	jg     80106fef <argfd+0x4b>
80106fd6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fdc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106fdf:	83 c2 08             	add    $0x8,%edx
80106fe2:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80106fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106fe9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106fed:	75 07                	jne    80106ff6 <argfd+0x52>
    return -1;
80106fef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ff4:	eb 21                	jmp    80107017 <argfd+0x73>
  if(pfd)
80106ff6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80106ffa:	74 08                	je     80107004 <argfd+0x60>
    *pfd = fd;
80106ffc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106fff:	8b 45 0c             	mov    0xc(%ebp),%eax
80107002:	89 10                	mov    %edx,(%eax)
  if(pf)
80107004:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107008:	74 08                	je     80107012 <argfd+0x6e>
    *pf = f;
8010700a:	8b 45 10             	mov    0x10(%ebp),%eax
8010700d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107010:	89 10                	mov    %edx,(%eax)
  return 0;
80107012:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107017:	c9                   	leave  
80107018:	c3                   	ret    

80107019 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80107019:	55                   	push   %ebp
8010701a:	89 e5                	mov    %esp,%ebp
8010701c:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
8010701f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80107026:	eb 30                	jmp    80107058 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80107028:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010702e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80107031:	83 c2 08             	add    $0x8,%edx
80107034:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80107038:	85 c0                	test   %eax,%eax
8010703a:	75 18                	jne    80107054 <fdalloc+0x3b>
      proc->ofile[fd] = f;
8010703c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107042:	8b 55 fc             	mov    -0x4(%ebp),%edx
80107045:	8d 4a 08             	lea    0x8(%edx),%ecx
80107048:	8b 55 08             	mov    0x8(%ebp),%edx
8010704b:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
8010704f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80107052:	eb 0f                	jmp    80107063 <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80107054:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80107058:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
8010705c:	7e ca                	jle    80107028 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
8010705e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107063:	c9                   	leave  
80107064:	c3                   	ret    

80107065 <sys_dup>:

int
sys_dup(void)
{
80107065:	55                   	push   %ebp
80107066:	89 e5                	mov    %esp,%ebp
80107068:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
8010706b:	83 ec 04             	sub    $0x4,%esp
8010706e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107071:	50                   	push   %eax
80107072:	6a 00                	push   $0x0
80107074:	6a 00                	push   $0x0
80107076:	e8 29 ff ff ff       	call   80106fa4 <argfd>
8010707b:	83 c4 10             	add    $0x10,%esp
8010707e:	85 c0                	test   %eax,%eax
80107080:	79 07                	jns    80107089 <sys_dup+0x24>
    return -1;
80107082:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107087:	eb 31                	jmp    801070ba <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80107089:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010708c:	83 ec 0c             	sub    $0xc,%esp
8010708f:	50                   	push   %eax
80107090:	e8 84 ff ff ff       	call   80107019 <fdalloc>
80107095:	83 c4 10             	add    $0x10,%esp
80107098:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010709b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010709f:	79 07                	jns    801070a8 <sys_dup+0x43>
    return -1;
801070a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801070a6:	eb 12                	jmp    801070ba <sys_dup+0x55>
  filedup(f);
801070a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070ab:	83 ec 0c             	sub    $0xc,%esp
801070ae:	50                   	push   %eax
801070af:	e8 a1 a0 ff ff       	call   80101155 <filedup>
801070b4:	83 c4 10             	add    $0x10,%esp
  return fd;
801070b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801070ba:	c9                   	leave  
801070bb:	c3                   	ret    

801070bc <sys_read>:

int
sys_read(void)
{
801070bc:	55                   	push   %ebp
801070bd:	89 e5                	mov    %esp,%ebp
801070bf:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801070c2:	83 ec 04             	sub    $0x4,%esp
801070c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801070c8:	50                   	push   %eax
801070c9:	6a 00                	push   $0x0
801070cb:	6a 00                	push   $0x0
801070cd:	e8 d2 fe ff ff       	call   80106fa4 <argfd>
801070d2:	83 c4 10             	add    $0x10,%esp
801070d5:	85 c0                	test   %eax,%eax
801070d7:	78 2e                	js     80107107 <sys_read+0x4b>
801070d9:	83 ec 08             	sub    $0x8,%esp
801070dc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801070df:	50                   	push   %eax
801070e0:	6a 02                	push   $0x2
801070e2:	e8 81 fd ff ff       	call   80106e68 <argint>
801070e7:	83 c4 10             	add    $0x10,%esp
801070ea:	85 c0                	test   %eax,%eax
801070ec:	78 19                	js     80107107 <sys_read+0x4b>
801070ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
801070f1:	83 ec 04             	sub    $0x4,%esp
801070f4:	50                   	push   %eax
801070f5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801070f8:	50                   	push   %eax
801070f9:	6a 01                	push   $0x1
801070fb:	e8 90 fd ff ff       	call   80106e90 <argptr>
80107100:	83 c4 10             	add    $0x10,%esp
80107103:	85 c0                	test   %eax,%eax
80107105:	79 07                	jns    8010710e <sys_read+0x52>
    return -1;
80107107:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010710c:	eb 17                	jmp    80107125 <sys_read+0x69>
  return fileread(f, p, n);
8010710e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80107111:	8b 55 ec             	mov    -0x14(%ebp),%edx
80107114:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107117:	83 ec 04             	sub    $0x4,%esp
8010711a:	51                   	push   %ecx
8010711b:	52                   	push   %edx
8010711c:	50                   	push   %eax
8010711d:	e8 c3 a1 ff ff       	call   801012e5 <fileread>
80107122:	83 c4 10             	add    $0x10,%esp
}
80107125:	c9                   	leave  
80107126:	c3                   	ret    

80107127 <sys_write>:

int
sys_write(void)
{
80107127:	55                   	push   %ebp
80107128:	89 e5                	mov    %esp,%ebp
8010712a:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010712d:	83 ec 04             	sub    $0x4,%esp
80107130:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107133:	50                   	push   %eax
80107134:	6a 00                	push   $0x0
80107136:	6a 00                	push   $0x0
80107138:	e8 67 fe ff ff       	call   80106fa4 <argfd>
8010713d:	83 c4 10             	add    $0x10,%esp
80107140:	85 c0                	test   %eax,%eax
80107142:	78 2e                	js     80107172 <sys_write+0x4b>
80107144:	83 ec 08             	sub    $0x8,%esp
80107147:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010714a:	50                   	push   %eax
8010714b:	6a 02                	push   $0x2
8010714d:	e8 16 fd ff ff       	call   80106e68 <argint>
80107152:	83 c4 10             	add    $0x10,%esp
80107155:	85 c0                	test   %eax,%eax
80107157:	78 19                	js     80107172 <sys_write+0x4b>
80107159:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010715c:	83 ec 04             	sub    $0x4,%esp
8010715f:	50                   	push   %eax
80107160:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107163:	50                   	push   %eax
80107164:	6a 01                	push   $0x1
80107166:	e8 25 fd ff ff       	call   80106e90 <argptr>
8010716b:	83 c4 10             	add    $0x10,%esp
8010716e:	85 c0                	test   %eax,%eax
80107170:	79 07                	jns    80107179 <sys_write+0x52>
    return -1;
80107172:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107177:	eb 17                	jmp    80107190 <sys_write+0x69>
  return filewrite(f, p, n);
80107179:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010717c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010717f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107182:	83 ec 04             	sub    $0x4,%esp
80107185:	51                   	push   %ecx
80107186:	52                   	push   %edx
80107187:	50                   	push   %eax
80107188:	e8 10 a2 ff ff       	call   8010139d <filewrite>
8010718d:	83 c4 10             	add    $0x10,%esp
}
80107190:	c9                   	leave  
80107191:	c3                   	ret    

80107192 <sys_close>:

int
sys_close(void)
{
80107192:	55                   	push   %ebp
80107193:	89 e5                	mov    %esp,%ebp
80107195:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80107198:	83 ec 04             	sub    $0x4,%esp
8010719b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010719e:	50                   	push   %eax
8010719f:	8d 45 f4             	lea    -0xc(%ebp),%eax
801071a2:	50                   	push   %eax
801071a3:	6a 00                	push   $0x0
801071a5:	e8 fa fd ff ff       	call   80106fa4 <argfd>
801071aa:	83 c4 10             	add    $0x10,%esp
801071ad:	85 c0                	test   %eax,%eax
801071af:	79 07                	jns    801071b8 <sys_close+0x26>
    return -1;
801071b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801071b6:	eb 28                	jmp    801071e0 <sys_close+0x4e>
  proc->ofile[fd] = 0;
801071b8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071be:	8b 55 f4             	mov    -0xc(%ebp),%edx
801071c1:	83 c2 08             	add    $0x8,%edx
801071c4:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801071cb:	00 
  fileclose(f);
801071cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801071cf:	83 ec 0c             	sub    $0xc,%esp
801071d2:	50                   	push   %eax
801071d3:	e8 ce 9f ff ff       	call   801011a6 <fileclose>
801071d8:	83 c4 10             	add    $0x10,%esp
  return 0;
801071db:	b8 00 00 00 00       	mov    $0x0,%eax
}
801071e0:	c9                   	leave  
801071e1:	c3                   	ret    

801071e2 <sys_fstat>:

int
sys_fstat(void)
{
801071e2:	55                   	push   %ebp
801071e3:	89 e5                	mov    %esp,%ebp
801071e5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801071e8:	83 ec 04             	sub    $0x4,%esp
801071eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801071ee:	50                   	push   %eax
801071ef:	6a 00                	push   $0x0
801071f1:	6a 00                	push   $0x0
801071f3:	e8 ac fd ff ff       	call   80106fa4 <argfd>
801071f8:	83 c4 10             	add    $0x10,%esp
801071fb:	85 c0                	test   %eax,%eax
801071fd:	78 17                	js     80107216 <sys_fstat+0x34>
801071ff:	83 ec 04             	sub    $0x4,%esp
80107202:	6a 1c                	push   $0x1c
80107204:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107207:	50                   	push   %eax
80107208:	6a 01                	push   $0x1
8010720a:	e8 81 fc ff ff       	call   80106e90 <argptr>
8010720f:	83 c4 10             	add    $0x10,%esp
80107212:	85 c0                	test   %eax,%eax
80107214:	79 07                	jns    8010721d <sys_fstat+0x3b>
    return -1;
80107216:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010721b:	eb 13                	jmp    80107230 <sys_fstat+0x4e>
  return filestat(f, st);
8010721d:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107220:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107223:	83 ec 08             	sub    $0x8,%esp
80107226:	52                   	push   %edx
80107227:	50                   	push   %eax
80107228:	e8 61 a0 ff ff       	call   8010128e <filestat>
8010722d:	83 c4 10             	add    $0x10,%esp
}
80107230:	c9                   	leave  
80107231:	c3                   	ret    

80107232 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80107232:	55                   	push   %ebp
80107233:	89 e5                	mov    %esp,%ebp
80107235:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80107238:	83 ec 08             	sub    $0x8,%esp
8010723b:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010723e:	50                   	push   %eax
8010723f:	6a 00                	push   $0x0
80107241:	e8 a7 fc ff ff       	call   80106eed <argstr>
80107246:	83 c4 10             	add    $0x10,%esp
80107249:	85 c0                	test   %eax,%eax
8010724b:	78 15                	js     80107262 <sys_link+0x30>
8010724d:	83 ec 08             	sub    $0x8,%esp
80107250:	8d 45 dc             	lea    -0x24(%ebp),%eax
80107253:	50                   	push   %eax
80107254:	6a 01                	push   $0x1
80107256:	e8 92 fc ff ff       	call   80106eed <argstr>
8010725b:	83 c4 10             	add    $0x10,%esp
8010725e:	85 c0                	test   %eax,%eax
80107260:	79 0a                	jns    8010726c <sys_link+0x3a>
    return -1;
80107262:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107267:	e9 68 01 00 00       	jmp    801073d4 <sys_link+0x1a2>

  begin_op();
8010726c:	e8 1d c6 ff ff       	call   8010388e <begin_op>
  if((ip = namei(old)) == 0){
80107271:	8b 45 d8             	mov    -0x28(%ebp),%eax
80107274:	83 ec 0c             	sub    $0xc,%esp
80107277:	50                   	push   %eax
80107278:	e8 78 b4 ff ff       	call   801026f5 <namei>
8010727d:	83 c4 10             	add    $0x10,%esp
80107280:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107283:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107287:	75 0f                	jne    80107298 <sys_link+0x66>
    end_op();
80107289:	e8 8c c6 ff ff       	call   8010391a <end_op>
    return -1;
8010728e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107293:	e9 3c 01 00 00       	jmp    801073d4 <sys_link+0x1a2>
  }

  ilock(ip);
80107298:	83 ec 0c             	sub    $0xc,%esp
8010729b:	ff 75 f4             	pushl  -0xc(%ebp)
8010729e:	e8 44 a8 ff ff       	call   80101ae7 <ilock>
801072a3:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
801072a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072a9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801072ad:	66 83 f8 01          	cmp    $0x1,%ax
801072b1:	75 1d                	jne    801072d0 <sys_link+0x9e>
    iunlockput(ip);
801072b3:	83 ec 0c             	sub    $0xc,%esp
801072b6:	ff 75 f4             	pushl  -0xc(%ebp)
801072b9:	e8 11 ab ff ff       	call   80101dcf <iunlockput>
801072be:	83 c4 10             	add    $0x10,%esp
    end_op();
801072c1:	e8 54 c6 ff ff       	call   8010391a <end_op>
    return -1;
801072c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801072cb:	e9 04 01 00 00       	jmp    801073d4 <sys_link+0x1a2>
  }

  ip->nlink++;
801072d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072d3:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801072d7:	83 c0 01             	add    $0x1,%eax
801072da:	89 c2                	mov    %eax,%edx
801072dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801072df:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801072e3:	83 ec 0c             	sub    $0xc,%esp
801072e6:	ff 75 f4             	pushl  -0xc(%ebp)
801072e9:	e8 f7 a5 ff ff       	call   801018e5 <iupdate>
801072ee:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
801072f1:	83 ec 0c             	sub    $0xc,%esp
801072f4:	ff 75 f4             	pushl  -0xc(%ebp)
801072f7:	e8 71 a9 ff ff       	call   80101c6d <iunlock>
801072fc:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
801072ff:	8b 45 dc             	mov    -0x24(%ebp),%eax
80107302:	83 ec 08             	sub    $0x8,%esp
80107305:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80107308:	52                   	push   %edx
80107309:	50                   	push   %eax
8010730a:	e8 02 b4 ff ff       	call   80102711 <nameiparent>
8010730f:	83 c4 10             	add    $0x10,%esp
80107312:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107315:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107319:	74 71                	je     8010738c <sys_link+0x15a>
    goto bad;
  ilock(dp);
8010731b:	83 ec 0c             	sub    $0xc,%esp
8010731e:	ff 75 f0             	pushl  -0x10(%ebp)
80107321:	e8 c1 a7 ff ff       	call   80101ae7 <ilock>
80107326:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80107329:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010732c:	8b 10                	mov    (%eax),%edx
8010732e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107331:	8b 00                	mov    (%eax),%eax
80107333:	39 c2                	cmp    %eax,%edx
80107335:	75 1d                	jne    80107354 <sys_link+0x122>
80107337:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010733a:	8b 40 04             	mov    0x4(%eax),%eax
8010733d:	83 ec 04             	sub    $0x4,%esp
80107340:	50                   	push   %eax
80107341:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80107344:	50                   	push   %eax
80107345:	ff 75 f0             	pushl  -0x10(%ebp)
80107348:	e8 0c b1 ff ff       	call   80102459 <dirlink>
8010734d:	83 c4 10             	add    $0x10,%esp
80107350:	85 c0                	test   %eax,%eax
80107352:	79 10                	jns    80107364 <sys_link+0x132>
    iunlockput(dp);
80107354:	83 ec 0c             	sub    $0xc,%esp
80107357:	ff 75 f0             	pushl  -0x10(%ebp)
8010735a:	e8 70 aa ff ff       	call   80101dcf <iunlockput>
8010735f:	83 c4 10             	add    $0x10,%esp
    goto bad;
80107362:	eb 29                	jmp    8010738d <sys_link+0x15b>
  }
  iunlockput(dp);
80107364:	83 ec 0c             	sub    $0xc,%esp
80107367:	ff 75 f0             	pushl  -0x10(%ebp)
8010736a:	e8 60 aa ff ff       	call   80101dcf <iunlockput>
8010736f:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80107372:	83 ec 0c             	sub    $0xc,%esp
80107375:	ff 75 f4             	pushl  -0xc(%ebp)
80107378:	e8 62 a9 ff ff       	call   80101cdf <iput>
8010737d:	83 c4 10             	add    $0x10,%esp

  end_op();
80107380:	e8 95 c5 ff ff       	call   8010391a <end_op>

  return 0;
80107385:	b8 00 00 00 00       	mov    $0x0,%eax
8010738a:	eb 48                	jmp    801073d4 <sys_link+0x1a2>
  ip->nlink++;
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
8010738c:	90                   	nop
  end_op();

  return 0;

bad:
  ilock(ip);
8010738d:	83 ec 0c             	sub    $0xc,%esp
80107390:	ff 75 f4             	pushl  -0xc(%ebp)
80107393:	e8 4f a7 ff ff       	call   80101ae7 <ilock>
80107398:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
8010739b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010739e:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801073a2:	83 e8 01             	sub    $0x1,%eax
801073a5:	89 c2                	mov    %eax,%edx
801073a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073aa:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801073ae:	83 ec 0c             	sub    $0xc,%esp
801073b1:	ff 75 f4             	pushl  -0xc(%ebp)
801073b4:	e8 2c a5 ff ff       	call   801018e5 <iupdate>
801073b9:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801073bc:	83 ec 0c             	sub    $0xc,%esp
801073bf:	ff 75 f4             	pushl  -0xc(%ebp)
801073c2:	e8 08 aa ff ff       	call   80101dcf <iunlockput>
801073c7:	83 c4 10             	add    $0x10,%esp
  end_op();
801073ca:	e8 4b c5 ff ff       	call   8010391a <end_op>
  return -1;
801073cf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801073d4:	c9                   	leave  
801073d5:	c3                   	ret    

801073d6 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801073d6:	55                   	push   %ebp
801073d7:	89 e5                	mov    %esp,%ebp
801073d9:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
801073dc:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
801073e3:	eb 40                	jmp    80107425 <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801073e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801073e8:	6a 10                	push   $0x10
801073ea:	50                   	push   %eax
801073eb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801073ee:	50                   	push   %eax
801073ef:	ff 75 08             	pushl  0x8(%ebp)
801073f2:	e8 ae ac ff ff       	call   801020a5 <readi>
801073f7:	83 c4 10             	add    $0x10,%esp
801073fa:	83 f8 10             	cmp    $0x10,%eax
801073fd:	74 0d                	je     8010740c <isdirempty+0x36>
      panic("isdirempty: readi");
801073ff:	83 ec 0c             	sub    $0xc,%esp
80107402:	68 d6 a6 10 80       	push   $0x8010a6d6
80107407:	e8 5a 91 ff ff       	call   80100566 <panic>
    if(de.inum != 0)
8010740c:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80107410:	66 85 c0             	test   %ax,%ax
80107413:	74 07                	je     8010741c <isdirempty+0x46>
      return 0;
80107415:	b8 00 00 00 00       	mov    $0x0,%eax
8010741a:	eb 1b                	jmp    80107437 <isdirempty+0x61>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
8010741c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010741f:	83 c0 10             	add    $0x10,%eax
80107422:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107425:	8b 45 08             	mov    0x8(%ebp),%eax
80107428:	8b 50 20             	mov    0x20(%eax),%edx
8010742b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010742e:	39 c2                	cmp    %eax,%edx
80107430:	77 b3                	ja     801073e5 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80107432:	b8 01 00 00 00       	mov    $0x1,%eax
}
80107437:	c9                   	leave  
80107438:	c3                   	ret    

80107439 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80107439:	55                   	push   %ebp
8010743a:	89 e5                	mov    %esp,%ebp
8010743c:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
8010743f:	83 ec 08             	sub    $0x8,%esp
80107442:	8d 45 cc             	lea    -0x34(%ebp),%eax
80107445:	50                   	push   %eax
80107446:	6a 00                	push   $0x0
80107448:	e8 a0 fa ff ff       	call   80106eed <argstr>
8010744d:	83 c4 10             	add    $0x10,%esp
80107450:	85 c0                	test   %eax,%eax
80107452:	79 0a                	jns    8010745e <sys_unlink+0x25>
    return -1;
80107454:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107459:	e9 bc 01 00 00       	jmp    8010761a <sys_unlink+0x1e1>

  begin_op();
8010745e:	e8 2b c4 ff ff       	call   8010388e <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80107463:	8b 45 cc             	mov    -0x34(%ebp),%eax
80107466:	83 ec 08             	sub    $0x8,%esp
80107469:	8d 55 d2             	lea    -0x2e(%ebp),%edx
8010746c:	52                   	push   %edx
8010746d:	50                   	push   %eax
8010746e:	e8 9e b2 ff ff       	call   80102711 <nameiparent>
80107473:	83 c4 10             	add    $0x10,%esp
80107476:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107479:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010747d:	75 0f                	jne    8010748e <sys_unlink+0x55>
    end_op();
8010747f:	e8 96 c4 ff ff       	call   8010391a <end_op>
    return -1;
80107484:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107489:	e9 8c 01 00 00       	jmp    8010761a <sys_unlink+0x1e1>
  }

  ilock(dp);
8010748e:	83 ec 0c             	sub    $0xc,%esp
80107491:	ff 75 f4             	pushl  -0xc(%ebp)
80107494:	e8 4e a6 ff ff       	call   80101ae7 <ilock>
80107499:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010749c:	83 ec 08             	sub    $0x8,%esp
8010749f:	68 e8 a6 10 80       	push   $0x8010a6e8
801074a4:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801074a7:	50                   	push   %eax
801074a8:	e8 d7 ae ff ff       	call   80102384 <namecmp>
801074ad:	83 c4 10             	add    $0x10,%esp
801074b0:	85 c0                	test   %eax,%eax
801074b2:	0f 84 4a 01 00 00    	je     80107602 <sys_unlink+0x1c9>
801074b8:	83 ec 08             	sub    $0x8,%esp
801074bb:	68 ea a6 10 80       	push   $0x8010a6ea
801074c0:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801074c3:	50                   	push   %eax
801074c4:	e8 bb ae ff ff       	call   80102384 <namecmp>
801074c9:	83 c4 10             	add    $0x10,%esp
801074cc:	85 c0                	test   %eax,%eax
801074ce:	0f 84 2e 01 00 00    	je     80107602 <sys_unlink+0x1c9>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
801074d4:	83 ec 04             	sub    $0x4,%esp
801074d7:	8d 45 c8             	lea    -0x38(%ebp),%eax
801074da:	50                   	push   %eax
801074db:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801074de:	50                   	push   %eax
801074df:	ff 75 f4             	pushl  -0xc(%ebp)
801074e2:	e8 b8 ae ff ff       	call   8010239f <dirlookup>
801074e7:	83 c4 10             	add    $0x10,%esp
801074ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
801074ed:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801074f1:	0f 84 0a 01 00 00    	je     80107601 <sys_unlink+0x1c8>
    goto bad;
  ilock(ip);
801074f7:	83 ec 0c             	sub    $0xc,%esp
801074fa:	ff 75 f0             	pushl  -0x10(%ebp)
801074fd:	e8 e5 a5 ff ff       	call   80101ae7 <ilock>
80107502:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80107505:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107508:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010750c:	66 85 c0             	test   %ax,%ax
8010750f:	7f 0d                	jg     8010751e <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80107511:	83 ec 0c             	sub    $0xc,%esp
80107514:	68 ed a6 10 80       	push   $0x8010a6ed
80107519:	e8 48 90 ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010751e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107521:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107525:	66 83 f8 01          	cmp    $0x1,%ax
80107529:	75 25                	jne    80107550 <sys_unlink+0x117>
8010752b:	83 ec 0c             	sub    $0xc,%esp
8010752e:	ff 75 f0             	pushl  -0x10(%ebp)
80107531:	e8 a0 fe ff ff       	call   801073d6 <isdirempty>
80107536:	83 c4 10             	add    $0x10,%esp
80107539:	85 c0                	test   %eax,%eax
8010753b:	75 13                	jne    80107550 <sys_unlink+0x117>
    iunlockput(ip);
8010753d:	83 ec 0c             	sub    $0xc,%esp
80107540:	ff 75 f0             	pushl  -0x10(%ebp)
80107543:	e8 87 a8 ff ff       	call   80101dcf <iunlockput>
80107548:	83 c4 10             	add    $0x10,%esp
    goto bad;
8010754b:	e9 b2 00 00 00       	jmp    80107602 <sys_unlink+0x1c9>
  }

  memset(&de, 0, sizeof(de));
80107550:	83 ec 04             	sub    $0x4,%esp
80107553:	6a 10                	push   $0x10
80107555:	6a 00                	push   $0x0
80107557:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010755a:	50                   	push   %eax
8010755b:	e8 e3 f5 ff ff       	call   80106b43 <memset>
80107560:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80107563:	8b 45 c8             	mov    -0x38(%ebp),%eax
80107566:	6a 10                	push   $0x10
80107568:	50                   	push   %eax
80107569:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010756c:	50                   	push   %eax
8010756d:	ff 75 f4             	pushl  -0xc(%ebp)
80107570:	e8 87 ac ff ff       	call   801021fc <writei>
80107575:	83 c4 10             	add    $0x10,%esp
80107578:	83 f8 10             	cmp    $0x10,%eax
8010757b:	74 0d                	je     8010758a <sys_unlink+0x151>
    panic("unlink: writei");
8010757d:	83 ec 0c             	sub    $0xc,%esp
80107580:	68 ff a6 10 80       	push   $0x8010a6ff
80107585:	e8 dc 8f ff ff       	call   80100566 <panic>
  if(ip->type == T_DIR){
8010758a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010758d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107591:	66 83 f8 01          	cmp    $0x1,%ax
80107595:	75 21                	jne    801075b8 <sys_unlink+0x17f>
    dp->nlink--;
80107597:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010759a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010759e:	83 e8 01             	sub    $0x1,%eax
801075a1:	89 c2                	mov    %eax,%edx
801075a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801075a6:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
801075aa:	83 ec 0c             	sub    $0xc,%esp
801075ad:	ff 75 f4             	pushl  -0xc(%ebp)
801075b0:	e8 30 a3 ff ff       	call   801018e5 <iupdate>
801075b5:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
801075b8:	83 ec 0c             	sub    $0xc,%esp
801075bb:	ff 75 f4             	pushl  -0xc(%ebp)
801075be:	e8 0c a8 ff ff       	call   80101dcf <iunlockput>
801075c3:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
801075c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801075c9:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801075cd:	83 e8 01             	sub    $0x1,%eax
801075d0:	89 c2                	mov    %eax,%edx
801075d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801075d5:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
801075d9:	83 ec 0c             	sub    $0xc,%esp
801075dc:	ff 75 f0             	pushl  -0x10(%ebp)
801075df:	e8 01 a3 ff ff       	call   801018e5 <iupdate>
801075e4:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
801075e7:	83 ec 0c             	sub    $0xc,%esp
801075ea:	ff 75 f0             	pushl  -0x10(%ebp)
801075ed:	e8 dd a7 ff ff       	call   80101dcf <iunlockput>
801075f2:	83 c4 10             	add    $0x10,%esp

  end_op();
801075f5:	e8 20 c3 ff ff       	call   8010391a <end_op>

  return 0;
801075fa:	b8 00 00 00 00       	mov    $0x0,%eax
801075ff:	eb 19                	jmp    8010761a <sys_unlink+0x1e1>
  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
80107601:	90                   	nop
  end_op();

  return 0;

bad:
  iunlockput(dp);
80107602:	83 ec 0c             	sub    $0xc,%esp
80107605:	ff 75 f4             	pushl  -0xc(%ebp)
80107608:	e8 c2 a7 ff ff       	call   80101dcf <iunlockput>
8010760d:	83 c4 10             	add    $0x10,%esp
  end_op();
80107610:	e8 05 c3 ff ff       	call   8010391a <end_op>
  return -1;
80107615:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010761a:	c9                   	leave  
8010761b:	c3                   	ret    

8010761c <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
8010761c:	55                   	push   %ebp
8010761d:	89 e5                	mov    %esp,%ebp
8010761f:	83 ec 38             	sub    $0x38,%esp
80107622:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80107625:	8b 55 10             	mov    0x10(%ebp),%edx
80107628:	8b 45 14             	mov    0x14(%ebp),%eax
8010762b:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010762f:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80107633:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80107637:	83 ec 08             	sub    $0x8,%esp
8010763a:	8d 45 de             	lea    -0x22(%ebp),%eax
8010763d:	50                   	push   %eax
8010763e:	ff 75 08             	pushl  0x8(%ebp)
80107641:	e8 cb b0 ff ff       	call   80102711 <nameiparent>
80107646:	83 c4 10             	add    $0x10,%esp
80107649:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010764c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107650:	75 0a                	jne    8010765c <create+0x40>
    return 0;
80107652:	b8 00 00 00 00       	mov    $0x0,%eax
80107657:	e9 90 01 00 00       	jmp    801077ec <create+0x1d0>
  ilock(dp);
8010765c:	83 ec 0c             	sub    $0xc,%esp
8010765f:	ff 75 f4             	pushl  -0xc(%ebp)
80107662:	e8 80 a4 ff ff       	call   80101ae7 <ilock>
80107667:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
8010766a:	83 ec 04             	sub    $0x4,%esp
8010766d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107670:	50                   	push   %eax
80107671:	8d 45 de             	lea    -0x22(%ebp),%eax
80107674:	50                   	push   %eax
80107675:	ff 75 f4             	pushl  -0xc(%ebp)
80107678:	e8 22 ad ff ff       	call   8010239f <dirlookup>
8010767d:	83 c4 10             	add    $0x10,%esp
80107680:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107683:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107687:	74 50                	je     801076d9 <create+0xbd>
    iunlockput(dp);
80107689:	83 ec 0c             	sub    $0xc,%esp
8010768c:	ff 75 f4             	pushl  -0xc(%ebp)
8010768f:	e8 3b a7 ff ff       	call   80101dcf <iunlockput>
80107694:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80107697:	83 ec 0c             	sub    $0xc,%esp
8010769a:	ff 75 f0             	pushl  -0x10(%ebp)
8010769d:	e8 45 a4 ff ff       	call   80101ae7 <ilock>
801076a2:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
801076a5:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801076aa:	75 15                	jne    801076c1 <create+0xa5>
801076ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076af:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801076b3:	66 83 f8 02          	cmp    $0x2,%ax
801076b7:	75 08                	jne    801076c1 <create+0xa5>
      return ip;
801076b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801076bc:	e9 2b 01 00 00       	jmp    801077ec <create+0x1d0>
    iunlockput(ip);
801076c1:	83 ec 0c             	sub    $0xc,%esp
801076c4:	ff 75 f0             	pushl  -0x10(%ebp)
801076c7:	e8 03 a7 ff ff       	call   80101dcf <iunlockput>
801076cc:	83 c4 10             	add    $0x10,%esp
    return 0;
801076cf:	b8 00 00 00 00       	mov    $0x0,%eax
801076d4:	e9 13 01 00 00       	jmp    801077ec <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801076d9:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
801076dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801076e0:	8b 00                	mov    (%eax),%eax
801076e2:	83 ec 08             	sub    $0x8,%esp
801076e5:	52                   	push   %edx
801076e6:	50                   	push   %eax
801076e7:	e8 22 a1 ff ff       	call   8010180e <ialloc>
801076ec:	83 c4 10             	add    $0x10,%esp
801076ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
801076f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801076f6:	75 0d                	jne    80107705 <create+0xe9>
    panic("create: ialloc");
801076f8:	83 ec 0c             	sub    $0xc,%esp
801076fb:	68 0e a7 10 80       	push   $0x8010a70e
80107700:	e8 61 8e ff ff       	call   80100566 <panic>

  ilock(ip);
80107705:	83 ec 0c             	sub    $0xc,%esp
80107708:	ff 75 f0             	pushl  -0x10(%ebp)
8010770b:	e8 d7 a3 ff ff       	call   80101ae7 <ilock>
80107710:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80107713:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107716:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
8010771a:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
8010771e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107721:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80107725:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80107729:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010772c:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80107732:	83 ec 0c             	sub    $0xc,%esp
80107735:	ff 75 f0             	pushl  -0x10(%ebp)
80107738:	e8 a8 a1 ff ff       	call   801018e5 <iupdate>
8010773d:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80107740:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80107745:	75 6a                	jne    801077b1 <create+0x195>
    dp->nlink++;  // for ".."
80107747:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010774a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010774e:	83 c0 01             	add    $0x1,%eax
80107751:	89 c2                	mov    %eax,%edx
80107753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107756:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
8010775a:	83 ec 0c             	sub    $0xc,%esp
8010775d:	ff 75 f4             	pushl  -0xc(%ebp)
80107760:	e8 80 a1 ff ff       	call   801018e5 <iupdate>
80107765:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80107768:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010776b:	8b 40 04             	mov    0x4(%eax),%eax
8010776e:	83 ec 04             	sub    $0x4,%esp
80107771:	50                   	push   %eax
80107772:	68 e8 a6 10 80       	push   $0x8010a6e8
80107777:	ff 75 f0             	pushl  -0x10(%ebp)
8010777a:	e8 da ac ff ff       	call   80102459 <dirlink>
8010777f:	83 c4 10             	add    $0x10,%esp
80107782:	85 c0                	test   %eax,%eax
80107784:	78 1e                	js     801077a4 <create+0x188>
80107786:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107789:	8b 40 04             	mov    0x4(%eax),%eax
8010778c:	83 ec 04             	sub    $0x4,%esp
8010778f:	50                   	push   %eax
80107790:	68 ea a6 10 80       	push   $0x8010a6ea
80107795:	ff 75 f0             	pushl  -0x10(%ebp)
80107798:	e8 bc ac ff ff       	call   80102459 <dirlink>
8010779d:	83 c4 10             	add    $0x10,%esp
801077a0:	85 c0                	test   %eax,%eax
801077a2:	79 0d                	jns    801077b1 <create+0x195>
      panic("create dots");
801077a4:	83 ec 0c             	sub    $0xc,%esp
801077a7:	68 1d a7 10 80       	push   $0x8010a71d
801077ac:	e8 b5 8d ff ff       	call   80100566 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801077b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801077b4:	8b 40 04             	mov    0x4(%eax),%eax
801077b7:	83 ec 04             	sub    $0x4,%esp
801077ba:	50                   	push   %eax
801077bb:	8d 45 de             	lea    -0x22(%ebp),%eax
801077be:	50                   	push   %eax
801077bf:	ff 75 f4             	pushl  -0xc(%ebp)
801077c2:	e8 92 ac ff ff       	call   80102459 <dirlink>
801077c7:	83 c4 10             	add    $0x10,%esp
801077ca:	85 c0                	test   %eax,%eax
801077cc:	79 0d                	jns    801077db <create+0x1bf>
    panic("create: dirlink");
801077ce:	83 ec 0c             	sub    $0xc,%esp
801077d1:	68 29 a7 10 80       	push   $0x8010a729
801077d6:	e8 8b 8d ff ff       	call   80100566 <panic>

  iunlockput(dp);
801077db:	83 ec 0c             	sub    $0xc,%esp
801077de:	ff 75 f4             	pushl  -0xc(%ebp)
801077e1:	e8 e9 a5 ff ff       	call   80101dcf <iunlockput>
801077e6:	83 c4 10             	add    $0x10,%esp

  return ip;
801077e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801077ec:	c9                   	leave  
801077ed:	c3                   	ret    

801077ee <sys_open>:

int
sys_open(void)
{
801077ee:	55                   	push   %ebp
801077ef:	89 e5                	mov    %esp,%ebp
801077f1:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801077f4:	83 ec 08             	sub    $0x8,%esp
801077f7:	8d 45 e8             	lea    -0x18(%ebp),%eax
801077fa:	50                   	push   %eax
801077fb:	6a 00                	push   $0x0
801077fd:	e8 eb f6 ff ff       	call   80106eed <argstr>
80107802:	83 c4 10             	add    $0x10,%esp
80107805:	85 c0                	test   %eax,%eax
80107807:	78 15                	js     8010781e <sys_open+0x30>
80107809:	83 ec 08             	sub    $0x8,%esp
8010780c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010780f:	50                   	push   %eax
80107810:	6a 01                	push   $0x1
80107812:	e8 51 f6 ff ff       	call   80106e68 <argint>
80107817:	83 c4 10             	add    $0x10,%esp
8010781a:	85 c0                	test   %eax,%eax
8010781c:	79 0a                	jns    80107828 <sys_open+0x3a>
    return -1;
8010781e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107823:	e9 61 01 00 00       	jmp    80107989 <sys_open+0x19b>

  begin_op();
80107828:	e8 61 c0 ff ff       	call   8010388e <begin_op>

  if(omode & O_CREATE){
8010782d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107830:	25 00 02 00 00       	and    $0x200,%eax
80107835:	85 c0                	test   %eax,%eax
80107837:	74 2a                	je     80107863 <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80107839:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010783c:	6a 00                	push   $0x0
8010783e:	6a 00                	push   $0x0
80107840:	6a 02                	push   $0x2
80107842:	50                   	push   %eax
80107843:	e8 d4 fd ff ff       	call   8010761c <create>
80107848:	83 c4 10             	add    $0x10,%esp
8010784b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010784e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107852:	75 75                	jne    801078c9 <sys_open+0xdb>
      end_op();
80107854:	e8 c1 c0 ff ff       	call   8010391a <end_op>
      return -1;
80107859:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010785e:	e9 26 01 00 00       	jmp    80107989 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
80107863:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107866:	83 ec 0c             	sub    $0xc,%esp
80107869:	50                   	push   %eax
8010786a:	e8 86 ae ff ff       	call   801026f5 <namei>
8010786f:	83 c4 10             	add    $0x10,%esp
80107872:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107875:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107879:	75 0f                	jne    8010788a <sys_open+0x9c>
      end_op();
8010787b:	e8 9a c0 ff ff       	call   8010391a <end_op>
      return -1;
80107880:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107885:	e9 ff 00 00 00       	jmp    80107989 <sys_open+0x19b>
    }
    ilock(ip);
8010788a:	83 ec 0c             	sub    $0xc,%esp
8010788d:	ff 75 f4             	pushl  -0xc(%ebp)
80107890:	e8 52 a2 ff ff       	call   80101ae7 <ilock>
80107895:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80107898:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010789b:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010789f:	66 83 f8 01          	cmp    $0x1,%ax
801078a3:	75 24                	jne    801078c9 <sys_open+0xdb>
801078a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801078a8:	85 c0                	test   %eax,%eax
801078aa:	74 1d                	je     801078c9 <sys_open+0xdb>
      iunlockput(ip);
801078ac:	83 ec 0c             	sub    $0xc,%esp
801078af:	ff 75 f4             	pushl  -0xc(%ebp)
801078b2:	e8 18 a5 ff ff       	call   80101dcf <iunlockput>
801078b7:	83 c4 10             	add    $0x10,%esp
      end_op();
801078ba:	e8 5b c0 ff ff       	call   8010391a <end_op>
      return -1;
801078bf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801078c4:	e9 c0 00 00 00       	jmp    80107989 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801078c9:	e8 1a 98 ff ff       	call   801010e8 <filealloc>
801078ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
801078d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801078d5:	74 17                	je     801078ee <sys_open+0x100>
801078d7:	83 ec 0c             	sub    $0xc,%esp
801078da:	ff 75 f0             	pushl  -0x10(%ebp)
801078dd:	e8 37 f7 ff ff       	call   80107019 <fdalloc>
801078e2:	83 c4 10             	add    $0x10,%esp
801078e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
801078e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801078ec:	79 2e                	jns    8010791c <sys_open+0x12e>
    if(f)
801078ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801078f2:	74 0e                	je     80107902 <sys_open+0x114>
      fileclose(f);
801078f4:	83 ec 0c             	sub    $0xc,%esp
801078f7:	ff 75 f0             	pushl  -0x10(%ebp)
801078fa:	e8 a7 98 ff ff       	call   801011a6 <fileclose>
801078ff:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80107902:	83 ec 0c             	sub    $0xc,%esp
80107905:	ff 75 f4             	pushl  -0xc(%ebp)
80107908:	e8 c2 a4 ff ff       	call   80101dcf <iunlockput>
8010790d:	83 c4 10             	add    $0x10,%esp
    end_op();
80107910:	e8 05 c0 ff ff       	call   8010391a <end_op>
    return -1;
80107915:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010791a:	eb 6d                	jmp    80107989 <sys_open+0x19b>
  }
  iunlock(ip);
8010791c:	83 ec 0c             	sub    $0xc,%esp
8010791f:	ff 75 f4             	pushl  -0xc(%ebp)
80107922:	e8 46 a3 ff ff       	call   80101c6d <iunlock>
80107927:	83 c4 10             	add    $0x10,%esp
  end_op();
8010792a:	e8 eb bf ff ff       	call   8010391a <end_op>

  f->type = FD_INODE;
8010792f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107932:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80107938:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010793b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010793e:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80107941:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107944:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
8010794b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010794e:	83 e0 01             	and    $0x1,%eax
80107951:	85 c0                	test   %eax,%eax
80107953:	0f 94 c0             	sete   %al
80107956:	89 c2                	mov    %eax,%edx
80107958:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010795b:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010795e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107961:	83 e0 01             	and    $0x1,%eax
80107964:	85 c0                	test   %eax,%eax
80107966:	75 0a                	jne    80107972 <sys_open+0x184>
80107968:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010796b:	83 e0 02             	and    $0x2,%eax
8010796e:	85 c0                	test   %eax,%eax
80107970:	74 07                	je     80107979 <sys_open+0x18b>
80107972:	b8 01 00 00 00       	mov    $0x1,%eax
80107977:	eb 05                	jmp    8010797e <sys_open+0x190>
80107979:	b8 00 00 00 00       	mov    $0x0,%eax
8010797e:	89 c2                	mov    %eax,%edx
80107980:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107983:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80107986:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80107989:	c9                   	leave  
8010798a:	c3                   	ret    

8010798b <sys_mkdir>:

int
sys_mkdir(void)
{
8010798b:	55                   	push   %ebp
8010798c:	89 e5                	mov    %esp,%ebp
8010798e:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107991:	e8 f8 be ff ff       	call   8010388e <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80107996:	83 ec 08             	sub    $0x8,%esp
80107999:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010799c:	50                   	push   %eax
8010799d:	6a 00                	push   $0x0
8010799f:	e8 49 f5 ff ff       	call   80106eed <argstr>
801079a4:	83 c4 10             	add    $0x10,%esp
801079a7:	85 c0                	test   %eax,%eax
801079a9:	78 1b                	js     801079c6 <sys_mkdir+0x3b>
801079ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801079ae:	6a 00                	push   $0x0
801079b0:	6a 00                	push   $0x0
801079b2:	6a 01                	push   $0x1
801079b4:	50                   	push   %eax
801079b5:	e8 62 fc ff ff       	call   8010761c <create>
801079ba:	83 c4 10             	add    $0x10,%esp
801079bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801079c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801079c4:	75 0c                	jne    801079d2 <sys_mkdir+0x47>
    end_op();
801079c6:	e8 4f bf ff ff       	call   8010391a <end_op>
    return -1;
801079cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801079d0:	eb 18                	jmp    801079ea <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801079d2:	83 ec 0c             	sub    $0xc,%esp
801079d5:	ff 75 f4             	pushl  -0xc(%ebp)
801079d8:	e8 f2 a3 ff ff       	call   80101dcf <iunlockput>
801079dd:	83 c4 10             	add    $0x10,%esp
  end_op();
801079e0:	e8 35 bf ff ff       	call   8010391a <end_op>
  return 0;
801079e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801079ea:	c9                   	leave  
801079eb:	c3                   	ret    

801079ec <sys_mknod>:

int
sys_mknod(void)
{
801079ec:	55                   	push   %ebp
801079ed:	89 e5                	mov    %esp,%ebp
801079ef:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
801079f2:	e8 97 be ff ff       	call   8010388e <begin_op>
  if((len=argstr(0, &path)) < 0 ||
801079f7:	83 ec 08             	sub    $0x8,%esp
801079fa:	8d 45 ec             	lea    -0x14(%ebp),%eax
801079fd:	50                   	push   %eax
801079fe:	6a 00                	push   $0x0
80107a00:	e8 e8 f4 ff ff       	call   80106eed <argstr>
80107a05:	83 c4 10             	add    $0x10,%esp
80107a08:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107a0b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107a0f:	78 4f                	js     80107a60 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
80107a11:	83 ec 08             	sub    $0x8,%esp
80107a14:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107a17:	50                   	push   %eax
80107a18:	6a 01                	push   $0x1
80107a1a:	e8 49 f4 ff ff       	call   80106e68 <argint>
80107a1f:	83 c4 10             	add    $0x10,%esp
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
80107a22:	85 c0                	test   %eax,%eax
80107a24:	78 3a                	js     80107a60 <sys_mknod+0x74>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107a26:	83 ec 08             	sub    $0x8,%esp
80107a29:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107a2c:	50                   	push   %eax
80107a2d:	6a 02                	push   $0x2
80107a2f:	e8 34 f4 ff ff       	call   80106e68 <argint>
80107a34:	83 c4 10             	add    $0x10,%esp
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80107a37:	85 c0                	test   %eax,%eax
80107a39:	78 25                	js     80107a60 <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80107a3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107a3e:	0f bf c8             	movswl %ax,%ecx
80107a41:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107a44:	0f bf d0             	movswl %ax,%edx
80107a47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80107a4a:	51                   	push   %ecx
80107a4b:	52                   	push   %edx
80107a4c:	6a 03                	push   $0x3
80107a4e:	50                   	push   %eax
80107a4f:	e8 c8 fb ff ff       	call   8010761c <create>
80107a54:	83 c4 10             	add    $0x10,%esp
80107a57:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107a5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107a5e:	75 0c                	jne    80107a6c <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80107a60:	e8 b5 be ff ff       	call   8010391a <end_op>
    return -1;
80107a65:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107a6a:	eb 18                	jmp    80107a84 <sys_mknod+0x98>
  }
  iunlockput(ip);
80107a6c:	83 ec 0c             	sub    $0xc,%esp
80107a6f:	ff 75 f0             	pushl  -0x10(%ebp)
80107a72:	e8 58 a3 ff ff       	call   80101dcf <iunlockput>
80107a77:	83 c4 10             	add    $0x10,%esp
  end_op();
80107a7a:	e8 9b be ff ff       	call   8010391a <end_op>
  return 0;
80107a7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107a84:	c9                   	leave  
80107a85:	c3                   	ret    

80107a86 <sys_chdir>:

int
sys_chdir(void)
{
80107a86:	55                   	push   %ebp
80107a87:	89 e5                	mov    %esp,%ebp
80107a89:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80107a8c:	e8 fd bd ff ff       	call   8010388e <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80107a91:	83 ec 08             	sub    $0x8,%esp
80107a94:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107a97:	50                   	push   %eax
80107a98:	6a 00                	push   $0x0
80107a9a:	e8 4e f4 ff ff       	call   80106eed <argstr>
80107a9f:	83 c4 10             	add    $0x10,%esp
80107aa2:	85 c0                	test   %eax,%eax
80107aa4:	78 18                	js     80107abe <sys_chdir+0x38>
80107aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107aa9:	83 ec 0c             	sub    $0xc,%esp
80107aac:	50                   	push   %eax
80107aad:	e8 43 ac ff ff       	call   801026f5 <namei>
80107ab2:	83 c4 10             	add    $0x10,%esp
80107ab5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ab8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107abc:	75 0c                	jne    80107aca <sys_chdir+0x44>
    end_op();
80107abe:	e8 57 be ff ff       	call   8010391a <end_op>
    return -1;
80107ac3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ac8:	eb 6e                	jmp    80107b38 <sys_chdir+0xb2>
  }
  ilock(ip);
80107aca:	83 ec 0c             	sub    $0xc,%esp
80107acd:	ff 75 f4             	pushl  -0xc(%ebp)
80107ad0:	e8 12 a0 ff ff       	call   80101ae7 <ilock>
80107ad5:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
80107ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107adb:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80107adf:	66 83 f8 01          	cmp    $0x1,%ax
80107ae3:	74 1a                	je     80107aff <sys_chdir+0x79>
    iunlockput(ip);
80107ae5:	83 ec 0c             	sub    $0xc,%esp
80107ae8:	ff 75 f4             	pushl  -0xc(%ebp)
80107aeb:	e8 df a2 ff ff       	call   80101dcf <iunlockput>
80107af0:	83 c4 10             	add    $0x10,%esp
    end_op();
80107af3:	e8 22 be ff ff       	call   8010391a <end_op>
    return -1;
80107af8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107afd:	eb 39                	jmp    80107b38 <sys_chdir+0xb2>
  }
  iunlock(ip);
80107aff:	83 ec 0c             	sub    $0xc,%esp
80107b02:	ff 75 f4             	pushl  -0xc(%ebp)
80107b05:	e8 63 a1 ff ff       	call   80101c6d <iunlock>
80107b0a:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
80107b0d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b13:	8b 40 68             	mov    0x68(%eax),%eax
80107b16:	83 ec 0c             	sub    $0xc,%esp
80107b19:	50                   	push   %eax
80107b1a:	e8 c0 a1 ff ff       	call   80101cdf <iput>
80107b1f:	83 c4 10             	add    $0x10,%esp
  end_op();
80107b22:	e8 f3 bd ff ff       	call   8010391a <end_op>
  proc->cwd = ip;
80107b27:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107b2d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107b30:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
80107b33:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107b38:	c9                   	leave  
80107b39:	c3                   	ret    

80107b3a <sys_exec>:

int
sys_exec(void)
{
80107b3a:	55                   	push   %ebp
80107b3b:	89 e5                	mov    %esp,%ebp
80107b3d:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80107b43:	83 ec 08             	sub    $0x8,%esp
80107b46:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107b49:	50                   	push   %eax
80107b4a:	6a 00                	push   $0x0
80107b4c:	e8 9c f3 ff ff       	call   80106eed <argstr>
80107b51:	83 c4 10             	add    $0x10,%esp
80107b54:	85 c0                	test   %eax,%eax
80107b56:	78 18                	js     80107b70 <sys_exec+0x36>
80107b58:	83 ec 08             	sub    $0x8,%esp
80107b5b:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80107b61:	50                   	push   %eax
80107b62:	6a 01                	push   $0x1
80107b64:	e8 ff f2 ff ff       	call   80106e68 <argint>
80107b69:	83 c4 10             	add    $0x10,%esp
80107b6c:	85 c0                	test   %eax,%eax
80107b6e:	79 0a                	jns    80107b7a <sys_exec+0x40>
    return -1;
80107b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107b75:	e9 c6 00 00 00       	jmp    80107c40 <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80107b7a:	83 ec 04             	sub    $0x4,%esp
80107b7d:	68 80 00 00 00       	push   $0x80
80107b82:	6a 00                	push   $0x0
80107b84:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107b8a:	50                   	push   %eax
80107b8b:	e8 b3 ef ff ff       	call   80106b43 <memset>
80107b90:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
80107b93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80107b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b9d:	83 f8 1f             	cmp    $0x1f,%eax
80107ba0:	76 0a                	jbe    80107bac <sys_exec+0x72>
      return -1;
80107ba2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ba7:	e9 94 00 00 00       	jmp    80107c40 <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80107bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107baf:	c1 e0 02             	shl    $0x2,%eax
80107bb2:	89 c2                	mov    %eax,%edx
80107bb4:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80107bba:	01 c2                	add    %eax,%edx
80107bbc:	83 ec 08             	sub    $0x8,%esp
80107bbf:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80107bc5:	50                   	push   %eax
80107bc6:	52                   	push   %edx
80107bc7:	e8 00 f2 ff ff       	call   80106dcc <fetchint>
80107bcc:	83 c4 10             	add    $0x10,%esp
80107bcf:	85 c0                	test   %eax,%eax
80107bd1:	79 07                	jns    80107bda <sys_exec+0xa0>
      return -1;
80107bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107bd8:	eb 66                	jmp    80107c40 <sys_exec+0x106>
    if(uarg == 0){
80107bda:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107be0:	85 c0                	test   %eax,%eax
80107be2:	75 27                	jne    80107c0b <sys_exec+0xd1>
      argv[i] = 0;
80107be4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be7:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
80107bee:	00 00 00 00 
      break;
80107bf2:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80107bf3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107bf6:	83 ec 08             	sub    $0x8,%esp
80107bf9:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
80107bff:	52                   	push   %edx
80107c00:	50                   	push   %eax
80107c01:	e8 15 90 ff ff       	call   80100c1b <exec>
80107c06:	83 c4 10             	add    $0x10,%esp
80107c09:	eb 35                	jmp    80107c40 <sys_exec+0x106>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80107c0b:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80107c11:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107c14:	c1 e2 02             	shl    $0x2,%edx
80107c17:	01 c2                	add    %eax,%edx
80107c19:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
80107c1f:	83 ec 08             	sub    $0x8,%esp
80107c22:	52                   	push   %edx
80107c23:	50                   	push   %eax
80107c24:	e8 dd f1 ff ff       	call   80106e06 <fetchstr>
80107c29:	83 c4 10             	add    $0x10,%esp
80107c2c:	85 c0                	test   %eax,%eax
80107c2e:	79 07                	jns    80107c37 <sys_exec+0xfd>
      return -1;
80107c30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c35:	eb 09                	jmp    80107c40 <sys_exec+0x106>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80107c37:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80107c3b:	e9 5a ff ff ff       	jmp    80107b9a <sys_exec+0x60>
  return exec(path, argv);
}
80107c40:	c9                   	leave  
80107c41:	c3                   	ret    

80107c42 <sys_pipe>:

int
sys_pipe(void)
{
80107c42:	55                   	push   %ebp
80107c43:	89 e5                	mov    %esp,%ebp
80107c45:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80107c48:	83 ec 04             	sub    $0x4,%esp
80107c4b:	6a 08                	push   $0x8
80107c4d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80107c50:	50                   	push   %eax
80107c51:	6a 00                	push   $0x0
80107c53:	e8 38 f2 ff ff       	call   80106e90 <argptr>
80107c58:	83 c4 10             	add    $0x10,%esp
80107c5b:	85 c0                	test   %eax,%eax
80107c5d:	79 0a                	jns    80107c69 <sys_pipe+0x27>
    return -1;
80107c5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c64:	e9 af 00 00 00       	jmp    80107d18 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80107c69:	83 ec 08             	sub    $0x8,%esp
80107c6c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80107c6f:	50                   	push   %eax
80107c70:	8d 45 e8             	lea    -0x18(%ebp),%eax
80107c73:	50                   	push   %eax
80107c74:	e8 09 c7 ff ff       	call   80104382 <pipealloc>
80107c79:	83 c4 10             	add    $0x10,%esp
80107c7c:	85 c0                	test   %eax,%eax
80107c7e:	79 0a                	jns    80107c8a <sys_pipe+0x48>
    return -1;
80107c80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107c85:	e9 8e 00 00 00       	jmp    80107d18 <sys_pipe+0xd6>
  fd0 = -1;
80107c8a:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80107c91:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107c94:	83 ec 0c             	sub    $0xc,%esp
80107c97:	50                   	push   %eax
80107c98:	e8 7c f3 ff ff       	call   80107019 <fdalloc>
80107c9d:	83 c4 10             	add    $0x10,%esp
80107ca0:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ca3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107ca7:	78 18                	js     80107cc1 <sys_pipe+0x7f>
80107ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107cac:	83 ec 0c             	sub    $0xc,%esp
80107caf:	50                   	push   %eax
80107cb0:	e8 64 f3 ff ff       	call   80107019 <fdalloc>
80107cb5:	83 c4 10             	add    $0x10,%esp
80107cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107cbb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107cbf:	79 3f                	jns    80107d00 <sys_pipe+0xbe>
    if(fd0 >= 0)
80107cc1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107cc5:	78 14                	js     80107cdb <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
80107cc7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ccd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107cd0:	83 c2 08             	add    $0x8,%edx
80107cd3:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80107cda:	00 
    fileclose(rf);
80107cdb:	8b 45 e8             	mov    -0x18(%ebp),%eax
80107cde:	83 ec 0c             	sub    $0xc,%esp
80107ce1:	50                   	push   %eax
80107ce2:	e8 bf 94 ff ff       	call   801011a6 <fileclose>
80107ce7:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
80107cea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107ced:	83 ec 0c             	sub    $0xc,%esp
80107cf0:	50                   	push   %eax
80107cf1:	e8 b0 94 ff ff       	call   801011a6 <fileclose>
80107cf6:	83 c4 10             	add    $0x10,%esp
    return -1;
80107cf9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107cfe:	eb 18                	jmp    80107d18 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
80107d00:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d03:	8b 55 f4             	mov    -0xc(%ebp),%edx
80107d06:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80107d08:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107d0b:	8d 50 04             	lea    0x4(%eax),%edx
80107d0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d11:	89 02                	mov    %eax,(%edx)
  return 0;
80107d13:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107d18:	c9                   	leave  
80107d19:	c3                   	ret    

80107d1a <sys_chmod>:

#ifdef CS333_P5
// Implementation of chmod system call
int
sys_chmod(void)
{
80107d1a:	55                   	push   %ebp
80107d1b:	89 e5                	mov    %esp,%ebp
80107d1d:	83 ec 18             	sub    $0x18,%esp
  char *pn;
  int md;
  
  if(argptr(0, (void*)&pn, sizeof(*pn)) < 0)
80107d20:	83 ec 04             	sub    $0x4,%esp
80107d23:	6a 01                	push   $0x1
80107d25:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107d28:	50                   	push   %eax
80107d29:	6a 00                	push   $0x0
80107d2b:	e8 60 f1 ff ff       	call   80106e90 <argptr>
80107d30:	83 c4 10             	add    $0x10,%esp
80107d33:	85 c0                	test   %eax,%eax
80107d35:	79 07                	jns    80107d3e <sys_chmod+0x24>
    return -1;
80107d37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d3c:	eb 32                	jmp    80107d70 <sys_chmod+0x56>
  argint(1, &md);
80107d3e:	83 ec 08             	sub    $0x8,%esp
80107d41:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d44:	50                   	push   %eax
80107d45:	6a 01                	push   $0x1
80107d47:	e8 1c f1 ff ff       	call   80106e68 <argint>
80107d4c:	83 c4 10             	add    $0x10,%esp
  // Error check the integer equivalent of the bounds for
  // a mode and return -1 if outside the correct range
  if (md < 0)
80107d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107d52:	85 c0                	test   %eax,%eax
80107d54:	79 07                	jns    80107d5d <sys_chmod+0x43>
    return -1; 
80107d56:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d5b:	eb 13                	jmp    80107d70 <sys_chmod+0x56>
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
80107d83:	e8 08 f1 ff ff       	call   80106e90 <argptr>
80107d88:	83 c4 10             	add    $0x10,%esp
80107d8b:	85 c0                	test   %eax,%eax
80107d8d:	79 07                	jns    80107d96 <sys_chown+0x24>
    return -1;
80107d8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107d94:	eb 3c                	jmp    80107dd2 <sys_chown+0x60>
  argint(1, &owner);
80107d96:	83 ec 08             	sub    $0x8,%esp
80107d99:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107d9c:	50                   	push   %eax
80107d9d:	6a 01                	push   $0x1
80107d9f:	e8 c4 f0 ff ff       	call   80106e68 <argint>
80107da4:	83 c4 10             	add    $0x10,%esp
  if (owner < 0 || owner > 32767)
80107da7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107daa:	85 c0                	test   %eax,%eax
80107dac:	78 0a                	js     80107db8 <sys_chown+0x46>
80107dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107db1:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107db6:	7e 07                	jle    80107dbf <sys_chown+0x4d>
    return -1;
80107db8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107dbd:	eb 13                	jmp    80107dd2 <sys_chown+0x60>
  else
    return chown_helper(pn, owner);
80107dbf:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc5:	83 ec 08             	sub    $0x8,%esp
80107dc8:	52                   	push   %edx
80107dc9:	50                   	push   %eax
80107dca:	e8 5d a9 ff ff       	call   8010272c <chown_helper>
80107dcf:	83 c4 10             	add    $0x10,%esp
}
80107dd2:	c9                   	leave  
80107dd3:	c3                   	ret    

80107dd4 <sys_chgrp>:

// Implementation of chgrp system call
int
sys_chgrp(void)
{
80107dd4:	55                   	push   %ebp
80107dd5:	89 e5                	mov    %esp,%ebp
80107dd7:	83 ec 18             	sub    $0x18,%esp
  char *pn;
  int owner;

  if (argptr(0, (void*)&pn, sizeof(*pn)) < 0)
80107dda:	83 ec 04             	sub    $0x4,%esp
80107ddd:	6a 01                	push   $0x1
80107ddf:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107de2:	50                   	push   %eax
80107de3:	6a 00                	push   $0x0
80107de5:	e8 a6 f0 ff ff       	call   80106e90 <argptr>
80107dea:	83 c4 10             	add    $0x10,%esp
80107ded:	85 c0                	test   %eax,%eax
80107def:	79 07                	jns    80107df8 <sys_chgrp+0x24>
    return -1;
80107df1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107df6:	eb 3c                	jmp    80107e34 <sys_chgrp+0x60>
  argint(1, &owner);
80107df8:	83 ec 08             	sub    $0x8,%esp
80107dfb:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107dfe:	50                   	push   %eax
80107dff:	6a 01                	push   $0x1
80107e01:	e8 62 f0 ff ff       	call   80106e68 <argint>
80107e06:	83 c4 10             	add    $0x10,%esp
  if (owner < 0 || owner > 32767)
80107e09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e0c:	85 c0                	test   %eax,%eax
80107e0e:	78 0a                	js     80107e1a <sys_chgrp+0x46>
80107e10:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107e13:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80107e18:	7e 07                	jle    80107e21 <sys_chgrp+0x4d>
    return -1;
80107e1a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107e1f:	eb 13                	jmp    80107e34 <sys_chgrp+0x60>
  else
    return chgrp_helper(pn, owner);
80107e21:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e27:	83 ec 08             	sub    $0x8,%esp
80107e2a:	52                   	push   %edx
80107e2b:	50                   	push   %eax
80107e2c:	e8 6b a9 ff ff       	call   8010279c <chgrp_helper>
80107e31:	83 c4 10             	add    $0x10,%esp
}
80107e34:	c9                   	leave  
80107e35:	c3                   	ret    

80107e36 <outw>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outw(ushort port, ushort data)
{
80107e36:	55                   	push   %ebp
80107e37:	89 e5                	mov    %esp,%ebp
80107e39:	83 ec 08             	sub    $0x8,%esp
80107e3c:	8b 55 08             	mov    0x8(%ebp),%edx
80107e3f:	8b 45 0c             	mov    0xc(%ebp),%eax
80107e42:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107e46:	66 89 45 f8          	mov    %ax,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107e4a:	0f b7 45 f8          	movzwl -0x8(%ebp),%eax
80107e4e:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80107e52:	66 ef                	out    %ax,(%dx)
}
80107e54:	90                   	nop
80107e55:	c9                   	leave  
80107e56:	c3                   	ret    

80107e57 <sys_fork>:
#include "proc.h"
#include "uproc.h"

int
sys_fork(void)
{
80107e57:	55                   	push   %ebp
80107e58:	89 e5                	mov    %esp,%ebp
80107e5a:	83 ec 08             	sub    $0x8,%esp
  return fork();
80107e5d:	e8 0c ce ff ff       	call   80104c6e <fork>
}
80107e62:	c9                   	leave  
80107e63:	c3                   	ret    

80107e64 <sys_exit>:

int
sys_exit(void)
{
80107e64:	55                   	push   %ebp
80107e65:	89 e5                	mov    %esp,%ebp
80107e67:	83 ec 08             	sub    $0x8,%esp
  exit();
80107e6a:	e8 75 d0 ff ff       	call   80104ee4 <exit>
  return 0;  // not reached
80107e6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107e74:	c9                   	leave  
80107e75:	c3                   	ret    

80107e76 <sys_wait>:

int
sys_wait(void)
{
80107e76:	55                   	push   %ebp
80107e77:	89 e5                	mov    %esp,%ebp
80107e79:	83 ec 08             	sub    $0x8,%esp
  return wait();
80107e7c:	e8 3c d2 ff ff       	call   801050bd <wait>
}
80107e81:	c9                   	leave  
80107e82:	c3                   	ret    

80107e83 <sys_kill>:

int
sys_kill(void)
{
80107e83:	55                   	push   %ebp
80107e84:	89 e5                	mov    %esp,%ebp
80107e86:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80107e89:	83 ec 08             	sub    $0x8,%esp
80107e8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107e8f:	50                   	push   %eax
80107e90:	6a 00                	push   $0x0
80107e92:	e8 d1 ef ff ff       	call   80106e68 <argint>
80107e97:	83 c4 10             	add    $0x10,%esp
80107e9a:	85 c0                	test   %eax,%eax
80107e9c:	79 07                	jns    80107ea5 <sys_kill+0x22>
    return -1;
80107e9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ea3:	eb 0f                	jmp    80107eb4 <sys_kill+0x31>
  return kill(pid);
80107ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea8:	83 ec 0c             	sub    $0xc,%esp
80107eab:	50                   	push   %eax
80107eac:	e8 b1 d9 ff ff       	call   80105862 <kill>
80107eb1:	83 c4 10             	add    $0x10,%esp
}
80107eb4:	c9                   	leave  
80107eb5:	c3                   	ret    

80107eb6 <sys_getpid>:

int
sys_getpid(void)
{
80107eb6:	55                   	push   %ebp
80107eb7:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80107eb9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107ebf:	8b 40 10             	mov    0x10(%eax),%eax
}
80107ec2:	5d                   	pop    %ebp
80107ec3:	c3                   	ret    

80107ec4 <sys_sbrk>:

int
sys_sbrk(void)
{
80107ec4:	55                   	push   %ebp
80107ec5:	89 e5                	mov    %esp,%ebp
80107ec7:	83 ec 18             	sub    $0x18,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80107eca:	83 ec 08             	sub    $0x8,%esp
80107ecd:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107ed0:	50                   	push   %eax
80107ed1:	6a 00                	push   $0x0
80107ed3:	e8 90 ef ff ff       	call   80106e68 <argint>
80107ed8:	83 c4 10             	add    $0x10,%esp
80107edb:	85 c0                	test   %eax,%eax
80107edd:	79 07                	jns    80107ee6 <sys_sbrk+0x22>
    return -1;
80107edf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107ee4:	eb 28                	jmp    80107f0e <sys_sbrk+0x4a>
  addr = proc->sz;
80107ee6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107eec:	8b 00                	mov    (%eax),%eax
80107eee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80107ef1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ef4:	83 ec 0c             	sub    $0xc,%esp
80107ef7:	50                   	push   %eax
80107ef8:	e8 ce cc ff ff       	call   80104bcb <growproc>
80107efd:	83 c4 10             	add    $0x10,%esp
80107f00:	85 c0                	test   %eax,%eax
80107f02:	79 07                	jns    80107f0b <sys_sbrk+0x47>
    return -1;
80107f04:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f09:	eb 03                	jmp    80107f0e <sys_sbrk+0x4a>
  return addr;
80107f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80107f0e:	c9                   	leave  
80107f0f:	c3                   	ret    

80107f10 <sys_sleep>:

int
sys_sleep(void)
{
80107f10:	55                   	push   %ebp
80107f11:	89 e5                	mov    %esp,%ebp
80107f13:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80107f16:	83 ec 08             	sub    $0x8,%esp
80107f19:	8d 45 f0             	lea    -0x10(%ebp),%eax
80107f1c:	50                   	push   %eax
80107f1d:	6a 00                	push   $0x0
80107f1f:	e8 44 ef ff ff       	call   80106e68 <argint>
80107f24:	83 c4 10             	add    $0x10,%esp
80107f27:	85 c0                	test   %eax,%eax
80107f29:	79 07                	jns    80107f32 <sys_sleep+0x22>
    return -1;
80107f2b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f30:	eb 44                	jmp    80107f76 <sys_sleep+0x66>
  ticks0 = ticks;
80107f32:	a1 20 79 11 80       	mov    0x80117920,%eax
80107f37:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80107f3a:	eb 26                	jmp    80107f62 <sys_sleep+0x52>
    if(proc->killed){
80107f3c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107f42:	8b 40 24             	mov    0x24(%eax),%eax
80107f45:	85 c0                	test   %eax,%eax
80107f47:	74 07                	je     80107f50 <sys_sleep+0x40>
      return -1;
80107f49:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107f4e:	eb 26                	jmp    80107f76 <sys_sleep+0x66>
    }
    sleep(&ticks, (struct spinlock *)0);
80107f50:	83 ec 08             	sub    $0x8,%esp
80107f53:	6a 00                	push   $0x0
80107f55:	68 20 79 11 80       	push   $0x80117920
80107f5a:	e8 f3 d6 ff ff       	call   80105652 <sleep>
80107f5f:	83 c4 10             	add    $0x10,%esp
  uint ticks0;
  
  if(argint(0, &n) < 0)
    return -1;
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80107f62:	a1 20 79 11 80       	mov    0x80117920,%eax
80107f67:	2b 45 f4             	sub    -0xc(%ebp),%eax
80107f6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80107f6d:	39 d0                	cmp    %edx,%eax
80107f6f:	72 cb                	jb     80107f3c <sys_sleep+0x2c>
    if(proc->killed){
      return -1;
    }
    sleep(&ticks, (struct spinlock *)0);
  }
  return 0;
80107f71:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107f76:	c9                   	leave  
80107f77:	c3                   	ret    

80107f78 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start. 
int
sys_uptime(void)
{
80107f78:	55                   	push   %ebp
80107f79:	89 e5                	mov    %esp,%ebp
80107f7b:	83 ec 10             	sub    $0x10,%esp
  uint xticks;
  
  xticks = ticks;
80107f7e:	a1 20 79 11 80       	mov    0x80117920,%eax
80107f83:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return xticks;
80107f86:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80107f89:	c9                   	leave  
80107f8a:	c3                   	ret    

80107f8b <sys_halt>:

//Turn of the computer
int sys_halt(void){
80107f8b:	55                   	push   %ebp
80107f8c:	89 e5                	mov    %esp,%ebp
80107f8e:	83 ec 08             	sub    $0x8,%esp
  cprintf("Shutting down ...\n");
80107f91:	83 ec 0c             	sub    $0xc,%esp
80107f94:	68 39 a7 10 80       	push   $0x8010a739
80107f99:	e8 28 84 ff ff       	call   801003c6 <cprintf>
80107f9e:	83 c4 10             	add    $0x10,%esp
// outw (0xB004, 0x0 | 0x2000);  // changed in newest version of QEMU
  outw( 0x604, 0x0 | 0x2000);
80107fa1:	83 ec 08             	sub    $0x8,%esp
80107fa4:	68 00 20 00 00       	push   $0x2000
80107fa9:	68 04 06 00 00       	push   $0x604
80107fae:	e8 83 fe ff ff       	call   80107e36 <outw>
80107fb3:	83 c4 10             	add    $0x10,%esp
  return 0;
80107fb6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107fbb:	c9                   	leave  
80107fbc:	c3                   	ret    

80107fbd <sys_date>:

// My implementation of sys_date()
int
sys_date(void)
{
80107fbd:	55                   	push   %ebp
80107fbe:	89 e5                	mov    %esp,%ebp
80107fc0:	83 ec 18             	sub    $0x18,%esp
  struct rtcdate *d;

  if (argptr(0, (void*)&d, sizeof(*d)) < 0)
80107fc3:	83 ec 04             	sub    $0x4,%esp
80107fc6:	6a 18                	push   $0x18
80107fc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80107fcb:	50                   	push   %eax
80107fcc:	6a 00                	push   $0x0
80107fce:	e8 bd ee ff ff       	call   80106e90 <argptr>
80107fd3:	83 c4 10             	add    $0x10,%esp
80107fd6:	85 c0                	test   %eax,%eax
80107fd8:	79 07                	jns    80107fe1 <sys_date+0x24>
    return -1;
80107fda:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fdf:	eb 14                	jmp    80107ff5 <sys_date+0x38>
  // MY CODE HERE
  cmostime(d);       
80107fe1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe4:	83 ec 0c             	sub    $0xc,%esp
80107fe7:	50                   	push   %eax
80107fe8:	e8 1c b5 ff ff       	call   80103509 <cmostime>
80107fed:	83 c4 10             	add    $0x10,%esp
  return 0; 
80107ff0:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107ff5:	c9                   	leave  
80107ff6:	c3                   	ret    

80107ff7 <sys_getuid>:

// My implementation of sys_getuid
uint
sys_getuid(void)
{
80107ff7:	55                   	push   %ebp
80107ff8:	89 e5                	mov    %esp,%ebp
  return proc->uid;
80107ffa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108000:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
}
80108006:	5d                   	pop    %ebp
80108007:	c3                   	ret    

80108008 <sys_getgid>:

// My implementation of sys_getgid
uint
sys_getgid(void)
{
80108008:	55                   	push   %ebp
80108009:	89 e5                	mov    %esp,%ebp
  return proc->gid;
8010800b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108011:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
}
80108017:	5d                   	pop    %ebp
80108018:	c3                   	ret    

80108019 <sys_getppid>:

// My implementation of sys_getppid
uint
sys_getppid(void)
{
80108019:	55                   	push   %ebp
8010801a:	89 e5                	mov    %esp,%ebp
  return proc->parent ? proc->parent->pid : proc->pid;
8010801c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108022:	8b 40 14             	mov    0x14(%eax),%eax
80108025:	85 c0                	test   %eax,%eax
80108027:	74 0e                	je     80108037 <sys_getppid+0x1e>
80108029:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010802f:	8b 40 14             	mov    0x14(%eax),%eax
80108032:	8b 40 10             	mov    0x10(%eax),%eax
80108035:	eb 09                	jmp    80108040 <sys_getppid+0x27>
80108037:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010803d:	8b 40 10             	mov    0x10(%eax),%eax
}
80108040:	5d                   	pop    %ebp
80108041:	c3                   	ret    

80108042 <sys_setuid>:


// Implementation of sys_setuid
int 
sys_setuid(void)
{
80108042:	55                   	push   %ebp
80108043:	89 e5                	mov    %esp,%ebp
80108045:	83 ec 18             	sub    $0x18,%esp
  int id; // uid argument
  // Grab argument off the stack and store in id
  argint(0, &id);
80108048:	83 ec 08             	sub    $0x8,%esp
8010804b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010804e:	50                   	push   %eax
8010804f:	6a 00                	push   $0x0
80108051:	e8 12 ee ff ff       	call   80106e68 <argint>
80108056:	83 c4 10             	add    $0x10,%esp
  if(id < 0 || id > 32767)
80108059:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805c:	85 c0                	test   %eax,%eax
8010805e:	78 0a                	js     8010806a <sys_setuid+0x28>
80108060:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108063:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
80108068:	7e 07                	jle    80108071 <sys_setuid+0x2f>
    return -1;
8010806a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010806f:	eb 14                	jmp    80108085 <sys_setuid+0x43>
  proc->uid = id; 
80108071:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108077:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010807a:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  return 0;
80108080:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108085:	c9                   	leave  
80108086:	c3                   	ret    

80108087 <sys_setgid>:

// Implementation of sys_setgid
int
sys_setgid(void)
{
80108087:	55                   	push   %ebp
80108088:	89 e5                	mov    %esp,%ebp
8010808a:	83 ec 18             	sub    $0x18,%esp
  int id; // gid argument 
  // Grab argument off the stack and store in id
  argint(0, &id);
8010808d:	83 ec 08             	sub    $0x8,%esp
80108090:	8d 45 f4             	lea    -0xc(%ebp),%eax
80108093:	50                   	push   %eax
80108094:	6a 00                	push   $0x0
80108096:	e8 cd ed ff ff       	call   80106e68 <argint>
8010809b:	83 c4 10             	add    $0x10,%esp
  if(id < 0 || id > 32767)
8010809e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a1:	85 c0                	test   %eax,%eax
801080a3:	78 0a                	js     801080af <sys_setgid+0x28>
801080a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a8:	3d ff 7f 00 00       	cmp    $0x7fff,%eax
801080ad:	7e 07                	jle    801080b6 <sys_setgid+0x2f>
    return -1;
801080af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080b4:	eb 14                	jmp    801080ca <sys_setgid+0x43>
  proc->gid = id;
801080b6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801080bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801080bf:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)
  return 0;
801080c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801080ca:	c9                   	leave  
801080cb:	c3                   	ret    

801080cc <sys_getprocs>:

// Implementation of sys_getprocs
int
sys_getprocs(void)
{
801080cc:	55                   	push   %ebp
801080cd:	89 e5                	mov    %esp,%ebp
801080cf:	83 ec 18             	sub    $0x18,%esp
  int m; // Max arg
  struct uproc* table;
  argint(0, &m);
801080d2:	83 ec 08             	sub    $0x8,%esp
801080d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801080d8:	50                   	push   %eax
801080d9:	6a 00                	push   $0x0
801080db:	e8 88 ed ff ff       	call   80106e68 <argint>
801080e0:	83 c4 10             	add    $0x10,%esp
  if (m < 0)
801080e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e6:	85 c0                	test   %eax,%eax
801080e8:	79 07                	jns    801080f1 <sys_getprocs+0x25>
    return -1;
801080ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801080ef:	eb 28                	jmp    80108119 <sys_getprocs+0x4d>
  argptr(1, (void*)&table, m);
801080f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f4:	83 ec 04             	sub    $0x4,%esp
801080f7:	50                   	push   %eax
801080f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
801080fb:	50                   	push   %eax
801080fc:	6a 01                	push   $0x1
801080fe:	e8 8d ed ff ff       	call   80106e90 <argptr>
80108103:	83 c4 10             	add    $0x10,%esp
  return getproc_helper(m, table);
80108106:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010810c:	83 ec 08             	sub    $0x8,%esp
8010810f:	52                   	push   %edx
80108110:	50                   	push   %eax
80108111:	e8 9d db ff ff       	call   80105cb3 <getproc_helper>
80108116:	83 c4 10             	add    $0x10,%esp
}
80108119:	c9                   	leave  
8010811a:	c3                   	ret    

8010811b <sys_setpriority>:

#ifdef CS333_P3P4
// Implementation of sys_setpriority
int
sys_setpriority(void)
{
8010811b:	55                   	push   %ebp
8010811c:	89 e5                	mov    %esp,%ebp
8010811e:	83 ec 18             	sub    $0x18,%esp
  int pid;
  int prio;

  argint(0, &pid);
80108121:	83 ec 08             	sub    $0x8,%esp
80108124:	8d 45 f4             	lea    -0xc(%ebp),%eax
80108127:	50                   	push   %eax
80108128:	6a 00                	push   $0x0
8010812a:	e8 39 ed ff ff       	call   80106e68 <argint>
8010812f:	83 c4 10             	add    $0x10,%esp
  argint(1, &prio);
80108132:	83 ec 08             	sub    $0x8,%esp
80108135:	8d 45 f0             	lea    -0x10(%ebp),%eax
80108138:	50                   	push   %eax
80108139:	6a 01                	push   $0x1
8010813b:	e8 28 ed ff ff       	call   80106e68 <argint>
80108140:	83 c4 10             	add    $0x10,%esp
  return set_priority(pid, prio);
80108143:	8b 55 f0             	mov    -0x10(%ebp),%edx
80108146:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108149:	83 ec 08             	sub    $0x8,%esp
8010814c:	52                   	push   %edx
8010814d:	50                   	push   %eax
8010814e:	e8 14 e3 ff ff       	call   80106467 <set_priority>
80108153:	83 c4 10             	add    $0x10,%esp
}
80108156:	c9                   	leave  
80108157:	c3                   	ret    

80108158 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80108158:	55                   	push   %ebp
80108159:	89 e5                	mov    %esp,%ebp
8010815b:	83 ec 08             	sub    $0x8,%esp
8010815e:	8b 55 08             	mov    0x8(%ebp),%edx
80108161:	8b 45 0c             	mov    0xc(%ebp),%eax
80108164:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80108168:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010816b:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010816f:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80108173:	ee                   	out    %al,(%dx)
}
80108174:	90                   	nop
80108175:	c9                   	leave  
80108176:	c3                   	ret    

80108177 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80108177:	55                   	push   %ebp
80108178:	89 e5                	mov    %esp,%ebp
8010817a:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
8010817d:	6a 34                	push   $0x34
8010817f:	6a 43                	push   $0x43
80108181:	e8 d2 ff ff ff       	call   80108158 <outb>
80108186:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80108189:	68 9c 00 00 00       	push   $0x9c
8010818e:	6a 40                	push   $0x40
80108190:	e8 c3 ff ff ff       	call   80108158 <outb>
80108195:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80108198:	6a 2e                	push   $0x2e
8010819a:	6a 40                	push   $0x40
8010819c:	e8 b7 ff ff ff       	call   80108158 <outb>
801081a1:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
801081a4:	83 ec 0c             	sub    $0xc,%esp
801081a7:	6a 00                	push   $0x0
801081a9:	e8 be c0 ff ff       	call   8010426c <picenable>
801081ae:	83 c4 10             	add    $0x10,%esp
}
801081b1:	90                   	nop
801081b2:	c9                   	leave  
801081b3:	c3                   	ret    

801081b4 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801081b4:	1e                   	push   %ds
  pushl %es
801081b5:	06                   	push   %es
  pushl %fs
801081b6:	0f a0                	push   %fs
  pushl %gs
801081b8:	0f a8                	push   %gs
  pushal
801081ba:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801081bb:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801081bf:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801081c1:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801081c3:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801081c7:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801081c9:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801081cb:	54                   	push   %esp
  call trap
801081cc:	e8 ce 01 00 00       	call   8010839f <trap>
  addl $4, %esp
801081d1:	83 c4 04             	add    $0x4,%esp

801081d4 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801081d4:	61                   	popa   
  popl %gs
801081d5:	0f a9                	pop    %gs
  popl %fs
801081d7:	0f a1                	pop    %fs
  popl %es
801081d9:	07                   	pop    %es
  popl %ds
801081da:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801081db:	83 c4 08             	add    $0x8,%esp
  iret
801081de:	cf                   	iret   

801081df <atom_inc>:

// Routines added for CS333
// atom_inc() added to simplify handling of ticks global
static inline void
atom_inc(volatile int *num)
{
801081df:	55                   	push   %ebp
801081e0:	89 e5                	mov    %esp,%ebp
  asm volatile ( "lock incl %0" : "=m" (*num));
801081e2:	8b 45 08             	mov    0x8(%ebp),%eax
801081e5:	f0 ff 00             	lock incl (%eax)
}
801081e8:	90                   	nop
801081e9:	5d                   	pop    %ebp
801081ea:	c3                   	ret    

801081eb <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
801081eb:	55                   	push   %ebp
801081ec:	89 e5                	mov    %esp,%ebp
801081ee:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
801081f1:	8b 45 0c             	mov    0xc(%ebp),%eax
801081f4:	83 e8 01             	sub    $0x1,%eax
801081f7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801081fb:	8b 45 08             	mov    0x8(%ebp),%eax
801081fe:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80108202:	8b 45 08             	mov    0x8(%ebp),%eax
80108205:	c1 e8 10             	shr    $0x10,%eax
80108208:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010820c:	8d 45 fa             	lea    -0x6(%ebp),%eax
8010820f:	0f 01 18             	lidtl  (%eax)
}
80108212:	90                   	nop
80108213:	c9                   	leave  
80108214:	c3                   	ret    

80108215 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80108215:	55                   	push   %ebp
80108216:	89 e5                	mov    %esp,%ebp
80108218:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010821b:	0f 20 d0             	mov    %cr2,%eax
8010821e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80108221:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80108224:	c9                   	leave  
80108225:	c3                   	ret    

80108226 <tvinit>:
// Software Developer’s Manual, Vol 3A, 8.1.1 Guaranteed Atomic Operations.
uint ticks __attribute__ ((aligned (4)));

void
tvinit(void)
{
80108226:	55                   	push   %ebp
80108227:	89 e5                	mov    %esp,%ebp
80108229:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
8010822c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80108233:	e9 c3 00 00 00       	jmp    801082fb <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80108238:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010823b:	8b 04 85 c8 d0 10 80 	mov    -0x7fef2f38(,%eax,4),%eax
80108242:	89 c2                	mov    %eax,%edx
80108244:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108247:	66 89 14 c5 20 71 11 	mov    %dx,-0x7fee8ee0(,%eax,8)
8010824e:	80 
8010824f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108252:	66 c7 04 c5 22 71 11 	movw   $0x8,-0x7fee8ede(,%eax,8)
80108259:	80 08 00 
8010825c:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010825f:	0f b6 14 c5 24 71 11 	movzbl -0x7fee8edc(,%eax,8),%edx
80108266:	80 
80108267:	83 e2 e0             	and    $0xffffffe0,%edx
8010826a:	88 14 c5 24 71 11 80 	mov    %dl,-0x7fee8edc(,%eax,8)
80108271:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108274:	0f b6 14 c5 24 71 11 	movzbl -0x7fee8edc(,%eax,8),%edx
8010827b:	80 
8010827c:	83 e2 1f             	and    $0x1f,%edx
8010827f:	88 14 c5 24 71 11 80 	mov    %dl,-0x7fee8edc(,%eax,8)
80108286:	8b 45 fc             	mov    -0x4(%ebp),%eax
80108289:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
80108290:	80 
80108291:	83 e2 f0             	and    $0xfffffff0,%edx
80108294:	83 ca 0e             	or     $0xe,%edx
80108297:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
8010829e:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082a1:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
801082a8:	80 
801082a9:	83 e2 ef             	and    $0xffffffef,%edx
801082ac:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
801082b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082b6:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
801082bd:	80 
801082be:	83 e2 9f             	and    $0xffffff9f,%edx
801082c1:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
801082c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082cb:	0f b6 14 c5 25 71 11 	movzbl -0x7fee8edb(,%eax,8),%edx
801082d2:	80 
801082d3:	83 ca 80             	or     $0xffffff80,%edx
801082d6:	88 14 c5 25 71 11 80 	mov    %dl,-0x7fee8edb(,%eax,8)
801082dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082e0:	8b 04 85 c8 d0 10 80 	mov    -0x7fef2f38(,%eax,4),%eax
801082e7:	c1 e8 10             	shr    $0x10,%eax
801082ea:	89 c2                	mov    %eax,%edx
801082ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
801082ef:	66 89 14 c5 26 71 11 	mov    %dx,-0x7fee8eda(,%eax,8)
801082f6:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801082f7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801082fb:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
80108302:	0f 8e 30 ff ff ff    	jle    80108238 <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80108308:	a1 c8 d1 10 80       	mov    0x8010d1c8,%eax
8010830d:	66 a3 20 73 11 80    	mov    %ax,0x80117320
80108313:	66 c7 05 22 73 11 80 	movw   $0x8,0x80117322
8010831a:	08 00 
8010831c:	0f b6 05 24 73 11 80 	movzbl 0x80117324,%eax
80108323:	83 e0 e0             	and    $0xffffffe0,%eax
80108326:	a2 24 73 11 80       	mov    %al,0x80117324
8010832b:	0f b6 05 24 73 11 80 	movzbl 0x80117324,%eax
80108332:	83 e0 1f             	and    $0x1f,%eax
80108335:	a2 24 73 11 80       	mov    %al,0x80117324
8010833a:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
80108341:	83 c8 0f             	or     $0xf,%eax
80108344:	a2 25 73 11 80       	mov    %al,0x80117325
80108349:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
80108350:	83 e0 ef             	and    $0xffffffef,%eax
80108353:	a2 25 73 11 80       	mov    %al,0x80117325
80108358:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
8010835f:	83 c8 60             	or     $0x60,%eax
80108362:	a2 25 73 11 80       	mov    %al,0x80117325
80108367:	0f b6 05 25 73 11 80 	movzbl 0x80117325,%eax
8010836e:	83 c8 80             	or     $0xffffff80,%eax
80108371:	a2 25 73 11 80       	mov    %al,0x80117325
80108376:	a1 c8 d1 10 80       	mov    0x8010d1c8,%eax
8010837b:	c1 e8 10             	shr    $0x10,%eax
8010837e:	66 a3 26 73 11 80    	mov    %ax,0x80117326
  
}
80108384:	90                   	nop
80108385:	c9                   	leave  
80108386:	c3                   	ret    

80108387 <idtinit>:

void
idtinit(void)
{
80108387:	55                   	push   %ebp
80108388:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));
8010838a:	68 00 08 00 00       	push   $0x800
8010838f:	68 20 71 11 80       	push   $0x80117120
80108394:	e8 52 fe ff ff       	call   801081eb <lidt>
80108399:	83 c4 08             	add    $0x8,%esp
}
8010839c:	90                   	nop
8010839d:	c9                   	leave  
8010839e:	c3                   	ret    

8010839f <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
8010839f:	55                   	push   %ebp
801083a0:	89 e5                	mov    %esp,%ebp
801083a2:	57                   	push   %edi
801083a3:	56                   	push   %esi
801083a4:	53                   	push   %ebx
801083a5:	83 ec 1c             	sub    $0x1c,%esp
  if(tf->trapno == T_SYSCALL){
801083a8:	8b 45 08             	mov    0x8(%ebp),%eax
801083ab:	8b 40 30             	mov    0x30(%eax),%eax
801083ae:	83 f8 40             	cmp    $0x40,%eax
801083b1:	75 3e                	jne    801083f1 <trap+0x52>
    if(proc->killed)
801083b3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801083b9:	8b 40 24             	mov    0x24(%eax),%eax
801083bc:	85 c0                	test   %eax,%eax
801083be:	74 05                	je     801083c5 <trap+0x26>
      exit();
801083c0:	e8 1f cb ff ff       	call   80104ee4 <exit>
    proc->tf = tf;
801083c5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801083cb:	8b 55 08             	mov    0x8(%ebp),%edx
801083ce:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801083d1:	e8 48 eb ff ff       	call   80106f1e <syscall>
    if(proc->killed)
801083d6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801083dc:	8b 40 24             	mov    0x24(%eax),%eax
801083df:	85 c0                	test   %eax,%eax
801083e1:	0f 84 fe 01 00 00    	je     801085e5 <trap+0x246>
      exit();
801083e7:	e8 f8 ca ff ff       	call   80104ee4 <exit>
    return;
801083ec:	e9 f4 01 00 00       	jmp    801085e5 <trap+0x246>
  }

  switch(tf->trapno){
801083f1:	8b 45 08             	mov    0x8(%ebp),%eax
801083f4:	8b 40 30             	mov    0x30(%eax),%eax
801083f7:	83 e8 20             	sub    $0x20,%eax
801083fa:	83 f8 1f             	cmp    $0x1f,%eax
801083fd:	0f 87 a3 00 00 00    	ja     801084a6 <trap+0x107>
80108403:	8b 04 85 ec a7 10 80 	mov    -0x7fef5814(,%eax,4),%eax
8010840a:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
   if(cpu->id == 0){
8010840c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108412:	0f b6 00             	movzbl (%eax),%eax
80108415:	84 c0                	test   %al,%al
80108417:	75 20                	jne    80108439 <trap+0x9a>
      atom_inc((int *)&ticks);   // guaranteed atomic so no lock necessary
80108419:	83 ec 0c             	sub    $0xc,%esp
8010841c:	68 20 79 11 80       	push   $0x80117920
80108421:	e8 b9 fd ff ff       	call   801081df <atom_inc>
80108426:	83 c4 10             	add    $0x10,%esp
      wakeup(&ticks);
80108429:	83 ec 0c             	sub    $0xc,%esp
8010842c:	68 20 79 11 80       	push   $0x80117920
80108431:	e8 f5 d3 ff ff       	call   8010582b <wakeup>
80108436:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80108439:	e8 28 af ff ff       	call   80103366 <lapiceoi>
    break;
8010843e:	e9 1c 01 00 00       	jmp    8010855f <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80108443:	e8 31 a7 ff ff       	call   80102b79 <ideintr>
    lapiceoi();
80108448:	e8 19 af ff ff       	call   80103366 <lapiceoi>
    break;
8010844d:	e9 0d 01 00 00       	jmp    8010855f <trap+0x1c0>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80108452:	e8 11 ad ff ff       	call   80103168 <kbdintr>
    lapiceoi();
80108457:	e8 0a af ff ff       	call   80103366 <lapiceoi>
    break;
8010845c:	e9 fe 00 00 00       	jmp    8010855f <trap+0x1c0>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80108461:	e8 60 03 00 00       	call   801087c6 <uartintr>
    lapiceoi();
80108466:	e8 fb ae ff ff       	call   80103366 <lapiceoi>
    break;
8010846b:	e9 ef 00 00 00       	jmp    8010855f <trap+0x1c0>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108470:	8b 45 08             	mov    0x8(%ebp),%eax
80108473:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
80108476:	8b 45 08             	mov    0x8(%ebp),%eax
80108479:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010847d:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
80108480:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108486:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80108489:	0f b6 c0             	movzbl %al,%eax
8010848c:	51                   	push   %ecx
8010848d:	52                   	push   %edx
8010848e:	50                   	push   %eax
8010848f:	68 4c a7 10 80       	push   $0x8010a74c
80108494:	e8 2d 7f ff ff       	call   801003c6 <cprintf>
80108499:	83 c4 10             	add    $0x10,%esp
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
8010849c:	e8 c5 ae ff ff       	call   80103366 <lapiceoi>
    break;
801084a1:	e9 b9 00 00 00       	jmp    8010855f <trap+0x1c0>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801084a6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801084ac:	85 c0                	test   %eax,%eax
801084ae:	74 11                	je     801084c1 <trap+0x122>
801084b0:	8b 45 08             	mov    0x8(%ebp),%eax
801084b3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801084b7:	0f b7 c0             	movzwl %ax,%eax
801084ba:	83 e0 03             	and    $0x3,%eax
801084bd:	85 c0                	test   %eax,%eax
801084bf:	75 40                	jne    80108501 <trap+0x162>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801084c1:	e8 4f fd ff ff       	call   80108215 <rcr2>
801084c6:	89 c3                	mov    %eax,%ebx
801084c8:	8b 45 08             	mov    0x8(%ebp),%eax
801084cb:	8b 48 38             	mov    0x38(%eax),%ecx
              tf->trapno, cpu->id, tf->eip, rcr2());
801084ce:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801084d4:	0f b6 00             	movzbl (%eax),%eax
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801084d7:	0f b6 d0             	movzbl %al,%edx
801084da:	8b 45 08             	mov    0x8(%ebp),%eax
801084dd:	8b 40 30             	mov    0x30(%eax),%eax
801084e0:	83 ec 0c             	sub    $0xc,%esp
801084e3:	53                   	push   %ebx
801084e4:	51                   	push   %ecx
801084e5:	52                   	push   %edx
801084e6:	50                   	push   %eax
801084e7:	68 70 a7 10 80       	push   $0x8010a770
801084ec:	e8 d5 7e ff ff       	call   801003c6 <cprintf>
801084f1:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
801084f4:	83 ec 0c             	sub    $0xc,%esp
801084f7:	68 a2 a7 10 80       	push   $0x8010a7a2
801084fc:	e8 65 80 ff ff       	call   80100566 <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108501:	e8 0f fd ff ff       	call   80108215 <rcr2>
80108506:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80108509:	8b 45 08             	mov    0x8(%ebp),%eax
8010850c:	8b 70 38             	mov    0x38(%eax),%esi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010850f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80108515:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108518:	0f b6 d8             	movzbl %al,%ebx
8010851b:	8b 45 08             	mov    0x8(%ebp),%eax
8010851e:	8b 48 34             	mov    0x34(%eax),%ecx
80108521:	8b 45 08             	mov    0x8(%ebp),%eax
80108524:	8b 50 30             	mov    0x30(%eax),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80108527:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010852d:	8d 78 6c             	lea    0x6c(%eax),%edi
80108530:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80108536:	8b 40 10             	mov    0x10(%eax),%eax
80108539:	ff 75 e4             	pushl  -0x1c(%ebp)
8010853c:	56                   	push   %esi
8010853d:	53                   	push   %ebx
8010853e:	51                   	push   %ecx
8010853f:	52                   	push   %edx
80108540:	57                   	push   %edi
80108541:	50                   	push   %eax
80108542:	68 a8 a7 10 80       	push   $0x8010a7a8
80108547:	e8 7a 7e ff ff       	call   801003c6 <cprintf>
8010854c:	83 c4 20             	add    $0x20,%esp
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
8010854f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108555:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010855c:	eb 01                	jmp    8010855f <trap+0x1c0>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
8010855e:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
8010855f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108565:	85 c0                	test   %eax,%eax
80108567:	74 24                	je     8010858d <trap+0x1ee>
80108569:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010856f:	8b 40 24             	mov    0x24(%eax),%eax
80108572:	85 c0                	test   %eax,%eax
80108574:	74 17                	je     8010858d <trap+0x1ee>
80108576:	8b 45 08             	mov    0x8(%ebp),%eax
80108579:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
8010857d:	0f b7 c0             	movzwl %ax,%eax
80108580:	83 e0 03             	and    $0x3,%eax
80108583:	83 f8 03             	cmp    $0x3,%eax
80108586:	75 05                	jne    8010858d <trap+0x1ee>
    exit();
80108588:	e8 57 c9 ff ff       	call   80104ee4 <exit>

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
8010858d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80108593:	85 c0                	test   %eax,%eax
80108595:	74 1e                	je     801085b5 <trap+0x216>
80108597:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010859d:	8b 40 0c             	mov    0xc(%eax),%eax
801085a0:	83 f8 04             	cmp    $0x4,%eax
801085a3:	75 10                	jne    801085b5 <trap+0x216>
801085a5:	8b 45 08             	mov    0x8(%ebp),%eax
801085a8:	8b 40 30             	mov    0x30(%eax),%eax
801085ab:	83 f8 20             	cmp    $0x20,%eax
801085ae:	75 05                	jne    801085b5 <trap+0x216>
    yield();
801085b0:	e8 5a cf ff ff       	call   8010550f <yield>

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801085b5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085bb:	85 c0                	test   %eax,%eax
801085bd:	74 27                	je     801085e6 <trap+0x247>
801085bf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801085c5:	8b 40 24             	mov    0x24(%eax),%eax
801085c8:	85 c0                	test   %eax,%eax
801085ca:	74 1a                	je     801085e6 <trap+0x247>
801085cc:	8b 45 08             	mov    0x8(%ebp),%eax
801085cf:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801085d3:	0f b7 c0             	movzwl %ax,%eax
801085d6:	83 e0 03             	and    $0x3,%eax
801085d9:	83 f8 03             	cmp    $0x3,%eax
801085dc:	75 08                	jne    801085e6 <trap+0x247>
    exit();
801085de:	e8 01 c9 ff ff       	call   80104ee4 <exit>
801085e3:	eb 01                	jmp    801085e6 <trap+0x247>
      exit();
    proc->tf = tf;
    syscall();
    if(proc->killed)
      exit();
    return;
801085e5:	90                   	nop
    yield();

  // Check if the process has been killed since we yielded
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
    exit();
}
801085e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801085e9:	5b                   	pop    %ebx
801085ea:	5e                   	pop    %esi
801085eb:	5f                   	pop    %edi
801085ec:	5d                   	pop    %ebp
801085ed:	c3                   	ret    

801085ee <inb>:

// end of CS333 added routines

static inline uchar
inb(ushort port)
{
801085ee:	55                   	push   %ebp
801085ef:	89 e5                	mov    %esp,%ebp
801085f1:	83 ec 14             	sub    $0x14,%esp
801085f4:	8b 45 08             	mov    0x8(%ebp),%eax
801085f7:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801085fb:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801085ff:	89 c2                	mov    %eax,%edx
80108601:	ec                   	in     (%dx),%al
80108602:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80108605:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80108609:	c9                   	leave  
8010860a:	c3                   	ret    

8010860b <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010860b:	55                   	push   %ebp
8010860c:	89 e5                	mov    %esp,%ebp
8010860e:	83 ec 08             	sub    $0x8,%esp
80108611:	8b 55 08             	mov    0x8(%ebp),%edx
80108614:	8b 45 0c             	mov    0xc(%ebp),%eax
80108617:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010861b:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010861e:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80108622:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80108626:	ee                   	out    %al,(%dx)
}
80108627:	90                   	nop
80108628:	c9                   	leave  
80108629:	c3                   	ret    

8010862a <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
8010862a:	55                   	push   %ebp
8010862b:	89 e5                	mov    %esp,%ebp
8010862d:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80108630:	6a 00                	push   $0x0
80108632:	68 fa 03 00 00       	push   $0x3fa
80108637:	e8 cf ff ff ff       	call   8010860b <outb>
8010863c:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
8010863f:	68 80 00 00 00       	push   $0x80
80108644:	68 fb 03 00 00       	push   $0x3fb
80108649:	e8 bd ff ff ff       	call   8010860b <outb>
8010864e:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80108651:	6a 0c                	push   $0xc
80108653:	68 f8 03 00 00       	push   $0x3f8
80108658:	e8 ae ff ff ff       	call   8010860b <outb>
8010865d:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80108660:	6a 00                	push   $0x0
80108662:	68 f9 03 00 00       	push   $0x3f9
80108667:	e8 9f ff ff ff       	call   8010860b <outb>
8010866c:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
8010866f:	6a 03                	push   $0x3
80108671:	68 fb 03 00 00       	push   $0x3fb
80108676:	e8 90 ff ff ff       	call   8010860b <outb>
8010867b:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
8010867e:	6a 00                	push   $0x0
80108680:	68 fc 03 00 00       	push   $0x3fc
80108685:	e8 81 ff ff ff       	call   8010860b <outb>
8010868a:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010868d:	6a 01                	push   $0x1
8010868f:	68 f9 03 00 00       	push   $0x3f9
80108694:	e8 72 ff ff ff       	call   8010860b <outb>
80108699:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
8010869c:	68 fd 03 00 00       	push   $0x3fd
801086a1:	e8 48 ff ff ff       	call   801085ee <inb>
801086a6:	83 c4 04             	add    $0x4,%esp
801086a9:	3c ff                	cmp    $0xff,%al
801086ab:	74 6e                	je     8010871b <uartinit+0xf1>
    return;
  uart = 1;
801086ad:	c7 05 8c d6 10 80 01 	movl   $0x1,0x8010d68c
801086b4:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
801086b7:	68 fa 03 00 00       	push   $0x3fa
801086bc:	e8 2d ff ff ff       	call   801085ee <inb>
801086c1:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
801086c4:	68 f8 03 00 00       	push   $0x3f8
801086c9:	e8 20 ff ff ff       	call   801085ee <inb>
801086ce:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
801086d1:	83 ec 0c             	sub    $0xc,%esp
801086d4:	6a 04                	push   $0x4
801086d6:	e8 91 bb ff ff       	call   8010426c <picenable>
801086db:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
801086de:	83 ec 08             	sub    $0x8,%esp
801086e1:	6a 00                	push   $0x0
801086e3:	6a 04                	push   $0x4
801086e5:	e8 31 a7 ff ff       	call   80102e1b <ioapicenable>
801086ea:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
801086ed:	c7 45 f4 6c a8 10 80 	movl   $0x8010a86c,-0xc(%ebp)
801086f4:	eb 19                	jmp    8010870f <uartinit+0xe5>
    uartputc(*p);
801086f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086f9:	0f b6 00             	movzbl (%eax),%eax
801086fc:	0f be c0             	movsbl %al,%eax
801086ff:	83 ec 0c             	sub    $0xc,%esp
80108702:	50                   	push   %eax
80108703:	e8 16 00 00 00       	call   8010871e <uartputc>
80108708:	83 c4 10             	add    $0x10,%esp
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
8010870b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010870f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108712:	0f b6 00             	movzbl (%eax),%eax
80108715:	84 c0                	test   %al,%al
80108717:	75 dd                	jne    801086f6 <uartinit+0xcc>
80108719:	eb 01                	jmp    8010871c <uartinit+0xf2>
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
    return;
8010871b:	90                   	nop
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}
8010871c:	c9                   	leave  
8010871d:	c3                   	ret    

8010871e <uartputc>:

void
uartputc(int c)
{
8010871e:	55                   	push   %ebp
8010871f:	89 e5                	mov    %esp,%ebp
80108721:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80108724:	a1 8c d6 10 80       	mov    0x8010d68c,%eax
80108729:	85 c0                	test   %eax,%eax
8010872b:	74 53                	je     80108780 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010872d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108734:	eb 11                	jmp    80108747 <uartputc+0x29>
    microdelay(10);
80108736:	83 ec 0c             	sub    $0xc,%esp
80108739:	6a 0a                	push   $0xa
8010873b:	e8 41 ac ff ff       	call   80103381 <microdelay>
80108740:	83 c4 10             	add    $0x10,%esp
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80108743:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108747:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
8010874b:	7f 1a                	jg     80108767 <uartputc+0x49>
8010874d:	83 ec 0c             	sub    $0xc,%esp
80108750:	68 fd 03 00 00       	push   $0x3fd
80108755:	e8 94 fe ff ff       	call   801085ee <inb>
8010875a:	83 c4 10             	add    $0x10,%esp
8010875d:	0f b6 c0             	movzbl %al,%eax
80108760:	83 e0 20             	and    $0x20,%eax
80108763:	85 c0                	test   %eax,%eax
80108765:	74 cf                	je     80108736 <uartputc+0x18>
    microdelay(10);
  outb(COM1+0, c);
80108767:	8b 45 08             	mov    0x8(%ebp),%eax
8010876a:	0f b6 c0             	movzbl %al,%eax
8010876d:	83 ec 08             	sub    $0x8,%esp
80108770:	50                   	push   %eax
80108771:	68 f8 03 00 00       	push   $0x3f8
80108776:	e8 90 fe ff ff       	call   8010860b <outb>
8010877b:	83 c4 10             	add    $0x10,%esp
8010877e:	eb 01                	jmp    80108781 <uartputc+0x63>
uartputc(int c)
{
  int i;

  if(!uart)
    return;
80108780:	90                   	nop
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80108781:	c9                   	leave  
80108782:	c3                   	ret    

80108783 <uartgetc>:

static int
uartgetc(void)
{
80108783:	55                   	push   %ebp
80108784:	89 e5                	mov    %esp,%ebp
  if(!uart)
80108786:	a1 8c d6 10 80       	mov    0x8010d68c,%eax
8010878b:	85 c0                	test   %eax,%eax
8010878d:	75 07                	jne    80108796 <uartgetc+0x13>
    return -1;
8010878f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108794:	eb 2e                	jmp    801087c4 <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80108796:	68 fd 03 00 00       	push   $0x3fd
8010879b:	e8 4e fe ff ff       	call   801085ee <inb>
801087a0:	83 c4 04             	add    $0x4,%esp
801087a3:	0f b6 c0             	movzbl %al,%eax
801087a6:	83 e0 01             	and    $0x1,%eax
801087a9:	85 c0                	test   %eax,%eax
801087ab:	75 07                	jne    801087b4 <uartgetc+0x31>
    return -1;
801087ad:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801087b2:	eb 10                	jmp    801087c4 <uartgetc+0x41>
  return inb(COM1+0);
801087b4:	68 f8 03 00 00       	push   $0x3f8
801087b9:	e8 30 fe ff ff       	call   801085ee <inb>
801087be:	83 c4 04             	add    $0x4,%esp
801087c1:	0f b6 c0             	movzbl %al,%eax
}
801087c4:	c9                   	leave  
801087c5:	c3                   	ret    

801087c6 <uartintr>:

void
uartintr(void)
{
801087c6:	55                   	push   %ebp
801087c7:	89 e5                	mov    %esp,%ebp
801087c9:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
801087cc:	83 ec 0c             	sub    $0xc,%esp
801087cf:	68 83 87 10 80       	push   $0x80108783
801087d4:	e8 20 80 ff ff       	call   801007f9 <consoleintr>
801087d9:	83 c4 10             	add    $0x10,%esp
}
801087dc:	90                   	nop
801087dd:	c9                   	leave  
801087de:	c3                   	ret    

801087df <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801087df:	6a 00                	push   $0x0
  pushl $0
801087e1:	6a 00                	push   $0x0
  jmp alltraps
801087e3:	e9 cc f9 ff ff       	jmp    801081b4 <alltraps>

801087e8 <vector1>:
.globl vector1
vector1:
  pushl $0
801087e8:	6a 00                	push   $0x0
  pushl $1
801087ea:	6a 01                	push   $0x1
  jmp alltraps
801087ec:	e9 c3 f9 ff ff       	jmp    801081b4 <alltraps>

801087f1 <vector2>:
.globl vector2
vector2:
  pushl $0
801087f1:	6a 00                	push   $0x0
  pushl $2
801087f3:	6a 02                	push   $0x2
  jmp alltraps
801087f5:	e9 ba f9 ff ff       	jmp    801081b4 <alltraps>

801087fa <vector3>:
.globl vector3
vector3:
  pushl $0
801087fa:	6a 00                	push   $0x0
  pushl $3
801087fc:	6a 03                	push   $0x3
  jmp alltraps
801087fe:	e9 b1 f9 ff ff       	jmp    801081b4 <alltraps>

80108803 <vector4>:
.globl vector4
vector4:
  pushl $0
80108803:	6a 00                	push   $0x0
  pushl $4
80108805:	6a 04                	push   $0x4
  jmp alltraps
80108807:	e9 a8 f9 ff ff       	jmp    801081b4 <alltraps>

8010880c <vector5>:
.globl vector5
vector5:
  pushl $0
8010880c:	6a 00                	push   $0x0
  pushl $5
8010880e:	6a 05                	push   $0x5
  jmp alltraps
80108810:	e9 9f f9 ff ff       	jmp    801081b4 <alltraps>

80108815 <vector6>:
.globl vector6
vector6:
  pushl $0
80108815:	6a 00                	push   $0x0
  pushl $6
80108817:	6a 06                	push   $0x6
  jmp alltraps
80108819:	e9 96 f9 ff ff       	jmp    801081b4 <alltraps>

8010881e <vector7>:
.globl vector7
vector7:
  pushl $0
8010881e:	6a 00                	push   $0x0
  pushl $7
80108820:	6a 07                	push   $0x7
  jmp alltraps
80108822:	e9 8d f9 ff ff       	jmp    801081b4 <alltraps>

80108827 <vector8>:
.globl vector8
vector8:
  pushl $8
80108827:	6a 08                	push   $0x8
  jmp alltraps
80108829:	e9 86 f9 ff ff       	jmp    801081b4 <alltraps>

8010882e <vector9>:
.globl vector9
vector9:
  pushl $0
8010882e:	6a 00                	push   $0x0
  pushl $9
80108830:	6a 09                	push   $0x9
  jmp alltraps
80108832:	e9 7d f9 ff ff       	jmp    801081b4 <alltraps>

80108837 <vector10>:
.globl vector10
vector10:
  pushl $10
80108837:	6a 0a                	push   $0xa
  jmp alltraps
80108839:	e9 76 f9 ff ff       	jmp    801081b4 <alltraps>

8010883e <vector11>:
.globl vector11
vector11:
  pushl $11
8010883e:	6a 0b                	push   $0xb
  jmp alltraps
80108840:	e9 6f f9 ff ff       	jmp    801081b4 <alltraps>

80108845 <vector12>:
.globl vector12
vector12:
  pushl $12
80108845:	6a 0c                	push   $0xc
  jmp alltraps
80108847:	e9 68 f9 ff ff       	jmp    801081b4 <alltraps>

8010884c <vector13>:
.globl vector13
vector13:
  pushl $13
8010884c:	6a 0d                	push   $0xd
  jmp alltraps
8010884e:	e9 61 f9 ff ff       	jmp    801081b4 <alltraps>

80108853 <vector14>:
.globl vector14
vector14:
  pushl $14
80108853:	6a 0e                	push   $0xe
  jmp alltraps
80108855:	e9 5a f9 ff ff       	jmp    801081b4 <alltraps>

8010885a <vector15>:
.globl vector15
vector15:
  pushl $0
8010885a:	6a 00                	push   $0x0
  pushl $15
8010885c:	6a 0f                	push   $0xf
  jmp alltraps
8010885e:	e9 51 f9 ff ff       	jmp    801081b4 <alltraps>

80108863 <vector16>:
.globl vector16
vector16:
  pushl $0
80108863:	6a 00                	push   $0x0
  pushl $16
80108865:	6a 10                	push   $0x10
  jmp alltraps
80108867:	e9 48 f9 ff ff       	jmp    801081b4 <alltraps>

8010886c <vector17>:
.globl vector17
vector17:
  pushl $17
8010886c:	6a 11                	push   $0x11
  jmp alltraps
8010886e:	e9 41 f9 ff ff       	jmp    801081b4 <alltraps>

80108873 <vector18>:
.globl vector18
vector18:
  pushl $0
80108873:	6a 00                	push   $0x0
  pushl $18
80108875:	6a 12                	push   $0x12
  jmp alltraps
80108877:	e9 38 f9 ff ff       	jmp    801081b4 <alltraps>

8010887c <vector19>:
.globl vector19
vector19:
  pushl $0
8010887c:	6a 00                	push   $0x0
  pushl $19
8010887e:	6a 13                	push   $0x13
  jmp alltraps
80108880:	e9 2f f9 ff ff       	jmp    801081b4 <alltraps>

80108885 <vector20>:
.globl vector20
vector20:
  pushl $0
80108885:	6a 00                	push   $0x0
  pushl $20
80108887:	6a 14                	push   $0x14
  jmp alltraps
80108889:	e9 26 f9 ff ff       	jmp    801081b4 <alltraps>

8010888e <vector21>:
.globl vector21
vector21:
  pushl $0
8010888e:	6a 00                	push   $0x0
  pushl $21
80108890:	6a 15                	push   $0x15
  jmp alltraps
80108892:	e9 1d f9 ff ff       	jmp    801081b4 <alltraps>

80108897 <vector22>:
.globl vector22
vector22:
  pushl $0
80108897:	6a 00                	push   $0x0
  pushl $22
80108899:	6a 16                	push   $0x16
  jmp alltraps
8010889b:	e9 14 f9 ff ff       	jmp    801081b4 <alltraps>

801088a0 <vector23>:
.globl vector23
vector23:
  pushl $0
801088a0:	6a 00                	push   $0x0
  pushl $23
801088a2:	6a 17                	push   $0x17
  jmp alltraps
801088a4:	e9 0b f9 ff ff       	jmp    801081b4 <alltraps>

801088a9 <vector24>:
.globl vector24
vector24:
  pushl $0
801088a9:	6a 00                	push   $0x0
  pushl $24
801088ab:	6a 18                	push   $0x18
  jmp alltraps
801088ad:	e9 02 f9 ff ff       	jmp    801081b4 <alltraps>

801088b2 <vector25>:
.globl vector25
vector25:
  pushl $0
801088b2:	6a 00                	push   $0x0
  pushl $25
801088b4:	6a 19                	push   $0x19
  jmp alltraps
801088b6:	e9 f9 f8 ff ff       	jmp    801081b4 <alltraps>

801088bb <vector26>:
.globl vector26
vector26:
  pushl $0
801088bb:	6a 00                	push   $0x0
  pushl $26
801088bd:	6a 1a                	push   $0x1a
  jmp alltraps
801088bf:	e9 f0 f8 ff ff       	jmp    801081b4 <alltraps>

801088c4 <vector27>:
.globl vector27
vector27:
  pushl $0
801088c4:	6a 00                	push   $0x0
  pushl $27
801088c6:	6a 1b                	push   $0x1b
  jmp alltraps
801088c8:	e9 e7 f8 ff ff       	jmp    801081b4 <alltraps>

801088cd <vector28>:
.globl vector28
vector28:
  pushl $0
801088cd:	6a 00                	push   $0x0
  pushl $28
801088cf:	6a 1c                	push   $0x1c
  jmp alltraps
801088d1:	e9 de f8 ff ff       	jmp    801081b4 <alltraps>

801088d6 <vector29>:
.globl vector29
vector29:
  pushl $0
801088d6:	6a 00                	push   $0x0
  pushl $29
801088d8:	6a 1d                	push   $0x1d
  jmp alltraps
801088da:	e9 d5 f8 ff ff       	jmp    801081b4 <alltraps>

801088df <vector30>:
.globl vector30
vector30:
  pushl $0
801088df:	6a 00                	push   $0x0
  pushl $30
801088e1:	6a 1e                	push   $0x1e
  jmp alltraps
801088e3:	e9 cc f8 ff ff       	jmp    801081b4 <alltraps>

801088e8 <vector31>:
.globl vector31
vector31:
  pushl $0
801088e8:	6a 00                	push   $0x0
  pushl $31
801088ea:	6a 1f                	push   $0x1f
  jmp alltraps
801088ec:	e9 c3 f8 ff ff       	jmp    801081b4 <alltraps>

801088f1 <vector32>:
.globl vector32
vector32:
  pushl $0
801088f1:	6a 00                	push   $0x0
  pushl $32
801088f3:	6a 20                	push   $0x20
  jmp alltraps
801088f5:	e9 ba f8 ff ff       	jmp    801081b4 <alltraps>

801088fa <vector33>:
.globl vector33
vector33:
  pushl $0
801088fa:	6a 00                	push   $0x0
  pushl $33
801088fc:	6a 21                	push   $0x21
  jmp alltraps
801088fe:	e9 b1 f8 ff ff       	jmp    801081b4 <alltraps>

80108903 <vector34>:
.globl vector34
vector34:
  pushl $0
80108903:	6a 00                	push   $0x0
  pushl $34
80108905:	6a 22                	push   $0x22
  jmp alltraps
80108907:	e9 a8 f8 ff ff       	jmp    801081b4 <alltraps>

8010890c <vector35>:
.globl vector35
vector35:
  pushl $0
8010890c:	6a 00                	push   $0x0
  pushl $35
8010890e:	6a 23                	push   $0x23
  jmp alltraps
80108910:	e9 9f f8 ff ff       	jmp    801081b4 <alltraps>

80108915 <vector36>:
.globl vector36
vector36:
  pushl $0
80108915:	6a 00                	push   $0x0
  pushl $36
80108917:	6a 24                	push   $0x24
  jmp alltraps
80108919:	e9 96 f8 ff ff       	jmp    801081b4 <alltraps>

8010891e <vector37>:
.globl vector37
vector37:
  pushl $0
8010891e:	6a 00                	push   $0x0
  pushl $37
80108920:	6a 25                	push   $0x25
  jmp alltraps
80108922:	e9 8d f8 ff ff       	jmp    801081b4 <alltraps>

80108927 <vector38>:
.globl vector38
vector38:
  pushl $0
80108927:	6a 00                	push   $0x0
  pushl $38
80108929:	6a 26                	push   $0x26
  jmp alltraps
8010892b:	e9 84 f8 ff ff       	jmp    801081b4 <alltraps>

80108930 <vector39>:
.globl vector39
vector39:
  pushl $0
80108930:	6a 00                	push   $0x0
  pushl $39
80108932:	6a 27                	push   $0x27
  jmp alltraps
80108934:	e9 7b f8 ff ff       	jmp    801081b4 <alltraps>

80108939 <vector40>:
.globl vector40
vector40:
  pushl $0
80108939:	6a 00                	push   $0x0
  pushl $40
8010893b:	6a 28                	push   $0x28
  jmp alltraps
8010893d:	e9 72 f8 ff ff       	jmp    801081b4 <alltraps>

80108942 <vector41>:
.globl vector41
vector41:
  pushl $0
80108942:	6a 00                	push   $0x0
  pushl $41
80108944:	6a 29                	push   $0x29
  jmp alltraps
80108946:	e9 69 f8 ff ff       	jmp    801081b4 <alltraps>

8010894b <vector42>:
.globl vector42
vector42:
  pushl $0
8010894b:	6a 00                	push   $0x0
  pushl $42
8010894d:	6a 2a                	push   $0x2a
  jmp alltraps
8010894f:	e9 60 f8 ff ff       	jmp    801081b4 <alltraps>

80108954 <vector43>:
.globl vector43
vector43:
  pushl $0
80108954:	6a 00                	push   $0x0
  pushl $43
80108956:	6a 2b                	push   $0x2b
  jmp alltraps
80108958:	e9 57 f8 ff ff       	jmp    801081b4 <alltraps>

8010895d <vector44>:
.globl vector44
vector44:
  pushl $0
8010895d:	6a 00                	push   $0x0
  pushl $44
8010895f:	6a 2c                	push   $0x2c
  jmp alltraps
80108961:	e9 4e f8 ff ff       	jmp    801081b4 <alltraps>

80108966 <vector45>:
.globl vector45
vector45:
  pushl $0
80108966:	6a 00                	push   $0x0
  pushl $45
80108968:	6a 2d                	push   $0x2d
  jmp alltraps
8010896a:	e9 45 f8 ff ff       	jmp    801081b4 <alltraps>

8010896f <vector46>:
.globl vector46
vector46:
  pushl $0
8010896f:	6a 00                	push   $0x0
  pushl $46
80108971:	6a 2e                	push   $0x2e
  jmp alltraps
80108973:	e9 3c f8 ff ff       	jmp    801081b4 <alltraps>

80108978 <vector47>:
.globl vector47
vector47:
  pushl $0
80108978:	6a 00                	push   $0x0
  pushl $47
8010897a:	6a 2f                	push   $0x2f
  jmp alltraps
8010897c:	e9 33 f8 ff ff       	jmp    801081b4 <alltraps>

80108981 <vector48>:
.globl vector48
vector48:
  pushl $0
80108981:	6a 00                	push   $0x0
  pushl $48
80108983:	6a 30                	push   $0x30
  jmp alltraps
80108985:	e9 2a f8 ff ff       	jmp    801081b4 <alltraps>

8010898a <vector49>:
.globl vector49
vector49:
  pushl $0
8010898a:	6a 00                	push   $0x0
  pushl $49
8010898c:	6a 31                	push   $0x31
  jmp alltraps
8010898e:	e9 21 f8 ff ff       	jmp    801081b4 <alltraps>

80108993 <vector50>:
.globl vector50
vector50:
  pushl $0
80108993:	6a 00                	push   $0x0
  pushl $50
80108995:	6a 32                	push   $0x32
  jmp alltraps
80108997:	e9 18 f8 ff ff       	jmp    801081b4 <alltraps>

8010899c <vector51>:
.globl vector51
vector51:
  pushl $0
8010899c:	6a 00                	push   $0x0
  pushl $51
8010899e:	6a 33                	push   $0x33
  jmp alltraps
801089a0:	e9 0f f8 ff ff       	jmp    801081b4 <alltraps>

801089a5 <vector52>:
.globl vector52
vector52:
  pushl $0
801089a5:	6a 00                	push   $0x0
  pushl $52
801089a7:	6a 34                	push   $0x34
  jmp alltraps
801089a9:	e9 06 f8 ff ff       	jmp    801081b4 <alltraps>

801089ae <vector53>:
.globl vector53
vector53:
  pushl $0
801089ae:	6a 00                	push   $0x0
  pushl $53
801089b0:	6a 35                	push   $0x35
  jmp alltraps
801089b2:	e9 fd f7 ff ff       	jmp    801081b4 <alltraps>

801089b7 <vector54>:
.globl vector54
vector54:
  pushl $0
801089b7:	6a 00                	push   $0x0
  pushl $54
801089b9:	6a 36                	push   $0x36
  jmp alltraps
801089bb:	e9 f4 f7 ff ff       	jmp    801081b4 <alltraps>

801089c0 <vector55>:
.globl vector55
vector55:
  pushl $0
801089c0:	6a 00                	push   $0x0
  pushl $55
801089c2:	6a 37                	push   $0x37
  jmp alltraps
801089c4:	e9 eb f7 ff ff       	jmp    801081b4 <alltraps>

801089c9 <vector56>:
.globl vector56
vector56:
  pushl $0
801089c9:	6a 00                	push   $0x0
  pushl $56
801089cb:	6a 38                	push   $0x38
  jmp alltraps
801089cd:	e9 e2 f7 ff ff       	jmp    801081b4 <alltraps>

801089d2 <vector57>:
.globl vector57
vector57:
  pushl $0
801089d2:	6a 00                	push   $0x0
  pushl $57
801089d4:	6a 39                	push   $0x39
  jmp alltraps
801089d6:	e9 d9 f7 ff ff       	jmp    801081b4 <alltraps>

801089db <vector58>:
.globl vector58
vector58:
  pushl $0
801089db:	6a 00                	push   $0x0
  pushl $58
801089dd:	6a 3a                	push   $0x3a
  jmp alltraps
801089df:	e9 d0 f7 ff ff       	jmp    801081b4 <alltraps>

801089e4 <vector59>:
.globl vector59
vector59:
  pushl $0
801089e4:	6a 00                	push   $0x0
  pushl $59
801089e6:	6a 3b                	push   $0x3b
  jmp alltraps
801089e8:	e9 c7 f7 ff ff       	jmp    801081b4 <alltraps>

801089ed <vector60>:
.globl vector60
vector60:
  pushl $0
801089ed:	6a 00                	push   $0x0
  pushl $60
801089ef:	6a 3c                	push   $0x3c
  jmp alltraps
801089f1:	e9 be f7 ff ff       	jmp    801081b4 <alltraps>

801089f6 <vector61>:
.globl vector61
vector61:
  pushl $0
801089f6:	6a 00                	push   $0x0
  pushl $61
801089f8:	6a 3d                	push   $0x3d
  jmp alltraps
801089fa:	e9 b5 f7 ff ff       	jmp    801081b4 <alltraps>

801089ff <vector62>:
.globl vector62
vector62:
  pushl $0
801089ff:	6a 00                	push   $0x0
  pushl $62
80108a01:	6a 3e                	push   $0x3e
  jmp alltraps
80108a03:	e9 ac f7 ff ff       	jmp    801081b4 <alltraps>

80108a08 <vector63>:
.globl vector63
vector63:
  pushl $0
80108a08:	6a 00                	push   $0x0
  pushl $63
80108a0a:	6a 3f                	push   $0x3f
  jmp alltraps
80108a0c:	e9 a3 f7 ff ff       	jmp    801081b4 <alltraps>

80108a11 <vector64>:
.globl vector64
vector64:
  pushl $0
80108a11:	6a 00                	push   $0x0
  pushl $64
80108a13:	6a 40                	push   $0x40
  jmp alltraps
80108a15:	e9 9a f7 ff ff       	jmp    801081b4 <alltraps>

80108a1a <vector65>:
.globl vector65
vector65:
  pushl $0
80108a1a:	6a 00                	push   $0x0
  pushl $65
80108a1c:	6a 41                	push   $0x41
  jmp alltraps
80108a1e:	e9 91 f7 ff ff       	jmp    801081b4 <alltraps>

80108a23 <vector66>:
.globl vector66
vector66:
  pushl $0
80108a23:	6a 00                	push   $0x0
  pushl $66
80108a25:	6a 42                	push   $0x42
  jmp alltraps
80108a27:	e9 88 f7 ff ff       	jmp    801081b4 <alltraps>

80108a2c <vector67>:
.globl vector67
vector67:
  pushl $0
80108a2c:	6a 00                	push   $0x0
  pushl $67
80108a2e:	6a 43                	push   $0x43
  jmp alltraps
80108a30:	e9 7f f7 ff ff       	jmp    801081b4 <alltraps>

80108a35 <vector68>:
.globl vector68
vector68:
  pushl $0
80108a35:	6a 00                	push   $0x0
  pushl $68
80108a37:	6a 44                	push   $0x44
  jmp alltraps
80108a39:	e9 76 f7 ff ff       	jmp    801081b4 <alltraps>

80108a3e <vector69>:
.globl vector69
vector69:
  pushl $0
80108a3e:	6a 00                	push   $0x0
  pushl $69
80108a40:	6a 45                	push   $0x45
  jmp alltraps
80108a42:	e9 6d f7 ff ff       	jmp    801081b4 <alltraps>

80108a47 <vector70>:
.globl vector70
vector70:
  pushl $0
80108a47:	6a 00                	push   $0x0
  pushl $70
80108a49:	6a 46                	push   $0x46
  jmp alltraps
80108a4b:	e9 64 f7 ff ff       	jmp    801081b4 <alltraps>

80108a50 <vector71>:
.globl vector71
vector71:
  pushl $0
80108a50:	6a 00                	push   $0x0
  pushl $71
80108a52:	6a 47                	push   $0x47
  jmp alltraps
80108a54:	e9 5b f7 ff ff       	jmp    801081b4 <alltraps>

80108a59 <vector72>:
.globl vector72
vector72:
  pushl $0
80108a59:	6a 00                	push   $0x0
  pushl $72
80108a5b:	6a 48                	push   $0x48
  jmp alltraps
80108a5d:	e9 52 f7 ff ff       	jmp    801081b4 <alltraps>

80108a62 <vector73>:
.globl vector73
vector73:
  pushl $0
80108a62:	6a 00                	push   $0x0
  pushl $73
80108a64:	6a 49                	push   $0x49
  jmp alltraps
80108a66:	e9 49 f7 ff ff       	jmp    801081b4 <alltraps>

80108a6b <vector74>:
.globl vector74
vector74:
  pushl $0
80108a6b:	6a 00                	push   $0x0
  pushl $74
80108a6d:	6a 4a                	push   $0x4a
  jmp alltraps
80108a6f:	e9 40 f7 ff ff       	jmp    801081b4 <alltraps>

80108a74 <vector75>:
.globl vector75
vector75:
  pushl $0
80108a74:	6a 00                	push   $0x0
  pushl $75
80108a76:	6a 4b                	push   $0x4b
  jmp alltraps
80108a78:	e9 37 f7 ff ff       	jmp    801081b4 <alltraps>

80108a7d <vector76>:
.globl vector76
vector76:
  pushl $0
80108a7d:	6a 00                	push   $0x0
  pushl $76
80108a7f:	6a 4c                	push   $0x4c
  jmp alltraps
80108a81:	e9 2e f7 ff ff       	jmp    801081b4 <alltraps>

80108a86 <vector77>:
.globl vector77
vector77:
  pushl $0
80108a86:	6a 00                	push   $0x0
  pushl $77
80108a88:	6a 4d                	push   $0x4d
  jmp alltraps
80108a8a:	e9 25 f7 ff ff       	jmp    801081b4 <alltraps>

80108a8f <vector78>:
.globl vector78
vector78:
  pushl $0
80108a8f:	6a 00                	push   $0x0
  pushl $78
80108a91:	6a 4e                	push   $0x4e
  jmp alltraps
80108a93:	e9 1c f7 ff ff       	jmp    801081b4 <alltraps>

80108a98 <vector79>:
.globl vector79
vector79:
  pushl $0
80108a98:	6a 00                	push   $0x0
  pushl $79
80108a9a:	6a 4f                	push   $0x4f
  jmp alltraps
80108a9c:	e9 13 f7 ff ff       	jmp    801081b4 <alltraps>

80108aa1 <vector80>:
.globl vector80
vector80:
  pushl $0
80108aa1:	6a 00                	push   $0x0
  pushl $80
80108aa3:	6a 50                	push   $0x50
  jmp alltraps
80108aa5:	e9 0a f7 ff ff       	jmp    801081b4 <alltraps>

80108aaa <vector81>:
.globl vector81
vector81:
  pushl $0
80108aaa:	6a 00                	push   $0x0
  pushl $81
80108aac:	6a 51                	push   $0x51
  jmp alltraps
80108aae:	e9 01 f7 ff ff       	jmp    801081b4 <alltraps>

80108ab3 <vector82>:
.globl vector82
vector82:
  pushl $0
80108ab3:	6a 00                	push   $0x0
  pushl $82
80108ab5:	6a 52                	push   $0x52
  jmp alltraps
80108ab7:	e9 f8 f6 ff ff       	jmp    801081b4 <alltraps>

80108abc <vector83>:
.globl vector83
vector83:
  pushl $0
80108abc:	6a 00                	push   $0x0
  pushl $83
80108abe:	6a 53                	push   $0x53
  jmp alltraps
80108ac0:	e9 ef f6 ff ff       	jmp    801081b4 <alltraps>

80108ac5 <vector84>:
.globl vector84
vector84:
  pushl $0
80108ac5:	6a 00                	push   $0x0
  pushl $84
80108ac7:	6a 54                	push   $0x54
  jmp alltraps
80108ac9:	e9 e6 f6 ff ff       	jmp    801081b4 <alltraps>

80108ace <vector85>:
.globl vector85
vector85:
  pushl $0
80108ace:	6a 00                	push   $0x0
  pushl $85
80108ad0:	6a 55                	push   $0x55
  jmp alltraps
80108ad2:	e9 dd f6 ff ff       	jmp    801081b4 <alltraps>

80108ad7 <vector86>:
.globl vector86
vector86:
  pushl $0
80108ad7:	6a 00                	push   $0x0
  pushl $86
80108ad9:	6a 56                	push   $0x56
  jmp alltraps
80108adb:	e9 d4 f6 ff ff       	jmp    801081b4 <alltraps>

80108ae0 <vector87>:
.globl vector87
vector87:
  pushl $0
80108ae0:	6a 00                	push   $0x0
  pushl $87
80108ae2:	6a 57                	push   $0x57
  jmp alltraps
80108ae4:	e9 cb f6 ff ff       	jmp    801081b4 <alltraps>

80108ae9 <vector88>:
.globl vector88
vector88:
  pushl $0
80108ae9:	6a 00                	push   $0x0
  pushl $88
80108aeb:	6a 58                	push   $0x58
  jmp alltraps
80108aed:	e9 c2 f6 ff ff       	jmp    801081b4 <alltraps>

80108af2 <vector89>:
.globl vector89
vector89:
  pushl $0
80108af2:	6a 00                	push   $0x0
  pushl $89
80108af4:	6a 59                	push   $0x59
  jmp alltraps
80108af6:	e9 b9 f6 ff ff       	jmp    801081b4 <alltraps>

80108afb <vector90>:
.globl vector90
vector90:
  pushl $0
80108afb:	6a 00                	push   $0x0
  pushl $90
80108afd:	6a 5a                	push   $0x5a
  jmp alltraps
80108aff:	e9 b0 f6 ff ff       	jmp    801081b4 <alltraps>

80108b04 <vector91>:
.globl vector91
vector91:
  pushl $0
80108b04:	6a 00                	push   $0x0
  pushl $91
80108b06:	6a 5b                	push   $0x5b
  jmp alltraps
80108b08:	e9 a7 f6 ff ff       	jmp    801081b4 <alltraps>

80108b0d <vector92>:
.globl vector92
vector92:
  pushl $0
80108b0d:	6a 00                	push   $0x0
  pushl $92
80108b0f:	6a 5c                	push   $0x5c
  jmp alltraps
80108b11:	e9 9e f6 ff ff       	jmp    801081b4 <alltraps>

80108b16 <vector93>:
.globl vector93
vector93:
  pushl $0
80108b16:	6a 00                	push   $0x0
  pushl $93
80108b18:	6a 5d                	push   $0x5d
  jmp alltraps
80108b1a:	e9 95 f6 ff ff       	jmp    801081b4 <alltraps>

80108b1f <vector94>:
.globl vector94
vector94:
  pushl $0
80108b1f:	6a 00                	push   $0x0
  pushl $94
80108b21:	6a 5e                	push   $0x5e
  jmp alltraps
80108b23:	e9 8c f6 ff ff       	jmp    801081b4 <alltraps>

80108b28 <vector95>:
.globl vector95
vector95:
  pushl $0
80108b28:	6a 00                	push   $0x0
  pushl $95
80108b2a:	6a 5f                	push   $0x5f
  jmp alltraps
80108b2c:	e9 83 f6 ff ff       	jmp    801081b4 <alltraps>

80108b31 <vector96>:
.globl vector96
vector96:
  pushl $0
80108b31:	6a 00                	push   $0x0
  pushl $96
80108b33:	6a 60                	push   $0x60
  jmp alltraps
80108b35:	e9 7a f6 ff ff       	jmp    801081b4 <alltraps>

80108b3a <vector97>:
.globl vector97
vector97:
  pushl $0
80108b3a:	6a 00                	push   $0x0
  pushl $97
80108b3c:	6a 61                	push   $0x61
  jmp alltraps
80108b3e:	e9 71 f6 ff ff       	jmp    801081b4 <alltraps>

80108b43 <vector98>:
.globl vector98
vector98:
  pushl $0
80108b43:	6a 00                	push   $0x0
  pushl $98
80108b45:	6a 62                	push   $0x62
  jmp alltraps
80108b47:	e9 68 f6 ff ff       	jmp    801081b4 <alltraps>

80108b4c <vector99>:
.globl vector99
vector99:
  pushl $0
80108b4c:	6a 00                	push   $0x0
  pushl $99
80108b4e:	6a 63                	push   $0x63
  jmp alltraps
80108b50:	e9 5f f6 ff ff       	jmp    801081b4 <alltraps>

80108b55 <vector100>:
.globl vector100
vector100:
  pushl $0
80108b55:	6a 00                	push   $0x0
  pushl $100
80108b57:	6a 64                	push   $0x64
  jmp alltraps
80108b59:	e9 56 f6 ff ff       	jmp    801081b4 <alltraps>

80108b5e <vector101>:
.globl vector101
vector101:
  pushl $0
80108b5e:	6a 00                	push   $0x0
  pushl $101
80108b60:	6a 65                	push   $0x65
  jmp alltraps
80108b62:	e9 4d f6 ff ff       	jmp    801081b4 <alltraps>

80108b67 <vector102>:
.globl vector102
vector102:
  pushl $0
80108b67:	6a 00                	push   $0x0
  pushl $102
80108b69:	6a 66                	push   $0x66
  jmp alltraps
80108b6b:	e9 44 f6 ff ff       	jmp    801081b4 <alltraps>

80108b70 <vector103>:
.globl vector103
vector103:
  pushl $0
80108b70:	6a 00                	push   $0x0
  pushl $103
80108b72:	6a 67                	push   $0x67
  jmp alltraps
80108b74:	e9 3b f6 ff ff       	jmp    801081b4 <alltraps>

80108b79 <vector104>:
.globl vector104
vector104:
  pushl $0
80108b79:	6a 00                	push   $0x0
  pushl $104
80108b7b:	6a 68                	push   $0x68
  jmp alltraps
80108b7d:	e9 32 f6 ff ff       	jmp    801081b4 <alltraps>

80108b82 <vector105>:
.globl vector105
vector105:
  pushl $0
80108b82:	6a 00                	push   $0x0
  pushl $105
80108b84:	6a 69                	push   $0x69
  jmp alltraps
80108b86:	e9 29 f6 ff ff       	jmp    801081b4 <alltraps>

80108b8b <vector106>:
.globl vector106
vector106:
  pushl $0
80108b8b:	6a 00                	push   $0x0
  pushl $106
80108b8d:	6a 6a                	push   $0x6a
  jmp alltraps
80108b8f:	e9 20 f6 ff ff       	jmp    801081b4 <alltraps>

80108b94 <vector107>:
.globl vector107
vector107:
  pushl $0
80108b94:	6a 00                	push   $0x0
  pushl $107
80108b96:	6a 6b                	push   $0x6b
  jmp alltraps
80108b98:	e9 17 f6 ff ff       	jmp    801081b4 <alltraps>

80108b9d <vector108>:
.globl vector108
vector108:
  pushl $0
80108b9d:	6a 00                	push   $0x0
  pushl $108
80108b9f:	6a 6c                	push   $0x6c
  jmp alltraps
80108ba1:	e9 0e f6 ff ff       	jmp    801081b4 <alltraps>

80108ba6 <vector109>:
.globl vector109
vector109:
  pushl $0
80108ba6:	6a 00                	push   $0x0
  pushl $109
80108ba8:	6a 6d                	push   $0x6d
  jmp alltraps
80108baa:	e9 05 f6 ff ff       	jmp    801081b4 <alltraps>

80108baf <vector110>:
.globl vector110
vector110:
  pushl $0
80108baf:	6a 00                	push   $0x0
  pushl $110
80108bb1:	6a 6e                	push   $0x6e
  jmp alltraps
80108bb3:	e9 fc f5 ff ff       	jmp    801081b4 <alltraps>

80108bb8 <vector111>:
.globl vector111
vector111:
  pushl $0
80108bb8:	6a 00                	push   $0x0
  pushl $111
80108bba:	6a 6f                	push   $0x6f
  jmp alltraps
80108bbc:	e9 f3 f5 ff ff       	jmp    801081b4 <alltraps>

80108bc1 <vector112>:
.globl vector112
vector112:
  pushl $0
80108bc1:	6a 00                	push   $0x0
  pushl $112
80108bc3:	6a 70                	push   $0x70
  jmp alltraps
80108bc5:	e9 ea f5 ff ff       	jmp    801081b4 <alltraps>

80108bca <vector113>:
.globl vector113
vector113:
  pushl $0
80108bca:	6a 00                	push   $0x0
  pushl $113
80108bcc:	6a 71                	push   $0x71
  jmp alltraps
80108bce:	e9 e1 f5 ff ff       	jmp    801081b4 <alltraps>

80108bd3 <vector114>:
.globl vector114
vector114:
  pushl $0
80108bd3:	6a 00                	push   $0x0
  pushl $114
80108bd5:	6a 72                	push   $0x72
  jmp alltraps
80108bd7:	e9 d8 f5 ff ff       	jmp    801081b4 <alltraps>

80108bdc <vector115>:
.globl vector115
vector115:
  pushl $0
80108bdc:	6a 00                	push   $0x0
  pushl $115
80108bde:	6a 73                	push   $0x73
  jmp alltraps
80108be0:	e9 cf f5 ff ff       	jmp    801081b4 <alltraps>

80108be5 <vector116>:
.globl vector116
vector116:
  pushl $0
80108be5:	6a 00                	push   $0x0
  pushl $116
80108be7:	6a 74                	push   $0x74
  jmp alltraps
80108be9:	e9 c6 f5 ff ff       	jmp    801081b4 <alltraps>

80108bee <vector117>:
.globl vector117
vector117:
  pushl $0
80108bee:	6a 00                	push   $0x0
  pushl $117
80108bf0:	6a 75                	push   $0x75
  jmp alltraps
80108bf2:	e9 bd f5 ff ff       	jmp    801081b4 <alltraps>

80108bf7 <vector118>:
.globl vector118
vector118:
  pushl $0
80108bf7:	6a 00                	push   $0x0
  pushl $118
80108bf9:	6a 76                	push   $0x76
  jmp alltraps
80108bfb:	e9 b4 f5 ff ff       	jmp    801081b4 <alltraps>

80108c00 <vector119>:
.globl vector119
vector119:
  pushl $0
80108c00:	6a 00                	push   $0x0
  pushl $119
80108c02:	6a 77                	push   $0x77
  jmp alltraps
80108c04:	e9 ab f5 ff ff       	jmp    801081b4 <alltraps>

80108c09 <vector120>:
.globl vector120
vector120:
  pushl $0
80108c09:	6a 00                	push   $0x0
  pushl $120
80108c0b:	6a 78                	push   $0x78
  jmp alltraps
80108c0d:	e9 a2 f5 ff ff       	jmp    801081b4 <alltraps>

80108c12 <vector121>:
.globl vector121
vector121:
  pushl $0
80108c12:	6a 00                	push   $0x0
  pushl $121
80108c14:	6a 79                	push   $0x79
  jmp alltraps
80108c16:	e9 99 f5 ff ff       	jmp    801081b4 <alltraps>

80108c1b <vector122>:
.globl vector122
vector122:
  pushl $0
80108c1b:	6a 00                	push   $0x0
  pushl $122
80108c1d:	6a 7a                	push   $0x7a
  jmp alltraps
80108c1f:	e9 90 f5 ff ff       	jmp    801081b4 <alltraps>

80108c24 <vector123>:
.globl vector123
vector123:
  pushl $0
80108c24:	6a 00                	push   $0x0
  pushl $123
80108c26:	6a 7b                	push   $0x7b
  jmp alltraps
80108c28:	e9 87 f5 ff ff       	jmp    801081b4 <alltraps>

80108c2d <vector124>:
.globl vector124
vector124:
  pushl $0
80108c2d:	6a 00                	push   $0x0
  pushl $124
80108c2f:	6a 7c                	push   $0x7c
  jmp alltraps
80108c31:	e9 7e f5 ff ff       	jmp    801081b4 <alltraps>

80108c36 <vector125>:
.globl vector125
vector125:
  pushl $0
80108c36:	6a 00                	push   $0x0
  pushl $125
80108c38:	6a 7d                	push   $0x7d
  jmp alltraps
80108c3a:	e9 75 f5 ff ff       	jmp    801081b4 <alltraps>

80108c3f <vector126>:
.globl vector126
vector126:
  pushl $0
80108c3f:	6a 00                	push   $0x0
  pushl $126
80108c41:	6a 7e                	push   $0x7e
  jmp alltraps
80108c43:	e9 6c f5 ff ff       	jmp    801081b4 <alltraps>

80108c48 <vector127>:
.globl vector127
vector127:
  pushl $0
80108c48:	6a 00                	push   $0x0
  pushl $127
80108c4a:	6a 7f                	push   $0x7f
  jmp alltraps
80108c4c:	e9 63 f5 ff ff       	jmp    801081b4 <alltraps>

80108c51 <vector128>:
.globl vector128
vector128:
  pushl $0
80108c51:	6a 00                	push   $0x0
  pushl $128
80108c53:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80108c58:	e9 57 f5 ff ff       	jmp    801081b4 <alltraps>

80108c5d <vector129>:
.globl vector129
vector129:
  pushl $0
80108c5d:	6a 00                	push   $0x0
  pushl $129
80108c5f:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80108c64:	e9 4b f5 ff ff       	jmp    801081b4 <alltraps>

80108c69 <vector130>:
.globl vector130
vector130:
  pushl $0
80108c69:	6a 00                	push   $0x0
  pushl $130
80108c6b:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80108c70:	e9 3f f5 ff ff       	jmp    801081b4 <alltraps>

80108c75 <vector131>:
.globl vector131
vector131:
  pushl $0
80108c75:	6a 00                	push   $0x0
  pushl $131
80108c77:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80108c7c:	e9 33 f5 ff ff       	jmp    801081b4 <alltraps>

80108c81 <vector132>:
.globl vector132
vector132:
  pushl $0
80108c81:	6a 00                	push   $0x0
  pushl $132
80108c83:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80108c88:	e9 27 f5 ff ff       	jmp    801081b4 <alltraps>

80108c8d <vector133>:
.globl vector133
vector133:
  pushl $0
80108c8d:	6a 00                	push   $0x0
  pushl $133
80108c8f:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80108c94:	e9 1b f5 ff ff       	jmp    801081b4 <alltraps>

80108c99 <vector134>:
.globl vector134
vector134:
  pushl $0
80108c99:	6a 00                	push   $0x0
  pushl $134
80108c9b:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80108ca0:	e9 0f f5 ff ff       	jmp    801081b4 <alltraps>

80108ca5 <vector135>:
.globl vector135
vector135:
  pushl $0
80108ca5:	6a 00                	push   $0x0
  pushl $135
80108ca7:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80108cac:	e9 03 f5 ff ff       	jmp    801081b4 <alltraps>

80108cb1 <vector136>:
.globl vector136
vector136:
  pushl $0
80108cb1:	6a 00                	push   $0x0
  pushl $136
80108cb3:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80108cb8:	e9 f7 f4 ff ff       	jmp    801081b4 <alltraps>

80108cbd <vector137>:
.globl vector137
vector137:
  pushl $0
80108cbd:	6a 00                	push   $0x0
  pushl $137
80108cbf:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80108cc4:	e9 eb f4 ff ff       	jmp    801081b4 <alltraps>

80108cc9 <vector138>:
.globl vector138
vector138:
  pushl $0
80108cc9:	6a 00                	push   $0x0
  pushl $138
80108ccb:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80108cd0:	e9 df f4 ff ff       	jmp    801081b4 <alltraps>

80108cd5 <vector139>:
.globl vector139
vector139:
  pushl $0
80108cd5:	6a 00                	push   $0x0
  pushl $139
80108cd7:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80108cdc:	e9 d3 f4 ff ff       	jmp    801081b4 <alltraps>

80108ce1 <vector140>:
.globl vector140
vector140:
  pushl $0
80108ce1:	6a 00                	push   $0x0
  pushl $140
80108ce3:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80108ce8:	e9 c7 f4 ff ff       	jmp    801081b4 <alltraps>

80108ced <vector141>:
.globl vector141
vector141:
  pushl $0
80108ced:	6a 00                	push   $0x0
  pushl $141
80108cef:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80108cf4:	e9 bb f4 ff ff       	jmp    801081b4 <alltraps>

80108cf9 <vector142>:
.globl vector142
vector142:
  pushl $0
80108cf9:	6a 00                	push   $0x0
  pushl $142
80108cfb:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80108d00:	e9 af f4 ff ff       	jmp    801081b4 <alltraps>

80108d05 <vector143>:
.globl vector143
vector143:
  pushl $0
80108d05:	6a 00                	push   $0x0
  pushl $143
80108d07:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80108d0c:	e9 a3 f4 ff ff       	jmp    801081b4 <alltraps>

80108d11 <vector144>:
.globl vector144
vector144:
  pushl $0
80108d11:	6a 00                	push   $0x0
  pushl $144
80108d13:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80108d18:	e9 97 f4 ff ff       	jmp    801081b4 <alltraps>

80108d1d <vector145>:
.globl vector145
vector145:
  pushl $0
80108d1d:	6a 00                	push   $0x0
  pushl $145
80108d1f:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80108d24:	e9 8b f4 ff ff       	jmp    801081b4 <alltraps>

80108d29 <vector146>:
.globl vector146
vector146:
  pushl $0
80108d29:	6a 00                	push   $0x0
  pushl $146
80108d2b:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80108d30:	e9 7f f4 ff ff       	jmp    801081b4 <alltraps>

80108d35 <vector147>:
.globl vector147
vector147:
  pushl $0
80108d35:	6a 00                	push   $0x0
  pushl $147
80108d37:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80108d3c:	e9 73 f4 ff ff       	jmp    801081b4 <alltraps>

80108d41 <vector148>:
.globl vector148
vector148:
  pushl $0
80108d41:	6a 00                	push   $0x0
  pushl $148
80108d43:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80108d48:	e9 67 f4 ff ff       	jmp    801081b4 <alltraps>

80108d4d <vector149>:
.globl vector149
vector149:
  pushl $0
80108d4d:	6a 00                	push   $0x0
  pushl $149
80108d4f:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80108d54:	e9 5b f4 ff ff       	jmp    801081b4 <alltraps>

80108d59 <vector150>:
.globl vector150
vector150:
  pushl $0
80108d59:	6a 00                	push   $0x0
  pushl $150
80108d5b:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80108d60:	e9 4f f4 ff ff       	jmp    801081b4 <alltraps>

80108d65 <vector151>:
.globl vector151
vector151:
  pushl $0
80108d65:	6a 00                	push   $0x0
  pushl $151
80108d67:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80108d6c:	e9 43 f4 ff ff       	jmp    801081b4 <alltraps>

80108d71 <vector152>:
.globl vector152
vector152:
  pushl $0
80108d71:	6a 00                	push   $0x0
  pushl $152
80108d73:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80108d78:	e9 37 f4 ff ff       	jmp    801081b4 <alltraps>

80108d7d <vector153>:
.globl vector153
vector153:
  pushl $0
80108d7d:	6a 00                	push   $0x0
  pushl $153
80108d7f:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80108d84:	e9 2b f4 ff ff       	jmp    801081b4 <alltraps>

80108d89 <vector154>:
.globl vector154
vector154:
  pushl $0
80108d89:	6a 00                	push   $0x0
  pushl $154
80108d8b:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80108d90:	e9 1f f4 ff ff       	jmp    801081b4 <alltraps>

80108d95 <vector155>:
.globl vector155
vector155:
  pushl $0
80108d95:	6a 00                	push   $0x0
  pushl $155
80108d97:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80108d9c:	e9 13 f4 ff ff       	jmp    801081b4 <alltraps>

80108da1 <vector156>:
.globl vector156
vector156:
  pushl $0
80108da1:	6a 00                	push   $0x0
  pushl $156
80108da3:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80108da8:	e9 07 f4 ff ff       	jmp    801081b4 <alltraps>

80108dad <vector157>:
.globl vector157
vector157:
  pushl $0
80108dad:	6a 00                	push   $0x0
  pushl $157
80108daf:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80108db4:	e9 fb f3 ff ff       	jmp    801081b4 <alltraps>

80108db9 <vector158>:
.globl vector158
vector158:
  pushl $0
80108db9:	6a 00                	push   $0x0
  pushl $158
80108dbb:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80108dc0:	e9 ef f3 ff ff       	jmp    801081b4 <alltraps>

80108dc5 <vector159>:
.globl vector159
vector159:
  pushl $0
80108dc5:	6a 00                	push   $0x0
  pushl $159
80108dc7:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80108dcc:	e9 e3 f3 ff ff       	jmp    801081b4 <alltraps>

80108dd1 <vector160>:
.globl vector160
vector160:
  pushl $0
80108dd1:	6a 00                	push   $0x0
  pushl $160
80108dd3:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80108dd8:	e9 d7 f3 ff ff       	jmp    801081b4 <alltraps>

80108ddd <vector161>:
.globl vector161
vector161:
  pushl $0
80108ddd:	6a 00                	push   $0x0
  pushl $161
80108ddf:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80108de4:	e9 cb f3 ff ff       	jmp    801081b4 <alltraps>

80108de9 <vector162>:
.globl vector162
vector162:
  pushl $0
80108de9:	6a 00                	push   $0x0
  pushl $162
80108deb:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80108df0:	e9 bf f3 ff ff       	jmp    801081b4 <alltraps>

80108df5 <vector163>:
.globl vector163
vector163:
  pushl $0
80108df5:	6a 00                	push   $0x0
  pushl $163
80108df7:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80108dfc:	e9 b3 f3 ff ff       	jmp    801081b4 <alltraps>

80108e01 <vector164>:
.globl vector164
vector164:
  pushl $0
80108e01:	6a 00                	push   $0x0
  pushl $164
80108e03:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80108e08:	e9 a7 f3 ff ff       	jmp    801081b4 <alltraps>

80108e0d <vector165>:
.globl vector165
vector165:
  pushl $0
80108e0d:	6a 00                	push   $0x0
  pushl $165
80108e0f:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80108e14:	e9 9b f3 ff ff       	jmp    801081b4 <alltraps>

80108e19 <vector166>:
.globl vector166
vector166:
  pushl $0
80108e19:	6a 00                	push   $0x0
  pushl $166
80108e1b:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80108e20:	e9 8f f3 ff ff       	jmp    801081b4 <alltraps>

80108e25 <vector167>:
.globl vector167
vector167:
  pushl $0
80108e25:	6a 00                	push   $0x0
  pushl $167
80108e27:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80108e2c:	e9 83 f3 ff ff       	jmp    801081b4 <alltraps>

80108e31 <vector168>:
.globl vector168
vector168:
  pushl $0
80108e31:	6a 00                	push   $0x0
  pushl $168
80108e33:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80108e38:	e9 77 f3 ff ff       	jmp    801081b4 <alltraps>

80108e3d <vector169>:
.globl vector169
vector169:
  pushl $0
80108e3d:	6a 00                	push   $0x0
  pushl $169
80108e3f:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80108e44:	e9 6b f3 ff ff       	jmp    801081b4 <alltraps>

80108e49 <vector170>:
.globl vector170
vector170:
  pushl $0
80108e49:	6a 00                	push   $0x0
  pushl $170
80108e4b:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80108e50:	e9 5f f3 ff ff       	jmp    801081b4 <alltraps>

80108e55 <vector171>:
.globl vector171
vector171:
  pushl $0
80108e55:	6a 00                	push   $0x0
  pushl $171
80108e57:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80108e5c:	e9 53 f3 ff ff       	jmp    801081b4 <alltraps>

80108e61 <vector172>:
.globl vector172
vector172:
  pushl $0
80108e61:	6a 00                	push   $0x0
  pushl $172
80108e63:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80108e68:	e9 47 f3 ff ff       	jmp    801081b4 <alltraps>

80108e6d <vector173>:
.globl vector173
vector173:
  pushl $0
80108e6d:	6a 00                	push   $0x0
  pushl $173
80108e6f:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80108e74:	e9 3b f3 ff ff       	jmp    801081b4 <alltraps>

80108e79 <vector174>:
.globl vector174
vector174:
  pushl $0
80108e79:	6a 00                	push   $0x0
  pushl $174
80108e7b:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80108e80:	e9 2f f3 ff ff       	jmp    801081b4 <alltraps>

80108e85 <vector175>:
.globl vector175
vector175:
  pushl $0
80108e85:	6a 00                	push   $0x0
  pushl $175
80108e87:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80108e8c:	e9 23 f3 ff ff       	jmp    801081b4 <alltraps>

80108e91 <vector176>:
.globl vector176
vector176:
  pushl $0
80108e91:	6a 00                	push   $0x0
  pushl $176
80108e93:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80108e98:	e9 17 f3 ff ff       	jmp    801081b4 <alltraps>

80108e9d <vector177>:
.globl vector177
vector177:
  pushl $0
80108e9d:	6a 00                	push   $0x0
  pushl $177
80108e9f:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80108ea4:	e9 0b f3 ff ff       	jmp    801081b4 <alltraps>

80108ea9 <vector178>:
.globl vector178
vector178:
  pushl $0
80108ea9:	6a 00                	push   $0x0
  pushl $178
80108eab:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80108eb0:	e9 ff f2 ff ff       	jmp    801081b4 <alltraps>

80108eb5 <vector179>:
.globl vector179
vector179:
  pushl $0
80108eb5:	6a 00                	push   $0x0
  pushl $179
80108eb7:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80108ebc:	e9 f3 f2 ff ff       	jmp    801081b4 <alltraps>

80108ec1 <vector180>:
.globl vector180
vector180:
  pushl $0
80108ec1:	6a 00                	push   $0x0
  pushl $180
80108ec3:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80108ec8:	e9 e7 f2 ff ff       	jmp    801081b4 <alltraps>

80108ecd <vector181>:
.globl vector181
vector181:
  pushl $0
80108ecd:	6a 00                	push   $0x0
  pushl $181
80108ecf:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80108ed4:	e9 db f2 ff ff       	jmp    801081b4 <alltraps>

80108ed9 <vector182>:
.globl vector182
vector182:
  pushl $0
80108ed9:	6a 00                	push   $0x0
  pushl $182
80108edb:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80108ee0:	e9 cf f2 ff ff       	jmp    801081b4 <alltraps>

80108ee5 <vector183>:
.globl vector183
vector183:
  pushl $0
80108ee5:	6a 00                	push   $0x0
  pushl $183
80108ee7:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80108eec:	e9 c3 f2 ff ff       	jmp    801081b4 <alltraps>

80108ef1 <vector184>:
.globl vector184
vector184:
  pushl $0
80108ef1:	6a 00                	push   $0x0
  pushl $184
80108ef3:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80108ef8:	e9 b7 f2 ff ff       	jmp    801081b4 <alltraps>

80108efd <vector185>:
.globl vector185
vector185:
  pushl $0
80108efd:	6a 00                	push   $0x0
  pushl $185
80108eff:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80108f04:	e9 ab f2 ff ff       	jmp    801081b4 <alltraps>

80108f09 <vector186>:
.globl vector186
vector186:
  pushl $0
80108f09:	6a 00                	push   $0x0
  pushl $186
80108f0b:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80108f10:	e9 9f f2 ff ff       	jmp    801081b4 <alltraps>

80108f15 <vector187>:
.globl vector187
vector187:
  pushl $0
80108f15:	6a 00                	push   $0x0
  pushl $187
80108f17:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80108f1c:	e9 93 f2 ff ff       	jmp    801081b4 <alltraps>

80108f21 <vector188>:
.globl vector188
vector188:
  pushl $0
80108f21:	6a 00                	push   $0x0
  pushl $188
80108f23:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80108f28:	e9 87 f2 ff ff       	jmp    801081b4 <alltraps>

80108f2d <vector189>:
.globl vector189
vector189:
  pushl $0
80108f2d:	6a 00                	push   $0x0
  pushl $189
80108f2f:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80108f34:	e9 7b f2 ff ff       	jmp    801081b4 <alltraps>

80108f39 <vector190>:
.globl vector190
vector190:
  pushl $0
80108f39:	6a 00                	push   $0x0
  pushl $190
80108f3b:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80108f40:	e9 6f f2 ff ff       	jmp    801081b4 <alltraps>

80108f45 <vector191>:
.globl vector191
vector191:
  pushl $0
80108f45:	6a 00                	push   $0x0
  pushl $191
80108f47:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80108f4c:	e9 63 f2 ff ff       	jmp    801081b4 <alltraps>

80108f51 <vector192>:
.globl vector192
vector192:
  pushl $0
80108f51:	6a 00                	push   $0x0
  pushl $192
80108f53:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80108f58:	e9 57 f2 ff ff       	jmp    801081b4 <alltraps>

80108f5d <vector193>:
.globl vector193
vector193:
  pushl $0
80108f5d:	6a 00                	push   $0x0
  pushl $193
80108f5f:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80108f64:	e9 4b f2 ff ff       	jmp    801081b4 <alltraps>

80108f69 <vector194>:
.globl vector194
vector194:
  pushl $0
80108f69:	6a 00                	push   $0x0
  pushl $194
80108f6b:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80108f70:	e9 3f f2 ff ff       	jmp    801081b4 <alltraps>

80108f75 <vector195>:
.globl vector195
vector195:
  pushl $0
80108f75:	6a 00                	push   $0x0
  pushl $195
80108f77:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80108f7c:	e9 33 f2 ff ff       	jmp    801081b4 <alltraps>

80108f81 <vector196>:
.globl vector196
vector196:
  pushl $0
80108f81:	6a 00                	push   $0x0
  pushl $196
80108f83:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80108f88:	e9 27 f2 ff ff       	jmp    801081b4 <alltraps>

80108f8d <vector197>:
.globl vector197
vector197:
  pushl $0
80108f8d:	6a 00                	push   $0x0
  pushl $197
80108f8f:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80108f94:	e9 1b f2 ff ff       	jmp    801081b4 <alltraps>

80108f99 <vector198>:
.globl vector198
vector198:
  pushl $0
80108f99:	6a 00                	push   $0x0
  pushl $198
80108f9b:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80108fa0:	e9 0f f2 ff ff       	jmp    801081b4 <alltraps>

80108fa5 <vector199>:
.globl vector199
vector199:
  pushl $0
80108fa5:	6a 00                	push   $0x0
  pushl $199
80108fa7:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80108fac:	e9 03 f2 ff ff       	jmp    801081b4 <alltraps>

80108fb1 <vector200>:
.globl vector200
vector200:
  pushl $0
80108fb1:	6a 00                	push   $0x0
  pushl $200
80108fb3:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80108fb8:	e9 f7 f1 ff ff       	jmp    801081b4 <alltraps>

80108fbd <vector201>:
.globl vector201
vector201:
  pushl $0
80108fbd:	6a 00                	push   $0x0
  pushl $201
80108fbf:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80108fc4:	e9 eb f1 ff ff       	jmp    801081b4 <alltraps>

80108fc9 <vector202>:
.globl vector202
vector202:
  pushl $0
80108fc9:	6a 00                	push   $0x0
  pushl $202
80108fcb:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80108fd0:	e9 df f1 ff ff       	jmp    801081b4 <alltraps>

80108fd5 <vector203>:
.globl vector203
vector203:
  pushl $0
80108fd5:	6a 00                	push   $0x0
  pushl $203
80108fd7:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80108fdc:	e9 d3 f1 ff ff       	jmp    801081b4 <alltraps>

80108fe1 <vector204>:
.globl vector204
vector204:
  pushl $0
80108fe1:	6a 00                	push   $0x0
  pushl $204
80108fe3:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80108fe8:	e9 c7 f1 ff ff       	jmp    801081b4 <alltraps>

80108fed <vector205>:
.globl vector205
vector205:
  pushl $0
80108fed:	6a 00                	push   $0x0
  pushl $205
80108fef:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80108ff4:	e9 bb f1 ff ff       	jmp    801081b4 <alltraps>

80108ff9 <vector206>:
.globl vector206
vector206:
  pushl $0
80108ff9:	6a 00                	push   $0x0
  pushl $206
80108ffb:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80109000:	e9 af f1 ff ff       	jmp    801081b4 <alltraps>

80109005 <vector207>:
.globl vector207
vector207:
  pushl $0
80109005:	6a 00                	push   $0x0
  pushl $207
80109007:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
8010900c:	e9 a3 f1 ff ff       	jmp    801081b4 <alltraps>

80109011 <vector208>:
.globl vector208
vector208:
  pushl $0
80109011:	6a 00                	push   $0x0
  pushl $208
80109013:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80109018:	e9 97 f1 ff ff       	jmp    801081b4 <alltraps>

8010901d <vector209>:
.globl vector209
vector209:
  pushl $0
8010901d:	6a 00                	push   $0x0
  pushl $209
8010901f:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80109024:	e9 8b f1 ff ff       	jmp    801081b4 <alltraps>

80109029 <vector210>:
.globl vector210
vector210:
  pushl $0
80109029:	6a 00                	push   $0x0
  pushl $210
8010902b:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80109030:	e9 7f f1 ff ff       	jmp    801081b4 <alltraps>

80109035 <vector211>:
.globl vector211
vector211:
  pushl $0
80109035:	6a 00                	push   $0x0
  pushl $211
80109037:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
8010903c:	e9 73 f1 ff ff       	jmp    801081b4 <alltraps>

80109041 <vector212>:
.globl vector212
vector212:
  pushl $0
80109041:	6a 00                	push   $0x0
  pushl $212
80109043:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80109048:	e9 67 f1 ff ff       	jmp    801081b4 <alltraps>

8010904d <vector213>:
.globl vector213
vector213:
  pushl $0
8010904d:	6a 00                	push   $0x0
  pushl $213
8010904f:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80109054:	e9 5b f1 ff ff       	jmp    801081b4 <alltraps>

80109059 <vector214>:
.globl vector214
vector214:
  pushl $0
80109059:	6a 00                	push   $0x0
  pushl $214
8010905b:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80109060:	e9 4f f1 ff ff       	jmp    801081b4 <alltraps>

80109065 <vector215>:
.globl vector215
vector215:
  pushl $0
80109065:	6a 00                	push   $0x0
  pushl $215
80109067:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
8010906c:	e9 43 f1 ff ff       	jmp    801081b4 <alltraps>

80109071 <vector216>:
.globl vector216
vector216:
  pushl $0
80109071:	6a 00                	push   $0x0
  pushl $216
80109073:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80109078:	e9 37 f1 ff ff       	jmp    801081b4 <alltraps>

8010907d <vector217>:
.globl vector217
vector217:
  pushl $0
8010907d:	6a 00                	push   $0x0
  pushl $217
8010907f:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80109084:	e9 2b f1 ff ff       	jmp    801081b4 <alltraps>

80109089 <vector218>:
.globl vector218
vector218:
  pushl $0
80109089:	6a 00                	push   $0x0
  pushl $218
8010908b:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80109090:	e9 1f f1 ff ff       	jmp    801081b4 <alltraps>

80109095 <vector219>:
.globl vector219
vector219:
  pushl $0
80109095:	6a 00                	push   $0x0
  pushl $219
80109097:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
8010909c:	e9 13 f1 ff ff       	jmp    801081b4 <alltraps>

801090a1 <vector220>:
.globl vector220
vector220:
  pushl $0
801090a1:	6a 00                	push   $0x0
  pushl $220
801090a3:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
801090a8:	e9 07 f1 ff ff       	jmp    801081b4 <alltraps>

801090ad <vector221>:
.globl vector221
vector221:
  pushl $0
801090ad:	6a 00                	push   $0x0
  pushl $221
801090af:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
801090b4:	e9 fb f0 ff ff       	jmp    801081b4 <alltraps>

801090b9 <vector222>:
.globl vector222
vector222:
  pushl $0
801090b9:	6a 00                	push   $0x0
  pushl $222
801090bb:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801090c0:	e9 ef f0 ff ff       	jmp    801081b4 <alltraps>

801090c5 <vector223>:
.globl vector223
vector223:
  pushl $0
801090c5:	6a 00                	push   $0x0
  pushl $223
801090c7:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801090cc:	e9 e3 f0 ff ff       	jmp    801081b4 <alltraps>

801090d1 <vector224>:
.globl vector224
vector224:
  pushl $0
801090d1:	6a 00                	push   $0x0
  pushl $224
801090d3:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801090d8:	e9 d7 f0 ff ff       	jmp    801081b4 <alltraps>

801090dd <vector225>:
.globl vector225
vector225:
  pushl $0
801090dd:	6a 00                	push   $0x0
  pushl $225
801090df:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801090e4:	e9 cb f0 ff ff       	jmp    801081b4 <alltraps>

801090e9 <vector226>:
.globl vector226
vector226:
  pushl $0
801090e9:	6a 00                	push   $0x0
  pushl $226
801090eb:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801090f0:	e9 bf f0 ff ff       	jmp    801081b4 <alltraps>

801090f5 <vector227>:
.globl vector227
vector227:
  pushl $0
801090f5:	6a 00                	push   $0x0
  pushl $227
801090f7:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801090fc:	e9 b3 f0 ff ff       	jmp    801081b4 <alltraps>

80109101 <vector228>:
.globl vector228
vector228:
  pushl $0
80109101:	6a 00                	push   $0x0
  pushl $228
80109103:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80109108:	e9 a7 f0 ff ff       	jmp    801081b4 <alltraps>

8010910d <vector229>:
.globl vector229
vector229:
  pushl $0
8010910d:	6a 00                	push   $0x0
  pushl $229
8010910f:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80109114:	e9 9b f0 ff ff       	jmp    801081b4 <alltraps>

80109119 <vector230>:
.globl vector230
vector230:
  pushl $0
80109119:	6a 00                	push   $0x0
  pushl $230
8010911b:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80109120:	e9 8f f0 ff ff       	jmp    801081b4 <alltraps>

80109125 <vector231>:
.globl vector231
vector231:
  pushl $0
80109125:	6a 00                	push   $0x0
  pushl $231
80109127:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
8010912c:	e9 83 f0 ff ff       	jmp    801081b4 <alltraps>

80109131 <vector232>:
.globl vector232
vector232:
  pushl $0
80109131:	6a 00                	push   $0x0
  pushl $232
80109133:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80109138:	e9 77 f0 ff ff       	jmp    801081b4 <alltraps>

8010913d <vector233>:
.globl vector233
vector233:
  pushl $0
8010913d:	6a 00                	push   $0x0
  pushl $233
8010913f:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80109144:	e9 6b f0 ff ff       	jmp    801081b4 <alltraps>

80109149 <vector234>:
.globl vector234
vector234:
  pushl $0
80109149:	6a 00                	push   $0x0
  pushl $234
8010914b:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80109150:	e9 5f f0 ff ff       	jmp    801081b4 <alltraps>

80109155 <vector235>:
.globl vector235
vector235:
  pushl $0
80109155:	6a 00                	push   $0x0
  pushl $235
80109157:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
8010915c:	e9 53 f0 ff ff       	jmp    801081b4 <alltraps>

80109161 <vector236>:
.globl vector236
vector236:
  pushl $0
80109161:	6a 00                	push   $0x0
  pushl $236
80109163:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80109168:	e9 47 f0 ff ff       	jmp    801081b4 <alltraps>

8010916d <vector237>:
.globl vector237
vector237:
  pushl $0
8010916d:	6a 00                	push   $0x0
  pushl $237
8010916f:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80109174:	e9 3b f0 ff ff       	jmp    801081b4 <alltraps>

80109179 <vector238>:
.globl vector238
vector238:
  pushl $0
80109179:	6a 00                	push   $0x0
  pushl $238
8010917b:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80109180:	e9 2f f0 ff ff       	jmp    801081b4 <alltraps>

80109185 <vector239>:
.globl vector239
vector239:
  pushl $0
80109185:	6a 00                	push   $0x0
  pushl $239
80109187:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
8010918c:	e9 23 f0 ff ff       	jmp    801081b4 <alltraps>

80109191 <vector240>:
.globl vector240
vector240:
  pushl $0
80109191:	6a 00                	push   $0x0
  pushl $240
80109193:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80109198:	e9 17 f0 ff ff       	jmp    801081b4 <alltraps>

8010919d <vector241>:
.globl vector241
vector241:
  pushl $0
8010919d:	6a 00                	push   $0x0
  pushl $241
8010919f:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
801091a4:	e9 0b f0 ff ff       	jmp    801081b4 <alltraps>

801091a9 <vector242>:
.globl vector242
vector242:
  pushl $0
801091a9:	6a 00                	push   $0x0
  pushl $242
801091ab:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
801091b0:	e9 ff ef ff ff       	jmp    801081b4 <alltraps>

801091b5 <vector243>:
.globl vector243
vector243:
  pushl $0
801091b5:	6a 00                	push   $0x0
  pushl $243
801091b7:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801091bc:	e9 f3 ef ff ff       	jmp    801081b4 <alltraps>

801091c1 <vector244>:
.globl vector244
vector244:
  pushl $0
801091c1:	6a 00                	push   $0x0
  pushl $244
801091c3:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801091c8:	e9 e7 ef ff ff       	jmp    801081b4 <alltraps>

801091cd <vector245>:
.globl vector245
vector245:
  pushl $0
801091cd:	6a 00                	push   $0x0
  pushl $245
801091cf:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801091d4:	e9 db ef ff ff       	jmp    801081b4 <alltraps>

801091d9 <vector246>:
.globl vector246
vector246:
  pushl $0
801091d9:	6a 00                	push   $0x0
  pushl $246
801091db:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801091e0:	e9 cf ef ff ff       	jmp    801081b4 <alltraps>

801091e5 <vector247>:
.globl vector247
vector247:
  pushl $0
801091e5:	6a 00                	push   $0x0
  pushl $247
801091e7:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801091ec:	e9 c3 ef ff ff       	jmp    801081b4 <alltraps>

801091f1 <vector248>:
.globl vector248
vector248:
  pushl $0
801091f1:	6a 00                	push   $0x0
  pushl $248
801091f3:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801091f8:	e9 b7 ef ff ff       	jmp    801081b4 <alltraps>

801091fd <vector249>:
.globl vector249
vector249:
  pushl $0
801091fd:	6a 00                	push   $0x0
  pushl $249
801091ff:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80109204:	e9 ab ef ff ff       	jmp    801081b4 <alltraps>

80109209 <vector250>:
.globl vector250
vector250:
  pushl $0
80109209:	6a 00                	push   $0x0
  pushl $250
8010920b:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80109210:	e9 9f ef ff ff       	jmp    801081b4 <alltraps>

80109215 <vector251>:
.globl vector251
vector251:
  pushl $0
80109215:	6a 00                	push   $0x0
  pushl $251
80109217:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
8010921c:	e9 93 ef ff ff       	jmp    801081b4 <alltraps>

80109221 <vector252>:
.globl vector252
vector252:
  pushl $0
80109221:	6a 00                	push   $0x0
  pushl $252
80109223:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80109228:	e9 87 ef ff ff       	jmp    801081b4 <alltraps>

8010922d <vector253>:
.globl vector253
vector253:
  pushl $0
8010922d:	6a 00                	push   $0x0
  pushl $253
8010922f:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80109234:	e9 7b ef ff ff       	jmp    801081b4 <alltraps>

80109239 <vector254>:
.globl vector254
vector254:
  pushl $0
80109239:	6a 00                	push   $0x0
  pushl $254
8010923b:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80109240:	e9 6f ef ff ff       	jmp    801081b4 <alltraps>

80109245 <vector255>:
.globl vector255
vector255:
  pushl $0
80109245:	6a 00                	push   $0x0
  pushl $255
80109247:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
8010924c:	e9 63 ef ff ff       	jmp    801081b4 <alltraps>

80109251 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80109251:	55                   	push   %ebp
80109252:	89 e5                	mov    %esp,%ebp
80109254:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80109257:	8b 45 0c             	mov    0xc(%ebp),%eax
8010925a:	83 e8 01             	sub    $0x1,%eax
8010925d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80109261:	8b 45 08             	mov    0x8(%ebp),%eax
80109264:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80109268:	8b 45 08             	mov    0x8(%ebp),%eax
8010926b:	c1 e8 10             	shr    $0x10,%eax
8010926e:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80109272:	8d 45 fa             	lea    -0x6(%ebp),%eax
80109275:	0f 01 10             	lgdtl  (%eax)
}
80109278:	90                   	nop
80109279:	c9                   	leave  
8010927a:	c3                   	ret    

8010927b <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
8010927b:	55                   	push   %ebp
8010927c:	89 e5                	mov    %esp,%ebp
8010927e:	83 ec 04             	sub    $0x4,%esp
80109281:	8b 45 08             	mov    0x8(%ebp),%eax
80109284:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80109288:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
8010928c:	0f 00 d8             	ltr    %ax
}
8010928f:	90                   	nop
80109290:	c9                   	leave  
80109291:	c3                   	ret    

80109292 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80109292:	55                   	push   %ebp
80109293:	89 e5                	mov    %esp,%ebp
80109295:	83 ec 04             	sub    $0x4,%esp
80109298:	8b 45 08             	mov    0x8(%ebp),%eax
8010929b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
8010929f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
801092a3:	8e e8                	mov    %eax,%gs
}
801092a5:	90                   	nop
801092a6:	c9                   	leave  
801092a7:	c3                   	ret    

801092a8 <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
801092a8:	55                   	push   %ebp
801092a9:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
801092ab:	8b 45 08             	mov    0x8(%ebp),%eax
801092ae:	0f 22 d8             	mov    %eax,%cr3
}
801092b1:	90                   	nop
801092b2:	5d                   	pop    %ebp
801092b3:	c3                   	ret    

801092b4 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801092b4:	55                   	push   %ebp
801092b5:	89 e5                	mov    %esp,%ebp
801092b7:	8b 45 08             	mov    0x8(%ebp),%eax
801092ba:	05 00 00 00 80       	add    $0x80000000,%eax
801092bf:	5d                   	pop    %ebp
801092c0:	c3                   	ret    

801092c1 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
801092c1:	55                   	push   %ebp
801092c2:	89 e5                	mov    %esp,%ebp
801092c4:	8b 45 08             	mov    0x8(%ebp),%eax
801092c7:	05 00 00 00 80       	add    $0x80000000,%eax
801092cc:	5d                   	pop    %ebp
801092cd:	c3                   	ret    

801092ce <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801092ce:	55                   	push   %ebp
801092cf:	89 e5                	mov    %esp,%ebp
801092d1:	53                   	push   %ebx
801092d2:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
801092d5:	e8 33 a0 ff ff       	call   8010330d <cpunum>
801092da:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801092e0:	05 a0 43 11 80       	add    $0x801143a0,%eax
801092e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801092e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092eb:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
801092f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092f4:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
801092fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801092fd:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80109301:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109304:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109308:	83 e2 f0             	and    $0xfffffff0,%edx
8010930b:	83 ca 0a             	or     $0xa,%edx
8010930e:	88 50 7d             	mov    %dl,0x7d(%eax)
80109311:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109314:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109318:	83 ca 10             	or     $0x10,%edx
8010931b:	88 50 7d             	mov    %dl,0x7d(%eax)
8010931e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109321:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109325:	83 e2 9f             	and    $0xffffff9f,%edx
80109328:	88 50 7d             	mov    %dl,0x7d(%eax)
8010932b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010932e:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80109332:	83 ca 80             	or     $0xffffff80,%edx
80109335:	88 50 7d             	mov    %dl,0x7d(%eax)
80109338:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010933b:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010933f:	83 ca 0f             	or     $0xf,%edx
80109342:	88 50 7e             	mov    %dl,0x7e(%eax)
80109345:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109348:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
8010934c:	83 e2 ef             	and    $0xffffffef,%edx
8010934f:	88 50 7e             	mov    %dl,0x7e(%eax)
80109352:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109355:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109359:	83 e2 df             	and    $0xffffffdf,%edx
8010935c:	88 50 7e             	mov    %dl,0x7e(%eax)
8010935f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109362:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109366:	83 ca 40             	or     $0x40,%edx
80109369:	88 50 7e             	mov    %dl,0x7e(%eax)
8010936c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010936f:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80109373:	83 ca 80             	or     $0xffffff80,%edx
80109376:	88 50 7e             	mov    %dl,0x7e(%eax)
80109379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010937c:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80109380:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109383:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
8010938a:	ff ff 
8010938c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010938f:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80109396:	00 00 
80109398:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010939b:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
801093a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093a5:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801093ac:	83 e2 f0             	and    $0xfffffff0,%edx
801093af:	83 ca 02             	or     $0x2,%edx
801093b2:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801093b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093bb:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801093c2:	83 ca 10             	or     $0x10,%edx
801093c5:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801093cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093ce:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801093d5:	83 e2 9f             	and    $0xffffff9f,%edx
801093d8:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801093de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093e1:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
801093e8:	83 ca 80             	or     $0xffffff80,%edx
801093eb:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
801093f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801093f4:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801093fb:	83 ca 0f             	or     $0xf,%edx
801093fe:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109404:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109407:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010940e:	83 e2 ef             	and    $0xffffffef,%edx
80109411:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109417:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010941a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109421:	83 e2 df             	and    $0xffffffdf,%edx
80109424:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010942a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010942d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109434:	83 ca 40             	or     $0x40,%edx
80109437:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010943d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109440:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80109447:	83 ca 80             	or     $0xffffff80,%edx
8010944a:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80109450:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109453:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010945a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010945d:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80109464:	ff ff 
80109466:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109469:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80109470:	00 00 
80109472:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109475:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
8010947c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010947f:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80109486:	83 e2 f0             	and    $0xfffffff0,%edx
80109489:	83 ca 0a             	or     $0xa,%edx
8010948c:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80109492:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109495:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010949c:	83 ca 10             	or     $0x10,%edx
8010949f:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801094a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094a8:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801094af:	83 ca 60             	or     $0x60,%edx
801094b2:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801094b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094bb:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801094c2:	83 ca 80             	or     $0xffffff80,%edx
801094c5:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
801094cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094ce:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801094d5:	83 ca 0f             	or     $0xf,%edx
801094d8:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801094de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094e1:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801094e8:	83 e2 ef             	and    $0xffffffef,%edx
801094eb:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
801094f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801094f4:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
801094fb:	83 e2 df             	and    $0xffffffdf,%edx
801094fe:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109504:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109507:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010950e:	83 ca 40             	or     $0x40,%edx
80109511:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80109517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010951a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80109521:	83 ca 80             	or     $0xffffff80,%edx
80109524:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010952a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010952d:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80109534:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109537:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
8010953e:	ff ff 
80109540:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109543:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
8010954a:	00 00 
8010954c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010954f:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80109556:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109559:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109560:	83 e2 f0             	and    $0xfffffff0,%edx
80109563:	83 ca 02             	or     $0x2,%edx
80109566:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010956c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010956f:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109576:	83 ca 10             	or     $0x10,%edx
80109579:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
8010957f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109582:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80109589:	83 ca 60             	or     $0x60,%edx
8010958c:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80109592:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109595:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010959c:	83 ca 80             	or     $0xffffff80,%edx
8010959f:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801095a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095a8:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801095af:	83 ca 0f             	or     $0xf,%edx
801095b2:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801095b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095bb:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801095c2:	83 e2 ef             	and    $0xffffffef,%edx
801095c5:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801095cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095ce:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801095d5:	83 e2 df             	and    $0xffffffdf,%edx
801095d8:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801095de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095e1:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801095e8:	83 ca 40             	or     $0x40,%edx
801095eb:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
801095f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801095f4:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
801095fb:	83 ca 80             	or     $0xffffff80,%edx
801095fe:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80109604:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109607:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
8010960e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109611:	05 b4 00 00 00       	add    $0xb4,%eax
80109616:	89 c3                	mov    %eax,%ebx
80109618:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010961b:	05 b4 00 00 00       	add    $0xb4,%eax
80109620:	c1 e8 10             	shr    $0x10,%eax
80109623:	89 c2                	mov    %eax,%edx
80109625:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109628:	05 b4 00 00 00       	add    $0xb4,%eax
8010962d:	c1 e8 18             	shr    $0x18,%eax
80109630:	89 c1                	mov    %eax,%ecx
80109632:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109635:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
8010963c:	00 00 
8010963e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109641:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80109648:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010964b:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80109651:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109654:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
8010965b:	83 e2 f0             	and    $0xfffffff0,%edx
8010965e:	83 ca 02             	or     $0x2,%edx
80109661:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80109667:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010966a:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109671:	83 ca 10             	or     $0x10,%edx
80109674:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010967a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010967d:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109684:	83 e2 9f             	and    $0xffffff9f,%edx
80109687:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
8010968d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109690:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80109697:	83 ca 80             	or     $0xffffff80,%edx
8010969a:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
801096a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096a3:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801096aa:	83 e2 f0             	and    $0xfffffff0,%edx
801096ad:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801096b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096b6:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801096bd:	83 e2 ef             	and    $0xffffffef,%edx
801096c0:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801096c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096c9:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801096d0:	83 e2 df             	and    $0xffffffdf,%edx
801096d3:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801096d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096dc:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801096e3:	83 ca 40             	or     $0x40,%edx
801096e6:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801096ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801096ef:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
801096f6:	83 ca 80             	or     $0xffffff80,%edx
801096f9:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
801096ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109702:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80109708:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010970b:	83 c0 70             	add    $0x70,%eax
8010970e:	83 ec 08             	sub    $0x8,%esp
80109711:	6a 38                	push   $0x38
80109713:	50                   	push   %eax
80109714:	e8 38 fb ff ff       	call   80109251 <lgdt>
80109719:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
8010971c:	83 ec 0c             	sub    $0xc,%esp
8010971f:	6a 18                	push   $0x18
80109721:	e8 6c fb ff ff       	call   80109292 <loadgs>
80109726:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80109729:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010972c:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80109732:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80109739:	00 00 00 00 
}
8010973d:	90                   	nop
8010973e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109741:	c9                   	leave  
80109742:	c3                   	ret    

80109743 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80109743:	55                   	push   %ebp
80109744:	89 e5                	mov    %esp,%ebp
80109746:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80109749:	8b 45 0c             	mov    0xc(%ebp),%eax
8010974c:	c1 e8 16             	shr    $0x16,%eax
8010974f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109756:	8b 45 08             	mov    0x8(%ebp),%eax
80109759:	01 d0                	add    %edx,%eax
8010975b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
8010975e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109761:	8b 00                	mov    (%eax),%eax
80109763:	83 e0 01             	and    $0x1,%eax
80109766:	85 c0                	test   %eax,%eax
80109768:	74 18                	je     80109782 <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
8010976a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010976d:	8b 00                	mov    (%eax),%eax
8010976f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109774:	50                   	push   %eax
80109775:	e8 47 fb ff ff       	call   801092c1 <p2v>
8010977a:	83 c4 04             	add    $0x4,%esp
8010977d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109780:	eb 48                	jmp    801097ca <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80109782:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80109786:	74 0e                	je     80109796 <walkpgdir+0x53>
80109788:	e8 1a 98 ff ff       	call   80102fa7 <kalloc>
8010978d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80109790:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109794:	75 07                	jne    8010979d <walkpgdir+0x5a>
      return 0;
80109796:	b8 00 00 00 00       	mov    $0x0,%eax
8010979b:	eb 44                	jmp    801097e1 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010979d:	83 ec 04             	sub    $0x4,%esp
801097a0:	68 00 10 00 00       	push   $0x1000
801097a5:	6a 00                	push   $0x0
801097a7:	ff 75 f4             	pushl  -0xc(%ebp)
801097aa:	e8 94 d3 ff ff       	call   80106b43 <memset>
801097af:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
801097b2:	83 ec 0c             	sub    $0xc,%esp
801097b5:	ff 75 f4             	pushl  -0xc(%ebp)
801097b8:	e8 f7 fa ff ff       	call   801092b4 <v2p>
801097bd:	83 c4 10             	add    $0x10,%esp
801097c0:	83 c8 07             	or     $0x7,%eax
801097c3:	89 c2                	mov    %eax,%edx
801097c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801097c8:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
801097ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801097cd:	c1 e8 0c             	shr    $0xc,%eax
801097d0:	25 ff 03 00 00       	and    $0x3ff,%eax
801097d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801097dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801097df:	01 d0                	add    %edx,%eax
}
801097e1:	c9                   	leave  
801097e2:	c3                   	ret    

801097e3 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801097e3:	55                   	push   %ebp
801097e4:	89 e5                	mov    %esp,%ebp
801097e6:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
801097e9:	8b 45 0c             	mov    0xc(%ebp),%eax
801097ec:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801097f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801097f4:	8b 55 0c             	mov    0xc(%ebp),%edx
801097f7:	8b 45 10             	mov    0x10(%ebp),%eax
801097fa:	01 d0                	add    %edx,%eax
801097fc:	83 e8 01             	sub    $0x1,%eax
801097ff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109804:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80109807:	83 ec 04             	sub    $0x4,%esp
8010980a:	6a 01                	push   $0x1
8010980c:	ff 75 f4             	pushl  -0xc(%ebp)
8010980f:	ff 75 08             	pushl  0x8(%ebp)
80109812:	e8 2c ff ff ff       	call   80109743 <walkpgdir>
80109817:	83 c4 10             	add    $0x10,%esp
8010981a:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010981d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109821:	75 07                	jne    8010982a <mappages+0x47>
      return -1;
80109823:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109828:	eb 47                	jmp    80109871 <mappages+0x8e>
    if(*pte & PTE_P)
8010982a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010982d:	8b 00                	mov    (%eax),%eax
8010982f:	83 e0 01             	and    $0x1,%eax
80109832:	85 c0                	test   %eax,%eax
80109834:	74 0d                	je     80109843 <mappages+0x60>
      panic("remap");
80109836:	83 ec 0c             	sub    $0xc,%esp
80109839:	68 74 a8 10 80       	push   $0x8010a874
8010983e:	e8 23 6d ff ff       	call   80100566 <panic>
    *pte = pa | perm | PTE_P;
80109843:	8b 45 18             	mov    0x18(%ebp),%eax
80109846:	0b 45 14             	or     0x14(%ebp),%eax
80109849:	83 c8 01             	or     $0x1,%eax
8010984c:	89 c2                	mov    %eax,%edx
8010984e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109851:	89 10                	mov    %edx,(%eax)
    if(a == last)
80109853:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109856:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109859:	74 10                	je     8010986b <mappages+0x88>
      break;
    a += PGSIZE;
8010985b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80109862:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
80109869:	eb 9c                	jmp    80109807 <mappages+0x24>
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
8010986b:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010986c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109871:	c9                   	leave  
80109872:	c3                   	ret    

80109873 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80109873:	55                   	push   %ebp
80109874:	89 e5                	mov    %esp,%ebp
80109876:	53                   	push   %ebx
80109877:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
8010987a:	e8 28 97 ff ff       	call   80102fa7 <kalloc>
8010987f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109882:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109886:	75 0a                	jne    80109892 <setupkvm+0x1f>
    return 0;
80109888:	b8 00 00 00 00       	mov    $0x0,%eax
8010988d:	e9 8e 00 00 00       	jmp    80109920 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
80109892:	83 ec 04             	sub    $0x4,%esp
80109895:	68 00 10 00 00       	push   $0x1000
8010989a:	6a 00                	push   $0x0
8010989c:	ff 75 f0             	pushl  -0x10(%ebp)
8010989f:	e8 9f d2 ff ff       	call   80106b43 <memset>
801098a4:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
801098a7:	83 ec 0c             	sub    $0xc,%esp
801098aa:	68 00 00 00 0e       	push   $0xe000000
801098af:	e8 0d fa ff ff       	call   801092c1 <p2v>
801098b4:	83 c4 10             	add    $0x10,%esp
801098b7:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
801098bc:	76 0d                	jbe    801098cb <setupkvm+0x58>
    panic("PHYSTOP too high");
801098be:	83 ec 0c             	sub    $0xc,%esp
801098c1:	68 7a a8 10 80       	push   $0x8010a87a
801098c6:	e8 9b 6c ff ff       	call   80100566 <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801098cb:	c7 45 f4 e0 d4 10 80 	movl   $0x8010d4e0,-0xc(%ebp)
801098d2:	eb 40                	jmp    80109914 <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801098d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098d7:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
801098da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098dd:	8b 50 04             	mov    0x4(%eax),%edx
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
801098e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098e3:	8b 58 08             	mov    0x8(%eax),%ebx
801098e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098e9:	8b 40 04             	mov    0x4(%eax),%eax
801098ec:	29 c3                	sub    %eax,%ebx
801098ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801098f1:	8b 00                	mov    (%eax),%eax
801098f3:	83 ec 0c             	sub    $0xc,%esp
801098f6:	51                   	push   %ecx
801098f7:	52                   	push   %edx
801098f8:	53                   	push   %ebx
801098f9:	50                   	push   %eax
801098fa:	ff 75 f0             	pushl  -0x10(%ebp)
801098fd:	e8 e1 fe ff ff       	call   801097e3 <mappages>
80109902:	83 c4 20             	add    $0x20,%esp
80109905:	85 c0                	test   %eax,%eax
80109907:	79 07                	jns    80109910 <setupkvm+0x9d>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80109909:	b8 00 00 00 00       	mov    $0x0,%eax
8010990e:	eb 10                	jmp    80109920 <setupkvm+0xad>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80109910:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80109914:	81 7d f4 20 d5 10 80 	cmpl   $0x8010d520,-0xc(%ebp)
8010991b:	72 b7                	jb     801098d4 <setupkvm+0x61>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
8010991d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80109920:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109923:	c9                   	leave  
80109924:	c3                   	ret    

80109925 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80109925:	55                   	push   %ebp
80109926:	89 e5                	mov    %esp,%ebp
80109928:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
8010992b:	e8 43 ff ff ff       	call   80109873 <setupkvm>
80109930:	a3 78 79 11 80       	mov    %eax,0x80117978
  switchkvm();
80109935:	e8 03 00 00 00       	call   8010993d <switchkvm>
}
8010993a:	90                   	nop
8010993b:	c9                   	leave  
8010993c:	c3                   	ret    

8010993d <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
8010993d:	55                   	push   %ebp
8010993e:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
80109940:	a1 78 79 11 80       	mov    0x80117978,%eax
80109945:	50                   	push   %eax
80109946:	e8 69 f9 ff ff       	call   801092b4 <v2p>
8010994b:	83 c4 04             	add    $0x4,%esp
8010994e:	50                   	push   %eax
8010994f:	e8 54 f9 ff ff       	call   801092a8 <lcr3>
80109954:	83 c4 04             	add    $0x4,%esp
}
80109957:	90                   	nop
80109958:	c9                   	leave  
80109959:	c3                   	ret    

8010995a <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
8010995a:	55                   	push   %ebp
8010995b:	89 e5                	mov    %esp,%ebp
8010995d:	56                   	push   %esi
8010995e:	53                   	push   %ebx
  pushcli();
8010995f:	e8 d9 d0 ff ff       	call   80106a3d <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
80109964:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010996a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80109971:	83 c2 08             	add    $0x8,%edx
80109974:	89 d6                	mov    %edx,%esi
80109976:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010997d:	83 c2 08             	add    $0x8,%edx
80109980:	c1 ea 10             	shr    $0x10,%edx
80109983:	89 d3                	mov    %edx,%ebx
80109985:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010998c:	83 c2 08             	add    $0x8,%edx
8010998f:	c1 ea 18             	shr    $0x18,%edx
80109992:	89 d1                	mov    %edx,%ecx
80109994:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
8010999b:	67 00 
8010999d:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
801099a4:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
801099aa:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801099b1:	83 e2 f0             	and    $0xfffffff0,%edx
801099b4:	83 ca 09             	or     $0x9,%edx
801099b7:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801099bd:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801099c4:	83 ca 10             	or     $0x10,%edx
801099c7:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801099cd:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801099d4:	83 e2 9f             	and    $0xffffff9f,%edx
801099d7:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801099dd:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801099e4:	83 ca 80             	or     $0xffffff80,%edx
801099e7:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
801099ed:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801099f4:	83 e2 f0             	and    $0xfffffff0,%edx
801099f7:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801099fd:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109a04:	83 e2 ef             	and    $0xffffffef,%edx
80109a07:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109a0d:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109a14:	83 e2 df             	and    $0xffffffdf,%edx
80109a17:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109a1d:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109a24:	83 ca 40             	or     $0x40,%edx
80109a27:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109a2d:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
80109a34:	83 e2 7f             	and    $0x7f,%edx
80109a37:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80109a3d:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
80109a43:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109a49:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80109a50:	83 e2 ef             	and    $0xffffffef,%edx
80109a53:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
80109a59:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109a5f:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
80109a65:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80109a6b:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80109a72:	8b 52 08             	mov    0x8(%edx),%edx
80109a75:	81 c2 00 10 00 00    	add    $0x1000,%edx
80109a7b:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80109a7e:	83 ec 0c             	sub    $0xc,%esp
80109a81:	6a 30                	push   $0x30
80109a83:	e8 f3 f7 ff ff       	call   8010927b <ltr>
80109a88:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80109a8b:	8b 45 08             	mov    0x8(%ebp),%eax
80109a8e:	8b 40 04             	mov    0x4(%eax),%eax
80109a91:	85 c0                	test   %eax,%eax
80109a93:	75 0d                	jne    80109aa2 <switchuvm+0x148>
    panic("switchuvm: no pgdir");
80109a95:	83 ec 0c             	sub    $0xc,%esp
80109a98:	68 8b a8 10 80       	push   $0x8010a88b
80109a9d:	e8 c4 6a ff ff       	call   80100566 <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80109aa2:	8b 45 08             	mov    0x8(%ebp),%eax
80109aa5:	8b 40 04             	mov    0x4(%eax),%eax
80109aa8:	83 ec 0c             	sub    $0xc,%esp
80109aab:	50                   	push   %eax
80109aac:	e8 03 f8 ff ff       	call   801092b4 <v2p>
80109ab1:	83 c4 10             	add    $0x10,%esp
80109ab4:	83 ec 0c             	sub    $0xc,%esp
80109ab7:	50                   	push   %eax
80109ab8:	e8 eb f7 ff ff       	call   801092a8 <lcr3>
80109abd:	83 c4 10             	add    $0x10,%esp
  popcli();
80109ac0:	e8 bd cf ff ff       	call   80106a82 <popcli>
}
80109ac5:	90                   	nop
80109ac6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80109ac9:	5b                   	pop    %ebx
80109aca:	5e                   	pop    %esi
80109acb:	5d                   	pop    %ebp
80109acc:	c3                   	ret    

80109acd <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80109acd:	55                   	push   %ebp
80109ace:	89 e5                	mov    %esp,%ebp
80109ad0:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
80109ad3:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80109ada:	76 0d                	jbe    80109ae9 <inituvm+0x1c>
    panic("inituvm: more than a page");
80109adc:	83 ec 0c             	sub    $0xc,%esp
80109adf:	68 9f a8 10 80       	push   $0x8010a89f
80109ae4:	e8 7d 6a ff ff       	call   80100566 <panic>
  mem = kalloc();
80109ae9:	e8 b9 94 ff ff       	call   80102fa7 <kalloc>
80109aee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
80109af1:	83 ec 04             	sub    $0x4,%esp
80109af4:	68 00 10 00 00       	push   $0x1000
80109af9:	6a 00                	push   $0x0
80109afb:	ff 75 f4             	pushl  -0xc(%ebp)
80109afe:	e8 40 d0 ff ff       	call   80106b43 <memset>
80109b03:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109b06:	83 ec 0c             	sub    $0xc,%esp
80109b09:	ff 75 f4             	pushl  -0xc(%ebp)
80109b0c:	e8 a3 f7 ff ff       	call   801092b4 <v2p>
80109b11:	83 c4 10             	add    $0x10,%esp
80109b14:	83 ec 0c             	sub    $0xc,%esp
80109b17:	6a 06                	push   $0x6
80109b19:	50                   	push   %eax
80109b1a:	68 00 10 00 00       	push   $0x1000
80109b1f:	6a 00                	push   $0x0
80109b21:	ff 75 08             	pushl  0x8(%ebp)
80109b24:	e8 ba fc ff ff       	call   801097e3 <mappages>
80109b29:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
80109b2c:	83 ec 04             	sub    $0x4,%esp
80109b2f:	ff 75 10             	pushl  0x10(%ebp)
80109b32:	ff 75 0c             	pushl  0xc(%ebp)
80109b35:	ff 75 f4             	pushl  -0xc(%ebp)
80109b38:	e8 c5 d0 ff ff       	call   80106c02 <memmove>
80109b3d:	83 c4 10             	add    $0x10,%esp
}
80109b40:	90                   	nop
80109b41:	c9                   	leave  
80109b42:	c3                   	ret    

80109b43 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80109b43:	55                   	push   %ebp
80109b44:	89 e5                	mov    %esp,%ebp
80109b46:	53                   	push   %ebx
80109b47:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80109b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
80109b4d:	25 ff 0f 00 00       	and    $0xfff,%eax
80109b52:	85 c0                	test   %eax,%eax
80109b54:	74 0d                	je     80109b63 <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
80109b56:	83 ec 0c             	sub    $0xc,%esp
80109b59:	68 bc a8 10 80       	push   $0x8010a8bc
80109b5e:	e8 03 6a ff ff       	call   80100566 <panic>
  for(i = 0; i < sz; i += PGSIZE){
80109b63:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109b6a:	e9 95 00 00 00       	jmp    80109c04 <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80109b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
80109b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109b75:	01 d0                	add    %edx,%eax
80109b77:	83 ec 04             	sub    $0x4,%esp
80109b7a:	6a 00                	push   $0x0
80109b7c:	50                   	push   %eax
80109b7d:	ff 75 08             	pushl  0x8(%ebp)
80109b80:	e8 be fb ff ff       	call   80109743 <walkpgdir>
80109b85:	83 c4 10             	add    $0x10,%esp
80109b88:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109b8b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109b8f:	75 0d                	jne    80109b9e <loaduvm+0x5b>
      panic("loaduvm: address should exist");
80109b91:	83 ec 0c             	sub    $0xc,%esp
80109b94:	68 df a8 10 80       	push   $0x8010a8df
80109b99:	e8 c8 69 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109b9e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ba1:	8b 00                	mov    (%eax),%eax
80109ba3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109ba8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80109bab:	8b 45 18             	mov    0x18(%ebp),%eax
80109bae:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109bb1:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80109bb6:	77 0b                	ja     80109bc3 <loaduvm+0x80>
      n = sz - i;
80109bb8:	8b 45 18             	mov    0x18(%ebp),%eax
80109bbb:	2b 45 f4             	sub    -0xc(%ebp),%eax
80109bbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109bc1:	eb 07                	jmp    80109bca <loaduvm+0x87>
    else
      n = PGSIZE;
80109bc3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80109bca:	8b 55 14             	mov    0x14(%ebp),%edx
80109bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109bd0:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80109bd3:	83 ec 0c             	sub    $0xc,%esp
80109bd6:	ff 75 e8             	pushl  -0x18(%ebp)
80109bd9:	e8 e3 f6 ff ff       	call   801092c1 <p2v>
80109bde:	83 c4 10             	add    $0x10,%esp
80109be1:	ff 75 f0             	pushl  -0x10(%ebp)
80109be4:	53                   	push   %ebx
80109be5:	50                   	push   %eax
80109be6:	ff 75 10             	pushl  0x10(%ebp)
80109be9:	e8 b7 84 ff ff       	call   801020a5 <readi>
80109bee:	83 c4 10             	add    $0x10,%esp
80109bf1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80109bf4:	74 07                	je     80109bfd <loaduvm+0xba>
      return -1;
80109bf6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80109bfb:	eb 18                	jmp    80109c15 <loaduvm+0xd2>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80109bfd:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109c07:	3b 45 18             	cmp    0x18(%ebp),%eax
80109c0a:	0f 82 5f ff ff ff    	jb     80109b6f <loaduvm+0x2c>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80109c10:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109c15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109c18:	c9                   	leave  
80109c19:	c3                   	ret    

80109c1a <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109c1a:	55                   	push   %ebp
80109c1b:	89 e5                	mov    %esp,%ebp
80109c1d:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80109c20:	8b 45 10             	mov    0x10(%ebp),%eax
80109c23:	85 c0                	test   %eax,%eax
80109c25:	79 0a                	jns    80109c31 <allocuvm+0x17>
    return 0;
80109c27:	b8 00 00 00 00       	mov    $0x0,%eax
80109c2c:	e9 b0 00 00 00       	jmp    80109ce1 <allocuvm+0xc7>
  if(newsz < oldsz)
80109c31:	8b 45 10             	mov    0x10(%ebp),%eax
80109c34:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109c37:	73 08                	jae    80109c41 <allocuvm+0x27>
    return oldsz;
80109c39:	8b 45 0c             	mov    0xc(%ebp),%eax
80109c3c:	e9 a0 00 00 00       	jmp    80109ce1 <allocuvm+0xc7>

  a = PGROUNDUP(oldsz);
80109c41:	8b 45 0c             	mov    0xc(%ebp),%eax
80109c44:	05 ff 0f 00 00       	add    $0xfff,%eax
80109c49:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109c4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
80109c51:	eb 7f                	jmp    80109cd2 <allocuvm+0xb8>
    mem = kalloc();
80109c53:	e8 4f 93 ff ff       	call   80102fa7 <kalloc>
80109c58:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80109c5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109c5f:	75 2b                	jne    80109c8c <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
80109c61:	83 ec 0c             	sub    $0xc,%esp
80109c64:	68 fd a8 10 80       	push   $0x8010a8fd
80109c69:	e8 58 67 ff ff       	call   801003c6 <cprintf>
80109c6e:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
80109c71:	83 ec 04             	sub    $0x4,%esp
80109c74:	ff 75 0c             	pushl  0xc(%ebp)
80109c77:	ff 75 10             	pushl  0x10(%ebp)
80109c7a:	ff 75 08             	pushl  0x8(%ebp)
80109c7d:	e8 61 00 00 00       	call   80109ce3 <deallocuvm>
80109c82:	83 c4 10             	add    $0x10,%esp
      return 0;
80109c85:	b8 00 00 00 00       	mov    $0x0,%eax
80109c8a:	eb 55                	jmp    80109ce1 <allocuvm+0xc7>
    }
    memset(mem, 0, PGSIZE);
80109c8c:	83 ec 04             	sub    $0x4,%esp
80109c8f:	68 00 10 00 00       	push   $0x1000
80109c94:	6a 00                	push   $0x0
80109c96:	ff 75 f0             	pushl  -0x10(%ebp)
80109c99:	e8 a5 ce ff ff       	call   80106b43 <memset>
80109c9e:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80109ca1:	83 ec 0c             	sub    $0xc,%esp
80109ca4:	ff 75 f0             	pushl  -0x10(%ebp)
80109ca7:	e8 08 f6 ff ff       	call   801092b4 <v2p>
80109cac:	83 c4 10             	add    $0x10,%esp
80109caf:	89 c2                	mov    %eax,%edx
80109cb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109cb4:	83 ec 0c             	sub    $0xc,%esp
80109cb7:	6a 06                	push   $0x6
80109cb9:	52                   	push   %edx
80109cba:	68 00 10 00 00       	push   $0x1000
80109cbf:	50                   	push   %eax
80109cc0:	ff 75 08             	pushl  0x8(%ebp)
80109cc3:	e8 1b fb ff ff       	call   801097e3 <mappages>
80109cc8:	83 c4 20             	add    $0x20,%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80109ccb:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109cd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109cd5:	3b 45 10             	cmp    0x10(%ebp),%eax
80109cd8:	0f 82 75 ff ff ff    	jb     80109c53 <allocuvm+0x39>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80109cde:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109ce1:	c9                   	leave  
80109ce2:	c3                   	ret    

80109ce3 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80109ce3:	55                   	push   %ebp
80109ce4:	89 e5                	mov    %esp,%ebp
80109ce6:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80109ce9:	8b 45 10             	mov    0x10(%ebp),%eax
80109cec:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109cef:	72 08                	jb     80109cf9 <deallocuvm+0x16>
    return oldsz;
80109cf1:	8b 45 0c             	mov    0xc(%ebp),%eax
80109cf4:	e9 a5 00 00 00       	jmp    80109d9e <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80109cf9:	8b 45 10             	mov    0x10(%ebp),%eax
80109cfc:	05 ff 0f 00 00       	add    $0xfff,%eax
80109d01:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80109d09:	e9 81 00 00 00       	jmp    80109d8f <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80109d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d11:	83 ec 04             	sub    $0x4,%esp
80109d14:	6a 00                	push   $0x0
80109d16:	50                   	push   %eax
80109d17:	ff 75 08             	pushl  0x8(%ebp)
80109d1a:	e8 24 fa ff ff       	call   80109743 <walkpgdir>
80109d1f:	83 c4 10             	add    $0x10,%esp
80109d22:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
80109d25:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109d29:	75 09                	jne    80109d34 <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
80109d2b:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
80109d32:	eb 54                	jmp    80109d88 <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
80109d34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d37:	8b 00                	mov    (%eax),%eax
80109d39:	83 e0 01             	and    $0x1,%eax
80109d3c:	85 c0                	test   %eax,%eax
80109d3e:	74 48                	je     80109d88 <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
80109d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d43:	8b 00                	mov    (%eax),%eax
80109d45:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109d4a:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80109d4d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109d51:	75 0d                	jne    80109d60 <deallocuvm+0x7d>
        panic("kfree");
80109d53:	83 ec 0c             	sub    $0xc,%esp
80109d56:	68 15 a9 10 80       	push   $0x8010a915
80109d5b:	e8 06 68 ff ff       	call   80100566 <panic>
      char *v = p2v(pa);
80109d60:	83 ec 0c             	sub    $0xc,%esp
80109d63:	ff 75 ec             	pushl  -0x14(%ebp)
80109d66:	e8 56 f5 ff ff       	call   801092c1 <p2v>
80109d6b:	83 c4 10             	add    $0x10,%esp
80109d6e:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80109d71:	83 ec 0c             	sub    $0xc,%esp
80109d74:	ff 75 e8             	pushl  -0x18(%ebp)
80109d77:	e8 8e 91 ff ff       	call   80102f0a <kfree>
80109d7c:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
80109d7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109d82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80109d88:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109d92:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109d95:	0f 82 73 ff ff ff    	jb     80109d0e <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80109d9b:	8b 45 10             	mov    0x10(%ebp),%eax
}
80109d9e:	c9                   	leave  
80109d9f:	c3                   	ret    

80109da0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80109da0:	55                   	push   %ebp
80109da1:	89 e5                	mov    %esp,%ebp
80109da3:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
80109da6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80109daa:	75 0d                	jne    80109db9 <freevm+0x19>
    panic("freevm: no pgdir");
80109dac:	83 ec 0c             	sub    $0xc,%esp
80109daf:	68 1b a9 10 80       	push   $0x8010a91b
80109db4:	e8 ad 67 ff ff       	call   80100566 <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80109db9:	83 ec 04             	sub    $0x4,%esp
80109dbc:	6a 00                	push   $0x0
80109dbe:	68 00 00 00 80       	push   $0x80000000
80109dc3:	ff 75 08             	pushl  0x8(%ebp)
80109dc6:	e8 18 ff ff ff       	call   80109ce3 <deallocuvm>
80109dcb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80109dce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109dd5:	eb 4f                	jmp    80109e26 <freevm+0x86>
    if(pgdir[i] & PTE_P){
80109dd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109dda:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109de1:	8b 45 08             	mov    0x8(%ebp),%eax
80109de4:	01 d0                	add    %edx,%eax
80109de6:	8b 00                	mov    (%eax),%eax
80109de8:	83 e0 01             	and    $0x1,%eax
80109deb:	85 c0                	test   %eax,%eax
80109ded:	74 33                	je     80109e22 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80109def:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109df2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80109df9:	8b 45 08             	mov    0x8(%ebp),%eax
80109dfc:	01 d0                	add    %edx,%eax
80109dfe:	8b 00                	mov    (%eax),%eax
80109e00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109e05:	83 ec 0c             	sub    $0xc,%esp
80109e08:	50                   	push   %eax
80109e09:	e8 b3 f4 ff ff       	call   801092c1 <p2v>
80109e0e:	83 c4 10             	add    $0x10,%esp
80109e11:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80109e14:	83 ec 0c             	sub    $0xc,%esp
80109e17:	ff 75 f0             	pushl  -0x10(%ebp)
80109e1a:	e8 eb 90 ff ff       	call   80102f0a <kfree>
80109e1f:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80109e22:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80109e26:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80109e2d:	76 a8                	jbe    80109dd7 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80109e2f:	83 ec 0c             	sub    $0xc,%esp
80109e32:	ff 75 08             	pushl  0x8(%ebp)
80109e35:	e8 d0 90 ff ff       	call   80102f0a <kfree>
80109e3a:	83 c4 10             	add    $0x10,%esp
}
80109e3d:	90                   	nop
80109e3e:	c9                   	leave  
80109e3f:	c3                   	ret    

80109e40 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80109e40:	55                   	push   %ebp
80109e41:	89 e5                	mov    %esp,%ebp
80109e43:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109e46:	83 ec 04             	sub    $0x4,%esp
80109e49:	6a 00                	push   $0x0
80109e4b:	ff 75 0c             	pushl  0xc(%ebp)
80109e4e:	ff 75 08             	pushl  0x8(%ebp)
80109e51:	e8 ed f8 ff ff       	call   80109743 <walkpgdir>
80109e56:	83 c4 10             	add    $0x10,%esp
80109e59:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80109e5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80109e60:	75 0d                	jne    80109e6f <clearpteu+0x2f>
    panic("clearpteu");
80109e62:	83 ec 0c             	sub    $0xc,%esp
80109e65:	68 2c a9 10 80       	push   $0x8010a92c
80109e6a:	e8 f7 66 ff ff       	call   80100566 <panic>
  *pte &= ~PTE_U;
80109e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e72:	8b 00                	mov    (%eax),%eax
80109e74:	83 e0 fb             	and    $0xfffffffb,%eax
80109e77:	89 c2                	mov    %eax,%edx
80109e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109e7c:	89 10                	mov    %edx,(%eax)
}
80109e7e:	90                   	nop
80109e7f:	c9                   	leave  
80109e80:	c3                   	ret    

80109e81 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80109e81:	55                   	push   %ebp
80109e82:	89 e5                	mov    %esp,%ebp
80109e84:	53                   	push   %ebx
80109e85:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80109e88:	e8 e6 f9 ff ff       	call   80109873 <setupkvm>
80109e8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80109e90:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80109e94:	75 0a                	jne    80109ea0 <copyuvm+0x1f>
    return 0;
80109e96:	b8 00 00 00 00       	mov    $0x0,%eax
80109e9b:	e9 f8 00 00 00       	jmp    80109f98 <copyuvm+0x117>
  for(i = 0; i < sz; i += PGSIZE){
80109ea0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80109ea7:	e9 c4 00 00 00       	jmp    80109f70 <copyuvm+0xef>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80109eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109eaf:	83 ec 04             	sub    $0x4,%esp
80109eb2:	6a 00                	push   $0x0
80109eb4:	50                   	push   %eax
80109eb5:	ff 75 08             	pushl  0x8(%ebp)
80109eb8:	e8 86 f8 ff ff       	call   80109743 <walkpgdir>
80109ebd:	83 c4 10             	add    $0x10,%esp
80109ec0:	89 45 ec             	mov    %eax,-0x14(%ebp)
80109ec3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80109ec7:	75 0d                	jne    80109ed6 <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80109ec9:	83 ec 0c             	sub    $0xc,%esp
80109ecc:	68 36 a9 10 80       	push   $0x8010a936
80109ed1:	e8 90 66 ff ff       	call   80100566 <panic>
    if(!(*pte & PTE_P))
80109ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ed9:	8b 00                	mov    (%eax),%eax
80109edb:	83 e0 01             	and    $0x1,%eax
80109ede:	85 c0                	test   %eax,%eax
80109ee0:	75 0d                	jne    80109eef <copyuvm+0x6e>
      panic("copyuvm: page not present");
80109ee2:	83 ec 0c             	sub    $0xc,%esp
80109ee5:	68 50 a9 10 80       	push   $0x8010a950
80109eea:	e8 77 66 ff ff       	call   80100566 <panic>
    pa = PTE_ADDR(*pte);
80109eef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109ef2:	8b 00                	mov    (%eax),%eax
80109ef4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109ef9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80109efc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80109eff:	8b 00                	mov    (%eax),%eax
80109f01:	25 ff 0f 00 00       	and    $0xfff,%eax
80109f06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80109f09:	e8 99 90 ff ff       	call   80102fa7 <kalloc>
80109f0e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80109f11:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80109f15:	74 6a                	je     80109f81 <copyuvm+0x100>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
80109f17:	83 ec 0c             	sub    $0xc,%esp
80109f1a:	ff 75 e8             	pushl  -0x18(%ebp)
80109f1d:	e8 9f f3 ff ff       	call   801092c1 <p2v>
80109f22:	83 c4 10             	add    $0x10,%esp
80109f25:	83 ec 04             	sub    $0x4,%esp
80109f28:	68 00 10 00 00       	push   $0x1000
80109f2d:	50                   	push   %eax
80109f2e:	ff 75 e0             	pushl  -0x20(%ebp)
80109f31:	e8 cc cc ff ff       	call   80106c02 <memmove>
80109f36:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80109f39:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80109f3c:	83 ec 0c             	sub    $0xc,%esp
80109f3f:	ff 75 e0             	pushl  -0x20(%ebp)
80109f42:	e8 6d f3 ff ff       	call   801092b4 <v2p>
80109f47:	83 c4 10             	add    $0x10,%esp
80109f4a:	89 c2                	mov    %eax,%edx
80109f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109f4f:	83 ec 0c             	sub    $0xc,%esp
80109f52:	53                   	push   %ebx
80109f53:	52                   	push   %edx
80109f54:	68 00 10 00 00       	push   $0x1000
80109f59:	50                   	push   %eax
80109f5a:	ff 75 f0             	pushl  -0x10(%ebp)
80109f5d:	e8 81 f8 ff ff       	call   801097e3 <mappages>
80109f62:	83 c4 20             	add    $0x20,%esp
80109f65:	85 c0                	test   %eax,%eax
80109f67:	78 1b                	js     80109f84 <copyuvm+0x103>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80109f69:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80109f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109f73:	3b 45 0c             	cmp    0xc(%ebp),%eax
80109f76:	0f 82 30 ff ff ff    	jb     80109eac <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80109f7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80109f7f:	eb 17                	jmp    80109f98 <copyuvm+0x117>
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
80109f81:	90                   	nop
80109f82:	eb 01                	jmp    80109f85 <copyuvm+0x104>
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
80109f84:	90                   	nop
  }
  return d;

bad:
  freevm(d);
80109f85:	83 ec 0c             	sub    $0xc,%esp
80109f88:	ff 75 f0             	pushl  -0x10(%ebp)
80109f8b:	e8 10 fe ff ff       	call   80109da0 <freevm>
80109f90:	83 c4 10             	add    $0x10,%esp
  return 0;
80109f93:	b8 00 00 00 00       	mov    $0x0,%eax
}
80109f98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80109f9b:	c9                   	leave  
80109f9c:	c3                   	ret    

80109f9d <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80109f9d:	55                   	push   %ebp
80109f9e:	89 e5                	mov    %esp,%ebp
80109fa0:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80109fa3:	83 ec 04             	sub    $0x4,%esp
80109fa6:	6a 00                	push   $0x0
80109fa8:	ff 75 0c             	pushl  0xc(%ebp)
80109fab:	ff 75 08             	pushl  0x8(%ebp)
80109fae:	e8 90 f7 ff ff       	call   80109743 <walkpgdir>
80109fb3:	83 c4 10             	add    $0x10,%esp
80109fb6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80109fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109fbc:	8b 00                	mov    (%eax),%eax
80109fbe:	83 e0 01             	and    $0x1,%eax
80109fc1:	85 c0                	test   %eax,%eax
80109fc3:	75 07                	jne    80109fcc <uva2ka+0x2f>
    return 0;
80109fc5:	b8 00 00 00 00       	mov    $0x0,%eax
80109fca:	eb 29                	jmp    80109ff5 <uva2ka+0x58>
  if((*pte & PTE_U) == 0)
80109fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109fcf:	8b 00                	mov    (%eax),%eax
80109fd1:	83 e0 04             	and    $0x4,%eax
80109fd4:	85 c0                	test   %eax,%eax
80109fd6:	75 07                	jne    80109fdf <uva2ka+0x42>
    return 0;
80109fd8:	b8 00 00 00 00       	mov    $0x0,%eax
80109fdd:	eb 16                	jmp    80109ff5 <uva2ka+0x58>
  return (char*)p2v(PTE_ADDR(*pte));
80109fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80109fe2:	8b 00                	mov    (%eax),%eax
80109fe4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80109fe9:	83 ec 0c             	sub    $0xc,%esp
80109fec:	50                   	push   %eax
80109fed:	e8 cf f2 ff ff       	call   801092c1 <p2v>
80109ff2:	83 c4 10             	add    $0x10,%esp
}
80109ff5:	c9                   	leave  
80109ff6:	c3                   	ret    

80109ff7 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80109ff7:	55                   	push   %ebp
80109ff8:	89 e5                	mov    %esp,%ebp
80109ffa:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80109ffd:	8b 45 10             	mov    0x10(%ebp),%eax
8010a000:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
8010a003:	eb 7f                	jmp    8010a084 <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
8010a005:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a008:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010a00d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
8010a010:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a013:	83 ec 08             	sub    $0x8,%esp
8010a016:	50                   	push   %eax
8010a017:	ff 75 08             	pushl  0x8(%ebp)
8010a01a:	e8 7e ff ff ff       	call   80109f9d <uva2ka>
8010a01f:	83 c4 10             	add    $0x10,%esp
8010a022:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010a025:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010a029:	75 07                	jne    8010a032 <copyout+0x3b>
      return -1;
8010a02b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010a030:	eb 61                	jmp    8010a093 <copyout+0x9c>
    n = PGSIZE - (va - va0);
8010a032:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a035:	2b 45 0c             	sub    0xc(%ebp),%eax
8010a038:	05 00 10 00 00       	add    $0x1000,%eax
8010a03d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
8010a040:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a043:	3b 45 14             	cmp    0x14(%ebp),%eax
8010a046:	76 06                	jbe    8010a04e <copyout+0x57>
      n = len;
8010a048:	8b 45 14             	mov    0x14(%ebp),%eax
8010a04b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
8010a04e:	8b 45 0c             	mov    0xc(%ebp),%eax
8010a051:	2b 45 ec             	sub    -0x14(%ebp),%eax
8010a054:	89 c2                	mov    %eax,%edx
8010a056:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010a059:	01 d0                	add    %edx,%eax
8010a05b:	83 ec 04             	sub    $0x4,%esp
8010a05e:	ff 75 f0             	pushl  -0x10(%ebp)
8010a061:	ff 75 f4             	pushl  -0xc(%ebp)
8010a064:	50                   	push   %eax
8010a065:	e8 98 cb ff ff       	call   80106c02 <memmove>
8010a06a:	83 c4 10             	add    $0x10,%esp
    len -= n;
8010a06d:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a070:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
8010a073:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010a076:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
8010a079:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010a07c:	05 00 10 00 00       	add    $0x1000,%eax
8010a081:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010a084:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010a088:	0f 85 77 ff ff ff    	jne    8010a005 <copyout+0xe>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010a08e:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010a093:	c9                   	leave  
8010a094:	c3                   	ret    
