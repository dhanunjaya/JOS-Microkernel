
obj/user/cat:     file format elf32-i386


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
  80002c:	e8 43 01 00 00       	call   800174 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
  80003d:	8b 75 08             	mov    0x8(%ebp),%esi
  800040:	8b 7d 0c             	mov    0xc(%ebp),%edi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800043:	eb 40                	jmp    800085 <cat+0x51>
		if ((r = write(1, buf, n)) != n)
  800045:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800049:	c7 44 24 04 80 60 80 	movl   $0x806080,0x4(%esp)
  800050:	00 
  800051:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800058:	e8 28 14 00 00       	call   801485 <write>
  80005d:	39 c3                	cmp    %eax,%ebx
  80005f:	74 24                	je     800085 <cat+0x51>
			panic("write error copying %s: %e", s, r);
  800061:	89 44 24 10          	mov    %eax,0x10(%esp)
  800065:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800069:	c7 44 24 08 60 2a 80 	movl   $0x802a60,0x8(%esp)
  800070:	00 
  800071:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
  800078:	00 
  800079:	c7 04 24 7b 2a 80 00 	movl   $0x802a7b,(%esp)
  800080:	e8 5b 01 00 00       	call   8001e0 <_panic>
cat(int f, char *s)
{
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  800085:	c7 44 24 08 00 20 00 	movl   $0x2000,0x8(%esp)
  80008c:	00 
  80008d:	c7 44 24 04 80 60 80 	movl   $0x806080,0x4(%esp)
  800094:	00 
  800095:	89 34 24             	mov    %esi,(%esp)
  800098:	e8 71 14 00 00       	call   80150e <read>
  80009d:	89 c3                	mov    %eax,%ebx
  80009f:	85 c0                	test   %eax,%eax
  8000a1:	7f a2                	jg     800045 <cat+0x11>
		if ((r = write(1, buf, n)) != n)
			panic("write error copying %s: %e", s, r);
	if (n < 0)
  8000a3:	85 c0                	test   %eax,%eax
  8000a5:	79 24                	jns    8000cb <cat+0x97>
		panic("error reading %s: %e", s, n);
  8000a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000ab:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000af:	c7 44 24 08 86 2a 80 	movl   $0x802a86,0x8(%esp)
  8000b6:	00 
  8000b7:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000be:	00 
  8000bf:	c7 04 24 7b 2a 80 00 	movl   $0x802a7b,(%esp)
  8000c6:	e8 15 01 00 00       	call   8001e0 <_panic>
}
  8000cb:	83 c4 2c             	add    $0x2c,%esp
  8000ce:	5b                   	pop    %ebx
  8000cf:	5e                   	pop    %esi
  8000d0:	5f                   	pop    %edi
  8000d1:	5d                   	pop    %ebp
  8000d2:	c3                   	ret    

008000d3 <umain>:

void
umain(int argc, char **argv)
{
  8000d3:	55                   	push   %ebp
  8000d4:	89 e5                	mov    %esp,%ebp
  8000d6:	57                   	push   %edi
  8000d7:	56                   	push   %esi
  8000d8:	53                   	push   %ebx
  8000d9:	83 ec 2c             	sub    $0x2c,%esp
  8000dc:	8b 75 0c             	mov    0xc(%ebp),%esi
	int f, i;

	argv0 = "cat";
  8000df:	c7 05 84 80 80 00 9b 	movl   $0x802a9b,0x808084
  8000e6:	2a 80 00 
	if (argc == 1)
  8000e9:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000ed:	74 0d                	je     8000fc <umain+0x29>
		cat(0, "<stdin>");
  8000ef:	bb 01 00 00 00       	mov    $0x1,%ebx
	else
		for (i = 1; i < argc; i++) {
  8000f4:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000f8:	7f 18                	jg     800112 <umain+0x3f>
  8000fa:	eb 70                	jmp    80016c <umain+0x99>
{
	int f, i;

	argv0 = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
  8000fc:	c7 44 24 04 9f 2a 80 	movl   $0x802a9f,0x4(%esp)
  800103:	00 
  800104:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80010b:	e8 24 ff ff ff       	call   800034 <cat>
  800110:	eb 5a                	jmp    80016c <umain+0x99>
	if (n < 0)
		panic("error reading %s: %e", s, n);
}

void
umain(int argc, char **argv)
  800112:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	argv0 = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  800115:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80011c:	00 
  80011d:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  800120:	89 04 24             	mov    %eax,(%esp)
  800123:	e8 3f 19 00 00       	call   801a67 <open>
  800128:	89 c7                	mov    %eax,%edi
			if (f < 0)
  80012a:	85 c0                	test   %eax,%eax
  80012c:	79 1c                	jns    80014a <umain+0x77>
				printf("can't open %s: %e\n", argv[i], f);
  80012e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800132:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800135:	8b 04 96             	mov    (%esi,%edx,4),%eax
  800138:	89 44 24 04          	mov    %eax,0x4(%esp)
  80013c:	c7 04 24 a7 2a 80 00 	movl   $0x802aa7,(%esp)
  800143:	e8 af 1a 00 00       	call   801bf7 <printf>
  800148:	eb 1a                	jmp    800164 <umain+0x91>
			else {
				cat(f, argv[i]);
  80014a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80014d:	8b 04 96             	mov    (%esi,%edx,4),%eax
  800150:	89 44 24 04          	mov    %eax,0x4(%esp)
  800154:	89 3c 24             	mov    %edi,(%esp)
  800157:	e8 d8 fe ff ff       	call   800034 <cat>
				close(f);
  80015c:	89 3c 24             	mov    %edi,(%esp)
  80015f:	e8 0a 15 00 00       	call   80166e <close>

	argv0 = "cat";
	if (argc == 1)
		cat(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800164:	83 c3 01             	add    $0x1,%ebx
  800167:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  80016a:	7f a6                	jg     800112 <umain+0x3f>
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  80016c:	83 c4 2c             	add    $0x2c,%esp
  80016f:	5b                   	pop    %ebx
  800170:	5e                   	pop    %esi
  800171:	5f                   	pop    %edi
  800172:	5d                   	pop    %ebp
  800173:	c3                   	ret    

00800174 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800174:	55                   	push   %ebp
  800175:	89 e5                	mov    %esp,%ebp
  800177:	83 ec 18             	sub    $0x18,%esp
  80017a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80017d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800180:	8b 75 08             	mov    0x8(%ebp),%esi
  800183:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  800186:	e8 ee 0f 00 00       	call   801179 <sys_getenvid>
  80018b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800190:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800193:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800198:	a3 80 80 80 00       	mov    %eax,0x808080

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80019d:	85 f6                	test   %esi,%esi
  80019f:	7e 07                	jle    8001a8 <libmain+0x34>
		binaryname = argv[0];
  8001a1:	8b 03                	mov    (%ebx),%eax
  8001a3:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  8001a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001ac:	89 34 24             	mov    %esi,(%esp)
  8001af:	e8 1f ff ff ff       	call   8000d3 <umain>

	// exit gracefully
	exit();
  8001b4:	e8 0b 00 00 00       	call   8001c4 <exit>
}
  8001b9:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8001bc:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8001bf:	89 ec                	mov    %ebp,%esp
  8001c1:	5d                   	pop    %ebp
  8001c2:	c3                   	ret    
	...

008001c4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001c4:	55                   	push   %ebp
  8001c5:	89 e5                	mov    %esp,%ebp
  8001c7:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001ca:	e8 1c 15 00 00       	call   8016eb <close_all>
	sys_env_destroy(0);
  8001cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001d6:	e8 d2 0f 00 00       	call   8011ad <sys_env_destroy>
}
  8001db:	c9                   	leave  
  8001dc:	c3                   	ret    
  8001dd:	00 00                	add    %al,(%eax)
	...

008001e0 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001e0:	55                   	push   %ebp
  8001e1:	89 e5                	mov    %esp,%ebp
  8001e3:	53                   	push   %ebx
  8001e4:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  8001e7:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  8001ea:	a1 84 80 80 00       	mov    0x808084,%eax
  8001ef:	85 c0                	test   %eax,%eax
  8001f1:	74 10                	je     800203 <_panic+0x23>
		cprintf("%s: ", argv0);
  8001f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001f7:	c7 04 24 d1 2a 80 00 	movl   $0x802ad1,(%esp)
  8001fe:	e8 a2 00 00 00       	call   8002a5 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800203:	8b 45 0c             	mov    0xc(%ebp),%eax
  800206:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80020a:	8b 45 08             	mov    0x8(%ebp),%eax
  80020d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800211:	a1 00 60 80 00       	mov    0x806000,%eax
  800216:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021a:	c7 04 24 d6 2a 80 00 	movl   $0x802ad6,(%esp)
  800221:	e8 7f 00 00 00       	call   8002a5 <cprintf>
	vcprintf(fmt, ap);
  800226:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80022a:	8b 45 10             	mov    0x10(%ebp),%eax
  80022d:	89 04 24             	mov    %eax,(%esp)
  800230:	e8 0f 00 00 00       	call   800244 <vcprintf>
	cprintf("\n");
  800235:	c7 04 24 29 2f 80 00 	movl   $0x802f29,(%esp)
  80023c:	e8 64 00 00 00       	call   8002a5 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800241:	cc                   	int3   
  800242:	eb fd                	jmp    800241 <_panic+0x61>

00800244 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  80024d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800254:	00 00 00 
	b.cnt = 0;
  800257:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80025e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800261:	8b 45 0c             	mov    0xc(%ebp),%eax
  800264:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800268:	8b 45 08             	mov    0x8(%ebp),%eax
  80026b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800275:	89 44 24 04          	mov    %eax,0x4(%esp)
  800279:	c7 04 24 bf 02 80 00 	movl   $0x8002bf,(%esp)
  800280:	e8 d8 01 00 00       	call   80045d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800285:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80028b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80028f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800295:	89 04 24             	mov    %eax,(%esp)
  800298:	e8 e3 0a 00 00       	call   800d80 <sys_cputs>

	return b.cnt;
}
  80029d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002a3:	c9                   	leave  
  8002a4:	c3                   	ret    

008002a5 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8002ab:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8002ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b5:	89 04 24             	mov    %eax,(%esp)
  8002b8:	e8 87 ff ff ff       	call   800244 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002bd:	c9                   	leave  
  8002be:	c3                   	ret    

008002bf <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	53                   	push   %ebx
  8002c3:	83 ec 14             	sub    $0x14,%esp
  8002c6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002c9:	8b 03                	mov    (%ebx),%eax
  8002cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ce:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002d2:	83 c0 01             	add    $0x1,%eax
  8002d5:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002d7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002dc:	75 19                	jne    8002f7 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002de:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002e5:	00 
  8002e6:	8d 43 08             	lea    0x8(%ebx),%eax
  8002e9:	89 04 24             	mov    %eax,(%esp)
  8002ec:	e8 8f 0a 00 00       	call   800d80 <sys_cputs>
		b->idx = 0;
  8002f1:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002f7:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002fb:	83 c4 14             	add    $0x14,%esp
  8002fe:	5b                   	pop    %ebx
  8002ff:	5d                   	pop    %ebp
  800300:	c3                   	ret    
	...

00800310 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	57                   	push   %edi
  800314:	56                   	push   %esi
  800315:	53                   	push   %ebx
  800316:	83 ec 4c             	sub    $0x4c,%esp
  800319:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80031c:	89 d6                	mov    %edx,%esi
  80031e:	8b 45 08             	mov    0x8(%ebp),%eax
  800321:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800324:	8b 55 0c             	mov    0xc(%ebp),%edx
  800327:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80032a:	8b 45 10             	mov    0x10(%ebp),%eax
  80032d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800330:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800333:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800336:	b9 00 00 00 00       	mov    $0x0,%ecx
  80033b:	39 d1                	cmp    %edx,%ecx
  80033d:	72 15                	jb     800354 <printnum+0x44>
  80033f:	77 07                	ja     800348 <printnum+0x38>
  800341:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800344:	39 d0                	cmp    %edx,%eax
  800346:	76 0c                	jbe    800354 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800348:	83 eb 01             	sub    $0x1,%ebx
  80034b:	85 db                	test   %ebx,%ebx
  80034d:	8d 76 00             	lea    0x0(%esi),%esi
  800350:	7f 61                	jg     8003b3 <printnum+0xa3>
  800352:	eb 70                	jmp    8003c4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800354:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800358:	83 eb 01             	sub    $0x1,%ebx
  80035b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80035f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800363:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800367:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80036b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80036e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800371:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800374:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800378:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80037f:	00 
  800380:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800383:	89 04 24             	mov    %eax,(%esp)
  800386:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800389:	89 54 24 04          	mov    %edx,0x4(%esp)
  80038d:	e8 5e 24 00 00       	call   8027f0 <__udivdi3>
  800392:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800395:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800398:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80039c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003a0:	89 04 24             	mov    %eax,(%esp)
  8003a3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003a7:	89 f2                	mov    %esi,%edx
  8003a9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ac:	e8 5f ff ff ff       	call   800310 <printnum>
  8003b1:	eb 11                	jmp    8003c4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003b7:	89 3c 24             	mov    %edi,(%esp)
  8003ba:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003bd:	83 eb 01             	sub    $0x1,%ebx
  8003c0:	85 db                	test   %ebx,%ebx
  8003c2:	7f ef                	jg     8003b3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003c4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003c8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8003cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003d3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003da:	00 
  8003db:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003de:	89 14 24             	mov    %edx,(%esp)
  8003e1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003e4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003e8:	e8 33 25 00 00       	call   802920 <__umoddi3>
  8003ed:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003f1:	0f be 80 f2 2a 80 00 	movsbl 0x802af2(%eax),%eax
  8003f8:	89 04 24             	mov    %eax,(%esp)
  8003fb:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8003fe:	83 c4 4c             	add    $0x4c,%esp
  800401:	5b                   	pop    %ebx
  800402:	5e                   	pop    %esi
  800403:	5f                   	pop    %edi
  800404:	5d                   	pop    %ebp
  800405:	c3                   	ret    

00800406 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800409:	83 fa 01             	cmp    $0x1,%edx
  80040c:	7e 0e                	jle    80041c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80040e:	8b 10                	mov    (%eax),%edx
  800410:	8d 4a 08             	lea    0x8(%edx),%ecx
  800413:	89 08                	mov    %ecx,(%eax)
  800415:	8b 02                	mov    (%edx),%eax
  800417:	8b 52 04             	mov    0x4(%edx),%edx
  80041a:	eb 22                	jmp    80043e <getuint+0x38>
	else if (lflag)
  80041c:	85 d2                	test   %edx,%edx
  80041e:	74 10                	je     800430 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800420:	8b 10                	mov    (%eax),%edx
  800422:	8d 4a 04             	lea    0x4(%edx),%ecx
  800425:	89 08                	mov    %ecx,(%eax)
  800427:	8b 02                	mov    (%edx),%eax
  800429:	ba 00 00 00 00       	mov    $0x0,%edx
  80042e:	eb 0e                	jmp    80043e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800430:	8b 10                	mov    (%eax),%edx
  800432:	8d 4a 04             	lea    0x4(%edx),%ecx
  800435:	89 08                	mov    %ecx,(%eax)
  800437:	8b 02                	mov    (%edx),%eax
  800439:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80043e:	5d                   	pop    %ebp
  80043f:	c3                   	ret    

00800440 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
  800443:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800446:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80044a:	8b 10                	mov    (%eax),%edx
  80044c:	3b 50 04             	cmp    0x4(%eax),%edx
  80044f:	73 0a                	jae    80045b <sprintputch+0x1b>
		*b->buf++ = ch;
  800451:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800454:	88 0a                	mov    %cl,(%edx)
  800456:	83 c2 01             	add    $0x1,%edx
  800459:	89 10                	mov    %edx,(%eax)
}
  80045b:	5d                   	pop    %ebp
  80045c:	c3                   	ret    

