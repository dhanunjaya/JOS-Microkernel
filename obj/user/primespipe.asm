
obj/user/primespipe:     file format elf32-i386


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
  80002c:	e8 9f 02 00 00       	call   8002d0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <primeproc>:

#include <inc/lib.h>

unsigned
primeproc(int fd)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 3c             	sub    $0x3c,%esp
  80003d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800040:	8d 75 e0             	lea    -0x20(%ebp),%esi
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);

	cprintf("%d\n", p);

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  800043:	8d 7d d8             	lea    -0x28(%ebp),%edi
{
	int i, id, p, pfd[2], wfd, r;

	// fetch a prime from our left neighbor
top:
	if ((r = readn(fd, &p, 4)) != 4)
  800046:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80004d:	00 
  80004e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800052:	89 1c 24             	mov    %ebx,(%esp)
  800055:	e8 22 1a 00 00       	call   801a7c <readn>
  80005a:	83 f8 04             	cmp    $0x4,%eax
  80005d:	74 31                	je     800090 <primeproc+0x5c>
		panic("primeproc could not read initial prime: %d, %e", r, r >= 0 ? 0 : r);
  80005f:	85 c0                	test   %eax,%eax
  800061:	0f 9f c2             	setg   %dl
  800064:	0f b6 d2             	movzbl %dl,%edx
  800067:	83 ea 01             	sub    $0x1,%edx
  80006a:	21 c2                	and    %eax,%edx
  80006c:	89 54 24 10          	mov    %edx,0x10(%esp)
  800070:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800074:	c7 44 24 08 c0 2e 80 	movl   $0x802ec0,0x8(%esp)
  80007b:	00 
  80007c:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  800083:	00 
  800084:	c7 04 24 ef 2e 80 00 	movl   $0x802eef,(%esp)
  80008b:	e8 ac 02 00 00       	call   80033c <_panic>

	cprintf("%d\n", p);
  800090:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800093:	89 44 24 04          	mov    %eax,0x4(%esp)
  800097:	c7 04 24 01 2f 80 00 	movl   $0x802f01,(%esp)
  80009e:	e8 5e 03 00 00       	call   800401 <cprintf>

	// fork a right neighbor to continue the chain
	if ((i=pipe(pfd)) < 0)
  8000a3:	89 3c 24             	mov    %edi,(%esp)
  8000a6:	e8 ae 26 00 00       	call   802759 <pipe>
  8000ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	79 20                	jns    8000d2 <primeproc+0x9e>
		panic("pipe: %e", i);
  8000b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b6:	c7 44 24 08 05 2f 80 	movl   $0x802f05,0x8(%esp)
  8000bd:	00 
  8000be:	c7 44 24 04 1b 00 00 	movl   $0x1b,0x4(%esp)
  8000c5:	00 
  8000c6:	c7 04 24 ef 2e 80 00 	movl   $0x802eef,(%esp)
  8000cd:	e8 6a 02 00 00       	call   80033c <_panic>
	if ((id = fork()) < 0)
  8000d2:	e8 e0 13 00 00       	call   8014b7 <fork>
  8000d7:	85 c0                	test   %eax,%eax
  8000d9:	79 20                	jns    8000fb <primeproc+0xc7>
		panic("fork: %e", id);
  8000db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000df:	c7 44 24 08 03 33 80 	movl   $0x803303,0x8(%esp)
  8000e6:	00 
  8000e7:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  8000ee:	00 
  8000ef:	c7 04 24 ef 2e 80 00 	movl   $0x802eef,(%esp)
  8000f6:	e8 41 02 00 00       	call   80033c <_panic>
	if (id == 0) {
  8000fb:	85 c0                	test   %eax,%eax
  8000fd:	75 1b                	jne    80011a <primeproc+0xe6>
		close(fd);
  8000ff:	89 1c 24             	mov    %ebx,(%esp)
  800102:	e8 47 1a 00 00       	call   801b4e <close>
		close(pfd[1]);
  800107:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80010a:	89 04 24             	mov    %eax,(%esp)
  80010d:	e8 3c 1a 00 00       	call   801b4e <close>
		fd = pfd[0];
  800112:	8b 5d d8             	mov    -0x28(%ebp),%ebx
		goto top;
  800115:	e9 2c ff ff ff       	jmp    800046 <primeproc+0x12>
	}

	close(pfd[0]);
  80011a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80011d:	89 04 24             	mov    %eax,(%esp)
  800120:	e8 29 1a 00 00       	call   801b4e <close>
	wfd = pfd[1];
  800125:	8b 7d dc             	mov    -0x24(%ebp),%edi

	// filter out multiples of our prime
	for (;;) {
		if ((r=readn(fd, &i, 4)) != 4)
  800128:	8d 75 e4             	lea    -0x1c(%ebp),%esi
  80012b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800132:	00 
  800133:	89 74 24 04          	mov    %esi,0x4(%esp)
  800137:	89 1c 24             	mov    %ebx,(%esp)
  80013a:	e8 3d 19 00 00       	call   801a7c <readn>
  80013f:	83 f8 04             	cmp    $0x4,%eax
  800142:	74 3c                	je     800180 <primeproc+0x14c>
			panic("primeproc %d readn %d %d %e", p, fd, r, r >= 0 ? 0 : r);
  800144:	85 c0                	test   %eax,%eax
  800146:	0f 9f c2             	setg   %dl
  800149:	0f b6 d2             	movzbl %dl,%edx
  80014c:	83 ea 01             	sub    $0x1,%edx
  80014f:	21 c2                	and    %eax,%edx
  800151:	89 54 24 18          	mov    %edx,0x18(%esp)
  800155:	89 44 24 14          	mov    %eax,0x14(%esp)
  800159:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  80015d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800160:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800164:	c7 44 24 08 0e 2f 80 	movl   $0x802f0e,0x8(%esp)
  80016b:	00 
  80016c:	c7 44 24 04 2b 00 00 	movl   $0x2b,0x4(%esp)
  800173:	00 
  800174:	c7 04 24 ef 2e 80 00 	movl   $0x802eef,(%esp)
  80017b:	e8 bc 01 00 00       	call   80033c <_panic>
		if (i%p)
  800180:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800183:	89 d0                	mov    %edx,%eax
  800185:	c1 fa 1f             	sar    $0x1f,%edx
  800188:	f7 7d e0             	idivl  -0x20(%ebp)
  80018b:	85 d2                	test   %edx,%edx
  80018d:	74 9c                	je     80012b <primeproc+0xf7>
			if ((r=write(wfd, &i, 4)) != 4)
  80018f:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800196:	00 
  800197:	89 74 24 04          	mov    %esi,0x4(%esp)
  80019b:	89 3c 24             	mov    %edi,(%esp)
  80019e:	e8 c2 17 00 00       	call   801965 <write>
  8001a3:	83 f8 04             	cmp    $0x4,%eax
  8001a6:	74 83                	je     80012b <primeproc+0xf7>
				panic("primeproc %d write: %d %e", p, r, r >= 0 ? 0 : r);
  8001a8:	85 c0                	test   %eax,%eax
  8001aa:	0f 9f c2             	setg   %dl
  8001ad:	0f b6 d2             	movzbl %dl,%edx
  8001b0:	83 ea 01             	sub    $0x1,%edx
  8001b3:	21 c2                	and    %eax,%edx
  8001b5:	89 54 24 14          	mov    %edx,0x14(%esp)
  8001b9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001c4:	c7 44 24 08 2a 2f 80 	movl   $0x802f2a,0x8(%esp)
  8001cb:	00 
  8001cc:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
  8001d3:	00 
  8001d4:	c7 04 24 ef 2e 80 00 	movl   $0x802eef,(%esp)
  8001db:	e8 5c 01 00 00       	call   80033c <_panic>

008001e0 <umain>:
	}
}

void
umain(void)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	53                   	push   %ebx
  8001e4:	83 ec 34             	sub    $0x34,%esp
	int i, id, p[2], r;

	argv0 = "primespipe";
  8001e7:	c7 05 78 70 80 00 44 	movl   $0x802f44,0x807078
  8001ee:	2f 80 00 

	if ((i=pipe(p)) < 0)
  8001f1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8001f4:	89 04 24             	mov    %eax,(%esp)
  8001f7:	e8 5d 25 00 00       	call   802759 <pipe>
  8001fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8001ff:	85 c0                	test   %eax,%eax
  800201:	79 20                	jns    800223 <umain+0x43>
		panic("pipe: %e", i);
  800203:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800207:	c7 44 24 08 05 2f 80 	movl   $0x802f05,0x8(%esp)
  80020e:	00 
  80020f:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  800216:	00 
  800217:	c7 04 24 ef 2e 80 00 	movl   $0x802eef,(%esp)
  80021e:	e8 19 01 00 00       	call   80033c <_panic>

	// fork the first prime process in the chain
	if ((id=fork()) < 0)
  800223:	e8 8f 12 00 00       	call   8014b7 <fork>
  800228:	85 c0                	test   %eax,%eax
  80022a:	79 20                	jns    80024c <umain+0x6c>
		panic("fork: %e", id);
  80022c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800230:	c7 44 24 08 03 33 80 	movl   $0x803303,0x8(%esp)
  800237:	00 
  800238:	c7 44 24 04 3e 00 00 	movl   $0x3e,0x4(%esp)
  80023f:	00 
  800240:	c7 04 24 ef 2e 80 00 	movl   $0x802eef,(%esp)
  800247:	e8 f0 00 00 00       	call   80033c <_panic>

	if (id == 0) {
  80024c:	85 c0                	test   %eax,%eax
  80024e:	75 16                	jne    800266 <umain+0x86>
		close(p[1]);
  800250:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800253:	89 04 24             	mov    %eax,(%esp)
  800256:	e8 f3 18 00 00       	call   801b4e <close>
		primeproc(p[0]);
  80025b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80025e:	89 04 24             	mov    %eax,(%esp)
  800261:	e8 ce fd ff ff       	call   800034 <primeproc>
	}

	close(p[0]);
  800266:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800269:	89 04 24             	mov    %eax,(%esp)
  80026c:	e8 dd 18 00 00       	call   801b4e <close>

	// feed all the integers through
	for (i=2;; i++)
  800271:	c7 45 f4 02 00 00 00 	movl   $0x2,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
  800278:	8d 5d f4             	lea    -0xc(%ebp),%ebx
  80027b:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800282:	00 
  800283:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800287:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80028a:	89 04 24             	mov    %eax,(%esp)
  80028d:	e8 d3 16 00 00       	call   801965 <write>
  800292:	83 f8 04             	cmp    $0x4,%eax
  800295:	74 31                	je     8002c8 <umain+0xe8>
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
  800297:	85 c0                	test   %eax,%eax
  800299:	0f 9f c2             	setg   %dl
  80029c:	0f b6 d2             	movzbl %dl,%edx
  80029f:	83 ea 01             	sub    $0x1,%edx
  8002a2:	21 c2                	and    %eax,%edx
  8002a4:	89 54 24 10          	mov    %edx,0x10(%esp)
  8002a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002ac:	c7 44 24 08 4f 2f 80 	movl   $0x802f4f,0x8(%esp)
  8002b3:	00 
  8002b4:	c7 44 24 04 4a 00 00 	movl   $0x4a,0x4(%esp)
  8002bb:	00 
  8002bc:	c7 04 24 ef 2e 80 00 	movl   $0x802eef,(%esp)
  8002c3:	e8 74 00 00 00       	call   80033c <_panic>
	}

	close(p[0]);

	// feed all the integers through
	for (i=2;; i++)
  8002c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
		if ((r=write(p[1], &i, 4)) != 4)
			panic("generator write: %d, %e", r, r >= 0 ? 0 : r);
}
  8002cc:	eb ad                	jmp    80027b <umain+0x9b>
	...

008002d0 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002d0:	55                   	push   %ebp
  8002d1:	89 e5                	mov    %esp,%ebp
  8002d3:	83 ec 18             	sub    $0x18,%esp
  8002d6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8002d9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8002dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8002df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  8002e2:	e8 e2 0f 00 00       	call   8012c9 <sys_getenvid>
  8002e7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002ec:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002ef:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f4:	a3 74 70 80 00       	mov    %eax,0x807074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f9:	85 f6                	test   %esi,%esi
  8002fb:	7e 07                	jle    800304 <libmain+0x34>
		binaryname = argv[0];
  8002fd:	8b 03                	mov    (%ebx),%eax
  8002ff:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  800304:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800308:	89 34 24             	mov    %esi,(%esp)
  80030b:	e8 d0 fe ff ff       	call   8001e0 <umain>

	// exit gracefully
	exit();
  800310:	e8 0b 00 00 00       	call   800320 <exit>
}
  800315:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800318:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80031b:	89 ec                	mov    %ebp,%esp
  80031d:	5d                   	pop    %ebp
  80031e:	c3                   	ret    
	...

00800320 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800326:	e8 a0 18 00 00       	call   801bcb <close_all>
	sys_env_destroy(0);
  80032b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800332:	e8 c6 0f 00 00       	call   8012fd <sys_env_destroy>
}
  800337:	c9                   	leave  
  800338:	c3                   	ret    
  800339:	00 00                	add    %al,(%eax)
	...

0080033c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80033c:	55                   	push   %ebp
  80033d:	89 e5                	mov    %esp,%ebp
  80033f:	53                   	push   %ebx
  800340:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  800343:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800346:	a1 78 70 80 00       	mov    0x807078,%eax
  80034b:	85 c0                	test   %eax,%eax
  80034d:	74 10                	je     80035f <_panic+0x23>
		cprintf("%s: ", argv0);
  80034f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800353:	c7 04 24 7e 2f 80 00 	movl   $0x802f7e,(%esp)
  80035a:	e8 a2 00 00 00       	call   800401 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80035f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800362:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	89 44 24 08          	mov    %eax,0x8(%esp)
  80036d:	a1 00 70 80 00       	mov    0x807000,%eax
  800372:	89 44 24 04          	mov    %eax,0x4(%esp)
  800376:	c7 04 24 83 2f 80 00 	movl   $0x802f83,(%esp)
  80037d:	e8 7f 00 00 00       	call   800401 <cprintf>
	vcprintf(fmt, ap);
  800382:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800386:	8b 45 10             	mov    0x10(%ebp),%eax
  800389:	89 04 24             	mov    %eax,(%esp)
  80038c:	e8 0f 00 00 00       	call   8003a0 <vcprintf>
	cprintf("\n");
  800391:	c7 04 24 03 2f 80 00 	movl   $0x802f03,(%esp)
  800398:	e8 64 00 00 00       	call   800401 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80039d:	cc                   	int3   
  80039e:	eb fd                	jmp    80039d <_panic+0x61>

008003a0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8003a0:	55                   	push   %ebp
  8003a1:	89 e5                	mov    %esp,%ebp
  8003a3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003a9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003b0:	00 00 00 
	b.cnt = 0;
  8003b3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003ba:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003cb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d5:	c7 04 24 1b 04 80 00 	movl   $0x80041b,(%esp)
  8003dc:	e8 cc 01 00 00       	call   8005ad <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003e1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8003e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003eb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003f1:	89 04 24             	mov    %eax,(%esp)
  8003f4:	e8 d7 0a 00 00       	call   800ed0 <sys_cputs>

	return b.cnt;
}
  8003f9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003ff:	c9                   	leave  
  800400:	c3                   	ret    

00800401 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800401:	55                   	push   %ebp
  800402:	89 e5                	mov    %esp,%ebp
  800404:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800407:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80040a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040e:	8b 45 08             	mov    0x8(%ebp),%eax
  800411:	89 04 24             	mov    %eax,(%esp)
  800414:	e8 87 ff ff ff       	call   8003a0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800419:	c9                   	leave  
  80041a:	c3                   	ret    

0080041b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80041b:	55                   	push   %ebp
  80041c:	89 e5                	mov    %esp,%ebp
  80041e:	53                   	push   %ebx
  80041f:	83 ec 14             	sub    $0x14,%esp
  800422:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800425:	8b 03                	mov    (%ebx),%eax
  800427:	8b 55 08             	mov    0x8(%ebp),%edx
  80042a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80042e:	83 c0 01             	add    $0x1,%eax
  800431:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800433:	3d ff 00 00 00       	cmp    $0xff,%eax
  800438:	75 19                	jne    800453 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80043a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800441:	00 
  800442:	8d 43 08             	lea    0x8(%ebx),%eax
  800445:	89 04 24             	mov    %eax,(%esp)
  800448:	e8 83 0a 00 00       	call   800ed0 <sys_cputs>
		b->idx = 0;
  80044d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800453:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800457:	83 c4 14             	add    $0x14,%esp
  80045a:	5b                   	pop    %ebx
  80045b:	5d                   	pop    %ebp
  80045c:	c3                   	ret    
  80045d:	00 00                	add    %al,(%eax)
	...

00800460 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	57                   	push   %edi
  800464:	56                   	push   %esi
  800465:	53                   	push   %ebx
  800466:	83 ec 4c             	sub    $0x4c,%esp
  800469:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80046c:	89 d6                	mov    %edx,%esi
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800474:	8b 55 0c             	mov    0xc(%ebp),%edx
  800477:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80047a:	8b 45 10             	mov    0x10(%ebp),%eax
  80047d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800480:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800483:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800486:	b9 00 00 00 00       	mov    $0x0,%ecx
  80048b:	39 d1                	cmp    %edx,%ecx
  80048d:	72 15                	jb     8004a4 <printnum+0x44>
  80048f:	77 07                	ja     800498 <printnum+0x38>
  800491:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800494:	39 d0                	cmp    %edx,%eax
  800496:	76 0c                	jbe    8004a4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800498:	83 eb 01             	sub    $0x1,%ebx
  80049b:	85 db                	test   %ebx,%ebx
  80049d:	8d 76 00             	lea    0x0(%esi),%esi
  8004a0:	7f 61                	jg     800503 <printnum+0xa3>
  8004a2:	eb 70                	jmp    800514 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004a4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8004a8:	83 eb 01             	sub    $0x1,%ebx
  8004ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004b3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8004b7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8004bb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8004be:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8004c1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8004c4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8004c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004cf:	00 
  8004d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004d3:	89 04 24             	mov    %eax,(%esp)
  8004d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004dd:	e8 5e 27 00 00       	call   802c40 <__udivdi3>
  8004e2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8004e5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8004e8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8004ec:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004f0:	89 04 24             	mov    %eax,(%esp)
  8004f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004f7:	89 f2                	mov    %esi,%edx
  8004f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004fc:	e8 5f ff ff ff       	call   800460 <printnum>
  800501:	eb 11                	jmp    800514 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800503:	89 74 24 04          	mov    %esi,0x4(%esp)
  800507:	89 3c 24             	mov    %edi,(%esp)
  80050a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80050d:	83 eb 01             	sub    $0x1,%ebx
  800510:	85 db                	test   %ebx,%ebx
  800512:	7f ef                	jg     800503 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800514:	89 74 24 04          	mov    %esi,0x4(%esp)
  800518:	8b 74 24 04          	mov    0x4(%esp),%esi
  80051c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80051f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800523:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80052a:	00 
  80052b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80052e:	89 14 24             	mov    %edx,(%esp)
  800531:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800534:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800538:	e8 33 28 00 00       	call   802d70 <__umoddi3>
  80053d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800541:	0f be 80 9f 2f 80 00 	movsbl 0x802f9f(%eax),%eax
  800548:	89 04 24             	mov    %eax,(%esp)
  80054b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80054e:	83 c4 4c             	add    $0x4c,%esp
  800551:	5b                   	pop    %ebx
  800552:	5e                   	pop    %esi
  800553:	5f                   	pop    %edi
  800554:	5d                   	pop    %ebp
  800555:	c3                   	ret    

00800556 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800559:	83 fa 01             	cmp    $0x1,%edx
  80055c:	7e 0e                	jle    80056c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80055e:	8b 10                	mov    (%eax),%edx
  800560:	8d 4a 08             	lea    0x8(%edx),%ecx
  800563:	89 08                	mov    %ecx,(%eax)
  800565:	8b 02                	mov    (%edx),%eax
  800567:	8b 52 04             	mov    0x4(%edx),%edx
  80056a:	eb 22                	jmp    80058e <getuint+0x38>
	else if (lflag)
  80056c:	85 d2                	test   %edx,%edx
  80056e:	74 10                	je     800580 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800570:	8b 10                	mov    (%eax),%edx
  800572:	8d 4a 04             	lea    0x4(%edx),%ecx
  800575:	89 08                	mov    %ecx,(%eax)
  800577:	8b 02                	mov    (%edx),%eax
  800579:	ba 00 00 00 00       	mov    $0x0,%edx
  80057e:	eb 0e                	jmp    80058e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800580:	8b 10                	mov    (%eax),%edx
  800582:	8d 4a 04             	lea    0x4(%edx),%ecx
  800585:	89 08                	mov    %ecx,(%eax)
  800587:	8b 02                	mov    (%edx),%eax
  800589:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80058e:	5d                   	pop    %ebp
  80058f:	c3                   	ret    

00800590 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800596:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80059a:	8b 10                	mov    (%eax),%edx
  80059c:	3b 50 04             	cmp    0x4(%eax),%edx
  80059f:	73 0a                	jae    8005ab <sprintputch+0x1b>
		*b->buf++ = ch;
  8005a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005a4:	88 0a                	mov    %cl,(%edx)
  8005a6:	83 c2 01             	add    $0x1,%edx
  8005a9:	89 10                	mov    %edx,(%eax)
}
  8005ab:	5d                   	pop    %ebp
  8005ac:	c3                   	ret    

