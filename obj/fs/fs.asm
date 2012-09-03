
obj/fs/fs:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 23 20 00 00       	call   802054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <ide_wait_ready>:

static int diskno = 1;

static int
ide_wait_ready(bool check_error)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	53                   	push   %ebx
  800044:	89 c1                	mov    %eax,%ecx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800046:	ba f7 01 00 00       	mov    $0x1f7,%edx
  80004b:	ec                   	in     (%dx),%al
	int r;

	while (((r = inb(0x1F7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
  80004c:	0f b6 d8             	movzbl %al,%ebx
  80004f:	89 d8                	mov    %ebx,%eax
  800051:	25 c0 00 00 00       	and    $0xc0,%eax
  800056:	83 f8 40             	cmp    $0x40,%eax
  800059:	75 f0                	jne    80004b <ide_wait_ready+0xb>
		/* do nothing */;

	if (check_error && (r & (IDE_DF|IDE_ERR)) != 0)
  80005b:	85 c9                	test   %ecx,%ecx
  80005d:	74 0a                	je     800069 <ide_wait_ready+0x29>
  80005f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800064:	f6 c3 21             	test   $0x21,%bl
  800067:	75 05                	jne    80006e <ide_wait_ready+0x2e>
  800069:	b8 00 00 00 00       	mov    $0x0,%eax
		return -1;
	return 0;
}
  80006e:	5b                   	pop    %ebx
  80006f:	5d                   	pop    %ebp
  800070:	c3                   	ret    

00800071 <ide_write>:
	return 0;
}

int
ide_write(uint32_t secno, const void *src, size_t nsecs)
{
  800071:	55                   	push   %ebp
  800072:	89 e5                	mov    %esp,%ebp
  800074:	57                   	push   %edi
  800075:	56                   	push   %esi
  800076:	53                   	push   %ebx
  800077:	83 ec 1c             	sub    $0x1c,%esp
  80007a:	8b 75 08             	mov    0x8(%ebp),%esi
  80007d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800080:	8b 7d 10             	mov    0x10(%ebp),%edi
	int r;
	
	assert(nsecs <= 256);
  800083:	81 ff 00 01 00 00    	cmp    $0x100,%edi
  800089:	76 24                	jbe    8000af <ide_write+0x3e>
  80008b:	c7 44 24 0c c0 48 80 	movl   $0x8048c0,0xc(%esp)
  800092:	00 
  800093:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  80009a:	00 
  80009b:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  8000a2:	00 
  8000a3:	c7 04 24 e2 48 80 00 	movl   $0x8048e2,(%esp)
  8000aa:	e8 11 20 00 00       	call   8020c0 <_panic>

	ide_wait_ready(0);
  8000af:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b4:	e8 87 ff ff ff       	call   800040 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  8000b9:	ba f2 01 00 00       	mov    $0x1f2,%edx
  8000be:	89 f8                	mov    %edi,%eax
  8000c0:	ee                   	out    %al,(%dx)
  8000c1:	b2 f3                	mov    $0xf3,%dl
  8000c3:	89 f0                	mov    %esi,%eax
  8000c5:	ee                   	out    %al,(%dx)
  8000c6:	89 f0                	mov    %esi,%eax
  8000c8:	c1 e8 08             	shr    $0x8,%eax
  8000cb:	b2 f4                	mov    $0xf4,%dl
  8000cd:	ee                   	out    %al,(%dx)
  8000ce:	89 f0                	mov    %esi,%eax
  8000d0:	c1 e8 10             	shr    $0x10,%eax
  8000d3:	b2 f5                	mov    $0xf5,%dl
  8000d5:	ee                   	out    %al,(%dx)
  8000d6:	a1 00 90 80 00       	mov    0x809000,%eax
  8000db:	83 e0 01             	and    $0x1,%eax
  8000de:	c1 e0 04             	shl    $0x4,%eax
  8000e1:	83 c8 e0             	or     $0xffffffe0,%eax
  8000e4:	c1 ee 18             	shr    $0x18,%esi
  8000e7:	83 e6 0f             	and    $0xf,%esi
  8000ea:	09 f0                	or     %esi,%eax
  8000ec:	b2 f6                	mov    $0xf6,%dl
  8000ee:	ee                   	out    %al,(%dx)
  8000ef:	b2 f7                	mov    $0xf7,%dl
  8000f1:	b8 30 00 00 00       	mov    $0x30,%eax
  8000f6:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  8000f7:	85 ff                	test   %edi,%edi
  8000f9:	74 2a                	je     800125 <ide_write+0xb4>
		if ((r = ide_wait_ready(1)) < 0)
  8000fb:	b8 01 00 00 00       	mov    $0x1,%eax
  800100:	e8 3b ff ff ff       	call   800040 <ide_wait_ready>
  800105:	85 c0                	test   %eax,%eax
  800107:	78 21                	js     80012a <ide_write+0xb9>
}

static __inline void
outsl(int port, const void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\toutsl"		:
  800109:	89 de                	mov    %ebx,%esi
  80010b:	b9 80 00 00 00       	mov    $0x80,%ecx
  800110:	ba f0 01 00 00       	mov    $0x1f0,%edx
  800115:	fc                   	cld    
  800116:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x30);	// CMD 0x30 means write sector

	for (; nsecs > 0; nsecs--, src += SECTSIZE) {
  800118:	83 ef 01             	sub    $0x1,%edi
  80011b:	74 08                	je     800125 <ide_write+0xb4>
  80011d:	81 c3 00 02 00 00    	add    $0x200,%ebx
  800123:	eb d6                	jmp    8000fb <ide_write+0x8a>
  800125:	b8 00 00 00 00       	mov    $0x0,%eax
			return r;
		outsl(0x1F0, src, SECTSIZE/4);
	}

	return 0;
}
  80012a:	83 c4 1c             	add    $0x1c,%esp
  80012d:	5b                   	pop    %ebx
  80012e:	5e                   	pop    %esi
  80012f:	5f                   	pop    %edi
  800130:	5d                   	pop    %ebp
  800131:	c3                   	ret    

00800132 <ide_read>:
	diskno = d;
}

int
ide_read(uint32_t secno, void *dst, size_t nsecs)
{
  800132:	55                   	push   %ebp
  800133:	89 e5                	mov    %esp,%ebp
  800135:	57                   	push   %edi
  800136:	56                   	push   %esi
  800137:	53                   	push   %ebx
  800138:	83 ec 1c             	sub    $0x1c,%esp
  80013b:	8b 7d 08             	mov    0x8(%ebp),%edi
  80013e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800141:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	assert(nsecs <= 256);
  800144:	81 fe 00 01 00 00    	cmp    $0x100,%esi
  80014a:	76 24                	jbe    800170 <ide_read+0x3e>
  80014c:	c7 44 24 0c c0 48 80 	movl   $0x8048c0,0xc(%esp)
  800153:	00 
  800154:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  80015b:	00 
  80015c:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  800163:	00 
  800164:	c7 04 24 e2 48 80 00 	movl   $0x8048e2,(%esp)
  80016b:	e8 50 1f 00 00       	call   8020c0 <_panic>

	ide_wait_ready(0);
  800170:	b8 00 00 00 00       	mov    $0x0,%eax
  800175:	e8 c6 fe ff ff       	call   800040 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  80017a:	ba f2 01 00 00       	mov    $0x1f2,%edx
  80017f:	89 f0                	mov    %esi,%eax
  800181:	ee                   	out    %al,(%dx)
  800182:	b2 f3                	mov    $0xf3,%dl
  800184:	89 f8                	mov    %edi,%eax
  800186:	ee                   	out    %al,(%dx)
  800187:	89 f8                	mov    %edi,%eax
  800189:	c1 e8 08             	shr    $0x8,%eax
  80018c:	b2 f4                	mov    $0xf4,%dl
  80018e:	ee                   	out    %al,(%dx)
  80018f:	89 f8                	mov    %edi,%eax
  800191:	c1 e8 10             	shr    $0x10,%eax
  800194:	b2 f5                	mov    $0xf5,%dl
  800196:	ee                   	out    %al,(%dx)
  800197:	a1 00 90 80 00       	mov    0x809000,%eax
  80019c:	83 e0 01             	and    $0x1,%eax
  80019f:	c1 e0 04             	shl    $0x4,%eax
  8001a2:	83 c8 e0             	or     $0xffffffe0,%eax
  8001a5:	c1 ef 18             	shr    $0x18,%edi
  8001a8:	83 e7 0f             	and    $0xf,%edi
  8001ab:	09 f8                	or     %edi,%eax
  8001ad:	b2 f6                	mov    $0xf6,%dl
  8001af:	ee                   	out    %al,(%dx)
  8001b0:	b2 f7                	mov    $0xf7,%dl
  8001b2:	b8 20 00 00 00       	mov    $0x20,%eax
  8001b7:	ee                   	out    %al,(%dx)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001b8:	85 f6                	test   %esi,%esi
  8001ba:	74 2a                	je     8001e6 <ide_read+0xb4>
		if ((r = ide_wait_ready(1)) < 0)
  8001bc:	b8 01 00 00 00       	mov    $0x1,%eax
  8001c1:	e8 7a fe ff ff       	call   800040 <ide_wait_ready>
  8001c6:	85 c0                	test   %eax,%eax
  8001c8:	78 21                	js     8001eb <ide_read+0xb9>
}

static __inline void
insl(int port, void *addr, int cnt)
{
	__asm __volatile("cld\n\trepne\n\tinsl"			:
  8001ca:	89 df                	mov    %ebx,%edi
  8001cc:	b9 80 00 00 00       	mov    $0x80,%ecx
  8001d1:	ba f0 01 00 00       	mov    $0x1f0,%edx
  8001d6:	fc                   	cld    
  8001d7:	f2 6d                	repnz insl (%dx),%es:(%edi)
	outb(0x1F4, (secno >> 8) & 0xFF);
	outb(0x1F5, (secno >> 16) & 0xFF);
	outb(0x1F6, 0xE0 | ((diskno&1)<<4) | ((secno>>24)&0x0F));
	outb(0x1F7, 0x20);	// CMD 0x20 means read sector

	for (; nsecs > 0; nsecs--, dst += SECTSIZE) {
  8001d9:	83 ee 01             	sub    $0x1,%esi
  8001dc:	74 08                	je     8001e6 <ide_read+0xb4>
  8001de:	81 c3 00 02 00 00    	add    $0x200,%ebx
  8001e4:	eb d6                	jmp    8001bc <ide_read+0x8a>
  8001e6:	b8 00 00 00 00       	mov    $0x0,%eax
			return r;
		insl(0x1F0, dst, SECTSIZE/4);
	}
	
	return 0;
}
  8001eb:	83 c4 1c             	add    $0x1c,%esp
  8001ee:	5b                   	pop    %ebx
  8001ef:	5e                   	pop    %esi
  8001f0:	5f                   	pop    %edi
  8001f1:	5d                   	pop    %ebp
  8001f2:	c3                   	ret    

008001f3 <ide_set_disk>:
	return (x < 1000);
}

void
ide_set_disk(int d)
{
  8001f3:	55                   	push   %ebp
  8001f4:	89 e5                	mov    %esp,%ebp
  8001f6:	83 ec 18             	sub    $0x18,%esp
  8001f9:	8b 45 08             	mov    0x8(%ebp),%eax
	if (d != 0 && d != 1)
  8001fc:	83 f8 01             	cmp    $0x1,%eax
  8001ff:	76 1c                	jbe    80021d <ide_set_disk+0x2a>
		panic("bad disk number");
  800201:	c7 44 24 08 eb 48 80 	movl   $0x8048eb,0x8(%esp)
  800208:	00 
  800209:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  800210:	00 
  800211:	c7 04 24 e2 48 80 00 	movl   $0x8048e2,(%esp)
  800218:	e8 a3 1e 00 00       	call   8020c0 <_panic>
	diskno = d;
  80021d:	a3 00 90 80 00       	mov    %eax,0x809000
}
  800222:	c9                   	leave  
  800223:	c3                   	ret    

00800224 <ide_probe_disk1>:
	return 0;
}

bool
ide_probe_disk1(void)
{
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	53                   	push   %ebx
  800228:	83 ec 14             	sub    $0x14,%esp
	int r, x;

	// wait for Device 0 to be ready
	ide_wait_ready(0);
  80022b:	b8 00 00 00 00       	mov    $0x0,%eax
  800230:	e8 0b fe ff ff       	call   800040 <ide_wait_ready>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800235:	ba f6 01 00 00       	mov    $0x1f6,%edx
  80023a:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
  80023f:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
  800240:	b2 f7                	mov    $0xf7,%dl
  800242:	ec                   	in     (%dx),%al

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0; 
  800243:	b9 01 00 00 00       	mov    $0x1,%ecx
  800248:	a8 a1                	test   $0xa1,%al
  80024a:	75 0f                	jne    80025b <ide_probe_disk1+0x37>
  80024c:	b1 00                	mov    $0x0,%cl
  80024e:	eb 10                	jmp    800260 <ide_probe_disk1+0x3c>
	     x < 1000 && ((r = inb(0x1F7)) & (IDE_BSY|IDE_DF|IDE_ERR)) != 0; 
	     x++)
  800250:	83 c1 01             	add    $0x1,%ecx

	// switch to Device 1
	outb(0x1F6, 0xE0 | (1<<4));

	// check for Device 1 to be ready for a while
	for (x = 0; 
  800253:	81 f9 e8 03 00 00    	cmp    $0x3e8,%ecx
  800259:	74 05                	je     800260 <ide_probe_disk1+0x3c>
  80025b:	ec                   	in     (%dx),%al
  80025c:	a8 a1                	test   $0xa1,%al
  80025e:	75 f0                	jne    800250 <ide_probe_disk1+0x2c>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
  800260:	ba f6 01 00 00       	mov    $0x1f6,%edx
  800265:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
  80026a:	ee                   	out    %al,(%dx)
		/* do nothing */;

	// switch back to Device 0
	outb(0x1F6, 0xE0 | (0<<4));

	cprintf("Device 1 presence: %d\n", (x < 1000));
  80026b:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
  800271:	0f 9e c3             	setle  %bl
  800274:	0f b6 db             	movzbl %bl,%ebx
  800277:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80027b:	c7 04 24 fb 48 80 00 	movl   $0x8048fb,(%esp)
  800282:	e8 fe 1e 00 00       	call   802185 <cprintf>
	return (x < 1000);
}
  800287:	89 d8                	mov    %ebx,%eax
  800289:	83 c4 14             	add    $0x14,%esp
  80028c:	5b                   	pop    %ebx
  80028d:	5d                   	pop    %ebp
  80028e:	c3                   	ret    
	...

00800290 <va_is_mapped>:
}

// Is this virtual address mapped?
bool
va_is_mapped(void *va)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
	return (vpd[PDX(va)] & PTE_P) && (vpt[VPN(va)] & PTE_P);
  800293:	8b 55 08             	mov    0x8(%ebp),%edx
  800296:	89 d0                	mov    %edx,%eax
  800298:	c1 e8 16             	shr    $0x16,%eax
  80029b:	8b 0c 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%ecx
  8002a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8002a7:	f6 c1 01             	test   $0x1,%cl
  8002aa:	74 0d                	je     8002b9 <va_is_mapped+0x29>
  8002ac:	c1 ea 0c             	shr    $0xc,%edx
  8002af:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8002b6:	83 e0 01             	and    $0x1,%eax
}
  8002b9:	5d                   	pop    %ebp
  8002ba:	c3                   	ret    

008002bb <va_is_dirty>:

// Is this virtual address dirty?
bool
va_is_dirty(void *va)
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
	return (vpt[VPN(va)] & PTE_D) != 0;
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	c1 e8 0c             	shr    $0xc,%eax
  8002c4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8002cb:	c1 e8 06             	shr    $0x6,%eax
  8002ce:	83 e0 01             	and    $0x1,%eax
}
  8002d1:	5d                   	pop    %ebp
  8002d2:	c3                   	ret    

008002d3 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint32_t blockno)
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	83 ec 18             	sub    $0x18,%esp
  8002d9:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  8002dc:	85 c0                	test   %eax,%eax
  8002de:	74 0f                	je     8002ef <diskaddr+0x1c>
  8002e0:	8b 15 e4 d0 80 00    	mov    0x80d0e4,%edx
  8002e6:	85 d2                	test   %edx,%edx
  8002e8:	74 25                	je     80030f <diskaddr+0x3c>
  8002ea:	3b 42 04             	cmp    0x4(%edx),%eax
  8002ed:	72 20                	jb     80030f <diskaddr+0x3c>
		panic("bad block number %08x in diskaddr", blockno);
  8002ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002f3:	c7 44 24 08 14 49 80 	movl   $0x804914,0x8(%esp)
  8002fa:	00 
  8002fb:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  800302:	00 
  800303:	c7 04 24 d4 49 80 00 	movl   $0x8049d4,(%esp)
  80030a:	e8 b1 1d 00 00       	call   8020c0 <_panic>
  80030f:	05 00 00 01 00       	add    $0x10000,%eax
  800314:	c1 e0 0c             	shl    $0xc,%eax
	return (char*) (DISKMAP + blockno * BLKSIZE);
}
  800317:	c9                   	leave  
  800318:	c3                   	ret    

00800319 <bc_pgfault>:
// Fault any disk block that is read or written in to memory by
// loading it from disk.
// Hint: Use ide_read and BLKSECTS.
static void
bc_pgfault(struct UTrapframe *utf)
{
  800319:	55                   	push   %ebp
  80031a:	89 e5                	mov    %esp,%ebp
  80031c:	56                   	push   %esi
  80031d:	53                   	push   %ebx
  80031e:	83 ec 20             	sub    $0x20,%esp
  800321:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800324:	8b 18                	mov    (%eax),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800326:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
  80032c:	81 fa ff ff ff bf    	cmp    $0xbfffffff,%edx
  800332:	76 2e                	jbe    800362 <bc_pgfault+0x49>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  800334:	8b 50 04             	mov    0x4(%eax),%edx
  800337:	89 54 24 14          	mov    %edx,0x14(%esp)
  80033b:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  80033f:	8b 40 28             	mov    0x28(%eax),%eax
  800342:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800346:	c7 44 24 08 38 49 80 	movl   $0x804938,0x8(%esp)
  80034d:	00 
  80034e:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  800355:	00 
  800356:	c7 04 24 d4 49 80 00 	movl   $0x8049d4,(%esp)
  80035d:	e8 5e 1d 00 00       	call   8020c0 <_panic>

	// Allocate a page in the disk map region and read the
	// contents of the block from the disk into that page.
	//
	// LAB 5: Your code here
           if(sys_page_alloc(0,ROUNDDOWN(addr,PGSIZE),PTE_W|PTE_U|PTE_P)<0)
  800362:	89 de                	mov    %ebx,%esi
  800364:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  80036a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800371:	00 
  800372:	89 74 24 04          	mov    %esi,0x4(%esp)
  800376:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80037d:	e8 44 2c 00 00       	call   802fc6 <sys_page_alloc>
  800382:	85 c0                	test   %eax,%eax
  800384:	79 1c                	jns    8003a2 <bc_pgfault+0x89>
                 panic("Not enough memory");
  800386:	c7 44 24 08 dc 49 80 	movl   $0x8049dc,0x8(%esp)
  80038d:	00 
  80038e:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  800395:	00 
  800396:	c7 04 24 d4 49 80 00 	movl   $0x8049d4,(%esp)
  80039d:	e8 1e 1d 00 00       	call   8020c0 <_panic>
// Hint: Use ide_read and BLKSECTS.
static void
bc_pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  8003a2:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
  8003a8:	c1 eb 0c             	shr    $0xc,%ebx
	//
	// LAB 5: Your code here
           if(sys_page_alloc(0,ROUNDDOWN(addr,PGSIZE),PTE_W|PTE_U|PTE_P)<0)
                 panic("Not enough memory");

            ide_read(blockno*8,ROUNDDOWN(addr,PGSIZE),8);
  8003ab:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  8003b2:	00 
  8003b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003b7:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
  8003be:	89 04 24             	mov    %eax,(%esp)
  8003c1:	e8 6c fd ff ff       	call   800132 <ide_read>
          


	// Sanity check the block number. (exercise for the reader:
	// why do we do this *after* reading the block in?)
	if (super && blockno >= super->s_nblocks)
  8003c6:	a1 e4 d0 80 00       	mov    0x80d0e4,%eax
  8003cb:	85 c0                	test   %eax,%eax
  8003cd:	74 25                	je     8003f4 <bc_pgfault+0xdb>
  8003cf:	3b 58 04             	cmp    0x4(%eax),%ebx
  8003d2:	72 20                	jb     8003f4 <bc_pgfault+0xdb>
		panic("reading non-existent block %08x\n", blockno);
  8003d4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003d8:	c7 44 24 08 68 49 80 	movl   $0x804968,0x8(%esp)
  8003df:	00 
  8003e0:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  8003e7:	00 
  8003e8:	c7 04 24 d4 49 80 00 	movl   $0x8049d4,(%esp)
  8003ef:	e8 cc 1c 00 00       	call   8020c0 <_panic>

	// Check that the block we read was allocated.
	if (bitmap && block_is_free(blockno))
  8003f4:	83 3d e0 d0 80 00 00 	cmpl   $0x0,0x80d0e0
  8003fb:	74 2c                	je     800429 <bc_pgfault+0x110>
  8003fd:	89 1c 24             	mov    %ebx,(%esp)
  800400:	e8 db 02 00 00       	call   8006e0 <block_is_free>
  800405:	85 c0                	test   %eax,%eax
  800407:	74 20                	je     800429 <bc_pgfault+0x110>
		panic("reading free block %08x\n", blockno);
  800409:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80040d:	c7 44 24 08 ee 49 80 	movl   $0x8049ee,0x8(%esp)
  800414:	00 
  800415:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  80041c:	00 
  80041d:	c7 04 24 d4 49 80 00 	movl   $0x8049d4,(%esp)
  800424:	e8 97 1c 00 00       	call   8020c0 <_panic>
}
  800429:	83 c4 20             	add    $0x20,%esp
  80042c:	5b                   	pop    %ebx
  80042d:	5e                   	pop    %esi
  80042e:	5d                   	pop    %ebp
  80042f:	c3                   	ret    

00800430 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and ide_write.
// Hint: Use the PTE_USER constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
  800433:	83 ec 28             	sub    $0x28,%esp
  800436:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800439:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80043c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80043f:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  800445:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  80044a:	76 20                	jbe    80046c <flush_block+0x3c>
		panic("flush_block of bad va %08x", addr);
  80044c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800450:	c7 44 24 08 07 4a 80 	movl   $0x804a07,0x8(%esp)
  800457:	00 
  800458:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  80045f:	00 
  800460:	c7 04 24 d4 49 80 00 	movl   $0x8049d4,(%esp)
  800467:	e8 54 1c 00 00       	call   8020c0 <_panic>

	// LAB 5: Your code here.
        if(va_is_mapped(addr) > 0)
  80046c:	89 1c 24             	mov    %ebx,(%esp)
  80046f:	e8 1c fe ff ff       	call   800290 <va_is_mapped>
  800474:	85 c0                	test   %eax,%eax
  800476:	0f 8e 84 00 00 00    	jle    800500 <flush_block+0xd0>
         {
            if(va_is_dirty(addr)>0)
  80047c:	89 1c 24             	mov    %ebx,(%esp)
  80047f:	e8 37 fe ff ff       	call   8002bb <va_is_dirty>
  800484:	85 c0                	test   %eax,%eax
  800486:	7e 78                	jle    800500 <flush_block+0xd0>
             {
		cprintf("\n???????????????????Writing dirty\n");
  800488:	c7 04 24 8c 49 80 00 	movl   $0x80498c,(%esp)
  80048f:	e8 f1 1c 00 00       	call   802185 <cprintf>
                ide_write(blockno*8,ROUNDDOWN(addr,PGSIZE),8);
  800494:	89 de                	mov    %ebx,%esi
  800496:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  80049c:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
  8004a3:	00 
  8004a4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004a8:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
  8004ae:	c1 eb 0c             	shr    $0xc,%ebx
  8004b1:	c1 e3 03             	shl    $0x3,%ebx
  8004b4:	89 1c 24             	mov    %ebx,(%esp)
  8004b7:	e8 b5 fb ff ff       	call   800071 <ide_write>
                if(sys_page_map(0,ROUNDDOWN(addr,PGSIZE),0,ROUNDDOWN(addr,PGSIZE),PTE_USER)<0)
  8004bc:	c7 44 24 10 07 0e 00 	movl   $0xe07,0x10(%esp)
  8004c3:	00 
  8004c4:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8004c8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8004cf:	00 
  8004d0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004d4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8004db:	e8 88 2a 00 00       	call   802f68 <sys_page_map>
  8004e0:	85 c0                	test   %eax,%eax
  8004e2:	79 1c                	jns    800500 <flush_block+0xd0>
                   panic("Not enough Memory");
  8004e4:	c7 44 24 08 22 4a 80 	movl   $0x804a22,0x8(%esp)
  8004eb:	00 
  8004ec:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  8004f3:	00 
  8004f4:	c7 04 24 d4 49 80 00 	movl   $0x8049d4,(%esp)
  8004fb:	e8 c0 1b 00 00       	call   8020c0 <_panic>

         }
              

//	panic("flush_block not implemented");
}
  800500:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800503:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800506:	89 ec                	mov    %ebp,%esp
  800508:	5d                   	pop    %ebp
  800509:	c3                   	ret    

0080050a <check_bc>:

// Test that the block cache works, by smashing the superblock and
// reading it back.
static void
check_bc(void)
{
  80050a:	55                   	push   %ebp
  80050b:	89 e5                	mov    %esp,%ebp
  80050d:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct Super backup;

	// back up super block
	memmove(&backup, diskaddr(1), sizeof backup);
  800513:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80051a:	e8 b4 fd ff ff       	call   8002d3 <diskaddr>
  80051f:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  800526:	00 
  800527:	89 44 24 04          	mov    %eax,0x4(%esp)
  80052b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800531:	89 04 24             	mov    %eax,(%esp)
  800534:	e8 ec 24 00 00       	call   802a25 <memmove>

	// smash it 
	strcpy(diskaddr(1), "OOPS!\n");
  800539:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800540:	e8 8e fd ff ff       	call   8002d3 <diskaddr>
  800545:	c7 44 24 04 34 4a 80 	movl   $0x804a34,0x4(%esp)
  80054c:	00 
  80054d:	89 04 24             	mov    %eax,(%esp)
  800550:	e8 15 23 00 00       	call   80286a <strcpy>
	flush_block(diskaddr(1));
  800555:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80055c:	e8 72 fd ff ff       	call   8002d3 <diskaddr>
  800561:	89 04 24             	mov    %eax,(%esp)
  800564:	e8 c7 fe ff ff       	call   800430 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800569:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800570:	e8 5e fd ff ff       	call   8002d3 <diskaddr>
  800575:	89 04 24             	mov    %eax,(%esp)
  800578:	e8 13 fd ff ff       	call   800290 <va_is_mapped>
  80057d:	85 c0                	test   %eax,%eax
  80057f:	75 24                	jne    8005a5 <check_bc+0x9b>
  800581:	c7 44 24 0c 56 4a 80 	movl   $0x804a56,0xc(%esp)
  800588:	00 
  800589:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  800590:	00 
  800591:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  800598:	00 
  800599:	c7 04 24 d4 49 80 00 	movl   $0x8049d4,(%esp)
  8005a0:	e8 1b 1b 00 00       	call   8020c0 <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  8005a5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005ac:	e8 22 fd ff ff       	call   8002d3 <diskaddr>
  8005b1:	89 04 24             	mov    %eax,(%esp)
  8005b4:	e8 02 fd ff ff       	call   8002bb <va_is_dirty>
  8005b9:	85 c0                	test   %eax,%eax
  8005bb:	74 24                	je     8005e1 <check_bc+0xd7>
  8005bd:	c7 44 24 0c 3b 4a 80 	movl   $0x804a3b,0xc(%esp)
  8005c4:	00 
  8005c5:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  8005cc:	00 
  8005cd:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  8005d4:	00 
  8005d5:	c7 04 24 d4 49 80 00 	movl   $0x8049d4,(%esp)
  8005dc:	e8 df 1a 00 00       	call   8020c0 <_panic>

	// clear it out
	sys_page_unmap(0, diskaddr(1));
  8005e1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8005e8:	e8 e6 fc ff ff       	call   8002d3 <diskaddr>
  8005ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005f1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005f8:	e8 0d 29 00 00       	call   802f0a <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  8005fd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800604:	e8 ca fc ff ff       	call   8002d3 <diskaddr>
  800609:	89 04 24             	mov    %eax,(%esp)
  80060c:	e8 7f fc ff ff       	call   800290 <va_is_mapped>
  800611:	85 c0                	test   %eax,%eax
  800613:	74 24                	je     800639 <check_bc+0x12f>
  800615:	c7 44 24 0c 55 4a 80 	movl   $0x804a55,0xc(%esp)
  80061c:	00 
  80061d:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  800624:	00 
  800625:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
  80062c:	00 
  80062d:	c7 04 24 d4 49 80 00 	movl   $0x8049d4,(%esp)
  800634:	e8 87 1a 00 00       	call   8020c0 <_panic>

	// read it back in
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800639:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800640:	e8 8e fc ff ff       	call   8002d3 <diskaddr>
  800645:	c7 44 24 04 34 4a 80 	movl   $0x804a34,0x4(%esp)
  80064c:	00 
  80064d:	89 04 24             	mov    %eax,(%esp)
  800650:	e8 a4 22 00 00       	call   8028f9 <strcmp>
  800655:	85 c0                	test   %eax,%eax
  800657:	74 24                	je     80067d <check_bc+0x173>
  800659:	c7 44 24 0c b0 49 80 	movl   $0x8049b0,0xc(%esp)
  800660:	00 
  800661:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  800668:	00 
  800669:	c7 44 24 04 75 00 00 	movl   $0x75,0x4(%esp)
  800670:	00 
  800671:	c7 04 24 d4 49 80 00 	movl   $0x8049d4,(%esp)
  800678:	e8 43 1a 00 00       	call   8020c0 <_panic>

	// fix it
	memmove(diskaddr(1), &backup, sizeof backup);
  80067d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800684:	e8 4a fc ff ff       	call   8002d3 <diskaddr>
  800689:	c7 44 24 08 08 01 00 	movl   $0x108,0x8(%esp)
  800690:	00 
  800691:	8d 95 f0 fe ff ff    	lea    -0x110(%ebp),%edx
  800697:	89 54 24 04          	mov    %edx,0x4(%esp)
  80069b:	89 04 24             	mov    %eax,(%esp)
  80069e:	e8 82 23 00 00       	call   802a25 <memmove>
	flush_block(diskaddr(1));
  8006a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8006aa:	e8 24 fc ff ff       	call   8002d3 <diskaddr>
  8006af:	89 04 24             	mov    %eax,(%esp)
  8006b2:	e8 79 fd ff ff       	call   800430 <flush_block>

	cprintf("block cache is good\n");
  8006b7:	c7 04 24 70 4a 80 00 	movl   $0x804a70,(%esp)
  8006be:	e8 c2 1a 00 00       	call   802185 <cprintf>
}
  8006c3:	c9                   	leave  
  8006c4:	c3                   	ret    

008006c5 <bc_init>:

void
bc_init(void)
{
  8006c5:	55                   	push   %ebp
  8006c6:	89 e5                	mov    %esp,%ebp
  8006c8:	83 ec 18             	sub    $0x18,%esp
	set_pgfault_handler(bc_pgfault);
  8006cb:	c7 04 24 19 03 80 00 	movl   $0x800319,(%esp)
  8006d2:	e8 15 2a 00 00       	call   8030ec <set_pgfault_handler>
	check_bc();
  8006d7:	e8 2e fe ff ff       	call   80050a <check_bc>
}
  8006dc:	c9                   	leave  
  8006dd:	c3                   	ret    
	...

008006e0 <block_is_free>:
// 1 means block is free
// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	53                   	push   %ebx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
	if (super == 0 || blockno >= super->s_nblocks)
  8006e7:	8b 15 e4 d0 80 00    	mov    0x80d0e4,%edx
  8006ed:	85 d2                	test   %edx,%edx
  8006ef:	74 25                	je     800716 <block_is_free+0x36>
  8006f1:	39 42 04             	cmp    %eax,0x4(%edx)
  8006f4:	76 20                	jbe    800716 <block_is_free+0x36>
  8006f6:	89 c1                	mov    %eax,%ecx
  8006f8:	83 e1 1f             	and    $0x1f,%ecx
  8006fb:	ba 01 00 00 00       	mov    $0x1,%edx
  800700:	d3 e2                	shl    %cl,%edx
  800702:	c1 e8 05             	shr    $0x5,%eax
  800705:	8b 1d e0 d0 80 00    	mov    0x80d0e0,%ebx
  80070b:	85 14 83             	test   %edx,(%ebx,%eax,4)
  80070e:	0f 95 c0             	setne  %al
  800711:	0f b6 c0             	movzbl %al,%eax
  800714:	eb 05                	jmp    80071b <block_is_free+0x3b>
  800716:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
	if (bitmap[blockno / 32] & (1 << (blockno % 32)))
		return 1;
	return 0;
}
  80071b:	5b                   	pop    %ebx
  80071c:	5d                   	pop    %ebp
  80071d:	c3                   	ret    

0080071e <skip_slash>:
}

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
	while (*p == '/')
  800721:	80 38 2f             	cmpb   $0x2f,(%eax)
  800724:	75 08                	jne    80072e <skip_slash+0x10>
		p++;
  800726:	83 c0 01             	add    $0x1,%eax

// Skip over slashes.
static const char*
skip_slash(const char *p)
{
	while (*p == '/')
  800729:	80 38 2f             	cmpb   $0x2f,(%eax)
  80072c:	74 f8                	je     800726 <skip_slash+0x8>
		p++;
	return p;
}
  80072e:	5d                   	pop    %ebp
  80072f:	c3                   	ret    

00800730 <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	53                   	push   %ebx
  800734:	83 ec 14             	sub    $0x14,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  800737:	a1 e4 d0 80 00       	mov    0x80d0e4,%eax
  80073c:	83 78 04 01          	cmpl   $0x1,0x4(%eax)
  800740:	76 2a                	jbe    80076c <fs_sync+0x3c>
  800742:	b8 01 00 00 00       	mov    $0x1,%eax
  800747:	bb 01 00 00 00       	mov    $0x1,%ebx
		flush_block(diskaddr(i));
  80074c:	89 04 24             	mov    %eax,(%esp)
  80074f:	e8 7f fb ff ff       	call   8002d3 <diskaddr>
  800754:	89 04 24             	mov    %eax,(%esp)
  800757:	e8 d4 fc ff ff       	call   800430 <flush_block>
// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  80075c:	83 c3 01             	add    $0x1,%ebx
  80075f:	89 d8                	mov    %ebx,%eax
  800761:	8b 15 e4 d0 80 00    	mov    0x80d0e4,%edx
  800767:	39 5a 04             	cmp    %ebx,0x4(%edx)
  80076a:	77 e0                	ja     80074c <fs_sync+0x1c>
		flush_block(diskaddr(i));
}
  80076c:	83 c4 14             	add    $0x14,%esp
  80076f:	5b                   	pop    %ebx
  800770:	5d                   	pop    %ebp
  800771:	c3                   	ret    

00800772 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  800772:	55                   	push   %ebp
  800773:	89 e5                	mov    %esp,%ebp
  800775:	56                   	push   %esi
  800776:	53                   	push   %ebx
  800777:	83 ec 10             	sub    $0x10,%esp
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
              uint32_t blockNo;
         for(blockNo=0;blockNo<super->s_nblocks;blockNo++)
  80077a:	a1 e4 d0 80 00       	mov    0x80d0e4,%eax
  80077f:	8b 70 04             	mov    0x4(%eax),%esi
  800782:	85 f6                	test   %esi,%esi
  800784:	74 4e                	je     8007d4 <alloc_block+0x62>
  800786:	bb 00 00 00 00       	mov    $0x0,%ebx
             {
                  if(block_is_free(blockNo)!=0)
  80078b:	89 1c 24             	mov    %ebx,(%esp)
  80078e:	e8 4d ff ff ff       	call   8006e0 <block_is_free>
  800793:	85 c0                	test   %eax,%eax
  800795:	74 36                	je     8007cd <alloc_block+0x5b>
                   {
                     bitmap[blockNo/32]&=(~(1 << (blockNo%32)));
  800797:	89 de                	mov    %ebx,%esi
  800799:	c1 ee 05             	shr    $0x5,%esi
  80079c:	c1 e6 02             	shl    $0x2,%esi
  80079f:	89 f0                	mov    %esi,%eax
  8007a1:	03 05 e0 d0 80 00    	add    0x80d0e0,%eax
  8007a7:	89 d9                	mov    %ebx,%ecx
  8007a9:	83 e1 1f             	and    $0x1f,%ecx
  8007ac:	ba fe ff ff ff       	mov    $0xfffffffe,%edx
  8007b1:	d3 c2                	rol    %cl,%edx
  8007b3:	21 10                	and    %edx,(%eax)
                     void *addr = diskaddr(blockNo);
  8007b5:	89 1c 24             	mov    %ebx,(%esp)
  8007b8:	e8 16 fb ff ff       	call   8002d3 <diskaddr>
                     flush_block(bitmap+(blockNo/32));
  8007bd:	03 35 e0 d0 80 00    	add    0x80d0e0,%esi
  8007c3:	89 34 24             	mov    %esi,(%esp)
  8007c6:	e8 65 fc ff ff       	call   800430 <flush_block>
                     return blockNo;   
  8007cb:	eb 0c                	jmp    8007d9 <alloc_block+0x67>
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
              uint32_t blockNo;
         for(blockNo=0;blockNo<super->s_nblocks;blockNo++)
  8007cd:	83 c3 01             	add    $0x1,%ebx
  8007d0:	39 de                	cmp    %ebx,%esi
  8007d2:	77 b7                	ja     80078b <alloc_block+0x19>
  8007d4:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
                   } 

             }
	//panic("alloc_block not implemented");
	return -E_NO_DISK;
}
  8007d9:	89 d8                	mov    %ebx,%eax
  8007db:	83 c4 10             	add    $0x10,%esp
  8007de:	5b                   	pop    %ebx
  8007df:	5e                   	pop    %esi
  8007e0:	5d                   	pop    %ebp
  8007e1:	c3                   	ret    

008007e2 <get_free_swap_block>:
	//flush_block((void *)swap_handler);
}


