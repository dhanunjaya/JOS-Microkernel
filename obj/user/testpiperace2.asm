
obj/user/testpiperace2:     file format elf32-i386


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
  80002c:	e8 bb 01 00 00       	call   8001ec <libmain>
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
	int p[2], r, i;
	struct Fd *fd;
	volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003d:	c7 04 24 e0 2d 80 00 	movl   $0x802de0,(%esp)
  800044:	e8 d4 02 00 00       	call   80031d <cprintf>
	if ((r = pipe(p)) < 0)
  800049:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80004c:	89 04 24             	mov    %eax,(%esp)
  80004f:	e8 25 26 00 00       	call   802679 <pipe>
  800054:	85 c0                	test   %eax,%eax
  800056:	79 20                	jns    800078 <umain+0x44>
		panic("pipe: %e", r);
  800058:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005c:	c7 44 24 08 2e 2e 80 	movl   $0x802e2e,0x8(%esp)
  800063:	00 
  800064:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  80006b:	00 
  80006c:	c7 04 24 37 2e 80 00 	movl   $0x802e37,(%esp)
  800073:	e8 e0 01 00 00       	call   800258 <_panic>
	if ((r = fork()) < 0)
  800078:	e8 5a 13 00 00       	call   8013d7 <fork>
  80007d:	89 c7                	mov    %eax,%edi
  80007f:	85 c0                	test   %eax,%eax
  800081:	79 20                	jns    8000a3 <umain+0x6f>
		panic("fork: %e", r);
  800083:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800087:	c7 44 24 08 43 32 80 	movl   $0x803243,0x8(%esp)
  80008e:	00 
  80008f:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800096:	00 
  800097:	c7 04 24 37 2e 80 00 	movl   $0x802e37,(%esp)
  80009e:	e8 b5 01 00 00       	call   800258 <_panic>
	if (r == 0) {
  8000a3:	85 c0                	test   %eax,%eax
  8000a5:	75 75                	jne    80011c <umain+0xe8>
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
  8000a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000aa:	89 04 24             	mov    %eax,(%esp)
  8000ad:	e8 bc 19 00 00       	call   801a6e <close>
  8000b2:	bb 00 00 00 00       	mov    $0x0,%ebx
		for (i = 0; i < 200; i++) {
			if (i % 10 == 0)
  8000b7:	be 67 66 66 66       	mov    $0x66666667,%esi
  8000bc:	89 d8                	mov    %ebx,%eax
  8000be:	f7 ee                	imul   %esi
  8000c0:	c1 fa 02             	sar    $0x2,%edx
  8000c3:	89 d8                	mov    %ebx,%eax
  8000c5:	c1 f8 1f             	sar    $0x1f,%eax
  8000c8:	29 c2                	sub    %eax,%edx
  8000ca:	8d 04 92             	lea    (%edx,%edx,4),%eax
  8000cd:	01 c0                	add    %eax,%eax
  8000cf:	39 c3                	cmp    %eax,%ebx
  8000d1:	75 10                	jne    8000e3 <umain+0xaf>
				cprintf("%d.", i);
  8000d3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d7:	c7 04 24 4c 2e 80 00 	movl   $0x802e4c,(%esp)
  8000de:	e8 3a 02 00 00       	call   80031d <cprintf>
			// dup, then close.  yield so that other guy will
			// see us while we're between them.
			dup(p[0], 10);
  8000e3:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  8000ea:	00 
  8000eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000ee:	89 04 24             	mov    %eax,(%esp)
  8000f1:	e8 17 1a 00 00       	call   801b0d <dup>
			sys_yield();
  8000f6:	e8 ba 10 00 00       	call   8011b5 <sys_yield>
			close(10);
  8000fb:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800102:	e8 67 19 00 00       	call   801a6e <close>
			sys_yield();
  800107:	e8 a9 10 00 00       	call   8011b5 <sys_yield>
	if (r == 0) {
		// child just dups and closes repeatedly,
		// yielding so the parent can see
		// the fd state between the two.
		close(p[1]);
		for (i = 0; i < 200; i++) {
  80010c:	83 c3 01             	add    $0x1,%ebx
  80010f:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800115:	75 a5                	jne    8000bc <umain+0x88>
			dup(p[0], 10);
			sys_yield();
			close(10);
			sys_yield();
		}
		exit();
  800117:	e8 20 01 00 00       	call   80023c <exit>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  80011c:	89 fb                	mov    %edi,%ebx
  80011e:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  800124:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  800127:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (kid->env_status == ENV_RUNNABLE)
  80012d:	eb 28                	jmp    800157 <umain+0x123>
		if (pipeisclosed(p[0]) != 0) {
  80012f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800132:	89 04 24             	mov    %eax,(%esp)
  800135:	e8 0c 25 00 00       	call   802646 <pipeisclosed>
  80013a:	85 c0                	test   %eax,%eax
  80013c:	74 19                	je     800157 <umain+0x123>
			cprintf("\nRACE: pipe appears closed\n");
  80013e:	c7 04 24 50 2e 80 00 	movl   $0x802e50,(%esp)
  800145:	e8 d3 01 00 00       	call   80031d <cprintf>
			sys_env_destroy(r);
  80014a:	89 3c 24             	mov    %edi,(%esp)
  80014d:	e8 cb 10 00 00       	call   80121d <sys_env_destroy>
			exit();
  800152:	e8 e5 00 00 00       	call   80023c <exit>
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
	while (kid->env_status == ENV_RUNNABLE)
  800157:	8b 43 54             	mov    0x54(%ebx),%eax
  80015a:	83 f8 01             	cmp    $0x1,%eax
  80015d:	74 d0                	je     80012f <umain+0xfb>
		if (pipeisclosed(p[0]) != 0) {
			cprintf("\nRACE: pipe appears closed\n");
			sys_env_destroy(r);
			exit();
		}
	cprintf("child done with loop\n");
  80015f:	c7 04 24 6c 2e 80 00 	movl   $0x802e6c,(%esp)
  800166:	e8 b2 01 00 00       	call   80031d <cprintf>
	if (pipeisclosed(p[0]))
  80016b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016e:	89 04 24             	mov    %eax,(%esp)
  800171:	e8 d0 24 00 00       	call   802646 <pipeisclosed>
  800176:	85 c0                	test   %eax,%eax
  800178:	74 1c                	je     800196 <umain+0x162>
		panic("somehow the other end of p[0] got closed!");
  80017a:	c7 44 24 08 04 2e 80 	movl   $0x802e04,0x8(%esp)
  800181:	00 
  800182:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
  800189:	00 
  80018a:	c7 04 24 37 2e 80 00 	movl   $0x802e37,(%esp)
  800191:	e8 c2 00 00 00       	call   800258 <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800196:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800199:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a0:	89 04 24             	mov    %eax,(%esp)
  8001a3:	e8 05 15 00 00       	call   8016ad <fd_lookup>
  8001a8:	85 c0                	test   %eax,%eax
  8001aa:	79 20                	jns    8001cc <umain+0x198>
		panic("cannot look up p[0]: %e", r);
  8001ac:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b0:	c7 44 24 08 82 2e 80 	movl   $0x802e82,0x8(%esp)
  8001b7:	00 
  8001b8:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
  8001bf:	00 
  8001c0:	c7 04 24 37 2e 80 00 	movl   $0x802e37,(%esp)
  8001c7:	e8 8c 00 00 00       	call   800258 <_panic>
	(void) fd2data(fd);
  8001cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001cf:	89 04 24             	mov    %eax,(%esp)
  8001d2:	e8 49 14 00 00       	call   801620 <fd2data>
	cprintf("race didn't happen\n");
  8001d7:	c7 04 24 9a 2e 80 00 	movl   $0x802e9a,(%esp)
  8001de:	e8 3a 01 00 00       	call   80031d <cprintf>
}
  8001e3:	83 c4 2c             	add    $0x2c,%esp
  8001e6:	5b                   	pop    %ebx
  8001e7:	5e                   	pop    %esi
  8001e8:	5f                   	pop    %edi
  8001e9:	5d                   	pop    %ebp
  8001ea:	c3                   	ret    
	...

008001ec <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ec:	55                   	push   %ebp
  8001ed:	89 e5                	mov    %esp,%ebp
  8001ef:	83 ec 18             	sub    $0x18,%esp
  8001f2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001f5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8001fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  8001fe:	e8 e6 0f 00 00       	call   8011e9 <sys_getenvid>
  800203:	25 ff 03 00 00       	and    $0x3ff,%eax
  800208:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80020b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800210:	a3 74 70 80 00       	mov    %eax,0x807074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800215:	85 f6                	test   %esi,%esi
  800217:	7e 07                	jle    800220 <libmain+0x34>
		binaryname = argv[0];
  800219:	8b 03                	mov    (%ebx),%eax
  80021b:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  800220:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800224:	89 34 24             	mov    %esi,(%esp)
  800227:	e8 08 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80022c:	e8 0b 00 00 00       	call   80023c <exit>
}
  800231:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800234:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800237:	89 ec                	mov    %ebp,%esp
  800239:	5d                   	pop    %ebp
  80023a:	c3                   	ret    
	...

0080023c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800242:	e8 a4 18 00 00       	call   801aeb <close_all>
	sys_env_destroy(0);
  800247:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80024e:	e8 ca 0f 00 00       	call   80121d <sys_env_destroy>
}
  800253:	c9                   	leave  
  800254:	c3                   	ret    
  800255:	00 00                	add    %al,(%eax)
	...

00800258 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800258:	55                   	push   %ebp
  800259:	89 e5                	mov    %esp,%ebp
  80025b:	53                   	push   %ebx
  80025c:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  80025f:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800262:	a1 78 70 80 00       	mov    0x807078,%eax
  800267:	85 c0                	test   %eax,%eax
  800269:	74 10                	je     80027b <_panic+0x23>
		cprintf("%s: ", argv0);
  80026b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80026f:	c7 04 24 c5 2e 80 00 	movl   $0x802ec5,(%esp)
  800276:	e8 a2 00 00 00       	call   80031d <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80027b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80027e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800282:	8b 45 08             	mov    0x8(%ebp),%eax
  800285:	89 44 24 08          	mov    %eax,0x8(%esp)
  800289:	a1 00 70 80 00       	mov    0x807000,%eax
  80028e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800292:	c7 04 24 ca 2e 80 00 	movl   $0x802eca,(%esp)
  800299:	e8 7f 00 00 00       	call   80031d <cprintf>
	vcprintf(fmt, ap);
  80029e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a5:	89 04 24             	mov    %eax,(%esp)
  8002a8:	e8 0f 00 00 00       	call   8002bc <vcprintf>
	cprintf("\n");
  8002ad:	c7 04 24 c1 33 80 00 	movl   $0x8033c1,(%esp)
  8002b4:	e8 64 00 00 00       	call   80031d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002b9:	cc                   	int3   
  8002ba:	eb fd                	jmp    8002b9 <_panic+0x61>

008002bc <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002c5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002cc:	00 00 00 
	b.cnt = 0;
  8002cf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002d6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002e7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f1:	c7 04 24 37 03 80 00 	movl   $0x800337,(%esp)
  8002f8:	e8 d0 01 00 00       	call   8004cd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002fd:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800303:	89 44 24 04          	mov    %eax,0x4(%esp)
  800307:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80030d:	89 04 24             	mov    %eax,(%esp)
  800310:	e8 db 0a 00 00       	call   800df0 <sys_cputs>

	return b.cnt;
}
  800315:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80031b:	c9                   	leave  
  80031c:	c3                   	ret    

0080031d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80031d:	55                   	push   %ebp
  80031e:	89 e5                	mov    %esp,%ebp
  800320:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800323:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800326:	89 44 24 04          	mov    %eax,0x4(%esp)
  80032a:	8b 45 08             	mov    0x8(%ebp),%eax
  80032d:	89 04 24             	mov    %eax,(%esp)
  800330:	e8 87 ff ff ff       	call   8002bc <vcprintf>
	va_end(ap);

	return cnt;
}
  800335:	c9                   	leave  
  800336:	c3                   	ret    

00800337 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800337:	55                   	push   %ebp
  800338:	89 e5                	mov    %esp,%ebp
  80033a:	53                   	push   %ebx
  80033b:	83 ec 14             	sub    $0x14,%esp
  80033e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800341:	8b 03                	mov    (%ebx),%eax
  800343:	8b 55 08             	mov    0x8(%ebp),%edx
  800346:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80034a:	83 c0 01             	add    $0x1,%eax
  80034d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80034f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800354:	75 19                	jne    80036f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800356:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80035d:	00 
  80035e:	8d 43 08             	lea    0x8(%ebx),%eax
  800361:	89 04 24             	mov    %eax,(%esp)
  800364:	e8 87 0a 00 00       	call   800df0 <sys_cputs>
		b->idx = 0;
  800369:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80036f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800373:	83 c4 14             	add    $0x14,%esp
  800376:	5b                   	pop    %ebx
  800377:	5d                   	pop    %ebp
  800378:	c3                   	ret    
  800379:	00 00                	add    %al,(%eax)
  80037b:	00 00                	add    %al,(%eax)
  80037d:	00 00                	add    %al,(%eax)
	...

00800380 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800380:	55                   	push   %ebp
  800381:	89 e5                	mov    %esp,%ebp
  800383:	57                   	push   %edi
  800384:	56                   	push   %esi
  800385:	53                   	push   %ebx
  800386:	83 ec 4c             	sub    $0x4c,%esp
  800389:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80038c:	89 d6                	mov    %edx,%esi
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800394:	8b 55 0c             	mov    0xc(%ebp),%edx
  800397:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80039a:	8b 45 10             	mov    0x10(%ebp),%eax
  80039d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003a0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003ab:	39 d1                	cmp    %edx,%ecx
  8003ad:	72 15                	jb     8003c4 <printnum+0x44>
  8003af:	77 07                	ja     8003b8 <printnum+0x38>
  8003b1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003b4:	39 d0                	cmp    %edx,%eax
  8003b6:	76 0c                	jbe    8003c4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003b8:	83 eb 01             	sub    $0x1,%ebx
  8003bb:	85 db                	test   %ebx,%ebx
  8003bd:	8d 76 00             	lea    0x0(%esi),%esi
  8003c0:	7f 61                	jg     800423 <printnum+0xa3>
  8003c2:	eb 70                	jmp    800434 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003c4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8003c8:	83 eb 01             	sub    $0x1,%ebx
  8003cb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003d3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8003d7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8003db:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8003de:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8003e1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8003e4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003ef:	00 
  8003f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003f3:	89 04 24             	mov    %eax,(%esp)
  8003f6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003f9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003fd:	e8 5e 27 00 00       	call   802b60 <__udivdi3>
  800402:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800405:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800408:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80040c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800410:	89 04 24             	mov    %eax,(%esp)
  800413:	89 54 24 04          	mov    %edx,0x4(%esp)
  800417:	89 f2                	mov    %esi,%edx
  800419:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041c:	e8 5f ff ff ff       	call   800380 <printnum>
  800421:	eb 11                	jmp    800434 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800423:	89 74 24 04          	mov    %esi,0x4(%esp)
  800427:	89 3c 24             	mov    %edi,(%esp)
  80042a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80042d:	83 eb 01             	sub    $0x1,%ebx
  800430:	85 db                	test   %ebx,%ebx
  800432:	7f ef                	jg     800423 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800434:	89 74 24 04          	mov    %esi,0x4(%esp)
  800438:	8b 74 24 04          	mov    0x4(%esp),%esi
  80043c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80043f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800443:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80044a:	00 
  80044b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80044e:	89 14 24             	mov    %edx,(%esp)
  800451:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800454:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800458:	e8 33 28 00 00       	call   802c90 <__umoddi3>
  80045d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800461:	0f be 80 e6 2e 80 00 	movsbl 0x802ee6(%eax),%eax
  800468:	89 04 24             	mov    %eax,(%esp)
  80046b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80046e:	83 c4 4c             	add    $0x4c,%esp
  800471:	5b                   	pop    %ebx
  800472:	5e                   	pop    %esi
  800473:	5f                   	pop    %edi
  800474:	5d                   	pop    %ebp
  800475:	c3                   	ret    

00800476 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800476:	55                   	push   %ebp
  800477:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800479:	83 fa 01             	cmp    $0x1,%edx
  80047c:	7e 0e                	jle    80048c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80047e:	8b 10                	mov    (%eax),%edx
  800480:	8d 4a 08             	lea    0x8(%edx),%ecx
  800483:	89 08                	mov    %ecx,(%eax)
  800485:	8b 02                	mov    (%edx),%eax
  800487:	8b 52 04             	mov    0x4(%edx),%edx
  80048a:	eb 22                	jmp    8004ae <getuint+0x38>
	else if (lflag)
  80048c:	85 d2                	test   %edx,%edx
  80048e:	74 10                	je     8004a0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800490:	8b 10                	mov    (%eax),%edx
  800492:	8d 4a 04             	lea    0x4(%edx),%ecx
  800495:	89 08                	mov    %ecx,(%eax)
  800497:	8b 02                	mov    (%edx),%eax
  800499:	ba 00 00 00 00       	mov    $0x0,%edx
  80049e:	eb 0e                	jmp    8004ae <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004a0:	8b 10                	mov    (%eax),%edx
  8004a2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004a5:	89 08                	mov    %ecx,(%eax)
  8004a7:	8b 02                	mov    (%edx),%eax
  8004a9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004ae:	5d                   	pop    %ebp
  8004af:	c3                   	ret    

008004b0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004b6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ba:	8b 10                	mov    (%eax),%edx
  8004bc:	3b 50 04             	cmp    0x4(%eax),%edx
  8004bf:	73 0a                	jae    8004cb <sprintputch+0x1b>
		*b->buf++ = ch;
  8004c1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004c4:	88 0a                	mov    %cl,(%edx)
  8004c6:	83 c2 01             	add    $0x1,%edx
  8004c9:	89 10                	mov    %edx,(%eax)
}
  8004cb:	5d                   	pop    %ebp
  8004cc:	c3                   	ret    

