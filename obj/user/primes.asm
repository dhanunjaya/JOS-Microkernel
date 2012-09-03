
obj/user/primes:     file format elf32-i386


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
  80002c:	e8 13 01 00 00       	call   800144 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
	int i, id, p;
	envid_t envid;

	// fetch a prime from our left neighbor
top:
	p = ipc_recv(&envid, 0, 0);
  80003d:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  800040:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800047:	00 
  800048:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80004f:	00 
  800050:	89 34 24             	mov    %esi,(%esp)
  800053:	e8 7a 15 00 00       	call   8015d2 <ipc_recv>
  800058:	89 c3                	mov    %eax,%ebx
	cprintf("%d ", p);
  80005a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005e:	c7 04 24 40 2d 80 00 	movl   $0x802d40,(%esp)
  800065:	e8 0b 02 00 00       	call   800275 <cprintf>

	// fork a right neighbor to continue the chain
	if ((id = fork()) < 0)
  80006a:	e8 c8 12 00 00       	call   801337 <fork>
  80006f:	89 c7                	mov    %eax,%edi
  800071:	85 c0                	test   %eax,%eax
  800073:	79 20                	jns    800095 <primeproc+0x61>
		panic("fork: %e", id);
  800075:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800079:	c7 44 24 08 e3 30 80 	movl   $0x8030e3,0x8(%esp)
  800080:	00 
  800081:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800088:	00 
  800089:	c7 04 24 44 2d 80 00 	movl   $0x802d44,(%esp)
  800090:	e8 1b 01 00 00       	call   8001b0 <_panic>
	if (id == 0)
  800095:	85 c0                	test   %eax,%eax
  800097:	74 a7                	je     800040 <primeproc+0xc>
		goto top;
	
	// filter out multiples of our prime
	while (1) {
		i = ipc_recv(&envid, 0, 0);
  800099:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80009c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000a3:	00 
  8000a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000ab:	00 
  8000ac:	89 34 24             	mov    %esi,(%esp)
  8000af:	e8 1e 15 00 00       	call   8015d2 <ipc_recv>
  8000b4:	89 c1                	mov    %eax,%ecx
		if (i % p)
  8000b6:	89 c2                	mov    %eax,%edx
  8000b8:	c1 fa 1f             	sar    $0x1f,%edx
  8000bb:	f7 fb                	idiv   %ebx
  8000bd:	85 d2                	test   %edx,%edx
  8000bf:	74 db                	je     80009c <primeproc+0x68>
			ipc_send(id, i, 0, 0);
  8000c1:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8000c8:	00 
  8000c9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000d0:	00 
  8000d1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8000d5:	89 3c 24             	mov    %edi,(%esp)
  8000d8:	e8 93 14 00 00       	call   801570 <ipc_send>
  8000dd:	eb bd                	jmp    80009c <primeproc+0x68>

008000df <umain>:
	}
}

void
umain(void)
{
  8000df:	55                   	push   %ebp
  8000e0:	89 e5                	mov    %esp,%ebp
  8000e2:	56                   	push   %esi
  8000e3:	53                   	push   %ebx
  8000e4:	83 ec 10             	sub    $0x10,%esp
	int i, id;

	// fork the first prime process in the chain
	if ((id = fork()) < 0)
  8000e7:	e8 4b 12 00 00       	call   801337 <fork>
  8000ec:	89 c6                	mov    %eax,%esi
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	79 20                	jns    800112 <umain+0x33>
		panic("fork: %e", id);
  8000f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000f6:	c7 44 24 08 e3 30 80 	movl   $0x8030e3,0x8(%esp)
  8000fd:	00 
  8000fe:	c7 44 24 04 2d 00 00 	movl   $0x2d,0x4(%esp)
  800105:	00 
  800106:	c7 04 24 44 2d 80 00 	movl   $0x802d44,(%esp)
  80010d:	e8 9e 00 00 00       	call   8001b0 <_panic>
	if (id == 0)
  800112:	bb 02 00 00 00       	mov    $0x2,%ebx
  800117:	85 c0                	test   %eax,%eax
  800119:	75 05                	jne    800120 <umain+0x41>
		primeproc();
  80011b:	e8 14 ff ff ff       	call   800034 <primeproc>

	// feed all the integers through
	for (i = 2; ; i++)
		ipc_send(id, i, 0, 0);
  800120:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800127:	00 
  800128:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80012f:	00 
  800130:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800134:	89 34 24             	mov    %esi,(%esp)
  800137:	e8 34 14 00 00       	call   801570 <ipc_send>
		panic("fork: %e", id);
	if (id == 0)
		primeproc();

	// feed all the integers through
	for (i = 2; ; i++)
  80013c:	83 c3 01             	add    $0x1,%ebx
  80013f:	eb df                	jmp    800120 <umain+0x41>
  800141:	00 00                	add    %al,(%eax)
	...

00800144 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800144:	55                   	push   %ebp
  800145:	89 e5                	mov    %esp,%ebp
  800147:	83 ec 18             	sub    $0x18,%esp
  80014a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80014d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800150:	8b 75 08             	mov    0x8(%ebp),%esi
  800153:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  800156:	e8 ee 0f 00 00       	call   801149 <sys_getenvid>
  80015b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800160:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800163:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800168:	a3 74 70 80 00       	mov    %eax,0x807074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016d:	85 f6                	test   %esi,%esi
  80016f:	7e 07                	jle    800178 <libmain+0x34>
		binaryname = argv[0];
  800171:	8b 03                	mov    (%ebx),%eax
  800173:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  800178:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80017c:	89 34 24             	mov    %esi,(%esp)
  80017f:	e8 5b ff ff ff       	call   8000df <umain>

	// exit gracefully
	exit();
  800184:	e8 0b 00 00 00       	call   800194 <exit>
}
  800189:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80018c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80018f:	89 ec                	mov    %ebp,%esp
  800191:	5d                   	pop    %ebp
  800192:	c3                   	ret    
	...

00800194 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800194:	55                   	push   %ebp
  800195:	89 e5                	mov    %esp,%ebp
  800197:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80019a:	e8 7c 19 00 00       	call   801b1b <close_all>
	sys_env_destroy(0);
  80019f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001a6:	e8 d2 0f 00 00       	call   80117d <sys_env_destroy>
}
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    
  8001ad:	00 00                	add    %al,(%eax)
	...

008001b0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001b0:	55                   	push   %ebp
  8001b1:	89 e5                	mov    %esp,%ebp
  8001b3:	53                   	push   %ebx
  8001b4:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  8001b7:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  8001ba:	a1 78 70 80 00       	mov    0x807078,%eax
  8001bf:	85 c0                	test   %eax,%eax
  8001c1:	74 10                	je     8001d3 <_panic+0x23>
		cprintf("%s: ", argv0);
  8001c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001c7:	c7 04 24 69 2d 80 00 	movl   $0x802d69,(%esp)
  8001ce:	e8 a2 00 00 00       	call   800275 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001da:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001e1:	a1 00 70 80 00       	mov    0x807000,%eax
  8001e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ea:	c7 04 24 6e 2d 80 00 	movl   $0x802d6e,(%esp)
  8001f1:	e8 7f 00 00 00       	call   800275 <cprintf>
	vcprintf(fmt, ap);
  8001f6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8001fd:	89 04 24             	mov    %eax,(%esp)
  800200:	e8 0f 00 00 00       	call   800214 <vcprintf>
	cprintf("\n");
  800205:	c7 04 24 7d 32 80 00 	movl   $0x80327d,(%esp)
  80020c:	e8 64 00 00 00       	call   800275 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800211:	cc                   	int3   
  800212:	eb fd                	jmp    800211 <_panic+0x61>

00800214 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80021d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800224:	00 00 00 
	b.cnt = 0;
  800227:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80022e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800231:	8b 45 0c             	mov    0xc(%ebp),%eax
  800234:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800238:	8b 45 08             	mov    0x8(%ebp),%eax
  80023b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80023f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800245:	89 44 24 04          	mov    %eax,0x4(%esp)
  800249:	c7 04 24 8f 02 80 00 	movl   $0x80028f,(%esp)
  800250:	e8 d8 01 00 00       	call   80042d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800255:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80025b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800265:	89 04 24             	mov    %eax,(%esp)
  800268:	e8 e3 0a 00 00       	call   800d50 <sys_cputs>

	return b.cnt;
}
  80026d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80027b:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80027e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800282:	8b 45 08             	mov    0x8(%ebp),%eax
  800285:	89 04 24             	mov    %eax,(%esp)
  800288:	e8 87 ff ff ff       	call   800214 <vcprintf>
	va_end(ap);

	return cnt;
}
  80028d:	c9                   	leave  
  80028e:	c3                   	ret    

0080028f <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80028f:	55                   	push   %ebp
  800290:	89 e5                	mov    %esp,%ebp
  800292:	53                   	push   %ebx
  800293:	83 ec 14             	sub    $0x14,%esp
  800296:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800299:	8b 03                	mov    (%ebx),%eax
  80029b:	8b 55 08             	mov    0x8(%ebp),%edx
  80029e:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002a2:	83 c0 01             	add    $0x1,%eax
  8002a5:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002a7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ac:	75 19                	jne    8002c7 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002ae:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002b5:	00 
  8002b6:	8d 43 08             	lea    0x8(%ebx),%eax
  8002b9:	89 04 24             	mov    %eax,(%esp)
  8002bc:	e8 8f 0a 00 00       	call   800d50 <sys_cputs>
		b->idx = 0;
  8002c1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002c7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002cb:	83 c4 14             	add    $0x14,%esp
  8002ce:	5b                   	pop    %ebx
  8002cf:	5d                   	pop    %ebp
  8002d0:	c3                   	ret    
	...

008002e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002e0:	55                   	push   %ebp
  8002e1:	89 e5                	mov    %esp,%ebp
  8002e3:	57                   	push   %edi
  8002e4:	56                   	push   %esi
  8002e5:	53                   	push   %ebx
  8002e6:	83 ec 4c             	sub    $0x4c,%esp
  8002e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002ec:	89 d6                	mov    %edx,%esi
  8002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002f7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8002fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8002fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800300:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800303:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800306:	b9 00 00 00 00       	mov    $0x0,%ecx
  80030b:	39 d1                	cmp    %edx,%ecx
  80030d:	72 15                	jb     800324 <printnum+0x44>
  80030f:	77 07                	ja     800318 <printnum+0x38>
  800311:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800314:	39 d0                	cmp    %edx,%eax
  800316:	76 0c                	jbe    800324 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800318:	83 eb 01             	sub    $0x1,%ebx
  80031b:	85 db                	test   %ebx,%ebx
  80031d:	8d 76 00             	lea    0x0(%esi),%esi
  800320:	7f 61                	jg     800383 <printnum+0xa3>
  800322:	eb 70                	jmp    800394 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800324:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800328:	83 eb 01             	sub    $0x1,%ebx
  80032b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80032f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800333:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800337:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80033b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80033e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800341:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800344:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800348:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80034f:	00 
  800350:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800353:	89 04 24             	mov    %eax,(%esp)
  800356:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800359:	89 54 24 04          	mov    %edx,0x4(%esp)
  80035d:	e8 5e 27 00 00       	call   802ac0 <__udivdi3>
  800362:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800365:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800368:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80036c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800370:	89 04 24             	mov    %eax,(%esp)
  800373:	89 54 24 04          	mov    %edx,0x4(%esp)
  800377:	89 f2                	mov    %esi,%edx
  800379:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80037c:	e8 5f ff ff ff       	call   8002e0 <printnum>
  800381:	eb 11                	jmp    800394 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800383:	89 74 24 04          	mov    %esi,0x4(%esp)
  800387:	89 3c 24             	mov    %edi,(%esp)
  80038a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80038d:	83 eb 01             	sub    $0x1,%ebx
  800390:	85 db                	test   %ebx,%ebx
  800392:	7f ef                	jg     800383 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800394:	89 74 24 04          	mov    %esi,0x4(%esp)
  800398:	8b 74 24 04          	mov    0x4(%esp),%esi
  80039c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003a3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003aa:	00 
  8003ab:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003ae:	89 14 24             	mov    %edx,(%esp)
  8003b1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003b4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003b8:	e8 33 28 00 00       	call   802bf0 <__umoddi3>
  8003bd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003c1:	0f be 80 8a 2d 80 00 	movsbl 0x802d8a(%eax),%eax
  8003c8:	89 04 24             	mov    %eax,(%esp)
  8003cb:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8003ce:	83 c4 4c             	add    $0x4c,%esp
  8003d1:	5b                   	pop    %ebx
  8003d2:	5e                   	pop    %esi
  8003d3:	5f                   	pop    %edi
  8003d4:	5d                   	pop    %ebp
  8003d5:	c3                   	ret    

008003d6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003d6:	55                   	push   %ebp
  8003d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003d9:	83 fa 01             	cmp    $0x1,%edx
  8003dc:	7e 0e                	jle    8003ec <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003de:	8b 10                	mov    (%eax),%edx
  8003e0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003e3:	89 08                	mov    %ecx,(%eax)
  8003e5:	8b 02                	mov    (%edx),%eax
  8003e7:	8b 52 04             	mov    0x4(%edx),%edx
  8003ea:	eb 22                	jmp    80040e <getuint+0x38>
	else if (lflag)
  8003ec:	85 d2                	test   %edx,%edx
  8003ee:	74 10                	je     800400 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8003f0:	8b 10                	mov    (%eax),%edx
  8003f2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8003f5:	89 08                	mov    %ecx,(%eax)
  8003f7:	8b 02                	mov    (%edx),%eax
  8003f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fe:	eb 0e                	jmp    80040e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800400:	8b 10                	mov    (%eax),%edx
  800402:	8d 4a 04             	lea    0x4(%edx),%ecx
  800405:	89 08                	mov    %ecx,(%eax)
  800407:	8b 02                	mov    (%edx),%eax
  800409:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80040e:	5d                   	pop    %ebp
  80040f:	c3                   	ret    

00800410 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800416:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80041a:	8b 10                	mov    (%eax),%edx
  80041c:	3b 50 04             	cmp    0x4(%eax),%edx
  80041f:	73 0a                	jae    80042b <sprintputch+0x1b>
		*b->buf++ = ch;
  800421:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800424:	88 0a                	mov    %cl,(%edx)
  800426:	83 c2 01             	add    $0x1,%edx
  800429:	89 10                	mov    %edx,(%eax)
}
  80042b:	5d                   	pop    %ebp
  80042c:	c3                   	ret    