void* get_free_swap_block(void)
{
  8007e2:	55                   	push   %ebp
  8007e3:	89 e5                	mov    %esp,%ebp
  8007e5:	57                   	push   %edi
  8007e6:	56                   	push   %esi
  8007e7:	53                   	push   %ebx
  8007e8:	83 ec 1c             	sub    $0x1c,%esp
  8007eb:	bb 00 00 00 00       	mov    $0x0,%ebx
uint32_t *indirectBlockBase; 
   // block free if 1
   for(;i<NSWAPBLOCKS;i++)
   {
	// checking which block in the swap space is free
	cprintf("\nInside block allocation\n");
  8007f0:	c7 04 24 85 4a 80 00 	movl   $0x804a85,(%esp)
  8007f7:	e8 89 19 00 00       	call   802185 <cprintf>
	if(swap_handler.bitmap[i/32]!=0 && ((swap_handler.bitmap[i/32]) & (ONE<<(i%32)))!=0)
  8007fc:	89 de                	mov    %ebx,%esi
  8007fe:	c1 ee 05             	shr    $0x5,%esi
  800801:	8b 04 b5 04 d1 80 00 	mov    0x80d104(,%esi,4),%eax
  800808:	85 c0                	test   %eax,%eax
  80080a:	74 78                	je     800884 <get_free_swap_block+0xa2>
  80080c:	89 d9                	mov    %ebx,%ecx
  80080e:	83 e1 1f             	and    $0x1f,%ecx
  800811:	bf 01 00 00 00       	mov    $0x1,%edi
  800816:	d3 e7                	shl    %cl,%edi
  800818:	85 c7                	test   %eax,%edi
  80081a:	74 68                	je     800884 <get_free_swap_block+0xa2>
	{
			cprintf("\nInside block allocation>>>>>>>in\n");
  80081c:	c7 04 24 20 4c 80 00 	movl   $0x804c20,(%esp)
  800823:	e8 5d 19 00 00       	call   802185 <cprintf>
		cprintf("\nadddreeeee>>>>>%x\n",swap_handler.swap_file);	
  800828:	ba 00 d1 80 00       	mov    $0x80d100,%edx
  80082d:	8b 02                	mov    (%edx),%eax
  80082f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800833:	c7 04 24 9f 4a 80 00 	movl   $0x804a9f,(%esp)
  80083a:	e8 46 19 00 00       	call   802185 <cprintf>
            // mark the block in the swap bitmap as occupied.
	    swap_handler.bitmap[i/32]&= (~(ONE<<(i%32)));
  80083f:	f7 d7                	not    %edi
  800841:	21 3c b5 04 d1 80 00 	and    %edi,0x80d104(,%esi,4)
	    // flush the swaphandler immediately.	
            /** return the blocks from the first direct blocks, if freeth block is less than tenth, otherwise pick
	     **	the one from the indirect blocks.Remember, the blocks have already been allocated to this special file
	     ** beforehand.Now we are taking the non-occupied block from swap file's bitmap.	
	     */	
	    if(i<10)
  800848:	83 fb 09             	cmp    $0x9,%ebx
  80084b:	77 16                	ja     800863 <get_free_swap_block+0x81>
	    	 return diskaddr(swap_handler.swap_file->f_direct[i]);
  80084d:	a1 00 d1 80 00       	mov    0x80d100,%eax
  800852:	8b 84 98 88 00 00 00 	mov    0x88(%eax,%ebx,4),%eax
  800859:	89 04 24             	mov    %eax,(%esp)
  80085c:	e8 72 fa ff ff       	call   8002d3 <diskaddr>
  800861:	eb 35                	jmp    800898 <get_free_swap_block+0xb6>
	    else
	    {
		 indirectBlockBase =(uint32_t *)diskaddr(swap_handler.swap_file->f_indirect);	
  800863:	a1 00 d1 80 00       	mov    0x80d100,%eax
  800868:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
  80086e:	89 04 24             	mov    %eax,(%esp)
  800871:	e8 5d fa ff ff       	call   8002d3 <diskaddr>
	         return diskaddr(*(indirectBlockBase+i-10));
  800876:	8b 44 98 d8          	mov    -0x28(%eax,%ebx,4),%eax
  80087a:	89 04 24             	mov    %eax,(%esp)
  80087d:	e8 51 fa ff ff       	call   8002d3 <diskaddr>
  800882:	eb 14                	jmp    800898 <get_free_swap_block+0xb6>
//uint32_t maxValue=0xFFFFFFFF;
uint32_t i=0;
uint32_t ONE = 1;
uint32_t *indirectBlockBase; 
   // block free if 1
   for(;i<NSWAPBLOCKS;i++)
  800884:	83 c3 01             	add    $0x1,%ebx
  800887:	81 fb 0a 04 00 00    	cmp    $0x40a,%ebx
  80088d:	0f 85 5d ff ff ff    	jne    8007f0 <get_free_swap_block+0xe>
  800893:	b8 00 00 00 00       	mov    $0x0,%eax
	    }
	}
   }
      // the swap space is full give error msg to swap environment
      return NULL;
}
  800898:	83 c4 1c             	add    $0x1c,%esp
  80089b:	5b                   	pop    %ebx
  80089c:	5e                   	pop    %esi
  80089d:	5f                   	pop    %edi
  80089e:	5d                   	pop    %ebp
  80089f:	c3                   	ret    

008008a0 <check_SwapBlock>:


void check_SwapBlock(void)
{ 	
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	53                   	push   %ebx
  8008a4:	83 ec 14             	sub    $0x14,%esp
  8008a7:	bb 00 00 00 00       	mov    $0x0,%ebx
int i=0;
	for(i=0;i<15;i++)
	  cprintf("\nfree block from SWAPPPPP SPACEEEEE--->>>>>>>> %d\n",((uint32_t)get_free_swap_block() - 0x10000000)/BLKSIZE);
  8008ac:	e8 31 ff ff ff       	call   8007e2 <get_free_swap_block>
  8008b1:	2d 00 00 00 10       	sub    $0x10000000,%eax
  8008b6:	c1 e8 0c             	shr    $0xc,%eax
  8008b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008bd:	c7 04 24 44 4c 80 00 	movl   $0x804c44,(%esp)
  8008c4:	e8 bc 18 00 00       	call   802185 <cprintf>


void check_SwapBlock(void)
{ 	
int i=0;
	for(i=0;i<15;i++)
  8008c9:	83 c3 01             	add    $0x1,%ebx
  8008cc:	83 fb 0f             	cmp    $0xf,%ebx
  8008cf:	75 db                	jne    8008ac <check_SwapBlock+0xc>
	  cprintf("\nfree block from SWAPPPPP SPACEEEEE--->>>>>>>> %d\n",((uint32_t)get_free_swap_block() - 0x10000000)/BLKSIZE);
}
  8008d1:	83 c4 14             	add    $0x14,%esp
  8008d4:	5b                   	pop    %ebx
  8008d5:	5d                   	pop    %ebp
  8008d6:	c3                   	ret    

008008d7 <file_block_walk>:
// Hint: Don't forget to clear any block you allocate.


static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	83 ec 38             	sub    $0x38,%esp
  8008dd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8008e0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8008e3:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8008e6:	89 c6                	mov    %eax,%esi
  8008e8:	89 d3                	mov    %edx,%ebx
  8008ea:	89 cf                	mov    %ecx,%edi
	// LAB 5: Your code here.
         
         
         if(filebno >= NDIRECT+NINDIRECT)
  8008ec:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f1:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  8008f7:	0f 87 83 00 00 00    	ja     800980 <file_block_walk+0xa9>
                  return -E_INVAL;
         if((filebno/NDIRECT)>0)
  8008fd:	83 fa 09             	cmp    $0x9,%edx
  800900:	76 70                	jbe    800972 <file_block_walk+0x9b>
             {
                 if(f->f_indirect!=0)
  800902:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800908:	85 c0                	test   %eax,%eax
  80090a:	74 15                	je     800921 <file_block_walk+0x4a>
               {
                  *ppdiskbno=((uint32_t *)((diskaddr(f->f_indirect))) + (filebno-NDIRECT));
  80090c:	89 04 24             	mov    %eax,(%esp)
  80090f:	e8 bf f9 ff ff       	call   8002d3 <diskaddr>
  800914:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  800918:	89 07                	mov    %eax,(%edi)
  80091a:	b8 00 00 00 00       	mov    $0x0,%eax
                  return 0;
  80091f:	eb 5f                	jmp    800980 <file_block_walk+0xa9>
               }
            else if(f->f_indirect==0 && alloc!=0)
  800921:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800926:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80092a:	74 54                	je     800980 <file_block_walk+0xa9>
               {
                  uint32_t blockno = alloc_block();
  80092c:	e8 41 fe ff ff       	call   800772 <alloc_block>
  800931:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                  if(blockno<0)
                    return -E_NO_DISK;
                  memset(diskaddr(blockno),0,BLKSIZE);
  800934:	89 04 24             	mov    %eax,(%esp)
  800937:	e8 97 f9 ff ff       	call   8002d3 <diskaddr>
  80093c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800943:	00 
  800944:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80094b:	00 
  80094c:	89 04 24             	mov    %eax,(%esp)
  80094f:	e8 72 20 00 00       	call   8029c6 <memset>
                  f->f_indirect=blockno;
  800954:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800957:	89 86 b0 00 00 00    	mov    %eax,0xb0(%esi)
                  *ppdiskbno=((uint32_t *)(diskaddr(f->f_indirect)) + (filebno-NDIRECT));
  80095d:	89 04 24             	mov    %eax,(%esp)
  800960:	e8 6e f9 ff ff       	call   8002d3 <diskaddr>
  800965:	8d 44 98 d8          	lea    -0x28(%eax,%ebx,4),%eax
  800969:	89 07                	mov    %eax,(%edi)
  80096b:	b8 00 00 00 00       	mov    $0x0,%eax
                   return 0;
  800970:	eb 0e                	jmp    800980 <file_block_walk+0xa9>
            else
               return -E_NOT_FOUND;
             }
          else
             {
               *ppdiskbno=(uint32_t *)(f->f_direct + filebno);
  800972:	8d 84 96 88 00 00 00 	lea    0x88(%esi,%edx,4),%eax
  800979:	89 01                	mov    %eax,(%ecx)
  80097b:	b8 00 00 00 00       	mov    $0x0,%eax
                return 0;     
             }

	//panic("file_block_walk not implemented");
}
  800980:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800983:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800986:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800989:	89 ec                	mov    %ebp,%esp
  80098b:	5d                   	pop    %ebp
  80098c:	c3                   	ret    

0080098d <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  80098d:	55                   	push   %ebp
  80098e:	89 e5                	mov    %esp,%ebp
  800990:	57                   	push   %edi
  800991:	56                   	push   %esi
  800992:	53                   	push   %ebx
  800993:	83 ec 2c             	sub    $0x2c,%esp
  800996:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800999:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  80099f:	05 ff 0f 00 00       	add    $0xfff,%eax
  8009a4:	3d ff 0f 00 00       	cmp    $0xfff,%eax
  8009a9:	7e 5b                	jle    800a06 <file_flush+0x79>
  8009ab:	be 00 00 00 00       	mov    $0x0,%esi
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  8009b0:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  8009b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8009ba:	89 f9                	mov    %edi,%ecx
  8009bc:	89 f2                	mov    %esi,%edx
  8009be:	89 d8                	mov    %ebx,%eax
  8009c0:	e8 12 ff ff ff       	call   8008d7 <file_block_walk>
  8009c5:	85 c0                	test   %eax,%eax
  8009c7:	78 1d                	js     8009e6 <file_flush+0x59>
		    pdiskbno == NULL || *pdiskbno == 0)
  8009c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  8009cc:	85 c0                	test   %eax,%eax
  8009ce:	74 16                	je     8009e6 <file_flush+0x59>
		    pdiskbno == NULL || *pdiskbno == 0)
  8009d0:	8b 00                	mov    (%eax),%eax
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  8009d2:	85 c0                	test   %eax,%eax
  8009d4:	74 10                	je     8009e6 <file_flush+0x59>
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
  8009d6:	89 04 24             	mov    %eax,(%esp)
  8009d9:	e8 f5 f8 ff ff       	call   8002d3 <diskaddr>
  8009de:	89 04 24             	mov    %eax,(%esp)
  8009e1:	e8 4a fa ff ff       	call   800430 <flush_block>
file_flush(struct File *f)
{
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  8009e6:	83 c6 01             	add    $0x1,%esi
  8009e9:	8b 83 80 00 00 00    	mov    0x80(%ebx),%eax
  8009ef:	05 ff 0f 00 00       	add    $0xfff,%eax
  8009f4:	89 c2                	mov    %eax,%edx
  8009f6:	c1 fa 1f             	sar    $0x1f,%edx
  8009f9:	c1 ea 14             	shr    $0x14,%edx
  8009fc:	8d 04 02             	lea    (%edx,%eax,1),%eax
  8009ff:	c1 f8 0c             	sar    $0xc,%eax
  800a02:	39 f0                	cmp    %esi,%eax
  800a04:	7f ad                	jg     8009b3 <file_flush+0x26>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
		    pdiskbno == NULL || *pdiskbno == 0)
			continue;
		flush_block(diskaddr(*pdiskbno));
	}
	flush_block(f);
  800a06:	89 1c 24             	mov    %ebx,(%esp)
  800a09:	e8 22 fa ff ff       	call   800430 <flush_block>
	if (f->f_indirect)
  800a0e:	8b 83 b0 00 00 00    	mov    0xb0(%ebx),%eax
  800a14:	85 c0                	test   %eax,%eax
  800a16:	74 10                	je     800a28 <file_flush+0x9b>
		flush_block(diskaddr(f->f_indirect));
  800a18:	89 04 24             	mov    %eax,(%esp)
  800a1b:	e8 b3 f8 ff ff       	call   8002d3 <diskaddr>
  800a20:	89 04 24             	mov    %eax,(%esp)
  800a23:	e8 08 fa ff ff       	call   800430 <flush_block>
}
  800a28:	83 c4 2c             	add    $0x2c,%esp
  800a2b:	5b                   	pop    %ebx
  800a2c:	5e                   	pop    %esi
  800a2d:	5f                   	pop    %edi
  800a2e:	5d                   	pop    %ebp
  800a2f:	c3                   	ret    

00800a30 <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	56                   	push   %esi
  800a34:	53                   	push   %ebx
  800a35:	83 ec 20             	sub    $0x20,%esp
  800a38:	8b 5d 10             	mov    0x10(%ebp),%ebx
	// LAB 5: Your code here.
	uint32_t *ppdiskbno = 0;
  800a3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        int r =file_block_walk(f,filebno,&ppdiskbno,1);
  800a42:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800a45:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800a4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	e8 80 fe ff ff       	call   8008d7 <file_block_walk>
         if(r<0)
  800a57:	85 c0                	test   %eax,%eax
  800a59:	78 54                	js     800aaf <file_get_block+0x7f>
            return r;
         else
          { 
             if(*ppdiskbno==0)
  800a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a5e:	8b 00                	mov    (%eax),%eax
  800a60:	85 c0                	test   %eax,%eax
  800a62:	75 31                	jne    800a95 <file_get_block+0x65>
               {
                 uint32_t blockno = alloc_block();
  800a64:	e8 09 fd ff ff       	call   800772 <alloc_block>
  800a69:	89 c6                	mov    %eax,%esi
		cprintf("\n Inside file get block no---->>>>%d\n",blockno);  
  800a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a6f:	c7 04 24 78 4c 80 00 	movl   $0x804c78,(%esp)
  800a76:	e8 0a 17 00 00       	call   802185 <cprintf>
                  if(blockno<0)
                    return -E_NO_DISK;
                  *ppdiskbno=blockno;
  800a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a7e:	89 30                	mov    %esi,(%eax)
		  if(blk!=NULL)   //added for project
  800a80:	85 db                	test   %ebx,%ebx
  800a82:	74 26                	je     800aaa <file_get_block+0x7a>
                  *blk = diskaddr(blockno);
  800a84:	89 34 24             	mov    %esi,(%esp)
  800a87:	e8 47 f8 ff ff       	call   8002d3 <diskaddr>
  800a8c:	89 03                	mov    %eax,(%ebx)
  800a8e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a93:	eb 1a                	jmp    800aaf <file_get_block+0x7f>
                   return 0;
               }
             else
               {  if(blk!=NULL)  //added for project
  800a95:	85 db                	test   %ebx,%ebx
  800a97:	74 11                	je     800aaa <file_get_block+0x7a>
                 *blk = diskaddr(*ppdiskbno);
  800a99:	89 04 24             	mov    %eax,(%esp)
  800a9c:	e8 32 f8 ff ff       	call   8002d3 <diskaddr>
  800aa1:	89 03                	mov    %eax,(%ebx)
  800aa3:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa8:	eb 05                	jmp    800aaf <file_get_block+0x7f>
  800aaa:	b8 00 00 00 00       	mov    $0x0,%eax
                   return 0;
               }
          } 
        //panic("file_get_block not implemented");
}
  800aaf:	83 c4 20             	add    $0x20,%esp
  800ab2:	5b                   	pop    %ebx
  800ab3:	5e                   	pop    %esi
  800ab4:	5d                   	pop    %ebp
  800ab5:	c3                   	ret    

00800ab6 <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	57                   	push   %edi
  800aba:	56                   	push   %esi
  800abb:	53                   	push   %ebx
  800abc:	83 ec 3c             	sub    $0x3c,%esp
  800abf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800ac2:	8b 55 10             	mov    0x10(%ebp),%edx
  800ac5:	8b 5d 14             	mov    0x14(%ebp),%ebx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  800acb:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
  800ad1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad6:	39 d9                	cmp    %ebx,%ecx
  800ad8:	0f 8e 8b 00 00 00    	jle    800b69 <file_read+0xb3>
		return 0;

	count = MIN(count, f->f_size - offset);
  800ade:	29 d9                	sub    %ebx,%ecx
  800ae0:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800ae3:	39 d1                	cmp    %edx,%ecx
  800ae5:	76 03                	jbe    800aea <file_read+0x34>
  800ae7:	89 55 cc             	mov    %edx,-0x34(%ebp)

	for (pos = offset; pos < offset + count; ) {
  800aea:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800aed:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800af0:	01 d8                	add    %ebx,%eax
  800af2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800af5:	39 d8                	cmp    %ebx,%eax
  800af7:	76 6d                	jbe    800b66 <file_read+0xb0>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800af9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800afc:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b00:	89 d8                	mov    %ebx,%eax
  800b02:	c1 f8 1f             	sar    $0x1f,%eax
  800b05:	c1 e8 14             	shr    $0x14,%eax
  800b08:	01 d8                	add    %ebx,%eax
  800b0a:	c1 f8 0c             	sar    $0xc,%eax
  800b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	89 04 24             	mov    %eax,(%esp)
  800b17:	e8 14 ff ff ff       	call   800a30 <file_get_block>
  800b1c:	85 c0                	test   %eax,%eax
  800b1e:	78 49                	js     800b69 <file_read+0xb3>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800b20:	89 da                	mov    %ebx,%edx
  800b22:	c1 fa 1f             	sar    $0x1f,%edx
  800b25:	c1 ea 14             	shr    $0x14,%edx
  800b28:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800b2b:	25 ff 0f 00 00       	and    $0xfff,%eax
  800b30:	29 d0                	sub    %edx,%eax
  800b32:	be 00 10 00 00       	mov    $0x1000,%esi
  800b37:	29 c6                	sub    %eax,%esi
  800b39:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800b3c:	2b 55 d0             	sub    -0x30(%ebp),%edx
  800b3f:	39 d6                	cmp    %edx,%esi
  800b41:	76 02                	jbe    800b45 <file_read+0x8f>
  800b43:	89 d6                	mov    %edx,%esi
		memmove(buf, blk + pos % BLKSIZE, bn);
  800b45:	89 74 24 08          	mov    %esi,0x8(%esp)
  800b49:	03 45 e4             	add    -0x1c(%ebp),%eax
  800b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b50:	89 3c 24             	mov    %edi,(%esp)
  800b53:	e8 cd 1e 00 00       	call   802a25 <memmove>
		pos += bn;
  800b58:	01 f3                	add    %esi,%ebx
	if (offset >= f->f_size)
		return 0;

	count = MIN(count, f->f_size - offset);

	for (pos = offset; pos < offset + count; ) {
  800b5a:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800b5d:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800b60:	76 04                	jbe    800b66 <file_read+0xb0>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
		memmove(buf, blk + pos % BLKSIZE, bn);
		pos += bn;
		buf += bn;
  800b62:	01 f7                	add    %esi,%edi
  800b64:	eb 93                	jmp    800af9 <file_read+0x43>
	}

	return count;
  800b66:	8b 45 cc             	mov    -0x34(%ebp),%eax
}
  800b69:	83 c4 3c             	add    $0x3c,%esp
  800b6c:	5b                   	pop    %ebx
  800b6d:	5e                   	pop    %esi
  800b6e:	5f                   	pop    %edi
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <check_bitmap>:
//
// Check that all reserved blocks -- 0, 1, and the bitmap blocks themselves --
// are all marked as in-use.
void
check_bitmap(void)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	56                   	push   %esi
  800b75:	53                   	push   %ebx
  800b76:	83 ec 10             	sub    $0x10,%esp
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800b79:	a1 e4 d0 80 00       	mov    0x80d0e4,%eax
  800b7e:	8b 70 04             	mov    0x4(%eax),%esi
  800b81:	85 f6                	test   %esi,%esi
  800b83:	74 44                	je     800bc9 <check_bitmap+0x58>
  800b85:	bb 00 00 00 00       	mov    $0x0,%ebx
		assert(!block_is_free(2+i));
  800b8a:	8d 43 02             	lea    0x2(%ebx),%eax
  800b8d:	89 04 24             	mov    %eax,(%esp)
  800b90:	e8 4b fb ff ff       	call   8006e0 <block_is_free>
  800b95:	85 c0                	test   %eax,%eax
  800b97:	74 24                	je     800bbd <check_bitmap+0x4c>
  800b99:	c7 44 24 0c b3 4a 80 	movl   $0x804ab3,0xc(%esp)
  800ba0:	00 
  800ba1:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  800ba8:	00 
  800ba9:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  800bb0:	00 
  800bb1:	c7 04 24 c7 4a 80 00 	movl   $0x804ac7,(%esp)
  800bb8:	e8 03 15 00 00       	call   8020c0 <_panic>
check_bitmap(void)
{
	uint32_t i;

	// Make sure all bitmap blocks are marked in-use
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  800bbd:	83 c3 01             	add    $0x1,%ebx
  800bc0:	89 d8                	mov    %ebx,%eax
  800bc2:	c1 e0 0f             	shl    $0xf,%eax
  800bc5:	39 f0                	cmp    %esi,%eax
  800bc7:	72 c1                	jb     800b8a <check_bitmap+0x19>
		assert(!block_is_free(2+i));

	// Make sure the reserved and root blocks are marked in-use.
	assert(!block_is_free(0));
  800bc9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800bd0:	e8 0b fb ff ff       	call   8006e0 <block_is_free>
  800bd5:	85 c0                	test   %eax,%eax
  800bd7:	74 24                	je     800bfd <check_bitmap+0x8c>
  800bd9:	c7 44 24 0c cf 4a 80 	movl   $0x804acf,0xc(%esp)
  800be0:	00 
  800be1:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  800be8:	00 
  800be9:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  800bf0:	00 
  800bf1:	c7 04 24 c7 4a 80 00 	movl   $0x804ac7,(%esp)
  800bf8:	e8 c3 14 00 00       	call   8020c0 <_panic>
	assert(!block_is_free(1));
  800bfd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800c04:	e8 d7 fa ff ff       	call   8006e0 <block_is_free>
  800c09:	85 c0                	test   %eax,%eax
  800c0b:	74 24                	je     800c31 <check_bitmap+0xc0>
  800c0d:	c7 44 24 0c e1 4a 80 	movl   $0x804ae1,0xc(%esp)
  800c14:	00 
  800c15:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  800c1c:	00 
  800c1d:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
  800c24:	00 
  800c25:	c7 04 24 c7 4a 80 00 	movl   $0x804ac7,(%esp)
  800c2c:	e8 8f 14 00 00       	call   8020c0 <_panic>
	//assert()

	cprintf("bitmap is good\n");
  800c31:	c7 04 24 f3 4a 80 00 	movl   $0x804af3,(%esp)
  800c38:	e8 48 15 00 00       	call   802185 <cprintf>
}
  800c3d:	83 c4 10             	add    $0x10,%esp
  800c40:	5b                   	pop    %ebx
  800c41:	5e                   	pop    %esi
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <free_block>:
}

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
  800c4a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800c4d:	85 c9                	test   %ecx,%ecx
  800c4f:	75 1c                	jne    800c6d <free_block+0x29>
		panic("attempt to free zero block");
  800c51:	c7 44 24 08 03 4b 80 	movl   $0x804b03,0x8(%esp)
  800c58:	00 
  800c59:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  800c60:	00 
  800c61:	c7 04 24 c7 4a 80 00 	movl   $0x804ac7,(%esp)
  800c68:	e8 53 14 00 00       	call   8020c0 <_panic>
	bitmap[blockno/32] |= 1<<(blockno%32);
  800c6d:	89 c8                	mov    %ecx,%eax
  800c6f:	c1 e8 05             	shr    $0x5,%eax
  800c72:	c1 e0 02             	shl    $0x2,%eax
  800c75:	03 05 e0 d0 80 00    	add    0x80d0e0,%eax
  800c7b:	83 e1 1f             	and    $0x1f,%ecx
  800c7e:	ba 01 00 00 00       	mov    $0x1,%edx
  800c83:	d3 e2                	shl    %cl,%edx
  800c85:	09 10                	or     %edx,(%eax)
}
  800c87:	c9                   	leave  
  800c88:	c3                   	ret    

00800c89 <file_truncate_blocks>:
// (Remember to clear the f->f_indirect pointer so you'll know
// whether it's valid!)
// Do not change f->f_size.
static void
file_truncate_blocks(struct File *f, off_t newsize)
{
  800c89:	55                   	push   %ebp
  800c8a:	89 e5                	mov    %esp,%ebp
  800c8c:	57                   	push   %edi
  800c8d:	56                   	push   %esi
  800c8e:	53                   	push   %ebx
  800c8f:	83 ec 3c             	sub    $0x3c,%esp
  800c92:	89 c6                	mov    %eax,%esi
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800c94:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800c9a:	05 ff 0f 00 00       	add    $0xfff,%eax
  800c9f:	89 c7                	mov    %eax,%edi
  800ca1:	c1 ff 1f             	sar    $0x1f,%edi
  800ca4:	c1 ef 14             	shr    $0x14,%edi
  800ca7:	01 c7                	add    %eax,%edi
  800ca9:	c1 ff 0c             	sar    $0xc,%edi
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800cac:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  800cb2:	89 d0                	mov    %edx,%eax
  800cb4:	c1 f8 1f             	sar    $0x1f,%eax
  800cb7:	c1 e8 14             	shr    $0x14,%eax
  800cba:	8d 14 10             	lea    (%eax,%edx,1),%edx
  800cbd:	c1 fa 0c             	sar    $0xc,%edx
  800cc0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800cc3:	39 d7                	cmp    %edx,%edi
  800cc5:	76 4c                	jbe    800d13 <file_truncate_blocks+0x8a>
  800cc7:	89 d3                	mov    %edx,%ebx
file_free_block(struct File *f, uint32_t filebno)
{
	int r;
	uint32_t *ptr;

	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800cc9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800cd0:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800cd3:	89 da                	mov    %ebx,%edx
  800cd5:	89 f0                	mov    %esi,%eax
  800cd7:	e8 fb fb ff ff       	call   8008d7 <file_block_walk>
  800cdc:	85 c0                	test   %eax,%eax
  800cde:	78 1c                	js     800cfc <file_truncate_blocks+0x73>
		return r;
	if (*ptr) {
  800ce0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ce3:	8b 00                	mov    (%eax),%eax
  800ce5:	85 c0                	test   %eax,%eax
  800ce7:	74 23                	je     800d0c <file_truncate_blocks+0x83>
		free_block(*ptr);
  800ce9:	89 04 24             	mov    %eax,(%esp)
  800cec:	e8 53 ff ff ff       	call   800c44 <free_block>
		*ptr = 0;
  800cf1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800cf4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800cfa:	eb 10                	jmp    800d0c <file_truncate_blocks+0x83>

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);
  800cfc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d00:	c7 04 24 1e 4b 80 00 	movl   $0x804b1e,(%esp)
  800d07:	e8 79 14 00 00       	call   802185 <cprintf>
	int r;
	uint32_t bno, old_nblocks, new_nblocks;

	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800d0c:	83 c3 01             	add    $0x1,%ebx
  800d0f:	39 df                	cmp    %ebx,%edi
  800d11:	77 b6                	ja     800cc9 <file_truncate_blocks+0x40>
		if ((r = file_free_block(f, bno)) < 0)
			cprintf("warning: file_free_block: %e", r);

	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800d13:	83 7d d4 0a          	cmpl   $0xa,-0x2c(%ebp)
  800d17:	77 1c                	ja     800d35 <file_truncate_blocks+0xac>
  800d19:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800d1f:	85 c0                	test   %eax,%eax
  800d21:	74 12                	je     800d35 <file_truncate_blocks+0xac>
		free_block(f->f_indirect);
  800d23:	89 04 24             	mov    %eax,(%esp)
  800d26:	e8 19 ff ff ff       	call   800c44 <free_block>
		f->f_indirect = 0;
  800d2b:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
  800d32:	00 00 00 
	}
}
  800d35:	83 c4 3c             	add    $0x3c,%esp
  800d38:	5b                   	pop    %ebx
  800d39:	5e                   	pop    %esi
  800d3a:	5f                   	pop    %edi
  800d3b:	5d                   	pop    %ebp
  800d3c:	c3                   	ret    

00800d3d <file_set_size>:

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800d3d:	55                   	push   %ebp
  800d3e:	89 e5                	mov    %esp,%ebp
  800d40:	83 ec 18             	sub    $0x18,%esp
  800d43:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800d46:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800d49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800d4c:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (f->f_size > newsize)
  800d4f:	39 b3 80 00 00 00    	cmp    %esi,0x80(%ebx)
  800d55:	7e 09                	jle    800d60 <file_set_size+0x23>
		file_truncate_blocks(f, newsize);
  800d57:	89 f2                	mov    %esi,%edx
  800d59:	89 d8                	mov    %ebx,%eax
  800d5b:	e8 29 ff ff ff       	call   800c89 <file_truncate_blocks>
	f->f_size = newsize;
  800d60:	89 b3 80 00 00 00    	mov    %esi,0x80(%ebx)
	flush_block(f);
  800d66:	89 1c 24             	mov    %ebx,(%esp)
  800d69:	e8 c2 f6 ff ff       	call   800430 <flush_block>
	return 0;
}
  800d6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800d73:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800d76:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800d79:	89 ec                	mov    %ebp,%esp
  800d7b:	5d                   	pop    %ebp
  800d7c:	c3                   	ret    

00800d7d <file_write>:
// offset.  This is meant to mimic the standard pwrite function.
// Extends the file if necessary.
// Returns the number of bytes written, < 0 on error.
int
file_write(struct File *f, const void *buf, size_t count, off_t offset)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	57                   	push   %edi
  800d81:	56                   	push   %esi
  800d82:	53                   	push   %ebx
  800d83:	83 ec 3c             	sub    $0x3c,%esp
  800d86:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800d89:	8b 5d 14             	mov    0x14(%ebp),%ebx
	int r, bn;
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
  800d8c:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800d8f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d92:	01 d8                	add    %ebx,%eax
  800d94:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800d97:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9a:	3b 82 80 00 00 00    	cmp    0x80(%edx),%eax
  800da0:	77 0d                	ja     800daf <file_write+0x32>
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  800da2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800da5:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  800da8:	72 1d                	jb     800dc7 <file_write+0x4a>
  800daa:	e9 85 00 00 00       	jmp    800e34 <file_write+0xb7>
	off_t pos;
	char *blk;

	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
  800daf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800db2:	89 54 24 04          	mov    %edx,0x4(%esp)
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	89 04 24             	mov    %eax,(%esp)
  800dbc:	e8 7c ff ff ff       	call   800d3d <file_set_size>
  800dc1:	85 c0                	test   %eax,%eax
  800dc3:	79 dd                	jns    800da2 <file_write+0x25>
  800dc5:	eb 70                	jmp    800e37 <file_write+0xba>
			return r;

	for (pos = offset; pos < offset + count; ) {
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800dc7:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  800dca:	89 54 24 08          	mov    %edx,0x8(%esp)
  800dce:	89 d8                	mov    %ebx,%eax
  800dd0:	c1 f8 1f             	sar    $0x1f,%eax
  800dd3:	c1 e8 14             	shr    $0x14,%eax
  800dd6:	01 d8                	add    %ebx,%eax
  800dd8:	c1 f8 0c             	sar    $0xc,%eax
  800ddb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	89 04 24             	mov    %eax,(%esp)
  800de5:	e8 46 fc ff ff       	call   800a30 <file_get_block>
  800dea:	85 c0                	test   %eax,%eax
  800dec:	78 49                	js     800e37 <file_write+0xba>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800dee:	89 da                	mov    %ebx,%edx
  800df0:	c1 fa 1f             	sar    $0x1f,%edx
  800df3:	c1 ea 14             	shr    $0x14,%edx
  800df6:	8d 04 13             	lea    (%ebx,%edx,1),%eax
  800df9:	25 ff 0f 00 00       	and    $0xfff,%eax
  800dfe:	29 d0                	sub    %edx,%eax
  800e00:	be 00 10 00 00       	mov    $0x1000,%esi
  800e05:	29 c6                	sub    %eax,%esi
  800e07:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800e0a:	2b 55 d0             	sub    -0x30(%ebp),%edx
  800e0d:	39 d6                	cmp    %edx,%esi
  800e0f:	76 02                	jbe    800e13 <file_write+0x96>
  800e11:	89 d6                	mov    %edx,%esi
		memmove(blk + pos % BLKSIZE, buf, bn);
  800e13:	89 74 24 08          	mov    %esi,0x8(%esp)
  800e17:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800e1b:	03 45 e4             	add    -0x1c(%ebp),%eax
  800e1e:	89 04 24             	mov    %eax,(%esp)
  800e21:	e8 ff 1b 00 00       	call   802a25 <memmove>
		pos += bn;
  800e26:	01 f3                	add    %esi,%ebx
	// Extend file if necessary
	if (offset + count > f->f_size)
		if ((r = file_set_size(f, offset + count)) < 0)
			return r;

	for (pos = offset; pos < offset + count; ) {
  800e28:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800e2b:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800e2e:	76 04                	jbe    800e34 <file_write+0xb7>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
		memmove(blk + pos % BLKSIZE, buf, bn);
		pos += bn;
		buf += bn;
  800e30:	01 f7                	add    %esi,%edi
  800e32:	eb 93                	jmp    800dc7 <file_write+0x4a>
	}

	return count;
  800e34:	8b 45 10             	mov    0x10(%ebp),%eax
}
  800e37:	83 c4 3c             	add    $0x3c,%esp
  800e3a:	5b                   	pop    %ebx
  800e3b:	5e                   	pop    %esi
  800e3c:	5f                   	pop    %edi
  800e3d:	5d                   	pop    %ebp
  800e3e:	c3                   	ret    

00800e3f <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	83 ec 18             	sub    $0x18,%esp
	if (super->s_magic != FS_MAGIC)
  800e45:	a1 e4 d0 80 00       	mov    0x80d0e4,%eax
  800e4a:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  800e50:	74 1c                	je     800e6e <check_super+0x2f>
		panic("bad file system magic number");
  800e52:	c7 44 24 08 3b 4b 80 	movl   $0x804b3b,0x8(%esp)
  800e59:	00 
  800e5a:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800e61:	00 
  800e62:	c7 04 24 c7 4a 80 00 	movl   $0x804ac7,(%esp)
  800e69:	e8 52 12 00 00       	call   8020c0 <_panic>

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800e6e:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  800e75:	76 1c                	jbe    800e93 <check_super+0x54>
		panic("file system is too large");
  800e77:	c7 44 24 08 58 4b 80 	movl   $0x804b58,0x8(%esp)
  800e7e:	00 
  800e7f:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  800e86:	00 
  800e87:	c7 04 24 c7 4a 80 00 	movl   $0x804ac7,(%esp)
  800e8e:	e8 2d 12 00 00       	call   8020c0 <_panic>

	cprintf("superblock is good\n");
  800e93:	c7 04 24 71 4b 80 00 	movl   $0x804b71,(%esp)
  800e9a:	e8 e6 12 00 00       	call   802185 <cprintf>
}
  800e9f:	c9                   	leave  
  800ea0:	c3                   	ret    