008004cd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004cd:	55                   	push   %ebp
  8004ce:	89 e5                	mov    %esp,%ebp
  8004d0:	57                   	push   %edi
  8004d1:	56                   	push   %esi
  8004d2:	53                   	push   %ebx
  8004d3:	83 ec 5c             	sub    $0x5c,%esp
  8004d6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8004d9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004dc:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004df:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8004e6:	eb 11                	jmp    8004f9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004e8:	85 c0                	test   %eax,%eax
  8004ea:	0f 84 09 04 00 00    	je     8008f9 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  8004f0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004f4:	89 04 24             	mov    %eax,(%esp)
  8004f7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004f9:	0f b6 03             	movzbl (%ebx),%eax
  8004fc:	83 c3 01             	add    $0x1,%ebx
  8004ff:	83 f8 25             	cmp    $0x25,%eax
  800502:	75 e4                	jne    8004e8 <vprintfmt+0x1b>
  800504:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800508:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80050f:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800516:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80051d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800522:	eb 06                	jmp    80052a <vprintfmt+0x5d>
  800524:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800528:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80052a:	0f b6 13             	movzbl (%ebx),%edx
  80052d:	0f b6 c2             	movzbl %dl,%eax
  800530:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800533:	8d 43 01             	lea    0x1(%ebx),%eax
  800536:	83 ea 23             	sub    $0x23,%edx
  800539:	80 fa 55             	cmp    $0x55,%dl
  80053c:	0f 87 9a 03 00 00    	ja     8008dc <vprintfmt+0x40f>
  800542:	0f b6 d2             	movzbl %dl,%edx
  800545:	ff 24 95 20 30 80 00 	jmp    *0x803020(,%edx,4)
  80054c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800550:	eb d6                	jmp    800528 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800552:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800555:	83 ea 30             	sub    $0x30,%edx
  800558:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  80055b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80055e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800561:	83 fb 09             	cmp    $0x9,%ebx
  800564:	77 4c                	ja     8005b2 <vprintfmt+0xe5>
  800566:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800569:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80056c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80056f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800572:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800576:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800579:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80057c:	83 fb 09             	cmp    $0x9,%ebx
  80057f:	76 eb                	jbe    80056c <vprintfmt+0x9f>
  800581:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800584:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800587:	eb 29                	jmp    8005b2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800589:	8b 55 14             	mov    0x14(%ebp),%edx
  80058c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80058f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800592:	8b 12                	mov    (%edx),%edx
  800594:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  800597:	eb 19                	jmp    8005b2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800599:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80059c:	c1 fa 1f             	sar    $0x1f,%edx
  80059f:	f7 d2                	not    %edx
  8005a1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8005a4:	eb 82                	jmp    800528 <vprintfmt+0x5b>
  8005a6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8005ad:	e9 76 ff ff ff       	jmp    800528 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8005b2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005b6:	0f 89 6c ff ff ff    	jns    800528 <vprintfmt+0x5b>
  8005bc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8005bf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005c2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8005c5:	89 55 cc             	mov    %edx,-0x34(%ebp)
  8005c8:	e9 5b ff ff ff       	jmp    800528 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005cd:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8005d0:	e9 53 ff ff ff       	jmp    800528 <vprintfmt+0x5b>
  8005d5:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005db:	8d 50 04             	lea    0x4(%eax),%edx
  8005de:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005e5:	8b 00                	mov    (%eax),%eax
  8005e7:	89 04 24             	mov    %eax,(%esp)
  8005ea:	ff d7                	call   *%edi
  8005ec:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8005ef:	e9 05 ff ff ff       	jmp    8004f9 <vprintfmt+0x2c>
  8005f4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8d 50 04             	lea    0x4(%eax),%edx
  8005fd:	89 55 14             	mov    %edx,0x14(%ebp)
  800600:	8b 00                	mov    (%eax),%eax
  800602:	89 c2                	mov    %eax,%edx
  800604:	c1 fa 1f             	sar    $0x1f,%edx
  800607:	31 d0                	xor    %edx,%eax
  800609:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80060b:	83 f8 0f             	cmp    $0xf,%eax
  80060e:	7f 0b                	jg     80061b <vprintfmt+0x14e>
  800610:	8b 14 85 80 31 80 00 	mov    0x803180(,%eax,4),%edx
  800617:	85 d2                	test   %edx,%edx
  800619:	75 20                	jne    80063b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80061b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80061f:	c7 44 24 08 f7 2e 80 	movl   $0x802ef7,0x8(%esp)
  800626:	00 
  800627:	89 74 24 04          	mov    %esi,0x4(%esp)
  80062b:	89 3c 24             	mov    %edi,(%esp)
  80062e:	e8 4e 03 00 00       	call   800981 <printfmt>
  800633:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800636:	e9 be fe ff ff       	jmp    8004f9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80063b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80063f:	c7 44 24 08 85 33 80 	movl   $0x803385,0x8(%esp)
  800646:	00 
  800647:	89 74 24 04          	mov    %esi,0x4(%esp)
  80064b:	89 3c 24             	mov    %edi,(%esp)
  80064e:	e8 2e 03 00 00       	call   800981 <printfmt>
  800653:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800656:	e9 9e fe ff ff       	jmp    8004f9 <vprintfmt+0x2c>
  80065b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80065e:	89 c3                	mov    %eax,%ebx
  800660:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800663:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800666:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800669:	8b 45 14             	mov    0x14(%ebp),%eax
  80066c:	8d 50 04             	lea    0x4(%eax),%edx
  80066f:	89 55 14             	mov    %edx,0x14(%ebp)
  800672:	8b 00                	mov    (%eax),%eax
  800674:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800677:	85 c0                	test   %eax,%eax
  800679:	75 07                	jne    800682 <vprintfmt+0x1b5>
  80067b:	c7 45 c4 00 2f 80 00 	movl   $0x802f00,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800682:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  800686:	7e 06                	jle    80068e <vprintfmt+0x1c1>
  800688:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80068c:	75 13                	jne    8006a1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80068e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800691:	0f be 02             	movsbl (%edx),%eax
  800694:	85 c0                	test   %eax,%eax
  800696:	0f 85 99 00 00 00    	jne    800735 <vprintfmt+0x268>
  80069c:	e9 86 00 00 00       	jmp    800727 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006a5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8006a8:	89 0c 24             	mov    %ecx,(%esp)
  8006ab:	e8 1b 03 00 00       	call   8009cb <strnlen>
  8006b0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8006b3:	29 c2                	sub    %eax,%edx
  8006b5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006b8:	85 d2                	test   %edx,%edx
  8006ba:	7e d2                	jle    80068e <vprintfmt+0x1c1>
					putch(padc, putdat);
  8006bc:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  8006c0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006c3:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  8006c6:	89 d3                	mov    %edx,%ebx
  8006c8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006cf:	89 04 24             	mov    %eax,(%esp)
  8006d2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d4:	83 eb 01             	sub    $0x1,%ebx
  8006d7:	85 db                	test   %ebx,%ebx
  8006d9:	7f ed                	jg     8006c8 <vprintfmt+0x1fb>
  8006db:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8006de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8006e5:	eb a7                	jmp    80068e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006e7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006eb:	74 18                	je     800705 <vprintfmt+0x238>
  8006ed:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006f0:	83 fa 5e             	cmp    $0x5e,%edx
  8006f3:	76 10                	jbe    800705 <vprintfmt+0x238>
					putch('?', putdat);
  8006f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006f9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800700:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800703:	eb 0a                	jmp    80070f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800705:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800709:	89 04 24             	mov    %eax,(%esp)
  80070c:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80070f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800713:	0f be 03             	movsbl (%ebx),%eax
  800716:	85 c0                	test   %eax,%eax
  800718:	74 05                	je     80071f <vprintfmt+0x252>
  80071a:	83 c3 01             	add    $0x1,%ebx
  80071d:	eb 29                	jmp    800748 <vprintfmt+0x27b>
  80071f:	89 fe                	mov    %edi,%esi
  800721:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800724:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800727:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80072b:	7f 2e                	jg     80075b <vprintfmt+0x28e>
  80072d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800730:	e9 c4 fd ff ff       	jmp    8004f9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800735:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800738:	83 c2 01             	add    $0x1,%edx
  80073b:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80073e:	89 f7                	mov    %esi,%edi
  800740:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800743:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  800746:	89 d3                	mov    %edx,%ebx
  800748:	85 f6                	test   %esi,%esi
  80074a:	78 9b                	js     8006e7 <vprintfmt+0x21a>
  80074c:	83 ee 01             	sub    $0x1,%esi
  80074f:	79 96                	jns    8006e7 <vprintfmt+0x21a>
  800751:	89 fe                	mov    %edi,%esi
  800753:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800756:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800759:	eb cc                	jmp    800727 <vprintfmt+0x25a>
  80075b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  80075e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800761:	89 74 24 04          	mov    %esi,0x4(%esp)
  800765:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80076c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80076e:	83 eb 01             	sub    $0x1,%ebx
  800771:	85 db                	test   %ebx,%ebx
  800773:	7f ec                	jg     800761 <vprintfmt+0x294>
  800775:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800778:	e9 7c fd ff ff       	jmp    8004f9 <vprintfmt+0x2c>
  80077d:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800780:	83 f9 01             	cmp    $0x1,%ecx
  800783:	7e 16                	jle    80079b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800785:	8b 45 14             	mov    0x14(%ebp),%eax
  800788:	8d 50 08             	lea    0x8(%eax),%edx
  80078b:	89 55 14             	mov    %edx,0x14(%ebp)
  80078e:	8b 10                	mov    (%eax),%edx
  800790:	8b 48 04             	mov    0x4(%eax),%ecx
  800793:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800796:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800799:	eb 32                	jmp    8007cd <vprintfmt+0x300>
	else if (lflag)
  80079b:	85 c9                	test   %ecx,%ecx
  80079d:	74 18                	je     8007b7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80079f:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a2:	8d 50 04             	lea    0x4(%eax),%edx
  8007a5:	89 55 14             	mov    %edx,0x14(%ebp)
  8007a8:	8b 00                	mov    (%eax),%eax
  8007aa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007ad:	89 c1                	mov    %eax,%ecx
  8007af:	c1 f9 1f             	sar    $0x1f,%ecx
  8007b2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007b5:	eb 16                	jmp    8007cd <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8007b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ba:	8d 50 04             	lea    0x4(%eax),%edx
  8007bd:	89 55 14             	mov    %edx,0x14(%ebp)
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007c5:	89 c2                	mov    %eax,%edx
  8007c7:	c1 fa 1f             	sar    $0x1f,%edx
  8007ca:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007cd:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8007d0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007d3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007d8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007dc:	0f 89 b8 00 00 00    	jns    80089a <vprintfmt+0x3cd>
				putch('-', putdat);
  8007e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007e6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007ed:	ff d7                	call   *%edi
				num = -(long long) num;
  8007ef:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8007f2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007f5:	f7 d9                	neg    %ecx
  8007f7:	83 d3 00             	adc    $0x0,%ebx
  8007fa:	f7 db                	neg    %ebx
  8007fc:	b8 0a 00 00 00       	mov    $0xa,%eax
  800801:	e9 94 00 00 00       	jmp    80089a <vprintfmt+0x3cd>
  800806:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800809:	89 ca                	mov    %ecx,%edx
  80080b:	8d 45 14             	lea    0x14(%ebp),%eax
  80080e:	e8 63 fc ff ff       	call   800476 <getuint>
  800813:	89 c1                	mov    %eax,%ecx
  800815:	89 d3                	mov    %edx,%ebx
  800817:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80081c:	eb 7c                	jmp    80089a <vprintfmt+0x3cd>
  80081e:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800821:	89 74 24 04          	mov    %esi,0x4(%esp)
  800825:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  80082c:	ff d7                	call   *%edi
			putch('X', putdat);
  80082e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800832:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800839:	ff d7                	call   *%edi
			putch('X', putdat);
  80083b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80083f:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800846:	ff d7                	call   *%edi
  800848:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80084b:	e9 a9 fc ff ff       	jmp    8004f9 <vprintfmt+0x2c>
  800850:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800853:	89 74 24 04          	mov    %esi,0x4(%esp)
  800857:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80085e:	ff d7                	call   *%edi
			putch('x', putdat);
  800860:	89 74 24 04          	mov    %esi,0x4(%esp)
  800864:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80086b:	ff d7                	call   *%edi
			num = (unsigned long long)
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	8d 50 04             	lea    0x4(%eax),%edx
  800873:	89 55 14             	mov    %edx,0x14(%ebp)
  800876:	8b 08                	mov    (%eax),%ecx
  800878:	bb 00 00 00 00       	mov    $0x0,%ebx
  80087d:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800882:	eb 16                	jmp    80089a <vprintfmt+0x3cd>
  800884:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800887:	89 ca                	mov    %ecx,%edx
  800889:	8d 45 14             	lea    0x14(%ebp),%eax
  80088c:	e8 e5 fb ff ff       	call   800476 <getuint>
  800891:	89 c1                	mov    %eax,%ecx
  800893:	89 d3                	mov    %edx,%ebx
  800895:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80089a:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  80089e:	89 54 24 10          	mov    %edx,0x10(%esp)
  8008a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8008a5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008a9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ad:	89 0c 24             	mov    %ecx,(%esp)
  8008b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008b4:	89 f2                	mov    %esi,%edx
  8008b6:	89 f8                	mov    %edi,%eax
  8008b8:	e8 c3 fa ff ff       	call   800380 <printnum>
  8008bd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8008c0:	e9 34 fc ff ff       	jmp    8004f9 <vprintfmt+0x2c>
  8008c5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008cf:	89 14 24             	mov    %edx,(%esp)
  8008d2:	ff d7                	call   *%edi
  8008d4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8008d7:	e9 1d fc ff ff       	jmp    8004f9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008e0:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008e7:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008e9:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8008ec:	80 38 25             	cmpb   $0x25,(%eax)
  8008ef:	0f 84 04 fc ff ff    	je     8004f9 <vprintfmt+0x2c>
  8008f5:	89 c3                	mov    %eax,%ebx
  8008f7:	eb f0                	jmp    8008e9 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  8008f9:	83 c4 5c             	add    $0x5c,%esp
  8008fc:	5b                   	pop    %ebx
  8008fd:	5e                   	pop    %esi
  8008fe:	5f                   	pop    %edi
  8008ff:	5d                   	pop    %ebp
  800900:	c3                   	ret    

00800901 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800901:	55                   	push   %ebp
  800902:	89 e5                	mov    %esp,%ebp
  800904:	83 ec 28             	sub    $0x28,%esp
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  80090d:	85 c0                	test   %eax,%eax
  80090f:	74 04                	je     800915 <vsnprintf+0x14>
  800911:	85 d2                	test   %edx,%edx
  800913:	7f 07                	jg     80091c <vsnprintf+0x1b>
  800915:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80091a:	eb 3b                	jmp    800957 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80091c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80091f:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800923:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800926:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80092d:	8b 45 14             	mov    0x14(%ebp),%eax
  800930:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800934:	8b 45 10             	mov    0x10(%ebp),%eax
  800937:	89 44 24 08          	mov    %eax,0x8(%esp)
  80093b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80093e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800942:	c7 04 24 b0 04 80 00 	movl   $0x8004b0,(%esp)
  800949:	e8 7f fb ff ff       	call   8004cd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80094e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800951:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800954:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800957:	c9                   	leave  
  800958:	c3                   	ret    

00800959 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80095f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800962:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800966:	8b 45 10             	mov    0x10(%ebp),%eax
  800969:	89 44 24 08          	mov    %eax,0x8(%esp)
  80096d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800970:	89 44 24 04          	mov    %eax,0x4(%esp)
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	89 04 24             	mov    %eax,(%esp)
  80097a:	e8 82 ff ff ff       	call   800901 <vsnprintf>
	va_end(ap);

	return rc;
}
  80097f:	c9                   	leave  
  800980:	c3                   	ret    

00800981 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800987:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80098a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80098e:	8b 45 10             	mov    0x10(%ebp),%eax
  800991:	89 44 24 08          	mov    %eax,0x8(%esp)
  800995:	8b 45 0c             	mov    0xc(%ebp),%eax
  800998:	89 44 24 04          	mov    %eax,0x4(%esp)
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	89 04 24             	mov    %eax,(%esp)
  8009a2:	e8 26 fb ff ff       	call   8004cd <vprintfmt>
	va_end(ap);
}
  8009a7:	c9                   	leave  
  8009a8:	c3                   	ret    
  8009a9:	00 00                	add    %al,(%eax)
  8009ab:	00 00                	add    %al,(%eax)
  8009ad:	00 00                	add    %al,(%eax)
	...

008009b0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009b0:	55                   	push   %ebp
  8009b1:	89 e5                	mov    %esp,%ebp
  8009b3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009bb:	80 3a 00             	cmpb   $0x0,(%edx)
  8009be:	74 09                	je     8009c9 <strlen+0x19>
		n++;
  8009c0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009c3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009c7:	75 f7                	jne    8009c0 <strlen+0x10>
		n++;
	return n;
}
  8009c9:	5d                   	pop    %ebp
  8009ca:	c3                   	ret    

008009cb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009cb:	55                   	push   %ebp
  8009cc:	89 e5                	mov    %esp,%ebp
  8009ce:	53                   	push   %ebx
  8009cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009d2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009d5:	85 c9                	test   %ecx,%ecx
  8009d7:	74 19                	je     8009f2 <strnlen+0x27>
  8009d9:	80 3b 00             	cmpb   $0x0,(%ebx)
  8009dc:	74 14                	je     8009f2 <strnlen+0x27>
  8009de:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8009e3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009e6:	39 c8                	cmp    %ecx,%eax
  8009e8:	74 0d                	je     8009f7 <strnlen+0x2c>
  8009ea:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8009ee:	75 f3                	jne    8009e3 <strnlen+0x18>
  8009f0:	eb 05                	jmp    8009f7 <strnlen+0x2c>
  8009f2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8009f7:	5b                   	pop    %ebx
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	53                   	push   %ebx
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a04:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a09:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a0d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a10:	83 c2 01             	add    $0x1,%edx
  800a13:	84 c9                	test   %cl,%cl
  800a15:	75 f2                	jne    800a09 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a17:	5b                   	pop    %ebx
  800a18:	5d                   	pop    %ebp
  800a19:	c3                   	ret    

00800a1a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a1a:	55                   	push   %ebp
  800a1b:	89 e5                	mov    %esp,%ebp
  800a1d:	56                   	push   %esi
  800a1e:	53                   	push   %ebx
  800a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a22:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a25:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a28:	85 f6                	test   %esi,%esi
  800a2a:	74 18                	je     800a44 <strncpy+0x2a>
  800a2c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800a31:	0f b6 1a             	movzbl (%edx),%ebx
  800a34:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a37:	80 3a 01             	cmpb   $0x1,(%edx)
  800a3a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a3d:	83 c1 01             	add    $0x1,%ecx
  800a40:	39 ce                	cmp    %ecx,%esi
  800a42:	77 ed                	ja     800a31 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a44:	5b                   	pop    %ebx
  800a45:	5e                   	pop    %esi
  800a46:	5d                   	pop    %ebp
  800a47:	c3                   	ret    

00800a48 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	56                   	push   %esi
  800a4c:	53                   	push   %ebx
  800a4d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a53:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a56:	89 f0                	mov    %esi,%eax
  800a58:	85 c9                	test   %ecx,%ecx
  800a5a:	74 27                	je     800a83 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800a5c:	83 e9 01             	sub    $0x1,%ecx
  800a5f:	74 1d                	je     800a7e <strlcpy+0x36>
  800a61:	0f b6 1a             	movzbl (%edx),%ebx
  800a64:	84 db                	test   %bl,%bl
  800a66:	74 16                	je     800a7e <strlcpy+0x36>
			*dst++ = *src++;
  800a68:	88 18                	mov    %bl,(%eax)
  800a6a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a6d:	83 e9 01             	sub    $0x1,%ecx
  800a70:	74 0e                	je     800a80 <strlcpy+0x38>
			*dst++ = *src++;
  800a72:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a75:	0f b6 1a             	movzbl (%edx),%ebx
  800a78:	84 db                	test   %bl,%bl
  800a7a:	75 ec                	jne    800a68 <strlcpy+0x20>
  800a7c:	eb 02                	jmp    800a80 <strlcpy+0x38>
  800a7e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800a80:	c6 00 00             	movb   $0x0,(%eax)
  800a83:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800a85:	5b                   	pop    %ebx
  800a86:	5e                   	pop    %esi
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    

00800a89 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a8f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a92:	0f b6 01             	movzbl (%ecx),%eax
  800a95:	84 c0                	test   %al,%al
  800a97:	74 15                	je     800aae <strcmp+0x25>
  800a99:	3a 02                	cmp    (%edx),%al
  800a9b:	75 11                	jne    800aae <strcmp+0x25>
		p++, q++;
  800a9d:	83 c1 01             	add    $0x1,%ecx
  800aa0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800aa3:	0f b6 01             	movzbl (%ecx),%eax
  800aa6:	84 c0                	test   %al,%al
  800aa8:	74 04                	je     800aae <strcmp+0x25>
  800aaa:	3a 02                	cmp    (%edx),%al
  800aac:	74 ef                	je     800a9d <strcmp+0x14>
  800aae:	0f b6 c0             	movzbl %al,%eax
  800ab1:	0f b6 12             	movzbl (%edx),%edx
  800ab4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ab6:	5d                   	pop    %ebp
  800ab7:	c3                   	ret    

00800ab8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	53                   	push   %ebx
  800abc:	8b 55 08             	mov    0x8(%ebp),%edx
  800abf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ac2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800ac5:	85 c0                	test   %eax,%eax
  800ac7:	74 23                	je     800aec <strncmp+0x34>
  800ac9:	0f b6 1a             	movzbl (%edx),%ebx
  800acc:	84 db                	test   %bl,%bl
  800ace:	74 24                	je     800af4 <strncmp+0x3c>
  800ad0:	3a 19                	cmp    (%ecx),%bl
  800ad2:	75 20                	jne    800af4 <strncmp+0x3c>
  800ad4:	83 e8 01             	sub    $0x1,%eax
  800ad7:	74 13                	je     800aec <strncmp+0x34>
		n--, p++, q++;
  800ad9:	83 c2 01             	add    $0x1,%edx
  800adc:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800adf:	0f b6 1a             	movzbl (%edx),%ebx
  800ae2:	84 db                	test   %bl,%bl
  800ae4:	74 0e                	je     800af4 <strncmp+0x3c>
  800ae6:	3a 19                	cmp    (%ecx),%bl
  800ae8:	74 ea                	je     800ad4 <strncmp+0x1c>
  800aea:	eb 08                	jmp    800af4 <strncmp+0x3c>
  800aec:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800af1:	5b                   	pop    %ebx
  800af2:	5d                   	pop    %ebp
  800af3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800af4:	0f b6 02             	movzbl (%edx),%eax
  800af7:	0f b6 11             	movzbl (%ecx),%edx
  800afa:	29 d0                	sub    %edx,%eax
  800afc:	eb f3                	jmp    800af1 <strncmp+0x39>

00800afe <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b08:	0f b6 10             	movzbl (%eax),%edx
  800b0b:	84 d2                	test   %dl,%dl
  800b0d:	74 15                	je     800b24 <strchr+0x26>
		if (*s == c)
  800b0f:	38 ca                	cmp    %cl,%dl
  800b11:	75 07                	jne    800b1a <strchr+0x1c>
  800b13:	eb 14                	jmp    800b29 <strchr+0x2b>
  800b15:	38 ca                	cmp    %cl,%dl
  800b17:	90                   	nop
  800b18:	74 0f                	je     800b29 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b1a:	83 c0 01             	add    $0x1,%eax
  800b1d:	0f b6 10             	movzbl (%eax),%edx
  800b20:	84 d2                	test   %dl,%dl
  800b22:	75 f1                	jne    800b15 <strchr+0x17>
  800b24:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b35:	0f b6 10             	movzbl (%eax),%edx
  800b38:	84 d2                	test   %dl,%dl
  800b3a:	74 18                	je     800b54 <strfind+0x29>
		if (*s == c)
  800b3c:	38 ca                	cmp    %cl,%dl
  800b3e:	75 0a                	jne    800b4a <strfind+0x1f>
  800b40:	eb 12                	jmp    800b54 <strfind+0x29>
  800b42:	38 ca                	cmp    %cl,%dl
  800b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800b48:	74 0a                	je     800b54 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b4a:	83 c0 01             	add    $0x1,%eax
  800b4d:	0f b6 10             	movzbl (%eax),%edx
  800b50:	84 d2                	test   %dl,%dl
  800b52:	75 ee                	jne    800b42 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    

