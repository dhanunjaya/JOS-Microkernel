
obj/user/testpiperace:     file format elf32-i386


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
  80002c:	e8 ef 01 00 00       	call   800220 <libmain>
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
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 20             	sub    $0x20,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003c:	c7 04 24 00 2e 80 00 	movl   $0x802e00,(%esp)
  800043:	e8 09 03 00 00       	call   800351 <cprintf>
	if ((r = pipe(p)) < 0)
  800048:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80004b:	89 04 24             	mov    %eax,(%esp)
  80004e:	e8 66 27 00 00       	call   8027b9 <pipe>
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <umain+0x43>
		panic("pipe: %e", r);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 19 2e 80 	movl   $0x802e19,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 22 2e 80 00 	movl   $0x802e22,(%esp)
  800072:	e8 15 02 00 00       	call   80028c <_panic>
	max = 200;
	if ((r = fork()) < 0)
  800077:	e8 8b 13 00 00       	call   801407 <fork>
  80007c:	89 c6                	mov    %eax,%esi
  80007e:	85 c0                	test   %eax,%eax
  800080:	79 20                	jns    8000a2 <umain+0x6e>
		panic("fork: %e", r);
  800082:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800086:	c7 44 24 08 83 32 80 	movl   $0x803283,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 22 2e 80 00 	movl   $0x802e22,(%esp)
  80009d:	e8 ea 01 00 00       	call   80028c <_panic>
	if (r == 0) {
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	75 5c                	jne    800102 <umain+0xce>
		close(p[1]);
  8000a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000a9:	89 04 24             	mov    %eax,(%esp)
  8000ac:	e8 bd 1a 00 00       	call   801b6e <close>
  8000b1:	bb 00 00 00 00       	mov    $0x0,%ebx
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
			if(pipeisclosed(p[0])){
  8000b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000b9:	89 04 24             	mov    %eax,(%esp)
  8000bc:	e8 c5 26 00 00       	call   802786 <pipeisclosed>
  8000c1:	85 c0                	test   %eax,%eax
  8000c3:	74 11                	je     8000d6 <umain+0xa2>
				cprintf("RACE: pipe appears closed\n");
  8000c5:	c7 04 24 36 2e 80 00 	movl   $0x802e36,(%esp)
  8000cc:	e8 80 02 00 00       	call   800351 <cprintf>
				exit();
  8000d1:	e8 9a 01 00 00       	call   800270 <exit>
			}
			sys_yield();
  8000d6:	e8 0a 11 00 00       	call   8011e5 <sys_yield>
		//
		// If a clock interrupt catches dup between mapping the
		// fd and mapping the pipe structure, we'll have the same
		// ref counts, still a no-no.
		//
		for (i=0; i<max; i++) {
  8000db:	83 c3 01             	add    $0x1,%ebx
  8000de:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  8000e4:	75 d0                	jne    8000b6 <umain+0x82>
				exit();
			}
			sys_yield();
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
  8000e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000ed:	00 
  8000ee:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000f5:	00 
  8000f6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000fd:	e8 a0 15 00 00       	call   8016a2 <ipc_recv>
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  800102:	89 74 24 04          	mov    %esi,0x4(%esp)
  800106:	c7 04 24 51 2e 80 00 	movl   $0x802e51,(%esp)
  80010d:	e8 3f 02 00 00       	call   800351 <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  800112:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  800118:	6b f6 7c             	imul   $0x7c,%esi,%esi
	cprintf("kid is %d\n", kid-envs);
  80011b:	8d 9e 00 00 c0 ee    	lea    -0x11400000(%esi),%ebx
  800121:	c1 ee 02             	shr    $0x2,%esi
  800124:	69 f6 df 7b ef bd    	imul   $0xbdef7bdf,%esi,%esi
  80012a:	89 74 24 04          	mov    %esi,0x4(%esp)
  80012e:	c7 04 24 5c 2e 80 00 	movl   $0x802e5c,(%esp)
  800135:	e8 17 02 00 00       	call   800351 <cprintf>
	dup(p[0], 10);
  80013a:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800141:	00 
  800142:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800145:	89 04 24             	mov    %eax,(%esp)
  800148:	e8 c0 1a 00 00       	call   801c0d <dup>
	while (kid->env_status == ENV_RUNNABLE)
  80014d:	8b 43 54             	mov    0x54(%ebx),%eax
  800150:	83 f8 01             	cmp    $0x1,%eax
  800153:	75 1b                	jne    800170 <umain+0x13c>
		dup(p[0], 10);
  800155:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  80015c:	00 
  80015d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800160:	89 04 24             	mov    %eax,(%esp)
  800163:	e8 a5 1a 00 00       	call   801c0d <dup>
	cprintf("pid is %d\n", pid);
	va = 0;
	kid = &envs[ENVX(pid)];
	cprintf("kid is %d\n", kid-envs);
	dup(p[0], 10);
	while (kid->env_status == ENV_RUNNABLE)
  800168:	8b 43 54             	mov    0x54(%ebx),%eax
  80016b:	83 f8 01             	cmp    $0x1,%eax
  80016e:	74 e5                	je     800155 <umain+0x121>
		dup(p[0], 10);

	cprintf("child done with loop\n");
  800170:	c7 04 24 67 2e 80 00 	movl   $0x802e67,(%esp)
  800177:	e8 d5 01 00 00       	call   800351 <cprintf>
	if (pipeisclosed(p[0]))
  80017c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80017f:	89 04 24             	mov    %eax,(%esp)
  800182:	e8 ff 25 00 00       	call   802786 <pipeisclosed>
  800187:	85 c0                	test   %eax,%eax
  800189:	74 1c                	je     8001a7 <umain+0x173>
		panic("somehow the other end of p[0] got closed!");
  80018b:	c7 44 24 08 c0 2e 80 	movl   $0x802ec0,0x8(%esp)
  800192:	00 
  800193:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  80019a:	00 
  80019b:	c7 04 24 22 2e 80 00 	movl   $0x802e22,(%esp)
  8001a2:	e8 e5 00 00 00       	call   80028c <_panic>
	if ((r = fd_lookup(p[0], &fd)) < 0)
  8001a7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001b1:	89 04 24             	mov    %eax,(%esp)
  8001b4:	e8 f4 15 00 00       	call   8017ad <fd_lookup>
  8001b9:	85 c0                	test   %eax,%eax
  8001bb:	79 20                	jns    8001dd <umain+0x1a9>
		panic("cannot look up p[0]: %e", r);
  8001bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001c1:	c7 44 24 08 7d 2e 80 	movl   $0x802e7d,0x8(%esp)
  8001c8:	00 
  8001c9:	c7 44 24 04 3c 00 00 	movl   $0x3c,0x4(%esp)
  8001d0:	00 
  8001d1:	c7 04 24 22 2e 80 00 	movl   $0x802e22,(%esp)
  8001d8:	e8 af 00 00 00       	call   80028c <_panic>
	va = fd2data(fd);
  8001dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001e0:	89 04 24             	mov    %eax,(%esp)
  8001e3:	e8 38 15 00 00       	call   801720 <fd2data>
	if (pageref(va) != 3+1)
  8001e8:	89 04 24             	mov    %eax,(%esp)
  8001eb:	e8 44 1e 00 00       	call   802034 <pageref>
  8001f0:	83 f8 04             	cmp    $0x4,%eax
  8001f3:	74 0e                	je     800203 <umain+0x1cf>
		cprintf("\nchild detected race\n");
  8001f5:	c7 04 24 95 2e 80 00 	movl   $0x802e95,(%esp)
  8001fc:	e8 50 01 00 00       	call   800351 <cprintf>
  800201:	eb 14                	jmp    800217 <umain+0x1e3>
	else
		cprintf("\nrace didn't happen\n", max);
  800203:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  80020a:	00 
  80020b:	c7 04 24 ab 2e 80 00 	movl   $0x802eab,(%esp)
  800212:	e8 3a 01 00 00       	call   800351 <cprintf>
}
  800217:	83 c4 20             	add    $0x20,%esp
  80021a:	5b                   	pop    %ebx
  80021b:	5e                   	pop    %esi
  80021c:	5d                   	pop    %ebp
  80021d:	c3                   	ret    
	...

00800220 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	83 ec 18             	sub    $0x18,%esp
  800226:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800229:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80022c:	8b 75 08             	mov    0x8(%ebp),%esi
  80022f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  800232:	e8 e2 0f 00 00       	call   801219 <sys_getenvid>
  800237:	25 ff 03 00 00       	and    $0x3ff,%eax
  80023c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80023f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800244:	a3 74 70 80 00       	mov    %eax,0x807074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800249:	85 f6                	test   %esi,%esi
  80024b:	7e 07                	jle    800254 <libmain+0x34>
		binaryname = argv[0];
  80024d:	8b 03                	mov    (%ebx),%eax
  80024f:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  800254:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800258:	89 34 24             	mov    %esi,(%esp)
  80025b:	e8 d4 fd ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800260:	e8 0b 00 00 00       	call   800270 <exit>
}
  800265:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800268:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80026b:	89 ec                	mov    %ebp,%esp
  80026d:	5d                   	pop    %ebp
  80026e:	c3                   	ret    
	...

00800270 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800276:	e8 70 19 00 00       	call   801beb <close_all>
	sys_env_destroy(0);
  80027b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800282:	e8 c6 0f 00 00       	call   80124d <sys_env_destroy>
}
  800287:	c9                   	leave  
  800288:	c3                   	ret    
  800289:	00 00                	add    %al,(%eax)
	...

0080028c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	53                   	push   %ebx
  800290:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  800293:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800296:	a1 78 70 80 00       	mov    0x807078,%eax
  80029b:	85 c0                	test   %eax,%eax
  80029d:	74 10                	je     8002af <_panic+0x23>
		cprintf("%s: ", argv0);
  80029f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002a3:	c7 04 24 01 2f 80 00 	movl   $0x802f01,(%esp)
  8002aa:	e8 a2 00 00 00       	call   800351 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002bd:	a1 00 70 80 00       	mov    0x807000,%eax
  8002c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002c6:	c7 04 24 06 2f 80 00 	movl   $0x802f06,(%esp)
  8002cd:	e8 7f 00 00 00       	call   800351 <cprintf>
	vcprintf(fmt, ap);
  8002d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002d9:	89 04 24             	mov    %eax,(%esp)
  8002dc:	e8 0f 00 00 00       	call   8002f0 <vcprintf>
	cprintf("\n");
  8002e1:	c7 04 24 17 2e 80 00 	movl   $0x802e17,(%esp)
  8002e8:	e8 64 00 00 00       	call   800351 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002ed:	cc                   	int3   
  8002ee:	eb fd                	jmp    8002ed <_panic+0x61>

008002f0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002f9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800300:	00 00 00 
	b.cnt = 0;
  800303:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80030a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800314:	8b 45 08             	mov    0x8(%ebp),%eax
  800317:	89 44 24 08          	mov    %eax,0x8(%esp)
  80031b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800321:	89 44 24 04          	mov    %eax,0x4(%esp)
  800325:	c7 04 24 6b 03 80 00 	movl   $0x80036b,(%esp)
  80032c:	e8 cc 01 00 00       	call   8004fd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800331:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800337:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800341:	89 04 24             	mov    %eax,(%esp)
  800344:	e8 d7 0a 00 00       	call   800e20 <sys_cputs>

	return b.cnt;
}
  800349:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80034f:	c9                   	leave  
  800350:	c3                   	ret    

00800351 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800351:	55                   	push   %ebp
  800352:	89 e5                	mov    %esp,%ebp
  800354:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800357:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80035a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035e:	8b 45 08             	mov    0x8(%ebp),%eax
  800361:	89 04 24             	mov    %eax,(%esp)
  800364:	e8 87 ff ff ff       	call   8002f0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800369:	c9                   	leave  
  80036a:	c3                   	ret    

0080036b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80036b:	55                   	push   %ebp
  80036c:	89 e5                	mov    %esp,%ebp
  80036e:	53                   	push   %ebx
  80036f:	83 ec 14             	sub    $0x14,%esp
  800372:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800375:	8b 03                	mov    (%ebx),%eax
  800377:	8b 55 08             	mov    0x8(%ebp),%edx
  80037a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80037e:	83 c0 01             	add    $0x1,%eax
  800381:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800383:	3d ff 00 00 00       	cmp    $0xff,%eax
  800388:	75 19                	jne    8003a3 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80038a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800391:	00 
  800392:	8d 43 08             	lea    0x8(%ebx),%eax
  800395:	89 04 24             	mov    %eax,(%esp)
  800398:	e8 83 0a 00 00       	call   800e20 <sys_cputs>
		b->idx = 0;
  80039d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8003a3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8003a7:	83 c4 14             	add    $0x14,%esp
  8003aa:	5b                   	pop    %ebx
  8003ab:	5d                   	pop    %ebp
  8003ac:	c3                   	ret    
  8003ad:	00 00                	add    %al,(%eax)
	...

008003b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003b0:	55                   	push   %ebp
  8003b1:	89 e5                	mov    %esp,%ebp
  8003b3:	57                   	push   %edi
  8003b4:	56                   	push   %esi
  8003b5:	53                   	push   %ebx
  8003b6:	83 ec 4c             	sub    $0x4c,%esp
  8003b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003bc:	89 d6                	mov    %edx,%esi
  8003be:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8003ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8003cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003d0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003db:	39 d1                	cmp    %edx,%ecx
  8003dd:	72 15                	jb     8003f4 <printnum+0x44>
  8003df:	77 07                	ja     8003e8 <printnum+0x38>
  8003e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003e4:	39 d0                	cmp    %edx,%eax
  8003e6:	76 0c                	jbe    8003f4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003e8:	83 eb 01             	sub    $0x1,%ebx
  8003eb:	85 db                	test   %ebx,%ebx
  8003ed:	8d 76 00             	lea    0x0(%esi),%esi
  8003f0:	7f 61                	jg     800453 <printnum+0xa3>
  8003f2:	eb 70                	jmp    800464 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003f4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8003f8:	83 eb 01             	sub    $0x1,%ebx
  8003fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  800403:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800407:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80040b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80040e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800411:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800414:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800418:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80041f:	00 
  800420:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800423:	89 04 24             	mov    %eax,(%esp)
  800426:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800429:	89 54 24 04          	mov    %edx,0x4(%esp)
  80042d:	e8 5e 27 00 00       	call   802b90 <__udivdi3>
  800432:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800435:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800438:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80043c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800440:	89 04 24             	mov    %eax,(%esp)
  800443:	89 54 24 04          	mov    %edx,0x4(%esp)
  800447:	89 f2                	mov    %esi,%edx
  800449:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80044c:	e8 5f ff ff ff       	call   8003b0 <printnum>
  800451:	eb 11                	jmp    800464 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800453:	89 74 24 04          	mov    %esi,0x4(%esp)
  800457:	89 3c 24             	mov    %edi,(%esp)
  80045a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80045d:	83 eb 01             	sub    $0x1,%ebx
  800460:	85 db                	test   %ebx,%ebx
  800462:	7f ef                	jg     800453 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800464:	89 74 24 04          	mov    %esi,0x4(%esp)
  800468:	8b 74 24 04          	mov    0x4(%esp),%esi
  80046c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80046f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800473:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80047a:	00 
  80047b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80047e:	89 14 24             	mov    %edx,(%esp)
  800481:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800484:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800488:	e8 33 28 00 00       	call   802cc0 <__umoddi3>
  80048d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800491:	0f be 80 22 2f 80 00 	movsbl 0x802f22(%eax),%eax
  800498:	89 04 24             	mov    %eax,(%esp)
  80049b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80049e:	83 c4 4c             	add    $0x4c,%esp
  8004a1:	5b                   	pop    %ebx
  8004a2:	5e                   	pop    %esi
  8004a3:	5f                   	pop    %edi
  8004a4:	5d                   	pop    %ebp
  8004a5:	c3                   	ret    

008004a6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004a9:	83 fa 01             	cmp    $0x1,%edx
  8004ac:	7e 0e                	jle    8004bc <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8004ae:	8b 10                	mov    (%eax),%edx
  8004b0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8004b3:	89 08                	mov    %ecx,(%eax)
  8004b5:	8b 02                	mov    (%edx),%eax
  8004b7:	8b 52 04             	mov    0x4(%edx),%edx
  8004ba:	eb 22                	jmp    8004de <getuint+0x38>
	else if (lflag)
  8004bc:	85 d2                	test   %edx,%edx
  8004be:	74 10                	je     8004d0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8004c0:	8b 10                	mov    (%eax),%edx
  8004c2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004c5:	89 08                	mov    %ecx,(%eax)
  8004c7:	8b 02                	mov    (%edx),%eax
  8004c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ce:	eb 0e                	jmp    8004de <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8004d0:	8b 10                	mov    (%eax),%edx
  8004d2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8004d5:	89 08                	mov    %ecx,(%eax)
  8004d7:	8b 02                	mov    (%edx),%eax
  8004d9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004de:	5d                   	pop    %ebp
  8004df:	c3                   	ret    

008004e0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8004e6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8004ea:	8b 10                	mov    (%eax),%edx
  8004ec:	3b 50 04             	cmp    0x4(%eax),%edx
  8004ef:	73 0a                	jae    8004fb <sprintputch+0x1b>
		*b->buf++ = ch;
  8004f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004f4:	88 0a                	mov    %cl,(%edx)
  8004f6:	83 c2 01             	add    $0x1,%edx
  8004f9:	89 10                	mov    %edx,(%eax)
}
  8004fb:	5d                   	pop    %ebp
  8004fc:	c3                   	ret    

