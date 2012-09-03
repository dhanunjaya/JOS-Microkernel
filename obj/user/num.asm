
obj/user/num:     file format elf32-i386


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
  80002c:	e8 9f 01 00 00       	call   8001d0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <num>:
int bol = 1;
int line = 0;

void
num(int f, char *s)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 3c             	sub    $0x3c,%esp
  80003d:	8b 75 08             	mov    0x8(%ebp),%esi
  800040:	8b 7d 0c             	mov    0xc(%ebp),%edi
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  800043:	8d 5d e7             	lea    -0x19(%ebp),%ebx
  800046:	e9 81 00 00 00       	jmp    8000cc <num+0x98>
		if (bol) {
  80004b:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  800052:	74 27                	je     80007b <num+0x47>
			printf("%5d ", ++line);
  800054:	a1 78 60 80 00       	mov    0x806078,%eax
  800059:	83 c0 01             	add    $0x1,%eax
  80005c:	a3 78 60 80 00       	mov    %eax,0x806078
  800061:	89 44 24 04          	mov    %eax,0x4(%esp)
  800065:	c7 04 24 c0 2a 80 00 	movl   $0x802ac0,(%esp)
  80006c:	e8 d6 1b 00 00       	call   801c47 <printf>
			bol = 0;
  800071:	c7 05 00 60 80 00 00 	movl   $0x0,0x806000
  800078:	00 00 00 
		}
		if ((r = write(1, &c, 1)) != 1)
  80007b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800082:	00 
  800083:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800087:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80008e:	e8 42 14 00 00       	call   8014d5 <write>
  800093:	83 f8 01             	cmp    $0x1,%eax
  800096:	74 24                	je     8000bc <num+0x88>
			panic("write error copying %s: %e", s, r);
  800098:	89 44 24 10          	mov    %eax,0x10(%esp)
  80009c:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000a0:	c7 44 24 08 c5 2a 80 	movl   $0x802ac5,0x8(%esp)
  8000a7:	00 
  8000a8:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000af:	00 
  8000b0:	c7 04 24 e0 2a 80 00 	movl   $0x802ae0,(%esp)
  8000b7:	e8 80 01 00 00       	call   80023c <_panic>
		if (c == '\n')
  8000bc:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8000c0:	75 0a                	jne    8000cc <num+0x98>
			bol = 1;
  8000c2:	c7 05 00 60 80 00 01 	movl   $0x1,0x806000
  8000c9:	00 00 00 
{
	long n;
	int r;
	char c;

	while ((n = read(f, &c, 1)) > 0) {
  8000cc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000d3:	00 
  8000d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d8:	89 34 24             	mov    %esi,(%esp)
  8000db:	e8 7e 14 00 00       	call   80155e <read>
  8000e0:	85 c0                	test   %eax,%eax
  8000e2:	0f 8f 63 ff ff ff    	jg     80004b <num+0x17>
		if ((r = write(1, &c, 1)) != 1)
			panic("write error copying %s: %e", s, r);
		if (c == '\n')
			bol = 1;
	}
	if (n < 0)
  8000e8:	85 c0                	test   %eax,%eax
  8000ea:	79 24                	jns    800110 <num+0xdc>
		panic("error reading %s: %e", s, n);
  8000ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  8000f0:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8000f4:	c7 44 24 08 eb 2a 80 	movl   $0x802aeb,0x8(%esp)
  8000fb:	00 
  8000fc:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  800103:	00 
  800104:	c7 04 24 e0 2a 80 00 	movl   $0x802ae0,(%esp)
  80010b:	e8 2c 01 00 00       	call   80023c <_panic>
}
  800110:	83 c4 3c             	add    $0x3c,%esp
  800113:	5b                   	pop    %ebx
  800114:	5e                   	pop    %esi
  800115:	5f                   	pop    %edi
  800116:	5d                   	pop    %ebp
  800117:	c3                   	ret    

00800118 <umain>:

void
umain(int argc, char **argv)
{
  800118:	55                   	push   %ebp
  800119:	89 e5                	mov    %esp,%ebp
  80011b:	57                   	push   %edi
  80011c:	56                   	push   %esi
  80011d:	53                   	push   %ebx
  80011e:	83 ec 3c             	sub    $0x3c,%esp
	int f, i;

	argv0 = "num";
  800121:	c7 05 80 60 80 00 00 	movl   $0x802b00,0x806080
  800128:	2b 80 00 
	if (argc == 1)
  80012b:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80012f:	74 0b                	je     80013c <umain+0x24>
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  800131:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800135:	7f 1b                	jg     800152 <umain+0x3a>
  800137:	e9 86 00 00 00       	jmp    8001c2 <umain+0xaa>
{
	int f, i;

	argv0 = "num";
	if (argc == 1)
		num(0, "<stdin>");
  80013c:	c7 44 24 04 04 2b 80 	movl   $0x802b04,0x4(%esp)
  800143:	00 
  800144:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014b:	e8 e4 fe ff ff       	call   800034 <num>
  800150:	eb 70                	jmp    8001c2 <umain+0xaa>
  800152:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800155:	83 c3 04             	add    $0x4,%ebx
  800158:	bf 01 00 00 00       	mov    $0x1,%edi
  80015d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
	else
		for (i = 1; i < argc; i++) {
			f = open(argv[i], O_RDONLY);
  800160:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800167:	00 
  800168:	8b 03                	mov    (%ebx),%eax
  80016a:	89 04 24             	mov    %eax,(%esp)
  80016d:	e8 45 19 00 00       	call   801ab7 <open>
  800172:	89 c6                	mov    %eax,%esi
			if (f < 0)
  800174:	85 c0                	test   %eax,%eax
  800176:	79 29                	jns    8001a1 <umain+0x89>
				panic("can't open %s: %e", argv[i], f);
  800178:	89 44 24 10          	mov    %eax,0x10(%esp)
  80017c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80017f:	8b 02                	mov    (%edx),%eax
  800181:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800185:	c7 44 24 08 0c 2b 80 	movl   $0x802b0c,0x8(%esp)
  80018c:	00 
  80018d:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
  800194:	00 
  800195:	c7 04 24 e0 2a 80 00 	movl   $0x802ae0,(%esp)
  80019c:	e8 9b 00 00 00       	call   80023c <_panic>
			else {
				num(f, argv[i]);
  8001a1:	8b 03                	mov    (%ebx),%eax
  8001a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001a7:	89 34 24             	mov    %esi,(%esp)
  8001aa:	e8 85 fe ff ff       	call   800034 <num>
				close(f);
  8001af:	89 34 24             	mov    %esi,(%esp)
  8001b2:	e8 07 15 00 00       	call   8016be <close>

	argv0 = "num";
	if (argc == 1)
		num(0, "<stdin>");
	else
		for (i = 1; i < argc; i++) {
  8001b7:	83 c7 01             	add    $0x1,%edi
  8001ba:	83 c3 04             	add    $0x4,%ebx
  8001bd:	39 7d 08             	cmp    %edi,0x8(%ebp)
  8001c0:	7f 9b                	jg     80015d <umain+0x45>
			else {
				num(f, argv[i]);
				close(f);
			}
		}
	exit();
  8001c2:	e8 59 00 00 00       	call   800220 <exit>
}
  8001c7:	83 c4 3c             	add    $0x3c,%esp
  8001ca:	5b                   	pop    %ebx
  8001cb:	5e                   	pop    %esi
  8001cc:	5f                   	pop    %edi
  8001cd:	5d                   	pop    %ebp
  8001ce:	c3                   	ret    
	...

008001d0 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001d0:	55                   	push   %ebp
  8001d1:	89 e5                	mov    %esp,%ebp
  8001d3:	83 ec 18             	sub    $0x18,%esp
  8001d6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001d9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001dc:	8b 75 08             	mov    0x8(%ebp),%esi
  8001df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  8001e2:	e8 e2 0f 00 00       	call   8011c9 <sys_getenvid>
  8001e7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001ec:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001ef:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001f4:	a3 7c 60 80 00       	mov    %eax,0x80607c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f9:	85 f6                	test   %esi,%esi
  8001fb:	7e 07                	jle    800204 <libmain+0x34>
		binaryname = argv[0];
  8001fd:	8b 03                	mov    (%ebx),%eax
  8001ff:	a3 04 60 80 00       	mov    %eax,0x806004

	// call user main routine
	umain(argc, argv);
  800204:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800208:	89 34 24             	mov    %esi,(%esp)
  80020b:	e8 08 ff ff ff       	call   800118 <umain>

	// exit gracefully
	exit();
  800210:	e8 0b 00 00 00       	call   800220 <exit>
}
  800215:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800218:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80021b:	89 ec                	mov    %ebp,%esp
  80021d:	5d                   	pop    %ebp
  80021e:	c3                   	ret    
	...

00800220 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800226:	e8 10 15 00 00       	call   80173b <close_all>
	sys_env_destroy(0);
  80022b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800232:	e8 c6 0f 00 00       	call   8011fd <sys_env_destroy>
}
  800237:	c9                   	leave  
  800238:	c3                   	ret    
  800239:	00 00                	add    %al,(%eax)
	...

0080023c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80023c:	55                   	push   %ebp
  80023d:	89 e5                	mov    %esp,%ebp
  80023f:	53                   	push   %ebx
  800240:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  800243:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800246:	a1 80 60 80 00       	mov    0x806080,%eax
  80024b:	85 c0                	test   %eax,%eax
  80024d:	74 10                	je     80025f <_panic+0x23>
		cprintf("%s: ", argv0);
  80024f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800253:	c7 04 24 35 2b 80 00 	movl   $0x802b35,(%esp)
  80025a:	e8 a2 00 00 00       	call   800301 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80025f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800262:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800266:	8b 45 08             	mov    0x8(%ebp),%eax
  800269:	89 44 24 08          	mov    %eax,0x8(%esp)
  80026d:	a1 04 60 80 00       	mov    0x806004,%eax
  800272:	89 44 24 04          	mov    %eax,0x4(%esp)
  800276:	c7 04 24 3a 2b 80 00 	movl   $0x802b3a,(%esp)
  80027d:	e8 7f 00 00 00       	call   800301 <cprintf>
	vcprintf(fmt, ap);
  800282:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800286:	8b 45 10             	mov    0x10(%ebp),%eax
  800289:	89 04 24             	mov    %eax,(%esp)
  80028c:	e8 0f 00 00 00       	call   8002a0 <vcprintf>
	cprintf("\n");
  800291:	c7 04 24 89 2f 80 00 	movl   $0x802f89,(%esp)
  800298:	e8 64 00 00 00       	call   800301 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80029d:	cc                   	int3   
  80029e:	eb fd                	jmp    80029d <_panic+0x61>

008002a0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8002a0:	55                   	push   %ebp
  8002a1:	89 e5                	mov    %esp,%ebp
  8002a3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8002a9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002b0:	00 00 00 
	b.cnt = 0;
  8002b3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002ba:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002cb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d5:	c7 04 24 1b 03 80 00 	movl   $0x80031b,(%esp)
  8002dc:	e8 cc 01 00 00       	call   8004ad <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002e1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002eb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002f1:	89 04 24             	mov    %eax,(%esp)
  8002f4:	e8 d7 0a 00 00       	call   800dd0 <sys_cputs>

	return b.cnt;
}
  8002f9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002ff:	c9                   	leave  
  800300:	c3                   	ret    

00800301 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800301:	55                   	push   %ebp
  800302:	89 e5                	mov    %esp,%ebp
  800304:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800307:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80030a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80030e:	8b 45 08             	mov    0x8(%ebp),%eax
  800311:	89 04 24             	mov    %eax,(%esp)
  800314:	e8 87 ff ff ff       	call   8002a0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800319:	c9                   	leave  
  80031a:	c3                   	ret    

0080031b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80031b:	55                   	push   %ebp
  80031c:	89 e5                	mov    %esp,%ebp
  80031e:	53                   	push   %ebx
  80031f:	83 ec 14             	sub    $0x14,%esp
  800322:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800325:	8b 03                	mov    (%ebx),%eax
  800327:	8b 55 08             	mov    0x8(%ebp),%edx
  80032a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80032e:	83 c0 01             	add    $0x1,%eax
  800331:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800333:	3d ff 00 00 00       	cmp    $0xff,%eax
  800338:	75 19                	jne    800353 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80033a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800341:	00 
  800342:	8d 43 08             	lea    0x8(%ebx),%eax
  800345:	89 04 24             	mov    %eax,(%esp)
  800348:	e8 83 0a 00 00       	call   800dd0 <sys_cputs>
		b->idx = 0;
  80034d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800353:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800357:	83 c4 14             	add    $0x14,%esp
  80035a:	5b                   	pop    %ebx
  80035b:	5d                   	pop    %ebp
  80035c:	c3                   	ret    
  80035d:	00 00                	add    %al,(%eax)
	...

00800360 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800360:	55                   	push   %ebp
  800361:	89 e5                	mov    %esp,%ebp
  800363:	57                   	push   %edi
  800364:	56                   	push   %esi
  800365:	53                   	push   %ebx
  800366:	83 ec 4c             	sub    $0x4c,%esp
  800369:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80036c:	89 d6                	mov    %edx,%esi
  80036e:	8b 45 08             	mov    0x8(%ebp),%eax
  800371:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800374:	8b 55 0c             	mov    0xc(%ebp),%edx
  800377:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80037a:	8b 45 10             	mov    0x10(%ebp),%eax
  80037d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800380:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800383:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800386:	b9 00 00 00 00       	mov    $0x0,%ecx
  80038b:	39 d1                	cmp    %edx,%ecx
  80038d:	72 15                	jb     8003a4 <printnum+0x44>
  80038f:	77 07                	ja     800398 <printnum+0x38>
  800391:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800394:	39 d0                	cmp    %edx,%eax
  800396:	76 0c                	jbe    8003a4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800398:	83 eb 01             	sub    $0x1,%ebx
  80039b:	85 db                	test   %ebx,%ebx
  80039d:	8d 76 00             	lea    0x0(%esi),%esi
  8003a0:	7f 61                	jg     800403 <printnum+0xa3>
  8003a2:	eb 70                	jmp    800414 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003a4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8003a8:	83 eb 01             	sub    $0x1,%ebx
  8003ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8003b7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8003bb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8003be:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8003c1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8003c4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003cf:	00 
  8003d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003d3:	89 04 24             	mov    %eax,(%esp)
  8003d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003dd:	e8 5e 24 00 00       	call   802840 <__udivdi3>
  8003e2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8003e5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8003e8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003ec:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003f0:	89 04 24             	mov    %eax,(%esp)
  8003f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003f7:	89 f2                	mov    %esi,%edx
  8003f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003fc:	e8 5f ff ff ff       	call   800360 <printnum>
  800401:	eb 11                	jmp    800414 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800403:	89 74 24 04          	mov    %esi,0x4(%esp)
  800407:	89 3c 24             	mov    %edi,(%esp)
  80040a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80040d:	83 eb 01             	sub    $0x1,%ebx
  800410:	85 db                	test   %ebx,%ebx
  800412:	7f ef                	jg     800403 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800414:	89 74 24 04          	mov    %esi,0x4(%esp)
  800418:	8b 74 24 04          	mov    0x4(%esp),%esi
  80041c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80041f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800423:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80042a:	00 
  80042b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80042e:	89 14 24             	mov    %edx,(%esp)
  800431:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800434:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800438:	e8 33 25 00 00       	call   802970 <__umoddi3>
  80043d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800441:	0f be 80 56 2b 80 00 	movsbl 0x802b56(%eax),%eax
  800448:	89 04 24             	mov    %eax,(%esp)
  80044b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80044e:	83 c4 4c             	add    $0x4c,%esp
  800451:	5b                   	pop    %ebx
  800452:	5e                   	pop    %esi
  800453:	5f                   	pop    %edi
  800454:	5d                   	pop    %ebp
  800455:	c3                   	ret    

00800456 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800456:	55                   	push   %ebp
  800457:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800459:	83 fa 01             	cmp    $0x1,%edx
  80045c:	7e 0e                	jle    80046c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80045e:	8b 10                	mov    (%eax),%edx
  800460:	8d 4a 08             	lea    0x8(%edx),%ecx
  800463:	89 08                	mov    %ecx,(%eax)
  800465:	8b 02                	mov    (%edx),%eax
  800467:	8b 52 04             	mov    0x4(%edx),%edx
  80046a:	eb 22                	jmp    80048e <getuint+0x38>
	else if (lflag)
  80046c:	85 d2                	test   %edx,%edx
  80046e:	74 10                	je     800480 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800470:	8b 10                	mov    (%eax),%edx
  800472:	8d 4a 04             	lea    0x4(%edx),%ecx
  800475:	89 08                	mov    %ecx,(%eax)
  800477:	8b 02                	mov    (%edx),%eax
  800479:	ba 00 00 00 00       	mov    $0x0,%edx
  80047e:	eb 0e                	jmp    80048e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800480:	8b 10                	mov    (%eax),%edx
  800482:	8d 4a 04             	lea    0x4(%edx),%ecx
  800485:	89 08                	mov    %ecx,(%eax)
  800487:	8b 02                	mov    (%edx),%eax
  800489:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80048e:	5d                   	pop    %ebp
  80048f:	c3                   	ret    

00800490 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800496:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80049a:	8b 10                	mov    (%eax),%edx
  80049c:	3b 50 04             	cmp    0x4(%eax),%edx
  80049f:	73 0a                	jae    8004ab <sprintputch+0x1b>
		*b->buf++ = ch;
  8004a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004a4:	88 0a                	mov    %cl,(%edx)
  8004a6:	83 c2 01             	add    $0x1,%edx
  8004a9:	89 10                	mov    %edx,(%eax)
}
  8004ab:	5d                   	pop    %ebp
  8004ac:	c3                   	ret    

