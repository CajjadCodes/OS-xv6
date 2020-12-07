
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
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
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
80100028:	bc d0 6e 11 80       	mov    $0x80116ed0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 70 31 10 80       	mov    $0x80103170,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 e0 7a 10 80       	push   $0x80107ae0
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 65 4b 00 00       	call   80104bc0 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 e7 7a 10 80       	push   $0x80107ae7
80100097:	50                   	push   %eax
80100098:	e8 f3 49 00 00       	call   80104a90 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 a7 4c 00 00       	call   80104d90 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 c9 4b 00 00       	call   80104d30 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 5e 49 00 00       	call   80104ad0 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 5f 22 00 00       	call   801023f0 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 ee 7a 10 80       	push   $0x80107aee
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 ad 49 00 00       	call   80104b70 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 17 22 00 00       	jmp    801023f0 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 ff 7a 10 80       	push   $0x80107aff
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 6c 49 00 00       	call   80104b70 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 1c 49 00 00       	call   80104b30 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 70 4b 00 00       	call   80104d90 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 bf 4a 00 00       	jmp    80104d30 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 06 7b 10 80       	push   $0x80107b06
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	pushl  0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 d7 16 00 00       	call   80101970 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 eb 4a 00 00       	call   80104d90 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 1e 43 00 00       	call   801045f0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 a9 38 00 00       	call   80103b90 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 35 4a 00 00       	call   80104d30 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	pushl  0x8(%ebp)
801002ff:	e8 8c 15 00 00       	call   80101890 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 df 49 00 00       	call   80104d30 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	pushl  0x8(%ebp)
80100355:	e8 36 15 00 00       	call   80101890 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 62 26 00 00       	call   80102a00 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 0d 7b 10 80       	push   $0x80107b0d
801003a7:	e8 d4 02 00 00       	call   80100680 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	pushl  0x8(%ebp)
801003b0:	e8 cb 02 00 00       	call   80100680 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 8b 85 10 80 	movl   $0x8010858b,(%esp)
801003bc:	e8 bf 02 00 00       	call   80100680 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 13 48 00 00       	call   80104be0 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	pushl  (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 21 7b 10 80       	push   $0x80107b21
801003dd:	e8 9e 02 00 00       	call   80100680 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <cgaputc>:
{
80100400:	55                   	push   %ebp
80100401:	89 c1                	mov    %eax,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100403:	b8 0e 00 00 00       	mov    $0xe,%eax
80100408:	89 e5                	mov    %esp,%ebp
8010040a:	57                   	push   %edi
8010040b:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100410:	56                   	push   %esi
80100411:	89 fa                	mov    %edi,%edx
80100413:	53                   	push   %ebx
80100414:	83 ec 1c             	sub    $0x1c,%esp
80100417:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100418:	be d5 03 00 00       	mov    $0x3d5,%esi
8010041d:	89 f2                	mov    %esi,%edx
8010041f:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100420:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100423:	89 fa                	mov    %edi,%edx
80100425:	c1 e0 08             	shl    $0x8,%eax
80100428:	89 c3                	mov    %eax,%ebx
8010042a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010042f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100430:	89 f2                	mov    %esi,%edx
80100432:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100433:	0f b6 c0             	movzbl %al,%eax
80100436:	09 d8                	or     %ebx,%eax
  if(c == '\n')
80100438:	83 f9 0a             	cmp    $0xa,%ecx
8010043b:	0f 84 97 00 00 00    	je     801004d8 <cgaputc+0xd8>
  else if(c == BACKSPACE){
80100441:	81 f9 00 01 00 00    	cmp    $0x100,%ecx
80100447:	74 77                	je     801004c0 <cgaputc+0xc0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100449:	0f b6 c9             	movzbl %cl,%ecx
8010044c:	8d 58 01             	lea    0x1(%eax),%ebx
8010044f:	80 cd 07             	or     $0x7,%ch
80100452:	66 89 8c 00 00 80 0b 	mov    %cx,-0x7ff48000(%eax,%eax,1)
80100459:	80 
  if(pos < 0 || pos > 25*80)
8010045a:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100460:	0f 8f cc 00 00 00    	jg     80100532 <cgaputc+0x132>
  if((pos/80) >= 24){  // Scroll up.
80100466:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
8010046c:	0f 8f 7e 00 00 00    	jg     801004f0 <cgaputc+0xf0>
  outb(CRTPORT+1, pos>>8);
80100472:	0f b6 c7             	movzbl %bh,%eax
  outb(CRTPORT+1, pos);
80100475:	89 df                	mov    %ebx,%edi
  crt[pos] = ' ' | 0x0700;
80100477:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
  outb(CRTPORT+1, pos>>8);
8010047e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100481:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100486:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048b:	89 da                	mov    %ebx,%edx
8010048d:	ee                   	out    %al,(%dx)
8010048e:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100493:	0f b6 45 e4          	movzbl -0x1c(%ebp),%eax
80100497:	89 ca                	mov    %ecx,%edx
80100499:	ee                   	out    %al,(%dx)
8010049a:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049f:	89 da                	mov    %ebx,%edx
801004a1:	ee                   	out    %al,(%dx)
801004a2:	89 f8                	mov    %edi,%eax
801004a4:	89 ca                	mov    %ecx,%edx
801004a6:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a7:	b8 20 07 00 00       	mov    $0x720,%eax
801004ac:	66 89 06             	mov    %ax,(%esi)
}
801004af:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004b2:	5b                   	pop    %ebx
801004b3:	5e                   	pop    %esi
801004b4:	5f                   	pop    %edi
801004b5:	5d                   	pop    %ebp
801004b6:	c3                   	ret    
801004b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801004be:	66 90                	xchg   %ax,%ax
    if(pos > 0) --pos;
801004c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
801004c3:	85 c0                	test   %eax,%eax
801004c5:	75 93                	jne    8010045a <cgaputc+0x5a>
801004c7:	c6 45 e4 00          	movb   $0x0,-0x1c(%ebp)
801004cb:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004d0:	31 ff                	xor    %edi,%edi
801004d2:	eb ad                	jmp    80100481 <cgaputc+0x81>
801004d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004d8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004dd:	f7 e2                	mul    %edx
801004df:	c1 ea 06             	shr    $0x6,%edx
801004e2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004e5:	c1 e0 04             	shl    $0x4,%eax
801004e8:	8d 58 50             	lea    0x50(%eax),%ebx
801004eb:	e9 6a ff ff ff       	jmp    8010045a <cgaputc+0x5a>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f0:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004f3:	8d 7b b0             	lea    -0x50(%ebx),%edi
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004f6:	8d b4 1b 60 7f 0b 80 	lea    -0x7ff480a0(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fd:	68 60 0e 00 00       	push   $0xe60
80100502:	68 a0 80 0b 80       	push   $0x800b80a0
80100507:	68 00 80 0b 80       	push   $0x800b8000
8010050c:	e8 df 49 00 00       	call   80104ef0 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100511:	b8 80 07 00 00       	mov    $0x780,%eax
80100516:	83 c4 0c             	add    $0xc,%esp
80100519:	29 f8                	sub    %edi,%eax
8010051b:	01 c0                	add    %eax,%eax
8010051d:	50                   	push   %eax
8010051e:	6a 00                	push   $0x0
80100520:	56                   	push   %esi
80100521:	e8 2a 49 00 00       	call   80104e50 <memset>
  outb(CRTPORT+1, pos);
80100526:	c6 45 e4 07          	movb   $0x7,-0x1c(%ebp)
8010052a:	83 c4 10             	add    $0x10,%esp
8010052d:	e9 4f ff ff ff       	jmp    80100481 <cgaputc+0x81>
    panic("pos under/overflow");
80100532:	83 ec 0c             	sub    $0xc,%esp
80100535:	68 25 7b 10 80       	push   $0x80107b25
8010053a:	e8 41 fe ff ff       	call   80100380 <panic>
8010053f:	90                   	nop

80100540 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100540:	55                   	push   %ebp
80100541:	89 e5                	mov    %esp,%ebp
80100543:	57                   	push   %edi
80100544:	56                   	push   %esi
80100545:	53                   	push   %ebx
80100546:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100549:	ff 75 08             	pushl  0x8(%ebp)
{
8010054c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010054f:	e8 1c 14 00 00       	call   80101970 <iunlock>
  acquire(&cons.lock);
80100554:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
8010055b:	e8 30 48 00 00       	call   80104d90 <acquire>
  for(i = 0; i < n; i++)
80100560:	83 c4 10             	add    $0x10,%esp
80100563:	85 f6                	test   %esi,%esi
80100565:	7e 3a                	jle    801005a1 <consolewrite+0x61>
80100567:	8b 5d 0c             	mov    0xc(%ebp),%ebx
8010056a:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
8010056d:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100573:	85 d2                	test   %edx,%edx
80100575:	74 09                	je     80100580 <consolewrite+0x40>
  asm volatile("cli");
80100577:	fa                   	cli    
    for(;;)
80100578:	eb fe                	jmp    80100578 <consolewrite+0x38>
8010057a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100580:	0f b6 03             	movzbl (%ebx),%eax
    uartputc(c);
80100583:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < n; i++)
80100586:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100589:	50                   	push   %eax
8010058a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010058d:	e8 6e 60 00 00       	call   80106600 <uartputc>
  cgaputc(c);
80100592:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100595:	e8 66 fe ff ff       	call   80100400 <cgaputc>
  for(i = 0; i < n; i++)
8010059a:	83 c4 10             	add    $0x10,%esp
8010059d:	39 df                	cmp    %ebx,%edi
8010059f:	75 cc                	jne    8010056d <consolewrite+0x2d>
  release(&cons.lock);
801005a1:	83 ec 0c             	sub    $0xc,%esp
801005a4:	68 20 ff 10 80       	push   $0x8010ff20
801005a9:	e8 82 47 00 00       	call   80104d30 <release>
  ilock(ip);
801005ae:	58                   	pop    %eax
801005af:	ff 75 08             	pushl  0x8(%ebp)
801005b2:	e8 d9 12 00 00       	call   80101890 <ilock>

  return n;
}
801005b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005ba:	89 f0                	mov    %esi,%eax
801005bc:	5b                   	pop    %ebx
801005bd:	5e                   	pop    %esi
801005be:	5f                   	pop    %edi
801005bf:	5d                   	pop    %ebp
801005c0:	c3                   	ret    
801005c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801005cf:	90                   	nop

801005d0 <printint>:
{
801005d0:	55                   	push   %ebp
801005d1:	89 e5                	mov    %esp,%ebp
801005d3:	57                   	push   %edi
801005d4:	56                   	push   %esi
801005d5:	53                   	push   %ebx
801005d6:	83 ec 2c             	sub    $0x2c,%esp
801005d9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801005dc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
801005df:	85 c9                	test   %ecx,%ecx
801005e1:	74 04                	je     801005e7 <printint+0x17>
801005e3:	85 c0                	test   %eax,%eax
801005e5:	78 7e                	js     80100665 <printint+0x95>
    x = xx;
801005e7:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
801005ee:	89 c1                	mov    %eax,%ecx
  i = 0;
801005f0:	31 db                	xor    %ebx,%ebx
801005f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
801005f8:	89 c8                	mov    %ecx,%eax
801005fa:	31 d2                	xor    %edx,%edx
801005fc:	89 de                	mov    %ebx,%esi
801005fe:	89 cf                	mov    %ecx,%edi
80100600:	f7 75 d4             	divl   -0x2c(%ebp)
80100603:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100606:	0f b6 92 50 7b 10 80 	movzbl -0x7fef84b0(%edx),%edx
  }while((x /= base) != 0);
8010060d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010060f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100613:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100616:	73 e0                	jae    801005f8 <printint+0x28>
  if(sign)
80100618:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010061b:	85 c9                	test   %ecx,%ecx
8010061d:	74 0c                	je     8010062b <printint+0x5b>
    buf[i++] = '-';
8010061f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100624:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100626:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010062b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
  if(panicked){
8010062f:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100634:	85 c0                	test   %eax,%eax
80100636:	74 08                	je     80100640 <printint+0x70>
80100638:	fa                   	cli    
    for(;;)
80100639:	eb fe                	jmp    80100639 <printint+0x69>
8010063b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010063f:	90                   	nop
    consputc(buf[i]);
80100640:	0f be f2             	movsbl %dl,%esi
    uartputc(c);
80100643:	83 ec 0c             	sub    $0xc,%esp
80100646:	56                   	push   %esi
80100647:	e8 b4 5f 00 00       	call   80106600 <uartputc>
  cgaputc(c);
8010064c:	89 f0                	mov    %esi,%eax
8010064e:	e8 ad fd ff ff       	call   80100400 <cgaputc>
  while(--i >= 0)
80100653:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100656:	83 c4 10             	add    $0x10,%esp
80100659:	39 c3                	cmp    %eax,%ebx
8010065b:	74 0e                	je     8010066b <printint+0x9b>
    consputc(buf[i]);
8010065d:	0f b6 13             	movzbl (%ebx),%edx
80100660:	83 eb 01             	sub    $0x1,%ebx
80100663:	eb ca                	jmp    8010062f <printint+0x5f>
    x = -xx;
80100665:	f7 d8                	neg    %eax
80100667:	89 c1                	mov    %eax,%ecx
80100669:	eb 85                	jmp    801005f0 <printint+0x20>
}
8010066b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010066e:	5b                   	pop    %ebx
8010066f:	5e                   	pop    %esi
80100670:	5f                   	pop    %edi
80100671:	5d                   	pop    %ebp
80100672:	c3                   	ret    
80100673:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010067a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100680 <cprintf>:
{
80100680:	55                   	push   %ebp
80100681:	89 e5                	mov    %esp,%ebp
80100683:	57                   	push   %edi
80100684:	56                   	push   %esi
80100685:	53                   	push   %ebx
80100686:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100689:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
8010068e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
80100691:	85 c0                	test   %eax,%eax
80100693:	0f 85 37 01 00 00    	jne    801007d0 <cprintf+0x150>
  if (fmt == 0)
80100699:	8b 75 08             	mov    0x8(%ebp),%esi
8010069c:	85 f6                	test   %esi,%esi
8010069e:	0f 84 3f 02 00 00    	je     801008e3 <cprintf+0x263>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006a4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006a7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006aa:	31 db                	xor    %ebx,%ebx
801006ac:	85 c0                	test   %eax,%eax
801006ae:	74 56                	je     80100706 <cprintf+0x86>
    if(c != '%'){
801006b0:	83 f8 25             	cmp    $0x25,%eax
801006b3:	0f 85 d7 00 00 00    	jne    80100790 <cprintf+0x110>
    c = fmt[++i] & 0xff;
801006b9:	83 c3 01             	add    $0x1,%ebx
801006bc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006c0:	85 d2                	test   %edx,%edx
801006c2:	74 42                	je     80100706 <cprintf+0x86>
    switch(c){
801006c4:	83 fa 70             	cmp    $0x70,%edx
801006c7:	0f 84 94 00 00 00    	je     80100761 <cprintf+0xe1>
801006cd:	7f 51                	jg     80100720 <cprintf+0xa0>
801006cf:	83 fa 25             	cmp    $0x25,%edx
801006d2:	0f 84 48 01 00 00    	je     80100820 <cprintf+0x1a0>
801006d8:	83 fa 64             	cmp    $0x64,%edx
801006db:	0f 85 04 01 00 00    	jne    801007e5 <cprintf+0x165>
      printint(*argp++, 10, 1);
801006e1:	8d 47 04             	lea    0x4(%edi),%eax
801006e4:	b9 01 00 00 00       	mov    $0x1,%ecx
801006e9:	ba 0a 00 00 00       	mov    $0xa,%edx
801006ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801006f1:	8b 07                	mov    (%edi),%eax
801006f3:	e8 d8 fe ff ff       	call   801005d0 <printint>
801006f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fb:	83 c3 01             	add    $0x1,%ebx
801006fe:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100702:	85 c0                	test   %eax,%eax
80100704:	75 aa                	jne    801006b0 <cprintf+0x30>
  if(locking)
80100706:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100709:	85 c0                	test   %eax,%eax
8010070b:	0f 85 b5 01 00 00    	jne    801008c6 <cprintf+0x246>
}
80100711:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100714:	5b                   	pop    %ebx
80100715:	5e                   	pop    %esi
80100716:	5f                   	pop    %edi
80100717:	5d                   	pop    %ebp
80100718:	c3                   	ret    
80100719:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	75 33                	jne    80100758 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100725:	8d 47 04             	lea    0x4(%edi),%eax
80100728:	8b 3f                	mov    (%edi),%edi
8010072a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010072d:	85 ff                	test   %edi,%edi
8010072f:	0f 85 33 01 00 00    	jne    80100868 <cprintf+0x1e8>
        s = "(null)";
80100735:	bf 38 7b 10 80       	mov    $0x80107b38,%edi
      for(; *s; s++)
8010073a:	89 5d dc             	mov    %ebx,-0x24(%ebp)
8010073d:	b8 28 00 00 00       	mov    $0x28,%eax
80100742:	89 fb                	mov    %edi,%ebx
  if(panicked){
80100744:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010074a:	85 d2                	test   %edx,%edx
8010074c:	0f 84 27 01 00 00    	je     80100879 <cprintf+0x1f9>
80100752:	fa                   	cli    
    for(;;)
80100753:	eb fe                	jmp    80100753 <cprintf+0xd3>
80100755:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100758:	83 fa 78             	cmp    $0x78,%edx
8010075b:	0f 85 84 00 00 00    	jne    801007e5 <cprintf+0x165>
      printint(*argp++, 16, 0);
80100761:	8d 47 04             	lea    0x4(%edi),%eax
80100764:	31 c9                	xor    %ecx,%ecx
80100766:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010076b:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010076e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100771:	8b 07                	mov    (%edi),%eax
80100773:	e8 58 fe ff ff       	call   801005d0 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100778:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
8010077c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010077f:	85 c0                	test   %eax,%eax
80100781:	0f 85 29 ff ff ff    	jne    801006b0 <cprintf+0x30>
80100787:	e9 7a ff ff ff       	jmp    80100706 <cprintf+0x86>
8010078c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(panicked){
80100790:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
80100796:	85 c9                	test   %ecx,%ecx
80100798:	74 06                	je     801007a0 <cprintf+0x120>
8010079a:	fa                   	cli    
    for(;;)
8010079b:	eb fe                	jmp    8010079b <cprintf+0x11b>
8010079d:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc(c);
801007a0:	83 ec 0c             	sub    $0xc,%esp
801007a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007a6:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
801007a9:	50                   	push   %eax
801007aa:	e8 51 5e 00 00       	call   80106600 <uartputc>
  cgaputc(c);
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	e8 49 fc ff ff       	call   80100400 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007b7:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      continue;
801007bb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007be:	85 c0                	test   %eax,%eax
801007c0:	0f 85 ea fe ff ff    	jne    801006b0 <cprintf+0x30>
801007c6:	e9 3b ff ff ff       	jmp    80100706 <cprintf+0x86>
801007cb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801007cf:	90                   	nop
    acquire(&cons.lock);
801007d0:	83 ec 0c             	sub    $0xc,%esp
801007d3:	68 20 ff 10 80       	push   $0x8010ff20
801007d8:	e8 b3 45 00 00       	call   80104d90 <acquire>
801007dd:	83 c4 10             	add    $0x10,%esp
801007e0:	e9 b4 fe ff ff       	jmp    80100699 <cprintf+0x19>
  if(panicked){
801007e5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007eb:	85 c9                	test   %ecx,%ecx
801007ed:	75 71                	jne    80100860 <cprintf+0x1e0>
    uartputc(c);
801007ef:	83 ec 0c             	sub    $0xc,%esp
801007f2:	89 55 e0             	mov    %edx,-0x20(%ebp)
801007f5:	6a 25                	push   $0x25
801007f7:	e8 04 5e 00 00       	call   80106600 <uartputc>
  cgaputc(c);
801007fc:	b8 25 00 00 00       	mov    $0x25,%eax
80100801:	e8 fa fb ff ff       	call   80100400 <cgaputc>
  if(panicked){
80100806:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
8010080c:	83 c4 10             	add    $0x10,%esp
8010080f:	85 d2                	test   %edx,%edx
80100811:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100814:	0f 84 8e 00 00 00    	je     801008a8 <cprintf+0x228>
8010081a:	fa                   	cli    
    for(;;)
8010081b:	eb fe                	jmp    8010081b <cprintf+0x19b>
8010081d:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
80100820:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100825:	85 c0                	test   %eax,%eax
80100827:	74 07                	je     80100830 <cprintf+0x1b0>
80100829:	fa                   	cli    
    for(;;)
8010082a:	eb fe                	jmp    8010082a <cprintf+0x1aa>
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    uartputc(c);
80100830:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100833:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100836:	6a 25                	push   $0x25
80100838:	e8 c3 5d 00 00       	call   80106600 <uartputc>
  cgaputc(c);
8010083d:	b8 25 00 00 00       	mov    $0x25,%eax
80100842:	e8 b9 fb ff ff       	call   80100400 <cgaputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100847:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
}
8010084b:	83 c4 10             	add    $0x10,%esp
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010084e:	85 c0                	test   %eax,%eax
80100850:	0f 85 5a fe ff ff    	jne    801006b0 <cprintf+0x30>
80100856:	e9 ab fe ff ff       	jmp    80100706 <cprintf+0x86>
8010085b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010085f:	90                   	nop
80100860:	fa                   	cli    
    for(;;)
80100861:	eb fe                	jmp    80100861 <cprintf+0x1e1>
80100863:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100867:	90                   	nop
      for(; *s; s++)
80100868:	0f b6 07             	movzbl (%edi),%eax
8010086b:	84 c0                	test   %al,%al
8010086d:	74 6c                	je     801008db <cprintf+0x25b>
8010086f:	89 5d dc             	mov    %ebx,-0x24(%ebp)
80100872:	89 fb                	mov    %edi,%ebx
80100874:	e9 cb fe ff ff       	jmp    80100744 <cprintf+0xc4>
    uartputc(c);
80100879:	83 ec 0c             	sub    $0xc,%esp
        consputc(*s);
8010087c:	0f be f8             	movsbl %al,%edi
      for(; *s; s++)
8010087f:	83 c3 01             	add    $0x1,%ebx
    uartputc(c);
80100882:	57                   	push   %edi
80100883:	e8 78 5d 00 00       	call   80106600 <uartputc>
  cgaputc(c);
80100888:	89 f8                	mov    %edi,%eax
8010088a:	e8 71 fb ff ff       	call   80100400 <cgaputc>
      for(; *s; s++)
8010088f:	0f b6 03             	movzbl (%ebx),%eax
80100892:	83 c4 10             	add    $0x10,%esp
80100895:	84 c0                	test   %al,%al
80100897:	0f 85 a7 fe ff ff    	jne    80100744 <cprintf+0xc4>
      if((s = (char*)*argp++) == 0)
8010089d:	8b 5d dc             	mov    -0x24(%ebp),%ebx
801008a0:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008a3:	e9 53 fe ff ff       	jmp    801006fb <cprintf+0x7b>
    uartputc(c);
801008a8:	83 ec 0c             	sub    $0xc,%esp
801008ab:	89 55 e0             	mov    %edx,-0x20(%ebp)
801008ae:	52                   	push   %edx
801008af:	e8 4c 5d 00 00       	call   80106600 <uartputc>
  cgaputc(c);
801008b4:	8b 55 e0             	mov    -0x20(%ebp),%edx
801008b7:	89 d0                	mov    %edx,%eax
801008b9:	e8 42 fb ff ff       	call   80100400 <cgaputc>
}
801008be:	83 c4 10             	add    $0x10,%esp
801008c1:	e9 35 fe ff ff       	jmp    801006fb <cprintf+0x7b>
    release(&cons.lock);
801008c6:	83 ec 0c             	sub    $0xc,%esp
801008c9:	68 20 ff 10 80       	push   $0x8010ff20
801008ce:	e8 5d 44 00 00       	call   80104d30 <release>
801008d3:	83 c4 10             	add    $0x10,%esp
}
801008d6:	e9 36 fe ff ff       	jmp    80100711 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
801008db:	8b 7d e0             	mov    -0x20(%ebp),%edi
801008de:	e9 18 fe ff ff       	jmp    801006fb <cprintf+0x7b>
    panic("null fmt");
801008e3:	83 ec 0c             	sub    $0xc,%esp
801008e6:	68 3f 7b 10 80       	push   $0x80107b3f
801008eb:	e8 90 fa ff ff       	call   80100380 <panic>

801008f0 <consoleintr>:
{
801008f0:	55                   	push   %ebp
801008f1:	89 e5                	mov    %esp,%ebp
801008f3:	57                   	push   %edi
801008f4:	56                   	push   %esi
801008f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801008f6:	31 db                	xor    %ebx,%ebx
{
801008f8:	83 ec 28             	sub    $0x28,%esp
801008fb:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&cons.lock);
801008fe:	68 20 ff 10 80       	push   $0x8010ff20
80100903:	e8 88 44 00 00       	call   80104d90 <acquire>
  while((c = getc()) >= 0){
80100908:	83 c4 10             	add    $0x10,%esp
8010090b:	eb 1a                	jmp    80100927 <consoleintr+0x37>
8010090d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
80100910:	83 f8 08             	cmp    $0x8,%eax
80100913:	0f 84 17 01 00 00    	je     80100a30 <consoleintr+0x140>
80100919:	83 f8 10             	cmp    $0x10,%eax
8010091c:	0f 85 9a 01 00 00    	jne    80100abc <consoleintr+0x1cc>
80100922:	bb 01 00 00 00       	mov    $0x1,%ebx
  while((c = getc()) >= 0){
80100927:	ff d6                	call   *%esi
80100929:	85 c0                	test   %eax,%eax
8010092b:	0f 88 6f 01 00 00    	js     80100aa0 <consoleintr+0x1b0>
    switch(c){
80100931:	83 f8 15             	cmp    $0x15,%eax
80100934:	0f 84 b6 00 00 00    	je     801009f0 <consoleintr+0x100>
8010093a:	7e d4                	jle    80100910 <consoleintr+0x20>
8010093c:	83 f8 7f             	cmp    $0x7f,%eax
8010093f:	0f 84 eb 00 00 00    	je     80100a30 <consoleintr+0x140>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100945:	8b 15 08 ff 10 80    	mov    0x8010ff08,%edx
8010094b:	89 d1                	mov    %edx,%ecx
8010094d:	2b 0d 00 ff 10 80    	sub    0x8010ff00,%ecx
80100953:	83 f9 7f             	cmp    $0x7f,%ecx
80100956:	77 cf                	ja     80100927 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
80100958:	89 d1                	mov    %edx,%ecx
8010095a:	83 c2 01             	add    $0x1,%edx
  if(panicked){
8010095d:	8b 3d 58 ff 10 80    	mov    0x8010ff58,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100963:	89 15 08 ff 10 80    	mov    %edx,0x8010ff08
80100969:	83 e1 7f             	and    $0x7f,%ecx
        c = (c == '\r') ? '\n' : c;
8010096c:	83 f8 0d             	cmp    $0xd,%eax
8010096f:	0f 84 9b 01 00 00    	je     80100b10 <consoleintr+0x220>
        input.buf[input.e++ % INPUT_BUF] = c;
80100975:	88 81 80 fe 10 80    	mov    %al,-0x7fef0180(%ecx)
  if(panicked){
8010097b:	85 ff                	test   %edi,%edi
8010097d:	0f 85 98 01 00 00    	jne    80100b1b <consoleintr+0x22b>
  if(c == BACKSPACE){
80100983:	3d 00 01 00 00       	cmp    $0x100,%eax
80100988:	0f 85 b3 01 00 00    	jne    80100b41 <consoleintr+0x251>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010098e:	83 ec 0c             	sub    $0xc,%esp
80100991:	6a 08                	push   $0x8
80100993:	e8 68 5c 00 00       	call   80106600 <uartputc>
80100998:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010099f:	e8 5c 5c 00 00       	call   80106600 <uartputc>
801009a4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801009ab:	e8 50 5c 00 00       	call   80106600 <uartputc>
  cgaputc(c);
801009b0:	b8 00 01 00 00       	mov    $0x100,%eax
801009b5:	e8 46 fa ff ff       	call   80100400 <cgaputc>
801009ba:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801009bd:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801009c2:	83 e8 80             	sub    $0xffffff80,%eax
801009c5:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
801009cb:	0f 85 56 ff ff ff    	jne    80100927 <consoleintr+0x37>
          wakeup(&input.r);
801009d1:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
801009d4:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
801009d9:	68 00 ff 10 80       	push   $0x8010ff00
801009de:	e8 cd 3c 00 00       	call   801046b0 <wakeup>
801009e3:	83 c4 10             	add    $0x10,%esp
801009e6:	e9 3c ff ff ff       	jmp    80100927 <consoleintr+0x37>
801009eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801009ef:	90                   	nop
      while(input.e != input.w &&
801009f0:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009f5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009fb:	0f 84 26 ff ff ff    	je     80100927 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100a01:	83 e8 01             	sub    $0x1,%eax
80100a04:	89 c2                	mov    %eax,%edx
80100a06:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100a09:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100a10:	0f 84 11 ff ff ff    	je     80100927 <consoleintr+0x37>
  if(panicked){
80100a16:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
80100a1c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100a21:	85 d2                	test   %edx,%edx
80100a23:	74 33                	je     80100a58 <consoleintr+0x168>
80100a25:	fa                   	cli    
    for(;;)
80100a26:	eb fe                	jmp    80100a26 <consoleintr+0x136>
80100a28:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a2f:	90                   	nop
      if(input.e != input.w){
80100a30:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100a35:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100a3b:	0f 84 e6 fe ff ff    	je     80100927 <consoleintr+0x37>
        input.e--;
80100a41:	83 e8 01             	sub    $0x1,%eax
80100a44:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100a49:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
80100a4e:	85 c0                	test   %eax,%eax
80100a50:	74 7e                	je     80100ad0 <consoleintr+0x1e0>
80100a52:	fa                   	cli    
    for(;;)
80100a53:	eb fe                	jmp    80100a53 <consoleintr+0x163>
80100a55:	8d 76 00             	lea    0x0(%esi),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100a58:	83 ec 0c             	sub    $0xc,%esp
80100a5b:	6a 08                	push   $0x8
80100a5d:	e8 9e 5b 00 00       	call   80106600 <uartputc>
80100a62:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100a69:	e8 92 5b 00 00       	call   80106600 <uartputc>
80100a6e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100a75:	e8 86 5b 00 00       	call   80106600 <uartputc>
  cgaputc(c);
80100a7a:	b8 00 01 00 00       	mov    $0x100,%eax
80100a7f:	e8 7c f9 ff ff       	call   80100400 <cgaputc>
      while(input.e != input.w &&
80100a84:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100a89:	83 c4 10             	add    $0x10,%esp
80100a8c:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
80100a92:	0f 85 69 ff ff ff    	jne    80100a01 <consoleintr+0x111>
80100a98:	e9 8a fe ff ff       	jmp    80100927 <consoleintr+0x37>
80100a9d:	8d 76 00             	lea    0x0(%esi),%esi
  release(&cons.lock);
80100aa0:	83 ec 0c             	sub    $0xc,%esp
80100aa3:	68 20 ff 10 80       	push   $0x8010ff20
80100aa8:	e8 83 42 00 00       	call   80104d30 <release>
  if(doprocdump) {
80100aad:	83 c4 10             	add    $0x10,%esp
80100ab0:	85 db                	test   %ebx,%ebx
80100ab2:	75 50                	jne    80100b04 <consoleintr+0x214>
}
80100ab4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ab7:	5b                   	pop    %ebx
80100ab8:	5e                   	pop    %esi
80100ab9:	5f                   	pop    %edi
80100aba:	5d                   	pop    %ebp
80100abb:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100abc:	85 c0                	test   %eax,%eax
80100abe:	0f 84 63 fe ff ff    	je     80100927 <consoleintr+0x37>
80100ac4:	e9 7c fe ff ff       	jmp    80100945 <consoleintr+0x55>
80100ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100ad0:	83 ec 0c             	sub    $0xc,%esp
80100ad3:	6a 08                	push   $0x8
80100ad5:	e8 26 5b 00 00       	call   80106600 <uartputc>
80100ada:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100ae1:	e8 1a 5b 00 00       	call   80106600 <uartputc>
80100ae6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100aed:	e8 0e 5b 00 00       	call   80106600 <uartputc>
  cgaputc(c);
80100af2:	b8 00 01 00 00       	mov    $0x100,%eax
80100af7:	e8 04 f9 ff ff       	call   80100400 <cgaputc>
}
80100afc:	83 c4 10             	add    $0x10,%esp
80100aff:	e9 23 fe ff ff       	jmp    80100927 <consoleintr+0x37>
}
80100b04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b07:	5b                   	pop    %ebx
80100b08:	5e                   	pop    %esi
80100b09:	5f                   	pop    %edi
80100b0a:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100b0b:	e9 80 3c 00 00       	jmp    80104790 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100b10:	c6 81 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%ecx)
  if(panicked){
80100b17:	85 ff                	test   %edi,%edi
80100b19:	74 05                	je     80100b20 <consoleintr+0x230>
80100b1b:	fa                   	cli    
    for(;;)
80100b1c:	eb fe                	jmp    80100b1c <consoleintr+0x22c>
80100b1e:	66 90                	xchg   %ax,%ax
    uartputc(c);
80100b20:	83 ec 0c             	sub    $0xc,%esp
80100b23:	6a 0a                	push   $0xa
80100b25:	e8 d6 5a 00 00       	call   80106600 <uartputc>
  cgaputc(c);
80100b2a:	b8 0a 00 00 00       	mov    $0xa,%eax
80100b2f:	e8 cc f8 ff ff       	call   80100400 <cgaputc>
          input.w = input.e;
80100b34:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100b39:	83 c4 10             	add    $0x10,%esp
80100b3c:	e9 90 fe ff ff       	jmp    801009d1 <consoleintr+0xe1>
    uartputc(c);
80100b41:	83 ec 0c             	sub    $0xc,%esp
80100b44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100b47:	50                   	push   %eax
80100b48:	e8 b3 5a 00 00       	call   80106600 <uartputc>
  cgaputc(c);
80100b4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100b50:	e8 ab f8 ff ff       	call   80100400 <cgaputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100b55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100b58:	83 c4 10             	add    $0x10,%esp
80100b5b:	83 f8 0a             	cmp    $0xa,%eax
80100b5e:	74 09                	je     80100b69 <consoleintr+0x279>
80100b60:	83 f8 04             	cmp    $0x4,%eax
80100b63:	0f 85 54 fe ff ff    	jne    801009bd <consoleintr+0xcd>
          input.w = input.e;
80100b69:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100b6e:	e9 5e fe ff ff       	jmp    801009d1 <consoleintr+0xe1>
80100b73:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100b80 <consoleinit>:

void
consoleinit(void)
{
80100b80:	55                   	push   %ebp
80100b81:	89 e5                	mov    %esp,%ebp
80100b83:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100b86:	68 48 7b 10 80       	push   $0x80107b48
80100b8b:	68 20 ff 10 80       	push   $0x8010ff20
80100b90:	e8 2b 40 00 00       	call   80104bc0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100b95:	58                   	pop    %eax
80100b96:	5a                   	pop    %edx
80100b97:	6a 00                	push   $0x0
80100b99:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100b9b:	c7 05 0c 09 11 80 40 	movl   $0x80100540,0x8011090c
80100ba2:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100ba5:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100bac:	02 10 80 
  cons.locking = 1;
80100baf:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100bb6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100bb9:	e8 d2 19 00 00       	call   80102590 <ioapicenable>
}
80100bbe:	83 c4 10             	add    $0x10,%esp
80100bc1:	c9                   	leave  
80100bc2:	c3                   	ret    
80100bc3:	66 90                	xchg   %ax,%ax
80100bc5:	66 90                	xchg   %ax,%ax
80100bc7:	66 90                	xchg   %ax,%ax
80100bc9:	66 90                	xchg   %ax,%ax
80100bcb:	66 90                	xchg   %ax,%ax
80100bcd:	66 90                	xchg   %ax,%ax
80100bcf:	90                   	nop

80100bd0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100bd0:	55                   	push   %ebp
80100bd1:	89 e5                	mov    %esp,%ebp
80100bd3:	57                   	push   %edi
80100bd4:	56                   	push   %esi
80100bd5:	53                   	push   %ebx
80100bd6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100bdc:	e8 af 2f 00 00       	call   80103b90 <myproc>
80100be1:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100be7:	e8 84 22 00 00       	call   80102e70 <begin_op>

  if((ip = namei(path)) == 0){
80100bec:	83 ec 0c             	sub    $0xc,%esp
80100bef:	ff 75 08             	pushl  0x8(%ebp)
80100bf2:	e8 b9 15 00 00       	call   801021b0 <namei>
80100bf7:	83 c4 10             	add    $0x10,%esp
80100bfa:	85 c0                	test   %eax,%eax
80100bfc:	0f 84 02 03 00 00    	je     80100f04 <exec+0x334>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100c02:	83 ec 0c             	sub    $0xc,%esp
80100c05:	89 c3                	mov    %eax,%ebx
80100c07:	50                   	push   %eax
80100c08:	e8 83 0c 00 00       	call   80101890 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100c0d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100c13:	6a 34                	push   $0x34
80100c15:	6a 00                	push   $0x0
80100c17:	50                   	push   %eax
80100c18:	53                   	push   %ebx
80100c19:	e8 82 0f 00 00       	call   80101ba0 <readi>
80100c1e:	83 c4 20             	add    $0x20,%esp
80100c21:	83 f8 34             	cmp    $0x34,%eax
80100c24:	74 22                	je     80100c48 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100c26:	83 ec 0c             	sub    $0xc,%esp
80100c29:	53                   	push   %ebx
80100c2a:	e8 f1 0e 00 00       	call   80101b20 <iunlockput>
    end_op();
80100c2f:	e8 ac 22 00 00       	call   80102ee0 <end_op>
80100c34:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100c37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100c3f:	5b                   	pop    %ebx
80100c40:	5e                   	pop    %esi
80100c41:	5f                   	pop    %edi
80100c42:	5d                   	pop    %ebp
80100c43:	c3                   	ret    
80100c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100c48:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100c4f:	45 4c 46 
80100c52:	75 d2                	jne    80100c26 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100c54:	e8 37 6b 00 00       	call   80107790 <setupkvm>
80100c59:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100c5f:	85 c0                	test   %eax,%eax
80100c61:	74 c3                	je     80100c26 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c63:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100c6a:	00 
80100c6b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100c71:	0f 84 ac 02 00 00    	je     80100f23 <exec+0x353>
  sz = 0;
80100c77:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100c7e:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c81:	31 ff                	xor    %edi,%edi
80100c83:	e9 8e 00 00 00       	jmp    80100d16 <exec+0x146>
80100c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c8f:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100c90:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100c97:	75 6c                	jne    80100d05 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100c99:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100c9f:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ca5:	0f 82 87 00 00 00    	jb     80100d32 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100cab:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100cb1:	72 7f                	jb     80100d32 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100cb3:	83 ec 04             	sub    $0x4,%esp
80100cb6:	50                   	push   %eax
80100cb7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100cbd:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cc3:	e8 e8 68 00 00       	call   801075b0 <allocuvm>
80100cc8:	83 c4 10             	add    $0x10,%esp
80100ccb:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100cd1:	85 c0                	test   %eax,%eax
80100cd3:	74 5d                	je     80100d32 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100cd5:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100cdb:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100ce0:	75 50                	jne    80100d32 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100ce2:	83 ec 0c             	sub    $0xc,%esp
80100ce5:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100ceb:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100cf1:	53                   	push   %ebx
80100cf2:	50                   	push   %eax
80100cf3:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100cf9:	e8 c2 67 00 00       	call   801074c0 <loaduvm>
80100cfe:	83 c4 20             	add    $0x20,%esp
80100d01:	85 c0                	test   %eax,%eax
80100d03:	78 2d                	js     80100d32 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d05:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100d0c:	83 c7 01             	add    $0x1,%edi
80100d0f:	83 c6 20             	add    $0x20,%esi
80100d12:	39 f8                	cmp    %edi,%eax
80100d14:	7e 3a                	jle    80100d50 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100d16:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100d1c:	6a 20                	push   $0x20
80100d1e:	56                   	push   %esi
80100d1f:	50                   	push   %eax
80100d20:	53                   	push   %ebx
80100d21:	e8 7a 0e 00 00       	call   80101ba0 <readi>
80100d26:	83 c4 10             	add    $0x10,%esp
80100d29:	83 f8 20             	cmp    $0x20,%eax
80100d2c:	0f 84 5e ff ff ff    	je     80100c90 <exec+0xc0>
    freevm(pgdir);
80100d32:	83 ec 0c             	sub    $0xc,%esp
80100d35:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100d3b:	e8 d0 69 00 00       	call   80107710 <freevm>
  if(ip){
80100d40:	83 c4 10             	add    $0x10,%esp
80100d43:	e9 de fe ff ff       	jmp    80100c26 <exec+0x56>
80100d48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100d4f:	90                   	nop
  sz = PGROUNDUP(sz);
80100d50:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100d56:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100d5c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d62:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100d68:	83 ec 0c             	sub    $0xc,%esp
80100d6b:	53                   	push   %ebx
80100d6c:	e8 af 0d 00 00       	call   80101b20 <iunlockput>
  end_op();
80100d71:	e8 6a 21 00 00       	call   80102ee0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d76:	83 c4 0c             	add    $0xc,%esp
80100d79:	56                   	push   %esi
80100d7a:	57                   	push   %edi
80100d7b:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100d81:	57                   	push   %edi
80100d82:	e8 29 68 00 00       	call   801075b0 <allocuvm>
80100d87:	83 c4 10             	add    $0x10,%esp
80100d8a:	89 c6                	mov    %eax,%esi
80100d8c:	85 c0                	test   %eax,%eax
80100d8e:	0f 84 94 00 00 00    	je     80100e28 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d94:	83 ec 08             	sub    $0x8,%esp
80100d97:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100d9d:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d9f:	50                   	push   %eax
80100da0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100da1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100da3:	e8 88 6a 00 00       	call   80107830 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100da8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dab:	83 c4 10             	add    $0x10,%esp
80100dae:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100db4:	8b 00                	mov    (%eax),%eax
80100db6:	85 c0                	test   %eax,%eax
80100db8:	0f 84 8b 00 00 00    	je     80100e49 <exec+0x279>
80100dbe:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100dc4:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100dca:	eb 23                	jmp    80100def <exec+0x21f>
80100dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100dd3:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100dda:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100ddd:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100de3:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100de6:	85 c0                	test   %eax,%eax
80100de8:	74 59                	je     80100e43 <exec+0x273>
    if(argc >= MAXARG)
80100dea:	83 ff 20             	cmp    $0x20,%edi
80100ded:	74 39                	je     80100e28 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100def:	83 ec 0c             	sub    $0xc,%esp
80100df2:	50                   	push   %eax
80100df3:	e8 58 42 00 00       	call   80105050 <strlen>
80100df8:	f7 d0                	not    %eax
80100dfa:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100dfc:	58                   	pop    %eax
80100dfd:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100e00:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100e03:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e06:	e8 45 42 00 00       	call   80105050 <strlen>
80100e0b:	83 c0 01             	add    $0x1,%eax
80100e0e:	50                   	push   %eax
80100e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e12:	ff 34 b8             	pushl  (%eax,%edi,4)
80100e15:	53                   	push   %ebx
80100e16:	56                   	push   %esi
80100e17:	e8 e4 6b 00 00       	call   80107a00 <copyout>
80100e1c:	83 c4 20             	add    $0x20,%esp
80100e1f:	85 c0                	test   %eax,%eax
80100e21:	79 ad                	jns    80100dd0 <exec+0x200>
80100e23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e27:	90                   	nop
    freevm(pgdir);
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
80100e31:	e8 da 68 00 00       	call   80107710 <freevm>
80100e36:	83 c4 10             	add    $0x10,%esp
  return -1;
80100e39:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e3e:	e9 f9 fd ff ff       	jmp    80100c3c <exec+0x6c>
80100e43:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e49:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100e50:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100e52:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100e59:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e5d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100e5f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100e62:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100e68:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e6a:	50                   	push   %eax
80100e6b:	52                   	push   %edx
80100e6c:	53                   	push   %ebx
80100e6d:	ff b5 f4 fe ff ff    	pushl  -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100e73:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100e7a:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e7d:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e83:	e8 78 6b 00 00       	call   80107a00 <copyout>
80100e88:	83 c4 10             	add    $0x10,%esp
80100e8b:	85 c0                	test   %eax,%eax
80100e8d:	78 99                	js     80100e28 <exec+0x258>
  for(last=s=path; *s; s++)
80100e8f:	8b 45 08             	mov    0x8(%ebp),%eax
80100e92:	8b 55 08             	mov    0x8(%ebp),%edx
80100e95:	0f b6 00             	movzbl (%eax),%eax
80100e98:	84 c0                	test   %al,%al
80100e9a:	74 13                	je     80100eaf <exec+0x2df>
80100e9c:	89 d1                	mov    %edx,%ecx
80100e9e:	66 90                	xchg   %ax,%ax
      last = s+1;
80100ea0:	83 c1 01             	add    $0x1,%ecx
80100ea3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100ea5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100ea8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100eab:	84 c0                	test   %al,%al
80100ead:	75 f1                	jne    80100ea0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100eaf:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100eb5:	83 ec 04             	sub    $0x4,%esp
80100eb8:	6a 10                	push   $0x10
80100eba:	89 f8                	mov    %edi,%eax
80100ebc:	52                   	push   %edx
80100ebd:	83 c0 6c             	add    $0x6c,%eax
80100ec0:	50                   	push   %eax
80100ec1:	e8 4a 41 00 00       	call   80105010 <safestrcpy>
  curproc->pgdir = pgdir;
80100ec6:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  oldpgdir = curproc->pgdir;
80100ecc:	89 f8                	mov    %edi,%eax
80100ece:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->sz = sz;
80100ed1:	89 30                	mov    %esi,(%eax)
  curproc->pgdir = pgdir;
80100ed3:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100ed6:	89 c1                	mov    %eax,%ecx
80100ed8:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100ede:	8b 40 18             	mov    0x18(%eax),%eax
80100ee1:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100ee4:	8b 41 18             	mov    0x18(%ecx),%eax
80100ee7:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100eea:	89 0c 24             	mov    %ecx,(%esp)
80100eed:	e8 3e 64 00 00       	call   80107330 <switchuvm>
  freevm(oldpgdir);
80100ef2:	89 3c 24             	mov    %edi,(%esp)
80100ef5:	e8 16 68 00 00       	call   80107710 <freevm>
  return 0;
80100efa:	83 c4 10             	add    $0x10,%esp
80100efd:	31 c0                	xor    %eax,%eax
80100eff:	e9 38 fd ff ff       	jmp    80100c3c <exec+0x6c>
    end_op();
80100f04:	e8 d7 1f 00 00       	call   80102ee0 <end_op>
    cprintf("exec: fail\n");
80100f09:	83 ec 0c             	sub    $0xc,%esp
80100f0c:	68 61 7b 10 80       	push   $0x80107b61
80100f11:	e8 6a f7 ff ff       	call   80100680 <cprintf>
    return -1;
80100f16:	83 c4 10             	add    $0x10,%esp
80100f19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f1e:	e9 19 fd ff ff       	jmp    80100c3c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100f23:	31 ff                	xor    %edi,%edi
80100f25:	be 00 20 00 00       	mov    $0x2000,%esi
80100f2a:	e9 39 fe ff ff       	jmp    80100d68 <exec+0x198>
80100f2f:	90                   	nop

80100f30 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100f36:	68 6d 7b 10 80       	push   $0x80107b6d
80100f3b:	68 60 ff 10 80       	push   $0x8010ff60
80100f40:	e8 7b 3c 00 00       	call   80104bc0 <initlock>
}
80100f45:	83 c4 10             	add    $0x10,%esp
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f54:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100f59:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100f5c:	68 60 ff 10 80       	push   $0x8010ff60
80100f61:	e8 2a 3e 00 00       	call   80104d90 <acquire>
80100f66:	83 c4 10             	add    $0x10,%esp
80100f69:	eb 10                	jmp    80100f7b <filealloc+0x2b>
80100f6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100f6f:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f70:	83 c3 18             	add    $0x18,%ebx
80100f73:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100f79:	74 25                	je     80100fa0 <filealloc+0x50>
    if(f->ref == 0){
80100f7b:	8b 43 04             	mov    0x4(%ebx),%eax
80100f7e:	85 c0                	test   %eax,%eax
80100f80:	75 ee                	jne    80100f70 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100f82:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100f85:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100f8c:	68 60 ff 10 80       	push   $0x8010ff60
80100f91:	e8 9a 3d 00 00       	call   80104d30 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f96:	89 d8                	mov    %ebx,%eax
      return f;
80100f98:	83 c4 10             	add    $0x10,%esp
}
80100f9b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f9e:	c9                   	leave  
80100f9f:	c3                   	ret    
  release(&ftable.lock);
80100fa0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100fa3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100fa5:	68 60 ff 10 80       	push   $0x8010ff60
80100faa:	e8 81 3d 00 00       	call   80104d30 <release>
}
80100faf:	89 d8                	mov    %ebx,%eax
  return 0;
80100fb1:	83 c4 10             	add    $0x10,%esp
}
80100fb4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fb7:	c9                   	leave  
80100fb8:	c3                   	ret    
80100fb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100fc0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	53                   	push   %ebx
80100fc4:	83 ec 10             	sub    $0x10,%esp
80100fc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100fca:	68 60 ff 10 80       	push   $0x8010ff60
80100fcf:	e8 bc 3d 00 00       	call   80104d90 <acquire>
  if(f->ref < 1)
80100fd4:	8b 43 04             	mov    0x4(%ebx),%eax
80100fd7:	83 c4 10             	add    $0x10,%esp
80100fda:	85 c0                	test   %eax,%eax
80100fdc:	7e 1a                	jle    80100ff8 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100fde:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100fe1:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100fe4:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100fe7:	68 60 ff 10 80       	push   $0x8010ff60
80100fec:	e8 3f 3d 00 00       	call   80104d30 <release>
  return f;
}
80100ff1:	89 d8                	mov    %ebx,%eax
80100ff3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ff6:	c9                   	leave  
80100ff7:	c3                   	ret    
    panic("filedup");
80100ff8:	83 ec 0c             	sub    $0xc,%esp
80100ffb:	68 74 7b 10 80       	push   $0x80107b74
80101000:	e8 7b f3 ff ff       	call   80100380 <panic>
80101005:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010100c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101010 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 28             	sub    $0x28,%esp
80101019:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
8010101c:	68 60 ff 10 80       	push   $0x8010ff60
80101021:	e8 6a 3d 00 00       	call   80104d90 <acquire>
  if(f->ref < 1)
80101026:	8b 53 04             	mov    0x4(%ebx),%edx
80101029:	83 c4 10             	add    $0x10,%esp
8010102c:	85 d2                	test   %edx,%edx
8010102e:	0f 8e a5 00 00 00    	jle    801010d9 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80101034:	83 ea 01             	sub    $0x1,%edx
80101037:	89 53 04             	mov    %edx,0x4(%ebx)
8010103a:	75 44                	jne    80101080 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
8010103c:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80101040:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80101043:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80101045:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
8010104b:	8b 73 0c             	mov    0xc(%ebx),%esi
8010104e:	88 45 e7             	mov    %al,-0x19(%ebp)
80101051:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80101054:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80101059:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
8010105c:	e8 cf 3c 00 00       	call   80104d30 <release>

  if(ff.type == FD_PIPE)
80101061:	83 c4 10             	add    $0x10,%esp
80101064:	83 ff 01             	cmp    $0x1,%edi
80101067:	74 57                	je     801010c0 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80101069:	83 ff 02             	cmp    $0x2,%edi
8010106c:	74 2a                	je     80101098 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
8010106e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101071:	5b                   	pop    %ebx
80101072:	5e                   	pop    %esi
80101073:	5f                   	pop    %edi
80101074:	5d                   	pop    %ebp
80101075:	c3                   	ret    
80101076:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010107d:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80101080:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80101087:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010108a:	5b                   	pop    %ebx
8010108b:	5e                   	pop    %esi
8010108c:	5f                   	pop    %edi
8010108d:	5d                   	pop    %ebp
    release(&ftable.lock);
8010108e:	e9 9d 3c 00 00       	jmp    80104d30 <release>
80101093:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101097:	90                   	nop
    begin_op();
80101098:	e8 d3 1d 00 00       	call   80102e70 <begin_op>
    iput(ff.ip);
8010109d:	83 ec 0c             	sub    $0xc,%esp
801010a0:	ff 75 e0             	pushl  -0x20(%ebp)
801010a3:	e8 18 09 00 00       	call   801019c0 <iput>
    end_op();
801010a8:	83 c4 10             	add    $0x10,%esp
}
801010ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010ae:	5b                   	pop    %ebx
801010af:	5e                   	pop    %esi
801010b0:	5f                   	pop    %edi
801010b1:	5d                   	pop    %ebp
    end_op();
801010b2:	e9 29 1e 00 00       	jmp    80102ee0 <end_op>
801010b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010be:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
801010c0:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
801010c4:	83 ec 08             	sub    $0x8,%esp
801010c7:	53                   	push   %ebx
801010c8:	56                   	push   %esi
801010c9:	e8 72 25 00 00       	call   80103640 <pipeclose>
801010ce:	83 c4 10             	add    $0x10,%esp
}
801010d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d4:	5b                   	pop    %ebx
801010d5:	5e                   	pop    %esi
801010d6:	5f                   	pop    %edi
801010d7:	5d                   	pop    %ebp
801010d8:	c3                   	ret    
    panic("fileclose");
801010d9:	83 ec 0c             	sub    $0xc,%esp
801010dc:	68 7c 7b 10 80       	push   $0x80107b7c
801010e1:	e8 9a f2 ff ff       	call   80100380 <panic>
801010e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801010ed:	8d 76 00             	lea    0x0(%esi),%esi

801010f0 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010f0:	55                   	push   %ebp
801010f1:	89 e5                	mov    %esp,%ebp
801010f3:	53                   	push   %ebx
801010f4:	83 ec 04             	sub    $0x4,%esp
801010f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
801010fa:	83 3b 02             	cmpl   $0x2,(%ebx)
801010fd:	75 31                	jne    80101130 <filestat+0x40>
    ilock(f->ip);
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	ff 73 10             	pushl  0x10(%ebx)
80101105:	e8 86 07 00 00       	call   80101890 <ilock>
    stati(f->ip, st);
8010110a:	58                   	pop    %eax
8010110b:	5a                   	pop    %edx
8010110c:	ff 75 0c             	pushl  0xc(%ebp)
8010110f:	ff 73 10             	pushl  0x10(%ebx)
80101112:	e8 59 0a 00 00       	call   80101b70 <stati>
    iunlock(f->ip);
80101117:	59                   	pop    %ecx
80101118:	ff 73 10             	pushl  0x10(%ebx)
8010111b:	e8 50 08 00 00       	call   80101970 <iunlock>
    return 0;
  }
  return -1;
}
80101120:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101123:	83 c4 10             	add    $0x10,%esp
80101126:	31 c0                	xor    %eax,%eax
}
80101128:	c9                   	leave  
80101129:	c3                   	ret    
8010112a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101130:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80101133:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101138:	c9                   	leave  
80101139:	c3                   	ret    
8010113a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101140 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	57                   	push   %edi
80101144:	56                   	push   %esi
80101145:	53                   	push   %ebx
80101146:	83 ec 0c             	sub    $0xc,%esp
80101149:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010114c:	8b 75 0c             	mov    0xc(%ebp),%esi
8010114f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80101152:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80101156:	74 60                	je     801011b8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80101158:	8b 03                	mov    (%ebx),%eax
8010115a:	83 f8 01             	cmp    $0x1,%eax
8010115d:	74 41                	je     801011a0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010115f:	83 f8 02             	cmp    $0x2,%eax
80101162:	75 5b                	jne    801011bf <fileread+0x7f>
    ilock(f->ip);
80101164:	83 ec 0c             	sub    $0xc,%esp
80101167:	ff 73 10             	pushl  0x10(%ebx)
8010116a:	e8 21 07 00 00       	call   80101890 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
8010116f:	57                   	push   %edi
80101170:	ff 73 14             	pushl  0x14(%ebx)
80101173:	56                   	push   %esi
80101174:	ff 73 10             	pushl  0x10(%ebx)
80101177:	e8 24 0a 00 00       	call   80101ba0 <readi>
8010117c:	83 c4 20             	add    $0x20,%esp
8010117f:	89 c6                	mov    %eax,%esi
80101181:	85 c0                	test   %eax,%eax
80101183:	7e 03                	jle    80101188 <fileread+0x48>
      f->off += r;
80101185:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80101188:	83 ec 0c             	sub    $0xc,%esp
8010118b:	ff 73 10             	pushl  0x10(%ebx)
8010118e:	e8 dd 07 00 00       	call   80101970 <iunlock>
    return r;
80101193:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101196:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101199:	89 f0                	mov    %esi,%eax
8010119b:	5b                   	pop    %ebx
8010119c:	5e                   	pop    %esi
8010119d:	5f                   	pop    %edi
8010119e:	5d                   	pop    %ebp
8010119f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
801011a0:	8b 43 0c             	mov    0xc(%ebx),%eax
801011a3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801011a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011a9:	5b                   	pop    %ebx
801011aa:	5e                   	pop    %esi
801011ab:	5f                   	pop    %edi
801011ac:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
801011ad:	e9 2e 26 00 00       	jmp    801037e0 <piperead>
801011b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801011b8:	be ff ff ff ff       	mov    $0xffffffff,%esi
801011bd:	eb d7                	jmp    80101196 <fileread+0x56>
  panic("fileread");
801011bf:	83 ec 0c             	sub    $0xc,%esp
801011c2:	68 86 7b 10 80       	push   $0x80107b86
801011c7:	e8 b4 f1 ff ff       	call   80100380 <panic>
801011cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801011d0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011d0:	55                   	push   %ebp
801011d1:	89 e5                	mov    %esp,%ebp
801011d3:	57                   	push   %edi
801011d4:	56                   	push   %esi
801011d5:	53                   	push   %ebx
801011d6:	83 ec 1c             	sub    $0x1c,%esp
801011d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801011dc:	8b 75 08             	mov    0x8(%ebp),%esi
801011df:	89 45 dc             	mov    %eax,-0x24(%ebp)
801011e2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
801011e5:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
801011e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
801011ec:	0f 84 bd 00 00 00    	je     801012af <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
801011f2:	8b 06                	mov    (%esi),%eax
801011f4:	83 f8 01             	cmp    $0x1,%eax
801011f7:	0f 84 bf 00 00 00    	je     801012bc <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
801011fd:	83 f8 02             	cmp    $0x2,%eax
80101200:	0f 85 c8 00 00 00    	jne    801012ce <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101206:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101209:	31 ff                	xor    %edi,%edi
    while(i < n){
8010120b:	85 c0                	test   %eax,%eax
8010120d:	7f 30                	jg     8010123f <filewrite+0x6f>
8010120f:	e9 94 00 00 00       	jmp    801012a8 <filewrite+0xd8>
80101214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101218:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010121b:	83 ec 0c             	sub    $0xc,%esp
8010121e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101221:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101224:	e8 47 07 00 00       	call   80101970 <iunlock>
      end_op();
80101229:	e8 b2 1c 00 00       	call   80102ee0 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010122e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101231:	83 c4 10             	add    $0x10,%esp
80101234:	39 c3                	cmp    %eax,%ebx
80101236:	75 60                	jne    80101298 <filewrite+0xc8>
        panic("short filewrite");
      i += r;
80101238:	01 df                	add    %ebx,%edi
    while(i < n){
8010123a:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
8010123d:	7e 69                	jle    801012a8 <filewrite+0xd8>
      int n1 = n - i;
8010123f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101242:	b8 00 06 00 00       	mov    $0x600,%eax
80101247:	29 fb                	sub    %edi,%ebx
      if(n1 > max)
80101249:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
8010124f:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101252:	e8 19 1c 00 00       	call   80102e70 <begin_op>
      ilock(f->ip);
80101257:	83 ec 0c             	sub    $0xc,%esp
8010125a:	ff 76 10             	pushl  0x10(%esi)
8010125d:	e8 2e 06 00 00       	call   80101890 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101262:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101265:	53                   	push   %ebx
80101266:	ff 76 14             	pushl  0x14(%esi)
80101269:	01 f8                	add    %edi,%eax
8010126b:	50                   	push   %eax
8010126c:	ff 76 10             	pushl  0x10(%esi)
8010126f:	e8 2c 0a 00 00       	call   80101ca0 <writei>
80101274:	83 c4 20             	add    $0x20,%esp
80101277:	85 c0                	test   %eax,%eax
80101279:	7f 9d                	jg     80101218 <filewrite+0x48>
      iunlock(f->ip);
8010127b:	83 ec 0c             	sub    $0xc,%esp
8010127e:	ff 76 10             	pushl  0x10(%esi)
80101281:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101284:	e8 e7 06 00 00       	call   80101970 <iunlock>
      end_op();
80101289:	e8 52 1c 00 00       	call   80102ee0 <end_op>
      if(r < 0)
8010128e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101291:	83 c4 10             	add    $0x10,%esp
80101294:	85 c0                	test   %eax,%eax
80101296:	75 17                	jne    801012af <filewrite+0xdf>
        panic("short filewrite");
80101298:	83 ec 0c             	sub    $0xc,%esp
8010129b:	68 8f 7b 10 80       	push   $0x80107b8f
801012a0:	e8 db f0 ff ff       	call   80100380 <panic>
801012a5:	8d 76 00             	lea    0x0(%esi),%esi
    }
    return i == n ? n : -1;
801012a8:	89 f8                	mov    %edi,%eax
801012aa:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801012ad:	74 05                	je     801012b4 <filewrite+0xe4>
801012af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801012b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012b7:	5b                   	pop    %ebx
801012b8:	5e                   	pop    %esi
801012b9:	5f                   	pop    %edi
801012ba:	5d                   	pop    %ebp
801012bb:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801012bc:	8b 46 0c             	mov    0xc(%esi),%eax
801012bf:	89 45 08             	mov    %eax,0x8(%ebp)
}
801012c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012c5:	5b                   	pop    %ebx
801012c6:	5e                   	pop    %esi
801012c7:	5f                   	pop    %edi
801012c8:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801012c9:	e9 12 24 00 00       	jmp    801036e0 <pipewrite>
  panic("filewrite");
801012ce:	83 ec 0c             	sub    $0xc,%esp
801012d1:	68 95 7b 10 80       	push   $0x80107b95
801012d6:	e8 a5 f0 ff ff       	call   80100380 <panic>
801012db:	66 90                	xchg   %ax,%ax
801012dd:	66 90                	xchg   %ax,%ax
801012df:	90                   	nop

801012e0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801012e0:	55                   	push   %ebp
801012e1:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
801012e3:	89 d0                	mov    %edx,%eax
801012e5:	c1 e8 0c             	shr    $0xc,%eax
801012e8:	03 05 cc 25 11 80    	add    0x801125cc,%eax
{
801012ee:	89 e5                	mov    %esp,%ebp
801012f0:	56                   	push   %esi
801012f1:	53                   	push   %ebx
801012f2:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
801012f4:	83 ec 08             	sub    $0x8,%esp
801012f7:	50                   	push   %eax
801012f8:	51                   	push   %ecx
801012f9:	e8 d2 ed ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
801012fe:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101300:	c1 fb 03             	sar    $0x3,%ebx
80101303:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101306:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101308:	83 e1 07             	and    $0x7,%ecx
8010130b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101310:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101316:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101318:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010131d:	85 c1                	test   %eax,%ecx
8010131f:	74 23                	je     80101344 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101321:	f7 d0                	not    %eax
  log_write(bp);
80101323:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101326:	21 c8                	and    %ecx,%eax
80101328:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010132c:	56                   	push   %esi
8010132d:	e8 1e 1d 00 00       	call   80103050 <log_write>
  brelse(bp);
80101332:	89 34 24             	mov    %esi,(%esp)
80101335:	e8 b6 ee ff ff       	call   801001f0 <brelse>
}
8010133a:	83 c4 10             	add    $0x10,%esp
8010133d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101340:	5b                   	pop    %ebx
80101341:	5e                   	pop    %esi
80101342:	5d                   	pop    %ebp
80101343:	c3                   	ret    
    panic("freeing free block");
80101344:	83 ec 0c             	sub    $0xc,%esp
80101347:	68 9f 7b 10 80       	push   $0x80107b9f
8010134c:	e8 2f f0 ff ff       	call   80100380 <panic>
80101351:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010135f:	90                   	nop

80101360 <balloc>:
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101369:	8b 0d b4 25 11 80    	mov    0x801125b4,%ecx
{
8010136f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101372:	85 c9                	test   %ecx,%ecx
80101374:	0f 84 87 00 00 00    	je     80101401 <balloc+0xa1>
8010137a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101381:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101384:	83 ec 08             	sub    $0x8,%esp
80101387:	89 f0                	mov    %esi,%eax
80101389:	c1 f8 0c             	sar    $0xc,%eax
8010138c:	03 05 cc 25 11 80    	add    0x801125cc,%eax
80101392:	50                   	push   %eax
80101393:	ff 75 d8             	pushl  -0x28(%ebp)
80101396:	e8 35 ed ff ff       	call   801000d0 <bread>
8010139b:	83 c4 10             	add    $0x10,%esp
8010139e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013a1:	a1 b4 25 11 80       	mov    0x801125b4,%eax
801013a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801013a9:	31 c0                	xor    %eax,%eax
801013ab:	eb 2f                	jmp    801013dc <balloc+0x7c>
801013ad:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801013b0:	89 c1                	mov    %eax,%ecx
801013b2:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013b7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801013ba:	83 e1 07             	and    $0x7,%ecx
801013bd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801013bf:	89 c1                	mov    %eax,%ecx
801013c1:	c1 f9 03             	sar    $0x3,%ecx
801013c4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801013c9:	89 fa                	mov    %edi,%edx
801013cb:	85 df                	test   %ebx,%edi
801013cd:	74 41                	je     80101410 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801013cf:	83 c0 01             	add    $0x1,%eax
801013d2:	83 c6 01             	add    $0x1,%esi
801013d5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801013da:	74 05                	je     801013e1 <balloc+0x81>
801013dc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801013df:	77 cf                	ja     801013b0 <balloc+0x50>
    brelse(bp);
801013e1:	83 ec 0c             	sub    $0xc,%esp
801013e4:	ff 75 e4             	pushl  -0x1c(%ebp)
801013e7:	e8 04 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801013ec:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
801013f3:	83 c4 10             	add    $0x10,%esp
801013f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
801013f9:	39 05 b4 25 11 80    	cmp    %eax,0x801125b4
801013ff:	77 80                	ja     80101381 <balloc+0x21>
  panic("balloc: out of blocks");
80101401:	83 ec 0c             	sub    $0xc,%esp
80101404:	68 b2 7b 10 80       	push   $0x80107bb2
80101409:	e8 72 ef ff ff       	call   80100380 <panic>
8010140e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101410:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101413:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101416:	09 da                	or     %ebx,%edx
80101418:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010141c:	57                   	push   %edi
8010141d:	e8 2e 1c 00 00       	call   80103050 <log_write>
        brelse(bp);
80101422:	89 3c 24             	mov    %edi,(%esp)
80101425:	e8 c6 ed ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010142a:	58                   	pop    %eax
8010142b:	5a                   	pop    %edx
8010142c:	56                   	push   %esi
8010142d:	ff 75 d8             	pushl  -0x28(%ebp)
80101430:	e8 9b ec ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101435:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
80101438:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
8010143a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010143d:	68 00 02 00 00       	push   $0x200
80101442:	6a 00                	push   $0x0
80101444:	50                   	push   %eax
80101445:	e8 06 3a 00 00       	call   80104e50 <memset>
  log_write(bp);
8010144a:	89 1c 24             	mov    %ebx,(%esp)
8010144d:	e8 fe 1b 00 00       	call   80103050 <log_write>
  brelse(bp);
80101452:	89 1c 24             	mov    %ebx,(%esp)
80101455:	e8 96 ed ff ff       	call   801001f0 <brelse>
}
8010145a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010145d:	89 f0                	mov    %esi,%eax
8010145f:	5b                   	pop    %ebx
80101460:	5e                   	pop    %esi
80101461:	5f                   	pop    %edi
80101462:	5d                   	pop    %ebp
80101463:	c3                   	ret    
80101464:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010146b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010146f:	90                   	nop

80101470 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	57                   	push   %edi
80101474:	89 c7                	mov    %eax,%edi
80101476:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101477:	31 f6                	xor    %esi,%esi
{
80101479:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010147a:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
8010147f:	83 ec 28             	sub    $0x28,%esp
80101482:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
80101485:	68 60 09 11 80       	push   $0x80110960
8010148a:	e8 01 39 00 00       	call   80104d90 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010148f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101492:	83 c4 10             	add    $0x10,%esp
80101495:	eb 1b                	jmp    801014b2 <iget+0x42>
80101497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010149e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014a0:	39 3b                	cmp    %edi,(%ebx)
801014a2:	74 6c                	je     80101510 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014a4:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014aa:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801014b0:	73 26                	jae    801014d8 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014b2:	8b 43 08             	mov    0x8(%ebx),%eax
801014b5:	85 c0                	test   %eax,%eax
801014b7:	7f e7                	jg     801014a0 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801014b9:	85 f6                	test   %esi,%esi
801014bb:	75 e7                	jne    801014a4 <iget+0x34>
801014bd:	89 d9                	mov    %ebx,%ecx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014bf:	81 c3 90 00 00 00    	add    $0x90,%ebx
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801014c5:	85 c0                	test   %eax,%eax
801014c7:	75 6e                	jne    80101537 <iget+0xc7>
801014c9:	89 ce                	mov    %ecx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014cb:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
801014d1:	72 df                	jb     801014b2 <iget+0x42>
801014d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801014d7:	90                   	nop
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801014d8:	85 f6                	test   %esi,%esi
801014da:	74 73                	je     8010154f <iget+0xdf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801014dc:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801014df:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801014e1:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801014e4:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801014eb:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801014f2:	68 60 09 11 80       	push   $0x80110960
801014f7:	e8 34 38 00 00       	call   80104d30 <release>

  return ip;
801014fc:	83 c4 10             	add    $0x10,%esp
}
801014ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101502:	89 f0                	mov    %esi,%eax
80101504:	5b                   	pop    %ebx
80101505:	5e                   	pop    %esi
80101506:	5f                   	pop    %edi
80101507:	5d                   	pop    %ebp
80101508:	c3                   	ret    
80101509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101510:	39 53 04             	cmp    %edx,0x4(%ebx)
80101513:	75 8f                	jne    801014a4 <iget+0x34>
      release(&icache.lock);
80101515:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101518:	83 c0 01             	add    $0x1,%eax
      return ip;
8010151b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010151d:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101522:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101525:	e8 06 38 00 00       	call   80104d30 <release>
      return ip;
8010152a:	83 c4 10             	add    $0x10,%esp
}
8010152d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101530:	89 f0                	mov    %esi,%eax
80101532:	5b                   	pop    %ebx
80101533:	5e                   	pop    %esi
80101534:	5f                   	pop    %edi
80101535:	5d                   	pop    %ebp
80101536:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101537:	81 fb b4 25 11 80    	cmp    $0x801125b4,%ebx
8010153d:	73 10                	jae    8010154f <iget+0xdf>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010153f:	8b 43 08             	mov    0x8(%ebx),%eax
80101542:	85 c0                	test   %eax,%eax
80101544:	0f 8f 56 ff ff ff    	jg     801014a0 <iget+0x30>
8010154a:	e9 6e ff ff ff       	jmp    801014bd <iget+0x4d>
    panic("iget: no inodes");
8010154f:	83 ec 0c             	sub    $0xc,%esp
80101552:	68 c8 7b 10 80       	push   $0x80107bc8
80101557:	e8 24 ee ff ff       	call   80100380 <panic>
8010155c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101560 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101560:	55                   	push   %ebp
80101561:	89 e5                	mov    %esp,%ebp
80101563:	57                   	push   %edi
80101564:	56                   	push   %esi
80101565:	89 c6                	mov    %eax,%esi
80101567:	53                   	push   %ebx
80101568:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010156b:	83 fa 0b             	cmp    $0xb,%edx
8010156e:	0f 86 8c 00 00 00    	jbe    80101600 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101574:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
80101577:	83 fb 7f             	cmp    $0x7f,%ebx
8010157a:	0f 87 a2 00 00 00    	ja     80101622 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101580:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
      ip->addrs[bn] = addr = balloc(ip->dev);
80101586:	8b 16                	mov    (%esi),%edx
    if((addr = ip->addrs[NDIRECT]) == 0)
80101588:	85 c0                	test   %eax,%eax
8010158a:	74 5c                	je     801015e8 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010158c:	83 ec 08             	sub    $0x8,%esp
8010158f:	50                   	push   %eax
80101590:	52                   	push   %edx
80101591:	e8 3a eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101596:	83 c4 10             	add    $0x10,%esp
80101599:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010159d:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010159f:	8b 3b                	mov    (%ebx),%edi
801015a1:	85 ff                	test   %edi,%edi
801015a3:	74 1b                	je     801015c0 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
801015a5:	83 ec 0c             	sub    $0xc,%esp
801015a8:	52                   	push   %edx
801015a9:	e8 42 ec ff ff       	call   801001f0 <brelse>
801015ae:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
801015b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801015b4:	89 f8                	mov    %edi,%eax
801015b6:	5b                   	pop    %ebx
801015b7:	5e                   	pop    %esi
801015b8:	5f                   	pop    %edi
801015b9:	5d                   	pop    %ebp
801015ba:	c3                   	ret    
801015bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801015bf:	90                   	nop
801015c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
801015c3:	8b 06                	mov    (%esi),%eax
801015c5:	e8 96 fd ff ff       	call   80101360 <balloc>
      log_write(bp);
801015ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015cd:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801015d0:	89 03                	mov    %eax,(%ebx)
801015d2:	89 c7                	mov    %eax,%edi
      log_write(bp);
801015d4:	52                   	push   %edx
801015d5:	e8 76 1a 00 00       	call   80103050 <log_write>
801015da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015dd:	83 c4 10             	add    $0x10,%esp
801015e0:	eb c3                	jmp    801015a5 <bmap+0x45>
801015e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801015e8:	89 d0                	mov    %edx,%eax
801015ea:	e8 71 fd ff ff       	call   80101360 <balloc>
    bp = bread(ip->dev, addr);
801015ef:	8b 16                	mov    (%esi),%edx
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
801015f1:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
801015f7:	eb 93                	jmp    8010158c <bmap+0x2c>
801015f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[bn]) == 0)
80101600:	8d 5a 14             	lea    0x14(%edx),%ebx
80101603:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101607:	85 ff                	test   %edi,%edi
80101609:	75 a6                	jne    801015b1 <bmap+0x51>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010160b:	8b 00                	mov    (%eax),%eax
8010160d:	e8 4e fd ff ff       	call   80101360 <balloc>
80101612:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101616:	89 c7                	mov    %eax,%edi
}
80101618:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010161b:	5b                   	pop    %ebx
8010161c:	89 f8                	mov    %edi,%eax
8010161e:	5e                   	pop    %esi
8010161f:	5f                   	pop    %edi
80101620:	5d                   	pop    %ebp
80101621:	c3                   	ret    
  panic("bmap: out of range");
80101622:	83 ec 0c             	sub    $0xc,%esp
80101625:	68 d8 7b 10 80       	push   $0x80107bd8
8010162a:	e8 51 ed ff ff       	call   80100380 <panic>
8010162f:	90                   	nop

80101630 <readsb>:
{
80101630:	55                   	push   %ebp
80101631:	89 e5                	mov    %esp,%ebp
80101633:	56                   	push   %esi
80101634:	53                   	push   %ebx
80101635:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101638:	83 ec 08             	sub    $0x8,%esp
8010163b:	6a 01                	push   $0x1
8010163d:	ff 75 08             	pushl  0x8(%ebp)
80101640:	e8 8b ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
80101645:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
80101648:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010164a:	8d 40 5c             	lea    0x5c(%eax),%eax
8010164d:	6a 1c                	push   $0x1c
8010164f:	50                   	push   %eax
80101650:	56                   	push   %esi
80101651:	e8 9a 38 00 00       	call   80104ef0 <memmove>
  brelse(bp);
80101656:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101659:	83 c4 10             	add    $0x10,%esp
}
8010165c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010165f:	5b                   	pop    %ebx
80101660:	5e                   	pop    %esi
80101661:	5d                   	pop    %ebp
  brelse(bp);
80101662:	e9 89 eb ff ff       	jmp    801001f0 <brelse>
80101667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010166e:	66 90                	xchg   %ax,%ax

80101670 <iinit>:
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	53                   	push   %ebx
80101674:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
80101679:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010167c:	68 eb 7b 10 80       	push   $0x80107beb
80101681:	68 60 09 11 80       	push   $0x80110960
80101686:	e8 35 35 00 00       	call   80104bc0 <initlock>
  for(i = 0; i < NINODE; i++) {
8010168b:	83 c4 10             	add    $0x10,%esp
8010168e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101690:	83 ec 08             	sub    $0x8,%esp
80101693:	68 f2 7b 10 80       	push   $0x80107bf2
80101698:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101699:	81 c3 90 00 00 00    	add    $0x90,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010169f:	e8 ec 33 00 00       	call   80104a90 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801016a4:	83 c4 10             	add    $0x10,%esp
801016a7:	81 fb c0 25 11 80    	cmp    $0x801125c0,%ebx
801016ad:	75 e1                	jne    80101690 <iinit+0x20>
  bp = bread(dev, 1);
801016af:	83 ec 08             	sub    $0x8,%esp
801016b2:	6a 01                	push   $0x1
801016b4:	ff 75 08             	pushl  0x8(%ebp)
801016b7:	e8 14 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801016bc:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801016bf:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801016c1:	8d 40 5c             	lea    0x5c(%eax),%eax
801016c4:	6a 1c                	push   $0x1c
801016c6:	50                   	push   %eax
801016c7:	68 b4 25 11 80       	push   $0x801125b4
801016cc:	e8 1f 38 00 00       	call   80104ef0 <memmove>
  brelse(bp);
801016d1:	89 1c 24             	mov    %ebx,(%esp)
801016d4:	e8 17 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801016d9:	ff 35 cc 25 11 80    	pushl  0x801125cc
801016df:	ff 35 c8 25 11 80    	pushl  0x801125c8
801016e5:	ff 35 c4 25 11 80    	pushl  0x801125c4
801016eb:	ff 35 c0 25 11 80    	pushl  0x801125c0
801016f1:	ff 35 bc 25 11 80    	pushl  0x801125bc
801016f7:	ff 35 b8 25 11 80    	pushl  0x801125b8
801016fd:	ff 35 b4 25 11 80    	pushl  0x801125b4
80101703:	68 58 7c 10 80       	push   $0x80107c58
80101708:	e8 73 ef ff ff       	call   80100680 <cprintf>
}
8010170d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101710:	83 c4 30             	add    $0x30,%esp
80101713:	c9                   	leave  
80101714:	c3                   	ret    
80101715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010171c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101720 <ialloc>:
{
80101720:	55                   	push   %ebp
80101721:	89 e5                	mov    %esp,%ebp
80101723:	57                   	push   %edi
80101724:	56                   	push   %esi
80101725:	53                   	push   %ebx
80101726:	83 ec 1c             	sub    $0x1c,%esp
80101729:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010172c:	83 3d bc 25 11 80 01 	cmpl   $0x1,0x801125bc
{
80101733:	8b 75 08             	mov    0x8(%ebp),%esi
80101736:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101739:	0f 86 91 00 00 00    	jbe    801017d0 <ialloc+0xb0>
8010173f:	bf 01 00 00 00       	mov    $0x1,%edi
80101744:	eb 21                	jmp    80101767 <ialloc+0x47>
80101746:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010174d:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
80101750:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101753:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
80101756:	53                   	push   %ebx
80101757:	e8 94 ea ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010175c:	83 c4 10             	add    $0x10,%esp
8010175f:	3b 3d bc 25 11 80    	cmp    0x801125bc,%edi
80101765:	73 69                	jae    801017d0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101767:	89 f8                	mov    %edi,%eax
80101769:	83 ec 08             	sub    $0x8,%esp
8010176c:	c1 e8 03             	shr    $0x3,%eax
8010176f:	03 05 c8 25 11 80    	add    0x801125c8,%eax
80101775:	50                   	push   %eax
80101776:	56                   	push   %esi
80101777:	e8 54 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
8010177c:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
8010177f:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101781:	89 f8                	mov    %edi,%eax
80101783:	83 e0 07             	and    $0x7,%eax
80101786:	c1 e0 06             	shl    $0x6,%eax
80101789:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010178d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101791:	75 bd                	jne    80101750 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101793:	83 ec 04             	sub    $0x4,%esp
80101796:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101799:	6a 40                	push   $0x40
8010179b:	6a 00                	push   $0x0
8010179d:	51                   	push   %ecx
8010179e:	e8 ad 36 00 00       	call   80104e50 <memset>
      dip->type = type;
801017a3:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
801017a7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
801017aa:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801017ad:	89 1c 24             	mov    %ebx,(%esp)
801017b0:	e8 9b 18 00 00       	call   80103050 <log_write>
      brelse(bp);
801017b5:	89 1c 24             	mov    %ebx,(%esp)
801017b8:	e8 33 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
801017bd:	83 c4 10             	add    $0x10,%esp
}
801017c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801017c3:	89 fa                	mov    %edi,%edx
}
801017c5:	5b                   	pop    %ebx
      return iget(dev, inum);
801017c6:	89 f0                	mov    %esi,%eax
}
801017c8:	5e                   	pop    %esi
801017c9:	5f                   	pop    %edi
801017ca:	5d                   	pop    %ebp
      return iget(dev, inum);
801017cb:	e9 a0 fc ff ff       	jmp    80101470 <iget>
  panic("ialloc: no inodes");
801017d0:	83 ec 0c             	sub    $0xc,%esp
801017d3:	68 f8 7b 10 80       	push   $0x80107bf8
801017d8:	e8 a3 eb ff ff       	call   80100380 <panic>
801017dd:	8d 76 00             	lea    0x0(%esi),%esi

801017e0 <iupdate>:
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	56                   	push   %esi
801017e4:	53                   	push   %ebx
801017e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017e8:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017eb:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017ee:	83 ec 08             	sub    $0x8,%esp
801017f1:	c1 e8 03             	shr    $0x3,%eax
801017f4:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801017fa:	50                   	push   %eax
801017fb:	ff 73 a4             	pushl  -0x5c(%ebx)
801017fe:	e8 cd e8 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101803:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101807:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010180a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010180c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010180f:	83 e0 07             	and    $0x7,%eax
80101812:	c1 e0 06             	shl    $0x6,%eax
80101815:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101819:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010181c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101820:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101823:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101827:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010182b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010182f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101833:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101837:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010183a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010183d:	6a 34                	push   $0x34
8010183f:	53                   	push   %ebx
80101840:	50                   	push   %eax
80101841:	e8 aa 36 00 00       	call   80104ef0 <memmove>
  log_write(bp);
80101846:	89 34 24             	mov    %esi,(%esp)
80101849:	e8 02 18 00 00       	call   80103050 <log_write>
  brelse(bp);
8010184e:	89 75 08             	mov    %esi,0x8(%ebp)
80101851:	83 c4 10             	add    $0x10,%esp
}
80101854:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101857:	5b                   	pop    %ebx
80101858:	5e                   	pop    %esi
80101859:	5d                   	pop    %ebp
  brelse(bp);
8010185a:	e9 91 e9 ff ff       	jmp    801001f0 <brelse>
8010185f:	90                   	nop

80101860 <idup>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	53                   	push   %ebx
80101864:	83 ec 10             	sub    $0x10,%esp
80101867:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010186a:	68 60 09 11 80       	push   $0x80110960
8010186f:	e8 1c 35 00 00       	call   80104d90 <acquire>
  ip->ref++;
80101874:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101878:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010187f:	e8 ac 34 00 00       	call   80104d30 <release>
}
80101884:	89 d8                	mov    %ebx,%eax
80101886:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101889:	c9                   	leave  
8010188a:	c3                   	ret    
8010188b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010188f:	90                   	nop

80101890 <ilock>:
{
80101890:	55                   	push   %ebp
80101891:	89 e5                	mov    %esp,%ebp
80101893:	56                   	push   %esi
80101894:	53                   	push   %ebx
80101895:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101898:	85 db                	test   %ebx,%ebx
8010189a:	0f 84 b7 00 00 00    	je     80101957 <ilock+0xc7>
801018a0:	8b 53 08             	mov    0x8(%ebx),%edx
801018a3:	85 d2                	test   %edx,%edx
801018a5:	0f 8e ac 00 00 00    	jle    80101957 <ilock+0xc7>
  acquiresleep(&ip->lock);
801018ab:	83 ec 0c             	sub    $0xc,%esp
801018ae:	8d 43 0c             	lea    0xc(%ebx),%eax
801018b1:	50                   	push   %eax
801018b2:	e8 19 32 00 00       	call   80104ad0 <acquiresleep>
  if(ip->valid == 0){
801018b7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801018ba:	83 c4 10             	add    $0x10,%esp
801018bd:	85 c0                	test   %eax,%eax
801018bf:	74 0f                	je     801018d0 <ilock+0x40>
}
801018c1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801018c4:	5b                   	pop    %ebx
801018c5:	5e                   	pop    %esi
801018c6:	5d                   	pop    %ebp
801018c7:	c3                   	ret    
801018c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018cf:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018d0:	8b 43 04             	mov    0x4(%ebx),%eax
801018d3:	83 ec 08             	sub    $0x8,%esp
801018d6:	c1 e8 03             	shr    $0x3,%eax
801018d9:	03 05 c8 25 11 80    	add    0x801125c8,%eax
801018df:	50                   	push   %eax
801018e0:	ff 33                	pushl  (%ebx)
801018e2:	e8 e9 e7 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018e7:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801018ea:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801018ec:	8b 43 04             	mov    0x4(%ebx),%eax
801018ef:	83 e0 07             	and    $0x7,%eax
801018f2:	c1 e0 06             	shl    $0x6,%eax
801018f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801018f9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018fc:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801018ff:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101903:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
80101907:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010190b:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
8010190f:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101913:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101917:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010191b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010191e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101921:	6a 34                	push   $0x34
80101923:	50                   	push   %eax
80101924:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101927:	50                   	push   %eax
80101928:	e8 c3 35 00 00       	call   80104ef0 <memmove>
    brelse(bp);
8010192d:	89 34 24             	mov    %esi,(%esp)
80101930:	e8 bb e8 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
80101935:	83 c4 10             	add    $0x10,%esp
80101938:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010193d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101944:	0f 85 77 ff ff ff    	jne    801018c1 <ilock+0x31>
      panic("ilock: no type");
8010194a:	83 ec 0c             	sub    $0xc,%esp
8010194d:	68 10 7c 10 80       	push   $0x80107c10
80101952:	e8 29 ea ff ff       	call   80100380 <panic>
    panic("ilock");
80101957:	83 ec 0c             	sub    $0xc,%esp
8010195a:	68 0a 7c 10 80       	push   $0x80107c0a
8010195f:	e8 1c ea ff ff       	call   80100380 <panic>
80101964:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010196b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010196f:	90                   	nop

80101970 <iunlock>:
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	56                   	push   %esi
80101974:	53                   	push   %ebx
80101975:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101978:	85 db                	test   %ebx,%ebx
8010197a:	74 28                	je     801019a4 <iunlock+0x34>
8010197c:	83 ec 0c             	sub    $0xc,%esp
8010197f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101982:	56                   	push   %esi
80101983:	e8 e8 31 00 00       	call   80104b70 <holdingsleep>
80101988:	83 c4 10             	add    $0x10,%esp
8010198b:	85 c0                	test   %eax,%eax
8010198d:	74 15                	je     801019a4 <iunlock+0x34>
8010198f:	8b 43 08             	mov    0x8(%ebx),%eax
80101992:	85 c0                	test   %eax,%eax
80101994:	7e 0e                	jle    801019a4 <iunlock+0x34>
  releasesleep(&ip->lock);
80101996:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101999:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010199c:	5b                   	pop    %ebx
8010199d:	5e                   	pop    %esi
8010199e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010199f:	e9 8c 31 00 00       	jmp    80104b30 <releasesleep>
    panic("iunlock");
801019a4:	83 ec 0c             	sub    $0xc,%esp
801019a7:	68 1f 7c 10 80       	push   $0x80107c1f
801019ac:	e8 cf e9 ff ff       	call   80100380 <panic>
801019b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801019bf:	90                   	nop

801019c0 <iput>:
{
801019c0:	55                   	push   %ebp
801019c1:	89 e5                	mov    %esp,%ebp
801019c3:	57                   	push   %edi
801019c4:	56                   	push   %esi
801019c5:	53                   	push   %ebx
801019c6:	83 ec 28             	sub    $0x28,%esp
801019c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801019cc:	8d 7b 0c             	lea    0xc(%ebx),%edi
801019cf:	57                   	push   %edi
801019d0:	e8 fb 30 00 00       	call   80104ad0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801019d5:	8b 53 4c             	mov    0x4c(%ebx),%edx
801019d8:	83 c4 10             	add    $0x10,%esp
801019db:	85 d2                	test   %edx,%edx
801019dd:	74 07                	je     801019e6 <iput+0x26>
801019df:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801019e4:	74 32                	je     80101a18 <iput+0x58>
  releasesleep(&ip->lock);
801019e6:	83 ec 0c             	sub    $0xc,%esp
801019e9:	57                   	push   %edi
801019ea:	e8 41 31 00 00       	call   80104b30 <releasesleep>
  acquire(&icache.lock);
801019ef:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801019f6:	e8 95 33 00 00       	call   80104d90 <acquire>
  ip->ref--;
801019fb:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
801019ff:	83 c4 10             	add    $0x10,%esp
80101a02:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
80101a09:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a0c:	5b                   	pop    %ebx
80101a0d:	5e                   	pop    %esi
80101a0e:	5f                   	pop    %edi
80101a0f:	5d                   	pop    %ebp
  release(&icache.lock);
80101a10:	e9 1b 33 00 00       	jmp    80104d30 <release>
80101a15:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
80101a18:	83 ec 0c             	sub    $0xc,%esp
80101a1b:	68 60 09 11 80       	push   $0x80110960
80101a20:	e8 6b 33 00 00       	call   80104d90 <acquire>
    int r = ip->ref;
80101a25:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
80101a28:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101a2f:	e8 fc 32 00 00       	call   80104d30 <release>
    if(r == 1){
80101a34:	83 c4 10             	add    $0x10,%esp
80101a37:	83 fe 01             	cmp    $0x1,%esi
80101a3a:	75 aa                	jne    801019e6 <iput+0x26>
80101a3c:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
80101a42:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101a45:	8d 73 5c             	lea    0x5c(%ebx),%esi
80101a48:	89 cf                	mov    %ecx,%edi
80101a4a:	eb 0b                	jmp    80101a57 <iput+0x97>
80101a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101a50:	83 c6 04             	add    $0x4,%esi
80101a53:	39 fe                	cmp    %edi,%esi
80101a55:	74 19                	je     80101a70 <iput+0xb0>
    if(ip->addrs[i]){
80101a57:	8b 16                	mov    (%esi),%edx
80101a59:	85 d2                	test   %edx,%edx
80101a5b:	74 f3                	je     80101a50 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
80101a5d:	8b 03                	mov    (%ebx),%eax
80101a5f:	e8 7c f8 ff ff       	call   801012e0 <bfree>
      ip->addrs[i] = 0;
80101a64:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a6a:	eb e4                	jmp    80101a50 <iput+0x90>
80101a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a70:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a76:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a79:	85 c0                	test   %eax,%eax
80101a7b:	75 2d                	jne    80101aaa <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a7d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a80:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a87:	53                   	push   %ebx
80101a88:	e8 53 fd ff ff       	call   801017e0 <iupdate>
      ip->type = 0;
80101a8d:	31 c0                	xor    %eax,%eax
80101a8f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a93:	89 1c 24             	mov    %ebx,(%esp)
80101a96:	e8 45 fd ff ff       	call   801017e0 <iupdate>
      ip->valid = 0;
80101a9b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101aa2:	83 c4 10             	add    $0x10,%esp
80101aa5:	e9 3c ff ff ff       	jmp    801019e6 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101aaa:	83 ec 08             	sub    $0x8,%esp
80101aad:	50                   	push   %eax
80101aae:	ff 33                	pushl  (%ebx)
80101ab0:	e8 1b e6 ff ff       	call   801000d0 <bread>
80101ab5:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101ab8:	83 c4 10             	add    $0x10,%esp
80101abb:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101ac1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101ac4:	8d 70 5c             	lea    0x5c(%eax),%esi
80101ac7:	89 cf                	mov    %ecx,%edi
80101ac9:	eb 0c                	jmp    80101ad7 <iput+0x117>
80101acb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101acf:	90                   	nop
80101ad0:	83 c6 04             	add    $0x4,%esi
80101ad3:	39 f7                	cmp    %esi,%edi
80101ad5:	74 0f                	je     80101ae6 <iput+0x126>
      if(a[j])
80101ad7:	8b 16                	mov    (%esi),%edx
80101ad9:	85 d2                	test   %edx,%edx
80101adb:	74 f3                	je     80101ad0 <iput+0x110>
        bfree(ip->dev, a[j]);
80101add:	8b 03                	mov    (%ebx),%eax
80101adf:	e8 fc f7 ff ff       	call   801012e0 <bfree>
80101ae4:	eb ea                	jmp    80101ad0 <iput+0x110>
    brelse(bp);
80101ae6:	83 ec 0c             	sub    $0xc,%esp
80101ae9:	ff 75 e4             	pushl  -0x1c(%ebp)
80101aec:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101aef:	e8 fc e6 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101af4:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101afa:	8b 03                	mov    (%ebx),%eax
80101afc:	e8 df f7 ff ff       	call   801012e0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101b01:	83 c4 10             	add    $0x10,%esp
80101b04:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101b0b:	00 00 00 
80101b0e:	e9 6a ff ff ff       	jmp    80101a7d <iput+0xbd>
80101b13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101b20 <iunlockput>:
{
80101b20:	55                   	push   %ebp
80101b21:	89 e5                	mov    %esp,%ebp
80101b23:	56                   	push   %esi
80101b24:	53                   	push   %ebx
80101b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101b28:	85 db                	test   %ebx,%ebx
80101b2a:	74 34                	je     80101b60 <iunlockput+0x40>
80101b2c:	83 ec 0c             	sub    $0xc,%esp
80101b2f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101b32:	56                   	push   %esi
80101b33:	e8 38 30 00 00       	call   80104b70 <holdingsleep>
80101b38:	83 c4 10             	add    $0x10,%esp
80101b3b:	85 c0                	test   %eax,%eax
80101b3d:	74 21                	je     80101b60 <iunlockput+0x40>
80101b3f:	8b 43 08             	mov    0x8(%ebx),%eax
80101b42:	85 c0                	test   %eax,%eax
80101b44:	7e 1a                	jle    80101b60 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101b46:	83 ec 0c             	sub    $0xc,%esp
80101b49:	56                   	push   %esi
80101b4a:	e8 e1 2f 00 00       	call   80104b30 <releasesleep>
  iput(ip);
80101b4f:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101b52:	83 c4 10             	add    $0x10,%esp
}
80101b55:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101b58:	5b                   	pop    %ebx
80101b59:	5e                   	pop    %esi
80101b5a:	5d                   	pop    %ebp
  iput(ip);
80101b5b:	e9 60 fe ff ff       	jmp    801019c0 <iput>
    panic("iunlock");
80101b60:	83 ec 0c             	sub    $0xc,%esp
80101b63:	68 1f 7c 10 80       	push   $0x80107c1f
80101b68:	e8 13 e8 ff ff       	call   80100380 <panic>
80101b6d:	8d 76 00             	lea    0x0(%esi),%esi

80101b70 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b70:	55                   	push   %ebp
80101b71:	89 e5                	mov    %esp,%ebp
80101b73:	8b 55 08             	mov    0x8(%ebp),%edx
80101b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b79:	8b 0a                	mov    (%edx),%ecx
80101b7b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b7e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b81:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b84:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b88:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b8b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b8f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b93:	8b 52 58             	mov    0x58(%edx),%edx
80101b96:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b99:	5d                   	pop    %ebp
80101b9a:	c3                   	ret    
80101b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b9f:	90                   	nop

80101ba0 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101bac:	8b 45 08             	mov    0x8(%ebp),%eax
80101baf:	8b 75 10             	mov    0x10(%ebp),%esi
80101bb2:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101bb5:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101bb8:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101bbd:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101bc0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101bc3:	0f 84 a7 00 00 00    	je     80101c70 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101bc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101bcc:	8b 40 58             	mov    0x58(%eax),%eax
80101bcf:	39 c6                	cmp    %eax,%esi
80101bd1:	0f 87 ba 00 00 00    	ja     80101c91 <readi+0xf1>
80101bd7:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bda:	31 c9                	xor    %ecx,%ecx
80101bdc:	89 da                	mov    %ebx,%edx
80101bde:	01 f2                	add    %esi,%edx
80101be0:	0f 92 c1             	setb   %cl
80101be3:	89 cf                	mov    %ecx,%edi
80101be5:	0f 82 a6 00 00 00    	jb     80101c91 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101beb:	89 c1                	mov    %eax,%ecx
80101bed:	29 f1                	sub    %esi,%ecx
80101bef:	39 d0                	cmp    %edx,%eax
80101bf1:	0f 43 cb             	cmovae %ebx,%ecx
80101bf4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bf7:	85 c9                	test   %ecx,%ecx
80101bf9:	74 67                	je     80101c62 <readi+0xc2>
80101bfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c00:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101c03:	89 f2                	mov    %esi,%edx
80101c05:	c1 ea 09             	shr    $0x9,%edx
80101c08:	89 d8                	mov    %ebx,%eax
80101c0a:	e8 51 f9 ff ff       	call   80101560 <bmap>
80101c0f:	83 ec 08             	sub    $0x8,%esp
80101c12:	50                   	push   %eax
80101c13:	ff 33                	pushl  (%ebx)
80101c15:	e8 b6 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c1a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101c1d:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c22:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c25:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101c27:	89 f0                	mov    %esi,%eax
80101c29:	25 ff 01 00 00       	and    $0x1ff,%eax
80101c2e:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c30:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101c33:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101c35:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101c39:	39 d9                	cmp    %ebx,%ecx
80101c3b:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101c3e:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c3f:	01 df                	add    %ebx,%edi
80101c41:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101c43:	50                   	push   %eax
80101c44:	ff 75 e0             	pushl  -0x20(%ebp)
80101c47:	e8 a4 32 00 00       	call   80104ef0 <memmove>
    brelse(bp);
80101c4c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101c4f:	89 14 24             	mov    %edx,(%esp)
80101c52:	e8 99 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101c57:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101c5a:	83 c4 10             	add    $0x10,%esp
80101c5d:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c60:	77 9e                	ja     80101c00 <readi+0x60>
  }
  return n;
80101c62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c68:	5b                   	pop    %ebx
80101c69:	5e                   	pop    %esi
80101c6a:	5f                   	pop    %edi
80101c6b:	5d                   	pop    %ebp
80101c6c:	c3                   	ret    
80101c6d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c74:	66 83 f8 09          	cmp    $0x9,%ax
80101c78:	77 17                	ja     80101c91 <readi+0xf1>
80101c7a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101c81:	85 c0                	test   %eax,%eax
80101c83:	74 0c                	je     80101c91 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c85:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c8b:	5b                   	pop    %ebx
80101c8c:	5e                   	pop    %esi
80101c8d:	5f                   	pop    %edi
80101c8e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c8f:	ff e0                	jmp    *%eax
      return -1;
80101c91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c96:	eb cd                	jmp    80101c65 <readi+0xc5>
80101c98:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c9f:	90                   	nop

80101ca0 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101ca0:	55                   	push   %ebp
80101ca1:	89 e5                	mov    %esp,%ebp
80101ca3:	57                   	push   %edi
80101ca4:	56                   	push   %esi
80101ca5:	53                   	push   %ebx
80101ca6:	83 ec 1c             	sub    $0x1c,%esp
80101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
80101cac:	8b 75 0c             	mov    0xc(%ebp),%esi
80101caf:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101cb2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101cb7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101cba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101cbd:	8b 75 10             	mov    0x10(%ebp),%esi
80101cc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101cc3:	0f 84 b7 00 00 00    	je     80101d80 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101cc9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101ccc:	3b 70 58             	cmp    0x58(%eax),%esi
80101ccf:	0f 87 e7 00 00 00    	ja     80101dbc <writei+0x11c>
80101cd5:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101cd8:	31 d2                	xor    %edx,%edx
80101cda:	89 f8                	mov    %edi,%eax
80101cdc:	01 f0                	add    %esi,%eax
80101cde:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ce1:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ce6:	0f 87 d0 00 00 00    	ja     80101dbc <writei+0x11c>
80101cec:	85 d2                	test   %edx,%edx
80101cee:	0f 85 c8 00 00 00    	jne    80101dbc <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cf4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101cfb:	85 ff                	test   %edi,%edi
80101cfd:	74 72                	je     80101d71 <writei+0xd1>
80101cff:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d00:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101d03:	89 f2                	mov    %esi,%edx
80101d05:	c1 ea 09             	shr    $0x9,%edx
80101d08:	89 f8                	mov    %edi,%eax
80101d0a:	e8 51 f8 ff ff       	call   80101560 <bmap>
80101d0f:	83 ec 08             	sub    $0x8,%esp
80101d12:	50                   	push   %eax
80101d13:	ff 37                	pushl  (%edi)
80101d15:	e8 b6 e3 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101d1a:	b9 00 02 00 00       	mov    $0x200,%ecx
80101d1f:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101d22:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101d25:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101d27:	89 f0                	mov    %esi,%eax
80101d29:	83 c4 0c             	add    $0xc,%esp
80101d2c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101d31:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101d33:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101d37:	39 d9                	cmp    %ebx,%ecx
80101d39:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101d3c:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d3d:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101d3f:	ff 75 dc             	pushl  -0x24(%ebp)
80101d42:	50                   	push   %eax
80101d43:	e8 a8 31 00 00       	call   80104ef0 <memmove>
    log_write(bp);
80101d48:	89 3c 24             	mov    %edi,(%esp)
80101d4b:	e8 00 13 00 00       	call   80103050 <log_write>
    brelse(bp);
80101d50:	89 3c 24             	mov    %edi,(%esp)
80101d53:	e8 98 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101d58:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101d5b:	83 c4 10             	add    $0x10,%esp
80101d5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d61:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d64:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101d67:	77 97                	ja     80101d00 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101d6f:	77 37                	ja     80101da8 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d71:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d77:	5b                   	pop    %ebx
80101d78:	5e                   	pop    %esi
80101d79:	5f                   	pop    %edi
80101d7a:	5d                   	pop    %ebp
80101d7b:	c3                   	ret    
80101d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d80:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d84:	66 83 f8 09          	cmp    $0x9,%ax
80101d88:	77 32                	ja     80101dbc <writei+0x11c>
80101d8a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101d91:	85 c0                	test   %eax,%eax
80101d93:	74 27                	je     80101dbc <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101d95:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d9b:	5b                   	pop    %ebx
80101d9c:	5e                   	pop    %esi
80101d9d:	5f                   	pop    %edi
80101d9e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d9f:	ff e0                	jmp    *%eax
80101da1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101da8:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101dab:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101dae:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101db1:	50                   	push   %eax
80101db2:	e8 29 fa ff ff       	call   801017e0 <iupdate>
80101db7:	83 c4 10             	add    $0x10,%esp
80101dba:	eb b5                	jmp    80101d71 <writei+0xd1>
      return -1;
80101dbc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101dc1:	eb b1                	jmp    80101d74 <writei+0xd4>
80101dc3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101dd0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101dd0:	55                   	push   %ebp
80101dd1:	89 e5                	mov    %esp,%ebp
80101dd3:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101dd6:	6a 0e                	push   $0xe
80101dd8:	ff 75 0c             	pushl  0xc(%ebp)
80101ddb:	ff 75 08             	pushl  0x8(%ebp)
80101dde:	e8 7d 31 00 00       	call   80104f60 <strncmp>
}
80101de3:	c9                   	leave  
80101de4:	c3                   	ret    
80101de5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101df0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	56                   	push   %esi
80101df5:	53                   	push   %ebx
80101df6:	83 ec 1c             	sub    $0x1c,%esp
80101df9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101dfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101e01:	0f 85 85 00 00 00    	jne    80101e8c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101e07:	8b 53 58             	mov    0x58(%ebx),%edx
80101e0a:	31 ff                	xor    %edi,%edi
80101e0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e0f:	85 d2                	test   %edx,%edx
80101e11:	74 3e                	je     80101e51 <dirlookup+0x61>
80101e13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e17:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e18:	6a 10                	push   $0x10
80101e1a:	57                   	push   %edi
80101e1b:	56                   	push   %esi
80101e1c:	53                   	push   %ebx
80101e1d:	e8 7e fd ff ff       	call   80101ba0 <readi>
80101e22:	83 c4 10             	add    $0x10,%esp
80101e25:	83 f8 10             	cmp    $0x10,%eax
80101e28:	75 55                	jne    80101e7f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101e2a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e2f:	74 18                	je     80101e49 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101e31:	83 ec 04             	sub    $0x4,%esp
80101e34:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e37:	6a 0e                	push   $0xe
80101e39:	50                   	push   %eax
80101e3a:	ff 75 0c             	pushl  0xc(%ebp)
80101e3d:	e8 1e 31 00 00       	call   80104f60 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	85 c0                	test   %eax,%eax
80101e47:	74 17                	je     80101e60 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e49:	83 c7 10             	add    $0x10,%edi
80101e4c:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101e4f:	72 c7                	jb     80101e18 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101e54:	31 c0                	xor    %eax,%eax
}
80101e56:	5b                   	pop    %ebx
80101e57:	5e                   	pop    %esi
80101e58:	5f                   	pop    %edi
80101e59:	5d                   	pop    %ebp
80101e5a:	c3                   	ret    
80101e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101e5f:	90                   	nop
      if(poff)
80101e60:	8b 45 10             	mov    0x10(%ebp),%eax
80101e63:	85 c0                	test   %eax,%eax
80101e65:	74 05                	je     80101e6c <dirlookup+0x7c>
        *poff = off;
80101e67:	8b 45 10             	mov    0x10(%ebp),%eax
80101e6a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e6c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e70:	8b 03                	mov    (%ebx),%eax
80101e72:	e8 f9 f5 ff ff       	call   80101470 <iget>
}
80101e77:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e7a:	5b                   	pop    %ebx
80101e7b:	5e                   	pop    %esi
80101e7c:	5f                   	pop    %edi
80101e7d:	5d                   	pop    %ebp
80101e7e:	c3                   	ret    
      panic("dirlookup read");
80101e7f:	83 ec 0c             	sub    $0xc,%esp
80101e82:	68 39 7c 10 80       	push   $0x80107c39
80101e87:	e8 f4 e4 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101e8c:	83 ec 0c             	sub    $0xc,%esp
80101e8f:	68 27 7c 10 80       	push   $0x80107c27
80101e94:	e8 e7 e4 ff ff       	call   80100380 <panic>
80101e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101ea0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ea0:	55                   	push   %ebp
80101ea1:	89 e5                	mov    %esp,%ebp
80101ea3:	57                   	push   %edi
80101ea4:	56                   	push   %esi
80101ea5:	53                   	push   %ebx
80101ea6:	89 c3                	mov    %eax,%ebx
80101ea8:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101eab:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101eae:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101eb1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101eb4:	0f 84 64 01 00 00    	je     8010201e <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101eba:	e8 d1 1c 00 00       	call   80103b90 <myproc>
  acquire(&icache.lock);
80101ebf:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101ec2:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101ec5:	68 60 09 11 80       	push   $0x80110960
80101eca:	e8 c1 2e 00 00       	call   80104d90 <acquire>
  ip->ref++;
80101ecf:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ed3:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101eda:	e8 51 2e 00 00       	call   80104d30 <release>
80101edf:	83 c4 10             	add    $0x10,%esp
80101ee2:	eb 07                	jmp    80101eeb <namex+0x4b>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ee8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101eeb:	0f b6 03             	movzbl (%ebx),%eax
80101eee:	3c 2f                	cmp    $0x2f,%al
80101ef0:	74 f6                	je     80101ee8 <namex+0x48>
  if(*path == 0)
80101ef2:	84 c0                	test   %al,%al
80101ef4:	0f 84 06 01 00 00    	je     80102000 <namex+0x160>
  while(*path != '/' && *path != 0)
80101efa:	0f b6 03             	movzbl (%ebx),%eax
80101efd:	84 c0                	test   %al,%al
80101eff:	0f 84 10 01 00 00    	je     80102015 <namex+0x175>
80101f05:	89 df                	mov    %ebx,%edi
80101f07:	3c 2f                	cmp    $0x2f,%al
80101f09:	0f 84 06 01 00 00    	je     80102015 <namex+0x175>
80101f0f:	90                   	nop
80101f10:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101f14:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101f17:	3c 2f                	cmp    $0x2f,%al
80101f19:	74 04                	je     80101f1f <namex+0x7f>
80101f1b:	84 c0                	test   %al,%al
80101f1d:	75 f1                	jne    80101f10 <namex+0x70>
  len = path - s;
80101f1f:	89 f8                	mov    %edi,%eax
80101f21:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101f23:	83 f8 0d             	cmp    $0xd,%eax
80101f26:	0f 8e ac 00 00 00    	jle    80101fd8 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101f2c:	83 ec 04             	sub    $0x4,%esp
80101f2f:	6a 0e                	push   $0xe
80101f31:	53                   	push   %ebx
    path++;
80101f32:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101f34:	ff 75 e4             	pushl  -0x1c(%ebp)
80101f37:	e8 b4 2f 00 00       	call   80104ef0 <memmove>
80101f3c:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101f3f:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101f42:	75 0c                	jne    80101f50 <namex+0xb0>
80101f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101f48:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101f4b:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101f4e:	74 f8                	je     80101f48 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101f50:	83 ec 0c             	sub    $0xc,%esp
80101f53:	56                   	push   %esi
80101f54:	e8 37 f9 ff ff       	call   80101890 <ilock>
    if(ip->type != T_DIR){
80101f59:	83 c4 10             	add    $0x10,%esp
80101f5c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f61:	0f 85 cd 00 00 00    	jne    80102034 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f67:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f6a:	85 c0                	test   %eax,%eax
80101f6c:	74 09                	je     80101f77 <namex+0xd7>
80101f6e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f71:	0f 84 22 01 00 00    	je     80102099 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f77:	83 ec 04             	sub    $0x4,%esp
80101f7a:	6a 00                	push   $0x0
80101f7c:	ff 75 e4             	pushl  -0x1c(%ebp)
80101f7f:	56                   	push   %esi
80101f80:	e8 6b fe ff ff       	call   80101df0 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f85:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101f88:	83 c4 10             	add    $0x10,%esp
80101f8b:	89 c7                	mov    %eax,%edi
80101f8d:	85 c0                	test   %eax,%eax
80101f8f:	0f 84 e1 00 00 00    	je     80102076 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f95:	83 ec 0c             	sub    $0xc,%esp
80101f98:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f9b:	52                   	push   %edx
80101f9c:	e8 cf 2b 00 00       	call   80104b70 <holdingsleep>
80101fa1:	83 c4 10             	add    $0x10,%esp
80101fa4:	85 c0                	test   %eax,%eax
80101fa6:	0f 84 30 01 00 00    	je     801020dc <namex+0x23c>
80101fac:	8b 56 08             	mov    0x8(%esi),%edx
80101faf:	85 d2                	test   %edx,%edx
80101fb1:	0f 8e 25 01 00 00    	jle    801020dc <namex+0x23c>
  releasesleep(&ip->lock);
80101fb7:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101fba:	83 ec 0c             	sub    $0xc,%esp
80101fbd:	52                   	push   %edx
80101fbe:	e8 6d 2b 00 00       	call   80104b30 <releasesleep>
  iput(ip);
80101fc3:	89 34 24             	mov    %esi,(%esp)
80101fc6:	89 fe                	mov    %edi,%esi
80101fc8:	e8 f3 f9 ff ff       	call   801019c0 <iput>
80101fcd:	83 c4 10             	add    $0x10,%esp
80101fd0:	e9 16 ff ff ff       	jmp    80101eeb <namex+0x4b>
80101fd5:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101fd8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101fdb:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101fde:	83 ec 04             	sub    $0x4,%esp
80101fe1:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101fe4:	50                   	push   %eax
80101fe5:	53                   	push   %ebx
    name[len] = 0;
80101fe6:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101fe8:	ff 75 e4             	pushl  -0x1c(%ebp)
80101feb:	e8 00 2f 00 00       	call   80104ef0 <memmove>
    name[len] = 0;
80101ff0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ff3:	83 c4 10             	add    $0x10,%esp
80101ff6:	c6 02 00             	movb   $0x0,(%edx)
80101ff9:	e9 41 ff ff ff       	jmp    80101f3f <namex+0x9f>
80101ffe:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102000:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102003:	85 c0                	test   %eax,%eax
80102005:	0f 85 be 00 00 00    	jne    801020c9 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
8010200b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010200e:	89 f0                	mov    %esi,%eax
80102010:	5b                   	pop    %ebx
80102011:	5e                   	pop    %esi
80102012:	5f                   	pop    %edi
80102013:	5d                   	pop    %ebp
80102014:	c3                   	ret    
  while(*path != '/' && *path != 0)
80102015:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102018:	89 df                	mov    %ebx,%edi
8010201a:	31 c0                	xor    %eax,%eax
8010201c:	eb c0                	jmp    80101fde <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
8010201e:	ba 01 00 00 00       	mov    $0x1,%edx
80102023:	b8 01 00 00 00       	mov    $0x1,%eax
80102028:	e8 43 f4 ff ff       	call   80101470 <iget>
8010202d:	89 c6                	mov    %eax,%esi
8010202f:	e9 b7 fe ff ff       	jmp    80101eeb <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102034:	83 ec 0c             	sub    $0xc,%esp
80102037:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010203a:	53                   	push   %ebx
8010203b:	e8 30 2b 00 00       	call   80104b70 <holdingsleep>
80102040:	83 c4 10             	add    $0x10,%esp
80102043:	85 c0                	test   %eax,%eax
80102045:	0f 84 91 00 00 00    	je     801020dc <namex+0x23c>
8010204b:	8b 46 08             	mov    0x8(%esi),%eax
8010204e:	85 c0                	test   %eax,%eax
80102050:	0f 8e 86 00 00 00    	jle    801020dc <namex+0x23c>
  releasesleep(&ip->lock);
80102056:	83 ec 0c             	sub    $0xc,%esp
80102059:	53                   	push   %ebx
8010205a:	e8 d1 2a 00 00       	call   80104b30 <releasesleep>
  iput(ip);
8010205f:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102062:	31 f6                	xor    %esi,%esi
  iput(ip);
80102064:	e8 57 f9 ff ff       	call   801019c0 <iput>
      return 0;
80102069:	83 c4 10             	add    $0x10,%esp
}
8010206c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010206f:	89 f0                	mov    %esi,%eax
80102071:	5b                   	pop    %ebx
80102072:	5e                   	pop    %esi
80102073:	5f                   	pop    %edi
80102074:	5d                   	pop    %ebp
80102075:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102076:	83 ec 0c             	sub    $0xc,%esp
80102079:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010207c:	52                   	push   %edx
8010207d:	e8 ee 2a 00 00       	call   80104b70 <holdingsleep>
80102082:	83 c4 10             	add    $0x10,%esp
80102085:	85 c0                	test   %eax,%eax
80102087:	74 53                	je     801020dc <namex+0x23c>
80102089:	8b 4e 08             	mov    0x8(%esi),%ecx
8010208c:	85 c9                	test   %ecx,%ecx
8010208e:	7e 4c                	jle    801020dc <namex+0x23c>
  releasesleep(&ip->lock);
80102090:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102093:	83 ec 0c             	sub    $0xc,%esp
80102096:	52                   	push   %edx
80102097:	eb c1                	jmp    8010205a <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102099:	83 ec 0c             	sub    $0xc,%esp
8010209c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010209f:	53                   	push   %ebx
801020a0:	e8 cb 2a 00 00       	call   80104b70 <holdingsleep>
801020a5:	83 c4 10             	add    $0x10,%esp
801020a8:	85 c0                	test   %eax,%eax
801020aa:	74 30                	je     801020dc <namex+0x23c>
801020ac:	8b 7e 08             	mov    0x8(%esi),%edi
801020af:	85 ff                	test   %edi,%edi
801020b1:	7e 29                	jle    801020dc <namex+0x23c>
  releasesleep(&ip->lock);
801020b3:	83 ec 0c             	sub    $0xc,%esp
801020b6:	53                   	push   %ebx
801020b7:	e8 74 2a 00 00       	call   80104b30 <releasesleep>
}
801020bc:	83 c4 10             	add    $0x10,%esp
}
801020bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020c2:	89 f0                	mov    %esi,%eax
801020c4:	5b                   	pop    %ebx
801020c5:	5e                   	pop    %esi
801020c6:	5f                   	pop    %edi
801020c7:	5d                   	pop    %ebp
801020c8:	c3                   	ret    
    iput(ip);
801020c9:	83 ec 0c             	sub    $0xc,%esp
801020cc:	56                   	push   %esi
    return 0;
801020cd:	31 f6                	xor    %esi,%esi
    iput(ip);
801020cf:	e8 ec f8 ff ff       	call   801019c0 <iput>
    return 0;
801020d4:	83 c4 10             	add    $0x10,%esp
801020d7:	e9 2f ff ff ff       	jmp    8010200b <namex+0x16b>
    panic("iunlock");
801020dc:	83 ec 0c             	sub    $0xc,%esp
801020df:	68 1f 7c 10 80       	push   $0x80107c1f
801020e4:	e8 97 e2 ff ff       	call   80100380 <panic>
801020e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020f0 <dirlink>:
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	57                   	push   %edi
801020f4:	56                   	push   %esi
801020f5:	53                   	push   %ebx
801020f6:	83 ec 20             	sub    $0x20,%esp
801020f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
801020fc:	6a 00                	push   $0x0
801020fe:	ff 75 0c             	pushl  0xc(%ebp)
80102101:	53                   	push   %ebx
80102102:	e8 e9 fc ff ff       	call   80101df0 <dirlookup>
80102107:	83 c4 10             	add    $0x10,%esp
8010210a:	85 c0                	test   %eax,%eax
8010210c:	75 67                	jne    80102175 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
8010210e:	8b 7b 58             	mov    0x58(%ebx),%edi
80102111:	8d 75 d8             	lea    -0x28(%ebp),%esi
80102114:	85 ff                	test   %edi,%edi
80102116:	74 29                	je     80102141 <dirlink+0x51>
80102118:	31 ff                	xor    %edi,%edi
8010211a:	8d 75 d8             	lea    -0x28(%ebp),%esi
8010211d:	eb 09                	jmp    80102128 <dirlink+0x38>
8010211f:	90                   	nop
80102120:	83 c7 10             	add    $0x10,%edi
80102123:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102126:	73 19                	jae    80102141 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102128:	6a 10                	push   $0x10
8010212a:	57                   	push   %edi
8010212b:	56                   	push   %esi
8010212c:	53                   	push   %ebx
8010212d:	e8 6e fa ff ff       	call   80101ba0 <readi>
80102132:	83 c4 10             	add    $0x10,%esp
80102135:	83 f8 10             	cmp    $0x10,%eax
80102138:	75 4e                	jne    80102188 <dirlink+0x98>
    if(de.inum == 0)
8010213a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010213f:	75 df                	jne    80102120 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102141:	83 ec 04             	sub    $0x4,%esp
80102144:	8d 45 da             	lea    -0x26(%ebp),%eax
80102147:	6a 0e                	push   $0xe
80102149:	ff 75 0c             	pushl  0xc(%ebp)
8010214c:	50                   	push   %eax
8010214d:	e8 5e 2e 00 00       	call   80104fb0 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102152:	6a 10                	push   $0x10
  de.inum = inum;
80102154:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102157:	57                   	push   %edi
80102158:	56                   	push   %esi
80102159:	53                   	push   %ebx
  de.inum = inum;
8010215a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010215e:	e8 3d fb ff ff       	call   80101ca0 <writei>
80102163:	83 c4 20             	add    $0x20,%esp
80102166:	83 f8 10             	cmp    $0x10,%eax
80102169:	75 2a                	jne    80102195 <dirlink+0xa5>
  return 0;
8010216b:	31 c0                	xor    %eax,%eax
}
8010216d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102170:	5b                   	pop    %ebx
80102171:	5e                   	pop    %esi
80102172:	5f                   	pop    %edi
80102173:	5d                   	pop    %ebp
80102174:	c3                   	ret    
    iput(ip);
80102175:	83 ec 0c             	sub    $0xc,%esp
80102178:	50                   	push   %eax
80102179:	e8 42 f8 ff ff       	call   801019c0 <iput>
    return -1;
8010217e:	83 c4 10             	add    $0x10,%esp
80102181:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102186:	eb e5                	jmp    8010216d <dirlink+0x7d>
      panic("dirlink read");
80102188:	83 ec 0c             	sub    $0xc,%esp
8010218b:	68 48 7c 10 80       	push   $0x80107c48
80102190:	e8 eb e1 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102195:	83 ec 0c             	sub    $0xc,%esp
80102198:	68 72 83 10 80       	push   $0x80108372
8010219d:	e8 de e1 ff ff       	call   80100380 <panic>
801021a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801021b0 <namei>:

struct inode*
namei(char *path)
{
801021b0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
801021b1:	31 d2                	xor    %edx,%edx
{
801021b3:	89 e5                	mov    %esp,%ebp
801021b5:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
801021b8:	8b 45 08             	mov    0x8(%ebp),%eax
801021bb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
801021be:	e8 dd fc ff ff       	call   80101ea0 <namex>
}
801021c3:	c9                   	leave  
801021c4:	c3                   	ret    
801021c5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801021d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801021d0:	55                   	push   %ebp
  return namex(path, 1, name);
801021d1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801021d6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801021d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801021db:	8b 45 08             	mov    0x8(%ebp),%eax
}
801021de:	5d                   	pop    %ebp
  return namex(path, 1, name);
801021df:	e9 bc fc ff ff       	jmp    80101ea0 <namex>
801021e4:	66 90                	xchg   %ax,%ax
801021e6:	66 90                	xchg   %ax,%ax
801021e8:	66 90                	xchg   %ax,%ax
801021ea:	66 90                	xchg   %ax,%ax
801021ec:	66 90                	xchg   %ax,%ax
801021ee:	66 90                	xchg   %ax,%ax

801021f0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801021f0:	55                   	push   %ebp
801021f1:	89 e5                	mov    %esp,%ebp
801021f3:	57                   	push   %edi
801021f4:	56                   	push   %esi
801021f5:	53                   	push   %ebx
801021f6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801021f9:	85 c0                	test   %eax,%eax
801021fb:	0f 84 b4 00 00 00    	je     801022b5 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80102201:	8b 70 08             	mov    0x8(%eax),%esi
80102204:	89 c3                	mov    %eax,%ebx
80102206:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
8010220c:	0f 87 96 00 00 00    	ja     801022a8 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102212:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
80102217:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010221e:	66 90                	xchg   %ax,%ax
80102220:	89 ca                	mov    %ecx,%edx
80102222:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102223:	83 e0 c0             	and    $0xffffffc0,%eax
80102226:	3c 40                	cmp    $0x40,%al
80102228:	75 f6                	jne    80102220 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010222a:	31 ff                	xor    %edi,%edi
8010222c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102231:	89 f8                	mov    %edi,%eax
80102233:	ee                   	out    %al,(%dx)
80102234:	b8 01 00 00 00       	mov    $0x1,%eax
80102239:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010223e:	ee                   	out    %al,(%dx)
8010223f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102244:	89 f0                	mov    %esi,%eax
80102246:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102247:	89 f0                	mov    %esi,%eax
80102249:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010224e:	c1 f8 08             	sar    $0x8,%eax
80102251:	ee                   	out    %al,(%dx)
80102252:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102257:	89 f8                	mov    %edi,%eax
80102259:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010225a:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
8010225e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102263:	c1 e0 04             	shl    $0x4,%eax
80102266:	83 e0 10             	and    $0x10,%eax
80102269:	83 c8 e0             	or     $0xffffffe0,%eax
8010226c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010226d:	f6 03 04             	testb  $0x4,(%ebx)
80102270:	75 16                	jne    80102288 <idestart+0x98>
80102272:	b8 20 00 00 00       	mov    $0x20,%eax
80102277:	89 ca                	mov    %ecx,%edx
80102279:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010227a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010227d:	5b                   	pop    %ebx
8010227e:	5e                   	pop    %esi
8010227f:	5f                   	pop    %edi
80102280:	5d                   	pop    %ebp
80102281:	c3                   	ret    
80102282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102288:	b8 30 00 00 00       	mov    $0x30,%eax
8010228d:	89 ca                	mov    %ecx,%edx
8010228f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102290:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102295:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102298:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010229d:	fc                   	cld    
8010229e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
801022a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022a3:	5b                   	pop    %ebx
801022a4:	5e                   	pop    %esi
801022a5:	5f                   	pop    %edi
801022a6:	5d                   	pop    %ebp
801022a7:	c3                   	ret    
    panic("incorrect blockno");
801022a8:	83 ec 0c             	sub    $0xc,%esp
801022ab:	68 b4 7c 10 80       	push   $0x80107cb4
801022b0:	e8 cb e0 ff ff       	call   80100380 <panic>
    panic("idestart");
801022b5:	83 ec 0c             	sub    $0xc,%esp
801022b8:	68 ab 7c 10 80       	push   $0x80107cab
801022bd:	e8 be e0 ff ff       	call   80100380 <panic>
801022c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801022d0 <ideinit>:
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801022d6:	68 c6 7c 10 80       	push   $0x80107cc6
801022db:	68 00 26 11 80       	push   $0x80112600
801022e0:	e8 db 28 00 00       	call   80104bc0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801022e5:	58                   	pop    %eax
801022e6:	a1 84 27 11 80       	mov    0x80112784,%eax
801022eb:	5a                   	pop    %edx
801022ec:	83 e8 01             	sub    $0x1,%eax
801022ef:	50                   	push   %eax
801022f0:	6a 0e                	push   $0xe
801022f2:	e8 99 02 00 00       	call   80102590 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801022f7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022fa:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022ff:	90                   	nop
80102300:	ec                   	in     (%dx),%al
80102301:	83 e0 c0             	and    $0xffffffc0,%eax
80102304:	3c 40                	cmp    $0x40,%al
80102306:	75 f8                	jne    80102300 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102308:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010230d:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102312:	ee                   	out    %al,(%dx)
80102313:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102318:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010231d:	eb 06                	jmp    80102325 <ideinit+0x55>
8010231f:	90                   	nop
  for(i=0; i<1000; i++){
80102320:	83 e9 01             	sub    $0x1,%ecx
80102323:	74 0f                	je     80102334 <ideinit+0x64>
80102325:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102326:	84 c0                	test   %al,%al
80102328:	74 f6                	je     80102320 <ideinit+0x50>
      havedisk1 = 1;
8010232a:	c7 05 e0 25 11 80 01 	movl   $0x1,0x801125e0
80102331:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102334:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102339:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010233e:	ee                   	out    %al,(%dx)
}
8010233f:	c9                   	leave  
80102340:	c3                   	ret    
80102341:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102348:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010234f:	90                   	nop

80102350 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102350:	55                   	push   %ebp
80102351:	89 e5                	mov    %esp,%ebp
80102353:	57                   	push   %edi
80102354:	56                   	push   %esi
80102355:	53                   	push   %ebx
80102356:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102359:	68 00 26 11 80       	push   $0x80112600
8010235e:	e8 2d 2a 00 00       	call   80104d90 <acquire>

  if((b = idequeue) == 0){
80102363:	8b 1d e4 25 11 80    	mov    0x801125e4,%ebx
80102369:	83 c4 10             	add    $0x10,%esp
8010236c:	85 db                	test   %ebx,%ebx
8010236e:	74 63                	je     801023d3 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102370:	8b 43 58             	mov    0x58(%ebx),%eax
80102373:	a3 e4 25 11 80       	mov    %eax,0x801125e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102378:	8b 33                	mov    (%ebx),%esi
8010237a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102380:	75 2f                	jne    801023b1 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102382:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102387:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010238e:	66 90                	xchg   %ax,%ax
80102390:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102391:	89 c1                	mov    %eax,%ecx
80102393:	83 e1 c0             	and    $0xffffffc0,%ecx
80102396:	80 f9 40             	cmp    $0x40,%cl
80102399:	75 f5                	jne    80102390 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010239b:	a8 21                	test   $0x21,%al
8010239d:	75 12                	jne    801023b1 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010239f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
801023a2:	b9 80 00 00 00       	mov    $0x80,%ecx
801023a7:	ba f0 01 00 00       	mov    $0x1f0,%edx
801023ac:	fc                   	cld    
801023ad:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801023af:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
801023b1:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
801023b4:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
801023b7:	83 ce 02             	or     $0x2,%esi
801023ba:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801023bc:	53                   	push   %ebx
801023bd:	e8 ee 22 00 00       	call   801046b0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801023c2:	a1 e4 25 11 80       	mov    0x801125e4,%eax
801023c7:	83 c4 10             	add    $0x10,%esp
801023ca:	85 c0                	test   %eax,%eax
801023cc:	74 05                	je     801023d3 <ideintr+0x83>
    idestart(idequeue);
801023ce:	e8 1d fe ff ff       	call   801021f0 <idestart>
    release(&idelock);
801023d3:	83 ec 0c             	sub    $0xc,%esp
801023d6:	68 00 26 11 80       	push   $0x80112600
801023db:	e8 50 29 00 00       	call   80104d30 <release>

  release(&idelock);
}
801023e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801023e3:	5b                   	pop    %ebx
801023e4:	5e                   	pop    %esi
801023e5:	5f                   	pop    %edi
801023e6:	5d                   	pop    %ebp
801023e7:	c3                   	ret    
801023e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801023ef:	90                   	nop

801023f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	53                   	push   %ebx
801023f4:	83 ec 10             	sub    $0x10,%esp
801023f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801023fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801023fd:	50                   	push   %eax
801023fe:	e8 6d 27 00 00       	call   80104b70 <holdingsleep>
80102403:	83 c4 10             	add    $0x10,%esp
80102406:	85 c0                	test   %eax,%eax
80102408:	0f 84 c3 00 00 00    	je     801024d1 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010240e:	8b 03                	mov    (%ebx),%eax
80102410:	83 e0 06             	and    $0x6,%eax
80102413:	83 f8 02             	cmp    $0x2,%eax
80102416:	0f 84 a8 00 00 00    	je     801024c4 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010241c:	8b 53 04             	mov    0x4(%ebx),%edx
8010241f:	85 d2                	test   %edx,%edx
80102421:	74 0d                	je     80102430 <iderw+0x40>
80102423:	a1 e0 25 11 80       	mov    0x801125e0,%eax
80102428:	85 c0                	test   %eax,%eax
8010242a:	0f 84 87 00 00 00    	je     801024b7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102430:	83 ec 0c             	sub    $0xc,%esp
80102433:	68 00 26 11 80       	push   $0x80112600
80102438:	e8 53 29 00 00       	call   80104d90 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010243d:	a1 e4 25 11 80       	mov    0x801125e4,%eax
  b->qnext = 0;
80102442:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102449:	83 c4 10             	add    $0x10,%esp
8010244c:	85 c0                	test   %eax,%eax
8010244e:	74 60                	je     801024b0 <iderw+0xc0>
80102450:	89 c2                	mov    %eax,%edx
80102452:	8b 40 58             	mov    0x58(%eax),%eax
80102455:	85 c0                	test   %eax,%eax
80102457:	75 f7                	jne    80102450 <iderw+0x60>
80102459:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
8010245c:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
8010245e:	39 1d e4 25 11 80    	cmp    %ebx,0x801125e4
80102464:	74 3a                	je     801024a0 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102466:	8b 03                	mov    (%ebx),%eax
80102468:	83 e0 06             	and    $0x6,%eax
8010246b:	83 f8 02             	cmp    $0x2,%eax
8010246e:	74 1b                	je     8010248b <iderw+0x9b>
    sleep(b, &idelock);
80102470:	83 ec 08             	sub    $0x8,%esp
80102473:	68 00 26 11 80       	push   $0x80112600
80102478:	53                   	push   %ebx
80102479:	e8 72 21 00 00       	call   801045f0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010247e:	8b 03                	mov    (%ebx),%eax
80102480:	83 c4 10             	add    $0x10,%esp
80102483:	83 e0 06             	and    $0x6,%eax
80102486:	83 f8 02             	cmp    $0x2,%eax
80102489:	75 e5                	jne    80102470 <iderw+0x80>
  }


  release(&idelock);
8010248b:	c7 45 08 00 26 11 80 	movl   $0x80112600,0x8(%ebp)
}
80102492:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102495:	c9                   	leave  
  release(&idelock);
80102496:	e9 95 28 00 00       	jmp    80104d30 <release>
8010249b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010249f:	90                   	nop
    idestart(b);
801024a0:	89 d8                	mov    %ebx,%eax
801024a2:	e8 49 fd ff ff       	call   801021f0 <idestart>
801024a7:	eb bd                	jmp    80102466 <iderw+0x76>
801024a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801024b0:	ba e4 25 11 80       	mov    $0x801125e4,%edx
801024b5:	eb a5                	jmp    8010245c <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
801024b7:	83 ec 0c             	sub    $0xc,%esp
801024ba:	68 f5 7c 10 80       	push   $0x80107cf5
801024bf:	e8 bc de ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
801024c4:	83 ec 0c             	sub    $0xc,%esp
801024c7:	68 e0 7c 10 80       	push   $0x80107ce0
801024cc:	e8 af de ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
801024d1:	83 ec 0c             	sub    $0xc,%esp
801024d4:	68 ca 7c 10 80       	push   $0x80107cca
801024d9:	e8 a2 de ff ff       	call   80100380 <panic>
801024de:	66 90                	xchg   %ax,%ax

801024e0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801024e0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801024e1:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
801024e8:	00 c0 fe 
{
801024eb:	89 e5                	mov    %esp,%ebp
801024ed:	56                   	push   %esi
801024ee:	53                   	push   %ebx
  ioapic->reg = reg;
801024ef:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801024f6:	00 00 00 
  return ioapic->data;
801024f9:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801024ff:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
80102502:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102508:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010250e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102515:	c1 ee 10             	shr    $0x10,%esi
80102518:	89 f0                	mov    %esi,%eax
8010251a:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010251d:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
80102520:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102523:	39 c2                	cmp    %eax,%edx
80102525:	74 16                	je     8010253d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102527:	83 ec 0c             	sub    $0xc,%esp
8010252a:	68 14 7d 10 80       	push   $0x80107d14
8010252f:	e8 4c e1 ff ff       	call   80100680 <cprintf>
  ioapic->reg = reg;
80102534:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
8010253a:	83 c4 10             	add    $0x10,%esp
8010253d:	83 c6 21             	add    $0x21,%esi
{
80102540:	ba 10 00 00 00       	mov    $0x10,%edx
80102545:	b8 20 00 00 00       	mov    $0x20,%eax
8010254a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
80102550:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102552:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
80102554:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
8010255a:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010255d:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102563:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102566:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102569:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010256c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010256e:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80102574:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010257b:	39 f0                	cmp    %esi,%eax
8010257d:	75 d1                	jne    80102550 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010257f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102582:	5b                   	pop    %ebx
80102583:	5e                   	pop    %esi
80102584:	5d                   	pop    %ebp
80102585:	c3                   	ret    
80102586:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010258d:	8d 76 00             	lea    0x0(%esi),%esi

80102590 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102590:	55                   	push   %ebp
  ioapic->reg = reg;
80102591:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
{
80102597:	89 e5                	mov    %esp,%ebp
80102599:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010259c:	8d 50 20             	lea    0x20(%eax),%edx
8010259f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
801025a3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025a5:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801025ae:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801025b4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801025b6:	a1 34 26 11 80       	mov    0x80112634,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801025bb:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801025be:	89 50 10             	mov    %edx,0x10(%eax)
}
801025c1:	5d                   	pop    %ebp
801025c2:	c3                   	ret    
801025c3:	66 90                	xchg   %ax,%ax
801025c5:	66 90                	xchg   %ax,%ax
801025c7:	66 90                	xchg   %ax,%ax
801025c9:	66 90                	xchg   %ax,%ax
801025cb:	66 90                	xchg   %ax,%ax
801025cd:	66 90                	xchg   %ax,%ax
801025cf:	90                   	nop

801025d0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	53                   	push   %ebx
801025d4:	83 ec 04             	sub    $0x4,%esp
801025d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801025da:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801025e0:	75 76                	jne    80102658 <kfree+0x88>
801025e2:	81 fb d0 6e 11 80    	cmp    $0x80116ed0,%ebx
801025e8:	72 6e                	jb     80102658 <kfree+0x88>
801025ea:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801025f0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801025f5:	77 61                	ja     80102658 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801025f7:	83 ec 04             	sub    $0x4,%esp
801025fa:	68 00 10 00 00       	push   $0x1000
801025ff:	6a 01                	push   $0x1
80102601:	53                   	push   %ebx
80102602:	e8 49 28 00 00       	call   80104e50 <memset>

  if(kmem.use_lock)
80102607:	8b 15 74 26 11 80    	mov    0x80112674,%edx
8010260d:	83 c4 10             	add    $0x10,%esp
80102610:	85 d2                	test   %edx,%edx
80102612:	75 1c                	jne    80102630 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102614:	a1 78 26 11 80       	mov    0x80112678,%eax
80102619:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010261b:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102620:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
80102626:	85 c0                	test   %eax,%eax
80102628:	75 1e                	jne    80102648 <kfree+0x78>
    release(&kmem.lock);
}
8010262a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010262d:	c9                   	leave  
8010262e:	c3                   	ret    
8010262f:	90                   	nop
    acquire(&kmem.lock);
80102630:	83 ec 0c             	sub    $0xc,%esp
80102633:	68 40 26 11 80       	push   $0x80112640
80102638:	e8 53 27 00 00       	call   80104d90 <acquire>
8010263d:	83 c4 10             	add    $0x10,%esp
80102640:	eb d2                	jmp    80102614 <kfree+0x44>
80102642:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102648:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010264f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102652:	c9                   	leave  
    release(&kmem.lock);
80102653:	e9 d8 26 00 00       	jmp    80104d30 <release>
    panic("kfree");
80102658:	83 ec 0c             	sub    $0xc,%esp
8010265b:	68 46 7d 10 80       	push   $0x80107d46
80102660:	e8 1b dd ff ff       	call   80100380 <panic>
80102665:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010266c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102670 <freerange>:
{
80102670:	55                   	push   %ebp
80102671:	89 e5                	mov    %esp,%ebp
80102673:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102674:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102677:	8b 75 0c             	mov    0xc(%ebp),%esi
8010267a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010267b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102681:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102687:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010268d:	39 de                	cmp    %ebx,%esi
8010268f:	72 23                	jb     801026b4 <freerange+0x44>
80102691:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102698:	83 ec 0c             	sub    $0xc,%esp
8010269b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026a7:	50                   	push   %eax
801026a8:	e8 23 ff ff ff       	call   801025d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026ad:	83 c4 10             	add    $0x10,%esp
801026b0:	39 f3                	cmp    %esi,%ebx
801026b2:	76 e4                	jbe    80102698 <freerange+0x28>
}
801026b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026b7:	5b                   	pop    %ebx
801026b8:	5e                   	pop    %esi
801026b9:	5d                   	pop    %ebp
801026ba:	c3                   	ret    
801026bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801026bf:	90                   	nop

801026c0 <kinit2>:
{
801026c0:	55                   	push   %ebp
801026c1:	89 e5                	mov    %esp,%ebp
801026c3:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
801026c4:	8b 45 08             	mov    0x8(%ebp),%eax
{
801026c7:	8b 75 0c             	mov    0xc(%ebp),%esi
801026ca:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
801026cb:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026d1:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026d7:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026dd:	39 de                	cmp    %ebx,%esi
801026df:	72 23                	jb     80102704 <kinit2+0x44>
801026e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
801026e8:	83 ec 0c             	sub    $0xc,%esp
801026eb:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026f1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801026f7:	50                   	push   %eax
801026f8:	e8 d3 fe ff ff       	call   801025d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026fd:	83 c4 10             	add    $0x10,%esp
80102700:	39 de                	cmp    %ebx,%esi
80102702:	73 e4                	jae    801026e8 <kinit2+0x28>
  kmem.use_lock = 1;
80102704:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010270b:	00 00 00 
}
8010270e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102711:	5b                   	pop    %ebx
80102712:	5e                   	pop    %esi
80102713:	5d                   	pop    %ebp
80102714:	c3                   	ret    
80102715:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010271c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102720 <kinit1>:
{
80102720:	55                   	push   %ebp
80102721:	89 e5                	mov    %esp,%ebp
80102723:	56                   	push   %esi
80102724:	53                   	push   %ebx
80102725:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
80102728:	83 ec 08             	sub    $0x8,%esp
8010272b:	68 4c 7d 10 80       	push   $0x80107d4c
80102730:	68 40 26 11 80       	push   $0x80112640
80102735:	e8 86 24 00 00       	call   80104bc0 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010273a:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010273d:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102740:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102747:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010274a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102750:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102756:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010275c:	39 de                	cmp    %ebx,%esi
8010275e:	72 1c                	jb     8010277c <kinit1+0x5c>
    kfree(p);
80102760:	83 ec 0c             	sub    $0xc,%esp
80102763:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102769:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010276f:	50                   	push   %eax
80102770:	e8 5b fe ff ff       	call   801025d0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102775:	83 c4 10             	add    $0x10,%esp
80102778:	39 de                	cmp    %ebx,%esi
8010277a:	73 e4                	jae    80102760 <kinit1+0x40>
}
8010277c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010277f:	5b                   	pop    %ebx
80102780:	5e                   	pop    %esi
80102781:	5d                   	pop    %ebp
80102782:	c3                   	ret    
80102783:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010278a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102790 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102790:	a1 74 26 11 80       	mov    0x80112674,%eax
80102795:	85 c0                	test   %eax,%eax
80102797:	75 1f                	jne    801027b8 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102799:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(r)
8010279e:	85 c0                	test   %eax,%eax
801027a0:	74 0e                	je     801027b0 <kalloc+0x20>
    kmem.freelist = r->next;
801027a2:	8b 10                	mov    (%eax),%edx
801027a4:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801027aa:	c3                   	ret    
801027ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027af:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
801027b0:	c3                   	ret    
801027b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
801027b8:	55                   	push   %ebp
801027b9:	89 e5                	mov    %esp,%ebp
801027bb:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
801027be:	68 40 26 11 80       	push   $0x80112640
801027c3:	e8 c8 25 00 00       	call   80104d90 <acquire>
  r = kmem.freelist;
801027c8:	a1 78 26 11 80       	mov    0x80112678,%eax
  if(kmem.use_lock)
801027cd:	8b 15 74 26 11 80    	mov    0x80112674,%edx
  if(r)
801027d3:	83 c4 10             	add    $0x10,%esp
801027d6:	85 c0                	test   %eax,%eax
801027d8:	74 08                	je     801027e2 <kalloc+0x52>
    kmem.freelist = r->next;
801027da:	8b 08                	mov    (%eax),%ecx
801027dc:	89 0d 78 26 11 80    	mov    %ecx,0x80112678
  if(kmem.use_lock)
801027e2:	85 d2                	test   %edx,%edx
801027e4:	74 16                	je     801027fc <kalloc+0x6c>
    release(&kmem.lock);
801027e6:	83 ec 0c             	sub    $0xc,%esp
801027e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801027ec:	68 40 26 11 80       	push   $0x80112640
801027f1:	e8 3a 25 00 00       	call   80104d30 <release>
  return (char*)r;
801027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801027f9:	83 c4 10             	add    $0x10,%esp
}
801027fc:	c9                   	leave  
801027fd:	c3                   	ret    
801027fe:	66 90                	xchg   %ax,%ax

80102800 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102800:	ba 64 00 00 00       	mov    $0x64,%edx
80102805:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102806:	a8 01                	test   $0x1,%al
80102808:	0f 84 ca 00 00 00    	je     801028d8 <kbdgetc+0xd8>
{
8010280e:	55                   	push   %ebp
8010280f:	ba 60 00 00 00       	mov    $0x60,%edx
80102814:	89 e5                	mov    %esp,%ebp
80102816:	53                   	push   %ebx
80102817:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
80102818:	8b 1d 7c 26 11 80    	mov    0x8011267c,%ebx
  data = inb(KBDATAP);
8010281e:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
80102821:	3c e0                	cmp    $0xe0,%al
80102823:	74 5b                	je     80102880 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102825:	89 da                	mov    %ebx,%edx
80102827:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
8010282a:	84 c0                	test   %al,%al
8010282c:	78 62                	js     80102890 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010282e:	85 d2                	test   %edx,%edx
80102830:	74 09                	je     8010283b <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102832:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102835:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102838:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
8010283b:	0f b6 91 80 7e 10 80 	movzbl -0x7fef8180(%ecx),%edx
  shift ^= togglecode[data];
80102842:	0f b6 81 80 7d 10 80 	movzbl -0x7fef8280(%ecx),%eax
  shift |= shiftcode[data];
80102849:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
8010284b:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010284d:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
8010284f:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  c = charcode[shift & (CTL | SHIFT)][data];
80102855:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102858:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010285b:	8b 04 85 60 7d 10 80 	mov    -0x7fef82a0(,%eax,4),%eax
80102862:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102866:	74 0b                	je     80102873 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102868:	8d 50 9f             	lea    -0x61(%eax),%edx
8010286b:	83 fa 19             	cmp    $0x19,%edx
8010286e:	77 50                	ja     801028c0 <kbdgetc+0xc0>
      c += 'A' - 'a';
80102870:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102873:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102876:	c9                   	leave  
80102877:	c3                   	ret    
80102878:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010287f:	90                   	nop
    shift |= E0ESC;
80102880:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102883:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102885:	89 1d 7c 26 11 80    	mov    %ebx,0x8011267c
}
8010288b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010288e:	c9                   	leave  
8010288f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102890:	83 e0 7f             	and    $0x7f,%eax
80102893:	85 d2                	test   %edx,%edx
80102895:	0f 44 c8             	cmove  %eax,%ecx
    return 0;
80102898:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010289a:	0f b6 91 80 7e 10 80 	movzbl -0x7fef8180(%ecx),%edx
801028a1:	83 ca 40             	or     $0x40,%edx
801028a4:	0f b6 d2             	movzbl %dl,%edx
801028a7:	f7 d2                	not    %edx
801028a9:	21 da                	and    %ebx,%edx
}
801028ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
801028ae:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
}
801028b4:	c9                   	leave  
801028b5:	c3                   	ret    
801028b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028bd:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801028c0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801028c3:	8d 50 20             	lea    0x20(%eax),%edx
}
801028c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028c9:	c9                   	leave  
      c += 'a' - 'A';
801028ca:	83 f9 1a             	cmp    $0x1a,%ecx
801028cd:	0f 42 c2             	cmovb  %edx,%eax
}
801028d0:	c3                   	ret    
801028d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801028d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801028dd:	c3                   	ret    
801028de:	66 90                	xchg   %ax,%ax

801028e0 <kbdintr>:

void
kbdintr(void)
{
801028e0:	55                   	push   %ebp
801028e1:	89 e5                	mov    %esp,%ebp
801028e3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801028e6:	68 00 28 10 80       	push   $0x80102800
801028eb:	e8 00 e0 ff ff       	call   801008f0 <consoleintr>
}
801028f0:	83 c4 10             	add    $0x10,%esp
801028f3:	c9                   	leave  
801028f4:	c3                   	ret    
801028f5:	66 90                	xchg   %ax,%ax
801028f7:	66 90                	xchg   %ax,%ax
801028f9:	66 90                	xchg   %ax,%ax
801028fb:	66 90                	xchg   %ax,%ax
801028fd:	66 90                	xchg   %ax,%ax
801028ff:	90                   	nop

80102900 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102900:	a1 80 26 11 80       	mov    0x80112680,%eax
80102905:	85 c0                	test   %eax,%eax
80102907:	0f 84 cb 00 00 00    	je     801029d8 <lapicinit+0xd8>
  lapic[index] = value;
8010290d:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102914:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102917:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010291a:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102921:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102924:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102927:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
8010292e:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102931:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102934:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010293b:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
8010293e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102941:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
80102948:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010294b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010294e:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102955:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102958:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010295b:	8b 50 30             	mov    0x30(%eax),%edx
8010295e:	c1 ea 10             	shr    $0x10,%edx
80102961:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102967:	75 77                	jne    801029e0 <lapicinit+0xe0>
  lapic[index] = value;
80102969:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102970:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102973:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102976:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010297d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102980:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102983:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010298a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010298d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102990:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102997:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010299a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010299d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
801029a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029a7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029aa:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801029b1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801029b4:	8b 50 20             	mov    0x20(%eax),%edx
801029b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029be:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801029c0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801029c6:	80 e6 10             	and    $0x10,%dh
801029c9:	75 f5                	jne    801029c0 <lapicinit+0xc0>
  lapic[index] = value;
801029cb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801029d2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801029d8:	c3                   	ret    
801029d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
801029e0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801029e7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801029ea:	8b 50 20             	mov    0x20(%eax),%edx
}
801029ed:	e9 77 ff ff ff       	jmp    80102969 <lapicinit+0x69>
801029f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102a00 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
80102a00:	a1 80 26 11 80       	mov    0x80112680,%eax
80102a05:	85 c0                	test   %eax,%eax
80102a07:	74 07                	je     80102a10 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
80102a09:	8b 40 20             	mov    0x20(%eax),%eax
80102a0c:	c1 e8 18             	shr    $0x18,%eax
80102a0f:	c3                   	ret    
    return 0;
80102a10:	31 c0                	xor    %eax,%eax
}
80102a12:	c3                   	ret    
80102a13:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102a20 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102a20:	a1 80 26 11 80       	mov    0x80112680,%eax
80102a25:	85 c0                	test   %eax,%eax
80102a27:	74 0d                	je     80102a36 <lapiceoi+0x16>
  lapic[index] = value;
80102a29:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102a30:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a33:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102a36:	c3                   	ret    
80102a37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a3e:	66 90                	xchg   %ax,%ax

80102a40 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
80102a40:	c3                   	ret    
80102a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a4f:	90                   	nop

80102a50 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102a50:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a51:	b8 0f 00 00 00       	mov    $0xf,%eax
80102a56:	ba 70 00 00 00       	mov    $0x70,%edx
80102a5b:	89 e5                	mov    %esp,%ebp
80102a5d:	53                   	push   %ebx
80102a5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a61:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a64:	ee                   	out    %al,(%dx)
80102a65:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a6a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a6f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a70:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a72:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a75:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a7b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a7d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102a80:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102a82:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a85:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a88:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a8e:	a1 80 26 11 80       	mov    0x80112680,%eax
80102a93:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a99:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a9c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102aa3:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102aa6:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102aa9:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102ab0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102ab3:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ab6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102abc:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102abf:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ac5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102ac8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ace:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102ad1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102ad7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102ada:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102add:	c9                   	leave  
80102ade:	c3                   	ret    
80102adf:	90                   	nop

80102ae0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102ae0:	55                   	push   %ebp
80102ae1:	b8 0b 00 00 00       	mov    $0xb,%eax
80102ae6:	ba 70 00 00 00       	mov    $0x70,%edx
80102aeb:	89 e5                	mov    %esp,%ebp
80102aed:	57                   	push   %edi
80102aee:	56                   	push   %esi
80102aef:	53                   	push   %ebx
80102af0:	83 ec 4c             	sub    $0x4c,%esp
80102af3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af4:	ba 71 00 00 00       	mov    $0x71,%edx
80102af9:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102afa:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102afd:	bb 70 00 00 00       	mov    $0x70,%ebx
80102b02:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102b05:	8d 76 00             	lea    0x0(%esi),%esi
80102b08:	31 c0                	xor    %eax,%eax
80102b0a:	89 da                	mov    %ebx,%edx
80102b0c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b0d:	b9 71 00 00 00       	mov    $0x71,%ecx
80102b12:	89 ca                	mov    %ecx,%edx
80102b14:	ec                   	in     (%dx),%al
80102b15:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b18:	89 da                	mov    %ebx,%edx
80102b1a:	b8 02 00 00 00       	mov    $0x2,%eax
80102b1f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b20:	89 ca                	mov    %ecx,%edx
80102b22:	ec                   	in     (%dx),%al
80102b23:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b26:	89 da                	mov    %ebx,%edx
80102b28:	b8 04 00 00 00       	mov    $0x4,%eax
80102b2d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b2e:	89 ca                	mov    %ecx,%edx
80102b30:	ec                   	in     (%dx),%al
80102b31:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b34:	89 da                	mov    %ebx,%edx
80102b36:	b8 07 00 00 00       	mov    $0x7,%eax
80102b3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3c:	89 ca                	mov    %ecx,%edx
80102b3e:	ec                   	in     (%dx),%al
80102b3f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b42:	89 da                	mov    %ebx,%edx
80102b44:	b8 08 00 00 00       	mov    $0x8,%eax
80102b49:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4a:	89 ca                	mov    %ecx,%edx
80102b4c:	ec                   	in     (%dx),%al
80102b4d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b4f:	89 da                	mov    %ebx,%edx
80102b51:	b8 09 00 00 00       	mov    $0x9,%eax
80102b56:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b57:	89 ca                	mov    %ecx,%edx
80102b59:	ec                   	in     (%dx),%al
80102b5a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b5c:	89 da                	mov    %ebx,%edx
80102b5e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b63:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b64:	89 ca                	mov    %ecx,%edx
80102b66:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b67:	84 c0                	test   %al,%al
80102b69:	78 9d                	js     80102b08 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b6b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b6f:	89 fa                	mov    %edi,%edx
80102b71:	0f b6 fa             	movzbl %dl,%edi
80102b74:	89 f2                	mov    %esi,%edx
80102b76:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b79:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b7d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b80:	89 da                	mov    %ebx,%edx
80102b82:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102b85:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b88:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b8c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102b8f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b92:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b96:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b99:	31 c0                	xor    %eax,%eax
80102b9b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b9c:	89 ca                	mov    %ecx,%edx
80102b9e:	ec                   	in     (%dx),%al
80102b9f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ba2:	89 da                	mov    %ebx,%edx
80102ba4:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102ba7:	b8 02 00 00 00       	mov    $0x2,%eax
80102bac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bad:	89 ca                	mov    %ecx,%edx
80102baf:	ec                   	in     (%dx),%al
80102bb0:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bb3:	89 da                	mov    %ebx,%edx
80102bb5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102bb8:	b8 04 00 00 00       	mov    $0x4,%eax
80102bbd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bbe:	89 ca                	mov    %ecx,%edx
80102bc0:	ec                   	in     (%dx),%al
80102bc1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bc4:	89 da                	mov    %ebx,%edx
80102bc6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102bc9:	b8 07 00 00 00       	mov    $0x7,%eax
80102bce:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bcf:	89 ca                	mov    %ecx,%edx
80102bd1:	ec                   	in     (%dx),%al
80102bd2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102bd5:	89 da                	mov    %ebx,%edx
80102bd7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102bda:	b8 08 00 00 00       	mov    $0x8,%eax
80102bdf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102be0:	89 ca                	mov    %ecx,%edx
80102be2:	ec                   	in     (%dx),%al
80102be3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102be6:	89 da                	mov    %ebx,%edx
80102be8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102beb:	b8 09 00 00 00       	mov    $0x9,%eax
80102bf0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102bf1:	89 ca                	mov    %ecx,%edx
80102bf3:	ec                   	in     (%dx),%al
80102bf4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bf7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102bfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102bfd:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102c00:	6a 18                	push   $0x18
80102c02:	50                   	push   %eax
80102c03:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102c06:	50                   	push   %eax
80102c07:	e8 94 22 00 00       	call   80104ea0 <memcmp>
80102c0c:	83 c4 10             	add    $0x10,%esp
80102c0f:	85 c0                	test   %eax,%eax
80102c11:	0f 85 f1 fe ff ff    	jne    80102b08 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102c17:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102c1b:	75 78                	jne    80102c95 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102c1d:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c20:	89 c2                	mov    %eax,%edx
80102c22:	83 e0 0f             	and    $0xf,%eax
80102c25:	c1 ea 04             	shr    $0x4,%edx
80102c28:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c2b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c2e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102c31:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c34:	89 c2                	mov    %eax,%edx
80102c36:	83 e0 0f             	and    $0xf,%eax
80102c39:	c1 ea 04             	shr    $0x4,%edx
80102c3c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c3f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c42:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102c45:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c48:	89 c2                	mov    %eax,%edx
80102c4a:	83 e0 0f             	and    $0xf,%eax
80102c4d:	c1 ea 04             	shr    $0x4,%edx
80102c50:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c53:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c56:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102c59:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c5c:	89 c2                	mov    %eax,%edx
80102c5e:	83 e0 0f             	and    $0xf,%eax
80102c61:	c1 ea 04             	shr    $0x4,%edx
80102c64:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c67:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c6a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c70:	89 c2                	mov    %eax,%edx
80102c72:	83 e0 0f             	and    $0xf,%eax
80102c75:	c1 ea 04             	shr    $0x4,%edx
80102c78:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c7b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c7e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c81:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c84:	89 c2                	mov    %eax,%edx
80102c86:	83 e0 0f             	and    $0xf,%eax
80102c89:	c1 ea 04             	shr    $0x4,%edx
80102c8c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c8f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c92:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c95:	8b 75 08             	mov    0x8(%ebp),%esi
80102c98:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c9b:	89 06                	mov    %eax,(%esi)
80102c9d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102ca0:	89 46 04             	mov    %eax,0x4(%esi)
80102ca3:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102ca6:	89 46 08             	mov    %eax,0x8(%esi)
80102ca9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102cac:	89 46 0c             	mov    %eax,0xc(%esi)
80102caf:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102cb2:	89 46 10             	mov    %eax,0x10(%esi)
80102cb5:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102cb8:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102cbb:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102cc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cc5:	5b                   	pop    %ebx
80102cc6:	5e                   	pop    %esi
80102cc7:	5f                   	pop    %edi
80102cc8:	5d                   	pop    %ebp
80102cc9:	c3                   	ret    
80102cca:	66 90                	xchg   %ax,%ax
80102ccc:	66 90                	xchg   %ax,%ax
80102cce:	66 90                	xchg   %ax,%ax

80102cd0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102cd0:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102cd6:	85 c9                	test   %ecx,%ecx
80102cd8:	0f 8e 8a 00 00 00    	jle    80102d68 <install_trans+0x98>
{
80102cde:	55                   	push   %ebp
80102cdf:	89 e5                	mov    %esp,%ebp
80102ce1:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102ce2:	31 ff                	xor    %edi,%edi
{
80102ce4:	56                   	push   %esi
80102ce5:	53                   	push   %ebx
80102ce6:	83 ec 0c             	sub    $0xc,%esp
80102ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102cf0:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102cf5:	83 ec 08             	sub    $0x8,%esp
80102cf8:	01 f8                	add    %edi,%eax
80102cfa:	83 c0 01             	add    $0x1,%eax
80102cfd:	50                   	push   %eax
80102cfe:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102d04:	e8 c7 d3 ff ff       	call   801000d0 <bread>
80102d09:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d0b:	58                   	pop    %eax
80102d0c:	5a                   	pop    %edx
80102d0d:	ff 34 bd ec 26 11 80 	pushl  -0x7feed914(,%edi,4)
80102d14:	ff 35 e4 26 11 80    	pushl  0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102d1a:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d1d:	e8 ae d3 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d22:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102d25:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102d27:	8d 46 5c             	lea    0x5c(%esi),%eax
80102d2a:	68 00 02 00 00       	push   $0x200
80102d2f:	50                   	push   %eax
80102d30:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102d33:	50                   	push   %eax
80102d34:	e8 b7 21 00 00       	call   80104ef0 <memmove>
    bwrite(dbuf);  // write dst to disk
80102d39:	89 1c 24             	mov    %ebx,(%esp)
80102d3c:	e8 6f d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102d41:	89 34 24             	mov    %esi,(%esp)
80102d44:	e8 a7 d4 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102d49:	89 1c 24             	mov    %ebx,(%esp)
80102d4c:	e8 9f d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102d51:	83 c4 10             	add    $0x10,%esp
80102d54:	39 3d e8 26 11 80    	cmp    %edi,0x801126e8
80102d5a:	7f 94                	jg     80102cf0 <install_trans+0x20>
  }
}
80102d5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d5f:	5b                   	pop    %ebx
80102d60:	5e                   	pop    %esi
80102d61:	5f                   	pop    %edi
80102d62:	5d                   	pop    %ebp
80102d63:	c3                   	ret    
80102d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d68:	c3                   	ret    
80102d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d70 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d77:	ff 35 d4 26 11 80    	pushl  0x801126d4
80102d7d:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102d83:	e8 48 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102d88:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d8e:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d91:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d93:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102d96:	85 c9                	test   %ecx,%ecx
80102d98:	7e 18                	jle    80102db2 <write_head+0x42>
80102d9a:	31 c0                	xor    %eax,%eax
80102d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102da0:	8b 14 85 ec 26 11 80 	mov    -0x7feed914(,%eax,4),%edx
80102da7:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102dab:	83 c0 01             	add    $0x1,%eax
80102dae:	39 c1                	cmp    %eax,%ecx
80102db0:	75 ee                	jne    80102da0 <write_head+0x30>
  }
  bwrite(buf);
80102db2:	83 ec 0c             	sub    $0xc,%esp
80102db5:	53                   	push   %ebx
80102db6:	e8 f5 d3 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102dbb:	89 1c 24             	mov    %ebx,(%esp)
80102dbe:	e8 2d d4 ff ff       	call   801001f0 <brelse>
}
80102dc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dc6:	83 c4 10             	add    $0x10,%esp
80102dc9:	c9                   	leave  
80102dca:	c3                   	ret    
80102dcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102dcf:	90                   	nop

80102dd0 <initlog>:
{
80102dd0:	55                   	push   %ebp
80102dd1:	89 e5                	mov    %esp,%ebp
80102dd3:	53                   	push   %ebx
80102dd4:	83 ec 2c             	sub    $0x2c,%esp
80102dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102dda:	68 80 7f 10 80       	push   $0x80107f80
80102ddf:	68 a0 26 11 80       	push   $0x801126a0
80102de4:	e8 d7 1d 00 00       	call   80104bc0 <initlock>
  readsb(dev, &sb);
80102de9:	58                   	pop    %eax
80102dea:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ded:	5a                   	pop    %edx
80102dee:	50                   	push   %eax
80102def:	53                   	push   %ebx
80102df0:	e8 3b e8 ff ff       	call   80101630 <readsb>
  log.start = sb.logstart;
80102df5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102df8:	59                   	pop    %ecx
  log.dev = dev;
80102df9:	89 1d e4 26 11 80    	mov    %ebx,0x801126e4
  log.size = sb.nlog;
80102dff:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102e02:	a3 d4 26 11 80       	mov    %eax,0x801126d4
  log.size = sb.nlog;
80102e07:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  struct buf *buf = bread(log.dev, log.start);
80102e0d:	5a                   	pop    %edx
80102e0e:	50                   	push   %eax
80102e0f:	53                   	push   %ebx
80102e10:	e8 bb d2 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102e15:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102e18:	8b 58 5c             	mov    0x5c(%eax),%ebx
  struct buf *buf = bread(log.dev, log.start);
80102e1b:	89 c1                	mov    %eax,%ecx
  log.lh.n = lh->n;
80102e1d:	89 1d e8 26 11 80    	mov    %ebx,0x801126e8
  for (i = 0; i < log.lh.n; i++) {
80102e23:	85 db                	test   %ebx,%ebx
80102e25:	7e 1b                	jle    80102e42 <initlog+0x72>
80102e27:	31 c0                	xor    %eax,%eax
80102e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102e30:	8b 54 81 60          	mov    0x60(%ecx,%eax,4),%edx
80102e34:	89 14 85 ec 26 11 80 	mov    %edx,-0x7feed914(,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
80102e3b:	83 c0 01             	add    $0x1,%eax
80102e3e:	39 c3                	cmp    %eax,%ebx
80102e40:	75 ee                	jne    80102e30 <initlog+0x60>
  brelse(buf);
80102e42:	83 ec 0c             	sub    $0xc,%esp
80102e45:	51                   	push   %ecx
80102e46:	e8 a5 d3 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102e4b:	e8 80 fe ff ff       	call   80102cd0 <install_trans>
  log.lh.n = 0;
80102e50:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102e57:	00 00 00 
  write_head(); // clear the log
80102e5a:	e8 11 ff ff ff       	call   80102d70 <write_head>
}
80102e5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e62:	83 c4 10             	add    $0x10,%esp
80102e65:	c9                   	leave  
80102e66:	c3                   	ret    
80102e67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e6e:	66 90                	xchg   %ax,%ax

80102e70 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e70:	55                   	push   %ebp
80102e71:	89 e5                	mov    %esp,%ebp
80102e73:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e76:	68 a0 26 11 80       	push   $0x801126a0
80102e7b:	e8 10 1f 00 00       	call   80104d90 <acquire>
80102e80:	83 c4 10             	add    $0x10,%esp
80102e83:	eb 18                	jmp    80102e9d <begin_op+0x2d>
80102e85:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e88:	83 ec 08             	sub    $0x8,%esp
80102e8b:	68 a0 26 11 80       	push   $0x801126a0
80102e90:	68 a0 26 11 80       	push   $0x801126a0
80102e95:	e8 56 17 00 00       	call   801045f0 <sleep>
80102e9a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e9d:	a1 e0 26 11 80       	mov    0x801126e0,%eax
80102ea2:	85 c0                	test   %eax,%eax
80102ea4:	75 e2                	jne    80102e88 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102ea6:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102eab:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80102eb1:	83 c0 01             	add    $0x1,%eax
80102eb4:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102eb7:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102eba:	83 fa 1e             	cmp    $0x1e,%edx
80102ebd:	7f c9                	jg     80102e88 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102ebf:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102ec2:	a3 dc 26 11 80       	mov    %eax,0x801126dc
      release(&log.lock);
80102ec7:	68 a0 26 11 80       	push   $0x801126a0
80102ecc:	e8 5f 1e 00 00       	call   80104d30 <release>
      break;
    }
  }
}
80102ed1:	83 c4 10             	add    $0x10,%esp
80102ed4:	c9                   	leave  
80102ed5:	c3                   	ret    
80102ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102edd:	8d 76 00             	lea    0x0(%esi),%esi

80102ee0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102ee0:	55                   	push   %ebp
80102ee1:	89 e5                	mov    %esp,%ebp
80102ee3:	57                   	push   %edi
80102ee4:	56                   	push   %esi
80102ee5:	53                   	push   %ebx
80102ee6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102ee9:	68 a0 26 11 80       	push   $0x801126a0
80102eee:	e8 9d 1e 00 00       	call   80104d90 <acquire>
  log.outstanding -= 1;
80102ef3:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  if(log.committing)
80102ef8:	8b 35 e0 26 11 80    	mov    0x801126e0,%esi
80102efe:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102f01:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102f04:	89 1d dc 26 11 80    	mov    %ebx,0x801126dc
  if(log.committing)
80102f0a:	85 f6                	test   %esi,%esi
80102f0c:	0f 85 22 01 00 00    	jne    80103034 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102f12:	85 db                	test   %ebx,%ebx
80102f14:	0f 85 f6 00 00 00    	jne    80103010 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102f1a:	c7 05 e0 26 11 80 01 	movl   $0x1,0x801126e0
80102f21:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102f24:	83 ec 0c             	sub    $0xc,%esp
80102f27:	68 a0 26 11 80       	push   $0x801126a0
80102f2c:	e8 ff 1d 00 00       	call   80104d30 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102f31:	8b 0d e8 26 11 80    	mov    0x801126e8,%ecx
80102f37:	83 c4 10             	add    $0x10,%esp
80102f3a:	85 c9                	test   %ecx,%ecx
80102f3c:	7f 42                	jg     80102f80 <end_op+0xa0>
    acquire(&log.lock);
80102f3e:	83 ec 0c             	sub    $0xc,%esp
80102f41:	68 a0 26 11 80       	push   $0x801126a0
80102f46:	e8 45 1e 00 00       	call   80104d90 <acquire>
    wakeup(&log);
80102f4b:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
    log.committing = 0;
80102f52:	c7 05 e0 26 11 80 00 	movl   $0x0,0x801126e0
80102f59:	00 00 00 
    wakeup(&log);
80102f5c:	e8 4f 17 00 00       	call   801046b0 <wakeup>
    release(&log.lock);
80102f61:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80102f68:	e8 c3 1d 00 00       	call   80104d30 <release>
80102f6d:	83 c4 10             	add    $0x10,%esp
}
80102f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f73:	5b                   	pop    %ebx
80102f74:	5e                   	pop    %esi
80102f75:	5f                   	pop    %edi
80102f76:	5d                   	pop    %ebp
80102f77:	c3                   	ret    
80102f78:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f7f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f80:	a1 d4 26 11 80       	mov    0x801126d4,%eax
80102f85:	83 ec 08             	sub    $0x8,%esp
80102f88:	01 d8                	add    %ebx,%eax
80102f8a:	83 c0 01             	add    $0x1,%eax
80102f8d:	50                   	push   %eax
80102f8e:	ff 35 e4 26 11 80    	pushl  0x801126e4
80102f94:	e8 37 d1 ff ff       	call   801000d0 <bread>
80102f99:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f9b:	58                   	pop    %eax
80102f9c:	5a                   	pop    %edx
80102f9d:	ff 34 9d ec 26 11 80 	pushl  -0x7feed914(,%ebx,4)
80102fa4:	ff 35 e4 26 11 80    	pushl  0x801126e4
  for (tail = 0; tail < log.lh.n; tail++) {
80102faa:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fad:	e8 1e d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102fb2:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102fb5:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102fb7:	8d 40 5c             	lea    0x5c(%eax),%eax
80102fba:	68 00 02 00 00       	push   $0x200
80102fbf:	50                   	push   %eax
80102fc0:	8d 46 5c             	lea    0x5c(%esi),%eax
80102fc3:	50                   	push   %eax
80102fc4:	e8 27 1f 00 00       	call   80104ef0 <memmove>
    bwrite(to);  // write the log
80102fc9:	89 34 24             	mov    %esi,(%esp)
80102fcc:	e8 df d1 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102fd1:	89 3c 24             	mov    %edi,(%esp)
80102fd4:	e8 17 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102fd9:	89 34 24             	mov    %esi,(%esp)
80102fdc:	e8 0f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102fe1:	83 c4 10             	add    $0x10,%esp
80102fe4:	3b 1d e8 26 11 80    	cmp    0x801126e8,%ebx
80102fea:	7c 94                	jl     80102f80 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102fec:	e8 7f fd ff ff       	call   80102d70 <write_head>
    install_trans(); // Now install writes to home locations
80102ff1:	e8 da fc ff ff       	call   80102cd0 <install_trans>
    log.lh.n = 0;
80102ff6:	c7 05 e8 26 11 80 00 	movl   $0x0,0x801126e8
80102ffd:	00 00 00 
    write_head();    // Erase the transaction from the log
80103000:	e8 6b fd ff ff       	call   80102d70 <write_head>
80103005:	e9 34 ff ff ff       	jmp    80102f3e <end_op+0x5e>
8010300a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80103010:	83 ec 0c             	sub    $0xc,%esp
80103013:	68 a0 26 11 80       	push   $0x801126a0
80103018:	e8 93 16 00 00       	call   801046b0 <wakeup>
  release(&log.lock);
8010301d:	c7 04 24 a0 26 11 80 	movl   $0x801126a0,(%esp)
80103024:	e8 07 1d 00 00       	call   80104d30 <release>
80103029:	83 c4 10             	add    $0x10,%esp
}
8010302c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010302f:	5b                   	pop    %ebx
80103030:	5e                   	pop    %esi
80103031:	5f                   	pop    %edi
80103032:	5d                   	pop    %ebp
80103033:	c3                   	ret    
    panic("log.committing");
80103034:	83 ec 0c             	sub    $0xc,%esp
80103037:	68 84 7f 10 80       	push   $0x80107f84
8010303c:	e8 3f d3 ff ff       	call   80100380 <panic>
80103041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103048:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010304f:	90                   	nop

80103050 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103050:	55                   	push   %ebp
80103051:	89 e5                	mov    %esp,%ebp
80103053:	53                   	push   %ebx
80103054:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103057:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
{
8010305d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103060:	83 fa 1d             	cmp    $0x1d,%edx
80103063:	0f 8f 85 00 00 00    	jg     801030ee <log_write+0x9e>
80103069:	a1 d8 26 11 80       	mov    0x801126d8,%eax
8010306e:	83 e8 01             	sub    $0x1,%eax
80103071:	39 c2                	cmp    %eax,%edx
80103073:	7d 79                	jge    801030ee <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103075:	a1 dc 26 11 80       	mov    0x801126dc,%eax
8010307a:	85 c0                	test   %eax,%eax
8010307c:	7e 7d                	jle    801030fb <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010307e:	83 ec 0c             	sub    $0xc,%esp
80103081:	68 a0 26 11 80       	push   $0x801126a0
80103086:	e8 05 1d 00 00       	call   80104d90 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010308b:	8b 15 e8 26 11 80    	mov    0x801126e8,%edx
80103091:	83 c4 10             	add    $0x10,%esp
80103094:	85 d2                	test   %edx,%edx
80103096:	7e 4a                	jle    801030e2 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103098:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010309b:	31 c0                	xor    %eax,%eax
8010309d:	eb 08                	jmp    801030a7 <log_write+0x57>
8010309f:	90                   	nop
801030a0:	83 c0 01             	add    $0x1,%eax
801030a3:	39 c2                	cmp    %eax,%edx
801030a5:	74 29                	je     801030d0 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801030a7:	39 0c 85 ec 26 11 80 	cmp    %ecx,-0x7feed914(,%eax,4)
801030ae:	75 f0                	jne    801030a0 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
801030b0:	89 0c 85 ec 26 11 80 	mov    %ecx,-0x7feed914(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801030b7:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
801030ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
801030bd:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
801030c4:	c9                   	leave  
  release(&log.lock);
801030c5:	e9 66 1c 00 00       	jmp    80104d30 <release>
801030ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
801030d0:	89 0c 95 ec 26 11 80 	mov    %ecx,-0x7feed914(,%edx,4)
    log.lh.n++;
801030d7:	83 c2 01             	add    $0x1,%edx
801030da:	89 15 e8 26 11 80    	mov    %edx,0x801126e8
801030e0:	eb d5                	jmp    801030b7 <log_write+0x67>
  log.lh.block[i] = b->blockno;
801030e2:	8b 43 08             	mov    0x8(%ebx),%eax
801030e5:	a3 ec 26 11 80       	mov    %eax,0x801126ec
  if (i == log.lh.n)
801030ea:	75 cb                	jne    801030b7 <log_write+0x67>
801030ec:	eb e9                	jmp    801030d7 <log_write+0x87>
    panic("too big a transaction");
801030ee:	83 ec 0c             	sub    $0xc,%esp
801030f1:	68 93 7f 10 80       	push   $0x80107f93
801030f6:	e8 85 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
801030fb:	83 ec 0c             	sub    $0xc,%esp
801030fe:	68 a9 7f 10 80       	push   $0x80107fa9
80103103:	e8 78 d2 ff ff       	call   80100380 <panic>
80103108:	66 90                	xchg   %ax,%ax
8010310a:	66 90                	xchg   %ax,%ax
8010310c:	66 90                	xchg   %ax,%ax
8010310e:	66 90                	xchg   %ax,%ax

80103110 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103110:	55                   	push   %ebp
80103111:	89 e5                	mov    %esp,%ebp
80103113:	53                   	push   %ebx
80103114:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80103117:	e8 54 0a 00 00       	call   80103b70 <cpuid>
8010311c:	89 c3                	mov    %eax,%ebx
8010311e:	e8 4d 0a 00 00       	call   80103b70 <cpuid>
80103123:	83 ec 04             	sub    $0x4,%esp
80103126:	53                   	push   %ebx
80103127:	50                   	push   %eax
80103128:	68 c4 7f 10 80       	push   $0x80107fc4
8010312d:	e8 4e d5 ff ff       	call   80100680 <cprintf>
  idtinit();       // load idt register
80103132:	e8 d9 30 00 00       	call   80106210 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103137:	e8 c4 09 00 00       	call   80103b00 <mycpu>
8010313c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010313e:	b8 01 00 00 00       	mov    $0x1,%eax
80103143:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010314a:	e8 91 10 00 00       	call   801041e0 <scheduler>
8010314f:	90                   	nop

80103150 <mpenter>:
{
80103150:	55                   	push   %ebp
80103151:	89 e5                	mov    %esp,%ebp
80103153:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103156:	e8 c5 41 00 00       	call   80107320 <switchkvm>
  seginit();
8010315b:	e8 30 41 00 00       	call   80107290 <seginit>
  lapicinit();
80103160:	e8 9b f7 ff ff       	call   80102900 <lapicinit>
  mpmain();
80103165:	e8 a6 ff ff ff       	call   80103110 <mpmain>
8010316a:	66 90                	xchg   %ax,%ax
8010316c:	66 90                	xchg   %ax,%ax
8010316e:	66 90                	xchg   %ax,%ax

80103170 <main>:
{
80103170:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103174:	83 e4 f0             	and    $0xfffffff0,%esp
80103177:	ff 71 fc             	pushl  -0x4(%ecx)
8010317a:	55                   	push   %ebp
8010317b:	89 e5                	mov    %esp,%ebp
8010317d:	53                   	push   %ebx
8010317e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010317f:	83 ec 08             	sub    $0x8,%esp
80103182:	68 00 00 40 80       	push   $0x80400000
80103187:	68 d0 6e 11 80       	push   $0x80116ed0
8010318c:	e8 8f f5 ff ff       	call   80102720 <kinit1>
  kvmalloc();      // kernel page table
80103191:	e8 7a 46 00 00       	call   80107810 <kvmalloc>
  mpinit();        // detect other processors
80103196:	e8 85 01 00 00       	call   80103320 <mpinit>
  lapicinit();     // interrupt controller
8010319b:	e8 60 f7 ff ff       	call   80102900 <lapicinit>
  seginit();       // segment descriptors
801031a0:	e8 eb 40 00 00       	call   80107290 <seginit>
  picinit();       // disable pic
801031a5:	e8 76 03 00 00       	call   80103520 <picinit>
  ioapicinit();    // another interrupt controller
801031aa:	e8 31 f3 ff ff       	call   801024e0 <ioapicinit>
  consoleinit();   // console hardware
801031af:	e8 cc d9 ff ff       	call   80100b80 <consoleinit>
  uartinit();      // serial port
801031b4:	e8 47 33 00 00       	call   80106500 <uartinit>
  pinit();         // process table
801031b9:	e8 22 09 00 00       	call   80103ae0 <pinit>
  tvinit();        // trap vectors
801031be:	e8 cd 2f 00 00       	call   80106190 <tvinit>
  binit();         // buffer cache
801031c3:	e8 78 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
801031c8:	e8 63 dd ff ff       	call   80100f30 <fileinit>
  ideinit();       // disk 
801031cd:	e8 fe f0 ff ff       	call   801022d0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801031d2:	83 c4 0c             	add    $0xc,%esp
801031d5:	68 8a 00 00 00       	push   $0x8a
801031da:	68 8c b4 10 80       	push   $0x8010b48c
801031df:	68 00 70 00 80       	push   $0x80007000
801031e4:	e8 07 1d 00 00       	call   80104ef0 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801031e9:	83 c4 10             	add    $0x10,%esp
801031ec:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
801031f3:	00 00 00 
801031f6:	05 a0 27 11 80       	add    $0x801127a0,%eax
801031fb:	3d a0 27 11 80       	cmp    $0x801127a0,%eax
80103200:	76 7e                	jbe    80103280 <main+0x110>
80103202:	bb a0 27 11 80       	mov    $0x801127a0,%ebx
80103207:	eb 20                	jmp    80103229 <main+0xb9>
80103209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103210:	69 05 84 27 11 80 b0 	imul   $0xb0,0x80112784,%eax
80103217:	00 00 00 
8010321a:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80103220:	05 a0 27 11 80       	add    $0x801127a0,%eax
80103225:	39 c3                	cmp    %eax,%ebx
80103227:	73 57                	jae    80103280 <main+0x110>
    if(c == mycpu())  // We've started already.
80103229:	e8 d2 08 00 00       	call   80103b00 <mycpu>
8010322e:	39 c3                	cmp    %eax,%ebx
80103230:	74 de                	je     80103210 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103232:	e8 59 f5 ff ff       	call   80102790 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80103237:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
8010323a:	c7 05 f8 6f 00 80 50 	movl   $0x80103150,0x80006ff8
80103241:	31 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80103244:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
8010324b:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
8010324e:	05 00 10 00 00       	add    $0x1000,%eax
80103253:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
80103258:	0f b6 03             	movzbl (%ebx),%eax
8010325b:	68 00 70 00 00       	push   $0x7000
80103260:	50                   	push   %eax
80103261:	e8 ea f7 ff ff       	call   80102a50 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103266:	83 c4 10             	add    $0x10,%esp
80103269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103270:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103276:	85 c0                	test   %eax,%eax
80103278:	74 f6                	je     80103270 <main+0x100>
8010327a:	eb 94                	jmp    80103210 <main+0xa0>
8010327c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103280:	83 ec 08             	sub    $0x8,%esp
80103283:	68 00 00 00 8e       	push   $0x8e000000
80103288:	68 00 00 40 80       	push   $0x80400000
8010328d:	e8 2e f4 ff ff       	call   801026c0 <kinit2>
  userinit();      // first user process
80103292:	e8 29 09 00 00       	call   80103bc0 <userinit>
  mpmain();        // finish this processor's setup
80103297:	e8 74 fe ff ff       	call   80103110 <mpmain>
8010329c:	66 90                	xchg   %ax,%ax
8010329e:	66 90                	xchg   %ax,%ax

801032a0 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801032a0:	55                   	push   %ebp
801032a1:	89 e5                	mov    %esp,%ebp
801032a3:	57                   	push   %edi
801032a4:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
801032a5:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
801032ab:	53                   	push   %ebx
  e = addr+len;
801032ac:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
801032af:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
801032b2:	39 de                	cmp    %ebx,%esi
801032b4:	72 10                	jb     801032c6 <mpsearch1+0x26>
801032b6:	eb 50                	jmp    80103308 <mpsearch1+0x68>
801032b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032bf:	90                   	nop
801032c0:	89 fe                	mov    %edi,%esi
801032c2:	39 fb                	cmp    %edi,%ebx
801032c4:	76 42                	jbe    80103308 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032c6:	83 ec 04             	sub    $0x4,%esp
801032c9:	8d 7e 10             	lea    0x10(%esi),%edi
801032cc:	6a 04                	push   $0x4
801032ce:	68 d8 7f 10 80       	push   $0x80107fd8
801032d3:	56                   	push   %esi
801032d4:	e8 c7 1b 00 00       	call   80104ea0 <memcmp>
801032d9:	83 c4 10             	add    $0x10,%esp
801032dc:	89 c2                	mov    %eax,%edx
801032de:	85 c0                	test   %eax,%eax
801032e0:	75 de                	jne    801032c0 <mpsearch1+0x20>
801032e2:	89 f0                	mov    %esi,%eax
801032e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801032e8:	0f b6 08             	movzbl (%eax),%ecx
  for(i=0; i<len; i++)
801032eb:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801032ee:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032f0:	39 f8                	cmp    %edi,%eax
801032f2:	75 f4                	jne    801032e8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801032f4:	84 d2                	test   %dl,%dl
801032f6:	75 c8                	jne    801032c0 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801032f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801032fb:	89 f0                	mov    %esi,%eax
801032fd:	5b                   	pop    %ebx
801032fe:	5e                   	pop    %esi
801032ff:	5f                   	pop    %edi
80103300:	5d                   	pop    %ebp
80103301:	c3                   	ret    
80103302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103308:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010330b:	31 f6                	xor    %esi,%esi
}
8010330d:	5b                   	pop    %ebx
8010330e:	89 f0                	mov    %esi,%eax
80103310:	5e                   	pop    %esi
80103311:	5f                   	pop    %edi
80103312:	5d                   	pop    %ebp
80103313:	c3                   	ret    
80103314:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010331b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010331f:	90                   	nop

80103320 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	57                   	push   %edi
80103324:	56                   	push   %esi
80103325:	53                   	push   %ebx
80103326:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103329:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103330:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103337:	c1 e0 08             	shl    $0x8,%eax
8010333a:	09 d0                	or     %edx,%eax
8010333c:	c1 e0 04             	shl    $0x4,%eax
8010333f:	75 1b                	jne    8010335c <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103341:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80103348:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
8010334f:	c1 e0 08             	shl    $0x8,%eax
80103352:	09 d0                	or     %edx,%eax
80103354:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103357:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010335c:	ba 00 04 00 00       	mov    $0x400,%edx
80103361:	e8 3a ff ff ff       	call   801032a0 <mpsearch1>
80103366:	89 c3                	mov    %eax,%ebx
80103368:	85 c0                	test   %eax,%eax
8010336a:	0f 84 40 01 00 00    	je     801034b0 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103370:	8b 73 04             	mov    0x4(%ebx),%esi
80103373:	85 f6                	test   %esi,%esi
80103375:	0f 84 25 01 00 00    	je     801034a0 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010337b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010337e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103384:	6a 04                	push   $0x4
80103386:	68 dd 7f 10 80       	push   $0x80107fdd
8010338b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010338c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010338f:	e8 0c 1b 00 00       	call   80104ea0 <memcmp>
80103394:	83 c4 10             	add    $0x10,%esp
80103397:	85 c0                	test   %eax,%eax
80103399:	0f 85 01 01 00 00    	jne    801034a0 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010339f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
801033a6:	3c 01                	cmp    $0x1,%al
801033a8:	74 08                	je     801033b2 <mpinit+0x92>
801033aa:	3c 04                	cmp    $0x4,%al
801033ac:	0f 85 ee 00 00 00    	jne    801034a0 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
801033b2:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
801033b9:	66 85 d2             	test   %dx,%dx
801033bc:	74 22                	je     801033e0 <mpinit+0xc0>
801033be:	8d 3c 32             	lea    (%edx,%esi,1),%edi
801033c1:	89 f0                	mov    %esi,%eax
  sum = 0;
801033c3:	31 d2                	xor    %edx,%edx
801033c5:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801033c8:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
801033cf:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801033d2:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801033d4:	39 f8                	cmp    %edi,%eax
801033d6:	75 f0                	jne    801033c8 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
801033d8:	84 d2                	test   %dl,%dl
801033da:	0f 85 c0 00 00 00    	jne    801034a0 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801033e0:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
801033e6:	a3 80 26 11 80       	mov    %eax,0x80112680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033eb:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801033f2:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
801033f8:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033fd:	03 55 e4             	add    -0x1c(%ebp),%edx
80103400:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80103403:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103407:	90                   	nop
80103408:	39 d0                	cmp    %edx,%eax
8010340a:	73 15                	jae    80103421 <mpinit+0x101>
    switch(*p){
8010340c:	0f b6 08             	movzbl (%eax),%ecx
8010340f:	80 f9 02             	cmp    $0x2,%cl
80103412:	74 4c                	je     80103460 <mpinit+0x140>
80103414:	77 3a                	ja     80103450 <mpinit+0x130>
80103416:	84 c9                	test   %cl,%cl
80103418:	74 56                	je     80103470 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
8010341a:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010341d:	39 d0                	cmp    %edx,%eax
8010341f:	72 eb                	jb     8010340c <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103421:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103424:	85 f6                	test   %esi,%esi
80103426:	0f 84 d9 00 00 00    	je     80103505 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010342c:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
80103430:	74 15                	je     80103447 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103432:	b8 70 00 00 00       	mov    $0x70,%eax
80103437:	ba 22 00 00 00       	mov    $0x22,%edx
8010343c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010343d:	ba 23 00 00 00       	mov    $0x23,%edx
80103442:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103443:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103446:	ee                   	out    %al,(%dx)
  }
}
80103447:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010344a:	5b                   	pop    %ebx
8010344b:	5e                   	pop    %esi
8010344c:	5f                   	pop    %edi
8010344d:	5d                   	pop    %ebp
8010344e:	c3                   	ret    
8010344f:	90                   	nop
    switch(*p){
80103450:	83 e9 03             	sub    $0x3,%ecx
80103453:	80 f9 01             	cmp    $0x1,%cl
80103456:	76 c2                	jbe    8010341a <mpinit+0xfa>
80103458:	31 f6                	xor    %esi,%esi
8010345a:	eb ac                	jmp    80103408 <mpinit+0xe8>
8010345c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103460:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103464:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103467:	88 0d 80 27 11 80    	mov    %cl,0x80112780
      continue;
8010346d:	eb 99                	jmp    80103408 <mpinit+0xe8>
8010346f:	90                   	nop
      if(ncpu < NCPU) {
80103470:	8b 0d 84 27 11 80    	mov    0x80112784,%ecx
80103476:	83 f9 07             	cmp    $0x7,%ecx
80103479:	7f 19                	jg     80103494 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010347b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103481:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103485:	83 c1 01             	add    $0x1,%ecx
80103488:	89 0d 84 27 11 80    	mov    %ecx,0x80112784
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010348e:	88 9f a0 27 11 80    	mov    %bl,-0x7feed860(%edi)
      p += sizeof(struct mpproc);
80103494:	83 c0 14             	add    $0x14,%eax
      continue;
80103497:	e9 6c ff ff ff       	jmp    80103408 <mpinit+0xe8>
8010349c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
801034a0:	83 ec 0c             	sub    $0xc,%esp
801034a3:	68 e2 7f 10 80       	push   $0x80107fe2
801034a8:	e8 d3 ce ff ff       	call   80100380 <panic>
801034ad:	8d 76 00             	lea    0x0(%esi),%esi
{
801034b0:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
801034b5:	eb 13                	jmp    801034ca <mpinit+0x1aa>
801034b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034be:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
801034c0:	89 f3                	mov    %esi,%ebx
801034c2:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
801034c8:	74 d6                	je     801034a0 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034ca:	83 ec 04             	sub    $0x4,%esp
801034cd:	8d 73 10             	lea    0x10(%ebx),%esi
801034d0:	6a 04                	push   $0x4
801034d2:	68 d8 7f 10 80       	push   $0x80107fd8
801034d7:	53                   	push   %ebx
801034d8:	e8 c3 19 00 00       	call   80104ea0 <memcmp>
801034dd:	83 c4 10             	add    $0x10,%esp
801034e0:	89 c2                	mov    %eax,%edx
801034e2:	85 c0                	test   %eax,%eax
801034e4:	75 da                	jne    801034c0 <mpinit+0x1a0>
801034e6:	89 d8                	mov    %ebx,%eax
801034e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801034ef:	90                   	nop
    sum += addr[i];
801034f0:	0f b6 08             	movzbl (%eax),%ecx
  for(i=0; i<len; i++)
801034f3:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801034f6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801034f8:	39 f0                	cmp    %esi,%eax
801034fa:	75 f4                	jne    801034f0 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801034fc:	84 d2                	test   %dl,%dl
801034fe:	75 c0                	jne    801034c0 <mpinit+0x1a0>
80103500:	e9 6b fe ff ff       	jmp    80103370 <mpinit+0x50>
    panic("Didn't find a suitable machine");
80103505:	83 ec 0c             	sub    $0xc,%esp
80103508:	68 fc 7f 10 80       	push   $0x80107ffc
8010350d:	e8 6e ce ff ff       	call   80100380 <panic>
80103512:	66 90                	xchg   %ax,%ax
80103514:	66 90                	xchg   %ax,%ax
80103516:	66 90                	xchg   %ax,%ax
80103518:	66 90                	xchg   %ax,%ax
8010351a:	66 90                	xchg   %ax,%ax
8010351c:	66 90                	xchg   %ax,%ax
8010351e:	66 90                	xchg   %ax,%ax

80103520 <picinit>:
80103520:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103525:	ba 21 00 00 00       	mov    $0x21,%edx
8010352a:	ee                   	out    %al,(%dx)
8010352b:	ba a1 00 00 00       	mov    $0xa1,%edx
80103530:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103531:	c3                   	ret    
80103532:	66 90                	xchg   %ax,%ax
80103534:	66 90                	xchg   %ax,%ax
80103536:	66 90                	xchg   %ax,%ax
80103538:	66 90                	xchg   %ax,%ax
8010353a:	66 90                	xchg   %ax,%ax
8010353c:	66 90                	xchg   %ax,%ax
8010353e:	66 90                	xchg   %ax,%ax

80103540 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103540:	55                   	push   %ebp
80103541:	89 e5                	mov    %esp,%ebp
80103543:	57                   	push   %edi
80103544:	56                   	push   %esi
80103545:	53                   	push   %ebx
80103546:	83 ec 0c             	sub    $0xc,%esp
80103549:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010354c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010354f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103555:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010355b:	e8 f0 d9 ff ff       	call   80100f50 <filealloc>
80103560:	89 03                	mov    %eax,(%ebx)
80103562:	85 c0                	test   %eax,%eax
80103564:	0f 84 a8 00 00 00    	je     80103612 <pipealloc+0xd2>
8010356a:	e8 e1 d9 ff ff       	call   80100f50 <filealloc>
8010356f:	89 06                	mov    %eax,(%esi)
80103571:	85 c0                	test   %eax,%eax
80103573:	0f 84 87 00 00 00    	je     80103600 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103579:	e8 12 f2 ff ff       	call   80102790 <kalloc>
8010357e:	89 c7                	mov    %eax,%edi
80103580:	85 c0                	test   %eax,%eax
80103582:	0f 84 b0 00 00 00    	je     80103638 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103588:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010358f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103592:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103595:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010359c:	00 00 00 
  p->nwrite = 0;
8010359f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801035a6:	00 00 00 
  p->nread = 0;
801035a9:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801035b0:	00 00 00 
  initlock(&p->lock, "pipe");
801035b3:	68 1b 80 10 80       	push   $0x8010801b
801035b8:	50                   	push   %eax
801035b9:	e8 02 16 00 00       	call   80104bc0 <initlock>
  (*f0)->type = FD_PIPE;
801035be:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801035c0:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801035c3:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801035c9:	8b 03                	mov    (%ebx),%eax
801035cb:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801035cf:	8b 03                	mov    (%ebx),%eax
801035d1:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801035d5:	8b 03                	mov    (%ebx),%eax
801035d7:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801035da:	8b 06                	mov    (%esi),%eax
801035dc:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801035e2:	8b 06                	mov    (%esi),%eax
801035e4:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801035e8:	8b 06                	mov    (%esi),%eax
801035ea:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801035ee:	8b 06                	mov    (%esi),%eax
801035f0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801035f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801035f6:	31 c0                	xor    %eax,%eax
}
801035f8:	5b                   	pop    %ebx
801035f9:	5e                   	pop    %esi
801035fa:	5f                   	pop    %edi
801035fb:	5d                   	pop    %ebp
801035fc:	c3                   	ret    
801035fd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
80103600:	8b 03                	mov    (%ebx),%eax
80103602:	85 c0                	test   %eax,%eax
80103604:	74 1e                	je     80103624 <pipealloc+0xe4>
    fileclose(*f0);
80103606:	83 ec 0c             	sub    $0xc,%esp
80103609:	50                   	push   %eax
8010360a:	e8 01 da ff ff       	call   80101010 <fileclose>
8010360f:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103612:	8b 06                	mov    (%esi),%eax
80103614:	85 c0                	test   %eax,%eax
80103616:	74 0c                	je     80103624 <pipealloc+0xe4>
    fileclose(*f1);
80103618:	83 ec 0c             	sub    $0xc,%esp
8010361b:	50                   	push   %eax
8010361c:	e8 ef d9 ff ff       	call   80101010 <fileclose>
80103621:	83 c4 10             	add    $0x10,%esp
}
80103624:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
80103627:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010362c:	5b                   	pop    %ebx
8010362d:	5e                   	pop    %esi
8010362e:	5f                   	pop    %edi
8010362f:	5d                   	pop    %ebp
80103630:	c3                   	ret    
80103631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
80103638:	8b 03                	mov    (%ebx),%eax
8010363a:	85 c0                	test   %eax,%eax
8010363c:	75 c8                	jne    80103606 <pipealloc+0xc6>
8010363e:	eb d2                	jmp    80103612 <pipealloc+0xd2>

80103640 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	56                   	push   %esi
80103644:	53                   	push   %ebx
80103645:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103648:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010364b:	83 ec 0c             	sub    $0xc,%esp
8010364e:	53                   	push   %ebx
8010364f:	e8 3c 17 00 00       	call   80104d90 <acquire>
  if(writable){
80103654:	83 c4 10             	add    $0x10,%esp
80103657:	85 f6                	test   %esi,%esi
80103659:	74 65                	je     801036c0 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
8010365b:	83 ec 0c             	sub    $0xc,%esp
8010365e:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103664:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010366b:	00 00 00 
    wakeup(&p->nread);
8010366e:	50                   	push   %eax
8010366f:	e8 3c 10 00 00       	call   801046b0 <wakeup>
80103674:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103677:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010367d:	85 d2                	test   %edx,%edx
8010367f:	75 0a                	jne    8010368b <pipeclose+0x4b>
80103681:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103687:	85 c0                	test   %eax,%eax
80103689:	74 15                	je     801036a0 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010368b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010368e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103691:	5b                   	pop    %ebx
80103692:	5e                   	pop    %esi
80103693:	5d                   	pop    %ebp
    release(&p->lock);
80103694:	e9 97 16 00 00       	jmp    80104d30 <release>
80103699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
801036a0:	83 ec 0c             	sub    $0xc,%esp
801036a3:	53                   	push   %ebx
801036a4:	e8 87 16 00 00       	call   80104d30 <release>
    kfree((char*)p);
801036a9:	89 5d 08             	mov    %ebx,0x8(%ebp)
801036ac:	83 c4 10             	add    $0x10,%esp
}
801036af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801036b2:	5b                   	pop    %ebx
801036b3:	5e                   	pop    %esi
801036b4:	5d                   	pop    %ebp
    kfree((char*)p);
801036b5:	e9 16 ef ff ff       	jmp    801025d0 <kfree>
801036ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
801036c0:	83 ec 0c             	sub    $0xc,%esp
801036c3:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801036c9:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801036d0:	00 00 00 
    wakeup(&p->nwrite);
801036d3:	50                   	push   %eax
801036d4:	e8 d7 0f 00 00       	call   801046b0 <wakeup>
801036d9:	83 c4 10             	add    $0x10,%esp
801036dc:	eb 99                	jmp    80103677 <pipeclose+0x37>
801036de:	66 90                	xchg   %ax,%ax

801036e0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	57                   	push   %edi
801036e4:	56                   	push   %esi
801036e5:	53                   	push   %ebx
801036e6:	83 ec 28             	sub    $0x28,%esp
801036e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801036ec:	53                   	push   %ebx
801036ed:	e8 9e 16 00 00       	call   80104d90 <acquire>
  for(i = 0; i < n; i++){
801036f2:	8b 45 10             	mov    0x10(%ebp),%eax
801036f5:	83 c4 10             	add    $0x10,%esp
801036f8:	85 c0                	test   %eax,%eax
801036fa:	0f 8e c0 00 00 00    	jle    801037c0 <pipewrite+0xe0>
80103700:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103703:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103709:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
8010370f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103712:	03 45 10             	add    0x10(%ebp),%eax
80103715:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103718:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010371e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103724:	89 ca                	mov    %ecx,%edx
80103726:	05 00 02 00 00       	add    $0x200,%eax
8010372b:	39 c1                	cmp    %eax,%ecx
8010372d:	74 3f                	je     8010376e <pipewrite+0x8e>
8010372f:	eb 67                	jmp    80103798 <pipewrite+0xb8>
80103731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
80103738:	e8 53 04 00 00       	call   80103b90 <myproc>
8010373d:	8b 48 24             	mov    0x24(%eax),%ecx
80103740:	85 c9                	test   %ecx,%ecx
80103742:	75 34                	jne    80103778 <pipewrite+0x98>
      wakeup(&p->nread);
80103744:	83 ec 0c             	sub    $0xc,%esp
80103747:	57                   	push   %edi
80103748:	e8 63 0f 00 00       	call   801046b0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010374d:	58                   	pop    %eax
8010374e:	5a                   	pop    %edx
8010374f:	53                   	push   %ebx
80103750:	56                   	push   %esi
80103751:	e8 9a 0e 00 00       	call   801045f0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103756:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010375c:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103762:	83 c4 10             	add    $0x10,%esp
80103765:	05 00 02 00 00       	add    $0x200,%eax
8010376a:	39 c2                	cmp    %eax,%edx
8010376c:	75 2a                	jne    80103798 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010376e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103774:	85 c0                	test   %eax,%eax
80103776:	75 c0                	jne    80103738 <pipewrite+0x58>
        release(&p->lock);
80103778:	83 ec 0c             	sub    $0xc,%esp
8010377b:	53                   	push   %ebx
8010377c:	e8 af 15 00 00       	call   80104d30 <release>
        return -1;
80103781:	83 c4 10             	add    $0x10,%esp
80103784:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103789:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010378c:	5b                   	pop    %ebx
8010378d:	5e                   	pop    %esi
8010378e:	5f                   	pop    %edi
8010378f:	5d                   	pop    %ebp
80103790:	c3                   	ret    
80103791:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103798:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010379b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010379e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801037a4:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
801037aa:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
801037ad:	83 c6 01             	add    $0x1,%esi
801037b0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801037b3:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801037b7:	3b 75 e0             	cmp    -0x20(%ebp),%esi
801037ba:	0f 85 58 ff ff ff    	jne    80103718 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801037c0:	83 ec 0c             	sub    $0xc,%esp
801037c3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801037c9:	50                   	push   %eax
801037ca:	e8 e1 0e 00 00       	call   801046b0 <wakeup>
  release(&p->lock);
801037cf:	89 1c 24             	mov    %ebx,(%esp)
801037d2:	e8 59 15 00 00       	call   80104d30 <release>
  return n;
801037d7:	8b 45 10             	mov    0x10(%ebp),%eax
801037da:	83 c4 10             	add    $0x10,%esp
801037dd:	eb aa                	jmp    80103789 <pipewrite+0xa9>
801037df:	90                   	nop

801037e0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801037e0:	55                   	push   %ebp
801037e1:	89 e5                	mov    %esp,%ebp
801037e3:	57                   	push   %edi
801037e4:	56                   	push   %esi
801037e5:	53                   	push   %ebx
801037e6:	83 ec 18             	sub    $0x18,%esp
801037e9:	8b 75 08             	mov    0x8(%ebp),%esi
801037ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801037ef:	56                   	push   %esi
801037f0:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801037f6:	e8 95 15 00 00       	call   80104d90 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037fb:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103801:	83 c4 10             	add    $0x10,%esp
80103804:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
8010380a:	74 2f                	je     8010383b <piperead+0x5b>
8010380c:	eb 37                	jmp    80103845 <piperead+0x65>
8010380e:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
80103810:	e8 7b 03 00 00       	call   80103b90 <myproc>
80103815:	8b 48 24             	mov    0x24(%eax),%ecx
80103818:	85 c9                	test   %ecx,%ecx
8010381a:	0f 85 80 00 00 00    	jne    801038a0 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103820:	83 ec 08             	sub    $0x8,%esp
80103823:	56                   	push   %esi
80103824:	53                   	push   %ebx
80103825:	e8 c6 0d 00 00       	call   801045f0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010382a:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
80103830:	83 c4 10             	add    $0x10,%esp
80103833:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
80103839:	75 0a                	jne    80103845 <piperead+0x65>
8010383b:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
80103841:	85 c0                	test   %eax,%eax
80103843:	75 cb                	jne    80103810 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103845:	8b 55 10             	mov    0x10(%ebp),%edx
80103848:	31 db                	xor    %ebx,%ebx
8010384a:	85 d2                	test   %edx,%edx
8010384c:	7f 20                	jg     8010386e <piperead+0x8e>
8010384e:	eb 2c                	jmp    8010387c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103850:	8d 48 01             	lea    0x1(%eax),%ecx
80103853:	25 ff 01 00 00       	and    $0x1ff,%eax
80103858:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010385e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103863:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103866:	83 c3 01             	add    $0x1,%ebx
80103869:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010386c:	74 0e                	je     8010387c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010386e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103874:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010387a:	75 d4                	jne    80103850 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010387c:	83 ec 0c             	sub    $0xc,%esp
8010387f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103885:	50                   	push   %eax
80103886:	e8 25 0e 00 00       	call   801046b0 <wakeup>
  release(&p->lock);
8010388b:	89 34 24             	mov    %esi,(%esp)
8010388e:	e8 9d 14 00 00       	call   80104d30 <release>
  return i;
80103893:	83 c4 10             	add    $0x10,%esp
}
80103896:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103899:	89 d8                	mov    %ebx,%eax
8010389b:	5b                   	pop    %ebx
8010389c:	5e                   	pop    %esi
8010389d:	5f                   	pop    %edi
8010389e:	5d                   	pop    %ebp
8010389f:	c3                   	ret    
      release(&p->lock);
801038a0:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801038a3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
801038a8:	56                   	push   %esi
801038a9:	e8 82 14 00 00       	call   80104d30 <release>
      return -1;
801038ae:	83 c4 10             	add    $0x10,%esp
}
801038b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801038b4:	89 d8                	mov    %ebx,%eax
801038b6:	5b                   	pop    %ebx
801038b7:	5e                   	pop    %esi
801038b8:	5f                   	pop    %edi
801038b9:	5d                   	pop    %ebp
801038ba:	c3                   	ret    
801038bb:	66 90                	xchg   %ax,%ax
801038bd:	66 90                	xchg   %ax,%ax
801038bf:	90                   	nop

801038c0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc *
allocproc(void)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038c4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801038c9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801038cc:	68 20 2d 11 80       	push   $0x80112d20
801038d1:	e8 ba 14 00 00       	call   80104d90 <acquire>
801038d6:	83 c4 10             	add    $0x10,%esp
801038d9:	eb 13                	jmp    801038ee <allocproc+0x2e>
801038db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038df:	90                   	nop
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801038e0:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
801038e6:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
801038ec:	74 7a                	je     80103968 <allocproc+0xa8>
    if (p->state == UNUSED)
801038ee:	8b 43 0c             	mov    0xc(%ebx),%eax
801038f1:	85 c0                	test   %eax,%eax
801038f3:	75 eb                	jne    801038e0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801038f5:	a1 18 b0 10 80       	mov    0x8010b018,%eax

  release(&ptable.lock);
801038fa:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801038fd:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103904:	89 43 10             	mov    %eax,0x10(%ebx)
80103907:	8d 50 01             	lea    0x1(%eax),%edx
  release(&ptable.lock);
8010390a:	68 20 2d 11 80       	push   $0x80112d20
  p->pid = nextpid++;
8010390f:	89 15 18 b0 10 80    	mov    %edx,0x8010b018
  release(&ptable.lock);
80103915:	e8 16 14 00 00       	call   80104d30 <release>

  // Allocate kernel stack.
  if ((p->kstack = kalloc()) == 0)
8010391a:	e8 71 ee ff ff       	call   80102790 <kalloc>
8010391f:	83 c4 10             	add    $0x10,%esp
80103922:	89 43 08             	mov    %eax,0x8(%ebx)
80103925:	85 c0                	test   %eax,%eax
80103927:	74 58                	je     80103981 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103929:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint *)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context *)sp;
  memset(p->context, 0, sizeof *p->context);
8010392f:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103932:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103937:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint *)sp = (uint)trapret;
8010393a:	c7 40 14 7a 61 10 80 	movl   $0x8010617a,0x14(%eax)
  p->context = (struct context *)sp;
80103941:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103944:	6a 14                	push   $0x14
80103946:	6a 00                	push   $0x0
80103948:	50                   	push   %eax
80103949:	e8 02 15 00 00       	call   80104e50 <memset>
  p->context->eip = (uint)forkret;
8010394e:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103951:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103954:	c7 40 10 a0 39 10 80 	movl   $0x801039a0,0x10(%eax)
}
8010395b:	89 d8                	mov    %ebx,%eax
8010395d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103960:	c9                   	leave  
80103961:	c3                   	ret    
80103962:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103968:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010396b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010396d:	68 20 2d 11 80       	push   $0x80112d20
80103972:	e8 b9 13 00 00       	call   80104d30 <release>
}
80103977:	89 d8                	mov    %ebx,%eax
  return 0;
80103979:	83 c4 10             	add    $0x10,%esp
}
8010397c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010397f:	c9                   	leave  
80103980:	c3                   	ret    
    p->state = UNUSED;
80103981:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103988:	31 db                	xor    %ebx,%ebx
}
8010398a:	89 d8                	mov    %ebx,%eax
8010398c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010398f:	c9                   	leave  
80103990:	c3                   	ret    
80103991:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010399f:	90                   	nop

801039a0 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void forkret(void)
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801039a6:	68 20 2d 11 80       	push   $0x80112d20
801039ab:	e8 80 13 00 00       	call   80104d30 <release>

  if (first)
801039b0:	a1 00 b0 10 80       	mov    0x8010b000,%eax
801039b5:	83 c4 10             	add    $0x10,%esp
801039b8:	85 c0                	test   %eax,%eax
801039ba:	75 04                	jne    801039c0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801039bc:	c9                   	leave  
801039bd:	c3                   	ret    
801039be:	66 90                	xchg   %ax,%ax
    first = 0;
801039c0:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801039c7:	00 00 00 
    iinit(ROOTDEV);
801039ca:	83 ec 0c             	sub    $0xc,%esp
801039cd:	6a 01                	push   $0x1
801039cf:	e8 9c dc ff ff       	call   80101670 <iinit>
    initlog(ROOTDEV);
801039d4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801039db:	e8 f0 f3 ff ff       	call   80102dd0 <initlog>
}
801039e0:	83 c4 10             	add    $0x10,%esp
801039e3:	c9                   	leave  
801039e4:	c3                   	ret    
801039e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039f0 <setProcessRank>:
{
801039f0:	55                   	push   %ebp
  p->rank = (1/p->ticket) * p->priorityRatio + p->arrivalTime * p->arrivalTimeRatio + p->executedCycle * p->executedCycleRatio;
801039f1:	b8 01 00 00 00       	mov    $0x1,%eax
801039f6:	99                   	cltd   
{
801039f7:	89 e5                	mov    %esp,%ebp
801039f9:	83 ec 04             	sub    $0x4,%esp
801039fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  p->rank = (1/p->ticket) * p->priorityRatio + p->arrivalTime * p->arrivalTimeRatio + p->executedCycle * p->executedCycleRatio;
801039ff:	f7 b9 98 00 00 00    	idivl  0x98(%ecx)
80103a05:	0f af 41 7c          	imul   0x7c(%ecx),%eax
80103a09:	89 45 fc             	mov    %eax,-0x4(%ebp)
80103a0c:	db 45 fc             	fildl  -0x4(%ebp)
80103a0f:	db 81 80 00 00 00    	fildl  0x80(%ecx)
80103a15:	d8 89 88 00 00 00    	fmuls  0x88(%ecx)
80103a1b:	de c1                	faddp  %st,%st(1)
80103a1d:	db 81 84 00 00 00    	fildl  0x84(%ecx)
80103a23:	d8 89 8c 00 00 00    	fmuls  0x8c(%ecx)
80103a29:	de c1                	faddp  %st,%st(1)
80103a2b:	d9 99 94 00 00 00    	fstps  0x94(%ecx)
}
80103a31:	c9                   	leave  
80103a32:	c3                   	ret    
80103a33:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103a40 <setDefaultSchedulingValues>:
{
80103a40:	55                   	push   %ebp
  p->arrivalTime = ticks; //not sure
80103a41:	31 d2                	xor    %edx,%edx
{
80103a43:	89 e5                	mov    %esp,%ebp
80103a45:	53                   	push   %ebx
80103a46:	83 ec 14             	sub    $0x14,%esp
80103a49:	8b 4d 08             	mov    0x8(%ebp),%ecx
  p->priorityRatio = default_priorityRatio;
80103a4c:	a1 14 b0 10 80       	mov    0x8010b014,%eax
  p->arrivalTime = ticks; //not sure
80103a51:	89 55 ec             	mov    %edx,-0x14(%ebp)
  p->ticket = default_ticket;
80103a54:	8b 1d 08 b0 10 80    	mov    0x8010b008,%ebx
  p->arrivalTimeRatio = default_arrivalTimeRatio;
80103a5a:	d9 05 10 b0 10 80    	flds   0x8010b010
  p->priorityRatio = default_priorityRatio;
80103a60:	89 41 7c             	mov    %eax,0x7c(%ecx)
  p->arrivalTimeRatio = default_arrivalTimeRatio;
80103a63:	d9 7d f6             	fnstcw -0xa(%ebp)
80103a66:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80103a6a:	80 cc 0c             	or     $0xc,%ah
80103a6d:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  p->arrivalTime = ticks; //not sure
80103a71:	a1 60 56 11 80       	mov    0x80115660,%eax
  p->arrivalTimeRatio = default_arrivalTimeRatio;
80103a76:	d9 6d f4             	fldcw  -0xc(%ebp)
80103a79:	db 99 80 00 00 00    	fistpl 0x80(%ecx)
80103a7f:	d9 6d f6             	fldcw  -0xa(%ebp)
  p->arrivalTime = ticks; //not sure
80103a82:	89 45 e8             	mov    %eax,-0x18(%ebp)
  p->priority = 1 / p->ticket;;
80103a85:	b8 01 00 00 00       	mov    $0x1,%eax
80103a8a:	99                   	cltd   
80103a8b:	f7 fb                	idiv   %ebx
  p->executedCycleRatio = default_executedCycleRatio;
80103a8d:	d9 05 0c b0 10 80    	flds   0x8010b00c
80103a93:	d9 6d f4             	fldcw  -0xc(%ebp)
80103a96:	db 99 84 00 00 00    	fistpl 0x84(%ecx)
80103a9c:	d9 6d f6             	fldcw  -0xa(%ebp)
  p->ticket = default_ticket;
80103a9f:	89 99 98 00 00 00    	mov    %ebx,0x98(%ecx)
  p->arrivalTime = ticks; //not sure
80103aa5:	df 6d e8             	fildll -0x18(%ebp)
80103aa8:	d9 99 88 00 00 00    	fstps  0x88(%ecx)
  p->executedCycle = 0;
80103aae:	d9 ee                	fldz   
80103ab0:	d9 91 8c 00 00 00    	fsts   0x8c(%ecx)
  p->priority = 1 / p->ticket;;
80103ab6:	89 45 e8             	mov    %eax,-0x18(%ebp)
80103ab9:	db 45 e8             	fildl  -0x18(%ebp)
  p->level = default_level;
80103abc:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->priority = 1 / p->ticket;;
80103ac1:	d9 99 90 00 00 00    	fstps  0x90(%ecx)
  p->level = default_level;
80103ac7:	89 81 a0 00 00 00    	mov    %eax,0xa0(%ecx)
  p->waitingCycle = 0;
80103acd:	d9 99 9c 00 00 00    	fstps  0x9c(%ecx)
}
80103ad3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ad6:	c9                   	leave  
80103ad7:	c3                   	ret    
80103ad8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103adf:	90                   	nop

80103ae0 <pinit>:
{
80103ae0:	55                   	push   %ebp
80103ae1:	89 e5                	mov    %esp,%ebp
80103ae3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103ae6:	68 20 80 10 80       	push   $0x80108020
80103aeb:	68 20 2d 11 80       	push   $0x80112d20
80103af0:	e8 cb 10 00 00       	call   80104bc0 <initlock>
}
80103af5:	83 c4 10             	add    $0x10,%esp
80103af8:	c9                   	leave  
80103af9:	c3                   	ret    
80103afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103b00 <mycpu>:
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
80103b03:	56                   	push   %esi
80103b04:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b05:	9c                   	pushf  
80103b06:	58                   	pop    %eax
  if (readeflags() & FL_IF)
80103b07:	f6 c4 02             	test   $0x2,%ah
80103b0a:	75 4e                	jne    80103b5a <mycpu+0x5a>
  apicid = lapicid();
80103b0c:	e8 ef ee ff ff       	call   80102a00 <lapicid>
  for (i = 0; i < ncpu; ++i)
80103b11:	8b 35 84 27 11 80    	mov    0x80112784,%esi
  apicid = lapicid();
80103b17:	89 c3                	mov    %eax,%ebx
  for (i = 0; i < ncpu; ++i)
80103b19:	85 f6                	test   %esi,%esi
80103b1b:	7e 30                	jle    80103b4d <mycpu+0x4d>
80103b1d:	31 c0                	xor    %eax,%eax
80103b1f:	eb 0e                	jmp    80103b2f <mycpu+0x2f>
80103b21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b28:	83 c0 01             	add    $0x1,%eax
80103b2b:	39 f0                	cmp    %esi,%eax
80103b2d:	74 1e                	je     80103b4d <mycpu+0x4d>
    if (cpus[i].apicid == apicid)
80103b2f:	69 d0 b0 00 00 00    	imul   $0xb0,%eax,%edx
80103b35:	0f b6 8a a0 27 11 80 	movzbl -0x7feed860(%edx),%ecx
80103b3c:	39 d9                	cmp    %ebx,%ecx
80103b3e:	75 e8                	jne    80103b28 <mycpu+0x28>
}
80103b40:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103b43:	8d 82 a0 27 11 80    	lea    -0x7feed860(%edx),%eax
}
80103b49:	5b                   	pop    %ebx
80103b4a:	5e                   	pop    %esi
80103b4b:	5d                   	pop    %ebp
80103b4c:	c3                   	ret    
  panic("unknown apicid\n");
80103b4d:	83 ec 0c             	sub    $0xc,%esp
80103b50:	68 27 80 10 80       	push   $0x80108027
80103b55:	e8 26 c8 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103b5a:	83 ec 0c             	sub    $0xc,%esp
80103b5d:	68 50 81 10 80       	push   $0x80108150
80103b62:	e8 19 c8 ff ff       	call   80100380 <panic>
80103b67:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b6e:	66 90                	xchg   %ax,%ax

80103b70 <cpuid>:
{
80103b70:	55                   	push   %ebp
80103b71:	89 e5                	mov    %esp,%ebp
80103b73:	83 ec 08             	sub    $0x8,%esp
  return mycpu() - cpus;
80103b76:	e8 85 ff ff ff       	call   80103b00 <mycpu>
}
80103b7b:	c9                   	leave  
  return mycpu() - cpus;
80103b7c:	2d a0 27 11 80       	sub    $0x801127a0,%eax
80103b81:	c1 f8 04             	sar    $0x4,%eax
80103b84:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103b8a:	c3                   	ret    
80103b8b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b8f:	90                   	nop

80103b90 <myproc>:
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	53                   	push   %ebx
80103b94:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103b97:	e8 a4 10 00 00       	call   80104c40 <pushcli>
  c = mycpu();
80103b9c:	e8 5f ff ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103ba1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ba7:	e8 e4 10 00 00       	call   80104c90 <popcli>
}
80103bac:	89 d8                	mov    %ebx,%eax
80103bae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103bb1:	c9                   	leave  
80103bb2:	c3                   	ret    
80103bb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bc0 <userinit>:
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	53                   	push   %ebx
80103bc4:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
80103bc7:	e8 f4 fc ff ff       	call   801038c0 <allocproc>
80103bcc:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103bce:	a3 54 56 11 80       	mov    %eax,0x80115654
  if ((p->pgdir = setupkvm()) == 0)
80103bd3:	e8 b8 3b 00 00       	call   80107790 <setupkvm>
80103bd8:	89 43 04             	mov    %eax,0x4(%ebx)
80103bdb:	85 c0                	test   %eax,%eax
80103bdd:	0f 84 46 01 00 00    	je     80103d29 <userinit+0x169>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103be3:	83 ec 04             	sub    $0x4,%esp
80103be6:	68 2c 00 00 00       	push   $0x2c
80103beb:	68 60 b4 10 80       	push   $0x8010b460
80103bf0:	50                   	push   %eax
80103bf1:	e8 4a 38 00 00       	call   80107440 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103bf6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103bf9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103bff:	6a 4c                	push   $0x4c
80103c01:	6a 00                	push   $0x0
80103c03:	ff 73 18             	pushl  0x18(%ebx)
80103c06:	e8 45 12 00 00       	call   80104e50 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c0b:	8b 43 18             	mov    0x18(%ebx),%eax
80103c0e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c13:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c16:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103c1b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103c1f:	8b 43 18             	mov    0x18(%ebx),%eax
80103c22:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103c26:	8b 43 18             	mov    0x18(%ebx),%eax
80103c29:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c2d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103c31:	8b 43 18             	mov    0x18(%ebx),%eax
80103c34:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103c38:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103c3c:	8b 43 18             	mov    0x18(%ebx),%eax
80103c3f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103c46:	8b 43 18             	mov    0x18(%ebx),%eax
80103c49:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0; // beginning of initcode.S
80103c50:	8b 43 18             	mov    0x18(%ebx),%eax
80103c53:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103c5a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103c5d:	6a 10                	push   $0x10
80103c5f:	68 50 80 10 80       	push   $0x80108050
80103c64:	50                   	push   %eax
80103c65:	e8 a6 13 00 00       	call   80105010 <safestrcpy>
  p->cwd = namei("/");
80103c6a:	c7 04 24 59 80 10 80 	movl   $0x80108059,(%esp)
80103c71:	e8 3a e5 ff ff       	call   801021b0 <namei>
80103c76:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103c79:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c80:	e8 0b 11 00 00       	call   80104d90 <acquire>
  p->priorityRatio = default_priorityRatio;
80103c85:	a1 14 b0 10 80       	mov    0x8010b014,%eax
  p->arrivalTime = ticks; //not sure
80103c8a:	31 d2                	xor    %edx,%edx
  p->ticket = default_ticket;
80103c8c:	8b 0d 08 b0 10 80    	mov    0x8010b008,%ecx
  p->arrivalTime = ticks; //not sure
80103c92:	89 55 ec             	mov    %edx,-0x14(%ebp)
  p->arrivalTimeRatio = default_arrivalTimeRatio;
80103c95:	d9 05 10 b0 10 80    	flds   0x8010b010
  p->priorityRatio = default_priorityRatio;
80103c9b:	89 43 7c             	mov    %eax,0x7c(%ebx)
  p->arrivalTimeRatio = default_arrivalTimeRatio;
80103c9e:	d9 7d f6             	fnstcw -0xa(%ebp)
80103ca1:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
80103ca5:	80 cc 0c             	or     $0xc,%ah
80103ca8:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  p->arrivalTime = ticks; //not sure
80103cac:	a1 60 56 11 80       	mov    0x80115660,%eax
  p->arrivalTimeRatio = default_arrivalTimeRatio;
80103cb1:	d9 6d f4             	fldcw  -0xc(%ebp)
80103cb4:	db 9b 80 00 00 00    	fistpl 0x80(%ebx)
80103cba:	d9 6d f6             	fldcw  -0xa(%ebp)
  p->arrivalTime = ticks; //not sure
80103cbd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  p->priority = 1 / p->ticket;;
80103cc0:	b8 01 00 00 00       	mov    $0x1,%eax
80103cc5:	99                   	cltd   
80103cc6:	f7 f9                	idiv   %ecx
  p->executedCycleRatio = default_executedCycleRatio;
80103cc8:	d9 05 0c b0 10 80    	flds   0x8010b00c
80103cce:	d9 6d f4             	fldcw  -0xc(%ebp)
80103cd1:	db 9b 84 00 00 00    	fistpl 0x84(%ebx)
80103cd7:	d9 6d f6             	fldcw  -0xa(%ebp)
  p->ticket = default_ticket;
80103cda:	89 8b 98 00 00 00    	mov    %ecx,0x98(%ebx)
  p->state = RUNNABLE;
80103ce0:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->arrivalTime = ticks; //not sure
80103ce7:	df 6d e8             	fildll -0x18(%ebp)
80103cea:	d9 9b 88 00 00 00    	fstps  0x88(%ebx)
  p->executedCycle = 0;
80103cf0:	d9 ee                	fldz   
80103cf2:	d9 93 8c 00 00 00    	fsts   0x8c(%ebx)
  p->priority = 1 / p->ticket;;
80103cf8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  p->level = default_level;
80103cfb:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->priority = 1 / p->ticket;;
80103d00:	db 45 e8             	fildl  -0x18(%ebp)
  p->level = default_level;
80103d03:	89 83 a0 00 00 00    	mov    %eax,0xa0(%ebx)
  p->priority = 1 / p->ticket;;
80103d09:	d9 9b 90 00 00 00    	fstps  0x90(%ebx)
  p->waitingCycle = 0;
80103d0f:	d9 9b 9c 00 00 00    	fstps  0x9c(%ebx)
  release(&ptable.lock);
80103d15:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d1c:	e8 0f 10 00 00       	call   80104d30 <release>
}
80103d21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d24:	83 c4 10             	add    $0x10,%esp
80103d27:	c9                   	leave  
80103d28:	c3                   	ret    
    panic("userinit: out of memory?");
80103d29:	83 ec 0c             	sub    $0xc,%esp
80103d2c:	68 37 80 10 80       	push   $0x80108037
80103d31:	e8 4a c6 ff ff       	call   80100380 <panic>
80103d36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103d3d:	8d 76 00             	lea    0x0(%esi),%esi

80103d40 <growproc>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	56                   	push   %esi
80103d44:	53                   	push   %ebx
80103d45:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d48:	e8 f3 0e 00 00       	call   80104c40 <pushcli>
  c = mycpu();
80103d4d:	e8 ae fd ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103d52:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d58:	e8 33 0f 00 00       	call   80104c90 <popcli>
  sz = curproc->sz;
80103d5d:	8b 03                	mov    (%ebx),%eax
  if (n > 0)
80103d5f:	85 f6                	test   %esi,%esi
80103d61:	7f 1d                	jg     80103d80 <growproc+0x40>
  else if (n < 0)
80103d63:	75 3b                	jne    80103da0 <growproc+0x60>
  switchuvm(curproc);
80103d65:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103d68:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103d6a:	53                   	push   %ebx
80103d6b:	e8 c0 35 00 00       	call   80107330 <switchuvm>
  return 0;
80103d70:	83 c4 10             	add    $0x10,%esp
80103d73:	31 c0                	xor    %eax,%eax
}
80103d75:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103d78:	5b                   	pop    %ebx
80103d79:	5e                   	pop    %esi
80103d7a:	5d                   	pop    %ebp
80103d7b:	c3                   	ret    
80103d7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103d80:	83 ec 04             	sub    $0x4,%esp
80103d83:	01 c6                	add    %eax,%esi
80103d85:	56                   	push   %esi
80103d86:	50                   	push   %eax
80103d87:	ff 73 04             	pushl  0x4(%ebx)
80103d8a:	e8 21 38 00 00       	call   801075b0 <allocuvm>
80103d8f:	83 c4 10             	add    $0x10,%esp
80103d92:	85 c0                	test   %eax,%eax
80103d94:	75 cf                	jne    80103d65 <growproc+0x25>
      return -1;
80103d96:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103d9b:	eb d8                	jmp    80103d75 <growproc+0x35>
80103d9d:	8d 76 00             	lea    0x0(%esi),%esi
    if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103da0:	83 ec 04             	sub    $0x4,%esp
80103da3:	01 c6                	add    %eax,%esi
80103da5:	56                   	push   %esi
80103da6:	50                   	push   %eax
80103da7:	ff 73 04             	pushl  0x4(%ebx)
80103daa:	e8 31 39 00 00       	call   801076e0 <deallocuvm>
80103daf:	83 c4 10             	add    $0x10,%esp
80103db2:	85 c0                	test   %eax,%eax
80103db4:	75 af                	jne    80103d65 <growproc+0x25>
80103db6:	eb de                	jmp    80103d96 <growproc+0x56>
80103db8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dbf:	90                   	nop

80103dc0 <fork>:
{
80103dc0:	55                   	push   %ebp
80103dc1:	89 e5                	mov    %esp,%ebp
80103dc3:	57                   	push   %edi
80103dc4:	56                   	push   %esi
80103dc5:	53                   	push   %ebx
80103dc6:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103dc9:	e8 72 0e 00 00       	call   80104c40 <pushcli>
  c = mycpu();
80103dce:	e8 2d fd ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80103dd3:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80103dd9:	89 55 d8             	mov    %edx,-0x28(%ebp)
  popcli();
80103ddc:	e8 af 0e 00 00       	call   80104c90 <popcli>
  if ((np = allocproc()) == 0)
80103de1:	e8 da fa ff ff       	call   801038c0 <allocproc>
80103de6:	85 c0                	test   %eax,%eax
80103de8:	0f 84 4e 01 00 00    	je     80103f3c <fork+0x17c>
  if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
80103dee:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103df1:	83 ec 08             	sub    $0x8,%esp
80103df4:	89 c3                	mov    %eax,%ebx
80103df6:	ff 32                	pushl  (%edx)
80103df8:	ff 72 04             	pushl  0x4(%edx)
80103dfb:	e8 80 3a 00 00       	call   80107880 <copyuvm>
80103e00:	83 c4 10             	add    $0x10,%esp
80103e03:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103e06:	85 c0                	test   %eax,%eax
80103e08:	89 43 04             	mov    %eax,0x4(%ebx)
80103e0b:	0f 84 32 01 00 00    	je     80103f43 <fork+0x183>
  np->sz = curproc->sz;
80103e11:	8b 02                	mov    (%edx),%eax
  *np->tf = *curproc->tf;
80103e13:	8b 7b 18             	mov    0x18(%ebx),%edi
  np->parent = curproc;
80103e16:	89 53 14             	mov    %edx,0x14(%ebx)
  *np->tf = *curproc->tf;
80103e19:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103e1e:	89 03                	mov    %eax,(%ebx)
  *np->tf = *curproc->tf;
80103e20:	8b 72 18             	mov    0x18(%edx),%esi
80103e23:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < NOFILE; i++)
80103e25:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e27:	8b 43 18             	mov    0x18(%ebx),%eax
80103e2a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for (i = 0; i < NOFILE; i++)
80103e31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (curproc->ofile[i])
80103e38:	8b 44 b2 28          	mov    0x28(%edx,%esi,4),%eax
80103e3c:	85 c0                	test   %eax,%eax
80103e3e:	74 16                	je     80103e56 <fork+0x96>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103e40:	83 ec 0c             	sub    $0xc,%esp
80103e43:	89 55 d8             	mov    %edx,-0x28(%ebp)
80103e46:	50                   	push   %eax
80103e47:	e8 74 d1 ff ff       	call   80100fc0 <filedup>
80103e4c:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103e4f:	83 c4 10             	add    $0x10,%esp
80103e52:	89 44 b3 28          	mov    %eax,0x28(%ebx,%esi,4)
  for (i = 0; i < NOFILE; i++)
80103e56:	83 c6 01             	add    $0x1,%esi
80103e59:	83 fe 10             	cmp    $0x10,%esi
80103e5c:	75 da                	jne    80103e38 <fork+0x78>
  np->cwd = idup(curproc->cwd);
80103e5e:	83 ec 0c             	sub    $0xc,%esp
80103e61:	ff 72 68             	pushl  0x68(%edx)
80103e64:	89 55 d8             	mov    %edx,-0x28(%ebp)
80103e67:	e8 f4 d9 ff ff       	call   80101860 <idup>
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e6c:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103e6f:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103e72:	89 43 68             	mov    %eax,0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103e75:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103e78:	83 c2 6c             	add    $0x6c,%edx
80103e7b:	6a 10                	push   $0x10
80103e7d:	52                   	push   %edx
80103e7e:	50                   	push   %eax
80103e7f:	e8 8c 11 00 00       	call   80105010 <safestrcpy>
  pid = np->pid;
80103e84:	8b 73 10             	mov    0x10(%ebx),%esi
  acquire(&ptable.lock);
80103e87:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e8e:	e8 fd 0e 00 00       	call   80104d90 <acquire>
  p->priorityRatio = default_priorityRatio;
80103e93:	a1 14 b0 10 80       	mov    0x8010b014,%eax
  np->state = RUNNABLE;
80103e98:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  p->arrivalTime = ticks; //not sure
80103e9f:	31 d2                	xor    %edx,%edx
  p->ticket = default_ticket;
80103ea1:	8b 0d 08 b0 10 80    	mov    0x8010b008,%ecx
  p->arrivalTime = ticks; //not sure
80103ea7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  p->priorityRatio = default_priorityRatio;
80103eaa:	89 43 7c             	mov    %eax,0x7c(%ebx)
  p->arrivalTimeRatio = default_arrivalTimeRatio;
80103ead:	d9 05 10 b0 10 80    	flds   0x8010b010
80103eb3:	d9 7d e6             	fnstcw -0x1a(%ebp)
80103eb6:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
80103eba:	80 cc 0c             	or     $0xc,%ah
80103ebd:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  p->arrivalTime = ticks; //not sure
80103ec1:	a1 60 56 11 80       	mov    0x80115660,%eax
  p->arrivalTimeRatio = default_arrivalTimeRatio;
80103ec6:	d9 6d e4             	fldcw  -0x1c(%ebp)
80103ec9:	db 9b 80 00 00 00    	fistpl 0x80(%ebx)
80103ecf:	d9 6d e6             	fldcw  -0x1a(%ebp)
  p->arrivalTime = ticks; //not sure
80103ed2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  p->priority = 1 / p->ticket;;
80103ed5:	b8 01 00 00 00       	mov    $0x1,%eax
80103eda:	99                   	cltd   
80103edb:	f7 f9                	idiv   %ecx
  p->executedCycleRatio = default_executedCycleRatio;
80103edd:	d9 05 0c b0 10 80    	flds   0x8010b00c
80103ee3:	d9 6d e4             	fldcw  -0x1c(%ebp)
80103ee6:	db 9b 84 00 00 00    	fistpl 0x84(%ebx)
80103eec:	d9 6d e6             	fldcw  -0x1a(%ebp)
  p->ticket = default_ticket;
80103eef:	89 8b 98 00 00 00    	mov    %ecx,0x98(%ebx)
  p->arrivalTime = ticks; //not sure
80103ef5:	df 6d d8             	fildll -0x28(%ebp)
80103ef8:	d9 9b 88 00 00 00    	fstps  0x88(%ebx)
  p->executedCycle = 0;
80103efe:	d9 ee                	fldz   
80103f00:	d9 93 8c 00 00 00    	fsts   0x8c(%ebx)
  p->priority = 1 / p->ticket;;
80103f06:	89 45 d8             	mov    %eax,-0x28(%ebp)
  p->level = default_level;
80103f09:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  p->priority = 1 / p->ticket;;
80103f0e:	db 45 d8             	fildl  -0x28(%ebp)
  p->level = default_level;
80103f11:	89 83 a0 00 00 00    	mov    %eax,0xa0(%ebx)
  p->priority = 1 / p->ticket;;
80103f17:	d9 9b 90 00 00 00    	fstps  0x90(%ebx)
  p->waitingCycle = 0;
80103f1d:	d9 9b 9c 00 00 00    	fstps  0x9c(%ebx)
  release(&ptable.lock);
80103f23:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f2a:	e8 01 0e 00 00       	call   80104d30 <release>
  return pid;
80103f2f:	83 c4 10             	add    $0x10,%esp
}
80103f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f35:	89 f0                	mov    %esi,%eax
80103f37:	5b                   	pop    %ebx
80103f38:	5e                   	pop    %esi
80103f39:	5f                   	pop    %edi
80103f3a:	5d                   	pop    %ebp
80103f3b:	c3                   	ret    
    return -1;
80103f3c:	be ff ff ff ff       	mov    $0xffffffff,%esi
80103f41:	eb ef                	jmp    80103f32 <fork+0x172>
    kfree(np->kstack);
80103f43:	83 ec 0c             	sub    $0xc,%esp
80103f46:	ff 73 08             	pushl  0x8(%ebx)
    return -1;
80103f49:	be ff ff ff ff       	mov    $0xffffffff,%esi
    kfree(np->kstack);
80103f4e:	e8 7d e6 ff ff       	call   801025d0 <kfree>
    np->kstack = 0;
80103f53:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    return -1;
80103f5a:	83 c4 10             	add    $0x10,%esp
    np->state = UNUSED;
80103f5d:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103f64:	eb cc                	jmp    80103f32 <fork+0x172>
80103f66:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f6d:	8d 76 00             	lea    0x0(%esi),%esi

80103f70 <getRandom>:
{
80103f70:	55                   	push   %ebp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f71:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
  int random = 1, randomDevotee = 1;
80103f76:	ba 01 00 00 00       	mov    $0x1,%edx
{
80103f7b:	89 e5                	mov    %esp,%ebp
80103f7d:	83 ec 08             	sub    $0x8,%esp
80103f80:	d9 7d fe             	fnstcw -0x2(%ebp)
80103f83:	0f b7 4d fe          	movzwl -0x2(%ebp),%ecx
80103f87:	80 cd 0c             	or     $0xc,%ch
80103f8a:	66 89 4d fc          	mov    %cx,-0x4(%ebp)
80103f8e:	66 90                	xchg   %ax,%ax
    randomDevotee *= p->arrivalTime * p->pid * p->waitingCycle * (int)p->rank;
80103f90:	db 40 10             	fildl  0x10(%eax)
80103f93:	d8 88 88 00 00 00    	fmuls  0x88(%eax)
80103f99:	d8 88 9c 00 00 00    	fmuls  0x9c(%eax)
80103f9f:	d9 80 94 00 00 00    	flds   0x94(%eax)
80103fa5:	d9 6d fc             	fldcw  -0x4(%ebp)
80103fa8:	db 5d f8             	fistpl -0x8(%ebp)
80103fab:	d9 6d fe             	fldcw  -0x2(%ebp)
80103fae:	db 45 f8             	fildl  -0x8(%ebp)
80103fb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
80103fb4:	de c9                	fmulp  %st,%st(1)
80103fb6:	db 45 f8             	fildl  -0x8(%ebp)
80103fb9:	de c9                	fmulp  %st,%st(1)
80103fbb:	d9 6d fc             	fldcw  -0x4(%ebp)
80103fbe:	db 5d f8             	fistpl -0x8(%ebp)
80103fc1:	d9 6d fe             	fldcw  -0x2(%ebp)
80103fc4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
    if (randomDevotee != 0)
80103fc7:	85 c9                	test   %ecx,%ecx
80103fc9:	0f 45 d1             	cmovne %ecx,%edx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103fcc:	05 a4 00 00 00       	add    $0xa4,%eax
80103fd1:	3d 54 56 11 80       	cmp    $0x80115654,%eax
80103fd6:	75 b8                	jne    80103f90 <getRandom+0x20>
}
80103fd8:	c9                   	leave  
80103fd9:	89 d0                	mov    %edx,%eax
80103fdb:	c3                   	ret    
80103fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103fe0 <lottery>:
{
80103fe0:	55                   	push   %ebp
80103fe1:	89 e5                	mov    %esp,%ebp
80103fe3:	57                   	push   %edi
80103fe4:	56                   	push   %esi
80103fe5:	53                   	push   %ebx
80103fe6:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103fe9:	8d bb 00 01 00 00    	lea    0x100(%ebx),%edi
    int a=getRandom()%allTickets;
80103fef:	e8 7c ff ff ff       	call   80103f70 <getRandom>
    int s=0;
80103ff4:	31 c9                	xor    %ecx,%ecx
    int a=getRandom()%allTickets;
80103ff6:	99                   	cltd   
80103ff7:	f7 7d 0c             	idivl  0xc(%ebp)
    for(int i=0;i<NPROC;i++)
80103ffa:	89 d8                	mov    %ebx,%eax
80103ffc:	eb 09                	jmp    80104007 <lottery+0x27>
80103ffe:	66 90                	xchg   %ax,%ax
80104000:	83 c0 04             	add    $0x4,%eax
80104003:	39 f8                	cmp    %edi,%eax
80104005:	74 19                	je     80104020 <lottery+0x40>
        if(s+lvl2[i]->ticket>a)
80104007:	8b 30                	mov    (%eax),%esi
80104009:	03 8e 98 00 00 00    	add    0x98(%esi),%ecx
8010400f:	39 d1                	cmp    %edx,%ecx
80104011:	7e ed                	jle    80104000 <lottery+0x20>
}
80104013:	5b                   	pop    %ebx
80104014:	89 f0                	mov    %esi,%eax
80104016:	5e                   	pop    %esi
80104017:	5f                   	pop    %edi
80104018:	5d                   	pop    %ebp
80104019:	c3                   	ret    
8010401a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return lvl2[0];
80104020:	8b 33                	mov    (%ebx),%esi
}
80104022:	5b                   	pop    %ebx
80104023:	89 f0                	mov    %esi,%eax
80104025:	5e                   	pop    %esi
80104026:	5f                   	pop    %edi
80104027:	5d                   	pop    %ebp
80104028:	c3                   	ret    
80104029:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104030 <choose>:
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	57                   	push   %edi
  best=ptable.proc;
80104034:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
{
80104039:	56                   	push   %esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010403a:	89 f9                	mov    %edi,%ecx
{
8010403c:	53                   	push   %ebx
8010403d:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  tckts=0;
80104043:	c7 85 e8 fe ff ff 00 	movl   $0x0,-0x118(%ebp)
8010404a:	00 00 00 
  j=0;
8010404d:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80104054:	00 00 00 
80104057:	eb 39                	jmp    80104092 <choose+0x62>
80104059:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    else if(best->level==p->level)
80104060:	0f 84 1a 01 00 00    	je     80104180 <choose+0x150>
80104066:	dd d8                	fstp   %st(0)
80104068:	eb 16                	jmp    80104080 <choose+0x50>
8010406a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104070:	dd d8                	fstp   %st(0)
80104072:	eb 0c                	jmp    80104080 <choose+0x50>
80104074:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104078:	dd d8                	fstp   %st(0)
8010407a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104080:	81 c1 a4 00 00 00    	add    $0xa4,%ecx
80104086:	81 f9 54 56 11 80    	cmp    $0x80115654,%ecx
8010408c:	0f 84 a1 00 00 00    	je     80104133 <choose+0x103>
    p->waitingCycle+=1;
80104092:	d9 e8                	fld1   
80104094:	d8 81 9c 00 00 00    	fadds  0x9c(%ecx)
    if(p->state != RUNNABLE)
8010409a:	83 79 0c 03          	cmpl   $0x3,0xc(%ecx)
    p->waitingCycle+=1;
8010409e:	d9 91 9c 00 00 00    	fsts   0x9c(%ecx)
    if(p->state != RUNNABLE)
801040a4:	75 ca                	jne    80104070 <choose+0x40>
    if(p->waitingCycle>=10000)
801040a6:	d9 05 74 82 10 80    	flds   0x80108274
801040ac:	d9 c9                	fxch   %st(1)
      tckts+=p->ticket;
801040ae:	8b 99 98 00 00 00    	mov    0x98(%ecx),%ebx
    if(p->waitingCycle>=10000)
801040b4:	df f1                	fcomip %st(1),%st
801040b6:	dd d8                	fstp   %st(0)
801040b8:	0f 82 92 00 00 00    	jb     80104150 <choose+0x120>
      p->waitingCycle=0;
801040be:	c7 81 9c 00 00 00 00 	movl   $0x0,0x9c(%ecx)
801040c5:	00 00 00 
    if(p->level==2)
801040c8:	be 01 00 00 00       	mov    $0x1,%esi
      p->level=1;
801040cd:	c7 81 a0 00 00 00 01 	movl   $0x1,0xa0(%ecx)
801040d4:	00 00 00 
  p->rank = (1/p->ticket) * p->priorityRatio + p->arrivalTime * p->arrivalTimeRatio + p->executedCycle * p->executedCycleRatio;
801040d7:	b8 01 00 00 00       	mov    $0x1,%eax
801040dc:	99                   	cltd   
801040dd:	f7 fb                	idiv   %ebx
801040df:	0f af 41 7c          	imul   0x7c(%ecx),%eax
801040e3:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801040e9:	db 85 f0 fe ff ff    	fildl  -0x110(%ebp)
801040ef:	db 81 80 00 00 00    	fildl  0x80(%ecx)
801040f5:	d8 89 88 00 00 00    	fmuls  0x88(%ecx)
801040fb:	de c1                	faddp  %st,%st(1)
801040fd:	db 81 84 00 00 00    	fildl  0x84(%ecx)
80104103:	d8 89 8c 00 00 00    	fmuls  0x8c(%ecx)
80104109:	de c1                	faddp  %st,%st(1)
8010410b:	d9 91 94 00 00 00    	fsts   0x94(%ecx)
    if(best->level>p->level)
80104111:	39 b7 a0 00 00 00    	cmp    %esi,0xa0(%edi)
80104117:	0f 8e 43 ff ff ff    	jle    80104060 <choose+0x30>
8010411d:	dd d8                	fstp   %st(0)
8010411f:	89 cf                	mov    %ecx,%edi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104121:	81 c1 a4 00 00 00    	add    $0xa4,%ecx
80104127:	81 f9 54 56 11 80    	cmp    $0x80115654,%ecx
8010412d:	0f 85 5f ff ff ff    	jne    80104092 <choose+0x62>
  if(best->level!=2)
80104133:	83 bf a0 00 00 00 02 	cmpl   $0x2,0xa0(%edi)
8010413a:	74 5f                	je     8010419b <choose+0x16b>
}
8010413c:	81 c4 0c 01 00 00    	add    $0x10c,%esp
80104142:	89 f8                	mov    %edi,%eax
80104144:	5b                   	pop    %ebx
80104145:	5e                   	pop    %esi
80104146:	5f                   	pop    %edi
80104147:	5d                   	pop    %ebp
80104148:	c3                   	ret    
80104149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p->level==2)
80104150:	8b b1 a0 00 00 00    	mov    0xa0(%ecx),%esi
80104156:	83 fe 02             	cmp    $0x2,%esi
80104159:	0f 85 78 ff ff ff    	jne    801040d7 <choose+0xa7>
      lvl2[j]=p;
8010415f:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
      tckts+=p->ticket;
80104165:	01 9d e8 fe ff ff    	add    %ebx,-0x118(%ebp)
      lvl2[j]=p;
8010416b:	89 8c 85 f4 fe ff ff 	mov    %ecx,-0x10c(%ebp,%eax,4)
      j++;
80104172:	83 c0 01             	add    $0x1,%eax
80104175:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
8010417b:	e9 57 ff ff ff       	jmp    801040d7 <choose+0xa7>
        else if(p->level==3)
80104180:	83 fe 03             	cmp    $0x3,%esi
80104183:	0f 85 ef fe ff ff    	jne    80104078 <choose+0x48>
            if(p->rank<best->rank)
80104189:	d9 87 94 00 00 00    	flds   0x94(%edi)
8010418f:	df e9                	fucomip %st(1),%st
80104191:	dd d8                	fstp   %st(0)
80104193:	0f 47 f9             	cmova  %ecx,%edi
80104196:	e9 e5 fe ff ff       	jmp    80104080 <choose+0x50>
    int a=getRandom()%allTickets;
8010419b:	e8 d0 fd ff ff       	call   80103f70 <getRandom>
801041a0:	8d 5d f4             	lea    -0xc(%ebp),%ebx
    int s=0;
801041a3:	31 c9                	xor    %ecx,%ecx
    int a=getRandom()%allTickets;
801041a5:	99                   	cltd   
801041a6:	f7 bd e8 fe ff ff    	idivl  -0x118(%ebp)
    for(int i=0;i<NPROC;i++)
801041ac:	8d 85 f4 fe ff ff    	lea    -0x10c(%ebp),%eax
801041b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        if(s+lvl2[i]->ticket>a)
801041b8:	8b 38                	mov    (%eax),%edi
801041ba:	03 8f 98 00 00 00    	add    0x98(%edi),%ecx
801041c0:	39 ca                	cmp    %ecx,%edx
801041c2:	0f 8c 74 ff ff ff    	jl     8010413c <choose+0x10c>
    for(int i=0;i<NPROC;i++)
801041c8:	83 c0 04             	add    $0x4,%eax
801041cb:	39 d8                	cmp    %ebx,%eax
801041cd:	75 e9                	jne    801041b8 <choose+0x188>
    return lvl2[0];
801041cf:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
801041d5:	e9 62 ff ff ff       	jmp    8010413c <choose+0x10c>
801041da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041e0 <scheduler>:
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	57                   	push   %edi
801041e4:	56                   	push   %esi
801041e5:	53                   	push   %ebx
801041e6:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
801041e9:	e8 12 f9 ff ff       	call   80103b00 <mycpu>
  c->proc = 0;
801041ee:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801041f5:	00 00 00 
  struct cpu *c = mycpu();
801041f8:	89 c6                	mov    %eax,%esi
      swtch(&(c->scheduler), _p->context);
801041fa:	8d 78 04             	lea    0x4(%eax),%edi
801041fd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80104200:	fb                   	sti    
    acquire(&ptable.lock);
80104201:	83 ec 0c             	sub    $0xc,%esp
80104204:	68 20 2d 11 80       	push   $0x80112d20
80104209:	e8 82 0b 00 00       	call   80104d90 <acquire>
      _p = choose(/*ptable*/);
8010420e:	e8 1d fe ff ff       	call   80104030 <choose>
      c->proc = _p;
80104213:	89 86 ac 00 00 00    	mov    %eax,0xac(%esi)
      _p = choose(/*ptable*/);
80104219:	89 c3                	mov    %eax,%ebx
      switchuvm(_p);
8010421b:	89 04 24             	mov    %eax,(%esp)
8010421e:	e8 0d 31 00 00       	call   80107330 <switchuvm>
      _p->executedCycle+=0.1;
80104223:	dd 05 78 82 10 80    	fldl   0x80108278
80104229:	d8 83 8c 00 00 00    	fadds  0x8c(%ebx)
      _p->state = RUNNING;
8010422f:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      _p->executedCycle+=0.1;
80104236:	d9 9b 8c 00 00 00    	fstps  0x8c(%ebx)
      _p->waitingCycle-=1;
8010423c:	d9 e8                	fld1   
8010423e:	d8 ab 9c 00 00 00    	fsubrs 0x9c(%ebx)
80104244:	d9 9b 9c 00 00 00    	fstps  0x9c(%ebx)
      swtch(&(c->scheduler), _p->context);
8010424a:	58                   	pop    %eax
8010424b:	5a                   	pop    %edx
8010424c:	ff 73 1c             	pushl  0x1c(%ebx)
8010424f:	57                   	push   %edi
80104250:	e8 16 0e 00 00       	call   8010506b <swtch>
      switchkvm();
80104255:	e8 c6 30 00 00       	call   80107320 <switchkvm>
      c->proc = 0;
8010425a:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80104261:	00 00 00 
    release(&ptable.lock);
80104264:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010426b:	e8 c0 0a 00 00       	call   80104d30 <release>
80104270:	83 c4 10             	add    $0x10,%esp
80104273:	eb 8b                	jmp    80104200 <scheduler+0x20>
80104275:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010427c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104280 <sched>:
{
80104280:	55                   	push   %ebp
80104281:	89 e5                	mov    %esp,%ebp
80104283:	56                   	push   %esi
80104284:	53                   	push   %ebx
  pushcli();
80104285:	e8 b6 09 00 00       	call   80104c40 <pushcli>
  c = mycpu();
8010428a:	e8 71 f8 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
8010428f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104295:	e8 f6 09 00 00       	call   80104c90 <popcli>
  if (!holding(&ptable.lock))
8010429a:	83 ec 0c             	sub    $0xc,%esp
8010429d:	68 20 2d 11 80       	push   $0x80112d20
801042a2:	e8 49 0a 00 00       	call   80104cf0 <holding>
801042a7:	83 c4 10             	add    $0x10,%esp
801042aa:	85 c0                	test   %eax,%eax
801042ac:	74 4f                	je     801042fd <sched+0x7d>
  if (mycpu()->ncli != 1)
801042ae:	e8 4d f8 ff ff       	call   80103b00 <mycpu>
801042b3:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
801042ba:	75 68                	jne    80104324 <sched+0xa4>
  if (p->state == RUNNING)
801042bc:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
801042c0:	74 55                	je     80104317 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042c2:	9c                   	pushf  
801042c3:	58                   	pop    %eax
  if (readeflags() & FL_IF)
801042c4:	f6 c4 02             	test   $0x2,%ah
801042c7:	75 41                	jne    8010430a <sched+0x8a>
  intena = mycpu()->intena;
801042c9:	e8 32 f8 ff ff       	call   80103b00 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
801042ce:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
801042d1:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
801042d7:	e8 24 f8 ff ff       	call   80103b00 <mycpu>
801042dc:	83 ec 08             	sub    $0x8,%esp
801042df:	ff 70 04             	pushl  0x4(%eax)
801042e2:	53                   	push   %ebx
801042e3:	e8 83 0d 00 00       	call   8010506b <swtch>
  mycpu()->intena = intena;
801042e8:	e8 13 f8 ff ff       	call   80103b00 <mycpu>
}
801042ed:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
801042f0:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801042f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042f9:	5b                   	pop    %ebx
801042fa:	5e                   	pop    %esi
801042fb:	5d                   	pop    %ebp
801042fc:	c3                   	ret    
    panic("sched ptable.lock");
801042fd:	83 ec 0c             	sub    $0xc,%esp
80104300:	68 5b 80 10 80       	push   $0x8010805b
80104305:	e8 76 c0 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010430a:	83 ec 0c             	sub    $0xc,%esp
8010430d:	68 87 80 10 80       	push   $0x80108087
80104312:	e8 69 c0 ff ff       	call   80100380 <panic>
    panic("sched running");
80104317:	83 ec 0c             	sub    $0xc,%esp
8010431a:	68 79 80 10 80       	push   $0x80108079
8010431f:	e8 5c c0 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104324:	83 ec 0c             	sub    $0xc,%esp
80104327:	68 6d 80 10 80       	push   $0x8010806d
8010432c:	e8 4f c0 ff ff       	call   80100380 <panic>
80104331:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104338:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010433f:	90                   	nop

80104340 <exit>:
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	57                   	push   %edi
80104344:	56                   	push   %esi
80104345:	53                   	push   %ebx
80104346:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
80104349:	e8 42 f8 ff ff       	call   80103b90 <myproc>
  if (curproc == initproc)
8010434e:	39 05 54 56 11 80    	cmp    %eax,0x80115654
80104354:	0f 84 07 01 00 00    	je     80104461 <exit+0x121>
8010435a:	89 c3                	mov    %eax,%ebx
8010435c:	8d 70 28             	lea    0x28(%eax),%esi
8010435f:	8d 78 68             	lea    0x68(%eax),%edi
80104362:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if (curproc->ofile[fd])
80104368:	8b 06                	mov    (%esi),%eax
8010436a:	85 c0                	test   %eax,%eax
8010436c:	74 12                	je     80104380 <exit+0x40>
      fileclose(curproc->ofile[fd]);
8010436e:	83 ec 0c             	sub    $0xc,%esp
80104371:	50                   	push   %eax
80104372:	e8 99 cc ff ff       	call   80101010 <fileclose>
      curproc->ofile[fd] = 0;
80104377:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010437d:	83 c4 10             	add    $0x10,%esp
  for (fd = 0; fd < NOFILE; fd++)
80104380:	83 c6 04             	add    $0x4,%esi
80104383:	39 f7                	cmp    %esi,%edi
80104385:	75 e1                	jne    80104368 <exit+0x28>
  begin_op();
80104387:	e8 e4 ea ff ff       	call   80102e70 <begin_op>
  iput(curproc->cwd);
8010438c:	83 ec 0c             	sub    $0xc,%esp
8010438f:	ff 73 68             	pushl  0x68(%ebx)
80104392:	e8 29 d6 ff ff       	call   801019c0 <iput>
  end_op();
80104397:	e8 44 eb ff ff       	call   80102ee0 <end_op>
  curproc->cwd = 0;
8010439c:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
801043a3:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801043aa:	e8 e1 09 00 00       	call   80104d90 <acquire>
  wakeup1(curproc->parent);
801043af:	8b 53 14             	mov    0x14(%ebx),%edx
801043b2:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043b5:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801043ba:	eb 10                	jmp    801043cc <exit+0x8c>
801043bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801043c0:	05 a4 00 00 00       	add    $0xa4,%eax
801043c5:	3d 54 56 11 80       	cmp    $0x80115654,%eax
801043ca:	74 1e                	je     801043ea <exit+0xaa>
    if (p->state == SLEEPING && p->chan == chan)
801043cc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801043d0:	75 ee                	jne    801043c0 <exit+0x80>
801043d2:	3b 50 20             	cmp    0x20(%eax),%edx
801043d5:	75 e9                	jne    801043c0 <exit+0x80>
      p->state = RUNNABLE;
801043d7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043de:	05 a4 00 00 00       	add    $0xa4,%eax
801043e3:	3d 54 56 11 80       	cmp    $0x80115654,%eax
801043e8:	75 e2                	jne    801043cc <exit+0x8c>
      p->parent = initproc;
801043ea:	8b 0d 54 56 11 80    	mov    0x80115654,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043f0:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
801043f5:	eb 17                	jmp    8010440e <exit+0xce>
801043f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043fe:	66 90                	xchg   %ax,%ax
80104400:	81 c2 a4 00 00 00    	add    $0xa4,%edx
80104406:	81 fa 54 56 11 80    	cmp    $0x80115654,%edx
8010440c:	74 3a                	je     80104448 <exit+0x108>
    if (p->parent == curproc)
8010440e:	39 5a 14             	cmp    %ebx,0x14(%edx)
80104411:	75 ed                	jne    80104400 <exit+0xc0>
      if (p->state == ZOMBIE)
80104413:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104417:	89 4a 14             	mov    %ecx,0x14(%edx)
      if (p->state == ZOMBIE)
8010441a:	75 e4                	jne    80104400 <exit+0xc0>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010441c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80104421:	eb 11                	jmp    80104434 <exit+0xf4>
80104423:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104427:	90                   	nop
80104428:	05 a4 00 00 00       	add    $0xa4,%eax
8010442d:	3d 54 56 11 80       	cmp    $0x80115654,%eax
80104432:	74 cc                	je     80104400 <exit+0xc0>
    if (p->state == SLEEPING && p->chan == chan)
80104434:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104438:	75 ee                	jne    80104428 <exit+0xe8>
8010443a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010443d:	75 e9                	jne    80104428 <exit+0xe8>
      p->state = RUNNABLE;
8010443f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80104446:	eb e0                	jmp    80104428 <exit+0xe8>
  curproc->state = ZOMBIE;
80104448:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
8010444f:	e8 2c fe ff ff       	call   80104280 <sched>
  panic("zombie exit");
80104454:	83 ec 0c             	sub    $0xc,%esp
80104457:	68 a8 80 10 80       	push   $0x801080a8
8010445c:	e8 1f bf ff ff       	call   80100380 <panic>
    panic("init exiting");
80104461:	83 ec 0c             	sub    $0xc,%esp
80104464:	68 9b 80 10 80       	push   $0x8010809b
80104469:	e8 12 bf ff ff       	call   80100380 <panic>
8010446e:	66 90                	xchg   %ax,%ax

80104470 <wait>:
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	56                   	push   %esi
80104474:	53                   	push   %ebx
  pushcli();
80104475:	e8 c6 07 00 00       	call   80104c40 <pushcli>
  c = mycpu();
8010447a:	e8 81 f6 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
8010447f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104485:	e8 06 08 00 00       	call   80104c90 <popcli>
  acquire(&ptable.lock);
8010448a:	83 ec 0c             	sub    $0xc,%esp
8010448d:	68 20 2d 11 80       	push   $0x80112d20
80104492:	e8 f9 08 00 00       	call   80104d90 <acquire>
80104497:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010449a:	31 c0                	xor    %eax,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010449c:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801044a1:	eb 13                	jmp    801044b6 <wait+0x46>
801044a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044a7:	90                   	nop
801044a8:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
801044ae:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
801044b4:	74 1e                	je     801044d4 <wait+0x64>
      if (p->parent != curproc)
801044b6:	39 73 14             	cmp    %esi,0x14(%ebx)
801044b9:	75 ed                	jne    801044a8 <wait+0x38>
      if (p->state == ZOMBIE)
801044bb:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801044bf:	74 5f                	je     80104520 <wait+0xb0>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044c1:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
      havekids = 1;
801044c7:	b8 01 00 00 00       	mov    $0x1,%eax
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801044cc:	81 fb 54 56 11 80    	cmp    $0x80115654,%ebx
801044d2:	75 e2                	jne    801044b6 <wait+0x46>
    if (!havekids || curproc->killed)
801044d4:	85 c0                	test   %eax,%eax
801044d6:	0f 84 9a 00 00 00    	je     80104576 <wait+0x106>
801044dc:	8b 46 24             	mov    0x24(%esi),%eax
801044df:	85 c0                	test   %eax,%eax
801044e1:	0f 85 8f 00 00 00    	jne    80104576 <wait+0x106>
  pushcli();
801044e7:	e8 54 07 00 00       	call   80104c40 <pushcli>
  c = mycpu();
801044ec:	e8 0f f6 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
801044f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044f7:	e8 94 07 00 00       	call   80104c90 <popcli>
  if (p == 0)
801044fc:	85 db                	test   %ebx,%ebx
801044fe:	0f 84 89 00 00 00    	je     8010458d <wait+0x11d>
  p->chan = chan;
80104504:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
80104507:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
8010450e:	e8 6d fd ff ff       	call   80104280 <sched>
  p->chan = 0;
80104513:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010451a:	e9 7b ff ff ff       	jmp    8010449a <wait+0x2a>
8010451f:	90                   	nop
        kfree(p->kstack);
80104520:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
80104523:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104526:	ff 73 08             	pushl  0x8(%ebx)
80104529:	e8 a2 e0 ff ff       	call   801025d0 <kfree>
        p->kstack = 0;
8010452e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104535:	5a                   	pop    %edx
80104536:	ff 73 04             	pushl  0x4(%ebx)
80104539:	e8 d2 31 00 00       	call   80107710 <freevm>
        p->pid = 0;
8010453e:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104545:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010454c:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104550:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104557:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010455e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80104565:	e8 c6 07 00 00       	call   80104d30 <release>
        return pid;
8010456a:	83 c4 10             	add    $0x10,%esp
}
8010456d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104570:	89 f0                	mov    %esi,%eax
80104572:	5b                   	pop    %ebx
80104573:	5e                   	pop    %esi
80104574:	5d                   	pop    %ebp
80104575:	c3                   	ret    
      release(&ptable.lock);
80104576:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104579:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010457e:	68 20 2d 11 80       	push   $0x80112d20
80104583:	e8 a8 07 00 00       	call   80104d30 <release>
      return -1;
80104588:	83 c4 10             	add    $0x10,%esp
8010458b:	eb e0                	jmp    8010456d <wait+0xfd>
    panic("sleep");
8010458d:	83 ec 0c             	sub    $0xc,%esp
80104590:	68 b4 80 10 80       	push   $0x801080b4
80104595:	e8 e6 bd ff ff       	call   80100380 <panic>
8010459a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801045a0 <yield>:
{
801045a0:	55                   	push   %ebp
801045a1:	89 e5                	mov    %esp,%ebp
801045a3:	53                   	push   %ebx
801045a4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock); //DOC: yieldlock
801045a7:	68 20 2d 11 80       	push   $0x80112d20
801045ac:	e8 df 07 00 00       	call   80104d90 <acquire>
  pushcli();
801045b1:	e8 8a 06 00 00       	call   80104c40 <pushcli>
  c = mycpu();
801045b6:	e8 45 f5 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
801045bb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801045c1:	e8 ca 06 00 00       	call   80104c90 <popcli>
  myproc()->state = RUNNABLE;
801045c6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801045cd:	e8 ae fc ff ff       	call   80104280 <sched>
  release(&ptable.lock);
801045d2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801045d9:	e8 52 07 00 00       	call   80104d30 <release>
}
801045de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801045e1:	83 c4 10             	add    $0x10,%esp
801045e4:	c9                   	leave  
801045e5:	c3                   	ret    
801045e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045ed:	8d 76 00             	lea    0x0(%esi),%esi

801045f0 <sleep>:
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	57                   	push   %edi
801045f4:	56                   	push   %esi
801045f5:	53                   	push   %ebx
801045f6:	83 ec 0c             	sub    $0xc,%esp
801045f9:	8b 7d 08             	mov    0x8(%ebp),%edi
801045fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801045ff:	e8 3c 06 00 00       	call   80104c40 <pushcli>
  c = mycpu();
80104604:	e8 f7 f4 ff ff       	call   80103b00 <mycpu>
  p = c->proc;
80104609:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010460f:	e8 7c 06 00 00       	call   80104c90 <popcli>
  if (p == 0)
80104614:	85 db                	test   %ebx,%ebx
80104616:	0f 84 87 00 00 00    	je     801046a3 <sleep+0xb3>
  if (lk == 0)
8010461c:	85 f6                	test   %esi,%esi
8010461e:	74 76                	je     80104696 <sleep+0xa6>
  if (lk != &ptable.lock)
80104620:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80104626:	74 50                	je     80104678 <sleep+0x88>
    acquire(&ptable.lock); //DOC: sleeplock1
80104628:	83 ec 0c             	sub    $0xc,%esp
8010462b:	68 20 2d 11 80       	push   $0x80112d20
80104630:	e8 5b 07 00 00       	call   80104d90 <acquire>
    release(lk);
80104635:	89 34 24             	mov    %esi,(%esp)
80104638:	e8 f3 06 00 00       	call   80104d30 <release>
  p->chan = chan;
8010463d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104640:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104647:	e8 34 fc ff ff       	call   80104280 <sched>
  p->chan = 0;
8010464c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104653:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010465a:	e8 d1 06 00 00       	call   80104d30 <release>
    acquire(lk);
8010465f:	89 75 08             	mov    %esi,0x8(%ebp)
80104662:	83 c4 10             	add    $0x10,%esp
}
80104665:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104668:	5b                   	pop    %ebx
80104669:	5e                   	pop    %esi
8010466a:	5f                   	pop    %edi
8010466b:	5d                   	pop    %ebp
    acquire(lk);
8010466c:	e9 1f 07 00 00       	jmp    80104d90 <acquire>
80104671:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104678:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010467b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104682:	e8 f9 fb ff ff       	call   80104280 <sched>
  p->chan = 0;
80104687:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010468e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104691:	5b                   	pop    %ebx
80104692:	5e                   	pop    %esi
80104693:	5f                   	pop    %edi
80104694:	5d                   	pop    %ebp
80104695:	c3                   	ret    
    panic("sleep without lk");
80104696:	83 ec 0c             	sub    $0xc,%esp
80104699:	68 ba 80 10 80       	push   $0x801080ba
8010469e:	e8 dd bc ff ff       	call   80100380 <panic>
    panic("sleep");
801046a3:	83 ec 0c             	sub    $0xc,%esp
801046a6:	68 b4 80 10 80       	push   $0x801080b4
801046ab:	e8 d0 bc ff ff       	call   80100380 <panic>

801046b0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	53                   	push   %ebx
801046b4:	83 ec 10             	sub    $0x10,%esp
801046b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801046ba:	68 20 2d 11 80       	push   $0x80112d20
801046bf:	e8 cc 06 00 00       	call   80104d90 <acquire>
801046c4:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046c7:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
801046cc:	eb 0e                	jmp    801046dc <wakeup+0x2c>
801046ce:	66 90                	xchg   %ax,%ax
801046d0:	05 a4 00 00 00       	add    $0xa4,%eax
801046d5:	3d 54 56 11 80       	cmp    $0x80115654,%eax
801046da:	74 1e                	je     801046fa <wakeup+0x4a>
    if (p->state == SLEEPING && p->chan == chan)
801046dc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801046e0:	75 ee                	jne    801046d0 <wakeup+0x20>
801046e2:	3b 58 20             	cmp    0x20(%eax),%ebx
801046e5:	75 e9                	jne    801046d0 <wakeup+0x20>
      p->state = RUNNABLE;
801046e7:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801046ee:	05 a4 00 00 00       	add    $0xa4,%eax
801046f3:	3d 54 56 11 80       	cmp    $0x80115654,%eax
801046f8:	75 e2                	jne    801046dc <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801046fa:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80104701:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104704:	c9                   	leave  
  release(&ptable.lock);
80104705:	e9 26 06 00 00       	jmp    80104d30 <release>
8010470a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104710 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
80104710:	55                   	push   %ebp
80104711:	89 e5                	mov    %esp,%ebp
80104713:	53                   	push   %ebx
80104714:	83 ec 10             	sub    $0x10,%esp
80104717:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010471a:	68 20 2d 11 80       	push   $0x80112d20
8010471f:	e8 6c 06 00 00       	call   80104d90 <acquire>
80104724:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104727:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
8010472c:	eb 0e                	jmp    8010473c <kill+0x2c>
8010472e:	66 90                	xchg   %ax,%ax
80104730:	05 a4 00 00 00       	add    $0xa4,%eax
80104735:	3d 54 56 11 80       	cmp    $0x80115654,%eax
8010473a:	74 34                	je     80104770 <kill+0x60>
  {
    if (p->pid == pid)
8010473c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010473f:	75 ef                	jne    80104730 <kill+0x20>
    {
      p->killed = 1;
      // Wake process from sleep if necessary.
      if (p->state == SLEEPING)
80104741:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104745:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if (p->state == SLEEPING)
8010474c:	75 07                	jne    80104755 <kill+0x45>
        p->state = RUNNABLE;
8010474e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104755:	83 ec 0c             	sub    $0xc,%esp
80104758:	68 20 2d 11 80       	push   $0x80112d20
8010475d:	e8 ce 05 00 00       	call   80104d30 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104762:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104765:	83 c4 10             	add    $0x10,%esp
80104768:	31 c0                	xor    %eax,%eax
}
8010476a:	c9                   	leave  
8010476b:	c3                   	ret    
8010476c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104770:	83 ec 0c             	sub    $0xc,%esp
80104773:	68 20 2d 11 80       	push   $0x80112d20
80104778:	e8 b3 05 00 00       	call   80104d30 <release>
}
8010477d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104780:	83 c4 10             	add    $0x10,%esp
80104783:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104788:	c9                   	leave  
80104789:	c3                   	ret    
8010478a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104790 <procdump>:
//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	57                   	push   %edi
80104794:	56                   	push   %esi
80104795:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104798:	53                   	push   %ebx
80104799:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010479e:	83 ec 3c             	sub    $0x3c,%esp
801047a1:	eb 27                	jmp    801047ca <procdump+0x3a>
801047a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801047a7:	90                   	nop
    {
      getcallerpcs((uint *)p->context->ebp + 2, pc);
      for (i = 0; i < 10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801047a8:	83 ec 0c             	sub    $0xc,%esp
801047ab:	68 8b 85 10 80       	push   $0x8010858b
801047b0:	e8 cb be ff ff       	call   80100680 <cprintf>
801047b5:	83 c4 10             	add    $0x10,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801047b8:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
801047be:	81 fb c0 56 11 80    	cmp    $0x801156c0,%ebx
801047c4:	0f 84 7e 00 00 00    	je     80104848 <procdump+0xb8>
    if (p->state == UNUSED)
801047ca:	8b 43 a0             	mov    -0x60(%ebx),%eax
801047cd:	85 c0                	test   %eax,%eax
801047cf:	74 e7                	je     801047b8 <procdump+0x28>
      state = "???";
801047d1:	ba cb 80 10 80       	mov    $0x801080cb,%edx
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
801047d6:	83 f8 05             	cmp    $0x5,%eax
801047d9:	77 11                	ja     801047ec <procdump+0x5c>
801047db:	8b 14 85 5c 82 10 80 	mov    -0x7fef7da4(,%eax,4),%edx
      state = "???";
801047e2:	b8 cb 80 10 80       	mov    $0x801080cb,%eax
801047e7:	85 d2                	test   %edx,%edx
801047e9:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
801047ec:	53                   	push   %ebx
801047ed:	52                   	push   %edx
801047ee:	ff 73 a4             	pushl  -0x5c(%ebx)
801047f1:	68 cf 80 10 80       	push   $0x801080cf
801047f6:	e8 85 be ff ff       	call   80100680 <cprintf>
    if (p->state == SLEEPING)
801047fb:	83 c4 10             	add    $0x10,%esp
801047fe:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104802:	75 a4                	jne    801047a8 <procdump+0x18>
      getcallerpcs((uint *)p->context->ebp + 2, pc);
80104804:	83 ec 08             	sub    $0x8,%esp
80104807:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010480a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010480d:	50                   	push   %eax
8010480e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104811:	8b 40 0c             	mov    0xc(%eax),%eax
80104814:	83 c0 08             	add    $0x8,%eax
80104817:	50                   	push   %eax
80104818:	e8 c3 03 00 00       	call   80104be0 <getcallerpcs>
      for (i = 0; i < 10 && pc[i] != 0; i++)
8010481d:	83 c4 10             	add    $0x10,%esp
80104820:	8b 17                	mov    (%edi),%edx
80104822:	85 d2                	test   %edx,%edx
80104824:	74 82                	je     801047a8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104826:	83 ec 08             	sub    $0x8,%esp
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104829:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
8010482c:	52                   	push   %edx
8010482d:	68 21 7b 10 80       	push   $0x80107b21
80104832:	e8 49 be ff ff       	call   80100680 <cprintf>
      for (i = 0; i < 10 && pc[i] != 0; i++)
80104837:	83 c4 10             	add    $0x10,%esp
8010483a:	39 fe                	cmp    %edi,%esi
8010483c:	75 e2                	jne    80104820 <procdump+0x90>
8010483e:	e9 65 ff ff ff       	jmp    801047a8 <procdump+0x18>
80104843:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104847:	90                   	nop
  }
}
80104848:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010484b:	5b                   	pop    %ebx
8010484c:	5e                   	pop    %esi
8010484d:	5f                   	pop    %edi
8010484e:	5d                   	pop    %ebp
8010484f:	c3                   	ret    

80104850 <changeQueue>:

void 
changeQueue(int pid, int level)
{
80104850:	55                   	push   %ebp
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104851:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
{
80104856:	89 e5                	mov    %esp,%ebp
80104858:	8b 55 08             	mov    0x8(%ebp),%edx
8010485b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010485e:	66 90                	xchg   %ax,%ax
  {
    if (p->pid == pid)
80104860:	39 50 10             	cmp    %edx,0x10(%eax)
80104863:	75 06                	jne    8010486b <changeQueue+0x1b>
      p->level = level;
80104865:	89 88 a0 00 00 00    	mov    %ecx,0xa0(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010486b:	05 a4 00 00 00       	add    $0xa4,%eax
80104870:	3d 54 56 11 80       	cmp    $0x80115654,%eax
80104875:	75 e9                	jne    80104860 <changeQueue+0x10>
  }
}
80104877:	5d                   	pop    %ebp
80104878:	c3                   	ret    
80104879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104880 <setTicket>:

void 
setTicket(int pid, int ticket)
{
80104880:	55                   	push   %ebp
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104881:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
{
80104886:	89 e5                	mov    %esp,%ebp
80104888:	8b 55 08             	mov    0x8(%ebp),%edx
8010488b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010488e:	66 90                	xchg   %ax,%ax
  {
    if (p->pid == pid)
80104890:	39 50 10             	cmp    %edx,0x10(%eax)
80104893:	75 06                	jne    8010489b <setTicket+0x1b>
      p->ticket = ticket;
80104895:	89 88 98 00 00 00    	mov    %ecx,0x98(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010489b:	05 a4 00 00 00       	add    $0xa4,%eax
801048a0:	3d 54 56 11 80       	cmp    $0x80115654,%eax
801048a5:	75 e9                	jne    80104890 <setTicket+0x10>
  }
}
801048a7:	5d                   	pop    %ebp
801048a8:	c3                   	ret    
801048a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801048b0 <setProcessParameters>:

void 
setProcessParameters(int pid, int priorityRatio, int arrivalTimeRatio, int executedCycleRatio)
{
801048b0:	55                   	push   %ebp
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048b1:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
{
801048b6:	89 e5                	mov    %esp,%ebp
801048b8:	56                   	push   %esi
801048b9:	8b 55 08             	mov    0x8(%ebp),%edx
801048bc:	8b 75 0c             	mov    0xc(%ebp),%esi
801048bf:	53                   	push   %ebx
801048c0:	8b 4d 14             	mov    0x14(%ebp),%ecx
801048c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
801048c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048cd:	8d 76 00             	lea    0x0(%esi),%esi
  {
    if (p->pid == pid)
801048d0:	39 50 10             	cmp    %edx,0x10(%eax)
801048d3:	75 0f                	jne    801048e4 <setProcessParameters+0x34>
    {
      p->priorityRatio = priorityRatio;
801048d5:	89 70 7c             	mov    %esi,0x7c(%eax)
      p->arrivalTimeRatio = arrivalTimeRatio;
801048d8:	89 98 80 00 00 00    	mov    %ebx,0x80(%eax)
      p->executedCycleRatio = executedCycleRatio;
801048de:	89 88 84 00 00 00    	mov    %ecx,0x84(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801048e4:	05 a4 00 00 00       	add    $0xa4,%eax
801048e9:	3d 54 56 11 80       	cmp    $0x80115654,%eax
801048ee:	75 e0                	jne    801048d0 <setProcessParameters+0x20>
    }
  }
}
801048f0:	5b                   	pop    %ebx
801048f1:	5e                   	pop    %esi
801048f2:	5d                   	pop    %ebp
801048f3:	c3                   	ret    
801048f4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801048fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801048ff:	90                   	nop

80104900 <setSystemParameters>:

void 
setSystemParameters(int priorityRatio, int arrivalTimeRatio, int executedCycleRatio)
{
80104900:	55                   	push   %ebp
  struct proc *p;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104901:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
{
80104906:	89 e5                	mov    %esp,%ebp
80104908:	53                   	push   %ebx
80104909:	83 ec 04             	sub    $0x4,%esp
8010490c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010490f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104912:	8b 55 10             	mov    0x10(%ebp),%edx
80104915:	8d 76 00             	lea    0x0(%esi),%esi
  {
    p->priorityRatio = priorityRatio;
80104918:	89 58 7c             	mov    %ebx,0x7c(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010491b:	05 a4 00 00 00       	add    $0xa4,%eax
    p->arrivalTimeRatio = arrivalTimeRatio;
80104920:	89 48 dc             	mov    %ecx,-0x24(%eax)
    p->executedCycleRatio = executedCycleRatio;
80104923:	89 50 e0             	mov    %edx,-0x20(%eax)
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104926:	3d 54 56 11 80       	cmp    $0x80115654,%eax
8010492b:	75 eb                	jne    80104918 <setSystemParameters+0x18>
  }

  //changing default rations as well
  default_priorityRatio = priorityRatio;  
  default_arrivalTimeRatio = arrivalTimeRatio;
8010492d:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80104930:	db 45 f8             	fildl  -0x8(%ebp)
  default_executedCycleRatio = executedCycleRatio;
80104933:	89 55 f8             	mov    %edx,-0x8(%ebp)
  default_priorityRatio = priorityRatio;  
80104936:	89 1d 14 b0 10 80    	mov    %ebx,0x8010b014
}
8010493c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  default_arrivalTimeRatio = arrivalTimeRatio;
8010493f:	d9 1d 10 b0 10 80    	fstps  0x8010b010
  default_executedCycleRatio = executedCycleRatio;
80104945:	db 45 f8             	fildl  -0x8(%ebp)
80104948:	d9 1d 0c b0 10 80    	fstps  0x8010b00c
}
8010494e:	c9                   	leave  
8010494f:	c3                   	ret    

80104950 <getStateString>:

void
getStateString(enum procstate state, char* stringOut, int n)
{
80104950:	55                   	push   %ebp
80104951:	89 e5                	mov    %esp,%ebp
80104953:	8b 45 08             	mov    0x8(%ebp),%eax

  if (state == UNUSED)
80104956:	85 c0                	test   %eax,%eax
80104958:	74 1e                	je     80104978 <getStateString+0x28>
    safestrcpy("UNUSED", stringOut, n);
  else if (state == EMBRYO)
8010495a:	83 f8 01             	cmp    $0x1,%eax
8010495d:	74 39                	je     80104998 <getStateString+0x48>
    safestrcpy("EMBRYO", stringOut, n);
  else if (state == SLEEPING)
8010495f:	83 f8 02             	cmp    $0x2,%eax
80104962:	74 24                	je     80104988 <getStateString+0x38>
    safestrcpy("SLEEPING", stringOut, n);
  else if (state == RUNNABLE)
80104964:	83 f8 03             	cmp    $0x3,%eax
80104967:	74 3f                	je     801049a8 <getStateString+0x58>
    safestrcpy("RUNNABLE", stringOut, n);
  else if (state == RUNNING)
80104969:	83 f8 04             	cmp    $0x4,%eax
8010496c:	74 4a                	je     801049b8 <getStateString+0x68>
    safestrcpy("RUNNING", stringOut, n);
  else if (state == ZOMBIE)
8010496e:	83 f8 05             	cmp    $0x5,%eax
80104971:	74 55                	je     801049c8 <getStateString+0x78>
    safestrcpy("ZOMBIE", stringOut, n);

}
80104973:	5d                   	pop    %ebp
80104974:	c3                   	ret    
80104975:	8d 76 00             	lea    0x0(%esi),%esi
    safestrcpy("UNUSED", stringOut, n);
80104978:	c7 45 08 d8 80 10 80 	movl   $0x801080d8,0x8(%ebp)
}
8010497f:	5d                   	pop    %ebp
    safestrcpy("UNUSED", stringOut, n);
80104980:	e9 8b 06 00 00       	jmp    80105010 <safestrcpy>
80104985:	8d 76 00             	lea    0x0(%esi),%esi
    safestrcpy("SLEEPING", stringOut, n);
80104988:	c7 45 08 e6 80 10 80 	movl   $0x801080e6,0x8(%ebp)
}
8010498f:	5d                   	pop    %ebp
    safestrcpy("SLEEPING", stringOut, n);
80104990:	e9 7b 06 00 00       	jmp    80105010 <safestrcpy>
80104995:	8d 76 00             	lea    0x0(%esi),%esi
    safestrcpy("EMBRYO", stringOut, n);
80104998:	c7 45 08 df 80 10 80 	movl   $0x801080df,0x8(%ebp)
}
8010499f:	5d                   	pop    %ebp
    safestrcpy("EMBRYO", stringOut, n);
801049a0:	e9 6b 06 00 00       	jmp    80105010 <safestrcpy>
801049a5:	8d 76 00             	lea    0x0(%esi),%esi
    safestrcpy("RUNNABLE", stringOut, n);
801049a8:	c7 45 08 ef 80 10 80 	movl   $0x801080ef,0x8(%ebp)
}
801049af:	5d                   	pop    %ebp
    safestrcpy("RUNNABLE", stringOut, n);
801049b0:	e9 5b 06 00 00       	jmp    80105010 <safestrcpy>
801049b5:	8d 76 00             	lea    0x0(%esi),%esi
    safestrcpy("RUNNING", stringOut, n);
801049b8:	c7 45 08 f8 80 10 80 	movl   $0x801080f8,0x8(%ebp)
}
801049bf:	5d                   	pop    %ebp
    safestrcpy("RUNNING", stringOut, n);
801049c0:	e9 4b 06 00 00       	jmp    80105010 <safestrcpy>
801049c5:	8d 76 00             	lea    0x0(%esi),%esi
    safestrcpy("ZOMBIE", stringOut, n);
801049c8:	c7 45 08 00 81 10 80 	movl   $0x80108100,0x8(%ebp)
}
801049cf:	5d                   	pop    %ebp
    safestrcpy("ZOMBIE", stringOut, n);
801049d0:	e9 3b 06 00 00       	jmp    80105010 <safestrcpy>
801049d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801049dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801049e0 <showInfo>:

void
showInfo()
{
801049e0:	55                   	push   %ebp
801049e1:	89 e5                	mov    %esp,%ebp
801049e3:	56                   	push   %esi
801049e4:	53                   	push   %ebx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == UNUSED)
      continue;

    getStateString(p->state, stateString, 15);
801049e5:	8d 75 e9             	lea    -0x17(%ebp),%esi
{
801049e8:	83 ec 1c             	sub    $0x1c,%esp
  cprintf("name\tpid\tstate\tticket\tlevel\tpriorityRatio\tarrivalTimeRatio\texecutedCycleRatio\trank\texecutedCycle");
801049eb:	68 78 81 10 80       	push   $0x80108178
801049f0:	e8 8b bc ff ff       	call   80100680 <cprintf>
  cprintf("-------------------------------------------------------------------------------------",
801049f5:	59                   	pop    %ecx
801049f6:	5b                   	pop    %ebx
801049f7:	68 dc 81 10 80       	push   $0x801081dc
801049fc:	68 04 82 10 80       	push   $0x80108204
80104a01:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80104a06:	e8 75 bc ff ff       	call   80100680 <cprintf>
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a0b:	83 c4 10             	add    $0x10,%esp
80104a0e:	66 90                	xchg   %ax,%ax
    if (p->state == UNUSED)
80104a10:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104a13:	85 c0                	test   %eax,%eax
80104a15:	74 56                	je     80104a6d <showInfo+0x8d>
    getStateString(p->state, stateString, 15);
80104a17:	83 ec 04             	sub    $0x4,%esp
80104a1a:	6a 0f                	push   $0xf
80104a1c:	56                   	push   %esi
80104a1d:	50                   	push   %eax
80104a1e:	e8 2d ff ff ff       	call   80104950 <getStateString>

    cprintf("%s\t%d\t%s\t%d\t%d\t", p->name, p->pid, stateString, p->ticket, p->level);
80104a23:	58                   	pop    %eax
80104a24:	5a                   	pop    %edx
80104a25:	ff 73 34             	pushl  0x34(%ebx)
80104a28:	ff 73 2c             	pushl  0x2c(%ebx)
80104a2b:	56                   	push   %esi
80104a2c:	ff 73 a4             	pushl  -0x5c(%ebx)
80104a2f:	53                   	push   %ebx
80104a30:	68 07 81 10 80       	push   $0x80108107
80104a35:	e8 46 bc ff ff       	call   80100680 <cprintf>
    cprintf("%d\t%d\t%d\t", p->priorityRatio, p->arrivalTimeRatio, p->executedCycleRatio);
80104a3a:	83 c4 20             	add    $0x20,%esp
80104a3d:	ff 73 18             	pushl  0x18(%ebx)
80104a40:	ff 73 14             	pushl  0x14(%ebx)
80104a43:	ff 73 10             	pushl  0x10(%ebx)
80104a46:	68 17 81 10 80       	push   $0x80108117
80104a4b:	e8 30 bc ff ff       	call   80100680 <cprintf>
    cprintf("%f\tf", p->rank, p->executedCycle);
80104a50:	d9 43 20             	flds   0x20(%ebx)
80104a53:	83 ec 0c             	sub    $0xc,%esp
80104a56:	dd 5c 24 08          	fstpl  0x8(%esp)
80104a5a:	d9 43 28             	flds   0x28(%ebx)
80104a5d:	dd 1c 24             	fstpl  (%esp)
80104a60:	68 21 81 10 80       	push   $0x80108121
80104a65:	e8 16 bc ff ff       	call   80100680 <cprintf>
80104a6a:	83 c4 20             	add    $0x20,%esp
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104a6d:	81 c3 a4 00 00 00    	add    $0xa4,%ebx
80104a73:	81 fb c0 56 11 80    	cmp    $0x801156c0,%ebx
80104a79:	75 95                	jne    80104a10 <showInfo+0x30>
  }

}
80104a7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a7e:	5b                   	pop    %ebx
80104a7f:	5e                   	pop    %esi
80104a80:	5d                   	pop    %ebp
80104a81:	c3                   	ret    
80104a82:	66 90                	xchg   %ax,%ax
80104a84:	66 90                	xchg   %ax,%ax
80104a86:	66 90                	xchg   %ax,%ax
80104a88:	66 90                	xchg   %ax,%ax
80104a8a:	66 90                	xchg   %ax,%ax
80104a8c:	66 90                	xchg   %ax,%ax
80104a8e:	66 90                	xchg   %ax,%ax

80104a90 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104a90:	55                   	push   %ebp
80104a91:	89 e5                	mov    %esp,%ebp
80104a93:	53                   	push   %ebx
80104a94:	83 ec 0c             	sub    $0xc,%esp
80104a97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80104a9a:	68 80 82 10 80       	push   $0x80108280
80104a9f:	8d 43 04             	lea    0x4(%ebx),%eax
80104aa2:	50                   	push   %eax
80104aa3:	e8 18 01 00 00       	call   80104bc0 <initlock>
  lk->name = name;
80104aa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104aab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104ab1:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104ab4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
80104abb:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104abe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ac1:	c9                   	leave  
80104ac2:	c3                   	ret    
80104ac3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ad0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	53                   	push   %ebx
80104ad5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104ad8:	8d 73 04             	lea    0x4(%ebx),%esi
80104adb:	83 ec 0c             	sub    $0xc,%esp
80104ade:	56                   	push   %esi
80104adf:	e8 ac 02 00 00       	call   80104d90 <acquire>
  while (lk->locked) {
80104ae4:	8b 13                	mov    (%ebx),%edx
80104ae6:	83 c4 10             	add    $0x10,%esp
80104ae9:	85 d2                	test   %edx,%edx
80104aeb:	74 16                	je     80104b03 <acquiresleep+0x33>
80104aed:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104af0:	83 ec 08             	sub    $0x8,%esp
80104af3:	56                   	push   %esi
80104af4:	53                   	push   %ebx
80104af5:	e8 f6 fa ff ff       	call   801045f0 <sleep>
  while (lk->locked) {
80104afa:	8b 03                	mov    (%ebx),%eax
80104afc:	83 c4 10             	add    $0x10,%esp
80104aff:	85 c0                	test   %eax,%eax
80104b01:	75 ed                	jne    80104af0 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104b03:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104b09:	e8 82 f0 ff ff       	call   80103b90 <myproc>
80104b0e:	8b 40 10             	mov    0x10(%eax),%eax
80104b11:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104b14:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104b17:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b1a:	5b                   	pop    %ebx
80104b1b:	5e                   	pop    %esi
80104b1c:	5d                   	pop    %ebp
  release(&lk->lk);
80104b1d:	e9 0e 02 00 00       	jmp    80104d30 <release>
80104b22:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b30 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104b30:	55                   	push   %ebp
80104b31:	89 e5                	mov    %esp,%ebp
80104b33:	56                   	push   %esi
80104b34:	53                   	push   %ebx
80104b35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104b38:	8d 73 04             	lea    0x4(%ebx),%esi
80104b3b:	83 ec 0c             	sub    $0xc,%esp
80104b3e:	56                   	push   %esi
80104b3f:	e8 4c 02 00 00       	call   80104d90 <acquire>
  lk->locked = 0;
80104b44:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104b4a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104b51:	89 1c 24             	mov    %ebx,(%esp)
80104b54:	e8 57 fb ff ff       	call   801046b0 <wakeup>
  release(&lk->lk);
80104b59:	89 75 08             	mov    %esi,0x8(%ebp)
80104b5c:	83 c4 10             	add    $0x10,%esp
}
80104b5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b62:	5b                   	pop    %ebx
80104b63:	5e                   	pop    %esi
80104b64:	5d                   	pop    %ebp
  release(&lk->lk);
80104b65:	e9 c6 01 00 00       	jmp    80104d30 <release>
80104b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104b70 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80104b70:	55                   	push   %ebp
80104b71:	89 e5                	mov    %esp,%ebp
80104b73:	57                   	push   %edi
80104b74:	31 ff                	xor    %edi,%edi
80104b76:	56                   	push   %esi
80104b77:	53                   	push   %ebx
80104b78:	83 ec 18             	sub    $0x18,%esp
80104b7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80104b7e:	8d 73 04             	lea    0x4(%ebx),%esi
80104b81:	56                   	push   %esi
80104b82:	e8 09 02 00 00       	call   80104d90 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104b87:	8b 03                	mov    (%ebx),%eax
80104b89:	83 c4 10             	add    $0x10,%esp
80104b8c:	85 c0                	test   %eax,%eax
80104b8e:	75 18                	jne    80104ba8 <holdingsleep+0x38>
  release(&lk->lk);
80104b90:	83 ec 0c             	sub    $0xc,%esp
80104b93:	56                   	push   %esi
80104b94:	e8 97 01 00 00       	call   80104d30 <release>
  return r;
}
80104b99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104b9c:	89 f8                	mov    %edi,%eax
80104b9e:	5b                   	pop    %ebx
80104b9f:	5e                   	pop    %esi
80104ba0:	5f                   	pop    %edi
80104ba1:	5d                   	pop    %ebp
80104ba2:	c3                   	ret    
80104ba3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ba7:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104ba8:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104bab:	e8 e0 ef ff ff       	call   80103b90 <myproc>
80104bb0:	39 58 10             	cmp    %ebx,0x10(%eax)
80104bb3:	0f 94 c0             	sete   %al
80104bb6:	0f b6 c0             	movzbl %al,%eax
80104bb9:	89 c7                	mov    %eax,%edi
80104bbb:	eb d3                	jmp    80104b90 <holdingsleep+0x20>
80104bbd:	66 90                	xchg   %ax,%ax
80104bbf:	90                   	nop

80104bc0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104bc0:	55                   	push   %ebp
80104bc1:	89 e5                	mov    %esp,%ebp
80104bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104bc6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104bc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
80104bcf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104bd2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104bd9:	5d                   	pop    %ebp
80104bda:	c3                   	ret    
80104bdb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104bdf:	90                   	nop

80104be0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104be0:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104be1:	31 d2                	xor    %edx,%edx
{
80104be3:	89 e5                	mov    %esp,%ebp
80104be5:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104be6:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104be9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
80104bec:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
80104bef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104bf0:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104bf6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104bfc:	77 1a                	ja     80104c18 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80104bfe:	8b 58 04             	mov    0x4(%eax),%ebx
80104c01:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104c04:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104c07:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104c09:	83 fa 0a             	cmp    $0xa,%edx
80104c0c:	75 e2                	jne    80104bf0 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
80104c0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c11:	c9                   	leave  
80104c12:	c3                   	ret    
80104c13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c17:	90                   	nop
  for(; i < 10; i++)
80104c18:	8d 04 91             	lea    (%ecx,%edx,4),%eax
80104c1b:	8d 51 28             	lea    0x28(%ecx),%edx
80104c1e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104c20:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104c26:	83 c0 04             	add    $0x4,%eax
80104c29:	39 d0                	cmp    %edx,%eax
80104c2b:	75 f3                	jne    80104c20 <getcallerpcs+0x40>
}
80104c2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c30:	c9                   	leave  
80104c31:	c3                   	ret    
80104c32:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104c40 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104c40:	55                   	push   %ebp
80104c41:	89 e5                	mov    %esp,%ebp
80104c43:	53                   	push   %ebx
80104c44:	83 ec 04             	sub    $0x4,%esp
80104c47:	9c                   	pushf  
80104c48:	5b                   	pop    %ebx
  asm volatile("cli");
80104c49:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80104c4a:	e8 b1 ee ff ff       	call   80103b00 <mycpu>
80104c4f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104c55:	85 c0                	test   %eax,%eax
80104c57:	74 17                	je     80104c70 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80104c59:	e8 a2 ee ff ff       	call   80103b00 <mycpu>
80104c5e:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104c65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c68:	c9                   	leave  
80104c69:	c3                   	ret    
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
80104c70:	e8 8b ee ff ff       	call   80103b00 <mycpu>
80104c75:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104c7b:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80104c81:	eb d6                	jmp    80104c59 <pushcli+0x19>
80104c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c90 <popcli>:

void
popcli(void)
{
80104c90:	55                   	push   %ebp
80104c91:	89 e5                	mov    %esp,%ebp
80104c93:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104c96:	9c                   	pushf  
80104c97:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104c98:	f6 c4 02             	test   $0x2,%ah
80104c9b:	75 35                	jne    80104cd2 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80104c9d:	e8 5e ee ff ff       	call   80103b00 <mycpu>
80104ca2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104ca9:	78 34                	js     80104cdf <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104cab:	e8 50 ee ff ff       	call   80103b00 <mycpu>
80104cb0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104cb6:	85 d2                	test   %edx,%edx
80104cb8:	74 06                	je     80104cc0 <popcli+0x30>
    sti();
}
80104cba:	c9                   	leave  
80104cbb:	c3                   	ret    
80104cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104cc0:	e8 3b ee ff ff       	call   80103b00 <mycpu>
80104cc5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104ccb:	85 c0                	test   %eax,%eax
80104ccd:	74 eb                	je     80104cba <popcli+0x2a>
  asm volatile("sti");
80104ccf:	fb                   	sti    
}
80104cd0:	c9                   	leave  
80104cd1:	c3                   	ret    
    panic("popcli - interruptible");
80104cd2:	83 ec 0c             	sub    $0xc,%esp
80104cd5:	68 8b 82 10 80       	push   $0x8010828b
80104cda:	e8 a1 b6 ff ff       	call   80100380 <panic>
    panic("popcli");
80104cdf:	83 ec 0c             	sub    $0xc,%esp
80104ce2:	68 a2 82 10 80       	push   $0x801082a2
80104ce7:	e8 94 b6 ff ff       	call   80100380 <panic>
80104cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104cf0 <holding>:
{
80104cf0:	55                   	push   %ebp
80104cf1:	89 e5                	mov    %esp,%ebp
80104cf3:	56                   	push   %esi
80104cf4:	53                   	push   %ebx
80104cf5:	8b 75 08             	mov    0x8(%ebp),%esi
80104cf8:	31 db                	xor    %ebx,%ebx
  pushcli();
80104cfa:	e8 41 ff ff ff       	call   80104c40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104cff:	8b 06                	mov    (%esi),%eax
80104d01:	85 c0                	test   %eax,%eax
80104d03:	75 0b                	jne    80104d10 <holding+0x20>
  popcli();
80104d05:	e8 86 ff ff ff       	call   80104c90 <popcli>
}
80104d0a:	89 d8                	mov    %ebx,%eax
80104d0c:	5b                   	pop    %ebx
80104d0d:	5e                   	pop    %esi
80104d0e:	5d                   	pop    %ebp
80104d0f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104d10:	8b 5e 08             	mov    0x8(%esi),%ebx
80104d13:	e8 e8 ed ff ff       	call   80103b00 <mycpu>
80104d18:	39 c3                	cmp    %eax,%ebx
80104d1a:	0f 94 c3             	sete   %bl
  popcli();
80104d1d:	e8 6e ff ff ff       	call   80104c90 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104d22:	0f b6 db             	movzbl %bl,%ebx
}
80104d25:	89 d8                	mov    %ebx,%eax
80104d27:	5b                   	pop    %ebx
80104d28:	5e                   	pop    %esi
80104d29:	5d                   	pop    %ebp
80104d2a:	c3                   	ret    
80104d2b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104d2f:	90                   	nop

80104d30 <release>:
{
80104d30:	55                   	push   %ebp
80104d31:	89 e5                	mov    %esp,%ebp
80104d33:	56                   	push   %esi
80104d34:	53                   	push   %ebx
80104d35:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104d38:	e8 03 ff ff ff       	call   80104c40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104d3d:	8b 03                	mov    (%ebx),%eax
80104d3f:	85 c0                	test   %eax,%eax
80104d41:	75 15                	jne    80104d58 <release+0x28>
  popcli();
80104d43:	e8 48 ff ff ff       	call   80104c90 <popcli>
    panic("release");
80104d48:	83 ec 0c             	sub    $0xc,%esp
80104d4b:	68 a9 82 10 80       	push   $0x801082a9
80104d50:	e8 2b b6 ff ff       	call   80100380 <panic>
80104d55:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104d58:	8b 73 08             	mov    0x8(%ebx),%esi
80104d5b:	e8 a0 ed ff ff       	call   80103b00 <mycpu>
80104d60:	39 c6                	cmp    %eax,%esi
80104d62:	75 df                	jne    80104d43 <release+0x13>
  popcli();
80104d64:	e8 27 ff ff ff       	call   80104c90 <popcli>
  lk->pcs[0] = 0;
80104d69:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104d70:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104d77:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104d7c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104d82:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104d85:	5b                   	pop    %ebx
80104d86:	5e                   	pop    %esi
80104d87:	5d                   	pop    %ebp
  popcli();
80104d88:	e9 03 ff ff ff       	jmp    80104c90 <popcli>
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi

80104d90 <acquire>:
{
80104d90:	55                   	push   %ebp
80104d91:	89 e5                	mov    %esp,%ebp
80104d93:	53                   	push   %ebx
80104d94:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104d97:	e8 a4 fe ff ff       	call   80104c40 <pushcli>
  if(holding(lk))
80104d9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80104d9f:	e8 9c fe ff ff       	call   80104c40 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104da4:	8b 03                	mov    (%ebx),%eax
80104da6:	85 c0                	test   %eax,%eax
80104da8:	75 7e                	jne    80104e28 <acquire+0x98>
  popcli();
80104daa:	e8 e1 fe ff ff       	call   80104c90 <popcli>
  asm volatile("lock; xchgl %0, %1" :
80104daf:	b9 01 00 00 00       	mov    $0x1,%ecx
80104db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104db8:	8b 55 08             	mov    0x8(%ebp),%edx
80104dbb:	89 c8                	mov    %ecx,%eax
80104dbd:	f0 87 02             	lock xchg %eax,(%edx)
80104dc0:	85 c0                	test   %eax,%eax
80104dc2:	75 f4                	jne    80104db8 <acquire+0x28>
  __sync_synchronize();
80104dc4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104dc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104dcc:	e8 2f ed ff ff       	call   80103b00 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104dd1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104dd4:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104dd6:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104dd9:	31 c0                	xor    %eax,%eax
80104ddb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ddf:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104de0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104de6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80104dec:	77 1a                	ja     80104e08 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
80104dee:	8b 5a 04             	mov    0x4(%edx),%ebx
80104df1:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104df5:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104df8:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104dfa:	83 f8 0a             	cmp    $0xa,%eax
80104dfd:	75 e1                	jne    80104de0 <acquire+0x50>
}
80104dff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e02:	c9                   	leave  
80104e03:	c3                   	ret    
80104e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104e08:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
80104e0c:	8d 51 34             	lea    0x34(%ecx),%edx
80104e0f:	90                   	nop
    pcs[i] = 0;
80104e10:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104e16:	83 c0 04             	add    $0x4,%eax
80104e19:	39 c2                	cmp    %eax,%edx
80104e1b:	75 f3                	jne    80104e10 <acquire+0x80>
}
80104e1d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e20:	c9                   	leave  
80104e21:	c3                   	ret    
80104e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104e28:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104e2b:	e8 d0 ec ff ff       	call   80103b00 <mycpu>
80104e30:	39 c3                	cmp    %eax,%ebx
80104e32:	0f 85 72 ff ff ff    	jne    80104daa <acquire+0x1a>
  popcli();
80104e38:	e8 53 fe ff ff       	call   80104c90 <popcli>
    panic("acquire");
80104e3d:	83 ec 0c             	sub    $0xc,%esp
80104e40:	68 b1 82 10 80       	push   $0x801082b1
80104e45:	e8 36 b5 ff ff       	call   80100380 <panic>
80104e4a:	66 90                	xchg   %ax,%ax
80104e4c:	66 90                	xchg   %ax,%ax
80104e4e:	66 90                	xchg   %ax,%ax

80104e50 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104e50:	55                   	push   %ebp
80104e51:	89 e5                	mov    %esp,%ebp
80104e53:	57                   	push   %edi
80104e54:	8b 55 08             	mov    0x8(%ebp),%edx
80104e57:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104e5a:	53                   	push   %ebx
80104e5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80104e5e:	89 d7                	mov    %edx,%edi
80104e60:	09 cf                	or     %ecx,%edi
80104e62:	83 e7 03             	and    $0x3,%edi
80104e65:	75 29                	jne    80104e90 <memset+0x40>
    c &= 0xFF;
80104e67:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104e6a:	c1 e0 18             	shl    $0x18,%eax
80104e6d:	89 fb                	mov    %edi,%ebx
80104e6f:	c1 e9 02             	shr    $0x2,%ecx
80104e72:	c1 e3 10             	shl    $0x10,%ebx
80104e75:	09 d8                	or     %ebx,%eax
80104e77:	09 f8                	or     %edi,%eax
80104e79:	c1 e7 08             	shl    $0x8,%edi
80104e7c:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104e7e:	89 d7                	mov    %edx,%edi
80104e80:	fc                   	cld    
80104e81:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104e83:	5b                   	pop    %ebx
80104e84:	89 d0                	mov    %edx,%eax
80104e86:	5f                   	pop    %edi
80104e87:	5d                   	pop    %ebp
80104e88:	c3                   	ret    
80104e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104e90:	89 d7                	mov    %edx,%edi
80104e92:	fc                   	cld    
80104e93:	f3 aa                	rep stos %al,%es:(%edi)
80104e95:	5b                   	pop    %ebx
80104e96:	89 d0                	mov    %edx,%eax
80104e98:	5f                   	pop    %edi
80104e99:	5d                   	pop    %ebp
80104e9a:	c3                   	ret    
80104e9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104e9f:	90                   	nop

80104ea0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ea0:	55                   	push   %ebp
80104ea1:	89 e5                	mov    %esp,%ebp
80104ea3:	56                   	push   %esi
80104ea4:	8b 75 10             	mov    0x10(%ebp),%esi
80104ea7:	8b 55 08             	mov    0x8(%ebp),%edx
80104eaa:	53                   	push   %ebx
80104eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104eae:	85 f6                	test   %esi,%esi
80104eb0:	74 2e                	je     80104ee0 <memcmp+0x40>
80104eb2:	01 c6                	add    %eax,%esi
80104eb4:	eb 14                	jmp    80104eca <memcmp+0x2a>
80104eb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ebd:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104ec0:	83 c0 01             	add    $0x1,%eax
80104ec3:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104ec6:	39 f0                	cmp    %esi,%eax
80104ec8:	74 16                	je     80104ee0 <memcmp+0x40>
    if(*s1 != *s2)
80104eca:	0f b6 0a             	movzbl (%edx),%ecx
80104ecd:	0f b6 18             	movzbl (%eax),%ebx
80104ed0:	38 d9                	cmp    %bl,%cl
80104ed2:	74 ec                	je     80104ec0 <memcmp+0x20>
      return *s1 - *s2;
80104ed4:	0f b6 c1             	movzbl %cl,%eax
80104ed7:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104ed9:	5b                   	pop    %ebx
80104eda:	5e                   	pop    %esi
80104edb:	5d                   	pop    %ebp
80104edc:	c3                   	ret    
80104edd:	8d 76 00             	lea    0x0(%esi),%esi
80104ee0:	5b                   	pop    %ebx
  return 0;
80104ee1:	31 c0                	xor    %eax,%eax
}
80104ee3:	5e                   	pop    %esi
80104ee4:	5d                   	pop    %ebp
80104ee5:	c3                   	ret    
80104ee6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eed:	8d 76 00             	lea    0x0(%esi),%esi

80104ef0 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	57                   	push   %edi
80104ef4:	8b 55 08             	mov    0x8(%ebp),%edx
80104ef7:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104efa:	56                   	push   %esi
80104efb:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104efe:	39 d6                	cmp    %edx,%esi
80104f00:	73 26                	jae    80104f28 <memmove+0x38>
80104f02:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104f05:	39 fa                	cmp    %edi,%edx
80104f07:	73 1f                	jae    80104f28 <memmove+0x38>
80104f09:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104f0c:	85 c9                	test   %ecx,%ecx
80104f0e:	74 0c                	je     80104f1c <memmove+0x2c>
      *--d = *--s;
80104f10:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104f14:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104f17:	83 e8 01             	sub    $0x1,%eax
80104f1a:	73 f4                	jae    80104f10 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104f1c:	5e                   	pop    %esi
80104f1d:	89 d0                	mov    %edx,%eax
80104f1f:	5f                   	pop    %edi
80104f20:	5d                   	pop    %ebp
80104f21:	c3                   	ret    
80104f22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104f28:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104f2b:	89 d7                	mov    %edx,%edi
80104f2d:	85 c9                	test   %ecx,%ecx
80104f2f:	74 eb                	je     80104f1c <memmove+0x2c>
80104f31:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104f38:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104f39:	39 f0                	cmp    %esi,%eax
80104f3b:	75 fb                	jne    80104f38 <memmove+0x48>
}
80104f3d:	5e                   	pop    %esi
80104f3e:	89 d0                	mov    %edx,%eax
80104f40:	5f                   	pop    %edi
80104f41:	5d                   	pop    %ebp
80104f42:	c3                   	ret    
80104f43:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104f50 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104f50:	eb 9e                	jmp    80104ef0 <memmove>
80104f52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104f60 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104f60:	55                   	push   %ebp
80104f61:	89 e5                	mov    %esp,%ebp
80104f63:	56                   	push   %esi
80104f64:	8b 75 10             	mov    0x10(%ebp),%esi
80104f67:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104f6a:	53                   	push   %ebx
80104f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80104f6e:	85 f6                	test   %esi,%esi
80104f70:	74 36                	je     80104fa8 <strncmp+0x48>
80104f72:	01 c6                	add    %eax,%esi
80104f74:	eb 18                	jmp    80104f8e <strncmp+0x2e>
80104f76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f7d:	8d 76 00             	lea    0x0(%esi),%esi
80104f80:	38 da                	cmp    %bl,%dl
80104f82:	75 14                	jne    80104f98 <strncmp+0x38>
    n--, p++, q++;
80104f84:	83 c0 01             	add    $0x1,%eax
80104f87:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104f8a:	39 f0                	cmp    %esi,%eax
80104f8c:	74 1a                	je     80104fa8 <strncmp+0x48>
80104f8e:	0f b6 11             	movzbl (%ecx),%edx
80104f91:	0f b6 18             	movzbl (%eax),%ebx
80104f94:	84 d2                	test   %dl,%dl
80104f96:	75 e8                	jne    80104f80 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104f98:	0f b6 c2             	movzbl %dl,%eax
80104f9b:	29 d8                	sub    %ebx,%eax
}
80104f9d:	5b                   	pop    %ebx
80104f9e:	5e                   	pop    %esi
80104f9f:	5d                   	pop    %ebp
80104fa0:	c3                   	ret    
80104fa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fa8:	5b                   	pop    %ebx
    return 0;
80104fa9:	31 c0                	xor    %eax,%eax
}
80104fab:	5e                   	pop    %esi
80104fac:	5d                   	pop    %ebp
80104fad:	c3                   	ret    
80104fae:	66 90                	xchg   %ax,%ax

80104fb0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	57                   	push   %edi
80104fb4:	56                   	push   %esi
80104fb5:	8b 75 08             	mov    0x8(%ebp),%esi
80104fb8:	53                   	push   %ebx
80104fb9:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104fbc:	89 f2                	mov    %esi,%edx
80104fbe:	eb 17                	jmp    80104fd7 <strncpy+0x27>
80104fc0:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104fc4:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104fc7:	83 c2 01             	add    $0x1,%edx
80104fca:	0f b6 7f ff          	movzbl -0x1(%edi),%edi
80104fce:	89 f9                	mov    %edi,%ecx
80104fd0:	88 4a ff             	mov    %cl,-0x1(%edx)
80104fd3:	84 c9                	test   %cl,%cl
80104fd5:	74 09                	je     80104fe0 <strncpy+0x30>
80104fd7:	89 c3                	mov    %eax,%ebx
80104fd9:	83 e8 01             	sub    $0x1,%eax
80104fdc:	85 db                	test   %ebx,%ebx
80104fde:	7f e0                	jg     80104fc0 <strncpy+0x10>
    ;
  while(n-- > 0)
80104fe0:	89 d1                	mov    %edx,%ecx
80104fe2:	85 c0                	test   %eax,%eax
80104fe4:	7e 1d                	jle    80105003 <strncpy+0x53>
80104fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104fed:	8d 76 00             	lea    0x0(%esi),%esi
    *s++ = 0;
80104ff0:	83 c1 01             	add    $0x1,%ecx
80104ff3:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  while(n-- > 0)
80104ff7:	89 c8                	mov    %ecx,%eax
80104ff9:	f7 d0                	not    %eax
80104ffb:	01 d0                	add    %edx,%eax
80104ffd:	01 d8                	add    %ebx,%eax
80104fff:	85 c0                	test   %eax,%eax
80105001:	7f ed                	jg     80104ff0 <strncpy+0x40>
  return os;
}
80105003:	5b                   	pop    %ebx
80105004:	89 f0                	mov    %esi,%eax
80105006:	5e                   	pop    %esi
80105007:	5f                   	pop    %edi
80105008:	5d                   	pop    %ebp
80105009:	c3                   	ret    
8010500a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105010 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105010:	55                   	push   %ebp
80105011:	89 e5                	mov    %esp,%ebp
80105013:	56                   	push   %esi
80105014:	8b 55 10             	mov    0x10(%ebp),%edx
80105017:	8b 75 08             	mov    0x8(%ebp),%esi
8010501a:	53                   	push   %ebx
8010501b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
8010501e:	85 d2                	test   %edx,%edx
80105020:	7e 25                	jle    80105047 <safestrcpy+0x37>
80105022:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80105026:	89 f2                	mov    %esi,%edx
80105028:	eb 16                	jmp    80105040 <safestrcpy+0x30>
8010502a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80105030:	0f b6 08             	movzbl (%eax),%ecx
80105033:	83 c0 01             	add    $0x1,%eax
80105036:	83 c2 01             	add    $0x1,%edx
80105039:	88 4a ff             	mov    %cl,-0x1(%edx)
8010503c:	84 c9                	test   %cl,%cl
8010503e:	74 04                	je     80105044 <safestrcpy+0x34>
80105040:	39 d8                	cmp    %ebx,%eax
80105042:	75 ec                	jne    80105030 <safestrcpy+0x20>
    ;
  *s = 0;
80105044:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80105047:	89 f0                	mov    %esi,%eax
80105049:	5b                   	pop    %ebx
8010504a:	5e                   	pop    %esi
8010504b:	5d                   	pop    %ebp
8010504c:	c3                   	ret    
8010504d:	8d 76 00             	lea    0x0(%esi),%esi

80105050 <strlen>:

int
strlen(const char *s)
{
80105050:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80105051:	31 c0                	xor    %eax,%eax
{
80105053:	89 e5                	mov    %esp,%ebp
80105055:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80105058:	80 3a 00             	cmpb   $0x0,(%edx)
8010505b:	74 0c                	je     80105069 <strlen+0x19>
8010505d:	8d 76 00             	lea    0x0(%esi),%esi
80105060:	83 c0 01             	add    $0x1,%eax
80105063:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80105067:	75 f7                	jne    80105060 <strlen+0x10>
    ;
  return n;
}
80105069:	5d                   	pop    %ebp
8010506a:	c3                   	ret    

8010506b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010506b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010506f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80105073:	55                   	push   %ebp
  pushl %ebx
80105074:	53                   	push   %ebx
  pushl %esi
80105075:	56                   	push   %esi
  pushl %edi
80105076:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80105077:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80105079:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010507b:	5f                   	pop    %edi
  popl %esi
8010507c:	5e                   	pop    %esi
  popl %ebx
8010507d:	5b                   	pop    %ebx
  popl %ebp
8010507e:	5d                   	pop    %ebp
  ret
8010507f:	c3                   	ret    

80105080 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	53                   	push   %ebx
80105084:	83 ec 04             	sub    $0x4,%esp
80105087:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010508a:	e8 01 eb ff ff       	call   80103b90 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010508f:	8b 00                	mov    (%eax),%eax
80105091:	39 d8                	cmp    %ebx,%eax
80105093:	76 1b                	jbe    801050b0 <fetchint+0x30>
80105095:	8d 53 04             	lea    0x4(%ebx),%edx
80105098:	39 d0                	cmp    %edx,%eax
8010509a:	72 14                	jb     801050b0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010509c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010509f:	8b 13                	mov    (%ebx),%edx
801050a1:	89 10                	mov    %edx,(%eax)
  return 0;
801050a3:	31 c0                	xor    %eax,%eax
}
801050a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050a8:	c9                   	leave  
801050a9:	c3                   	ret    
801050aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801050b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050b5:	eb ee                	jmp    801050a5 <fetchint+0x25>
801050b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050be:	66 90                	xchg   %ax,%ax

801050c0 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801050c0:	55                   	push   %ebp
801050c1:	89 e5                	mov    %esp,%ebp
801050c3:	53                   	push   %ebx
801050c4:	83 ec 04             	sub    $0x4,%esp
801050c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
801050ca:	e8 c1 ea ff ff       	call   80103b90 <myproc>

  if(addr >= curproc->sz)
801050cf:	39 18                	cmp    %ebx,(%eax)
801050d1:	76 2d                	jbe    80105100 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
801050d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801050d6:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
801050d8:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
801050da:	39 d3                	cmp    %edx,%ebx
801050dc:	73 22                	jae    80105100 <fetchstr+0x40>
801050de:	89 d8                	mov    %ebx,%eax
801050e0:	eb 0d                	jmp    801050ef <fetchstr+0x2f>
801050e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801050e8:	83 c0 01             	add    $0x1,%eax
801050eb:	39 c2                	cmp    %eax,%edx
801050ed:	76 11                	jbe    80105100 <fetchstr+0x40>
    if(*s == 0)
801050ef:	80 38 00             	cmpb   $0x0,(%eax)
801050f2:	75 f4                	jne    801050e8 <fetchstr+0x28>
      return s - *pp;
801050f4:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801050f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801050f9:	c9                   	leave  
801050fa:	c3                   	ret    
801050fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801050ff:	90                   	nop
80105100:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80105103:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105108:	c9                   	leave  
80105109:	c3                   	ret    
8010510a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105110 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105110:	55                   	push   %ebp
80105111:	89 e5                	mov    %esp,%ebp
80105113:	56                   	push   %esi
80105114:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105115:	e8 76 ea ff ff       	call   80103b90 <myproc>
8010511a:	8b 55 08             	mov    0x8(%ebp),%edx
8010511d:	8b 40 18             	mov    0x18(%eax),%eax
80105120:	8b 40 44             	mov    0x44(%eax),%eax
80105123:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105126:	e8 65 ea ff ff       	call   80103b90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010512b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010512e:	8b 00                	mov    (%eax),%eax
80105130:	39 c6                	cmp    %eax,%esi
80105132:	73 1c                	jae    80105150 <argint+0x40>
80105134:	8d 53 08             	lea    0x8(%ebx),%edx
80105137:	39 d0                	cmp    %edx,%eax
80105139:	72 15                	jb     80105150 <argint+0x40>
  *ip = *(int*)(addr);
8010513b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010513e:	8b 53 04             	mov    0x4(%ebx),%edx
80105141:	89 10                	mov    %edx,(%eax)
  return 0;
80105143:	31 c0                	xor    %eax,%eax
}
80105145:	5b                   	pop    %ebx
80105146:	5e                   	pop    %esi
80105147:	5d                   	pop    %ebp
80105148:	c3                   	ret    
80105149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105150:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105155:	eb ee                	jmp    80105145 <argint+0x35>
80105157:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010515e:	66 90                	xchg   %ax,%ax

80105160 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	57                   	push   %edi
80105164:	56                   	push   %esi
80105165:	53                   	push   %ebx
80105166:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80105169:	e8 22 ea ff ff       	call   80103b90 <myproc>
8010516e:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105170:	e8 1b ea ff ff       	call   80103b90 <myproc>
80105175:	8b 55 08             	mov    0x8(%ebp),%edx
80105178:	8b 40 18             	mov    0x18(%eax),%eax
8010517b:	8b 40 44             	mov    0x44(%eax),%eax
8010517e:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80105181:	e8 0a ea ff ff       	call   80103b90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80105186:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80105189:	8b 00                	mov    (%eax),%eax
8010518b:	39 c7                	cmp    %eax,%edi
8010518d:	73 31                	jae    801051c0 <argptr+0x60>
8010518f:	8d 4b 08             	lea    0x8(%ebx),%ecx
80105192:	39 c8                	cmp    %ecx,%eax
80105194:	72 2a                	jb     801051c0 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80105196:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80105199:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
8010519c:	85 d2                	test   %edx,%edx
8010519e:	78 20                	js     801051c0 <argptr+0x60>
801051a0:	8b 16                	mov    (%esi),%edx
801051a2:	39 c2                	cmp    %eax,%edx
801051a4:	76 1a                	jbe    801051c0 <argptr+0x60>
801051a6:	8b 5d 10             	mov    0x10(%ebp),%ebx
801051a9:	01 c3                	add    %eax,%ebx
801051ab:	39 da                	cmp    %ebx,%edx
801051ad:	72 11                	jb     801051c0 <argptr+0x60>
    return -1;
  *pp = (char*)i;
801051af:	8b 55 0c             	mov    0xc(%ebp),%edx
801051b2:	89 02                	mov    %eax,(%edx)
  return 0;
801051b4:	31 c0                	xor    %eax,%eax
}
801051b6:	83 c4 0c             	add    $0xc,%esp
801051b9:	5b                   	pop    %ebx
801051ba:	5e                   	pop    %esi
801051bb:	5f                   	pop    %edi
801051bc:	5d                   	pop    %ebp
801051bd:	c3                   	ret    
801051be:	66 90                	xchg   %ax,%ax
    return -1;
801051c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051c5:	eb ef                	jmp    801051b6 <argptr+0x56>
801051c7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051ce:	66 90                	xchg   %ax,%ax

801051d0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801051d0:	55                   	push   %ebp
801051d1:	89 e5                	mov    %esp,%ebp
801051d3:	56                   	push   %esi
801051d4:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051d5:	e8 b6 e9 ff ff       	call   80103b90 <myproc>
801051da:	8b 55 08             	mov    0x8(%ebp),%edx
801051dd:	8b 40 18             	mov    0x18(%eax),%eax
801051e0:	8b 40 44             	mov    0x44(%eax),%eax
801051e3:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
801051e6:	e8 a5 e9 ff ff       	call   80103b90 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801051eb:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
801051ee:	8b 00                	mov    (%eax),%eax
801051f0:	39 c6                	cmp    %eax,%esi
801051f2:	73 44                	jae    80105238 <argstr+0x68>
801051f4:	8d 53 08             	lea    0x8(%ebx),%edx
801051f7:	39 d0                	cmp    %edx,%eax
801051f9:	72 3d                	jb     80105238 <argstr+0x68>
  *ip = *(int*)(addr);
801051fb:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
801051fe:	e8 8d e9 ff ff       	call   80103b90 <myproc>
  if(addr >= curproc->sz)
80105203:	3b 18                	cmp    (%eax),%ebx
80105205:	73 31                	jae    80105238 <argstr+0x68>
  *pp = (char*)addr;
80105207:	8b 55 0c             	mov    0xc(%ebp),%edx
8010520a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
8010520c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
8010520e:	39 d3                	cmp    %edx,%ebx
80105210:	73 26                	jae    80105238 <argstr+0x68>
80105212:	89 d8                	mov    %ebx,%eax
80105214:	eb 11                	jmp    80105227 <argstr+0x57>
80105216:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010521d:	8d 76 00             	lea    0x0(%esi),%esi
80105220:	83 c0 01             	add    $0x1,%eax
80105223:	39 c2                	cmp    %eax,%edx
80105225:	76 11                	jbe    80105238 <argstr+0x68>
    if(*s == 0)
80105227:	80 38 00             	cmpb   $0x0,(%eax)
8010522a:	75 f4                	jne    80105220 <argstr+0x50>
      return s - *pp;
8010522c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
8010522e:	5b                   	pop    %ebx
8010522f:	5e                   	pop    %esi
80105230:	5d                   	pop    %ebp
80105231:	c3                   	ret    
80105232:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105238:	5b                   	pop    %ebx
    return -1;
80105239:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010523e:	5e                   	pop    %esi
8010523f:	5d                   	pop    %ebp
80105240:	c3                   	ret    
80105241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105248:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010524f:	90                   	nop

80105250 <syscall>:
[SYS_showInfo] sys_showInfo,
};

void
syscall(void)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	53                   	push   %ebx
80105254:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80105257:	e8 34 e9 ff ff       	call   80103b90 <myproc>
8010525c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010525e:	8b 40 18             	mov    0x18(%eax),%eax
80105261:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105264:	8d 50 ff             	lea    -0x1(%eax),%edx
80105267:	83 fa 19             	cmp    $0x19,%edx
8010526a:	77 24                	ja     80105290 <syscall+0x40>
8010526c:	8b 14 85 e0 82 10 80 	mov    -0x7fef7d20(,%eax,4),%edx
80105273:	85 d2                	test   %edx,%edx
80105275:	74 19                	je     80105290 <syscall+0x40>
    curproc->tf->eax = syscalls[num]();
80105277:	ff d2                	call   *%edx
80105279:	89 c2                	mov    %eax,%edx
8010527b:	8b 43 18             	mov    0x18(%ebx),%eax
8010527e:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80105281:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105284:	c9                   	leave  
80105285:	c3                   	ret    
80105286:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010528d:	8d 76 00             	lea    0x0(%esi),%esi
    cprintf("%d %s: unknown sys call %d\n",
80105290:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80105291:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80105294:	50                   	push   %eax
80105295:	ff 73 10             	pushl  0x10(%ebx)
80105298:	68 b9 82 10 80       	push   $0x801082b9
8010529d:	e8 de b3 ff ff       	call   80100680 <cprintf>
    curproc->tf->eax = -1;
801052a2:	8b 43 18             	mov    0x18(%ebx),%eax
801052a5:	83 c4 10             	add    $0x10,%esp
801052a8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
801052af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801052b2:	c9                   	leave  
801052b3:	c3                   	ret    
801052b4:	66 90                	xchg   %ax,%ax
801052b6:	66 90                	xchg   %ax,%ax
801052b8:	66 90                	xchg   %ax,%ax
801052ba:	66 90                	xchg   %ax,%ax
801052bc:	66 90                	xchg   %ax,%ax
801052be:	66 90                	xchg   %ax,%ax

801052c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801052c0:	55                   	push   %ebp
801052c1:	89 e5                	mov    %esp,%ebp
801052c3:	57                   	push   %edi
801052c4:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801052c5:	8d 7d da             	lea    -0x26(%ebp),%edi
{
801052c8:	53                   	push   %ebx
801052c9:	83 ec 34             	sub    $0x34,%esp
801052cc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801052cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
801052d2:	57                   	push   %edi
801052d3:	50                   	push   %eax
{
801052d4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801052d7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801052da:	e8 f1 ce ff ff       	call   801021d0 <nameiparent>
801052df:	83 c4 10             	add    $0x10,%esp
801052e2:	85 c0                	test   %eax,%eax
801052e4:	0f 84 46 01 00 00    	je     80105430 <create+0x170>
    return 0;
  ilock(dp);
801052ea:	83 ec 0c             	sub    $0xc,%esp
801052ed:	89 c3                	mov    %eax,%ebx
801052ef:	50                   	push   %eax
801052f0:	e8 9b c5 ff ff       	call   80101890 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
801052f5:	83 c4 0c             	add    $0xc,%esp
801052f8:	6a 00                	push   $0x0
801052fa:	57                   	push   %edi
801052fb:	53                   	push   %ebx
801052fc:	e8 ef ca ff ff       	call   80101df0 <dirlookup>
80105301:	83 c4 10             	add    $0x10,%esp
80105304:	89 c6                	mov    %eax,%esi
80105306:	85 c0                	test   %eax,%eax
80105308:	74 56                	je     80105360 <create+0xa0>
    iunlockput(dp);
8010530a:	83 ec 0c             	sub    $0xc,%esp
8010530d:	53                   	push   %ebx
8010530e:	e8 0d c8 ff ff       	call   80101b20 <iunlockput>
    ilock(ip);
80105313:	89 34 24             	mov    %esi,(%esp)
80105316:	e8 75 c5 ff ff       	call   80101890 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010531b:	83 c4 10             	add    $0x10,%esp
8010531e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105323:	75 1b                	jne    80105340 <create+0x80>
80105325:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010532a:	75 14                	jne    80105340 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010532c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010532f:	89 f0                	mov    %esi,%eax
80105331:	5b                   	pop    %ebx
80105332:	5e                   	pop    %esi
80105333:	5f                   	pop    %edi
80105334:	5d                   	pop    %ebp
80105335:	c3                   	ret    
80105336:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010533d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105340:	83 ec 0c             	sub    $0xc,%esp
80105343:	56                   	push   %esi
    return 0;
80105344:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80105346:	e8 d5 c7 ff ff       	call   80101b20 <iunlockput>
    return 0;
8010534b:	83 c4 10             	add    $0x10,%esp
}
8010534e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105351:	89 f0                	mov    %esi,%eax
80105353:	5b                   	pop    %ebx
80105354:	5e                   	pop    %esi
80105355:	5f                   	pop    %edi
80105356:	5d                   	pop    %ebp
80105357:	c3                   	ret    
80105358:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010535f:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80105360:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80105364:	83 ec 08             	sub    $0x8,%esp
80105367:	50                   	push   %eax
80105368:	ff 33                	pushl  (%ebx)
8010536a:	e8 b1 c3 ff ff       	call   80101720 <ialloc>
8010536f:	83 c4 10             	add    $0x10,%esp
80105372:	89 c6                	mov    %eax,%esi
80105374:	85 c0                	test   %eax,%eax
80105376:	0f 84 cd 00 00 00    	je     80105449 <create+0x189>
  ilock(ip);
8010537c:	83 ec 0c             	sub    $0xc,%esp
8010537f:	50                   	push   %eax
80105380:	e8 0b c5 ff ff       	call   80101890 <ilock>
  ip->major = major;
80105385:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80105389:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010538d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80105391:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80105395:	b8 01 00 00 00       	mov    $0x1,%eax
8010539a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010539e:	89 34 24             	mov    %esi,(%esp)
801053a1:	e8 3a c4 ff ff       	call   801017e0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801053a6:	83 c4 10             	add    $0x10,%esp
801053a9:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801053ae:	74 30                	je     801053e0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
801053b0:	83 ec 04             	sub    $0x4,%esp
801053b3:	ff 76 04             	pushl  0x4(%esi)
801053b6:	57                   	push   %edi
801053b7:	53                   	push   %ebx
801053b8:	e8 33 cd ff ff       	call   801020f0 <dirlink>
801053bd:	83 c4 10             	add    $0x10,%esp
801053c0:	85 c0                	test   %eax,%eax
801053c2:	78 78                	js     8010543c <create+0x17c>
  iunlockput(dp);
801053c4:	83 ec 0c             	sub    $0xc,%esp
801053c7:	53                   	push   %ebx
801053c8:	e8 53 c7 ff ff       	call   80101b20 <iunlockput>
  return ip;
801053cd:	83 c4 10             	add    $0x10,%esp
}
801053d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053d3:	89 f0                	mov    %esi,%eax
801053d5:	5b                   	pop    %ebx
801053d6:	5e                   	pop    %esi
801053d7:	5f                   	pop    %edi
801053d8:	5d                   	pop    %ebp
801053d9:	c3                   	ret    
801053da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
801053e0:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
801053e3:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
801053e8:	53                   	push   %ebx
801053e9:	e8 f2 c3 ff ff       	call   801017e0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801053ee:	83 c4 0c             	add    $0xc,%esp
801053f1:	ff 76 04             	pushl  0x4(%esi)
801053f4:	68 68 83 10 80       	push   $0x80108368
801053f9:	56                   	push   %esi
801053fa:	e8 f1 cc ff ff       	call   801020f0 <dirlink>
801053ff:	83 c4 10             	add    $0x10,%esp
80105402:	85 c0                	test   %eax,%eax
80105404:	78 18                	js     8010541e <create+0x15e>
80105406:	83 ec 04             	sub    $0x4,%esp
80105409:	ff 73 04             	pushl  0x4(%ebx)
8010540c:	68 67 83 10 80       	push   $0x80108367
80105411:	56                   	push   %esi
80105412:	e8 d9 cc ff ff       	call   801020f0 <dirlink>
80105417:	83 c4 10             	add    $0x10,%esp
8010541a:	85 c0                	test   %eax,%eax
8010541c:	79 92                	jns    801053b0 <create+0xf0>
      panic("create dots");
8010541e:	83 ec 0c             	sub    $0xc,%esp
80105421:	68 5b 83 10 80       	push   $0x8010835b
80105426:	e8 55 af ff ff       	call   80100380 <panic>
8010542b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010542f:	90                   	nop
}
80105430:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80105433:	31 f6                	xor    %esi,%esi
}
80105435:	5b                   	pop    %ebx
80105436:	89 f0                	mov    %esi,%eax
80105438:	5e                   	pop    %esi
80105439:	5f                   	pop    %edi
8010543a:	5d                   	pop    %ebp
8010543b:	c3                   	ret    
    panic("create: dirlink");
8010543c:	83 ec 0c             	sub    $0xc,%esp
8010543f:	68 6a 83 10 80       	push   $0x8010836a
80105444:	e8 37 af ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80105449:	83 ec 0c             	sub    $0xc,%esp
8010544c:	68 4c 83 10 80       	push   $0x8010834c
80105451:	e8 2a af ff ff       	call   80100380 <panic>
80105456:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010545d:	8d 76 00             	lea    0x0(%esi),%esi

80105460 <sys_dup>:
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	56                   	push   %esi
80105464:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105465:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105468:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010546b:	50                   	push   %eax
8010546c:	6a 00                	push   $0x0
8010546e:	e8 9d fc ff ff       	call   80105110 <argint>
80105473:	83 c4 10             	add    $0x10,%esp
80105476:	85 c0                	test   %eax,%eax
80105478:	78 36                	js     801054b0 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010547a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010547e:	77 30                	ja     801054b0 <sys_dup+0x50>
80105480:	e8 0b e7 ff ff       	call   80103b90 <myproc>
80105485:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105488:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010548c:	85 f6                	test   %esi,%esi
8010548e:	74 20                	je     801054b0 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105490:	e8 fb e6 ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105495:	31 db                	xor    %ebx,%ebx
80105497:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010549e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
801054a0:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
801054a4:	85 d2                	test   %edx,%edx
801054a6:	74 18                	je     801054c0 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
801054a8:	83 c3 01             	add    $0x1,%ebx
801054ab:	83 fb 10             	cmp    $0x10,%ebx
801054ae:	75 f0                	jne    801054a0 <sys_dup+0x40>
}
801054b0:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
801054b3:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
801054b8:	89 d8                	mov    %ebx,%eax
801054ba:	5b                   	pop    %ebx
801054bb:	5e                   	pop    %esi
801054bc:	5d                   	pop    %ebp
801054bd:	c3                   	ret    
801054be:	66 90                	xchg   %ax,%ax
  filedup(f);
801054c0:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801054c3:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
801054c7:	56                   	push   %esi
801054c8:	e8 f3 ba ff ff       	call   80100fc0 <filedup>
  return fd;
801054cd:	83 c4 10             	add    $0x10,%esp
}
801054d0:	8d 65 f8             	lea    -0x8(%ebp),%esp
801054d3:	89 d8                	mov    %ebx,%eax
801054d5:	5b                   	pop    %ebx
801054d6:	5e                   	pop    %esi
801054d7:	5d                   	pop    %ebp
801054d8:	c3                   	ret    
801054d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801054e0 <sys_read>:
{
801054e0:	55                   	push   %ebp
801054e1:	89 e5                	mov    %esp,%ebp
801054e3:	56                   	push   %esi
801054e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801054e5:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
801054e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801054eb:	53                   	push   %ebx
801054ec:	6a 00                	push   $0x0
801054ee:	e8 1d fc ff ff       	call   80105110 <argint>
801054f3:	83 c4 10             	add    $0x10,%esp
801054f6:	85 c0                	test   %eax,%eax
801054f8:	78 5e                	js     80105558 <sys_read+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801054fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801054fe:	77 58                	ja     80105558 <sys_read+0x78>
80105500:	e8 8b e6 ff ff       	call   80103b90 <myproc>
80105505:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105508:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010550c:	85 f6                	test   %esi,%esi
8010550e:	74 48                	je     80105558 <sys_read+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105510:	83 ec 08             	sub    $0x8,%esp
80105513:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105516:	50                   	push   %eax
80105517:	6a 02                	push   $0x2
80105519:	e8 f2 fb ff ff       	call   80105110 <argint>
8010551e:	83 c4 10             	add    $0x10,%esp
80105521:	85 c0                	test   %eax,%eax
80105523:	78 33                	js     80105558 <sys_read+0x78>
80105525:	83 ec 04             	sub    $0x4,%esp
80105528:	ff 75 f0             	pushl  -0x10(%ebp)
8010552b:	53                   	push   %ebx
8010552c:	6a 01                	push   $0x1
8010552e:	e8 2d fc ff ff       	call   80105160 <argptr>
80105533:	83 c4 10             	add    $0x10,%esp
80105536:	85 c0                	test   %eax,%eax
80105538:	78 1e                	js     80105558 <sys_read+0x78>
  return fileread(f, p, n);
8010553a:	83 ec 04             	sub    $0x4,%esp
8010553d:	ff 75 f0             	pushl  -0x10(%ebp)
80105540:	ff 75 f4             	pushl  -0xc(%ebp)
80105543:	56                   	push   %esi
80105544:	e8 f7 bb ff ff       	call   80101140 <fileread>
80105549:	83 c4 10             	add    $0x10,%esp
}
8010554c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010554f:	5b                   	pop    %ebx
80105550:	5e                   	pop    %esi
80105551:	5d                   	pop    %ebp
80105552:	c3                   	ret    
80105553:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105557:	90                   	nop
    return -1;
80105558:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010555d:	eb ed                	jmp    8010554c <sys_read+0x6c>
8010555f:	90                   	nop

80105560 <sys_write>:
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	56                   	push   %esi
80105564:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105565:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105568:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010556b:	53                   	push   %ebx
8010556c:	6a 00                	push   $0x0
8010556e:	e8 9d fb ff ff       	call   80105110 <argint>
80105573:	83 c4 10             	add    $0x10,%esp
80105576:	85 c0                	test   %eax,%eax
80105578:	78 5e                	js     801055d8 <sys_write+0x78>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010557a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010557e:	77 58                	ja     801055d8 <sys_write+0x78>
80105580:	e8 0b e6 ff ff       	call   80103b90 <myproc>
80105585:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105588:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010558c:	85 f6                	test   %esi,%esi
8010558e:	74 48                	je     801055d8 <sys_write+0x78>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105590:	83 ec 08             	sub    $0x8,%esp
80105593:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105596:	50                   	push   %eax
80105597:	6a 02                	push   $0x2
80105599:	e8 72 fb ff ff       	call   80105110 <argint>
8010559e:	83 c4 10             	add    $0x10,%esp
801055a1:	85 c0                	test   %eax,%eax
801055a3:	78 33                	js     801055d8 <sys_write+0x78>
801055a5:	83 ec 04             	sub    $0x4,%esp
801055a8:	ff 75 f0             	pushl  -0x10(%ebp)
801055ab:	53                   	push   %ebx
801055ac:	6a 01                	push   $0x1
801055ae:	e8 ad fb ff ff       	call   80105160 <argptr>
801055b3:	83 c4 10             	add    $0x10,%esp
801055b6:	85 c0                	test   %eax,%eax
801055b8:	78 1e                	js     801055d8 <sys_write+0x78>
  return filewrite(f, p, n);
801055ba:	83 ec 04             	sub    $0x4,%esp
801055bd:	ff 75 f0             	pushl  -0x10(%ebp)
801055c0:	ff 75 f4             	pushl  -0xc(%ebp)
801055c3:	56                   	push   %esi
801055c4:	e8 07 bc ff ff       	call   801011d0 <filewrite>
801055c9:	83 c4 10             	add    $0x10,%esp
}
801055cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801055cf:	5b                   	pop    %ebx
801055d0:	5e                   	pop    %esi
801055d1:	5d                   	pop    %ebp
801055d2:	c3                   	ret    
801055d3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801055d7:	90                   	nop
    return -1;
801055d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055dd:	eb ed                	jmp    801055cc <sys_write+0x6c>
801055df:	90                   	nop

801055e0 <sys_close>:
{
801055e0:	55                   	push   %ebp
801055e1:	89 e5                	mov    %esp,%ebp
801055e3:	56                   	push   %esi
801055e4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801055e5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801055e8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801055eb:	50                   	push   %eax
801055ec:	6a 00                	push   $0x0
801055ee:	e8 1d fb ff ff       	call   80105110 <argint>
801055f3:	83 c4 10             	add    $0x10,%esp
801055f6:	85 c0                	test   %eax,%eax
801055f8:	78 3e                	js     80105638 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801055fa:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801055fe:	77 38                	ja     80105638 <sys_close+0x58>
80105600:	e8 8b e5 ff ff       	call   80103b90 <myproc>
80105605:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105608:	8d 5a 08             	lea    0x8(%edx),%ebx
8010560b:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
8010560f:	85 f6                	test   %esi,%esi
80105611:	74 25                	je     80105638 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
80105613:	e8 78 e5 ff ff       	call   80103b90 <myproc>
  fileclose(f);
80105618:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
8010561b:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105622:	00 
  fileclose(f);
80105623:	56                   	push   %esi
80105624:	e8 e7 b9 ff ff       	call   80101010 <fileclose>
  return 0;
80105629:	83 c4 10             	add    $0x10,%esp
8010562c:	31 c0                	xor    %eax,%eax
}
8010562e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105631:	5b                   	pop    %ebx
80105632:	5e                   	pop    %esi
80105633:	5d                   	pop    %ebp
80105634:	c3                   	ret    
80105635:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105638:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010563d:	eb ef                	jmp    8010562e <sys_close+0x4e>
8010563f:	90                   	nop

80105640 <sys_fstat>:
{
80105640:	55                   	push   %ebp
80105641:	89 e5                	mov    %esp,%ebp
80105643:	56                   	push   %esi
80105644:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105645:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105648:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010564b:	53                   	push   %ebx
8010564c:	6a 00                	push   $0x0
8010564e:	e8 bd fa ff ff       	call   80105110 <argint>
80105653:	83 c4 10             	add    $0x10,%esp
80105656:	85 c0                	test   %eax,%eax
80105658:	78 46                	js     801056a0 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010565a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010565e:	77 40                	ja     801056a0 <sys_fstat+0x60>
80105660:	e8 2b e5 ff ff       	call   80103b90 <myproc>
80105665:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105668:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010566c:	85 f6                	test   %esi,%esi
8010566e:	74 30                	je     801056a0 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105670:	83 ec 04             	sub    $0x4,%esp
80105673:	6a 14                	push   $0x14
80105675:	53                   	push   %ebx
80105676:	6a 01                	push   $0x1
80105678:	e8 e3 fa ff ff       	call   80105160 <argptr>
8010567d:	83 c4 10             	add    $0x10,%esp
80105680:	85 c0                	test   %eax,%eax
80105682:	78 1c                	js     801056a0 <sys_fstat+0x60>
  return filestat(f, st);
80105684:	83 ec 08             	sub    $0x8,%esp
80105687:	ff 75 f4             	pushl  -0xc(%ebp)
8010568a:	56                   	push   %esi
8010568b:	e8 60 ba ff ff       	call   801010f0 <filestat>
80105690:	83 c4 10             	add    $0x10,%esp
}
80105693:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105696:	5b                   	pop    %ebx
80105697:	5e                   	pop    %esi
80105698:	5d                   	pop    %ebp
80105699:	c3                   	ret    
8010569a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
801056a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056a5:	eb ec                	jmp    80105693 <sys_fstat+0x53>
801056a7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801056ae:	66 90                	xchg   %ax,%ax

801056b0 <sys_link>:
{
801056b0:	55                   	push   %ebp
801056b1:	89 e5                	mov    %esp,%ebp
801056b3:	57                   	push   %edi
801056b4:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056b5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801056b8:	53                   	push   %ebx
801056b9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801056bc:	50                   	push   %eax
801056bd:	6a 00                	push   $0x0
801056bf:	e8 0c fb ff ff       	call   801051d0 <argstr>
801056c4:	83 c4 10             	add    $0x10,%esp
801056c7:	85 c0                	test   %eax,%eax
801056c9:	0f 88 fb 00 00 00    	js     801057ca <sys_link+0x11a>
801056cf:	83 ec 08             	sub    $0x8,%esp
801056d2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801056d5:	50                   	push   %eax
801056d6:	6a 01                	push   $0x1
801056d8:	e8 f3 fa ff ff       	call   801051d0 <argstr>
801056dd:	83 c4 10             	add    $0x10,%esp
801056e0:	85 c0                	test   %eax,%eax
801056e2:	0f 88 e2 00 00 00    	js     801057ca <sys_link+0x11a>
  begin_op();
801056e8:	e8 83 d7 ff ff       	call   80102e70 <begin_op>
  if((ip = namei(old)) == 0){
801056ed:	83 ec 0c             	sub    $0xc,%esp
801056f0:	ff 75 d4             	pushl  -0x2c(%ebp)
801056f3:	e8 b8 ca ff ff       	call   801021b0 <namei>
801056f8:	83 c4 10             	add    $0x10,%esp
801056fb:	89 c3                	mov    %eax,%ebx
801056fd:	85 c0                	test   %eax,%eax
801056ff:	0f 84 e4 00 00 00    	je     801057e9 <sys_link+0x139>
  ilock(ip);
80105705:	83 ec 0c             	sub    $0xc,%esp
80105708:	50                   	push   %eax
80105709:	e8 82 c1 ff ff       	call   80101890 <ilock>
  if(ip->type == T_DIR){
8010570e:	83 c4 10             	add    $0x10,%esp
80105711:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105716:	0f 84 b5 00 00 00    	je     801057d1 <sys_link+0x121>
  iupdate(ip);
8010571c:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
8010571f:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105724:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105727:	53                   	push   %ebx
80105728:	e8 b3 c0 ff ff       	call   801017e0 <iupdate>
  iunlock(ip);
8010572d:	89 1c 24             	mov    %ebx,(%esp)
80105730:	e8 3b c2 ff ff       	call   80101970 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105735:	58                   	pop    %eax
80105736:	5a                   	pop    %edx
80105737:	57                   	push   %edi
80105738:	ff 75 d0             	pushl  -0x30(%ebp)
8010573b:	e8 90 ca ff ff       	call   801021d0 <nameiparent>
80105740:	83 c4 10             	add    $0x10,%esp
80105743:	89 c6                	mov    %eax,%esi
80105745:	85 c0                	test   %eax,%eax
80105747:	74 5b                	je     801057a4 <sys_link+0xf4>
  ilock(dp);
80105749:	83 ec 0c             	sub    $0xc,%esp
8010574c:	50                   	push   %eax
8010574d:	e8 3e c1 ff ff       	call   80101890 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105752:	8b 03                	mov    (%ebx),%eax
80105754:	83 c4 10             	add    $0x10,%esp
80105757:	39 06                	cmp    %eax,(%esi)
80105759:	75 3d                	jne    80105798 <sys_link+0xe8>
8010575b:	83 ec 04             	sub    $0x4,%esp
8010575e:	ff 73 04             	pushl  0x4(%ebx)
80105761:	57                   	push   %edi
80105762:	56                   	push   %esi
80105763:	e8 88 c9 ff ff       	call   801020f0 <dirlink>
80105768:	83 c4 10             	add    $0x10,%esp
8010576b:	85 c0                	test   %eax,%eax
8010576d:	78 29                	js     80105798 <sys_link+0xe8>
  iunlockput(dp);
8010576f:	83 ec 0c             	sub    $0xc,%esp
80105772:	56                   	push   %esi
80105773:	e8 a8 c3 ff ff       	call   80101b20 <iunlockput>
  iput(ip);
80105778:	89 1c 24             	mov    %ebx,(%esp)
8010577b:	e8 40 c2 ff ff       	call   801019c0 <iput>
  end_op();
80105780:	e8 5b d7 ff ff       	call   80102ee0 <end_op>
  return 0;
80105785:	83 c4 10             	add    $0x10,%esp
80105788:	31 c0                	xor    %eax,%eax
}
8010578a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010578d:	5b                   	pop    %ebx
8010578e:	5e                   	pop    %esi
8010578f:	5f                   	pop    %edi
80105790:	5d                   	pop    %ebp
80105791:	c3                   	ret    
80105792:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105798:	83 ec 0c             	sub    $0xc,%esp
8010579b:	56                   	push   %esi
8010579c:	e8 7f c3 ff ff       	call   80101b20 <iunlockput>
    goto bad;
801057a1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801057a4:	83 ec 0c             	sub    $0xc,%esp
801057a7:	53                   	push   %ebx
801057a8:	e8 e3 c0 ff ff       	call   80101890 <ilock>
  ip->nlink--;
801057ad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801057b2:	89 1c 24             	mov    %ebx,(%esp)
801057b5:	e8 26 c0 ff ff       	call   801017e0 <iupdate>
  iunlockput(ip);
801057ba:	89 1c 24             	mov    %ebx,(%esp)
801057bd:	e8 5e c3 ff ff       	call   80101b20 <iunlockput>
  end_op();
801057c2:	e8 19 d7 ff ff       	call   80102ee0 <end_op>
  return -1;
801057c7:	83 c4 10             	add    $0x10,%esp
801057ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057cf:	eb b9                	jmp    8010578a <sys_link+0xda>
    iunlockput(ip);
801057d1:	83 ec 0c             	sub    $0xc,%esp
801057d4:	53                   	push   %ebx
801057d5:	e8 46 c3 ff ff       	call   80101b20 <iunlockput>
    end_op();
801057da:	e8 01 d7 ff ff       	call   80102ee0 <end_op>
    return -1;
801057df:	83 c4 10             	add    $0x10,%esp
801057e2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057e7:	eb a1                	jmp    8010578a <sys_link+0xda>
    end_op();
801057e9:	e8 f2 d6 ff ff       	call   80102ee0 <end_op>
    return -1;
801057ee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057f3:	eb 95                	jmp    8010578a <sys_link+0xda>
801057f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801057fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105800 <sys_unlink>:
{
80105800:	55                   	push   %ebp
80105801:	89 e5                	mov    %esp,%ebp
80105803:	57                   	push   %edi
80105804:	56                   	push   %esi
  if(argstr(0, &path) < 0)
80105805:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
80105808:	53                   	push   %ebx
80105809:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
8010580c:	50                   	push   %eax
8010580d:	6a 00                	push   $0x0
8010580f:	e8 bc f9 ff ff       	call   801051d0 <argstr>
80105814:	83 c4 10             	add    $0x10,%esp
80105817:	85 c0                	test   %eax,%eax
80105819:	0f 88 7a 01 00 00    	js     80105999 <sys_unlink+0x199>
  begin_op();
8010581f:	e8 4c d6 ff ff       	call   80102e70 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105824:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105827:	83 ec 08             	sub    $0x8,%esp
8010582a:	53                   	push   %ebx
8010582b:	ff 75 c0             	pushl  -0x40(%ebp)
8010582e:	e8 9d c9 ff ff       	call   801021d0 <nameiparent>
80105833:	83 c4 10             	add    $0x10,%esp
80105836:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105839:	85 c0                	test   %eax,%eax
8010583b:	0f 84 62 01 00 00    	je     801059a3 <sys_unlink+0x1a3>
  ilock(dp);
80105841:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105844:	83 ec 0c             	sub    $0xc,%esp
80105847:	57                   	push   %edi
80105848:	e8 43 c0 ff ff       	call   80101890 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010584d:	58                   	pop    %eax
8010584e:	5a                   	pop    %edx
8010584f:	68 68 83 10 80       	push   $0x80108368
80105854:	53                   	push   %ebx
80105855:	e8 76 c5 ff ff       	call   80101dd0 <namecmp>
8010585a:	83 c4 10             	add    $0x10,%esp
8010585d:	85 c0                	test   %eax,%eax
8010585f:	0f 84 fb 00 00 00    	je     80105960 <sys_unlink+0x160>
80105865:	83 ec 08             	sub    $0x8,%esp
80105868:	68 67 83 10 80       	push   $0x80108367
8010586d:	53                   	push   %ebx
8010586e:	e8 5d c5 ff ff       	call   80101dd0 <namecmp>
80105873:	83 c4 10             	add    $0x10,%esp
80105876:	85 c0                	test   %eax,%eax
80105878:	0f 84 e2 00 00 00    	je     80105960 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010587e:	83 ec 04             	sub    $0x4,%esp
80105881:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105884:	50                   	push   %eax
80105885:	53                   	push   %ebx
80105886:	57                   	push   %edi
80105887:	e8 64 c5 ff ff       	call   80101df0 <dirlookup>
8010588c:	83 c4 10             	add    $0x10,%esp
8010588f:	89 c3                	mov    %eax,%ebx
80105891:	85 c0                	test   %eax,%eax
80105893:	0f 84 c7 00 00 00    	je     80105960 <sys_unlink+0x160>
  ilock(ip);
80105899:	83 ec 0c             	sub    $0xc,%esp
8010589c:	50                   	push   %eax
8010589d:	e8 ee bf ff ff       	call   80101890 <ilock>
  if(ip->nlink < 1)
801058a2:	83 c4 10             	add    $0x10,%esp
801058a5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
801058aa:	0f 8e 1c 01 00 00    	jle    801059cc <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
801058b0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058b5:	8d 7d d8             	lea    -0x28(%ebp),%edi
801058b8:	74 66                	je     80105920 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801058ba:	83 ec 04             	sub    $0x4,%esp
801058bd:	6a 10                	push   $0x10
801058bf:	6a 00                	push   $0x0
801058c1:	57                   	push   %edi
801058c2:	e8 89 f5 ff ff       	call   80104e50 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801058c7:	6a 10                	push   $0x10
801058c9:	ff 75 c4             	pushl  -0x3c(%ebp)
801058cc:	57                   	push   %edi
801058cd:	ff 75 b4             	pushl  -0x4c(%ebp)
801058d0:	e8 cb c3 ff ff       	call   80101ca0 <writei>
801058d5:	83 c4 20             	add    $0x20,%esp
801058d8:	83 f8 10             	cmp    $0x10,%eax
801058db:	0f 85 de 00 00 00    	jne    801059bf <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801058e1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801058e6:	0f 84 94 00 00 00    	je     80105980 <sys_unlink+0x180>
  iunlockput(dp);
801058ec:	83 ec 0c             	sub    $0xc,%esp
801058ef:	ff 75 b4             	pushl  -0x4c(%ebp)
801058f2:	e8 29 c2 ff ff       	call   80101b20 <iunlockput>
  ip->nlink--;
801058f7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801058fc:	89 1c 24             	mov    %ebx,(%esp)
801058ff:	e8 dc be ff ff       	call   801017e0 <iupdate>
  iunlockput(ip);
80105904:	89 1c 24             	mov    %ebx,(%esp)
80105907:	e8 14 c2 ff ff       	call   80101b20 <iunlockput>
  end_op();
8010590c:	e8 cf d5 ff ff       	call   80102ee0 <end_op>
  return 0;
80105911:	83 c4 10             	add    $0x10,%esp
80105914:	31 c0                	xor    %eax,%eax
}
80105916:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105919:	5b                   	pop    %ebx
8010591a:	5e                   	pop    %esi
8010591b:	5f                   	pop    %edi
8010591c:	5d                   	pop    %ebp
8010591d:	c3                   	ret    
8010591e:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105920:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105924:	76 94                	jbe    801058ba <sys_unlink+0xba>
80105926:	be 20 00 00 00       	mov    $0x20,%esi
8010592b:	eb 0b                	jmp    80105938 <sys_unlink+0x138>
8010592d:	8d 76 00             	lea    0x0(%esi),%esi
80105930:	83 c6 10             	add    $0x10,%esi
80105933:	3b 73 58             	cmp    0x58(%ebx),%esi
80105936:	73 82                	jae    801058ba <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105938:	6a 10                	push   $0x10
8010593a:	56                   	push   %esi
8010593b:	57                   	push   %edi
8010593c:	53                   	push   %ebx
8010593d:	e8 5e c2 ff ff       	call   80101ba0 <readi>
80105942:	83 c4 10             	add    $0x10,%esp
80105945:	83 f8 10             	cmp    $0x10,%eax
80105948:	75 68                	jne    801059b2 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010594a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010594f:	74 df                	je     80105930 <sys_unlink+0x130>
    iunlockput(ip);
80105951:	83 ec 0c             	sub    $0xc,%esp
80105954:	53                   	push   %ebx
80105955:	e8 c6 c1 ff ff       	call   80101b20 <iunlockput>
    goto bad;
8010595a:	83 c4 10             	add    $0x10,%esp
8010595d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105960:	83 ec 0c             	sub    $0xc,%esp
80105963:	ff 75 b4             	pushl  -0x4c(%ebp)
80105966:	e8 b5 c1 ff ff       	call   80101b20 <iunlockput>
  end_op();
8010596b:	e8 70 d5 ff ff       	call   80102ee0 <end_op>
  return -1;
80105970:	83 c4 10             	add    $0x10,%esp
80105973:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105978:	eb 9c                	jmp    80105916 <sys_unlink+0x116>
8010597a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105980:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105983:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105986:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010598b:	50                   	push   %eax
8010598c:	e8 4f be ff ff       	call   801017e0 <iupdate>
80105991:	83 c4 10             	add    $0x10,%esp
80105994:	e9 53 ff ff ff       	jmp    801058ec <sys_unlink+0xec>
    return -1;
80105999:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010599e:	e9 73 ff ff ff       	jmp    80105916 <sys_unlink+0x116>
    end_op();
801059a3:	e8 38 d5 ff ff       	call   80102ee0 <end_op>
    return -1;
801059a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059ad:	e9 64 ff ff ff       	jmp    80105916 <sys_unlink+0x116>
      panic("isdirempty: readi");
801059b2:	83 ec 0c             	sub    $0xc,%esp
801059b5:	68 8c 83 10 80       	push   $0x8010838c
801059ba:	e8 c1 a9 ff ff       	call   80100380 <panic>
    panic("unlink: writei");
801059bf:	83 ec 0c             	sub    $0xc,%esp
801059c2:	68 9e 83 10 80       	push   $0x8010839e
801059c7:	e8 b4 a9 ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801059cc:	83 ec 0c             	sub    $0xc,%esp
801059cf:	68 7a 83 10 80       	push   $0x8010837a
801059d4:	e8 a7 a9 ff ff       	call   80100380 <panic>
801059d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801059e0 <sys_open>:

int
sys_open(void)
{
801059e0:	55                   	push   %ebp
801059e1:	89 e5                	mov    %esp,%ebp
801059e3:	57                   	push   %edi
801059e4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801059e5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801059e8:	53                   	push   %ebx
801059e9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801059ec:	50                   	push   %eax
801059ed:	6a 00                	push   $0x0
801059ef:	e8 dc f7 ff ff       	call   801051d0 <argstr>
801059f4:	83 c4 10             	add    $0x10,%esp
801059f7:	85 c0                	test   %eax,%eax
801059f9:	0f 88 8e 00 00 00    	js     80105a8d <sys_open+0xad>
801059ff:	83 ec 08             	sub    $0x8,%esp
80105a02:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a05:	50                   	push   %eax
80105a06:	6a 01                	push   $0x1
80105a08:	e8 03 f7 ff ff       	call   80105110 <argint>
80105a0d:	83 c4 10             	add    $0x10,%esp
80105a10:	85 c0                	test   %eax,%eax
80105a12:	78 79                	js     80105a8d <sys_open+0xad>
    return -1;

  begin_op();
80105a14:	e8 57 d4 ff ff       	call   80102e70 <begin_op>

  if(omode & O_CREATE){
80105a19:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105a1d:	75 79                	jne    80105a98 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105a1f:	83 ec 0c             	sub    $0xc,%esp
80105a22:	ff 75 e0             	pushl  -0x20(%ebp)
80105a25:	e8 86 c7 ff ff       	call   801021b0 <namei>
80105a2a:	83 c4 10             	add    $0x10,%esp
80105a2d:	89 c6                	mov    %eax,%esi
80105a2f:	85 c0                	test   %eax,%eax
80105a31:	0f 84 7e 00 00 00    	je     80105ab5 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105a37:	83 ec 0c             	sub    $0xc,%esp
80105a3a:	50                   	push   %eax
80105a3b:	e8 50 be ff ff       	call   80101890 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105a40:	83 c4 10             	add    $0x10,%esp
80105a43:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105a48:	0f 84 c2 00 00 00    	je     80105b10 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105a4e:	e8 fd b4 ff ff       	call   80100f50 <filealloc>
80105a53:	89 c7                	mov    %eax,%edi
80105a55:	85 c0                	test   %eax,%eax
80105a57:	74 23                	je     80105a7c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105a59:	e8 32 e1 ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a5e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105a60:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105a64:	85 d2                	test   %edx,%edx
80105a66:	74 60                	je     80105ac8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105a68:	83 c3 01             	add    $0x1,%ebx
80105a6b:	83 fb 10             	cmp    $0x10,%ebx
80105a6e:	75 f0                	jne    80105a60 <sys_open+0x80>
    if(f)
      fileclose(f);
80105a70:	83 ec 0c             	sub    $0xc,%esp
80105a73:	57                   	push   %edi
80105a74:	e8 97 b5 ff ff       	call   80101010 <fileclose>
80105a79:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
80105a7c:	83 ec 0c             	sub    $0xc,%esp
80105a7f:	56                   	push   %esi
80105a80:	e8 9b c0 ff ff       	call   80101b20 <iunlockput>
    end_op();
80105a85:	e8 56 d4 ff ff       	call   80102ee0 <end_op>
    return -1;
80105a8a:	83 c4 10             	add    $0x10,%esp
80105a8d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105a92:	eb 6d                	jmp    80105b01 <sys_open+0x121>
80105a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105a98:	83 ec 0c             	sub    $0xc,%esp
80105a9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105a9e:	31 c9                	xor    %ecx,%ecx
80105aa0:	ba 02 00 00 00       	mov    $0x2,%edx
80105aa5:	6a 00                	push   $0x0
80105aa7:	e8 14 f8 ff ff       	call   801052c0 <create>
    if(ip == 0){
80105aac:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
80105aaf:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105ab1:	85 c0                	test   %eax,%eax
80105ab3:	75 99                	jne    80105a4e <sys_open+0x6e>
      end_op();
80105ab5:	e8 26 d4 ff ff       	call   80102ee0 <end_op>
      return -1;
80105aba:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105abf:	eb 40                	jmp    80105b01 <sys_open+0x121>
80105ac1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
80105ac8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105acb:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
80105acf:	56                   	push   %esi
80105ad0:	e8 9b be ff ff       	call   80101970 <iunlock>
  end_op();
80105ad5:	e8 06 d4 ff ff       	call   80102ee0 <end_op>

  f->type = FD_INODE;
80105ada:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105ae0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105ae3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105ae6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
80105ae9:	89 d0                	mov    %edx,%eax
  f->off = 0;
80105aeb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105af2:	f7 d0                	not    %eax
80105af4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105af7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
80105afa:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105afd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
80105b01:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b04:	89 d8                	mov    %ebx,%eax
80105b06:	5b                   	pop    %ebx
80105b07:	5e                   	pop    %esi
80105b08:	5f                   	pop    %edi
80105b09:	5d                   	pop    %ebp
80105b0a:	c3                   	ret    
80105b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105b0f:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
80105b10:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80105b13:	85 c9                	test   %ecx,%ecx
80105b15:	0f 84 33 ff ff ff    	je     80105a4e <sys_open+0x6e>
80105b1b:	e9 5c ff ff ff       	jmp    80105a7c <sys_open+0x9c>

80105b20 <sys_mkdir>:

int
sys_mkdir(void)
{
80105b20:	55                   	push   %ebp
80105b21:	89 e5                	mov    %esp,%ebp
80105b23:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105b26:	e8 45 d3 ff ff       	call   80102e70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80105b2b:	83 ec 08             	sub    $0x8,%esp
80105b2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b31:	50                   	push   %eax
80105b32:	6a 00                	push   $0x0
80105b34:	e8 97 f6 ff ff       	call   801051d0 <argstr>
80105b39:	83 c4 10             	add    $0x10,%esp
80105b3c:	85 c0                	test   %eax,%eax
80105b3e:	78 30                	js     80105b70 <sys_mkdir+0x50>
80105b40:	83 ec 0c             	sub    $0xc,%esp
80105b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b46:	31 c9                	xor    %ecx,%ecx
80105b48:	ba 01 00 00 00       	mov    $0x1,%edx
80105b4d:	6a 00                	push   $0x0
80105b4f:	e8 6c f7 ff ff       	call   801052c0 <create>
80105b54:	83 c4 10             	add    $0x10,%esp
80105b57:	85 c0                	test   %eax,%eax
80105b59:	74 15                	je     80105b70 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105b5b:	83 ec 0c             	sub    $0xc,%esp
80105b5e:	50                   	push   %eax
80105b5f:	e8 bc bf ff ff       	call   80101b20 <iunlockput>
  end_op();
80105b64:	e8 77 d3 ff ff       	call   80102ee0 <end_op>
  return 0;
80105b69:	83 c4 10             	add    $0x10,%esp
80105b6c:	31 c0                	xor    %eax,%eax
}
80105b6e:	c9                   	leave  
80105b6f:	c3                   	ret    
    end_op();
80105b70:	e8 6b d3 ff ff       	call   80102ee0 <end_op>
    return -1;
80105b75:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b7a:	c9                   	leave  
80105b7b:	c3                   	ret    
80105b7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105b80 <sys_mknod>:

int
sys_mknod(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105b86:	e8 e5 d2 ff ff       	call   80102e70 <begin_op>
  if((argstr(0, &path)) < 0 ||
80105b8b:	83 ec 08             	sub    $0x8,%esp
80105b8e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105b91:	50                   	push   %eax
80105b92:	6a 00                	push   $0x0
80105b94:	e8 37 f6 ff ff       	call   801051d0 <argstr>
80105b99:	83 c4 10             	add    $0x10,%esp
80105b9c:	85 c0                	test   %eax,%eax
80105b9e:	78 60                	js     80105c00 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105ba0:	83 ec 08             	sub    $0x8,%esp
80105ba3:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ba6:	50                   	push   %eax
80105ba7:	6a 01                	push   $0x1
80105ba9:	e8 62 f5 ff ff       	call   80105110 <argint>
  if((argstr(0, &path)) < 0 ||
80105bae:	83 c4 10             	add    $0x10,%esp
80105bb1:	85 c0                	test   %eax,%eax
80105bb3:	78 4b                	js     80105c00 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105bb5:	83 ec 08             	sub    $0x8,%esp
80105bb8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105bbb:	50                   	push   %eax
80105bbc:	6a 02                	push   $0x2
80105bbe:	e8 4d f5 ff ff       	call   80105110 <argint>
     argint(1, &major) < 0 ||
80105bc3:	83 c4 10             	add    $0x10,%esp
80105bc6:	85 c0                	test   %eax,%eax
80105bc8:	78 36                	js     80105c00 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105bca:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
80105bce:	83 ec 0c             	sub    $0xc,%esp
80105bd1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105bd5:	ba 03 00 00 00       	mov    $0x3,%edx
80105bda:	50                   	push   %eax
80105bdb:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105bde:	e8 dd f6 ff ff       	call   801052c0 <create>
     argint(2, &minor) < 0 ||
80105be3:	83 c4 10             	add    $0x10,%esp
80105be6:	85 c0                	test   %eax,%eax
80105be8:	74 16                	je     80105c00 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
80105bea:	83 ec 0c             	sub    $0xc,%esp
80105bed:	50                   	push   %eax
80105bee:	e8 2d bf ff ff       	call   80101b20 <iunlockput>
  end_op();
80105bf3:	e8 e8 d2 ff ff       	call   80102ee0 <end_op>
  return 0;
80105bf8:	83 c4 10             	add    $0x10,%esp
80105bfb:	31 c0                	xor    %eax,%eax
}
80105bfd:	c9                   	leave  
80105bfe:	c3                   	ret    
80105bff:	90                   	nop
    end_op();
80105c00:	e8 db d2 ff ff       	call   80102ee0 <end_op>
    return -1;
80105c05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c0a:	c9                   	leave  
80105c0b:	c3                   	ret    
80105c0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c10 <sys_chdir>:

int
sys_chdir(void)
{
80105c10:	55                   	push   %ebp
80105c11:	89 e5                	mov    %esp,%ebp
80105c13:	56                   	push   %esi
80105c14:	53                   	push   %ebx
80105c15:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105c18:	e8 73 df ff ff       	call   80103b90 <myproc>
80105c1d:	89 c6                	mov    %eax,%esi
  
  begin_op();
80105c1f:	e8 4c d2 ff ff       	call   80102e70 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105c24:	83 ec 08             	sub    $0x8,%esp
80105c27:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c2a:	50                   	push   %eax
80105c2b:	6a 00                	push   $0x0
80105c2d:	e8 9e f5 ff ff       	call   801051d0 <argstr>
80105c32:	83 c4 10             	add    $0x10,%esp
80105c35:	85 c0                	test   %eax,%eax
80105c37:	78 77                	js     80105cb0 <sys_chdir+0xa0>
80105c39:	83 ec 0c             	sub    $0xc,%esp
80105c3c:	ff 75 f4             	pushl  -0xc(%ebp)
80105c3f:	e8 6c c5 ff ff       	call   801021b0 <namei>
80105c44:	83 c4 10             	add    $0x10,%esp
80105c47:	89 c3                	mov    %eax,%ebx
80105c49:	85 c0                	test   %eax,%eax
80105c4b:	74 63                	je     80105cb0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
80105c4d:	83 ec 0c             	sub    $0xc,%esp
80105c50:	50                   	push   %eax
80105c51:	e8 3a bc ff ff       	call   80101890 <ilock>
  if(ip->type != T_DIR){
80105c56:	83 c4 10             	add    $0x10,%esp
80105c59:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105c5e:	75 30                	jne    80105c90 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105c60:	83 ec 0c             	sub    $0xc,%esp
80105c63:	53                   	push   %ebx
80105c64:	e8 07 bd ff ff       	call   80101970 <iunlock>
  iput(curproc->cwd);
80105c69:	58                   	pop    %eax
80105c6a:	ff 76 68             	pushl  0x68(%esi)
80105c6d:	e8 4e bd ff ff       	call   801019c0 <iput>
  end_op();
80105c72:	e8 69 d2 ff ff       	call   80102ee0 <end_op>
  curproc->cwd = ip;
80105c77:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80105c7a:	83 c4 10             	add    $0x10,%esp
80105c7d:	31 c0                	xor    %eax,%eax
}
80105c7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105c82:	5b                   	pop    %ebx
80105c83:	5e                   	pop    %esi
80105c84:	5d                   	pop    %ebp
80105c85:	c3                   	ret    
80105c86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c8d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105c90:	83 ec 0c             	sub    $0xc,%esp
80105c93:	53                   	push   %ebx
80105c94:	e8 87 be ff ff       	call   80101b20 <iunlockput>
    end_op();
80105c99:	e8 42 d2 ff ff       	call   80102ee0 <end_op>
    return -1;
80105c9e:	83 c4 10             	add    $0x10,%esp
80105ca1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ca6:	eb d7                	jmp    80105c7f <sys_chdir+0x6f>
80105ca8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105caf:	90                   	nop
    end_op();
80105cb0:	e8 2b d2 ff ff       	call   80102ee0 <end_op>
    return -1;
80105cb5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cba:	eb c3                	jmp    80105c7f <sys_chdir+0x6f>
80105cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105cc0 <sys_exec>:

int
sys_exec(void)
{
80105cc0:	55                   	push   %ebp
80105cc1:	89 e5                	mov    %esp,%ebp
80105cc3:	57                   	push   %edi
80105cc4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105cc5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
80105ccb:	53                   	push   %ebx
80105ccc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105cd2:	50                   	push   %eax
80105cd3:	6a 00                	push   $0x0
80105cd5:	e8 f6 f4 ff ff       	call   801051d0 <argstr>
80105cda:	83 c4 10             	add    $0x10,%esp
80105cdd:	85 c0                	test   %eax,%eax
80105cdf:	0f 88 87 00 00 00    	js     80105d6c <sys_exec+0xac>
80105ce5:	83 ec 08             	sub    $0x8,%esp
80105ce8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105cee:	50                   	push   %eax
80105cef:	6a 01                	push   $0x1
80105cf1:	e8 1a f4 ff ff       	call   80105110 <argint>
80105cf6:	83 c4 10             	add    $0x10,%esp
80105cf9:	85 c0                	test   %eax,%eax
80105cfb:	78 6f                	js     80105d6c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105cfd:	83 ec 04             	sub    $0x4,%esp
80105d00:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  for(i=0;; i++){
80105d06:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105d08:	68 80 00 00 00       	push   $0x80
80105d0d:	6a 00                	push   $0x0
80105d0f:	56                   	push   %esi
80105d10:	e8 3b f1 ff ff       	call   80104e50 <memset>
80105d15:	83 c4 10             	add    $0x10,%esp
80105d18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d1f:	90                   	nop
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105d20:	83 ec 08             	sub    $0x8,%esp
80105d23:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105d29:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105d30:	50                   	push   %eax
80105d31:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105d37:	01 f8                	add    %edi,%eax
80105d39:	50                   	push   %eax
80105d3a:	e8 41 f3 ff ff       	call   80105080 <fetchint>
80105d3f:	83 c4 10             	add    $0x10,%esp
80105d42:	85 c0                	test   %eax,%eax
80105d44:	78 26                	js     80105d6c <sys_exec+0xac>
      return -1;
    if(uarg == 0){
80105d46:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105d4c:	85 c0                	test   %eax,%eax
80105d4e:	74 30                	je     80105d80 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105d50:	83 ec 08             	sub    $0x8,%esp
80105d53:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105d56:	52                   	push   %edx
80105d57:	50                   	push   %eax
80105d58:	e8 63 f3 ff ff       	call   801050c0 <fetchstr>
80105d5d:	83 c4 10             	add    $0x10,%esp
80105d60:	85 c0                	test   %eax,%eax
80105d62:	78 08                	js     80105d6c <sys_exec+0xac>
  for(i=0;; i++){
80105d64:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105d67:	83 fb 20             	cmp    $0x20,%ebx
80105d6a:	75 b4                	jne    80105d20 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
80105d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
80105d6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d74:	5b                   	pop    %ebx
80105d75:	5e                   	pop    %esi
80105d76:	5f                   	pop    %edi
80105d77:	5d                   	pop    %ebp
80105d78:	c3                   	ret    
80105d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
80105d80:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105d87:	00 00 00 00 
  return exec(path, argv);
80105d8b:	83 ec 08             	sub    $0x8,%esp
80105d8e:	56                   	push   %esi
80105d8f:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
80105d95:	e8 36 ae ff ff       	call   80100bd0 <exec>
80105d9a:	83 c4 10             	add    $0x10,%esp
}
80105d9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105da0:	5b                   	pop    %ebx
80105da1:	5e                   	pop    %esi
80105da2:	5f                   	pop    %edi
80105da3:	5d                   	pop    %ebp
80105da4:	c3                   	ret    
80105da5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105db0 <sys_pipe>:

int
sys_pipe(void)
{
80105db0:	55                   	push   %ebp
80105db1:	89 e5                	mov    %esp,%ebp
80105db3:	57                   	push   %edi
80105db4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105db5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
80105db8:	53                   	push   %ebx
80105db9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105dbc:	6a 08                	push   $0x8
80105dbe:	50                   	push   %eax
80105dbf:	6a 00                	push   $0x0
80105dc1:	e8 9a f3 ff ff       	call   80105160 <argptr>
80105dc6:	83 c4 10             	add    $0x10,%esp
80105dc9:	85 c0                	test   %eax,%eax
80105dcb:	78 4a                	js     80105e17 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105dcd:	83 ec 08             	sub    $0x8,%esp
80105dd0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105dd3:	50                   	push   %eax
80105dd4:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105dd7:	50                   	push   %eax
80105dd8:	e8 63 d7 ff ff       	call   80103540 <pipealloc>
80105ddd:	83 c4 10             	add    $0x10,%esp
80105de0:	85 c0                	test   %eax,%eax
80105de2:	78 33                	js     80105e17 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105de4:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105de7:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105de9:	e8 a2 dd ff ff       	call   80103b90 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105dee:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105df0:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105df4:	85 f6                	test   %esi,%esi
80105df6:	74 28                	je     80105e20 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105df8:	83 c3 01             	add    $0x1,%ebx
80105dfb:	83 fb 10             	cmp    $0x10,%ebx
80105dfe:	75 f0                	jne    80105df0 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105e00:	83 ec 0c             	sub    $0xc,%esp
80105e03:	ff 75 e0             	pushl  -0x20(%ebp)
80105e06:	e8 05 b2 ff ff       	call   80101010 <fileclose>
    fileclose(wf);
80105e0b:	58                   	pop    %eax
80105e0c:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e0f:	e8 fc b1 ff ff       	call   80101010 <fileclose>
    return -1;
80105e14:	83 c4 10             	add    $0x10,%esp
80105e17:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e1c:	eb 53                	jmp    80105e71 <sys_pipe+0xc1>
80105e1e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e20:	8d 73 08             	lea    0x8(%ebx),%esi
80105e23:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105e27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105e2a:	e8 61 dd ff ff       	call   80103b90 <myproc>
80105e2f:	89 c2                	mov    %eax,%edx
  for(fd = 0; fd < NOFILE; fd++){
80105e31:	31 c0                	xor    %eax,%eax
80105e33:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e37:	90                   	nop
    if(curproc->ofile[fd] == 0){
80105e38:	8b 4c 82 28          	mov    0x28(%edx,%eax,4),%ecx
80105e3c:	85 c9                	test   %ecx,%ecx
80105e3e:	74 20                	je     80105e60 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105e40:	83 c0 01             	add    $0x1,%eax
80105e43:	83 f8 10             	cmp    $0x10,%eax
80105e46:	75 f0                	jne    80105e38 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105e48:	e8 43 dd ff ff       	call   80103b90 <myproc>
80105e4d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105e54:	00 
80105e55:	eb a9                	jmp    80105e00 <sys_pipe+0x50>
80105e57:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e5e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105e60:	89 7c 82 28          	mov    %edi,0x28(%edx,%eax,4)
  }
  fd[0] = fd0;
80105e64:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e67:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80105e69:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e6c:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80105e6f:	31 c0                	xor    %eax,%eax
}
80105e71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e74:	5b                   	pop    %ebx
80105e75:	5e                   	pop    %esi
80105e76:	5f                   	pop    %edi
80105e77:	5d                   	pop    %ebp
80105e78:	c3                   	ret    
80105e79:	66 90                	xchg   %ax,%ax
80105e7b:	66 90                	xchg   %ax,%ax
80105e7d:	66 90                	xchg   %ax,%ax
80105e7f:	90                   	nop

80105e80 <sys_fork>:
#include "proc.h"

int
sys_fork(void)
{
  return fork();
80105e80:	e9 3b df ff ff       	jmp    80103dc0 <fork>
80105e85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105e90 <sys_exit>:
}

int
sys_exit(void)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	83 ec 08             	sub    $0x8,%esp
  exit();
80105e96:	e8 a5 e4 ff ff       	call   80104340 <exit>
  return 0;  // not reached
}
80105e9b:	31 c0                	xor    %eax,%eax
80105e9d:	c9                   	leave  
80105e9e:	c3                   	ret    
80105e9f:	90                   	nop

80105ea0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105ea0:	e9 cb e5 ff ff       	jmp    80104470 <wait>
80105ea5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105eb0 <sys_kill>:
}

int
sys_kill(void)
{
80105eb0:	55                   	push   %ebp
80105eb1:	89 e5                	mov    %esp,%ebp
80105eb3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105eb6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105eb9:	50                   	push   %eax
80105eba:	6a 00                	push   $0x0
80105ebc:	e8 4f f2 ff ff       	call   80105110 <argint>
80105ec1:	83 c4 10             	add    $0x10,%esp
80105ec4:	85 c0                	test   %eax,%eax
80105ec6:	78 18                	js     80105ee0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105ec8:	83 ec 0c             	sub    $0xc,%esp
80105ecb:	ff 75 f4             	pushl  -0xc(%ebp)
80105ece:	e8 3d e8 ff ff       	call   80104710 <kill>
80105ed3:	83 c4 10             	add    $0x10,%esp
}
80105ed6:	c9                   	leave  
80105ed7:	c3                   	ret    
80105ed8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105edf:	90                   	nop
80105ee0:	c9                   	leave  
    return -1;
80105ee1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105ee6:	c3                   	ret    
80105ee7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105eee:	66 90                	xchg   %ax,%ax

80105ef0 <sys_getpid>:

int
sys_getpid(void)
{
80105ef0:	55                   	push   %ebp
80105ef1:	89 e5                	mov    %esp,%ebp
80105ef3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105ef6:	e8 95 dc ff ff       	call   80103b90 <myproc>
80105efb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105efe:	c9                   	leave  
80105eff:	c3                   	ret    

80105f00 <sys_sbrk>:

int
sys_sbrk(void)
{
80105f00:	55                   	push   %ebp
80105f01:	89 e5                	mov    %esp,%ebp
80105f03:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105f04:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f07:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f0a:	50                   	push   %eax
80105f0b:	6a 00                	push   $0x0
80105f0d:	e8 fe f1 ff ff       	call   80105110 <argint>
80105f12:	83 c4 10             	add    $0x10,%esp
80105f15:	85 c0                	test   %eax,%eax
80105f17:	78 27                	js     80105f40 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105f19:	e8 72 dc ff ff       	call   80103b90 <myproc>
  if(growproc(n) < 0)
80105f1e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105f21:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105f23:	ff 75 f4             	pushl  -0xc(%ebp)
80105f26:	e8 15 de ff ff       	call   80103d40 <growproc>
80105f2b:	83 c4 10             	add    $0x10,%esp
80105f2e:	85 c0                	test   %eax,%eax
80105f30:	78 0e                	js     80105f40 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105f32:	89 d8                	mov    %ebx,%eax
80105f34:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105f37:	c9                   	leave  
80105f38:	c3                   	ret    
80105f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105f40:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105f45:	eb eb                	jmp    80105f32 <sys_sbrk+0x32>
80105f47:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f4e:	66 90                	xchg   %ax,%ax

80105f50 <sys_sleep>:

int
sys_sleep(void)
{
80105f50:	55                   	push   %ebp
80105f51:	89 e5                	mov    %esp,%ebp
80105f53:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105f54:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105f57:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105f5a:	50                   	push   %eax
80105f5b:	6a 00                	push   $0x0
80105f5d:	e8 ae f1 ff ff       	call   80105110 <argint>
80105f62:	83 c4 10             	add    $0x10,%esp
80105f65:	85 c0                	test   %eax,%eax
80105f67:	0f 88 8a 00 00 00    	js     80105ff7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105f6d:	83 ec 0c             	sub    $0xc,%esp
80105f70:	68 80 56 11 80       	push   $0x80115680
80105f75:	e8 16 ee ff ff       	call   80104d90 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105f7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105f7d:	8b 1d 60 56 11 80    	mov    0x80115660,%ebx
  while(ticks - ticks0 < n){
80105f83:	83 c4 10             	add    $0x10,%esp
80105f86:	85 d2                	test   %edx,%edx
80105f88:	75 27                	jne    80105fb1 <sys_sleep+0x61>
80105f8a:	eb 54                	jmp    80105fe0 <sys_sleep+0x90>
80105f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105f90:	83 ec 08             	sub    $0x8,%esp
80105f93:	68 80 56 11 80       	push   $0x80115680
80105f98:	68 60 56 11 80       	push   $0x80115660
80105f9d:	e8 4e e6 ff ff       	call   801045f0 <sleep>
  while(ticks - ticks0 < n){
80105fa2:	a1 60 56 11 80       	mov    0x80115660,%eax
80105fa7:	83 c4 10             	add    $0x10,%esp
80105faa:	29 d8                	sub    %ebx,%eax
80105fac:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105faf:	73 2f                	jae    80105fe0 <sys_sleep+0x90>
    if(myproc()->killed){
80105fb1:	e8 da db ff ff       	call   80103b90 <myproc>
80105fb6:	8b 40 24             	mov    0x24(%eax),%eax
80105fb9:	85 c0                	test   %eax,%eax
80105fbb:	74 d3                	je     80105f90 <sys_sleep+0x40>
      release(&tickslock);
80105fbd:	83 ec 0c             	sub    $0xc,%esp
80105fc0:	68 80 56 11 80       	push   $0x80115680
80105fc5:	e8 66 ed ff ff       	call   80104d30 <release>
  }
  release(&tickslock);
  return 0;
}
80105fca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105fcd:	83 c4 10             	add    $0x10,%esp
80105fd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105fd5:	c9                   	leave  
80105fd6:	c3                   	ret    
80105fd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105fde:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105fe0:	83 ec 0c             	sub    $0xc,%esp
80105fe3:	68 80 56 11 80       	push   $0x80115680
80105fe8:	e8 43 ed ff ff       	call   80104d30 <release>
  return 0;
80105fed:	83 c4 10             	add    $0x10,%esp
80105ff0:	31 c0                	xor    %eax,%eax
}
80105ff2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ff5:	c9                   	leave  
80105ff6:	c3                   	ret    
    return -1;
80105ff7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ffc:	eb f4                	jmp    80105ff2 <sys_sleep+0xa2>
80105ffe:	66 90                	xchg   %ax,%ax

80106000 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106000:	55                   	push   %ebp
80106001:	89 e5                	mov    %esp,%ebp
80106003:	53                   	push   %ebx
80106004:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80106007:	68 80 56 11 80       	push   $0x80115680
8010600c:	e8 7f ed ff ff       	call   80104d90 <acquire>
  xticks = ticks;
80106011:	8b 1d 60 56 11 80    	mov    0x80115660,%ebx
  release(&tickslock);
80106017:	c7 04 24 80 56 11 80 	movl   $0x80115680,(%esp)
8010601e:	e8 0d ed ff ff       	call   80104d30 <release>
  return xticks;
}
80106023:	89 d8                	mov    %ebx,%eax
80106025:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80106028:	c9                   	leave  
80106029:	c3                   	ret    
8010602a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106030 <sys_changeQueue>:

int sys_changeQueue(void)
{
80106030:	55                   	push   %ebp
80106031:	89 e5                	mov    %esp,%ebp
80106033:	83 ec 20             	sub    $0x20,%esp
  int pid, level;
  argint(0, &pid);
80106036:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106039:	50                   	push   %eax
8010603a:	6a 00                	push   $0x0
8010603c:	e8 cf f0 ff ff       	call   80105110 <argint>
  argint(1, &level);
80106041:	58                   	pop    %eax
80106042:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106045:	5a                   	pop    %edx
80106046:	50                   	push   %eax
80106047:	6a 01                	push   $0x1
80106049:	e8 c2 f0 ff ff       	call   80105110 <argint>
  changeQueue(pid, level);
8010604e:	59                   	pop    %ecx
8010604f:	58                   	pop    %eax
80106050:	ff 75 f4             	pushl  -0xc(%ebp)
80106053:	ff 75 f0             	pushl  -0x10(%ebp)
80106056:	e8 f5 e7 ff ff       	call   80104850 <changeQueue>
  return 1;
}
8010605b:	b8 01 00 00 00       	mov    $0x1,%eax
80106060:	c9                   	leave  
80106061:	c3                   	ret    
80106062:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106070 <sys_setTicket>:

int 
sys_setTicket(void)
{
80106070:	55                   	push   %ebp
80106071:	89 e5                	mov    %esp,%ebp
80106073:	83 ec 20             	sub    $0x20,%esp
  int pid, ticket;
  argint(0, &pid);
80106076:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106079:	50                   	push   %eax
8010607a:	6a 00                	push   $0x0
8010607c:	e8 8f f0 ff ff       	call   80105110 <argint>
  argint(1, &ticket);
80106081:	58                   	pop    %eax
80106082:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106085:	5a                   	pop    %edx
80106086:	50                   	push   %eax
80106087:	6a 01                	push   $0x1
80106089:	e8 82 f0 ff ff       	call   80105110 <argint>
  setTicket(pid, ticket);
8010608e:	59                   	pop    %ecx
8010608f:	58                   	pop    %eax
80106090:	ff 75 f4             	pushl  -0xc(%ebp)
80106093:	ff 75 f0             	pushl  -0x10(%ebp)
80106096:	e8 e5 e7 ff ff       	call   80104880 <setTicket>
  return 1;
}
8010609b:	b8 01 00 00 00       	mov    $0x1,%eax
801060a0:	c9                   	leave  
801060a1:	c3                   	ret    
801060a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801060a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801060b0 <sys_setProcessParameters>:

int
sys_setProcessParameters(void)
{
801060b0:	55                   	push   %ebp
801060b1:	89 e5                	mov    %esp,%ebp
801060b3:	83 ec 20             	sub    $0x20,%esp
  int pid;
  int priorityRatio, arrivalTimeRatio, executedCycleRatio;
  argint(0, &pid);
801060b6:	8d 45 e8             	lea    -0x18(%ebp),%eax
801060b9:	50                   	push   %eax
801060ba:	6a 00                	push   $0x0
801060bc:	e8 4f f0 ff ff       	call   80105110 <argint>
  argint(1, &priorityRatio);
801060c1:	58                   	pop    %eax
801060c2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801060c5:	5a                   	pop    %edx
801060c6:	50                   	push   %eax
801060c7:	6a 01                	push   $0x1
801060c9:	e8 42 f0 ff ff       	call   80105110 <argint>
  argint(2, &arrivalTimeRatio);
801060ce:	59                   	pop    %ecx
801060cf:	58                   	pop    %eax
801060d0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801060d3:	50                   	push   %eax
801060d4:	6a 02                	push   $0x2
801060d6:	e8 35 f0 ff ff       	call   80105110 <argint>
  argint(3, &executedCycleRatio);
801060db:	58                   	pop    %eax
801060dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
801060df:	5a                   	pop    %edx
801060e0:	50                   	push   %eax
801060e1:	6a 03                	push   $0x3
801060e3:	e8 28 f0 ff ff       	call   80105110 <argint>
  setProcessParameters(pid, priorityRatio, arrivalTimeRatio, executedCycleRatio);
801060e8:	ff 75 f4             	pushl  -0xc(%ebp)
801060eb:	ff 75 f0             	pushl  -0x10(%ebp)
801060ee:	ff 75 ec             	pushl  -0x14(%ebp)
801060f1:	ff 75 e8             	pushl  -0x18(%ebp)
801060f4:	e8 b7 e7 ff ff       	call   801048b0 <setProcessParameters>
  return 1;
}
801060f9:	b8 01 00 00 00       	mov    $0x1,%eax
801060fe:	c9                   	leave  
801060ff:	c3                   	ret    

80106100 <sys_setSystemParameters>:

int
sys_setSystemParameters(void)
{
80106100:	55                   	push   %ebp
80106101:	89 e5                	mov    %esp,%ebp
80106103:	83 ec 20             	sub    $0x20,%esp
  int priorityRatio, arrivalTimeRatio, executedCycleRatio;
  argint(1, &priorityRatio);
80106106:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106109:	50                   	push   %eax
8010610a:	6a 01                	push   $0x1
8010610c:	e8 ff ef ff ff       	call   80105110 <argint>
  argint(2, &arrivalTimeRatio);
80106111:	58                   	pop    %eax
80106112:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106115:	5a                   	pop    %edx
80106116:	50                   	push   %eax
80106117:	6a 02                	push   $0x2
80106119:	e8 f2 ef ff ff       	call   80105110 <argint>
  argint(3, &executedCycleRatio);
8010611e:	59                   	pop    %ecx
8010611f:	58                   	pop    %eax
80106120:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106123:	50                   	push   %eax
80106124:	6a 03                	push   $0x3
80106126:	e8 e5 ef ff ff       	call   80105110 <argint>
  setSystemParameters(priorityRatio, arrivalTimeRatio, executedCycleRatio);
8010612b:	83 c4 0c             	add    $0xc,%esp
8010612e:	ff 75 f4             	pushl  -0xc(%ebp)
80106131:	ff 75 f0             	pushl  -0x10(%ebp)
80106134:	ff 75 ec             	pushl  -0x14(%ebp)
80106137:	e8 c4 e7 ff ff       	call   80104900 <setSystemParameters>
  return 1;
}
8010613c:	b8 01 00 00 00       	mov    $0x1,%eax
80106141:	c9                   	leave  
80106142:	c3                   	ret    
80106143:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010614a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106150 <sys_showInfo>:

int
sys_showInfo(void)
{
80106150:	55                   	push   %ebp
80106151:	89 e5                	mov    %esp,%ebp
80106153:	83 ec 08             	sub    $0x8,%esp
  showInfo();
80106156:	e8 85 e8 ff ff       	call   801049e0 <showInfo>
  return 1;
}
8010615b:	b8 01 00 00 00       	mov    $0x1,%eax
80106160:	c9                   	leave  
80106161:	c3                   	ret    

80106162 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106162:	1e                   	push   %ds
  pushl %es
80106163:	06                   	push   %es
  pushl %fs
80106164:	0f a0                	push   %fs
  pushl %gs
80106166:	0f a8                	push   %gs
  pushal
80106168:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80106169:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010616d:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010616f:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80106171:	54                   	push   %esp
  call trap
80106172:	e8 c9 00 00 00       	call   80106240 <trap>
  addl $4, %esp
80106177:	83 c4 04             	add    $0x4,%esp

8010617a <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
8010617a:	61                   	popa   
  popl %gs
8010617b:	0f a9                	pop    %gs
  popl %fs
8010617d:	0f a1                	pop    %fs
  popl %es
8010617f:	07                   	pop    %es
  popl %ds
80106180:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106181:	83 c4 08             	add    $0x8,%esp
  iret
80106184:	cf                   	iret   
80106185:	66 90                	xchg   %ax,%ax
80106187:	66 90                	xchg   %ax,%ax
80106189:	66 90                	xchg   %ax,%ax
8010618b:	66 90                	xchg   %ax,%ax
8010618d:	66 90                	xchg   %ax,%ax
8010618f:	90                   	nop

80106190 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106190:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80106191:	31 c0                	xor    %eax,%eax
{
80106193:	89 e5                	mov    %esp,%ebp
80106195:	83 ec 08             	sub    $0x8,%esp
80106198:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010619f:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801061a0:	8b 14 85 1c b0 10 80 	mov    -0x7fef4fe4(,%eax,4),%edx
801061a7:	c7 04 c5 c2 56 11 80 	movl   $0x8e000008,-0x7feea93e(,%eax,8)
801061ae:	08 00 00 8e 
801061b2:	66 89 14 c5 c0 56 11 	mov    %dx,-0x7feea940(,%eax,8)
801061b9:	80 
801061ba:	c1 ea 10             	shr    $0x10,%edx
801061bd:	66 89 14 c5 c6 56 11 	mov    %dx,-0x7feea93a(,%eax,8)
801061c4:	80 
  for(i = 0; i < 256; i++)
801061c5:	83 c0 01             	add    $0x1,%eax
801061c8:	3d 00 01 00 00       	cmp    $0x100,%eax
801061cd:	75 d1                	jne    801061a0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
801061cf:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061d2:	a1 1c b1 10 80       	mov    0x8010b11c,%eax
801061d7:	c7 05 c2 58 11 80 08 	movl   $0xef000008,0x801158c2
801061de:	00 00 ef 
  initlock(&tickslock, "time");
801061e1:	68 ad 83 10 80       	push   $0x801083ad
801061e6:	68 80 56 11 80       	push   $0x80115680
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801061eb:	66 a3 c0 58 11 80    	mov    %ax,0x801158c0
801061f1:	c1 e8 10             	shr    $0x10,%eax
801061f4:	66 a3 c6 58 11 80    	mov    %ax,0x801158c6
  initlock(&tickslock, "time");
801061fa:	e8 c1 e9 ff ff       	call   80104bc0 <initlock>
}
801061ff:	83 c4 10             	add    $0x10,%esp
80106202:	c9                   	leave  
80106203:	c3                   	ret    
80106204:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010620b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010620f:	90                   	nop

80106210 <idtinit>:

void
idtinit(void)
{
80106210:	55                   	push   %ebp
  pd[0] = size-1;
80106211:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80106216:	89 e5                	mov    %esp,%ebp
80106218:	83 ec 10             	sub    $0x10,%esp
8010621b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010621f:	b8 c0 56 11 80       	mov    $0x801156c0,%eax
80106224:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106228:	c1 e8 10             	shr    $0x10,%eax
8010622b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010622f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106232:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80106235:	c9                   	leave  
80106236:	c3                   	ret    
80106237:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010623e:	66 90                	xchg   %ax,%ax

80106240 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106240:	55                   	push   %ebp
80106241:	89 e5                	mov    %esp,%ebp
80106243:	57                   	push   %edi
80106244:	56                   	push   %esi
80106245:	53                   	push   %ebx
80106246:	83 ec 1c             	sub    $0x1c,%esp
80106249:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010624c:	8b 43 30             	mov    0x30(%ebx),%eax
8010624f:	83 f8 40             	cmp    $0x40,%eax
80106252:	0f 84 68 01 00 00    	je     801063c0 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80106258:	83 e8 20             	sub    $0x20,%eax
8010625b:	83 f8 1f             	cmp    $0x1f,%eax
8010625e:	0f 87 8c 00 00 00    	ja     801062f0 <trap+0xb0>
80106264:	ff 24 85 54 84 10 80 	jmp    *-0x7fef7bac(,%eax,4)
8010626b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010626f:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106270:	e8 db c0 ff ff       	call   80102350 <ideintr>
    lapiceoi();
80106275:	e8 a6 c7 ff ff       	call   80102a20 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010627a:	e8 11 d9 ff ff       	call   80103b90 <myproc>
8010627f:	85 c0                	test   %eax,%eax
80106281:	74 1d                	je     801062a0 <trap+0x60>
80106283:	e8 08 d9 ff ff       	call   80103b90 <myproc>
80106288:	8b 50 24             	mov    0x24(%eax),%edx
8010628b:	85 d2                	test   %edx,%edx
8010628d:	74 11                	je     801062a0 <trap+0x60>
8010628f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80106293:	83 e0 03             	and    $0x3,%eax
80106296:	66 83 f8 03          	cmp    $0x3,%ax
8010629a:	0f 84 e8 01 00 00    	je     80106488 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801062a0:	e8 eb d8 ff ff       	call   80103b90 <myproc>
801062a5:	85 c0                	test   %eax,%eax
801062a7:	74 0f                	je     801062b8 <trap+0x78>
801062a9:	e8 e2 d8 ff ff       	call   80103b90 <myproc>
801062ae:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801062b2:	0f 84 b8 00 00 00    	je     80106370 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801062b8:	e8 d3 d8 ff ff       	call   80103b90 <myproc>
801062bd:	85 c0                	test   %eax,%eax
801062bf:	74 1d                	je     801062de <trap+0x9e>
801062c1:	e8 ca d8 ff ff       	call   80103b90 <myproc>
801062c6:	8b 40 24             	mov    0x24(%eax),%eax
801062c9:	85 c0                	test   %eax,%eax
801062cb:	74 11                	je     801062de <trap+0x9e>
801062cd:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801062d1:	83 e0 03             	and    $0x3,%eax
801062d4:	66 83 f8 03          	cmp    $0x3,%ax
801062d8:	0f 84 0f 01 00 00    	je     801063ed <trap+0x1ad>
    exit();
}
801062de:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062e1:	5b                   	pop    %ebx
801062e2:	5e                   	pop    %esi
801062e3:	5f                   	pop    %edi
801062e4:	5d                   	pop    %ebp
801062e5:	c3                   	ret    
801062e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801062ed:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
801062f0:	e8 9b d8 ff ff       	call   80103b90 <myproc>
801062f5:	8b 7b 38             	mov    0x38(%ebx),%edi
801062f8:	85 c0                	test   %eax,%eax
801062fa:	0f 84 a2 01 00 00    	je     801064a2 <trap+0x262>
80106300:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80106304:	0f 84 98 01 00 00    	je     801064a2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010630a:	0f 20 d1             	mov    %cr2,%ecx
8010630d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106310:	e8 5b d8 ff ff       	call   80103b70 <cpuid>
80106315:	8b 73 30             	mov    0x30(%ebx),%esi
80106318:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010631b:	8b 43 34             	mov    0x34(%ebx),%eax
8010631e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80106321:	e8 6a d8 ff ff       	call   80103b90 <myproc>
80106326:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106329:	e8 62 d8 ff ff       	call   80103b90 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010632e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80106331:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106334:	51                   	push   %ecx
80106335:	57                   	push   %edi
80106336:	52                   	push   %edx
80106337:	ff 75 e4             	pushl  -0x1c(%ebp)
8010633a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
8010633b:	8b 75 e0             	mov    -0x20(%ebp),%esi
8010633e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80106341:	56                   	push   %esi
80106342:	ff 70 10             	pushl  0x10(%eax)
80106345:	68 10 84 10 80       	push   $0x80108410
8010634a:	e8 31 a3 ff ff       	call   80100680 <cprintf>
    myproc()->killed = 1;
8010634f:	83 c4 20             	add    $0x20,%esp
80106352:	e8 39 d8 ff ff       	call   80103b90 <myproc>
80106357:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010635e:	e8 2d d8 ff ff       	call   80103b90 <myproc>
80106363:	85 c0                	test   %eax,%eax
80106365:	0f 85 18 ff ff ff    	jne    80106283 <trap+0x43>
8010636b:	e9 30 ff ff ff       	jmp    801062a0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80106370:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80106374:	0f 85 3e ff ff ff    	jne    801062b8 <trap+0x78>
    yield();
8010637a:	e8 21 e2 ff ff       	call   801045a0 <yield>
8010637f:	e9 34 ff ff ff       	jmp    801062b8 <trap+0x78>
80106384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106388:	8b 7b 38             	mov    0x38(%ebx),%edi
8010638b:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
8010638f:	e8 dc d7 ff ff       	call   80103b70 <cpuid>
80106394:	57                   	push   %edi
80106395:	56                   	push   %esi
80106396:	50                   	push   %eax
80106397:	68 b8 83 10 80       	push   $0x801083b8
8010639c:	e8 df a2 ff ff       	call   80100680 <cprintf>
    lapiceoi();
801063a1:	e8 7a c6 ff ff       	call   80102a20 <lapiceoi>
    break;
801063a6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801063a9:	e8 e2 d7 ff ff       	call   80103b90 <myproc>
801063ae:	85 c0                	test   %eax,%eax
801063b0:	0f 85 cd fe ff ff    	jne    80106283 <trap+0x43>
801063b6:	e9 e5 fe ff ff       	jmp    801062a0 <trap+0x60>
801063bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801063bf:	90                   	nop
    if(myproc()->killed)
801063c0:	e8 cb d7 ff ff       	call   80103b90 <myproc>
801063c5:	8b 70 24             	mov    0x24(%eax),%esi
801063c8:	85 f6                	test   %esi,%esi
801063ca:	0f 85 c8 00 00 00    	jne    80106498 <trap+0x258>
    myproc()->tf = tf;
801063d0:	e8 bb d7 ff ff       	call   80103b90 <myproc>
801063d5:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
801063d8:	e8 73 ee ff ff       	call   80105250 <syscall>
    if(myproc()->killed)
801063dd:	e8 ae d7 ff ff       	call   80103b90 <myproc>
801063e2:	8b 48 24             	mov    0x24(%eax),%ecx
801063e5:	85 c9                	test   %ecx,%ecx
801063e7:	0f 84 f1 fe ff ff    	je     801062de <trap+0x9e>
}
801063ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063f0:	5b                   	pop    %ebx
801063f1:	5e                   	pop    %esi
801063f2:	5f                   	pop    %edi
801063f3:	5d                   	pop    %ebp
      exit();
801063f4:	e9 47 df ff ff       	jmp    80104340 <exit>
801063f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106400:	e8 5b 02 00 00       	call   80106660 <uartintr>
    lapiceoi();
80106405:	e8 16 c6 ff ff       	call   80102a20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010640a:	e8 81 d7 ff ff       	call   80103b90 <myproc>
8010640f:	85 c0                	test   %eax,%eax
80106411:	0f 85 6c fe ff ff    	jne    80106283 <trap+0x43>
80106417:	e9 84 fe ff ff       	jmp    801062a0 <trap+0x60>
8010641c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106420:	e8 bb c4 ff ff       	call   801028e0 <kbdintr>
    lapiceoi();
80106425:	e8 f6 c5 ff ff       	call   80102a20 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010642a:	e8 61 d7 ff ff       	call   80103b90 <myproc>
8010642f:	85 c0                	test   %eax,%eax
80106431:	0f 85 4c fe ff ff    	jne    80106283 <trap+0x43>
80106437:	e9 64 fe ff ff       	jmp    801062a0 <trap+0x60>
8010643c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106440:	e8 2b d7 ff ff       	call   80103b70 <cpuid>
80106445:	85 c0                	test   %eax,%eax
80106447:	0f 85 28 fe ff ff    	jne    80106275 <trap+0x35>
      acquire(&tickslock);
8010644d:	83 ec 0c             	sub    $0xc,%esp
80106450:	68 80 56 11 80       	push   $0x80115680
80106455:	e8 36 e9 ff ff       	call   80104d90 <acquire>
      wakeup(&ticks);
8010645a:	c7 04 24 60 56 11 80 	movl   $0x80115660,(%esp)
      ticks++;
80106461:	83 05 60 56 11 80 01 	addl   $0x1,0x80115660
      wakeup(&ticks);
80106468:	e8 43 e2 ff ff       	call   801046b0 <wakeup>
      release(&tickslock);
8010646d:	c7 04 24 80 56 11 80 	movl   $0x80115680,(%esp)
80106474:	e8 b7 e8 ff ff       	call   80104d30 <release>
80106479:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
8010647c:	e9 f4 fd ff ff       	jmp    80106275 <trap+0x35>
80106481:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
80106488:	e8 b3 de ff ff       	call   80104340 <exit>
8010648d:	e9 0e fe ff ff       	jmp    801062a0 <trap+0x60>
80106492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
80106498:	e8 a3 de ff ff       	call   80104340 <exit>
8010649d:	e9 2e ff ff ff       	jmp    801063d0 <trap+0x190>
801064a2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801064a5:	e8 c6 d6 ff ff       	call   80103b70 <cpuid>
801064aa:	83 ec 0c             	sub    $0xc,%esp
801064ad:	56                   	push   %esi
801064ae:	57                   	push   %edi
801064af:	50                   	push   %eax
801064b0:	ff 73 30             	pushl  0x30(%ebx)
801064b3:	68 dc 83 10 80       	push   $0x801083dc
801064b8:	e8 c3 a1 ff ff       	call   80100680 <cprintf>
      panic("trap");
801064bd:	83 c4 14             	add    $0x14,%esp
801064c0:	68 b2 83 10 80       	push   $0x801083b2
801064c5:	e8 b6 9e ff ff       	call   80100380 <panic>
801064ca:	66 90                	xchg   %ax,%ax
801064cc:	66 90                	xchg   %ax,%ax
801064ce:	66 90                	xchg   %ax,%ax

801064d0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
801064d0:	a1 c0 5e 11 80       	mov    0x80115ec0,%eax
801064d5:	85 c0                	test   %eax,%eax
801064d7:	74 17                	je     801064f0 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801064d9:	ba fd 03 00 00       	mov    $0x3fd,%edx
801064de:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801064df:	a8 01                	test   $0x1,%al
801064e1:	74 0d                	je     801064f0 <uartgetc+0x20>
801064e3:	ba f8 03 00 00       	mov    $0x3f8,%edx
801064e8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801064e9:	0f b6 c0             	movzbl %al,%eax
801064ec:	c3                   	ret    
801064ed:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801064f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801064f5:	c3                   	ret    
801064f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801064fd:	8d 76 00             	lea    0x0(%esi),%esi

80106500 <uartinit>:
{
80106500:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106501:	31 c9                	xor    %ecx,%ecx
80106503:	89 c8                	mov    %ecx,%eax
80106505:	89 e5                	mov    %esp,%ebp
80106507:	57                   	push   %edi
80106508:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010650d:	56                   	push   %esi
8010650e:	89 fa                	mov    %edi,%edx
80106510:	53                   	push   %ebx
80106511:	83 ec 1c             	sub    $0x1c,%esp
80106514:	ee                   	out    %al,(%dx)
80106515:	be fb 03 00 00       	mov    $0x3fb,%esi
8010651a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010651f:	89 f2                	mov    %esi,%edx
80106521:	ee                   	out    %al,(%dx)
80106522:	b8 0c 00 00 00       	mov    $0xc,%eax
80106527:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010652c:	ee                   	out    %al,(%dx)
8010652d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106532:	89 c8                	mov    %ecx,%eax
80106534:	89 da                	mov    %ebx,%edx
80106536:	ee                   	out    %al,(%dx)
80106537:	b8 03 00 00 00       	mov    $0x3,%eax
8010653c:	89 f2                	mov    %esi,%edx
8010653e:	ee                   	out    %al,(%dx)
8010653f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106544:	89 c8                	mov    %ecx,%eax
80106546:	ee                   	out    %al,(%dx)
80106547:	b8 01 00 00 00       	mov    $0x1,%eax
8010654c:	89 da                	mov    %ebx,%edx
8010654e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010654f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106554:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106555:	3c ff                	cmp    $0xff,%al
80106557:	0f 84 93 00 00 00    	je     801065f0 <uartinit+0xf0>
  uart = 1;
8010655d:	c7 05 c0 5e 11 80 01 	movl   $0x1,0x80115ec0
80106564:	00 00 00 
80106567:	89 fa                	mov    %edi,%edx
80106569:	ec                   	in     (%dx),%al
8010656a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010656f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80106570:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
80106573:	bf d4 84 10 80       	mov    $0x801084d4,%edi
80106578:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
8010657d:	6a 00                	push   $0x0
8010657f:	6a 04                	push   $0x4
80106581:	e8 0a c0 ff ff       	call   80102590 <ioapicenable>
80106586:	c6 45 e7 76          	movb   $0x76,-0x19(%ebp)
8010658a:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
8010658d:	c6 45 e6 78          	movb   $0x78,-0x1a(%ebp)
80106591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
80106598:	a1 c0 5e 11 80       	mov    0x80115ec0,%eax
8010659d:	bb 80 00 00 00       	mov    $0x80,%ebx
801065a2:	85 c0                	test   %eax,%eax
801065a4:	75 1c                	jne    801065c2 <uartinit+0xc2>
801065a6:	eb 2b                	jmp    801065d3 <uartinit+0xd3>
801065a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065af:	90                   	nop
    microdelay(10);
801065b0:	83 ec 0c             	sub    $0xc,%esp
801065b3:	6a 0a                	push   $0xa
801065b5:	e8 86 c4 ff ff       	call   80102a40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801065ba:	83 c4 10             	add    $0x10,%esp
801065bd:	83 eb 01             	sub    $0x1,%ebx
801065c0:	74 07                	je     801065c9 <uartinit+0xc9>
801065c2:	89 f2                	mov    %esi,%edx
801065c4:	ec                   	in     (%dx),%al
801065c5:	a8 20                	test   $0x20,%al
801065c7:	74 e7                	je     801065b0 <uartinit+0xb0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801065c9:	0f b6 45 e6          	movzbl -0x1a(%ebp),%eax
801065cd:	ba f8 03 00 00       	mov    $0x3f8,%edx
801065d2:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
801065d3:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801065d7:	83 c7 01             	add    $0x1,%edi
801065da:	84 c0                	test   %al,%al
801065dc:	74 12                	je     801065f0 <uartinit+0xf0>
801065de:	88 45 e6             	mov    %al,-0x1a(%ebp)
801065e1:	0f b6 47 01          	movzbl 0x1(%edi),%eax
801065e5:	88 45 e7             	mov    %al,-0x19(%ebp)
801065e8:	eb ae                	jmp    80106598 <uartinit+0x98>
801065ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
801065f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065f3:	5b                   	pop    %ebx
801065f4:	5e                   	pop    %esi
801065f5:	5f                   	pop    %edi
801065f6:	5d                   	pop    %ebp
801065f7:	c3                   	ret    
801065f8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801065ff:	90                   	nop

80106600 <uartputc>:
  if(!uart)
80106600:	a1 c0 5e 11 80       	mov    0x80115ec0,%eax
80106605:	85 c0                	test   %eax,%eax
80106607:	74 47                	je     80106650 <uartputc+0x50>
{
80106609:	55                   	push   %ebp
8010660a:	89 e5                	mov    %esp,%ebp
8010660c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010660d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106612:	53                   	push   %ebx
80106613:	bb 80 00 00 00       	mov    $0x80,%ebx
80106618:	eb 18                	jmp    80106632 <uartputc+0x32>
8010661a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106620:	83 ec 0c             	sub    $0xc,%esp
80106623:	6a 0a                	push   $0xa
80106625:	e8 16 c4 ff ff       	call   80102a40 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010662a:	83 c4 10             	add    $0x10,%esp
8010662d:	83 eb 01             	sub    $0x1,%ebx
80106630:	74 07                	je     80106639 <uartputc+0x39>
80106632:	89 f2                	mov    %esi,%edx
80106634:	ec                   	in     (%dx),%al
80106635:	a8 20                	test   $0x20,%al
80106637:	74 e7                	je     80106620 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106639:	8b 45 08             	mov    0x8(%ebp),%eax
8010663c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106641:	ee                   	out    %al,(%dx)
}
80106642:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106645:	5b                   	pop    %ebx
80106646:	5e                   	pop    %esi
80106647:	5d                   	pop    %ebp
80106648:	c3                   	ret    
80106649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106650:	c3                   	ret    
80106651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106658:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010665f:	90                   	nop

80106660 <uartintr>:

void
uartintr(void)
{
80106660:	55                   	push   %ebp
80106661:	89 e5                	mov    %esp,%ebp
80106663:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106666:	68 d0 64 10 80       	push   $0x801064d0
8010666b:	e8 80 a2 ff ff       	call   801008f0 <consoleintr>
}
80106670:	83 c4 10             	add    $0x10,%esp
80106673:	c9                   	leave  
80106674:	c3                   	ret    

80106675 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106675:	6a 00                	push   $0x0
  pushl $0
80106677:	6a 00                	push   $0x0
  jmp alltraps
80106679:	e9 e4 fa ff ff       	jmp    80106162 <alltraps>

8010667e <vector1>:
.globl vector1
vector1:
  pushl $0
8010667e:	6a 00                	push   $0x0
  pushl $1
80106680:	6a 01                	push   $0x1
  jmp alltraps
80106682:	e9 db fa ff ff       	jmp    80106162 <alltraps>

80106687 <vector2>:
.globl vector2
vector2:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $2
80106689:	6a 02                	push   $0x2
  jmp alltraps
8010668b:	e9 d2 fa ff ff       	jmp    80106162 <alltraps>

80106690 <vector3>:
.globl vector3
vector3:
  pushl $0
80106690:	6a 00                	push   $0x0
  pushl $3
80106692:	6a 03                	push   $0x3
  jmp alltraps
80106694:	e9 c9 fa ff ff       	jmp    80106162 <alltraps>

80106699 <vector4>:
.globl vector4
vector4:
  pushl $0
80106699:	6a 00                	push   $0x0
  pushl $4
8010669b:	6a 04                	push   $0x4
  jmp alltraps
8010669d:	e9 c0 fa ff ff       	jmp    80106162 <alltraps>

801066a2 <vector5>:
.globl vector5
vector5:
  pushl $0
801066a2:	6a 00                	push   $0x0
  pushl $5
801066a4:	6a 05                	push   $0x5
  jmp alltraps
801066a6:	e9 b7 fa ff ff       	jmp    80106162 <alltraps>

801066ab <vector6>:
.globl vector6
vector6:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $6
801066ad:	6a 06                	push   $0x6
  jmp alltraps
801066af:	e9 ae fa ff ff       	jmp    80106162 <alltraps>

801066b4 <vector7>:
.globl vector7
vector7:
  pushl $0
801066b4:	6a 00                	push   $0x0
  pushl $7
801066b6:	6a 07                	push   $0x7
  jmp alltraps
801066b8:	e9 a5 fa ff ff       	jmp    80106162 <alltraps>

801066bd <vector8>:
.globl vector8
vector8:
  pushl $8
801066bd:	6a 08                	push   $0x8
  jmp alltraps
801066bf:	e9 9e fa ff ff       	jmp    80106162 <alltraps>

801066c4 <vector9>:
.globl vector9
vector9:
  pushl $0
801066c4:	6a 00                	push   $0x0
  pushl $9
801066c6:	6a 09                	push   $0x9
  jmp alltraps
801066c8:	e9 95 fa ff ff       	jmp    80106162 <alltraps>

801066cd <vector10>:
.globl vector10
vector10:
  pushl $10
801066cd:	6a 0a                	push   $0xa
  jmp alltraps
801066cf:	e9 8e fa ff ff       	jmp    80106162 <alltraps>

801066d4 <vector11>:
.globl vector11
vector11:
  pushl $11
801066d4:	6a 0b                	push   $0xb
  jmp alltraps
801066d6:	e9 87 fa ff ff       	jmp    80106162 <alltraps>

801066db <vector12>:
.globl vector12
vector12:
  pushl $12
801066db:	6a 0c                	push   $0xc
  jmp alltraps
801066dd:	e9 80 fa ff ff       	jmp    80106162 <alltraps>

801066e2 <vector13>:
.globl vector13
vector13:
  pushl $13
801066e2:	6a 0d                	push   $0xd
  jmp alltraps
801066e4:	e9 79 fa ff ff       	jmp    80106162 <alltraps>

801066e9 <vector14>:
.globl vector14
vector14:
  pushl $14
801066e9:	6a 0e                	push   $0xe
  jmp alltraps
801066eb:	e9 72 fa ff ff       	jmp    80106162 <alltraps>

801066f0 <vector15>:
.globl vector15
vector15:
  pushl $0
801066f0:	6a 00                	push   $0x0
  pushl $15
801066f2:	6a 0f                	push   $0xf
  jmp alltraps
801066f4:	e9 69 fa ff ff       	jmp    80106162 <alltraps>

801066f9 <vector16>:
.globl vector16
vector16:
  pushl $0
801066f9:	6a 00                	push   $0x0
  pushl $16
801066fb:	6a 10                	push   $0x10
  jmp alltraps
801066fd:	e9 60 fa ff ff       	jmp    80106162 <alltraps>

80106702 <vector17>:
.globl vector17
vector17:
  pushl $17
80106702:	6a 11                	push   $0x11
  jmp alltraps
80106704:	e9 59 fa ff ff       	jmp    80106162 <alltraps>

80106709 <vector18>:
.globl vector18
vector18:
  pushl $0
80106709:	6a 00                	push   $0x0
  pushl $18
8010670b:	6a 12                	push   $0x12
  jmp alltraps
8010670d:	e9 50 fa ff ff       	jmp    80106162 <alltraps>

80106712 <vector19>:
.globl vector19
vector19:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $19
80106714:	6a 13                	push   $0x13
  jmp alltraps
80106716:	e9 47 fa ff ff       	jmp    80106162 <alltraps>

8010671b <vector20>:
.globl vector20
vector20:
  pushl $0
8010671b:	6a 00                	push   $0x0
  pushl $20
8010671d:	6a 14                	push   $0x14
  jmp alltraps
8010671f:	e9 3e fa ff ff       	jmp    80106162 <alltraps>

80106724 <vector21>:
.globl vector21
vector21:
  pushl $0
80106724:	6a 00                	push   $0x0
  pushl $21
80106726:	6a 15                	push   $0x15
  jmp alltraps
80106728:	e9 35 fa ff ff       	jmp    80106162 <alltraps>

8010672d <vector22>:
.globl vector22
vector22:
  pushl $0
8010672d:	6a 00                	push   $0x0
  pushl $22
8010672f:	6a 16                	push   $0x16
  jmp alltraps
80106731:	e9 2c fa ff ff       	jmp    80106162 <alltraps>

80106736 <vector23>:
.globl vector23
vector23:
  pushl $0
80106736:	6a 00                	push   $0x0
  pushl $23
80106738:	6a 17                	push   $0x17
  jmp alltraps
8010673a:	e9 23 fa ff ff       	jmp    80106162 <alltraps>

8010673f <vector24>:
.globl vector24
vector24:
  pushl $0
8010673f:	6a 00                	push   $0x0
  pushl $24
80106741:	6a 18                	push   $0x18
  jmp alltraps
80106743:	e9 1a fa ff ff       	jmp    80106162 <alltraps>

80106748 <vector25>:
.globl vector25
vector25:
  pushl $0
80106748:	6a 00                	push   $0x0
  pushl $25
8010674a:	6a 19                	push   $0x19
  jmp alltraps
8010674c:	e9 11 fa ff ff       	jmp    80106162 <alltraps>

80106751 <vector26>:
.globl vector26
vector26:
  pushl $0
80106751:	6a 00                	push   $0x0
  pushl $26
80106753:	6a 1a                	push   $0x1a
  jmp alltraps
80106755:	e9 08 fa ff ff       	jmp    80106162 <alltraps>

8010675a <vector27>:
.globl vector27
vector27:
  pushl $0
8010675a:	6a 00                	push   $0x0
  pushl $27
8010675c:	6a 1b                	push   $0x1b
  jmp alltraps
8010675e:	e9 ff f9 ff ff       	jmp    80106162 <alltraps>

80106763 <vector28>:
.globl vector28
vector28:
  pushl $0
80106763:	6a 00                	push   $0x0
  pushl $28
80106765:	6a 1c                	push   $0x1c
  jmp alltraps
80106767:	e9 f6 f9 ff ff       	jmp    80106162 <alltraps>

8010676c <vector29>:
.globl vector29
vector29:
  pushl $0
8010676c:	6a 00                	push   $0x0
  pushl $29
8010676e:	6a 1d                	push   $0x1d
  jmp alltraps
80106770:	e9 ed f9 ff ff       	jmp    80106162 <alltraps>

80106775 <vector30>:
.globl vector30
vector30:
  pushl $0
80106775:	6a 00                	push   $0x0
  pushl $30
80106777:	6a 1e                	push   $0x1e
  jmp alltraps
80106779:	e9 e4 f9 ff ff       	jmp    80106162 <alltraps>

8010677e <vector31>:
.globl vector31
vector31:
  pushl $0
8010677e:	6a 00                	push   $0x0
  pushl $31
80106780:	6a 1f                	push   $0x1f
  jmp alltraps
80106782:	e9 db f9 ff ff       	jmp    80106162 <alltraps>

80106787 <vector32>:
.globl vector32
vector32:
  pushl $0
80106787:	6a 00                	push   $0x0
  pushl $32
80106789:	6a 20                	push   $0x20
  jmp alltraps
8010678b:	e9 d2 f9 ff ff       	jmp    80106162 <alltraps>

80106790 <vector33>:
.globl vector33
vector33:
  pushl $0
80106790:	6a 00                	push   $0x0
  pushl $33
80106792:	6a 21                	push   $0x21
  jmp alltraps
80106794:	e9 c9 f9 ff ff       	jmp    80106162 <alltraps>

80106799 <vector34>:
.globl vector34
vector34:
  pushl $0
80106799:	6a 00                	push   $0x0
  pushl $34
8010679b:	6a 22                	push   $0x22
  jmp alltraps
8010679d:	e9 c0 f9 ff ff       	jmp    80106162 <alltraps>

801067a2 <vector35>:
.globl vector35
vector35:
  pushl $0
801067a2:	6a 00                	push   $0x0
  pushl $35
801067a4:	6a 23                	push   $0x23
  jmp alltraps
801067a6:	e9 b7 f9 ff ff       	jmp    80106162 <alltraps>

801067ab <vector36>:
.globl vector36
vector36:
  pushl $0
801067ab:	6a 00                	push   $0x0
  pushl $36
801067ad:	6a 24                	push   $0x24
  jmp alltraps
801067af:	e9 ae f9 ff ff       	jmp    80106162 <alltraps>

801067b4 <vector37>:
.globl vector37
vector37:
  pushl $0
801067b4:	6a 00                	push   $0x0
  pushl $37
801067b6:	6a 25                	push   $0x25
  jmp alltraps
801067b8:	e9 a5 f9 ff ff       	jmp    80106162 <alltraps>

801067bd <vector38>:
.globl vector38
vector38:
  pushl $0
801067bd:	6a 00                	push   $0x0
  pushl $38
801067bf:	6a 26                	push   $0x26
  jmp alltraps
801067c1:	e9 9c f9 ff ff       	jmp    80106162 <alltraps>

801067c6 <vector39>:
.globl vector39
vector39:
  pushl $0
801067c6:	6a 00                	push   $0x0
  pushl $39
801067c8:	6a 27                	push   $0x27
  jmp alltraps
801067ca:	e9 93 f9 ff ff       	jmp    80106162 <alltraps>

801067cf <vector40>:
.globl vector40
vector40:
  pushl $0
801067cf:	6a 00                	push   $0x0
  pushl $40
801067d1:	6a 28                	push   $0x28
  jmp alltraps
801067d3:	e9 8a f9 ff ff       	jmp    80106162 <alltraps>

801067d8 <vector41>:
.globl vector41
vector41:
  pushl $0
801067d8:	6a 00                	push   $0x0
  pushl $41
801067da:	6a 29                	push   $0x29
  jmp alltraps
801067dc:	e9 81 f9 ff ff       	jmp    80106162 <alltraps>

801067e1 <vector42>:
.globl vector42
vector42:
  pushl $0
801067e1:	6a 00                	push   $0x0
  pushl $42
801067e3:	6a 2a                	push   $0x2a
  jmp alltraps
801067e5:	e9 78 f9 ff ff       	jmp    80106162 <alltraps>

801067ea <vector43>:
.globl vector43
vector43:
  pushl $0
801067ea:	6a 00                	push   $0x0
  pushl $43
801067ec:	6a 2b                	push   $0x2b
  jmp alltraps
801067ee:	e9 6f f9 ff ff       	jmp    80106162 <alltraps>

801067f3 <vector44>:
.globl vector44
vector44:
  pushl $0
801067f3:	6a 00                	push   $0x0
  pushl $44
801067f5:	6a 2c                	push   $0x2c
  jmp alltraps
801067f7:	e9 66 f9 ff ff       	jmp    80106162 <alltraps>

801067fc <vector45>:
.globl vector45
vector45:
  pushl $0
801067fc:	6a 00                	push   $0x0
  pushl $45
801067fe:	6a 2d                	push   $0x2d
  jmp alltraps
80106800:	e9 5d f9 ff ff       	jmp    80106162 <alltraps>

80106805 <vector46>:
.globl vector46
vector46:
  pushl $0
80106805:	6a 00                	push   $0x0
  pushl $46
80106807:	6a 2e                	push   $0x2e
  jmp alltraps
80106809:	e9 54 f9 ff ff       	jmp    80106162 <alltraps>

8010680e <vector47>:
.globl vector47
vector47:
  pushl $0
8010680e:	6a 00                	push   $0x0
  pushl $47
80106810:	6a 2f                	push   $0x2f
  jmp alltraps
80106812:	e9 4b f9 ff ff       	jmp    80106162 <alltraps>

80106817 <vector48>:
.globl vector48
vector48:
  pushl $0
80106817:	6a 00                	push   $0x0
  pushl $48
80106819:	6a 30                	push   $0x30
  jmp alltraps
8010681b:	e9 42 f9 ff ff       	jmp    80106162 <alltraps>

80106820 <vector49>:
.globl vector49
vector49:
  pushl $0
80106820:	6a 00                	push   $0x0
  pushl $49
80106822:	6a 31                	push   $0x31
  jmp alltraps
80106824:	e9 39 f9 ff ff       	jmp    80106162 <alltraps>

80106829 <vector50>:
.globl vector50
vector50:
  pushl $0
80106829:	6a 00                	push   $0x0
  pushl $50
8010682b:	6a 32                	push   $0x32
  jmp alltraps
8010682d:	e9 30 f9 ff ff       	jmp    80106162 <alltraps>

80106832 <vector51>:
.globl vector51
vector51:
  pushl $0
80106832:	6a 00                	push   $0x0
  pushl $51
80106834:	6a 33                	push   $0x33
  jmp alltraps
80106836:	e9 27 f9 ff ff       	jmp    80106162 <alltraps>

8010683b <vector52>:
.globl vector52
vector52:
  pushl $0
8010683b:	6a 00                	push   $0x0
  pushl $52
8010683d:	6a 34                	push   $0x34
  jmp alltraps
8010683f:	e9 1e f9 ff ff       	jmp    80106162 <alltraps>

80106844 <vector53>:
.globl vector53
vector53:
  pushl $0
80106844:	6a 00                	push   $0x0
  pushl $53
80106846:	6a 35                	push   $0x35
  jmp alltraps
80106848:	e9 15 f9 ff ff       	jmp    80106162 <alltraps>

8010684d <vector54>:
.globl vector54
vector54:
  pushl $0
8010684d:	6a 00                	push   $0x0
  pushl $54
8010684f:	6a 36                	push   $0x36
  jmp alltraps
80106851:	e9 0c f9 ff ff       	jmp    80106162 <alltraps>

80106856 <vector55>:
.globl vector55
vector55:
  pushl $0
80106856:	6a 00                	push   $0x0
  pushl $55
80106858:	6a 37                	push   $0x37
  jmp alltraps
8010685a:	e9 03 f9 ff ff       	jmp    80106162 <alltraps>

8010685f <vector56>:
.globl vector56
vector56:
  pushl $0
8010685f:	6a 00                	push   $0x0
  pushl $56
80106861:	6a 38                	push   $0x38
  jmp alltraps
80106863:	e9 fa f8 ff ff       	jmp    80106162 <alltraps>

80106868 <vector57>:
.globl vector57
vector57:
  pushl $0
80106868:	6a 00                	push   $0x0
  pushl $57
8010686a:	6a 39                	push   $0x39
  jmp alltraps
8010686c:	e9 f1 f8 ff ff       	jmp    80106162 <alltraps>

80106871 <vector58>:
.globl vector58
vector58:
  pushl $0
80106871:	6a 00                	push   $0x0
  pushl $58
80106873:	6a 3a                	push   $0x3a
  jmp alltraps
80106875:	e9 e8 f8 ff ff       	jmp    80106162 <alltraps>

8010687a <vector59>:
.globl vector59
vector59:
  pushl $0
8010687a:	6a 00                	push   $0x0
  pushl $59
8010687c:	6a 3b                	push   $0x3b
  jmp alltraps
8010687e:	e9 df f8 ff ff       	jmp    80106162 <alltraps>

80106883 <vector60>:
.globl vector60
vector60:
  pushl $0
80106883:	6a 00                	push   $0x0
  pushl $60
80106885:	6a 3c                	push   $0x3c
  jmp alltraps
80106887:	e9 d6 f8 ff ff       	jmp    80106162 <alltraps>

8010688c <vector61>:
.globl vector61
vector61:
  pushl $0
8010688c:	6a 00                	push   $0x0
  pushl $61
8010688e:	6a 3d                	push   $0x3d
  jmp alltraps
80106890:	e9 cd f8 ff ff       	jmp    80106162 <alltraps>

80106895 <vector62>:
.globl vector62
vector62:
  pushl $0
80106895:	6a 00                	push   $0x0
  pushl $62
80106897:	6a 3e                	push   $0x3e
  jmp alltraps
80106899:	e9 c4 f8 ff ff       	jmp    80106162 <alltraps>

8010689e <vector63>:
.globl vector63
vector63:
  pushl $0
8010689e:	6a 00                	push   $0x0
  pushl $63
801068a0:	6a 3f                	push   $0x3f
  jmp alltraps
801068a2:	e9 bb f8 ff ff       	jmp    80106162 <alltraps>

801068a7 <vector64>:
.globl vector64
vector64:
  pushl $0
801068a7:	6a 00                	push   $0x0
  pushl $64
801068a9:	6a 40                	push   $0x40
  jmp alltraps
801068ab:	e9 b2 f8 ff ff       	jmp    80106162 <alltraps>

801068b0 <vector65>:
.globl vector65
vector65:
  pushl $0
801068b0:	6a 00                	push   $0x0
  pushl $65
801068b2:	6a 41                	push   $0x41
  jmp alltraps
801068b4:	e9 a9 f8 ff ff       	jmp    80106162 <alltraps>

801068b9 <vector66>:
.globl vector66
vector66:
  pushl $0
801068b9:	6a 00                	push   $0x0
  pushl $66
801068bb:	6a 42                	push   $0x42
  jmp alltraps
801068bd:	e9 a0 f8 ff ff       	jmp    80106162 <alltraps>

801068c2 <vector67>:
.globl vector67
vector67:
  pushl $0
801068c2:	6a 00                	push   $0x0
  pushl $67
801068c4:	6a 43                	push   $0x43
  jmp alltraps
801068c6:	e9 97 f8 ff ff       	jmp    80106162 <alltraps>

801068cb <vector68>:
.globl vector68
vector68:
  pushl $0
801068cb:	6a 00                	push   $0x0
  pushl $68
801068cd:	6a 44                	push   $0x44
  jmp alltraps
801068cf:	e9 8e f8 ff ff       	jmp    80106162 <alltraps>

801068d4 <vector69>:
.globl vector69
vector69:
  pushl $0
801068d4:	6a 00                	push   $0x0
  pushl $69
801068d6:	6a 45                	push   $0x45
  jmp alltraps
801068d8:	e9 85 f8 ff ff       	jmp    80106162 <alltraps>

801068dd <vector70>:
.globl vector70
vector70:
  pushl $0
801068dd:	6a 00                	push   $0x0
  pushl $70
801068df:	6a 46                	push   $0x46
  jmp alltraps
801068e1:	e9 7c f8 ff ff       	jmp    80106162 <alltraps>

801068e6 <vector71>:
.globl vector71
vector71:
  pushl $0
801068e6:	6a 00                	push   $0x0
  pushl $71
801068e8:	6a 47                	push   $0x47
  jmp alltraps
801068ea:	e9 73 f8 ff ff       	jmp    80106162 <alltraps>

801068ef <vector72>:
.globl vector72
vector72:
  pushl $0
801068ef:	6a 00                	push   $0x0
  pushl $72
801068f1:	6a 48                	push   $0x48
  jmp alltraps
801068f3:	e9 6a f8 ff ff       	jmp    80106162 <alltraps>

801068f8 <vector73>:
.globl vector73
vector73:
  pushl $0
801068f8:	6a 00                	push   $0x0
  pushl $73
801068fa:	6a 49                	push   $0x49
  jmp alltraps
801068fc:	e9 61 f8 ff ff       	jmp    80106162 <alltraps>

80106901 <vector74>:
.globl vector74
vector74:
  pushl $0
80106901:	6a 00                	push   $0x0
  pushl $74
80106903:	6a 4a                	push   $0x4a
  jmp alltraps
80106905:	e9 58 f8 ff ff       	jmp    80106162 <alltraps>

8010690a <vector75>:
.globl vector75
vector75:
  pushl $0
8010690a:	6a 00                	push   $0x0
  pushl $75
8010690c:	6a 4b                	push   $0x4b
  jmp alltraps
8010690e:	e9 4f f8 ff ff       	jmp    80106162 <alltraps>

80106913 <vector76>:
.globl vector76
vector76:
  pushl $0
80106913:	6a 00                	push   $0x0
  pushl $76
80106915:	6a 4c                	push   $0x4c
  jmp alltraps
80106917:	e9 46 f8 ff ff       	jmp    80106162 <alltraps>

8010691c <vector77>:
.globl vector77
vector77:
  pushl $0
8010691c:	6a 00                	push   $0x0
  pushl $77
8010691e:	6a 4d                	push   $0x4d
  jmp alltraps
80106920:	e9 3d f8 ff ff       	jmp    80106162 <alltraps>

80106925 <vector78>:
.globl vector78
vector78:
  pushl $0
80106925:	6a 00                	push   $0x0
  pushl $78
80106927:	6a 4e                	push   $0x4e
  jmp alltraps
80106929:	e9 34 f8 ff ff       	jmp    80106162 <alltraps>

8010692e <vector79>:
.globl vector79
vector79:
  pushl $0
8010692e:	6a 00                	push   $0x0
  pushl $79
80106930:	6a 4f                	push   $0x4f
  jmp alltraps
80106932:	e9 2b f8 ff ff       	jmp    80106162 <alltraps>

80106937 <vector80>:
.globl vector80
vector80:
  pushl $0
80106937:	6a 00                	push   $0x0
  pushl $80
80106939:	6a 50                	push   $0x50
  jmp alltraps
8010693b:	e9 22 f8 ff ff       	jmp    80106162 <alltraps>

80106940 <vector81>:
.globl vector81
vector81:
  pushl $0
80106940:	6a 00                	push   $0x0
  pushl $81
80106942:	6a 51                	push   $0x51
  jmp alltraps
80106944:	e9 19 f8 ff ff       	jmp    80106162 <alltraps>

80106949 <vector82>:
.globl vector82
vector82:
  pushl $0
80106949:	6a 00                	push   $0x0
  pushl $82
8010694b:	6a 52                	push   $0x52
  jmp alltraps
8010694d:	e9 10 f8 ff ff       	jmp    80106162 <alltraps>

80106952 <vector83>:
.globl vector83
vector83:
  pushl $0
80106952:	6a 00                	push   $0x0
  pushl $83
80106954:	6a 53                	push   $0x53
  jmp alltraps
80106956:	e9 07 f8 ff ff       	jmp    80106162 <alltraps>

8010695b <vector84>:
.globl vector84
vector84:
  pushl $0
8010695b:	6a 00                	push   $0x0
  pushl $84
8010695d:	6a 54                	push   $0x54
  jmp alltraps
8010695f:	e9 fe f7 ff ff       	jmp    80106162 <alltraps>

80106964 <vector85>:
.globl vector85
vector85:
  pushl $0
80106964:	6a 00                	push   $0x0
  pushl $85
80106966:	6a 55                	push   $0x55
  jmp alltraps
80106968:	e9 f5 f7 ff ff       	jmp    80106162 <alltraps>

8010696d <vector86>:
.globl vector86
vector86:
  pushl $0
8010696d:	6a 00                	push   $0x0
  pushl $86
8010696f:	6a 56                	push   $0x56
  jmp alltraps
80106971:	e9 ec f7 ff ff       	jmp    80106162 <alltraps>

80106976 <vector87>:
.globl vector87
vector87:
  pushl $0
80106976:	6a 00                	push   $0x0
  pushl $87
80106978:	6a 57                	push   $0x57
  jmp alltraps
8010697a:	e9 e3 f7 ff ff       	jmp    80106162 <alltraps>

8010697f <vector88>:
.globl vector88
vector88:
  pushl $0
8010697f:	6a 00                	push   $0x0
  pushl $88
80106981:	6a 58                	push   $0x58
  jmp alltraps
80106983:	e9 da f7 ff ff       	jmp    80106162 <alltraps>

80106988 <vector89>:
.globl vector89
vector89:
  pushl $0
80106988:	6a 00                	push   $0x0
  pushl $89
8010698a:	6a 59                	push   $0x59
  jmp alltraps
8010698c:	e9 d1 f7 ff ff       	jmp    80106162 <alltraps>

80106991 <vector90>:
.globl vector90
vector90:
  pushl $0
80106991:	6a 00                	push   $0x0
  pushl $90
80106993:	6a 5a                	push   $0x5a
  jmp alltraps
80106995:	e9 c8 f7 ff ff       	jmp    80106162 <alltraps>

8010699a <vector91>:
.globl vector91
vector91:
  pushl $0
8010699a:	6a 00                	push   $0x0
  pushl $91
8010699c:	6a 5b                	push   $0x5b
  jmp alltraps
8010699e:	e9 bf f7 ff ff       	jmp    80106162 <alltraps>

801069a3 <vector92>:
.globl vector92
vector92:
  pushl $0
801069a3:	6a 00                	push   $0x0
  pushl $92
801069a5:	6a 5c                	push   $0x5c
  jmp alltraps
801069a7:	e9 b6 f7 ff ff       	jmp    80106162 <alltraps>

801069ac <vector93>:
.globl vector93
vector93:
  pushl $0
801069ac:	6a 00                	push   $0x0
  pushl $93
801069ae:	6a 5d                	push   $0x5d
  jmp alltraps
801069b0:	e9 ad f7 ff ff       	jmp    80106162 <alltraps>

801069b5 <vector94>:
.globl vector94
vector94:
  pushl $0
801069b5:	6a 00                	push   $0x0
  pushl $94
801069b7:	6a 5e                	push   $0x5e
  jmp alltraps
801069b9:	e9 a4 f7 ff ff       	jmp    80106162 <alltraps>

801069be <vector95>:
.globl vector95
vector95:
  pushl $0
801069be:	6a 00                	push   $0x0
  pushl $95
801069c0:	6a 5f                	push   $0x5f
  jmp alltraps
801069c2:	e9 9b f7 ff ff       	jmp    80106162 <alltraps>

801069c7 <vector96>:
.globl vector96
vector96:
  pushl $0
801069c7:	6a 00                	push   $0x0
  pushl $96
801069c9:	6a 60                	push   $0x60
  jmp alltraps
801069cb:	e9 92 f7 ff ff       	jmp    80106162 <alltraps>

801069d0 <vector97>:
.globl vector97
vector97:
  pushl $0
801069d0:	6a 00                	push   $0x0
  pushl $97
801069d2:	6a 61                	push   $0x61
  jmp alltraps
801069d4:	e9 89 f7 ff ff       	jmp    80106162 <alltraps>

801069d9 <vector98>:
.globl vector98
vector98:
  pushl $0
801069d9:	6a 00                	push   $0x0
  pushl $98
801069db:	6a 62                	push   $0x62
  jmp alltraps
801069dd:	e9 80 f7 ff ff       	jmp    80106162 <alltraps>

801069e2 <vector99>:
.globl vector99
vector99:
  pushl $0
801069e2:	6a 00                	push   $0x0
  pushl $99
801069e4:	6a 63                	push   $0x63
  jmp alltraps
801069e6:	e9 77 f7 ff ff       	jmp    80106162 <alltraps>

801069eb <vector100>:
.globl vector100
vector100:
  pushl $0
801069eb:	6a 00                	push   $0x0
  pushl $100
801069ed:	6a 64                	push   $0x64
  jmp alltraps
801069ef:	e9 6e f7 ff ff       	jmp    80106162 <alltraps>

801069f4 <vector101>:
.globl vector101
vector101:
  pushl $0
801069f4:	6a 00                	push   $0x0
  pushl $101
801069f6:	6a 65                	push   $0x65
  jmp alltraps
801069f8:	e9 65 f7 ff ff       	jmp    80106162 <alltraps>

801069fd <vector102>:
.globl vector102
vector102:
  pushl $0
801069fd:	6a 00                	push   $0x0
  pushl $102
801069ff:	6a 66                	push   $0x66
  jmp alltraps
80106a01:	e9 5c f7 ff ff       	jmp    80106162 <alltraps>

80106a06 <vector103>:
.globl vector103
vector103:
  pushl $0
80106a06:	6a 00                	push   $0x0
  pushl $103
80106a08:	6a 67                	push   $0x67
  jmp alltraps
80106a0a:	e9 53 f7 ff ff       	jmp    80106162 <alltraps>

80106a0f <vector104>:
.globl vector104
vector104:
  pushl $0
80106a0f:	6a 00                	push   $0x0
  pushl $104
80106a11:	6a 68                	push   $0x68
  jmp alltraps
80106a13:	e9 4a f7 ff ff       	jmp    80106162 <alltraps>

80106a18 <vector105>:
.globl vector105
vector105:
  pushl $0
80106a18:	6a 00                	push   $0x0
  pushl $105
80106a1a:	6a 69                	push   $0x69
  jmp alltraps
80106a1c:	e9 41 f7 ff ff       	jmp    80106162 <alltraps>

80106a21 <vector106>:
.globl vector106
vector106:
  pushl $0
80106a21:	6a 00                	push   $0x0
  pushl $106
80106a23:	6a 6a                	push   $0x6a
  jmp alltraps
80106a25:	e9 38 f7 ff ff       	jmp    80106162 <alltraps>

80106a2a <vector107>:
.globl vector107
vector107:
  pushl $0
80106a2a:	6a 00                	push   $0x0
  pushl $107
80106a2c:	6a 6b                	push   $0x6b
  jmp alltraps
80106a2e:	e9 2f f7 ff ff       	jmp    80106162 <alltraps>

80106a33 <vector108>:
.globl vector108
vector108:
  pushl $0
80106a33:	6a 00                	push   $0x0
  pushl $108
80106a35:	6a 6c                	push   $0x6c
  jmp alltraps
80106a37:	e9 26 f7 ff ff       	jmp    80106162 <alltraps>

80106a3c <vector109>:
.globl vector109
vector109:
  pushl $0
80106a3c:	6a 00                	push   $0x0
  pushl $109
80106a3e:	6a 6d                	push   $0x6d
  jmp alltraps
80106a40:	e9 1d f7 ff ff       	jmp    80106162 <alltraps>

80106a45 <vector110>:
.globl vector110
vector110:
  pushl $0
80106a45:	6a 00                	push   $0x0
  pushl $110
80106a47:	6a 6e                	push   $0x6e
  jmp alltraps
80106a49:	e9 14 f7 ff ff       	jmp    80106162 <alltraps>

80106a4e <vector111>:
.globl vector111
vector111:
  pushl $0
80106a4e:	6a 00                	push   $0x0
  pushl $111
80106a50:	6a 6f                	push   $0x6f
  jmp alltraps
80106a52:	e9 0b f7 ff ff       	jmp    80106162 <alltraps>

80106a57 <vector112>:
.globl vector112
vector112:
  pushl $0
80106a57:	6a 00                	push   $0x0
  pushl $112
80106a59:	6a 70                	push   $0x70
  jmp alltraps
80106a5b:	e9 02 f7 ff ff       	jmp    80106162 <alltraps>

80106a60 <vector113>:
.globl vector113
vector113:
  pushl $0
80106a60:	6a 00                	push   $0x0
  pushl $113
80106a62:	6a 71                	push   $0x71
  jmp alltraps
80106a64:	e9 f9 f6 ff ff       	jmp    80106162 <alltraps>

80106a69 <vector114>:
.globl vector114
vector114:
  pushl $0
80106a69:	6a 00                	push   $0x0
  pushl $114
80106a6b:	6a 72                	push   $0x72
  jmp alltraps
80106a6d:	e9 f0 f6 ff ff       	jmp    80106162 <alltraps>

80106a72 <vector115>:
.globl vector115
vector115:
  pushl $0
80106a72:	6a 00                	push   $0x0
  pushl $115
80106a74:	6a 73                	push   $0x73
  jmp alltraps
80106a76:	e9 e7 f6 ff ff       	jmp    80106162 <alltraps>

80106a7b <vector116>:
.globl vector116
vector116:
  pushl $0
80106a7b:	6a 00                	push   $0x0
  pushl $116
80106a7d:	6a 74                	push   $0x74
  jmp alltraps
80106a7f:	e9 de f6 ff ff       	jmp    80106162 <alltraps>

80106a84 <vector117>:
.globl vector117
vector117:
  pushl $0
80106a84:	6a 00                	push   $0x0
  pushl $117
80106a86:	6a 75                	push   $0x75
  jmp alltraps
80106a88:	e9 d5 f6 ff ff       	jmp    80106162 <alltraps>

80106a8d <vector118>:
.globl vector118
vector118:
  pushl $0
80106a8d:	6a 00                	push   $0x0
  pushl $118
80106a8f:	6a 76                	push   $0x76
  jmp alltraps
80106a91:	e9 cc f6 ff ff       	jmp    80106162 <alltraps>

80106a96 <vector119>:
.globl vector119
vector119:
  pushl $0
80106a96:	6a 00                	push   $0x0
  pushl $119
80106a98:	6a 77                	push   $0x77
  jmp alltraps
80106a9a:	e9 c3 f6 ff ff       	jmp    80106162 <alltraps>

80106a9f <vector120>:
.globl vector120
vector120:
  pushl $0
80106a9f:	6a 00                	push   $0x0
  pushl $120
80106aa1:	6a 78                	push   $0x78
  jmp alltraps
80106aa3:	e9 ba f6 ff ff       	jmp    80106162 <alltraps>

80106aa8 <vector121>:
.globl vector121
vector121:
  pushl $0
80106aa8:	6a 00                	push   $0x0
  pushl $121
80106aaa:	6a 79                	push   $0x79
  jmp alltraps
80106aac:	e9 b1 f6 ff ff       	jmp    80106162 <alltraps>

80106ab1 <vector122>:
.globl vector122
vector122:
  pushl $0
80106ab1:	6a 00                	push   $0x0
  pushl $122
80106ab3:	6a 7a                	push   $0x7a
  jmp alltraps
80106ab5:	e9 a8 f6 ff ff       	jmp    80106162 <alltraps>

80106aba <vector123>:
.globl vector123
vector123:
  pushl $0
80106aba:	6a 00                	push   $0x0
  pushl $123
80106abc:	6a 7b                	push   $0x7b
  jmp alltraps
80106abe:	e9 9f f6 ff ff       	jmp    80106162 <alltraps>

80106ac3 <vector124>:
.globl vector124
vector124:
  pushl $0
80106ac3:	6a 00                	push   $0x0
  pushl $124
80106ac5:	6a 7c                	push   $0x7c
  jmp alltraps
80106ac7:	e9 96 f6 ff ff       	jmp    80106162 <alltraps>

80106acc <vector125>:
.globl vector125
vector125:
  pushl $0
80106acc:	6a 00                	push   $0x0
  pushl $125
80106ace:	6a 7d                	push   $0x7d
  jmp alltraps
80106ad0:	e9 8d f6 ff ff       	jmp    80106162 <alltraps>

80106ad5 <vector126>:
.globl vector126
vector126:
  pushl $0
80106ad5:	6a 00                	push   $0x0
  pushl $126
80106ad7:	6a 7e                	push   $0x7e
  jmp alltraps
80106ad9:	e9 84 f6 ff ff       	jmp    80106162 <alltraps>

80106ade <vector127>:
.globl vector127
vector127:
  pushl $0
80106ade:	6a 00                	push   $0x0
  pushl $127
80106ae0:	6a 7f                	push   $0x7f
  jmp alltraps
80106ae2:	e9 7b f6 ff ff       	jmp    80106162 <alltraps>

80106ae7 <vector128>:
.globl vector128
vector128:
  pushl $0
80106ae7:	6a 00                	push   $0x0
  pushl $128
80106ae9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
80106aee:	e9 6f f6 ff ff       	jmp    80106162 <alltraps>

80106af3 <vector129>:
.globl vector129
vector129:
  pushl $0
80106af3:	6a 00                	push   $0x0
  pushl $129
80106af5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106afa:	e9 63 f6 ff ff       	jmp    80106162 <alltraps>

80106aff <vector130>:
.globl vector130
vector130:
  pushl $0
80106aff:	6a 00                	push   $0x0
  pushl $130
80106b01:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106b06:	e9 57 f6 ff ff       	jmp    80106162 <alltraps>

80106b0b <vector131>:
.globl vector131
vector131:
  pushl $0
80106b0b:	6a 00                	push   $0x0
  pushl $131
80106b0d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106b12:	e9 4b f6 ff ff       	jmp    80106162 <alltraps>

80106b17 <vector132>:
.globl vector132
vector132:
  pushl $0
80106b17:	6a 00                	push   $0x0
  pushl $132
80106b19:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80106b1e:	e9 3f f6 ff ff       	jmp    80106162 <alltraps>

80106b23 <vector133>:
.globl vector133
vector133:
  pushl $0
80106b23:	6a 00                	push   $0x0
  pushl $133
80106b25:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106b2a:	e9 33 f6 ff ff       	jmp    80106162 <alltraps>

80106b2f <vector134>:
.globl vector134
vector134:
  pushl $0
80106b2f:	6a 00                	push   $0x0
  pushl $134
80106b31:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106b36:	e9 27 f6 ff ff       	jmp    80106162 <alltraps>

80106b3b <vector135>:
.globl vector135
vector135:
  pushl $0
80106b3b:	6a 00                	push   $0x0
  pushl $135
80106b3d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106b42:	e9 1b f6 ff ff       	jmp    80106162 <alltraps>

80106b47 <vector136>:
.globl vector136
vector136:
  pushl $0
80106b47:	6a 00                	push   $0x0
  pushl $136
80106b49:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80106b4e:	e9 0f f6 ff ff       	jmp    80106162 <alltraps>

80106b53 <vector137>:
.globl vector137
vector137:
  pushl $0
80106b53:	6a 00                	push   $0x0
  pushl $137
80106b55:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80106b5a:	e9 03 f6 ff ff       	jmp    80106162 <alltraps>

80106b5f <vector138>:
.globl vector138
vector138:
  pushl $0
80106b5f:	6a 00                	push   $0x0
  pushl $138
80106b61:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106b66:	e9 f7 f5 ff ff       	jmp    80106162 <alltraps>

80106b6b <vector139>:
.globl vector139
vector139:
  pushl $0
80106b6b:	6a 00                	push   $0x0
  pushl $139
80106b6d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106b72:	e9 eb f5 ff ff       	jmp    80106162 <alltraps>

80106b77 <vector140>:
.globl vector140
vector140:
  pushl $0
80106b77:	6a 00                	push   $0x0
  pushl $140
80106b79:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80106b7e:	e9 df f5 ff ff       	jmp    80106162 <alltraps>

80106b83 <vector141>:
.globl vector141
vector141:
  pushl $0
80106b83:	6a 00                	push   $0x0
  pushl $141
80106b85:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80106b8a:	e9 d3 f5 ff ff       	jmp    80106162 <alltraps>

80106b8f <vector142>:
.globl vector142
vector142:
  pushl $0
80106b8f:	6a 00                	push   $0x0
  pushl $142
80106b91:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106b96:	e9 c7 f5 ff ff       	jmp    80106162 <alltraps>

80106b9b <vector143>:
.globl vector143
vector143:
  pushl $0
80106b9b:	6a 00                	push   $0x0
  pushl $143
80106b9d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106ba2:	e9 bb f5 ff ff       	jmp    80106162 <alltraps>

80106ba7 <vector144>:
.globl vector144
vector144:
  pushl $0
80106ba7:	6a 00                	push   $0x0
  pushl $144
80106ba9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80106bae:	e9 af f5 ff ff       	jmp    80106162 <alltraps>

80106bb3 <vector145>:
.globl vector145
vector145:
  pushl $0
80106bb3:	6a 00                	push   $0x0
  pushl $145
80106bb5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106bba:	e9 a3 f5 ff ff       	jmp    80106162 <alltraps>

80106bbf <vector146>:
.globl vector146
vector146:
  pushl $0
80106bbf:	6a 00                	push   $0x0
  pushl $146
80106bc1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106bc6:	e9 97 f5 ff ff       	jmp    80106162 <alltraps>

80106bcb <vector147>:
.globl vector147
vector147:
  pushl $0
80106bcb:	6a 00                	push   $0x0
  pushl $147
80106bcd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106bd2:	e9 8b f5 ff ff       	jmp    80106162 <alltraps>

80106bd7 <vector148>:
.globl vector148
vector148:
  pushl $0
80106bd7:	6a 00                	push   $0x0
  pushl $148
80106bd9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80106bde:	e9 7f f5 ff ff       	jmp    80106162 <alltraps>

80106be3 <vector149>:
.globl vector149
vector149:
  pushl $0
80106be3:	6a 00                	push   $0x0
  pushl $149
80106be5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106bea:	e9 73 f5 ff ff       	jmp    80106162 <alltraps>

80106bef <vector150>:
.globl vector150
vector150:
  pushl $0
80106bef:	6a 00                	push   $0x0
  pushl $150
80106bf1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106bf6:	e9 67 f5 ff ff       	jmp    80106162 <alltraps>

80106bfb <vector151>:
.globl vector151
vector151:
  pushl $0
80106bfb:	6a 00                	push   $0x0
  pushl $151
80106bfd:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106c02:	e9 5b f5 ff ff       	jmp    80106162 <alltraps>

80106c07 <vector152>:
.globl vector152
vector152:
  pushl $0
80106c07:	6a 00                	push   $0x0
  pushl $152
80106c09:	68 98 00 00 00       	push   $0x98
  jmp alltraps
80106c0e:	e9 4f f5 ff ff       	jmp    80106162 <alltraps>

80106c13 <vector153>:
.globl vector153
vector153:
  pushl $0
80106c13:	6a 00                	push   $0x0
  pushl $153
80106c15:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106c1a:	e9 43 f5 ff ff       	jmp    80106162 <alltraps>

80106c1f <vector154>:
.globl vector154
vector154:
  pushl $0
80106c1f:	6a 00                	push   $0x0
  pushl $154
80106c21:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106c26:	e9 37 f5 ff ff       	jmp    80106162 <alltraps>

80106c2b <vector155>:
.globl vector155
vector155:
  pushl $0
80106c2b:	6a 00                	push   $0x0
  pushl $155
80106c2d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106c32:	e9 2b f5 ff ff       	jmp    80106162 <alltraps>

80106c37 <vector156>:
.globl vector156
vector156:
  pushl $0
80106c37:	6a 00                	push   $0x0
  pushl $156
80106c39:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80106c3e:	e9 1f f5 ff ff       	jmp    80106162 <alltraps>

80106c43 <vector157>:
.globl vector157
vector157:
  pushl $0
80106c43:	6a 00                	push   $0x0
  pushl $157
80106c45:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106c4a:	e9 13 f5 ff ff       	jmp    80106162 <alltraps>

80106c4f <vector158>:
.globl vector158
vector158:
  pushl $0
80106c4f:	6a 00                	push   $0x0
  pushl $158
80106c51:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106c56:	e9 07 f5 ff ff       	jmp    80106162 <alltraps>

80106c5b <vector159>:
.globl vector159
vector159:
  pushl $0
80106c5b:	6a 00                	push   $0x0
  pushl $159
80106c5d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106c62:	e9 fb f4 ff ff       	jmp    80106162 <alltraps>

80106c67 <vector160>:
.globl vector160
vector160:
  pushl $0
80106c67:	6a 00                	push   $0x0
  pushl $160
80106c69:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80106c6e:	e9 ef f4 ff ff       	jmp    80106162 <alltraps>

80106c73 <vector161>:
.globl vector161
vector161:
  pushl $0
80106c73:	6a 00                	push   $0x0
  pushl $161
80106c75:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80106c7a:	e9 e3 f4 ff ff       	jmp    80106162 <alltraps>

80106c7f <vector162>:
.globl vector162
vector162:
  pushl $0
80106c7f:	6a 00                	push   $0x0
  pushl $162
80106c81:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106c86:	e9 d7 f4 ff ff       	jmp    80106162 <alltraps>

80106c8b <vector163>:
.globl vector163
vector163:
  pushl $0
80106c8b:	6a 00                	push   $0x0
  pushl $163
80106c8d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106c92:	e9 cb f4 ff ff       	jmp    80106162 <alltraps>

80106c97 <vector164>:
.globl vector164
vector164:
  pushl $0
80106c97:	6a 00                	push   $0x0
  pushl $164
80106c99:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80106c9e:	e9 bf f4 ff ff       	jmp    80106162 <alltraps>

80106ca3 <vector165>:
.globl vector165
vector165:
  pushl $0
80106ca3:	6a 00                	push   $0x0
  pushl $165
80106ca5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80106caa:	e9 b3 f4 ff ff       	jmp    80106162 <alltraps>

80106caf <vector166>:
.globl vector166
vector166:
  pushl $0
80106caf:	6a 00                	push   $0x0
  pushl $166
80106cb1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106cb6:	e9 a7 f4 ff ff       	jmp    80106162 <alltraps>

80106cbb <vector167>:
.globl vector167
vector167:
  pushl $0
80106cbb:	6a 00                	push   $0x0
  pushl $167
80106cbd:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106cc2:	e9 9b f4 ff ff       	jmp    80106162 <alltraps>

80106cc7 <vector168>:
.globl vector168
vector168:
  pushl $0
80106cc7:	6a 00                	push   $0x0
  pushl $168
80106cc9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80106cce:	e9 8f f4 ff ff       	jmp    80106162 <alltraps>

80106cd3 <vector169>:
.globl vector169
vector169:
  pushl $0
80106cd3:	6a 00                	push   $0x0
  pushl $169
80106cd5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106cda:	e9 83 f4 ff ff       	jmp    80106162 <alltraps>

80106cdf <vector170>:
.globl vector170
vector170:
  pushl $0
80106cdf:	6a 00                	push   $0x0
  pushl $170
80106ce1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106ce6:	e9 77 f4 ff ff       	jmp    80106162 <alltraps>

80106ceb <vector171>:
.globl vector171
vector171:
  pushl $0
80106ceb:	6a 00                	push   $0x0
  pushl $171
80106ced:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106cf2:	e9 6b f4 ff ff       	jmp    80106162 <alltraps>

80106cf7 <vector172>:
.globl vector172
vector172:
  pushl $0
80106cf7:	6a 00                	push   $0x0
  pushl $172
80106cf9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80106cfe:	e9 5f f4 ff ff       	jmp    80106162 <alltraps>

80106d03 <vector173>:
.globl vector173
vector173:
  pushl $0
80106d03:	6a 00                	push   $0x0
  pushl $173
80106d05:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106d0a:	e9 53 f4 ff ff       	jmp    80106162 <alltraps>

80106d0f <vector174>:
.globl vector174
vector174:
  pushl $0
80106d0f:	6a 00                	push   $0x0
  pushl $174
80106d11:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106d16:	e9 47 f4 ff ff       	jmp    80106162 <alltraps>

80106d1b <vector175>:
.globl vector175
vector175:
  pushl $0
80106d1b:	6a 00                	push   $0x0
  pushl $175
80106d1d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106d22:	e9 3b f4 ff ff       	jmp    80106162 <alltraps>

80106d27 <vector176>:
.globl vector176
vector176:
  pushl $0
80106d27:	6a 00                	push   $0x0
  pushl $176
80106d29:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80106d2e:	e9 2f f4 ff ff       	jmp    80106162 <alltraps>

80106d33 <vector177>:
.globl vector177
vector177:
  pushl $0
80106d33:	6a 00                	push   $0x0
  pushl $177
80106d35:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106d3a:	e9 23 f4 ff ff       	jmp    80106162 <alltraps>

80106d3f <vector178>:
.globl vector178
vector178:
  pushl $0
80106d3f:	6a 00                	push   $0x0
  pushl $178
80106d41:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106d46:	e9 17 f4 ff ff       	jmp    80106162 <alltraps>

80106d4b <vector179>:
.globl vector179
vector179:
  pushl $0
80106d4b:	6a 00                	push   $0x0
  pushl $179
80106d4d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106d52:	e9 0b f4 ff ff       	jmp    80106162 <alltraps>

80106d57 <vector180>:
.globl vector180
vector180:
  pushl $0
80106d57:	6a 00                	push   $0x0
  pushl $180
80106d59:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80106d5e:	e9 ff f3 ff ff       	jmp    80106162 <alltraps>

80106d63 <vector181>:
.globl vector181
vector181:
  pushl $0
80106d63:	6a 00                	push   $0x0
  pushl $181
80106d65:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80106d6a:	e9 f3 f3 ff ff       	jmp    80106162 <alltraps>

80106d6f <vector182>:
.globl vector182
vector182:
  pushl $0
80106d6f:	6a 00                	push   $0x0
  pushl $182
80106d71:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106d76:	e9 e7 f3 ff ff       	jmp    80106162 <alltraps>

80106d7b <vector183>:
.globl vector183
vector183:
  pushl $0
80106d7b:	6a 00                	push   $0x0
  pushl $183
80106d7d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106d82:	e9 db f3 ff ff       	jmp    80106162 <alltraps>

80106d87 <vector184>:
.globl vector184
vector184:
  pushl $0
80106d87:	6a 00                	push   $0x0
  pushl $184
80106d89:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80106d8e:	e9 cf f3 ff ff       	jmp    80106162 <alltraps>

80106d93 <vector185>:
.globl vector185
vector185:
  pushl $0
80106d93:	6a 00                	push   $0x0
  pushl $185
80106d95:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80106d9a:	e9 c3 f3 ff ff       	jmp    80106162 <alltraps>

80106d9f <vector186>:
.globl vector186
vector186:
  pushl $0
80106d9f:	6a 00                	push   $0x0
  pushl $186
80106da1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106da6:	e9 b7 f3 ff ff       	jmp    80106162 <alltraps>

80106dab <vector187>:
.globl vector187
vector187:
  pushl $0
80106dab:	6a 00                	push   $0x0
  pushl $187
80106dad:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106db2:	e9 ab f3 ff ff       	jmp    80106162 <alltraps>

80106db7 <vector188>:
.globl vector188
vector188:
  pushl $0
80106db7:	6a 00                	push   $0x0
  pushl $188
80106db9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80106dbe:	e9 9f f3 ff ff       	jmp    80106162 <alltraps>

80106dc3 <vector189>:
.globl vector189
vector189:
  pushl $0
80106dc3:	6a 00                	push   $0x0
  pushl $189
80106dc5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106dca:	e9 93 f3 ff ff       	jmp    80106162 <alltraps>

80106dcf <vector190>:
.globl vector190
vector190:
  pushl $0
80106dcf:	6a 00                	push   $0x0
  pushl $190
80106dd1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106dd6:	e9 87 f3 ff ff       	jmp    80106162 <alltraps>

80106ddb <vector191>:
.globl vector191
vector191:
  pushl $0
80106ddb:	6a 00                	push   $0x0
  pushl $191
80106ddd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106de2:	e9 7b f3 ff ff       	jmp    80106162 <alltraps>

80106de7 <vector192>:
.globl vector192
vector192:
  pushl $0
80106de7:	6a 00                	push   $0x0
  pushl $192
80106de9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106dee:	e9 6f f3 ff ff       	jmp    80106162 <alltraps>

80106df3 <vector193>:
.globl vector193
vector193:
  pushl $0
80106df3:	6a 00                	push   $0x0
  pushl $193
80106df5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106dfa:	e9 63 f3 ff ff       	jmp    80106162 <alltraps>

80106dff <vector194>:
.globl vector194
vector194:
  pushl $0
80106dff:	6a 00                	push   $0x0
  pushl $194
80106e01:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106e06:	e9 57 f3 ff ff       	jmp    80106162 <alltraps>

80106e0b <vector195>:
.globl vector195
vector195:
  pushl $0
80106e0b:	6a 00                	push   $0x0
  pushl $195
80106e0d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106e12:	e9 4b f3 ff ff       	jmp    80106162 <alltraps>

80106e17 <vector196>:
.globl vector196
vector196:
  pushl $0
80106e17:	6a 00                	push   $0x0
  pushl $196
80106e19:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106e1e:	e9 3f f3 ff ff       	jmp    80106162 <alltraps>

80106e23 <vector197>:
.globl vector197
vector197:
  pushl $0
80106e23:	6a 00                	push   $0x0
  pushl $197
80106e25:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106e2a:	e9 33 f3 ff ff       	jmp    80106162 <alltraps>

80106e2f <vector198>:
.globl vector198
vector198:
  pushl $0
80106e2f:	6a 00                	push   $0x0
  pushl $198
80106e31:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106e36:	e9 27 f3 ff ff       	jmp    80106162 <alltraps>

80106e3b <vector199>:
.globl vector199
vector199:
  pushl $0
80106e3b:	6a 00                	push   $0x0
  pushl $199
80106e3d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106e42:	e9 1b f3 ff ff       	jmp    80106162 <alltraps>

80106e47 <vector200>:
.globl vector200
vector200:
  pushl $0
80106e47:	6a 00                	push   $0x0
  pushl $200
80106e49:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106e4e:	e9 0f f3 ff ff       	jmp    80106162 <alltraps>

80106e53 <vector201>:
.globl vector201
vector201:
  pushl $0
80106e53:	6a 00                	push   $0x0
  pushl $201
80106e55:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106e5a:	e9 03 f3 ff ff       	jmp    80106162 <alltraps>

80106e5f <vector202>:
.globl vector202
vector202:
  pushl $0
80106e5f:	6a 00                	push   $0x0
  pushl $202
80106e61:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106e66:	e9 f7 f2 ff ff       	jmp    80106162 <alltraps>

80106e6b <vector203>:
.globl vector203
vector203:
  pushl $0
80106e6b:	6a 00                	push   $0x0
  pushl $203
80106e6d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106e72:	e9 eb f2 ff ff       	jmp    80106162 <alltraps>

80106e77 <vector204>:
.globl vector204
vector204:
  pushl $0
80106e77:	6a 00                	push   $0x0
  pushl $204
80106e79:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106e7e:	e9 df f2 ff ff       	jmp    80106162 <alltraps>

80106e83 <vector205>:
.globl vector205
vector205:
  pushl $0
80106e83:	6a 00                	push   $0x0
  pushl $205
80106e85:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106e8a:	e9 d3 f2 ff ff       	jmp    80106162 <alltraps>

80106e8f <vector206>:
.globl vector206
vector206:
  pushl $0
80106e8f:	6a 00                	push   $0x0
  pushl $206
80106e91:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106e96:	e9 c7 f2 ff ff       	jmp    80106162 <alltraps>

80106e9b <vector207>:
.globl vector207
vector207:
  pushl $0
80106e9b:	6a 00                	push   $0x0
  pushl $207
80106e9d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ea2:	e9 bb f2 ff ff       	jmp    80106162 <alltraps>

80106ea7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106ea7:	6a 00                	push   $0x0
  pushl $208
80106ea9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106eae:	e9 af f2 ff ff       	jmp    80106162 <alltraps>

80106eb3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106eb3:	6a 00                	push   $0x0
  pushl $209
80106eb5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106eba:	e9 a3 f2 ff ff       	jmp    80106162 <alltraps>

80106ebf <vector210>:
.globl vector210
vector210:
  pushl $0
80106ebf:	6a 00                	push   $0x0
  pushl $210
80106ec1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106ec6:	e9 97 f2 ff ff       	jmp    80106162 <alltraps>

80106ecb <vector211>:
.globl vector211
vector211:
  pushl $0
80106ecb:	6a 00                	push   $0x0
  pushl $211
80106ecd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106ed2:	e9 8b f2 ff ff       	jmp    80106162 <alltraps>

80106ed7 <vector212>:
.globl vector212
vector212:
  pushl $0
80106ed7:	6a 00                	push   $0x0
  pushl $212
80106ed9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106ede:	e9 7f f2 ff ff       	jmp    80106162 <alltraps>

80106ee3 <vector213>:
.globl vector213
vector213:
  pushl $0
80106ee3:	6a 00                	push   $0x0
  pushl $213
80106ee5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106eea:	e9 73 f2 ff ff       	jmp    80106162 <alltraps>

80106eef <vector214>:
.globl vector214
vector214:
  pushl $0
80106eef:	6a 00                	push   $0x0
  pushl $214
80106ef1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106ef6:	e9 67 f2 ff ff       	jmp    80106162 <alltraps>

80106efb <vector215>:
.globl vector215
vector215:
  pushl $0
80106efb:	6a 00                	push   $0x0
  pushl $215
80106efd:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106f02:	e9 5b f2 ff ff       	jmp    80106162 <alltraps>

80106f07 <vector216>:
.globl vector216
vector216:
  pushl $0
80106f07:	6a 00                	push   $0x0
  pushl $216
80106f09:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106f0e:	e9 4f f2 ff ff       	jmp    80106162 <alltraps>

80106f13 <vector217>:
.globl vector217
vector217:
  pushl $0
80106f13:	6a 00                	push   $0x0
  pushl $217
80106f15:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106f1a:	e9 43 f2 ff ff       	jmp    80106162 <alltraps>

80106f1f <vector218>:
.globl vector218
vector218:
  pushl $0
80106f1f:	6a 00                	push   $0x0
  pushl $218
80106f21:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106f26:	e9 37 f2 ff ff       	jmp    80106162 <alltraps>

80106f2b <vector219>:
.globl vector219
vector219:
  pushl $0
80106f2b:	6a 00                	push   $0x0
  pushl $219
80106f2d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106f32:	e9 2b f2 ff ff       	jmp    80106162 <alltraps>

80106f37 <vector220>:
.globl vector220
vector220:
  pushl $0
80106f37:	6a 00                	push   $0x0
  pushl $220
80106f39:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106f3e:	e9 1f f2 ff ff       	jmp    80106162 <alltraps>

80106f43 <vector221>:
.globl vector221
vector221:
  pushl $0
80106f43:	6a 00                	push   $0x0
  pushl $221
80106f45:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106f4a:	e9 13 f2 ff ff       	jmp    80106162 <alltraps>

80106f4f <vector222>:
.globl vector222
vector222:
  pushl $0
80106f4f:	6a 00                	push   $0x0
  pushl $222
80106f51:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106f56:	e9 07 f2 ff ff       	jmp    80106162 <alltraps>

80106f5b <vector223>:
.globl vector223
vector223:
  pushl $0
80106f5b:	6a 00                	push   $0x0
  pushl $223
80106f5d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106f62:	e9 fb f1 ff ff       	jmp    80106162 <alltraps>

80106f67 <vector224>:
.globl vector224
vector224:
  pushl $0
80106f67:	6a 00                	push   $0x0
  pushl $224
80106f69:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106f6e:	e9 ef f1 ff ff       	jmp    80106162 <alltraps>

80106f73 <vector225>:
.globl vector225
vector225:
  pushl $0
80106f73:	6a 00                	push   $0x0
  pushl $225
80106f75:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106f7a:	e9 e3 f1 ff ff       	jmp    80106162 <alltraps>

80106f7f <vector226>:
.globl vector226
vector226:
  pushl $0
80106f7f:	6a 00                	push   $0x0
  pushl $226
80106f81:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106f86:	e9 d7 f1 ff ff       	jmp    80106162 <alltraps>

80106f8b <vector227>:
.globl vector227
vector227:
  pushl $0
80106f8b:	6a 00                	push   $0x0
  pushl $227
80106f8d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106f92:	e9 cb f1 ff ff       	jmp    80106162 <alltraps>

80106f97 <vector228>:
.globl vector228
vector228:
  pushl $0
80106f97:	6a 00                	push   $0x0
  pushl $228
80106f99:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106f9e:	e9 bf f1 ff ff       	jmp    80106162 <alltraps>

80106fa3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106fa3:	6a 00                	push   $0x0
  pushl $229
80106fa5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106faa:	e9 b3 f1 ff ff       	jmp    80106162 <alltraps>

80106faf <vector230>:
.globl vector230
vector230:
  pushl $0
80106faf:	6a 00                	push   $0x0
  pushl $230
80106fb1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106fb6:	e9 a7 f1 ff ff       	jmp    80106162 <alltraps>

80106fbb <vector231>:
.globl vector231
vector231:
  pushl $0
80106fbb:	6a 00                	push   $0x0
  pushl $231
80106fbd:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106fc2:	e9 9b f1 ff ff       	jmp    80106162 <alltraps>

80106fc7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106fc7:	6a 00                	push   $0x0
  pushl $232
80106fc9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106fce:	e9 8f f1 ff ff       	jmp    80106162 <alltraps>

80106fd3 <vector233>:
.globl vector233
vector233:
  pushl $0
80106fd3:	6a 00                	push   $0x0
  pushl $233
80106fd5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106fda:	e9 83 f1 ff ff       	jmp    80106162 <alltraps>

80106fdf <vector234>:
.globl vector234
vector234:
  pushl $0
80106fdf:	6a 00                	push   $0x0
  pushl $234
80106fe1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106fe6:	e9 77 f1 ff ff       	jmp    80106162 <alltraps>

80106feb <vector235>:
.globl vector235
vector235:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $235
80106fed:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106ff2:	e9 6b f1 ff ff       	jmp    80106162 <alltraps>

80106ff7 <vector236>:
.globl vector236
vector236:
  pushl $0
80106ff7:	6a 00                	push   $0x0
  pushl $236
80106ff9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106ffe:	e9 5f f1 ff ff       	jmp    80106162 <alltraps>

80107003 <vector237>:
.globl vector237
vector237:
  pushl $0
80107003:	6a 00                	push   $0x0
  pushl $237
80107005:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
8010700a:	e9 53 f1 ff ff       	jmp    80106162 <alltraps>

8010700f <vector238>:
.globl vector238
vector238:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $238
80107011:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107016:	e9 47 f1 ff ff       	jmp    80106162 <alltraps>

8010701b <vector239>:
.globl vector239
vector239:
  pushl $0
8010701b:	6a 00                	push   $0x0
  pushl $239
8010701d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107022:	e9 3b f1 ff ff       	jmp    80106162 <alltraps>

80107027 <vector240>:
.globl vector240
vector240:
  pushl $0
80107027:	6a 00                	push   $0x0
  pushl $240
80107029:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010702e:	e9 2f f1 ff ff       	jmp    80106162 <alltraps>

80107033 <vector241>:
.globl vector241
vector241:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $241
80107035:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010703a:	e9 23 f1 ff ff       	jmp    80106162 <alltraps>

8010703f <vector242>:
.globl vector242
vector242:
  pushl $0
8010703f:	6a 00                	push   $0x0
  pushl $242
80107041:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107046:	e9 17 f1 ff ff       	jmp    80106162 <alltraps>

8010704b <vector243>:
.globl vector243
vector243:
  pushl $0
8010704b:	6a 00                	push   $0x0
  pushl $243
8010704d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107052:	e9 0b f1 ff ff       	jmp    80106162 <alltraps>

80107057 <vector244>:
.globl vector244
vector244:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $244
80107059:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010705e:	e9 ff f0 ff ff       	jmp    80106162 <alltraps>

80107063 <vector245>:
.globl vector245
vector245:
  pushl $0
80107063:	6a 00                	push   $0x0
  pushl $245
80107065:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010706a:	e9 f3 f0 ff ff       	jmp    80106162 <alltraps>

8010706f <vector246>:
.globl vector246
vector246:
  pushl $0
8010706f:	6a 00                	push   $0x0
  pushl $246
80107071:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107076:	e9 e7 f0 ff ff       	jmp    80106162 <alltraps>

8010707b <vector247>:
.globl vector247
vector247:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $247
8010707d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107082:	e9 db f0 ff ff       	jmp    80106162 <alltraps>

80107087 <vector248>:
.globl vector248
vector248:
  pushl $0
80107087:	6a 00                	push   $0x0
  pushl $248
80107089:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010708e:	e9 cf f0 ff ff       	jmp    80106162 <alltraps>

80107093 <vector249>:
.globl vector249
vector249:
  pushl $0
80107093:	6a 00                	push   $0x0
  pushl $249
80107095:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010709a:	e9 c3 f0 ff ff       	jmp    80106162 <alltraps>

8010709f <vector250>:
.globl vector250
vector250:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $250
801070a1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801070a6:	e9 b7 f0 ff ff       	jmp    80106162 <alltraps>

801070ab <vector251>:
.globl vector251
vector251:
  pushl $0
801070ab:	6a 00                	push   $0x0
  pushl $251
801070ad:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801070b2:	e9 ab f0 ff ff       	jmp    80106162 <alltraps>

801070b7 <vector252>:
.globl vector252
vector252:
  pushl $0
801070b7:	6a 00                	push   $0x0
  pushl $252
801070b9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801070be:	e9 9f f0 ff ff       	jmp    80106162 <alltraps>

801070c3 <vector253>:
.globl vector253
vector253:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $253
801070c5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801070ca:	e9 93 f0 ff ff       	jmp    80106162 <alltraps>

801070cf <vector254>:
.globl vector254
vector254:
  pushl $0
801070cf:	6a 00                	push   $0x0
  pushl $254
801070d1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801070d6:	e9 87 f0 ff ff       	jmp    80106162 <alltraps>

801070db <vector255>:
.globl vector255
vector255:
  pushl $0
801070db:	6a 00                	push   $0x0
  pushl $255
801070dd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801070e2:	e9 7b f0 ff ff       	jmp    80106162 <alltraps>
801070e7:	66 90                	xchg   %ax,%ax
801070e9:	66 90                	xchg   %ax,%ax
801070eb:	66 90                	xchg   %ax,%ax
801070ed:	66 90                	xchg   %ax,%ax
801070ef:	90                   	nop

801070f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	57                   	push   %edi
801070f4:	56                   	push   %esi
801070f5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801070f6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
801070fc:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80107102:	83 ec 1c             	sub    $0x1c,%esp
80107105:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107108:	39 d3                	cmp    %edx,%ebx
8010710a:	73 45                	jae    80107151 <deallocuvm.part.0+0x61>
8010710c:	89 c7                	mov    %eax,%edi
8010710e:	eb 0a                	jmp    8010711a <deallocuvm.part.0+0x2a>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80107110:	8d 59 01             	lea    0x1(%ecx),%ebx
80107113:	c1 e3 16             	shl    $0x16,%ebx
  for(; a  < oldsz; a += PGSIZE){
80107116:	39 da                	cmp    %ebx,%edx
80107118:	76 37                	jbe    80107151 <deallocuvm.part.0+0x61>
  pde = &pgdir[PDX(va)];
8010711a:	89 d9                	mov    %ebx,%ecx
8010711c:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
8010711f:	8b 04 8f             	mov    (%edi,%ecx,4),%eax
80107122:	a8 01                	test   $0x1,%al
80107124:	74 ea                	je     80107110 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80107126:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107128:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
8010712d:	c1 ee 0a             	shr    $0xa,%esi
80107130:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80107136:	8d b4 30 00 00 00 80 	lea    -0x80000000(%eax,%esi,1),%esi
    if(!pte)
8010713d:	85 f6                	test   %esi,%esi
8010713f:	74 cf                	je     80107110 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80107141:	8b 06                	mov    (%esi),%eax
80107143:	a8 01                	test   $0x1,%al
80107145:	75 19                	jne    80107160 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80107147:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010714d:	39 da                	cmp    %ebx,%edx
8010714f:	77 c9                	ja     8010711a <deallocuvm.part.0+0x2a>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80107151:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107154:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107157:	5b                   	pop    %ebx
80107158:	5e                   	pop    %esi
80107159:	5f                   	pop    %edi
8010715a:	5d                   	pop    %ebp
8010715b:	c3                   	ret    
8010715c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(pa == 0)
80107160:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107165:	74 25                	je     8010718c <deallocuvm.part.0+0x9c>
      kfree(v);
80107167:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
8010716a:	05 00 00 00 80       	add    $0x80000000,%eax
8010716f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80107172:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80107178:	50                   	push   %eax
80107179:	e8 52 b4 ff ff       	call   801025d0 <kfree>
      *pte = 0;
8010717e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80107184:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107187:	83 c4 10             	add    $0x10,%esp
8010718a:	eb 8a                	jmp    80107116 <deallocuvm.part.0+0x26>
        panic("kfree");
8010718c:	83 ec 0c             	sub    $0xc,%esp
8010718f:	68 46 7d 10 80       	push   $0x80107d46
80107194:	e8 e7 91 ff ff       	call   80100380 <panic>
80107199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071a0 <mappages>:
{
801071a0:	55                   	push   %ebp
801071a1:	89 e5                	mov    %esp,%ebp
801071a3:	57                   	push   %edi
801071a4:	56                   	push   %esi
801071a5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
801071a6:	89 d3                	mov    %edx,%ebx
801071a8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
801071ae:	83 ec 1c             	sub    $0x1c,%esp
801071b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801071b4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801071b8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801071bd:	89 45 dc             	mov    %eax,-0x24(%ebp)
801071c0:	8b 45 08             	mov    0x8(%ebp),%eax
801071c3:	29 d8                	sub    %ebx,%eax
801071c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801071c8:	eb 3d                	jmp    80107207 <mappages+0x67>
801071ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
801071d0:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801071d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801071d7:	c1 ea 0a             	shr    $0xa,%edx
801071da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801071e0:	8d 94 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%edx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801071e7:	85 d2                	test   %edx,%edx
801071e9:	74 75                	je     80107260 <mappages+0xc0>
    if(*pte & PTE_P)
801071eb:	f6 02 01             	testb  $0x1,(%edx)
801071ee:	0f 85 86 00 00 00    	jne    8010727a <mappages+0xda>
    *pte = pa | perm | PTE_P;
801071f4:	0b 75 0c             	or     0xc(%ebp),%esi
801071f7:	83 ce 01             	or     $0x1,%esi
801071fa:	89 32                	mov    %esi,(%edx)
    if(a == last)
801071fc:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
801071ff:	74 6f                	je     80107270 <mappages+0xd0>
    a += PGSIZE;
80107201:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80107207:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
8010720a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010720d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80107210:	89 d8                	mov    %ebx,%eax
80107212:	c1 e8 16             	shr    $0x16,%eax
80107215:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80107218:	8b 07                	mov    (%edi),%eax
8010721a:	a8 01                	test   $0x1,%al
8010721c:	75 b2                	jne    801071d0 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
8010721e:	e8 6d b5 ff ff       	call   80102790 <kalloc>
80107223:	85 c0                	test   %eax,%eax
80107225:	74 39                	je     80107260 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80107227:	83 ec 04             	sub    $0x4,%esp
8010722a:	89 45 d8             	mov    %eax,-0x28(%ebp)
8010722d:	68 00 10 00 00       	push   $0x1000
80107232:	6a 00                	push   $0x0
80107234:	50                   	push   %eax
80107235:	e8 16 dc ff ff       	call   80104e50 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010723a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
8010723d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80107240:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80107246:	83 c8 07             	or     $0x7,%eax
80107249:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
8010724b:	89 d8                	mov    %ebx,%eax
8010724d:	c1 e8 0a             	shr    $0xa,%eax
80107250:	25 fc 0f 00 00       	and    $0xffc,%eax
80107255:	01 c2                	add    %eax,%edx
80107257:	eb 92                	jmp    801071eb <mappages+0x4b>
80107259:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80107260:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107263:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107268:	5b                   	pop    %ebx
80107269:	5e                   	pop    %esi
8010726a:	5f                   	pop    %edi
8010726b:	5d                   	pop    %ebp
8010726c:	c3                   	ret    
8010726d:	8d 76 00             	lea    0x0(%esi),%esi
80107270:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107273:	31 c0                	xor    %eax,%eax
}
80107275:	5b                   	pop    %ebx
80107276:	5e                   	pop    %esi
80107277:	5f                   	pop    %edi
80107278:	5d                   	pop    %ebp
80107279:	c3                   	ret    
      panic("remap");
8010727a:	83 ec 0c             	sub    $0xc,%esp
8010727d:	68 dc 84 10 80       	push   $0x801084dc
80107282:	e8 f9 90 ff ff       	call   80100380 <panic>
80107287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010728e:	66 90                	xchg   %ax,%ax

80107290 <seginit>:
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80107296:	e8 d5 c8 ff ff       	call   80103b70 <cpuid>
  pd[0] = size-1;
8010729b:	ba 2f 00 00 00       	mov    $0x2f,%edx
801072a0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801072a6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801072aa:	c7 80 18 28 11 80 ff 	movl   $0xffff,-0x7feed7e8(%eax)
801072b1:	ff 00 00 
801072b4:	c7 80 1c 28 11 80 00 	movl   $0xcf9a00,-0x7feed7e4(%eax)
801072bb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801072be:	c7 80 20 28 11 80 ff 	movl   $0xffff,-0x7feed7e0(%eax)
801072c5:	ff 00 00 
801072c8:	c7 80 24 28 11 80 00 	movl   $0xcf9200,-0x7feed7dc(%eax)
801072cf:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801072d2:	c7 80 28 28 11 80 ff 	movl   $0xffff,-0x7feed7d8(%eax)
801072d9:	ff 00 00 
801072dc:	c7 80 2c 28 11 80 00 	movl   $0xcffa00,-0x7feed7d4(%eax)
801072e3:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801072e6:	c7 80 30 28 11 80 ff 	movl   $0xffff,-0x7feed7d0(%eax)
801072ed:	ff 00 00 
801072f0:	c7 80 34 28 11 80 00 	movl   $0xcff200,-0x7feed7cc(%eax)
801072f7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
801072fa:	05 10 28 11 80       	add    $0x80112810,%eax
  pd[1] = (uint)p;
801072ff:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80107303:	c1 e8 10             	shr    $0x10,%eax
80107306:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
8010730a:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010730d:	0f 01 10             	lgdtl  (%eax)
}
80107310:	c9                   	leave  
80107311:	c3                   	ret    
80107312:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80107320 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107320:	a1 c4 5e 11 80       	mov    0x80115ec4,%eax
80107325:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010732a:	0f 22 d8             	mov    %eax,%cr3
}
8010732d:	c3                   	ret    
8010732e:	66 90                	xchg   %ax,%ax

80107330 <switchuvm>:
{
80107330:	55                   	push   %ebp
80107331:	89 e5                	mov    %esp,%ebp
80107333:	57                   	push   %edi
80107334:	56                   	push   %esi
80107335:	53                   	push   %ebx
80107336:	83 ec 1c             	sub    $0x1c,%esp
80107339:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010733c:	85 f6                	test   %esi,%esi
8010733e:	0f 84 cb 00 00 00    	je     8010740f <switchuvm+0xdf>
  if(p->kstack == 0)
80107344:	8b 46 08             	mov    0x8(%esi),%eax
80107347:	85 c0                	test   %eax,%eax
80107349:	0f 84 da 00 00 00    	je     80107429 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010734f:	8b 46 04             	mov    0x4(%esi),%eax
80107352:	85 c0                	test   %eax,%eax
80107354:	0f 84 c2 00 00 00    	je     8010741c <switchuvm+0xec>
  pushcli();
8010735a:	e8 e1 d8 ff ff       	call   80104c40 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010735f:	e8 9c c7 ff ff       	call   80103b00 <mycpu>
80107364:	89 c3                	mov    %eax,%ebx
80107366:	e8 95 c7 ff ff       	call   80103b00 <mycpu>
8010736b:	89 c7                	mov    %eax,%edi
8010736d:	e8 8e c7 ff ff       	call   80103b00 <mycpu>
80107372:	83 c7 08             	add    $0x8,%edi
80107375:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80107378:	e8 83 c7 ff ff       	call   80103b00 <mycpu>
8010737d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80107380:	ba 67 00 00 00       	mov    $0x67,%edx
80107385:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
8010738c:	83 c0 08             	add    $0x8,%eax
8010738f:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107396:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010739b:	83 c1 08             	add    $0x8,%ecx
8010739e:	c1 e8 18             	shr    $0x18,%eax
801073a1:	c1 e9 10             	shr    $0x10,%ecx
801073a4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
801073aa:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801073b0:	b9 99 40 00 00       	mov    $0x4099,%ecx
801073b5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073bc:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801073c1:	e8 3a c7 ff ff       	call   80103b00 <mycpu>
801073c6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
801073cd:	e8 2e c7 ff ff       	call   80103b00 <mycpu>
801073d2:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801073d6:	8b 5e 08             	mov    0x8(%esi),%ebx
801073d9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801073df:	e8 1c c7 ff ff       	call   80103b00 <mycpu>
801073e4:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801073e7:	e8 14 c7 ff ff       	call   80103b00 <mycpu>
801073ec:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801073f0:	b8 28 00 00 00       	mov    $0x28,%eax
801073f5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
801073f8:	8b 46 04             	mov    0x4(%esi),%eax
801073fb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107400:	0f 22 d8             	mov    %eax,%cr3
}
80107403:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107406:	5b                   	pop    %ebx
80107407:	5e                   	pop    %esi
80107408:	5f                   	pop    %edi
80107409:	5d                   	pop    %ebp
  popcli();
8010740a:	e9 81 d8 ff ff       	jmp    80104c90 <popcli>
    panic("switchuvm: no process");
8010740f:	83 ec 0c             	sub    $0xc,%esp
80107412:	68 e2 84 10 80       	push   $0x801084e2
80107417:	e8 64 8f ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010741c:	83 ec 0c             	sub    $0xc,%esp
8010741f:	68 0d 85 10 80       	push   $0x8010850d
80107424:	e8 57 8f ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107429:	83 ec 0c             	sub    $0xc,%esp
8010742c:	68 f8 84 10 80       	push   $0x801084f8
80107431:	e8 4a 8f ff ff       	call   80100380 <panic>
80107436:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010743d:	8d 76 00             	lea    0x0(%esi),%esi

80107440 <inituvm>:
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	57                   	push   %edi
80107444:	56                   	push   %esi
80107445:	53                   	push   %ebx
80107446:	83 ec 1c             	sub    $0x1c,%esp
80107449:	8b 45 0c             	mov    0xc(%ebp),%eax
8010744c:	8b 75 10             	mov    0x10(%ebp),%esi
8010744f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107452:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107455:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010745b:	77 4b                	ja     801074a8 <inituvm+0x68>
  mem = kalloc();
8010745d:	e8 2e b3 ff ff       	call   80102790 <kalloc>
  memset(mem, 0, PGSIZE);
80107462:	83 ec 04             	sub    $0x4,%esp
80107465:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010746a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010746c:	6a 00                	push   $0x0
8010746e:	50                   	push   %eax
8010746f:	e8 dc d9 ff ff       	call   80104e50 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107474:	58                   	pop    %eax
80107475:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010747b:	5a                   	pop    %edx
8010747c:	6a 06                	push   $0x6
8010747e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107483:	31 d2                	xor    %edx,%edx
80107485:	50                   	push   %eax
80107486:	89 f8                	mov    %edi,%eax
80107488:	e8 13 fd ff ff       	call   801071a0 <mappages>
  memmove(mem, init, sz);
8010748d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107490:	89 75 10             	mov    %esi,0x10(%ebp)
80107493:	83 c4 10             	add    $0x10,%esp
80107496:	89 5d 08             	mov    %ebx,0x8(%ebp)
80107499:	89 45 0c             	mov    %eax,0xc(%ebp)
}
8010749c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010749f:	5b                   	pop    %ebx
801074a0:	5e                   	pop    %esi
801074a1:	5f                   	pop    %edi
801074a2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801074a3:	e9 48 da ff ff       	jmp    80104ef0 <memmove>
    panic("inituvm: more than a page");
801074a8:	83 ec 0c             	sub    $0xc,%esp
801074ab:	68 21 85 10 80       	push   $0x80108521
801074b0:	e8 cb 8e ff ff       	call   80100380 <panic>
801074b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801074c0 <loaduvm>:
{
801074c0:	55                   	push   %ebp
801074c1:	89 e5                	mov    %esp,%ebp
801074c3:	57                   	push   %edi
801074c4:	56                   	push   %esi
801074c5:	53                   	push   %ebx
801074c6:	83 ec 1c             	sub    $0x1c,%esp
801074c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801074cc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801074cf:	a9 ff 0f 00 00       	test   $0xfff,%eax
801074d4:	0f 85 bb 00 00 00    	jne    80107595 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
801074da:	01 f0                	add    %esi,%eax
801074dc:	89 f3                	mov    %esi,%ebx
801074de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
801074e1:	8b 45 14             	mov    0x14(%ebp),%eax
801074e4:	01 f0                	add    %esi,%eax
801074e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
801074e9:	85 f6                	test   %esi,%esi
801074eb:	0f 84 87 00 00 00    	je     80107578 <loaduvm+0xb8>
801074f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
801074f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
801074fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
801074fe:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107500:	89 c2                	mov    %eax,%edx
80107502:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107505:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107508:	f6 c2 01             	test   $0x1,%dl
8010750b:	75 13                	jne    80107520 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010750d:	83 ec 0c             	sub    $0xc,%esp
80107510:	68 3b 85 10 80       	push   $0x8010853b
80107515:	e8 66 8e ff ff       	call   80100380 <panic>
8010751a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107520:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107523:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107529:	25 fc 0f 00 00       	and    $0xffc,%eax
8010752e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107535:	85 c0                	test   %eax,%eax
80107537:	74 d4                	je     8010750d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107539:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010753b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010753e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107543:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107548:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010754e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107551:	29 d9                	sub    %ebx,%ecx
80107553:	05 00 00 00 80       	add    $0x80000000,%eax
80107558:	57                   	push   %edi
80107559:	51                   	push   %ecx
8010755a:	50                   	push   %eax
8010755b:	ff 75 10             	pushl  0x10(%ebp)
8010755e:	e8 3d a6 ff ff       	call   80101ba0 <readi>
80107563:	83 c4 10             	add    $0x10,%esp
80107566:	39 f8                	cmp    %edi,%eax
80107568:	75 1e                	jne    80107588 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010756a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
80107570:	89 f0                	mov    %esi,%eax
80107572:	29 d8                	sub    %ebx,%eax
80107574:	39 c6                	cmp    %eax,%esi
80107576:	77 80                	ja     801074f8 <loaduvm+0x38>
}
80107578:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
8010757b:	31 c0                	xor    %eax,%eax
}
8010757d:	5b                   	pop    %ebx
8010757e:	5e                   	pop    %esi
8010757f:	5f                   	pop    %edi
80107580:	5d                   	pop    %ebp
80107581:	c3                   	ret    
80107582:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107588:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
8010758b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107590:	5b                   	pop    %ebx
80107591:	5e                   	pop    %esi
80107592:	5f                   	pop    %edi
80107593:	5d                   	pop    %ebp
80107594:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
80107595:	83 ec 0c             	sub    $0xc,%esp
80107598:	68 dc 85 10 80       	push   $0x801085dc
8010759d:	e8 de 8d ff ff       	call   80100380 <panic>
801075a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801075b0 <allocuvm>:
{
801075b0:	55                   	push   %ebp
801075b1:	89 e5                	mov    %esp,%ebp
801075b3:	57                   	push   %edi
801075b4:	56                   	push   %esi
801075b5:	53                   	push   %ebx
801075b6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801075b9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801075bc:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801075bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801075c2:	85 c0                	test   %eax,%eax
801075c4:	0f 88 b6 00 00 00    	js     80107680 <allocuvm+0xd0>
  if(newsz < oldsz)
801075ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801075cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801075d0:	0f 82 9a 00 00 00    	jb     80107670 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
801075d6:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801075dc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801075e2:	39 75 10             	cmp    %esi,0x10(%ebp)
801075e5:	77 44                	ja     8010762b <allocuvm+0x7b>
801075e7:	e9 87 00 00 00       	jmp    80107673 <allocuvm+0xc3>
801075ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
801075f0:	83 ec 04             	sub    $0x4,%esp
801075f3:	68 00 10 00 00       	push   $0x1000
801075f8:	6a 00                	push   $0x0
801075fa:	50                   	push   %eax
801075fb:	e8 50 d8 ff ff       	call   80104e50 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107600:	58                   	pop    %eax
80107601:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107607:	5a                   	pop    %edx
80107608:	6a 06                	push   $0x6
8010760a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010760f:	89 f2                	mov    %esi,%edx
80107611:	50                   	push   %eax
80107612:	89 f8                	mov    %edi,%eax
80107614:	e8 87 fb ff ff       	call   801071a0 <mappages>
80107619:	83 c4 10             	add    $0x10,%esp
8010761c:	85 c0                	test   %eax,%eax
8010761e:	78 78                	js     80107698 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107620:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107626:	39 75 10             	cmp    %esi,0x10(%ebp)
80107629:	76 48                	jbe    80107673 <allocuvm+0xc3>
    mem = kalloc();
8010762b:	e8 60 b1 ff ff       	call   80102790 <kalloc>
80107630:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107632:	85 c0                	test   %eax,%eax
80107634:	75 ba                	jne    801075f0 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107636:	83 ec 0c             	sub    $0xc,%esp
80107639:	68 59 85 10 80       	push   $0x80108559
8010763e:	e8 3d 90 ff ff       	call   80100680 <cprintf>
  if(newsz >= oldsz)
80107643:	8b 45 0c             	mov    0xc(%ebp),%eax
80107646:	83 c4 10             	add    $0x10,%esp
80107649:	39 45 10             	cmp    %eax,0x10(%ebp)
8010764c:	74 32                	je     80107680 <allocuvm+0xd0>
8010764e:	8b 55 10             	mov    0x10(%ebp),%edx
80107651:	89 c1                	mov    %eax,%ecx
80107653:	89 f8                	mov    %edi,%eax
80107655:	e8 96 fa ff ff       	call   801070f0 <deallocuvm.part.0>
      return 0;
8010765a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107661:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107664:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107667:	5b                   	pop    %ebx
80107668:	5e                   	pop    %esi
80107669:	5f                   	pop    %edi
8010766a:	5d                   	pop    %ebp
8010766b:	c3                   	ret    
8010766c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
80107670:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
80107673:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107676:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107679:	5b                   	pop    %ebx
8010767a:	5e                   	pop    %esi
8010767b:	5f                   	pop    %edi
8010767c:	5d                   	pop    %ebp
8010767d:	c3                   	ret    
8010767e:	66 90                	xchg   %ax,%ax
    return 0;
80107680:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107687:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010768a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010768d:	5b                   	pop    %ebx
8010768e:	5e                   	pop    %esi
8010768f:	5f                   	pop    %edi
80107690:	5d                   	pop    %ebp
80107691:	c3                   	ret    
80107692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107698:	83 ec 0c             	sub    $0xc,%esp
8010769b:	68 71 85 10 80       	push   $0x80108571
801076a0:	e8 db 8f ff ff       	call   80100680 <cprintf>
  if(newsz >= oldsz)
801076a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801076a8:	83 c4 10             	add    $0x10,%esp
801076ab:	39 45 10             	cmp    %eax,0x10(%ebp)
801076ae:	74 0c                	je     801076bc <allocuvm+0x10c>
801076b0:	8b 55 10             	mov    0x10(%ebp),%edx
801076b3:	89 c1                	mov    %eax,%ecx
801076b5:	89 f8                	mov    %edi,%eax
801076b7:	e8 34 fa ff ff       	call   801070f0 <deallocuvm.part.0>
      kfree(mem);
801076bc:	83 ec 0c             	sub    $0xc,%esp
801076bf:	53                   	push   %ebx
801076c0:	e8 0b af ff ff       	call   801025d0 <kfree>
      return 0;
801076c5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801076cc:	83 c4 10             	add    $0x10,%esp
}
801076cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801076d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801076d5:	5b                   	pop    %ebx
801076d6:	5e                   	pop    %esi
801076d7:	5f                   	pop    %edi
801076d8:	5d                   	pop    %ebp
801076d9:	c3                   	ret    
801076da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801076e0 <deallocuvm>:
{
801076e0:	55                   	push   %ebp
801076e1:	89 e5                	mov    %esp,%ebp
801076e3:	8b 55 0c             	mov    0xc(%ebp),%edx
801076e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
801076e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
801076ec:	39 d1                	cmp    %edx,%ecx
801076ee:	73 10                	jae    80107700 <deallocuvm+0x20>
}
801076f0:	5d                   	pop    %ebp
801076f1:	e9 fa f9 ff ff       	jmp    801070f0 <deallocuvm.part.0>
801076f6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076fd:	8d 76 00             	lea    0x0(%esi),%esi
80107700:	89 d0                	mov    %edx,%eax
80107702:	5d                   	pop    %ebp
80107703:	c3                   	ret    
80107704:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010770b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010770f:	90                   	nop

80107710 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107710:	55                   	push   %ebp
80107711:	89 e5                	mov    %esp,%ebp
80107713:	57                   	push   %edi
80107714:	56                   	push   %esi
80107715:	53                   	push   %ebx
80107716:	83 ec 0c             	sub    $0xc,%esp
80107719:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010771c:	85 f6                	test   %esi,%esi
8010771e:	74 59                	je     80107779 <freevm+0x69>
  if(newsz >= oldsz)
80107720:	31 c9                	xor    %ecx,%ecx
80107722:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107727:	89 f0                	mov    %esi,%eax
80107729:	89 f3                	mov    %esi,%ebx
8010772b:	e8 c0 f9 ff ff       	call   801070f0 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107730:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107736:	eb 0f                	jmp    80107747 <freevm+0x37>
80107738:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010773f:	90                   	nop
80107740:	83 c3 04             	add    $0x4,%ebx
80107743:	39 df                	cmp    %ebx,%edi
80107745:	74 23                	je     8010776a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107747:	8b 03                	mov    (%ebx),%eax
80107749:	a8 01                	test   $0x1,%al
8010774b:	74 f3                	je     80107740 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010774d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107752:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107755:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107758:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010775d:	50                   	push   %eax
8010775e:	e8 6d ae ff ff       	call   801025d0 <kfree>
80107763:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107766:	39 df                	cmp    %ebx,%edi
80107768:	75 dd                	jne    80107747 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010776a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010776d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107770:	5b                   	pop    %ebx
80107771:	5e                   	pop    %esi
80107772:	5f                   	pop    %edi
80107773:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107774:	e9 57 ae ff ff       	jmp    801025d0 <kfree>
    panic("freevm: no pgdir");
80107779:	83 ec 0c             	sub    $0xc,%esp
8010777c:	68 8d 85 10 80       	push   $0x8010858d
80107781:	e8 fa 8b ff ff       	call   80100380 <panic>
80107786:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010778d:	8d 76 00             	lea    0x0(%esi),%esi

80107790 <setupkvm>:
{
80107790:	55                   	push   %ebp
80107791:	89 e5                	mov    %esp,%ebp
80107793:	56                   	push   %esi
80107794:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107795:	e8 f6 af ff ff       	call   80102790 <kalloc>
8010779a:	89 c6                	mov    %eax,%esi
8010779c:	85 c0                	test   %eax,%eax
8010779e:	74 42                	je     801077e2 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801077a0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077a3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801077a8:	68 00 10 00 00       	push   $0x1000
801077ad:	6a 00                	push   $0x0
801077af:	50                   	push   %eax
801077b0:	e8 9b d6 ff ff       	call   80104e50 <memset>
801077b5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801077b8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801077bb:	83 ec 08             	sub    $0x8,%esp
801077be:	8b 4b 08             	mov    0x8(%ebx),%ecx
801077c1:	ff 73 0c             	pushl  0xc(%ebx)
801077c4:	8b 13                	mov    (%ebx),%edx
801077c6:	50                   	push   %eax
801077c7:	29 c1                	sub    %eax,%ecx
801077c9:	89 f0                	mov    %esi,%eax
801077cb:	e8 d0 f9 ff ff       	call   801071a0 <mappages>
801077d0:	83 c4 10             	add    $0x10,%esp
801077d3:	85 c0                	test   %eax,%eax
801077d5:	78 19                	js     801077f0 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801077d7:	83 c3 10             	add    $0x10,%ebx
801077da:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
801077e0:	75 d6                	jne    801077b8 <setupkvm+0x28>
}
801077e2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801077e5:	89 f0                	mov    %esi,%eax
801077e7:	5b                   	pop    %ebx
801077e8:	5e                   	pop    %esi
801077e9:	5d                   	pop    %ebp
801077ea:	c3                   	ret    
801077eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801077ef:	90                   	nop
      freevm(pgdir);
801077f0:	83 ec 0c             	sub    $0xc,%esp
801077f3:	56                   	push   %esi
      return 0;
801077f4:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
801077f6:	e8 15 ff ff ff       	call   80107710 <freevm>
      return 0;
801077fb:	83 c4 10             	add    $0x10,%esp
}
801077fe:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107801:	89 f0                	mov    %esi,%eax
80107803:	5b                   	pop    %ebx
80107804:	5e                   	pop    %esi
80107805:	5d                   	pop    %ebp
80107806:	c3                   	ret    
80107807:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010780e:	66 90                	xchg   %ax,%ax

80107810 <kvmalloc>:
{
80107810:	55                   	push   %ebp
80107811:	89 e5                	mov    %esp,%ebp
80107813:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107816:	e8 75 ff ff ff       	call   80107790 <setupkvm>
8010781b:	a3 c4 5e 11 80       	mov    %eax,0x80115ec4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107820:	05 00 00 00 80       	add    $0x80000000,%eax
80107825:	0f 22 d8             	mov    %eax,%cr3
}
80107828:	c9                   	leave  
80107829:	c3                   	ret    
8010782a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107830 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107830:	55                   	push   %ebp
80107831:	89 e5                	mov    %esp,%ebp
80107833:	83 ec 08             	sub    $0x8,%esp
80107836:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107839:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010783c:	89 c1                	mov    %eax,%ecx
8010783e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107841:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107844:	f6 c2 01             	test   $0x1,%dl
80107847:	75 17                	jne    80107860 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107849:	83 ec 0c             	sub    $0xc,%esp
8010784c:	68 9e 85 10 80       	push   $0x8010859e
80107851:	e8 2a 8b ff ff       	call   80100380 <panic>
80107856:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010785d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107860:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107863:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107869:	25 fc 0f 00 00       	and    $0xffc,%eax
8010786e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
80107875:	85 c0                	test   %eax,%eax
80107877:	74 d0                	je     80107849 <clearpteu+0x19>
  *pte &= ~PTE_U;
80107879:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
8010787c:	c9                   	leave  
8010787d:	c3                   	ret    
8010787e:	66 90                	xchg   %ax,%ax

80107880 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80107880:	55                   	push   %ebp
80107881:	89 e5                	mov    %esp,%ebp
80107883:	57                   	push   %edi
80107884:	56                   	push   %esi
80107885:	53                   	push   %ebx
80107886:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80107889:	e8 02 ff ff ff       	call   80107790 <setupkvm>
8010788e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107891:	85 c0                	test   %eax,%eax
80107893:	0f 84 bd 00 00 00    	je     80107956 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107899:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010789c:	85 c9                	test   %ecx,%ecx
8010789e:	0f 84 b2 00 00 00    	je     80107956 <copyuvm+0xd6>
801078a4:	31 f6                	xor    %esi,%esi
801078a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801078ad:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801078b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801078b3:	89 f0                	mov    %esi,%eax
801078b5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801078b8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801078bb:	a8 01                	test   $0x1,%al
801078bd:	75 11                	jne    801078d0 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801078bf:	83 ec 0c             	sub    $0xc,%esp
801078c2:	68 a8 85 10 80       	push   $0x801085a8
801078c7:	e8 b4 8a ff ff       	call   80100380 <panic>
801078cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
801078d0:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801078d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
801078d7:	c1 ea 0a             	shr    $0xa,%edx
801078da:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
801078e0:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801078e7:	85 c0                	test   %eax,%eax
801078e9:	74 d4                	je     801078bf <copyuvm+0x3f>
    if(!(*pte & PTE_P))
801078eb:	8b 00                	mov    (%eax),%eax
801078ed:	a8 01                	test   $0x1,%al
801078ef:	0f 84 9f 00 00 00    	je     80107994 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801078f5:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
801078f7:	25 ff 0f 00 00       	and    $0xfff,%eax
801078fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
801078ff:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107905:	e8 86 ae ff ff       	call   80102790 <kalloc>
8010790a:	89 c3                	mov    %eax,%ebx
8010790c:	85 c0                	test   %eax,%eax
8010790e:	74 64                	je     80107974 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107910:	83 ec 04             	sub    $0x4,%esp
80107913:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107919:	68 00 10 00 00       	push   $0x1000
8010791e:	57                   	push   %edi
8010791f:	50                   	push   %eax
80107920:	e8 cb d5 ff ff       	call   80104ef0 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107925:	58                   	pop    %eax
80107926:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010792c:	5a                   	pop    %edx
8010792d:	ff 75 e4             	pushl  -0x1c(%ebp)
80107930:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107935:	89 f2                	mov    %esi,%edx
80107937:	50                   	push   %eax
80107938:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010793b:	e8 60 f8 ff ff       	call   801071a0 <mappages>
80107940:	83 c4 10             	add    $0x10,%esp
80107943:	85 c0                	test   %eax,%eax
80107945:	78 21                	js     80107968 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107947:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010794d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107950:	0f 87 5a ff ff ff    	ja     801078b0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107956:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107959:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010795c:	5b                   	pop    %ebx
8010795d:	5e                   	pop    %esi
8010795e:	5f                   	pop    %edi
8010795f:	5d                   	pop    %ebp
80107960:	c3                   	ret    
80107961:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107968:	83 ec 0c             	sub    $0xc,%esp
8010796b:	53                   	push   %ebx
8010796c:	e8 5f ac ff ff       	call   801025d0 <kfree>
      goto bad;
80107971:	83 c4 10             	add    $0x10,%esp
  freevm(d);
80107974:	83 ec 0c             	sub    $0xc,%esp
80107977:	ff 75 e0             	pushl  -0x20(%ebp)
8010797a:	e8 91 fd ff ff       	call   80107710 <freevm>
  return 0;
8010797f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
80107986:	83 c4 10             	add    $0x10,%esp
}
80107989:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010798c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010798f:	5b                   	pop    %ebx
80107990:	5e                   	pop    %esi
80107991:	5f                   	pop    %edi
80107992:	5d                   	pop    %ebp
80107993:	c3                   	ret    
      panic("copyuvm: page not present");
80107994:	83 ec 0c             	sub    $0xc,%esp
80107997:	68 c2 85 10 80       	push   $0x801085c2
8010799c:	e8 df 89 ff ff       	call   80100380 <panic>
801079a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801079af:	90                   	nop

801079b0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801079b0:	55                   	push   %ebp
801079b1:	89 e5                	mov    %esp,%ebp
801079b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801079b6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801079b9:	89 c1                	mov    %eax,%ecx
801079bb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801079be:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801079c1:	f6 c2 01             	test   $0x1,%dl
801079c4:	0f 84 00 01 00 00    	je     80107aca <uva2ka.cold>
  return &pgtab[PTX(va)];
801079ca:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801079cd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801079d3:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
801079d4:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
801079d9:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
801079e0:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801079e7:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801079ea:	05 00 00 00 80       	add    $0x80000000,%eax
801079ef:	83 fa 05             	cmp    $0x5,%edx
801079f2:	ba 00 00 00 00       	mov    $0x0,%edx
801079f7:	0f 45 c2             	cmovne %edx,%eax
}
801079fa:	c3                   	ret    
801079fb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801079ff:	90                   	nop

80107a00 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107a00:	55                   	push   %ebp
80107a01:	89 e5                	mov    %esp,%ebp
80107a03:	57                   	push   %edi
80107a04:	56                   	push   %esi
80107a05:	53                   	push   %ebx
80107a06:	83 ec 0c             	sub    $0xc,%esp
80107a09:	8b 75 14             	mov    0x14(%ebp),%esi
80107a0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80107a0f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107a12:	85 f6                	test   %esi,%esi
80107a14:	75 51                	jne    80107a67 <copyout+0x67>
80107a16:	e9 a5 00 00 00       	jmp    80107ac0 <copyout+0xc0>
80107a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107a1f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107a20:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107a26:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
80107a2c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107a32:	74 75                	je     80107aa9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107a34:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107a36:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107a39:	29 c3                	sub    %eax,%ebx
80107a3b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80107a41:	39 f3                	cmp    %esi,%ebx
80107a43:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107a46:	29 f8                	sub    %edi,%eax
80107a48:	83 ec 04             	sub    $0x4,%esp
80107a4b:	01 c8                	add    %ecx,%eax
80107a4d:	53                   	push   %ebx
80107a4e:	52                   	push   %edx
80107a4f:	50                   	push   %eax
80107a50:	e8 9b d4 ff ff       	call   80104ef0 <memmove>
    len -= n;
    buf += n;
80107a55:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107a58:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
80107a5e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107a61:	01 da                	add    %ebx,%edx
  while(len > 0){
80107a63:	29 de                	sub    %ebx,%esi
80107a65:	74 59                	je     80107ac0 <copyout+0xc0>
  if(*pde & PTE_P){
80107a67:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
80107a6a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107a6c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
80107a6e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
80107a71:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
80107a77:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
80107a7a:	f6 c1 01             	test   $0x1,%cl
80107a7d:	0f 84 4e 00 00 00    	je     80107ad1 <copyout.cold>
  return &pgtab[PTX(va)];
80107a83:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107a85:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80107a8b:	c1 eb 0c             	shr    $0xc,%ebx
80107a8e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
80107a94:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
80107a9b:	89 d9                	mov    %ebx,%ecx
80107a9d:	83 e1 05             	and    $0x5,%ecx
80107aa0:	83 f9 05             	cmp    $0x5,%ecx
80107aa3:	0f 84 77 ff ff ff    	je     80107a20 <copyout+0x20>
  }
  return 0;
}
80107aa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107aac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107ab1:	5b                   	pop    %ebx
80107ab2:	5e                   	pop    %esi
80107ab3:	5f                   	pop    %edi
80107ab4:	5d                   	pop    %ebp
80107ab5:	c3                   	ret    
80107ab6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107abd:	8d 76 00             	lea    0x0(%esi),%esi
80107ac0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107ac3:	31 c0                	xor    %eax,%eax
}
80107ac5:	5b                   	pop    %ebx
80107ac6:	5e                   	pop    %esi
80107ac7:	5f                   	pop    %edi
80107ac8:	5d                   	pop    %ebp
80107ac9:	c3                   	ret    

80107aca <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
80107aca:	a1 00 00 00 00       	mov    0x0,%eax
80107acf:	0f 0b                	ud2    

80107ad1 <copyout.cold>:
80107ad1:	a1 00 00 00 00       	mov    0x0,%eax
80107ad6:	0f 0b                	ud2    