00800b56 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
  800b59:	83 ec 0c             	sub    $0xc,%esp
  800b5c:	89 1c 24             	mov    %ebx,(%esp)
  800b5f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b63:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800b67:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b70:	85 c9                	test   %ecx,%ecx
  800b72:	74 30                	je     800ba4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b74:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b7a:	75 25                	jne    800ba1 <memset+0x4b>
  800b7c:	f6 c1 03             	test   $0x3,%cl
  800b7f:	75 20                	jne    800ba1 <memset+0x4b>
		c &= 0xFF;
  800b81:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b84:	89 d3                	mov    %edx,%ebx
  800b86:	c1 e3 08             	shl    $0x8,%ebx
  800b89:	89 d6                	mov    %edx,%esi
  800b8b:	c1 e6 18             	shl    $0x18,%esi
  800b8e:	89 d0                	mov    %edx,%eax
  800b90:	c1 e0 10             	shl    $0x10,%eax
  800b93:	09 f0                	or     %esi,%eax
  800b95:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800b97:	09 d8                	or     %ebx,%eax
  800b99:	c1 e9 02             	shr    $0x2,%ecx
  800b9c:	fc                   	cld    
  800b9d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b9f:	eb 03                	jmp    800ba4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ba1:	fc                   	cld    
  800ba2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800ba4:	89 f8                	mov    %edi,%eax
  800ba6:	8b 1c 24             	mov    (%esp),%ebx
  800ba9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800bad:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800bb1:	89 ec                	mov    %ebp,%esp
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    

00800bb5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 08             	sub    $0x8,%esp
  800bbb:	89 34 24             	mov    %esi,(%esp)
  800bbe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800bc8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800bcb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800bcd:	39 c6                	cmp    %eax,%esi
  800bcf:	73 35                	jae    800c06 <memmove+0x51>
  800bd1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bd4:	39 d0                	cmp    %edx,%eax
  800bd6:	73 2e                	jae    800c06 <memmove+0x51>
		s += n;
		d += n;
  800bd8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bda:	f6 c2 03             	test   $0x3,%dl
  800bdd:	75 1b                	jne    800bfa <memmove+0x45>
  800bdf:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800be5:	75 13                	jne    800bfa <memmove+0x45>
  800be7:	f6 c1 03             	test   $0x3,%cl
  800bea:	75 0e                	jne    800bfa <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800bec:	83 ef 04             	sub    $0x4,%edi
  800bef:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bf2:	c1 e9 02             	shr    $0x2,%ecx
  800bf5:	fd                   	std    
  800bf6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf8:	eb 09                	jmp    800c03 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800bfa:	83 ef 01             	sub    $0x1,%edi
  800bfd:	8d 72 ff             	lea    -0x1(%edx),%esi
  800c00:	fd                   	std    
  800c01:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c03:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c04:	eb 20                	jmp    800c26 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c06:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c0c:	75 15                	jne    800c23 <memmove+0x6e>
  800c0e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c14:	75 0d                	jne    800c23 <memmove+0x6e>
  800c16:	f6 c1 03             	test   $0x3,%cl
  800c19:	75 08                	jne    800c23 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800c1b:	c1 e9 02             	shr    $0x2,%ecx
  800c1e:	fc                   	cld    
  800c1f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c21:	eb 03                	jmp    800c26 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c23:	fc                   	cld    
  800c24:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c26:	8b 34 24             	mov    (%esp),%esi
  800c29:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800c2d:	89 ec                	mov    %ebp,%esp
  800c2f:	5d                   	pop    %ebp
  800c30:	c3                   	ret    

00800c31 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800c31:	55                   	push   %ebp
  800c32:	89 e5                	mov    %esp,%ebp
  800c34:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c37:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c41:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	89 04 24             	mov    %eax,(%esp)
  800c4b:	e8 65 ff ff ff       	call   800bb5 <memmove>
}
  800c50:	c9                   	leave  
  800c51:	c3                   	ret    

00800c52 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	57                   	push   %edi
  800c56:	56                   	push   %esi
  800c57:	53                   	push   %ebx
  800c58:	8b 75 08             	mov    0x8(%ebp),%esi
  800c5b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800c5e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c61:	85 c9                	test   %ecx,%ecx
  800c63:	74 36                	je     800c9b <memcmp+0x49>
		if (*s1 != *s2)
  800c65:	0f b6 06             	movzbl (%esi),%eax
  800c68:	0f b6 1f             	movzbl (%edi),%ebx
  800c6b:	38 d8                	cmp    %bl,%al
  800c6d:	74 20                	je     800c8f <memcmp+0x3d>
  800c6f:	eb 14                	jmp    800c85 <memcmp+0x33>
  800c71:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800c76:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800c7b:	83 c2 01             	add    $0x1,%edx
  800c7e:	83 e9 01             	sub    $0x1,%ecx
  800c81:	38 d8                	cmp    %bl,%al
  800c83:	74 12                	je     800c97 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800c85:	0f b6 c0             	movzbl %al,%eax
  800c88:	0f b6 db             	movzbl %bl,%ebx
  800c8b:	29 d8                	sub    %ebx,%eax
  800c8d:	eb 11                	jmp    800ca0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c8f:	83 e9 01             	sub    $0x1,%ecx
  800c92:	ba 00 00 00 00       	mov    $0x0,%edx
  800c97:	85 c9                	test   %ecx,%ecx
  800c99:	75 d6                	jne    800c71 <memcmp+0x1f>
  800c9b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800ca0:	5b                   	pop    %ebx
  800ca1:	5e                   	pop    %esi
  800ca2:	5f                   	pop    %edi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    

00800ca5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800cab:	89 c2                	mov    %eax,%edx
  800cad:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800cb0:	39 d0                	cmp    %edx,%eax
  800cb2:	73 15                	jae    800cc9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800cb4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800cb8:	38 08                	cmp    %cl,(%eax)
  800cba:	75 06                	jne    800cc2 <memfind+0x1d>
  800cbc:	eb 0b                	jmp    800cc9 <memfind+0x24>
  800cbe:	38 08                	cmp    %cl,(%eax)
  800cc0:	74 07                	je     800cc9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cc2:	83 c0 01             	add    $0x1,%eax
  800cc5:	39 c2                	cmp    %eax,%edx
  800cc7:	77 f5                	ja     800cbe <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800cc9:	5d                   	pop    %ebp
  800cca:	c3                   	ret    

00800ccb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	57                   	push   %edi
  800ccf:	56                   	push   %esi
  800cd0:	53                   	push   %ebx
  800cd1:	83 ec 04             	sub    $0x4,%esp
  800cd4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cda:	0f b6 02             	movzbl (%edx),%eax
  800cdd:	3c 20                	cmp    $0x20,%al
  800cdf:	74 04                	je     800ce5 <strtol+0x1a>
  800ce1:	3c 09                	cmp    $0x9,%al
  800ce3:	75 0e                	jne    800cf3 <strtol+0x28>
		s++;
  800ce5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ce8:	0f b6 02             	movzbl (%edx),%eax
  800ceb:	3c 20                	cmp    $0x20,%al
  800ced:	74 f6                	je     800ce5 <strtol+0x1a>
  800cef:	3c 09                	cmp    $0x9,%al
  800cf1:	74 f2                	je     800ce5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cf3:	3c 2b                	cmp    $0x2b,%al
  800cf5:	75 0c                	jne    800d03 <strtol+0x38>
		s++;
  800cf7:	83 c2 01             	add    $0x1,%edx
  800cfa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d01:	eb 15                	jmp    800d18 <strtol+0x4d>
	else if (*s == '-')
  800d03:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d0a:	3c 2d                	cmp    $0x2d,%al
  800d0c:	75 0a                	jne    800d18 <strtol+0x4d>
		s++, neg = 1;
  800d0e:	83 c2 01             	add    $0x1,%edx
  800d11:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d18:	85 db                	test   %ebx,%ebx
  800d1a:	0f 94 c0             	sete   %al
  800d1d:	74 05                	je     800d24 <strtol+0x59>
  800d1f:	83 fb 10             	cmp    $0x10,%ebx
  800d22:	75 18                	jne    800d3c <strtol+0x71>
  800d24:	80 3a 30             	cmpb   $0x30,(%edx)
  800d27:	75 13                	jne    800d3c <strtol+0x71>
  800d29:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d2d:	8d 76 00             	lea    0x0(%esi),%esi
  800d30:	75 0a                	jne    800d3c <strtol+0x71>
		s += 2, base = 16;
  800d32:	83 c2 02             	add    $0x2,%edx
  800d35:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d3a:	eb 15                	jmp    800d51 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d3c:	84 c0                	test   %al,%al
  800d3e:	66 90                	xchg   %ax,%ax
  800d40:	74 0f                	je     800d51 <strtol+0x86>
  800d42:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800d47:	80 3a 30             	cmpb   $0x30,(%edx)
  800d4a:	75 05                	jne    800d51 <strtol+0x86>
		s++, base = 8;
  800d4c:	83 c2 01             	add    $0x1,%edx
  800d4f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d51:	b8 00 00 00 00       	mov    $0x0,%eax
  800d56:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d58:	0f b6 0a             	movzbl (%edx),%ecx
  800d5b:	89 cf                	mov    %ecx,%edi
  800d5d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800d60:	80 fb 09             	cmp    $0x9,%bl
  800d63:	77 08                	ja     800d6d <strtol+0xa2>
			dig = *s - '0';
  800d65:	0f be c9             	movsbl %cl,%ecx
  800d68:	83 e9 30             	sub    $0x30,%ecx
  800d6b:	eb 1e                	jmp    800d8b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800d6d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800d70:	80 fb 19             	cmp    $0x19,%bl
  800d73:	77 08                	ja     800d7d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800d75:	0f be c9             	movsbl %cl,%ecx
  800d78:	83 e9 57             	sub    $0x57,%ecx
  800d7b:	eb 0e                	jmp    800d8b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800d7d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800d80:	80 fb 19             	cmp    $0x19,%bl
  800d83:	77 15                	ja     800d9a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800d85:	0f be c9             	movsbl %cl,%ecx
  800d88:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d8b:	39 f1                	cmp    %esi,%ecx
  800d8d:	7d 0b                	jge    800d9a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800d8f:	83 c2 01             	add    $0x1,%edx
  800d92:	0f af c6             	imul   %esi,%eax
  800d95:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800d98:	eb be                	jmp    800d58 <strtol+0x8d>
  800d9a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800d9c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800da0:	74 05                	je     800da7 <strtol+0xdc>
		*endptr = (char *) s;
  800da2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800da5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800da7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800dab:	74 04                	je     800db1 <strtol+0xe6>
  800dad:	89 c8                	mov    %ecx,%eax
  800daf:	f7 d8                	neg    %eax
}
  800db1:	83 c4 04             	add    $0x4,%esp
  800db4:	5b                   	pop    %ebx
  800db5:	5e                   	pop    %esi
  800db6:	5f                   	pop    %edi
  800db7:	5d                   	pop    %ebp
  800db8:	c3                   	ret    
  800db9:	00 00                	add    %al,(%eax)
	...

00800dbc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	83 ec 0c             	sub    $0xc,%esp
  800dc2:	89 1c 24             	mov    %ebx,(%esp)
  800dc5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dc9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dcd:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd2:	b8 01 00 00 00       	mov    $0x1,%eax
  800dd7:	89 d1                	mov    %edx,%ecx
  800dd9:	89 d3                	mov    %edx,%ebx
  800ddb:	89 d7                	mov    %edx,%edi
  800ddd:	89 d6                	mov    %edx,%esi
  800ddf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800de1:	8b 1c 24             	mov    (%esp),%ebx
  800de4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800de8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dec:	89 ec                	mov    %ebp,%esp
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    

00800df0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800df0:	55                   	push   %ebp
  800df1:	89 e5                	mov    %esp,%ebp
  800df3:	83 ec 0c             	sub    $0xc,%esp
  800df6:	89 1c 24             	mov    %ebx,(%esp)
  800df9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dfd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e01:	b8 00 00 00 00       	mov    $0x0,%eax
  800e06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e09:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0c:	89 c3                	mov    %eax,%ebx
  800e0e:	89 c7                	mov    %eax,%edi
  800e10:	89 c6                	mov    %eax,%esi
  800e12:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e14:	8b 1c 24             	mov    (%esp),%ebx
  800e17:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e1b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e1f:	89 ec                	mov    %ebp,%esp
  800e21:	5d                   	pop    %ebp
  800e22:	c3                   	ret    

00800e23 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  800e23:	55                   	push   %ebp
  800e24:	89 e5                	mov    %esp,%ebp
  800e26:	83 ec 0c             	sub    $0xc,%esp
  800e29:	89 1c 24             	mov    %ebx,(%esp)
  800e2c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e30:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e39:	b8 10 00 00 00       	mov    $0x10,%eax
  800e3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e41:	8b 55 08             	mov    0x8(%ebp),%edx
  800e44:	89 df                	mov    %ebx,%edi
  800e46:	89 de                	mov    %ebx,%esi
  800e48:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800e4a:	8b 1c 24             	mov    (%esp),%ebx
  800e4d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e51:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e55:	89 ec                	mov    %ebp,%esp
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    

00800e59 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	83 ec 38             	sub    $0x38,%esp
  800e5f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e62:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e65:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e68:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e6d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	89 df                	mov    %ebx,%edi
  800e7a:	89 de                	mov    %ebx,%esi
  800e7c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e7e:	85 c0                	test   %eax,%eax
  800e80:	7e 28                	jle    800eaa <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e82:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e86:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800e8d:	00 
  800e8e:	c7 44 24 08 df 31 80 	movl   $0x8031df,0x8(%esp)
  800e95:	00 
  800e96:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e9d:	00 
  800e9e:	c7 04 24 fc 31 80 00 	movl   $0x8031fc,(%esp)
  800ea5:	e8 ae f3 ff ff       	call   800258 <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800eaa:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ead:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eb0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eb3:	89 ec                	mov    %ebp,%esp
  800eb5:	5d                   	pop    %ebp
  800eb6:	c3                   	ret    

00800eb7 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800eb7:	55                   	push   %ebp
  800eb8:	89 e5                	mov    %esp,%ebp
  800eba:	83 ec 0c             	sub    $0xc,%esp
  800ebd:	89 1c 24             	mov    %ebx,(%esp)
  800ec0:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ec4:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ecd:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ed2:	89 d1                	mov    %edx,%ecx
  800ed4:	89 d3                	mov    %edx,%ebx
  800ed6:	89 d7                	mov    %edx,%edi
  800ed8:	89 d6                	mov    %edx,%esi
  800eda:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800edc:	8b 1c 24             	mov    (%esp),%ebx
  800edf:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ee3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ee7:	89 ec                	mov    %ebp,%esp
  800ee9:	5d                   	pop    %ebp
  800eea:	c3                   	ret    

00800eeb <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800eeb:	55                   	push   %ebp
  800eec:	89 e5                	mov    %esp,%ebp
  800eee:	83 ec 38             	sub    $0x38,%esp
  800ef1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ef4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ef7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eff:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f04:	8b 55 08             	mov    0x8(%ebp),%edx
  800f07:	89 cb                	mov    %ecx,%ebx
  800f09:	89 cf                	mov    %ecx,%edi
  800f0b:	89 ce                	mov    %ecx,%esi
  800f0d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f0f:	85 c0                	test   %eax,%eax
  800f11:	7e 28                	jle    800f3b <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f13:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f17:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f1e:	00 
  800f1f:	c7 44 24 08 df 31 80 	movl   $0x8031df,0x8(%esp)
  800f26:	00 
  800f27:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f2e:	00 
  800f2f:	c7 04 24 fc 31 80 00 	movl   $0x8031fc,(%esp)
  800f36:	e8 1d f3 ff ff       	call   800258 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f3b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f3e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f41:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f44:	89 ec                	mov    %ebp,%esp
  800f46:	5d                   	pop    %ebp
  800f47:	c3                   	ret    

00800f48 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f48:	55                   	push   %ebp
  800f49:	89 e5                	mov    %esp,%ebp
  800f4b:	83 ec 0c             	sub    $0xc,%esp
  800f4e:	89 1c 24             	mov    %ebx,(%esp)
  800f51:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f55:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f59:	be 00 00 00 00       	mov    $0x0,%esi
  800f5e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f63:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f66:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f71:	8b 1c 24             	mov    (%esp),%ebx
  800f74:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f78:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f7c:	89 ec                	mov    %ebp,%esp
  800f7e:	5d                   	pop    %ebp
  800f7f:	c3                   	ret    

00800f80 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f80:	55                   	push   %ebp
  800f81:	89 e5                	mov    %esp,%ebp
  800f83:	83 ec 38             	sub    $0x38,%esp
  800f86:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f89:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f8c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f8f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f94:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9f:	89 df                	mov    %ebx,%edi
  800fa1:	89 de                	mov    %ebx,%esi
  800fa3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fa5:	85 c0                	test   %eax,%eax
  800fa7:	7e 28                	jle    800fd1 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fad:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800fb4:	00 
  800fb5:	c7 44 24 08 df 31 80 	movl   $0x8031df,0x8(%esp)
  800fbc:	00 
  800fbd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fc4:	00 
  800fc5:	c7 04 24 fc 31 80 00 	movl   $0x8031fc,(%esp)
  800fcc:	e8 87 f2 ff ff       	call   800258 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fd1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fd4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fd7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fda:	89 ec                	mov    %ebp,%esp
  800fdc:	5d                   	pop    %ebp
  800fdd:	c3                   	ret    

00800fde <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fde:	55                   	push   %ebp
  800fdf:	89 e5                	mov    %esp,%ebp
  800fe1:	83 ec 38             	sub    $0x38,%esp
  800fe4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fe7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fea:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fed:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ff2:	b8 09 00 00 00       	mov    $0x9,%eax
  800ff7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ffa:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffd:	89 df                	mov    %ebx,%edi
  800fff:	89 de                	mov    %ebx,%esi
  801001:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801003:	85 c0                	test   %eax,%eax
  801005:	7e 28                	jle    80102f <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801007:	89 44 24 10          	mov    %eax,0x10(%esp)
  80100b:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801012:	00 
  801013:	c7 44 24 08 df 31 80 	movl   $0x8031df,0x8(%esp)
  80101a:	00 
  80101b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801022:	00 
  801023:	c7 04 24 fc 31 80 00 	movl   $0x8031fc,(%esp)
  80102a:	e8 29 f2 ff ff       	call   800258 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80102f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801032:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801035:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801038:	89 ec                	mov    %ebp,%esp
  80103a:	5d                   	pop    %ebp
  80103b:	c3                   	ret    

0080103c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	83 ec 38             	sub    $0x38,%esp
  801042:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801045:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801048:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80104b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801050:	b8 08 00 00 00       	mov    $0x8,%eax
  801055:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801058:	8b 55 08             	mov    0x8(%ebp),%edx
  80105b:	89 df                	mov    %ebx,%edi
  80105d:	89 de                	mov    %ebx,%esi
  80105f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801061:	85 c0                	test   %eax,%eax
  801063:	7e 28                	jle    80108d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801065:	89 44 24 10          	mov    %eax,0x10(%esp)
  801069:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801070:	00 
  801071:	c7 44 24 08 df 31 80 	movl   $0x8031df,0x8(%esp)
  801078:	00 
  801079:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801080:	00 
  801081:	c7 04 24 fc 31 80 00 	movl   $0x8031fc,(%esp)
  801088:	e8 cb f1 ff ff       	call   800258 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80108d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801090:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801093:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801096:	89 ec                	mov    %ebp,%esp
  801098:	5d                   	pop    %ebp
  801099:	c3                   	ret    

0080109a <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80109a:	55                   	push   %ebp
  80109b:	89 e5                	mov    %esp,%ebp
  80109d:	83 ec 38             	sub    $0x38,%esp
  8010a0:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010a3:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010a6:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ae:	b8 06 00 00 00       	mov    $0x6,%eax
  8010b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b9:	89 df                	mov    %ebx,%edi
  8010bb:	89 de                	mov    %ebx,%esi
  8010bd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010bf:	85 c0                	test   %eax,%eax
  8010c1:	7e 28                	jle    8010eb <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8010ce:	00 
  8010cf:	c7 44 24 08 df 31 80 	movl   $0x8031df,0x8(%esp)
  8010d6:	00 
  8010d7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010de:	00 
  8010df:	c7 04 24 fc 31 80 00 	movl   $0x8031fc,(%esp)
  8010e6:	e8 6d f1 ff ff       	call   800258 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010eb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010ee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010f1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010f4:	89 ec                	mov    %ebp,%esp
  8010f6:	5d                   	pop    %ebp
  8010f7:	c3                   	ret    

