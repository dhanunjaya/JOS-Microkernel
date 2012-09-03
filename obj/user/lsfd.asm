
obj/user/lsfd:     file format elf32-i386


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
  80002c:	e8 67 01 00 00       	call   800198 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: lsfd [-1]\n");
  800046:	c7 04 24 80 2a 80 00 	movl   $0x802a80,(%esp)
  80004d:	e8 77 02 00 00       	call   8002c9 <cprintf>
	exit();
  800052:	e8 91 01 00 00       	call   8001e8 <exit>
}
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <umain>:

void
umain(int argc, char **argv)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	57                   	push   %edi
  80005d:	56                   	push   %esi
  80005e:	53                   	push   %ebx
  80005f:	81 ec cc 00 00 00    	sub    $0xcc,%esp
  800065:	8b 45 0c             	mov    0xc(%ebp),%eax
	int i, usefprint = 0;
	struct Stat st;

	ARGBEGIN{
  800068:	85 c0                	test   %eax,%eax
  80006a:	75 03                	jne    80006f <umain+0x16>
  80006c:	8d 45 08             	lea    0x8(%ebp),%eax
  80006f:	83 3d 78 60 80 00 00 	cmpl   $0x0,0x806078
  800076:	75 08                	jne    800080 <umain+0x27>
  800078:	8b 10                	mov    (%eax),%edx
  80007a:	89 15 78 60 80 00    	mov    %edx,0x806078
  800080:	83 c0 04             	add    $0x4,%eax
  800083:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  800089:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  80008d:	8b 18                	mov    (%eax),%ebx
  80008f:	85 db                	test   %ebx,%ebx
  800091:	74 29                	je     8000bc <umain+0x63>
  800093:	80 3b 2d             	cmpb   $0x2d,(%ebx)
  800096:	75 24                	jne    8000bc <umain+0x63>
  800098:	83 c3 01             	add    $0x1,%ebx
  80009b:	0f b6 03             	movzbl (%ebx),%eax
  80009e:	84 c0                	test   %al,%al
  8000a0:	74 1a                	je     8000bc <umain+0x63>
  8000a2:	be 00 00 00 00       	mov    $0x0,%esi
  8000a7:	bf 01 00 00 00       	mov    $0x1,%edi
  8000ac:	3c 2d                	cmp    $0x2d,%al
  8000ae:	75 28                	jne    8000d8 <umain+0x7f>
  8000b0:	80 7b 01 00          	cmpb   $0x0,0x1(%ebx)
  8000b4:	75 22                	jne    8000d8 <umain+0x7f>
  8000b6:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  8000ba:	eb 05                	jmp    8000c1 <umain+0x68>
  8000bc:	be 00 00 00 00       	mov    $0x0,%esi
  8000c1:	bb 00 00 00 00       	mov    $0x0,%ebx
		usefprint = 1;
		break;
	}ARGEND

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
  8000c6:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  8000cc:	eb 3f                	jmp    80010d <umain+0xb4>
	int i, usefprint = 0;
	struct Stat st;

	ARGBEGIN{
	default:
		usage();
  8000ce:	e8 6d ff ff ff       	call   800040 <usage>
umain(int argc, char **argv)
{
	int i, usefprint = 0;
	struct Stat st;

	ARGBEGIN{
  8000d3:	83 c3 01             	add    $0x1,%ebx
  8000d6:	89 fe                	mov    %edi,%esi
  8000d8:	0f b6 03             	movzbl (%ebx),%eax
  8000db:	84 c0                	test   %al,%al
  8000dd:	74 06                	je     8000e5 <umain+0x8c>
  8000df:	3c 31                	cmp    $0x31,%al
  8000e1:	75 eb                	jne    8000ce <umain+0x75>
  8000e3:	eb ee                	jmp    8000d3 <umain+0x7a>
  8000e5:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  8000e9:	83 85 54 ff ff ff 04 	addl   $0x4,-0xac(%ebp)
  8000f0:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  8000f6:	8b 18                	mov    (%eax),%ebx
  8000f8:	85 db                	test   %ebx,%ebx
  8000fa:	74 c5                	je     8000c1 <umain+0x68>
  8000fc:	80 3b 2d             	cmpb   $0x2d,(%ebx)
  8000ff:	75 c0                	jne    8000c1 <umain+0x68>
  800101:	83 c3 01             	add    $0x1,%ebx
  800104:	0f b6 03             	movzbl (%ebx),%eax
  800107:	84 c0                	test   %al,%al
  800109:	75 a1                	jne    8000ac <umain+0x53>
  80010b:	eb b4                	jmp    8000c1 <umain+0x68>
		usefprint = 1;
		break;
	}ARGEND

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
  80010d:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800111:	89 1c 24             	mov    %ebx,(%esp)
  800114:	e8 91 12 00 00       	call   8013aa <fstat>
  800119:	85 c0                	test   %eax,%eax
  80011b:	78 66                	js     800183 <umain+0x12a>
			if (usefprint)
  80011d:	85 f6                	test   %esi,%esi
  80011f:	74 36                	je     800157 <umain+0xfe>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  800121:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800124:	8b 40 04             	mov    0x4(%eax),%eax
  800127:	89 44 24 18          	mov    %eax,0x18(%esp)
  80012b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80012e:	89 44 24 14          	mov    %eax,0x14(%esp)
  800132:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800135:	89 44 24 10          	mov    %eax,0x10(%esp)
  800139:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80013d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800141:	c7 44 24 04 94 2a 80 	movl   $0x802a94,0x4(%esp)
  800148:	00 
  800149:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800150:	e8 e4 1a 00 00       	call   801c39 <fprintf>
  800155:	eb 2c                	jmp    800183 <umain+0x12a>
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);	
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  800157:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80015a:	8b 40 04             	mov    0x4(%eax),%eax
  80015d:	89 44 24 14          	mov    %eax,0x14(%esp)
  800161:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800164:	89 44 24 10          	mov    %eax,0x10(%esp)
  800168:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80016b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80016f:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800173:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800177:	c7 04 24 94 2a 80 00 	movl   $0x802a94,(%esp)
  80017e:	e8 46 01 00 00       	call   8002c9 <cprintf>
	case '1':
		usefprint = 1;
		break;
	}ARGEND

	for (i = 0; i < 32; i++)
  800183:	83 c3 01             	add    $0x1,%ebx
  800186:	83 fb 20             	cmp    $0x20,%ebx
  800189:	75 82                	jne    80010d <umain+0xb4>
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, st.st_isdir,
					st.st_size, st.st_dev->dev_name);
		}
}
  80018b:	81 c4 cc 00 00 00    	add    $0xcc,%esp
  800191:	5b                   	pop    %ebx
  800192:	5e                   	pop    %esi
  800193:	5f                   	pop    %edi
  800194:	5d                   	pop    %ebp
  800195:	c3                   	ret    
	...

00800198 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800198:	55                   	push   %ebp
  800199:	89 e5                	mov    %esp,%ebp
  80019b:	83 ec 18             	sub    $0x18,%esp
  80019e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001a1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8001a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  8001aa:	e8 ea 0f 00 00       	call   801199 <sys_getenvid>
  8001af:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001b7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001bc:	a3 74 60 80 00       	mov    %eax,0x806074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c1:	85 f6                	test   %esi,%esi
  8001c3:	7e 07                	jle    8001cc <libmain+0x34>
		binaryname = argv[0];
  8001c5:	8b 03                	mov    (%ebx),%eax
  8001c7:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  8001cc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001d0:	89 34 24             	mov    %esi,(%esp)
  8001d3:	e8 81 fe ff ff       	call   800059 <umain>

	// exit gracefully
	exit();
  8001d8:	e8 0b 00 00 00       	call   8001e8 <exit>
}
  8001dd:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8001e0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8001e3:	89 ec                	mov    %ebp,%esp
  8001e5:	5d                   	pop    %ebp
  8001e6:	c3                   	ret    
	...

008001e8 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e8:	55                   	push   %ebp
  8001e9:	89 e5                	mov    %esp,%ebp
  8001eb:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001ee:	e8 18 15 00 00       	call   80170b <close_all>
	sys_env_destroy(0);
  8001f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001fa:	e8 ce 0f 00 00       	call   8011cd <sys_env_destroy>
}
  8001ff:	c9                   	leave  
  800200:	c3                   	ret    
  800201:	00 00                	add    %al,(%eax)
	...

00800204 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	53                   	push   %ebx
  800208:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  80020b:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  80020e:	a1 78 60 80 00       	mov    0x806078,%eax
  800213:	85 c0                	test   %eax,%eax
  800215:	74 10                	je     800227 <_panic+0x23>
		cprintf("%s: ", argv0);
  800217:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021b:	c7 04 24 d3 2a 80 00 	movl   $0x802ad3,(%esp)
  800222:	e8 a2 00 00 00       	call   8002c9 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800227:	8b 45 0c             	mov    0xc(%ebp),%eax
  80022a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80022e:	8b 45 08             	mov    0x8(%ebp),%eax
  800231:	89 44 24 08          	mov    %eax,0x8(%esp)
  800235:	a1 00 60 80 00       	mov    0x806000,%eax
  80023a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023e:	c7 04 24 d8 2a 80 00 	movl   $0x802ad8,(%esp)
  800245:	e8 7f 00 00 00       	call   8002c9 <cprintf>
	vcprintf(fmt, ap);
  80024a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80024e:	8b 45 10             	mov    0x10(%ebp),%eax
  800251:	89 04 24             	mov    %eax,(%esp)
  800254:	e8 0f 00 00 00       	call   800268 <vcprintf>
	cprintf("\n");
  800259:	c7 04 24 90 2a 80 00 	movl   $0x802a90,(%esp)
  800260:	e8 64 00 00 00       	call   8002c9 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800265:	cc                   	int3   
  800266:	eb fd                	jmp    800265 <_panic+0x61>

00800268 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800268:	55                   	push   %ebp
  800269:	89 e5                	mov    %esp,%ebp
  80026b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800271:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800278:	00 00 00 
	b.cnt = 0;
  80027b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800282:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800285:	8b 45 0c             	mov    0xc(%ebp),%eax
  800288:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80028c:	8b 45 08             	mov    0x8(%ebp),%eax
  80028f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800293:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800299:	89 44 24 04          	mov    %eax,0x4(%esp)
  80029d:	c7 04 24 e3 02 80 00 	movl   $0x8002e3,(%esp)
  8002a4:	e8 d4 01 00 00       	call   80047d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002a9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002b9:	89 04 24             	mov    %eax,(%esp)
  8002bc:	e8 df 0a 00 00       	call   800da0 <sys_cputs>

	return b.cnt;
}
  8002c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002c7:	c9                   	leave  
  8002c8:	c3                   	ret    

008002c9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002c9:	55                   	push   %ebp
  8002ca:	89 e5                	mov    %esp,%ebp
  8002cc:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8002cf:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8002d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d9:	89 04 24             	mov    %eax,(%esp)
  8002dc:	e8 87 ff ff ff       	call   800268 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002e1:	c9                   	leave  
  8002e2:	c3                   	ret    

008002e3 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	53                   	push   %ebx
  8002e7:	83 ec 14             	sub    $0x14,%esp
  8002ea:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002ed:	8b 03                	mov    (%ebx),%eax
  8002ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f2:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002f6:	83 c0 01             	add    $0x1,%eax
  8002f9:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002fb:	3d ff 00 00 00       	cmp    $0xff,%eax
  800300:	75 19                	jne    80031b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800302:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800309:	00 
  80030a:	8d 43 08             	lea    0x8(%ebx),%eax
  80030d:	89 04 24             	mov    %eax,(%esp)
  800310:	e8 8b 0a 00 00       	call   800da0 <sys_cputs>
		b->idx = 0;
  800315:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80031b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80031f:	83 c4 14             	add    $0x14,%esp
  800322:	5b                   	pop    %ebx
  800323:	5d                   	pop    %ebp
  800324:	c3                   	ret    
	...

00800330 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800330:	55                   	push   %ebp
  800331:	89 e5                	mov    %esp,%ebp
  800333:	57                   	push   %edi
  800334:	56                   	push   %esi
  800335:	53                   	push   %ebx
  800336:	83 ec 4c             	sub    $0x4c,%esp
  800339:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80033c:	89 d6                	mov    %edx,%esi
  80033e:	8b 45 08             	mov    0x8(%ebp),%eax
  800341:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800344:	8b 55 0c             	mov    0xc(%ebp),%edx
  800347:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80034a:	8b 45 10             	mov    0x10(%ebp),%eax
  80034d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800350:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800353:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800356:	b9 00 00 00 00       	mov    $0x0,%ecx
  80035b:	39 d1                	cmp    %edx,%ecx
  80035d:	72 15                	jb     800374 <printnum+0x44>
  80035f:	77 07                	ja     800368 <printnum+0x38>
  800361:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800364:	39 d0                	cmp    %edx,%eax
  800366:	76 0c                	jbe    800374 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800368:	83 eb 01             	sub    $0x1,%ebx
  80036b:	85 db                	test   %ebx,%ebx
  80036d:	8d 76 00             	lea    0x0(%esi),%esi
  800370:	7f 61                	jg     8003d3 <printnum+0xa3>
  800372:	eb 70                	jmp    8003e4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800374:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800378:	83 eb 01             	sub    $0x1,%ebx
  80037b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80037f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800383:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800387:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80038b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80038e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800391:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800394:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800398:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80039f:	00 
  8003a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003a3:	89 04 24             	mov    %eax,(%esp)
  8003a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003ad:	e8 5e 24 00 00       	call   802810 <__udivdi3>
  8003b2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8003b5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8003b8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003bc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003c0:	89 04 24             	mov    %eax,(%esp)
  8003c3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003c7:	89 f2                	mov    %esi,%edx
  8003c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003cc:	e8 5f ff ff ff       	call   800330 <printnum>
  8003d1:	eb 11                	jmp    8003e4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003d3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003d7:	89 3c 24             	mov    %edi,(%esp)
  8003da:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003dd:	83 eb 01             	sub    $0x1,%ebx
  8003e0:	85 db                	test   %ebx,%ebx
  8003e2:	7f ef                	jg     8003d3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003e4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003e8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8003ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003fa:	00 
  8003fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003fe:	89 14 24             	mov    %edx,(%esp)
  800401:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800404:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800408:	e8 33 25 00 00       	call   802940 <__umoddi3>
  80040d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800411:	0f be 80 f4 2a 80 00 	movsbl 0x802af4(%eax),%eax
  800418:	89 04 24             	mov    %eax,(%esp)
  80041b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80041e:	83 c4 4c             	add    $0x4c,%esp
  800421:	5b                   	pop    %ebx
  800422:	5e                   	pop    %esi
  800423:	5f                   	pop    %edi
  800424:	5d                   	pop    %ebp
  800425:	c3                   	ret    

00800426 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800426:	55                   	push   %ebp
  800427:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800429:	83 fa 01             	cmp    $0x1,%edx
  80042c:	7e 0e                	jle    80043c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80042e:	8b 10                	mov    (%eax),%edx
  800430:	8d 4a 08             	lea    0x8(%edx),%ecx
  800433:	89 08                	mov    %ecx,(%eax)
  800435:	8b 02                	mov    (%edx),%eax
  800437:	8b 52 04             	mov    0x4(%edx),%edx
  80043a:	eb 22                	jmp    80045e <getuint+0x38>
	else if (lflag)
  80043c:	85 d2                	test   %edx,%edx
  80043e:	74 10                	je     800450 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800440:	8b 10                	mov    (%eax),%edx
  800442:	8d 4a 04             	lea    0x4(%edx),%ecx
  800445:	89 08                	mov    %ecx,(%eax)
  800447:	8b 02                	mov    (%edx),%eax
  800449:	ba 00 00 00 00       	mov    $0x0,%edx
  80044e:	eb 0e                	jmp    80045e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800450:	8b 10                	mov    (%eax),%edx
  800452:	8d 4a 04             	lea    0x4(%edx),%ecx
  800455:	89 08                	mov    %ecx,(%eax)
  800457:	8b 02                	mov    (%edx),%eax
  800459:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80045e:	5d                   	pop    %ebp
  80045f:	c3                   	ret    

00800460 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800466:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80046a:	8b 10                	mov    (%eax),%edx
  80046c:	3b 50 04             	cmp    0x4(%eax),%edx
  80046f:	73 0a                	jae    80047b <sprintputch+0x1b>
		*b->buf++ = ch;
  800471:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800474:	88 0a                	mov    %cl,(%edx)
  800476:	83 c2 01             	add    $0x1,%edx
  800479:	89 10                	mov    %edx,(%eax)
}
  80047b:	5d                   	pop    %ebp
  80047c:	c3                   	ret    