0080045d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80045d:	55                   	push   %ebp
  80045e:	89 e5                	mov    %esp,%ebp
  800460:	57                   	push   %edi
  800461:	56                   	push   %esi
  800462:	53                   	push   %ebx
  800463:	83 ec 5c             	sub    $0x5c,%esp
  800466:	8b 7d 08             	mov    0x8(%ebp),%edi
  800469:	8b 75 0c             	mov    0xc(%ebp),%esi
  80046c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80046f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800476:	eb 11                	jmp    800489 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800478:	85 c0                	test   %eax,%eax
  80047a:	0f 84 09 04 00 00    	je     800889 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  800480:	89 74 24 04          	mov    %esi,0x4(%esp)
  800484:	89 04 24             	mov    %eax,(%esp)
  800487:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800489:	0f b6 03             	movzbl (%ebx),%eax
  80048c:	83 c3 01             	add    $0x1,%ebx
  80048f:	83 f8 25             	cmp    $0x25,%eax
  800492:	75 e4                	jne    800478 <vprintfmt+0x1b>
  800494:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800498:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80049f:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8004a6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004b2:	eb 06                	jmp    8004ba <vprintfmt+0x5d>
  8004b4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8004b8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	0f b6 13             	movzbl (%ebx),%edx
  8004bd:	0f b6 c2             	movzbl %dl,%eax
  8004c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004c3:	8d 43 01             	lea    0x1(%ebx),%eax
  8004c6:	83 ea 23             	sub    $0x23,%edx
  8004c9:	80 fa 55             	cmp    $0x55,%dl
  8004cc:	0f 87 9a 03 00 00    	ja     80086c <vprintfmt+0x40f>
  8004d2:	0f b6 d2             	movzbl %dl,%edx
  8004d5:	ff 24 95 40 2c 80 00 	jmp    *0x802c40(,%edx,4)
  8004dc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8004e0:	eb d6                	jmp    8004b8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004e5:	83 ea 30             	sub    $0x30,%edx
  8004e8:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  8004eb:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8004ee:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8004f1:	83 fb 09             	cmp    $0x9,%ebx
  8004f4:	77 4c                	ja     800542 <vprintfmt+0xe5>
  8004f6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004f9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004fc:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8004ff:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800502:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800506:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800509:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80050c:	83 fb 09             	cmp    $0x9,%ebx
  80050f:	76 eb                	jbe    8004fc <vprintfmt+0x9f>
  800511:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800514:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800517:	eb 29                	jmp    800542 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800519:	8b 55 14             	mov    0x14(%ebp),%edx
  80051c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80051f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800522:	8b 12                	mov    (%edx),%edx
  800524:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  800527:	eb 19                	jmp    800542 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800529:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80052c:	c1 fa 1f             	sar    $0x1f,%edx
  80052f:	f7 d2                	not    %edx
  800531:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800534:	eb 82                	jmp    8004b8 <vprintfmt+0x5b>
  800536:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80053d:	e9 76 ff ff ff       	jmp    8004b8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800542:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800546:	0f 89 6c ff ff ff    	jns    8004b8 <vprintfmt+0x5b>
  80054c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80054f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800552:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800555:	89 55 cc             	mov    %edx,-0x34(%ebp)
  800558:	e9 5b ff ff ff       	jmp    8004b8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80055d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800560:	e9 53 ff ff ff       	jmp    8004b8 <vprintfmt+0x5b>
  800565:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800568:	8b 45 14             	mov    0x14(%ebp),%eax
  80056b:	8d 50 04             	lea    0x4(%eax),%edx
  80056e:	89 55 14             	mov    %edx,0x14(%ebp)
  800571:	89 74 24 04          	mov    %esi,0x4(%esp)
  800575:	8b 00                	mov    (%eax),%eax
  800577:	89 04 24             	mov    %eax,(%esp)
  80057a:	ff d7                	call   *%edi
  80057c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80057f:	e9 05 ff ff ff       	jmp    800489 <vprintfmt+0x2c>
  800584:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8d 50 04             	lea    0x4(%eax),%edx
  80058d:	89 55 14             	mov    %edx,0x14(%ebp)
  800590:	8b 00                	mov    (%eax),%eax
  800592:	89 c2                	mov    %eax,%edx
  800594:	c1 fa 1f             	sar    $0x1f,%edx
  800597:	31 d0                	xor    %edx,%eax
  800599:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80059b:	83 f8 0f             	cmp    $0xf,%eax
  80059e:	7f 0b                	jg     8005ab <vprintfmt+0x14e>
  8005a0:	8b 14 85 a0 2d 80 00 	mov    0x802da0(,%eax,4),%edx
  8005a7:	85 d2                	test   %edx,%edx
  8005a9:	75 20                	jne    8005cb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8005ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005af:	c7 44 24 08 03 2b 80 	movl   $0x802b03,0x8(%esp)
  8005b6:	00 
  8005b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005bb:	89 3c 24             	mov    %edi,(%esp)
  8005be:	e8 4e 03 00 00       	call   800911 <printfmt>
  8005c3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005c6:	e9 be fe ff ff       	jmp    800489 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005cb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005cf:	c7 44 24 08 ed 2e 80 	movl   $0x802eed,0x8(%esp)
  8005d6:	00 
  8005d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005db:	89 3c 24             	mov    %edi,(%esp)
  8005de:	e8 2e 03 00 00       	call   800911 <printfmt>
  8005e3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005e6:	e9 9e fe ff ff       	jmp    800489 <vprintfmt+0x2c>
  8005eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ee:	89 c3                	mov    %eax,%ebx
  8005f0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8005f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005f6:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fc:	8d 50 04             	lea    0x4(%eax),%edx
  8005ff:	89 55 14             	mov    %edx,0x14(%ebp)
  800602:	8b 00                	mov    (%eax),%eax
  800604:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800607:	85 c0                	test   %eax,%eax
  800609:	75 07                	jne    800612 <vprintfmt+0x1b5>
  80060b:	c7 45 c4 0c 2b 80 00 	movl   $0x802b0c,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800612:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  800616:	7e 06                	jle    80061e <vprintfmt+0x1c1>
  800618:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80061c:	75 13                	jne    800631 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800621:	0f be 02             	movsbl (%edx),%eax
  800624:	85 c0                	test   %eax,%eax
  800626:	0f 85 99 00 00 00    	jne    8006c5 <vprintfmt+0x268>
  80062c:	e9 86 00 00 00       	jmp    8006b7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800631:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800635:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800638:	89 0c 24             	mov    %ecx,(%esp)
  80063b:	e8 1b 03 00 00       	call   80095b <strnlen>
  800640:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800643:	29 c2                	sub    %eax,%edx
  800645:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800648:	85 d2                	test   %edx,%edx
  80064a:	7e d2                	jle    80061e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80064c:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  800650:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800653:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  800656:	89 d3                	mov    %edx,%ebx
  800658:	89 74 24 04          	mov    %esi,0x4(%esp)
  80065c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80065f:	89 04 24             	mov    %eax,(%esp)
  800662:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800664:	83 eb 01             	sub    $0x1,%ebx
  800667:	85 db                	test   %ebx,%ebx
  800669:	7f ed                	jg     800658 <vprintfmt+0x1fb>
  80066b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80066e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800675:	eb a7                	jmp    80061e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800677:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80067b:	74 18                	je     800695 <vprintfmt+0x238>
  80067d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800680:	83 fa 5e             	cmp    $0x5e,%edx
  800683:	76 10                	jbe    800695 <vprintfmt+0x238>
					putch('?', putdat);
  800685:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800689:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800690:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800693:	eb 0a                	jmp    80069f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800695:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800699:	89 04 24             	mov    %eax,(%esp)
  80069c:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80069f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8006a3:	0f be 03             	movsbl (%ebx),%eax
  8006a6:	85 c0                	test   %eax,%eax
  8006a8:	74 05                	je     8006af <vprintfmt+0x252>
  8006aa:	83 c3 01             	add    $0x1,%ebx
  8006ad:	eb 29                	jmp    8006d8 <vprintfmt+0x27b>
  8006af:	89 fe                	mov    %edi,%esi
  8006b1:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006b4:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006bb:	7f 2e                	jg     8006eb <vprintfmt+0x28e>
  8006bd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006c0:	e9 c4 fd ff ff       	jmp    800489 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006c5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006c8:	83 c2 01             	add    $0x1,%edx
  8006cb:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8006ce:	89 f7                	mov    %esi,%edi
  8006d0:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006d3:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  8006d6:	89 d3                	mov    %edx,%ebx
  8006d8:	85 f6                	test   %esi,%esi
  8006da:	78 9b                	js     800677 <vprintfmt+0x21a>
  8006dc:	83 ee 01             	sub    $0x1,%esi
  8006df:	79 96                	jns    800677 <vprintfmt+0x21a>
  8006e1:	89 fe                	mov    %edi,%esi
  8006e3:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006e6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8006e9:	eb cc                	jmp    8006b7 <vprintfmt+0x25a>
  8006eb:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8006ee:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006f1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006f5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006fc:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006fe:	83 eb 01             	sub    $0x1,%ebx
  800701:	85 db                	test   %ebx,%ebx
  800703:	7f ec                	jg     8006f1 <vprintfmt+0x294>
  800705:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800708:	e9 7c fd ff ff       	jmp    800489 <vprintfmt+0x2c>
  80070d:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800710:	83 f9 01             	cmp    $0x1,%ecx
  800713:	7e 16                	jle    80072b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8d 50 08             	lea    0x8(%eax),%edx
  80071b:	89 55 14             	mov    %edx,0x14(%ebp)
  80071e:	8b 10                	mov    (%eax),%edx
  800720:	8b 48 04             	mov    0x4(%eax),%ecx
  800723:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800726:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800729:	eb 32                	jmp    80075d <vprintfmt+0x300>
	else if (lflag)
  80072b:	85 c9                	test   %ecx,%ecx
  80072d:	74 18                	je     800747 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80072f:	8b 45 14             	mov    0x14(%ebp),%eax
  800732:	8d 50 04             	lea    0x4(%eax),%edx
  800735:	89 55 14             	mov    %edx,0x14(%ebp)
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80073d:	89 c1                	mov    %eax,%ecx
  80073f:	c1 f9 1f             	sar    $0x1f,%ecx
  800742:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800745:	eb 16                	jmp    80075d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800747:	8b 45 14             	mov    0x14(%ebp),%eax
  80074a:	8d 50 04             	lea    0x4(%eax),%edx
  80074d:	89 55 14             	mov    %edx,0x14(%ebp)
  800750:	8b 00                	mov    (%eax),%eax
  800752:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800755:	89 c2                	mov    %eax,%edx
  800757:	c1 fa 1f             	sar    $0x1f,%edx
  80075a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80075d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800760:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800763:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800768:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80076c:	0f 89 b8 00 00 00    	jns    80082a <vprintfmt+0x3cd>
				putch('-', putdat);
  800772:	89 74 24 04          	mov    %esi,0x4(%esp)
  800776:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80077d:	ff d7                	call   *%edi
				num = -(long long) num;
  80077f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800782:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800785:	f7 d9                	neg    %ecx
  800787:	83 d3 00             	adc    $0x0,%ebx
  80078a:	f7 db                	neg    %ebx
  80078c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800791:	e9 94 00 00 00       	jmp    80082a <vprintfmt+0x3cd>
  800796:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800799:	89 ca                	mov    %ecx,%edx
  80079b:	8d 45 14             	lea    0x14(%ebp),%eax
  80079e:	e8 63 fc ff ff       	call   800406 <getuint>
  8007a3:	89 c1                	mov    %eax,%ecx
  8007a5:	89 d3                	mov    %edx,%ebx
  8007a7:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8007ac:	eb 7c                	jmp    80082a <vprintfmt+0x3cd>
  8007ae:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007b1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007b5:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8007bc:	ff d7                	call   *%edi
			putch('X', putdat);
  8007be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007c2:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8007c9:	ff d7                	call   *%edi
			putch('X', putdat);
  8007cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007cf:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8007d6:	ff d7                	call   *%edi
  8007d8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8007db:	e9 a9 fc ff ff       	jmp    800489 <vprintfmt+0x2c>
  8007e0:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8007e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007e7:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007ee:	ff d7                	call   *%edi
			putch('x', putdat);
  8007f0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007f4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007fb:	ff d7                	call   *%edi
			num = (unsigned long long)
  8007fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800800:	8d 50 04             	lea    0x4(%eax),%edx
  800803:	89 55 14             	mov    %edx,0x14(%ebp)
  800806:	8b 08                	mov    (%eax),%ecx
  800808:	bb 00 00 00 00       	mov    $0x0,%ebx
  80080d:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800812:	eb 16                	jmp    80082a <vprintfmt+0x3cd>
  800814:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800817:	89 ca                	mov    %ecx,%edx
  800819:	8d 45 14             	lea    0x14(%ebp),%eax
  80081c:	e8 e5 fb ff ff       	call   800406 <getuint>
  800821:	89 c1                	mov    %eax,%ecx
  800823:	89 d3                	mov    %edx,%ebx
  800825:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80082a:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  80082e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800832:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800835:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800839:	89 44 24 08          	mov    %eax,0x8(%esp)
  80083d:	89 0c 24             	mov    %ecx,(%esp)
  800840:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800844:	89 f2                	mov    %esi,%edx
  800846:	89 f8                	mov    %edi,%eax
  800848:	e8 c3 fa ff ff       	call   800310 <printnum>
  80084d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800850:	e9 34 fc ff ff       	jmp    800489 <vprintfmt+0x2c>
  800855:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800858:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80085b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80085f:	89 14 24             	mov    %edx,(%esp)
  800862:	ff d7                	call   *%edi
  800864:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800867:	e9 1d fc ff ff       	jmp    800489 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80086c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800870:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800877:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800879:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80087c:	80 38 25             	cmpb   $0x25,(%eax)
  80087f:	0f 84 04 fc ff ff    	je     800489 <vprintfmt+0x2c>
  800885:	89 c3                	mov    %eax,%ebx
  800887:	eb f0                	jmp    800879 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  800889:	83 c4 5c             	add    $0x5c,%esp
  80088c:	5b                   	pop    %ebx
  80088d:	5e                   	pop    %esi
  80088e:	5f                   	pop    %edi
  80088f:	5d                   	pop    %ebp
  800890:	c3                   	ret    

00800891 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800891:	55                   	push   %ebp
  800892:	89 e5                	mov    %esp,%ebp
  800894:	83 ec 28             	sub    $0x28,%esp
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  80089d:	85 c0                	test   %eax,%eax
  80089f:	74 04                	je     8008a5 <vsnprintf+0x14>
  8008a1:	85 d2                	test   %edx,%edx
  8008a3:	7f 07                	jg     8008ac <vsnprintf+0x1b>
  8008a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008aa:	eb 3b                	jmp    8008e7 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008af:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8008b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d2:	c7 04 24 40 04 80 00 	movl   $0x800440,(%esp)
  8008d9:	e8 7f fb ff ff       	call   80045d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008e7:	c9                   	leave  
  8008e8:	c3                   	ret    

008008e9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008e9:	55                   	push   %ebp
  8008ea:	89 e5                	mov    %esp,%ebp
  8008ec:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8008ef:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8008f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800900:	89 44 24 04          	mov    %eax,0x4(%esp)
  800904:	8b 45 08             	mov    0x8(%ebp),%eax
  800907:	89 04 24             	mov    %eax,(%esp)
  80090a:	e8 82 ff ff ff       	call   800891 <vsnprintf>
	va_end(ap);

	return rc;
}
  80090f:	c9                   	leave  
  800910:	c3                   	ret    

00800911 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800911:	55                   	push   %ebp
  800912:	89 e5                	mov    %esp,%ebp
  800914:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800917:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80091a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80091e:	8b 45 10             	mov    0x10(%ebp),%eax
  800921:	89 44 24 08          	mov    %eax,0x8(%esp)
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	89 44 24 04          	mov    %eax,0x4(%esp)
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	89 04 24             	mov    %eax,(%esp)
  800932:	e8 26 fb ff ff       	call   80045d <vprintfmt>
	va_end(ap);
}
  800937:	c9                   	leave  
  800938:	c3                   	ret    
  800939:	00 00                	add    %al,(%eax)
  80093b:	00 00                	add    %al,(%eax)
  80093d:	00 00                	add    %al,(%eax)
	...

00800940 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800946:	b8 00 00 00 00       	mov    $0x0,%eax
  80094b:	80 3a 00             	cmpb   $0x0,(%edx)
  80094e:	74 09                	je     800959 <strlen+0x19>
		n++;
  800950:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800953:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800957:	75 f7                	jne    800950 <strlen+0x10>
		n++;
	return n;
}
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	53                   	push   %ebx
  80095f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800962:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800965:	85 c9                	test   %ecx,%ecx
  800967:	74 19                	je     800982 <strnlen+0x27>
  800969:	80 3b 00             	cmpb   $0x0,(%ebx)
  80096c:	74 14                	je     800982 <strnlen+0x27>
  80096e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800973:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800976:	39 c8                	cmp    %ecx,%eax
  800978:	74 0d                	je     800987 <strnlen+0x2c>
  80097a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80097e:	75 f3                	jne    800973 <strnlen+0x18>
  800980:	eb 05                	jmp    800987 <strnlen+0x2c>
  800982:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800987:	5b                   	pop    %ebx
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	53                   	push   %ebx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800994:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800999:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80099d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009a0:	83 c2 01             	add    $0x1,%edx
  8009a3:	84 c9                	test   %cl,%cl
  8009a5:	75 f2                	jne    800999 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009a7:	5b                   	pop    %ebx
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	56                   	push   %esi
  8009ae:	53                   	push   %ebx
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009b8:	85 f6                	test   %esi,%esi
  8009ba:	74 18                	je     8009d4 <strncpy+0x2a>
  8009bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8009c1:	0f b6 1a             	movzbl (%edx),%ebx
  8009c4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009c7:	80 3a 01             	cmpb   $0x1,(%edx)
  8009ca:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009cd:	83 c1 01             	add    $0x1,%ecx
  8009d0:	39 ce                	cmp    %ecx,%esi
  8009d2:	77 ed                	ja     8009c1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009d4:	5b                   	pop    %ebx
  8009d5:	5e                   	pop    %esi
  8009d6:	5d                   	pop    %ebp
  8009d7:	c3                   	ret    

008009d8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009d8:	55                   	push   %ebp
  8009d9:	89 e5                	mov    %esp,%ebp
  8009db:	56                   	push   %esi
  8009dc:	53                   	push   %ebx
  8009dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8009e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009e6:	89 f0                	mov    %esi,%eax
  8009e8:	85 c9                	test   %ecx,%ecx
  8009ea:	74 27                	je     800a13 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  8009ec:	83 e9 01             	sub    $0x1,%ecx
  8009ef:	74 1d                	je     800a0e <strlcpy+0x36>
  8009f1:	0f b6 1a             	movzbl (%edx),%ebx
  8009f4:	84 db                	test   %bl,%bl
  8009f6:	74 16                	je     800a0e <strlcpy+0x36>
			*dst++ = *src++;
  8009f8:	88 18                	mov    %bl,(%eax)
  8009fa:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009fd:	83 e9 01             	sub    $0x1,%ecx
  800a00:	74 0e                	je     800a10 <strlcpy+0x38>
			*dst++ = *src++;
  800a02:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a05:	0f b6 1a             	movzbl (%edx),%ebx
  800a08:	84 db                	test   %bl,%bl
  800a0a:	75 ec                	jne    8009f8 <strlcpy+0x20>
  800a0c:	eb 02                	jmp    800a10 <strlcpy+0x38>
  800a0e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800a10:	c6 00 00             	movb   $0x0,(%eax)
  800a13:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800a15:	5b                   	pop    %ebx
  800a16:	5e                   	pop    %esi
  800a17:	5d                   	pop    %ebp
  800a18:	c3                   	ret    

00800a19 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a19:	55                   	push   %ebp
  800a1a:	89 e5                	mov    %esp,%ebp
  800a1c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a1f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a22:	0f b6 01             	movzbl (%ecx),%eax
  800a25:	84 c0                	test   %al,%al
  800a27:	74 15                	je     800a3e <strcmp+0x25>
  800a29:	3a 02                	cmp    (%edx),%al
  800a2b:	75 11                	jne    800a3e <strcmp+0x25>
		p++, q++;
  800a2d:	83 c1 01             	add    $0x1,%ecx
  800a30:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a33:	0f b6 01             	movzbl (%ecx),%eax
  800a36:	84 c0                	test   %al,%al
  800a38:	74 04                	je     800a3e <strcmp+0x25>
  800a3a:	3a 02                	cmp    (%edx),%al
  800a3c:	74 ef                	je     800a2d <strcmp+0x14>
  800a3e:	0f b6 c0             	movzbl %al,%eax
  800a41:	0f b6 12             	movzbl (%edx),%edx
  800a44:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a46:	5d                   	pop    %ebp
  800a47:	c3                   	ret    