0080042d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80042d:	55                   	push   %ebp
  80042e:	89 e5                	mov    %esp,%ebp
  800430:	57                   	push   %edi
  800431:	56                   	push   %esi
  800432:	53                   	push   %ebx
  800433:	83 ec 5c             	sub    $0x5c,%esp
  800436:	8b 7d 08             	mov    0x8(%ebp),%edi
  800439:	8b 75 0c             	mov    0xc(%ebp),%esi
  80043c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80043f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800446:	eb 11                	jmp    800459 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800448:	85 c0                	test   %eax,%eax
  80044a:	0f 84 09 04 00 00    	je     800859 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  800450:	89 74 24 04          	mov    %esi,0x4(%esp)
  800454:	89 04 24             	mov    %eax,(%esp)
  800457:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800459:	0f b6 03             	movzbl (%ebx),%eax
  80045c:	83 c3 01             	add    $0x1,%ebx
  80045f:	83 f8 25             	cmp    $0x25,%eax
  800462:	75 e4                	jne    800448 <vprintfmt+0x1b>
  800464:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800468:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80046f:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800476:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80047d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800482:	eb 06                	jmp    80048a <vprintfmt+0x5d>
  800484:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800488:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80048a:	0f b6 13             	movzbl (%ebx),%edx
  80048d:	0f b6 c2             	movzbl %dl,%eax
  800490:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800493:	8d 43 01             	lea    0x1(%ebx),%eax
  800496:	83 ea 23             	sub    $0x23,%edx
  800499:	80 fa 55             	cmp    $0x55,%dl
  80049c:	0f 87 9a 03 00 00    	ja     80083c <vprintfmt+0x40f>
  8004a2:	0f b6 d2             	movzbl %dl,%edx
  8004a5:	ff 24 95 c0 2e 80 00 	jmp    *0x802ec0(,%edx,4)
  8004ac:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8004b0:	eb d6                	jmp    800488 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004b5:	83 ea 30             	sub    $0x30,%edx
  8004b8:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  8004bb:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8004be:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8004c1:	83 fb 09             	cmp    $0x9,%ebx
  8004c4:	77 4c                	ja     800512 <vprintfmt+0xe5>
  8004c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004c9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004cc:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8004cf:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004d2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8004d6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8004d9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8004dc:	83 fb 09             	cmp    $0x9,%ebx
  8004df:	76 eb                	jbe    8004cc <vprintfmt+0x9f>
  8004e1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8004e4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004e7:	eb 29                	jmp    800512 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004e9:	8b 55 14             	mov    0x14(%ebp),%edx
  8004ec:	8d 5a 04             	lea    0x4(%edx),%ebx
  8004ef:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8004f2:	8b 12                	mov    (%edx),%edx
  8004f4:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  8004f7:	eb 19                	jmp    800512 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8004f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8004fc:	c1 fa 1f             	sar    $0x1f,%edx
  8004ff:	f7 d2                	not    %edx
  800501:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800504:	eb 82                	jmp    800488 <vprintfmt+0x5b>
  800506:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80050d:	e9 76 ff ff ff       	jmp    800488 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800512:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800516:	0f 89 6c ff ff ff    	jns    800488 <vprintfmt+0x5b>
  80051c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80051f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800522:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800525:	89 55 cc             	mov    %edx,-0x34(%ebp)
  800528:	e9 5b ff ff ff       	jmp    800488 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80052d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800530:	e9 53 ff ff ff       	jmp    800488 <vprintfmt+0x5b>
  800535:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800538:	8b 45 14             	mov    0x14(%ebp),%eax
  80053b:	8d 50 04             	lea    0x4(%eax),%edx
  80053e:	89 55 14             	mov    %edx,0x14(%ebp)
  800541:	89 74 24 04          	mov    %esi,0x4(%esp)
  800545:	8b 00                	mov    (%eax),%eax
  800547:	89 04 24             	mov    %eax,(%esp)
  80054a:	ff d7                	call   *%edi
  80054c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80054f:	e9 05 ff ff ff       	jmp    800459 <vprintfmt+0x2c>
  800554:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	8d 50 04             	lea    0x4(%eax),%edx
  80055d:	89 55 14             	mov    %edx,0x14(%ebp)
  800560:	8b 00                	mov    (%eax),%eax
  800562:	89 c2                	mov    %eax,%edx
  800564:	c1 fa 1f             	sar    $0x1f,%edx
  800567:	31 d0                	xor    %edx,%eax
  800569:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80056b:	83 f8 0f             	cmp    $0xf,%eax
  80056e:	7f 0b                	jg     80057b <vprintfmt+0x14e>
  800570:	8b 14 85 20 30 80 00 	mov    0x803020(,%eax,4),%edx
  800577:	85 d2                	test   %edx,%edx
  800579:	75 20                	jne    80059b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80057b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80057f:	c7 44 24 08 9b 2d 80 	movl   $0x802d9b,0x8(%esp)
  800586:	00 
  800587:	89 74 24 04          	mov    %esi,0x4(%esp)
  80058b:	89 3c 24             	mov    %edi,(%esp)
  80058e:	e8 4e 03 00 00       	call   8008e1 <printfmt>
  800593:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800596:	e9 be fe ff ff       	jmp    800459 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80059b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80059f:	c7 44 24 08 41 32 80 	movl   $0x803241,0x8(%esp)
  8005a6:	00 
  8005a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005ab:	89 3c 24             	mov    %edi,(%esp)
  8005ae:	e8 2e 03 00 00       	call   8008e1 <printfmt>
  8005b3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005b6:	e9 9e fe ff ff       	jmp    800459 <vprintfmt+0x2c>
  8005bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005be:	89 c3                	mov    %eax,%ebx
  8005c0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8005c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005c6:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cc:	8d 50 04             	lea    0x4(%eax),%edx
  8005cf:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8005d7:	85 c0                	test   %eax,%eax
  8005d9:	75 07                	jne    8005e2 <vprintfmt+0x1b5>
  8005db:	c7 45 c4 a4 2d 80 00 	movl   $0x802da4,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  8005e2:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8005e6:	7e 06                	jle    8005ee <vprintfmt+0x1c1>
  8005e8:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  8005ec:	75 13                	jne    800601 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005ee:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8005f1:	0f be 02             	movsbl (%edx),%eax
  8005f4:	85 c0                	test   %eax,%eax
  8005f6:	0f 85 99 00 00 00    	jne    800695 <vprintfmt+0x268>
  8005fc:	e9 86 00 00 00       	jmp    800687 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800601:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800605:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800608:	89 0c 24             	mov    %ecx,(%esp)
  80060b:	e8 1b 03 00 00       	call   80092b <strnlen>
  800610:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800613:	29 c2                	sub    %eax,%edx
  800615:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800618:	85 d2                	test   %edx,%edx
  80061a:	7e d2                	jle    8005ee <vprintfmt+0x1c1>
					putch(padc, putdat);
  80061c:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  800620:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800623:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  800626:	89 d3                	mov    %edx,%ebx
  800628:	89 74 24 04          	mov    %esi,0x4(%esp)
  80062c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80062f:	89 04 24             	mov    %eax,(%esp)
  800632:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800634:	83 eb 01             	sub    $0x1,%ebx
  800637:	85 db                	test   %ebx,%ebx
  800639:	7f ed                	jg     800628 <vprintfmt+0x1fb>
  80063b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80063e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800645:	eb a7                	jmp    8005ee <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800647:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80064b:	74 18                	je     800665 <vprintfmt+0x238>
  80064d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800650:	83 fa 5e             	cmp    $0x5e,%edx
  800653:	76 10                	jbe    800665 <vprintfmt+0x238>
					putch('?', putdat);
  800655:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800659:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800660:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800663:	eb 0a                	jmp    80066f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800665:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800669:	89 04 24             	mov    %eax,(%esp)
  80066c:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80066f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800673:	0f be 03             	movsbl (%ebx),%eax
  800676:	85 c0                	test   %eax,%eax
  800678:	74 05                	je     80067f <vprintfmt+0x252>
  80067a:	83 c3 01             	add    $0x1,%ebx
  80067d:	eb 29                	jmp    8006a8 <vprintfmt+0x27b>
  80067f:	89 fe                	mov    %edi,%esi
  800681:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800684:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800687:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80068b:	7f 2e                	jg     8006bb <vprintfmt+0x28e>
  80068d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800690:	e9 c4 fd ff ff       	jmp    800459 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800695:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800698:	83 c2 01             	add    $0x1,%edx
  80069b:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80069e:	89 f7                	mov    %esi,%edi
  8006a0:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006a3:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  8006a6:	89 d3                	mov    %edx,%ebx
  8006a8:	85 f6                	test   %esi,%esi
  8006aa:	78 9b                	js     800647 <vprintfmt+0x21a>
  8006ac:	83 ee 01             	sub    $0x1,%esi
  8006af:	79 96                	jns    800647 <vprintfmt+0x21a>
  8006b1:	89 fe                	mov    %edi,%esi
  8006b3:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006b6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8006b9:	eb cc                	jmp    800687 <vprintfmt+0x25a>
  8006bb:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8006be:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006c5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006cc:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006ce:	83 eb 01             	sub    $0x1,%ebx
  8006d1:	85 db                	test   %ebx,%ebx
  8006d3:	7f ec                	jg     8006c1 <vprintfmt+0x294>
  8006d5:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8006d8:	e9 7c fd ff ff       	jmp    800459 <vprintfmt+0x2c>
  8006dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006e0:	83 f9 01             	cmp    $0x1,%ecx
  8006e3:	7e 16                	jle    8006fb <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  8006e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e8:	8d 50 08             	lea    0x8(%eax),%edx
  8006eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8006ee:	8b 10                	mov    (%eax),%edx
  8006f0:	8b 48 04             	mov    0x4(%eax),%ecx
  8006f3:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8006f6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8006f9:	eb 32                	jmp    80072d <vprintfmt+0x300>
	else if (lflag)
  8006fb:	85 c9                	test   %ecx,%ecx
  8006fd:	74 18                	je     800717 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8d 50 04             	lea    0x4(%eax),%edx
  800705:	89 55 14             	mov    %edx,0x14(%ebp)
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80070d:	89 c1                	mov    %eax,%ecx
  80070f:	c1 f9 1f             	sar    $0x1f,%ecx
  800712:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800715:	eb 16                	jmp    80072d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800717:	8b 45 14             	mov    0x14(%ebp),%eax
  80071a:	8d 50 04             	lea    0x4(%eax),%edx
  80071d:	89 55 14             	mov    %edx,0x14(%ebp)
  800720:	8b 00                	mov    (%eax),%eax
  800722:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800725:	89 c2                	mov    %eax,%edx
  800727:	c1 fa 1f             	sar    $0x1f,%edx
  80072a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80072d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800730:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800733:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800738:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80073c:	0f 89 b8 00 00 00    	jns    8007fa <vprintfmt+0x3cd>
				putch('-', putdat);
  800742:	89 74 24 04          	mov    %esi,0x4(%esp)
  800746:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80074d:	ff d7                	call   *%edi
				num = -(long long) num;
  80074f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800752:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800755:	f7 d9                	neg    %ecx
  800757:	83 d3 00             	adc    $0x0,%ebx
  80075a:	f7 db                	neg    %ebx
  80075c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800761:	e9 94 00 00 00       	jmp    8007fa <vprintfmt+0x3cd>
  800766:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800769:	89 ca                	mov    %ecx,%edx
  80076b:	8d 45 14             	lea    0x14(%ebp),%eax
  80076e:	e8 63 fc ff ff       	call   8003d6 <getuint>
  800773:	89 c1                	mov    %eax,%ecx
  800775:	89 d3                	mov    %edx,%ebx
  800777:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80077c:	eb 7c                	jmp    8007fa <vprintfmt+0x3cd>
  80077e:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800781:	89 74 24 04          	mov    %esi,0x4(%esp)
  800785:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  80078c:	ff d7                	call   *%edi
			putch('X', putdat);
  80078e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800792:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800799:	ff d7                	call   *%edi
			putch('X', putdat);
  80079b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80079f:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8007a6:	ff d7                	call   *%edi
  8007a8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8007ab:	e9 a9 fc ff ff       	jmp    800459 <vprintfmt+0x2c>
  8007b0:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8007b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007b7:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007be:	ff d7                	call   *%edi
			putch('x', putdat);
  8007c0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007c4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007cb:	ff d7                	call   *%edi
			num = (unsigned long long)
  8007cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d0:	8d 50 04             	lea    0x4(%eax),%edx
  8007d3:	89 55 14             	mov    %edx,0x14(%ebp)
  8007d6:	8b 08                	mov    (%eax),%ecx
  8007d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007dd:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8007e2:	eb 16                	jmp    8007fa <vprintfmt+0x3cd>
  8007e4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007e7:	89 ca                	mov    %ecx,%edx
  8007e9:	8d 45 14             	lea    0x14(%ebp),%eax
  8007ec:	e8 e5 fb ff ff       	call   8003d6 <getuint>
  8007f1:	89 c1                	mov    %eax,%ecx
  8007f3:	89 d3                	mov    %edx,%ebx
  8007f5:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8007fa:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  8007fe:	89 54 24 10          	mov    %edx,0x10(%esp)
  800802:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800805:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800809:	89 44 24 08          	mov    %eax,0x8(%esp)
  80080d:	89 0c 24             	mov    %ecx,(%esp)
  800810:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800814:	89 f2                	mov    %esi,%edx
  800816:	89 f8                	mov    %edi,%eax
  800818:	e8 c3 fa ff ff       	call   8002e0 <printnum>
  80081d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800820:	e9 34 fc ff ff       	jmp    800459 <vprintfmt+0x2c>
  800825:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800828:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80082b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80082f:	89 14 24             	mov    %edx,(%esp)
  800832:	ff d7                	call   *%edi
  800834:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800837:	e9 1d fc ff ff       	jmp    800459 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80083c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800840:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800847:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800849:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80084c:	80 38 25             	cmpb   $0x25,(%eax)
  80084f:	0f 84 04 fc ff ff    	je     800459 <vprintfmt+0x2c>
  800855:	89 c3                	mov    %eax,%ebx
  800857:	eb f0                	jmp    800849 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  800859:	83 c4 5c             	add    $0x5c,%esp
  80085c:	5b                   	pop    %ebx
  80085d:	5e                   	pop    %esi
  80085e:	5f                   	pop    %edi
  80085f:	5d                   	pop    %ebp
  800860:	c3                   	ret    

00800861 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800861:	55                   	push   %ebp
  800862:	89 e5                	mov    %esp,%ebp
  800864:	83 ec 28             	sub    $0x28,%esp
  800867:	8b 45 08             	mov    0x8(%ebp),%eax
  80086a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  80086d:	85 c0                	test   %eax,%eax
  80086f:	74 04                	je     800875 <vsnprintf+0x14>
  800871:	85 d2                	test   %edx,%edx
  800873:	7f 07                	jg     80087c <vsnprintf+0x1b>
  800875:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80087a:	eb 3b                	jmp    8008b7 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80087c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80087f:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800883:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800886:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80088d:	8b 45 14             	mov    0x14(%ebp),%eax
  800890:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800894:	8b 45 10             	mov    0x10(%ebp),%eax
  800897:	89 44 24 08          	mov    %eax,0x8(%esp)
  80089b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80089e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a2:	c7 04 24 10 04 80 00 	movl   $0x800410,(%esp)
  8008a9:	e8 7f fb ff ff       	call   80042d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008b1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008b7:	c9                   	leave  
  8008b8:	c3                   	ret    

008008b9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008b9:	55                   	push   %ebp
  8008ba:	89 e5                	mov    %esp,%ebp
  8008bc:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8008bf:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8008c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d7:	89 04 24             	mov    %eax,(%esp)
  8008da:	e8 82 ff ff ff       	call   800861 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008df:	c9                   	leave  
  8008e0:	c3                   	ret    

008008e1 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8008e7:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8008ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	89 04 24             	mov    %eax,(%esp)
  800902:	e8 26 fb ff ff       	call   80042d <vprintfmt>
	va_end(ap);
}
  800907:	c9                   	leave  
  800908:	c3                   	ret    
  800909:	00 00                	add    %al,(%eax)
  80090b:	00 00                	add    %al,(%eax)
  80090d:	00 00                	add    %al,(%eax)
	...

00800910 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800910:	55                   	push   %ebp
  800911:	89 e5                	mov    %esp,%ebp
  800913:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800916:	b8 00 00 00 00       	mov    $0x0,%eax
  80091b:	80 3a 00             	cmpb   $0x0,(%edx)
  80091e:	74 09                	je     800929 <strlen+0x19>
		n++;
  800920:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800923:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800927:	75 f7                	jne    800920 <strlen+0x10>
		n++;
	return n;
}
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	53                   	push   %ebx
  80092f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800932:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800935:	85 c9                	test   %ecx,%ecx
  800937:	74 19                	je     800952 <strnlen+0x27>
  800939:	80 3b 00             	cmpb   $0x0,(%ebx)
  80093c:	74 14                	je     800952 <strnlen+0x27>
  80093e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800943:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800946:	39 c8                	cmp    %ecx,%eax
  800948:	74 0d                	je     800957 <strnlen+0x2c>
  80094a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80094e:	75 f3                	jne    800943 <strnlen+0x18>
  800950:	eb 05                	jmp    800957 <strnlen+0x2c>
  800952:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800957:	5b                   	pop    %ebx
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	53                   	push   %ebx
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800964:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800969:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80096d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800970:	83 c2 01             	add    $0x1,%edx
  800973:	84 c9                	test   %cl,%cl
  800975:	75 f2                	jne    800969 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800977:	5b                   	pop    %ebx
  800978:	5d                   	pop    %ebp
  800979:	c3                   	ret    

0080097a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	56                   	push   %esi
  80097e:	53                   	push   %ebx
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	8b 55 0c             	mov    0xc(%ebp),%edx
  800985:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800988:	85 f6                	test   %esi,%esi
  80098a:	74 18                	je     8009a4 <strncpy+0x2a>
  80098c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800991:	0f b6 1a             	movzbl (%edx),%ebx
  800994:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800997:	80 3a 01             	cmpb   $0x1,(%edx)
  80099a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80099d:	83 c1 01             	add    $0x1,%ecx
  8009a0:	39 ce                	cmp    %ecx,%esi
  8009a2:	77 ed                	ja     800991 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009a4:	5b                   	pop    %ebx
  8009a5:	5e                   	pop    %esi
  8009a6:	5d                   	pop    %ebp
  8009a7:	c3                   	ret    

008009a8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009a8:	55                   	push   %ebp
  8009a9:	89 e5                	mov    %esp,%ebp
  8009ab:	56                   	push   %esi
  8009ac:	53                   	push   %ebx
  8009ad:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009b6:	89 f0                	mov    %esi,%eax
  8009b8:	85 c9                	test   %ecx,%ecx
  8009ba:	74 27                	je     8009e3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  8009bc:	83 e9 01             	sub    $0x1,%ecx
  8009bf:	74 1d                	je     8009de <strlcpy+0x36>
  8009c1:	0f b6 1a             	movzbl (%edx),%ebx
  8009c4:	84 db                	test   %bl,%bl
  8009c6:	74 16                	je     8009de <strlcpy+0x36>
			*dst++ = *src++;
  8009c8:	88 18                	mov    %bl,(%eax)
  8009ca:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009cd:	83 e9 01             	sub    $0x1,%ecx
  8009d0:	74 0e                	je     8009e0 <strlcpy+0x38>
			*dst++ = *src++;
  8009d2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009d5:	0f b6 1a             	movzbl (%edx),%ebx
  8009d8:	84 db                	test   %bl,%bl
  8009da:	75 ec                	jne    8009c8 <strlcpy+0x20>
  8009dc:	eb 02                	jmp    8009e0 <strlcpy+0x38>
  8009de:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8009e0:	c6 00 00             	movb   $0x0,(%eax)
  8009e3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8009e5:	5b                   	pop    %ebx
  8009e6:	5e                   	pop    %esi
  8009e7:	5d                   	pop    %ebp
  8009e8:	c3                   	ret    

008009e9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e9:	55                   	push   %ebp
  8009ea:	89 e5                	mov    %esp,%ebp
  8009ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ef:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f2:	0f b6 01             	movzbl (%ecx),%eax
  8009f5:	84 c0                	test   %al,%al
  8009f7:	74 15                	je     800a0e <strcmp+0x25>
  8009f9:	3a 02                	cmp    (%edx),%al
  8009fb:	75 11                	jne    800a0e <strcmp+0x25>
		p++, q++;
  8009fd:	83 c1 01             	add    $0x1,%ecx
  800a00:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a03:	0f b6 01             	movzbl (%ecx),%eax
  800a06:	84 c0                	test   %al,%al
  800a08:	74 04                	je     800a0e <strcmp+0x25>
  800a0a:	3a 02                	cmp    (%edx),%al
  800a0c:	74 ef                	je     8009fd <strcmp+0x14>
  800a0e:	0f b6 c0             	movzbl %al,%eax
  800a11:	0f b6 12             	movzbl (%edx),%edx
  800a14:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a16:	5d                   	pop    %ebp
  800a17:	c3                   	ret    

00800a18 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	53                   	push   %ebx
  800a1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a22:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800a25:	85 c0                	test   %eax,%eax
  800a27:	74 23                	je     800a4c <strncmp+0x34>
  800a29:	0f b6 1a             	movzbl (%edx),%ebx
  800a2c:	84 db                	test   %bl,%bl
  800a2e:	74 24                	je     800a54 <strncmp+0x3c>
  800a30:	3a 19                	cmp    (%ecx),%bl
  800a32:	75 20                	jne    800a54 <strncmp+0x3c>
  800a34:	83 e8 01             	sub    $0x1,%eax
  800a37:	74 13                	je     800a4c <strncmp+0x34>
		n--, p++, q++;
  800a39:	83 c2 01             	add    $0x1,%edx
  800a3c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a3f:	0f b6 1a             	movzbl (%edx),%ebx
  800a42:	84 db                	test   %bl,%bl
  800a44:	74 0e                	je     800a54 <strncmp+0x3c>
  800a46:	3a 19                	cmp    (%ecx),%bl
  800a48:	74 ea                	je     800a34 <strncmp+0x1c>
  800a4a:	eb 08                	jmp    800a54 <strncmp+0x3c>
  800a4c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a51:	5b                   	pop    %ebx
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a54:	0f b6 02             	movzbl (%edx),%eax
  800a57:	0f b6 11             	movzbl (%ecx),%edx
  800a5a:	29 d0                	sub    %edx,%eax
  800a5c:	eb f3                	jmp    800a51 <strncmp+0x39>

00800a5e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a5e:	55                   	push   %ebp
  800a5f:	89 e5                	mov    %esp,%ebp
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a68:	0f b6 10             	movzbl (%eax),%edx
  800a6b:	84 d2                	test   %dl,%dl
  800a6d:	74 15                	je     800a84 <strchr+0x26>
		if (*s == c)
  800a6f:	38 ca                	cmp    %cl,%dl
  800a71:	75 07                	jne    800a7a <strchr+0x1c>
  800a73:	eb 14                	jmp    800a89 <strchr+0x2b>
  800a75:	38 ca                	cmp    %cl,%dl
  800a77:	90                   	nop
  800a78:	74 0f                	je     800a89 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a7a:	83 c0 01             	add    $0x1,%eax
  800a7d:	0f b6 10             	movzbl (%eax),%edx
  800a80:	84 d2                	test   %dl,%dl
  800a82:	75 f1                	jne    800a75 <strchr+0x17>
  800a84:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800a89:	5d                   	pop    %ebp
  800a8a:	c3                   	ret    

00800a8b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a8b:	55                   	push   %ebp
  800a8c:	89 e5                	mov    %esp,%ebp
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a95:	0f b6 10             	movzbl (%eax),%edx
  800a98:	84 d2                	test   %dl,%dl
  800a9a:	74 18                	je     800ab4 <strfind+0x29>
		if (*s == c)
  800a9c:	38 ca                	cmp    %cl,%dl
  800a9e:	75 0a                	jne    800aaa <strfind+0x1f>
  800aa0:	eb 12                	jmp    800ab4 <strfind+0x29>
  800aa2:	38 ca                	cmp    %cl,%dl
  800aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800aa8:	74 0a                	je     800ab4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800aaa:	83 c0 01             	add    $0x1,%eax
  800aad:	0f b6 10             	movzbl (%eax),%edx
  800ab0:	84 d2                	test   %dl,%dl
  800ab2:	75 ee                	jne    800aa2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800ab4:	5d                   	pop    %ebp
  800ab5:	c3                   	ret    

00800ab6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ab6:	55                   	push   %ebp
  800ab7:	89 e5                	mov    %esp,%ebp
  800ab9:	83 ec 0c             	sub    $0xc,%esp
  800abc:	89 1c 24             	mov    %ebx,(%esp)
  800abf:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ac3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800ac7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800aca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800acd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ad0:	85 c9                	test   %ecx,%ecx
  800ad2:	74 30                	je     800b04 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ad4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ada:	75 25                	jne    800b01 <memset+0x4b>
  800adc:	f6 c1 03             	test   $0x3,%cl
  800adf:	75 20                	jne    800b01 <memset+0x4b>
		c &= 0xFF;
  800ae1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ae4:	89 d3                	mov    %edx,%ebx
  800ae6:	c1 e3 08             	shl    $0x8,%ebx
  800ae9:	89 d6                	mov    %edx,%esi
  800aeb:	c1 e6 18             	shl    $0x18,%esi
  800aee:	89 d0                	mov    %edx,%eax
  800af0:	c1 e0 10             	shl    $0x10,%eax
  800af3:	09 f0                	or     %esi,%eax
  800af5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800af7:	09 d8                	or     %ebx,%eax
  800af9:	c1 e9 02             	shr    $0x2,%ecx
  800afc:	fc                   	cld    
  800afd:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800aff:	eb 03                	jmp    800b04 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b01:	fc                   	cld    
  800b02:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b04:	89 f8                	mov    %edi,%eax
  800b06:	8b 1c 24             	mov    (%esp),%ebx
  800b09:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b0d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b11:	89 ec                	mov    %ebp,%esp
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    