008005ad <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	57                   	push   %edi
  8005b1:	56                   	push   %esi
  8005b2:	53                   	push   %ebx
  8005b3:	83 ec 5c             	sub    $0x5c,%esp
  8005b6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8005b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005bf:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8005c6:	eb 11                	jmp    8005d9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8005c8:	85 c0                	test   %eax,%eax
  8005ca:	0f 84 09 04 00 00    	je     8009d9 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  8005d0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005d4:	89 04 24             	mov    %eax,(%esp)
  8005d7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005d9:	0f b6 03             	movzbl (%ebx),%eax
  8005dc:	83 c3 01             	add    $0x1,%ebx
  8005df:	83 f8 25             	cmp    $0x25,%eax
  8005e2:	75 e4                	jne    8005c8 <vprintfmt+0x1b>
  8005e4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8005e8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8005ef:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8005f6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8005fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800602:	eb 06                	jmp    80060a <vprintfmt+0x5d>
  800604:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800608:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80060a:	0f b6 13             	movzbl (%ebx),%edx
  80060d:	0f b6 c2             	movzbl %dl,%eax
  800610:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800613:	8d 43 01             	lea    0x1(%ebx),%eax
  800616:	83 ea 23             	sub    $0x23,%edx
  800619:	80 fa 55             	cmp    $0x55,%dl
  80061c:	0f 87 9a 03 00 00    	ja     8009bc <vprintfmt+0x40f>
  800622:	0f b6 d2             	movzbl %dl,%edx
  800625:	ff 24 95 e0 30 80 00 	jmp    *0x8030e0(,%edx,4)
  80062c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800630:	eb d6                	jmp    800608 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800632:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800635:	83 ea 30             	sub    $0x30,%edx
  800638:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  80063b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80063e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800641:	83 fb 09             	cmp    $0x9,%ebx
  800644:	77 4c                	ja     800692 <vprintfmt+0xe5>
  800646:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800649:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80064c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80064f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800652:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800656:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800659:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80065c:	83 fb 09             	cmp    $0x9,%ebx
  80065f:	76 eb                	jbe    80064c <vprintfmt+0x9f>
  800661:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800664:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800667:	eb 29                	jmp    800692 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800669:	8b 55 14             	mov    0x14(%ebp),%edx
  80066c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80066f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800672:	8b 12                	mov    (%edx),%edx
  800674:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  800677:	eb 19                	jmp    800692 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800679:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80067c:	c1 fa 1f             	sar    $0x1f,%edx
  80067f:	f7 d2                	not    %edx
  800681:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800684:	eb 82                	jmp    800608 <vprintfmt+0x5b>
  800686:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80068d:	e9 76 ff ff ff       	jmp    800608 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800692:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800696:	0f 89 6c ff ff ff    	jns    800608 <vprintfmt+0x5b>
  80069c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80069f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006a2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8006a5:	89 55 cc             	mov    %edx,-0x34(%ebp)
  8006a8:	e9 5b ff ff ff       	jmp    800608 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006ad:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8006b0:	e9 53 ff ff ff       	jmp    800608 <vprintfmt+0x5b>
  8006b5:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8d 50 04             	lea    0x4(%eax),%edx
  8006be:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	89 04 24             	mov    %eax,(%esp)
  8006ca:	ff d7                	call   *%edi
  8006cc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8006cf:	e9 05 ff ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  8006d4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8d 50 04             	lea    0x4(%eax),%edx
  8006dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	89 c2                	mov    %eax,%edx
  8006e4:	c1 fa 1f             	sar    $0x1f,%edx
  8006e7:	31 d0                	xor    %edx,%eax
  8006e9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006eb:	83 f8 0f             	cmp    $0xf,%eax
  8006ee:	7f 0b                	jg     8006fb <vprintfmt+0x14e>
  8006f0:	8b 14 85 40 32 80 00 	mov    0x803240(,%eax,4),%edx
  8006f7:	85 d2                	test   %edx,%edx
  8006f9:	75 20                	jne    80071b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8006fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006ff:	c7 44 24 08 b0 2f 80 	movl   $0x802fb0,0x8(%esp)
  800706:	00 
  800707:	89 74 24 04          	mov    %esi,0x4(%esp)
  80070b:	89 3c 24             	mov    %edi,(%esp)
  80070e:	e8 4e 03 00 00       	call   800a61 <printfmt>
  800713:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800716:	e9 be fe ff ff       	jmp    8005d9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80071b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80071f:	c7 44 24 08 45 34 80 	movl   $0x803445,0x8(%esp)
  800726:	00 
  800727:	89 74 24 04          	mov    %esi,0x4(%esp)
  80072b:	89 3c 24             	mov    %edi,(%esp)
  80072e:	e8 2e 03 00 00       	call   800a61 <printfmt>
  800733:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800736:	e9 9e fe ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  80073b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80073e:	89 c3                	mov    %eax,%ebx
  800740:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800746:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	8d 50 04             	lea    0x4(%eax),%edx
  80074f:	89 55 14             	mov    %edx,0x14(%ebp)
  800752:	8b 00                	mov    (%eax),%eax
  800754:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800757:	85 c0                	test   %eax,%eax
  800759:	75 07                	jne    800762 <vprintfmt+0x1b5>
  80075b:	c7 45 c4 b9 2f 80 00 	movl   $0x802fb9,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800762:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  800766:	7e 06                	jle    80076e <vprintfmt+0x1c1>
  800768:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80076c:	75 13                	jne    800781 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800771:	0f be 02             	movsbl (%edx),%eax
  800774:	85 c0                	test   %eax,%eax
  800776:	0f 85 99 00 00 00    	jne    800815 <vprintfmt+0x268>
  80077c:	e9 86 00 00 00       	jmp    800807 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800781:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800785:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800788:	89 0c 24             	mov    %ecx,(%esp)
  80078b:	e8 1b 03 00 00       	call   800aab <strnlen>
  800790:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800793:	29 c2                	sub    %eax,%edx
  800795:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800798:	85 d2                	test   %edx,%edx
  80079a:	7e d2                	jle    80076e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80079c:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  8007a0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007a3:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  8007a6:	89 d3                	mov    %edx,%ebx
  8007a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007af:	89 04 24             	mov    %eax,(%esp)
  8007b2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b4:	83 eb 01             	sub    $0x1,%ebx
  8007b7:	85 db                	test   %ebx,%ebx
  8007b9:	7f ed                	jg     8007a8 <vprintfmt+0x1fb>
  8007bb:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8007be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8007c5:	eb a7                	jmp    80076e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007c7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007cb:	74 18                	je     8007e5 <vprintfmt+0x238>
  8007cd:	8d 50 e0             	lea    -0x20(%eax),%edx
  8007d0:	83 fa 5e             	cmp    $0x5e,%edx
  8007d3:	76 10                	jbe    8007e5 <vprintfmt+0x238>
					putch('?', putdat);
  8007d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007e0:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007e3:	eb 0a                	jmp    8007ef <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8007e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e9:	89 04 24             	mov    %eax,(%esp)
  8007ec:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007ef:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8007f3:	0f be 03             	movsbl (%ebx),%eax
  8007f6:	85 c0                	test   %eax,%eax
  8007f8:	74 05                	je     8007ff <vprintfmt+0x252>
  8007fa:	83 c3 01             	add    $0x1,%ebx
  8007fd:	eb 29                	jmp    800828 <vprintfmt+0x27b>
  8007ff:	89 fe                	mov    %edi,%esi
  800801:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800804:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800807:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080b:	7f 2e                	jg     80083b <vprintfmt+0x28e>
  80080d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800810:	e9 c4 fd ff ff       	jmp    8005d9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800815:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800818:	83 c2 01             	add    $0x1,%edx
  80081b:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80081e:	89 f7                	mov    %esi,%edi
  800820:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800823:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  800826:	89 d3                	mov    %edx,%ebx
  800828:	85 f6                	test   %esi,%esi
  80082a:	78 9b                	js     8007c7 <vprintfmt+0x21a>
  80082c:	83 ee 01             	sub    $0x1,%esi
  80082f:	79 96                	jns    8007c7 <vprintfmt+0x21a>
  800831:	89 fe                	mov    %edi,%esi
  800833:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800836:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800839:	eb cc                	jmp    800807 <vprintfmt+0x25a>
  80083b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  80083e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800841:	89 74 24 04          	mov    %esi,0x4(%esp)
  800845:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80084c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80084e:	83 eb 01             	sub    $0x1,%ebx
  800851:	85 db                	test   %ebx,%ebx
  800853:	7f ec                	jg     800841 <vprintfmt+0x294>
  800855:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800858:	e9 7c fd ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  80085d:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800860:	83 f9 01             	cmp    $0x1,%ecx
  800863:	7e 16                	jle    80087b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	8d 50 08             	lea    0x8(%eax),%edx
  80086b:	89 55 14             	mov    %edx,0x14(%ebp)
  80086e:	8b 10                	mov    (%eax),%edx
  800870:	8b 48 04             	mov    0x4(%eax),%ecx
  800873:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800876:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800879:	eb 32                	jmp    8008ad <vprintfmt+0x300>
	else if (lflag)
  80087b:	85 c9                	test   %ecx,%ecx
  80087d:	74 18                	je     800897 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8d 50 04             	lea    0x4(%eax),%edx
  800885:	89 55 14             	mov    %edx,0x14(%ebp)
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80088d:	89 c1                	mov    %eax,%ecx
  80088f:	c1 f9 1f             	sar    $0x1f,%ecx
  800892:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800895:	eb 16                	jmp    8008ad <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8d 50 04             	lea    0x4(%eax),%edx
  80089d:	89 55 14             	mov    %edx,0x14(%ebp)
  8008a0:	8b 00                	mov    (%eax),%eax
  8008a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008a5:	89 c2                	mov    %eax,%edx
  8008a7:	c1 fa 1f             	sar    $0x1f,%edx
  8008aa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008ad:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8008b0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8008b3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8008b8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008bc:	0f 89 b8 00 00 00    	jns    80097a <vprintfmt+0x3cd>
				putch('-', putdat);
  8008c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008c6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008cd:	ff d7                	call   *%edi
				num = -(long long) num;
  8008cf:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8008d2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8008d5:	f7 d9                	neg    %ecx
  8008d7:	83 d3 00             	adc    $0x0,%ebx
  8008da:	f7 db                	neg    %ebx
  8008dc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e1:	e9 94 00 00 00       	jmp    80097a <vprintfmt+0x3cd>
  8008e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008e9:	89 ca                	mov    %ecx,%edx
  8008eb:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ee:	e8 63 fc ff ff       	call   800556 <getuint>
  8008f3:	89 c1                	mov    %eax,%ecx
  8008f5:	89 d3                	mov    %edx,%ebx
  8008f7:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8008fc:	eb 7c                	jmp    80097a <vprintfmt+0x3cd>
  8008fe:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800901:	89 74 24 04          	mov    %esi,0x4(%esp)
  800905:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  80090c:	ff d7                	call   *%edi
			putch('X', putdat);
  80090e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800912:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800919:	ff d7                	call   *%edi
			putch('X', putdat);
  80091b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80091f:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800926:	ff d7                	call   *%edi
  800928:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80092b:	e9 a9 fc ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  800930:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800933:	89 74 24 04          	mov    %esi,0x4(%esp)
  800937:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80093e:	ff d7                	call   *%edi
			putch('x', putdat);
  800940:	89 74 24 04          	mov    %esi,0x4(%esp)
  800944:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80094b:	ff d7                	call   *%edi
			num = (unsigned long long)
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	8d 50 04             	lea    0x4(%eax),%edx
  800953:	89 55 14             	mov    %edx,0x14(%ebp)
  800956:	8b 08                	mov    (%eax),%ecx
  800958:	bb 00 00 00 00       	mov    $0x0,%ebx
  80095d:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800962:	eb 16                	jmp    80097a <vprintfmt+0x3cd>
  800964:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800967:	89 ca                	mov    %ecx,%edx
  800969:	8d 45 14             	lea    0x14(%ebp),%eax
  80096c:	e8 e5 fb ff ff       	call   800556 <getuint>
  800971:	89 c1                	mov    %eax,%ecx
  800973:	89 d3                	mov    %edx,%ebx
  800975:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80097a:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  80097e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800982:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800985:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800989:	89 44 24 08          	mov    %eax,0x8(%esp)
  80098d:	89 0c 24             	mov    %ecx,(%esp)
  800990:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800994:	89 f2                	mov    %esi,%edx
  800996:	89 f8                	mov    %edi,%eax
  800998:	e8 c3 fa ff ff       	call   800460 <printnum>
  80099d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8009a0:	e9 34 fc ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  8009a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ab:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009af:	89 14 24             	mov    %edx,(%esp)
  8009b2:	ff d7                	call   *%edi
  8009b4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8009b7:	e9 1d fc ff ff       	jmp    8005d9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009c0:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009c7:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009c9:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8009cc:	80 38 25             	cmpb   $0x25,(%eax)
  8009cf:	0f 84 04 fc ff ff    	je     8005d9 <vprintfmt+0x2c>
  8009d5:	89 c3                	mov    %eax,%ebx
  8009d7:	eb f0                	jmp    8009c9 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  8009d9:	83 c4 5c             	add    $0x5c,%esp
  8009dc:	5b                   	pop    %ebx
  8009dd:	5e                   	pop    %esi
  8009de:	5f                   	pop    %edi
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	83 ec 28             	sub    $0x28,%esp
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8009ed:	85 c0                	test   %eax,%eax
  8009ef:	74 04                	je     8009f5 <vsnprintf+0x14>
  8009f1:	85 d2                	test   %edx,%edx
  8009f3:	7f 07                	jg     8009fc <vsnprintf+0x1b>
  8009f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009fa:	eb 3b                	jmp    800a37 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ff:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800a03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a14:	8b 45 10             	mov    0x10(%ebp),%eax
  800a17:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a1b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a22:	c7 04 24 90 05 80 00 	movl   $0x800590,(%esp)
  800a29:	e8 7f fb ff ff       	call   8005ad <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a31:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a37:	c9                   	leave  
  800a38:	c3                   	ret    

00800a39 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800a3f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800a42:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a46:	8b 45 10             	mov    0x10(%ebp),%eax
  800a49:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a50:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	89 04 24             	mov    %eax,(%esp)
  800a5a:	e8 82 ff ff ff       	call   8009e1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800a67:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800a6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a71:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a78:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	89 04 24             	mov    %eax,(%esp)
  800a82:	e8 26 fb ff ff       	call   8005ad <vprintfmt>
	va_end(ap);
}
  800a87:	c9                   	leave  
  800a88:	c3                   	ret    
  800a89:	00 00                	add    %al,(%eax)
  800a8b:	00 00                	add    %al,(%eax)
  800a8d:	00 00                	add    %al,(%eax)
	...

00800a90 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800a96:	b8 00 00 00 00       	mov    $0x0,%eax
  800a9b:	80 3a 00             	cmpb   $0x0,(%edx)
  800a9e:	74 09                	je     800aa9 <strlen+0x19>
		n++;
  800aa0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aa3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800aa7:	75 f7                	jne    800aa0 <strlen+0x10>
		n++;
	return n;
}
  800aa9:	5d                   	pop    %ebp
  800aaa:	c3                   	ret    

00800aab <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800aab:	55                   	push   %ebp
  800aac:	89 e5                	mov    %esp,%ebp
  800aae:	53                   	push   %ebx
  800aaf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ab2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ab5:	85 c9                	test   %ecx,%ecx
  800ab7:	74 19                	je     800ad2 <strnlen+0x27>
  800ab9:	80 3b 00             	cmpb   $0x0,(%ebx)
  800abc:	74 14                	je     800ad2 <strnlen+0x27>
  800abe:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800ac3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ac6:	39 c8                	cmp    %ecx,%eax
  800ac8:	74 0d                	je     800ad7 <strnlen+0x2c>
  800aca:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800ace:	75 f3                	jne    800ac3 <strnlen+0x18>
  800ad0:	eb 05                	jmp    800ad7 <strnlen+0x2c>
  800ad2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800ad7:	5b                   	pop    %ebx
  800ad8:	5d                   	pop    %ebp
  800ad9:	c3                   	ret    

00800ada <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ada:	55                   	push   %ebp
  800adb:	89 e5                	mov    %esp,%ebp
  800add:	53                   	push   %ebx
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ae4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800ae9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800aed:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800af0:	83 c2 01             	add    $0x1,%edx
  800af3:	84 c9                	test   %cl,%cl
  800af5:	75 f2                	jne    800ae9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800af7:	5b                   	pop    %ebx
  800af8:	5d                   	pop    %ebp
  800af9:	c3                   	ret    

00800afa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800afa:	55                   	push   %ebp
  800afb:	89 e5                	mov    %esp,%ebp
  800afd:	56                   	push   %esi
  800afe:	53                   	push   %ebx
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b05:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b08:	85 f6                	test   %esi,%esi
  800b0a:	74 18                	je     800b24 <strncpy+0x2a>
  800b0c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800b11:	0f b6 1a             	movzbl (%edx),%ebx
  800b14:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b17:	80 3a 01             	cmpb   $0x1,(%edx)
  800b1a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b1d:	83 c1 01             	add    $0x1,%ecx
  800b20:	39 ce                	cmp    %ecx,%esi
  800b22:	77 ed                	ja     800b11 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b24:	5b                   	pop    %ebx
  800b25:	5e                   	pop    %esi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	56                   	push   %esi
  800b2c:	53                   	push   %ebx
  800b2d:	8b 75 08             	mov    0x8(%ebp),%esi
  800b30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b33:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b36:	89 f0                	mov    %esi,%eax
  800b38:	85 c9                	test   %ecx,%ecx
  800b3a:	74 27                	je     800b63 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800b3c:	83 e9 01             	sub    $0x1,%ecx
  800b3f:	74 1d                	je     800b5e <strlcpy+0x36>
  800b41:	0f b6 1a             	movzbl (%edx),%ebx
  800b44:	84 db                	test   %bl,%bl
  800b46:	74 16                	je     800b5e <strlcpy+0x36>
			*dst++ = *src++;
  800b48:	88 18                	mov    %bl,(%eax)
  800b4a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b4d:	83 e9 01             	sub    $0x1,%ecx
  800b50:	74 0e                	je     800b60 <strlcpy+0x38>
			*dst++ = *src++;
  800b52:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b55:	0f b6 1a             	movzbl (%edx),%ebx
  800b58:	84 db                	test   %bl,%bl
  800b5a:	75 ec                	jne    800b48 <strlcpy+0x20>
  800b5c:	eb 02                	jmp    800b60 <strlcpy+0x38>
  800b5e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800b60:	c6 00 00             	movb   $0x0,(%eax)
  800b63:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800b65:	5b                   	pop    %ebx
  800b66:	5e                   	pop    %esi
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    

00800b69 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800b72:	0f b6 01             	movzbl (%ecx),%eax
  800b75:	84 c0                	test   %al,%al
  800b77:	74 15                	je     800b8e <strcmp+0x25>
  800b79:	3a 02                	cmp    (%edx),%al
  800b7b:	75 11                	jne    800b8e <strcmp+0x25>
		p++, q++;
  800b7d:	83 c1 01             	add    $0x1,%ecx
  800b80:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b83:	0f b6 01             	movzbl (%ecx),%eax
  800b86:	84 c0                	test   %al,%al
  800b88:	74 04                	je     800b8e <strcmp+0x25>
  800b8a:	3a 02                	cmp    (%edx),%al
  800b8c:	74 ef                	je     800b7d <strcmp+0x14>
  800b8e:	0f b6 c0             	movzbl %al,%eax
  800b91:	0f b6 12             	movzbl (%edx),%edx
  800b94:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    

00800b98 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800b98:	55                   	push   %ebp
  800b99:	89 e5                	mov    %esp,%ebp
  800b9b:	53                   	push   %ebx
  800b9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800ba5:	85 c0                	test   %eax,%eax
  800ba7:	74 23                	je     800bcc <strncmp+0x34>
  800ba9:	0f b6 1a             	movzbl (%edx),%ebx
  800bac:	84 db                	test   %bl,%bl
  800bae:	74 24                	je     800bd4 <strncmp+0x3c>
  800bb0:	3a 19                	cmp    (%ecx),%bl
  800bb2:	75 20                	jne    800bd4 <strncmp+0x3c>
  800bb4:	83 e8 01             	sub    $0x1,%eax
  800bb7:	74 13                	je     800bcc <strncmp+0x34>
		n--, p++, q++;
  800bb9:	83 c2 01             	add    $0x1,%edx
  800bbc:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800bbf:	0f b6 1a             	movzbl (%edx),%ebx
  800bc2:	84 db                	test   %bl,%bl
  800bc4:	74 0e                	je     800bd4 <strncmp+0x3c>
  800bc6:	3a 19                	cmp    (%ecx),%bl
  800bc8:	74 ea                	je     800bb4 <strncmp+0x1c>
  800bca:	eb 08                	jmp    800bd4 <strncmp+0x3c>
  800bcc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800bd1:	5b                   	pop    %ebx
  800bd2:	5d                   	pop    %ebp
  800bd3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800bd4:	0f b6 02             	movzbl (%edx),%eax
  800bd7:	0f b6 11             	movzbl (%ecx),%edx
  800bda:	29 d0                	sub    %edx,%eax
  800bdc:	eb f3                	jmp    800bd1 <strncmp+0x39>