008010f8 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	83 ec 38             	sub    $0x38,%esp
  8010fe:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801101:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801104:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801107:	b8 05 00 00 00       	mov    $0x5,%eax
  80110c:	8b 75 18             	mov    0x18(%ebp),%esi
  80110f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801112:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801115:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801118:	8b 55 08             	mov    0x8(%ebp),%edx
  80111b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80111d:	85 c0                	test   %eax,%eax
  80111f:	7e 28                	jle    801149 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801121:	89 44 24 10          	mov    %eax,0x10(%esp)
  801125:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80112c:	00 
  80112d:	c7 44 24 08 df 31 80 	movl   $0x8031df,0x8(%esp)
  801134:	00 
  801135:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80113c:	00 
  80113d:	c7 04 24 fc 31 80 00 	movl   $0x8031fc,(%esp)
  801144:	e8 0f f1 ff ff       	call   800258 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801149:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80114c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80114f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801152:	89 ec                	mov    %ebp,%esp
  801154:	5d                   	pop    %ebp
  801155:	c3                   	ret    

00801156 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 38             	sub    $0x38,%esp
  80115c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80115f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801162:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801165:	be 00 00 00 00       	mov    $0x0,%esi
  80116a:	b8 04 00 00 00       	mov    $0x4,%eax
  80116f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801172:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801175:	8b 55 08             	mov    0x8(%ebp),%edx
  801178:	89 f7                	mov    %esi,%edi
  80117a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80117c:	85 c0                	test   %eax,%eax
  80117e:	7e 28                	jle    8011a8 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801180:	89 44 24 10          	mov    %eax,0x10(%esp)
  801184:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80118b:	00 
  80118c:	c7 44 24 08 df 31 80 	movl   $0x8031df,0x8(%esp)
  801193:	00 
  801194:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80119b:	00 
  80119c:	c7 04 24 fc 31 80 00 	movl   $0x8031fc,(%esp)
  8011a3:	e8 b0 f0 ff ff       	call   800258 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011a8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011ab:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011ae:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011b1:	89 ec                	mov    %ebp,%esp
  8011b3:	5d                   	pop    %ebp
  8011b4:	c3                   	ret    

008011b5 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8011b5:	55                   	push   %ebp
  8011b6:	89 e5                	mov    %esp,%ebp
  8011b8:	83 ec 0c             	sub    $0xc,%esp
  8011bb:	89 1c 24             	mov    %ebx,(%esp)
  8011be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011c2:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8011cb:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011d0:	89 d1                	mov    %edx,%ecx
  8011d2:	89 d3                	mov    %edx,%ebx
  8011d4:	89 d7                	mov    %edx,%edi
  8011d6:	89 d6                	mov    %edx,%esi
  8011d8:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011da:	8b 1c 24             	mov    (%esp),%ebx
  8011dd:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011e1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011e5:	89 ec                	mov    %ebp,%esp
  8011e7:	5d                   	pop    %ebp
  8011e8:	c3                   	ret    

008011e9 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 0c             	sub    $0xc,%esp
  8011ef:	89 1c 24             	mov    %ebx,(%esp)
  8011f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011f6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ff:	b8 02 00 00 00       	mov    $0x2,%eax
  801204:	89 d1                	mov    %edx,%ecx
  801206:	89 d3                	mov    %edx,%ebx
  801208:	89 d7                	mov    %edx,%edi
  80120a:	89 d6                	mov    %edx,%esi
  80120c:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80120e:	8b 1c 24             	mov    (%esp),%ebx
  801211:	8b 74 24 04          	mov    0x4(%esp),%esi
  801215:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801219:	89 ec                	mov    %ebp,%esp
  80121b:	5d                   	pop    %ebp
  80121c:	c3                   	ret    

0080121d <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	83 ec 38             	sub    $0x38,%esp
  801223:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801226:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801229:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80122c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801231:	b8 03 00 00 00       	mov    $0x3,%eax
  801236:	8b 55 08             	mov    0x8(%ebp),%edx
  801239:	89 cb                	mov    %ecx,%ebx
  80123b:	89 cf                	mov    %ecx,%edi
  80123d:	89 ce                	mov    %ecx,%esi
  80123f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801241:	85 c0                	test   %eax,%eax
  801243:	7e 28                	jle    80126d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801245:	89 44 24 10          	mov    %eax,0x10(%esp)
  801249:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801250:	00 
  801251:	c7 44 24 08 df 31 80 	movl   $0x8031df,0x8(%esp)
  801258:	00 
  801259:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801260:	00 
  801261:	c7 04 24 fc 31 80 00 	movl   $0x8031fc,(%esp)
  801268:	e8 eb ef ff ff       	call   800258 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80126d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801270:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801273:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801276:	89 ec                	mov    %ebp,%esp
  801278:	5d                   	pop    %ebp
  801279:	c3                   	ret    
	...

0080127c <sfork>:
}

// Challenge!
int
sfork(void)
{
  80127c:	55                   	push   %ebp
  80127d:	89 e5                	mov    %esp,%ebp
  80127f:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801282:	c7 44 24 08 0a 32 80 	movl   $0x80320a,0x8(%esp)
  801289:	00 
  80128a:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  801291:	00 
  801292:	c7 04 24 20 32 80 00 	movl   $0x803220,(%esp)
  801299:	e8 ba ef ff ff       	call   800258 <_panic>

0080129e <duppage>:
// It is also OK to panic on error.
// 

static int
duppage(envid_t envid, unsigned pn)
{
  80129e:	55                   	push   %ebp
  80129f:	89 e5                	mov    %esp,%ebp
  8012a1:	83 ec 28             	sub    $0x28,%esp
  8012a4:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8012a7:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8012aa:	89 c3                	mov    %eax,%ebx
	int r;

	// LAB 4: Your code here.
     pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  8012ac:	89 d6                	mov    %edx,%esi
  8012ae:	c1 e6 0c             	shl    $0xc,%esi
  8012b1:	89 f0                	mov    %esi,%eax
  8012b3:	c1 e8 16             	shr    $0x16,%eax
  8012b6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
       
        if( 0 == pgDirEntry )
  8012bd:	85 c0                	test   %eax,%eax
  8012bf:	0f 84 fc 00 00 00    	je     8013c1 <duppage+0x123>
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  8012c5:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8012cc:	89 c2                	mov    %eax,%edx
  8012ce:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        //cprintf("Below %d",vpt[pn]);
                //if(perm!=0)  //commented nw.
                   // cprintf("perm bit %d",perm);
	
	
	if((perm & PTE_W) && (perm & PTE_SHARE))
  8012d4:	25 02 04 00 00       	and    $0x402,%eax
  8012d9:	3d 02 04 00 00       	cmp    $0x402,%eax
  8012de:	75 4d                	jne    80132d <duppage+0x8f>
	{	
		if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_SHARE|(perm & PTE_USER))) < 0)
  8012e0:	81 e2 07 0a 00 00    	and    $0xa07,%edx
  8012e6:	80 ce 04             	or     $0x4,%dh
  8012e9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8012ed:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012f1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012f5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801300:	e8 f3 fd ff ff       	call   8010f8 <sys_page_map>
  801305:	85 c0                	test   %eax,%eax
  801307:	0f 89 bb 00 00 00    	jns    8013c8 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  80130d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801311:	c7 44 24 08 2b 32 80 	movl   $0x80322b,0x8(%esp)
  801318:	00 
  801319:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  801320:	00 
  801321:	c7 04 24 20 32 80 00 	movl   $0x803220,(%esp)
  801328:	e8 2b ef ff ff       	call   800258 <_panic>
	}	


        else if((perm & PTE_W)!=0 || (perm & PTE_COW)!=0)
  80132d:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801333:	0f 84 8f 00 00 00    	je     8013c8 <duppage+0x12a>
         {
          //cprintf("\nInside Setting Cow\n"); 
        if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  801339:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801340:	00 
  801341:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801345:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801349:	89 74 24 04          	mov    %esi,0x4(%esp)
  80134d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801354:	e8 9f fd ff ff       	call   8010f8 <sys_page_map>
  801359:	85 c0                	test   %eax,%eax
  80135b:	79 20                	jns    80137d <duppage+0xdf>
                panic("sys_page_map: %e", r);
  80135d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801361:	c7 44 24 08 2b 32 80 	movl   $0x80322b,0x8(%esp)
  801368:	00 
  801369:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801370:	00 
  801371:	c7 04 24 20 32 80 00 	movl   $0x803220,(%esp)
  801378:	e8 db ee ff ff       	call   800258 <_panic>
        if ((r = sys_page_map(envid,(void *)(pn*PGSIZE),0,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  80137d:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801384:	00 
  801385:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801389:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801390:	00 
  801391:	89 74 24 04          	mov    %esi,0x4(%esp)
  801395:	89 1c 24             	mov    %ebx,(%esp)
  801398:	e8 5b fd ff ff       	call   8010f8 <sys_page_map>
  80139d:	85 c0                	test   %eax,%eax
  80139f:	79 27                	jns    8013c8 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  8013a1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013a5:	c7 44 24 08 2b 32 80 	movl   $0x80322b,0x8(%esp)
  8013ac:	00 
  8013ad:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8013b4:	00 
  8013b5:	c7 04 24 20 32 80 00 	movl   $0x803220,(%esp)
  8013bc:	e8 97 ee ff ff       	call   800258 <_panic>
  8013c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8013c6:	eb 05                	jmp    8013cd <duppage+0x12f>
  8013c8:	b8 00 00 00 00       	mov    $0x0,%eax
         }


//	panic("duppage not implemented");
	return 0;
}
  8013cd:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8013d0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8013d3:	89 ec                	mov    %ebp,%esp
  8013d5:	5d                   	pop    %ebp
  8013d6:	c3                   	ret    

008013d7 <fork>:
//


envid_t
fork(void)
{
  8013d7:	55                   	push   %ebp
  8013d8:	89 e5                	mov    %esp,%ebp
  8013da:	56                   	push   %esi
  8013db:	53                   	push   %ebx
  8013dc:	83 ec 10             	sub    $0x10,%esp

        envid_t envid;
        uint8_t *addr;
        int r;
        extern unsigned char end[];
        set_pgfault_handler(pgfault);
  8013df:	c7 04 24 ee 14 80 00 	movl   $0x8014ee,(%esp)
  8013e6:	e8 c1 15 00 00       	call   8029ac <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8013eb:	be 07 00 00 00       	mov    $0x7,%esi
  8013f0:	89 f0                	mov    %esi,%eax
  8013f2:	cd 30                	int    $0x30
  8013f4:	89 c6                	mov    %eax,%esi

        envid = sys_exofork();
        if (envid < 0)
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	79 20                	jns    80141a <fork+0x43>
                panic("sys_exofork: %e", envid);
  8013fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013fe:	c7 44 24 08 3c 32 80 	movl   $0x80323c,0x8(%esp)
  801405:	00 
  801406:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  80140d:	00 
  80140e:	c7 04 24 20 32 80 00 	movl   $0x803220,(%esp)
  801415:	e8 3e ee ff ff       	call   800258 <_panic>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
  80141a:	bb 00 00 80 00       	mov    $0x800000,%ebx
        set_pgfault_handler(pgfault);

        envid = sys_exofork();
        if (envid < 0)
                panic("sys_exofork: %e", envid);
        if (envid == 0) {
  80141f:	85 c0                	test   %eax,%eax
  801421:	75 1c                	jne    80143f <fork+0x68>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
  801423:	e8 c1 fd ff ff       	call   8011e9 <sys_getenvid>
  801428:	25 ff 03 00 00       	and    $0x3ff,%eax
  80142d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801430:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801435:	a3 74 70 80 00       	mov    %eax,0x807074
                return 0;
  80143a:	e9 a6 00 00 00       	jmp    8014e5 <fork+0x10e>
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
  80143f:	89 da                	mov    %ebx,%edx
  801441:	c1 ea 0c             	shr    $0xc,%edx
  801444:	89 f0                	mov    %esi,%eax
  801446:	e8 53 fe ff ff       	call   80129e <duppage>
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
  80144b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801451:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801457:	75 e6                	jne    80143f <fork+0x68>
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
                }
              duppage(envid,VPN(USTACKTOP-PGSIZE));
  801459:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80145e:	89 f0                	mov    %esi,%eax
  801460:	e8 39 fe ff ff       	call   80129e <duppage>
        // Also copy the stack we are currently running on.
       //if(sys_page_alloc(envid, (void *)(ROUNDDOWN(&addr, PGSIZE)),PTE_U|PTE_P|PTE_W)<0)
         //                      panic("stack not allocated");
     
   
     sys_env_set_pgfault_upcall(envid,env->env_pgfault_upcall);
  801465:	a1 74 70 80 00       	mov    0x807074,%eax
  80146a:	8b 40 64             	mov    0x64(%eax),%eax
  80146d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801471:	89 34 24             	mov    %esi,(%esp)
  801474:	e8 07 fb ff ff       	call   800f80 <sys_env_set_pgfault_upcall>

     if(sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  801479:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801480:	00 
  801481:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801488:	ee 
  801489:	89 34 24             	mov    %esi,(%esp)
  80148c:	e8 c5 fc ff ff       	call   801156 <sys_page_alloc>
  801491:	85 c0                	test   %eax,%eax
  801493:	79 1c                	jns    8014b1 <fork+0xda>
                          panic("Cant allocate Page");
  801495:	c7 44 24 08 4c 32 80 	movl   $0x80324c,0x8(%esp)
  80149c:	00 
  80149d:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  8014a4:	00 
  8014a5:	c7 04 24 20 32 80 00 	movl   $0x803220,(%esp)
  8014ac:	e8 a7 ed ff ff       	call   800258 <_panic>

        // Start the child environment running
        if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8014b1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8014b8:	00 
  8014b9:	89 34 24             	mov    %esi,(%esp)
  8014bc:	e8 7b fb ff ff       	call   80103c <sys_env_set_status>
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	79 20                	jns    8014e5 <fork+0x10e>
                panic("sys_env_set_status: %e", r);
  8014c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014c9:	c7 44 24 08 5f 32 80 	movl   $0x80325f,0x8(%esp)
  8014d0:	00 
  8014d1:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  8014d8:	00 
  8014d9:	c7 04 24 20 32 80 00 	movl   $0x803220,(%esp)
  8014e0:	e8 73 ed ff ff       	call   800258 <_panic>
         return envid;
           
//panic("fork not implemented");
}
  8014e5:	89 f0                	mov    %esi,%eax
  8014e7:	83 c4 10             	add    $0x10,%esp
  8014ea:	5b                   	pop    %ebx
  8014eb:	5e                   	pop    %esi
  8014ec:	5d                   	pop    %ebp
  8014ed:	c3                   	ret    

008014ee <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
  8014f1:	53                   	push   %ebx
  8014f2:	83 ec 24             	sub    $0x24,%esp
  8014f5:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8014f8:	8b 18                	mov    (%eax),%ebx
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).
 
         int perm = vpt[VPN(addr)] & 0xFFF;
  8014fa:	89 da                	mov    %ebx,%edx
  8014fc:	c1 ea 0c             	shr    $0xc,%edx
  8014ff:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx

static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
  801506:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80150a:	74 21                	je     80152d <pgfault+0x3f>
 
         int perm = vpt[VPN(addr)] & 0xFFF;
        if((err & FEC_WR)!=0)
           {
//              cprintf("\n>>>>>Due to write\n");
            if((perm & PTE_COW) == 0)
  80150c:	f6 c6 08             	test   $0x8,%dh
  80150f:	75 1c                	jne    80152d <pgfault+0x3f>
             {
                   panic("Not Set Cow");
  801511:	c7 44 24 08 76 32 80 	movl   $0x803276,0x8(%esp)
  801518:	00 
  801519:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801520:	00 
  801521:	c7 04 24 20 32 80 00 	movl   $0x803220,(%esp)
  801528:	e8 2b ed ff ff       	call   800258 <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
        if(sys_page_alloc(0,PFTEMP,PTE_P|PTE_U|PTE_W)<0)
  80152d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801534:	00 
  801535:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80153c:	00 
  80153d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801544:	e8 0d fc ff ff       	call   801156 <sys_page_alloc>
  801549:	85 c0                	test   %eax,%eax
  80154b:	79 1c                	jns    801569 <pgfault+0x7b>
              panic("\nPage not allocated\n");
  80154d:	c7 44 24 08 82 32 80 	movl   $0x803282,0x8(%esp)
  801554:	00 
  801555:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  80155c:	00 
  80155d:	c7 04 24 20 32 80 00 	movl   $0x803220,(%esp)
  801564:	e8 ef ec ff ff       	call   800258 <_panic>
           memmove(PFTEMP,ROUNDDOWN(addr,PGSIZE),PGSIZE);
  801569:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80156f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801576:	00 
  801577:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80157b:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801582:	e8 2e f6 ff ff       	call   800bb5 <memmove>
          if(sys_page_map(0,ROUNDDOWN(PFTEMP,PGSIZE),0,ROUNDDOWN(addr,PGSIZE),PTE_U|PTE_P|PTE_W)<0)
  801587:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80158e:	00 
  80158f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801593:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80159a:	00 
  80159b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8015a2:	00 
  8015a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015aa:	e8 49 fb ff ff       	call   8010f8 <sys_page_map>
  8015af:	85 c0                	test   %eax,%eax
  8015b1:	79 1c                	jns    8015cf <pgfault+0xe1>
                   panic("not mapped properly");
  8015b3:	c7 44 24 08 97 32 80 	movl   $0x803297,0x8(%esp)
  8015ba:	00 
  8015bb:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8015c2:	00 
  8015c3:	c7 04 24 20 32 80 00 	movl   $0x803220,(%esp)
  8015ca:	e8 89 ec ff ff       	call   800258 <_panic>
         if( 0 > sys_page_unmap(0, PFTEMP) )
  8015cf:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8015d6:	00 
  8015d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015de:	e8 b7 fa ff ff       	call   80109a <sys_page_unmap>
  8015e3:	85 c0                	test   %eax,%eax
  8015e5:	79 1c                	jns    801603 <pgfault+0x115>
                panic("sys_page_unmap failed\n");
  8015e7:	c7 44 24 08 ab 32 80 	movl   $0x8032ab,0x8(%esp)
  8015ee:	00 
  8015ef:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  8015f6:	00 
  8015f7:	c7 04 24 20 32 80 00 	movl   $0x803220,(%esp)
  8015fe:	e8 55 ec ff ff       	call   800258 <_panic>
   
//	panic("pgfault not implemented");
}
  801603:	83 c4 24             	add    $0x24,%esp
  801606:	5b                   	pop    %ebx
  801607:	5d                   	pop    %ebp
  801608:	c3                   	ret    
  801609:	00 00                	add    %al,(%eax)
  80160b:	00 00                	add    %al,(%eax)
  80160d:	00 00                	add    %al,(%eax)
	...

00801610 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
  801613:	8b 45 08             	mov    0x8(%ebp),%eax
  801616:	05 00 00 00 30       	add    $0x30000000,%eax
  80161b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80161e:	5d                   	pop    %ebp
  80161f:	c3                   	ret    

00801620 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801620:	55                   	push   %ebp
  801621:	89 e5                	mov    %esp,%ebp
  801623:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801626:	8b 45 08             	mov    0x8(%ebp),%eax
  801629:	89 04 24             	mov    %eax,(%esp)
  80162c:	e8 df ff ff ff       	call   801610 <fd2num>
  801631:	05 20 00 0d 00       	add    $0xd0020,%eax
  801636:	c1 e0 0c             	shl    $0xc,%eax
}
  801639:	c9                   	leave  
  80163a:	c3                   	ret    

0080163b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80163b:	55                   	push   %ebp
  80163c:	89 e5                	mov    %esp,%ebp
  80163e:	57                   	push   %edi
  80163f:	56                   	push   %esi
  801640:	53                   	push   %ebx
  801641:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801644:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801649:	a8 01                	test   $0x1,%al
  80164b:	74 36                	je     801683 <fd_alloc+0x48>
  80164d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801652:	a8 01                	test   $0x1,%al
  801654:	74 2d                	je     801683 <fd_alloc+0x48>
  801656:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80165b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801660:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801665:	89 c3                	mov    %eax,%ebx
  801667:	89 c2                	mov    %eax,%edx
  801669:	c1 ea 16             	shr    $0x16,%edx
  80166c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80166f:	f6 c2 01             	test   $0x1,%dl
  801672:	74 14                	je     801688 <fd_alloc+0x4d>
  801674:	89 c2                	mov    %eax,%edx
  801676:	c1 ea 0c             	shr    $0xc,%edx
  801679:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80167c:	f6 c2 01             	test   $0x1,%dl
  80167f:	75 10                	jne    801691 <fd_alloc+0x56>
  801681:	eb 05                	jmp    801688 <fd_alloc+0x4d>
  801683:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801688:	89 1f                	mov    %ebx,(%edi)
  80168a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80168f:	eb 17                	jmp    8016a8 <fd_alloc+0x6d>
  801691:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801696:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80169b:	75 c8                	jne    801665 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80169d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8016a3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8016a8:	5b                   	pop    %ebx
  8016a9:	5e                   	pop    %esi
  8016aa:	5f                   	pop    %edi
  8016ab:	5d                   	pop    %ebp
  8016ac:	c3                   	ret    

008016ad <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8016b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b3:	83 f8 1f             	cmp    $0x1f,%eax
  8016b6:	77 36                	ja     8016ee <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8016b8:	05 00 00 0d 00       	add    $0xd0000,%eax
  8016bd:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8016c0:	89 c2                	mov    %eax,%edx
  8016c2:	c1 ea 16             	shr    $0x16,%edx
  8016c5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8016cc:	f6 c2 01             	test   $0x1,%dl
  8016cf:	74 1d                	je     8016ee <fd_lookup+0x41>
  8016d1:	89 c2                	mov    %eax,%edx
  8016d3:	c1 ea 0c             	shr    $0xc,%edx
  8016d6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016dd:	f6 c2 01             	test   $0x1,%dl
  8016e0:	74 0c                	je     8016ee <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e5:	89 02                	mov    %eax,(%edx)
  8016e7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8016ec:	eb 05                	jmp    8016f3 <fd_lookup+0x46>
  8016ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016f3:	5d                   	pop    %ebp
  8016f4:	c3                   	ret    

008016f5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8016f5:	55                   	push   %ebp
  8016f6:	89 e5                	mov    %esp,%ebp
  8016f8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016fb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8016fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801702:	8b 45 08             	mov    0x8(%ebp),%eax
  801705:	89 04 24             	mov    %eax,(%esp)
  801708:	e8 a0 ff ff ff       	call   8016ad <fd_lookup>
  80170d:	85 c0                	test   %eax,%eax
  80170f:	78 0e                	js     80171f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801711:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801714:	8b 55 0c             	mov    0xc(%ebp),%edx
  801717:	89 50 04             	mov    %edx,0x4(%eax)
  80171a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
  801724:	56                   	push   %esi
  801725:	53                   	push   %ebx
  801726:	83 ec 10             	sub    $0x10,%esp
  801729:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80172c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80172f:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801734:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801739:	be 44 33 80 00       	mov    $0x803344,%esi
		if (devtab[i]->dev_id == dev_id) {
  80173e:	39 08                	cmp    %ecx,(%eax)
  801740:	75 10                	jne    801752 <dev_lookup+0x31>
  801742:	eb 04                	jmp    801748 <dev_lookup+0x27>
  801744:	39 08                	cmp    %ecx,(%eax)
  801746:	75 0a                	jne    801752 <dev_lookup+0x31>
			*dev = devtab[i];
  801748:	89 03                	mov    %eax,(%ebx)
  80174a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80174f:	90                   	nop
  801750:	eb 31                	jmp    801783 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801752:	83 c2 01             	add    $0x1,%edx
  801755:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801758:	85 c0                	test   %eax,%eax
  80175a:	75 e8                	jne    801744 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80175c:	a1 74 70 80 00       	mov    0x807074,%eax
  801761:	8b 40 4c             	mov    0x4c(%eax),%eax
  801764:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801768:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176c:	c7 04 24 c4 32 80 00 	movl   $0x8032c4,(%esp)
  801773:	e8 a5 eb ff ff       	call   80031d <cprintf>
	*dev = 0;
  801778:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80177e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	5b                   	pop    %ebx
  801787:	5e                   	pop    %esi
  801788:	5d                   	pop    %ebp
  801789:	c3                   	ret    

0080178a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80178a:	55                   	push   %ebp
  80178b:	89 e5                	mov    %esp,%ebp
  80178d:	53                   	push   %ebx
  80178e:	83 ec 24             	sub    $0x24,%esp
  801791:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801794:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801797:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	89 04 24             	mov    %eax,(%esp)
  8017a1:	e8 07 ff ff ff       	call   8016ad <fd_lookup>
  8017a6:	85 c0                	test   %eax,%eax
  8017a8:	78 53                	js     8017fd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b4:	8b 00                	mov    (%eax),%eax
  8017b6:	89 04 24             	mov    %eax,(%esp)
  8017b9:	e8 63 ff ff ff       	call   801721 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017be:	85 c0                	test   %eax,%eax
  8017c0:	78 3b                	js     8017fd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8017c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ca:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8017ce:	74 2d                	je     8017fd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017d0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017d3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017da:	00 00 00 
	stat->st_isdir = 0;
  8017dd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017e4:	00 00 00 
	stat->st_dev = dev;
  8017e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ea:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017f7:	89 14 24             	mov    %edx,(%esp)
  8017fa:	ff 50 14             	call   *0x14(%eax)
}
  8017fd:	83 c4 24             	add    $0x24,%esp
  801800:	5b                   	pop    %ebx
  801801:	5d                   	pop    %ebp
  801802:	c3                   	ret    

00801803 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	53                   	push   %ebx
  801807:	83 ec 24             	sub    $0x24,%esp
  80180a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80180d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801810:	89 44 24 04          	mov    %eax,0x4(%esp)
  801814:	89 1c 24             	mov    %ebx,(%esp)
  801817:	e8 91 fe ff ff       	call   8016ad <fd_lookup>
  80181c:	85 c0                	test   %eax,%eax
  80181e:	78 5f                	js     80187f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801820:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801823:	89 44 24 04          	mov    %eax,0x4(%esp)
  801827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182a:	8b 00                	mov    (%eax),%eax
  80182c:	89 04 24             	mov    %eax,(%esp)
  80182f:	e8 ed fe ff ff       	call   801721 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801834:	85 c0                	test   %eax,%eax
  801836:	78 47                	js     80187f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801838:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80183b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80183f:	75 23                	jne    801864 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801841:	a1 74 70 80 00       	mov    0x807074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801846:	8b 40 4c             	mov    0x4c(%eax),%eax
  801849:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80184d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801851:	c7 04 24 e4 32 80 00 	movl   $0x8032e4,(%esp)
  801858:	e8 c0 ea ff ff       	call   80031d <cprintf>
  80185d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801862:	eb 1b                	jmp    80187f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801864:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801867:	8b 48 18             	mov    0x18(%eax),%ecx
  80186a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80186f:	85 c9                	test   %ecx,%ecx
  801871:	74 0c                	je     80187f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801873:	8b 45 0c             	mov    0xc(%ebp),%eax
  801876:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187a:	89 14 24             	mov    %edx,(%esp)
  80187d:	ff d1                	call   *%ecx
}
  80187f:	83 c4 24             	add    $0x24,%esp
  801882:	5b                   	pop    %ebx
  801883:	5d                   	pop    %ebp
  801884:	c3                   	ret    

00801885 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801885:	55                   	push   %ebp
  801886:	89 e5                	mov    %esp,%ebp
  801888:	53                   	push   %ebx
  801889:	83 ec 24             	sub    $0x24,%esp
  80188c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80188f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801892:	89 44 24 04          	mov    %eax,0x4(%esp)
  801896:	89 1c 24             	mov    %ebx,(%esp)
  801899:	e8 0f fe ff ff       	call   8016ad <fd_lookup>
  80189e:	85 c0                	test   %eax,%eax
  8018a0:	78 66                	js     801908 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ac:	8b 00                	mov    (%eax),%eax
  8018ae:	89 04 24             	mov    %eax,(%esp)
  8018b1:	e8 6b fe ff ff       	call   801721 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018b6:	85 c0                	test   %eax,%eax
  8018b8:	78 4e                	js     801908 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018bd:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8018c1:	75 23                	jne    8018e6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8018c3:	a1 74 70 80 00       	mov    0x807074,%eax
  8018c8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8018cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d3:	c7 04 24 08 33 80 00 	movl   $0x803308,(%esp)
  8018da:	e8 3e ea ff ff       	call   80031d <cprintf>
  8018df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8018e4:	eb 22                	jmp    801908 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018e9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8018ec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018f1:	85 c9                	test   %ecx,%ecx
  8018f3:	74 13                	je     801908 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801903:	89 14 24             	mov    %edx,(%esp)
  801906:	ff d1                	call   *%ecx
}
  801908:	83 c4 24             	add    $0x24,%esp
  80190b:	5b                   	pop    %ebx
  80190c:	5d                   	pop    %ebp
  80190d:	c3                   	ret    