00800b15 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	83 ec 08             	sub    $0x8,%esp
  800b1b:	89 34 24             	mov    %esi,(%esp)
  800b1e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800b28:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800b2b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800b2d:	39 c6                	cmp    %eax,%esi
  800b2f:	73 35                	jae    800b66 <memmove+0x51>
  800b31:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b34:	39 d0                	cmp    %edx,%eax
  800b36:	73 2e                	jae    800b66 <memmove+0x51>
		s += n;
		d += n;
  800b38:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b3a:	f6 c2 03             	test   $0x3,%dl
  800b3d:	75 1b                	jne    800b5a <memmove+0x45>
  800b3f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b45:	75 13                	jne    800b5a <memmove+0x45>
  800b47:	f6 c1 03             	test   $0x3,%cl
  800b4a:	75 0e                	jne    800b5a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800b4c:	83 ef 04             	sub    $0x4,%edi
  800b4f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b52:	c1 e9 02             	shr    $0x2,%ecx
  800b55:	fd                   	std    
  800b56:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b58:	eb 09                	jmp    800b63 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b5a:	83 ef 01             	sub    $0x1,%edi
  800b5d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b60:	fd                   	std    
  800b61:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b63:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b64:	eb 20                	jmp    800b86 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b66:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b6c:	75 15                	jne    800b83 <memmove+0x6e>
  800b6e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b74:	75 0d                	jne    800b83 <memmove+0x6e>
  800b76:	f6 c1 03             	test   $0x3,%cl
  800b79:	75 08                	jne    800b83 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800b7b:	c1 e9 02             	shr    $0x2,%ecx
  800b7e:	fc                   	cld    
  800b7f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b81:	eb 03                	jmp    800b86 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b83:	fc                   	cld    
  800b84:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b86:	8b 34 24             	mov    (%esp),%esi
  800b89:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b8d:	89 ec                	mov    %ebp,%esp
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    

00800b91 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800b97:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba8:	89 04 24             	mov    %eax,(%esp)
  800bab:	e8 65 ff ff ff       	call   800b15 <memmove>
}
  800bb0:	c9                   	leave  
  800bb1:	c3                   	ret    

00800bb2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	57                   	push   %edi
  800bb6:	56                   	push   %esi
  800bb7:	53                   	push   %ebx
  800bb8:	8b 75 08             	mov    0x8(%ebp),%esi
  800bbb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800bbe:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bc1:	85 c9                	test   %ecx,%ecx
  800bc3:	74 36                	je     800bfb <memcmp+0x49>
		if (*s1 != *s2)
  800bc5:	0f b6 06             	movzbl (%esi),%eax
  800bc8:	0f b6 1f             	movzbl (%edi),%ebx
  800bcb:	38 d8                	cmp    %bl,%al
  800bcd:	74 20                	je     800bef <memcmp+0x3d>
  800bcf:	eb 14                	jmp    800be5 <memcmp+0x33>
  800bd1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800bd6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800bdb:	83 c2 01             	add    $0x1,%edx
  800bde:	83 e9 01             	sub    $0x1,%ecx
  800be1:	38 d8                	cmp    %bl,%al
  800be3:	74 12                	je     800bf7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800be5:	0f b6 c0             	movzbl %al,%eax
  800be8:	0f b6 db             	movzbl %bl,%ebx
  800beb:	29 d8                	sub    %ebx,%eax
  800bed:	eb 11                	jmp    800c00 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bef:	83 e9 01             	sub    $0x1,%ecx
  800bf2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf7:	85 c9                	test   %ecx,%ecx
  800bf9:	75 d6                	jne    800bd1 <memcmp+0x1f>
  800bfb:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800c00:	5b                   	pop    %ebx
  800c01:	5e                   	pop    %esi
  800c02:	5f                   	pop    %edi
  800c03:	5d                   	pop    %ebp
  800c04:	c3                   	ret    

00800c05 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c05:	55                   	push   %ebp
  800c06:	89 e5                	mov    %esp,%ebp
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c0b:	89 c2                	mov    %eax,%edx
  800c0d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c10:	39 d0                	cmp    %edx,%eax
  800c12:	73 15                	jae    800c29 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c14:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c18:	38 08                	cmp    %cl,(%eax)
  800c1a:	75 06                	jne    800c22 <memfind+0x1d>
  800c1c:	eb 0b                	jmp    800c29 <memfind+0x24>
  800c1e:	38 08                	cmp    %cl,(%eax)
  800c20:	74 07                	je     800c29 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c22:	83 c0 01             	add    $0x1,%eax
  800c25:	39 c2                	cmp    %eax,%edx
  800c27:	77 f5                	ja     800c1e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c29:	5d                   	pop    %ebp
  800c2a:	c3                   	ret    

00800c2b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	57                   	push   %edi
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
  800c31:	83 ec 04             	sub    $0x4,%esp
  800c34:	8b 55 08             	mov    0x8(%ebp),%edx
  800c37:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c3a:	0f b6 02             	movzbl (%edx),%eax
  800c3d:	3c 20                	cmp    $0x20,%al
  800c3f:	74 04                	je     800c45 <strtol+0x1a>
  800c41:	3c 09                	cmp    $0x9,%al
  800c43:	75 0e                	jne    800c53 <strtol+0x28>
		s++;
  800c45:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c48:	0f b6 02             	movzbl (%edx),%eax
  800c4b:	3c 20                	cmp    $0x20,%al
  800c4d:	74 f6                	je     800c45 <strtol+0x1a>
  800c4f:	3c 09                	cmp    $0x9,%al
  800c51:	74 f2                	je     800c45 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c53:	3c 2b                	cmp    $0x2b,%al
  800c55:	75 0c                	jne    800c63 <strtol+0x38>
		s++;
  800c57:	83 c2 01             	add    $0x1,%edx
  800c5a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c61:	eb 15                	jmp    800c78 <strtol+0x4d>
	else if (*s == '-')
  800c63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c6a:	3c 2d                	cmp    $0x2d,%al
  800c6c:	75 0a                	jne    800c78 <strtol+0x4d>
		s++, neg = 1;
  800c6e:	83 c2 01             	add    $0x1,%edx
  800c71:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c78:	85 db                	test   %ebx,%ebx
  800c7a:	0f 94 c0             	sete   %al
  800c7d:	74 05                	je     800c84 <strtol+0x59>
  800c7f:	83 fb 10             	cmp    $0x10,%ebx
  800c82:	75 18                	jne    800c9c <strtol+0x71>
  800c84:	80 3a 30             	cmpb   $0x30,(%edx)
  800c87:	75 13                	jne    800c9c <strtol+0x71>
  800c89:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c8d:	8d 76 00             	lea    0x0(%esi),%esi
  800c90:	75 0a                	jne    800c9c <strtol+0x71>
		s += 2, base = 16;
  800c92:	83 c2 02             	add    $0x2,%edx
  800c95:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c9a:	eb 15                	jmp    800cb1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800c9c:	84 c0                	test   %al,%al
  800c9e:	66 90                	xchg   %ax,%ax
  800ca0:	74 0f                	je     800cb1 <strtol+0x86>
  800ca2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800ca7:	80 3a 30             	cmpb   $0x30,(%edx)
  800caa:	75 05                	jne    800cb1 <strtol+0x86>
		s++, base = 8;
  800cac:	83 c2 01             	add    $0x1,%edx
  800caf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cb8:	0f b6 0a             	movzbl (%edx),%ecx
  800cbb:	89 cf                	mov    %ecx,%edi
  800cbd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800cc0:	80 fb 09             	cmp    $0x9,%bl
  800cc3:	77 08                	ja     800ccd <strtol+0xa2>
			dig = *s - '0';
  800cc5:	0f be c9             	movsbl %cl,%ecx
  800cc8:	83 e9 30             	sub    $0x30,%ecx
  800ccb:	eb 1e                	jmp    800ceb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800ccd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800cd0:	80 fb 19             	cmp    $0x19,%bl
  800cd3:	77 08                	ja     800cdd <strtol+0xb2>
			dig = *s - 'a' + 10;
  800cd5:	0f be c9             	movsbl %cl,%ecx
  800cd8:	83 e9 57             	sub    $0x57,%ecx
  800cdb:	eb 0e                	jmp    800ceb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800cdd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800ce0:	80 fb 19             	cmp    $0x19,%bl
  800ce3:	77 15                	ja     800cfa <strtol+0xcf>
			dig = *s - 'A' + 10;
  800ce5:	0f be c9             	movsbl %cl,%ecx
  800ce8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ceb:	39 f1                	cmp    %esi,%ecx
  800ced:	7d 0b                	jge    800cfa <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800cef:	83 c2 01             	add    $0x1,%edx
  800cf2:	0f af c6             	imul   %esi,%eax
  800cf5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800cf8:	eb be                	jmp    800cb8 <strtol+0x8d>
  800cfa:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800cfc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d00:	74 05                	je     800d07 <strtol+0xdc>
		*endptr = (char *) s;
  800d02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d05:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d0b:	74 04                	je     800d11 <strtol+0xe6>
  800d0d:	89 c8                	mov    %ecx,%eax
  800d0f:	f7 d8                	neg    %eax
}
  800d11:	83 c4 04             	add    $0x4,%esp
  800d14:	5b                   	pop    %ebx
  800d15:	5e                   	pop    %esi
  800d16:	5f                   	pop    %edi
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    
  800d19:	00 00                	add    %al,(%eax)
	...

00800d1c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800d1c:	55                   	push   %ebp
  800d1d:	89 e5                	mov    %esp,%ebp
  800d1f:	83 ec 0c             	sub    $0xc,%esp
  800d22:	89 1c 24             	mov    %ebx,(%esp)
  800d25:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d29:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d32:	b8 01 00 00 00       	mov    $0x1,%eax
  800d37:	89 d1                	mov    %edx,%ecx
  800d39:	89 d3                	mov    %edx,%ebx
  800d3b:	89 d7                	mov    %edx,%edi
  800d3d:	89 d6                	mov    %edx,%esi
  800d3f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d41:	8b 1c 24             	mov    (%esp),%ebx
  800d44:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d48:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d4c:	89 ec                	mov    %ebp,%esp
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 0c             	sub    $0xc,%esp
  800d56:	89 1c 24             	mov    %ebx,(%esp)
  800d59:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d5d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d61:	b8 00 00 00 00       	mov    $0x0,%eax
  800d66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	89 c3                	mov    %eax,%ebx
  800d6e:	89 c7                	mov    %eax,%edi
  800d70:	89 c6                	mov    %eax,%esi
  800d72:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d74:	8b 1c 24             	mov    (%esp),%ebx
  800d77:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d7b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d7f:	89 ec                	mov    %ebp,%esp
  800d81:	5d                   	pop    %ebp
  800d82:	c3                   	ret    

00800d83 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  800d83:	55                   	push   %ebp
  800d84:	89 e5                	mov    %esp,%ebp
  800d86:	83 ec 0c             	sub    $0xc,%esp
  800d89:	89 1c 24             	mov    %ebx,(%esp)
  800d8c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d90:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d94:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d99:	b8 10 00 00 00       	mov    $0x10,%eax
  800d9e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da1:	8b 55 08             	mov    0x8(%ebp),%edx
  800da4:	89 df                	mov    %ebx,%edi
  800da6:	89 de                	mov    %ebx,%esi
  800da8:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800daa:	8b 1c 24             	mov    (%esp),%ebx
  800dad:	8b 74 24 04          	mov    0x4(%esp),%esi
  800db1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800db5:	89 ec                	mov    %ebp,%esp
  800db7:	5d                   	pop    %ebp
  800db8:	c3                   	ret    

00800db9 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  800db9:	55                   	push   %ebp
  800dba:	89 e5                	mov    %esp,%ebp
  800dbc:	83 ec 38             	sub    $0x38,%esp
  800dbf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dc2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dc5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dcd:	b8 0f 00 00 00       	mov    $0xf,%eax
  800dd2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd8:	89 df                	mov    %ebx,%edi
  800dda:	89 de                	mov    %ebx,%esi
  800ddc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800dde:	85 c0                	test   %eax,%eax
  800de0:	7e 28                	jle    800e0a <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800de2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800de6:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800ded:	00 
  800dee:	c7 44 24 08 7f 30 80 	movl   $0x80307f,0x8(%esp)
  800df5:	00 
  800df6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800dfd:	00 
  800dfe:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  800e05:	e8 a6 f3 ff ff       	call   8001b0 <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800e0a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e0d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e10:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e13:	89 ec                	mov    %ebp,%esp
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
  800e1a:	83 ec 0c             	sub    $0xc,%esp
  800e1d:	89 1c 24             	mov    %ebx,(%esp)
  800e20:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e24:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e28:	ba 00 00 00 00       	mov    $0x0,%edx
  800e2d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e32:	89 d1                	mov    %edx,%ecx
  800e34:	89 d3                	mov    %edx,%ebx
  800e36:	89 d7                	mov    %edx,%edi
  800e38:	89 d6                	mov    %edx,%esi
  800e3a:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e3c:	8b 1c 24             	mov    (%esp),%ebx
  800e3f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e43:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e47:	89 ec                	mov    %ebp,%esp
  800e49:	5d                   	pop    %ebp
  800e4a:	c3                   	ret    

00800e4b <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800e4b:	55                   	push   %ebp
  800e4c:	89 e5                	mov    %esp,%ebp
  800e4e:	83 ec 38             	sub    $0x38,%esp
  800e51:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e54:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e57:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e5a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e5f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e64:	8b 55 08             	mov    0x8(%ebp),%edx
  800e67:	89 cb                	mov    %ecx,%ebx
  800e69:	89 cf                	mov    %ecx,%edi
  800e6b:	89 ce                	mov    %ecx,%esi
  800e6d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	7e 28                	jle    800e9b <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e73:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e77:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e7e:	00 
  800e7f:	c7 44 24 08 7f 30 80 	movl   $0x80307f,0x8(%esp)
  800e86:	00 
  800e87:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e8e:	00 
  800e8f:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  800e96:	e8 15 f3 ff ff       	call   8001b0 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e9b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e9e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ea1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ea4:	89 ec                	mov    %ebp,%esp
  800ea6:	5d                   	pop    %ebp
  800ea7:	c3                   	ret    

00800ea8 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
  800eab:	83 ec 0c             	sub    $0xc,%esp
  800eae:	89 1c 24             	mov    %ebx,(%esp)
  800eb1:	89 74 24 04          	mov    %esi,0x4(%esp)
  800eb5:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eb9:	be 00 00 00 00       	mov    $0x0,%esi
  800ebe:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ec3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ec6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ec9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ecc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ecf:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ed1:	8b 1c 24             	mov    (%esp),%ebx
  800ed4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ed8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800edc:	89 ec                	mov    %ebp,%esp
  800ede:	5d                   	pop    %ebp
  800edf:	c3                   	ret    

00800ee0 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 38             	sub    $0x38,%esp
  800ee6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ee9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800eec:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eef:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ef4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ef9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efc:	8b 55 08             	mov    0x8(%ebp),%edx
  800eff:	89 df                	mov    %ebx,%edi
  800f01:	89 de                	mov    %ebx,%esi
  800f03:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	7e 28                	jle    800f31 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f09:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f0d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f14:	00 
  800f15:	c7 44 24 08 7f 30 80 	movl   $0x80307f,0x8(%esp)
  800f1c:	00 
  800f1d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f24:	00 
  800f25:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  800f2c:	e8 7f f2 ff ff       	call   8001b0 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f31:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f34:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f37:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f3a:	89 ec                	mov    %ebp,%esp
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    

00800f3e <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 38             	sub    $0x38,%esp
  800f44:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f47:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f4a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f52:	b8 09 00 00 00       	mov    $0x9,%eax
  800f57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5d:	89 df                	mov    %ebx,%edi
  800f5f:	89 de                	mov    %ebx,%esi
  800f61:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f63:	85 c0                	test   %eax,%eax
  800f65:	7e 28                	jle    800f8f <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f67:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f6b:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f72:	00 
  800f73:	c7 44 24 08 7f 30 80 	movl   $0x80307f,0x8(%esp)
  800f7a:	00 
  800f7b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f82:	00 
  800f83:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  800f8a:	e8 21 f2 ff ff       	call   8001b0 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f8f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f92:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f95:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f98:	89 ec                	mov    %ebp,%esp
  800f9a:	5d                   	pop    %ebp
  800f9b:	c3                   	ret    

00800f9c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 38             	sub    $0x38,%esp
  800fa2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fa5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fa8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fab:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fb0:	b8 08 00 00 00       	mov    $0x8,%eax
  800fb5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbb:	89 df                	mov    %ebx,%edi
  800fbd:	89 de                	mov    %ebx,%esi
  800fbf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fc1:	85 c0                	test   %eax,%eax
  800fc3:	7e 28                	jle    800fed <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fc9:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800fd0:	00 
  800fd1:	c7 44 24 08 7f 30 80 	movl   $0x80307f,0x8(%esp)
  800fd8:	00 
  800fd9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fe0:	00 
  800fe1:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  800fe8:	e8 c3 f1 ff ff       	call   8001b0 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fed:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ff0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ff3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ff6:	89 ec                	mov    %ebp,%esp
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    

00800ffa <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 38             	sub    $0x38,%esp
  801000:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801003:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801006:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801009:	bb 00 00 00 00       	mov    $0x0,%ebx
  80100e:	b8 06 00 00 00       	mov    $0x6,%eax
  801013:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801016:	8b 55 08             	mov    0x8(%ebp),%edx
  801019:	89 df                	mov    %ebx,%edi
  80101b:	89 de                	mov    %ebx,%esi
  80101d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80101f:	85 c0                	test   %eax,%eax
  801021:	7e 28                	jle    80104b <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801023:	89 44 24 10          	mov    %eax,0x10(%esp)
  801027:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80102e:	00 
  80102f:	c7 44 24 08 7f 30 80 	movl   $0x80307f,0x8(%esp)
  801036:	00 
  801037:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80103e:	00 
  80103f:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  801046:	e8 65 f1 ff ff       	call   8001b0 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80104b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80104e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801051:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801054:	89 ec                	mov    %ebp,%esp
  801056:	5d                   	pop    %ebp
  801057:	c3                   	ret    

00801058 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	83 ec 38             	sub    $0x38,%esp
  80105e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801061:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801064:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801067:	b8 05 00 00 00       	mov    $0x5,%eax
  80106c:	8b 75 18             	mov    0x18(%ebp),%esi
  80106f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801072:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801075:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801078:	8b 55 08             	mov    0x8(%ebp),%edx
  80107b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80107d:	85 c0                	test   %eax,%eax
  80107f:	7e 28                	jle    8010a9 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801081:	89 44 24 10          	mov    %eax,0x10(%esp)
  801085:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80108c:	00 
  80108d:	c7 44 24 08 7f 30 80 	movl   $0x80307f,0x8(%esp)
  801094:	00 
  801095:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80109c:	00 
  80109d:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  8010a4:	e8 07 f1 ff ff       	call   8001b0 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010a9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010ac:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010af:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010b2:	89 ec                	mov    %ebp,%esp
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    

008010b6 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 38             	sub    $0x38,%esp
  8010bc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010bf:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010c2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010c5:	be 00 00 00 00       	mov    $0x0,%esi
  8010ca:	b8 04 00 00 00       	mov    $0x4,%eax
  8010cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d8:	89 f7                	mov    %esi,%edi
  8010da:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	7e 28                	jle    801108 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010e4:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8010eb:	00 
  8010ec:	c7 44 24 08 7f 30 80 	movl   $0x80307f,0x8(%esp)
  8010f3:	00 
  8010f4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010fb:	00 
  8010fc:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  801103:	e8 a8 f0 ff ff       	call   8001b0 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801108:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80110b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80110e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801111:	89 ec                	mov    %ebp,%esp
  801113:	5d                   	pop    %ebp
  801114:	c3                   	ret    

00801115 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  801115:	55                   	push   %ebp
  801116:	89 e5                	mov    %esp,%ebp
  801118:	83 ec 0c             	sub    $0xc,%esp
  80111b:	89 1c 24             	mov    %ebx,(%esp)
  80111e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801122:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801126:	ba 00 00 00 00       	mov    $0x0,%edx
  80112b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801130:	89 d1                	mov    %edx,%ecx
  801132:	89 d3                	mov    %edx,%ebx
  801134:	89 d7                	mov    %edx,%edi
  801136:	89 d6                	mov    %edx,%esi
  801138:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80113a:	8b 1c 24             	mov    (%esp),%ebx
  80113d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801141:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801145:	89 ec                	mov    %ebp,%esp
  801147:	5d                   	pop    %ebp
  801148:	c3                   	ret    