00800ea1 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	57                   	push   %edi
  800ea5:	56                   	push   %esi
  800ea6:	53                   	push   %ebx
  800ea7:	81 ec cc 00 00 00    	sub    $0xcc,%esp
  800ead:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
  800eb3:	89 8d 3c ff ff ff    	mov    %ecx,-0xc4(%ebp)
	struct File *dir, *f;
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
  800eb9:	e8 60 f8 ff ff       	call   80071e <skip_slash>
  800ebe:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)
	f = &super->s_root;
  800ec4:	a1 e4 d0 80 00       	mov    0x80d0e4,%eax
	dir = 0;
	name[0] = 0;
  800ec9:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  800ed0:	83 bd 40 ff ff ff 00 	cmpl   $0x0,-0xc0(%ebp)
  800ed7:	74 0c                	je     800ee5 <walk_path+0x44>
		*pdir = 0;
  800ed9:	8b 95 40 ff ff ff    	mov    -0xc0(%ebp),%edx
  800edf:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800ee5:	83 c0 08             	add    $0x8,%eax
  800ee8:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
	dir = 0;
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
  800eee:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
  800ef4:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
  800efa:	ba 00 00 00 00       	mov    $0x0,%edx
	while (*path != '\0') {
  800eff:	e9 a0 01 00 00       	jmp    8010a4 <walk_path+0x203>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800f04:	83 c6 01             	add    $0x1,%esi
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  800f07:	0f b6 06             	movzbl (%esi),%eax
  800f0a:	3c 2f                	cmp    $0x2f,%al
  800f0c:	74 04                	je     800f12 <walk_path+0x71>
  800f0e:	84 c0                	test   %al,%al
  800f10:	75 f2                	jne    800f04 <walk_path+0x63>
			path++;
		if (path - p >= MAXNAMELEN)
  800f12:	89 f3                	mov    %esi,%ebx
  800f14:	2b 9d 48 ff ff ff    	sub    -0xb8(%ebp),%ebx
  800f1a:	83 fb 7f             	cmp    $0x7f,%ebx
  800f1d:	7e 0a                	jle    800f29 <walk_path+0x88>
  800f1f:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800f24:	e9 c2 01 00 00       	jmp    8010eb <walk_path+0x24a>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  800f29:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800f2d:	8b 85 48 ff ff ff    	mov    -0xb8(%ebp),%eax
  800f33:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f37:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
  800f3d:	89 14 24             	mov    %edx,(%esp)
  800f40:	e8 e0 1a 00 00       	call   802a25 <memmove>
		name[path - p] = '\0';
  800f45:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800f4c:	00 
		path = skip_slash(path);
  800f4d:	89 f0                	mov    %esi,%eax
  800f4f:	e8 ca f7 ff ff       	call   80071e <skip_slash>
  800f54:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

		if (dir->f_type != FTYPE_DIR)
  800f5a:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800f60:	83 b9 84 00 00 00 01 	cmpl   $0x1,0x84(%ecx)
  800f67:	0f 85 79 01 00 00    	jne    8010e6 <walk_path+0x245>
	struct File *f;

	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
  800f6d:	8b 81 80 00 00 00    	mov    0x80(%ecx),%eax
  800f73:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800f78:	74 24                	je     800f9e <walk_path+0xfd>
  800f7a:	c7 44 24 0c 85 4b 80 	movl   $0x804b85,0xc(%esp)
  800f81:	00 
  800f82:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  800f89:	00 
  800f8a:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  800f91:	00 
  800f92:	c7 04 24 c7 4a 80 00 	movl   $0x804ac7,(%esp)
  800f99:	e8 22 11 00 00       	call   8020c0 <_panic>
	nblock = dir->f_size / BLKSIZE;
  800f9e:	89 c2                	mov    %eax,%edx
  800fa0:	c1 fa 1f             	sar    $0x1f,%edx
  800fa3:	c1 ea 14             	shr    $0x14,%edx
  800fa6:	8d 04 02             	lea    (%edx,%eax,1),%eax
  800fa9:	c1 f8 0c             	sar    $0xc,%eax
  800fac:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
	for (i = 0; i < nblock; i++) {
  800fb2:	85 c0                	test   %eax,%eax
  800fb4:	0f 84 8a 00 00 00    	je     801044 <walk_path+0x1a3>
  800fba:	c7 85 50 ff ff ff 00 	movl   $0x0,-0xb0(%ebp)
  800fc1:	00 00 00 
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  800fc4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800fca:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800fd0:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fd4:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  800fda:	89 54 24 04          	mov    %edx,0x4(%esp)
  800fde:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800fe4:	89 0c 24             	mov    %ecx,(%esp)
  800fe7:	e8 44 fa ff ff       	call   800a30 <file_get_block>
  800fec:	85 c0                	test   %eax,%eax
  800fee:	78 4b                	js     80103b <walk_path+0x19a>
  800ff0:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
// and set *pdir to the directory the file is in.
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
  800ff6:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
  800ffc:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (strcmp(f[j].f_name, name) == 0) {
  801002:	89 74 24 04          	mov    %esi,0x4(%esp)
  801006:	89 1c 24             	mov    %ebx,(%esp)
  801009:	e8 eb 18 00 00       	call   8028f9 <strcmp>
  80100e:	85 c0                	test   %eax,%eax
  801010:	0f 84 82 00 00 00    	je     801098 <walk_path+0x1f7>
  801016:	81 c3 00 01 00 00    	add    $0x100,%ebx
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  80101c:	3b 9d 54 ff ff ff    	cmp    -0xac(%ebp),%ebx
  801022:	75 de                	jne    801002 <walk_path+0x161>
	// Search dir for name.
	// We maintain the invariant that the size of a directory-file
	// is always a multiple of the file system's block size.
	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  801024:	83 85 50 ff ff ff 01 	addl   $0x1,-0xb0(%ebp)
  80102b:	8b 95 50 ff ff ff    	mov    -0xb0(%ebp),%edx
  801031:	39 95 44 ff ff ff    	cmp    %edx,-0xbc(%ebp)
  801037:	77 91                	ja     800fca <walk_path+0x129>
  801039:	eb 09                	jmp    801044 <walk_path+0x1a3>

		if (dir->f_type != FTYPE_DIR)
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  80103b:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80103e:	0f 85 a7 00 00 00    	jne    8010eb <walk_path+0x24a>
  801044:	8b 8d 48 ff ff ff    	mov    -0xb8(%ebp),%ecx
  80104a:	80 39 00             	cmpb   $0x0,(%ecx)
  80104d:	0f 85 93 00 00 00    	jne    8010e6 <walk_path+0x245>
				if (pdir)
  801053:	83 bd 40 ff ff ff 00 	cmpl   $0x0,-0xc0(%ebp)
  80105a:	74 0e                	je     80106a <walk_path+0x1c9>
					*pdir = dir;
  80105c:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  801062:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  801068:	89 10                	mov    %edx,(%eax)
				if (lastelem)
  80106a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106e:	74 15                	je     801085 <walk_path+0x1e4>
					strcpy(lastelem, name);
  801070:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801076:	89 44 24 04          	mov    %eax,0x4(%esp)
  80107a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80107d:	89 0c 24             	mov    %ecx,(%esp)
  801080:	e8 e5 17 00 00       	call   80286a <strcpy>
				*pf = 0;
  801085:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  80108b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801091:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  801096:	eb 53                	jmp    8010eb <walk_path+0x24a>
  801098:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
  80109e:	89 9d 4c ff ff ff    	mov    %ebx,-0xb4(%ebp)
	name[0] = 0;

	if (pdir)
		*pdir = 0;
	*pf = 0;
	while (*path != '\0') {
  8010a4:	8b 8d 48 ff ff ff    	mov    -0xb8(%ebp),%ecx
  8010aa:	0f b6 01             	movzbl (%ecx),%eax
  8010ad:	84 c0                	test   %al,%al
  8010af:	74 0f                	je     8010c0 <walk_path+0x21f>
  8010b1:	89 ce                	mov    %ecx,%esi
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
  8010b3:	3c 2f                	cmp    $0x2f,%al
  8010b5:	0f 85 49 fe ff ff    	jne    800f04 <walk_path+0x63>
  8010bb:	e9 52 fe ff ff       	jmp    800f12 <walk_path+0x71>
			}
			return r;
		}
	}

	if (pdir)
  8010c0:	83 bd 40 ff ff ff 00 	cmpl   $0x0,-0xc0(%ebp)
  8010c7:	74 08                	je     8010d1 <walk_path+0x230>
		*pdir = dir;
  8010c9:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  8010cf:	89 10                	mov    %edx,(%eax)
	*pf = f;
  8010d1:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  8010d7:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
  8010dd:	89 0a                	mov    %ecx,(%edx)
  8010df:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8010e4:	eb 05                	jmp    8010eb <walk_path+0x24a>
  8010e6:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
}
  8010eb:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  8010f1:	5b                   	pop    %ebx
  8010f2:	5e                   	pop    %esi
  8010f3:	5f                   	pop    %edi
  8010f4:	5d                   	pop    %ebp
  8010f5:	c3                   	ret    

008010f6 <file_remove>:
}

// Remove a file by truncating it and then zeroing the name.
int
file_remove(const char *path)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct File *f;

	if ((r = walk_path(path, 0, &f, 0)) < 0)
  8010fc:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  8010ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801106:	ba 00 00 00 00       	mov    $0x0,%edx
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	e8 8e fd ff ff       	call   800ea1 <walk_path>
  801113:	85 c0                	test   %eax,%eax
  801115:	78 30                	js     801147 <file_remove+0x51>
		return r;

	file_truncate_blocks(f, 0);
  801117:	ba 00 00 00 00       	mov    $0x0,%edx
  80111c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111f:	e8 65 fb ff ff       	call   800c89 <file_truncate_blocks>
	f->f_name[0] = '\0';
  801124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801127:	c6 00 00             	movb   $0x0,(%eax)
	f->f_size = 0;
  80112a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112d:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
  801134:	00 00 00 
	flush_block(f);
  801137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113a:	89 04 24             	mov    %eax,(%esp)
  80113d:	e8 ee f2 ff ff       	call   800430 <flush_block>
  801142:	b8 00 00 00 00       	mov    $0x0,%eax

	return 0;
}
  801147:	c9                   	leave  
  801148:	c3                   	ret    

00801149 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	83 ec 18             	sub    $0x18,%esp
	return walk_path(path, 0, pf, 0);
  80114f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801156:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801159:	ba 00 00 00 00       	mov    $0x0,%edx
  80115e:	8b 45 08             	mov    0x8(%ebp),%eax
  801161:	e8 3b fd ff ff       	call   800ea1 <walk_path>
}
  801166:	c9                   	leave  
  801167:	c3                   	ret    

00801168 <file_create>:

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
{
  801168:	55                   	push   %ebp
  801169:	89 e5                	mov    %esp,%ebp
  80116b:	57                   	push   %edi
  80116c:	56                   	push   %esi
  80116d:	53                   	push   %ebx
  80116e:	81 ec bc 00 00 00    	sub    $0xbc,%esp
	char name[MAXNAMELEN];
	int r;
	struct File *dir, *f;

	if ((r = walk_path(path, &dir, &f, name)) == 0)
  801174:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  80117a:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  801180:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  801186:	89 04 24             	mov    %eax,(%esp)
  801189:	8b 45 08             	mov    0x8(%ebp),%eax
  80118c:	e8 10 fd ff ff       	call   800ea1 <walk_path>
  801191:	89 c3                	mov    %eax,%ebx
  801193:	85 c0                	test   %eax,%eax
  801195:	0f 84 ed 00 00 00    	je     801288 <file_create+0x120>
		return -E_FILE_EXISTS;
	if (r != -E_NOT_FOUND || dir == 0)
  80119b:	83 f8 f5             	cmp    $0xfffffff5,%eax
  80119e:	0f 85 e9 00 00 00    	jne    80128d <file_create+0x125>
  8011a4:	8b bd 64 ff ff ff    	mov    -0x9c(%ebp),%edi
  8011aa:	85 ff                	test   %edi,%edi
  8011ac:	0f 84 db 00 00 00    	je     80128d <file_create+0x125>
	int r;
	uint32_t nblock, i, j;
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
  8011b2:	8b 87 80 00 00 00    	mov    0x80(%edi),%eax
  8011b8:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8011bd:	74 24                	je     8011e3 <file_create+0x7b>
  8011bf:	c7 44 24 0c 85 4b 80 	movl   $0x804b85,0xc(%esp)
  8011c6:	00 
  8011c7:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  8011ce:	00 
  8011cf:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  8011d6:	00 
  8011d7:	c7 04 24 c7 4a 80 00 	movl   $0x804ac7,(%esp)
  8011de:	e8 dd 0e 00 00       	call   8020c0 <_panic>
	nblock = dir->f_size / BLKSIZE;
  8011e3:	89 c2                	mov    %eax,%edx
  8011e5:	c1 fa 1f             	sar    $0x1f,%edx
  8011e8:	c1 ea 14             	shr    $0x14,%edx
  8011eb:	8d 04 02             	lea    (%edx,%eax,1),%eax
  8011ee:	c1 f8 0c             	sar    $0xc,%eax
  8011f1:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
	for (i = 0; i < nblock; i++) {
  8011f7:	be 00 00 00 00       	mov    $0x0,%esi
  8011fc:	85 c0                	test   %eax,%eax
  8011fe:	74 56                	je     801256 <file_create+0xee>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  801200:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  801206:	89 44 24 08          	mov    %eax,0x8(%esp)
  80120a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80120e:	89 3c 24             	mov    %edi,(%esp)
  801211:	e8 1a f8 ff ff       	call   800a30 <file_get_block>
  801216:	85 c0                	test   %eax,%eax
  801218:	78 73                	js     80128d <file_create+0x125>
			return r;
		f = (struct File*) blk;
  80121a:	8b 8d 5c ff ff ff    	mov    -0xa4(%ebp),%ecx
  801220:	89 ca                	mov    %ecx,%edx
		for (j = 0; j < BLKFILES; j++)
			if (f[j].f_name[0] == '\0') {
  801222:	80 39 00             	cmpb   $0x0,(%ecx)
  801225:	74 13                	je     80123a <file_create+0xd2>
  801227:	8d 81 00 01 00 00    	lea    0x100(%ecx),%eax
// --------------------------------------------------------------

// Create "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_create(const char *path, struct File **pf)
  80122d:	81 c1 00 10 00 00    	add    $0x1000,%ecx
  801233:	89 c2                	mov    %eax,%edx
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
			if (f[j].f_name[0] == '\0') {
  801235:	80 38 00             	cmpb   $0x0,(%eax)
  801238:	75 08                	jne    801242 <file_create+0xda>
				*file = &f[j];
  80123a:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  801240:	eb 58                	jmp    80129a <file_create+0x132>
  801242:	05 00 01 00 00       	add    $0x100,%eax
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
		if ((r = file_get_block(dir, i, &blk)) < 0)
			return r;
		f = (struct File*) blk;
		for (j = 0; j < BLKFILES; j++)
  801247:	39 c8                	cmp    %ecx,%eax
  801249:	75 e8                	jne    801233 <file_create+0xcb>
	char *blk;
	struct File *f;

	assert((dir->f_size % BLKSIZE) == 0);
	nblock = dir->f_size / BLKSIZE;
	for (i = 0; i < nblock; i++) {
  80124b:	83 c6 01             	add    $0x1,%esi
  80124e:	39 b5 54 ff ff ff    	cmp    %esi,-0xac(%ebp)
  801254:	77 aa                	ja     801200 <file_create+0x98>
			if (f[j].f_name[0] == '\0') {
				*file = &f[j];
				return 0;
			}
	}
	dir->f_size += BLKSIZE;
  801256:	81 87 80 00 00 00 00 	addl   $0x1000,0x80(%edi)
  80125d:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  801260:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  801266:	89 44 24 08          	mov    %eax,0x8(%esp)
  80126a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80126e:	89 3c 24             	mov    %edi,(%esp)
  801271:	e8 ba f7 ff ff       	call   800a30 <file_get_block>
  801276:	85 c0                	test   %eax,%eax
  801278:	78 13                	js     80128d <file_create+0x125>
		return r;
	f = (struct File*) blk;
	*file = &f[0];
  80127a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  801280:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  801286:	eb 12                	jmp    80129a <file_create+0x132>
  801288:	bb f3 ff ff ff       	mov    $0xfffffff3,%ebx
		return r;
	strcpy(f->f_name, name);
	*pf = f;
	file_flush(dir);
	return 0;
}
  80128d:	89 d8                	mov    %ebx,%eax
  80128f:	81 c4 bc 00 00 00    	add    $0xbc,%esp
  801295:	5b                   	pop    %ebx
  801296:	5e                   	pop    %esi
  801297:	5f                   	pop    %edi
  801298:	5d                   	pop    %ebp
  801299:	c3                   	ret    
		return -E_FILE_EXISTS;
	if (r != -E_NOT_FOUND || dir == 0)
		return r;
	if (dir_alloc_file(dir, &f) < 0)
		return r;
	strcpy(f->f_name, name);
  80129a:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  8012a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012a4:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  8012aa:	89 04 24             	mov    %eax,(%esp)
  8012ad:	e8 b8 15 00 00       	call   80286a <strcpy>
	*pf = f;
  8012b2:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  8012b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012bb:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  8012bd:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
  8012c3:	89 04 24             	mov    %eax,(%esp)
  8012c6:	e8 c2 f6 ff ff       	call   80098d <file_flush>
  8012cb:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8012d0:	eb bb                	jmp    80128d <file_create+0x125>

008012d2 <swap_init>:


//Intialize swapspace

void swap_init(void)
{
  8012d2:	55                   	push   %ebp
  8012d3:	89 e5                	mov    %esp,%ebp
  8012d5:	57                   	push   %edi
  8012d6:	56                   	push   %esi
  8012d7:	53                   	push   %ebx
  8012d8:	81 ec ac 00 00 00    	sub    $0xac,%esp
int block = 0;
uint32_t ONE=1;
uint32_t maxValue=0xFFFFFFFF;
uint32_t *indirectBlockBase;
	// creates the swap file on the boot up
	if(file_create("/swap",&f) == -E_FILE_EXISTS)
  8012de:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e5:	c7 04 24 a2 4b 80 00 	movl   $0x804ba2,(%esp)
  8012ec:	e8 77 fe ff ff       	call   801168 <file_create>
  8012f1:	83 f8 f3             	cmp    $0xfffffff3,%eax
  8012f4:	0f 85 30 01 00 00    	jne    80142a <swap_init+0x158>
    		 ** If the file is already present, then open the file
                 ** and clean the bitmap and all the occupied blocks.
                 ** We do not have to allocate blocks again, as the file 
		 ** became persistent on disk. 
		 **/
		cprintf("\nFile exists\n");
  8012fa:	c7 04 24 a8 4b 80 00 	movl   $0x804ba8,(%esp)
  801301:	e8 7f 0e 00 00       	call   802185 <cprintf>
		file_open("/swap",&f);
  801306:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801309:	89 44 24 04          	mov    %eax,0x4(%esp)
  80130d:	c7 04 24 a2 4b 80 00 	movl   $0x804ba2,(%esp)
  801314:	e8 30 fe ff ff       	call   801149 <file_open>
		swap_handler.swap_file = f;
  801319:	be 00 d1 80 00       	mov    $0x80d100,%esi
  80131e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801321:	89 06                	mov    %eax,(%esi)
		cprintf("\n>>>>>>SWAPPING>>>>>>>>%x   %x\n",swap_handler,swap_handler.bitmap);
  801323:	c7 84 24 8c 00 00 00 	movl   $0x80d104,0x8c(%esp)
  80132a:	04 d1 80 00 
  80132e:	8d 7c 24 04          	lea    0x4(%esp),%edi
  801332:	b9 22 00 00 00       	mov    $0x22,%ecx
  801337:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801339:	c7 04 24 a0 4c 80 00 	movl   $0x804ca0,(%esp)
  801340:	e8 40 0e 00 00       	call   802185 <cprintf>
  801345:	bf d8 ff ff ff       	mov    $0xffffffd8,%edi
  80134a:	be 00 00 00 00       	mov    $0x0,%esi
		// clean all the previous block entries.
		for(block=0;block<(NDIRECT+NINDIRECT)/3;block++)
		{  // check which blocks have been previously occupied. Then go to the blocks and clear the entries. 
                   // 1 means free. ) 0 means occupied.
		   if(swap_handler.bitmap[(block/32)]!=maxValue && (swap_handler.bitmap[block/32] & (ONE << (block % 32)))==0)
  80134f:	89 f0                	mov    %esi,%eax
  801351:	c1 f8 1f             	sar    $0x1f,%eax
  801354:	c1 e8 1b             	shr    $0x1b,%eax
  801357:	01 f0                	add    %esi,%eax
  801359:	c1 f8 05             	sar    $0x5,%eax
  80135c:	8b 04 85 04 d1 80 00 	mov    0x80d104(,%eax,4),%eax
  801363:	83 f8 ff             	cmp    $0xffffffff,%eax
  801366:	0f 84 aa 00 00 00    	je     801416 <swap_init+0x144>
  80136c:	89 f2                	mov    %esi,%edx
  80136e:	c1 fa 1f             	sar    $0x1f,%edx
  801371:	c1 ea 1b             	shr    $0x1b,%edx
  801374:	8d 0c 16             	lea    (%esi,%edx,1),%ecx
  801377:	83 e1 1f             	and    $0x1f,%ecx
  80137a:	29 d1                	sub    %edx,%ecx
  80137c:	ba 01 00 00 00       	mov    $0x1,%edx
  801381:	d3 e2                	shl    %cl,%edx
  801383:	85 c2                	test   %eax,%edx
  801385:	0f 85 8b 00 00 00    	jne    801416 <swap_init+0x144>
		   {
			cprintf("\n>>>>>>%x\n",swap_handler.bitmap[(block/32)]);
  80138b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80138f:	c7 04 24 b6 4b 80 00 	movl   $0x804bb6,(%esp)
  801396:	e8 ea 0d 00 00       	call   802185 <cprintf>
			
		   	if(block<10)
  80139b:	83 fe 09             	cmp    $0x9,%esi
  80139e:	7f 2e                	jg     8013ce <swap_init+0xfc>
		   	{                   
				memset(diskaddr(swap_handler.swap_file->f_direct[block]),0,BLKSIZE);
  8013a0:	a1 00 d1 80 00       	mov    0x80d100,%eax
  8013a5:	8b 84 b0 88 00 00 00 	mov    0x88(%eax,%esi,4),%eax
  8013ac:	89 04 24             	mov    %eax,(%esp)
  8013af:	e8 1f ef ff ff       	call   8002d3 <diskaddr>
  8013b4:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8013bb:	00 
  8013bc:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8013c3:	00 
  8013c4:	89 04 24             	mov    %eax,(%esp)
  8013c7:	e8 fa 15 00 00       	call   8029c6 <memset>
  8013cc:	eb 48                	jmp    801416 <swap_init+0x144>
		   	}
		   	else
		   	{       //f->f_indirect gives the block no of the indirect block not the address.
				indirectBlockBase =(uint32_t *)diskaddr(swap_handler.swap_file->f_indirect);
  8013ce:	a1 00 d1 80 00       	mov    0x80d100,%eax
  8013d3:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
  8013d9:	89 04 24             	mov    %eax,(%esp)
  8013dc:	e8 f2 ee ff ff       	call   8002d3 <diskaddr>
  8013e1:	89 c3                	mov    %eax,%ebx
				// we need to get the block stored at ith position in Indirect block
				cprintf("\nBlock Panic>>>>%d\n",block);
  8013e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013e7:	c7 04 24 c1 4b 80 00 	movl   $0x804bc1,(%esp)
  8013ee:	e8 92 0d 00 00       	call   802185 <cprintf>
				memset(diskaddr(*(indirectBlockBase+block-10)),0,BLKSIZE);
  8013f3:	8b 04 3b             	mov    (%ebx,%edi,1),%eax
  8013f6:	89 04 24             	mov    %eax,(%esp)
  8013f9:	e8 d5 ee ff ff       	call   8002d3 <diskaddr>
  8013fe:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801405:	00 
  801406:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80140d:	00 
  80140e:	89 04 24             	mov    %eax,(%esp)
  801411:	e8 b0 15 00 00       	call   8029c6 <memset>
		cprintf("\nFile exists\n");
		file_open("/swap",&f);
		swap_handler.swap_file = f;
		cprintf("\n>>>>>>SWAPPING>>>>>>>>%x   %x\n",swap_handler,swap_handler.bitmap);
		// clean all the previous block entries.
		for(block=0;block<(NDIRECT+NINDIRECT)/3;block++)
  801416:	83 c6 01             	add    $0x1,%esi
  801419:	83 c7 04             	add    $0x4,%edi
  80141c:	81 fe 58 01 00 00    	cmp    $0x158,%esi
  801422:	0f 85 27 ff ff ff    	jne    80134f <swap_init+0x7d>
  801428:	eb 77                	jmp    8014a1 <swap_init+0x1cf>
                   }
		}
	}
	else
	{
		cprintf("\n-----Inside else swap_init>>>>>\n");
  80142a:	c7 04 24 c0 4c 80 00 	movl   $0x804cc0,(%esp)
  801431:	e8 4f 0d 00 00       	call   802185 <cprintf>
		swap_handler.swap_file = f;
  801436:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801439:	a3 00 d1 80 00       	mov    %eax,0x80d100
  80143e:	bb 00 00 00 00       	mov    $0x0,%ebx
		// else this is the first time the file is created.So,allocate the blocks to the file.
		while(i < (NDIRECT+NINDIRECT)/3) //343 bcz in total s-> n_blocks they are 1024	
	        {
			cprintf("\nInside while>>>>>%d\n",i);
		 	file_get_block(swap_handler.swap_file,i,0);  //swap_handler->swap_file previously
  801443:	be 00 d1 80 00       	mov    $0x80d100,%esi
		cprintf("\n-----Inside else swap_init>>>>>\n");
		swap_handler.swap_file = f;
		// else this is the first time the file is created.So,allocate the blocks to the file.
		while(i < (NDIRECT+NINDIRECT)/3) //343 bcz in total s-> n_blocks they are 1024	
	        {
			cprintf("\nInside while>>>>>%d\n",i);
  801448:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80144c:	c7 04 24 d5 4b 80 00 	movl   $0x804bd5,(%esp)
  801453:	e8 2d 0d 00 00       	call   802185 <cprintf>
		 	file_get_block(swap_handler.swap_file,i,0);  //swap_handler->swap_file previously
  801458:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80145f:	00 
  801460:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801464:	8b 06                	mov    (%esi),%eax
  801466:	89 04 24             	mov    %eax,(%esp)
  801469:	e8 c2 f5 ff ff       	call   800a30 <file_get_block>
  80146e:	83 c3 01             	add    $0x1,%ebx
	else
	{
		cprintf("\n-----Inside else swap_init>>>>>\n");
		swap_handler.swap_file = f;
		// else this is the first time the file is created.So,allocate the blocks to the file.
		while(i < (NDIRECT+NINDIRECT)/3) //343 bcz in total s-> n_blocks they are 1024	
  801471:	81 fb 58 01 00 00    	cmp    $0x158,%ebx
  801477:	75 cf                	jne    801448 <swap_init+0x176>
		 	file_get_block(swap_handler.swap_file,i,0);  //swap_handler->swap_file previously
		 	i++;      
	        }

		// flush the state of the swap_file(i.e the blocks allocated to file) on the disk
		flush_block((void *)swap_handler.swap_file);
  801479:	a1 00 d1 80 00       	mov    0x80d100,%eax
  80147e:	89 04 24             	mov    %eax,(%esp)
  801481:	e8 aa ef ff ff       	call   800430 <flush_block>
		flush_block(diskaddr(swap_handler.swap_file->f_indirect));
  801486:	a1 00 d1 80 00       	mov    0x80d100,%eax
  80148b:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
  801491:	89 04 24             	mov    %eax,(%esp)
  801494:	e8 3a ee ff ff       	call   8002d3 <diskaddr>
  801499:	89 04 24             	mov    %eax,(%esp)
  80149c:	e8 8f ef ff ff       	call   800430 <flush_block>
	
	//clearing bitmap setting them free on startup.
	
	// write the swap struct file
	//flush_block((void *)swap_handler);
}
  8014a1:	81 c4 ac 00 00 00    	add    $0xac,%esp
  8014a7:	5b                   	pop    %ebx
  8014a8:	5e                   	pop    %esi
  8014a9:	5f                   	pop    %edi
  8014aa:	5d                   	pop    %ebp
  8014ab:	c3                   	ret    

008014ac <fs_init>:
// --------------------------------------------------------------

// Initialize the file system
void
fs_init(void)
{
  8014ac:	55                   	push   %ebp
  8014ad:	89 e5                	mov    %esp,%ebp
  8014af:	83 ec 18             	sub    $0x18,%esp
	int swap_Handler_Block_No;
	static_assert(sizeof(struct File) == 256);

	// Find a JOS disk.  Use the second IDE disk (number 1) if available.
	if (ide_probe_disk1())
  8014b2:	e8 6d ed ff ff       	call   800224 <ide_probe_disk1>
  8014b7:	85 c0                	test   %eax,%eax
  8014b9:	74 0e                	je     8014c9 <fs_init+0x1d>
		ide_set_disk(1);
  8014bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8014c2:	e8 2c ed ff ff       	call   8001f3 <ide_set_disk>
  8014c7:	eb 0c                	jmp    8014d5 <fs_init+0x29>
	else
		ide_set_disk(0);
  8014c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014d0:	e8 1e ed ff ff       	call   8001f3 <ide_set_disk>
	
	bc_init();
  8014d5:	e8 eb f1 ff ff       	call   8006c5 <bc_init>

	// Set "super" to point to the super block.
	super = diskaddr(1);
  8014da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8014e1:	e8 ed ed ff ff       	call   8002d3 <diskaddr>
  8014e6:	a3 e4 d0 80 00       	mov    %eax,0x80d0e4
	// Set "bitmap" to the beginning of the first bitmap block.
	bitmap = diskaddr(2);
  8014eb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  8014f2:	e8 dc ed ff ff       	call   8002d3 <diskaddr>
  8014f7:	a3 e0 d0 80 00       	mov    %eax,0x80d0e0
	//cprintf("\nblock no......%d\n",alloc_block());
	cprintf("\nNo of blocks......%u\n",super->s_nblocks);
  8014fc:	a1 e4 d0 80 00       	mov    0x80d0e4,%eax
  801501:	8b 40 04             	mov    0x4(%eax),%eax
  801504:	89 44 24 04          	mov    %eax,0x4(%esp)
  801508:	c7 04 24 eb 4b 80 00 	movl   $0x804beb,(%esp)
  80150f:	e8 71 0c 00 00       	call   802185 <cprintf>
        //swap_Handler_Block_No=alloc_block();	
	//diskaddr(swap_Handler_Block_No);    
	
	//swap_handler=(struct Swap_Space *)malloc(sizeof(struct Swap_Space *));
	memset((void *)&swap_handler,0,sizeof(struct Swap_Space));
  801514:	c7 44 24 08 88 00 00 	movl   $0x88,0x8(%esp)
  80151b:	00 
  80151c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801523:	00 
  801524:	c7 04 24 00 d1 80 00 	movl   $0x80d100,(%esp)
  80152b:	e8 96 14 00 00       	call   8029c6 <memset>
	//cprintf("goofY1\n");	
	memset(swap_handler.bitmap,0xFF,NSWAPBLK_BITSIZE*4);
  801530:	c7 44 24 08 84 00 00 	movl   $0x84,0x8(%esp)
  801537:	00 
  801538:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80153f:	00 
  801540:	c7 04 24 04 d1 80 00 	movl   $0x80d104,(%esp)
  801547:	e8 7a 14 00 00       	call   8029c6 <memset>
	{
		swap_handler = (struct Swap_Space *)diskaddr(SWAPBLOCK);
		//flush_block((void *)swap_handler);	    
	}	
*/
	cprintf("\n>>>>Beforre Sueprrr>>>>>\n");
  80154c:	c7 04 24 02 4c 80 00 	movl   $0x804c02,(%esp)
  801553:	e8 2d 0c 00 00       	call   802185 <cprintf>
	check_super();
  801558:	e8 e2 f8 ff ff       	call   800e3f <check_super>
	check_bitmap();
  80155d:	e8 0f f6 ff ff       	call   800b71 <check_bitmap>
	
}
  801562:	c9                   	leave  
  801563:	c3                   	ret    
	...

00801570 <serve_init>:
// Virtual address at which to receive page mappings containing client requests.
union Fsipc *fsreq = (union Fsipc *)0x0ffff000;

void
serve_init(void)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	ba 20 90 80 00       	mov    $0x809020,%edx
  801578:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
  80157d:	b8 00 00 00 00       	mov    $0x0,%eax
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
		opentab[i].o_fileid = i;
  801582:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  801584:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  801587:	81 c1 00 10 00 00    	add    $0x1000,%ecx
void
serve_init(void)
{
	int i;
	uintptr_t va = FILEVA;
	for (i = 0; i < MAXOPEN; i++) {
  80158d:	83 c0 01             	add    $0x1,%eax
  801590:	83 c2 10             	add    $0x10,%edx
  801593:	3d 00 04 00 00       	cmp    $0x400,%eax
  801598:	75 e8                	jne    801582 <serve_init+0x12>
		opentab[i].o_fileid = i;
		opentab[i].o_fd = (struct Fd*) va;
		va += PGSIZE;
	}
}
  80159a:	5d                   	pop    %ebp
  80159b:	c3                   	ret    

0080159c <serve_sync>:
}

// Sync the file system.
int
serve_sync(envid_t envid, union Fsipc *req)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  8015a2:	e8 89 f1 ff ff       	call   800730 <fs_sync>
	return 0;
}
  8015a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ac:	c9                   	leave  
  8015ad:	c3                   	ret    

008015ae <serve_remove>:
}

// Remove the file req->req_path.
int
serve_remove(envid_t envid, struct Fsreq_remove *req)
{
  8015ae:	55                   	push   %ebp
  8015af:	89 e5                	mov    %esp,%ebp
  8015b1:	53                   	push   %ebx
  8015b2:	81 ec 14 04 00 00    	sub    $0x414,%esp

	// Delete the named file.
	// Note: This request doesn't refer to an open file.

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  8015b8:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  8015bf:	00 
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c7:	8d 9d f8 fb ff ff    	lea    -0x408(%ebp),%ebx
  8015cd:	89 1c 24             	mov    %ebx,(%esp)
  8015d0:	e8 50 14 00 00       	call   802a25 <memmove>
	path[MAXPATHLEN-1] = 0;
  8015d5:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)

	// Delete the specified file
	return file_remove(path);
  8015d9:	89 1c 24             	mov    %ebx,(%esp)
  8015dc:	e8 15 fb ff ff       	call   8010f6 <file_remove>
}
  8015e1:	81 c4 14 04 00 00    	add    $0x414,%esp
  8015e7:	5b                   	pop    %ebx
  8015e8:	5d                   	pop    %ebp
  8015e9:	c3                   	ret    

008015ea <openfile_lookup>:
}

// Look up an open file for envid.
int
openfile_lookup(envid_t envid, uint32_t fileid, struct OpenFile **po)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	83 ec 18             	sub    $0x18,%esp
  8015f0:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8015f3:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8015f6:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct OpenFile *o;

	o = &opentab[fileid % MAXOPEN];
  8015f9:	89 f3                	mov    %esi,%ebx
  8015fb:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  801601:	c1 e3 04             	shl    $0x4,%ebx
  801604:	81 c3 20 90 80 00    	add    $0x809020,%ebx
	if (pageref(o->o_fd) == 1 || o->o_fileid != fileid)
  80160a:	8b 43 0c             	mov    0xc(%ebx),%eax
  80160d:	89 04 24             	mov    %eax,(%esp)
  801610:	e8 6f 25 00 00       	call   803b84 <pageref>
  801615:	83 f8 01             	cmp    $0x1,%eax
  801618:	74 10                	je     80162a <openfile_lookup+0x40>
  80161a:	39 33                	cmp    %esi,(%ebx)
  80161c:	75 0c                	jne    80162a <openfile_lookup+0x40>
		return -E_INVAL;
	*po = o;
  80161e:	8b 45 10             	mov    0x10(%ebp),%eax
  801621:	89 18                	mov    %ebx,(%eax)
  801623:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  801628:	eb 05                	jmp    80162f <openfile_lookup+0x45>
  80162a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80162f:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801632:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801635:	89 ec                	mov    %ebp,%esp
  801637:	5d                   	pop    %ebp
  801638:	c3                   	ret    

00801639 <serve_flush>:
}