0080190e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	53                   	push   %ebx
  801912:	83 ec 24             	sub    $0x24,%esp
  801915:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801918:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80191b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80191f:	89 1c 24             	mov    %ebx,(%esp)
  801922:	e8 86 fd ff ff       	call   8016ad <fd_lookup>
  801927:	85 c0                	test   %eax,%eax
  801929:	78 6b                	js     801996 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80192b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80192e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801932:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801935:	8b 00                	mov    (%eax),%eax
  801937:	89 04 24             	mov    %eax,(%esp)
  80193a:	e8 e2 fd ff ff       	call   801721 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80193f:	85 c0                	test   %eax,%eax
  801941:	78 53                	js     801996 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801943:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801946:	8b 42 08             	mov    0x8(%edx),%eax
  801949:	83 e0 03             	and    $0x3,%eax
  80194c:	83 f8 01             	cmp    $0x1,%eax
  80194f:	75 23                	jne    801974 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801951:	a1 74 70 80 00       	mov    0x807074,%eax
  801956:	8b 40 4c             	mov    0x4c(%eax),%eax
  801959:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80195d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801961:	c7 04 24 25 33 80 00 	movl   $0x803325,(%esp)
  801968:	e8 b0 e9 ff ff       	call   80031d <cprintf>
  80196d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801972:	eb 22                	jmp    801996 <read+0x88>
	}
	if (!dev->dev_read)
  801974:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801977:	8b 48 08             	mov    0x8(%eax),%ecx
  80197a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80197f:	85 c9                	test   %ecx,%ecx
  801981:	74 13                	je     801996 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801983:	8b 45 10             	mov    0x10(%ebp),%eax
  801986:	89 44 24 08          	mov    %eax,0x8(%esp)
  80198a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80198d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801991:	89 14 24             	mov    %edx,(%esp)
  801994:	ff d1                	call   *%ecx
}
  801996:	83 c4 24             	add    $0x24,%esp
  801999:	5b                   	pop    %ebx
  80199a:	5d                   	pop    %ebp
  80199b:	c3                   	ret    

0080199c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80199c:	55                   	push   %ebp
  80199d:	89 e5                	mov    %esp,%ebp
  80199f:	57                   	push   %edi
  8019a0:	56                   	push   %esi
  8019a1:	53                   	push   %ebx
  8019a2:	83 ec 1c             	sub    $0x1c,%esp
  8019a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8019a8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8019b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8019ba:	85 f6                	test   %esi,%esi
  8019bc:	74 29                	je     8019e7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8019be:	89 f0                	mov    %esi,%eax
  8019c0:	29 d0                	sub    %edx,%eax
  8019c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019c6:	03 55 0c             	add    0xc(%ebp),%edx
  8019c9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019cd:	89 3c 24             	mov    %edi,(%esp)
  8019d0:	e8 39 ff ff ff       	call   80190e <read>
		if (m < 0)
  8019d5:	85 c0                	test   %eax,%eax
  8019d7:	78 0e                	js     8019e7 <readn+0x4b>
			return m;
		if (m == 0)
  8019d9:	85 c0                	test   %eax,%eax
  8019db:	74 08                	je     8019e5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019dd:	01 c3                	add    %eax,%ebx
  8019df:	89 da                	mov    %ebx,%edx
  8019e1:	39 f3                	cmp    %esi,%ebx
  8019e3:	72 d9                	jb     8019be <readn+0x22>
  8019e5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8019e7:	83 c4 1c             	add    $0x1c,%esp
  8019ea:	5b                   	pop    %ebx
  8019eb:	5e                   	pop    %esi
  8019ec:	5f                   	pop    %edi
  8019ed:	5d                   	pop    %ebp
  8019ee:	c3                   	ret    

008019ef <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8019ef:	55                   	push   %ebp
  8019f0:	89 e5                	mov    %esp,%ebp
  8019f2:	56                   	push   %esi
  8019f3:	53                   	push   %ebx
  8019f4:	83 ec 20             	sub    $0x20,%esp
  8019f7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8019fa:	89 34 24             	mov    %esi,(%esp)
  8019fd:	e8 0e fc ff ff       	call   801610 <fd2num>
  801a02:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801a05:	89 54 24 04          	mov    %edx,0x4(%esp)
  801a09:	89 04 24             	mov    %eax,(%esp)
  801a0c:	e8 9c fc ff ff       	call   8016ad <fd_lookup>
  801a11:	89 c3                	mov    %eax,%ebx
  801a13:	85 c0                	test   %eax,%eax
  801a15:	78 05                	js     801a1c <fd_close+0x2d>
  801a17:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801a1a:	74 0c                	je     801a28 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801a1c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801a20:	19 c0                	sbb    %eax,%eax
  801a22:	f7 d0                	not    %eax
  801a24:	21 c3                	and    %eax,%ebx
  801a26:	eb 3d                	jmp    801a65 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801a28:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a2f:	8b 06                	mov    (%esi),%eax
  801a31:	89 04 24             	mov    %eax,(%esp)
  801a34:	e8 e8 fc ff ff       	call   801721 <dev_lookup>
  801a39:	89 c3                	mov    %eax,%ebx
  801a3b:	85 c0                	test   %eax,%eax
  801a3d:	78 16                	js     801a55 <fd_close+0x66>
		if (dev->dev_close)
  801a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a42:	8b 40 10             	mov    0x10(%eax),%eax
  801a45:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a4a:	85 c0                	test   %eax,%eax
  801a4c:	74 07                	je     801a55 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801a4e:	89 34 24             	mov    %esi,(%esp)
  801a51:	ff d0                	call   *%eax
  801a53:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801a55:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a60:	e8 35 f6 ff ff       	call   80109a <sys_page_unmap>
	return r;
}
  801a65:	89 d8                	mov    %ebx,%eax
  801a67:	83 c4 20             	add    $0x20,%esp
  801a6a:	5b                   	pop    %ebx
  801a6b:	5e                   	pop    %esi
  801a6c:	5d                   	pop    %ebp
  801a6d:	c3                   	ret    

00801a6e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
  801a71:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a77:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7e:	89 04 24             	mov    %eax,(%esp)
  801a81:	e8 27 fc ff ff       	call   8016ad <fd_lookup>
  801a86:	85 c0                	test   %eax,%eax
  801a88:	78 13                	js     801a9d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801a8a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801a91:	00 
  801a92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a95:	89 04 24             	mov    %eax,(%esp)
  801a98:	e8 52 ff ff ff       	call   8019ef <fd_close>
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
  801aa2:	83 ec 18             	sub    $0x18,%esp
  801aa5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801aa8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801aab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ab2:	00 
  801ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab6:	89 04 24             	mov    %eax,(%esp)
  801ab9:	e8 a9 03 00 00       	call   801e67 <open>
  801abe:	89 c3                	mov    %eax,%ebx
  801ac0:	85 c0                	test   %eax,%eax
  801ac2:	78 1b                	js     801adf <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801acb:	89 1c 24             	mov    %ebx,(%esp)
  801ace:	e8 b7 fc ff ff       	call   80178a <fstat>
  801ad3:	89 c6                	mov    %eax,%esi
	close(fd);
  801ad5:	89 1c 24             	mov    %ebx,(%esp)
  801ad8:	e8 91 ff ff ff       	call   801a6e <close>
  801add:	89 f3                	mov    %esi,%ebx
	return r;
}
  801adf:	89 d8                	mov    %ebx,%eax
  801ae1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ae4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ae7:	89 ec                	mov    %ebp,%esp
  801ae9:	5d                   	pop    %ebp
  801aea:	c3                   	ret    

00801aeb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	53                   	push   %ebx
  801aef:	83 ec 14             	sub    $0x14,%esp
  801af2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801af7:	89 1c 24             	mov    %ebx,(%esp)
  801afa:	e8 6f ff ff ff       	call   801a6e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801aff:	83 c3 01             	add    $0x1,%ebx
  801b02:	83 fb 20             	cmp    $0x20,%ebx
  801b05:	75 f0                	jne    801af7 <close_all+0xc>
		close(i);
}
  801b07:	83 c4 14             	add    $0x14,%esp
  801b0a:	5b                   	pop    %ebx
  801b0b:	5d                   	pop    %ebp
  801b0c:	c3                   	ret    

00801b0d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	83 ec 58             	sub    $0x58,%esp
  801b13:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801b16:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801b19:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801b1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801b1f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801b22:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	89 04 24             	mov    %eax,(%esp)
  801b2c:	e8 7c fb ff ff       	call   8016ad <fd_lookup>
  801b31:	89 c3                	mov    %eax,%ebx
  801b33:	85 c0                	test   %eax,%eax
  801b35:	0f 88 e0 00 00 00    	js     801c1b <dup+0x10e>
		return r;
	close(newfdnum);
  801b3b:	89 3c 24             	mov    %edi,(%esp)
  801b3e:	e8 2b ff ff ff       	call   801a6e <close>

	newfd = INDEX2FD(newfdnum);
  801b43:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801b49:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801b4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b4f:	89 04 24             	mov    %eax,(%esp)
  801b52:	e8 c9 fa ff ff       	call   801620 <fd2data>
  801b57:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801b59:	89 34 24             	mov    %esi,(%esp)
  801b5c:	e8 bf fa ff ff       	call   801620 <fd2data>
  801b61:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801b64:	89 da                	mov    %ebx,%edx
  801b66:	89 d8                	mov    %ebx,%eax
  801b68:	c1 e8 16             	shr    $0x16,%eax
  801b6b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b72:	a8 01                	test   $0x1,%al
  801b74:	74 43                	je     801bb9 <dup+0xac>
  801b76:	c1 ea 0c             	shr    $0xc,%edx
  801b79:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801b80:	a8 01                	test   $0x1,%al
  801b82:	74 35                	je     801bb9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801b84:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801b8b:	25 07 0e 00 00       	and    $0xe07,%eax
  801b90:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ba2:	00 
  801ba3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ba7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bae:	e8 45 f5 ff ff       	call   8010f8 <sys_page_map>
  801bb3:	89 c3                	mov    %eax,%ebx
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	78 3f                	js     801bf8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801bb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bbc:	89 c2                	mov    %eax,%edx
  801bbe:	c1 ea 0c             	shr    $0xc,%edx
  801bc1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801bc8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801bce:	89 54 24 10          	mov    %edx,0x10(%esp)
  801bd2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801bd6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bdd:	00 
  801bde:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801be9:	e8 0a f5 ff ff       	call   8010f8 <sys_page_map>
  801bee:	89 c3                	mov    %eax,%ebx
  801bf0:	85 c0                	test   %eax,%eax
  801bf2:	78 04                	js     801bf8 <dup+0xeb>
  801bf4:	89 fb                	mov    %edi,%ebx
  801bf6:	eb 23                	jmp    801c1b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801bf8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bfc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c03:	e8 92 f4 ff ff       	call   80109a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801c08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c16:	e8 7f f4 ff ff       	call   80109a <sys_page_unmap>
	return r;
}
  801c1b:	89 d8                	mov    %ebx,%eax
  801c1d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c20:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c23:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c26:	89 ec                	mov    %ebp,%esp
  801c28:	5d                   	pop    %ebp
  801c29:	c3                   	ret    
	...

00801c2c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
  801c2f:	53                   	push   %ebx
  801c30:	83 ec 14             	sub    $0x14,%esp
  801c33:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c35:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801c3b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c42:	00 
  801c43:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801c4a:	00 
  801c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c4f:	89 14 24             	mov    %edx,(%esp)
  801c52:	e8 f9 0d 00 00       	call   802a50 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c57:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c5e:	00 
  801c5f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c63:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c6a:	e8 43 0e 00 00       	call   802ab2 <ipc_recv>
}
  801c6f:	83 c4 14             	add    $0x14,%esp
  801c72:	5b                   	pop    %ebx
  801c73:	5d                   	pop    %ebp
  801c74:	c3                   	ret    

00801c75 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
  801c78:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	8b 40 0c             	mov    0xc(%eax),%eax
  801c81:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c89:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c93:	b8 02 00 00 00       	mov    $0x2,%eax
  801c98:	e8 8f ff ff ff       	call   801c2c <fsipc>
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ca5:	ba 00 00 00 00       	mov    $0x0,%edx
  801caa:	b8 08 00 00 00       	mov    $0x8,%eax
  801caf:	e8 78 ff ff ff       	call   801c2c <fsipc>
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
  801cb9:	53                   	push   %ebx
  801cba:	83 ec 14             	sub    $0x14,%esp
  801cbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc3:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc6:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801ccb:	ba 00 00 00 00       	mov    $0x0,%edx
  801cd0:	b8 05 00 00 00       	mov    $0x5,%eax
  801cd5:	e8 52 ff ff ff       	call   801c2c <fsipc>
  801cda:	85 c0                	test   %eax,%eax
  801cdc:	78 2b                	js     801d09 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cde:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801ce5:	00 
  801ce6:	89 1c 24             	mov    %ebx,(%esp)
  801ce9:	e8 0c ed ff ff       	call   8009fa <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cee:	a1 80 40 80 00       	mov    0x804080,%eax
  801cf3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cf9:	a1 84 40 80 00       	mov    0x804084,%eax
  801cfe:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801d04:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801d09:	83 c4 14             	add    $0x14,%esp
  801d0c:	5b                   	pop    %ebx
  801d0d:	5d                   	pop    %ebp
  801d0e:	c3                   	ret    