00800a48 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a48:	55                   	push   %ebp
  800a49:	89 e5                	mov    %esp,%ebp
  800a4b:	53                   	push   %ebx
  800a4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a52:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800a55:	85 c0                	test   %eax,%eax
  800a57:	74 23                	je     800a7c <strncmp+0x34>
  800a59:	0f b6 1a             	movzbl (%edx),%ebx
  800a5c:	84 db                	test   %bl,%bl
  800a5e:	74 24                	je     800a84 <strncmp+0x3c>
  800a60:	3a 19                	cmp    (%ecx),%bl
  800a62:	75 20                	jne    800a84 <strncmp+0x3c>
  800a64:	83 e8 01             	sub    $0x1,%eax
  800a67:	74 13                	je     800a7c <strncmp+0x34>
		n--, p++, q++;
  800a69:	83 c2 01             	add    $0x1,%edx
  800a6c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a6f:	0f b6 1a             	movzbl (%edx),%ebx
  800a72:	84 db                	test   %bl,%bl
  800a74:	74 0e                	je     800a84 <strncmp+0x3c>
  800a76:	3a 19                	cmp    (%ecx),%bl
  800a78:	74 ea                	je     800a64 <strncmp+0x1c>
  800a7a:	eb 08                	jmp    800a84 <strncmp+0x3c>
  800a7c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a81:	5b                   	pop    %ebx
  800a82:	5d                   	pop    %ebp
  800a83:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a84:	0f b6 02             	movzbl (%edx),%eax
  800a87:	0f b6 11             	movzbl (%ecx),%edx
  800a8a:	29 d0                	sub    %edx,%eax
  800a8c:	eb f3                	jmp    800a81 <strncmp+0x39>

00800a8e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a8e:	55                   	push   %ebp
  800a8f:	89 e5                	mov    %esp,%ebp
  800a91:	8b 45 08             	mov    0x8(%ebp),%eax
  800a94:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a98:	0f b6 10             	movzbl (%eax),%edx
  800a9b:	84 d2                	test   %dl,%dl
  800a9d:	74 15                	je     800ab4 <strchr+0x26>
		if (*s == c)
  800a9f:	38 ca                	cmp    %cl,%dl
  800aa1:	75 07                	jne    800aaa <strchr+0x1c>
  800aa3:	eb 14                	jmp    800ab9 <strchr+0x2b>
  800aa5:	38 ca                	cmp    %cl,%dl
  800aa7:	90                   	nop
  800aa8:	74 0f                	je     800ab9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aaa:	83 c0 01             	add    $0x1,%eax
  800aad:	0f b6 10             	movzbl (%eax),%edx
  800ab0:	84 d2                	test   %dl,%dl
  800ab2:	75 f1                	jne    800aa5 <strchr+0x17>
  800ab4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800ab9:	5d                   	pop    %ebp
  800aba:	c3                   	ret    

00800abb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ac5:	0f b6 10             	movzbl (%eax),%edx
  800ac8:	84 d2                	test   %dl,%dl
  800aca:	74 18                	je     800ae4 <strfind+0x29>
		if (*s == c)
  800acc:	38 ca                	cmp    %cl,%dl
  800ace:	75 0a                	jne    800ada <strfind+0x1f>
  800ad0:	eb 12                	jmp    800ae4 <strfind+0x29>
  800ad2:	38 ca                	cmp    %cl,%dl
  800ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ad8:	74 0a                	je     800ae4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ada:	83 c0 01             	add    $0x1,%eax
  800add:	0f b6 10             	movzbl (%eax),%edx
  800ae0:	84 d2                	test   %dl,%dl
  800ae2:	75 ee                	jne    800ad2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800ae4:	5d                   	pop    %ebp
  800ae5:	c3                   	ret    

00800ae6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	83 ec 0c             	sub    $0xc,%esp
  800aec:	89 1c 24             	mov    %ebx,(%esp)
  800aef:	89 74 24 04          	mov    %esi,0x4(%esp)
  800af3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800af7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b00:	85 c9                	test   %ecx,%ecx
  800b02:	74 30                	je     800b34 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b04:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b0a:	75 25                	jne    800b31 <memset+0x4b>
  800b0c:	f6 c1 03             	test   $0x3,%cl
  800b0f:	75 20                	jne    800b31 <memset+0x4b>
		c &= 0xFF;
  800b11:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b14:	89 d3                	mov    %edx,%ebx
  800b16:	c1 e3 08             	shl    $0x8,%ebx
  800b19:	89 d6                	mov    %edx,%esi
  800b1b:	c1 e6 18             	shl    $0x18,%esi
  800b1e:	89 d0                	mov    %edx,%eax
  800b20:	c1 e0 10             	shl    $0x10,%eax
  800b23:	09 f0                	or     %esi,%eax
  800b25:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800b27:	09 d8                	or     %ebx,%eax
  800b29:	c1 e9 02             	shr    $0x2,%ecx
  800b2c:	fc                   	cld    
  800b2d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b2f:	eb 03                	jmp    800b34 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b31:	fc                   	cld    
  800b32:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b34:	89 f8                	mov    %edi,%eax
  800b36:	8b 1c 24             	mov    (%esp),%ebx
  800b39:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b3d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b41:	89 ec                	mov    %ebp,%esp
  800b43:	5d                   	pop    %ebp
  800b44:	c3                   	ret    

00800b45 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	89 34 24             	mov    %esi,(%esp)
  800b4e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800b58:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800b5b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800b5d:	39 c6                	cmp    %eax,%esi
  800b5f:	73 35                	jae    800b96 <memmove+0x51>
  800b61:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b64:	39 d0                	cmp    %edx,%eax
  800b66:	73 2e                	jae    800b96 <memmove+0x51>
		s += n;
		d += n;
  800b68:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b6a:	f6 c2 03             	test   $0x3,%dl
  800b6d:	75 1b                	jne    800b8a <memmove+0x45>
  800b6f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b75:	75 13                	jne    800b8a <memmove+0x45>
  800b77:	f6 c1 03             	test   $0x3,%cl
  800b7a:	75 0e                	jne    800b8a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800b7c:	83 ef 04             	sub    $0x4,%edi
  800b7f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b82:	c1 e9 02             	shr    $0x2,%ecx
  800b85:	fd                   	std    
  800b86:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b88:	eb 09                	jmp    800b93 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b8a:	83 ef 01             	sub    $0x1,%edi
  800b8d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b90:	fd                   	std    
  800b91:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b93:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b94:	eb 20                	jmp    800bb6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b96:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b9c:	75 15                	jne    800bb3 <memmove+0x6e>
  800b9e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800ba4:	75 0d                	jne    800bb3 <memmove+0x6e>
  800ba6:	f6 c1 03             	test   $0x3,%cl
  800ba9:	75 08                	jne    800bb3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800bab:	c1 e9 02             	shr    $0x2,%ecx
  800bae:	fc                   	cld    
  800baf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb1:	eb 03                	jmp    800bb6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800bb3:	fc                   	cld    
  800bb4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bb6:	8b 34 24             	mov    (%esp),%esi
  800bb9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800bbd:	89 ec                	mov    %ebp,%esp
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800bc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bca:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd8:	89 04 24             	mov    %eax,(%esp)
  800bdb:	e8 65 ff ff ff       	call   800b45 <memmove>
}
  800be0:	c9                   	leave  
  800be1:	c3                   	ret    

00800be2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800be2:	55                   	push   %ebp
  800be3:	89 e5                	mov    %esp,%ebp
  800be5:	57                   	push   %edi
  800be6:	56                   	push   %esi
  800be7:	53                   	push   %ebx
  800be8:	8b 75 08             	mov    0x8(%ebp),%esi
  800beb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800bee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bf1:	85 c9                	test   %ecx,%ecx
  800bf3:	74 36                	je     800c2b <memcmp+0x49>
		if (*s1 != *s2)
  800bf5:	0f b6 06             	movzbl (%esi),%eax
  800bf8:	0f b6 1f             	movzbl (%edi),%ebx
  800bfb:	38 d8                	cmp    %bl,%al
  800bfd:	74 20                	je     800c1f <memcmp+0x3d>
  800bff:	eb 14                	jmp    800c15 <memcmp+0x33>
  800c01:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800c06:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800c0b:	83 c2 01             	add    $0x1,%edx
  800c0e:	83 e9 01             	sub    $0x1,%ecx
  800c11:	38 d8                	cmp    %bl,%al
  800c13:	74 12                	je     800c27 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800c15:	0f b6 c0             	movzbl %al,%eax
  800c18:	0f b6 db             	movzbl %bl,%ebx
  800c1b:	29 d8                	sub    %ebx,%eax
  800c1d:	eb 11                	jmp    800c30 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c1f:	83 e9 01             	sub    $0x1,%ecx
  800c22:	ba 00 00 00 00       	mov    $0x0,%edx
  800c27:	85 c9                	test   %ecx,%ecx
  800c29:	75 d6                	jne    800c01 <memcmp+0x1f>
  800c2b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800c30:	5b                   	pop    %ebx
  800c31:	5e                   	pop    %esi
  800c32:	5f                   	pop    %edi
  800c33:	5d                   	pop    %ebp
  800c34:	c3                   	ret    

00800c35 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c3b:	89 c2                	mov    %eax,%edx
  800c3d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c40:	39 d0                	cmp    %edx,%eax
  800c42:	73 15                	jae    800c59 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c44:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c48:	38 08                	cmp    %cl,(%eax)
  800c4a:	75 06                	jne    800c52 <memfind+0x1d>
  800c4c:	eb 0b                	jmp    800c59 <memfind+0x24>
  800c4e:	38 08                	cmp    %cl,(%eax)
  800c50:	74 07                	je     800c59 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c52:	83 c0 01             	add    $0x1,%eax
  800c55:	39 c2                	cmp    %eax,%edx
  800c57:	77 f5                	ja     800c4e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    

00800c5b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	57                   	push   %edi
  800c5f:	56                   	push   %esi
  800c60:	53                   	push   %ebx
  800c61:	83 ec 04             	sub    $0x4,%esp
  800c64:	8b 55 08             	mov    0x8(%ebp),%edx
  800c67:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c6a:	0f b6 02             	movzbl (%edx),%eax
  800c6d:	3c 20                	cmp    $0x20,%al
  800c6f:	74 04                	je     800c75 <strtol+0x1a>
  800c71:	3c 09                	cmp    $0x9,%al
  800c73:	75 0e                	jne    800c83 <strtol+0x28>
		s++;
  800c75:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c78:	0f b6 02             	movzbl (%edx),%eax
  800c7b:	3c 20                	cmp    $0x20,%al
  800c7d:	74 f6                	je     800c75 <strtol+0x1a>
  800c7f:	3c 09                	cmp    $0x9,%al
  800c81:	74 f2                	je     800c75 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c83:	3c 2b                	cmp    $0x2b,%al
  800c85:	75 0c                	jne    800c93 <strtol+0x38>
		s++;
  800c87:	83 c2 01             	add    $0x1,%edx
  800c8a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c91:	eb 15                	jmp    800ca8 <strtol+0x4d>
	else if (*s == '-')
  800c93:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c9a:	3c 2d                	cmp    $0x2d,%al
  800c9c:	75 0a                	jne    800ca8 <strtol+0x4d>
		s++, neg = 1;
  800c9e:	83 c2 01             	add    $0x1,%edx
  800ca1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ca8:	85 db                	test   %ebx,%ebx
  800caa:	0f 94 c0             	sete   %al
  800cad:	74 05                	je     800cb4 <strtol+0x59>
  800caf:	83 fb 10             	cmp    $0x10,%ebx
  800cb2:	75 18                	jne    800ccc <strtol+0x71>
  800cb4:	80 3a 30             	cmpb   $0x30,(%edx)
  800cb7:	75 13                	jne    800ccc <strtol+0x71>
  800cb9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800cbd:	8d 76 00             	lea    0x0(%esi),%esi
  800cc0:	75 0a                	jne    800ccc <strtol+0x71>
		s += 2, base = 16;
  800cc2:	83 c2 02             	add    $0x2,%edx
  800cc5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cca:	eb 15                	jmp    800ce1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ccc:	84 c0                	test   %al,%al
  800cce:	66 90                	xchg   %ax,%ax
  800cd0:	74 0f                	je     800ce1 <strtol+0x86>
  800cd2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800cd7:	80 3a 30             	cmpb   $0x30,(%edx)
  800cda:	75 05                	jne    800ce1 <strtol+0x86>
		s++, base = 8;
  800cdc:	83 c2 01             	add    $0x1,%edx
  800cdf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ce1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ce6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ce8:	0f b6 0a             	movzbl (%edx),%ecx
  800ceb:	89 cf                	mov    %ecx,%edi
  800ced:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800cf0:	80 fb 09             	cmp    $0x9,%bl
  800cf3:	77 08                	ja     800cfd <strtol+0xa2>
			dig = *s - '0';
  800cf5:	0f be c9             	movsbl %cl,%ecx
  800cf8:	83 e9 30             	sub    $0x30,%ecx
  800cfb:	eb 1e                	jmp    800d1b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800cfd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800d00:	80 fb 19             	cmp    $0x19,%bl
  800d03:	77 08                	ja     800d0d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800d05:	0f be c9             	movsbl %cl,%ecx
  800d08:	83 e9 57             	sub    $0x57,%ecx
  800d0b:	eb 0e                	jmp    800d1b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800d0d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800d10:	80 fb 19             	cmp    $0x19,%bl
  800d13:	77 15                	ja     800d2a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800d15:	0f be c9             	movsbl %cl,%ecx
  800d18:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d1b:	39 f1                	cmp    %esi,%ecx
  800d1d:	7d 0b                	jge    800d2a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800d1f:	83 c2 01             	add    $0x1,%edx
  800d22:	0f af c6             	imul   %esi,%eax
  800d25:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800d28:	eb be                	jmp    800ce8 <strtol+0x8d>
  800d2a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800d2c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d30:	74 05                	je     800d37 <strtol+0xdc>
		*endptr = (char *) s;
  800d32:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d35:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d37:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d3b:	74 04                	je     800d41 <strtol+0xe6>
  800d3d:	89 c8                	mov    %ecx,%eax
  800d3f:	f7 d8                	neg    %eax
}
  800d41:	83 c4 04             	add    $0x4,%esp
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    
  800d49:	00 00                	add    %al,(%eax)
	...

00800d4c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	83 ec 0c             	sub    $0xc,%esp
  800d52:	89 1c 24             	mov    %ebx,(%esp)
  800d55:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d59:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d62:	b8 01 00 00 00       	mov    $0x1,%eax
  800d67:	89 d1                	mov    %edx,%ecx
  800d69:	89 d3                	mov    %edx,%ebx
  800d6b:	89 d7                	mov    %edx,%edi
  800d6d:	89 d6                	mov    %edx,%esi
  800d6f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d71:	8b 1c 24             	mov    (%esp),%ebx
  800d74:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d78:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d7c:	89 ec                	mov    %ebp,%esp
  800d7e:	5d                   	pop    %ebp
  800d7f:	c3                   	ret    

00800d80 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d80:	55                   	push   %ebp
  800d81:	89 e5                	mov    %esp,%ebp
  800d83:	83 ec 0c             	sub    $0xc,%esp
  800d86:	89 1c 24             	mov    %ebx,(%esp)
  800d89:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d8d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d91:	b8 00 00 00 00       	mov    $0x0,%eax
  800d96:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d99:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9c:	89 c3                	mov    %eax,%ebx
  800d9e:	89 c7                	mov    %eax,%edi
  800da0:	89 c6                	mov    %eax,%esi
  800da2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800da4:	8b 1c 24             	mov    (%esp),%ebx
  800da7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dab:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800daf:	89 ec                	mov    %ebp,%esp
  800db1:	5d                   	pop    %ebp
  800db2:	c3                   	ret    

00800db3 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  800db3:	55                   	push   %ebp
  800db4:	89 e5                	mov    %esp,%ebp
  800db6:	83 ec 0c             	sub    $0xc,%esp
  800db9:	89 1c 24             	mov    %ebx,(%esp)
  800dbc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dc0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc9:	b8 10 00 00 00       	mov    $0x10,%eax
  800dce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd4:	89 df                	mov    %ebx,%edi
  800dd6:	89 de                	mov    %ebx,%esi
  800dd8:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800dda:	8b 1c 24             	mov    (%esp),%ebx
  800ddd:	8b 74 24 04          	mov    0x4(%esp),%esi
  800de1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800de5:	89 ec                	mov    %ebp,%esp
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    

00800de9 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	83 ec 38             	sub    $0x38,%esp
  800def:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800df2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800df5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800df8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dfd:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e05:	8b 55 08             	mov    0x8(%ebp),%edx
  800e08:	89 df                	mov    %ebx,%edi
  800e0a:	89 de                	mov    %ebx,%esi
  800e0c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e0e:	85 c0                	test   %eax,%eax
  800e10:	7e 28                	jle    800e3a <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e12:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e16:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800e1d:	00 
  800e1e:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800e25:	00 
  800e26:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e2d:	00 
  800e2e:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800e35:	e8 a6 f3 ff ff       	call   8001e0 <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800e3a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e3d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e40:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e43:	89 ec                	mov    %ebp,%esp
  800e45:	5d                   	pop    %ebp
  800e46:	c3                   	ret    

00800e47 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800e47:	55                   	push   %ebp
  800e48:	89 e5                	mov    %esp,%ebp
  800e4a:	83 ec 0c             	sub    $0xc,%esp
  800e4d:	89 1c 24             	mov    %ebx,(%esp)
  800e50:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e54:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e58:	ba 00 00 00 00       	mov    $0x0,%edx
  800e5d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e62:	89 d1                	mov    %edx,%ecx
  800e64:	89 d3                	mov    %edx,%ebx
  800e66:	89 d7                	mov    %edx,%edi
  800e68:	89 d6                	mov    %edx,%esi
  800e6a:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e6c:	8b 1c 24             	mov    (%esp),%ebx
  800e6f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e73:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e77:	89 ec                	mov    %ebp,%esp
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	83 ec 38             	sub    $0x38,%esp
  800e81:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e84:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e87:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e8f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	89 cb                	mov    %ecx,%ebx
  800e99:	89 cf                	mov    %ecx,%edi
  800e9b:	89 ce                	mov    %ecx,%esi
  800e9d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e9f:	85 c0                	test   %eax,%eax
  800ea1:	7e 28                	jle    800ecb <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea7:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800eae:	00 
  800eaf:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800eb6:	00 
  800eb7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ebe:	00 
  800ebf:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800ec6:	e8 15 f3 ff ff       	call   8001e0 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ecb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ece:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ed1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ed4:	89 ec                	mov    %ebp,%esp
  800ed6:	5d                   	pop    %ebp
  800ed7:	c3                   	ret    