008004ad <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8004ad:	55                   	push   %ebp
  8004ae:	89 e5                	mov    %esp,%ebp
  8004b0:	57                   	push   %edi
  8004b1:	56                   	push   %esi
  8004b2:	53                   	push   %ebx
  8004b3:	83 ec 5c             	sub    $0x5c,%esp
  8004b6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8004b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004bf:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8004c6:	eb 11                	jmp    8004d9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004c8:	85 c0                	test   %eax,%eax
  8004ca:	0f 84 09 04 00 00    	je     8008d9 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  8004d0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004d4:	89 04 24             	mov    %eax,(%esp)
  8004d7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004d9:	0f b6 03             	movzbl (%ebx),%eax
  8004dc:	83 c3 01             	add    $0x1,%ebx
  8004df:	83 f8 25             	cmp    $0x25,%eax
  8004e2:	75 e4                	jne    8004c8 <vprintfmt+0x1b>
  8004e4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8004e8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8004ef:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8004f6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800502:	eb 06                	jmp    80050a <vprintfmt+0x5d>
  800504:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800508:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80050a:	0f b6 13             	movzbl (%ebx),%edx
  80050d:	0f b6 c2             	movzbl %dl,%eax
  800510:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800513:	8d 43 01             	lea    0x1(%ebx),%eax
  800516:	83 ea 23             	sub    $0x23,%edx
  800519:	80 fa 55             	cmp    $0x55,%dl
  80051c:	0f 87 9a 03 00 00    	ja     8008bc <vprintfmt+0x40f>
  800522:	0f b6 d2             	movzbl %dl,%edx
  800525:	ff 24 95 a0 2c 80 00 	jmp    *0x802ca0(,%edx,4)
  80052c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800530:	eb d6                	jmp    800508 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800532:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800535:	83 ea 30             	sub    $0x30,%edx
  800538:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  80053b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80053e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800541:	83 fb 09             	cmp    $0x9,%ebx
  800544:	77 4c                	ja     800592 <vprintfmt+0xe5>
  800546:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800549:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80054c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80054f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800552:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800556:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800559:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80055c:	83 fb 09             	cmp    $0x9,%ebx
  80055f:	76 eb                	jbe    80054c <vprintfmt+0x9f>
  800561:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800564:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800567:	eb 29                	jmp    800592 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800569:	8b 55 14             	mov    0x14(%ebp),%edx
  80056c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80056f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800572:	8b 12                	mov    (%edx),%edx
  800574:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  800577:	eb 19                	jmp    800592 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800579:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80057c:	c1 fa 1f             	sar    $0x1f,%edx
  80057f:	f7 d2                	not    %edx
  800581:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800584:	eb 82                	jmp    800508 <vprintfmt+0x5b>
  800586:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80058d:	e9 76 ff ff ff       	jmp    800508 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800592:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800596:	0f 89 6c ff ff ff    	jns    800508 <vprintfmt+0x5b>
  80059c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80059f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005a2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8005a5:	89 55 cc             	mov    %edx,-0x34(%ebp)
  8005a8:	e9 5b ff ff ff       	jmp    800508 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8005ad:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8005b0:	e9 53 ff ff ff       	jmp    800508 <vprintfmt+0x5b>
  8005b5:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005bb:	8d 50 04             	lea    0x4(%eax),%edx
  8005be:	89 55 14             	mov    %edx,0x14(%ebp)
  8005c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005c5:	8b 00                	mov    (%eax),%eax
  8005c7:	89 04 24             	mov    %eax,(%esp)
  8005ca:	ff d7                	call   *%edi
  8005cc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8005cf:	e9 05 ff ff ff       	jmp    8004d9 <vprintfmt+0x2c>
  8005d4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005da:	8d 50 04             	lea    0x4(%eax),%edx
  8005dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e0:	8b 00                	mov    (%eax),%eax
  8005e2:	89 c2                	mov    %eax,%edx
  8005e4:	c1 fa 1f             	sar    $0x1f,%edx
  8005e7:	31 d0                	xor    %edx,%eax
  8005e9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005eb:	83 f8 0f             	cmp    $0xf,%eax
  8005ee:	7f 0b                	jg     8005fb <vprintfmt+0x14e>
  8005f0:	8b 14 85 00 2e 80 00 	mov    0x802e00(,%eax,4),%edx
  8005f7:	85 d2                	test   %edx,%edx
  8005f9:	75 20                	jne    80061b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8005fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005ff:	c7 44 24 08 67 2b 80 	movl   $0x802b67,0x8(%esp)
  800606:	00 
  800607:	89 74 24 04          	mov    %esi,0x4(%esp)
  80060b:	89 3c 24             	mov    %edi,(%esp)
  80060e:	e8 4e 03 00 00       	call   800961 <printfmt>
  800613:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800616:	e9 be fe ff ff       	jmp    8004d9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80061b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80061f:	c7 44 24 08 4d 2f 80 	movl   $0x802f4d,0x8(%esp)
  800626:	00 
  800627:	89 74 24 04          	mov    %esi,0x4(%esp)
  80062b:	89 3c 24             	mov    %edi,(%esp)
  80062e:	e8 2e 03 00 00       	call   800961 <printfmt>
  800633:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800636:	e9 9e fe ff ff       	jmp    8004d9 <vprintfmt+0x2c>
  80063b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80063e:	89 c3                	mov    %eax,%ebx
  800640:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800643:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800646:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8d 50 04             	lea    0x4(%eax),%edx
  80064f:	89 55 14             	mov    %edx,0x14(%ebp)
  800652:	8b 00                	mov    (%eax),%eax
  800654:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800657:	85 c0                	test   %eax,%eax
  800659:	75 07                	jne    800662 <vprintfmt+0x1b5>
  80065b:	c7 45 c4 70 2b 80 00 	movl   $0x802b70,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800662:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  800666:	7e 06                	jle    80066e <vprintfmt+0x1c1>
  800668:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80066c:	75 13                	jne    800681 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80066e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800671:	0f be 02             	movsbl (%edx),%eax
  800674:	85 c0                	test   %eax,%eax
  800676:	0f 85 99 00 00 00    	jne    800715 <vprintfmt+0x268>
  80067c:	e9 86 00 00 00       	jmp    800707 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800681:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800685:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800688:	89 0c 24             	mov    %ecx,(%esp)
  80068b:	e8 1b 03 00 00       	call   8009ab <strnlen>
  800690:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800693:	29 c2                	sub    %eax,%edx
  800695:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800698:	85 d2                	test   %edx,%edx
  80069a:	7e d2                	jle    80066e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80069c:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  8006a0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006a3:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  8006a6:	89 d3                	mov    %edx,%ebx
  8006a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8006af:	89 04 24             	mov    %eax,(%esp)
  8006b2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006b4:	83 eb 01             	sub    $0x1,%ebx
  8006b7:	85 db                	test   %ebx,%ebx
  8006b9:	7f ed                	jg     8006a8 <vprintfmt+0x1fb>
  8006bb:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8006be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8006c5:	eb a7                	jmp    80066e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006c7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006cb:	74 18                	je     8006e5 <vprintfmt+0x238>
  8006cd:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006d0:	83 fa 5e             	cmp    $0x5e,%edx
  8006d3:	76 10                	jbe    8006e5 <vprintfmt+0x238>
					putch('?', putdat);
  8006d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006e0:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006e3:	eb 0a                	jmp    8006ef <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8006e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006e9:	89 04 24             	mov    %eax,(%esp)
  8006ec:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006ef:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8006f3:	0f be 03             	movsbl (%ebx),%eax
  8006f6:	85 c0                	test   %eax,%eax
  8006f8:	74 05                	je     8006ff <vprintfmt+0x252>
  8006fa:	83 c3 01             	add    $0x1,%ebx
  8006fd:	eb 29                	jmp    800728 <vprintfmt+0x27b>
  8006ff:	89 fe                	mov    %edi,%esi
  800701:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800704:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800707:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80070b:	7f 2e                	jg     80073b <vprintfmt+0x28e>
  80070d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800710:	e9 c4 fd ff ff       	jmp    8004d9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800715:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800718:	83 c2 01             	add    $0x1,%edx
  80071b:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80071e:	89 f7                	mov    %esi,%edi
  800720:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800723:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  800726:	89 d3                	mov    %edx,%ebx
  800728:	85 f6                	test   %esi,%esi
  80072a:	78 9b                	js     8006c7 <vprintfmt+0x21a>
  80072c:	83 ee 01             	sub    $0x1,%esi
  80072f:	79 96                	jns    8006c7 <vprintfmt+0x21a>
  800731:	89 fe                	mov    %edi,%esi
  800733:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800736:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800739:	eb cc                	jmp    800707 <vprintfmt+0x25a>
  80073b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  80073e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800741:	89 74 24 04          	mov    %esi,0x4(%esp)
  800745:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80074c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80074e:	83 eb 01             	sub    $0x1,%ebx
  800751:	85 db                	test   %ebx,%ebx
  800753:	7f ec                	jg     800741 <vprintfmt+0x294>
  800755:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800758:	e9 7c fd ff ff       	jmp    8004d9 <vprintfmt+0x2c>
  80075d:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800760:	83 f9 01             	cmp    $0x1,%ecx
  800763:	7e 16                	jle    80077b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	8d 50 08             	lea    0x8(%eax),%edx
  80076b:	89 55 14             	mov    %edx,0x14(%ebp)
  80076e:	8b 10                	mov    (%eax),%edx
  800770:	8b 48 04             	mov    0x4(%eax),%ecx
  800773:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800776:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800779:	eb 32                	jmp    8007ad <vprintfmt+0x300>
	else if (lflag)
  80077b:	85 c9                	test   %ecx,%ecx
  80077d:	74 18                	je     800797 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8d 50 04             	lea    0x4(%eax),%edx
  800785:	89 55 14             	mov    %edx,0x14(%ebp)
  800788:	8b 00                	mov    (%eax),%eax
  80078a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80078d:	89 c1                	mov    %eax,%ecx
  80078f:	c1 f9 1f             	sar    $0x1f,%ecx
  800792:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800795:	eb 16                	jmp    8007ad <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800797:	8b 45 14             	mov    0x14(%ebp),%eax
  80079a:	8d 50 04             	lea    0x4(%eax),%edx
  80079d:	89 55 14             	mov    %edx,0x14(%ebp)
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007a5:	89 c2                	mov    %eax,%edx
  8007a7:	c1 fa 1f             	sar    $0x1f,%edx
  8007aa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ad:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8007b0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007b3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007b8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007bc:	0f 89 b8 00 00 00    	jns    80087a <vprintfmt+0x3cd>
				putch('-', putdat);
  8007c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007c6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007cd:	ff d7                	call   *%edi
				num = -(long long) num;
  8007cf:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8007d2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007d5:	f7 d9                	neg    %ecx
  8007d7:	83 d3 00             	adc    $0x0,%ebx
  8007da:	f7 db                	neg    %ebx
  8007dc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007e1:	e9 94 00 00 00       	jmp    80087a <vprintfmt+0x3cd>
  8007e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007e9:	89 ca                	mov    %ecx,%edx
  8007eb:	8d 45 14             	lea    0x14(%ebp),%eax
  8007ee:	e8 63 fc ff ff       	call   800456 <getuint>
  8007f3:	89 c1                	mov    %eax,%ecx
  8007f5:	89 d3                	mov    %edx,%ebx
  8007f7:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8007fc:	eb 7c                	jmp    80087a <vprintfmt+0x3cd>
  8007fe:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800801:	89 74 24 04          	mov    %esi,0x4(%esp)
  800805:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  80080c:	ff d7                	call   *%edi
			putch('X', putdat);
  80080e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800812:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800819:	ff d7                	call   *%edi
			putch('X', putdat);
  80081b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80081f:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800826:	ff d7                	call   *%edi
  800828:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80082b:	e9 a9 fc ff ff       	jmp    8004d9 <vprintfmt+0x2c>
  800830:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800833:	89 74 24 04          	mov    %esi,0x4(%esp)
  800837:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80083e:	ff d7                	call   *%edi
			putch('x', putdat);
  800840:	89 74 24 04          	mov    %esi,0x4(%esp)
  800844:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80084b:	ff d7                	call   *%edi
			num = (unsigned long long)
  80084d:	8b 45 14             	mov    0x14(%ebp),%eax
  800850:	8d 50 04             	lea    0x4(%eax),%edx
  800853:	89 55 14             	mov    %edx,0x14(%ebp)
  800856:	8b 08                	mov    (%eax),%ecx
  800858:	bb 00 00 00 00       	mov    $0x0,%ebx
  80085d:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800862:	eb 16                	jmp    80087a <vprintfmt+0x3cd>
  800864:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800867:	89 ca                	mov    %ecx,%edx
  800869:	8d 45 14             	lea    0x14(%ebp),%eax
  80086c:	e8 e5 fb ff ff       	call   800456 <getuint>
  800871:	89 c1                	mov    %eax,%ecx
  800873:	89 d3                	mov    %edx,%ebx
  800875:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80087a:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  80087e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800882:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800885:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800889:	89 44 24 08          	mov    %eax,0x8(%esp)
  80088d:	89 0c 24             	mov    %ecx,(%esp)
  800890:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800894:	89 f2                	mov    %esi,%edx
  800896:	89 f8                	mov    %edi,%eax
  800898:	e8 c3 fa ff ff       	call   800360 <printnum>
  80089d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8008a0:	e9 34 fc ff ff       	jmp    8004d9 <vprintfmt+0x2c>
  8008a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008ab:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008af:	89 14 24             	mov    %edx,(%esp)
  8008b2:	ff d7                	call   *%edi
  8008b4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8008b7:	e9 1d fc ff ff       	jmp    8004d9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008c0:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008c7:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008c9:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8008cc:	80 38 25             	cmpb   $0x25,(%eax)
  8008cf:	0f 84 04 fc ff ff    	je     8004d9 <vprintfmt+0x2c>
  8008d5:	89 c3                	mov    %eax,%ebx
  8008d7:	eb f0                	jmp    8008c9 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  8008d9:	83 c4 5c             	add    $0x5c,%esp
  8008dc:	5b                   	pop    %ebx
  8008dd:	5e                   	pop    %esi
  8008de:	5f                   	pop    %edi
  8008df:	5d                   	pop    %ebp
  8008e0:	c3                   	ret    

008008e1 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008e1:	55                   	push   %ebp
  8008e2:	89 e5                	mov    %esp,%ebp
  8008e4:	83 ec 28             	sub    $0x28,%esp
  8008e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ea:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8008ed:	85 c0                	test   %eax,%eax
  8008ef:	74 04                	je     8008f5 <vsnprintf+0x14>
  8008f1:	85 d2                	test   %edx,%edx
  8008f3:	7f 07                	jg     8008fc <vsnprintf+0x1b>
  8008f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008fa:	eb 3b                	jmp    800937 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ff:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800903:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800906:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80090d:	8b 45 14             	mov    0x14(%ebp),%eax
  800910:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800914:	8b 45 10             	mov    0x10(%ebp),%eax
  800917:	89 44 24 08          	mov    %eax,0x8(%esp)
  80091b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80091e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800922:	c7 04 24 90 04 80 00 	movl   $0x800490,(%esp)
  800929:	e8 7f fb ff ff       	call   8004ad <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80092e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800931:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800934:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800937:	c9                   	leave  
  800938:	c3                   	ret    

00800939 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
  80093c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80093f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800942:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800946:	8b 45 10             	mov    0x10(%ebp),%eax
  800949:	89 44 24 08          	mov    %eax,0x8(%esp)
  80094d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800950:	89 44 24 04          	mov    %eax,0x4(%esp)
  800954:	8b 45 08             	mov    0x8(%ebp),%eax
  800957:	89 04 24             	mov    %eax,(%esp)
  80095a:	e8 82 ff ff ff       	call   8008e1 <vsnprintf>
	va_end(ap);

	return rc;
}
  80095f:	c9                   	leave  
  800960:	c3                   	ret    

00800961 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800961:	55                   	push   %ebp
  800962:	89 e5                	mov    %esp,%ebp
  800964:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800967:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80096a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80096e:	8b 45 10             	mov    0x10(%ebp),%eax
  800971:	89 44 24 08          	mov    %eax,0x8(%esp)
  800975:	8b 45 0c             	mov    0xc(%ebp),%eax
  800978:	89 44 24 04          	mov    %eax,0x4(%esp)
  80097c:	8b 45 08             	mov    0x8(%ebp),%eax
  80097f:	89 04 24             	mov    %eax,(%esp)
  800982:	e8 26 fb ff ff       	call   8004ad <vprintfmt>
	va_end(ap);
}
  800987:	c9                   	leave  
  800988:	c3                   	ret    
  800989:	00 00                	add    %al,(%eax)
  80098b:	00 00                	add    %al,(%eax)
  80098d:	00 00                	add    %al,(%eax)
	...

00800990 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800996:	b8 00 00 00 00       	mov    $0x0,%eax
  80099b:	80 3a 00             	cmpb   $0x0,(%edx)
  80099e:	74 09                	je     8009a9 <strlen+0x19>
		n++;
  8009a0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8009a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8009a7:	75 f7                	jne    8009a0 <strlen+0x10>
		n++;
	return n;
}
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	53                   	push   %ebx
  8009af:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009b2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009b5:	85 c9                	test   %ecx,%ecx
  8009b7:	74 19                	je     8009d2 <strnlen+0x27>
  8009b9:	80 3b 00             	cmpb   $0x0,(%ebx)
  8009bc:	74 14                	je     8009d2 <strnlen+0x27>
  8009be:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8009c3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009c6:	39 c8                	cmp    %ecx,%eax
  8009c8:	74 0d                	je     8009d7 <strnlen+0x2c>
  8009ca:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8009ce:	75 f3                	jne    8009c3 <strnlen+0x18>
  8009d0:	eb 05                	jmp    8009d7 <strnlen+0x2c>
  8009d2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8009d7:	5b                   	pop    %ebx
  8009d8:	5d                   	pop    %ebp
  8009d9:	c3                   	ret    

008009da <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	53                   	push   %ebx
  8009de:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009e4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009e9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009ed:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009f0:	83 c2 01             	add    $0x1,%edx
  8009f3:	84 c9                	test   %cl,%cl
  8009f5:	75 f2                	jne    8009e9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009f7:	5b                   	pop    %ebx
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	56                   	push   %esi
  8009fe:	53                   	push   %ebx
  8009ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a05:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a08:	85 f6                	test   %esi,%esi
  800a0a:	74 18                	je     800a24 <strncpy+0x2a>
  800a0c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800a11:	0f b6 1a             	movzbl (%edx),%ebx
  800a14:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a17:	80 3a 01             	cmpb   $0x1,(%edx)
  800a1a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a1d:	83 c1 01             	add    $0x1,%ecx
  800a20:	39 ce                	cmp    %ecx,%esi
  800a22:	77 ed                	ja     800a11 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a24:	5b                   	pop    %ebx
  800a25:	5e                   	pop    %esi
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	56                   	push   %esi
  800a2c:	53                   	push   %ebx
  800a2d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a30:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a33:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a36:	89 f0                	mov    %esi,%eax
  800a38:	85 c9                	test   %ecx,%ecx
  800a3a:	74 27                	je     800a63 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800a3c:	83 e9 01             	sub    $0x1,%ecx
  800a3f:	74 1d                	je     800a5e <strlcpy+0x36>
  800a41:	0f b6 1a             	movzbl (%edx),%ebx
  800a44:	84 db                	test   %bl,%bl
  800a46:	74 16                	je     800a5e <strlcpy+0x36>
			*dst++ = *src++;
  800a48:	88 18                	mov    %bl,(%eax)
  800a4a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a4d:	83 e9 01             	sub    $0x1,%ecx
  800a50:	74 0e                	je     800a60 <strlcpy+0x38>
			*dst++ = *src++;
  800a52:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a55:	0f b6 1a             	movzbl (%edx),%ebx
  800a58:	84 db                	test   %bl,%bl
  800a5a:	75 ec                	jne    800a48 <strlcpy+0x20>
  800a5c:	eb 02                	jmp    800a60 <strlcpy+0x38>
  800a5e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800a60:	c6 00 00             	movb   $0x0,(%eax)
  800a63:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800a65:	5b                   	pop    %ebx
  800a66:	5e                   	pop    %esi
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    