00801149 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	83 ec 0c             	sub    $0xc,%esp
  80114f:	89 1c 24             	mov    %ebx,(%esp)
  801152:	89 74 24 04          	mov    %esi,0x4(%esp)
  801156:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80115a:	ba 00 00 00 00       	mov    $0x0,%edx
  80115f:	b8 02 00 00 00       	mov    $0x2,%eax
  801164:	89 d1                	mov    %edx,%ecx
  801166:	89 d3                	mov    %edx,%ebx
  801168:	89 d7                	mov    %edx,%edi
  80116a:	89 d6                	mov    %edx,%esi
  80116c:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80116e:	8b 1c 24             	mov    (%esp),%ebx
  801171:	8b 74 24 04          	mov    0x4(%esp),%esi
  801175:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801179:	89 ec                	mov    %ebp,%esp
  80117b:	5d                   	pop    %ebp
  80117c:	c3                   	ret    

0080117d <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	83 ec 38             	sub    $0x38,%esp
  801183:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801186:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801189:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80118c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801191:	b8 03 00 00 00       	mov    $0x3,%eax
  801196:	8b 55 08             	mov    0x8(%ebp),%edx
  801199:	89 cb                	mov    %ecx,%ebx
  80119b:	89 cf                	mov    %ecx,%edi
  80119d:	89 ce                	mov    %ecx,%esi
  80119f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011a1:	85 c0                	test   %eax,%eax
  8011a3:	7e 28                	jle    8011cd <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011a9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8011b0:	00 
  8011b1:	c7 44 24 08 7f 30 80 	movl   $0x80307f,0x8(%esp)
  8011b8:	00 
  8011b9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011c0:	00 
  8011c1:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  8011c8:	e8 e3 ef ff ff       	call   8001b0 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011cd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011d0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011d3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011d6:	89 ec                	mov    %ebp,%esp
  8011d8:	5d                   	pop    %ebp
  8011d9:	c3                   	ret    
	...

008011dc <sfork>:
}

// Challenge!
int
sfork(void)
{
  8011dc:	55                   	push   %ebp
  8011dd:	89 e5                	mov    %esp,%ebp
  8011df:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8011e2:	c7 44 24 08 aa 30 80 	movl   $0x8030aa,0x8(%esp)
  8011e9:	00 
  8011ea:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  8011f1:	00 
  8011f2:	c7 04 24 c0 30 80 00 	movl   $0x8030c0,(%esp)
  8011f9:	e8 b2 ef ff ff       	call   8001b0 <_panic>

008011fe <duppage>:
// It is also OK to panic on error.
// 

static int
duppage(envid_t envid, unsigned pn)
{
  8011fe:	55                   	push   %ebp
  8011ff:	89 e5                	mov    %esp,%ebp
  801201:	83 ec 28             	sub    $0x28,%esp
  801204:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801207:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80120a:	89 c3                	mov    %eax,%ebx
	int r;

	// LAB 4: Your code here.
     pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  80120c:	89 d6                	mov    %edx,%esi
  80120e:	c1 e6 0c             	shl    $0xc,%esi
  801211:	89 f0                	mov    %esi,%eax
  801213:	c1 e8 16             	shr    $0x16,%eax
  801216:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
       
        if( 0 == pgDirEntry )
  80121d:	85 c0                	test   %eax,%eax
  80121f:	0f 84 fc 00 00 00    	je     801321 <duppage+0x123>
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  801225:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80122c:	89 c2                	mov    %eax,%edx
  80122e:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        //cprintf("Below %d",vpt[pn]);
                //if(perm!=0)  //commented nw.
                   // cprintf("perm bit %d",perm);
	
	
	if((perm & PTE_W) && (perm & PTE_SHARE))
  801234:	25 02 04 00 00       	and    $0x402,%eax
  801239:	3d 02 04 00 00       	cmp    $0x402,%eax
  80123e:	75 4d                	jne    80128d <duppage+0x8f>
	{	
		if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_SHARE|(perm & PTE_USER))) < 0)
  801240:	81 e2 07 0a 00 00    	and    $0xa07,%edx
  801246:	80 ce 04             	or     $0x4,%dh
  801249:	89 54 24 10          	mov    %edx,0x10(%esp)
  80124d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801251:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801255:	89 74 24 04          	mov    %esi,0x4(%esp)
  801259:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801260:	e8 f3 fd ff ff       	call   801058 <sys_page_map>
  801265:	85 c0                	test   %eax,%eax
  801267:	0f 89 bb 00 00 00    	jns    801328 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  80126d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801271:	c7 44 24 08 cb 30 80 	movl   $0x8030cb,0x8(%esp)
  801278:	00 
  801279:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  801280:	00 
  801281:	c7 04 24 c0 30 80 00 	movl   $0x8030c0,(%esp)
  801288:	e8 23 ef ff ff       	call   8001b0 <_panic>
	}	


        else if((perm & PTE_W)!=0 || (perm & PTE_COW)!=0)
  80128d:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801293:	0f 84 8f 00 00 00    	je     801328 <duppage+0x12a>
         {
          //cprintf("\nInside Setting Cow\n"); 
        if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  801299:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012a0:	00 
  8012a1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012a5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012b4:	e8 9f fd ff ff       	call   801058 <sys_page_map>
  8012b9:	85 c0                	test   %eax,%eax
  8012bb:	79 20                	jns    8012dd <duppage+0xdf>
                panic("sys_page_map: %e", r);
  8012bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012c1:	c7 44 24 08 cb 30 80 	movl   $0x8030cb,0x8(%esp)
  8012c8:	00 
  8012c9:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8012d0:	00 
  8012d1:	c7 04 24 c0 30 80 00 	movl   $0x8030c0,(%esp)
  8012d8:	e8 d3 ee ff ff       	call   8001b0 <_panic>
        if ((r = sys_page_map(envid,(void *)(pn*PGSIZE),0,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  8012dd:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8012e4:	00 
  8012e5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012e9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8012f0:	00 
  8012f1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012f5:	89 1c 24             	mov    %ebx,(%esp)
  8012f8:	e8 5b fd ff ff       	call   801058 <sys_page_map>
  8012fd:	85 c0                	test   %eax,%eax
  8012ff:	79 27                	jns    801328 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  801301:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801305:	c7 44 24 08 cb 30 80 	movl   $0x8030cb,0x8(%esp)
  80130c:	00 
  80130d:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801314:	00 
  801315:	c7 04 24 c0 30 80 00 	movl   $0x8030c0,(%esp)
  80131c:	e8 8f ee ff ff       	call   8001b0 <_panic>
  801321:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801326:	eb 05                	jmp    80132d <duppage+0x12f>
  801328:	b8 00 00 00 00       	mov    $0x0,%eax
         }


//	panic("duppage not implemented");
	return 0;
}
  80132d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801330:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801333:	89 ec                	mov    %ebp,%esp
  801335:	5d                   	pop    %ebp
  801336:	c3                   	ret    

00801337 <fork>:
//


envid_t
fork(void)
{
  801337:	55                   	push   %ebp
  801338:	89 e5                	mov    %esp,%ebp
  80133a:	56                   	push   %esi
  80133b:	53                   	push   %ebx
  80133c:	83 ec 10             	sub    $0x10,%esp

        envid_t envid;
        uint8_t *addr;
        int r;
        extern unsigned char end[];
        set_pgfault_handler(pgfault);
  80133f:	c7 04 24 4e 14 80 00 	movl   $0x80144e,(%esp)
  801346:	e8 91 16 00 00       	call   8029dc <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80134b:	be 07 00 00 00       	mov    $0x7,%esi
  801350:	89 f0                	mov    %esi,%eax
  801352:	cd 30                	int    $0x30
  801354:	89 c6                	mov    %eax,%esi

        envid = sys_exofork();
        if (envid < 0)
  801356:	85 c0                	test   %eax,%eax
  801358:	79 20                	jns    80137a <fork+0x43>
                panic("sys_exofork: %e", envid);
  80135a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80135e:	c7 44 24 08 dc 30 80 	movl   $0x8030dc,0x8(%esp)
  801365:	00 
  801366:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  80136d:	00 
  80136e:	c7 04 24 c0 30 80 00 	movl   $0x8030c0,(%esp)
  801375:	e8 36 ee ff ff       	call   8001b0 <_panic>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
  80137a:	bb 00 00 80 00       	mov    $0x800000,%ebx
        set_pgfault_handler(pgfault);

        envid = sys_exofork();
        if (envid < 0)
                panic("sys_exofork: %e", envid);
        if (envid == 0) {
  80137f:	85 c0                	test   %eax,%eax
  801381:	75 1c                	jne    80139f <fork+0x68>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
  801383:	e8 c1 fd ff ff       	call   801149 <sys_getenvid>
  801388:	25 ff 03 00 00       	and    $0x3ff,%eax
  80138d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801390:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801395:	a3 74 70 80 00       	mov    %eax,0x807074
                return 0;
  80139a:	e9 a6 00 00 00       	jmp    801445 <fork+0x10e>
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
  80139f:	89 da                	mov    %ebx,%edx
  8013a1:	c1 ea 0c             	shr    $0xc,%edx
  8013a4:	89 f0                	mov    %esi,%eax
  8013a6:	e8 53 fe ff ff       	call   8011fe <duppage>
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
  8013ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013b1:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8013b7:	75 e6                	jne    80139f <fork+0x68>
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
                }
              duppage(envid,VPN(USTACKTOP-PGSIZE));
  8013b9:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  8013be:	89 f0                	mov    %esi,%eax
  8013c0:	e8 39 fe ff ff       	call   8011fe <duppage>
        // Also copy the stack we are currently running on.
       //if(sys_page_alloc(envid, (void *)(ROUNDDOWN(&addr, PGSIZE)),PTE_U|PTE_P|PTE_W)<0)
         //                      panic("stack not allocated");
     
   
     sys_env_set_pgfault_upcall(envid,env->env_pgfault_upcall);
  8013c5:	a1 74 70 80 00       	mov    0x807074,%eax
  8013ca:	8b 40 64             	mov    0x64(%eax),%eax
  8013cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d1:	89 34 24             	mov    %esi,(%esp)
  8013d4:	e8 07 fb ff ff       	call   800ee0 <sys_env_set_pgfault_upcall>

     if(sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  8013d9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8013e0:	00 
  8013e1:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8013e8:	ee 
  8013e9:	89 34 24             	mov    %esi,(%esp)
  8013ec:	e8 c5 fc ff ff       	call   8010b6 <sys_page_alloc>
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	79 1c                	jns    801411 <fork+0xda>
                          panic("Cant allocate Page");
  8013f5:	c7 44 24 08 ec 30 80 	movl   $0x8030ec,0x8(%esp)
  8013fc:	00 
  8013fd:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  801404:	00 
  801405:	c7 04 24 c0 30 80 00 	movl   $0x8030c0,(%esp)
  80140c:	e8 9f ed ff ff       	call   8001b0 <_panic>

        // Start the child environment running
        if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801411:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801418:	00 
  801419:	89 34 24             	mov    %esi,(%esp)
  80141c:	e8 7b fb ff ff       	call   800f9c <sys_env_set_status>
  801421:	85 c0                	test   %eax,%eax
  801423:	79 20                	jns    801445 <fork+0x10e>
                panic("sys_env_set_status: %e", r);
  801425:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801429:	c7 44 24 08 ff 30 80 	movl   $0x8030ff,0x8(%esp)
  801430:	00 
  801431:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  801438:	00 
  801439:	c7 04 24 c0 30 80 00 	movl   $0x8030c0,(%esp)
  801440:	e8 6b ed ff ff       	call   8001b0 <_panic>
         return envid;
           
//panic("fork not implemented");
}
  801445:	89 f0                	mov    %esi,%eax
  801447:	83 c4 10             	add    $0x10,%esp
  80144a:	5b                   	pop    %ebx
  80144b:	5e                   	pop    %esi
  80144c:	5d                   	pop    %ebp
  80144d:	c3                   	ret    

0080144e <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  80144e:	55                   	push   %ebp
  80144f:	89 e5                	mov    %esp,%ebp
  801451:	53                   	push   %ebx
  801452:	83 ec 24             	sub    $0x24,%esp
  801455:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801458:	8b 18                	mov    (%eax),%ebx
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).
 
         int perm = vpt[VPN(addr)] & 0xFFF;
  80145a:	89 da                	mov    %ebx,%edx
  80145c:	c1 ea 0c             	shr    $0xc,%edx
  80145f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx

static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
  801466:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80146a:	74 21                	je     80148d <pgfault+0x3f>
 
         int perm = vpt[VPN(addr)] & 0xFFF;
        if((err & FEC_WR)!=0)
           {
//              cprintf("\n>>>>>Due to write\n");
            if((perm & PTE_COW) == 0)
  80146c:	f6 c6 08             	test   $0x8,%dh
  80146f:	75 1c                	jne    80148d <pgfault+0x3f>
             {
                   panic("Not Set Cow");
  801471:	c7 44 24 08 16 31 80 	movl   $0x803116,0x8(%esp)
  801478:	00 
  801479:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801480:	00 
  801481:	c7 04 24 c0 30 80 00 	movl   $0x8030c0,(%esp)
  801488:	e8 23 ed ff ff       	call   8001b0 <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
        if(sys_page_alloc(0,PFTEMP,PTE_P|PTE_U|PTE_W)<0)
  80148d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801494:	00 
  801495:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80149c:	00 
  80149d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8014a4:	e8 0d fc ff ff       	call   8010b6 <sys_page_alloc>
  8014a9:	85 c0                	test   %eax,%eax
  8014ab:	79 1c                	jns    8014c9 <pgfault+0x7b>
              panic("\nPage not allocated\n");
  8014ad:	c7 44 24 08 22 31 80 	movl   $0x803122,0x8(%esp)
  8014b4:	00 
  8014b5:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  8014bc:	00 
  8014bd:	c7 04 24 c0 30 80 00 	movl   $0x8030c0,(%esp)
  8014c4:	e8 e7 ec ff ff       	call   8001b0 <_panic>
           memmove(PFTEMP,ROUNDDOWN(addr,PGSIZE),PGSIZE);
  8014c9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  8014cf:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8014d6:	00 
  8014d7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8014db:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8014e2:	e8 2e f6 ff ff       	call   800b15 <memmove>
          if(sys_page_map(0,ROUNDDOWN(PFTEMP,PGSIZE),0,ROUNDDOWN(addr,PGSIZE),PTE_U|PTE_P|PTE_W)<0)
  8014e7:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8014ee:	00 
  8014ef:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8014f3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014fa:	00 
  8014fb:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801502:	00 
  801503:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80150a:	e8 49 fb ff ff       	call   801058 <sys_page_map>
  80150f:	85 c0                	test   %eax,%eax
  801511:	79 1c                	jns    80152f <pgfault+0xe1>
                   panic("not mapped properly");
  801513:	c7 44 24 08 37 31 80 	movl   $0x803137,0x8(%esp)
  80151a:	00 
  80151b:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801522:	00 
  801523:	c7 04 24 c0 30 80 00 	movl   $0x8030c0,(%esp)
  80152a:	e8 81 ec ff ff       	call   8001b0 <_panic>
         if( 0 > sys_page_unmap(0, PFTEMP) )
  80152f:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801536:	00 
  801537:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80153e:	e8 b7 fa ff ff       	call   800ffa <sys_page_unmap>
  801543:	85 c0                	test   %eax,%eax
  801545:	79 1c                	jns    801563 <pgfault+0x115>
                panic("sys_page_unmap failed\n");
  801547:	c7 44 24 08 4b 31 80 	movl   $0x80314b,0x8(%esp)
  80154e:	00 
  80154f:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  801556:	00 
  801557:	c7 04 24 c0 30 80 00 	movl   $0x8030c0,(%esp)
  80155e:	e8 4d ec ff ff       	call   8001b0 <_panic>
   
//	panic("pgfault not implemented");
}
  801563:	83 c4 24             	add    $0x24,%esp
  801566:	5b                   	pop    %ebx
  801567:	5d                   	pop    %ebp
  801568:	c3                   	ret    
  801569:	00 00                	add    %al,(%eax)
  80156b:	00 00                	add    %al,(%eax)
  80156d:	00 00                	add    %al,(%eax)
	...

00801570 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
  801573:	57                   	push   %edi
  801574:	56                   	push   %esi
  801575:	53                   	push   %ebx
  801576:	83 ec 1c             	sub    $0x1c,%esp
  801579:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80157c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80157f:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  801582:	8b 45 14             	mov    0x14(%ebp),%eax
  801585:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801589:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80158d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801591:	89 1c 24             	mov    %ebx,(%esp)
  801594:	e8 0f f9 ff ff       	call   800ea8 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  801599:	85 c0                	test   %eax,%eax
  80159b:	79 21                	jns    8015be <ipc_send+0x4e>
  80159d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8015a0:	74 1c                	je     8015be <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  8015a2:	c7 44 24 08 62 31 80 	movl   $0x803162,0x8(%esp)
  8015a9:	00 
  8015aa:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  8015b1:	00 
  8015b2:	c7 04 24 74 31 80 00 	movl   $0x803174,(%esp)
  8015b9:	e8 f2 eb ff ff       	call   8001b0 <_panic>
          else if(r==-E_IPC_NOT_RECV)
  8015be:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8015c1:	75 07                	jne    8015ca <ipc_send+0x5a>
           sys_yield();
  8015c3:	e8 4d fb ff ff       	call   801115 <sys_yield>
          else
            break;
        }
  8015c8:	eb b8                	jmp    801582 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  8015ca:	83 c4 1c             	add    $0x1c,%esp
  8015cd:	5b                   	pop    %ebx
  8015ce:	5e                   	pop    %esi
  8015cf:	5f                   	pop    %edi
  8015d0:	5d                   	pop    %ebp
  8015d1:	c3                   	ret    

008015d2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8015d2:	55                   	push   %ebp
  8015d3:	89 e5                	mov    %esp,%ebp
  8015d5:	83 ec 18             	sub    $0x18,%esp
  8015d8:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8015db:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8015de:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8015e1:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  8015e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e7:	89 04 24             	mov    %eax,(%esp)
  8015ea:	e8 5c f8 ff ff       	call   800e4b <sys_ipc_recv>
        if(r<0)
  8015ef:	85 c0                	test   %eax,%eax
  8015f1:	79 17                	jns    80160a <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  8015f3:	85 db                	test   %ebx,%ebx
  8015f5:	74 06                	je     8015fd <ipc_recv+0x2b>
               *from_env_store =0;
  8015f7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  8015fd:	85 f6                	test   %esi,%esi
  8015ff:	90                   	nop
  801600:	74 2c                	je     80162e <ipc_recv+0x5c>
              *perm_store=0;
  801602:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  801608:	eb 24                	jmp    80162e <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  80160a:	85 db                	test   %ebx,%ebx
  80160c:	74 0a                	je     801618 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  80160e:	a1 74 70 80 00       	mov    0x807074,%eax
  801613:	8b 40 74             	mov    0x74(%eax),%eax
  801616:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  801618:	85 f6                	test   %esi,%esi
  80161a:	74 0a                	je     801626 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  80161c:	a1 74 70 80 00       	mov    0x807074,%eax
  801621:	8b 40 78             	mov    0x78(%eax),%eax
  801624:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  801626:	a1 74 70 80 00       	mov    0x807074,%eax
  80162b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80162e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801631:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801634:	89 ec                	mov    %ebp,%esp
  801636:	5d                   	pop    %ebp
  801637:	c3                   	ret    
	...

00801640 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	8b 45 08             	mov    0x8(%ebp),%eax
  801646:	05 00 00 00 30       	add    $0x30000000,%eax
  80164b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80164e:	5d                   	pop    %ebp
  80164f:	c3                   	ret    

00801650 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801656:	8b 45 08             	mov    0x8(%ebp),%eax
  801659:	89 04 24             	mov    %eax,(%esp)
  80165c:	e8 df ff ff ff       	call   801640 <fd2num>
  801661:	05 20 00 0d 00       	add    $0xd0020,%eax
  801666:	c1 e0 0c             	shl    $0xc,%eax
}
  801669:	c9                   	leave  
  80166a:	c3                   	ret    

0080166b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80166b:	55                   	push   %ebp
  80166c:	89 e5                	mov    %esp,%ebp
  80166e:	57                   	push   %edi
  80166f:	56                   	push   %esi
  801670:	53                   	push   %ebx
  801671:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801674:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801679:	a8 01                	test   $0x1,%al
  80167b:	74 36                	je     8016b3 <fd_alloc+0x48>
  80167d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801682:	a8 01                	test   $0x1,%al
  801684:	74 2d                	je     8016b3 <fd_alloc+0x48>
  801686:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80168b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801690:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801695:	89 c3                	mov    %eax,%ebx
  801697:	89 c2                	mov    %eax,%edx
  801699:	c1 ea 16             	shr    $0x16,%edx
  80169c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80169f:	f6 c2 01             	test   $0x1,%dl
  8016a2:	74 14                	je     8016b8 <fd_alloc+0x4d>
  8016a4:	89 c2                	mov    %eax,%edx
  8016a6:	c1 ea 0c             	shr    $0xc,%edx
  8016a9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  8016ac:	f6 c2 01             	test   $0x1,%dl
  8016af:	75 10                	jne    8016c1 <fd_alloc+0x56>
  8016b1:	eb 05                	jmp    8016b8 <fd_alloc+0x4d>
  8016b3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  8016b8:	89 1f                	mov    %ebx,(%edi)
  8016ba:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8016bf:	eb 17                	jmp    8016d8 <fd_alloc+0x6d>
  8016c1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8016c6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8016cb:	75 c8                	jne    801695 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8016cd:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8016d3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8016d8:	5b                   	pop    %ebx
  8016d9:	5e                   	pop    %esi
  8016da:	5f                   	pop    %edi
  8016db:	5d                   	pop    %ebp
  8016dc:	c3                   	ret    

008016dd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e3:	83 f8 1f             	cmp    $0x1f,%eax
  8016e6:	77 36                	ja     80171e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016e8:	05 00 00 0d 00       	add    $0xd0000,%eax
  8016ed:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8016f0:	89 c2                	mov    %eax,%edx
  8016f2:	c1 ea 16             	shr    $0x16,%edx
  8016f5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016fc:	f6 c2 01             	test   $0x1,%dl
  8016ff:	74 1d                	je     80171e <fd_lookup+0x41>
  801701:	89 c2                	mov    %eax,%edx
  801703:	c1 ea 0c             	shr    $0xc,%edx
  801706:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80170d:	f6 c2 01             	test   $0x1,%dl
  801710:	74 0c                	je     80171e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801712:	8b 55 0c             	mov    0xc(%ebp),%edx
  801715:	89 02                	mov    %eax,(%edx)
  801717:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80171c:	eb 05                	jmp    801723 <fd_lookup+0x46>
  80171e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801723:	5d                   	pop    %ebp
  801724:	c3                   	ret    

00801725 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80172b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80172e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801732:	8b 45 08             	mov    0x8(%ebp),%eax
  801735:	89 04 24             	mov    %eax,(%esp)
  801738:	e8 a0 ff ff ff       	call   8016dd <fd_lookup>
  80173d:	85 c0                	test   %eax,%eax
  80173f:	78 0e                	js     80174f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801741:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801744:	8b 55 0c             	mov    0xc(%ebp),%edx
  801747:	89 50 04             	mov    %edx,0x4(%eax)
  80174a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80174f:	c9                   	leave  
  801750:	c3                   	ret    

00801751 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801751:	55                   	push   %ebp
  801752:	89 e5                	mov    %esp,%ebp
  801754:	56                   	push   %esi
  801755:	53                   	push   %ebx
  801756:	83 ec 10             	sub    $0x10,%esp
  801759:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80175c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80175f:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801764:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801769:	be 00 32 80 00       	mov    $0x803200,%esi
		if (devtab[i]->dev_id == dev_id) {
  80176e:	39 08                	cmp    %ecx,(%eax)
  801770:	75 10                	jne    801782 <dev_lookup+0x31>
  801772:	eb 04                	jmp    801778 <dev_lookup+0x27>
  801774:	39 08                	cmp    %ecx,(%eax)
  801776:	75 0a                	jne    801782 <dev_lookup+0x31>
			*dev = devtab[i];
  801778:	89 03                	mov    %eax,(%ebx)
  80177a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80177f:	90                   	nop
  801780:	eb 31                	jmp    8017b3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801782:	83 c2 01             	add    $0x1,%edx
  801785:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801788:	85 c0                	test   %eax,%eax
  80178a:	75 e8                	jne    801774 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80178c:	a1 74 70 80 00       	mov    0x807074,%eax
  801791:	8b 40 4c             	mov    0x4c(%eax),%eax
  801794:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801798:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179c:	c7 04 24 80 31 80 00 	movl   $0x803180,(%esp)
  8017a3:	e8 cd ea ff ff       	call   800275 <cprintf>
	*dev = 0;
  8017a8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8017ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8017b3:	83 c4 10             	add    $0x10,%esp
  8017b6:	5b                   	pop    %ebx
  8017b7:	5e                   	pop    %esi
  8017b8:	5d                   	pop    %ebp
  8017b9:	c3                   	ret    

008017ba <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8017ba:	55                   	push   %ebp
  8017bb:	89 e5                	mov    %esp,%ebp
  8017bd:	53                   	push   %ebx
  8017be:	83 ec 24             	sub    $0x24,%esp
  8017c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	89 04 24             	mov    %eax,(%esp)
  8017d1:	e8 07 ff ff ff       	call   8016dd <fd_lookup>
  8017d6:	85 c0                	test   %eax,%eax
  8017d8:	78 53                	js     80182d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e4:	8b 00                	mov    (%eax),%eax
  8017e6:	89 04 24             	mov    %eax,(%esp)
  8017e9:	e8 63 ff ff ff       	call   801751 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017ee:	85 c0                	test   %eax,%eax
  8017f0:	78 3b                	js     80182d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8017f2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017fa:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8017fe:	74 2d                	je     80182d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801800:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801803:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80180a:	00 00 00 
	stat->st_isdir = 0;
  80180d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801814:	00 00 00 
	stat->st_dev = dev;
  801817:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80181a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801820:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801824:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801827:	89 14 24             	mov    %edx,(%esp)
  80182a:	ff 50 14             	call   *0x14(%eax)
}
  80182d:	83 c4 24             	add    $0x24,%esp
  801830:	5b                   	pop    %ebx
  801831:	5d                   	pop    %ebp
  801832:	c3                   	ret    

00801833 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	53                   	push   %ebx
  801837:	83 ec 24             	sub    $0x24,%esp
  80183a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80183d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801840:	89 44 24 04          	mov    %eax,0x4(%esp)
  801844:	89 1c 24             	mov    %ebx,(%esp)
  801847:	e8 91 fe ff ff       	call   8016dd <fd_lookup>
  80184c:	85 c0                	test   %eax,%eax
  80184e:	78 5f                	js     8018af <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801850:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801853:	89 44 24 04          	mov    %eax,0x4(%esp)
  801857:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80185a:	8b 00                	mov    (%eax),%eax
  80185c:	89 04 24             	mov    %eax,(%esp)
  80185f:	e8 ed fe ff ff       	call   801751 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801864:	85 c0                	test   %eax,%eax
  801866:	78 47                	js     8018af <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801868:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80186b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80186f:	75 23                	jne    801894 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801871:	a1 74 70 80 00       	mov    0x807074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801876:	8b 40 4c             	mov    0x4c(%eax),%eax
  801879:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80187d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801881:	c7 04 24 a0 31 80 00 	movl   $0x8031a0,(%esp)
  801888:	e8 e8 e9 ff ff       	call   800275 <cprintf>
  80188d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801892:	eb 1b                	jmp    8018af <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801897:	8b 48 18             	mov    0x18(%eax),%ecx
  80189a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80189f:	85 c9                	test   %ecx,%ecx
  8018a1:	74 0c                	je     8018af <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8018a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018aa:	89 14 24             	mov    %edx,(%esp)
  8018ad:	ff d1                	call   *%ecx
}
  8018af:	83 c4 24             	add    $0x24,%esp
  8018b2:	5b                   	pop    %ebx
  8018b3:	5d                   	pop    %ebp
  8018b4:	c3                   	ret    