00800ed8 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ed8:	55                   	push   %ebp
  800ed9:	89 e5                	mov    %esp,%ebp
  800edb:	83 ec 0c             	sub    $0xc,%esp
  800ede:	89 1c 24             	mov    %ebx,(%esp)
  800ee1:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ee5:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee9:	be 00 00 00 00       	mov    $0x0,%esi
  800eee:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ef3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ef6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efc:	8b 55 08             	mov    0x8(%ebp),%edx
  800eff:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f01:	8b 1c 24             	mov    (%esp),%ebx
  800f04:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f08:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f0c:	89 ec                	mov    %ebp,%esp
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    

00800f10 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f10:	55                   	push   %ebp
  800f11:	89 e5                	mov    %esp,%ebp
  800f13:	83 ec 38             	sub    $0x38,%esp
  800f16:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f19:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f1c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f1f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f24:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2f:	89 df                	mov    %ebx,%edi
  800f31:	89 de                	mov    %ebx,%esi
  800f33:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f35:	85 c0                	test   %eax,%eax
  800f37:	7e 28                	jle    800f61 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f39:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f3d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f44:	00 
  800f45:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800f4c:	00 
  800f4d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f54:	00 
  800f55:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800f5c:	e8 7f f2 ff ff       	call   8001e0 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f61:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f64:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f67:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f6a:	89 ec                	mov    %ebp,%esp
  800f6c:	5d                   	pop    %ebp
  800f6d:	c3                   	ret    

00800f6e <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f6e:	55                   	push   %ebp
  800f6f:	89 e5                	mov    %esp,%ebp
  800f71:	83 ec 38             	sub    $0x38,%esp
  800f74:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f77:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f7a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f7d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f82:	b8 09 00 00 00       	mov    $0x9,%eax
  800f87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	89 df                	mov    %ebx,%edi
  800f8f:	89 de                	mov    %ebx,%esi
  800f91:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f93:	85 c0                	test   %eax,%eax
  800f95:	7e 28                	jle    800fbf <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f97:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f9b:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800fa2:	00 
  800fa3:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800faa:	00 
  800fab:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fb2:	00 
  800fb3:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800fba:	e8 21 f2 ff ff       	call   8001e0 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fbf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fc2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fc5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fc8:	89 ec                	mov    %ebp,%esp
  800fca:	5d                   	pop    %ebp
  800fcb:	c3                   	ret    

00800fcc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 38             	sub    $0x38,%esp
  800fd2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fd5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fd8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fdb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe0:	b8 08 00 00 00       	mov    $0x8,%eax
  800fe5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fe8:	8b 55 08             	mov    0x8(%ebp),%edx
  800feb:	89 df                	mov    %ebx,%edi
  800fed:	89 de                	mov    %ebx,%esi
  800fef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ff1:	85 c0                	test   %eax,%eax
  800ff3:	7e 28                	jle    80101d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ff5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ff9:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801000:	00 
  801001:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  801008:	00 
  801009:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801010:	00 
  801011:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  801018:	e8 c3 f1 ff ff       	call   8001e0 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80101d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801020:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801023:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801026:	89 ec                	mov    %ebp,%esp
  801028:	5d                   	pop    %ebp
  801029:	c3                   	ret    

0080102a <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	83 ec 38             	sub    $0x38,%esp
  801030:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801033:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801036:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801039:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103e:	b8 06 00 00 00       	mov    $0x6,%eax
  801043:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801046:	8b 55 08             	mov    0x8(%ebp),%edx
  801049:	89 df                	mov    %ebx,%edi
  80104b:	89 de                	mov    %ebx,%esi
  80104d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80104f:	85 c0                	test   %eax,%eax
  801051:	7e 28                	jle    80107b <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801053:	89 44 24 10          	mov    %eax,0x10(%esp)
  801057:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80105e:	00 
  80105f:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  801066:	00 
  801067:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80106e:	00 
  80106f:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  801076:	e8 65 f1 ff ff       	call   8001e0 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80107b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80107e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801081:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801084:	89 ec                	mov    %ebp,%esp
  801086:	5d                   	pop    %ebp
  801087:	c3                   	ret    

00801088 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
  80108b:	83 ec 38             	sub    $0x38,%esp
  80108e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801091:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801094:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801097:	b8 05 00 00 00       	mov    $0x5,%eax
  80109c:	8b 75 18             	mov    0x18(%ebp),%esi
  80109f:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010a2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ab:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010ad:	85 c0                	test   %eax,%eax
  8010af:	7e 28                	jle    8010d9 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010b5:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8010bc:	00 
  8010bd:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  8010c4:	00 
  8010c5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010cc:	00 
  8010cd:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  8010d4:	e8 07 f1 ff ff       	call   8001e0 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010d9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010dc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010df:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010e2:	89 ec                	mov    %ebp,%esp
  8010e4:	5d                   	pop    %ebp
  8010e5:	c3                   	ret    

008010e6 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010e6:	55                   	push   %ebp
  8010e7:	89 e5                	mov    %esp,%ebp
  8010e9:	83 ec 38             	sub    $0x38,%esp
  8010ec:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010ef:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010f2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010f5:	be 00 00 00 00       	mov    $0x0,%esi
  8010fa:	b8 04 00 00 00       	mov    $0x4,%eax
  8010ff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801102:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801105:	8b 55 08             	mov    0x8(%ebp),%edx
  801108:	89 f7                	mov    %esi,%edi
  80110a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80110c:	85 c0                	test   %eax,%eax
  80110e:	7e 28                	jle    801138 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801110:	89 44 24 10          	mov    %eax,0x10(%esp)
  801114:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80111b:	00 
  80111c:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  801123:	00 
  801124:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80112b:	00 
  80112c:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  801133:	e8 a8 f0 ff ff       	call   8001e0 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801138:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80113b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80113e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801141:	89 ec                	mov    %ebp,%esp
  801143:	5d                   	pop    %ebp
  801144:	c3                   	ret    

00801145 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	83 ec 0c             	sub    $0xc,%esp
  80114b:	89 1c 24             	mov    %ebx,(%esp)
  80114e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801152:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801156:	ba 00 00 00 00       	mov    $0x0,%edx
  80115b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801160:	89 d1                	mov    %edx,%ecx
  801162:	89 d3                	mov    %edx,%ebx
  801164:	89 d7                	mov    %edx,%edi
  801166:	89 d6                	mov    %edx,%esi
  801168:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80116a:	8b 1c 24             	mov    (%esp),%ebx
  80116d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801171:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801175:	89 ec                	mov    %ebp,%esp
  801177:	5d                   	pop    %ebp
  801178:	c3                   	ret    

00801179 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	83 ec 0c             	sub    $0xc,%esp
  80117f:	89 1c 24             	mov    %ebx,(%esp)
  801182:	89 74 24 04          	mov    %esi,0x4(%esp)
  801186:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80118a:	ba 00 00 00 00       	mov    $0x0,%edx
  80118f:	b8 02 00 00 00       	mov    $0x2,%eax
  801194:	89 d1                	mov    %edx,%ecx
  801196:	89 d3                	mov    %edx,%ebx
  801198:	89 d7                	mov    %edx,%edi
  80119a:	89 d6                	mov    %edx,%esi
  80119c:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80119e:	8b 1c 24             	mov    (%esp),%ebx
  8011a1:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011a5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011a9:	89 ec                	mov    %ebp,%esp
  8011ab:	5d                   	pop    %ebp
  8011ac:	c3                   	ret    

008011ad <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8011ad:	55                   	push   %ebp
  8011ae:	89 e5                	mov    %esp,%ebp
  8011b0:	83 ec 38             	sub    $0x38,%esp
  8011b3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011b6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011b9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011bc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011c1:	b8 03 00 00 00       	mov    $0x3,%eax
  8011c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c9:	89 cb                	mov    %ecx,%ebx
  8011cb:	89 cf                	mov    %ecx,%edi
  8011cd:	89 ce                	mov    %ecx,%esi
  8011cf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011d1:	85 c0                	test   %eax,%eax
  8011d3:	7e 28                	jle    8011fd <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011d9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8011e0:	00 
  8011e1:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  8011e8:	00 
  8011e9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011f0:	00 
  8011f1:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  8011f8:	e8 e3 ef ff ff       	call   8001e0 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011fd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801200:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801203:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801206:	89 ec                	mov    %ebp,%esp
  801208:	5d                   	pop    %ebp
  801209:	c3                   	ret    
  80120a:	00 00                	add    %al,(%eax)
  80120c:	00 00                	add    %al,(%eax)
	...

00801210 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801210:	55                   	push   %ebp
  801211:	89 e5                	mov    %esp,%ebp
  801213:	8b 45 08             	mov    0x8(%ebp),%eax
  801216:	05 00 00 00 30       	add    $0x30000000,%eax
  80121b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80121e:	5d                   	pop    %ebp
  80121f:	c3                   	ret    

00801220 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	89 04 24             	mov    %eax,(%esp)
  80122c:	e8 df ff ff ff       	call   801210 <fd2num>
  801231:	05 20 00 0d 00       	add    $0xd0020,%eax
  801236:	c1 e0 0c             	shl    $0xc,%eax
}
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	57                   	push   %edi
  80123f:	56                   	push   %esi
  801240:	53                   	push   %ebx
  801241:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801244:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801249:	a8 01                	test   $0x1,%al
  80124b:	74 36                	je     801283 <fd_alloc+0x48>
  80124d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801252:	a8 01                	test   $0x1,%al
  801254:	74 2d                	je     801283 <fd_alloc+0x48>
  801256:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80125b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801260:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801265:	89 c3                	mov    %eax,%ebx
  801267:	89 c2                	mov    %eax,%edx
  801269:	c1 ea 16             	shr    $0x16,%edx
  80126c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80126f:	f6 c2 01             	test   $0x1,%dl
  801272:	74 14                	je     801288 <fd_alloc+0x4d>
  801274:	89 c2                	mov    %eax,%edx
  801276:	c1 ea 0c             	shr    $0xc,%edx
  801279:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80127c:	f6 c2 01             	test   $0x1,%dl
  80127f:	75 10                	jne    801291 <fd_alloc+0x56>
  801281:	eb 05                	jmp    801288 <fd_alloc+0x4d>
  801283:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801288:	89 1f                	mov    %ebx,(%edi)
  80128a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80128f:	eb 17                	jmp    8012a8 <fd_alloc+0x6d>
  801291:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801296:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80129b:	75 c8                	jne    801265 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80129d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8012a3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8012a8:	5b                   	pop    %ebx
  8012a9:	5e                   	pop    %esi
  8012aa:	5f                   	pop    %edi
  8012ab:	5d                   	pop    %ebp
  8012ac:	c3                   	ret    

008012ad <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	83 f8 1f             	cmp    $0x1f,%eax
  8012b6:	77 36                	ja     8012ee <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012b8:	05 00 00 0d 00       	add    $0xd0000,%eax
  8012bd:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8012c0:	89 c2                	mov    %eax,%edx
  8012c2:	c1 ea 16             	shr    $0x16,%edx
  8012c5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012cc:	f6 c2 01             	test   $0x1,%dl
  8012cf:	74 1d                	je     8012ee <fd_lookup+0x41>
  8012d1:	89 c2                	mov    %eax,%edx
  8012d3:	c1 ea 0c             	shr    $0xc,%edx
  8012d6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012dd:	f6 c2 01             	test   $0x1,%dl
  8012e0:	74 0c                	je     8012ee <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e5:	89 02                	mov    %eax,(%edx)
  8012e7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8012ec:	eb 05                	jmp    8012f3 <fd_lookup+0x46>
  8012ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012f3:	5d                   	pop    %ebp
  8012f4:	c3                   	ret    

008012f5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
  8012f8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012fb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801302:	8b 45 08             	mov    0x8(%ebp),%eax
  801305:	89 04 24             	mov    %eax,(%esp)
  801308:	e8 a0 ff ff ff       	call   8012ad <fd_lookup>
  80130d:	85 c0                	test   %eax,%eax
  80130f:	78 0e                	js     80131f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801311:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801314:	8b 55 0c             	mov    0xc(%ebp),%edx
  801317:	89 50 04             	mov    %edx,0x4(%eax)
  80131a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80131f:	c9                   	leave  
  801320:	c3                   	ret    

00801321 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801321:	55                   	push   %ebp
  801322:	89 e5                	mov    %esp,%ebp
  801324:	56                   	push   %esi
  801325:	53                   	push   %ebx
  801326:	83 ec 10             	sub    $0x10,%esp
  801329:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80132c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80132f:	b8 04 60 80 00       	mov    $0x806004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801334:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801339:	be ac 2e 80 00       	mov    $0x802eac,%esi
		if (devtab[i]->dev_id == dev_id) {
  80133e:	39 08                	cmp    %ecx,(%eax)
  801340:	75 10                	jne    801352 <dev_lookup+0x31>
  801342:	eb 04                	jmp    801348 <dev_lookup+0x27>
  801344:	39 08                	cmp    %ecx,(%eax)
  801346:	75 0a                	jne    801352 <dev_lookup+0x31>
			*dev = devtab[i];
  801348:	89 03                	mov    %eax,(%ebx)
  80134a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80134f:	90                   	nop
  801350:	eb 31                	jmp    801383 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801352:	83 c2 01             	add    $0x1,%edx
  801355:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801358:	85 c0                	test   %eax,%eax
  80135a:	75 e8                	jne    801344 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80135c:	a1 80 80 80 00       	mov    0x808080,%eax
  801361:	8b 40 4c             	mov    0x4c(%eax),%eax
  801364:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801368:	89 44 24 04          	mov    %eax,0x4(%esp)
  80136c:	c7 04 24 2c 2e 80 00 	movl   $0x802e2c,(%esp)
  801373:	e8 2d ef ff ff       	call   8002a5 <cprintf>
	*dev = 0;
  801378:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80137e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801383:	83 c4 10             	add    $0x10,%esp
  801386:	5b                   	pop    %ebx
  801387:	5e                   	pop    %esi
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    

0080138a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	53                   	push   %ebx
  80138e:	83 ec 24             	sub    $0x24,%esp
  801391:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801394:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801397:	89 44 24 04          	mov    %eax,0x4(%esp)
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	89 04 24             	mov    %eax,(%esp)
  8013a1:	e8 07 ff ff ff       	call   8012ad <fd_lookup>
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	78 53                	js     8013fd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b4:	8b 00                	mov    (%eax),%eax
  8013b6:	89 04 24             	mov    %eax,(%esp)
  8013b9:	e8 63 ff ff ff       	call   801321 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013be:	85 c0                	test   %eax,%eax
  8013c0:	78 3b                	js     8013fd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8013c2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ca:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8013ce:	74 2d                	je     8013fd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013d0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013d3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013da:	00 00 00 
	stat->st_isdir = 0;
  8013dd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013e4:	00 00 00 
	stat->st_dev = dev;
  8013e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ea:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013f4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f7:	89 14 24             	mov    %edx,(%esp)
  8013fa:	ff 50 14             	call   *0x14(%eax)
}
  8013fd:	83 c4 24             	add    $0x24,%esp
  801400:	5b                   	pop    %ebx
  801401:	5d                   	pop    %ebp
  801402:	c3                   	ret    

00801403 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801403:	55                   	push   %ebp
  801404:	89 e5                	mov    %esp,%ebp
  801406:	53                   	push   %ebx
  801407:	83 ec 24             	sub    $0x24,%esp
  80140a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80140d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801410:	89 44 24 04          	mov    %eax,0x4(%esp)
  801414:	89 1c 24             	mov    %ebx,(%esp)
  801417:	e8 91 fe ff ff       	call   8012ad <fd_lookup>
  80141c:	85 c0                	test   %eax,%eax
  80141e:	78 5f                	js     80147f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801420:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801423:	89 44 24 04          	mov    %eax,0x4(%esp)
  801427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142a:	8b 00                	mov    (%eax),%eax
  80142c:	89 04 24             	mov    %eax,(%esp)
  80142f:	e8 ed fe ff ff       	call   801321 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801434:	85 c0                	test   %eax,%eax
  801436:	78 47                	js     80147f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801438:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80143b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80143f:	75 23                	jne    801464 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801441:	a1 80 80 80 00       	mov    0x808080,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801446:	8b 40 4c             	mov    0x4c(%eax),%eax
  801449:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80144d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801451:	c7 04 24 4c 2e 80 00 	movl   $0x802e4c,(%esp)
  801458:	e8 48 ee ff ff       	call   8002a5 <cprintf>
  80145d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801462:	eb 1b                	jmp    80147f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801467:	8b 48 18             	mov    0x18(%eax),%ecx
  80146a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80146f:	85 c9                	test   %ecx,%ecx
  801471:	74 0c                	je     80147f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801473:	8b 45 0c             	mov    0xc(%ebp),%eax
  801476:	89 44 24 04          	mov    %eax,0x4(%esp)
  80147a:	89 14 24             	mov    %edx,(%esp)
  80147d:	ff d1                	call   *%ecx
}
  80147f:	83 c4 24             	add    $0x24,%esp
  801482:	5b                   	pop    %ebx
  801483:	5d                   	pop    %ebp
  801484:	c3                   	ret    

00801485 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	53                   	push   %ebx
  801489:	83 ec 24             	sub    $0x24,%esp
  80148c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80148f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801492:	89 44 24 04          	mov    %eax,0x4(%esp)
  801496:	89 1c 24             	mov    %ebx,(%esp)
  801499:	e8 0f fe ff ff       	call   8012ad <fd_lookup>
  80149e:	85 c0                	test   %eax,%eax
  8014a0:	78 66                	js     801508 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ac:	8b 00                	mov    (%eax),%eax
  8014ae:	89 04 24             	mov    %eax,(%esp)
  8014b1:	e8 6b fe ff ff       	call   801321 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	78 4e                	js     801508 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014ba:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014bd:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8014c1:	75 23                	jne    8014e6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8014c3:	a1 80 80 80 00       	mov    0x808080,%eax
  8014c8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8014cb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014d3:	c7 04 24 70 2e 80 00 	movl   $0x802e70,(%esp)
  8014da:	e8 c6 ed ff ff       	call   8002a5 <cprintf>
  8014df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8014e4:	eb 22                	jmp    801508 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014e9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8014ec:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014f1:	85 c9                	test   %ecx,%ecx
  8014f3:	74 13                	je     801508 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014f5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014f8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801503:	89 14 24             	mov    %edx,(%esp)
  801506:	ff d1                	call   *%ecx
}
  801508:	83 c4 24             	add    $0x24,%esp
  80150b:	5b                   	pop    %ebx
  80150c:	5d                   	pop    %ebp
  80150d:	c3                   	ret    