00800a69 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a6f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a72:	0f b6 01             	movzbl (%ecx),%eax
  800a75:	84 c0                	test   %al,%al
  800a77:	74 15                	je     800a8e <strcmp+0x25>
  800a79:	3a 02                	cmp    (%edx),%al
  800a7b:	75 11                	jne    800a8e <strcmp+0x25>
		p++, q++;
  800a7d:	83 c1 01             	add    $0x1,%ecx
  800a80:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a83:	0f b6 01             	movzbl (%ecx),%eax
  800a86:	84 c0                	test   %al,%al
  800a88:	74 04                	je     800a8e <strcmp+0x25>
  800a8a:	3a 02                	cmp    (%edx),%al
  800a8c:	74 ef                	je     800a7d <strcmp+0x14>
  800a8e:	0f b6 c0             	movzbl %al,%eax
  800a91:	0f b6 12             	movzbl (%edx),%edx
  800a94:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	53                   	push   %ebx
  800a9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a9f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800aa5:	85 c0                	test   %eax,%eax
  800aa7:	74 23                	je     800acc <strncmp+0x34>
  800aa9:	0f b6 1a             	movzbl (%edx),%ebx
  800aac:	84 db                	test   %bl,%bl
  800aae:	74 24                	je     800ad4 <strncmp+0x3c>
  800ab0:	3a 19                	cmp    (%ecx),%bl
  800ab2:	75 20                	jne    800ad4 <strncmp+0x3c>
  800ab4:	83 e8 01             	sub    $0x1,%eax
  800ab7:	74 13                	je     800acc <strncmp+0x34>
		n--, p++, q++;
  800ab9:	83 c2 01             	add    $0x1,%edx
  800abc:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800abf:	0f b6 1a             	movzbl (%edx),%ebx
  800ac2:	84 db                	test   %bl,%bl
  800ac4:	74 0e                	je     800ad4 <strncmp+0x3c>
  800ac6:	3a 19                	cmp    (%ecx),%bl
  800ac8:	74 ea                	je     800ab4 <strncmp+0x1c>
  800aca:	eb 08                	jmp    800ad4 <strncmp+0x3c>
  800acc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ad1:	5b                   	pop    %ebx
  800ad2:	5d                   	pop    %ebp
  800ad3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ad4:	0f b6 02             	movzbl (%edx),%eax
  800ad7:	0f b6 11             	movzbl (%ecx),%edx
  800ada:	29 d0                	sub    %edx,%eax
  800adc:	eb f3                	jmp    800ad1 <strncmp+0x39>

00800ade <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ade:	55                   	push   %ebp
  800adf:	89 e5                	mov    %esp,%ebp
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ae8:	0f b6 10             	movzbl (%eax),%edx
  800aeb:	84 d2                	test   %dl,%dl
  800aed:	74 15                	je     800b04 <strchr+0x26>
		if (*s == c)
  800aef:	38 ca                	cmp    %cl,%dl
  800af1:	75 07                	jne    800afa <strchr+0x1c>
  800af3:	eb 14                	jmp    800b09 <strchr+0x2b>
  800af5:	38 ca                	cmp    %cl,%dl
  800af7:	90                   	nop
  800af8:	74 0f                	je     800b09 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800afa:	83 c0 01             	add    $0x1,%eax
  800afd:	0f b6 10             	movzbl (%eax),%edx
  800b00:	84 d2                	test   %dl,%dl
  800b02:	75 f1                	jne    800af5 <strchr+0x17>
  800b04:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800b09:	5d                   	pop    %ebp
  800b0a:	c3                   	ret    

00800b0b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b15:	0f b6 10             	movzbl (%eax),%edx
  800b18:	84 d2                	test   %dl,%dl
  800b1a:	74 18                	je     800b34 <strfind+0x29>
		if (*s == c)
  800b1c:	38 ca                	cmp    %cl,%dl
  800b1e:	75 0a                	jne    800b2a <strfind+0x1f>
  800b20:	eb 12                	jmp    800b34 <strfind+0x29>
  800b22:	38 ca                	cmp    %cl,%dl
  800b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800b28:	74 0a                	je     800b34 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b2a:	83 c0 01             	add    $0x1,%eax
  800b2d:	0f b6 10             	movzbl (%eax),%edx
  800b30:	84 d2                	test   %dl,%dl
  800b32:	75 ee                	jne    800b22 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 0c             	sub    $0xc,%esp
  800b3c:	89 1c 24             	mov    %ebx,(%esp)
  800b3f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b43:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800b47:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b50:	85 c9                	test   %ecx,%ecx
  800b52:	74 30                	je     800b84 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b54:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b5a:	75 25                	jne    800b81 <memset+0x4b>
  800b5c:	f6 c1 03             	test   $0x3,%cl
  800b5f:	75 20                	jne    800b81 <memset+0x4b>
		c &= 0xFF;
  800b61:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b64:	89 d3                	mov    %edx,%ebx
  800b66:	c1 e3 08             	shl    $0x8,%ebx
  800b69:	89 d6                	mov    %edx,%esi
  800b6b:	c1 e6 18             	shl    $0x18,%esi
  800b6e:	89 d0                	mov    %edx,%eax
  800b70:	c1 e0 10             	shl    $0x10,%eax
  800b73:	09 f0                	or     %esi,%eax
  800b75:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800b77:	09 d8                	or     %ebx,%eax
  800b79:	c1 e9 02             	shr    $0x2,%ecx
  800b7c:	fc                   	cld    
  800b7d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b7f:	eb 03                	jmp    800b84 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b81:	fc                   	cld    
  800b82:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b84:	89 f8                	mov    %edi,%eax
  800b86:	8b 1c 24             	mov    (%esp),%ebx
  800b89:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b8d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b91:	89 ec                	mov    %ebp,%esp
  800b93:	5d                   	pop    %ebp
  800b94:	c3                   	ret    

00800b95 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b95:	55                   	push   %ebp
  800b96:	89 e5                	mov    %esp,%ebp
  800b98:	83 ec 08             	sub    $0x8,%esp
  800b9b:	89 34 24             	mov    %esi,(%esp)
  800b9e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800ba8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800bab:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800bad:	39 c6                	cmp    %eax,%esi
  800baf:	73 35                	jae    800be6 <memmove+0x51>
  800bb1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800bb4:	39 d0                	cmp    %edx,%eax
  800bb6:	73 2e                	jae    800be6 <memmove+0x51>
		s += n;
		d += n;
  800bb8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bba:	f6 c2 03             	test   $0x3,%dl
  800bbd:	75 1b                	jne    800bda <memmove+0x45>
  800bbf:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bc5:	75 13                	jne    800bda <memmove+0x45>
  800bc7:	f6 c1 03             	test   $0x3,%cl
  800bca:	75 0e                	jne    800bda <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800bcc:	83 ef 04             	sub    $0x4,%edi
  800bcf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bd2:	c1 e9 02             	shr    $0x2,%ecx
  800bd5:	fd                   	std    
  800bd6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd8:	eb 09                	jmp    800be3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800bda:	83 ef 01             	sub    $0x1,%edi
  800bdd:	8d 72 ff             	lea    -0x1(%edx),%esi
  800be0:	fd                   	std    
  800be1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800be3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800be4:	eb 20                	jmp    800c06 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800be6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bec:	75 15                	jne    800c03 <memmove+0x6e>
  800bee:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bf4:	75 0d                	jne    800c03 <memmove+0x6e>
  800bf6:	f6 c1 03             	test   $0x3,%cl
  800bf9:	75 08                	jne    800c03 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800bfb:	c1 e9 02             	shr    $0x2,%ecx
  800bfe:	fc                   	cld    
  800bff:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800c01:	eb 03                	jmp    800c06 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800c03:	fc                   	cld    
  800c04:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800c06:	8b 34 24             	mov    (%esp),%esi
  800c09:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800c0d:	89 ec                	mov    %ebp,%esp
  800c0f:	5d                   	pop    %ebp
  800c10:	c3                   	ret    

00800c11 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c17:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	89 04 24             	mov    %eax,(%esp)
  800c2b:	e8 65 ff ff ff       	call   800b95 <memmove>
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	57                   	push   %edi
  800c36:	56                   	push   %esi
  800c37:	53                   	push   %ebx
  800c38:	8b 75 08             	mov    0x8(%ebp),%esi
  800c3b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800c3e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c41:	85 c9                	test   %ecx,%ecx
  800c43:	74 36                	je     800c7b <memcmp+0x49>
		if (*s1 != *s2)
  800c45:	0f b6 06             	movzbl (%esi),%eax
  800c48:	0f b6 1f             	movzbl (%edi),%ebx
  800c4b:	38 d8                	cmp    %bl,%al
  800c4d:	74 20                	je     800c6f <memcmp+0x3d>
  800c4f:	eb 14                	jmp    800c65 <memcmp+0x33>
  800c51:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800c56:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800c5b:	83 c2 01             	add    $0x1,%edx
  800c5e:	83 e9 01             	sub    $0x1,%ecx
  800c61:	38 d8                	cmp    %bl,%al
  800c63:	74 12                	je     800c77 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800c65:	0f b6 c0             	movzbl %al,%eax
  800c68:	0f b6 db             	movzbl %bl,%ebx
  800c6b:	29 d8                	sub    %ebx,%eax
  800c6d:	eb 11                	jmp    800c80 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c6f:	83 e9 01             	sub    $0x1,%ecx
  800c72:	ba 00 00 00 00       	mov    $0x0,%edx
  800c77:	85 c9                	test   %ecx,%ecx
  800c79:	75 d6                	jne    800c51 <memcmp+0x1f>
  800c7b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800c80:	5b                   	pop    %ebx
  800c81:	5e                   	pop    %esi
  800c82:	5f                   	pop    %edi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c8b:	89 c2                	mov    %eax,%edx
  800c8d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c90:	39 d0                	cmp    %edx,%eax
  800c92:	73 15                	jae    800ca9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c94:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c98:	38 08                	cmp    %cl,(%eax)
  800c9a:	75 06                	jne    800ca2 <memfind+0x1d>
  800c9c:	eb 0b                	jmp    800ca9 <memfind+0x24>
  800c9e:	38 08                	cmp    %cl,(%eax)
  800ca0:	74 07                	je     800ca9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ca2:	83 c0 01             	add    $0x1,%eax
  800ca5:	39 c2                	cmp    %eax,%edx
  800ca7:	77 f5                	ja     800c9e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    

00800cab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
  800cb1:	83 ec 04             	sub    $0x4,%esp
  800cb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cba:	0f b6 02             	movzbl (%edx),%eax
  800cbd:	3c 20                	cmp    $0x20,%al
  800cbf:	74 04                	je     800cc5 <strtol+0x1a>
  800cc1:	3c 09                	cmp    $0x9,%al
  800cc3:	75 0e                	jne    800cd3 <strtol+0x28>
		s++;
  800cc5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cc8:	0f b6 02             	movzbl (%edx),%eax
  800ccb:	3c 20                	cmp    $0x20,%al
  800ccd:	74 f6                	je     800cc5 <strtol+0x1a>
  800ccf:	3c 09                	cmp    $0x9,%al
  800cd1:	74 f2                	je     800cc5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cd3:	3c 2b                	cmp    $0x2b,%al
  800cd5:	75 0c                	jne    800ce3 <strtol+0x38>
		s++;
  800cd7:	83 c2 01             	add    $0x1,%edx
  800cda:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ce1:	eb 15                	jmp    800cf8 <strtol+0x4d>
	else if (*s == '-')
  800ce3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cea:	3c 2d                	cmp    $0x2d,%al
  800cec:	75 0a                	jne    800cf8 <strtol+0x4d>
		s++, neg = 1;
  800cee:	83 c2 01             	add    $0x1,%edx
  800cf1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cf8:	85 db                	test   %ebx,%ebx
  800cfa:	0f 94 c0             	sete   %al
  800cfd:	74 05                	je     800d04 <strtol+0x59>
  800cff:	83 fb 10             	cmp    $0x10,%ebx
  800d02:	75 18                	jne    800d1c <strtol+0x71>
  800d04:	80 3a 30             	cmpb   $0x30,(%edx)
  800d07:	75 13                	jne    800d1c <strtol+0x71>
  800d09:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800d0d:	8d 76 00             	lea    0x0(%esi),%esi
  800d10:	75 0a                	jne    800d1c <strtol+0x71>
		s += 2, base = 16;
  800d12:	83 c2 02             	add    $0x2,%edx
  800d15:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d1a:	eb 15                	jmp    800d31 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d1c:	84 c0                	test   %al,%al
  800d1e:	66 90                	xchg   %ax,%ax
  800d20:	74 0f                	je     800d31 <strtol+0x86>
  800d22:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800d27:	80 3a 30             	cmpb   $0x30,(%edx)
  800d2a:	75 05                	jne    800d31 <strtol+0x86>
		s++, base = 8;
  800d2c:	83 c2 01             	add    $0x1,%edx
  800d2f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d31:	b8 00 00 00 00       	mov    $0x0,%eax
  800d36:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d38:	0f b6 0a             	movzbl (%edx),%ecx
  800d3b:	89 cf                	mov    %ecx,%edi
  800d3d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800d40:	80 fb 09             	cmp    $0x9,%bl
  800d43:	77 08                	ja     800d4d <strtol+0xa2>
			dig = *s - '0';
  800d45:	0f be c9             	movsbl %cl,%ecx
  800d48:	83 e9 30             	sub    $0x30,%ecx
  800d4b:	eb 1e                	jmp    800d6b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800d4d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800d50:	80 fb 19             	cmp    $0x19,%bl
  800d53:	77 08                	ja     800d5d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800d55:	0f be c9             	movsbl %cl,%ecx
  800d58:	83 e9 57             	sub    $0x57,%ecx
  800d5b:	eb 0e                	jmp    800d6b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800d5d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800d60:	80 fb 19             	cmp    $0x19,%bl
  800d63:	77 15                	ja     800d7a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800d65:	0f be c9             	movsbl %cl,%ecx
  800d68:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d6b:	39 f1                	cmp    %esi,%ecx
  800d6d:	7d 0b                	jge    800d7a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800d6f:	83 c2 01             	add    $0x1,%edx
  800d72:	0f af c6             	imul   %esi,%eax
  800d75:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800d78:	eb be                	jmp    800d38 <strtol+0x8d>
  800d7a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800d7c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d80:	74 05                	je     800d87 <strtol+0xdc>
		*endptr = (char *) s;
  800d82:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d85:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d8b:	74 04                	je     800d91 <strtol+0xe6>
  800d8d:	89 c8                	mov    %ecx,%eax
  800d8f:	f7 d8                	neg    %eax
}
  800d91:	83 c4 04             	add    $0x4,%esp
  800d94:	5b                   	pop    %ebx
  800d95:	5e                   	pop    %esi
  800d96:	5f                   	pop    %edi
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    
  800d99:	00 00                	add    %al,(%eax)
	...

00800d9c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	83 ec 0c             	sub    $0xc,%esp
  800da2:	89 1c 24             	mov    %ebx,(%esp)
  800da5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800da9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dad:	ba 00 00 00 00       	mov    $0x0,%edx
  800db2:	b8 01 00 00 00       	mov    $0x1,%eax
  800db7:	89 d1                	mov    %edx,%ecx
  800db9:	89 d3                	mov    %edx,%ebx
  800dbb:	89 d7                	mov    %edx,%edi
  800dbd:	89 d6                	mov    %edx,%esi
  800dbf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800dc1:	8b 1c 24             	mov    (%esp),%ebx
  800dc4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dc8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dcc:	89 ec                	mov    %ebp,%esp
  800dce:	5d                   	pop    %ebp
  800dcf:	c3                   	ret    

00800dd0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800dd0:	55                   	push   %ebp
  800dd1:	89 e5                	mov    %esp,%ebp
  800dd3:	83 ec 0c             	sub    $0xc,%esp
  800dd6:	89 1c 24             	mov    %ebx,(%esp)
  800dd9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ddd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de1:	b8 00 00 00 00       	mov    $0x0,%eax
  800de6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dec:	89 c3                	mov    %eax,%ebx
  800dee:	89 c7                	mov    %eax,%edi
  800df0:	89 c6                	mov    %eax,%esi
  800df2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800df4:	8b 1c 24             	mov    (%esp),%ebx
  800df7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dfb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dff:	89 ec                	mov    %ebp,%esp
  800e01:	5d                   	pop    %ebp
  800e02:	c3                   	ret    

00800e03 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  800e03:	55                   	push   %ebp
  800e04:	89 e5                	mov    %esp,%ebp
  800e06:	83 ec 0c             	sub    $0xc,%esp
  800e09:	89 1c 24             	mov    %ebx,(%esp)
  800e0c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e10:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e14:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e19:	b8 10 00 00 00       	mov    $0x10,%eax
  800e1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e21:	8b 55 08             	mov    0x8(%ebp),%edx
  800e24:	89 df                	mov    %ebx,%edi
  800e26:	89 de                	mov    %ebx,%esi
  800e28:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800e2a:	8b 1c 24             	mov    (%esp),%ebx
  800e2d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e31:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e35:	89 ec                	mov    %ebp,%esp
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	83 ec 38             	sub    $0x38,%esp
  800e3f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e42:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e45:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e48:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e4d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e55:	8b 55 08             	mov    0x8(%ebp),%edx
  800e58:	89 df                	mov    %ebx,%edi
  800e5a:	89 de                	mov    %ebx,%esi
  800e5c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	7e 28                	jle    800e8a <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e62:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e66:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800e6d:	00 
  800e6e:	c7 44 24 08 5f 2e 80 	movl   $0x802e5f,0x8(%esp)
  800e75:	00 
  800e76:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e7d:	00 
  800e7e:	c7 04 24 7c 2e 80 00 	movl   $0x802e7c,(%esp)
  800e85:	e8 b2 f3 ff ff       	call   80023c <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800e8a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e8d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e90:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e93:	89 ec                	mov    %ebp,%esp
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 0c             	sub    $0xc,%esp
  800e9d:	89 1c 24             	mov    %ebx,(%esp)
  800ea0:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ea4:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ea8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ead:	b8 0e 00 00 00       	mov    $0xe,%eax
  800eb2:	89 d1                	mov    %edx,%ecx
  800eb4:	89 d3                	mov    %edx,%ebx
  800eb6:	89 d7                	mov    %edx,%edi
  800eb8:	89 d6                	mov    %edx,%esi
  800eba:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800ebc:	8b 1c 24             	mov    (%esp),%ebx
  800ebf:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ec3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ec7:	89 ec                	mov    %ebp,%esp
  800ec9:	5d                   	pop    %ebp
  800eca:	c3                   	ret    

00800ecb <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800ecb:	55                   	push   %ebp
  800ecc:	89 e5                	mov    %esp,%ebp
  800ece:	83 ec 38             	sub    $0x38,%esp
  800ed1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ed4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ed7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eda:	b9 00 00 00 00       	mov    $0x0,%ecx
  800edf:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee7:	89 cb                	mov    %ecx,%ebx
  800ee9:	89 cf                	mov    %ecx,%edi
  800eeb:	89 ce                	mov    %ecx,%esi
  800eed:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800eef:	85 c0                	test   %eax,%eax
  800ef1:	7e 28                	jle    800f1b <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ef3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ef7:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800efe:	00 
  800eff:	c7 44 24 08 5f 2e 80 	movl   $0x802e5f,0x8(%esp)
  800f06:	00 
  800f07:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f0e:	00 
  800f0f:	c7 04 24 7c 2e 80 00 	movl   $0x802e7c,(%esp)
  800f16:	e8 21 f3 ff ff       	call   80023c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f1b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f1e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f21:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f24:	89 ec                	mov    %ebp,%esp
  800f26:	5d                   	pop    %ebp
  800f27:	c3                   	ret    

