
obj/user/pingpong:     file format elf32-i386


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
  80002c:	e8 c7 00 00 00       	call   8000f8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

#include <inc/lib.h>

void
umain(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
	envid_t who;

	if ((who = fork()) != 0) {
  80003d:	e8 45 12 00 00       	call   801287 <fork>
  800042:	89 c3                	mov    %eax,%ebx
  800044:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800047:	85 c0                	test   %eax,%eax
  800049:	74 3c                	je     800087 <umain+0x53>
		// get the ball rolling
		cprintf("send 0 from %x to %x\n", sys_getenvid(), who);
  80004b:	e8 49 10 00 00       	call   801099 <sys_getenvid>
  800050:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800054:	89 44 24 04          	mov    %eax,0x4(%esp)
  800058:	c7 04 24 00 2d 80 00 	movl   $0x802d00,(%esp)
  80005f:	e8 61 01 00 00       	call   8001c5 <cprintf>
		ipc_send(who, 0, 0, 0);
  800064:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80006b:	00 
  80006c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800073:	00 
  800074:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007b:	00 
  80007c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80007f:	89 04 24             	mov    %eax,(%esp)
  800082:	e8 39 14 00 00       	call   8014c0 <ipc_send>
	}

	while (1) {
		uint32_t i = ipc_recv(&who, 0, 0);
  800087:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  80008a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800091:	00 
  800092:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800099:	00 
  80009a:	89 3c 24             	mov    %edi,(%esp)
  80009d:	e8 80 14 00 00       	call   801522 <ipc_recv>
  8000a2:	89 c3                	mov    %eax,%ebx
		cprintf("%x got %d from %x\n", sys_getenvid(), i, who);
  8000a4:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8000a7:	e8 ed 0f 00 00       	call   801099 <sys_getenvid>
  8000ac:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8000b0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8000b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b8:	c7 04 24 16 2d 80 00 	movl   $0x802d16,(%esp)
  8000bf:	e8 01 01 00 00       	call   8001c5 <cprintf>
		if (i == 10)
  8000c4:	83 fb 0a             	cmp    $0xa,%ebx
  8000c7:	74 27                	je     8000f0 <umain+0xbc>
			return;
		i++;
  8000c9:	83 c3 01             	add    $0x1,%ebx
		ipc_send(who, i, 0, 0);
  8000cc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000d3:	00 
  8000d4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000db:	00 
  8000dc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000e3:	89 04 24             	mov    %eax,(%esp)
  8000e6:	e8 d5 13 00 00       	call   8014c0 <ipc_send>
		if (i == 10)
  8000eb:	83 fb 0a             	cmp    $0xa,%ebx
  8000ee:	75 9a                	jne    80008a <umain+0x56>
			return;
	}
		
}
  8000f0:	83 c4 2c             	add    $0x2c,%esp
  8000f3:	5b                   	pop    %ebx
  8000f4:	5e                   	pop    %esi
  8000f5:	5f                   	pop    %edi
  8000f6:	5d                   	pop    %ebp
  8000f7:	c3                   	ret    

008000f8 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	83 ec 18             	sub    $0x18,%esp
  8000fe:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800101:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800104:	8b 75 08             	mov    0x8(%ebp),%esi
  800107:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  80010a:	e8 8a 0f 00 00       	call   801099 <sys_getenvid>
  80010f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800114:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800117:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80011c:	a3 74 70 80 00       	mov    %eax,0x807074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800121:	85 f6                	test   %esi,%esi
  800123:	7e 07                	jle    80012c <libmain+0x34>
		binaryname = argv[0];
  800125:	8b 03                	mov    (%ebx),%eax
  800127:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  80012c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800130:	89 34 24             	mov    %esi,(%esp)
  800133:	e8 fc fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800138:	e8 0b 00 00 00       	call   800148 <exit>
}
  80013d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800140:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800143:	89 ec                	mov    %ebp,%esp
  800145:	5d                   	pop    %ebp
  800146:	c3                   	ret    
	...

00800148 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80014e:	e8 18 19 00 00       	call   801a6b <close_all>
	sys_env_destroy(0);
  800153:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80015a:	e8 6e 0f 00 00       	call   8010cd <sys_env_destroy>
}
  80015f:	c9                   	leave  
  800160:	c3                   	ret    
  800161:	00 00                	add    %al,(%eax)
	...

00800164 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80016d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800174:	00 00 00 
	b.cnt = 0;
  800177:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80017e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800181:	8b 45 0c             	mov    0xc(%ebp),%eax
  800184:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800188:	8b 45 08             	mov    0x8(%ebp),%eax
  80018b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80018f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800195:	89 44 24 04          	mov    %eax,0x4(%esp)
  800199:	c7 04 24 df 01 80 00 	movl   $0x8001df,(%esp)
  8001a0:	e8 d8 01 00 00       	call   80037d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001a5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8001ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001af:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001b5:	89 04 24             	mov    %eax,(%esp)
  8001b8:	e8 e3 0a 00 00       	call   800ca0 <sys_cputs>

	return b.cnt;
}
  8001bd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001c3:	c9                   	leave  
  8001c4:	c3                   	ret    

008001c5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001c5:	55                   	push   %ebp
  8001c6:	89 e5                	mov    %esp,%ebp
  8001c8:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8001cb:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8001ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d5:	89 04 24             	mov    %eax,(%esp)
  8001d8:	e8 87 ff ff ff       	call   800164 <vcprintf>
	va_end(ap);

	return cnt;
}
  8001dd:	c9                   	leave  
  8001de:	c3                   	ret    

008001df <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001df:	55                   	push   %ebp
  8001e0:	89 e5                	mov    %esp,%ebp
  8001e2:	53                   	push   %ebx
  8001e3:	83 ec 14             	sub    $0x14,%esp
  8001e6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001e9:	8b 03                	mov    (%ebx),%eax
  8001eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ee:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8001f2:	83 c0 01             	add    $0x1,%eax
  8001f5:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8001f7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001fc:	75 19                	jne    800217 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8001fe:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800205:	00 
  800206:	8d 43 08             	lea    0x8(%ebx),%eax
  800209:	89 04 24             	mov    %eax,(%esp)
  80020c:	e8 8f 0a 00 00       	call   800ca0 <sys_cputs>
		b->idx = 0;
  800211:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800217:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80021b:	83 c4 14             	add    $0x14,%esp
  80021e:	5b                   	pop    %ebx
  80021f:	5d                   	pop    %ebp
  800220:	c3                   	ret    
	...

00800230 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
  800233:	57                   	push   %edi
  800234:	56                   	push   %esi
  800235:	53                   	push   %ebx
  800236:	83 ec 4c             	sub    $0x4c,%esp
  800239:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80023c:	89 d6                	mov    %edx,%esi
  80023e:	8b 45 08             	mov    0x8(%ebp),%eax
  800241:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800244:	8b 55 0c             	mov    0xc(%ebp),%edx
  800247:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80024a:	8b 45 10             	mov    0x10(%ebp),%eax
  80024d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800250:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800253:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800256:	b9 00 00 00 00       	mov    $0x0,%ecx
  80025b:	39 d1                	cmp    %edx,%ecx
  80025d:	72 15                	jb     800274 <printnum+0x44>
  80025f:	77 07                	ja     800268 <printnum+0x38>
  800261:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800264:	39 d0                	cmp    %edx,%eax
  800266:	76 0c                	jbe    800274 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800268:	83 eb 01             	sub    $0x1,%ebx
  80026b:	85 db                	test   %ebx,%ebx
  80026d:	8d 76 00             	lea    0x0(%esi),%esi
  800270:	7f 61                	jg     8002d3 <printnum+0xa3>
  800272:	eb 70                	jmp    8002e4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800274:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800278:	83 eb 01             	sub    $0x1,%ebx
  80027b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80027f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800283:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800287:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80028b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80028e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800291:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800294:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800298:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80029f:	00 
  8002a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8002a3:	89 04 24             	mov    %eax,(%esp)
  8002a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002ad:	e8 ce 27 00 00       	call   802a80 <__udivdi3>
  8002b2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8002b5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8002b8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8002bc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8002c0:	89 04 24             	mov    %eax,(%esp)
  8002c3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8002c7:	89 f2                	mov    %esi,%edx
  8002c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8002cc:	e8 5f ff ff ff       	call   800230 <printnum>
  8002d1:	eb 11                	jmp    8002e4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002d3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002d7:	89 3c 24             	mov    %edi,(%esp)
  8002da:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8002dd:	83 eb 01             	sub    $0x1,%ebx
  8002e0:	85 db                	test   %ebx,%ebx
  8002e2:	7f ef                	jg     8002d3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002e4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002e8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8002ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8002ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8002fa:	00 
  8002fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8002fe:	89 14 24             	mov    %edx,(%esp)
  800301:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800304:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800308:	e8 a3 28 00 00       	call   802bb0 <__umoddi3>
  80030d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800311:	0f be 80 40 2d 80 00 	movsbl 0x802d40(%eax),%eax
  800318:	89 04 24             	mov    %eax,(%esp)
  80031b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80031e:	83 c4 4c             	add    $0x4c,%esp
  800321:	5b                   	pop    %ebx
  800322:	5e                   	pop    %esi
  800323:	5f                   	pop    %edi
  800324:	5d                   	pop    %ebp
  800325:	c3                   	ret    

00800326 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800329:	83 fa 01             	cmp    $0x1,%edx
  80032c:	7e 0e                	jle    80033c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80032e:	8b 10                	mov    (%eax),%edx
  800330:	8d 4a 08             	lea    0x8(%edx),%ecx
  800333:	89 08                	mov    %ecx,(%eax)
  800335:	8b 02                	mov    (%edx),%eax
  800337:	8b 52 04             	mov    0x4(%edx),%edx
  80033a:	eb 22                	jmp    80035e <getuint+0x38>
	else if (lflag)
  80033c:	85 d2                	test   %edx,%edx
  80033e:	74 10                	je     800350 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800340:	8b 10                	mov    (%eax),%edx
  800342:	8d 4a 04             	lea    0x4(%edx),%ecx
  800345:	89 08                	mov    %ecx,(%eax)
  800347:	8b 02                	mov    (%edx),%eax
  800349:	ba 00 00 00 00       	mov    $0x0,%edx
  80034e:	eb 0e                	jmp    80035e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800350:	8b 10                	mov    (%eax),%edx
  800352:	8d 4a 04             	lea    0x4(%edx),%ecx
  800355:	89 08                	mov    %ecx,(%eax)
  800357:	8b 02                	mov    (%edx),%eax
  800359:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80035e:	5d                   	pop    %ebp
  80035f:	c3                   	ret    

00800360 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800366:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80036a:	8b 10                	mov    (%eax),%edx
  80036c:	3b 50 04             	cmp    0x4(%eax),%edx
  80036f:	73 0a                	jae    80037b <sprintputch+0x1b>
		*b->buf++ = ch;
  800371:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800374:	88 0a                	mov    %cl,(%edx)
  800376:	83 c2 01             	add    $0x1,%edx
  800379:	89 10                	mov    %edx,(%eax)
}
  80037b:	5d                   	pop    %ebp
  80037c:	c3                   	ret    

0080037d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80037d:	55                   	push   %ebp
  80037e:	89 e5                	mov    %esp,%ebp
  800380:	57                   	push   %edi
  800381:	56                   	push   %esi
  800382:	53                   	push   %ebx
  800383:	83 ec 5c             	sub    $0x5c,%esp
  800386:	8b 7d 08             	mov    0x8(%ebp),%edi
  800389:	8b 75 0c             	mov    0xc(%ebp),%esi
  80038c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80038f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800396:	eb 11                	jmp    8003a9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800398:	85 c0                	test   %eax,%eax
  80039a:	0f 84 09 04 00 00    	je     8007a9 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  8003a0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003a4:	89 04 24             	mov    %eax,(%esp)
  8003a7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8003a9:	0f b6 03             	movzbl (%ebx),%eax
  8003ac:	83 c3 01             	add    $0x1,%ebx
  8003af:	83 f8 25             	cmp    $0x25,%eax
  8003b2:	75 e4                	jne    800398 <vprintfmt+0x1b>
  8003b4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8003b8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8003bf:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8003c6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8003cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003d2:	eb 06                	jmp    8003da <vprintfmt+0x5d>
  8003d4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8003d8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8003da:	0f b6 13             	movzbl (%ebx),%edx
  8003dd:	0f b6 c2             	movzbl %dl,%eax
  8003e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003e3:	8d 43 01             	lea    0x1(%ebx),%eax
  8003e6:	83 ea 23             	sub    $0x23,%edx
  8003e9:	80 fa 55             	cmp    $0x55,%dl
  8003ec:	0f 87 9a 03 00 00    	ja     80078c <vprintfmt+0x40f>
  8003f2:	0f b6 d2             	movzbl %dl,%edx
  8003f5:	ff 24 95 80 2e 80 00 	jmp    *0x802e80(,%edx,4)
  8003fc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800400:	eb d6                	jmp    8003d8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800402:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800405:	83 ea 30             	sub    $0x30,%edx
  800408:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  80040b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80040e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800411:	83 fb 09             	cmp    $0x9,%ebx
  800414:	77 4c                	ja     800462 <vprintfmt+0xe5>
  800416:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800419:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80041c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80041f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800422:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800426:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800429:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80042c:	83 fb 09             	cmp    $0x9,%ebx
  80042f:	76 eb                	jbe    80041c <vprintfmt+0x9f>
  800431:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800434:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800437:	eb 29                	jmp    800462 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800439:	8b 55 14             	mov    0x14(%ebp),%edx
  80043c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80043f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800442:	8b 12                	mov    (%edx),%edx
  800444:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  800447:	eb 19                	jmp    800462 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800449:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80044c:	c1 fa 1f             	sar    $0x1f,%edx
  80044f:	f7 d2                	not    %edx
  800451:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800454:	eb 82                	jmp    8003d8 <vprintfmt+0x5b>
  800456:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80045d:	e9 76 ff ff ff       	jmp    8003d8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800462:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800466:	0f 89 6c ff ff ff    	jns    8003d8 <vprintfmt+0x5b>
  80046c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80046f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800472:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800475:	89 55 cc             	mov    %edx,-0x34(%ebp)
  800478:	e9 5b ff ff ff       	jmp    8003d8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80047d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800480:	e9 53 ff ff ff       	jmp    8003d8 <vprintfmt+0x5b>
  800485:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800488:	8b 45 14             	mov    0x14(%ebp),%eax
  80048b:	8d 50 04             	lea    0x4(%eax),%edx
  80048e:	89 55 14             	mov    %edx,0x14(%ebp)
  800491:	89 74 24 04          	mov    %esi,0x4(%esp)
  800495:	8b 00                	mov    (%eax),%eax
  800497:	89 04 24             	mov    %eax,(%esp)
  80049a:	ff d7                	call   *%edi
  80049c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80049f:	e9 05 ff ff ff       	jmp    8003a9 <vprintfmt+0x2c>
  8004a4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8004a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004aa:	8d 50 04             	lea    0x4(%eax),%edx
  8004ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	89 c2                	mov    %eax,%edx
  8004b4:	c1 fa 1f             	sar    $0x1f,%edx
  8004b7:	31 d0                	xor    %edx,%eax
  8004b9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8004bb:	83 f8 0f             	cmp    $0xf,%eax
  8004be:	7f 0b                	jg     8004cb <vprintfmt+0x14e>
  8004c0:	8b 14 85 e0 2f 80 00 	mov    0x802fe0(,%eax,4),%edx
  8004c7:	85 d2                	test   %edx,%edx
  8004c9:	75 20                	jne    8004eb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8004cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004cf:	c7 44 24 08 51 2d 80 	movl   $0x802d51,0x8(%esp)
  8004d6:	00 
  8004d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004db:	89 3c 24             	mov    %edi,(%esp)
  8004de:	e8 4e 03 00 00       	call   800831 <printfmt>
  8004e3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8004e6:	e9 be fe ff ff       	jmp    8003a9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8004eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004ef:	c7 44 24 08 01 32 80 	movl   $0x803201,0x8(%esp)
  8004f6:	00 
  8004f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004fb:	89 3c 24             	mov    %edi,(%esp)
  8004fe:	e8 2e 03 00 00       	call   800831 <printfmt>
  800503:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800506:	e9 9e fe ff ff       	jmp    8003a9 <vprintfmt+0x2c>
  80050b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80050e:	89 c3                	mov    %eax,%ebx
  800510:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800513:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800516:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8d 50 04             	lea    0x4(%eax),%edx
  80051f:	89 55 14             	mov    %edx,0x14(%ebp)
  800522:	8b 00                	mov    (%eax),%eax
  800524:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800527:	85 c0                	test   %eax,%eax
  800529:	75 07                	jne    800532 <vprintfmt+0x1b5>
  80052b:	c7 45 c4 5a 2d 80 00 	movl   $0x802d5a,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800532:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  800536:	7e 06                	jle    80053e <vprintfmt+0x1c1>
  800538:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80053c:	75 13                	jne    800551 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80053e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800541:	0f be 02             	movsbl (%edx),%eax
  800544:	85 c0                	test   %eax,%eax
  800546:	0f 85 99 00 00 00    	jne    8005e5 <vprintfmt+0x268>
  80054c:	e9 86 00 00 00       	jmp    8005d7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800551:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800555:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800558:	89 0c 24             	mov    %ecx,(%esp)
  80055b:	e8 1b 03 00 00       	call   80087b <strnlen>
  800560:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800563:	29 c2                	sub    %eax,%edx
  800565:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800568:	85 d2                	test   %edx,%edx
  80056a:	7e d2                	jle    80053e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80056c:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  800570:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800573:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  800576:	89 d3                	mov    %edx,%ebx
  800578:	89 74 24 04          	mov    %esi,0x4(%esp)
  80057c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80057f:	89 04 24             	mov    %eax,(%esp)
  800582:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800584:	83 eb 01             	sub    $0x1,%ebx
  800587:	85 db                	test   %ebx,%ebx
  800589:	7f ed                	jg     800578 <vprintfmt+0x1fb>
  80058b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80058e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800595:	eb a7                	jmp    80053e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800597:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80059b:	74 18                	je     8005b5 <vprintfmt+0x238>
  80059d:	8d 50 e0             	lea    -0x20(%eax),%edx
  8005a0:	83 fa 5e             	cmp    $0x5e,%edx
  8005a3:	76 10                	jbe    8005b5 <vprintfmt+0x238>
					putch('?', putdat);
  8005a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005a9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8005b0:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8005b3:	eb 0a                	jmp    8005bf <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8005b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8005b9:	89 04 24             	mov    %eax,(%esp)
  8005bc:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005bf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8005c3:	0f be 03             	movsbl (%ebx),%eax
  8005c6:	85 c0                	test   %eax,%eax
  8005c8:	74 05                	je     8005cf <vprintfmt+0x252>
  8005ca:	83 c3 01             	add    $0x1,%ebx
  8005cd:	eb 29                	jmp    8005f8 <vprintfmt+0x27b>
  8005cf:	89 fe                	mov    %edi,%esi
  8005d1:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8005d4:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005db:	7f 2e                	jg     80060b <vprintfmt+0x28e>
  8005dd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005e0:	e9 c4 fd ff ff       	jmp    8003a9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005e5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005e8:	83 c2 01             	add    $0x1,%edx
  8005eb:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8005ee:	89 f7                	mov    %esi,%edi
  8005f0:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8005f3:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  8005f6:	89 d3                	mov    %edx,%ebx
  8005f8:	85 f6                	test   %esi,%esi
  8005fa:	78 9b                	js     800597 <vprintfmt+0x21a>
  8005fc:	83 ee 01             	sub    $0x1,%esi
  8005ff:	79 96                	jns    800597 <vprintfmt+0x21a>
  800601:	89 fe                	mov    %edi,%esi
  800603:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800606:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800609:	eb cc                	jmp    8005d7 <vprintfmt+0x25a>
  80060b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  80060e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800611:	89 74 24 04          	mov    %esi,0x4(%esp)
  800615:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80061c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80061e:	83 eb 01             	sub    $0x1,%ebx
  800621:	85 db                	test   %ebx,%ebx
  800623:	7f ec                	jg     800611 <vprintfmt+0x294>
  800625:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800628:	e9 7c fd ff ff       	jmp    8003a9 <vprintfmt+0x2c>
  80062d:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800630:	83 f9 01             	cmp    $0x1,%ecx
  800633:	7e 16                	jle    80064b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8d 50 08             	lea    0x8(%eax),%edx
  80063b:	89 55 14             	mov    %edx,0x14(%ebp)
  80063e:	8b 10                	mov    (%eax),%edx
  800640:	8b 48 04             	mov    0x4(%eax),%ecx
  800643:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800646:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800649:	eb 32                	jmp    80067d <vprintfmt+0x300>
	else if (lflag)
  80064b:	85 c9                	test   %ecx,%ecx
  80064d:	74 18                	je     800667 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80064f:	8b 45 14             	mov    0x14(%ebp),%eax
  800652:	8d 50 04             	lea    0x4(%eax),%edx
  800655:	89 55 14             	mov    %edx,0x14(%ebp)
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80065d:	89 c1                	mov    %eax,%ecx
  80065f:	c1 f9 1f             	sar    $0x1f,%ecx
  800662:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800665:	eb 16                	jmp    80067d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8d 50 04             	lea    0x4(%eax),%edx
  80066d:	89 55 14             	mov    %edx,0x14(%ebp)
  800670:	8b 00                	mov    (%eax),%eax
  800672:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800675:	89 c2                	mov    %eax,%edx
  800677:	c1 fa 1f             	sar    $0x1f,%edx
  80067a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80067d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800680:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800683:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800688:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80068c:	0f 89 b8 00 00 00    	jns    80074a <vprintfmt+0x3cd>
				putch('-', putdat);
  800692:	89 74 24 04          	mov    %esi,0x4(%esp)
  800696:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80069d:	ff d7                	call   *%edi
				num = -(long long) num;
  80069f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8006a2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8006a5:	f7 d9                	neg    %ecx
  8006a7:	83 d3 00             	adc    $0x0,%ebx
  8006aa:	f7 db                	neg    %ebx
  8006ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006b1:	e9 94 00 00 00       	jmp    80074a <vprintfmt+0x3cd>
  8006b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8006b9:	89 ca                	mov    %ecx,%edx
  8006bb:	8d 45 14             	lea    0x14(%ebp),%eax
  8006be:	e8 63 fc ff ff       	call   800326 <getuint>
  8006c3:	89 c1                	mov    %eax,%ecx
  8006c5:	89 d3                	mov    %edx,%ebx
  8006c7:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8006cc:	eb 7c                	jmp    80074a <vprintfmt+0x3cd>
  8006ce:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8006d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006d5:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8006dc:	ff d7                	call   *%edi
			putch('X', putdat);
  8006de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006e2:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8006e9:	ff d7                	call   *%edi
			putch('X', putdat);
  8006eb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006ef:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8006f6:	ff d7                	call   *%edi
  8006f8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8006fb:	e9 a9 fc ff ff       	jmp    8003a9 <vprintfmt+0x2c>
  800700:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800703:	89 74 24 04          	mov    %esi,0x4(%esp)
  800707:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80070e:	ff d7                	call   *%edi
			putch('x', putdat);
  800710:	89 74 24 04          	mov    %esi,0x4(%esp)
  800714:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80071b:	ff d7                	call   *%edi
			num = (unsigned long long)
  80071d:	8b 45 14             	mov    0x14(%ebp),%eax
  800720:	8d 50 04             	lea    0x4(%eax),%edx
  800723:	89 55 14             	mov    %edx,0x14(%ebp)
  800726:	8b 08                	mov    (%eax),%ecx
  800728:	bb 00 00 00 00       	mov    $0x0,%ebx
  80072d:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800732:	eb 16                	jmp    80074a <vprintfmt+0x3cd>
  800734:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800737:	89 ca                	mov    %ecx,%edx
  800739:	8d 45 14             	lea    0x14(%ebp),%eax
  80073c:	e8 e5 fb ff ff       	call   800326 <getuint>
  800741:	89 c1                	mov    %eax,%ecx
  800743:	89 d3                	mov    %edx,%ebx
  800745:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80074a:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  80074e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800752:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800755:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800759:	89 44 24 08          	mov    %eax,0x8(%esp)
  80075d:	89 0c 24             	mov    %ecx,(%esp)
  800760:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800764:	89 f2                	mov    %esi,%edx
  800766:	89 f8                	mov    %edi,%eax
  800768:	e8 c3 fa ff ff       	call   800230 <printnum>
  80076d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800770:	e9 34 fc ff ff       	jmp    8003a9 <vprintfmt+0x2c>
  800775:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800778:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80077b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80077f:	89 14 24             	mov    %edx,(%esp)
  800782:	ff d7                	call   *%edi
  800784:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800787:	e9 1d fc ff ff       	jmp    8003a9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80078c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800790:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800797:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800799:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80079c:	80 38 25             	cmpb   $0x25,(%eax)
  80079f:	0f 84 04 fc ff ff    	je     8003a9 <vprintfmt+0x2c>
  8007a5:	89 c3                	mov    %eax,%ebx
  8007a7:	eb f0                	jmp    800799 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  8007a9:	83 c4 5c             	add    $0x5c,%esp
  8007ac:	5b                   	pop    %ebx
  8007ad:	5e                   	pop    %esi
  8007ae:	5f                   	pop    %edi
  8007af:	5d                   	pop    %ebp
  8007b0:	c3                   	ret    