00800bde <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	8b 45 08             	mov    0x8(%ebp),%eax
  800be4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800be8:	0f b6 10             	movzbl (%eax),%edx
  800beb:	84 d2                	test   %dl,%dl
  800bed:	74 15                	je     800c04 <strchr+0x26>
		if (*s == c)
  800bef:	38 ca                	cmp    %cl,%dl
  800bf1:	75 07                	jne    800bfa <strchr+0x1c>
  800bf3:	eb 14                	jmp    800c09 <strchr+0x2b>
  800bf5:	38 ca                	cmp    %cl,%dl
  800bf7:	90                   	nop
  800bf8:	74 0f                	je     800c09 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bfa:	83 c0 01             	add    $0x1,%eax
  800bfd:	0f b6 10             	movzbl (%eax),%edx
  800c00:	84 d2                	test   %dl,%dl
  800c02:	75 f1                	jne    800bf5 <strchr+0x17>
  800c04:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800c09:	5d                   	pop    %ebp
  800c0a:	c3                   	ret    

00800c0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c0b:	55                   	push   %ebp
  800c0c:	89 e5                	mov    %esp,%ebp
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c15:	0f b6 10             	movzbl (%eax),%edx
  800c18:	84 d2                	test   %dl,%dl
  800c1a:	74 18                	je     800c34 <strfind+0x29>
		if (*s == c)
  800c1c:	38 ca                	cmp    %cl,%dl
  800c1e:	75 0a                	jne    800c2a <strfind+0x1f>
  800c20:	eb 12                	jmp    800c34 <strfind+0x29>
  800c22:	38 ca                	cmp    %cl,%dl
  800c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800c28:	74 0a                	je     800c34 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c2a:	83 c0 01             	add    $0x1,%eax
  800c2d:	0f b6 10             	movzbl (%eax),%edx
  800c30:	84 d2                	test   %dl,%dl
  800c32:	75 ee                	jne    800c22 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800c34:	5d                   	pop    %ebp
  800c35:	c3                   	ret    

00800c36 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c36:	55                   	push   %ebp
  800c37:	89 e5                	mov    %esp,%ebp
  800c39:	83 ec 0c             	sub    $0xc,%esp
  800c3c:	89 1c 24             	mov    %ebx,(%esp)
  800c3f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c43:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800c47:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c50:	85 c9                	test   %ecx,%ecx
  800c52:	74 30                	je     800c84 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c54:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c5a:	75 25                	jne    800c81 <memset+0x4b>
  800c5c:	f6 c1 03             	test   $0x3,%cl
  800c5f:	75 20                	jne    800c81 <memset+0x4b>
		c &= 0xFF;
  800c61:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c64:	89 d3                	mov    %edx,%ebx
  800c66:	c1 e3 08             	shl    $0x8,%ebx
  800c69:	89 d6                	mov    %edx,%esi
  800c6b:	c1 e6 18             	shl    $0x18,%esi
  800c6e:	89 d0                	mov    %edx,%eax
  800c70:	c1 e0 10             	shl    $0x10,%eax
  800c73:	09 f0                	or     %esi,%eax
  800c75:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800c77:	09 d8                	or     %ebx,%eax
  800c79:	c1 e9 02             	shr    $0x2,%ecx
  800c7c:	fc                   	cld    
  800c7d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c7f:	eb 03                	jmp    800c84 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c81:	fc                   	cld    
  800c82:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c84:	89 f8                	mov    %edi,%eax
  800c86:	8b 1c 24             	mov    (%esp),%ebx
  800c89:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c8d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c91:	89 ec                	mov    %ebp,%esp
  800c93:	5d                   	pop    %ebp
  800c94:	c3                   	ret    

00800c95 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	83 ec 08             	sub    $0x8,%esp
  800c9b:	89 34 24             	mov    %esi,(%esp)
  800c9e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800ca8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800cab:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800cad:	39 c6                	cmp    %eax,%esi
  800caf:	73 35                	jae    800ce6 <memmove+0x51>
  800cb1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800cb4:	39 d0                	cmp    %edx,%eax
  800cb6:	73 2e                	jae    800ce6 <memmove+0x51>
		s += n;
		d += n;
  800cb8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cba:	f6 c2 03             	test   $0x3,%dl
  800cbd:	75 1b                	jne    800cda <memmove+0x45>
  800cbf:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800cc5:	75 13                	jne    800cda <memmove+0x45>
  800cc7:	f6 c1 03             	test   $0x3,%cl
  800cca:	75 0e                	jne    800cda <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800ccc:	83 ef 04             	sub    $0x4,%edi
  800ccf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cd2:	c1 e9 02             	shr    $0x2,%ecx
  800cd5:	fd                   	std    
  800cd6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cd8:	eb 09                	jmp    800ce3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800cda:	83 ef 01             	sub    $0x1,%edi
  800cdd:	8d 72 ff             	lea    -0x1(%edx),%esi
  800ce0:	fd                   	std    
  800ce1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ce3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ce4:	eb 20                	jmp    800d06 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ce6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cec:	75 15                	jne    800d03 <memmove+0x6e>
  800cee:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800cf4:	75 0d                	jne    800d03 <memmove+0x6e>
  800cf6:	f6 c1 03             	test   $0x3,%cl
  800cf9:	75 08                	jne    800d03 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800cfb:	c1 e9 02             	shr    $0x2,%ecx
  800cfe:	fc                   	cld    
  800cff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d01:	eb 03                	jmp    800d06 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d03:	fc                   	cld    
  800d04:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d06:	8b 34 24             	mov    (%esp),%esi
  800d09:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800d0d:	89 ec                	mov    %ebp,%esp
  800d0f:	5d                   	pop    %ebp
  800d10:	c3                   	ret    

00800d11 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d17:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d25:	8b 45 08             	mov    0x8(%ebp),%eax
  800d28:	89 04 24             	mov    %eax,(%esp)
  800d2b:	e8 65 ff ff ff       	call   800c95 <memmove>
}
  800d30:	c9                   	leave  
  800d31:	c3                   	ret    

00800d32 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d32:	55                   	push   %ebp
  800d33:	89 e5                	mov    %esp,%ebp
  800d35:	57                   	push   %edi
  800d36:	56                   	push   %esi
  800d37:	53                   	push   %ebx
  800d38:	8b 75 08             	mov    0x8(%ebp),%esi
  800d3b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800d3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d41:	85 c9                	test   %ecx,%ecx
  800d43:	74 36                	je     800d7b <memcmp+0x49>
		if (*s1 != *s2)
  800d45:	0f b6 06             	movzbl (%esi),%eax
  800d48:	0f b6 1f             	movzbl (%edi),%ebx
  800d4b:	38 d8                	cmp    %bl,%al
  800d4d:	74 20                	je     800d6f <memcmp+0x3d>
  800d4f:	eb 14                	jmp    800d65 <memcmp+0x33>
  800d51:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800d56:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800d5b:	83 c2 01             	add    $0x1,%edx
  800d5e:	83 e9 01             	sub    $0x1,%ecx
  800d61:	38 d8                	cmp    %bl,%al
  800d63:	74 12                	je     800d77 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800d65:	0f b6 c0             	movzbl %al,%eax
  800d68:	0f b6 db             	movzbl %bl,%ebx
  800d6b:	29 d8                	sub    %ebx,%eax
  800d6d:	eb 11                	jmp    800d80 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d6f:	83 e9 01             	sub    $0x1,%ecx
  800d72:	ba 00 00 00 00       	mov    $0x0,%edx
  800d77:	85 c9                	test   %ecx,%ecx
  800d79:	75 d6                	jne    800d51 <memcmp+0x1f>
  800d7b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800d80:	5b                   	pop    %ebx
  800d81:	5e                   	pop    %esi
  800d82:	5f                   	pop    %edi
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800d8b:	89 c2                	mov    %eax,%edx
  800d8d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d90:	39 d0                	cmp    %edx,%eax
  800d92:	73 15                	jae    800da9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d94:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800d98:	38 08                	cmp    %cl,(%eax)
  800d9a:	75 06                	jne    800da2 <memfind+0x1d>
  800d9c:	eb 0b                	jmp    800da9 <memfind+0x24>
  800d9e:	38 08                	cmp    %cl,(%eax)
  800da0:	74 07                	je     800da9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800da2:	83 c0 01             	add    $0x1,%eax
  800da5:	39 c2                	cmp    %eax,%edx
  800da7:	77 f5                	ja     800d9e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800da9:	5d                   	pop    %ebp
  800daa:	c3                   	ret    

00800dab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	57                   	push   %edi
  800daf:	56                   	push   %esi
  800db0:	53                   	push   %ebx
  800db1:	83 ec 04             	sub    $0x4,%esp
  800db4:	8b 55 08             	mov    0x8(%ebp),%edx
  800db7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dba:	0f b6 02             	movzbl (%edx),%eax
  800dbd:	3c 20                	cmp    $0x20,%al
  800dbf:	74 04                	je     800dc5 <strtol+0x1a>
  800dc1:	3c 09                	cmp    $0x9,%al
  800dc3:	75 0e                	jne    800dd3 <strtol+0x28>
		s++;
  800dc5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dc8:	0f b6 02             	movzbl (%edx),%eax
  800dcb:	3c 20                	cmp    $0x20,%al
  800dcd:	74 f6                	je     800dc5 <strtol+0x1a>
  800dcf:	3c 09                	cmp    $0x9,%al
  800dd1:	74 f2                	je     800dc5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800dd3:	3c 2b                	cmp    $0x2b,%al
  800dd5:	75 0c                	jne    800de3 <strtol+0x38>
		s++;
  800dd7:	83 c2 01             	add    $0x1,%edx
  800dda:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800de1:	eb 15                	jmp    800df8 <strtol+0x4d>
	else if (*s == '-')
  800de3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800dea:	3c 2d                	cmp    $0x2d,%al
  800dec:	75 0a                	jne    800df8 <strtol+0x4d>
		s++, neg = 1;
  800dee:	83 c2 01             	add    $0x1,%edx
  800df1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800df8:	85 db                	test   %ebx,%ebx
  800dfa:	0f 94 c0             	sete   %al
  800dfd:	74 05                	je     800e04 <strtol+0x59>
  800dff:	83 fb 10             	cmp    $0x10,%ebx
  800e02:	75 18                	jne    800e1c <strtol+0x71>
  800e04:	80 3a 30             	cmpb   $0x30,(%edx)
  800e07:	75 13                	jne    800e1c <strtol+0x71>
  800e09:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e0d:	8d 76 00             	lea    0x0(%esi),%esi
  800e10:	75 0a                	jne    800e1c <strtol+0x71>
		s += 2, base = 16;
  800e12:	83 c2 02             	add    $0x2,%edx
  800e15:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e1a:	eb 15                	jmp    800e31 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e1c:	84 c0                	test   %al,%al
  800e1e:	66 90                	xchg   %ax,%ax
  800e20:	74 0f                	je     800e31 <strtol+0x86>
  800e22:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800e27:	80 3a 30             	cmpb   $0x30,(%edx)
  800e2a:	75 05                	jne    800e31 <strtol+0x86>
		s++, base = 8;
  800e2c:	83 c2 01             	add    $0x1,%edx
  800e2f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e31:	b8 00 00 00 00       	mov    $0x0,%eax
  800e36:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e38:	0f b6 0a             	movzbl (%edx),%ecx
  800e3b:	89 cf                	mov    %ecx,%edi
  800e3d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800e40:	80 fb 09             	cmp    $0x9,%bl
  800e43:	77 08                	ja     800e4d <strtol+0xa2>
			dig = *s - '0';
  800e45:	0f be c9             	movsbl %cl,%ecx
  800e48:	83 e9 30             	sub    $0x30,%ecx
  800e4b:	eb 1e                	jmp    800e6b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800e4d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800e50:	80 fb 19             	cmp    $0x19,%bl
  800e53:	77 08                	ja     800e5d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800e55:	0f be c9             	movsbl %cl,%ecx
  800e58:	83 e9 57             	sub    $0x57,%ecx
  800e5b:	eb 0e                	jmp    800e6b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800e5d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800e60:	80 fb 19             	cmp    $0x19,%bl
  800e63:	77 15                	ja     800e7a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800e65:	0f be c9             	movsbl %cl,%ecx
  800e68:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e6b:	39 f1                	cmp    %esi,%ecx
  800e6d:	7d 0b                	jge    800e7a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800e6f:	83 c2 01             	add    $0x1,%edx
  800e72:	0f af c6             	imul   %esi,%eax
  800e75:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800e78:	eb be                	jmp    800e38 <strtol+0x8d>
  800e7a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800e7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e80:	74 05                	je     800e87 <strtol+0xdc>
		*endptr = (char *) s;
  800e82:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800e85:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800e87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800e8b:	74 04                	je     800e91 <strtol+0xe6>
  800e8d:	89 c8                	mov    %ecx,%eax
  800e8f:	f7 d8                	neg    %eax
}
  800e91:	83 c4 04             	add    $0x4,%esp
  800e94:	5b                   	pop    %ebx
  800e95:	5e                   	pop    %esi
  800e96:	5f                   	pop    %edi
  800e97:	5d                   	pop    %ebp
  800e98:	c3                   	ret    
  800e99:	00 00                	add    %al,(%eax)
	...

00800e9c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 0c             	sub    $0xc,%esp
  800ea2:	89 1c 24             	mov    %ebx,(%esp)
  800ea5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ea9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ead:	ba 00 00 00 00       	mov    $0x0,%edx
  800eb2:	b8 01 00 00 00       	mov    $0x1,%eax
  800eb7:	89 d1                	mov    %edx,%ecx
  800eb9:	89 d3                	mov    %edx,%ebx
  800ebb:	89 d7                	mov    %edx,%edi
  800ebd:	89 d6                	mov    %edx,%esi
  800ebf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ec1:	8b 1c 24             	mov    (%esp),%ebx
  800ec4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ec8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ecc:	89 ec                	mov    %ebp,%esp
  800ece:	5d                   	pop    %ebp
  800ecf:	c3                   	ret    

00800ed0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	83 ec 0c             	sub    $0xc,%esp
  800ed6:	89 1c 24             	mov    %ebx,(%esp)
  800ed9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800edd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ee6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eec:	89 c3                	mov    %eax,%ebx
  800eee:	89 c7                	mov    %eax,%edi
  800ef0:	89 c6                	mov    %eax,%esi
  800ef2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ef4:	8b 1c 24             	mov    (%esp),%ebx
  800ef7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800efb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800eff:	89 ec                	mov    %ebp,%esp
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    

00800f03 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  800f03:	55                   	push   %ebp
  800f04:	89 e5                	mov    %esp,%ebp
  800f06:	83 ec 0c             	sub    $0xc,%esp
  800f09:	89 1c 24             	mov    %ebx,(%esp)
  800f0c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f10:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f14:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f19:	b8 10 00 00 00       	mov    $0x10,%eax
  800f1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	89 df                	mov    %ebx,%edi
  800f26:	89 de                	mov    %ebx,%esi
  800f28:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800f2a:	8b 1c 24             	mov    (%esp),%ebx
  800f2d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f31:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f35:	89 ec                	mov    %ebp,%esp
  800f37:	5d                   	pop    %ebp
  800f38:	c3                   	ret    

00800f39 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	83 ec 38             	sub    $0x38,%esp
  800f3f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f42:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f45:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f48:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f4d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f55:	8b 55 08             	mov    0x8(%ebp),%edx
  800f58:	89 df                	mov    %ebx,%edi
  800f5a:	89 de                	mov    %ebx,%esi
  800f5c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f5e:	85 c0                	test   %eax,%eax
  800f60:	7e 28                	jle    800f8a <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f62:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f66:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800f6d:	00 
  800f6e:	c7 44 24 08 9f 32 80 	movl   $0x80329f,0x8(%esp)
  800f75:	00 
  800f76:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f7d:	00 
  800f7e:	c7 04 24 bc 32 80 00 	movl   $0x8032bc,(%esp)
  800f85:	e8 b2 f3 ff ff       	call   80033c <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800f8a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f8d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f90:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f93:	89 ec                	mov    %ebp,%esp
  800f95:	5d                   	pop    %ebp
  800f96:	c3                   	ret    

00800f97 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	83 ec 0c             	sub    $0xc,%esp
  800f9d:	89 1c 24             	mov    %ebx,(%esp)
  800fa0:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fa4:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa8:	ba 00 00 00 00       	mov    $0x0,%edx
  800fad:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fb2:	89 d1                	mov    %edx,%ecx
  800fb4:	89 d3                	mov    %edx,%ebx
  800fb6:	89 d7                	mov    %edx,%edi
  800fb8:	89 d6                	mov    %edx,%esi
  800fba:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fbc:	8b 1c 24             	mov    (%esp),%ebx
  800fbf:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fc3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fc7:	89 ec                	mov    %ebp,%esp
  800fc9:	5d                   	pop    %ebp
  800fca:	c3                   	ret    

00800fcb <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 38             	sub    $0x38,%esp
  800fd1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fd4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fd7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fda:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fdf:	b8 0d 00 00 00       	mov    $0xd,%eax
  800fe4:	8b 55 08             	mov    0x8(%ebp),%edx
  800fe7:	89 cb                	mov    %ecx,%ebx
  800fe9:	89 cf                	mov    %ecx,%edi
  800feb:	89 ce                	mov    %ecx,%esi
  800fed:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fef:	85 c0                	test   %eax,%eax
  800ff1:	7e 28                	jle    80101b <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff7:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ffe:	00 
  800fff:	c7 44 24 08 9f 32 80 	movl   $0x80329f,0x8(%esp)
  801006:	00 
  801007:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80100e:	00 
  80100f:	c7 04 24 bc 32 80 00 	movl   $0x8032bc,(%esp)
  801016:	e8 21 f3 ff ff       	call   80033c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80101b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80101e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801021:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801024:	89 ec                	mov    %ebp,%esp
  801026:	5d                   	pop    %ebp
  801027:	c3                   	ret    

00801028 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 0c             	sub    $0xc,%esp
  80102e:	89 1c 24             	mov    %ebx,(%esp)
  801031:	89 74 24 04          	mov    %esi,0x4(%esp)
  801035:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801039:	be 00 00 00 00       	mov    $0x0,%esi
  80103e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801043:	8b 7d 14             	mov    0x14(%ebp),%edi
  801046:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801049:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104c:	8b 55 08             	mov    0x8(%ebp),%edx
  80104f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801051:	8b 1c 24             	mov    (%esp),%ebx
  801054:	8b 74 24 04          	mov    0x4(%esp),%esi
  801058:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80105c:	89 ec                	mov    %ebp,%esp
  80105e:	5d                   	pop    %ebp
  80105f:	c3                   	ret    

00801060 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801060:	55                   	push   %ebp
  801061:	89 e5                	mov    %esp,%ebp
  801063:	83 ec 38             	sub    $0x38,%esp
  801066:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801069:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80106c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801074:	b8 0a 00 00 00       	mov    $0xa,%eax
  801079:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107c:	8b 55 08             	mov    0x8(%ebp),%edx
  80107f:	89 df                	mov    %ebx,%edi
  801081:	89 de                	mov    %ebx,%esi
  801083:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801085:	85 c0                	test   %eax,%eax
  801087:	7e 28                	jle    8010b1 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801089:	89 44 24 10          	mov    %eax,0x10(%esp)
  80108d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801094:	00 
  801095:	c7 44 24 08 9f 32 80 	movl   $0x80329f,0x8(%esp)
  80109c:	00 
  80109d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010a4:	00 
  8010a5:	c7 04 24 bc 32 80 00 	movl   $0x8032bc,(%esp)
  8010ac:	e8 8b f2 ff ff       	call   80033c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010b1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010b4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010b7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010ba:	89 ec                	mov    %ebp,%esp
  8010bc:	5d                   	pop    %ebp
  8010bd:	c3                   	ret    

008010be <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010be:	55                   	push   %ebp
  8010bf:	89 e5                	mov    %esp,%ebp
  8010c1:	83 ec 38             	sub    $0x38,%esp
  8010c4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010c7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010ca:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010d2:	b8 09 00 00 00       	mov    $0x9,%eax
  8010d7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010da:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dd:	89 df                	mov    %ebx,%edi
  8010df:	89 de                	mov    %ebx,%esi
  8010e1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	7e 28                	jle    80110f <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010eb:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8010f2:	00 
  8010f3:	c7 44 24 08 9f 32 80 	movl   $0x80329f,0x8(%esp)
  8010fa:	00 
  8010fb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801102:	00 
  801103:	c7 04 24 bc 32 80 00 	movl   $0x8032bc,(%esp)
  80110a:	e8 2d f2 ff ff       	call   80033c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80110f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801112:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801115:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801118:	89 ec                	mov    %ebp,%esp
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    

0080111c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
  80111f:	83 ec 38             	sub    $0x38,%esp
  801122:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801125:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801128:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80112b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801130:	b8 08 00 00 00       	mov    $0x8,%eax
  801135:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801138:	8b 55 08             	mov    0x8(%ebp),%edx
  80113b:	89 df                	mov    %ebx,%edi
  80113d:	89 de                	mov    %ebx,%esi
  80113f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801141:	85 c0                	test   %eax,%eax
  801143:	7e 28                	jle    80116d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801145:	89 44 24 10          	mov    %eax,0x10(%esp)
  801149:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801150:	00 
  801151:	c7 44 24 08 9f 32 80 	movl   $0x80329f,0x8(%esp)
  801158:	00 
  801159:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801160:	00 
  801161:	c7 04 24 bc 32 80 00 	movl   $0x8032bc,(%esp)
  801168:	e8 cf f1 ff ff       	call   80033c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80116d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801170:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801173:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801176:	89 ec                	mov    %ebp,%esp
  801178:	5d                   	pop    %ebp
  801179:	c3                   	ret    