008018b5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018b5:	55                   	push   %ebp
  8018b6:	89 e5                	mov    %esp,%ebp
  8018b8:	53                   	push   %ebx
  8018b9:	83 ec 24             	sub    $0x24,%esp
  8018bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c6:	89 1c 24             	mov    %ebx,(%esp)
  8018c9:	e8 0f fe ff ff       	call   8016dd <fd_lookup>
  8018ce:	85 c0                	test   %eax,%eax
  8018d0:	78 66                	js     801938 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018dc:	8b 00                	mov    (%eax),%eax
  8018de:	89 04 24             	mov    %eax,(%esp)
  8018e1:	e8 6b fe ff ff       	call   801751 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e6:	85 c0                	test   %eax,%eax
  8018e8:	78 4e                	js     801938 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018ed:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8018f1:	75 23                	jne    801916 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8018f3:	a1 74 70 80 00       	mov    0x807074,%eax
  8018f8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8018fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801903:	c7 04 24 c4 31 80 00 	movl   $0x8031c4,(%esp)
  80190a:	e8 66 e9 ff ff       	call   800275 <cprintf>
  80190f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801914:	eb 22                	jmp    801938 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801916:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801919:	8b 48 0c             	mov    0xc(%eax),%ecx
  80191c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801921:	85 c9                	test   %ecx,%ecx
  801923:	74 13                	je     801938 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801925:	8b 45 10             	mov    0x10(%ebp),%eax
  801928:	89 44 24 08          	mov    %eax,0x8(%esp)
  80192c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80192f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801933:	89 14 24             	mov    %edx,(%esp)
  801936:	ff d1                	call   *%ecx
}
  801938:	83 c4 24             	add    $0x24,%esp
  80193b:	5b                   	pop    %ebx
  80193c:	5d                   	pop    %ebp
  80193d:	c3                   	ret    

0080193e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	53                   	push   %ebx
  801942:	83 ec 24             	sub    $0x24,%esp
  801945:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801948:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80194b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194f:	89 1c 24             	mov    %ebx,(%esp)
  801952:	e8 86 fd ff ff       	call   8016dd <fd_lookup>
  801957:	85 c0                	test   %eax,%eax
  801959:	78 6b                	js     8019c6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80195b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80195e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801962:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801965:	8b 00                	mov    (%eax),%eax
  801967:	89 04 24             	mov    %eax,(%esp)
  80196a:	e8 e2 fd ff ff       	call   801751 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80196f:	85 c0                	test   %eax,%eax
  801971:	78 53                	js     8019c6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801973:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801976:	8b 42 08             	mov    0x8(%edx),%eax
  801979:	83 e0 03             	and    $0x3,%eax
  80197c:	83 f8 01             	cmp    $0x1,%eax
  80197f:	75 23                	jne    8019a4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801981:	a1 74 70 80 00       	mov    0x807074,%eax
  801986:	8b 40 4c             	mov    0x4c(%eax),%eax
  801989:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80198d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801991:	c7 04 24 e1 31 80 00 	movl   $0x8031e1,(%esp)
  801998:	e8 d8 e8 ff ff       	call   800275 <cprintf>
  80199d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8019a2:	eb 22                	jmp    8019c6 <read+0x88>
	}
	if (!dev->dev_read)
  8019a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019a7:	8b 48 08             	mov    0x8(%eax),%ecx
  8019aa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019af:	85 c9                	test   %ecx,%ecx
  8019b1:	74 13                	je     8019c6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8019b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c1:	89 14 24             	mov    %edx,(%esp)
  8019c4:	ff d1                	call   *%ecx
}
  8019c6:	83 c4 24             	add    $0x24,%esp
  8019c9:	5b                   	pop    %ebx
  8019ca:	5d                   	pop    %ebp
  8019cb:	c3                   	ret    

008019cc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	57                   	push   %edi
  8019d0:	56                   	push   %esi
  8019d1:	53                   	push   %ebx
  8019d2:	83 ec 1c             	sub    $0x1c,%esp
  8019d5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019d8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019db:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ea:	85 f6                	test   %esi,%esi
  8019ec:	74 29                	je     801a17 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019ee:	89 f0                	mov    %esi,%eax
  8019f0:	29 d0                	sub    %edx,%eax
  8019f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019f6:	03 55 0c             	add    0xc(%ebp),%edx
  8019f9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019fd:	89 3c 24             	mov    %edi,(%esp)
  801a00:	e8 39 ff ff ff       	call   80193e <read>
		if (m < 0)
  801a05:	85 c0                	test   %eax,%eax
  801a07:	78 0e                	js     801a17 <readn+0x4b>
			return m;
		if (m == 0)
  801a09:	85 c0                	test   %eax,%eax
  801a0b:	74 08                	je     801a15 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a0d:	01 c3                	add    %eax,%ebx
  801a0f:	89 da                	mov    %ebx,%edx
  801a11:	39 f3                	cmp    %esi,%ebx
  801a13:	72 d9                	jb     8019ee <readn+0x22>
  801a15:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801a17:	83 c4 1c             	add    $0x1c,%esp
  801a1a:	5b                   	pop    %ebx
  801a1b:	5e                   	pop    %esi
  801a1c:	5f                   	pop    %edi
  801a1d:	5d                   	pop    %ebp
  801a1e:	c3                   	ret    

00801a1f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	56                   	push   %esi
  801a23:	53                   	push   %ebx
  801a24:	83 ec 20             	sub    $0x20,%esp
  801a27:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801a2a:	89 34 24             	mov    %esi,(%esp)
  801a2d:	e8 0e fc ff ff       	call   801640 <fd2num>
  801a32:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a35:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a39:	89 04 24             	mov    %eax,(%esp)
  801a3c:	e8 9c fc ff ff       	call   8016dd <fd_lookup>
  801a41:	89 c3                	mov    %eax,%ebx
  801a43:	85 c0                	test   %eax,%eax
  801a45:	78 05                	js     801a4c <fd_close+0x2d>
  801a47:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801a4a:	74 0c                	je     801a58 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801a4c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a50:	19 c0                	sbb    %eax,%eax
  801a52:	f7 d0                	not    %eax
  801a54:	21 c3                	and    %eax,%ebx
  801a56:	eb 3d                	jmp    801a95 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a58:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5f:	8b 06                	mov    (%esi),%eax
  801a61:	89 04 24             	mov    %eax,(%esp)
  801a64:	e8 e8 fc ff ff       	call   801751 <dev_lookup>
  801a69:	89 c3                	mov    %eax,%ebx
  801a6b:	85 c0                	test   %eax,%eax
  801a6d:	78 16                	js     801a85 <fd_close+0x66>
		if (dev->dev_close)
  801a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a72:	8b 40 10             	mov    0x10(%eax),%eax
  801a75:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	74 07                	je     801a85 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801a7e:	89 34 24             	mov    %esi,(%esp)
  801a81:	ff d0                	call   *%eax
  801a83:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801a85:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a89:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a90:	e8 65 f5 ff ff       	call   800ffa <sys_page_unmap>
	return r;
}
  801a95:	89 d8                	mov    %ebx,%eax
  801a97:	83 c4 20             	add    $0x20,%esp
  801a9a:	5b                   	pop    %ebx
  801a9b:	5e                   	pop    %esi
  801a9c:	5d                   	pop    %ebp
  801a9d:	c3                   	ret    

00801a9e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aab:	8b 45 08             	mov    0x8(%ebp),%eax
  801aae:	89 04 24             	mov    %eax,(%esp)
  801ab1:	e8 27 fc ff ff       	call   8016dd <fd_lookup>
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	78 13                	js     801acd <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801aba:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801ac1:	00 
  801ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac5:	89 04 24             	mov    %eax,(%esp)
  801ac8:	e8 52 ff ff ff       	call   801a1f <fd_close>
}
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	83 ec 18             	sub    $0x18,%esp
  801ad5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801ad8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801adb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ae2:	00 
  801ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae6:	89 04 24             	mov    %eax,(%esp)
  801ae9:	e8 a9 03 00 00       	call   801e97 <open>
  801aee:	89 c3                	mov    %eax,%ebx
  801af0:	85 c0                	test   %eax,%eax
  801af2:	78 1b                	js     801b0f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801af4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801afb:	89 1c 24             	mov    %ebx,(%esp)
  801afe:	e8 b7 fc ff ff       	call   8017ba <fstat>
  801b03:	89 c6                	mov    %eax,%esi
	close(fd);
  801b05:	89 1c 24             	mov    %ebx,(%esp)
  801b08:	e8 91 ff ff ff       	call   801a9e <close>
  801b0d:	89 f3                	mov    %esi,%ebx
	return r;
}
  801b0f:	89 d8                	mov    %ebx,%eax
  801b11:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801b14:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801b17:	89 ec                	mov    %ebp,%esp
  801b19:	5d                   	pop    %ebp
  801b1a:	c3                   	ret    

00801b1b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
  801b1e:	53                   	push   %ebx
  801b1f:	83 ec 14             	sub    $0x14,%esp
  801b22:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801b27:	89 1c 24             	mov    %ebx,(%esp)
  801b2a:	e8 6f ff ff ff       	call   801a9e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801b2f:	83 c3 01             	add    $0x1,%ebx
  801b32:	83 fb 20             	cmp    $0x20,%ebx
  801b35:	75 f0                	jne    801b27 <close_all+0xc>
		close(i);
}
  801b37:	83 c4 14             	add    $0x14,%esp
  801b3a:	5b                   	pop    %ebx
  801b3b:	5d                   	pop    %ebp
  801b3c:	c3                   	ret    

00801b3d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801b3d:	55                   	push   %ebp
  801b3e:	89 e5                	mov    %esp,%ebp
  801b40:	83 ec 58             	sub    $0x58,%esp
  801b43:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b46:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b49:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b4c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801b4f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b52:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	89 04 24             	mov    %eax,(%esp)
  801b5c:	e8 7c fb ff ff       	call   8016dd <fd_lookup>
  801b61:	89 c3                	mov    %eax,%ebx
  801b63:	85 c0                	test   %eax,%eax
  801b65:	0f 88 e0 00 00 00    	js     801c4b <dup+0x10e>
		return r;
	close(newfdnum);
  801b6b:	89 3c 24             	mov    %edi,(%esp)
  801b6e:	e8 2b ff ff ff       	call   801a9e <close>

	newfd = INDEX2FD(newfdnum);
  801b73:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801b79:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801b7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b7f:	89 04 24             	mov    %eax,(%esp)
  801b82:	e8 c9 fa ff ff       	call   801650 <fd2data>
  801b87:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801b89:	89 34 24             	mov    %esi,(%esp)
  801b8c:	e8 bf fa ff ff       	call   801650 <fd2data>
  801b91:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801b94:	89 da                	mov    %ebx,%edx
  801b96:	89 d8                	mov    %ebx,%eax
  801b98:	c1 e8 16             	shr    $0x16,%eax
  801b9b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ba2:	a8 01                	test   $0x1,%al
  801ba4:	74 43                	je     801be9 <dup+0xac>
  801ba6:	c1 ea 0c             	shr    $0xc,%edx
  801ba9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801bb0:	a8 01                	test   $0x1,%al
  801bb2:	74 35                	je     801be9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801bb4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801bbb:	25 07 0e 00 00       	and    $0xe07,%eax
  801bc0:	89 44 24 10          	mov    %eax,0x10(%esp)
  801bc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bc7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bcb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bd2:	00 
  801bd3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801bd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bde:	e8 75 f4 ff ff       	call   801058 <sys_page_map>
  801be3:	89 c3                	mov    %eax,%ebx
  801be5:	85 c0                	test   %eax,%eax
  801be7:	78 3f                	js     801c28 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801be9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bec:	89 c2                	mov    %eax,%edx
  801bee:	c1 ea 0c             	shr    $0xc,%edx
  801bf1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801bf8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801bfe:	89 54 24 10          	mov    %edx,0x10(%esp)
  801c02:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c06:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c0d:	00 
  801c0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c19:	e8 3a f4 ff ff       	call   801058 <sys_page_map>
  801c1e:	89 c3                	mov    %eax,%ebx
  801c20:	85 c0                	test   %eax,%eax
  801c22:	78 04                	js     801c28 <dup+0xeb>
  801c24:	89 fb                	mov    %edi,%ebx
  801c26:	eb 23                	jmp    801c4b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801c28:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c2c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c33:	e8 c2 f3 ff ff       	call   800ffa <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c46:	e8 af f3 ff ff       	call   800ffa <sys_page_unmap>
	return r;
}
  801c4b:	89 d8                	mov    %ebx,%eax
  801c4d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c50:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c53:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c56:	89 ec                	mov    %ebp,%esp
  801c58:	5d                   	pop    %ebp
  801c59:	c3                   	ret    
	...