00801d0f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  801d15:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801d1c:	00 
  801d1d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d24:	00 
  801d25:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801d2c:	e8 25 ee ff ff       	call   800b56 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d31:	8b 45 08             	mov    0x8(%ebp),%eax
  801d34:	8b 40 0c             	mov    0xc(%eax),%eax
  801d37:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801d3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d41:	b8 06 00 00 00       	mov    $0x6,%eax
  801d46:	e8 e1 fe ff ff       	call   801c2c <fsipc>
}
  801d4b:	c9                   	leave  
  801d4c:	c3                   	ret    

00801d4d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801d4d:	55                   	push   %ebp
  801d4e:	89 e5                	mov    %esp,%ebp
  801d50:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801d53:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801d5a:	00 
  801d5b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d62:	00 
  801d63:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801d6a:	e8 e7 ed ff ff       	call   800b56 <memset>
  801d6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d72:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801d77:	76 05                	jbe    801d7e <devfile_write+0x31>
  801d79:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d7e:	8b 55 08             	mov    0x8(%ebp),%edx
  801d81:	8b 52 0c             	mov    0xc(%edx),%edx
  801d84:	89 15 00 40 80 00    	mov    %edx,0x804000
        fsipcbuf.write.req_n = numberOfBytes;
  801d8a:	a3 04 40 80 00       	mov    %eax,0x804004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  801d8f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d96:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d9a:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801da1:	e8 0f ee ff ff       	call   800bb5 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  801da6:	ba 00 00 00 00       	mov    $0x0,%edx
  801dab:	b8 04 00 00 00       	mov    $0x4,%eax
  801db0:	e8 77 fe ff ff       	call   801c2c <fsipc>
              return r;
        return r;
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
  801dba:	53                   	push   %ebx
  801dbb:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  801dbe:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801dc5:	00 
  801dc6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801dcd:	00 
  801dce:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801dd5:	e8 7c ed ff ff       	call   800b56 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  801dda:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddd:	8b 40 0c             	mov    0xc(%eax),%eax
  801de0:	a3 00 40 80 00       	mov    %eax,0x804000
        fsipcbuf.read.req_n = n;
  801de5:	8b 45 10             	mov    0x10(%ebp),%eax
  801de8:	a3 04 40 80 00       	mov    %eax,0x804004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  801ded:	ba 00 00 00 00       	mov    $0x0,%edx
  801df2:	b8 03 00 00 00       	mov    $0x3,%eax
  801df7:	e8 30 fe ff ff       	call   801c2c <fsipc>
  801dfc:	89 c3                	mov    %eax,%ebx
  801dfe:	85 c0                	test   %eax,%eax
  801e00:	78 17                	js     801e19 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  801e02:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e06:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801e0d:	00 
  801e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e11:	89 04 24             	mov    %eax,(%esp)
  801e14:	e8 9c ed ff ff       	call   800bb5 <memmove>
        return r;
}
  801e19:	89 d8                	mov    %ebx,%eax
  801e1b:	83 c4 14             	add    $0x14,%esp
  801e1e:	5b                   	pop    %ebx
  801e1f:	5d                   	pop    %ebp
  801e20:	c3                   	ret    

00801e21 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	53                   	push   %ebx
  801e25:	83 ec 14             	sub    $0x14,%esp
  801e28:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801e2b:	89 1c 24             	mov    %ebx,(%esp)
  801e2e:	e8 7d eb ff ff       	call   8009b0 <strlen>
  801e33:	89 c2                	mov    %eax,%edx
  801e35:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801e3a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801e40:	7f 1f                	jg     801e61 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801e42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e46:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e4d:	e8 a8 eb ff ff       	call   8009fa <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801e52:	ba 00 00 00 00       	mov    $0x0,%edx
  801e57:	b8 07 00 00 00       	mov    $0x7,%eax
  801e5c:	e8 cb fd ff ff       	call   801c2c <fsipc>
}
  801e61:	83 c4 14             	add    $0x14,%esp
  801e64:	5b                   	pop    %ebx
  801e65:	5d                   	pop    %ebp
  801e66:	c3                   	ret    

00801e67 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  801e67:	55                   	push   %ebp
  801e68:	89 e5                	mov    %esp,%ebp
  801e6a:	56                   	push   %esi
  801e6b:	53                   	push   %ebx
  801e6c:	83 ec 20             	sub    $0x20,%esp
  801e6f:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  801e72:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801e79:	00 
  801e7a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e81:	00 
  801e82:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e89:	e8 c8 ec ff ff       	call   800b56 <memset>
    if(strlen(path)>=MAXPATHLEN)
  801e8e:	89 34 24             	mov    %esi,(%esp)
  801e91:	e8 1a eb ff ff       	call   8009b0 <strlen>
  801e96:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e9b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ea0:	0f 8f 84 00 00 00    	jg     801f2a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  801ea6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ea9:	89 04 24             	mov    %eax,(%esp)
  801eac:	e8 8a f7 ff ff       	call   80163b <fd_alloc>
  801eb1:	89 c3                	mov    %eax,%ebx
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	78 73                	js     801f2a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  801eb7:	0f b6 06             	movzbl (%esi),%eax
  801eba:	84 c0                	test   %al,%al
  801ebc:	74 20                	je     801ede <open+0x77>
  801ebe:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  801ec0:	0f be c0             	movsbl %al,%eax
  801ec3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ec7:	c7 04 24 58 33 80 00 	movl   $0x803358,(%esp)
  801ece:	e8 4a e4 ff ff       	call   80031d <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  801ed3:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  801ed7:	83 c3 01             	add    $0x1,%ebx
  801eda:	84 c0                	test   %al,%al
  801edc:	75 e2                	jne    801ec0 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  801ede:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ee2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801ee9:	e8 0c eb ff ff       	call   8009fa <strcpy>
    fsipcbuf.open.req_omode = mode;
  801eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef1:	a3 00 44 80 00       	mov    %eax,0x804400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  801ef6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef9:	b8 01 00 00 00       	mov    $0x1,%eax
  801efe:	e8 29 fd ff ff       	call   801c2c <fsipc>
  801f03:	89 c3                	mov    %eax,%ebx
  801f05:	85 c0                	test   %eax,%eax
  801f07:	79 15                	jns    801f1e <open+0xb7>
        {
            fd_close(fd,1);
  801f09:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801f10:	00 
  801f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f14:	89 04 24             	mov    %eax,(%esp)
  801f17:	e8 d3 fa ff ff       	call   8019ef <fd_close>
             return r;
  801f1c:	eb 0c                	jmp    801f2a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  801f1e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801f21:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  801f27:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  801f2a:	89 d8                	mov    %ebx,%eax
  801f2c:	83 c4 20             	add    $0x20,%esp
  801f2f:	5b                   	pop    %ebx
  801f30:	5e                   	pop    %esi
  801f31:	5d                   	pop    %ebp
  801f32:	c3                   	ret    
	...

00801f40 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801f46:	c7 44 24 04 5b 33 80 	movl   $0x80335b,0x4(%esp)
  801f4d:	00 
  801f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f51:	89 04 24             	mov    %eax,(%esp)
  801f54:	e8 a1 ea ff ff       	call   8009fa <strcpy>
	return 0;
}
  801f59:	b8 00 00 00 00       	mov    $0x0,%eax
  801f5e:	c9                   	leave  
  801f5f:	c3                   	ret    

00801f60 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801f60:	55                   	push   %ebp
  801f61:	89 e5                	mov    %esp,%ebp
  801f63:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801f66:	8b 45 08             	mov    0x8(%ebp),%eax
  801f69:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6c:	89 04 24             	mov    %eax,(%esp)
  801f6f:	e8 9e 02 00 00       	call   802212 <nsipc_close>
}
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801f7c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f83:	00 
  801f84:	8b 45 10             	mov    0x10(%ebp),%eax
  801f87:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	8b 40 0c             	mov    0xc(%eax),%eax
  801f98:	89 04 24             	mov    %eax,(%esp)
  801f9b:	e8 ae 02 00 00       	call   80224e <nsipc_send>
}
  801fa0:	c9                   	leave  
  801fa1:	c3                   	ret    

00801fa2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801fa2:	55                   	push   %ebp
  801fa3:	89 e5                	mov    %esp,%ebp
  801fa5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801fa8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801faf:	00 
  801fb0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fba:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc4:	89 04 24             	mov    %eax,(%esp)
  801fc7:	e8 f5 02 00 00       	call   8022c1 <nsipc_recv>
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	56                   	push   %esi
  801fd2:	53                   	push   %ebx
  801fd3:	83 ec 20             	sub    $0x20,%esp
  801fd6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801fd8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fdb:	89 04 24             	mov    %eax,(%esp)
  801fde:	e8 58 f6 ff ff       	call   80163b <fd_alloc>
  801fe3:	89 c3                	mov    %eax,%ebx
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	78 21                	js     80200a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801fe9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801ff0:	00 
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fff:	e8 52 f1 ff ff       	call   801156 <sys_page_alloc>
  802004:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802006:	85 c0                	test   %eax,%eax
  802008:	79 0a                	jns    802014 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80200a:	89 34 24             	mov    %esi,(%esp)
  80200d:	e8 00 02 00 00       	call   802212 <nsipc_close>
		return r;
  802012:	eb 28                	jmp    80203c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802014:	8b 15 20 70 80 00    	mov    0x807020,%edx
  80201a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80201f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802022:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80202f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802032:	89 04 24             	mov    %eax,(%esp)
  802035:	e8 d6 f5 ff ff       	call   801610 <fd2num>
  80203a:	89 c3                	mov    %eax,%ebx
}
  80203c:	89 d8                	mov    %ebx,%eax
  80203e:	83 c4 20             	add    $0x20,%esp
  802041:	5b                   	pop    %ebx
  802042:	5e                   	pop    %esi
  802043:	5d                   	pop    %ebp
  802044:	c3                   	ret    

00802045 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802045:	55                   	push   %ebp
  802046:	89 e5                	mov    %esp,%ebp
  802048:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80204b:	8b 45 10             	mov    0x10(%ebp),%eax
  80204e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802052:	8b 45 0c             	mov    0xc(%ebp),%eax
  802055:	89 44 24 04          	mov    %eax,0x4(%esp)
  802059:	8b 45 08             	mov    0x8(%ebp),%eax
  80205c:	89 04 24             	mov    %eax,(%esp)
  80205f:	e8 62 01 00 00       	call   8021c6 <nsipc_socket>
  802064:	85 c0                	test   %eax,%eax
  802066:	78 05                	js     80206d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802068:	e8 61 ff ff ff       	call   801fce <alloc_sockfd>
}
  80206d:	c9                   	leave  
  80206e:	66 90                	xchg   %ax,%ax
  802070:	c3                   	ret    

00802071 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802077:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80207a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80207e:	89 04 24             	mov    %eax,(%esp)
  802081:	e8 27 f6 ff ff       	call   8016ad <fd_lookup>
  802086:	85 c0                	test   %eax,%eax
  802088:	78 15                	js     80209f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80208a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208d:	8b 0a                	mov    (%edx),%ecx
  80208f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802094:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  80209a:	75 03                	jne    80209f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80209c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  80209f:	c9                   	leave  
  8020a0:	c3                   	ret    

008020a1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8020a1:	55                   	push   %ebp
  8020a2:	89 e5                	mov    %esp,%ebp
  8020a4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8020aa:	e8 c2 ff ff ff       	call   802071 <fd2sockid>
  8020af:	85 c0                	test   %eax,%eax
  8020b1:	78 0f                	js     8020c2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8020b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020ba:	89 04 24             	mov    %eax,(%esp)
  8020bd:	e8 2e 01 00 00       	call   8021f0 <nsipc_listen>
}
  8020c2:	c9                   	leave  
  8020c3:	c3                   	ret    

008020c4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020c4:	55                   	push   %ebp
  8020c5:	89 e5                	mov    %esp,%ebp
  8020c7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8020cd:	e8 9f ff ff ff       	call   802071 <fd2sockid>
  8020d2:	85 c0                	test   %eax,%eax
  8020d4:	78 16                	js     8020ec <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8020d6:	8b 55 10             	mov    0x10(%ebp),%edx
  8020d9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020e4:	89 04 24             	mov    %eax,(%esp)
  8020e7:	e8 55 02 00 00       	call   802341 <nsipc_connect>
}
  8020ec:	c9                   	leave  
  8020ed:	c3                   	ret    

008020ee <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8020ee:	55                   	push   %ebp
  8020ef:	89 e5                	mov    %esp,%ebp
  8020f1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f7:	e8 75 ff ff ff       	call   802071 <fd2sockid>
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	78 0f                	js     80210f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802100:	8b 55 0c             	mov    0xc(%ebp),%edx
  802103:	89 54 24 04          	mov    %edx,0x4(%esp)
  802107:	89 04 24             	mov    %eax,(%esp)
  80210a:	e8 1d 01 00 00       	call   80222c <nsipc_shutdown>
}
  80210f:	c9                   	leave  
  802110:	c3                   	ret    

00802111 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802111:	55                   	push   %ebp
  802112:	89 e5                	mov    %esp,%ebp
  802114:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	e8 52 ff ff ff       	call   802071 <fd2sockid>
  80211f:	85 c0                	test   %eax,%eax
  802121:	78 16                	js     802139 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802123:	8b 55 10             	mov    0x10(%ebp),%edx
  802126:	89 54 24 08          	mov    %edx,0x8(%esp)
  80212a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80212d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802131:	89 04 24             	mov    %eax,(%esp)
  802134:	e8 47 02 00 00       	call   802380 <nsipc_bind>
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802141:	8b 45 08             	mov    0x8(%ebp),%eax
  802144:	e8 28 ff ff ff       	call   802071 <fd2sockid>
  802149:	85 c0                	test   %eax,%eax
  80214b:	78 1f                	js     80216c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80214d:	8b 55 10             	mov    0x10(%ebp),%edx
  802150:	89 54 24 08          	mov    %edx,0x8(%esp)
  802154:	8b 55 0c             	mov    0xc(%ebp),%edx
  802157:	89 54 24 04          	mov    %edx,0x4(%esp)
  80215b:	89 04 24             	mov    %eax,(%esp)
  80215e:	e8 5c 02 00 00       	call   8023bf <nsipc_accept>
  802163:	85 c0                	test   %eax,%eax
  802165:	78 05                	js     80216c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802167:	e8 62 fe ff ff       	call   801fce <alloc_sockfd>
}
  80216c:	c9                   	leave  
  80216d:	8d 76 00             	lea    0x0(%esi),%esi
  802170:	c3                   	ret    
	...

00802180 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802180:	55                   	push   %ebp
  802181:	89 e5                	mov    %esp,%ebp
  802183:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802186:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  80218c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802193:	00 
  802194:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80219b:	00 
  80219c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a0:	89 14 24             	mov    %edx,(%esp)
  8021a3:	e8 a8 08 00 00       	call   802a50 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8021a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021af:	00 
  8021b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8021b7:	00 
  8021b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021bf:	e8 ee 08 00 00       	call   802ab2 <ipc_recv>
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
  8021c9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8021d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021d7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8021dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8021df:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8021e4:	b8 09 00 00 00       	mov    $0x9,%eax
  8021e9:	e8 92 ff ff ff       	call   802180 <nsipc>
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
  8021f3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8021f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8021fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802201:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802206:	b8 06 00 00 00       	mov    $0x6,%eax
  80220b:	e8 70 ff ff ff       	call   802180 <nsipc>
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
  802215:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802218:	8b 45 08             	mov    0x8(%ebp),%eax
  80221b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802220:	b8 04 00 00 00       	mov    $0x4,%eax
  802225:	e8 56 ff ff ff       	call   802180 <nsipc>
}
  80222a:	c9                   	leave  
  80222b:	c3                   	ret    

0080222c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80222c:	55                   	push   %ebp
  80222d:	89 e5                	mov    %esp,%ebp
  80222f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80223a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80223d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802242:	b8 03 00 00 00       	mov    $0x3,%eax
  802247:	e8 34 ff ff ff       	call   802180 <nsipc>
}
  80224c:	c9                   	leave  
  80224d:	c3                   	ret    

0080224e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80224e:	55                   	push   %ebp
  80224f:	89 e5                	mov    %esp,%ebp
  802251:	53                   	push   %ebx
  802252:	83 ec 14             	sub    $0x14,%esp
  802255:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802260:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802266:	7e 24                	jle    80228c <nsipc_send+0x3e>
  802268:	c7 44 24 0c 67 33 80 	movl   $0x803367,0xc(%esp)
  80226f:	00 
  802270:	c7 44 24 08 73 33 80 	movl   $0x803373,0x8(%esp)
  802277:	00 
  802278:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  80227f:	00 
  802280:	c7 04 24 88 33 80 00 	movl   $0x803388,(%esp)
  802287:	e8 cc df ff ff       	call   800258 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80228c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802290:	8b 45 0c             	mov    0xc(%ebp),%eax
  802293:	89 44 24 04          	mov    %eax,0x4(%esp)
  802297:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80229e:	e8 12 e9 ff ff       	call   800bb5 <memmove>
	nsipcbuf.send.req_size = size;
  8022a3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8022a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8022ac:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8022b1:	b8 08 00 00 00       	mov    $0x8,%eax
  8022b6:	e8 c5 fe ff ff       	call   802180 <nsipc>
}
  8022bb:	83 c4 14             	add    $0x14,%esp
  8022be:	5b                   	pop    %ebx
  8022bf:	5d                   	pop    %ebp
  8022c0:	c3                   	ret    

008022c1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8022c1:	55                   	push   %ebp
  8022c2:	89 e5                	mov    %esp,%ebp
  8022c4:	56                   	push   %esi
  8022c5:	53                   	push   %ebx
  8022c6:	83 ec 10             	sub    $0x10,%esp
  8022c9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8022d4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8022da:	8b 45 14             	mov    0x14(%ebp),%eax
  8022dd:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8022e2:	b8 07 00 00 00       	mov    $0x7,%eax
  8022e7:	e8 94 fe ff ff       	call   802180 <nsipc>
  8022ec:	89 c3                	mov    %eax,%ebx
  8022ee:	85 c0                	test   %eax,%eax
  8022f0:	78 46                	js     802338 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8022f2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8022f7:	7f 04                	jg     8022fd <nsipc_recv+0x3c>
  8022f9:	39 c6                	cmp    %eax,%esi
  8022fb:	7d 24                	jge    802321 <nsipc_recv+0x60>
  8022fd:	c7 44 24 0c 94 33 80 	movl   $0x803394,0xc(%esp)
  802304:	00 
  802305:	c7 44 24 08 73 33 80 	movl   $0x803373,0x8(%esp)
  80230c:	00 
  80230d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802314:	00 
  802315:	c7 04 24 88 33 80 00 	movl   $0x803388,(%esp)
  80231c:	e8 37 df ff ff       	call   800258 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802321:	89 44 24 08          	mov    %eax,0x8(%esp)
  802325:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80232c:	00 
  80232d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802330:	89 04 24             	mov    %eax,(%esp)
  802333:	e8 7d e8 ff ff       	call   800bb5 <memmove>
	}

	return r;
}
  802338:	89 d8                	mov    %ebx,%eax
  80233a:	83 c4 10             	add    $0x10,%esp
  80233d:	5b                   	pop    %ebx
  80233e:	5e                   	pop    %esi
  80233f:	5d                   	pop    %ebp
  802340:	c3                   	ret    

00802341 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802341:	55                   	push   %ebp
  802342:	89 e5                	mov    %esp,%ebp
  802344:	53                   	push   %ebx
  802345:	83 ec 14             	sub    $0x14,%esp
  802348:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802353:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802357:	8b 45 0c             	mov    0xc(%ebp),%eax
  80235a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80235e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802365:	e8 4b e8 ff ff       	call   800bb5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80236a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802370:	b8 05 00 00 00       	mov    $0x5,%eax
  802375:	e8 06 fe ff ff       	call   802180 <nsipc>
}
  80237a:	83 c4 14             	add    $0x14,%esp
  80237d:	5b                   	pop    %ebx
  80237e:	5d                   	pop    %ebp
  80237f:	c3                   	ret    

00802380 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	53                   	push   %ebx
  802384:	83 ec 14             	sub    $0x14,%esp
  802387:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80238a:	8b 45 08             	mov    0x8(%ebp),%eax
  80238d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802392:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802396:	8b 45 0c             	mov    0xc(%ebp),%eax
  802399:	89 44 24 04          	mov    %eax,0x4(%esp)
  80239d:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8023a4:	e8 0c e8 ff ff       	call   800bb5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8023a9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8023af:	b8 02 00 00 00       	mov    $0x2,%eax
  8023b4:	e8 c7 fd ff ff       	call   802180 <nsipc>
}
  8023b9:	83 c4 14             	add    $0x14,%esp
  8023bc:	5b                   	pop    %ebx
  8023bd:	5d                   	pop    %ebp
  8023be:	c3                   	ret    