0080117a <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80117a:	55                   	push   %ebp
  80117b:	89 e5                	mov    %esp,%ebp
  80117d:	83 ec 38             	sub    $0x38,%esp
  801180:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801183:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801186:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801189:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118e:	b8 06 00 00 00       	mov    $0x6,%eax
  801193:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801196:	8b 55 08             	mov    0x8(%ebp),%edx
  801199:	89 df                	mov    %ebx,%edi
  80119b:	89 de                	mov    %ebx,%esi
  80119d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80119f:	85 c0                	test   %eax,%eax
  8011a1:	7e 28                	jle    8011cb <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011a3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011a7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8011ae:	00 
  8011af:	c7 44 24 08 9f 32 80 	movl   $0x80329f,0x8(%esp)
  8011b6:	00 
  8011b7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011be:	00 
  8011bf:	c7 04 24 bc 32 80 00 	movl   $0x8032bc,(%esp)
  8011c6:	e8 71 f1 ff ff       	call   80033c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011cb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011ce:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011d1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011d4:	89 ec                	mov    %ebp,%esp
  8011d6:	5d                   	pop    %ebp
  8011d7:	c3                   	ret    

008011d8 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011d8:	55                   	push   %ebp
  8011d9:	89 e5                	mov    %esp,%ebp
  8011db:	83 ec 38             	sub    $0x38,%esp
  8011de:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011e1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011e4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e7:	b8 05 00 00 00       	mov    $0x5,%eax
  8011ec:	8b 75 18             	mov    0x18(%ebp),%esi
  8011ef:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011fd:	85 c0                	test   %eax,%eax
  8011ff:	7e 28                	jle    801229 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801201:	89 44 24 10          	mov    %eax,0x10(%esp)
  801205:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80120c:	00 
  80120d:	c7 44 24 08 9f 32 80 	movl   $0x80329f,0x8(%esp)
  801214:	00 
  801215:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80121c:	00 
  80121d:	c7 04 24 bc 32 80 00 	movl   $0x8032bc,(%esp)
  801224:	e8 13 f1 ff ff       	call   80033c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801229:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80122c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80122f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801232:	89 ec                	mov    %ebp,%esp
  801234:	5d                   	pop    %ebp
  801235:	c3                   	ret    

00801236 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801236:	55                   	push   %ebp
  801237:	89 e5                	mov    %esp,%ebp
  801239:	83 ec 38             	sub    $0x38,%esp
  80123c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80123f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801242:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801245:	be 00 00 00 00       	mov    $0x0,%esi
  80124a:	b8 04 00 00 00       	mov    $0x4,%eax
  80124f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801252:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801255:	8b 55 08             	mov    0x8(%ebp),%edx
  801258:	89 f7                	mov    %esi,%edi
  80125a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80125c:	85 c0                	test   %eax,%eax
  80125e:	7e 28                	jle    801288 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801260:	89 44 24 10          	mov    %eax,0x10(%esp)
  801264:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80126b:	00 
  80126c:	c7 44 24 08 9f 32 80 	movl   $0x80329f,0x8(%esp)
  801273:	00 
  801274:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80127b:	00 
  80127c:	c7 04 24 bc 32 80 00 	movl   $0x8032bc,(%esp)
  801283:	e8 b4 f0 ff ff       	call   80033c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801288:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80128b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80128e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801291:	89 ec                	mov    %ebp,%esp
  801293:	5d                   	pop    %ebp
  801294:	c3                   	ret    

00801295 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	83 ec 0c             	sub    $0xc,%esp
  80129b:	89 1c 24             	mov    %ebx,(%esp)
  80129e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012a2:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8012ab:	b8 0b 00 00 00       	mov    $0xb,%eax
  8012b0:	89 d1                	mov    %edx,%ecx
  8012b2:	89 d3                	mov    %edx,%ebx
  8012b4:	89 d7                	mov    %edx,%edi
  8012b6:	89 d6                	mov    %edx,%esi
  8012b8:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8012ba:	8b 1c 24             	mov    (%esp),%ebx
  8012bd:	8b 74 24 04          	mov    0x4(%esp),%esi
  8012c1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8012c5:	89 ec                	mov    %ebp,%esp
  8012c7:	5d                   	pop    %ebp
  8012c8:	c3                   	ret    

008012c9 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
  8012cc:	83 ec 0c             	sub    $0xc,%esp
  8012cf:	89 1c 24             	mov    %ebx,(%esp)
  8012d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012d6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012da:	ba 00 00 00 00       	mov    $0x0,%edx
  8012df:	b8 02 00 00 00       	mov    $0x2,%eax
  8012e4:	89 d1                	mov    %edx,%ecx
  8012e6:	89 d3                	mov    %edx,%ebx
  8012e8:	89 d7                	mov    %edx,%edi
  8012ea:	89 d6                	mov    %edx,%esi
  8012ec:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8012ee:	8b 1c 24             	mov    (%esp),%ebx
  8012f1:	8b 74 24 04          	mov    0x4(%esp),%esi
  8012f5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8012f9:	89 ec                	mov    %ebp,%esp
  8012fb:	5d                   	pop    %ebp
  8012fc:	c3                   	ret    

008012fd <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
  801300:	83 ec 38             	sub    $0x38,%esp
  801303:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801306:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801309:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80130c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801311:	b8 03 00 00 00       	mov    $0x3,%eax
  801316:	8b 55 08             	mov    0x8(%ebp),%edx
  801319:	89 cb                	mov    %ecx,%ebx
  80131b:	89 cf                	mov    %ecx,%edi
  80131d:	89 ce                	mov    %ecx,%esi
  80131f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801321:	85 c0                	test   %eax,%eax
  801323:	7e 28                	jle    80134d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801325:	89 44 24 10          	mov    %eax,0x10(%esp)
  801329:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801330:	00 
  801331:	c7 44 24 08 9f 32 80 	movl   $0x80329f,0x8(%esp)
  801338:	00 
  801339:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801340:	00 
  801341:	c7 04 24 bc 32 80 00 	movl   $0x8032bc,(%esp)
  801348:	e8 ef ef ff ff       	call   80033c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80134d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801350:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801353:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801356:	89 ec                	mov    %ebp,%esp
  801358:	5d                   	pop    %ebp
  801359:	c3                   	ret    
	...

0080135c <sfork>:
}

// Challenge!
int
sfork(void)
{
  80135c:	55                   	push   %ebp
  80135d:	89 e5                	mov    %esp,%ebp
  80135f:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801362:	c7 44 24 08 ca 32 80 	movl   $0x8032ca,0x8(%esp)
  801369:	00 
  80136a:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  801371:	00 
  801372:	c7 04 24 e0 32 80 00 	movl   $0x8032e0,(%esp)
  801379:	e8 be ef ff ff       	call   80033c <_panic>

0080137e <duppage>:
// It is also OK to panic on error.
// 

static int
duppage(envid_t envid, unsigned pn)
{
  80137e:	55                   	push   %ebp
  80137f:	89 e5                	mov    %esp,%ebp
  801381:	83 ec 28             	sub    $0x28,%esp
  801384:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801387:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80138a:	89 c3                	mov    %eax,%ebx
	int r;

	// LAB 4: Your code here.
     pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  80138c:	89 d6                	mov    %edx,%esi
  80138e:	c1 e6 0c             	shl    $0xc,%esi
  801391:	89 f0                	mov    %esi,%eax
  801393:	c1 e8 16             	shr    $0x16,%eax
  801396:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
       
        if( 0 == pgDirEntry )
  80139d:	85 c0                	test   %eax,%eax
  80139f:	0f 84 fc 00 00 00    	je     8014a1 <duppage+0x123>
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  8013a5:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8013ac:	89 c2                	mov    %eax,%edx
  8013ae:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        //cprintf("Below %d",vpt[pn]);
                //if(perm!=0)  //commented nw.
                   // cprintf("perm bit %d",perm);
	
	
	if((perm & PTE_W) && (perm & PTE_SHARE))
  8013b4:	25 02 04 00 00       	and    $0x402,%eax
  8013b9:	3d 02 04 00 00       	cmp    $0x402,%eax
  8013be:	75 4d                	jne    80140d <duppage+0x8f>
	{	
		if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_SHARE|(perm & PTE_USER))) < 0)
  8013c0:	81 e2 07 0a 00 00    	and    $0xa07,%edx
  8013c6:	80 ce 04             	or     $0x4,%dh
  8013c9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013cd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8013d1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8013d5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013e0:	e8 f3 fd ff ff       	call   8011d8 <sys_page_map>
  8013e5:	85 c0                	test   %eax,%eax
  8013e7:	0f 89 bb 00 00 00    	jns    8014a8 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  8013ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013f1:	c7 44 24 08 eb 32 80 	movl   $0x8032eb,0x8(%esp)
  8013f8:	00 
  8013f9:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  801400:	00 
  801401:	c7 04 24 e0 32 80 00 	movl   $0x8032e0,(%esp)
  801408:	e8 2f ef ff ff       	call   80033c <_panic>
	}	


        else if((perm & PTE_W)!=0 || (perm & PTE_COW)!=0)
  80140d:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801413:	0f 84 8f 00 00 00    	je     8014a8 <duppage+0x12a>
         {
          //cprintf("\nInside Setting Cow\n"); 
        if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  801419:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801420:	00 
  801421:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801425:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801429:	89 74 24 04          	mov    %esi,0x4(%esp)
  80142d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801434:	e8 9f fd ff ff       	call   8011d8 <sys_page_map>
  801439:	85 c0                	test   %eax,%eax
  80143b:	79 20                	jns    80145d <duppage+0xdf>
                panic("sys_page_map: %e", r);
  80143d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801441:	c7 44 24 08 eb 32 80 	movl   $0x8032eb,0x8(%esp)
  801448:	00 
  801449:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801450:	00 
  801451:	c7 04 24 e0 32 80 00 	movl   $0x8032e0,(%esp)
  801458:	e8 df ee ff ff       	call   80033c <_panic>
        if ((r = sys_page_map(envid,(void *)(pn*PGSIZE),0,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  80145d:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801464:	00 
  801465:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801469:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801470:	00 
  801471:	89 74 24 04          	mov    %esi,0x4(%esp)
  801475:	89 1c 24             	mov    %ebx,(%esp)
  801478:	e8 5b fd ff ff       	call   8011d8 <sys_page_map>
  80147d:	85 c0                	test   %eax,%eax
  80147f:	79 27                	jns    8014a8 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  801481:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801485:	c7 44 24 08 eb 32 80 	movl   $0x8032eb,0x8(%esp)
  80148c:	00 
  80148d:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801494:	00 
  801495:	c7 04 24 e0 32 80 00 	movl   $0x8032e0,(%esp)
  80149c:	e8 9b ee ff ff       	call   80033c <_panic>
  8014a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8014a6:	eb 05                	jmp    8014ad <duppage+0x12f>
  8014a8:	b8 00 00 00 00       	mov    $0x0,%eax
         }


//	panic("duppage not implemented");
	return 0;
}
  8014ad:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8014b0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8014b3:	89 ec                	mov    %ebp,%esp
  8014b5:	5d                   	pop    %ebp
  8014b6:	c3                   	ret    

008014b7 <fork>:
//


envid_t
fork(void)
{
  8014b7:	55                   	push   %ebp
  8014b8:	89 e5                	mov    %esp,%ebp
  8014ba:	56                   	push   %esi
  8014bb:	53                   	push   %ebx
  8014bc:	83 ec 10             	sub    $0x10,%esp

        envid_t envid;
        uint8_t *addr;
        int r;
        extern unsigned char end[];
        set_pgfault_handler(pgfault);
  8014bf:	c7 04 24 ce 15 80 00 	movl   $0x8015ce,(%esp)
  8014c6:	e8 c1 15 00 00       	call   802a8c <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8014cb:	be 07 00 00 00       	mov    $0x7,%esi
  8014d0:	89 f0                	mov    %esi,%eax
  8014d2:	cd 30                	int    $0x30
  8014d4:	89 c6                	mov    %eax,%esi

        envid = sys_exofork();
        if (envid < 0)
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	79 20                	jns    8014fa <fork+0x43>
                panic("sys_exofork: %e", envid);
  8014da:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014de:	c7 44 24 08 fc 32 80 	movl   $0x8032fc,0x8(%esp)
  8014e5:	00 
  8014e6:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  8014ed:	00 
  8014ee:	c7 04 24 e0 32 80 00 	movl   $0x8032e0,(%esp)
  8014f5:	e8 42 ee ff ff       	call   80033c <_panic>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
  8014fa:	bb 00 00 80 00       	mov    $0x800000,%ebx
        set_pgfault_handler(pgfault);

        envid = sys_exofork();
        if (envid < 0)
                panic("sys_exofork: %e", envid);
        if (envid == 0) {
  8014ff:	85 c0                	test   %eax,%eax
  801501:	75 1c                	jne    80151f <fork+0x68>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
  801503:	e8 c1 fd ff ff       	call   8012c9 <sys_getenvid>
  801508:	25 ff 03 00 00       	and    $0x3ff,%eax
  80150d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801510:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801515:	a3 74 70 80 00       	mov    %eax,0x807074
                return 0;
  80151a:	e9 a6 00 00 00       	jmp    8015c5 <fork+0x10e>
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
  80151f:	89 da                	mov    %ebx,%edx
  801521:	c1 ea 0c             	shr    $0xc,%edx
  801524:	89 f0                	mov    %esi,%eax
  801526:	e8 53 fe ff ff       	call   80137e <duppage>
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
  80152b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801531:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801537:	75 e6                	jne    80151f <fork+0x68>
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
                }
              duppage(envid,VPN(USTACKTOP-PGSIZE));
  801539:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80153e:	89 f0                	mov    %esi,%eax
  801540:	e8 39 fe ff ff       	call   80137e <duppage>
        // Also copy the stack we are currently running on.
       //if(sys_page_alloc(envid, (void *)(ROUNDDOWN(&addr, PGSIZE)),PTE_U|PTE_P|PTE_W)<0)
         //                      panic("stack not allocated");
     
   
     sys_env_set_pgfault_upcall(envid,env->env_pgfault_upcall);
  801545:	a1 74 70 80 00       	mov    0x807074,%eax
  80154a:	8b 40 64             	mov    0x64(%eax),%eax
  80154d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801551:	89 34 24             	mov    %esi,(%esp)
  801554:	e8 07 fb ff ff       	call   801060 <sys_env_set_pgfault_upcall>

     if(sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  801559:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801560:	00 
  801561:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801568:	ee 
  801569:	89 34 24             	mov    %esi,(%esp)
  80156c:	e8 c5 fc ff ff       	call   801236 <sys_page_alloc>
  801571:	85 c0                	test   %eax,%eax
  801573:	79 1c                	jns    801591 <fork+0xda>
                          panic("Cant allocate Page");
  801575:	c7 44 24 08 0c 33 80 	movl   $0x80330c,0x8(%esp)
  80157c:	00 
  80157d:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  801584:	00 
  801585:	c7 04 24 e0 32 80 00 	movl   $0x8032e0,(%esp)
  80158c:	e8 ab ed ff ff       	call   80033c <_panic>

        // Start the child environment running
        if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801591:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801598:	00 
  801599:	89 34 24             	mov    %esi,(%esp)
  80159c:	e8 7b fb ff ff       	call   80111c <sys_env_set_status>
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	79 20                	jns    8015c5 <fork+0x10e>
                panic("sys_env_set_status: %e", r);
  8015a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015a9:	c7 44 24 08 1f 33 80 	movl   $0x80331f,0x8(%esp)
  8015b0:	00 
  8015b1:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  8015b8:	00 
  8015b9:	c7 04 24 e0 32 80 00 	movl   $0x8032e0,(%esp)
  8015c0:	e8 77 ed ff ff       	call   80033c <_panic>
         return envid;
           
//panic("fork not implemented");
}
  8015c5:	89 f0                	mov    %esi,%eax
  8015c7:	83 c4 10             	add    $0x10,%esp
  8015ca:	5b                   	pop    %ebx
  8015cb:	5e                   	pop    %esi
  8015cc:	5d                   	pop    %ebp
  8015cd:	c3                   	ret    

008015ce <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  8015ce:	55                   	push   %ebp
  8015cf:	89 e5                	mov    %esp,%ebp
  8015d1:	53                   	push   %ebx
  8015d2:	83 ec 24             	sub    $0x24,%esp
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8015d8:	8b 18                	mov    (%eax),%ebx
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).
 
         int perm = vpt[VPN(addr)] & 0xFFF;
  8015da:	89 da                	mov    %ebx,%edx
  8015dc:	c1 ea 0c             	shr    $0xc,%edx
  8015df:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx

static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
  8015e6:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8015ea:	74 21                	je     80160d <pgfault+0x3f>
 
         int perm = vpt[VPN(addr)] & 0xFFF;
        if((err & FEC_WR)!=0)
           {
//              cprintf("\n>>>>>Due to write\n");
            if((perm & PTE_COW) == 0)
  8015ec:	f6 c6 08             	test   $0x8,%dh
  8015ef:	75 1c                	jne    80160d <pgfault+0x3f>
             {
                   panic("Not Set Cow");
  8015f1:	c7 44 24 08 36 33 80 	movl   $0x803336,0x8(%esp)
  8015f8:	00 
  8015f9:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801600:	00 
  801601:	c7 04 24 e0 32 80 00 	movl   $0x8032e0,(%esp)
  801608:	e8 2f ed ff ff       	call   80033c <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
        if(sys_page_alloc(0,PFTEMP,PTE_P|PTE_U|PTE_W)<0)
  80160d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801614:	00 
  801615:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80161c:	00 
  80161d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801624:	e8 0d fc ff ff       	call   801236 <sys_page_alloc>
  801629:	85 c0                	test   %eax,%eax
  80162b:	79 1c                	jns    801649 <pgfault+0x7b>
              panic("\nPage not allocated\n");
  80162d:	c7 44 24 08 42 33 80 	movl   $0x803342,0x8(%esp)
  801634:	00 
  801635:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  80163c:	00 
  80163d:	c7 04 24 e0 32 80 00 	movl   $0x8032e0,(%esp)
  801644:	e8 f3 ec ff ff       	call   80033c <_panic>
           memmove(PFTEMP,ROUNDDOWN(addr,PGSIZE),PGSIZE);
  801649:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80164f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801656:	00 
  801657:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80165b:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801662:	e8 2e f6 ff ff       	call   800c95 <memmove>
          if(sys_page_map(0,ROUNDDOWN(PFTEMP,PGSIZE),0,ROUNDDOWN(addr,PGSIZE),PTE_U|PTE_P|PTE_W)<0)
  801667:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80166e:	00 
  80166f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801673:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80167a:	00 
  80167b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801682:	00 
  801683:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80168a:	e8 49 fb ff ff       	call   8011d8 <sys_page_map>
  80168f:	85 c0                	test   %eax,%eax
  801691:	79 1c                	jns    8016af <pgfault+0xe1>
                   panic("not mapped properly");
  801693:	c7 44 24 08 57 33 80 	movl   $0x803357,0x8(%esp)
  80169a:	00 
  80169b:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8016a2:	00 
  8016a3:	c7 04 24 e0 32 80 00 	movl   $0x8032e0,(%esp)
  8016aa:	e8 8d ec ff ff       	call   80033c <_panic>
         if( 0 > sys_page_unmap(0, PFTEMP) )
  8016af:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8016b6:	00 
  8016b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016be:	e8 b7 fa ff ff       	call   80117a <sys_page_unmap>
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	79 1c                	jns    8016e3 <pgfault+0x115>
                panic("sys_page_unmap failed\n");
  8016c7:	c7 44 24 08 6b 33 80 	movl   $0x80336b,0x8(%esp)
  8016ce:	00 
  8016cf:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  8016d6:	00 
  8016d7:	c7 04 24 e0 32 80 00 	movl   $0x8032e0,(%esp)
  8016de:	e8 59 ec ff ff       	call   80033c <_panic>
   
//	panic("pgfault not implemented");
}
  8016e3:	83 c4 24             	add    $0x24,%esp
  8016e6:	5b                   	pop    %ebx
  8016e7:	5d                   	pop    %ebp
  8016e8:	c3                   	ret    
  8016e9:	00 00                	add    %al,(%eax)
  8016eb:	00 00                	add    %al,(%eax)
  8016ed:	00 00                	add    %al,(%eax)
	...

008016f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8016f0:	55                   	push   %ebp
  8016f1:	89 e5                	mov    %esp,%ebp
  8016f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8016fb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8016fe:	5d                   	pop    %ebp
  8016ff:	c3                   	ret    

00801700 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801700:	55                   	push   %ebp
  801701:	89 e5                	mov    %esp,%ebp
  801703:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	89 04 24             	mov    %eax,(%esp)
  80170c:	e8 df ff ff ff       	call   8016f0 <fd2num>
  801711:	05 20 00 0d 00       	add    $0xd0020,%eax
  801716:	c1 e0 0c             	shl    $0xc,%eax
}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
  80171e:	57                   	push   %edi
  80171f:	56                   	push   %esi
  801720:	53                   	push   %ebx
  801721:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801724:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801729:	a8 01                	test   $0x1,%al
  80172b:	74 36                	je     801763 <fd_alloc+0x48>
  80172d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801732:	a8 01                	test   $0x1,%al
  801734:	74 2d                	je     801763 <fd_alloc+0x48>
  801736:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80173b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801740:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801745:	89 c3                	mov    %eax,%ebx
  801747:	89 c2                	mov    %eax,%edx
  801749:	c1 ea 16             	shr    $0x16,%edx
  80174c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80174f:	f6 c2 01             	test   $0x1,%dl
  801752:	74 14                	je     801768 <fd_alloc+0x4d>
  801754:	89 c2                	mov    %eax,%edx
  801756:	c1 ea 0c             	shr    $0xc,%edx
  801759:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80175c:	f6 c2 01             	test   $0x1,%dl
  80175f:	75 10                	jne    801771 <fd_alloc+0x56>
  801761:	eb 05                	jmp    801768 <fd_alloc+0x4d>
  801763:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801768:	89 1f                	mov    %ebx,(%edi)
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80176f:	eb 17                	jmp    801788 <fd_alloc+0x6d>
  801771:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801776:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80177b:	75 c8                	jne    801745 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80177d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801783:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801788:	5b                   	pop    %ebx
  801789:	5e                   	pop    %esi
  80178a:	5f                   	pop    %edi
  80178b:	5d                   	pop    %ebp
  80178c:	c3                   	ret    

0080178d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801790:	8b 45 08             	mov    0x8(%ebp),%eax
  801793:	83 f8 1f             	cmp    $0x1f,%eax
  801796:	77 36                	ja     8017ce <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801798:	05 00 00 0d 00       	add    $0xd0000,%eax
  80179d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8017a0:	89 c2                	mov    %eax,%edx
  8017a2:	c1 ea 16             	shr    $0x16,%edx
  8017a5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017ac:	f6 c2 01             	test   $0x1,%dl
  8017af:	74 1d                	je     8017ce <fd_lookup+0x41>
  8017b1:	89 c2                	mov    %eax,%edx
  8017b3:	c1 ea 0c             	shr    $0xc,%edx
  8017b6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017bd:	f6 c2 01             	test   $0x1,%dl
  8017c0:	74 0c                	je     8017ce <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8017c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017c5:	89 02                	mov    %eax,(%edx)
  8017c7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8017cc:	eb 05                	jmp    8017d3 <fd_lookup+0x46>
  8017ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8017d3:	5d                   	pop    %ebp
  8017d4:	c3                   	ret    

008017d5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8017d5:	55                   	push   %ebp
  8017d6:	89 e5                	mov    %esp,%ebp
  8017d8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017db:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	89 04 24             	mov    %eax,(%esp)
  8017e8:	e8 a0 ff ff ff       	call   80178d <fd_lookup>
  8017ed:	85 c0                	test   %eax,%eax
  8017ef:	78 0e                	js     8017ff <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8017f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017f7:	89 50 04             	mov    %edx,0x4(%eax)
  8017fa:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8017ff:	c9                   	leave  
  801800:	c3                   	ret    

00801801 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801801:	55                   	push   %ebp
  801802:	89 e5                	mov    %esp,%ebp
  801804:	56                   	push   %esi
  801805:	53                   	push   %ebx
  801806:	83 ec 10             	sub    $0x10,%esp
  801809:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80180c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80180f:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801814:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801819:	be 04 34 80 00       	mov    $0x803404,%esi
		if (devtab[i]->dev_id == dev_id) {
  80181e:	39 08                	cmp    %ecx,(%eax)
  801820:	75 10                	jne    801832 <dev_lookup+0x31>
  801822:	eb 04                	jmp    801828 <dev_lookup+0x27>
  801824:	39 08                	cmp    %ecx,(%eax)
  801826:	75 0a                	jne    801832 <dev_lookup+0x31>
			*dev = devtab[i];
  801828:	89 03                	mov    %eax,(%ebx)
  80182a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80182f:	90                   	nop
  801830:	eb 31                	jmp    801863 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801832:	83 c2 01             	add    $0x1,%edx
  801835:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801838:	85 c0                	test   %eax,%eax
  80183a:	75 e8                	jne    801824 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80183c:	a1 74 70 80 00       	mov    0x807074,%eax
  801841:	8b 40 4c             	mov    0x4c(%eax),%eax
  801844:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801848:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184c:	c7 04 24 84 33 80 00 	movl   $0x803384,(%esp)
  801853:	e8 a9 eb ff ff       	call   800401 <cprintf>
	*dev = 0;
  801858:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80185e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801863:	83 c4 10             	add    $0x10,%esp
  801866:	5b                   	pop    %ebx
  801867:	5e                   	pop    %esi
  801868:	5d                   	pop    %ebp
  801869:	c3                   	ret    

0080186a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	53                   	push   %ebx
  80186e:	83 ec 24             	sub    $0x24,%esp
  801871:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801874:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801877:	89 44 24 04          	mov    %eax,0x4(%esp)
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	89 04 24             	mov    %eax,(%esp)
  801881:	e8 07 ff ff ff       	call   80178d <fd_lookup>
  801886:	85 c0                	test   %eax,%eax
  801888:	78 53                	js     8018dd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80188a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801891:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801894:	8b 00                	mov    (%eax),%eax
  801896:	89 04 24             	mov    %eax,(%esp)
  801899:	e8 63 ff ff ff       	call   801801 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80189e:	85 c0                	test   %eax,%eax
  8018a0:	78 3b                	js     8018dd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8018a2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018aa:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8018ae:	74 2d                	je     8018dd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018b0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018b3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018ba:	00 00 00 
	stat->st_isdir = 0;
  8018bd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018c4:	00 00 00 
	stat->st_dev = dev;
  8018c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ca:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8018d7:	89 14 24             	mov    %edx,(%esp)
  8018da:	ff 50 14             	call   *0x14(%eax)
}
  8018dd:	83 c4 24             	add    $0x24,%esp
  8018e0:	5b                   	pop    %ebx
  8018e1:	5d                   	pop    %ebp
  8018e2:	c3                   	ret    

008018e3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	53                   	push   %ebx
  8018e7:	83 ec 24             	sub    $0x24,%esp
  8018ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f4:	89 1c 24             	mov    %ebx,(%esp)
  8018f7:	e8 91 fe ff ff       	call   80178d <fd_lookup>
  8018fc:	85 c0                	test   %eax,%eax
  8018fe:	78 5f                	js     80195f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801900:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801903:	89 44 24 04          	mov    %eax,0x4(%esp)
  801907:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80190a:	8b 00                	mov    (%eax),%eax
  80190c:	89 04 24             	mov    %eax,(%esp)
  80190f:	e8 ed fe ff ff       	call   801801 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801914:	85 c0                	test   %eax,%eax
  801916:	78 47                	js     80195f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801918:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80191b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80191f:	75 23                	jne    801944 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801921:	a1 74 70 80 00       	mov    0x807074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801926:	8b 40 4c             	mov    0x4c(%eax),%eax
  801929:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80192d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801931:	c7 04 24 a4 33 80 00 	movl   $0x8033a4,(%esp)
  801938:	e8 c4 ea ff ff       	call   800401 <cprintf>
  80193d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801942:	eb 1b                	jmp    80195f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801947:	8b 48 18             	mov    0x18(%eax),%ecx
  80194a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80194f:	85 c9                	test   %ecx,%ecx
  801951:	74 0c                	je     80195f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801953:	8b 45 0c             	mov    0xc(%ebp),%eax
  801956:	89 44 24 04          	mov    %eax,0x4(%esp)
  80195a:	89 14 24             	mov    %edx,(%esp)
  80195d:	ff d1                	call   *%ecx
}
  80195f:	83 c4 24             	add    $0x24,%esp
  801962:	5b                   	pop    %ebx
  801963:	5d                   	pop    %ebp
  801964:	c3                   	ret    

00801965 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	53                   	push   %ebx
  801969:	83 ec 24             	sub    $0x24,%esp
  80196c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80196f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801972:	89 44 24 04          	mov    %eax,0x4(%esp)
  801976:	89 1c 24             	mov    %ebx,(%esp)
  801979:	e8 0f fe ff ff       	call   80178d <fd_lookup>
  80197e:	85 c0                	test   %eax,%eax
  801980:	78 66                	js     8019e8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801982:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801985:	89 44 24 04          	mov    %eax,0x4(%esp)
  801989:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198c:	8b 00                	mov    (%eax),%eax
  80198e:	89 04 24             	mov    %eax,(%esp)
  801991:	e8 6b fe ff ff       	call   801801 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801996:	85 c0                	test   %eax,%eax
  801998:	78 4e                	js     8019e8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80199a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80199d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8019a1:	75 23                	jne    8019c6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8019a3:	a1 74 70 80 00       	mov    0x807074,%eax
  8019a8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8019ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b3:	c7 04 24 c8 33 80 00 	movl   $0x8033c8,(%esp)
  8019ba:	e8 42 ea ff ff       	call   800401 <cprintf>
  8019bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8019c4:	eb 22                	jmp    8019e8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8019c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8019cc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019d1:	85 c9                	test   %ecx,%ecx
  8019d3:	74 13                	je     8019e8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8019d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019e3:	89 14 24             	mov    %edx,(%esp)
  8019e6:	ff d1                	call   *%ecx
}
  8019e8:	83 c4 24             	add    $0x24,%esp
  8019eb:	5b                   	pop    %ebx
  8019ec:	5d                   	pop    %ebp
  8019ed:	c3                   	ret    