008007b1 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007b1:	55                   	push   %ebp
  8007b2:	89 e5                	mov    %esp,%ebp
  8007b4:	83 ec 28             	sub    $0x28,%esp
  8007b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ba:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8007bd:	85 c0                	test   %eax,%eax
  8007bf:	74 04                	je     8007c5 <vsnprintf+0x14>
  8007c1:	85 d2                	test   %edx,%edx
  8007c3:	7f 07                	jg     8007cc <vsnprintf+0x1b>
  8007c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007ca:	eb 3b                	jmp    800807 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007cf:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8007d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007f2:	c7 04 24 60 03 80 00 	movl   $0x800360,(%esp)
  8007f9:	e8 7f fb ff ff       	call   80037d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800801:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800804:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800807:	c9                   	leave  
  800808:	c3                   	ret    

00800809 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800809:	55                   	push   %ebp
  80080a:	89 e5                	mov    %esp,%ebp
  80080c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80080f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800812:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800816:	8b 45 10             	mov    0x10(%ebp),%eax
  800819:	89 44 24 08          	mov    %eax,0x8(%esp)
  80081d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800820:	89 44 24 04          	mov    %eax,0x4(%esp)
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	89 04 24             	mov    %eax,(%esp)
  80082a:	e8 82 ff ff ff       	call   8007b1 <vsnprintf>
	va_end(ap);

	return rc;
}
  80082f:	c9                   	leave  
  800830:	c3                   	ret    

00800831 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800831:	55                   	push   %ebp
  800832:	89 e5                	mov    %esp,%ebp
  800834:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800837:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80083a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80083e:	8b 45 10             	mov    0x10(%ebp),%eax
  800841:	89 44 24 08          	mov    %eax,0x8(%esp)
  800845:	8b 45 0c             	mov    0xc(%ebp),%eax
  800848:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084c:	8b 45 08             	mov    0x8(%ebp),%eax
  80084f:	89 04 24             	mov    %eax,(%esp)
  800852:	e8 26 fb ff ff       	call   80037d <vprintfmt>
	va_end(ap);
}
  800857:	c9                   	leave  
  800858:	c3                   	ret    
  800859:	00 00                	add    %al,(%eax)
  80085b:	00 00                	add    %al,(%eax)
  80085d:	00 00                	add    %al,(%eax)
	...

00800860 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800866:	b8 00 00 00 00       	mov    $0x0,%eax
  80086b:	80 3a 00             	cmpb   $0x0,(%edx)
  80086e:	74 09                	je     800879 <strlen+0x19>
		n++;
  800870:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800873:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800877:	75 f7                	jne    800870 <strlen+0x10>
		n++;
	return n;
}
  800879:	5d                   	pop    %ebp
  80087a:	c3                   	ret    

0080087b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
  80087e:	53                   	push   %ebx
  80087f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800882:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800885:	85 c9                	test   %ecx,%ecx
  800887:	74 19                	je     8008a2 <strnlen+0x27>
  800889:	80 3b 00             	cmpb   $0x0,(%ebx)
  80088c:	74 14                	je     8008a2 <strnlen+0x27>
  80088e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800893:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800896:	39 c8                	cmp    %ecx,%eax
  800898:	74 0d                	je     8008a7 <strnlen+0x2c>
  80089a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80089e:	75 f3                	jne    800893 <strnlen+0x18>
  8008a0:	eb 05                	jmp    8008a7 <strnlen+0x2c>
  8008a2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8008a7:	5b                   	pop    %ebx
  8008a8:	5d                   	pop    %ebp
  8008a9:	c3                   	ret    

008008aa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8008aa:	55                   	push   %ebp
  8008ab:	89 e5                	mov    %esp,%ebp
  8008ad:	53                   	push   %ebx
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008b4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008b9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8008bd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8008c0:	83 c2 01             	add    $0x1,%edx
  8008c3:	84 c9                	test   %cl,%cl
  8008c5:	75 f2                	jne    8008b9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8008c7:	5b                   	pop    %ebx
  8008c8:	5d                   	pop    %ebp
  8008c9:	c3                   	ret    

008008ca <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008ca:	55                   	push   %ebp
  8008cb:	89 e5                	mov    %esp,%ebp
  8008cd:	56                   	push   %esi
  8008ce:	53                   	push   %ebx
  8008cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008d8:	85 f6                	test   %esi,%esi
  8008da:	74 18                	je     8008f4 <strncpy+0x2a>
  8008dc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8008e1:	0f b6 1a             	movzbl (%edx),%ebx
  8008e4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008e7:	80 3a 01             	cmpb   $0x1,(%edx)
  8008ea:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008ed:	83 c1 01             	add    $0x1,%ecx
  8008f0:	39 ce                	cmp    %ecx,%esi
  8008f2:	77 ed                	ja     8008e1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8008f4:	5b                   	pop    %ebx
  8008f5:	5e                   	pop    %esi
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	56                   	push   %esi
  8008fc:	53                   	push   %ebx
  8008fd:	8b 75 08             	mov    0x8(%ebp),%esi
  800900:	8b 55 0c             	mov    0xc(%ebp),%edx
  800903:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800906:	89 f0                	mov    %esi,%eax
  800908:	85 c9                	test   %ecx,%ecx
  80090a:	74 27                	je     800933 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  80090c:	83 e9 01             	sub    $0x1,%ecx
  80090f:	74 1d                	je     80092e <strlcpy+0x36>
  800911:	0f b6 1a             	movzbl (%edx),%ebx
  800914:	84 db                	test   %bl,%bl
  800916:	74 16                	je     80092e <strlcpy+0x36>
			*dst++ = *src++;
  800918:	88 18                	mov    %bl,(%eax)
  80091a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80091d:	83 e9 01             	sub    $0x1,%ecx
  800920:	74 0e                	je     800930 <strlcpy+0x38>
			*dst++ = *src++;
  800922:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800925:	0f b6 1a             	movzbl (%edx),%ebx
  800928:	84 db                	test   %bl,%bl
  80092a:	75 ec                	jne    800918 <strlcpy+0x20>
  80092c:	eb 02                	jmp    800930 <strlcpy+0x38>
  80092e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800930:	c6 00 00             	movb   $0x0,(%eax)
  800933:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800935:	5b                   	pop    %ebx
  800936:	5e                   	pop    %esi
  800937:	5d                   	pop    %ebp
  800938:	c3                   	ret    

00800939 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80093f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800942:	0f b6 01             	movzbl (%ecx),%eax
  800945:	84 c0                	test   %al,%al
  800947:	74 15                	je     80095e <strcmp+0x25>
  800949:	3a 02                	cmp    (%edx),%al
  80094b:	75 11                	jne    80095e <strcmp+0x25>
		p++, q++;
  80094d:	83 c1 01             	add    $0x1,%ecx
  800950:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800953:	0f b6 01             	movzbl (%ecx),%eax
  800956:	84 c0                	test   %al,%al
  800958:	74 04                	je     80095e <strcmp+0x25>
  80095a:	3a 02                	cmp    (%edx),%al
  80095c:	74 ef                	je     80094d <strcmp+0x14>
  80095e:	0f b6 c0             	movzbl %al,%eax
  800961:	0f b6 12             	movzbl (%edx),%edx
  800964:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800966:	5d                   	pop    %ebp
  800967:	c3                   	ret    

00800968 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	53                   	push   %ebx
  80096c:	8b 55 08             	mov    0x8(%ebp),%edx
  80096f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800972:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800975:	85 c0                	test   %eax,%eax
  800977:	74 23                	je     80099c <strncmp+0x34>
  800979:	0f b6 1a             	movzbl (%edx),%ebx
  80097c:	84 db                	test   %bl,%bl
  80097e:	74 24                	je     8009a4 <strncmp+0x3c>
  800980:	3a 19                	cmp    (%ecx),%bl
  800982:	75 20                	jne    8009a4 <strncmp+0x3c>
  800984:	83 e8 01             	sub    $0x1,%eax
  800987:	74 13                	je     80099c <strncmp+0x34>
		n--, p++, q++;
  800989:	83 c2 01             	add    $0x1,%edx
  80098c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80098f:	0f b6 1a             	movzbl (%edx),%ebx
  800992:	84 db                	test   %bl,%bl
  800994:	74 0e                	je     8009a4 <strncmp+0x3c>
  800996:	3a 19                	cmp    (%ecx),%bl
  800998:	74 ea                	je     800984 <strncmp+0x1c>
  80099a:	eb 08                	jmp    8009a4 <strncmp+0x3c>
  80099c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8009a1:	5b                   	pop    %ebx
  8009a2:	5d                   	pop    %ebp
  8009a3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8009a4:	0f b6 02             	movzbl (%edx),%eax
  8009a7:	0f b6 11             	movzbl (%ecx),%edx
  8009aa:	29 d0                	sub    %edx,%eax
  8009ac:	eb f3                	jmp    8009a1 <strncmp+0x39>

008009ae <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009b8:	0f b6 10             	movzbl (%eax),%edx
  8009bb:	84 d2                	test   %dl,%dl
  8009bd:	74 15                	je     8009d4 <strchr+0x26>
		if (*s == c)
  8009bf:	38 ca                	cmp    %cl,%dl
  8009c1:	75 07                	jne    8009ca <strchr+0x1c>
  8009c3:	eb 14                	jmp    8009d9 <strchr+0x2b>
  8009c5:	38 ca                	cmp    %cl,%dl
  8009c7:	90                   	nop
  8009c8:	74 0f                	je     8009d9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8009ca:	83 c0 01             	add    $0x1,%eax
  8009cd:	0f b6 10             	movzbl (%eax),%edx
  8009d0:	84 d2                	test   %dl,%dl
  8009d2:	75 f1                	jne    8009c5 <strchr+0x17>
  8009d4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8009d9:	5d                   	pop    %ebp
  8009da:	c3                   	ret    

008009db <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009db:	55                   	push   %ebp
  8009dc:	89 e5                	mov    %esp,%ebp
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8009e5:	0f b6 10             	movzbl (%eax),%edx
  8009e8:	84 d2                	test   %dl,%dl
  8009ea:	74 18                	je     800a04 <strfind+0x29>
		if (*s == c)
  8009ec:	38 ca                	cmp    %cl,%dl
  8009ee:	75 0a                	jne    8009fa <strfind+0x1f>
  8009f0:	eb 12                	jmp    800a04 <strfind+0x29>
  8009f2:	38 ca                	cmp    %cl,%dl
  8009f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8009f8:	74 0a                	je     800a04 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8009fa:	83 c0 01             	add    $0x1,%eax
  8009fd:	0f b6 10             	movzbl (%eax),%edx
  800a00:	84 d2                	test   %dl,%dl
  800a02:	75 ee                	jne    8009f2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800a04:	5d                   	pop    %ebp
  800a05:	c3                   	ret    

00800a06 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	83 ec 0c             	sub    $0xc,%esp
  800a0c:	89 1c 24             	mov    %ebx,(%esp)
  800a0f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a13:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800a17:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a20:	85 c9                	test   %ecx,%ecx
  800a22:	74 30                	je     800a54 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a24:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a2a:	75 25                	jne    800a51 <memset+0x4b>
  800a2c:	f6 c1 03             	test   $0x3,%cl
  800a2f:	75 20                	jne    800a51 <memset+0x4b>
		c &= 0xFF;
  800a31:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a34:	89 d3                	mov    %edx,%ebx
  800a36:	c1 e3 08             	shl    $0x8,%ebx
  800a39:	89 d6                	mov    %edx,%esi
  800a3b:	c1 e6 18             	shl    $0x18,%esi
  800a3e:	89 d0                	mov    %edx,%eax
  800a40:	c1 e0 10             	shl    $0x10,%eax
  800a43:	09 f0                	or     %esi,%eax
  800a45:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800a47:	09 d8                	or     %ebx,%eax
  800a49:	c1 e9 02             	shr    $0x2,%ecx
  800a4c:	fc                   	cld    
  800a4d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a4f:	eb 03                	jmp    800a54 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a51:	fc                   	cld    
  800a52:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a54:	89 f8                	mov    %edi,%eax
  800a56:	8b 1c 24             	mov    (%esp),%ebx
  800a59:	8b 74 24 04          	mov    0x4(%esp),%esi
  800a5d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800a61:	89 ec                	mov    %ebp,%esp
  800a63:	5d                   	pop    %ebp
  800a64:	c3                   	ret    

00800a65 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a65:	55                   	push   %ebp
  800a66:	89 e5                	mov    %esp,%ebp
  800a68:	83 ec 08             	sub    $0x8,%esp
  800a6b:	89 34 24             	mov    %esi,(%esp)
  800a6e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a72:	8b 45 08             	mov    0x8(%ebp),%eax
  800a75:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800a78:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a7b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a7d:	39 c6                	cmp    %eax,%esi
  800a7f:	73 35                	jae    800ab6 <memmove+0x51>
  800a81:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a84:	39 d0                	cmp    %edx,%eax
  800a86:	73 2e                	jae    800ab6 <memmove+0x51>
		s += n;
		d += n;
  800a88:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a8a:	f6 c2 03             	test   $0x3,%dl
  800a8d:	75 1b                	jne    800aaa <memmove+0x45>
  800a8f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a95:	75 13                	jne    800aaa <memmove+0x45>
  800a97:	f6 c1 03             	test   $0x3,%cl
  800a9a:	75 0e                	jne    800aaa <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800a9c:	83 ef 04             	sub    $0x4,%edi
  800a9f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aa2:	c1 e9 02             	shr    $0x2,%ecx
  800aa5:	fd                   	std    
  800aa6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800aa8:	eb 09                	jmp    800ab3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800aaa:	83 ef 01             	sub    $0x1,%edi
  800aad:	8d 72 ff             	lea    -0x1(%edx),%esi
  800ab0:	fd                   	std    
  800ab1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ab3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ab4:	eb 20                	jmp    800ad6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ab6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800abc:	75 15                	jne    800ad3 <memmove+0x6e>
  800abe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ac4:	75 0d                	jne    800ad3 <memmove+0x6e>
  800ac6:	f6 c1 03             	test   $0x3,%cl
  800ac9:	75 08                	jne    800ad3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800acb:	c1 e9 02             	shr    $0x2,%ecx
  800ace:	fc                   	cld    
  800acf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad1:	eb 03                	jmp    800ad6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ad3:	fc                   	cld    
  800ad4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ad6:	8b 34 24             	mov    (%esp),%esi
  800ad9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800add:	89 ec                	mov    %ebp,%esp
  800adf:	5d                   	pop    %ebp
  800ae0:	c3                   	ret    