0080047d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80047d:	55                   	push   %ebp
  80047e:	89 e5                	mov    %esp,%ebp
  800480:	57                   	push   %edi
  800481:	56                   	push   %esi
  800482:	53                   	push   %ebx
  800483:	83 ec 5c             	sub    $0x5c,%esp
  800486:	8b 7d 08             	mov    0x8(%ebp),%edi
  800489:	8b 75 0c             	mov    0xc(%ebp),%esi
  80048c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80048f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800496:	eb 11                	jmp    8004a9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800498:	85 c0                	test   %eax,%eax
  80049a:	0f 84 09 04 00 00    	je     8008a9 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  8004a0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004a4:	89 04 24             	mov    %eax,(%esp)
  8004a7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004a9:	0f b6 03             	movzbl (%ebx),%eax
  8004ac:	83 c3 01             	add    $0x1,%ebx
  8004af:	83 f8 25             	cmp    $0x25,%eax
  8004b2:	75 e4                	jne    800498 <vprintfmt+0x1b>
  8004b4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8004b8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8004bf:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8004c6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004d2:	eb 06                	jmp    8004da <vprintfmt+0x5d>
  8004d4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8004d8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004da:	0f b6 13             	movzbl (%ebx),%edx
  8004dd:	0f b6 c2             	movzbl %dl,%eax
  8004e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004e3:	8d 43 01             	lea    0x1(%ebx),%eax
  8004e6:	83 ea 23             	sub    $0x23,%edx
  8004e9:	80 fa 55             	cmp    $0x55,%dl
  8004ec:	0f 87 9a 03 00 00    	ja     80088c <vprintfmt+0x40f>
  8004f2:	0f b6 d2             	movzbl %dl,%edx
  8004f5:	ff 24 95 40 2c 80 00 	jmp    *0x802c40(,%edx,4)
  8004fc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800500:	eb d6                	jmp    8004d8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800502:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800505:	83 ea 30             	sub    $0x30,%edx
  800508:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  80050b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80050e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800511:	83 fb 09             	cmp    $0x9,%ebx
  800514:	77 4c                	ja     800562 <vprintfmt+0xe5>
  800516:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800519:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80051c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80051f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800522:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800526:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800529:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80052c:	83 fb 09             	cmp    $0x9,%ebx
  80052f:	76 eb                	jbe    80051c <vprintfmt+0x9f>
  800531:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800534:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800537:	eb 29                	jmp    800562 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800539:	8b 55 14             	mov    0x14(%ebp),%edx
  80053c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80053f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800542:	8b 12                	mov    (%edx),%edx
  800544:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  800547:	eb 19                	jmp    800562 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800549:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80054c:	c1 fa 1f             	sar    $0x1f,%edx
  80054f:	f7 d2                	not    %edx
  800551:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800554:	eb 82                	jmp    8004d8 <vprintfmt+0x5b>
  800556:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80055d:	e9 76 ff ff ff       	jmp    8004d8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800562:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800566:	0f 89 6c ff ff ff    	jns    8004d8 <vprintfmt+0x5b>
  80056c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80056f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800572:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800575:	89 55 cc             	mov    %edx,-0x34(%ebp)
  800578:	e9 5b ff ff ff       	jmp    8004d8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80057d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800580:	e9 53 ff ff ff       	jmp    8004d8 <vprintfmt+0x5b>
  800585:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800588:	8b 45 14             	mov    0x14(%ebp),%eax
  80058b:	8d 50 04             	lea    0x4(%eax),%edx
  80058e:	89 55 14             	mov    %edx,0x14(%ebp)
  800591:	89 74 24 04          	mov    %esi,0x4(%esp)
  800595:	8b 00                	mov    (%eax),%eax
  800597:	89 04 24             	mov    %eax,(%esp)
  80059a:	ff d7                	call   *%edi
  80059c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80059f:	e9 05 ff ff ff       	jmp    8004a9 <vprintfmt+0x2c>
  8005a4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005aa:	8d 50 04             	lea    0x4(%eax),%edx
  8005ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b0:	8b 00                	mov    (%eax),%eax
  8005b2:	89 c2                	mov    %eax,%edx
  8005b4:	c1 fa 1f             	sar    $0x1f,%edx
  8005b7:	31 d0                	xor    %edx,%eax
  8005b9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005bb:	83 f8 0f             	cmp    $0xf,%eax
  8005be:	7f 0b                	jg     8005cb <vprintfmt+0x14e>
  8005c0:	8b 14 85 a0 2d 80 00 	mov    0x802da0(,%eax,4),%edx
  8005c7:	85 d2                	test   %edx,%edx
  8005c9:	75 20                	jne    8005eb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8005cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005cf:	c7 44 24 08 05 2b 80 	movl   $0x802b05,0x8(%esp)
  8005d6:	00 
  8005d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005db:	89 3c 24             	mov    %edi,(%esp)
  8005de:	e8 4e 03 00 00       	call   800931 <printfmt>
  8005e3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005e6:	e9 be fe ff ff       	jmp    8004a9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005ef:	c7 44 24 08 ed 2e 80 	movl   $0x802eed,0x8(%esp)
  8005f6:	00 
  8005f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005fb:	89 3c 24             	mov    %edi,(%esp)
  8005fe:	e8 2e 03 00 00       	call   800931 <printfmt>
  800603:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800606:	e9 9e fe ff ff       	jmp    8004a9 <vprintfmt+0x2c>
  80060b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80060e:	89 c3                	mov    %eax,%ebx
  800610:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800613:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800616:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800619:	8b 45 14             	mov    0x14(%ebp),%eax
  80061c:	8d 50 04             	lea    0x4(%eax),%edx
  80061f:	89 55 14             	mov    %edx,0x14(%ebp)
  800622:	8b 00                	mov    (%eax),%eax
  800624:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800627:	85 c0                	test   %eax,%eax
  800629:	75 07                	jne    800632 <vprintfmt+0x1b5>
  80062b:	c7 45 c4 0e 2b 80 00 	movl   $0x802b0e,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800632:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  800636:	7e 06                	jle    80063e <vprintfmt+0x1c1>
  800638:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80063c:	75 13                	jne    800651 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80063e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800641:	0f be 02             	movsbl (%edx),%eax
  800644:	85 c0                	test   %eax,%eax
  800646:	0f 85 99 00 00 00    	jne    8006e5 <vprintfmt+0x268>
  80064c:	e9 86 00 00 00       	jmp    8006d7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800651:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800655:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800658:	89 0c 24             	mov    %ecx,(%esp)
  80065b:	e8 1b 03 00 00       	call   80097b <strnlen>
  800660:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800663:	29 c2                	sub    %eax,%edx
  800665:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800668:	85 d2                	test   %edx,%edx
  80066a:	7e d2                	jle    80063e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80066c:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  800670:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800673:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  800676:	89 d3                	mov    %edx,%ebx
  800678:	89 74 24 04          	mov    %esi,0x4(%esp)
  80067c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80067f:	89 04 24             	mov    %eax,(%esp)
  800682:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800684:	83 eb 01             	sub    $0x1,%ebx
  800687:	85 db                	test   %ebx,%ebx
  800689:	7f ed                	jg     800678 <vprintfmt+0x1fb>
  80068b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80068e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800695:	eb a7                	jmp    80063e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800697:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80069b:	74 18                	je     8006b5 <vprintfmt+0x238>
  80069d:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006a0:	83 fa 5e             	cmp    $0x5e,%edx
  8006a3:	76 10                	jbe    8006b5 <vprintfmt+0x238>
					putch('?', putdat);
  8006a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006a9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006b0:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006b3:	eb 0a                	jmp    8006bf <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8006b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006b9:	89 04 24             	mov    %eax,(%esp)
  8006bc:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006bf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8006c3:	0f be 03             	movsbl (%ebx),%eax
  8006c6:	85 c0                	test   %eax,%eax
  8006c8:	74 05                	je     8006cf <vprintfmt+0x252>
  8006ca:	83 c3 01             	add    $0x1,%ebx
  8006cd:	eb 29                	jmp    8006f8 <vprintfmt+0x27b>
  8006cf:	89 fe                	mov    %edi,%esi
  8006d1:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006d4:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006db:	7f 2e                	jg     80070b <vprintfmt+0x28e>
  8006dd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006e0:	e9 c4 fd ff ff       	jmp    8004a9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006e5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006e8:	83 c2 01             	add    $0x1,%edx
  8006eb:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8006ee:	89 f7                	mov    %esi,%edi
  8006f0:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006f3:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  8006f6:	89 d3                	mov    %edx,%ebx
  8006f8:	85 f6                	test   %esi,%esi
  8006fa:	78 9b                	js     800697 <vprintfmt+0x21a>
  8006fc:	83 ee 01             	sub    $0x1,%esi
  8006ff:	79 96                	jns    800697 <vprintfmt+0x21a>
  800701:	89 fe                	mov    %edi,%esi
  800703:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800706:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800709:	eb cc                	jmp    8006d7 <vprintfmt+0x25a>
  80070b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  80070e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800711:	89 74 24 04          	mov    %esi,0x4(%esp)
  800715:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80071c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80071e:	83 eb 01             	sub    $0x1,%ebx
  800721:	85 db                	test   %ebx,%ebx
  800723:	7f ec                	jg     800711 <vprintfmt+0x294>
  800725:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800728:	e9 7c fd ff ff       	jmp    8004a9 <vprintfmt+0x2c>
  80072d:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800730:	83 f9 01             	cmp    $0x1,%ecx
  800733:	7e 16                	jle    80074b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800735:	8b 45 14             	mov    0x14(%ebp),%eax
  800738:	8d 50 08             	lea    0x8(%eax),%edx
  80073b:	89 55 14             	mov    %edx,0x14(%ebp)
  80073e:	8b 10                	mov    (%eax),%edx
  800740:	8b 48 04             	mov    0x4(%eax),%ecx
  800743:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800746:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800749:	eb 32                	jmp    80077d <vprintfmt+0x300>
	else if (lflag)
  80074b:	85 c9                	test   %ecx,%ecx
  80074d:	74 18                	je     800767 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80074f:	8b 45 14             	mov    0x14(%ebp),%eax
  800752:	8d 50 04             	lea    0x4(%eax),%edx
  800755:	89 55 14             	mov    %edx,0x14(%ebp)
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80075d:	89 c1                	mov    %eax,%ecx
  80075f:	c1 f9 1f             	sar    $0x1f,%ecx
  800762:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800765:	eb 16                	jmp    80077d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	8d 50 04             	lea    0x4(%eax),%edx
  80076d:	89 55 14             	mov    %edx,0x14(%ebp)
  800770:	8b 00                	mov    (%eax),%eax
  800772:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800775:	89 c2                	mov    %eax,%edx
  800777:	c1 fa 1f             	sar    $0x1f,%edx
  80077a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80077d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800780:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800783:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800788:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80078c:	0f 89 b8 00 00 00    	jns    80084a <vprintfmt+0x3cd>
				putch('-', putdat);
  800792:	89 74 24 04          	mov    %esi,0x4(%esp)
  800796:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80079d:	ff d7                	call   *%edi
				num = -(long long) num;
  80079f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8007a2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007a5:	f7 d9                	neg    %ecx
  8007a7:	83 d3 00             	adc    $0x0,%ebx
  8007aa:	f7 db                	neg    %ebx
  8007ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b1:	e9 94 00 00 00       	jmp    80084a <vprintfmt+0x3cd>
  8007b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007b9:	89 ca                	mov    %ecx,%edx
  8007bb:	8d 45 14             	lea    0x14(%ebp),%eax
  8007be:	e8 63 fc ff ff       	call   800426 <getuint>
  8007c3:	89 c1                	mov    %eax,%ecx
  8007c5:	89 d3                	mov    %edx,%ebx
  8007c7:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8007cc:	eb 7c                	jmp    80084a <vprintfmt+0x3cd>
  8007ce:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007d5:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8007dc:	ff d7                	call   *%edi
			putch('X', putdat);
  8007de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007e2:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8007e9:	ff d7                	call   *%edi
			putch('X', putdat);
  8007eb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007ef:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8007f6:	ff d7                	call   *%edi
  8007f8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8007fb:	e9 a9 fc ff ff       	jmp    8004a9 <vprintfmt+0x2c>
  800800:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800803:	89 74 24 04          	mov    %esi,0x4(%esp)
  800807:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80080e:	ff d7                	call   *%edi
			putch('x', putdat);
  800810:	89 74 24 04          	mov    %esi,0x4(%esp)
  800814:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80081b:	ff d7                	call   *%edi
			num = (unsigned long long)
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	8d 50 04             	lea    0x4(%eax),%edx
  800823:	89 55 14             	mov    %edx,0x14(%ebp)
  800826:	8b 08                	mov    (%eax),%ecx
  800828:	bb 00 00 00 00       	mov    $0x0,%ebx
  80082d:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800832:	eb 16                	jmp    80084a <vprintfmt+0x3cd>
  800834:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800837:	89 ca                	mov    %ecx,%edx
  800839:	8d 45 14             	lea    0x14(%ebp),%eax
  80083c:	e8 e5 fb ff ff       	call   800426 <getuint>
  800841:	89 c1                	mov    %eax,%ecx
  800843:	89 d3                	mov    %edx,%ebx
  800845:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80084a:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  80084e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800852:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800855:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800859:	89 44 24 08          	mov    %eax,0x8(%esp)
  80085d:	89 0c 24             	mov    %ecx,(%esp)
  800860:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800864:	89 f2                	mov    %esi,%edx
  800866:	89 f8                	mov    %edi,%eax
  800868:	e8 c3 fa ff ff       	call   800330 <printnum>
  80086d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800870:	e9 34 fc ff ff       	jmp    8004a9 <vprintfmt+0x2c>
  800875:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800878:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80087b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80087f:	89 14 24             	mov    %edx,(%esp)
  800882:	ff d7                	call   *%edi
  800884:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800887:	e9 1d fc ff ff       	jmp    8004a9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80088c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800890:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800897:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800899:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80089c:	80 38 25             	cmpb   $0x25,(%eax)
  80089f:	0f 84 04 fc ff ff    	je     8004a9 <vprintfmt+0x2c>
  8008a5:	89 c3                	mov    %eax,%ebx
  8008a7:	eb f0                	jmp    800899 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  8008a9:	83 c4 5c             	add    $0x5c,%esp
  8008ac:	5b                   	pop    %ebx
  8008ad:	5e                   	pop    %esi
  8008ae:	5f                   	pop    %edi
  8008af:	5d                   	pop    %ebp
  8008b0:	c3                   	ret    

008008b1 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008b1:	55                   	push   %ebp
  8008b2:	89 e5                	mov    %esp,%ebp
  8008b4:	83 ec 28             	sub    $0x28,%esp
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8008bd:	85 c0                	test   %eax,%eax
  8008bf:	74 04                	je     8008c5 <vsnprintf+0x14>
  8008c1:	85 d2                	test   %edx,%edx
  8008c3:	7f 07                	jg     8008cc <vsnprintf+0x1b>
  8008c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ca:	eb 3b                	jmp    800907 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008cf:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8008d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f2:	c7 04 24 60 04 80 00 	movl   $0x800460,(%esp)
  8008f9:	e8 7f fb ff ff       	call   80047d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800901:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800904:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800907:	c9                   	leave  
  800908:	c3                   	ret    

00800909 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800909:	55                   	push   %ebp
  80090a:	89 e5                	mov    %esp,%ebp
  80090c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80090f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800912:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800916:	8b 45 10             	mov    0x10(%ebp),%eax
  800919:	89 44 24 08          	mov    %eax,0x8(%esp)
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	89 44 24 04          	mov    %eax,0x4(%esp)
  800924:	8b 45 08             	mov    0x8(%ebp),%eax
  800927:	89 04 24             	mov    %eax,(%esp)
  80092a:	e8 82 ff ff ff       	call   8008b1 <vsnprintf>
	va_end(ap);

	return rc;
}
  80092f:	c9                   	leave  
  800930:	c3                   	ret    

00800931 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800931:	55                   	push   %ebp
  800932:	89 e5                	mov    %esp,%ebp
  800934:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800937:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80093a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80093e:	8b 45 10             	mov    0x10(%ebp),%eax
  800941:	89 44 24 08          	mov    %eax,0x8(%esp)
  800945:	8b 45 0c             	mov    0xc(%ebp),%eax
  800948:	89 44 24 04          	mov    %eax,0x4(%esp)
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	89 04 24             	mov    %eax,(%esp)
  800952:	e8 26 fb ff ff       	call   80047d <vprintfmt>
	va_end(ap);
}
  800957:	c9                   	leave  
  800958:	c3                   	ret    
  800959:	00 00                	add    %al,(%eax)
  80095b:	00 00                	add    %al,(%eax)
  80095d:	00 00                	add    %al,(%eax)
	...

00800960 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800966:	b8 00 00 00 00       	mov    $0x0,%eax
  80096b:	80 3a 00             	cmpb   $0x0,(%edx)
  80096e:	74 09                	je     800979 <strlen+0x19>
		n++;
  800970:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800973:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800977:	75 f7                	jne    800970 <strlen+0x10>
		n++;
	return n;
}
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	53                   	push   %ebx
  80097f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800982:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800985:	85 c9                	test   %ecx,%ecx
  800987:	74 19                	je     8009a2 <strnlen+0x27>
  800989:	80 3b 00             	cmpb   $0x0,(%ebx)
  80098c:	74 14                	je     8009a2 <strnlen+0x27>
  80098e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800993:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800996:	39 c8                	cmp    %ecx,%eax
  800998:	74 0d                	je     8009a7 <strnlen+0x2c>
  80099a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80099e:	75 f3                	jne    800993 <strnlen+0x18>
  8009a0:	eb 05                	jmp    8009a7 <strnlen+0x2c>
  8009a2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8009a7:	5b                   	pop    %ebx
  8009a8:	5d                   	pop    %ebp
  8009a9:	c3                   	ret    

008009aa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009aa:	55                   	push   %ebp
  8009ab:	89 e5                	mov    %esp,%ebp
  8009ad:	53                   	push   %ebx
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009b4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009b9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009bd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009c0:	83 c2 01             	add    $0x1,%edx
  8009c3:	84 c9                	test   %cl,%cl
  8009c5:	75 f2                	jne    8009b9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009c7:	5b                   	pop    %ebx
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	56                   	push   %esi
  8009ce:	53                   	push   %ebx
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009d5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009d8:	85 f6                	test   %esi,%esi
  8009da:	74 18                	je     8009f4 <strncpy+0x2a>
  8009dc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8009e1:	0f b6 1a             	movzbl (%edx),%ebx
  8009e4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009e7:	80 3a 01             	cmpb   $0x1,(%edx)
  8009ea:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ed:	83 c1 01             	add    $0x1,%ecx
  8009f0:	39 ce                	cmp    %ecx,%esi
  8009f2:	77 ed                	ja     8009e1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009f4:	5b                   	pop    %ebx
  8009f5:	5e                   	pop    %esi
  8009f6:	5d                   	pop    %ebp
  8009f7:	c3                   	ret    

008009f8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	56                   	push   %esi
  8009fc:	53                   	push   %ebx
  8009fd:	8b 75 08             	mov    0x8(%ebp),%esi
  800a00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a03:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a06:	89 f0                	mov    %esi,%eax
  800a08:	85 c9                	test   %ecx,%ecx
  800a0a:	74 27                	je     800a33 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800a0c:	83 e9 01             	sub    $0x1,%ecx
  800a0f:	74 1d                	je     800a2e <strlcpy+0x36>
  800a11:	0f b6 1a             	movzbl (%edx),%ebx
  800a14:	84 db                	test   %bl,%bl
  800a16:	74 16                	je     800a2e <strlcpy+0x36>
			*dst++ = *src++;
  800a18:	88 18                	mov    %bl,(%eax)
  800a1a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a1d:	83 e9 01             	sub    $0x1,%ecx
  800a20:	74 0e                	je     800a30 <strlcpy+0x38>
			*dst++ = *src++;
  800a22:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a25:	0f b6 1a             	movzbl (%edx),%ebx
  800a28:	84 db                	test   %bl,%bl
  800a2a:	75 ec                	jne    800a18 <strlcpy+0x20>
  800a2c:	eb 02                	jmp    800a30 <strlcpy+0x38>
  800a2e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800a30:	c6 00 00             	movb   $0x0,(%eax)
  800a33:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800a35:	5b                   	pop    %ebx
  800a36:	5e                   	pop    %esi
  800a37:	5d                   	pop    %ebp
  800a38:	c3                   	ret    

00800a39 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a3f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a42:	0f b6 01             	movzbl (%ecx),%eax
  800a45:	84 c0                	test   %al,%al
  800a47:	74 15                	je     800a5e <strcmp+0x25>
  800a49:	3a 02                	cmp    (%edx),%al
  800a4b:	75 11                	jne    800a5e <strcmp+0x25>
		p++, q++;
  800a4d:	83 c1 01             	add    $0x1,%ecx
  800a50:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a53:	0f b6 01             	movzbl (%ecx),%eax
  800a56:	84 c0                	test   %al,%al
  800a58:	74 04                	je     800a5e <strcmp+0x25>
  800a5a:	3a 02                	cmp    (%edx),%al
  800a5c:	74 ef                	je     800a4d <strcmp+0x14>
  800a5e:	0f b6 c0             	movzbl %al,%eax
  800a61:	0f b6 12             	movzbl (%edx),%edx
  800a64:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a66:	5d                   	pop    %ebp
  800a67:	c3                   	ret    