0080150e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80150e:	55                   	push   %ebp
  80150f:	89 e5                	mov    %esp,%ebp
  801511:	53                   	push   %ebx
  801512:	83 ec 24             	sub    $0x24,%esp
  801515:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801518:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80151b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80151f:	89 1c 24             	mov    %ebx,(%esp)
  801522:	e8 86 fd ff ff       	call   8012ad <fd_lookup>
  801527:	85 c0                	test   %eax,%eax
  801529:	78 6b                	js     801596 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80152b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80152e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801535:	8b 00                	mov    (%eax),%eax
  801537:	89 04 24             	mov    %eax,(%esp)
  80153a:	e8 e2 fd ff ff       	call   801321 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80153f:	85 c0                	test   %eax,%eax
  801541:	78 53                	js     801596 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801543:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801546:	8b 42 08             	mov    0x8(%edx),%eax
  801549:	83 e0 03             	and    $0x3,%eax
  80154c:	83 f8 01             	cmp    $0x1,%eax
  80154f:	75 23                	jne    801574 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801551:	a1 80 80 80 00       	mov    0x808080,%eax
  801556:	8b 40 4c             	mov    0x4c(%eax),%eax
  801559:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80155d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801561:	c7 04 24 8d 2e 80 00 	movl   $0x802e8d,(%esp)
  801568:	e8 38 ed ff ff       	call   8002a5 <cprintf>
  80156d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801572:	eb 22                	jmp    801596 <read+0x88>
	}
	if (!dev->dev_read)
  801574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801577:	8b 48 08             	mov    0x8(%eax),%ecx
  80157a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80157f:	85 c9                	test   %ecx,%ecx
  801581:	74 13                	je     801596 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801583:	8b 45 10             	mov    0x10(%ebp),%eax
  801586:	89 44 24 08          	mov    %eax,0x8(%esp)
  80158a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80158d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801591:	89 14 24             	mov    %edx,(%esp)
  801594:	ff d1                	call   *%ecx
}
  801596:	83 c4 24             	add    $0x24,%esp
  801599:	5b                   	pop    %ebx
  80159a:	5d                   	pop    %ebp
  80159b:	c3                   	ret    

0080159c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	57                   	push   %edi
  8015a0:	56                   	push   %esi
  8015a1:	53                   	push   %ebx
  8015a2:	83 ec 1c             	sub    $0x1c,%esp
  8015a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015a8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ba:	85 f6                	test   %esi,%esi
  8015bc:	74 29                	je     8015e7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015be:	89 f0                	mov    %esi,%eax
  8015c0:	29 d0                	sub    %edx,%eax
  8015c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015c6:	03 55 0c             	add    0xc(%ebp),%edx
  8015c9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015cd:	89 3c 24             	mov    %edi,(%esp)
  8015d0:	e8 39 ff ff ff       	call   80150e <read>
		if (m < 0)
  8015d5:	85 c0                	test   %eax,%eax
  8015d7:	78 0e                	js     8015e7 <readn+0x4b>
			return m;
		if (m == 0)
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	74 08                	je     8015e5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015dd:	01 c3                	add    %eax,%ebx
  8015df:	89 da                	mov    %ebx,%edx
  8015e1:	39 f3                	cmp    %esi,%ebx
  8015e3:	72 d9                	jb     8015be <readn+0x22>
  8015e5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8015e7:	83 c4 1c             	add    $0x1c,%esp
  8015ea:	5b                   	pop    %ebx
  8015eb:	5e                   	pop    %esi
  8015ec:	5f                   	pop    %edi
  8015ed:	5d                   	pop    %ebp
  8015ee:	c3                   	ret    

008015ef <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	56                   	push   %esi
  8015f3:	53                   	push   %ebx
  8015f4:	83 ec 20             	sub    $0x20,%esp
  8015f7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015fa:	89 34 24             	mov    %esi,(%esp)
  8015fd:	e8 0e fc ff ff       	call   801210 <fd2num>
  801602:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801605:	89 54 24 04          	mov    %edx,0x4(%esp)
  801609:	89 04 24             	mov    %eax,(%esp)
  80160c:	e8 9c fc ff ff       	call   8012ad <fd_lookup>
  801611:	89 c3                	mov    %eax,%ebx
  801613:	85 c0                	test   %eax,%eax
  801615:	78 05                	js     80161c <fd_close+0x2d>
  801617:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80161a:	74 0c                	je     801628 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80161c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801620:	19 c0                	sbb    %eax,%eax
  801622:	f7 d0                	not    %eax
  801624:	21 c3                	and    %eax,%ebx
  801626:	eb 3d                	jmp    801665 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801628:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80162b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80162f:	8b 06                	mov    (%esi),%eax
  801631:	89 04 24             	mov    %eax,(%esp)
  801634:	e8 e8 fc ff ff       	call   801321 <dev_lookup>
  801639:	89 c3                	mov    %eax,%ebx
  80163b:	85 c0                	test   %eax,%eax
  80163d:	78 16                	js     801655 <fd_close+0x66>
		if (dev->dev_close)
  80163f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801642:	8b 40 10             	mov    0x10(%eax),%eax
  801645:	bb 00 00 00 00       	mov    $0x0,%ebx
  80164a:	85 c0                	test   %eax,%eax
  80164c:	74 07                	je     801655 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80164e:	89 34 24             	mov    %esi,(%esp)
  801651:	ff d0                	call   *%eax
  801653:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801655:	89 74 24 04          	mov    %esi,0x4(%esp)
  801659:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801660:	e8 c5 f9 ff ff       	call   80102a <sys_page_unmap>
	return r;
}
  801665:	89 d8                	mov    %ebx,%eax
  801667:	83 c4 20             	add    $0x20,%esp
  80166a:	5b                   	pop    %ebx
  80166b:	5e                   	pop    %esi
  80166c:	5d                   	pop    %ebp
  80166d:	c3                   	ret    

0080166e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80166e:	55                   	push   %ebp
  80166f:	89 e5                	mov    %esp,%ebp
  801671:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801674:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801677:	89 44 24 04          	mov    %eax,0x4(%esp)
  80167b:	8b 45 08             	mov    0x8(%ebp),%eax
  80167e:	89 04 24             	mov    %eax,(%esp)
  801681:	e8 27 fc ff ff       	call   8012ad <fd_lookup>
  801686:	85 c0                	test   %eax,%eax
  801688:	78 13                	js     80169d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80168a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801691:	00 
  801692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801695:	89 04 24             	mov    %eax,(%esp)
  801698:	e8 52 ff ff ff       	call   8015ef <fd_close>
}
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	83 ec 18             	sub    $0x18,%esp
  8016a5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8016a8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016b2:	00 
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	89 04 24             	mov    %eax,(%esp)
  8016b9:	e8 a9 03 00 00       	call   801a67 <open>
  8016be:	89 c3                	mov    %eax,%ebx
  8016c0:	85 c0                	test   %eax,%eax
  8016c2:	78 1b                	js     8016df <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8016c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cb:	89 1c 24             	mov    %ebx,(%esp)
  8016ce:	e8 b7 fc ff ff       	call   80138a <fstat>
  8016d3:	89 c6                	mov    %eax,%esi
	close(fd);
  8016d5:	89 1c 24             	mov    %ebx,(%esp)
  8016d8:	e8 91 ff ff ff       	call   80166e <close>
  8016dd:	89 f3                	mov    %esi,%ebx
	return r;
}
  8016df:	89 d8                	mov    %ebx,%eax
  8016e1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8016e4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8016e7:	89 ec                	mov    %ebp,%esp
  8016e9:	5d                   	pop    %ebp
  8016ea:	c3                   	ret    

008016eb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  8016eb:	55                   	push   %ebp
  8016ec:	89 e5                	mov    %esp,%ebp
  8016ee:	53                   	push   %ebx
  8016ef:	83 ec 14             	sub    $0x14,%esp
  8016f2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  8016f7:	89 1c 24             	mov    %ebx,(%esp)
  8016fa:	e8 6f ff ff ff       	call   80166e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8016ff:	83 c3 01             	add    $0x1,%ebx
  801702:	83 fb 20             	cmp    $0x20,%ebx
  801705:	75 f0                	jne    8016f7 <close_all+0xc>
		close(i);
}
  801707:	83 c4 14             	add    $0x14,%esp
  80170a:	5b                   	pop    %ebx
  80170b:	5d                   	pop    %ebp
  80170c:	c3                   	ret    

0080170d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80170d:	55                   	push   %ebp
  80170e:	89 e5                	mov    %esp,%ebp
  801710:	83 ec 58             	sub    $0x58,%esp
  801713:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801716:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801719:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80171c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80171f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801722:	89 44 24 04          	mov    %eax,0x4(%esp)
  801726:	8b 45 08             	mov    0x8(%ebp),%eax
  801729:	89 04 24             	mov    %eax,(%esp)
  80172c:	e8 7c fb ff ff       	call   8012ad <fd_lookup>
  801731:	89 c3                	mov    %eax,%ebx
  801733:	85 c0                	test   %eax,%eax
  801735:	0f 88 e0 00 00 00    	js     80181b <dup+0x10e>
		return r;
	close(newfdnum);
  80173b:	89 3c 24             	mov    %edi,(%esp)
  80173e:	e8 2b ff ff ff       	call   80166e <close>

	newfd = INDEX2FD(newfdnum);
  801743:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801749:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80174c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80174f:	89 04 24             	mov    %eax,(%esp)
  801752:	e8 c9 fa ff ff       	call   801220 <fd2data>
  801757:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801759:	89 34 24             	mov    %esi,(%esp)
  80175c:	e8 bf fa ff ff       	call   801220 <fd2data>
  801761:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801764:	89 da                	mov    %ebx,%edx
  801766:	89 d8                	mov    %ebx,%eax
  801768:	c1 e8 16             	shr    $0x16,%eax
  80176b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801772:	a8 01                	test   $0x1,%al
  801774:	74 43                	je     8017b9 <dup+0xac>
  801776:	c1 ea 0c             	shr    $0xc,%edx
  801779:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801780:	a8 01                	test   $0x1,%al
  801782:	74 35                	je     8017b9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801784:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80178b:	25 07 0e 00 00       	and    $0xe07,%eax
  801790:	89 44 24 10          	mov    %eax,0x10(%esp)
  801794:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801797:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80179b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017a2:	00 
  8017a3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017ae:	e8 d5 f8 ff ff       	call   801088 <sys_page_map>
  8017b3:	89 c3                	mov    %eax,%ebx
  8017b5:	85 c0                	test   %eax,%eax
  8017b7:	78 3f                	js     8017f8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  8017b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017bc:	89 c2                	mov    %eax,%edx
  8017be:	c1 ea 0c             	shr    $0xc,%edx
  8017c1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017c8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017ce:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017d2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8017d6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017dd:	00 
  8017de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017e9:	e8 9a f8 ff ff       	call   801088 <sys_page_map>
  8017ee:	89 c3                	mov    %eax,%ebx
  8017f0:	85 c0                	test   %eax,%eax
  8017f2:	78 04                	js     8017f8 <dup+0xeb>
  8017f4:	89 fb                	mov    %edi,%ebx
  8017f6:	eb 23                	jmp    80181b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8017f8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801803:	e8 22 f8 ff ff       	call   80102a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801808:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80180b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80180f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801816:	e8 0f f8 ff ff       	call   80102a <sys_page_unmap>
	return r;
}
  80181b:	89 d8                	mov    %ebx,%eax
  80181d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801820:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801823:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801826:	89 ec                	mov    %ebp,%esp
  801828:	5d                   	pop    %ebp
  801829:	c3                   	ret    
	...

0080182c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	53                   	push   %ebx
  801830:	83 ec 14             	sub    $0x14,%esp
  801833:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801835:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80183b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801842:	00 
  801843:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  80184a:	00 
  80184b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184f:	89 14 24             	mov    %edx,(%esp)
  801852:	e8 89 0e 00 00       	call   8026e0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801857:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80185e:	00 
  80185f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801863:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80186a:	e8 d3 0e 00 00       	call   802742 <ipc_recv>
}
  80186f:	83 c4 14             	add    $0x14,%esp
  801872:	5b                   	pop    %ebx
  801873:	5d                   	pop    %ebp
  801874:	c3                   	ret    

00801875 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
  801878:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80187b:	8b 45 08             	mov    0x8(%ebp),%eax
  80187e:	8b 40 0c             	mov    0xc(%eax),%eax
  801881:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  801886:	8b 45 0c             	mov    0xc(%ebp),%eax
  801889:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80188e:	ba 00 00 00 00       	mov    $0x0,%edx
  801893:	b8 02 00 00 00       	mov    $0x2,%eax
  801898:	e8 8f ff ff ff       	call   80182c <fsipc>
}
  80189d:	c9                   	leave  
  80189e:	c3                   	ret    

0080189f <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018a5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018aa:	b8 08 00 00 00       	mov    $0x8,%eax
  8018af:	e8 78 ff ff ff       	call   80182c <fsipc>
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	53                   	push   %ebx
  8018ba:	83 ec 14             	sub    $0x14,%esp
  8018bd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c6:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d0:	b8 05 00 00 00       	mov    $0x5,%eax
  8018d5:	e8 52 ff ff ff       	call   80182c <fsipc>
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	78 2b                	js     801909 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018de:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  8018e5:	00 
  8018e6:	89 1c 24             	mov    %ebx,(%esp)
  8018e9:	e8 9c f0 ff ff       	call   80098a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018ee:	a1 80 30 80 00       	mov    0x803080,%eax
  8018f3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018f9:	a1 84 30 80 00       	mov    0x803084,%eax
  8018fe:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801904:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801909:	83 c4 14             	add    $0x14,%esp
  80190c:	5b                   	pop    %ebx
  80190d:	5d                   	pop    %ebp
  80190e:	c3                   	ret    

0080190f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
  801912:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  801915:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80191c:	00 
  80191d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801924:	00 
  801925:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  80192c:	e8 b5 f1 ff ff       	call   800ae6 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	8b 40 0c             	mov    0xc(%eax),%eax
  801937:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  80193c:	ba 00 00 00 00       	mov    $0x0,%edx
  801941:	b8 06 00 00 00       	mov    $0x6,%eax
  801946:	e8 e1 fe ff ff       	call   80182c <fsipc>
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801953:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80195a:	00 
  80195b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801962:	00 
  801963:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  80196a:	e8 77 f1 ff ff       	call   800ae6 <memset>
  80196f:	8b 45 10             	mov    0x10(%ebp),%eax
  801972:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801977:	76 05                	jbe    80197e <devfile_write+0x31>
  801979:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80197e:	8b 55 08             	mov    0x8(%ebp),%edx
  801981:	8b 52 0c             	mov    0xc(%edx),%edx
  801984:	89 15 00 30 80 00    	mov    %edx,0x803000
        fsipcbuf.write.req_n = numberOfBytes;
  80198a:	a3 04 30 80 00       	mov    %eax,0x803004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  80198f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801993:	8b 45 0c             	mov    0xc(%ebp),%eax
  801996:	89 44 24 04          	mov    %eax,0x4(%esp)
  80199a:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  8019a1:	e8 9f f1 ff ff       	call   800b45 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  8019a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ab:	b8 04 00 00 00       	mov    $0x4,%eax
  8019b0:	e8 77 fe ff ff       	call   80182c <fsipc>
              return r;
        return r;
}
  8019b5:	c9                   	leave  
  8019b6:	c3                   	ret    

008019b7 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8019b7:	55                   	push   %ebp
  8019b8:	89 e5                	mov    %esp,%ebp
  8019ba:	53                   	push   %ebx
  8019bb:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  8019be:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8019c5:	00 
  8019c6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019cd:	00 
  8019ce:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  8019d5:	e8 0c f1 ff ff       	call   800ae6 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e0:	a3 00 30 80 00       	mov    %eax,0x803000
        fsipcbuf.read.req_n = n;
  8019e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e8:	a3 04 30 80 00       	mov    %eax,0x803004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  8019ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f2:	b8 03 00 00 00       	mov    $0x3,%eax
  8019f7:	e8 30 fe ff ff       	call   80182c <fsipc>
  8019fc:	89 c3                	mov    %eax,%ebx
  8019fe:	85 c0                	test   %eax,%eax
  801a00:	78 17                	js     801a19 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  801a02:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a06:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801a0d:	00 
  801a0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a11:	89 04 24             	mov    %eax,(%esp)
  801a14:	e8 2c f1 ff ff       	call   800b45 <memmove>
        return r;
}
  801a19:	89 d8                	mov    %ebx,%eax
  801a1b:	83 c4 14             	add    $0x14,%esp
  801a1e:	5b                   	pop    %ebx
  801a1f:	5d                   	pop    %ebp
  801a20:	c3                   	ret    

00801a21 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
  801a24:	53                   	push   %ebx
  801a25:	83 ec 14             	sub    $0x14,%esp
  801a28:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801a2b:	89 1c 24             	mov    %ebx,(%esp)
  801a2e:	e8 0d ef ff ff       	call   800940 <strlen>
  801a33:	89 c2                	mov    %eax,%edx
  801a35:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801a3a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801a40:	7f 1f                	jg     801a61 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801a42:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a46:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801a4d:	e8 38 ef ff ff       	call   80098a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801a52:	ba 00 00 00 00       	mov    $0x0,%edx
  801a57:	b8 07 00 00 00       	mov    $0x7,%eax
  801a5c:	e8 cb fd ff ff       	call   80182c <fsipc>
}
  801a61:	83 c4 14             	add    $0x14,%esp
  801a64:	5b                   	pop    %ebx
  801a65:	5d                   	pop    %ebp
  801a66:	c3                   	ret    