00800ae1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800ae1:	55                   	push   %ebp
  800ae2:	89 e5                	mov    %esp,%ebp
  800ae4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ae7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aea:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af5:	8b 45 08             	mov    0x8(%ebp),%eax
  800af8:	89 04 24             	mov    %eax,(%esp)
  800afb:	e8 65 ff ff ff       	call   800a65 <memmove>
}
  800b00:	c9                   	leave  
  800b01:	c3                   	ret    

00800b02 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b02:	55                   	push   %ebp
  800b03:	89 e5                	mov    %esp,%ebp
  800b05:	57                   	push   %edi
  800b06:	56                   	push   %esi
  800b07:	53                   	push   %ebx
  800b08:	8b 75 08             	mov    0x8(%ebp),%esi
  800b0b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800b0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b11:	85 c9                	test   %ecx,%ecx
  800b13:	74 36                	je     800b4b <memcmp+0x49>
		if (*s1 != *s2)
  800b15:	0f b6 06             	movzbl (%esi),%eax
  800b18:	0f b6 1f             	movzbl (%edi),%ebx
  800b1b:	38 d8                	cmp    %bl,%al
  800b1d:	74 20                	je     800b3f <memcmp+0x3d>
  800b1f:	eb 14                	jmp    800b35 <memcmp+0x33>
  800b21:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800b26:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800b2b:	83 c2 01             	add    $0x1,%edx
  800b2e:	83 e9 01             	sub    $0x1,%ecx
  800b31:	38 d8                	cmp    %bl,%al
  800b33:	74 12                	je     800b47 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800b35:	0f b6 c0             	movzbl %al,%eax
  800b38:	0f b6 db             	movzbl %bl,%ebx
  800b3b:	29 d8                	sub    %ebx,%eax
  800b3d:	eb 11                	jmp    800b50 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800b3f:	83 e9 01             	sub    $0x1,%ecx
  800b42:	ba 00 00 00 00       	mov    $0x0,%edx
  800b47:	85 c9                	test   %ecx,%ecx
  800b49:	75 d6                	jne    800b21 <memcmp+0x1f>
  800b4b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800b50:	5b                   	pop    %ebx
  800b51:	5e                   	pop    %esi
  800b52:	5f                   	pop    %edi
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
  800b58:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800b5b:	89 c2                	mov    %eax,%edx
  800b5d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b60:	39 d0                	cmp    %edx,%eax
  800b62:	73 15                	jae    800b79 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b64:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800b68:	38 08                	cmp    %cl,(%eax)
  800b6a:	75 06                	jne    800b72 <memfind+0x1d>
  800b6c:	eb 0b                	jmp    800b79 <memfind+0x24>
  800b6e:	38 08                	cmp    %cl,(%eax)
  800b70:	74 07                	je     800b79 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b72:	83 c0 01             	add    $0x1,%eax
  800b75:	39 c2                	cmp    %eax,%edx
  800b77:	77 f5                	ja     800b6e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	57                   	push   %edi
  800b7f:	56                   	push   %esi
  800b80:	53                   	push   %ebx
  800b81:	83 ec 04             	sub    $0x4,%esp
  800b84:	8b 55 08             	mov    0x8(%ebp),%edx
  800b87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b8a:	0f b6 02             	movzbl (%edx),%eax
  800b8d:	3c 20                	cmp    $0x20,%al
  800b8f:	74 04                	je     800b95 <strtol+0x1a>
  800b91:	3c 09                	cmp    $0x9,%al
  800b93:	75 0e                	jne    800ba3 <strtol+0x28>
		s++;
  800b95:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b98:	0f b6 02             	movzbl (%edx),%eax
  800b9b:	3c 20                	cmp    $0x20,%al
  800b9d:	74 f6                	je     800b95 <strtol+0x1a>
  800b9f:	3c 09                	cmp    $0x9,%al
  800ba1:	74 f2                	je     800b95 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ba3:	3c 2b                	cmp    $0x2b,%al
  800ba5:	75 0c                	jne    800bb3 <strtol+0x38>
		s++;
  800ba7:	83 c2 01             	add    $0x1,%edx
  800baa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bb1:	eb 15                	jmp    800bc8 <strtol+0x4d>
	else if (*s == '-')
  800bb3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800bba:	3c 2d                	cmp    $0x2d,%al
  800bbc:	75 0a                	jne    800bc8 <strtol+0x4d>
		s++, neg = 1;
  800bbe:	83 c2 01             	add    $0x1,%edx
  800bc1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bc8:	85 db                	test   %ebx,%ebx
  800bca:	0f 94 c0             	sete   %al
  800bcd:	74 05                	je     800bd4 <strtol+0x59>
  800bcf:	83 fb 10             	cmp    $0x10,%ebx
  800bd2:	75 18                	jne    800bec <strtol+0x71>
  800bd4:	80 3a 30             	cmpb   $0x30,(%edx)
  800bd7:	75 13                	jne    800bec <strtol+0x71>
  800bd9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800bdd:	8d 76 00             	lea    0x0(%esi),%esi
  800be0:	75 0a                	jne    800bec <strtol+0x71>
		s += 2, base = 16;
  800be2:	83 c2 02             	add    $0x2,%edx
  800be5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bea:	eb 15                	jmp    800c01 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bec:	84 c0                	test   %al,%al
  800bee:	66 90                	xchg   %ax,%ax
  800bf0:	74 0f                	je     800c01 <strtol+0x86>
  800bf2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800bf7:	80 3a 30             	cmpb   $0x30,(%edx)
  800bfa:	75 05                	jne    800c01 <strtol+0x86>
		s++, base = 8;
  800bfc:	83 c2 01             	add    $0x1,%edx
  800bff:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c01:	b8 00 00 00 00       	mov    $0x0,%eax
  800c06:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800c08:	0f b6 0a             	movzbl (%edx),%ecx
  800c0b:	89 cf                	mov    %ecx,%edi
  800c0d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800c10:	80 fb 09             	cmp    $0x9,%bl
  800c13:	77 08                	ja     800c1d <strtol+0xa2>
			dig = *s - '0';
  800c15:	0f be c9             	movsbl %cl,%ecx
  800c18:	83 e9 30             	sub    $0x30,%ecx
  800c1b:	eb 1e                	jmp    800c3b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800c1d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800c20:	80 fb 19             	cmp    $0x19,%bl
  800c23:	77 08                	ja     800c2d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800c25:	0f be c9             	movsbl %cl,%ecx
  800c28:	83 e9 57             	sub    $0x57,%ecx
  800c2b:	eb 0e                	jmp    800c3b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800c2d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800c30:	80 fb 19             	cmp    $0x19,%bl
  800c33:	77 15                	ja     800c4a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800c35:	0f be c9             	movsbl %cl,%ecx
  800c38:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800c3b:	39 f1                	cmp    %esi,%ecx
  800c3d:	7d 0b                	jge    800c4a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800c3f:	83 c2 01             	add    $0x1,%edx
  800c42:	0f af c6             	imul   %esi,%eax
  800c45:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800c48:	eb be                	jmp    800c08 <strtol+0x8d>
  800c4a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800c4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c50:	74 05                	je     800c57 <strtol+0xdc>
		*endptr = (char *) s;
  800c52:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c55:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800c57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800c5b:	74 04                	je     800c61 <strtol+0xe6>
  800c5d:	89 c8                	mov    %ecx,%eax
  800c5f:	f7 d8                	neg    %eax
}
  800c61:	83 c4 04             	add    $0x4,%esp
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5f                   	pop    %edi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    
  800c69:	00 00                	add    %al,(%eax)
	...

00800c6c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	83 ec 0c             	sub    $0xc,%esp
  800c72:	89 1c 24             	mov    %ebx,(%esp)
  800c75:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c79:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c82:	b8 01 00 00 00       	mov    $0x1,%eax
  800c87:	89 d1                	mov    %edx,%ecx
  800c89:	89 d3                	mov    %edx,%ebx
  800c8b:	89 d7                	mov    %edx,%edi
  800c8d:	89 d6                	mov    %edx,%esi
  800c8f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c91:	8b 1c 24             	mov    (%esp),%ebx
  800c94:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c98:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c9c:	89 ec                	mov    %ebp,%esp
  800c9e:	5d                   	pop    %ebp
  800c9f:	c3                   	ret    

00800ca0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 0c             	sub    $0xc,%esp
  800ca6:	89 1c 24             	mov    %ebx,(%esp)
  800ca9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cad:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbc:	89 c3                	mov    %eax,%ebx
  800cbe:	89 c7                	mov    %eax,%edi
  800cc0:	89 c6                	mov    %eax,%esi
  800cc2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cc4:	8b 1c 24             	mov    (%esp),%ebx
  800cc7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ccb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ccf:	89 ec                	mov    %ebp,%esp
  800cd1:	5d                   	pop    %ebp
  800cd2:	c3                   	ret    

00800cd3 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 0c             	sub    $0xc,%esp
  800cd9:	89 1c 24             	mov    %ebx,(%esp)
  800cdc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ce0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ce4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce9:	b8 10 00 00 00       	mov    $0x10,%eax
  800cee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf1:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf4:	89 df                	mov    %ebx,%edi
  800cf6:	89 de                	mov    %ebx,%esi
  800cf8:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800cfa:	8b 1c 24             	mov    (%esp),%ebx
  800cfd:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d01:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d05:	89 ec                	mov    %ebp,%esp
  800d07:	5d                   	pop    %ebp
  800d08:	c3                   	ret    

00800d09 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 38             	sub    $0x38,%esp
  800d0f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d12:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d15:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d18:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d1d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800d22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d25:	8b 55 08             	mov    0x8(%ebp),%edx
  800d28:	89 df                	mov    %ebx,%edi
  800d2a:	89 de                	mov    %ebx,%esi
  800d2c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800d2e:	85 c0                	test   %eax,%eax
  800d30:	7e 28                	jle    800d5a <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d32:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d36:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800d3d:	00 
  800d3e:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  800d45:	00 
  800d46:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d4d:	00 
  800d4e:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  800d55:	e8 d2 1b 00 00       	call   80292c <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800d5a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d5d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d60:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d63:	89 ec                	mov    %ebp,%esp
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    

00800d67 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	83 ec 0c             	sub    $0xc,%esp
  800d6d:	89 1c 24             	mov    %ebx,(%esp)
  800d70:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d74:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d78:	ba 00 00 00 00       	mov    $0x0,%edx
  800d7d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d82:	89 d1                	mov    %edx,%ecx
  800d84:	89 d3                	mov    %edx,%ebx
  800d86:	89 d7                	mov    %edx,%edi
  800d88:	89 d6                	mov    %edx,%esi
  800d8a:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d8c:	8b 1c 24             	mov    (%esp),%ebx
  800d8f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d93:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d97:	89 ec                	mov    %ebp,%esp
  800d99:	5d                   	pop    %ebp
  800d9a:	c3                   	ret    

00800d9b <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 38             	sub    $0x38,%esp
  800da1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800da4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800da7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800daa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800daf:	b8 0d 00 00 00       	mov    $0xd,%eax
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	89 cb                	mov    %ecx,%ebx
  800db9:	89 cf                	mov    %ecx,%edi
  800dbb:	89 ce                	mov    %ecx,%esi
  800dbd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800dbf:	85 c0                	test   %eax,%eax
  800dc1:	7e 28                	jle    800deb <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800dc3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800dc7:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800dce:	00 
  800dcf:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  800dd6:	00 
  800dd7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dde:	00 
  800ddf:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  800de6:	e8 41 1b 00 00       	call   80292c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800deb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800dee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800df1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800df4:	89 ec                	mov    %ebp,%esp
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	83 ec 0c             	sub    $0xc,%esp
  800dfe:	89 1c 24             	mov    %ebx,(%esp)
  800e01:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e05:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e09:	be 00 00 00 00       	mov    $0x0,%esi
  800e0e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e13:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e16:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e1f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e21:	8b 1c 24             	mov    (%esp),%ebx
  800e24:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e28:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e2c:	89 ec                	mov    %ebp,%esp
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	83 ec 38             	sub    $0x38,%esp
  800e36:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e39:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e3c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e44:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4f:	89 df                	mov    %ebx,%edi
  800e51:	89 de                	mov    %ebx,%esi
  800e53:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	7e 28                	jle    800e81 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e59:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e5d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800e64:	00 
  800e65:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  800e6c:	00 
  800e6d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e74:	00 
  800e75:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  800e7c:	e8 ab 1a 00 00       	call   80292c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e81:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e84:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e87:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e8a:	89 ec                	mov    %ebp,%esp
  800e8c:	5d                   	pop    %ebp
  800e8d:	c3                   	ret    

00800e8e <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 38             	sub    $0x38,%esp
  800e94:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e97:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e9a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ea2:	b8 09 00 00 00       	mov    $0x9,%eax
  800ea7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eaa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ead:	89 df                	mov    %ebx,%edi
  800eaf:	89 de                	mov    %ebx,%esi
  800eb1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800eb3:	85 c0                	test   %eax,%eax
  800eb5:	7e 28                	jle    800edf <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ebb:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ec2:	00 
  800ec3:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  800eca:	00 
  800ecb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ed2:	00 
  800ed3:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  800eda:	e8 4d 1a 00 00       	call   80292c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800edf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ee2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ee5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ee8:	89 ec                	mov    %ebp,%esp
  800eea:	5d                   	pop    %ebp
  800eeb:	c3                   	ret    

00800eec <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 38             	sub    $0x38,%esp
  800ef2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ef5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ef8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f00:	b8 08 00 00 00       	mov    $0x8,%eax
  800f05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f08:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0b:	89 df                	mov    %ebx,%edi
  800f0d:	89 de                	mov    %ebx,%esi
  800f0f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f11:	85 c0                	test   %eax,%eax
  800f13:	7e 28                	jle    800f3d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f15:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f19:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800f20:	00 
  800f21:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  800f28:	00 
  800f29:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f30:	00 
  800f31:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  800f38:	e8 ef 19 00 00       	call   80292c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800f3d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f40:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f43:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f46:	89 ec                	mov    %ebp,%esp
  800f48:	5d                   	pop    %ebp
  800f49:	c3                   	ret    

00800f4a <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800f4a:	55                   	push   %ebp
  800f4b:	89 e5                	mov    %esp,%ebp
  800f4d:	83 ec 38             	sub    $0x38,%esp
  800f50:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f53:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f56:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f59:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f5e:	b8 06 00 00 00       	mov    $0x6,%eax
  800f63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f66:	8b 55 08             	mov    0x8(%ebp),%edx
  800f69:	89 df                	mov    %ebx,%edi
  800f6b:	89 de                	mov    %ebx,%esi
  800f6d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f6f:	85 c0                	test   %eax,%eax
  800f71:	7e 28                	jle    800f9b <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f73:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f77:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f7e:	00 
  800f7f:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  800f86:	00 
  800f87:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f8e:	00 
  800f8f:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  800f96:	e8 91 19 00 00       	call   80292c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f9b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f9e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fa1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fa4:	89 ec                	mov    %ebp,%esp
  800fa6:	5d                   	pop    %ebp
  800fa7:	c3                   	ret    

00800fa8 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800fa8:	55                   	push   %ebp
  800fa9:	89 e5                	mov    %esp,%ebp
  800fab:	83 ec 38             	sub    $0x38,%esp
  800fae:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fb1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fb4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb7:	b8 05 00 00 00       	mov    $0x5,%eax
  800fbc:	8b 75 18             	mov    0x18(%ebp),%esi
  800fbf:	8b 7d 14             	mov    0x14(%ebp),%edi
  800fc2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fcd:	85 c0                	test   %eax,%eax
  800fcf:	7e 28                	jle    800ff9 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd1:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd5:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800fdc:	00 
  800fdd:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  800fe4:	00 
  800fe5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fec:	00 
  800fed:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  800ff4:	e8 33 19 00 00       	call   80292c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800ff9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ffc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fff:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801002:	89 ec                	mov    %ebp,%esp
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    

00801006 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
  801009:	83 ec 38             	sub    $0x38,%esp
  80100c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80100f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801012:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801015:	be 00 00 00 00       	mov    $0x0,%esi
  80101a:	b8 04 00 00 00       	mov    $0x4,%eax
  80101f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801022:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801025:	8b 55 08             	mov    0x8(%ebp),%edx
  801028:	89 f7                	mov    %esi,%edi
  80102a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80102c:	85 c0                	test   %eax,%eax
  80102e:	7e 28                	jle    801058 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801030:	89 44 24 10          	mov    %eax,0x10(%esp)
  801034:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80103b:	00 
  80103c:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  801043:	00 
  801044:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80104b:	00 
  80104c:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  801053:	e8 d4 18 00 00       	call   80292c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801058:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80105b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80105e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801061:	89 ec                	mov    %ebp,%esp
  801063:	5d                   	pop    %ebp
  801064:	c3                   	ret    

00801065 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  801065:	55                   	push   %ebp
  801066:	89 e5                	mov    %esp,%ebp
  801068:	83 ec 0c             	sub    $0xc,%esp
  80106b:	89 1c 24             	mov    %ebx,(%esp)
  80106e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801072:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801076:	ba 00 00 00 00       	mov    $0x0,%edx
  80107b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801080:	89 d1                	mov    %edx,%ecx
  801082:	89 d3                	mov    %edx,%ebx
  801084:	89 d7                	mov    %edx,%edi
  801086:	89 d6                	mov    %edx,%esi
  801088:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80108a:	8b 1c 24             	mov    (%esp),%ebx
  80108d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801091:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801095:	89 ec                	mov    %ebp,%esp
  801097:	5d                   	pop    %ebp
  801098:	c3                   	ret    

00801099 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 0c             	sub    $0xc,%esp
  80109f:	89 1c 24             	mov    %ebx,(%esp)
  8010a2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010a6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8010af:	b8 02 00 00 00       	mov    $0x2,%eax
  8010b4:	89 d1                	mov    %edx,%ecx
  8010b6:	89 d3                	mov    %edx,%ebx
  8010b8:	89 d7                	mov    %edx,%edi
  8010ba:	89 d6                	mov    %edx,%esi
  8010bc:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010be:	8b 1c 24             	mov    (%esp),%ebx
  8010c1:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010c5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010c9:	89 ec                	mov    %ebp,%esp
  8010cb:	5d                   	pop    %ebp
  8010cc:	c3                   	ret    

008010cd <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	83 ec 38             	sub    $0x38,%esp
  8010d3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010d6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010d9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010e1:	b8 03 00 00 00       	mov    $0x3,%eax
  8010e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e9:	89 cb                	mov    %ecx,%ebx
  8010eb:	89 cf                	mov    %ecx,%edi
  8010ed:	89 ce                	mov    %ecx,%esi
  8010ef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010f1:	85 c0                	test   %eax,%eax
  8010f3:	7e 28                	jle    80111d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010f9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801100:	00 
  801101:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  801108:	00 
  801109:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801110:	00 
  801111:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  801118:	e8 0f 18 00 00       	call   80292c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80111d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801120:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801123:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801126:	89 ec                	mov    %ebp,%esp
  801128:	5d                   	pop    %ebp
  801129:	c3                   	ret    
	...

0080112c <sfork>:
}