00800a68 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	53                   	push   %ebx
  800a6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a72:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800a75:	85 c0                	test   %eax,%eax
  800a77:	74 23                	je     800a9c <strncmp+0x34>
  800a79:	0f b6 1a             	movzbl (%edx),%ebx
  800a7c:	84 db                	test   %bl,%bl
  800a7e:	74 24                	je     800aa4 <strncmp+0x3c>
  800a80:	3a 19                	cmp    (%ecx),%bl
  800a82:	75 20                	jne    800aa4 <strncmp+0x3c>
  800a84:	83 e8 01             	sub    $0x1,%eax
  800a87:	74 13                	je     800a9c <strncmp+0x34>
		n--, p++, q++;
  800a89:	83 c2 01             	add    $0x1,%edx
  800a8c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a8f:	0f b6 1a             	movzbl (%edx),%ebx
  800a92:	84 db                	test   %bl,%bl
  800a94:	74 0e                	je     800aa4 <strncmp+0x3c>
  800a96:	3a 19                	cmp    (%ecx),%bl
  800a98:	74 ea                	je     800a84 <strncmp+0x1c>
  800a9a:	eb 08                	jmp    800aa4 <strncmp+0x3c>
  800a9c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800aa1:	5b                   	pop    %ebx
  800aa2:	5d                   	pop    %ebp
  800aa3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800aa4:	0f b6 02             	movzbl (%edx),%eax
  800aa7:	0f b6 11             	movzbl (%ecx),%edx
  800aaa:	29 d0                	sub    %edx,%eax
  800aac:	eb f3                	jmp    800aa1 <strncmp+0x39>

00800aae <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800aae:	55                   	push   %ebp
  800aaf:	89 e5                	mov    %esp,%ebp
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ab8:	0f b6 10             	movzbl (%eax),%edx
  800abb:	84 d2                	test   %dl,%dl
  800abd:	74 15                	je     800ad4 <strchr+0x26>
		if (*s == c)
  800abf:	38 ca                	cmp    %cl,%dl
  800ac1:	75 07                	jne    800aca <strchr+0x1c>
  800ac3:	eb 14                	jmp    800ad9 <strchr+0x2b>
  800ac5:	38 ca                	cmp    %cl,%dl
  800ac7:	90                   	nop
  800ac8:	74 0f                	je     800ad9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aca:	83 c0 01             	add    $0x1,%eax
  800acd:	0f b6 10             	movzbl (%eax),%edx
  800ad0:	84 d2                	test   %dl,%dl
  800ad2:	75 f1                	jne    800ac5 <strchr+0x17>
  800ad4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ae5:	0f b6 10             	movzbl (%eax),%edx
  800ae8:	84 d2                	test   %dl,%dl
  800aea:	74 18                	je     800b04 <strfind+0x29>
		if (*s == c)
  800aec:	38 ca                	cmp    %cl,%dl
  800aee:	75 0a                	jne    800afa <strfind+0x1f>
  800af0:	eb 12                	jmp    800b04 <strfind+0x29>
  800af2:	38 ca                	cmp    %cl,%dl
  800af4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800af8:	74 0a                	je     800b04 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800afa:	83 c0 01             	add    $0x1,%eax
  800afd:	0f b6 10             	movzbl (%eax),%edx
  800b00:	84 d2                	test   %dl,%dl
  800b02:	75 ee                	jne    800af2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800b04:	5d                   	pop    %ebp
  800b05:	c3                   	ret    

00800b06 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	83 ec 0c             	sub    $0xc,%esp
  800b0c:	89 1c 24             	mov    %ebx,(%esp)
  800b0f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b13:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800b17:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b20:	85 c9                	test   %ecx,%ecx
  800b22:	74 30                	je     800b54 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b24:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b2a:	75 25                	jne    800b51 <memset+0x4b>
  800b2c:	f6 c1 03             	test   $0x3,%cl
  800b2f:	75 20                	jne    800b51 <memset+0x4b>
		c &= 0xFF;
  800b31:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b34:	89 d3                	mov    %edx,%ebx
  800b36:	c1 e3 08             	shl    $0x8,%ebx
  800b39:	89 d6                	mov    %edx,%esi
  800b3b:	c1 e6 18             	shl    $0x18,%esi
  800b3e:	89 d0                	mov    %edx,%eax
  800b40:	c1 e0 10             	shl    $0x10,%eax
  800b43:	09 f0                	or     %esi,%eax
  800b45:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800b47:	09 d8                	or     %ebx,%eax
  800b49:	c1 e9 02             	shr    $0x2,%ecx
  800b4c:	fc                   	cld    
  800b4d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b4f:	eb 03                	jmp    800b54 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b51:	fc                   	cld    
  800b52:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b54:	89 f8                	mov    %edi,%eax
  800b56:	8b 1c 24             	mov    (%esp),%ebx
  800b59:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b5d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b61:	89 ec                	mov    %ebp,%esp
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    

00800b65 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 08             	sub    $0x8,%esp
  800b6b:	89 34 24             	mov    %esi,(%esp)
  800b6e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b72:	8b 45 08             	mov    0x8(%ebp),%eax
  800b75:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800b78:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800b7b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800b7d:	39 c6                	cmp    %eax,%esi
  800b7f:	73 35                	jae    800bb6 <memmove+0x51>
  800b81:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b84:	39 d0                	cmp    %edx,%eax
  800b86:	73 2e                	jae    800bb6 <memmove+0x51>
		s += n;
		d += n;
  800b88:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b8a:	f6 c2 03             	test   $0x3,%dl
  800b8d:	75 1b                	jne    800baa <memmove+0x45>
  800b8f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b95:	75 13                	jne    800baa <memmove+0x45>
  800b97:	f6 c1 03             	test   $0x3,%cl
  800b9a:	75 0e                	jne    800baa <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800b9c:	83 ef 04             	sub    $0x4,%edi
  800b9f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ba2:	c1 e9 02             	shr    $0x2,%ecx
  800ba5:	fd                   	std    
  800ba6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ba8:	eb 09                	jmp    800bb3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800baa:	83 ef 01             	sub    $0x1,%edi
  800bad:	8d 72 ff             	lea    -0x1(%edx),%esi
  800bb0:	fd                   	std    
  800bb1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bb3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bb4:	eb 20                	jmp    800bd6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bb6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bbc:	75 15                	jne    800bd3 <memmove+0x6e>
  800bbe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bc4:	75 0d                	jne    800bd3 <memmove+0x6e>
  800bc6:	f6 c1 03             	test   $0x3,%cl
  800bc9:	75 08                	jne    800bd3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800bcb:	c1 e9 02             	shr    $0x2,%ecx
  800bce:	fc                   	cld    
  800bcf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd1:	eb 03                	jmp    800bd6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800bd3:	fc                   	cld    
  800bd4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bd6:	8b 34 24             	mov    (%esp),%esi
  800bd9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800bdd:	89 ec                	mov    %ebp,%esp
  800bdf:	5d                   	pop    %ebp
  800be0:	c3                   	ret    

00800be1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800be1:	55                   	push   %ebp
  800be2:	89 e5                	mov    %esp,%ebp
  800be4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800be7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bea:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	89 04 24             	mov    %eax,(%esp)
  800bfb:	e8 65 ff ff ff       	call   800b65 <memmove>
}
  800c00:	c9                   	leave  
  800c01:	c3                   	ret    

00800c02 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c02:	55                   	push   %ebp
  800c03:	89 e5                	mov    %esp,%ebp
  800c05:	57                   	push   %edi
  800c06:	56                   	push   %esi
  800c07:	53                   	push   %ebx
  800c08:	8b 75 08             	mov    0x8(%ebp),%esi
  800c0b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800c0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c11:	85 c9                	test   %ecx,%ecx
  800c13:	74 36                	je     800c4b <memcmp+0x49>
		if (*s1 != *s2)
  800c15:	0f b6 06             	movzbl (%esi),%eax
  800c18:	0f b6 1f             	movzbl (%edi),%ebx
  800c1b:	38 d8                	cmp    %bl,%al
  800c1d:	74 20                	je     800c3f <memcmp+0x3d>
  800c1f:	eb 14                	jmp    800c35 <memcmp+0x33>
  800c21:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800c26:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800c2b:	83 c2 01             	add    $0x1,%edx
  800c2e:	83 e9 01             	sub    $0x1,%ecx
  800c31:	38 d8                	cmp    %bl,%al
  800c33:	74 12                	je     800c47 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800c35:	0f b6 c0             	movzbl %al,%eax
  800c38:	0f b6 db             	movzbl %bl,%ebx
  800c3b:	29 d8                	sub    %ebx,%eax
  800c3d:	eb 11                	jmp    800c50 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c3f:	83 e9 01             	sub    $0x1,%ecx
  800c42:	ba 00 00 00 00       	mov    $0x0,%edx
  800c47:	85 c9                	test   %ecx,%ecx
  800c49:	75 d6                	jne    800c21 <memcmp+0x1f>
  800c4b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800c50:	5b                   	pop    %ebx
  800c51:	5e                   	pop    %esi
  800c52:	5f                   	pop    %edi
  800c53:	5d                   	pop    %ebp
  800c54:	c3                   	ret    

00800c55 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c5b:	89 c2                	mov    %eax,%edx
  800c5d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c60:	39 d0                	cmp    %edx,%eax
  800c62:	73 15                	jae    800c79 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c64:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c68:	38 08                	cmp    %cl,(%eax)
  800c6a:	75 06                	jne    800c72 <memfind+0x1d>
  800c6c:	eb 0b                	jmp    800c79 <memfind+0x24>
  800c6e:	38 08                	cmp    %cl,(%eax)
  800c70:	74 07                	je     800c79 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c72:	83 c0 01             	add    $0x1,%eax
  800c75:	39 c2                	cmp    %eax,%edx
  800c77:	77 f5                	ja     800c6e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c79:	5d                   	pop    %ebp
  800c7a:	c3                   	ret    

00800c7b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c7b:	55                   	push   %ebp
  800c7c:	89 e5                	mov    %esp,%ebp
  800c7e:	57                   	push   %edi
  800c7f:	56                   	push   %esi
  800c80:	53                   	push   %ebx
  800c81:	83 ec 04             	sub    $0x4,%esp
  800c84:	8b 55 08             	mov    0x8(%ebp),%edx
  800c87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c8a:	0f b6 02             	movzbl (%edx),%eax
  800c8d:	3c 20                	cmp    $0x20,%al
  800c8f:	74 04                	je     800c95 <strtol+0x1a>
  800c91:	3c 09                	cmp    $0x9,%al
  800c93:	75 0e                	jne    800ca3 <strtol+0x28>
		s++;
  800c95:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c98:	0f b6 02             	movzbl (%edx),%eax
  800c9b:	3c 20                	cmp    $0x20,%al
  800c9d:	74 f6                	je     800c95 <strtol+0x1a>
  800c9f:	3c 09                	cmp    $0x9,%al
  800ca1:	74 f2                	je     800c95 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ca3:	3c 2b                	cmp    $0x2b,%al
  800ca5:	75 0c                	jne    800cb3 <strtol+0x38>
		s++;
  800ca7:	83 c2 01             	add    $0x1,%edx
  800caa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cb1:	eb 15                	jmp    800cc8 <strtol+0x4d>
	else if (*s == '-')
  800cb3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cba:	3c 2d                	cmp    $0x2d,%al
  800cbc:	75 0a                	jne    800cc8 <strtol+0x4d>
		s++, neg = 1;
  800cbe:	83 c2 01             	add    $0x1,%edx
  800cc1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cc8:	85 db                	test   %ebx,%ebx
  800cca:	0f 94 c0             	sete   %al
  800ccd:	74 05                	je     800cd4 <strtol+0x59>
  800ccf:	83 fb 10             	cmp    $0x10,%ebx
  800cd2:	75 18                	jne    800cec <strtol+0x71>
  800cd4:	80 3a 30             	cmpb   $0x30,(%edx)
  800cd7:	75 13                	jne    800cec <strtol+0x71>
  800cd9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800cdd:	8d 76 00             	lea    0x0(%esi),%esi
  800ce0:	75 0a                	jne    800cec <strtol+0x71>
		s += 2, base = 16;
  800ce2:	83 c2 02             	add    $0x2,%edx
  800ce5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800cea:	eb 15                	jmp    800d01 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cec:	84 c0                	test   %al,%al
  800cee:	66 90                	xchg   %ax,%ax
  800cf0:	74 0f                	je     800d01 <strtol+0x86>
  800cf2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800cf7:	80 3a 30             	cmpb   $0x30,(%edx)
  800cfa:	75 05                	jne    800d01 <strtol+0x86>
		s++, base = 8;
  800cfc:	83 c2 01             	add    $0x1,%edx
  800cff:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d01:	b8 00 00 00 00       	mov    $0x0,%eax
  800d06:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d08:	0f b6 0a             	movzbl (%edx),%ecx
  800d0b:	89 cf                	mov    %ecx,%edi
  800d0d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800d10:	80 fb 09             	cmp    $0x9,%bl
  800d13:	77 08                	ja     800d1d <strtol+0xa2>
			dig = *s - '0';
  800d15:	0f be c9             	movsbl %cl,%ecx
  800d18:	83 e9 30             	sub    $0x30,%ecx
  800d1b:	eb 1e                	jmp    800d3b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800d1d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800d20:	80 fb 19             	cmp    $0x19,%bl
  800d23:	77 08                	ja     800d2d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800d25:	0f be c9             	movsbl %cl,%ecx
  800d28:	83 e9 57             	sub    $0x57,%ecx
  800d2b:	eb 0e                	jmp    800d3b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800d2d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800d30:	80 fb 19             	cmp    $0x19,%bl
  800d33:	77 15                	ja     800d4a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800d35:	0f be c9             	movsbl %cl,%ecx
  800d38:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d3b:	39 f1                	cmp    %esi,%ecx
  800d3d:	7d 0b                	jge    800d4a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800d3f:	83 c2 01             	add    $0x1,%edx
  800d42:	0f af c6             	imul   %esi,%eax
  800d45:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800d48:	eb be                	jmp    800d08 <strtol+0x8d>
  800d4a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800d4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d50:	74 05                	je     800d57 <strtol+0xdc>
		*endptr = (char *) s;
  800d52:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d55:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d5b:	74 04                	je     800d61 <strtol+0xe6>
  800d5d:	89 c8                	mov    %ecx,%eax
  800d5f:	f7 d8                	neg    %eax
}
  800d61:	83 c4 04             	add    $0x4,%esp
  800d64:	5b                   	pop    %ebx
  800d65:	5e                   	pop    %esi
  800d66:	5f                   	pop    %edi
  800d67:	5d                   	pop    %ebp
  800d68:	c3                   	ret    
  800d69:	00 00                	add    %al,(%eax)
	...

00800d6c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800d6c:	55                   	push   %ebp
  800d6d:	89 e5                	mov    %esp,%ebp
  800d6f:	83 ec 0c             	sub    $0xc,%esp
  800d72:	89 1c 24             	mov    %ebx,(%esp)
  800d75:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d79:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d82:	b8 01 00 00 00       	mov    $0x1,%eax
  800d87:	89 d1                	mov    %edx,%ecx
  800d89:	89 d3                	mov    %edx,%ebx
  800d8b:	89 d7                	mov    %edx,%edi
  800d8d:	89 d6                	mov    %edx,%esi
  800d8f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d91:	8b 1c 24             	mov    (%esp),%ebx
  800d94:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d98:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d9c:	89 ec                	mov    %ebp,%esp
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	83 ec 0c             	sub    $0xc,%esp
  800da6:	89 1c 24             	mov    %ebx,(%esp)
  800da9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dad:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800db1:	b8 00 00 00 00       	mov    $0x0,%eax
  800db6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbc:	89 c3                	mov    %eax,%ebx
  800dbe:	89 c7                	mov    %eax,%edi
  800dc0:	89 c6                	mov    %eax,%esi
  800dc2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800dc4:	8b 1c 24             	mov    (%esp),%ebx
  800dc7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dcb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dcf:	89 ec                	mov    %ebp,%esp
  800dd1:	5d                   	pop    %ebp
  800dd2:	c3                   	ret    

00800dd3 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 0c             	sub    $0xc,%esp
  800dd9:	89 1c 24             	mov    %ebx,(%esp)
  800ddc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800de0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800de4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800de9:	b8 10 00 00 00       	mov    $0x10,%eax
  800dee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df1:	8b 55 08             	mov    0x8(%ebp),%edx
  800df4:	89 df                	mov    %ebx,%edi
  800df6:	89 de                	mov    %ebx,%esi
  800df8:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800dfa:	8b 1c 24             	mov    (%esp),%ebx
  800dfd:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e01:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e05:	89 ec                	mov    %ebp,%esp
  800e07:	5d                   	pop    %ebp
  800e08:	c3                   	ret    

00800e09 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  800e09:	55                   	push   %ebp
  800e0a:	89 e5                	mov    %esp,%ebp
  800e0c:	83 ec 38             	sub    $0x38,%esp
  800e0f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e12:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e15:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e18:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e1d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e25:	8b 55 08             	mov    0x8(%ebp),%edx
  800e28:	89 df                	mov    %ebx,%edi
  800e2a:	89 de                	mov    %ebx,%esi
  800e2c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e2e:	85 c0                	test   %eax,%eax
  800e30:	7e 28                	jle    800e5a <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e32:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e36:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800e3d:	00 
  800e3e:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800e45:	00 
  800e46:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e4d:	00 
  800e4e:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800e55:	e8 aa f3 ff ff       	call   800204 <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800e5a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e5d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e60:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e63:	89 ec                	mov    %ebp,%esp
  800e65:	5d                   	pop    %ebp
  800e66:	c3                   	ret    

00800e67 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 0c             	sub    $0xc,%esp
  800e6d:	89 1c 24             	mov    %ebx,(%esp)
  800e70:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e74:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e78:	ba 00 00 00 00       	mov    $0x0,%edx
  800e7d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e82:	89 d1                	mov    %edx,%ecx
  800e84:	89 d3                	mov    %edx,%ebx
  800e86:	89 d7                	mov    %edx,%edi
  800e88:	89 d6                	mov    %edx,%esi
  800e8a:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e8c:	8b 1c 24             	mov    (%esp),%ebx
  800e8f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e93:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e97:	89 ec                	mov    %ebp,%esp
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 38             	sub    $0x38,%esp
  800ea1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ea4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ea7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eaa:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eaf:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eb4:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb7:	89 cb                	mov    %ecx,%ebx
  800eb9:	89 cf                	mov    %ecx,%edi
  800ebb:	89 ce                	mov    %ecx,%esi
  800ebd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	7e 28                	jle    800eeb <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ec3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ec7:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800ece:	00 
  800ecf:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800ed6:	00 
  800ed7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ede:	00 
  800edf:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800ee6:	e8 19 f3 ff ff       	call   800204 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eeb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ef1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ef4:	89 ec                	mov    %ebp,%esp
  800ef6:	5d                   	pop    %ebp
  800ef7:	c3                   	ret    