00801a67 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
  801a6a:	56                   	push   %esi
  801a6b:	53                   	push   %ebx
  801a6c:	83 ec 20             	sub    $0x20,%esp
  801a6f:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  801a72:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801a79:	00 
  801a7a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a81:	00 
  801a82:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801a89:	e8 58 f0 ff ff       	call   800ae6 <memset>
    if(strlen(path)>=MAXPATHLEN)
  801a8e:	89 34 24             	mov    %esi,(%esp)
  801a91:	e8 aa ee ff ff       	call   800940 <strlen>
  801a96:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a9b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801aa0:	0f 8f 84 00 00 00    	jg     801b2a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  801aa6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aa9:	89 04 24             	mov    %eax,(%esp)
  801aac:	e8 8a f7 ff ff       	call   80123b <fd_alloc>
  801ab1:	89 c3                	mov    %eax,%ebx
  801ab3:	85 c0                	test   %eax,%eax
  801ab5:	78 73                	js     801b2a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  801ab7:	0f b6 06             	movzbl (%esi),%eax
  801aba:	84 c0                	test   %al,%al
  801abc:	74 20                	je     801ade <open+0x77>
  801abe:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  801ac0:	0f be c0             	movsbl %al,%eax
  801ac3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac7:	c7 04 24 c0 2e 80 00 	movl   $0x802ec0,(%esp)
  801ace:	e8 d2 e7 ff ff       	call   8002a5 <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  801ad3:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  801ad7:	83 c3 01             	add    $0x1,%ebx
  801ada:	84 c0                	test   %al,%al
  801adc:	75 e2                	jne    801ac0 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  801ade:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ae2:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801ae9:	e8 9c ee ff ff       	call   80098a <strcpy>
    fsipcbuf.open.req_omode = mode;
  801aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af1:	a3 00 34 80 00       	mov    %eax,0x803400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  801af6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801af9:	b8 01 00 00 00       	mov    $0x1,%eax
  801afe:	e8 29 fd ff ff       	call   80182c <fsipc>
  801b03:	89 c3                	mov    %eax,%ebx
  801b05:	85 c0                	test   %eax,%eax
  801b07:	79 15                	jns    801b1e <open+0xb7>
        {
            fd_close(fd,1);
  801b09:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801b10:	00 
  801b11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b14:	89 04 24             	mov    %eax,(%esp)
  801b17:	e8 d3 fa ff ff       	call   8015ef <fd_close>
             return r;
  801b1c:	eb 0c                	jmp    801b2a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  801b1e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b21:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  801b27:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  801b2a:	89 d8                	mov    %ebx,%eax
  801b2c:	83 c4 20             	add    $0x20,%esp
  801b2f:	5b                   	pop    %ebx
  801b30:	5e                   	pop    %esi
  801b31:	5d                   	pop    %ebp
  801b32:	c3                   	ret    
	...

00801b34 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801b34:	55                   	push   %ebp
  801b35:	89 e5                	mov    %esp,%ebp
  801b37:	53                   	push   %ebx
  801b38:	83 ec 14             	sub    $0x14,%esp
  801b3b:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801b3d:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801b41:	7e 34                	jle    801b77 <writebuf+0x43>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801b43:	8b 40 04             	mov    0x4(%eax),%eax
  801b46:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b4a:	8d 43 10             	lea    0x10(%ebx),%eax
  801b4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b51:	8b 03                	mov    (%ebx),%eax
  801b53:	89 04 24             	mov    %eax,(%esp)
  801b56:	e8 2a f9 ff ff       	call   801485 <write>
		if (result > 0)
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	7e 03                	jle    801b62 <writebuf+0x2e>
			b->result += result;
  801b5f:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801b62:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b65:	74 10                	je     801b77 <writebuf+0x43>
			b->error = (result < 0 ? result : 0);
  801b67:	85 c0                	test   %eax,%eax
  801b69:	0f 9f c2             	setg   %dl
  801b6c:	0f b6 d2             	movzbl %dl,%edx
  801b6f:	83 ea 01             	sub    $0x1,%edx
  801b72:	21 d0                	and    %edx,%eax
  801b74:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801b77:	83 c4 14             	add    $0x14,%esp
  801b7a:	5b                   	pop    %ebx
  801b7b:	5d                   	pop    %ebp
  801b7c:	c3                   	ret    

00801b7d <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801b86:	8b 45 08             	mov    0x8(%ebp),%eax
  801b89:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801b8f:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801b96:	00 00 00 
	b.result = 0;
  801b99:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801ba0:	00 00 00 
	b.error = 1;
  801ba3:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801baa:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801bad:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bbb:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc5:	c7 04 24 3a 1c 80 00 	movl   $0x801c3a,(%esp)
  801bcc:	e8 8c e8 ff ff       	call   80045d <vprintfmt>
	if (b.idx > 0)
  801bd1:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801bd8:	7e 0b                	jle    801be5 <vfprintf+0x68>
		writebuf(&b);
  801bda:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801be0:	e8 4f ff ff ff       	call   801b34 <writebuf>

	return (b.result ? b.result : b.error);
  801be5:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801beb:	85 c0                	test   %eax,%eax
  801bed:	75 06                	jne    801bf5 <vfprintf+0x78>
  801bef:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  801bfd:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  801c00:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c0b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c12:	e8 66 ff ff ff       	call   801b7d <vfprintf>
	va_end(ap);

	return cnt;
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
  801c1c:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  801c1f:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  801c22:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c26:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c29:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c30:	89 04 24             	mov    %eax,(%esp)
  801c33:	e8 45 ff ff ff       	call   801b7d <vfprintf>
	va_end(ap);

	return cnt;
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	53                   	push   %ebx
  801c3e:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  801c41:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801c44:	8b 43 04             	mov    0x4(%ebx),%eax
  801c47:	8b 55 08             	mov    0x8(%ebp),%edx
  801c4a:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801c4e:	83 c0 01             	add    $0x1,%eax
  801c51:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801c54:	3d 00 01 00 00       	cmp    $0x100,%eax
  801c59:	75 0e                	jne    801c69 <putch+0x2f>
		writebuf(b);
  801c5b:	89 d8                	mov    %ebx,%eax
  801c5d:	e8 d2 fe ff ff       	call   801b34 <writebuf>
		b->idx = 0;
  801c62:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801c69:	83 c4 04             	add    $0x4,%esp
  801c6c:	5b                   	pop    %ebx
  801c6d:	5d                   	pop    %ebp
  801c6e:	c3                   	ret    
	...

00801c70 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
  801c73:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801c76:	c7 44 24 04 c3 2e 80 	movl   $0x802ec3,0x4(%esp)
  801c7d:	00 
  801c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c81:	89 04 24             	mov    %eax,(%esp)
  801c84:	e8 01 ed ff ff       	call   80098a <strcpy>
	return 0;
}
  801c89:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8e:	c9                   	leave  
  801c8f:	c3                   	ret    

00801c90 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	8b 40 0c             	mov    0xc(%eax),%eax
  801c9c:	89 04 24             	mov    %eax,(%esp)
  801c9f:	e8 9e 02 00 00       	call   801f42 <nsipc_close>
}
  801ca4:	c9                   	leave  
  801ca5:	c3                   	ret    

00801ca6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ca6:	55                   	push   %ebp
  801ca7:	89 e5                	mov    %esp,%ebp
  801ca9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801cac:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cb3:	00 
  801cb4:	8b 45 10             	mov    0x10(%ebp),%eax
  801cb7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc5:	8b 40 0c             	mov    0xc(%eax),%eax
  801cc8:	89 04 24             	mov    %eax,(%esp)
  801ccb:	e8 ae 02 00 00       	call   801f7e <nsipc_send>
}
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801cd8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cdf:	00 
  801ce0:	8b 45 10             	mov    0x10(%ebp),%eax
  801ce3:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cea:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	8b 40 0c             	mov    0xc(%eax),%eax
  801cf4:	89 04 24             	mov    %eax,(%esp)
  801cf7:	e8 f5 02 00 00       	call   801ff1 <nsipc_recv>
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	56                   	push   %esi
  801d02:	53                   	push   %ebx
  801d03:	83 ec 20             	sub    $0x20,%esp
  801d06:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d08:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d0b:	89 04 24             	mov    %eax,(%esp)
  801d0e:	e8 28 f5 ff ff       	call   80123b <fd_alloc>
  801d13:	89 c3                	mov    %eax,%ebx
  801d15:	85 c0                	test   %eax,%eax
  801d17:	78 21                	js     801d3a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801d19:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801d20:	00 
  801d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d28:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d2f:	e8 b2 f3 ff ff       	call   8010e6 <sys_page_alloc>
  801d34:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d36:	85 c0                	test   %eax,%eax
  801d38:	79 0a                	jns    801d44 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801d3a:	89 34 24             	mov    %esi,(%esp)
  801d3d:	e8 00 02 00 00       	call   801f42 <nsipc_close>
		return r;
  801d42:	eb 28                	jmp    801d6c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801d44:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d52:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d5c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d62:	89 04 24             	mov    %eax,(%esp)
  801d65:	e8 a6 f4 ff ff       	call   801210 <fd2num>
  801d6a:	89 c3                	mov    %eax,%ebx
}
  801d6c:	89 d8                	mov    %ebx,%eax
  801d6e:	83 c4 20             	add    $0x20,%esp
  801d71:	5b                   	pop    %ebx
  801d72:	5e                   	pop    %esi
  801d73:	5d                   	pop    %ebp
  801d74:	c3                   	ret    

00801d75 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801d75:	55                   	push   %ebp
  801d76:	89 e5                	mov    %esp,%ebp
  801d78:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d7e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d82:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d85:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d89:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8c:	89 04 24             	mov    %eax,(%esp)
  801d8f:	e8 62 01 00 00       	call   801ef6 <nsipc_socket>
  801d94:	85 c0                	test   %eax,%eax
  801d96:	78 05                	js     801d9d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801d98:	e8 61 ff ff ff       	call   801cfe <alloc_sockfd>
}
  801d9d:	c9                   	leave  
  801d9e:	66 90                	xchg   %ax,%ax
  801da0:	c3                   	ret    

00801da1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801da1:	55                   	push   %ebp
  801da2:	89 e5                	mov    %esp,%ebp
  801da4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801da7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801daa:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dae:	89 04 24             	mov    %eax,(%esp)
  801db1:	e8 f7 f4 ff ff       	call   8012ad <fd_lookup>
  801db6:	85 c0                	test   %eax,%eax
  801db8:	78 15                	js     801dcf <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801dba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801dbd:	8b 0a                	mov    (%edx),%ecx
  801dbf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801dc4:	3b 0d 20 60 80 00    	cmp    0x806020,%ecx
  801dca:	75 03                	jne    801dcf <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801dcc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801dcf:	c9                   	leave  
  801dd0:	c3                   	ret    

00801dd1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801dd1:	55                   	push   %ebp
  801dd2:	89 e5                	mov    %esp,%ebp
  801dd4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dda:	e8 c2 ff ff ff       	call   801da1 <fd2sockid>
  801ddf:	85 c0                	test   %eax,%eax
  801de1:	78 0f                	js     801df2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801de3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de6:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dea:	89 04 24             	mov    %eax,(%esp)
  801ded:	e8 2e 01 00 00       	call   801f20 <nsipc_listen>
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
  801df7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfd:	e8 9f ff ff ff       	call   801da1 <fd2sockid>
  801e02:	85 c0                	test   %eax,%eax
  801e04:	78 16                	js     801e1c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801e06:	8b 55 10             	mov    0x10(%ebp),%edx
  801e09:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e10:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e14:	89 04 24             	mov    %eax,(%esp)
  801e17:	e8 55 02 00 00       	call   802071 <nsipc_connect>
}
  801e1c:	c9                   	leave  
  801e1d:	c3                   	ret    

00801e1e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	e8 75 ff ff ff       	call   801da1 <fd2sockid>
  801e2c:	85 c0                	test   %eax,%eax
  801e2e:	78 0f                	js     801e3f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801e30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e33:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e37:	89 04 24             	mov    %eax,(%esp)
  801e3a:	e8 1d 01 00 00       	call   801f5c <nsipc_shutdown>
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e47:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4a:	e8 52 ff ff ff       	call   801da1 <fd2sockid>
  801e4f:	85 c0                	test   %eax,%eax
  801e51:	78 16                	js     801e69 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801e53:	8b 55 10             	mov    0x10(%ebp),%edx
  801e56:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e61:	89 04 24             	mov    %eax,(%esp)
  801e64:	e8 47 02 00 00       	call   8020b0 <nsipc_bind>
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
  801e6e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	e8 28 ff ff ff       	call   801da1 <fd2sockid>
  801e79:	85 c0                	test   %eax,%eax
  801e7b:	78 1f                	js     801e9c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e7d:	8b 55 10             	mov    0x10(%ebp),%edx
  801e80:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e87:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e8b:	89 04 24             	mov    %eax,(%esp)
  801e8e:	e8 5c 02 00 00       	call   8020ef <nsipc_accept>
  801e93:	85 c0                	test   %eax,%eax
  801e95:	78 05                	js     801e9c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801e97:	e8 62 fe ff ff       	call   801cfe <alloc_sockfd>
}
  801e9c:	c9                   	leave  
  801e9d:	8d 76 00             	lea    0x0(%esi),%esi
  801ea0:	c3                   	ret    
	...

00801eb0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801eb6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  801ebc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ec3:	00 
  801ec4:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801ecb:	00 
  801ecc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed0:	89 14 24             	mov    %edx,(%esp)
  801ed3:	e8 08 08 00 00       	call   8026e0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ed8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801edf:	00 
  801ee0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ee7:	00 
  801ee8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801eef:	e8 4e 08 00 00       	call   802742 <ipc_recv>
}
  801ef4:	c9                   	leave  
  801ef5:	c3                   	ret    

00801ef6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f07:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  801f0c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f0f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801f14:	b8 09 00 00 00       	mov    $0x9,%eax
  801f19:	e8 92 ff ff ff       	call   801eb0 <nsipc>
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f26:	8b 45 08             	mov    0x8(%ebp),%eax
  801f29:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  801f2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f31:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801f36:	b8 06 00 00 00       	mov    $0x6,%eax
  801f3b:	e8 70 ff ff ff       	call   801eb0 <nsipc>
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801f50:	b8 04 00 00 00       	mov    $0x4,%eax
  801f55:	e8 56 ff ff ff       	call   801eb0 <nsipc>
}
  801f5a:	c9                   	leave  
  801f5b:	c3                   	ret    

00801f5c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f62:	8b 45 08             	mov    0x8(%ebp),%eax
  801f65:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  801f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f6d:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801f72:	b8 03 00 00 00       	mov    $0x3,%eax
  801f77:	e8 34 ff ff ff       	call   801eb0 <nsipc>
}
  801f7c:	c9                   	leave  
  801f7d:	c3                   	ret    

00801f7e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f7e:	55                   	push   %ebp
  801f7f:	89 e5                	mov    %esp,%ebp
  801f81:	53                   	push   %ebx
  801f82:	83 ec 14             	sub    $0x14,%esp
  801f85:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801f88:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8b:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  801f90:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801f96:	7e 24                	jle    801fbc <nsipc_send+0x3e>
  801f98:	c7 44 24 0c cf 2e 80 	movl   $0x802ecf,0xc(%esp)
  801f9f:	00 
  801fa0:	c7 44 24 08 db 2e 80 	movl   $0x802edb,0x8(%esp)
  801fa7:	00 
  801fa8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801faf:	00 
  801fb0:	c7 04 24 f0 2e 80 00 	movl   $0x802ef0,(%esp)
  801fb7:	e8 24 e2 ff ff       	call   8001e0 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fbc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fc0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc7:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  801fce:	e8 72 eb ff ff       	call   800b45 <memmove>
	nsipcbuf.send.req_size = size;
  801fd3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  801fd9:	8b 45 14             	mov    0x14(%ebp),%eax
  801fdc:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  801fe1:	b8 08 00 00 00       	mov    $0x8,%eax
  801fe6:	e8 c5 fe ff ff       	call   801eb0 <nsipc>
}
  801feb:	83 c4 14             	add    $0x14,%esp
  801fee:	5b                   	pop    %ebx
  801fef:	5d                   	pop    %ebp
  801ff0:	c3                   	ret    

00801ff1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	56                   	push   %esi
  801ff5:	53                   	push   %ebx
  801ff6:	83 ec 10             	sub    $0x10,%esp
  801ff9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fff:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  802004:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  80200a:	8b 45 14             	mov    0x14(%ebp),%eax
  80200d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802012:	b8 07 00 00 00       	mov    $0x7,%eax
  802017:	e8 94 fe ff ff       	call   801eb0 <nsipc>
  80201c:	89 c3                	mov    %eax,%ebx
  80201e:	85 c0                	test   %eax,%eax
  802020:	78 46                	js     802068 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802022:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802027:	7f 04                	jg     80202d <nsipc_recv+0x3c>
  802029:	39 c6                	cmp    %eax,%esi
  80202b:	7d 24                	jge    802051 <nsipc_recv+0x60>
  80202d:	c7 44 24 0c fc 2e 80 	movl   $0x802efc,0xc(%esp)
  802034:	00 
  802035:	c7 44 24 08 db 2e 80 	movl   $0x802edb,0x8(%esp)
  80203c:	00 
  80203d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802044:	00 
  802045:	c7 04 24 f0 2e 80 00 	movl   $0x802ef0,(%esp)
  80204c:	e8 8f e1 ff ff       	call   8001e0 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802051:	89 44 24 08          	mov    %eax,0x8(%esp)
  802055:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80205c:	00 
  80205d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802060:	89 04 24             	mov    %eax,(%esp)
  802063:	e8 dd ea ff ff       	call   800b45 <memmove>
	}

	return r;
}
  802068:	89 d8                	mov    %ebx,%eax
  80206a:	83 c4 10             	add    $0x10,%esp
  80206d:	5b                   	pop    %ebx
  80206e:	5e                   	pop    %esi
  80206f:	5d                   	pop    %ebp
  802070:	c3                   	ret    

00802071 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	53                   	push   %ebx
  802075:	83 ec 14             	sub    $0x14,%esp
  802078:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80207b:	8b 45 08             	mov    0x8(%ebp),%eax
  80207e:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802083:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802087:	8b 45 0c             	mov    0xc(%ebp),%eax
  80208a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80208e:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  802095:	e8 ab ea ff ff       	call   800b45 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80209a:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  8020a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8020a5:	e8 06 fe ff ff       	call   801eb0 <nsipc>
}
  8020aa:	83 c4 14             	add    $0x14,%esp
  8020ad:	5b                   	pop    %ebx
  8020ae:	5d                   	pop    %ebp
  8020af:	c3                   	ret    

008020b0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	53                   	push   %ebx
  8020b4:	83 ec 14             	sub    $0x14,%esp
  8020b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8020bd:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020c2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020cd:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8020d4:	e8 6c ea ff ff       	call   800b45 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020d9:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  8020df:	b8 02 00 00 00       	mov    $0x2,%eax
  8020e4:	e8 c7 fd ff ff       	call   801eb0 <nsipc>
}
  8020e9:	83 c4 14             	add    $0x14,%esp
  8020ec:	5b                   	pop    %ebx
  8020ed:	5d                   	pop    %ebp
  8020ee:	c3                   	ret    