// Challenge!
int
sfork(void)
{
  80112c:	55                   	push   %ebp
  80112d:	89 e5                	mov    %esp,%ebp
  80112f:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801132:	c7 44 24 08 6a 30 80 	movl   $0x80306a,0x8(%esp)
  801139:	00 
  80113a:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  801141:	00 
  801142:	c7 04 24 80 30 80 00 	movl   $0x803080,(%esp)
  801149:	e8 de 17 00 00       	call   80292c <_panic>

0080114e <duppage>:
// It is also OK to panic on error.
// 

static int
duppage(envid_t envid, unsigned pn)
{
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 28             	sub    $0x28,%esp
  801154:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801157:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80115a:	89 c3                	mov    %eax,%ebx
	int r;

	// LAB 4: Your code here.
     pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  80115c:	89 d6                	mov    %edx,%esi
  80115e:	c1 e6 0c             	shl    $0xc,%esi
  801161:	89 f0                	mov    %esi,%eax
  801163:	c1 e8 16             	shr    $0x16,%eax
  801166:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
       
        if( 0 == pgDirEntry )
  80116d:	85 c0                	test   %eax,%eax
  80116f:	0f 84 fc 00 00 00    	je     801271 <duppage+0x123>
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  801175:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80117c:	89 c2                	mov    %eax,%edx
  80117e:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        //cprintf("Below %d",vpt[pn]);
                //if(perm!=0)  //commented nw.
                   // cprintf("perm bit %d",perm);
	
	
	if((perm & PTE_W) && (perm & PTE_SHARE))
  801184:	25 02 04 00 00       	and    $0x402,%eax
  801189:	3d 02 04 00 00       	cmp    $0x402,%eax
  80118e:	75 4d                	jne    8011dd <duppage+0x8f>
	{	
		if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_SHARE|(perm & PTE_USER))) < 0)
  801190:	81 e2 07 0a 00 00    	and    $0xa07,%edx
  801196:	80 ce 04             	or     $0x4,%dh
  801199:	89 54 24 10          	mov    %edx,0x10(%esp)
  80119d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011a1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8011a5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8011b0:	e8 f3 fd ff ff       	call   800fa8 <sys_page_map>
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	0f 89 bb 00 00 00    	jns    801278 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  8011bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011c1:	c7 44 24 08 8b 30 80 	movl   $0x80308b,0x8(%esp)
  8011c8:	00 
  8011c9:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  8011d0:	00 
  8011d1:	c7 04 24 80 30 80 00 	movl   $0x803080,(%esp)
  8011d8:	e8 4f 17 00 00       	call   80292c <_panic>
	}	


        else if((perm & PTE_W)!=0 || (perm & PTE_COW)!=0)
  8011dd:	f7 c2 02 08 00 00    	test   $0x802,%edx
  8011e3:	0f 84 8f 00 00 00    	je     801278 <duppage+0x12a>
         {
          //cprintf("\nInside Setting Cow\n"); 
        if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  8011e9:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8011f0:	00 
  8011f1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8011f5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8011f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801204:	e8 9f fd ff ff       	call   800fa8 <sys_page_map>
  801209:	85 c0                	test   %eax,%eax
  80120b:	79 20                	jns    80122d <duppage+0xdf>
                panic("sys_page_map: %e", r);
  80120d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801211:	c7 44 24 08 8b 30 80 	movl   $0x80308b,0x8(%esp)
  801218:	00 
  801219:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801220:	00 
  801221:	c7 04 24 80 30 80 00 	movl   $0x803080,(%esp)
  801228:	e8 ff 16 00 00       	call   80292c <_panic>
        if ((r = sys_page_map(envid,(void *)(pn*PGSIZE),0,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  80122d:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801234:	00 
  801235:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801239:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801240:	00 
  801241:	89 74 24 04          	mov    %esi,0x4(%esp)
  801245:	89 1c 24             	mov    %ebx,(%esp)
  801248:	e8 5b fd ff ff       	call   800fa8 <sys_page_map>
  80124d:	85 c0                	test   %eax,%eax
  80124f:	79 27                	jns    801278 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  801251:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801255:	c7 44 24 08 8b 30 80 	movl   $0x80308b,0x8(%esp)
  80125c:	00 
  80125d:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801264:	00 
  801265:	c7 04 24 80 30 80 00 	movl   $0x803080,(%esp)
  80126c:	e8 bb 16 00 00       	call   80292c <_panic>
  801271:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801276:	eb 05                	jmp    80127d <duppage+0x12f>
  801278:	b8 00 00 00 00       	mov    $0x0,%eax
         }


//	panic("duppage not implemented");
	return 0;
}
  80127d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801280:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801283:	89 ec                	mov    %ebp,%esp
  801285:	5d                   	pop    %ebp
  801286:	c3                   	ret    

00801287 <fork>:
//


envid_t
fork(void)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
  80128a:	56                   	push   %esi
  80128b:	53                   	push   %ebx
  80128c:	83 ec 10             	sub    $0x10,%esp

        envid_t envid;
        uint8_t *addr;
        int r;
        extern unsigned char end[];
        set_pgfault_handler(pgfault);
  80128f:	c7 04 24 9e 13 80 00 	movl   $0x80139e,(%esp)
  801296:	e8 f5 16 00 00       	call   802990 <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80129b:	be 07 00 00 00       	mov    $0x7,%esi
  8012a0:	89 f0                	mov    %esi,%eax
  8012a2:	cd 30                	int    $0x30
  8012a4:	89 c6                	mov    %eax,%esi

        envid = sys_exofork();
        if (envid < 0)
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	79 20                	jns    8012ca <fork+0x43>
                panic("sys_exofork: %e", envid);
  8012aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012ae:	c7 44 24 08 9c 30 80 	movl   $0x80309c,0x8(%esp)
  8012b5:	00 
  8012b6:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  8012bd:	00 
  8012be:	c7 04 24 80 30 80 00 	movl   $0x803080,(%esp)
  8012c5:	e8 62 16 00 00       	call   80292c <_panic>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
  8012ca:	bb 00 00 80 00       	mov    $0x800000,%ebx
        set_pgfault_handler(pgfault);

        envid = sys_exofork();
        if (envid < 0)
                panic("sys_exofork: %e", envid);
        if (envid == 0) {
  8012cf:	85 c0                	test   %eax,%eax
  8012d1:	75 1c                	jne    8012ef <fork+0x68>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
  8012d3:	e8 c1 fd ff ff       	call   801099 <sys_getenvid>
  8012d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8012dd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8012e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8012e5:	a3 74 70 80 00       	mov    %eax,0x807074
                return 0;
  8012ea:	e9 a6 00 00 00       	jmp    801395 <fork+0x10e>
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
  8012ef:	89 da                	mov    %ebx,%edx
  8012f1:	c1 ea 0c             	shr    $0xc,%edx
  8012f4:	89 f0                	mov    %esi,%eax
  8012f6:	e8 53 fe ff ff       	call   80114e <duppage>
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
  8012fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801301:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801307:	75 e6                	jne    8012ef <fork+0x68>
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
                }
              duppage(envid,VPN(USTACKTOP-PGSIZE));
  801309:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80130e:	89 f0                	mov    %esi,%eax
  801310:	e8 39 fe ff ff       	call   80114e <duppage>
        // Also copy the stack we are currently running on.
       //if(sys_page_alloc(envid, (void *)(ROUNDDOWN(&addr, PGSIZE)),PTE_U|PTE_P|PTE_W)<0)
         //                      panic("stack not allocated");
     
   
     sys_env_set_pgfault_upcall(envid,env->env_pgfault_upcall);
  801315:	a1 74 70 80 00       	mov    0x807074,%eax
  80131a:	8b 40 64             	mov    0x64(%eax),%eax
  80131d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801321:	89 34 24             	mov    %esi,(%esp)
  801324:	e8 07 fb ff ff       	call   800e30 <sys_env_set_pgfault_upcall>

     if(sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  801329:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801330:	00 
  801331:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801338:	ee 
  801339:	89 34 24             	mov    %esi,(%esp)
  80133c:	e8 c5 fc ff ff       	call   801006 <sys_page_alloc>
  801341:	85 c0                	test   %eax,%eax
  801343:	79 1c                	jns    801361 <fork+0xda>
                          panic("Cant allocate Page");
  801345:	c7 44 24 08 ac 30 80 	movl   $0x8030ac,0x8(%esp)
  80134c:	00 
  80134d:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  801354:	00 
  801355:	c7 04 24 80 30 80 00 	movl   $0x803080,(%esp)
  80135c:	e8 cb 15 00 00       	call   80292c <_panic>

        // Start the child environment running
        if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801361:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801368:	00 
  801369:	89 34 24             	mov    %esi,(%esp)
  80136c:	e8 7b fb ff ff       	call   800eec <sys_env_set_status>
  801371:	85 c0                	test   %eax,%eax
  801373:	79 20                	jns    801395 <fork+0x10e>
                panic("sys_env_set_status: %e", r);
  801375:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801379:	c7 44 24 08 bf 30 80 	movl   $0x8030bf,0x8(%esp)
  801380:	00 
  801381:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  801388:	00 
  801389:	c7 04 24 80 30 80 00 	movl   $0x803080,(%esp)
  801390:	e8 97 15 00 00       	call   80292c <_panic>
         return envid;
           
//panic("fork not implemented");
}
  801395:	89 f0                	mov    %esi,%eax
  801397:	83 c4 10             	add    $0x10,%esp
  80139a:	5b                   	pop    %ebx
  80139b:	5e                   	pop    %esi
  80139c:	5d                   	pop    %ebp
  80139d:	c3                   	ret    

0080139e <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  80139e:	55                   	push   %ebp
  80139f:	89 e5                	mov    %esp,%ebp
  8013a1:	53                   	push   %ebx
  8013a2:	83 ec 24             	sub    $0x24,%esp
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8013a8:	8b 18                	mov    (%eax),%ebx
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).
 
         int perm = vpt[VPN(addr)] & 0xFFF;
  8013aa:	89 da                	mov    %ebx,%edx
  8013ac:	c1 ea 0c             	shr    $0xc,%edx
  8013af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx

static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
  8013b6:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8013ba:	74 21                	je     8013dd <pgfault+0x3f>
 
         int perm = vpt[VPN(addr)] & 0xFFF;
        if((err & FEC_WR)!=0)
           {
//              cprintf("\n>>>>>Due to write\n");
            if((perm & PTE_COW) == 0)
  8013bc:	f6 c6 08             	test   $0x8,%dh
  8013bf:	75 1c                	jne    8013dd <pgfault+0x3f>
             {
                   panic("Not Set Cow");
  8013c1:	c7 44 24 08 d6 30 80 	movl   $0x8030d6,0x8(%esp)
  8013c8:	00 
  8013c9:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8013d0:	00 
  8013d1:	c7 04 24 80 30 80 00 	movl   $0x803080,(%esp)
  8013d8:	e8 4f 15 00 00       	call   80292c <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
        if(sys_page_alloc(0,PFTEMP,PTE_P|PTE_U|PTE_W)<0)
  8013dd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013e4:	00 
  8013e5:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8013ec:	00 
  8013ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013f4:	e8 0d fc ff ff       	call   801006 <sys_page_alloc>
  8013f9:	85 c0                	test   %eax,%eax
  8013fb:	79 1c                	jns    801419 <pgfault+0x7b>
              panic("\nPage not allocated\n");
  8013fd:	c7 44 24 08 e2 30 80 	movl   $0x8030e2,0x8(%esp)
  801404:	00 
  801405:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  80140c:	00 
  80140d:	c7 04 24 80 30 80 00 	movl   $0x803080,(%esp)
  801414:	e8 13 15 00 00       	call   80292c <_panic>
           memmove(PFTEMP,ROUNDDOWN(addr,PGSIZE),PGSIZE);
  801419:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80141f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801426:	00 
  801427:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80142b:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801432:	e8 2e f6 ff ff       	call   800a65 <memmove>
          if(sys_page_map(0,ROUNDDOWN(PFTEMP,PGSIZE),0,ROUNDDOWN(addr,PGSIZE),PTE_U|PTE_P|PTE_W)<0)
  801437:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80143e:	00 
  80143f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801443:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80144a:	00 
  80144b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801452:	00 
  801453:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80145a:	e8 49 fb ff ff       	call   800fa8 <sys_page_map>
  80145f:	85 c0                	test   %eax,%eax
  801461:	79 1c                	jns    80147f <pgfault+0xe1>
                   panic("not mapped properly");
  801463:	c7 44 24 08 f7 30 80 	movl   $0x8030f7,0x8(%esp)
  80146a:	00 
  80146b:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801472:	00 
  801473:	c7 04 24 80 30 80 00 	movl   $0x803080,(%esp)
  80147a:	e8 ad 14 00 00       	call   80292c <_panic>
         if( 0 > sys_page_unmap(0, PFTEMP) )
  80147f:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801486:	00 
  801487:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80148e:	e8 b7 fa ff ff       	call   800f4a <sys_page_unmap>
  801493:	85 c0                	test   %eax,%eax
  801495:	79 1c                	jns    8014b3 <pgfault+0x115>
                panic("sys_page_unmap failed\n");
  801497:	c7 44 24 08 0b 31 80 	movl   $0x80310b,0x8(%esp)
  80149e:	00 
  80149f:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  8014a6:	00 
  8014a7:	c7 04 24 80 30 80 00 	movl   $0x803080,(%esp)
  8014ae:	e8 79 14 00 00       	call   80292c <_panic>
   
//	panic("pgfault not implemented");
}
  8014b3:	83 c4 24             	add    $0x24,%esp
  8014b6:	5b                   	pop    %ebx
  8014b7:	5d                   	pop    %ebp
  8014b8:	c3                   	ret    
  8014b9:	00 00                	add    %al,(%eax)
  8014bb:	00 00                	add    %al,(%eax)
  8014bd:	00 00                	add    %al,(%eax)
	...

008014c0 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8014c0:	55                   	push   %ebp
  8014c1:	89 e5                	mov    %esp,%ebp
  8014c3:	57                   	push   %edi
  8014c4:	56                   	push   %esi
  8014c5:	53                   	push   %ebx
  8014c6:	83 ec 1c             	sub    $0x1c,%esp
  8014c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8014cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014cf:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  8014d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014d9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8014dd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014e1:	89 1c 24             	mov    %ebx,(%esp)
  8014e4:	e8 0f f9 ff ff       	call   800df8 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  8014e9:	85 c0                	test   %eax,%eax
  8014eb:	79 21                	jns    80150e <ipc_send+0x4e>
  8014ed:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8014f0:	74 1c                	je     80150e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  8014f2:	c7 44 24 08 22 31 80 	movl   $0x803122,0x8(%esp)
  8014f9:	00 
  8014fa:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  801501:	00 
  801502:	c7 04 24 34 31 80 00 	movl   $0x803134,(%esp)
  801509:	e8 1e 14 00 00       	call   80292c <_panic>
          else if(r==-E_IPC_NOT_RECV)
  80150e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801511:	75 07                	jne    80151a <ipc_send+0x5a>
           sys_yield();
  801513:	e8 4d fb ff ff       	call   801065 <sys_yield>
          else
            break;
        }
  801518:	eb b8                	jmp    8014d2 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  80151a:	83 c4 1c             	add    $0x1c,%esp
  80151d:	5b                   	pop    %ebx
  80151e:	5e                   	pop    %esi
  80151f:	5f                   	pop    %edi
  801520:	5d                   	pop    %ebp
  801521:	c3                   	ret    

00801522 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801522:	55                   	push   %ebp
  801523:	89 e5                	mov    %esp,%ebp
  801525:	83 ec 18             	sub    $0x18,%esp
  801528:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80152b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80152e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801531:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  801534:	8b 45 0c             	mov    0xc(%ebp),%eax
  801537:	89 04 24             	mov    %eax,(%esp)
  80153a:	e8 5c f8 ff ff       	call   800d9b <sys_ipc_recv>
        if(r<0)
  80153f:	85 c0                	test   %eax,%eax
  801541:	79 17                	jns    80155a <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  801543:	85 db                	test   %ebx,%ebx
  801545:	74 06                	je     80154d <ipc_recv+0x2b>
               *from_env_store =0;
  801547:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  80154d:	85 f6                	test   %esi,%esi
  80154f:	90                   	nop
  801550:	74 2c                	je     80157e <ipc_recv+0x5c>
              *perm_store=0;
  801552:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  801558:	eb 24                	jmp    80157e <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  80155a:	85 db                	test   %ebx,%ebx
  80155c:	74 0a                	je     801568 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  80155e:	a1 74 70 80 00       	mov    0x807074,%eax
  801563:	8b 40 74             	mov    0x74(%eax),%eax
  801566:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  801568:	85 f6                	test   %esi,%esi
  80156a:	74 0a                	je     801576 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  80156c:	a1 74 70 80 00       	mov    0x807074,%eax
  801571:	8b 40 78             	mov    0x78(%eax),%eax
  801574:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  801576:	a1 74 70 80 00       	mov    0x807074,%eax
  80157b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80157e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801581:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801584:	89 ec                	mov    %ebp,%esp
  801586:	5d                   	pop    %ebp
  801587:	c3                   	ret    
	...

00801590 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	8b 45 08             	mov    0x8(%ebp),%eax
  801596:	05 00 00 00 30       	add    $0x30000000,%eax
  80159b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80159e:	5d                   	pop    %ebp
  80159f:	c3                   	ret    

008015a0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8015a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a9:	89 04 24             	mov    %eax,(%esp)
  8015ac:	e8 df ff ff ff       	call   801590 <fd2num>
  8015b1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8015b6:	c1 e0 0c             	shl    $0xc,%eax
}
  8015b9:	c9                   	leave  
  8015ba:	c3                   	ret    

008015bb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015bb:	55                   	push   %ebp
  8015bc:	89 e5                	mov    %esp,%ebp
  8015be:	57                   	push   %edi
  8015bf:	56                   	push   %esi
  8015c0:	53                   	push   %ebx
  8015c1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8015c4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8015c9:	a8 01                	test   $0x1,%al
  8015cb:	74 36                	je     801603 <fd_alloc+0x48>
  8015cd:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8015d2:	a8 01                	test   $0x1,%al
  8015d4:	74 2d                	je     801603 <fd_alloc+0x48>
  8015d6:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  8015db:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8015e0:	be 00 00 40 ef       	mov    $0xef400000,%esi
  8015e5:	89 c3                	mov    %eax,%ebx
  8015e7:	89 c2                	mov    %eax,%edx
  8015e9:	c1 ea 16             	shr    $0x16,%edx
  8015ec:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8015ef:	f6 c2 01             	test   $0x1,%dl
  8015f2:	74 14                	je     801608 <fd_alloc+0x4d>
  8015f4:	89 c2                	mov    %eax,%edx
  8015f6:	c1 ea 0c             	shr    $0xc,%edx
  8015f9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  8015fc:	f6 c2 01             	test   $0x1,%dl
  8015ff:	75 10                	jne    801611 <fd_alloc+0x56>
  801601:	eb 05                	jmp    801608 <fd_alloc+0x4d>
  801603:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801608:	89 1f                	mov    %ebx,(%edi)
  80160a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80160f:	eb 17                	jmp    801628 <fd_alloc+0x6d>
  801611:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801616:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80161b:	75 c8                	jne    8015e5 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80161d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801623:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801628:	5b                   	pop    %ebx
  801629:	5e                   	pop    %esi
  80162a:	5f                   	pop    %edi
  80162b:	5d                   	pop    %ebp
  80162c:	c3                   	ret    

0080162d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801630:	8b 45 08             	mov    0x8(%ebp),%eax
  801633:	83 f8 1f             	cmp    $0x1f,%eax
  801636:	77 36                	ja     80166e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801638:	05 00 00 0d 00       	add    $0xd0000,%eax
  80163d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801640:	89 c2                	mov    %eax,%edx
  801642:	c1 ea 16             	shr    $0x16,%edx
  801645:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80164c:	f6 c2 01             	test   $0x1,%dl
  80164f:	74 1d                	je     80166e <fd_lookup+0x41>
  801651:	89 c2                	mov    %eax,%edx
  801653:	c1 ea 0c             	shr    $0xc,%edx
  801656:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80165d:	f6 c2 01             	test   $0x1,%dl
  801660:	74 0c                	je     80166e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801662:	8b 55 0c             	mov    0xc(%ebp),%edx
  801665:	89 02                	mov    %eax,(%edx)
  801667:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80166c:	eb 05                	jmp    801673 <fd_lookup+0x46>
  80166e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801673:	5d                   	pop    %ebp
  801674:	c3                   	ret    

00801675 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80167b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80167e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	89 04 24             	mov    %eax,(%esp)
  801688:	e8 a0 ff ff ff       	call   80162d <fd_lookup>
  80168d:	85 c0                	test   %eax,%eax
  80168f:	78 0e                	js     80169f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801691:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801694:	8b 55 0c             	mov    0xc(%ebp),%edx
  801697:	89 50 04             	mov    %edx,0x4(%eax)
  80169a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80169f:	c9                   	leave  
  8016a0:	c3                   	ret    