00801c5c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c5c:	55                   	push   %ebp
  801c5d:	89 e5                	mov    %esp,%ebp
  801c5f:	53                   	push   %ebx
  801c60:	83 ec 14             	sub    $0x14,%esp
  801c63:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c65:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801c6b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c72:	00 
  801c73:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801c7a:	00 
  801c7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c7f:	89 14 24             	mov    %edx,(%esp)
  801c82:	e8 e9 f8 ff ff       	call   801570 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c87:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c8e:	00 
  801c8f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c93:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c9a:	e8 33 f9 ff ff       	call   8015d2 <ipc_recv>
}
  801c9f:	83 c4 14             	add    $0x14,%esp
  801ca2:	5b                   	pop    %ebx
  801ca3:	5d                   	pop    %ebp
  801ca4:	c3                   	ret    

00801ca5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801cab:	8b 45 08             	mov    0x8(%ebp),%eax
  801cae:	8b 40 0c             	mov    0xc(%eax),%eax
  801cb1:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb9:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801cbe:	ba 00 00 00 00       	mov    $0x0,%edx
  801cc3:	b8 02 00 00 00       	mov    $0x2,%eax
  801cc8:	e8 8f ff ff ff       	call   801c5c <fsipc>
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
  801cd2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801cd5:	ba 00 00 00 00       	mov    $0x0,%edx
  801cda:	b8 08 00 00 00       	mov    $0x8,%eax
  801cdf:	e8 78 ff ff ff       	call   801c5c <fsipc>
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	53                   	push   %ebx
  801cea:	83 ec 14             	sub    $0x14,%esp
  801ced:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf3:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf6:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801cfb:	ba 00 00 00 00       	mov    $0x0,%edx
  801d00:	b8 05 00 00 00       	mov    $0x5,%eax
  801d05:	e8 52 ff ff ff       	call   801c5c <fsipc>
  801d0a:	85 c0                	test   %eax,%eax
  801d0c:	78 2b                	js     801d39 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801d0e:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801d15:	00 
  801d16:	89 1c 24             	mov    %ebx,(%esp)
  801d19:	e8 3c ec ff ff       	call   80095a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801d1e:	a1 80 40 80 00       	mov    0x804080,%eax
  801d23:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801d29:	a1 84 40 80 00       	mov    0x804084,%eax
  801d2e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801d34:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801d39:	83 c4 14             	add    $0x14,%esp
  801d3c:	5b                   	pop    %ebx
  801d3d:	5d                   	pop    %ebp
  801d3e:	c3                   	ret    

00801d3f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  801d45:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801d4c:	00 
  801d4d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d54:	00 
  801d55:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801d5c:	e8 55 ed ff ff       	call   800ab6 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d61:	8b 45 08             	mov    0x8(%ebp),%eax
  801d64:	8b 40 0c             	mov    0xc(%eax),%eax
  801d67:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801d6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d71:	b8 06 00 00 00       	mov    $0x6,%eax
  801d76:	e8 e1 fe ff ff       	call   801c5c <fsipc>
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
  801d80:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801d83:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801d8a:	00 
  801d8b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d92:	00 
  801d93:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801d9a:	e8 17 ed ff ff       	call   800ab6 <memset>
  801d9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801da2:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801da7:	76 05                	jbe    801dae <devfile_write+0x31>
  801da9:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801dae:	8b 55 08             	mov    0x8(%ebp),%edx
  801db1:	8b 52 0c             	mov    0xc(%edx),%edx
  801db4:	89 15 00 40 80 00    	mov    %edx,0x804000
        fsipcbuf.write.req_n = numberOfBytes;
  801dba:	a3 04 40 80 00       	mov    %eax,0x804004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  801dbf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dca:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801dd1:	e8 3f ed ff ff       	call   800b15 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  801dd6:	ba 00 00 00 00       	mov    $0x0,%edx
  801ddb:	b8 04 00 00 00       	mov    $0x4,%eax
  801de0:	e8 77 fe ff ff       	call   801c5c <fsipc>
              return r;
        return r;
}
  801de5:	c9                   	leave  
  801de6:	c3                   	ret    

00801de7 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801de7:	55                   	push   %ebp
  801de8:	89 e5                	mov    %esp,%ebp
  801dea:	53                   	push   %ebx
  801deb:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  801dee:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801df5:	00 
  801df6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801dfd:	00 
  801dfe:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e05:	e8 ac ec ff ff       	call   800ab6 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  801e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e0d:	8b 40 0c             	mov    0xc(%eax),%eax
  801e10:	a3 00 40 80 00       	mov    %eax,0x804000
        fsipcbuf.read.req_n = n;
  801e15:	8b 45 10             	mov    0x10(%ebp),%eax
  801e18:	a3 04 40 80 00       	mov    %eax,0x804004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  801e1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801e22:	b8 03 00 00 00       	mov    $0x3,%eax
  801e27:	e8 30 fe ff ff       	call   801c5c <fsipc>
  801e2c:	89 c3                	mov    %eax,%ebx
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	78 17                	js     801e49 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  801e32:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e36:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801e3d:	00 
  801e3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e41:	89 04 24             	mov    %eax,(%esp)
  801e44:	e8 cc ec ff ff       	call   800b15 <memmove>
        return r;
}
  801e49:	89 d8                	mov    %ebx,%eax
  801e4b:	83 c4 14             	add    $0x14,%esp
  801e4e:	5b                   	pop    %ebx
  801e4f:	5d                   	pop    %ebp
  801e50:	c3                   	ret    

00801e51 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801e51:	55                   	push   %ebp
  801e52:	89 e5                	mov    %esp,%ebp
  801e54:	53                   	push   %ebx
  801e55:	83 ec 14             	sub    $0x14,%esp
  801e58:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801e5b:	89 1c 24             	mov    %ebx,(%esp)
  801e5e:	e8 ad ea ff ff       	call   800910 <strlen>
  801e63:	89 c2                	mov    %eax,%edx
  801e65:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801e6a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801e70:	7f 1f                	jg     801e91 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801e72:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e76:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e7d:	e8 d8 ea ff ff       	call   80095a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801e82:	ba 00 00 00 00       	mov    $0x0,%edx
  801e87:	b8 07 00 00 00       	mov    $0x7,%eax
  801e8c:	e8 cb fd ff ff       	call   801c5c <fsipc>
}
  801e91:	83 c4 14             	add    $0x14,%esp
  801e94:	5b                   	pop    %ebx
  801e95:	5d                   	pop    %ebp
  801e96:	c3                   	ret    

00801e97 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	56                   	push   %esi
  801e9b:	53                   	push   %ebx
  801e9c:	83 ec 20             	sub    $0x20,%esp
  801e9f:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  801ea2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801ea9:	00 
  801eaa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801eb1:	00 
  801eb2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801eb9:	e8 f8 eb ff ff       	call   800ab6 <memset>
    if(strlen(path)>=MAXPATHLEN)
  801ebe:	89 34 24             	mov    %esi,(%esp)
  801ec1:	e8 4a ea ff ff       	call   800910 <strlen>
  801ec6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ecb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ed0:	0f 8f 84 00 00 00    	jg     801f5a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  801ed6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ed9:	89 04 24             	mov    %eax,(%esp)
  801edc:	e8 8a f7 ff ff       	call   80166b <fd_alloc>
  801ee1:	89 c3                	mov    %eax,%ebx
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	78 73                	js     801f5a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  801ee7:	0f b6 06             	movzbl (%esi),%eax
  801eea:	84 c0                	test   %al,%al
  801eec:	74 20                	je     801f0e <open+0x77>
  801eee:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  801ef0:	0f be c0             	movsbl %al,%eax
  801ef3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef7:	c7 04 24 14 32 80 00 	movl   $0x803214,(%esp)
  801efe:	e8 72 e3 ff ff       	call   800275 <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  801f03:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  801f07:	83 c3 01             	add    $0x1,%ebx
  801f0a:	84 c0                	test   %al,%al
  801f0c:	75 e2                	jne    801ef0 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  801f0e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f12:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801f19:	e8 3c ea ff ff       	call   80095a <strcpy>
    fsipcbuf.open.req_omode = mode;
  801f1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f21:	a3 00 44 80 00       	mov    %eax,0x804400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  801f26:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f29:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2e:	e8 29 fd ff ff       	call   801c5c <fsipc>
  801f33:	89 c3                	mov    %eax,%ebx
  801f35:	85 c0                	test   %eax,%eax
  801f37:	79 15                	jns    801f4e <open+0xb7>
        {
            fd_close(fd,1);
  801f39:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801f40:	00 
  801f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f44:	89 04 24             	mov    %eax,(%esp)
  801f47:	e8 d3 fa ff ff       	call   801a1f <fd_close>
             return r;
  801f4c:	eb 0c                	jmp    801f5a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  801f4e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801f51:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  801f57:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  801f5a:	89 d8                	mov    %ebx,%eax
  801f5c:	83 c4 20             	add    $0x20,%esp
  801f5f:	5b                   	pop    %ebx
  801f60:	5e                   	pop    %esi
  801f61:	5d                   	pop    %ebp
  801f62:	c3                   	ret    
	...

00801f70 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801f76:	c7 44 24 04 17 32 80 	movl   $0x803217,0x4(%esp)
  801f7d:	00 
  801f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f81:	89 04 24             	mov    %eax,(%esp)
  801f84:	e8 d1 e9 ff ff       	call   80095a <strcpy>
	return 0;
}
  801f89:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8e:	c9                   	leave  
  801f8f:	c3                   	ret    

00801f90 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801f90:	55                   	push   %ebp
  801f91:	89 e5                	mov    %esp,%ebp
  801f93:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801f96:	8b 45 08             	mov    0x8(%ebp),%eax
  801f99:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9c:	89 04 24             	mov    %eax,(%esp)
  801f9f:	e8 9e 02 00 00       	call   802242 <nsipc_close>
}
  801fa4:	c9                   	leave  
  801fa5:	c3                   	ret    

00801fa6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801fa6:	55                   	push   %ebp
  801fa7:	89 e5                	mov    %esp,%ebp
  801fa9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801fac:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801fb3:	00 
  801fb4:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc5:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc8:	89 04 24             	mov    %eax,(%esp)
  801fcb:	e8 ae 02 00 00       	call   80227e <nsipc_send>
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fd8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801fdf:	00 
  801fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fe7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fea:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fee:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff4:	89 04 24             	mov    %eax,(%esp)
  801ff7:	e8 f5 02 00 00       	call   8022f1 <nsipc_recv>
}
  801ffc:	c9                   	leave  
  801ffd:	c3                   	ret    

00801ffe <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801ffe:	55                   	push   %ebp
  801fff:	89 e5                	mov    %esp,%ebp
  802001:	56                   	push   %esi
  802002:	53                   	push   %ebx
  802003:	83 ec 20             	sub    $0x20,%esp
  802006:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802008:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80200b:	89 04 24             	mov    %eax,(%esp)
  80200e:	e8 58 f6 ff ff       	call   80166b <fd_alloc>
  802013:	89 c3                	mov    %eax,%ebx
  802015:	85 c0                	test   %eax,%eax
  802017:	78 21                	js     80203a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  802019:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802020:	00 
  802021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802024:	89 44 24 04          	mov    %eax,0x4(%esp)
  802028:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80202f:	e8 82 f0 ff ff       	call   8010b6 <sys_page_alloc>
  802034:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802036:	85 c0                	test   %eax,%eax
  802038:	79 0a                	jns    802044 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80203a:	89 34 24             	mov    %esi,(%esp)
  80203d:	e8 00 02 00 00       	call   802242 <nsipc_close>
		return r;
  802042:	eb 28                	jmp    80206c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802044:	8b 15 20 70 80 00    	mov    0x807020,%edx
  80204a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80204f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802052:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80205f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802062:	89 04 24             	mov    %eax,(%esp)
  802065:	e8 d6 f5 ff ff       	call   801640 <fd2num>
  80206a:	89 c3                	mov    %eax,%ebx
}
  80206c:	89 d8                	mov    %ebx,%eax
  80206e:	83 c4 20             	add    $0x20,%esp
  802071:	5b                   	pop    %ebx
  802072:	5e                   	pop    %esi
  802073:	5d                   	pop    %ebp
  802074:	c3                   	ret    

00802075 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80207b:	8b 45 10             	mov    0x10(%ebp),%eax
  80207e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802082:	8b 45 0c             	mov    0xc(%ebp),%eax
  802085:	89 44 24 04          	mov    %eax,0x4(%esp)
  802089:	8b 45 08             	mov    0x8(%ebp),%eax
  80208c:	89 04 24             	mov    %eax,(%esp)
  80208f:	e8 62 01 00 00       	call   8021f6 <nsipc_socket>
  802094:	85 c0                	test   %eax,%eax
  802096:	78 05                	js     80209d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802098:	e8 61 ff ff ff       	call   801ffe <alloc_sockfd>
}
  80209d:	c9                   	leave  
  80209e:	66 90                	xchg   %ax,%ax
  8020a0:	c3                   	ret    

008020a1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8020a7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8020aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020ae:	89 04 24             	mov    %eax,(%esp)
  8020b1:	e8 27 f6 ff ff       	call   8016dd <fd_lookup>
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	78 15                	js     8020cf <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8020ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020bd:	8b 0a                	mov    (%edx),%ecx
  8020bf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8020c4:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  8020ca:	75 03                	jne    8020cf <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8020cc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8020cf:	c9                   	leave  
  8020d0:	c3                   	ret    

008020d1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8020d1:	55                   	push   %ebp
  8020d2:	89 e5                	mov    %esp,%ebp
  8020d4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020da:	e8 c2 ff ff ff       	call   8020a1 <fd2sockid>
  8020df:	85 c0                	test   %eax,%eax
  8020e1:	78 0f                	js     8020f2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8020e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020ea:	89 04 24             	mov    %eax,(%esp)
  8020ed:	e8 2e 01 00 00       	call   802220 <nsipc_listen>
}
  8020f2:	c9                   	leave  
  8020f3:	c3                   	ret    

008020f4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020f4:	55                   	push   %ebp
  8020f5:	89 e5                	mov    %esp,%ebp
  8020f7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fd:	e8 9f ff ff ff       	call   8020a1 <fd2sockid>
  802102:	85 c0                	test   %eax,%eax
  802104:	78 16                	js     80211c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802106:	8b 55 10             	mov    0x10(%ebp),%edx
  802109:	89 54 24 08          	mov    %edx,0x8(%esp)
  80210d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802110:	89 54 24 04          	mov    %edx,0x4(%esp)
  802114:	89 04 24             	mov    %eax,(%esp)
  802117:	e8 55 02 00 00       	call   802371 <nsipc_connect>
}
  80211c:	c9                   	leave  
  80211d:	c3                   	ret    

0080211e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80211e:	55                   	push   %ebp
  80211f:	89 e5                	mov    %esp,%ebp
  802121:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802124:	8b 45 08             	mov    0x8(%ebp),%eax
  802127:	e8 75 ff ff ff       	call   8020a1 <fd2sockid>
  80212c:	85 c0                	test   %eax,%eax
  80212e:	78 0f                	js     80213f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802130:	8b 55 0c             	mov    0xc(%ebp),%edx
  802133:	89 54 24 04          	mov    %edx,0x4(%esp)
  802137:	89 04 24             	mov    %eax,(%esp)
  80213a:	e8 1d 01 00 00       	call   80225c <nsipc_shutdown>
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802147:	8b 45 08             	mov    0x8(%ebp),%eax
  80214a:	e8 52 ff ff ff       	call   8020a1 <fd2sockid>
  80214f:	85 c0                	test   %eax,%eax
  802151:	78 16                	js     802169 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802153:	8b 55 10             	mov    0x10(%ebp),%edx
  802156:	89 54 24 08          	mov    %edx,0x8(%esp)
  80215a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80215d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802161:	89 04 24             	mov    %eax,(%esp)
  802164:	e8 47 02 00 00       	call   8023b0 <nsipc_bind>
}
  802169:	c9                   	leave  
  80216a:	c3                   	ret    

0080216b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80216b:	55                   	push   %ebp
  80216c:	89 e5                	mov    %esp,%ebp
  80216e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	e8 28 ff ff ff       	call   8020a1 <fd2sockid>
  802179:	85 c0                	test   %eax,%eax
  80217b:	78 1f                	js     80219c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80217d:	8b 55 10             	mov    0x10(%ebp),%edx
  802180:	89 54 24 08          	mov    %edx,0x8(%esp)
  802184:	8b 55 0c             	mov    0xc(%ebp),%edx
  802187:	89 54 24 04          	mov    %edx,0x4(%esp)
  80218b:	89 04 24             	mov    %eax,(%esp)
  80218e:	e8 5c 02 00 00       	call   8023ef <nsipc_accept>
  802193:	85 c0                	test   %eax,%eax
  802195:	78 05                	js     80219c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802197:	e8 62 fe ff ff       	call   801ffe <alloc_sockfd>
}
  80219c:	c9                   	leave  
  80219d:	8d 76 00             	lea    0x0(%esi),%esi
  8021a0:	c3                   	ret    
	...

008021b0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8021b0:	55                   	push   %ebp
  8021b1:	89 e5                	mov    %esp,%ebp
  8021b3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8021b6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8021bc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8021c3:	00 
  8021c4:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8021cb:	00 
  8021cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d0:	89 14 24             	mov    %edx,(%esp)
  8021d3:	e8 98 f3 ff ff       	call   801570 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021d8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021df:	00 
  8021e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8021e7:	00 
  8021e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021ef:	e8 de f3 ff ff       	call   8015d2 <ipc_recv>
}
  8021f4:	c9                   	leave  
  8021f5:	c3                   	ret    

008021f6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8021f6:	55                   	push   %ebp
  8021f7:	89 e5                	mov    %esp,%ebp
  8021f9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802204:	8b 45 0c             	mov    0xc(%ebp),%eax
  802207:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80220c:	8b 45 10             	mov    0x10(%ebp),%eax
  80220f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802214:	b8 09 00 00 00       	mov    $0x9,%eax
  802219:	e8 92 ff ff ff       	call   8021b0 <nsipc>
}
  80221e:	c9                   	leave  
  80221f:	c3                   	ret    

00802220 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802220:	55                   	push   %ebp
  802221:	89 e5                	mov    %esp,%ebp
  802223:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80222e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802231:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802236:	b8 06 00 00 00       	mov    $0x6,%eax
  80223b:	e8 70 ff ff ff       	call   8021b0 <nsipc>
}
  802240:	c9                   	leave  
  802241:	c3                   	ret    

00802242 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802242:	55                   	push   %ebp
  802243:	89 e5                	mov    %esp,%ebp
  802245:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802250:	b8 04 00 00 00       	mov    $0x4,%eax
  802255:	e8 56 ff ff ff       	call   8021b0 <nsipc>
}
  80225a:	c9                   	leave  
  80225b:	c3                   	ret    

0080225c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80225c:	55                   	push   %ebp
  80225d:	89 e5                	mov    %esp,%ebp
  80225f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802262:	8b 45 08             	mov    0x8(%ebp),%eax
  802265:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80226a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80226d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802272:	b8 03 00 00 00       	mov    $0x3,%eax
  802277:	e8 34 ff ff ff       	call   8021b0 <nsipc>
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
  802281:	53                   	push   %ebx
  802282:	83 ec 14             	sub    $0x14,%esp
  802285:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802290:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802296:	7e 24                	jle    8022bc <nsipc_send+0x3e>
  802298:	c7 44 24 0c 23 32 80 	movl   $0x803223,0xc(%esp)
  80229f:	00 
  8022a0:	c7 44 24 08 2f 32 80 	movl   $0x80322f,0x8(%esp)
  8022a7:	00 
  8022a8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8022af:	00 
  8022b0:	c7 04 24 44 32 80 00 	movl   $0x803244,(%esp)
  8022b7:	e8 f4 de ff ff       	call   8001b0 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8022bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c7:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8022ce:	e8 42 e8 ff ff       	call   800b15 <memmove>
	nsipcbuf.send.req_size = size;
  8022d3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8022d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8022dc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8022e1:	b8 08 00 00 00       	mov    $0x8,%eax
  8022e6:	e8 c5 fe ff ff       	call   8021b0 <nsipc>
}
  8022eb:	83 c4 14             	add    $0x14,%esp
  8022ee:	5b                   	pop    %ebx
  8022ef:	5d                   	pop    %ebp
  8022f0:	c3                   	ret    