// Flush all data and metadata of req->req_fileid to disk.
int
serve_flush(envid_t envid, struct Fsreq_flush *req)
{
  801639:	55                   	push   %ebp
  80163a:	89 e5                	mov    %esp,%ebp
  80163c:	83 ec 28             	sub    $0x28,%esp
	int r;

	if (debug)
		cprintf("serve_flush %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80163f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801642:	89 44 24 08          	mov    %eax,0x8(%esp)
  801646:	8b 45 0c             	mov    0xc(%ebp),%eax
  801649:	8b 00                	mov    (%eax),%eax
  80164b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164f:	8b 45 08             	mov    0x8(%ebp),%eax
  801652:	89 04 24             	mov    %eax,(%esp)
  801655:	e8 90 ff ff ff       	call   8015ea <openfile_lookup>
  80165a:	85 c0                	test   %eax,%eax
  80165c:	78 13                	js     801671 <serve_flush+0x38>
		return r;
	file_flush(o->o_file);
  80165e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801661:	8b 40 04             	mov    0x4(%eax),%eax
  801664:	89 04 24             	mov    %eax,(%esp)
  801667:	e8 21 f3 ff ff       	call   80098d <file_flush>
  80166c:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801671:	c9                   	leave  
  801672:	c3                   	ret    

00801673 <serve_stat>:

// Stat ipc->stat.req_fileid.  Return the file's struct Stat to the
// caller in ipc->statRet.
int
serve_stat(envid_t envid, union Fsipc *ipc)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	53                   	push   %ebx
  801677:	83 ec 24             	sub    $0x24,%esp
  80167a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	if (debug)
		cprintf("serve_stat %08x %08x\n", envid, req->req_fileid);

	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80167d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801680:	89 44 24 08          	mov    %eax,0x8(%esp)
  801684:	8b 03                	mov    (%ebx),%eax
  801686:	89 44 24 04          	mov    %eax,0x4(%esp)
  80168a:	8b 45 08             	mov    0x8(%ebp),%eax
  80168d:	89 04 24             	mov    %eax,(%esp)
  801690:	e8 55 ff ff ff       	call   8015ea <openfile_lookup>
  801695:	85 c0                	test   %eax,%eax
  801697:	78 3f                	js     8016d8 <serve_stat+0x65>
		return r;

	strcpy(ret->ret_name, o->o_file->f_name);
  801699:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169c:	8b 40 04             	mov    0x4(%eax),%eax
  80169f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016a3:	89 1c 24             	mov    %ebx,(%esp)
  8016a6:	e8 bf 11 00 00       	call   80286a <strcpy>
	ret->ret_size = o->o_file->f_size;
  8016ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ae:	8b 50 04             	mov    0x4(%eax),%edx
  8016b1:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  8016b7:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_isdir = (o->o_file->f_type == FTYPE_DIR);
  8016bd:	8b 40 04             	mov    0x4(%eax),%eax
  8016c0:	83 b8 84 00 00 00 01 	cmpl   $0x1,0x84(%eax)
  8016c7:	0f 94 c0             	sete   %al
  8016ca:	0f b6 c0             	movzbl %al,%eax
  8016cd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  8016d3:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8016d8:	83 c4 24             	add    $0x24,%esp
  8016db:	5b                   	pop    %ebx
  8016dc:	5d                   	pop    %ebp
  8016dd:	c3                   	ret    

008016de <serve_write>:
// accordingly.  Extend the file if necessary.  Returns the number of
// bytes written, or < 0 on error.

int
serve_write(envid_t envid, struct Fsreq_write *req)
{
  8016de:	55                   	push   %ebp
  8016df:	89 e5                	mov    %esp,%ebp
  8016e1:	53                   	push   %ebx
  8016e2:	83 ec 24             	sub    $0x24,%esp
  8016e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if (debug)
		cprintf("serve_write %08x %08x %08x\n", envid, req->req_fileid, req->req_n);

	// LAB 5: Your code here.
         
        if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8016e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016eb:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016ef:	8b 03                	mov    (%ebx),%eax
  8016f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f8:	89 04 24             	mov    %eax,(%esp)
  8016fb:	e8 ea fe ff ff       	call   8015ea <openfile_lookup>
  801700:	85 c0                	test   %eax,%eax
  801702:	78 33                	js     801737 <serve_write+0x59>
		return r;
                 //int n=0;
            // if(sizeof(req->req_buf)<sizeof(req->req_n))
              //       n=
        if((r = file_write(o->o_file,req->req_buf,req->req_n,o->o_fd->fd_offset))<0)
  801704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801707:	8b 50 0c             	mov    0xc(%eax),%edx
  80170a:	8b 52 04             	mov    0x4(%edx),%edx
  80170d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801711:	8b 53 04             	mov    0x4(%ebx),%edx
  801714:	89 54 24 08          	mov    %edx,0x8(%esp)
  801718:	83 c3 08             	add    $0x8,%ebx
  80171b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80171f:	8b 40 04             	mov    0x4(%eax),%eax
  801722:	89 04 24             	mov    %eax,(%esp)
  801725:	e8 53 f6 ff ff       	call   800d7d <file_write>
  80172a:	85 c0                	test   %eax,%eax
  80172c:	78 09                	js     801737 <serve_write+0x59>
              return r;
            o->o_fd->fd_offset+=r;
  80172e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801731:	8b 52 0c             	mov    0xc(%edx),%edx
  801734:	01 42 04             	add    %eax,0x4(%edx)
          return r;
}
  801737:	83 c4 24             	add    $0x24,%esp
  80173a:	5b                   	pop    %ebx
  80173b:	5d                   	pop    %ebp
  80173c:	c3                   	ret    

0080173d <serve_read>:
// in ipc->read.req_fileid.  Return the bytes read from the file to
// the caller in ipc->readRet, then update the seek position.  Returns
// the number of bytes successfully read, or < 0 on error.
int
serve_read(envid_t envid, union Fsipc *ipc)
{
  80173d:	55                   	push   %ebp
  80173e:	89 e5                	mov    %esp,%ebp
  801740:	53                   	push   %ebx
  801741:	83 ec 24             	sub    $0x24,%esp
  801744:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// so filling in ret will overwrite req.
	//
	// Hint: Use file_read.
	// Hint: The seek position is stored in the struct Fd.
	// LAB 5: Your code here
	 if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801747:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80174e:	8b 03                	mov    (%ebx),%eax
  801750:	89 44 24 04          	mov    %eax,0x4(%esp)
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	89 04 24             	mov    %eax,(%esp)
  80175a:	e8 8b fe ff ff       	call   8015ea <openfile_lookup>
  80175f:	85 c0                	test   %eax,%eax
  801761:	78 3c                	js     80179f <serve_read+0x62>
		return r;
         if(req->req_n > PGSIZE)
            numberOfBytes = PGSIZE;
          else
             numberOfBytes = req->req_n;
      if((r = file_read(o->o_file, ipc->readRet.ret_buf,numberOfBytes,o->o_fd->fd_offset))<0)
  801763:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801766:	8b 42 0c             	mov    0xc(%edx),%eax
  801769:	8b 40 04             	mov    0x4(%eax),%eax
  80176c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801770:	8b 43 04             	mov    0x4(%ebx),%eax
  801773:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801778:	76 05                	jbe    80177f <serve_read+0x42>
  80177a:	b8 00 10 00 00       	mov    $0x1000,%eax
  80177f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801783:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801787:	8b 42 04             	mov    0x4(%edx),%eax
  80178a:	89 04 24             	mov    %eax,(%esp)
  80178d:	e8 24 f3 ff ff       	call   800ab6 <file_read>
  801792:	85 c0                	test   %eax,%eax
  801794:	78 09                	js     80179f <serve_read+0x62>
              return r;
       o->o_fd->fd_offset+=r;
  801796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801799:	8b 52 0c             	mov    0xc(%edx),%edx
  80179c:	01 42 04             	add    %eax,0x4(%edx)
          return r;
         //panic("serve_read not implemented");
}
  80179f:	83 c4 24             	add    $0x24,%esp
  8017a2:	5b                   	pop    %ebx
  8017a3:	5d                   	pop    %ebp
  8017a4:	c3                   	ret    

008017a5 <serve_set_size>:

// Set the size of req->req_fileid to req->req_size bytes, truncating
// or extending the file as necessary.
int
serve_set_size(envid_t envid, struct Fsreq_set_size *req)
{
  8017a5:	55                   	push   %ebp
  8017a6:	89 e5                	mov    %esp,%ebp
  8017a8:	53                   	push   %ebx
  8017a9:	83 ec 24             	sub    $0x24,%esp
  8017ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Every file system IPC call has the same general structure.
	// Here's how it goes.

	// First, use openfile_lookup to find the relevant open file.
	// On failure, return the error code to the client with ipc_send.
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8017af:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017b6:	8b 03                	mov    (%ebx),%eax
  8017b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	89 04 24             	mov    %eax,(%esp)
  8017c2:	e8 23 fe ff ff       	call   8015ea <openfile_lookup>
  8017c7:	85 c0                	test   %eax,%eax
  8017c9:	78 15                	js     8017e0 <serve_set_size+0x3b>
		return r;

	// Second, call the relevant file system function (from fs/fs.c).
	// On failure, return the error code to the client.
	return file_set_size(o->o_file, req->req_size);
  8017cb:	8b 43 04             	mov    0x4(%ebx),%eax
  8017ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d5:	8b 40 04             	mov    0x4(%eax),%eax
  8017d8:	89 04 24             	mov    %eax,(%esp)
  8017db:	e8 5d f5 ff ff       	call   800d3d <file_set_size>
}
  8017e0:	83 c4 24             	add    $0x24,%esp
  8017e3:	5b                   	pop    %ebx
  8017e4:	5d                   	pop    %ebp
  8017e5:	c3                   	ret    

008017e6 <openfile_alloc>:
}

// Allocate an open file.
int
openfile_alloc(struct OpenFile **o)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	83 ec 28             	sub    $0x28,%esp
  8017ec:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8017ef:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8017f2:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8017f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017f8:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
		switch (pageref(opentab[i].o_fd)) {
  8017fd:	be 2c 90 80 00       	mov    $0x80902c,%esi
  801802:	89 d8                	mov    %ebx,%eax
  801804:	c1 e0 04             	shl    $0x4,%eax
  801807:	8b 04 06             	mov    (%esi,%eax,1),%eax
  80180a:	89 04 24             	mov    %eax,(%esp)
  80180d:	e8 72 23 00 00       	call   803b84 <pageref>
  801812:	85 c0                	test   %eax,%eax
  801814:	74 0c                	je     801822 <openfile_alloc+0x3c>
  801816:	83 f8 01             	cmp    $0x1,%eax
  801819:	75 67                	jne    801882 <openfile_alloc+0x9c>
  80181b:	90                   	nop
  80181c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801820:	eb 27                	jmp    801849 <openfile_alloc+0x63>
		case 0:
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801822:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801829:	00 
  80182a:	89 d8                	mov    %ebx,%eax
  80182c:	c1 e0 04             	shl    $0x4,%eax
  80182f:	8b 80 2c 90 80 00    	mov    0x80902c(%eax),%eax
  801835:	89 44 24 04          	mov    %eax,0x4(%esp)
  801839:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801840:	e8 81 17 00 00       	call   802fc6 <sys_page_alloc>
  801845:	85 c0                	test   %eax,%eax
  801847:	78 4d                	js     801896 <openfile_alloc+0xb0>
				return r;
			/* fall through */
		case 1:
			opentab[i].o_fileid += MAXOPEN;
  801849:	c1 e3 04             	shl    $0x4,%ebx
  80184c:	81 83 20 90 80 00 00 	addl   $0x400,0x809020(%ebx)
  801853:	04 00 00 
			*o = &opentab[i];
  801856:	8d 83 20 90 80 00    	lea    0x809020(%ebx),%eax
  80185c:	89 07                	mov    %eax,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  80185e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801865:	00 
  801866:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80186d:	00 
  80186e:	8b 83 2c 90 80 00    	mov    0x80902c(%ebx),%eax
  801874:	89 04 24             	mov    %eax,(%esp)
  801877:	e8 4a 11 00 00       	call   8029c6 <memset>
			return (*o)->o_fileid;
  80187c:	8b 07                	mov    (%edi),%eax
  80187e:	8b 00                	mov    (%eax),%eax
  801880:	eb 14                	jmp    801896 <openfile_alloc+0xb0>
openfile_alloc(struct OpenFile **o)
{
	int i, r;

	// Find an available open-file table entry
	for (i = 0; i < MAXOPEN; i++) {
  801882:	83 c3 01             	add    $0x1,%ebx
  801885:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  80188b:	0f 85 71 ff ff ff    	jne    801802 <openfile_alloc+0x1c>
  801891:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
			memset(opentab[i].o_fd, 0, PGSIZE);
			return (*o)->o_fileid;
		}
	}
	return -E_MAX_OPEN;
}
  801896:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801899:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80189c:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80189f:	89 ec                	mov    %ebp,%esp
  8018a1:	5d                   	pop    %ebp
  8018a2:	c3                   	ret    

008018a3 <serve_open>:
// permissions to return to the calling environment in *pg_store and
// *perm_store respectively.
int
serve_open(envid_t envid, struct Fsreq_open *req,
	   void **pg_store, int *perm_store)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	53                   	push   %ebx
  8018a7:	81 ec 24 04 00 00    	sub    $0x424,%esp
  8018ad:	8b 5d 0c             	mov    0xc(%ebp),%ebx

	if (debug)
		cprintf("serve_open %08x %s 0x%x\n", envid, req->req_path, req->req_omode);

	// Copy in the path, making sure it's null-terminated
	memmove(path, req->req_path, MAXPATHLEN);
  8018b0:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
  8018b7:	00 
  8018b8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018bc:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8018c2:	89 04 24             	mov    %eax,(%esp)
  8018c5:	e8 5b 11 00 00       	call   802a25 <memmove>
	path[MAXPATHLEN-1] = 0;
  8018ca:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)

	// Find an open file ID
	if ((r = openfile_alloc(&o)) < 0) {
  8018ce:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  8018d4:	89 04 24             	mov    %eax,(%esp)
  8018d7:	e8 0a ff ff ff       	call   8017e6 <openfile_alloc>
  8018dc:	85 c0                	test   %eax,%eax
  8018de:	0f 88 ec 00 00 00    	js     8019d0 <serve_open+0x12d>
		return r;
	}
	fileid = r;

	// Open the file
	if (req->req_omode & O_CREAT) {
  8018e4:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  8018eb:	74 32                	je     80191f <serve_open+0x7c>
		if ((r = file_create(path, &f)) < 0) {
  8018ed:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8018f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f7:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8018fd:	89 04 24             	mov    %eax,(%esp)
  801900:	e8 63 f8 ff ff       	call   801168 <file_create>
  801905:	85 c0                	test   %eax,%eax
  801907:	79 36                	jns    80193f <serve_open+0x9c>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  801909:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  801910:	0f 85 ba 00 00 00    	jne    8019d0 <serve_open+0x12d>
  801916:	83 f8 f3             	cmp    $0xfffffff3,%eax
  801919:	0f 85 b1 00 00 00    	jne    8019d0 <serve_open+0x12d>
				cprintf("file_create failed: %e", r);
			return r;
		}
	} else {
try_open:
		if ((r = file_open(path, &f)) < 0) {
  80191f:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  801925:	89 44 24 04          	mov    %eax,0x4(%esp)
  801929:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  80192f:	89 04 24             	mov    %eax,(%esp)
  801932:	e8 12 f8 ff ff       	call   801149 <file_open>
  801937:	85 c0                	test   %eax,%eax
  801939:	0f 88 91 00 00 00    	js     8019d0 <serve_open+0x12d>
			return r;
		}
	}

	// Truncate
	if (req->req_omode & O_TRUNC) {
  80193f:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  801946:	74 1a                	je     801962 <serve_open+0xbf>
		if ((r = file_set_size(f, 0)) < 0) {
  801948:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80194f:	00 
  801950:	8b 85 f4 fb ff ff    	mov    -0x40c(%ebp),%eax
  801956:	89 04 24             	mov    %eax,(%esp)
  801959:	e8 df f3 ff ff       	call   800d3d <file_set_size>
  80195e:	85 c0                	test   %eax,%eax
  801960:	78 6e                	js     8019d0 <serve_open+0x12d>
			return r;
		}
	}

	// Save the file pointer
	o->o_file = f;
  801962:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  801968:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  80196e:	89 50 04             	mov    %edx,0x4(%eax)

	// Fill out the Fd structure
	o->o_fd->fd_file.id = o->o_fileid;
  801971:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801977:	8b 50 0c             	mov    0xc(%eax),%edx
  80197a:	8b 00                	mov    (%eax),%eax
  80197c:	89 42 0c             	mov    %eax,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  80197f:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801985:	8b 40 0c             	mov    0xc(%eax),%eax
  801988:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  80198e:	83 e2 03             	and    $0x3,%edx
  801991:	89 50 08             	mov    %edx,0x8(%eax)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801994:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  80199a:	8b 40 0c             	mov    0xc(%eax),%eax
  80199d:	8b 15 68 d0 80 00    	mov    0x80d068,%edx
  8019a3:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  8019a5:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  8019ab:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  8019b1:	89 50 08             	mov    %edx,0x8(%eax)

	if (debug)
		cprintf("sending success, page %08x\n", (uintptr_t) o->o_fd);

	// Share the FD page with the caller
	*pg_store = o->o_fd;
  8019b4:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  8019ba:	8b 50 0c             	mov    0xc(%eax),%edx
  8019bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c0:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  8019c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c5:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
  8019cb:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8019d0:	81 c4 24 04 00 00    	add    $0x424,%esp
  8019d6:	5b                   	pop    %ebx
  8019d7:	5d                   	pop    %ebp
  8019d8:	c3                   	ret    

008019d9 <serve>:
};
#define NHANDLERS (sizeof(handlers)/sizeof(handlers[0]))

void
serve(void)
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
  8019dc:	57                   	push   %edi
  8019dd:	56                   	push   %esi
  8019de:	53                   	push   %ebx
  8019df:	83 ec 2c             	sub    $0x2c,%esp
  8019e2:	be 00 00 00 00       	mov    $0x0,%esi
	int perm, r=0; // I have initialized it.....
	void *pg;
	void *blockva;
	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8019e7:	8d 7d e0             	lea    -0x20(%ebp),%edi
	uint32_t req, whom;
	int perm, r=0; // I have initialized it.....
	void *pg;
	void *blockva;
	while (1) {
		perm = 0;
  8019ea:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  8019f1:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8019f5:	a1 20 d0 80 00       	mov    0x80d020,%eax
  8019fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fe:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801a01:	89 04 24             	mov    %eax,(%esp)
  801a04:	e8 e9 17 00 00       	call   8031f2 <ipc_recv>
  801a09:	89 c3                	mov    %eax,%ebx
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, vpt[VPN(fsreq)], fsreq);

		// if the request is to swap out the page, then get the blockva, swap out the block and unmap the page.

		if(req == SWAP_OUT_PAGE)
  801a0b:	83 f8 0a             	cmp    $0xa,%eax
  801a0e:	75 21                	jne    801a31 <serve+0x58>
			{
				blockva = (void *)fsreq->swap.blockva;
  801a10:	a1 20 d0 80 00       	mov    0x80d020,%eax
  801a15:	8b 30                	mov    (%eax),%esi
				flush_block(blockva);
  801a17:	89 34 24             	mov    %esi,(%esp)
  801a1a:	e8 11 ea ff ff       	call   800430 <flush_block>
				r = sys_page_unmap(0,blockva);
  801a1f:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a23:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a2a:	e8 db 14 00 00       	call   802f0a <sys_page_unmap>
  801a2f:	89 c6                	mov    %eax,%esi
			}
			
		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
  801a31:	f6 45 e0 01          	testb  $0x1,-0x20(%ebp)
  801a35:	75 37                	jne    801a6e <serve+0x95>
			// Added for project.....To retrieve the free block and pass it to the swap out env.			
			if(req == SWAP_OUT_REQUEST_BLOCK)
  801a37:	83 fb 09             	cmp    $0x9,%ebx
  801a3a:	75 18                	jne    801a54 <serve+0x7b>
			{
				if((blockva = get_free_swap_block())!=NULL)
  801a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801a40:	e8 9d ed ff ff       	call   8007e2 <get_free_swap_block>
  801a45:	85 c0                	test   %eax,%eax
  801a47:	74 20                	je     801a69 <serve+0x90>
				    r = (uint32_t)blockva;
  801a49:	89 c6                	mov    %eax,%esi
				whom);
			continue; // just leave it hanging...
			}		
		}

		pg = NULL;
  801a4b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  801a52:	eb 6f                	jmp    801ac3 <serve+0xea>
				    r = (uint32_t)blockva;
				else
			            r = -E_INVAL;		
			}
			else
			{ cprintf("Invalid request from %08x: no argument page\n",
  801a54:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5b:	c7 04 24 e4 4c 80 00 	movl   $0x804ce4,(%esp)
  801a62:	e8 1e 07 00 00       	call   802185 <cprintf>
				whom);
			continue; // just leave it hanging...
  801a67:	eb 81                	jmp    8019ea <serve+0x11>
  801a69:	be fd ff ff ff       	mov    $0xfffffffd,%esi
			}		
		}

		pg = NULL;
  801a6e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
		if (req == FSREQ_OPEN) {
  801a75:	83 fb 01             	cmp    $0x1,%ebx
  801a78:	75 23                	jne    801a9d <serve+0xc4>
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  801a7a:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801a7e:	8d 45 dc             	lea    -0x24(%ebp),%eax
  801a81:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a85:	a1 20 d0 80 00       	mov    0x80d020,%eax
  801a8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a91:	89 04 24             	mov    %eax,(%esp)
  801a94:	e8 0a fe ff ff       	call   8018a3 <serve_open>
  801a99:	89 c6                	mov    %eax,%esi
  801a9b:	eb 4a                	jmp    801ae7 <serve+0x10e>
		} else if (req < NHANDLERS && handlers[req]) {
  801a9d:	83 fb 08             	cmp    $0x8,%ebx
  801aa0:	77 21                	ja     801ac3 <serve+0xea>
  801aa2:	8b 04 9d 40 d0 80 00 	mov    0x80d040(,%ebx,4),%eax
  801aa9:	85 c0                	test   %eax,%eax
  801aab:	74 16                	je     801ac3 <serve+0xea>
			r = handlers[req](whom, fsreq);
  801aad:	8b 15 20 d0 80 00    	mov    0x80d020,%edx
  801ab3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ab7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801aba:	89 14 24             	mov    %edx,(%esp)
  801abd:	ff d0                	call   *%eax
  801abf:	89 c6                	mov    %eax,%esi
		}

		pg = NULL;
		if (req == FSREQ_OPEN) {
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
		} else if (req < NHANDLERS && handlers[req]) {
  801ac1:	eb 24                	jmp    801ae7 <serve+0x10e>
			r = handlers[req](whom, fsreq);
		}
		// added for project
		else if ( req == SWAP_OUT_REQUEST_BLOCK || req == SWAP_OUT_PAGE)
  801ac3:	8d 43 f7             	lea    -0x9(%ebx),%eax
  801ac6:	83 f8 01             	cmp    $0x1,%eax
  801ac9:	76 1c                	jbe    801ae7 <serve+0x10e>
                   {  //do nothing, just to prevent it from going in the else block
		   }   
		 else {
			cprintf("Invalid request code %d from %08x\n", whom, req);
  801acb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801acf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ad6:	c7 04 24 14 4d 80 00 	movl   $0x804d14,(%esp)
  801add:	e8 a3 06 00 00       	call   802185 <cprintf>
  801ae2:	be fd ff ff ff       	mov    $0xfffffffd,%esi
			r = -E_INVAL;
		}
		ipc_send(whom, r, pg, perm);
  801ae7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801aea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801aee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801af1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801af5:	89 74 24 04          	mov    %esi,0x4(%esp)
  801af9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801afc:	89 04 24             	mov    %eax,(%esp)
  801aff:	e8 8c 16 00 00       	call   803190 <ipc_send>
		sys_page_unmap(0, fsreq);
  801b04:	a1 20 d0 80 00       	mov    0x80d020,%eax
  801b09:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b14:	e8 f1 13 00 00       	call   802f0a <sys_page_unmap>
  801b19:	e9 cc fe ff ff       	jmp    8019ea <serve+0x11>

00801b1e <umain>:
	}
}

void
umain(void)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	83 ec 18             	sub    $0x18,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  801b24:	c7 05 64 d0 80 00 37 	movl   $0x804d37,0x80d064
  801b2b:	4d 80 00 
	cprintf("FS is running\n");
  801b2e:	c7 04 24 3a 4d 80 00 	movl   $0x804d3a,(%esp)
  801b35:	e8 4b 06 00 00       	call   802185 <cprintf>
}

static __inline void
outw(int port, uint16_t data)
{
	__asm __volatile("outw %0,%w1" : : "a" (data), "d" (port));
  801b3a:	ba 00 8a 00 00       	mov    $0x8a00,%edx
  801b3f:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
  801b44:	66 ef                	out    %ax,(%dx)

	// Check that we are able to do I/O
	outw(0x8A00, 0x8A00);
	cprintf("FS can do I/O\n");
  801b46:	c7 04 24 49 4d 80 00 	movl   $0x804d49,(%esp)
  801b4d:	e8 33 06 00 00       	call   802185 <cprintf>

	serve_init();
  801b52:	e8 19 fa ff ff       	call   801570 <serve_init>
	fs_init();
  801b57:	e8 50 f9 ff ff       	call   8014ac <fs_init>
	swap_init();
  801b5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801b60:	e8 6d f7 ff ff       	call   8012d2 <swap_init>
	fs_test();
  801b65:	e8 0e 00 00 00       	call   801b78 <fs_test>
	check_SwapBlock();
  801b6a:	e8 31 ed ff ff       	call   8008a0 <check_SwapBlock>
	
	serve();
  801b6f:	90                   	nop
  801b70:	e8 64 fe ff ff       	call   8019d9 <serve>
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    
	...

00801b78 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
  801b7b:	53                   	push   %ebx
  801b7c:	83 ec 24             	sub    $0x24,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  801b7f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801b86:	00 
  801b87:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  801b8e:	00 
  801b8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b96:	e8 2b 14 00 00       	call   802fc6 <sys_page_alloc>
  801b9b:	85 c0                	test   %eax,%eax
  801b9d:	79 20                	jns    801bbf <fs_test+0x47>
		panic("sys_page_alloc: %e", r);
  801b9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ba3:	c7 44 24 08 58 4d 80 	movl   $0x804d58,0x8(%esp)
  801baa:	00 
  801bab:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  801bb2:	00 
  801bb3:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801bba:	e8 01 05 00 00       	call   8020c0 <_panic>
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  801bbf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801bc6:	00 
  801bc7:	a1 e0 d0 80 00       	mov    0x80d0e0,%eax
  801bcc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd0:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
  801bd7:	e8 49 0e 00 00       	call   802a25 <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  801bdc:	e8 91 eb ff ff       	call   800772 <alloc_block>
  801be1:	85 c0                	test   %eax,%eax
  801be3:	79 20                	jns    801c05 <fs_test+0x8d>
		panic("alloc_block: %e", r);
  801be5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801be9:	c7 44 24 08 75 4d 80 	movl   $0x804d75,0x8(%esp)
  801bf0:	00 
  801bf1:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  801bf8:	00 
  801bf9:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801c00:	e8 bb 04 00 00       	call   8020c0 <_panic>
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  801c05:	89 c3                	mov    %eax,%ebx
  801c07:	c1 fb 1f             	sar    $0x1f,%ebx
  801c0a:	c1 eb 1b             	shr    $0x1b,%ebx
  801c0d:	8d 04 03             	lea    (%ebx,%eax,1),%eax
  801c10:	89 c2                	mov    %eax,%edx
  801c12:	c1 fa 05             	sar    $0x5,%edx
  801c15:	c1 e2 02             	shl    $0x2,%edx
  801c18:	89 c1                	mov    %eax,%ecx
  801c1a:	83 e1 1f             	and    $0x1f,%ecx
  801c1d:	29 d9                	sub    %ebx,%ecx
  801c1f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c24:	d3 e0                	shl    %cl,%eax
  801c26:	85 82 00 10 00 00    	test   %eax,0x1000(%edx)
  801c2c:	75 24                	jne    801c52 <fs_test+0xda>
  801c2e:	c7 44 24 0c 85 4d 80 	movl   $0x804d85,0xc(%esp)
  801c35:	00 
  801c36:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  801c3d:	00 
  801c3e:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  801c45:	00 
  801c46:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801c4d:	e8 6e 04 00 00       	call   8020c0 <_panic>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801c52:	8b 0d e0 d0 80 00    	mov    0x80d0e0,%ecx
  801c58:	85 04 11             	test   %eax,(%ecx,%edx,1)
  801c5b:	74 24                	je     801c81 <fs_test+0x109>
  801c5d:	c7 44 24 0c f8 4e 80 	movl   $0x804ef8,0xc(%esp)
  801c64:	00 
  801c65:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  801c6c:	00 
  801c6d:	c7 44 24 04 1c 00 00 	movl   $0x1c,0x4(%esp)
  801c74:	00 
  801c75:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801c7c:	e8 3f 04 00 00       	call   8020c0 <_panic>
	cprintf("alloc_block is good\n");
  801c81:	c7 04 24 a0 4d 80 00 	movl   $0x804da0,(%esp)
  801c88:	e8 f8 04 00 00       	call   802185 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND)
  801c8d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c90:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c94:	c7 04 24 b5 4d 80 00 	movl   $0x804db5,(%esp)
  801c9b:	e8 a9 f4 ff ff       	call   801149 <file_open>
  801ca0:	85 c0                	test   %eax,%eax
  801ca2:	79 25                	jns    801cc9 <fs_test+0x151>
  801ca4:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801ca7:	74 40                	je     801ce9 <fs_test+0x171>
		panic("file_open /not-found: %e", r);
  801ca9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cad:	c7 44 24 08 c0 4d 80 	movl   $0x804dc0,0x8(%esp)
  801cb4:	00 
  801cb5:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
  801cbc:	00 
  801cbd:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801cc4:	e8 f7 03 00 00       	call   8020c0 <_panic>
	else if (r == 0)
  801cc9:	85 c0                	test   %eax,%eax
  801ccb:	75 1c                	jne    801ce9 <fs_test+0x171>
		panic("file_open /not-found succeeded!");
  801ccd:	c7 44 24 08 18 4f 80 	movl   $0x804f18,0x8(%esp)
  801cd4:	00 
  801cd5:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801cdc:	00 
  801cdd:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801ce4:	e8 d7 03 00 00       	call   8020c0 <_panic>
	if ((r = file_open("/newmotd", &f)) < 0)
  801ce9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cf0:	c7 04 24 d9 4d 80 00 	movl   $0x804dd9,(%esp)
  801cf7:	e8 4d f4 ff ff       	call   801149 <file_open>
  801cfc:	85 c0                	test   %eax,%eax
  801cfe:	79 20                	jns    801d20 <fs_test+0x1a8>
		panic("file_open /newmotd: %e", r);
  801d00:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d04:	c7 44 24 08 e2 4d 80 	movl   $0x804de2,0x8(%esp)
  801d0b:	00 
  801d0c:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  801d13:	00 
  801d14:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801d1b:	e8 a0 03 00 00       	call   8020c0 <_panic>
	cprintf("file_open is good\n");
  801d20:	c7 04 24 f9 4d 80 00 	movl   $0x804df9,(%esp)
  801d27:	e8 59 04 00 00       	call   802185 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  801d2c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d2f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d33:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d3a:	00 
  801d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d3e:	89 04 24             	mov    %eax,(%esp)
  801d41:	e8 ea ec ff ff       	call   800a30 <file_get_block>
  801d46:	85 c0                	test   %eax,%eax
  801d48:	79 20                	jns    801d6a <fs_test+0x1f2>
		panic("file_get_block: %e", r);
  801d4a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d4e:	c7 44 24 08 0c 4e 80 	movl   $0x804e0c,0x8(%esp)
  801d55:	00 
  801d56:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
  801d5d:	00 
  801d5e:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801d65:	e8 56 03 00 00       	call   8020c0 <_panic>
	if (strcmp(blk, msg) != 0)
  801d6a:	8b 1d 84 4f 80 00    	mov    0x804f84,%ebx
  801d70:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d77:	89 04 24             	mov    %eax,(%esp)
  801d7a:	e8 7a 0b 00 00       	call   8028f9 <strcmp>
  801d7f:	85 c0                	test   %eax,%eax
  801d81:	74 1c                	je     801d9f <fs_test+0x227>
		panic("file_get_block returned wrong data");
  801d83:	c7 44 24 08 38 4f 80 	movl   $0x804f38,0x8(%esp)
  801d8a:	00 
  801d8b:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
  801d92:	00 
  801d93:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801d9a:	e8 21 03 00 00       	call   8020c0 <_panic>
	cprintf("file_get_block is good\n");
  801d9f:	c7 04 24 1f 4e 80 00 	movl   $0x804e1f,(%esp)
  801da6:	e8 da 03 00 00       	call   802185 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  801dab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dae:	0f b6 10             	movzbl (%eax),%edx
  801db1:	88 10                	mov    %dl,(%eax)
	assert((vpt[VPN(blk)] & PTE_D));
  801db3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db6:	c1 e8 0c             	shr    $0xc,%eax
  801db9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801dc0:	a8 40                	test   $0x40,%al
  801dc2:	75 24                	jne    801de8 <fs_test+0x270>
  801dc4:	c7 44 24 0c 38 4e 80 	movl   $0x804e38,0xc(%esp)
  801dcb:	00 
  801dcc:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  801dd3:	00 
  801dd4:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  801ddb:	00 
  801ddc:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801de3:	e8 d8 02 00 00       	call   8020c0 <_panic>
	file_flush(f);
  801de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801deb:	89 04 24             	mov    %eax,(%esp)
  801dee:	e8 9a eb ff ff       	call   80098d <file_flush>
	assert(!(vpt[VPN(blk)] & PTE_D));
  801df3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df6:	c1 e8 0c             	shr    $0xc,%eax
  801df9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801e00:	a8 40                	test   $0x40,%al
  801e02:	74 24                	je     801e28 <fs_test+0x2b0>
  801e04:	c7 44 24 0c 37 4e 80 	movl   $0x804e37,0xc(%esp)
  801e0b:	00 
  801e0c:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  801e13:	00 
  801e14:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  801e1b:	00 
  801e1c:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801e23:	e8 98 02 00 00       	call   8020c0 <_panic>
	cprintf("file_flush is good\n");
  801e28:	c7 04 24 50 4e 80 00 	movl   $0x804e50,(%esp)
  801e2f:	e8 51 03 00 00       	call   802185 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  801e34:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e3b:	00 
  801e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e3f:	89 04 24             	mov    %eax,(%esp)
  801e42:	e8 f6 ee ff ff       	call   800d3d <file_set_size>
  801e47:	85 c0                	test   %eax,%eax
  801e49:	79 20                	jns    801e6b <fs_test+0x2f3>
		panic("file_set_size: %e", r);
  801e4b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e4f:	c7 44 24 08 64 4e 80 	movl   $0x804e64,0x8(%esp)
  801e56:	00 
  801e57:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  801e5e:	00 
  801e5f:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801e66:	e8 55 02 00 00       	call   8020c0 <_panic>
	assert(f->f_direct[0] == 0);
  801e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6e:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  801e75:	74 24                	je     801e9b <fs_test+0x323>
  801e77:	c7 44 24 0c 76 4e 80 	movl   $0x804e76,0xc(%esp)
  801e7e:	00 
  801e7f:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  801e86:	00 
  801e87:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  801e8e:	00 
  801e8f:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801e96:	e8 25 02 00 00       	call   8020c0 <_panic>
	assert(!(vpt[VPN(f)] & PTE_D));
  801e9b:	c1 e8 0c             	shr    $0xc,%eax
  801e9e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ea5:	a8 40                	test   $0x40,%al
  801ea7:	74 24                	je     801ecd <fs_test+0x355>
  801ea9:	c7 44 24 0c 8a 4e 80 	movl   $0x804e8a,0xc(%esp)
  801eb0:	00 
  801eb1:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  801eb8:	00 
  801eb9:	c7 44 24 04 36 00 00 	movl   $0x36,0x4(%esp)
  801ec0:	00 
  801ec1:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801ec8:	e8 f3 01 00 00       	call   8020c0 <_panic>
	cprintf("file_truncate is good\n");
  801ecd:	c7 04 24 a1 4e 80 00 	movl   $0x804ea1,(%esp)
  801ed4:	e8 ac 02 00 00       	call   802185 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  801ed9:	89 1c 24             	mov    %ebx,(%esp)
  801edc:	e8 3f 09 00 00       	call   802820 <strlen>
  801ee1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee8:	89 04 24             	mov    %eax,(%esp)
  801eeb:	e8 4d ee ff ff       	call   800d3d <file_set_size>
  801ef0:	85 c0                	test   %eax,%eax
  801ef2:	79 20                	jns    801f14 <fs_test+0x39c>
		panic("file_set_size 2: %e", r);
  801ef4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ef8:	c7 44 24 08 b8 4e 80 	movl   $0x804eb8,0x8(%esp)
  801eff:	00 
  801f00:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  801f07:	00 
  801f08:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801f0f:	e8 ac 01 00 00       	call   8020c0 <_panic>
	assert(!(vpt[VPN(f)] & PTE_D));
  801f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f17:	89 c2                	mov    %eax,%edx
  801f19:	c1 ea 0c             	shr    $0xc,%edx
  801f1c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801f23:	f6 c2 40             	test   $0x40,%dl
  801f26:	74 24                	je     801f4c <fs_test+0x3d4>
  801f28:	c7 44 24 0c 8a 4e 80 	movl   $0x804e8a,0xc(%esp)
  801f2f:	00 
  801f30:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  801f37:	00 
  801f38:	c7 44 24 04 3b 00 00 	movl   $0x3b,0x4(%esp)
  801f3f:	00 
  801f40:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801f47:	e8 74 01 00 00       	call   8020c0 <_panic>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  801f4c:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801f4f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f53:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f5a:	00 
  801f5b:	89 04 24             	mov    %eax,(%esp)
  801f5e:	e8 cd ea ff ff       	call   800a30 <file_get_block>
  801f63:	85 c0                	test   %eax,%eax
  801f65:	79 20                	jns    801f87 <fs_test+0x40f>
		panic("file_get_block 2: %e", r);
  801f67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f6b:	c7 44 24 08 cc 4e 80 	movl   $0x804ecc,0x8(%esp)
  801f72:	00 
  801f73:	c7 44 24 04 3d 00 00 	movl   $0x3d,0x4(%esp)
  801f7a:	00 
  801f7b:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801f82:	e8 39 01 00 00       	call   8020c0 <_panic>
	strcpy(blk, msg);
  801f87:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f8b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f8e:	89 04 24             	mov    %eax,(%esp)
  801f91:	e8 d4 08 00 00       	call   80286a <strcpy>
	assert((vpt[VPN(blk)] & PTE_D));
  801f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f99:	c1 e8 0c             	shr    $0xc,%eax
  801f9c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801fa3:	a8 40                	test   $0x40,%al
  801fa5:	75 24                	jne    801fcb <fs_test+0x453>
  801fa7:	c7 44 24 0c 38 4e 80 	movl   $0x804e38,0xc(%esp)
  801fae:	00 
  801faf:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  801fb6:	00 
  801fb7:	c7 44 24 04 3f 00 00 	movl   $0x3f,0x4(%esp)
  801fbe:	00 
  801fbf:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  801fc6:	e8 f5 00 00 00       	call   8020c0 <_panic>
	file_flush(f);
  801fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fce:	89 04 24             	mov    %eax,(%esp)
  801fd1:	e8 b7 e9 ff ff       	call   80098d <file_flush>
	assert(!(vpt[VPN(blk)] & PTE_D));
  801fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd9:	c1 e8 0c             	shr    $0xc,%eax
  801fdc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801fe3:	a8 40                	test   $0x40,%al
  801fe5:	74 24                	je     80200b <fs_test+0x493>
  801fe7:	c7 44 24 0c 37 4e 80 	movl   $0x804e37,0xc(%esp)
  801fee:	00 
  801fef:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  801ff6:	00 
  801ff7:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
  801ffe:	00 
  801fff:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  802006:	e8 b5 00 00 00       	call   8020c0 <_panic>
	assert(!(vpt[VPN(f)] & PTE_D));
  80200b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200e:	c1 e8 0c             	shr    $0xc,%eax
  802011:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  802018:	a8 40                	test   $0x40,%al
  80201a:	74 24                	je     802040 <fs_test+0x4c8>
  80201c:	c7 44 24 0c 8a 4e 80 	movl   $0x804e8a,0xc(%esp)
  802023:	00 
  802024:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  80202b:	00 
  80202c:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
  802033:	00 
  802034:	c7 04 24 6b 4d 80 00 	movl   $0x804d6b,(%esp)
  80203b:	e8 80 00 00 00       	call   8020c0 <_panic>
	cprintf("file rewrite is good\n");
  802040:	c7 04 24 e1 4e 80 00 	movl   $0x804ee1,(%esp)
  802047:	e8 39 01 00 00       	call   802185 <cprintf>
}
  80204c:	83 c4 24             	add    $0x24,%esp
  80204f:	5b                   	pop    %ebx
  802050:	5d                   	pop    %ebp
  802051:	c3                   	ret    
	...

00802054 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  802054:	55                   	push   %ebp
  802055:	89 e5                	mov    %esp,%ebp
  802057:	83 ec 18             	sub    $0x18,%esp
  80205a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80205d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802060:	8b 75 08             	mov    0x8(%ebp),%esi
  802063:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  802066:	e8 ee 0f 00 00       	call   803059 <sys_getenvid>
  80206b:	25 ff 03 00 00       	and    $0x3ff,%eax
  802070:	6b c0 7c             	imul   $0x7c,%eax,%eax
  802073:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  802078:	a3 88 d1 80 00       	mov    %eax,0x80d188

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80207d:	85 f6                	test   %esi,%esi
  80207f:	7e 07                	jle    802088 <libmain+0x34>
		binaryname = argv[0];
  802081:	8b 03                	mov    (%ebx),%eax
  802083:	a3 64 d0 80 00       	mov    %eax,0x80d064

	// call user main routine
	umain(argc, argv);
  802088:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80208c:	89 34 24             	mov    %esi,(%esp)
  80208f:	e8 8a fa ff ff       	call   801b1e <umain>

	// exit gracefully
	exit();
  802094:	e8 0b 00 00 00       	call   8020a4 <exit>
}
  802099:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80209c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80209f:	89 ec                	mov    %ebp,%esp
  8020a1:	5d                   	pop    %ebp
  8020a2:	c3                   	ret    
	...

008020a4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8020a4:	55                   	push   %ebp
  8020a5:	89 e5                	mov    %esp,%ebp
  8020a7:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8020aa:	e8 8c 16 00 00       	call   80373b <close_all>
	sys_env_destroy(0);
  8020af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020b6:	e8 d2 0f 00 00       	call   80308d <sys_env_destroy>
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    
  8020bd:	00 00                	add    %al,(%eax)
	...

008020c0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8020c0:	55                   	push   %ebp
  8020c1:	89 e5                	mov    %esp,%ebp
  8020c3:	53                   	push   %ebx
  8020c4:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  8020c7:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  8020ca:	a1 8c d1 80 00       	mov    0x80d18c,%eax
  8020cf:	85 c0                	test   %eax,%eax
  8020d1:	74 10                	je     8020e3 <_panic+0x23>
		cprintf("%s: ", argv0);
  8020d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d7:	c7 04 24 9f 4f 80 00 	movl   $0x804f9f,(%esp)
  8020de:	e8 a2 00 00 00       	call   802185 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8020e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020f1:	a1 64 d0 80 00       	mov    0x80d064,%eax
  8020f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020fa:	c7 04 24 a4 4f 80 00 	movl   $0x804fa4,(%esp)
  802101:	e8 7f 00 00 00       	call   802185 <cprintf>
	vcprintf(fmt, ap);
  802106:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80210a:	8b 45 10             	mov    0x10(%ebp),%eax
  80210d:	89 04 24             	mov    %eax,(%esp)
  802110:	e8 0f 00 00 00       	call   802124 <vcprintf>
	cprintf("\n");
  802115:	c7 04 24 39 4a 80 00 	movl   $0x804a39,(%esp)
  80211c:	e8 64 00 00 00       	call   802185 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  802121:	cc                   	int3   
  802122:	eb fd                	jmp    802121 <_panic+0x61>

00802124 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
  802127:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80212d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802134:	00 00 00 
	b.cnt = 0;
  802137:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80213e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  802141:	8b 45 0c             	mov    0xc(%ebp),%eax
  802144:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802148:	8b 45 08             	mov    0x8(%ebp),%eax
  80214b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80214f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  802155:	89 44 24 04          	mov    %eax,0x4(%esp)
  802159:	c7 04 24 9f 21 80 00 	movl   $0x80219f,(%esp)
  802160:	e8 d8 01 00 00       	call   80233d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  802165:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80216b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80216f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  802175:	89 04 24             	mov    %eax,(%esp)
  802178:	e8 e3 0a 00 00       	call   802c60 <sys_cputs>

	return b.cnt;
}
  80217d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80218b:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80218e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	89 04 24             	mov    %eax,(%esp)
  802198:	e8 87 ff ff ff       	call   802124 <vcprintf>
	va_end(ap);

	return cnt;
}
  80219d:	c9                   	leave  
  80219e:	c3                   	ret    

0080219f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80219f:	55                   	push   %ebp
  8021a0:	89 e5                	mov    %esp,%ebp
  8021a2:	53                   	push   %ebx
  8021a3:	83 ec 14             	sub    $0x14,%esp
  8021a6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8021a9:	8b 03                	mov    (%ebx),%eax
  8021ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ae:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8021b2:	83 c0 01             	add    $0x1,%eax
  8021b5:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8021b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8021bc:	75 19                	jne    8021d7 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8021be:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8021c5:	00 
  8021c6:	8d 43 08             	lea    0x8(%ebx),%eax
  8021c9:	89 04 24             	mov    %eax,(%esp)
  8021cc:	e8 8f 0a 00 00       	call   802c60 <sys_cputs>
		b->idx = 0;
  8021d1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8021d7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8021db:	83 c4 14             	add    $0x14,%esp
  8021de:	5b                   	pop    %ebx
  8021df:	5d                   	pop    %ebp
  8021e0:	c3                   	ret    
	...