008016a1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016a1:	55                   	push   %ebp
  8016a2:	89 e5                	mov    %esp,%ebp
  8016a4:	56                   	push   %esi
  8016a5:	53                   	push   %ebx
  8016a6:	83 ec 10             	sub    $0x10,%esp
  8016a9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8016af:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  8016b4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8016b9:	be c0 31 80 00       	mov    $0x8031c0,%esi
		if (devtab[i]->dev_id == dev_id) {
  8016be:	39 08                	cmp    %ecx,(%eax)
  8016c0:	75 10                	jne    8016d2 <dev_lookup+0x31>
  8016c2:	eb 04                	jmp    8016c8 <dev_lookup+0x27>
  8016c4:	39 08                	cmp    %ecx,(%eax)
  8016c6:	75 0a                	jne    8016d2 <dev_lookup+0x31>
			*dev = devtab[i];
  8016c8:	89 03                	mov    %eax,(%ebx)
  8016ca:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8016cf:	90                   	nop
  8016d0:	eb 31                	jmp    801703 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8016d2:	83 c2 01             	add    $0x1,%edx
  8016d5:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8016d8:	85 c0                	test   %eax,%eax
  8016da:	75 e8                	jne    8016c4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8016dc:	a1 74 70 80 00       	mov    0x807074,%eax
  8016e1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8016e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8016e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ec:	c7 04 24 40 31 80 00 	movl   $0x803140,(%esp)
  8016f3:	e8 cd ea ff ff       	call   8001c5 <cprintf>
	*dev = 0;
  8016f8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8016fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801703:	83 c4 10             	add    $0x10,%esp
  801706:	5b                   	pop    %ebx
  801707:	5e                   	pop    %esi
  801708:	5d                   	pop    %ebp
  801709:	c3                   	ret    

0080170a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	53                   	push   %ebx
  80170e:	83 ec 24             	sub    $0x24,%esp
  801711:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801714:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801717:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	89 04 24             	mov    %eax,(%esp)
  801721:	e8 07 ff ff ff       	call   80162d <fd_lookup>
  801726:	85 c0                	test   %eax,%eax
  801728:	78 53                	js     80177d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80172a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80172d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801734:	8b 00                	mov    (%eax),%eax
  801736:	89 04 24             	mov    %eax,(%esp)
  801739:	e8 63 ff ff ff       	call   8016a1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80173e:	85 c0                	test   %eax,%eax
  801740:	78 3b                	js     80177d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801742:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801747:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80174e:	74 2d                	je     80177d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801750:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801753:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80175a:	00 00 00 
	stat->st_isdir = 0;
  80175d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801764:	00 00 00 
	stat->st_dev = dev;
  801767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80176a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801770:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801774:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801777:	89 14 24             	mov    %edx,(%esp)
  80177a:	ff 50 14             	call   *0x14(%eax)
}
  80177d:	83 c4 24             	add    $0x24,%esp
  801780:	5b                   	pop    %ebx
  801781:	5d                   	pop    %ebp
  801782:	c3                   	ret    

00801783 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801783:	55                   	push   %ebp
  801784:	89 e5                	mov    %esp,%ebp
  801786:	53                   	push   %ebx
  801787:	83 ec 24             	sub    $0x24,%esp
  80178a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80178d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801790:	89 44 24 04          	mov    %eax,0x4(%esp)
  801794:	89 1c 24             	mov    %ebx,(%esp)
  801797:	e8 91 fe ff ff       	call   80162d <fd_lookup>
  80179c:	85 c0                	test   %eax,%eax
  80179e:	78 5f                	js     8017ff <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017aa:	8b 00                	mov    (%eax),%eax
  8017ac:	89 04 24             	mov    %eax,(%esp)
  8017af:	e8 ed fe ff ff       	call   8016a1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b4:	85 c0                	test   %eax,%eax
  8017b6:	78 47                	js     8017ff <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017bb:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8017bf:	75 23                	jne    8017e4 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8017c1:	a1 74 70 80 00       	mov    0x807074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8017c6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8017c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d1:	c7 04 24 60 31 80 00 	movl   $0x803160,(%esp)
  8017d8:	e8 e8 e9 ff ff       	call   8001c5 <cprintf>
  8017dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  8017e2:	eb 1b                	jmp    8017ff <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8017e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e7:	8b 48 18             	mov    0x18(%eax),%ecx
  8017ea:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017ef:	85 c9                	test   %ecx,%ecx
  8017f1:	74 0c                	je     8017ff <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8017f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017fa:	89 14 24             	mov    %edx,(%esp)
  8017fd:	ff d1                	call   *%ecx
}
  8017ff:	83 c4 24             	add    $0x24,%esp
  801802:	5b                   	pop    %ebx
  801803:	5d                   	pop    %ebp
  801804:	c3                   	ret    

00801805 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	53                   	push   %ebx
  801809:	83 ec 24             	sub    $0x24,%esp
  80180c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80180f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801812:	89 44 24 04          	mov    %eax,0x4(%esp)
  801816:	89 1c 24             	mov    %ebx,(%esp)
  801819:	e8 0f fe ff ff       	call   80162d <fd_lookup>
  80181e:	85 c0                	test   %eax,%eax
  801820:	78 66                	js     801888 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801822:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801825:	89 44 24 04          	mov    %eax,0x4(%esp)
  801829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182c:	8b 00                	mov    (%eax),%eax
  80182e:	89 04 24             	mov    %eax,(%esp)
  801831:	e8 6b fe ff ff       	call   8016a1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801836:	85 c0                	test   %eax,%eax
  801838:	78 4e                	js     801888 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80183a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80183d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801841:	75 23                	jne    801866 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801843:	a1 74 70 80 00       	mov    0x807074,%eax
  801848:	8b 40 4c             	mov    0x4c(%eax),%eax
  80184b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80184f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801853:	c7 04 24 84 31 80 00 	movl   $0x803184,(%esp)
  80185a:	e8 66 e9 ff ff       	call   8001c5 <cprintf>
  80185f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801864:	eb 22                	jmp    801888 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801869:	8b 48 0c             	mov    0xc(%eax),%ecx
  80186c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801871:	85 c9                	test   %ecx,%ecx
  801873:	74 13                	je     801888 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801875:	8b 45 10             	mov    0x10(%ebp),%eax
  801878:	89 44 24 08          	mov    %eax,0x8(%esp)
  80187c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801883:	89 14 24             	mov    %edx,(%esp)
  801886:	ff d1                	call   *%ecx
}
  801888:	83 c4 24             	add    $0x24,%esp
  80188b:	5b                   	pop    %ebx
  80188c:	5d                   	pop    %ebp
  80188d:	c3                   	ret    

0080188e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	53                   	push   %ebx
  801892:	83 ec 24             	sub    $0x24,%esp
  801895:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801898:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80189b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189f:	89 1c 24             	mov    %ebx,(%esp)
  8018a2:	e8 86 fd ff ff       	call   80162d <fd_lookup>
  8018a7:	85 c0                	test   %eax,%eax
  8018a9:	78 6b                	js     801916 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b5:	8b 00                	mov    (%eax),%eax
  8018b7:	89 04 24             	mov    %eax,(%esp)
  8018ba:	e8 e2 fd ff ff       	call   8016a1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	78 53                	js     801916 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8018c3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018c6:	8b 42 08             	mov    0x8(%edx),%eax
  8018c9:	83 e0 03             	and    $0x3,%eax
  8018cc:	83 f8 01             	cmp    $0x1,%eax
  8018cf:	75 23                	jne    8018f4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8018d1:	a1 74 70 80 00       	mov    0x807074,%eax
  8018d6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8018d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e1:	c7 04 24 a1 31 80 00 	movl   $0x8031a1,(%esp)
  8018e8:	e8 d8 e8 ff ff       	call   8001c5 <cprintf>
  8018ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8018f2:	eb 22                	jmp    801916 <read+0x88>
	}
	if (!dev->dev_read)
  8018f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f7:	8b 48 08             	mov    0x8(%eax),%ecx
  8018fa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018ff:	85 c9                	test   %ecx,%ecx
  801901:	74 13                	je     801916 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801903:	8b 45 10             	mov    0x10(%ebp),%eax
  801906:	89 44 24 08          	mov    %eax,0x8(%esp)
  80190a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80190d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801911:	89 14 24             	mov    %edx,(%esp)
  801914:	ff d1                	call   *%ecx
}
  801916:	83 c4 24             	add    $0x24,%esp
  801919:	5b                   	pop    %ebx
  80191a:	5d                   	pop    %ebp
  80191b:	c3                   	ret    

0080191c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	57                   	push   %edi
  801920:	56                   	push   %esi
  801921:	53                   	push   %ebx
  801922:	83 ec 1c             	sub    $0x1c,%esp
  801925:	8b 7d 08             	mov    0x8(%ebp),%edi
  801928:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80192b:	ba 00 00 00 00       	mov    $0x0,%edx
  801930:	bb 00 00 00 00       	mov    $0x0,%ebx
  801935:	b8 00 00 00 00       	mov    $0x0,%eax
  80193a:	85 f6                	test   %esi,%esi
  80193c:	74 29                	je     801967 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80193e:	89 f0                	mov    %esi,%eax
  801940:	29 d0                	sub    %edx,%eax
  801942:	89 44 24 08          	mov    %eax,0x8(%esp)
  801946:	03 55 0c             	add    0xc(%ebp),%edx
  801949:	89 54 24 04          	mov    %edx,0x4(%esp)
  80194d:	89 3c 24             	mov    %edi,(%esp)
  801950:	e8 39 ff ff ff       	call   80188e <read>
		if (m < 0)
  801955:	85 c0                	test   %eax,%eax
  801957:	78 0e                	js     801967 <readn+0x4b>
			return m;
		if (m == 0)
  801959:	85 c0                	test   %eax,%eax
  80195b:	74 08                	je     801965 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80195d:	01 c3                	add    %eax,%ebx
  80195f:	89 da                	mov    %ebx,%edx
  801961:	39 f3                	cmp    %esi,%ebx
  801963:	72 d9                	jb     80193e <readn+0x22>
  801965:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801967:	83 c4 1c             	add    $0x1c,%esp
  80196a:	5b                   	pop    %ebx
  80196b:	5e                   	pop    %esi
  80196c:	5f                   	pop    %edi
  80196d:	5d                   	pop    %ebp
  80196e:	c3                   	ret    

0080196f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	56                   	push   %esi
  801973:	53                   	push   %ebx
  801974:	83 ec 20             	sub    $0x20,%esp
  801977:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80197a:	89 34 24             	mov    %esi,(%esp)
  80197d:	e8 0e fc ff ff       	call   801590 <fd2num>
  801982:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801985:	89 54 24 04          	mov    %edx,0x4(%esp)
  801989:	89 04 24             	mov    %eax,(%esp)
  80198c:	e8 9c fc ff ff       	call   80162d <fd_lookup>
  801991:	89 c3                	mov    %eax,%ebx
  801993:	85 c0                	test   %eax,%eax
  801995:	78 05                	js     80199c <fd_close+0x2d>
  801997:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80199a:	74 0c                	je     8019a8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80199c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019a0:	19 c0                	sbb    %eax,%eax
  8019a2:	f7 d0                	not    %eax
  8019a4:	21 c3                	and    %eax,%ebx
  8019a6:	eb 3d                	jmp    8019e5 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8019a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019af:	8b 06                	mov    (%esi),%eax
  8019b1:	89 04 24             	mov    %eax,(%esp)
  8019b4:	e8 e8 fc ff ff       	call   8016a1 <dev_lookup>
  8019b9:	89 c3                	mov    %eax,%ebx
  8019bb:	85 c0                	test   %eax,%eax
  8019bd:	78 16                	js     8019d5 <fd_close+0x66>
		if (dev->dev_close)
  8019bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c2:	8b 40 10             	mov    0x10(%eax),%eax
  8019c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019ca:	85 c0                	test   %eax,%eax
  8019cc:	74 07                	je     8019d5 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  8019ce:	89 34 24             	mov    %esi,(%esp)
  8019d1:	ff d0                	call   *%eax
  8019d3:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8019d5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8019d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019e0:	e8 65 f5 ff ff       	call   800f4a <sys_page_unmap>
	return r;
}
  8019e5:	89 d8                	mov    %ebx,%eax
  8019e7:	83 c4 20             	add    $0x20,%esp
  8019ea:	5b                   	pop    %ebx
  8019eb:	5e                   	pop    %esi
  8019ec:	5d                   	pop    %ebp
  8019ed:	c3                   	ret    

008019ee <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	89 04 24             	mov    %eax,(%esp)
  801a01:	e8 27 fc ff ff       	call   80162d <fd_lookup>
  801a06:	85 c0                	test   %eax,%eax
  801a08:	78 13                	js     801a1d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801a0a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801a11:	00 
  801a12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a15:	89 04 24             	mov    %eax,(%esp)
  801a18:	e8 52 ff ff ff       	call   80196f <fd_close>
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	83 ec 18             	sub    $0x18,%esp
  801a25:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801a28:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a2b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a32:	00 
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	89 04 24             	mov    %eax,(%esp)
  801a39:	e8 a9 03 00 00       	call   801de7 <open>
  801a3e:	89 c3                	mov    %eax,%ebx
  801a40:	85 c0                	test   %eax,%eax
  801a42:	78 1b                	js     801a5f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801a44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4b:	89 1c 24             	mov    %ebx,(%esp)
  801a4e:	e8 b7 fc ff ff       	call   80170a <fstat>
  801a53:	89 c6                	mov    %eax,%esi
	close(fd);
  801a55:	89 1c 24             	mov    %ebx,(%esp)
  801a58:	e8 91 ff ff ff       	call   8019ee <close>
  801a5d:	89 f3                	mov    %esi,%ebx
	return r;
}
  801a5f:	89 d8                	mov    %ebx,%eax
  801a61:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801a64:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801a67:	89 ec                	mov    %ebp,%esp
  801a69:	5d                   	pop    %ebp
  801a6a:	c3                   	ret    

00801a6b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801a6b:	55                   	push   %ebp
  801a6c:	89 e5                	mov    %esp,%ebp
  801a6e:	53                   	push   %ebx
  801a6f:	83 ec 14             	sub    $0x14,%esp
  801a72:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801a77:	89 1c 24             	mov    %ebx,(%esp)
  801a7a:	e8 6f ff ff ff       	call   8019ee <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801a7f:	83 c3 01             	add    $0x1,%ebx
  801a82:	83 fb 20             	cmp    $0x20,%ebx
  801a85:	75 f0                	jne    801a77 <close_all+0xc>
		close(i);
}
  801a87:	83 c4 14             	add    $0x14,%esp
  801a8a:	5b                   	pop    %ebx
  801a8b:	5d                   	pop    %ebp
  801a8c:	c3                   	ret    

00801a8d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
  801a90:	83 ec 58             	sub    $0x58,%esp
  801a93:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a96:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a99:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801a9c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801a9f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa9:	89 04 24             	mov    %eax,(%esp)
  801aac:	e8 7c fb ff ff       	call   80162d <fd_lookup>
  801ab1:	89 c3                	mov    %eax,%ebx
  801ab3:	85 c0                	test   %eax,%eax
  801ab5:	0f 88 e0 00 00 00    	js     801b9b <dup+0x10e>
		return r;
	close(newfdnum);
  801abb:	89 3c 24             	mov    %edi,(%esp)
  801abe:	e8 2b ff ff ff       	call   8019ee <close>

	newfd = INDEX2FD(newfdnum);
  801ac3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801ac9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801acc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801acf:	89 04 24             	mov    %eax,(%esp)
  801ad2:	e8 c9 fa ff ff       	call   8015a0 <fd2data>
  801ad7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801ad9:	89 34 24             	mov    %esi,(%esp)
  801adc:	e8 bf fa ff ff       	call   8015a0 <fd2data>
  801ae1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801ae4:	89 da                	mov    %ebx,%edx
  801ae6:	89 d8                	mov    %ebx,%eax
  801ae8:	c1 e8 16             	shr    $0x16,%eax
  801aeb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801af2:	a8 01                	test   $0x1,%al
  801af4:	74 43                	je     801b39 <dup+0xac>
  801af6:	c1 ea 0c             	shr    $0xc,%edx
  801af9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801b00:	a8 01                	test   $0x1,%al
  801b02:	74 35                	je     801b39 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801b04:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801b0b:	25 07 0e 00 00       	and    $0xe07,%eax
  801b10:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b14:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b1b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b22:	00 
  801b23:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b27:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b2e:	e8 75 f4 ff ff       	call   800fa8 <sys_page_map>
  801b33:	89 c3                	mov    %eax,%ebx
  801b35:	85 c0                	test   %eax,%eax
  801b37:	78 3f                	js     801b78 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801b39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b3c:	89 c2                	mov    %eax,%edx
  801b3e:	c1 ea 0c             	shr    $0xc,%edx
  801b41:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801b48:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801b4e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801b52:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801b56:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b5d:	00 
  801b5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b69:	e8 3a f4 ff ff       	call   800fa8 <sys_page_map>
  801b6e:	89 c3                	mov    %eax,%ebx
  801b70:	85 c0                	test   %eax,%eax
  801b72:	78 04                	js     801b78 <dup+0xeb>
  801b74:	89 fb                	mov    %edi,%ebx
  801b76:	eb 23                	jmp    801b9b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801b78:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b7c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b83:	e8 c2 f3 ff ff       	call   800f4a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801b88:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b96:	e8 af f3 ff ff       	call   800f4a <sys_page_unmap>
	return r;
}
  801b9b:	89 d8                	mov    %ebx,%eax
  801b9d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801ba0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801ba3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ba6:	89 ec                	mov    %ebp,%esp
  801ba8:	5d                   	pop    %ebp
  801ba9:	c3                   	ret    
	...

00801bac <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	53                   	push   %ebx
  801bb0:	83 ec 14             	sub    $0x14,%esp
  801bb3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801bb5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801bbb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801bc2:	00 
  801bc3:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801bca:	00 
  801bcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bcf:	89 14 24             	mov    %edx,(%esp)
  801bd2:	e8 e9 f8 ff ff       	call   8014c0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801bd7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bde:	00 
  801bdf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801be3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bea:	e8 33 f9 ff ff       	call   801522 <ipc_recv>
}
  801bef:	83 c4 14             	add    $0x14,%esp
  801bf2:	5b                   	pop    %ebx
  801bf3:	5d                   	pop    %ebp
  801bf4:	c3                   	ret    

00801bf5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
  801bf8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	8b 40 0c             	mov    0xc(%eax),%eax
  801c01:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801c06:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c09:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c0e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c13:	b8 02 00 00 00       	mov    $0x2,%eax
  801c18:	e8 8f ff ff ff       	call   801bac <fsipc>
}
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
  801c22:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c25:	ba 00 00 00 00       	mov    $0x0,%edx
  801c2a:	b8 08 00 00 00       	mov    $0x8,%eax
  801c2f:	e8 78 ff ff ff       	call   801bac <fsipc>
}
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    

00801c36 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c36:	55                   	push   %ebp
  801c37:	89 e5                	mov    %esp,%ebp
  801c39:	53                   	push   %ebx
  801c3a:	83 ec 14             	sub    $0x14,%esp
  801c3d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c40:	8b 45 08             	mov    0x8(%ebp),%eax
  801c43:	8b 40 0c             	mov    0xc(%eax),%eax
  801c46:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c4b:	ba 00 00 00 00       	mov    $0x0,%edx
  801c50:	b8 05 00 00 00       	mov    $0x5,%eax
  801c55:	e8 52 ff ff ff       	call   801bac <fsipc>
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	78 2b                	js     801c89 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801c5e:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801c65:	00 
  801c66:	89 1c 24             	mov    %ebx,(%esp)
  801c69:	e8 3c ec ff ff       	call   8008aa <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801c6e:	a1 80 40 80 00       	mov    0x804080,%eax
  801c73:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801c79:	a1 84 40 80 00       	mov    0x804084,%eax
  801c7e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801c84:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801c89:	83 c4 14             	add    $0x14,%esp
  801c8c:	5b                   	pop    %ebx
  801c8d:	5d                   	pop    %ebp
  801c8e:	c3                   	ret    