008004fd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004fd:	55                   	push   %ebp
  8004fe:	89 e5                	mov    %esp,%ebp
  800500:	57                   	push   %edi
  800501:	56                   	push   %esi
  800502:	53                   	push   %ebx
  800503:	83 ec 5c             	sub    $0x5c,%esp
  800506:	8b 7d 08             	mov    0x8(%ebp),%edi
  800509:	8b 75 0c             	mov    0xc(%ebp),%esi
  80050c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80050f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800516:	eb 11                	jmp    800529 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800518:	85 c0                	test   %eax,%eax
  80051a:	0f 84 09 04 00 00    	je     800929 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  800520:	89 74 24 04          	mov    %esi,0x4(%esp)
  800524:	89 04 24             	mov    %eax,(%esp)
  800527:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800529:	0f b6 03             	movzbl (%ebx),%eax
  80052c:	83 c3 01             	add    $0x1,%ebx
  80052f:	83 f8 25             	cmp    $0x25,%eax
  800532:	75 e4                	jne    800518 <vprintfmt+0x1b>
  800534:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800538:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80053f:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800546:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80054d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800552:	eb 06                	jmp    80055a <vprintfmt+0x5d>
  800554:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800558:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80055a:	0f b6 13             	movzbl (%ebx),%edx
  80055d:	0f b6 c2             	movzbl %dl,%eax
  800560:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800563:	8d 43 01             	lea    0x1(%ebx),%eax
  800566:	83 ea 23             	sub    $0x23,%edx
  800569:	80 fa 55             	cmp    $0x55,%dl
  80056c:	0f 87 9a 03 00 00    	ja     80090c <vprintfmt+0x40f>
  800572:	0f b6 d2             	movzbl %dl,%edx
  800575:	ff 24 95 60 30 80 00 	jmp    *0x803060(,%edx,4)
  80057c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800580:	eb d6                	jmp    800558 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800582:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800585:	83 ea 30             	sub    $0x30,%edx
  800588:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  80058b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80058e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800591:	83 fb 09             	cmp    $0x9,%ebx
  800594:	77 4c                	ja     8005e2 <vprintfmt+0xe5>
  800596:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800599:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80059c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80059f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8005a2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8005a6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8005a9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8005ac:	83 fb 09             	cmp    $0x9,%ebx
  8005af:	76 eb                	jbe    80059c <vprintfmt+0x9f>
  8005b1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8005b4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005b7:	eb 29                	jmp    8005e2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8005b9:	8b 55 14             	mov    0x14(%ebp),%edx
  8005bc:	8d 5a 04             	lea    0x4(%edx),%ebx
  8005bf:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8005c2:	8b 12                	mov    (%edx),%edx
  8005c4:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  8005c7:	eb 19                	jmp    8005e2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8005c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8005cc:	c1 fa 1f             	sar    $0x1f,%edx
  8005cf:	f7 d2                	not    %edx
  8005d1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8005d4:	eb 82                	jmp    800558 <vprintfmt+0x5b>
  8005d6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8005dd:	e9 76 ff ff ff       	jmp    800558 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8005e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8005e6:	0f 89 6c ff ff ff    	jns    800558 <vprintfmt+0x5b>
  8005ec:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8005ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005f2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8005f5:	89 55 cc             	mov    %edx,-0x34(%ebp)
  8005f8:	e9 5b ff ff ff       	jmp    800558 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005fd:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800600:	e9 53 ff ff ff       	jmp    800558 <vprintfmt+0x5b>
  800605:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800608:	8b 45 14             	mov    0x14(%ebp),%eax
  80060b:	8d 50 04             	lea    0x4(%eax),%edx
  80060e:	89 55 14             	mov    %edx,0x14(%ebp)
  800611:	89 74 24 04          	mov    %esi,0x4(%esp)
  800615:	8b 00                	mov    (%eax),%eax
  800617:	89 04 24             	mov    %eax,(%esp)
  80061a:	ff d7                	call   *%edi
  80061c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80061f:	e9 05 ff ff ff       	jmp    800529 <vprintfmt+0x2c>
  800624:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800627:	8b 45 14             	mov    0x14(%ebp),%eax
  80062a:	8d 50 04             	lea    0x4(%eax),%edx
  80062d:	89 55 14             	mov    %edx,0x14(%ebp)
  800630:	8b 00                	mov    (%eax),%eax
  800632:	89 c2                	mov    %eax,%edx
  800634:	c1 fa 1f             	sar    $0x1f,%edx
  800637:	31 d0                	xor    %edx,%eax
  800639:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80063b:	83 f8 0f             	cmp    $0xf,%eax
  80063e:	7f 0b                	jg     80064b <vprintfmt+0x14e>
  800640:	8b 14 85 c0 31 80 00 	mov    0x8031c0(,%eax,4),%edx
  800647:	85 d2                	test   %edx,%edx
  800649:	75 20                	jne    80066b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80064b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80064f:	c7 44 24 08 33 2f 80 	movl   $0x802f33,0x8(%esp)
  800656:	00 
  800657:	89 74 24 04          	mov    %esi,0x4(%esp)
  80065b:	89 3c 24             	mov    %edi,(%esp)
  80065e:	e8 4e 03 00 00       	call   8009b1 <printfmt>
  800663:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800666:	e9 be fe ff ff       	jmp    800529 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80066b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80066f:	c7 44 24 08 e1 33 80 	movl   $0x8033e1,0x8(%esp)
  800676:	00 
  800677:	89 74 24 04          	mov    %esi,0x4(%esp)
  80067b:	89 3c 24             	mov    %edi,(%esp)
  80067e:	e8 2e 03 00 00       	call   8009b1 <printfmt>
  800683:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800686:	e9 9e fe ff ff       	jmp    800529 <vprintfmt+0x2c>
  80068b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80068e:	89 c3                	mov    %eax,%ebx
  800690:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800696:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8d 50 04             	lea    0x4(%eax),%edx
  80069f:	89 55 14             	mov    %edx,0x14(%ebp)
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8006a7:	85 c0                	test   %eax,%eax
  8006a9:	75 07                	jne    8006b2 <vprintfmt+0x1b5>
  8006ab:	c7 45 c4 3c 2f 80 00 	movl   $0x802f3c,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  8006b2:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8006b6:	7e 06                	jle    8006be <vprintfmt+0x1c1>
  8006b8:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  8006bc:	75 13                	jne    8006d1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006be:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006c1:	0f be 02             	movsbl (%edx),%eax
  8006c4:	85 c0                	test   %eax,%eax
  8006c6:	0f 85 99 00 00 00    	jne    800765 <vprintfmt+0x268>
  8006cc:	e9 86 00 00 00       	jmp    800757 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006d1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8006d5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8006d8:	89 0c 24             	mov    %ecx,(%esp)
  8006db:	e8 1b 03 00 00       	call   8009fb <strnlen>
  8006e0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8006e3:	29 c2                	sub    %eax,%edx
  8006e5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006e8:	85 d2                	test   %edx,%edx
  8006ea:	7e d2                	jle    8006be <vprintfmt+0x1c1>
					putch(padc, putdat);
  8006ec:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  8006f0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006f3:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  8006f6:	89 d3                	mov    %edx,%ebx
  8006f8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006ff:	89 04 24             	mov    %eax,(%esp)
  800702:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800704:	83 eb 01             	sub    $0x1,%ebx
  800707:	85 db                	test   %ebx,%ebx
  800709:	7f ed                	jg     8006f8 <vprintfmt+0x1fb>
  80070b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80070e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800715:	eb a7                	jmp    8006be <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800717:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80071b:	74 18                	je     800735 <vprintfmt+0x238>
  80071d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800720:	83 fa 5e             	cmp    $0x5e,%edx
  800723:	76 10                	jbe    800735 <vprintfmt+0x238>
					putch('?', putdat);
  800725:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800729:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800730:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800733:	eb 0a                	jmp    80073f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800735:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800739:	89 04 24             	mov    %eax,(%esp)
  80073c:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80073f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800743:	0f be 03             	movsbl (%ebx),%eax
  800746:	85 c0                	test   %eax,%eax
  800748:	74 05                	je     80074f <vprintfmt+0x252>
  80074a:	83 c3 01             	add    $0x1,%ebx
  80074d:	eb 29                	jmp    800778 <vprintfmt+0x27b>
  80074f:	89 fe                	mov    %edi,%esi
  800751:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800754:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800757:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80075b:	7f 2e                	jg     80078b <vprintfmt+0x28e>
  80075d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800760:	e9 c4 fd ff ff       	jmp    800529 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800765:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800768:	83 c2 01             	add    $0x1,%edx
  80076b:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80076e:	89 f7                	mov    %esi,%edi
  800770:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800773:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  800776:	89 d3                	mov    %edx,%ebx
  800778:	85 f6                	test   %esi,%esi
  80077a:	78 9b                	js     800717 <vprintfmt+0x21a>
  80077c:	83 ee 01             	sub    $0x1,%esi
  80077f:	79 96                	jns    800717 <vprintfmt+0x21a>
  800781:	89 fe                	mov    %edi,%esi
  800783:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800786:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800789:	eb cc                	jmp    800757 <vprintfmt+0x25a>
  80078b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  80078e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800791:	89 74 24 04          	mov    %esi,0x4(%esp)
  800795:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80079c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079e:	83 eb 01             	sub    $0x1,%ebx
  8007a1:	85 db                	test   %ebx,%ebx
  8007a3:	7f ec                	jg     800791 <vprintfmt+0x294>
  8007a5:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8007a8:	e9 7c fd ff ff       	jmp    800529 <vprintfmt+0x2c>
  8007ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8007b0:	83 f9 01             	cmp    $0x1,%ecx
  8007b3:	7e 16                	jle    8007cb <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  8007b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b8:	8d 50 08             	lea    0x8(%eax),%edx
  8007bb:	89 55 14             	mov    %edx,0x14(%ebp)
  8007be:	8b 10                	mov    (%eax),%edx
  8007c0:	8b 48 04             	mov    0x4(%eax),%ecx
  8007c3:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8007c6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007c9:	eb 32                	jmp    8007fd <vprintfmt+0x300>
	else if (lflag)
  8007cb:	85 c9                	test   %ecx,%ecx
  8007cd:	74 18                	je     8007e7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8d 50 04             	lea    0x4(%eax),%edx
  8007d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007dd:	89 c1                	mov    %eax,%ecx
  8007df:	c1 f9 1f             	sar    $0x1f,%ecx
  8007e2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8007e5:	eb 16                	jmp    8007fd <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8d 50 04             	lea    0x4(%eax),%edx
  8007ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007f5:	89 c2                	mov    %eax,%edx
  8007f7:	c1 fa 1f             	sar    $0x1f,%edx
  8007fa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007fd:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800800:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800803:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800808:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80080c:	0f 89 b8 00 00 00    	jns    8008ca <vprintfmt+0x3cd>
				putch('-', putdat);
  800812:	89 74 24 04          	mov    %esi,0x4(%esp)
  800816:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80081d:	ff d7                	call   *%edi
				num = -(long long) num;
  80081f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800822:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800825:	f7 d9                	neg    %ecx
  800827:	83 d3 00             	adc    $0x0,%ebx
  80082a:	f7 db                	neg    %ebx
  80082c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800831:	e9 94 00 00 00       	jmp    8008ca <vprintfmt+0x3cd>
  800836:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800839:	89 ca                	mov    %ecx,%edx
  80083b:	8d 45 14             	lea    0x14(%ebp),%eax
  80083e:	e8 63 fc ff ff       	call   8004a6 <getuint>
  800843:	89 c1                	mov    %eax,%ecx
  800845:	89 d3                	mov    %edx,%ebx
  800847:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80084c:	eb 7c                	jmp    8008ca <vprintfmt+0x3cd>
  80084e:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800851:	89 74 24 04          	mov    %esi,0x4(%esp)
  800855:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  80085c:	ff d7                	call   *%edi
			putch('X', putdat);
  80085e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800862:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800869:	ff d7                	call   *%edi
			putch('X', putdat);
  80086b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80086f:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800876:	ff d7                	call   *%edi
  800878:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80087b:	e9 a9 fc ff ff       	jmp    800529 <vprintfmt+0x2c>
  800880:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800883:	89 74 24 04          	mov    %esi,0x4(%esp)
  800887:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80088e:	ff d7                	call   *%edi
			putch('x', putdat);
  800890:	89 74 24 04          	mov    %esi,0x4(%esp)
  800894:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80089b:	ff d7                	call   *%edi
			num = (unsigned long long)
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	8d 50 04             	lea    0x4(%eax),%edx
  8008a3:	89 55 14             	mov    %edx,0x14(%ebp)
  8008a6:	8b 08                	mov    (%eax),%ecx
  8008a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008ad:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8008b2:	eb 16                	jmp    8008ca <vprintfmt+0x3cd>
  8008b4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8008b7:	89 ca                	mov    %ecx,%edx
  8008b9:	8d 45 14             	lea    0x14(%ebp),%eax
  8008bc:	e8 e5 fb ff ff       	call   8004a6 <getuint>
  8008c1:	89 c1                	mov    %eax,%ecx
  8008c3:	89 d3                	mov    %edx,%ebx
  8008c5:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008ca:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  8008ce:	89 54 24 10          	mov    %edx,0x10(%esp)
  8008d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8008d5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8008d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008dd:	89 0c 24             	mov    %ecx,(%esp)
  8008e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8008e4:	89 f2                	mov    %esi,%edx
  8008e6:	89 f8                	mov    %edi,%eax
  8008e8:	e8 c3 fa ff ff       	call   8003b0 <printnum>
  8008ed:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8008f0:	e9 34 fc ff ff       	jmp    800529 <vprintfmt+0x2c>
  8008f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008f8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008fb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008ff:	89 14 24             	mov    %edx,(%esp)
  800902:	ff d7                	call   *%edi
  800904:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800907:	e9 1d fc ff ff       	jmp    800529 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80090c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800910:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800917:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800919:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80091c:	80 38 25             	cmpb   $0x25,(%eax)
  80091f:	0f 84 04 fc ff ff    	je     800529 <vprintfmt+0x2c>
  800925:	89 c3                	mov    %eax,%ebx
  800927:	eb f0                	jmp    800919 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  800929:	83 c4 5c             	add    $0x5c,%esp
  80092c:	5b                   	pop    %ebx
  80092d:	5e                   	pop    %esi
  80092e:	5f                   	pop    %edi
  80092f:	5d                   	pop    %ebp
  800930:	c3                   	ret    

00800931 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	83 ec 28             	sub    $0x28,%esp
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  80093d:	85 c0                	test   %eax,%eax
  80093f:	74 04                	je     800945 <vsnprintf+0x14>
  800941:	85 d2                	test   %edx,%edx
  800943:	7f 07                	jg     80094c <vsnprintf+0x1b>
  800945:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80094a:	eb 3b                	jmp    800987 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80094c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80094f:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800953:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800956:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800964:	8b 45 10             	mov    0x10(%ebp),%eax
  800967:	89 44 24 08          	mov    %eax,0x8(%esp)
  80096b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80096e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800972:	c7 04 24 e0 04 80 00 	movl   $0x8004e0,(%esp)
  800979:	e8 7f fb ff ff       	call   8004fd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80097e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800981:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800984:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800987:	c9                   	leave  
  800988:	c3                   	ret    

00800989 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800989:	55                   	push   %ebp
  80098a:	89 e5                	mov    %esp,%ebp
  80098c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80098f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800992:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800996:	8b 45 10             	mov    0x10(%ebp),%eax
  800999:	89 44 24 08          	mov    %eax,0x8(%esp)
  80099d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	89 04 24             	mov    %eax,(%esp)
  8009aa:	e8 82 ff ff ff       	call   800931 <vsnprintf>
	va_end(ap);

	return rc;
}
  8009af:	c9                   	leave  
  8009b0:	c3                   	ret    

008009b1 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009b1:	55                   	push   %ebp
  8009b2:	89 e5                	mov    %esp,%ebp
  8009b4:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8009b7:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8009ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009be:	8b 45 10             	mov    0x10(%ebp),%eax
  8009c1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	89 04 24             	mov    %eax,(%esp)
  8009d2:	e8 26 fb ff ff       	call   8004fd <vprintfmt>
	va_end(ap);
}
  8009d7:	c9                   	leave  
  8009d8:	c3                   	ret    
  8009d9:	00 00                	add    %al,(%eax)
  8009db:	00 00                	add    %al,(%eax)
  8009dd:	00 00                	add    %al,(%eax)
	...

008009e0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8009e0:	55                   	push   %ebp
  8009e1:	89 e5                	mov    %esp,%ebp
  8009e3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8009e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8009eb:	80 3a 00             	cmpb   $0x0,(%edx)
  8009ee:	74 09                	je     8009f9 <strlen+0x19>
		n++;
  8009f0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009f3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009f7:	75 f7                	jne    8009f0 <strlen+0x10>
		n++;
	return n;
}
  8009f9:	5d                   	pop    %ebp
  8009fa:	c3                   	ret    

008009fb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009fb:	55                   	push   %ebp
  8009fc:	89 e5                	mov    %esp,%ebp
  8009fe:	53                   	push   %ebx
  8009ff:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a05:	85 c9                	test   %ecx,%ecx
  800a07:	74 19                	je     800a22 <strnlen+0x27>
  800a09:	80 3b 00             	cmpb   $0x0,(%ebx)
  800a0c:	74 14                	je     800a22 <strnlen+0x27>
  800a0e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800a13:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a16:	39 c8                	cmp    %ecx,%eax
  800a18:	74 0d                	je     800a27 <strnlen+0x2c>
  800a1a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800a1e:	75 f3                	jne    800a13 <strnlen+0x18>
  800a20:	eb 05                	jmp    800a27 <strnlen+0x2c>
  800a22:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800a27:	5b                   	pop    %ebx
  800a28:	5d                   	pop    %ebp
  800a29:	c3                   	ret    

00800a2a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a2a:	55                   	push   %ebp
  800a2b:	89 e5                	mov    %esp,%ebp
  800a2d:	53                   	push   %ebx
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800a34:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800a39:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800a3d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800a40:	83 c2 01             	add    $0x1,%edx
  800a43:	84 c9                	test   %cl,%cl
  800a45:	75 f2                	jne    800a39 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800a47:	5b                   	pop    %ebx
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    

00800a4a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800a4a:	55                   	push   %ebp
  800a4b:	89 e5                	mov    %esp,%ebp
  800a4d:	56                   	push   %esi
  800a4e:	53                   	push   %ebx
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a55:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a58:	85 f6                	test   %esi,%esi
  800a5a:	74 18                	je     800a74 <strncpy+0x2a>
  800a5c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800a61:	0f b6 1a             	movzbl (%edx),%ebx
  800a64:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a67:	80 3a 01             	cmpb   $0x1,(%edx)
  800a6a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a6d:	83 c1 01             	add    $0x1,%ecx
  800a70:	39 ce                	cmp    %ecx,%esi
  800a72:	77 ed                	ja     800a61 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a74:	5b                   	pop    %ebx
  800a75:	5e                   	pop    %esi
  800a76:	5d                   	pop    %ebp
  800a77:	c3                   	ret    

00800a78 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	56                   	push   %esi
  800a7c:	53                   	push   %ebx
  800a7d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a83:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a86:	89 f0                	mov    %esi,%eax
  800a88:	85 c9                	test   %ecx,%ecx
  800a8a:	74 27                	je     800ab3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800a8c:	83 e9 01             	sub    $0x1,%ecx
  800a8f:	74 1d                	je     800aae <strlcpy+0x36>
  800a91:	0f b6 1a             	movzbl (%edx),%ebx
  800a94:	84 db                	test   %bl,%bl
  800a96:	74 16                	je     800aae <strlcpy+0x36>
			*dst++ = *src++;
  800a98:	88 18                	mov    %bl,(%eax)
  800a9a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a9d:	83 e9 01             	sub    $0x1,%ecx
  800aa0:	74 0e                	je     800ab0 <strlcpy+0x38>
			*dst++ = *src++;
  800aa2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800aa5:	0f b6 1a             	movzbl (%edx),%ebx
  800aa8:	84 db                	test   %bl,%bl
  800aaa:	75 ec                	jne    800a98 <strlcpy+0x20>
  800aac:	eb 02                	jmp    800ab0 <strlcpy+0x38>
  800aae:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800ab0:	c6 00 00             	movb   $0x0,(%eax)
  800ab3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800ab5:	5b                   	pop    %ebx
  800ab6:	5e                   	pop    %esi
  800ab7:	5d                   	pop    %ebp
  800ab8:	c3                   	ret    

00800ab9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800abf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ac2:	0f b6 01             	movzbl (%ecx),%eax
  800ac5:	84 c0                	test   %al,%al
  800ac7:	74 15                	je     800ade <strcmp+0x25>
  800ac9:	3a 02                	cmp    (%edx),%al
  800acb:	75 11                	jne    800ade <strcmp+0x25>
		p++, q++;
  800acd:	83 c1 01             	add    $0x1,%ecx
  800ad0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ad3:	0f b6 01             	movzbl (%ecx),%eax
  800ad6:	84 c0                	test   %al,%al
  800ad8:	74 04                	je     800ade <strcmp+0x25>
  800ada:	3a 02                	cmp    (%edx),%al
  800adc:	74 ef                	je     800acd <strcmp+0x14>
  800ade:	0f b6 c0             	movzbl %al,%eax
  800ae1:	0f b6 12             	movzbl (%edx),%edx
  800ae4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ae6:	5d                   	pop    %ebp
  800ae7:	c3                   	ret    

00800ae8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ae8:	55                   	push   %ebp
  800ae9:	89 e5                	mov    %esp,%ebp
  800aeb:	53                   	push   %ebx
  800aec:	8b 55 08             	mov    0x8(%ebp),%edx
  800aef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800af2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800af5:	85 c0                	test   %eax,%eax
  800af7:	74 23                	je     800b1c <strncmp+0x34>
  800af9:	0f b6 1a             	movzbl (%edx),%ebx
  800afc:	84 db                	test   %bl,%bl
  800afe:	74 24                	je     800b24 <strncmp+0x3c>
  800b00:	3a 19                	cmp    (%ecx),%bl
  800b02:	75 20                	jne    800b24 <strncmp+0x3c>
  800b04:	83 e8 01             	sub    $0x1,%eax
  800b07:	74 13                	je     800b1c <strncmp+0x34>
		n--, p++, q++;
  800b09:	83 c2 01             	add    $0x1,%edx
  800b0c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800b0f:	0f b6 1a             	movzbl (%edx),%ebx
  800b12:	84 db                	test   %bl,%bl
  800b14:	74 0e                	je     800b24 <strncmp+0x3c>
  800b16:	3a 19                	cmp    (%ecx),%bl
  800b18:	74 ea                	je     800b04 <strncmp+0x1c>
  800b1a:	eb 08                	jmp    800b24 <strncmp+0x3c>
  800b1c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800b21:	5b                   	pop    %ebx
  800b22:	5d                   	pop    %ebp
  800b23:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b24:	0f b6 02             	movzbl (%edx),%eax
  800b27:	0f b6 11             	movzbl (%ecx),%edx
  800b2a:	29 d0                	sub    %edx,%eax
  800b2c:	eb f3                	jmp    800b21 <strncmp+0x39>