008020ef <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
  8020f2:	83 ec 18             	sub    $0x18,%esp
  8020f5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8020f8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8020fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fe:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802103:	b8 01 00 00 00       	mov    $0x1,%eax
  802108:	e8 a3 fd ff ff       	call   801eb0 <nsipc>
  80210d:	89 c3                	mov    %eax,%ebx
  80210f:	85 c0                	test   %eax,%eax
  802111:	78 25                	js     802138 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802113:	be 10 50 80 00       	mov    $0x805010,%esi
  802118:	8b 06                	mov    (%esi),%eax
  80211a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80211e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  802125:	00 
  802126:	8b 45 0c             	mov    0xc(%ebp),%eax
  802129:	89 04 24             	mov    %eax,(%esp)
  80212c:	e8 14 ea ff ff       	call   800b45 <memmove>
		*addrlen = ret->ret_addrlen;
  802131:	8b 16                	mov    (%esi),%edx
  802133:	8b 45 10             	mov    0x10(%ebp),%eax
  802136:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802138:	89 d8                	mov    %ebx,%eax
  80213a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80213d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802140:	89 ec                	mov    %ebp,%esp
  802142:	5d                   	pop    %ebp
  802143:	c3                   	ret    
	...

00802150 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 18             	sub    $0x18,%esp
  802156:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802159:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80215c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	89 04 24             	mov    %eax,(%esp)
  802165:	e8 b6 f0 ff ff       	call   801220 <fd2data>
  80216a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80216c:	c7 44 24 04 11 2f 80 	movl   $0x802f11,0x4(%esp)
  802173:	00 
  802174:	89 34 24             	mov    %esi,(%esp)
  802177:	e8 0e e8 ff ff       	call   80098a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80217c:	8b 43 04             	mov    0x4(%ebx),%eax
  80217f:	2b 03                	sub    (%ebx),%eax
  802181:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802187:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80218e:	00 00 00 
	stat->st_dev = &devpipe;
  802191:	c7 86 88 00 00 00 3c 	movl   $0x80603c,0x88(%esi)
  802198:	60 80 00 
	return 0;
}
  80219b:	b8 00 00 00 00       	mov    $0x0,%eax
  8021a0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8021a3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8021a6:	89 ec                	mov    %ebp,%esp
  8021a8:	5d                   	pop    %ebp
  8021a9:	c3                   	ret    

008021aa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	53                   	push   %ebx
  8021ae:	83 ec 14             	sub    $0x14,%esp
  8021b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021bf:	e8 66 ee ff ff       	call   80102a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021c4:	89 1c 24             	mov    %ebx,(%esp)
  8021c7:	e8 54 f0 ff ff       	call   801220 <fd2data>
  8021cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d7:	e8 4e ee ff ff       	call   80102a <sys_page_unmap>
}
  8021dc:	83 c4 14             	add    $0x14,%esp
  8021df:	5b                   	pop    %ebx
  8021e0:	5d                   	pop    %ebp
  8021e1:	c3                   	ret    

008021e2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8021e2:	55                   	push   %ebp
  8021e3:	89 e5                	mov    %esp,%ebp
  8021e5:	57                   	push   %edi
  8021e6:	56                   	push   %esi
  8021e7:	53                   	push   %ebx
  8021e8:	83 ec 2c             	sub    $0x2c,%esp
  8021eb:	89 c7                	mov    %eax,%edi
  8021ed:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8021f0:	a1 80 80 80 00       	mov    0x808080,%eax
  8021f5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8021f8:	89 3c 24             	mov    %edi,(%esp)
  8021fb:	e8 a8 05 00 00       	call   8027a8 <pageref>
  802200:	89 c6                	mov    %eax,%esi
  802202:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802205:	89 04 24             	mov    %eax,(%esp)
  802208:	e8 9b 05 00 00       	call   8027a8 <pageref>
  80220d:	39 c6                	cmp    %eax,%esi
  80220f:	0f 94 c0             	sete   %al
  802212:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802215:	8b 15 80 80 80 00    	mov    0x808080,%edx
  80221b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80221e:	39 cb                	cmp    %ecx,%ebx
  802220:	75 08                	jne    80222a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802222:	83 c4 2c             	add    $0x2c,%esp
  802225:	5b                   	pop    %ebx
  802226:	5e                   	pop    %esi
  802227:	5f                   	pop    %edi
  802228:	5d                   	pop    %ebp
  802229:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80222a:	83 f8 01             	cmp    $0x1,%eax
  80222d:	75 c1                	jne    8021f0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80222f:	8b 52 58             	mov    0x58(%edx),%edx
  802232:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802236:	89 54 24 08          	mov    %edx,0x8(%esp)
  80223a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80223e:	c7 04 24 18 2f 80 00 	movl   $0x802f18,(%esp)
  802245:	e8 5b e0 ff ff       	call   8002a5 <cprintf>
  80224a:	eb a4                	jmp    8021f0 <_pipeisclosed+0xe>

0080224c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80224c:	55                   	push   %ebp
  80224d:	89 e5                	mov    %esp,%ebp
  80224f:	57                   	push   %edi
  802250:	56                   	push   %esi
  802251:	53                   	push   %ebx
  802252:	83 ec 1c             	sub    $0x1c,%esp
  802255:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802258:	89 34 24             	mov    %esi,(%esp)
  80225b:	e8 c0 ef ff ff       	call   801220 <fd2data>
  802260:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802262:	bf 00 00 00 00       	mov    $0x0,%edi
  802267:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80226b:	75 54                	jne    8022c1 <devpipe_write+0x75>
  80226d:	eb 60                	jmp    8022cf <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80226f:	89 da                	mov    %ebx,%edx
  802271:	89 f0                	mov    %esi,%eax
  802273:	e8 6a ff ff ff       	call   8021e2 <_pipeisclosed>
  802278:	85 c0                	test   %eax,%eax
  80227a:	74 07                	je     802283 <devpipe_write+0x37>
  80227c:	b8 00 00 00 00       	mov    $0x0,%eax
  802281:	eb 53                	jmp    8022d6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802283:	90                   	nop
  802284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802288:	e8 b8 ee ff ff       	call   801145 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80228d:	8b 43 04             	mov    0x4(%ebx),%eax
  802290:	8b 13                	mov    (%ebx),%edx
  802292:	83 c2 20             	add    $0x20,%edx
  802295:	39 d0                	cmp    %edx,%eax
  802297:	73 d6                	jae    80226f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802299:	89 c2                	mov    %eax,%edx
  80229b:	c1 fa 1f             	sar    $0x1f,%edx
  80229e:	c1 ea 1b             	shr    $0x1b,%edx
  8022a1:	01 d0                	add    %edx,%eax
  8022a3:	83 e0 1f             	and    $0x1f,%eax
  8022a6:	29 d0                	sub    %edx,%eax
  8022a8:	89 c2                	mov    %eax,%edx
  8022aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022ad:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8022b1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8022b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022b9:	83 c7 01             	add    $0x1,%edi
  8022bc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8022bf:	76 13                	jbe    8022d4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022c1:	8b 43 04             	mov    0x4(%ebx),%eax
  8022c4:	8b 13                	mov    (%ebx),%edx
  8022c6:	83 c2 20             	add    $0x20,%edx
  8022c9:	39 d0                	cmp    %edx,%eax
  8022cb:	73 a2                	jae    80226f <devpipe_write+0x23>
  8022cd:	eb ca                	jmp    802299 <devpipe_write+0x4d>
  8022cf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8022d4:	89 f8                	mov    %edi,%eax
}
  8022d6:	83 c4 1c             	add    $0x1c,%esp
  8022d9:	5b                   	pop    %ebx
  8022da:	5e                   	pop    %esi
  8022db:	5f                   	pop    %edi
  8022dc:	5d                   	pop    %ebp
  8022dd:	c3                   	ret    

008022de <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022de:	55                   	push   %ebp
  8022df:	89 e5                	mov    %esp,%ebp
  8022e1:	83 ec 28             	sub    $0x28,%esp
  8022e4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8022e7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8022ea:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8022ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8022f0:	89 3c 24             	mov    %edi,(%esp)
  8022f3:	e8 28 ef ff ff       	call   801220 <fd2data>
  8022f8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022fa:	be 00 00 00 00       	mov    $0x0,%esi
  8022ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802303:	75 4c                	jne    802351 <devpipe_read+0x73>
  802305:	eb 5b                	jmp    802362 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802307:	89 f0                	mov    %esi,%eax
  802309:	eb 5e                	jmp    802369 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80230b:	89 da                	mov    %ebx,%edx
  80230d:	89 f8                	mov    %edi,%eax
  80230f:	90                   	nop
  802310:	e8 cd fe ff ff       	call   8021e2 <_pipeisclosed>
  802315:	85 c0                	test   %eax,%eax
  802317:	74 07                	je     802320 <devpipe_read+0x42>
  802319:	b8 00 00 00 00       	mov    $0x0,%eax
  80231e:	eb 49                	jmp    802369 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802320:	e8 20 ee ff ff       	call   801145 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802325:	8b 03                	mov    (%ebx),%eax
  802327:	3b 43 04             	cmp    0x4(%ebx),%eax
  80232a:	74 df                	je     80230b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80232c:	89 c2                	mov    %eax,%edx
  80232e:	c1 fa 1f             	sar    $0x1f,%edx
  802331:	c1 ea 1b             	shr    $0x1b,%edx
  802334:	01 d0                	add    %edx,%eax
  802336:	83 e0 1f             	and    $0x1f,%eax
  802339:	29 d0                	sub    %edx,%eax
  80233b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802340:	8b 55 0c             	mov    0xc(%ebp),%edx
  802343:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802346:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802349:	83 c6 01             	add    $0x1,%esi
  80234c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80234f:	76 16                	jbe    802367 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802351:	8b 03                	mov    (%ebx),%eax
  802353:	3b 43 04             	cmp    0x4(%ebx),%eax
  802356:	75 d4                	jne    80232c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802358:	85 f6                	test   %esi,%esi
  80235a:	75 ab                	jne    802307 <devpipe_read+0x29>
  80235c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802360:	eb a9                	jmp    80230b <devpipe_read+0x2d>
  802362:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802367:	89 f0                	mov    %esi,%eax
}
  802369:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80236c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80236f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802372:	89 ec                	mov    %ebp,%esp
  802374:	5d                   	pop    %ebp
  802375:	c3                   	ret    

00802376 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802376:	55                   	push   %ebp
  802377:	89 e5                	mov    %esp,%ebp
  802379:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80237c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80237f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802383:	8b 45 08             	mov    0x8(%ebp),%eax
  802386:	89 04 24             	mov    %eax,(%esp)
  802389:	e8 1f ef ff ff       	call   8012ad <fd_lookup>
  80238e:	85 c0                	test   %eax,%eax
  802390:	78 15                	js     8023a7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802395:	89 04 24             	mov    %eax,(%esp)
  802398:	e8 83 ee ff ff       	call   801220 <fd2data>
	return _pipeisclosed(fd, p);
  80239d:	89 c2                	mov    %eax,%edx
  80239f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a2:	e8 3b fe ff ff       	call   8021e2 <_pipeisclosed>
}
  8023a7:	c9                   	leave  
  8023a8:	c3                   	ret    

008023a9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8023a9:	55                   	push   %ebp
  8023aa:	89 e5                	mov    %esp,%ebp
  8023ac:	83 ec 48             	sub    $0x48,%esp
  8023af:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8023b2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8023b5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8023b8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8023bb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8023be:	89 04 24             	mov    %eax,(%esp)
  8023c1:	e8 75 ee ff ff       	call   80123b <fd_alloc>
  8023c6:	89 c3                	mov    %eax,%ebx
  8023c8:	85 c0                	test   %eax,%eax
  8023ca:	0f 88 42 01 00 00    	js     802512 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023d0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023d7:	00 
  8023d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023e6:	e8 fb ec ff ff       	call   8010e6 <sys_page_alloc>
  8023eb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8023ed:	85 c0                	test   %eax,%eax
  8023ef:	0f 88 1d 01 00 00    	js     802512 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8023f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8023f8:	89 04 24             	mov    %eax,(%esp)
  8023fb:	e8 3b ee ff ff       	call   80123b <fd_alloc>
  802400:	89 c3                	mov    %eax,%ebx
  802402:	85 c0                	test   %eax,%eax
  802404:	0f 88 f5 00 00 00    	js     8024ff <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80240a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802411:	00 
  802412:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802415:	89 44 24 04          	mov    %eax,0x4(%esp)
  802419:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802420:	e8 c1 ec ff ff       	call   8010e6 <sys_page_alloc>
  802425:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802427:	85 c0                	test   %eax,%eax
  802429:	0f 88 d0 00 00 00    	js     8024ff <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80242f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802432:	89 04 24             	mov    %eax,(%esp)
  802435:	e8 e6 ed ff ff       	call   801220 <fd2data>
  80243a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80243c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802443:	00 
  802444:	89 44 24 04          	mov    %eax,0x4(%esp)
  802448:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80244f:	e8 92 ec ff ff       	call   8010e6 <sys_page_alloc>
  802454:	89 c3                	mov    %eax,%ebx
  802456:	85 c0                	test   %eax,%eax
  802458:	0f 88 8e 00 00 00    	js     8024ec <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80245e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802461:	89 04 24             	mov    %eax,(%esp)
  802464:	e8 b7 ed ff ff       	call   801220 <fd2data>
  802469:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802470:	00 
  802471:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802475:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80247c:	00 
  80247d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802481:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802488:	e8 fb eb ff ff       	call   801088 <sys_page_map>
  80248d:	89 c3                	mov    %eax,%ebx
  80248f:	85 c0                	test   %eax,%eax
  802491:	78 49                	js     8024dc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802493:	b8 3c 60 80 00       	mov    $0x80603c,%eax
  802498:	8b 08                	mov    (%eax),%ecx
  80249a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80249d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80249f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024a2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8024a9:	8b 10                	mov    (%eax),%edx
  8024ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ae:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8024b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024b3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8024ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024bd:	89 04 24             	mov    %eax,(%esp)
  8024c0:	e8 4b ed ff ff       	call   801210 <fd2num>
  8024c5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8024c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ca:	89 04 24             	mov    %eax,(%esp)
  8024cd:	e8 3e ed ff ff       	call   801210 <fd2num>
  8024d2:	89 47 04             	mov    %eax,0x4(%edi)
  8024d5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8024da:	eb 36                	jmp    802512 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8024dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024e7:	e8 3e eb ff ff       	call   80102a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8024ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024fa:	e8 2b eb ff ff       	call   80102a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8024ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802502:	89 44 24 04          	mov    %eax,0x4(%esp)
  802506:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80250d:	e8 18 eb ff ff       	call   80102a <sys_page_unmap>
    err:
	return r;
}
  802512:	89 d8                	mov    %ebx,%eax
  802514:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802517:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80251a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80251d:	89 ec                	mov    %ebp,%esp
  80251f:	5d                   	pop    %ebp
  802520:	c3                   	ret    
	...

00802530 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802533:	b8 00 00 00 00       	mov    $0x0,%eax
  802538:	5d                   	pop    %ebp
  802539:	c3                   	ret    

0080253a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80253a:	55                   	push   %ebp
  80253b:	89 e5                	mov    %esp,%ebp
  80253d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802540:	c7 44 24 04 30 2f 80 	movl   $0x802f30,0x4(%esp)
  802547:	00 
  802548:	8b 45 0c             	mov    0xc(%ebp),%eax
  80254b:	89 04 24             	mov    %eax,(%esp)
  80254e:	e8 37 e4 ff ff       	call   80098a <strcpy>
	return 0;
}
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
  802558:	c9                   	leave  
  802559:	c3                   	ret    

0080255a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	57                   	push   %edi
  80255e:	56                   	push   %esi
  80255f:	53                   	push   %ebx
  802560:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802566:	b8 00 00 00 00       	mov    $0x0,%eax
  80256b:	be 00 00 00 00       	mov    $0x0,%esi
  802570:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802574:	74 3f                	je     8025b5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802576:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80257c:	8b 55 10             	mov    0x10(%ebp),%edx
  80257f:	29 c2                	sub    %eax,%edx
  802581:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802583:	83 fa 7f             	cmp    $0x7f,%edx
  802586:	76 05                	jbe    80258d <devcons_write+0x33>
  802588:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80258d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802591:	03 45 0c             	add    0xc(%ebp),%eax
  802594:	89 44 24 04          	mov    %eax,0x4(%esp)
  802598:	89 3c 24             	mov    %edi,(%esp)
  80259b:	e8 a5 e5 ff ff       	call   800b45 <memmove>
		sys_cputs(buf, m);
  8025a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025a4:	89 3c 24             	mov    %edi,(%esp)
  8025a7:	e8 d4 e7 ff ff       	call   800d80 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025ac:	01 de                	add    %ebx,%esi
  8025ae:	89 f0                	mov    %esi,%eax
  8025b0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025b3:	72 c7                	jb     80257c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8025b5:	89 f0                	mov    %esi,%eax
  8025b7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8025bd:	5b                   	pop    %ebx
  8025be:	5e                   	pop    %esi
  8025bf:	5f                   	pop    %edi
  8025c0:	5d                   	pop    %ebp
  8025c1:	c3                   	ret    

008025c2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8025c2:	55                   	push   %ebp
  8025c3:	89 e5                	mov    %esp,%ebp
  8025c5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8025c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025cb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8025ce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8025d5:	00 
  8025d6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025d9:	89 04 24             	mov    %eax,(%esp)
  8025dc:	e8 9f e7 ff ff       	call   800d80 <sys_cputs>
}
  8025e1:	c9                   	leave  
  8025e2:	c3                   	ret    

008025e3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8025e3:	55                   	push   %ebp
  8025e4:	89 e5                	mov    %esp,%ebp
  8025e6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8025e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025ed:	75 07                	jne    8025f6 <devcons_read+0x13>
  8025ef:	eb 28                	jmp    802619 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8025f1:	e8 4f eb ff ff       	call   801145 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8025f6:	66 90                	xchg   %ax,%ax
  8025f8:	e8 4f e7 ff ff       	call   800d4c <sys_cgetc>
  8025fd:	85 c0                	test   %eax,%eax
  8025ff:	90                   	nop
  802600:	74 ef                	je     8025f1 <devcons_read+0xe>
  802602:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802604:	85 c0                	test   %eax,%eax
  802606:	78 16                	js     80261e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802608:	83 f8 04             	cmp    $0x4,%eax
  80260b:	74 0c                	je     802619 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80260d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802610:	88 10                	mov    %dl,(%eax)
  802612:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802617:	eb 05                	jmp    80261e <devcons_read+0x3b>
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80261e:	c9                   	leave  
  80261f:	c3                   	ret    