00800ef8 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800ef8:	55                   	push   %ebp
  800ef9:	89 e5                	mov    %esp,%ebp
  800efb:	83 ec 0c             	sub    $0xc,%esp
  800efe:	89 1c 24             	mov    %ebx,(%esp)
  800f01:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f05:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f09:	be 00 00 00 00       	mov    $0x0,%esi
  800f0e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f13:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f16:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f19:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f1c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f21:	8b 1c 24             	mov    (%esp),%ebx
  800f24:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f28:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f2c:	89 ec                	mov    %ebp,%esp
  800f2e:	5d                   	pop    %ebp
  800f2f:	c3                   	ret    

00800f30 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f30:	55                   	push   %ebp
  800f31:	89 e5                	mov    %esp,%ebp
  800f33:	83 ec 38             	sub    $0x38,%esp
  800f36:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f39:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f3c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f3f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f44:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4f:	89 df                	mov    %ebx,%edi
  800f51:	89 de                	mov    %ebx,%esi
  800f53:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f55:	85 c0                	test   %eax,%eax
  800f57:	7e 28                	jle    800f81 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f59:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f5d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f64:	00 
  800f65:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800f6c:	00 
  800f6d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f74:	00 
  800f75:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800f7c:	e8 83 f2 ff ff       	call   800204 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f81:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f84:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f87:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f8a:	89 ec                	mov    %ebp,%esp
  800f8c:	5d                   	pop    %ebp
  800f8d:	c3                   	ret    

00800f8e <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	83 ec 38             	sub    $0x38,%esp
  800f94:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f97:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f9a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fa2:	b8 09 00 00 00       	mov    $0x9,%eax
  800fa7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800faa:	8b 55 08             	mov    0x8(%ebp),%edx
  800fad:	89 df                	mov    %ebx,%edi
  800faf:	89 de                	mov    %ebx,%esi
  800fb1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fb3:	85 c0                	test   %eax,%eax
  800fb5:	7e 28                	jle    800fdf <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fbb:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800fc2:	00 
  800fc3:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  800fca:	00 
  800fcb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fd2:	00 
  800fd3:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800fda:	e8 25 f2 ff ff       	call   800204 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fdf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fe2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fe5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fe8:	89 ec                	mov    %ebp,%esp
  800fea:	5d                   	pop    %ebp
  800feb:	c3                   	ret    

00800fec <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fec:	55                   	push   %ebp
  800fed:	89 e5                	mov    %esp,%ebp
  800fef:	83 ec 38             	sub    $0x38,%esp
  800ff2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ff5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ff8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ffb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801000:	b8 08 00 00 00       	mov    $0x8,%eax
  801005:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801008:	8b 55 08             	mov    0x8(%ebp),%edx
  80100b:	89 df                	mov    %ebx,%edi
  80100d:	89 de                	mov    %ebx,%esi
  80100f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801011:	85 c0                	test   %eax,%eax
  801013:	7e 28                	jle    80103d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801015:	89 44 24 10          	mov    %eax,0x10(%esp)
  801019:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801020:	00 
  801021:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  801028:	00 
  801029:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801030:	00 
  801031:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  801038:	e8 c7 f1 ff ff       	call   800204 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80103d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801040:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801043:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801046:	89 ec                	mov    %ebp,%esp
  801048:	5d                   	pop    %ebp
  801049:	c3                   	ret    

0080104a <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80104a:	55                   	push   %ebp
  80104b:	89 e5                	mov    %esp,%ebp
  80104d:	83 ec 38             	sub    $0x38,%esp
  801050:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801053:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801056:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801059:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105e:	b8 06 00 00 00       	mov    $0x6,%eax
  801063:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801066:	8b 55 08             	mov    0x8(%ebp),%edx
  801069:	89 df                	mov    %ebx,%edi
  80106b:	89 de                	mov    %ebx,%esi
  80106d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80106f:	85 c0                	test   %eax,%eax
  801071:	7e 28                	jle    80109b <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801073:	89 44 24 10          	mov    %eax,0x10(%esp)
  801077:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80107e:	00 
  80107f:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  801086:	00 
  801087:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80108e:	00 
  80108f:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  801096:	e8 69 f1 ff ff       	call   800204 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80109b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80109e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010a1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010a4:	89 ec                	mov    %ebp,%esp
  8010a6:	5d                   	pop    %ebp
  8010a7:	c3                   	ret    

008010a8 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010a8:	55                   	push   %ebp
  8010a9:	89 e5                	mov    %esp,%ebp
  8010ab:	83 ec 38             	sub    $0x38,%esp
  8010ae:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010b1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010b4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b7:	b8 05 00 00 00       	mov    $0x5,%eax
  8010bc:	8b 75 18             	mov    0x18(%ebp),%esi
  8010bf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010cd:	85 c0                	test   %eax,%eax
  8010cf:	7e 28                	jle    8010f9 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010d5:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8010dc:	00 
  8010dd:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  8010e4:	00 
  8010e5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010ec:	00 
  8010ed:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  8010f4:	e8 0b f1 ff ff       	call   800204 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010f9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010fc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010ff:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801102:	89 ec                	mov    %ebp,%esp
  801104:	5d                   	pop    %ebp
  801105:	c3                   	ret    

00801106 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	83 ec 38             	sub    $0x38,%esp
  80110c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80110f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801112:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801115:	be 00 00 00 00       	mov    $0x0,%esi
  80111a:	b8 04 00 00 00       	mov    $0x4,%eax
  80111f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801122:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801125:	8b 55 08             	mov    0x8(%ebp),%edx
  801128:	89 f7                	mov    %esi,%edi
  80112a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80112c:	85 c0                	test   %eax,%eax
  80112e:	7e 28                	jle    801158 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801130:	89 44 24 10          	mov    %eax,0x10(%esp)
  801134:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80113b:	00 
  80113c:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  801143:	00 
  801144:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80114b:	00 
  80114c:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  801153:	e8 ac f0 ff ff       	call   800204 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801158:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80115b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80115e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801161:	89 ec                	mov    %ebp,%esp
  801163:	5d                   	pop    %ebp
  801164:	c3                   	ret    

00801165 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  801165:	55                   	push   %ebp
  801166:	89 e5                	mov    %esp,%ebp
  801168:	83 ec 0c             	sub    $0xc,%esp
  80116b:	89 1c 24             	mov    %ebx,(%esp)
  80116e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801172:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801176:	ba 00 00 00 00       	mov    $0x0,%edx
  80117b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801180:	89 d1                	mov    %edx,%ecx
  801182:	89 d3                	mov    %edx,%ebx
  801184:	89 d7                	mov    %edx,%edi
  801186:	89 d6                	mov    %edx,%esi
  801188:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80118a:	8b 1c 24             	mov    (%esp),%ebx
  80118d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801191:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801195:	89 ec                	mov    %ebp,%esp
  801197:	5d                   	pop    %ebp
  801198:	c3                   	ret    

00801199 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801199:	55                   	push   %ebp
  80119a:	89 e5                	mov    %esp,%ebp
  80119c:	83 ec 0c             	sub    $0xc,%esp
  80119f:	89 1c 24             	mov    %ebx,(%esp)
  8011a2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011a6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8011af:	b8 02 00 00 00       	mov    $0x2,%eax
  8011b4:	89 d1                	mov    %edx,%ecx
  8011b6:	89 d3                	mov    %edx,%ebx
  8011b8:	89 d7                	mov    %edx,%edi
  8011ba:	89 d6                	mov    %edx,%esi
  8011bc:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011be:	8b 1c 24             	mov    (%esp),%ebx
  8011c1:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011c5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011c9:	89 ec                	mov    %ebp,%esp
  8011cb:	5d                   	pop    %ebp
  8011cc:	c3                   	ret    

008011cd <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8011cd:	55                   	push   %ebp
  8011ce:	89 e5                	mov    %esp,%ebp
  8011d0:	83 ec 38             	sub    $0x38,%esp
  8011d3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011d6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011d9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011e1:	b8 03 00 00 00       	mov    $0x3,%eax
  8011e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e9:	89 cb                	mov    %ecx,%ebx
  8011eb:	89 cf                	mov    %ecx,%edi
  8011ed:	89 ce                	mov    %ecx,%esi
  8011ef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011f1:	85 c0                	test   %eax,%eax
  8011f3:	7e 28                	jle    80121d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011f5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011f9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801200:	00 
  801201:	c7 44 24 08 ff 2d 80 	movl   $0x802dff,0x8(%esp)
  801208:	00 
  801209:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801210:	00 
  801211:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  801218:	e8 e7 ef ff ff       	call   800204 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80121d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801220:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801223:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801226:	89 ec                	mov    %ebp,%esp
  801228:	5d                   	pop    %ebp
  801229:	c3                   	ret    
  80122a:	00 00                	add    %al,(%eax)
  80122c:	00 00                	add    %al,(%eax)
	...

00801230 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801230:	55                   	push   %ebp
  801231:	89 e5                	mov    %esp,%ebp
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	05 00 00 00 30       	add    $0x30000000,%eax
  80123b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80123e:	5d                   	pop    %ebp
  80123f:	c3                   	ret    

00801240 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801240:	55                   	push   %ebp
  801241:	89 e5                	mov    %esp,%ebp
  801243:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	89 04 24             	mov    %eax,(%esp)
  80124c:	e8 df ff ff ff       	call   801230 <fd2num>
  801251:	05 20 00 0d 00       	add    $0xd0020,%eax
  801256:	c1 e0 0c             	shl    $0xc,%eax
}
  801259:	c9                   	leave  
  80125a:	c3                   	ret    

0080125b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80125b:	55                   	push   %ebp
  80125c:	89 e5                	mov    %esp,%ebp
  80125e:	57                   	push   %edi
  80125f:	56                   	push   %esi
  801260:	53                   	push   %ebx
  801261:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801264:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801269:	a8 01                	test   $0x1,%al
  80126b:	74 36                	je     8012a3 <fd_alloc+0x48>
  80126d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801272:	a8 01                	test   $0x1,%al
  801274:	74 2d                	je     8012a3 <fd_alloc+0x48>
  801276:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80127b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801280:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801285:	89 c3                	mov    %eax,%ebx
  801287:	89 c2                	mov    %eax,%edx
  801289:	c1 ea 16             	shr    $0x16,%edx
  80128c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80128f:	f6 c2 01             	test   $0x1,%dl
  801292:	74 14                	je     8012a8 <fd_alloc+0x4d>
  801294:	89 c2                	mov    %eax,%edx
  801296:	c1 ea 0c             	shr    $0xc,%edx
  801299:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80129c:	f6 c2 01             	test   $0x1,%dl
  80129f:	75 10                	jne    8012b1 <fd_alloc+0x56>
  8012a1:	eb 05                	jmp    8012a8 <fd_alloc+0x4d>
  8012a3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  8012a8:	89 1f                	mov    %ebx,(%edi)
  8012aa:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8012af:	eb 17                	jmp    8012c8 <fd_alloc+0x6d>
  8012b1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8012b6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8012bb:	75 c8                	jne    801285 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8012bd:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8012c3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8012c8:	5b                   	pop    %ebx
  8012c9:	5e                   	pop    %esi
  8012ca:	5f                   	pop    %edi
  8012cb:	5d                   	pop    %ebp
  8012cc:	c3                   	ret    

008012cd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	83 f8 1f             	cmp    $0x1f,%eax
  8012d6:	77 36                	ja     80130e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012d8:	05 00 00 0d 00       	add    $0xd0000,%eax
  8012dd:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8012e0:	89 c2                	mov    %eax,%edx
  8012e2:	c1 ea 16             	shr    $0x16,%edx
  8012e5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012ec:	f6 c2 01             	test   $0x1,%dl
  8012ef:	74 1d                	je     80130e <fd_lookup+0x41>
  8012f1:	89 c2                	mov    %eax,%edx
  8012f3:	c1 ea 0c             	shr    $0xc,%edx
  8012f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012fd:	f6 c2 01             	test   $0x1,%dl
  801300:	74 0c                	je     80130e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801302:	8b 55 0c             	mov    0xc(%ebp),%edx
  801305:	89 02                	mov    %eax,(%edx)
  801307:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80130c:	eb 05                	jmp    801313 <fd_lookup+0x46>
  80130e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801313:	5d                   	pop    %ebp
  801314:	c3                   	ret    

00801315 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801315:	55                   	push   %ebp
  801316:	89 e5                	mov    %esp,%ebp
  801318:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80131b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80131e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801322:	8b 45 08             	mov    0x8(%ebp),%eax
  801325:	89 04 24             	mov    %eax,(%esp)
  801328:	e8 a0 ff ff ff       	call   8012cd <fd_lookup>
  80132d:	85 c0                	test   %eax,%eax
  80132f:	78 0e                	js     80133f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801331:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801334:	8b 55 0c             	mov    0xc(%ebp),%edx
  801337:	89 50 04             	mov    %edx,0x4(%eax)
  80133a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80133f:	c9                   	leave  
  801340:	c3                   	ret    

00801341 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801341:	55                   	push   %ebp
  801342:	89 e5                	mov    %esp,%ebp
  801344:	56                   	push   %esi
  801345:	53                   	push   %ebx
  801346:	83 ec 10             	sub    $0x10,%esp
  801349:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80134c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80134f:	b8 04 60 80 00       	mov    $0x806004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801354:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801359:	be ac 2e 80 00       	mov    $0x802eac,%esi
		if (devtab[i]->dev_id == dev_id) {
  80135e:	39 08                	cmp    %ecx,(%eax)
  801360:	75 10                	jne    801372 <dev_lookup+0x31>
  801362:	eb 04                	jmp    801368 <dev_lookup+0x27>
  801364:	39 08                	cmp    %ecx,(%eax)
  801366:	75 0a                	jne    801372 <dev_lookup+0x31>
			*dev = devtab[i];
  801368:	89 03                	mov    %eax,(%ebx)
  80136a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80136f:	90                   	nop
  801370:	eb 31                	jmp    8013a3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801372:	83 c2 01             	add    $0x1,%edx
  801375:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801378:	85 c0                	test   %eax,%eax
  80137a:	75 e8                	jne    801364 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80137c:	a1 74 60 80 00       	mov    0x806074,%eax
  801381:	8b 40 4c             	mov    0x4c(%eax),%eax
  801384:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801388:	89 44 24 04          	mov    %eax,0x4(%esp)
  80138c:	c7 04 24 2c 2e 80 00 	movl   $0x802e2c,(%esp)
  801393:	e8 31 ef ff ff       	call   8002c9 <cprintf>
	*dev = 0;
  801398:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80139e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8013a3:	83 c4 10             	add    $0x10,%esp
  8013a6:	5b                   	pop    %ebx
  8013a7:	5e                   	pop    %esi
  8013a8:	5d                   	pop    %ebp
  8013a9:	c3                   	ret    

008013aa <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	53                   	push   %ebx
  8013ae:	83 ec 24             	sub    $0x24,%esp
  8013b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	89 04 24             	mov    %eax,(%esp)
  8013c1:	e8 07 ff ff ff       	call   8012cd <fd_lookup>
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	78 53                	js     80141d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d4:	8b 00                	mov    (%eax),%eax
  8013d6:	89 04 24             	mov    %eax,(%esp)
  8013d9:	e8 63 ff ff ff       	call   801341 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013de:	85 c0                	test   %eax,%eax
  8013e0:	78 3b                	js     80141d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8013e2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ea:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8013ee:	74 2d                	je     80141d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013f0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013f3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013fa:	00 00 00 
	stat->st_isdir = 0;
  8013fd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801404:	00 00 00 
	stat->st_dev = dev;
  801407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80140a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801410:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801414:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801417:	89 14 24             	mov    %edx,(%esp)
  80141a:	ff 50 14             	call   *0x14(%eax)
}
  80141d:	83 c4 24             	add    $0x24,%esp
  801420:	5b                   	pop    %ebx
  801421:	5d                   	pop    %ebp
  801422:	c3                   	ret    

00801423 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801423:	55                   	push   %ebp
  801424:	89 e5                	mov    %esp,%ebp
  801426:	53                   	push   %ebx
  801427:	83 ec 24             	sub    $0x24,%esp
  80142a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80142d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801430:	89 44 24 04          	mov    %eax,0x4(%esp)
  801434:	89 1c 24             	mov    %ebx,(%esp)
  801437:	e8 91 fe ff ff       	call   8012cd <fd_lookup>
  80143c:	85 c0                	test   %eax,%eax
  80143e:	78 5f                	js     80149f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801440:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801443:	89 44 24 04          	mov    %eax,0x4(%esp)
  801447:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144a:	8b 00                	mov    (%eax),%eax
  80144c:	89 04 24             	mov    %eax,(%esp)
  80144f:	e8 ed fe ff ff       	call   801341 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801454:	85 c0                	test   %eax,%eax
  801456:	78 47                	js     80149f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801458:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80145b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80145f:	75 23                	jne    801484 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801461:	a1 74 60 80 00       	mov    0x806074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801466:	8b 40 4c             	mov    0x4c(%eax),%eax
  801469:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80146d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801471:	c7 04 24 4c 2e 80 00 	movl   $0x802e4c,(%esp)
  801478:	e8 4c ee ff ff       	call   8002c9 <cprintf>
  80147d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801482:	eb 1b                	jmp    80149f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801487:	8b 48 18             	mov    0x18(%eax),%ecx
  80148a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80148f:	85 c9                	test   %ecx,%ecx
  801491:	74 0c                	je     80149f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801493:	8b 45 0c             	mov    0xc(%ebp),%eax
  801496:	89 44 24 04          	mov    %eax,0x4(%esp)
  80149a:	89 14 24             	mov    %edx,(%esp)
  80149d:	ff d1                	call   *%ecx
}
  80149f:	83 c4 24             	add    $0x24,%esp
  8014a2:	5b                   	pop    %ebx
  8014a3:	5d                   	pop    %ebp
  8014a4:	c3                   	ret    