00800b2e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b2e:	55                   	push   %ebp
  800b2f:	89 e5                	mov    %esp,%ebp
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b38:	0f b6 10             	movzbl (%eax),%edx
  800b3b:	84 d2                	test   %dl,%dl
  800b3d:	74 15                	je     800b54 <strchr+0x26>
		if (*s == c)
  800b3f:	38 ca                	cmp    %cl,%dl
  800b41:	75 07                	jne    800b4a <strchr+0x1c>
  800b43:	eb 14                	jmp    800b59 <strchr+0x2b>
  800b45:	38 ca                	cmp    %cl,%dl
  800b47:	90                   	nop
  800b48:	74 0f                	je     800b59 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800b4a:	83 c0 01             	add    $0x1,%eax
  800b4d:	0f b6 10             	movzbl (%eax),%edx
  800b50:	84 d2                	test   %dl,%dl
  800b52:	75 f1                	jne    800b45 <strchr+0x17>
  800b54:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b65:	0f b6 10             	movzbl (%eax),%edx
  800b68:	84 d2                	test   %dl,%dl
  800b6a:	74 18                	je     800b84 <strfind+0x29>
		if (*s == c)
  800b6c:	38 ca                	cmp    %cl,%dl
  800b6e:	75 0a                	jne    800b7a <strfind+0x1f>
  800b70:	eb 12                	jmp    800b84 <strfind+0x29>
  800b72:	38 ca                	cmp    %cl,%dl
  800b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800b78:	74 0a                	je     800b84 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b7a:	83 c0 01             	add    $0x1,%eax
  800b7d:	0f b6 10             	movzbl (%eax),%edx
  800b80:	84 d2                	test   %dl,%dl
  800b82:	75 ee                	jne    800b72 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800b84:	5d                   	pop    %ebp
  800b85:	c3                   	ret    

00800b86 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	83 ec 0c             	sub    $0xc,%esp
  800b8c:	89 1c 24             	mov    %ebx,(%esp)
  800b8f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b93:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800b97:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ba0:	85 c9                	test   %ecx,%ecx
  800ba2:	74 30                	je     800bd4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ba4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800baa:	75 25                	jne    800bd1 <memset+0x4b>
  800bac:	f6 c1 03             	test   $0x3,%cl
  800baf:	75 20                	jne    800bd1 <memset+0x4b>
		c &= 0xFF;
  800bb1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800bb4:	89 d3                	mov    %edx,%ebx
  800bb6:	c1 e3 08             	shl    $0x8,%ebx
  800bb9:	89 d6                	mov    %edx,%esi
  800bbb:	c1 e6 18             	shl    $0x18,%esi
  800bbe:	89 d0                	mov    %edx,%eax
  800bc0:	c1 e0 10             	shl    $0x10,%eax
  800bc3:	09 f0                	or     %esi,%eax
  800bc5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800bc7:	09 d8                	or     %ebx,%eax
  800bc9:	c1 e9 02             	shr    $0x2,%ecx
  800bcc:	fc                   	cld    
  800bcd:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800bcf:	eb 03                	jmp    800bd4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800bd1:	fc                   	cld    
  800bd2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800bd4:	89 f8                	mov    %edi,%eax
  800bd6:	8b 1c 24             	mov    (%esp),%ebx
  800bd9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800bdd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800be1:	89 ec                	mov    %ebp,%esp
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	83 ec 08             	sub    $0x8,%esp
  800beb:	89 34 24             	mov    %esi,(%esp)
  800bee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800bf8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800bfb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800bfd:	39 c6                	cmp    %eax,%esi
  800bff:	73 35                	jae    800c36 <memmove+0x51>
  800c01:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800c04:	39 d0                	cmp    %edx,%eax
  800c06:	73 2e                	jae    800c36 <memmove+0x51>
		s += n;
		d += n;
  800c08:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c0a:	f6 c2 03             	test   $0x3,%dl
  800c0d:	75 1b                	jne    800c2a <memmove+0x45>
  800c0f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c15:	75 13                	jne    800c2a <memmove+0x45>
  800c17:	f6 c1 03             	test   $0x3,%cl
  800c1a:	75 0e                	jne    800c2a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800c1c:	83 ef 04             	sub    $0x4,%edi
  800c1f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800c22:	c1 e9 02             	shr    $0x2,%ecx
  800c25:	fd                   	std    
  800c26:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c28:	eb 09                	jmp    800c33 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800c2a:	83 ef 01             	sub    $0x1,%edi
  800c2d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800c30:	fd                   	std    
  800c31:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800c33:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800c34:	eb 20                	jmp    800c56 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c36:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800c3c:	75 15                	jne    800c53 <memmove+0x6e>
  800c3e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c44:	75 0d                	jne    800c53 <memmove+0x6e>
  800c46:	f6 c1 03             	test   $0x3,%cl
  800c49:	75 08                	jne    800c53 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800c4b:	c1 e9 02             	shr    $0x2,%ecx
  800c4e:	fc                   	cld    
  800c4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c51:	eb 03                	jmp    800c56 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c53:	fc                   	cld    
  800c54:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c56:	8b 34 24             	mov    (%esp),%esi
  800c59:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800c5d:	89 ec                	mov    %ebp,%esp
  800c5f:	5d                   	pop    %ebp
  800c60:	c3                   	ret    

00800c61 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c67:	8b 45 10             	mov    0x10(%ebp),%eax
  800c6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c71:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c75:	8b 45 08             	mov    0x8(%ebp),%eax
  800c78:	89 04 24             	mov    %eax,(%esp)
  800c7b:	e8 65 ff ff ff       	call   800be5 <memmove>
}
  800c80:	c9                   	leave  
  800c81:	c3                   	ret    

00800c82 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	57                   	push   %edi
  800c86:	56                   	push   %esi
  800c87:	53                   	push   %ebx
  800c88:	8b 75 08             	mov    0x8(%ebp),%esi
  800c8b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800c8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c91:	85 c9                	test   %ecx,%ecx
  800c93:	74 36                	je     800ccb <memcmp+0x49>
		if (*s1 != *s2)
  800c95:	0f b6 06             	movzbl (%esi),%eax
  800c98:	0f b6 1f             	movzbl (%edi),%ebx
  800c9b:	38 d8                	cmp    %bl,%al
  800c9d:	74 20                	je     800cbf <memcmp+0x3d>
  800c9f:	eb 14                	jmp    800cb5 <memcmp+0x33>
  800ca1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800ca6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800cab:	83 c2 01             	add    $0x1,%edx
  800cae:	83 e9 01             	sub    $0x1,%ecx
  800cb1:	38 d8                	cmp    %bl,%al
  800cb3:	74 12                	je     800cc7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800cb5:	0f b6 c0             	movzbl %al,%eax
  800cb8:	0f b6 db             	movzbl %bl,%ebx
  800cbb:	29 d8                	sub    %ebx,%eax
  800cbd:	eb 11                	jmp    800cd0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800cbf:	83 e9 01             	sub    $0x1,%ecx
  800cc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800cc7:	85 c9                	test   %ecx,%ecx
  800cc9:	75 d6                	jne    800ca1 <memcmp+0x1f>
  800ccb:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800cd0:	5b                   	pop    %ebx
  800cd1:	5e                   	pop    %esi
  800cd2:	5f                   	pop    %edi
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800cdb:	89 c2                	mov    %eax,%edx
  800cdd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ce0:	39 d0                	cmp    %edx,%eax
  800ce2:	73 15                	jae    800cf9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ce4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800ce8:	38 08                	cmp    %cl,(%eax)
  800cea:	75 06                	jne    800cf2 <memfind+0x1d>
  800cec:	eb 0b                	jmp    800cf9 <memfind+0x24>
  800cee:	38 08                	cmp    %cl,(%eax)
  800cf0:	74 07                	je     800cf9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800cf2:	83 c0 01             	add    $0x1,%eax
  800cf5:	39 c2                	cmp    %eax,%edx
  800cf7:	77 f5                	ja     800cee <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    

00800cfb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	57                   	push   %edi
  800cff:	56                   	push   %esi
  800d00:	53                   	push   %ebx
  800d01:	83 ec 04             	sub    $0x4,%esp
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d0a:	0f b6 02             	movzbl (%edx),%eax
  800d0d:	3c 20                	cmp    $0x20,%al
  800d0f:	74 04                	je     800d15 <strtol+0x1a>
  800d11:	3c 09                	cmp    $0x9,%al
  800d13:	75 0e                	jne    800d23 <strtol+0x28>
		s++;
  800d15:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d18:	0f b6 02             	movzbl (%edx),%eax
  800d1b:	3c 20                	cmp    $0x20,%al
  800d1d:	74 f6                	je     800d15 <strtol+0x1a>
  800d1f:	3c 09                	cmp    $0x9,%al
  800d21:	74 f2                	je     800d15 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d23:	3c 2b                	cmp    $0x2b,%al
  800d25:	75 0c                	jne    800d33 <strtol+0x38>
		s++;
  800d27:	83 c2 01             	add    $0x1,%edx
  800d2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d31:	eb 15                	jmp    800d48 <strtol+0x4d>
	else if (*s == '-')
  800d33:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800d3a:	3c 2d                	cmp    $0x2d,%al
  800d3c:	75 0a                	jne    800d48 <strtol+0x4d>
		s++, neg = 1;
  800d3e:	83 c2 01             	add    $0x1,%edx
  800d41:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d48:	85 db                	test   %ebx,%ebx
  800d4a:	0f 94 c0             	sete   %al
  800d4d:	74 05                	je     800d54 <strtol+0x59>
  800d4f:	83 fb 10             	cmp    $0x10,%ebx
  800d52:	75 18                	jne    800d6c <strtol+0x71>
  800d54:	80 3a 30             	cmpb   $0x30,(%edx)
  800d57:	75 13                	jne    800d6c <strtol+0x71>
  800d59:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d5d:	8d 76 00             	lea    0x0(%esi),%esi
  800d60:	75 0a                	jne    800d6c <strtol+0x71>
		s += 2, base = 16;
  800d62:	83 c2 02             	add    $0x2,%edx
  800d65:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d6a:	eb 15                	jmp    800d81 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d6c:	84 c0                	test   %al,%al
  800d6e:	66 90                	xchg   %ax,%ax
  800d70:	74 0f                	je     800d81 <strtol+0x86>
  800d72:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800d77:	80 3a 30             	cmpb   $0x30,(%edx)
  800d7a:	75 05                	jne    800d81 <strtol+0x86>
		s++, base = 8;
  800d7c:	83 c2 01             	add    $0x1,%edx
  800d7f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d81:	b8 00 00 00 00       	mov    $0x0,%eax
  800d86:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d88:	0f b6 0a             	movzbl (%edx),%ecx
  800d8b:	89 cf                	mov    %ecx,%edi
  800d8d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800d90:	80 fb 09             	cmp    $0x9,%bl
  800d93:	77 08                	ja     800d9d <strtol+0xa2>
			dig = *s - '0';
  800d95:	0f be c9             	movsbl %cl,%ecx
  800d98:	83 e9 30             	sub    $0x30,%ecx
  800d9b:	eb 1e                	jmp    800dbb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800d9d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800da0:	80 fb 19             	cmp    $0x19,%bl
  800da3:	77 08                	ja     800dad <strtol+0xb2>
			dig = *s - 'a' + 10;
  800da5:	0f be c9             	movsbl %cl,%ecx
  800da8:	83 e9 57             	sub    $0x57,%ecx
  800dab:	eb 0e                	jmp    800dbb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800dad:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800db0:	80 fb 19             	cmp    $0x19,%bl
  800db3:	77 15                	ja     800dca <strtol+0xcf>
			dig = *s - 'A' + 10;
  800db5:	0f be c9             	movsbl %cl,%ecx
  800db8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800dbb:	39 f1                	cmp    %esi,%ecx
  800dbd:	7d 0b                	jge    800dca <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800dbf:	83 c2 01             	add    $0x1,%edx
  800dc2:	0f af c6             	imul   %esi,%eax
  800dc5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800dc8:	eb be                	jmp    800d88 <strtol+0x8d>
  800dca:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800dcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dd0:	74 05                	je     800dd7 <strtol+0xdc>
		*endptr = (char *) s;
  800dd2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800dd5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800dd7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ddb:	74 04                	je     800de1 <strtol+0xe6>
  800ddd:	89 c8                	mov    %ecx,%eax
  800ddf:	f7 d8                	neg    %eax
}
  800de1:	83 c4 04             	add    $0x4,%esp
  800de4:	5b                   	pop    %ebx
  800de5:	5e                   	pop    %esi
  800de6:	5f                   	pop    %edi
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    
  800de9:	00 00                	add    %al,(%eax)
	...

00800dec <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	83 ec 0c             	sub    $0xc,%esp
  800df2:	89 1c 24             	mov    %ebx,(%esp)
  800df5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800df9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dfd:	ba 00 00 00 00       	mov    $0x0,%edx
  800e02:	b8 01 00 00 00       	mov    $0x1,%eax
  800e07:	89 d1                	mov    %edx,%ecx
  800e09:	89 d3                	mov    %edx,%ebx
  800e0b:	89 d7                	mov    %edx,%edi
  800e0d:	89 d6                	mov    %edx,%esi
  800e0f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e11:	8b 1c 24             	mov    (%esp),%ebx
  800e14:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e18:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e1c:	89 ec                	mov    %ebp,%esp
  800e1e:	5d                   	pop    %ebp
  800e1f:	c3                   	ret    

00800e20 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 0c             	sub    $0xc,%esp
  800e26:	89 1c 24             	mov    %ebx,(%esp)
  800e29:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e2d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e31:	b8 00 00 00 00       	mov    $0x0,%eax
  800e36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e39:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3c:	89 c3                	mov    %eax,%ebx
  800e3e:	89 c7                	mov    %eax,%edi
  800e40:	89 c6                	mov    %eax,%esi
  800e42:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e44:	8b 1c 24             	mov    (%esp),%ebx
  800e47:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e4b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e4f:	89 ec                	mov    %ebp,%esp
  800e51:	5d                   	pop    %ebp
  800e52:	c3                   	ret    

00800e53 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  800e53:	55                   	push   %ebp
  800e54:	89 e5                	mov    %esp,%ebp
  800e56:	83 ec 0c             	sub    $0xc,%esp
  800e59:	89 1c 24             	mov    %ebx,(%esp)
  800e5c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e60:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e69:	b8 10 00 00 00       	mov    $0x10,%eax
  800e6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e71:	8b 55 08             	mov    0x8(%ebp),%edx
  800e74:	89 df                	mov    %ebx,%edi
  800e76:	89 de                	mov    %ebx,%esi
  800e78:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800e7a:	8b 1c 24             	mov    (%esp),%ebx
  800e7d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e81:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e85:	89 ec                	mov    %ebp,%esp
  800e87:	5d                   	pop    %ebp
  800e88:	c3                   	ret    

00800e89 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 38             	sub    $0x38,%esp
  800e8f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e92:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e95:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e98:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e9d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800ea2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea8:	89 df                	mov    %ebx,%edi
  800eaa:	89 de                	mov    %ebx,%esi
  800eac:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	7e 28                	jle    800eda <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800eb2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800eb6:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800ebd:	00 
  800ebe:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  800ec5:	00 
  800ec6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ecd:	00 
  800ece:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  800ed5:	e8 b2 f3 ff ff       	call   80028c <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800eda:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800edd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ee0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ee3:	89 ec                	mov    %ebp,%esp
  800ee5:	5d                   	pop    %ebp
  800ee6:	c3                   	ret    

00800ee7 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	83 ec 0c             	sub    $0xc,%esp
  800eed:	89 1c 24             	mov    %ebx,(%esp)
  800ef0:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ef4:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ef8:	ba 00 00 00 00       	mov    $0x0,%edx
  800efd:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f02:	89 d1                	mov    %edx,%ecx
  800f04:	89 d3                	mov    %edx,%ebx
  800f06:	89 d7                	mov    %edx,%edi
  800f08:	89 d6                	mov    %edx,%esi
  800f0a:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800f0c:	8b 1c 24             	mov    (%esp),%ebx
  800f0f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f13:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f17:	89 ec                	mov    %ebp,%esp
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 38             	sub    $0x38,%esp
  800f21:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f24:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f27:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f2a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f2f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f34:	8b 55 08             	mov    0x8(%ebp),%edx
  800f37:	89 cb                	mov    %ecx,%ebx
  800f39:	89 cf                	mov    %ecx,%edi
  800f3b:	89 ce                	mov    %ecx,%esi
  800f3d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f3f:	85 c0                	test   %eax,%eax
  800f41:	7e 28                	jle    800f6b <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f43:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f47:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800f4e:	00 
  800f4f:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  800f56:	00 
  800f57:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f5e:	00 
  800f5f:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  800f66:	e8 21 f3 ff ff       	call   80028c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f6b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f6e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f71:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f74:	89 ec                	mov    %ebp,%esp
  800f76:	5d                   	pop    %ebp
  800f77:	c3                   	ret    

00800f78 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f78:	55                   	push   %ebp
  800f79:	89 e5                	mov    %esp,%ebp
  800f7b:	83 ec 0c             	sub    $0xc,%esp
  800f7e:	89 1c 24             	mov    %ebx,(%esp)
  800f81:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f85:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f89:	be 00 00 00 00       	mov    $0x0,%esi
  800f8e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f93:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f96:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800fa1:	8b 1c 24             	mov    (%esp),%ebx
  800fa4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fa8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fac:	89 ec                	mov    %ebp,%esp
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 38             	sub    $0x38,%esp
  800fb6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fb9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fbc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fc9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcf:	89 df                	mov    %ebx,%edi
  800fd1:	89 de                	mov    %ebx,%esi
  800fd3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fd5:	85 c0                	test   %eax,%eax
  800fd7:	7e 28                	jle    801001 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fdd:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800fe4:	00 
  800fe5:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  800fec:	00 
  800fed:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff4:	00 
  800ff5:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  800ffc:	e8 8b f2 ff ff       	call   80028c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801001:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801004:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801007:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80100a:	89 ec                	mov    %ebp,%esp
  80100c:	5d                   	pop    %ebp
  80100d:	c3                   	ret    

0080100e <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80100e:	55                   	push   %ebp
  80100f:	89 e5                	mov    %esp,%ebp
  801011:	83 ec 38             	sub    $0x38,%esp
  801014:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801017:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80101a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801022:	b8 09 00 00 00       	mov    $0x9,%eax
  801027:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102a:	8b 55 08             	mov    0x8(%ebp),%edx
  80102d:	89 df                	mov    %ebx,%edi
  80102f:	89 de                	mov    %ebx,%esi
  801031:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801033:	85 c0                	test   %eax,%eax
  801035:	7e 28                	jle    80105f <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801037:	89 44 24 10          	mov    %eax,0x10(%esp)
  80103b:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801042:	00 
  801043:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  80104a:	00 
  80104b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801052:	00 
  801053:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  80105a:	e8 2d f2 ff ff       	call   80028c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80105f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801062:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801065:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801068:	89 ec                	mov    %ebp,%esp
  80106a:	5d                   	pop    %ebp
  80106b:	c3                   	ret    

0080106c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 38             	sub    $0x38,%esp
  801072:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801075:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801078:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80107b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801080:	b8 08 00 00 00       	mov    $0x8,%eax
  801085:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801088:	8b 55 08             	mov    0x8(%ebp),%edx
  80108b:	89 df                	mov    %ebx,%edi
  80108d:	89 de                	mov    %ebx,%esi
  80108f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801091:	85 c0                	test   %eax,%eax
  801093:	7e 28                	jle    8010bd <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801095:	89 44 24 10          	mov    %eax,0x10(%esp)
  801099:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8010a0:	00 
  8010a1:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  8010a8:	00 
  8010a9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010b0:	00 
  8010b1:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  8010b8:	e8 cf f1 ff ff       	call   80028c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010bd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010c0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010c3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010c6:	89 ec                	mov    %ebp,%esp
  8010c8:	5d                   	pop    %ebp
  8010c9:	c3                   	ret    

008010ca <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	83 ec 38             	sub    $0x38,%esp
  8010d0:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010d3:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010d6:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010de:	b8 06 00 00 00       	mov    $0x6,%eax
  8010e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e9:	89 df                	mov    %ebx,%edi
  8010eb:	89 de                	mov    %ebx,%esi
  8010ed:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010ef:	85 c0                	test   %eax,%eax
  8010f1:	7e 28                	jle    80111b <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010f7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8010fe:	00 
  8010ff:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  801106:	00 
  801107:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80110e:	00 
  80110f:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  801116:	e8 71 f1 ff ff       	call   80028c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80111b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80111e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801121:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801124:	89 ec                	mov    %ebp,%esp
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    

00801128 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	83 ec 38             	sub    $0x38,%esp
  80112e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801131:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801134:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801137:	b8 05 00 00 00       	mov    $0x5,%eax
  80113c:	8b 75 18             	mov    0x18(%ebp),%esi
  80113f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801142:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801145:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801148:	8b 55 08             	mov    0x8(%ebp),%edx
  80114b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80114d:	85 c0                	test   %eax,%eax
  80114f:	7e 28                	jle    801179 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801151:	89 44 24 10          	mov    %eax,0x10(%esp)
  801155:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80115c:	00 
  80115d:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  801164:	00 
  801165:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80116c:	00 
  80116d:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  801174:	e8 13 f1 ff ff       	call   80028c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801179:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80117c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80117f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801182:	89 ec                	mov    %ebp,%esp
  801184:	5d                   	pop    %ebp
  801185:	c3                   	ret    