008023bf <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8023bf:	55                   	push   %ebp
  8023c0:	89 e5                	mov    %esp,%ebp
  8023c2:	83 ec 18             	sub    $0x18,%esp
  8023c5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8023c8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8023cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ce:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8023d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8023d8:	e8 a3 fd ff ff       	call   802180 <nsipc>
  8023dd:	89 c3                	mov    %eax,%ebx
  8023df:	85 c0                	test   %eax,%eax
  8023e1:	78 25                	js     802408 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8023e3:	be 10 60 80 00       	mov    $0x806010,%esi
  8023e8:	8b 06                	mov    (%esi),%eax
  8023ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8023ee:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8023f5:	00 
  8023f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023f9:	89 04 24             	mov    %eax,(%esp)
  8023fc:	e8 b4 e7 ff ff       	call   800bb5 <memmove>
		*addrlen = ret->ret_addrlen;
  802401:	8b 16                	mov    (%esi),%edx
  802403:	8b 45 10             	mov    0x10(%ebp),%eax
  802406:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802408:	89 d8                	mov    %ebx,%eax
  80240a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80240d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802410:	89 ec                	mov    %ebp,%esp
  802412:	5d                   	pop    %ebp
  802413:	c3                   	ret    
	...

00802420 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	83 ec 18             	sub    $0x18,%esp
  802426:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802429:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80242c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80242f:	8b 45 08             	mov    0x8(%ebp),%eax
  802432:	89 04 24             	mov    %eax,(%esp)
  802435:	e8 e6 f1 ff ff       	call   801620 <fd2data>
  80243a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80243c:	c7 44 24 04 a9 33 80 	movl   $0x8033a9,0x4(%esp)
  802443:	00 
  802444:	89 34 24             	mov    %esi,(%esp)
  802447:	e8 ae e5 ff ff       	call   8009fa <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80244c:	8b 43 04             	mov    0x4(%ebx),%eax
  80244f:	2b 03                	sub    (%ebx),%eax
  802451:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802457:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80245e:	00 00 00 
	stat->st_dev = &devpipe;
  802461:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  802468:	70 80 00 
	return 0;
}
  80246b:	b8 00 00 00 00       	mov    $0x0,%eax
  802470:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802473:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802476:	89 ec                	mov    %ebp,%esp
  802478:	5d                   	pop    %ebp
  802479:	c3                   	ret    

0080247a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	53                   	push   %ebx
  80247e:	83 ec 14             	sub    $0x14,%esp
  802481:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802484:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802488:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80248f:	e8 06 ec ff ff       	call   80109a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802494:	89 1c 24             	mov    %ebx,(%esp)
  802497:	e8 84 f1 ff ff       	call   801620 <fd2data>
  80249c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024a7:	e8 ee eb ff ff       	call   80109a <sys_page_unmap>
}
  8024ac:	83 c4 14             	add    $0x14,%esp
  8024af:	5b                   	pop    %ebx
  8024b0:	5d                   	pop    %ebp
  8024b1:	c3                   	ret    

008024b2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8024b2:	55                   	push   %ebp
  8024b3:	89 e5                	mov    %esp,%ebp
  8024b5:	57                   	push   %edi
  8024b6:	56                   	push   %esi
  8024b7:	53                   	push   %ebx
  8024b8:	83 ec 2c             	sub    $0x2c,%esp
  8024bb:	89 c7                	mov    %eax,%edi
  8024bd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8024c0:	a1 74 70 80 00       	mov    0x807074,%eax
  8024c5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8024c8:	89 3c 24             	mov    %edi,(%esp)
  8024cb:	e8 48 06 00 00       	call   802b18 <pageref>
  8024d0:	89 c6                	mov    %eax,%esi
  8024d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024d5:	89 04 24             	mov    %eax,(%esp)
  8024d8:	e8 3b 06 00 00       	call   802b18 <pageref>
  8024dd:	39 c6                	cmp    %eax,%esi
  8024df:	0f 94 c0             	sete   %al
  8024e2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  8024e5:	8b 15 74 70 80 00    	mov    0x807074,%edx
  8024eb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8024ee:	39 cb                	cmp    %ecx,%ebx
  8024f0:	75 08                	jne    8024fa <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  8024f2:	83 c4 2c             	add    $0x2c,%esp
  8024f5:	5b                   	pop    %ebx
  8024f6:	5e                   	pop    %esi
  8024f7:	5f                   	pop    %edi
  8024f8:	5d                   	pop    %ebp
  8024f9:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8024fa:	83 f8 01             	cmp    $0x1,%eax
  8024fd:	75 c1                	jne    8024c0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  8024ff:	8b 52 58             	mov    0x58(%edx),%edx
  802502:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802506:	89 54 24 08          	mov    %edx,0x8(%esp)
  80250a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80250e:	c7 04 24 b0 33 80 00 	movl   $0x8033b0,(%esp)
  802515:	e8 03 de ff ff       	call   80031d <cprintf>
  80251a:	eb a4                	jmp    8024c0 <_pipeisclosed+0xe>

0080251c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80251c:	55                   	push   %ebp
  80251d:	89 e5                	mov    %esp,%ebp
  80251f:	57                   	push   %edi
  802520:	56                   	push   %esi
  802521:	53                   	push   %ebx
  802522:	83 ec 1c             	sub    $0x1c,%esp
  802525:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802528:	89 34 24             	mov    %esi,(%esp)
  80252b:	e8 f0 f0 ff ff       	call   801620 <fd2data>
  802530:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802532:	bf 00 00 00 00       	mov    $0x0,%edi
  802537:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80253b:	75 54                	jne    802591 <devpipe_write+0x75>
  80253d:	eb 60                	jmp    80259f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80253f:	89 da                	mov    %ebx,%edx
  802541:	89 f0                	mov    %esi,%eax
  802543:	e8 6a ff ff ff       	call   8024b2 <_pipeisclosed>
  802548:	85 c0                	test   %eax,%eax
  80254a:	74 07                	je     802553 <devpipe_write+0x37>
  80254c:	b8 00 00 00 00       	mov    $0x0,%eax
  802551:	eb 53                	jmp    8025a6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802553:	90                   	nop
  802554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802558:	e8 58 ec ff ff       	call   8011b5 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80255d:	8b 43 04             	mov    0x4(%ebx),%eax
  802560:	8b 13                	mov    (%ebx),%edx
  802562:	83 c2 20             	add    $0x20,%edx
  802565:	39 d0                	cmp    %edx,%eax
  802567:	73 d6                	jae    80253f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802569:	89 c2                	mov    %eax,%edx
  80256b:	c1 fa 1f             	sar    $0x1f,%edx
  80256e:	c1 ea 1b             	shr    $0x1b,%edx
  802571:	01 d0                	add    %edx,%eax
  802573:	83 e0 1f             	and    $0x1f,%eax
  802576:	29 d0                	sub    %edx,%eax
  802578:	89 c2                	mov    %eax,%edx
  80257a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80257d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802581:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802585:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802589:	83 c7 01             	add    $0x1,%edi
  80258c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80258f:	76 13                	jbe    8025a4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802591:	8b 43 04             	mov    0x4(%ebx),%eax
  802594:	8b 13                	mov    (%ebx),%edx
  802596:	83 c2 20             	add    $0x20,%edx
  802599:	39 d0                	cmp    %edx,%eax
  80259b:	73 a2                	jae    80253f <devpipe_write+0x23>
  80259d:	eb ca                	jmp    802569 <devpipe_write+0x4d>
  80259f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8025a4:	89 f8                	mov    %edi,%eax
}
  8025a6:	83 c4 1c             	add    $0x1c,%esp
  8025a9:	5b                   	pop    %ebx
  8025aa:	5e                   	pop    %esi
  8025ab:	5f                   	pop    %edi
  8025ac:	5d                   	pop    %ebp
  8025ad:	c3                   	ret    

008025ae <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
  8025b1:	83 ec 28             	sub    $0x28,%esp
  8025b4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8025b7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8025ba:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8025bd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8025c0:	89 3c 24             	mov    %edi,(%esp)
  8025c3:	e8 58 f0 ff ff       	call   801620 <fd2data>
  8025c8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8025ca:	be 00 00 00 00       	mov    $0x0,%esi
  8025cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025d3:	75 4c                	jne    802621 <devpipe_read+0x73>
  8025d5:	eb 5b                	jmp    802632 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8025d7:	89 f0                	mov    %esi,%eax
  8025d9:	eb 5e                	jmp    802639 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8025db:	89 da                	mov    %ebx,%edx
  8025dd:	89 f8                	mov    %edi,%eax
  8025df:	90                   	nop
  8025e0:	e8 cd fe ff ff       	call   8024b2 <_pipeisclosed>
  8025e5:	85 c0                	test   %eax,%eax
  8025e7:	74 07                	je     8025f0 <devpipe_read+0x42>
  8025e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025ee:	eb 49                	jmp    802639 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8025f0:	e8 c0 eb ff ff       	call   8011b5 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8025f5:	8b 03                	mov    (%ebx),%eax
  8025f7:	3b 43 04             	cmp    0x4(%ebx),%eax
  8025fa:	74 df                	je     8025db <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8025fc:	89 c2                	mov    %eax,%edx
  8025fe:	c1 fa 1f             	sar    $0x1f,%edx
  802601:	c1 ea 1b             	shr    $0x1b,%edx
  802604:	01 d0                	add    %edx,%eax
  802606:	83 e0 1f             	and    $0x1f,%eax
  802609:	29 d0                	sub    %edx,%eax
  80260b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802610:	8b 55 0c             	mov    0xc(%ebp),%edx
  802613:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802616:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802619:	83 c6 01             	add    $0x1,%esi
  80261c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80261f:	76 16                	jbe    802637 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802621:	8b 03                	mov    (%ebx),%eax
  802623:	3b 43 04             	cmp    0x4(%ebx),%eax
  802626:	75 d4                	jne    8025fc <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802628:	85 f6                	test   %esi,%esi
  80262a:	75 ab                	jne    8025d7 <devpipe_read+0x29>
  80262c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802630:	eb a9                	jmp    8025db <devpipe_read+0x2d>
  802632:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802637:	89 f0                	mov    %esi,%eax
}
  802639:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80263c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80263f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802642:	89 ec                	mov    %ebp,%esp
  802644:	5d                   	pop    %ebp
  802645:	c3                   	ret    

00802646 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802646:	55                   	push   %ebp
  802647:	89 e5                	mov    %esp,%ebp
  802649:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80264c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80264f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802653:	8b 45 08             	mov    0x8(%ebp),%eax
  802656:	89 04 24             	mov    %eax,(%esp)
  802659:	e8 4f f0 ff ff       	call   8016ad <fd_lookup>
  80265e:	85 c0                	test   %eax,%eax
  802660:	78 15                	js     802677 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	89 04 24             	mov    %eax,(%esp)
  802668:	e8 b3 ef ff ff       	call   801620 <fd2data>
	return _pipeisclosed(fd, p);
  80266d:	89 c2                	mov    %eax,%edx
  80266f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802672:	e8 3b fe ff ff       	call   8024b2 <_pipeisclosed>
}
  802677:	c9                   	leave  
  802678:	c3                   	ret    

00802679 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802679:	55                   	push   %ebp
  80267a:	89 e5                	mov    %esp,%ebp
  80267c:	83 ec 48             	sub    $0x48,%esp
  80267f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802682:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802685:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802688:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80268b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80268e:	89 04 24             	mov    %eax,(%esp)
  802691:	e8 a5 ef ff ff       	call   80163b <fd_alloc>
  802696:	89 c3                	mov    %eax,%ebx
  802698:	85 c0                	test   %eax,%eax
  80269a:	0f 88 42 01 00 00    	js     8027e2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026a0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026a7:	00 
  8026a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b6:	e8 9b ea ff ff       	call   801156 <sys_page_alloc>
  8026bb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	0f 88 1d 01 00 00    	js     8027e2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8026c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8026c8:	89 04 24             	mov    %eax,(%esp)
  8026cb:	e8 6b ef ff ff       	call   80163b <fd_alloc>
  8026d0:	89 c3                	mov    %eax,%ebx
  8026d2:	85 c0                	test   %eax,%eax
  8026d4:	0f 88 f5 00 00 00    	js     8027cf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8026da:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8026e1:	00 
  8026e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026f0:	e8 61 ea ff ff       	call   801156 <sys_page_alloc>
  8026f5:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8026f7:	85 c0                	test   %eax,%eax
  8026f9:	0f 88 d0 00 00 00    	js     8027cf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8026ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802702:	89 04 24             	mov    %eax,(%esp)
  802705:	e8 16 ef ff ff       	call   801620 <fd2data>
  80270a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80270c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802713:	00 
  802714:	89 44 24 04          	mov    %eax,0x4(%esp)
  802718:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80271f:	e8 32 ea ff ff       	call   801156 <sys_page_alloc>
  802724:	89 c3                	mov    %eax,%ebx
  802726:	85 c0                	test   %eax,%eax
  802728:	0f 88 8e 00 00 00    	js     8027bc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80272e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802731:	89 04 24             	mov    %eax,(%esp)
  802734:	e8 e7 ee ff ff       	call   801620 <fd2data>
  802739:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802740:	00 
  802741:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802745:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80274c:	00 
  80274d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802751:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802758:	e8 9b e9 ff ff       	call   8010f8 <sys_page_map>
  80275d:	89 c3                	mov    %eax,%ebx
  80275f:	85 c0                	test   %eax,%eax
  802761:	78 49                	js     8027ac <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802763:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  802768:	8b 08                	mov    (%eax),%ecx
  80276a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80276d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80276f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802772:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802779:	8b 10                	mov    (%eax),%edx
  80277b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80277e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802780:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802783:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80278a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278d:	89 04 24             	mov    %eax,(%esp)
  802790:	e8 7b ee ff ff       	call   801610 <fd2num>
  802795:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802797:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80279a:	89 04 24             	mov    %eax,(%esp)
  80279d:	e8 6e ee ff ff       	call   801610 <fd2num>
  8027a2:	89 47 04             	mov    %eax,0x4(%edi)
  8027a5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8027aa:	eb 36                	jmp    8027e2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8027ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027b7:	e8 de e8 ff ff       	call   80109a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8027bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027ca:	e8 cb e8 ff ff       	call   80109a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8027cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027dd:	e8 b8 e8 ff ff       	call   80109a <sys_page_unmap>
    err:
	return r;
}
  8027e2:	89 d8                	mov    %ebx,%eax
  8027e4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8027e7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8027ea:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8027ed:	89 ec                	mov    %ebp,%esp
  8027ef:	5d                   	pop    %ebp
  8027f0:	c3                   	ret    
	...

00802800 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802803:	b8 00 00 00 00       	mov    $0x0,%eax
  802808:	5d                   	pop    %ebp
  802809:	c3                   	ret    

0080280a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80280a:	55                   	push   %ebp
  80280b:	89 e5                	mov    %esp,%ebp
  80280d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802810:	c7 44 24 04 c8 33 80 	movl   $0x8033c8,0x4(%esp)
  802817:	00 
  802818:	8b 45 0c             	mov    0xc(%ebp),%eax
  80281b:	89 04 24             	mov    %eax,(%esp)
  80281e:	e8 d7 e1 ff ff       	call   8009fa <strcpy>
	return 0;
}
  802823:	b8 00 00 00 00       	mov    $0x0,%eax
  802828:	c9                   	leave  
  802829:	c3                   	ret    

0080282a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80282a:	55                   	push   %ebp
  80282b:	89 e5                	mov    %esp,%ebp
  80282d:	57                   	push   %edi
  80282e:	56                   	push   %esi
  80282f:	53                   	push   %ebx
  802830:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802836:	b8 00 00 00 00       	mov    $0x0,%eax
  80283b:	be 00 00 00 00       	mov    $0x0,%esi
  802840:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802844:	74 3f                	je     802885 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802846:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80284c:	8b 55 10             	mov    0x10(%ebp),%edx
  80284f:	29 c2                	sub    %eax,%edx
  802851:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802853:	83 fa 7f             	cmp    $0x7f,%edx
  802856:	76 05                	jbe    80285d <devcons_write+0x33>
  802858:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80285d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802861:	03 45 0c             	add    0xc(%ebp),%eax
  802864:	89 44 24 04          	mov    %eax,0x4(%esp)
  802868:	89 3c 24             	mov    %edi,(%esp)
  80286b:	e8 45 e3 ff ff       	call   800bb5 <memmove>
		sys_cputs(buf, m);
  802870:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802874:	89 3c 24             	mov    %edi,(%esp)
  802877:	e8 74 e5 ff ff       	call   800df0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80287c:	01 de                	add    %ebx,%esi
  80287e:	89 f0                	mov    %esi,%eax
  802880:	3b 75 10             	cmp    0x10(%ebp),%esi
  802883:	72 c7                	jb     80284c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802885:	89 f0                	mov    %esi,%eax
  802887:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80288d:	5b                   	pop    %ebx
  80288e:	5e                   	pop    %esi
  80288f:	5f                   	pop    %edi
  802890:	5d                   	pop    %ebp
  802891:	c3                   	ret    

00802892 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802892:	55                   	push   %ebp
  802893:	89 e5                	mov    %esp,%ebp
  802895:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80289e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8028a5:	00 
  8028a6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028a9:	89 04 24             	mov    %eax,(%esp)
  8028ac:	e8 3f e5 ff ff       	call   800df0 <sys_cputs>
}
  8028b1:	c9                   	leave  
  8028b2:	c3                   	ret    

008028b3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8028b3:	55                   	push   %ebp
  8028b4:	89 e5                	mov    %esp,%ebp
  8028b6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8028b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8028bd:	75 07                	jne    8028c6 <devcons_read+0x13>
  8028bf:	eb 28                	jmp    8028e9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8028c1:	e8 ef e8 ff ff       	call   8011b5 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8028c6:	66 90                	xchg   %ax,%ax
  8028c8:	e8 ef e4 ff ff       	call   800dbc <sys_cgetc>
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	90                   	nop
  8028d0:	74 ef                	je     8028c1 <devcons_read+0xe>
  8028d2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8028d4:	85 c0                	test   %eax,%eax
  8028d6:	78 16                	js     8028ee <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8028d8:	83 f8 04             	cmp    $0x4,%eax
  8028db:	74 0c                	je     8028e9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8028dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028e0:	88 10                	mov    %dl,(%eax)
  8028e2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8028e7:	eb 05                	jmp    8028ee <devcons_read+0x3b>
  8028e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028ee:	c9                   	leave  
  8028ef:	c3                   	ret    

008028f0 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  8028f0:	55                   	push   %ebp
  8028f1:	89 e5                	mov    %esp,%ebp
  8028f3:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8028f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028f9:	89 04 24             	mov    %eax,(%esp)
  8028fc:	e8 3a ed ff ff       	call   80163b <fd_alloc>
  802901:	85 c0                	test   %eax,%eax
  802903:	78 3f                	js     802944 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802905:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80290c:	00 
  80290d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802910:	89 44 24 04          	mov    %eax,0x4(%esp)
  802914:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80291b:	e8 36 e8 ff ff       	call   801156 <sys_page_alloc>
  802920:	85 c0                	test   %eax,%eax
  802922:	78 20                	js     802944 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802924:	8b 15 58 70 80 00    	mov    0x807058,%edx
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80292f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802932:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802939:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293c:	89 04 24             	mov    %eax,(%esp)
  80293f:	e8 cc ec ff ff       	call   801610 <fd2num>
}
  802944:	c9                   	leave  
  802945:	c3                   	ret    

00802946 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802946:	55                   	push   %ebp
  802947:	89 e5                	mov    %esp,%ebp
  802949:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80294c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80294f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802953:	8b 45 08             	mov    0x8(%ebp),%eax
  802956:	89 04 24             	mov    %eax,(%esp)
  802959:	e8 4f ed ff ff       	call   8016ad <fd_lookup>
  80295e:	85 c0                	test   %eax,%eax
  802960:	78 11                	js     802973 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802962:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802965:	8b 00                	mov    (%eax),%eax
  802967:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  80296d:	0f 94 c0             	sete   %al
  802970:	0f b6 c0             	movzbl %al,%eax
}
  802973:	c9                   	leave  
  802974:	c3                   	ret    

00802975 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802975:	55                   	push   %ebp
  802976:	89 e5                	mov    %esp,%ebp
  802978:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80297b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802982:	00 
  802983:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802986:	89 44 24 04          	mov    %eax,0x4(%esp)
  80298a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802991:	e8 78 ef ff ff       	call   80190e <read>
	if (r < 0)
  802996:	85 c0                	test   %eax,%eax
  802998:	78 0f                	js     8029a9 <getchar+0x34>
		return r;
	if (r < 1)
  80299a:	85 c0                	test   %eax,%eax
  80299c:	7f 07                	jg     8029a5 <getchar+0x30>
  80299e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8029a3:	eb 04                	jmp    8029a9 <getchar+0x34>
		return -E_EOF;
	return c;
  8029a5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8029a9:	c9                   	leave  
  8029aa:	c3                   	ret    
	...