008019ee <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	53                   	push   %ebx
  8019f2:	83 ec 24             	sub    $0x24,%esp
  8019f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ff:	89 1c 24             	mov    %ebx,(%esp)
  801a02:	e8 86 fd ff ff       	call   80178d <fd_lookup>
  801a07:	85 c0                	test   %eax,%eax
  801a09:	78 6b                	js     801a76 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a15:	8b 00                	mov    (%eax),%eax
  801a17:	89 04 24             	mov    %eax,(%esp)
  801a1a:	e8 e2 fd ff ff       	call   801801 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a1f:	85 c0                	test   %eax,%eax
  801a21:	78 53                	js     801a76 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a26:	8b 42 08             	mov    0x8(%edx),%eax
  801a29:	83 e0 03             	and    $0x3,%eax
  801a2c:	83 f8 01             	cmp    $0x1,%eax
  801a2f:	75 23                	jne    801a54 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801a31:	a1 74 70 80 00       	mov    0x807074,%eax
  801a36:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a39:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a41:	c7 04 24 e5 33 80 00 	movl   $0x8033e5,(%esp)
  801a48:	e8 b4 e9 ff ff       	call   800401 <cprintf>
  801a4d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801a52:	eb 22                	jmp    801a76 <read+0x88>
	}
	if (!dev->dev_read)
  801a54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a57:	8b 48 08             	mov    0x8(%eax),%ecx
  801a5a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a5f:	85 c9                	test   %ecx,%ecx
  801a61:	74 13                	je     801a76 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801a63:	8b 45 10             	mov    0x10(%ebp),%eax
  801a66:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a71:	89 14 24             	mov    %edx,(%esp)
  801a74:	ff d1                	call   *%ecx
}
  801a76:	83 c4 24             	add    $0x24,%esp
  801a79:	5b                   	pop    %ebx
  801a7a:	5d                   	pop    %ebp
  801a7b:	c3                   	ret    

00801a7c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	57                   	push   %edi
  801a80:	56                   	push   %esi
  801a81:	53                   	push   %ebx
  801a82:	83 ec 1c             	sub    $0x1c,%esp
  801a85:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a88:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801a8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801a90:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a95:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9a:	85 f6                	test   %esi,%esi
  801a9c:	74 29                	je     801ac7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801a9e:	89 f0                	mov    %esi,%eax
  801aa0:	29 d0                	sub    %edx,%eax
  801aa2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aa6:	03 55 0c             	add    0xc(%ebp),%edx
  801aa9:	89 54 24 04          	mov    %edx,0x4(%esp)
  801aad:	89 3c 24             	mov    %edi,(%esp)
  801ab0:	e8 39 ff ff ff       	call   8019ee <read>
		if (m < 0)
  801ab5:	85 c0                	test   %eax,%eax
  801ab7:	78 0e                	js     801ac7 <readn+0x4b>
			return m;
		if (m == 0)
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	74 08                	je     801ac5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801abd:	01 c3                	add    %eax,%ebx
  801abf:	89 da                	mov    %ebx,%edx
  801ac1:	39 f3                	cmp    %esi,%ebx
  801ac3:	72 d9                	jb     801a9e <readn+0x22>
  801ac5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801ac7:	83 c4 1c             	add    $0x1c,%esp
  801aca:	5b                   	pop    %ebx
  801acb:	5e                   	pop    %esi
  801acc:	5f                   	pop    %edi
  801acd:	5d                   	pop    %ebp
  801ace:	c3                   	ret    

00801acf <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	56                   	push   %esi
  801ad3:	53                   	push   %ebx
  801ad4:	83 ec 20             	sub    $0x20,%esp
  801ad7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801ada:	89 34 24             	mov    %esi,(%esp)
  801add:	e8 0e fc ff ff       	call   8016f0 <fd2num>
  801ae2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ae5:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ae9:	89 04 24             	mov    %eax,(%esp)
  801aec:	e8 9c fc ff ff       	call   80178d <fd_lookup>
  801af1:	89 c3                	mov    %eax,%ebx
  801af3:	85 c0                	test   %eax,%eax
  801af5:	78 05                	js     801afc <fd_close+0x2d>
  801af7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801afa:	74 0c                	je     801b08 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801afc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801b00:	19 c0                	sbb    %eax,%eax
  801b02:	f7 d0                	not    %eax
  801b04:	21 c3                	and    %eax,%ebx
  801b06:	eb 3d                	jmp    801b45 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b08:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b0f:	8b 06                	mov    (%esi),%eax
  801b11:	89 04 24             	mov    %eax,(%esp)
  801b14:	e8 e8 fc ff ff       	call   801801 <dev_lookup>
  801b19:	89 c3                	mov    %eax,%ebx
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	78 16                	js     801b35 <fd_close+0x66>
		if (dev->dev_close)
  801b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b22:	8b 40 10             	mov    0x10(%eax),%eax
  801b25:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b2a:	85 c0                	test   %eax,%eax
  801b2c:	74 07                	je     801b35 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801b2e:	89 34 24             	mov    %esi,(%esp)
  801b31:	ff d0                	call   *%eax
  801b33:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801b35:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b39:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b40:	e8 35 f6 ff ff       	call   80117a <sys_page_unmap>
	return r;
}
  801b45:	89 d8                	mov    %ebx,%eax
  801b47:	83 c4 20             	add    $0x20,%esp
  801b4a:	5b                   	pop    %ebx
  801b4b:	5e                   	pop    %esi
  801b4c:	5d                   	pop    %ebp
  801b4d:	c3                   	ret    

00801b4e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b54:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5e:	89 04 24             	mov    %eax,(%esp)
  801b61:	e8 27 fc ff ff       	call   80178d <fd_lookup>
  801b66:	85 c0                	test   %eax,%eax
  801b68:	78 13                	js     801b7d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801b6a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801b71:	00 
  801b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b75:	89 04 24             	mov    %eax,(%esp)
  801b78:	e8 52 ff ff ff       	call   801acf <fd_close>
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 18             	sub    $0x18,%esp
  801b85:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801b88:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801b8b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b92:	00 
  801b93:	8b 45 08             	mov    0x8(%ebp),%eax
  801b96:	89 04 24             	mov    %eax,(%esp)
  801b99:	e8 a9 03 00 00       	call   801f47 <open>
  801b9e:	89 c3                	mov    %eax,%ebx
  801ba0:	85 c0                	test   %eax,%eax
  801ba2:	78 1b                	js     801bbf <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ba7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bab:	89 1c 24             	mov    %ebx,(%esp)
  801bae:	e8 b7 fc ff ff       	call   80186a <fstat>
  801bb3:	89 c6                	mov    %eax,%esi
	close(fd);
  801bb5:	89 1c 24             	mov    %ebx,(%esp)
  801bb8:	e8 91 ff ff ff       	call   801b4e <close>
  801bbd:	89 f3                	mov    %esi,%ebx
	return r;
}
  801bbf:	89 d8                	mov    %ebx,%eax
  801bc1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801bc4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801bc7:	89 ec                	mov    %ebp,%esp
  801bc9:	5d                   	pop    %ebp
  801bca:	c3                   	ret    

00801bcb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
  801bce:	53                   	push   %ebx
  801bcf:	83 ec 14             	sub    $0x14,%esp
  801bd2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801bd7:	89 1c 24             	mov    %ebx,(%esp)
  801bda:	e8 6f ff ff ff       	call   801b4e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801bdf:	83 c3 01             	add    $0x1,%ebx
  801be2:	83 fb 20             	cmp    $0x20,%ebx
  801be5:	75 f0                	jne    801bd7 <close_all+0xc>
		close(i);
}
  801be7:	83 c4 14             	add    $0x14,%esp
  801bea:	5b                   	pop    %ebx
  801beb:	5d                   	pop    %ebp
  801bec:	c3                   	ret    

00801bed <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	83 ec 58             	sub    $0x58,%esp
  801bf3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801bf6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801bf9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801bfc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801bff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801c02:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	89 04 24             	mov    %eax,(%esp)
  801c0c:	e8 7c fb ff ff       	call   80178d <fd_lookup>
  801c11:	89 c3                	mov    %eax,%ebx
  801c13:	85 c0                	test   %eax,%eax
  801c15:	0f 88 e0 00 00 00    	js     801cfb <dup+0x10e>
		return r;
	close(newfdnum);
  801c1b:	89 3c 24             	mov    %edi,(%esp)
  801c1e:	e8 2b ff ff ff       	call   801b4e <close>

	newfd = INDEX2FD(newfdnum);
  801c23:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801c29:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801c2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c2f:	89 04 24             	mov    %eax,(%esp)
  801c32:	e8 c9 fa ff ff       	call   801700 <fd2data>
  801c37:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801c39:	89 34 24             	mov    %esi,(%esp)
  801c3c:	e8 bf fa ff ff       	call   801700 <fd2data>
  801c41:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801c44:	89 da                	mov    %ebx,%edx
  801c46:	89 d8                	mov    %ebx,%eax
  801c48:	c1 e8 16             	shr    $0x16,%eax
  801c4b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c52:	a8 01                	test   $0x1,%al
  801c54:	74 43                	je     801c99 <dup+0xac>
  801c56:	c1 ea 0c             	shr    $0xc,%edx
  801c59:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c60:	a8 01                	test   $0x1,%al
  801c62:	74 35                	je     801c99 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801c64:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c6b:	25 07 0e 00 00       	and    $0xe07,%eax
  801c70:	89 44 24 10          	mov    %eax,0x10(%esp)
  801c74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801c77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c7b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c82:	00 
  801c83:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c8e:	e8 45 f5 ff ff       	call   8011d8 <sys_page_map>
  801c93:	89 c3                	mov    %eax,%ebx
  801c95:	85 c0                	test   %eax,%eax
  801c97:	78 3f                	js     801cd8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801c99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c9c:	89 c2                	mov    %eax,%edx
  801c9e:	c1 ea 0c             	shr    $0xc,%edx
  801ca1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801ca8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801cae:	89 54 24 10          	mov    %edx,0x10(%esp)
  801cb2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801cb6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cbd:	00 
  801cbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cc9:	e8 0a f5 ff ff       	call   8011d8 <sys_page_map>
  801cce:	89 c3                	mov    %eax,%ebx
  801cd0:	85 c0                	test   %eax,%eax
  801cd2:	78 04                	js     801cd8 <dup+0xeb>
  801cd4:	89 fb                	mov    %edi,%ebx
  801cd6:	eb 23                	jmp    801cfb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801cd8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cdc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ce3:	e8 92 f4 ff ff       	call   80117a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801ce8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801ceb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cf6:	e8 7f f4 ff ff       	call   80117a <sys_page_unmap>
	return r;
}
  801cfb:	89 d8                	mov    %ebx,%eax
  801cfd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801d00:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801d03:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801d06:	89 ec                	mov    %ebp,%esp
  801d08:	5d                   	pop    %ebp
  801d09:	c3                   	ret    
	...

00801d0c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	53                   	push   %ebx
  801d10:	83 ec 14             	sub    $0x14,%esp
  801d13:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d15:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801d1b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d22:	00 
  801d23:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801d2a:	00 
  801d2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d2f:	89 14 24             	mov    %edx,(%esp)
  801d32:	e8 f9 0d 00 00       	call   802b30 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d37:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d3e:	00 
  801d3f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d43:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d4a:	e8 43 0e 00 00       	call   802b92 <ipc_recv>
}
  801d4f:	83 c4 14             	add    $0x14,%esp
  801d52:	5b                   	pop    %ebx
  801d53:	5d                   	pop    %ebp
  801d54:	c3                   	ret    