00800f28 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
  800f2b:	83 ec 0c             	sub    $0xc,%esp
  800f2e:	89 1c 24             	mov    %ebx,(%esp)
  800f31:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f35:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f39:	be 00 00 00 00       	mov    $0x0,%esi
  800f3e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f43:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f46:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f51:	8b 1c 24             	mov    (%esp),%ebx
  800f54:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f58:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f5c:	89 ec                	mov    %ebp,%esp
  800f5e:	5d                   	pop    %ebp
  800f5f:	c3                   	ret    

00800f60 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
  800f63:	83 ec 38             	sub    $0x38,%esp
  800f66:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f69:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f6c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f6f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f74:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7f:	89 df                	mov    %ebx,%edi
  800f81:	89 de                	mov    %ebx,%esi
  800f83:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f85:	85 c0                	test   %eax,%eax
  800f87:	7e 28                	jle    800fb1 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f89:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f8d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f94:	00 
  800f95:	c7 44 24 08 5f 2e 80 	movl   $0x802e5f,0x8(%esp)
  800f9c:	00 
  800f9d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fa4:	00 
  800fa5:	c7 04 24 7c 2e 80 00 	movl   $0x802e7c,(%esp)
  800fac:	e8 8b f2 ff ff       	call   80023c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fb1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fb4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fb7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fba:	89 ec                	mov    %ebp,%esp
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    

00800fbe <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fbe:	55                   	push   %ebp
  800fbf:	89 e5                	mov    %esp,%ebp
  800fc1:	83 ec 38             	sub    $0x38,%esp
  800fc4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fc7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fca:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fcd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fd2:	b8 09 00 00 00       	mov    $0x9,%eax
  800fd7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fda:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdd:	89 df                	mov    %ebx,%edi
  800fdf:	89 de                	mov    %ebx,%esi
  800fe1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	7e 28                	jle    80100f <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800feb:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800ff2:	00 
  800ff3:	c7 44 24 08 5f 2e 80 	movl   $0x802e5f,0x8(%esp)
  800ffa:	00 
  800ffb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801002:	00 
  801003:	c7 04 24 7c 2e 80 00 	movl   $0x802e7c,(%esp)
  80100a:	e8 2d f2 ff ff       	call   80023c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80100f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801012:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801015:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801018:	89 ec                	mov    %ebp,%esp
  80101a:	5d                   	pop    %ebp
  80101b:	c3                   	ret    

0080101c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80101c:	55                   	push   %ebp
  80101d:	89 e5                	mov    %esp,%ebp
  80101f:	83 ec 38             	sub    $0x38,%esp
  801022:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801025:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801028:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801030:	b8 08 00 00 00       	mov    $0x8,%eax
  801035:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801038:	8b 55 08             	mov    0x8(%ebp),%edx
  80103b:	89 df                	mov    %ebx,%edi
  80103d:	89 de                	mov    %ebx,%esi
  80103f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801041:	85 c0                	test   %eax,%eax
  801043:	7e 28                	jle    80106d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801045:	89 44 24 10          	mov    %eax,0x10(%esp)
  801049:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801050:	00 
  801051:	c7 44 24 08 5f 2e 80 	movl   $0x802e5f,0x8(%esp)
  801058:	00 
  801059:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801060:	00 
  801061:	c7 04 24 7c 2e 80 00 	movl   $0x802e7c,(%esp)
  801068:	e8 cf f1 ff ff       	call   80023c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80106d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801070:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801073:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801076:	89 ec                	mov    %ebp,%esp
  801078:	5d                   	pop    %ebp
  801079:	c3                   	ret    

0080107a <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 38             	sub    $0x38,%esp
  801080:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801083:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801086:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801089:	bb 00 00 00 00       	mov    $0x0,%ebx
  80108e:	b8 06 00 00 00       	mov    $0x6,%eax
  801093:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801096:	8b 55 08             	mov    0x8(%ebp),%edx
  801099:	89 df                	mov    %ebx,%edi
  80109b:	89 de                	mov    %ebx,%esi
  80109d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80109f:	85 c0                	test   %eax,%eax
  8010a1:	7e 28                	jle    8010cb <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010a7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8010ae:	00 
  8010af:	c7 44 24 08 5f 2e 80 	movl   $0x802e5f,0x8(%esp)
  8010b6:	00 
  8010b7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010be:	00 
  8010bf:	c7 04 24 7c 2e 80 00 	movl   $0x802e7c,(%esp)
  8010c6:	e8 71 f1 ff ff       	call   80023c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010cb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010ce:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010d1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010d4:	89 ec                	mov    %ebp,%esp
  8010d6:	5d                   	pop    %ebp
  8010d7:	c3                   	ret    

008010d8 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010d8:	55                   	push   %ebp
  8010d9:	89 e5                	mov    %esp,%ebp
  8010db:	83 ec 38             	sub    $0x38,%esp
  8010de:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010e1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010e4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010e7:	b8 05 00 00 00       	mov    $0x5,%eax
  8010ec:	8b 75 18             	mov    0x18(%ebp),%esi
  8010ef:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010f2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010f5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010fd:	85 c0                	test   %eax,%eax
  8010ff:	7e 28                	jle    801129 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801101:	89 44 24 10          	mov    %eax,0x10(%esp)
  801105:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80110c:	00 
  80110d:	c7 44 24 08 5f 2e 80 	movl   $0x802e5f,0x8(%esp)
  801114:	00 
  801115:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80111c:	00 
  80111d:	c7 04 24 7c 2e 80 00 	movl   $0x802e7c,(%esp)
  801124:	e8 13 f1 ff ff       	call   80023c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801129:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80112c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80112f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801132:	89 ec                	mov    %ebp,%esp
  801134:	5d                   	pop    %ebp
  801135:	c3                   	ret    

00801136 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 38             	sub    $0x38,%esp
  80113c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80113f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801142:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801145:	be 00 00 00 00       	mov    $0x0,%esi
  80114a:	b8 04 00 00 00       	mov    $0x4,%eax
  80114f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801152:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801155:	8b 55 08             	mov    0x8(%ebp),%edx
  801158:	89 f7                	mov    %esi,%edi
  80115a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80115c:	85 c0                	test   %eax,%eax
  80115e:	7e 28                	jle    801188 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801160:	89 44 24 10          	mov    %eax,0x10(%esp)
  801164:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80116b:	00 
  80116c:	c7 44 24 08 5f 2e 80 	movl   $0x802e5f,0x8(%esp)
  801173:	00 
  801174:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80117b:	00 
  80117c:	c7 04 24 7c 2e 80 00 	movl   $0x802e7c,(%esp)
  801183:	e8 b4 f0 ff ff       	call   80023c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801188:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80118b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80118e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801191:	89 ec                	mov    %ebp,%esp
  801193:	5d                   	pop    %ebp
  801194:	c3                   	ret    

00801195 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  801195:	55                   	push   %ebp
  801196:	89 e5                	mov    %esp,%ebp
  801198:	83 ec 0c             	sub    $0xc,%esp
  80119b:	89 1c 24             	mov    %ebx,(%esp)
  80119e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011a2:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ab:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011b0:	89 d1                	mov    %edx,%ecx
  8011b2:	89 d3                	mov    %edx,%ebx
  8011b4:	89 d7                	mov    %edx,%edi
  8011b6:	89 d6                	mov    %edx,%esi
  8011b8:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011ba:	8b 1c 24             	mov    (%esp),%ebx
  8011bd:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011c1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011c5:	89 ec                	mov    %ebp,%esp
  8011c7:	5d                   	pop    %ebp
  8011c8:	c3                   	ret    

008011c9 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	83 ec 0c             	sub    $0xc,%esp
  8011cf:	89 1c 24             	mov    %ebx,(%esp)
  8011d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011d6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011da:	ba 00 00 00 00       	mov    $0x0,%edx
  8011df:	b8 02 00 00 00       	mov    $0x2,%eax
  8011e4:	89 d1                	mov    %edx,%ecx
  8011e6:	89 d3                	mov    %edx,%ebx
  8011e8:	89 d7                	mov    %edx,%edi
  8011ea:	89 d6                	mov    %edx,%esi
  8011ec:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011ee:	8b 1c 24             	mov    (%esp),%ebx
  8011f1:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011f5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011f9:	89 ec                	mov    %ebp,%esp
  8011fb:	5d                   	pop    %ebp
  8011fc:	c3                   	ret    

008011fd <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	83 ec 38             	sub    $0x38,%esp
  801203:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801206:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801209:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80120c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801211:	b8 03 00 00 00       	mov    $0x3,%eax
  801216:	8b 55 08             	mov    0x8(%ebp),%edx
  801219:	89 cb                	mov    %ecx,%ebx
  80121b:	89 cf                	mov    %ecx,%edi
  80121d:	89 ce                	mov    %ecx,%esi
  80121f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801221:	85 c0                	test   %eax,%eax
  801223:	7e 28                	jle    80124d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801225:	89 44 24 10          	mov    %eax,0x10(%esp)
  801229:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801230:	00 
  801231:	c7 44 24 08 5f 2e 80 	movl   $0x802e5f,0x8(%esp)
  801238:	00 
  801239:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801240:	00 
  801241:	c7 04 24 7c 2e 80 00 	movl   $0x802e7c,(%esp)
  801248:	e8 ef ef ff ff       	call   80023c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80124d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801250:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801253:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801256:	89 ec                	mov    %ebp,%esp
  801258:	5d                   	pop    %ebp
  801259:	c3                   	ret    
  80125a:	00 00                	add    %al,(%eax)
  80125c:	00 00                	add    %al,(%eax)
	...

00801260 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801260:	55                   	push   %ebp
  801261:	89 e5                	mov    %esp,%ebp
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	05 00 00 00 30       	add    $0x30000000,%eax
  80126b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80126e:	5d                   	pop    %ebp
  80126f:	c3                   	ret    

00801270 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801270:	55                   	push   %ebp
  801271:	89 e5                	mov    %esp,%ebp
  801273:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	89 04 24             	mov    %eax,(%esp)
  80127c:	e8 df ff ff ff       	call   801260 <fd2num>
  801281:	05 20 00 0d 00       	add    $0xd0020,%eax
  801286:	c1 e0 0c             	shl    $0xc,%eax
}
  801289:	c9                   	leave  
  80128a:	c3                   	ret    

0080128b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	57                   	push   %edi
  80128f:	56                   	push   %esi
  801290:	53                   	push   %ebx
  801291:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801294:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801299:	a8 01                	test   $0x1,%al
  80129b:	74 36                	je     8012d3 <fd_alloc+0x48>
  80129d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8012a2:	a8 01                	test   $0x1,%al
  8012a4:	74 2d                	je     8012d3 <fd_alloc+0x48>
  8012a6:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  8012ab:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8012b0:	be 00 00 40 ef       	mov    $0xef400000,%esi
  8012b5:	89 c3                	mov    %eax,%ebx
  8012b7:	89 c2                	mov    %eax,%edx
  8012b9:	c1 ea 16             	shr    $0x16,%edx
  8012bc:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8012bf:	f6 c2 01             	test   $0x1,%dl
  8012c2:	74 14                	je     8012d8 <fd_alloc+0x4d>
  8012c4:	89 c2                	mov    %eax,%edx
  8012c6:	c1 ea 0c             	shr    $0xc,%edx
  8012c9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  8012cc:	f6 c2 01             	test   $0x1,%dl
  8012cf:	75 10                	jne    8012e1 <fd_alloc+0x56>
  8012d1:	eb 05                	jmp    8012d8 <fd_alloc+0x4d>
  8012d3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  8012d8:	89 1f                	mov    %ebx,(%edi)
  8012da:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8012df:	eb 17                	jmp    8012f8 <fd_alloc+0x6d>
  8012e1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8012e6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012eb:	75 c8                	jne    8012b5 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012ed:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8012f3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8012f8:	5b                   	pop    %ebx
  8012f9:	5e                   	pop    %esi
  8012fa:	5f                   	pop    %edi
  8012fb:	5d                   	pop    %ebp
  8012fc:	c3                   	ret    

008012fd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801300:	8b 45 08             	mov    0x8(%ebp),%eax
  801303:	83 f8 1f             	cmp    $0x1f,%eax
  801306:	77 36                	ja     80133e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801308:	05 00 00 0d 00       	add    $0xd0000,%eax
  80130d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801310:	89 c2                	mov    %eax,%edx
  801312:	c1 ea 16             	shr    $0x16,%edx
  801315:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80131c:	f6 c2 01             	test   $0x1,%dl
  80131f:	74 1d                	je     80133e <fd_lookup+0x41>
  801321:	89 c2                	mov    %eax,%edx
  801323:	c1 ea 0c             	shr    $0xc,%edx
  801326:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80132d:	f6 c2 01             	test   $0x1,%dl
  801330:	74 0c                	je     80133e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801332:	8b 55 0c             	mov    0xc(%ebp),%edx
  801335:	89 02                	mov    %eax,(%edx)
  801337:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80133c:	eb 05                	jmp    801343 <fd_lookup+0x46>
  80133e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801343:	5d                   	pop    %ebp
  801344:	c3                   	ret    

00801345 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801345:	55                   	push   %ebp
  801346:	89 e5                	mov    %esp,%ebp
  801348:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80134b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80134e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	89 04 24             	mov    %eax,(%esp)
  801358:	e8 a0 ff ff ff       	call   8012fd <fd_lookup>
  80135d:	85 c0                	test   %eax,%eax
  80135f:	78 0e                	js     80136f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801361:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801364:	8b 55 0c             	mov    0xc(%ebp),%edx
  801367:	89 50 04             	mov    %edx,0x4(%eax)
  80136a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80136f:	c9                   	leave  
  801370:	c3                   	ret    

00801371 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	56                   	push   %esi
  801375:	53                   	push   %ebx
  801376:	83 ec 10             	sub    $0x10,%esp
  801379:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80137c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80137f:	b8 08 60 80 00       	mov    $0x806008,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801384:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801389:	be 0c 2f 80 00       	mov    $0x802f0c,%esi
		if (devtab[i]->dev_id == dev_id) {
  80138e:	39 08                	cmp    %ecx,(%eax)
  801390:	75 10                	jne    8013a2 <dev_lookup+0x31>
  801392:	eb 04                	jmp    801398 <dev_lookup+0x27>
  801394:	39 08                	cmp    %ecx,(%eax)
  801396:	75 0a                	jne    8013a2 <dev_lookup+0x31>
			*dev = devtab[i];
  801398:	89 03                	mov    %eax,(%ebx)
  80139a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80139f:	90                   	nop
  8013a0:	eb 31                	jmp    8013d3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8013a2:	83 c2 01             	add    $0x1,%edx
  8013a5:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8013a8:	85 c0                	test   %eax,%eax
  8013aa:	75 e8                	jne    801394 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8013ac:	a1 7c 60 80 00       	mov    0x80607c,%eax
  8013b1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8013b4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8013b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013bc:	c7 04 24 8c 2e 80 00 	movl   $0x802e8c,(%esp)
  8013c3:	e8 39 ef ff ff       	call   800301 <cprintf>
	*dev = 0;
  8013c8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8013ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8013d3:	83 c4 10             	add    $0x10,%esp
  8013d6:	5b                   	pop    %ebx
  8013d7:	5e                   	pop    %esi
  8013d8:	5d                   	pop    %ebp
  8013d9:	c3                   	ret    

008013da <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8013da:	55                   	push   %ebp
  8013db:	89 e5                	mov    %esp,%ebp
  8013dd:	53                   	push   %ebx
  8013de:	83 ec 24             	sub    $0x24,%esp
  8013e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013e4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	89 04 24             	mov    %eax,(%esp)
  8013f1:	e8 07 ff ff ff       	call   8012fd <fd_lookup>
  8013f6:	85 c0                	test   %eax,%eax
  8013f8:	78 53                	js     80144d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801404:	8b 00                	mov    (%eax),%eax
  801406:	89 04 24             	mov    %eax,(%esp)
  801409:	e8 63 ff ff ff       	call   801371 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80140e:	85 c0                	test   %eax,%eax
  801410:	78 3b                	js     80144d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801412:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801417:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80141a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80141e:	74 2d                	je     80144d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801420:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801423:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80142a:	00 00 00 
	stat->st_isdir = 0;
  80142d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801434:	00 00 00 
	stat->st_dev = dev;
  801437:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80143a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801440:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801444:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801447:	89 14 24             	mov    %edx,(%esp)
  80144a:	ff 50 14             	call   *0x14(%eax)
}
  80144d:	83 c4 24             	add    $0x24,%esp
  801450:	5b                   	pop    %ebx
  801451:	5d                   	pop    %ebp
  801452:	c3                   	ret    

00801453 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	53                   	push   %ebx
  801457:	83 ec 24             	sub    $0x24,%esp
  80145a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80145d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801460:	89 44 24 04          	mov    %eax,0x4(%esp)
  801464:	89 1c 24             	mov    %ebx,(%esp)
  801467:	e8 91 fe ff ff       	call   8012fd <fd_lookup>
  80146c:	85 c0                	test   %eax,%eax
  80146e:	78 5f                	js     8014cf <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801470:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801473:	89 44 24 04          	mov    %eax,0x4(%esp)
  801477:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147a:	8b 00                	mov    (%eax),%eax
  80147c:	89 04 24             	mov    %eax,(%esp)
  80147f:	e8 ed fe ff ff       	call   801371 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801484:	85 c0                	test   %eax,%eax
  801486:	78 47                	js     8014cf <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801488:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80148b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80148f:	75 23                	jne    8014b4 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801491:	a1 7c 60 80 00       	mov    0x80607c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801496:	8b 40 4c             	mov    0x4c(%eax),%eax
  801499:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80149d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014a1:	c7 04 24 ac 2e 80 00 	movl   $0x802eac,(%esp)
  8014a8:	e8 54 ee ff ff       	call   800301 <cprintf>
  8014ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  8014b2:	eb 1b                	jmp    8014cf <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8014b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b7:	8b 48 18             	mov    0x18(%eax),%ecx
  8014ba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014bf:	85 c9                	test   %ecx,%ecx
  8014c1:	74 0c                	je     8014cf <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8014c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ca:	89 14 24             	mov    %edx,(%esp)
  8014cd:	ff d1                	call   *%ecx
}
  8014cf:	83 c4 24             	add    $0x24,%esp
  8014d2:	5b                   	pop    %ebx
  8014d3:	5d                   	pop    %ebp
  8014d4:	c3                   	ret    