008014a5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8014a5:	55                   	push   %ebp
  8014a6:	89 e5                	mov    %esp,%ebp
  8014a8:	53                   	push   %ebx
  8014a9:	83 ec 24             	sub    $0x24,%esp
  8014ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b6:	89 1c 24             	mov    %ebx,(%esp)
  8014b9:	e8 0f fe ff ff       	call   8012cd <fd_lookup>
  8014be:	85 c0                	test   %eax,%eax
  8014c0:	78 66                	js     801528 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014cc:	8b 00                	mov    (%eax),%eax
  8014ce:	89 04 24             	mov    %eax,(%esp)
  8014d1:	e8 6b fe ff ff       	call   801341 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	78 4e                	js     801528 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014dd:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8014e1:	75 23                	jne    801506 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8014e3:	a1 74 60 80 00       	mov    0x806074,%eax
  8014e8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8014eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f3:	c7 04 24 70 2e 80 00 	movl   $0x802e70,(%esp)
  8014fa:	e8 ca ed ff ff       	call   8002c9 <cprintf>
  8014ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801504:	eb 22                	jmp    801528 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801509:	8b 48 0c             	mov    0xc(%eax),%ecx
  80150c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801511:	85 c9                	test   %ecx,%ecx
  801513:	74 13                	je     801528 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801515:	8b 45 10             	mov    0x10(%ebp),%eax
  801518:	89 44 24 08          	mov    %eax,0x8(%esp)
  80151c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801523:	89 14 24             	mov    %edx,(%esp)
  801526:	ff d1                	call   *%ecx
}
  801528:	83 c4 24             	add    $0x24,%esp
  80152b:	5b                   	pop    %ebx
  80152c:	5d                   	pop    %ebp
  80152d:	c3                   	ret    

0080152e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	53                   	push   %ebx
  801532:	83 ec 24             	sub    $0x24,%esp
  801535:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801538:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80153b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80153f:	89 1c 24             	mov    %ebx,(%esp)
  801542:	e8 86 fd ff ff       	call   8012cd <fd_lookup>
  801547:	85 c0                	test   %eax,%eax
  801549:	78 6b                	js     8015b6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80154b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80154e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801555:	8b 00                	mov    (%eax),%eax
  801557:	89 04 24             	mov    %eax,(%esp)
  80155a:	e8 e2 fd ff ff       	call   801341 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80155f:	85 c0                	test   %eax,%eax
  801561:	78 53                	js     8015b6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801563:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801566:	8b 42 08             	mov    0x8(%edx),%eax
  801569:	83 e0 03             	and    $0x3,%eax
  80156c:	83 f8 01             	cmp    $0x1,%eax
  80156f:	75 23                	jne    801594 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801571:	a1 74 60 80 00       	mov    0x806074,%eax
  801576:	8b 40 4c             	mov    0x4c(%eax),%eax
  801579:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80157d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801581:	c7 04 24 8d 2e 80 00 	movl   $0x802e8d,(%esp)
  801588:	e8 3c ed ff ff       	call   8002c9 <cprintf>
  80158d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801592:	eb 22                	jmp    8015b6 <read+0x88>
	}
	if (!dev->dev_read)
  801594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801597:	8b 48 08             	mov    0x8(%eax),%ecx
  80159a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80159f:	85 c9                	test   %ecx,%ecx
  8015a1:	74 13                	je     8015b6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015b1:	89 14 24             	mov    %edx,(%esp)
  8015b4:	ff d1                	call   *%ecx
}
  8015b6:	83 c4 24             	add    $0x24,%esp
  8015b9:	5b                   	pop    %ebx
  8015ba:	5d                   	pop    %ebp
  8015bb:	c3                   	ret    

008015bc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	57                   	push   %edi
  8015c0:	56                   	push   %esi
  8015c1:	53                   	push   %ebx
  8015c2:	83 ec 1c             	sub    $0x1c,%esp
  8015c5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015c8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8015da:	85 f6                	test   %esi,%esi
  8015dc:	74 29                	je     801607 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015de:	89 f0                	mov    %esi,%eax
  8015e0:	29 d0                	sub    %edx,%eax
  8015e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015e6:	03 55 0c             	add    0xc(%ebp),%edx
  8015e9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015ed:	89 3c 24             	mov    %edi,(%esp)
  8015f0:	e8 39 ff ff ff       	call   80152e <read>
		if (m < 0)
  8015f5:	85 c0                	test   %eax,%eax
  8015f7:	78 0e                	js     801607 <readn+0x4b>
			return m;
		if (m == 0)
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	74 08                	je     801605 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015fd:	01 c3                	add    %eax,%ebx
  8015ff:	89 da                	mov    %ebx,%edx
  801601:	39 f3                	cmp    %esi,%ebx
  801603:	72 d9                	jb     8015de <readn+0x22>
  801605:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801607:	83 c4 1c             	add    $0x1c,%esp
  80160a:	5b                   	pop    %ebx
  80160b:	5e                   	pop    %esi
  80160c:	5f                   	pop    %edi
  80160d:	5d                   	pop    %ebp
  80160e:	c3                   	ret    

0080160f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
  801612:	56                   	push   %esi
  801613:	53                   	push   %ebx
  801614:	83 ec 20             	sub    $0x20,%esp
  801617:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80161a:	89 34 24             	mov    %esi,(%esp)
  80161d:	e8 0e fc ff ff       	call   801230 <fd2num>
  801622:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801625:	89 54 24 04          	mov    %edx,0x4(%esp)
  801629:	89 04 24             	mov    %eax,(%esp)
  80162c:	e8 9c fc ff ff       	call   8012cd <fd_lookup>
  801631:	89 c3                	mov    %eax,%ebx
  801633:	85 c0                	test   %eax,%eax
  801635:	78 05                	js     80163c <fd_close+0x2d>
  801637:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80163a:	74 0c                	je     801648 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80163c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801640:	19 c0                	sbb    %eax,%eax
  801642:	f7 d0                	not    %eax
  801644:	21 c3                	and    %eax,%ebx
  801646:	eb 3d                	jmp    801685 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801648:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80164b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80164f:	8b 06                	mov    (%esi),%eax
  801651:	89 04 24             	mov    %eax,(%esp)
  801654:	e8 e8 fc ff ff       	call   801341 <dev_lookup>
  801659:	89 c3                	mov    %eax,%ebx
  80165b:	85 c0                	test   %eax,%eax
  80165d:	78 16                	js     801675 <fd_close+0x66>
		if (dev->dev_close)
  80165f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801662:	8b 40 10             	mov    0x10(%eax),%eax
  801665:	bb 00 00 00 00       	mov    $0x0,%ebx
  80166a:	85 c0                	test   %eax,%eax
  80166c:	74 07                	je     801675 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80166e:	89 34 24             	mov    %esi,(%esp)
  801671:	ff d0                	call   *%eax
  801673:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801675:	89 74 24 04          	mov    %esi,0x4(%esp)
  801679:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801680:	e8 c5 f9 ff ff       	call   80104a <sys_page_unmap>
	return r;
}
  801685:	89 d8                	mov    %ebx,%eax
  801687:	83 c4 20             	add    $0x20,%esp
  80168a:	5b                   	pop    %ebx
  80168b:	5e                   	pop    %esi
  80168c:	5d                   	pop    %ebp
  80168d:	c3                   	ret    

0080168e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801694:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801697:	89 44 24 04          	mov    %eax,0x4(%esp)
  80169b:	8b 45 08             	mov    0x8(%ebp),%eax
  80169e:	89 04 24             	mov    %eax,(%esp)
  8016a1:	e8 27 fc ff ff       	call   8012cd <fd_lookup>
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	78 13                	js     8016bd <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8016aa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016b1:	00 
  8016b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b5:	89 04 24             	mov    %eax,(%esp)
  8016b8:	e8 52 ff ff ff       	call   80160f <fd_close>
}
  8016bd:	c9                   	leave  
  8016be:	c3                   	ret    

008016bf <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8016bf:	55                   	push   %ebp
  8016c0:	89 e5                	mov    %esp,%ebp
  8016c2:	83 ec 18             	sub    $0x18,%esp
  8016c5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8016c8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8016d2:	00 
  8016d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d6:	89 04 24             	mov    %eax,(%esp)
  8016d9:	e8 a9 03 00 00       	call   801a87 <open>
  8016de:	89 c3                	mov    %eax,%ebx
  8016e0:	85 c0                	test   %eax,%eax
  8016e2:	78 1b                	js     8016ff <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8016e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016eb:	89 1c 24             	mov    %ebx,(%esp)
  8016ee:	e8 b7 fc ff ff       	call   8013aa <fstat>
  8016f3:	89 c6                	mov    %eax,%esi
	close(fd);
  8016f5:	89 1c 24             	mov    %ebx,(%esp)
  8016f8:	e8 91 ff ff ff       	call   80168e <close>
  8016fd:	89 f3                	mov    %esi,%ebx
	return r;
}
  8016ff:	89 d8                	mov    %ebx,%eax
  801701:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801704:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801707:	89 ec                	mov    %ebp,%esp
  801709:	5d                   	pop    %ebp
  80170a:	c3                   	ret    

0080170b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80170b:	55                   	push   %ebp
  80170c:	89 e5                	mov    %esp,%ebp
  80170e:	53                   	push   %ebx
  80170f:	83 ec 14             	sub    $0x14,%esp
  801712:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801717:	89 1c 24             	mov    %ebx,(%esp)
  80171a:	e8 6f ff ff ff       	call   80168e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80171f:	83 c3 01             	add    $0x1,%ebx
  801722:	83 fb 20             	cmp    $0x20,%ebx
  801725:	75 f0                	jne    801717 <close_all+0xc>
		close(i);
}
  801727:	83 c4 14             	add    $0x14,%esp
  80172a:	5b                   	pop    %ebx
  80172b:	5d                   	pop    %ebp
  80172c:	c3                   	ret    

0080172d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80172d:	55                   	push   %ebp
  80172e:	89 e5                	mov    %esp,%ebp
  801730:	83 ec 58             	sub    $0x58,%esp
  801733:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801736:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801739:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80173c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80173f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801742:	89 44 24 04          	mov    %eax,0x4(%esp)
  801746:	8b 45 08             	mov    0x8(%ebp),%eax
  801749:	89 04 24             	mov    %eax,(%esp)
  80174c:	e8 7c fb ff ff       	call   8012cd <fd_lookup>
  801751:	89 c3                	mov    %eax,%ebx
  801753:	85 c0                	test   %eax,%eax
  801755:	0f 88 e0 00 00 00    	js     80183b <dup+0x10e>
		return r;
	close(newfdnum);
  80175b:	89 3c 24             	mov    %edi,(%esp)
  80175e:	e8 2b ff ff ff       	call   80168e <close>

	newfd = INDEX2FD(newfdnum);
  801763:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801769:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80176c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80176f:	89 04 24             	mov    %eax,(%esp)
  801772:	e8 c9 fa ff ff       	call   801240 <fd2data>
  801777:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801779:	89 34 24             	mov    %esi,(%esp)
  80177c:	e8 bf fa ff ff       	call   801240 <fd2data>
  801781:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801784:	89 da                	mov    %ebx,%edx
  801786:	89 d8                	mov    %ebx,%eax
  801788:	c1 e8 16             	shr    $0x16,%eax
  80178b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801792:	a8 01                	test   $0x1,%al
  801794:	74 43                	je     8017d9 <dup+0xac>
  801796:	c1 ea 0c             	shr    $0xc,%edx
  801799:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8017a0:	a8 01                	test   $0x1,%al
  8017a2:	74 35                	je     8017d9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  8017a4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8017ab:	25 07 0e 00 00       	and    $0xe07,%eax
  8017b0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8017b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017c2:	00 
  8017c3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017ce:	e8 d5 f8 ff ff       	call   8010a8 <sys_page_map>
  8017d3:	89 c3                	mov    %eax,%ebx
  8017d5:	85 c0                	test   %eax,%eax
  8017d7:	78 3f                	js     801818 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  8017d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017dc:	89 c2                	mov    %eax,%edx
  8017de:	c1 ea 0c             	shr    $0xc,%edx
  8017e1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017e8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017ee:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017f2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8017f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017fd:	00 
  8017fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801802:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801809:	e8 9a f8 ff ff       	call   8010a8 <sys_page_map>
  80180e:	89 c3                	mov    %eax,%ebx
  801810:	85 c0                	test   %eax,%eax
  801812:	78 04                	js     801818 <dup+0xeb>
  801814:	89 fb                	mov    %edi,%ebx
  801816:	eb 23                	jmp    80183b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801818:	89 74 24 04          	mov    %esi,0x4(%esp)
  80181c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801823:	e8 22 f8 ff ff       	call   80104a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801828:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80182b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801836:	e8 0f f8 ff ff       	call   80104a <sys_page_unmap>
	return r;
}
  80183b:	89 d8                	mov    %ebx,%eax
  80183d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801840:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801843:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801846:	89 ec                	mov    %ebp,%esp
  801848:	5d                   	pop    %ebp
  801849:	c3                   	ret    
	...

0080184c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	53                   	push   %ebx
  801850:	83 ec 14             	sub    $0x14,%esp
  801853:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801855:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80185b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801862:	00 
  801863:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  80186a:	00 
  80186b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186f:	89 14 24             	mov    %edx,(%esp)
  801872:	e8 89 0e 00 00       	call   802700 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801877:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80187e:	00 
  80187f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801883:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80188a:	e8 d3 0e 00 00       	call   802762 <ipc_recv>
}
  80188f:	83 c4 14             	add    $0x14,%esp
  801892:	5b                   	pop    %ebx
  801893:	5d                   	pop    %ebp
  801894:	c3                   	ret    

00801895 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a1:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  8018a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a9:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b3:	b8 02 00 00 00       	mov    $0x2,%eax
  8018b8:	e8 8f ff ff ff       	call   80184c <fsipc>
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018c5:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ca:	b8 08 00 00 00       	mov    $0x8,%eax
  8018cf:	e8 78 ff ff ff       	call   80184c <fsipc>
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	53                   	push   %ebx
  8018da:	83 ec 14             	sub    $0x14,%esp
  8018dd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8018e6:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f0:	b8 05 00 00 00       	mov    $0x5,%eax
  8018f5:	e8 52 ff ff ff       	call   80184c <fsipc>
  8018fa:	85 c0                	test   %eax,%eax
  8018fc:	78 2b                	js     801929 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018fe:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801905:	00 
  801906:	89 1c 24             	mov    %ebx,(%esp)
  801909:	e8 9c f0 ff ff       	call   8009aa <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80190e:	a1 80 30 80 00       	mov    0x803080,%eax
  801913:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801919:	a1 84 30 80 00       	mov    0x803084,%eax
  80191e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801924:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801929:	83 c4 14             	add    $0x14,%esp
  80192c:	5b                   	pop    %ebx
  80192d:	5d                   	pop    %ebp
  80192e:	c3                   	ret    

0080192f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
  801932:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  801935:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80193c:	00 
  80193d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801944:	00 
  801945:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  80194c:	e8 b5 f1 ff ff       	call   800b06 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801951:	8b 45 08             	mov    0x8(%ebp),%eax
  801954:	8b 40 0c             	mov    0xc(%eax),%eax
  801957:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  80195c:	ba 00 00 00 00       	mov    $0x0,%edx
  801961:	b8 06 00 00 00       	mov    $0x6,%eax
  801966:	e8 e1 fe ff ff       	call   80184c <fsipc>
}
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801973:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80197a:	00 
  80197b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801982:	00 
  801983:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  80198a:	e8 77 f1 ff ff       	call   800b06 <memset>
  80198f:	8b 45 10             	mov    0x10(%ebp),%eax
  801992:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801997:	76 05                	jbe    80199e <devfile_write+0x31>
  801999:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80199e:	8b 55 08             	mov    0x8(%ebp),%edx
  8019a1:	8b 52 0c             	mov    0xc(%edx),%edx
  8019a4:	89 15 00 30 80 00    	mov    %edx,0x803000
        fsipcbuf.write.req_n = numberOfBytes;
  8019aa:	a3 04 30 80 00       	mov    %eax,0x803004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  8019af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ba:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  8019c1:	e8 9f f1 ff ff       	call   800b65 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  8019c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8019cb:	b8 04 00 00 00       	mov    $0x4,%eax
  8019d0:	e8 77 fe ff ff       	call   80184c <fsipc>
              return r;
        return r;
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
  8019da:	53                   	push   %ebx
  8019db:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  8019de:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8019e5:	00 
  8019e6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019ed:	00 
  8019ee:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  8019f5:	e8 0c f1 ff ff       	call   800b06 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	8b 40 0c             	mov    0xc(%eax),%eax
  801a00:	a3 00 30 80 00       	mov    %eax,0x803000
        fsipcbuf.read.req_n = n;
  801a05:	8b 45 10             	mov    0x10(%ebp),%eax
  801a08:	a3 04 30 80 00       	mov    %eax,0x803004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  801a0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801a12:	b8 03 00 00 00       	mov    $0x3,%eax
  801a17:	e8 30 fe ff ff       	call   80184c <fsipc>
  801a1c:	89 c3                	mov    %eax,%ebx
  801a1e:	85 c0                	test   %eax,%eax
  801a20:	78 17                	js     801a39 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  801a22:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a26:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801a2d:	00 
  801a2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a31:	89 04 24             	mov    %eax,(%esp)
  801a34:	e8 2c f1 ff ff       	call   800b65 <memmove>
        return r;
}
  801a39:	89 d8                	mov    %ebx,%eax
  801a3b:	83 c4 14             	add    $0x14,%esp
  801a3e:	5b                   	pop    %ebx
  801a3f:	5d                   	pop    %ebp
  801a40:	c3                   	ret    

00801a41 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
  801a44:	53                   	push   %ebx
  801a45:	83 ec 14             	sub    $0x14,%esp
  801a48:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801a4b:	89 1c 24             	mov    %ebx,(%esp)
  801a4e:	e8 0d ef ff ff       	call   800960 <strlen>
  801a53:	89 c2                	mov    %eax,%edx
  801a55:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801a5a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801a60:	7f 1f                	jg     801a81 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801a62:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a66:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801a6d:	e8 38 ef ff ff       	call   8009aa <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801a72:	ba 00 00 00 00       	mov    $0x0,%edx
  801a77:	b8 07 00 00 00       	mov    $0x7,%eax
  801a7c:	e8 cb fd ff ff       	call   80184c <fsipc>
}
  801a81:	83 c4 14             	add    $0x14,%esp
  801a84:	5b                   	pop    %ebx
  801a85:	5d                   	pop    %ebp
  801a86:	c3                   	ret    