00801d55 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
  801d58:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5e:	8b 40 0c             	mov    0xc(%eax),%eax
  801d61:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d69:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801d6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801d73:	b8 02 00 00 00       	mov    $0x2,%eax
  801d78:	e8 8f ff ff ff       	call   801d0c <fsipc>
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
  801d82:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d85:	ba 00 00 00 00       	mov    $0x0,%edx
  801d8a:	b8 08 00 00 00       	mov    $0x8,%eax
  801d8f:	e8 78 ff ff ff       	call   801d0c <fsipc>
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	53                   	push   %ebx
  801d9a:	83 ec 14             	sub    $0x14,%esp
  801d9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	8b 40 0c             	mov    0xc(%eax),%eax
  801da6:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801dab:	ba 00 00 00 00       	mov    $0x0,%edx
  801db0:	b8 05 00 00 00       	mov    $0x5,%eax
  801db5:	e8 52 ff ff ff       	call   801d0c <fsipc>
  801dba:	85 c0                	test   %eax,%eax
  801dbc:	78 2b                	js     801de9 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801dbe:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801dc5:	00 
  801dc6:	89 1c 24             	mov    %ebx,(%esp)
  801dc9:	e8 0c ed ff ff       	call   800ada <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801dce:	a1 80 40 80 00       	mov    0x804080,%eax
  801dd3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801dd9:	a1 84 40 80 00       	mov    0x804084,%eax
  801dde:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801de4:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801de9:	83 c4 14             	add    $0x14,%esp
  801dec:	5b                   	pop    %ebx
  801ded:	5d                   	pop    %ebp
  801dee:	c3                   	ret    

00801def <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  801df5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801dfc:	00 
  801dfd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e04:	00 
  801e05:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e0c:	e8 25 ee ff ff       	call   800c36 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e11:	8b 45 08             	mov    0x8(%ebp),%eax
  801e14:	8b 40 0c             	mov    0xc(%eax),%eax
  801e17:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801e1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e21:	b8 06 00 00 00       	mov    $0x6,%eax
  801e26:	e8 e1 fe ff ff       	call   801d0c <fsipc>
}
  801e2b:	c9                   	leave  
  801e2c:	c3                   	ret    

00801e2d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e2d:	55                   	push   %ebp
  801e2e:	89 e5                	mov    %esp,%ebp
  801e30:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801e33:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801e3a:	00 
  801e3b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e42:	00 
  801e43:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e4a:	e8 e7 ed ff ff       	call   800c36 <memset>
  801e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801e52:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801e57:	76 05                	jbe    801e5e <devfile_write+0x31>
  801e59:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801e5e:	8b 55 08             	mov    0x8(%ebp),%edx
  801e61:	8b 52 0c             	mov    0xc(%edx),%edx
  801e64:	89 15 00 40 80 00    	mov    %edx,0x804000
        fsipcbuf.write.req_n = numberOfBytes;
  801e6a:	a3 04 40 80 00       	mov    %eax,0x804004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  801e6f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e76:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7a:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801e81:	e8 0f ee ff ff       	call   800c95 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  801e86:	ba 00 00 00 00       	mov    $0x0,%edx
  801e8b:	b8 04 00 00 00       	mov    $0x4,%eax
  801e90:	e8 77 fe ff ff       	call   801d0c <fsipc>
              return r;
        return r;
}
  801e95:	c9                   	leave  
  801e96:	c3                   	ret    

00801e97 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801e97:	55                   	push   %ebp
  801e98:	89 e5                	mov    %esp,%ebp
  801e9a:	53                   	push   %ebx
  801e9b:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  801e9e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801ea5:	00 
  801ea6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ead:	00 
  801eae:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801eb5:	e8 7c ed ff ff       	call   800c36 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  801eba:	8b 45 08             	mov    0x8(%ebp),%eax
  801ebd:	8b 40 0c             	mov    0xc(%eax),%eax
  801ec0:	a3 00 40 80 00       	mov    %eax,0x804000
        fsipcbuf.read.req_n = n;
  801ec5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ec8:	a3 04 40 80 00       	mov    %eax,0x804004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  801ecd:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed2:	b8 03 00 00 00       	mov    $0x3,%eax
  801ed7:	e8 30 fe ff ff       	call   801d0c <fsipc>
  801edc:	89 c3                	mov    %eax,%ebx
  801ede:	85 c0                	test   %eax,%eax
  801ee0:	78 17                	js     801ef9 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  801ee2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ee6:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801eed:	00 
  801eee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ef1:	89 04 24             	mov    %eax,(%esp)
  801ef4:	e8 9c ed ff ff       	call   800c95 <memmove>
        return r;
}
  801ef9:	89 d8                	mov    %ebx,%eax
  801efb:	83 c4 14             	add    $0x14,%esp
  801efe:	5b                   	pop    %ebx
  801eff:	5d                   	pop    %ebp
  801f00:	c3                   	ret    

00801f01 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801f01:	55                   	push   %ebp
  801f02:	89 e5                	mov    %esp,%ebp
  801f04:	53                   	push   %ebx
  801f05:	83 ec 14             	sub    $0x14,%esp
  801f08:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801f0b:	89 1c 24             	mov    %ebx,(%esp)
  801f0e:	e8 7d eb ff ff       	call   800a90 <strlen>
  801f13:	89 c2                	mov    %eax,%edx
  801f15:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801f1a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801f20:	7f 1f                	jg     801f41 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801f22:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f26:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801f2d:	e8 a8 eb ff ff       	call   800ada <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801f32:	ba 00 00 00 00       	mov    $0x0,%edx
  801f37:	b8 07 00 00 00       	mov    $0x7,%eax
  801f3c:	e8 cb fd ff ff       	call   801d0c <fsipc>
}
  801f41:	83 c4 14             	add    $0x14,%esp
  801f44:	5b                   	pop    %ebx
  801f45:	5d                   	pop    %ebp
  801f46:	c3                   	ret    

00801f47 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
  801f4a:	56                   	push   %esi
  801f4b:	53                   	push   %ebx
  801f4c:	83 ec 20             	sub    $0x20,%esp
  801f4f:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  801f52:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801f59:	00 
  801f5a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f61:	00 
  801f62:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801f69:	e8 c8 ec ff ff       	call   800c36 <memset>
    if(strlen(path)>=MAXPATHLEN)
  801f6e:	89 34 24             	mov    %esi,(%esp)
  801f71:	e8 1a eb ff ff       	call   800a90 <strlen>
  801f76:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801f7b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801f80:	0f 8f 84 00 00 00    	jg     80200a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  801f86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f89:	89 04 24             	mov    %eax,(%esp)
  801f8c:	e8 8a f7 ff ff       	call   80171b <fd_alloc>
  801f91:	89 c3                	mov    %eax,%ebx
  801f93:	85 c0                	test   %eax,%eax
  801f95:	78 73                	js     80200a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  801f97:	0f b6 06             	movzbl (%esi),%eax
  801f9a:	84 c0                	test   %al,%al
  801f9c:	74 20                	je     801fbe <open+0x77>
  801f9e:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  801fa0:	0f be c0             	movsbl %al,%eax
  801fa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa7:	c7 04 24 18 34 80 00 	movl   $0x803418,(%esp)
  801fae:	e8 4e e4 ff ff       	call   800401 <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  801fb3:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  801fb7:	83 c3 01             	add    $0x1,%ebx
  801fba:	84 c0                	test   %al,%al
  801fbc:	75 e2                	jne    801fa0 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  801fbe:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fc2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801fc9:	e8 0c eb ff ff       	call   800ada <strcpy>
    fsipcbuf.open.req_omode = mode;
  801fce:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fd1:	a3 00 44 80 00       	mov    %eax,0x804400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  801fd6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801fde:	e8 29 fd ff ff       	call   801d0c <fsipc>
  801fe3:	89 c3                	mov    %eax,%ebx
  801fe5:	85 c0                	test   %eax,%eax
  801fe7:	79 15                	jns    801ffe <open+0xb7>
        {
            fd_close(fd,1);
  801fe9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801ff0:	00 
  801ff1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff4:	89 04 24             	mov    %eax,(%esp)
  801ff7:	e8 d3 fa ff ff       	call   801acf <fd_close>
             return r;
  801ffc:	eb 0c                	jmp    80200a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  801ffe:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802001:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  802007:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  80200a:	89 d8                	mov    %ebx,%eax
  80200c:	83 c4 20             	add    $0x20,%esp
  80200f:	5b                   	pop    %ebx
  802010:	5e                   	pop    %esi
  802011:	5d                   	pop    %ebp
  802012:	c3                   	ret    
	...

00802020 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802020:	55                   	push   %ebp
  802021:	89 e5                	mov    %esp,%ebp
  802023:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802026:	c7 44 24 04 1b 34 80 	movl   $0x80341b,0x4(%esp)
  80202d:	00 
  80202e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802031:	89 04 24             	mov    %eax,(%esp)
  802034:	e8 a1 ea ff ff       	call   800ada <strcpy>
	return 0;
}
  802039:	b8 00 00 00 00       	mov    $0x0,%eax
  80203e:	c9                   	leave  
  80203f:	c3                   	ret    

00802040 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  802046:	8b 45 08             	mov    0x8(%ebp),%eax
  802049:	8b 40 0c             	mov    0xc(%eax),%eax
  80204c:	89 04 24             	mov    %eax,(%esp)
  80204f:	e8 9e 02 00 00       	call   8022f2 <nsipc_close>
}
  802054:	c9                   	leave  
  802055:	c3                   	ret    

00802056 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802056:	55                   	push   %ebp
  802057:	89 e5                	mov    %esp,%ebp
  802059:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80205c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802063:	00 
  802064:	8b 45 10             	mov    0x10(%ebp),%eax
  802067:	89 44 24 08          	mov    %eax,0x8(%esp)
  80206b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80206e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802072:	8b 45 08             	mov    0x8(%ebp),%eax
  802075:	8b 40 0c             	mov    0xc(%eax),%eax
  802078:	89 04 24             	mov    %eax,(%esp)
  80207b:	e8 ae 02 00 00       	call   80232e <nsipc_send>
}
  802080:	c9                   	leave  
  802081:	c3                   	ret    

00802082 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802082:	55                   	push   %ebp
  802083:	89 e5                	mov    %esp,%ebp
  802085:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802088:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80208f:	00 
  802090:	8b 45 10             	mov    0x10(%ebp),%eax
  802093:	89 44 24 08          	mov    %eax,0x8(%esp)
  802097:	8b 45 0c             	mov    0xc(%ebp),%eax
  80209a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80209e:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a4:	89 04 24             	mov    %eax,(%esp)
  8020a7:	e8 f5 02 00 00       	call   8023a1 <nsipc_recv>
}
  8020ac:	c9                   	leave  
  8020ad:	c3                   	ret    

008020ae <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8020ae:	55                   	push   %ebp
  8020af:	89 e5                	mov    %esp,%ebp
  8020b1:	56                   	push   %esi
  8020b2:	53                   	push   %ebx
  8020b3:	83 ec 20             	sub    $0x20,%esp
  8020b6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8020b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020bb:	89 04 24             	mov    %eax,(%esp)
  8020be:	e8 58 f6 ff ff       	call   80171b <fd_alloc>
  8020c3:	89 c3                	mov    %eax,%ebx
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	78 21                	js     8020ea <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  8020c9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8020d0:	00 
  8020d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020df:	e8 52 f1 ff ff       	call   801236 <sys_page_alloc>
  8020e4:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8020e6:	85 c0                	test   %eax,%eax
  8020e8:	79 0a                	jns    8020f4 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  8020ea:	89 34 24             	mov    %esi,(%esp)
  8020ed:	e8 00 02 00 00       	call   8022f2 <nsipc_close>
		return r;
  8020f2:	eb 28                	jmp    80211c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8020f4:	8b 15 20 70 80 00    	mov    0x807020,%edx
  8020fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8020ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802102:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80210f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802112:	89 04 24             	mov    %eax,(%esp)
  802115:	e8 d6 f5 ff ff       	call   8016f0 <fd2num>
  80211a:	89 c3                	mov    %eax,%ebx
}
  80211c:	89 d8                	mov    %ebx,%eax
  80211e:	83 c4 20             	add    $0x20,%esp
  802121:	5b                   	pop    %ebx
  802122:	5e                   	pop    %esi
  802123:	5d                   	pop    %ebp
  802124:	c3                   	ret    

00802125 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802125:	55                   	push   %ebp
  802126:	89 e5                	mov    %esp,%ebp
  802128:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80212b:	8b 45 10             	mov    0x10(%ebp),%eax
  80212e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802132:	8b 45 0c             	mov    0xc(%ebp),%eax
  802135:	89 44 24 04          	mov    %eax,0x4(%esp)
  802139:	8b 45 08             	mov    0x8(%ebp),%eax
  80213c:	89 04 24             	mov    %eax,(%esp)
  80213f:	e8 62 01 00 00       	call   8022a6 <nsipc_socket>
  802144:	85 c0                	test   %eax,%eax
  802146:	78 05                	js     80214d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802148:	e8 61 ff ff ff       	call   8020ae <alloc_sockfd>
}
  80214d:	c9                   	leave  
  80214e:	66 90                	xchg   %ax,%ax
  802150:	c3                   	ret    

00802151 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
  802154:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802157:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80215a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80215e:	89 04 24             	mov    %eax,(%esp)
  802161:	e8 27 f6 ff ff       	call   80178d <fd_lookup>
  802166:	85 c0                	test   %eax,%eax
  802168:	78 15                	js     80217f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80216a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216d:	8b 0a                	mov    (%edx),%ecx
  80216f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802174:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  80217a:	75 03                	jne    80217f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80217c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	e8 c2 ff ff ff       	call   802151 <fd2sockid>
  80218f:	85 c0                	test   %eax,%eax
  802191:	78 0f                	js     8021a2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  802193:	8b 55 0c             	mov    0xc(%ebp),%edx
  802196:	89 54 24 04          	mov    %edx,0x4(%esp)
  80219a:	89 04 24             	mov    %eax,(%esp)
  80219d:	e8 2e 01 00 00       	call   8022d0 <nsipc_listen>
}
  8021a2:	c9                   	leave  
  8021a3:	c3                   	ret    

008021a4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021a4:	55                   	push   %ebp
  8021a5:	89 e5                	mov    %esp,%ebp
  8021a7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ad:	e8 9f ff ff ff       	call   802151 <fd2sockid>
  8021b2:	85 c0                	test   %eax,%eax
  8021b4:	78 16                	js     8021cc <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8021b6:	8b 55 10             	mov    0x10(%ebp),%edx
  8021b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021c0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021c4:	89 04 24             	mov    %eax,(%esp)
  8021c7:	e8 55 02 00 00       	call   802421 <nsipc_connect>
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d7:	e8 75 ff ff ff       	call   802151 <fd2sockid>
  8021dc:	85 c0                	test   %eax,%eax
  8021de:	78 0f                	js     8021ef <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8021e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021e7:	89 04 24             	mov    %eax,(%esp)
  8021ea:	e8 1d 01 00 00       	call   80230c <nsipc_shutdown>
}
  8021ef:	c9                   	leave  
  8021f0:	c3                   	ret    

008021f1 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8021f1:	55                   	push   %ebp
  8021f2:	89 e5                	mov    %esp,%ebp
  8021f4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fa:	e8 52 ff ff ff       	call   802151 <fd2sockid>
  8021ff:	85 c0                	test   %eax,%eax
  802201:	78 16                	js     802219 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802203:	8b 55 10             	mov    0x10(%ebp),%edx
  802206:	89 54 24 08          	mov    %edx,0x8(%esp)
  80220a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80220d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802211:	89 04 24             	mov    %eax,(%esp)
  802214:	e8 47 02 00 00       	call   802460 <nsipc_bind>
}
  802219:	c9                   	leave  
  80221a:	c3                   	ret    

0080221b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80221b:	55                   	push   %ebp
  80221c:	89 e5                	mov    %esp,%ebp
  80221e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802221:	8b 45 08             	mov    0x8(%ebp),%eax
  802224:	e8 28 ff ff ff       	call   802151 <fd2sockid>
  802229:	85 c0                	test   %eax,%eax
  80222b:	78 1f                	js     80224c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80222d:	8b 55 10             	mov    0x10(%ebp),%edx
  802230:	89 54 24 08          	mov    %edx,0x8(%esp)
  802234:	8b 55 0c             	mov    0xc(%ebp),%edx
  802237:	89 54 24 04          	mov    %edx,0x4(%esp)
  80223b:	89 04 24             	mov    %eax,(%esp)
  80223e:	e8 5c 02 00 00       	call   80249f <nsipc_accept>
  802243:	85 c0                	test   %eax,%eax
  802245:	78 05                	js     80224c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802247:	e8 62 fe ff ff       	call   8020ae <alloc_sockfd>
}
  80224c:	c9                   	leave  
  80224d:	8d 76 00             	lea    0x0(%esi),%esi
  802250:	c3                   	ret    
	...

00802260 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802266:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  80226c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802273:	00 
  802274:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80227b:	00 
  80227c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802280:	89 14 24             	mov    %edx,(%esp)
  802283:	e8 a8 08 00 00       	call   802b30 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802288:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80228f:	00 
  802290:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802297:	00 
  802298:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80229f:	e8 ee 08 00 00       	call   802b92 <ipc_recv>
}
  8022a4:	c9                   	leave  
  8022a5:	c3                   	ret    

008022a6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8022a6:	55                   	push   %ebp
  8022a7:	89 e5                	mov    %esp,%ebp
  8022a9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8022b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8022bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8022bf:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8022c4:	b8 09 00 00 00       	mov    $0x9,%eax
  8022c9:	e8 92 ff ff ff       	call   802260 <nsipc>
}
  8022ce:	c9                   	leave  
  8022cf:	c3                   	ret    

008022d0 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8022de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e1:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8022e6:	b8 06 00 00 00       	mov    $0x6,%eax
  8022eb:	e8 70 ff ff ff       	call   802260 <nsipc>
}
  8022f0:	c9                   	leave  
  8022f1:	c3                   	ret    

008022f2 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  8022f2:	55                   	push   %ebp
  8022f3:	89 e5                	mov    %esp,%ebp
  8022f5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802300:	b8 04 00 00 00       	mov    $0x4,%eax
  802305:	e8 56 ff ff ff       	call   802260 <nsipc>
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80231a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802322:	b8 03 00 00 00       	mov    $0x3,%eax
  802327:	e8 34 ff ff ff       	call   802260 <nsipc>
}
  80232c:	c9                   	leave  
  80232d:	c3                   	ret    

0080232e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	53                   	push   %ebx
  802332:	83 ec 14             	sub    $0x14,%esp
  802335:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802338:	8b 45 08             	mov    0x8(%ebp),%eax
  80233b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802340:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802346:	7e 24                	jle    80236c <nsipc_send+0x3e>
  802348:	c7 44 24 0c 27 34 80 	movl   $0x803427,0xc(%esp)
  80234f:	00 
  802350:	c7 44 24 08 33 34 80 	movl   $0x803433,0x8(%esp)
  802357:	00 
  802358:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  80235f:	00 
  802360:	c7 04 24 48 34 80 00 	movl   $0x803448,(%esp)
  802367:	e8 d0 df ff ff       	call   80033c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80236c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802370:	8b 45 0c             	mov    0xc(%ebp),%eax
  802373:	89 44 24 04          	mov    %eax,0x4(%esp)
  802377:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80237e:	e8 12 e9 ff ff       	call   800c95 <memmove>
	nsipcbuf.send.req_size = size;
  802383:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802389:	8b 45 14             	mov    0x14(%ebp),%eax
  80238c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802391:	b8 08 00 00 00       	mov    $0x8,%eax
  802396:	e8 c5 fe ff ff       	call   802260 <nsipc>
}
  80239b:	83 c4 14             	add    $0x14,%esp
  80239e:	5b                   	pop    %ebx
  80239f:	5d                   	pop    %ebp
  8023a0:	c3                   	ret    

008023a1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
  8023a4:	56                   	push   %esi
  8023a5:	53                   	push   %ebx
  8023a6:	83 ec 10             	sub    $0x10,%esp
  8023a9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8023b4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8023ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8023bd:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8023c2:	b8 07 00 00 00       	mov    $0x7,%eax
  8023c7:	e8 94 fe ff ff       	call   802260 <nsipc>
  8023cc:	89 c3                	mov    %eax,%ebx
  8023ce:	85 c0                	test   %eax,%eax
  8023d0:	78 46                	js     802418 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8023d2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8023d7:	7f 04                	jg     8023dd <nsipc_recv+0x3c>
  8023d9:	39 c6                	cmp    %eax,%esi
  8023db:	7d 24                	jge    802401 <nsipc_recv+0x60>
  8023dd:	c7 44 24 0c 54 34 80 	movl   $0x803454,0xc(%esp)
  8023e4:	00 
  8023e5:	c7 44 24 08 33 34 80 	movl   $0x803433,0x8(%esp)
  8023ec:	00 
  8023ed:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  8023f4:	00 
  8023f5:	c7 04 24 48 34 80 00 	movl   $0x803448,(%esp)
  8023fc:	e8 3b df ff ff       	call   80033c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802401:	89 44 24 08          	mov    %eax,0x8(%esp)
  802405:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80240c:	00 
  80240d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802410:	89 04 24             	mov    %eax,(%esp)
  802413:	e8 7d e8 ff ff       	call   800c95 <memmove>
	}

	return r;
}
  802418:	89 d8                	mov    %ebx,%eax
  80241a:	83 c4 10             	add    $0x10,%esp
  80241d:	5b                   	pop    %ebx
  80241e:	5e                   	pop    %esi
  80241f:	5d                   	pop    %ebp
  802420:	c3                   	ret    