008014d5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	53                   	push   %ebx
  8014d9:	83 ec 24             	sub    $0x24,%esp
  8014dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e6:	89 1c 24             	mov    %ebx,(%esp)
  8014e9:	e8 0f fe ff ff       	call   8012fd <fd_lookup>
  8014ee:	85 c0                	test   %eax,%eax
  8014f0:	78 66                	js     801558 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014fc:	8b 00                	mov    (%eax),%eax
  8014fe:	89 04 24             	mov    %eax,(%esp)
  801501:	e8 6b fe ff ff       	call   801371 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801506:	85 c0                	test   %eax,%eax
  801508:	78 4e                	js     801558 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80150a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80150d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801511:	75 23                	jne    801536 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801513:	a1 7c 60 80 00       	mov    0x80607c,%eax
  801518:	8b 40 4c             	mov    0x4c(%eax),%eax
  80151b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80151f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801523:	c7 04 24 d0 2e 80 00 	movl   $0x802ed0,(%esp)
  80152a:	e8 d2 ed ff ff       	call   800301 <cprintf>
  80152f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801534:	eb 22                	jmp    801558 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801539:	8b 48 0c             	mov    0xc(%eax),%ecx
  80153c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801541:	85 c9                	test   %ecx,%ecx
  801543:	74 13                	je     801558 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801545:	8b 45 10             	mov    0x10(%ebp),%eax
  801548:	89 44 24 08          	mov    %eax,0x8(%esp)
  80154c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80154f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801553:	89 14 24             	mov    %edx,(%esp)
  801556:	ff d1                	call   *%ecx
}
  801558:	83 c4 24             	add    $0x24,%esp
  80155b:	5b                   	pop    %ebx
  80155c:	5d                   	pop    %ebp
  80155d:	c3                   	ret    

0080155e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
  801561:	53                   	push   %ebx
  801562:	83 ec 24             	sub    $0x24,%esp
  801565:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801568:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80156b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80156f:	89 1c 24             	mov    %ebx,(%esp)
  801572:	e8 86 fd ff ff       	call   8012fd <fd_lookup>
  801577:	85 c0                	test   %eax,%eax
  801579:	78 6b                	js     8015e6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80157b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80157e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801582:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801585:	8b 00                	mov    (%eax),%eax
  801587:	89 04 24             	mov    %eax,(%esp)
  80158a:	e8 e2 fd ff ff       	call   801371 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80158f:	85 c0                	test   %eax,%eax
  801591:	78 53                	js     8015e6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801593:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801596:	8b 42 08             	mov    0x8(%edx),%eax
  801599:	83 e0 03             	and    $0x3,%eax
  80159c:	83 f8 01             	cmp    $0x1,%eax
  80159f:	75 23                	jne    8015c4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8015a1:	a1 7c 60 80 00       	mov    0x80607c,%eax
  8015a6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8015a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8015ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b1:	c7 04 24 ed 2e 80 00 	movl   $0x802eed,(%esp)
  8015b8:	e8 44 ed ff ff       	call   800301 <cprintf>
  8015bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8015c2:	eb 22                	jmp    8015e6 <read+0x88>
	}
	if (!dev->dev_read)
  8015c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c7:	8b 48 08             	mov    0x8(%eax),%ecx
  8015ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015cf:	85 c9                	test   %ecx,%ecx
  8015d1:	74 13                	je     8015e6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e1:	89 14 24             	mov    %edx,(%esp)
  8015e4:	ff d1                	call   *%ecx
}
  8015e6:	83 c4 24             	add    $0x24,%esp
  8015e9:	5b                   	pop    %ebx
  8015ea:	5d                   	pop    %ebp
  8015eb:	c3                   	ret    

008015ec <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	57                   	push   %edi
  8015f0:	56                   	push   %esi
  8015f1:	53                   	push   %ebx
  8015f2:	83 ec 1c             	sub    $0x1c,%esp
  8015f5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015f8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801600:	bb 00 00 00 00       	mov    $0x0,%ebx
  801605:	b8 00 00 00 00       	mov    $0x0,%eax
  80160a:	85 f6                	test   %esi,%esi
  80160c:	74 29                	je     801637 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80160e:	89 f0                	mov    %esi,%eax
  801610:	29 d0                	sub    %edx,%eax
  801612:	89 44 24 08          	mov    %eax,0x8(%esp)
  801616:	03 55 0c             	add    0xc(%ebp),%edx
  801619:	89 54 24 04          	mov    %edx,0x4(%esp)
  80161d:	89 3c 24             	mov    %edi,(%esp)
  801620:	e8 39 ff ff ff       	call   80155e <read>
		if (m < 0)
  801625:	85 c0                	test   %eax,%eax
  801627:	78 0e                	js     801637 <readn+0x4b>
			return m;
		if (m == 0)
  801629:	85 c0                	test   %eax,%eax
  80162b:	74 08                	je     801635 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80162d:	01 c3                	add    %eax,%ebx
  80162f:	89 da                	mov    %ebx,%edx
  801631:	39 f3                	cmp    %esi,%ebx
  801633:	72 d9                	jb     80160e <readn+0x22>
  801635:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801637:	83 c4 1c             	add    $0x1c,%esp
  80163a:	5b                   	pop    %ebx
  80163b:	5e                   	pop    %esi
  80163c:	5f                   	pop    %edi
  80163d:	5d                   	pop    %ebp
  80163e:	c3                   	ret    

0080163f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	56                   	push   %esi
  801643:	53                   	push   %ebx
  801644:	83 ec 20             	sub    $0x20,%esp
  801647:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80164a:	89 34 24             	mov    %esi,(%esp)
  80164d:	e8 0e fc ff ff       	call   801260 <fd2num>
  801652:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801655:	89 54 24 04          	mov    %edx,0x4(%esp)
  801659:	89 04 24             	mov    %eax,(%esp)
  80165c:	e8 9c fc ff ff       	call   8012fd <fd_lookup>
  801661:	89 c3                	mov    %eax,%ebx
  801663:	85 c0                	test   %eax,%eax
  801665:	78 05                	js     80166c <fd_close+0x2d>
  801667:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80166a:	74 0c                	je     801678 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80166c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801670:	19 c0                	sbb    %eax,%eax
  801672:	f7 d0                	not    %eax
  801674:	21 c3                	and    %eax,%ebx
  801676:	eb 3d                	jmp    8016b5 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801678:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80167b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80167f:	8b 06                	mov    (%esi),%eax
  801681:	89 04 24             	mov    %eax,(%esp)
  801684:	e8 e8 fc ff ff       	call   801371 <dev_lookup>
  801689:	89 c3                	mov    %eax,%ebx
  80168b:	85 c0                	test   %eax,%eax
  80168d:	78 16                	js     8016a5 <fd_close+0x66>
		if (dev->dev_close)
  80168f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801692:	8b 40 10             	mov    0x10(%eax),%eax
  801695:	bb 00 00 00 00       	mov    $0x0,%ebx
  80169a:	85 c0                	test   %eax,%eax
  80169c:	74 07                	je     8016a5 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80169e:	89 34 24             	mov    %esi,(%esp)
  8016a1:	ff d0                	call   *%eax
  8016a3:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8016a5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016b0:	e8 c5 f9 ff ff       	call   80107a <sys_page_unmap>
	return r;
}
  8016b5:	89 d8                	mov    %ebx,%eax
  8016b7:	83 c4 20             	add    $0x20,%esp
  8016ba:	5b                   	pop    %ebx
  8016bb:	5e                   	pop    %esi
  8016bc:	5d                   	pop    %ebp
  8016bd:	c3                   	ret    

008016be <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8016be:	55                   	push   %ebp
  8016bf:	89 e5                	mov    %esp,%ebp
  8016c1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016c4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ce:	89 04 24             	mov    %eax,(%esp)
  8016d1:	e8 27 fc ff ff       	call   8012fd <fd_lookup>
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	78 13                	js     8016ed <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8016da:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016e1:	00 
  8016e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e5:	89 04 24             	mov    %eax,(%esp)
  8016e8:	e8 52 ff ff ff       	call   80163f <fd_close>
}
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    

008016ef <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8016ef:	55                   	push   %ebp
  8016f0:	89 e5                	mov    %esp,%ebp
  8016f2:	83 ec 18             	sub    $0x18,%esp
  8016f5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8016f8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801702:	00 
  801703:	8b 45 08             	mov    0x8(%ebp),%eax
  801706:	89 04 24             	mov    %eax,(%esp)
  801709:	e8 a9 03 00 00       	call   801ab7 <open>
  80170e:	89 c3                	mov    %eax,%ebx
  801710:	85 c0                	test   %eax,%eax
  801712:	78 1b                	js     80172f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801714:	8b 45 0c             	mov    0xc(%ebp),%eax
  801717:	89 44 24 04          	mov    %eax,0x4(%esp)
  80171b:	89 1c 24             	mov    %ebx,(%esp)
  80171e:	e8 b7 fc ff ff       	call   8013da <fstat>
  801723:	89 c6                	mov    %eax,%esi
	close(fd);
  801725:	89 1c 24             	mov    %ebx,(%esp)
  801728:	e8 91 ff ff ff       	call   8016be <close>
  80172d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80172f:	89 d8                	mov    %ebx,%eax
  801731:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801734:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801737:	89 ec                	mov    %ebp,%esp
  801739:	5d                   	pop    %ebp
  80173a:	c3                   	ret    

0080173b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80173b:	55                   	push   %ebp
  80173c:	89 e5                	mov    %esp,%ebp
  80173e:	53                   	push   %ebx
  80173f:	83 ec 14             	sub    $0x14,%esp
  801742:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801747:	89 1c 24             	mov    %ebx,(%esp)
  80174a:	e8 6f ff ff ff       	call   8016be <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80174f:	83 c3 01             	add    $0x1,%ebx
  801752:	83 fb 20             	cmp    $0x20,%ebx
  801755:	75 f0                	jne    801747 <close_all+0xc>
		close(i);
}
  801757:	83 c4 14             	add    $0x14,%esp
  80175a:	5b                   	pop    %ebx
  80175b:	5d                   	pop    %ebp
  80175c:	c3                   	ret    

0080175d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80175d:	55                   	push   %ebp
  80175e:	89 e5                	mov    %esp,%ebp
  801760:	83 ec 58             	sub    $0x58,%esp
  801763:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801766:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801769:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80176c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80176f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801772:	89 44 24 04          	mov    %eax,0x4(%esp)
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	89 04 24             	mov    %eax,(%esp)
  80177c:	e8 7c fb ff ff       	call   8012fd <fd_lookup>
  801781:	89 c3                	mov    %eax,%ebx
  801783:	85 c0                	test   %eax,%eax
  801785:	0f 88 e0 00 00 00    	js     80186b <dup+0x10e>
		return r;
	close(newfdnum);
  80178b:	89 3c 24             	mov    %edi,(%esp)
  80178e:	e8 2b ff ff ff       	call   8016be <close>

	newfd = INDEX2FD(newfdnum);
  801793:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801799:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80179c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80179f:	89 04 24             	mov    %eax,(%esp)
  8017a2:	e8 c9 fa ff ff       	call   801270 <fd2data>
  8017a7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017a9:	89 34 24             	mov    %esi,(%esp)
  8017ac:	e8 bf fa ff ff       	call   801270 <fd2data>
  8017b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  8017b4:	89 da                	mov    %ebx,%edx
  8017b6:	89 d8                	mov    %ebx,%eax
  8017b8:	c1 e8 16             	shr    $0x16,%eax
  8017bb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017c2:	a8 01                	test   $0x1,%al
  8017c4:	74 43                	je     801809 <dup+0xac>
  8017c6:	c1 ea 0c             	shr    $0xc,%edx
  8017c9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8017d0:	a8 01                	test   $0x1,%al
  8017d2:	74 35                	je     801809 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  8017d4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8017db:	25 07 0e 00 00       	and    $0xe07,%eax
  8017e0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017e7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017eb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017f2:	00 
  8017f3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017fe:	e8 d5 f8 ff ff       	call   8010d8 <sys_page_map>
  801803:	89 c3                	mov    %eax,%ebx
  801805:	85 c0                	test   %eax,%eax
  801807:	78 3f                	js     801848 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801809:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80180c:	89 c2                	mov    %eax,%edx
  80180e:	c1 ea 0c             	shr    $0xc,%edx
  801811:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801818:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80181e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801822:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801826:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80182d:	00 
  80182e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801832:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801839:	e8 9a f8 ff ff       	call   8010d8 <sys_page_map>
  80183e:	89 c3                	mov    %eax,%ebx
  801840:	85 c0                	test   %eax,%eax
  801842:	78 04                	js     801848 <dup+0xeb>
  801844:	89 fb                	mov    %edi,%ebx
  801846:	eb 23                	jmp    80186b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801848:	89 74 24 04          	mov    %esi,0x4(%esp)
  80184c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801853:	e8 22 f8 ff ff       	call   80107a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80185b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80185f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801866:	e8 0f f8 ff ff       	call   80107a <sys_page_unmap>
	return r;
}
  80186b:	89 d8                	mov    %ebx,%eax
  80186d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801870:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801873:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801876:	89 ec                	mov    %ebp,%esp
  801878:	5d                   	pop    %ebp
  801879:	c3                   	ret    
	...

0080187c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	53                   	push   %ebx
  801880:	83 ec 14             	sub    $0x14,%esp
  801883:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801885:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80188b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801892:	00 
  801893:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  80189a:	00 
  80189b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189f:	89 14 24             	mov    %edx,(%esp)
  8018a2:	e8 89 0e 00 00       	call   802730 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8018a7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8018ae:	00 
  8018af:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018ba:	e8 d3 0e 00 00       	call   802792 <ipc_recv>
}
  8018bf:	83 c4 14             	add    $0x14,%esp
  8018c2:	5b                   	pop    %ebx
  8018c3:	5d                   	pop    %ebp
  8018c4:	c3                   	ret    

008018c5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8018d1:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  8018d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018d9:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018de:	ba 00 00 00 00       	mov    $0x0,%edx
  8018e3:	b8 02 00 00 00       	mov    $0x2,%eax
  8018e8:	e8 8f ff ff ff       	call   80187c <fsipc>
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fa:	b8 08 00 00 00       	mov    $0x8,%eax
  8018ff:	e8 78 ff ff ff       	call   80187c <fsipc>
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	53                   	push   %ebx
  80190a:	83 ec 14             	sub    $0x14,%esp
  80190d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801910:	8b 45 08             	mov    0x8(%ebp),%eax
  801913:	8b 40 0c             	mov    0xc(%eax),%eax
  801916:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80191b:	ba 00 00 00 00       	mov    $0x0,%edx
  801920:	b8 05 00 00 00       	mov    $0x5,%eax
  801925:	e8 52 ff ff ff       	call   80187c <fsipc>
  80192a:	85 c0                	test   %eax,%eax
  80192c:	78 2b                	js     801959 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80192e:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801935:	00 
  801936:	89 1c 24             	mov    %ebx,(%esp)
  801939:	e8 9c f0 ff ff       	call   8009da <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80193e:	a1 80 30 80 00       	mov    0x803080,%eax
  801943:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801949:	a1 84 30 80 00       	mov    0x803084,%eax
  80194e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801954:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801959:	83 c4 14             	add    $0x14,%esp
  80195c:	5b                   	pop    %ebx
  80195d:	5d                   	pop    %ebp
  80195e:	c3                   	ret    

0080195f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80195f:	55                   	push   %ebp
  801960:	89 e5                	mov    %esp,%ebp
  801962:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  801965:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80196c:	00 
  80196d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801974:	00 
  801975:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  80197c:	e8 b5 f1 ff ff       	call   800b36 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801981:	8b 45 08             	mov    0x8(%ebp),%eax
  801984:	8b 40 0c             	mov    0xc(%eax),%eax
  801987:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  80198c:	ba 00 00 00 00       	mov    $0x0,%edx
  801991:	b8 06 00 00 00       	mov    $0x6,%eax
  801996:	e8 e1 fe ff ff       	call   80187c <fsipc>
}
  80199b:	c9                   	leave  
  80199c:	c3                   	ret    

0080199d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  8019a3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8019aa:	00 
  8019ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019b2:	00 
  8019b3:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  8019ba:	e8 77 f1 ff ff       	call   800b36 <memset>
  8019bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c2:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8019c7:	76 05                	jbe    8019ce <devfile_write+0x31>
  8019c9:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8019ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8019d1:	8b 52 0c             	mov    0xc(%edx),%edx
  8019d4:	89 15 00 30 80 00    	mov    %edx,0x803000
        fsipcbuf.write.req_n = numberOfBytes;
  8019da:	a3 04 30 80 00       	mov    %eax,0x803004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  8019df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ea:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  8019f1:	e8 9f f1 ff ff       	call   800b95 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  8019f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019fb:	b8 04 00 00 00       	mov    $0x4,%eax
  801a00:	e8 77 fe ff ff       	call   80187c <fsipc>
              return r;
        return r;
}
  801a05:	c9                   	leave  
  801a06:	c3                   	ret    

00801a07 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801a07:	55                   	push   %ebp
  801a08:	89 e5                	mov    %esp,%ebp
  801a0a:	53                   	push   %ebx
  801a0b:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  801a0e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801a15:	00 
  801a16:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a1d:	00 
  801a1e:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801a25:	e8 0c f1 ff ff       	call   800b36 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  801a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2d:	8b 40 0c             	mov    0xc(%eax),%eax
  801a30:	a3 00 30 80 00       	mov    %eax,0x803000
        fsipcbuf.read.req_n = n;
  801a35:	8b 45 10             	mov    0x10(%ebp),%eax
  801a38:	a3 04 30 80 00       	mov    %eax,0x803004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  801a3d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a42:	b8 03 00 00 00       	mov    $0x3,%eax
  801a47:	e8 30 fe ff ff       	call   80187c <fsipc>
  801a4c:	89 c3                	mov    %eax,%ebx
  801a4e:	85 c0                	test   %eax,%eax
  801a50:	78 17                	js     801a69 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  801a52:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a56:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801a5d:	00 
  801a5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a61:	89 04 24             	mov    %eax,(%esp)
  801a64:	e8 2c f1 ff ff       	call   800b95 <memmove>
        return r;
}
  801a69:	89 d8                	mov    %ebx,%eax
  801a6b:	83 c4 14             	add    $0x14,%esp
  801a6e:	5b                   	pop    %ebx
  801a6f:	5d                   	pop    %ebp
  801a70:	c3                   	ret    

00801a71 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	53                   	push   %ebx
  801a75:	83 ec 14             	sub    $0x14,%esp
  801a78:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801a7b:	89 1c 24             	mov    %ebx,(%esp)
  801a7e:	e8 0d ef ff ff       	call   800990 <strlen>
  801a83:	89 c2                	mov    %eax,%edx
  801a85:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801a8a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801a90:	7f 1f                	jg     801ab1 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801a92:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a96:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801a9d:	e8 38 ef ff ff       	call   8009da <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801aa2:	ba 00 00 00 00       	mov    $0x0,%edx
  801aa7:	b8 07 00 00 00       	mov    $0x7,%eax
  801aac:	e8 cb fd ff ff       	call   80187c <fsipc>
}
  801ab1:	83 c4 14             	add    $0x14,%esp
  801ab4:	5b                   	pop    %ebx
  801ab5:	5d                   	pop    %ebp
  801ab6:	c3                   	ret    