00801c8f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  801c95:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801c9c:	00 
  801c9d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ca4:	00 
  801ca5:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801cac:	e8 55 ed ff ff       	call   800a06 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb4:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb7:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801cbc:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc1:	b8 06 00 00 00       	mov    $0x6,%eax
  801cc6:	e8 e1 fe ff ff       	call   801bac <fsipc>
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
  801cd0:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801cd3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801cda:	00 
  801cdb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ce2:	00 
  801ce3:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801cea:	e8 17 ed ff ff       	call   800a06 <memset>
  801cef:	8b 45 10             	mov    0x10(%ebp),%eax
  801cf2:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801cf7:	76 05                	jbe    801cfe <devfile_write+0x31>
  801cf9:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801cfe:	8b 55 08             	mov    0x8(%ebp),%edx
  801d01:	8b 52 0c             	mov    0xc(%edx),%edx
  801d04:	89 15 00 40 80 00    	mov    %edx,0x804000
        fsipcbuf.write.req_n = numberOfBytes;
  801d0a:	a3 04 40 80 00       	mov    %eax,0x804004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  801d0f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d16:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d1a:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801d21:	e8 3f ed ff ff       	call   800a65 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  801d26:	ba 00 00 00 00       	mov    $0x0,%edx
  801d2b:	b8 04 00 00 00       	mov    $0x4,%eax
  801d30:	e8 77 fe ff ff       	call   801bac <fsipc>
              return r;
        return r;
}
  801d35:	c9                   	leave  
  801d36:	c3                   	ret    

00801d37 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801d37:	55                   	push   %ebp
  801d38:	89 e5                	mov    %esp,%ebp
  801d3a:	53                   	push   %ebx
  801d3b:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  801d3e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801d45:	00 
  801d46:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d4d:	00 
  801d4e:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801d55:	e8 ac ec ff ff       	call   800a06 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  801d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5d:	8b 40 0c             	mov    0xc(%eax),%eax
  801d60:	a3 00 40 80 00       	mov    %eax,0x804000
        fsipcbuf.read.req_n = n;
  801d65:	8b 45 10             	mov    0x10(%ebp),%eax
  801d68:	a3 04 40 80 00       	mov    %eax,0x804004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  801d6d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d72:	b8 03 00 00 00       	mov    $0x3,%eax
  801d77:	e8 30 fe ff ff       	call   801bac <fsipc>
  801d7c:	89 c3                	mov    %eax,%ebx
  801d7e:	85 c0                	test   %eax,%eax
  801d80:	78 17                	js     801d99 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  801d82:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d86:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801d8d:	00 
  801d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d91:	89 04 24             	mov    %eax,(%esp)
  801d94:	e8 cc ec ff ff       	call   800a65 <memmove>
        return r;
}
  801d99:	89 d8                	mov    %ebx,%eax
  801d9b:	83 c4 14             	add    $0x14,%esp
  801d9e:	5b                   	pop    %ebx
  801d9f:	5d                   	pop    %ebp
  801da0:	c3                   	ret    

00801da1 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	53                   	push   %ebx
  801da5:	83 ec 14             	sub    $0x14,%esp
  801da8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801dab:	89 1c 24             	mov    %ebx,(%esp)
  801dae:	e8 ad ea ff ff       	call   800860 <strlen>
  801db3:	89 c2                	mov    %eax,%edx
  801db5:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801dba:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801dc0:	7f 1f                	jg     801de1 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801dc2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801dc6:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801dcd:	e8 d8 ea ff ff       	call   8008aa <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801dd2:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd7:	b8 07 00 00 00       	mov    $0x7,%eax
  801ddc:	e8 cb fd ff ff       	call   801bac <fsipc>
}
  801de1:	83 c4 14             	add    $0x14,%esp
  801de4:	5b                   	pop    %ebx
  801de5:	5d                   	pop    %ebp
  801de6:	c3                   	ret    

00801de7 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	56                   	push   %esi
  801deb:	53                   	push   %ebx
  801dec:	83 ec 20             	sub    $0x20,%esp
  801def:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  801df2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801df9:	00 
  801dfa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e01:	00 
  801e02:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e09:	e8 f8 eb ff ff       	call   800a06 <memset>
    if(strlen(path)>=MAXPATHLEN)
  801e0e:	89 34 24             	mov    %esi,(%esp)
  801e11:	e8 4a ea ff ff       	call   800860 <strlen>
  801e16:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e1b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e20:	0f 8f 84 00 00 00    	jg     801eaa <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  801e26:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e29:	89 04 24             	mov    %eax,(%esp)
  801e2c:	e8 8a f7 ff ff       	call   8015bb <fd_alloc>
  801e31:	89 c3                	mov    %eax,%ebx
  801e33:	85 c0                	test   %eax,%eax
  801e35:	78 73                	js     801eaa <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  801e37:	0f b6 06             	movzbl (%esi),%eax
  801e3a:	84 c0                	test   %al,%al
  801e3c:	74 20                	je     801e5e <open+0x77>
  801e3e:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  801e40:	0f be c0             	movsbl %al,%eax
  801e43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e47:	c7 04 24 d4 31 80 00 	movl   $0x8031d4,(%esp)
  801e4e:	e8 72 e3 ff ff       	call   8001c5 <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  801e53:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  801e57:	83 c3 01             	add    $0x1,%ebx
  801e5a:	84 c0                	test   %al,%al
  801e5c:	75 e2                	jne    801e40 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  801e5e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e62:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e69:	e8 3c ea ff ff       	call   8008aa <strcpy>
    fsipcbuf.open.req_omode = mode;
  801e6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e71:	a3 00 44 80 00       	mov    %eax,0x804400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  801e76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e79:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7e:	e8 29 fd ff ff       	call   801bac <fsipc>
  801e83:	89 c3                	mov    %eax,%ebx
  801e85:	85 c0                	test   %eax,%eax
  801e87:	79 15                	jns    801e9e <open+0xb7>
        {
            fd_close(fd,1);
  801e89:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801e90:	00 
  801e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e94:	89 04 24             	mov    %eax,(%esp)
  801e97:	e8 d3 fa ff ff       	call   80196f <fd_close>
             return r;
  801e9c:	eb 0c                	jmp    801eaa <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  801e9e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801ea1:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  801ea7:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  801eaa:	89 d8                	mov    %ebx,%eax
  801eac:	83 c4 20             	add    $0x20,%esp
  801eaf:	5b                   	pop    %ebx
  801eb0:	5e                   	pop    %esi
  801eb1:	5d                   	pop    %ebp
  801eb2:	c3                   	ret    
	...

00801ec0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801ec0:	55                   	push   %ebp
  801ec1:	89 e5                	mov    %esp,%ebp
  801ec3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801ec6:	c7 44 24 04 d7 31 80 	movl   $0x8031d7,0x4(%esp)
  801ecd:	00 
  801ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed1:	89 04 24             	mov    %eax,(%esp)
  801ed4:	e8 d1 e9 ff ff       	call   8008aa <strcpy>
	return 0;
}
  801ed9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ede:	c9                   	leave  
  801edf:	c3                   	ret    

00801ee0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801ee0:	55                   	push   %ebp
  801ee1:	89 e5                	mov    %esp,%ebp
  801ee3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee9:	8b 40 0c             	mov    0xc(%eax),%eax
  801eec:	89 04 24             	mov    %eax,(%esp)
  801eef:	e8 9e 02 00 00       	call   802192 <nsipc_close>
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801efc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f03:	00 
  801f04:	8b 45 10             	mov    0x10(%ebp),%eax
  801f07:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f12:	8b 45 08             	mov    0x8(%ebp),%eax
  801f15:	8b 40 0c             	mov    0xc(%eax),%eax
  801f18:	89 04 24             	mov    %eax,(%esp)
  801f1b:	e8 ae 02 00 00       	call   8021ce <nsipc_send>
}
  801f20:	c9                   	leave  
  801f21:	c3                   	ret    

00801f22 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801f22:	55                   	push   %ebp
  801f23:	89 e5                	mov    %esp,%ebp
  801f25:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f28:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f2f:	00 
  801f30:	8b 45 10             	mov    0x10(%ebp),%eax
  801f33:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f41:	8b 40 0c             	mov    0xc(%eax),%eax
  801f44:	89 04 24             	mov    %eax,(%esp)
  801f47:	e8 f5 02 00 00       	call   802241 <nsipc_recv>
}
  801f4c:	c9                   	leave  
  801f4d:	c3                   	ret    

00801f4e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801f4e:	55                   	push   %ebp
  801f4f:	89 e5                	mov    %esp,%ebp
  801f51:	56                   	push   %esi
  801f52:	53                   	push   %ebx
  801f53:	83 ec 20             	sub    $0x20,%esp
  801f56:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f5b:	89 04 24             	mov    %eax,(%esp)
  801f5e:	e8 58 f6 ff ff       	call   8015bb <fd_alloc>
  801f63:	89 c3                	mov    %eax,%ebx
  801f65:	85 c0                	test   %eax,%eax
  801f67:	78 21                	js     801f8a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801f69:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801f70:	00 
  801f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f7f:	e8 82 f0 ff ff       	call   801006 <sys_page_alloc>
  801f84:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f86:	85 c0                	test   %eax,%eax
  801f88:	79 0a                	jns    801f94 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801f8a:	89 34 24             	mov    %esi,(%esp)
  801f8d:	e8 00 02 00 00       	call   802192 <nsipc_close>
		return r;
  801f92:	eb 28                	jmp    801fbc <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f94:	8b 15 20 70 80 00    	mov    0x807020,%edx
  801f9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	89 04 24             	mov    %eax,(%esp)
  801fb5:	e8 d6 f5 ff ff       	call   801590 <fd2num>
  801fba:	89 c3                	mov    %eax,%ebx
}
  801fbc:	89 d8                	mov    %ebx,%eax
  801fbe:	83 c4 20             	add    $0x20,%esp
  801fc1:	5b                   	pop    %ebx
  801fc2:	5e                   	pop    %esi
  801fc3:	5d                   	pop    %ebp
  801fc4:	c3                   	ret    

00801fc5 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
  801fc8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fcb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fce:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdc:	89 04 24             	mov    %eax,(%esp)
  801fdf:	e8 62 01 00 00       	call   802146 <nsipc_socket>
  801fe4:	85 c0                	test   %eax,%eax
  801fe6:	78 05                	js     801fed <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801fe8:	e8 61 ff ff ff       	call   801f4e <alloc_sockfd>
}
  801fed:	c9                   	leave  
  801fee:	66 90                	xchg   %ax,%ax
  801ff0:	c3                   	ret    

00801ff1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801ff7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ffa:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ffe:	89 04 24             	mov    %eax,(%esp)
  802001:	e8 27 f6 ff ff       	call   80162d <fd_lookup>
  802006:	85 c0                	test   %eax,%eax
  802008:	78 15                	js     80201f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80200a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80200d:	8b 0a                	mov    (%edx),%ecx
  80200f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802014:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  80201a:	75 03                	jne    80201f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80201c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  80201f:	c9                   	leave  
  802020:	c3                   	ret    

00802021 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802021:	55                   	push   %ebp
  802022:	89 e5                	mov    %esp,%ebp
  802024:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802027:	8b 45 08             	mov    0x8(%ebp),%eax
  80202a:	e8 c2 ff ff ff       	call   801ff1 <fd2sockid>
  80202f:	85 c0                	test   %eax,%eax
  802031:	78 0f                	js     802042 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  802033:	8b 55 0c             	mov    0xc(%ebp),%edx
  802036:	89 54 24 04          	mov    %edx,0x4(%esp)
  80203a:	89 04 24             	mov    %eax,(%esp)
  80203d:	e8 2e 01 00 00       	call   802170 <nsipc_listen>
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	e8 9f ff ff ff       	call   801ff1 <fd2sockid>
  802052:	85 c0                	test   %eax,%eax
  802054:	78 16                	js     80206c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802056:	8b 55 10             	mov    0x10(%ebp),%edx
  802059:	89 54 24 08          	mov    %edx,0x8(%esp)
  80205d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802060:	89 54 24 04          	mov    %edx,0x4(%esp)
  802064:	89 04 24             	mov    %eax,(%esp)
  802067:	e8 55 02 00 00       	call   8022c1 <nsipc_connect>
}
  80206c:	c9                   	leave  
  80206d:	c3                   	ret    

0080206e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802074:	8b 45 08             	mov    0x8(%ebp),%eax
  802077:	e8 75 ff ff ff       	call   801ff1 <fd2sockid>
  80207c:	85 c0                	test   %eax,%eax
  80207e:	78 0f                	js     80208f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802080:	8b 55 0c             	mov    0xc(%ebp),%edx
  802083:	89 54 24 04          	mov    %edx,0x4(%esp)
  802087:	89 04 24             	mov    %eax,(%esp)
  80208a:	e8 1d 01 00 00       	call   8021ac <nsipc_shutdown>
}
  80208f:	c9                   	leave  
  802090:	c3                   	ret    

00802091 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
  802094:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802097:	8b 45 08             	mov    0x8(%ebp),%eax
  80209a:	e8 52 ff ff ff       	call   801ff1 <fd2sockid>
  80209f:	85 c0                	test   %eax,%eax
  8020a1:	78 16                	js     8020b9 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8020a3:	8b 55 10             	mov    0x10(%ebp),%edx
  8020a6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ad:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020b1:	89 04 24             	mov    %eax,(%esp)
  8020b4:	e8 47 02 00 00       	call   802300 <nsipc_bind>
}
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
  8020be:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c4:	e8 28 ff ff ff       	call   801ff1 <fd2sockid>
  8020c9:	85 c0                	test   %eax,%eax
  8020cb:	78 1f                	js     8020ec <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020cd:	8b 55 10             	mov    0x10(%ebp),%edx
  8020d0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020d7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020db:	89 04 24             	mov    %eax,(%esp)
  8020de:	e8 5c 02 00 00       	call   80233f <nsipc_accept>
  8020e3:	85 c0                	test   %eax,%eax
  8020e5:	78 05                	js     8020ec <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8020e7:	e8 62 fe ff ff       	call   801f4e <alloc_sockfd>
}
  8020ec:	c9                   	leave  
  8020ed:	8d 76 00             	lea    0x0(%esi),%esi
  8020f0:	c3                   	ret    
	...

00802100 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802106:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  80210c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802113:	00 
  802114:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80211b:	00 
  80211c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802120:	89 14 24             	mov    %edx,(%esp)
  802123:	e8 98 f3 ff ff       	call   8014c0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802128:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80212f:	00 
  802130:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802137:	00 
  802138:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80213f:	e8 de f3 ff ff       	call   801522 <ipc_recv>
}
  802144:	c9                   	leave  
  802145:	c3                   	ret    

00802146 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  802146:	55                   	push   %ebp
  802147:	89 e5                	mov    %esp,%ebp
  802149:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80214c:	8b 45 08             	mov    0x8(%ebp),%eax
  80214f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802154:	8b 45 0c             	mov    0xc(%ebp),%eax
  802157:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80215c:	8b 45 10             	mov    0x10(%ebp),%eax
  80215f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802164:	b8 09 00 00 00       	mov    $0x9,%eax
  802169:	e8 92 ff ff ff       	call   802100 <nsipc>
}
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80217e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802181:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802186:	b8 06 00 00 00       	mov    $0x6,%eax
  80218b:	e8 70 ff ff ff       	call   802100 <nsipc>
}
  802190:	c9                   	leave  
  802191:	c3                   	ret    

00802192 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802192:	55                   	push   %ebp
  802193:	89 e5                	mov    %esp,%ebp
  802195:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802198:	8b 45 08             	mov    0x8(%ebp),%eax
  80219b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8021a0:	b8 04 00 00 00       	mov    $0x4,%eax
  8021a5:	e8 56 ff ff ff       	call   802100 <nsipc>
}
  8021aa:	c9                   	leave  
  8021ab:	c3                   	ret    

008021ac <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  8021ac:	55                   	push   %ebp
  8021ad:	89 e5                	mov    %esp,%ebp
  8021af:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8021ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021bd:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8021c2:	b8 03 00 00 00       	mov    $0x3,%eax
  8021c7:	e8 34 ff ff ff       	call   802100 <nsipc>
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	53                   	push   %ebx
  8021d2:	83 ec 14             	sub    $0x14,%esp
  8021d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8021e0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021e6:	7e 24                	jle    80220c <nsipc_send+0x3e>
  8021e8:	c7 44 24 0c e3 31 80 	movl   $0x8031e3,0xc(%esp)
  8021ef:	00 
  8021f0:	c7 44 24 08 ef 31 80 	movl   $0x8031ef,0x8(%esp)
  8021f7:	00 
  8021f8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8021ff:	00 
  802200:	c7 04 24 04 32 80 00 	movl   $0x803204,(%esp)
  802207:	e8 20 07 00 00       	call   80292c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80220c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802210:	8b 45 0c             	mov    0xc(%ebp),%eax
  802213:	89 44 24 04          	mov    %eax,0x4(%esp)
  802217:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80221e:	e8 42 e8 ff ff       	call   800a65 <memmove>
	nsipcbuf.send.req_size = size;
  802223:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802229:	8b 45 14             	mov    0x14(%ebp),%eax
  80222c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802231:	b8 08 00 00 00       	mov    $0x8,%eax
  802236:	e8 c5 fe ff ff       	call   802100 <nsipc>
}
  80223b:	83 c4 14             	add    $0x14,%esp
  80223e:	5b                   	pop    %ebx
  80223f:	5d                   	pop    %ebp
  802240:	c3                   	ret    

00802241 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	56                   	push   %esi
  802245:	53                   	push   %ebx
  802246:	83 ec 10             	sub    $0x10,%esp
  802249:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80224c:	8b 45 08             	mov    0x8(%ebp),%eax
  80224f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802254:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80225a:	8b 45 14             	mov    0x14(%ebp),%eax
  80225d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802262:	b8 07 00 00 00       	mov    $0x7,%eax
  802267:	e8 94 fe ff ff       	call   802100 <nsipc>
  80226c:	89 c3                	mov    %eax,%ebx
  80226e:	85 c0                	test   %eax,%eax
  802270:	78 46                	js     8022b8 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802272:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802277:	7f 04                	jg     80227d <nsipc_recv+0x3c>
  802279:	39 c6                	cmp    %eax,%esi
  80227b:	7d 24                	jge    8022a1 <nsipc_recv+0x60>
  80227d:	c7 44 24 0c 10 32 80 	movl   $0x803210,0xc(%esp)
  802284:	00 
  802285:	c7 44 24 08 ef 31 80 	movl   $0x8031ef,0x8(%esp)
  80228c:	00 
  80228d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802294:	00 
  802295:	c7 04 24 04 32 80 00 	movl   $0x803204,(%esp)
  80229c:	e8 8b 06 00 00       	call   80292c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8022a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022a5:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8022ac:	00 
  8022ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b0:	89 04 24             	mov    %eax,(%esp)
  8022b3:	e8 ad e7 ff ff       	call   800a65 <memmove>
	}

	return r;
}
  8022b8:	89 d8                	mov    %ebx,%eax
  8022ba:	83 c4 10             	add    $0x10,%esp
  8022bd:	5b                   	pop    %ebx
  8022be:	5e                   	pop    %esi
  8022bf:	5d                   	pop    %ebp
  8022c0:	c3                   	ret    

008022c1 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	53                   	push   %ebx
  8022c5:	83 ec 14             	sub    $0x14,%esp
  8022c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022de:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8022e5:	e8 7b e7 ff ff       	call   800a65 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022ea:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8022f0:	b8 05 00 00 00       	mov    $0x5,%eax
  8022f5:	e8 06 fe ff ff       	call   802100 <nsipc>
}
  8022fa:	83 c4 14             	add    $0x14,%esp
  8022fd:	5b                   	pop    %ebx
  8022fe:	5d                   	pop    %ebp
  8022ff:	c3                   	ret    