00802421 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802421:	55                   	push   %ebp
  802422:	89 e5                	mov    %esp,%ebp
  802424:	53                   	push   %ebx
  802425:	83 ec 14             	sub    $0x14,%esp
  802428:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802433:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80243e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802445:	e8 4b e8 ff ff       	call   800c95 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80244a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802450:	b8 05 00 00 00       	mov    $0x5,%eax
  802455:	e8 06 fe ff ff       	call   802260 <nsipc>
}
  80245a:	83 c4 14             	add    $0x14,%esp
  80245d:	5b                   	pop    %ebx
  80245e:	5d                   	pop    %ebp
  80245f:	c3                   	ret    

00802460 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802460:	55                   	push   %ebp
  802461:	89 e5                	mov    %esp,%ebp
  802463:	53                   	push   %ebx
  802464:	83 ec 14             	sub    $0x14,%esp
  802467:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80246a:	8b 45 08             	mov    0x8(%ebp),%eax
  80246d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802472:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802476:	8b 45 0c             	mov    0xc(%ebp),%eax
  802479:	89 44 24 04          	mov    %eax,0x4(%esp)
  80247d:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802484:	e8 0c e8 ff ff       	call   800c95 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802489:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80248f:	b8 02 00 00 00       	mov    $0x2,%eax
  802494:	e8 c7 fd ff ff       	call   802260 <nsipc>
}
  802499:	83 c4 14             	add    $0x14,%esp
  80249c:	5b                   	pop    %ebx
  80249d:	5d                   	pop    %ebp
  80249e:	c3                   	ret    

0080249f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
  8024a2:	83 ec 18             	sub    $0x18,%esp
  8024a5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8024a8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8024ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8024ae:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8024b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b8:	e8 a3 fd ff ff       	call   802260 <nsipc>
  8024bd:	89 c3                	mov    %eax,%ebx
  8024bf:	85 c0                	test   %eax,%eax
  8024c1:	78 25                	js     8024e8 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8024c3:	be 10 60 80 00       	mov    $0x806010,%esi
  8024c8:	8b 06                	mov    (%esi),%eax
  8024ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024ce:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8024d5:	00 
  8024d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d9:	89 04 24             	mov    %eax,(%esp)
  8024dc:	e8 b4 e7 ff ff       	call   800c95 <memmove>
		*addrlen = ret->ret_addrlen;
  8024e1:	8b 16                	mov    (%esi),%edx
  8024e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8024e6:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  8024e8:	89 d8                	mov    %ebx,%eax
  8024ea:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8024ed:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8024f0:	89 ec                	mov    %ebp,%esp
  8024f2:	5d                   	pop    %ebp
  8024f3:	c3                   	ret    
	...

00802500 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802500:	55                   	push   %ebp
  802501:	89 e5                	mov    %esp,%ebp
  802503:	83 ec 18             	sub    $0x18,%esp
  802506:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802509:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80250c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80250f:	8b 45 08             	mov    0x8(%ebp),%eax
  802512:	89 04 24             	mov    %eax,(%esp)
  802515:	e8 e6 f1 ff ff       	call   801700 <fd2data>
  80251a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80251c:	c7 44 24 04 69 34 80 	movl   $0x803469,0x4(%esp)
  802523:	00 
  802524:	89 34 24             	mov    %esi,(%esp)
  802527:	e8 ae e5 ff ff       	call   800ada <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80252c:	8b 43 04             	mov    0x4(%ebx),%eax
  80252f:	2b 03                	sub    (%ebx),%eax
  802531:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802537:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80253e:	00 00 00 
	stat->st_dev = &devpipe;
  802541:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  802548:	70 80 00 
	return 0;
}
  80254b:	b8 00 00 00 00       	mov    $0x0,%eax
  802550:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802553:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802556:	89 ec                	mov    %ebp,%esp
  802558:	5d                   	pop    %ebp
  802559:	c3                   	ret    

0080255a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	53                   	push   %ebx
  80255e:	83 ec 14             	sub    $0x14,%esp
  802561:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802564:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802568:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80256f:	e8 06 ec ff ff       	call   80117a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802574:	89 1c 24             	mov    %ebx,(%esp)
  802577:	e8 84 f1 ff ff       	call   801700 <fd2data>
  80257c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802580:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802587:	e8 ee eb ff ff       	call   80117a <sys_page_unmap>
}
  80258c:	83 c4 14             	add    $0x14,%esp
  80258f:	5b                   	pop    %ebx
  802590:	5d                   	pop    %ebp
  802591:	c3                   	ret    

00802592 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802592:	55                   	push   %ebp
  802593:	89 e5                	mov    %esp,%ebp
  802595:	57                   	push   %edi
  802596:	56                   	push   %esi
  802597:	53                   	push   %ebx
  802598:	83 ec 2c             	sub    $0x2c,%esp
  80259b:	89 c7                	mov    %eax,%edi
  80259d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8025a0:	a1 74 70 80 00       	mov    0x807074,%eax
  8025a5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8025a8:	89 3c 24             	mov    %edi,(%esp)
  8025ab:	e8 48 06 00 00       	call   802bf8 <pageref>
  8025b0:	89 c6                	mov    %eax,%esi
  8025b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025b5:	89 04 24             	mov    %eax,(%esp)
  8025b8:	e8 3b 06 00 00       	call   802bf8 <pageref>
  8025bd:	39 c6                	cmp    %eax,%esi
  8025bf:	0f 94 c0             	sete   %al
  8025c2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  8025c5:	8b 15 74 70 80 00    	mov    0x807074,%edx
  8025cb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8025ce:	39 cb                	cmp    %ecx,%ebx
  8025d0:	75 08                	jne    8025da <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  8025d2:	83 c4 2c             	add    $0x2c,%esp
  8025d5:	5b                   	pop    %ebx
  8025d6:	5e                   	pop    %esi
  8025d7:	5f                   	pop    %edi
  8025d8:	5d                   	pop    %ebp
  8025d9:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8025da:	83 f8 01             	cmp    $0x1,%eax
  8025dd:	75 c1                	jne    8025a0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  8025df:	8b 52 58             	mov    0x58(%edx),%edx
  8025e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025e6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025ea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025ee:	c7 04 24 70 34 80 00 	movl   $0x803470,(%esp)
  8025f5:	e8 07 de ff ff       	call   800401 <cprintf>
  8025fa:	eb a4                	jmp    8025a0 <_pipeisclosed+0xe>

008025fc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025fc:	55                   	push   %ebp
  8025fd:	89 e5                	mov    %esp,%ebp
  8025ff:	57                   	push   %edi
  802600:	56                   	push   %esi
  802601:	53                   	push   %ebx
  802602:	83 ec 1c             	sub    $0x1c,%esp
  802605:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802608:	89 34 24             	mov    %esi,(%esp)
  80260b:	e8 f0 f0 ff ff       	call   801700 <fd2data>
  802610:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802612:	bf 00 00 00 00       	mov    $0x0,%edi
  802617:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80261b:	75 54                	jne    802671 <devpipe_write+0x75>
  80261d:	eb 60                	jmp    80267f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80261f:	89 da                	mov    %ebx,%edx
  802621:	89 f0                	mov    %esi,%eax
  802623:	e8 6a ff ff ff       	call   802592 <_pipeisclosed>
  802628:	85 c0                	test   %eax,%eax
  80262a:	74 07                	je     802633 <devpipe_write+0x37>
  80262c:	b8 00 00 00 00       	mov    $0x0,%eax
  802631:	eb 53                	jmp    802686 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802633:	90                   	nop
  802634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802638:	e8 58 ec ff ff       	call   801295 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80263d:	8b 43 04             	mov    0x4(%ebx),%eax
  802640:	8b 13                	mov    (%ebx),%edx
  802642:	83 c2 20             	add    $0x20,%edx
  802645:	39 d0                	cmp    %edx,%eax
  802647:	73 d6                	jae    80261f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802649:	89 c2                	mov    %eax,%edx
  80264b:	c1 fa 1f             	sar    $0x1f,%edx
  80264e:	c1 ea 1b             	shr    $0x1b,%edx
  802651:	01 d0                	add    %edx,%eax
  802653:	83 e0 1f             	and    $0x1f,%eax
  802656:	29 d0                	sub    %edx,%eax
  802658:	89 c2                	mov    %eax,%edx
  80265a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80265d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802661:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802665:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802669:	83 c7 01             	add    $0x1,%edi
  80266c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80266f:	76 13                	jbe    802684 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802671:	8b 43 04             	mov    0x4(%ebx),%eax
  802674:	8b 13                	mov    (%ebx),%edx
  802676:	83 c2 20             	add    $0x20,%edx
  802679:	39 d0                	cmp    %edx,%eax
  80267b:	73 a2                	jae    80261f <devpipe_write+0x23>
  80267d:	eb ca                	jmp    802649 <devpipe_write+0x4d>
  80267f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802684:	89 f8                	mov    %edi,%eax
}
  802686:	83 c4 1c             	add    $0x1c,%esp
  802689:	5b                   	pop    %ebx
  80268a:	5e                   	pop    %esi
  80268b:	5f                   	pop    %edi
  80268c:	5d                   	pop    %ebp
  80268d:	c3                   	ret    

0080268e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80268e:	55                   	push   %ebp
  80268f:	89 e5                	mov    %esp,%ebp
  802691:	83 ec 28             	sub    $0x28,%esp
  802694:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802697:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80269a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80269d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8026a0:	89 3c 24             	mov    %edi,(%esp)
  8026a3:	e8 58 f0 ff ff       	call   801700 <fd2data>
  8026a8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026aa:	be 00 00 00 00       	mov    $0x0,%esi
  8026af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8026b3:	75 4c                	jne    802701 <devpipe_read+0x73>
  8026b5:	eb 5b                	jmp    802712 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8026b7:	89 f0                	mov    %esi,%eax
  8026b9:	eb 5e                	jmp    802719 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8026bb:	89 da                	mov    %ebx,%edx
  8026bd:	89 f8                	mov    %edi,%eax
  8026bf:	90                   	nop
  8026c0:	e8 cd fe ff ff       	call   802592 <_pipeisclosed>
  8026c5:	85 c0                	test   %eax,%eax
  8026c7:	74 07                	je     8026d0 <devpipe_read+0x42>
  8026c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ce:	eb 49                	jmp    802719 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8026d0:	e8 c0 eb ff ff       	call   801295 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8026d5:	8b 03                	mov    (%ebx),%eax
  8026d7:	3b 43 04             	cmp    0x4(%ebx),%eax
  8026da:	74 df                	je     8026bb <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8026dc:	89 c2                	mov    %eax,%edx
  8026de:	c1 fa 1f             	sar    $0x1f,%edx
  8026e1:	c1 ea 1b             	shr    $0x1b,%edx
  8026e4:	01 d0                	add    %edx,%eax
  8026e6:	83 e0 1f             	and    $0x1f,%eax
  8026e9:	29 d0                	sub    %edx,%eax
  8026eb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8026f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f3:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8026f6:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026f9:	83 c6 01             	add    $0x1,%esi
  8026fc:	39 75 10             	cmp    %esi,0x10(%ebp)
  8026ff:	76 16                	jbe    802717 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802701:	8b 03                	mov    (%ebx),%eax
  802703:	3b 43 04             	cmp    0x4(%ebx),%eax
  802706:	75 d4                	jne    8026dc <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802708:	85 f6                	test   %esi,%esi
  80270a:	75 ab                	jne    8026b7 <devpipe_read+0x29>
  80270c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802710:	eb a9                	jmp    8026bb <devpipe_read+0x2d>
  802712:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802717:	89 f0                	mov    %esi,%eax
}
  802719:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80271c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80271f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802722:	89 ec                	mov    %ebp,%esp
  802724:	5d                   	pop    %ebp
  802725:	c3                   	ret    

00802726 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
  802729:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80272c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80272f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802733:	8b 45 08             	mov    0x8(%ebp),%eax
  802736:	89 04 24             	mov    %eax,(%esp)
  802739:	e8 4f f0 ff ff       	call   80178d <fd_lookup>
  80273e:	85 c0                	test   %eax,%eax
  802740:	78 15                	js     802757 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	89 04 24             	mov    %eax,(%esp)
  802748:	e8 b3 ef ff ff       	call   801700 <fd2data>
	return _pipeisclosed(fd, p);
  80274d:	89 c2                	mov    %eax,%edx
  80274f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802752:	e8 3b fe ff ff       	call   802592 <_pipeisclosed>
}
  802757:	c9                   	leave  
  802758:	c3                   	ret    

00802759 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802759:	55                   	push   %ebp
  80275a:	89 e5                	mov    %esp,%ebp
  80275c:	83 ec 48             	sub    $0x48,%esp
  80275f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802762:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802765:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802768:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80276b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80276e:	89 04 24             	mov    %eax,(%esp)
  802771:	e8 a5 ef ff ff       	call   80171b <fd_alloc>
  802776:	89 c3                	mov    %eax,%ebx
  802778:	85 c0                	test   %eax,%eax
  80277a:	0f 88 42 01 00 00    	js     8028c2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802780:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802787:	00 
  802788:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80278b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80278f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802796:	e8 9b ea ff ff       	call   801236 <sys_page_alloc>
  80279b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80279d:	85 c0                	test   %eax,%eax
  80279f:	0f 88 1d 01 00 00    	js     8028c2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8027a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8027a8:	89 04 24             	mov    %eax,(%esp)
  8027ab:	e8 6b ef ff ff       	call   80171b <fd_alloc>
  8027b0:	89 c3                	mov    %eax,%ebx
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	0f 88 f5 00 00 00    	js     8028af <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027ba:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027c1:	00 
  8027c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8027c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027d0:	e8 61 ea ff ff       	call   801236 <sys_page_alloc>
  8027d5:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	0f 88 d0 00 00 00    	js     8028af <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8027df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027e2:	89 04 24             	mov    %eax,(%esp)
  8027e5:	e8 16 ef ff ff       	call   801700 <fd2data>
  8027ea:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027ec:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027f3:	00 
  8027f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027ff:	e8 32 ea ff ff       	call   801236 <sys_page_alloc>
  802804:	89 c3                	mov    %eax,%ebx
  802806:	85 c0                	test   %eax,%eax
  802808:	0f 88 8e 00 00 00    	js     80289c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80280e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802811:	89 04 24             	mov    %eax,(%esp)
  802814:	e8 e7 ee ff ff       	call   801700 <fd2data>
  802819:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802820:	00 
  802821:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802825:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80282c:	00 
  80282d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802831:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802838:	e8 9b e9 ff ff       	call   8011d8 <sys_page_map>
  80283d:	89 c3                	mov    %eax,%ebx
  80283f:	85 c0                	test   %eax,%eax
  802841:	78 49                	js     80288c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802843:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  802848:	8b 08                	mov    (%eax),%ecx
  80284a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80284d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80284f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802852:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802859:	8b 10                	mov    (%eax),%edx
  80285b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80285e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802860:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802863:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80286a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80286d:	89 04 24             	mov    %eax,(%esp)
  802870:	e8 7b ee ff ff       	call   8016f0 <fd2num>
  802875:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802877:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80287a:	89 04 24             	mov    %eax,(%esp)
  80287d:	e8 6e ee ff ff       	call   8016f0 <fd2num>
  802882:	89 47 04             	mov    %eax,0x4(%edi)
  802885:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80288a:	eb 36                	jmp    8028c2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80288c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802890:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802897:	e8 de e8 ff ff       	call   80117a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80289c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80289f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028aa:	e8 cb e8 ff ff       	call   80117a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8028af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028bd:	e8 b8 e8 ff ff       	call   80117a <sys_page_unmap>
    err:
	return r;
}
  8028c2:	89 d8                	mov    %ebx,%eax
  8028c4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8028c7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8028ca:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8028cd:	89 ec                	mov    %ebp,%esp
  8028cf:	5d                   	pop    %ebp
  8028d0:	c3                   	ret    
	...

008028e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8028e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8028e8:	5d                   	pop    %ebp
  8028e9:	c3                   	ret    

008028ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8028ea:	55                   	push   %ebp
  8028eb:	89 e5                	mov    %esp,%ebp
  8028ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8028f0:	c7 44 24 04 83 34 80 	movl   $0x803483,0x4(%esp)
  8028f7:	00 
  8028f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028fb:	89 04 24             	mov    %eax,(%esp)
  8028fe:	e8 d7 e1 ff ff       	call   800ada <strcpy>
	return 0;
}
  802903:	b8 00 00 00 00       	mov    $0x0,%eax
  802908:	c9                   	leave  
  802909:	c3                   	ret    

0080290a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80290a:	55                   	push   %ebp
  80290b:	89 e5                	mov    %esp,%ebp
  80290d:	57                   	push   %edi
  80290e:	56                   	push   %esi
  80290f:	53                   	push   %ebx
  802910:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802916:	b8 00 00 00 00       	mov    $0x0,%eax
  80291b:	be 00 00 00 00       	mov    $0x0,%esi
  802920:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802924:	74 3f                	je     802965 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802926:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80292c:	8b 55 10             	mov    0x10(%ebp),%edx
  80292f:	29 c2                	sub    %eax,%edx
  802931:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802933:	83 fa 7f             	cmp    $0x7f,%edx
  802936:	76 05                	jbe    80293d <devcons_write+0x33>
  802938:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80293d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802941:	03 45 0c             	add    0xc(%ebp),%eax
  802944:	89 44 24 04          	mov    %eax,0x4(%esp)
  802948:	89 3c 24             	mov    %edi,(%esp)
  80294b:	e8 45 e3 ff ff       	call   800c95 <memmove>
		sys_cputs(buf, m);
  802950:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802954:	89 3c 24             	mov    %edi,(%esp)
  802957:	e8 74 e5 ff ff       	call   800ed0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80295c:	01 de                	add    %ebx,%esi
  80295e:	89 f0                	mov    %esi,%eax
  802960:	3b 75 10             	cmp    0x10(%ebp),%esi
  802963:	72 c7                	jb     80292c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802965:	89 f0                	mov    %esi,%eax
  802967:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80296d:	5b                   	pop    %ebx
  80296e:	5e                   	pop    %esi
  80296f:	5f                   	pop    %edi
  802970:	5d                   	pop    %ebp
  802971:	c3                   	ret    

00802972 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802972:	55                   	push   %ebp
  802973:	89 e5                	mov    %esp,%ebp
  802975:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802978:	8b 45 08             	mov    0x8(%ebp),%eax
  80297b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80297e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802985:	00 
  802986:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802989:	89 04 24             	mov    %eax,(%esp)
  80298c:	e8 3f e5 ff ff       	call   800ed0 <sys_cputs>
}
  802991:	c9                   	leave  
  802992:	c3                   	ret    

00802993 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802993:	55                   	push   %ebp
  802994:	89 e5                	mov    %esp,%ebp
  802996:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802999:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80299d:	75 07                	jne    8029a6 <devcons_read+0x13>
  80299f:	eb 28                	jmp    8029c9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8029a1:	e8 ef e8 ff ff       	call   801295 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8029a6:	66 90                	xchg   %ax,%ax
  8029a8:	e8 ef e4 ff ff       	call   800e9c <sys_cgetc>
  8029ad:	85 c0                	test   %eax,%eax
  8029af:	90                   	nop
  8029b0:	74 ef                	je     8029a1 <devcons_read+0xe>
  8029b2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8029b4:	85 c0                	test   %eax,%eax
  8029b6:	78 16                	js     8029ce <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8029b8:	83 f8 04             	cmp    $0x4,%eax
  8029bb:	74 0c                	je     8029c9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8029bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029c0:	88 10                	mov    %dl,(%eax)
  8029c2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8029c7:	eb 05                	jmp    8029ce <devcons_read+0x3b>
  8029c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029ce:	c9                   	leave  
  8029cf:	c3                   	ret    

008029d0 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  8029d0:	55                   	push   %ebp
  8029d1:	89 e5                	mov    %esp,%ebp
  8029d3:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8029d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029d9:	89 04 24             	mov    %eax,(%esp)
  8029dc:	e8 3a ed ff ff       	call   80171b <fd_alloc>
  8029e1:	85 c0                	test   %eax,%eax
  8029e3:	78 3f                	js     802a24 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8029e5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8029ec:	00 
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029fb:	e8 36 e8 ff ff       	call   801236 <sys_page_alloc>
  802a00:	85 c0                	test   %eax,%eax
  802a02:	78 20                	js     802a24 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802a04:	8b 15 58 70 80 00    	mov    0x807058,%edx
  802a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1c:	89 04 24             	mov    %eax,(%esp)
  802a1f:	e8 cc ec ff ff       	call   8016f0 <fd2num>
}
  802a24:	c9                   	leave  
  802a25:	c3                   	ret    

00802a26 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802a26:	55                   	push   %ebp
  802a27:	89 e5                	mov    %esp,%ebp
  802a29:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802a2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a33:	8b 45 08             	mov    0x8(%ebp),%eax
  802a36:	89 04 24             	mov    %eax,(%esp)
  802a39:	e8 4f ed ff ff       	call   80178d <fd_lookup>
  802a3e:	85 c0                	test   %eax,%eax
  802a40:	78 11                	js     802a53 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a45:	8b 00                	mov    (%eax),%eax
  802a47:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  802a4d:	0f 94 c0             	sete   %al
  802a50:	0f b6 c0             	movzbl %al,%eax
}
  802a53:	c9                   	leave  
  802a54:	c3                   	ret    