00801186 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801186:	55                   	push   %ebp
  801187:	89 e5                	mov    %esp,%ebp
  801189:	83 ec 38             	sub    $0x38,%esp
  80118c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80118f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801192:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801195:	be 00 00 00 00       	mov    $0x0,%esi
  80119a:	b8 04 00 00 00       	mov    $0x4,%eax
  80119f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a8:	89 f7                	mov    %esi,%edi
  8011aa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	7e 28                	jle    8011d8 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011b4:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8011bb:	00 
  8011bc:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  8011c3:	00 
  8011c4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011cb:	00 
  8011cc:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  8011d3:	e8 b4 f0 ff ff       	call   80028c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011d8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011db:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011de:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011e1:	89 ec                	mov    %ebp,%esp
  8011e3:	5d                   	pop    %ebp
  8011e4:	c3                   	ret    

008011e5 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	83 ec 0c             	sub    $0xc,%esp
  8011eb:	89 1c 24             	mov    %ebx,(%esp)
  8011ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011f2:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8011fb:	b8 0b 00 00 00       	mov    $0xb,%eax
  801200:	89 d1                	mov    %edx,%ecx
  801202:	89 d3                	mov    %edx,%ebx
  801204:	89 d7                	mov    %edx,%edi
  801206:	89 d6                	mov    %edx,%esi
  801208:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80120a:	8b 1c 24             	mov    (%esp),%ebx
  80120d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801211:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801215:	89 ec                	mov    %ebp,%esp
  801217:	5d                   	pop    %ebp
  801218:	c3                   	ret    

00801219 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801219:	55                   	push   %ebp
  80121a:	89 e5                	mov    %esp,%ebp
  80121c:	83 ec 0c             	sub    $0xc,%esp
  80121f:	89 1c 24             	mov    %ebx,(%esp)
  801222:	89 74 24 04          	mov    %esi,0x4(%esp)
  801226:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80122a:	ba 00 00 00 00       	mov    $0x0,%edx
  80122f:	b8 02 00 00 00       	mov    $0x2,%eax
  801234:	89 d1                	mov    %edx,%ecx
  801236:	89 d3                	mov    %edx,%ebx
  801238:	89 d7                	mov    %edx,%edi
  80123a:	89 d6                	mov    %edx,%esi
  80123c:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80123e:	8b 1c 24             	mov    (%esp),%ebx
  801241:	8b 74 24 04          	mov    0x4(%esp),%esi
  801245:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801249:	89 ec                	mov    %ebp,%esp
  80124b:	5d                   	pop    %ebp
  80124c:	c3                   	ret    

0080124d <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  80124d:	55                   	push   %ebp
  80124e:	89 e5                	mov    %esp,%ebp
  801250:	83 ec 38             	sub    $0x38,%esp
  801253:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801256:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801259:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80125c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801261:	b8 03 00 00 00       	mov    $0x3,%eax
  801266:	8b 55 08             	mov    0x8(%ebp),%edx
  801269:	89 cb                	mov    %ecx,%ebx
  80126b:	89 cf                	mov    %ecx,%edi
  80126d:	89 ce                	mov    %ecx,%esi
  80126f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801271:	85 c0                	test   %eax,%eax
  801273:	7e 28                	jle    80129d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801275:	89 44 24 10          	mov    %eax,0x10(%esp)
  801279:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801280:	00 
  801281:	c7 44 24 08 1f 32 80 	movl   $0x80321f,0x8(%esp)
  801288:	00 
  801289:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801290:	00 
  801291:	c7 04 24 3c 32 80 00 	movl   $0x80323c,(%esp)
  801298:	e8 ef ef ff ff       	call   80028c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80129d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012a0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012a3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012a6:	89 ec                	mov    %ebp,%esp
  8012a8:	5d                   	pop    %ebp
  8012a9:	c3                   	ret    
	...

008012ac <sfork>:
}

// Challenge!
int
sfork(void)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8012b2:	c7 44 24 08 4a 32 80 	movl   $0x80324a,0x8(%esp)
  8012b9:	00 
  8012ba:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  8012c1:	00 
  8012c2:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  8012c9:	e8 be ef ff ff       	call   80028c <_panic>

008012ce <duppage>:
// It is also OK to panic on error.
// 

static int
duppage(envid_t envid, unsigned pn)
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 28             	sub    $0x28,%esp
  8012d4:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8012d7:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8012da:	89 c3                	mov    %eax,%ebx
	int r;

	// LAB 4: Your code here.
     pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  8012dc:	89 d6                	mov    %edx,%esi
  8012de:	c1 e6 0c             	shl    $0xc,%esi
  8012e1:	89 f0                	mov    %esi,%eax
  8012e3:	c1 e8 16             	shr    $0x16,%eax
  8012e6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
       
        if( 0 == pgDirEntry )
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	0f 84 fc 00 00 00    	je     8013f1 <duppage+0x123>
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  8012f5:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8012fc:	89 c2                	mov    %eax,%edx
  8012fe:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        //cprintf("Below %d",vpt[pn]);
                //if(perm!=0)  //commented nw.
                   // cprintf("perm bit %d",perm);
	
	
	if((perm & PTE_W) && (perm & PTE_SHARE))
  801304:	25 02 04 00 00       	and    $0x402,%eax
  801309:	3d 02 04 00 00       	cmp    $0x402,%eax
  80130e:	75 4d                	jne    80135d <duppage+0x8f>
	{	
		if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_SHARE|(perm & PTE_USER))) < 0)
  801310:	81 e2 07 0a 00 00    	and    $0xa07,%edx
  801316:	80 ce 04             	or     $0x4,%dh
  801319:	89 54 24 10          	mov    %edx,0x10(%esp)
  80131d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801321:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801325:	89 74 24 04          	mov    %esi,0x4(%esp)
  801329:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801330:	e8 f3 fd ff ff       	call   801128 <sys_page_map>
  801335:	85 c0                	test   %eax,%eax
  801337:	0f 89 bb 00 00 00    	jns    8013f8 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  80133d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801341:	c7 44 24 08 6b 32 80 	movl   $0x80326b,0x8(%esp)
  801348:	00 
  801349:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  801350:	00 
  801351:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  801358:	e8 2f ef ff ff       	call   80028c <_panic>
	}	


        else if((perm & PTE_W)!=0 || (perm & PTE_COW)!=0)
  80135d:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801363:	0f 84 8f 00 00 00    	je     8013f8 <duppage+0x12a>
         {
          //cprintf("\nInside Setting Cow\n"); 
        if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  801369:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801370:	00 
  801371:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801375:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801379:	89 74 24 04          	mov    %esi,0x4(%esp)
  80137d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801384:	e8 9f fd ff ff       	call   801128 <sys_page_map>
  801389:	85 c0                	test   %eax,%eax
  80138b:	79 20                	jns    8013ad <duppage+0xdf>
                panic("sys_page_map: %e", r);
  80138d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801391:	c7 44 24 08 6b 32 80 	movl   $0x80326b,0x8(%esp)
  801398:	00 
  801399:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8013a0:	00 
  8013a1:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  8013a8:	e8 df ee ff ff       	call   80028c <_panic>
        if ((r = sys_page_map(envid,(void *)(pn*PGSIZE),0,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  8013ad:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8013b4:	00 
  8013b5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013b9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8013c0:	00 
  8013c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013c5:	89 1c 24             	mov    %ebx,(%esp)
  8013c8:	e8 5b fd ff ff       	call   801128 <sys_page_map>
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	79 27                	jns    8013f8 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  8013d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013d5:	c7 44 24 08 6b 32 80 	movl   $0x80326b,0x8(%esp)
  8013dc:	00 
  8013dd:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8013e4:	00 
  8013e5:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  8013ec:	e8 9b ee ff ff       	call   80028c <_panic>
  8013f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8013f6:	eb 05                	jmp    8013fd <duppage+0x12f>
  8013f8:	b8 00 00 00 00       	mov    $0x0,%eax
         }


//	panic("duppage not implemented");
	return 0;
}
  8013fd:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801400:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801403:	89 ec                	mov    %ebp,%esp
  801405:	5d                   	pop    %ebp
  801406:	c3                   	ret    

00801407 <fork>:
//


envid_t
fork(void)
{
  801407:	55                   	push   %ebp
  801408:	89 e5                	mov    %esp,%ebp
  80140a:	56                   	push   %esi
  80140b:	53                   	push   %ebx
  80140c:	83 ec 10             	sub    $0x10,%esp

        envid_t envid;
        uint8_t *addr;
        int r;
        extern unsigned char end[];
        set_pgfault_handler(pgfault);
  80140f:	c7 04 24 1e 15 80 00 	movl   $0x80151e,(%esp)
  801416:	e8 d1 16 00 00       	call   802aec <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80141b:	be 07 00 00 00       	mov    $0x7,%esi
  801420:	89 f0                	mov    %esi,%eax
  801422:	cd 30                	int    $0x30
  801424:	89 c6                	mov    %eax,%esi

        envid = sys_exofork();
        if (envid < 0)
  801426:	85 c0                	test   %eax,%eax
  801428:	79 20                	jns    80144a <fork+0x43>
                panic("sys_exofork: %e", envid);
  80142a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80142e:	c7 44 24 08 7c 32 80 	movl   $0x80327c,0x8(%esp)
  801435:	00 
  801436:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  80143d:	00 
  80143e:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  801445:	e8 42 ee ff ff       	call   80028c <_panic>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
  80144a:	bb 00 00 80 00       	mov    $0x800000,%ebx
        set_pgfault_handler(pgfault);

        envid = sys_exofork();
        if (envid < 0)
                panic("sys_exofork: %e", envid);
        if (envid == 0) {
  80144f:	85 c0                	test   %eax,%eax
  801451:	75 1c                	jne    80146f <fork+0x68>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
  801453:	e8 c1 fd ff ff       	call   801219 <sys_getenvid>
  801458:	25 ff 03 00 00       	and    $0x3ff,%eax
  80145d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801460:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801465:	a3 74 70 80 00       	mov    %eax,0x807074
                return 0;
  80146a:	e9 a6 00 00 00       	jmp    801515 <fork+0x10e>
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
  80146f:	89 da                	mov    %ebx,%edx
  801471:	c1 ea 0c             	shr    $0xc,%edx
  801474:	89 f0                	mov    %esi,%eax
  801476:	e8 53 fe ff ff       	call   8012ce <duppage>
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
  80147b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801481:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801487:	75 e6                	jne    80146f <fork+0x68>
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
                }
              duppage(envid,VPN(USTACKTOP-PGSIZE));
  801489:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80148e:	89 f0                	mov    %esi,%eax
  801490:	e8 39 fe ff ff       	call   8012ce <duppage>
        // Also copy the stack we are currently running on.
       //if(sys_page_alloc(envid, (void *)(ROUNDDOWN(&addr, PGSIZE)),PTE_U|PTE_P|PTE_W)<0)
         //                      panic("stack not allocated");
     
   
     sys_env_set_pgfault_upcall(envid,env->env_pgfault_upcall);
  801495:	a1 74 70 80 00       	mov    0x807074,%eax
  80149a:	8b 40 64             	mov    0x64(%eax),%eax
  80149d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a1:	89 34 24             	mov    %esi,(%esp)
  8014a4:	e8 07 fb ff ff       	call   800fb0 <sys_env_set_pgfault_upcall>

     if(sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  8014a9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8014b0:	00 
  8014b1:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8014b8:	ee 
  8014b9:	89 34 24             	mov    %esi,(%esp)
  8014bc:	e8 c5 fc ff ff       	call   801186 <sys_page_alloc>
  8014c1:	85 c0                	test   %eax,%eax
  8014c3:	79 1c                	jns    8014e1 <fork+0xda>
                          panic("Cant allocate Page");
  8014c5:	c7 44 24 08 8c 32 80 	movl   $0x80328c,0x8(%esp)
  8014cc:	00 
  8014cd:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  8014d4:	00 
  8014d5:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  8014dc:	e8 ab ed ff ff       	call   80028c <_panic>

        // Start the child environment running
        if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8014e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8014e8:	00 
  8014e9:	89 34 24             	mov    %esi,(%esp)
  8014ec:	e8 7b fb ff ff       	call   80106c <sys_env_set_status>
  8014f1:	85 c0                	test   %eax,%eax
  8014f3:	79 20                	jns    801515 <fork+0x10e>
                panic("sys_env_set_status: %e", r);
  8014f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014f9:	c7 44 24 08 9f 32 80 	movl   $0x80329f,0x8(%esp)
  801500:	00 
  801501:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  801508:	00 
  801509:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  801510:	e8 77 ed ff ff       	call   80028c <_panic>
         return envid;
           
//panic("fork not implemented");
}
  801515:	89 f0                	mov    %esi,%eax
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	5b                   	pop    %ebx
  80151b:	5e                   	pop    %esi
  80151c:	5d                   	pop    %ebp
  80151d:	c3                   	ret    

0080151e <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	53                   	push   %ebx
  801522:	83 ec 24             	sub    $0x24,%esp
  801525:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801528:	8b 18                	mov    (%eax),%ebx
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).
 
         int perm = vpt[VPN(addr)] & 0xFFF;
  80152a:	89 da                	mov    %ebx,%edx
  80152c:	c1 ea 0c             	shr    $0xc,%edx
  80152f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx

static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
  801536:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80153a:	74 21                	je     80155d <pgfault+0x3f>
 
         int perm = vpt[VPN(addr)] & 0xFFF;
        if((err & FEC_WR)!=0)
           {
//              cprintf("\n>>>>>Due to write\n");
            if((perm & PTE_COW) == 0)
  80153c:	f6 c6 08             	test   $0x8,%dh
  80153f:	75 1c                	jne    80155d <pgfault+0x3f>
             {
                   panic("Not Set Cow");
  801541:	c7 44 24 08 b6 32 80 	movl   $0x8032b6,0x8(%esp)
  801548:	00 
  801549:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801550:	00 
  801551:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  801558:	e8 2f ed ff ff       	call   80028c <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
        if(sys_page_alloc(0,PFTEMP,PTE_P|PTE_U|PTE_W)<0)
  80155d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801564:	00 
  801565:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80156c:	00 
  80156d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801574:	e8 0d fc ff ff       	call   801186 <sys_page_alloc>
  801579:	85 c0                	test   %eax,%eax
  80157b:	79 1c                	jns    801599 <pgfault+0x7b>
              panic("\nPage not allocated\n");
  80157d:	c7 44 24 08 c2 32 80 	movl   $0x8032c2,0x8(%esp)
  801584:	00 
  801585:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  80158c:	00 
  80158d:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  801594:	e8 f3 ec ff ff       	call   80028c <_panic>
           memmove(PFTEMP,ROUNDDOWN(addr,PGSIZE),PGSIZE);
  801599:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80159f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8015a6:	00 
  8015a7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8015ab:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8015b2:	e8 2e f6 ff ff       	call   800be5 <memmove>
          if(sys_page_map(0,ROUNDDOWN(PFTEMP,PGSIZE),0,ROUNDDOWN(addr,PGSIZE),PTE_U|PTE_P|PTE_W)<0)
  8015b7:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8015be:	00 
  8015bf:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8015c3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015ca:	00 
  8015cb:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8015d2:	00 
  8015d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015da:	e8 49 fb ff ff       	call   801128 <sys_page_map>
  8015df:	85 c0                	test   %eax,%eax
  8015e1:	79 1c                	jns    8015ff <pgfault+0xe1>
                   panic("not mapped properly");
  8015e3:	c7 44 24 08 d7 32 80 	movl   $0x8032d7,0x8(%esp)
  8015ea:	00 
  8015eb:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8015f2:	00 
  8015f3:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  8015fa:	e8 8d ec ff ff       	call   80028c <_panic>
         if( 0 > sys_page_unmap(0, PFTEMP) )
  8015ff:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801606:	00 
  801607:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80160e:	e8 b7 fa ff ff       	call   8010ca <sys_page_unmap>
  801613:	85 c0                	test   %eax,%eax
  801615:	79 1c                	jns    801633 <pgfault+0x115>
                panic("sys_page_unmap failed\n");
  801617:	c7 44 24 08 eb 32 80 	movl   $0x8032eb,0x8(%esp)
  80161e:	00 
  80161f:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  801626:	00 
  801627:	c7 04 24 60 32 80 00 	movl   $0x803260,(%esp)
  80162e:	e8 59 ec ff ff       	call   80028c <_panic>
   
//	panic("pgfault not implemented");
}
  801633:	83 c4 24             	add    $0x24,%esp
  801636:	5b                   	pop    %ebx
  801637:	5d                   	pop    %ebp
  801638:	c3                   	ret    
  801639:	00 00                	add    %al,(%eax)
  80163b:	00 00                	add    %al,(%eax)
  80163d:	00 00                	add    %al,(%eax)
	...

00801640 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801640:	55                   	push   %ebp
  801641:	89 e5                	mov    %esp,%ebp
  801643:	57                   	push   %edi
  801644:	56                   	push   %esi
  801645:	53                   	push   %ebx
  801646:	83 ec 1c             	sub    $0x1c,%esp
  801649:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80164c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80164f:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  801652:	8b 45 14             	mov    0x14(%ebp),%eax
  801655:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801659:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80165d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801661:	89 1c 24             	mov    %ebx,(%esp)
  801664:	e8 0f f9 ff ff       	call   800f78 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  801669:	85 c0                	test   %eax,%eax
  80166b:	79 21                	jns    80168e <ipc_send+0x4e>
  80166d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801670:	74 1c                	je     80168e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  801672:	c7 44 24 08 02 33 80 	movl   $0x803302,0x8(%esp)
  801679:	00 
  80167a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  801681:	00 
  801682:	c7 04 24 14 33 80 00 	movl   $0x803314,(%esp)
  801689:	e8 fe eb ff ff       	call   80028c <_panic>
          else if(r==-E_IPC_NOT_RECV)
  80168e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801691:	75 07                	jne    80169a <ipc_send+0x5a>
           sys_yield();
  801693:	e8 4d fb ff ff       	call   8011e5 <sys_yield>
          else
            break;
        }
  801698:	eb b8                	jmp    801652 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  80169a:	83 c4 1c             	add    $0x1c,%esp
  80169d:	5b                   	pop    %ebx
  80169e:	5e                   	pop    %esi
  80169f:	5f                   	pop    %edi
  8016a0:	5d                   	pop    %ebp
  8016a1:	c3                   	ret    

008016a2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8016a2:	55                   	push   %ebp
  8016a3:	89 e5                	mov    %esp,%ebp
  8016a5:	83 ec 18             	sub    $0x18,%esp
  8016a8:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8016ab:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8016ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8016b1:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  8016b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b7:	89 04 24             	mov    %eax,(%esp)
  8016ba:	e8 5c f8 ff ff       	call   800f1b <sys_ipc_recv>
        if(r<0)
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	79 17                	jns    8016da <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  8016c3:	85 db                	test   %ebx,%ebx
  8016c5:	74 06                	je     8016cd <ipc_recv+0x2b>
               *from_env_store =0;
  8016c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  8016cd:	85 f6                	test   %esi,%esi
  8016cf:	90                   	nop
  8016d0:	74 2c                	je     8016fe <ipc_recv+0x5c>
              *perm_store=0;
  8016d2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8016d8:	eb 24                	jmp    8016fe <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  8016da:	85 db                	test   %ebx,%ebx
  8016dc:	74 0a                	je     8016e8 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  8016de:	a1 74 70 80 00       	mov    0x807074,%eax
  8016e3:	8b 40 74             	mov    0x74(%eax),%eax
  8016e6:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  8016e8:	85 f6                	test   %esi,%esi
  8016ea:	74 0a                	je     8016f6 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  8016ec:	a1 74 70 80 00       	mov    0x807074,%eax
  8016f1:	8b 40 78             	mov    0x78(%eax),%eax
  8016f4:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  8016f6:	a1 74 70 80 00       	mov    0x807074,%eax
  8016fb:	8b 40 70             	mov    0x70(%eax),%eax
}
  8016fe:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801701:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801704:	89 ec                	mov    %ebp,%esp
  801706:	5d                   	pop    %ebp
  801707:	c3                   	ret    
	...

00801710 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801710:	55                   	push   %ebp
  801711:	89 e5                	mov    %esp,%ebp
  801713:	8b 45 08             	mov    0x8(%ebp),%eax
  801716:	05 00 00 00 30       	add    $0x30000000,%eax
  80171b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80171e:	5d                   	pop    %ebp
  80171f:	c3                   	ret    

00801720 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	89 04 24             	mov    %eax,(%esp)
  80172c:	e8 df ff ff ff       	call   801710 <fd2num>
  801731:	05 20 00 0d 00       	add    $0xd0020,%eax
  801736:	c1 e0 0c             	shl    $0xc,%eax
}
  801739:	c9                   	leave  
  80173a:	c3                   	ret    