00802300 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	53                   	push   %ebx
  802304:	83 ec 14             	sub    $0x14,%esp
  802307:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80230a:	8b 45 08             	mov    0x8(%ebp),%eax
  80230d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802312:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802316:	8b 45 0c             	mov    0xc(%ebp),%eax
  802319:	89 44 24 04          	mov    %eax,0x4(%esp)
  80231d:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802324:	e8 3c e7 ff ff       	call   800a65 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802329:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80232f:	b8 02 00 00 00       	mov    $0x2,%eax
  802334:	e8 c7 fd ff ff       	call   802100 <nsipc>
}
  802339:	83 c4 14             	add    $0x14,%esp
  80233c:	5b                   	pop    %ebx
  80233d:	5d                   	pop    %ebp
  80233e:	c3                   	ret    

0080233f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	83 ec 18             	sub    $0x18,%esp
  802345:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802348:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802353:	b8 01 00 00 00       	mov    $0x1,%eax
  802358:	e8 a3 fd ff ff       	call   802100 <nsipc>
  80235d:	89 c3                	mov    %eax,%ebx
  80235f:	85 c0                	test   %eax,%eax
  802361:	78 25                	js     802388 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802363:	be 10 60 80 00       	mov    $0x806010,%esi
  802368:	8b 06                	mov    (%esi),%eax
  80236a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80236e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802375:	00 
  802376:	8b 45 0c             	mov    0xc(%ebp),%eax
  802379:	89 04 24             	mov    %eax,(%esp)
  80237c:	e8 e4 e6 ff ff       	call   800a65 <memmove>
		*addrlen = ret->ret_addrlen;
  802381:	8b 16                	mov    (%esi),%edx
  802383:	8b 45 10             	mov    0x10(%ebp),%eax
  802386:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802388:	89 d8                	mov    %ebx,%eax
  80238a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80238d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802390:	89 ec                	mov    %ebp,%esp
  802392:	5d                   	pop    %ebp
  802393:	c3                   	ret    
	...

008023a0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	83 ec 18             	sub    $0x18,%esp
  8023a6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8023a9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8023ac:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8023af:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b2:	89 04 24             	mov    %eax,(%esp)
  8023b5:	e8 e6 f1 ff ff       	call   8015a0 <fd2data>
  8023ba:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8023bc:	c7 44 24 04 25 32 80 	movl   $0x803225,0x4(%esp)
  8023c3:	00 
  8023c4:	89 34 24             	mov    %esi,(%esp)
  8023c7:	e8 de e4 ff ff       	call   8008aa <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023cc:	8b 43 04             	mov    0x4(%ebx),%eax
  8023cf:	2b 03                	sub    (%ebx),%eax
  8023d1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8023d7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8023de:	00 00 00 
	stat->st_dev = &devpipe;
  8023e1:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  8023e8:	70 80 00 
	return 0;
}
  8023eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023f0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8023f3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8023f6:	89 ec                	mov    %ebp,%esp
  8023f8:	5d                   	pop    %ebp
  8023f9:	c3                   	ret    

008023fa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
  8023fd:	53                   	push   %ebx
  8023fe:	83 ec 14             	sub    $0x14,%esp
  802401:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802404:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802408:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80240f:	e8 36 eb ff ff       	call   800f4a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802414:	89 1c 24             	mov    %ebx,(%esp)
  802417:	e8 84 f1 ff ff       	call   8015a0 <fd2data>
  80241c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802420:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802427:	e8 1e eb ff ff       	call   800f4a <sys_page_unmap>
}
  80242c:	83 c4 14             	add    $0x14,%esp
  80242f:	5b                   	pop    %ebx
  802430:	5d                   	pop    %ebp
  802431:	c3                   	ret    

00802432 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802432:	55                   	push   %ebp
  802433:	89 e5                	mov    %esp,%ebp
  802435:	57                   	push   %edi
  802436:	56                   	push   %esi
  802437:	53                   	push   %ebx
  802438:	83 ec 2c             	sub    $0x2c,%esp
  80243b:	89 c7                	mov    %eax,%edi
  80243d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802440:	a1 74 70 80 00       	mov    0x807074,%eax
  802445:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802448:	89 3c 24             	mov    %edi,(%esp)
  80244b:	e8 e0 05 00 00       	call   802a30 <pageref>
  802450:	89 c6                	mov    %eax,%esi
  802452:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802455:	89 04 24             	mov    %eax,(%esp)
  802458:	e8 d3 05 00 00       	call   802a30 <pageref>
  80245d:	39 c6                	cmp    %eax,%esi
  80245f:	0f 94 c0             	sete   %al
  802462:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802465:	8b 15 74 70 80 00    	mov    0x807074,%edx
  80246b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80246e:	39 cb                	cmp    %ecx,%ebx
  802470:	75 08                	jne    80247a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802472:	83 c4 2c             	add    $0x2c,%esp
  802475:	5b                   	pop    %ebx
  802476:	5e                   	pop    %esi
  802477:	5f                   	pop    %edi
  802478:	5d                   	pop    %ebp
  802479:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80247a:	83 f8 01             	cmp    $0x1,%eax
  80247d:	75 c1                	jne    802440 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80247f:	8b 52 58             	mov    0x58(%edx),%edx
  802482:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802486:	89 54 24 08          	mov    %edx,0x8(%esp)
  80248a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80248e:	c7 04 24 2c 32 80 00 	movl   $0x80322c,(%esp)
  802495:	e8 2b dd ff ff       	call   8001c5 <cprintf>
  80249a:	eb a4                	jmp    802440 <_pipeisclosed+0xe>

0080249c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80249c:	55                   	push   %ebp
  80249d:	89 e5                	mov    %esp,%ebp
  80249f:	57                   	push   %edi
  8024a0:	56                   	push   %esi
  8024a1:	53                   	push   %ebx
  8024a2:	83 ec 1c             	sub    $0x1c,%esp
  8024a5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8024a8:	89 34 24             	mov    %esi,(%esp)
  8024ab:	e8 f0 f0 ff ff       	call   8015a0 <fd2data>
  8024b0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8024b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024bb:	75 54                	jne    802511 <devpipe_write+0x75>
  8024bd:	eb 60                	jmp    80251f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8024bf:	89 da                	mov    %ebx,%edx
  8024c1:	89 f0                	mov    %esi,%eax
  8024c3:	e8 6a ff ff ff       	call   802432 <_pipeisclosed>
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	74 07                	je     8024d3 <devpipe_write+0x37>
  8024cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024d1:	eb 53                	jmp    802526 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8024d3:	90                   	nop
  8024d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024d8:	e8 88 eb ff ff       	call   801065 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024dd:	8b 43 04             	mov    0x4(%ebx),%eax
  8024e0:	8b 13                	mov    (%ebx),%edx
  8024e2:	83 c2 20             	add    $0x20,%edx
  8024e5:	39 d0                	cmp    %edx,%eax
  8024e7:	73 d6                	jae    8024bf <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024e9:	89 c2                	mov    %eax,%edx
  8024eb:	c1 fa 1f             	sar    $0x1f,%edx
  8024ee:	c1 ea 1b             	shr    $0x1b,%edx
  8024f1:	01 d0                	add    %edx,%eax
  8024f3:	83 e0 1f             	and    $0x1f,%eax
  8024f6:	29 d0                	sub    %edx,%eax
  8024f8:	89 c2                	mov    %eax,%edx
  8024fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024fd:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802501:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802505:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802509:	83 c7 01             	add    $0x1,%edi
  80250c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80250f:	76 13                	jbe    802524 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802511:	8b 43 04             	mov    0x4(%ebx),%eax
  802514:	8b 13                	mov    (%ebx),%edx
  802516:	83 c2 20             	add    $0x20,%edx
  802519:	39 d0                	cmp    %edx,%eax
  80251b:	73 a2                	jae    8024bf <devpipe_write+0x23>
  80251d:	eb ca                	jmp    8024e9 <devpipe_write+0x4d>
  80251f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802524:	89 f8                	mov    %edi,%eax
}
  802526:	83 c4 1c             	add    $0x1c,%esp
  802529:	5b                   	pop    %ebx
  80252a:	5e                   	pop    %esi
  80252b:	5f                   	pop    %edi
  80252c:	5d                   	pop    %ebp
  80252d:	c3                   	ret    

0080252e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80252e:	55                   	push   %ebp
  80252f:	89 e5                	mov    %esp,%ebp
  802531:	83 ec 28             	sub    $0x28,%esp
  802534:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802537:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80253a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80253d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802540:	89 3c 24             	mov    %edi,(%esp)
  802543:	e8 58 f0 ff ff       	call   8015a0 <fd2data>
  802548:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80254a:	be 00 00 00 00       	mov    $0x0,%esi
  80254f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802553:	75 4c                	jne    8025a1 <devpipe_read+0x73>
  802555:	eb 5b                	jmp    8025b2 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802557:	89 f0                	mov    %esi,%eax
  802559:	eb 5e                	jmp    8025b9 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80255b:	89 da                	mov    %ebx,%edx
  80255d:	89 f8                	mov    %edi,%eax
  80255f:	90                   	nop
  802560:	e8 cd fe ff ff       	call   802432 <_pipeisclosed>
  802565:	85 c0                	test   %eax,%eax
  802567:	74 07                	je     802570 <devpipe_read+0x42>
  802569:	b8 00 00 00 00       	mov    $0x0,%eax
  80256e:	eb 49                	jmp    8025b9 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802570:	e8 f0 ea ff ff       	call   801065 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802575:	8b 03                	mov    (%ebx),%eax
  802577:	3b 43 04             	cmp    0x4(%ebx),%eax
  80257a:	74 df                	je     80255b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80257c:	89 c2                	mov    %eax,%edx
  80257e:	c1 fa 1f             	sar    $0x1f,%edx
  802581:	c1 ea 1b             	shr    $0x1b,%edx
  802584:	01 d0                	add    %edx,%eax
  802586:	83 e0 1f             	and    $0x1f,%eax
  802589:	29 d0                	sub    %edx,%eax
  80258b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802590:	8b 55 0c             	mov    0xc(%ebp),%edx
  802593:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802596:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802599:	83 c6 01             	add    $0x1,%esi
  80259c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80259f:	76 16                	jbe    8025b7 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  8025a1:	8b 03                	mov    (%ebx),%eax
  8025a3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025a6:	75 d4                	jne    80257c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8025a8:	85 f6                	test   %esi,%esi
  8025aa:	75 ab                	jne    802557 <devpipe_read+0x29>
  8025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025b0:	eb a9                	jmp    80255b <devpipe_read+0x2d>
  8025b2:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8025b7:	89 f0                	mov    %esi,%eax
}
  8025b9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8025bc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8025bf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8025c2:	89 ec                	mov    %ebp,%esp
  8025c4:	5d                   	pop    %ebp
  8025c5:	c3                   	ret    

008025c6 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8025c6:	55                   	push   %ebp
  8025c7:	89 e5                	mov    %esp,%ebp
  8025c9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025d6:	89 04 24             	mov    %eax,(%esp)
  8025d9:	e8 4f f0 ff ff       	call   80162d <fd_lookup>
  8025de:	85 c0                	test   %eax,%eax
  8025e0:	78 15                	js     8025f7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8025e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e5:	89 04 24             	mov    %eax,(%esp)
  8025e8:	e8 b3 ef ff ff       	call   8015a0 <fd2data>
	return _pipeisclosed(fd, p);
  8025ed:	89 c2                	mov    %eax,%edx
  8025ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f2:	e8 3b fe ff ff       	call   802432 <_pipeisclosed>
}
  8025f7:	c9                   	leave  
  8025f8:	c3                   	ret    

008025f9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8025f9:	55                   	push   %ebp
  8025fa:	89 e5                	mov    %esp,%ebp
  8025fc:	83 ec 48             	sub    $0x48,%esp
  8025ff:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802602:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802605:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802608:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80260b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80260e:	89 04 24             	mov    %eax,(%esp)
  802611:	e8 a5 ef ff ff       	call   8015bb <fd_alloc>
  802616:	89 c3                	mov    %eax,%ebx
  802618:	85 c0                	test   %eax,%eax
  80261a:	0f 88 42 01 00 00    	js     802762 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802620:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802627:	00 
  802628:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80262b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80262f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802636:	e8 cb e9 ff ff       	call   801006 <sys_page_alloc>
  80263b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80263d:	85 c0                	test   %eax,%eax
  80263f:	0f 88 1d 01 00 00    	js     802762 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802645:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802648:	89 04 24             	mov    %eax,(%esp)
  80264b:	e8 6b ef ff ff       	call   8015bb <fd_alloc>
  802650:	89 c3                	mov    %eax,%ebx
  802652:	85 c0                	test   %eax,%eax
  802654:	0f 88 f5 00 00 00    	js     80274f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80265a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802661:	00 
  802662:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802665:	89 44 24 04          	mov    %eax,0x4(%esp)
  802669:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802670:	e8 91 e9 ff ff       	call   801006 <sys_page_alloc>
  802675:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802677:	85 c0                	test   %eax,%eax
  802679:	0f 88 d0 00 00 00    	js     80274f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80267f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802682:	89 04 24             	mov    %eax,(%esp)
  802685:	e8 16 ef ff ff       	call   8015a0 <fd2data>
  80268a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80268c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802693:	00 
  802694:	89 44 24 04          	mov    %eax,0x4(%esp)
  802698:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80269f:	e8 62 e9 ff ff       	call   801006 <sys_page_alloc>
  8026a4:	89 c3                	mov    %eax,%ebx
  8026a6:	85 c0                	test   %eax,%eax
  8026a8:	0f 88 8e 00 00 00    	js     80273c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026b1:	89 04 24             	mov    %eax,(%esp)
  8026b4:	e8 e7 ee ff ff       	call   8015a0 <fd2data>
  8026b9:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8026c0:	00 
  8026c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026c5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8026cc:	00 
  8026cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026d8:	e8 cb e8 ff ff       	call   800fa8 <sys_page_map>
  8026dd:	89 c3                	mov    %eax,%ebx
  8026df:	85 c0                	test   %eax,%eax
  8026e1:	78 49                	js     80272c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8026e3:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  8026e8:	8b 08                	mov    (%eax),%ecx
  8026ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026ed:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026f2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8026f9:	8b 10                	mov    (%eax),%edx
  8026fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026fe:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802700:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802703:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80270a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80270d:	89 04 24             	mov    %eax,(%esp)
  802710:	e8 7b ee ff ff       	call   801590 <fd2num>
  802715:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802717:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80271a:	89 04 24             	mov    %eax,(%esp)
  80271d:	e8 6e ee ff ff       	call   801590 <fd2num>
  802722:	89 47 04             	mov    %eax,0x4(%edi)
  802725:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80272a:	eb 36                	jmp    802762 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80272c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802730:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802737:	e8 0e e8 ff ff       	call   800f4a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80273c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80273f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802743:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80274a:	e8 fb e7 ff ff       	call   800f4a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80274f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802752:	89 44 24 04          	mov    %eax,0x4(%esp)
  802756:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80275d:	e8 e8 e7 ff ff       	call   800f4a <sys_page_unmap>
    err:
	return r;
}
  802762:	89 d8                	mov    %ebx,%eax
  802764:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802767:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80276a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80276d:	89 ec                	mov    %ebp,%esp
  80276f:	5d                   	pop    %ebp
  802770:	c3                   	ret    
	...

00802780 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802783:	b8 00 00 00 00       	mov    $0x0,%eax
  802788:	5d                   	pop    %ebp
  802789:	c3                   	ret    

0080278a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80278a:	55                   	push   %ebp
  80278b:	89 e5                	mov    %esp,%ebp
  80278d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802790:	c7 44 24 04 44 32 80 	movl   $0x803244,0x4(%esp)
  802797:	00 
  802798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80279b:	89 04 24             	mov    %eax,(%esp)
  80279e:	e8 07 e1 ff ff       	call   8008aa <strcpy>
	return 0;
}
  8027a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a8:	c9                   	leave  
  8027a9:	c3                   	ret    

008027aa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8027aa:	55                   	push   %ebp
  8027ab:	89 e5                	mov    %esp,%ebp
  8027ad:	57                   	push   %edi
  8027ae:	56                   	push   %esi
  8027af:	53                   	push   %ebx
  8027b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8027bb:	be 00 00 00 00       	mov    $0x0,%esi
  8027c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027c4:	74 3f                	je     802805 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027c6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8027cc:	8b 55 10             	mov    0x10(%ebp),%edx
  8027cf:	29 c2                	sub    %eax,%edx
  8027d1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  8027d3:	83 fa 7f             	cmp    $0x7f,%edx
  8027d6:	76 05                	jbe    8027dd <devcons_write+0x33>
  8027d8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027dd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027e1:	03 45 0c             	add    0xc(%ebp),%eax
  8027e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027e8:	89 3c 24             	mov    %edi,(%esp)
  8027eb:	e8 75 e2 ff ff       	call   800a65 <memmove>
		sys_cputs(buf, m);
  8027f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027f4:	89 3c 24             	mov    %edi,(%esp)
  8027f7:	e8 a4 e4 ff ff       	call   800ca0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027fc:	01 de                	add    %ebx,%esi
  8027fe:	89 f0                	mov    %esi,%eax
  802800:	3b 75 10             	cmp    0x10(%ebp),%esi
  802803:	72 c7                	jb     8027cc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802805:	89 f0                	mov    %esi,%eax
  802807:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80280d:	5b                   	pop    %ebx
  80280e:	5e                   	pop    %esi
  80280f:	5f                   	pop    %edi
  802810:	5d                   	pop    %ebp
  802811:	c3                   	ret    

00802812 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802812:	55                   	push   %ebp
  802813:	89 e5                	mov    %esp,%ebp
  802815:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802818:	8b 45 08             	mov    0x8(%ebp),%eax
  80281b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80281e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802825:	00 
  802826:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802829:	89 04 24             	mov    %eax,(%esp)
  80282c:	e8 6f e4 ff ff       	call   800ca0 <sys_cputs>
}
  802831:	c9                   	leave  
  802832:	c3                   	ret    

00802833 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802833:	55                   	push   %ebp
  802834:	89 e5                	mov    %esp,%ebp
  802836:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802839:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80283d:	75 07                	jne    802846 <devcons_read+0x13>
  80283f:	eb 28                	jmp    802869 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802841:	e8 1f e8 ff ff       	call   801065 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802846:	66 90                	xchg   %ax,%ax
  802848:	e8 1f e4 ff ff       	call   800c6c <sys_cgetc>
  80284d:	85 c0                	test   %eax,%eax
  80284f:	90                   	nop
  802850:	74 ef                	je     802841 <devcons_read+0xe>
  802852:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802854:	85 c0                	test   %eax,%eax
  802856:	78 16                	js     80286e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802858:	83 f8 04             	cmp    $0x4,%eax
  80285b:	74 0c                	je     802869 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80285d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802860:	88 10                	mov    %dl,(%eax)
  802862:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802867:	eb 05                	jmp    80286e <devcons_read+0x3b>
  802869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80286e:	c9                   	leave  
  80286f:	c3                   	ret    

00802870 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802870:	55                   	push   %ebp
  802871:	89 e5                	mov    %esp,%ebp
  802873:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802876:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802879:	89 04 24             	mov    %eax,(%esp)
  80287c:	e8 3a ed ff ff       	call   8015bb <fd_alloc>
  802881:	85 c0                	test   %eax,%eax
  802883:	78 3f                	js     8028c4 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802885:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80288c:	00 
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	89 44 24 04          	mov    %eax,0x4(%esp)
  802894:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80289b:	e8 66 e7 ff ff       	call   801006 <sys_page_alloc>
  8028a0:	85 c0                	test   %eax,%eax
  8028a2:	78 20                	js     8028c4 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8028a4:	8b 15 58 70 80 00    	mov    0x807058,%edx
  8028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ad:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	89 04 24             	mov    %eax,(%esp)
  8028bf:	e8 cc ec ff ff       	call   801590 <fd2num>
}
  8028c4:	c9                   	leave  
  8028c5:	c3                   	ret    