00802a55 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802a55:	55                   	push   %ebp
  802a56:	89 e5                	mov    %esp,%ebp
  802a58:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802a5b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802a62:	00 
  802a63:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a66:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a71:	e8 78 ef ff ff       	call   8019ee <read>
	if (r < 0)
  802a76:	85 c0                	test   %eax,%eax
  802a78:	78 0f                	js     802a89 <getchar+0x34>
		return r;
	if (r < 1)
  802a7a:	85 c0                	test   %eax,%eax
  802a7c:	7f 07                	jg     802a85 <getchar+0x30>
  802a7e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802a83:	eb 04                	jmp    802a89 <getchar+0x34>
		return -E_EOF;
	return c;
  802a85:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802a89:	c9                   	leave  
  802a8a:	c3                   	ret    
	...

00802a8c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802a8c:	55                   	push   %ebp
  802a8d:	89 e5                	mov    %esp,%ebp
  802a8f:	53                   	push   %ebx
  802a90:	83 ec 14             	sub    $0x14,%esp
  802a93:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    // cprintf("\nhere outside loading creating page\n");

	if (_pgfault_handler == 0) {
  802a96:	83 3d 7c 70 80 00 00 	cmpl   $0x0,0x80707c
  802a9d:	75 58                	jne    802af7 <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
           //cprintf("\nhere inside loading creating page\n");    
          if(sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  802a9f:	e8 25 e8 ff ff       	call   8012c9 <sys_getenvid>
  802aa4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802aab:	00 
  802aac:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802ab3:	ee 
  802ab4:	89 04 24             	mov    %eax,(%esp)
  802ab7:	e8 7a e7 ff ff       	call   801236 <sys_page_alloc>
  802abc:	85 c0                	test   %eax,%eax
  802abe:	79 1c                	jns    802adc <set_pgfault_handler+0x50>
                          panic("Cant allocate Page");                    
  802ac0:	c7 44 24 08 0c 33 80 	movl   $0x80330c,0x8(%esp)
  802ac7:	00 
  802ac8:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802acf:	00 
  802ad0:	c7 04 24 8f 34 80 00 	movl   $0x80348f,(%esp)
  802ad7:	e8 60 d8 ff ff       	call   80033c <_panic>
                _pgfault_handler=handler;
  802adc:	89 1d 7c 70 80 00    	mov    %ebx,0x80707c
//entry point _pgfault_handler not pointed to by the kernel bcz after the execution is complete control needs to be returned back to execute the rest...so upcall is there         
             sys_env_set_pgfault_upcall(sys_getenvid(),_pgfault_upcall);
  802ae2:	e8 e2 e7 ff ff       	call   8012c9 <sys_getenvid>
  802ae7:	c7 44 24 04 04 2b 80 	movl   $0x802b04,0x4(%esp)
  802aee:	00 
  802aef:	89 04 24             	mov    %eax,(%esp)
  802af2:	e8 69 e5 ff ff       	call   801060 <sys_env_set_pgfault_upcall>

	// Save handler pointer for assembly to call.
 //     if(sys_page_alloc(0,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
   //                       panic("Cant allocate Page");

	_pgfault_handler = handler;
  802af7:	89 1d 7c 70 80 00    	mov    %ebx,0x80707c
}
  802afd:	83 c4 14             	add    $0x14,%esp
  802b00:	5b                   	pop    %ebx
  802b01:	5d                   	pop    %ebp
  802b02:	c3                   	ret    
	...

00802b04 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802b04:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802b05:	a1 7c 70 80 00       	mov    0x80707c,%eax
	call *%eax
  802b0a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802b0c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
           addl $8,%esp
  802b0f:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
            movl  32(%esp),%ebx
  802b12:	8b 5c 24 20          	mov    0x20(%esp),%ebx
            movl  40(%esp),%eax
  802b16:	8b 44 24 28          	mov    0x28(%esp),%eax
            subl  $4,%eax
  802b1a:	83 e8 04             	sub    $0x4,%eax
            movl  %eax,40(%esp)
  802b1d:	89 44 24 28          	mov    %eax,0x28(%esp)
            movl  %ebx,(%eax)
  802b21:	89 18                	mov    %ebx,(%eax)
            popal
  802b23:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
            
            add $4,%esp            
  802b24:	83 c4 04             	add    $0x4,%esp
            popfl
  802b27:	9d                   	popf   
             
           popl %esp
  802b28:	5c                   	pop    %esp
	// LAB 4: Your code here.
           

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
           ret
  802b29:	c3                   	ret    
  802b2a:	00 00                	add    %al,(%eax)
  802b2c:	00 00                	add    %al,(%eax)
	...

00802b30 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802b30:	55                   	push   %ebp
  802b31:	89 e5                	mov    %esp,%ebp
  802b33:	57                   	push   %edi
  802b34:	56                   	push   %esi
  802b35:	53                   	push   %ebx
  802b36:	83 ec 1c             	sub    $0x1c,%esp
  802b39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802b3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  802b3f:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  802b42:	8b 45 14             	mov    0x14(%ebp),%eax
  802b45:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802b49:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802b4d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802b51:	89 1c 24             	mov    %ebx,(%esp)
  802b54:	e8 cf e4 ff ff       	call   801028 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  802b59:	85 c0                	test   %eax,%eax
  802b5b:	79 21                	jns    802b7e <ipc_send+0x4e>
  802b5d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802b60:	74 1c                	je     802b7e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  802b62:	c7 44 24 08 9d 34 80 	movl   $0x80349d,0x8(%esp)
  802b69:	00 
  802b6a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  802b71:	00 
  802b72:	c7 04 24 af 34 80 00 	movl   $0x8034af,(%esp)
  802b79:	e8 be d7 ff ff       	call   80033c <_panic>
          else if(r==-E_IPC_NOT_RECV)
  802b7e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802b81:	75 07                	jne    802b8a <ipc_send+0x5a>
           sys_yield();
  802b83:	e8 0d e7 ff ff       	call   801295 <sys_yield>
          else
            break;
        }
  802b88:	eb b8                	jmp    802b42 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  802b8a:	83 c4 1c             	add    $0x1c,%esp
  802b8d:	5b                   	pop    %ebx
  802b8e:	5e                   	pop    %esi
  802b8f:	5f                   	pop    %edi
  802b90:	5d                   	pop    %ebp
  802b91:	c3                   	ret    

00802b92 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802b92:	55                   	push   %ebp
  802b93:	89 e5                	mov    %esp,%ebp
  802b95:	83 ec 18             	sub    $0x18,%esp
  802b98:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802b9b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802b9e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802ba1:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  802ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ba7:	89 04 24             	mov    %eax,(%esp)
  802baa:	e8 1c e4 ff ff       	call   800fcb <sys_ipc_recv>
        if(r<0)
  802baf:	85 c0                	test   %eax,%eax
  802bb1:	79 17                	jns    802bca <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  802bb3:	85 db                	test   %ebx,%ebx
  802bb5:	74 06                	je     802bbd <ipc_recv+0x2b>
               *from_env_store =0;
  802bb7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  802bbd:	85 f6                	test   %esi,%esi
  802bbf:	90                   	nop
  802bc0:	74 2c                	je     802bee <ipc_recv+0x5c>
              *perm_store=0;
  802bc2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802bc8:	eb 24                	jmp    802bee <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  802bca:	85 db                	test   %ebx,%ebx
  802bcc:	74 0a                	je     802bd8 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  802bce:	a1 74 70 80 00       	mov    0x807074,%eax
  802bd3:	8b 40 74             	mov    0x74(%eax),%eax
  802bd6:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  802bd8:	85 f6                	test   %esi,%esi
  802bda:	74 0a                	je     802be6 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  802bdc:	a1 74 70 80 00       	mov    0x807074,%eax
  802be1:	8b 40 78             	mov    0x78(%eax),%eax
  802be4:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  802be6:	a1 74 70 80 00       	mov    0x807074,%eax
  802beb:	8b 40 70             	mov    0x70(%eax),%eax
}
  802bee:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802bf1:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802bf4:	89 ec                	mov    %ebp,%esp
  802bf6:	5d                   	pop    %ebp
  802bf7:	c3                   	ret    

00802bf8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802bf8:	55                   	push   %ebp
  802bf9:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfe:	89 c2                	mov    %eax,%edx
  802c00:	c1 ea 16             	shr    $0x16,%edx
  802c03:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802c0a:	f6 c2 01             	test   $0x1,%dl
  802c0d:	74 26                	je     802c35 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802c0f:	c1 e8 0c             	shr    $0xc,%eax
  802c12:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802c19:	a8 01                	test   $0x1,%al
  802c1b:	74 18                	je     802c35 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802c1d:	c1 e8 0c             	shr    $0xc,%eax
  802c20:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802c23:	c1 e2 02             	shl    $0x2,%edx
  802c26:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802c2b:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802c30:	0f b7 c0             	movzwl %ax,%eax
  802c33:	eb 05                	jmp    802c3a <pageref+0x42>
  802c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c3a:	5d                   	pop    %ebp
  802c3b:	c3                   	ret    
  802c3c:	00 00                	add    %al,(%eax)
	...

00802c40 <__udivdi3>:
  802c40:	55                   	push   %ebp
  802c41:	89 e5                	mov    %esp,%ebp
  802c43:	57                   	push   %edi
  802c44:	56                   	push   %esi
  802c45:	83 ec 10             	sub    $0x10,%esp
  802c48:	8b 45 14             	mov    0x14(%ebp),%eax
  802c4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4e:	8b 75 10             	mov    0x10(%ebp),%esi
  802c51:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802c54:	85 c0                	test   %eax,%eax
  802c56:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802c59:	75 35                	jne    802c90 <__udivdi3+0x50>
  802c5b:	39 fe                	cmp    %edi,%esi
  802c5d:	77 61                	ja     802cc0 <__udivdi3+0x80>
  802c5f:	85 f6                	test   %esi,%esi
  802c61:	75 0b                	jne    802c6e <__udivdi3+0x2e>
  802c63:	b8 01 00 00 00       	mov    $0x1,%eax
  802c68:	31 d2                	xor    %edx,%edx
  802c6a:	f7 f6                	div    %esi
  802c6c:	89 c6                	mov    %eax,%esi
  802c6e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802c71:	31 d2                	xor    %edx,%edx
  802c73:	89 f8                	mov    %edi,%eax
  802c75:	f7 f6                	div    %esi
  802c77:	89 c7                	mov    %eax,%edi
  802c79:	89 c8                	mov    %ecx,%eax
  802c7b:	f7 f6                	div    %esi
  802c7d:	89 c1                	mov    %eax,%ecx
  802c7f:	89 fa                	mov    %edi,%edx
  802c81:	89 c8                	mov    %ecx,%eax
  802c83:	83 c4 10             	add    $0x10,%esp
  802c86:	5e                   	pop    %esi
  802c87:	5f                   	pop    %edi
  802c88:	5d                   	pop    %ebp
  802c89:	c3                   	ret    
  802c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802c90:	39 f8                	cmp    %edi,%eax
  802c92:	77 1c                	ja     802cb0 <__udivdi3+0x70>
  802c94:	0f bd d0             	bsr    %eax,%edx
  802c97:	83 f2 1f             	xor    $0x1f,%edx
  802c9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802c9d:	75 39                	jne    802cd8 <__udivdi3+0x98>
  802c9f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802ca2:	0f 86 a0 00 00 00    	jbe    802d48 <__udivdi3+0x108>
  802ca8:	39 f8                	cmp    %edi,%eax
  802caa:	0f 82 98 00 00 00    	jb     802d48 <__udivdi3+0x108>
  802cb0:	31 ff                	xor    %edi,%edi
  802cb2:	31 c9                	xor    %ecx,%ecx
  802cb4:	89 c8                	mov    %ecx,%eax
  802cb6:	89 fa                	mov    %edi,%edx
  802cb8:	83 c4 10             	add    $0x10,%esp
  802cbb:	5e                   	pop    %esi
  802cbc:	5f                   	pop    %edi
  802cbd:	5d                   	pop    %ebp
  802cbe:	c3                   	ret    
  802cbf:	90                   	nop
  802cc0:	89 d1                	mov    %edx,%ecx
  802cc2:	89 fa                	mov    %edi,%edx
  802cc4:	89 c8                	mov    %ecx,%eax
  802cc6:	31 ff                	xor    %edi,%edi
  802cc8:	f7 f6                	div    %esi
  802cca:	89 c1                	mov    %eax,%ecx
  802ccc:	89 fa                	mov    %edi,%edx
  802cce:	89 c8                	mov    %ecx,%eax
  802cd0:	83 c4 10             	add    $0x10,%esp
  802cd3:	5e                   	pop    %esi
  802cd4:	5f                   	pop    %edi
  802cd5:	5d                   	pop    %ebp
  802cd6:	c3                   	ret    
  802cd7:	90                   	nop
  802cd8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802cdc:	89 f2                	mov    %esi,%edx
  802cde:	d3 e0                	shl    %cl,%eax
  802ce0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ce3:	b8 20 00 00 00       	mov    $0x20,%eax
  802ce8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802ceb:	89 c1                	mov    %eax,%ecx
  802ced:	d3 ea                	shr    %cl,%edx
  802cef:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802cf3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802cf6:	d3 e6                	shl    %cl,%esi
  802cf8:	89 c1                	mov    %eax,%ecx
  802cfa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802cfd:	89 fe                	mov    %edi,%esi
  802cff:	d3 ee                	shr    %cl,%esi
  802d01:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d05:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d0b:	d3 e7                	shl    %cl,%edi
  802d0d:	89 c1                	mov    %eax,%ecx
  802d0f:	d3 ea                	shr    %cl,%edx
  802d11:	09 d7                	or     %edx,%edi
  802d13:	89 f2                	mov    %esi,%edx
  802d15:	89 f8                	mov    %edi,%eax
  802d17:	f7 75 ec             	divl   -0x14(%ebp)
  802d1a:	89 d6                	mov    %edx,%esi
  802d1c:	89 c7                	mov    %eax,%edi
  802d1e:	f7 65 e8             	mull   -0x18(%ebp)
  802d21:	39 d6                	cmp    %edx,%esi
  802d23:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d26:	72 30                	jb     802d58 <__udivdi3+0x118>
  802d28:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d2b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d2f:	d3 e2                	shl    %cl,%edx
  802d31:	39 c2                	cmp    %eax,%edx
  802d33:	73 05                	jae    802d3a <__udivdi3+0xfa>
  802d35:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802d38:	74 1e                	je     802d58 <__udivdi3+0x118>
  802d3a:	89 f9                	mov    %edi,%ecx
  802d3c:	31 ff                	xor    %edi,%edi
  802d3e:	e9 71 ff ff ff       	jmp    802cb4 <__udivdi3+0x74>
  802d43:	90                   	nop
  802d44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d48:	31 ff                	xor    %edi,%edi
  802d4a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802d4f:	e9 60 ff ff ff       	jmp    802cb4 <__udivdi3+0x74>
  802d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d58:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802d5b:	31 ff                	xor    %edi,%edi
  802d5d:	89 c8                	mov    %ecx,%eax
  802d5f:	89 fa                	mov    %edi,%edx
  802d61:	83 c4 10             	add    $0x10,%esp
  802d64:	5e                   	pop    %esi
  802d65:	5f                   	pop    %edi
  802d66:	5d                   	pop    %ebp
  802d67:	c3                   	ret    
	...

00802d70 <__umoddi3>:
  802d70:	55                   	push   %ebp
  802d71:	89 e5                	mov    %esp,%ebp
  802d73:	57                   	push   %edi
  802d74:	56                   	push   %esi
  802d75:	83 ec 20             	sub    $0x20,%esp
  802d78:	8b 55 14             	mov    0x14(%ebp),%edx
  802d7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802d7e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802d81:	8b 75 0c             	mov    0xc(%ebp),%esi
  802d84:	85 d2                	test   %edx,%edx
  802d86:	89 c8                	mov    %ecx,%eax
  802d88:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802d8b:	75 13                	jne    802da0 <__umoddi3+0x30>
  802d8d:	39 f7                	cmp    %esi,%edi
  802d8f:	76 3f                	jbe    802dd0 <__umoddi3+0x60>
  802d91:	89 f2                	mov    %esi,%edx
  802d93:	f7 f7                	div    %edi
  802d95:	89 d0                	mov    %edx,%eax
  802d97:	31 d2                	xor    %edx,%edx
  802d99:	83 c4 20             	add    $0x20,%esp
  802d9c:	5e                   	pop    %esi
  802d9d:	5f                   	pop    %edi
  802d9e:	5d                   	pop    %ebp
  802d9f:	c3                   	ret    
  802da0:	39 f2                	cmp    %esi,%edx
  802da2:	77 4c                	ja     802df0 <__umoddi3+0x80>
  802da4:	0f bd ca             	bsr    %edx,%ecx
  802da7:	83 f1 1f             	xor    $0x1f,%ecx
  802daa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802dad:	75 51                	jne    802e00 <__umoddi3+0x90>
  802daf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802db2:	0f 87 e0 00 00 00    	ja     802e98 <__umoddi3+0x128>
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	29 f8                	sub    %edi,%eax
  802dbd:	19 d6                	sbb    %edx,%esi
  802dbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc5:	89 f2                	mov    %esi,%edx
  802dc7:	83 c4 20             	add    $0x20,%esp
  802dca:	5e                   	pop    %esi
  802dcb:	5f                   	pop    %edi
  802dcc:	5d                   	pop    %ebp
  802dcd:	c3                   	ret    
  802dce:	66 90                	xchg   %ax,%ax
  802dd0:	85 ff                	test   %edi,%edi
  802dd2:	75 0b                	jne    802ddf <__umoddi3+0x6f>
  802dd4:	b8 01 00 00 00       	mov    $0x1,%eax
  802dd9:	31 d2                	xor    %edx,%edx
  802ddb:	f7 f7                	div    %edi
  802ddd:	89 c7                	mov    %eax,%edi
  802ddf:	89 f0                	mov    %esi,%eax
  802de1:	31 d2                	xor    %edx,%edx
  802de3:	f7 f7                	div    %edi
  802de5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de8:	f7 f7                	div    %edi
  802dea:	eb a9                	jmp    802d95 <__umoddi3+0x25>
  802dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802df0:	89 c8                	mov    %ecx,%eax
  802df2:	89 f2                	mov    %esi,%edx
  802df4:	83 c4 20             	add    $0x20,%esp
  802df7:	5e                   	pop    %esi
  802df8:	5f                   	pop    %edi
  802df9:	5d                   	pop    %ebp
  802dfa:	c3                   	ret    
  802dfb:	90                   	nop
  802dfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e00:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e04:	d3 e2                	shl    %cl,%edx
  802e06:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e09:	ba 20 00 00 00       	mov    $0x20,%edx
  802e0e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802e11:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802e14:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e18:	89 fa                	mov    %edi,%edx
  802e1a:	d3 ea                	shr    %cl,%edx
  802e1c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e20:	0b 55 f4             	or     -0xc(%ebp),%edx
  802e23:	d3 e7                	shl    %cl,%edi
  802e25:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e29:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e2c:	89 f2                	mov    %esi,%edx
  802e2e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802e31:	89 c7                	mov    %eax,%edi
  802e33:	d3 ea                	shr    %cl,%edx
  802e35:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e39:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802e3c:	89 c2                	mov    %eax,%edx
  802e3e:	d3 e6                	shl    %cl,%esi
  802e40:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e44:	d3 ea                	shr    %cl,%edx
  802e46:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e4a:	09 d6                	or     %edx,%esi
  802e4c:	89 f0                	mov    %esi,%eax
  802e4e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802e51:	d3 e7                	shl    %cl,%edi
  802e53:	89 f2                	mov    %esi,%edx
  802e55:	f7 75 f4             	divl   -0xc(%ebp)
  802e58:	89 d6                	mov    %edx,%esi
  802e5a:	f7 65 e8             	mull   -0x18(%ebp)
  802e5d:	39 d6                	cmp    %edx,%esi
  802e5f:	72 2b                	jb     802e8c <__umoddi3+0x11c>
  802e61:	39 c7                	cmp    %eax,%edi
  802e63:	72 23                	jb     802e88 <__umoddi3+0x118>
  802e65:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e69:	29 c7                	sub    %eax,%edi
  802e6b:	19 d6                	sbb    %edx,%esi
  802e6d:	89 f0                	mov    %esi,%eax
  802e6f:	89 f2                	mov    %esi,%edx
  802e71:	d3 ef                	shr    %cl,%edi
  802e73:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e77:	d3 e0                	shl    %cl,%eax
  802e79:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e7d:	09 f8                	or     %edi,%eax
  802e7f:	d3 ea                	shr    %cl,%edx
  802e81:	83 c4 20             	add    $0x20,%esp
  802e84:	5e                   	pop    %esi
  802e85:	5f                   	pop    %edi
  802e86:	5d                   	pop    %ebp
  802e87:	c3                   	ret    
  802e88:	39 d6                	cmp    %edx,%esi
  802e8a:	75 d9                	jne    802e65 <__umoddi3+0xf5>
  802e8c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802e8f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802e92:	eb d1                	jmp    802e65 <__umoddi3+0xf5>
  802e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e98:	39 f2                	cmp    %esi,%edx
  802e9a:	0f 82 18 ff ff ff    	jb     802db8 <__umoddi3+0x48>
  802ea0:	e9 1d ff ff ff       	jmp    802dc2 <__umoddi3+0x52>