008021f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	57                   	push   %edi
  8021f4:	56                   	push   %esi
  8021f5:	53                   	push   %ebx
  8021f6:	83 ec 4c             	sub    $0x4c,%esp
  8021f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8021fc:	89 d6                	mov    %edx,%esi
  8021fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802201:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802204:	8b 55 0c             	mov    0xc(%ebp),%edx
  802207:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80220a:	8b 45 10             	mov    0x10(%ebp),%eax
  80220d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802210:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802213:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802216:	b9 00 00 00 00       	mov    $0x0,%ecx
  80221b:	39 d1                	cmp    %edx,%ecx
  80221d:	72 15                	jb     802234 <printnum+0x44>
  80221f:	77 07                	ja     802228 <printnum+0x38>
  802221:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802224:	39 d0                	cmp    %edx,%eax
  802226:	76 0c                	jbe    802234 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802228:	83 eb 01             	sub    $0x1,%ebx
  80222b:	85 db                	test   %ebx,%ebx
  80222d:	8d 76 00             	lea    0x0(%esi),%esi
  802230:	7f 61                	jg     802293 <printnum+0xa3>
  802232:	eb 70                	jmp    8022a4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802234:	89 7c 24 10          	mov    %edi,0x10(%esp)
  802238:	83 eb 01             	sub    $0x1,%ebx
  80223b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80223f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802243:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802247:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80224b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80224e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  802251:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  802254:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802258:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80225f:	00 
  802260:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802263:	89 04 24             	mov    %eax,(%esp)
  802266:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802269:	89 54 24 04          	mov    %edx,0x4(%esp)
  80226d:	e8 ce 23 00 00       	call   804640 <__udivdi3>
  802272:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  802275:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802278:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80227c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802280:	89 04 24             	mov    %eax,(%esp)
  802283:	89 54 24 04          	mov    %edx,0x4(%esp)
  802287:	89 f2                	mov    %esi,%edx
  802289:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80228c:	e8 5f ff ff ff       	call   8021f0 <printnum>
  802291:	eb 11                	jmp    8022a4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  802293:	89 74 24 04          	mov    %esi,0x4(%esp)
  802297:	89 3c 24             	mov    %edi,(%esp)
  80229a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80229d:	83 eb 01             	sub    $0x1,%ebx
  8022a0:	85 db                	test   %ebx,%ebx
  8022a2:	7f ef                	jg     802293 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8022a4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022a8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8022ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8022af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022b3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8022ba:	00 
  8022bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8022be:	89 14 24             	mov    %edx,(%esp)
  8022c1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8022c4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022c8:	e8 a3 24 00 00       	call   804770 <__umoddi3>
  8022cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022d1:	0f be 80 c0 4f 80 00 	movsbl 0x804fc0(%eax),%eax
  8022d8:	89 04 24             	mov    %eax,(%esp)
  8022db:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8022de:	83 c4 4c             	add    $0x4c,%esp
  8022e1:	5b                   	pop    %ebx
  8022e2:	5e                   	pop    %esi
  8022e3:	5f                   	pop    %edi
  8022e4:	5d                   	pop    %ebp
  8022e5:	c3                   	ret    

008022e6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8022e6:	55                   	push   %ebp
  8022e7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8022e9:	83 fa 01             	cmp    $0x1,%edx
  8022ec:	7e 0e                	jle    8022fc <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8022ee:	8b 10                	mov    (%eax),%edx
  8022f0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8022f3:	89 08                	mov    %ecx,(%eax)
  8022f5:	8b 02                	mov    (%edx),%eax
  8022f7:	8b 52 04             	mov    0x4(%edx),%edx
  8022fa:	eb 22                	jmp    80231e <getuint+0x38>
	else if (lflag)
  8022fc:	85 d2                	test   %edx,%edx
  8022fe:	74 10                	je     802310 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  802300:	8b 10                	mov    (%eax),%edx
  802302:	8d 4a 04             	lea    0x4(%edx),%ecx
  802305:	89 08                	mov    %ecx,(%eax)
  802307:	8b 02                	mov    (%edx),%eax
  802309:	ba 00 00 00 00       	mov    $0x0,%edx
  80230e:	eb 0e                	jmp    80231e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  802310:	8b 10                	mov    (%eax),%edx
  802312:	8d 4a 04             	lea    0x4(%edx),%ecx
  802315:	89 08                	mov    %ecx,(%eax)
  802317:	8b 02                	mov    (%edx),%eax
  802319:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80231e:	5d                   	pop    %ebp
  80231f:	c3                   	ret    

00802320 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  802326:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80232a:	8b 10                	mov    (%eax),%edx
  80232c:	3b 50 04             	cmp    0x4(%eax),%edx
  80232f:	73 0a                	jae    80233b <sprintputch+0x1b>
		*b->buf++ = ch;
  802331:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802334:	88 0a                	mov    %cl,(%edx)
  802336:	83 c2 01             	add    $0x1,%edx
  802339:	89 10                	mov    %edx,(%eax)
}
  80233b:	5d                   	pop    %ebp
  80233c:	c3                   	ret    

0080233d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80233d:	55                   	push   %ebp
  80233e:	89 e5                	mov    %esp,%ebp
  802340:	57                   	push   %edi
  802341:	56                   	push   %esi
  802342:	53                   	push   %ebx
  802343:	83 ec 5c             	sub    $0x5c,%esp
  802346:	8b 7d 08             	mov    0x8(%ebp),%edi
  802349:	8b 75 0c             	mov    0xc(%ebp),%esi
  80234c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80234f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  802356:	eb 11                	jmp    802369 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  802358:	85 c0                	test   %eax,%eax
  80235a:	0f 84 09 04 00 00    	je     802769 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  802360:	89 74 24 04          	mov    %esi,0x4(%esp)
  802364:	89 04 24             	mov    %eax,(%esp)
  802367:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802369:	0f b6 03             	movzbl (%ebx),%eax
  80236c:	83 c3 01             	add    $0x1,%ebx
  80236f:	83 f8 25             	cmp    $0x25,%eax
  802372:	75 e4                	jne    802358 <vprintfmt+0x1b>
  802374:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  802378:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80237f:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  802386:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80238d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802392:	eb 06                	jmp    80239a <vprintfmt+0x5d>
  802394:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  802398:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80239a:	0f b6 13             	movzbl (%ebx),%edx
  80239d:	0f b6 c2             	movzbl %dl,%eax
  8023a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8023a3:	8d 43 01             	lea    0x1(%ebx),%eax
  8023a6:	83 ea 23             	sub    $0x23,%edx
  8023a9:	80 fa 55             	cmp    $0x55,%dl
  8023ac:	0f 87 9a 03 00 00    	ja     80274c <vprintfmt+0x40f>
  8023b2:	0f b6 d2             	movzbl %dl,%edx
  8023b5:	ff 24 95 00 51 80 00 	jmp    *0x805100(,%edx,4)
  8023bc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8023c0:	eb d6                	jmp    802398 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8023c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8023c5:	83 ea 30             	sub    $0x30,%edx
  8023c8:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  8023cb:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8023ce:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8023d1:	83 fb 09             	cmp    $0x9,%ebx
  8023d4:	77 4c                	ja     802422 <vprintfmt+0xe5>
  8023d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8023d9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8023dc:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8023df:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8023e2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8023e6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8023e9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8023ec:	83 fb 09             	cmp    $0x9,%ebx
  8023ef:	76 eb                	jbe    8023dc <vprintfmt+0x9f>
  8023f1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8023f4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8023f7:	eb 29                	jmp    802422 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8023f9:	8b 55 14             	mov    0x14(%ebp),%edx
  8023fc:	8d 5a 04             	lea    0x4(%edx),%ebx
  8023ff:	89 5d 14             	mov    %ebx,0x14(%ebp)
  802402:	8b 12                	mov    (%edx),%edx
  802404:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  802407:	eb 19                	jmp    802422 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  802409:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80240c:	c1 fa 1f             	sar    $0x1f,%edx
  80240f:	f7 d2                	not    %edx
  802411:	21 55 e4             	and    %edx,-0x1c(%ebp)
  802414:	eb 82                	jmp    802398 <vprintfmt+0x5b>
  802416:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80241d:	e9 76 ff ff ff       	jmp    802398 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  802422:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802426:	0f 89 6c ff ff ff    	jns    802398 <vprintfmt+0x5b>
  80242c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80242f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802432:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802435:	89 55 cc             	mov    %edx,-0x34(%ebp)
  802438:	e9 5b ff ff ff       	jmp    802398 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80243d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  802440:	e9 53 ff ff ff       	jmp    802398 <vprintfmt+0x5b>
  802445:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  802448:	8b 45 14             	mov    0x14(%ebp),%eax
  80244b:	8d 50 04             	lea    0x4(%eax),%edx
  80244e:	89 55 14             	mov    %edx,0x14(%ebp)
  802451:	89 74 24 04          	mov    %esi,0x4(%esp)
  802455:	8b 00                	mov    (%eax),%eax
  802457:	89 04 24             	mov    %eax,(%esp)
  80245a:	ff d7                	call   *%edi
  80245c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80245f:	e9 05 ff ff ff       	jmp    802369 <vprintfmt+0x2c>
  802464:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  802467:	8b 45 14             	mov    0x14(%ebp),%eax
  80246a:	8d 50 04             	lea    0x4(%eax),%edx
  80246d:	89 55 14             	mov    %edx,0x14(%ebp)
  802470:	8b 00                	mov    (%eax),%eax
  802472:	89 c2                	mov    %eax,%edx
  802474:	c1 fa 1f             	sar    $0x1f,%edx
  802477:	31 d0                	xor    %edx,%eax
  802479:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80247b:	83 f8 0f             	cmp    $0xf,%eax
  80247e:	7f 0b                	jg     80248b <vprintfmt+0x14e>
  802480:	8b 14 85 60 52 80 00 	mov    0x805260(,%eax,4),%edx
  802487:	85 d2                	test   %edx,%edx
  802489:	75 20                	jne    8024ab <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80248b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80248f:	c7 44 24 08 d1 4f 80 	movl   $0x804fd1,0x8(%esp)
  802496:	00 
  802497:	89 74 24 04          	mov    %esi,0x4(%esp)
  80249b:	89 3c 24             	mov    %edi,(%esp)
  80249e:	e8 4e 03 00 00       	call   8027f1 <printfmt>
  8024a3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8024a6:	e9 be fe ff ff       	jmp    802369 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8024ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8024af:	c7 44 24 08 df 48 80 	movl   $0x8048df,0x8(%esp)
  8024b6:	00 
  8024b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024bb:	89 3c 24             	mov    %edi,(%esp)
  8024be:	e8 2e 03 00 00       	call   8027f1 <printfmt>
  8024c3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8024c6:	e9 9e fe ff ff       	jmp    802369 <vprintfmt+0x2c>
  8024cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8024ce:	89 c3                	mov    %eax,%ebx
  8024d0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8024d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d6:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8024d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8024dc:	8d 50 04             	lea    0x4(%eax),%edx
  8024df:	89 55 14             	mov    %edx,0x14(%ebp)
  8024e2:	8b 00                	mov    (%eax),%eax
  8024e4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8024e7:	85 c0                	test   %eax,%eax
  8024e9:	75 07                	jne    8024f2 <vprintfmt+0x1b5>
  8024eb:	c7 45 c4 da 4f 80 00 	movl   $0x804fda,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  8024f2:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8024f6:	7e 06                	jle    8024fe <vprintfmt+0x1c1>
  8024f8:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  8024fc:	75 13                	jne    802511 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8024fe:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802501:	0f be 02             	movsbl (%edx),%eax
  802504:	85 c0                	test   %eax,%eax
  802506:	0f 85 99 00 00 00    	jne    8025a5 <vprintfmt+0x268>
  80250c:	e9 86 00 00 00       	jmp    802597 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802511:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802515:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  802518:	89 0c 24             	mov    %ecx,(%esp)
  80251b:	e8 1b 03 00 00       	call   80283b <strnlen>
  802520:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802523:	29 c2                	sub    %eax,%edx
  802525:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802528:	85 d2                	test   %edx,%edx
  80252a:	7e d2                	jle    8024fe <vprintfmt+0x1c1>
					putch(padc, putdat);
  80252c:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  802530:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  802533:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  802536:	89 d3                	mov    %edx,%ebx
  802538:	89 74 24 04          	mov    %esi,0x4(%esp)
  80253c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80253f:	89 04 24             	mov    %eax,(%esp)
  802542:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802544:	83 eb 01             	sub    $0x1,%ebx
  802547:	85 db                	test   %ebx,%ebx
  802549:	7f ed                	jg     802538 <vprintfmt+0x1fb>
  80254b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80254e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802555:	eb a7                	jmp    8024fe <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802557:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80255b:	74 18                	je     802575 <vprintfmt+0x238>
  80255d:	8d 50 e0             	lea    -0x20(%eax),%edx
  802560:	83 fa 5e             	cmp    $0x5e,%edx
  802563:	76 10                	jbe    802575 <vprintfmt+0x238>
					putch('?', putdat);
  802565:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802569:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  802570:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802573:	eb 0a                	jmp    80257f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  802575:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802579:	89 04 24             	mov    %eax,(%esp)
  80257c:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80257f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  802583:	0f be 03             	movsbl (%ebx),%eax
  802586:	85 c0                	test   %eax,%eax
  802588:	74 05                	je     80258f <vprintfmt+0x252>
  80258a:	83 c3 01             	add    $0x1,%ebx
  80258d:	eb 29                	jmp    8025b8 <vprintfmt+0x27b>
  80258f:	89 fe                	mov    %edi,%esi
  802591:	8b 7d dc             	mov    -0x24(%ebp),%edi
  802594:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802597:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80259b:	7f 2e                	jg     8025cb <vprintfmt+0x28e>
  80259d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8025a0:	e9 c4 fd ff ff       	jmp    802369 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8025a5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8025a8:	83 c2 01             	add    $0x1,%edx
  8025ab:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8025ae:	89 f7                	mov    %esi,%edi
  8025b0:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8025b3:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  8025b6:	89 d3                	mov    %edx,%ebx
  8025b8:	85 f6                	test   %esi,%esi
  8025ba:	78 9b                	js     802557 <vprintfmt+0x21a>
  8025bc:	83 ee 01             	sub    $0x1,%esi
  8025bf:	79 96                	jns    802557 <vprintfmt+0x21a>
  8025c1:	89 fe                	mov    %edi,%esi
  8025c3:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8025c6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8025c9:	eb cc                	jmp    802597 <vprintfmt+0x25a>
  8025cb:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8025ce:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8025d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8025d5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8025dc:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8025de:	83 eb 01             	sub    $0x1,%ebx
  8025e1:	85 db                	test   %ebx,%ebx
  8025e3:	7f ec                	jg     8025d1 <vprintfmt+0x294>
  8025e5:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8025e8:	e9 7c fd ff ff       	jmp    802369 <vprintfmt+0x2c>
  8025ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8025f0:	83 f9 01             	cmp    $0x1,%ecx
  8025f3:	7e 16                	jle    80260b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  8025f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8025f8:	8d 50 08             	lea    0x8(%eax),%edx
  8025fb:	89 55 14             	mov    %edx,0x14(%ebp)
  8025fe:	8b 10                	mov    (%eax),%edx
  802600:	8b 48 04             	mov    0x4(%eax),%ecx
  802603:	89 55 d0             	mov    %edx,-0x30(%ebp)
  802606:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  802609:	eb 32                	jmp    80263d <vprintfmt+0x300>
	else if (lflag)
  80260b:	85 c9                	test   %ecx,%ecx
  80260d:	74 18                	je     802627 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80260f:	8b 45 14             	mov    0x14(%ebp),%eax
  802612:	8d 50 04             	lea    0x4(%eax),%edx
  802615:	89 55 14             	mov    %edx,0x14(%ebp)
  802618:	8b 00                	mov    (%eax),%eax
  80261a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80261d:	89 c1                	mov    %eax,%ecx
  80261f:	c1 f9 1f             	sar    $0x1f,%ecx
  802622:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  802625:	eb 16                	jmp    80263d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  802627:	8b 45 14             	mov    0x14(%ebp),%eax
  80262a:	8d 50 04             	lea    0x4(%eax),%edx
  80262d:	89 55 14             	mov    %edx,0x14(%ebp)
  802630:	8b 00                	mov    (%eax),%eax
  802632:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802635:	89 c2                	mov    %eax,%edx
  802637:	c1 fa 1f             	sar    $0x1f,%edx
  80263a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80263d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  802640:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802643:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  802648:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80264c:	0f 89 b8 00 00 00    	jns    80270a <vprintfmt+0x3cd>
				putch('-', putdat);
  802652:	89 74 24 04          	mov    %esi,0x4(%esp)
  802656:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80265d:	ff d7                	call   *%edi
				num = -(long long) num;
  80265f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  802662:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802665:	f7 d9                	neg    %ecx
  802667:	83 d3 00             	adc    $0x0,%ebx
  80266a:	f7 db                	neg    %ebx
  80266c:	b8 0a 00 00 00       	mov    $0xa,%eax
  802671:	e9 94 00 00 00       	jmp    80270a <vprintfmt+0x3cd>
  802676:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  802679:	89 ca                	mov    %ecx,%edx
  80267b:	8d 45 14             	lea    0x14(%ebp),%eax
  80267e:	e8 63 fc ff ff       	call   8022e6 <getuint>
  802683:	89 c1                	mov    %eax,%ecx
  802685:	89 d3                	mov    %edx,%ebx
  802687:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80268c:	eb 7c                	jmp    80270a <vprintfmt+0x3cd>
  80268e:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  802691:	89 74 24 04          	mov    %esi,0x4(%esp)
  802695:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  80269c:	ff d7                	call   *%edi
			putch('X', putdat);
  80269e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026a2:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8026a9:	ff d7                	call   *%edi
			putch('X', putdat);
  8026ab:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026af:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8026b6:	ff d7                	call   *%edi
  8026b8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8026bb:	e9 a9 fc ff ff       	jmp    802369 <vprintfmt+0x2c>
  8026c0:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8026c3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026c7:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8026ce:	ff d7                	call   *%edi
			putch('x', putdat);
  8026d0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026d4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8026db:	ff d7                	call   *%edi
			num = (unsigned long long)
  8026dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8026e0:	8d 50 04             	lea    0x4(%eax),%edx
  8026e3:	89 55 14             	mov    %edx,0x14(%ebp)
  8026e6:	8b 08                	mov    (%eax),%ecx
  8026e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8026ed:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8026f2:	eb 16                	jmp    80270a <vprintfmt+0x3cd>
  8026f4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8026f7:	89 ca                	mov    %ecx,%edx
  8026f9:	8d 45 14             	lea    0x14(%ebp),%eax
  8026fc:	e8 e5 fb ff ff       	call   8022e6 <getuint>
  802701:	89 c1                	mov    %eax,%ecx
  802703:	89 d3                	mov    %edx,%ebx
  802705:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80270a:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  80270e:	89 54 24 10          	mov    %edx,0x10(%esp)
  802712:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802715:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802719:	89 44 24 08          	mov    %eax,0x8(%esp)
  80271d:	89 0c 24             	mov    %ecx,(%esp)
  802720:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802724:	89 f2                	mov    %esi,%edx
  802726:	89 f8                	mov    %edi,%eax
  802728:	e8 c3 fa ff ff       	call   8021f0 <printnum>
  80272d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  802730:	e9 34 fc ff ff       	jmp    802369 <vprintfmt+0x2c>
  802735:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802738:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80273b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80273f:	89 14 24             	mov    %edx,(%esp)
  802742:	ff d7                	call   *%edi
  802744:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  802747:	e9 1d fc ff ff       	jmp    802369 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80274c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802750:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  802757:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  802759:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80275c:	80 38 25             	cmpb   $0x25,(%eax)
  80275f:	0f 84 04 fc ff ff    	je     802369 <vprintfmt+0x2c>
  802765:	89 c3                	mov    %eax,%ebx
  802767:	eb f0                	jmp    802759 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  802769:	83 c4 5c             	add    $0x5c,%esp
  80276c:	5b                   	pop    %ebx
  80276d:	5e                   	pop    %esi
  80276e:	5f                   	pop    %edi
  80276f:	5d                   	pop    %ebp
  802770:	c3                   	ret    

00802771 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802771:	55                   	push   %ebp
  802772:	89 e5                	mov    %esp,%ebp
  802774:	83 ec 28             	sub    $0x28,%esp
  802777:	8b 45 08             	mov    0x8(%ebp),%eax
  80277a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  80277d:	85 c0                	test   %eax,%eax
  80277f:	74 04                	je     802785 <vsnprintf+0x14>
  802781:	85 d2                	test   %edx,%edx
  802783:	7f 07                	jg     80278c <vsnprintf+0x1b>
  802785:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80278a:	eb 3b                	jmp    8027c7 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80278c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80278f:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  802793:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802796:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80279d:	8b 45 14             	mov    0x14(%ebp),%eax
  8027a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8027a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8027ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027b2:	c7 04 24 20 23 80 00 	movl   $0x802320,(%esp)
  8027b9:	e8 7f fb ff ff       	call   80233d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8027be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8027c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8027c7:	c9                   	leave  
  8027c8:	c3                   	ret    

008027c9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8027c9:	55                   	push   %ebp
  8027ca:	89 e5                	mov    %esp,%ebp
  8027cc:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8027cf:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8027d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8027d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e7:	89 04 24             	mov    %eax,(%esp)
  8027ea:	e8 82 ff ff ff       	call   802771 <vsnprintf>
	va_end(ap);

	return rc;
}
  8027ef:	c9                   	leave  
  8027f0:	c3                   	ret    

008027f1 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8027f1:	55                   	push   %ebp
  8027f2:	89 e5                	mov    %esp,%ebp
  8027f4:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8027f7:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8027fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8027fe:	8b 45 10             	mov    0x10(%ebp),%eax
  802801:	89 44 24 08          	mov    %eax,0x8(%esp)
  802805:	8b 45 0c             	mov    0xc(%ebp),%eax
  802808:	89 44 24 04          	mov    %eax,0x4(%esp)
  80280c:	8b 45 08             	mov    0x8(%ebp),%eax
  80280f:	89 04 24             	mov    %eax,(%esp)
  802812:	e8 26 fb ff ff       	call   80233d <vprintfmt>
	va_end(ap);
}
  802817:	c9                   	leave  
  802818:	c3                   	ret    
  802819:	00 00                	add    %al,(%eax)
  80281b:	00 00                	add    %al,(%eax)
  80281d:	00 00                	add    %al,(%eax)
	...

00802820 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802820:	55                   	push   %ebp
  802821:	89 e5                	mov    %esp,%ebp
  802823:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  802826:	b8 00 00 00 00       	mov    $0x0,%eax
  80282b:	80 3a 00             	cmpb   $0x0,(%edx)
  80282e:	74 09                	je     802839 <strlen+0x19>
		n++;
  802830:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802833:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  802837:	75 f7                	jne    802830 <strlen+0x10>
		n++;
	return n;
}
  802839:	5d                   	pop    %ebp
  80283a:	c3                   	ret    

0080283b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80283b:	55                   	push   %ebp
  80283c:	89 e5                	mov    %esp,%ebp
  80283e:	53                   	push   %ebx
  80283f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802842:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802845:	85 c9                	test   %ecx,%ecx
  802847:	74 19                	je     802862 <strnlen+0x27>
  802849:	80 3b 00             	cmpb   $0x0,(%ebx)
  80284c:	74 14                	je     802862 <strnlen+0x27>
  80284e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  802853:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802856:	39 c8                	cmp    %ecx,%eax
  802858:	74 0d                	je     802867 <strnlen+0x2c>
  80285a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80285e:	75 f3                	jne    802853 <strnlen+0x18>
  802860:	eb 05                	jmp    802867 <strnlen+0x2c>
  802862:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  802867:	5b                   	pop    %ebx
  802868:	5d                   	pop    %ebp
  802869:	c3                   	ret    

0080286a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80286a:	55                   	push   %ebp
  80286b:	89 e5                	mov    %esp,%ebp
  80286d:	53                   	push   %ebx
  80286e:	8b 45 08             	mov    0x8(%ebp),%eax
  802871:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802874:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  802879:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80287d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  802880:	83 c2 01             	add    $0x1,%edx
  802883:	84 c9                	test   %cl,%cl
  802885:	75 f2                	jne    802879 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  802887:	5b                   	pop    %ebx
  802888:	5d                   	pop    %ebp
  802889:	c3                   	ret    

0080288a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80288a:	55                   	push   %ebp
  80288b:	89 e5                	mov    %esp,%ebp
  80288d:	56                   	push   %esi
  80288e:	53                   	push   %ebx
  80288f:	8b 45 08             	mov    0x8(%ebp),%eax
  802892:	8b 55 0c             	mov    0xc(%ebp),%edx
  802895:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  802898:	85 f6                	test   %esi,%esi
  80289a:	74 18                	je     8028b4 <strncpy+0x2a>
  80289c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8028a1:	0f b6 1a             	movzbl (%edx),%ebx
  8028a4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8028a7:	80 3a 01             	cmpb   $0x1,(%edx)
  8028aa:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8028ad:	83 c1 01             	add    $0x1,%ecx
  8028b0:	39 ce                	cmp    %ecx,%esi
  8028b2:	77 ed                	ja     8028a1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8028b4:	5b                   	pop    %ebx
  8028b5:	5e                   	pop    %esi
  8028b6:	5d                   	pop    %ebp
  8028b7:	c3                   	ret    

008028b8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8028b8:	55                   	push   %ebp
  8028b9:	89 e5                	mov    %esp,%ebp
  8028bb:	56                   	push   %esi
  8028bc:	53                   	push   %ebx
  8028bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8028c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8028c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8028c6:	89 f0                	mov    %esi,%eax
  8028c8:	85 c9                	test   %ecx,%ecx
  8028ca:	74 27                	je     8028f3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  8028cc:	83 e9 01             	sub    $0x1,%ecx
  8028cf:	74 1d                	je     8028ee <strlcpy+0x36>
  8028d1:	0f b6 1a             	movzbl (%edx),%ebx
  8028d4:	84 db                	test   %bl,%bl
  8028d6:	74 16                	je     8028ee <strlcpy+0x36>
			*dst++ = *src++;
  8028d8:	88 18                	mov    %bl,(%eax)
  8028da:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8028dd:	83 e9 01             	sub    $0x1,%ecx
  8028e0:	74 0e                	je     8028f0 <strlcpy+0x38>
			*dst++ = *src++;
  8028e2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8028e5:	0f b6 1a             	movzbl (%edx),%ebx
  8028e8:	84 db                	test   %bl,%bl
  8028ea:	75 ec                	jne    8028d8 <strlcpy+0x20>
  8028ec:	eb 02                	jmp    8028f0 <strlcpy+0x38>
  8028ee:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8028f0:	c6 00 00             	movb   $0x0,(%eax)
  8028f3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8028f5:	5b                   	pop    %ebx
  8028f6:	5e                   	pop    %esi
  8028f7:	5d                   	pop    %ebp
  8028f8:	c3                   	ret    

008028f9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8028f9:	55                   	push   %ebp
  8028fa:	89 e5                	mov    %esp,%ebp
  8028fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8028ff:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802902:	0f b6 01             	movzbl (%ecx),%eax
  802905:	84 c0                	test   %al,%al
  802907:	74 15                	je     80291e <strcmp+0x25>
  802909:	3a 02                	cmp    (%edx),%al
  80290b:	75 11                	jne    80291e <strcmp+0x25>
		p++, q++;
  80290d:	83 c1 01             	add    $0x1,%ecx
  802910:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802913:	0f b6 01             	movzbl (%ecx),%eax
  802916:	84 c0                	test   %al,%al
  802918:	74 04                	je     80291e <strcmp+0x25>
  80291a:	3a 02                	cmp    (%edx),%al
  80291c:	74 ef                	je     80290d <strcmp+0x14>
  80291e:	0f b6 c0             	movzbl %al,%eax
  802921:	0f b6 12             	movzbl (%edx),%edx
  802924:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802926:	5d                   	pop    %ebp
  802927:	c3                   	ret    

00802928 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802928:	55                   	push   %ebp
  802929:	89 e5                	mov    %esp,%ebp
  80292b:	53                   	push   %ebx
  80292c:	8b 55 08             	mov    0x8(%ebp),%edx
  80292f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802932:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  802935:	85 c0                	test   %eax,%eax
  802937:	74 23                	je     80295c <strncmp+0x34>
  802939:	0f b6 1a             	movzbl (%edx),%ebx
  80293c:	84 db                	test   %bl,%bl
  80293e:	74 24                	je     802964 <strncmp+0x3c>
  802940:	3a 19                	cmp    (%ecx),%bl
  802942:	75 20                	jne    802964 <strncmp+0x3c>
  802944:	83 e8 01             	sub    $0x1,%eax
  802947:	74 13                	je     80295c <strncmp+0x34>
		n--, p++, q++;
  802949:	83 c2 01             	add    $0x1,%edx
  80294c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80294f:	0f b6 1a             	movzbl (%edx),%ebx
  802952:	84 db                	test   %bl,%bl
  802954:	74 0e                	je     802964 <strncmp+0x3c>
  802956:	3a 19                	cmp    (%ecx),%bl
  802958:	74 ea                	je     802944 <strncmp+0x1c>
  80295a:	eb 08                	jmp    802964 <strncmp+0x3c>
  80295c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802961:	5b                   	pop    %ebx
  802962:	5d                   	pop    %ebp
  802963:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  802964:	0f b6 02             	movzbl (%edx),%eax
  802967:	0f b6 11             	movzbl (%ecx),%edx
  80296a:	29 d0                	sub    %edx,%eax
  80296c:	eb f3                	jmp    802961 <strncmp+0x39>

0080296e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80296e:	55                   	push   %ebp
  80296f:	89 e5                	mov    %esp,%ebp
  802971:	8b 45 08             	mov    0x8(%ebp),%eax
  802974:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  802978:	0f b6 10             	movzbl (%eax),%edx
  80297b:	84 d2                	test   %dl,%dl
  80297d:	74 15                	je     802994 <strchr+0x26>
		if (*s == c)
  80297f:	38 ca                	cmp    %cl,%dl
  802981:	75 07                	jne    80298a <strchr+0x1c>
  802983:	eb 14                	jmp    802999 <strchr+0x2b>
  802985:	38 ca                	cmp    %cl,%dl
  802987:	90                   	nop
  802988:	74 0f                	je     802999 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80298a:	83 c0 01             	add    $0x1,%eax
  80298d:	0f b6 10             	movzbl (%eax),%edx
  802990:	84 d2                	test   %dl,%dl
  802992:	75 f1                	jne    802985 <strchr+0x17>
  802994:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  802999:	5d                   	pop    %ebp
  80299a:	c3                   	ret    

0080299b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80299b:	55                   	push   %ebp
  80299c:	89 e5                	mov    %esp,%ebp
  80299e:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8029a5:	0f b6 10             	movzbl (%eax),%edx
  8029a8:	84 d2                	test   %dl,%dl
  8029aa:	74 18                	je     8029c4 <strfind+0x29>
		if (*s == c)
  8029ac:	38 ca                	cmp    %cl,%dl
  8029ae:	75 0a                	jne    8029ba <strfind+0x1f>
  8029b0:	eb 12                	jmp    8029c4 <strfind+0x29>
  8029b2:	38 ca                	cmp    %cl,%dl
  8029b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029b8:	74 0a                	je     8029c4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8029ba:	83 c0 01             	add    $0x1,%eax
  8029bd:	0f b6 10             	movzbl (%eax),%edx
  8029c0:	84 d2                	test   %dl,%dl
  8029c2:	75 ee                	jne    8029b2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8029c4:	5d                   	pop    %ebp
  8029c5:	c3                   	ret    

008029c6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8029c6:	55                   	push   %ebp
  8029c7:	89 e5                	mov    %esp,%ebp
  8029c9:	83 ec 0c             	sub    $0xc,%esp
  8029cc:	89 1c 24             	mov    %ebx,(%esp)
  8029cf:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029d3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8029d7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8029da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029dd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8029e0:	85 c9                	test   %ecx,%ecx
  8029e2:	74 30                	je     802a14 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8029e4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8029ea:	75 25                	jne    802a11 <memset+0x4b>
  8029ec:	f6 c1 03             	test   $0x3,%cl
  8029ef:	75 20                	jne    802a11 <memset+0x4b>
		c &= 0xFF;
  8029f1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8029f4:	89 d3                	mov    %edx,%ebx
  8029f6:	c1 e3 08             	shl    $0x8,%ebx
  8029f9:	89 d6                	mov    %edx,%esi
  8029fb:	c1 e6 18             	shl    $0x18,%esi
  8029fe:	89 d0                	mov    %edx,%eax
  802a00:	c1 e0 10             	shl    $0x10,%eax
  802a03:	09 f0                	or     %esi,%eax
  802a05:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  802a07:	09 d8                	or     %ebx,%eax
  802a09:	c1 e9 02             	shr    $0x2,%ecx
  802a0c:	fc                   	cld    
  802a0d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802a0f:	eb 03                	jmp    802a14 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802a11:	fc                   	cld    
  802a12:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  802a14:	89 f8                	mov    %edi,%eax
  802a16:	8b 1c 24             	mov    (%esp),%ebx
  802a19:	8b 74 24 04          	mov    0x4(%esp),%esi
  802a1d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802a21:	89 ec                	mov    %ebp,%esp
  802a23:	5d                   	pop    %ebp
  802a24:	c3                   	ret    

00802a25 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802a25:	55                   	push   %ebp
  802a26:	89 e5                	mov    %esp,%ebp
  802a28:	83 ec 08             	sub    $0x8,%esp
  802a2b:	89 34 24             	mov    %esi,(%esp)
  802a2e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802a32:	8b 45 08             	mov    0x8(%ebp),%eax
  802a35:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  802a38:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  802a3b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  802a3d:	39 c6                	cmp    %eax,%esi
  802a3f:	73 35                	jae    802a76 <memmove+0x51>
  802a41:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802a44:	39 d0                	cmp    %edx,%eax
  802a46:	73 2e                	jae    802a76 <memmove+0x51>
		s += n;
		d += n;
  802a48:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802a4a:	f6 c2 03             	test   $0x3,%dl
  802a4d:	75 1b                	jne    802a6a <memmove+0x45>
  802a4f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  802a55:	75 13                	jne    802a6a <memmove+0x45>
  802a57:	f6 c1 03             	test   $0x3,%cl
  802a5a:	75 0e                	jne    802a6a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  802a5c:	83 ef 04             	sub    $0x4,%edi
  802a5f:	8d 72 fc             	lea    -0x4(%edx),%esi
  802a62:	c1 e9 02             	shr    $0x2,%ecx
  802a65:	fd                   	std    
  802a66:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802a68:	eb 09                	jmp    802a73 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  802a6a:	83 ef 01             	sub    $0x1,%edi
  802a6d:	8d 72 ff             	lea    -0x1(%edx),%esi
  802a70:	fd                   	std    
  802a71:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802a73:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  802a74:	eb 20                	jmp    802a96 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802a76:	f7 c6 03 00 00 00    	test   $0x3,%esi
  802a7c:	75 15                	jne    802a93 <memmove+0x6e>
  802a7e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  802a84:	75 0d                	jne    802a93 <memmove+0x6e>
  802a86:	f6 c1 03             	test   $0x3,%cl
  802a89:	75 08                	jne    802a93 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  802a8b:	c1 e9 02             	shr    $0x2,%ecx
  802a8e:	fc                   	cld    
  802a8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802a91:	eb 03                	jmp    802a96 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802a93:	fc                   	cld    
  802a94:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802a96:	8b 34 24             	mov    (%esp),%esi
  802a99:	8b 7c 24 04          	mov    0x4(%esp),%edi
  802a9d:	89 ec                	mov    %ebp,%esp
  802a9f:	5d                   	pop    %ebp
  802aa0:	c3                   	ret    

00802aa1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  802aa1:	55                   	push   %ebp
  802aa2:	89 e5                	mov    %esp,%ebp
  802aa4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  802aa7:	8b 45 10             	mov    0x10(%ebp),%eax
  802aaa:	89 44 24 08          	mov    %eax,0x8(%esp)
  802aae:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ab1:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab8:	89 04 24             	mov    %eax,(%esp)
  802abb:	e8 65 ff ff ff       	call   802a25 <memmove>
}
  802ac0:	c9                   	leave  
  802ac1:	c3                   	ret    

00802ac2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802ac2:	55                   	push   %ebp
  802ac3:	89 e5                	mov    %esp,%ebp
  802ac5:	57                   	push   %edi
  802ac6:	56                   	push   %esi
  802ac7:	53                   	push   %ebx
  802ac8:	8b 75 08             	mov    0x8(%ebp),%esi
  802acb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802ace:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802ad1:	85 c9                	test   %ecx,%ecx
  802ad3:	74 36                	je     802b0b <memcmp+0x49>
		if (*s1 != *s2)
  802ad5:	0f b6 06             	movzbl (%esi),%eax
  802ad8:	0f b6 1f             	movzbl (%edi),%ebx
  802adb:	38 d8                	cmp    %bl,%al
  802add:	74 20                	je     802aff <memcmp+0x3d>
  802adf:	eb 14                	jmp    802af5 <memcmp+0x33>
  802ae1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  802ae6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  802aeb:	83 c2 01             	add    $0x1,%edx
  802aee:	83 e9 01             	sub    $0x1,%ecx
  802af1:	38 d8                	cmp    %bl,%al
  802af3:	74 12                	je     802b07 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  802af5:	0f b6 c0             	movzbl %al,%eax
  802af8:	0f b6 db             	movzbl %bl,%ebx
  802afb:	29 d8                	sub    %ebx,%eax
  802afd:	eb 11                	jmp    802b10 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802aff:	83 e9 01             	sub    $0x1,%ecx
  802b02:	ba 00 00 00 00       	mov    $0x0,%edx
  802b07:	85 c9                	test   %ecx,%ecx
  802b09:	75 d6                	jne    802ae1 <memcmp+0x1f>
  802b0b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  802b10:	5b                   	pop    %ebx
  802b11:	5e                   	pop    %esi
  802b12:	5f                   	pop    %edi
  802b13:	5d                   	pop    %ebp
  802b14:	c3                   	ret    

00802b15 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802b15:	55                   	push   %ebp
  802b16:	89 e5                	mov    %esp,%ebp
  802b18:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  802b1b:	89 c2                	mov    %eax,%edx
  802b1d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802b20:	39 d0                	cmp    %edx,%eax
  802b22:	73 15                	jae    802b39 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  802b24:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  802b28:	38 08                	cmp    %cl,(%eax)
  802b2a:	75 06                	jne    802b32 <memfind+0x1d>
  802b2c:	eb 0b                	jmp    802b39 <memfind+0x24>
  802b2e:	38 08                	cmp    %cl,(%eax)
  802b30:	74 07                	je     802b39 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802b32:	83 c0 01             	add    $0x1,%eax
  802b35:	39 c2                	cmp    %eax,%edx
  802b37:	77 f5                	ja     802b2e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802b39:	5d                   	pop    %ebp
  802b3a:	c3                   	ret    