00801a87 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	56                   	push   %esi
  801a8b:	53                   	push   %ebx
  801a8c:	83 ec 20             	sub    $0x20,%esp
  801a8f:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  801a92:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801a99:	00 
  801a9a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801aa1:	00 
  801aa2:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801aa9:	e8 58 f0 ff ff       	call   800b06 <memset>
    if(strlen(path)>=MAXPATHLEN)
  801aae:	89 34 24             	mov    %esi,(%esp)
  801ab1:	e8 aa ee ff ff       	call   800960 <strlen>
  801ab6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801abb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ac0:	0f 8f 84 00 00 00    	jg     801b4a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  801ac6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ac9:	89 04 24             	mov    %eax,(%esp)
  801acc:	e8 8a f7 ff ff       	call   80125b <fd_alloc>
  801ad1:	89 c3                	mov    %eax,%ebx
  801ad3:	85 c0                	test   %eax,%eax
  801ad5:	78 73                	js     801b4a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  801ad7:	0f b6 06             	movzbl (%esi),%eax
  801ada:	84 c0                	test   %al,%al
  801adc:	74 20                	je     801afe <open+0x77>
  801ade:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  801ae0:	0f be c0             	movsbl %al,%eax
  801ae3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae7:	c7 04 24 c0 2e 80 00 	movl   $0x802ec0,(%esp)
  801aee:	e8 d6 e7 ff ff       	call   8002c9 <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  801af3:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  801af7:	83 c3 01             	add    $0x1,%ebx
  801afa:	84 c0                	test   %al,%al
  801afc:	75 e2                	jne    801ae0 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  801afe:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b02:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801b09:	e8 9c ee ff ff       	call   8009aa <strcpy>
    fsipcbuf.open.req_omode = mode;
  801b0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b11:	a3 00 34 80 00       	mov    %eax,0x803400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  801b16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b19:	b8 01 00 00 00       	mov    $0x1,%eax
  801b1e:	e8 29 fd ff ff       	call   80184c <fsipc>
  801b23:	89 c3                	mov    %eax,%ebx
  801b25:	85 c0                	test   %eax,%eax
  801b27:	79 15                	jns    801b3e <open+0xb7>
        {
            fd_close(fd,1);
  801b29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801b30:	00 
  801b31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b34:	89 04 24             	mov    %eax,(%esp)
  801b37:	e8 d3 fa ff ff       	call   80160f <fd_close>
             return r;
  801b3c:	eb 0c                	jmp    801b4a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  801b3e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b41:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  801b47:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  801b4a:	89 d8                	mov    %ebx,%eax
  801b4c:	83 c4 20             	add    $0x20,%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5e                   	pop    %esi
  801b51:	5d                   	pop    %ebp
  801b52:	c3                   	ret    
	...

00801b54 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	53                   	push   %ebx
  801b58:	83 ec 14             	sub    $0x14,%esp
  801b5b:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801b5d:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801b61:	7e 34                	jle    801b97 <writebuf+0x43>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801b63:	8b 40 04             	mov    0x4(%eax),%eax
  801b66:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b6a:	8d 43 10             	lea    0x10(%ebx),%eax
  801b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b71:	8b 03                	mov    (%ebx),%eax
  801b73:	89 04 24             	mov    %eax,(%esp)
  801b76:	e8 2a f9 ff ff       	call   8014a5 <write>
		if (result > 0)
  801b7b:	85 c0                	test   %eax,%eax
  801b7d:	7e 03                	jle    801b82 <writebuf+0x2e>
			b->result += result;
  801b7f:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801b82:	3b 43 04             	cmp    0x4(%ebx),%eax
  801b85:	74 10                	je     801b97 <writebuf+0x43>
			b->error = (result < 0 ? result : 0);
  801b87:	85 c0                	test   %eax,%eax
  801b89:	0f 9f c2             	setg   %dl
  801b8c:	0f b6 d2             	movzbl %dl,%edx
  801b8f:	83 ea 01             	sub    $0x1,%edx
  801b92:	21 d0                	and    %edx,%eax
  801b94:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801b97:	83 c4 14             	add    $0x14,%esp
  801b9a:	5b                   	pop    %ebx
  801b9b:	5d                   	pop    %ebp
  801b9c:	c3                   	ret    

00801b9d <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
  801ba0:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba9:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801baf:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801bb6:	00 00 00 
	b.result = 0;
  801bb9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801bc0:	00 00 00 
	b.error = 1;
  801bc3:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801bca:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bdb:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801be1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be5:	c7 04 24 5a 1c 80 00 	movl   $0x801c5a,(%esp)
  801bec:	e8 8c e8 ff ff       	call   80047d <vprintfmt>
	if (b.idx > 0)
  801bf1:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801bf8:	7e 0b                	jle    801c05 <vfprintf+0x68>
		writebuf(&b);
  801bfa:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801c00:	e8 4f ff ff ff       	call   801b54 <writebuf>

	return (b.result ? b.result : b.error);
  801c05:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801c0b:	85 c0                	test   %eax,%eax
  801c0d:	75 06                	jne    801c15 <vfprintf+0x78>
  801c0f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  801c1d:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  801c20:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c24:	8b 45 08             	mov    0x8(%ebp),%eax
  801c27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c2b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801c32:	e8 66 ff ff ff       	call   801b9d <vfprintf>
	va_end(ap);

	return cnt;
}
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  801c3f:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  801c42:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c50:	89 04 24             	mov    %eax,(%esp)
  801c53:	e8 45 ff ff ff       	call   801b9d <vfprintf>
	va_end(ap);

	return cnt;
}
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
  801c5d:	53                   	push   %ebx
  801c5e:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  801c61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801c64:	8b 43 04             	mov    0x4(%ebx),%eax
  801c67:	8b 55 08             	mov    0x8(%ebp),%edx
  801c6a:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801c6e:	83 c0 01             	add    $0x1,%eax
  801c71:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801c74:	3d 00 01 00 00       	cmp    $0x100,%eax
  801c79:	75 0e                	jne    801c89 <putch+0x2f>
		writebuf(b);
  801c7b:	89 d8                	mov    %ebx,%eax
  801c7d:	e8 d2 fe ff ff       	call   801b54 <writebuf>
		b->idx = 0;
  801c82:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801c89:	83 c4 04             	add    $0x4,%esp
  801c8c:	5b                   	pop    %ebx
  801c8d:	5d                   	pop    %ebp
  801c8e:	c3                   	ret    
	...

00801c90 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801c90:	55                   	push   %ebp
  801c91:	89 e5                	mov    %esp,%ebp
  801c93:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801c96:	c7 44 24 04 c3 2e 80 	movl   $0x802ec3,0x4(%esp)
  801c9d:	00 
  801c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca1:	89 04 24             	mov    %eax,(%esp)
  801ca4:	e8 01 ed ff ff       	call   8009aa <strcpy>
	return 0;
}
  801ca9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cae:	c9                   	leave  
  801caf:	c3                   	ret    

00801cb0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801cb0:	55                   	push   %ebp
  801cb1:	89 e5                	mov    %esp,%ebp
  801cb3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb9:	8b 40 0c             	mov    0xc(%eax),%eax
  801cbc:	89 04 24             	mov    %eax,(%esp)
  801cbf:	e8 9e 02 00 00       	call   801f62 <nsipc_close>
}
  801cc4:	c9                   	leave  
  801cc5:	c3                   	ret    

00801cc6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801cc6:	55                   	push   %ebp
  801cc7:	89 e5                	mov    %esp,%ebp
  801cc9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ccc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cd3:	00 
  801cd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801cd7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cde:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ce8:	89 04 24             	mov    %eax,(%esp)
  801ceb:	e8 ae 02 00 00       	call   801f9e <nsipc_send>
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
  801cf5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801cf8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801cff:	00 
  801d00:	8b 45 10             	mov    0x10(%ebp),%eax
  801d03:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	8b 40 0c             	mov    0xc(%eax),%eax
  801d14:	89 04 24             	mov    %eax,(%esp)
  801d17:	e8 f5 02 00 00       	call   802011 <nsipc_recv>
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
  801d21:	56                   	push   %esi
  801d22:	53                   	push   %ebx
  801d23:	83 ec 20             	sub    $0x20,%esp
  801d26:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d2b:	89 04 24             	mov    %eax,(%esp)
  801d2e:	e8 28 f5 ff ff       	call   80125b <fd_alloc>
  801d33:	89 c3                	mov    %eax,%ebx
  801d35:	85 c0                	test   %eax,%eax
  801d37:	78 21                	js     801d5a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801d39:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801d40:	00 
  801d41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d4f:	e8 b2 f3 ff ff       	call   801106 <sys_page_alloc>
  801d54:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801d56:	85 c0                	test   %eax,%eax
  801d58:	79 0a                	jns    801d64 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801d5a:	89 34 24             	mov    %esi,(%esp)
  801d5d:	e8 00 02 00 00       	call   801f62 <nsipc_close>
		return r;
  801d62:	eb 28                	jmp    801d8c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801d64:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d72:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d82:	89 04 24             	mov    %eax,(%esp)
  801d85:	e8 a6 f4 ff ff       	call   801230 <fd2num>
  801d8a:	89 c3                	mov    %eax,%ebx
}
  801d8c:	89 d8                	mov    %ebx,%eax
  801d8e:	83 c4 20             	add    $0x20,%esp
  801d91:	5b                   	pop    %ebx
  801d92:	5e                   	pop    %esi
  801d93:	5d                   	pop    %ebp
  801d94:	c3                   	ret    

00801d95 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801d95:	55                   	push   %ebp
  801d96:	89 e5                	mov    %esp,%ebp
  801d98:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801d9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801d9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801da2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801da5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801da9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dac:	89 04 24             	mov    %eax,(%esp)
  801daf:	e8 62 01 00 00       	call   801f16 <nsipc_socket>
  801db4:	85 c0                	test   %eax,%eax
  801db6:	78 05                	js     801dbd <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801db8:	e8 61 ff ff ff       	call   801d1e <alloc_sockfd>
}
  801dbd:	c9                   	leave  
  801dbe:	66 90                	xchg   %ax,%ax
  801dc0:	c3                   	ret    

00801dc1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801dc7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801dca:	89 54 24 04          	mov    %edx,0x4(%esp)
  801dce:	89 04 24             	mov    %eax,(%esp)
  801dd1:	e8 f7 f4 ff ff       	call   8012cd <fd_lookup>
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	78 15                	js     801def <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801dda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ddd:	8b 0a                	mov    (%edx),%ecx
  801ddf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801de4:	3b 0d 20 60 80 00    	cmp    0x806020,%ecx
  801dea:	75 03                	jne    801def <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801dec:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801def:	c9                   	leave  
  801df0:	c3                   	ret    

00801df1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801df7:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfa:	e8 c2 ff ff ff       	call   801dc1 <fd2sockid>
  801dff:	85 c0                	test   %eax,%eax
  801e01:	78 0f                	js     801e12 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801e03:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e06:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e0a:	89 04 24             	mov    %eax,(%esp)
  801e0d:	e8 2e 01 00 00       	call   801f40 <nsipc_listen>
}
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    

00801e14 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
  801e17:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e1d:	e8 9f ff ff ff       	call   801dc1 <fd2sockid>
  801e22:	85 c0                	test   %eax,%eax
  801e24:	78 16                	js     801e3c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801e26:	8b 55 10             	mov    0x10(%ebp),%edx
  801e29:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e30:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e34:	89 04 24             	mov    %eax,(%esp)
  801e37:	e8 55 02 00 00       	call   802091 <nsipc_connect>
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
  801e41:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	e8 75 ff ff ff       	call   801dc1 <fd2sockid>
  801e4c:	85 c0                	test   %eax,%eax
  801e4e:	78 0f                	js     801e5f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801e50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e53:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e57:	89 04 24             	mov    %eax,(%esp)
  801e5a:	e8 1d 01 00 00       	call   801f7c <nsipc_shutdown>
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e67:	8b 45 08             	mov    0x8(%ebp),%eax
  801e6a:	e8 52 ff ff ff       	call   801dc1 <fd2sockid>
  801e6f:	85 c0                	test   %eax,%eax
  801e71:	78 16                	js     801e89 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801e73:	8b 55 10             	mov    0x10(%ebp),%edx
  801e76:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e7d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e81:	89 04 24             	mov    %eax,(%esp)
  801e84:	e8 47 02 00 00       	call   8020d0 <nsipc_bind>
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801e91:	8b 45 08             	mov    0x8(%ebp),%eax
  801e94:	e8 28 ff ff ff       	call   801dc1 <fd2sockid>
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	78 1f                	js     801ebc <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801e9d:	8b 55 10             	mov    0x10(%ebp),%edx
  801ea0:	89 54 24 08          	mov    %edx,0x8(%esp)
  801ea4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea7:	89 54 24 04          	mov    %edx,0x4(%esp)
  801eab:	89 04 24             	mov    %eax,(%esp)
  801eae:	e8 5c 02 00 00       	call   80210f <nsipc_accept>
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	78 05                	js     801ebc <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801eb7:	e8 62 fe ff ff       	call   801d1e <alloc_sockfd>
}
  801ebc:	c9                   	leave  
  801ebd:	8d 76 00             	lea    0x0(%esi),%esi
  801ec0:	c3                   	ret    
	...

00801ed0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801ed6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  801edc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ee3:	00 
  801ee4:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801eeb:	00 
  801eec:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ef0:	89 14 24             	mov    %edx,(%esp)
  801ef3:	e8 08 08 00 00       	call   802700 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801ef8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801eff:	00 
  801f00:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f07:	00 
  801f08:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f0f:	e8 4e 08 00 00       	call   802762 <ipc_recv>
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
  801f19:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801f24:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f27:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  801f2c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801f34:	b8 09 00 00 00       	mov    $0x9,%eax
  801f39:	e8 92 ff ff ff       	call   801ed0 <nsipc>
}
  801f3e:	c9                   	leave  
  801f3f:	c3                   	ret    

00801f40 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801f46:	8b 45 08             	mov    0x8(%ebp),%eax
  801f49:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  801f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f51:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801f56:	b8 06 00 00 00       	mov    $0x6,%eax
  801f5b:	e8 70 ff ff ff       	call   801ed0 <nsipc>
}
  801f60:	c9                   	leave  
  801f61:	c3                   	ret    

00801f62 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801f68:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801f70:	b8 04 00 00 00       	mov    $0x4,%eax
  801f75:	e8 56 ff ff ff       	call   801ed0 <nsipc>
}
  801f7a:	c9                   	leave  
  801f7b:	c3                   	ret    

00801f7c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801f7c:	55                   	push   %ebp
  801f7d:	89 e5                	mov    %esp,%ebp
  801f7f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801f82:	8b 45 08             	mov    0x8(%ebp),%eax
  801f85:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  801f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f8d:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801f92:	b8 03 00 00 00       	mov    $0x3,%eax
  801f97:	e8 34 ff ff ff       	call   801ed0 <nsipc>
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	53                   	push   %ebx
  801fa2:	83 ec 14             	sub    $0x14,%esp
  801fa5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801fa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fab:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  801fb0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801fb6:	7e 24                	jle    801fdc <nsipc_send+0x3e>
  801fb8:	c7 44 24 0c cf 2e 80 	movl   $0x802ecf,0xc(%esp)
  801fbf:	00 
  801fc0:	c7 44 24 08 db 2e 80 	movl   $0x802edb,0x8(%esp)
  801fc7:	00 
  801fc8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801fcf:	00 
  801fd0:	c7 04 24 f0 2e 80 00 	movl   $0x802ef0,(%esp)
  801fd7:	e8 28 e2 ff ff       	call   800204 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801fdc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801fe0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fe3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe7:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  801fee:	e8 72 eb ff ff       	call   800b65 <memmove>
	nsipcbuf.send.req_size = size;
  801ff3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  801ff9:	8b 45 14             	mov    0x14(%ebp),%eax
  801ffc:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  802001:	b8 08 00 00 00       	mov    $0x8,%eax
  802006:	e8 c5 fe ff ff       	call   801ed0 <nsipc>
}
  80200b:	83 c4 14             	add    $0x14,%esp
  80200e:	5b                   	pop    %ebx
  80200f:	5d                   	pop    %ebp
  802010:	c3                   	ret    

00802011 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	56                   	push   %esi
  802015:	53                   	push   %ebx
  802016:	83 ec 10             	sub    $0x10,%esp
  802019:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80201c:	8b 45 08             	mov    0x8(%ebp),%eax
  80201f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  802024:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  80202a:	8b 45 14             	mov    0x14(%ebp),%eax
  80202d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802032:	b8 07 00 00 00       	mov    $0x7,%eax
  802037:	e8 94 fe ff ff       	call   801ed0 <nsipc>
  80203c:	89 c3                	mov    %eax,%ebx
  80203e:	85 c0                	test   %eax,%eax
  802040:	78 46                	js     802088 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802042:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802047:	7f 04                	jg     80204d <nsipc_recv+0x3c>
  802049:	39 c6                	cmp    %eax,%esi
  80204b:	7d 24                	jge    802071 <nsipc_recv+0x60>
  80204d:	c7 44 24 0c fc 2e 80 	movl   $0x802efc,0xc(%esp)
  802054:	00 
  802055:	c7 44 24 08 db 2e 80 	movl   $0x802edb,0x8(%esp)
  80205c:	00 
  80205d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802064:	00 
  802065:	c7 04 24 f0 2e 80 00 	movl   $0x802ef0,(%esp)
  80206c:	e8 93 e1 ff ff       	call   800204 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802071:	89 44 24 08          	mov    %eax,0x8(%esp)
  802075:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80207c:	00 
  80207d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802080:	89 04 24             	mov    %eax,(%esp)
  802083:	e8 dd ea ff ff       	call   800b65 <memmove>
	}

	return r;
}
  802088:	89 d8                	mov    %ebx,%eax
  80208a:	83 c4 10             	add    $0x10,%esp
  80208d:	5b                   	pop    %ebx
  80208e:	5e                   	pop    %esi
  80208f:	5d                   	pop    %ebp
  802090:	c3                   	ret    

00802091 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802091:	55                   	push   %ebp
  802092:	89 e5                	mov    %esp,%ebp
  802094:	53                   	push   %ebx
  802095:	83 ec 14             	sub    $0x14,%esp
  802098:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80209b:	8b 45 08             	mov    0x8(%ebp),%eax
  80209e:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8020a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ae:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8020b5:	e8 ab ea ff ff       	call   800b65 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8020ba:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  8020c0:	b8 05 00 00 00       	mov    $0x5,%eax
  8020c5:	e8 06 fe ff ff       	call   801ed0 <nsipc>
}
  8020ca:	83 c4 14             	add    $0x14,%esp
  8020cd:	5b                   	pop    %ebx
  8020ce:	5d                   	pop    %ebp
  8020cf:	c3                   	ret    

008020d0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	53                   	push   %ebx
  8020d4:	83 ec 14             	sub    $0x14,%esp
  8020d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8020da:	8b 45 08             	mov    0x8(%ebp),%eax
  8020dd:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8020e2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8020e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ed:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8020f4:	e8 6c ea ff ff       	call   800b65 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8020f9:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  8020ff:	b8 02 00 00 00       	mov    $0x2,%eax
  802104:	e8 c7 fd ff ff       	call   801ed0 <nsipc>
}
  802109:	83 c4 14             	add    $0x14,%esp
  80210c:	5b                   	pop    %ebx
  80210d:	5d                   	pop    %ebp
  80210e:	c3                   	ret    