008029ac <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8029ac:	55                   	push   %ebp
  8029ad:	89 e5                	mov    %esp,%ebp
  8029af:	53                   	push   %ebx
  8029b0:	83 ec 14             	sub    $0x14,%esp
  8029b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    // cprintf("\nhere outside loading creating page\n");

	if (_pgfault_handler == 0) {
  8029b6:	83 3d 7c 70 80 00 00 	cmpl   $0x0,0x80707c
  8029bd:	75 58                	jne    802a17 <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
           //cprintf("\nhere inside loading creating page\n");    
          if(sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  8029bf:	e8 25 e8 ff ff       	call   8011e9 <sys_getenvid>
  8029c4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8029cb:	00 
  8029cc:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8029d3:	ee 
  8029d4:	89 04 24             	mov    %eax,(%esp)
  8029d7:	e8 7a e7 ff ff       	call   801156 <sys_page_alloc>
  8029dc:	85 c0                	test   %eax,%eax
  8029de:	79 1c                	jns    8029fc <set_pgfault_handler+0x50>
                          panic("Cant allocate Page");                    
  8029e0:	c7 44 24 08 4c 32 80 	movl   $0x80324c,0x8(%esp)
  8029e7:	00 
  8029e8:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8029ef:	00 
  8029f0:	c7 04 24 d4 33 80 00 	movl   $0x8033d4,(%esp)
  8029f7:	e8 5c d8 ff ff       	call   800258 <_panic>
                _pgfault_handler=handler;
  8029fc:	89 1d 7c 70 80 00    	mov    %ebx,0x80707c
//entry point _pgfault_handler not pointed to by the kernel bcz after the execution is complete control needs to be returned back to execute the rest...so upcall is there         
             sys_env_set_pgfault_upcall(sys_getenvid(),_pgfault_upcall);
  802a02:	e8 e2 e7 ff ff       	call   8011e9 <sys_getenvid>
  802a07:	c7 44 24 04 24 2a 80 	movl   $0x802a24,0x4(%esp)
  802a0e:	00 
  802a0f:	89 04 24             	mov    %eax,(%esp)
  802a12:	e8 69 e5 ff ff       	call   800f80 <sys_env_set_pgfault_upcall>

	// Save handler pointer for assembly to call.
 //     if(sys_page_alloc(0,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
   //                       panic("Cant allocate Page");

	_pgfault_handler = handler;
  802a17:	89 1d 7c 70 80 00    	mov    %ebx,0x80707c
}
  802a1d:	83 c4 14             	add    $0x14,%esp
  802a20:	5b                   	pop    %ebx
  802a21:	5d                   	pop    %ebp
  802a22:	c3                   	ret    
	...

00802a24 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802a24:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802a25:	a1 7c 70 80 00       	mov    0x80707c,%eax
	call *%eax
  802a2a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802a2c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
           addl $8,%esp
  802a2f:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
            movl  32(%esp),%ebx
  802a32:	8b 5c 24 20          	mov    0x20(%esp),%ebx
            movl  40(%esp),%eax
  802a36:	8b 44 24 28          	mov    0x28(%esp),%eax
            subl  $4,%eax
  802a3a:	83 e8 04             	sub    $0x4,%eax
            movl  %eax,40(%esp)
  802a3d:	89 44 24 28          	mov    %eax,0x28(%esp)
            movl  %ebx,(%eax)
  802a41:	89 18                	mov    %ebx,(%eax)
            popal
  802a43:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
            
            add $4,%esp            
  802a44:	83 c4 04             	add    $0x4,%esp
            popfl
  802a47:	9d                   	popf   
             
           popl %esp
  802a48:	5c                   	pop    %esp
	// LAB 4: Your code here.
           

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
           ret
  802a49:	c3                   	ret    
  802a4a:	00 00                	add    %al,(%eax)
  802a4c:	00 00                	add    %al,(%eax)
	...

00802a50 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a50:	55                   	push   %ebp
  802a51:	89 e5                	mov    %esp,%ebp
  802a53:	57                   	push   %edi
  802a54:	56                   	push   %esi
  802a55:	53                   	push   %ebx
  802a56:	83 ec 1c             	sub    $0x1c,%esp
  802a59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a5f:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  802a62:	8b 45 14             	mov    0x14(%ebp),%eax
  802a65:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a69:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802a6d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a71:	89 1c 24             	mov    %ebx,(%esp)
  802a74:	e8 cf e4 ff ff       	call   800f48 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	79 21                	jns    802a9e <ipc_send+0x4e>
  802a7d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a80:	74 1c                	je     802a9e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  802a82:	c7 44 24 08 e2 33 80 	movl   $0x8033e2,0x8(%esp)
  802a89:	00 
  802a8a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  802a91:	00 
  802a92:	c7 04 24 f4 33 80 00 	movl   $0x8033f4,(%esp)
  802a99:	e8 ba d7 ff ff       	call   800258 <_panic>
          else if(r==-E_IPC_NOT_RECV)
  802a9e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802aa1:	75 07                	jne    802aaa <ipc_send+0x5a>
           sys_yield();
  802aa3:	e8 0d e7 ff ff       	call   8011b5 <sys_yield>
          else
            break;
        }
  802aa8:	eb b8                	jmp    802a62 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  802aaa:	83 c4 1c             	add    $0x1c,%esp
  802aad:	5b                   	pop    %ebx
  802aae:	5e                   	pop    %esi
  802aaf:	5f                   	pop    %edi
  802ab0:	5d                   	pop    %ebp
  802ab1:	c3                   	ret    

00802ab2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802ab2:	55                   	push   %ebp
  802ab3:	89 e5                	mov    %esp,%ebp
  802ab5:	83 ec 18             	sub    $0x18,%esp
  802ab8:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802abb:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802abe:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802ac1:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  802ac4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ac7:	89 04 24             	mov    %eax,(%esp)
  802aca:	e8 1c e4 ff ff       	call   800eeb <sys_ipc_recv>
        if(r<0)
  802acf:	85 c0                	test   %eax,%eax
  802ad1:	79 17                	jns    802aea <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  802ad3:	85 db                	test   %ebx,%ebx
  802ad5:	74 06                	je     802add <ipc_recv+0x2b>
               *from_env_store =0;
  802ad7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  802add:	85 f6                	test   %esi,%esi
  802adf:	90                   	nop
  802ae0:	74 2c                	je     802b0e <ipc_recv+0x5c>
              *perm_store=0;
  802ae2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802ae8:	eb 24                	jmp    802b0e <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  802aea:	85 db                	test   %ebx,%ebx
  802aec:	74 0a                	je     802af8 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  802aee:	a1 74 70 80 00       	mov    0x807074,%eax
  802af3:	8b 40 74             	mov    0x74(%eax),%eax
  802af6:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  802af8:	85 f6                	test   %esi,%esi
  802afa:	74 0a                	je     802b06 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  802afc:	a1 74 70 80 00       	mov    0x807074,%eax
  802b01:	8b 40 78             	mov    0x78(%eax),%eax
  802b04:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  802b06:	a1 74 70 80 00       	mov    0x807074,%eax
  802b0b:	8b 40 70             	mov    0x70(%eax),%eax
}
  802b0e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802b11:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802b14:	89 ec                	mov    %ebp,%esp
  802b16:	5d                   	pop    %ebp
  802b17:	c3                   	ret    

00802b18 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802b18:	55                   	push   %ebp
  802b19:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1e:	89 c2                	mov    %eax,%edx
  802b20:	c1 ea 16             	shr    $0x16,%edx
  802b23:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802b2a:	f6 c2 01             	test   $0x1,%dl
  802b2d:	74 26                	je     802b55 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802b2f:	c1 e8 0c             	shr    $0xc,%eax
  802b32:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802b39:	a8 01                	test   $0x1,%al
  802b3b:	74 18                	je     802b55 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802b3d:	c1 e8 0c             	shr    $0xc,%eax
  802b40:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802b43:	c1 e2 02             	shl    $0x2,%edx
  802b46:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802b4b:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802b50:	0f b7 c0             	movzwl %ax,%eax
  802b53:	eb 05                	jmp    802b5a <pageref+0x42>
  802b55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b5a:	5d                   	pop    %ebp
  802b5b:	c3                   	ret    
  802b5c:	00 00                	add    %al,(%eax)
	...

00802b60 <__udivdi3>:
  802b60:	55                   	push   %ebp
  802b61:	89 e5                	mov    %esp,%ebp
  802b63:	57                   	push   %edi
  802b64:	56                   	push   %esi
  802b65:	83 ec 10             	sub    $0x10,%esp
  802b68:	8b 45 14             	mov    0x14(%ebp),%eax
  802b6b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b6e:	8b 75 10             	mov    0x10(%ebp),%esi
  802b71:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802b74:	85 c0                	test   %eax,%eax
  802b76:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802b79:	75 35                	jne    802bb0 <__udivdi3+0x50>
  802b7b:	39 fe                	cmp    %edi,%esi
  802b7d:	77 61                	ja     802be0 <__udivdi3+0x80>
  802b7f:	85 f6                	test   %esi,%esi
  802b81:	75 0b                	jne    802b8e <__udivdi3+0x2e>
  802b83:	b8 01 00 00 00       	mov    $0x1,%eax
  802b88:	31 d2                	xor    %edx,%edx
  802b8a:	f7 f6                	div    %esi
  802b8c:	89 c6                	mov    %eax,%esi
  802b8e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802b91:	31 d2                	xor    %edx,%edx
  802b93:	89 f8                	mov    %edi,%eax
  802b95:	f7 f6                	div    %esi
  802b97:	89 c7                	mov    %eax,%edi
  802b99:	89 c8                	mov    %ecx,%eax
  802b9b:	f7 f6                	div    %esi
  802b9d:	89 c1                	mov    %eax,%ecx
  802b9f:	89 fa                	mov    %edi,%edx
  802ba1:	89 c8                	mov    %ecx,%eax
  802ba3:	83 c4 10             	add    $0x10,%esp
  802ba6:	5e                   	pop    %esi
  802ba7:	5f                   	pop    %edi
  802ba8:	5d                   	pop    %ebp
  802ba9:	c3                   	ret    
  802baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802bb0:	39 f8                	cmp    %edi,%eax
  802bb2:	77 1c                	ja     802bd0 <__udivdi3+0x70>
  802bb4:	0f bd d0             	bsr    %eax,%edx
  802bb7:	83 f2 1f             	xor    $0x1f,%edx
  802bba:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802bbd:	75 39                	jne    802bf8 <__udivdi3+0x98>
  802bbf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802bc2:	0f 86 a0 00 00 00    	jbe    802c68 <__udivdi3+0x108>
  802bc8:	39 f8                	cmp    %edi,%eax
  802bca:	0f 82 98 00 00 00    	jb     802c68 <__udivdi3+0x108>
  802bd0:	31 ff                	xor    %edi,%edi
  802bd2:	31 c9                	xor    %ecx,%ecx
  802bd4:	89 c8                	mov    %ecx,%eax
  802bd6:	89 fa                	mov    %edi,%edx
  802bd8:	83 c4 10             	add    $0x10,%esp
  802bdb:	5e                   	pop    %esi
  802bdc:	5f                   	pop    %edi
  802bdd:	5d                   	pop    %ebp
  802bde:	c3                   	ret    
  802bdf:	90                   	nop
  802be0:	89 d1                	mov    %edx,%ecx
  802be2:	89 fa                	mov    %edi,%edx
  802be4:	89 c8                	mov    %ecx,%eax
  802be6:	31 ff                	xor    %edi,%edi
  802be8:	f7 f6                	div    %esi
  802bea:	89 c1                	mov    %eax,%ecx
  802bec:	89 fa                	mov    %edi,%edx
  802bee:	89 c8                	mov    %ecx,%eax
  802bf0:	83 c4 10             	add    $0x10,%esp
  802bf3:	5e                   	pop    %esi
  802bf4:	5f                   	pop    %edi
  802bf5:	5d                   	pop    %ebp
  802bf6:	c3                   	ret    
  802bf7:	90                   	nop
  802bf8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802bfc:	89 f2                	mov    %esi,%edx
  802bfe:	d3 e0                	shl    %cl,%eax
  802c00:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c03:	b8 20 00 00 00       	mov    $0x20,%eax
  802c08:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802c0b:	89 c1                	mov    %eax,%ecx
  802c0d:	d3 ea                	shr    %cl,%edx
  802c0f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c13:	0b 55 ec             	or     -0x14(%ebp),%edx
  802c16:	d3 e6                	shl    %cl,%esi
  802c18:	89 c1                	mov    %eax,%ecx
  802c1a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802c1d:	89 fe                	mov    %edi,%esi
  802c1f:	d3 ee                	shr    %cl,%esi
  802c21:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c25:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802c28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c2b:	d3 e7                	shl    %cl,%edi
  802c2d:	89 c1                	mov    %eax,%ecx
  802c2f:	d3 ea                	shr    %cl,%edx
  802c31:	09 d7                	or     %edx,%edi
  802c33:	89 f2                	mov    %esi,%edx
  802c35:	89 f8                	mov    %edi,%eax
  802c37:	f7 75 ec             	divl   -0x14(%ebp)
  802c3a:	89 d6                	mov    %edx,%esi
  802c3c:	89 c7                	mov    %eax,%edi
  802c3e:	f7 65 e8             	mull   -0x18(%ebp)
  802c41:	39 d6                	cmp    %edx,%esi
  802c43:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802c46:	72 30                	jb     802c78 <__udivdi3+0x118>
  802c48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c4b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c4f:	d3 e2                	shl    %cl,%edx
  802c51:	39 c2                	cmp    %eax,%edx
  802c53:	73 05                	jae    802c5a <__udivdi3+0xfa>
  802c55:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802c58:	74 1e                	je     802c78 <__udivdi3+0x118>
  802c5a:	89 f9                	mov    %edi,%ecx
  802c5c:	31 ff                	xor    %edi,%edi
  802c5e:	e9 71 ff ff ff       	jmp    802bd4 <__udivdi3+0x74>
  802c63:	90                   	nop
  802c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c68:	31 ff                	xor    %edi,%edi
  802c6a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802c6f:	e9 60 ff ff ff       	jmp    802bd4 <__udivdi3+0x74>
  802c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c78:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802c7b:	31 ff                	xor    %edi,%edi
  802c7d:	89 c8                	mov    %ecx,%eax
  802c7f:	89 fa                	mov    %edi,%edx
  802c81:	83 c4 10             	add    $0x10,%esp
  802c84:	5e                   	pop    %esi
  802c85:	5f                   	pop    %edi
  802c86:	5d                   	pop    %ebp
  802c87:	c3                   	ret    
	...

00802c90 <__umoddi3>:
  802c90:	55                   	push   %ebp
  802c91:	89 e5                	mov    %esp,%ebp
  802c93:	57                   	push   %edi
  802c94:	56                   	push   %esi
  802c95:	83 ec 20             	sub    $0x20,%esp
  802c98:	8b 55 14             	mov    0x14(%ebp),%edx
  802c9b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c9e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802ca1:	8b 75 0c             	mov    0xc(%ebp),%esi
  802ca4:	85 d2                	test   %edx,%edx
  802ca6:	89 c8                	mov    %ecx,%eax
  802ca8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802cab:	75 13                	jne    802cc0 <__umoddi3+0x30>
  802cad:	39 f7                	cmp    %esi,%edi
  802caf:	76 3f                	jbe    802cf0 <__umoddi3+0x60>
  802cb1:	89 f2                	mov    %esi,%edx
  802cb3:	f7 f7                	div    %edi
  802cb5:	89 d0                	mov    %edx,%eax
  802cb7:	31 d2                	xor    %edx,%edx
  802cb9:	83 c4 20             	add    $0x20,%esp
  802cbc:	5e                   	pop    %esi
  802cbd:	5f                   	pop    %edi
  802cbe:	5d                   	pop    %ebp
  802cbf:	c3                   	ret    
  802cc0:	39 f2                	cmp    %esi,%edx
  802cc2:	77 4c                	ja     802d10 <__umoddi3+0x80>
  802cc4:	0f bd ca             	bsr    %edx,%ecx
  802cc7:	83 f1 1f             	xor    $0x1f,%ecx
  802cca:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802ccd:	75 51                	jne    802d20 <__umoddi3+0x90>
  802ccf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802cd2:	0f 87 e0 00 00 00    	ja     802db8 <__umoddi3+0x128>
  802cd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdb:	29 f8                	sub    %edi,%eax
  802cdd:	19 d6                	sbb    %edx,%esi
  802cdf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ce2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce5:	89 f2                	mov    %esi,%edx
  802ce7:	83 c4 20             	add    $0x20,%esp
  802cea:	5e                   	pop    %esi
  802ceb:	5f                   	pop    %edi
  802cec:	5d                   	pop    %ebp
  802ced:	c3                   	ret    
  802cee:	66 90                	xchg   %ax,%ax
  802cf0:	85 ff                	test   %edi,%edi
  802cf2:	75 0b                	jne    802cff <__umoddi3+0x6f>
  802cf4:	b8 01 00 00 00       	mov    $0x1,%eax
  802cf9:	31 d2                	xor    %edx,%edx
  802cfb:	f7 f7                	div    %edi
  802cfd:	89 c7                	mov    %eax,%edi
  802cff:	89 f0                	mov    %esi,%eax
  802d01:	31 d2                	xor    %edx,%edx
  802d03:	f7 f7                	div    %edi
  802d05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d08:	f7 f7                	div    %edi
  802d0a:	eb a9                	jmp    802cb5 <__umoddi3+0x25>
  802d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d10:	89 c8                	mov    %ecx,%eax
  802d12:	89 f2                	mov    %esi,%edx
  802d14:	83 c4 20             	add    $0x20,%esp
  802d17:	5e                   	pop    %esi
  802d18:	5f                   	pop    %edi
  802d19:	5d                   	pop    %ebp
  802d1a:	c3                   	ret    
  802d1b:	90                   	nop
  802d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d20:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d24:	d3 e2                	shl    %cl,%edx
  802d26:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d29:	ba 20 00 00 00       	mov    $0x20,%edx
  802d2e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802d31:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d34:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d38:	89 fa                	mov    %edi,%edx
  802d3a:	d3 ea                	shr    %cl,%edx
  802d3c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d40:	0b 55 f4             	or     -0xc(%ebp),%edx
  802d43:	d3 e7                	shl    %cl,%edi
  802d45:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d49:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d4c:	89 f2                	mov    %esi,%edx
  802d4e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802d51:	89 c7                	mov    %eax,%edi
  802d53:	d3 ea                	shr    %cl,%edx
  802d55:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d59:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802d5c:	89 c2                	mov    %eax,%edx
  802d5e:	d3 e6                	shl    %cl,%esi
  802d60:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d64:	d3 ea                	shr    %cl,%edx
  802d66:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d6a:	09 d6                	or     %edx,%esi
  802d6c:	89 f0                	mov    %esi,%eax
  802d6e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802d71:	d3 e7                	shl    %cl,%edi
  802d73:	89 f2                	mov    %esi,%edx
  802d75:	f7 75 f4             	divl   -0xc(%ebp)
  802d78:	89 d6                	mov    %edx,%esi
  802d7a:	f7 65 e8             	mull   -0x18(%ebp)
  802d7d:	39 d6                	cmp    %edx,%esi
  802d7f:	72 2b                	jb     802dac <__umoddi3+0x11c>
  802d81:	39 c7                	cmp    %eax,%edi
  802d83:	72 23                	jb     802da8 <__umoddi3+0x118>
  802d85:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d89:	29 c7                	sub    %eax,%edi
  802d8b:	19 d6                	sbb    %edx,%esi
  802d8d:	89 f0                	mov    %esi,%eax
  802d8f:	89 f2                	mov    %esi,%edx
  802d91:	d3 ef                	shr    %cl,%edi
  802d93:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d97:	d3 e0                	shl    %cl,%eax
  802d99:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d9d:	09 f8                	or     %edi,%eax
  802d9f:	d3 ea                	shr    %cl,%edx
  802da1:	83 c4 20             	add    $0x20,%esp
  802da4:	5e                   	pop    %esi
  802da5:	5f                   	pop    %edi
  802da6:	5d                   	pop    %ebp
  802da7:	c3                   	ret    
  802da8:	39 d6                	cmp    %edx,%esi
  802daa:	75 d9                	jne    802d85 <__umoddi3+0xf5>
  802dac:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802daf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802db2:	eb d1                	jmp    802d85 <__umoddi3+0xf5>
  802db4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802db8:	39 f2                	cmp    %esi,%edx
  802dba:	0f 82 18 ff ff ff    	jb     802cd8 <__umoddi3+0x48>
  802dc0:	e9 1d ff ff ff       	jmp    802ce2 <__umoddi3+0x52>