00802620 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802626:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802629:	89 04 24             	mov    %eax,(%esp)
  80262c:	e8 0a ec ff ff       	call   80123b <fd_alloc>
  802631:	85 c0                	test   %eax,%eax
  802633:	78 3f                	js     802674 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802635:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80263c:	00 
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	89 44 24 04          	mov    %eax,0x4(%esp)
  802644:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80264b:	e8 96 ea ff ff       	call   8010e6 <sys_page_alloc>
  802650:	85 c0                	test   %eax,%eax
  802652:	78 20                	js     802674 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802654:	8b 15 58 60 80 00    	mov    0x806058,%edx
  80265a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80265d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802669:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266c:	89 04 24             	mov    %eax,(%esp)
  80266f:	e8 9c eb ff ff       	call   801210 <fd2num>
}
  802674:	c9                   	leave  
  802675:	c3                   	ret    

00802676 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802676:	55                   	push   %ebp
  802677:	89 e5                	mov    %esp,%ebp
  802679:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80267c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80267f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802683:	8b 45 08             	mov    0x8(%ebp),%eax
  802686:	89 04 24             	mov    %eax,(%esp)
  802689:	e8 1f ec ff ff       	call   8012ad <fd_lookup>
  80268e:	85 c0                	test   %eax,%eax
  802690:	78 11                	js     8026a3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 00                	mov    (%eax),%eax
  802697:	3b 05 58 60 80 00    	cmp    0x806058,%eax
  80269d:	0f 94 c0             	sete   %al
  8026a0:	0f b6 c0             	movzbl %al,%eax
}
  8026a3:	c9                   	leave  
  8026a4:	c3                   	ret    

008026a5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8026a5:	55                   	push   %ebp
  8026a6:	89 e5                	mov    %esp,%ebp
  8026a8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8026ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8026b2:	00 
  8026b3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026c1:	e8 48 ee ff ff       	call   80150e <read>
	if (r < 0)
  8026c6:	85 c0                	test   %eax,%eax
  8026c8:	78 0f                	js     8026d9 <getchar+0x34>
		return r;
	if (r < 1)
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	7f 07                	jg     8026d5 <getchar+0x30>
  8026ce:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8026d3:	eb 04                	jmp    8026d9 <getchar+0x34>
		return -E_EOF;
	return c;
  8026d5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026d9:	c9                   	leave  
  8026da:	c3                   	ret    
  8026db:	00 00                	add    %al,(%eax)
  8026dd:	00 00                	add    %al,(%eax)
	...

008026e0 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026e0:	55                   	push   %ebp
  8026e1:	89 e5                	mov    %esp,%ebp
  8026e3:	57                   	push   %edi
  8026e4:	56                   	push   %esi
  8026e5:	53                   	push   %ebx
  8026e6:	83 ec 1c             	sub    $0x1c,%esp
  8026e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8026ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026ef:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  8026f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8026f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026f9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8026fd:	89 74 24 04          	mov    %esi,0x4(%esp)
  802701:	89 1c 24             	mov    %ebx,(%esp)
  802704:	e8 cf e7 ff ff       	call   800ed8 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  802709:	85 c0                	test   %eax,%eax
  80270b:	79 21                	jns    80272e <ipc_send+0x4e>
  80270d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802710:	74 1c                	je     80272e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  802712:	c7 44 24 08 3c 2f 80 	movl   $0x802f3c,0x8(%esp)
  802719:	00 
  80271a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  802721:	00 
  802722:	c7 04 24 4e 2f 80 00 	movl   $0x802f4e,(%esp)
  802729:	e8 b2 da ff ff       	call   8001e0 <_panic>
          else if(r==-E_IPC_NOT_RECV)
  80272e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802731:	75 07                	jne    80273a <ipc_send+0x5a>
           sys_yield();
  802733:	e8 0d ea ff ff       	call   801145 <sys_yield>
          else
            break;
        }
  802738:	eb b8                	jmp    8026f2 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  80273a:	83 c4 1c             	add    $0x1c,%esp
  80273d:	5b                   	pop    %ebx
  80273e:	5e                   	pop    %esi
  80273f:	5f                   	pop    %edi
  802740:	5d                   	pop    %ebp
  802741:	c3                   	ret    

00802742 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802742:	55                   	push   %ebp
  802743:	89 e5                	mov    %esp,%ebp
  802745:	83 ec 18             	sub    $0x18,%esp
  802748:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80274b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80274e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802751:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  802754:	8b 45 0c             	mov    0xc(%ebp),%eax
  802757:	89 04 24             	mov    %eax,(%esp)
  80275a:	e8 1c e7 ff ff       	call   800e7b <sys_ipc_recv>
        if(r<0)
  80275f:	85 c0                	test   %eax,%eax
  802761:	79 17                	jns    80277a <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  802763:	85 db                	test   %ebx,%ebx
  802765:	74 06                	je     80276d <ipc_recv+0x2b>
               *from_env_store =0;
  802767:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  80276d:	85 f6                	test   %esi,%esi
  80276f:	90                   	nop
  802770:	74 2c                	je     80279e <ipc_recv+0x5c>
              *perm_store=0;
  802772:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802778:	eb 24                	jmp    80279e <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  80277a:	85 db                	test   %ebx,%ebx
  80277c:	74 0a                	je     802788 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  80277e:	a1 80 80 80 00       	mov    0x808080,%eax
  802783:	8b 40 74             	mov    0x74(%eax),%eax
  802786:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  802788:	85 f6                	test   %esi,%esi
  80278a:	74 0a                	je     802796 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  80278c:	a1 80 80 80 00       	mov    0x808080,%eax
  802791:	8b 40 78             	mov    0x78(%eax),%eax
  802794:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  802796:	a1 80 80 80 00       	mov    0x808080,%eax
  80279b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80279e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8027a1:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8027a4:	89 ec                	mov    %ebp,%esp
  8027a6:	5d                   	pop    %ebp
  8027a7:	c3                   	ret    

008027a8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027a8:	55                   	push   %ebp
  8027a9:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8027ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ae:	89 c2                	mov    %eax,%edx
  8027b0:	c1 ea 16             	shr    $0x16,%edx
  8027b3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8027ba:	f6 c2 01             	test   $0x1,%dl
  8027bd:	74 26                	je     8027e5 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  8027bf:	c1 e8 0c             	shr    $0xc,%eax
  8027c2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8027c9:	a8 01                	test   $0x1,%al
  8027cb:	74 18                	je     8027e5 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  8027cd:	c1 e8 0c             	shr    $0xc,%eax
  8027d0:	8d 14 40             	lea    (%eax,%eax,2),%edx
  8027d3:	c1 e2 02             	shl    $0x2,%edx
  8027d6:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8027db:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  8027e0:	0f b7 c0             	movzwl %ax,%eax
  8027e3:	eb 05                	jmp    8027ea <pageref+0x42>
  8027e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ea:	5d                   	pop    %ebp
  8027eb:	c3                   	ret    
  8027ec:	00 00                	add    %al,(%eax)
	...

008027f0 <__udivdi3>:
  8027f0:	55                   	push   %ebp
  8027f1:	89 e5                	mov    %esp,%ebp
  8027f3:	57                   	push   %edi
  8027f4:	56                   	push   %esi
  8027f5:	83 ec 10             	sub    $0x10,%esp
  8027f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8027fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8027fe:	8b 75 10             	mov    0x10(%ebp),%esi
  802801:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802804:	85 c0                	test   %eax,%eax
  802806:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802809:	75 35                	jne    802840 <__udivdi3+0x50>
  80280b:	39 fe                	cmp    %edi,%esi
  80280d:	77 61                	ja     802870 <__udivdi3+0x80>
  80280f:	85 f6                	test   %esi,%esi
  802811:	75 0b                	jne    80281e <__udivdi3+0x2e>
  802813:	b8 01 00 00 00       	mov    $0x1,%eax
  802818:	31 d2                	xor    %edx,%edx
  80281a:	f7 f6                	div    %esi
  80281c:	89 c6                	mov    %eax,%esi
  80281e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802821:	31 d2                	xor    %edx,%edx
  802823:	89 f8                	mov    %edi,%eax
  802825:	f7 f6                	div    %esi
  802827:	89 c7                	mov    %eax,%edi
  802829:	89 c8                	mov    %ecx,%eax
  80282b:	f7 f6                	div    %esi
  80282d:	89 c1                	mov    %eax,%ecx
  80282f:	89 fa                	mov    %edi,%edx
  802831:	89 c8                	mov    %ecx,%eax
  802833:	83 c4 10             	add    $0x10,%esp
  802836:	5e                   	pop    %esi
  802837:	5f                   	pop    %edi
  802838:	5d                   	pop    %ebp
  802839:	c3                   	ret    
  80283a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802840:	39 f8                	cmp    %edi,%eax
  802842:	77 1c                	ja     802860 <__udivdi3+0x70>
  802844:	0f bd d0             	bsr    %eax,%edx
  802847:	83 f2 1f             	xor    $0x1f,%edx
  80284a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80284d:	75 39                	jne    802888 <__udivdi3+0x98>
  80284f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802852:	0f 86 a0 00 00 00    	jbe    8028f8 <__udivdi3+0x108>
  802858:	39 f8                	cmp    %edi,%eax
  80285a:	0f 82 98 00 00 00    	jb     8028f8 <__udivdi3+0x108>
  802860:	31 ff                	xor    %edi,%edi
  802862:	31 c9                	xor    %ecx,%ecx
  802864:	89 c8                	mov    %ecx,%eax
  802866:	89 fa                	mov    %edi,%edx
  802868:	83 c4 10             	add    $0x10,%esp
  80286b:	5e                   	pop    %esi
  80286c:	5f                   	pop    %edi
  80286d:	5d                   	pop    %ebp
  80286e:	c3                   	ret    
  80286f:	90                   	nop
  802870:	89 d1                	mov    %edx,%ecx
  802872:	89 fa                	mov    %edi,%edx
  802874:	89 c8                	mov    %ecx,%eax
  802876:	31 ff                	xor    %edi,%edi
  802878:	f7 f6                	div    %esi
  80287a:	89 c1                	mov    %eax,%ecx
  80287c:	89 fa                	mov    %edi,%edx
  80287e:	89 c8                	mov    %ecx,%eax
  802880:	83 c4 10             	add    $0x10,%esp
  802883:	5e                   	pop    %esi
  802884:	5f                   	pop    %edi
  802885:	5d                   	pop    %ebp
  802886:	c3                   	ret    
  802887:	90                   	nop
  802888:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80288c:	89 f2                	mov    %esi,%edx
  80288e:	d3 e0                	shl    %cl,%eax
  802890:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802893:	b8 20 00 00 00       	mov    $0x20,%eax
  802898:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80289b:	89 c1                	mov    %eax,%ecx
  80289d:	d3 ea                	shr    %cl,%edx
  80289f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028a3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8028a6:	d3 e6                	shl    %cl,%esi
  8028a8:	89 c1                	mov    %eax,%ecx
  8028aa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8028ad:	89 fe                	mov    %edi,%esi
  8028af:	d3 ee                	shr    %cl,%esi
  8028b1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028b5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8028b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028bb:	d3 e7                	shl    %cl,%edi
  8028bd:	89 c1                	mov    %eax,%ecx
  8028bf:	d3 ea                	shr    %cl,%edx
  8028c1:	09 d7                	or     %edx,%edi
  8028c3:	89 f2                	mov    %esi,%edx
  8028c5:	89 f8                	mov    %edi,%eax
  8028c7:	f7 75 ec             	divl   -0x14(%ebp)
  8028ca:	89 d6                	mov    %edx,%esi
  8028cc:	89 c7                	mov    %eax,%edi
  8028ce:	f7 65 e8             	mull   -0x18(%ebp)
  8028d1:	39 d6                	cmp    %edx,%esi
  8028d3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8028d6:	72 30                	jb     802908 <__udivdi3+0x118>
  8028d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028db:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028df:	d3 e2                	shl    %cl,%edx
  8028e1:	39 c2                	cmp    %eax,%edx
  8028e3:	73 05                	jae    8028ea <__udivdi3+0xfa>
  8028e5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8028e8:	74 1e                	je     802908 <__udivdi3+0x118>
  8028ea:	89 f9                	mov    %edi,%ecx
  8028ec:	31 ff                	xor    %edi,%edi
  8028ee:	e9 71 ff ff ff       	jmp    802864 <__udivdi3+0x74>
  8028f3:	90                   	nop
  8028f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028f8:	31 ff                	xor    %edi,%edi
  8028fa:	b9 01 00 00 00       	mov    $0x1,%ecx
  8028ff:	e9 60 ff ff ff       	jmp    802864 <__udivdi3+0x74>
  802904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802908:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80290b:	31 ff                	xor    %edi,%edi
  80290d:	89 c8                	mov    %ecx,%eax
  80290f:	89 fa                	mov    %edi,%edx
  802911:	83 c4 10             	add    $0x10,%esp
  802914:	5e                   	pop    %esi
  802915:	5f                   	pop    %edi
  802916:	5d                   	pop    %ebp
  802917:	c3                   	ret    
	...

00802920 <__umoddi3>:
  802920:	55                   	push   %ebp
  802921:	89 e5                	mov    %esp,%ebp
  802923:	57                   	push   %edi
  802924:	56                   	push   %esi
  802925:	83 ec 20             	sub    $0x20,%esp
  802928:	8b 55 14             	mov    0x14(%ebp),%edx
  80292b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80292e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802931:	8b 75 0c             	mov    0xc(%ebp),%esi
  802934:	85 d2                	test   %edx,%edx
  802936:	89 c8                	mov    %ecx,%eax
  802938:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80293b:	75 13                	jne    802950 <__umoddi3+0x30>
  80293d:	39 f7                	cmp    %esi,%edi
  80293f:	76 3f                	jbe    802980 <__umoddi3+0x60>
  802941:	89 f2                	mov    %esi,%edx
  802943:	f7 f7                	div    %edi
  802945:	89 d0                	mov    %edx,%eax
  802947:	31 d2                	xor    %edx,%edx
  802949:	83 c4 20             	add    $0x20,%esp
  80294c:	5e                   	pop    %esi
  80294d:	5f                   	pop    %edi
  80294e:	5d                   	pop    %ebp
  80294f:	c3                   	ret    
  802950:	39 f2                	cmp    %esi,%edx
  802952:	77 4c                	ja     8029a0 <__umoddi3+0x80>
  802954:	0f bd ca             	bsr    %edx,%ecx
  802957:	83 f1 1f             	xor    $0x1f,%ecx
  80295a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80295d:	75 51                	jne    8029b0 <__umoddi3+0x90>
  80295f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802962:	0f 87 e0 00 00 00    	ja     802a48 <__umoddi3+0x128>
  802968:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296b:	29 f8                	sub    %edi,%eax
  80296d:	19 d6                	sbb    %edx,%esi
  80296f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802972:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802975:	89 f2                	mov    %esi,%edx
  802977:	83 c4 20             	add    $0x20,%esp
  80297a:	5e                   	pop    %esi
  80297b:	5f                   	pop    %edi
  80297c:	5d                   	pop    %ebp
  80297d:	c3                   	ret    
  80297e:	66 90                	xchg   %ax,%ax
  802980:	85 ff                	test   %edi,%edi
  802982:	75 0b                	jne    80298f <__umoddi3+0x6f>
  802984:	b8 01 00 00 00       	mov    $0x1,%eax
  802989:	31 d2                	xor    %edx,%edx
  80298b:	f7 f7                	div    %edi
  80298d:	89 c7                	mov    %eax,%edi
  80298f:	89 f0                	mov    %esi,%eax
  802991:	31 d2                	xor    %edx,%edx
  802993:	f7 f7                	div    %edi
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	f7 f7                	div    %edi
  80299a:	eb a9                	jmp    802945 <__umoddi3+0x25>
  80299c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029a0:	89 c8                	mov    %ecx,%eax
  8029a2:	89 f2                	mov    %esi,%edx
  8029a4:	83 c4 20             	add    $0x20,%esp
  8029a7:	5e                   	pop    %esi
  8029a8:	5f                   	pop    %edi
  8029a9:	5d                   	pop    %ebp
  8029aa:	c3                   	ret    
  8029ab:	90                   	nop
  8029ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029b0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029b4:	d3 e2                	shl    %cl,%edx
  8029b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8029b9:	ba 20 00 00 00       	mov    $0x20,%edx
  8029be:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8029c1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8029c4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8029c8:	89 fa                	mov    %edi,%edx
  8029ca:	d3 ea                	shr    %cl,%edx
  8029cc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029d0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8029d3:	d3 e7                	shl    %cl,%edi
  8029d5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8029d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8029dc:	89 f2                	mov    %esi,%edx
  8029de:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8029e1:	89 c7                	mov    %eax,%edi
  8029e3:	d3 ea                	shr    %cl,%edx
  8029e5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8029ec:	89 c2                	mov    %eax,%edx
  8029ee:	d3 e6                	shl    %cl,%esi
  8029f0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8029f4:	d3 ea                	shr    %cl,%edx
  8029f6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029fa:	09 d6                	or     %edx,%esi
  8029fc:	89 f0                	mov    %esi,%eax
  8029fe:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802a01:	d3 e7                	shl    %cl,%edi
  802a03:	89 f2                	mov    %esi,%edx
  802a05:	f7 75 f4             	divl   -0xc(%ebp)
  802a08:	89 d6                	mov    %edx,%esi
  802a0a:	f7 65 e8             	mull   -0x18(%ebp)
  802a0d:	39 d6                	cmp    %edx,%esi
  802a0f:	72 2b                	jb     802a3c <__umoddi3+0x11c>
  802a11:	39 c7                	cmp    %eax,%edi
  802a13:	72 23                	jb     802a38 <__umoddi3+0x118>
  802a15:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a19:	29 c7                	sub    %eax,%edi
  802a1b:	19 d6                	sbb    %edx,%esi
  802a1d:	89 f0                	mov    %esi,%eax
  802a1f:	89 f2                	mov    %esi,%edx
  802a21:	d3 ef                	shr    %cl,%edi
  802a23:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a27:	d3 e0                	shl    %cl,%eax
  802a29:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a2d:	09 f8                	or     %edi,%eax
  802a2f:	d3 ea                	shr    %cl,%edx
  802a31:	83 c4 20             	add    $0x20,%esp
  802a34:	5e                   	pop    %esi
  802a35:	5f                   	pop    %edi
  802a36:	5d                   	pop    %ebp
  802a37:	c3                   	ret    
  802a38:	39 d6                	cmp    %edx,%esi
  802a3a:	75 d9                	jne    802a15 <__umoddi3+0xf5>
  802a3c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802a3f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802a42:	eb d1                	jmp    802a15 <__umoddi3+0xf5>
  802a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a48:	39 f2                	cmp    %esi,%edx
  802a4a:	0f 82 18 ff ff ff    	jb     802968 <__umoddi3+0x48>
  802a50:	e9 1d ff ff ff       	jmp    802972 <__umoddi3+0x52>