0080173b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	57                   	push   %edi
  80173f:	56                   	push   %esi
  801740:	53                   	push   %ebx
  801741:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801744:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801749:	a8 01                	test   $0x1,%al
  80174b:	74 36                	je     801783 <fd_alloc+0x48>
  80174d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801752:	a8 01                	test   $0x1,%al
  801754:	74 2d                	je     801783 <fd_alloc+0x48>
  801756:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80175b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801760:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801765:	89 c3                	mov    %eax,%ebx
  801767:	89 c2                	mov    %eax,%edx
  801769:	c1 ea 16             	shr    $0x16,%edx
  80176c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80176f:	f6 c2 01             	test   $0x1,%dl
  801772:	74 14                	je     801788 <fd_alloc+0x4d>
  801774:	89 c2                	mov    %eax,%edx
  801776:	c1 ea 0c             	shr    $0xc,%edx
  801779:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80177c:	f6 c2 01             	test   $0x1,%dl
  80177f:	75 10                	jne    801791 <fd_alloc+0x56>
  801781:	eb 05                	jmp    801788 <fd_alloc+0x4d>
  801783:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801788:	89 1f                	mov    %ebx,(%edi)
  80178a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80178f:	eb 17                	jmp    8017a8 <fd_alloc+0x6d>
  801791:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801796:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80179b:	75 c8                	jne    801765 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80179d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8017a3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8017a8:	5b                   	pop    %ebx
  8017a9:	5e                   	pop    %esi
  8017aa:	5f                   	pop    %edi
  8017ab:	5d                   	pop    %ebp
  8017ac:	c3                   	ret    

008017ad <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8017ad:	55                   	push   %ebp
  8017ae:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b3:	83 f8 1f             	cmp    $0x1f,%eax
  8017b6:	77 36                	ja     8017ee <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017b8:	05 00 00 0d 00       	add    $0xd0000,%eax
  8017bd:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8017c0:	89 c2                	mov    %eax,%edx
  8017c2:	c1 ea 16             	shr    $0x16,%edx
  8017c5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017cc:	f6 c2 01             	test   $0x1,%dl
  8017cf:	74 1d                	je     8017ee <fd_lookup+0x41>
  8017d1:	89 c2                	mov    %eax,%edx
  8017d3:	c1 ea 0c             	shr    $0xc,%edx
  8017d6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017dd:	f6 c2 01             	test   $0x1,%dl
  8017e0:	74 0c                	je     8017ee <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e5:	89 02                	mov    %eax,(%edx)
  8017e7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8017ec:	eb 05                	jmp    8017f3 <fd_lookup+0x46>
  8017ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017f3:	5d                   	pop    %ebp
  8017f4:	c3                   	ret    

008017f5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017fb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	89 04 24             	mov    %eax,(%esp)
  801808:	e8 a0 ff ff ff       	call   8017ad <fd_lookup>
  80180d:	85 c0                	test   %eax,%eax
  80180f:	78 0e                	js     80181f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801811:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801814:	8b 55 0c             	mov    0xc(%ebp),%edx
  801817:	89 50 04             	mov    %edx,0x4(%eax)
  80181a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80181f:	c9                   	leave  
  801820:	c3                   	ret    

00801821 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	56                   	push   %esi
  801825:	53                   	push   %ebx
  801826:	83 ec 10             	sub    $0x10,%esp
  801829:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80182c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80182f:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801834:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801839:	be a0 33 80 00       	mov    $0x8033a0,%esi
		if (devtab[i]->dev_id == dev_id) {
  80183e:	39 08                	cmp    %ecx,(%eax)
  801840:	75 10                	jne    801852 <dev_lookup+0x31>
  801842:	eb 04                	jmp    801848 <dev_lookup+0x27>
  801844:	39 08                	cmp    %ecx,(%eax)
  801846:	75 0a                	jne    801852 <dev_lookup+0x31>
			*dev = devtab[i];
  801848:	89 03                	mov    %eax,(%ebx)
  80184a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80184f:	90                   	nop
  801850:	eb 31                	jmp    801883 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801852:	83 c2 01             	add    $0x1,%edx
  801855:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801858:	85 c0                	test   %eax,%eax
  80185a:	75 e8                	jne    801844 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80185c:	a1 74 70 80 00       	mov    0x807074,%eax
  801861:	8b 40 4c             	mov    0x4c(%eax),%eax
  801864:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801868:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186c:	c7 04 24 20 33 80 00 	movl   $0x803320,(%esp)
  801873:	e8 d9 ea ff ff       	call   800351 <cprintf>
	*dev = 0;
  801878:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80187e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801883:	83 c4 10             	add    $0x10,%esp
  801886:	5b                   	pop    %ebx
  801887:	5e                   	pop    %esi
  801888:	5d                   	pop    %ebp
  801889:	c3                   	ret    

0080188a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80188a:	55                   	push   %ebp
  80188b:	89 e5                	mov    %esp,%ebp
  80188d:	53                   	push   %ebx
  80188e:	83 ec 24             	sub    $0x24,%esp
  801891:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801894:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801897:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	89 04 24             	mov    %eax,(%esp)
  8018a1:	e8 07 ff ff ff       	call   8017ad <fd_lookup>
  8018a6:	85 c0                	test   %eax,%eax
  8018a8:	78 53                	js     8018fd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b4:	8b 00                	mov    (%eax),%eax
  8018b6:	89 04 24             	mov    %eax,(%esp)
  8018b9:	e8 63 ff ff ff       	call   801821 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018be:	85 c0                	test   %eax,%eax
  8018c0:	78 3b                	js     8018fd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8018c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ca:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8018ce:	74 2d                	je     8018fd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018d0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018d3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018da:	00 00 00 
	stat->st_isdir = 0;
  8018dd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018e4:	00 00 00 
	stat->st_dev = dev;
  8018e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ea:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018f7:	89 14 24             	mov    %edx,(%esp)
  8018fa:	ff 50 14             	call   *0x14(%eax)
}
  8018fd:	83 c4 24             	add    $0x24,%esp
  801900:	5b                   	pop    %ebx
  801901:	5d                   	pop    %ebp
  801902:	c3                   	ret    

00801903 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801903:	55                   	push   %ebp
  801904:	89 e5                	mov    %esp,%ebp
  801906:	53                   	push   %ebx
  801907:	83 ec 24             	sub    $0x24,%esp
  80190a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80190d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801910:	89 44 24 04          	mov    %eax,0x4(%esp)
  801914:	89 1c 24             	mov    %ebx,(%esp)
  801917:	e8 91 fe ff ff       	call   8017ad <fd_lookup>
  80191c:	85 c0                	test   %eax,%eax
  80191e:	78 5f                	js     80197f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801920:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801923:	89 44 24 04          	mov    %eax,0x4(%esp)
  801927:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192a:	8b 00                	mov    (%eax),%eax
  80192c:	89 04 24             	mov    %eax,(%esp)
  80192f:	e8 ed fe ff ff       	call   801821 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801934:	85 c0                	test   %eax,%eax
  801936:	78 47                	js     80197f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801938:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80193b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80193f:	75 23                	jne    801964 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801941:	a1 74 70 80 00       	mov    0x807074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801946:	8b 40 4c             	mov    0x4c(%eax),%eax
  801949:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80194d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801951:	c7 04 24 40 33 80 00 	movl   $0x803340,(%esp)
  801958:	e8 f4 e9 ff ff       	call   800351 <cprintf>
  80195d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801962:	eb 1b                	jmp    80197f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801967:	8b 48 18             	mov    0x18(%eax),%ecx
  80196a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80196f:	85 c9                	test   %ecx,%ecx
  801971:	74 0c                	je     80197f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801973:	8b 45 0c             	mov    0xc(%ebp),%eax
  801976:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197a:	89 14 24             	mov    %edx,(%esp)
  80197d:	ff d1                	call   *%ecx
}
  80197f:	83 c4 24             	add    $0x24,%esp
  801982:	5b                   	pop    %ebx
  801983:	5d                   	pop    %ebp
  801984:	c3                   	ret    

00801985 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	53                   	push   %ebx
  801989:	83 ec 24             	sub    $0x24,%esp
  80198c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80198f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801992:	89 44 24 04          	mov    %eax,0x4(%esp)
  801996:	89 1c 24             	mov    %ebx,(%esp)
  801999:	e8 0f fe ff ff       	call   8017ad <fd_lookup>
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	78 66                	js     801a08 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019ac:	8b 00                	mov    (%eax),%eax
  8019ae:	89 04 24             	mov    %eax,(%esp)
  8019b1:	e8 6b fe ff ff       	call   801821 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	78 4e                	js     801a08 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019bd:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8019c1:	75 23                	jne    8019e6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8019c3:	a1 74 70 80 00       	mov    0x807074,%eax
  8019c8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8019cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d3:	c7 04 24 64 33 80 00 	movl   $0x803364,(%esp)
  8019da:	e8 72 e9 ff ff       	call   800351 <cprintf>
  8019df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8019e4:	eb 22                	jmp    801a08 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8019ec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019f1:	85 c9                	test   %ecx,%ecx
  8019f3:	74 13                	je     801a08 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a03:	89 14 24             	mov    %edx,(%esp)
  801a06:	ff d1                	call   *%ecx
}
  801a08:	83 c4 24             	add    $0x24,%esp
  801a0b:	5b                   	pop    %ebx
  801a0c:	5d                   	pop    %ebp
  801a0d:	c3                   	ret    

00801a0e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	53                   	push   %ebx
  801a12:	83 ec 24             	sub    $0x24,%esp
  801a15:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a18:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a1f:	89 1c 24             	mov    %ebx,(%esp)
  801a22:	e8 86 fd ff ff       	call   8017ad <fd_lookup>
  801a27:	85 c0                	test   %eax,%eax
  801a29:	78 6b                	js     801a96 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a2b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a35:	8b 00                	mov    (%eax),%eax
  801a37:	89 04 24             	mov    %eax,(%esp)
  801a3a:	e8 e2 fd ff ff       	call   801821 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a3f:	85 c0                	test   %eax,%eax
  801a41:	78 53                	js     801a96 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a43:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a46:	8b 42 08             	mov    0x8(%edx),%eax
  801a49:	83 e0 03             	and    $0x3,%eax
  801a4c:	83 f8 01             	cmp    $0x1,%eax
  801a4f:	75 23                	jne    801a74 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801a51:	a1 74 70 80 00       	mov    0x807074,%eax
  801a56:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a59:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a61:	c7 04 24 81 33 80 00 	movl   $0x803381,(%esp)
  801a68:	e8 e4 e8 ff ff       	call   800351 <cprintf>
  801a6d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801a72:	eb 22                	jmp    801a96 <read+0x88>
	}
	if (!dev->dev_read)
  801a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a77:	8b 48 08             	mov    0x8(%eax),%ecx
  801a7a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a7f:	85 c9                	test   %ecx,%ecx
  801a81:	74 13                	je     801a96 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a83:	8b 45 10             	mov    0x10(%ebp),%eax
  801a86:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a91:	89 14 24             	mov    %edx,(%esp)
  801a94:	ff d1                	call   *%ecx
}
  801a96:	83 c4 24             	add    $0x24,%esp
  801a99:	5b                   	pop    %ebx
  801a9a:	5d                   	pop    %ebp
  801a9b:	c3                   	ret    

00801a9c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a9c:	55                   	push   %ebp
  801a9d:	89 e5                	mov    %esp,%ebp
  801a9f:	57                   	push   %edi
  801aa0:	56                   	push   %esi
  801aa1:	53                   	push   %ebx
  801aa2:	83 ec 1c             	sub    $0x1c,%esp
  801aa5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801aa8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801aab:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ab5:	b8 00 00 00 00       	mov    $0x0,%eax
  801aba:	85 f6                	test   %esi,%esi
  801abc:	74 29                	je     801ae7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801abe:	89 f0                	mov    %esi,%eax
  801ac0:	29 d0                	sub    %edx,%eax
  801ac2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ac6:	03 55 0c             	add    0xc(%ebp),%edx
  801ac9:	89 54 24 04          	mov    %edx,0x4(%esp)
  801acd:	89 3c 24             	mov    %edi,(%esp)
  801ad0:	e8 39 ff ff ff       	call   801a0e <read>
		if (m < 0)
  801ad5:	85 c0                	test   %eax,%eax
  801ad7:	78 0e                	js     801ae7 <readn+0x4b>
			return m;
		if (m == 0)
  801ad9:	85 c0                	test   %eax,%eax
  801adb:	74 08                	je     801ae5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801add:	01 c3                	add    %eax,%ebx
  801adf:	89 da                	mov    %ebx,%edx
  801ae1:	39 f3                	cmp    %esi,%ebx
  801ae3:	72 d9                	jb     801abe <readn+0x22>
  801ae5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801ae7:	83 c4 1c             	add    $0x1c,%esp
  801aea:	5b                   	pop    %ebx
  801aeb:	5e                   	pop    %esi
  801aec:	5f                   	pop    %edi
  801aed:	5d                   	pop    %ebp
  801aee:	c3                   	ret    

00801aef <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801aef:	55                   	push   %ebp
  801af0:	89 e5                	mov    %esp,%ebp
  801af2:	56                   	push   %esi
  801af3:	53                   	push   %ebx
  801af4:	83 ec 20             	sub    $0x20,%esp
  801af7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801afa:	89 34 24             	mov    %esi,(%esp)
  801afd:	e8 0e fc ff ff       	call   801710 <fd2num>
  801b02:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b05:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b09:	89 04 24             	mov    %eax,(%esp)
  801b0c:	e8 9c fc ff ff       	call   8017ad <fd_lookup>
  801b11:	89 c3                	mov    %eax,%ebx
  801b13:	85 c0                	test   %eax,%eax
  801b15:	78 05                	js     801b1c <fd_close+0x2d>
  801b17:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801b1a:	74 0c                	je     801b28 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801b1c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801b20:	19 c0                	sbb    %eax,%eax
  801b22:	f7 d0                	not    %eax
  801b24:	21 c3                	and    %eax,%ebx
  801b26:	eb 3d                	jmp    801b65 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b28:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2f:	8b 06                	mov    (%esi),%eax
  801b31:	89 04 24             	mov    %eax,(%esp)
  801b34:	e8 e8 fc ff ff       	call   801821 <dev_lookup>
  801b39:	89 c3                	mov    %eax,%ebx
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	78 16                	js     801b55 <fd_close+0x66>
		if (dev->dev_close)
  801b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b42:	8b 40 10             	mov    0x10(%eax),%eax
  801b45:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b4a:	85 c0                	test   %eax,%eax
  801b4c:	74 07                	je     801b55 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801b4e:	89 34 24             	mov    %esi,(%esp)
  801b51:	ff d0                	call   *%eax
  801b53:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801b55:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b59:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b60:	e8 65 f5 ff ff       	call   8010ca <sys_page_unmap>
	return r;
}
  801b65:	89 d8                	mov    %ebx,%eax
  801b67:	83 c4 20             	add    $0x20,%esp
  801b6a:	5b                   	pop    %ebx
  801b6b:	5e                   	pop    %esi
  801b6c:	5d                   	pop    %ebp
  801b6d:	c3                   	ret    

00801b6e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
  801b71:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b74:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b77:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	89 04 24             	mov    %eax,(%esp)
  801b81:	e8 27 fc ff ff       	call   8017ad <fd_lookup>
  801b86:	85 c0                	test   %eax,%eax
  801b88:	78 13                	js     801b9d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801b8a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801b91:	00 
  801b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b95:	89 04 24             	mov    %eax,(%esp)
  801b98:	e8 52 ff ff ff       	call   801aef <fd_close>
}
  801b9d:	c9                   	leave  
  801b9e:	c3                   	ret    

00801b9f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801b9f:	55                   	push   %ebp
  801ba0:	89 e5                	mov    %esp,%ebp
  801ba2:	83 ec 18             	sub    $0x18,%esp
  801ba5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801ba8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bb2:	00 
  801bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb6:	89 04 24             	mov    %eax,(%esp)
  801bb9:	e8 a9 03 00 00       	call   801f67 <open>
  801bbe:	89 c3                	mov    %eax,%ebx
  801bc0:	85 c0                	test   %eax,%eax
  801bc2:	78 1b                	js     801bdf <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bcb:	89 1c 24             	mov    %ebx,(%esp)
  801bce:	e8 b7 fc ff ff       	call   80188a <fstat>
  801bd3:	89 c6                	mov    %eax,%esi
	close(fd);
  801bd5:	89 1c 24             	mov    %ebx,(%esp)
  801bd8:	e8 91 ff ff ff       	call   801b6e <close>
  801bdd:	89 f3                	mov    %esi,%ebx
	return r;
}
  801bdf:	89 d8                	mov    %ebx,%eax
  801be1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801be4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801be7:	89 ec                	mov    %ebp,%esp
  801be9:	5d                   	pop    %ebp
  801bea:	c3                   	ret    

00801beb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	53                   	push   %ebx
  801bef:	83 ec 14             	sub    $0x14,%esp
  801bf2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801bf7:	89 1c 24             	mov    %ebx,(%esp)
  801bfa:	e8 6f ff ff ff       	call   801b6e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801bff:	83 c3 01             	add    $0x1,%ebx
  801c02:	83 fb 20             	cmp    $0x20,%ebx
  801c05:	75 f0                	jne    801bf7 <close_all+0xc>
		close(i);
}
  801c07:	83 c4 14             	add    $0x14,%esp
  801c0a:	5b                   	pop    %ebx
  801c0b:	5d                   	pop    %ebp
  801c0c:	c3                   	ret    

00801c0d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	83 ec 58             	sub    $0x58,%esp
  801c13:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801c16:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801c19:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801c1c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801c1f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801c22:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c26:	8b 45 08             	mov    0x8(%ebp),%eax
  801c29:	89 04 24             	mov    %eax,(%esp)
  801c2c:	e8 7c fb ff ff       	call   8017ad <fd_lookup>
  801c31:	89 c3                	mov    %eax,%ebx
  801c33:	85 c0                	test   %eax,%eax
  801c35:	0f 88 e0 00 00 00    	js     801d1b <dup+0x10e>
		return r;
	close(newfdnum);
  801c3b:	89 3c 24             	mov    %edi,(%esp)
  801c3e:	e8 2b ff ff ff       	call   801b6e <close>

	newfd = INDEX2FD(newfdnum);
  801c43:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801c49:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801c4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c4f:	89 04 24             	mov    %eax,(%esp)
  801c52:	e8 c9 fa ff ff       	call   801720 <fd2data>
  801c57:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801c59:	89 34 24             	mov    %esi,(%esp)
  801c5c:	e8 bf fa ff ff       	call   801720 <fd2data>
  801c61:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801c64:	89 da                	mov    %ebx,%edx
  801c66:	89 d8                	mov    %ebx,%eax
  801c68:	c1 e8 16             	shr    $0x16,%eax
  801c6b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c72:	a8 01                	test   $0x1,%al
  801c74:	74 43                	je     801cb9 <dup+0xac>
  801c76:	c1 ea 0c             	shr    $0xc,%edx
  801c79:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c80:	a8 01                	test   $0x1,%al
  801c82:	74 35                	je     801cb9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801c84:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c8b:	25 07 0e 00 00       	and    $0xe07,%eax
  801c90:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c94:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c97:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c9b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ca2:	00 
  801ca3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ca7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cae:	e8 75 f4 ff ff       	call   801128 <sys_page_map>
  801cb3:	89 c3                	mov    %eax,%ebx
  801cb5:	85 c0                	test   %eax,%eax
  801cb7:	78 3f                	js     801cf8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801cb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cbc:	89 c2                	mov    %eax,%edx
  801cbe:	c1 ea 0c             	shr    $0xc,%edx
  801cc1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801cc8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801cce:	89 54 24 10          	mov    %edx,0x10(%esp)
  801cd2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801cd6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cdd:	00 
  801cde:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ce9:	e8 3a f4 ff ff       	call   801128 <sys_page_map>
  801cee:	89 c3                	mov    %eax,%ebx
  801cf0:	85 c0                	test   %eax,%eax
  801cf2:	78 04                	js     801cf8 <dup+0xeb>
  801cf4:	89 fb                	mov    %edi,%ebx
  801cf6:	eb 23                	jmp    801d1b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801cf8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cfc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d03:	e8 c2 f3 ff ff       	call   8010ca <sys_page_unmap>
	sys_page_unmap(0, nva);
  801d08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d16:	e8 af f3 ff ff       	call   8010ca <sys_page_unmap>
	return r;
}
  801d1b:	89 d8                	mov    %ebx,%eax
  801d1d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801d20:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801d23:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801d26:	89 ec                	mov    %ebp,%esp
  801d28:	5d                   	pop    %ebp
  801d29:	c3                   	ret    
	...