0080210f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 18             	sub    $0x18,%esp
  802115:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802118:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802123:	b8 01 00 00 00       	mov    $0x1,%eax
  802128:	e8 a3 fd ff ff       	call   801ed0 <nsipc>
  80212d:	89 c3                	mov    %eax,%ebx
  80212f:	85 c0                	test   %eax,%eax
  802131:	78 25                	js     802158 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802133:	be 10 50 80 00       	mov    $0x805010,%esi
  802138:	8b 06                	mov    (%esi),%eax
  80213a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80213e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  802145:	00 
  802146:	8b 45 0c             	mov    0xc(%ebp),%eax
  802149:	89 04 24             	mov    %eax,(%esp)
  80214c:	e8 14 ea ff ff       	call   800b65 <memmove>
		*addrlen = ret->ret_addrlen;
  802151:	8b 16                	mov    (%esi),%edx
  802153:	8b 45 10             	mov    0x10(%ebp),%eax
  802156:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802158:	89 d8                	mov    %ebx,%eax
  80215a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80215d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802160:	89 ec                	mov    %ebp,%esp
  802162:	5d                   	pop    %ebp
  802163:	c3                   	ret    
	...

00802170 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	83 ec 18             	sub    $0x18,%esp
  802176:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802179:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80217c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	89 04 24             	mov    %eax,(%esp)
  802185:	e8 b6 f0 ff ff       	call   801240 <fd2data>
  80218a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80218c:	c7 44 24 04 11 2f 80 	movl   $0x802f11,0x4(%esp)
  802193:	00 
  802194:	89 34 24             	mov    %esi,(%esp)
  802197:	e8 0e e8 ff ff       	call   8009aa <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80219c:	8b 43 04             	mov    0x4(%ebx),%eax
  80219f:	2b 03                	sub    (%ebx),%eax
  8021a1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8021a7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8021ae:	00 00 00 
	stat->st_dev = &devpipe;
  8021b1:	c7 86 88 00 00 00 3c 	movl   $0x80603c,0x88(%esi)
  8021b8:	60 80 00 
	return 0;
}
  8021bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8021c3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8021c6:	89 ec                	mov    %ebp,%esp
  8021c8:	5d                   	pop    %ebp
  8021c9:	c3                   	ret    

008021ca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8021ca:	55                   	push   %ebp
  8021cb:	89 e5                	mov    %esp,%ebp
  8021cd:	53                   	push   %ebx
  8021ce:	83 ec 14             	sub    $0x14,%esp
  8021d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8021d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021df:	e8 66 ee ff ff       	call   80104a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8021e4:	89 1c 24             	mov    %ebx,(%esp)
  8021e7:	e8 54 f0 ff ff       	call   801240 <fd2data>
  8021ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021f7:	e8 4e ee ff ff       	call   80104a <sys_page_unmap>
}
  8021fc:	83 c4 14             	add    $0x14,%esp
  8021ff:	5b                   	pop    %ebx
  802200:	5d                   	pop    %ebp
  802201:	c3                   	ret    

00802202 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802202:	55                   	push   %ebp
  802203:	89 e5                	mov    %esp,%ebp
  802205:	57                   	push   %edi
  802206:	56                   	push   %esi
  802207:	53                   	push   %ebx
  802208:	83 ec 2c             	sub    $0x2c,%esp
  80220b:	89 c7                	mov    %eax,%edi
  80220d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802210:	a1 74 60 80 00       	mov    0x806074,%eax
  802215:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802218:	89 3c 24             	mov    %edi,(%esp)
  80221b:	e8 a8 05 00 00       	call   8027c8 <pageref>
  802220:	89 c6                	mov    %eax,%esi
  802222:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802225:	89 04 24             	mov    %eax,(%esp)
  802228:	e8 9b 05 00 00       	call   8027c8 <pageref>
  80222d:	39 c6                	cmp    %eax,%esi
  80222f:	0f 94 c0             	sete   %al
  802232:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802235:	8b 15 74 60 80 00    	mov    0x806074,%edx
  80223b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80223e:	39 cb                	cmp    %ecx,%ebx
  802240:	75 08                	jne    80224a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802242:	83 c4 2c             	add    $0x2c,%esp
  802245:	5b                   	pop    %ebx
  802246:	5e                   	pop    %esi
  802247:	5f                   	pop    %edi
  802248:	5d                   	pop    %ebp
  802249:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80224a:	83 f8 01             	cmp    $0x1,%eax
  80224d:	75 c1                	jne    802210 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80224f:	8b 52 58             	mov    0x58(%edx),%edx
  802252:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802256:	89 54 24 08          	mov    %edx,0x8(%esp)
  80225a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80225e:	c7 04 24 18 2f 80 00 	movl   $0x802f18,(%esp)
  802265:	e8 5f e0 ff ff       	call   8002c9 <cprintf>
  80226a:	eb a4                	jmp    802210 <_pipeisclosed+0xe>

0080226c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80226c:	55                   	push   %ebp
  80226d:	89 e5                	mov    %esp,%ebp
  80226f:	57                   	push   %edi
  802270:	56                   	push   %esi
  802271:	53                   	push   %ebx
  802272:	83 ec 1c             	sub    $0x1c,%esp
  802275:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802278:	89 34 24             	mov    %esi,(%esp)
  80227b:	e8 c0 ef ff ff       	call   801240 <fd2data>
  802280:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802282:	bf 00 00 00 00       	mov    $0x0,%edi
  802287:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80228b:	75 54                	jne    8022e1 <devpipe_write+0x75>
  80228d:	eb 60                	jmp    8022ef <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80228f:	89 da                	mov    %ebx,%edx
  802291:	89 f0                	mov    %esi,%eax
  802293:	e8 6a ff ff ff       	call   802202 <_pipeisclosed>
  802298:	85 c0                	test   %eax,%eax
  80229a:	74 07                	je     8022a3 <devpipe_write+0x37>
  80229c:	b8 00 00 00 00       	mov    $0x0,%eax
  8022a1:	eb 53                	jmp    8022f6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8022a3:	90                   	nop
  8022a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8022a8:	e8 b8 ee ff ff       	call   801165 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022ad:	8b 43 04             	mov    0x4(%ebx),%eax
  8022b0:	8b 13                	mov    (%ebx),%edx
  8022b2:	83 c2 20             	add    $0x20,%edx
  8022b5:	39 d0                	cmp    %edx,%eax
  8022b7:	73 d6                	jae    80228f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8022b9:	89 c2                	mov    %eax,%edx
  8022bb:	c1 fa 1f             	sar    $0x1f,%edx
  8022be:	c1 ea 1b             	shr    $0x1b,%edx
  8022c1:	01 d0                	add    %edx,%eax
  8022c3:	83 e0 1f             	and    $0x1f,%eax
  8022c6:	29 d0                	sub    %edx,%eax
  8022c8:	89 c2                	mov    %eax,%edx
  8022ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022cd:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8022d1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8022d5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8022d9:	83 c7 01             	add    $0x1,%edi
  8022dc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8022df:	76 13                	jbe    8022f4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8022e1:	8b 43 04             	mov    0x4(%ebx),%eax
  8022e4:	8b 13                	mov    (%ebx),%edx
  8022e6:	83 c2 20             	add    $0x20,%edx
  8022e9:	39 d0                	cmp    %edx,%eax
  8022eb:	73 a2                	jae    80228f <devpipe_write+0x23>
  8022ed:	eb ca                	jmp    8022b9 <devpipe_write+0x4d>
  8022ef:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8022f4:	89 f8                	mov    %edi,%eax
}
  8022f6:	83 c4 1c             	add    $0x1c,%esp
  8022f9:	5b                   	pop    %ebx
  8022fa:	5e                   	pop    %esi
  8022fb:	5f                   	pop    %edi
  8022fc:	5d                   	pop    %ebp
  8022fd:	c3                   	ret    

008022fe <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 28             	sub    $0x28,%esp
  802304:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802307:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80230a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80230d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802310:	89 3c 24             	mov    %edi,(%esp)
  802313:	e8 28 ef ff ff       	call   801240 <fd2data>
  802318:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80231a:	be 00 00 00 00       	mov    $0x0,%esi
  80231f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802323:	75 4c                	jne    802371 <devpipe_read+0x73>
  802325:	eb 5b                	jmp    802382 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802327:	89 f0                	mov    %esi,%eax
  802329:	eb 5e                	jmp    802389 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80232b:	89 da                	mov    %ebx,%edx
  80232d:	89 f8                	mov    %edi,%eax
  80232f:	90                   	nop
  802330:	e8 cd fe ff ff       	call   802202 <_pipeisclosed>
  802335:	85 c0                	test   %eax,%eax
  802337:	74 07                	je     802340 <devpipe_read+0x42>
  802339:	b8 00 00 00 00       	mov    $0x0,%eax
  80233e:	eb 49                	jmp    802389 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802340:	e8 20 ee ff ff       	call   801165 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802345:	8b 03                	mov    (%ebx),%eax
  802347:	3b 43 04             	cmp    0x4(%ebx),%eax
  80234a:	74 df                	je     80232b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80234c:	89 c2                	mov    %eax,%edx
  80234e:	c1 fa 1f             	sar    $0x1f,%edx
  802351:	c1 ea 1b             	shr    $0x1b,%edx
  802354:	01 d0                	add    %edx,%eax
  802356:	83 e0 1f             	and    $0x1f,%eax
  802359:	29 d0                	sub    %edx,%eax
  80235b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802360:	8b 55 0c             	mov    0xc(%ebp),%edx
  802363:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802366:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802369:	83 c6 01             	add    $0x1,%esi
  80236c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80236f:	76 16                	jbe    802387 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802371:	8b 03                	mov    (%ebx),%eax
  802373:	3b 43 04             	cmp    0x4(%ebx),%eax
  802376:	75 d4                	jne    80234c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802378:	85 f6                	test   %esi,%esi
  80237a:	75 ab                	jne    802327 <devpipe_read+0x29>
  80237c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802380:	eb a9                	jmp    80232b <devpipe_read+0x2d>
  802382:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802387:	89 f0                	mov    %esi,%eax
}
  802389:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80238c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80238f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802392:	89 ec                	mov    %ebp,%esp
  802394:	5d                   	pop    %ebp
  802395:	c3                   	ret    

00802396 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802396:	55                   	push   %ebp
  802397:	89 e5                	mov    %esp,%ebp
  802399:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80239c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80239f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a6:	89 04 24             	mov    %eax,(%esp)
  8023a9:	e8 1f ef ff ff       	call   8012cd <fd_lookup>
  8023ae:	85 c0                	test   %eax,%eax
  8023b0:	78 15                	js     8023c7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8023b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b5:	89 04 24             	mov    %eax,(%esp)
  8023b8:	e8 83 ee ff ff       	call   801240 <fd2data>
	return _pipeisclosed(fd, p);
  8023bd:	89 c2                	mov    %eax,%edx
  8023bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c2:	e8 3b fe ff ff       	call   802202 <_pipeisclosed>
}
  8023c7:	c9                   	leave  
  8023c8:	c3                   	ret    

008023c9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8023c9:	55                   	push   %ebp
  8023ca:	89 e5                	mov    %esp,%ebp
  8023cc:	83 ec 48             	sub    $0x48,%esp
  8023cf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8023d2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8023d5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8023d8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8023db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8023de:	89 04 24             	mov    %eax,(%esp)
  8023e1:	e8 75 ee ff ff       	call   80125b <fd_alloc>
  8023e6:	89 c3                	mov    %eax,%ebx
  8023e8:	85 c0                	test   %eax,%eax
  8023ea:	0f 88 42 01 00 00    	js     802532 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8023f0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023f7:	00 
  8023f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8023fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802406:	e8 fb ec ff ff       	call   801106 <sys_page_alloc>
  80240b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80240d:	85 c0                	test   %eax,%eax
  80240f:	0f 88 1d 01 00 00    	js     802532 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802415:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802418:	89 04 24             	mov    %eax,(%esp)
  80241b:	e8 3b ee ff ff       	call   80125b <fd_alloc>
  802420:	89 c3                	mov    %eax,%ebx
  802422:	85 c0                	test   %eax,%eax
  802424:	0f 88 f5 00 00 00    	js     80251f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80242a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802431:	00 
  802432:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802435:	89 44 24 04          	mov    %eax,0x4(%esp)
  802439:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802440:	e8 c1 ec ff ff       	call   801106 <sys_page_alloc>
  802445:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802447:	85 c0                	test   %eax,%eax
  802449:	0f 88 d0 00 00 00    	js     80251f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80244f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802452:	89 04 24             	mov    %eax,(%esp)
  802455:	e8 e6 ed ff ff       	call   801240 <fd2data>
  80245a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80245c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802463:	00 
  802464:	89 44 24 04          	mov    %eax,0x4(%esp)
  802468:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80246f:	e8 92 ec ff ff       	call   801106 <sys_page_alloc>
  802474:	89 c3                	mov    %eax,%ebx
  802476:	85 c0                	test   %eax,%eax
  802478:	0f 88 8e 00 00 00    	js     80250c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80247e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802481:	89 04 24             	mov    %eax,(%esp)
  802484:	e8 b7 ed ff ff       	call   801240 <fd2data>
  802489:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802490:	00 
  802491:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802495:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80249c:	00 
  80249d:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024a8:	e8 fb eb ff ff       	call   8010a8 <sys_page_map>
  8024ad:	89 c3                	mov    %eax,%ebx
  8024af:	85 c0                	test   %eax,%eax
  8024b1:	78 49                	js     8024fc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8024b3:	b8 3c 60 80 00       	mov    $0x80603c,%eax
  8024b8:	8b 08                	mov    (%eax),%ecx
  8024ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024bd:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8024bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8024c2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8024c9:	8b 10                	mov    (%eax),%edx
  8024cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ce:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8024d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024d3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8024da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024dd:	89 04 24             	mov    %eax,(%esp)
  8024e0:	e8 4b ed ff ff       	call   801230 <fd2num>
  8024e5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8024e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8024ea:	89 04 24             	mov    %eax,(%esp)
  8024ed:	e8 3e ed ff ff       	call   801230 <fd2num>
  8024f2:	89 47 04             	mov    %eax,0x4(%edi)
  8024f5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8024fa:	eb 36                	jmp    802532 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8024fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  802500:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802507:	e8 3e eb ff ff       	call   80104a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80250c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80250f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802513:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80251a:	e8 2b eb ff ff       	call   80104a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80251f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802522:	89 44 24 04          	mov    %eax,0x4(%esp)
  802526:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80252d:	e8 18 eb ff ff       	call   80104a <sys_page_unmap>
    err:
	return r;
}
  802532:	89 d8                	mov    %ebx,%eax
  802534:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802537:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80253a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80253d:	89 ec                	mov    %ebp,%esp
  80253f:	5d                   	pop    %ebp
  802540:	c3                   	ret    
	...

00802550 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
  802558:	5d                   	pop    %ebp
  802559:	c3                   	ret    

0080255a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80255a:	55                   	push   %ebp
  80255b:	89 e5                	mov    %esp,%ebp
  80255d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802560:	c7 44 24 04 30 2f 80 	movl   $0x802f30,0x4(%esp)
  802567:	00 
  802568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80256b:	89 04 24             	mov    %eax,(%esp)
  80256e:	e8 37 e4 ff ff       	call   8009aa <strcpy>
	return 0;
}
  802573:	b8 00 00 00 00       	mov    $0x0,%eax
  802578:	c9                   	leave  
  802579:	c3                   	ret    

0080257a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80257a:	55                   	push   %ebp
  80257b:	89 e5                	mov    %esp,%ebp
  80257d:	57                   	push   %edi
  80257e:	56                   	push   %esi
  80257f:	53                   	push   %ebx
  802580:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802586:	b8 00 00 00 00       	mov    $0x0,%eax
  80258b:	be 00 00 00 00       	mov    $0x0,%esi
  802590:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802594:	74 3f                	je     8025d5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802596:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80259c:	8b 55 10             	mov    0x10(%ebp),%edx
  80259f:	29 c2                	sub    %eax,%edx
  8025a1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  8025a3:	83 fa 7f             	cmp    $0x7f,%edx
  8025a6:	76 05                	jbe    8025ad <devcons_write+0x33>
  8025a8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8025ad:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025b1:	03 45 0c             	add    0xc(%ebp),%eax
  8025b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025b8:	89 3c 24             	mov    %edi,(%esp)
  8025bb:	e8 a5 e5 ff ff       	call   800b65 <memmove>
		sys_cputs(buf, m);
  8025c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025c4:	89 3c 24             	mov    %edi,(%esp)
  8025c7:	e8 d4 e7 ff ff       	call   800da0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8025cc:	01 de                	add    %ebx,%esi
  8025ce:	89 f0                	mov    %esi,%eax
  8025d0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8025d3:	72 c7                	jb     80259c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8025d5:	89 f0                	mov    %esi,%eax
  8025d7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8025dd:	5b                   	pop    %ebx
  8025de:	5e                   	pop    %esi
  8025df:	5f                   	pop    %edi
  8025e0:	5d                   	pop    %ebp
  8025e1:	c3                   	ret    

008025e2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8025e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8025eb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8025ee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8025f5:	00 
  8025f6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8025f9:	89 04 24             	mov    %eax,(%esp)
  8025fc:	e8 9f e7 ff ff       	call   800da0 <sys_cputs>
}
  802601:	c9                   	leave  
  802602:	c3                   	ret    

00802603 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802603:	55                   	push   %ebp
  802604:	89 e5                	mov    %esp,%ebp
  802606:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802609:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80260d:	75 07                	jne    802616 <devcons_read+0x13>
  80260f:	eb 28                	jmp    802639 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802611:	e8 4f eb ff ff       	call   801165 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802616:	66 90                	xchg   %ax,%ax
  802618:	e8 4f e7 ff ff       	call   800d6c <sys_cgetc>
  80261d:	85 c0                	test   %eax,%eax
  80261f:	90                   	nop
  802620:	74 ef                	je     802611 <devcons_read+0xe>
  802622:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802624:	85 c0                	test   %eax,%eax
  802626:	78 16                	js     80263e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802628:	83 f8 04             	cmp    $0x4,%eax
  80262b:	74 0c                	je     802639 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80262d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802630:	88 10                	mov    %dl,(%eax)
  802632:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802637:	eb 05                	jmp    80263e <devcons_read+0x3b>
  802639:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80263e:	c9                   	leave  
  80263f:	c3                   	ret    