008022f1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	56                   	push   %esi
  8022f5:	53                   	push   %ebx
  8022f6:	83 ec 10             	sub    $0x10,%esp
  8022f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802304:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80230a:	8b 45 14             	mov    0x14(%ebp),%eax
  80230d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802312:	b8 07 00 00 00       	mov    $0x7,%eax
  802317:	e8 94 fe ff ff       	call   8021b0 <nsipc>
  80231c:	89 c3                	mov    %eax,%ebx
  80231e:	85 c0                	test   %eax,%eax
  802320:	78 46                	js     802368 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802322:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802327:	7f 04                	jg     80232d <nsipc_recv+0x3c>
  802329:	39 c6                	cmp    %eax,%esi
  80232b:	7d 24                	jge    802351 <nsipc_recv+0x60>
  80232d:	c7 44 24 0c 50 32 80 	movl   $0x803250,0xc(%esp)
  802334:	00 
  802335:	c7 44 24 08 2f 32 80 	movl   $0x80322f,0x8(%esp)
  80233c:	00 
  80233d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802344:	00 
  802345:	c7 04 24 44 32 80 00 	movl   $0x803244,(%esp)
  80234c:	e8 5f de ff ff       	call   8001b0 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802351:	89 44 24 08          	mov    %eax,0x8(%esp)
  802355:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80235c:	00 
  80235d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802360:	89 04 24             	mov    %eax,(%esp)
  802363:	e8 ad e7 ff ff       	call   800b15 <memmove>
	}

	return r;
}
  802368:	89 d8                	mov    %ebx,%eax
  80236a:	83 c4 10             	add    $0x10,%esp
  80236d:	5b                   	pop    %ebx
  80236e:	5e                   	pop    %esi
  80236f:	5d                   	pop    %ebp
  802370:	c3                   	ret    

00802371 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802371:	55                   	push   %ebp
  802372:	89 e5                	mov    %esp,%ebp
  802374:	53                   	push   %ebx
  802375:	83 ec 14             	sub    $0x14,%esp
  802378:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80237b:	8b 45 08             	mov    0x8(%ebp),%eax
  80237e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802383:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80238a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80238e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802395:	e8 7b e7 ff ff       	call   800b15 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80239a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8023a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8023a5:	e8 06 fe ff ff       	call   8021b0 <nsipc>
}
  8023aa:	83 c4 14             	add    $0x14,%esp
  8023ad:	5b                   	pop    %ebx
  8023ae:	5d                   	pop    %ebp
  8023af:	c3                   	ret    

008023b0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8023b0:	55                   	push   %ebp
  8023b1:	89 e5                	mov    %esp,%ebp
  8023b3:	53                   	push   %ebx
  8023b4:	83 ec 14             	sub    $0x14,%esp
  8023b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8023c2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023cd:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8023d4:	e8 3c e7 ff ff       	call   800b15 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8023d9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8023df:	b8 02 00 00 00       	mov    $0x2,%eax
  8023e4:	e8 c7 fd ff ff       	call   8021b0 <nsipc>
}
  8023e9:	83 c4 14             	add    $0x14,%esp
  8023ec:	5b                   	pop    %ebx
  8023ed:	5d                   	pop    %ebp
  8023ee:	c3                   	ret    

008023ef <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8023ef:	55                   	push   %ebp
  8023f0:	89 e5                	mov    %esp,%ebp
  8023f2:	83 ec 18             	sub    $0x18,%esp
  8023f5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8023f8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8023fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fe:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802403:	b8 01 00 00 00       	mov    $0x1,%eax
  802408:	e8 a3 fd ff ff       	call   8021b0 <nsipc>
  80240d:	89 c3                	mov    %eax,%ebx
  80240f:	85 c0                	test   %eax,%eax
  802411:	78 25                	js     802438 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802413:	be 10 60 80 00       	mov    $0x806010,%esi
  802418:	8b 06                	mov    (%esi),%eax
  80241a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80241e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802425:	00 
  802426:	8b 45 0c             	mov    0xc(%ebp),%eax
  802429:	89 04 24             	mov    %eax,(%esp)
  80242c:	e8 e4 e6 ff ff       	call   800b15 <memmove>
		*addrlen = ret->ret_addrlen;
  802431:	8b 16                	mov    (%esi),%edx
  802433:	8b 45 10             	mov    0x10(%ebp),%eax
  802436:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802438:	89 d8                	mov    %ebx,%eax
  80243a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80243d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802440:	89 ec                	mov    %ebp,%esp
  802442:	5d                   	pop    %ebp
  802443:	c3                   	ret    
	...

00802450 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802450:	55                   	push   %ebp
  802451:	89 e5                	mov    %esp,%ebp
  802453:	83 ec 18             	sub    $0x18,%esp
  802456:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802459:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80245c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80245f:	8b 45 08             	mov    0x8(%ebp),%eax
  802462:	89 04 24             	mov    %eax,(%esp)
  802465:	e8 e6 f1 ff ff       	call   801650 <fd2data>
  80246a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80246c:	c7 44 24 04 65 32 80 	movl   $0x803265,0x4(%esp)
  802473:	00 
  802474:	89 34 24             	mov    %esi,(%esp)
  802477:	e8 de e4 ff ff       	call   80095a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80247c:	8b 43 04             	mov    0x4(%ebx),%eax
  80247f:	2b 03                	sub    (%ebx),%eax
  802481:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802487:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80248e:	00 00 00 
	stat->st_dev = &devpipe;
  802491:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  802498:	70 80 00 
	return 0;
}
  80249b:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8024a3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8024a6:	89 ec                	mov    %ebp,%esp
  8024a8:	5d                   	pop    %ebp
  8024a9:	c3                   	ret    

008024aa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8024aa:	55                   	push   %ebp
  8024ab:	89 e5                	mov    %esp,%ebp
  8024ad:	53                   	push   %ebx
  8024ae:	83 ec 14             	sub    $0x14,%esp
  8024b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8024b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024bf:	e8 36 eb ff ff       	call   800ffa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8024c4:	89 1c 24             	mov    %ebx,(%esp)
  8024c7:	e8 84 f1 ff ff       	call   801650 <fd2data>
  8024cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d7:	e8 1e eb ff ff       	call   800ffa <sys_page_unmap>
}
  8024dc:	83 c4 14             	add    $0x14,%esp
  8024df:	5b                   	pop    %ebx
  8024e0:	5d                   	pop    %ebp
  8024e1:	c3                   	ret    

008024e2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8024e2:	55                   	push   %ebp
  8024e3:	89 e5                	mov    %esp,%ebp
  8024e5:	57                   	push   %edi
  8024e6:	56                   	push   %esi
  8024e7:	53                   	push   %ebx
  8024e8:	83 ec 2c             	sub    $0x2c,%esp
  8024eb:	89 c7                	mov    %eax,%edi
  8024ed:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8024f0:	a1 74 70 80 00       	mov    0x807074,%eax
  8024f5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024f8:	89 3c 24             	mov    %edi,(%esp)
  8024fb:	e8 7c 05 00 00       	call   802a7c <pageref>
  802500:	89 c6                	mov    %eax,%esi
  802502:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802505:	89 04 24             	mov    %eax,(%esp)
  802508:	e8 6f 05 00 00       	call   802a7c <pageref>
  80250d:	39 c6                	cmp    %eax,%esi
  80250f:	0f 94 c0             	sete   %al
  802512:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802515:	8b 15 74 70 80 00    	mov    0x807074,%edx
  80251b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80251e:	39 cb                	cmp    %ecx,%ebx
  802520:	75 08                	jne    80252a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802522:	83 c4 2c             	add    $0x2c,%esp
  802525:	5b                   	pop    %ebx
  802526:	5e                   	pop    %esi
  802527:	5f                   	pop    %edi
  802528:	5d                   	pop    %ebp
  802529:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80252a:	83 f8 01             	cmp    $0x1,%eax
  80252d:	75 c1                	jne    8024f0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80252f:	8b 52 58             	mov    0x58(%edx),%edx
  802532:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802536:	89 54 24 08          	mov    %edx,0x8(%esp)
  80253a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80253e:	c7 04 24 6c 32 80 00 	movl   $0x80326c,(%esp)
  802545:	e8 2b dd ff ff       	call   800275 <cprintf>
  80254a:	eb a4                	jmp    8024f0 <_pipeisclosed+0xe>

0080254c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80254c:	55                   	push   %ebp
  80254d:	89 e5                	mov    %esp,%ebp
  80254f:	57                   	push   %edi
  802550:	56                   	push   %esi
  802551:	53                   	push   %ebx
  802552:	83 ec 1c             	sub    $0x1c,%esp
  802555:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802558:	89 34 24             	mov    %esi,(%esp)
  80255b:	e8 f0 f0 ff ff       	call   801650 <fd2data>
  802560:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802562:	bf 00 00 00 00       	mov    $0x0,%edi
  802567:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80256b:	75 54                	jne    8025c1 <devpipe_write+0x75>
  80256d:	eb 60                	jmp    8025cf <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80256f:	89 da                	mov    %ebx,%edx
  802571:	89 f0                	mov    %esi,%eax
  802573:	e8 6a ff ff ff       	call   8024e2 <_pipeisclosed>
  802578:	85 c0                	test   %eax,%eax
  80257a:	74 07                	je     802583 <devpipe_write+0x37>
  80257c:	b8 00 00 00 00       	mov    $0x0,%eax
  802581:	eb 53                	jmp    8025d6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802583:	90                   	nop
  802584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802588:	e8 88 eb ff ff       	call   801115 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80258d:	8b 43 04             	mov    0x4(%ebx),%eax
  802590:	8b 13                	mov    (%ebx),%edx
  802592:	83 c2 20             	add    $0x20,%edx
  802595:	39 d0                	cmp    %edx,%eax
  802597:	73 d6                	jae    80256f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802599:	89 c2                	mov    %eax,%edx
  80259b:	c1 fa 1f             	sar    $0x1f,%edx
  80259e:	c1 ea 1b             	shr    $0x1b,%edx
  8025a1:	01 d0                	add    %edx,%eax
  8025a3:	83 e0 1f             	and    $0x1f,%eax
  8025a6:	29 d0                	sub    %edx,%eax
  8025a8:	89 c2                	mov    %eax,%edx
  8025aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8025ad:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8025b1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8025b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025b9:	83 c7 01             	add    $0x1,%edi
  8025bc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8025bf:	76 13                	jbe    8025d4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8025c1:	8b 43 04             	mov    0x4(%ebx),%eax
  8025c4:	8b 13                	mov    (%ebx),%edx
  8025c6:	83 c2 20             	add    $0x20,%edx
  8025c9:	39 d0                	cmp    %edx,%eax
  8025cb:	73 a2                	jae    80256f <devpipe_write+0x23>
  8025cd:	eb ca                	jmp    802599 <devpipe_write+0x4d>
  8025cf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8025d4:	89 f8                	mov    %edi,%eax
}
  8025d6:	83 c4 1c             	add    $0x1c,%esp
  8025d9:	5b                   	pop    %ebx
  8025da:	5e                   	pop    %esi
  8025db:	5f                   	pop    %edi
  8025dc:	5d                   	pop    %ebp
  8025dd:	c3                   	ret    

008025de <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025de:	55                   	push   %ebp
  8025df:	89 e5                	mov    %esp,%ebp
  8025e1:	83 ec 28             	sub    $0x28,%esp
  8025e4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8025e7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8025ea:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8025ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8025f0:	89 3c 24             	mov    %edi,(%esp)
  8025f3:	e8 58 f0 ff ff       	call   801650 <fd2data>
  8025f8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025fa:	be 00 00 00 00       	mov    $0x0,%esi
  8025ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802603:	75 4c                	jne    802651 <devpipe_read+0x73>
  802605:	eb 5b                	jmp    802662 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802607:	89 f0                	mov    %esi,%eax
  802609:	eb 5e                	jmp    802669 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80260b:	89 da                	mov    %ebx,%edx
  80260d:	89 f8                	mov    %edi,%eax
  80260f:	90                   	nop
  802610:	e8 cd fe ff ff       	call   8024e2 <_pipeisclosed>
  802615:	85 c0                	test   %eax,%eax
  802617:	74 07                	je     802620 <devpipe_read+0x42>
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
  80261e:	eb 49                	jmp    802669 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802620:	e8 f0 ea ff ff       	call   801115 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802625:	8b 03                	mov    (%ebx),%eax
  802627:	3b 43 04             	cmp    0x4(%ebx),%eax
  80262a:	74 df                	je     80260b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80262c:	89 c2                	mov    %eax,%edx
  80262e:	c1 fa 1f             	sar    $0x1f,%edx
  802631:	c1 ea 1b             	shr    $0x1b,%edx
  802634:	01 d0                	add    %edx,%eax
  802636:	83 e0 1f             	and    $0x1f,%eax
  802639:	29 d0                	sub    %edx,%eax
  80263b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802640:	8b 55 0c             	mov    0xc(%ebp),%edx
  802643:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802646:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802649:	83 c6 01             	add    $0x1,%esi
  80264c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80264f:	76 16                	jbe    802667 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802651:	8b 03                	mov    (%ebx),%eax
  802653:	3b 43 04             	cmp    0x4(%ebx),%eax
  802656:	75 d4                	jne    80262c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802658:	85 f6                	test   %esi,%esi
  80265a:	75 ab                	jne    802607 <devpipe_read+0x29>
  80265c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802660:	eb a9                	jmp    80260b <devpipe_read+0x2d>
  802662:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802667:	89 f0                	mov    %esi,%eax
}
  802669:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80266c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80266f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802672:	89 ec                	mov    %ebp,%esp
  802674:	5d                   	pop    %ebp
  802675:	c3                   	ret    

00802676 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
  802679:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80267c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80267f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	89 04 24             	mov    %eax,(%esp)
  802689:	e8 4f f0 ff ff       	call   8016dd <fd_lookup>
  80268e:	85 c0                	test   %eax,%eax
  802690:	78 15                	js     8026a7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	89 04 24             	mov    %eax,(%esp)
  802698:	e8 b3 ef ff ff       	call   801650 <fd2data>
	return _pipeisclosed(fd, p);
  80269d:	89 c2                	mov    %eax,%edx
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	e8 3b fe ff ff       	call   8024e2 <_pipeisclosed>
}
  8026a7:	c9                   	leave  
  8026a8:	c3                   	ret    

008026a9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8026a9:	55                   	push   %ebp
  8026aa:	89 e5                	mov    %esp,%ebp
  8026ac:	83 ec 48             	sub    $0x48,%esp
  8026af:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8026b2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8026b5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8026b8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8026bb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8026be:	89 04 24             	mov    %eax,(%esp)
  8026c1:	e8 a5 ef ff ff       	call   80166b <fd_alloc>
  8026c6:	89 c3                	mov    %eax,%ebx
  8026c8:	85 c0                	test   %eax,%eax
  8026ca:	0f 88 42 01 00 00    	js     802812 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026d0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026d7:	00 
  8026d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026e6:	e8 cb e9 ff ff       	call   8010b6 <sys_page_alloc>
  8026eb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8026ed:	85 c0                	test   %eax,%eax
  8026ef:	0f 88 1d 01 00 00    	js     802812 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8026f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8026f8:	89 04 24             	mov    %eax,(%esp)
  8026fb:	e8 6b ef ff ff       	call   80166b <fd_alloc>
  802700:	89 c3                	mov    %eax,%ebx
  802702:	85 c0                	test   %eax,%eax
  802704:	0f 88 f5 00 00 00    	js     8027ff <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80270a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802711:	00 
  802712:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802715:	89 44 24 04          	mov    %eax,0x4(%esp)
  802719:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802720:	e8 91 e9 ff ff       	call   8010b6 <sys_page_alloc>
  802725:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802727:	85 c0                	test   %eax,%eax
  802729:	0f 88 d0 00 00 00    	js     8027ff <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80272f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802732:	89 04 24             	mov    %eax,(%esp)
  802735:	e8 16 ef ff ff       	call   801650 <fd2data>
  80273a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80273c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802743:	00 
  802744:	89 44 24 04          	mov    %eax,0x4(%esp)
  802748:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80274f:	e8 62 e9 ff ff       	call   8010b6 <sys_page_alloc>
  802754:	89 c3                	mov    %eax,%ebx
  802756:	85 c0                	test   %eax,%eax
  802758:	0f 88 8e 00 00 00    	js     8027ec <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80275e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802761:	89 04 24             	mov    %eax,(%esp)
  802764:	e8 e7 ee ff ff       	call   801650 <fd2data>
  802769:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802770:	00 
  802771:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802775:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80277c:	00 
  80277d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802781:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802788:	e8 cb e8 ff ff       	call   801058 <sys_page_map>
  80278d:	89 c3                	mov    %eax,%ebx
  80278f:	85 c0                	test   %eax,%eax
  802791:	78 49                	js     8027dc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802793:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  802798:	8b 08                	mov    (%eax),%ecx
  80279a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80279d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80279f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8027a2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8027a9:	8b 10                	mov    (%eax),%edx
  8027ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ae:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8027b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027b3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8027ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027bd:	89 04 24             	mov    %eax,(%esp)
  8027c0:	e8 7b ee ff ff       	call   801640 <fd2num>
  8027c5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8027c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ca:	89 04 24             	mov    %eax,(%esp)
  8027cd:	e8 6e ee ff ff       	call   801640 <fd2num>
  8027d2:	89 47 04             	mov    %eax,0x4(%edi)
  8027d5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8027da:	eb 36                	jmp    802812 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8027dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027e7:	e8 0e e8 ff ff       	call   800ffa <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8027ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027fa:	e8 fb e7 ff ff       	call   800ffa <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8027ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802802:	89 44 24 04          	mov    %eax,0x4(%esp)
  802806:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80280d:	e8 e8 e7 ff ff       	call   800ffa <sys_page_unmap>
    err:
	return r;
}
  802812:	89 d8                	mov    %ebx,%eax
  802814:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802817:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80281a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80281d:	89 ec                	mov    %ebp,%esp
  80281f:	5d                   	pop    %ebp
  802820:	c3                   	ret    
	...

00802830 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802830:	55                   	push   %ebp
  802831:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802833:	b8 00 00 00 00       	mov    $0x0,%eax
  802838:	5d                   	pop    %ebp
  802839:	c3                   	ret    

0080283a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80283a:	55                   	push   %ebp
  80283b:	89 e5                	mov    %esp,%ebp
  80283d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802840:	c7 44 24 04 84 32 80 	movl   $0x803284,0x4(%esp)
  802847:	00 
  802848:	8b 45 0c             	mov    0xc(%ebp),%eax
  80284b:	89 04 24             	mov    %eax,(%esp)
  80284e:	e8 07 e1 ff ff       	call   80095a <strcpy>
	return 0;
}
  802853:	b8 00 00 00 00       	mov    $0x0,%eax
  802858:	c9                   	leave  
  802859:	c3                   	ret    

0080285a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80285a:	55                   	push   %ebp
  80285b:	89 e5                	mov    %esp,%ebp
  80285d:	57                   	push   %edi
  80285e:	56                   	push   %esi
  80285f:	53                   	push   %ebx
  802860:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802866:	b8 00 00 00 00       	mov    $0x0,%eax
  80286b:	be 00 00 00 00       	mov    $0x0,%esi
  802870:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802874:	74 3f                	je     8028b5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802876:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80287c:	8b 55 10             	mov    0x10(%ebp),%edx
  80287f:	29 c2                	sub    %eax,%edx
  802881:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802883:	83 fa 7f             	cmp    $0x7f,%edx
  802886:	76 05                	jbe    80288d <devcons_write+0x33>
  802888:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80288d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802891:	03 45 0c             	add    0xc(%ebp),%eax
  802894:	89 44 24 04          	mov    %eax,0x4(%esp)
  802898:	89 3c 24             	mov    %edi,(%esp)
  80289b:	e8 75 e2 ff ff       	call   800b15 <memmove>
		sys_cputs(buf, m);
  8028a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8028a4:	89 3c 24             	mov    %edi,(%esp)
  8028a7:	e8 a4 e4 ff ff       	call   800d50 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8028ac:	01 de                	add    %ebx,%esi
  8028ae:	89 f0                	mov    %esi,%eax
  8028b0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8028b3:	72 c7                	jb     80287c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8028b5:	89 f0                	mov    %esi,%eax
  8028b7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8028bd:	5b                   	pop    %ebx
  8028be:	5e                   	pop    %esi
  8028bf:	5f                   	pop    %edi
  8028c0:	5d                   	pop    %ebp
  8028c1:	c3                   	ret    

008028c2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8028c2:	55                   	push   %ebp
  8028c3:	89 e5                	mov    %esp,%ebp
  8028c5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8028c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8028ce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8028d5:	00 
  8028d6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028d9:	89 04 24             	mov    %eax,(%esp)
  8028dc:	e8 6f e4 ff ff       	call   800d50 <sys_cputs>
}
  8028e1:	c9                   	leave  
  8028e2:	c3                   	ret    