00801d2c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	53                   	push   %ebx
  801d30:	83 ec 14             	sub    $0x14,%esp
  801d33:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d35:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801d3b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d42:	00 
  801d43:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801d4a:	00 
  801d4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d4f:	89 14 24             	mov    %edx,(%esp)
  801d52:	e8 e9 f8 ff ff       	call   801640 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d57:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d5e:	00 
  801d5f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d63:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d6a:	e8 33 f9 ff ff       	call   8016a2 <ipc_recv>
}
  801d6f:	83 c4 14             	add    $0x14,%esp
  801d72:	5b                   	pop    %ebx
  801d73:	5d                   	pop    %ebp
  801d74:	c3                   	ret    

00801d75 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d81:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801d86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d89:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d8e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d93:	b8 02 00 00 00       	mov    $0x2,%eax
  801d98:	e8 8f ff ff ff       	call   801d2c <fsipc>
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801da5:	ba 00 00 00 00       	mov    $0x0,%edx
  801daa:	b8 08 00 00 00       	mov    $0x8,%eax
  801daf:	e8 78 ff ff ff       	call   801d2c <fsipc>
}
  801db4:	c9                   	leave  
  801db5:	c3                   	ret    

00801db6 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801db6:	55                   	push   %ebp
  801db7:	89 e5                	mov    %esp,%ebp
  801db9:	53                   	push   %ebx
  801dba:	83 ec 14             	sub    $0x14,%esp
  801dbd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc3:	8b 40 0c             	mov    0xc(%eax),%eax
  801dc6:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801dcb:	ba 00 00 00 00       	mov    $0x0,%edx
  801dd0:	b8 05 00 00 00       	mov    $0x5,%eax
  801dd5:	e8 52 ff ff ff       	call   801d2c <fsipc>
  801dda:	85 c0                	test   %eax,%eax
  801ddc:	78 2b                	js     801e09 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801dde:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801de5:	00 
  801de6:	89 1c 24             	mov    %ebx,(%esp)
  801de9:	e8 3c ec ff ff       	call   800a2a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801dee:	a1 80 40 80 00       	mov    0x804080,%eax
  801df3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801df9:	a1 84 40 80 00       	mov    0x804084,%eax
  801dfe:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801e04:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801e09:	83 c4 14             	add    $0x14,%esp
  801e0c:	5b                   	pop    %ebx
  801e0d:	5d                   	pop    %ebp
  801e0e:	c3                   	ret    

00801e0f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
  801e12:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  801e15:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801e1c:	00 
  801e1d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e24:	00 
  801e25:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e2c:	e8 55 ed ff ff       	call   800b86 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	8b 40 0c             	mov    0xc(%eax),%eax
  801e37:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801e3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e41:	b8 06 00 00 00       	mov    $0x6,%eax
  801e46:	e8 e1 fe ff ff       	call   801d2c <fsipc>
}
  801e4b:	c9                   	leave  
  801e4c:	c3                   	ret    

00801e4d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e4d:	55                   	push   %ebp
  801e4e:	89 e5                	mov    %esp,%ebp
  801e50:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801e53:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801e5a:	00 
  801e5b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e62:	00 
  801e63:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e6a:	e8 17 ed ff ff       	call   800b86 <memset>
  801e6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e72:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801e77:	76 05                	jbe    801e7e <devfile_write+0x31>
  801e79:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e7e:	8b 55 08             	mov    0x8(%ebp),%edx
  801e81:	8b 52 0c             	mov    0xc(%edx),%edx
  801e84:	89 15 00 40 80 00    	mov    %edx,0x804000
        fsipcbuf.write.req_n = numberOfBytes;
  801e8a:	a3 04 40 80 00       	mov    %eax,0x804004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  801e8f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e93:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e96:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e9a:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801ea1:	e8 3f ed ff ff       	call   800be5 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  801ea6:	ba 00 00 00 00       	mov    $0x0,%edx
  801eab:	b8 04 00 00 00       	mov    $0x4,%eax
  801eb0:	e8 77 fe ff ff       	call   801d2c <fsipc>
              return r;
        return r;
}
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
  801eba:	53                   	push   %ebx
  801ebb:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  801ebe:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801ec5:	00 
  801ec6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ecd:	00 
  801ece:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801ed5:	e8 ac ec ff ff       	call   800b86 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  801eda:	8b 45 08             	mov    0x8(%ebp),%eax
  801edd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee0:	a3 00 40 80 00       	mov    %eax,0x804000
        fsipcbuf.read.req_n = n;
  801ee5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ee8:	a3 04 40 80 00       	mov    %eax,0x804004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  801eed:	ba 00 00 00 00       	mov    $0x0,%edx
  801ef2:	b8 03 00 00 00       	mov    $0x3,%eax
  801ef7:	e8 30 fe ff ff       	call   801d2c <fsipc>
  801efc:	89 c3                	mov    %eax,%ebx
  801efe:	85 c0                	test   %eax,%eax
  801f00:	78 17                	js     801f19 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  801f02:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f06:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801f0d:	00 
  801f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f11:	89 04 24             	mov    %eax,(%esp)
  801f14:	e8 cc ec ff ff       	call   800be5 <memmove>
        return r;
}
  801f19:	89 d8                	mov    %ebx,%eax
  801f1b:	83 c4 14             	add    $0x14,%esp
  801f1e:	5b                   	pop    %ebx
  801f1f:	5d                   	pop    %ebp
  801f20:	c3                   	ret    

00801f21 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	53                   	push   %ebx
  801f25:	83 ec 14             	sub    $0x14,%esp
  801f28:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801f2b:	89 1c 24             	mov    %ebx,(%esp)
  801f2e:	e8 ad ea ff ff       	call   8009e0 <strlen>
  801f33:	89 c2                	mov    %eax,%edx
  801f35:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801f3a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801f40:	7f 1f                	jg     801f61 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801f42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f46:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801f4d:	e8 d8 ea ff ff       	call   800a2a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801f52:	ba 00 00 00 00       	mov    $0x0,%edx
  801f57:	b8 07 00 00 00       	mov    $0x7,%eax
  801f5c:	e8 cb fd ff ff       	call   801d2c <fsipc>
}
  801f61:	83 c4 14             	add    $0x14,%esp
  801f64:	5b                   	pop    %ebx
  801f65:	5d                   	pop    %ebp
  801f66:	c3                   	ret    

00801f67 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  801f67:	55                   	push   %ebp
  801f68:	89 e5                	mov    %esp,%ebp
  801f6a:	56                   	push   %esi
  801f6b:	53                   	push   %ebx
  801f6c:	83 ec 20             	sub    $0x20,%esp
  801f6f:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  801f72:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801f79:	00 
  801f7a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f81:	00 
  801f82:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801f89:	e8 f8 eb ff ff       	call   800b86 <memset>
    if(strlen(path)>=MAXPATHLEN)
  801f8e:	89 34 24             	mov    %esi,(%esp)
  801f91:	e8 4a ea ff ff       	call   8009e0 <strlen>
  801f96:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f9b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801fa0:	0f 8f 84 00 00 00    	jg     80202a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  801fa6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fa9:	89 04 24             	mov    %eax,(%esp)
  801fac:	e8 8a f7 ff ff       	call   80173b <fd_alloc>
  801fb1:	89 c3                	mov    %eax,%ebx
  801fb3:	85 c0                	test   %eax,%eax
  801fb5:	78 73                	js     80202a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  801fb7:	0f b6 06             	movzbl (%esi),%eax
  801fba:	84 c0                	test   %al,%al
  801fbc:	74 20                	je     801fde <open+0x77>
  801fbe:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  801fc0:	0f be c0             	movsbl %al,%eax
  801fc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc7:	c7 04 24 b4 33 80 00 	movl   $0x8033b4,(%esp)
  801fce:	e8 7e e3 ff ff       	call   800351 <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  801fd3:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  801fd7:	83 c3 01             	add    $0x1,%ebx
  801fda:	84 c0                	test   %al,%al
  801fdc:	75 e2                	jne    801fc0 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  801fde:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fe2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801fe9:	e8 3c ea ff ff       	call   800a2a <strcpy>
    fsipcbuf.open.req_omode = mode;
  801fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff1:	a3 00 44 80 00       	mov    %eax,0x804400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  801ff6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ff9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ffe:	e8 29 fd ff ff       	call   801d2c <fsipc>
  802003:	89 c3                	mov    %eax,%ebx
  802005:	85 c0                	test   %eax,%eax
  802007:	79 15                	jns    80201e <open+0xb7>
        {
            fd_close(fd,1);
  802009:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802010:	00 
  802011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802014:	89 04 24             	mov    %eax,(%esp)
  802017:	e8 d3 fa ff ff       	call   801aef <fd_close>
             return r;
  80201c:	eb 0c                	jmp    80202a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  80201e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802021:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  802027:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  80202a:	89 d8                	mov    %ebx,%eax
  80202c:	83 c4 20             	add    $0x20,%esp
  80202f:	5b                   	pop    %ebx
  802030:	5e                   	pop    %esi
  802031:	5d                   	pop    %ebp
  802032:	c3                   	ret    
	...

00802034 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802037:	8b 45 08             	mov    0x8(%ebp),%eax
  80203a:	89 c2                	mov    %eax,%edx
  80203c:	c1 ea 16             	shr    $0x16,%edx
  80203f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802046:	f6 c2 01             	test   $0x1,%dl
  802049:	74 26                	je     802071 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  80204b:	c1 e8 0c             	shr    $0xc,%eax
  80204e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802055:	a8 01                	test   $0x1,%al
  802057:	74 18                	je     802071 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802059:	c1 e8 0c             	shr    $0xc,%eax
  80205c:	8d 14 40             	lea    (%eax,%eax,2),%edx
  80205f:	c1 e2 02             	shl    $0x2,%edx
  802062:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802067:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  80206c:	0f b7 c0             	movzwl %ax,%eax
  80206f:	eb 05                	jmp    802076 <pageref+0x42>
  802071:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802076:	5d                   	pop    %ebp
  802077:	c3                   	ret    
	...

00802080 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802080:	55                   	push   %ebp
  802081:	89 e5                	mov    %esp,%ebp
  802083:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802086:	c7 44 24 04 b7 33 80 	movl   $0x8033b7,0x4(%esp)
  80208d:	00 
  80208e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802091:	89 04 24             	mov    %eax,(%esp)
  802094:	e8 91 e9 ff ff       	call   800a2a <strcpy>
	return 0;
}
  802099:	b8 00 00 00 00       	mov    $0x0,%eax
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
  8020a3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  8020a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ac:	89 04 24             	mov    %eax,(%esp)
  8020af:	e8 9e 02 00 00       	call   802352 <nsipc_close>
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020bc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020c3:	00 
  8020c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d8:	89 04 24             	mov    %eax,(%esp)
  8020db:	e8 ae 02 00 00       	call   80238e <nsipc_send>
}
  8020e0:	c9                   	leave  
  8020e1:	c3                   	ret    

008020e2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8020e2:	55                   	push   %ebp
  8020e3:	89 e5                	mov    %esp,%ebp
  8020e5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020ef:	00 
  8020f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8020f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802101:	8b 40 0c             	mov    0xc(%eax),%eax
  802104:	89 04 24             	mov    %eax,(%esp)
  802107:	e8 f5 02 00 00       	call   802401 <nsipc_recv>
}
  80210c:	c9                   	leave  
  80210d:	c3                   	ret    

0080210e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  80210e:	55                   	push   %ebp
  80210f:	89 e5                	mov    %esp,%ebp
  802111:	56                   	push   %esi
  802112:	53                   	push   %ebx
  802113:	83 ec 20             	sub    $0x20,%esp
  802116:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802118:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80211b:	89 04 24             	mov    %eax,(%esp)
  80211e:	e8 18 f6 ff ff       	call   80173b <fd_alloc>
  802123:	89 c3                	mov    %eax,%ebx
  802125:	85 c0                	test   %eax,%eax
  802127:	78 21                	js     80214a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  802129:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802130:	00 
  802131:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802134:	89 44 24 04          	mov    %eax,0x4(%esp)
  802138:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80213f:	e8 42 f0 ff ff       	call   801186 <sys_page_alloc>
  802144:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802146:	85 c0                	test   %eax,%eax
  802148:	79 0a                	jns    802154 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80214a:	89 34 24             	mov    %esi,(%esp)
  80214d:	e8 00 02 00 00       	call   802352 <nsipc_close>
		return r;
  802152:	eb 28                	jmp    80217c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802154:	8b 15 20 70 80 00    	mov    0x807020,%edx
  80215a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80215f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802162:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802169:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80216c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80216f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802172:	89 04 24             	mov    %eax,(%esp)
  802175:	e8 96 f5 ff ff       	call   801710 <fd2num>
  80217a:	89 c3                	mov    %eax,%ebx
}
  80217c:	89 d8                	mov    %ebx,%eax
  80217e:	83 c4 20             	add    $0x20,%esp
  802181:	5b                   	pop    %ebx
  802182:	5e                   	pop    %esi
  802183:	5d                   	pop    %ebp
  802184:	c3                   	ret    

00802185 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80218b:	8b 45 10             	mov    0x10(%ebp),%eax
  80218e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802192:	8b 45 0c             	mov    0xc(%ebp),%eax
  802195:	89 44 24 04          	mov    %eax,0x4(%esp)
  802199:	8b 45 08             	mov    0x8(%ebp),%eax
  80219c:	89 04 24             	mov    %eax,(%esp)
  80219f:	e8 62 01 00 00       	call   802306 <nsipc_socket>
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	78 05                	js     8021ad <socket+0x28>
		return r;
	return alloc_sockfd(r);
  8021a8:	e8 61 ff ff ff       	call   80210e <alloc_sockfd>
}
  8021ad:	c9                   	leave  
  8021ae:	66 90                	xchg   %ax,%ax
  8021b0:	c3                   	ret    

008021b1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8021b1:	55                   	push   %ebp
  8021b2:	89 e5                	mov    %esp,%ebp
  8021b4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8021b7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8021ba:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021be:	89 04 24             	mov    %eax,(%esp)
  8021c1:	e8 e7 f5 ff ff       	call   8017ad <fd_lookup>
  8021c6:	85 c0                	test   %eax,%eax
  8021c8:	78 15                	js     8021df <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8021ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021cd:	8b 0a                	mov    (%edx),%ecx
  8021cf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021d4:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  8021da:	75 03                	jne    8021df <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8021dc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8021df:	c9                   	leave  
  8021e0:	c3                   	ret    

008021e1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8021e1:	55                   	push   %ebp
  8021e2:	89 e5                	mov    %esp,%ebp
  8021e4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	e8 c2 ff ff ff       	call   8021b1 <fd2sockid>
  8021ef:	85 c0                	test   %eax,%eax
  8021f1:	78 0f                	js     802202 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8021f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021f6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021fa:	89 04 24             	mov    %eax,(%esp)
  8021fd:	e8 2e 01 00 00       	call   802330 <nsipc_listen>
}
  802202:	c9                   	leave  
  802203:	c3                   	ret    

00802204 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802204:	55                   	push   %ebp
  802205:	89 e5                	mov    %esp,%ebp
  802207:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	e8 9f ff ff ff       	call   8021b1 <fd2sockid>
  802212:	85 c0                	test   %eax,%eax
  802214:	78 16                	js     80222c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802216:	8b 55 10             	mov    0x10(%ebp),%edx
  802219:	89 54 24 08          	mov    %edx,0x8(%esp)
  80221d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802220:	89 54 24 04          	mov    %edx,0x4(%esp)
  802224:	89 04 24             	mov    %eax,(%esp)
  802227:	e8 55 02 00 00       	call   802481 <nsipc_connect>
}
  80222c:	c9                   	leave  
  80222d:	c3                   	ret    

0080222e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80222e:	55                   	push   %ebp
  80222f:	89 e5                	mov    %esp,%ebp
  802231:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	e8 75 ff ff ff       	call   8021b1 <fd2sockid>
  80223c:	85 c0                	test   %eax,%eax
  80223e:	78 0f                	js     80224f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802240:	8b 55 0c             	mov    0xc(%ebp),%edx
  802243:	89 54 24 04          	mov    %edx,0x4(%esp)
  802247:	89 04 24             	mov    %eax,(%esp)
  80224a:	e8 1d 01 00 00       	call   80236c <nsipc_shutdown>
}
  80224f:	c9                   	leave  
  802250:	c3                   	ret    

00802251 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
  802254:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802257:	8b 45 08             	mov    0x8(%ebp),%eax
  80225a:	e8 52 ff ff ff       	call   8021b1 <fd2sockid>
  80225f:	85 c0                	test   %eax,%eax
  802261:	78 16                	js     802279 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802263:	8b 55 10             	mov    0x10(%ebp),%edx
  802266:	89 54 24 08          	mov    %edx,0x8(%esp)
  80226a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80226d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802271:	89 04 24             	mov    %eax,(%esp)
  802274:	e8 47 02 00 00       	call   8024c0 <nsipc_bind>
}
  802279:	c9                   	leave  
  80227a:	c3                   	ret    

0080227b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80227b:	55                   	push   %ebp
  80227c:	89 e5                	mov    %esp,%ebp
  80227e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802281:	8b 45 08             	mov    0x8(%ebp),%eax
  802284:	e8 28 ff ff ff       	call   8021b1 <fd2sockid>
  802289:	85 c0                	test   %eax,%eax
  80228b:	78 1f                	js     8022ac <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80228d:	8b 55 10             	mov    0x10(%ebp),%edx
  802290:	89 54 24 08          	mov    %edx,0x8(%esp)
  802294:	8b 55 0c             	mov    0xc(%ebp),%edx
  802297:	89 54 24 04          	mov    %edx,0x4(%esp)
  80229b:	89 04 24             	mov    %eax,(%esp)
  80229e:	e8 5c 02 00 00       	call   8024ff <nsipc_accept>
  8022a3:	85 c0                	test   %eax,%eax
  8022a5:	78 05                	js     8022ac <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8022a7:	e8 62 fe ff ff       	call   80210e <alloc_sockfd>
}
  8022ac:	c9                   	leave  
  8022ad:	8d 76 00             	lea    0x0(%esi),%esi
  8022b0:	c3                   	ret    
	...

008022c0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022c6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8022cc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8022d3:	00 
  8022d4:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8022db:	00 
  8022dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022e0:	89 14 24             	mov    %edx,(%esp)
  8022e3:	e8 58 f3 ff ff       	call   801640 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8022e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022ef:	00 
  8022f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8022f7:	00 
  8022f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022ff:	e8 9e f3 ff ff       	call   8016a2 <ipc_recv>
}
  802304:	c9                   	leave  
  802305:	c3                   	ret    

00802306 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  802306:	55                   	push   %ebp
  802307:	89 e5                	mov    %esp,%ebp
  802309:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80230c:	8b 45 08             	mov    0x8(%ebp),%eax
  80230f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802314:	8b 45 0c             	mov    0xc(%ebp),%eax
  802317:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80231c:	8b 45 10             	mov    0x10(%ebp),%eax
  80231f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802324:	b8 09 00 00 00       	mov    $0x9,%eax
  802329:	e8 92 ff ff ff       	call   8022c0 <nsipc>
}
  80232e:	c9                   	leave  
  80232f:	c3                   	ret    

00802330 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802330:	55                   	push   %ebp
  802331:	89 e5                	mov    %esp,%ebp
  802333:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802336:	8b 45 08             	mov    0x8(%ebp),%eax
  802339:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80233e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802341:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802346:	b8 06 00 00 00       	mov    $0x6,%eax
  80234b:	e8 70 ff ff ff       	call   8022c0 <nsipc>
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
  802355:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802358:	8b 45 08             	mov    0x8(%ebp),%eax
  80235b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802360:	b8 04 00 00 00       	mov    $0x4,%eax
  802365:	e8 56 ff ff ff       	call   8022c0 <nsipc>
}
  80236a:	c9                   	leave  
  80236b:	c3                   	ret    

0080236c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
  80236f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802372:	8b 45 08             	mov    0x8(%ebp),%eax
  802375:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80237a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80237d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802382:	b8 03 00 00 00       	mov    $0x3,%eax
  802387:	e8 34 ff ff ff       	call   8022c0 <nsipc>
}
  80238c:	c9                   	leave  
  80238d:	c3                   	ret    