00802b3b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802b3b:	55                   	push   %ebp
  802b3c:	89 e5                	mov    %esp,%ebp
  802b3e:	57                   	push   %edi
  802b3f:	56                   	push   %esi
  802b40:	53                   	push   %ebx
  802b41:	83 ec 04             	sub    $0x4,%esp
  802b44:	8b 55 08             	mov    0x8(%ebp),%edx
  802b47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802b4a:	0f b6 02             	movzbl (%edx),%eax
  802b4d:	3c 20                	cmp    $0x20,%al
  802b4f:	74 04                	je     802b55 <strtol+0x1a>
  802b51:	3c 09                	cmp    $0x9,%al
  802b53:	75 0e                	jne    802b63 <strtol+0x28>
		s++;
  802b55:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  802b58:	0f b6 02             	movzbl (%edx),%eax
  802b5b:	3c 20                	cmp    $0x20,%al
  802b5d:	74 f6                	je     802b55 <strtol+0x1a>
  802b5f:	3c 09                	cmp    $0x9,%al
  802b61:	74 f2                	je     802b55 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  802b63:	3c 2b                	cmp    $0x2b,%al
  802b65:	75 0c                	jne    802b73 <strtol+0x38>
		s++;
  802b67:	83 c2 01             	add    $0x1,%edx
  802b6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802b71:	eb 15                	jmp    802b88 <strtol+0x4d>
	else if (*s == '-')
  802b73:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802b7a:	3c 2d                	cmp    $0x2d,%al
  802b7c:	75 0a                	jne    802b88 <strtol+0x4d>
		s++, neg = 1;
  802b7e:	83 c2 01             	add    $0x1,%edx
  802b81:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802b88:	85 db                	test   %ebx,%ebx
  802b8a:	0f 94 c0             	sete   %al
  802b8d:	74 05                	je     802b94 <strtol+0x59>
  802b8f:	83 fb 10             	cmp    $0x10,%ebx
  802b92:	75 18                	jne    802bac <strtol+0x71>
  802b94:	80 3a 30             	cmpb   $0x30,(%edx)
  802b97:	75 13                	jne    802bac <strtol+0x71>
  802b99:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  802b9d:	8d 76 00             	lea    0x0(%esi),%esi
  802ba0:	75 0a                	jne    802bac <strtol+0x71>
		s += 2, base = 16;
  802ba2:	83 c2 02             	add    $0x2,%edx
  802ba5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  802baa:	eb 15                	jmp    802bc1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  802bac:	84 c0                	test   %al,%al
  802bae:	66 90                	xchg   %ax,%ax
  802bb0:	74 0f                	je     802bc1 <strtol+0x86>
  802bb2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  802bb7:	80 3a 30             	cmpb   $0x30,(%edx)
  802bba:	75 05                	jne    802bc1 <strtol+0x86>
		s++, base = 8;
  802bbc:	83 c2 01             	add    $0x1,%edx
  802bbf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  802bc1:	b8 00 00 00 00       	mov    $0x0,%eax
  802bc6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802bc8:	0f b6 0a             	movzbl (%edx),%ecx
  802bcb:	89 cf                	mov    %ecx,%edi
  802bcd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  802bd0:	80 fb 09             	cmp    $0x9,%bl
  802bd3:	77 08                	ja     802bdd <strtol+0xa2>
			dig = *s - '0';
  802bd5:	0f be c9             	movsbl %cl,%ecx
  802bd8:	83 e9 30             	sub    $0x30,%ecx
  802bdb:	eb 1e                	jmp    802bfb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  802bdd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  802be0:	80 fb 19             	cmp    $0x19,%bl
  802be3:	77 08                	ja     802bed <strtol+0xb2>
			dig = *s - 'a' + 10;
  802be5:	0f be c9             	movsbl %cl,%ecx
  802be8:	83 e9 57             	sub    $0x57,%ecx
  802beb:	eb 0e                	jmp    802bfb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  802bed:	8d 5f bf             	lea    -0x41(%edi),%ebx
  802bf0:	80 fb 19             	cmp    $0x19,%bl
  802bf3:	77 15                	ja     802c0a <strtol+0xcf>
			dig = *s - 'A' + 10;
  802bf5:	0f be c9             	movsbl %cl,%ecx
  802bf8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  802bfb:	39 f1                	cmp    %esi,%ecx
  802bfd:	7d 0b                	jge    802c0a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  802bff:	83 c2 01             	add    $0x1,%edx
  802c02:	0f af c6             	imul   %esi,%eax
  802c05:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  802c08:	eb be                	jmp    802bc8 <strtol+0x8d>
  802c0a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  802c0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802c10:	74 05                	je     802c17 <strtol+0xdc>
		*endptr = (char *) s;
  802c12:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802c15:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  802c17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c1b:	74 04                	je     802c21 <strtol+0xe6>
  802c1d:	89 c8                	mov    %ecx,%eax
  802c1f:	f7 d8                	neg    %eax
}
  802c21:	83 c4 04             	add    $0x4,%esp
  802c24:	5b                   	pop    %ebx
  802c25:	5e                   	pop    %esi
  802c26:	5f                   	pop    %edi
  802c27:	5d                   	pop    %ebp
  802c28:	c3                   	ret    
  802c29:	00 00                	add    %al,(%eax)
	...

00802c2c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  802c2c:	55                   	push   %ebp
  802c2d:	89 e5                	mov    %esp,%ebp
  802c2f:	83 ec 0c             	sub    $0xc,%esp
  802c32:	89 1c 24             	mov    %ebx,(%esp)
  802c35:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c39:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802c3d:	ba 00 00 00 00       	mov    $0x0,%edx
  802c42:	b8 01 00 00 00       	mov    $0x1,%eax
  802c47:	89 d1                	mov    %edx,%ecx
  802c49:	89 d3                	mov    %edx,%ebx
  802c4b:	89 d7                	mov    %edx,%edi
  802c4d:	89 d6                	mov    %edx,%esi
  802c4f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  802c51:	8b 1c 24             	mov    (%esp),%ebx
  802c54:	8b 74 24 04          	mov    0x4(%esp),%esi
  802c58:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802c5c:	89 ec                	mov    %ebp,%esp
  802c5e:	5d                   	pop    %ebp
  802c5f:	c3                   	ret    

00802c60 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  802c60:	55                   	push   %ebp
  802c61:	89 e5                	mov    %esp,%ebp
  802c63:	83 ec 0c             	sub    $0xc,%esp
  802c66:	89 1c 24             	mov    %ebx,(%esp)
  802c69:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c6d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802c71:	b8 00 00 00 00       	mov    $0x0,%eax
  802c76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802c79:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7c:	89 c3                	mov    %eax,%ebx
  802c7e:	89 c7                	mov    %eax,%edi
  802c80:	89 c6                	mov    %eax,%esi
  802c82:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  802c84:	8b 1c 24             	mov    (%esp),%ebx
  802c87:	8b 74 24 04          	mov    0x4(%esp),%esi
  802c8b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802c8f:	89 ec                	mov    %ebp,%esp
  802c91:	5d                   	pop    %ebp
  802c92:	c3                   	ret    

00802c93 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  802c93:	55                   	push   %ebp
  802c94:	89 e5                	mov    %esp,%ebp
  802c96:	83 ec 0c             	sub    $0xc,%esp
  802c99:	89 1c 24             	mov    %ebx,(%esp)
  802c9c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ca0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802ca4:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ca9:	b8 10 00 00 00       	mov    $0x10,%eax
  802cae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802cb1:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb4:	89 df                	mov    %ebx,%edi
  802cb6:	89 de                	mov    %ebx,%esi
  802cb8:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  802cba:	8b 1c 24             	mov    (%esp),%ebx
  802cbd:	8b 74 24 04          	mov    0x4(%esp),%esi
  802cc1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802cc5:	89 ec                	mov    %ebp,%esp
  802cc7:	5d                   	pop    %ebp
  802cc8:	c3                   	ret    

00802cc9 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  802cc9:	55                   	push   %ebp
  802cca:	89 e5                	mov    %esp,%ebp
  802ccc:	83 ec 38             	sub    $0x38,%esp
  802ccf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802cd2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802cd5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802cd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  802cdd:	b8 0f 00 00 00       	mov    $0xf,%eax
  802ce2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce8:	89 df                	mov    %ebx,%edi
  802cea:	89 de                	mov    %ebx,%esi
  802cec:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  802cee:	85 c0                	test   %eax,%eax
  802cf0:	7e 28                	jle    802d1a <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  802cf2:	89 44 24 10          	mov    %eax,0x10(%esp)
  802cf6:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  802cfd:	00 
  802cfe:	c7 44 24 08 bf 52 80 	movl   $0x8052bf,0x8(%esp)
  802d05:	00 
  802d06:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802d0d:	00 
  802d0e:	c7 04 24 dc 52 80 00 	movl   $0x8052dc,(%esp)
  802d15:	e8 a6 f3 ff ff       	call   8020c0 <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  802d1a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802d1d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802d20:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802d23:	89 ec                	mov    %ebp,%esp
  802d25:	5d                   	pop    %ebp
  802d26:	c3                   	ret    

00802d27 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  802d27:	55                   	push   %ebp
  802d28:	89 e5                	mov    %esp,%ebp
  802d2a:	83 ec 0c             	sub    $0xc,%esp
  802d2d:	89 1c 24             	mov    %ebx,(%esp)
  802d30:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d34:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802d38:	ba 00 00 00 00       	mov    $0x0,%edx
  802d3d:	b8 0e 00 00 00       	mov    $0xe,%eax
  802d42:	89 d1                	mov    %edx,%ecx
  802d44:	89 d3                	mov    %edx,%ebx
  802d46:	89 d7                	mov    %edx,%edi
  802d48:	89 d6                	mov    %edx,%esi
  802d4a:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  802d4c:	8b 1c 24             	mov    (%esp),%ebx
  802d4f:	8b 74 24 04          	mov    0x4(%esp),%esi
  802d53:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802d57:	89 ec                	mov    %ebp,%esp
  802d59:	5d                   	pop    %ebp
  802d5a:	c3                   	ret    

00802d5b <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  802d5b:	55                   	push   %ebp
  802d5c:	89 e5                	mov    %esp,%ebp
  802d5e:	83 ec 38             	sub    $0x38,%esp
  802d61:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802d64:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802d67:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802d6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  802d6f:	b8 0d 00 00 00       	mov    $0xd,%eax
  802d74:	8b 55 08             	mov    0x8(%ebp),%edx
  802d77:	89 cb                	mov    %ecx,%ebx
  802d79:	89 cf                	mov    %ecx,%edi
  802d7b:	89 ce                	mov    %ecx,%esi
  802d7d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  802d7f:	85 c0                	test   %eax,%eax
  802d81:	7e 28                	jle    802dab <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  802d83:	89 44 24 10          	mov    %eax,0x10(%esp)
  802d87:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  802d8e:	00 
  802d8f:	c7 44 24 08 bf 52 80 	movl   $0x8052bf,0x8(%esp)
  802d96:	00 
  802d97:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802d9e:	00 
  802d9f:	c7 04 24 dc 52 80 00 	movl   $0x8052dc,(%esp)
  802da6:	e8 15 f3 ff ff       	call   8020c0 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802dab:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802dae:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802db1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802db4:	89 ec                	mov    %ebp,%esp
  802db6:	5d                   	pop    %ebp
  802db7:	c3                   	ret    

00802db8 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  802db8:	55                   	push   %ebp
  802db9:	89 e5                	mov    %esp,%ebp
  802dbb:	83 ec 0c             	sub    $0xc,%esp
  802dbe:	89 1c 24             	mov    %ebx,(%esp)
  802dc1:	89 74 24 04          	mov    %esi,0x4(%esp)
  802dc5:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802dc9:	be 00 00 00 00       	mov    $0x0,%esi
  802dce:	b8 0c 00 00 00       	mov    $0xc,%eax
  802dd3:	8b 7d 14             	mov    0x14(%ebp),%edi
  802dd6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802dd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ddf:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  802de1:	8b 1c 24             	mov    (%esp),%ebx
  802de4:	8b 74 24 04          	mov    0x4(%esp),%esi
  802de8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802dec:	89 ec                	mov    %ebp,%esp
  802dee:	5d                   	pop    %ebp
  802def:	c3                   	ret    

00802df0 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  802df0:	55                   	push   %ebp
  802df1:	89 e5                	mov    %esp,%ebp
  802df3:	83 ec 38             	sub    $0x38,%esp
  802df6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802df9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802dfc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802dff:	bb 00 00 00 00       	mov    $0x0,%ebx
  802e04:	b8 0a 00 00 00       	mov    $0xa,%eax
  802e09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e0f:	89 df                	mov    %ebx,%edi
  802e11:	89 de                	mov    %ebx,%esi
  802e13:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  802e15:	85 c0                	test   %eax,%eax
  802e17:	7e 28                	jle    802e41 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  802e19:	89 44 24 10          	mov    %eax,0x10(%esp)
  802e1d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  802e24:	00 
  802e25:	c7 44 24 08 bf 52 80 	movl   $0x8052bf,0x8(%esp)
  802e2c:	00 
  802e2d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802e34:	00 
  802e35:	c7 04 24 dc 52 80 00 	movl   $0x8052dc,(%esp)
  802e3c:	e8 7f f2 ff ff       	call   8020c0 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  802e41:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802e44:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802e47:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802e4a:	89 ec                	mov    %ebp,%esp
  802e4c:	5d                   	pop    %ebp
  802e4d:	c3                   	ret    

00802e4e <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802e4e:	55                   	push   %ebp
  802e4f:	89 e5                	mov    %esp,%ebp
  802e51:	83 ec 38             	sub    $0x38,%esp
  802e54:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802e57:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802e5a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802e5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  802e62:	b8 09 00 00 00       	mov    $0x9,%eax
  802e67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802e6a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e6d:	89 df                	mov    %ebx,%edi
  802e6f:	89 de                	mov    %ebx,%esi
  802e71:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  802e73:	85 c0                	test   %eax,%eax
  802e75:	7e 28                	jle    802e9f <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  802e77:	89 44 24 10          	mov    %eax,0x10(%esp)
  802e7b:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  802e82:	00 
  802e83:	c7 44 24 08 bf 52 80 	movl   $0x8052bf,0x8(%esp)
  802e8a:	00 
  802e8b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802e92:	00 
  802e93:	c7 04 24 dc 52 80 00 	movl   $0x8052dc,(%esp)
  802e9a:	e8 21 f2 ff ff       	call   8020c0 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  802e9f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802ea2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802ea5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802ea8:	89 ec                	mov    %ebp,%esp
  802eaa:	5d                   	pop    %ebp
  802eab:	c3                   	ret    

00802eac <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  802eac:	55                   	push   %ebp
  802ead:	89 e5                	mov    %esp,%ebp
  802eaf:	83 ec 38             	sub    $0x38,%esp
  802eb2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802eb5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802eb8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802ebb:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ec0:	b8 08 00 00 00       	mov    $0x8,%eax
  802ec5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecb:	89 df                	mov    %ebx,%edi
  802ecd:	89 de                	mov    %ebx,%esi
  802ecf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  802ed1:	85 c0                	test   %eax,%eax
  802ed3:	7e 28                	jle    802efd <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  802ed5:	89 44 24 10          	mov    %eax,0x10(%esp)
  802ed9:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  802ee0:	00 
  802ee1:	c7 44 24 08 bf 52 80 	movl   $0x8052bf,0x8(%esp)
  802ee8:	00 
  802ee9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802ef0:	00 
  802ef1:	c7 04 24 dc 52 80 00 	movl   $0x8052dc,(%esp)
  802ef8:	e8 c3 f1 ff ff       	call   8020c0 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802efd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802f00:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802f03:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802f06:	89 ec                	mov    %ebp,%esp
  802f08:	5d                   	pop    %ebp
  802f09:	c3                   	ret    

00802f0a <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  802f0a:	55                   	push   %ebp
  802f0b:	89 e5                	mov    %esp,%ebp
  802f0d:	83 ec 38             	sub    $0x38,%esp
  802f10:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802f13:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802f16:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802f19:	bb 00 00 00 00       	mov    $0x0,%ebx
  802f1e:	b8 06 00 00 00       	mov    $0x6,%eax
  802f23:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802f26:	8b 55 08             	mov    0x8(%ebp),%edx
  802f29:	89 df                	mov    %ebx,%edi
  802f2b:	89 de                	mov    %ebx,%esi
  802f2d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	7e 28                	jle    802f5b <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  802f33:	89 44 24 10          	mov    %eax,0x10(%esp)
  802f37:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  802f3e:	00 
  802f3f:	c7 44 24 08 bf 52 80 	movl   $0x8052bf,0x8(%esp)
  802f46:	00 
  802f47:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802f4e:	00 
  802f4f:	c7 04 24 dc 52 80 00 	movl   $0x8052dc,(%esp)
  802f56:	e8 65 f1 ff ff       	call   8020c0 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  802f5b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802f5e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802f61:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802f64:	89 ec                	mov    %ebp,%esp
  802f66:	5d                   	pop    %ebp
  802f67:	c3                   	ret    

00802f68 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802f68:	55                   	push   %ebp
  802f69:	89 e5                	mov    %esp,%ebp
  802f6b:	83 ec 38             	sub    $0x38,%esp
  802f6e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802f71:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802f74:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802f77:	b8 05 00 00 00       	mov    $0x5,%eax
  802f7c:	8b 75 18             	mov    0x18(%ebp),%esi
  802f7f:	8b 7d 14             	mov    0x14(%ebp),%edi
  802f82:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802f85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802f88:	8b 55 08             	mov    0x8(%ebp),%edx
  802f8b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  802f8d:	85 c0                	test   %eax,%eax
  802f8f:	7e 28                	jle    802fb9 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  802f91:	89 44 24 10          	mov    %eax,0x10(%esp)
  802f95:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  802f9c:	00 
  802f9d:	c7 44 24 08 bf 52 80 	movl   $0x8052bf,0x8(%esp)
  802fa4:	00 
  802fa5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  802fac:	00 
  802fad:	c7 04 24 dc 52 80 00 	movl   $0x8052dc,(%esp)
  802fb4:	e8 07 f1 ff ff       	call   8020c0 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  802fb9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802fbc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802fbf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802fc2:	89 ec                	mov    %ebp,%esp
  802fc4:	5d                   	pop    %ebp
  802fc5:	c3                   	ret    

00802fc6 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802fc6:	55                   	push   %ebp
  802fc7:	89 e5                	mov    %esp,%ebp
  802fc9:	83 ec 38             	sub    $0x38,%esp
  802fcc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802fcf:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802fd2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802fd5:	be 00 00 00 00       	mov    $0x0,%esi
  802fda:	b8 04 00 00 00       	mov    $0x4,%eax
  802fdf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802fe2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802fe5:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe8:	89 f7                	mov    %esi,%edi
  802fea:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  802fec:	85 c0                	test   %eax,%eax
  802fee:	7e 28                	jle    803018 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  802ff0:	89 44 24 10          	mov    %eax,0x10(%esp)
  802ff4:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  802ffb:	00 
  802ffc:	c7 44 24 08 bf 52 80 	movl   $0x8052bf,0x8(%esp)
  803003:	00 
  803004:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80300b:	00 
  80300c:	c7 04 24 dc 52 80 00 	movl   $0x8052dc,(%esp)
  803013:	e8 a8 f0 ff ff       	call   8020c0 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  803018:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80301b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80301e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803021:	89 ec                	mov    %ebp,%esp
  803023:	5d                   	pop    %ebp
  803024:	c3                   	ret    

00803025 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  803025:	55                   	push   %ebp
  803026:	89 e5                	mov    %esp,%ebp
  803028:	83 ec 0c             	sub    $0xc,%esp
  80302b:	89 1c 24             	mov    %ebx,(%esp)
  80302e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803032:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  803036:	ba 00 00 00 00       	mov    $0x0,%edx
  80303b:	b8 0b 00 00 00       	mov    $0xb,%eax
  803040:	89 d1                	mov    %edx,%ecx
  803042:	89 d3                	mov    %edx,%ebx
  803044:	89 d7                	mov    %edx,%edi
  803046:	89 d6                	mov    %edx,%esi
  803048:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80304a:	8b 1c 24             	mov    (%esp),%ebx
  80304d:	8b 74 24 04          	mov    0x4(%esp),%esi
  803051:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803055:	89 ec                	mov    %ebp,%esp
  803057:	5d                   	pop    %ebp
  803058:	c3                   	ret    

00803059 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  803059:	55                   	push   %ebp
  80305a:	89 e5                	mov    %esp,%ebp
  80305c:	83 ec 0c             	sub    $0xc,%esp
  80305f:	89 1c 24             	mov    %ebx,(%esp)
  803062:	89 74 24 04          	mov    %esi,0x4(%esp)
  803066:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80306a:	ba 00 00 00 00       	mov    $0x0,%edx
  80306f:	b8 02 00 00 00       	mov    $0x2,%eax
  803074:	89 d1                	mov    %edx,%ecx
  803076:	89 d3                	mov    %edx,%ebx
  803078:	89 d7                	mov    %edx,%edi
  80307a:	89 d6                	mov    %edx,%esi
  80307c:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80307e:	8b 1c 24             	mov    (%esp),%ebx
  803081:	8b 74 24 04          	mov    0x4(%esp),%esi
  803085:	8b 7c 24 08          	mov    0x8(%esp),%edi
  803089:	89 ec                	mov    %ebp,%esp
  80308b:	5d                   	pop    %ebp
  80308c:	c3                   	ret    

0080308d <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  80308d:	55                   	push   %ebp
  80308e:	89 e5                	mov    %esp,%ebp
  803090:	83 ec 38             	sub    $0x38,%esp
  803093:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803096:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803099:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80309c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8030a1:	b8 03 00 00 00       	mov    $0x3,%eax
  8030a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8030a9:	89 cb                	mov    %ecx,%ebx
  8030ab:	89 cf                	mov    %ecx,%edi
  8030ad:	89 ce                	mov    %ecx,%esi
  8030af:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8030b1:	85 c0                	test   %eax,%eax
  8030b3:	7e 28                	jle    8030dd <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8030b5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8030b9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8030c0:	00 
  8030c1:	c7 44 24 08 bf 52 80 	movl   $0x8052bf,0x8(%esp)
  8030c8:	00 
  8030c9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8030d0:	00 
  8030d1:	c7 04 24 dc 52 80 00 	movl   $0x8052dc,(%esp)
  8030d8:	e8 e3 ef ff ff       	call   8020c0 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8030dd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8030e0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8030e3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8030e6:	89 ec                	mov    %ebp,%esp
  8030e8:	5d                   	pop    %ebp
  8030e9:	c3                   	ret    
	...

008030ec <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8030ec:	55                   	push   %ebp
  8030ed:	89 e5                	mov    %esp,%ebp
  8030ef:	53                   	push   %ebx
  8030f0:	83 ec 14             	sub    $0x14,%esp
  8030f3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    // cprintf("\nhere outside loading creating page\n");

	if (_pgfault_handler == 0) {
  8030f6:	83 3d 90 d1 80 00 00 	cmpl   $0x0,0x80d190
  8030fd:	75 58                	jne    803157 <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
           //cprintf("\nhere inside loading creating page\n");    
          if(sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  8030ff:	e8 55 ff ff ff       	call   803059 <sys_getenvid>
  803104:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80310b:	00 
  80310c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  803113:	ee 
  803114:	89 04 24             	mov    %eax,(%esp)
  803117:	e8 aa fe ff ff       	call   802fc6 <sys_page_alloc>
  80311c:	85 c0                	test   %eax,%eax
  80311e:	79 1c                	jns    80313c <set_pgfault_handler+0x50>
                          panic("Cant allocate Page");                    
  803120:	c7 44 24 08 ea 52 80 	movl   $0x8052ea,0x8(%esp)
  803127:	00 
  803128:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80312f:	00 
  803130:	c7 04 24 fd 52 80 00 	movl   $0x8052fd,(%esp)
  803137:	e8 84 ef ff ff       	call   8020c0 <_panic>
                _pgfault_handler=handler;
  80313c:	89 1d 90 d1 80 00    	mov    %ebx,0x80d190
//entry point _pgfault_handler not pointed to by the kernel bcz after the execution is complete control needs to be returned back to execute the rest...so upcall is there         
             sys_env_set_pgfault_upcall(sys_getenvid(),_pgfault_upcall);
  803142:	e8 12 ff ff ff       	call   803059 <sys_getenvid>
  803147:	c7 44 24 04 64 31 80 	movl   $0x803164,0x4(%esp)
  80314e:	00 
  80314f:	89 04 24             	mov    %eax,(%esp)
  803152:	e8 99 fc ff ff       	call   802df0 <sys_env_set_pgfault_upcall>

	// Save handler pointer for assembly to call.
 //     if(sys_page_alloc(0,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
   //                       panic("Cant allocate Page");

	_pgfault_handler = handler;
  803157:	89 1d 90 d1 80 00    	mov    %ebx,0x80d190
}
  80315d:	83 c4 14             	add    $0x14,%esp
  803160:	5b                   	pop    %ebx
  803161:	5d                   	pop    %ebp
  803162:	c3                   	ret    
	...

00803164 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803164:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803165:	a1 90 d1 80 00       	mov    0x80d190,%eax
	call *%eax
  80316a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80316c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
           addl $8,%esp
  80316f:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
            movl  32(%esp),%ebx
  803172:	8b 5c 24 20          	mov    0x20(%esp),%ebx
            movl  40(%esp),%eax
  803176:	8b 44 24 28          	mov    0x28(%esp),%eax
            subl  $4,%eax
  80317a:	83 e8 04             	sub    $0x4,%eax
            movl  %eax,40(%esp)
  80317d:	89 44 24 28          	mov    %eax,0x28(%esp)
            movl  %ebx,(%eax)
  803181:	89 18                	mov    %ebx,(%eax)
            popal
  803183:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
            
            add $4,%esp            
  803184:	83 c4 04             	add    $0x4,%esp
            popfl
  803187:	9d                   	popf   
             
           popl %esp
  803188:	5c                   	pop    %esp
	// LAB 4: Your code here.
           

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
           ret
  803189:	c3                   	ret    
  80318a:	00 00                	add    %al,(%eax)
  80318c:	00 00                	add    %al,(%eax)
	...

00803190 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  803190:	55                   	push   %ebp
  803191:	89 e5                	mov    %esp,%ebp
  803193:	57                   	push   %edi
  803194:	56                   	push   %esi
  803195:	53                   	push   %ebx
  803196:	83 ec 1c             	sub    $0x1c,%esp
  803199:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80319c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80319f:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  8031a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8031a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031a9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8031ad:	89 74 24 04          	mov    %esi,0x4(%esp)
  8031b1:	89 1c 24             	mov    %ebx,(%esp)
  8031b4:	e8 ff fb ff ff       	call   802db8 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  8031b9:	85 c0                	test   %eax,%eax
  8031bb:	79 21                	jns    8031de <ipc_send+0x4e>
  8031bd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8031c0:	74 1c                	je     8031de <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  8031c2:	c7 44 24 08 0b 53 80 	movl   $0x80530b,0x8(%esp)
  8031c9:	00 
  8031ca:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  8031d1:	00 
  8031d2:	c7 04 24 1d 53 80 00 	movl   $0x80531d,(%esp)
  8031d9:	e8 e2 ee ff ff       	call   8020c0 <_panic>
          else if(r==-E_IPC_NOT_RECV)
  8031de:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8031e1:	75 07                	jne    8031ea <ipc_send+0x5a>
           sys_yield();
  8031e3:	e8 3d fe ff ff       	call   803025 <sys_yield>
          else
            break;
        }
  8031e8:	eb b8                	jmp    8031a2 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  8031ea:	83 c4 1c             	add    $0x1c,%esp
  8031ed:	5b                   	pop    %ebx
  8031ee:	5e                   	pop    %esi
  8031ef:	5f                   	pop    %edi
  8031f0:	5d                   	pop    %ebp
  8031f1:	c3                   	ret    

008031f2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8031f2:	55                   	push   %ebp
  8031f3:	89 e5                	mov    %esp,%ebp
  8031f5:	83 ec 18             	sub    $0x18,%esp
  8031f8:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8031fb:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8031fe:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803201:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  803204:	8b 45 0c             	mov    0xc(%ebp),%eax
  803207:	89 04 24             	mov    %eax,(%esp)
  80320a:	e8 4c fb ff ff       	call   802d5b <sys_ipc_recv>
        if(r<0)
  80320f:	85 c0                	test   %eax,%eax
  803211:	79 17                	jns    80322a <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  803213:	85 db                	test   %ebx,%ebx
  803215:	74 06                	je     80321d <ipc_recv+0x2b>
               *from_env_store =0;
  803217:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  80321d:	85 f6                	test   %esi,%esi
  80321f:	90                   	nop
  803220:	74 2c                	je     80324e <ipc_recv+0x5c>
              *perm_store=0;
  803222:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  803228:	eb 24                	jmp    80324e <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  80322a:	85 db                	test   %ebx,%ebx
  80322c:	74 0a                	je     803238 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  80322e:	a1 88 d1 80 00       	mov    0x80d188,%eax
  803233:	8b 40 74             	mov    0x74(%eax),%eax
  803236:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  803238:	85 f6                	test   %esi,%esi
  80323a:	74 0a                	je     803246 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  80323c:	a1 88 d1 80 00       	mov    0x80d188,%eax
  803241:	8b 40 78             	mov    0x78(%eax),%eax
  803244:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  803246:	a1 88 d1 80 00       	mov    0x80d188,%eax
  80324b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80324e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803251:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803254:	89 ec                	mov    %ebp,%esp
  803256:	5d                   	pop    %ebp
  803257:	c3                   	ret    
	...

00803260 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  803260:	55                   	push   %ebp
  803261:	89 e5                	mov    %esp,%ebp
  803263:	8b 45 08             	mov    0x8(%ebp),%eax
  803266:	05 00 00 00 30       	add    $0x30000000,%eax
  80326b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80326e:	5d                   	pop    %ebp
  80326f:	c3                   	ret    

00803270 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  803270:	55                   	push   %ebp
  803271:	89 e5                	mov    %esp,%ebp
  803273:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  803276:	8b 45 08             	mov    0x8(%ebp),%eax
  803279:	89 04 24             	mov    %eax,(%esp)
  80327c:	e8 df ff ff ff       	call   803260 <fd2num>
  803281:	05 20 00 0d 00       	add    $0xd0020,%eax
  803286:	c1 e0 0c             	shl    $0xc,%eax
}
  803289:	c9                   	leave  
  80328a:	c3                   	ret    

0080328b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80328b:	55                   	push   %ebp
  80328c:	89 e5                	mov    %esp,%ebp
  80328e:	57                   	push   %edi
  80328f:	56                   	push   %esi
  803290:	53                   	push   %ebx
  803291:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  803294:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  803299:	a8 01                	test   $0x1,%al
  80329b:	74 36                	je     8032d3 <fd_alloc+0x48>
  80329d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8032a2:	a8 01                	test   $0x1,%al
  8032a4:	74 2d                	je     8032d3 <fd_alloc+0x48>
  8032a6:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  8032ab:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8032b0:	be 00 00 40 ef       	mov    $0xef400000,%esi
  8032b5:	89 c3                	mov    %eax,%ebx
  8032b7:	89 c2                	mov    %eax,%edx
  8032b9:	c1 ea 16             	shr    $0x16,%edx
  8032bc:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8032bf:	f6 c2 01             	test   $0x1,%dl
  8032c2:	74 14                	je     8032d8 <fd_alloc+0x4d>
  8032c4:	89 c2                	mov    %eax,%edx
  8032c6:	c1 ea 0c             	shr    $0xc,%edx
  8032c9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  8032cc:	f6 c2 01             	test   $0x1,%dl
  8032cf:	75 10                	jne    8032e1 <fd_alloc+0x56>
  8032d1:	eb 05                	jmp    8032d8 <fd_alloc+0x4d>
  8032d3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  8032d8:	89 1f                	mov    %ebx,(%edi)
  8032da:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8032df:	eb 17                	jmp    8032f8 <fd_alloc+0x6d>
  8032e1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8032e6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8032eb:	75 c8                	jne    8032b5 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8032ed:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8032f3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8032f8:	5b                   	pop    %ebx
  8032f9:	5e                   	pop    %esi
  8032fa:	5f                   	pop    %edi
  8032fb:	5d                   	pop    %ebp
  8032fc:	c3                   	ret    

008032fd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8032fd:	55                   	push   %ebp
  8032fe:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  803300:	8b 45 08             	mov    0x8(%ebp),%eax
  803303:	83 f8 1f             	cmp    $0x1f,%eax
  803306:	77 36                	ja     80333e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  803308:	05 00 00 0d 00       	add    $0xd0000,%eax
  80330d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  803310:	89 c2                	mov    %eax,%edx
  803312:	c1 ea 16             	shr    $0x16,%edx
  803315:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80331c:	f6 c2 01             	test   $0x1,%dl
  80331f:	74 1d                	je     80333e <fd_lookup+0x41>
  803321:	89 c2                	mov    %eax,%edx
  803323:	c1 ea 0c             	shr    $0xc,%edx
  803326:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80332d:	f6 c2 01             	test   $0x1,%dl
  803330:	74 0c                	je     80333e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  803332:	8b 55 0c             	mov    0xc(%ebp),%edx
  803335:	89 02                	mov    %eax,(%edx)
  803337:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80333c:	eb 05                	jmp    803343 <fd_lookup+0x46>
  80333e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  803343:	5d                   	pop    %ebp
  803344:	c3                   	ret    

00803345 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  803345:	55                   	push   %ebp
  803346:	89 e5                	mov    %esp,%ebp
  803348:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80334b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80334e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803352:	8b 45 08             	mov    0x8(%ebp),%eax
  803355:	89 04 24             	mov    %eax,(%esp)
  803358:	e8 a0 ff ff ff       	call   8032fd <fd_lookup>
  80335d:	85 c0                	test   %eax,%eax
  80335f:	78 0e                	js     80336f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  803361:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803364:	8b 55 0c             	mov    0xc(%ebp),%edx
  803367:	89 50 04             	mov    %edx,0x4(%eax)
  80336a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80336f:	c9                   	leave  
  803370:	c3                   	ret    

00803371 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  803371:	55                   	push   %ebp
  803372:	89 e5                	mov    %esp,%ebp
  803374:	56                   	push   %esi
  803375:	53                   	push   %ebx
  803376:	83 ec 10             	sub    $0x10,%esp
  803379:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80337c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80337f:	b8 68 d0 80 00       	mov    $0x80d068,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  803384:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  803389:	be a8 53 80 00       	mov    $0x8053a8,%esi
		if (devtab[i]->dev_id == dev_id) {
  80338e:	39 08                	cmp    %ecx,(%eax)
  803390:	75 10                	jne    8033a2 <dev_lookup+0x31>
  803392:	eb 04                	jmp    803398 <dev_lookup+0x27>
  803394:	39 08                	cmp    %ecx,(%eax)
  803396:	75 0a                	jne    8033a2 <dev_lookup+0x31>
			*dev = devtab[i];
  803398:	89 03                	mov    %eax,(%ebx)
  80339a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80339f:	90                   	nop
  8033a0:	eb 31                	jmp    8033d3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8033a2:	83 c2 01             	add    $0x1,%edx
  8033a5:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8033a8:	85 c0                	test   %eax,%eax
  8033aa:	75 e8                	jne    803394 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8033ac:	a1 88 d1 80 00       	mov    0x80d188,%eax
  8033b1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8033b4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8033b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033bc:	c7 04 24 28 53 80 00 	movl   $0x805328,(%esp)
  8033c3:	e8 bd ed ff ff       	call   802185 <cprintf>
	*dev = 0;
  8033c8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8033ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8033d3:	83 c4 10             	add    $0x10,%esp
  8033d6:	5b                   	pop    %ebx
  8033d7:	5e                   	pop    %esi
  8033d8:	5d                   	pop    %ebp
  8033d9:	c3                   	ret    

008033da <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8033da:	55                   	push   %ebp
  8033db:	89 e5                	mov    %esp,%ebp
  8033dd:	53                   	push   %ebx
  8033de:	83 ec 24             	sub    $0x24,%esp
  8033e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8033e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8033e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8033eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ee:	89 04 24             	mov    %eax,(%esp)
  8033f1:	e8 07 ff ff ff       	call   8032fd <fd_lookup>
  8033f6:	85 c0                	test   %eax,%eax
  8033f8:	78 53                	js     80344d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8033fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8033fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  803401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803404:	8b 00                	mov    (%eax),%eax
  803406:	89 04 24             	mov    %eax,(%esp)
  803409:	e8 63 ff ff ff       	call   803371 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80340e:	85 c0                	test   %eax,%eax
  803410:	78 3b                	js     80344d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  803412:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803417:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80341a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80341e:	74 2d                	je     80344d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  803420:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  803423:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80342a:	00 00 00 
	stat->st_isdir = 0;
  80342d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  803434:	00 00 00 
	stat->st_dev = dev;
  803437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  803440:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803444:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803447:	89 14 24             	mov    %edx,(%esp)
  80344a:	ff 50 14             	call   *0x14(%eax)
}
  80344d:	83 c4 24             	add    $0x24,%esp
  803450:	5b                   	pop    %ebx
  803451:	5d                   	pop    %ebp
  803452:	c3                   	ret    

00803453 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  803453:	55                   	push   %ebp
  803454:	89 e5                	mov    %esp,%ebp
  803456:	53                   	push   %ebx
  803457:	83 ec 24             	sub    $0x24,%esp
  80345a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80345d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  803460:	89 44 24 04          	mov    %eax,0x4(%esp)
  803464:	89 1c 24             	mov    %ebx,(%esp)
  803467:	e8 91 fe ff ff       	call   8032fd <fd_lookup>
  80346c:	85 c0                	test   %eax,%eax
  80346e:	78 5f                	js     8034cf <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  803470:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803473:	89 44 24 04          	mov    %eax,0x4(%esp)
  803477:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80347a:	8b 00                	mov    (%eax),%eax
  80347c:	89 04 24             	mov    %eax,(%esp)
  80347f:	e8 ed fe ff ff       	call   803371 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  803484:	85 c0                	test   %eax,%eax
  803486:	78 47                	js     8034cf <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  803488:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80348b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80348f:	75 23                	jne    8034b4 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  803491:	a1 88 d1 80 00       	mov    0x80d188,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  803496:	8b 40 4c             	mov    0x4c(%eax),%eax
  803499:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80349d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034a1:	c7 04 24 48 53 80 00 	movl   $0x805348,(%esp)
  8034a8:	e8 d8 ec ff ff       	call   802185 <cprintf>
  8034ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  8034b2:	eb 1b                	jmp    8034cf <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8034b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b7:	8b 48 18             	mov    0x18(%eax),%ecx
  8034ba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8034bf:	85 c9                	test   %ecx,%ecx
  8034c1:	74 0c                	je     8034cf <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8034c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034ca:	89 14 24             	mov    %edx,(%esp)
  8034cd:	ff d1                	call   *%ecx
}
  8034cf:	83 c4 24             	add    $0x24,%esp
  8034d2:	5b                   	pop    %ebx
  8034d3:	5d                   	pop    %ebp
  8034d4:	c3                   	ret    