00802640 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
  802643:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802646:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802649:	89 04 24             	mov    %eax,(%esp)
  80264c:	e8 0a ec ff ff       	call   80125b <fd_alloc>
  802651:	85 c0                	test   %eax,%eax
  802653:	78 3f                	js     802694 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802655:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80265c:	00 
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	89 44 24 04          	mov    %eax,0x4(%esp)
  802664:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80266b:	e8 96 ea ff ff       	call   801106 <sys_page_alloc>
  802670:	85 c0                	test   %eax,%eax
  802672:	78 20                	js     802694 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802674:	8b 15 58 60 80 00    	mov    0x806058,%edx
  80267a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	89 04 24             	mov    %eax,(%esp)
  80268f:	e8 9c eb ff ff       	call   801230 <fd2num>
}
  802694:	c9                   	leave  
  802695:	c3                   	ret    

00802696 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802696:	55                   	push   %ebp
  802697:	89 e5                	mov    %esp,%ebp
  802699:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80269c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80269f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a6:	89 04 24             	mov    %eax,(%esp)
  8026a9:	e8 1f ec ff ff       	call   8012cd <fd_lookup>
  8026ae:	85 c0                	test   %eax,%eax
  8026b0:	78 11                	js     8026c3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	8b 00                	mov    (%eax),%eax
  8026b7:	3b 05 58 60 80 00    	cmp    0x806058,%eax
  8026bd:	0f 94 c0             	sete   %al
  8026c0:	0f b6 c0             	movzbl %al,%eax
}
  8026c3:	c9                   	leave  
  8026c4:	c3                   	ret    

008026c5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8026c5:	55                   	push   %ebp
  8026c6:	89 e5                	mov    %esp,%ebp
  8026c8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8026cb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8026d2:	00 
  8026d3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8026d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026e1:	e8 48 ee ff ff       	call   80152e <read>
	if (r < 0)
  8026e6:	85 c0                	test   %eax,%eax
  8026e8:	78 0f                	js     8026f9 <getchar+0x34>
		return r;
	if (r < 1)
  8026ea:	85 c0                	test   %eax,%eax
  8026ec:	7f 07                	jg     8026f5 <getchar+0x30>
  8026ee:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8026f3:	eb 04                	jmp    8026f9 <getchar+0x34>
		return -E_EOF;
	return c;
  8026f5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8026f9:	c9                   	leave  
  8026fa:	c3                   	ret    
  8026fb:	00 00                	add    %al,(%eax)
  8026fd:	00 00                	add    %al,(%eax)
	...

00802700 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802700:	55                   	push   %ebp
  802701:	89 e5                	mov    %esp,%ebp
  802703:	57                   	push   %edi
  802704:	56                   	push   %esi
  802705:	53                   	push   %ebx
  802706:	83 ec 1c             	sub    $0x1c,%esp
  802709:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80270c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80270f:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  802712:	8b 45 14             	mov    0x14(%ebp),%eax
  802715:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802719:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80271d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802721:	89 1c 24             	mov    %ebx,(%esp)
  802724:	e8 cf e7 ff ff       	call   800ef8 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  802729:	85 c0                	test   %eax,%eax
  80272b:	79 21                	jns    80274e <ipc_send+0x4e>
  80272d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802730:	74 1c                	je     80274e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  802732:	c7 44 24 08 3c 2f 80 	movl   $0x802f3c,0x8(%esp)
  802739:	00 
  80273a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  802741:	00 
  802742:	c7 04 24 4e 2f 80 00 	movl   $0x802f4e,(%esp)
  802749:	e8 b6 da ff ff       	call   800204 <_panic>
          else if(r==-E_IPC_NOT_RECV)
  80274e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802751:	75 07                	jne    80275a <ipc_send+0x5a>
           sys_yield();
  802753:	e8 0d ea ff ff       	call   801165 <sys_yield>
          else
            break;
        }
  802758:	eb b8                	jmp    802712 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  80275a:	83 c4 1c             	add    $0x1c,%esp
  80275d:	5b                   	pop    %ebx
  80275e:	5e                   	pop    %esi
  80275f:	5f                   	pop    %edi
  802760:	5d                   	pop    %ebp
  802761:	c3                   	ret    

00802762 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802762:	55                   	push   %ebp
  802763:	89 e5                	mov    %esp,%ebp
  802765:	83 ec 18             	sub    $0x18,%esp
  802768:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80276b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80276e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802771:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  802774:	8b 45 0c             	mov    0xc(%ebp),%eax
  802777:	89 04 24             	mov    %eax,(%esp)
  80277a:	e8 1c e7 ff ff       	call   800e9b <sys_ipc_recv>
        if(r<0)
  80277f:	85 c0                	test   %eax,%eax
  802781:	79 17                	jns    80279a <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  802783:	85 db                	test   %ebx,%ebx
  802785:	74 06                	je     80278d <ipc_recv+0x2b>
               *from_env_store =0;
  802787:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  80278d:	85 f6                	test   %esi,%esi
  80278f:	90                   	nop
  802790:	74 2c                	je     8027be <ipc_recv+0x5c>
              *perm_store=0;
  802792:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802798:	eb 24                	jmp    8027be <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  80279a:	85 db                	test   %ebx,%ebx
  80279c:	74 0a                	je     8027a8 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  80279e:	a1 74 60 80 00       	mov    0x806074,%eax
  8027a3:	8b 40 74             	mov    0x74(%eax),%eax
  8027a6:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  8027a8:	85 f6                	test   %esi,%esi
  8027aa:	74 0a                	je     8027b6 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  8027ac:	a1 74 60 80 00       	mov    0x806074,%eax
  8027b1:	8b 40 78             	mov    0x78(%eax),%eax
  8027b4:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  8027b6:	a1 74 60 80 00       	mov    0x806074,%eax
  8027bb:	8b 40 70             	mov    0x70(%eax),%eax
}
  8027be:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8027c1:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8027c4:	89 ec                	mov    %ebp,%esp
  8027c6:	5d                   	pop    %ebp
  8027c7:	c3                   	ret    

008027c8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8027c8:	55                   	push   %ebp
  8027c9:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8027cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ce:	89 c2                	mov    %eax,%edx
  8027d0:	c1 ea 16             	shr    $0x16,%edx
  8027d3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8027da:	f6 c2 01             	test   $0x1,%dl
  8027dd:	74 26                	je     802805 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  8027df:	c1 e8 0c             	shr    $0xc,%eax
  8027e2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8027e9:	a8 01                	test   $0x1,%al
  8027eb:	74 18                	je     802805 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  8027ed:	c1 e8 0c             	shr    $0xc,%eax
  8027f0:	8d 14 40             	lea    (%eax,%eax,2),%edx
  8027f3:	c1 e2 02             	shl    $0x2,%edx
  8027f6:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8027fb:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802800:	0f b7 c0             	movzwl %ax,%eax
  802803:	eb 05                	jmp    80280a <pageref+0x42>
  802805:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80280a:	5d                   	pop    %ebp
  80280b:	c3                   	ret    
  80280c:	00 00                	add    %al,(%eax)
	...

00802810 <__udivdi3>:
  802810:	55                   	push   %ebp
  802811:	89 e5                	mov    %esp,%ebp
  802813:	57                   	push   %edi
  802814:	56                   	push   %esi
  802815:	83 ec 10             	sub    $0x10,%esp
  802818:	8b 45 14             	mov    0x14(%ebp),%eax
  80281b:	8b 55 08             	mov    0x8(%ebp),%edx
  80281e:	8b 75 10             	mov    0x10(%ebp),%esi
  802821:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802824:	85 c0                	test   %eax,%eax
  802826:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802829:	75 35                	jne    802860 <__udivdi3+0x50>
  80282b:	39 fe                	cmp    %edi,%esi
  80282d:	77 61                	ja     802890 <__udivdi3+0x80>
  80282f:	85 f6                	test   %esi,%esi
  802831:	75 0b                	jne    80283e <__udivdi3+0x2e>
  802833:	b8 01 00 00 00       	mov    $0x1,%eax
  802838:	31 d2                	xor    %edx,%edx
  80283a:	f7 f6                	div    %esi
  80283c:	89 c6                	mov    %eax,%esi
  80283e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802841:	31 d2                	xor    %edx,%edx
  802843:	89 f8                	mov    %edi,%eax
  802845:	f7 f6                	div    %esi
  802847:	89 c7                	mov    %eax,%edi
  802849:	89 c8                	mov    %ecx,%eax
  80284b:	f7 f6                	div    %esi
  80284d:	89 c1                	mov    %eax,%ecx
  80284f:	89 fa                	mov    %edi,%edx
  802851:	89 c8                	mov    %ecx,%eax
  802853:	83 c4 10             	add    $0x10,%esp
  802856:	5e                   	pop    %esi
  802857:	5f                   	pop    %edi
  802858:	5d                   	pop    %ebp
  802859:	c3                   	ret    
  80285a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802860:	39 f8                	cmp    %edi,%eax
  802862:	77 1c                	ja     802880 <__udivdi3+0x70>
  802864:	0f bd d0             	bsr    %eax,%edx
  802867:	83 f2 1f             	xor    $0x1f,%edx
  80286a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80286d:	75 39                	jne    8028a8 <__udivdi3+0x98>
  80286f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802872:	0f 86 a0 00 00 00    	jbe    802918 <__udivdi3+0x108>
  802878:	39 f8                	cmp    %edi,%eax
  80287a:	0f 82 98 00 00 00    	jb     802918 <__udivdi3+0x108>
  802880:	31 ff                	xor    %edi,%edi
  802882:	31 c9                	xor    %ecx,%ecx
  802884:	89 c8                	mov    %ecx,%eax
  802886:	89 fa                	mov    %edi,%edx
  802888:	83 c4 10             	add    $0x10,%esp
  80288b:	5e                   	pop    %esi
  80288c:	5f                   	pop    %edi
  80288d:	5d                   	pop    %ebp
  80288e:	c3                   	ret    
  80288f:	90                   	nop
  802890:	89 d1                	mov    %edx,%ecx
  802892:	89 fa                	mov    %edi,%edx
  802894:	89 c8                	mov    %ecx,%eax
  802896:	31 ff                	xor    %edi,%edi
  802898:	f7 f6                	div    %esi
  80289a:	89 c1                	mov    %eax,%ecx
  80289c:	89 fa                	mov    %edi,%edx
  80289e:	89 c8                	mov    %ecx,%eax
  8028a0:	83 c4 10             	add    $0x10,%esp
  8028a3:	5e                   	pop    %esi
  8028a4:	5f                   	pop    %edi
  8028a5:	5d                   	pop    %ebp
  8028a6:	c3                   	ret    
  8028a7:	90                   	nop
  8028a8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028ac:	89 f2                	mov    %esi,%edx
  8028ae:	d3 e0                	shl    %cl,%eax
  8028b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8028b3:	b8 20 00 00 00       	mov    $0x20,%eax
  8028b8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8028bb:	89 c1                	mov    %eax,%ecx
  8028bd:	d3 ea                	shr    %cl,%edx
  8028bf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028c3:	0b 55 ec             	or     -0x14(%ebp),%edx
  8028c6:	d3 e6                	shl    %cl,%esi
  8028c8:	89 c1                	mov    %eax,%ecx
  8028ca:	89 75 e8             	mov    %esi,-0x18(%ebp)
  8028cd:	89 fe                	mov    %edi,%esi
  8028cf:	d3 ee                	shr    %cl,%esi
  8028d1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028d5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8028d8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028db:	d3 e7                	shl    %cl,%edi
  8028dd:	89 c1                	mov    %eax,%ecx
  8028df:	d3 ea                	shr    %cl,%edx
  8028e1:	09 d7                	or     %edx,%edi
  8028e3:	89 f2                	mov    %esi,%edx
  8028e5:	89 f8                	mov    %edi,%eax
  8028e7:	f7 75 ec             	divl   -0x14(%ebp)
  8028ea:	89 d6                	mov    %edx,%esi
  8028ec:	89 c7                	mov    %eax,%edi
  8028ee:	f7 65 e8             	mull   -0x18(%ebp)
  8028f1:	39 d6                	cmp    %edx,%esi
  8028f3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8028f6:	72 30                	jb     802928 <__udivdi3+0x118>
  8028f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8028fb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8028ff:	d3 e2                	shl    %cl,%edx
  802901:	39 c2                	cmp    %eax,%edx
  802903:	73 05                	jae    80290a <__udivdi3+0xfa>
  802905:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802908:	74 1e                	je     802928 <__udivdi3+0x118>
  80290a:	89 f9                	mov    %edi,%ecx
  80290c:	31 ff                	xor    %edi,%edi
  80290e:	e9 71 ff ff ff       	jmp    802884 <__udivdi3+0x74>
  802913:	90                   	nop
  802914:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802918:	31 ff                	xor    %edi,%edi
  80291a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80291f:	e9 60 ff ff ff       	jmp    802884 <__udivdi3+0x74>
  802924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802928:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80292b:	31 ff                	xor    %edi,%edi
  80292d:	89 c8                	mov    %ecx,%eax
  80292f:	89 fa                	mov    %edi,%edx
  802931:	83 c4 10             	add    $0x10,%esp
  802934:	5e                   	pop    %esi
  802935:	5f                   	pop    %edi
  802936:	5d                   	pop    %ebp
  802937:	c3                   	ret    
	...

00802940 <__umoddi3>:
  802940:	55                   	push   %ebp
  802941:	89 e5                	mov    %esp,%ebp
  802943:	57                   	push   %edi
  802944:	56                   	push   %esi
  802945:	83 ec 20             	sub    $0x20,%esp
  802948:	8b 55 14             	mov    0x14(%ebp),%edx
  80294b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80294e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802951:	8b 75 0c             	mov    0xc(%ebp),%esi
  802954:	85 d2                	test   %edx,%edx
  802956:	89 c8                	mov    %ecx,%eax
  802958:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80295b:	75 13                	jne    802970 <__umoddi3+0x30>
  80295d:	39 f7                	cmp    %esi,%edi
  80295f:	76 3f                	jbe    8029a0 <__umoddi3+0x60>
  802961:	89 f2                	mov    %esi,%edx
  802963:	f7 f7                	div    %edi
  802965:	89 d0                	mov    %edx,%eax
  802967:	31 d2                	xor    %edx,%edx
  802969:	83 c4 20             	add    $0x20,%esp
  80296c:	5e                   	pop    %esi
  80296d:	5f                   	pop    %edi
  80296e:	5d                   	pop    %ebp
  80296f:	c3                   	ret    
  802970:	39 f2                	cmp    %esi,%edx
  802972:	77 4c                	ja     8029c0 <__umoddi3+0x80>
  802974:	0f bd ca             	bsr    %edx,%ecx
  802977:	83 f1 1f             	xor    $0x1f,%ecx
  80297a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80297d:	75 51                	jne    8029d0 <__umoddi3+0x90>
  80297f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802982:	0f 87 e0 00 00 00    	ja     802a68 <__umoddi3+0x128>
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	29 f8                	sub    %edi,%eax
  80298d:	19 d6                	sbb    %edx,%esi
  80298f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	89 f2                	mov    %esi,%edx
  802997:	83 c4 20             	add    $0x20,%esp
  80299a:	5e                   	pop    %esi
  80299b:	5f                   	pop    %edi
  80299c:	5d                   	pop    %ebp
  80299d:	c3                   	ret    
  80299e:	66 90                	xchg   %ax,%ax
  8029a0:	85 ff                	test   %edi,%edi
  8029a2:	75 0b                	jne    8029af <__umoddi3+0x6f>
  8029a4:	b8 01 00 00 00       	mov    $0x1,%eax
  8029a9:	31 d2                	xor    %edx,%edx
  8029ab:	f7 f7                	div    %edi
  8029ad:	89 c7                	mov    %eax,%edi
  8029af:	89 f0                	mov    %esi,%eax
  8029b1:	31 d2                	xor    %edx,%edx
  8029b3:	f7 f7                	div    %edi
  8029b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b8:	f7 f7                	div    %edi
  8029ba:	eb a9                	jmp    802965 <__umoddi3+0x25>
  8029bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029c0:	89 c8                	mov    %ecx,%eax
  8029c2:	89 f2                	mov    %esi,%edx
  8029c4:	83 c4 20             	add    $0x20,%esp
  8029c7:	5e                   	pop    %esi
  8029c8:	5f                   	pop    %edi
  8029c9:	5d                   	pop    %ebp
  8029ca:	c3                   	ret    
  8029cb:	90                   	nop
  8029cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029d0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029d4:	d3 e2                	shl    %cl,%edx
  8029d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8029d9:	ba 20 00 00 00       	mov    $0x20,%edx
  8029de:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8029e1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8029e4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8029e8:	89 fa                	mov    %edi,%edx
  8029ea:	d3 ea                	shr    %cl,%edx
  8029ec:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8029f0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8029f3:	d3 e7                	shl    %cl,%edi
  8029f5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8029f9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8029fc:	89 f2                	mov    %esi,%edx
  8029fe:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802a01:	89 c7                	mov    %eax,%edi
  802a03:	d3 ea                	shr    %cl,%edx
  802a05:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a09:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802a0c:	89 c2                	mov    %eax,%edx
  802a0e:	d3 e6                	shl    %cl,%esi
  802a10:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a14:	d3 ea                	shr    %cl,%edx
  802a16:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a1a:	09 d6                	or     %edx,%esi
  802a1c:	89 f0                	mov    %esi,%eax
  802a1e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802a21:	d3 e7                	shl    %cl,%edi
  802a23:	89 f2                	mov    %esi,%edx
  802a25:	f7 75 f4             	divl   -0xc(%ebp)
  802a28:	89 d6                	mov    %edx,%esi
  802a2a:	f7 65 e8             	mull   -0x18(%ebp)
  802a2d:	39 d6                	cmp    %edx,%esi
  802a2f:	72 2b                	jb     802a5c <__umoddi3+0x11c>
  802a31:	39 c7                	cmp    %eax,%edi
  802a33:	72 23                	jb     802a58 <__umoddi3+0x118>
  802a35:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a39:	29 c7                	sub    %eax,%edi
  802a3b:	19 d6                	sbb    %edx,%esi
  802a3d:	89 f0                	mov    %esi,%eax
  802a3f:	89 f2                	mov    %esi,%edx
  802a41:	d3 ef                	shr    %cl,%edi
  802a43:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a47:	d3 e0                	shl    %cl,%eax
  802a49:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a4d:	09 f8                	or     %edi,%eax
  802a4f:	d3 ea                	shr    %cl,%edx
  802a51:	83 c4 20             	add    $0x20,%esp
  802a54:	5e                   	pop    %esi
  802a55:	5f                   	pop    %edi
  802a56:	5d                   	pop    %ebp
  802a57:	c3                   	ret    
  802a58:	39 d6                	cmp    %edx,%esi
  802a5a:	75 d9                	jne    802a35 <__umoddi3+0xf5>
  802a5c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802a5f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802a62:	eb d1                	jmp    802a35 <__umoddi3+0xf5>
  802a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a68:	39 f2                	cmp    %esi,%edx
  802a6a:	0f 82 18 ff ff ff    	jb     802988 <__umoddi3+0x48>
  802a70:	e9 1d ff ff ff       	jmp    802992 <__umoddi3+0x52>