0080238e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80238e:	55                   	push   %ebp
  80238f:	89 e5                	mov    %esp,%ebp
  802391:	53                   	push   %ebx
  802392:	83 ec 14             	sub    $0x14,%esp
  802395:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802398:	8b 45 08             	mov    0x8(%ebp),%eax
  80239b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8023a0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8023a6:	7e 24                	jle    8023cc <nsipc_send+0x3e>
  8023a8:	c7 44 24 0c c3 33 80 	movl   $0x8033c3,0xc(%esp)
  8023af:	00 
  8023b0:	c7 44 24 08 cf 33 80 	movl   $0x8033cf,0x8(%esp)
  8023b7:	00 
  8023b8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8023bf:	00 
  8023c0:	c7 04 24 e4 33 80 00 	movl   $0x8033e4,(%esp)
  8023c7:	e8 c0 de ff ff       	call   80028c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023cc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d7:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8023de:	e8 02 e8 ff ff       	call   800be5 <memmove>
	nsipcbuf.send.req_size = size;
  8023e3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8023e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8023ec:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8023f1:	b8 08 00 00 00       	mov    $0x8,%eax
  8023f6:	e8 c5 fe ff ff       	call   8022c0 <nsipc>
}
  8023fb:	83 c4 14             	add    $0x14,%esp
  8023fe:	5b                   	pop    %ebx
  8023ff:	5d                   	pop    %ebp
  802400:	c3                   	ret    

00802401 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802401:	55                   	push   %ebp
  802402:	89 e5                	mov    %esp,%ebp
  802404:	56                   	push   %esi
  802405:	53                   	push   %ebx
  802406:	83 ec 10             	sub    $0x10,%esp
  802409:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80240c:	8b 45 08             	mov    0x8(%ebp),%eax
  80240f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802414:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80241a:	8b 45 14             	mov    0x14(%ebp),%eax
  80241d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802422:	b8 07 00 00 00       	mov    $0x7,%eax
  802427:	e8 94 fe ff ff       	call   8022c0 <nsipc>
  80242c:	89 c3                	mov    %eax,%ebx
  80242e:	85 c0                	test   %eax,%eax
  802430:	78 46                	js     802478 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802432:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802437:	7f 04                	jg     80243d <nsipc_recv+0x3c>
  802439:	39 c6                	cmp    %eax,%esi
  80243b:	7d 24                	jge    802461 <nsipc_recv+0x60>
  80243d:	c7 44 24 0c f0 33 80 	movl   $0x8033f0,0xc(%esp)
  802444:	00 
  802445:	c7 44 24 08 cf 33 80 	movl   $0x8033cf,0x8(%esp)
  80244c:	00 
  80244d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802454:	00 
  802455:	c7 04 24 e4 33 80 00 	movl   $0x8033e4,(%esp)
  80245c:	e8 2b de ff ff       	call   80028c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802461:	89 44 24 08          	mov    %eax,0x8(%esp)
  802465:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80246c:	00 
  80246d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802470:	89 04 24             	mov    %eax,(%esp)
  802473:	e8 6d e7 ff ff       	call   800be5 <memmove>
	}

	return r;
}
  802478:	89 d8                	mov    %ebx,%eax
  80247a:	83 c4 10             	add    $0x10,%esp
  80247d:	5b                   	pop    %ebx
  80247e:	5e                   	pop    %esi
  80247f:	5d                   	pop    %ebp
  802480:	c3                   	ret    

00802481 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802481:	55                   	push   %ebp
  802482:	89 e5                	mov    %esp,%ebp
  802484:	53                   	push   %ebx
  802485:	83 ec 14             	sub    $0x14,%esp
  802488:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80248b:	8b 45 08             	mov    0x8(%ebp),%eax
  80248e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802493:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802497:	8b 45 0c             	mov    0xc(%ebp),%eax
  80249a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80249e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8024a5:	e8 3b e7 ff ff       	call   800be5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8024aa:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8024b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8024b5:	e8 06 fe ff ff       	call   8022c0 <nsipc>
}
  8024ba:	83 c4 14             	add    $0x14,%esp
  8024bd:	5b                   	pop    %ebx
  8024be:	5d                   	pop    %ebp
  8024bf:	c3                   	ret    

008024c0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
  8024c3:	53                   	push   %ebx
  8024c4:	83 ec 14             	sub    $0x14,%esp
  8024c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8024ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8024d2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024dd:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8024e4:	e8 fc e6 ff ff       	call   800be5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8024e9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8024ef:	b8 02 00 00 00       	mov    $0x2,%eax
  8024f4:	e8 c7 fd ff ff       	call   8022c0 <nsipc>
}
  8024f9:	83 c4 14             	add    $0x14,%esp
  8024fc:	5b                   	pop    %ebx
  8024fd:	5d                   	pop    %ebp
  8024fe:	c3                   	ret    

008024ff <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8024ff:	55                   	push   %ebp
  802500:	89 e5                	mov    %esp,%ebp
  802502:	83 ec 18             	sub    $0x18,%esp
  802505:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802508:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80250b:	8b 45 08             	mov    0x8(%ebp),%eax
  80250e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802513:	b8 01 00 00 00       	mov    $0x1,%eax
  802518:	e8 a3 fd ff ff       	call   8022c0 <nsipc>
  80251d:	89 c3                	mov    %eax,%ebx
  80251f:	85 c0                	test   %eax,%eax
  802521:	78 25                	js     802548 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802523:	be 10 60 80 00       	mov    $0x806010,%esi
  802528:	8b 06                	mov    (%esi),%eax
  80252a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80252e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802535:	00 
  802536:	8b 45 0c             	mov    0xc(%ebp),%eax
  802539:	89 04 24             	mov    %eax,(%esp)
  80253c:	e8 a4 e6 ff ff       	call   800be5 <memmove>
		*addrlen = ret->ret_addrlen;
  802541:	8b 16                	mov    (%esi),%edx
  802543:	8b 45 10             	mov    0x10(%ebp),%eax
  802546:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802548:	89 d8                	mov    %ebx,%eax
  80254a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80254d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802550:	89 ec                	mov    %ebp,%esp
  802552:	5d                   	pop    %ebp
  802553:	c3                   	ret    
	...

00802560 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	83 ec 18             	sub    $0x18,%esp
  802566:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802569:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80256c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80256f:	8b 45 08             	mov    0x8(%ebp),%eax
  802572:	89 04 24             	mov    %eax,(%esp)
  802575:	e8 a6 f1 ff ff       	call   801720 <fd2data>
  80257a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80257c:	c7 44 24 04 05 34 80 	movl   $0x803405,0x4(%esp)
  802583:	00 
  802584:	89 34 24             	mov    %esi,(%esp)
  802587:	e8 9e e4 ff ff       	call   800a2a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80258c:	8b 43 04             	mov    0x4(%ebx),%eax
  80258f:	2b 03                	sub    (%ebx),%eax
  802591:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802597:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80259e:	00 00 00 
	stat->st_dev = &devpipe;
  8025a1:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  8025a8:	70 80 00 
	return 0;
}
  8025ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8025b0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8025b3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8025b6:	89 ec                	mov    %ebp,%esp
  8025b8:	5d                   	pop    %ebp
  8025b9:	c3                   	ret    

008025ba <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8025ba:	55                   	push   %ebp
  8025bb:	89 e5                	mov    %esp,%ebp
  8025bd:	53                   	push   %ebx
  8025be:	83 ec 14             	sub    $0x14,%esp
  8025c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8025c4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025cf:	e8 f6 ea ff ff       	call   8010ca <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8025d4:	89 1c 24             	mov    %ebx,(%esp)
  8025d7:	e8 44 f1 ff ff       	call   801720 <fd2data>
  8025dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025e7:	e8 de ea ff ff       	call   8010ca <sys_page_unmap>
}
  8025ec:	83 c4 14             	add    $0x14,%esp
  8025ef:	5b                   	pop    %ebx
  8025f0:	5d                   	pop    %ebp
  8025f1:	c3                   	ret    

008025f2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8025f2:	55                   	push   %ebp
  8025f3:	89 e5                	mov    %esp,%ebp
  8025f5:	57                   	push   %edi
  8025f6:	56                   	push   %esi
  8025f7:	53                   	push   %ebx
  8025f8:	83 ec 2c             	sub    $0x2c,%esp
  8025fb:	89 c7                	mov    %eax,%edi
  8025fd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802600:	a1 74 70 80 00       	mov    0x807074,%eax
  802605:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802608:	89 3c 24             	mov    %edi,(%esp)
  80260b:	e8 24 fa ff ff       	call   802034 <pageref>
  802610:	89 c6                	mov    %eax,%esi
  802612:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802615:	89 04 24             	mov    %eax,(%esp)
  802618:	e8 17 fa ff ff       	call   802034 <pageref>
  80261d:	39 c6                	cmp    %eax,%esi
  80261f:	0f 94 c0             	sete   %al
  802622:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802625:	8b 15 74 70 80 00    	mov    0x807074,%edx
  80262b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80262e:	39 cb                	cmp    %ecx,%ebx
  802630:	75 08                	jne    80263a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802632:	83 c4 2c             	add    $0x2c,%esp
  802635:	5b                   	pop    %ebx
  802636:	5e                   	pop    %esi
  802637:	5f                   	pop    %edi
  802638:	5d                   	pop    %ebp
  802639:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80263a:	83 f8 01             	cmp    $0x1,%eax
  80263d:	75 c1                	jne    802600 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80263f:	8b 52 58             	mov    0x58(%edx),%edx
  802642:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802646:	89 54 24 08          	mov    %edx,0x8(%esp)
  80264a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80264e:	c7 04 24 0c 34 80 00 	movl   $0x80340c,(%esp)
  802655:	e8 f7 dc ff ff       	call   800351 <cprintf>
  80265a:	eb a4                	jmp    802600 <_pipeisclosed+0xe>

0080265c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80265c:	55                   	push   %ebp
  80265d:	89 e5                	mov    %esp,%ebp
  80265f:	57                   	push   %edi
  802660:	56                   	push   %esi
  802661:	53                   	push   %ebx
  802662:	83 ec 1c             	sub    $0x1c,%esp
  802665:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802668:	89 34 24             	mov    %esi,(%esp)
  80266b:	e8 b0 f0 ff ff       	call   801720 <fd2data>
  802670:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802672:	bf 00 00 00 00       	mov    $0x0,%edi
  802677:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80267b:	75 54                	jne    8026d1 <devpipe_write+0x75>
  80267d:	eb 60                	jmp    8026df <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80267f:	89 da                	mov    %ebx,%edx
  802681:	89 f0                	mov    %esi,%eax
  802683:	e8 6a ff ff ff       	call   8025f2 <_pipeisclosed>
  802688:	85 c0                	test   %eax,%eax
  80268a:	74 07                	je     802693 <devpipe_write+0x37>
  80268c:	b8 00 00 00 00       	mov    $0x0,%eax
  802691:	eb 53                	jmp    8026e6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802693:	90                   	nop
  802694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802698:	e8 48 eb ff ff       	call   8011e5 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80269d:	8b 43 04             	mov    0x4(%ebx),%eax
  8026a0:	8b 13                	mov    (%ebx),%edx
  8026a2:	83 c2 20             	add    $0x20,%edx
  8026a5:	39 d0                	cmp    %edx,%eax
  8026a7:	73 d6                	jae    80267f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8026a9:	89 c2                	mov    %eax,%edx
  8026ab:	c1 fa 1f             	sar    $0x1f,%edx
  8026ae:	c1 ea 1b             	shr    $0x1b,%edx
  8026b1:	01 d0                	add    %edx,%eax
  8026b3:	83 e0 1f             	and    $0x1f,%eax
  8026b6:	29 d0                	sub    %edx,%eax
  8026b8:	89 c2                	mov    %eax,%edx
  8026ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026bd:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8026c1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8026c5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026c9:	83 c7 01             	add    $0x1,%edi
  8026cc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8026cf:	76 13                	jbe    8026e4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8026d1:	8b 43 04             	mov    0x4(%ebx),%eax
  8026d4:	8b 13                	mov    (%ebx),%edx
  8026d6:	83 c2 20             	add    $0x20,%edx
  8026d9:	39 d0                	cmp    %edx,%eax
  8026db:	73 a2                	jae    80267f <devpipe_write+0x23>
  8026dd:	eb ca                	jmp    8026a9 <devpipe_write+0x4d>
  8026df:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8026e4:	89 f8                	mov    %edi,%eax
}
  8026e6:	83 c4 1c             	add    $0x1c,%esp
  8026e9:	5b                   	pop    %ebx
  8026ea:	5e                   	pop    %esi
  8026eb:	5f                   	pop    %edi
  8026ec:	5d                   	pop    %ebp
  8026ed:	c3                   	ret    

008026ee <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8026ee:	55                   	push   %ebp
  8026ef:	89 e5                	mov    %esp,%ebp
  8026f1:	83 ec 28             	sub    $0x28,%esp
  8026f4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8026f7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8026fa:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8026fd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802700:	89 3c 24             	mov    %edi,(%esp)
  802703:	e8 18 f0 ff ff       	call   801720 <fd2data>
  802708:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80270a:	be 00 00 00 00       	mov    $0x0,%esi
  80270f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802713:	75 4c                	jne    802761 <devpipe_read+0x73>
  802715:	eb 5b                	jmp    802772 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802717:	89 f0                	mov    %esi,%eax
  802719:	eb 5e                	jmp    802779 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80271b:	89 da                	mov    %ebx,%edx
  80271d:	89 f8                	mov    %edi,%eax
  80271f:	90                   	nop
  802720:	e8 cd fe ff ff       	call   8025f2 <_pipeisclosed>
  802725:	85 c0                	test   %eax,%eax
  802727:	74 07                	je     802730 <devpipe_read+0x42>
  802729:	b8 00 00 00 00       	mov    $0x0,%eax
  80272e:	eb 49                	jmp    802779 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802730:	e8 b0 ea ff ff       	call   8011e5 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802735:	8b 03                	mov    (%ebx),%eax
  802737:	3b 43 04             	cmp    0x4(%ebx),%eax
  80273a:	74 df                	je     80271b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80273c:	89 c2                	mov    %eax,%edx
  80273e:	c1 fa 1f             	sar    $0x1f,%edx
  802741:	c1 ea 1b             	shr    $0x1b,%edx
  802744:	01 d0                	add    %edx,%eax
  802746:	83 e0 1f             	and    $0x1f,%eax
  802749:	29 d0                	sub    %edx,%eax
  80274b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802750:	8b 55 0c             	mov    0xc(%ebp),%edx
  802753:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802756:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802759:	83 c6 01             	add    $0x1,%esi
  80275c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80275f:	76 16                	jbe    802777 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802761:	8b 03                	mov    (%ebx),%eax
  802763:	3b 43 04             	cmp    0x4(%ebx),%eax
  802766:	75 d4                	jne    80273c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802768:	85 f6                	test   %esi,%esi
  80276a:	75 ab                	jne    802717 <devpipe_read+0x29>
  80276c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802770:	eb a9                	jmp    80271b <devpipe_read+0x2d>
  802772:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802777:	89 f0                	mov    %esi,%eax
}
  802779:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80277c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80277f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802782:	89 ec                	mov    %ebp,%esp
  802784:	5d                   	pop    %ebp
  802785:	c3                   	ret    

00802786 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
  802789:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80278c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80278f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802793:	8b 45 08             	mov    0x8(%ebp),%eax
  802796:	89 04 24             	mov    %eax,(%esp)
  802799:	e8 0f f0 ff ff       	call   8017ad <fd_lookup>
  80279e:	85 c0                	test   %eax,%eax
  8027a0:	78 15                	js     8027b7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	89 04 24             	mov    %eax,(%esp)
  8027a8:	e8 73 ef ff ff       	call   801720 <fd2data>
	return _pipeisclosed(fd, p);
  8027ad:	89 c2                	mov    %eax,%edx
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	e8 3b fe ff ff       	call   8025f2 <_pipeisclosed>
}
  8027b7:	c9                   	leave  
  8027b8:	c3                   	ret    

008027b9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8027b9:	55                   	push   %ebp
  8027ba:	89 e5                	mov    %esp,%ebp
  8027bc:	83 ec 48             	sub    $0x48,%esp
  8027bf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8027c2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8027c5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8027c8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8027cb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8027ce:	89 04 24             	mov    %eax,(%esp)
  8027d1:	e8 65 ef ff ff       	call   80173b <fd_alloc>
  8027d6:	89 c3                	mov    %eax,%ebx
  8027d8:	85 c0                	test   %eax,%eax
  8027da:	0f 88 42 01 00 00    	js     802922 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027e0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027e7:	00 
  8027e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027f6:	e8 8b e9 ff ff       	call   801186 <sys_page_alloc>
  8027fb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8027fd:	85 c0                	test   %eax,%eax
  8027ff:	0f 88 1d 01 00 00    	js     802922 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802805:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802808:	89 04 24             	mov    %eax,(%esp)
  80280b:	e8 2b ef ff ff       	call   80173b <fd_alloc>
  802810:	89 c3                	mov    %eax,%ebx
  802812:	85 c0                	test   %eax,%eax
  802814:	0f 88 f5 00 00 00    	js     80290f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80281a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802821:	00 
  802822:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802825:	89 44 24 04          	mov    %eax,0x4(%esp)
  802829:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802830:	e8 51 e9 ff ff       	call   801186 <sys_page_alloc>
  802835:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802837:	85 c0                	test   %eax,%eax
  802839:	0f 88 d0 00 00 00    	js     80290f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80283f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802842:	89 04 24             	mov    %eax,(%esp)
  802845:	e8 d6 ee ff ff       	call   801720 <fd2data>
  80284a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80284c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802853:	00 
  802854:	89 44 24 04          	mov    %eax,0x4(%esp)
  802858:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80285f:	e8 22 e9 ff ff       	call   801186 <sys_page_alloc>
  802864:	89 c3                	mov    %eax,%ebx
  802866:	85 c0                	test   %eax,%eax
  802868:	0f 88 8e 00 00 00    	js     8028fc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80286e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802871:	89 04 24             	mov    %eax,(%esp)
  802874:	e8 a7 ee ff ff       	call   801720 <fd2data>
  802879:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802880:	00 
  802881:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802885:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80288c:	00 
  80288d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802891:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802898:	e8 8b e8 ff ff       	call   801128 <sys_page_map>
  80289d:	89 c3                	mov    %eax,%ebx
  80289f:	85 c0                	test   %eax,%eax
  8028a1:	78 49                	js     8028ec <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8028a3:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  8028a8:	8b 08                	mov    (%eax),%ecx
  8028aa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028ad:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8028af:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028b2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8028b9:	8b 10                	mov    (%eax),%edx
  8028bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028be:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8028c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8028ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028cd:	89 04 24             	mov    %eax,(%esp)
  8028d0:	e8 3b ee ff ff       	call   801710 <fd2num>
  8028d5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8028d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028da:	89 04 24             	mov    %eax,(%esp)
  8028dd:	e8 2e ee ff ff       	call   801710 <fd2num>
  8028e2:	89 47 04             	mov    %eax,0x4(%edi)
  8028e5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8028ea:	eb 36                	jmp    802922 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8028ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028f7:	e8 ce e7 ff ff       	call   8010ca <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8028fc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  802903:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80290a:	e8 bb e7 ff ff       	call   8010ca <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80290f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802912:	89 44 24 04          	mov    %eax,0x4(%esp)
  802916:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80291d:	e8 a8 e7 ff ff       	call   8010ca <sys_page_unmap>
    err:
	return r;
}
  802922:	89 d8                	mov    %ebx,%eax
  802924:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802927:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80292a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80292d:	89 ec                	mov    %ebp,%esp
  80292f:	5d                   	pop    %ebp
  802930:	c3                   	ret    
	...

00802940 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802940:	55                   	push   %ebp
  802941:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802943:	b8 00 00 00 00       	mov    $0x0,%eax
  802948:	5d                   	pop    %ebp
  802949:	c3                   	ret    

0080294a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80294a:	55                   	push   %ebp
  80294b:	89 e5                	mov    %esp,%ebp
  80294d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802950:	c7 44 24 04 24 34 80 	movl   $0x803424,0x4(%esp)
  802957:	00 
  802958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80295b:	89 04 24             	mov    %eax,(%esp)
  80295e:	e8 c7 e0 ff ff       	call   800a2a <strcpy>
	return 0;
}
  802963:	b8 00 00 00 00       	mov    $0x0,%eax
  802968:	c9                   	leave  
  802969:	c3                   	ret    

0080296a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80296a:	55                   	push   %ebp
  80296b:	89 e5                	mov    %esp,%ebp
  80296d:	57                   	push   %edi
  80296e:	56                   	push   %esi
  80296f:	53                   	push   %ebx
  802970:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802976:	b8 00 00 00 00       	mov    $0x0,%eax
  80297b:	be 00 00 00 00       	mov    $0x0,%esi
  802980:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802984:	74 3f                	je     8029c5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802986:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80298c:	8b 55 10             	mov    0x10(%ebp),%edx
  80298f:	29 c2                	sub    %eax,%edx
  802991:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802993:	83 fa 7f             	cmp    $0x7f,%edx
  802996:	76 05                	jbe    80299d <devcons_write+0x33>
  802998:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80299d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029a1:	03 45 0c             	add    0xc(%ebp),%eax
  8029a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029a8:	89 3c 24             	mov    %edi,(%esp)
  8029ab:	e8 35 e2 ff ff       	call   800be5 <memmove>
		sys_cputs(buf, m);
  8029b0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8029b4:	89 3c 24             	mov    %edi,(%esp)
  8029b7:	e8 64 e4 ff ff       	call   800e20 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8029bc:	01 de                	add    %ebx,%esi
  8029be:	89 f0                	mov    %esi,%eax
  8029c0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8029c3:	72 c7                	jb     80298c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8029c5:	89 f0                	mov    %esi,%eax
  8029c7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8029cd:	5b                   	pop    %ebx
  8029ce:	5e                   	pop    %esi
  8029cf:	5f                   	pop    %edi
  8029d0:	5d                   	pop    %ebp
  8029d1:	c3                   	ret    