008028e3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8028e3:	55                   	push   %ebp
  8028e4:	89 e5                	mov    %esp,%ebp
  8028e6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8028e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028ed:	75 07                	jne    8028f6 <devcons_read+0x13>
  8028ef:	eb 28                	jmp    802919 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8028f1:	e8 1f e8 ff ff       	call   801115 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8028f6:	66 90                	xchg   %ax,%ax
  8028f8:	e8 1f e4 ff ff       	call   800d1c <sys_cgetc>
  8028fd:	85 c0                	test   %eax,%eax
  8028ff:	90                   	nop
  802900:	74 ef                	je     8028f1 <devcons_read+0xe>
  802902:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802904:	85 c0                	test   %eax,%eax
  802906:	78 16                	js     80291e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802908:	83 f8 04             	cmp    $0x4,%eax
  80290b:	74 0c                	je     802919 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80290d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802910:	88 10                	mov    %dl,(%eax)
  802912:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802917:	eb 05                	jmp    80291e <devcons_read+0x3b>
  802919:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80291e:	c9                   	leave  
  80291f:	c3                   	ret    

00802920 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
  802923:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802926:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802929:	89 04 24             	mov    %eax,(%esp)
  80292c:	e8 3a ed ff ff       	call   80166b <fd_alloc>
  802931:	85 c0                	test   %eax,%eax
  802933:	78 3f                	js     802974 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802935:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80293c:	00 
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	89 44 24 04          	mov    %eax,0x4(%esp)
  802944:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80294b:	e8 66 e7 ff ff       	call   8010b6 <sys_page_alloc>
  802950:	85 c0                	test   %eax,%eax
  802952:	78 20                	js     802974 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802954:	8b 15 58 70 80 00    	mov    0x807058,%edx
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296c:	89 04 24             	mov    %eax,(%esp)
  80296f:	e8 cc ec ff ff       	call   801640 <fd2num>
}
  802974:	c9                   	leave  
  802975:	c3                   	ret    

00802976 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802976:	55                   	push   %ebp
  802977:	89 e5                	mov    %esp,%ebp
  802979:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80297c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80297f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802983:	8b 45 08             	mov    0x8(%ebp),%eax
  802986:	89 04 24             	mov    %eax,(%esp)
  802989:	e8 4f ed ff ff       	call   8016dd <fd_lookup>
  80298e:	85 c0                	test   %eax,%eax
  802990:	78 11                	js     8029a3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	8b 00                	mov    (%eax),%eax
  802997:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  80299d:	0f 94 c0             	sete   %al
  8029a0:	0f b6 c0             	movzbl %al,%eax
}
  8029a3:	c9                   	leave  
  8029a4:	c3                   	ret    

008029a5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8029a5:	55                   	push   %ebp
  8029a6:	89 e5                	mov    %esp,%ebp
  8029a8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8029ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8029b2:	00 
  8029b3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029c1:	e8 78 ef ff ff       	call   80193e <read>
	if (r < 0)
  8029c6:	85 c0                	test   %eax,%eax
  8029c8:	78 0f                	js     8029d9 <getchar+0x34>
		return r;
	if (r < 1)
  8029ca:	85 c0                	test   %eax,%eax
  8029cc:	7f 07                	jg     8029d5 <getchar+0x30>
  8029ce:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8029d3:	eb 04                	jmp    8029d9 <getchar+0x34>
		return -E_EOF;
	return c;
  8029d5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8029d9:	c9                   	leave  
  8029da:	c3                   	ret    
	...

008029dc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8029dc:	55                   	push   %ebp
  8029dd:	89 e5                	mov    %esp,%ebp
  8029df:	53                   	push   %ebx
  8029e0:	83 ec 14             	sub    $0x14,%esp
  8029e3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    // cprintf("\nhere outside loading creating page\n");

	if (_pgfault_handler == 0) {
  8029e6:	83 3d 7c 70 80 00 00 	cmpl   $0x0,0x80707c
  8029ed:	75 58                	jne    802a47 <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
           //cprintf("\nhere inside loading creating page\n");    
          if(sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  8029ef:	e8 55 e7 ff ff       	call   801149 <sys_getenvid>
  8029f4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8029fb:	00 
  8029fc:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802a03:	ee 
  802a04:	89 04 24             	mov    %eax,(%esp)
  802a07:	e8 aa e6 ff ff       	call   8010b6 <sys_page_alloc>
  802a0c:	85 c0                	test   %eax,%eax
  802a0e:	79 1c                	jns    802a2c <set_pgfault_handler+0x50>
                          panic("Cant allocate Page");                    
  802a10:	c7 44 24 08 ec 30 80 	movl   $0x8030ec,0x8(%esp)
  802a17:	00 
  802a18:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802a1f:	00 
  802a20:	c7 04 24 90 32 80 00 	movl   $0x803290,(%esp)
  802a27:	e8 84 d7 ff ff       	call   8001b0 <_panic>
                _pgfault_handler=handler;
  802a2c:	89 1d 7c 70 80 00    	mov    %ebx,0x80707c
//entry point _pgfault_handler not pointed to by the kernel bcz after the execution is complete control needs to be returned back to execute the rest...so upcall is there         
             sys_env_set_pgfault_upcall(sys_getenvid(),_pgfault_upcall);
  802a32:	e8 12 e7 ff ff       	call   801149 <sys_getenvid>
  802a37:	c7 44 24 04 54 2a 80 	movl   $0x802a54,0x4(%esp)
  802a3e:	00 
  802a3f:	89 04 24             	mov    %eax,(%esp)
  802a42:	e8 99 e4 ff ff       	call   800ee0 <sys_env_set_pgfault_upcall>

	// Save handler pointer for assembly to call.
 //     if(sys_page_alloc(0,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
   //                       panic("Cant allocate Page");

	_pgfault_handler = handler;
  802a47:	89 1d 7c 70 80 00    	mov    %ebx,0x80707c
}
  802a4d:	83 c4 14             	add    $0x14,%esp
  802a50:	5b                   	pop    %ebx
  802a51:	5d                   	pop    %ebp
  802a52:	c3                   	ret    
	...

00802a54 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a54:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a55:	a1 7c 70 80 00       	mov    0x80707c,%eax
	call *%eax
  802a5a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a5c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
           addl $8,%esp
  802a5f:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
            movl  32(%esp),%ebx
  802a62:	8b 5c 24 20          	mov    0x20(%esp),%ebx
            movl  40(%esp),%eax
  802a66:	8b 44 24 28          	mov    0x28(%esp),%eax
            subl  $4,%eax
  802a6a:	83 e8 04             	sub    $0x4,%eax
            movl  %eax,40(%esp)
  802a6d:	89 44 24 28          	mov    %eax,0x28(%esp)
            movl  %ebx,(%eax)
  802a71:	89 18                	mov    %ebx,(%eax)
            popal
  802a73:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
            
            add $4,%esp            
  802a74:	83 c4 04             	add    $0x4,%esp
            popfl
  802a77:	9d                   	popf   
             
           popl %esp
  802a78:	5c                   	pop    %esp
	// LAB 4: Your code here.
           

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
           ret
  802a79:	c3                   	ret    
	...

00802a7c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802a7c:	55                   	push   %ebp
  802a7d:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	89 c2                	mov    %eax,%edx
  802a84:	c1 ea 16             	shr    $0x16,%edx
  802a87:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802a8e:	f6 c2 01             	test   $0x1,%dl
  802a91:	74 26                	je     802ab9 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802a93:	c1 e8 0c             	shr    $0xc,%eax
  802a96:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802a9d:	a8 01                	test   $0x1,%al
  802a9f:	74 18                	je     802ab9 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802aa1:	c1 e8 0c             	shr    $0xc,%eax
  802aa4:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802aa7:	c1 e2 02             	shl    $0x2,%edx
  802aaa:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802aaf:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802ab4:	0f b7 c0             	movzwl %ax,%eax
  802ab7:	eb 05                	jmp    802abe <pageref+0x42>
  802ab9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802abe:	5d                   	pop    %ebp
  802abf:	c3                   	ret    

00802ac0 <__udivdi3>:
  802ac0:	55                   	push   %ebp
  802ac1:	89 e5                	mov    %esp,%ebp
  802ac3:	57                   	push   %edi
  802ac4:	56                   	push   %esi
  802ac5:	83 ec 10             	sub    $0x10,%esp
  802ac8:	8b 45 14             	mov    0x14(%ebp),%eax
  802acb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ace:	8b 75 10             	mov    0x10(%ebp),%esi
  802ad1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802ad4:	85 c0                	test   %eax,%eax
  802ad6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802ad9:	75 35                	jne    802b10 <__udivdi3+0x50>
  802adb:	39 fe                	cmp    %edi,%esi
  802add:	77 61                	ja     802b40 <__udivdi3+0x80>
  802adf:	85 f6                	test   %esi,%esi
  802ae1:	75 0b                	jne    802aee <__udivdi3+0x2e>
  802ae3:	b8 01 00 00 00       	mov    $0x1,%eax
  802ae8:	31 d2                	xor    %edx,%edx
  802aea:	f7 f6                	div    %esi
  802aec:	89 c6                	mov    %eax,%esi
  802aee:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802af1:	31 d2                	xor    %edx,%edx
  802af3:	89 f8                	mov    %edi,%eax
  802af5:	f7 f6                	div    %esi
  802af7:	89 c7                	mov    %eax,%edi
  802af9:	89 c8                	mov    %ecx,%eax
  802afb:	f7 f6                	div    %esi
  802afd:	89 c1                	mov    %eax,%ecx
  802aff:	89 fa                	mov    %edi,%edx
  802b01:	89 c8                	mov    %ecx,%eax
  802b03:	83 c4 10             	add    $0x10,%esp
  802b06:	5e                   	pop    %esi
  802b07:	5f                   	pop    %edi
  802b08:	5d                   	pop    %ebp
  802b09:	c3                   	ret    
  802b0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b10:	39 f8                	cmp    %edi,%eax
  802b12:	77 1c                	ja     802b30 <__udivdi3+0x70>
  802b14:	0f bd d0             	bsr    %eax,%edx
  802b17:	83 f2 1f             	xor    $0x1f,%edx
  802b1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802b1d:	75 39                	jne    802b58 <__udivdi3+0x98>
  802b1f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802b22:	0f 86 a0 00 00 00    	jbe    802bc8 <__udivdi3+0x108>
  802b28:	39 f8                	cmp    %edi,%eax
  802b2a:	0f 82 98 00 00 00    	jb     802bc8 <__udivdi3+0x108>
  802b30:	31 ff                	xor    %edi,%edi
  802b32:	31 c9                	xor    %ecx,%ecx
  802b34:	89 c8                	mov    %ecx,%eax
  802b36:	89 fa                	mov    %edi,%edx
  802b38:	83 c4 10             	add    $0x10,%esp
  802b3b:	5e                   	pop    %esi
  802b3c:	5f                   	pop    %edi
  802b3d:	5d                   	pop    %ebp
  802b3e:	c3                   	ret    
  802b3f:	90                   	nop
  802b40:	89 d1                	mov    %edx,%ecx
  802b42:	89 fa                	mov    %edi,%edx
  802b44:	89 c8                	mov    %ecx,%eax
  802b46:	31 ff                	xor    %edi,%edi
  802b48:	f7 f6                	div    %esi
  802b4a:	89 c1                	mov    %eax,%ecx
  802b4c:	89 fa                	mov    %edi,%edx
  802b4e:	89 c8                	mov    %ecx,%eax
  802b50:	83 c4 10             	add    $0x10,%esp
  802b53:	5e                   	pop    %esi
  802b54:	5f                   	pop    %edi
  802b55:	5d                   	pop    %ebp
  802b56:	c3                   	ret    
  802b57:	90                   	nop
  802b58:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802b5c:	89 f2                	mov    %esi,%edx
  802b5e:	d3 e0                	shl    %cl,%eax
  802b60:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802b63:	b8 20 00 00 00       	mov    $0x20,%eax
  802b68:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802b6b:	89 c1                	mov    %eax,%ecx
  802b6d:	d3 ea                	shr    %cl,%edx
  802b6f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802b73:	0b 55 ec             	or     -0x14(%ebp),%edx
  802b76:	d3 e6                	shl    %cl,%esi
  802b78:	89 c1                	mov    %eax,%ecx
  802b7a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802b7d:	89 fe                	mov    %edi,%esi
  802b7f:	d3 ee                	shr    %cl,%esi
  802b81:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802b85:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802b88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802b8b:	d3 e7                	shl    %cl,%edi
  802b8d:	89 c1                	mov    %eax,%ecx
  802b8f:	d3 ea                	shr    %cl,%edx
  802b91:	09 d7                	or     %edx,%edi
  802b93:	89 f2                	mov    %esi,%edx
  802b95:	89 f8                	mov    %edi,%eax
  802b97:	f7 75 ec             	divl   -0x14(%ebp)
  802b9a:	89 d6                	mov    %edx,%esi
  802b9c:	89 c7                	mov    %eax,%edi
  802b9e:	f7 65 e8             	mull   -0x18(%ebp)
  802ba1:	39 d6                	cmp    %edx,%esi
  802ba3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ba6:	72 30                	jb     802bd8 <__udivdi3+0x118>
  802ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802bab:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802baf:	d3 e2                	shl    %cl,%edx
  802bb1:	39 c2                	cmp    %eax,%edx
  802bb3:	73 05                	jae    802bba <__udivdi3+0xfa>
  802bb5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802bb8:	74 1e                	je     802bd8 <__udivdi3+0x118>
  802bba:	89 f9                	mov    %edi,%ecx
  802bbc:	31 ff                	xor    %edi,%edi
  802bbe:	e9 71 ff ff ff       	jmp    802b34 <__udivdi3+0x74>
  802bc3:	90                   	nop
  802bc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bc8:	31 ff                	xor    %edi,%edi
  802bca:	b9 01 00 00 00       	mov    $0x1,%ecx
  802bcf:	e9 60 ff ff ff       	jmp    802b34 <__udivdi3+0x74>
  802bd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bd8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802bdb:	31 ff                	xor    %edi,%edi
  802bdd:	89 c8                	mov    %ecx,%eax
  802bdf:	89 fa                	mov    %edi,%edx
  802be1:	83 c4 10             	add    $0x10,%esp
  802be4:	5e                   	pop    %esi
  802be5:	5f                   	pop    %edi
  802be6:	5d                   	pop    %ebp
  802be7:	c3                   	ret    
	...

00802bf0 <__umoddi3>:
  802bf0:	55                   	push   %ebp
  802bf1:	89 e5                	mov    %esp,%ebp
  802bf3:	57                   	push   %edi
  802bf4:	56                   	push   %esi
  802bf5:	83 ec 20             	sub    $0x20,%esp
  802bf8:	8b 55 14             	mov    0x14(%ebp),%edx
  802bfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802bfe:	8b 7d 10             	mov    0x10(%ebp),%edi
  802c01:	8b 75 0c             	mov    0xc(%ebp),%esi
  802c04:	85 d2                	test   %edx,%edx
  802c06:	89 c8                	mov    %ecx,%eax
  802c08:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802c0b:	75 13                	jne    802c20 <__umoddi3+0x30>
  802c0d:	39 f7                	cmp    %esi,%edi
  802c0f:	76 3f                	jbe    802c50 <__umoddi3+0x60>
  802c11:	89 f2                	mov    %esi,%edx
  802c13:	f7 f7                	div    %edi
  802c15:	89 d0                	mov    %edx,%eax
  802c17:	31 d2                	xor    %edx,%edx
  802c19:	83 c4 20             	add    $0x20,%esp
  802c1c:	5e                   	pop    %esi
  802c1d:	5f                   	pop    %edi
  802c1e:	5d                   	pop    %ebp
  802c1f:	c3                   	ret    
  802c20:	39 f2                	cmp    %esi,%edx
  802c22:	77 4c                	ja     802c70 <__umoddi3+0x80>
  802c24:	0f bd ca             	bsr    %edx,%ecx
  802c27:	83 f1 1f             	xor    $0x1f,%ecx
  802c2a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802c2d:	75 51                	jne    802c80 <__umoddi3+0x90>
  802c2f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802c32:	0f 87 e0 00 00 00    	ja     802d18 <__umoddi3+0x128>
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	29 f8                	sub    %edi,%eax
  802c3d:	19 d6                	sbb    %edx,%esi
  802c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c45:	89 f2                	mov    %esi,%edx
  802c47:	83 c4 20             	add    $0x20,%esp
  802c4a:	5e                   	pop    %esi
  802c4b:	5f                   	pop    %edi
  802c4c:	5d                   	pop    %ebp
  802c4d:	c3                   	ret    
  802c4e:	66 90                	xchg   %ax,%ax
  802c50:	85 ff                	test   %edi,%edi
  802c52:	75 0b                	jne    802c5f <__umoddi3+0x6f>
  802c54:	b8 01 00 00 00       	mov    $0x1,%eax
  802c59:	31 d2                	xor    %edx,%edx
  802c5b:	f7 f7                	div    %edi
  802c5d:	89 c7                	mov    %eax,%edi
  802c5f:	89 f0                	mov    %esi,%eax
  802c61:	31 d2                	xor    %edx,%edx
  802c63:	f7 f7                	div    %edi
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	f7 f7                	div    %edi
  802c6a:	eb a9                	jmp    802c15 <__umoddi3+0x25>
  802c6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c70:	89 c8                	mov    %ecx,%eax
  802c72:	89 f2                	mov    %esi,%edx
  802c74:	83 c4 20             	add    $0x20,%esp
  802c77:	5e                   	pop    %esi
  802c78:	5f                   	pop    %edi
  802c79:	5d                   	pop    %ebp
  802c7a:	c3                   	ret    
  802c7b:	90                   	nop
  802c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c80:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c84:	d3 e2                	shl    %cl,%edx
  802c86:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802c89:	ba 20 00 00 00       	mov    $0x20,%edx
  802c8e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802c91:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802c94:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802c98:	89 fa                	mov    %edi,%edx
  802c9a:	d3 ea                	shr    %cl,%edx
  802c9c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ca0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802ca3:	d3 e7                	shl    %cl,%edi
  802ca5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ca9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802cac:	89 f2                	mov    %esi,%edx
  802cae:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802cb1:	89 c7                	mov    %eax,%edi
  802cb3:	d3 ea                	shr    %cl,%edx
  802cb5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802cb9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802cbc:	89 c2                	mov    %eax,%edx
  802cbe:	d3 e6                	shl    %cl,%esi
  802cc0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802cc4:	d3 ea                	shr    %cl,%edx
  802cc6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802cca:	09 d6                	or     %edx,%esi
  802ccc:	89 f0                	mov    %esi,%eax
  802cce:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802cd1:	d3 e7                	shl    %cl,%edi
  802cd3:	89 f2                	mov    %esi,%edx
  802cd5:	f7 75 f4             	divl   -0xc(%ebp)
  802cd8:	89 d6                	mov    %edx,%esi
  802cda:	f7 65 e8             	mull   -0x18(%ebp)
  802cdd:	39 d6                	cmp    %edx,%esi
  802cdf:	72 2b                	jb     802d0c <__umoddi3+0x11c>
  802ce1:	39 c7                	cmp    %eax,%edi
  802ce3:	72 23                	jb     802d08 <__umoddi3+0x118>
  802ce5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ce9:	29 c7                	sub    %eax,%edi
  802ceb:	19 d6                	sbb    %edx,%esi
  802ced:	89 f0                	mov    %esi,%eax
  802cef:	89 f2                	mov    %esi,%edx
  802cf1:	d3 ef                	shr    %cl,%edi
  802cf3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802cf7:	d3 e0                	shl    %cl,%eax
  802cf9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802cfd:	09 f8                	or     %edi,%eax
  802cff:	d3 ea                	shr    %cl,%edx
  802d01:	83 c4 20             	add    $0x20,%esp
  802d04:	5e                   	pop    %esi
  802d05:	5f                   	pop    %edi
  802d06:	5d                   	pop    %ebp
  802d07:	c3                   	ret    
  802d08:	39 d6                	cmp    %edx,%esi
  802d0a:	75 d9                	jne    802ce5 <__umoddi3+0xf5>
  802d0c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802d0f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802d12:	eb d1                	jmp    802ce5 <__umoddi3+0xf5>
  802d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d18:	39 f2                	cmp    %esi,%edx
  802d1a:	0f 82 18 ff ff ff    	jb     802c38 <__umoddi3+0x48>
  802d20:	e9 1d ff ff ff       	jmp    802c42 <__umoddi3+0x52>