00801ab7 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
  801aba:	56                   	push   %esi
  801abb:	53                   	push   %ebx
  801abc:	83 ec 20             	sub    $0x20,%esp
  801abf:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  801ac2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801ac9:	00 
  801aca:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ad1:	00 
  801ad2:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801ad9:	e8 58 f0 ff ff       	call   800b36 <memset>
    if(strlen(path)>=MAXPATHLEN)
  801ade:	89 34 24             	mov    %esi,(%esp)
  801ae1:	e8 aa ee ff ff       	call   800990 <strlen>
  801ae6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801aeb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801af0:	0f 8f 84 00 00 00    	jg     801b7a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  801af6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801af9:	89 04 24             	mov    %eax,(%esp)
  801afc:	e8 8a f7 ff ff       	call   80128b <fd_alloc>
  801b01:	89 c3                	mov    %eax,%ebx
  801b03:	85 c0                	test   %eax,%eax
  801b05:	78 73                	js     801b7a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  801b07:	0f b6 06             	movzbl (%esi),%eax
  801b0a:	84 c0                	test   %al,%al
  801b0c:	74 20                	je     801b2e <open+0x77>
  801b0e:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  801b10:	0f be c0             	movsbl %al,%eax
  801b13:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b17:	c7 04 24 20 2f 80 00 	movl   $0x802f20,(%esp)
  801b1e:	e8 de e7 ff ff       	call   800301 <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  801b23:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  801b27:	83 c3 01             	add    $0x1,%ebx
  801b2a:	84 c0                	test   %al,%al
  801b2c:	75 e2                	jne    801b10 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  801b2e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b32:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801b39:	e8 9c ee ff ff       	call   8009da <strcpy>
    fsipcbuf.open.req_omode = mode;
  801b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b41:	a3 00 34 80 00       	mov    %eax,0x803400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  801b46:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b49:	b8 01 00 00 00       	mov    $0x1,%eax
  801b4e:	e8 29 fd ff ff       	call   80187c <fsipc>
  801b53:	89 c3                	mov    %eax,%ebx
  801b55:	85 c0                	test   %eax,%eax
  801b57:	79 15                	jns    801b6e <open+0xb7>
        {
            fd_close(fd,1);
  801b59:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801b60:	00 
  801b61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b64:	89 04 24             	mov    %eax,(%esp)
  801b67:	e8 d3 fa ff ff       	call   80163f <fd_close>
             return r;
  801b6c:	eb 0c                	jmp    801b7a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  801b6e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b71:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  801b77:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  801b7a:	89 d8                	mov    %ebx,%eax
  801b7c:	83 c4 20             	add    $0x20,%esp
  801b7f:	5b                   	pop    %ebx
  801b80:	5e                   	pop    %esi
  801b81:	5d                   	pop    %ebp
  801b82:	c3                   	ret    
	...

00801b84 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	53                   	push   %ebx
  801b88:	83 ec 14             	sub    $0x14,%esp
  801b8b:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801b8d:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801b91:	7e 34                	jle    801bc7 <writebuf+0x43>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801b93:	8b 40 04             	mov    0x4(%eax),%eax
  801b96:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b9a:	8d 43 10             	lea    0x10(%ebx),%eax
  801b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba1:	8b 03                	mov    (%ebx),%eax
  801ba3:	89 04 24             	mov    %eax,(%esp)
  801ba6:	e8 2a f9 ff ff       	call   8014d5 <write>
		if (result > 0)
  801bab:	85 c0                	test   %eax,%eax
  801bad:	7e 03                	jle    801bb2 <writebuf+0x2e>
			b->result += result;
  801baf:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801bb2:	3b 43 04             	cmp    0x4(%ebx),%eax
  801bb5:	74 10                	je     801bc7 <writebuf+0x43>
			b->error = (result < 0 ? result : 0);
  801bb7:	85 c0                	test   %eax,%eax
  801bb9:	0f 9f c2             	setg   %dl
  801bbc:	0f b6 d2             	movzbl %dl,%edx
  801bbf:	83 ea 01             	sub    $0x1,%edx
  801bc2:	21 d0                	and    %edx,%eax
  801bc4:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801bc7:	83 c4 14             	add    $0x14,%esp
  801bca:	5b                   	pop    %ebx
  801bcb:	5d                   	pop    %ebp
  801bcc:	c3                   	ret    

00801bcd <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd9:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801bdf:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801be6:	00 00 00 
	b.result = 0;
  801be9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801bf0:	00 00 00 
	b.error = 1;
  801bf3:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801bfa:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801bfd:	8b 45 10             	mov    0x10(%ebp),%eax
  801c00:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c07:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c0b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c11:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c15:	c7 04 24 8a 1c 80 00 	movl   $0x801c8a,(%esp)
  801c1c:	e8 8c e8 ff ff       	call   8004ad <vprintfmt>
	if (b.idx > 0)
  801c21:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801c28:	7e 0b                	jle    801c35 <vfprintf+0x68>
		writebuf(&b);
  801c2a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c30:	e8 4f ff ff ff       	call   801b84 <writebuf>

	return (b.result ? b.result : b.error);
  801c35:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801c3b:	85 c0                	test   %eax,%eax
  801c3d:	75 06                	jne    801c45 <vfprintf+0x78>
  801c3f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801c45:	c9                   	leave  
  801c46:	c3                   	ret    

00801c47 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  801c47:	55                   	push   %ebp
  801c48:	89 e5                	mov    %esp,%ebp
  801c4a:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  801c4d:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  801c50:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c54:	8b 45 08             	mov    0x8(%ebp),%eax
  801c57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c5b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c62:	e8 66 ff ff ff       	call   801bcd <vfprintf>
	va_end(ap);

	return cnt;
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
  801c6c:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  801c6f:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  801c72:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c76:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c79:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c80:	89 04 24             	mov    %eax,(%esp)
  801c83:	e8 45 ff ff ff       	call   801bcd <vfprintf>
	va_end(ap);

	return cnt;
}
  801c88:	c9                   	leave  
  801c89:	c3                   	ret    

00801c8a <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  801c8a:	55                   	push   %ebp
  801c8b:	89 e5                	mov    %esp,%ebp
  801c8d:	53                   	push   %ebx
  801c8e:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  801c91:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801c94:	8b 43 04             	mov    0x4(%ebx),%eax
  801c97:	8b 55 08             	mov    0x8(%ebp),%edx
  801c9a:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801c9e:	83 c0 01             	add    $0x1,%eax
  801ca1:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801ca4:	3d 00 01 00 00       	cmp    $0x100,%eax
  801ca9:	75 0e                	jne    801cb9 <putch+0x2f>
		writebuf(b);
  801cab:	89 d8                	mov    %ebx,%eax
  801cad:	e8 d2 fe ff ff       	call   801b84 <writebuf>
		b->idx = 0;
  801cb2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801cb9:	83 c4 04             	add    $0x4,%esp
  801cbc:	5b                   	pop    %ebx
  801cbd:	5d                   	pop    %ebp
  801cbe:	c3                   	ret    
	...

00801cc0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
  801cc3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801cc6:	c7 44 24 04 23 2f 80 	movl   $0x802f23,0x4(%esp)
  801ccd:	00 
  801cce:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd1:	89 04 24             	mov    %eax,(%esp)
  801cd4:	e8 01 ed ff ff       	call   8009da <strcpy>
	return 0;
}
  801cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce9:	8b 40 0c             	mov    0xc(%eax),%eax
  801cec:	89 04 24             	mov    %eax,(%esp)
  801cef:	e8 9e 02 00 00       	call   801f92 <nsipc_close>
}
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801cfc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d03:	00 
  801d04:	8b 45 10             	mov    0x10(%ebp),%eax
  801d07:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d12:	8b 45 08             	mov    0x8(%ebp),%eax
  801d15:	8b 40 0c             	mov    0xc(%eax),%eax
  801d18:	89 04 24             	mov    %eax,(%esp)
  801d1b:	e8 ae 02 00 00       	call   801fce <nsipc_send>
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801d28:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801d2f:	00 
  801d30:	8b 45 10             	mov    0x10(%ebp),%eax
  801d33:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d37:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d41:	8b 40 0c             	mov    0xc(%eax),%eax
  801d44:	89 04 24             	mov    %eax,(%esp)
  801d47:	e8 f5 02 00 00       	call   802041 <nsipc_recv>
}
  801d4c:	c9                   	leave  
  801d4d:	c3                   	ret    

00801d4e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	56                   	push   %esi
  801d52:	53                   	push   %ebx
  801d53:	83 ec 20             	sub    $0x20,%esp
  801d56:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d58:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d5b:	89 04 24             	mov    %eax,(%esp)
  801d5e:	e8 28 f5 ff ff       	call   80128b <fd_alloc>
  801d63:	89 c3                	mov    %eax,%ebx
  801d65:	85 c0                	test   %eax,%eax
  801d67:	78 21                	js     801d8a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801d69:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801d70:	00 
  801d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d74:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d7f:	e8 b2 f3 ff ff       	call   801136 <sys_page_alloc>
  801d84:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d86:	85 c0                	test   %eax,%eax
  801d88:	79 0a                	jns    801d94 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801d8a:	89 34 24             	mov    %esi,(%esp)
  801d8d:	e8 00 02 00 00       	call   801f92 <nsipc_close>
		return r;
  801d92:	eb 28                	jmp    801dbc <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801d94:	8b 15 24 60 80 00    	mov    0x806024,%edx
  801d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801da9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dac:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db2:	89 04 24             	mov    %eax,(%esp)
  801db5:	e8 a6 f4 ff ff       	call   801260 <fd2num>
  801dba:	89 c3                	mov    %eax,%ebx
}
  801dbc:	89 d8                	mov    %ebx,%eax
  801dbe:	83 c4 20             	add    $0x20,%esp
  801dc1:	5b                   	pop    %ebx
  801dc2:	5e                   	pop    %esi
  801dc3:	5d                   	pop    %ebp
  801dc4:	c3                   	ret    

00801dc5 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
  801dc8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801dcb:	8b 45 10             	mov    0x10(%ebp),%eax
  801dce:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd9:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddc:	89 04 24             	mov    %eax,(%esp)
  801ddf:	e8 62 01 00 00       	call   801f46 <nsipc_socket>
  801de4:	85 c0                	test   %eax,%eax
  801de6:	78 05                	js     801ded <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801de8:	e8 61 ff ff ff       	call   801d4e <alloc_sockfd>
}
  801ded:	c9                   	leave  
  801dee:	66 90                	xchg   %ax,%ax
  801df0:	c3                   	ret    

00801df1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801df7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801dfa:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dfe:	89 04 24             	mov    %eax,(%esp)
  801e01:	e8 f7 f4 ff ff       	call   8012fd <fd_lookup>
  801e06:	85 c0                	test   %eax,%eax
  801e08:	78 15                	js     801e1f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801e0a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e0d:	8b 0a                	mov    (%edx),%ecx
  801e0f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e14:	3b 0d 24 60 80 00    	cmp    0x806024,%ecx
  801e1a:	75 03                	jne    801e1f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801e1c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801e1f:	c9                   	leave  
  801e20:	c3                   	ret    

00801e21 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801e21:	55                   	push   %ebp
  801e22:	89 e5                	mov    %esp,%ebp
  801e24:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e27:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2a:	e8 c2 ff ff ff       	call   801df1 <fd2sockid>
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	78 0f                	js     801e42 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801e33:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e36:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e3a:	89 04 24             	mov    %eax,(%esp)
  801e3d:	e8 2e 01 00 00       	call   801f70 <nsipc_listen>
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e4d:	e8 9f ff ff ff       	call   801df1 <fd2sockid>
  801e52:	85 c0                	test   %eax,%eax
  801e54:	78 16                	js     801e6c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801e56:	8b 55 10             	mov    0x10(%ebp),%edx
  801e59:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e60:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e64:	89 04 24             	mov    %eax,(%esp)
  801e67:	e8 55 02 00 00       	call   8020c1 <nsipc_connect>
}
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
  801e71:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e74:	8b 45 08             	mov    0x8(%ebp),%eax
  801e77:	e8 75 ff ff ff       	call   801df1 <fd2sockid>
  801e7c:	85 c0                	test   %eax,%eax
  801e7e:	78 0f                	js     801e8f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801e80:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e83:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e87:	89 04 24             	mov    %eax,(%esp)
  801e8a:	e8 1d 01 00 00       	call   801fac <nsipc_shutdown>
}
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e97:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9a:	e8 52 ff ff ff       	call   801df1 <fd2sockid>
  801e9f:	85 c0                	test   %eax,%eax
  801ea1:	78 16                	js     801eb9 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801ea3:	8b 55 10             	mov    0x10(%ebp),%edx
  801ea6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801eaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ead:	89 54 24 04          	mov    %edx,0x4(%esp)
  801eb1:	89 04 24             	mov    %eax,(%esp)
  801eb4:	e8 47 02 00 00       	call   802100 <nsipc_bind>
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
  801ebe:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ec1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec4:	e8 28 ff ff ff       	call   801df1 <fd2sockid>
  801ec9:	85 c0                	test   %eax,%eax
  801ecb:	78 1f                	js     801eec <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801ecd:	8b 55 10             	mov    0x10(%ebp),%edx
  801ed0:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ed4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ed7:	89 54 24 04          	mov    %edx,0x4(%esp)
  801edb:	89 04 24             	mov    %eax,(%esp)
  801ede:	e8 5c 02 00 00       	call   80213f <nsipc_accept>
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	78 05                	js     801eec <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801ee7:	e8 62 fe ff ff       	call   801d4e <alloc_sockfd>
}
  801eec:	c9                   	leave  
  801eed:	8d 76 00             	lea    0x0(%esi),%esi
  801ef0:	c3                   	ret    
	...

00801f00 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801f00:	55                   	push   %ebp
  801f01:	89 e5                	mov    %esp,%ebp
  801f03:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801f06:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  801f0c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801f13:	00 
  801f14:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801f1b:	00 
  801f1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f20:	89 14 24             	mov    %edx,(%esp)
  801f23:	e8 08 08 00 00       	call   802730 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801f28:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f2f:	00 
  801f30:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f37:	00 
  801f38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f3f:	e8 4e 08 00 00       	call   802792 <ipc_recv>
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f4f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f57:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  801f5c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801f64:	b8 09 00 00 00       	mov    $0x9,%eax
  801f69:	e8 92 ff ff ff       	call   801f00 <nsipc>
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
  801f73:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f76:	8b 45 08             	mov    0x8(%ebp),%eax
  801f79:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  801f7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f81:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801f86:	b8 06 00 00 00       	mov    $0x6,%eax
  801f8b:	e8 70 ff ff ff       	call   801f00 <nsipc>
}
  801f90:	c9                   	leave  
  801f91:	c3                   	ret    

00801f92 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801f92:	55                   	push   %ebp
  801f93:	89 e5                	mov    %esp,%ebp
  801f95:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801fa0:	b8 04 00 00 00       	mov    $0x4,%eax
  801fa5:	e8 56 ff ff ff       	call   801f00 <nsipc>
}
  801faa:	c9                   	leave  
  801fab:	c3                   	ret    

00801fac <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801fac:	55                   	push   %ebp
  801fad:	89 e5                	mov    %esp,%ebp
  801faf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb5:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  801fba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fbd:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801fc2:	b8 03 00 00 00       	mov    $0x3,%eax
  801fc7:	e8 34 ff ff ff       	call   801f00 <nsipc>
}
  801fcc:	c9                   	leave  
  801fcd:	c3                   	ret    

00801fce <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801fce:	55                   	push   %ebp
  801fcf:	89 e5                	mov    %esp,%ebp
  801fd1:	53                   	push   %ebx
  801fd2:	83 ec 14             	sub    $0x14,%esp
  801fd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  801fe0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fe6:	7e 24                	jle    80200c <nsipc_send+0x3e>
  801fe8:	c7 44 24 0c 2f 2f 80 	movl   $0x802f2f,0xc(%esp)
  801fef:	00 
  801ff0:	c7 44 24 08 3b 2f 80 	movl   $0x802f3b,0x8(%esp)
  801ff7:	00 
  801ff8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801fff:	00 
  802000:	c7 04 24 50 2f 80 00 	movl   $0x802f50,(%esp)
  802007:	e8 30 e2 ff ff       	call   80023c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80200c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802010:	8b 45 0c             	mov    0xc(%ebp),%eax
  802013:	89 44 24 04          	mov    %eax,0x4(%esp)
  802017:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  80201e:	e8 72 eb ff ff       	call   800b95 <memmove>
	nsipcbuf.send.req_size = size;
  802023:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  802029:	8b 45 14             	mov    0x14(%ebp),%eax
  80202c:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  802031:	b8 08 00 00 00       	mov    $0x8,%eax
  802036:	e8 c5 fe ff ff       	call   801f00 <nsipc>
}
  80203b:	83 c4 14             	add    $0x14,%esp
  80203e:	5b                   	pop    %ebx
  80203f:	5d                   	pop    %ebp
  802040:	c3                   	ret    

00802041 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	56                   	push   %esi
  802045:	53                   	push   %ebx
  802046:	83 ec 10             	sub    $0x10,%esp
  802049:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  802054:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  80205a:	8b 45 14             	mov    0x14(%ebp),%eax
  80205d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802062:	b8 07 00 00 00       	mov    $0x7,%eax
  802067:	e8 94 fe ff ff       	call   801f00 <nsipc>
  80206c:	89 c3                	mov    %eax,%ebx
  80206e:	85 c0                	test   %eax,%eax
  802070:	78 46                	js     8020b8 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802072:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802077:	7f 04                	jg     80207d <nsipc_recv+0x3c>
  802079:	39 c6                	cmp    %eax,%esi
  80207b:	7d 24                	jge    8020a1 <nsipc_recv+0x60>
  80207d:	c7 44 24 0c 5c 2f 80 	movl   $0x802f5c,0xc(%esp)
  802084:	00 
  802085:	c7 44 24 08 3b 2f 80 	movl   $0x802f3b,0x8(%esp)
  80208c:	00 
  80208d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802094:	00 
  802095:	c7 04 24 50 2f 80 00 	movl   $0x802f50,(%esp)
  80209c:	e8 9b e1 ff ff       	call   80023c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8020a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020a5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  8020ac:	00 
  8020ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020b0:	89 04 24             	mov    %eax,(%esp)
  8020b3:	e8 dd ea ff ff       	call   800b95 <memmove>
	}

	return r;
}
  8020b8:	89 d8                	mov    %ebx,%eax
  8020ba:	83 c4 10             	add    $0x10,%esp
  8020bd:	5b                   	pop    %ebx
  8020be:	5e                   	pop    %esi
  8020bf:	5d                   	pop    %ebp
  8020c0:	c3                   	ret    

008020c1 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8020c1:	55                   	push   %ebp
  8020c2:	89 e5                	mov    %esp,%ebp
  8020c4:	53                   	push   %ebx
  8020c5:	83 ec 14             	sub    $0x14,%esp
  8020c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8020cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ce:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020de:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8020e5:	e8 ab ea ff ff       	call   800b95 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020ea:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  8020f0:	b8 05 00 00 00       	mov    $0x5,%eax
  8020f5:	e8 06 fe ff ff       	call   801f00 <nsipc>
}
  8020fa:	83 c4 14             	add    $0x14,%esp
  8020fd:	5b                   	pop    %ebx
  8020fe:	5d                   	pop    %ebp
  8020ff:	c3                   	ret    