008034d5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8034d5:	55                   	push   %ebp
  8034d6:	89 e5                	mov    %esp,%ebp
  8034d8:	53                   	push   %ebx
  8034d9:	83 ec 24             	sub    $0x24,%esp
  8034dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8034df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8034e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034e6:	89 1c 24             	mov    %ebx,(%esp)
  8034e9:	e8 0f fe ff ff       	call   8032fd <fd_lookup>
  8034ee:	85 c0                	test   %eax,%eax
  8034f0:	78 66                	js     803558 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8034f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8034f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8034f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034fc:	8b 00                	mov    (%eax),%eax
  8034fe:	89 04 24             	mov    %eax,(%esp)
  803501:	e8 6b fe ff ff       	call   803371 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803506:	85 c0                	test   %eax,%eax
  803508:	78 4e                	js     803558 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80350a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80350d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  803511:	75 23                	jne    803536 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  803513:	a1 88 d1 80 00       	mov    0x80d188,%eax
  803518:	8b 40 4c             	mov    0x4c(%eax),%eax
  80351b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80351f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803523:	c7 04 24 6c 53 80 00 	movl   $0x80536c,(%esp)
  80352a:	e8 56 ec ff ff       	call   802185 <cprintf>
  80352f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  803534:	eb 22                	jmp    803558 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  803536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803539:	8b 48 0c             	mov    0xc(%eax),%ecx
  80353c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803541:	85 c9                	test   %ecx,%ecx
  803543:	74 13                	je     803558 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  803545:	8b 45 10             	mov    0x10(%ebp),%eax
  803548:	89 44 24 08          	mov    %eax,0x8(%esp)
  80354c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80354f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803553:	89 14 24             	mov    %edx,(%esp)
  803556:	ff d1                	call   *%ecx
}
  803558:	83 c4 24             	add    $0x24,%esp
  80355b:	5b                   	pop    %ebx
  80355c:	5d                   	pop    %ebp
  80355d:	c3                   	ret    

0080355e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80355e:	55                   	push   %ebp
  80355f:	89 e5                	mov    %esp,%ebp
  803561:	53                   	push   %ebx
  803562:	83 ec 24             	sub    $0x24,%esp
  803565:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  803568:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80356b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80356f:	89 1c 24             	mov    %ebx,(%esp)
  803572:	e8 86 fd ff ff       	call   8032fd <fd_lookup>
  803577:	85 c0                	test   %eax,%eax
  803579:	78 6b                	js     8035e6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80357b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80357e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803585:	8b 00                	mov    (%eax),%eax
  803587:	89 04 24             	mov    %eax,(%esp)
  80358a:	e8 e2 fd ff ff       	call   803371 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80358f:	85 c0                	test   %eax,%eax
  803591:	78 53                	js     8035e6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  803593:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803596:	8b 42 08             	mov    0x8(%edx),%eax
  803599:	83 e0 03             	and    $0x3,%eax
  80359c:	83 f8 01             	cmp    $0x1,%eax
  80359f:	75 23                	jne    8035c4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8035a1:	a1 88 d1 80 00       	mov    0x80d188,%eax
  8035a6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8035a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035b1:	c7 04 24 89 53 80 00 	movl   $0x805389,(%esp)
  8035b8:	e8 c8 eb ff ff       	call   802185 <cprintf>
  8035bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8035c2:	eb 22                	jmp    8035e6 <read+0x88>
	}
	if (!dev->dev_read)
  8035c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c7:	8b 48 08             	mov    0x8(%eax),%ecx
  8035ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8035cf:	85 c9                	test   %ecx,%ecx
  8035d1:	74 13                	je     8035e6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8035d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8035d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8035da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8035dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8035e1:	89 14 24             	mov    %edx,(%esp)
  8035e4:	ff d1                	call   *%ecx
}
  8035e6:	83 c4 24             	add    $0x24,%esp
  8035e9:	5b                   	pop    %ebx
  8035ea:	5d                   	pop    %ebp
  8035eb:	c3                   	ret    

008035ec <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8035ec:	55                   	push   %ebp
  8035ed:	89 e5                	mov    %esp,%ebp
  8035ef:	57                   	push   %edi
  8035f0:	56                   	push   %esi
  8035f1:	53                   	push   %ebx
  8035f2:	83 ec 1c             	sub    $0x1c,%esp
  8035f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8035f8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8035fb:	ba 00 00 00 00       	mov    $0x0,%edx
  803600:	bb 00 00 00 00       	mov    $0x0,%ebx
  803605:	b8 00 00 00 00       	mov    $0x0,%eax
  80360a:	85 f6                	test   %esi,%esi
  80360c:	74 29                	je     803637 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80360e:	89 f0                	mov    %esi,%eax
  803610:	29 d0                	sub    %edx,%eax
  803612:	89 44 24 08          	mov    %eax,0x8(%esp)
  803616:	03 55 0c             	add    0xc(%ebp),%edx
  803619:	89 54 24 04          	mov    %edx,0x4(%esp)
  80361d:	89 3c 24             	mov    %edi,(%esp)
  803620:	e8 39 ff ff ff       	call   80355e <read>
		if (m < 0)
  803625:	85 c0                	test   %eax,%eax
  803627:	78 0e                	js     803637 <readn+0x4b>
			return m;
		if (m == 0)
  803629:	85 c0                	test   %eax,%eax
  80362b:	74 08                	je     803635 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80362d:	01 c3                	add    %eax,%ebx
  80362f:	89 da                	mov    %ebx,%edx
  803631:	39 f3                	cmp    %esi,%ebx
  803633:	72 d9                	jb     80360e <readn+0x22>
  803635:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  803637:	83 c4 1c             	add    $0x1c,%esp
  80363a:	5b                   	pop    %ebx
  80363b:	5e                   	pop    %esi
  80363c:	5f                   	pop    %edi
  80363d:	5d                   	pop    %ebp
  80363e:	c3                   	ret    

0080363f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80363f:	55                   	push   %ebp
  803640:	89 e5                	mov    %esp,%ebp
  803642:	56                   	push   %esi
  803643:	53                   	push   %ebx
  803644:	83 ec 20             	sub    $0x20,%esp
  803647:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80364a:	89 34 24             	mov    %esi,(%esp)
  80364d:	e8 0e fc ff ff       	call   803260 <fd2num>
  803652:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803655:	89 54 24 04          	mov    %edx,0x4(%esp)
  803659:	89 04 24             	mov    %eax,(%esp)
  80365c:	e8 9c fc ff ff       	call   8032fd <fd_lookup>
  803661:	89 c3                	mov    %eax,%ebx
  803663:	85 c0                	test   %eax,%eax
  803665:	78 05                	js     80366c <fd_close+0x2d>
  803667:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80366a:	74 0c                	je     803678 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80366c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  803670:	19 c0                	sbb    %eax,%eax
  803672:	f7 d0                	not    %eax
  803674:	21 c3                	and    %eax,%ebx
  803676:	eb 3d                	jmp    8036b5 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  803678:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80367b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80367f:	8b 06                	mov    (%esi),%eax
  803681:	89 04 24             	mov    %eax,(%esp)
  803684:	e8 e8 fc ff ff       	call   803371 <dev_lookup>
  803689:	89 c3                	mov    %eax,%ebx
  80368b:	85 c0                	test   %eax,%eax
  80368d:	78 16                	js     8036a5 <fd_close+0x66>
		if (dev->dev_close)
  80368f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803692:	8b 40 10             	mov    0x10(%eax),%eax
  803695:	bb 00 00 00 00       	mov    $0x0,%ebx
  80369a:	85 c0                	test   %eax,%eax
  80369c:	74 07                	je     8036a5 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80369e:	89 34 24             	mov    %esi,(%esp)
  8036a1:	ff d0                	call   *%eax
  8036a3:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8036a5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8036a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8036b0:	e8 55 f8 ff ff       	call   802f0a <sys_page_unmap>
	return r;
}
  8036b5:	89 d8                	mov    %ebx,%eax
  8036b7:	83 c4 20             	add    $0x20,%esp
  8036ba:	5b                   	pop    %ebx
  8036bb:	5e                   	pop    %esi
  8036bc:	5d                   	pop    %ebp
  8036bd:	c3                   	ret    

008036be <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8036be:	55                   	push   %ebp
  8036bf:	89 e5                	mov    %esp,%ebp
  8036c1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8036c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8036c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ce:	89 04 24             	mov    %eax,(%esp)
  8036d1:	e8 27 fc ff ff       	call   8032fd <fd_lookup>
  8036d6:	85 c0                	test   %eax,%eax
  8036d8:	78 13                	js     8036ed <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8036da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8036e1:	00 
  8036e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036e5:	89 04 24             	mov    %eax,(%esp)
  8036e8:	e8 52 ff ff ff       	call   80363f <fd_close>
}
  8036ed:	c9                   	leave  
  8036ee:	c3                   	ret    

008036ef <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8036ef:	55                   	push   %ebp
  8036f0:	89 e5                	mov    %esp,%ebp
  8036f2:	83 ec 18             	sub    $0x18,%esp
  8036f5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8036f8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8036fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803702:	00 
  803703:	8b 45 08             	mov    0x8(%ebp),%eax
  803706:	89 04 24             	mov    %eax,(%esp)
  803709:	e8 a9 03 00 00       	call   803ab7 <open>
  80370e:	89 c3                	mov    %eax,%ebx
  803710:	85 c0                	test   %eax,%eax
  803712:	78 1b                	js     80372f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  803714:	8b 45 0c             	mov    0xc(%ebp),%eax
  803717:	89 44 24 04          	mov    %eax,0x4(%esp)
  80371b:	89 1c 24             	mov    %ebx,(%esp)
  80371e:	e8 b7 fc ff ff       	call   8033da <fstat>
  803723:	89 c6                	mov    %eax,%esi
	close(fd);
  803725:	89 1c 24             	mov    %ebx,(%esp)
  803728:	e8 91 ff ff ff       	call   8036be <close>
  80372d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80372f:	89 d8                	mov    %ebx,%eax
  803731:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803734:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803737:	89 ec                	mov    %ebp,%esp
  803739:	5d                   	pop    %ebp
  80373a:	c3                   	ret    

0080373b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80373b:	55                   	push   %ebp
  80373c:	89 e5                	mov    %esp,%ebp
  80373e:	53                   	push   %ebx
  80373f:	83 ec 14             	sub    $0x14,%esp
  803742:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  803747:	89 1c 24             	mov    %ebx,(%esp)
  80374a:	e8 6f ff ff ff       	call   8036be <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80374f:	83 c3 01             	add    $0x1,%ebx
  803752:	83 fb 20             	cmp    $0x20,%ebx
  803755:	75 f0                	jne    803747 <close_all+0xc>
		close(i);
}
  803757:	83 c4 14             	add    $0x14,%esp
  80375a:	5b                   	pop    %ebx
  80375b:	5d                   	pop    %ebp
  80375c:	c3                   	ret    

0080375d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80375d:	55                   	push   %ebp
  80375e:	89 e5                	mov    %esp,%ebp
  803760:	83 ec 58             	sub    $0x58,%esp
  803763:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803766:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803769:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80376c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80376f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  803772:	89 44 24 04          	mov    %eax,0x4(%esp)
  803776:	8b 45 08             	mov    0x8(%ebp),%eax
  803779:	89 04 24             	mov    %eax,(%esp)
  80377c:	e8 7c fb ff ff       	call   8032fd <fd_lookup>
  803781:	89 c3                	mov    %eax,%ebx
  803783:	85 c0                	test   %eax,%eax
  803785:	0f 88 e0 00 00 00    	js     80386b <dup+0x10e>
		return r;
	close(newfdnum);
  80378b:	89 3c 24             	mov    %edi,(%esp)
  80378e:	e8 2b ff ff ff       	call   8036be <close>

	newfd = INDEX2FD(newfdnum);
  803793:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  803799:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80379c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379f:	89 04 24             	mov    %eax,(%esp)
  8037a2:	e8 c9 fa ff ff       	call   803270 <fd2data>
  8037a7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8037a9:	89 34 24             	mov    %esi,(%esp)
  8037ac:	e8 bf fa ff ff       	call   803270 <fd2data>
  8037b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  8037b4:	89 da                	mov    %ebx,%edx
  8037b6:	89 d8                	mov    %ebx,%eax
  8037b8:	c1 e8 16             	shr    $0x16,%eax
  8037bb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8037c2:	a8 01                	test   $0x1,%al
  8037c4:	74 43                	je     803809 <dup+0xac>
  8037c6:	c1 ea 0c             	shr    $0xc,%edx
  8037c9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8037d0:	a8 01                	test   $0x1,%al
  8037d2:	74 35                	je     803809 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  8037d4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8037db:	25 07 0e 00 00       	and    $0xe07,%eax
  8037e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8037e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8037e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8037eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8037f2:	00 
  8037f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8037f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8037fe:	e8 65 f7 ff ff       	call   802f68 <sys_page_map>
  803803:	89 c3                	mov    %eax,%ebx
  803805:	85 c0                	test   %eax,%eax
  803807:	78 3f                	js     803848 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  803809:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380c:	89 c2                	mov    %eax,%edx
  80380e:	c1 ea 0c             	shr    $0xc,%edx
  803811:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  803818:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80381e:	89 54 24 10          	mov    %edx,0x10(%esp)
  803822:	89 74 24 0c          	mov    %esi,0xc(%esp)
  803826:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80382d:	00 
  80382e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803832:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803839:	e8 2a f7 ff ff       	call   802f68 <sys_page_map>
  80383e:	89 c3                	mov    %eax,%ebx
  803840:	85 c0                	test   %eax,%eax
  803842:	78 04                	js     803848 <dup+0xeb>
  803844:	89 fb                	mov    %edi,%ebx
  803846:	eb 23                	jmp    80386b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  803848:	89 74 24 04          	mov    %esi,0x4(%esp)
  80384c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803853:	e8 b2 f6 ff ff       	call   802f0a <sys_page_unmap>
	sys_page_unmap(0, nva);
  803858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80385b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80385f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803866:	e8 9f f6 ff ff       	call   802f0a <sys_page_unmap>
	return r;
}
  80386b:	89 d8                	mov    %ebx,%eax
  80386d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803870:	8b 75 f8             	mov    -0x8(%ebp),%esi
  803873:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803876:	89 ec                	mov    %ebp,%esp
  803878:	5d                   	pop    %ebp
  803879:	c3                   	ret    
	...

0080387c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80387c:	55                   	push   %ebp
  80387d:	89 e5                	mov    %esp,%ebp
  80387f:	53                   	push   %ebx
  803880:	83 ec 14             	sub    $0x14,%esp
  803883:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  803885:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80388b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803892:	00 
  803893:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80389a:	00 
  80389b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80389f:	89 14 24             	mov    %edx,(%esp)
  8038a2:	e8 e9 f8 ff ff       	call   803190 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8038a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8038ae:	00 
  8038af:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8038b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038ba:	e8 33 f9 ff ff       	call   8031f2 <ipc_recv>
}
  8038bf:	83 c4 14             	add    $0x14,%esp
  8038c2:	5b                   	pop    %ebx
  8038c3:	5d                   	pop    %ebp
  8038c4:	c3                   	ret    

008038c5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8038c5:	55                   	push   %ebp
  8038c6:	89 e5                	mov    %esp,%ebp
  8038c8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8038cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8038ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8038d1:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8038d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8038d9:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8038de:	ba 00 00 00 00       	mov    $0x0,%edx
  8038e3:	b8 02 00 00 00       	mov    $0x2,%eax
  8038e8:	e8 8f ff ff ff       	call   80387c <fsipc>
}
  8038ed:	c9                   	leave  
  8038ee:	c3                   	ret    

008038ef <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  8038ef:	55                   	push   %ebp
  8038f0:	89 e5                	mov    %esp,%ebp
  8038f2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8038f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8038fa:	b8 08 00 00 00       	mov    $0x8,%eax
  8038ff:	e8 78 ff ff ff       	call   80387c <fsipc>
}
  803904:	c9                   	leave  
  803905:	c3                   	ret    

00803906 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  803906:	55                   	push   %ebp
  803907:	89 e5                	mov    %esp,%ebp
  803909:	53                   	push   %ebx
  80390a:	83 ec 14             	sub    $0x14,%esp
  80390d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  803910:	8b 45 08             	mov    0x8(%ebp),%eax
  803913:	8b 40 0c             	mov    0xc(%eax),%eax
  803916:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80391b:	ba 00 00 00 00       	mov    $0x0,%edx
  803920:	b8 05 00 00 00       	mov    $0x5,%eax
  803925:	e8 52 ff ff ff       	call   80387c <fsipc>
  80392a:	85 c0                	test   %eax,%eax
  80392c:	78 2b                	js     803959 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80392e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  803935:	00 
  803936:	89 1c 24             	mov    %ebx,(%esp)
  803939:	e8 2c ef ff ff       	call   80286a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80393e:	a1 80 60 80 00       	mov    0x806080,%eax
  803943:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  803949:	a1 84 60 80 00       	mov    0x806084,%eax
  80394e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  803954:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  803959:	83 c4 14             	add    $0x14,%esp
  80395c:	5b                   	pop    %ebx
  80395d:	5d                   	pop    %ebp
  80395e:	c3                   	ret    

0080395f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80395f:	55                   	push   %ebp
  803960:	89 e5                	mov    %esp,%ebp
  803962:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  803965:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80396c:	00 
  80396d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803974:	00 
  803975:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  80397c:	e8 45 f0 ff ff       	call   8029c6 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  803981:	8b 45 08             	mov    0x8(%ebp),%eax
  803984:	8b 40 0c             	mov    0xc(%eax),%eax
  803987:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  80398c:	ba 00 00 00 00       	mov    $0x0,%edx
  803991:	b8 06 00 00 00       	mov    $0x6,%eax
  803996:	e8 e1 fe ff ff       	call   80387c <fsipc>
}
  80399b:	c9                   	leave  
  80399c:	c3                   	ret    

0080399d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80399d:	55                   	push   %ebp
  80399e:	89 e5                	mov    %esp,%ebp
  8039a0:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  8039a3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8039aa:	00 
  8039ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8039b2:	00 
  8039b3:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  8039ba:	e8 07 f0 ff ff       	call   8029c6 <memset>
  8039bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8039c2:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8039c7:	76 05                	jbe    8039ce <devfile_write+0x31>
  8039c9:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8039ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8039d1:	8b 52 0c             	mov    0xc(%edx),%edx
  8039d4:	89 15 00 60 80 00    	mov    %edx,0x806000
        fsipcbuf.write.req_n = numberOfBytes;
  8039da:	a3 04 60 80 00       	mov    %eax,0x806004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  8039df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8039e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8039e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039ea:	c7 04 24 08 60 80 00 	movl   $0x806008,(%esp)
  8039f1:	e8 2f f0 ff ff       	call   802a25 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  8039f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8039fb:	b8 04 00 00 00       	mov    $0x4,%eax
  803a00:	e8 77 fe ff ff       	call   80387c <fsipc>
              return r;
        return r;
}
  803a05:	c9                   	leave  
  803a06:	c3                   	ret    

00803a07 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  803a07:	55                   	push   %ebp
  803a08:	89 e5                	mov    %esp,%ebp
  803a0a:	53                   	push   %ebx
  803a0b:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  803a0e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  803a15:	00 
  803a16:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803a1d:	00 
  803a1e:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  803a25:	e8 9c ef ff ff       	call   8029c6 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  803a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803a2d:	8b 40 0c             	mov    0xc(%eax),%eax
  803a30:	a3 00 60 80 00       	mov    %eax,0x806000
        fsipcbuf.read.req_n = n;
  803a35:	8b 45 10             	mov    0x10(%ebp),%eax
  803a38:	a3 04 60 80 00       	mov    %eax,0x806004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  803a3d:	ba 00 00 00 00       	mov    $0x0,%edx
  803a42:	b8 03 00 00 00       	mov    $0x3,%eax
  803a47:	e8 30 fe ff ff       	call   80387c <fsipc>
  803a4c:	89 c3                	mov    %eax,%ebx
  803a4e:	85 c0                	test   %eax,%eax
  803a50:	78 17                	js     803a69 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  803a52:	89 44 24 08          	mov    %eax,0x8(%esp)
  803a56:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  803a5d:	00 
  803a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a61:	89 04 24             	mov    %eax,(%esp)
  803a64:	e8 bc ef ff ff       	call   802a25 <memmove>
        return r;
}
  803a69:	89 d8                	mov    %ebx,%eax
  803a6b:	83 c4 14             	add    $0x14,%esp
  803a6e:	5b                   	pop    %ebx
  803a6f:	5d                   	pop    %ebp
  803a70:	c3                   	ret    

00803a71 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  803a71:	55                   	push   %ebp
  803a72:	89 e5                	mov    %esp,%ebp
  803a74:	53                   	push   %ebx
  803a75:	83 ec 14             	sub    $0x14,%esp
  803a78:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  803a7b:	89 1c 24             	mov    %ebx,(%esp)
  803a7e:	e8 9d ed ff ff       	call   802820 <strlen>
  803a83:	89 c2                	mov    %eax,%edx
  803a85:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  803a8a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  803a90:	7f 1f                	jg     803ab1 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  803a92:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803a96:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  803a9d:	e8 c8 ed ff ff       	call   80286a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  803aa2:	ba 00 00 00 00       	mov    $0x0,%edx
  803aa7:	b8 07 00 00 00       	mov    $0x7,%eax
  803aac:	e8 cb fd ff ff       	call   80387c <fsipc>
}
  803ab1:	83 c4 14             	add    $0x14,%esp
  803ab4:	5b                   	pop    %ebx
  803ab5:	5d                   	pop    %ebp
  803ab6:	c3                   	ret    

00803ab7 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  803ab7:	55                   	push   %ebp
  803ab8:	89 e5                	mov    %esp,%ebp
  803aba:	56                   	push   %esi
  803abb:	53                   	push   %ebx
  803abc:	83 ec 20             	sub    $0x20,%esp
  803abf:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  803ac2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  803ac9:	00 
  803aca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803ad1:	00 
  803ad2:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  803ad9:	e8 e8 ee ff ff       	call   8029c6 <memset>
    if(strlen(path)>=MAXPATHLEN)
  803ade:	89 34 24             	mov    %esi,(%esp)
  803ae1:	e8 3a ed ff ff       	call   802820 <strlen>
  803ae6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  803aeb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  803af0:	0f 8f 84 00 00 00    	jg     803b7a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  803af6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803af9:	89 04 24             	mov    %eax,(%esp)
  803afc:	e8 8a f7 ff ff       	call   80328b <fd_alloc>
  803b01:	89 c3                	mov    %eax,%ebx
  803b03:	85 c0                	test   %eax,%eax
  803b05:	78 73                	js     803b7a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  803b07:	0f b6 06             	movzbl (%esi),%eax
  803b0a:	84 c0                	test   %al,%al
  803b0c:	74 20                	je     803b2e <open+0x77>
  803b0e:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  803b10:	0f be c0             	movsbl %al,%eax
  803b13:	89 44 24 04          	mov    %eax,0x4(%esp)
  803b17:	c7 04 24 bc 53 80 00 	movl   $0x8053bc,(%esp)
  803b1e:	e8 62 e6 ff ff       	call   802185 <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  803b23:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  803b27:	83 c3 01             	add    $0x1,%ebx
  803b2a:	84 c0                	test   %al,%al
  803b2c:	75 e2                	jne    803b10 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  803b2e:	89 74 24 04          	mov    %esi,0x4(%esp)
  803b32:	c7 04 24 00 60 80 00 	movl   $0x806000,(%esp)
  803b39:	e8 2c ed ff ff       	call   80286a <strcpy>
    fsipcbuf.open.req_omode = mode;
  803b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803b41:	a3 00 64 80 00       	mov    %eax,0x806400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  803b46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803b49:	b8 01 00 00 00       	mov    $0x1,%eax
  803b4e:	e8 29 fd ff ff       	call   80387c <fsipc>
  803b53:	89 c3                	mov    %eax,%ebx
  803b55:	85 c0                	test   %eax,%eax
  803b57:	79 15                	jns    803b6e <open+0xb7>
        {
            fd_close(fd,1);
  803b59:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  803b60:	00 
  803b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b64:	89 04 24             	mov    %eax,(%esp)
  803b67:	e8 d3 fa ff ff       	call   80363f <fd_close>
             return r;
  803b6c:	eb 0c                	jmp    803b7a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  803b6e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  803b71:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  803b77:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  803b7a:	89 d8                	mov    %ebx,%eax
  803b7c:	83 c4 20             	add    $0x20,%esp
  803b7f:	5b                   	pop    %ebx
  803b80:	5e                   	pop    %esi
  803b81:	5d                   	pop    %ebp
  803b82:	c3                   	ret    
	...

00803b84 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803b84:	55                   	push   %ebp
  803b85:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803b87:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8a:	89 c2                	mov    %eax,%edx
  803b8c:	c1 ea 16             	shr    $0x16,%edx
  803b8f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  803b96:	f6 c2 01             	test   $0x1,%dl
  803b99:	74 26                	je     803bc1 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  803b9b:	c1 e8 0c             	shr    $0xc,%eax
  803b9e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  803ba5:	a8 01                	test   $0x1,%al
  803ba7:	74 18                	je     803bc1 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  803ba9:	c1 e8 0c             	shr    $0xc,%eax
  803bac:	8d 14 40             	lea    (%eax,%eax,2),%edx
  803baf:	c1 e2 02             	shl    $0x2,%edx
  803bb2:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  803bb7:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  803bbc:	0f b7 c0             	movzwl %ax,%eax
  803bbf:	eb 05                	jmp    803bc6 <pageref+0x42>
  803bc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803bc6:	5d                   	pop    %ebp
  803bc7:	c3                   	ret    
	...

00803bd0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803bd0:	55                   	push   %ebp
  803bd1:	89 e5                	mov    %esp,%ebp
  803bd3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803bd6:	c7 44 24 04 bf 53 80 	movl   $0x8053bf,0x4(%esp)
  803bdd:	00 
  803bde:	8b 45 0c             	mov    0xc(%ebp),%eax
  803be1:	89 04 24             	mov    %eax,(%esp)
  803be4:	e8 81 ec ff ff       	call   80286a <strcpy>
	return 0;
}
  803be9:	b8 00 00 00 00       	mov    $0x0,%eax
  803bee:	c9                   	leave  
  803bef:	c3                   	ret    

00803bf0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803bf0:	55                   	push   %ebp
  803bf1:	89 e5                	mov    %esp,%ebp
  803bf3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  803bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf9:	8b 40 0c             	mov    0xc(%eax),%eax
  803bfc:	89 04 24             	mov    %eax,(%esp)
  803bff:	e8 9e 02 00 00       	call   803ea2 <nsipc_close>
}
  803c04:	c9                   	leave  
  803c05:	c3                   	ret    

00803c06 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803c06:	55                   	push   %ebp
  803c07:	89 e5                	mov    %esp,%ebp
  803c09:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  803c0c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803c13:	00 
  803c14:	8b 45 10             	mov    0x10(%ebp),%eax
  803c17:	89 44 24 08          	mov    %eax,0x8(%esp)
  803c1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c22:	8b 45 08             	mov    0x8(%ebp),%eax
  803c25:	8b 40 0c             	mov    0xc(%eax),%eax
  803c28:	89 04 24             	mov    %eax,(%esp)
  803c2b:	e8 ae 02 00 00       	call   803ede <nsipc_send>
}
  803c30:	c9                   	leave  
  803c31:	c3                   	ret    

00803c32 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803c32:	55                   	push   %ebp
  803c33:	89 e5                	mov    %esp,%ebp
  803c35:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803c38:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803c3f:	00 
  803c40:	8b 45 10             	mov    0x10(%ebp),%eax
  803c43:	89 44 24 08          	mov    %eax,0x8(%esp)
  803c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  803c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  803c51:	8b 40 0c             	mov    0xc(%eax),%eax
  803c54:	89 04 24             	mov    %eax,(%esp)
  803c57:	e8 f5 02 00 00       	call   803f51 <nsipc_recv>
}
  803c5c:	c9                   	leave  
  803c5d:	c3                   	ret    

00803c5e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  803c5e:	55                   	push   %ebp
  803c5f:	89 e5                	mov    %esp,%ebp
  803c61:	56                   	push   %esi
  803c62:	53                   	push   %ebx
  803c63:	83 ec 20             	sub    $0x20,%esp
  803c66:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803c68:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803c6b:	89 04 24             	mov    %eax,(%esp)
  803c6e:	e8 18 f6 ff ff       	call   80328b <fd_alloc>
  803c73:	89 c3                	mov    %eax,%ebx
  803c75:	85 c0                	test   %eax,%eax
  803c77:	78 21                	js     803c9a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  803c79:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  803c80:	00 
  803c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c84:	89 44 24 04          	mov    %eax,0x4(%esp)
  803c88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803c8f:	e8 32 f3 ff ff       	call   802fc6 <sys_page_alloc>
  803c94:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  803c96:	85 c0                	test   %eax,%eax
  803c98:	79 0a                	jns    803ca4 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  803c9a:	89 34 24             	mov    %esi,(%esp)
  803c9d:	e8 00 02 00 00       	call   803ea2 <nsipc_close>
		return r;
  803ca2:	eb 28                	jmp    803ccc <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803ca4:	8b 15 84 d0 80 00    	mov    0x80d084,%edx
  803caa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cad:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  803caf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cb2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803cb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cbc:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  803cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803cc2:	89 04 24             	mov    %eax,(%esp)
  803cc5:	e8 96 f5 ff ff       	call   803260 <fd2num>
  803cca:	89 c3                	mov    %eax,%ebx
}
  803ccc:	89 d8                	mov    %ebx,%eax
  803cce:	83 c4 20             	add    $0x20,%esp
  803cd1:	5b                   	pop    %ebx
  803cd2:	5e                   	pop    %esi
  803cd3:	5d                   	pop    %ebp
  803cd4:	c3                   	ret    

00803cd5 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803cd5:	55                   	push   %ebp
  803cd6:	89 e5                	mov    %esp,%ebp
  803cd8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  803cdb:	8b 45 10             	mov    0x10(%ebp),%eax
  803cde:	89 44 24 08          	mov    %eax,0x8(%esp)
  803ce2:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
  803ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  803cec:	89 04 24             	mov    %eax,(%esp)
  803cef:	e8 62 01 00 00       	call   803e56 <nsipc_socket>
  803cf4:	85 c0                	test   %eax,%eax
  803cf6:	78 05                	js     803cfd <socket+0x28>
		return r;
	return alloc_sockfd(r);
  803cf8:	e8 61 ff ff ff       	call   803c5e <alloc_sockfd>
}
  803cfd:	c9                   	leave  
  803cfe:	66 90                	xchg   %ax,%ax
  803d00:	c3                   	ret    

00803d01 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803d01:	55                   	push   %ebp
  803d02:	89 e5                	mov    %esp,%ebp
  803d04:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803d07:	8d 55 f4             	lea    -0xc(%ebp),%edx
  803d0a:	89 54 24 04          	mov    %edx,0x4(%esp)
  803d0e:	89 04 24             	mov    %eax,(%esp)
  803d11:	e8 e7 f5 ff ff       	call   8032fd <fd_lookup>
  803d16:	85 c0                	test   %eax,%eax
  803d18:	78 15                	js     803d2f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  803d1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803d1d:	8b 0a                	mov    (%edx),%ecx
  803d1f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803d24:	3b 0d 84 d0 80 00    	cmp    0x80d084,%ecx
  803d2a:	75 03                	jne    803d2f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  803d2c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  803d2f:	c9                   	leave  
  803d30:	c3                   	ret    

00803d31 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  803d31:	55                   	push   %ebp
  803d32:	89 e5                	mov    %esp,%ebp
  803d34:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d37:	8b 45 08             	mov    0x8(%ebp),%eax
  803d3a:	e8 c2 ff ff ff       	call   803d01 <fd2sockid>
  803d3f:	85 c0                	test   %eax,%eax
  803d41:	78 0f                	js     803d52 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  803d43:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d46:	89 54 24 04          	mov    %edx,0x4(%esp)
  803d4a:	89 04 24             	mov    %eax,(%esp)
  803d4d:	e8 2e 01 00 00       	call   803e80 <nsipc_listen>
}
  803d52:	c9                   	leave  
  803d53:	c3                   	ret    

00803d54 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803d54:	55                   	push   %ebp
  803d55:	89 e5                	mov    %esp,%ebp
  803d57:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  803d5d:	e8 9f ff ff ff       	call   803d01 <fd2sockid>
  803d62:	85 c0                	test   %eax,%eax
  803d64:	78 16                	js     803d7c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  803d66:	8b 55 10             	mov    0x10(%ebp),%edx
  803d69:	89 54 24 08          	mov    %edx,0x8(%esp)
  803d6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d70:	89 54 24 04          	mov    %edx,0x4(%esp)
  803d74:	89 04 24             	mov    %eax,(%esp)
  803d77:	e8 55 02 00 00       	call   803fd1 <nsipc_connect>
}
  803d7c:	c9                   	leave  
  803d7d:	c3                   	ret    

00803d7e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  803d7e:	55                   	push   %ebp
  803d7f:	89 e5                	mov    %esp,%ebp
  803d81:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803d84:	8b 45 08             	mov    0x8(%ebp),%eax
  803d87:	e8 75 ff ff ff       	call   803d01 <fd2sockid>
  803d8c:	85 c0                	test   %eax,%eax
  803d8e:	78 0f                	js     803d9f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  803d90:	8b 55 0c             	mov    0xc(%ebp),%edx
  803d93:	89 54 24 04          	mov    %edx,0x4(%esp)
  803d97:	89 04 24             	mov    %eax,(%esp)
  803d9a:	e8 1d 01 00 00       	call   803ebc <nsipc_shutdown>
}
  803d9f:	c9                   	leave  
  803da0:	c3                   	ret    

00803da1 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803da1:	55                   	push   %ebp
  803da2:	89 e5                	mov    %esp,%ebp
  803da4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803da7:	8b 45 08             	mov    0x8(%ebp),%eax
  803daa:	e8 52 ff ff ff       	call   803d01 <fd2sockid>
  803daf:	85 c0                	test   %eax,%eax
  803db1:	78 16                	js     803dc9 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  803db3:	8b 55 10             	mov    0x10(%ebp),%edx
  803db6:	89 54 24 08          	mov    %edx,0x8(%esp)
  803dba:	8b 55 0c             	mov    0xc(%ebp),%edx
  803dbd:	89 54 24 04          	mov    %edx,0x4(%esp)
  803dc1:	89 04 24             	mov    %eax,(%esp)
  803dc4:	e8 47 02 00 00       	call   804010 <nsipc_bind>
}
  803dc9:	c9                   	leave  
  803dca:	c3                   	ret    

00803dcb <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  803dcb:	55                   	push   %ebp
  803dcc:	89 e5                	mov    %esp,%ebp
  803dce:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd4:	e8 28 ff ff ff       	call   803d01 <fd2sockid>
  803dd9:	85 c0                	test   %eax,%eax
  803ddb:	78 1f                	js     803dfc <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  803ddd:	8b 55 10             	mov    0x10(%ebp),%edx
  803de0:	89 54 24 08          	mov    %edx,0x8(%esp)
  803de4:	8b 55 0c             	mov    0xc(%ebp),%edx
  803de7:	89 54 24 04          	mov    %edx,0x4(%esp)
  803deb:	89 04 24             	mov    %eax,(%esp)
  803dee:	e8 5c 02 00 00       	call   80404f <nsipc_accept>
  803df3:	85 c0                	test   %eax,%eax
  803df5:	78 05                	js     803dfc <accept+0x31>
		return r;
	return alloc_sockfd(r);
  803df7:	e8 62 fe ff ff       	call   803c5e <alloc_sockfd>
}
  803dfc:	c9                   	leave  
  803dfd:	8d 76 00             	lea    0x0(%esi),%esi
  803e00:	c3                   	ret    
	...

00803e10 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803e10:	55                   	push   %ebp
  803e11:	89 e5                	mov    %esp,%ebp
  803e13:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803e16:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  803e1c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803e23:	00 
  803e24:	c7 44 24 08 00 80 80 	movl   $0x808000,0x8(%esp)
  803e2b:	00 
  803e2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803e30:	89 14 24             	mov    %edx,(%esp)
  803e33:	e8 58 f3 ff ff       	call   803190 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803e38:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  803e3f:	00 
  803e40:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  803e47:	00 
  803e48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803e4f:	e8 9e f3 ff ff       	call   8031f2 <ipc_recv>
}
  803e54:	c9                   	leave  
  803e55:	c3                   	ret    

00803e56 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  803e56:	55                   	push   %ebp
  803e57:	89 e5                	mov    %esp,%ebp
  803e59:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  803e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  803e5f:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.socket.req_type = type;
  803e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e67:	a3 04 80 80 00       	mov    %eax,0x808004
	nsipcbuf.socket.req_protocol = protocol;
  803e6c:	8b 45 10             	mov    0x10(%ebp),%eax
  803e6f:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SOCKET);
  803e74:	b8 09 00 00 00       	mov    $0x9,%eax
  803e79:	e8 92 ff ff ff       	call   803e10 <nsipc>
}
  803e7e:	c9                   	leave  
  803e7f:	c3                   	ret    

00803e80 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  803e80:	55                   	push   %ebp
  803e81:	89 e5                	mov    %esp,%ebp
  803e83:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  803e86:	8b 45 08             	mov    0x8(%ebp),%eax
  803e89:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.listen.req_backlog = backlog;
  803e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803e91:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_LISTEN);
  803e96:	b8 06 00 00 00       	mov    $0x6,%eax
  803e9b:	e8 70 ff ff ff       	call   803e10 <nsipc>
}
  803ea0:	c9                   	leave  
  803ea1:	c3                   	ret    

00803ea2 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  803ea2:	55                   	push   %ebp
  803ea3:	89 e5                	mov    %esp,%ebp
  803ea5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  803eab:	a3 00 80 80 00       	mov    %eax,0x808000
	return nsipc(NSREQ_CLOSE);
  803eb0:	b8 04 00 00 00       	mov    $0x4,%eax
  803eb5:	e8 56 ff ff ff       	call   803e10 <nsipc>
}
  803eba:	c9                   	leave  
  803ebb:	c3                   	ret    

00803ebc <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  803ebc:	55                   	push   %ebp
  803ebd:	89 e5                	mov    %esp,%ebp
  803ebf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec5:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.shutdown.req_how = how;
  803eca:	8b 45 0c             	mov    0xc(%ebp),%eax
  803ecd:	a3 04 80 80 00       	mov    %eax,0x808004
	return nsipc(NSREQ_SHUTDOWN);
  803ed2:	b8 03 00 00 00       	mov    $0x3,%eax
  803ed7:	e8 34 ff ff ff       	call   803e10 <nsipc>
}
  803edc:	c9                   	leave  
  803edd:	c3                   	ret    

00803ede <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  803ede:	55                   	push   %ebp
  803edf:	89 e5                	mov    %esp,%ebp
  803ee1:	53                   	push   %ebx
  803ee2:	83 ec 14             	sub    $0x14,%esp
  803ee5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  803eeb:	a3 00 80 80 00       	mov    %eax,0x808000
	assert(size < 1600);
  803ef0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803ef6:	7e 24                	jle    803f1c <nsipc_send+0x3e>
  803ef8:	c7 44 24 0c cb 53 80 	movl   $0x8053cb,0xc(%esp)
  803eff:	00 
  803f00:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  803f07:	00 
  803f08:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  803f0f:	00 
  803f10:	c7 04 24 d7 53 80 00 	movl   $0x8053d7,(%esp)
  803f17:	e8 a4 e1 ff ff       	call   8020c0 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  803f1c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803f20:	8b 45 0c             	mov    0xc(%ebp),%eax
  803f23:	89 44 24 04          	mov    %eax,0x4(%esp)
  803f27:	c7 04 24 0c 80 80 00 	movl   $0x80800c,(%esp)
  803f2e:	e8 f2 ea ff ff       	call   802a25 <memmove>
	nsipcbuf.send.req_size = size;
  803f33:	89 1d 04 80 80 00    	mov    %ebx,0x808004
	nsipcbuf.send.req_flags = flags;
  803f39:	8b 45 14             	mov    0x14(%ebp),%eax
  803f3c:	a3 08 80 80 00       	mov    %eax,0x808008
	return nsipc(NSREQ_SEND);
  803f41:	b8 08 00 00 00       	mov    $0x8,%eax
  803f46:	e8 c5 fe ff ff       	call   803e10 <nsipc>
}
  803f4b:	83 c4 14             	add    $0x14,%esp
  803f4e:	5b                   	pop    %ebx
  803f4f:	5d                   	pop    %ebp
  803f50:	c3                   	ret    