008029d2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8029d2:	55                   	push   %ebp
  8029d3:	89 e5                	mov    %esp,%ebp
  8029d5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8029d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029db:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8029de:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8029e5:	00 
  8029e6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8029e9:	89 04 24             	mov    %eax,(%esp)
  8029ec:	e8 2f e4 ff ff       	call   800e20 <sys_cputs>
}
  8029f1:	c9                   	leave  
  8029f2:	c3                   	ret    

008029f3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8029f3:	55                   	push   %ebp
  8029f4:	89 e5                	mov    %esp,%ebp
  8029f6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8029f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8029fd:	75 07                	jne    802a06 <devcons_read+0x13>
  8029ff:	eb 28                	jmp    802a29 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802a01:	e8 df e7 ff ff       	call   8011e5 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802a06:	66 90                	xchg   %ax,%ax
  802a08:	e8 df e3 ff ff       	call   800dec <sys_cgetc>
  802a0d:	85 c0                	test   %eax,%eax
  802a0f:	90                   	nop
  802a10:	74 ef                	je     802a01 <devcons_read+0xe>
  802a12:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802a14:	85 c0                	test   %eax,%eax
  802a16:	78 16                	js     802a2e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802a18:	83 f8 04             	cmp    $0x4,%eax
  802a1b:	74 0c                	je     802a29 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802a1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a20:	88 10                	mov    %dl,(%eax)
  802a22:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802a27:	eb 05                	jmp    802a2e <devcons_read+0x3b>
  802a29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a2e:	c9                   	leave  
  802a2f:	c3                   	ret    

00802a30 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802a30:	55                   	push   %ebp
  802a31:	89 e5                	mov    %esp,%ebp
  802a33:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a39:	89 04 24             	mov    %eax,(%esp)
  802a3c:	e8 fa ec ff ff       	call   80173b <fd_alloc>
  802a41:	85 c0                	test   %eax,%eax
  802a43:	78 3f                	js     802a84 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a45:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a4c:	00 
  802a4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a50:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a54:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a5b:	e8 26 e7 ff ff       	call   801186 <sys_page_alloc>
  802a60:	85 c0                	test   %eax,%eax
  802a62:	78 20                	js     802a84 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802a64:	8b 15 58 70 80 00    	mov    0x807058,%edx
  802a6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a72:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	89 04 24             	mov    %eax,(%esp)
  802a7f:	e8 8c ec ff ff       	call   801710 <fd2num>
}
  802a84:	c9                   	leave  
  802a85:	c3                   	ret    

00802a86 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802a86:	55                   	push   %ebp
  802a87:	89 e5                	mov    %esp,%ebp
  802a89:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a93:	8b 45 08             	mov    0x8(%ebp),%eax
  802a96:	89 04 24             	mov    %eax,(%esp)
  802a99:	e8 0f ed ff ff       	call   8017ad <fd_lookup>
  802a9e:	85 c0                	test   %eax,%eax
  802aa0:	78 11                	js     802ab3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa5:	8b 00                	mov    (%eax),%eax
  802aa7:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  802aad:	0f 94 c0             	sete   %al
  802ab0:	0f b6 c0             	movzbl %al,%eax
}
  802ab3:	c9                   	leave  
  802ab4:	c3                   	ret    

00802ab5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802ab5:	55                   	push   %ebp
  802ab6:	89 e5                	mov    %esp,%ebp
  802ab8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802abb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802ac2:	00 
  802ac3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802ac6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802aca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ad1:	e8 38 ef ff ff       	call   801a0e <read>
	if (r < 0)
  802ad6:	85 c0                	test   %eax,%eax
  802ad8:	78 0f                	js     802ae9 <getchar+0x34>
		return r;
	if (r < 1)
  802ada:	85 c0                	test   %eax,%eax
  802adc:	7f 07                	jg     802ae5 <getchar+0x30>
  802ade:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802ae3:	eb 04                	jmp    802ae9 <getchar+0x34>
		return -E_EOF;
	return c;
  802ae5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802ae9:	c9                   	leave  
  802aea:	c3                   	ret    
	...

00802aec <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802aec:	55                   	push   %ebp
  802aed:	89 e5                	mov    %esp,%ebp
  802aef:	53                   	push   %ebx
  802af0:	83 ec 14             	sub    $0x14,%esp
  802af3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    // cprintf("\nhere outside loading creating page\n");

	if (_pgfault_handler == 0) {
  802af6:	83 3d 7c 70 80 00 00 	cmpl   $0x0,0x80707c
  802afd:	75 58                	jne    802b57 <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
           //cprintf("\nhere inside loading creating page\n");    
          if(sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  802aff:	e8 15 e7 ff ff       	call   801219 <sys_getenvid>
  802b04:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802b0b:	00 
  802b0c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802b13:	ee 
  802b14:	89 04 24             	mov    %eax,(%esp)
  802b17:	e8 6a e6 ff ff       	call   801186 <sys_page_alloc>
  802b1c:	85 c0                	test   %eax,%eax
  802b1e:	79 1c                	jns    802b3c <set_pgfault_handler+0x50>
                          panic("Cant allocate Page");                    
  802b20:	c7 44 24 08 8c 32 80 	movl   $0x80328c,0x8(%esp)
  802b27:	00 
  802b28:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802b2f:	00 
  802b30:	c7 04 24 30 34 80 00 	movl   $0x803430,(%esp)
  802b37:	e8 50 d7 ff ff       	call   80028c <_panic>
                _pgfault_handler=handler;
  802b3c:	89 1d 7c 70 80 00    	mov    %ebx,0x80707c
//entry point _pgfault_handler not pointed to by the kernel bcz after the execution is complete control needs to be returned back to execute the rest...so upcall is there         
             sys_env_set_pgfault_upcall(sys_getenvid(),_pgfault_upcall);
  802b42:	e8 d2 e6 ff ff       	call   801219 <sys_getenvid>
  802b47:	c7 44 24 04 64 2b 80 	movl   $0x802b64,0x4(%esp)
  802b4e:	00 
  802b4f:	89 04 24             	mov    %eax,(%esp)
  802b52:	e8 59 e4 ff ff       	call   800fb0 <sys_env_set_pgfault_upcall>

	// Save handler pointer for assembly to call.
 //     if(sys_page_alloc(0,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
   //                       panic("Cant allocate Page");

	_pgfault_handler = handler;
  802b57:	89 1d 7c 70 80 00    	mov    %ebx,0x80707c
}
  802b5d:	83 c4 14             	add    $0x14,%esp
  802b60:	5b                   	pop    %ebx
  802b61:	5d                   	pop    %ebp
  802b62:	c3                   	ret    
	...

00802b64 <_pgfault_upcall>:
  802b64:	54                   	push   %esp
  802b65:	a1 7c 70 80 00       	mov    0x80707c,%eax
  802b6a:	ff d0                	call   *%eax
  802b6c:	83 c4 04             	add    $0x4,%esp
  802b6f:	83 c4 08             	add    $0x8,%esp
  802b72:	8b 5c 24 20          	mov    0x20(%esp),%ebx
  802b76:	8b 44 24 28          	mov    0x28(%esp),%eax
  802b7a:	83 e8 04             	sub    $0x4,%eax
  802b7d:	89 44 24 28          	mov    %eax,0x28(%esp)
  802b81:	89 18                	mov    %ebx,(%eax)
  802b83:	61                   	popa   
  802b84:	83 c4 04             	add    $0x4,%esp
  802b87:	9d                   	popf   
  802b88:	5c                   	pop    %esp
  802b89:	c3                   	ret    
  802b8a:	00 00                	add    %al,(%eax)
  802b8c:	00 00                	add    %al,(%eax)
	...

00802b90 <__udivdi3>:
  802b90:	55                   	push   %ebp
  802b91:	89 e5                	mov    %esp,%ebp
  802b93:	57                   	push   %edi
  802b94:	56                   	push   %esi
  802b95:	83 ec 10             	sub    $0x10,%esp
  802b98:	8b 45 14             	mov    0x14(%ebp),%eax
  802b9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b9e:	8b 75 10             	mov    0x10(%ebp),%esi
  802ba1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802ba9:	75 35                	jne    802be0 <__udivdi3+0x50>
  802bab:	39 fe                	cmp    %edi,%esi
  802bad:	77 61                	ja     802c10 <__udivdi3+0x80>
  802baf:	85 f6                	test   %esi,%esi
  802bb1:	75 0b                	jne    802bbe <__udivdi3+0x2e>
  802bb3:	b8 01 00 00 00       	mov    $0x1,%eax
  802bb8:	31 d2                	xor    %edx,%edx
  802bba:	f7 f6                	div    %esi
  802bbc:	89 c6                	mov    %eax,%esi
  802bbe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802bc1:	31 d2                	xor    %edx,%edx
  802bc3:	89 f8                	mov    %edi,%eax
  802bc5:	f7 f6                	div    %esi
  802bc7:	89 c7                	mov    %eax,%edi
  802bc9:	89 c8                	mov    %ecx,%eax
  802bcb:	f7 f6                	div    %esi
  802bcd:	89 c1                	mov    %eax,%ecx
  802bcf:	89 fa                	mov    %edi,%edx
  802bd1:	89 c8                	mov    %ecx,%eax
  802bd3:	83 c4 10             	add    $0x10,%esp
  802bd6:	5e                   	pop    %esi
  802bd7:	5f                   	pop    %edi
  802bd8:	5d                   	pop    %ebp
  802bd9:	c3                   	ret    
  802bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802be0:	39 f8                	cmp    %edi,%eax
  802be2:	77 1c                	ja     802c00 <__udivdi3+0x70>
  802be4:	0f bd d0             	bsr    %eax,%edx
  802be7:	83 f2 1f             	xor    $0x1f,%edx
  802bea:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802bed:	75 39                	jne    802c28 <__udivdi3+0x98>
  802bef:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802bf2:	0f 86 a0 00 00 00    	jbe    802c98 <__udivdi3+0x108>
  802bf8:	39 f8                	cmp    %edi,%eax
  802bfa:	0f 82 98 00 00 00    	jb     802c98 <__udivdi3+0x108>
  802c00:	31 ff                	xor    %edi,%edi
  802c02:	31 c9                	xor    %ecx,%ecx
  802c04:	89 c8                	mov    %ecx,%eax
  802c06:	89 fa                	mov    %edi,%edx
  802c08:	83 c4 10             	add    $0x10,%esp
  802c0b:	5e                   	pop    %esi
  802c0c:	5f                   	pop    %edi
  802c0d:	5d                   	pop    %ebp
  802c0e:	c3                   	ret    
  802c0f:	90                   	nop
  802c10:	89 d1                	mov    %edx,%ecx
  802c12:	89 fa                	mov    %edi,%edx
  802c14:	89 c8                	mov    %ecx,%eax
  802c16:	31 ff                	xor    %edi,%edi
  802c18:	f7 f6                	div    %esi
  802c1a:	89 c1                	mov    %eax,%ecx
  802c1c:	89 fa                	mov    %edi,%edx
  802c1e:	89 c8                	mov    %ecx,%eax
  802c20:	83 c4 10             	add    $0x10,%esp
  802c23:	5e                   	pop    %esi
  802c24:	5f                   	pop    %edi
  802c25:	5d                   	pop    %ebp
  802c26:	c3                   	ret    
  802c27:	90                   	nop
  802c28:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c2c:	89 f2                	mov    %esi,%edx
  802c2e:	d3 e0                	shl    %cl,%eax
  802c30:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802c33:	b8 20 00 00 00       	mov    $0x20,%eax
  802c38:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802c3b:	89 c1                	mov    %eax,%ecx
  802c3d:	d3 ea                	shr    %cl,%edx
  802c3f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c43:	0b 55 ec             	or     -0x14(%ebp),%edx
  802c46:	d3 e6                	shl    %cl,%esi
  802c48:	89 c1                	mov    %eax,%ecx
  802c4a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802c4d:	89 fe                	mov    %edi,%esi
  802c4f:	d3 ee                	shr    %cl,%esi
  802c51:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c55:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802c58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c5b:	d3 e7                	shl    %cl,%edi
  802c5d:	89 c1                	mov    %eax,%ecx
  802c5f:	d3 ea                	shr    %cl,%edx
  802c61:	09 d7                	or     %edx,%edi
  802c63:	89 f2                	mov    %esi,%edx
  802c65:	89 f8                	mov    %edi,%eax
  802c67:	f7 75 ec             	divl   -0x14(%ebp)
  802c6a:	89 d6                	mov    %edx,%esi
  802c6c:	89 c7                	mov    %eax,%edi
  802c6e:	f7 65 e8             	mull   -0x18(%ebp)
  802c71:	39 d6                	cmp    %edx,%esi
  802c73:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802c76:	72 30                	jb     802ca8 <__udivdi3+0x118>
  802c78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c7b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c7f:	d3 e2                	shl    %cl,%edx
  802c81:	39 c2                	cmp    %eax,%edx
  802c83:	73 05                	jae    802c8a <__udivdi3+0xfa>
  802c85:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802c88:	74 1e                	je     802ca8 <__udivdi3+0x118>
  802c8a:	89 f9                	mov    %edi,%ecx
  802c8c:	31 ff                	xor    %edi,%edi
  802c8e:	e9 71 ff ff ff       	jmp    802c04 <__udivdi3+0x74>
  802c93:	90                   	nop
  802c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c98:	31 ff                	xor    %edi,%edi
  802c9a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802c9f:	e9 60 ff ff ff       	jmp    802c04 <__udivdi3+0x74>
  802ca4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ca8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802cab:	31 ff                	xor    %edi,%edi
  802cad:	89 c8                	mov    %ecx,%eax
  802caf:	89 fa                	mov    %edi,%edx
  802cb1:	83 c4 10             	add    $0x10,%esp
  802cb4:	5e                   	pop    %esi
  802cb5:	5f                   	pop    %edi
  802cb6:	5d                   	pop    %ebp
  802cb7:	c3                   	ret    
	...

00802cc0 <__umoddi3>:
  802cc0:	55                   	push   %ebp
  802cc1:	89 e5                	mov    %esp,%ebp
  802cc3:	57                   	push   %edi
  802cc4:	56                   	push   %esi
  802cc5:	83 ec 20             	sub    $0x20,%esp
  802cc8:	8b 55 14             	mov    0x14(%ebp),%edx
  802ccb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802cce:	8b 7d 10             	mov    0x10(%ebp),%edi
  802cd1:	8b 75 0c             	mov    0xc(%ebp),%esi
  802cd4:	85 d2                	test   %edx,%edx
  802cd6:	89 c8                	mov    %ecx,%eax
  802cd8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802cdb:	75 13                	jne    802cf0 <__umoddi3+0x30>
  802cdd:	39 f7                	cmp    %esi,%edi
  802cdf:	76 3f                	jbe    802d20 <__umoddi3+0x60>
  802ce1:	89 f2                	mov    %esi,%edx
  802ce3:	f7 f7                	div    %edi
  802ce5:	89 d0                	mov    %edx,%eax
  802ce7:	31 d2                	xor    %edx,%edx
  802ce9:	83 c4 20             	add    $0x20,%esp
  802cec:	5e                   	pop    %esi
  802ced:	5f                   	pop    %edi
  802cee:	5d                   	pop    %ebp
  802cef:	c3                   	ret    
  802cf0:	39 f2                	cmp    %esi,%edx
  802cf2:	77 4c                	ja     802d40 <__umoddi3+0x80>
  802cf4:	0f bd ca             	bsr    %edx,%ecx
  802cf7:	83 f1 1f             	xor    $0x1f,%ecx
  802cfa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802cfd:	75 51                	jne    802d50 <__umoddi3+0x90>
  802cff:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802d02:	0f 87 e0 00 00 00    	ja     802de8 <__umoddi3+0x128>
  802d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0b:	29 f8                	sub    %edi,%eax
  802d0d:	19 d6                	sbb    %edx,%esi
  802d0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d15:	89 f2                	mov    %esi,%edx
  802d17:	83 c4 20             	add    $0x20,%esp
  802d1a:	5e                   	pop    %esi
  802d1b:	5f                   	pop    %edi
  802d1c:	5d                   	pop    %ebp
  802d1d:	c3                   	ret    
  802d1e:	66 90                	xchg   %ax,%ax
  802d20:	85 ff                	test   %edi,%edi
  802d22:	75 0b                	jne    802d2f <__umoddi3+0x6f>
  802d24:	b8 01 00 00 00       	mov    $0x1,%eax
  802d29:	31 d2                	xor    %edx,%edx
  802d2b:	f7 f7                	div    %edi
  802d2d:	89 c7                	mov    %eax,%edi
  802d2f:	89 f0                	mov    %esi,%eax
  802d31:	31 d2                	xor    %edx,%edx
  802d33:	f7 f7                	div    %edi
  802d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d38:	f7 f7                	div    %edi
  802d3a:	eb a9                	jmp    802ce5 <__umoddi3+0x25>
  802d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d40:	89 c8                	mov    %ecx,%eax
  802d42:	89 f2                	mov    %esi,%edx
  802d44:	83 c4 20             	add    $0x20,%esp
  802d47:	5e                   	pop    %esi
  802d48:	5f                   	pop    %edi
  802d49:	5d                   	pop    %ebp
  802d4a:	c3                   	ret    
  802d4b:	90                   	nop
  802d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d50:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d54:	d3 e2                	shl    %cl,%edx
  802d56:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d59:	ba 20 00 00 00       	mov    $0x20,%edx
  802d5e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802d61:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d64:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d68:	89 fa                	mov    %edi,%edx
  802d6a:	d3 ea                	shr    %cl,%edx
  802d6c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d70:	0b 55 f4             	or     -0xc(%ebp),%edx
  802d73:	d3 e7                	shl    %cl,%edi
  802d75:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d79:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d7c:	89 f2                	mov    %esi,%edx
  802d7e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802d81:	89 c7                	mov    %eax,%edi
  802d83:	d3 ea                	shr    %cl,%edx
  802d85:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d89:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802d8c:	89 c2                	mov    %eax,%edx
  802d8e:	d3 e6                	shl    %cl,%esi
  802d90:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d94:	d3 ea                	shr    %cl,%edx
  802d96:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d9a:	09 d6                	or     %edx,%esi
  802d9c:	89 f0                	mov    %esi,%eax
  802d9e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802da1:	d3 e7                	shl    %cl,%edi
  802da3:	89 f2                	mov    %esi,%edx
  802da5:	f7 75 f4             	divl   -0xc(%ebp)
  802da8:	89 d6                	mov    %edx,%esi
  802daa:	f7 65 e8             	mull   -0x18(%ebp)
  802dad:	39 d6                	cmp    %edx,%esi
  802daf:	72 2b                	jb     802ddc <__umoddi3+0x11c>
  802db1:	39 c7                	cmp    %eax,%edi
  802db3:	72 23                	jb     802dd8 <__umoddi3+0x118>
  802db5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802db9:	29 c7                	sub    %eax,%edi
  802dbb:	19 d6                	sbb    %edx,%esi
  802dbd:	89 f0                	mov    %esi,%eax
  802dbf:	89 f2                	mov    %esi,%edx
  802dc1:	d3 ef                	shr    %cl,%edi
  802dc3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802dc7:	d3 e0                	shl    %cl,%eax
  802dc9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802dcd:	09 f8                	or     %edi,%eax
  802dcf:	d3 ea                	shr    %cl,%edx
  802dd1:	83 c4 20             	add    $0x20,%esp
  802dd4:	5e                   	pop    %esi
  802dd5:	5f                   	pop    %edi
  802dd6:	5d                   	pop    %ebp
  802dd7:	c3                   	ret    
  802dd8:	39 d6                	cmp    %edx,%esi
  802dda:	75 d9                	jne    802db5 <__umoddi3+0xf5>
  802ddc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802ddf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802de2:	eb d1                	jmp    802db5 <__umoddi3+0xf5>
  802de4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802de8:	39 f2                	cmp    %esi,%edx
  802dea:	0f 82 18 ff ff ff    	jb     802d08 <__umoddi3+0x48>
  802df0:	e9 1d ff ff ff       	jmp    802d12 <__umoddi3+0x52>