00802100 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802100:	55                   	push   %ebp
  802101:	89 e5                	mov    %esp,%ebp
  802103:	53                   	push   %ebx
  802104:	83 ec 14             	sub    $0x14,%esp
  802107:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80210a:	8b 45 08             	mov    0x8(%ebp),%eax
  80210d:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802112:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802116:	8b 45 0c             	mov    0xc(%ebp),%eax
  802119:	89 44 24 04          	mov    %eax,0x4(%esp)
  80211d:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  802124:	e8 6c ea ff ff       	call   800b95 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802129:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  80212f:	b8 02 00 00 00       	mov    $0x2,%eax
  802134:	e8 c7 fd ff ff       	call   801f00 <nsipc>
}
  802139:	83 c4 14             	add    $0x14,%esp
  80213c:	5b                   	pop    %ebx
  80213d:	5d                   	pop    %ebp
  80213e:	c3                   	ret    

0080213f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80213f:	55                   	push   %ebp
  802140:	89 e5                	mov    %esp,%ebp
  802142:	83 ec 18             	sub    $0x18,%esp
  802145:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802148:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80214b:	8b 45 08             	mov    0x8(%ebp),%eax
  80214e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802153:	b8 01 00 00 00       	mov    $0x1,%eax
  802158:	e8 a3 fd ff ff       	call   801f00 <nsipc>
  80215d:	89 c3                	mov    %eax,%ebx
  80215f:	85 c0                	test   %eax,%eax
  802161:	78 25                	js     802188 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802163:	be 10 50 80 00       	mov    $0x805010,%esi
  802168:	8b 06                	mov    (%esi),%eax
  80216a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80216e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  802175:	00 
  802176:	8b 45 0c             	mov    0xc(%ebp),%eax
  802179:	89 04 24             	mov    %eax,(%esp)
  80217c:	e8 14 ea ff ff       	call   800b95 <memmove>
		*addrlen = ret->ret_addrlen;
  802181:	8b 16                	mov    (%esi),%edx
  802183:	8b 45 10             	mov    0x10(%ebp),%eax
  802186:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802188:	89 d8                	mov    %ebx,%eax
  80218a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80218d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802190:	89 ec                	mov    %ebp,%esp
  802192:	5d                   	pop    %ebp
  802193:	c3                   	ret    
	...

008021a0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8021a0:	55                   	push   %ebp
  8021a1:	89 e5                	mov    %esp,%ebp
  8021a3:	83 ec 18             	sub    $0x18,%esp
  8021a6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8021a9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8021ac:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8021af:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b2:	89 04 24             	mov    %eax,(%esp)
  8021b5:	e8 b6 f0 ff ff       	call   801270 <fd2data>
  8021ba:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8021bc:	c7 44 24 04 71 2f 80 	movl   $0x802f71,0x4(%esp)
  8021c3:	00 
  8021c4:	89 34 24             	mov    %esi,(%esp)
  8021c7:	e8 0e e8 ff ff       	call   8009da <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8021cc:	8b 43 04             	mov    0x4(%ebx),%eax
  8021cf:	2b 03                	sub    (%ebx),%eax
  8021d1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8021d7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8021de:	00 00 00 
	stat->st_dev = &devpipe;
  8021e1:	c7 86 88 00 00 00 40 	movl   $0x806040,0x88(%esi)
  8021e8:	60 80 00 
	return 0;
}
  8021eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8021f0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8021f3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8021f6:	89 ec                	mov    %ebp,%esp
  8021f8:	5d                   	pop    %ebp
  8021f9:	c3                   	ret    

008021fa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021fa:	55                   	push   %ebp
  8021fb:	89 e5                	mov    %esp,%ebp
  8021fd:	53                   	push   %ebx
  8021fe:	83 ec 14             	sub    $0x14,%esp
  802201:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802204:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802208:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80220f:	e8 66 ee ff ff       	call   80107a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802214:	89 1c 24             	mov    %ebx,(%esp)
  802217:	e8 54 f0 ff ff       	call   801270 <fd2data>
  80221c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802220:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802227:	e8 4e ee ff ff       	call   80107a <sys_page_unmap>
}
  80222c:	83 c4 14             	add    $0x14,%esp
  80222f:	5b                   	pop    %ebx
  802230:	5d                   	pop    %ebp
  802231:	c3                   	ret    

00802232 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802232:	55                   	push   %ebp
  802233:	89 e5                	mov    %esp,%ebp
  802235:	57                   	push   %edi
  802236:	56                   	push   %esi
  802237:	53                   	push   %ebx
  802238:	83 ec 2c             	sub    $0x2c,%esp
  80223b:	89 c7                	mov    %eax,%edi
  80223d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802240:	a1 7c 60 80 00       	mov    0x80607c,%eax
  802245:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802248:	89 3c 24             	mov    %edi,(%esp)
  80224b:	e8 a8 05 00 00       	call   8027f8 <pageref>
  802250:	89 c6                	mov    %eax,%esi
  802252:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802255:	89 04 24             	mov    %eax,(%esp)
  802258:	e8 9b 05 00 00       	call   8027f8 <pageref>
  80225d:	39 c6                	cmp    %eax,%esi
  80225f:	0f 94 c0             	sete   %al
  802262:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802265:	8b 15 7c 60 80 00    	mov    0x80607c,%edx
  80226b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80226e:	39 cb                	cmp    %ecx,%ebx
  802270:	75 08                	jne    80227a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802272:	83 c4 2c             	add    $0x2c,%esp
  802275:	5b                   	pop    %ebx
  802276:	5e                   	pop    %esi
  802277:	5f                   	pop    %edi
  802278:	5d                   	pop    %ebp
  802279:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80227a:	83 f8 01             	cmp    $0x1,%eax
  80227d:	75 c1                	jne    802240 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80227f:	8b 52 58             	mov    0x58(%edx),%edx
  802282:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802286:	89 54 24 08          	mov    %edx,0x8(%esp)
  80228a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80228e:	c7 04 24 78 2f 80 00 	movl   $0x802f78,(%esp)
  802295:	e8 67 e0 ff ff       	call   800301 <cprintf>
  80229a:	eb a4                	jmp    802240 <_pipeisclosed+0xe>

0080229c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80229c:	55                   	push   %ebp
  80229d:	89 e5                	mov    %esp,%ebp
  80229f:	57                   	push   %edi
  8022a0:	56                   	push   %esi
  8022a1:	53                   	push   %ebx
  8022a2:	83 ec 1c             	sub    $0x1c,%esp
  8022a5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8022a8:	89 34 24             	mov    %esi,(%esp)
  8022ab:	e8 c0 ef ff ff       	call   801270 <fd2data>
  8022b0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8022b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022bb:	75 54                	jne    802311 <devpipe_write+0x75>
  8022bd:	eb 60                	jmp    80231f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8022bf:	89 da                	mov    %ebx,%edx
  8022c1:	89 f0                	mov    %esi,%eax
  8022c3:	e8 6a ff ff ff       	call   802232 <_pipeisclosed>
  8022c8:	85 c0                	test   %eax,%eax
  8022ca:	74 07                	je     8022d3 <devpipe_write+0x37>
  8022cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d1:	eb 53                	jmp    802326 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8022d3:	90                   	nop
  8022d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022d8:	e8 b8 ee ff ff       	call   801195 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022dd:	8b 43 04             	mov    0x4(%ebx),%eax
  8022e0:	8b 13                	mov    (%ebx),%edx
  8022e2:	83 c2 20             	add    $0x20,%edx
  8022e5:	39 d0                	cmp    %edx,%eax
  8022e7:	73 d6                	jae    8022bf <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022e9:	89 c2                	mov    %eax,%edx
  8022eb:	c1 fa 1f             	sar    $0x1f,%edx
  8022ee:	c1 ea 1b             	shr    $0x1b,%edx
  8022f1:	01 d0                	add    %edx,%eax
  8022f3:	83 e0 1f             	and    $0x1f,%eax
  8022f6:	29 d0                	sub    %edx,%eax
  8022f8:	89 c2                	mov    %eax,%edx
  8022fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022fd:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802301:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802305:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802309:	83 c7 01             	add    $0x1,%edi
  80230c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80230f:	76 13                	jbe    802324 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802311:	8b 43 04             	mov    0x4(%ebx),%eax
  802314:	8b 13                	mov    (%ebx),%edx
  802316:	83 c2 20             	add    $0x20,%edx
  802319:	39 d0                	cmp    %edx,%eax
  80231b:	73 a2                	jae    8022bf <devpipe_write+0x23>
  80231d:	eb ca                	jmp    8022e9 <devpipe_write+0x4d>
  80231f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802324:	89 f8                	mov    %edi,%eax
}
  802326:	83 c4 1c             	add    $0x1c,%esp
  802329:	5b                   	pop    %ebx
  80232a:	5e                   	pop    %esi
  80232b:	5f                   	pop    %edi
  80232c:	5d                   	pop    %ebp
  80232d:	c3                   	ret    

0080232e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
  802331:	83 ec 28             	sub    $0x28,%esp
  802334:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802337:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80233a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80233d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802340:	89 3c 24             	mov    %edi,(%esp)
  802343:	e8 28 ef ff ff       	call   801270 <fd2data>
  802348:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80234a:	be 00 00 00 00       	mov    $0x0,%esi
  80234f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802353:	75 4c                	jne    8023a1 <devpipe_read+0x73>
  802355:	eb 5b                	jmp    8023b2 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802357:	89 f0                	mov    %esi,%eax
  802359:	eb 5e                	jmp    8023b9 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80235b:	89 da                	mov    %ebx,%edx
  80235d:	89 f8                	mov    %edi,%eax
  80235f:	90                   	nop
  802360:	e8 cd fe ff ff       	call   802232 <_pipeisclosed>
  802365:	85 c0                	test   %eax,%eax
  802367:	74 07                	je     802370 <devpipe_read+0x42>
  802369:	b8 00 00 00 00       	mov    $0x0,%eax
  80236e:	eb 49                	jmp    8023b9 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802370:	e8 20 ee ff ff       	call   801195 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802375:	8b 03                	mov    (%ebx),%eax
  802377:	3b 43 04             	cmp    0x4(%ebx),%eax
  80237a:	74 df                	je     80235b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80237c:	89 c2                	mov    %eax,%edx
  80237e:	c1 fa 1f             	sar    $0x1f,%edx
  802381:	c1 ea 1b             	shr    $0x1b,%edx
  802384:	01 d0                	add    %edx,%eax
  802386:	83 e0 1f             	and    $0x1f,%eax
  802389:	29 d0                	sub    %edx,%eax
  80238b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802390:	8b 55 0c             	mov    0xc(%ebp),%edx
  802393:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802396:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802399:	83 c6 01             	add    $0x1,%esi
  80239c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80239f:	76 16                	jbe    8023b7 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  8023a1:	8b 03                	mov    (%ebx),%eax
  8023a3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8023a6:	75 d4                	jne    80237c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8023a8:	85 f6                	test   %esi,%esi
  8023aa:	75 ab                	jne    802357 <devpipe_read+0x29>
  8023ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8023b0:	eb a9                	jmp    80235b <devpipe_read+0x2d>
  8023b2:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8023b7:	89 f0                	mov    %esi,%eax
}
  8023b9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8023bc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8023bf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8023c2:	89 ec                	mov    %ebp,%esp
  8023c4:	5d                   	pop    %ebp
  8023c5:	c3                   	ret    

008023c6 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
  8023c9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	89 04 24             	mov    %eax,(%esp)
  8023d9:	e8 1f ef ff ff       	call   8012fd <fd_lookup>
  8023de:	85 c0                	test   %eax,%eax
  8023e0:	78 15                	js     8023f7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	89 04 24             	mov    %eax,(%esp)
  8023e8:	e8 83 ee ff ff       	call   801270 <fd2data>
	return _pipeisclosed(fd, p);
  8023ed:	89 c2                	mov    %eax,%edx
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	e8 3b fe ff ff       	call   802232 <_pipeisclosed>
}
  8023f7:	c9                   	leave  
  8023f8:	c3                   	ret    

008023f9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8023f9:	55                   	push   %ebp
  8023fa:	89 e5                	mov    %esp,%ebp
  8023fc:	83 ec 48             	sub    $0x48,%esp
  8023ff:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802402:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802405:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802408:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80240b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80240e:	89 04 24             	mov    %eax,(%esp)
  802411:	e8 75 ee ff ff       	call   80128b <fd_alloc>
  802416:	89 c3                	mov    %eax,%ebx
  802418:	85 c0                	test   %eax,%eax
  80241a:	0f 88 42 01 00 00    	js     802562 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802420:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802427:	00 
  802428:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80242b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80242f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802436:	e8 fb ec ff ff       	call   801136 <sys_page_alloc>
  80243b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80243d:	85 c0                	test   %eax,%eax
  80243f:	0f 88 1d 01 00 00    	js     802562 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802445:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802448:	89 04 24             	mov    %eax,(%esp)
  80244b:	e8 3b ee ff ff       	call   80128b <fd_alloc>
  802450:	89 c3                	mov    %eax,%ebx
  802452:	85 c0                	test   %eax,%eax
  802454:	0f 88 f5 00 00 00    	js     80254f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80245a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802461:	00 
  802462:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802465:	89 44 24 04          	mov    %eax,0x4(%esp)
  802469:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802470:	e8 c1 ec ff ff       	call   801136 <sys_page_alloc>
  802475:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802477:	85 c0                	test   %eax,%eax
  802479:	0f 88 d0 00 00 00    	js     80254f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80247f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802482:	89 04 24             	mov    %eax,(%esp)
  802485:	e8 e6 ed ff ff       	call   801270 <fd2data>
  80248a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80248c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802493:	00 
  802494:	89 44 24 04          	mov    %eax,0x4(%esp)
  802498:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80249f:	e8 92 ec ff ff       	call   801136 <sys_page_alloc>
  8024a4:	89 c3                	mov    %eax,%ebx
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	0f 88 8e 00 00 00    	js     80253c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8024ae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024b1:	89 04 24             	mov    %eax,(%esp)
  8024b4:	e8 b7 ed ff ff       	call   801270 <fd2data>
  8024b9:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8024c0:	00 
  8024c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024c5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8024cc:	00 
  8024cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024d1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024d8:	e8 fb eb ff ff       	call   8010d8 <sys_page_map>
  8024dd:	89 c3                	mov    %eax,%ebx
  8024df:	85 c0                	test   %eax,%eax
  8024e1:	78 49                	js     80252c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8024e3:	b8 40 60 80 00       	mov    $0x806040,%eax
  8024e8:	8b 08                	mov    (%eax),%ecx
  8024ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024ed:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024ef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024f2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8024f9:	8b 10                	mov    (%eax),%edx
  8024fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024fe:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802500:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802503:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80250a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250d:	89 04 24             	mov    %eax,(%esp)
  802510:	e8 4b ed ff ff       	call   801260 <fd2num>
  802515:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802517:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80251a:	89 04 24             	mov    %eax,(%esp)
  80251d:	e8 3e ed ff ff       	call   801260 <fd2num>
  802522:	89 47 04             	mov    %eax,0x4(%edi)
  802525:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80252a:	eb 36                	jmp    802562 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80252c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802530:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802537:	e8 3e eb ff ff       	call   80107a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80253c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80253f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802543:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80254a:	e8 2b eb ff ff       	call   80107a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80254f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802552:	89 44 24 04          	mov    %eax,0x4(%esp)
  802556:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80255d:	e8 18 eb ff ff       	call   80107a <sys_page_unmap>
    err:
	return r;
}
  802562:	89 d8                	mov    %ebx,%eax
  802564:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802567:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80256a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80256d:	89 ec                	mov    %ebp,%esp
  80256f:	5d                   	pop    %ebp
  802570:	c3                   	ret    
	...

00802580 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802583:	b8 00 00 00 00       	mov    $0x0,%eax
  802588:	5d                   	pop    %ebp
  802589:	c3                   	ret    

0080258a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80258a:	55                   	push   %ebp
  80258b:	89 e5                	mov    %esp,%ebp
  80258d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802590:	c7 44 24 04 90 2f 80 	movl   $0x802f90,0x4(%esp)
  802597:	00 
  802598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80259b:	89 04 24             	mov    %eax,(%esp)
  80259e:	e8 37 e4 ff ff       	call   8009da <strcpy>
	return 0;
}
  8025a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a8:	c9                   	leave  
  8025a9:	c3                   	ret    

008025aa <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
  8025ad:	57                   	push   %edi
  8025ae:	56                   	push   %esi
  8025af:	53                   	push   %ebx
  8025b0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8025bb:	be 00 00 00 00       	mov    $0x0,%esi
  8025c0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8025c4:	74 3f                	je     802605 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8025c6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8025cc:	8b 55 10             	mov    0x10(%ebp),%edx
  8025cf:	29 c2                	sub    %eax,%edx
  8025d1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  8025d3:	83 fa 7f             	cmp    $0x7f,%edx
  8025d6:	76 05                	jbe    8025dd <devcons_write+0x33>
  8025d8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8025dd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025e1:	03 45 0c             	add    0xc(%ebp),%eax
  8025e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e8:	89 3c 24             	mov    %edi,(%esp)
  8025eb:	e8 a5 e5 ff ff       	call   800b95 <memmove>
		sys_cputs(buf, m);
  8025f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025f4:	89 3c 24             	mov    %edi,(%esp)
  8025f7:	e8 d4 e7 ff ff       	call   800dd0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025fc:	01 de                	add    %ebx,%esi
  8025fe:	89 f0                	mov    %esi,%eax
  802600:	3b 75 10             	cmp    0x10(%ebp),%esi
  802603:	72 c7                	jb     8025cc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802605:	89 f0                	mov    %esi,%eax
  802607:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80260d:	5b                   	pop    %ebx
  80260e:	5e                   	pop    %esi
  80260f:	5f                   	pop    %edi
  802610:	5d                   	pop    %ebp
  802611:	c3                   	ret    

00802612 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802612:	55                   	push   %ebp
  802613:	89 e5                	mov    %esp,%ebp
  802615:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802618:	8b 45 08             	mov    0x8(%ebp),%eax
  80261b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80261e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802625:	00 
  802626:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802629:	89 04 24             	mov    %eax,(%esp)
  80262c:	e8 9f e7 ff ff       	call   800dd0 <sys_cputs>
}
  802631:	c9                   	leave  
  802632:	c3                   	ret    

00802633 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802633:	55                   	push   %ebp
  802634:	89 e5                	mov    %esp,%ebp
  802636:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802639:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80263d:	75 07                	jne    802646 <devcons_read+0x13>
  80263f:	eb 28                	jmp    802669 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802641:	e8 4f eb ff ff       	call   801195 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802646:	66 90                	xchg   %ax,%ax
  802648:	e8 4f e7 ff ff       	call   800d9c <sys_cgetc>
  80264d:	85 c0                	test   %eax,%eax
  80264f:	90                   	nop
  802650:	74 ef                	je     802641 <devcons_read+0xe>
  802652:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802654:	85 c0                	test   %eax,%eax
  802656:	78 16                	js     80266e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802658:	83 f8 04             	cmp    $0x4,%eax
  80265b:	74 0c                	je     802669 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80265d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802660:	88 10                	mov    %dl,(%eax)
  802662:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802667:	eb 05                	jmp    80266e <devcons_read+0x3b>
  802669:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
  802673:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802676:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802679:	89 04 24             	mov    %eax,(%esp)
  80267c:	e8 0a ec ff ff       	call   80128b <fd_alloc>
  802681:	85 c0                	test   %eax,%eax
  802683:	78 3f                	js     8026c4 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802685:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80268c:	00 
  80268d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802690:	89 44 24 04          	mov    %eax,0x4(%esp)
  802694:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80269b:	e8 96 ea ff ff       	call   801136 <sys_page_alloc>
  8026a0:	85 c0                	test   %eax,%eax
  8026a2:	78 20                	js     8026c4 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8026a4:	8b 15 5c 60 80 00    	mov    0x80605c,%edx
  8026aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ad:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8026af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8026b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bc:	89 04 24             	mov    %eax,(%esp)
  8026bf:	e8 9c eb ff ff       	call   801260 <fd2num>
}
  8026c4:	c9                   	leave  
  8026c5:	c3                   	ret    