00803f51 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  803f51:	55                   	push   %ebp
  803f52:	89 e5                	mov    %esp,%ebp
  803f54:	56                   	push   %esi
  803f55:	53                   	push   %ebx
  803f56:	83 ec 10             	sub    $0x10,%esp
  803f59:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  803f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f5f:	a3 00 80 80 00       	mov    %eax,0x808000
	nsipcbuf.recv.req_len = len;
  803f64:	89 35 04 80 80 00    	mov    %esi,0x808004
	nsipcbuf.recv.req_flags = flags;
  803f6a:	8b 45 14             	mov    0x14(%ebp),%eax
  803f6d:	a3 08 80 80 00       	mov    %eax,0x808008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  803f72:	b8 07 00 00 00       	mov    $0x7,%eax
  803f77:	e8 94 fe ff ff       	call   803e10 <nsipc>
  803f7c:	89 c3                	mov    %eax,%ebx
  803f7e:	85 c0                	test   %eax,%eax
  803f80:	78 46                	js     803fc8 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  803f82:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  803f87:	7f 04                	jg     803f8d <nsipc_recv+0x3c>
  803f89:	39 c6                	cmp    %eax,%esi
  803f8b:	7d 24                	jge    803fb1 <nsipc_recv+0x60>
  803f8d:	c7 44 24 0c e3 53 80 	movl   $0x8053e3,0xc(%esp)
  803f94:	00 
  803f95:	c7 44 24 08 cd 48 80 	movl   $0x8048cd,0x8(%esp)
  803f9c:	00 
  803f9d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  803fa4:	00 
  803fa5:	c7 04 24 d7 53 80 00 	movl   $0x8053d7,(%esp)
  803fac:	e8 0f e1 ff ff       	call   8020c0 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803fb1:	89 44 24 08          	mov    %eax,0x8(%esp)
  803fb5:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  803fbc:	00 
  803fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fc0:	89 04 24             	mov    %eax,(%esp)
  803fc3:	e8 5d ea ff ff       	call   802a25 <memmove>
	}

	return r;
}
  803fc8:	89 d8                	mov    %ebx,%eax
  803fca:	83 c4 10             	add    $0x10,%esp
  803fcd:	5b                   	pop    %ebx
  803fce:	5e                   	pop    %esi
  803fcf:	5d                   	pop    %ebp
  803fd0:	c3                   	ret    

00803fd1 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803fd1:	55                   	push   %ebp
  803fd2:	89 e5                	mov    %esp,%ebp
  803fd4:	53                   	push   %ebx
  803fd5:	83 ec 14             	sub    $0x14,%esp
  803fd8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  803fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  803fde:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803fe3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  803fea:	89 44 24 04          	mov    %eax,0x4(%esp)
  803fee:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  803ff5:	e8 2b ea ff ff       	call   802a25 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  803ffa:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_CONNECT);
  804000:	b8 05 00 00 00       	mov    $0x5,%eax
  804005:	e8 06 fe ff ff       	call   803e10 <nsipc>
}
  80400a:	83 c4 14             	add    $0x14,%esp
  80400d:	5b                   	pop    %ebx
  80400e:	5d                   	pop    %ebp
  80400f:	c3                   	ret    

00804010 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  804010:	55                   	push   %ebp
  804011:	89 e5                	mov    %esp,%ebp
  804013:	53                   	push   %ebx
  804014:	83 ec 14             	sub    $0x14,%esp
  804017:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80401a:	8b 45 08             	mov    0x8(%ebp),%eax
  80401d:	a3 00 80 80 00       	mov    %eax,0x808000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  804022:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  804026:	8b 45 0c             	mov    0xc(%ebp),%eax
  804029:	89 44 24 04          	mov    %eax,0x4(%esp)
  80402d:	c7 04 24 04 80 80 00 	movl   $0x808004,(%esp)
  804034:	e8 ec e9 ff ff       	call   802a25 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  804039:	89 1d 14 80 80 00    	mov    %ebx,0x808014
	return nsipc(NSREQ_BIND);
  80403f:	b8 02 00 00 00       	mov    $0x2,%eax
  804044:	e8 c7 fd ff ff       	call   803e10 <nsipc>
}
  804049:	83 c4 14             	add    $0x14,%esp
  80404c:	5b                   	pop    %ebx
  80404d:	5d                   	pop    %ebp
  80404e:	c3                   	ret    

0080404f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80404f:	55                   	push   %ebp
  804050:	89 e5                	mov    %esp,%ebp
  804052:	83 ec 18             	sub    $0x18,%esp
  804055:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  804058:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80405b:	8b 45 08             	mov    0x8(%ebp),%eax
  80405e:	a3 00 80 80 00       	mov    %eax,0x808000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  804063:	b8 01 00 00 00       	mov    $0x1,%eax
  804068:	e8 a3 fd ff ff       	call   803e10 <nsipc>
  80406d:	89 c3                	mov    %eax,%ebx
  80406f:	85 c0                	test   %eax,%eax
  804071:	78 25                	js     804098 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  804073:	be 10 80 80 00       	mov    $0x808010,%esi
  804078:	8b 06                	mov    (%esi),%eax
  80407a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80407e:	c7 44 24 04 00 80 80 	movl   $0x808000,0x4(%esp)
  804085:	00 
  804086:	8b 45 0c             	mov    0xc(%ebp),%eax
  804089:	89 04 24             	mov    %eax,(%esp)
  80408c:	e8 94 e9 ff ff       	call   802a25 <memmove>
		*addrlen = ret->ret_addrlen;
  804091:	8b 16                	mov    (%esi),%edx
  804093:	8b 45 10             	mov    0x10(%ebp),%eax
  804096:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  804098:	89 d8                	mov    %ebx,%eax
  80409a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80409d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8040a0:	89 ec                	mov    %ebp,%esp
  8040a2:	5d                   	pop    %ebp
  8040a3:	c3                   	ret    
	...

008040b0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8040b0:	55                   	push   %ebp
  8040b1:	89 e5                	mov    %esp,%ebp
  8040b3:	83 ec 18             	sub    $0x18,%esp
  8040b6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8040b9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8040bc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8040bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8040c2:	89 04 24             	mov    %eax,(%esp)
  8040c5:	e8 a6 f1 ff ff       	call   803270 <fd2data>
  8040ca:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8040cc:	c7 44 24 04 f8 53 80 	movl   $0x8053f8,0x4(%esp)
  8040d3:	00 
  8040d4:	89 34 24             	mov    %esi,(%esp)
  8040d7:	e8 8e e7 ff ff       	call   80286a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8040dc:	8b 43 04             	mov    0x4(%ebx),%eax
  8040df:	2b 03                	sub    (%ebx),%eax
  8040e1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8040e7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8040ee:	00 00 00 
	stat->st_dev = &devpipe;
  8040f1:	c7 86 88 00 00 00 a0 	movl   $0x80d0a0,0x88(%esi)
  8040f8:	d0 80 00 
	return 0;
}
  8040fb:	b8 00 00 00 00       	mov    $0x0,%eax
  804100:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  804103:	8b 75 fc             	mov    -0x4(%ebp),%esi
  804106:	89 ec                	mov    %ebp,%esp
  804108:	5d                   	pop    %ebp
  804109:	c3                   	ret    

0080410a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80410a:	55                   	push   %ebp
  80410b:	89 e5                	mov    %esp,%ebp
  80410d:	53                   	push   %ebx
  80410e:	83 ec 14             	sub    $0x14,%esp
  804111:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  804114:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  804118:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80411f:	e8 e6 ed ff ff       	call   802f0a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  804124:	89 1c 24             	mov    %ebx,(%esp)
  804127:	e8 44 f1 ff ff       	call   803270 <fd2data>
  80412c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804130:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804137:	e8 ce ed ff ff       	call   802f0a <sys_page_unmap>
}
  80413c:	83 c4 14             	add    $0x14,%esp
  80413f:	5b                   	pop    %ebx
  804140:	5d                   	pop    %ebp
  804141:	c3                   	ret    

00804142 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  804142:	55                   	push   %ebp
  804143:	89 e5                	mov    %esp,%ebp
  804145:	57                   	push   %edi
  804146:	56                   	push   %esi
  804147:	53                   	push   %ebx
  804148:	83 ec 2c             	sub    $0x2c,%esp
  80414b:	89 c7                	mov    %eax,%edi
  80414d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  804150:	a1 88 d1 80 00       	mov    0x80d188,%eax
  804155:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  804158:	89 3c 24             	mov    %edi,(%esp)
  80415b:	e8 24 fa ff ff       	call   803b84 <pageref>
  804160:	89 c6                	mov    %eax,%esi
  804162:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804165:	89 04 24             	mov    %eax,(%esp)
  804168:	e8 17 fa ff ff       	call   803b84 <pageref>
  80416d:	39 c6                	cmp    %eax,%esi
  80416f:	0f 94 c0             	sete   %al
  804172:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  804175:	8b 15 88 d1 80 00    	mov    0x80d188,%edx
  80417b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80417e:	39 cb                	cmp    %ecx,%ebx
  804180:	75 08                	jne    80418a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  804182:	83 c4 2c             	add    $0x2c,%esp
  804185:	5b                   	pop    %ebx
  804186:	5e                   	pop    %esi
  804187:	5f                   	pop    %edi
  804188:	5d                   	pop    %ebp
  804189:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80418a:	83 f8 01             	cmp    $0x1,%eax
  80418d:	75 c1                	jne    804150 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80418f:	8b 52 58             	mov    0x58(%edx),%edx
  804192:	89 44 24 0c          	mov    %eax,0xc(%esp)
  804196:	89 54 24 08          	mov    %edx,0x8(%esp)
  80419a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80419e:	c7 04 24 ff 53 80 00 	movl   $0x8053ff,(%esp)
  8041a5:	e8 db df ff ff       	call   802185 <cprintf>
  8041aa:	eb a4                	jmp    804150 <_pipeisclosed+0xe>

008041ac <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8041ac:	55                   	push   %ebp
  8041ad:	89 e5                	mov    %esp,%ebp
  8041af:	57                   	push   %edi
  8041b0:	56                   	push   %esi
  8041b1:	53                   	push   %ebx
  8041b2:	83 ec 1c             	sub    $0x1c,%esp
  8041b5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8041b8:	89 34 24             	mov    %esi,(%esp)
  8041bb:	e8 b0 f0 ff ff       	call   803270 <fd2data>
  8041c0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8041c2:	bf 00 00 00 00       	mov    $0x0,%edi
  8041c7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8041cb:	75 54                	jne    804221 <devpipe_write+0x75>
  8041cd:	eb 60                	jmp    80422f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8041cf:	89 da                	mov    %ebx,%edx
  8041d1:	89 f0                	mov    %esi,%eax
  8041d3:	e8 6a ff ff ff       	call   804142 <_pipeisclosed>
  8041d8:	85 c0                	test   %eax,%eax
  8041da:	74 07                	je     8041e3 <devpipe_write+0x37>
  8041dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8041e1:	eb 53                	jmp    804236 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8041e3:	90                   	nop
  8041e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8041e8:	e8 38 ee ff ff       	call   803025 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8041ed:	8b 43 04             	mov    0x4(%ebx),%eax
  8041f0:	8b 13                	mov    (%ebx),%edx
  8041f2:	83 c2 20             	add    $0x20,%edx
  8041f5:	39 d0                	cmp    %edx,%eax
  8041f7:	73 d6                	jae    8041cf <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8041f9:	89 c2                	mov    %eax,%edx
  8041fb:	c1 fa 1f             	sar    $0x1f,%edx
  8041fe:	c1 ea 1b             	shr    $0x1b,%edx
  804201:	01 d0                	add    %edx,%eax
  804203:	83 e0 1f             	and    $0x1f,%eax
  804206:	29 d0                	sub    %edx,%eax
  804208:	89 c2                	mov    %eax,%edx
  80420a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80420d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  804211:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  804215:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  804219:	83 c7 01             	add    $0x1,%edi
  80421c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80421f:	76 13                	jbe    804234 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  804221:	8b 43 04             	mov    0x4(%ebx),%eax
  804224:	8b 13                	mov    (%ebx),%edx
  804226:	83 c2 20             	add    $0x20,%edx
  804229:	39 d0                	cmp    %edx,%eax
  80422b:	73 a2                	jae    8041cf <devpipe_write+0x23>
  80422d:	eb ca                	jmp    8041f9 <devpipe_write+0x4d>
  80422f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  804234:	89 f8                	mov    %edi,%eax
}
  804236:	83 c4 1c             	add    $0x1c,%esp
  804239:	5b                   	pop    %ebx
  80423a:	5e                   	pop    %esi
  80423b:	5f                   	pop    %edi
  80423c:	5d                   	pop    %ebp
  80423d:	c3                   	ret    

0080423e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80423e:	55                   	push   %ebp
  80423f:	89 e5                	mov    %esp,%ebp
  804241:	83 ec 28             	sub    $0x28,%esp
  804244:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  804247:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80424a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80424d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  804250:	89 3c 24             	mov    %edi,(%esp)
  804253:	e8 18 f0 ff ff       	call   803270 <fd2data>
  804258:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80425a:	be 00 00 00 00       	mov    $0x0,%esi
  80425f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  804263:	75 4c                	jne    8042b1 <devpipe_read+0x73>
  804265:	eb 5b                	jmp    8042c2 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  804267:	89 f0                	mov    %esi,%eax
  804269:	eb 5e                	jmp    8042c9 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80426b:	89 da                	mov    %ebx,%edx
  80426d:	89 f8                	mov    %edi,%eax
  80426f:	90                   	nop
  804270:	e8 cd fe ff ff       	call   804142 <_pipeisclosed>
  804275:	85 c0                	test   %eax,%eax
  804277:	74 07                	je     804280 <devpipe_read+0x42>
  804279:	b8 00 00 00 00       	mov    $0x0,%eax
  80427e:	eb 49                	jmp    8042c9 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  804280:	e8 a0 ed ff ff       	call   803025 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  804285:	8b 03                	mov    (%ebx),%eax
  804287:	3b 43 04             	cmp    0x4(%ebx),%eax
  80428a:	74 df                	je     80426b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80428c:	89 c2                	mov    %eax,%edx
  80428e:	c1 fa 1f             	sar    $0x1f,%edx
  804291:	c1 ea 1b             	shr    $0x1b,%edx
  804294:	01 d0                	add    %edx,%eax
  804296:	83 e0 1f             	and    $0x1f,%eax
  804299:	29 d0                	sub    %edx,%eax
  80429b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8042a0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8042a3:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8042a6:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8042a9:	83 c6 01             	add    $0x1,%esi
  8042ac:	39 75 10             	cmp    %esi,0x10(%ebp)
  8042af:	76 16                	jbe    8042c7 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  8042b1:	8b 03                	mov    (%ebx),%eax
  8042b3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8042b6:	75 d4                	jne    80428c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8042b8:	85 f6                	test   %esi,%esi
  8042ba:	75 ab                	jne    804267 <devpipe_read+0x29>
  8042bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8042c0:	eb a9                	jmp    80426b <devpipe_read+0x2d>
  8042c2:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8042c7:	89 f0                	mov    %esi,%eax
}
  8042c9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8042cc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8042cf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8042d2:	89 ec                	mov    %ebp,%esp
  8042d4:	5d                   	pop    %ebp
  8042d5:	c3                   	ret    

008042d6 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8042d6:	55                   	push   %ebp
  8042d7:	89 e5                	mov    %esp,%ebp
  8042d9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8042dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8042df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8042e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8042e6:	89 04 24             	mov    %eax,(%esp)
  8042e9:	e8 0f f0 ff ff       	call   8032fd <fd_lookup>
  8042ee:	85 c0                	test   %eax,%eax
  8042f0:	78 15                	js     804307 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8042f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8042f5:	89 04 24             	mov    %eax,(%esp)
  8042f8:	e8 73 ef ff ff       	call   803270 <fd2data>
	return _pipeisclosed(fd, p);
  8042fd:	89 c2                	mov    %eax,%edx
  8042ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804302:	e8 3b fe ff ff       	call   804142 <_pipeisclosed>
}
  804307:	c9                   	leave  
  804308:	c3                   	ret    

00804309 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  804309:	55                   	push   %ebp
  80430a:	89 e5                	mov    %esp,%ebp
  80430c:	83 ec 48             	sub    $0x48,%esp
  80430f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  804312:	89 75 f8             	mov    %esi,-0x8(%ebp)
  804315:	89 7d fc             	mov    %edi,-0x4(%ebp)
  804318:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80431b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80431e:	89 04 24             	mov    %eax,(%esp)
  804321:	e8 65 ef ff ff       	call   80328b <fd_alloc>
  804326:	89 c3                	mov    %eax,%ebx
  804328:	85 c0                	test   %eax,%eax
  80432a:	0f 88 42 01 00 00    	js     804472 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  804330:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  804337:	00 
  804338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80433b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80433f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804346:	e8 7b ec ff ff       	call   802fc6 <sys_page_alloc>
  80434b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80434d:	85 c0                	test   %eax,%eax
  80434f:	0f 88 1d 01 00 00    	js     804472 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804355:	8d 45 e0             	lea    -0x20(%ebp),%eax
  804358:	89 04 24             	mov    %eax,(%esp)
  80435b:	e8 2b ef ff ff       	call   80328b <fd_alloc>
  804360:	89 c3                	mov    %eax,%ebx
  804362:	85 c0                	test   %eax,%eax
  804364:	0f 88 f5 00 00 00    	js     80445f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80436a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  804371:	00 
  804372:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804375:	89 44 24 04          	mov    %eax,0x4(%esp)
  804379:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804380:	e8 41 ec ff ff       	call   802fc6 <sys_page_alloc>
  804385:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  804387:	85 c0                	test   %eax,%eax
  804389:	0f 88 d0 00 00 00    	js     80445f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80438f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804392:	89 04 24             	mov    %eax,(%esp)
  804395:	e8 d6 ee ff ff       	call   803270 <fd2data>
  80439a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80439c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8043a3:	00 
  8043a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8043a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8043af:	e8 12 ec ff ff       	call   802fc6 <sys_page_alloc>
  8043b4:	89 c3                	mov    %eax,%ebx
  8043b6:	85 c0                	test   %eax,%eax
  8043b8:	0f 88 8e 00 00 00    	js     80444c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8043be:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8043c1:	89 04 24             	mov    %eax,(%esp)
  8043c4:	e8 a7 ee ff ff       	call   803270 <fd2data>
  8043c9:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8043d0:	00 
  8043d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8043d5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8043dc:	00 
  8043dd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8043e1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8043e8:	e8 7b eb ff ff       	call   802f68 <sys_page_map>
  8043ed:	89 c3                	mov    %eax,%ebx
  8043ef:	85 c0                	test   %eax,%eax
  8043f1:	78 49                	js     80443c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8043f3:	b8 a0 d0 80 00       	mov    $0x80d0a0,%eax
  8043f8:	8b 08                	mov    (%eax),%ecx
  8043fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8043fd:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8043ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804402:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  804409:	8b 10                	mov    (%eax),%edx
  80440b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80440e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  804410:	8b 45 e0             	mov    -0x20(%ebp),%eax
  804413:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80441a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80441d:	89 04 24             	mov    %eax,(%esp)
  804420:	e8 3b ee ff ff       	call   803260 <fd2num>
  804425:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  804427:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80442a:	89 04 24             	mov    %eax,(%esp)
  80442d:	e8 2e ee ff ff       	call   803260 <fd2num>
  804432:	89 47 04             	mov    %eax,0x4(%edi)
  804435:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80443a:	eb 36                	jmp    804472 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80443c:	89 74 24 04          	mov    %esi,0x4(%esp)
  804440:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804447:	e8 be ea ff ff       	call   802f0a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80444c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80444f:	89 44 24 04          	mov    %eax,0x4(%esp)
  804453:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80445a:	e8 ab ea ff ff       	call   802f0a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80445f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804462:	89 44 24 04          	mov    %eax,0x4(%esp)
  804466:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80446d:	e8 98 ea ff ff       	call   802f0a <sys_page_unmap>
    err:
	return r;
}
  804472:	89 d8                	mov    %ebx,%eax
  804474:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  804477:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80447a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80447d:	89 ec                	mov    %ebp,%esp
  80447f:	5d                   	pop    %ebp
  804480:	c3                   	ret    
	...

00804490 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  804490:	55                   	push   %ebp
  804491:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  804493:	b8 00 00 00 00       	mov    $0x0,%eax
  804498:	5d                   	pop    %ebp
  804499:	c3                   	ret    

0080449a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80449a:	55                   	push   %ebp
  80449b:	89 e5                	mov    %esp,%ebp
  80449d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8044a0:	c7 44 24 04 17 54 80 	movl   $0x805417,0x4(%esp)
  8044a7:	00 
  8044a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8044ab:	89 04 24             	mov    %eax,(%esp)
  8044ae:	e8 b7 e3 ff ff       	call   80286a <strcpy>
	return 0;
}
  8044b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8044b8:	c9                   	leave  
  8044b9:	c3                   	ret    

008044ba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8044ba:	55                   	push   %ebp
  8044bb:	89 e5                	mov    %esp,%ebp
  8044bd:	57                   	push   %edi
  8044be:	56                   	push   %esi
  8044bf:	53                   	push   %ebx
  8044c0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8044c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8044cb:	be 00 00 00 00       	mov    $0x0,%esi
  8044d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8044d4:	74 3f                	je     804515 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8044d6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8044dc:	8b 55 10             	mov    0x10(%ebp),%edx
  8044df:	29 c2                	sub    %eax,%edx
  8044e1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  8044e3:	83 fa 7f             	cmp    $0x7f,%edx
  8044e6:	76 05                	jbe    8044ed <devcons_write+0x33>
  8044e8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8044ed:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8044f1:	03 45 0c             	add    0xc(%ebp),%eax
  8044f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8044f8:	89 3c 24             	mov    %edi,(%esp)
  8044fb:	e8 25 e5 ff ff       	call   802a25 <memmove>
		sys_cputs(buf, m);
  804500:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  804504:	89 3c 24             	mov    %edi,(%esp)
  804507:	e8 54 e7 ff ff       	call   802c60 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80450c:	01 de                	add    %ebx,%esi
  80450e:	89 f0                	mov    %esi,%eax
  804510:	3b 75 10             	cmp    0x10(%ebp),%esi
  804513:	72 c7                	jb     8044dc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  804515:	89 f0                	mov    %esi,%eax
  804517:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80451d:	5b                   	pop    %ebx
  80451e:	5e                   	pop    %esi
  80451f:	5f                   	pop    %edi
  804520:	5d                   	pop    %ebp
  804521:	c3                   	ret    

00804522 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  804522:	55                   	push   %ebp
  804523:	89 e5                	mov    %esp,%ebp
  804525:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  804528:	8b 45 08             	mov    0x8(%ebp),%eax
  80452b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80452e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  804535:	00 
  804536:	8d 45 f7             	lea    -0x9(%ebp),%eax
  804539:	89 04 24             	mov    %eax,(%esp)
  80453c:	e8 1f e7 ff ff       	call   802c60 <sys_cputs>
}
  804541:	c9                   	leave  
  804542:	c3                   	ret    

00804543 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  804543:	55                   	push   %ebp
  804544:	89 e5                	mov    %esp,%ebp
  804546:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  804549:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80454d:	75 07                	jne    804556 <devcons_read+0x13>
  80454f:	eb 28                	jmp    804579 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  804551:	e8 cf ea ff ff       	call   803025 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  804556:	66 90                	xchg   %ax,%ax
  804558:	e8 cf e6 ff ff       	call   802c2c <sys_cgetc>
  80455d:	85 c0                	test   %eax,%eax
  80455f:	90                   	nop
  804560:	74 ef                	je     804551 <devcons_read+0xe>
  804562:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  804564:	85 c0                	test   %eax,%eax
  804566:	78 16                	js     80457e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  804568:	83 f8 04             	cmp    $0x4,%eax
  80456b:	74 0c                	je     804579 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80456d:	8b 45 0c             	mov    0xc(%ebp),%eax
  804570:	88 10                	mov    %dl,(%eax)
  804572:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  804577:	eb 05                	jmp    80457e <devcons_read+0x3b>
  804579:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80457e:	c9                   	leave  
  80457f:	c3                   	ret    

00804580 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  804580:	55                   	push   %ebp
  804581:	89 e5                	mov    %esp,%ebp
  804583:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  804586:	8d 45 f4             	lea    -0xc(%ebp),%eax
  804589:	89 04 24             	mov    %eax,(%esp)
  80458c:	e8 fa ec ff ff       	call   80328b <fd_alloc>
  804591:	85 c0                	test   %eax,%eax
  804593:	78 3f                	js     8045d4 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  804595:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80459c:	00 
  80459d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8045a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8045ab:	e8 16 ea ff ff       	call   802fc6 <sys_page_alloc>
  8045b0:	85 c0                	test   %eax,%eax
  8045b2:	78 20                	js     8045d4 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8045b4:	8b 15 bc d0 80 00    	mov    0x80d0bc,%edx
  8045ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045bd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8045bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045c2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8045c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045cc:	89 04 24             	mov    %eax,(%esp)
  8045cf:	e8 8c ec ff ff       	call   803260 <fd2num>
}
  8045d4:	c9                   	leave  
  8045d5:	c3                   	ret    

008045d6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8045d6:	55                   	push   %ebp
  8045d7:	89 e5                	mov    %esp,%ebp
  8045d9:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8045dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8045df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8045e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8045e6:	89 04 24             	mov    %eax,(%esp)
  8045e9:	e8 0f ed ff ff       	call   8032fd <fd_lookup>
  8045ee:	85 c0                	test   %eax,%eax
  8045f0:	78 11                	js     804603 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8045f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8045f5:	8b 00                	mov    (%eax),%eax
  8045f7:	3b 05 bc d0 80 00    	cmp    0x80d0bc,%eax
  8045fd:	0f 94 c0             	sete   %al
  804600:	0f b6 c0             	movzbl %al,%eax
}
  804603:	c9                   	leave  
  804604:	c3                   	ret    

00804605 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  804605:	55                   	push   %ebp
  804606:	89 e5                	mov    %esp,%ebp
  804608:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80460b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  804612:	00 
  804613:	8d 45 f7             	lea    -0x9(%ebp),%eax
  804616:	89 44 24 04          	mov    %eax,0x4(%esp)
  80461a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  804621:	e8 38 ef ff ff       	call   80355e <read>
	if (r < 0)
  804626:	85 c0                	test   %eax,%eax
  804628:	78 0f                	js     804639 <getchar+0x34>
		return r;
	if (r < 1)
  80462a:	85 c0                	test   %eax,%eax
  80462c:	7f 07                	jg     804635 <getchar+0x30>
  80462e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  804633:	eb 04                	jmp    804639 <getchar+0x34>
		return -E_EOF;
	return c;
  804635:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  804639:	c9                   	leave  
  80463a:	c3                   	ret    
  80463b:	00 00                	add    %al,(%eax)
  80463d:	00 00                	add    %al,(%eax)
	...

00804640 <__udivdi3>:
  804640:	55                   	push   %ebp
  804641:	89 e5                	mov    %esp,%ebp
  804643:	57                   	push   %edi
  804644:	56                   	push   %esi
  804645:	83 ec 10             	sub    $0x10,%esp
  804648:	8b 45 14             	mov    0x14(%ebp),%eax
  80464b:	8b 55 08             	mov    0x8(%ebp),%edx
  80464e:	8b 75 10             	mov    0x10(%ebp),%esi
  804651:	8b 7d 0c             	mov    0xc(%ebp),%edi
  804654:	85 c0                	test   %eax,%eax
  804656:	89 55 f0             	mov    %edx,-0x10(%ebp)
  804659:	75 35                	jne    804690 <__udivdi3+0x50>
  80465b:	39 fe                	cmp    %edi,%esi
  80465d:	77 61                	ja     8046c0 <__udivdi3+0x80>
  80465f:	85 f6                	test   %esi,%esi
  804661:	75 0b                	jne    80466e <__udivdi3+0x2e>
  804663:	b8 01 00 00 00       	mov    $0x1,%eax
  804668:	31 d2                	xor    %edx,%edx
  80466a:	f7 f6                	div    %esi
  80466c:	89 c6                	mov    %eax,%esi
  80466e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  804671:	31 d2                	xor    %edx,%edx
  804673:	89 f8                	mov    %edi,%eax
  804675:	f7 f6                	div    %esi
  804677:	89 c7                	mov    %eax,%edi
  804679:	89 c8                	mov    %ecx,%eax
  80467b:	f7 f6                	div    %esi
  80467d:	89 c1                	mov    %eax,%ecx
  80467f:	89 fa                	mov    %edi,%edx
  804681:	89 c8                	mov    %ecx,%eax
  804683:	83 c4 10             	add    $0x10,%esp
  804686:	5e                   	pop    %esi
  804687:	5f                   	pop    %edi
  804688:	5d                   	pop    %ebp
  804689:	c3                   	ret    
  80468a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  804690:	39 f8                	cmp    %edi,%eax
  804692:	77 1c                	ja     8046b0 <__udivdi3+0x70>
  804694:	0f bd d0             	bsr    %eax,%edx
  804697:	83 f2 1f             	xor    $0x1f,%edx
  80469a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80469d:	75 39                	jne    8046d8 <__udivdi3+0x98>
  80469f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8046a2:	0f 86 a0 00 00 00    	jbe    804748 <__udivdi3+0x108>
  8046a8:	39 f8                	cmp    %edi,%eax
  8046aa:	0f 82 98 00 00 00    	jb     804748 <__udivdi3+0x108>
  8046b0:	31 ff                	xor    %edi,%edi
  8046b2:	31 c9                	xor    %ecx,%ecx
  8046b4:	89 c8                	mov    %ecx,%eax
  8046b6:	89 fa                	mov    %edi,%edx
  8046b8:	83 c4 10             	add    $0x10,%esp
  8046bb:	5e                   	pop    %esi
  8046bc:	5f                   	pop    %edi
  8046bd:	5d                   	pop    %ebp
  8046be:	c3                   	ret    
  8046bf:	90                   	nop
  8046c0:	89 d1                	mov    %edx,%ecx
  8046c2:	89 fa                	mov    %edi,%edx
  8046c4:	89 c8                	mov    %ecx,%eax
  8046c6:	31 ff                	xor    %edi,%edi
  8046c8:	f7 f6                	div    %esi
  8046ca:	89 c1                	mov    %eax,%ecx
  8046cc:	89 fa                	mov    %edi,%edx
  8046ce:	89 c8                	mov    %ecx,%eax
  8046d0:	83 c4 10             	add    $0x10,%esp
  8046d3:	5e                   	pop    %esi
  8046d4:	5f                   	pop    %edi
  8046d5:	5d                   	pop    %ebp
  8046d6:	c3                   	ret    
  8046d7:	90                   	nop
  8046d8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8046dc:	89 f2                	mov    %esi,%edx
  8046de:	d3 e0                	shl    %cl,%eax
  8046e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8046e3:	b8 20 00 00 00       	mov    $0x20,%eax
  8046e8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8046eb:	89 c1                	mov    %eax,%ecx
  8046ed:	d3 ea                	shr    %cl,%edx
  8046ef:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8046f3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8046f6:	d3 e6                	shl    %cl,%esi
  8046f8:	89 c1                	mov    %eax,%ecx
  8046fa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8046fd:	89 fe                	mov    %edi,%esi
  8046ff:	d3 ee                	shr    %cl,%esi
  804701:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  804705:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804708:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80470b:	d3 e7                	shl    %cl,%edi
  80470d:	89 c1                	mov    %eax,%ecx
  80470f:	d3 ea                	shr    %cl,%edx
  804711:	09 d7                	or     %edx,%edi
  804713:	89 f2                	mov    %esi,%edx
  804715:	89 f8                	mov    %edi,%eax
  804717:	f7 75 ec             	divl   -0x14(%ebp)
  80471a:	89 d6                	mov    %edx,%esi
  80471c:	89 c7                	mov    %eax,%edi
  80471e:	f7 65 e8             	mull   -0x18(%ebp)
  804721:	39 d6                	cmp    %edx,%esi
  804723:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804726:	72 30                	jb     804758 <__udivdi3+0x118>
  804728:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80472b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80472f:	d3 e2                	shl    %cl,%edx
  804731:	39 c2                	cmp    %eax,%edx
  804733:	73 05                	jae    80473a <__udivdi3+0xfa>
  804735:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  804738:	74 1e                	je     804758 <__udivdi3+0x118>
  80473a:	89 f9                	mov    %edi,%ecx
  80473c:	31 ff                	xor    %edi,%edi
  80473e:	e9 71 ff ff ff       	jmp    8046b4 <__udivdi3+0x74>
  804743:	90                   	nop
  804744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804748:	31 ff                	xor    %edi,%edi
  80474a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80474f:	e9 60 ff ff ff       	jmp    8046b4 <__udivdi3+0x74>
  804754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804758:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80475b:	31 ff                	xor    %edi,%edi
  80475d:	89 c8                	mov    %ecx,%eax
  80475f:	89 fa                	mov    %edi,%edx
  804761:	83 c4 10             	add    $0x10,%esp
  804764:	5e                   	pop    %esi
  804765:	5f                   	pop    %edi
  804766:	5d                   	pop    %ebp
  804767:	c3                   	ret    
	...

00804770 <__umoddi3>:
  804770:	55                   	push   %ebp
  804771:	89 e5                	mov    %esp,%ebp
  804773:	57                   	push   %edi
  804774:	56                   	push   %esi
  804775:	83 ec 20             	sub    $0x20,%esp
  804778:	8b 55 14             	mov    0x14(%ebp),%edx
  80477b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80477e:	8b 7d 10             	mov    0x10(%ebp),%edi
  804781:	8b 75 0c             	mov    0xc(%ebp),%esi
  804784:	85 d2                	test   %edx,%edx
  804786:	89 c8                	mov    %ecx,%eax
  804788:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80478b:	75 13                	jne    8047a0 <__umoddi3+0x30>
  80478d:	39 f7                	cmp    %esi,%edi
  80478f:	76 3f                	jbe    8047d0 <__umoddi3+0x60>
  804791:	89 f2                	mov    %esi,%edx
  804793:	f7 f7                	div    %edi
  804795:	89 d0                	mov    %edx,%eax
  804797:	31 d2                	xor    %edx,%edx
  804799:	83 c4 20             	add    $0x20,%esp
  80479c:	5e                   	pop    %esi
  80479d:	5f                   	pop    %edi
  80479e:	5d                   	pop    %ebp
  80479f:	c3                   	ret    
  8047a0:	39 f2                	cmp    %esi,%edx
  8047a2:	77 4c                	ja     8047f0 <__umoddi3+0x80>
  8047a4:	0f bd ca             	bsr    %edx,%ecx
  8047a7:	83 f1 1f             	xor    $0x1f,%ecx
  8047aa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8047ad:	75 51                	jne    804800 <__umoddi3+0x90>
  8047af:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8047b2:	0f 87 e0 00 00 00    	ja     804898 <__umoddi3+0x128>
  8047b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8047bb:	29 f8                	sub    %edi,%eax
  8047bd:	19 d6                	sbb    %edx,%esi
  8047bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8047c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8047c5:	89 f2                	mov    %esi,%edx
  8047c7:	83 c4 20             	add    $0x20,%esp
  8047ca:	5e                   	pop    %esi
  8047cb:	5f                   	pop    %edi
  8047cc:	5d                   	pop    %ebp
  8047cd:	c3                   	ret    
  8047ce:	66 90                	xchg   %ax,%ax
  8047d0:	85 ff                	test   %edi,%edi
  8047d2:	75 0b                	jne    8047df <__umoddi3+0x6f>
  8047d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8047d9:	31 d2                	xor    %edx,%edx
  8047db:	f7 f7                	div    %edi
  8047dd:	89 c7                	mov    %eax,%edi
  8047df:	89 f0                	mov    %esi,%eax
  8047e1:	31 d2                	xor    %edx,%edx
  8047e3:	f7 f7                	div    %edi
  8047e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8047e8:	f7 f7                	div    %edi
  8047ea:	eb a9                	jmp    804795 <__umoddi3+0x25>
  8047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8047f0:	89 c8                	mov    %ecx,%eax
  8047f2:	89 f2                	mov    %esi,%edx
  8047f4:	83 c4 20             	add    $0x20,%esp
  8047f7:	5e                   	pop    %esi
  8047f8:	5f                   	pop    %edi
  8047f9:	5d                   	pop    %ebp
  8047fa:	c3                   	ret    
  8047fb:	90                   	nop
  8047fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804800:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804804:	d3 e2                	shl    %cl,%edx
  804806:	89 55 f4             	mov    %edx,-0xc(%ebp)
  804809:	ba 20 00 00 00       	mov    $0x20,%edx
  80480e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  804811:	89 55 ec             	mov    %edx,-0x14(%ebp)
  804814:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804818:	89 fa                	mov    %edi,%edx
  80481a:	d3 ea                	shr    %cl,%edx
  80481c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804820:	0b 55 f4             	or     -0xc(%ebp),%edx
  804823:	d3 e7                	shl    %cl,%edi
  804825:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804829:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80482c:	89 f2                	mov    %esi,%edx
  80482e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  804831:	89 c7                	mov    %eax,%edi
  804833:	d3 ea                	shr    %cl,%edx
  804835:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804839:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80483c:	89 c2                	mov    %eax,%edx
  80483e:	d3 e6                	shl    %cl,%esi
  804840:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804844:	d3 ea                	shr    %cl,%edx
  804846:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80484a:	09 d6                	or     %edx,%esi
  80484c:	89 f0                	mov    %esi,%eax
  80484e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  804851:	d3 e7                	shl    %cl,%edi
  804853:	89 f2                	mov    %esi,%edx
  804855:	f7 75 f4             	divl   -0xc(%ebp)
  804858:	89 d6                	mov    %edx,%esi
  80485a:	f7 65 e8             	mull   -0x18(%ebp)
  80485d:	39 d6                	cmp    %edx,%esi
  80485f:	72 2b                	jb     80488c <__umoddi3+0x11c>
  804861:	39 c7                	cmp    %eax,%edi
  804863:	72 23                	jb     804888 <__umoddi3+0x118>
  804865:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  804869:	29 c7                	sub    %eax,%edi
  80486b:	19 d6                	sbb    %edx,%esi
  80486d:	89 f0                	mov    %esi,%eax
  80486f:	89 f2                	mov    %esi,%edx
  804871:	d3 ef                	shr    %cl,%edi
  804873:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  804877:	d3 e0                	shl    %cl,%eax
  804879:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80487d:	09 f8                	or     %edi,%eax
  80487f:	d3 ea                	shr    %cl,%edx
  804881:	83 c4 20             	add    $0x20,%esp
  804884:	5e                   	pop    %esi
  804885:	5f                   	pop    %edi
  804886:	5d                   	pop    %ebp
  804887:	c3                   	ret    
  804888:	39 d6                	cmp    %edx,%esi
  80488a:	75 d9                	jne    804865 <__umoddi3+0xf5>
  80488c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80488f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  804892:	eb d1                	jmp    804865 <__umoddi3+0xf5>
  804894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  804898:	39 f2                	cmp    %esi,%edx
  80489a:	0f 82 18 ff ff ff    	jb     8047b8 <__umoddi3+0x48>
  8048a0:	e9 1d ff ff ff       	jmp    8047c2 <__umoddi3+0x52>
