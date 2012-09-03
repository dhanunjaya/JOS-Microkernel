
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start-0xc>:
.long MULTIBOOT_HEADER_FLAGS
.long CHECKSUM

.globl		_start
_start:
	movw	$0x1234,0x472			# warm boot
f0100000:	02 b0 ad 1b 03 00    	add    0x31bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fb                   	sti    
f0100009:	4f                   	dec    %edi
f010000a:	52                   	push   %edx
f010000b:	e4 66                	in     $0x66,%al

f010000c <_start>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 

	# Establish our own GDT in place of the boot loader's temporary GDT.
	lgdt	RELOC(mygdtdesc)		# load descriptor table
f0100015:	0f 01 15 18 f0 11 00 	lgdtl  0x11f018

	# Immediately reload all segment registers (including CS!)
	# with segment selectors from the new GDT.
	movl	$DATA_SEL, %eax			# Data segment selector
f010001c:	b8 10 00 00 00       	mov    $0x10,%eax
	movw	%ax,%ds				# -> DS: Data Segment
f0100021:	8e d8                	mov    %eax,%ds
	movw	%ax,%es				# -> ES: Extra Segment
f0100023:	8e c0                	mov    %eax,%es
	movw	%ax,%ss				# -> SS: Stack Segment
f0100025:	8e d0                	mov    %eax,%ss
	ljmp	$CODE_SEL,$relocated		# reload CS by jumping
f0100027:	ea 2e 00 10 f0 08 00 	ljmp   $0x8,$0xf010002e

f010002e <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0,%ebp			# nuke frame pointer
f010002e:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Leave a few words on the stack for the user trap frame
	movl	$(bootstacktop-SIZEOF_STRUCT_TRAPFRAME),%esp
f0100033:	bc bc ef 11 f0       	mov    $0xf011efbc,%esp

	# now to C code
	call	i386_init
f0100038:	e8 a7 00 00 00       	call   f01000e4 <i386_init>

f010003d <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f010003d:	eb fe                	jmp    f010003d <spin>
	...

f0100040 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100040:	55                   	push   %ebp
f0100041:	89 e5                	mov    %esp,%ebp
f0100043:	53                   	push   %ebx
f0100044:	83 ec 14             	sub    $0x14,%esp
		monitor(NULL);
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
f0100047:	8d 5d 14             	lea    0x14(%ebp),%ebx
{
	va_list ap;

	va_start(ap, fmt);
	cprintf("kernel warning at %s:%d: ", file, line);
f010004a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010004d:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100051:	8b 45 08             	mov    0x8(%ebp),%eax
f0100054:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100058:	c7 04 24 a0 61 10 f0 	movl   $0xf01061a0,(%esp)
f010005f:	e8 5b 33 00 00       	call   f01033bf <cprintf>
	vcprintf(fmt, ap);
f0100064:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100068:	8b 45 10             	mov    0x10(%ebp),%eax
f010006b:	89 04 24             	mov    %eax,(%esp)
f010006e:	e8 19 33 00 00       	call   f010338c <vcprintf>
	cprintf("\n");
f0100073:	c7 04 24 75 66 10 f0 	movl   $0xf0106675,(%esp)
f010007a:	e8 40 33 00 00       	call   f01033bf <cprintf>
	va_end(ap);
}
f010007f:	83 c4 14             	add    $0x14,%esp
f0100082:	5b                   	pop    %ebx
f0100083:	5d                   	pop    %ebp
f0100084:	c3                   	ret    

f0100085 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100085:	55                   	push   %ebp
f0100086:	89 e5                	mov    %esp,%ebp
f0100088:	56                   	push   %esi
f0100089:	53                   	push   %ebx
f010008a:	83 ec 10             	sub    $0x10,%esp
f010008d:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f0100090:	83 3d a0 30 2d f0 00 	cmpl   $0x0,0xf02d30a0
f0100097:	75 3d                	jne    f01000d6 <_panic+0x51>
		goto dead;
	panicstr = fmt;
f0100099:	89 35 a0 30 2d f0    	mov    %esi,0xf02d30a0

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");
f010009f:	fa                   	cli    
f01000a0:	fc                   	cld    
/*
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
f01000a1:	8d 5d 14             	lea    0x14(%ebp),%ebx

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");

	va_start(ap, fmt);
	cprintf("kernel panic at %s:%d: ", file, line);
f01000a4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01000a7:	89 44 24 08          	mov    %eax,0x8(%esp)
f01000ab:	8b 45 08             	mov    0x8(%ebp),%eax
f01000ae:	89 44 24 04          	mov    %eax,0x4(%esp)
f01000b2:	c7 04 24 ba 61 10 f0 	movl   $0xf01061ba,(%esp)
f01000b9:	e8 01 33 00 00       	call   f01033bf <cprintf>
	vcprintf(fmt, ap);
f01000be:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01000c2:	89 34 24             	mov    %esi,(%esp)
f01000c5:	e8 c2 32 00 00       	call   f010338c <vcprintf>
	cprintf("\n");
f01000ca:	c7 04 24 75 66 10 f0 	movl   $0xf0106675,(%esp)
f01000d1:	e8 e9 32 00 00       	call   f01033bf <cprintf>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f01000d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01000dd:	e8 fe 06 00 00       	call   f01007e0 <monitor>
f01000e2:	eb f2                	jmp    f01000d6 <_panic+0x51>

f01000e4 <i386_init>:
#include <kern/pci.h>


void
i386_init(void)
{
f01000e4:	55                   	push   %ebp
f01000e5:	89 e5                	mov    %esp,%ebp
f01000e7:	83 ec 18             	sub    $0x18,%esp
	extern char edata[], end[];

	// Before doing anything else, complete the ELF loading process.
	// Clear the uninitialized global data (BSS) section of our program.
	// This ensures that all static/global variables start out zero.
	memset(edata, 0, end - edata);
f01000ea:	b8 58 ee 31 f0       	mov    $0xf031ee58,%eax
f01000ef:	2d 95 30 2d f0       	sub    $0xf02d3095,%eax
f01000f4:	89 44 24 08          	mov    %eax,0x8(%esp)
f01000f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01000ff:	00 
f0100100:	c7 04 24 95 30 2d f0 	movl   $0xf02d3095,(%esp)
f0100107:	e8 7a 50 00 00       	call   f0105186 <memset>

	// Initialize the console.
	// Can't call cprintf until after we do this!
	cons_init();
f010010c:	e8 84 04 00 00       	call   f0100595 <cons_init>

	cprintf("6828 decimal is %o octal!\n", 6828);
f0100111:	c7 44 24 04 ac 1a 00 	movl   $0x1aac,0x4(%esp)
f0100118:	00 
f0100119:	c7 04 24 d2 61 10 f0 	movl   $0xf01061d2,(%esp)
f0100120:	e8 9a 32 00 00       	call   f01033bf <cprintf>

	// Lab 2 memory management initialization functions
	i386_detect_memory();
f0100125:	e8 66 10 00 00       	call   f0101190 <i386_detect_memory>
	i386_vm_init();
f010012a:	e8 f8 10 00 00       	call   f0101227 <i386_vm_init>

	// Lab 3 user environment initialization functions
	env_init();
f010012f:	90                   	nop
f0100130:	e8 ae 2a 00 00       	call   f0102be3 <env_init>
	idt_init();
f0100135:	e8 b6 32 00 00       	call   f01033f0 <idt_init>

	// Lab 4 multitasking initialization functions
	pic_init();
f010013a:	e8 c1 31 00 00       	call   f0103300 <pic_init>
	kclock_init();
f010013f:	90                   	nop
f0100140:	e8 e7 30 00 00       	call   f010322c <kclock_init>

	time_init();
f0100145:	e8 86 5d 00 00       	call   f0105ed0 <time_init>
	pci_init();
f010014a:	e8 e9 5a 00 00       	call   f0105c38 <pci_init>

	// Should always have an idle process as first one.
	ENV_CREATE(user_idle);
f010014f:	c7 44 24 04 28 42 01 	movl   $0x14228,0x4(%esp)
f0100156:	00 
f0100157:	c7 04 24 02 56 13 f0 	movl   $0xf0135602,(%esp)
f010015e:	e8 ce 2f 00 00       	call   f0103131 <env_create>

	// Start fs.
	ENV_CREATE(fs_fs);
f0100163:	c7 44 24 04 44 09 02 	movl   $0x20944,0x4(%esp)
f010016a:	00 
f010016b:	c7 04 24 bd 5b 23 f0 	movl   $0xf0235bbd,(%esp)
f0100172:	e8 ba 2f 00 00       	call   f0103131 <env_create>


#endif // TEST*

	// Should not be necessary - drains keyboard because interrupt has given up.
	kbd_intr();
f0100177:	e8 86 00 00 00       	call   f0100202 <kbd_intr>

	// Schedule and run the first user environment!
	sched_yield();
f010017c:	e8 3b 3c 00 00       	call   f0103dbc <sched_yield>
	...

f0100190 <delay>:
static void cons_putc(int c);

// Stupid I/O delay routine necessitated by historical PC design flaws
static void
delay(void)
{
f0100190:	55                   	push   %ebp
f0100191:	89 e5                	mov    %esp,%ebp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100193:	ba 84 00 00 00       	mov    $0x84,%edx
f0100198:	ec                   	in     (%dx),%al
f0100199:	ec                   	in     (%dx),%al
f010019a:	ec                   	in     (%dx),%al
f010019b:	ec                   	in     (%dx),%al
	inb(0x84);
	inb(0x84);
	inb(0x84);
	inb(0x84);
}
f010019c:	5d                   	pop    %ebp
f010019d:	c3                   	ret    

f010019e <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f010019e:	55                   	push   %ebp
f010019f:	89 e5                	mov    %esp,%ebp
f01001a1:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01001a6:	ec                   	in     (%dx),%al
f01001a7:	89 c2                	mov    %eax,%edx
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f01001a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01001ae:	f6 c2 01             	test   $0x1,%dl
f01001b1:	74 09                	je     f01001bc <serial_proc_data+0x1e>
f01001b3:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01001b8:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f01001b9:	0f b6 c0             	movzbl %al,%eax
}
f01001bc:	5d                   	pop    %ebp
f01001bd:	c3                   	ret    

f01001be <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f01001be:	55                   	push   %ebp
f01001bf:	89 e5                	mov    %esp,%ebp
f01001c1:	57                   	push   %edi
f01001c2:	56                   	push   %esi
f01001c3:	53                   	push   %ebx
f01001c4:	83 ec 0c             	sub    $0xc,%esp
f01001c7:	89 c6                	mov    %eax,%esi
	int c;

	while ((c = (*proc)()) != -1) {
		if (c == 0)
			continue;
		cons.buf[cons.wpos++] = c;
f01001c9:	bb e4 32 2d f0       	mov    $0xf02d32e4,%ebx
f01001ce:	bf e0 30 2d f0       	mov    $0xf02d30e0,%edi
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
f01001d3:	eb 1e                	jmp    f01001f3 <cons_intr+0x35>
		if (c == 0)
f01001d5:	85 c0                	test   %eax,%eax
f01001d7:	74 1a                	je     f01001f3 <cons_intr+0x35>
			continue;
		cons.buf[cons.wpos++] = c;
f01001d9:	8b 13                	mov    (%ebx),%edx
f01001db:	88 04 17             	mov    %al,(%edi,%edx,1)
f01001de:	8d 42 01             	lea    0x1(%edx),%eax
		if (cons.wpos == CONSBUFSIZE)
f01001e1:	3d 00 02 00 00       	cmp    $0x200,%eax
			cons.wpos = 0;
f01001e6:	0f 94 c2             	sete   %dl
f01001e9:	0f b6 d2             	movzbl %dl,%edx
f01001ec:	83 ea 01             	sub    $0x1,%edx
f01001ef:	21 d0                	and    %edx,%eax
f01001f1:	89 03                	mov    %eax,(%ebx)
static void
cons_intr(int (*proc)(void))
{
	int c;

	while ((c = (*proc)()) != -1) {
f01001f3:	ff d6                	call   *%esi
f01001f5:	83 f8 ff             	cmp    $0xffffffff,%eax
f01001f8:	75 db                	jne    f01001d5 <cons_intr+0x17>
			continue;
		cons.buf[cons.wpos++] = c;
		if (cons.wpos == CONSBUFSIZE)
			cons.wpos = 0;
	}
}
f01001fa:	83 c4 0c             	add    $0xc,%esp
f01001fd:	5b                   	pop    %ebx
f01001fe:	5e                   	pop    %esi
f01001ff:	5f                   	pop    %edi
f0100200:	5d                   	pop    %ebp
f0100201:	c3                   	ret    

f0100202 <kbd_intr>:
	return c;
}

void
kbd_intr(void)
{
f0100202:	55                   	push   %ebp
f0100203:	89 e5                	mov    %esp,%ebp
f0100205:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f0100208:	b8 9a 04 10 f0       	mov    $0xf010049a,%eax
f010020d:	e8 ac ff ff ff       	call   f01001be <cons_intr>
}
f0100212:	c9                   	leave  
f0100213:	c3                   	ret    

f0100214 <serial_intr>:
	return inb(COM1+COM_RX);
}

void
serial_intr(void)
{
f0100214:	55                   	push   %ebp
f0100215:	89 e5                	mov    %esp,%ebp
f0100217:	83 ec 08             	sub    $0x8,%esp
	if (serial_exists)
f010021a:	83 3d c4 30 2d f0 00 	cmpl   $0x0,0xf02d30c4
f0100221:	74 0a                	je     f010022d <serial_intr+0x19>
		cons_intr(serial_proc_data);
f0100223:	b8 9e 01 10 f0       	mov    $0xf010019e,%eax
f0100228:	e8 91 ff ff ff       	call   f01001be <cons_intr>
}
f010022d:	c9                   	leave  
f010022e:	c3                   	ret    

f010022f <cons_getc>:
}

// return the next input character from the console, or 0 if none waiting
int
cons_getc(void)
{
f010022f:	55                   	push   %ebp
f0100230:	89 e5                	mov    %esp,%ebp
f0100232:	83 ec 08             	sub    $0x8,%esp
	int c;

	// poll for any pending input characters,
	// so that this function works even when interrupts are disabled
	// (e.g., when called from the kernel monitor).
	serial_intr();
f0100235:	e8 da ff ff ff       	call   f0100214 <serial_intr>
	kbd_intr();
f010023a:	e8 c3 ff ff ff       	call   f0100202 <kbd_intr>

	// grab the next character from the input buffer.
	if (cons.rpos != cons.wpos) {
f010023f:	8b 15 e0 32 2d f0    	mov    0xf02d32e0,%edx
f0100245:	b8 00 00 00 00       	mov    $0x0,%eax
f010024a:	3b 15 e4 32 2d f0    	cmp    0xf02d32e4,%edx
f0100250:	74 21                	je     f0100273 <cons_getc+0x44>
		c = cons.buf[cons.rpos++];
f0100252:	0f b6 82 e0 30 2d f0 	movzbl -0xfd2cf20(%edx),%eax
f0100259:	83 c2 01             	add    $0x1,%edx
		if (cons.rpos == CONSBUFSIZE)
f010025c:	81 fa 00 02 00 00    	cmp    $0x200,%edx
			cons.rpos = 0;
f0100262:	0f 94 c1             	sete   %cl
f0100265:	0f b6 c9             	movzbl %cl,%ecx
f0100268:	83 e9 01             	sub    $0x1,%ecx
f010026b:	21 ca                	and    %ecx,%edx
f010026d:	89 15 e0 32 2d f0    	mov    %edx,0xf02d32e0
		return c;
	}
	return 0;
}
f0100273:	c9                   	leave  
f0100274:	c3                   	ret    

f0100275 <getchar>:
	cons_putc(c);
}

int
getchar(void)
{
f0100275:	55                   	push   %ebp
f0100276:	89 e5                	mov    %esp,%ebp
f0100278:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f010027b:	e8 af ff ff ff       	call   f010022f <cons_getc>
f0100280:	85 c0                	test   %eax,%eax
f0100282:	74 f7                	je     f010027b <getchar+0x6>
		/* do nothing */;
	return c;
}
f0100284:	c9                   	leave  
f0100285:	c3                   	ret    

f0100286 <iscons>:

int
iscons(int fdnum)
{
f0100286:	55                   	push   %ebp
f0100287:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f0100289:	b8 01 00 00 00       	mov    $0x1,%eax
f010028e:	5d                   	pop    %ebp
f010028f:	c3                   	ret    

f0100290 <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f0100290:	55                   	push   %ebp
f0100291:	89 e5                	mov    %esp,%ebp
f0100293:	57                   	push   %edi
f0100294:	56                   	push   %esi
f0100295:	53                   	push   %ebx
f0100296:	83 ec 2c             	sub    $0x2c,%esp
f0100299:	89 c7                	mov    %eax,%edi
f010029b:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01002a0:	ec                   	in     (%dx),%al
static void
serial_putc(int c)
{
	int i;
	
	for (i = 0;
f01002a1:	a8 20                	test   $0x20,%al
f01002a3:	75 21                	jne    f01002c6 <cons_putc+0x36>
f01002a5:	bb 00 00 00 00       	mov    $0x0,%ebx
f01002aa:	be fd 03 00 00       	mov    $0x3fd,%esi
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();
f01002af:	e8 dc fe ff ff       	call   f0100190 <delay>
f01002b4:	89 f2                	mov    %esi,%edx
f01002b6:	ec                   	in     (%dx),%al
static void
serial_putc(int c)
{
	int i;
	
	for (i = 0;
f01002b7:	a8 20                	test   $0x20,%al
f01002b9:	75 0b                	jne    f01002c6 <cons_putc+0x36>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
f01002bb:	83 c3 01             	add    $0x1,%ebx
static void
serial_putc(int c)
{
	int i;
	
	for (i = 0;
f01002be:	81 fb 00 32 00 00    	cmp    $0x3200,%ebx
f01002c4:	75 e9                	jne    f01002af <cons_putc+0x1f>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
	     i++)
		delay();
	
	outb(COM1 + COM_TX, c);
f01002c6:	89 fa                	mov    %edi,%edx
f01002c8:	89 f8                	mov    %edi,%eax
f01002ca:	88 55 e7             	mov    %dl,-0x19(%ebp)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01002cd:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01002d2:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01002d3:	b2 79                	mov    $0x79,%dl
f01002d5:	ec                   	in     (%dx),%al
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01002d6:	84 c0                	test   %al,%al
f01002d8:	78 21                	js     f01002fb <cons_putc+0x6b>
f01002da:	bb 00 00 00 00       	mov    $0x0,%ebx
f01002df:	be 79 03 00 00       	mov    $0x379,%esi
		delay();
f01002e4:	e8 a7 fe ff ff       	call   f0100190 <delay>
f01002e9:	89 f2                	mov    %esi,%edx
f01002eb:	ec                   	in     (%dx),%al
static void
lpt_putc(int c)
{
	int i;

	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01002ec:	84 c0                	test   %al,%al
f01002ee:	78 0b                	js     f01002fb <cons_putc+0x6b>
f01002f0:	83 c3 01             	add    $0x1,%ebx
f01002f3:	81 fb 00 32 00 00    	cmp    $0x3200,%ebx
f01002f9:	75 e9                	jne    f01002e4 <cons_putc+0x54>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01002fb:	ba 78 03 00 00       	mov    $0x378,%edx
f0100300:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
f0100304:	ee                   	out    %al,(%dx)
f0100305:	b2 7a                	mov    $0x7a,%dl
f0100307:	b8 0d 00 00 00       	mov    $0xd,%eax
f010030c:	ee                   	out    %al,(%dx)
f010030d:	b8 08 00 00 00       	mov    $0x8,%eax
f0100312:	ee                   	out    %al,(%dx)

static void
cga_putc(int c)
{
	// if no attribute given, then use black on white
	if (!(c & ~0xFF))
f0100313:	f7 c7 00 ff ff ff    	test   $0xffffff00,%edi
f0100319:	75 06                	jne    f0100321 <cons_putc+0x91>
		c |= 0x0700;
f010031b:	81 cf 00 07 00 00    	or     $0x700,%edi

	switch (c & 0xff) {
f0100321:	89 f8                	mov    %edi,%eax
f0100323:	25 ff 00 00 00       	and    $0xff,%eax
f0100328:	83 f8 09             	cmp    $0x9,%eax
f010032b:	0f 84 83 00 00 00    	je     f01003b4 <cons_putc+0x124>
f0100331:	83 f8 09             	cmp    $0x9,%eax
f0100334:	7f 0c                	jg     f0100342 <cons_putc+0xb2>
f0100336:	83 f8 08             	cmp    $0x8,%eax
f0100339:	0f 85 a9 00 00 00    	jne    f01003e8 <cons_putc+0x158>
f010033f:	90                   	nop
f0100340:	eb 18                	jmp    f010035a <cons_putc+0xca>
f0100342:	83 f8 0a             	cmp    $0xa,%eax
f0100345:	8d 76 00             	lea    0x0(%esi),%esi
f0100348:	74 40                	je     f010038a <cons_putc+0xfa>
f010034a:	83 f8 0d             	cmp    $0xd,%eax
f010034d:	8d 76 00             	lea    0x0(%esi),%esi
f0100350:	0f 85 92 00 00 00    	jne    f01003e8 <cons_putc+0x158>
f0100356:	66 90                	xchg   %ax,%ax
f0100358:	eb 38                	jmp    f0100392 <cons_putc+0x102>
	case '\b':
		if (crt_pos > 0) {
f010035a:	0f b7 05 d0 30 2d f0 	movzwl 0xf02d30d0,%eax
f0100361:	66 85 c0             	test   %ax,%ax
f0100364:	0f 84 e8 00 00 00    	je     f0100452 <cons_putc+0x1c2>
			crt_pos--;
f010036a:	83 e8 01             	sub    $0x1,%eax
f010036d:	66 a3 d0 30 2d f0    	mov    %ax,0xf02d30d0
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f0100373:	0f b7 c0             	movzwl %ax,%eax
f0100376:	66 81 e7 00 ff       	and    $0xff00,%di
f010037b:	83 cf 20             	or     $0x20,%edi
f010037e:	8b 15 cc 30 2d f0    	mov    0xf02d30cc,%edx
f0100384:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f0100388:	eb 7b                	jmp    f0100405 <cons_putc+0x175>
		}
		break;
	case '\n':
		crt_pos += CRT_COLS;
f010038a:	66 83 05 d0 30 2d f0 	addw   $0x50,0xf02d30d0
f0100391:	50 
		/* fallthru */
	case '\r':
		crt_pos -= (crt_pos % CRT_COLS);
f0100392:	0f b7 05 d0 30 2d f0 	movzwl 0xf02d30d0,%eax
f0100399:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
f010039f:	c1 e8 10             	shr    $0x10,%eax
f01003a2:	66 c1 e8 06          	shr    $0x6,%ax
f01003a6:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01003a9:	c1 e0 04             	shl    $0x4,%eax
f01003ac:	66 a3 d0 30 2d f0    	mov    %ax,0xf02d30d0
f01003b2:	eb 51                	jmp    f0100405 <cons_putc+0x175>
		break;
	case '\t':
		cons_putc(' ');
f01003b4:	b8 20 00 00 00       	mov    $0x20,%eax
f01003b9:	e8 d2 fe ff ff       	call   f0100290 <cons_putc>
		cons_putc(' ');
f01003be:	b8 20 00 00 00       	mov    $0x20,%eax
f01003c3:	e8 c8 fe ff ff       	call   f0100290 <cons_putc>
		cons_putc(' ');
f01003c8:	b8 20 00 00 00       	mov    $0x20,%eax
f01003cd:	e8 be fe ff ff       	call   f0100290 <cons_putc>
		cons_putc(' ');
f01003d2:	b8 20 00 00 00       	mov    $0x20,%eax
f01003d7:	e8 b4 fe ff ff       	call   f0100290 <cons_putc>
		cons_putc(' ');
f01003dc:	b8 20 00 00 00       	mov    $0x20,%eax
f01003e1:	e8 aa fe ff ff       	call   f0100290 <cons_putc>
f01003e6:	eb 1d                	jmp    f0100405 <cons_putc+0x175>
		break;
	default:
		crt_buf[crt_pos++] = c;		/* write the character */
f01003e8:	0f b7 05 d0 30 2d f0 	movzwl 0xf02d30d0,%eax
f01003ef:	0f b7 c8             	movzwl %ax,%ecx
f01003f2:	8b 15 cc 30 2d f0    	mov    0xf02d30cc,%edx
f01003f8:	66 89 3c 4a          	mov    %di,(%edx,%ecx,2)
f01003fc:	83 c0 01             	add    $0x1,%eax
f01003ff:	66 a3 d0 30 2d f0    	mov    %ax,0xf02d30d0
		break;
	}

	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
f0100405:	66 81 3d d0 30 2d f0 	cmpw   $0x7cf,0xf02d30d0
f010040c:	cf 07 
f010040e:	76 42                	jbe    f0100452 <cons_putc+0x1c2>
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100410:	a1 cc 30 2d f0       	mov    0xf02d30cc,%eax
f0100415:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
f010041c:	00 
f010041d:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100423:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100427:	89 04 24             	mov    %eax,(%esp)
f010042a:	e8 b6 4d 00 00       	call   f01051e5 <memmove>
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
			crt_buf[i] = 0x0700 | ' ';
f010042f:	8b 15 cc 30 2d f0    	mov    0xf02d30cc,%edx
f0100435:	b8 80 07 00 00       	mov    $0x780,%eax
f010043a:	66 c7 04 42 20 07    	movw   $0x720,(%edx,%eax,2)
	// What is the purpose of this?
	if (crt_pos >= CRT_SIZE) {
		int i;

		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100440:	83 c0 01             	add    $0x1,%eax
f0100443:	3d d0 07 00 00       	cmp    $0x7d0,%eax
f0100448:	75 f0                	jne    f010043a <cons_putc+0x1aa>
			crt_buf[i] = 0x0700 | ' ';
		crt_pos -= CRT_COLS;
f010044a:	66 83 2d d0 30 2d f0 	subw   $0x50,0xf02d30d0
f0100451:	50 
	}

	/* move that little blinky thing */
	outb(addr_6845, 14);
f0100452:	8b 0d c8 30 2d f0    	mov    0xf02d30c8,%ecx
f0100458:	89 cb                	mov    %ecx,%ebx
f010045a:	b8 0e 00 00 00       	mov    $0xe,%eax
f010045f:	89 ca                	mov    %ecx,%edx
f0100461:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100462:	0f b7 35 d0 30 2d f0 	movzwl 0xf02d30d0,%esi
f0100469:	83 c1 01             	add    $0x1,%ecx
f010046c:	89 f0                	mov    %esi,%eax
f010046e:	66 c1 e8 08          	shr    $0x8,%ax
f0100472:	89 ca                	mov    %ecx,%edx
f0100474:	ee                   	out    %al,(%dx)
f0100475:	b8 0f 00 00 00       	mov    $0xf,%eax
f010047a:	89 da                	mov    %ebx,%edx
f010047c:	ee                   	out    %al,(%dx)
f010047d:	89 f0                	mov    %esi,%eax
f010047f:	89 ca                	mov    %ecx,%edx
f0100481:	ee                   	out    %al,(%dx)
cons_putc(int c)
{
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f0100482:	83 c4 2c             	add    $0x2c,%esp
f0100485:	5b                   	pop    %ebx
f0100486:	5e                   	pop    %esi
f0100487:	5f                   	pop    %edi
f0100488:	5d                   	pop    %ebp
f0100489:	c3                   	ret    

f010048a <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f010048a:	55                   	push   %ebp
f010048b:	89 e5                	mov    %esp,%ebp
f010048d:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f0100490:	8b 45 08             	mov    0x8(%ebp),%eax
f0100493:	e8 f8 fd ff ff       	call   f0100290 <cons_putc>
}
f0100498:	c9                   	leave  
f0100499:	c3                   	ret    

f010049a <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f010049a:	55                   	push   %ebp
f010049b:	89 e5                	mov    %esp,%ebp
f010049d:	53                   	push   %ebx
f010049e:	83 ec 14             	sub    $0x14,%esp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01004a1:	ba 64 00 00 00       	mov    $0x64,%edx
f01004a6:	ec                   	in     (%dx),%al
	int c;
	uint8_t data;
	static uint32_t shift;

	if ((inb(KBSTATP) & KBS_DIB) == 0)
f01004a7:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01004ac:	a8 01                	test   $0x1,%al
f01004ae:	0f 84 d9 00 00 00    	je     f010058d <kbd_proc_data+0xf3>
f01004b4:	b2 60                	mov    $0x60,%dl
f01004b6:	ec                   	in     (%dx),%al
		return -1;

	data = inb(KBDATAP);

	if (data == 0xE0) {
f01004b7:	3c e0                	cmp    $0xe0,%al
f01004b9:	75 11                	jne    f01004cc <kbd_proc_data+0x32>
		// E0 escape character
		shift |= E0ESC;
f01004bb:	83 0d c0 30 2d f0 40 	orl    $0x40,0xf02d30c0
f01004c2:	bb 00 00 00 00       	mov    $0x0,%ebx
		return 0;
f01004c7:	e9 c1 00 00 00       	jmp    f010058d <kbd_proc_data+0xf3>
	} else if (data & 0x80) {
f01004cc:	84 c0                	test   %al,%al
f01004ce:	79 32                	jns    f0100502 <kbd_proc_data+0x68>
		// Key released
		data = (shift & E0ESC ? data : data & 0x7F);
f01004d0:	8b 15 c0 30 2d f0    	mov    0xf02d30c0,%edx
f01004d6:	f6 c2 40             	test   $0x40,%dl
f01004d9:	75 03                	jne    f01004de <kbd_proc_data+0x44>
f01004db:	83 e0 7f             	and    $0x7f,%eax
		shift &= ~(shiftcode[data] | E0ESC);
f01004de:	0f b6 c0             	movzbl %al,%eax
f01004e1:	0f b6 80 20 62 10 f0 	movzbl -0xfef9de0(%eax),%eax
f01004e8:	83 c8 40             	or     $0x40,%eax
f01004eb:	0f b6 c0             	movzbl %al,%eax
f01004ee:	f7 d0                	not    %eax
f01004f0:	21 c2                	and    %eax,%edx
f01004f2:	89 15 c0 30 2d f0    	mov    %edx,0xf02d30c0
f01004f8:	bb 00 00 00 00       	mov    $0x0,%ebx
		return 0;
f01004fd:	e9 8b 00 00 00       	jmp    f010058d <kbd_proc_data+0xf3>
	} else if (shift & E0ESC) {
f0100502:	8b 15 c0 30 2d f0    	mov    0xf02d30c0,%edx
f0100508:	f6 c2 40             	test   $0x40,%dl
f010050b:	74 0c                	je     f0100519 <kbd_proc_data+0x7f>
		// Last character was an E0 escape; or with 0x80
		data |= 0x80;
f010050d:	83 c8 80             	or     $0xffffff80,%eax
		shift &= ~E0ESC;
f0100510:	83 e2 bf             	and    $0xffffffbf,%edx
f0100513:	89 15 c0 30 2d f0    	mov    %edx,0xf02d30c0
	}

	shift |= shiftcode[data];
f0100519:	0f b6 c0             	movzbl %al,%eax
	shift ^= togglecode[data];
f010051c:	0f b6 90 20 62 10 f0 	movzbl -0xfef9de0(%eax),%edx
f0100523:	0b 15 c0 30 2d f0    	or     0xf02d30c0,%edx
f0100529:	0f b6 88 20 63 10 f0 	movzbl -0xfef9ce0(%eax),%ecx
f0100530:	31 ca                	xor    %ecx,%edx
f0100532:	89 15 c0 30 2d f0    	mov    %edx,0xf02d30c0

	c = charcode[shift & (CTL | SHIFT)][data];
f0100538:	89 d1                	mov    %edx,%ecx
f010053a:	83 e1 03             	and    $0x3,%ecx
f010053d:	8b 0c 8d 20 64 10 f0 	mov    -0xfef9be0(,%ecx,4),%ecx
f0100544:	0f b6 1c 01          	movzbl (%ecx,%eax,1),%ebx
	if (shift & CAPSLOCK) {
f0100548:	f6 c2 08             	test   $0x8,%dl
f010054b:	74 1a                	je     f0100567 <kbd_proc_data+0xcd>
		if ('a' <= c && c <= 'z')
f010054d:	89 d9                	mov    %ebx,%ecx
f010054f:	8d 43 9f             	lea    -0x61(%ebx),%eax
f0100552:	83 f8 19             	cmp    $0x19,%eax
f0100555:	77 05                	ja     f010055c <kbd_proc_data+0xc2>
			c += 'A' - 'a';
f0100557:	83 eb 20             	sub    $0x20,%ebx
f010055a:	eb 0b                	jmp    f0100567 <kbd_proc_data+0xcd>
		else if ('A' <= c && c <= 'Z')
f010055c:	83 e9 41             	sub    $0x41,%ecx
f010055f:	83 f9 19             	cmp    $0x19,%ecx
f0100562:	77 03                	ja     f0100567 <kbd_proc_data+0xcd>
			c += 'a' - 'A';
f0100564:	83 c3 20             	add    $0x20,%ebx
	}

	// Process special keys
	// Ctrl-Alt-Del: reboot
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100567:	f7 d2                	not    %edx
f0100569:	f6 c2 06             	test   $0x6,%dl
f010056c:	75 1f                	jne    f010058d <kbd_proc_data+0xf3>
f010056e:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f0100574:	75 17                	jne    f010058d <kbd_proc_data+0xf3>
		cprintf("Rebooting!\n");
f0100576:	c7 04 24 ed 61 10 f0 	movl   $0xf01061ed,(%esp)
f010057d:	e8 3d 2e 00 00       	call   f01033bf <cprintf>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100582:	ba 92 00 00 00       	mov    $0x92,%edx
f0100587:	b8 03 00 00 00       	mov    $0x3,%eax
f010058c:	ee                   	out    %al,(%dx)
		outb(0x92, 0x3); // courtesy of Chris Frost
	}

	return c;
}
f010058d:	89 d8                	mov    %ebx,%eax
f010058f:	83 c4 14             	add    $0x14,%esp
f0100592:	5b                   	pop    %ebx
f0100593:	5d                   	pop    %ebp
f0100594:	c3                   	ret    

f0100595 <cons_init>:
}

// initialize the console devices
void
cons_init(void)
{
f0100595:	55                   	push   %ebp
f0100596:	89 e5                	mov    %esp,%ebp
f0100598:	57                   	push   %edi
f0100599:	56                   	push   %esi
f010059a:	53                   	push   %ebx
f010059b:	83 ec 1c             	sub    $0x1c,%esp
	volatile uint16_t *cp;
	uint16_t was;
	unsigned pos;

	cp = (uint16_t*) (KERNBASE + CGA_BUF);
	was = *cp;
f010059e:	b8 00 80 0b f0       	mov    $0xf00b8000,%eax
f01005a3:	0f b7 10             	movzwl (%eax),%edx
	*cp = (uint16_t) 0xA55A;
f01005a6:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
	if (*cp != 0xA55A) {
f01005ab:	0f b7 00             	movzwl (%eax),%eax
f01005ae:	66 3d 5a a5          	cmp    $0xa55a,%ax
f01005b2:	74 11                	je     f01005c5 <cons_init+0x30>
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
		addr_6845 = MONO_BASE;
f01005b4:	c7 05 c8 30 2d f0 b4 	movl   $0x3b4,0xf02d30c8
f01005bb:	03 00 00 
f01005be:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
f01005c3:	eb 16                	jmp    f01005db <cons_init+0x46>
	} else {
		*cp = was;
f01005c5:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f01005cc:	c7 05 c8 30 2d f0 d4 	movl   $0x3d4,0xf02d30c8
f01005d3:	03 00 00 
f01005d6:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
	}
	
	/* Extract cursor location */
	outb(addr_6845, 14);
f01005db:	8b 0d c8 30 2d f0    	mov    0xf02d30c8,%ecx
f01005e1:	89 cb                	mov    %ecx,%ebx
f01005e3:	b8 0e 00 00 00       	mov    $0xe,%eax
f01005e8:	89 ca                	mov    %ecx,%edx
f01005ea:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f01005eb:	83 c1 01             	add    $0x1,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01005ee:	89 ca                	mov    %ecx,%edx
f01005f0:	ec                   	in     (%dx),%al
f01005f1:	0f b6 f8             	movzbl %al,%edi
f01005f4:	c1 e7 08             	shl    $0x8,%edi
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01005f7:	b8 0f 00 00 00       	mov    $0xf,%eax
f01005fc:	89 da                	mov    %ebx,%edx
f01005fe:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01005ff:	89 ca                	mov    %ecx,%edx
f0100601:	ec                   	in     (%dx),%al
	outb(addr_6845, 15);
	pos |= inb(addr_6845 + 1);

	crt_buf = (uint16_t*) cp;
f0100602:	89 35 cc 30 2d f0    	mov    %esi,0xf02d30cc
	crt_pos = pos;
f0100608:	0f b6 c8             	movzbl %al,%ecx
f010060b:	09 cf                	or     %ecx,%edi
f010060d:	66 89 3d d0 30 2d f0 	mov    %di,0xf02d30d0

static void
kbd_init(void)
{
	// Drain the kbd buffer so that Bochs generates interrupts.
	kbd_intr();
f0100614:	e8 e9 fb ff ff       	call   f0100202 <kbd_intr>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<1));
f0100619:	0f b7 05 58 f3 11 f0 	movzwl 0xf011f358,%eax
f0100620:	25 fd ff 00 00       	and    $0xfffd,%eax
f0100625:	89 04 24             	mov    %eax,(%esp)
f0100628:	e8 62 2c 00 00       	call   f010328f <irq_setmask_8259A>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010062d:	bb fa 03 00 00       	mov    $0x3fa,%ebx
f0100632:	b8 00 00 00 00       	mov    $0x0,%eax
f0100637:	89 da                	mov    %ebx,%edx
f0100639:	ee                   	out    %al,(%dx)
f010063a:	b2 fb                	mov    $0xfb,%dl
f010063c:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
f0100641:	ee                   	out    %al,(%dx)
f0100642:	b9 f8 03 00 00       	mov    $0x3f8,%ecx
f0100647:	b8 0c 00 00 00       	mov    $0xc,%eax
f010064c:	89 ca                	mov    %ecx,%edx
f010064e:	ee                   	out    %al,(%dx)
f010064f:	b2 f9                	mov    $0xf9,%dl
f0100651:	b8 00 00 00 00       	mov    $0x0,%eax
f0100656:	ee                   	out    %al,(%dx)
f0100657:	b2 fb                	mov    $0xfb,%dl
f0100659:	b8 03 00 00 00       	mov    $0x3,%eax
f010065e:	ee                   	out    %al,(%dx)
f010065f:	b2 fc                	mov    $0xfc,%dl
f0100661:	b8 00 00 00 00       	mov    $0x0,%eax
f0100666:	ee                   	out    %al,(%dx)
f0100667:	b2 f9                	mov    $0xf9,%dl
f0100669:	b8 01 00 00 00       	mov    $0x1,%eax
f010066e:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010066f:	b2 fd                	mov    $0xfd,%dl
f0100671:	ec                   	in     (%dx),%al
	// Enable rcv interrupts
	outb(COM1+COM_IER, COM_IER_RDI);

	// Clear any preexisting overrun indications and interrupts
	// Serial port doesn't exist if COM_LSR returns 0xFF
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f0100672:	3c ff                	cmp    $0xff,%al
f0100674:	0f 95 c0             	setne  %al
f0100677:	0f b6 f0             	movzbl %al,%esi
f010067a:	89 35 c4 30 2d f0    	mov    %esi,0xf02d30c4
f0100680:	89 da                	mov    %ebx,%edx
f0100682:	ec                   	in     (%dx),%al
f0100683:	89 ca                	mov    %ecx,%edx
f0100685:	ec                   	in     (%dx),%al
	(void) inb(COM1+COM_IIR);
	(void) inb(COM1+COM_RX);

	// Enable serial interrupts
	if (serial_exists)
f0100686:	85 f6                	test   %esi,%esi
f0100688:	74 1d                	je     f01006a7 <cons_init+0x112>
		irq_setmask_8259A(irq_mask_8259A & ~(1<<4));
f010068a:	0f b7 05 58 f3 11 f0 	movzwl 0xf011f358,%eax
f0100691:	25 ef ff 00 00       	and    $0xffef,%eax
f0100696:	89 04 24             	mov    %eax,(%esp)
f0100699:	e8 f1 2b 00 00       	call   f010328f <irq_setmask_8259A>
{
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f010069e:	83 3d c4 30 2d f0 00 	cmpl   $0x0,0xf02d30c4
f01006a5:	75 0c                	jne    f01006b3 <cons_init+0x11e>
		cprintf("Serial port does not exist!\n");
f01006a7:	c7 04 24 f9 61 10 f0 	movl   $0xf01061f9,(%esp)
f01006ae:	e8 0c 2d 00 00       	call   f01033bf <cprintf>
}
f01006b3:	83 c4 1c             	add    $0x1c,%esp
f01006b6:	5b                   	pop    %ebx
f01006b7:	5e                   	pop    %esi
f01006b8:	5f                   	pop    %edi
f01006b9:	5d                   	pop    %ebp
f01006ba:	c3                   	ret    
f01006bb:	00 00                	add    %al,(%eax)
f01006bd:	00 00                	add    %al,(%eax)
	...

f01006c0 <read_eip>:
// return EIP of caller.
// does not work if inlined.
// putting at the end of the file seems to prevent inlining.
unsigned
read_eip()
{
f01006c0:	55                   	push   %ebp
f01006c1:	89 e5                	mov    %esp,%ebp
	uint32_t callerpc;
	__asm __volatile("movl 4(%%ebp), %0" : "=r" (callerpc));
f01006c3:	8b 45 04             	mov    0x4(%ebp),%eax
	return callerpc;
}
f01006c6:	5d                   	pop    %ebp
f01006c7:	c3                   	ret    

f01006c8 <mon_kerninfo>:
	return 0;
}

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f01006c8:	55                   	push   %ebp
f01006c9:	89 e5                	mov    %esp,%ebp
f01006cb:	83 ec 18             	sub    $0x18,%esp
	extern char _start[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f01006ce:	c7 04 24 30 64 10 f0 	movl   $0xf0106430,(%esp)
f01006d5:	e8 e5 2c 00 00       	call   f01033bf <cprintf>
	cprintf("  _start %08x (virt)  %08x (phys)\n", _start, _start - KERNBASE);
f01006da:	c7 44 24 08 0c 00 10 	movl   $0x10000c,0x8(%esp)
f01006e1:	00 
f01006e2:	c7 44 24 04 0c 00 10 	movl   $0xf010000c,0x4(%esp)
f01006e9:	f0 
f01006ea:	c7 04 24 e0 64 10 f0 	movl   $0xf01064e0,(%esp)
f01006f1:	e8 c9 2c 00 00       	call   f01033bf <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01006f6:	c7 44 24 08 95 61 10 	movl   $0x106195,0x8(%esp)
f01006fd:	00 
f01006fe:	c7 44 24 04 95 61 10 	movl   $0xf0106195,0x4(%esp)
f0100705:	f0 
f0100706:	c7 04 24 04 65 10 f0 	movl   $0xf0106504,(%esp)
f010070d:	e8 ad 2c 00 00       	call   f01033bf <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f0100712:	c7 44 24 08 95 30 2d 	movl   $0x2d3095,0x8(%esp)
f0100719:	00 
f010071a:	c7 44 24 04 95 30 2d 	movl   $0xf02d3095,0x4(%esp)
f0100721:	f0 
f0100722:	c7 04 24 28 65 10 f0 	movl   $0xf0106528,(%esp)
f0100729:	e8 91 2c 00 00       	call   f01033bf <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f010072e:	c7 44 24 08 58 ee 31 	movl   $0x31ee58,0x8(%esp)
f0100735:	00 
f0100736:	c7 44 24 04 58 ee 31 	movl   $0xf031ee58,0x4(%esp)
f010073d:	f0 
f010073e:	c7 04 24 4c 65 10 f0 	movl   $0xf010654c,(%esp)
f0100745:	e8 75 2c 00 00       	call   f01033bf <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f010074a:	b8 57 f2 31 f0       	mov    $0xf031f257,%eax
f010074f:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
f0100754:	89 c2                	mov    %eax,%edx
f0100756:	c1 fa 1f             	sar    $0x1f,%edx
f0100759:	c1 ea 16             	shr    $0x16,%edx
f010075c:	8d 04 02             	lea    (%edx,%eax,1),%eax
f010075f:	c1 f8 0a             	sar    $0xa,%eax
f0100762:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100766:	c7 04 24 70 65 10 f0 	movl   $0xf0106570,(%esp)
f010076d:	e8 4d 2c 00 00       	call   f01033bf <cprintf>
		(end-_start+1023)/1024);
	return 0;
}
f0100772:	b8 00 00 00 00       	mov    $0x0,%eax
f0100777:	c9                   	leave  
f0100778:	c3                   	ret    

f0100779 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100779:	55                   	push   %ebp
f010077a:	89 e5                	mov    %esp,%ebp
f010077c:	83 ec 18             	sub    $0x18,%esp
	int i;

	for (i = 0; i < NCOMMANDS; i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f010077f:	a1 44 66 10 f0       	mov    0xf0106644,%eax
f0100784:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100788:	a1 40 66 10 f0       	mov    0xf0106640,%eax
f010078d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100791:	c7 04 24 49 64 10 f0 	movl   $0xf0106449,(%esp)
f0100798:	e8 22 2c 00 00       	call   f01033bf <cprintf>
f010079d:	a1 50 66 10 f0       	mov    0xf0106650,%eax
f01007a2:	89 44 24 08          	mov    %eax,0x8(%esp)
f01007a6:	a1 4c 66 10 f0       	mov    0xf010664c,%eax
f01007ab:	89 44 24 04          	mov    %eax,0x4(%esp)
f01007af:	c7 04 24 49 64 10 f0 	movl   $0xf0106449,(%esp)
f01007b6:	e8 04 2c 00 00       	call   f01033bf <cprintf>
f01007bb:	a1 5c 66 10 f0       	mov    0xf010665c,%eax
f01007c0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01007c4:	a1 58 66 10 f0       	mov    0xf0106658,%eax
f01007c9:	89 44 24 04          	mov    %eax,0x4(%esp)
f01007cd:	c7 04 24 49 64 10 f0 	movl   $0xf0106449,(%esp)
f01007d4:	e8 e6 2b 00 00       	call   f01033bf <cprintf>
	return 0;
}
f01007d9:	b8 00 00 00 00       	mov    $0x0,%eax
f01007de:	c9                   	leave  
f01007df:	c3                   	ret    

f01007e0 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f01007e0:	55                   	push   %ebp
f01007e1:	89 e5                	mov    %esp,%ebp
f01007e3:	57                   	push   %edi
f01007e4:	56                   	push   %esi
f01007e5:	53                   	push   %ebx
f01007e6:	83 ec 5c             	sub    $0x5c,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f01007e9:	c7 04 24 9c 65 10 f0 	movl   $0xf010659c,(%esp)
f01007f0:	e8 ca 2b 00 00       	call   f01033bf <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f01007f5:	c7 04 24 c0 65 10 f0 	movl   $0xf01065c0,(%esp)
f01007fc:	e8 be 2b 00 00       	call   f01033bf <cprintf>

	if (tf != NULL)
f0100801:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100805:	74 0b                	je     f0100812 <monitor+0x32>
		print_trapframe(tf);
f0100807:	8b 45 08             	mov    0x8(%ebp),%eax
f010080a:	89 04 24             	mov    %eax,(%esp)
f010080d:	e8 14 31 00 00       	call   f0103926 <print_trapframe>

	while (1) {
		buf = readline("K> ");
f0100812:	c7 04 24 52 64 10 f0 	movl   $0xf0106452,(%esp)
f0100819:	e8 d2 46 00 00       	call   f0104ef0 <readline>
f010081e:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100820:	85 c0                	test   %eax,%eax
f0100822:	74 ee                	je     f0100812 <monitor+0x32>
	char *argv[MAXARGS];
	int i;

	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
f0100824:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
f010082b:	be 00 00 00 00       	mov    $0x0,%esi
f0100830:	eb 06                	jmp    f0100838 <monitor+0x58>
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
			*buf++ = 0;
f0100832:	c6 03 00             	movb   $0x0,(%ebx)
f0100835:	83 c3 01             	add    $0x1,%ebx
	// Parse the command buffer into whitespace-separated arguments
	argc = 0;
	argv[argc] = 0;
	while (1) {
		// gobble whitespace
		while (*buf && strchr(WHITESPACE, *buf))
f0100838:	0f b6 03             	movzbl (%ebx),%eax
f010083b:	84 c0                	test   %al,%al
f010083d:	74 6c                	je     f01008ab <monitor+0xcb>
f010083f:	0f be c0             	movsbl %al,%eax
f0100842:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100846:	c7 04 24 56 64 10 f0 	movl   $0xf0106456,(%esp)
f010084d:	e8 dc 48 00 00       	call   f010512e <strchr>
f0100852:	85 c0                	test   %eax,%eax
f0100854:	75 dc                	jne    f0100832 <monitor+0x52>
			*buf++ = 0;
		if (*buf == 0)
f0100856:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100859:	74 50                	je     f01008ab <monitor+0xcb>
			break;

		// save and scan past next arg
		if (argc == MAXARGS-1) {
f010085b:	83 fe 0f             	cmp    $0xf,%esi
f010085e:	66 90                	xchg   %ax,%ax
f0100860:	75 16                	jne    f0100878 <monitor+0x98>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100862:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f0100869:	00 
f010086a:	c7 04 24 5b 64 10 f0 	movl   $0xf010645b,(%esp)
f0100871:	e8 49 2b 00 00       	call   f01033bf <cprintf>
f0100876:	eb 9a                	jmp    f0100812 <monitor+0x32>
			return 0;
		}
		argv[argc++] = buf;
f0100878:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f010087c:	83 c6 01             	add    $0x1,%esi
		while (*buf && !strchr(WHITESPACE, *buf))
f010087f:	0f b6 03             	movzbl (%ebx),%eax
f0100882:	84 c0                	test   %al,%al
f0100884:	75 0c                	jne    f0100892 <monitor+0xb2>
f0100886:	eb b0                	jmp    f0100838 <monitor+0x58>
			buf++;
f0100888:	83 c3 01             	add    $0x1,%ebx
		if (argc == MAXARGS-1) {
			cprintf("Too many arguments (max %d)\n", MAXARGS);
			return 0;
		}
		argv[argc++] = buf;
		while (*buf && !strchr(WHITESPACE, *buf))
f010088b:	0f b6 03             	movzbl (%ebx),%eax
f010088e:	84 c0                	test   %al,%al
f0100890:	74 a6                	je     f0100838 <monitor+0x58>
f0100892:	0f be c0             	movsbl %al,%eax
f0100895:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100899:	c7 04 24 56 64 10 f0 	movl   $0xf0106456,(%esp)
f01008a0:	e8 89 48 00 00       	call   f010512e <strchr>
f01008a5:	85 c0                	test   %eax,%eax
f01008a7:	74 df                	je     f0100888 <monitor+0xa8>
f01008a9:	eb 8d                	jmp    f0100838 <monitor+0x58>
			buf++;
	}
	argv[argc] = 0;
f01008ab:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f01008b2:	00 

	// Lookup and invoke the command
	if (argc == 0)
f01008b3:	85 f6                	test   %esi,%esi
f01008b5:	0f 84 57 ff ff ff    	je     f0100812 <monitor+0x32>
f01008bb:	bb 40 66 10 f0       	mov    $0xf0106640,%ebx
f01008c0:	bf 00 00 00 00       	mov    $0x0,%edi
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
		if (strcmp(argv[0], commands[i].name) == 0)
f01008c5:	8b 03                	mov    (%ebx),%eax
f01008c7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01008cb:	8b 45 a8             	mov    -0x58(%ebp),%eax
f01008ce:	89 04 24             	mov    %eax,(%esp)
f01008d1:	e8 e3 47 00 00       	call   f01050b9 <strcmp>
f01008d6:	85 c0                	test   %eax,%eax
f01008d8:	75 23                	jne    f01008fd <monitor+0x11d>
			return commands[i].func(argc, argv, tf);
f01008da:	6b ff 0c             	imul   $0xc,%edi,%edi
f01008dd:	8b 45 08             	mov    0x8(%ebp),%eax
f01008e0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01008e4:	8d 45 a8             	lea    -0x58(%ebp),%eax
f01008e7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01008eb:	89 34 24             	mov    %esi,(%esp)
f01008ee:	ff 97 48 66 10 f0    	call   *-0xfef99b8(%edi)
		print_trapframe(tf);

	while (1) {
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
f01008f4:	85 c0                	test   %eax,%eax
f01008f6:	78 28                	js     f0100920 <monitor+0x140>
f01008f8:	e9 15 ff ff ff       	jmp    f0100812 <monitor+0x32>
	argv[argc] = 0;

	// Lookup and invoke the command
	if (argc == 0)
		return 0;
	for (i = 0; i < NCOMMANDS; i++) {
f01008fd:	83 c7 01             	add    $0x1,%edi
f0100900:	83 c3 0c             	add    $0xc,%ebx
f0100903:	83 ff 03             	cmp    $0x3,%edi
f0100906:	75 bd                	jne    f01008c5 <monitor+0xe5>
		if (strcmp(argv[0], commands[i].name) == 0)
			return commands[i].func(argc, argv, tf);
	}
	cprintf("Unknown command '%s'\n", argv[0]);
f0100908:	8b 45 a8             	mov    -0x58(%ebp),%eax
f010090b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010090f:	c7 04 24 78 64 10 f0 	movl   $0xf0106478,(%esp)
f0100916:	e8 a4 2a 00 00       	call   f01033bf <cprintf>
f010091b:	e9 f2 fe ff ff       	jmp    f0100812 <monitor+0x32>
		buf = readline("K> ");
		if (buf != NULL)
			if (runcmd(buf, tf) < 0)
				break;
	}
}
f0100920:	83 c4 5c             	add    $0x5c,%esp
f0100923:	5b                   	pop    %ebx
f0100924:	5e                   	pop    %esi
f0100925:	5f                   	pop    %edi
f0100926:	5d                   	pop    %ebp
f0100927:	c3                   	ret    

f0100928 <mon_backtrace>:
	return 0;
}

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100928:	55                   	push   %ebp
f0100929:	89 e5                	mov    %esp,%ebp
f010092b:	57                   	push   %edi
f010092c:	56                   	push   %esi
f010092d:	53                   	push   %ebx
f010092e:	83 ec 5c             	sub    $0x5c,%esp
	 int *presentEbp = (int *)read_ebp();
f0100931:	89 eb                	mov    %ebp,%ebx
             struct Eipdebuginfo info;
           int i = -1;
           int *eip = (int *)read_eip();               
f0100933:	e8 88 fd ff ff       	call   f01006c0 <read_eip>
            while(presentEbp!= 0)
f0100938:	85 db                	test   %ebx,%ebx
f010093a:	0f 84 bf 00 00 00    	je     f01009ff <mon_backtrace+0xd7>
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
	 int *presentEbp = (int *)read_ebp();
             struct Eipdebuginfo info;
           int i = -1;
           int *eip = (int *)read_eip();               
f0100940:	89 c6                	mov    %eax,%esi
f0100942:	89 65 c4             	mov    %esp,-0x3c(%ebp)
            while(presentEbp!= 0)
               { 
                 cprintf("ebp %x eip %x args %08x %08x %08x %08x %08x \n", presentEbp,eip,*(presentEbp+2),*(presentEbp+3),*(presentEbp+4),*(presentEbp+5),*(presentEbp+6));
f0100945:	8b 43 18             	mov    0x18(%ebx),%eax
f0100948:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f010094c:	8b 43 14             	mov    0x14(%ebx),%eax
f010094f:	89 44 24 18          	mov    %eax,0x18(%esp)
f0100953:	8b 43 10             	mov    0x10(%ebx),%eax
f0100956:	89 44 24 14          	mov    %eax,0x14(%esp)
f010095a:	8b 43 0c             	mov    0xc(%ebx),%eax
f010095d:	89 44 24 10          	mov    %eax,0x10(%esp)
f0100961:	8b 43 08             	mov    0x8(%ebx),%eax
f0100964:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100968:	89 74 24 08          	mov    %esi,0x8(%esp)
f010096c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100970:	c7 04 24 e8 65 10 f0 	movl   $0xf01065e8,(%esp)
f0100977:	e8 43 2a 00 00       	call   f01033bf <cprintf>
                   i = debuginfo_eip((unsigned int)eip,&info);
f010097c:	8d 45 d0             	lea    -0x30(%ebp),%eax
f010097f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100983:	89 34 24             	mov    %esi,(%esp)
f0100986:	e8 93 3c 00 00       	call   f010461e <debuginfo_eip>
                   char function_Name[(info.eip_fn_namelen)+1];
f010098b:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010098e:	83 c0 1f             	add    $0x1f,%eax
f0100991:	83 e0 f0             	and    $0xfffffff0,%eax
f0100994:	29 c4                	sub    %eax,%esp
f0100996:	8d 7c 24 2f          	lea    0x2f(%esp),%edi
f010099a:	83 e7 f0             	and    $0xfffffff0,%edi
                         int j=0;
                  while(*(info.eip_fn_name)!=':')
f010099d:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01009a0:	0f b6 08             	movzbl (%eax),%ecx
f01009a3:	ba 00 00 00 00       	mov    $0x0,%edx
f01009a8:	80 f9 3a             	cmp    $0x3a,%cl
f01009ab:	74 14                	je     f01009c1 <mon_backtrace+0x99>
                   {
                    function_Name[j] = *info.eip_fn_name;
f01009ad:	88 0c 17             	mov    %cl,(%edi,%edx,1)
                      info.eip_fn_name++;
f01009b0:	83 c0 01             	add    $0x1,%eax
f01009b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
                      j++;   
f01009b6:	83 c2 01             	add    $0x1,%edx
               { 
                 cprintf("ebp %x eip %x args %08x %08x %08x %08x %08x \n", presentEbp,eip,*(presentEbp+2),*(presentEbp+3),*(presentEbp+4),*(presentEbp+5),*(presentEbp+6));
                   i = debuginfo_eip((unsigned int)eip,&info);
                   char function_Name[(info.eip_fn_namelen)+1];
                         int j=0;
                  while(*(info.eip_fn_name)!=':')
f01009b9:	0f b6 08             	movzbl (%eax),%ecx
f01009bc:	80 f9 3a             	cmp    $0x3a,%cl
f01009bf:	75 ec                	jne    f01009ad <mon_backtrace+0x85>
                   {
                    function_Name[j] = *info.eip_fn_name;
                      info.eip_fn_name++;
                      j++;   
                   }
                   function_Name[j]='\0';
f01009c1:	c6 04 17 00          	movb   $0x0,(%edi,%edx,1)
                  
                
              cprintf(" %s:%d: %s+%u\n",info.eip_file,info.eip_line,function_Name,eip-(info.eip_fn_addr));
f01009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01009c8:	c1 e0 02             	shl    $0x2,%eax
f01009cb:	29 c6                	sub    %eax,%esi
f01009cd:	89 74 24 10          	mov    %esi,0x10(%esp)
f01009d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
f01009d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01009d8:	89 44 24 08          	mov    %eax,0x8(%esp)
f01009dc:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01009df:	89 44 24 04          	mov    %eax,0x4(%esp)
f01009e3:	c7 04 24 8e 64 10 f0 	movl   $0xf010648e,(%esp)
f01009ea:	e8 d0 29 00 00       	call   f01033bf <cprintf>
                  eip = (int *)*(presentEbp+1);
f01009ef:	8b 73 04             	mov    0x4(%ebx),%esi
      
 presentEbp = (int *)*presentEbp;   
f01009f2:	8b 1b                	mov    (%ebx),%ebx
f01009f4:	8b 65 c4             	mov    -0x3c(%ebp),%esp
{
	 int *presentEbp = (int *)read_ebp();
             struct Eipdebuginfo info;
           int i = -1;
           int *eip = (int *)read_eip();               
            while(presentEbp!= 0)
f01009f7:	85 db                	test   %ebx,%ebx
f01009f9:	0f 85 43 ff ff ff    	jne    f0100942 <mon_backtrace+0x1a>
 presentEbp = (int *)*presentEbp;   

                }
                               
	return 0;
}
f01009ff:	b8 00 00 00 00       	mov    $0x0,%eax
f0100a04:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100a07:	5b                   	pop    %ebx
f0100a08:	5e                   	pop    %esi
f0100a09:	5f                   	pop    %edi
f0100a0a:	5d                   	pop    %ebp
f0100a0b:	c3                   	ret    
f0100a0c:	00 00                	add    %al,(%eax)
	...

f0100a10 <boot_alloc>:
// This function may ONLY be used during initialization,
// before the page_free_list has been set up.
// 
static void*
boot_alloc(uint32_t n, uint32_t align)
{
f0100a10:	55                   	push   %ebp
f0100a11:	89 e5                	mov    %esp,%ebp
f0100a13:	83 ec 08             	sub    $0x8,%esp
f0100a16:	89 1c 24             	mov    %ebx,(%esp)
f0100a19:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100a1d:	89 c6                	mov    %eax,%esi
f0100a1f:	89 d1                	mov    %edx,%ecx
	// Initialize boot_freemem if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment -
	// i.e., the first virtual address that the linker
	// did _not_ assign to any kernel code or global variables.
	if (boot_freemem == 0)
f0100a21:	83 3d f4 32 2d f0 00 	cmpl   $0x0,0xf02d32f4
f0100a28:	75 0a                	jne    f0100a34 <boot_alloc+0x24>
	{	
         boot_freemem = end;
f0100a2a:	c7 05 f4 32 2d f0 58 	movl   $0xf031ee58,0xf02d32f4
f0100a31:	ee 31 f0 
	//	Step 2: save current value of boot_freemem as allocated chunk
	//	Step 3: increase boot_freemem to record allocation
	//	Step 4: return allocated chunk

           //cprintf("HI here in boot_alloc");
         boot_freemem = ROUNDUP(boot_freemem,align);
f0100a34:	a1 f4 32 2d f0       	mov    0xf02d32f4,%eax
f0100a39:	8d 5c 08 ff          	lea    -0x1(%eax,%ecx,1),%ebx
f0100a3d:	89 d8                	mov    %ebx,%eax
f0100a3f:	ba 00 00 00 00       	mov    $0x0,%edx
f0100a44:	f7 f1                	div    %ecx
f0100a46:	29 d3                	sub    %edx,%ebx
               
               //cprintf("%x", boot_freemem);         
               v=boot_freemem;
               boot_freemem+=ROUNDUP(n , align);
f0100a48:	8d 74 0e ff          	lea    -0x1(%esi,%ecx,1),%esi
f0100a4c:	89 f0                	mov    %esi,%eax
f0100a4e:	ba 00 00 00 00       	mov    $0x0,%edx
f0100a53:	f7 f1                	div    %ecx
f0100a55:	29 d6                	sub    %edx,%esi
f0100a57:	8d 34 33             	lea    (%ebx,%esi,1),%esi
f0100a5a:	89 35 f4 32 2d f0    	mov    %esi,0xf02d32f4
               //cprintf("%x",boot_freemem);         
	       return v;
}
f0100a60:	89 d8                	mov    %ebx,%eax
f0100a62:	8b 1c 24             	mov    (%esp),%ebx
f0100a65:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100a69:	89 ec                	mov    %ebp,%esp
f0100a6b:	5d                   	pop    %ebp
f0100a6c:	c3                   	ret    

f0100a6d <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct Page *pp)
{
f0100a6d:	55                   	push   %ebp
f0100a6e:	89 e5                	mov    %esp,%ebp
f0100a70:	8b 45 08             	mov    0x8(%ebp),%eax
 LIST_INSERT_HEAD(&page_free_list, pp, pp_link);
f0100a73:	8b 15 f8 32 2d f0    	mov    0xf02d32f8,%edx
f0100a79:	89 10                	mov    %edx,(%eax)
f0100a7b:	85 d2                	test   %edx,%edx
f0100a7d:	74 09                	je     f0100a88 <page_free+0x1b>
f0100a7f:	8b 15 f8 32 2d f0    	mov    0xf02d32f8,%edx
f0100a85:	89 42 04             	mov    %eax,0x4(%edx)
f0100a88:	a3 f8 32 2d f0       	mov    %eax,0xf02d32f8
f0100a8d:	c7 40 04 f8 32 2d f0 	movl   $0xf02d32f8,0x4(%eax)
}
f0100a94:	5d                   	pop    %ebp
f0100a95:	c3                   	ret    

f0100a96 <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no morecprintf("\n\nCHECK%x %x\n\n",check_va2pa(boot_pgdir, PGSIZE),page2pa(pp2)); refs.
//
void
page_decref(struct Page* pp)
{
f0100a96:	55                   	push   %ebp
f0100a97:	89 e5                	mov    %esp,%ebp
f0100a99:	83 ec 04             	sub    $0x4,%esp
f0100a9c:	8b 45 08             	mov    0x8(%ebp),%eax
// cprintf("Here in dec ref");	
if (--pp->pp_ref == 0)
f0100a9f:	0f b7 50 08          	movzwl 0x8(%eax),%edx
f0100aa3:	83 ea 01             	sub    $0x1,%edx
f0100aa6:	66 89 50 08          	mov    %dx,0x8(%eax)
f0100aaa:	66 85 d2             	test   %dx,%dx
f0100aad:	75 08                	jne    f0100ab7 <page_decref+0x21>
		page_free(pp);
f0100aaf:	89 04 24             	mov    %eax,(%esp)
f0100ab2:	e8 b6 ff ff ff       	call   f0100a6d <page_free>
//else
 //cprintf("Here in dec ref%d",pp->pp_ref);	

}
f0100ab7:	c9                   	leave  
f0100ab8:	c3                   	ret    

f0100ab9 <tlb_invalidate>:
// Invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
//
void
tlb_invalidate(pde_t *pgdir, void *va)
{
f0100ab9:	55                   	push   %ebp
f0100aba:	89 e5                	mov    %esp,%ebp
	// Flush the entry only if we're modifying the current address space.
	if (!curenv || curenv->env_pgdir == pgdir)
f0100abc:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0100ac1:	85 c0                	test   %eax,%eax
f0100ac3:	74 08                	je     f0100acd <tlb_invalidate+0x14>
f0100ac5:	8b 55 08             	mov    0x8(%ebp),%edx
f0100ac8:	39 50 5c             	cmp    %edx,0x5c(%eax)
f0100acb:	75 06                	jne    f0100ad3 <tlb_invalidate+0x1a>
}

static __inline void 
invlpg(void *addr)
{ 
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0100acd:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100ad0:	0f 01 38             	invlpg (%eax)
		invlpg(va);
}
f0100ad3:	5d                   	pop    %ebp
f0100ad4:	c3                   	ret    

f0100ad5 <page_init>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f0100ad5:	55                   	push   %ebp
f0100ad6:	89 e5                	mov    %esp,%ebp
f0100ad8:	56                   	push   %esi
f0100ad9:	53                   	push   %ebx
f0100ada:	83 ec 10             	sub    $0x10,%esp
	int i;
  /* cprintf("%x  %x  %x  %x  %x %d %d %d %d %d",_start-KERNBASE,end-KERNBASE,boot_freemem-KERNBASE,IOPHYSMEM,EXTPHYSMEM,PPN(_start-KERNBASE),PPN(end-KERNBASE),PPN(IOPHYSMEM),PPN(EXTPHYSMEM),PPN(boot_freemem-KERNBASE));
cprintf("/n%x  %x  %x  %x  %x %d %d %d %d %d",_start-KERNBASE,end-KERNBASE,boot_freemem-KERNBASE,IOPHYSMEM,EXTPHYSMEM,PPN(_start-KERNBASE),PPN(end-KERNBASE-1),PPN(IOPHYSMEM),PPN(EXTPHYSMEM-1),PPN(boot_freemem-KERNBASE-1));
cprintf("%u",boot_freemem);
    */
         cprintf("\n\n Pages%x %x %u\n\n",pages, pages+1, (pages+1)-(pages));            
f0100add:	a1 b8 3f 2d f0       	mov    0xf02d3fb8,%eax
f0100ae2:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
f0100ae9:	00 
f0100aea:	8d 50 0c             	lea    0xc(%eax),%edx
f0100aed:	89 54 24 08          	mov    %edx,0x8(%esp)
f0100af1:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100af5:	c7 04 24 64 66 10 f0 	movl   $0xf0106664,(%esp)
f0100afc:	e8 be 28 00 00       	call   f01033bf <cprintf>
	LIST_INIT(&page_free_list);
f0100b01:	c7 05 f8 32 2d f0 00 	movl   $0x0,0xf02d32f8
f0100b08:	00 00 00 
	for (i = 0; i < npage; i++) {
f0100b0b:	83 3d ac 3f 2d f0 00 	cmpl   $0x0,0xf02d3fac
f0100b12:	0f 84 81 00 00 00    	je     f0100b99 <page_init+0xc4>
          
          if( i == 0)
{             
             continue;
} 
              if((i>=PPN(ROUNDUP(IOPHYSMEM,PGSIZE))) && (i < PPN(ROUNDUP(boot_freemem-KERNBASE,PGSIZE))))	
f0100b18:	8b 1d f4 32 2d f0    	mov    0xf02d32f4,%ebx
f0100b1e:	81 c3 ff 0f 00 10    	add    $0x10000fff,%ebx
f0100b24:	c1 eb 0c             	shr    $0xc,%ebx
f0100b27:	ba 0c 00 00 00       	mov    $0xc,%edx
f0100b2c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100b31:	eb 59                	jmp    f0100b8c <page_init+0xb7>
    */
         cprintf("\n\n Pages%x %x %u\n\n",pages, pages+1, (pages+1)-(pages));            
	LIST_INIT(&page_free_list);
	for (i = 0; i < npage; i++) {
          
          if( i == 0)
f0100b33:	85 c0                	test   %eax,%eax
f0100b35:	74 52                	je     f0100b89 <page_init+0xb4>
{             
             continue;
} 
              if((i>=PPN(ROUNDUP(IOPHYSMEM,PGSIZE))) && (i < PPN(ROUNDUP(boot_freemem-KERNBASE,PGSIZE))))	
f0100b37:	81 f9 9f 00 00 00    	cmp    $0x9f,%ecx
f0100b3d:	76 04                	jbe    f0100b43 <page_init+0x6e>
f0100b3f:	39 d9                	cmp    %ebx,%ecx
f0100b41:	72 46                	jb     f0100b89 <page_init+0xb4>
           	{ 
                        
                    continue;
                }
                pages[i].pp_ref = 0;
f0100b43:	8b 0d b8 3f 2d f0    	mov    0xf02d3fb8,%ecx
f0100b49:	66 c7 44 11 08 00 00 	movw   $0x0,0x8(%ecx,%edx,1)
		LIST_INSERT_HEAD(&page_free_list, &pages[i], pp_link);
f0100b50:	8b 0d f8 32 2d f0    	mov    0xf02d32f8,%ecx
f0100b56:	8b 35 b8 3f 2d f0    	mov    0xf02d3fb8,%esi
f0100b5c:	89 0c 16             	mov    %ecx,(%esi,%edx,1)
f0100b5f:	85 c9                	test   %ecx,%ecx
f0100b61:	74 11                	je     f0100b74 <page_init+0x9f>
f0100b63:	89 d6                	mov    %edx,%esi
f0100b65:	03 35 b8 3f 2d f0    	add    0xf02d3fb8,%esi
f0100b6b:	8b 0d f8 32 2d f0    	mov    0xf02d32f8,%ecx
f0100b71:	89 71 04             	mov    %esi,0x4(%ecx)
f0100b74:	89 d1                	mov    %edx,%ecx
f0100b76:	03 0d b8 3f 2d f0    	add    0xf02d3fb8,%ecx
f0100b7c:	89 0d f8 32 2d f0    	mov    %ecx,0xf02d32f8
f0100b82:	c7 41 04 f8 32 2d f0 	movl   $0xf02d32f8,0x4(%ecx)
f0100b89:	83 c2 0c             	add    $0xc,%edx
cprintf("/n%x  %x  %x  %x  %x %d %d %d %d %d",_start-KERNBASE,end-KERNBASE,boot_freemem-KERNBASE,IOPHYSMEM,EXTPHYSMEM,PPN(_start-KERNBASE),PPN(end-KERNBASE-1),PPN(IOPHYSMEM),PPN(EXTPHYSMEM-1),PPN(boot_freemem-KERNBASE-1));
cprintf("%u",boot_freemem);
    */
         cprintf("\n\n Pages%x %x %u\n\n",pages, pages+1, (pages+1)-(pages));            
	LIST_INIT(&page_free_list);
	for (i = 0; i < npage; i++) {
f0100b8c:	83 c0 01             	add    $0x1,%eax
f0100b8f:	89 c1                	mov    %eax,%ecx
f0100b91:	39 05 ac 3f 2d f0    	cmp    %eax,0xf02d3fac
f0100b97:	77 9a                	ja     f0100b33 <page_init+0x5e>

//cprintf("\nno of pages %d\n",npage);
//cprintf("\nno of pages %u\n",pages);


}
f0100b99:	83 c4 10             	add    $0x10,%esp
f0100b9c:	5b                   	pop    %ebx
f0100b9d:	5e                   	pop    %esi
f0100b9e:	5d                   	pop    %ebp
f0100b9f:	c3                   	ret    

f0100ba0 <check_va2pa>:
// this functionality for us!  We define our own version to help check
// the check_boot_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0100ba0:	55                   	push   %ebp
f0100ba1:	89 e5                	mov    %esp,%ebp
f0100ba3:	83 ec 18             	sub    $0x18,%esp
	pte_t *p;
	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
f0100ba6:	89 d1                	mov    %edx,%ecx
f0100ba8:	c1 e9 16             	shr    $0x16,%ecx
f0100bab:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100bae:	a8 01                	test   $0x1,%al
f0100bb0:	74 4d                	je     f0100bff <check_va2pa+0x5f>
		return ~0;
        //cprintf("\nOI\n");
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100bb2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100bb7:	89 c1                	mov    %eax,%ecx
f0100bb9:	c1 e9 0c             	shr    $0xc,%ecx
f0100bbc:	3b 0d ac 3f 2d f0    	cmp    0xf02d3fac,%ecx
f0100bc2:	72 20                	jb     f0100be4 <check_va2pa+0x44>
f0100bc4:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100bc8:	c7 44 24 08 00 69 10 	movl   $0xf0106900,0x8(%esp)
f0100bcf:	f0 
f0100bd0:	c7 44 24 04 e3 01 00 	movl   $0x1e3,0x4(%esp)
f0100bd7:	00 
f0100bd8:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0100bdf:	e8 a1 f4 ff ff       	call   f0100085 <_panic>
	//cprintf("\n permissionPTX%xPDX %x %x\n",p[PTX(va)],pgdir[PDX(va)], PTE_P);
	
         if (!(p[PTX(va)] & PTE_P))
f0100be4:	c1 ea 0c             	shr    $0xc,%edx
f0100be7:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100bed:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100bf4:	a8 01                	test   $0x1,%al
f0100bf6:	74 07                	je     f0100bff <check_va2pa+0x5f>
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f0100bf8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100bfd:	eb 05                	jmp    f0100c04 <check_va2pa+0x64>
f0100bff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
f0100c04:	c9                   	leave  
f0100c05:	c3                   	ret    

f0100c06 <page_alloc>:
//   -E_NO_MEM -- otherwise 
//
// Hint: use LIST_FIRST, LIST_REMOVE, and page_initpp
int
page_alloc(struct Page **pp_store)
{
f0100c06:	55                   	push   %ebp
f0100c07:	89 e5                	mov    %esp,%ebp
f0100c09:	83 ec 18             	sub    $0x18,%esp
f0100c0c:	8b 4d 08             	mov    0x8(%ebp),%ecx

    struct Page *page=LIST_FIRST(&page_free_list);	// Fill this function in
f0100c0f:	8b 15 f8 32 2d f0    	mov    0xf02d32f8,%edx
     if(page == NULL)
f0100c15:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0100c1a:	85 d2                	test   %edx,%edx
f0100c1c:	74 36                	je     f0100c54 <page_alloc+0x4e>
         return -E_NO_MEM;
    *pp_store=page;
f0100c1e:	89 11                	mov    %edx,(%ecx)
 
  LIST_REMOVE(*pp_store,pp_link);
f0100c20:	8b 02                	mov    (%edx),%eax
f0100c22:	85 c0                	test   %eax,%eax
f0100c24:	74 06                	je     f0100c2c <page_alloc+0x26>
f0100c26:	8b 52 04             	mov    0x4(%edx),%edx
f0100c29:	89 50 04             	mov    %edx,0x4(%eax)
f0100c2c:	8b 01                	mov    (%ecx),%eax
f0100c2e:	8b 50 04             	mov    0x4(%eax),%edx
f0100c31:	8b 00                	mov    (%eax),%eax
f0100c33:	89 02                	mov    %eax,(%edx)
// Note that the corresponding physical page is NOT initialized!
//
static void
page_initpp(struct Page *pp)
{
	memset(pp, 0, sizeof(*pp));
f0100c35:	c7 44 24 08 0c 00 00 	movl   $0xc,0x8(%esp)
f0100c3c:	00 
f0100c3d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100c44:	00 
f0100c45:	8b 01                	mov    (%ecx),%eax
f0100c47:	89 04 24             	mov    %eax,(%esp)
f0100c4a:	e8 37 45 00 00       	call   f0105186 <memset>
f0100c4f:	b8 00 00 00 00       	mov    $0x0,%eax
   return 0;
 
//LIST_REMOVE(*pp_store);    

	
}
f0100c54:	c9                   	leave  
f0100c55:	c3                   	ret    

f0100c56 <pgdir_walk>:
// and the page table, so it's safe to leave permissions in the page
// more permissive than strictly necessary.

pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
f0100c56:	55                   	push   %ebp
f0100c57:	89 e5                	mov    %esp,%ebp
f0100c59:	83 ec 28             	sub    $0x28,%esp
f0100c5c:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f0100c5f:	89 75 fc             	mov    %esi,-0x4(%ebp)
f0100c62:	8b 5d 0c             	mov    0xc(%ebp),%ebx
   unsigned int pageTableIndex = PDX(va);
   unsigned int pageTableEntryIndex=PTX(va);
f0100c65:	89 de                	mov    %ebx,%esi
f0100c67:	c1 ee 0c             	shr    $0xc,%esi
f0100c6a:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
     struct Page *page_Table;
      pde_t * pageTable=pgdir+pageTableIndex;
f0100c70:	c1 eb 16             	shr    $0x16,%ebx
f0100c73:	c1 e3 02             	shl    $0x2,%ebx
f0100c76:	03 5d 08             	add    0x8(%ebp),%ebx
      pte_t* pageTableEntry=NULL;
     //physaddr_t pageTablePhysicalAddress;
 //cprintf("\nOFFSETS%x    %x\n",PDX(va),PTX(va));
    
        if((*(pageTable))==0)
f0100c79:	8b 03                	mov    (%ebx),%eax
f0100c7b:	85 c0                	test   %eax,%eax
f0100c7d:	0f 85 94 00 00 00    	jne    f0100d17 <pgdir_walk+0xc1>
       {
           if(create==0)    
f0100c83:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0100c87:	0f 84 c5 00 00 00    	je     f0100d52 <pgdir_walk+0xfc>
              return NULL;
           else
          {    
             if(page_alloc(&page_Table)==0)
f0100c8d:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0100c90:	89 04 24             	mov    %eax,(%esp)
f0100c93:	e8 6e ff ff ff       	call   f0100c06 <page_alloc>
f0100c98:	85 c0                	test   %eax,%eax
f0100c9a:	0f 85 b2 00 00 00    	jne    f0100d52 <pgdir_walk+0xfc>
                {
                    // for understanding pageTablePhysicalAddress = page2pa(page_Table);
                    page_Table->pp_ref=1;
f0100ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100ca3:	66 c7 40 08 01 00    	movw   $0x1,0x8(%eax)
                    //memset(va,0,PGSIZE);
                    //or the pgdir[pageTableIndex] 
             //cprintf("Here in creating Page");                   
                   *(pageTable)=page2pa(page_Table)|PTE_W|PTE_U|PTE_P;
f0100ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100cac:	2b 05 b8 3f 2d f0    	sub    0xf02d3fb8,%eax
f0100cb2:	c1 f8 02             	sar    $0x2,%eax
f0100cb5:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0100cbb:	c1 e0 0c             	shl    $0xc,%eax
f0100cbe:	83 c8 07             	or     $0x7,%eax
f0100cc1:	89 03                	mov    %eax,(%ebx)
                    pageTableEntry=(pte_t *)(KADDR(PTE_ADDR(*(pageTable))))+pageTableEntryIndex;
f0100cc3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100cc8:	89 c2                	mov    %eax,%edx
f0100cca:	c1 ea 0c             	shr    $0xc,%edx
f0100ccd:	3b 15 ac 3f 2d f0    	cmp    0xf02d3fac,%edx
f0100cd3:	72 20                	jb     f0100cf5 <pgdir_walk+0x9f>
f0100cd5:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100cd9:	c7 44 24 08 00 69 10 	movl   $0xf0106900,0x8(%esp)
f0100ce0:	f0 
f0100ce1:	c7 44 24 04 97 02 00 	movl   $0x297,0x4(%esp)
f0100ce8:	00 
f0100ce9:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0100cf0:	e8 90 f3 ff ff       	call   f0100085 <_panic>
f0100cf5:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100cfa:	8d 1c b0             	lea    (%eax,%esi,4),%ebx
                    memset(KADDR(PTE_ADDR(*(pageTable))),0,PGSIZE);
f0100cfd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0100d04:	00 
f0100d05:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0100d0c:	00 
f0100d0d:	89 04 24             	mov    %eax,(%esp)
f0100d10:	e8 71 44 00 00       	call   f0105186 <memset>
               //     cprintf("inside directory%u",*(pageTableEntry+3));  
                    return pageTableEntry;
f0100d15:	eb 40                	jmp    f0100d57 <pgdir_walk+0x101>
             else
             return NULL;
          }
       }
       else
        return ((pte_t *)(KADDR(PTE_ADDR(*(pageTable))))+pageTableEntryIndex);          
f0100d17:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100d1c:	89 c2                	mov    %eax,%edx
f0100d1e:	c1 ea 0c             	shr    $0xc,%edx
f0100d21:	3b 15 ac 3f 2d f0    	cmp    0xf02d3fac,%edx
f0100d27:	72 20                	jb     f0100d49 <pgdir_walk+0xf3>
f0100d29:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100d2d:	c7 44 24 08 00 69 10 	movl   $0xf0106900,0x8(%esp)
f0100d34:	f0 
f0100d35:	c7 44 24 04 a1 02 00 	movl   $0x2a1,0x4(%esp)
f0100d3c:	00 
f0100d3d:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0100d44:	e8 3c f3 ff ff       	call   f0100085 <_panic>
f0100d49:	8d 9c b0 00 00 00 f0 	lea    -0x10000000(%eax,%esi,4),%ebx
f0100d50:	eb 05                	jmp    f0100d57 <pgdir_walk+0x101>
f0100d52:	bb 00 00 00 00       	mov    $0x0,%ebx

}
f0100d57:	89 d8                	mov    %ebx,%eax
f0100d59:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f0100d5c:	8b 75 fc             	mov    -0x4(%ebp),%esi
f0100d5f:	89 ec                	mov    %ebp,%esp
f0100d61:	5d                   	pop    %ebp
f0100d62:	c3                   	ret    

f0100d63 <user_mem_check>:
//


int
user_mem_check(struct Env *env, const void *va, size_t len, int perm)
{
f0100d63:	55                   	push   %ebp
f0100d64:	89 e5                	mov    %esp,%ebp
f0100d66:	57                   	push   %edi
f0100d67:	56                   	push   %esi
f0100d68:	53                   	push   %ebx
f0100d69:	83 ec 3c             	sub    $0x3c,%esp
f0100d6c:	8b 7d 08             	mov    0x8(%ebp),%edi
	// LAB 3: Your code here. 
        //cprintf("\nhere checking%x\n",va);  
          if((uint32_t)va>ULIM)
f0100d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100d72:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0100d75:	3d 00 00 80 ef       	cmp    $0xef800000,%eax
f0100d7a:	76 0f                	jbe    f0100d8b <user_mem_check+0x28>
              {user_mem_check_addr=(uint32_t)va;  
f0100d7c:	a3 fc 32 2d f0       	mov    %eax,0xf02d32fc
f0100d81:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
              return -E_FAULT;
f0100d86:	e9 b1 00 00 00       	jmp    f0100e3c <user_mem_check+0xd9>
                }
          uint32_t startva=(uint32_t)ROUNDDOWN(va,PGSIZE);
f0100d8b:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0100d8e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100d94:	89 55 dc             	mov    %edx,-0x24(%ebp)
          len=ROUNDUP(len,PGSIZE);
f0100d97:	8b 45 10             	mov    0x10(%ebp),%eax
f0100d9a:	05 ff 0f 00 00       	add    $0xfff,%eax
        
      // cprintf("In Assert>>> va==%x    len==%x\n",va,len);
       int i=0;
       uint32_t t; 
           for(;i<len;i+=PGSIZE)
f0100d9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100da4:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0100da7:	0f 84 8a 00 00 00    	je     f0100e37 <user_mem_check+0xd4>
f0100dad:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0100db0:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0100db3:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100db8:	be 00 00 00 00       	mov    $0x0,%esi
                          t=(uint32_t)startva;
                 pte_t *pageTableEntry=pgdir_walk(env->env_pgdir,(void *)(startva+i),0);
                  if(pageTableEntry!=NULL && *(pageTableEntry)!=0)
                     {
                          
                         if((*(pageTableEntry) & (perm|PTE_P))!=(perm|PTE_P))
f0100dbd:	8b 45 14             	mov    0x14(%ebp),%eax
f0100dc0:	83 c8 01             	or     $0x1,%eax
f0100dc3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      // cprintf("In Assert>>> va==%x    len==%x\n",va,len);
       int i=0;
       uint32_t t; 
           for(;i<len;i+=PGSIZE)
               {
                      if(i==0)
f0100dc6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0100dc9:	eb 10                	jmp    f0100ddb <user_mem_check+0x78>
f0100dcb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0100dce:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100dd1:	85 db                	test   %ebx,%ebx
f0100dd3:	75 06                	jne    f0100ddb <user_mem_check+0x78>
f0100dd5:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0100dd8:	89 45 e0             	mov    %eax,-0x20(%ebp)
                         t=(uint32_t)va;
                       else
                          t=(uint32_t)startva;
                 pte_t *pageTableEntry=pgdir_walk(env->env_pgdir,(void *)(startva+i),0);
f0100ddb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100de2:	00 
f0100de3:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100de6:	8d 04 16             	lea    (%esi,%edx,1),%eax
f0100de9:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ded:	8b 47 5c             	mov    0x5c(%edi),%eax
f0100df0:	89 04 24             	mov    %eax,(%esp)
f0100df3:	e8 5e fe ff ff       	call   f0100c56 <pgdir_walk>
                  if(pageTableEntry!=NULL && *(pageTableEntry)!=0)
f0100df8:	85 c0                	test   %eax,%eax
f0100dfa:	74 1e                	je     f0100e1a <user_mem_check+0xb7>
f0100dfc:	8b 00                	mov    (%eax),%eax
f0100dfe:	85 c0                	test   %eax,%eax
f0100e00:	74 18                	je     f0100e1a <user_mem_check+0xb7>
                     {
                          
                         if((*(pageTableEntry) & (perm|PTE_P))!=(perm|PTE_P))
f0100e02:	23 45 e4             	and    -0x1c(%ebp),%eax
f0100e05:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
f0100e08:	74 20                	je     f0100e2a <user_mem_check+0xc7>
                           {
                               
                               user_mem_check_addr= (uint32_t)t+i;
f0100e0a:	03 75 e0             	add    -0x20(%ebp),%esi
f0100e0d:	89 35 fc 32 2d f0    	mov    %esi,0xf02d32fc
f0100e13:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
                               return -E_FAULT;
f0100e18:	eb 22                	jmp    f0100e3c <user_mem_check+0xd9>
                           }
                    }
                     else
                            {user_mem_check_addr= (uint32_t)t+i;
f0100e1a:	03 75 e0             	add    -0x20(%ebp),%esi
f0100e1d:	89 35 fc 32 2d f0    	mov    %esi,0xf02d32fc
f0100e23:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
                             return -E_FAULT;
f0100e28:	eb 12                	jmp    f0100e3c <user_mem_check+0xd9>
          len=ROUNDUP(len,PGSIZE);
        
      // cprintf("In Assert>>> va==%x    len==%x\n",va,len);
       int i=0;
       uint32_t t; 
           for(;i<len;i+=PGSIZE)
f0100e2a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0100e30:	89 de                	mov    %ebx,%esi
f0100e32:	39 5d d8             	cmp    %ebx,-0x28(%ebp)
f0100e35:	77 94                	ja     f0100dcb <user_mem_check+0x68>
f0100e37:	b8 00 00 00 00       	mov    $0x0,%eax
                     else
                            {user_mem_check_addr= (uint32_t)t+i;
                             return -E_FAULT;
               }}
	return 0;
}
f0100e3c:	83 c4 3c             	add    $0x3c,%esp
f0100e3f:	5b                   	pop    %ebx
f0100e40:	5e                   	pop    %esi
f0100e41:	5f                   	pop    %edi
f0100e42:	5d                   	pop    %ebp
f0100e43:	c3                   	ret    

f0100e44 <user_mem_assert>:
// If it cannot, 'env' is destroyed and, if env is the current
// environment, this function will not return.
//
void
user_mem_assert(struct Env *env, const void *va, size_t len, int perm)
{
f0100e44:	55                   	push   %ebp
f0100e45:	89 e5                	mov    %esp,%ebp
f0100e47:	53                   	push   %ebx
f0100e48:	83 ec 14             	sub    $0x14,%esp
f0100e4b:	8b 5d 08             	mov    0x8(%ebp),%ebx
      //cprintf("here asserting memory\n");
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f0100e4e:	8b 45 14             	mov    0x14(%ebp),%eax
f0100e51:	83 c8 04             	or     $0x4,%eax
f0100e54:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100e58:	8b 45 10             	mov    0x10(%ebp),%eax
f0100e5b:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100e5f:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100e62:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100e66:	89 1c 24             	mov    %ebx,(%esp)
f0100e69:	e8 f5 fe ff ff       	call   f0100d63 <user_mem_check>
f0100e6e:	85 c0                	test   %eax,%eax
f0100e70:	79 24                	jns    f0100e96 <user_mem_assert+0x52>
		cprintf("[%08x] user_mem_check assertion failure for "
f0100e72:	a1 fc 32 2d f0       	mov    0xf02d32fc,%eax
f0100e77:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100e7b:	8b 43 4c             	mov    0x4c(%ebx),%eax
f0100e7e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100e82:	c7 04 24 24 69 10 f0 	movl   $0xf0106924,(%esp)
f0100e89:	e8 31 25 00 00       	call   f01033bf <cprintf>
			"va %08x\n", env->env_id, user_mem_check_addr);
		env_destroy(env);	// may not return
f0100e8e:	89 1c 24             	mov    %ebx,(%esp)
f0100e91:	e8 48 20 00 00       	call   f0102ede <env_destroy>
	}
}
f0100e96:	83 c4 14             	add    $0x14,%esp
f0100e99:	5b                   	pop    %ebx
f0100e9a:	5d                   	pop    %ebp
f0100e9b:	c3                   	ret    

f0100e9c <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct Page *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
f0100e9c:	55                   	push   %ebp
f0100e9d:	89 e5                	mov    %esp,%ebp
f0100e9f:	53                   	push   %ebx
f0100ea0:	83 ec 14             	sub    $0x14,%esp
f0100ea3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  struct Page* page=NULL;
  pte_t* pageTableEntry;
  pageTableEntry=pgdir_walk(pgdir,va,0);
f0100ea6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0100ead:	00 
f0100eae:	8b 45 0c             	mov    0xc(%ebp),%eax
f0100eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100eb5:	8b 45 08             	mov    0x8(%ebp),%eax
f0100eb8:	89 04 24             	mov    %eax,(%esp)
f0100ebb:	e8 96 fd ff ff       	call   f0100c56 <pgdir_walk>
  unsigned int pageIndex = PTX(va);
  
if((pageTableEntry)!=NULL)
f0100ec0:	ba 00 00 00 00       	mov    $0x0,%edx
f0100ec5:	85 c0                	test   %eax,%eax
f0100ec7:	74 35                	je     f0100efe <page_lookup+0x62>
}

static inline struct Page*
pa2page(physaddr_t pa)
{
	if (PPN(pa) >= npage)
f0100ec9:	8b 10                	mov    (%eax),%edx
f0100ecb:	c1 ea 0c             	shr    $0xc,%edx
f0100ece:	3b 15 ac 3f 2d f0    	cmp    0xf02d3fac,%edx
f0100ed4:	72 1c                	jb     f0100ef2 <page_lookup+0x56>
		panic("pa2page called with invalid pa");
f0100ed6:	c7 44 24 08 5c 69 10 	movl   $0xf010695c,0x8(%esp)
f0100edd:	f0 
f0100ede:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
f0100ee5:	00 
f0100ee6:	c7 04 24 83 66 10 f0 	movl   $0xf0106683,(%esp)
f0100eed:	e8 93 f1 ff ff       	call   f0100085 <_panic>
	return &pages[PPN(pa)];
f0100ef2:	8d 14 52             	lea    (%edx,%edx,2),%edx
f0100ef5:	c1 e2 02             	shl    $0x2,%edx
f0100ef8:	03 15 b8 3f 2d f0    	add    0xf02d3fb8,%edx
{  

///cprintf("\n\n\nHello removing\n\n\n");
   page= pa2page(PTE_ADDR(*(pageTableEntry)));
     }             
if(pte_store!=0)
f0100efe:	85 db                	test   %ebx,%ebx
f0100f00:	74 02                	je     f0100f04 <page_lookup+0x68>
{
       *pte_store=pageTableEntry;
f0100f02:	89 03                	mov    %eax,(%ebx)
}
             
// Fill this function in
	return page;
}
f0100f04:	89 d0                	mov    %edx,%eax
f0100f06:	83 c4 14             	add    $0x14,%esp
f0100f09:	5b                   	pop    %ebx
f0100f0a:	5d                   	pop    %ebp
f0100f0b:	c3                   	ret    

f0100f0c <page_remove>:
// 	tlb_invalidate, and page_decref.
//

void
page_remove(pde_t *pgdir, void *va)
{
f0100f0c:	55                   	push   %ebp
f0100f0d:	89 e5                	mov    %esp,%ebp
f0100f0f:	83 ec 28             	sub    $0x28,%esp
f0100f12:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f0100f15:	89 75 fc             	mov    %esi,-0x4(%ebp)
f0100f18:	8b 75 08             	mov    0x8(%ebp),%esi
f0100f1b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
        // Fill this function in
        pte_t *pgTbEntry = NULL;
f0100f1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        struct Page *phyPg = page_lookup(pgdir, va, &pgTbEntry);
f0100f25:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0100f28:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100f2c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100f30:	89 34 24             	mov    %esi,(%esp)
f0100f33:	e8 64 ff ff ff       	call   f0100e9c <page_lookup>
        //cprintf("Checking Condition %d",phyPg==NULL);
        if( NULL == phyPg )
f0100f38:	85 c0                	test   %eax,%eax
f0100f3a:	74 1d                	je     f0100f59 <page_remove+0x4d>
                return;
      
        page_decref(phyPg);
f0100f3c:	89 04 24             	mov    %eax,(%esp)
f0100f3f:	e8 52 fb ff ff       	call   f0100a96 <page_decref>
        *pgTbEntry = 0;
f0100f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0100f47:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, va);
f0100f4d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0100f51:	89 34 24             	mov    %esi,(%esp)
f0100f54:	e8 60 fb ff ff       	call   f0100ab9 <tlb_invalidate>
        //cprintf("removed");
}
f0100f59:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f0100f5c:	8b 75 fc             	mov    -0x4(%ebp),%esi
f0100f5f:	89 ec                	mov    %ebp,%esp
f0100f61:	5d                   	pop    %ebp
f0100f62:	c3                   	ret    

f0100f63 <page_insert>:
// and page2pa.
//

int
page_insert(pde_t *pgdir, struct Page *pp, void *va, int perm) 
{
f0100f63:	55                   	push   %ebp
f0100f64:	89 e5                	mov    %esp,%ebp
f0100f66:	83 ec 28             	sub    $0x28,%esp
f0100f69:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0100f6c:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0100f6f:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0100f72:	8b 75 0c             	mov    0xc(%ebp),%esi
f0100f75:	8b 7d 10             	mov    0x10(%ebp),%edi
	// Fill this function in
    struct Page *page=NULL;
  //         cprintf("\npageTableEntry at START  va = %x\n",va);
	    pte_t * pageTableEntry = pgdir_walk(pgdir,va,1);
f0100f78:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0100f7f:	00 
f0100f80:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100f84:	8b 45 08             	mov    0x8(%ebp),%eax
f0100f87:	89 04 24             	mov    %eax,(%esp)
f0100f8a:	e8 c7 fc ff ff       	call   f0100c56 <pgdir_walk>
f0100f8f:	89 c3                	mov    %eax,%ebx
//cprintf("\npageTableEntry at START 2  va = %x  pageTableEntry=  %x   %x    %x %u\n",va,pageTableEntry,PTX(va),*(pageTableEntry));
	   
  
              if(pageTableEntry==NULL)
f0100f91:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0100f96:	85 db                	test   %ebx,%ebx
f0100f98:	0f 84 ca 00 00 00    	je     f0101068 <page_insert+0x105>
                 return -E_NO_MEM;
             //pte_t * pageIndex=pageTable+PTX(va);
             if(*(pageTableEntry)==0)
f0100f9e:	8b 03                	mov    (%ebx),%eax
f0100fa0:	85 c0                	test   %eax,%eax
f0100fa2:	75 2d                	jne    f0100fd1 <page_insert+0x6e>
                 {   
                    *(pageTableEntry)=page2pa(pp)|perm|PTE_P;
f0100fa4:	8b 55 14             	mov    0x14(%ebp),%edx
f0100fa7:	83 ca 01             	or     $0x1,%edx
f0100faa:	89 f0                	mov    %esi,%eax
f0100fac:	2b 05 b8 3f 2d f0    	sub    0xf02d3fb8,%eax
f0100fb2:	c1 f8 02             	sar    $0x2,%eax
f0100fb5:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0100fbb:	c1 e0 0c             	shl    $0xc,%eax
f0100fbe:	09 d0                	or     %edx,%eax
f0100fc0:	89 03                	mov    %eax,(%ebx)
    //                 cprintf("\nhere%x\n",*(pageTableEntry));
                     
                      pp->pp_ref= pp->pp_ref+1;
f0100fc2:	66 83 46 08 01       	addw   $0x1,0x8(%esi)
f0100fc7:	b8 00 00 00 00       	mov    $0x0,%eax
f0100fcc:	e9 97 00 00 00       	jmp    f0101068 <page_insert+0x105>
}

static inline struct Page*
pa2page(physaddr_t pa)
{
	if (PPN(pa) >= npage)
f0100fd1:	c1 e8 0c             	shr    $0xc,%eax
f0100fd4:	3b 05 ac 3f 2d f0    	cmp    0xf02d3fac,%eax
f0100fda:	72 1c                	jb     f0100ff8 <page_insert+0x95>
		panic("pa2page called with invalid pa");
f0100fdc:	c7 44 24 08 5c 69 10 	movl   $0xf010695c,0x8(%esp)
f0100fe3:	f0 
f0100fe4:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
f0100feb:	00 
f0100fec:	c7 04 24 83 66 10 f0 	movl   $0xf0106683,(%esp)
f0100ff3:	e8 8d f0 ff ff       	call   f0100085 <_panic>
	return &pages[PPN(pa)];
f0100ff8:	8b 15 b8 3f 2d f0    	mov    0xf02d3fb8,%edx
                 }else
                  {  
      //              cprintf("here allocated\n"); 
                    page=pa2page(PTE_ADDR(*(pageTableEntry)));
                    
                     if(!(page==pp))
f0100ffe:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0101001:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0101004:	39 c6                	cmp    %eax,%esi
f0101006:	74 34                	je     f010103c <page_insert+0xd9>
                    { //cprintf("here allocated different%x\n",*(pageTableEntry));
                      page_remove(pgdir,va);
f0101008:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010100c:	8b 45 08             	mov    0x8(%ebp),%eax
f010100f:	89 04 24             	mov    %eax,(%esp)
f0101012:	e8 f5 fe ff ff       	call   f0100f0c <page_remove>
                    *(pageTableEntry)=page2pa(pp)|perm|PTE_P;
f0101017:	8b 55 14             	mov    0x14(%ebp),%edx
f010101a:	83 ca 01             	or     $0x1,%edx
f010101d:	89 f0                	mov    %esi,%eax
f010101f:	2b 05 b8 3f 2d f0    	sub    0xf02d3fb8,%eax
f0101025:	c1 f8 02             	sar    $0x2,%eax
f0101028:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f010102e:	c1 e0 0c             	shl    $0xc,%eax
f0101031:	09 d0                	or     %edx,%eax
f0101033:	89 03                	mov    %eax,(%ebx)

                     //cprintf("before%d\n",pp->pp_ref);
                      pp->pp_ref= pp->pp_ref+1;
f0101035:	66 83 46 08 01       	addw   $0x1,0x8(%esi)
f010103a:	eb 18                	jmp    f0101054 <page_insert+0xf1>
                    }
                    else
                    *(pageTableEntry)=page2pa(pp)|perm|PTE_P;
f010103c:	8b 4d 14             	mov    0x14(%ebp),%ecx
f010103f:	83 c9 01             	or     $0x1,%ecx
f0101042:	29 d6                	sub    %edx,%esi
f0101044:	c1 fe 02             	sar    $0x2,%esi
f0101047:	69 c6 ab aa aa aa    	imul   $0xaaaaaaab,%esi,%eax
f010104d:	c1 e0 0c             	shl    $0xc,%eax
f0101050:	09 c8                	or     %ecx,%eax
f0101052:	89 03                	mov    %eax,(%ebx)
                      tlb_invalidate(pgdir, va);
f0101054:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0101058:	8b 45 08             	mov    0x8(%ebp),%eax
f010105b:	89 04 24             	mov    %eax,(%esp)
f010105e:	e8 56 fa ff ff       	call   f0100ab9 <tlb_invalidate>
f0101063:	b8 00 00 00 00       	mov    $0x0,%eax
                  } 
          
                               
  return 0;
}
f0101068:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f010106b:	8b 75 f8             	mov    -0x8(%ebp),%esi
f010106e:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0101071:	89 ec                	mov    %ebp,%esp
f0101073:	5d                   	pop    %ebp
f0101074:	c3                   	ret    

f0101075 <boot_map_segment>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, physaddr_t pa, int perm)
{
f0101075:	55                   	push   %ebp
f0101076:	89 e5                	mov    %esp,%ebp
f0101078:	57                   	push   %edi
f0101079:	56                   	push   %esi
f010107a:	53                   	push   %ebx
f010107b:	83 ec 2c             	sub    $0x2c,%esp
f010107e:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0101081:	89 d7                	mov    %edx,%edi
f0101083:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
              int i;
        
          pte_t *pageTableEntry;
         assert(la % PGSIZE == 0);
f0101086:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f010108c:	74 24                	je     f01010b2 <boot_map_segment+0x3d>
f010108e:	c7 44 24 0c 91 66 10 	movl   $0xf0106691,0xc(%esp)
f0101095:	f0 
f0101096:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f010109d:	f0 
f010109e:	c7 44 24 04 f7 02 00 	movl   $0x2f7,0x4(%esp)
f01010a5:	00 
f01010a6:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01010ad:	e8 d3 ef ff ff       	call   f0100085 <_panic>
	assert(pa % PGSIZE == 0);
f01010b2:	f7 45 08 ff 0f 00 00 	testl  $0xfff,0x8(%ebp)
f01010b9:	74 24                	je     f01010df <boot_map_segment+0x6a>
f01010bb:	c7 44 24 0c b7 66 10 	movl   $0xf01066b7,0xc(%esp)
f01010c2:	f0 
f01010c3:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01010ca:	f0 
f01010cb:	c7 44 24 04 f8 02 00 	movl   $0x2f8,0x4(%esp)
f01010d2:	00 
f01010d3:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01010da:	e8 a6 ef ff ff       	call   f0100085 <_panic>
	assert(size % PGSIZE == 0);
f01010df:	f7 45 e4 ff 0f 00 00 	testl  $0xfff,-0x1c(%ebp)
f01010e6:	75 12                	jne    f01010fa <boot_map_segment+0x85>
f01010e8:	be 00 00 00 00       	mov    $0x0,%esi
f01010ed:	bb 00 00 00 00       	mov    $0x0,%ebx

           
      // boot_map_segment(pgdir,UPAGES, npage*((sizeof(struct Page))),PADDR(pages),PTE_U | PTE_P);
         
  for(i=0;i<size;i+=PGSIZE)
f01010f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01010f6:	75 26                	jne    f010111e <boot_map_segment+0xa9>
f01010f8:	eb 5c                	jmp    f0101156 <boot_map_segment+0xe1>
              int i;
        
          pte_t *pageTableEntry;
         assert(la % PGSIZE == 0);
	assert(pa % PGSIZE == 0);
	assert(size % PGSIZE == 0);
f01010fa:	c7 44 24 0c c8 66 10 	movl   $0xf01066c8,0xc(%esp)
f0101101:	f0 
f0101102:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101109:	f0 
f010110a:	c7 44 24 04 f9 02 00 	movl   $0x2f9,0x4(%esp)
f0101111:	00 
f0101112:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101119:	e8 67 ef ff ff       	call   f0100085 <_panic>
             {
                 
                 pageTableEntry=pgdir_walk(pgdir,(void *)la+i,1);
                  //cprintf("PageTableEntyr%x",pageTableEntry);              
 //this is a page entry in page table, it's physical address will refer to the top of the page(offset decide krega page me kahan pe)    
              *(pageTableEntry) =(pa+i)|perm|PTE_P;
f010111e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101121:	83 c8 01             	or     $0x1,%eax
f0101124:	89 45 dc             	mov    %eax,-0x24(%ebp)
      // boot_map_segment(pgdir,UPAGES, npage*((sizeof(struct Page))),PADDR(pages),PTE_U | PTE_P);
         
  for(i=0;i<size;i+=PGSIZE)
             {
                 
                 pageTableEntry=pgdir_walk(pgdir,(void *)la+i,1);
f0101127:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010112e:	00 
f010112f:	8d 04 3e             	lea    (%esi,%edi,1),%eax
f0101132:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101136:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101139:	89 04 24             	mov    %eax,(%esp)
f010113c:	e8 15 fb ff ff       	call   f0100c56 <pgdir_walk>
                  //cprintf("PageTableEntyr%x",pageTableEntry);              
 //this is a page entry in page table, it's physical address will refer to the top of the page(offset decide krega page me kahan pe)    
              *(pageTableEntry) =(pa+i)|perm|PTE_P;
f0101141:	03 75 08             	add    0x8(%ebp),%esi
f0101144:	0b 75 dc             	or     -0x24(%ebp),%esi
f0101147:	89 30                	mov    %esi,(%eax)
	assert(size % PGSIZE == 0);

           
      // boot_map_segment(pgdir,UPAGES, npage*((sizeof(struct Page))),PADDR(pages),PTE_U | PTE_P);
         
  for(i=0;i<size;i+=PGSIZE)
f0101149:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010114f:	89 de                	mov    %ebx,%esi
f0101151:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
f0101154:	77 d1                	ja     f0101127 <boot_map_segment+0xb2>
                  //cprintf("PageTableEntyr%x",pageTableEntry);              
 //this is a page entry in page table, it's physical address will refer to the top of the page(offset decide krega page me kahan pe)    
              *(pageTableEntry) =(pa+i)|perm|PTE_P;
             }
	// Fill this function in
}
f0101156:	83 c4 2c             	add    $0x2c,%esp
f0101159:	5b                   	pop    %ebx
f010115a:	5e                   	pop    %esi
f010115b:	5f                   	pop    %edi
f010115c:	5d                   	pop    %ebp
f010115d:	c3                   	ret    

f010115e <nvram_read>:
	sizeof(gdt) - 1, (unsigned long) gdt
};

static int
nvram_read(int r)
{
f010115e:	55                   	push   %ebp
f010115f:	89 e5                	mov    %esp,%ebp
f0101161:	83 ec 18             	sub    $0x18,%esp
f0101164:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f0101167:	89 75 fc             	mov    %esi,-0x4(%ebp)
f010116a:	89 c3                	mov    %eax,%ebx
	return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f010116c:	89 04 24             	mov    %eax,(%esp)
f010116f:	e8 90 20 00 00       	call   f0103204 <mc146818_read>
f0101174:	89 c6                	mov    %eax,%esi
f0101176:	83 c3 01             	add    $0x1,%ebx
f0101179:	89 1c 24             	mov    %ebx,(%esp)
f010117c:	e8 83 20 00 00       	call   f0103204 <mc146818_read>
f0101181:	c1 e0 08             	shl    $0x8,%eax
f0101184:	09 f0                	or     %esi,%eax
}
f0101186:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f0101189:	8b 75 fc             	mov    -0x4(%ebp),%esi
f010118c:	89 ec                	mov    %ebp,%esp
f010118e:	5d                   	pop    %ebp
f010118f:	c3                   	ret    

f0101190 <i386_detect_memory>:

void
i386_detect_memory(void)
{
f0101190:	55                   	push   %ebp
f0101191:	89 e5                	mov    %esp,%ebp
f0101193:	83 ec 18             	sub    $0x18,%esp
	// CMOS tells us how many kilobytes there are
	basemem = ROUNDDOWN(nvram_read(NVRAM_BASELO)*1024, PGSIZE);
f0101196:	b8 15 00 00 00       	mov    $0x15,%eax
f010119b:	e8 be ff ff ff       	call   f010115e <nvram_read>
f01011a0:	c1 e0 0a             	shl    $0xa,%eax
f01011a3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01011a8:	a3 ec 32 2d f0       	mov    %eax,0xf02d32ec
	extmem = ROUNDDOWN(nvram_read(NVRAM_EXTLO)*1024, PGSIZE);
f01011ad:	b8 17 00 00 00       	mov    $0x17,%eax
f01011b2:	e8 a7 ff ff ff       	call   f010115e <nvram_read>
f01011b7:	c1 e0 0a             	shl    $0xa,%eax
f01011ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01011bf:	a3 f0 32 2d f0       	mov    %eax,0xf02d32f0

	// Calculate the maximum physical address based on whether
	// or not there is any extended memory.  See comment in <inc/mmu.h>.
	if (extmem)
f01011c4:	85 c0                	test   %eax,%eax
f01011c6:	74 0c                	je     f01011d4 <i386_detect_memory+0x44>
		maxpa = EXTPHYSMEM + extmem;
f01011c8:	05 00 00 10 00       	add    $0x100000,%eax
f01011cd:	a3 e8 32 2d f0       	mov    %eax,0xf02d32e8
f01011d2:	eb 0a                	jmp    f01011de <i386_detect_memory+0x4e>
	else
		maxpa = basemem;
f01011d4:	a1 ec 32 2d f0       	mov    0xf02d32ec,%eax
f01011d9:	a3 e8 32 2d f0       	mov    %eax,0xf02d32e8

	npage = maxpa / PGSIZE;
f01011de:	a1 e8 32 2d f0       	mov    0xf02d32e8,%eax
f01011e3:	89 c2                	mov    %eax,%edx
f01011e5:	c1 ea 0c             	shr    $0xc,%edx
f01011e8:	89 15 ac 3f 2d f0    	mov    %edx,0xf02d3fac

	cprintf("Physical memory: %dK available, ", (int)(maxpa/1024));
f01011ee:	c1 e8 0a             	shr    $0xa,%eax
f01011f1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01011f5:	c7 04 24 7c 69 10 f0 	movl   $0xf010697c,(%esp)
f01011fc:	e8 be 21 00 00       	call   f01033bf <cprintf>
	cprintf("base = %dK, extended = %dK\n", (int)(basemem/1024), (int)(extmem/1024));
f0101201:	a1 f0 32 2d f0       	mov    0xf02d32f0,%eax
f0101206:	c1 e8 0a             	shr    $0xa,%eax
f0101209:	89 44 24 08          	mov    %eax,0x8(%esp)
f010120d:	a1 ec 32 2d f0       	mov    0xf02d32ec,%eax
f0101212:	c1 e8 0a             	shr    $0xa,%eax
f0101215:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101219:	c7 04 24 db 66 10 f0 	movl   $0xf01066db,(%esp)
f0101220:	e8 9a 21 00 00       	call   f01033bf <cprintf>
}
f0101225:	c9                   	leave  
f0101226:	c3                   	ret    

f0101227 <i386_vm_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read (or write). 
void
i386_vm_init(void)
{
f0101227:	55                   	push   %ebp
f0101228:	89 e5                	mov    %esp,%ebp
f010122a:	57                   	push   %edi
f010122b:	56                   	push   %esi
f010122c:	53                   	push   %ebx
f010122d:	83 ec 4c             	sub    $0x4c,%esp
	// Delete this line:


	//////////////////////////////////////////////////////////////////////
	// create initial page directory.
	pgdir = boot_alloc(PGSIZE, PGSIZE);
f0101230:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101235:	b8 00 10 00 00       	mov    $0x1000,%eax
f010123a:	e8 d1 f7 ff ff       	call   f0100a10 <boot_alloc>
f010123f:	89 45 bc             	mov    %eax,-0x44(%ebp)
	memset(pgdir, 0, PGSIZE);
f0101242:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101249:	00 
f010124a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101251:	00 
f0101252:	89 04 24             	mov    %eax,(%esp)
f0101255:	e8 2c 3f 00 00       	call   f0105186 <memset>
	boot_pgdir = pgdir;
f010125a:	8b 45 bc             	mov    -0x44(%ebp),%eax
f010125d:	a3 b4 3f 2d f0       	mov    %eax,0xf02d3fb4
	boot_cr3 = PADDR(pgdir);
f0101262:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0101267:	77 20                	ja     f0101289 <i386_vm_init+0x62>
f0101269:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010126d:	c7 44 24 08 a0 69 10 	movl   $0xf01069a0,0x8(%esp)
f0101274:	f0 
f0101275:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
f010127c:	00 
f010127d:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101284:	e8 fc ed ff ff       	call   f0100085 <_panic>
f0101289:	05 00 00 00 10       	add    $0x10000000,%eax
f010128e:	a3 b0 3f 2d f0       	mov    %eax,0xf02d3fb0
	// a virtual page table at virtual address VPT.
	// (For now, you don't have understand the greater purpose of the
	// following two lines.)
        //cprintf("%d",PDX(UVPT)-PDX(VPT));
	// Permissions: kernel RW, user NONE
	pgdir[PDX(VPT)] = PADDR(pgdir)|PTE_W|PTE_P;
f0101293:	89 c2                	mov    %eax,%edx
f0101295:	83 ca 03             	or     $0x3,%edx
f0101298:	8b 4d bc             	mov    -0x44(%ebp),%ecx
f010129b:	89 91 fc 0e 00 00    	mov    %edx,0xefc(%ecx)

	// same for UVPT
	// Permissions: kernel R, user R 
	pgdir[PDX(UVPT)] = PADDR(pgdir)|PTE_U|PTE_P;
f01012a1:	83 c8 05             	or     $0x5,%eax
f01012a4:	89 81 f4 0e 00 00    	mov    %eax,0xef4(%ecx)
          
          //pages=(struct Page*)0;


          
         pages=boot_alloc(npage * sizeof(struct Page),PGSIZE);
f01012aa:	a1 ac 3f 2d f0       	mov    0xf02d3fac,%eax
f01012af:	8d 04 40             	lea    (%eax,%eax,2),%eax
f01012b2:	c1 e0 02             	shl    $0x2,%eax
f01012b5:	ba 00 10 00 00       	mov    $0x1000,%edx
f01012ba:	e8 51 f7 ff ff       	call   f0100a10 <boot_alloc>
f01012bf:	a3 b8 3f 2d f0       	mov    %eax,0xf02d3fb8
           // assert((unsigned int)(&pages) % PGSIZE == 0);      
        n = ROUNDUP(npage * sizeof(struct Page), PGSIZE);
f01012c4:	a1 ac 3f 2d f0       	mov    0xf02d3fac,%eax
f01012c9:	89 45 b8             	mov    %eax,-0x48(%ebp)
	//////////////////////////////////////////////////////////////////////
	// Make 'envs' point to an array of size 'NENV' of 'struct Env'.
	// LAB 3: Your code here.
        //cprintf("\nsize of%d\n",sizeof(struct Env));
        envs=boot_alloc(NENV*sizeof(struct Env),PGSIZE);
f01012cc:	ba 00 10 00 00       	mov    $0x1000,%edx
f01012d1:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f01012d6:	e8 35 f7 ff ff       	call   f0100a10 <boot_alloc>
f01012db:	a3 00 33 2d f0       	mov    %eax,0xf02d3300
	//////////////////////////////////////////////////////////////////////
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_segment or page_insert
	page_init();
f01012e0:	e8 f0 f7 ff ff       	call   f0100ad5 <page_init>
	struct Page_list fl;

	// if there's a page that shouldn't be on
	// the free list, try to make sure it
	// eventually causes trouble.
	LIST_FOREACH(pp0, &page_free_list, pp_link)
f01012e5:	a1 f8 32 2d f0       	mov    0xf02d32f8,%eax
f01012ea:	89 45 dc             	mov    %eax,-0x24(%ebp)
f01012ed:	85 c0                	test   %eax,%eax
f01012ef:	0f 84 89 00 00 00    	je     f010137e <i386_vm_init+0x157>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
	return page2ppn(pp) << PGSHIFT;
f01012f5:	2b 05 b8 3f 2d f0    	sub    0xf02d3fb8,%eax
f01012fb:	c1 f8 02             	sar    $0x2,%eax
f01012fe:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0101304:	c1 e0 0c             	shl    $0xc,%eax
}

static inline void*
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0101307:	89 c2                	mov    %eax,%edx
f0101309:	c1 ea 0c             	shr    $0xc,%edx
f010130c:	3b 15 ac 3f 2d f0    	cmp    0xf02d3fac,%edx
f0101312:	72 41                	jb     f0101355 <i386_vm_init+0x12e>
f0101314:	eb 1f                	jmp    f0101335 <i386_vm_init+0x10e>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
	return page2ppn(pp) << PGSHIFT;
f0101316:	2b 05 b8 3f 2d f0    	sub    0xf02d3fb8,%eax
f010131c:	c1 f8 02             	sar    $0x2,%eax
f010131f:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0101325:	c1 e0 0c             	shl    $0xc,%eax
}

static inline void*
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0101328:	89 c2                	mov    %eax,%edx
f010132a:	c1 ea 0c             	shr    $0xc,%edx
f010132d:	3b 15 ac 3f 2d f0    	cmp    0xf02d3fac,%edx
f0101333:	72 20                	jb     f0101355 <i386_vm_init+0x12e>
f0101335:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101339:	c7 44 24 08 00 69 10 	movl   $0xf0106900,0x8(%esp)
f0101340:	f0 
f0101341:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0101348:	00 
f0101349:	c7 04 24 83 66 10 f0 	movl   $0xf0106683,(%esp)
f0101350:	e8 30 ed ff ff       	call   f0100085 <_panic>
		memset(page2kva(pp0), 0x97, 128);
f0101355:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
f010135c:	00 
f010135d:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
f0101364:	00 
f0101365:	2d 00 00 00 10       	sub    $0x10000000,%eax
f010136a:	89 04 24             	mov    %eax,(%esp)
f010136d:	e8 14 3e 00 00       	call   f0105186 <memset>
	struct Page_list fl;

	// if there's a page that shouldn't be on
	// the free list, try to make sure it
	// eventually causes trouble.
	LIST_FOREACH(pp0, &page_free_list, pp_link)
f0101372:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0101375:	8b 00                	mov    (%eax),%eax
f0101377:	89 45 dc             	mov    %eax,-0x24(%ebp)
f010137a:	85 c0                	test   %eax,%eax
f010137c:	75 98                	jne    f0101316 <i386_vm_init+0xef>
		memset(page2kva(pp0), 0x97, 128);

	LIST_FOREACH(pp0, &page_free_list, pp_link) {
f010137e:	a1 f8 32 2d f0       	mov    0xf02d32f8,%eax
f0101383:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0101386:	85 c0                	test   %eax,%eax
f0101388:	0f 84 e4 01 00 00    	je     f0101572 <i386_vm_init+0x34b>
		// check that we didn't corrupt the free list itself
		assert(pp0 >= pages);
f010138e:	8b 1d b8 3f 2d f0    	mov    0xf02d3fb8,%ebx
f0101394:	39 d8                	cmp    %ebx,%eax
f0101396:	72 5a                	jb     f01013f2 <i386_vm_init+0x1cb>
		assert(pp0 < pages + npage);
f0101398:	8b 35 ac 3f 2d f0    	mov    0xf02d3fac,%esi
f010139e:	8d 14 76             	lea    (%esi,%esi,2),%edx
f01013a1:	8d 3c 93             	lea    (%ebx,%edx,4),%edi
f01013a4:	39 f8                	cmp    %edi,%eax
f01013a6:	73 72                	jae    f010141a <i386_vm_init+0x1f3>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f01013a8:	89 5d c0             	mov    %ebx,-0x40(%ebp)
}

static inline physaddr_t
page2pa(struct Page *pp)
{
	return page2ppn(pp) << PGSHIFT;
f01013ab:	89 c2                	mov    %eax,%edx
f01013ad:	29 da                	sub    %ebx,%edx
f01013af:	c1 fa 02             	sar    $0x2,%edx
f01013b2:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f01013b8:	c1 e2 0c             	shl    $0xc,%edx

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp0) != 0);
f01013bb:	85 d2                	test   %edx,%edx
f01013bd:	0f 84 90 00 00 00    	je     f0101453 <i386_vm_init+0x22c>
		assert(page2pa(pp0) != IOPHYSMEM);
f01013c3:	81 fa 00 00 0a 00    	cmp    $0xa0000,%edx
f01013c9:	0f 84 b0 00 00 00    	je     f010147f <i386_vm_init+0x258>
		assert(page2pa(pp0) != EXTPHYSMEM - PGSIZE);
f01013cf:	81 fa 00 f0 0f 00    	cmp    $0xff000,%edx
f01013d5:	0f 84 d0 00 00 00    	je     f01014ab <i386_vm_init+0x284>
		assert(page2pa(pp0) != EXTPHYSMEM);
f01013db:	81 fa 00 00 10 00    	cmp    $0x100000,%edx
f01013e1:	0f 85 14 01 00 00    	jne    f01014fb <i386_vm_init+0x2d4>
f01013e7:	90                   	nop
f01013e8:	e9 ea 00 00 00       	jmp    f01014d7 <i386_vm_init+0x2b0>
	LIST_FOREACH(pp0, &page_free_list, pp_link)
		memset(page2kva(pp0), 0x97, 128);

	LIST_FOREACH(pp0, &page_free_list, pp_link) {
		// check that we didn't corrupt the free list itself
		assert(pp0 >= pages);
f01013ed:	39 d8                	cmp    %ebx,%eax
f01013ef:	90                   	nop
f01013f0:	73 24                	jae    f0101416 <i386_vm_init+0x1ef>
f01013f2:	c7 44 24 0c f7 66 10 	movl   $0xf01066f7,0xc(%esp)
f01013f9:	f0 
f01013fa:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101401:	f0 
f0101402:	c7 44 24 04 5b 01 00 	movl   $0x15b,0x4(%esp)
f0101409:	00 
f010140a:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101411:	e8 6f ec ff ff       	call   f0100085 <_panic>
		assert(pp0 < pages + npage);
f0101416:	39 f8                	cmp    %edi,%eax
f0101418:	72 24                	jb     f010143e <i386_vm_init+0x217>
f010141a:	c7 44 24 0c 04 67 10 	movl   $0xf0106704,0xc(%esp)
f0101421:	f0 
f0101422:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101429:	f0 
f010142a:	c7 44 24 04 5c 01 00 	movl   $0x15c,0x4(%esp)
f0101431:	00 
f0101432:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101439:	e8 47 ec ff ff       	call   f0100085 <_panic>
f010143e:	89 c2                	mov    %eax,%edx
f0101440:	2b 55 c0             	sub    -0x40(%ebp),%edx
f0101443:	c1 fa 02             	sar    $0x2,%edx
f0101446:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f010144c:	c1 e2 0c             	shl    $0xc,%edx

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp0) != 0);
f010144f:	85 d2                	test   %edx,%edx
f0101451:	75 24                	jne    f0101477 <i386_vm_init+0x250>
f0101453:	c7 44 24 0c 18 67 10 	movl   $0xf0106718,0xc(%esp)
f010145a:	f0 
f010145b:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101462:	f0 
f0101463:	c7 44 24 04 5f 01 00 	movl   $0x15f,0x4(%esp)
f010146a:	00 
f010146b:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101472:	e8 0e ec ff ff       	call   f0100085 <_panic>
		assert(page2pa(pp0) != IOPHYSMEM);
f0101477:	81 fa 00 00 0a 00    	cmp    $0xa0000,%edx
f010147d:	75 24                	jne    f01014a3 <i386_vm_init+0x27c>
f010147f:	c7 44 24 0c 2a 67 10 	movl   $0xf010672a,0xc(%esp)
f0101486:	f0 
f0101487:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f010148e:	f0 
f010148f:	c7 44 24 04 60 01 00 	movl   $0x160,0x4(%esp)
f0101496:	00 
f0101497:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f010149e:	e8 e2 eb ff ff       	call   f0100085 <_panic>
		assert(page2pa(pp0) != EXTPHYSMEM - PGSIZE);
f01014a3:	81 fa 00 f0 0f 00    	cmp    $0xff000,%edx
f01014a9:	75 24                	jne    f01014cf <i386_vm_init+0x2a8>
f01014ab:	c7 44 24 0c c4 69 10 	movl   $0xf01069c4,0xc(%esp)
f01014b2:	f0 
f01014b3:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01014ba:	f0 
f01014bb:	c7 44 24 04 61 01 00 	movl   $0x161,0x4(%esp)
f01014c2:	00 
f01014c3:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01014ca:	e8 b6 eb ff ff       	call   f0100085 <_panic>
		assert(page2pa(pp0) != EXTPHYSMEM);
f01014cf:	81 fa 00 00 10 00    	cmp    $0x100000,%edx
f01014d5:	75 36                	jne    f010150d <i386_vm_init+0x2e6>
f01014d7:	c7 44 24 0c 44 67 10 	movl   $0xf0106744,0xc(%esp)
f01014de:	f0 
f01014df:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01014e6:	f0 
f01014e7:	c7 44 24 04 62 01 00 	movl   $0x162,0x4(%esp)
f01014ee:	00 
f01014ef:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01014f6:	e8 8a eb ff ff       	call   f0100085 <_panic>
		assert(page2kva(pp0) != ROUNDDOWN(boot_freemem - 1, PGSIZE));
f01014fb:	8b 0d f4 32 2d f0    	mov    0xf02d32f4,%ecx
f0101501:	83 e9 01             	sub    $0x1,%ecx
f0101504:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f010150a:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
}

static inline void*
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f010150d:	89 d1                	mov    %edx,%ecx
f010150f:	c1 e9 0c             	shr    $0xc,%ecx
f0101512:	39 f1                	cmp    %esi,%ecx
f0101514:	72 20                	jb     f0101536 <i386_vm_init+0x30f>
f0101516:	89 54 24 0c          	mov    %edx,0xc(%esp)
f010151a:	c7 44 24 08 00 69 10 	movl   $0xf0106900,0x8(%esp)
f0101521:	f0 
f0101522:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0101529:	00 
f010152a:	c7 04 24 83 66 10 f0 	movl   $0xf0106683,(%esp)
f0101531:	e8 4f eb ff ff       	call   f0100085 <_panic>
f0101536:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f010153c:	39 55 c4             	cmp    %edx,-0x3c(%ebp)
f010153f:	75 24                	jne    f0101565 <i386_vm_init+0x33e>
f0101541:	c7 44 24 0c e8 69 10 	movl   $0xf01069e8,0xc(%esp)
f0101548:	f0 
f0101549:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101550:	f0 
f0101551:	c7 44 24 04 63 01 00 	movl   $0x163,0x4(%esp)
f0101558:	00 
f0101559:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101560:	e8 20 eb ff ff       	call   f0100085 <_panic>
	// the free list, try to make sure it
	// eventually causes trouble.
	LIST_FOREACH(pp0, &page_free_list, pp_link)
		memset(page2kva(pp0), 0x97, 128);

	LIST_FOREACH(pp0, &page_free_list, pp_link) {
f0101565:	8b 00                	mov    (%eax),%eax
f0101567:	89 45 dc             	mov    %eax,-0x24(%ebp)
f010156a:	85 c0                	test   %eax,%eax
f010156c:	0f 85 7b fe ff ff    	jne    f01013ed <i386_vm_init+0x1c6>
		assert(page2pa(pp0) != EXTPHYSMEM);
		assert(page2kva(pp0) != ROUNDDOWN(boot_freemem - 1, PGSIZE));
	}

// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
f0101572:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0101579:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0101580:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    cprintf(" Pages before allocation %u    %u",pp0,pp1);
f0101587:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010158e:	00 
f010158f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101596:	00 
f0101597:	c7 04 24 20 6a 10 f0 	movl   $0xf0106a20,(%esp)
f010159e:	e8 1c 1e 00 00       	call   f01033bf <cprintf>
	assert(page_alloc(&pp0) == 0);
f01015a3:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01015a6:	89 04 24             	mov    %eax,(%esp)
f01015a9:	e8 58 f6 ff ff       	call   f0100c06 <page_alloc>
f01015ae:	85 c0                	test   %eax,%eax
f01015b0:	74 24                	je     f01015d6 <i386_vm_init+0x3af>
f01015b2:	c7 44 24 0c 5f 67 10 	movl   $0xf010675f,0xc(%esp)
f01015b9:	f0 
f01015ba:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01015c1:	f0 
f01015c2:	c7 44 24 04 69 01 00 	movl   $0x169,0x4(%esp)
f01015c9:	00 
f01015ca:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01015d1:	e8 af ea ff ff       	call   f0100085 <_panic>
	assert(page_alloc(&pp1) == 0);
f01015d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
f01015d9:	89 04 24             	mov    %eax,(%esp)
f01015dc:	e8 25 f6 ff ff       	call   f0100c06 <page_alloc>
f01015e1:	85 c0                	test   %eax,%eax
f01015e3:	74 24                	je     f0101609 <i386_vm_init+0x3e2>
f01015e5:	c7 44 24 0c 75 67 10 	movl   $0xf0106775,0xc(%esp)
f01015ec:	f0 
f01015ed:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01015f4:	f0 
f01015f5:	c7 44 24 04 6a 01 00 	movl   $0x16a,0x4(%esp)
f01015fc:	00 
f01015fd:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101604:	e8 7c ea ff ff       	call   f0100085 <_panic>
	assert(page_alloc(&pp2) == 0);
f0101609:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010160c:	89 04 24             	mov    %eax,(%esp)
f010160f:	e8 f2 f5 ff ff       	call   f0100c06 <page_alloc>
f0101614:	85 c0                	test   %eax,%eax
f0101616:	74 24                	je     f010163c <i386_vm_init+0x415>
f0101618:	c7 44 24 0c 8b 67 10 	movl   $0xf010678b,0xc(%esp)
f010161f:	f0 
f0101620:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101627:	f0 
f0101628:	c7 44 24 04 6b 01 00 	movl   $0x16b,0x4(%esp)
f010162f:	00 
f0101630:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101637:	e8 49 ea ff ff       	call   f0100085 <_panic>

	assert(pp0);
f010163c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f010163f:	85 c9                	test   %ecx,%ecx
f0101641:	75 24                	jne    f0101667 <i386_vm_init+0x440>
f0101643:	c7 44 24 0c af 67 10 	movl   $0xf01067af,0xc(%esp)
f010164a:	f0 
f010164b:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101652:	f0 
f0101653:	c7 44 24 04 6d 01 00 	movl   $0x16d,0x4(%esp)
f010165a:	00 
f010165b:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101662:	e8 1e ea ff ff       	call   f0100085 <_panic>
	assert(pp1 && pp1 != pp0);
f0101667:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010166a:	85 d2                	test   %edx,%edx
f010166c:	74 04                	je     f0101672 <i386_vm_init+0x44b>
f010166e:	39 d1                	cmp    %edx,%ecx
f0101670:	75 24                	jne    f0101696 <i386_vm_init+0x46f>
f0101672:	c7 44 24 0c a1 67 10 	movl   $0xf01067a1,0xc(%esp)
f0101679:	f0 
f010167a:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101681:	f0 
f0101682:	c7 44 24 04 6e 01 00 	movl   $0x16e,0x4(%esp)
f0101689:	00 
f010168a:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101691:	e8 ef e9 ff ff       	call   f0100085 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101696:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0101699:	85 c0                	test   %eax,%eax
f010169b:	74 08                	je     f01016a5 <i386_vm_init+0x47e>
f010169d:	39 c2                	cmp    %eax,%edx
f010169f:	74 04                	je     f01016a5 <i386_vm_init+0x47e>
f01016a1:	39 c1                	cmp    %eax,%ecx
f01016a3:	75 24                	jne    f01016c9 <i386_vm_init+0x4a2>
f01016a5:	c7 44 24 0c 44 6a 10 	movl   $0xf0106a44,0xc(%esp)
f01016ac:	f0 
f01016ad:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01016b4:	f0 
f01016b5:	c7 44 24 04 6f 01 00 	movl   $0x16f,0x4(%esp)
f01016bc:	00 
f01016bd:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01016c4:	e8 bc e9 ff ff       	call   f0100085 <_panic>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline ppn_t
page2ppn(struct Page *pp)
{
	return pp - pages;
f01016c9:	8b 35 b8 3f 2d f0    	mov    0xf02d3fb8,%esi
	assert(page2pa(pp0) < npage*PGSIZE);
f01016cf:	8b 1d ac 3f 2d f0    	mov    0xf02d3fac,%ebx
f01016d5:	c1 e3 0c             	shl    $0xc,%ebx
f01016d8:	29 f1                	sub    %esi,%ecx
f01016da:	c1 f9 02             	sar    $0x2,%ecx
f01016dd:	69 c9 ab aa aa aa    	imul   $0xaaaaaaab,%ecx,%ecx
f01016e3:	c1 e1 0c             	shl    $0xc,%ecx
f01016e6:	39 d9                	cmp    %ebx,%ecx
f01016e8:	72 24                	jb     f010170e <i386_vm_init+0x4e7>
f01016ea:	c7 44 24 0c b3 67 10 	movl   $0xf01067b3,0xc(%esp)
f01016f1:	f0 
f01016f2:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01016f9:	f0 
f01016fa:	c7 44 24 04 70 01 00 	movl   $0x170,0x4(%esp)
f0101701:	00 
f0101702:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101709:	e8 77 e9 ff ff       	call   f0100085 <_panic>
	assert(page2pa(pp1) < npage*PGSIZE);
f010170e:	29 f2                	sub    %esi,%edx
f0101710:	c1 fa 02             	sar    $0x2,%edx
f0101713:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0101719:	c1 e2 0c             	shl    $0xc,%edx
f010171c:	39 d3                	cmp    %edx,%ebx
f010171e:	77 24                	ja     f0101744 <i386_vm_init+0x51d>
f0101720:	c7 44 24 0c cf 67 10 	movl   $0xf01067cf,0xc(%esp)
f0101727:	f0 
f0101728:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f010172f:	f0 
f0101730:	c7 44 24 04 71 01 00 	movl   $0x171,0x4(%esp)
f0101737:	00 
f0101738:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f010173f:	e8 41 e9 ff ff       	call   f0100085 <_panic>
	assert(page2pa(pp2) < npage*PGSIZE);
f0101744:	29 f0                	sub    %esi,%eax
f0101746:	c1 f8 02             	sar    $0x2,%eax
f0101749:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f010174f:	c1 e0 0c             	shl    $0xc,%eax
f0101752:	39 c3                	cmp    %eax,%ebx
f0101754:	77 24                	ja     f010177a <i386_vm_init+0x553>
f0101756:	c7 44 24 0c eb 67 10 	movl   $0xf01067eb,0xc(%esp)
f010175d:	f0 
f010175e:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101765:	f0 
f0101766:	c7 44 24 04 72 01 00 	movl   $0x172,0x4(%esp)
f010176d:	00 
f010176e:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101775:	e8 0b e9 ff ff       	call   f0100085 <_panic>

// temporarily steal the rest of the free pages
	fl = page_free_list;
f010177a:	8b 1d f8 32 2d f0    	mov    0xf02d32f8,%ebx
	LIST_INIT(&page_free_list);
f0101780:	c7 05 f8 32 2d f0 00 	movl   $0x0,0xf02d32f8
f0101787:	00 00 00 

	// should be no free memory
	assert(page_alloc(&pp) == -E_NO_MEM);
f010178a:	8d 45 d8             	lea    -0x28(%ebp),%eax
f010178d:	89 04 24             	mov    %eax,(%esp)
f0101790:	e8 71 f4 ff ff       	call   f0100c06 <page_alloc>
f0101795:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0101798:	74 24                	je     f01017be <i386_vm_init+0x597>
f010179a:	c7 44 24 0c 07 68 10 	movl   $0xf0106807,0xc(%esp)
f01017a1:	f0 
f01017a2:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01017a9:	f0 
f01017aa:	c7 44 24 04 79 01 00 	movl   $0x179,0x4(%esp)
f01017b1:	00 
f01017b2:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01017b9:	e8 c7 e8 ff ff       	call   f0100085 <_panic>

	// free and re-allocate?
	page_free(pp0);
f01017be:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01017c1:	89 04 24             	mov    %eax,(%esp)
f01017c4:	e8 a4 f2 ff ff       	call   f0100a6d <page_free>
	page_free(pp1);
f01017c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01017cc:	89 04 24             	mov    %eax,(%esp)
f01017cf:	e8 99 f2 ff ff       	call   f0100a6d <page_free>
	page_free(pp2);
f01017d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01017d7:	89 04 24             	mov    %eax,(%esp)
f01017da:	e8 8e f2 ff ff       	call   f0100a6d <page_free>
	pp0 = pp1 = pp2 = 0;
f01017df:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f01017e6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f01017ed:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	assert(page_alloc(&pp0) == 0);
f01017f4:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01017f7:	89 04 24             	mov    %eax,(%esp)
f01017fa:	e8 07 f4 ff ff       	call   f0100c06 <page_alloc>
f01017ff:	85 c0                	test   %eax,%eax
f0101801:	74 24                	je     f0101827 <i386_vm_init+0x600>
f0101803:	c7 44 24 0c 5f 67 10 	movl   $0xf010675f,0xc(%esp)
f010180a:	f0 
f010180b:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101812:	f0 
f0101813:	c7 44 24 04 80 01 00 	movl   $0x180,0x4(%esp)
f010181a:	00 
f010181b:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101822:	e8 5e e8 ff ff       	call   f0100085 <_panic>
	assert(page_alloc(&pp1) == 0);
f0101827:	8d 45 e0             	lea    -0x20(%ebp),%eax
f010182a:	89 04 24             	mov    %eax,(%esp)
f010182d:	e8 d4 f3 ff ff       	call   f0100c06 <page_alloc>
f0101832:	85 c0                	test   %eax,%eax
f0101834:	74 24                	je     f010185a <i386_vm_init+0x633>
f0101836:	c7 44 24 0c 75 67 10 	movl   $0xf0106775,0xc(%esp)
f010183d:	f0 
f010183e:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101845:	f0 
f0101846:	c7 44 24 04 81 01 00 	movl   $0x181,0x4(%esp)
f010184d:	00 
f010184e:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101855:	e8 2b e8 ff ff       	call   f0100085 <_panic>
	assert(page_alloc(&pp2) == 0);
f010185a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010185d:	89 04 24             	mov    %eax,(%esp)
f0101860:	e8 a1 f3 ff ff       	call   f0100c06 <page_alloc>
f0101865:	85 c0                	test   %eax,%eax
f0101867:	74 24                	je     f010188d <i386_vm_init+0x666>
f0101869:	c7 44 24 0c 8b 67 10 	movl   $0xf010678b,0xc(%esp)
f0101870:	f0 
f0101871:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101878:	f0 
f0101879:	c7 44 24 04 82 01 00 	movl   $0x182,0x4(%esp)
f0101880:	00 
f0101881:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101888:	e8 f8 e7 ff ff       	call   f0100085 <_panic>
	assert(pp0);
f010188d:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0101890:	85 d2                	test   %edx,%edx
f0101892:	75 24                	jne    f01018b8 <i386_vm_init+0x691>
f0101894:	c7 44 24 0c af 67 10 	movl   $0xf01067af,0xc(%esp)
f010189b:	f0 
f010189c:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01018a3:	f0 
f01018a4:	c7 44 24 04 83 01 00 	movl   $0x183,0x4(%esp)
f01018ab:	00 
f01018ac:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01018b3:	e8 cd e7 ff ff       	call   f0100085 <_panic>
	assert(pp1 && pp1 != pp0);
f01018b8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01018bb:	85 c9                	test   %ecx,%ecx
f01018bd:	74 04                	je     f01018c3 <i386_vm_init+0x69c>
f01018bf:	39 ca                	cmp    %ecx,%edx
f01018c1:	75 24                	jne    f01018e7 <i386_vm_init+0x6c0>
f01018c3:	c7 44 24 0c a1 67 10 	movl   $0xf01067a1,0xc(%esp)
f01018ca:	f0 
f01018cb:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01018d2:	f0 
f01018d3:	c7 44 24 04 84 01 00 	movl   $0x184,0x4(%esp)
f01018da:	00 
f01018db:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01018e2:	e8 9e e7 ff ff       	call   f0100085 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01018e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01018ea:	85 c0                	test   %eax,%eax
f01018ec:	74 08                	je     f01018f6 <i386_vm_init+0x6cf>
f01018ee:	39 c1                	cmp    %eax,%ecx
f01018f0:	74 04                	je     f01018f6 <i386_vm_init+0x6cf>
f01018f2:	39 c2                	cmp    %eax,%edx
f01018f4:	75 24                	jne    f010191a <i386_vm_init+0x6f3>
f01018f6:	c7 44 24 0c 44 6a 10 	movl   $0xf0106a44,0xc(%esp)
f01018fd:	f0 
f01018fe:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101905:	f0 
f0101906:	c7 44 24 04 85 01 00 	movl   $0x185,0x4(%esp)
f010190d:	00 
f010190e:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101915:	e8 6b e7 ff ff       	call   f0100085 <_panic>
	assert(page_alloc(&pp) == -E_NO_MEM);
f010191a:	8d 45 d8             	lea    -0x28(%ebp),%eax
f010191d:	89 04 24             	mov    %eax,(%esp)
f0101920:	e8 e1 f2 ff ff       	call   f0100c06 <page_alloc>
f0101925:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0101928:	74 24                	je     f010194e <i386_vm_init+0x727>
f010192a:	c7 44 24 0c 07 68 10 	movl   $0xf0106807,0xc(%esp)
f0101931:	f0 
f0101932:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101939:	f0 
f010193a:	c7 44 24 04 86 01 00 	movl   $0x186,0x4(%esp)
f0101941:	00 
f0101942:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101949:	e8 37 e7 ff ff       	call   f0100085 <_panic>

	// give free list back
	page_free_list = fl;
f010194e:	89 1d f8 32 2d f0    	mov    %ebx,0xf02d32f8

	// free the pages we took
	page_free(pp0);
f0101954:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0101957:	89 04 24             	mov    %eax,(%esp)
f010195a:	e8 0e f1 ff ff       	call   f0100a6d <page_free>
	page_free(pp1);
f010195f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101962:	89 04 24             	mov    %eax,(%esp)
f0101965:	e8 03 f1 ff ff       	call   f0100a6d <page_free>
	page_free(pp2);
f010196a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010196d:	89 04 24             	mov    %eax,(%esp)
f0101970:	e8 f8 f0 ff ff       	call   f0100a6d <page_free>

	cprintf("check_page_alloc() succeeded!\n");
f0101975:	c7 04 24 64 6a 10 f0 	movl   $0xf0106a64,(%esp)
f010197c:	e8 3e 1a 00 00       	call   f01033bf <cprintf>
	pte_t *ptep, *ptep1;
	void *va;
	int i;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
f0101981:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
f0101988:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f010198f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	assert(page_alloc(&pp0) == 0);
f0101996:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0101999:	89 04 24             	mov    %eax,(%esp)
f010199c:	e8 65 f2 ff ff       	call   f0100c06 <page_alloc>
f01019a1:	85 c0                	test   %eax,%eax
f01019a3:	74 24                	je     f01019c9 <i386_vm_init+0x7a2>
f01019a5:	c7 44 24 0c 5f 67 10 	movl   $0xf010675f,0xc(%esp)
f01019ac:	f0 
f01019ad:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01019b4:	f0 
f01019b5:	c7 44 24 04 d7 03 00 	movl   $0x3d7,0x4(%esp)
f01019bc:	00 
f01019bd:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01019c4:	e8 bc e6 ff ff       	call   f0100085 <_panic>
	assert(page_alloc(&pp1) == 0);
f01019c9:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01019cc:	89 04 24             	mov    %eax,(%esp)
f01019cf:	e8 32 f2 ff ff       	call   f0100c06 <page_alloc>
f01019d4:	85 c0                	test   %eax,%eax
f01019d6:	74 24                	je     f01019fc <i386_vm_init+0x7d5>
f01019d8:	c7 44 24 0c 75 67 10 	movl   $0xf0106775,0xc(%esp)
f01019df:	f0 
f01019e0:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01019e7:	f0 
f01019e8:	c7 44 24 04 d8 03 00 	movl   $0x3d8,0x4(%esp)
f01019ef:	00 
f01019f0:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01019f7:	e8 89 e6 ff ff       	call   f0100085 <_panic>
	assert(page_alloc(&pp2) == 0);
f01019fc:	8d 45 d8             	lea    -0x28(%ebp),%eax
f01019ff:	89 04 24             	mov    %eax,(%esp)
f0101a02:	e8 ff f1 ff ff       	call   f0100c06 <page_alloc>
f0101a07:	85 c0                	test   %eax,%eax
f0101a09:	74 24                	je     f0101a2f <i386_vm_init+0x808>
f0101a0b:	c7 44 24 0c 8b 67 10 	movl   $0xf010678b,0xc(%esp)
f0101a12:	f0 
f0101a13:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101a1a:	f0 
f0101a1b:	c7 44 24 04 d9 03 00 	movl   $0x3d9,0x4(%esp)
f0101a22:	00 
f0101a23:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101a2a:	e8 56 e6 ff ff       	call   f0100085 <_panic>

	assert(pp0);
f0101a2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0101a32:	85 d2                	test   %edx,%edx
f0101a34:	75 24                	jne    f0101a5a <i386_vm_init+0x833>
f0101a36:	c7 44 24 0c af 67 10 	movl   $0xf01067af,0xc(%esp)
f0101a3d:	f0 
f0101a3e:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101a45:	f0 
f0101a46:	c7 44 24 04 db 03 00 	movl   $0x3db,0x4(%esp)
f0101a4d:	00 
f0101a4e:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101a55:	e8 2b e6 ff ff       	call   f0100085 <_panic>
	assert(pp1 && pp1 != pp0);
f0101a5a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f0101a5d:	85 c9                	test   %ecx,%ecx
f0101a5f:	74 04                	je     f0101a65 <i386_vm_init+0x83e>
f0101a61:	39 ca                	cmp    %ecx,%edx
f0101a63:	75 24                	jne    f0101a89 <i386_vm_init+0x862>
f0101a65:	c7 44 24 0c a1 67 10 	movl   $0xf01067a1,0xc(%esp)
f0101a6c:	f0 
f0101a6d:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101a74:	f0 
f0101a75:	c7 44 24 04 dc 03 00 	movl   $0x3dc,0x4(%esp)
f0101a7c:	00 
f0101a7d:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101a84:	e8 fc e5 ff ff       	call   f0100085 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101a89:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101a8c:	85 c0                	test   %eax,%eax
f0101a8e:	74 08                	je     f0101a98 <i386_vm_init+0x871>
f0101a90:	39 c1                	cmp    %eax,%ecx
f0101a92:	74 04                	je     f0101a98 <i386_vm_init+0x871>
f0101a94:	39 c2                	cmp    %eax,%edx
f0101a96:	75 24                	jne    f0101abc <i386_vm_init+0x895>
f0101a98:	c7 44 24 0c 44 6a 10 	movl   $0xf0106a44,0xc(%esp)
f0101a9f:	f0 
f0101aa0:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101aa7:	f0 
f0101aa8:	c7 44 24 04 dd 03 00 	movl   $0x3dd,0x4(%esp)
f0101aaf:	00 
f0101ab0:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101ab7:	e8 c9 e5 ff ff       	call   f0100085 <_panic>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101abc:	8b 1d f8 32 2d f0    	mov    0xf02d32f8,%ebx
	LIST_INIT(&page_free_list);
f0101ac2:	c7 05 f8 32 2d f0 00 	movl   $0x0,0xf02d32f8
f0101ac9:	00 00 00 

	// should be no free memory
	assert(page_alloc(&pp) == -E_NO_MEM);
f0101acc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101acf:	89 04 24             	mov    %eax,(%esp)
f0101ad2:	e8 2f f1 ff ff       	call   f0100c06 <page_alloc>
f0101ad7:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0101ada:	74 24                	je     f0101b00 <i386_vm_init+0x8d9>
f0101adc:	c7 44 24 0c 07 68 10 	movl   $0xf0106807,0xc(%esp)
f0101ae3:	f0 
f0101ae4:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101aeb:	f0 
f0101aec:	c7 44 24 04 e4 03 00 	movl   $0x3e4,0x4(%esp)
f0101af3:	00 
f0101af4:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101afb:	e8 85 e5 ff ff       	call   f0100085 <_panic>

	// there is no page allocated at address 0
	assert(page_lookup(boot_pgdir, (void *) 0x0, &ptep) == NULL);
f0101b00:	8d 45 d4             	lea    -0x2c(%ebp),%eax
f0101b03:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101b07:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0101b0e:	00 
f0101b0f:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f0101b14:	89 04 24             	mov    %eax,(%esp)
f0101b17:	e8 80 f3 ff ff       	call   f0100e9c <page_lookup>
f0101b1c:	85 c0                	test   %eax,%eax
f0101b1e:	74 24                	je     f0101b44 <i386_vm_init+0x91d>
f0101b20:	c7 44 24 0c 84 6a 10 	movl   $0xf0106a84,0xc(%esp)
f0101b27:	f0 
f0101b28:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101b2f:	f0 
f0101b30:	c7 44 24 04 e7 03 00 	movl   $0x3e7,0x4(%esp)
f0101b37:	00 
f0101b38:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101b3f:	e8 41 e5 ff ff       	call   f0100085 <_panic>

	// there is no free memory, so we can't allocate a page table 
	assert(page_insert(boot_pgdir, pp1, 0x0, 0) < 0);
f0101b44:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0101b4b:	00 
f0101b4c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0101b53:	00 
f0101b54:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0101b57:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101b5b:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f0101b60:	89 04 24             	mov    %eax,(%esp)
f0101b63:	e8 fb f3 ff ff       	call   f0100f63 <page_insert>
f0101b68:	85 c0                	test   %eax,%eax
f0101b6a:	78 24                	js     f0101b90 <i386_vm_init+0x969>
f0101b6c:	c7 44 24 0c bc 6a 10 	movl   $0xf0106abc,0xc(%esp)
f0101b73:	f0 
f0101b74:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101b7b:	f0 
f0101b7c:	c7 44 24 04 ea 03 00 	movl   $0x3ea,0x4(%esp)
f0101b83:	00 
f0101b84:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101b8b:	e8 f5 e4 ff ff       	call   f0100085 <_panic>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101b90:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101b93:	89 04 24             	mov    %eax,(%esp)
f0101b96:	e8 d2 ee ff ff       	call   f0100a6d <page_free>
	assert(page_insert(boot_pgdir, pp1, 0x0, 0) == 0);
f0101b9b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0101ba2:	00 
f0101ba3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0101baa:	00 
f0101bab:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0101bae:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101bb2:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f0101bb7:	89 04 24             	mov    %eax,(%esp)
f0101bba:	e8 a4 f3 ff ff       	call   f0100f63 <page_insert>
f0101bbf:	85 c0                	test   %eax,%eax
f0101bc1:	74 24                	je     f0101be7 <i386_vm_init+0x9c0>
f0101bc3:	c7 44 24 0c e8 6a 10 	movl   $0xf0106ae8,0xc(%esp)
f0101bca:	f0 
f0101bcb:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101bd2:	f0 
f0101bd3:	c7 44 24 04 ee 03 00 	movl   $0x3ee,0x4(%esp)
f0101bda:	00 
f0101bdb:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101be2:	e8 9e e4 ff ff       	call   f0100085 <_panic>
	assert(PTE_ADDR(boot_pgdir[0]) == page2pa(pp0));
f0101be7:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f0101bec:	8b 08                	mov    (%eax),%ecx
f0101bee:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0101bf4:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0101bf7:	2b 15 b8 3f 2d f0    	sub    0xf02d3fb8,%edx
f0101bfd:	c1 fa 02             	sar    $0x2,%edx
f0101c00:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0101c06:	c1 e2 0c             	shl    $0xc,%edx
f0101c09:	39 d1                	cmp    %edx,%ecx
f0101c0b:	74 24                	je     f0101c31 <i386_vm_init+0xa0a>
f0101c0d:	c7 44 24 0c 14 6b 10 	movl   $0xf0106b14,0xc(%esp)
f0101c14:	f0 
f0101c15:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101c1c:	f0 
f0101c1d:	c7 44 24 04 ef 03 00 	movl   $0x3ef,0x4(%esp)
f0101c24:	00 
f0101c25:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101c2c:	e8 54 e4 ff ff       	call   f0100085 <_panic>
        //cprintf("\n\nCHECK%x %x%x\n\n",check_va2pa(boot_pgdir, 0x0),page2pa(pp1),page2pa(pp0));
	assert(check_va2pa(boot_pgdir, 0x0) == page2pa(pp1));
f0101c31:	ba 00 00 00 00       	mov    $0x0,%edx
f0101c36:	e8 65 ef ff ff       	call   f0100ba0 <check_va2pa>
f0101c3b:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0101c3e:	89 d1                	mov    %edx,%ecx
f0101c40:	2b 0d b8 3f 2d f0    	sub    0xf02d3fb8,%ecx
f0101c46:	c1 f9 02             	sar    $0x2,%ecx
f0101c49:	69 c9 ab aa aa aa    	imul   $0xaaaaaaab,%ecx,%ecx
f0101c4f:	c1 e1 0c             	shl    $0xc,%ecx
f0101c52:	39 c8                	cmp    %ecx,%eax
f0101c54:	74 24                	je     f0101c7a <i386_vm_init+0xa53>
f0101c56:	c7 44 24 0c 3c 6b 10 	movl   $0xf0106b3c,0xc(%esp)
f0101c5d:	f0 
f0101c5e:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101c65:	f0 
f0101c66:	c7 44 24 04 f1 03 00 	movl   $0x3f1,0x4(%esp)
f0101c6d:	00 
f0101c6e:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101c75:	e8 0b e4 ff ff       	call   f0100085 <_panic>
	assert(pp1->pp_ref == 1);
f0101c7a:	66 83 7a 08 01       	cmpw   $0x1,0x8(%edx)
f0101c7f:	74 24                	je     f0101ca5 <i386_vm_init+0xa7e>
f0101c81:	c7 44 24 0c 24 68 10 	movl   $0xf0106824,0xc(%esp)
f0101c88:	f0 
f0101c89:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101c90:	f0 
f0101c91:	c7 44 24 04 f2 03 00 	movl   $0x3f2,0x4(%esp)
f0101c98:	00 
f0101c99:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101ca0:	e8 e0 e3 ff ff       	call   f0100085 <_panic>
	assert(pp0->pp_ref == 1);
f0101ca5:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0101ca8:	66 83 78 08 01       	cmpw   $0x1,0x8(%eax)
f0101cad:	74 24                	je     f0101cd3 <i386_vm_init+0xaac>
f0101caf:	c7 44 24 0c 35 68 10 	movl   $0xf0106835,0xc(%esp)
f0101cb6:	f0 
f0101cb7:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101cbe:	f0 
f0101cbf:	c7 44 24 04 f3 03 00 	movl   $0x3f3,0x4(%esp)
f0101cc6:	00 
f0101cc7:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101cce:	e8 b2 e3 ff ff       	call   f0100085 <_panic>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(boot_pgdir, pp2, (void*) PGSIZE, 0) == 0);
f0101cd3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0101cda:	00 
f0101cdb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101ce2:	00 
f0101ce3:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101ce6:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101cea:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f0101cef:	89 04 24             	mov    %eax,(%esp)
f0101cf2:	e8 6c f2 ff ff       	call   f0100f63 <page_insert>
f0101cf7:	85 c0                	test   %eax,%eax
f0101cf9:	74 24                	je     f0101d1f <i386_vm_init+0xaf8>
f0101cfb:	c7 44 24 0c 6c 6b 10 	movl   $0xf0106b6c,0xc(%esp)
f0101d02:	f0 
f0101d03:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101d0a:	f0 
f0101d0b:	c7 44 24 04 f6 03 00 	movl   $0x3f6,0x4(%esp)
f0101d12:	00 
f0101d13:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101d1a:	e8 66 e3 ff ff       	call   f0100085 <_panic>
	//cprintf("\n\nCHECK%x %x\n\n",PGSIZE,page2pa(pp2));
     assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp2));
f0101d1f:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d24:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f0101d29:	e8 72 ee ff ff       	call   f0100ba0 <check_va2pa>
f0101d2e:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0101d31:	89 d1                	mov    %edx,%ecx
f0101d33:	2b 0d b8 3f 2d f0    	sub    0xf02d3fb8,%ecx
f0101d39:	c1 f9 02             	sar    $0x2,%ecx
f0101d3c:	69 c9 ab aa aa aa    	imul   $0xaaaaaaab,%ecx,%ecx
f0101d42:	c1 e1 0c             	shl    $0xc,%ecx
f0101d45:	39 c8                	cmp    %ecx,%eax
f0101d47:	74 24                	je     f0101d6d <i386_vm_init+0xb46>
f0101d49:	c7 44 24 0c a4 6b 10 	movl   $0xf0106ba4,0xc(%esp)
f0101d50:	f0 
f0101d51:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101d58:	f0 
f0101d59:	c7 44 24 04 f8 03 00 	movl   $0x3f8,0x4(%esp)
f0101d60:	00 
f0101d61:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101d68:	e8 18 e3 ff ff       	call   f0100085 <_panic>
	assert(pp2->pp_ref == 1);
f0101d6d:	66 83 7a 08 01       	cmpw   $0x1,0x8(%edx)
f0101d72:	74 24                	je     f0101d98 <i386_vm_init+0xb71>
f0101d74:	c7 44 24 0c 46 68 10 	movl   $0xf0106846,0xc(%esp)
f0101d7b:	f0 
f0101d7c:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101d83:	f0 
f0101d84:	c7 44 24 04 f9 03 00 	movl   $0x3f9,0x4(%esp)
f0101d8b:	00 
f0101d8c:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101d93:	e8 ed e2 ff ff       	call   f0100085 <_panic>

	// should be no free memory
	assert(page_alloc(&pp) == -E_NO_MEM);
f0101d98:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101d9b:	89 04 24             	mov    %eax,(%esp)
f0101d9e:	e8 63 ee ff ff       	call   f0100c06 <page_alloc>
f0101da3:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0101da6:	74 24                	je     f0101dcc <i386_vm_init+0xba5>
f0101da8:	c7 44 24 0c 07 68 10 	movl   $0xf0106807,0xc(%esp)
f0101daf:	f0 
f0101db0:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101db7:	f0 
f0101db8:	c7 44 24 04 fc 03 00 	movl   $0x3fc,0x4(%esp)
f0101dbf:	00 
f0101dc0:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101dc7:	e8 b9 e2 ff ff       	call   f0100085 <_panic>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(boot_pgdir, pp2, (void*) PGSIZE, 0) == 0);
f0101dcc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0101dd3:	00 
f0101dd4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101ddb:	00 
f0101ddc:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101ddf:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101de3:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f0101de8:	89 04 24             	mov    %eax,(%esp)
f0101deb:	e8 73 f1 ff ff       	call   f0100f63 <page_insert>
f0101df0:	85 c0                	test   %eax,%eax
f0101df2:	74 24                	je     f0101e18 <i386_vm_init+0xbf1>
f0101df4:	c7 44 24 0c 6c 6b 10 	movl   $0xf0106b6c,0xc(%esp)
f0101dfb:	f0 
f0101dfc:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101e03:	f0 
f0101e04:	c7 44 24 04 ff 03 00 	movl   $0x3ff,0x4(%esp)
f0101e0b:	00 
f0101e0c:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101e13:	e8 6d e2 ff ff       	call   f0100085 <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp2));
f0101e18:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e1d:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f0101e22:	e8 79 ed ff ff       	call   f0100ba0 <check_va2pa>
f0101e27:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0101e2a:	89 d1                	mov    %edx,%ecx
f0101e2c:	2b 0d b8 3f 2d f0    	sub    0xf02d3fb8,%ecx
f0101e32:	c1 f9 02             	sar    $0x2,%ecx
f0101e35:	69 c9 ab aa aa aa    	imul   $0xaaaaaaab,%ecx,%ecx
f0101e3b:	c1 e1 0c             	shl    $0xc,%ecx
f0101e3e:	39 c8                	cmp    %ecx,%eax
f0101e40:	74 24                	je     f0101e66 <i386_vm_init+0xc3f>
f0101e42:	c7 44 24 0c a4 6b 10 	movl   $0xf0106ba4,0xc(%esp)
f0101e49:	f0 
f0101e4a:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101e51:	f0 
f0101e52:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
f0101e59:	00 
f0101e5a:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101e61:	e8 1f e2 ff ff       	call   f0100085 <_panic>
	assert(pp2->pp_ref == 1);
f0101e66:	66 83 7a 08 01       	cmpw   $0x1,0x8(%edx)
f0101e6b:	74 24                	je     f0101e91 <i386_vm_init+0xc6a>
f0101e6d:	c7 44 24 0c 46 68 10 	movl   $0xf0106846,0xc(%esp)
f0101e74:	f0 
f0101e75:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101e7c:	f0 
f0101e7d:	c7 44 24 04 01 04 00 	movl   $0x401,0x4(%esp)
f0101e84:	00 
f0101e85:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101e8c:	e8 f4 e1 ff ff       	call   f0100085 <_panic>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(page_alloc(&pp) == -E_NO_MEM);
f0101e91:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101e94:	89 04 24             	mov    %eax,(%esp)
f0101e97:	e8 6a ed ff ff       	call   f0100c06 <page_alloc>
f0101e9c:	83 f8 fc             	cmp    $0xfffffffc,%eax
f0101e9f:	74 24                	je     f0101ec5 <i386_vm_init+0xc9e>
f0101ea1:	c7 44 24 0c 07 68 10 	movl   $0xf0106807,0xc(%esp)
f0101ea8:	f0 
f0101ea9:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101eb0:	f0 
f0101eb1:	c7 44 24 04 05 04 00 	movl   $0x405,0x4(%esp)
f0101eb8:	00 
f0101eb9:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101ec0:	e8 c0 e1 ff ff       	call   f0100085 <_panic>

	// check that pgdir	
	ptep = KADDR(PTE_ADDR(boot_pgdir[PDX(PGSIZE)]));
f0101ec5:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f0101eca:	8b 00                	mov    (%eax),%eax
f0101ecc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101ed1:	89 c2                	mov    %eax,%edx
f0101ed3:	c1 ea 0c             	shr    $0xc,%edx
f0101ed6:	3b 15 ac 3f 2d f0    	cmp    0xf02d3fac,%edx
f0101edc:	72 20                	jb     f0101efe <i386_vm_init+0xcd7>
f0101ede:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0101ee2:	c7 44 24 08 00 69 10 	movl   $0xf0106900,0x8(%esp)
f0101ee9:	f0 
f0101eea:	c7 44 24 04 08 04 00 	movl   $0x408,0x4(%esp)
f0101ef1:	00 
f0101ef2:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101ef9:	e8 87 e1 ff ff       	call   f0100085 <_panic>
f0101efe:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101f03:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	assert(pgdir_walk(boot_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101f06:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0101f0d:	00 
f0101f0e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0101f15:	00 
f0101f16:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f0101f1b:	89 04 24             	mov    %eax,(%esp)
f0101f1e:	e8 33 ed ff ff       	call   f0100c56 <pgdir_walk>
f0101f23:	8b 55 d4             	mov    -0x2c(%ebp),%edx
f0101f26:	83 c2 04             	add    $0x4,%edx
f0101f29:	39 d0                	cmp    %edx,%eax
f0101f2b:	74 24                	je     f0101f51 <i386_vm_init+0xd2a>
f0101f2d:	c7 44 24 0c d4 6b 10 	movl   $0xf0106bd4,0xc(%esp)
f0101f34:	f0 
f0101f35:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101f3c:	f0 
f0101f3d:	c7 44 24 04 09 04 00 	movl   $0x409,0x4(%esp)
f0101f44:	00 
f0101f45:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101f4c:	e8 34 e1 ff ff       	call   f0100085 <_panic>

	// should be able to change permissions too.
	assert(page_insert(boot_pgdir, pp2, (void*) PGSIZE, PTE_U) == 0);
f0101f51:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0101f58:	00 
f0101f59:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0101f60:	00 
f0101f61:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0101f64:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101f68:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f0101f6d:	89 04 24             	mov    %eax,(%esp)
f0101f70:	e8 ee ef ff ff       	call   f0100f63 <page_insert>
f0101f75:	85 c0                	test   %eax,%eax
f0101f77:	74 24                	je     f0101f9d <i386_vm_init+0xd76>
f0101f79:	c7 44 24 0c 14 6c 10 	movl   $0xf0106c14,0xc(%esp)
f0101f80:	f0 
f0101f81:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101f88:	f0 
f0101f89:	c7 44 24 04 0c 04 00 	movl   $0x40c,0x4(%esp)
f0101f90:	00 
f0101f91:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101f98:	e8 e8 e0 ff ff       	call   f0100085 <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp2));
f0101f9d:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101fa2:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f0101fa7:	e8 f4 eb ff ff       	call   f0100ba0 <check_va2pa>
f0101fac:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0101faf:	89 d1                	mov    %edx,%ecx
f0101fb1:	2b 0d b8 3f 2d f0    	sub    0xf02d3fb8,%ecx
f0101fb7:	c1 f9 02             	sar    $0x2,%ecx
f0101fba:	69 c9 ab aa aa aa    	imul   $0xaaaaaaab,%ecx,%ecx
f0101fc0:	c1 e1 0c             	shl    $0xc,%ecx
f0101fc3:	39 c8                	cmp    %ecx,%eax
f0101fc5:	74 24                	je     f0101feb <i386_vm_init+0xdc4>
f0101fc7:	c7 44 24 0c a4 6b 10 	movl   $0xf0106ba4,0xc(%esp)
f0101fce:	f0 
f0101fcf:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0101fd6:	f0 
f0101fd7:	c7 44 24 04 0d 04 00 	movl   $0x40d,0x4(%esp)
f0101fde:	00 
f0101fdf:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0101fe6:	e8 9a e0 ff ff       	call   f0100085 <_panic>
	assert(pp2->pp_ref == 1);
f0101feb:	66 83 7a 08 01       	cmpw   $0x1,0x8(%edx)
f0101ff0:	74 24                	je     f0102016 <i386_vm_init+0xdef>
f0101ff2:	c7 44 24 0c 46 68 10 	movl   $0xf0106846,0xc(%esp)
f0101ff9:	f0 
f0101ffa:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0102001:	f0 
f0102002:	c7 44 24 04 0e 04 00 	movl   $0x40e,0x4(%esp)
f0102009:	00 
f010200a:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102011:	e8 6f e0 ff ff       	call   f0100085 <_panic>
	assert(*pgdir_walk(boot_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0102016:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f010201d:	00 
f010201e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f0102025:	00 
f0102026:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f010202b:	89 04 24             	mov    %eax,(%esp)
f010202e:	e8 23 ec ff ff       	call   f0100c56 <pgdir_walk>
f0102033:	f6 00 04             	testb  $0x4,(%eax)
f0102036:	75 24                	jne    f010205c <i386_vm_init+0xe35>
f0102038:	c7 44 24 0c 50 6c 10 	movl   $0xf0106c50,0xc(%esp)
f010203f:	f0 
f0102040:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0102047:	f0 
f0102048:	c7 44 24 04 0f 04 00 	movl   $0x40f,0x4(%esp)
f010204f:	00 
f0102050:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102057:	e8 29 e0 ff ff       	call   f0100085 <_panic>
	assert(boot_pgdir[0] & PTE_U);
f010205c:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f0102061:	f6 00 04             	testb  $0x4,(%eax)
f0102064:	75 24                	jne    f010208a <i386_vm_init+0xe63>
f0102066:	c7 44 24 0c 57 68 10 	movl   $0xf0106857,0xc(%esp)
f010206d:	f0 
f010206e:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0102075:	f0 
f0102076:	c7 44 24 04 10 04 00 	movl   $0x410,0x4(%esp)
f010207d:	00 
f010207e:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102085:	e8 fb df ff ff       	call   f0100085 <_panic>
	
	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(boot_pgdir, pp0, (void*) PTSIZE, 0) < 0);
f010208a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0102091:	00 
f0102092:	c7 44 24 08 00 00 40 	movl   $0x400000,0x8(%esp)
f0102099:	00 
f010209a:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010209d:	89 54 24 04          	mov    %edx,0x4(%esp)
f01020a1:	89 04 24             	mov    %eax,(%esp)
f01020a4:	e8 ba ee ff ff       	call   f0100f63 <page_insert>
f01020a9:	85 c0                	test   %eax,%eax
f01020ab:	78 24                	js     f01020d1 <i386_vm_init+0xeaa>
f01020ad:	c7 44 24 0c 84 6c 10 	movl   $0xf0106c84,0xc(%esp)
f01020b4:	f0 
f01020b5:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01020bc:	f0 
f01020bd:	c7 44 24 04 13 04 00 	movl   $0x413,0x4(%esp)
f01020c4:	00 
f01020c5:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01020cc:	e8 b4 df ff ff       	call   f0100085 <_panic>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(boot_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f01020d1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f01020d8:	00 
f01020d9:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01020e0:	00 
f01020e1:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01020e4:	89 44 24 04          	mov    %eax,0x4(%esp)
f01020e8:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f01020ed:	89 04 24             	mov    %eax,(%esp)
f01020f0:	e8 6e ee ff ff       	call   f0100f63 <page_insert>
f01020f5:	85 c0                	test   %eax,%eax
f01020f7:	74 24                	je     f010211d <i386_vm_init+0xef6>
f01020f9:	c7 44 24 0c b8 6c 10 	movl   $0xf0106cb8,0xc(%esp)
f0102100:	f0 
f0102101:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0102108:	f0 
f0102109:	c7 44 24 04 16 04 00 	movl   $0x416,0x4(%esp)
f0102110:	00 
f0102111:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102118:	e8 68 df ff ff       	call   f0100085 <_panic>
	assert(!(*pgdir_walk(boot_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010211d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0102124:	00 
f0102125:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f010212c:	00 
f010212d:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f0102132:	89 04 24             	mov    %eax,(%esp)
f0102135:	e8 1c eb ff ff       	call   f0100c56 <pgdir_walk>
f010213a:	f6 00 04             	testb  $0x4,(%eax)
f010213d:	74 24                	je     f0102163 <i386_vm_init+0xf3c>
f010213f:	c7 44 24 0c f0 6c 10 	movl   $0xf0106cf0,0xc(%esp)
f0102146:	f0 
f0102147:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f010214e:	f0 
f010214f:	c7 44 24 04 17 04 00 	movl   $0x417,0x4(%esp)
f0102156:	00 
f0102157:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f010215e:	e8 22 df ff ff       	call   f0100085 <_panic>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(boot_pgdir, 0) == page2pa(pp1));
f0102163:	ba 00 00 00 00       	mov    $0x0,%edx
f0102168:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f010216d:	e8 2e ea ff ff       	call   f0100ba0 <check_va2pa>
f0102172:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0102175:	2b 15 b8 3f 2d f0    	sub    0xf02d3fb8,%edx
f010217b:	c1 fa 02             	sar    $0x2,%edx
f010217e:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0102184:	c1 e2 0c             	shl    $0xc,%edx
f0102187:	39 d0                	cmp    %edx,%eax
f0102189:	74 24                	je     f01021af <i386_vm_init+0xf88>
f010218b:	c7 44 24 0c 28 6d 10 	movl   $0xf0106d28,0xc(%esp)
f0102192:	f0 
f0102193:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f010219a:	f0 
f010219b:	c7 44 24 04 1a 04 00 	movl   $0x41a,0x4(%esp)
f01021a2:	00 
f01021a3:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01021aa:	e8 d6 de ff ff       	call   f0100085 <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp1));
f01021af:	ba 00 10 00 00       	mov    $0x1000,%edx
f01021b4:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f01021b9:	e8 e2 e9 ff ff       	call   f0100ba0 <check_va2pa>
f01021be:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01021c1:	89 d1                	mov    %edx,%ecx
f01021c3:	2b 0d b8 3f 2d f0    	sub    0xf02d3fb8,%ecx
f01021c9:	c1 f9 02             	sar    $0x2,%ecx
f01021cc:	69 c9 ab aa aa aa    	imul   $0xaaaaaaab,%ecx,%ecx
f01021d2:	c1 e1 0c             	shl    $0xc,%ecx
f01021d5:	39 c8                	cmp    %ecx,%eax
f01021d7:	74 24                	je     f01021fd <i386_vm_init+0xfd6>
f01021d9:	c7 44 24 0c 54 6d 10 	movl   $0xf0106d54,0xc(%esp)
f01021e0:	f0 
f01021e1:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01021e8:	f0 
f01021e9:	c7 44 24 04 1b 04 00 	movl   $0x41b,0x4(%esp)
f01021f0:	00 
f01021f1:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01021f8:	e8 88 de ff ff       	call   f0100085 <_panic>
	// ... and ref counts should reflect this
	


        assert(pp1->pp_ref == 2);
f01021fd:	66 83 7a 08 02       	cmpw   $0x2,0x8(%edx)
f0102202:	74 24                	je     f0102228 <i386_vm_init+0x1001>
f0102204:	c7 44 24 0c 6d 68 10 	movl   $0xf010686d,0xc(%esp)
f010220b:	f0 
f010220c:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0102213:	f0 
f0102214:	c7 44 24 04 20 04 00 	movl   $0x420,0x4(%esp)
f010221b:	00 
f010221c:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102223:	e8 5d de ff ff       	call   f0100085 <_panic>



	assert(pp2->pp_ref == 0);
f0102228:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010222b:	66 83 78 08 00       	cmpw   $0x0,0x8(%eax)
f0102230:	74 24                	je     f0102256 <i386_vm_init+0x102f>
f0102232:	c7 44 24 0c 7e 68 10 	movl   $0xf010687e,0xc(%esp)
f0102239:	f0 
f010223a:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0102241:	f0 
f0102242:	c7 44 24 04 24 04 00 	movl   $0x424,0x4(%esp)
f0102249:	00 
f010224a:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102251:	e8 2f de ff ff       	call   f0100085 <_panic>

	// pp2 should be returned by page_alloc
	assert(page_alloc(&pp) == 0 && pp == pp2);
f0102256:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0102259:	89 04 24             	mov    %eax,(%esp)
f010225c:	e8 a5 e9 ff ff       	call   f0100c06 <page_alloc>
f0102261:	85 c0                	test   %eax,%eax
f0102263:	75 08                	jne    f010226d <i386_vm_init+0x1046>
f0102265:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0102268:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f010226b:	74 24                	je     f0102291 <i386_vm_init+0x106a>
f010226d:	c7 44 24 0c 84 6d 10 	movl   $0xf0106d84,0xc(%esp)
f0102274:	f0 
f0102275:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f010227c:	f0 
f010227d:	c7 44 24 04 27 04 00 	movl   $0x427,0x4(%esp)
f0102284:	00 
f0102285:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f010228c:	e8 f4 dd ff ff       	call   f0100085 <_panic>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(boot_pgdir, 0x0);
f0102291:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102298:	00 
f0102299:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f010229e:	89 04 24             	mov    %eax,(%esp)
f01022a1:	e8 66 ec ff ff       	call   f0100f0c <page_remove>
	assert(check_va2pa(boot_pgdir, 0x0) == ~0);
f01022a6:	ba 00 00 00 00       	mov    $0x0,%edx
f01022ab:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f01022b0:	e8 eb e8 ff ff       	call   f0100ba0 <check_va2pa>
f01022b5:	83 f8 ff             	cmp    $0xffffffff,%eax
f01022b8:	74 24                	je     f01022de <i386_vm_init+0x10b7>
f01022ba:	c7 44 24 0c a8 6d 10 	movl   $0xf0106da8,0xc(%esp)
f01022c1:	f0 
f01022c2:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01022c9:	f0 
f01022ca:	c7 44 24 04 2b 04 00 	movl   $0x42b,0x4(%esp)
f01022d1:	00 
f01022d2:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01022d9:	e8 a7 dd ff ff       	call   f0100085 <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == page2pa(pp1));
f01022de:	ba 00 10 00 00       	mov    $0x1000,%edx
f01022e3:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f01022e8:	e8 b3 e8 ff ff       	call   f0100ba0 <check_va2pa>
f01022ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01022f0:	89 d1                	mov    %edx,%ecx
f01022f2:	2b 0d b8 3f 2d f0    	sub    0xf02d3fb8,%ecx
f01022f8:	c1 f9 02             	sar    $0x2,%ecx
f01022fb:	69 c9 ab aa aa aa    	imul   $0xaaaaaaab,%ecx,%ecx
f0102301:	c1 e1 0c             	shl    $0xc,%ecx
f0102304:	39 c8                	cmp    %ecx,%eax
f0102306:	74 24                	je     f010232c <i386_vm_init+0x1105>
f0102308:	c7 44 24 0c 54 6d 10 	movl   $0xf0106d54,0xc(%esp)
f010230f:	f0 
f0102310:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0102317:	f0 
f0102318:	c7 44 24 04 2c 04 00 	movl   $0x42c,0x4(%esp)
f010231f:	00 
f0102320:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102327:	e8 59 dd ff ff       	call   f0100085 <_panic>
	assert(pp1->pp_ref == 1);
f010232c:	66 83 7a 08 01       	cmpw   $0x1,0x8(%edx)
f0102331:	74 24                	je     f0102357 <i386_vm_init+0x1130>
f0102333:	c7 44 24 0c 24 68 10 	movl   $0xf0106824,0xc(%esp)
f010233a:	f0 
f010233b:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0102342:	f0 
f0102343:	c7 44 24 04 2d 04 00 	movl   $0x42d,0x4(%esp)
f010234a:	00 
f010234b:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102352:	e8 2e dd ff ff       	call   f0100085 <_panic>
	assert(pp2->pp_ref == 0);
f0102357:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010235a:	66 83 78 08 00       	cmpw   $0x0,0x8(%eax)
f010235f:	74 24                	je     f0102385 <i386_vm_init+0x115e>
f0102361:	c7 44 24 0c 7e 68 10 	movl   $0xf010687e,0xc(%esp)
f0102368:	f0 
f0102369:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0102370:	f0 
f0102371:	c7 44 24 04 2e 04 00 	movl   $0x42e,0x4(%esp)
f0102378:	00 
f0102379:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102380:	e8 00 dd ff ff       	call   f0100085 <_panic>

	// unmapping pp1 at PGSIZE should free it
	page_remove(boot_pgdir, (void*) PGSIZE);
f0102385:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
f010238c:	00 
f010238d:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f0102392:	89 04 24             	mov    %eax,(%esp)
f0102395:	e8 72 eb ff ff       	call   f0100f0c <page_remove>
	assert(check_va2pa(boot_pgdir, 0x0) == ~0);
f010239a:	ba 00 00 00 00       	mov    $0x0,%edx
f010239f:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f01023a4:	e8 f7 e7 ff ff       	call   f0100ba0 <check_va2pa>
f01023a9:	83 f8 ff             	cmp    $0xffffffff,%eax
f01023ac:	74 24                	je     f01023d2 <i386_vm_init+0x11ab>
f01023ae:	c7 44 24 0c a8 6d 10 	movl   $0xf0106da8,0xc(%esp)
f01023b5:	f0 
f01023b6:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01023bd:	f0 
f01023be:	c7 44 24 04 32 04 00 	movl   $0x432,0x4(%esp)
f01023c5:	00 
f01023c6:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01023cd:	e8 b3 dc ff ff       	call   f0100085 <_panic>
	assert(check_va2pa(boot_pgdir, PGSIZE) == ~0);
f01023d2:	ba 00 10 00 00       	mov    $0x1000,%edx
f01023d7:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f01023dc:	e8 bf e7 ff ff       	call   f0100ba0 <check_va2pa>
f01023e1:	83 f8 ff             	cmp    $0xffffffff,%eax
f01023e4:	74 24                	je     f010240a <i386_vm_init+0x11e3>
f01023e6:	c7 44 24 0c cc 6d 10 	movl   $0xf0106dcc,0xc(%esp)
f01023ed:	f0 
f01023ee:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01023f5:	f0 
f01023f6:	c7 44 24 04 33 04 00 	movl   $0x433,0x4(%esp)
f01023fd:	00 
f01023fe:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102405:	e8 7b dc ff ff       	call   f0100085 <_panic>
	assert(pp1->pp_ref == 0);
f010240a:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010240d:	66 83 78 08 00       	cmpw   $0x0,0x8(%eax)
f0102412:	74 24                	je     f0102438 <i386_vm_init+0x1211>
f0102414:	c7 44 24 0c 8f 68 10 	movl   $0xf010688f,0xc(%esp)
f010241b:	f0 
f010241c:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0102423:	f0 
f0102424:	c7 44 24 04 34 04 00 	movl   $0x434,0x4(%esp)
f010242b:	00 
f010242c:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102433:	e8 4d dc ff ff       	call   f0100085 <_panic>
	assert(pp2->pp_ref == 0);
f0102438:	8b 45 d8             	mov    -0x28(%ebp),%eax
f010243b:	66 83 78 08 00       	cmpw   $0x0,0x8(%eax)
f0102440:	74 24                	je     f0102466 <i386_vm_init+0x123f>
f0102442:	c7 44 24 0c 7e 68 10 	movl   $0xf010687e,0xc(%esp)
f0102449:	f0 
f010244a:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0102451:	f0 
f0102452:	c7 44 24 04 35 04 00 	movl   $0x435,0x4(%esp)
f0102459:	00 
f010245a:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102461:	e8 1f dc ff ff       	call   f0100085 <_panic>

	// so it should be returned by page_alloc
	assert(page_alloc(&pp) == 0 && pp == pp1);
f0102466:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0102469:	89 04 24             	mov    %eax,(%esp)
f010246c:	e8 95 e7 ff ff       	call   f0100c06 <page_alloc>
f0102471:	85 c0                	test   %eax,%eax
f0102473:	75 08                	jne    f010247d <i386_vm_init+0x1256>
f0102475:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0102478:	3b 45 dc             	cmp    -0x24(%ebp),%eax
f010247b:	74 24                	je     f01024a1 <i386_vm_init+0x127a>
f010247d:	c7 44 24 0c f4 6d 10 	movl   $0xf0106df4,0xc(%esp)
f0102484:	f0 
f0102485:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f010248c:	f0 
f010248d:	c7 44 24 04 38 04 00 	movl   $0x438,0x4(%esp)
f0102494:	00 
f0102495:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f010249c:	e8 e4 db ff ff       	call   f0100085 <_panic>

	// should be no free memory
	assert(page_alloc(&pp) == -E_NO_MEM);
f01024a1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01024a4:	89 04 24             	mov    %eax,(%esp)
f01024a7:	e8 5a e7 ff ff       	call   f0100c06 <page_alloc>
f01024ac:	83 f8 fc             	cmp    $0xfffffffc,%eax
f01024af:	74 24                	je     f01024d5 <i386_vm_init+0x12ae>
f01024b1:	c7 44 24 0c 07 68 10 	movl   $0xf0106807,0xc(%esp)
f01024b8:	f0 
f01024b9:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01024c0:	f0 
f01024c1:	c7 44 24 04 3b 04 00 	movl   $0x43b,0x4(%esp)
f01024c8:	00 
f01024c9:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01024d0:	e8 b0 db ff ff       	call   f0100085 <_panic>
	page_remove(boot_pgdir, 0x0);
	assert(pp2->pp_ref == 0);
#endif

	// forcibly take pp0 back
	assert(PTE_ADDR(boot_pgdir[0]) == page2pa(pp0));
f01024d5:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f01024da:	8b 08                	mov    (%eax),%ecx
f01024dc:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01024e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01024e5:	2b 15 b8 3f 2d f0    	sub    0xf02d3fb8,%edx
f01024eb:	c1 fa 02             	sar    $0x2,%edx
f01024ee:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f01024f4:	c1 e2 0c             	shl    $0xc,%edx
f01024f7:	39 d1                	cmp    %edx,%ecx
f01024f9:	74 24                	je     f010251f <i386_vm_init+0x12f8>
f01024fb:	c7 44 24 0c 14 6b 10 	movl   $0xf0106b14,0xc(%esp)
f0102502:	f0 
f0102503:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f010250a:	f0 
f010250b:	c7 44 24 04 4e 04 00 	movl   $0x44e,0x4(%esp)
f0102512:	00 
f0102513:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f010251a:	e8 66 db ff ff       	call   f0100085 <_panic>
	boot_pgdir[0] = 0;
f010251f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	assert(pp0->pp_ref == 1);
f0102525:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102528:	66 83 78 08 01       	cmpw   $0x1,0x8(%eax)
f010252d:	74 24                	je     f0102553 <i386_vm_init+0x132c>
f010252f:	c7 44 24 0c 35 68 10 	movl   $0xf0106835,0xc(%esp)
f0102536:	f0 
f0102537:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f010253e:	f0 
f010253f:	c7 44 24 04 50 04 00 	movl   $0x450,0x4(%esp)
f0102546:	00 
f0102547:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f010254e:	e8 32 db ff ff       	call   f0100085 <_panic>
	pp0->pp_ref = 0;
f0102553:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
	
	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0102559:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010255c:	89 04 24             	mov    %eax,(%esp)
f010255f:	e8 09 e5 ff ff       	call   f0100a6d <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(boot_pgdir, va, 1);
f0102564:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010256b:	00 
f010256c:	c7 44 24 04 00 10 40 	movl   $0x401000,0x4(%esp)
f0102573:	00 
f0102574:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f0102579:	89 04 24             	mov    %eax,(%esp)
f010257c:	e8 d5 e6 ff ff       	call   f0100c56 <pgdir_walk>
f0102581:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	ptep1 = KADDR(PTE_ADDR(boot_pgdir[PDX(va)]));
f0102584:	8b 0d b4 3f 2d f0    	mov    0xf02d3fb4,%ecx
f010258a:	83 c1 04             	add    $0x4,%ecx
f010258d:	8b 11                	mov    (%ecx),%edx
f010258f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102595:	89 d6                	mov    %edx,%esi
f0102597:	c1 ee 0c             	shr    $0xc,%esi
f010259a:	3b 35 ac 3f 2d f0    	cmp    0xf02d3fac,%esi
f01025a0:	72 20                	jb     f01025c2 <i386_vm_init+0x139b>
f01025a2:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01025a6:	c7 44 24 08 00 69 10 	movl   $0xf0106900,0x8(%esp)
f01025ad:	f0 
f01025ae:	c7 44 24 04 57 04 00 	movl   $0x457,0x4(%esp)
f01025b5:	00 
f01025b6:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01025bd:	e8 c3 da ff ff       	call   f0100085 <_panic>
	assert(ptep == ptep1 + PTX(va));
f01025c2:	81 ea fc ff ff 0f    	sub    $0xffffffc,%edx
f01025c8:	39 d0                	cmp    %edx,%eax
f01025ca:	74 24                	je     f01025f0 <i386_vm_init+0x13c9>
f01025cc:	c7 44 24 0c a0 68 10 	movl   $0xf01068a0,0xc(%esp)
f01025d3:	f0 
f01025d4:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01025db:	f0 
f01025dc:	c7 44 24 04 58 04 00 	movl   $0x458,0x4(%esp)
f01025e3:	00 
f01025e4:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01025eb:	e8 95 da ff ff       	call   f0100085 <_panic>
	boot_pgdir[PDX(va)] = 0;
f01025f0:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	pp0->pp_ref = 0;
f01025f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01025f9:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)
}

static inline physaddr_t
page2pa(struct Page *pp)
{
	return page2ppn(pp) << PGSHIFT;
f01025ff:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102602:	2b 05 b8 3f 2d f0    	sub    0xf02d3fb8,%eax
f0102608:	c1 f8 02             	sar    $0x2,%eax
f010260b:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0102611:	c1 e0 0c             	shl    $0xc,%eax
}

static inline void*
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0102614:	89 c2                	mov    %eax,%edx
f0102616:	c1 ea 0c             	shr    $0xc,%edx
f0102619:	3b 15 ac 3f 2d f0    	cmp    0xf02d3fac,%edx
f010261f:	72 20                	jb     f0102641 <i386_vm_init+0x141a>
f0102621:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102625:	c7 44 24 08 00 69 10 	movl   $0xf0106900,0x8(%esp)
f010262c:	f0 
f010262d:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0102634:	00 
f0102635:	c7 04 24 83 66 10 f0 	movl   $0xf0106683,(%esp)
f010263c:	e8 44 da ff ff       	call   f0100085 <_panic>
	
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0102641:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102648:	00 
f0102649:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
f0102650:	00 
f0102651:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102656:	89 04 24             	mov    %eax,(%esp)
f0102659:	e8 28 2b 00 00       	call   f0105186 <memset>
	page_free(pp0);
f010265e:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102661:	89 04 24             	mov    %eax,(%esp)
f0102664:	e8 04 e4 ff ff       	call   f0100a6d <page_free>
	pgdir_walk(boot_pgdir, 0x0, 1);
f0102669:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0102670:	00 
f0102671:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102678:	00 
f0102679:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f010267e:	89 04 24             	mov    %eax,(%esp)
f0102681:	e8 d0 e5 ff ff       	call   f0100c56 <pgdir_walk>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
	return page2ppn(pp) << PGSHIFT;
f0102686:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0102689:	2b 15 b8 3f 2d f0    	sub    0xf02d3fb8,%edx
f010268f:	c1 fa 02             	sar    $0x2,%edx
f0102692:	69 d2 ab aa aa aa    	imul   $0xaaaaaaab,%edx,%edx
f0102698:	c1 e2 0c             	shl    $0xc,%edx
}

static inline void*
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f010269b:	89 d0                	mov    %edx,%eax
f010269d:	c1 e8 0c             	shr    $0xc,%eax
f01026a0:	3b 05 ac 3f 2d f0    	cmp    0xf02d3fac,%eax
f01026a6:	72 20                	jb     f01026c8 <i386_vm_init+0x14a1>
f01026a8:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01026ac:	c7 44 24 08 00 69 10 	movl   $0xf0106900,0x8(%esp)
f01026b3:	f0 
f01026b4:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f01026bb:	00 
f01026bc:	c7 04 24 83 66 10 f0 	movl   $0xf0106683,(%esp)
f01026c3:	e8 bd d9 ff ff       	call   f0100085 <_panic>
	ptep = page2kva(pp0);
f01026c8:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f01026ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f01026d1:	f6 00 01             	testb  $0x1,(%eax)
f01026d4:	75 11                	jne    f01026e7 <i386_vm_init+0x14c0>
f01026d6:	8d 82 04 00 00 f0    	lea    -0xffffffc(%edx),%eax
// will be setup later.
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read (or write). 
void
i386_vm_init(void)
f01026dc:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(boot_pgdir, 0x0, 1);
	ptep = page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f01026e2:	f6 00 01             	testb  $0x1,(%eax)
f01026e5:	74 24                	je     f010270b <i386_vm_init+0x14e4>
f01026e7:	c7 44 24 0c b8 68 10 	movl   $0xf01068b8,0xc(%esp)
f01026ee:	f0 
f01026ef:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01026f6:	f0 
f01026f7:	c7 44 24 04 62 04 00 	movl   $0x462,0x4(%esp)
f01026fe:	00 
f01026ff:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102706:	e8 7a d9 ff ff       	call   f0100085 <_panic>
f010270b:	83 c0 04             	add    $0x4,%eax
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(boot_pgdir, 0x0, 1);
	ptep = page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
f010270e:	39 d0                	cmp    %edx,%eax
f0102710:	75 d0                	jne    f01026e2 <i386_vm_init+0x14bb>
		assert((ptep[i] & PTE_P) == 0);
	boot_pgdir[0] = 0;
f0102712:	a1 b4 3f 2d f0       	mov    0xf02d3fb4,%eax
f0102717:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f010271d:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102720:	66 c7 40 08 00 00    	movw   $0x0,0x8(%eax)

	// give free list back
	page_free_list = fl;
f0102726:	89 1d f8 32 2d f0    	mov    %ebx,0xf02d32f8

	// free the pages we took
	page_free(pp0);
f010272c:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010272f:	89 04 24             	mov    %eax,(%esp)
f0102732:	e8 36 e3 ff ff       	call   f0100a6d <page_free>
	page_free(pp1);
f0102737:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010273a:	89 04 24             	mov    %eax,(%esp)
f010273d:	e8 2b e3 ff ff       	call   f0100a6d <page_free>
	page_free(pp2);
f0102742:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0102745:	89 04 24             	mov    %eax,(%esp)
f0102748:	e8 20 e3 ff ff       	call   f0100a6d <page_free>
	
	cprintf("page_check() succeeded!\n");
f010274d:	c7 04 24 cf 68 10 f0 	movl   $0xf01068cf,(%esp)
f0102754:	e8 66 0c 00 00       	call   f01033bf <cprintf>
	// Your code goes here:

        
        //boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, physaddr_t pa, int perm)
             //PADDR woud be a multiple of 4096 as kernbase is also a multiple of 4096..so no roundup
        boot_map_segment(pgdir,UPAGES, n,PADDR(pages),PTE_U|PTE_P);
f0102759:	a1 b8 3f 2d f0       	mov    0xf02d3fb8,%eax
f010275e:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102763:	77 20                	ja     f0102785 <i386_vm_init+0x155e>
f0102765:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102769:	c7 44 24 08 a0 69 10 	movl   $0xf01069a0,0x8(%esp)
f0102770:	f0 
f0102771:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
f0102778:	00 
f0102779:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102780:	e8 00 d9 ff ff       	call   f0100085 <_panic>


          
         pages=boot_alloc(npage * sizeof(struct Page),PGSIZE);
           // assert((unsigned int)(&pages) % PGSIZE == 0);      
        n = ROUNDUP(npage * sizeof(struct Page), PGSIZE);
f0102785:	8b 4d b8             	mov    -0x48(%ebp),%ecx
f0102788:	8d 14 49             	lea    (%ecx,%ecx,2),%edx
f010278b:	8d 0c 95 ff 0f 00 00 	lea    0xfff(,%edx,4),%ecx
	// Your code goes here:

        
        //boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, physaddr_t pa, int perm)
             //PADDR woud be a multiple of 4096 as kernbase is also a multiple of 4096..so no roundup
        boot_map_segment(pgdir,UPAGES, n,PADDR(pages),PTE_U|PTE_P);
f0102792:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102798:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
f010279f:	00 
f01027a0:	05 00 00 00 10       	add    $0x10000000,%eax
f01027a5:	89 04 24             	mov    %eax,(%esp)
f01027a8:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f01027ad:	8b 45 bc             	mov    -0x44(%ebp),%eax
f01027b0:	e8 c0 e8 ff ff       	call   f0101075 <boot_map_segment>
	// (ie. perm = PTE_U | PTE_P).
	// Permissions:
	//    - the new image at UENVS  -- kernel R, user R
	//    - envs itself -- kernel RW, user NONE
	// LAB 3: Your code here.
            boot_map_segment(pgdir,UENVS,NENV*sizeof(struct Env),PADDR(envs),PTE_U|PTE_P);
f01027b5:	a1 00 33 2d f0       	mov    0xf02d3300,%eax
f01027ba:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01027bf:	77 20                	ja     f01027e1 <i386_vm_init+0x15ba>
f01027c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01027c5:	c7 44 24 08 a0 69 10 	movl   $0xf01069a0,0x8(%esp)
f01027cc:	f0 
f01027cd:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
f01027d4:	00 
f01027d5:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01027dc:	e8 a4 d8 ff ff       	call   f0100085 <_panic>
f01027e1:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
f01027e8:	00 
f01027e9:	05 00 00 00 10       	add    $0x10000000,%eax
f01027ee:	89 04 24             	mov    %eax,(%esp)
f01027f1:	b9 00 f0 01 00       	mov    $0x1f000,%ecx
f01027f6:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f01027fb:	8b 45 bc             	mov    -0x44(%ebp),%eax
f01027fe:	e8 72 e8 ff ff       	call   f0101075 <boot_map_segment>
	//     * [KSTACKTOP-PTSIZE, KSTACKTOP-KSTKSIZE) -- not backed; so if
	//       the kernel overflows its stack, it will fault rather than
	//       overwrite memory.  Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	// Your code goes here:
    boot_map_segment(pgdir,KSTACKTOP-KSTKSIZE, ROUNDUP(KSTKSIZE,PGSIZE),PADDR(bootstack),PTE_W|PTE_P);
f0102803:	bb 00 70 11 f0       	mov    $0xf0117000,%ebx
f0102808:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f010280e:	77 20                	ja     f0102830 <i386_vm_init+0x1609>
f0102810:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0102814:	c7 44 24 08 a0 69 10 	movl   $0xf01069a0,0x8(%esp)
f010281b:	f0 
f010281c:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
f0102823:	00 
f0102824:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f010282b:	e8 55 d8 ff ff       	call   f0100085 <_panic>
f0102830:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
f0102837:	00 
f0102838:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f010283e:	89 04 24             	mov    %eax,(%esp)
f0102841:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102846:	ba 00 80 bf ef       	mov    $0xefbf8000,%edx
f010284b:	8b 45 bc             	mov    -0x44(%ebp),%eax
f010284e:	e8 22 e8 ff ff       	call   f0101075 <boot_map_segment>
	// We might not have 2^32 - KERNBASE bytes of physical memory, but
	// we just set up the mapping anyway.
	// Permissions: kernel RW, user NONE
	// Your code goes here:

       boot_map_segment(pgdir,KERNBASE, 256*1024*1024,0,PTE_W|PTE_P);
f0102853:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
f010285a:	00 
f010285b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102862:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f0102867:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f010286c:	8b 45 bc             	mov    -0x44(%ebp),%eax
f010286f:	e8 01 e8 ff ff       	call   f0101075 <boot_map_segment>


	uint32_t i, n;
	pde_t *pgdir;
LIST_FIRST(&page_free_list);
	pgdir = boot_pgdir;
f0102874:	8b 3d b4 3f 2d f0    	mov    0xf02d3fb4,%edi
	// check pages array
	n = ROUNDUP(npage*sizeof(struct Page), PGSIZE);
f010287a:	6b 05 ac 3f 2d f0 0c 	imul   $0xc,0xf02d3fac,%eax
f0102881:	05 ff 0f 00 00       	add    $0xfff,%eax
f0102886:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010288b:	be 00 00 00 00       	mov    $0x0,%esi
f0102890:	e9 f2 00 00 00       	jmp    f0102987 <i386_vm_init+0x1760>
//cprintf("\nSIZE %d",sizeof(uintptr_t));

	for (i = 0; i < n; i += PGSIZE)
         {       
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102895:	8d 96 00 00 00 ef    	lea    -0x11000000(%esi),%edx
f010289b:	89 f8                	mov    %edi,%eax
f010289d:	e8 fe e2 ff ff       	call   f0100ba0 <check_va2pa>
f01028a2:	8b 15 b8 3f 2d f0    	mov    0xf02d3fb8,%edx
f01028a8:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f01028ae:	77 20                	ja     f01028d0 <i386_vm_init+0x16a9>
f01028b0:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01028b4:	c7 44 24 08 a0 69 10 	movl   $0xf01069a0,0x8(%esp)
f01028bb:	f0 
f01028bc:	c7 44 24 04 ae 01 00 	movl   $0x1ae,0x4(%esp)
f01028c3:	00 
f01028c4:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01028cb:	e8 b5 d7 ff ff       	call   f0100085 <_panic>
f01028d0:	8d 94 16 00 00 00 10 	lea    0x10000000(%esi,%edx,1),%edx
f01028d7:	39 d0                	cmp    %edx,%eax
f01028d9:	74 24                	je     f01028ff <i386_vm_init+0x16d8>
f01028db:	c7 44 24 0c 18 6e 10 	movl   $0xf0106e18,0xc(%esp)
f01028e2:	f0 
f01028e3:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01028ea:	f0 
f01028eb:	c7 44 24 04 ae 01 00 	movl   $0x1ae,0x4(%esp)
f01028f2:	00 
f01028f3:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01028fa:	e8 86 d7 ff ff       	call   f0100085 <_panic>
f01028ff:	be 00 00 00 00       	mov    $0x0,%esi

	
	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102904:	8d 96 00 00 c0 ee    	lea    -0x11400000(%esi),%edx
f010290a:	89 f8                	mov    %edi,%eax
f010290c:	e8 8f e2 ff ff       	call   f0100ba0 <check_va2pa>
f0102911:	8b 15 00 33 2d f0    	mov    0xf02d3300,%edx
f0102917:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f010291d:	77 20                	ja     f010293f <i386_vm_init+0x1718>
f010291f:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0102923:	c7 44 24 08 a0 69 10 	movl   $0xf01069a0,0x8(%esp)
f010292a:	f0 
f010292b:	c7 44 24 04 b4 01 00 	movl   $0x1b4,0x4(%esp)
f0102932:	00 
f0102933:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f010293a:	e8 46 d7 ff ff       	call   f0100085 <_panic>
f010293f:	8d 94 16 00 00 00 10 	lea    0x10000000(%esi,%edx,1),%edx
f0102946:	39 d0                	cmp    %edx,%eax
f0102948:	74 24                	je     f010296e <i386_vm_init+0x1747>
f010294a:	c7 44 24 0c 4c 6e 10 	movl   $0xf0106e4c,0xc(%esp)
f0102951:	f0 
f0102952:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0102959:	f0 
f010295a:	c7 44 24 04 b4 01 00 	movl   $0x1b4,0x4(%esp)
f0102961:	00 
f0102962:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102969:	e8 17 d7 ff ff       	call   f0100085 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);

	
	// check envs array (new test for lab 3)
	n = ROUNDUP(NENV*sizeof(struct Env), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f010296e:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0102974:	81 fe 00 f0 01 00    	cmp    $0x1f000,%esi
f010297a:	75 88                	jne    f0102904 <i386_vm_init+0x16dd>
	pgdir = boot_pgdir;
	// check pages array
	n = ROUNDUP(npage*sizeof(struct Page), PGSIZE);
//cprintf("\nSIZE %d",sizeof(uintptr_t));

	for (i = 0; i < n; i += PGSIZE)
f010297c:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0102982:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f0102987:	39 c6                	cmp    %eax,%esi
f0102989:	0f 82 06 ff ff ff    	jb     f0102895 <i386_vm_init+0x166e>
f010298f:	be 00 00 00 00       	mov    $0x0,%esi
f0102994:	eb 3b                	jmp    f01029d1 <i386_vm_init+0x17aa>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
	}

	// check phys mem
	for (i = 0; i < npage * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102996:	8d 96 00 00 00 f0    	lea    -0x10000000(%esi),%edx
f010299c:	89 f8                	mov    %edi,%eax
f010299e:	e8 fd e1 ff ff       	call   f0100ba0 <check_va2pa>
f01029a3:	39 c6                	cmp    %eax,%esi
f01029a5:	74 24                	je     f01029cb <i386_vm_init+0x17a4>
f01029a7:	c7 44 24 0c 80 6e 10 	movl   $0xf0106e80,0xc(%esp)
f01029ae:	f0 
f01029af:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01029b6:	f0 
f01029b7:	c7 44 24 04 b9 01 00 	movl   $0x1b9,0x4(%esp)
f01029be:	00 
f01029bf:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f01029c6:	e8 ba d6 ff ff       	call   f0100085 <_panic>
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
	}

	// check phys mem
	for (i = 0; i < npage * PGSIZE; i += PGSIZE)
f01029cb:	81 c6 00 10 00 00    	add    $0x1000,%esi
f01029d1:	a1 ac 3f 2d f0       	mov    0xf02d3fac,%eax
f01029d6:	c1 e0 0c             	shl    $0xc,%eax
f01029d9:	39 c6                	cmp    %eax,%esi
f01029db:	72 b9                	jb     f0102996 <i386_vm_init+0x176f>
f01029dd:	be 00 80 bf ef       	mov    $0xefbf8000,%esi
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f01029e2:	81 c3 00 80 40 20    	add    $0x20408000,%ebx
f01029e8:	89 f2                	mov    %esi,%edx
f01029ea:	89 f8                	mov    %edi,%eax
f01029ec:	e8 af e1 ff ff       	call   f0100ba0 <check_va2pa>
f01029f1:	8d 14 33             	lea    (%ebx,%esi,1),%edx
f01029f4:	39 d0                	cmp    %edx,%eax
f01029f6:	74 24                	je     f0102a1c <i386_vm_init+0x17f5>
f01029f8:	c7 44 24 0c a8 6e 10 	movl   $0xf0106ea8,0xc(%esp)
f01029ff:	f0 
f0102a00:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0102a07:	f0 
f0102a08:	c7 44 24 04 bd 01 00 	movl   $0x1bd,0x4(%esp)
f0102a0f:	00 
f0102a10:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102a17:	e8 69 d6 ff ff       	call   f0100085 <_panic>
f0102a1c:	81 c6 00 10 00 00    	add    $0x1000,%esi
	// check phys mem
	for (i = 0; i < npage * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102a22:	81 fe 00 00 c0 ef    	cmp    $0xefc00000,%esi
f0102a28:	75 be                	jne    f01029e8 <i386_vm_init+0x17c1>
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f0102a2a:	ba 00 00 80 ef       	mov    $0xef800000,%edx
f0102a2f:	89 f8                	mov    %edi,%eax
f0102a31:	e8 6a e1 ff ff       	call   f0100ba0 <check_va2pa>
f0102a36:	ba 00 00 00 00       	mov    $0x0,%edx
f0102a3b:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102a3e:	74 24                	je     f0102a64 <i386_vm_init+0x183d>
f0102a40:	c7 44 24 0c f0 6e 10 	movl   $0xf0106ef0,0xc(%esp)
f0102a47:	f0 
f0102a48:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0102a4f:	f0 
f0102a50:	c7 44 24 04 be 01 00 	movl   $0x1be,0x4(%esp)
f0102a57:	00 
f0102a58:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102a5f:	e8 21 d6 ff ff       	call   f0100085 <_panic>

       //cprintf("\n\n\n%x   %x   %x   %x",PDX(UVPT),PDX(KERNBASE));
	// check for zero/non-zero in PDEs
	for (i = 0; i < NPDENTRIES; i++) {
		switch (i) {
f0102a64:	8d 82 45 fc ff ff    	lea    -0x3bb(%edx),%eax
f0102a6a:	83 f8 04             	cmp    $0x4,%eax
f0102a6d:	77 2e                	ja     f0102a9d <i386_vm_init+0x1876>
		case PDX(VPT):
		case PDX(UVPT):
		case PDX(KSTACKTOP-1):
		case PDX(UPAGES):
		case PDX(UENVS):
			assert(pgdir[i]);
f0102a6f:	83 3c 97 00          	cmpl   $0x0,(%edi,%edx,4)
f0102a73:	0f 85 80 00 00 00    	jne    f0102af9 <i386_vm_init+0x18d2>
f0102a79:	c7 44 24 0c e8 68 10 	movl   $0xf01068e8,0xc(%esp)
f0102a80:	f0 
f0102a81:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0102a88:	f0 
f0102a89:	c7 44 24 04 c9 01 00 	movl   $0x1c9,0x4(%esp)
f0102a90:	00 
f0102a91:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102a98:	e8 e8 d5 ff ff       	call   f0100085 <_panic>
			break;
		default:
			if (i >= PDX(KERNBASE))
f0102a9d:	81 fa bf 03 00 00    	cmp    $0x3bf,%edx
f0102aa3:	76 2a                	jbe    f0102acf <i386_vm_init+0x18a8>
				assert(pgdir[i]);
f0102aa5:	83 3c 97 00          	cmpl   $0x0,(%edi,%edx,4)
f0102aa9:	75 4e                	jne    f0102af9 <i386_vm_init+0x18d2>
f0102aab:	c7 44 24 0c e8 68 10 	movl   $0xf01068e8,0xc(%esp)
f0102ab2:	f0 
f0102ab3:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0102aba:	f0 
f0102abb:	c7 44 24 04 cd 01 00 	movl   $0x1cd,0x4(%esp)
f0102ac2:	00 
f0102ac3:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102aca:	e8 b6 d5 ff ff       	call   f0100085 <_panic>
			else
				assert(pgdir[i] == 0);
f0102acf:	83 3c 97 00          	cmpl   $0x0,(%edi,%edx,4)
f0102ad3:	74 24                	je     f0102af9 <i386_vm_init+0x18d2>
f0102ad5:	c7 44 24 0c f1 68 10 	movl   $0xf01068f1,0xc(%esp)
f0102adc:	f0 
f0102add:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0102ae4:	f0 
f0102ae5:	c7 44 24 04 cf 01 00 	movl   $0x1cf,0x4(%esp)
f0102aec:	00 
f0102aed:	c7 04 24 77 66 10 f0 	movl   $0xf0106677,(%esp)
f0102af4:	e8 8c d5 ff ff       	call   f0100085 <_panic>
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);

       //cprintf("\n\n\n%x   %x   %x   %x",PDX(UVPT),PDX(KERNBASE));
	// check for zero/non-zero in PDEs
	for (i = 0; i < NPDENTRIES; i++) {
f0102af9:	83 c2 01             	add    $0x1,%edx
f0102afc:	81 fa 00 04 00 00    	cmp    $0x400,%edx
f0102b02:	0f 85 5c ff ff ff    	jne    f0102a64 <i386_vm_init+0x183d>
			else
				assert(pgdir[i] == 0);
			break;
		}
	}
	cprintf("check_boot_pgdir() succeeded!\n");
f0102b08:	c7 04 24 20 6f 10 f0 	movl   $0xf0106f20,(%esp)
f0102b0f:	e8 ab 08 00 00       	call   f01033bf <cprintf>
	// mapping, even though we are turning on paging and reconfiguring
	// segmentation.

	// Map VA 0:4MB same as VA KERNBASE, i.e. to PA 0:4MB.
	// (Limits our kernel to <4MB)
	pgdir[0] = pgdir[PDX(KERNBASE)];
f0102b14:	8b 55 bc             	mov    -0x44(%ebp),%edx
f0102b17:	8b 82 00 0f 00 00    	mov    0xf00(%edx),%eax
f0102b1d:	89 02                	mov    %eax,(%edx)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0102b1f:	a1 b0 3f 2d f0       	mov    0xf02d3fb0,%eax
f0102b24:	0f 22 d8             	mov    %eax,%cr3

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
f0102b27:	0f 20 c0             	mov    %cr0,%eax
	// Install page table.
	lcr3(boot_cr3);
      
	// Turn on paging.
	cr0 = rcr0();
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_TS|CR0_EM|CR0_MP;
f0102b2a:	0d 2f 00 05 80       	or     $0x8005002f,%eax
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
f0102b2f:	83 e0 f3             	and    $0xfffffff3,%eax
f0102b32:	0f 22 c0             	mov    %eax,%cr0
        //cprintf("HEy222");
	// Current mapping: KERNBASE+x => x => x.
	// (x < 4MB so uses paging pgdir[0])

	// Reload all segment registers.
	asm volatile("lgdt gdt_pd");
f0102b35:	0f 01 15 50 f3 11 f0 	lgdtl  0xf011f350
	asm volatile("movw %%ax,%%gs" :: "a" (GD_UD|3));
f0102b3c:	b8 23 00 00 00       	mov    $0x23,%eax
f0102b41:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" :: "a" (GD_UD|3));
f0102b43:	8e e0                	mov    %eax,%fs
	asm volatile("movw %%ax,%%es" :: "a" (GD_KD));
f0102b45:	b0 10                	mov    $0x10,%al
f0102b47:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" :: "a" (GD_KD));
f0102b49:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" :: "a" (GD_KD));
f0102b4b:	8e d0                	mov    %eax,%ss
	asm volatile("ljmp %0,$1f\n 1:\n" :: "i" (GD_KT));  // reload cs
f0102b4d:	ea 54 2b 10 f0 08 00 	ljmp   $0x8,$0xf0102b54
	asm volatile("lldt %%ax" :: "a" (0));
f0102b54:	b0 00                	mov    $0x0,%al
f0102b56:	0f 00 d0             	lldt   %ax
	// Final mapping: KERNBASE+x => KERNBASE+x => x.

	// This mapping was only used after paging was turned on but
	// before the segment registers were reloaded.
	
pgdir[0] = 0;
f0102b59:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0102b5f:	a1 b0 3f 2d f0       	mov    0xf02d3fb0,%eax
f0102b64:	0f 22 d8             	mov    %eax,%cr3
	// Flush the TLB for good measure, to kill the pgdir[0] mapping.
	lcr3(boot_cr3);
}
f0102b67:	83 c4 4c             	add    $0x4c,%esp
f0102b6a:	5b                   	pop    %ebx
f0102b6b:	5e                   	pop    %esi
f0102b6c:	5f                   	pop    %edi
f0102b6d:	5d                   	pop    %ebp
f0102b6e:	c3                   	ret    
	...

f0102b70 <envid2env>:
//   On success, sets *env_store to the environment.
//   On error, sets *env_store to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm)
{
f0102b70:	55                   	push   %ebp
f0102b71:	89 e5                	mov    %esp,%ebp
f0102b73:	53                   	push   %ebx
f0102b74:	8b 45 08             	mov    0x8(%ebp),%eax
f0102b77:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	struct Env *e;

	// If envid is zero, return the current environment.
	if (envid == 0) {
f0102b7a:	85 c0                	test   %eax,%eax
f0102b7c:	75 0e                	jne    f0102b8c <envid2env+0x1c>
		*env_store = curenv;
f0102b7e:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0102b83:	89 01                	mov    %eax,(%ecx)
f0102b85:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
f0102b8a:	eb 54                	jmp    f0102be0 <envid2env+0x70>
	// Look up the Env structure via the index part of the envid,
	// then check the env_id field in that struct Env
	// to ensure that the envid is not stale
	// (i.e., does not refer to a _previous_ environment
	// that used the same slot in the envs[] array).
	e = &envs[ENVX(envid)];
f0102b8c:	89 c2                	mov    %eax,%edx
f0102b8e:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0102b94:	6b d2 7c             	imul   $0x7c,%edx,%edx
f0102b97:	03 15 00 33 2d f0    	add    0xf02d3300,%edx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f0102b9d:	83 7a 54 00          	cmpl   $0x0,0x54(%edx)
f0102ba1:	74 05                	je     f0102ba8 <envid2env+0x38>
f0102ba3:	39 42 4c             	cmp    %eax,0x4c(%edx)
f0102ba6:	74 0d                	je     f0102bb5 <envid2env+0x45>
		*env_store = 0;
f0102ba8:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
f0102bae:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
		return -E_BAD_ENV;
f0102bb3:	eb 2b                	jmp    f0102be0 <envid2env+0x70>
	// Check that the calling environment has legitimate permission
	// to manipulate the specified environment.
	// If checkperm is set, the specified environment
	// must be either the current environment
	// or an immediate child of the current environment.
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0102bb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0102bb9:	74 1e                	je     f0102bd9 <envid2env+0x69>
f0102bbb:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0102bc0:	39 c2                	cmp    %eax,%edx
f0102bc2:	74 15                	je     f0102bd9 <envid2env+0x69>
f0102bc4:	8b 5a 50             	mov    0x50(%edx),%ebx
f0102bc7:	3b 58 4c             	cmp    0x4c(%eax),%ebx
f0102bca:	74 0d                	je     f0102bd9 <envid2env+0x69>
		*env_store = 0;
f0102bcc:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
f0102bd2:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
		return -E_BAD_ENV;
f0102bd7:	eb 07                	jmp    f0102be0 <envid2env+0x70>
	}

	*env_store = e;
f0102bd9:	89 11                	mov    %edx,(%ecx)
f0102bdb:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
f0102be0:	5b                   	pop    %ebx
f0102be1:	5d                   	pop    %ebp
f0102be2:	c3                   	ret    

f0102be3 <env_init>:
}
*/

void
env_init(void)
{
f0102be3:	55                   	push   %ebp
f0102be4:	89 e5                	mov    %esp,%ebp
        // LAB 3: Your code here.
        int iEnv = 0;
        LIST_INIT(&env_free_list);
f0102be6:	c7 05 08 33 2d f0 00 	movl   $0x0,0xf02d3308
f0102bed:	00 00 00 
f0102bf0:	b8 84 ef 01 00       	mov    $0x1ef84,%eax
        for(iEnv = NENV - 1; iEnv >=0 ; iEnv--)
        {
                envs[iEnv].env_id = 0;
f0102bf5:	8b 15 00 33 2d f0    	mov    0xf02d3300,%edx
f0102bfb:	c7 44 02 4c 00 00 00 	movl   $0x0,0x4c(%edx,%eax,1)
f0102c02:	00 
                LIST_INSERT_HEAD(&env_free_list, &envs[iEnv], env_link);
f0102c03:	8b 15 08 33 2d f0    	mov    0xf02d3308,%edx
f0102c09:	8b 0d 00 33 2d f0    	mov    0xf02d3300,%ecx
f0102c0f:	89 54 01 44          	mov    %edx,0x44(%ecx,%eax,1)
f0102c13:	85 d2                	test   %edx,%edx
f0102c15:	74 14                	je     f0102c2b <env_init+0x48>
f0102c17:	89 c1                	mov    %eax,%ecx
f0102c19:	03 0d 00 33 2d f0    	add    0xf02d3300,%ecx
f0102c1f:	83 c1 44             	add    $0x44,%ecx
f0102c22:	8b 15 08 33 2d f0    	mov    0xf02d3308,%edx
f0102c28:	89 4a 48             	mov    %ecx,0x48(%edx)
f0102c2b:	89 c2                	mov    %eax,%edx
f0102c2d:	03 15 00 33 2d f0    	add    0xf02d3300,%edx
f0102c33:	89 15 08 33 2d f0    	mov    %edx,0xf02d3308
f0102c39:	c7 42 48 08 33 2d f0 	movl   $0xf02d3308,0x48(%edx)
f0102c40:	83 e8 7c             	sub    $0x7c,%eax
env_init(void)
{
        // LAB 3: Your code here.
        int iEnv = 0;
        LIST_INIT(&env_free_list);
        for(iEnv = NENV - 1; iEnv >=0 ; iEnv--)
f0102c43:	83 f8 84             	cmp    $0xffffff84,%eax
f0102c46:	75 ad                	jne    f0102bf5 <env_init+0x12>
        {
                envs[iEnv].env_id = 0;
                LIST_INSERT_HEAD(&env_free_list, &envs[iEnv], env_link);
        }
}
f0102c48:	5d                   	pop    %ebp
f0102c49:	c3                   	ret    

f0102c4a <segment_alloc>:
// Panic if any allocation attempt fails.
//

static void
segment_alloc(struct Env *e, void *va, size_t len)
{
f0102c4a:	55                   	push   %ebp
f0102c4b:	89 e5                	mov    %esp,%ebp
f0102c4d:	57                   	push   %edi
f0102c4e:	56                   	push   %esi
f0102c4f:	53                   	push   %ebx
f0102c50:	83 ec 3c             	sub    $0x3c,%esp
f0102c53:	89 c6                	mov    %eax,%esi
	// LAB 3: Your code here.
	// (But only if you need it for load_icode.)
           //cprintf("sizeof%d",sizeof(va));
           va = ROUNDDOWN(va,PGSIZE);
f0102c55:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102c5b:	89 55 d0             	mov    %edx,-0x30(%ebp)
           len = ROUNDUP(len,PGSIZE);
f0102c5e:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
           //cprintf("va= %x len=%d",va,len);
           struct Page *p=NULL;
           uint32_t i=0;
            for(i=0;i<len;i+=PGSIZE)
f0102c64:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102c6a:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0102c6d:	74 68                	je     f0102cd7 <segment_alloc+0x8d>
	// (But only if you need it for load_icode.)
           //cprintf("sizeof%d",sizeof(va));
           va = ROUNDDOWN(va,PGSIZE);
           len = ROUNDUP(len,PGSIZE);
           //cprintf("va= %x len=%d",va,len);
           struct Page *p=NULL;
f0102c6f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0102c76:	bb 00 00 00 00       	mov    $0x0,%ebx
           uint32_t i=0;
            for(i=0;i<len;i+=PGSIZE)
                {    
                          if(page_alloc(&p)==0)
f0102c7b:	8d 7d e4             	lea    -0x1c(%ebp),%edi
f0102c7e:	89 3c 24             	mov    %edi,(%esp)
f0102c81:	e8 80 df ff ff       	call   f0100c06 <page_alloc>
f0102c86:	85 c0                	test   %eax,%eax
f0102c88:	75 31                	jne    f0102cbb <segment_alloc+0x71>
                         {
                          // cprintf("va= %x len=%d\n",va+i,len);
                           page_insert(e->env_pgdir,p,va+i,PTE_U|PTE_W); 
f0102c8a:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
f0102c91:	00 
f0102c92:	8b 55 d0             	mov    -0x30(%ebp),%edx
f0102c95:	8d 04 13             	lea    (%ebx,%edx,1),%eax
f0102c98:	89 44 24 08          	mov    %eax,0x8(%esp)
f0102c9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0102c9f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102ca3:	8b 46 5c             	mov    0x5c(%esi),%eax
f0102ca6:	89 04 24             	mov    %eax,(%esp)
f0102ca9:	e8 b5 e2 ff ff       	call   f0100f63 <page_insert>
           va = ROUNDDOWN(va,PGSIZE);
           len = ROUNDUP(len,PGSIZE);
           //cprintf("va= %x len=%d",va,len);
           struct Page *p=NULL;
           uint32_t i=0;
            for(i=0;i<len;i+=PGSIZE)
f0102cae:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102cb4:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f0102cb7:	77 c5                	ja     f0102c7e <segment_alloc+0x34>
f0102cb9:	eb 1c                	jmp    f0102cd7 <segment_alloc+0x8d>
                         {
                          // cprintf("va= %x len=%d\n",va+i,len);
                           page_insert(e->env_pgdir,p,va+i,PTE_U|PTE_W); 
                         }   
                     else
                     panic("Not available");
f0102cbb:	c7 44 24 08 3f 6f 10 	movl   $0xf0106f3f,0x8(%esp)
f0102cc2:	f0 
f0102cc3:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
f0102cca:	00 
f0102ccb:	c7 04 24 4d 6f 10 f0 	movl   $0xf0106f4d,(%esp)
f0102cd2:	e8 ae d3 ff ff       	call   f0100085 <_panic>
    
	//
	// Hint: It is easier to use segment_alloc if the caller can pass
	//   'va' and 'len' values that are not page-aligned.
	//   You should round va down, and round (va + len) up.
}
f0102cd7:	83 c4 3c             	add    $0x3c,%esp
f0102cda:	5b                   	pop    %ebx
f0102cdb:	5e                   	pop    %esi
f0102cdc:	5f                   	pop    %edi
f0102cdd:	5d                   	pop    %ebp
f0102cde:	c3                   	ret    

f0102cdf <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0102cdf:	55                   	push   %ebp
f0102ce0:	89 e5                	mov    %esp,%ebp
f0102ce2:	83 ec 18             	sub    $0x18,%esp
	__asm __volatile("movl %0,%%esp\n"
f0102ce5:	8b 65 08             	mov    0x8(%ebp),%esp
f0102ce8:	61                   	popa   
f0102ce9:	07                   	pop    %es
f0102cea:	1f                   	pop    %ds
f0102ceb:	83 c4 08             	add    $0x8,%esp
f0102cee:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0102cef:	c7 44 24 08 58 6f 10 	movl   $0xf0106f58,0x8(%esp)
f0102cf6:	f0 
f0102cf7:	c7 44 24 04 88 02 00 	movl   $0x288,0x4(%esp)
f0102cfe:	00 
f0102cff:	c7 04 24 4d 6f 10 f0 	movl   $0xf0106f4d,(%esp)
f0102d06:	e8 7a d3 ff ff       	call   f0100085 <_panic>

f0102d0b <env_run>:



void
env_run(struct Env *e)
{
f0102d0b:	55                   	push   %ebp
f0102d0c:	89 e5                	mov    %esp,%ebp
f0102d0e:	83 ec 18             	sub    $0x18,%esp
f0102d11:	8b 45 08             	mov    0x8(%ebp),%eax
        //      e->env_tf.  Go back through the code you wrote above
        //      and make sure you have set the relevant parts of
        //      e->env_tf to sensible values.

        // LAB 3: Your code here.
        curenv = e;
f0102d14:	a3 04 33 2d f0       	mov    %eax,0xf02d3304
        curenv->env_runs++;
f0102d19:	83 40 58 01          	addl   $0x1,0x58(%eax)
        lcr3(curenv->env_cr3);
f0102d1d:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0102d22:	8b 50 60             	mov    0x60(%eax),%edx
f0102d25:	0f 22 da             	mov    %edx,%cr3
        env_pop_tf(&curenv->env_tf);
f0102d28:	89 04 24             	mov    %eax,(%esp)
f0102d2b:	e8 af ff ff ff       	call   f0102cdf <env_pop_tf>

f0102d30 <env_free>:
//
// Frees env e and all memory it uses.
// 
void
env_free(struct Env *e)
{
f0102d30:	55                   	push   %ebp
f0102d31:	89 e5                	mov    %esp,%ebp
f0102d33:	57                   	push   %edi
f0102d34:	56                   	push   %esi
f0102d35:	53                   	push   %ebx
f0102d36:	83 ec 2c             	sub    $0x2c,%esp
f0102d39:	8b 7d 08             	mov    0x8(%ebp),%edi
	physaddr_t pa;
	
	// If freeing the current environment, switch to boot_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0102d3c:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0102d41:	39 c7                	cmp    %eax,%edi
f0102d43:	75 09                	jne    f0102d4e <env_free+0x1e>
f0102d45:	8b 15 b0 3f 2d f0    	mov    0xf02d3fb0,%edx
f0102d4b:	0f 22 da             	mov    %edx,%cr3
		lcr3(boot_cr3);

	// Note the environment's demise.
	 cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f0102d4e:	8b 4f 4c             	mov    0x4c(%edi),%ecx
f0102d51:	ba 00 00 00 00       	mov    $0x0,%edx
f0102d56:	85 c0                	test   %eax,%eax
f0102d58:	74 03                	je     f0102d5d <env_free+0x2d>
f0102d5a:	8b 50 4c             	mov    0x4c(%eax),%edx
f0102d5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0102d61:	89 54 24 04          	mov    %edx,0x4(%esp)
f0102d65:	c7 04 24 64 6f 10 f0 	movl   $0xf0106f64,(%esp)
f0102d6c:	e8 4e 06 00 00       	call   f01033bf <cprintf>
f0102d71:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0102d78:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0102d7b:	c1 e0 02             	shl    $0x2,%eax
f0102d7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {

		// only look at mapped page tables
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0102d81:	8b 47 5c             	mov    0x5c(%edi),%eax
f0102d84:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0102d87:	8b 34 10             	mov    (%eax,%edx,1),%esi
f0102d8a:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0102d90:	0f 84 bb 00 00 00    	je     f0102e51 <env_free+0x121>
			continue;

		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0102d96:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
		pt = (pte_t*) KADDR(pa);
f0102d9c:	89 f0                	mov    %esi,%eax
f0102d9e:	c1 e8 0c             	shr    $0xc,%eax
f0102da1:	89 45 dc             	mov    %eax,-0x24(%ebp)
f0102da4:	3b 05 ac 3f 2d f0    	cmp    0xf02d3fac,%eax
f0102daa:	72 20                	jb     f0102dcc <env_free+0x9c>
f0102dac:	89 74 24 0c          	mov    %esi,0xc(%esp)
f0102db0:	c7 44 24 08 00 69 10 	movl   $0xf0106900,0x8(%esp)
f0102db7:	f0 
f0102db8:	c7 44 24 04 4f 02 00 	movl   $0x24f,0x4(%esp)
f0102dbf:	00 
f0102dc0:	c7 04 24 4d 6f 10 f0 	movl   $0xf0106f4d,(%esp)
f0102dc7:	e8 b9 d2 ff ff       	call   f0100085 <_panic>

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0102dcc:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0102dcf:	c1 e2 16             	shl    $0x16,%edx
f0102dd2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0102dd5:	bb 00 00 00 00       	mov    $0x0,%ebx
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
			if (pt[pteno] & PTE_P)
f0102dda:	f6 84 9e 00 00 00 f0 	testb  $0x1,-0x10000000(%esi,%ebx,4)
f0102de1:	01 
f0102de2:	74 17                	je     f0102dfb <env_free+0xcb>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f0102de4:	89 d8                	mov    %ebx,%eax
f0102de6:	c1 e0 0c             	shl    $0xc,%eax
f0102de9:	0b 45 e4             	or     -0x1c(%ebp),%eax
f0102dec:	89 44 24 04          	mov    %eax,0x4(%esp)
f0102df0:	8b 47 5c             	mov    0x5c(%edi),%eax
f0102df3:	89 04 24             	mov    %eax,(%esp)
f0102df6:	e8 11 e1 ff ff       	call   f0100f0c <page_remove>
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f0102dfb:	83 c3 01             	add    $0x1,%ebx
f0102dfe:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0102e04:	75 d4                	jne    f0102dda <env_free+0xaa>
			if (pt[pteno] & PTE_P)
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0102e06:	8b 47 5c             	mov    0x5c(%edi),%eax
f0102e09:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0102e0c:	c7 04 10 00 00 00 00 	movl   $0x0,(%eax,%edx,1)
}

static inline struct Page*
pa2page(physaddr_t pa)
{
	if (PPN(pa) >= npage)
f0102e13:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0102e16:	3b 05 ac 3f 2d f0    	cmp    0xf02d3fac,%eax
f0102e1c:	72 1c                	jb     f0102e3a <env_free+0x10a>
		panic("pa2page called with invalid pa");
f0102e1e:	c7 44 24 08 5c 69 10 	movl   $0xf010695c,0x8(%esp)
f0102e25:	f0 
f0102e26:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
f0102e2d:	00 
f0102e2e:	c7 04 24 83 66 10 f0 	movl   $0xf0106683,(%esp)
f0102e35:	e8 4b d2 ff ff       	call   f0100085 <_panic>
		page_decref(pa2page(pa));
f0102e3a:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0102e3d:	8d 04 52             	lea    (%edx,%edx,2),%eax
f0102e40:	c1 e0 02             	shl    $0x2,%eax
f0102e43:	03 05 b8 3f 2d f0    	add    0xf02d3fb8,%eax
f0102e49:	89 04 24             	mov    %eax,(%esp)
f0102e4c:	e8 45 dc ff ff       	call   f0100a96 <page_decref>
	// Note the environment's demise.
	 cprintf("[%08x] free env %08x\n", curenv ? curenv->env_id : 0, e->env_id);

	// Flush all mapped pages in the user portion of the address space
	static_assert(UTOP % PTSIZE == 0);
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f0102e51:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
f0102e55:	81 7d e0 bb 03 00 00 	cmpl   $0x3bb,-0x20(%ebp)
f0102e5c:	0f 85 16 ff ff ff    	jne    f0102d78 <env_free+0x48>
		e->env_pgdir[pdeno] = 0;
		page_decref(pa2page(pa));
	}

	// free the page directory
	pa = e->env_cr3;
f0102e62:	8b 47 60             	mov    0x60(%edi),%eax
	e->env_pgdir = 0;
f0102e65:	c7 47 5c 00 00 00 00 	movl   $0x0,0x5c(%edi)
	e->env_cr3 = 0;
f0102e6c:	c7 47 60 00 00 00 00 	movl   $0x0,0x60(%edi)
}

static inline struct Page*
pa2page(physaddr_t pa)
{
	if (PPN(pa) >= npage)
f0102e73:	c1 e8 0c             	shr    $0xc,%eax
f0102e76:	3b 05 ac 3f 2d f0    	cmp    0xf02d3fac,%eax
f0102e7c:	72 1c                	jb     f0102e9a <env_free+0x16a>
		panic("pa2page called with invalid pa");
f0102e7e:	c7 44 24 08 5c 69 10 	movl   $0xf010695c,0x8(%esp)
f0102e85:	f0 
f0102e86:	c7 44 24 04 53 00 00 	movl   $0x53,0x4(%esp)
f0102e8d:	00 
f0102e8e:	c7 04 24 83 66 10 f0 	movl   $0xf0106683,(%esp)
f0102e95:	e8 eb d1 ff ff       	call   f0100085 <_panic>
	page_decref(pa2page(pa));
f0102e9a:	6b c0 0c             	imul   $0xc,%eax,%eax
f0102e9d:	03 05 b8 3f 2d f0    	add    0xf02d3fb8,%eax
f0102ea3:	89 04 24             	mov    %eax,(%esp)
f0102ea6:	e8 eb db ff ff       	call   f0100a96 <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f0102eab:	c7 47 54 00 00 00 00 	movl   $0x0,0x54(%edi)
	LIST_INSERT_HEAD(&env_free_list, e, env_link);
f0102eb2:	a1 08 33 2d f0       	mov    0xf02d3308,%eax
f0102eb7:	89 47 44             	mov    %eax,0x44(%edi)
f0102eba:	85 c0                	test   %eax,%eax
f0102ebc:	74 0b                	je     f0102ec9 <env_free+0x199>
f0102ebe:	8d 57 44             	lea    0x44(%edi),%edx
f0102ec1:	a1 08 33 2d f0       	mov    0xf02d3308,%eax
f0102ec6:	89 50 48             	mov    %edx,0x48(%eax)
f0102ec9:	89 3d 08 33 2d f0    	mov    %edi,0xf02d3308
f0102ecf:	c7 47 48 08 33 2d f0 	movl   $0xf02d3308,0x48(%edi)
}
f0102ed6:	83 c4 2c             	add    $0x2c,%esp
f0102ed9:	5b                   	pop    %ebx
f0102eda:	5e                   	pop    %esi
f0102edb:	5f                   	pop    %edi
f0102edc:	5d                   	pop    %ebp
f0102edd:	c3                   	ret    

f0102ede <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e) 
{
f0102ede:	55                   	push   %ebp
f0102edf:	89 e5                	mov    %esp,%ebp
f0102ee1:	53                   	push   %ebx
f0102ee2:	83 ec 14             	sub    $0x14,%esp
f0102ee5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	env_free(e);
f0102ee8:	89 1c 24             	mov    %ebx,(%esp)
f0102eeb:	e8 40 fe ff ff       	call   f0102d30 <env_free>

	if (curenv == e) {
f0102ef0:	39 1d 04 33 2d f0    	cmp    %ebx,0xf02d3304
f0102ef6:	75 0f                	jne    f0102f07 <env_destroy+0x29>
		curenv = NULL;
f0102ef8:	c7 05 04 33 2d f0 00 	movl   $0x0,0xf02d3304
f0102eff:	00 00 00 
		sched_yield();
f0102f02:	e8 b5 0e 00 00       	call   f0103dbc <sched_yield>
	}
}
f0102f07:	83 c4 14             	add    $0x14,%esp
f0102f0a:	5b                   	pop    %ebx
f0102f0b:	5d                   	pop    %ebp
f0102f0c:	c3                   	ret    

f0102f0d <env_alloc>:
//	-E_NO_FREE_ENV if all NENVS environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id)
{
f0102f0d:	55                   	push   %ebp
f0102f0e:	89 e5                	mov    %esp,%ebp
f0102f10:	53                   	push   %ebx
f0102f11:	83 ec 24             	sub    $0x24,%esp
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = LIST_FIRST(&env_free_list)))
f0102f14:	8b 1d 08 33 2d f0    	mov    0xf02d3308,%ebx
f0102f1a:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0102f1f:	85 db                	test   %ebx,%ebx
f0102f21:	0f 84 04 02 00 00    	je     f010312b <env_alloc+0x21e>

static int
env_setup_vm(struct Env *e)
{
        int i, r;
        struct Page *p = NULL;
f0102f27:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

        // Allocate a page for the page directory
        if ((r = page_alloc(&p)) < 0)
f0102f2e:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0102f31:	89 04 24             	mov    %eax,(%esp)
f0102f34:	e8 cd dc ff ff       	call   f0100c06 <page_alloc>
f0102f39:	85 c0                	test   %eax,%eax
f0102f3b:	0f 88 ea 01 00 00    	js     f010312b <env_alloc+0x21e>
        //      is an exception -- you need to increment env_pgdir's
        //      pp_ref for env_free to work correctly.
        //    - The functions in kern/pmap.h are handy.

        // LAB 3: Your code here.
        p->pp_ref++;
f0102f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102f44:	66 83 40 08 01       	addw   $0x1,0x8(%eax)
}

static inline physaddr_t
page2pa(struct Page *pp)
{
	return page2ppn(pp) << PGSHIFT;
f0102f49:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102f4c:	2b 05 b8 3f 2d f0    	sub    0xf02d3fb8,%eax
f0102f52:	c1 f8 02             	sar    $0x2,%eax
f0102f55:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0102f5b:	c1 e0 0c             	shl    $0xc,%eax
}

static inline void*
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0102f5e:	89 c2                	mov    %eax,%edx
f0102f60:	c1 ea 0c             	shr    $0xc,%edx
f0102f63:	3b 15 ac 3f 2d f0    	cmp    0xf02d3fac,%edx
f0102f69:	72 20                	jb     f0102f8b <env_alloc+0x7e>
f0102f6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102f6f:	c7 44 24 08 00 69 10 	movl   $0xf0106900,0x8(%esp)
f0102f76:	f0 
f0102f77:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0102f7e:	00 
f0102f7f:	c7 04 24 83 66 10 f0 	movl   $0xf0106683,(%esp)
f0102f86:	e8 fa d0 ff ff       	call   f0100085 <_panic>
        memset(page2kva(p), 0, PGSIZE);
f0102f8b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f0102f92:	00 
f0102f93:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0102f9a:	00 
f0102f9b:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102fa0:	89 04 24             	mov    %eax,(%esp)
f0102fa3:	e8 de 21 00 00       	call   f0105186 <memset>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
	return page2ppn(pp) << PGSHIFT;
f0102fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102fab:	2b 05 b8 3f 2d f0    	sub    0xf02d3fb8,%eax
f0102fb1:	c1 f8 02             	sar    $0x2,%eax
f0102fb4:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0102fba:	c1 e0 0c             	shl    $0xc,%eax
}

static inline void*
page2kva(struct Page *pp)
{
	return KADDR(page2pa(pp));
f0102fbd:	89 c2                	mov    %eax,%edx
f0102fbf:	c1 ea 0c             	shr    $0xc,%edx
f0102fc2:	3b 15 ac 3f 2d f0    	cmp    0xf02d3fac,%edx
f0102fc8:	72 20                	jb     f0102fea <env_alloc+0xdd>
f0102fca:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0102fce:	c7 44 24 08 00 69 10 	movl   $0xf0106900,0x8(%esp)
f0102fd5:	f0 
f0102fd6:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
f0102fdd:	00 
f0102fde:	c7 04 24 83 66 10 f0 	movl   $0xf0106683,(%esp)
f0102fe5:	e8 9b d0 ff ff       	call   f0100085 <_panic>
        e->env_pgdir = page2kva(p);
f0102fea:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102fef:	89 43 5c             	mov    %eax,0x5c(%ebx)
        e->env_cr3 = page2pa(p);
f0102ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0102ff5:	2b 05 b8 3f 2d f0    	sub    0xf02d3fb8,%eax
f0102ffb:	c1 f8 02             	sar    $0x2,%eax
f0102ffe:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0103004:	c1 e0 0c             	shl    $0xc,%eax
f0103007:	89 43 60             	mov    %eax,0x60(%ebx)
f010300a:	b8 00 00 00 00       	mov    $0x0,%eax
        {
                int iPgDirEntry = 0;
                for( iPgDirEntry = 0; iPgDirEntry < NPDENTRIES; iPgDirEntry++ )
                       e->env_pgdir[iPgDirEntry] = boot_pgdir[iPgDirEntry];
f010300f:	8b 53 5c             	mov    0x5c(%ebx),%edx
f0103012:	8b 0d b4 3f 2d f0    	mov    0xf02d3fb4,%ecx
f0103018:	8b 0c 01             	mov    (%ecx,%eax,1),%ecx
f010301b:	89 0c 02             	mov    %ecx,(%edx,%eax,1)
f010301e:	83 c0 04             	add    $0x4,%eax
        memset(page2kva(p), 0, PGSIZE);
        e->env_pgdir = page2kva(p);
        e->env_cr3 = page2pa(p);
        {
                int iPgDirEntry = 0;
                for( iPgDirEntry = 0; iPgDirEntry < NPDENTRIES; iPgDirEntry++ )
f0103021:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0103026:	75 e7                	jne    f010300f <env_alloc+0x102>
                       e->env_pgdir[iPgDirEntry] = boot_pgdir[iPgDirEntry];
        }
         // VPT and UVPT map the env's own page table, with
        // different permissions.
        e->env_pgdir[PDX(VPT)]  = e->env_cr3 | PTE_P | PTE_W;
f0103028:	8b 43 5c             	mov    0x5c(%ebx),%eax
f010302b:	8b 53 60             	mov    0x60(%ebx),%edx
f010302e:	83 ca 03             	or     $0x3,%edx
f0103031:	89 90 fc 0e 00 00    	mov    %edx,0xefc(%eax)
        e->env_pgdir[PDX(UVPT)] = e->env_cr3 | PTE_P | PTE_U;
f0103037:	8b 43 5c             	mov    0x5c(%ebx),%eax
f010303a:	8b 53 60             	mov    0x60(%ebx),%edx
f010303d:	83 ca 05             	or     $0x5,%edx
f0103040:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	// Allocate and set up the page directory for this environment.
	if ((r = env_setup_vm(e)) < 0)
		return r;

	// Generate an env_id for this environment.
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103046:	8b 43 4c             	mov    0x4c(%ebx),%eax
f0103049:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f010304e:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f0103053:	7f 05                	jg     f010305a <env_alloc+0x14d>
f0103055:	b8 00 10 00 00       	mov    $0x1000,%eax
		generation = 1 << ENVGENSHIFT;
	e->env_id = generation | (e - envs);
f010305a:	89 da                	mov    %ebx,%edx
f010305c:	2b 15 00 33 2d f0    	sub    0xf02d3300,%edx
f0103062:	c1 fa 02             	sar    $0x2,%edx
f0103065:	69 d2 df 7b ef bd    	imul   $0xbdef7bdf,%edx,%edx
f010306b:	09 d0                	or     %edx,%eax
f010306d:	89 43 4c             	mov    %eax,0x4c(%ebx)
	
	// Set the basic status variables.
	e->env_parent_id = parent_id;
f0103070:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103073:	89 43 50             	mov    %eax,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f0103076:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
	e->env_runs = 0;
f010307d:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)

	// Clear out all the saved register state,
	// to prevent the register values
	// of a prior environment inhabiting this Env structure
	// from "leaking" into our new environment.
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f0103084:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
f010308b:	00 
f010308c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103093:	00 
f0103094:	89 1c 24             	mov    %ebx,(%esp)
f0103097:	e8 ea 20 00 00       	call   f0105186 <memset>
	// Set up appropriate initial values for the segment registers.
	// GD_UD is the user data segment selector in the GDT, and 
	// GD_UT is the user text segment selector (see inc/memlayout.h).
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.
	e->env_tf.tf_ds = GD_UD | 3;
f010309c:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f01030a2:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f01030a8:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f01030ae:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f01030b5:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	// You will set e->env_tf.tf_eip later.

	// Enable interrupts while in user mode.
      	// LAB 4: Your code here.
           e->env_tf.tf_eflags = FL_IF;        
f01030bb:	c7 43 38 00 02 00 00 	movl   $0x200,0x38(%ebx)


	// Clear the page fault handler until user installs one.
	e->env_pgfault_upcall = 0;
f01030c2:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)

	// Also clear the IPC receiving flag.
	e->env_ipc_recving = 0;
f01030c9:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

	// If this is the file server (e == &envs[1]) give it I/O privileges.
	// LAB 5: Your code here.
         if(e==&envs[1])
f01030d0:	a1 00 33 2d f0       	mov    0xf02d3300,%eax
f01030d5:	83 c0 7c             	add    $0x7c,%eax
f01030d8:	39 d8                	cmp    %ebx,%eax
f01030da:	75 07                	jne    f01030e3 <env_alloc+0x1d6>
           e->env_tf.tf_eflags=e->env_tf.tf_eflags|FL_IOPL_3;   
f01030dc:	c7 40 38 00 32 00 00 	movl   $0x3200,0x38(%eax)
       
	// commit the allocation
	LIST_REMOVE(e, env_link);
f01030e3:	8b 43 44             	mov    0x44(%ebx),%eax
f01030e6:	85 c0                	test   %eax,%eax
f01030e8:	74 06                	je     f01030f0 <env_alloc+0x1e3>
f01030ea:	8b 53 48             	mov    0x48(%ebx),%edx
f01030ed:	89 50 48             	mov    %edx,0x48(%eax)
f01030f0:	8b 43 48             	mov    0x48(%ebx),%eax
f01030f3:	8b 53 44             	mov    0x44(%ebx),%edx
f01030f6:	89 10                	mov    %edx,(%eax)
	*newenv_store = e;
f01030f8:	8b 45 08             	mov    0x8(%ebp),%eax
f01030fb:	89 18                	mov    %ebx,(%eax)

	cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
f01030fd:	8b 4b 4c             	mov    0x4c(%ebx),%ecx
f0103100:	8b 15 04 33 2d f0    	mov    0xf02d3304,%edx
f0103106:	b8 00 00 00 00       	mov    $0x0,%eax
f010310b:	85 d2                	test   %edx,%edx
f010310d:	74 03                	je     f0103112 <env_alloc+0x205>
f010310f:	8b 42 4c             	mov    0x4c(%edx),%eax
f0103112:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0103116:	89 44 24 04          	mov    %eax,0x4(%esp)
f010311a:	c7 04 24 7a 6f 10 f0 	movl   $0xf0106f7a,(%esp)
f0103121:	e8 99 02 00 00       	call   f01033bf <cprintf>
f0103126:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
f010312b:	83 c4 24             	add    $0x24,%esp
f010312e:	5b                   	pop    %ebx
f010312f:	5d                   	pop    %ebp
f0103130:	c3                   	ret    

f0103131 <env_create>:
*/


void
env_create(uint8_t *binary, size_t size)
{
f0103131:	55                   	push   %ebp
f0103132:	89 e5                	mov    %esp,%ebp
f0103134:	57                   	push   %edi
f0103135:	56                   	push   %esi
f0103136:	53                   	push   %ebx
f0103137:	83 ec 3c             	sub    $0x3c,%esp
        struct Env *e = NULL;
f010313a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        if( 0 != env_alloc(&e, 0) )
f0103141:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0103148:	00 
f0103149:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010314c:	89 04 24             	mov    %eax,(%esp)
f010314f:	e8 b9 fd ff ff       	call   f0102f0d <env_alloc>
f0103154:	85 c0                	test   %eax,%eax
f0103156:	0f 85 9f 00 00 00    	jne    f01031fb <env_create+0xca>
                return;
        load_icode(e, binary, size);
f010315c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010315f:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0103162:	8b 40 60             	mov    0x60(%eax),%eax
f0103165:	0f 22 d8             	mov    %eax,%cr3
	// LAB 3: Your code here.
         

lcr3(e->env_cr3);
         struct Proghdr *ph, *eph;
         struct Elf *header=((struct Elf *)binary);
f0103168:	8b 45 08             	mov    0x8(%ebp),%eax
f010316b:	89 45 cc             	mov    %eax,-0x34(%ebp)
        ph = (struct Proghdr *)(((uint8_t *)header)+header->e_phoff);
f010316e:	89 c3                	mov    %eax,%ebx
f0103170:	03 58 1c             	add    0x1c(%eax),%ebx

        // load each program segment (ignores ph flags)
          
        eph = ph + header->e_phnum; 
f0103173:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
f0103177:	c1 e0 05             	shl    $0x5,%eax
f010317a:	8d 04 03             	lea    (%ebx,%eax,1),%eax
f010317d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             
     for (;ph < eph; ph++)
f0103180:	39 c3                	cmp    %eax,%ebx
f0103182:	73 51                	jae    f01031d5 <env_create+0xa4>
                {
                    if(ph->p_type == ELF_PROG_LOAD)
f0103184:	83 3b 01             	cmpl   $0x1,(%ebx)
f0103187:	75 44                	jne    f01031cd <env_create+0x9c>
                       {
                         uint8_t *va=(uint8_t *)ph->p_va;
f0103189:	8b 73 08             	mov    0x8(%ebx),%esi
                           uint8_t *endva=va+ph->p_memsz;
                           int i=0;
                           //cprintf("header loop\n"); 
                         segment_alloc(e,(uint8_t *)va,ph->p_memsz);
f010318c:	8b 4b 14             	mov    0x14(%ebx),%ecx
f010318f:	89 f2                	mov    %esi,%edx
f0103191:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0103194:	e8 b1 fa ff ff       	call   f0102c4a <segment_alloc>
                          
                         while(i<ph->p_memsz)
f0103199:	83 7b 14 00          	cmpl   $0x0,0x14(%ebx)
f010319d:	74 2e                	je     f01031cd <env_create+0x9c>
f010319f:	ba 00 00 00 00       	mov    $0x0,%edx
f01031a4:	b8 00 00 00 00       	mov    $0x0,%eax
                           { 
                              if(i<ph->p_filesz)
f01031a9:	39 53 10             	cmp    %edx,0x10(%ebx)
f01031ac:	76 11                	jbe    f01031bf <env_create+0x8e>
                                 *(va+i)= *(binary + ph->p_offset+i);
f01031ae:	8b 4b 04             	mov    0x4(%ebx),%ecx
f01031b1:	8b 7d 08             	mov    0x8(%ebp),%edi
f01031b4:	01 d7                	add    %edx,%edi
f01031b6:	0f b6 0c 0f          	movzbl (%edi,%ecx,1),%ecx
f01031ba:	88 0c 16             	mov    %cl,(%esi,%edx,1)
f01031bd:	eb 04                	jmp    f01031c3 <env_create+0x92>
                               else
                                *(va+i)=0;
f01031bf:	c6 04 16 00          	movb   $0x0,(%esi,%edx,1)
                               i++;
f01031c3:	83 c0 01             	add    $0x1,%eax
f01031c6:	89 c2                	mov    %eax,%edx
                           uint8_t *endva=va+ph->p_memsz;
                           int i=0;
                           //cprintf("header loop\n"); 
                         segment_alloc(e,(uint8_t *)va,ph->p_memsz);
                          
                         while(i<ph->p_memsz)
f01031c8:	39 43 14             	cmp    %eax,0x14(%ebx)
f01031cb:	77 dc                	ja     f01031a9 <env_create+0x78>

        // load each program segment (ignores ph flags)
          
        eph = ph + header->e_phnum; 
             
     for (;ph < eph; ph++)
f01031cd:	83 c3 20             	add    $0x20,%ebx
f01031d0:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f01031d3:	77 af                	ja     f0103184 <env_create+0x53>
f01031d5:	a1 b0 3f 2d f0       	mov    0xf02d3fb0,%eax
f01031da:	0f 22 d8             	mov    %eax,%cr3
         //cprintf("here before");     
                    lcr3(boot_cr3);  
         //cprintf("here under");   
 	// Now map one page for the program's initial stack
	// at virtual address USTACKTOP - PGSIZE.
        e->env_tf.tf_eip = (header)->e_entry;
f01031dd:	8b 55 cc             	mov    -0x34(%ebp),%edx
f01031e0:	8b 42 18             	mov    0x18(%edx),%eax
f01031e3:	8b 55 d0             	mov    -0x30(%ebp),%edx
f01031e6:	89 42 30             	mov    %eax,0x30(%edx)
          
       segment_alloc(e,(void *)(USTACKTOP-PGSIZE),PGSIZE);
f01031e9:	b9 00 10 00 00       	mov    $0x1000,%ecx
f01031ee:	ba 00 d0 bf ee       	mov    $0xeebfd000,%edx
f01031f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01031f6:	e8 4f fa ff ff       	call   f0102c4a <segment_alloc>
{
        struct Env *e = NULL;
        if( 0 != env_alloc(&e, 0) )
                return;
        load_icode(e, binary, size);
}
f01031fb:	83 c4 3c             	add    $0x3c,%esp
f01031fe:	5b                   	pop    %ebx
f01031ff:	5e                   	pop    %esi
f0103200:	5f                   	pop    %edi
f0103201:	5d                   	pop    %ebp
f0103202:	c3                   	ret    
	...

f0103204 <mc146818_read>:
#include <kern/picirq.h>


unsigned
mc146818_read(unsigned reg)
{
f0103204:	55                   	push   %ebp
f0103205:	89 e5                	mov    %esp,%ebp
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103207:	ba 70 00 00 00       	mov    $0x70,%edx
f010320c:	8b 45 08             	mov    0x8(%ebp),%eax
f010320f:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103210:	b2 71                	mov    $0x71,%dl
f0103212:	ec                   	in     (%dx),%al
f0103213:	0f b6 c0             	movzbl %al,%eax
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
}
f0103216:	5d                   	pop    %ebp
f0103217:	c3                   	ret    

f0103218 <mc146818_write>:

void
mc146818_write(unsigned reg, unsigned datum)
{
f0103218:	55                   	push   %ebp
f0103219:	89 e5                	mov    %esp,%ebp
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010321b:	ba 70 00 00 00       	mov    $0x70,%edx
f0103220:	8b 45 08             	mov    0x8(%ebp),%eax
f0103223:	ee                   	out    %al,(%dx)
f0103224:	b2 71                	mov    $0x71,%dl
f0103226:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103229:	ee                   	out    %al,(%dx)
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f010322a:	5d                   	pop    %ebp
f010322b:	c3                   	ret    

f010322c <kclock_init>:


void
kclock_init(void)
{
f010322c:	55                   	push   %ebp
f010322d:	89 e5                	mov    %esp,%ebp
f010322f:	83 ec 18             	sub    $0x18,%esp
f0103232:	ba 43 00 00 00       	mov    $0x43,%edx
f0103237:	b8 34 00 00 00       	mov    $0x34,%eax
f010323c:	ee                   	out    %al,(%dx)
f010323d:	b2 40                	mov    $0x40,%dl
f010323f:	b8 9c ff ff ff       	mov    $0xffffff9c,%eax
f0103244:	ee                   	out    %al,(%dx)
f0103245:	b8 2e 00 00 00       	mov    $0x2e,%eax
f010324a:	ee                   	out    %al,(%dx)
	/* initialize 8253 clock to interrupt 100 times/sec */
	outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
	outb(IO_TIMER1, TIMER_DIV(100) % 256);
	outb(IO_TIMER1, TIMER_DIV(100) / 256);
	cprintf("	Setup timer interrupts via 8259A\n");
f010324b:	c7 04 24 90 6f 10 f0 	movl   $0xf0106f90,(%esp)
f0103252:	e8 68 01 00 00       	call   f01033bf <cprintf>
	irq_setmask_8259A(irq_mask_8259A & ~(1<<0));
f0103257:	0f b7 05 58 f3 11 f0 	movzwl 0xf011f358,%eax
f010325e:	25 fe ff 00 00       	and    $0xfffe,%eax
f0103263:	89 04 24             	mov    %eax,(%esp)
f0103266:	e8 24 00 00 00       	call   f010328f <irq_setmask_8259A>
	cprintf("	unmasked timer interrupt\n");
f010326b:	c7 04 24 b3 6f 10 f0 	movl   $0xf0106fb3,(%esp)
f0103272:	e8 48 01 00 00       	call   f01033bf <cprintf>
}
f0103277:	c9                   	leave  
f0103278:	c3                   	ret    
f0103279:	00 00                	add    %al,(%eax)
	...

f010327c <irq_eoi>:
	cprintf("\n");
}

void
irq_eoi(void)
{
f010327c:	55                   	push   %ebp
f010327d:	89 e5                	mov    %esp,%ebp
f010327f:	ba 20 00 00 00       	mov    $0x20,%edx
f0103284:	b8 20 00 00 00       	mov    $0x20,%eax
f0103289:	ee                   	out    %al,(%dx)
f010328a:	b2 a0                	mov    $0xa0,%dl
f010328c:	ee                   	out    %al,(%dx)
	//   s: specific
	//   e: end-of-interrupt
	// xxx: specific interrupt line
	outb(IO_PIC1, 0x20);
	outb(IO_PIC2, 0x20);
}
f010328d:	5d                   	pop    %ebp
f010328e:	c3                   	ret    

f010328f <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f010328f:	55                   	push   %ebp
f0103290:	89 e5                	mov    %esp,%ebp
f0103292:	56                   	push   %esi
f0103293:	53                   	push   %ebx
f0103294:	83 ec 10             	sub    $0x10,%esp
f0103297:	8b 45 08             	mov    0x8(%ebp),%eax
f010329a:	89 c6                	mov    %eax,%esi
	int i;
	irq_mask_8259A = mask;
f010329c:	66 a3 58 f3 11 f0    	mov    %ax,0xf011f358
	if (!didinit)
f01032a2:	83 3d 0c 33 2d f0 00 	cmpl   $0x0,0xf02d330c
f01032a9:	74 4e                	je     f01032f9 <irq_setmask_8259A+0x6a>
f01032ab:	ba 21 00 00 00       	mov    $0x21,%edx
f01032b0:	ee                   	out    %al,(%dx)
f01032b1:	89 f0                	mov    %esi,%eax
f01032b3:	66 c1 e8 08          	shr    $0x8,%ax
f01032b7:	b2 a1                	mov    $0xa1,%dl
f01032b9:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
	cprintf("enabled interrupts:");
f01032ba:	c7 04 24 ce 6f 10 f0 	movl   $0xf0106fce,(%esp)
f01032c1:	e8 f9 00 00 00       	call   f01033bf <cprintf>
f01032c6:	bb 00 00 00 00       	mov    $0x0,%ebx
	for (i = 0; i < 16; i++)
		if (~mask & (1<<i))
f01032cb:	0f b7 f6             	movzwl %si,%esi
f01032ce:	f7 d6                	not    %esi
f01032d0:	0f a3 de             	bt     %ebx,%esi
f01032d3:	73 10                	jae    f01032e5 <irq_setmask_8259A+0x56>
			cprintf(" %d", i);
f01032d5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01032d9:	c7 04 24 54 74 10 f0 	movl   $0xf0107454,(%esp)
f01032e0:	e8 da 00 00 00       	call   f01033bf <cprintf>
	if (!didinit)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
	cprintf("enabled interrupts:");
	for (i = 0; i < 16; i++)
f01032e5:	83 c3 01             	add    $0x1,%ebx
f01032e8:	83 fb 10             	cmp    $0x10,%ebx
f01032eb:	75 e3                	jne    f01032d0 <irq_setmask_8259A+0x41>
		if (~mask & (1<<i))
			cprintf(" %d", i);
	cprintf("\n");
f01032ed:	c7 04 24 75 66 10 f0 	movl   $0xf0106675,(%esp)
f01032f4:	e8 c6 00 00 00       	call   f01033bf <cprintf>
}
f01032f9:	83 c4 10             	add    $0x10,%esp
f01032fc:	5b                   	pop    %ebx
f01032fd:	5e                   	pop    %esi
f01032fe:	5d                   	pop    %ebp
f01032ff:	c3                   	ret    

f0103300 <pic_init>:
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f0103300:	55                   	push   %ebp
f0103301:	89 e5                	mov    %esp,%ebp
f0103303:	83 ec 18             	sub    $0x18,%esp
	didinit = 1;
f0103306:	c7 05 0c 33 2d f0 01 	movl   $0x1,0xf02d330c
f010330d:	00 00 00 
f0103310:	ba 21 00 00 00       	mov    $0x21,%edx
f0103315:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010331a:	ee                   	out    %al,(%dx)
f010331b:	b2 a1                	mov    $0xa1,%dl
f010331d:	ee                   	out    %al,(%dx)
f010331e:	b2 20                	mov    $0x20,%dl
f0103320:	b8 11 00 00 00       	mov    $0x11,%eax
f0103325:	ee                   	out    %al,(%dx)
f0103326:	b2 21                	mov    $0x21,%dl
f0103328:	b8 20 00 00 00       	mov    $0x20,%eax
f010332d:	ee                   	out    %al,(%dx)
f010332e:	b8 04 00 00 00       	mov    $0x4,%eax
f0103333:	ee                   	out    %al,(%dx)
f0103334:	b8 03 00 00 00       	mov    $0x3,%eax
f0103339:	ee                   	out    %al,(%dx)
f010333a:	b2 a0                	mov    $0xa0,%dl
f010333c:	b8 11 00 00 00       	mov    $0x11,%eax
f0103341:	ee                   	out    %al,(%dx)
f0103342:	b2 a1                	mov    $0xa1,%dl
f0103344:	b8 28 00 00 00       	mov    $0x28,%eax
f0103349:	ee                   	out    %al,(%dx)
f010334a:	b8 02 00 00 00       	mov    $0x2,%eax
f010334f:	ee                   	out    %al,(%dx)
f0103350:	b8 01 00 00 00       	mov    $0x1,%eax
f0103355:	ee                   	out    %al,(%dx)
f0103356:	b2 20                	mov    $0x20,%dl
f0103358:	b8 68 00 00 00       	mov    $0x68,%eax
f010335d:	ee                   	out    %al,(%dx)
f010335e:	b8 0a 00 00 00       	mov    $0xa,%eax
f0103363:	ee                   	out    %al,(%dx)
f0103364:	b2 a0                	mov    $0xa0,%dl
f0103366:	b8 68 00 00 00       	mov    $0x68,%eax
f010336b:	ee                   	out    %al,(%dx)
f010336c:	b8 0a 00 00 00       	mov    $0xa,%eax
f0103371:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f0103372:	0f b7 05 58 f3 11 f0 	movzwl 0xf011f358,%eax
f0103379:	66 83 f8 ff          	cmp    $0xffffffff,%ax
f010337d:	74 0b                	je     f010338a <pic_init+0x8a>
		irq_setmask_8259A(irq_mask_8259A);
f010337f:	0f b7 c0             	movzwl %ax,%eax
f0103382:	89 04 24             	mov    %eax,(%esp)
f0103385:	e8 05 ff ff ff       	call   f010328f <irq_setmask_8259A>
}
f010338a:	c9                   	leave  
f010338b:	c3                   	ret    

f010338c <vcprintf>:
	*cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
f010338c:	55                   	push   %ebp
f010338d:	89 e5                	mov    %esp,%ebp
f010338f:	83 ec 28             	sub    $0x28,%esp
	int cnt = 0;
f0103392:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103399:	8b 45 0c             	mov    0xc(%ebp),%eax
f010339c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01033a0:	8b 45 08             	mov    0x8(%ebp),%eax
f01033a3:	89 44 24 08          	mov    %eax,0x8(%esp)
f01033a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
f01033aa:	89 44 24 04          	mov    %eax,0x4(%esp)
f01033ae:	c7 04 24 d9 33 10 f0 	movl   $0xf01033d9,(%esp)
f01033b5:	e8 53 16 00 00       	call   f0104a0d <vprintfmt>
	return cnt;
}
f01033ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01033bd:	c9                   	leave  
f01033be:	c3                   	ret    

f01033bf <cprintf>:

int
cprintf(const char *fmt, ...)
{
f01033bf:	55                   	push   %ebp
f01033c0:	89 e5                	mov    %esp,%ebp
f01033c2:	83 ec 18             	sub    $0x18,%esp
	vprintfmt((void*)putch, &cnt, fmt, ap);
	return cnt;
}

int
cprintf(const char *fmt, ...)
f01033c5:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
f01033c8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01033cc:	8b 45 08             	mov    0x8(%ebp),%eax
f01033cf:	89 04 24             	mov    %eax,(%esp)
f01033d2:	e8 b5 ff ff ff       	call   f010338c <vcprintf>
	va_end(ap);

	return cnt;
}
f01033d7:	c9                   	leave  
f01033d8:	c3                   	ret    

f01033d9 <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f01033d9:	55                   	push   %ebp
f01033da:	89 e5                	mov    %esp,%ebp
f01033dc:	83 ec 18             	sub    $0x18,%esp
	cputchar(ch);
f01033df:	8b 45 08             	mov    0x8(%ebp),%eax
f01033e2:	89 04 24             	mov    %eax,(%esp)
f01033e5:	e8 a0 d0 ff ff       	call   f010048a <cputchar>
	*cnt++;
}
f01033ea:	c9                   	leave  
f01033eb:	c3                   	ret    
f01033ec:	00 00                	add    %al,(%eax)
	...

f01033f0 <idt_init>:
}


void
idt_init(void)
{
f01033f0:	55                   	push   %ebp
f01033f1:	89 e5                	mov    %esp,%ebp

        //Initial system call entry
        SETGATE(idt[T_SYSCALL], 1, GD_KT,tsyscall, 3);
*/

        SETGATE(idt[IRQ_TIMER+IRQ_OFFSET],  0, GD_KT, handleTIMER,  0)
f01033f3:	b8 64 3d 10 f0       	mov    $0xf0103d64,%eax
f01033f8:	66 a3 20 34 2d f0    	mov    %ax,0xf02d3420
f01033fe:	66 c7 05 22 34 2d f0 	movw   $0x8,0xf02d3422
f0103405:	08 00 
f0103407:	c6 05 24 34 2d f0 00 	movb   $0x0,0xf02d3424
f010340e:	c6 05 25 34 2d f0 8e 	movb   $0x8e,0xf02d3425
f0103415:	c1 e8 10             	shr    $0x10,%eax
f0103418:	66 a3 26 34 2d f0    	mov    %ax,0xf02d3426
        SETGATE(idt[IRQ_KBD+IRQ_OFFSET],  0, GD_KT, handleKBD,  0)
f010341e:	b8 6a 3d 10 f0       	mov    $0xf0103d6a,%eax
f0103423:	66 a3 28 34 2d f0    	mov    %ax,0xf02d3428
f0103429:	66 c7 05 2a 34 2d f0 	movw   $0x8,0xf02d342a
f0103430:	08 00 
f0103432:	c6 05 2c 34 2d f0 00 	movb   $0x0,0xf02d342c
f0103439:	c6 05 2d 34 2d f0 8e 	movb   $0x8e,0xf02d342d
f0103440:	c1 e8 10             	shr    $0x10,%eax
f0103443:	66 a3 2e 34 2d f0    	mov    %ax,0xf02d342e
        SETGATE(idt[IRQ_SERIAL+IRQ_OFFSET],  0, GD_KT, handleSERIAL,  0)
f0103449:	b8 70 3d 10 f0       	mov    $0xf0103d70,%eax
f010344e:	66 a3 40 34 2d f0    	mov    %ax,0xf02d3440
f0103454:	66 c7 05 42 34 2d f0 	movw   $0x8,0xf02d3442
f010345b:	08 00 
f010345d:	c6 05 44 34 2d f0 00 	movb   $0x0,0xf02d3444
f0103464:	c6 05 45 34 2d f0 8e 	movb   $0x8e,0xf02d3445
f010346b:	c1 e8 10             	shr    $0x10,%eax
f010346e:	66 a3 46 34 2d f0    	mov    %ax,0xf02d3446
        SETGATE(idt[IRQ_SPURIOUS+IRQ_OFFSET],  0, GD_KT, handleSPURIOUS,  0)
f0103474:	b8 76 3d 10 f0       	mov    $0xf0103d76,%eax
f0103479:	66 a3 58 34 2d f0    	mov    %ax,0xf02d3458
f010347f:	66 c7 05 5a 34 2d f0 	movw   $0x8,0xf02d345a
f0103486:	08 00 
f0103488:	c6 05 5c 34 2d f0 00 	movb   $0x0,0xf02d345c
f010348f:	c6 05 5d 34 2d f0 8e 	movb   $0x8e,0xf02d345d
f0103496:	c1 e8 10             	shr    $0x10,%eax
f0103499:	66 a3 5e 34 2d f0    	mov    %ax,0xf02d345e
        SETGATE(idt[IRQ_IDE+IRQ_OFFSET],  0, GD_KT, handleIDE,  0)
f010349f:	b8 7c 3d 10 f0       	mov    $0xf0103d7c,%eax
f01034a4:	66 a3 90 34 2d f0    	mov    %ax,0xf02d3490
f01034aa:	66 c7 05 92 34 2d f0 	movw   $0x8,0xf02d3492
f01034b1:	08 00 
f01034b3:	c6 05 94 34 2d f0 00 	movb   $0x0,0xf02d3494
f01034ba:	c6 05 95 34 2d f0 8e 	movb   $0x8e,0xf02d3495
f01034c1:	c1 e8 10             	shr    $0x10,%eax
f01034c4:	66 a3 96 34 2d f0    	mov    %ax,0xf02d3496
        SETGATE(idt[IRQ_ERROR+IRQ_OFFSET],  0, GD_KT, handleERROR, 0)
f01034ca:	b8 82 3d 10 f0       	mov    $0xf0103d82,%eax
f01034cf:	66 a3 b8 34 2d f0    	mov    %ax,0xf02d34b8
f01034d5:	66 c7 05 ba 34 2d f0 	movw   $0x8,0xf02d34ba
f01034dc:	08 00 
f01034de:	c6 05 bc 34 2d f0 00 	movb   $0x0,0xf02d34bc
f01034e5:	c6 05 bd 34 2d f0 8e 	movb   $0x8e,0xf02d34bd
f01034ec:	c1 e8 10             	shr    $0x10,%eax
f01034ef:	66 a3 be 34 2d f0    	mov    %ax,0xf02d34be
       
        SETGATE(idt[T_DIVIDE],  0, GD_KT, handleDIVIDE,  0)
f01034f5:	b8 18 3d 10 f0       	mov    $0xf0103d18,%eax
f01034fa:	66 a3 20 33 2d f0    	mov    %ax,0xf02d3320
f0103500:	66 c7 05 22 33 2d f0 	movw   $0x8,0xf02d3322
f0103507:	08 00 
f0103509:	c6 05 24 33 2d f0 00 	movb   $0x0,0xf02d3324
f0103510:	c6 05 25 33 2d f0 8e 	movb   $0x8e,0xf02d3325
f0103517:	c1 e8 10             	shr    $0x10,%eax
f010351a:	66 a3 26 33 2d f0    	mov    %ax,0xf02d3326
        SETGATE(idt[T_DEBUG],   0, GD_KT, handleDEBUG,   0)
f0103520:	b8 22 3d 10 f0       	mov    $0xf0103d22,%eax
f0103525:	66 a3 28 33 2d f0    	mov    %ax,0xf02d3328
f010352b:	66 c7 05 2a 33 2d f0 	movw   $0x8,0xf02d332a
f0103532:	08 00 
f0103534:	c6 05 2c 33 2d f0 00 	movb   $0x0,0xf02d332c
f010353b:	c6 05 2d 33 2d f0 8e 	movb   $0x8e,0xf02d332d
f0103542:	c1 e8 10             	shr    $0x10,%eax
f0103545:	66 a3 2e 33 2d f0    	mov    %ax,0xf02d332e
        SETGATE(idt[T_NMI],     0, GD_KT, handleNMI,     0)
f010354b:	b8 28 3d 10 f0       	mov    $0xf0103d28,%eax
f0103550:	66 a3 30 33 2d f0    	mov    %ax,0xf02d3330
f0103556:	66 c7 05 32 33 2d f0 	movw   $0x8,0xf02d3332
f010355d:	08 00 
f010355f:	c6 05 34 33 2d f0 00 	movb   $0x0,0xf02d3334
f0103566:	c6 05 35 33 2d f0 8e 	movb   $0x8e,0xf02d3335
f010356d:	c1 e8 10             	shr    $0x10,%eax
f0103570:	66 a3 36 33 2d f0    	mov    %ax,0xf02d3336
        SETGATE(idt[T_BRKPT],   0, GD_KT, handleBRKPT,   3)
f0103576:	b8 2e 3d 10 f0       	mov    $0xf0103d2e,%eax
f010357b:	66 a3 38 33 2d f0    	mov    %ax,0xf02d3338
f0103581:	66 c7 05 3a 33 2d f0 	movw   $0x8,0xf02d333a
f0103588:	08 00 
f010358a:	c6 05 3c 33 2d f0 00 	movb   $0x0,0xf02d333c
f0103591:	c6 05 3d 33 2d f0 ee 	movb   $0xee,0xf02d333d
f0103598:	c1 e8 10             	shr    $0x10,%eax
f010359b:	66 a3 3e 33 2d f0    	mov    %ax,0xf02d333e
        SETGATE(idt[T_OFLOW],   1, GD_KT, handleOFLOW,   0)
f01035a1:	b8 34 3d 10 f0       	mov    $0xf0103d34,%eax
f01035a6:	66 a3 40 33 2d f0    	mov    %ax,0xf02d3340
f01035ac:	66 c7 05 42 33 2d f0 	movw   $0x8,0xf02d3342
f01035b3:	08 00 
f01035b5:	c6 05 44 33 2d f0 00 	movb   $0x0,0xf02d3344
f01035bc:	c6 05 45 33 2d f0 8f 	movb   $0x8f,0xf02d3345
f01035c3:	c1 e8 10             	shr    $0x10,%eax
f01035c6:	66 a3 46 33 2d f0    	mov    %ax,0xf02d3346
        SETGATE(idt[T_BOUND],   0, GD_KT, handleBOUND,   0)
f01035cc:	b8 3a 3d 10 f0       	mov    $0xf0103d3a,%eax
f01035d1:	66 a3 48 33 2d f0    	mov    %ax,0xf02d3348
f01035d7:	66 c7 05 4a 33 2d f0 	movw   $0x8,0xf02d334a
f01035de:	08 00 
f01035e0:	c6 05 4c 33 2d f0 00 	movb   $0x0,0xf02d334c
f01035e7:	c6 05 4d 33 2d f0 8e 	movb   $0x8e,0xf02d334d
f01035ee:	c1 e8 10             	shr    $0x10,%eax
f01035f1:	66 a3 4e 33 2d f0    	mov    %ax,0xf02d334e
        SETGATE(idt[T_ILLOP],   0, GD_KT, handleILLOP,   0)
f01035f7:	b8 40 3d 10 f0       	mov    $0xf0103d40,%eax
f01035fc:	66 a3 50 33 2d f0    	mov    %ax,0xf02d3350
f0103602:	66 c7 05 52 33 2d f0 	movw   $0x8,0xf02d3352
f0103609:	08 00 
f010360b:	c6 05 54 33 2d f0 00 	movb   $0x0,0xf02d3354
f0103612:	c6 05 55 33 2d f0 8e 	movb   $0x8e,0xf02d3355
f0103619:	c1 e8 10             	shr    $0x10,%eax
f010361c:	66 a3 56 33 2d f0    	mov    %ax,0xf02d3356
        SETGATE(idt[T_DEVICE],  0, GD_KT, handleDEVICE,  0)
f0103622:	b8 46 3d 10 f0       	mov    $0xf0103d46,%eax
f0103627:	66 a3 58 33 2d f0    	mov    %ax,0xf02d3358
f010362d:	66 c7 05 5a 33 2d f0 	movw   $0x8,0xf02d335a
f0103634:	08 00 
f0103636:	c6 05 5c 33 2d f0 00 	movb   $0x0,0xf02d335c
f010363d:	c6 05 5d 33 2d f0 8e 	movb   $0x8e,0xf02d335d
f0103644:	c1 e8 10             	shr    $0x10,%eax
f0103647:	66 a3 5e 33 2d f0    	mov    %ax,0xf02d335e
        SETGATE(idt[T_DBLFLT],  0, GD_KT, handleDBLFLT,  0)
f010364d:	b8 88 3d 10 f0       	mov    $0xf0103d88,%eax
f0103652:	66 a3 60 33 2d f0    	mov    %ax,0xf02d3360
f0103658:	66 c7 05 62 33 2d f0 	movw   $0x8,0xf02d3362
f010365f:	08 00 
f0103661:	c6 05 64 33 2d f0 00 	movb   $0x0,0xf02d3364
f0103668:	c6 05 65 33 2d f0 8e 	movb   $0x8e,0xf02d3365
f010366f:	c1 e8 10             	shr    $0x10,%eax
f0103672:	66 a3 66 33 2d f0    	mov    %ax,0xf02d3366
        SETGATE(idt[T_TSS],     0, GD_KT, handleTSS,     0)
f0103678:	b8 8c 3d 10 f0       	mov    $0xf0103d8c,%eax
f010367d:	66 a3 70 33 2d f0    	mov    %ax,0xf02d3370
f0103683:	66 c7 05 72 33 2d f0 	movw   $0x8,0xf02d3372
f010368a:	08 00 
f010368c:	c6 05 74 33 2d f0 00 	movb   $0x0,0xf02d3374
f0103693:	c6 05 75 33 2d f0 8e 	movb   $0x8e,0xf02d3375
f010369a:	c1 e8 10             	shr    $0x10,%eax
f010369d:	66 a3 76 33 2d f0    	mov    %ax,0xf02d3376
        SETGATE(idt[T_SEGNP],   0, GD_KT, handleSEGNP,   0)
f01036a3:	b8 90 3d 10 f0       	mov    $0xf0103d90,%eax
f01036a8:	66 a3 78 33 2d f0    	mov    %ax,0xf02d3378
f01036ae:	66 c7 05 7a 33 2d f0 	movw   $0x8,0xf02d337a
f01036b5:	08 00 
f01036b7:	c6 05 7c 33 2d f0 00 	movb   $0x0,0xf02d337c
f01036be:	c6 05 7d 33 2d f0 8e 	movb   $0x8e,0xf02d337d
f01036c5:	c1 e8 10             	shr    $0x10,%eax
f01036c8:	66 a3 7e 33 2d f0    	mov    %ax,0xf02d337e
        SETGATE(idt[T_STACK],   0, GD_KT, handleSTACK,   0)
f01036ce:	b8 94 3d 10 f0       	mov    $0xf0103d94,%eax
f01036d3:	66 a3 80 33 2d f0    	mov    %ax,0xf02d3380
f01036d9:	66 c7 05 82 33 2d f0 	movw   $0x8,0xf02d3382
f01036e0:	08 00 
f01036e2:	c6 05 84 33 2d f0 00 	movb   $0x0,0xf02d3384
f01036e9:	c6 05 85 33 2d f0 8e 	movb   $0x8e,0xf02d3385
f01036f0:	c1 e8 10             	shr    $0x10,%eax
f01036f3:	66 a3 86 33 2d f0    	mov    %ax,0xf02d3386
        SETGATE(idt[T_GPFLT],   0, GD_KT, handleGPFLT,   0)
f01036f9:	b8 98 3d 10 f0       	mov    $0xf0103d98,%eax
f01036fe:	66 a3 88 33 2d f0    	mov    %ax,0xf02d3388
f0103704:	66 c7 05 8a 33 2d f0 	movw   $0x8,0xf02d338a
f010370b:	08 00 
f010370d:	c6 05 8c 33 2d f0 00 	movb   $0x0,0xf02d338c
f0103714:	c6 05 8d 33 2d f0 8e 	movb   $0x8e,0xf02d338d
f010371b:	c1 e8 10             	shr    $0x10,%eax
f010371e:	66 a3 8e 33 2d f0    	mov    %ax,0xf02d338e
        SETGATE(idt[T_PGFLT],   0, GD_KT, handlePGFLT,   0)
f0103724:	b8 9c 3d 10 f0       	mov    $0xf0103d9c,%eax
f0103729:	66 a3 90 33 2d f0    	mov    %ax,0xf02d3390
f010372f:	66 c7 05 92 33 2d f0 	movw   $0x8,0xf02d3392
f0103736:	08 00 
f0103738:	c6 05 94 33 2d f0 00 	movb   $0x0,0xf02d3394
f010373f:	c6 05 95 33 2d f0 8e 	movb   $0x8e,0xf02d3395
f0103746:	c1 e8 10             	shr    $0x10,%eax
f0103749:	66 a3 96 33 2d f0    	mov    %ax,0xf02d3396
        SETGATE(idt[T_FPERR],   0, GD_KT, handleFPERR,   0)
f010374f:	b8 4c 3d 10 f0       	mov    $0xf0103d4c,%eax
f0103754:	66 a3 a0 33 2d f0    	mov    %ax,0xf02d33a0
f010375a:	66 c7 05 a2 33 2d f0 	movw   $0x8,0xf02d33a2
f0103761:	08 00 
f0103763:	c6 05 a4 33 2d f0 00 	movb   $0x0,0xf02d33a4
f010376a:	c6 05 a5 33 2d f0 8e 	movb   $0x8e,0xf02d33a5
f0103771:	c1 e8 10             	shr    $0x10,%eax
f0103774:	66 a3 a6 33 2d f0    	mov    %ax,0xf02d33a6
        SETGATE(idt[T_ALIGN],   0, GD_KT, handleALIGN,   0)
f010377a:	b8 a0 3d 10 f0       	mov    $0xf0103da0,%eax
f010377f:	66 a3 a8 33 2d f0    	mov    %ax,0xf02d33a8
f0103785:	66 c7 05 aa 33 2d f0 	movw   $0x8,0xf02d33aa
f010378c:	08 00 
f010378e:	c6 05 ac 33 2d f0 00 	movb   $0x0,0xf02d33ac
f0103795:	c6 05 ad 33 2d f0 8e 	movb   $0x8e,0xf02d33ad
f010379c:	c1 e8 10             	shr    $0x10,%eax
f010379f:	66 a3 ae 33 2d f0    	mov    %ax,0xf02d33ae
        SETGATE(idt[T_MCHK],    0, GD_KT, handleMCHK,    0)
f01037a5:	b8 52 3d 10 f0       	mov    $0xf0103d52,%eax
f01037aa:	66 a3 b0 33 2d f0    	mov    %ax,0xf02d33b0
f01037b0:	66 c7 05 b2 33 2d f0 	movw   $0x8,0xf02d33b2
f01037b7:	08 00 
f01037b9:	c6 05 b4 33 2d f0 00 	movb   $0x0,0xf02d33b4
f01037c0:	c6 05 b5 33 2d f0 8e 	movb   $0x8e,0xf02d33b5
f01037c7:	c1 e8 10             	shr    $0x10,%eax
f01037ca:	66 a3 b6 33 2d f0    	mov    %ax,0xf02d33b6
        SETGATE(idt[T_SIMDERR], 0, GD_KT, handleSIMDERR, 0)
f01037d0:	b8 58 3d 10 f0       	mov    $0xf0103d58,%eax
f01037d5:	66 a3 b8 33 2d f0    	mov    %ax,0xf02d33b8
f01037db:	66 c7 05 ba 33 2d f0 	movw   $0x8,0xf02d33ba
f01037e2:	08 00 
f01037e4:	c6 05 bc 33 2d f0 00 	movb   $0x0,0xf02d33bc
f01037eb:	c6 05 bd 33 2d f0 8e 	movb   $0x8e,0xf02d33bd
f01037f2:	c1 e8 10             	shr    $0x10,%eax
f01037f5:	66 a3 be 33 2d f0    	mov    %ax,0xf02d33be
        SETGATE(idt[T_SYSCALL], 0, GD_KT, handleSYSCALL, 3)
f01037fb:	b8 5e 3d 10 f0       	mov    $0xf0103d5e,%eax
f0103800:	66 a3 a0 34 2d f0    	mov    %ax,0xf02d34a0
f0103806:	66 c7 05 a2 34 2d f0 	movw   $0x8,0xf02d34a2
f010380d:	08 00 
f010380f:	c6 05 a4 34 2d f0 00 	movb   $0x0,0xf02d34a4
f0103816:	c6 05 a5 34 2d f0 ee 	movb   $0xee,0xf02d34a5
f010381d:	c1 e8 10             	shr    $0x10,%eax
f0103820:	66 a3 a6 34 2d f0    	mov    %ax,0xf02d34a6
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts.ts_esp0 = KSTACKTOP;
f0103826:	c7 05 24 3b 2d f0 00 	movl   $0xefc00000,0xf02d3b24
f010382d:	00 c0 ef 
	ts.ts_ss0 = GD_KD;
f0103830:	66 c7 05 28 3b 2d f0 	movw   $0x10,0xf02d3b28
f0103837:	10 00 
	// Initialize the TSS field of the gdt.
	gdt[GD_TSS >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
f0103839:	66 c7 05 48 f3 11 f0 	movw   $0x68,0xf011f348
f0103840:	68 00 
f0103842:	b8 20 3b 2d f0       	mov    $0xf02d3b20,%eax
f0103847:	66 a3 4a f3 11 f0    	mov    %ax,0xf011f34a
f010384d:	89 c2                	mov    %eax,%edx
f010384f:	c1 ea 10             	shr    $0x10,%edx
f0103852:	88 15 4c f3 11 f0    	mov    %dl,0xf011f34c
f0103858:	c6 05 4e f3 11 f0 40 	movb   $0x40,0xf011f34e
f010385f:	c1 e8 18             	shr    $0x18,%eax
f0103862:	a2 4f f3 11 f0       	mov    %al,0xf011f34f
					sizeof(struct Taskstate), 0);
	gdt[GD_TSS >> 3].sd_s = 0;
f0103867:	c6 05 4d f3 11 f0 89 	movb   $0x89,0xf011f34d
}

static __inline void
ltr(uint16_t sel)
{
	__asm __volatile("ltr %0" : : "r" (sel));
f010386e:	b8 28 00 00 00       	mov    $0x28,%eax
f0103873:	0f 00 d8             	ltr    %ax

	// Load the TSS
	ltr(GD_TSS);

	// Load the IDT
	asm volatile("lidt idt_pd");
f0103876:	0f 01 1d 5c f3 11 f0 	lidtl  0xf011f35c
}
f010387d:	5d                   	pop    %ebp
f010387e:	c3                   	ret    

f010387f <print_regs>:
	cprintf("  ss   0x----%04x\n", tf->tf_ss);
}

void
print_regs(struct PushRegs *regs)
{
f010387f:	55                   	push   %ebp
f0103880:	89 e5                	mov    %esp,%ebp
f0103882:	53                   	push   %ebx
f0103883:	83 ec 14             	sub    $0x14,%esp
f0103886:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103889:	8b 03                	mov    (%ebx),%eax
f010388b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010388f:	c7 04 24 e2 6f 10 f0 	movl   $0xf0106fe2,(%esp)
f0103896:	e8 24 fb ff ff       	call   f01033bf <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f010389b:	8b 43 04             	mov    0x4(%ebx),%eax
f010389e:	89 44 24 04          	mov    %eax,0x4(%esp)
f01038a2:	c7 04 24 f1 6f 10 f0 	movl   $0xf0106ff1,(%esp)
f01038a9:	e8 11 fb ff ff       	call   f01033bf <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f01038ae:	8b 43 08             	mov    0x8(%ebx),%eax
f01038b1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01038b5:	c7 04 24 00 70 10 f0 	movl   $0xf0107000,(%esp)
f01038bc:	e8 fe fa ff ff       	call   f01033bf <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f01038c1:	8b 43 0c             	mov    0xc(%ebx),%eax
f01038c4:	89 44 24 04          	mov    %eax,0x4(%esp)
f01038c8:	c7 04 24 0f 70 10 f0 	movl   $0xf010700f,(%esp)
f01038cf:	e8 eb fa ff ff       	call   f01033bf <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f01038d4:	8b 43 10             	mov    0x10(%ebx),%eax
f01038d7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01038db:	c7 04 24 1e 70 10 f0 	movl   $0xf010701e,(%esp)
f01038e2:	e8 d8 fa ff ff       	call   f01033bf <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f01038e7:	8b 43 14             	mov    0x14(%ebx),%eax
f01038ea:	89 44 24 04          	mov    %eax,0x4(%esp)
f01038ee:	c7 04 24 2d 70 10 f0 	movl   $0xf010702d,(%esp)
f01038f5:	e8 c5 fa ff ff       	call   f01033bf <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f01038fa:	8b 43 18             	mov    0x18(%ebx),%eax
f01038fd:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103901:	c7 04 24 3c 70 10 f0 	movl   $0xf010703c,(%esp)
f0103908:	e8 b2 fa ff ff       	call   f01033bf <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f010390d:	8b 43 1c             	mov    0x1c(%ebx),%eax
f0103910:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103914:	c7 04 24 4b 70 10 f0 	movl   $0xf010704b,(%esp)
f010391b:	e8 9f fa ff ff       	call   f01033bf <cprintf>
}
f0103920:	83 c4 14             	add    $0x14,%esp
f0103923:	5b                   	pop    %ebx
f0103924:	5d                   	pop    %ebp
f0103925:	c3                   	ret    

f0103926 <print_trapframe>:
	asm volatile("lidt idt_pd");
}

void
print_trapframe(struct Trapframe *tf)
{
f0103926:	55                   	push   %ebp
f0103927:	89 e5                	mov    %esp,%ebp
f0103929:	53                   	push   %ebx
f010392a:	83 ec 14             	sub    $0x14,%esp
f010392d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p\n", tf);
f0103930:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0103934:	c7 04 24 5a 70 10 f0 	movl   $0xf010705a,(%esp)
f010393b:	e8 7f fa ff ff       	call   f01033bf <cprintf>
	print_regs(&tf->tf_regs);
f0103940:	89 1c 24             	mov    %ebx,(%esp)
f0103943:	e8 37 ff ff ff       	call   f010387f <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0103948:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f010394c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103950:	c7 04 24 6c 70 10 f0 	movl   $0xf010706c,(%esp)
f0103957:	e8 63 fa ff ff       	call   f01033bf <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f010395c:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0103960:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103964:	c7 04 24 7f 70 10 f0 	movl   $0xf010707f,(%esp)
f010396b:	e8 4f fa ff ff       	call   f01033bf <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0103970:	8b 43 28             	mov    0x28(%ebx),%eax
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
f0103973:	83 f8 13             	cmp    $0x13,%eax
f0103976:	77 09                	ja     f0103981 <print_trapframe+0x5b>
		return excnames[trapno];
f0103978:	8b 14 85 20 73 10 f0 	mov    -0xfef8ce0(,%eax,4),%edx
f010397f:	eb 1c                	jmp    f010399d <print_trapframe+0x77>
	if (trapno == T_SYSCALL)
f0103981:	ba 92 70 10 f0       	mov    $0xf0107092,%edx
f0103986:	83 f8 30             	cmp    $0x30,%eax
f0103989:	74 12                	je     f010399d <print_trapframe+0x77>
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f010398b:	8d 48 e0             	lea    -0x20(%eax),%ecx
f010398e:	ba ad 70 10 f0       	mov    $0xf01070ad,%edx
f0103993:	83 f9 0f             	cmp    $0xf,%ecx
f0103996:	76 05                	jbe    f010399d <print_trapframe+0x77>
f0103998:	ba 9e 70 10 f0       	mov    $0xf010709e,%edx
{
	cprintf("TRAP frame at %p\n", tf);
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f010399d:	89 54 24 08          	mov    %edx,0x8(%esp)
f01039a1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01039a5:	c7 04 24 c0 70 10 f0 	movl   $0xf01070c0,(%esp)
f01039ac:	e8 0e fa ff ff       	call   f01033bf <cprintf>
	cprintf("  err  0x%08x\n", tf->tf_err);
f01039b1:	8b 43 2c             	mov    0x2c(%ebx),%eax
f01039b4:	89 44 24 04          	mov    %eax,0x4(%esp)
f01039b8:	c7 04 24 d2 70 10 f0 	movl   $0xf01070d2,(%esp)
f01039bf:	e8 fb f9 ff ff       	call   f01033bf <cprintf>
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f01039c4:	8b 43 30             	mov    0x30(%ebx),%eax
f01039c7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01039cb:	c7 04 24 e1 70 10 f0 	movl   $0xf01070e1,(%esp)
f01039d2:	e8 e8 f9 ff ff       	call   f01033bf <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f01039d7:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f01039db:	89 44 24 04          	mov    %eax,0x4(%esp)
f01039df:	c7 04 24 f0 70 10 f0 	movl   $0xf01070f0,(%esp)
f01039e6:	e8 d4 f9 ff ff       	call   f01033bf <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f01039eb:	8b 43 38             	mov    0x38(%ebx),%eax
f01039ee:	89 44 24 04          	mov    %eax,0x4(%esp)
f01039f2:	c7 04 24 03 71 10 f0 	movl   $0xf0107103,(%esp)
f01039f9:	e8 c1 f9 ff ff       	call   f01033bf <cprintf>
	cprintf("  esp  0x%08x\n", tf->tf_esp);
f01039fe:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0103a01:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103a05:	c7 04 24 12 71 10 f0 	movl   $0xf0107112,(%esp)
f0103a0c:	e8 ae f9 ff ff       	call   f01033bf <cprintf>
	cprintf("  ss   0x----%04x\n", tf->tf_ss);
f0103a11:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0103a15:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103a19:	c7 04 24 21 71 10 f0 	movl   $0xf0107121,(%esp)
f0103a20:	e8 9a f9 ff ff       	call   f01033bf <cprintf>
}
f0103a25:	83 c4 14             	add    $0x14,%esp
f0103a28:	5b                   	pop    %ebx
f0103a29:	5d                   	pop    %ebp
f0103a2a:	c3                   	ret    

f0103a2b <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0103a2b:	55                   	push   %ebp
f0103a2c:	89 e5                	mov    %esp,%ebp
f0103a2e:	83 ec 38             	sub    $0x38,%esp
f0103a31:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0103a34:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0103a37:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0103a3a:	8b 5d 08             	mov    0x8(%ebp),%ebx

static __inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
f0103a3d:	0f 20 d6             	mov    %cr2,%esi
              
            //fault_va

        /* generally, the page fault in the kernel does not happen,,,,,if some exception happens the processor automatically pushes the flags,cs,eip on the stack(but thats not a page fault, its simply the nested backtrace),,,,,so, this function wont be called and there will be no exception or interrupt,,,as no pagefault only some runtime exception in the kernel which wud be handled by some other trap........If the pagefault happens in kernel,,,then the JOS doesnot handle that and panics,,,,
          */ 
                uint16_t CPL = tf->tf_cs & 0x0003;
f0103a40:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0103a44:	75 1c                	jne    f0103a62 <page_fault_handler+0x37>
                 if(CPL==0)
                    panic("kernel mode fault");
f0103a46:	c7 44 24 08 34 71 10 	movl   $0xf0107134,0x8(%esp)
f0103a4d:	f0 
f0103a4e:	c7 44 24 04 7c 01 00 	movl   $0x17c,0x4(%esp)
f0103a55:	00 
f0103a56:	c7 04 24 46 71 10 f0 	movl   $0xf0107146,(%esp)
f0103a5d:	e8 23 c6 ff ff       	call   f0100085 <_panic>

	// LAB 4: Your code here.

//if(sys_page_alloc(curenv->env_id,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
                          
    if(curenv->env_pgfault_upcall!=NULL)
f0103a62:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0103a67:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f0103a6b:	0f 84 ce 00 00 00    	je     f0103b3f <page_fault_handler+0x114>
       struct UTrapframe *utf;
       //uint32_t espValue =*(curenv->env_tf.tf_esp); 

//      user_mem_assert(curenv, (void *)(UXSTACKTOP-4), 4, 0);

           if(!(tf->tf_esp > UXSTACKTOP-PGSIZE && tf->tf_esp < UXSTACKTOP))
f0103a71:	8b 53 3c             	mov    0x3c(%ebx),%edx
f0103a74:	8d 8a ff 0f 40 11    	lea    0x11400fff(%edx),%ecx
f0103a7a:	c7 45 e4 cc ff bf ee 	movl   $0xeebfffcc,-0x1c(%ebp)
f0103a81:	81 f9 fe 0f 00 00    	cmp    $0xffe,%ecx
f0103a87:	77 06                	ja     f0103a8f <page_fault_handler+0x64>
                          //   cprintf("\nesp in IF>>>> %x\n",tf->tf_esp);        
                        // cprintf("\nHere in if esp %x   TOP %x  UTF  %x\n",(((uint32_t *)UXSTACKTOP) - (sizeof(struct UTrapframe)/4)),UXSTACKTOP,utf);
                        }
                    else
                        {
                          utf=(struct UTrapframe *)(((uint32_t *)tf->tf_esp) - ((sizeof(struct UTrapframe)/4)+1));
f0103a89:	83 ea 38             	sub    $0x38,%edx
f0103a8c:	89 55 e4             	mov    %edx,-0x1c(%ebp)
                }
*/
           // user_mem_assert(curenv,(void *)UXSTACKTOP-PGSIZE,400,PTE_P|PTE_U|PTE_W);
      //cprintf("\nva22222 = %x    faultva=%x",utf,fault_va);
    // cprintf("Before assert in kern pgfault trap>>>>>>>>>\n");  
     user_mem_assert(curenv,(void *)utf,sizeof(utf),0);  
f0103a8f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0103a96:	00 
f0103a97:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f0103a9e:	00 
f0103a9f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0103aa2:	89 54 24 04          	mov    %edx,0x4(%esp)
f0103aa6:	89 04 24             	mov    %eax,(%esp)
f0103aa9:	e8 96 d3 ff ff       	call   f0100e44 <user_mem_assert>
        utf->utf_fault_va =fault_va;
f0103aae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103ab1:	89 30                	mov    %esi,(%eax)
        utf->utf_err = tf->tf_err; 
f0103ab3:	8b 43 2c             	mov    0x2c(%ebx),%eax
f0103ab6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0103ab9:	89 42 04             	mov    %eax,0x4(%edx)
        /* trap-time return state */
        utf->utf_regs = tf->tf_regs;
f0103abc:	89 d7                	mov    %edx,%edi
f0103abe:	83 c7 08             	add    $0x8,%edi
f0103ac1:	89 de                	mov    %ebx,%esi
f0103ac3:	b8 20 00 00 00       	mov    $0x20,%eax
f0103ac8:	f7 c7 01 00 00 00    	test   $0x1,%edi
f0103ace:	74 04                	je     f0103ad4 <page_fault_handler+0xa9>
f0103ad0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
f0103ad1:	83 e8 01             	sub    $0x1,%eax
f0103ad4:	f7 c7 02 00 00 00    	test   $0x2,%edi
f0103ada:	74 05                	je     f0103ae1 <page_fault_handler+0xb6>
f0103adc:	66 a5                	movsw  %ds:(%esi),%es:(%edi)
f0103ade:	83 e8 02             	sub    $0x2,%eax
f0103ae1:	89 c1                	mov    %eax,%ecx
f0103ae3:	c1 e9 02             	shr    $0x2,%ecx
f0103ae6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0103ae8:	ba 00 00 00 00       	mov    $0x0,%edx
f0103aed:	a8 02                	test   $0x2,%al
f0103aef:	74 0b                	je     f0103afc <page_fault_handler+0xd1>
f0103af1:	0f b7 0c 16          	movzwl (%esi,%edx,1),%ecx
f0103af5:	66 89 0c 17          	mov    %cx,(%edi,%edx,1)
f0103af9:	83 c2 02             	add    $0x2,%edx
f0103afc:	a8 01                	test   $0x1,%al
f0103afe:	74 07                	je     f0103b07 <page_fault_handler+0xdc>
f0103b00:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
f0103b04:	88 04 17             	mov    %al,(%edi,%edx,1)
        utf->utf_eip = tf->tf_eip;
f0103b07:	8b 43 30             	mov    0x30(%ebx),%eax
f0103b0a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0103b0d:	89 42 28             	mov    %eax,0x28(%edx)
        utf->utf_eflags = tf->tf_eflags;
f0103b10:	8b 43 38             	mov    0x38(%ebx),%eax
f0103b13:	89 42 2c             	mov    %eax,0x2c(%edx)
        /* the trap-time stack to return to */
        utf->utf_esp = tf->tf_esp;
f0103b16:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0103b19:	89 42 30             	mov    %eax,0x30(%edx)
//        cprintf("\nabove curenv");
        curenv->env_tf.tf_eip =(uintptr_t)curenv->env_pgfault_upcall;
f0103b1c:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0103b21:	8b 50 64             	mov    0x64(%eax),%edx
f0103b24:	89 50 30             	mov    %edx,0x30(%eax)
        curenv->env_tf.tf_esp =(uintptr_t)utf;
f0103b27:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0103b2c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0103b2f:	89 50 3c             	mov    %edx,0x3c(%eax)
  //      cprintf("\n below allocation of trap frame");           
        env_run(curenv);
f0103b32:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0103b37:	89 04 24             	mov    %eax,(%esp)
f0103b3a:	e8 cc f1 ff ff       	call   f0102d0b <env_run>
                  
                        }

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f0103b3f:	8b 53 30             	mov    0x30(%ebx),%edx
f0103b42:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0103b46:	89 74 24 08          	mov    %esi,0x8(%esp)
f0103b4a:	8b 40 4c             	mov    0x4c(%eax),%eax
f0103b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103b51:	c7 04 24 ec 72 10 f0 	movl   $0xf01072ec,(%esp)
f0103b58:	e8 62 f8 ff ff       	call   f01033bf <cprintf>
		curenv->env_id, fault_va, tf->tf_eip);
	print_trapframe(tf);
f0103b5d:	89 1c 24             	mov    %ebx,(%esp)
f0103b60:	e8 c1 fd ff ff       	call   f0103926 <print_trapframe>
	env_destroy(curenv);
f0103b65:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0103b6a:	89 04 24             	mov    %eax,(%esp)
f0103b6d:	e8 6c f3 ff ff       	call   f0102ede <env_destroy>

}
f0103b72:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0103b75:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0103b78:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0103b7b:	89 ec                	mov    %ebp,%esp
f0103b7d:	5d                   	pop    %ebp
f0103b7e:	c3                   	ret    

f0103b7f <trap>:
	}
}

void
trap(struct Trapframe *tf)
{
f0103b7f:	55                   	push   %ebp
f0103b80:	89 e5                	mov    %esp,%ebp
f0103b82:	57                   	push   %edi
f0103b83:	56                   	push   %esi
f0103b84:	83 ec 20             	sub    $0x20,%esp
f0103b87:	8b 75 08             	mov    0x8(%ebp),%esi
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");
f0103b8a:	fc                   	cld    

static __inline uint32_t
read_eflags(void)
{
        uint32_t eflags;
        __asm __volatile("pushfl; popl %0" : "=r" (eflags));
f0103b8b:	9c                   	pushf  
f0103b8c:	58                   	pop    %eax

	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));
f0103b8d:	f6 c4 02             	test   $0x2,%ah
f0103b90:	74 24                	je     f0103bb6 <trap+0x37>
f0103b92:	c7 44 24 0c 52 71 10 	movl   $0xf0107152,0xc(%esp)
f0103b99:	f0 
f0103b9a:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0103ba1:	f0 
f0103ba2:	c7 44 24 04 43 01 00 	movl   $0x143,0x4(%esp)
f0103ba9:	00 
f0103baa:	c7 04 24 46 71 10 f0 	movl   $0xf0107146,(%esp)
f0103bb1:	e8 cf c4 ff ff       	call   f0100085 <_panic>

       //print_trapframe(tf);


// only here we map the trapframe of a process or environment from the kernel stack, so that read below....
	if ((tf->tf_cs & 3) == 3) {
f0103bb6:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0103bba:	83 e0 03             	and    $0x3,%eax
f0103bbd:	83 f8 03             	cmp    $0x3,%eax
f0103bc0:	75 3c                	jne    f0103bfe <trap+0x7f>
		// Trapped from user mode.
		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		assert(curenv);
f0103bc2:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0103bc7:	85 c0                	test   %eax,%eax
f0103bc9:	75 24                	jne    f0103bef <trap+0x70>
f0103bcb:	c7 44 24 0c 6b 71 10 	movl   $0xf010716b,0xc(%esp)
f0103bd2:	f0 
f0103bd3:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0103bda:	f0 
f0103bdb:	c7 44 24 04 50 01 00 	movl   $0x150,0x4(%esp)
f0103be2:	00 
f0103be3:	c7 04 24 46 71 10 f0 	movl   $0xf0107146,(%esp)
f0103bea:	e8 96 c4 ff ff       	call   f0100085 <_panic>
		curenv->env_tf = *tf;
f0103bef:	b9 11 00 00 00       	mov    $0x11,%ecx
f0103bf4:	89 c7                	mov    %eax,%edi
f0103bf6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
f0103bf8:	8b 35 04 33 2d f0    	mov    0xf02d3304,%esi
	// LAB 3: Your code here.

	
	// Handle clock interrupts.
	// LAB 4: Your code here.
        if(tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER)
f0103bfe:	8b 46 28             	mov    0x28(%esi),%eax
f0103c01:	83 f8 20             	cmp    $0x20,%eax
f0103c04:	75 0a                	jne    f0103c10 <trap+0x91>
             {
                time_tick();
f0103c06:	e8 e3 22 00 00       	call   f0105eee <time_tick>
                //if(((time_msec())%100) == 0)
                  //update_page_access_reference();
                sched_yield();                             
f0103c0b:	e8 ac 01 00 00       	call   f0103dbc <sched_yield>
	// LAB 6: Your code here.

	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0103c10:	83 f8 27             	cmp    $0x27,%eax
f0103c13:	75 19                	jne    f0103c2e <trap+0xaf>
		cprintf("Spurious interrupt on irq 7\n");
f0103c15:	c7 04 24 72 71 10 f0 	movl   $0xf0107172,(%esp)
f0103c1c:	e8 9e f7 ff ff       	call   f01033bf <cprintf>
		print_trapframe(tf);
f0103c21:	89 34 24             	mov    %esi,(%esp)
f0103c24:	e8 fd fc ff ff       	call   f0103926 <print_trapframe>
f0103c29:	e9 cd 00 00 00       	jmp    f0103cfb <trap+0x17c>
		return;
	}

          if(tf->tf_trapno==T_PGFLT)
f0103c2e:	83 f8 0e             	cmp    $0xe,%eax
f0103c31:	75 12                	jne    f0103c45 <trap+0xc6>
              { page_fault_handler(tf);	
f0103c33:	89 34 24             	mov    %esi,(%esp)
f0103c36:	66 90                	xchg   %ax,%ax
f0103c38:	e8 ee fd ff ff       	call   f0103a2b <page_fault_handler>
f0103c3d:	8d 76 00             	lea    0x0(%esi),%esi
f0103c40:	e9 b6 00 00 00       	jmp    f0103cfb <trap+0x17c>
               return;
              } 

             if(tf->tf_trapno==T_BRKPT)
f0103c45:	83 f8 03             	cmp    $0x3,%eax
f0103c48:	75 10                	jne    f0103c5a <trap+0xdb>
                    {
                        monitor(tf);
f0103c4a:	89 34 24             	mov    %esi,(%esp)
f0103c4d:	8d 76 00             	lea    0x0(%esi),%esi
f0103c50:	e8 8b cb ff ff       	call   f01007e0 <monitor>
f0103c55:	e9 a1 00 00 00       	jmp    f0103cfb <trap+0x17c>
                return;
      //asm volatile("int3");

                    }

             if(tf->tf_trapno==T_SYSCALL)
f0103c5a:	83 f8 30             	cmp    $0x30,%eax
f0103c5d:	8d 76 00             	lea    0x0(%esi),%esi
f0103c60:	75 32                	jne    f0103c94 <trap+0x115>
                     //cprintf("Size of %d",sizeof(struct UTrapframe));
//                      cprintf("\nvalue of cs%x\n",tf->tf_cs);
                     //for(;i<(tf->tf_regs).reg_ecx;i++)
                       // cprintf("\nValues eax%d  edx%d  ecx%x\n ",(tf->tf_regs).reg_eax,(tf->tf_regs).reg_edx,((char *)(tf->tf_regs).reg_ecx));
                       // cprintf("%c",*(((char *)((tf->tf_regs).reg_edx))+i));
      uint32_t ret = syscall((tf->tf_regs).reg_eax,(tf->tf_regs).reg_edx,(tf->tf_regs).reg_ecx,(tf->tf_regs).reg_ebx,(tf->tf_regs).reg_edi,(tf->tf_regs).reg_esi);
f0103c62:	8b 46 04             	mov    0x4(%esi),%eax
f0103c65:	89 44 24 14          	mov    %eax,0x14(%esp)
f0103c69:	8b 06                	mov    (%esi),%eax
f0103c6b:	89 44 24 10          	mov    %eax,0x10(%esp)
f0103c6f:	8b 46 10             	mov    0x10(%esi),%eax
f0103c72:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0103c76:	8b 46 18             	mov    0x18(%esi),%eax
f0103c79:	89 44 24 08          	mov    %eax,0x8(%esp)
f0103c7d:	8b 46 14             	mov    0x14(%esi),%eax
f0103c80:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103c84:	8b 46 1c             	mov    0x1c(%esi),%eax
f0103c87:	89 04 24             	mov    %eax,(%esp)
f0103c8a:	e8 e1 01 00 00       	call   f0103e70 <syscall>
                      (tf->tf_regs).reg_eax=ret;
f0103c8f:	89 46 1c             	mov    %eax,0x1c(%esi)
f0103c92:	eb 67                	jmp    f0103cfb <trap+0x17c>


	// Handle keyboard and serial interrupts.
	// LAB 7: Your code here.

	if(tf->tf_trapno == IRQ_KBD+IRQ_OFFSET)
f0103c94:	83 f8 21             	cmp    $0x21,%eax
f0103c97:	75 0e                	jne    f0103ca7 <trap+0x128>
	{
		kbd_intr();
f0103c99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0103ca0:	e8 5d c5 ff ff       	call   f0100202 <kbd_intr>
f0103ca5:	eb 54                	jmp    f0103cfb <trap+0x17c>
		return;
	}


	if(tf->tf_trapno == IRQ_SERIAL+IRQ_OFFSET)
f0103ca7:	83 f8 24             	cmp    $0x24,%eax
f0103caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0103cb0:	75 10                	jne    f0103cc2 <trap+0x143>
	{
		serial_intr();
f0103cb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0103cb8:	e8 57 c5 ff ff       	call   f0100214 <serial_intr>
f0103cbd:	8d 76 00             	lea    0x0(%esi),%esi
f0103cc0:	eb 39                	jmp    f0103cfb <trap+0x17c>
		return;
	}

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
f0103cc2:	89 34 24             	mov    %esi,(%esp)
f0103cc5:	e8 5c fc ff ff       	call   f0103926 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f0103cca:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0103ccf:	90                   	nop
f0103cd0:	75 1c                	jne    f0103cee <trap+0x16f>
		panic("unhandled trap in kernel");
f0103cd2:	c7 44 24 08 8f 71 10 	movl   $0xf010718f,0x8(%esp)
f0103cd9:	f0 
f0103cda:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
f0103ce1:	00 
f0103ce2:	c7 04 24 46 71 10 f0 	movl   $0xf0107146,(%esp)
f0103ce9:	e8 97 c3 ff ff       	call   f0100085 <_panic>
	else {
		env_destroy(curenv);
f0103cee:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0103cf3:	89 04 24             	mov    %eax,(%esp)
f0103cf6:	e8 e3 f1 ff ff       	call   f0102ede <env_destroy>


	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNABLE)
f0103cfb:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0103d00:	85 c0                	test   %eax,%eax
f0103d02:	74 0e                	je     f0103d12 <trap+0x193>
f0103d04:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0103d08:	75 08                	jne    f0103d12 <trap+0x193>
		env_run(curenv);
f0103d0a:	89 04 24             	mov    %eax,(%esp)
f0103d0d:	e8 f9 ef ff ff       	call   f0102d0b <env_run>
	else
		sched_yield();
f0103d12:	e8 a5 00 00 00       	call   f0103dbc <sched_yield>
	...

f0103d18 <handleDIVIDE>:
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text
TRAPHANDLER_NOEC(handleDIVIDE, T_DIVIDE)
f0103d18:	6a 00                	push   $0x0
f0103d1a:	6a 00                	push   $0x0
f0103d1c:	e9 83 00 00 00       	jmp    f0103da4 <_alltraps>
f0103d21:	90                   	nop

f0103d22 <handleDEBUG>:
TRAPHANDLER_NOEC(handleDEBUG, T_DEBUG)
f0103d22:	6a 00                	push   $0x0
f0103d24:	6a 01                	push   $0x1
f0103d26:	eb 7c                	jmp    f0103da4 <_alltraps>

f0103d28 <handleNMI>:
TRAPHANDLER_NOEC(handleNMI, T_NMI)
f0103d28:	6a 00                	push   $0x0
f0103d2a:	6a 02                	push   $0x2
f0103d2c:	eb 76                	jmp    f0103da4 <_alltraps>

f0103d2e <handleBRKPT>:
TRAPHANDLER_NOEC(handleBRKPT, T_BRKPT)
f0103d2e:	6a 00                	push   $0x0
f0103d30:	6a 03                	push   $0x3
f0103d32:	eb 70                	jmp    f0103da4 <_alltraps>

f0103d34 <handleOFLOW>:
TRAPHANDLER_NOEC(handleOFLOW, T_OFLOW)
f0103d34:	6a 00                	push   $0x0
f0103d36:	6a 04                	push   $0x4
f0103d38:	eb 6a                	jmp    f0103da4 <_alltraps>

f0103d3a <handleBOUND>:
TRAPHANDLER_NOEC(handleBOUND, T_BOUND)
f0103d3a:	6a 00                	push   $0x0
f0103d3c:	6a 05                	push   $0x5
f0103d3e:	eb 64                	jmp    f0103da4 <_alltraps>

f0103d40 <handleILLOP>:
TRAPHANDLER_NOEC(handleILLOP, T_ILLOP)
f0103d40:	6a 00                	push   $0x0
f0103d42:	6a 06                	push   $0x6
f0103d44:	eb 5e                	jmp    f0103da4 <_alltraps>

f0103d46 <handleDEVICE>:
TRAPHANDLER_NOEC(handleDEVICE, T_DEVICE)
f0103d46:	6a 00                	push   $0x0
f0103d48:	6a 07                	push   $0x7
f0103d4a:	eb 58                	jmp    f0103da4 <_alltraps>

f0103d4c <handleFPERR>:
TRAPHANDLER_NOEC(handleFPERR, T_FPERR)
f0103d4c:	6a 00                	push   $0x0
f0103d4e:	6a 10                	push   $0x10
f0103d50:	eb 52                	jmp    f0103da4 <_alltraps>

f0103d52 <handleMCHK>:
TRAPHANDLER_NOEC(handleMCHK, T_MCHK)
f0103d52:	6a 00                	push   $0x0
f0103d54:	6a 12                	push   $0x12
f0103d56:	eb 4c                	jmp    f0103da4 <_alltraps>

f0103d58 <handleSIMDERR>:
TRAPHANDLER_NOEC(handleSIMDERR, T_SIMDERR)
f0103d58:	6a 00                	push   $0x0
f0103d5a:	6a 13                	push   $0x13
f0103d5c:	eb 46                	jmp    f0103da4 <_alltraps>

f0103d5e <handleSYSCALL>:
TRAPHANDLER_NOEC(handleSYSCALL, T_SYSCALL)
f0103d5e:	6a 00                	push   $0x0
f0103d60:	6a 30                	push   $0x30
f0103d62:	eb 40                	jmp    f0103da4 <_alltraps>

f0103d64 <handleTIMER>:
TRAPHANDLER_NOEC(handleTIMER,IRQ_TIMER+IRQ_OFFSET)
f0103d64:	6a 00                	push   $0x0
f0103d66:	6a 20                	push   $0x20
f0103d68:	eb 3a                	jmp    f0103da4 <_alltraps>

f0103d6a <handleKBD>:
TRAPHANDLER_NOEC(handleKBD,IRQ_KBD+IRQ_OFFSET)
f0103d6a:	6a 00                	push   $0x0
f0103d6c:	6a 21                	push   $0x21
f0103d6e:	eb 34                	jmp    f0103da4 <_alltraps>

f0103d70 <handleSERIAL>:
TRAPHANDLER_NOEC(handleSERIAL,IRQ_SERIAL+IRQ_OFFSET)
f0103d70:	6a 00                	push   $0x0
f0103d72:	6a 24                	push   $0x24
f0103d74:	eb 2e                	jmp    f0103da4 <_alltraps>

f0103d76 <handleSPURIOUS>:
TRAPHANDLER_NOEC(handleSPURIOUS,IRQ_SPURIOUS+IRQ_OFFSET)
f0103d76:	6a 00                	push   $0x0
f0103d78:	6a 27                	push   $0x27
f0103d7a:	eb 28                	jmp    f0103da4 <_alltraps>

f0103d7c <handleIDE>:
TRAPHANDLER_NOEC(handleIDE,IRQ_IDE+IRQ_OFFSET)
f0103d7c:	6a 00                	push   $0x0
f0103d7e:	6a 2e                	push   $0x2e
f0103d80:	eb 22                	jmp    f0103da4 <_alltraps>

f0103d82 <handleERROR>:
TRAPHANDLER_NOEC(handleERROR,IRQ_ERROR+IRQ_OFFSET)
f0103d82:	6a 00                	push   $0x0
f0103d84:	6a 33                	push   $0x33
f0103d86:	eb 1c                	jmp    f0103da4 <_alltraps>

f0103d88 <handleDBLFLT>:
TRAPHANDLER(handleDBLFLT, T_DBLFLT)
f0103d88:	6a 08                	push   $0x8
f0103d8a:	eb 18                	jmp    f0103da4 <_alltraps>

f0103d8c <handleTSS>:
TRAPHANDLER(handleTSS, T_TSS)
f0103d8c:	6a 0a                	push   $0xa
f0103d8e:	eb 14                	jmp    f0103da4 <_alltraps>

f0103d90 <handleSEGNP>:
TRAPHANDLER(handleSEGNP, T_SEGNP)
f0103d90:	6a 0b                	push   $0xb
f0103d92:	eb 10                	jmp    f0103da4 <_alltraps>

f0103d94 <handleSTACK>:
TRAPHANDLER(handleSTACK, T_STACK)
f0103d94:	6a 0c                	push   $0xc
f0103d96:	eb 0c                	jmp    f0103da4 <_alltraps>

f0103d98 <handleGPFLT>:
TRAPHANDLER(handleGPFLT, T_GPFLT)
f0103d98:	6a 0d                	push   $0xd
f0103d9a:	eb 08                	jmp    f0103da4 <_alltraps>

f0103d9c <handlePGFLT>:
TRAPHANDLER(handlePGFLT, T_PGFLT)
f0103d9c:	6a 0e                	push   $0xe
f0103d9e:	eb 04                	jmp    f0103da4 <_alltraps>

f0103da0 <handleALIGN>:
TRAPHANDLER(handleALIGN, T_ALIGN)
f0103da0:	6a 11                	push   $0x11
f0103da2:	eb 00                	jmp    f0103da4 <_alltraps>

f0103da4 <_alltraps>:

/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
pushl %ds
f0103da4:	1e                   	push   %ds
pushl %es
f0103da5:	06                   	push   %es
pushal
f0103da6:	60                   	pusha  
movw $GD_KD,%ax
f0103da7:	66 b8 10 00          	mov    $0x10,%ax
movw %ax,%ds
f0103dab:	8e d8                	mov    %eax,%ds
movw %ax,%es
f0103dad:	8e c0                	mov    %eax,%es
pushl %esp
f0103daf:	54                   	push   %esp
call trap
f0103db0:	e8 ca fd ff ff       	call   f0103b7f <trap>
popal
f0103db5:	61                   	popa   
popl %es
f0103db6:	07                   	pop    %es
popl %ds
f0103db7:	1f                   	pop    %ds
iret
f0103db8:	cf                   	iret   
f0103db9:	00 00                	add    %al,(%eax)
	...

f0103dbc <sched_yield>:


// Choose a user environment to run and run it.
void
sched_yield(void)
{
f0103dbc:	55                   	push   %ebp
f0103dbd:	89 e5                	mov    %esp,%ebp
f0103dbf:	56                   	push   %esi
f0103dc0:	53                   	push   %ebx
f0103dc1:	83 ec 20             	sub    $0x20,%esp
	// unless NOTHING else is runnable.

        // LAB 4: Your code here
uint32_t index=0;
uint32_t i=0;
if(curenv!=NULL)
f0103dc4:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0103dc9:	85 c0                	test   %eax,%eax
f0103dcb:	75 09                	jne    f0103dd6 <sched_yield+0x1a>
f0103dcd:	b0 01                	mov    $0x1,%al
f0103dcf:	b9 00 00 00 00       	mov    $0x0,%ecx
f0103dd4:	eb 1b                	jmp    f0103df1 <sched_yield+0x35>
{index=curenv-envs;
f0103dd6:	2b 05 00 33 2d f0    	sub    0xf02d3300,%eax
f0103ddc:	89 c1                	mov    %eax,%ecx
f0103dde:	c1 f9 02             	sar    $0x2,%ecx
f0103de1:	69 c9 df 7b ef bd    	imul   $0xbdef7bdf,%ecx,%ecx
i=index+1;
f0103de7:	8d 41 01             	lea    0x1(%ecx),%eax
i=1;
uint32_t end=NENV;

//cprintf("\nIndex %d\n",index);

             for(;i<end;i++)
f0103dea:	3d ff 03 00 00       	cmp    $0x3ff,%eax
f0103def:	77 4b                	ja     f0103e3c <sched_yield+0x80>
                       {   
                          
                                   //cprintf("\nStatus %d \n",envs[i].env_status);
                             if(envs[i].env_status==ENV_RUNNABLE)
f0103df1:	8b 35 00 33 2d f0    	mov    0xf02d3300,%esi
f0103df7:	6b d0 7c             	imul   $0x7c,%eax,%edx
f0103dfa:	8d 14 16             	lea    (%esi,%edx,1),%edx
f0103dfd:	83 7a 54 01          	cmpl   $0x1,0x54(%edx)
f0103e01:	75 16                	jne    f0103e19 <sched_yield+0x5d>
f0103e03:	eb 0c                	jmp    f0103e11 <sched_yield+0x55>
f0103e05:	6b d0 7c             	imul   $0x7c,%eax,%edx
f0103e08:	8d 14 16             	lea    (%esi,%edx,1),%edx
f0103e0b:	83 7a 54 01          	cmpl   $0x1,0x54(%edx)
f0103e0f:	75 18                	jne    f0103e29 <sched_yield+0x6d>
                                   { 
                                     //cprintf("\nYieldind %d\n",i);
                                        env_run(&envs[i]);
f0103e11:	89 14 24             	mov    %edx,(%esp)
f0103e14:	e8 f2 ee ff ff       	call   f0102d0b <env_run>
f0103e19:	bb 00 04 00 00       	mov    $0x400,%ebx
                                   }
                             if(i==NENV-1)
                               {
                                 //cprintf("\nInside changing i%d\n",i);
                                 i=0;
                                 end=index+1;
f0103e1e:	83 c1 01             	add    $0x1,%ecx
f0103e21:	89 4d f4             	mov    %ecx,-0xc(%ebp)
f0103e24:	b9 00 00 00 00       	mov    $0x0,%ecx
                                   { 
                                     //cprintf("\nYieldind %d\n",i);
                                        env_run(&envs[i]);
                                         
                                   }
                             if(i==NENV-1)
f0103e29:	3d ff 03 00 00       	cmp    $0x3ff,%eax
f0103e2e:	75 05                	jne    f0103e35 <sched_yield+0x79>
                               {
                                 //cprintf("\nInside changing i%d\n",i);
                                 i=0;
                                 end=index+1;
f0103e30:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0103e33:	89 c8                	mov    %ecx,%eax
i=1;
uint32_t end=NENV;

//cprintf("\nIndex %d\n",index);

             for(;i<end;i++)
f0103e35:	83 c0 01             	add    $0x1,%eax
f0103e38:	39 c3                	cmp    %eax,%ebx
f0103e3a:	77 c9                	ja     f0103e05 <sched_yield+0x49>
  }
*/


	// Run the special idle environment when nothing else is runnable.
	if (envs[0].env_status == ENV_RUNNABLE)
f0103e3c:	a1 00 33 2d f0       	mov    0xf02d3300,%eax
f0103e41:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f0103e45:	75 08                	jne    f0103e4f <sched_yield+0x93>
		env_run(&envs[0]);
f0103e47:	89 04 24             	mov    %eax,(%esp)
f0103e4a:	e8 bc ee ff ff       	call   f0102d0b <env_run>
	else {
		cprintf("Destroyed all environments - nothing more to do!\n");
f0103e4f:	c7 04 24 70 73 10 f0 	movl   $0xf0107370,(%esp)
f0103e56:	e8 64 f5 ff ff       	call   f01033bf <cprintf>
		while (1)
			monitor(NULL);
f0103e5b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103e62:	e8 79 c9 ff ff       	call   f01007e0 <monitor>
f0103e67:	eb f2                	jmp    f0103e5b <sched_yield+0x9f>
f0103e69:	00 00                	add    %al,(%eax)
f0103e6b:	00 00                	add    %al,(%eax)
f0103e6d:	00 00                	add    %al,(%eax)
	...

f0103e70 <syscall>:


// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0103e70:	55                   	push   %ebp
f0103e71:	89 e5                	mov    %esp,%ebp
f0103e73:	83 ec 48             	sub    $0x48,%esp
f0103e76:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0103e79:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0103e7c:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0103e7f:	8b 45 08             	mov    0x8(%ebp),%eax
f0103e82:	8b 75 0c             	mov    0xc(%ebp),%esi
f0103e85:	8b 7d 10             	mov    0x10(%ebp),%edi
f0103e88:	8b 5d 14             	mov    0x14(%ebp),%ebx
               if(syscallno==SYS_cgetc)
                     return sys_cgetc();
   return ret;
}*/
//cprintf("\nNO----%d\n",syscallno);
 switch (syscallno) {  
f0103e8b:	83 f8 10             	cmp    $0x10,%eax
f0103e8e:	0f 87 3f 06 00 00    	ja     f01044d3 <syscall+0x663>
f0103e94:	ff 24 85 f0 73 10 f0 	jmp    *-0xfef8c10(,%eax,4)
	// Check that the user has permission to read memory [s, s+len).
	// Destroy the environment if not.
	
              	// LAB 3: Your code here.

             user_mem_assert(curenv,(void *)s,len,0);
f0103e9b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0103ea2:	00 
f0103ea3:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0103ea7:	89 74 24 04          	mov    %esi,0x4(%esp)
f0103eab:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0103eb0:	89 04 24             	mov    %eax,(%esp)
f0103eb3:	e8 8c cf ff ff       	call   f0100e44 <user_mem_assert>
                 // env_destroy(curenv);
       //cprintf("%d",len);

	// Print the string supplied by the user.
	cprintf("%.*s", len, s);
f0103eb8:	89 74 24 08          	mov    %esi,0x8(%esp)
f0103ebc:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0103ec0:	c7 04 24 a2 73 10 f0 	movl   $0xf01073a2,(%esp)
f0103ec7:	e8 f3 f4 ff ff       	call   f01033bf <cprintf>
f0103ecc:	b8 00 00 00 00       	mov    $0x0,%eax
f0103ed1:	e9 02 06 00 00       	jmp    f01044d8 <syscall+0x668>
// Read a character from the system console without blocking.
// Returns the character, or 0 if there is no input waiting.
static int
sys_cgetc(void)
{
	return cons_getc();
f0103ed6:	e8 54 c3 ff ff       	call   f010022f <cons_getc>
     case SYS_cputs:  
         sys_cputs((const char *)a1, (size_t)a2);  
         break;  
     case SYS_cgetc:  
         ret = sys_cgetc();  
         break;  
f0103edb:	90                   	nop
f0103edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0103ee0:	e9 f3 05 00 00       	jmp    f01044d8 <syscall+0x668>

// Returns the current environment's envid.
static envid_t
sys_getenvid(void)
{
	return curenv->env_id;
f0103ee5:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0103eea:	8b 40 4c             	mov    0x4c(%eax),%eax
     case SYS_cgetc:  
         ret = sys_cgetc();  
         break;  
     case SYS_getenvid:  
         ret = sys_getenvid();  
         break;  
f0103eed:	e9 e6 05 00 00       	jmp    f01044d8 <syscall+0x668>
sys_env_destroy(envid_t envid)
{
	int r;
	struct Env *e;

	if ((r = envid2env(envid, &e, 1)) < 0)
f0103ef2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0103ef9:	00 
f0103efa:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0103efd:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103f01:	89 34 24             	mov    %esi,(%esp)
f0103f04:	e8 67 ec ff ff       	call   f0102b70 <envid2env>
f0103f09:	85 c0                	test   %eax,%eax
f0103f0b:	0f 88 c7 05 00 00    	js     f01044d8 <syscall+0x668>
		return r;
	env_destroy(e);
f0103f11:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103f14:	89 04 24             	mov    %eax,(%esp)
f0103f17:	e8 c2 ef ff ff       	call   f0102ede <env_destroy>
f0103f1c:	b8 00 00 00 00       	mov    $0x0,%eax
f0103f21:	e9 b2 05 00 00       	jmp    f01044d8 <syscall+0x668>

// Deschedule current environment and pick a different one to run.
static void
sys_yield(void)
{
	sched_yield();
f0103f26:	e8 91 fe ff ff       	call   f0103dbc <sched_yield>

	// LAB 4: Your code here.
	
     struct Env *e;

         if(env_alloc(&e,curenv->env_id)<0)
f0103f2b:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0103f30:	8b 40 4c             	mov    0x4c(%eax),%eax
f0103f33:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103f37:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0103f3a:	89 04 24             	mov    %eax,(%esp)
f0103f3d:	e8 cb ef ff ff       	call   f0102f0d <env_alloc>
f0103f42:	89 c2                	mov    %eax,%edx
f0103f44:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f0103f49:	85 d2                	test   %edx,%edx
f0103f4b:	0f 88 87 05 00 00    	js     f01044d8 <syscall+0x668>
            return -E_NO_FREE_ENV;
      else
       {
        e->env_status = ENV_NOT_RUNNABLE;
f0103f51:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103f54:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
        e->env_tf=curenv->env_tf;
f0103f5b:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103f5e:	8b 35 04 33 2d f0    	mov    0xf02d3304,%esi
f0103f64:	b9 11 00 00 00       	mov    $0x11,%ecx
f0103f69:	89 c7                	mov    %eax,%edi
f0103f6b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
     //when child env runs value of e  
        e->env_tf.tf_regs.reg_eax=0;
f0103f6d:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103f70:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
      
        return e->env_id;
f0103f77:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103f7a:	8b 40 4c             	mov    0x4c(%eax),%eax
f0103f7d:	e9 56 05 00 00       	jmp    f01044d8 <syscall+0x668>
	// check whether the current environment has permission to set
	// envid's status.
      
	// LAB 4: Your code here.
         struct Env *e;  
           if(envid2env(envid,&e,1)<0)
f0103f82:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0103f89:	00 
f0103f8a:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0103f8d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0103f91:	89 34 24             	mov    %esi,(%esp)
f0103f94:	e8 d7 eb ff ff       	call   f0102b70 <envid2env>
f0103f99:	89 c2                	mov    %eax,%edx
f0103f9b:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103fa0:	85 d2                	test   %edx,%edx
f0103fa2:	0f 88 30 05 00 00    	js     f01044d8 <syscall+0x668>
               return -E_BAD_ENV;
            else
               {

                  if(status!=ENV_RUNNABLE && status!=ENV_NOT_RUNNABLE)
f0103fa8:	8d 57 ff             	lea    -0x1(%edi),%edx
f0103fab:	b0 fd                	mov    $0xfd,%al
f0103fad:	83 fa 01             	cmp    $0x1,%edx
f0103fb0:	0f 87 22 05 00 00    	ja     f01044d8 <syscall+0x668>
                       return -E_INVAL;
                     else
                     {
                       e->env_status=status;
f0103fb6:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103fb9:	89 78 54             	mov    %edi,0x54(%eax)
f0103fbc:	b8 00 00 00 00       	mov    $0x0,%eax
f0103fc1:	e9 12 05 00 00       	jmp    f01044d8 <syscall+0x668>
	//   If page_insert() fails, remember to free the page you
	//   allocated!

	// LAB 4: Your code here.
               
         struct Env *e=NULL;
f0103fc6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
         struct Page *p=NULL;
f0103fcd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

              if( (perm & PTE_P)!=0 && (perm & PTE_U)!=0)
f0103fd4:	89 d8                	mov    %ebx,%eax
f0103fd6:	83 e0 05             	and    $0x5,%eax
f0103fd9:	83 f8 05             	cmp    $0x5,%eax
f0103fdc:	0f 85 09 01 00 00    	jne    f01040eb <syscall+0x27b>
                   {
                         if((perm & ((~(PTE_USER)) & 0xFFF))!=0)
f0103fe2:	f7 c3 f8 01 00 00    	test   $0x1f8,%ebx
f0103fe8:	0f 85 fd 00 00 00    	jne    f01040eb <syscall+0x27b>
       break;
    case SYS_env_set_status:
         ret = sys_env_set_status(a1,a2);
        break;
    case SYS_page_alloc:
         ret = sys_page_alloc(a1,(void *)a2,a3);
f0103fee:	89 7d d4             	mov    %edi,-0x2c(%ebp)
                               return -E_INVAL;
                   }
              else
                return -E_INVAL;

             if(va >=(void *)UTOP ||((uint32_t)va)%PGSIZE!=0)
f0103ff1:	81 ff ff ff bf ee    	cmp    $0xeebfffff,%edi
f0103ff7:	0f 87 ee 00 00 00    	ja     f01040eb <syscall+0x27b>
f0103ffd:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
f0104003:	0f 85 e2 00 00 00    	jne    f01040eb <syscall+0x27b>
               return -E_INVAL;             
             if(envid2env(envid,&e,1)<0)
f0104009:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104010:	00 
f0104011:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0104014:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104018:	89 34 24             	mov    %esi,(%esp)
f010401b:	e8 50 eb ff ff       	call   f0102b70 <envid2env>
f0104020:	89 c2                	mov    %eax,%edx
f0104022:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0104027:	85 d2                	test   %edx,%edx
f0104029:	0f 88 a9 04 00 00    	js     f01044d8 <syscall+0x668>
               return -E_BAD_ENV;
             if (page_alloc(&p)<0)
f010402f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104032:	89 04 24             	mov    %eax,(%esp)
f0104035:	e8 cc cb ff ff       	call   f0100c06 <page_alloc>
f010403a:	89 c2                	mov    %eax,%edx
f010403c:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0104041:	85 d2                	test   %edx,%edx
f0104043:	0f 88 8f 04 00 00    	js     f01044d8 <syscall+0x668>
               return -E_NO_MEM;
          else
            {
                if(page_insert(e->env_pgdir,p,va,perm)<0)
f0104049:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010404d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0104050:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104054:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104057:	89 44 24 04          	mov    %eax,0x4(%esp)
f010405b:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010405e:	8b 40 5c             	mov    0x5c(%eax),%eax
f0104061:	89 04 24             	mov    %eax,(%esp)
f0104064:	e8 fa ce ff ff       	call   f0100f63 <page_insert>
f0104069:	85 c0                	test   %eax,%eax
f010406b:	79 15                	jns    f0104082 <syscall+0x212>
                  {
                        page_free(p);
f010406d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104070:	89 04 24             	mov    %eax,(%esp)
f0104073:	e8 f5 c9 ff ff       	call   f0100a6d <page_free>
f0104078:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010407d:	e9 56 04 00 00       	jmp    f01044d8 <syscall+0x668>
}

static inline physaddr_t
page2pa(struct Page *pp)
{
	return page2ppn(pp) << PGSHIFT;
f0104082:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104085:	2b 05 b8 3f 2d f0    	sub    0xf02d3fb8,%eax
f010408b:	c1 f8 02             	sar    $0x2,%eax
f010408e:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f0104094:	c1 e0 0c             	shl    $0xc,%eax
                        return -E_NO_MEM;
                  }
//            cprintf("\ninside page alooc\n");
             memset(KADDR(page2pa(p)),0,PGSIZE);
f0104097:	89 c2                	mov    %eax,%edx
f0104099:	c1 ea 0c             	shr    $0xc,%edx
f010409c:	3b 15 ac 3f 2d f0    	cmp    0xf02d3fac,%edx
f01040a2:	72 20                	jb     f01040c4 <syscall+0x254>
f01040a4:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01040a8:	c7 44 24 08 00 69 10 	movl   $0xf0106900,0x8(%esp)
f01040af:	f0 
f01040b0:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
f01040b7:	00 
f01040b8:	c7 04 24 a7 73 10 f0 	movl   $0xf01073a7,(%esp)
f01040bf:	e8 c1 bf ff ff       	call   f0100085 <_panic>
f01040c4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
f01040cb:	00 
f01040cc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01040d3:	00 
f01040d4:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01040d9:	89 04 24             	mov    %eax,(%esp)
f01040dc:	e8 a5 10 00 00       	call   f0105186 <memset>
f01040e1:	b8 00 00 00 00       	mov    $0x0,%eax
f01040e6:	e9 ed 03 00 00       	jmp    f01044d8 <syscall+0x668>
f01040eb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01040f0:	e9 e3 03 00 00       	jmp    f01044d8 <syscall+0x668>
	//   parameters for correctness.
	//   Use the third argument to page_lookup() to
	//   check the current permissions on the page.

	// LAB 4: Your code here.
          struct Env *srcenv=NULL;
f01040f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
          struct Env *destenv=NULL;
f01040fc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
          struct Page *p=NULL;    
            
	    if(envid2env(srcenvid,&srcenv,1)<0 || envid2env(dstenvid,&destenv,1)<0)
f0104103:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010410a:	00 
f010410b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f010410e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104112:	89 34 24             	mov    %esi,(%esp)
f0104115:	e8 56 ea ff ff       	call   f0102b70 <envid2env>
f010411a:	85 c0                	test   %eax,%eax
f010411c:	0f 88 b2 00 00 00    	js     f01041d4 <syscall+0x364>
f0104122:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104129:	00 
f010412a:	8d 45 dc             	lea    -0x24(%ebp),%eax
f010412d:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104131:	89 1c 24             	mov    %ebx,(%esp)
f0104134:	e8 37 ea ff ff       	call   f0102b70 <envid2env>
f0104139:	85 c0                	test   %eax,%eax
f010413b:	0f 88 93 00 00 00    	js     f01041d4 <syscall+0x364>
        break;
    case SYS_page_alloc:
         ret = sys_page_alloc(a1,(void *)a2,a3);
        break;
    case SYS_page_map:
         ret = sys_page_map(a1,(void *)a2,a3,(void *)a4,a5);
f0104141:	8b 5d 18             	mov    0x18(%ebp),%ebx
f0104144:	89 f8                	mov    %edi,%eax
          struct Env *destenv=NULL;
          struct Page *p=NULL;    
            
	    if(envid2env(srcenvid,&srcenv,1)<0 || envid2env(dstenvid,&destenv,1)<0)
                 return -E_BAD_ENV;
            if(srcva>= (void *)UTOP || dstva>= (void *)UTOP || ((uint32_t)srcva)%PGSIZE!=0 ||((uint32_t)dstva)%PGSIZE!=0)
f0104146:	81 ff ff ff bf ee    	cmp    $0xeebfffff,%edi
f010414c:	0f 87 8c 00 00 00    	ja     f01041de <syscall+0x36e>
f0104152:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f0104158:	0f 87 80 00 00 00    	ja     f01041de <syscall+0x36e>
f010415e:	09 df                	or     %ebx,%edi
f0104160:	f7 c7 ff 0f 00 00    	test   $0xfff,%edi
f0104166:	75 76                	jne    f01041de <syscall+0x36e>
                return -E_INVAL;

         pte_t *srcPageToMap=NULL;
f0104168:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
         p = page_lookup(srcenv->env_pgdir,srcva,&srcPageToMap);
f010416f:	8d 55 e0             	lea    -0x20(%ebp),%edx
f0104172:	89 54 24 08          	mov    %edx,0x8(%esp)
f0104176:	89 44 24 04          	mov    %eax,0x4(%esp)
f010417a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010417d:	8b 40 5c             	mov    0x5c(%eax),%eax
f0104180:	89 04 24             	mov    %eax,(%esp)
f0104183:	e8 14 cd ff ff       	call   f0100e9c <page_lookup>

	    if(p==NULL)
f0104188:	85 c0                	test   %eax,%eax
f010418a:	74 52                	je     f01041de <syscall+0x36e>
                return -E_INVAL;
            else
                {
                     if( (perm & PTE_P)!=0 && (perm & PTE_U)!=0)
f010418c:	8b 55 1c             	mov    0x1c(%ebp),%edx
f010418f:	83 e2 05             	and    $0x5,%edx
f0104192:	83 fa 05             	cmp    $0x5,%edx
f0104195:	75 47                	jne    f01041de <syscall+0x36e>
        break;
    case SYS_page_alloc:
         ret = sys_page_alloc(a1,(void *)a2,a3);
        break;
    case SYS_page_map:
         ret = sys_page_map(a1,(void *)a2,a3,(void *)a4,a5);
f0104197:	8b 55 1c             	mov    0x1c(%ebp),%edx
                return -E_INVAL;
            else
                {
                     if( (perm & PTE_P)!=0 && (perm & PTE_U)!=0)
                       {
                         if((perm & ((~(PTE_USER)) & 0xFFF))!=0)
f010419a:	f7 c2 f8 01 00 00    	test   $0x1f8,%edx
f01041a0:	75 3c                	jne    f01041de <syscall+0x36e>
                       }
                    else
                     return -E_INVAL;
                   
                    int srcperm = (*(srcPageToMap) & 0xFFF); 
                     if ((srcperm & PTE_W) == 0)
f01041a2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01041a5:	f6 01 02             	testb  $0x2,(%ecx)
f01041a8:	75 05                	jne    f01041af <syscall+0x33f>
                         {
                              if((perm & PTE_W)!=0)
f01041aa:	f6 c2 02             	test   $0x2,%dl
f01041ad:	75 2f                	jne    f01041de <syscall+0x36e>
                               return -E_INVAL;    
                         }           
                                 
                         //else
                         {
                            if (page_insert(destenv->env_pgdir,p,dstva,perm)<0)
f01041af:	89 54 24 0c          	mov    %edx,0xc(%esp)
f01041b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f01041b7:	89 44 24 04          	mov    %eax,0x4(%esp)
f01041bb:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01041be:	8b 40 5c             	mov    0x5c(%eax),%eax
f01041c1:	89 04 24             	mov    %eax,(%esp)
f01041c4:	e8 9a cd ff ff       	call   f0100f63 <page_insert>
f01041c9:	c1 f8 1f             	sar    $0x1f,%eax
f01041cc:	83 e0 fc             	and    $0xfffffffc,%eax
f01041cf:	e9 04 03 00 00       	jmp    f01044d8 <syscall+0x668>
f01041d4:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01041d9:	e9 fa 02 00 00       	jmp    f01044d8 <syscall+0x668>
f01041de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01041e3:	e9 f0 02 00 00       	jmp    f01044d8 <syscall+0x668>
sys_page_unmap(envid_t envid, void *va)
{
	// Hint: This function is a wrapper around page_remove().

	// LAB 4: Your code here.
         struct Env *e=NULL;
f01041e8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
      
       if((uint32_t)va>=UTOP)
f01041ef:	81 ff ff ff bf ee    	cmp    $0xeebfffff,%edi
f01041f5:	76 0a                	jbe    f0104201 <syscall+0x391>
f01041f7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01041fc:	e9 d7 02 00 00       	jmp    f01044d8 <syscall+0x668>
          return -E_INVAL;
     //cprintf("\nPageUnmap %x\n",va);
        if(envid2env(envid,&e,1)<0)
f0104201:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104208:	00 
f0104209:	8d 45 e0             	lea    -0x20(%ebp),%eax
f010420c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104210:	89 34 24             	mov    %esi,(%esp)
f0104213:	e8 58 e9 ff ff       	call   f0102b70 <envid2env>
f0104218:	89 c2                	mov    %eax,%edx
f010421a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010421f:	85 d2                	test   %edx,%edx
f0104221:	0f 88 b1 02 00 00    	js     f01044d8 <syscall+0x668>
                return -E_BAD_ENV;
        else
          {
             page_remove(e->env_pgdir,va);
f0104227:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010422b:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010422e:	8b 40 5c             	mov    0x5c(%eax),%eax
f0104231:	89 04 24             	mov    %eax,(%esp)
f0104234:	e8 d3 cc ff ff       	call   f0100f0c <page_remove>
f0104239:	b8 00 00 00 00       	mov    $0x0,%eax
f010423e:	e9 95 02 00 00       	jmp    f01044d8 <syscall+0x668>
//		or the caller doesn't have permission to change envid.
static int
sys_env_set_pgfault_upcall(envid_t envid, void *func)
{
	// LAB 4: Your code here.
      struct Env *e=NULL;
f0104243:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

        if(envid2env(envid,&e,1)<0)
f010424a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f0104251:	00 
f0104252:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104255:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104259:	89 34 24             	mov    %esi,(%esp)
f010425c:	e8 0f e9 ff ff       	call   f0102b70 <envid2env>
f0104261:	85 c0                	test   %eax,%eax
f0104263:	78 06                	js     f010426b <syscall+0x3fb>
               return -E_BAD_ENV;
         e->env_pgfault_upcall=func;
f0104265:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104268:	89 78 64             	mov    %edi,0x64(%eax)

static int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, unsigned perm)
{
	// LAB 4: Your code here.
        struct Env *e=NULL;
f010426b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
        struct Page *p=NULL;
        pte_t *pageTableEntry=NULL;
f0104272:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
        int srcperm = 0;
          if(envid2env(envid,&e,0)<0)
f0104279:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
f0104280:	00 
f0104281:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104284:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104288:	89 34 24             	mov    %esi,(%esp)
f010428b:	e8 e0 e8 ff ff       	call   f0102b70 <envid2env>
f0104290:	89 c2                	mov    %eax,%edx
f0104292:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0104297:	85 d2                	test   %edx,%edx
f0104299:	0f 88 39 02 00 00    	js     f01044d8 <syscall+0x668>
                           return -E_BAD_ENV;

          if(e->env_status != ENV_NOT_RUNNABLE || e->env_ipc_recving == 0)
f010429f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01042a2:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f01042a6:	0f 85 f8 00 00 00    	jne    f01043a4 <syscall+0x534>
f01042ac:	83 78 68 00          	cmpl   $0x0,0x68(%eax)
f01042b0:	0f 84 ee 00 00 00    	je     f01043a4 <syscall+0x534>
                    {
                        return -E_IPC_NOT_RECV;
                    }
                           
         if((uint32_t)srcva < UTOP && srcva!=NULL)
f01042b6:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f01042bc:	0f 87 a9 00 00 00    	ja     f010436b <syscall+0x4fb>
f01042c2:	85 db                	test   %ebx,%ebx
f01042c4:	0f 84 a1 00 00 00    	je     f010436b <syscall+0x4fb>
              {
                 if( (perm & PTE_P)!=0 && (perm & PTE_U)!=0)
f01042ca:	8b 45 18             	mov    0x18(%ebp),%eax
f01042cd:	83 e0 05             	and    $0x5,%eax
f01042d0:	83 f8 05             	cmp    $0x5,%eax
f01042d3:	0f 85 d5 00 00 00    	jne    f01043ae <syscall+0x53e>
                   {
                         if((perm & ((~(PTE_USER)) & 0xFFF))!=0)
f01042d9:	f7 45 18 f8 01 00 00 	testl  $0x1f8,0x18(%ebp)
f01042e0:	0f 85 c8 00 00 00    	jne    f01043ae <syscall+0x53e>
                               return -E_INVAL;
                   }
                else
                 return -E_INVAL;

                 if((uint32_t)srcva%PGSIZE!=0)
f01042e6:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
f01042ec:	0f 85 bc 00 00 00    	jne    f01043ae <syscall+0x53e>
                    return -E_INVAL;
            
               p=page_lookup(curenv->env_pgdir,srcva,&pageTableEntry);
f01042f2:	8d 45 dc             	lea    -0x24(%ebp),%eax
f01042f5:	89 44 24 08          	mov    %eax,0x8(%esp)
f01042f9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01042fd:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0104302:	8b 40 5c             	mov    0x5c(%eax),%eax
f0104305:	89 04 24             	mov    %eax,(%esp)
f0104308:	e8 8f cb ff ff       	call   f0100e9c <page_lookup>
                     
                  if(p==NULL)
f010430d:	85 c0                	test   %eax,%eax
f010430f:	0f 84 99 00 00 00    	je     f01043ae <syscall+0x53e>
                     return -E_INVAL;

                srcperm = *(pageTableEntry) & (0xFFF);  
                 
                  if((srcperm & PTE_W) ==0)
f0104315:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0104318:	f6 02 02             	testb  $0x2,(%edx)
f010431b:	75 0a                	jne    f0104327 <syscall+0x4b7>
                   {
                      if((perm & PTE_W)!=0)
f010431d:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0104321:	0f 85 87 00 00 00    	jne    f01043ae <syscall+0x53e>
                        return -E_INVAL;
                   }
                                
                if(e->env_ipc_dstva!=NULL)
f0104327:	8b 55 e0             	mov    -0x20(%ebp),%edx
f010432a:	8b 4a 6c             	mov    0x6c(%edx),%ecx
f010432d:	85 c9                	test   %ecx,%ecx
f010432f:	74 31                	je     f0104362 <syscall+0x4f2>
                  {  if(page_insert(e->env_pgdir,p,e->env_ipc_dstva,perm)<0)
f0104331:	8b 5d 18             	mov    0x18(%ebp),%ebx
f0104334:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0104338:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010433c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104340:	8b 42 5c             	mov    0x5c(%edx),%eax
f0104343:	89 04 24             	mov    %eax,(%esp)
f0104346:	e8 18 cc ff ff       	call   f0100f63 <page_insert>
f010434b:	89 c2                	mov    %eax,%edx
f010434d:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0104352:	85 d2                	test   %edx,%edx
f0104354:	0f 88 7e 01 00 00    	js     f01044d8 <syscall+0x668>
                       return -E_NO_MEM;
                     e->env_ipc_perm = perm; 
f010435a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010435d:	89 58 78             	mov    %ebx,0x78(%eax)
f0104360:	eb 10                	jmp    f0104372 <syscall+0x502>
                  }
                else
                  {
                   e->env_ipc_perm =0;
f0104362:	c7 42 78 00 00 00 00 	movl   $0x0,0x78(%edx)
f0104369:	eb 07                	jmp    f0104372 <syscall+0x502>
       
              }
             
             else
               {
                   e->env_ipc_perm=0;
f010436b:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
               }
            
             e->env_ipc_from = curenv->env_id;
f0104372:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0104377:	8b 50 4c             	mov    0x4c(%eax),%edx
f010437a:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010437d:	89 50 74             	mov    %edx,0x74(%eax)
             e->env_ipc_value = value;
f0104380:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104383:	89 78 70             	mov    %edi,0x70(%eax)
             e->env_ipc_recving = 0;
f0104386:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104389:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)
             e->env_status = ENV_RUNNABLE;
f0104390:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104393:	c7 40 54 01 00 00 00 	movl   $0x1,0x54(%eax)
f010439a:	b8 00 00 00 00       	mov    $0x0,%eax
f010439f:	e9 34 01 00 00       	jmp    f01044d8 <syscall+0x668>
f01043a4:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
f01043a9:	e9 2a 01 00 00       	jmp    f01044d8 <syscall+0x668>
f01043ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01043b3:	e9 20 01 00 00       	jmp    f01044d8 <syscall+0x668>
static int
sys_ipc_recv(void *dstva)
{
	// LAB 4: Your code here.
      
            if((uint32_t)dstva < UTOP && dstva!=NULL)
f01043b8:	81 fe ff ff bf ee    	cmp    $0xeebfffff,%esi
f01043be:	66 90                	xchg   %ax,%ax
f01043c0:	77 1f                	ja     f01043e1 <syscall+0x571>
f01043c2:	85 f6                	test   %esi,%esi
f01043c4:	74 1b                	je     f01043e1 <syscall+0x571>
               {
                    if((((uint32_t)dstva)%PGSIZE)!=0)
f01043c6:	f7 c6 ff 0f 00 00    	test   $0xfff,%esi
f01043cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01043d0:	0f 85 fd 00 00 00    	jne    f01044d3 <syscall+0x663>
                       return -E_INVAL;
                    
                    curenv->env_ipc_dstva = dstva;
f01043d6:	8b 15 04 33 2d f0    	mov    0xf02d3304,%edx
f01043dc:	89 72 6c             	mov    %esi,0x6c(%edx)
f01043df:	eb 0c                	jmp    f01043ed <syscall+0x57d>
               }
          else 
           curenv->env_ipc_dstva = NULL;
f01043e1:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f01043e6:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
	
        curenv->env_status=ENV_NOT_RUNNABLE;
f01043ed:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f01043f2:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
        curenv->env_ipc_recving = 1;
f01043f9:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f01043fe:	c7 40 68 01 00 00 00 	movl   $0x1,0x68(%eax)
        curenv->env_tf.tf_regs.reg_eax = 0;
f0104405:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f010440a:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
        sched_yield();       
f0104411:	e8 a6 f9 ff ff       	call   f0103dbc <sched_yield>
          break;
    case SYS_ipc_recv:
          ret=sys_ipc_recv((void *)a1);
           break;
   case SYS_env_set_trapframe:
         ret=sys_env_set_trapframe(a1,(struct Trapframe *)a2);
f0104416:	89 fb                	mov    %edi,%ebx
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	// LAB 5: Your code here.
	// Remember to check whether the user has supplied us with a good
	// address!
       cprintf("tf value esp-->%x eip  %x",tf->tf_esp,tf->tf_eip);  
f0104418:	8b 47 30             	mov    0x30(%edi),%eax
f010441b:	89 44 24 08          	mov    %eax,0x8(%esp)
f010441f:	8b 47 3c             	mov    0x3c(%edi),%eax
f0104422:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104426:	c7 04 24 b6 73 10 f0 	movl   $0xf01073b6,(%esp)
f010442d:	e8 8d ef ff ff       	call   f01033bf <cprintf>
    user_mem_assert(curenv,(void *)tf,sizeof(tf),0);
f0104432:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0104439:	00 
f010443a:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f0104441:	00 
f0104442:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0104446:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f010444b:	89 04 24             	mov    %eax,(%esp)
f010444e:	e8 f1 c9 ff ff       	call   f0100e44 <user_mem_assert>
       struct Env *e;  
           if(envid2env(envid,&e,1)<0)
f0104453:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
f010445a:	00 
f010445b:	8d 45 dc             	lea    -0x24(%ebp),%eax
f010445e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104462:	89 34 24             	mov    %esi,(%esp)
f0104465:	e8 06 e7 ff ff       	call   f0102b70 <envid2env>
f010446a:	89 c2                	mov    %eax,%edx
f010446c:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0104471:	85 d2                	test   %edx,%edx
f0104473:	78 63                	js     f01044d8 <syscall+0x668>
               return -E_BAD_ENV;
         e->env_tf=*tf;
f0104475:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104478:	b9 11 00 00 00       	mov    $0x11,%ecx
f010447d:	89 c7                	mov    %eax,%edi
f010447f:	89 de                	mov    %ebx,%esi
f0104481:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
         //e->env_tf.tf_cs=tf->tf_cs|3;
         e->env_tf.tf_eflags|=FL_IF;
f0104483:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104486:	81 48 38 00 02 00 00 	orl    $0x200,0x38(%eax)
         e->env_tf.tf_eflags&=~(FL_IOPL_3);
f010448d:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104490:	81 60 38 ff cf ff ff 	andl   $0xffffcfff,0x38(%eax)
               
      cprintf("\nHere inside setting trapframe\n");    
f0104497:	c7 04 24 d0 73 10 f0 	movl   $0xf01073d0,(%esp)
f010449e:	e8 1c ef ff ff       	call   f01033bf <cprintf>
f01044a3:	b8 00 00 00 00       	mov    $0x0,%eax
f01044a8:	eb 2e                	jmp    f01044d8 <syscall+0x668>
// Return the current time.
static int
sys_time_msec(void) 
{
	// LAB 6: Your code here.
         return time_msec();
f01044aa:	e8 30 1a 00 00       	call   f0105edf <time_msec>
   case SYS_env_set_trapframe:
         ret=sys_env_set_trapframe(a1,(struct Trapframe *)a2);
    break;
   case SYS_time_msec:
         ret=sys_time_msec();
    break;
f01044af:	90                   	nop
f01044b0:	eb 26                	jmp    f01044d8 <syscall+0x668>

static int sys_call_packet_send(void *va,size_t len)
{
 int i=0;
//cprintf("\nHere inside sys_call_packet\n");  
 copyIntoDMA(va,len);
f01044b2:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01044b6:	89 34 24             	mov    %esi,(%esp)
f01044b9:	e8 81 11 00 00       	call   f010563f <copyIntoDMA>
f01044be:	b8 00 00 00 00       	mov    $0x0,%eax
   case SYS_time_msec:
         ret=sys_time_msec();
    break;
   case SYS_call_packet_send:
         ret=sys_call_packet_send((void *)a1,a2);
   break;
f01044c3:	eb 13                	jmp    f01044d8 <syscall+0x668>
}

static int sys_call_receive_packet(void *va, void *len)
{
   //cprintf("\nlen in syscall%x\n",&len);
   int r = copyFromRFA(va,len);
f01044c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01044c9:	89 34 24             	mov    %esi,(%esp)
f01044cc:	e8 ff 11 00 00       	call   f01056d0 <copyFromRFA>
   case SYS_call_packet_send:
         ret=sys_call_packet_send((void *)a1,a2);
   break;
   case SYS_call_receive_packet:
         ret=sys_call_receive_packet((void *)a1,(void *)a2);
       break;
f01044d1:	eb 05                	jmp    f01044d8 <syscall+0x668>
f01044d3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
         // NSYSCALLS  
         ret = -E_INVAL;  
         break;  
    }
  return ret;
}
f01044d8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f01044db:	8b 75 f8             	mov    -0x8(%ebp),%esi
f01044de:	8b 7d fc             	mov    -0x4(%ebp),%edi
f01044e1:	89 ec                	mov    %ebp,%esp
f01044e3:	5d                   	pop    %ebp
f01044e4:	c3                   	ret    
	...

f01044f0 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f01044f0:	55                   	push   %ebp
f01044f1:	89 e5                	mov    %esp,%ebp
f01044f3:	57                   	push   %edi
f01044f4:	56                   	push   %esi
f01044f5:	53                   	push   %ebx
f01044f6:	83 ec 14             	sub    $0x14,%esp
f01044f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
f01044fc:	89 55 e8             	mov    %edx,-0x18(%ebp)
f01044ff:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104502:	8b 75 08             	mov    0x8(%ebp),%esi
	int l = *region_left, r = *region_right, any_matches = 0;
f0104505:	8b 1a                	mov    (%edx),%ebx
f0104507:	8b 01                	mov    (%ecx),%eax
f0104509:	89 45 ec             	mov    %eax,-0x14(%ebp)
	
	while (l <= r) {
f010450c:	39 c3                	cmp    %eax,%ebx
f010450e:	0f 8f 9c 00 00 00    	jg     f01045b0 <stab_binsearch+0xc0>
f0104514:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		int true_m = (l + r) / 2, m = true_m;
f010451b:	8b 45 ec             	mov    -0x14(%ebp),%eax
f010451e:	01 d8                	add    %ebx,%eax
f0104520:	89 c7                	mov    %eax,%edi
f0104522:	c1 ef 1f             	shr    $0x1f,%edi
f0104525:	01 c7                	add    %eax,%edi
f0104527:	d1 ff                	sar    %edi
		
		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f0104529:	39 df                	cmp    %ebx,%edi
f010452b:	7c 33                	jl     f0104560 <stab_binsearch+0x70>
f010452d:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0104530:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0104533:	0f b6 44 82 04       	movzbl 0x4(%edx,%eax,4),%eax
f0104538:	39 f0                	cmp    %esi,%eax
f010453a:	0f 84 bc 00 00 00    	je     f01045fc <stab_binsearch+0x10c>
f0104540:	8d 44 7f fd          	lea    -0x3(%edi,%edi,2),%eax
f0104544:	8d 54 82 04          	lea    0x4(%edx,%eax,4),%edx
f0104548:	89 f8                	mov    %edi,%eax
			m--;
f010454a:	83 e8 01             	sub    $0x1,%eax
	
	while (l <= r) {
		int true_m = (l + r) / 2, m = true_m;
		
		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
f010454d:	39 d8                	cmp    %ebx,%eax
f010454f:	7c 0f                	jl     f0104560 <stab_binsearch+0x70>
f0104551:	0f b6 0a             	movzbl (%edx),%ecx
f0104554:	83 ea 0c             	sub    $0xc,%edx
f0104557:	39 f1                	cmp    %esi,%ecx
f0104559:	75 ef                	jne    f010454a <stab_binsearch+0x5a>
f010455b:	e9 9e 00 00 00       	jmp    f01045fe <stab_binsearch+0x10e>
			m--;
		if (m < l) {	// no match in [l, m]
			l = true_m + 1;
f0104560:	8d 5f 01             	lea    0x1(%edi),%ebx
			continue;
f0104563:	eb 3c                	jmp    f01045a1 <stab_binsearch+0xb1>
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
			*region_left = m;
f0104565:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0104568:	89 01                	mov    %eax,(%ecx)
			l = true_m + 1;
f010456a:	8d 5f 01             	lea    0x1(%edi),%ebx
f010456d:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0104574:	eb 2b                	jmp    f01045a1 <stab_binsearch+0xb1>
		} else if (stabs[m].n_value > addr) {
f0104576:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0104579:	76 14                	jbe    f010458f <stab_binsearch+0x9f>
			*region_right = m - 1;
f010457b:	83 e8 01             	sub    $0x1,%eax
f010457e:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104581:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104584:	89 02                	mov    %eax,(%edx)
f0104586:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f010458d:	eb 12                	jmp    f01045a1 <stab_binsearch+0xb1>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f010458f:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f0104592:	89 01                	mov    %eax,(%ecx)
			l = m;
			addr++;
f0104594:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
f0104598:	89 c3                	mov    %eax,%ebx
f010459a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
	int l = *region_left, r = *region_right, any_matches = 0;
	
	while (l <= r) {
f01045a1:	39 5d ec             	cmp    %ebx,-0x14(%ebp)
f01045a4:	0f 8d 71 ff ff ff    	jge    f010451b <stab_binsearch+0x2b>
			l = m;
			addr++;
		}
	}

	if (!any_matches)
f01045aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f01045ae:	75 0f                	jne    f01045bf <stab_binsearch+0xcf>
		*region_right = *region_left - 1;
f01045b0:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f01045b3:	8b 03                	mov    (%ebx),%eax
f01045b5:	83 e8 01             	sub    $0x1,%eax
f01045b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01045bb:	89 02                	mov    %eax,(%edx)
f01045bd:	eb 57                	jmp    f0104616 <stab_binsearch+0x126>
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f01045bf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f01045c2:	8b 01                	mov    (%ecx),%eax
		     l > *region_left && stabs[l].n_type != type;
f01045c4:	8b 5d e8             	mov    -0x18(%ebp),%ebx
f01045c7:	8b 0b                	mov    (%ebx),%ecx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f01045c9:	39 c1                	cmp    %eax,%ecx
f01045cb:	7d 28                	jge    f01045f5 <stab_binsearch+0x105>
		     l > *region_left && stabs[l].n_type != type;
f01045cd:	8d 14 40             	lea    (%eax,%eax,2),%edx
f01045d0:	8b 5d f0             	mov    -0x10(%ebp),%ebx
f01045d3:	0f b6 54 93 04       	movzbl 0x4(%ebx,%edx,4),%edx
f01045d8:	39 f2                	cmp    %esi,%edx
f01045da:	74 19                	je     f01045f5 <stab_binsearch+0x105>
f01045dc:	8d 54 40 fd          	lea    -0x3(%eax,%eax,2),%edx
f01045e0:	8d 54 93 04          	lea    0x4(%ebx,%edx,4),%edx
		     l--)
f01045e4:	83 e8 01             	sub    $0x1,%eax

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f01045e7:	39 c1                	cmp    %eax,%ecx
f01045e9:	7d 0a                	jge    f01045f5 <stab_binsearch+0x105>
		     l > *region_left && stabs[l].n_type != type;
f01045eb:	0f b6 1a             	movzbl (%edx),%ebx
f01045ee:	83 ea 0c             	sub    $0xc,%edx

	if (!any_matches)
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f01045f1:	39 f3                	cmp    %esi,%ebx
f01045f3:	75 ef                	jne    f01045e4 <stab_binsearch+0xf4>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
f01045f5:	8b 55 e8             	mov    -0x18(%ebp),%edx
f01045f8:	89 02                	mov    %eax,(%edx)
f01045fa:	eb 1a                	jmp    f0104616 <stab_binsearch+0x126>
	}
}
f01045fc:	89 f8                	mov    %edi,%eax
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f01045fe:	8d 14 40             	lea    (%eax,%eax,2),%edx
f0104601:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0104604:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104608:	3b 55 0c             	cmp    0xc(%ebp),%edx
f010460b:	0f 82 54 ff ff ff    	jb     f0104565 <stab_binsearch+0x75>
f0104611:	e9 60 ff ff ff       	jmp    f0104576 <stab_binsearch+0x86>
		     l > *region_left && stabs[l].n_type != type;
		     l--)
			/* do nothing */;
		*region_left = l;
	}
}
f0104616:	83 c4 14             	add    $0x14,%esp
f0104619:	5b                   	pop    %ebx
f010461a:	5e                   	pop    %esi
f010461b:	5f                   	pop    %edi
f010461c:	5d                   	pop    %ebp
f010461d:	c3                   	ret    

f010461e <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f010461e:	55                   	push   %ebp
f010461f:	89 e5                	mov    %esp,%ebp
f0104621:	83 ec 58             	sub    $0x58,%esp
f0104624:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0104627:	89 75 f8             	mov    %esi,-0x8(%ebp)
f010462a:	89 7d fc             	mov    %edi,-0x4(%ebp)
f010462d:	8b 75 08             	mov    0x8(%ebp),%esi
f0104630:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0104633:	c7 03 34 74 10 f0    	movl   $0xf0107434,(%ebx)
	info->eip_line = 0;
f0104639:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	info->eip_fn_name = "<unknown>";
f0104640:	c7 43 08 34 74 10 f0 	movl   $0xf0107434,0x8(%ebx)
	info->eip_fn_namelen = 9;
f0104647:	c7 43 0c 09 00 00 00 	movl   $0x9,0xc(%ebx)
	info->eip_fn_addr = addr;
f010464e:	89 73 10             	mov    %esi,0x10(%ebx)
	info->eip_fn_narg = 0;
f0104651:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f0104658:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f010465e:	76 1f                	jbe    f010467f <debuginfo_eip+0x61>
f0104660:	bf b3 64 11 f0       	mov    $0xf01164b3,%edi
f0104665:	c7 45 c4 f9 16 11 f0 	movl   $0xf01116f9,-0x3c(%ebp)
f010466c:	c7 45 bc f8 16 11 f0 	movl   $0xf01116f8,-0x44(%ebp)
f0104673:	c7 45 c0 5c 7a 10 f0 	movl   $0xf0107a5c,-0x40(%ebp)
f010467a:	e9 a3 00 00 00       	jmp    f0104722 <debuginfo_eip+0x104>
                const struct UserStabData *usd = (const struct UserStabData *) USTABDATA;

                // Make sure this memory is valid.
                // Return -1 if it is not.  Hint: Call user_mem_check.
                // LAB 3: Your code here.
                if( 0 > user_mem_check(curenv, usd, sizeof(usd), PTE_U) )
f010467f:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f0104686:	00 
f0104687:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
f010468e:	00 
f010468f:	c7 44 24 04 00 00 20 	movl   $0x200000,0x4(%esp)
f0104696:	00 
f0104697:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f010469c:	89 04 24             	mov    %eax,(%esp)
f010469f:	e8 bf c6 ff ff       	call   f0100d63 <user_mem_check>
f01046a4:	85 c0                	test   %eax,%eax
f01046a6:	0f 88 e2 01 00 00    	js     f010488e <debuginfo_eip+0x270>
                        return -1;

                stabs = usd->stabs;
f01046ac:	b8 00 00 20 00       	mov    $0x200000,%eax
f01046b1:	8b 10                	mov    (%eax),%edx
f01046b3:	89 55 c0             	mov    %edx,-0x40(%ebp)
                stab_end = usd->stab_end;
f01046b6:	8b 48 04             	mov    0x4(%eax),%ecx
f01046b9:	89 4d bc             	mov    %ecx,-0x44(%ebp)
                stabstr = usd->stabstr;
f01046bc:	8b 50 08             	mov    0x8(%eax),%edx
f01046bf:	89 55 c4             	mov    %edx,-0x3c(%ebp)
                stabstr_end = usd->stabstr_end;
f01046c2:	8b 78 0c             	mov    0xc(%eax),%edi

                // Make sure the STABS and string table memory is valid.
                // LAB 3: Your code here.

                if( 0 > user_mem_check(curenv, stabs, (stab_end - stabs)*(sizeof(struct Stab)), PTE_U) )
f01046c5:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f01046cc:	00 
f01046cd:	89 c8                	mov    %ecx,%eax
f01046cf:	2b 45 c0             	sub    -0x40(%ebp),%eax
f01046d2:	83 e0 fc             	and    $0xfffffffc,%eax
f01046d5:	89 44 24 08          	mov    %eax,0x8(%esp)
f01046d9:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f01046dc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f01046e0:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f01046e5:	89 04 24             	mov    %eax,(%esp)
f01046e8:	e8 76 c6 ff ff       	call   f0100d63 <user_mem_check>
f01046ed:	85 c0                	test   %eax,%eax
f01046ef:	0f 88 99 01 00 00    	js     f010488e <debuginfo_eip+0x270>
                        return -1;
                if( 0 > user_mem_check(curenv, stabstr, (stabstr_end - stabstr), PTE_U) )
f01046f5:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
f01046fc:	00 
f01046fd:	89 f8                	mov    %edi,%eax
f01046ff:	2b 45 c4             	sub    -0x3c(%ebp),%eax
f0104702:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104706:	8b 45 c4             	mov    -0x3c(%ebp),%eax
f0104709:	89 44 24 04          	mov    %eax,0x4(%esp)
f010470d:	a1 04 33 2d f0       	mov    0xf02d3304,%eax
f0104712:	89 04 24             	mov    %eax,(%esp)
f0104715:	e8 49 c6 ff ff       	call   f0100d63 <user_mem_check>
f010471a:	85 c0                	test   %eax,%eax
f010471c:	0f 88 6c 01 00 00    	js     f010488e <debuginfo_eip+0x270>
                        return -1;
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f0104722:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
f0104725:	0f 83 63 01 00 00    	jae    f010488e <debuginfo_eip+0x270>
f010472b:	80 7f ff 00          	cmpb   $0x0,-0x1(%edi)
f010472f:	90                   	nop
f0104730:	0f 85 58 01 00 00    	jne    f010488e <debuginfo_eip+0x270>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.
	
	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f0104736:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f010473d:	8b 45 bc             	mov    -0x44(%ebp),%eax
f0104740:	2b 45 c0             	sub    -0x40(%ebp),%eax
f0104743:	c1 f8 02             	sar    $0x2,%eax
f0104746:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
f010474c:	83 e8 01             	sub    $0x1,%eax
f010474f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f0104752:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0104755:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104758:	89 74 24 04          	mov    %esi,0x4(%esp)
f010475c:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f0104763:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0104766:	e8 85 fd ff ff       	call   f01044f0 <stab_binsearch>
	if (lfile == 0)
f010476b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010476e:	85 c0                	test   %eax,%eax
f0104770:	0f 84 18 01 00 00    	je     f010488e <debuginfo_eip+0x270>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f0104776:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0104779:	8b 45 e0             	mov    -0x20(%ebp),%eax
f010477c:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f010477f:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0104782:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0104785:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104789:	c7 04 24 24 00 00 00 	movl   $0x24,(%esp)
f0104790:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0104793:	e8 58 fd ff ff       	call   f01044f0 <stab_binsearch>

	if (lfun <= rfun) {
f0104798:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010479b:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f010479e:	7f 35                	jg     f01047d5 <debuginfo_eip+0x1b7>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f01047a0:	6b c0 0c             	imul   $0xc,%eax,%eax
f01047a3:	8b 55 c0             	mov    -0x40(%ebp),%edx
f01047a6:	8b 04 10             	mov    (%eax,%edx,1),%eax
f01047a9:	89 fa                	mov    %edi,%edx
f01047ab:	2b 55 c4             	sub    -0x3c(%ebp),%edx
f01047ae:	39 d0                	cmp    %edx,%eax
f01047b0:	73 06                	jae    f01047b8 <debuginfo_eip+0x19a>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f01047b2:	03 45 c4             	add    -0x3c(%ebp),%eax
f01047b5:	89 43 08             	mov    %eax,0x8(%ebx)
		info->eip_fn_addr = stabs[lfun].n_value;
f01047b8:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01047bb:	6b c2 0c             	imul   $0xc,%edx,%eax
f01047be:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f01047c1:	8b 44 08 08          	mov    0x8(%eax,%ecx,1),%eax
f01047c5:	89 43 10             	mov    %eax,0x10(%ebx)
		addr -= info->eip_fn_addr;
f01047c8:	29 c6                	sub    %eax,%esi
		// Search within the function definition for the line number.
		lline = lfun;
f01047ca:	89 55 d4             	mov    %edx,-0x2c(%ebp)
		rline = rfun;
f01047cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
f01047d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01047d3:	eb 0f                	jmp    f01047e4 <debuginfo_eip+0x1c6>
	} else {
		// Couldn't find function stab!  Maybe we're in an assembly
		// file.  Search the whole file for the line number.
		info->eip_fn_addr = addr;
f01047d5:	89 73 10             	mov    %esi,0x10(%ebx)
		lline = lfile;
f01047d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01047db:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f01047de:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01047e1:	89 45 d0             	mov    %eax,-0x30(%ebp)
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f01047e4:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
f01047eb:	00 
f01047ec:	8b 43 08             	mov    0x8(%ebx),%eax
f01047ef:	89 04 24             	mov    %eax,(%esp)
f01047f2:	e8 64 09 00 00       	call   f010515b <strfind>
f01047f7:	2b 43 08             	sub    0x8(%ebx),%eax
f01047fa:	89 43 0c             	mov    %eax,0xc(%ebx)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
     stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f01047fd:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0104800:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0104803:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104807:	c7 04 24 44 00 00 00 	movl   $0x44,(%esp)
f010480e:	8b 45 c0             	mov    -0x40(%ebp),%eax
f0104811:	e8 da fc ff ff       	call   f01044f0 <stab_binsearch>
        if( lline <= rline )
f0104816:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0104819:	3b 45 d0             	cmp    -0x30(%ebp),%eax
f010481c:	7f 70                	jg     f010488e <debuginfo_eip+0x270>
                info->eip_line = stabs[lline].n_desc;
f010481e:	6b c0 0c             	imul   $0xc,%eax,%eax
f0104821:	8b 55 c0             	mov    -0x40(%ebp),%edx
f0104824:	0f b7 44 10 06       	movzwl 0x6(%eax,%edx,1),%eax
f0104829:	89 43 04             	mov    %eax,0x4(%ebx)
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
f010482c:	8b 75 e4             	mov    -0x1c(%ebp),%esi
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f010482f:	eb 06                	jmp    f0104837 <debuginfo_eip+0x219>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
f0104831:	83 e8 01             	sub    $0x1,%eax
f0104834:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
f0104837:	8b 45 d4             	mov    -0x2c(%ebp),%eax
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f010483a:	39 f0                	cmp    %esi,%eax
f010483c:	7c 21                	jl     f010485f <debuginfo_eip+0x241>
	       && stabs[lline].n_type != N_SOL
f010483e:	6b d0 0c             	imul   $0xc,%eax,%edx
f0104841:	03 55 c0             	add    -0x40(%ebp),%edx
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0104844:	0f b6 4a 04          	movzbl 0x4(%edx),%ecx
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f0104848:	80 f9 84             	cmp    $0x84,%cl
f010484b:	74 5a                	je     f01048a7 <debuginfo_eip+0x289>
f010484d:	80 f9 64             	cmp    $0x64,%cl
f0104850:	75 df                	jne    f0104831 <debuginfo_eip+0x213>
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f0104852:	83 7a 08 00          	cmpl   $0x0,0x8(%edx)
f0104856:	74 d9                	je     f0104831 <debuginfo_eip+0x213>
f0104858:	eb 4d                	jmp    f01048a7 <debuginfo_eip+0x289>
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
		info->eip_file = stabstr + stabs[lline].n_strx;
f010485a:	03 45 c4             	add    -0x3c(%ebp),%eax
f010485d:	89 03                	mov    %eax,(%ebx)


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f010485f:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104862:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f0104865:	7d 2e                	jge    f0104895 <debuginfo_eip+0x277>
		for (lline = lfun + 1;
f0104867:	83 c0 01             	add    $0x1,%eax
f010486a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010486d:	eb 08                	jmp    f0104877 <debuginfo_eip+0x259>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f010486f:	83 43 14 01          	addl   $0x1,0x14(%ebx)
	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
f0104873:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)

	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f0104877:	8b 45 d4             	mov    -0x2c(%ebp),%eax


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
		for (lline = lfun + 1;
f010487a:	3b 45 d8             	cmp    -0x28(%ebp),%eax
f010487d:	7d 16                	jge    f0104895 <debuginfo_eip+0x277>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f010487f:	6b c0 0c             	imul   $0xc,%eax,%eax
f0104882:	8b 4d c0             	mov    -0x40(%ebp),%ecx
f0104885:	80 7c 08 04 a0       	cmpb   $0xa0,0x4(%eax,%ecx,1)
f010488a:	74 e3                	je     f010486f <debuginfo_eip+0x251>
f010488c:	eb 07                	jmp    f0104895 <debuginfo_eip+0x277>
f010488e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104893:	eb 05                	jmp    f010489a <debuginfo_eip+0x27c>
f0104895:	b8 00 00 00 00       	mov    $0x0,%eax
		     lline++)
			info->eip_fn_narg++;
	
	return 0;
}
f010489a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f010489d:	8b 75 f8             	mov    -0x8(%ebp),%esi
f01048a0:	8b 7d fc             	mov    -0x4(%ebp),%edi
f01048a3:	89 ec                	mov    %ebp,%esp
f01048a5:	5d                   	pop    %ebp
f01048a6:	c3                   	ret    
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
	       && stabs[lline].n_type != N_SOL
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
		lline--;
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f01048a7:	6b c0 0c             	imul   $0xc,%eax,%eax
f01048aa:	8b 55 c0             	mov    -0x40(%ebp),%edx
f01048ad:	8b 04 10             	mov    (%eax,%edx,1),%eax
f01048b0:	2b 7d c4             	sub    -0x3c(%ebp),%edi
f01048b3:	39 f8                	cmp    %edi,%eax
f01048b5:	72 a3                	jb     f010485a <debuginfo_eip+0x23c>
f01048b7:	eb a6                	jmp    f010485f <debuginfo_eip+0x241>
f01048b9:	00 00                	add    %al,(%eax)
f01048bb:	00 00                	add    %al,(%eax)
f01048bd:	00 00                	add    %al,(%eax)
	...

f01048c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f01048c0:	55                   	push   %ebp
f01048c1:	89 e5                	mov    %esp,%ebp
f01048c3:	57                   	push   %edi
f01048c4:	56                   	push   %esi
f01048c5:	53                   	push   %ebx
f01048c6:	83 ec 4c             	sub    $0x4c,%esp
f01048c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f01048cc:	89 d6                	mov    %edx,%esi
f01048ce:	8b 45 08             	mov    0x8(%ebp),%eax
f01048d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
f01048d4:	8b 55 0c             	mov    0xc(%ebp),%edx
f01048d7:	89 55 e0             	mov    %edx,-0x20(%ebp)
f01048da:	8b 45 10             	mov    0x10(%ebp),%eax
f01048dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
f01048e0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f01048e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
f01048e6:	b9 00 00 00 00       	mov    $0x0,%ecx
f01048eb:	39 d1                	cmp    %edx,%ecx
f01048ed:	72 15                	jb     f0104904 <printnum+0x44>
f01048ef:	77 07                	ja     f01048f8 <printnum+0x38>
f01048f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01048f4:	39 d0                	cmp    %edx,%eax
f01048f6:	76 0c                	jbe    f0104904 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f01048f8:	83 eb 01             	sub    $0x1,%ebx
f01048fb:	85 db                	test   %ebx,%ebx
f01048fd:	8d 76 00             	lea    0x0(%esi),%esi
f0104900:	7f 61                	jg     f0104963 <printnum+0xa3>
f0104902:	eb 70                	jmp    f0104974 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
f0104904:	89 7c 24 10          	mov    %edi,0x10(%esp)
f0104908:	83 eb 01             	sub    $0x1,%ebx
f010490b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010490f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104913:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f0104917:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
f010491b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f010491e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
f0104921:	8b 5d dc             	mov    -0x24(%ebp),%ebx
f0104924:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0104928:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f010492f:	00 
f0104930:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0104933:	89 04 24             	mov    %eax,(%esp)
f0104936:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104939:	89 54 24 04          	mov    %edx,0x4(%esp)
f010493d:	e8 ee 15 00 00       	call   f0105f30 <__udivdi3>
f0104942:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0104945:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0104948:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010494c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f0104950:	89 04 24             	mov    %eax,(%esp)
f0104953:	89 54 24 04          	mov    %edx,0x4(%esp)
f0104957:	89 f2                	mov    %esi,%edx
f0104959:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010495c:	e8 5f ff ff ff       	call   f01048c0 <printnum>
f0104961:	eb 11                	jmp    f0104974 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0104963:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104967:	89 3c 24             	mov    %edi,(%esp)
f010496a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f010496d:	83 eb 01             	sub    $0x1,%ebx
f0104970:	85 db                	test   %ebx,%ebx
f0104972:	7f ef                	jg     f0104963 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0104974:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104978:	8b 74 24 04          	mov    0x4(%esp),%esi
f010497c:	8b 45 dc             	mov    -0x24(%ebp),%eax
f010497f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104983:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f010498a:	00 
f010498b:	8b 55 d8             	mov    -0x28(%ebp),%edx
f010498e:	89 14 24             	mov    %edx,(%esp)
f0104991:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0104994:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0104998:	e8 c3 16 00 00       	call   f0106060 <__umoddi3>
f010499d:	89 74 24 04          	mov    %esi,0x4(%esp)
f01049a1:	0f be 80 3e 74 10 f0 	movsbl -0xfef8bc2(%eax),%eax
f01049a8:	89 04 24             	mov    %eax,(%esp)
f01049ab:	ff 55 e4             	call   *-0x1c(%ebp)
}
f01049ae:	83 c4 4c             	add    $0x4c,%esp
f01049b1:	5b                   	pop    %ebx
f01049b2:	5e                   	pop    %esi
f01049b3:	5f                   	pop    %edi
f01049b4:	5d                   	pop    %ebp
f01049b5:	c3                   	ret    

f01049b6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
f01049b6:	55                   	push   %ebp
f01049b7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
f01049b9:	83 fa 01             	cmp    $0x1,%edx
f01049bc:	7e 0e                	jle    f01049cc <getuint+0x16>
		return va_arg(*ap, unsigned long long);
f01049be:	8b 10                	mov    (%eax),%edx
f01049c0:	8d 4a 08             	lea    0x8(%edx),%ecx
f01049c3:	89 08                	mov    %ecx,(%eax)
f01049c5:	8b 02                	mov    (%edx),%eax
f01049c7:	8b 52 04             	mov    0x4(%edx),%edx
f01049ca:	eb 22                	jmp    f01049ee <getuint+0x38>
	else if (lflag)
f01049cc:	85 d2                	test   %edx,%edx
f01049ce:	74 10                	je     f01049e0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
f01049d0:	8b 10                	mov    (%eax),%edx
f01049d2:	8d 4a 04             	lea    0x4(%edx),%ecx
f01049d5:	89 08                	mov    %ecx,(%eax)
f01049d7:	8b 02                	mov    (%edx),%eax
f01049d9:	ba 00 00 00 00       	mov    $0x0,%edx
f01049de:	eb 0e                	jmp    f01049ee <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
f01049e0:	8b 10                	mov    (%eax),%edx
f01049e2:	8d 4a 04             	lea    0x4(%edx),%ecx
f01049e5:	89 08                	mov    %ecx,(%eax)
f01049e7:	8b 02                	mov    (%edx),%eax
f01049e9:	ba 00 00 00 00       	mov    $0x0,%edx
}
f01049ee:	5d                   	pop    %ebp
f01049ef:	c3                   	ret    

f01049f0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f01049f0:	55                   	push   %ebp
f01049f1:	89 e5                	mov    %esp,%ebp
f01049f3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f01049f6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f01049fa:	8b 10                	mov    (%eax),%edx
f01049fc:	3b 50 04             	cmp    0x4(%eax),%edx
f01049ff:	73 0a                	jae    f0104a0b <sprintputch+0x1b>
		*b->buf++ = ch;
f0104a01:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0104a04:	88 0a                	mov    %cl,(%edx)
f0104a06:	83 c2 01             	add    $0x1,%edx
f0104a09:	89 10                	mov    %edx,(%eax)
}
f0104a0b:	5d                   	pop    %ebp
f0104a0c:	c3                   	ret    

f0104a0d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f0104a0d:	55                   	push   %ebp
f0104a0e:	89 e5                	mov    %esp,%ebp
f0104a10:	57                   	push   %edi
f0104a11:	56                   	push   %esi
f0104a12:	53                   	push   %ebx
f0104a13:	83 ec 5c             	sub    $0x5c,%esp
f0104a16:	8b 7d 08             	mov    0x8(%ebp),%edi
f0104a19:	8b 75 0c             	mov    0xc(%ebp),%esi
f0104a1c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
f0104a1f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
f0104a26:	eb 11                	jmp    f0104a39 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
f0104a28:	85 c0                	test   %eax,%eax
f0104a2a:	0f 84 09 04 00 00    	je     f0104e39 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
f0104a30:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104a34:	89 04 24             	mov    %eax,(%esp)
f0104a37:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0104a39:	0f b6 03             	movzbl (%ebx),%eax
f0104a3c:	83 c3 01             	add    $0x1,%ebx
f0104a3f:	83 f8 25             	cmp    $0x25,%eax
f0104a42:	75 e4                	jne    f0104a28 <vprintfmt+0x1b>
f0104a44:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
f0104a48:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
f0104a4f:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
f0104a56:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
f0104a5d:	b9 00 00 00 00       	mov    $0x0,%ecx
f0104a62:	eb 06                	jmp    f0104a6a <vprintfmt+0x5d>
f0104a64:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
f0104a68:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0104a6a:	0f b6 13             	movzbl (%ebx),%edx
f0104a6d:	0f b6 c2             	movzbl %dl,%eax
f0104a70:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104a73:	8d 43 01             	lea    0x1(%ebx),%eax
f0104a76:	83 ea 23             	sub    $0x23,%edx
f0104a79:	80 fa 55             	cmp    $0x55,%dl
f0104a7c:	0f 87 9a 03 00 00    	ja     f0104e1c <vprintfmt+0x40f>
f0104a82:	0f b6 d2             	movzbl %dl,%edx
f0104a85:	ff 24 95 80 75 10 f0 	jmp    *-0xfef8a80(,%edx,4)
f0104a8c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
f0104a90:	eb d6                	jmp    f0104a68 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f0104a92:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104a95:	83 ea 30             	sub    $0x30,%edx
f0104a98:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
f0104a9b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
f0104a9e:	8d 5a d0             	lea    -0x30(%edx),%ebx
f0104aa1:	83 fb 09             	cmp    $0x9,%ebx
f0104aa4:	77 4c                	ja     f0104af2 <vprintfmt+0xe5>
f0104aa6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104aa9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f0104aac:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
f0104aaf:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
f0104ab2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
f0104ab6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
f0104ab9:	8d 5a d0             	lea    -0x30(%edx),%ebx
f0104abc:	83 fb 09             	cmp    $0x9,%ebx
f0104abf:	76 eb                	jbe    f0104aac <vprintfmt+0x9f>
f0104ac1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
f0104ac4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0104ac7:	eb 29                	jmp    f0104af2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f0104ac9:	8b 55 14             	mov    0x14(%ebp),%edx
f0104acc:	8d 5a 04             	lea    0x4(%edx),%ebx
f0104acf:	89 5d 14             	mov    %ebx,0x14(%ebp)
f0104ad2:	8b 12                	mov    (%edx),%edx
f0104ad4:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
f0104ad7:	eb 19                	jmp    f0104af2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
f0104ad9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104adc:	c1 fa 1f             	sar    $0x1f,%edx
f0104adf:	f7 d2                	not    %edx
f0104ae1:	21 55 e4             	and    %edx,-0x1c(%ebp)
f0104ae4:	eb 82                	jmp    f0104a68 <vprintfmt+0x5b>
f0104ae6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
f0104aed:	e9 76 ff ff ff       	jmp    f0104a68 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
f0104af2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0104af6:	0f 89 6c ff ff ff    	jns    f0104a68 <vprintfmt+0x5b>
f0104afc:	8b 55 cc             	mov    -0x34(%ebp),%edx
f0104aff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104b02:	8b 55 c8             	mov    -0x38(%ebp),%edx
f0104b05:	89 55 cc             	mov    %edx,-0x34(%ebp)
f0104b08:	e9 5b ff ff ff       	jmp    f0104a68 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f0104b0d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
f0104b10:	e9 53 ff ff ff       	jmp    f0104a68 <vprintfmt+0x5b>
f0104b15:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f0104b18:	8b 45 14             	mov    0x14(%ebp),%eax
f0104b1b:	8d 50 04             	lea    0x4(%eax),%edx
f0104b1e:	89 55 14             	mov    %edx,0x14(%ebp)
f0104b21:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104b25:	8b 00                	mov    (%eax),%eax
f0104b27:	89 04 24             	mov    %eax,(%esp)
f0104b2a:	ff d7                	call   *%edi
f0104b2c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
f0104b2f:	e9 05 ff ff ff       	jmp    f0104a39 <vprintfmt+0x2c>
f0104b34:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
f0104b37:	8b 45 14             	mov    0x14(%ebp),%eax
f0104b3a:	8d 50 04             	lea    0x4(%eax),%edx
f0104b3d:	89 55 14             	mov    %edx,0x14(%ebp)
f0104b40:	8b 00                	mov    (%eax),%eax
f0104b42:	89 c2                	mov    %eax,%edx
f0104b44:	c1 fa 1f             	sar    $0x1f,%edx
f0104b47:	31 d0                	xor    %edx,%eax
f0104b49:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
f0104b4b:	83 f8 0f             	cmp    $0xf,%eax
f0104b4e:	7f 0b                	jg     f0104b5b <vprintfmt+0x14e>
f0104b50:	8b 14 85 e0 76 10 f0 	mov    -0xfef8920(,%eax,4),%edx
f0104b57:	85 d2                	test   %edx,%edx
f0104b59:	75 20                	jne    f0104b7b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
f0104b5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104b5f:	c7 44 24 08 4f 74 10 	movl   $0xf010744f,0x8(%esp)
f0104b66:	f0 
f0104b67:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104b6b:	89 3c 24             	mov    %edi,(%esp)
f0104b6e:	e8 4e 03 00 00       	call   f0104ec1 <printfmt>
f0104b73:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
f0104b76:	e9 be fe ff ff       	jmp    f0104a39 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
f0104b7b:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0104b7f:	c7 44 24 08 b4 66 10 	movl   $0xf01066b4,0x8(%esp)
f0104b86:	f0 
f0104b87:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104b8b:	89 3c 24             	mov    %edi,(%esp)
f0104b8e:	e8 2e 03 00 00       	call   f0104ec1 <printfmt>
f0104b93:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0104b96:	e9 9e fe ff ff       	jmp    f0104a39 <vprintfmt+0x2c>
f0104b9b:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0104b9e:	89 c3                	mov    %eax,%ebx
f0104ba0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
f0104ba3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104ba6:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f0104ba9:	8b 45 14             	mov    0x14(%ebp),%eax
f0104bac:	8d 50 04             	lea    0x4(%eax),%edx
f0104baf:	89 55 14             	mov    %edx,0x14(%ebp)
f0104bb2:	8b 00                	mov    (%eax),%eax
f0104bb4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
f0104bb7:	85 c0                	test   %eax,%eax
f0104bb9:	75 07                	jne    f0104bc2 <vprintfmt+0x1b5>
f0104bbb:	c7 45 c4 58 74 10 f0 	movl   $0xf0107458,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
f0104bc2:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
f0104bc6:	7e 06                	jle    f0104bce <vprintfmt+0x1c1>
f0104bc8:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
f0104bcc:	75 13                	jne    f0104be1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0104bce:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0104bd1:	0f be 02             	movsbl (%edx),%eax
f0104bd4:	85 c0                	test   %eax,%eax
f0104bd6:	0f 85 99 00 00 00    	jne    f0104c75 <vprintfmt+0x268>
f0104bdc:	e9 86 00 00 00       	jmp    f0104c67 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0104be1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0104be5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
f0104be8:	89 0c 24             	mov    %ecx,(%esp)
f0104beb:	e8 0b 04 00 00       	call   f0104ffb <strnlen>
f0104bf0:	8b 55 c0             	mov    -0x40(%ebp),%edx
f0104bf3:	29 c2                	sub    %eax,%edx
f0104bf5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104bf8:	85 d2                	test   %edx,%edx
f0104bfa:	7e d2                	jle    f0104bce <vprintfmt+0x1c1>
					putch(padc, putdat);
f0104bfc:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
f0104c00:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f0104c03:	89 5d c0             	mov    %ebx,-0x40(%ebp)
f0104c06:	89 d3                	mov    %edx,%ebx
f0104c08:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104c0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104c0f:	89 04 24             	mov    %eax,(%esp)
f0104c12:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0104c14:	83 eb 01             	sub    $0x1,%ebx
f0104c17:	85 db                	test   %ebx,%ebx
f0104c19:	7f ed                	jg     f0104c08 <vprintfmt+0x1fb>
f0104c1b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
f0104c1e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
f0104c25:	eb a7                	jmp    f0104bce <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f0104c27:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
f0104c2b:	74 18                	je     f0104c45 <vprintfmt+0x238>
f0104c2d:	8d 50 e0             	lea    -0x20(%eax),%edx
f0104c30:	83 fa 5e             	cmp    $0x5e,%edx
f0104c33:	76 10                	jbe    f0104c45 <vprintfmt+0x238>
					putch('?', putdat);
f0104c35:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0104c39:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f0104c40:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f0104c43:	eb 0a                	jmp    f0104c4f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
f0104c45:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0104c49:	89 04 24             	mov    %eax,(%esp)
f0104c4c:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0104c4f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
f0104c53:	0f be 03             	movsbl (%ebx),%eax
f0104c56:	85 c0                	test   %eax,%eax
f0104c58:	74 05                	je     f0104c5f <vprintfmt+0x252>
f0104c5a:	83 c3 01             	add    $0x1,%ebx
f0104c5d:	eb 29                	jmp    f0104c88 <vprintfmt+0x27b>
f0104c5f:	89 fe                	mov    %edi,%esi
f0104c61:	8b 7d dc             	mov    -0x24(%ebp),%edi
f0104c64:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0104c67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0104c6b:	7f 2e                	jg     f0104c9b <vprintfmt+0x28e>
f0104c6d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0104c70:	e9 c4 fd ff ff       	jmp    f0104a39 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0104c75:	8b 55 c4             	mov    -0x3c(%ebp),%edx
f0104c78:	83 c2 01             	add    $0x1,%edx
f0104c7b:	89 7d dc             	mov    %edi,-0x24(%ebp)
f0104c7e:	89 f7                	mov    %esi,%edi
f0104c80:	8b 75 cc             	mov    -0x34(%ebp),%esi
f0104c83:	89 5d cc             	mov    %ebx,-0x34(%ebp)
f0104c86:	89 d3                	mov    %edx,%ebx
f0104c88:	85 f6                	test   %esi,%esi
f0104c8a:	78 9b                	js     f0104c27 <vprintfmt+0x21a>
f0104c8c:	83 ee 01             	sub    $0x1,%esi
f0104c8f:	79 96                	jns    f0104c27 <vprintfmt+0x21a>
f0104c91:	89 fe                	mov    %edi,%esi
f0104c93:	8b 7d dc             	mov    -0x24(%ebp),%edi
f0104c96:	8b 5d cc             	mov    -0x34(%ebp),%ebx
f0104c99:	eb cc                	jmp    f0104c67 <vprintfmt+0x25a>
f0104c9b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
f0104c9e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f0104ca1:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104ca5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0104cac:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0104cae:	83 eb 01             	sub    $0x1,%ebx
f0104cb1:	85 db                	test   %ebx,%ebx
f0104cb3:	7f ec                	jg     f0104ca1 <vprintfmt+0x294>
f0104cb5:	8b 5d d0             	mov    -0x30(%ebp),%ebx
f0104cb8:	e9 7c fd ff ff       	jmp    f0104a39 <vprintfmt+0x2c>
f0104cbd:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f0104cc0:	83 f9 01             	cmp    $0x1,%ecx
f0104cc3:	7e 16                	jle    f0104cdb <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
f0104cc5:	8b 45 14             	mov    0x14(%ebp),%eax
f0104cc8:	8d 50 08             	lea    0x8(%eax),%edx
f0104ccb:	89 55 14             	mov    %edx,0x14(%ebp)
f0104cce:	8b 10                	mov    (%eax),%edx
f0104cd0:	8b 48 04             	mov    0x4(%eax),%ecx
f0104cd3:	89 55 d0             	mov    %edx,-0x30(%ebp)
f0104cd6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0104cd9:	eb 32                	jmp    f0104d0d <vprintfmt+0x300>
	else if (lflag)
f0104cdb:	85 c9                	test   %ecx,%ecx
f0104cdd:	74 18                	je     f0104cf7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
f0104cdf:	8b 45 14             	mov    0x14(%ebp),%eax
f0104ce2:	8d 50 04             	lea    0x4(%eax),%edx
f0104ce5:	89 55 14             	mov    %edx,0x14(%ebp)
f0104ce8:	8b 00                	mov    (%eax),%eax
f0104cea:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104ced:	89 c1                	mov    %eax,%ecx
f0104cef:	c1 f9 1f             	sar    $0x1f,%ecx
f0104cf2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0104cf5:	eb 16                	jmp    f0104d0d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
f0104cf7:	8b 45 14             	mov    0x14(%ebp),%eax
f0104cfa:	8d 50 04             	lea    0x4(%eax),%edx
f0104cfd:	89 55 14             	mov    %edx,0x14(%ebp)
f0104d00:	8b 00                	mov    (%eax),%eax
f0104d02:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0104d05:	89 c2                	mov    %eax,%edx
f0104d07:	c1 fa 1f             	sar    $0x1f,%edx
f0104d0a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
f0104d0d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0104d10:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0104d13:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
f0104d18:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
f0104d1c:	0f 89 b8 00 00 00    	jns    f0104dda <vprintfmt+0x3cd>
				putch('-', putdat);
f0104d22:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104d26:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f0104d2d:	ff d7                	call   *%edi
				num = -(long long) num;
f0104d2f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
f0104d32:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
f0104d35:	f7 d9                	neg    %ecx
f0104d37:	83 d3 00             	adc    $0x0,%ebx
f0104d3a:	f7 db                	neg    %ebx
f0104d3c:	b8 0a 00 00 00       	mov    $0xa,%eax
f0104d41:	e9 94 00 00 00       	jmp    f0104dda <vprintfmt+0x3cd>
f0104d46:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f0104d49:	89 ca                	mov    %ecx,%edx
f0104d4b:	8d 45 14             	lea    0x14(%ebp),%eax
f0104d4e:	e8 63 fc ff ff       	call   f01049b6 <getuint>
f0104d53:	89 c1                	mov    %eax,%ecx
f0104d55:	89 d3                	mov    %edx,%ebx
f0104d57:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
f0104d5c:	eb 7c                	jmp    f0104dda <vprintfmt+0x3cd>
f0104d5e:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
f0104d61:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104d65:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
f0104d6c:	ff d7                	call   *%edi
			putch('X', putdat);
f0104d6e:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104d72:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
f0104d79:	ff d7                	call   *%edi
			putch('X', putdat);
f0104d7b:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104d7f:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
f0104d86:	ff d7                	call   *%edi
f0104d88:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
f0104d8b:	e9 a9 fc ff ff       	jmp    f0104a39 <vprintfmt+0x2c>
f0104d90:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
f0104d93:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104d97:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f0104d9e:	ff d7                	call   *%edi
			putch('x', putdat);
f0104da0:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104da4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f0104dab:	ff d7                	call   *%edi
			num = (unsigned long long)
f0104dad:	8b 45 14             	mov    0x14(%ebp),%eax
f0104db0:	8d 50 04             	lea    0x4(%eax),%edx
f0104db3:	89 55 14             	mov    %edx,0x14(%ebp)
f0104db6:	8b 08                	mov    (%eax),%ecx
f0104db8:	bb 00 00 00 00       	mov    $0x0,%ebx
f0104dbd:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
f0104dc2:	eb 16                	jmp    f0104dda <vprintfmt+0x3cd>
f0104dc4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
f0104dc7:	89 ca                	mov    %ecx,%edx
f0104dc9:	8d 45 14             	lea    0x14(%ebp),%eax
f0104dcc:	e8 e5 fb ff ff       	call   f01049b6 <getuint>
f0104dd1:	89 c1                	mov    %eax,%ecx
f0104dd3:	89 d3                	mov    %edx,%ebx
f0104dd5:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
f0104dda:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
f0104dde:	89 54 24 10          	mov    %edx,0x10(%esp)
f0104de2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104de5:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0104de9:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104ded:	89 0c 24             	mov    %ecx,(%esp)
f0104df0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0104df4:	89 f2                	mov    %esi,%edx
f0104df6:	89 f8                	mov    %edi,%eax
f0104df8:	e8 c3 fa ff ff       	call   f01048c0 <printnum>
f0104dfd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
f0104e00:	e9 34 fc ff ff       	jmp    f0104a39 <vprintfmt+0x2c>
f0104e05:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104e08:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f0104e0b:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104e0f:	89 14 24             	mov    %edx,(%esp)
f0104e12:	ff d7                	call   *%edi
f0104e14:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
f0104e17:	e9 1d fc ff ff       	jmp    f0104a39 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f0104e1c:	89 74 24 04          	mov    %esi,0x4(%esp)
f0104e20:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f0104e27:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
f0104e29:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0104e2c:	80 38 25             	cmpb   $0x25,(%eax)
f0104e2f:	0f 84 04 fc ff ff    	je     f0104a39 <vprintfmt+0x2c>
f0104e35:	89 c3                	mov    %eax,%ebx
f0104e37:	eb f0                	jmp    f0104e29 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
f0104e39:	83 c4 5c             	add    $0x5c,%esp
f0104e3c:	5b                   	pop    %ebx
f0104e3d:	5e                   	pop    %esi
f0104e3e:	5f                   	pop    %edi
f0104e3f:	5d                   	pop    %ebp
f0104e40:	c3                   	ret    

f0104e41 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0104e41:	55                   	push   %ebp
f0104e42:	89 e5                	mov    %esp,%ebp
f0104e44:	83 ec 28             	sub    $0x28,%esp
f0104e47:	8b 45 08             	mov    0x8(%ebp),%eax
f0104e4a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
f0104e4d:	85 c0                	test   %eax,%eax
f0104e4f:	74 04                	je     f0104e55 <vsnprintf+0x14>
f0104e51:	85 d2                	test   %edx,%edx
f0104e53:	7f 07                	jg     f0104e5c <vsnprintf+0x1b>
f0104e55:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104e5a:	eb 3b                	jmp    f0104e97 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
f0104e5c:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104e5f:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
f0104e63:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104e66:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0104e6d:	8b 45 14             	mov    0x14(%ebp),%eax
f0104e70:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104e74:	8b 45 10             	mov    0x10(%ebp),%eax
f0104e77:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104e7b:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0104e7e:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104e82:	c7 04 24 f0 49 10 f0 	movl   $0xf01049f0,(%esp)
f0104e89:	e8 7f fb ff ff       	call   f0104a0d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0104e8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0104e91:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0104e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
f0104e97:	c9                   	leave  
f0104e98:	c3                   	ret    

f0104e99 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0104e99:	55                   	push   %ebp
f0104e9a:	89 e5                	mov    %esp,%ebp
f0104e9c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
f0104e9f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
f0104ea2:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104ea6:	8b 45 10             	mov    0x10(%ebp),%eax
f0104ea9:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104ead:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104eb0:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104eb4:	8b 45 08             	mov    0x8(%ebp),%eax
f0104eb7:	89 04 24             	mov    %eax,(%esp)
f0104eba:	e8 82 ff ff ff       	call   f0104e41 <vsnprintf>
	va_end(ap);

	return rc;
}
f0104ebf:	c9                   	leave  
f0104ec0:	c3                   	ret    

f0104ec1 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f0104ec1:	55                   	push   %ebp
f0104ec2:	89 e5                	mov    %esp,%ebp
f0104ec4:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
f0104ec7:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
f0104eca:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0104ece:	8b 45 10             	mov    0x10(%ebp),%eax
f0104ed1:	89 44 24 08          	mov    %eax,0x8(%esp)
f0104ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104ed8:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104edc:	8b 45 08             	mov    0x8(%ebp),%eax
f0104edf:	89 04 24             	mov    %eax,(%esp)
f0104ee2:	e8 26 fb ff ff       	call   f0104a0d <vprintfmt>
	va_end(ap);
}
f0104ee7:	c9                   	leave  
f0104ee8:	c3                   	ret    
f0104ee9:	00 00                	add    %al,(%eax)
f0104eeb:	00 00                	add    %al,(%eax)
f0104eed:	00 00                	add    %al,(%eax)
	...

f0104ef0 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0104ef0:	55                   	push   %ebp
f0104ef1:	89 e5                	mov    %esp,%ebp
f0104ef3:	57                   	push   %edi
f0104ef4:	56                   	push   %esi
f0104ef5:	53                   	push   %ebx
f0104ef6:	83 ec 1c             	sub    $0x1c,%esp
f0104ef9:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0104efc:	85 c0                	test   %eax,%eax
f0104efe:	74 10                	je     f0104f10 <readline+0x20>
		cprintf("%s", prompt);
f0104f00:	89 44 24 04          	mov    %eax,0x4(%esp)
f0104f04:	c7 04 24 b4 66 10 f0 	movl   $0xf01066b4,(%esp)
f0104f0b:	e8 af e4 ff ff       	call   f01033bf <cprintf>
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f0104f10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0104f17:	e8 6a b3 ff ff       	call   f0100286 <iscons>
f0104f1c:	89 c7                	mov    %eax,%edi
f0104f1e:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		c = getchar();
f0104f23:	e8 4d b3 ff ff       	call   f0100275 <getchar>
f0104f28:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f0104f2a:	85 c0                	test   %eax,%eax
f0104f2c:	79 25                	jns    f0104f53 <readline+0x63>
			if (c != -E_EOF)
f0104f2e:	b8 00 00 00 00       	mov    $0x0,%eax
f0104f33:	83 fb f8             	cmp    $0xfffffff8,%ebx
f0104f36:	0f 84 96 00 00 00    	je     f0104fd2 <readline+0xe2>
				cprintf("read error: %e\n", c);
f0104f3c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f0104f40:	c7 04 24 3f 77 10 f0 	movl   $0xf010773f,(%esp)
f0104f47:	e8 73 e4 ff ff       	call   f01033bf <cprintf>
f0104f4c:	b8 00 00 00 00       	mov    $0x0,%eax
f0104f51:	eb 7f                	jmp    f0104fd2 <readline+0xe2>
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0104f53:	83 f8 08             	cmp    $0x8,%eax
f0104f56:	74 0a                	je     f0104f62 <readline+0x72>
f0104f58:	83 f8 7f             	cmp    $0x7f,%eax
f0104f5b:	90                   	nop
f0104f5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0104f60:	75 19                	jne    f0104f7b <readline+0x8b>
f0104f62:	85 f6                	test   %esi,%esi
f0104f64:	7e 15                	jle    f0104f7b <readline+0x8b>
			if (echoing)
f0104f66:	85 ff                	test   %edi,%edi
f0104f68:	74 0c                	je     f0104f76 <readline+0x86>
				cputchar('\b');
f0104f6a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
f0104f71:	e8 14 b5 ff ff       	call   f010048a <cputchar>
			i--;
f0104f76:	83 ee 01             	sub    $0x1,%esi
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0104f79:	eb a8                	jmp    f0104f23 <readline+0x33>
			if (echoing)
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
f0104f7b:	83 fb 1f             	cmp    $0x1f,%ebx
f0104f7e:	66 90                	xchg   %ax,%ax
f0104f80:	7e 26                	jle    f0104fa8 <readline+0xb8>
f0104f82:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0104f88:	7f 1e                	jg     f0104fa8 <readline+0xb8>
			if (echoing)
f0104f8a:	85 ff                	test   %edi,%edi
f0104f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0104f90:	74 08                	je     f0104f9a <readline+0xaa>
				cputchar(c);
f0104f92:	89 1c 24             	mov    %ebx,(%esp)
f0104f95:	e8 f0 b4 ff ff       	call   f010048a <cputchar>
			buf[i++] = c;
f0104f9a:	88 9e a0 3b 2d f0    	mov    %bl,-0xfd2c460(%esi)
f0104fa0:	83 c6 01             	add    $0x1,%esi
f0104fa3:	e9 7b ff ff ff       	jmp    f0104f23 <readline+0x33>
		} else if (c == '\n' || c == '\r') {
f0104fa8:	83 fb 0a             	cmp    $0xa,%ebx
f0104fab:	74 09                	je     f0104fb6 <readline+0xc6>
f0104fad:	83 fb 0d             	cmp    $0xd,%ebx
f0104fb0:	0f 85 6d ff ff ff    	jne    f0104f23 <readline+0x33>
			if (echoing)
f0104fb6:	85 ff                	test   %edi,%edi
f0104fb8:	74 0c                	je     f0104fc6 <readline+0xd6>
				cputchar('\n');
f0104fba:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
f0104fc1:	e8 c4 b4 ff ff       	call   f010048a <cputchar>
			buf[i] = 0;
f0104fc6:	c6 86 a0 3b 2d f0 00 	movb   $0x0,-0xfd2c460(%esi)
f0104fcd:	b8 a0 3b 2d f0       	mov    $0xf02d3ba0,%eax
			return buf;
		}
	}
}
f0104fd2:	83 c4 1c             	add    $0x1c,%esp
f0104fd5:	5b                   	pop    %ebx
f0104fd6:	5e                   	pop    %esi
f0104fd7:	5f                   	pop    %edi
f0104fd8:	5d                   	pop    %ebp
f0104fd9:	c3                   	ret    
f0104fda:	00 00                	add    %al,(%eax)
f0104fdc:	00 00                	add    %al,(%eax)
	...

f0104fe0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0104fe0:	55                   	push   %ebp
f0104fe1:	89 e5                	mov    %esp,%ebp
f0104fe3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0104fe6:	b8 00 00 00 00       	mov    $0x0,%eax
f0104feb:	80 3a 00             	cmpb   $0x0,(%edx)
f0104fee:	74 09                	je     f0104ff9 <strlen+0x19>
		n++;
f0104ff0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f0104ff3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0104ff7:	75 f7                	jne    f0104ff0 <strlen+0x10>
		n++;
	return n;
}
f0104ff9:	5d                   	pop    %ebp
f0104ffa:	c3                   	ret    

f0104ffb <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0104ffb:	55                   	push   %ebp
f0104ffc:	89 e5                	mov    %esp,%ebp
f0104ffe:	53                   	push   %ebx
f0104fff:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0105002:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105005:	85 c9                	test   %ecx,%ecx
f0105007:	74 19                	je     f0105022 <strnlen+0x27>
f0105009:	80 3b 00             	cmpb   $0x0,(%ebx)
f010500c:	74 14                	je     f0105022 <strnlen+0x27>
f010500e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
f0105013:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105016:	39 c8                	cmp    %ecx,%eax
f0105018:	74 0d                	je     f0105027 <strnlen+0x2c>
f010501a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
f010501e:	75 f3                	jne    f0105013 <strnlen+0x18>
f0105020:	eb 05                	jmp    f0105027 <strnlen+0x2c>
f0105022:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
f0105027:	5b                   	pop    %ebx
f0105028:	5d                   	pop    %ebp
f0105029:	c3                   	ret    

f010502a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f010502a:	55                   	push   %ebp
f010502b:	89 e5                	mov    %esp,%ebp
f010502d:	53                   	push   %ebx
f010502e:	8b 45 08             	mov    0x8(%ebp),%eax
f0105031:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105034:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0105039:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f010503d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0105040:	83 c2 01             	add    $0x1,%edx
f0105043:	84 c9                	test   %cl,%cl
f0105045:	75 f2                	jne    f0105039 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
f0105047:	5b                   	pop    %ebx
f0105048:	5d                   	pop    %ebp
f0105049:	c3                   	ret    

f010504a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f010504a:	55                   	push   %ebp
f010504b:	89 e5                	mov    %esp,%ebp
f010504d:	56                   	push   %esi
f010504e:	53                   	push   %ebx
f010504f:	8b 45 08             	mov    0x8(%ebp),%eax
f0105052:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105055:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0105058:	85 f6                	test   %esi,%esi
f010505a:	74 18                	je     f0105074 <strncpy+0x2a>
f010505c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
f0105061:	0f b6 1a             	movzbl (%edx),%ebx
f0105064:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0105067:	80 3a 01             	cmpb   $0x1,(%edx)
f010506a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f010506d:	83 c1 01             	add    $0x1,%ecx
f0105070:	39 ce                	cmp    %ecx,%esi
f0105072:	77 ed                	ja     f0105061 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f0105074:	5b                   	pop    %ebx
f0105075:	5e                   	pop    %esi
f0105076:	5d                   	pop    %ebp
f0105077:	c3                   	ret    

f0105078 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0105078:	55                   	push   %ebp
f0105079:	89 e5                	mov    %esp,%ebp
f010507b:	56                   	push   %esi
f010507c:	53                   	push   %ebx
f010507d:	8b 75 08             	mov    0x8(%ebp),%esi
f0105080:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105083:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0105086:	89 f0                	mov    %esi,%eax
f0105088:	85 c9                	test   %ecx,%ecx
f010508a:	74 27                	je     f01050b3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
f010508c:	83 e9 01             	sub    $0x1,%ecx
f010508f:	74 1d                	je     f01050ae <strlcpy+0x36>
f0105091:	0f b6 1a             	movzbl (%edx),%ebx
f0105094:	84 db                	test   %bl,%bl
f0105096:	74 16                	je     f01050ae <strlcpy+0x36>
			*dst++ = *src++;
f0105098:	88 18                	mov    %bl,(%eax)
f010509a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f010509d:	83 e9 01             	sub    $0x1,%ecx
f01050a0:	74 0e                	je     f01050b0 <strlcpy+0x38>
			*dst++ = *src++;
f01050a2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f01050a5:	0f b6 1a             	movzbl (%edx),%ebx
f01050a8:	84 db                	test   %bl,%bl
f01050aa:	75 ec                	jne    f0105098 <strlcpy+0x20>
f01050ac:	eb 02                	jmp    f01050b0 <strlcpy+0x38>
f01050ae:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
f01050b0:	c6 00 00             	movb   $0x0,(%eax)
f01050b3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
f01050b5:	5b                   	pop    %ebx
f01050b6:	5e                   	pop    %esi
f01050b7:	5d                   	pop    %ebp
f01050b8:	c3                   	ret    

f01050b9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01050b9:	55                   	push   %ebp
f01050ba:	89 e5                	mov    %esp,%ebp
f01050bc:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01050bf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f01050c2:	0f b6 01             	movzbl (%ecx),%eax
f01050c5:	84 c0                	test   %al,%al
f01050c7:	74 15                	je     f01050de <strcmp+0x25>
f01050c9:	3a 02                	cmp    (%edx),%al
f01050cb:	75 11                	jne    f01050de <strcmp+0x25>
		p++, q++;
f01050cd:	83 c1 01             	add    $0x1,%ecx
f01050d0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f01050d3:	0f b6 01             	movzbl (%ecx),%eax
f01050d6:	84 c0                	test   %al,%al
f01050d8:	74 04                	je     f01050de <strcmp+0x25>
f01050da:	3a 02                	cmp    (%edx),%al
f01050dc:	74 ef                	je     f01050cd <strcmp+0x14>
f01050de:	0f b6 c0             	movzbl %al,%eax
f01050e1:	0f b6 12             	movzbl (%edx),%edx
f01050e4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
f01050e6:	5d                   	pop    %ebp
f01050e7:	c3                   	ret    

f01050e8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f01050e8:	55                   	push   %ebp
f01050e9:	89 e5                	mov    %esp,%ebp
f01050eb:	53                   	push   %ebx
f01050ec:	8b 55 08             	mov    0x8(%ebp),%edx
f01050ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01050f2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
f01050f5:	85 c0                	test   %eax,%eax
f01050f7:	74 23                	je     f010511c <strncmp+0x34>
f01050f9:	0f b6 1a             	movzbl (%edx),%ebx
f01050fc:	84 db                	test   %bl,%bl
f01050fe:	74 24                	je     f0105124 <strncmp+0x3c>
f0105100:	3a 19                	cmp    (%ecx),%bl
f0105102:	75 20                	jne    f0105124 <strncmp+0x3c>
f0105104:	83 e8 01             	sub    $0x1,%eax
f0105107:	74 13                	je     f010511c <strncmp+0x34>
		n--, p++, q++;
f0105109:	83 c2 01             	add    $0x1,%edx
f010510c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f010510f:	0f b6 1a             	movzbl (%edx),%ebx
f0105112:	84 db                	test   %bl,%bl
f0105114:	74 0e                	je     f0105124 <strncmp+0x3c>
f0105116:	3a 19                	cmp    (%ecx),%bl
f0105118:	74 ea                	je     f0105104 <strncmp+0x1c>
f010511a:	eb 08                	jmp    f0105124 <strncmp+0x3c>
f010511c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
f0105121:	5b                   	pop    %ebx
f0105122:	5d                   	pop    %ebp
f0105123:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105124:	0f b6 02             	movzbl (%edx),%eax
f0105127:	0f b6 11             	movzbl (%ecx),%edx
f010512a:	29 d0                	sub    %edx,%eax
f010512c:	eb f3                	jmp    f0105121 <strncmp+0x39>

f010512e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f010512e:	55                   	push   %ebp
f010512f:	89 e5                	mov    %esp,%ebp
f0105131:	8b 45 08             	mov    0x8(%ebp),%eax
f0105134:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105138:	0f b6 10             	movzbl (%eax),%edx
f010513b:	84 d2                	test   %dl,%dl
f010513d:	74 15                	je     f0105154 <strchr+0x26>
		if (*s == c)
f010513f:	38 ca                	cmp    %cl,%dl
f0105141:	75 07                	jne    f010514a <strchr+0x1c>
f0105143:	eb 14                	jmp    f0105159 <strchr+0x2b>
f0105145:	38 ca                	cmp    %cl,%dl
f0105147:	90                   	nop
f0105148:	74 0f                	je     f0105159 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f010514a:	83 c0 01             	add    $0x1,%eax
f010514d:	0f b6 10             	movzbl (%eax),%edx
f0105150:	84 d2                	test   %dl,%dl
f0105152:	75 f1                	jne    f0105145 <strchr+0x17>
f0105154:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
f0105159:	5d                   	pop    %ebp
f010515a:	c3                   	ret    

f010515b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f010515b:	55                   	push   %ebp
f010515c:	89 e5                	mov    %esp,%ebp
f010515e:	8b 45 08             	mov    0x8(%ebp),%eax
f0105161:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
f0105165:	0f b6 10             	movzbl (%eax),%edx
f0105168:	84 d2                	test   %dl,%dl
f010516a:	74 18                	je     f0105184 <strfind+0x29>
		if (*s == c)
f010516c:	38 ca                	cmp    %cl,%dl
f010516e:	75 0a                	jne    f010517a <strfind+0x1f>
f0105170:	eb 12                	jmp    f0105184 <strfind+0x29>
f0105172:	38 ca                	cmp    %cl,%dl
f0105174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0105178:	74 0a                	je     f0105184 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f010517a:	83 c0 01             	add    $0x1,%eax
f010517d:	0f b6 10             	movzbl (%eax),%edx
f0105180:	84 d2                	test   %dl,%dl
f0105182:	75 ee                	jne    f0105172 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
f0105184:	5d                   	pop    %ebp
f0105185:	c3                   	ret    

f0105186 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0105186:	55                   	push   %ebp
f0105187:	89 e5                	mov    %esp,%ebp
f0105189:	83 ec 0c             	sub    $0xc,%esp
f010518c:	89 1c 24             	mov    %ebx,(%esp)
f010518f:	89 74 24 04          	mov    %esi,0x4(%esp)
f0105193:	89 7c 24 08          	mov    %edi,0x8(%esp)
f0105197:	8b 7d 08             	mov    0x8(%ebp),%edi
f010519a:	8b 45 0c             	mov    0xc(%ebp),%eax
f010519d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f01051a0:	85 c9                	test   %ecx,%ecx
f01051a2:	74 30                	je     f01051d4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01051a4:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01051aa:	75 25                	jne    f01051d1 <memset+0x4b>
f01051ac:	f6 c1 03             	test   $0x3,%cl
f01051af:	75 20                	jne    f01051d1 <memset+0x4b>
		c &= 0xFF;
f01051b1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01051b4:	89 d3                	mov    %edx,%ebx
f01051b6:	c1 e3 08             	shl    $0x8,%ebx
f01051b9:	89 d6                	mov    %edx,%esi
f01051bb:	c1 e6 18             	shl    $0x18,%esi
f01051be:	89 d0                	mov    %edx,%eax
f01051c0:	c1 e0 10             	shl    $0x10,%eax
f01051c3:	09 f0                	or     %esi,%eax
f01051c5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
f01051c7:	09 d8                	or     %ebx,%eax
f01051c9:	c1 e9 02             	shr    $0x2,%ecx
f01051cc:	fc                   	cld    
f01051cd:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01051cf:	eb 03                	jmp    f01051d4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f01051d1:	fc                   	cld    
f01051d2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f01051d4:	89 f8                	mov    %edi,%eax
f01051d6:	8b 1c 24             	mov    (%esp),%ebx
f01051d9:	8b 74 24 04          	mov    0x4(%esp),%esi
f01051dd:	8b 7c 24 08          	mov    0x8(%esp),%edi
f01051e1:	89 ec                	mov    %ebp,%esp
f01051e3:	5d                   	pop    %ebp
f01051e4:	c3                   	ret    

f01051e5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f01051e5:	55                   	push   %ebp
f01051e6:	89 e5                	mov    %esp,%ebp
f01051e8:	83 ec 08             	sub    $0x8,%esp
f01051eb:	89 34 24             	mov    %esi,(%esp)
f01051ee:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01051f2:	8b 45 08             	mov    0x8(%ebp),%eax
f01051f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
f01051f8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
f01051fb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
f01051fd:	39 c6                	cmp    %eax,%esi
f01051ff:	73 35                	jae    f0105236 <memmove+0x51>
f0105201:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0105204:	39 d0                	cmp    %edx,%eax
f0105206:	73 2e                	jae    f0105236 <memmove+0x51>
		s += n;
		d += n;
f0105208:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010520a:	f6 c2 03             	test   $0x3,%dl
f010520d:	75 1b                	jne    f010522a <memmove+0x45>
f010520f:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0105215:	75 13                	jne    f010522a <memmove+0x45>
f0105217:	f6 c1 03             	test   $0x3,%cl
f010521a:	75 0e                	jne    f010522a <memmove+0x45>
			asm volatile("std; rep movsl\n"
f010521c:	83 ef 04             	sub    $0x4,%edi
f010521f:	8d 72 fc             	lea    -0x4(%edx),%esi
f0105222:	c1 e9 02             	shr    $0x2,%ecx
f0105225:	fd                   	std    
f0105226:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105228:	eb 09                	jmp    f0105233 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f010522a:	83 ef 01             	sub    $0x1,%edi
f010522d:	8d 72 ff             	lea    -0x1(%edx),%esi
f0105230:	fd                   	std    
f0105231:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0105233:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0105234:	eb 20                	jmp    f0105256 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105236:	f7 c6 03 00 00 00    	test   $0x3,%esi
f010523c:	75 15                	jne    f0105253 <memmove+0x6e>
f010523e:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0105244:	75 0d                	jne    f0105253 <memmove+0x6e>
f0105246:	f6 c1 03             	test   $0x3,%cl
f0105249:	75 08                	jne    f0105253 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
f010524b:	c1 e9 02             	shr    $0x2,%ecx
f010524e:	fc                   	cld    
f010524f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105251:	eb 03                	jmp    f0105256 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0105253:	fc                   	cld    
f0105254:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0105256:	8b 34 24             	mov    (%esp),%esi
f0105259:	8b 7c 24 04          	mov    0x4(%esp),%edi
f010525d:	89 ec                	mov    %ebp,%esp
f010525f:	5d                   	pop    %ebp
f0105260:	c3                   	ret    

f0105261 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
f0105261:	55                   	push   %ebp
f0105262:	89 e5                	mov    %esp,%ebp
f0105264:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f0105267:	8b 45 10             	mov    0x10(%ebp),%eax
f010526a:	89 44 24 08          	mov    %eax,0x8(%esp)
f010526e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105271:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105275:	8b 45 08             	mov    0x8(%ebp),%eax
f0105278:	89 04 24             	mov    %eax,(%esp)
f010527b:	e8 65 ff ff ff       	call   f01051e5 <memmove>
}
f0105280:	c9                   	leave  
f0105281:	c3                   	ret    

f0105282 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0105282:	55                   	push   %ebp
f0105283:	89 e5                	mov    %esp,%ebp
f0105285:	57                   	push   %edi
f0105286:	56                   	push   %esi
f0105287:	53                   	push   %ebx
f0105288:	8b 75 08             	mov    0x8(%ebp),%esi
f010528b:	8b 7d 0c             	mov    0xc(%ebp),%edi
f010528e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f0105291:	85 c9                	test   %ecx,%ecx
f0105293:	74 36                	je     f01052cb <memcmp+0x49>
		if (*s1 != *s2)
f0105295:	0f b6 06             	movzbl (%esi),%eax
f0105298:	0f b6 1f             	movzbl (%edi),%ebx
f010529b:	38 d8                	cmp    %bl,%al
f010529d:	74 20                	je     f01052bf <memcmp+0x3d>
f010529f:	eb 14                	jmp    f01052b5 <memcmp+0x33>
f01052a1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
f01052a6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
f01052ab:	83 c2 01             	add    $0x1,%edx
f01052ae:	83 e9 01             	sub    $0x1,%ecx
f01052b1:	38 d8                	cmp    %bl,%al
f01052b3:	74 12                	je     f01052c7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
f01052b5:	0f b6 c0             	movzbl %al,%eax
f01052b8:	0f b6 db             	movzbl %bl,%ebx
f01052bb:	29 d8                	sub    %ebx,%eax
f01052bd:	eb 11                	jmp    f01052d0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01052bf:	83 e9 01             	sub    $0x1,%ecx
f01052c2:	ba 00 00 00 00       	mov    $0x0,%edx
f01052c7:	85 c9                	test   %ecx,%ecx
f01052c9:	75 d6                	jne    f01052a1 <memcmp+0x1f>
f01052cb:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
f01052d0:	5b                   	pop    %ebx
f01052d1:	5e                   	pop    %esi
f01052d2:	5f                   	pop    %edi
f01052d3:	5d                   	pop    %ebp
f01052d4:	c3                   	ret    

f01052d5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f01052d5:	55                   	push   %ebp
f01052d6:	89 e5                	mov    %esp,%ebp
f01052d8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
f01052db:	89 c2                	mov    %eax,%edx
f01052dd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f01052e0:	39 d0                	cmp    %edx,%eax
f01052e2:	73 15                	jae    f01052f9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
f01052e4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
f01052e8:	38 08                	cmp    %cl,(%eax)
f01052ea:	75 06                	jne    f01052f2 <memfind+0x1d>
f01052ec:	eb 0b                	jmp    f01052f9 <memfind+0x24>
f01052ee:	38 08                	cmp    %cl,(%eax)
f01052f0:	74 07                	je     f01052f9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f01052f2:	83 c0 01             	add    $0x1,%eax
f01052f5:	39 c2                	cmp    %eax,%edx
f01052f7:	77 f5                	ja     f01052ee <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f01052f9:	5d                   	pop    %ebp
f01052fa:	c3                   	ret    

f01052fb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f01052fb:	55                   	push   %ebp
f01052fc:	89 e5                	mov    %esp,%ebp
f01052fe:	57                   	push   %edi
f01052ff:	56                   	push   %esi
f0105300:	53                   	push   %ebx
f0105301:	83 ec 04             	sub    $0x4,%esp
f0105304:	8b 55 08             	mov    0x8(%ebp),%edx
f0105307:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f010530a:	0f b6 02             	movzbl (%edx),%eax
f010530d:	3c 20                	cmp    $0x20,%al
f010530f:	74 04                	je     f0105315 <strtol+0x1a>
f0105311:	3c 09                	cmp    $0x9,%al
f0105313:	75 0e                	jne    f0105323 <strtol+0x28>
		s++;
f0105315:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0105318:	0f b6 02             	movzbl (%edx),%eax
f010531b:	3c 20                	cmp    $0x20,%al
f010531d:	74 f6                	je     f0105315 <strtol+0x1a>
f010531f:	3c 09                	cmp    $0x9,%al
f0105321:	74 f2                	je     f0105315 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
f0105323:	3c 2b                	cmp    $0x2b,%al
f0105325:	75 0c                	jne    f0105333 <strtol+0x38>
		s++;
f0105327:	83 c2 01             	add    $0x1,%edx
f010532a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0105331:	eb 15                	jmp    f0105348 <strtol+0x4d>
	else if (*s == '-')
f0105333:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f010533a:	3c 2d                	cmp    $0x2d,%al
f010533c:	75 0a                	jne    f0105348 <strtol+0x4d>
		s++, neg = 1;
f010533e:	83 c2 01             	add    $0x1,%edx
f0105341:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105348:	85 db                	test   %ebx,%ebx
f010534a:	0f 94 c0             	sete   %al
f010534d:	74 05                	je     f0105354 <strtol+0x59>
f010534f:	83 fb 10             	cmp    $0x10,%ebx
f0105352:	75 18                	jne    f010536c <strtol+0x71>
f0105354:	80 3a 30             	cmpb   $0x30,(%edx)
f0105357:	75 13                	jne    f010536c <strtol+0x71>
f0105359:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f010535d:	8d 76 00             	lea    0x0(%esi),%esi
f0105360:	75 0a                	jne    f010536c <strtol+0x71>
		s += 2, base = 16;
f0105362:	83 c2 02             	add    $0x2,%edx
f0105365:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f010536a:	eb 15                	jmp    f0105381 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f010536c:	84 c0                	test   %al,%al
f010536e:	66 90                	xchg   %ax,%ax
f0105370:	74 0f                	je     f0105381 <strtol+0x86>
f0105372:	bb 0a 00 00 00       	mov    $0xa,%ebx
f0105377:	80 3a 30             	cmpb   $0x30,(%edx)
f010537a:	75 05                	jne    f0105381 <strtol+0x86>
		s++, base = 8;
f010537c:	83 c2 01             	add    $0x1,%edx
f010537f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0105381:	b8 00 00 00 00       	mov    $0x0,%eax
f0105386:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f0105388:	0f b6 0a             	movzbl (%edx),%ecx
f010538b:	89 cf                	mov    %ecx,%edi
f010538d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
f0105390:	80 fb 09             	cmp    $0x9,%bl
f0105393:	77 08                	ja     f010539d <strtol+0xa2>
			dig = *s - '0';
f0105395:	0f be c9             	movsbl %cl,%ecx
f0105398:	83 e9 30             	sub    $0x30,%ecx
f010539b:	eb 1e                	jmp    f01053bb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
f010539d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
f01053a0:	80 fb 19             	cmp    $0x19,%bl
f01053a3:	77 08                	ja     f01053ad <strtol+0xb2>
			dig = *s - 'a' + 10;
f01053a5:	0f be c9             	movsbl %cl,%ecx
f01053a8:	83 e9 57             	sub    $0x57,%ecx
f01053ab:	eb 0e                	jmp    f01053bb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
f01053ad:	8d 5f bf             	lea    -0x41(%edi),%ebx
f01053b0:	80 fb 19             	cmp    $0x19,%bl
f01053b3:	77 15                	ja     f01053ca <strtol+0xcf>
			dig = *s - 'A' + 10;
f01053b5:	0f be c9             	movsbl %cl,%ecx
f01053b8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f01053bb:	39 f1                	cmp    %esi,%ecx
f01053bd:	7d 0b                	jge    f01053ca <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
f01053bf:	83 c2 01             	add    $0x1,%edx
f01053c2:	0f af c6             	imul   %esi,%eax
f01053c5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
f01053c8:	eb be                	jmp    f0105388 <strtol+0x8d>
f01053ca:	89 c1                	mov    %eax,%ecx

	if (endptr)
f01053cc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f01053d0:	74 05                	je     f01053d7 <strtol+0xdc>
		*endptr = (char *) s;
f01053d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f01053d5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
f01053d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
f01053db:	74 04                	je     f01053e1 <strtol+0xe6>
f01053dd:	89 c8                	mov    %ecx,%eax
f01053df:	f7 d8                	neg    %eax
}
f01053e1:	83 c4 04             	add    $0x4,%esp
f01053e4:	5b                   	pop    %ebx
f01053e5:	5e                   	pop    %esi
f01053e6:	5f                   	pop    %edi
f01053e7:	5d                   	pop    %ebp
f01053e8:	c3                   	ret    
f01053e9:	00 00                	add    %al,(%eax)
f01053eb:	00 00                	add    %al,(%eax)
f01053ed:	00 00                	add    %al,(%eax)
	...

f01053f0 <delay>:
DMASendRing *sendHeader=sendDmaList;
DMAReceiveRing *currentRFD=receiveDmaList;

 void
delay(void)
{
f01053f0:	55                   	push   %ebp
f01053f1:	89 e5                	mov    %esp,%ebp

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01053f3:	ba 84 00 00 00       	mov    $0x84,%edx
f01053f8:	ec                   	in     (%dx),%al
f01053f9:	ec                   	in     (%dx),%al
f01053fa:	ec                   	in     (%dx),%al
f01053fb:	ec                   	in     (%dx),%al
f01053fc:	ec                   	in     (%dx),%al
f01053fd:	ec                   	in     (%dx),%al
f01053fe:	ec                   	in     (%dx),%al
f01053ff:	ec                   	in     (%dx),%al
        inb(0x84);
        inb(0x84);
        inb(0x84);
        inb(0x84);
        inb(0x84); 
}
f0105400:	5d                   	pop    %ebp
f0105401:	c3                   	ret    

f0105402 <loadCUBase>:
 
}


void loadCUBase(void)
{
f0105402:	55                   	push   %ebp
f0105403:	89 e5                	mov    %esp,%ebp
f0105405:	53                   	push   %ebx
  uint16_t status_word=inw(portAddress);
f0105406:	8b 0d c4 3f 2d f0    	mov    0xf02d3fc4,%ecx

static __inline uint16_t
inw(int port)
{
	uint16_t data;
	__asm __volatile("inw %w1,%0" : "=a" (data) : "d" (port));
f010540c:	89 ca                	mov    %ecx,%edx
f010540e:	66 ed                	in     (%dx),%ax
       if(CU_ACTIVE & status_word)
f0105410:	84 c0                	test   %al,%al
f0105412:	78 1e                	js     f0105432 <loadCUBase+0x30>
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0105414:	8d 51 04             	lea    0x4(%ecx),%edx
f0105417:	b8 20 97 2f 00       	mov    $0x2f9720,%eax
f010541c:	ef                   	out    %eax,(%dx)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010541d:	8d 51 03             	lea    0x3(%ecx),%edx
f0105420:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105425:	ee                   	out    %al,(%dx)
f0105426:	8d 51 02             	lea    0x2(%ecx),%edx
f0105429:	b8 10 00 00 00       	mov    $0x10,%eax
f010542e:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f010542f:	89 ca                	mov    %ecx,%edx
f0105431:	ec                   	in     (%dx),%al
  //start
  outb(portAddress+0x2,CU_START);
  uint8_t status_word2=inb(portAddress);
 // cprintf("status word>>>> %d",(status_word2 & 0xC0));
 
}
f0105432:	5b                   	pop    %ebx
f0105433:	5d                   	pop    %ebp
f0105434:	c3                   	ret    

f0105435 <incrementCurrentSend>:
  }
  return NULL;
}

void incrementCurrentSend()
{
f0105435:	55                   	push   %ebp
f0105436:	89 e5                	mov    %esp,%ebp
  if(current==&sendDmaList[DMA_SIZE-1])
f0105438:	a1 64 f3 11 f0       	mov    0xf011f364,%eax
f010543d:	3d 5a e8 31 f0       	cmp    $0xf031e85a,%eax
f0105442:	75 0c                	jne    f0105450 <incrementCurrentSend+0x1b>
     current=sendDmaList;
f0105444:	c7 05 64 f3 11 f0 20 	movl   $0xf02f9720,0xf011f364
f010544b:	97 2f f0 
f010544e:	eb 0a                	jmp    f010545a <incrementCurrentSend+0x25>
   else
    current++;
f0105450:	05 fe 05 00 00       	add    $0x5fe,%eax
f0105455:	a3 64 f3 11 f0       	mov    %eax,0xf011f364
}
f010545a:	5d                   	pop    %ebp
f010545b:	c3                   	ret    

f010545c <incrementReceiveRFD>:

void incrementReceiveRFD()
{
f010545c:	55                   	push   %ebp
f010545d:	89 e5                	mov    %esp,%ebp
  if(currentRFD==&receiveDmaList[DMA_SIZE-1])
f010545f:	a1 6c f3 11 f0       	mov    0xf011f36c,%eax
f0105464:	3d 1a 91 2f f0       	cmp    $0xf02f911a,%eax
f0105469:	75 0c                	jne    f0105477 <incrementReceiveRFD+0x1b>
     currentRFD=receiveDmaList;
f010546b:	c7 05 6c f3 11 f0 e0 	movl   $0xf02d3fe0,0xf011f36c
f0105472:	3f 2d f0 
f0105475:	eb 0a                	jmp    f0105481 <incrementReceiveRFD+0x25>
   else
    currentRFD++;
f0105477:	05 fe 05 00 00       	add    $0x5fe,%eax
f010547c:	a3 6c f3 11 f0       	mov    %eax,0xf011f36c
}
f0105481:	5d                   	pop    %ebp
f0105482:	c3                   	ret    

f0105483 <rfd_init>:

}


void rfd_init(void)
{
f0105483:	55                   	push   %ebp
f0105484:	89 e5                	mov    %esp,%ebp
f0105486:	83 ec 18             	sub    $0x18,%esp
   memset(receiveDmaList,0,DMA_SIZE*sizeof(DMAReceiveRing));
f0105489:	c7 44 24 08 38 57 02 	movl   $0x25738,0x8(%esp)
f0105490:	00 
f0105491:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0105498:	00 
f0105499:	c7 04 24 e0 3f 2d f0 	movl   $0xf02d3fe0,(%esp)
f01054a0:	e8 e1 fc ff ff       	call   f0105186 <memset>
f01054a5:	b8 e8 3f 2d f0       	mov    $0xf02d3fe8,%eax
f01054aa:	ba 00 00 00 00       	mov    $0x0,%edx
   int i=0;
   for(;i<DMA_SIZE;i++)
    {
       receiveDmaList[i].reserved= 0xFFFFFFFF;
f01054af:	c7 00 ff ff ff ff    	movl   $0xffffffff,(%eax)
       receiveDmaList[i].size=1518; 
f01054b5:	66 c7 40 06 ee 05    	movw   $0x5ee,0x6(%eax)
       if(i<DMA_SIZE-1)
f01054bb:	83 fa 62             	cmp    $0x62,%edx
f01054be:	7f 0b                	jg     f01054cb <rfd_init+0x48>
         { 
         receiveDmaList[i].link=(uint32_t *)(((uint32_t)(receiveDmaList+i+1))-KERNBASE);
f01054c0:	8d 88 f6 05 00 10    	lea    0x100005f6(%eax),%ecx
f01054c6:	89 48 fc             	mov    %ecx,-0x4(%eax)
f01054c9:	eb 0d                	jmp    f01054d8 <rfd_init+0x55>
         //setting EL bit
         }
          else
          {
            receiveDmaList[i].link=(uint32_t *)(((uint32_t)receiveDmaList)-KERNBASE);
f01054cb:	c7 40 fc e0 3f 2d 00 	movl   $0x2d3fe0,-0x4(%eax)
            receiveDmaList[i].cmd=EL_BIT; 
f01054d2:	66 c7 40 fa 00 80    	movw   $0x8000,-0x6(%eax)

void rfd_init(void)
{
   memset(receiveDmaList,0,DMA_SIZE*sizeof(DMAReceiveRing));
   int i=0;
   for(;i<DMA_SIZE;i++)
f01054d8:	83 c2 01             	add    $0x1,%edx
f01054db:	05 fe 05 00 00       	add    $0x5fe,%eax
f01054e0:	83 fa 64             	cmp    $0x64,%edx
f01054e3:	75 ca                	jne    f01054af <rfd_init+0x2c>
            receiveDmaList[i].cmd=EL_BIT; 
          }
        // cprintf("\nKADDR%x\n",((uint32_t)receiveDmaList[i].link)+KERNBASE);
    }

}
f01054e5:	c9                   	leave  
f01054e6:	c3                   	ret    

f01054e7 <tcb_init>:
        inb(0x84); 
}


void tcb_init(void)
{
f01054e7:	55                   	push   %ebp
f01054e8:	89 e5                	mov    %esp,%ebp
f01054ea:	83 ec 18             	sub    $0x18,%esp
   memset(sendDmaList,0,DMA_SIZE*sizeof(DMASendRing));
f01054ed:	c7 44 24 08 38 57 02 	movl   $0x25738,0x8(%esp)
f01054f4:	00 
f01054f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f01054fc:	00 
f01054fd:	c7 04 24 20 97 2f f0 	movl   $0xf02f9720,(%esp)
f0105504:	e8 7d fc ff ff       	call   f0105186 <memset>
f0105509:	b8 2e 97 2f f0       	mov    $0xf02f972e,%eax
f010550e:	ba 00 00 00 00       	mov    $0x0,%edx
   int i=0;
   for(;i<DMA_SIZE;i++)
    {
       sendDmaList[i].THRS=0xe0;
f0105513:	c6 00 e0             	movb   $0xe0,(%eax)
       sendDmaList[i].TBD_ARRAY_ADDR= 0xFFFFFFFF;
f0105516:	c7 40 fa ff ff ff ff 	movl   $0xffffffff,-0x6(%eax)
        if(i<DMA_SIZE-1) 
f010551d:	83 fa 62             	cmp    $0x62,%edx
f0105520:	7f 0b                	jg     f010552d <tcb_init+0x46>
         sendDmaList[i].link=(uint32_t *)(((uint32_t)(sendDmaList+i+1))-KERNBASE);
f0105522:	8d 88 f0 05 00 10    	lea    0x100005f0(%eax),%ecx
f0105528:	89 48 f6             	mov    %ecx,-0xa(%eax)
f010552b:	eb 07                	jmp    f0105534 <tcb_init+0x4d>
        else
         sendDmaList[i].link=(uint32_t *)(((uint32_t)sendDmaList)-KERNBASE);
f010552d:	c7 40 f6 20 97 2f 00 	movl   $0x2f9720,-0xa(%eax)

void tcb_init(void)
{
   memset(sendDmaList,0,DMA_SIZE*sizeof(DMASendRing));
   int i=0;
   for(;i<DMA_SIZE;i++)
f0105534:	83 c2 01             	add    $0x1,%edx
f0105537:	05 fe 05 00 00       	add    $0x5fe,%eax
f010553c:	83 fa 64             	cmp    $0x64,%edx
f010553f:	75 d2                	jne    f0105513 <tcb_init+0x2c>
        else
         sendDmaList[i].link=(uint32_t *)(((uint32_t)sendDmaList)-KERNBASE);
      //cprintf("\nKADDR%x\n",((uint32_t)sendDmaList[i].link)+KERNBASE);
    }

}
f0105541:	c9                   	leave  
f0105542:	c3                   	ret    

f0105543 <getFreeBlock>:
  //else if(deviceStatus & CU_ACTIVE)
}


DMASendRing *getFreeBlock()
{
f0105543:	55                   	push   %ebp
f0105544:	89 e5                	mov    %esp,%ebp
f0105546:	53                   	push   %ebx
f0105547:	83 ec 14             	sub    $0x14,%esp
 for(;i<DMA_SIZE;i++)
  {
  
  // cprintf("\nCurrent---->%x",current);
 
   if(current->size!=0)
f010554a:	a1 64 f3 11 f0       	mov    0xf011f364,%eax
f010554f:	bb 00 00 00 00       	mov    $0x0,%ebx
f0105554:	66 83 78 0c 00       	cmpw   $0x0,0xc(%eax)
f0105559:	75 15                	jne    f0105570 <getFreeBlock+0x2d>
f010555b:	e9 a4 00 00 00       	jmp    f0105604 <getFreeBlock+0xc1>
f0105560:	a1 64 f3 11 f0       	mov    0xf011f364,%eax
f0105565:	66 83 78 0c 00       	cmpw   $0x0,0xc(%eax)
f010556a:	0f 84 94 00 00 00    	je     f0105604 <getFreeBlock+0xc1>
      {
            //cprintf("\nInside %d",current->size);
            //cprintf("\nRead Status Word--->%x",current->status); 
            if(((current->status & CHECK_CMPL)==CHECK_CMPL) && ((current->status & OK)==OK))//(1  
f0105570:	0f b7 10             	movzwl (%eax),%edx
f0105573:	66 85 d2             	test   %dx,%dx
f0105576:	79 4a                	jns    f01055c2 <getFreeBlock+0x7f>
f0105578:	0f b7 10             	movzwl (%eax),%edx
f010557b:	f6 c6 20             	test   $0x20,%dh
f010557e:	74 42                	je     f01055c2 <getFreeBlock+0x7f>
              {
                //cprintf("\nInside OK bit");
                 memset(current->data,0,1518);
f0105580:	c7 44 24 08 ee 05 00 	movl   $0x5ee,0x8(%esp)
f0105587:	00 
f0105588:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010558f:	00 
f0105590:	83 c0 10             	add    $0x10,%eax
f0105593:	89 04 24             	mov    %eax,(%esp)
f0105596:	e8 eb fb ff ff       	call   f0105186 <memset>
                 current->status=0;
f010559b:	a1 64 f3 11 f0       	mov    0xf011f364,%eax
f01055a0:	66 c7 00 00 00       	movw   $0x0,(%eax)
                 current->cmd=0;
f01055a5:	a1 64 f3 11 f0       	mov    0xf011f364,%eax
f01055aa:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
                 //current->THRS=0xe0;
                 current->size = 0;
f01055b0:	a1 64 f3 11 f0       	mov    0xf011f364,%eax
f01055b5:	66 c7 40 0c 00 00    	movw   $0x0,0xc(%eax)
                 return current;
f01055bb:	a1 64 f3 11 f0       	mov    0xf011f364,%eax
f01055c0:	eb 42                	jmp    f0105604 <getFreeBlock+0xc1>
              }
          else if((current->status & CHECK_CMPL) ==CHECK_CMPL && (current->status & OK)!=OK)
f01055c2:	0f b7 10             	movzwl (%eax),%edx
f01055c5:	66 85 d2             	test   %dx,%dx
f01055c8:	79 24                	jns    f01055ee <getFreeBlock+0xab>
f01055ca:	0f b7 00             	movzwl (%eax),%eax
f01055cd:	f6 c4 20             	test   $0x20,%ah
f01055d0:	75 1c                	jne    f01055ee <getFreeBlock+0xab>
                { 
                  cprintf("\nInside error bit\n");
f01055d2:	c7 04 24 4f 77 10 f0 	movl   $0xf010774f,(%esp)
f01055d9:	e8 e1 dd ff ff       	call   f01033bf <cprintf>
                  current->status&=(~CHECK_CMPL);
f01055de:	a1 64 f3 11 f0       	mov    0xf011f364,%eax
f01055e3:	0f b7 10             	movzwl (%eax),%edx
f01055e6:	66 81 e2 ff 7f       	and    $0x7fff,%dx
f01055eb:	66 89 10             	mov    %dx,(%eax)
                }
   
      }
   else 
    return current;
  incrementCurrentSend();
f01055ee:	e8 42 fe ff ff       	call   f0105435 <incrementCurrentSend>


DMASendRing *getFreeBlock()
{
int i=0;
 for(;i<DMA_SIZE;i++)
f01055f3:	83 c3 01             	add    $0x1,%ebx
f01055f6:	83 fb 64             	cmp    $0x64,%ebx
f01055f9:	0f 85 61 ff ff ff    	jne    f0105560 <getFreeBlock+0x1d>
f01055ff:	b8 00 00 00 00       	mov    $0x0,%eax
   else 
    return current;
  incrementCurrentSend();
  }
  return NULL;
}
f0105604:	83 c4 14             	add    $0x14,%esp
f0105607:	5b                   	pop    %ebx
f0105608:	5d                   	pop    %ebp
f0105609:	c3                   	ret    

f010560a <ru_start>:
return 0;
}


void ru_start(void)
{
f010560a:	55                   	push   %ebp
f010560b:	89 e5                	mov    %esp,%ebp
f010560d:	83 ec 18             	sub    $0x18,%esp
cprintf("\n-->here RU start\n");
f0105610:	c7 04 24 62 77 10 f0 	movl   $0xf0107762,(%esp)
f0105617:	e8 a3 dd ff ff       	call   f01033bf <cprintf>
outl(portAddress+0x4,((uint32_t)(receiveDmaList)-KERNBASE));
f010561c:	8b 0d c4 3f 2d f0    	mov    0xf02d3fc4,%ecx
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0105622:	8d 51 04             	lea    0x4(%ecx),%edx
f0105625:	b8 e0 3f 2d 00       	mov    $0x2d3fe0,%eax
f010562a:	ef                   	out    %eax,(%dx)
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010562b:	8d 51 03             	lea    0x3(%ecx),%edx
f010562e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105633:	ee                   	out    %al,(%dx)
f0105634:	8d 51 02             	lea    0x2(%ecx),%edx
f0105637:	b8 01 00 00 00       	mov    $0x1,%eax
f010563c:	ee                   	out    %al,(%dx)
outb(portAddress+0x3, 0xFF);
outb(portAddress+0x2,0x01);
}
f010563d:	c9                   	leave  
f010563e:	c3                   	ret    

f010563f <copyIntoDMA>:
}
 
// resume it when the CU is in suspended mode
// restart it when in idle.
void copyIntoDMA(void *va,size_t len)
{
f010563f:	55                   	push   %ebp
f0105640:	89 e5                	mov    %esp,%ebp
f0105642:	56                   	push   %esi
f0105643:	53                   	push   %ebx
f0105644:	83 ec 10             	sub    $0x10,%esp
f0105647:	8b 75 0c             	mov    0xc(%ebp),%esi

DMASendRing *freeblock = getFreeBlock();
f010564a:	e8 f4 fe ff ff       	call   f0105543 <getFreeBlock>
f010564f:	89 c3                	mov    %eax,%ebx
if(freeblock!=NULL)
f0105651:	85 c0                	test   %eax,%eax
f0105653:	74 4e                	je     f01056a3 <copyIntoDMA+0x64>
  {
       //cprintf("%d",sizeof(DMASendRing)); 
       //cprintf("\n%x  %x",freeblock,sendDmaList);
        memmove(freeblock->data,va,len);
f0105655:	89 74 24 08          	mov    %esi,0x8(%esp)
f0105659:	8b 45 08             	mov    0x8(%ebp),%eax
f010565c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105660:	8d 43 10             	lea    0x10(%ebx),%eax
f0105663:	89 04 24             	mov    %eax,(%esp)
f0105666:	e8 7a fb ff ff       	call   f01051e5 <memmove>
	//set the S bit here
       // cprintf("Current-> %x   FreeBlock--> %x",current,freeblock);
	int i=0;
        while(freeblock->data[i]!='\0')
f010566b:	80 7b 10 00          	cmpb   $0x0,0x10(%ebx)
f010566f:	74 0d                	je     f010567e <copyIntoDMA+0x3f>
f0105671:	89 d8                	mov    %ebx,%eax
f0105673:	0f b6 50 11          	movzbl 0x11(%eax),%edx
f0105677:	83 c0 01             	add    $0x1,%eax
f010567a:	84 d2                	test   %dl,%dl
f010567c:	75 f5                	jne    f0105673 <copyIntoDMA+0x34>
        {
        //cprintf("%c",freeblock->data[i]);
         i++;
        }
        freeblock->cmd = freeblock->cmd|S_BIT;	                 
f010567e:	0f b7 43 02          	movzwl 0x2(%ebx),%eax
	freeblock->size = len; 	
f0105682:	66 89 73 0c          	mov    %si,0xc(%ebx)
        freeblock->cmd|=TRANSMIT;
f0105686:	66 0d 04 40          	or     $0x4004,%ax
f010568a:	66 89 43 02          	mov    %ax,0x2(%ebx)
        incrementCurrentSend();
f010568e:	e8 a2 fd ff ff       	call   f0105435 <incrementCurrentSend>
// setting the previous S bit to zero.Assuming there will be no error.
   /*DMASendRing *prev=NULL; 
   getPreviousSend(&prev); 
   prev->cmd=0;
*/
   uint16_t deviceStatus=inb(portAddress);
f0105693:	8b 15 c4 3f 2d f0    	mov    0xf02d3fc4,%edx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0105699:	ec                   	in     (%dx),%al
   //cprintf("Device Status%x\n",(deviceStatus & 0x00F0));
  if( 0x00 == (deviceStatus & 0xC0) )
f010569a:	25 c0 00 00 00       	and    $0xc0,%eax
f010569f:	75 19                	jne    f01056ba <copyIntoDMA+0x7b>
f01056a1:	eb 0f                	jmp    f01056b2 <copyIntoDMA+0x73>
        freeblock->cmd|=TRANSMIT;
        incrementCurrentSend();
  }
else
  {
   cprintf("\nDMA Ring Full\n");
f01056a3:	c7 04 24 75 77 10 f0 	movl   $0xf0107775,(%esp)
f01056aa:	e8 10 dd ff ff       	call   f01033bf <cprintf>
    return;
f01056af:	90                   	nop
f01056b0:	eb 17                	jmp    f01056c9 <copyIntoDMA+0x8a>
   uint16_t deviceStatus=inb(portAddress);
   //cprintf("Device Status%x\n",(deviceStatus & 0x00F0));
  if( 0x00 == (deviceStatus & 0xC0) )
                {
      //             cprintf("\nHere starting\n");
                    loadCUBase();
f01056b2:	e8 4b fd ff ff       	call   f0105402 <loadCUBase>
f01056b7:	90                   	nop
f01056b8:	eb 0f                	jmp    f01056c9 <copyIntoDMA+0x8a>
                }


   else if((deviceStatus & 0xC0) ==CU_SUSPEND)
f01056ba:	83 f8 40             	cmp    $0x40,%eax
f01056bd:	8d 76 00             	lea    0x0(%esi),%esi
f01056c0:	75 07                	jne    f01056c9 <copyIntoDMA+0x8a>
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
f01056c2:	83 c2 02             	add    $0x2,%edx
f01056c5:	b0 20                	mov    $0x20,%al
f01056c7:	66 ef                	out    %ax,(%dx)
    //        cprintf("\nHere Suspend\n");
            outw(portAddress+0x2,0x20);
       }
   
  //else if(deviceStatus & CU_ACTIVE)
}
f01056c9:	83 c4 10             	add    $0x10,%esp
f01056cc:	5b                   	pop    %ebx
f01056cd:	5e                   	pop    %esi
f01056ce:	5d                   	pop    %ebp
f01056cf:	c3                   	ret    

f01056d0 <copyFromRFA>:
outb(portAddress+0x2,0x01);
}


int copyFromRFA(void *va,void *len)
{
f01056d0:	55                   	push   %ebp
f01056d1:	89 e5                	mov    %esp,%ebp
f01056d3:	83 ec 18             	sub    $0x18,%esp
//int i=0;
//cprintf("\n-->here copyfrom RFA start\n");
//for(;i<DMA_SIZE;i++)
//{
  //checkForFreeRFA();
 if(((currentRFD->status & CHECK_CMPL)== CHECK_CMPL)  && ((currentRFD->status & OK)== OK)  && (currentRFD->actualCount & 0xc000) )
f01056d6:	a1 6c f3 11 f0       	mov    0xf011f36c,%eax
f01056db:	0f b7 10             	movzwl (%eax),%edx
f01056de:	66 85 d2             	test   %dx,%dx
f01056e1:	0f 89 38 01 00 00    	jns    f010581f <copyFromRFA+0x14f>
f01056e7:	0f b7 10             	movzwl (%eax),%edx
f01056ea:	f6 c6 20             	test   $0x20,%dh
f01056ed:	0f 84 2c 01 00 00    	je     f010581f <copyFromRFA+0x14f>
f01056f3:	66 f7 40 0c 00 c0    	testw  $0xc000,0xc(%eax)
f01056f9:	0f 84 20 01 00 00    	je     f010581f <copyFromRFA+0x14f>
     {
       //memmove(va,(receiveDmaList[i].actualCount & 0x3FFF));
        cprintf("\nstatuse=------%x\n",currentRFD->status);
f01056ff:	0f b7 00             	movzwl (%eax),%eax
f0105702:	0f b7 c0             	movzwl %ax,%eax
f0105705:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105709:	c7 04 24 85 77 10 f0 	movl   $0xf0107785,(%esp)
f0105710:	e8 aa dc ff ff       	call   f01033bf <cprintf>
        cprintf("\nEOF=------%x\n",(currentRFD->actualCount& 0xc000));
f0105715:	a1 6c f3 11 f0       	mov    0xf011f36c,%eax
f010571a:	0f b7 40 0c          	movzwl 0xc(%eax),%eax
f010571e:	25 00 c0 00 00       	and    $0xc000,%eax
f0105723:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105727:	c7 04 24 98 77 10 f0 	movl   $0xf0107798,(%esp)
f010572e:	e8 8c dc ff ff       	call   f01033bf <cprintf>
        memmove(va,currentRFD->data,(currentRFD->actualCount & 0x3FFF));
f0105733:	a1 6c f3 11 f0       	mov    0xf011f36c,%eax
f0105738:	0f b7 50 0c          	movzwl 0xc(%eax),%edx
f010573c:	81 e2 ff 3f 00 00    	and    $0x3fff,%edx
f0105742:	89 54 24 08          	mov    %edx,0x8(%esp)
f0105746:	83 c0 10             	add    $0x10,%eax
f0105749:	89 44 24 04          	mov    %eax,0x4(%esp)
f010574d:	8b 45 08             	mov    0x8(%ebp),%eax
f0105750:	89 04 24             	mov    %eax,(%esp)
f0105753:	e8 8d fa ff ff       	call   f01051e5 <memmove>
        uint32_t *locallen=(uint32_t *)len;
        //cprintf("len--->%x",len);
       *locallen=(currentRFD->actualCount & 0x3FFF); 
f0105758:	a1 6c f3 11 f0       	mov    0xf011f36c,%eax
f010575d:	0f b7 50 0c          	movzwl 0xc(%eax),%edx
f0105761:	81 e2 ff 3f 00 00    	and    $0x3fff,%edx
f0105767:	8b 45 0c             	mov    0xc(%ebp),%eax
f010576a:	89 10                	mov    %edx,(%eax)
        ///stting the pkt len
        //va->pkt.jp_len=(receiveDmaList[i].actualCount & 0x3FFF);
  //     cprintf("\n-->Actual Count--->\n%d",(currentRFD->actualCount & 0x3FFF));      
       memset(currentRFD->data,0,1518);
f010576c:	c7 44 24 08 ee 05 00 	movl   $0x5ee,0x8(%esp)
f0105773:	00 
f0105774:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010577b:	00 
f010577c:	a1 6c f3 11 f0       	mov    0xf011f36c,%eax
f0105781:	83 c0 10             	add    $0x10,%eax
f0105784:	89 04 24             	mov    %eax,(%esp)
f0105787:	e8 fa f9 ff ff       	call   f0105186 <memset>
       currentRFD->actualCount=0;
f010578c:	a1 6c f3 11 f0       	mov    0xf011f36c,%eax
f0105791:	66 c7 40 0c 00 00    	movw   $0x0,0xc(%eax)
       currentRFD->cmd=0;
f0105797:	a1 6c f3 11 f0       	mov    0xf011f36c,%eax
f010579c:	66 c7 40 02 00 00    	movw   $0x0,0x2(%eax)
       currentRFD->status=0;
f01057a2:	a1 6c f3 11 f0       	mov    0xf011f36c,%eax
f01057a7:	66 c7 00 00 00       	movw   $0x0,(%eax)
       
      
       if((uint32_t)currentRFD>(uint32_t)receiveDmaList)
f01057ac:	a1 6c f3 11 f0       	mov    0xf011f36c,%eax
f01057b1:	3d e0 3f 2d f0       	cmp    $0xf02d3fe0,%eax
f01057b6:	76 31                	jbe    f01057e9 <copyFromRFA+0x119>
        { 
    //         cprintf("\ncurrentRFD--->%x   receiveDmaList%x\n",currentRFD,receiveDmaList);
      //       cprintf("\nAbove if--->%x   EL-bit%x\n",((currentRFD-1)->cmd & EL_BIT),EL_BIT);
        //     cprintf("\nLastttt--->%x   receiveDmaList%x\n",(receiveDmaList[DMA_SIZE-1].cmd & EL_BIT) ,EL_BIT); 
           if(((currentRFD-1)->cmd & EL_BIT) == EL_BIT)
f01057b8:	66 83 b8 04 fa ff ff 	cmpw   $0x0,-0x5fc(%eax)
f01057bf:	00 
f01057c0:	79 51                	jns    f0105813 <copyFromRFA+0x143>
             {
                cprintf("\nChanging EL bit>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n");
f01057c2:	c7 04 24 c0 77 10 f0 	movl   $0xf01077c0,(%esp)
f01057c9:	e8 f1 db ff ff       	call   f01033bf <cprintf>
               currentRFD->cmd = EL_BIT;
f01057ce:	a1 6c f3 11 f0       	mov    0xf011f36c,%eax
f01057d3:	66 c7 40 02 00 80    	movw   $0x8000,0x2(%eax)
               (currentRFD-1)->cmd&=0x7FFF; 
f01057d9:	a1 6c f3 11 f0       	mov    0xf011f36c,%eax
f01057de:	66 81 a0 04 fa ff ff 	andw   $0x7fff,-0x5fc(%eax)
f01057e5:	ff 7f 
f01057e7:	eb 2a                	jmp    f0105813 <copyFromRFA+0x143>
             }
        }
      else
        {
     //cprintf("\nLasttt--->%x   receiveDmaList%x\n",(receiveDmaList[DMA_SIZE-1].cmd & EL_BIT) ,EL_BIT); 
          if((receiveDmaList[DMA_SIZE-1].cmd & EL_BIT) == EL_BIT)
f01057e9:	66 83 3d 1c 91 2f f0 	cmpw   $0x0,0xf02f911c
f01057f0:	00 
f01057f1:	79 20                	jns    f0105813 <copyFromRFA+0x143>
              {  

                cprintf("\nChanging EL bit below\n");
f01057f3:	c7 04 24 a7 77 10 f0 	movl   $0xf01077a7,(%esp)
f01057fa:	e8 c0 db ff ff       	call   f01033bf <cprintf>
                receiveDmaList[DMA_SIZE-1].cmd &=0x7FFF ;
f01057ff:	66 81 25 1c 91 2f f0 	andw   $0x7fff,0xf02f911c
f0105806:	ff 7f 
                currentRFD->cmd=EL_BIT;
f0105808:	a1 6c f3 11 f0       	mov    0xf011f36c,%eax
f010580d:	66 c7 40 02 00 80    	movw   $0x8000,0x2(%eax)
              } 
        }
       incrementReceiveRFD();
f0105813:	e8 44 fc ff ff       	call   f010545c <incrementReceiveRFD>
f0105818:	b8 00 00 00 00       	mov    $0x0,%eax
       return 0; 
f010581d:	eb 05                	jmp    f0105824 <copyFromRFA+0x154>
f010581f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
     }
 else
  return NO_PACKET; 
 
}
f0105824:	c9                   	leave  
f0105825:	c3                   	ret    

f0105826 <addEthernetDriver>:




int addEthernetDriver(struct pci_func *pcif)
{
f0105826:	55                   	push   %ebp
f0105827:	89 e5                	mov    %esp,%ebp
f0105829:	53                   	push   %ebx
f010582a:	83 ec 14             	sub    $0x14,%esp
f010582d:	8b 5d 08             	mov    0x8(%ebp),%ebx
pci_func_enable(pcif);
f0105830:	89 1c 24             	mov    %ebx,(%esp)
f0105833:	e8 36 05 00 00       	call   f0105d6e <pci_func_enable>
irqLine = pcif->irq_line;
f0105838:	0f b6 43 44          	movzbl 0x44(%ebx),%eax
f010583c:	a2 c0 3f 2d f0       	mov    %al,0xf02d3fc0
portAddress=pcif->reg_base[1];
f0105841:	8b 53 18             	mov    0x18(%ebx),%edx
f0105844:	89 15 c4 3f 2d f0    	mov    %edx,0xf02d3fc4
uint32_t temp = inl(portAddress + 0x8);
f010584a:	83 c2 08             	add    $0x8,%edx

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f010584d:	ed                   	in     (%dx),%eax
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f010584e:	b8 00 00 00 00       	mov    $0x0,%eax
f0105853:	ef                   	out    %eax,(%dx)
outl(portAddress+0x8,0x0); 
delay();
f0105854:	e8 97 fb ff ff       	call   f01053f0 <delay>
tcb_init();
f0105859:	e8 89 fc ff ff       	call   f01054e7 <tcb_init>
rfd_init();
f010585e:	e8 20 fc ff ff       	call   f0105483 <rfd_init>
ru_start();
f0105863:	e8 a2 fd ff ff       	call   f010560a <ru_start>
return 0;
}
f0105868:	b8 00 00 00 00       	mov    $0x0,%eax
f010586d:	83 c4 14             	add    $0x14,%esp
f0105870:	5b                   	pop    %ebx
f0105871:	5d                   	pop    %ebp
f0105872:	c3                   	ret    
	...

f0105880 <pci_attach_match>:
}

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f0105880:	55                   	push   %ebp
f0105881:	89 e5                	mov    %esp,%ebp
f0105883:	57                   	push   %edi
f0105884:	56                   	push   %esi
f0105885:	53                   	push   %ebx
f0105886:	83 ec 3c             	sub    $0x3c,%esp
f0105889:	89 c7                	mov    %eax,%edi
f010588b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010588e:	89 ce                	mov    %ecx,%esi
	uint32_t i;
	
       // if(list[0].attachfn==NULL)
             //cprintf("\ntrue\n");
	for (i = 0; list[i].attachfn; i++) {
f0105890:	8b 41 08             	mov    0x8(%ecx),%eax
f0105893:	85 c0                	test   %eax,%eax
f0105895:	74 4d                	je     f01058e4 <pci_attach_match+0x64>
f0105897:	8d 59 0c             	lea    0xc(%ecx),%ebx
         //cprintf("\nHere inside matching key1= %d  key2= %d fn = %d\n",key1,key2,list[i].attachfn);
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f010589a:	39 3e                	cmp    %edi,(%esi)
f010589c:	75 3a                	jne    f01058d8 <pci_attach_match+0x58>
f010589e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f01058a1:	39 56 04             	cmp    %edx,0x4(%esi)
f01058a4:	75 32                	jne    f01058d8 <pci_attach_match+0x58>
                     //cprintf("Here inside matching %d  %d",key1,key2);
			int r = list[i].attachfn(pcif);
f01058a6:	8b 55 08             	mov    0x8(%ebp),%edx
f01058a9:	89 14 24             	mov    %edx,(%esp)
f01058ac:	ff d0                	call   *%eax
			if (r > 0)
f01058ae:	85 c0                	test   %eax,%eax
f01058b0:	7f 37                	jg     f01058e9 <pci_attach_match+0x69>
				return r;
			if (r < 0)
f01058b2:	85 c0                	test   %eax,%eax
f01058b4:	79 22                	jns    f01058d8 <pci_attach_match+0x58>
				cprintf("pci_attach_match: attaching "
f01058b6:	89 44 24 10          	mov    %eax,0x10(%esp)
f01058ba:	8b 46 08             	mov    0x8(%esi),%eax
f01058bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01058c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01058c4:	89 44 24 08          	mov    %eax,0x8(%esp)
f01058c8:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01058cc:	c7 04 24 04 78 10 f0 	movl   $0xf0107804,(%esp)
f01058d3:	e8 e7 da ff ff       	call   f01033bf <cprintf>
f01058d8:	89 de                	mov    %ebx,%esi
{
	uint32_t i;
	
       // if(list[0].attachfn==NULL)
             //cprintf("\ntrue\n");
	for (i = 0; list[i].attachfn; i++) {
f01058da:	8b 43 08             	mov    0x8(%ebx),%eax
f01058dd:	83 c3 0c             	add    $0xc,%ebx
f01058e0:	85 c0                	test   %eax,%eax
f01058e2:	75 b6                	jne    f010589a <pci_attach_match+0x1a>
f01058e4:	b8 00 00 00 00       	mov    $0x0,%eax
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f01058e9:	83 c4 3c             	add    $0x3c,%esp
f01058ec:	5b                   	pop    %ebx
f01058ed:	5e                   	pop    %esi
f01058ee:	5f                   	pop    %edi
f01058ef:	5d                   	pop    %ebp
f01058f0:	c3                   	ret    

f01058f1 <pci_conf1_set_addr>:
static void
pci_conf1_set_addr(uint32_t bus,
		   uint32_t dev,
		   uint32_t func,
		   uint32_t offset)
{
f01058f1:	55                   	push   %ebp
f01058f2:	89 e5                	mov    %esp,%ebp
f01058f4:	53                   	push   %ebx
f01058f5:	83 ec 14             	sub    $0x14,%esp
f01058f8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f01058fb:	3d ff 00 00 00       	cmp    $0xff,%eax
f0105900:	76 24                	jbe    f0105926 <pci_conf1_set_addr+0x35>
f0105902:	c7 44 24 0c 5c 79 10 	movl   $0xf010795c,0xc(%esp)
f0105909:	f0 
f010590a:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0105911:	f0 
f0105912:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
f0105919:	00 
f010591a:	c7 04 24 66 79 10 f0 	movl   $0xf0107966,(%esp)
f0105921:	e8 5f a7 ff ff       	call   f0100085 <_panic>
	assert(dev < 32);
f0105926:	83 fa 1f             	cmp    $0x1f,%edx
f0105929:	76 24                	jbe    f010594f <pci_conf1_set_addr+0x5e>
f010592b:	c7 44 24 0c 71 79 10 	movl   $0xf0107971,0xc(%esp)
f0105932:	f0 
f0105933:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f010593a:	f0 
f010593b:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
f0105942:	00 
f0105943:	c7 04 24 66 79 10 f0 	movl   $0xf0107966,(%esp)
f010594a:	e8 36 a7 ff ff       	call   f0100085 <_panic>
	assert(func < 8);
f010594f:	83 f9 07             	cmp    $0x7,%ecx
f0105952:	76 24                	jbe    f0105978 <pci_conf1_set_addr+0x87>
f0105954:	c7 44 24 0c 7a 79 10 	movl   $0xf010797a,0xc(%esp)
f010595b:	f0 
f010595c:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f0105963:	f0 
f0105964:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
f010596b:	00 
f010596c:	c7 04 24 66 79 10 f0 	movl   $0xf0107966,(%esp)
f0105973:	e8 0d a7 ff ff       	call   f0100085 <_panic>
	assert(offset < 256);
f0105978:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f010597e:	76 24                	jbe    f01059a4 <pci_conf1_set_addr+0xb3>
f0105980:	c7 44 24 0c 83 79 10 	movl   $0xf0107983,0xc(%esp)
f0105987:	f0 
f0105988:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f010598f:	f0 
f0105990:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
f0105997:	00 
f0105998:	c7 04 24 66 79 10 f0 	movl   $0xf0107966,(%esp)
f010599f:	e8 e1 a6 ff ff       	call   f0100085 <_panic>
	assert((offset & 0x3) == 0);
f01059a4:	f6 c3 03             	test   $0x3,%bl
f01059a7:	74 24                	je     f01059cd <pci_conf1_set_addr+0xdc>
f01059a9:	c7 44 24 0c 90 79 10 	movl   $0xf0107990,0xc(%esp)
f01059b0:	f0 
f01059b1:	c7 44 24 08 a2 66 10 	movl   $0xf01066a2,0x8(%esp)
f01059b8:	f0 
f01059b9:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
f01059c0:	00 
f01059c1:	c7 04 24 66 79 10 f0 	movl   $0xf0107966,(%esp)
f01059c8:	e8 b8 a6 ff ff       	call   f0100085 <_panic>
f01059cd:	c1 e0 10             	shl    $0x10,%eax
f01059d0:	0d 00 00 00 80       	or     $0x80000000,%eax
f01059d5:	c1 e2 0b             	shl    $0xb,%edx
f01059d8:	09 d0                	or     %edx,%eax
f01059da:	09 d8                	or     %ebx,%eax
f01059dc:	c1 e1 08             	shl    $0x8,%ecx
f01059df:	09 c8                	or     %ecx,%eax
f01059e1:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f01059e6:	ef                   	out    %eax,(%dx)
	
	uint32_t v = (1 << 31) |		// config-space
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
	outl(pci_conf1_addr_ioport, v);
}
f01059e7:	83 c4 14             	add    $0x14,%esp
f01059ea:	5b                   	pop    %ebx
f01059eb:	5d                   	pop    %ebp
f01059ec:	c3                   	ret    

f01059ed <pci_conf_read>:

static uint32_t
pci_conf_read(struct pci_func *f, uint32_t off)
{
f01059ed:	55                   	push   %ebp
f01059ee:	89 e5                	mov    %esp,%ebp
f01059f0:	53                   	push   %ebx
f01059f1:	83 ec 14             	sub    $0x14,%esp
f01059f4:	89 d3                	mov    %edx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f01059f6:	8b 48 08             	mov    0x8(%eax),%ecx
f01059f9:	8b 50 04             	mov    0x4(%eax),%edx
f01059fc:	8b 00                	mov    (%eax),%eax
f01059fe:	8b 40 04             	mov    0x4(%eax),%eax
f0105a01:	89 1c 24             	mov    %ebx,(%esp)
f0105a04:	e8 e8 fe ff ff       	call   f01058f1 <pci_conf1_set_addr>

static __inline uint32_t
inl(int port)
{
	uint32_t data;
	__asm __volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f0105a09:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0105a0e:	ed                   	in     (%dx),%eax
	return inl(pci_conf1_data_ioport);
}
f0105a0f:	83 c4 14             	add    $0x14,%esp
f0105a12:	5b                   	pop    %ebx
f0105a13:	5d                   	pop    %ebp
f0105a14:	c3                   	ret    

f0105a15 <pci_scan_bus>:
		f->irq_line);
}

static int 
pci_scan_bus(struct pci_bus *bus)
{
f0105a15:	55                   	push   %ebp
f0105a16:	89 e5                	mov    %esp,%ebp
f0105a18:	57                   	push   %edi
f0105a19:	56                   	push   %esi
f0105a1a:	53                   	push   %ebx
f0105a1b:	81 ec 3c 01 00 00    	sub    $0x13c,%esp
f0105a21:	89 c3                	mov    %eax,%ebx
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
f0105a23:	c7 44 24 08 48 00 00 	movl   $0x48,0x8(%esp)
f0105a2a:	00 
f0105a2b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0105a32:	00 
f0105a33:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0105a36:	89 04 24             	mov    %eax,(%esp)
f0105a39:	e8 48 f7 ff ff       	call   f0105186 <memset>
	df.bus = bus;
f0105a3e:	89 5d a0             	mov    %ebx,-0x60(%ebp)
	
	for (df.dev = 0; df.dev < 32; df.dev++) {
f0105a41:	c7 45 a4 00 00 00 00 	movl   $0x0,-0x5c(%ebp)
};

static void 
pci_print_func(struct pci_func *f)
{
	const char *class = pci_class[0];
f0105a48:	c7 85 fc fe ff ff 00 	movl   $0x0,-0x104(%ebp)
f0105a4f:	00 00 00 
	df.bus = bus;
	
	for (df.dev = 0; df.dev < 32; df.dev++) {
		//cprintf("%d\n",totaldev);
              
            uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f0105a52:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0105a55:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
		{    //cprintf("%d\n",totaldev);
                	continue;
		}
		totaldev++;
		
		struct pci_func f = df;
f0105a5b:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
f0105a61:	89 8d f4 fe ff ff    	mov    %ecx,-0x10c(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
			struct pci_func af = f;
f0105a67:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f0105a6d:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
f0105a73:	89 8d 00 ff ff ff    	mov    %ecx,-0x100(%ebp)
f0105a79:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
	df.bus = bus;
	
	for (df.dev = 0; df.dev < 32; df.dev++) {
		//cprintf("%d\n",totaldev);
              
            uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f0105a7f:	ba 0c 00 00 00       	mov    $0xc,%edx
f0105a84:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0105a87:	e8 61 ff ff ff       	call   f01059ed <pci_conf_read>
		//cprintf(" bhlc%x  %x bus %x  dev %x\n",bhlc,PCI_HDRTYPE_TYPE(bhlc),df.func,df.dev);
                 if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f0105a8c:	89 c2                	mov    %eax,%edx
f0105a8e:	c1 ea 10             	shr    $0x10,%edx
f0105a91:	83 e2 7f             	and    $0x7f,%edx
f0105a94:	83 fa 01             	cmp    $0x1,%edx
f0105a97:	0f 87 77 01 00 00    	ja     f0105c14 <pci_scan_bus+0x1ff>
		{    //cprintf("%d\n",totaldev);
                	continue;
		}
		totaldev++;
		
		struct pci_func f = df;
f0105a9d:	b9 12 00 00 00       	mov    $0x12,%ecx
f0105aa2:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
f0105aa8:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
f0105aae:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0105ab0:	c7 85 60 ff ff ff 00 	movl   $0x0,-0xa0(%ebp)
f0105ab7:	00 00 00 
f0105aba:	89 c3                	mov    %eax,%ebx
f0105abc:	81 e3 00 00 80 00    	and    $0x800000,%ebx
f0105ac2:	e9 2f 01 00 00       	jmp    f0105bf6 <pci_scan_bus+0x1e1>
		     f.func++) {
			struct pci_func af = f;
f0105ac7:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
f0105acd:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
f0105ad3:	b9 12 00 00 00       	mov    $0x12,%ecx
f0105ad8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			
			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f0105ada:	ba 00 00 00 00       	mov    $0x0,%edx
f0105adf:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f0105ae5:	e8 03 ff ff ff       	call   f01059ed <pci_conf_read>
f0105aea:	89 85 1c ff ff ff    	mov    %eax,-0xe4(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f0105af0:	66 83 f8 ff          	cmp    $0xffffffff,%ax
f0105af4:	0f 84 f5 00 00 00    	je     f0105bef <pci_scan_bus+0x1da>
				continue;
			
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0105afa:	ba 3c 00 00 00       	mov    $0x3c,%edx
f0105aff:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f0105b05:	e8 e3 fe ff ff       	call   f01059ed <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f0105b0a:	88 85 54 ff ff ff    	mov    %al,-0xac(%ebp)
			
			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0105b10:	ba 08 00 00 00       	mov    $0x8,%edx
f0105b15:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f0105b1b:	e8 cd fe ff ff       	call   f01059ed <pci_conf_read>
f0105b20:	89 85 20 ff ff ff    	mov    %eax,-0xe0(%ebp)

static void 
pci_print_func(struct pci_func *f)
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
f0105b26:	89 c2                	mov    %eax,%edx
f0105b28:	c1 ea 18             	shr    $0x18,%edx
f0105b2b:	b9 a4 79 10 f0       	mov    $0xf01079a4,%ecx
f0105b30:	83 fa 06             	cmp    $0x6,%edx
f0105b33:	77 07                	ja     f0105b3c <pci_scan_bus+0x127>
		class = pci_class[PCI_CLASS(f->dev_class)];
f0105b35:	8b 0c 95 18 7a 10 f0 	mov    -0xfef85e8(,%edx,4),%ecx

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0105b3c:	8b bd 1c ff ff ff    	mov    -0xe4(%ebp),%edi
{
	const char *class = pci_class[0];
	if (PCI_CLASS(f->dev_class) < sizeof(pci_class) / sizeof(pci_class[0]))
		class = pci_class[PCI_CLASS(f->dev_class)];

	cprintf("PCI: %02x:%02x.%d: %04x:%04x: class: %x.%x (%s) irq: %d\n",
f0105b42:	0f b6 b5 54 ff ff ff 	movzbl -0xac(%ebp),%esi
f0105b49:	89 74 24 24          	mov    %esi,0x24(%esp)
f0105b4d:	89 4c 24 20          	mov    %ecx,0x20(%esp)
f0105b51:	c1 e8 10             	shr    $0x10,%eax
f0105b54:	25 ff 00 00 00       	and    $0xff,%eax
f0105b59:	89 44 24 1c          	mov    %eax,0x1c(%esp)
f0105b5d:	89 54 24 18          	mov    %edx,0x18(%esp)
f0105b61:	89 f8                	mov    %edi,%eax
f0105b63:	c1 e8 10             	shr    $0x10,%eax
f0105b66:	89 44 24 14          	mov    %eax,0x14(%esp)
f0105b6a:	81 e7 ff ff 00 00    	and    $0xffff,%edi
f0105b70:	89 7c 24 10          	mov    %edi,0x10(%esp)
f0105b74:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
f0105b7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105b7e:	8b 85 14 ff ff ff    	mov    -0xec(%ebp),%eax
f0105b84:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105b88:	8b 85 10 ff ff ff    	mov    -0xf0(%ebp),%eax
f0105b8e:	8b 40 04             	mov    0x4(%eax),%eax
f0105b91:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105b95:	c7 04 24 30 78 10 f0 	movl   $0xf0107830,(%esp)
f0105b9c:	e8 1e d8 ff ff       	call   f01033bf <cprintf>
static int
pci_attach(struct pci_func *f)
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class), 
				 PCI_SUBCLASS(f->dev_class),
f0105ba1:	8b 85 20 ff ff ff    	mov    -0xe0(%ebp),%eax
				 &pci_attach_class[0], f) ||
f0105ba7:	89 c2                	mov    %eax,%edx
f0105ba9:	c1 ea 10             	shr    $0x10,%edx
f0105bac:	81 e2 ff 00 00 00    	and    $0xff,%edx
f0105bb2:	c1 e8 18             	shr    $0x18,%eax
f0105bb5:	8b 8d 04 ff ff ff    	mov    -0xfc(%ebp),%ecx
f0105bbb:	89 0c 24             	mov    %ecx,(%esp)
f0105bbe:	b9 70 f3 11 f0       	mov    $0xf011f370,%ecx
f0105bc3:	e8 b8 fc ff ff       	call   f0105880 <pci_attach_match>

static int
pci_attach(struct pci_func *f)
{
	return
		pci_attach_match(PCI_CLASS(f->dev_class), 
f0105bc8:	85 c0                	test   %eax,%eax
f0105bca:	75 23                	jne    f0105bef <pci_scan_bus+0x1da>
				 PCI_SUBCLASS(f->dev_class),
				 &pci_attach_class[0], f) ||
		pci_attach_match(PCI_VENDOR(f->dev_id), 
				 PCI_PRODUCT(f->dev_id),
f0105bcc:	8b 85 1c ff ff ff    	mov    -0xe4(%ebp),%eax
				 &pci_attach_vendor[0], f);
f0105bd2:	89 c2                	mov    %eax,%edx
f0105bd4:	c1 ea 10             	shr    $0x10,%edx
f0105bd7:	25 ff ff 00 00       	and    $0xffff,%eax
f0105bdc:	8b 8d 04 ff ff ff    	mov    -0xfc(%ebp),%ecx
f0105be2:	89 0c 24             	mov    %ecx,(%esp)
f0105be5:	b9 88 f3 11 f0       	mov    $0xf011f388,%ecx
f0105bea:	e8 91 fc ff ff       	call   f0105880 <pci_attach_match>
		}
		totaldev++;
		
		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f0105bef:	83 85 60 ff ff ff 01 	addl   $0x1,-0xa0(%ebp)
                	continue;
		}
		totaldev++;
		
		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0105bf6:	83 fb 01             	cmp    $0x1,%ebx
f0105bf9:	19 c0                	sbb    %eax,%eax
f0105bfb:	83 e0 f9             	and    $0xfffffff9,%eax
f0105bfe:	83 c0 08             	add    $0x8,%eax
f0105c01:	3b 85 60 ff ff ff    	cmp    -0xa0(%ebp),%eax
f0105c07:	0f 87 ba fe ff ff    	ja     f0105ac7 <pci_scan_bus+0xb2>
		//cprintf(" bhlc%x  %x bus %x  dev %x\n",bhlc,PCI_HDRTYPE_TYPE(bhlc),df.func,df.dev);
                 if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
		{    //cprintf("%d\n",totaldev);
                	continue;
		}
		totaldev++;
f0105c0d:	83 85 fc fe ff ff 01 	addl   $0x1,-0x104(%ebp)
	int totaldev = 0;
	struct pci_func df;
	memset(&df, 0, sizeof(df));
	df.bus = bus;
	
	for (df.dev = 0; df.dev < 32; df.dev++) {
f0105c14:	8b 45 a4             	mov    -0x5c(%ebp),%eax
f0105c17:	83 c0 01             	add    $0x1,%eax
f0105c1a:	83 f8 1f             	cmp    $0x1f,%eax
f0105c1d:	77 08                	ja     f0105c27 <pci_scan_bus+0x212>
f0105c1f:	89 45 a4             	mov    %eax,-0x5c(%ebp)
f0105c22:	e9 58 fe ff ff       	jmp    f0105a7f <pci_scan_bus+0x6a>
			pci_attach(&af);
		}
	}
	
	return totaldev;
}
f0105c27:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
f0105c2d:	81 c4 3c 01 00 00    	add    $0x13c,%esp
f0105c33:	5b                   	pop    %ebx
f0105c34:	5e                   	pop    %esi
f0105c35:	5f                   	pop    %edi
f0105c36:	5d                   	pop    %ebp
f0105c37:	c3                   	ret    

f0105c38 <pci_init>:
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
}

int
pci_init(void)
{
f0105c38:	55                   	push   %ebp
f0105c39:	89 e5                	mov    %esp,%ebp
f0105c3b:	83 ec 18             	sub    $0x18,%esp
	static struct pci_bus root_bus;
	memset(&root_bus, 0, sizeof(root_bus));
f0105c3e:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
f0105c45:	00 
f0105c46:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0105c4d:	00 
f0105c4e:	c7 04 24 a0 3f 2d f0 	movl   $0xf02d3fa0,(%esp)
f0105c55:	e8 2c f5 ff ff       	call   f0105186 <memset>
	
	return pci_scan_bus(&root_bus);
f0105c5a:	b8 a0 3f 2d f0       	mov    $0xf02d3fa0,%eax
f0105c5f:	e8 b1 fd ff ff       	call   f0105a15 <pci_scan_bus>
}
f0105c64:	c9                   	leave  
f0105c65:	c3                   	ret    

f0105c66 <pci_bridge_attach>:
	return totaldev;
}

static int
pci_bridge_attach(struct pci_func *pcif)
{
f0105c66:	55                   	push   %ebp
f0105c67:	89 e5                	mov    %esp,%ebp
f0105c69:	83 ec 48             	sub    $0x48,%esp
f0105c6c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
f0105c6f:	89 75 f8             	mov    %esi,-0x8(%ebp)
f0105c72:	89 7d fc             	mov    %edi,-0x4(%ebp)
f0105c75:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f0105c78:	ba 1c 00 00 00       	mov    $0x1c,%edx
f0105c7d:	89 d8                	mov    %ebx,%eax
f0105c7f:	e8 69 fd ff ff       	call   f01059ed <pci_conf_read>
f0105c84:	89 c7                	mov    %eax,%edi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f0105c86:	ba 18 00 00 00       	mov    $0x18,%edx
f0105c8b:	89 d8                	mov    %ebx,%eax
f0105c8d:	e8 5b fd ff ff       	call   f01059ed <pci_conf_read>
f0105c92:	89 c6                	mov    %eax,%esi
	
	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0105c94:	83 e7 0f             	and    $0xf,%edi
f0105c97:	83 ff 01             	cmp    $0x1,%edi
f0105c9a:	75 2a                	jne    f0105cc6 <pci_bridge_attach+0x60>
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f0105c9c:	8b 43 08             	mov    0x8(%ebx),%eax
f0105c9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105ca3:	8b 43 04             	mov    0x4(%ebx),%eax
f0105ca6:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105caa:	8b 03                	mov    (%ebx),%eax
f0105cac:	8b 40 04             	mov    0x4(%eax),%eax
f0105caf:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105cb3:	c7 04 24 6c 78 10 f0 	movl   $0xf010786c,(%esp)
f0105cba:	e8 00 d7 ff ff       	call   f01033bf <cprintf>
f0105cbf:	b8 00 00 00 00       	mov    $0x0,%eax
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
f0105cc4:	eb 66                	jmp    f0105d2c <pci_bridge_attach+0xc6>
	}
	
	struct pci_bus nbus;
	memset(&nbus, 0, sizeof(nbus));
f0105cc6:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
f0105ccd:	00 
f0105cce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f0105cd5:	00 
f0105cd6:	8d 7d e0             	lea    -0x20(%ebp),%edi
f0105cd9:	89 3c 24             	mov    %edi,(%esp)
f0105cdc:	e8 a5 f4 ff ff       	call   f0105186 <memset>
	nbus.parent_bridge = pcif;
f0105ce1:	89 5d e0             	mov    %ebx,-0x20(%ebp)
	nbus.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff;
f0105ce4:	89 f2                	mov    %esi,%edx
f0105ce6:	0f b6 c6             	movzbl %dh,%eax
f0105ce9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	
	if (pci_show_devs)
		cprintf("PCI: %02x:%02x.%d: bridge to PCI bus %d--%d\n",
f0105cec:	c1 ee 10             	shr    $0x10,%esi
f0105cef:	81 e6 ff 00 00 00    	and    $0xff,%esi
f0105cf5:	89 74 24 14          	mov    %esi,0x14(%esp)
f0105cf9:	89 44 24 10          	mov    %eax,0x10(%esp)
f0105cfd:	8b 43 08             	mov    0x8(%ebx),%eax
f0105d00:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105d04:	8b 43 04             	mov    0x4(%ebx),%eax
f0105d07:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105d0b:	8b 03                	mov    (%ebx),%eax
f0105d0d:	8b 40 04             	mov    0x4(%eax),%eax
f0105d10:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105d14:	c7 04 24 a0 78 10 f0 	movl   $0xf01078a0,(%esp)
f0105d1b:	e8 9f d6 ff ff       	call   f01033bf <cprintf>
			pcif->bus->busno, pcif->dev, pcif->func,
			nbus.busno,
			(busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
	
	pci_scan_bus(&nbus);
f0105d20:	89 f8                	mov    %edi,%eax
f0105d22:	e8 ee fc ff ff       	call   f0105a15 <pci_scan_bus>
f0105d27:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
}
f0105d2c:	8b 5d f4             	mov    -0xc(%ebp),%ebx
f0105d2f:	8b 75 f8             	mov    -0x8(%ebp),%esi
f0105d32:	8b 7d fc             	mov    -0x4(%ebp),%edi
f0105d35:	89 ec                	mov    %ebp,%esp
f0105d37:	5d                   	pop    %ebp
f0105d38:	c3                   	ret    

f0105d39 <pci_conf_write>:
	return inl(pci_conf1_data_ioport);
}

static void
pci_conf_write(struct pci_func *f, uint32_t off, uint32_t v)
{
f0105d39:	55                   	push   %ebp
f0105d3a:	89 e5                	mov    %esp,%ebp
f0105d3c:	83 ec 18             	sub    $0x18,%esp
f0105d3f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
f0105d42:	89 75 fc             	mov    %esi,-0x4(%ebp)
f0105d45:	89 d3                	mov    %edx,%ebx
f0105d47:	89 ce                	mov    %ecx,%esi
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0105d49:	8b 48 08             	mov    0x8(%eax),%ecx
f0105d4c:	8b 50 04             	mov    0x4(%eax),%edx
f0105d4f:	8b 00                	mov    (%eax),%eax
f0105d51:	8b 40 04             	mov    0x4(%eax),%eax
f0105d54:	89 1c 24             	mov    %ebx,(%esp)
f0105d57:	e8 95 fb ff ff       	call   f01058f1 <pci_conf1_set_addr>
}

static __inline void
outl(int port, uint32_t data)
{
	__asm __volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0105d5c:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0105d61:	89 f0                	mov    %esi,%eax
f0105d63:	ef                   	out    %eax,(%dx)
	outl(pci_conf1_data_ioport, v);
}
f0105d64:	8b 5d f8             	mov    -0x8(%ebp),%ebx
f0105d67:	8b 75 fc             	mov    -0x4(%ebp),%esi
f0105d6a:	89 ec                	mov    %ebp,%esp
f0105d6c:	5d                   	pop    %ebp
f0105d6d:	c3                   	ret    

f0105d6e <pci_func_enable>:

// External PCI subsystem interface

void
pci_func_enable(struct pci_func *f)
{
f0105d6e:	55                   	push   %ebp
f0105d6f:	89 e5                	mov    %esp,%ebp
f0105d71:	57                   	push   %edi
f0105d72:	56                   	push   %esi
f0105d73:	53                   	push   %ebx
f0105d74:	83 ec 4c             	sub    $0x4c,%esp
f0105d77:	8b 5d 08             	mov    0x8(%ebp),%ebx
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f0105d7a:	b9 07 00 00 00       	mov    $0x7,%ecx
f0105d7f:	ba 04 00 00 00       	mov    $0x4,%edx
f0105d84:	89 d8                	mov    %ebx,%eax
f0105d86:	e8 ae ff ff ff       	call   f0105d39 <pci_conf_write>
f0105d8b:	be 10 00 00 00       	mov    $0x10,%esi
	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
	{
		uint32_t oldv = pci_conf_read(f, bar);
f0105d90:	89 f2                	mov    %esi,%edx
f0105d92:	89 d8                	mov    %ebx,%eax
f0105d94:	e8 54 fc ff ff       	call   f01059ed <pci_conf_read>
f0105d99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		
		bar_width = 4;
		pci_conf_write(f, bar, 0xffffffff);
f0105d9c:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0105da1:	89 f2                	mov    %esi,%edx
f0105da3:	89 d8                	mov    %ebx,%eax
f0105da5:	e8 8f ff ff ff       	call   f0105d39 <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f0105daa:	89 f2                	mov    %esi,%edx
f0105dac:	89 d8                	mov    %ebx,%eax
f0105dae:	e8 3a fc ff ff       	call   f01059ed <pci_conf_read>
		 //cprintf("\nrv%x Macro%x\n",rv,oldv);

		if (rv == 0)
f0105db3:	bf 04 00 00 00       	mov    $0x4,%edi
f0105db8:	85 c0                	test   %eax,%eax
f0105dba:	0f 84 c4 00 00 00    	je     f0105e84 <pci_func_enable+0x116>
			continue;
	//	cprintf("\nrv%x Macro%x\n",rv,oldv);
		int regnum = PCI_MAPREG_NUM(bar);
f0105dc0:	8d 56 f0             	lea    -0x10(%esi),%edx
f0105dc3:	c1 ea 02             	shr    $0x2,%edx
f0105dc6:	89 55 e0             	mov    %edx,-0x20(%ebp)
		uint32_t base, size;
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f0105dc9:	a8 01                	test   $0x1,%al
f0105dcb:	75 2c                	jne    f0105df9 <pci_func_enable+0x8b>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f0105dcd:	89 c2                	mov    %eax,%edx
f0105dcf:	83 e2 06             	and    $0x6,%edx
f0105dd2:	83 fa 04             	cmp    $0x4,%edx
f0105dd5:	0f 94 c2             	sete   %dl
f0105dd8:	0f b6 fa             	movzbl %dl,%edi
f0105ddb:	8d 3c bd 04 00 00 00 	lea    0x4(,%edi,4),%edi
				bar_width = 8;
			
			size = PCI_MAPREG_MEM_SIZE(rv);
f0105de2:	83 e0 f0             	and    $0xfffffff0,%eax
f0105de5:	89 c2                	mov    %eax,%edx
f0105de7:	f7 da                	neg    %edx
f0105de9:	21 d0                	and    %edx,%eax
f0105deb:	89 45 dc             	mov    %eax,-0x24(%ebp)
			base = PCI_MAPREG_MEM_ADDR(oldv);
f0105dee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105df1:	83 e0 f0             	and    $0xfffffff0,%eax
f0105df4:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105df7:	eb 1a                	jmp    f0105e13 <pci_func_enable+0xa5>
			if (pci_show_addrs)
				cprintf("  mem region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		} else {
			size = PCI_MAPREG_IO_SIZE(rv);
f0105df9:	83 e0 fc             	and    $0xfffffffc,%eax
f0105dfc:	89 c2                	mov    %eax,%edx
f0105dfe:	f7 da                	neg    %edx
f0105e00:	21 d0                	and    %edx,%eax
f0105e02:	89 45 dc             	mov    %eax,-0x24(%ebp)
			base = PCI_MAPREG_IO_ADDR(oldv);
f0105e05:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0105e08:	83 e2 fc             	and    $0xfffffffc,%edx
f0105e0b:	89 55 d8             	mov    %edx,-0x28(%ebp)
f0105e0e:	bf 04 00 00 00       	mov    $0x4,%edi
			if (pci_show_addrs)
				cprintf("  io region %d: %d bytes at 0x%x\n",
					regnum, size, base);
		}
		
		pci_conf_write(f, bar, oldv);
f0105e13:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0105e16:	89 f2                	mov    %esi,%edx
f0105e18:	89 d8                	mov    %ebx,%eax
f0105e1a:	e8 1a ff ff ff       	call   f0105d39 <pci_conf_write>
		f->reg_base[regnum] = base;
f0105e1f:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105e22:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105e25:	89 54 83 14          	mov    %edx,0x14(%ebx,%eax,4)
		f->reg_size[regnum] = size;
f0105e29:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0105e2c:	89 54 83 2c          	mov    %edx,0x2c(%ebx,%eax,4)
		
		if (size && !base)
f0105e30:	85 d2                	test   %edx,%edx
f0105e32:	74 50                	je     f0105e84 <pci_func_enable+0x116>
f0105e34:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f0105e38:	75 4a                	jne    f0105e84 <pci_func_enable+0x116>
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
				"may be misconfigured: "
				"region %d: base 0x%x, size %d\n",
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0105e3a:	8b 43 0c             	mov    0xc(%ebx),%eax
		pci_conf_write(f, bar, oldv);
		f->reg_base[regnum] = base;
		f->reg_size[regnum] = size;
		
		if (size && !base)
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f0105e3d:	89 54 24 20          	mov    %edx,0x20(%esp)
f0105e41:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105e44:	89 54 24 1c          	mov    %edx,0x1c(%esp)
f0105e48:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0105e4b:	89 54 24 18          	mov    %edx,0x18(%esp)
f0105e4f:	89 c2                	mov    %eax,%edx
f0105e51:	c1 ea 10             	shr    $0x10,%edx
f0105e54:	89 54 24 14          	mov    %edx,0x14(%esp)
f0105e58:	25 ff ff 00 00       	and    $0xffff,%eax
f0105e5d:	89 44 24 10          	mov    %eax,0x10(%esp)
f0105e61:	8b 43 08             	mov    0x8(%ebx),%eax
f0105e64:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105e68:	8b 43 04             	mov    0x4(%ebx),%eax
f0105e6b:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105e6f:	8b 03                	mov    (%ebx),%eax
f0105e71:	8b 40 04             	mov    0x4(%eax),%eax
f0105e74:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105e78:	c7 04 24 d0 78 10 f0 	movl   $0xf01078d0,(%esp)
f0105e7f:	e8 3b d5 ff ff       	call   f01033bf <cprintf>
		       PCI_COMMAND_MASTER_ENABLE);
	
	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
	     bar += bar_width)
f0105e84:	01 fe                	add    %edi,%esi
		       PCI_COMMAND_MEM_ENABLE |
		       PCI_COMMAND_MASTER_ENABLE);
	
	uint32_t bar_width;
	uint32_t bar;
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END;
f0105e86:	83 fe 27             	cmp    $0x27,%esi
f0105e89:	0f 86 01 ff ff ff    	jbe    f0105d90 <pci_func_enable+0x22>
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f0105e8f:	8b 43 0c             	mov    0xc(%ebx),%eax
				f->bus->busno, f->dev, f->func,
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
				regnum, base, size);
	}

	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f0105e92:	89 c2                	mov    %eax,%edx
f0105e94:	c1 ea 10             	shr    $0x10,%edx
f0105e97:	89 54 24 14          	mov    %edx,0x14(%esp)
f0105e9b:	25 ff ff 00 00       	and    $0xffff,%eax
f0105ea0:	89 44 24 10          	mov    %eax,0x10(%esp)
f0105ea4:	8b 43 08             	mov    0x8(%ebx),%eax
f0105ea7:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0105eab:	8b 43 04             	mov    0x4(%ebx),%eax
f0105eae:	89 44 24 08          	mov    %eax,0x8(%esp)
f0105eb2:	8b 03                	mov    (%ebx),%eax
f0105eb4:	8b 40 04             	mov    0x4(%eax),%eax
f0105eb7:	89 44 24 04          	mov    %eax,0x4(%esp)
f0105ebb:	c7 04 24 2c 79 10 f0 	movl   $0xf010792c,(%esp)
f0105ec2:	e8 f8 d4 ff ff       	call   f01033bf <cprintf>
		f->bus->busno, f->dev, f->func,
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
}
f0105ec7:	83 c4 4c             	add    $0x4c,%esp
f0105eca:	5b                   	pop    %ebx
f0105ecb:	5e                   	pop    %esi
f0105ecc:	5f                   	pop    %edi
f0105ecd:	5d                   	pop    %ebp
f0105ece:	c3                   	ret    
	...

f0105ed0 <time_init>:

static unsigned int ticks;

void
time_init(void) 
{
f0105ed0:	55                   	push   %ebp
f0105ed1:	89 e5                	mov    %esp,%ebp
	ticks = 0;
f0105ed3:	c7 05 a8 3f 2d f0 00 	movl   $0x0,0xf02d3fa8
f0105eda:	00 00 00 
}
f0105edd:	5d                   	pop    %ebp
f0105ede:	c3                   	ret    

f0105edf <time_msec>:
		panic("time_tick: time overflowed");
}

unsigned int
time_msec(void) 
{
f0105edf:	55                   	push   %ebp
f0105ee0:	89 e5                	mov    %esp,%ebp
f0105ee2:	a1 a8 3f 2d f0       	mov    0xf02d3fa8,%eax
f0105ee7:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0105eea:	01 c0                	add    %eax,%eax
	return ticks * 10;
}
f0105eec:	5d                   	pop    %ebp
f0105eed:	c3                   	ret    

f0105eee <time_tick>:

// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void) 
{
f0105eee:	55                   	push   %ebp
f0105eef:	89 e5                	mov    %esp,%ebp
f0105ef1:	83 ec 18             	sub    $0x18,%esp
	ticks++;
f0105ef4:	a1 a8 3f 2d f0       	mov    0xf02d3fa8,%eax
f0105ef9:	83 c0 01             	add    $0x1,%eax
f0105efc:	a3 a8 3f 2d f0       	mov    %eax,0xf02d3fa8
	if (ticks * 10 < ticks)
f0105f01:	8d 14 80             	lea    (%eax,%eax,4),%edx
f0105f04:	01 d2                	add    %edx,%edx
f0105f06:	39 d0                	cmp    %edx,%eax
f0105f08:	76 1c                	jbe    f0105f26 <time_tick+0x38>
		panic("time_tick: time overflowed");
f0105f0a:	c7 44 24 08 34 7a 10 	movl   $0xf0107a34,0x8(%esp)
f0105f11:	f0 
f0105f12:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
f0105f19:	00 
f0105f1a:	c7 04 24 4f 7a 10 f0 	movl   $0xf0107a4f,(%esp)
f0105f21:	e8 5f a1 ff ff       	call   f0100085 <_panic>
}
f0105f26:	c9                   	leave  
f0105f27:	c3                   	ret    
	...

f0105f30 <__udivdi3>:
f0105f30:	55                   	push   %ebp
f0105f31:	89 e5                	mov    %esp,%ebp
f0105f33:	57                   	push   %edi
f0105f34:	56                   	push   %esi
f0105f35:	83 ec 10             	sub    $0x10,%esp
f0105f38:	8b 45 14             	mov    0x14(%ebp),%eax
f0105f3b:	8b 55 08             	mov    0x8(%ebp),%edx
f0105f3e:	8b 75 10             	mov    0x10(%ebp),%esi
f0105f41:	8b 7d 0c             	mov    0xc(%ebp),%edi
f0105f44:	85 c0                	test   %eax,%eax
f0105f46:	89 55 f0             	mov    %edx,-0x10(%ebp)
f0105f49:	75 35                	jne    f0105f80 <__udivdi3+0x50>
f0105f4b:	39 fe                	cmp    %edi,%esi
f0105f4d:	77 61                	ja     f0105fb0 <__udivdi3+0x80>
f0105f4f:	85 f6                	test   %esi,%esi
f0105f51:	75 0b                	jne    f0105f5e <__udivdi3+0x2e>
f0105f53:	b8 01 00 00 00       	mov    $0x1,%eax
f0105f58:	31 d2                	xor    %edx,%edx
f0105f5a:	f7 f6                	div    %esi
f0105f5c:	89 c6                	mov    %eax,%esi
f0105f5e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
f0105f61:	31 d2                	xor    %edx,%edx
f0105f63:	89 f8                	mov    %edi,%eax
f0105f65:	f7 f6                	div    %esi
f0105f67:	89 c7                	mov    %eax,%edi
f0105f69:	89 c8                	mov    %ecx,%eax
f0105f6b:	f7 f6                	div    %esi
f0105f6d:	89 c1                	mov    %eax,%ecx
f0105f6f:	89 fa                	mov    %edi,%edx
f0105f71:	89 c8                	mov    %ecx,%eax
f0105f73:	83 c4 10             	add    $0x10,%esp
f0105f76:	5e                   	pop    %esi
f0105f77:	5f                   	pop    %edi
f0105f78:	5d                   	pop    %ebp
f0105f79:	c3                   	ret    
f0105f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0105f80:	39 f8                	cmp    %edi,%eax
f0105f82:	77 1c                	ja     f0105fa0 <__udivdi3+0x70>
f0105f84:	0f bd d0             	bsr    %eax,%edx
f0105f87:	83 f2 1f             	xor    $0x1f,%edx
f0105f8a:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0105f8d:	75 39                	jne    f0105fc8 <__udivdi3+0x98>
f0105f8f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
f0105f92:	0f 86 a0 00 00 00    	jbe    f0106038 <__udivdi3+0x108>
f0105f98:	39 f8                	cmp    %edi,%eax
f0105f9a:	0f 82 98 00 00 00    	jb     f0106038 <__udivdi3+0x108>
f0105fa0:	31 ff                	xor    %edi,%edi
f0105fa2:	31 c9                	xor    %ecx,%ecx
f0105fa4:	89 c8                	mov    %ecx,%eax
f0105fa6:	89 fa                	mov    %edi,%edx
f0105fa8:	83 c4 10             	add    $0x10,%esp
f0105fab:	5e                   	pop    %esi
f0105fac:	5f                   	pop    %edi
f0105fad:	5d                   	pop    %ebp
f0105fae:	c3                   	ret    
f0105faf:	90                   	nop
f0105fb0:	89 d1                	mov    %edx,%ecx
f0105fb2:	89 fa                	mov    %edi,%edx
f0105fb4:	89 c8                	mov    %ecx,%eax
f0105fb6:	31 ff                	xor    %edi,%edi
f0105fb8:	f7 f6                	div    %esi
f0105fba:	89 c1                	mov    %eax,%ecx
f0105fbc:	89 fa                	mov    %edi,%edx
f0105fbe:	89 c8                	mov    %ecx,%eax
f0105fc0:	83 c4 10             	add    $0x10,%esp
f0105fc3:	5e                   	pop    %esi
f0105fc4:	5f                   	pop    %edi
f0105fc5:	5d                   	pop    %ebp
f0105fc6:	c3                   	ret    
f0105fc7:	90                   	nop
f0105fc8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0105fcc:	89 f2                	mov    %esi,%edx
f0105fce:	d3 e0                	shl    %cl,%eax
f0105fd0:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105fd3:	b8 20 00 00 00       	mov    $0x20,%eax
f0105fd8:	2b 45 f4             	sub    -0xc(%ebp),%eax
f0105fdb:	89 c1                	mov    %eax,%ecx
f0105fdd:	d3 ea                	shr    %cl,%edx
f0105fdf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0105fe3:	0b 55 ec             	or     -0x14(%ebp),%edx
f0105fe6:	d3 e6                	shl    %cl,%esi
f0105fe8:	89 c1                	mov    %eax,%ecx
f0105fea:	89 75 e8             	mov    %esi,-0x18(%ebp)
f0105fed:	89 fe                	mov    %edi,%esi
f0105fef:	d3 ee                	shr    %cl,%esi
f0105ff1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f0105ff5:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0105ff8:	8b 55 f0             	mov    -0x10(%ebp),%edx
f0105ffb:	d3 e7                	shl    %cl,%edi
f0105ffd:	89 c1                	mov    %eax,%ecx
f0105fff:	d3 ea                	shr    %cl,%edx
f0106001:	09 d7                	or     %edx,%edi
f0106003:	89 f2                	mov    %esi,%edx
f0106005:	89 f8                	mov    %edi,%eax
f0106007:	f7 75 ec             	divl   -0x14(%ebp)
f010600a:	89 d6                	mov    %edx,%esi
f010600c:	89 c7                	mov    %eax,%edi
f010600e:	f7 65 e8             	mull   -0x18(%ebp)
f0106011:	39 d6                	cmp    %edx,%esi
f0106013:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0106016:	72 30                	jb     f0106048 <__udivdi3+0x118>
f0106018:	8b 55 f0             	mov    -0x10(%ebp),%edx
f010601b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
f010601f:	d3 e2                	shl    %cl,%edx
f0106021:	39 c2                	cmp    %eax,%edx
f0106023:	73 05                	jae    f010602a <__udivdi3+0xfa>
f0106025:	3b 75 ec             	cmp    -0x14(%ebp),%esi
f0106028:	74 1e                	je     f0106048 <__udivdi3+0x118>
f010602a:	89 f9                	mov    %edi,%ecx
f010602c:	31 ff                	xor    %edi,%edi
f010602e:	e9 71 ff ff ff       	jmp    f0105fa4 <__udivdi3+0x74>
f0106033:	90                   	nop
f0106034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106038:	31 ff                	xor    %edi,%edi
f010603a:	b9 01 00 00 00       	mov    $0x1,%ecx
f010603f:	e9 60 ff ff ff       	jmp    f0105fa4 <__udivdi3+0x74>
f0106044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106048:	8d 4f ff             	lea    -0x1(%edi),%ecx
f010604b:	31 ff                	xor    %edi,%edi
f010604d:	89 c8                	mov    %ecx,%eax
f010604f:	89 fa                	mov    %edi,%edx
f0106051:	83 c4 10             	add    $0x10,%esp
f0106054:	5e                   	pop    %esi
f0106055:	5f                   	pop    %edi
f0106056:	5d                   	pop    %ebp
f0106057:	c3                   	ret    
	...

f0106060 <__umoddi3>:
f0106060:	55                   	push   %ebp
f0106061:	89 e5                	mov    %esp,%ebp
f0106063:	57                   	push   %edi
f0106064:	56                   	push   %esi
f0106065:	83 ec 20             	sub    $0x20,%esp
f0106068:	8b 55 14             	mov    0x14(%ebp),%edx
f010606b:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010606e:	8b 7d 10             	mov    0x10(%ebp),%edi
f0106071:	8b 75 0c             	mov    0xc(%ebp),%esi
f0106074:	85 d2                	test   %edx,%edx
f0106076:	89 c8                	mov    %ecx,%eax
f0106078:	89 4d f4             	mov    %ecx,-0xc(%ebp)
f010607b:	75 13                	jne    f0106090 <__umoddi3+0x30>
f010607d:	39 f7                	cmp    %esi,%edi
f010607f:	76 3f                	jbe    f01060c0 <__umoddi3+0x60>
f0106081:	89 f2                	mov    %esi,%edx
f0106083:	f7 f7                	div    %edi
f0106085:	89 d0                	mov    %edx,%eax
f0106087:	31 d2                	xor    %edx,%edx
f0106089:	83 c4 20             	add    $0x20,%esp
f010608c:	5e                   	pop    %esi
f010608d:	5f                   	pop    %edi
f010608e:	5d                   	pop    %ebp
f010608f:	c3                   	ret    
f0106090:	39 f2                	cmp    %esi,%edx
f0106092:	77 4c                	ja     f01060e0 <__umoddi3+0x80>
f0106094:	0f bd ca             	bsr    %edx,%ecx
f0106097:	83 f1 1f             	xor    $0x1f,%ecx
f010609a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f010609d:	75 51                	jne    f01060f0 <__umoddi3+0x90>
f010609f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
f01060a2:	0f 87 e0 00 00 00    	ja     f0106188 <__umoddi3+0x128>
f01060a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01060ab:	29 f8                	sub    %edi,%eax
f01060ad:	19 d6                	sbb    %edx,%esi
f01060af:	89 45 f4             	mov    %eax,-0xc(%ebp)
f01060b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01060b5:	89 f2                	mov    %esi,%edx
f01060b7:	83 c4 20             	add    $0x20,%esp
f01060ba:	5e                   	pop    %esi
f01060bb:	5f                   	pop    %edi
f01060bc:	5d                   	pop    %ebp
f01060bd:	c3                   	ret    
f01060be:	66 90                	xchg   %ax,%ax
f01060c0:	85 ff                	test   %edi,%edi
f01060c2:	75 0b                	jne    f01060cf <__umoddi3+0x6f>
f01060c4:	b8 01 00 00 00       	mov    $0x1,%eax
f01060c9:	31 d2                	xor    %edx,%edx
f01060cb:	f7 f7                	div    %edi
f01060cd:	89 c7                	mov    %eax,%edi
f01060cf:	89 f0                	mov    %esi,%eax
f01060d1:	31 d2                	xor    %edx,%edx
f01060d3:	f7 f7                	div    %edi
f01060d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
f01060d8:	f7 f7                	div    %edi
f01060da:	eb a9                	jmp    f0106085 <__umoddi3+0x25>
f01060dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01060e0:	89 c8                	mov    %ecx,%eax
f01060e2:	89 f2                	mov    %esi,%edx
f01060e4:	83 c4 20             	add    $0x20,%esp
f01060e7:	5e                   	pop    %esi
f01060e8:	5f                   	pop    %edi
f01060e9:	5d                   	pop    %ebp
f01060ea:	c3                   	ret    
f01060eb:	90                   	nop
f01060ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01060f0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f01060f4:	d3 e2                	shl    %cl,%edx
f01060f6:	89 55 f4             	mov    %edx,-0xc(%ebp)
f01060f9:	ba 20 00 00 00       	mov    $0x20,%edx
f01060fe:	2b 55 f0             	sub    -0x10(%ebp),%edx
f0106101:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0106104:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0106108:	89 fa                	mov    %edi,%edx
f010610a:	d3 ea                	shr    %cl,%edx
f010610c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0106110:	0b 55 f4             	or     -0xc(%ebp),%edx
f0106113:	d3 e7                	shl    %cl,%edi
f0106115:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0106119:	89 55 f4             	mov    %edx,-0xc(%ebp)
f010611c:	89 f2                	mov    %esi,%edx
f010611e:	89 7d e8             	mov    %edi,-0x18(%ebp)
f0106121:	89 c7                	mov    %eax,%edi
f0106123:	d3 ea                	shr    %cl,%edx
f0106125:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0106129:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f010612c:	89 c2                	mov    %eax,%edx
f010612e:	d3 e6                	shl    %cl,%esi
f0106130:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0106134:	d3 ea                	shr    %cl,%edx
f0106136:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f010613a:	09 d6                	or     %edx,%esi
f010613c:	89 f0                	mov    %esi,%eax
f010613e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0106141:	d3 e7                	shl    %cl,%edi
f0106143:	89 f2                	mov    %esi,%edx
f0106145:	f7 75 f4             	divl   -0xc(%ebp)
f0106148:	89 d6                	mov    %edx,%esi
f010614a:	f7 65 e8             	mull   -0x18(%ebp)
f010614d:	39 d6                	cmp    %edx,%esi
f010614f:	72 2b                	jb     f010617c <__umoddi3+0x11c>
f0106151:	39 c7                	cmp    %eax,%edi
f0106153:	72 23                	jb     f0106178 <__umoddi3+0x118>
f0106155:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0106159:	29 c7                	sub    %eax,%edi
f010615b:	19 d6                	sbb    %edx,%esi
f010615d:	89 f0                	mov    %esi,%eax
f010615f:	89 f2                	mov    %esi,%edx
f0106161:	d3 ef                	shr    %cl,%edi
f0106163:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0106167:	d3 e0                	shl    %cl,%eax
f0106169:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f010616d:	09 f8                	or     %edi,%eax
f010616f:	d3 ea                	shr    %cl,%edx
f0106171:	83 c4 20             	add    $0x20,%esp
f0106174:	5e                   	pop    %esi
f0106175:	5f                   	pop    %edi
f0106176:	5d                   	pop    %ebp
f0106177:	c3                   	ret    
f0106178:	39 d6                	cmp    %edx,%esi
f010617a:	75 d9                	jne    f0106155 <__umoddi3+0xf5>
f010617c:	2b 45 e8             	sub    -0x18(%ebp),%eax
f010617f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
f0106182:	eb d1                	jmp    f0106155 <__umoddi3+0xf5>
f0106184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0106188:	39 f2                	cmp    %esi,%edx
f010618a:	0f 82 18 ff ff ff    	jb     f01060a8 <__umoddi3+0x48>
f0106190:	e9 1d ff ff ff       	jmp    f01060b2 <__umoddi3+0x52>