008026c6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8026c6:	55                   	push   %ebp
  8026c7:	89 e5                	mov    %esp,%ebp
  8026c9:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8026cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8026cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d6:	89 04 24             	mov    %eax,(%esp)
  8026d9:	e8 1f ec ff ff       	call   8012fd <fd_lookup>
  8026de:	85 c0                	test   %eax,%eax
  8026e0:	78 11                	js     8026f3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8026e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e5:	8b 00                	mov    (%eax),%eax
  8026e7:	3b 05 5c 60 80 00    	cmp    0x80605c,%eax
  8026ed:	0f 94 c0             	sete   %al
  8026f0:	0f b6 c0             	movzbl %al,%eax
}
  8026f3:	c9                   	leave  
  8026f4:	c3                   	ret    

008026f5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8026f5:	55                   	push   %ebp
  8026f6:	89 e5                	mov    %esp,%ebp
  8026f8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8026fb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802702:	00 
  802703:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802706:	89 44 24 04          	mov    %eax,0x4(%esp)
  80270a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802711:	e8 48 ee ff ff       	call   80155e <read>
	if (r < 0)
  802716:	85 c0                	test   %eax,%eax
  802718:	78 0f                	js     802729 <getchar+0x34>
		return r;
	if (r < 1)
  80271a:	85 c0                	test   %eax,%eax
  80271c:	7f 07                	jg     802725 <getchar+0x30>
  80271e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802723:	eb 04                	jmp    802729 <getchar+0x34>
		return -E_EOF;
	return c;
  802725:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802729:	c9                   	leave  
  80272a:	c3                   	ret    
  80272b:	00 00                	add    %al,(%eax)
  80272d:	00 00                	add    %al,(%eax)
	...

00802730 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802730:	55                   	push   %ebp
  802731:	89 e5                	mov    %esp,%ebp
  802733:	57                   	push   %edi
  802734:	56                   	push   %esi
  802735:	53                   	push   %ebx
  802736:	83 ec 1c             	sub    $0x1c,%esp
  802739:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80273c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80273f:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  802742:	8b 45 14             	mov    0x14(%ebp),%eax
  802745:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802749:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80274d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802751:	89 1c 24             	mov    %ebx,(%esp)
  802754:	e8 cf e7 ff ff       	call   800f28 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  802759:	85 c0                	test   %eax,%eax
  80275b:	79 21                	jns    80277e <ipc_send+0x4e>
  80275d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802760:	74 1c                	je     80277e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  802762:	c7 44 24 08 9c 2f 80 	movl   $0x802f9c,0x8(%esp)
  802769:	00 
  80276a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  802771:	00 
  802772:	c7 04 24 ae 2f 80 00 	movl   $0x802fae,(%esp)
  802779:	e8 be da ff ff       	call   80023c <_panic>
          else if(r==-E_IPC_NOT_RECV)
  80277e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802781:	75 07                	jne    80278a <ipc_send+0x5a>
           sys_yield();
  802783:	e8 0d ea ff ff       	call   801195 <sys_yield>
          else
            break;
        }
  802788:	eb b8                	jmp    802742 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  80278a:	83 c4 1c             	add    $0x1c,%esp
  80278d:	5b                   	pop    %ebx
  80278e:	5e                   	pop    %esi
  80278f:	5f                   	pop    %edi
  802790:	5d                   	pop    %ebp
  802791:	c3                   	ret    

00802792 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802792:	55                   	push   %ebp
  802793:	89 e5                	mov    %esp,%ebp
  802795:	83 ec 18             	sub    $0x18,%esp
  802798:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80279b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80279e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8027a1:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  8027a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027a7:	89 04 24             	mov    %eax,(%esp)
  8027aa:	e8 1c e7 ff ff       	call   800ecb <sys_ipc_recv>
        if(r<0)
  8027af:	85 c0                	test   %eax,%eax
  8027b1:	79 17                	jns    8027ca <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  8027b3:	85 db                	test   %ebx,%ebx
  8027b5:	74 06                	je     8027bd <ipc_recv+0x2b>
               *from_env_store =0;
  8027b7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  8027bd:	85 f6                	test   %esi,%esi
  8027bf:	90                   	nop
  8027c0:	74 2c                	je     8027ee <ipc_recv+0x5c>
              *perm_store=0;
  8027c2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8027c8:	eb 24                	jmp    8027ee <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  8027ca:	85 db                	test   %ebx,%ebx
  8027cc:	74 0a                	je     8027d8 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  8027ce:	a1 7c 60 80 00       	mov    0x80607c,%eax
  8027d3:	8b 40 74             	mov    0x74(%eax),%eax
  8027d6:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  8027d8:	85 f6                	test   %esi,%esi
  8027da:	74 0a                	je     8027e6 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  8027dc:	a1 7c 60 80 00       	mov    0x80607c,%eax
  8027e1:	8b 40 78             	mov    0x78(%eax),%eax
  8027e4:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  8027e6:	a1 7c 60 80 00       	mov    0x80607c,%eax
  8027eb:	8b 40 70             	mov    0x70(%eax),%eax
}
  8027ee:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8027f1:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8027f4:	89 ec                	mov    %ebp,%esp
  8027f6:	5d                   	pop    %ebp
  8027f7:	c3                   	ret    

008027f8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027f8:	55                   	push   %ebp
  8027f9:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8027fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fe:	89 c2                	mov    %eax,%edx
  802800:	c1 ea 16             	shr    $0x16,%edx
  802803:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80280a:	f6 c2 01             	test   $0x1,%dl
  80280d:	74 26                	je     802835 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  80280f:	c1 e8 0c             	shr    $0xc,%eax
  802812:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802819:	a8 01                	test   $0x1,%al
  80281b:	74 18                	je     802835 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  80281d:	c1 e8 0c             	shr    $0xc,%eax
  802820:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802823:	c1 e2 02             	shl    $0x2,%edx
  802826:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  80282b:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802830:	0f b7 c0             	movzwl %ax,%eax
  802833:	eb 05                	jmp    80283a <pageref+0x42>
  802835:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80283a:	5d                   	pop    %ebp
  80283b:	c3                   	ret    
  80283c:	00 00                	add    %al,(%eax)
	...

00802840 <__udivdi3>:
  802840:	55                   	push   %ebp
  802841:	89 e5                	mov    %esp,%ebp
  802843:	57                   	push   %edi
  802844:	56                   	push   %esi
  802845:	83 ec 10             	sub    $0x10,%esp
  802848:	8b 45 14             	mov    0x14(%ebp),%eax
  80284b:	8b 55 08             	mov    0x8(%ebp),%edx
  80284e:	8b 75 10             	mov    0x10(%ebp),%esi
  802851:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802854:	85 c0                	test   %eax,%eax
  802856:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802859:	75 35                	jne    802890 <__udivdi3+0x50>
  80285b:	39 fe                	cmp    %edi,%esi
  80285d:	77 61                	ja     8028c0 <__udivdi3+0x80>
  80285f:	85 f6                	test   %esi,%esi
  802861:	75 0b                	jne    80286e <__udivdi3+0x2e>
  802863:	b8 01 00 00 00       	mov    $0x1,%eax
  802868:	31 d2                	xor    %edx,%edx
  80286a:	f7 f6                	div    %esi
  80286c:	89 c6                	mov    %eax,%esi
  80286e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802871:	31 d2                	xor    %edx,%edx
  802873:	89 f8                	mov    %edi,%eax
  802875:	f7 f6                	div    %esi
  802877:	89 c7                	mov    %eax,%edi
  802879:	89 c8                	mov    %ecx,%eax
  80287b:	f7 f6                	div    %esi
  80287d:	89 c1                	mov    %eax,%ecx
  80287f:	89 fa                	mov    %edi,%edx
  802881:	89 c8                	mov    %ecx,%eax
  802883:	83 c4 10             	add    $0x10,%esp
  802886:	5e                   	pop    %esi
  802887:	5f                   	pop    %edi
  802888:	5d                   	pop    %ebp
  802889:	c3                   	ret    
  80288a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802890:	39 f8                	cmp    %edi,%eax
  802892:	77 1c                	ja     8028b0 <__udivdi3+0x70>
  802894:	0f bd d0             	bsr    %eax,%edx
  802897:	83 f2 1f             	xor    $0x1f,%edx
  80289a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80289d:	75 39                	jne    8028d8 <__udivdi3+0x98>
  80289f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8028a2:	0f 86 a0 00 00 00    	jbe    802948 <__udivdi3+0x108>
  8028a8:	39 f8                	cmp    %edi,%eax
  8028aa:	0f 82 98 00 00 00    	jb     802948 <__udivdi3+0x108>
  8028b0:	31 ff                	xor    %edi,%edi
  8028b2:	31 c9                	xor    %ecx,%ecx
  8028b4:	89 c8                	mov    %ecx,%eax
  8028b6:	89 fa                	mov    %edi,%edx
  8028b8:	83 c4 10             	add    $0x10,%esp
  8028bb:	5e                   	pop    %esi
  8028bc:	5f                   	pop    %edi
  8028bd:	5d                   	pop    %ebp
  8028be:	c3                   	ret    
  8028bf:	90                   	nop
  8028c0:	89 d1                	mov    %edx,%ecx
  8028c2:	89 fa                	mov    %edi,%edx
  8028c4:	89 c8                	mov    %ecx,%eax
  8028c6:	31 ff                	xor    %edi,%edi
  8028c8:	f7 f6                	div    %esi
  8028ca:	89 c1                	mov    %eax,%ecx
  8028cc:	89 fa                	mov    %edi,%edx
  8028ce:	89 c8                	mov    %ecx,%eax
  8028d0:	83 c4 10             	add    $0x10,%esp
  8028d3:	5e                   	pop    %esi
  8028d4:	5f                   	pop    %edi
  8028d5:	5d                   	pop    %ebp
  8028d6:	c3                   	ret    
  8028d7:	90                   	nop
  8028d8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028dc:	89 f2                	mov    %esi,%edx
  8028de:	d3 e0                	shl    %cl,%eax
  8028e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028e3:	b8 20 00 00 00       	mov    $0x20,%eax
  8028e8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8028eb:	89 c1                	mov    %eax,%ecx
  8028ed:	d3 ea                	shr    %cl,%edx
  8028ef:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028f3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8028f6:	d3 e6                	shl    %cl,%esi
  8028f8:	89 c1                	mov    %eax,%ecx
  8028fa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8028fd:	89 fe                	mov    %edi,%esi
  8028ff:	d3 ee                	shr    %cl,%esi
  802901:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802905:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802908:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80290b:	d3 e7                	shl    %cl,%edi
  80290d:	89 c1                	mov    %eax,%ecx
  80290f:	d3 ea                	shr    %cl,%edx
  802911:	09 d7                	or     %edx,%edi
  802913:	89 f2                	mov    %esi,%edx
  802915:	89 f8                	mov    %edi,%eax
  802917:	f7 75 ec             	divl   -0x14(%ebp)
  80291a:	89 d6                	mov    %edx,%esi
  80291c:	89 c7                	mov    %eax,%edi
  80291e:	f7 65 e8             	mull   -0x18(%ebp)
  802921:	39 d6                	cmp    %edx,%esi
  802923:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802926:	72 30                	jb     802958 <__udivdi3+0x118>
  802928:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80292b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80292f:	d3 e2                	shl    %cl,%edx
  802931:	39 c2                	cmp    %eax,%edx
  802933:	73 05                	jae    80293a <__udivdi3+0xfa>
  802935:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802938:	74 1e                	je     802958 <__udivdi3+0x118>
  80293a:	89 f9                	mov    %edi,%ecx
  80293c:	31 ff                	xor    %edi,%edi
  80293e:	e9 71 ff ff ff       	jmp    8028b4 <__udivdi3+0x74>
  802943:	90                   	nop
  802944:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802948:	31 ff                	xor    %edi,%edi
  80294a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80294f:	e9 60 ff ff ff       	jmp    8028b4 <__udivdi3+0x74>
  802954:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802958:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80295b:	31 ff                	xor    %edi,%edi
  80295d:	89 c8                	mov    %ecx,%eax
  80295f:	89 fa                	mov    %edi,%edx
  802961:	83 c4 10             	add    $0x10,%esp
  802964:	5e                   	pop    %esi
  802965:	5f                   	pop    %edi
  802966:	5d                   	pop    %ebp
  802967:	c3                   	ret    
	...

00802970 <__umoddi3>:
  802970:	55                   	push   %ebp
  802971:	89 e5                	mov    %esp,%ebp
  802973:	57                   	push   %edi
  802974:	56                   	push   %esi
  802975:	83 ec 20             	sub    $0x20,%esp
  802978:	8b 55 14             	mov    0x14(%ebp),%edx
  80297b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80297e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802981:	8b 75 0c             	mov    0xc(%ebp),%esi
  802984:	85 d2                	test   %edx,%edx
  802986:	89 c8                	mov    %ecx,%eax
  802988:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80298b:	75 13                	jne    8029a0 <__umoddi3+0x30>
  80298d:	39 f7                	cmp    %esi,%edi
  80298f:	76 3f                	jbe    8029d0 <__umoddi3+0x60>
  802991:	89 f2                	mov    %esi,%edx
  802993:	f7 f7                	div    %edi
  802995:	89 d0                	mov    %edx,%eax
  802997:	31 d2                	xor    %edx,%edx
  802999:	83 c4 20             	add    $0x20,%esp
  80299c:	5e                   	pop    %esi
  80299d:	5f                   	pop    %edi
  80299e:	5d                   	pop    %ebp
  80299f:	c3                   	ret    
  8029a0:	39 f2                	cmp    %esi,%edx
  8029a2:	77 4c                	ja     8029f0 <__umoddi3+0x80>
  8029a4:	0f bd ca             	bsr    %edx,%ecx
  8029a7:	83 f1 1f             	xor    $0x1f,%ecx
  8029aa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8029ad:	75 51                	jne    802a00 <__umoddi3+0x90>
  8029af:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8029b2:	0f 87 e0 00 00 00    	ja     802a98 <__umoddi3+0x128>
  8029b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bb:	29 f8                	sub    %edi,%eax
  8029bd:	19 d6                	sbb    %edx,%esi
  8029bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c5:	89 f2                	mov    %esi,%edx
  8029c7:	83 c4 20             	add    $0x20,%esp
  8029ca:	5e                   	pop    %esi
  8029cb:	5f                   	pop    %edi
  8029cc:	5d                   	pop    %ebp
  8029cd:	c3                   	ret    
  8029ce:	66 90                	xchg   %ax,%ax
  8029d0:	85 ff                	test   %edi,%edi
  8029d2:	75 0b                	jne    8029df <__umoddi3+0x6f>
  8029d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8029d9:	31 d2                	xor    %edx,%edx
  8029db:	f7 f7                	div    %edi
  8029dd:	89 c7                	mov    %eax,%edi
  8029df:	89 f0                	mov    %esi,%eax
  8029e1:	31 d2                	xor    %edx,%edx
  8029e3:	f7 f7                	div    %edi
  8029e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e8:	f7 f7                	div    %edi
  8029ea:	eb a9                	jmp    802995 <__umoddi3+0x25>
  8029ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029f0:	89 c8                	mov    %ecx,%eax
  8029f2:	89 f2                	mov    %esi,%edx
  8029f4:	83 c4 20             	add    $0x20,%esp
  8029f7:	5e                   	pop    %esi
  8029f8:	5f                   	pop    %edi
  8029f9:	5d                   	pop    %ebp
  8029fa:	c3                   	ret    
  8029fb:	90                   	nop
  8029fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a00:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a04:	d3 e2                	shl    %cl,%edx
  802a06:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802a09:	ba 20 00 00 00       	mov    $0x20,%edx
  802a0e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802a11:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802a14:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a18:	89 fa                	mov    %edi,%edx
  802a1a:	d3 ea                	shr    %cl,%edx
  802a1c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a20:	0b 55 f4             	or     -0xc(%ebp),%edx
  802a23:	d3 e7                	shl    %cl,%edi
  802a25:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a29:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802a2c:	89 f2                	mov    %esi,%edx
  802a2e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802a31:	89 c7                	mov    %eax,%edi
  802a33:	d3 ea                	shr    %cl,%edx
  802a35:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a39:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802a3c:	89 c2                	mov    %eax,%edx
  802a3e:	d3 e6                	shl    %cl,%esi
  802a40:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a44:	d3 ea                	shr    %cl,%edx
  802a46:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a4a:	09 d6                	or     %edx,%esi
  802a4c:	89 f0                	mov    %esi,%eax
  802a4e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802a51:	d3 e7                	shl    %cl,%edi
  802a53:	89 f2                	mov    %esi,%edx
  802a55:	f7 75 f4             	divl   -0xc(%ebp)
  802a58:	89 d6                	mov    %edx,%esi
  802a5a:	f7 65 e8             	mull   -0x18(%ebp)
  802a5d:	39 d6                	cmp    %edx,%esi
  802a5f:	72 2b                	jb     802a8c <__umoddi3+0x11c>
  802a61:	39 c7                	cmp    %eax,%edi
  802a63:	72 23                	jb     802a88 <__umoddi3+0x118>
  802a65:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a69:	29 c7                	sub    %eax,%edi
  802a6b:	19 d6                	sbb    %edx,%esi
  802a6d:	89 f0                	mov    %esi,%eax
  802a6f:	89 f2                	mov    %esi,%edx
  802a71:	d3 ef                	shr    %cl,%edi
  802a73:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a77:	d3 e0                	shl    %cl,%eax
  802a79:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a7d:	09 f8                	or     %edi,%eax
  802a7f:	d3 ea                	shr    %cl,%edx
  802a81:	83 c4 20             	add    $0x20,%esp
  802a84:	5e                   	pop    %esi
  802a85:	5f                   	pop    %edi
  802a86:	5d                   	pop    %ebp
  802a87:	c3                   	ret    
  802a88:	39 d6                	cmp    %edx,%esi
  802a8a:	75 d9                	jne    802a65 <__umoddi3+0xf5>
  802a8c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802a8f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802a92:	eb d1                	jmp    802a65 <__umoddi3+0xf5>
  802a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a98:	39 f2                	cmp    %esi,%edx
  802a9a:	0f 82 18 ff ff ff    	jb     8029b8 <__umoddi3+0x48>
  802aa0:	e9 1d ff ff ff       	jmp    8029c2 <__umoddi3+0x52>