008028c6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8028c6:	55                   	push   %ebp
  8028c7:	89 e5                	mov    %esp,%ebp
  8028c9:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d6:	89 04 24             	mov    %eax,(%esp)
  8028d9:	e8 4f ed ff ff       	call   80162d <fd_lookup>
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	78 11                	js     8028f3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  8028ed:	0f 94 c0             	sete   %al
  8028f0:	0f b6 c0             	movzbl %al,%eax
}
  8028f3:	c9                   	leave  
  8028f4:	c3                   	ret    

008028f5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8028f5:	55                   	push   %ebp
  8028f6:	89 e5                	mov    %esp,%ebp
  8028f8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8028fb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802902:	00 
  802903:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802906:	89 44 24 04          	mov    %eax,0x4(%esp)
  80290a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802911:	e8 78 ef ff ff       	call   80188e <read>
	if (r < 0)
  802916:	85 c0                	test   %eax,%eax
  802918:	78 0f                	js     802929 <getchar+0x34>
		return r;
	if (r < 1)
  80291a:	85 c0                	test   %eax,%eax
  80291c:	7f 07                	jg     802925 <getchar+0x30>
  80291e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802923:	eb 04                	jmp    802929 <getchar+0x34>
		return -E_EOF;
	return c;
  802925:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802929:	c9                   	leave  
  80292a:	c3                   	ret    
	...

0080292c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80292c:	55                   	push   %ebp
  80292d:	89 e5                	mov    %esp,%ebp
  80292f:	53                   	push   %ebx
  802930:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  802933:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  802936:	a1 78 70 80 00       	mov    0x807078,%eax
  80293b:	85 c0                	test   %eax,%eax
  80293d:	74 10                	je     80294f <_panic+0x23>
		cprintf("%s: ", argv0);
  80293f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802943:	c7 04 24 50 32 80 00 	movl   $0x803250,(%esp)
  80294a:	e8 76 d8 ff ff       	call   8001c5 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80294f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802952:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802956:	8b 45 08             	mov    0x8(%ebp),%eax
  802959:	89 44 24 08          	mov    %eax,0x8(%esp)
  80295d:	a1 00 70 80 00       	mov    0x807000,%eax
  802962:	89 44 24 04          	mov    %eax,0x4(%esp)
  802966:	c7 04 24 55 32 80 00 	movl   $0x803255,(%esp)
  80296d:	e8 53 d8 ff ff       	call   8001c5 <cprintf>
	vcprintf(fmt, ap);
  802972:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802976:	8b 45 10             	mov    0x10(%ebp),%eax
  802979:	89 04 24             	mov    %eax,(%esp)
  80297c:	e8 e3 d7 ff ff       	call   800164 <vcprintf>
	cprintf("\n");
  802981:	c7 04 24 3d 32 80 00 	movl   $0x80323d,(%esp)
  802988:	e8 38 d8 ff ff       	call   8001c5 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80298d:	cc                   	int3   
  80298e:	eb fd                	jmp    80298d <_panic+0x61>

00802990 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802990:	55                   	push   %ebp
  802991:	89 e5                	mov    %esp,%ebp
  802993:	53                   	push   %ebx
  802994:	83 ec 14             	sub    $0x14,%esp
  802997:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    // cprintf("\nhere outside loading creating page\n");

	if (_pgfault_handler == 0) {
  80299a:	83 3d 7c 70 80 00 00 	cmpl   $0x0,0x80707c
  8029a1:	75 58                	jne    8029fb <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
           //cprintf("\nhere inside loading creating page\n");    
          if(sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  8029a3:	e8 f1 e6 ff ff       	call   801099 <sys_getenvid>
  8029a8:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8029af:	00 
  8029b0:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8029b7:	ee 
  8029b8:	89 04 24             	mov    %eax,(%esp)
  8029bb:	e8 46 e6 ff ff       	call   801006 <sys_page_alloc>
  8029c0:	85 c0                	test   %eax,%eax
  8029c2:	79 1c                	jns    8029e0 <set_pgfault_handler+0x50>
                          panic("Cant allocate Page");                    
  8029c4:	c7 44 24 08 ac 30 80 	movl   $0x8030ac,0x8(%esp)
  8029cb:	00 
  8029cc:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8029d3:	00 
  8029d4:	c7 04 24 71 32 80 00 	movl   $0x803271,(%esp)
  8029db:	e8 4c ff ff ff       	call   80292c <_panic>
                _pgfault_handler=handler;
  8029e0:	89 1d 7c 70 80 00    	mov    %ebx,0x80707c
//entry point _pgfault_handler not pointed to by the kernel bcz after the execution is complete control needs to be returned back to execute the rest...so upcall is there         
             sys_env_set_pgfault_upcall(sys_getenvid(),_pgfault_upcall);
  8029e6:	e8 ae e6 ff ff       	call   801099 <sys_getenvid>
  8029eb:	c7 44 24 04 08 2a 80 	movl   $0x802a08,0x4(%esp)
  8029f2:	00 
  8029f3:	89 04 24             	mov    %eax,(%esp)
  8029f6:	e8 35 e4 ff ff       	call   800e30 <sys_env_set_pgfault_upcall>

	// Save handler pointer for assembly to call.
 //     if(sys_page_alloc(0,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
   //                       panic("Cant allocate Page");

	_pgfault_handler = handler;
  8029fb:	89 1d 7c 70 80 00    	mov    %ebx,0x80707c
}
  802a01:	83 c4 14             	add    $0x14,%esp
  802a04:	5b                   	pop    %ebx
  802a05:	5d                   	pop    %ebp
  802a06:	c3                   	ret    
	...

00802a08 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a08:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a09:	a1 7c 70 80 00       	mov    0x80707c,%eax
	call *%eax
  802a0e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a10:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
           addl $8,%esp
  802a13:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
            movl  32(%esp),%ebx
  802a16:	8b 5c 24 20          	mov    0x20(%esp),%ebx
            movl  40(%esp),%eax
  802a1a:	8b 44 24 28          	mov    0x28(%esp),%eax
            subl  $4,%eax
  802a1e:	83 e8 04             	sub    $0x4,%eax
            movl  %eax,40(%esp)
  802a21:	89 44 24 28          	mov    %eax,0x28(%esp)
            movl  %ebx,(%eax)
  802a25:	89 18                	mov    %ebx,(%eax)
            popal
  802a27:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
            
            add $4,%esp            
  802a28:	83 c4 04             	add    $0x4,%esp
            popfl
  802a2b:	9d                   	popf   
             
           popl %esp
  802a2c:	5c                   	pop    %esp
	// LAB 4: Your code here.
           

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
           ret
  802a2d:	c3                   	ret    
	...

00802a30 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a30:	55                   	push   %ebp
  802a31:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802a33:	8b 45 08             	mov    0x8(%ebp),%eax
  802a36:	89 c2                	mov    %eax,%edx
  802a38:	c1 ea 16             	shr    $0x16,%edx
  802a3b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802a42:	f6 c2 01             	test   $0x1,%dl
  802a45:	74 26                	je     802a6d <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802a47:	c1 e8 0c             	shr    $0xc,%eax
  802a4a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802a51:	a8 01                	test   $0x1,%al
  802a53:	74 18                	je     802a6d <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802a55:	c1 e8 0c             	shr    $0xc,%eax
  802a58:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802a5b:	c1 e2 02             	shl    $0x2,%edx
  802a5e:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802a63:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802a68:	0f b7 c0             	movzwl %ax,%eax
  802a6b:	eb 05                	jmp    802a72 <pageref+0x42>
  802a6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a72:	5d                   	pop    %ebp
  802a73:	c3                   	ret    
	...

00802a80 <__udivdi3>:
  802a80:	55                   	push   %ebp
  802a81:	89 e5                	mov    %esp,%ebp
  802a83:	57                   	push   %edi
  802a84:	56                   	push   %esi
  802a85:	83 ec 10             	sub    $0x10,%esp
  802a88:	8b 45 14             	mov    0x14(%ebp),%eax
  802a8b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a8e:	8b 75 10             	mov    0x10(%ebp),%esi
  802a91:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802a94:	85 c0                	test   %eax,%eax
  802a96:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802a99:	75 35                	jne    802ad0 <__udivdi3+0x50>
  802a9b:	39 fe                	cmp    %edi,%esi
  802a9d:	77 61                	ja     802b00 <__udivdi3+0x80>
  802a9f:	85 f6                	test   %esi,%esi
  802aa1:	75 0b                	jne    802aae <__udivdi3+0x2e>
  802aa3:	b8 01 00 00 00       	mov    $0x1,%eax
  802aa8:	31 d2                	xor    %edx,%edx
  802aaa:	f7 f6                	div    %esi
  802aac:	89 c6                	mov    %eax,%esi
  802aae:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802ab1:	31 d2                	xor    %edx,%edx
  802ab3:	89 f8                	mov    %edi,%eax
  802ab5:	f7 f6                	div    %esi
  802ab7:	89 c7                	mov    %eax,%edi
  802ab9:	89 c8                	mov    %ecx,%eax
  802abb:	f7 f6                	div    %esi
  802abd:	89 c1                	mov    %eax,%ecx
  802abf:	89 fa                	mov    %edi,%edx
  802ac1:	89 c8                	mov    %ecx,%eax
  802ac3:	83 c4 10             	add    $0x10,%esp
  802ac6:	5e                   	pop    %esi
  802ac7:	5f                   	pop    %edi
  802ac8:	5d                   	pop    %ebp
  802ac9:	c3                   	ret    
  802aca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802ad0:	39 f8                	cmp    %edi,%eax
  802ad2:	77 1c                	ja     802af0 <__udivdi3+0x70>
  802ad4:	0f bd d0             	bsr    %eax,%edx
  802ad7:	83 f2 1f             	xor    $0x1f,%edx
  802ada:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802add:	75 39                	jne    802b18 <__udivdi3+0x98>
  802adf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802ae2:	0f 86 a0 00 00 00    	jbe    802b88 <__udivdi3+0x108>
  802ae8:	39 f8                	cmp    %edi,%eax
  802aea:	0f 82 98 00 00 00    	jb     802b88 <__udivdi3+0x108>
  802af0:	31 ff                	xor    %edi,%edi
  802af2:	31 c9                	xor    %ecx,%ecx
  802af4:	89 c8                	mov    %ecx,%eax
  802af6:	89 fa                	mov    %edi,%edx
  802af8:	83 c4 10             	add    $0x10,%esp
  802afb:	5e                   	pop    %esi
  802afc:	5f                   	pop    %edi
  802afd:	5d                   	pop    %ebp
  802afe:	c3                   	ret    
  802aff:	90                   	nop
  802b00:	89 d1                	mov    %edx,%ecx
  802b02:	89 fa                	mov    %edi,%edx
  802b04:	89 c8                	mov    %ecx,%eax
  802b06:	31 ff                	xor    %edi,%edi
  802b08:	f7 f6                	div    %esi
  802b0a:	89 c1                	mov    %eax,%ecx
  802b0c:	89 fa                	mov    %edi,%edx
  802b0e:	89 c8                	mov    %ecx,%eax
  802b10:	83 c4 10             	add    $0x10,%esp
  802b13:	5e                   	pop    %esi
  802b14:	5f                   	pop    %edi
  802b15:	5d                   	pop    %ebp
  802b16:	c3                   	ret    
  802b17:	90                   	nop
  802b18:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802b1c:	89 f2                	mov    %esi,%edx
  802b1e:	d3 e0                	shl    %cl,%eax
  802b20:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b23:	b8 20 00 00 00       	mov    $0x20,%eax
  802b28:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802b2b:	89 c1                	mov    %eax,%ecx
  802b2d:	d3 ea                	shr    %cl,%edx
  802b2f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802b33:	0b 55 ec             	or     -0x14(%ebp),%edx
  802b36:	d3 e6                	shl    %cl,%esi
  802b38:	89 c1                	mov    %eax,%ecx
  802b3a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802b3d:	89 fe                	mov    %edi,%esi
  802b3f:	d3 ee                	shr    %cl,%esi
  802b41:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802b45:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802b48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b4b:	d3 e7                	shl    %cl,%edi
  802b4d:	89 c1                	mov    %eax,%ecx
  802b4f:	d3 ea                	shr    %cl,%edx
  802b51:	09 d7                	or     %edx,%edi
  802b53:	89 f2                	mov    %esi,%edx
  802b55:	89 f8                	mov    %edi,%eax
  802b57:	f7 75 ec             	divl   -0x14(%ebp)
  802b5a:	89 d6                	mov    %edx,%esi
  802b5c:	89 c7                	mov    %eax,%edi
  802b5e:	f7 65 e8             	mull   -0x18(%ebp)
  802b61:	39 d6                	cmp    %edx,%esi
  802b63:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802b66:	72 30                	jb     802b98 <__udivdi3+0x118>
  802b68:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b6b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802b6f:	d3 e2                	shl    %cl,%edx
  802b71:	39 c2                	cmp    %eax,%edx
  802b73:	73 05                	jae    802b7a <__udivdi3+0xfa>
  802b75:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802b78:	74 1e                	je     802b98 <__udivdi3+0x118>
  802b7a:	89 f9                	mov    %edi,%ecx
  802b7c:	31 ff                	xor    %edi,%edi
  802b7e:	e9 71 ff ff ff       	jmp    802af4 <__udivdi3+0x74>
  802b83:	90                   	nop
  802b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b88:	31 ff                	xor    %edi,%edi
  802b8a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802b8f:	e9 60 ff ff ff       	jmp    802af4 <__udivdi3+0x74>
  802b94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b98:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802b9b:	31 ff                	xor    %edi,%edi
  802b9d:	89 c8                	mov    %ecx,%eax
  802b9f:	89 fa                	mov    %edi,%edx
  802ba1:	83 c4 10             	add    $0x10,%esp
  802ba4:	5e                   	pop    %esi
  802ba5:	5f                   	pop    %edi
  802ba6:	5d                   	pop    %ebp
  802ba7:	c3                   	ret    
	...

00802bb0 <__umoddi3>:
  802bb0:	55                   	push   %ebp
  802bb1:	89 e5                	mov    %esp,%ebp
  802bb3:	57                   	push   %edi
  802bb4:	56                   	push   %esi
  802bb5:	83 ec 20             	sub    $0x20,%esp
  802bb8:	8b 55 14             	mov    0x14(%ebp),%edx
  802bbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bbe:	8b 7d 10             	mov    0x10(%ebp),%edi
  802bc1:	8b 75 0c             	mov    0xc(%ebp),%esi
  802bc4:	85 d2                	test   %edx,%edx
  802bc6:	89 c8                	mov    %ecx,%eax
  802bc8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802bcb:	75 13                	jne    802be0 <__umoddi3+0x30>
  802bcd:	39 f7                	cmp    %esi,%edi
  802bcf:	76 3f                	jbe    802c10 <__umoddi3+0x60>
  802bd1:	89 f2                	mov    %esi,%edx
  802bd3:	f7 f7                	div    %edi
  802bd5:	89 d0                	mov    %edx,%eax
  802bd7:	31 d2                	xor    %edx,%edx
  802bd9:	83 c4 20             	add    $0x20,%esp
  802bdc:	5e                   	pop    %esi
  802bdd:	5f                   	pop    %edi
  802bde:	5d                   	pop    %ebp
  802bdf:	c3                   	ret    
  802be0:	39 f2                	cmp    %esi,%edx
  802be2:	77 4c                	ja     802c30 <__umoddi3+0x80>
  802be4:	0f bd ca             	bsr    %edx,%ecx
  802be7:	83 f1 1f             	xor    $0x1f,%ecx
  802bea:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802bed:	75 51                	jne    802c40 <__umoddi3+0x90>
  802bef:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802bf2:	0f 87 e0 00 00 00    	ja     802cd8 <__umoddi3+0x128>
  802bf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfb:	29 f8                	sub    %edi,%eax
  802bfd:	19 d6                	sbb    %edx,%esi
  802bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	89 f2                	mov    %esi,%edx
  802c07:	83 c4 20             	add    $0x20,%esp
  802c0a:	5e                   	pop    %esi
  802c0b:	5f                   	pop    %edi
  802c0c:	5d                   	pop    %ebp
  802c0d:	c3                   	ret    
  802c0e:	66 90                	xchg   %ax,%ax
  802c10:	85 ff                	test   %edi,%edi
  802c12:	75 0b                	jne    802c1f <__umoddi3+0x6f>
  802c14:	b8 01 00 00 00       	mov    $0x1,%eax
  802c19:	31 d2                	xor    %edx,%edx
  802c1b:	f7 f7                	div    %edi
  802c1d:	89 c7                	mov    %eax,%edi
  802c1f:	89 f0                	mov    %esi,%eax
  802c21:	31 d2                	xor    %edx,%edx
  802c23:	f7 f7                	div    %edi
  802c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c28:	f7 f7                	div    %edi
  802c2a:	eb a9                	jmp    802bd5 <__umoddi3+0x25>
  802c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c30:	89 c8                	mov    %ecx,%eax
  802c32:	89 f2                	mov    %esi,%edx
  802c34:	83 c4 20             	add    $0x20,%esp
  802c37:	5e                   	pop    %esi
  802c38:	5f                   	pop    %edi
  802c39:	5d                   	pop    %ebp
  802c3a:	c3                   	ret    
  802c3b:	90                   	nop
  802c3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c40:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c44:	d3 e2                	shl    %cl,%edx
  802c46:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802c49:	ba 20 00 00 00       	mov    $0x20,%edx
  802c4e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802c51:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802c54:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802c58:	89 fa                	mov    %edi,%edx
  802c5a:	d3 ea                	shr    %cl,%edx
  802c5c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c60:	0b 55 f4             	or     -0xc(%ebp),%edx
  802c63:	d3 e7                	shl    %cl,%edi
  802c65:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802c69:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802c6c:	89 f2                	mov    %esi,%edx
  802c6e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802c71:	89 c7                	mov    %eax,%edi
  802c73:	d3 ea                	shr    %cl,%edx
  802c75:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c79:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802c7c:	89 c2                	mov    %eax,%edx
  802c7e:	d3 e6                	shl    %cl,%esi
  802c80:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802c84:	d3 ea                	shr    %cl,%edx
  802c86:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c8a:	09 d6                	or     %edx,%esi
  802c8c:	89 f0                	mov    %esi,%eax
  802c8e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802c91:	d3 e7                	shl    %cl,%edi
  802c93:	89 f2                	mov    %esi,%edx
  802c95:	f7 75 f4             	divl   -0xc(%ebp)
  802c98:	89 d6                	mov    %edx,%esi
  802c9a:	f7 65 e8             	mull   -0x18(%ebp)
  802c9d:	39 d6                	cmp    %edx,%esi
  802c9f:	72 2b                	jb     802ccc <__umoddi3+0x11c>
  802ca1:	39 c7                	cmp    %eax,%edi
  802ca3:	72 23                	jb     802cc8 <__umoddi3+0x118>
  802ca5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ca9:	29 c7                	sub    %eax,%edi
  802cab:	19 d6                	sbb    %edx,%esi
  802cad:	89 f0                	mov    %esi,%eax
  802caf:	89 f2                	mov    %esi,%edx
  802cb1:	d3 ef                	shr    %cl,%edi
  802cb3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802cb7:	d3 e0                	shl    %cl,%eax
  802cb9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802cbd:	09 f8                	or     %edi,%eax
  802cbf:	d3 ea                	shr    %cl,%edx
  802cc1:	83 c4 20             	add    $0x20,%esp
  802cc4:	5e                   	pop    %esi
  802cc5:	5f                   	pop    %edi
  802cc6:	5d                   	pop    %ebp
  802cc7:	c3                   	ret    
  802cc8:	39 d6                	cmp    %edx,%esi
  802cca:	75 d9                	jne    802ca5 <__umoddi3+0xf5>
  802ccc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802ccf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802cd2:	eb d1                	jmp    802ca5 <__umoddi3+0xf5>
  802cd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cd8:	39 f2                	cmp    %esi,%edx
  802cda:	0f 82 18 ff ff ff    	jb     802bf8 <__umoddi3+0x48>
  802ce0:	e9 1d ff ff ff       	jmp    802c02 <__umoddi3+0x52>
