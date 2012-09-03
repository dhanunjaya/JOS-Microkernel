
obj/user/testpteshare:     file format elf32-i386


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
  80002c:	e8 87 01 00 00       	call   8001b8 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <childofspawn>:
	breakpoint();
}

void
childofspawn(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 18             	sub    $0x18,%esp
	strcpy(VA, msg2);
  80003a:	a1 04 70 80 00       	mov    0x807004,%eax
  80003f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800043:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  80004a:	e8 7b 09 00 00       	call   8009ca <strcpy>
	exit();
  80004f:	e8 b4 01 00 00       	call   800208 <exit>
}
  800054:	c9                   	leave  
  800055:	c3                   	ret    

00800056 <umain>:

void childofspawn(void);

void
umain(int argc, char **argv)
{
  800056:	55                   	push   %ebp
  800057:	89 e5                	mov    %esp,%ebp
  800059:	53                   	push   %ebx
  80005a:	83 ec 14             	sub    $0x14,%esp
	int r;

	if (argc != 0)
  80005d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800061:	74 05                	je     800068 <umain+0x12>
		childofspawn();
  800063:	e8 cc ff ff ff       	call   800034 <childofspawn>

	if ((r = sys_page_alloc(0, VA, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800068:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80006f:	00 
  800070:	c7 44 24 04 00 00 00 	movl   $0xa0000000,0x4(%esp)
  800077:	a0 
  800078:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80007f:	e8 a2 10 00 00       	call   801126 <sys_page_alloc>
  800084:	85 c0                	test   %eax,%eax
  800086:	79 20                	jns    8000a8 <umain+0x52>
		panic("sys_page_alloc: %e", r);
  800088:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80008c:	c7 44 24 08 20 34 80 	movl   $0x803420,0x8(%esp)
  800093:	00 
  800094:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80009b:	00 
  80009c:	c7 04 24 33 34 80 00 	movl   $0x803433,(%esp)
  8000a3:	e8 7c 01 00 00       	call   800224 <_panic>

	// check fork
	if ((r = fork()) < 0)
  8000a8:	e8 fa 12 00 00       	call   8013a7 <fork>
  8000ad:	89 c3                	mov    %eax,%ebx
  8000af:	85 c0                	test   %eax,%eax
  8000b1:	79 20                	jns    8000d3 <umain+0x7d>
		panic("fork: %e", r);
  8000b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000b7:	c7 44 24 08 63 38 80 	movl   $0x803863,0x8(%esp)
  8000be:	00 
  8000bf:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  8000c6:	00 
  8000c7:	c7 04 24 33 34 80 00 	movl   $0x803433,(%esp)
  8000ce:	e8 51 01 00 00       	call   800224 <_panic>
	if (r == 0) {
  8000d3:	85 c0                	test   %eax,%eax
  8000d5:	75 1a                	jne    8000f1 <umain+0x9b>
		strcpy(VA, msg);
  8000d7:	a1 00 70 80 00       	mov    0x807000,%eax
  8000dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e0:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  8000e7:	e8 de 08 00 00       	call   8009ca <strcpy>
		exit();
  8000ec:	e8 17 01 00 00       	call   800208 <exit>
	}
	wait(r);
  8000f1:	89 1c 24             	mov    %ebx,(%esp)
  8000f4:	e8 eb 2c 00 00       	call   802de4 <wait>
	cprintf("fork handles PTE_SHARE %s\n", strcmp(VA, msg) == 0 ? "right" : "wrong");
  8000f9:	a1 00 70 80 00       	mov    0x807000,%eax
  8000fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800102:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  800109:	e8 4b 09 00 00       	call   800a59 <strcmp>
  80010e:	ba 4d 34 80 00       	mov    $0x80344d,%edx
  800113:	85 c0                	test   %eax,%eax
  800115:	74 05                	je     80011c <umain+0xc6>
  800117:	ba 47 34 80 00       	mov    $0x803447,%edx
  80011c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800120:	c7 04 24 53 34 80 00 	movl   $0x803453,(%esp)
  800127:	e8 bd 01 00 00       	call   8002e9 <cprintf>

	// check spawn
	if ((r = spawnl("/testpteshare", "testpteshare", "arg", 0)) < 0)
  80012c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800133:	00 
  800134:	c7 44 24 08 6e 34 80 	movl   $0x80346e,0x8(%esp)
  80013b:	00 
  80013c:	c7 44 24 04 73 34 80 	movl   $0x803473,0x4(%esp)
  800143:	00 
  800144:	c7 04 24 72 34 80 00 	movl   $0x803472,(%esp)
  80014b:	e8 c1 23 00 00       	call   802511 <spawnl>
  800150:	85 c0                	test   %eax,%eax
  800152:	79 20                	jns    800174 <umain+0x11e>
		panic("spawn: %e", r);
  800154:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800158:	c7 44 24 08 80 34 80 	movl   $0x803480,0x8(%esp)
  80015f:	00 
  800160:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  800167:	00 
  800168:	c7 04 24 33 34 80 00 	movl   $0x803433,(%esp)
  80016f:	e8 b0 00 00 00       	call   800224 <_panic>
	wait(r);
  800174:	89 04 24             	mov    %eax,(%esp)
  800177:	e8 68 2c 00 00       	call   802de4 <wait>
	cprintf("spawn handles PTE_SHARE %s\n", strcmp(VA, msg2) == 0 ? "right" : "wrong");
  80017c:	a1 04 70 80 00       	mov    0x807004,%eax
  800181:	89 44 24 04          	mov    %eax,0x4(%esp)
  800185:	c7 04 24 00 00 00 a0 	movl   $0xa0000000,(%esp)
  80018c:	e8 c8 08 00 00       	call   800a59 <strcmp>
  800191:	ba 4d 34 80 00       	mov    $0x80344d,%edx
  800196:	85 c0                	test   %eax,%eax
  800198:	74 05                	je     80019f <umain+0x149>
  80019a:	ba 47 34 80 00       	mov    $0x803447,%edx
  80019f:	89 54 24 04          	mov    %edx,0x4(%esp)
  8001a3:	c7 04 24 8a 34 80 00 	movl   $0x80348a,(%esp)
  8001aa:	e8 3a 01 00 00       	call   8002e9 <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8001af:	cc                   	int3   

	breakpoint();
}
  8001b0:	83 c4 14             	add    $0x14,%esp
  8001b3:	5b                   	pop    %ebx
  8001b4:	5d                   	pop    %ebp
  8001b5:	c3                   	ret    
	...

008001b8 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001b8:	55                   	push   %ebp
  8001b9:	89 e5                	mov    %esp,%ebp
  8001bb:	83 ec 18             	sub    $0x18,%esp
  8001be:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8001c1:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8001c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8001c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  8001ca:	e8 ea 0f 00 00       	call   8011b9 <sys_getenvid>
  8001cf:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001d4:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8001d7:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001dc:	a3 7c 70 80 00       	mov    %eax,0x80707c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e1:	85 f6                	test   %esi,%esi
  8001e3:	7e 07                	jle    8001ec <libmain+0x34>
		binaryname = argv[0];
  8001e5:	8b 03                	mov    (%ebx),%eax
  8001e7:	a3 08 70 80 00       	mov    %eax,0x807008

	// call user main routine
	umain(argc, argv);
  8001ec:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001f0:	89 34 24             	mov    %esi,(%esp)
  8001f3:	e8 5e fe ff ff       	call   800056 <umain>

	// exit gracefully
	exit();
  8001f8:	e8 0b 00 00 00       	call   800208 <exit>
}
  8001fd:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800200:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800203:	89 ec                	mov    %ebp,%esp
  800205:	5d                   	pop    %ebp
  800206:	c3                   	ret    
	...

00800208 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80020e:	e8 a8 18 00 00       	call   801abb <close_all>
	sys_env_destroy(0);
  800213:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80021a:	e8 ce 0f 00 00       	call   8011ed <sys_env_destroy>
}
  80021f:	c9                   	leave  
  800220:	c3                   	ret    
  800221:	00 00                	add    %al,(%eax)
	...

00800224 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800224:	55                   	push   %ebp
  800225:	89 e5                	mov    %esp,%ebp
  800227:	53                   	push   %ebx
  800228:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  80022b:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  80022e:	a1 80 70 80 00       	mov    0x807080,%eax
  800233:	85 c0                	test   %eax,%eax
  800235:	74 10                	je     800247 <_panic+0x23>
		cprintf("%s: ", argv0);
  800237:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023b:	c7 04 24 db 34 80 00 	movl   $0x8034db,(%esp)
  800242:	e8 a2 00 00 00       	call   8002e9 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800247:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80024e:	8b 45 08             	mov    0x8(%ebp),%eax
  800251:	89 44 24 08          	mov    %eax,0x8(%esp)
  800255:	a1 08 70 80 00       	mov    0x807008,%eax
  80025a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80025e:	c7 04 24 e0 34 80 00 	movl   $0x8034e0,(%esp)
  800265:	e8 7f 00 00 00       	call   8002e9 <cprintf>
	vcprintf(fmt, ap);
  80026a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80026e:	8b 45 10             	mov    0x10(%ebp),%eax
  800271:	89 04 24             	mov    %eax,(%esp)
  800274:	e8 0f 00 00 00       	call   800288 <vcprintf>
	cprintf("\n");
  800279:	c7 04 24 75 3a 80 00 	movl   $0x803a75,(%esp)
  800280:	e8 64 00 00 00       	call   8002e9 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800285:	cc                   	int3   
  800286:	eb fd                	jmp    800285 <_panic+0x61>

00800288 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800291:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800298:	00 00 00 
	b.cnt = 0;
  80029b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8002a2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8002a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8002af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002b3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8002b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002bd:	c7 04 24 03 03 80 00 	movl   $0x800303,(%esp)
  8002c4:	e8 d4 01 00 00       	call   80049d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8002c9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8002cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002d3:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8002d9:	89 04 24             	mov    %eax,(%esp)
  8002dc:	e8 df 0a 00 00       	call   800dc0 <sys_cputs>

	return b.cnt;
}
  8002e1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8002e7:	c9                   	leave  
  8002e8:	c3                   	ret    

008002e9 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8002ef:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8002f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	89 04 24             	mov    %eax,(%esp)
  8002fc:	e8 87 ff ff ff       	call   800288 <vcprintf>
	va_end(ap);

	return cnt;
}
  800301:	c9                   	leave  
  800302:	c3                   	ret    

00800303 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800303:	55                   	push   %ebp
  800304:	89 e5                	mov    %esp,%ebp
  800306:	53                   	push   %ebx
  800307:	83 ec 14             	sub    $0x14,%esp
  80030a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80030d:	8b 03                	mov    (%ebx),%eax
  80030f:	8b 55 08             	mov    0x8(%ebp),%edx
  800312:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800316:	83 c0 01             	add    $0x1,%eax
  800319:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80031b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800320:	75 19                	jne    80033b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800322:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800329:	00 
  80032a:	8d 43 08             	lea    0x8(%ebx),%eax
  80032d:	89 04 24             	mov    %eax,(%esp)
  800330:	e8 8b 0a 00 00       	call   800dc0 <sys_cputs>
		b->idx = 0;
  800335:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80033b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80033f:	83 c4 14             	add    $0x14,%esp
  800342:	5b                   	pop    %ebx
  800343:	5d                   	pop    %ebp
  800344:	c3                   	ret    
	...

00800350 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	57                   	push   %edi
  800354:	56                   	push   %esi
  800355:	53                   	push   %ebx
  800356:	83 ec 4c             	sub    $0x4c,%esp
  800359:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80035c:	89 d6                	mov    %edx,%esi
  80035e:	8b 45 08             	mov    0x8(%ebp),%eax
  800361:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800364:	8b 55 0c             	mov    0xc(%ebp),%edx
  800367:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80036a:	8b 45 10             	mov    0x10(%ebp),%eax
  80036d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800370:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800373:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800376:	b9 00 00 00 00       	mov    $0x0,%ecx
  80037b:	39 d1                	cmp    %edx,%ecx
  80037d:	72 15                	jb     800394 <printnum+0x44>
  80037f:	77 07                	ja     800388 <printnum+0x38>
  800381:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800384:	39 d0                	cmp    %edx,%eax
  800386:	76 0c                	jbe    800394 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800388:	83 eb 01             	sub    $0x1,%ebx
  80038b:	85 db                	test   %ebx,%ebx
  80038d:	8d 76 00             	lea    0x0(%esi),%esi
  800390:	7f 61                	jg     8003f3 <printnum+0xa3>
  800392:	eb 70                	jmp    800404 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800394:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800398:	83 eb 01             	sub    $0x1,%ebx
  80039b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80039f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003a3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8003a7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8003ab:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8003ae:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8003b1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8003b4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8003b8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003bf:	00 
  8003c0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8003c3:	89 04 24             	mov    %eax,(%esp)
  8003c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003c9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003cd:	e8 de 2d 00 00       	call   8031b0 <__udivdi3>
  8003d2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8003d5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8003d8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8003dc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8003e0:	89 04 24             	mov    %eax,(%esp)
  8003e3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8003e7:	89 f2                	mov    %esi,%edx
  8003e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003ec:	e8 5f ff ff ff       	call   800350 <printnum>
  8003f1:	eb 11                	jmp    800404 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003f3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003f7:	89 3c 24             	mov    %edi,(%esp)
  8003fa:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8003fd:	83 eb 01             	sub    $0x1,%ebx
  800400:	85 db                	test   %ebx,%ebx
  800402:	7f ef                	jg     8003f3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800404:	89 74 24 04          	mov    %esi,0x4(%esp)
  800408:	8b 74 24 04          	mov    0x4(%esp),%esi
  80040c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80040f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800413:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80041a:	00 
  80041b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80041e:	89 14 24             	mov    %edx,(%esp)
  800421:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800424:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800428:	e8 b3 2e 00 00       	call   8032e0 <__umoddi3>
  80042d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800431:	0f be 80 fc 34 80 00 	movsbl 0x8034fc(%eax),%eax
  800438:	89 04 24             	mov    %eax,(%esp)
  80043b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80043e:	83 c4 4c             	add    $0x4c,%esp
  800441:	5b                   	pop    %ebx
  800442:	5e                   	pop    %esi
  800443:	5f                   	pop    %edi
  800444:	5d                   	pop    %ebp
  800445:	c3                   	ret    

00800446 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800446:	55                   	push   %ebp
  800447:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800449:	83 fa 01             	cmp    $0x1,%edx
  80044c:	7e 0e                	jle    80045c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80044e:	8b 10                	mov    (%eax),%edx
  800450:	8d 4a 08             	lea    0x8(%edx),%ecx
  800453:	89 08                	mov    %ecx,(%eax)
  800455:	8b 02                	mov    (%edx),%eax
  800457:	8b 52 04             	mov    0x4(%edx),%edx
  80045a:	eb 22                	jmp    80047e <getuint+0x38>
	else if (lflag)
  80045c:	85 d2                	test   %edx,%edx
  80045e:	74 10                	je     800470 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800460:	8b 10                	mov    (%eax),%edx
  800462:	8d 4a 04             	lea    0x4(%edx),%ecx
  800465:	89 08                	mov    %ecx,(%eax)
  800467:	8b 02                	mov    (%edx),%eax
  800469:	ba 00 00 00 00       	mov    $0x0,%edx
  80046e:	eb 0e                	jmp    80047e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800470:	8b 10                	mov    (%eax),%edx
  800472:	8d 4a 04             	lea    0x4(%edx),%ecx
  800475:	89 08                	mov    %ecx,(%eax)
  800477:	8b 02                	mov    (%edx),%eax
  800479:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80047e:	5d                   	pop    %ebp
  80047f:	c3                   	ret    

00800480 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800480:	55                   	push   %ebp
  800481:	89 e5                	mov    %esp,%ebp
  800483:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800486:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80048a:	8b 10                	mov    (%eax),%edx
  80048c:	3b 50 04             	cmp    0x4(%eax),%edx
  80048f:	73 0a                	jae    80049b <sprintputch+0x1b>
		*b->buf++ = ch;
  800491:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800494:	88 0a                	mov    %cl,(%edx)
  800496:	83 c2 01             	add    $0x1,%edx
  800499:	89 10                	mov    %edx,(%eax)
}
  80049b:	5d                   	pop    %ebp
  80049c:	c3                   	ret    

0080049d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	57                   	push   %edi
  8004a1:	56                   	push   %esi
  8004a2:	53                   	push   %ebx
  8004a3:	83 ec 5c             	sub    $0x5c,%esp
  8004a6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8004a9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8004ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8004af:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8004b6:	eb 11                	jmp    8004c9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8004b8:	85 c0                	test   %eax,%eax
  8004ba:	0f 84 09 04 00 00    	je     8008c9 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  8004c0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004c4:	89 04 24             	mov    %eax,(%esp)
  8004c7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8004c9:	0f b6 03             	movzbl (%ebx),%eax
  8004cc:	83 c3 01             	add    $0x1,%ebx
  8004cf:	83 f8 25             	cmp    $0x25,%eax
  8004d2:	75 e4                	jne    8004b8 <vprintfmt+0x1b>
  8004d4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8004d8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8004df:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8004e6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8004ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004f2:	eb 06                	jmp    8004fa <vprintfmt+0x5d>
  8004f4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8004f8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8004fa:	0f b6 13             	movzbl (%ebx),%edx
  8004fd:	0f b6 c2             	movzbl %dl,%eax
  800500:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800503:	8d 43 01             	lea    0x1(%ebx),%eax
  800506:	83 ea 23             	sub    $0x23,%edx
  800509:	80 fa 55             	cmp    $0x55,%dl
  80050c:	0f 87 9a 03 00 00    	ja     8008ac <vprintfmt+0x40f>
  800512:	0f b6 d2             	movzbl %dl,%edx
  800515:	ff 24 95 40 36 80 00 	jmp    *0x803640(,%edx,4)
  80051c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800520:	eb d6                	jmp    8004f8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800522:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800525:	83 ea 30             	sub    $0x30,%edx
  800528:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  80052b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80052e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800531:	83 fb 09             	cmp    $0x9,%ebx
  800534:	77 4c                	ja     800582 <vprintfmt+0xe5>
  800536:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800539:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80053c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80053f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800542:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800546:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800549:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80054c:	83 fb 09             	cmp    $0x9,%ebx
  80054f:	76 eb                	jbe    80053c <vprintfmt+0x9f>
  800551:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800554:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800557:	eb 29                	jmp    800582 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800559:	8b 55 14             	mov    0x14(%ebp),%edx
  80055c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80055f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800562:	8b 12                	mov    (%edx),%edx
  800564:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  800567:	eb 19                	jmp    800582 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800569:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80056c:	c1 fa 1f             	sar    $0x1f,%edx
  80056f:	f7 d2                	not    %edx
  800571:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800574:	eb 82                	jmp    8004f8 <vprintfmt+0x5b>
  800576:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80057d:	e9 76 ff ff ff       	jmp    8004f8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800582:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800586:	0f 89 6c ff ff ff    	jns    8004f8 <vprintfmt+0x5b>
  80058c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80058f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800592:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800595:	89 55 cc             	mov    %edx,-0x34(%ebp)
  800598:	e9 5b ff ff ff       	jmp    8004f8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80059d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8005a0:	e9 53 ff ff ff       	jmp    8004f8 <vprintfmt+0x5b>
  8005a5:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8d 50 04             	lea    0x4(%eax),%edx
  8005ae:	89 55 14             	mov    %edx,0x14(%ebp)
  8005b1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005b5:	8b 00                	mov    (%eax),%eax
  8005b7:	89 04 24             	mov    %eax,(%esp)
  8005ba:	ff d7                	call   *%edi
  8005bc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8005bf:	e9 05 ff ff ff       	jmp    8004c9 <vprintfmt+0x2c>
  8005c4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8005c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ca:	8d 50 04             	lea    0x4(%eax),%edx
  8005cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8005d0:	8b 00                	mov    (%eax),%eax
  8005d2:	89 c2                	mov    %eax,%edx
  8005d4:	c1 fa 1f             	sar    $0x1f,%edx
  8005d7:	31 d0                	xor    %edx,%eax
  8005d9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005db:	83 f8 0f             	cmp    $0xf,%eax
  8005de:	7f 0b                	jg     8005eb <vprintfmt+0x14e>
  8005e0:	8b 14 85 a0 37 80 00 	mov    0x8037a0(,%eax,4),%edx
  8005e7:	85 d2                	test   %edx,%edx
  8005e9:	75 20                	jne    80060b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8005eb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005ef:	c7 44 24 08 0d 35 80 	movl   $0x80350d,0x8(%esp)
  8005f6:	00 
  8005f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005fb:	89 3c 24             	mov    %edi,(%esp)
  8005fe:	e8 4e 03 00 00       	call   800951 <printfmt>
  800603:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800606:	e9 be fe ff ff       	jmp    8004c9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80060b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80060f:	c7 44 24 08 b3 39 80 	movl   $0x8039b3,0x8(%esp)
  800616:	00 
  800617:	89 74 24 04          	mov    %esi,0x4(%esp)
  80061b:	89 3c 24             	mov    %edi,(%esp)
  80061e:	e8 2e 03 00 00       	call   800951 <printfmt>
  800623:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800626:	e9 9e fe ff ff       	jmp    8004c9 <vprintfmt+0x2c>
  80062b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80062e:	89 c3                	mov    %eax,%ebx
  800630:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800636:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8d 50 04             	lea    0x4(%eax),%edx
  80063f:	89 55 14             	mov    %edx,0x14(%ebp)
  800642:	8b 00                	mov    (%eax),%eax
  800644:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800647:	85 c0                	test   %eax,%eax
  800649:	75 07                	jne    800652 <vprintfmt+0x1b5>
  80064b:	c7 45 c4 16 35 80 00 	movl   $0x803516,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800652:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  800656:	7e 06                	jle    80065e <vprintfmt+0x1c1>
  800658:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80065c:	75 13                	jne    800671 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80065e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800661:	0f be 02             	movsbl (%edx),%eax
  800664:	85 c0                	test   %eax,%eax
  800666:	0f 85 99 00 00 00    	jne    800705 <vprintfmt+0x268>
  80066c:	e9 86 00 00 00       	jmp    8006f7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800671:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800675:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800678:	89 0c 24             	mov    %ecx,(%esp)
  80067b:	e8 1b 03 00 00       	call   80099b <strnlen>
  800680:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800683:	29 c2                	sub    %eax,%edx
  800685:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800688:	85 d2                	test   %edx,%edx
  80068a:	7e d2                	jle    80065e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80068c:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  800690:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800693:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  800696:	89 d3                	mov    %edx,%ebx
  800698:	89 74 24 04          	mov    %esi,0x4(%esp)
  80069c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80069f:	89 04 24             	mov    %eax,(%esp)
  8006a2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8006a4:	83 eb 01             	sub    $0x1,%ebx
  8006a7:	85 db                	test   %ebx,%ebx
  8006a9:	7f ed                	jg     800698 <vprintfmt+0x1fb>
  8006ab:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8006ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8006b5:	eb a7                	jmp    80065e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006b7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8006bb:	74 18                	je     8006d5 <vprintfmt+0x238>
  8006bd:	8d 50 e0             	lea    -0x20(%eax),%edx
  8006c0:	83 fa 5e             	cmp    $0x5e,%edx
  8006c3:	76 10                	jbe    8006d5 <vprintfmt+0x238>
					putch('?', putdat);
  8006c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006c9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8006d0:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8006d3:	eb 0a                	jmp    8006df <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8006d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8006d9:	89 04 24             	mov    %eax,(%esp)
  8006dc:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006df:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8006e3:	0f be 03             	movsbl (%ebx),%eax
  8006e6:	85 c0                	test   %eax,%eax
  8006e8:	74 05                	je     8006ef <vprintfmt+0x252>
  8006ea:	83 c3 01             	add    $0x1,%ebx
  8006ed:	eb 29                	jmp    800718 <vprintfmt+0x27b>
  8006ef:	89 fe                	mov    %edi,%esi
  8006f1:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006f4:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006fb:	7f 2e                	jg     80072b <vprintfmt+0x28e>
  8006fd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800700:	e9 c4 fd ff ff       	jmp    8004c9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800705:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800708:	83 c2 01             	add    $0x1,%edx
  80070b:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80070e:	89 f7                	mov    %esi,%edi
  800710:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800713:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  800716:	89 d3                	mov    %edx,%ebx
  800718:	85 f6                	test   %esi,%esi
  80071a:	78 9b                	js     8006b7 <vprintfmt+0x21a>
  80071c:	83 ee 01             	sub    $0x1,%esi
  80071f:	79 96                	jns    8006b7 <vprintfmt+0x21a>
  800721:	89 fe                	mov    %edi,%esi
  800723:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800726:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800729:	eb cc                	jmp    8006f7 <vprintfmt+0x25a>
  80072b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  80072e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800731:	89 74 24 04          	mov    %esi,0x4(%esp)
  800735:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80073c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80073e:	83 eb 01             	sub    $0x1,%ebx
  800741:	85 db                	test   %ebx,%ebx
  800743:	7f ec                	jg     800731 <vprintfmt+0x294>
  800745:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800748:	e9 7c fd ff ff       	jmp    8004c9 <vprintfmt+0x2c>
  80074d:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800750:	83 f9 01             	cmp    $0x1,%ecx
  800753:	7e 16                	jle    80076b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800755:	8b 45 14             	mov    0x14(%ebp),%eax
  800758:	8d 50 08             	lea    0x8(%eax),%edx
  80075b:	89 55 14             	mov    %edx,0x14(%ebp)
  80075e:	8b 10                	mov    (%eax),%edx
  800760:	8b 48 04             	mov    0x4(%eax),%ecx
  800763:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800766:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800769:	eb 32                	jmp    80079d <vprintfmt+0x300>
	else if (lflag)
  80076b:	85 c9                	test   %ecx,%ecx
  80076d:	74 18                	je     800787 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80076f:	8b 45 14             	mov    0x14(%ebp),%eax
  800772:	8d 50 04             	lea    0x4(%eax),%edx
  800775:	89 55 14             	mov    %edx,0x14(%ebp)
  800778:	8b 00                	mov    (%eax),%eax
  80077a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80077d:	89 c1                	mov    %eax,%ecx
  80077f:	c1 f9 1f             	sar    $0x1f,%ecx
  800782:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800785:	eb 16                	jmp    80079d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800787:	8b 45 14             	mov    0x14(%ebp),%eax
  80078a:	8d 50 04             	lea    0x4(%eax),%edx
  80078d:	89 55 14             	mov    %edx,0x14(%ebp)
  800790:	8b 00                	mov    (%eax),%eax
  800792:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800795:	89 c2                	mov    %eax,%edx
  800797:	c1 fa 1f             	sar    $0x1f,%edx
  80079a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80079d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8007a0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007a3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8007a8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8007ac:	0f 89 b8 00 00 00    	jns    80086a <vprintfmt+0x3cd>
				putch('-', putdat);
  8007b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007b6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8007bd:	ff d7                	call   *%edi
				num = -(long long) num;
  8007bf:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8007c2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007c5:	f7 d9                	neg    %ecx
  8007c7:	83 d3 00             	adc    $0x0,%ebx
  8007ca:	f7 db                	neg    %ebx
  8007cc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007d1:	e9 94 00 00 00       	jmp    80086a <vprintfmt+0x3cd>
  8007d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007d9:	89 ca                	mov    %ecx,%edx
  8007db:	8d 45 14             	lea    0x14(%ebp),%eax
  8007de:	e8 63 fc ff ff       	call   800446 <getuint>
  8007e3:	89 c1                	mov    %eax,%ecx
  8007e5:	89 d3                	mov    %edx,%ebx
  8007e7:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8007ec:	eb 7c                	jmp    80086a <vprintfmt+0x3cd>
  8007ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8007f1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007f5:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8007fc:	ff d7                	call   *%edi
			putch('X', putdat);
  8007fe:	89 74 24 04          	mov    %esi,0x4(%esp)
  800802:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800809:	ff d7                	call   *%edi
			putch('X', putdat);
  80080b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80080f:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800816:	ff d7                	call   *%edi
  800818:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80081b:	e9 a9 fc ff ff       	jmp    8004c9 <vprintfmt+0x2c>
  800820:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800823:	89 74 24 04          	mov    %esi,0x4(%esp)
  800827:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80082e:	ff d7                	call   *%edi
			putch('x', putdat);
  800830:	89 74 24 04          	mov    %esi,0x4(%esp)
  800834:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80083b:	ff d7                	call   *%edi
			num = (unsigned long long)
  80083d:	8b 45 14             	mov    0x14(%ebp),%eax
  800840:	8d 50 04             	lea    0x4(%eax),%edx
  800843:	89 55 14             	mov    %edx,0x14(%ebp)
  800846:	8b 08                	mov    (%eax),%ecx
  800848:	bb 00 00 00 00       	mov    $0x0,%ebx
  80084d:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800852:	eb 16                	jmp    80086a <vprintfmt+0x3cd>
  800854:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800857:	89 ca                	mov    %ecx,%edx
  800859:	8d 45 14             	lea    0x14(%ebp),%eax
  80085c:	e8 e5 fb ff ff       	call   800446 <getuint>
  800861:	89 c1                	mov    %eax,%ecx
  800863:	89 d3                	mov    %edx,%ebx
  800865:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80086a:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  80086e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800872:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800875:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800879:	89 44 24 08          	mov    %eax,0x8(%esp)
  80087d:	89 0c 24             	mov    %ecx,(%esp)
  800880:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800884:	89 f2                	mov    %esi,%edx
  800886:	89 f8                	mov    %edi,%eax
  800888:	e8 c3 fa ff ff       	call   800350 <printnum>
  80088d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800890:	e9 34 fc ff ff       	jmp    8004c9 <vprintfmt+0x2c>
  800895:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800898:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80089b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80089f:	89 14 24             	mov    %edx,(%esp)
  8008a2:	ff d7                	call   *%edi
  8008a4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8008a7:	e9 1d fc ff ff       	jmp    8004c9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008b0:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8008b7:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008b9:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8008bc:	80 38 25             	cmpb   $0x25,(%eax)
  8008bf:	0f 84 04 fc ff ff    	je     8004c9 <vprintfmt+0x2c>
  8008c5:	89 c3                	mov    %eax,%ebx
  8008c7:	eb f0                	jmp    8008b9 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  8008c9:	83 c4 5c             	add    $0x5c,%esp
  8008cc:	5b                   	pop    %ebx
  8008cd:	5e                   	pop    %esi
  8008ce:	5f                   	pop    %edi
  8008cf:	5d                   	pop    %ebp
  8008d0:	c3                   	ret    

008008d1 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008d1:	55                   	push   %ebp
  8008d2:	89 e5                	mov    %esp,%ebp
  8008d4:	83 ec 28             	sub    $0x28,%esp
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8008dd:	85 c0                	test   %eax,%eax
  8008df:	74 04                	je     8008e5 <vsnprintf+0x14>
  8008e1:	85 d2                	test   %edx,%edx
  8008e3:	7f 07                	jg     8008ec <vsnprintf+0x1b>
  8008e5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ea:	eb 3b                	jmp    800927 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ef:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8008f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800900:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800904:	8b 45 10             	mov    0x10(%ebp),%eax
  800907:	89 44 24 08          	mov    %eax,0x8(%esp)
  80090b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80090e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800912:	c7 04 24 80 04 80 00 	movl   $0x800480,(%esp)
  800919:	e8 7f fb ff ff       	call   80049d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80091e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800921:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800924:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800927:	c9                   	leave  
  800928:	c3                   	ret    

00800929 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
  80092c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80092f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800932:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800936:	8b 45 10             	mov    0x10(%ebp),%eax
  800939:	89 44 24 08          	mov    %eax,0x8(%esp)
  80093d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800940:	89 44 24 04          	mov    %eax,0x4(%esp)
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	89 04 24             	mov    %eax,(%esp)
  80094a:	e8 82 ff ff ff       	call   8008d1 <vsnprintf>
	va_end(ap);

	return rc;
}
  80094f:	c9                   	leave  
  800950:	c3                   	ret    

00800951 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800957:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80095a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80095e:	8b 45 10             	mov    0x10(%ebp),%eax
  800961:	89 44 24 08          	mov    %eax,0x8(%esp)
  800965:	8b 45 0c             	mov    0xc(%ebp),%eax
  800968:	89 44 24 04          	mov    %eax,0x4(%esp)
  80096c:	8b 45 08             	mov    0x8(%ebp),%eax
  80096f:	89 04 24             	mov    %eax,(%esp)
  800972:	e8 26 fb ff ff       	call   80049d <vprintfmt>
	va_end(ap);
}
  800977:	c9                   	leave  
  800978:	c3                   	ret    
  800979:	00 00                	add    %al,(%eax)
  80097b:	00 00                	add    %al,(%eax)
  80097d:	00 00                	add    %al,(%eax)
	...

00800980 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800980:	55                   	push   %ebp
  800981:	89 e5                	mov    %esp,%ebp
  800983:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800986:	b8 00 00 00 00       	mov    $0x0,%eax
  80098b:	80 3a 00             	cmpb   $0x0,(%edx)
  80098e:	74 09                	je     800999 <strlen+0x19>
		n++;
  800990:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800993:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800997:	75 f7                	jne    800990 <strlen+0x10>
		n++;
	return n;
}
  800999:	5d                   	pop    %ebp
  80099a:	c3                   	ret    

0080099b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80099b:	55                   	push   %ebp
  80099c:	89 e5                	mov    %esp,%ebp
  80099e:	53                   	push   %ebx
  80099f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8009a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009a5:	85 c9                	test   %ecx,%ecx
  8009a7:	74 19                	je     8009c2 <strnlen+0x27>
  8009a9:	80 3b 00             	cmpb   $0x0,(%ebx)
  8009ac:	74 14                	je     8009c2 <strnlen+0x27>
  8009ae:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8009b3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8009b6:	39 c8                	cmp    %ecx,%eax
  8009b8:	74 0d                	je     8009c7 <strnlen+0x2c>
  8009ba:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8009be:	75 f3                	jne    8009b3 <strnlen+0x18>
  8009c0:	eb 05                	jmp    8009c7 <strnlen+0x2c>
  8009c2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8009c7:	5b                   	pop    %ebx
  8009c8:	5d                   	pop    %ebp
  8009c9:	c3                   	ret    

008009ca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	53                   	push   %ebx
  8009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8009d4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8009d9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8009dd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8009e0:	83 c2 01             	add    $0x1,%edx
  8009e3:	84 c9                	test   %cl,%cl
  8009e5:	75 f2                	jne    8009d9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8009e7:	5b                   	pop    %ebx
  8009e8:	5d                   	pop    %ebp
  8009e9:	c3                   	ret    

008009ea <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	56                   	push   %esi
  8009ee:	53                   	push   %ebx
  8009ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009f5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009f8:	85 f6                	test   %esi,%esi
  8009fa:	74 18                	je     800a14 <strncpy+0x2a>
  8009fc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800a01:	0f b6 1a             	movzbl (%edx),%ebx
  800a04:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800a07:	80 3a 01             	cmpb   $0x1,(%edx)
  800a0a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800a0d:	83 c1 01             	add    $0x1,%ecx
  800a10:	39 ce                	cmp    %ecx,%esi
  800a12:	77 ed                	ja     800a01 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800a14:	5b                   	pop    %ebx
  800a15:	5e                   	pop    %esi
  800a16:	5d                   	pop    %ebp
  800a17:	c3                   	ret    

00800a18 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	56                   	push   %esi
  800a1c:	53                   	push   %ebx
  800a1d:	8b 75 08             	mov    0x8(%ebp),%esi
  800a20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a23:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a26:	89 f0                	mov    %esi,%eax
  800a28:	85 c9                	test   %ecx,%ecx
  800a2a:	74 27                	je     800a53 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800a2c:	83 e9 01             	sub    $0x1,%ecx
  800a2f:	74 1d                	je     800a4e <strlcpy+0x36>
  800a31:	0f b6 1a             	movzbl (%edx),%ebx
  800a34:	84 db                	test   %bl,%bl
  800a36:	74 16                	je     800a4e <strlcpy+0x36>
			*dst++ = *src++;
  800a38:	88 18                	mov    %bl,(%eax)
  800a3a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a3d:	83 e9 01             	sub    $0x1,%ecx
  800a40:	74 0e                	je     800a50 <strlcpy+0x38>
			*dst++ = *src++;
  800a42:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800a45:	0f b6 1a             	movzbl (%edx),%ebx
  800a48:	84 db                	test   %bl,%bl
  800a4a:	75 ec                	jne    800a38 <strlcpy+0x20>
  800a4c:	eb 02                	jmp    800a50 <strlcpy+0x38>
  800a4e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800a50:	c6 00 00             	movb   $0x0,(%eax)
  800a53:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800a55:	5b                   	pop    %ebx
  800a56:	5e                   	pop    %esi
  800a57:	5d                   	pop    %ebp
  800a58:	c3                   	ret    

00800a59 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a5f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a62:	0f b6 01             	movzbl (%ecx),%eax
  800a65:	84 c0                	test   %al,%al
  800a67:	74 15                	je     800a7e <strcmp+0x25>
  800a69:	3a 02                	cmp    (%edx),%al
  800a6b:	75 11                	jne    800a7e <strcmp+0x25>
		p++, q++;
  800a6d:	83 c1 01             	add    $0x1,%ecx
  800a70:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a73:	0f b6 01             	movzbl (%ecx),%eax
  800a76:	84 c0                	test   %al,%al
  800a78:	74 04                	je     800a7e <strcmp+0x25>
  800a7a:	3a 02                	cmp    (%edx),%al
  800a7c:	74 ef                	je     800a6d <strcmp+0x14>
  800a7e:	0f b6 c0             	movzbl %al,%eax
  800a81:	0f b6 12             	movzbl (%edx),%edx
  800a84:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a86:	5d                   	pop    %ebp
  800a87:	c3                   	ret    

00800a88 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a88:	55                   	push   %ebp
  800a89:	89 e5                	mov    %esp,%ebp
  800a8b:	53                   	push   %ebx
  800a8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a92:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800a95:	85 c0                	test   %eax,%eax
  800a97:	74 23                	je     800abc <strncmp+0x34>
  800a99:	0f b6 1a             	movzbl (%edx),%ebx
  800a9c:	84 db                	test   %bl,%bl
  800a9e:	74 24                	je     800ac4 <strncmp+0x3c>
  800aa0:	3a 19                	cmp    (%ecx),%bl
  800aa2:	75 20                	jne    800ac4 <strncmp+0x3c>
  800aa4:	83 e8 01             	sub    $0x1,%eax
  800aa7:	74 13                	je     800abc <strncmp+0x34>
		n--, p++, q++;
  800aa9:	83 c2 01             	add    $0x1,%edx
  800aac:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800aaf:	0f b6 1a             	movzbl (%edx),%ebx
  800ab2:	84 db                	test   %bl,%bl
  800ab4:	74 0e                	je     800ac4 <strncmp+0x3c>
  800ab6:	3a 19                	cmp    (%ecx),%bl
  800ab8:	74 ea                	je     800aa4 <strncmp+0x1c>
  800aba:	eb 08                	jmp    800ac4 <strncmp+0x3c>
  800abc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ac1:	5b                   	pop    %ebx
  800ac2:	5d                   	pop    %ebp
  800ac3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ac4:	0f b6 02             	movzbl (%edx),%eax
  800ac7:	0f b6 11             	movzbl (%ecx),%edx
  800aca:	29 d0                	sub    %edx,%eax
  800acc:	eb f3                	jmp    800ac1 <strncmp+0x39>

00800ace <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ad8:	0f b6 10             	movzbl (%eax),%edx
  800adb:	84 d2                	test   %dl,%dl
  800add:	74 15                	je     800af4 <strchr+0x26>
		if (*s == c)
  800adf:	38 ca                	cmp    %cl,%dl
  800ae1:	75 07                	jne    800aea <strchr+0x1c>
  800ae3:	eb 14                	jmp    800af9 <strchr+0x2b>
  800ae5:	38 ca                	cmp    %cl,%dl
  800ae7:	90                   	nop
  800ae8:	74 0f                	je     800af9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800aea:	83 c0 01             	add    $0x1,%eax
  800aed:	0f b6 10             	movzbl (%eax),%edx
  800af0:	84 d2                	test   %dl,%dl
  800af2:	75 f1                	jne    800ae5 <strchr+0x17>
  800af4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800af9:	5d                   	pop    %ebp
  800afa:	c3                   	ret    

00800afb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800b05:	0f b6 10             	movzbl (%eax),%edx
  800b08:	84 d2                	test   %dl,%dl
  800b0a:	74 18                	je     800b24 <strfind+0x29>
		if (*s == c)
  800b0c:	38 ca                	cmp    %cl,%dl
  800b0e:	75 0a                	jne    800b1a <strfind+0x1f>
  800b10:	eb 12                	jmp    800b24 <strfind+0x29>
  800b12:	38 ca                	cmp    %cl,%dl
  800b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800b18:	74 0a                	je     800b24 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800b1a:	83 c0 01             	add    $0x1,%eax
  800b1d:	0f b6 10             	movzbl (%eax),%edx
  800b20:	84 d2                	test   %dl,%dl
  800b22:	75 ee                	jne    800b12 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800b24:	5d                   	pop    %ebp
  800b25:	c3                   	ret    

00800b26 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
  800b29:	83 ec 0c             	sub    $0xc,%esp
  800b2c:	89 1c 24             	mov    %ebx,(%esp)
  800b2f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b33:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800b37:	8b 7d 08             	mov    0x8(%ebp),%edi
  800b3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800b40:	85 c9                	test   %ecx,%ecx
  800b42:	74 30                	je     800b74 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b44:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b4a:	75 25                	jne    800b71 <memset+0x4b>
  800b4c:	f6 c1 03             	test   $0x3,%cl
  800b4f:	75 20                	jne    800b71 <memset+0x4b>
		c &= 0xFF;
  800b51:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800b54:	89 d3                	mov    %edx,%ebx
  800b56:	c1 e3 08             	shl    $0x8,%ebx
  800b59:	89 d6                	mov    %edx,%esi
  800b5b:	c1 e6 18             	shl    $0x18,%esi
  800b5e:	89 d0                	mov    %edx,%eax
  800b60:	c1 e0 10             	shl    $0x10,%eax
  800b63:	09 f0                	or     %esi,%eax
  800b65:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800b67:	09 d8                	or     %ebx,%eax
  800b69:	c1 e9 02             	shr    $0x2,%ecx
  800b6c:	fc                   	cld    
  800b6d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b6f:	eb 03                	jmp    800b74 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b71:	fc                   	cld    
  800b72:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b74:	89 f8                	mov    %edi,%eax
  800b76:	8b 1c 24             	mov    (%esp),%ebx
  800b79:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b7d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b81:	89 ec                	mov    %ebp,%esp
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	83 ec 08             	sub    $0x8,%esp
  800b8b:	89 34 24             	mov    %esi,(%esp)
  800b8e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800b98:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800b9b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800b9d:	39 c6                	cmp    %eax,%esi
  800b9f:	73 35                	jae    800bd6 <memmove+0x51>
  800ba1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ba4:	39 d0                	cmp    %edx,%eax
  800ba6:	73 2e                	jae    800bd6 <memmove+0x51>
		s += n;
		d += n;
  800ba8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800baa:	f6 c2 03             	test   $0x3,%dl
  800bad:	75 1b                	jne    800bca <memmove+0x45>
  800baf:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800bb5:	75 13                	jne    800bca <memmove+0x45>
  800bb7:	f6 c1 03             	test   $0x3,%cl
  800bba:	75 0e                	jne    800bca <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800bbc:	83 ef 04             	sub    $0x4,%edi
  800bbf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800bc2:	c1 e9 02             	shr    $0x2,%ecx
  800bc5:	fd                   	std    
  800bc6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bc8:	eb 09                	jmp    800bd3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800bca:	83 ef 01             	sub    $0x1,%edi
  800bcd:	8d 72 ff             	lea    -0x1(%edx),%esi
  800bd0:	fd                   	std    
  800bd1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800bd3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800bd4:	eb 20                	jmp    800bf6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bd6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800bdc:	75 15                	jne    800bf3 <memmove+0x6e>
  800bde:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800be4:	75 0d                	jne    800bf3 <memmove+0x6e>
  800be6:	f6 c1 03             	test   $0x3,%cl
  800be9:	75 08                	jne    800bf3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800beb:	c1 e9 02             	shr    $0x2,%ecx
  800bee:	fc                   	cld    
  800bef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800bf1:	eb 03                	jmp    800bf6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800bf3:	fc                   	cld    
  800bf4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800bf6:	8b 34 24             	mov    (%esp),%esi
  800bf9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800bfd:	89 ec                	mov    %ebp,%esp
  800bff:	5d                   	pop    %ebp
  800c00:	c3                   	ret    

00800c01 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800c01:	55                   	push   %ebp
  800c02:	89 e5                	mov    %esp,%ebp
  800c04:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800c07:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c11:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c15:	8b 45 08             	mov    0x8(%ebp),%eax
  800c18:	89 04 24             	mov    %eax,(%esp)
  800c1b:	e8 65 ff ff ff       	call   800b85 <memmove>
}
  800c20:	c9                   	leave  
  800c21:	c3                   	ret    

00800c22 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800c22:	55                   	push   %ebp
  800c23:	89 e5                	mov    %esp,%ebp
  800c25:	57                   	push   %edi
  800c26:	56                   	push   %esi
  800c27:	53                   	push   %ebx
  800c28:	8b 75 08             	mov    0x8(%ebp),%esi
  800c2b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800c2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c31:	85 c9                	test   %ecx,%ecx
  800c33:	74 36                	je     800c6b <memcmp+0x49>
		if (*s1 != *s2)
  800c35:	0f b6 06             	movzbl (%esi),%eax
  800c38:	0f b6 1f             	movzbl (%edi),%ebx
  800c3b:	38 d8                	cmp    %bl,%al
  800c3d:	74 20                	je     800c5f <memcmp+0x3d>
  800c3f:	eb 14                	jmp    800c55 <memcmp+0x33>
  800c41:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800c46:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800c4b:	83 c2 01             	add    $0x1,%edx
  800c4e:	83 e9 01             	sub    $0x1,%ecx
  800c51:	38 d8                	cmp    %bl,%al
  800c53:	74 12                	je     800c67 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800c55:	0f b6 c0             	movzbl %al,%eax
  800c58:	0f b6 db             	movzbl %bl,%ebx
  800c5b:	29 d8                	sub    %ebx,%eax
  800c5d:	eb 11                	jmp    800c70 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800c5f:	83 e9 01             	sub    $0x1,%ecx
  800c62:	ba 00 00 00 00       	mov    $0x0,%edx
  800c67:	85 c9                	test   %ecx,%ecx
  800c69:	75 d6                	jne    800c41 <memcmp+0x1f>
  800c6b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800c70:	5b                   	pop    %ebx
  800c71:	5e                   	pop    %esi
  800c72:	5f                   	pop    %edi
  800c73:	5d                   	pop    %ebp
  800c74:	c3                   	ret    

00800c75 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c75:	55                   	push   %ebp
  800c76:	89 e5                	mov    %esp,%ebp
  800c78:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c7b:	89 c2                	mov    %eax,%edx
  800c7d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c80:	39 d0                	cmp    %edx,%eax
  800c82:	73 15                	jae    800c99 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c84:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c88:	38 08                	cmp    %cl,(%eax)
  800c8a:	75 06                	jne    800c92 <memfind+0x1d>
  800c8c:	eb 0b                	jmp    800c99 <memfind+0x24>
  800c8e:	38 08                	cmp    %cl,(%eax)
  800c90:	74 07                	je     800c99 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c92:	83 c0 01             	add    $0x1,%eax
  800c95:	39 c2                	cmp    %eax,%edx
  800c97:	77 f5                	ja     800c8e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c99:	5d                   	pop    %ebp
  800c9a:	c3                   	ret    

00800c9b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	83 ec 04             	sub    $0x4,%esp
  800ca4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800caa:	0f b6 02             	movzbl (%edx),%eax
  800cad:	3c 20                	cmp    $0x20,%al
  800caf:	74 04                	je     800cb5 <strtol+0x1a>
  800cb1:	3c 09                	cmp    $0x9,%al
  800cb3:	75 0e                	jne    800cc3 <strtol+0x28>
		s++;
  800cb5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800cb8:	0f b6 02             	movzbl (%edx),%eax
  800cbb:	3c 20                	cmp    $0x20,%al
  800cbd:	74 f6                	je     800cb5 <strtol+0x1a>
  800cbf:	3c 09                	cmp    $0x9,%al
  800cc1:	74 f2                	je     800cb5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800cc3:	3c 2b                	cmp    $0x2b,%al
  800cc5:	75 0c                	jne    800cd3 <strtol+0x38>
		s++;
  800cc7:	83 c2 01             	add    $0x1,%edx
  800cca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cd1:	eb 15                	jmp    800ce8 <strtol+0x4d>
	else if (*s == '-')
  800cd3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cda:	3c 2d                	cmp    $0x2d,%al
  800cdc:	75 0a                	jne    800ce8 <strtol+0x4d>
		s++, neg = 1;
  800cde:	83 c2 01             	add    $0x1,%edx
  800ce1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ce8:	85 db                	test   %ebx,%ebx
  800cea:	0f 94 c0             	sete   %al
  800ced:	74 05                	je     800cf4 <strtol+0x59>
  800cef:	83 fb 10             	cmp    $0x10,%ebx
  800cf2:	75 18                	jne    800d0c <strtol+0x71>
  800cf4:	80 3a 30             	cmpb   $0x30,(%edx)
  800cf7:	75 13                	jne    800d0c <strtol+0x71>
  800cf9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800cfd:	8d 76 00             	lea    0x0(%esi),%esi
  800d00:	75 0a                	jne    800d0c <strtol+0x71>
		s += 2, base = 16;
  800d02:	83 c2 02             	add    $0x2,%edx
  800d05:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d0a:	eb 15                	jmp    800d21 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d0c:	84 c0                	test   %al,%al
  800d0e:	66 90                	xchg   %ax,%ax
  800d10:	74 0f                	je     800d21 <strtol+0x86>
  800d12:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800d17:	80 3a 30             	cmpb   $0x30,(%edx)
  800d1a:	75 05                	jne    800d21 <strtol+0x86>
		s++, base = 8;
  800d1c:	83 c2 01             	add    $0x1,%edx
  800d1f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d21:	b8 00 00 00 00       	mov    $0x0,%eax
  800d26:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800d28:	0f b6 0a             	movzbl (%edx),%ecx
  800d2b:	89 cf                	mov    %ecx,%edi
  800d2d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800d30:	80 fb 09             	cmp    $0x9,%bl
  800d33:	77 08                	ja     800d3d <strtol+0xa2>
			dig = *s - '0';
  800d35:	0f be c9             	movsbl %cl,%ecx
  800d38:	83 e9 30             	sub    $0x30,%ecx
  800d3b:	eb 1e                	jmp    800d5b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800d3d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800d40:	80 fb 19             	cmp    $0x19,%bl
  800d43:	77 08                	ja     800d4d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800d45:	0f be c9             	movsbl %cl,%ecx
  800d48:	83 e9 57             	sub    $0x57,%ecx
  800d4b:	eb 0e                	jmp    800d5b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800d4d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800d50:	80 fb 19             	cmp    $0x19,%bl
  800d53:	77 15                	ja     800d6a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800d55:	0f be c9             	movsbl %cl,%ecx
  800d58:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800d5b:	39 f1                	cmp    %esi,%ecx
  800d5d:	7d 0b                	jge    800d6a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800d5f:	83 c2 01             	add    $0x1,%edx
  800d62:	0f af c6             	imul   %esi,%eax
  800d65:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800d68:	eb be                	jmp    800d28 <strtol+0x8d>
  800d6a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800d6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d70:	74 05                	je     800d77 <strtol+0xdc>
		*endptr = (char *) s;
  800d72:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d75:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d7b:	74 04                	je     800d81 <strtol+0xe6>
  800d7d:	89 c8                	mov    %ecx,%eax
  800d7f:	f7 d8                	neg    %eax
}
  800d81:	83 c4 04             	add    $0x4,%esp
  800d84:	5b                   	pop    %ebx
  800d85:	5e                   	pop    %esi
  800d86:	5f                   	pop    %edi
  800d87:	5d                   	pop    %ebp
  800d88:	c3                   	ret    
  800d89:	00 00                	add    %al,(%eax)
	...

00800d8c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	83 ec 0c             	sub    $0xc,%esp
  800d92:	89 1c 24             	mov    %ebx,(%esp)
  800d95:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d99:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800da2:	b8 01 00 00 00       	mov    $0x1,%eax
  800da7:	89 d1                	mov    %edx,%ecx
  800da9:	89 d3                	mov    %edx,%ebx
  800dab:	89 d7                	mov    %edx,%edi
  800dad:	89 d6                	mov    %edx,%esi
  800daf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800db1:	8b 1c 24             	mov    (%esp),%ebx
  800db4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800db8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dbc:	89 ec                	mov    %ebp,%esp
  800dbe:	5d                   	pop    %ebp
  800dbf:	c3                   	ret    

00800dc0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	83 ec 0c             	sub    $0xc,%esp
  800dc6:	89 1c 24             	mov    %ebx,(%esp)
  800dc9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800dcd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddc:	89 c3                	mov    %eax,%ebx
  800dde:	89 c7                	mov    %eax,%edi
  800de0:	89 c6                	mov    %eax,%esi
  800de2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800de4:	8b 1c 24             	mov    (%esp),%ebx
  800de7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800deb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800def:	89 ec                	mov    %ebp,%esp
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	83 ec 0c             	sub    $0xc,%esp
  800df9:	89 1c 24             	mov    %ebx,(%esp)
  800dfc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e00:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e09:	b8 10 00 00 00       	mov    $0x10,%eax
  800e0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e11:	8b 55 08             	mov    0x8(%ebp),%edx
  800e14:	89 df                	mov    %ebx,%edi
  800e16:	89 de                	mov    %ebx,%esi
  800e18:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800e1a:	8b 1c 24             	mov    (%esp),%ebx
  800e1d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e21:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e25:	89 ec                	mov    %ebp,%esp
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    

00800e29 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
  800e2c:	83 ec 38             	sub    $0x38,%esp
  800e2f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e32:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e35:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e38:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e42:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e45:	8b 55 08             	mov    0x8(%ebp),%edx
  800e48:	89 df                	mov    %ebx,%edi
  800e4a:	89 de                	mov    %ebx,%esi
  800e4c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e4e:	85 c0                	test   %eax,%eax
  800e50:	7e 28                	jle    800e7a <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e52:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e56:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800e5d:	00 
  800e5e:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  800e65:	00 
  800e66:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e6d:	00 
  800e6e:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  800e75:	e8 aa f3 ff ff       	call   800224 <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800e7a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e7d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e80:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e83:	89 ec                	mov    %ebp,%esp
  800e85:	5d                   	pop    %ebp
  800e86:	c3                   	ret    

00800e87 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	83 ec 0c             	sub    $0xc,%esp
  800e8d:	89 1c 24             	mov    %ebx,(%esp)
  800e90:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e94:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e98:	ba 00 00 00 00       	mov    $0x0,%edx
  800e9d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800ea2:	89 d1                	mov    %edx,%ecx
  800ea4:	89 d3                	mov    %edx,%ebx
  800ea6:	89 d7                	mov    %edx,%edi
  800ea8:	89 d6                	mov    %edx,%esi
  800eaa:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800eac:	8b 1c 24             	mov    (%esp),%ebx
  800eaf:	8b 74 24 04          	mov    0x4(%esp),%esi
  800eb3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800eb7:	89 ec                	mov    %ebp,%esp
  800eb9:	5d                   	pop    %ebp
  800eba:	c3                   	ret    

00800ebb <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	83 ec 38             	sub    $0x38,%esp
  800ec1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ec4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ec7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eca:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ecf:	b8 0d 00 00 00       	mov    $0xd,%eax
  800ed4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed7:	89 cb                	mov    %ecx,%ebx
  800ed9:	89 cf                	mov    %ecx,%edi
  800edb:	89 ce                	mov    %ecx,%esi
  800edd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800edf:	85 c0                	test   %eax,%eax
  800ee1:	7e 28                	jle    800f0b <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ee3:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ee7:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800eee:	00 
  800eef:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  800ef6:	00 
  800ef7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800efe:	00 
  800eff:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  800f06:	e8 19 f3 ff ff       	call   800224 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f0b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f0e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f11:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f14:	89 ec                	mov    %ebp,%esp
  800f16:	5d                   	pop    %ebp
  800f17:	c3                   	ret    

00800f18 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 0c             	sub    $0xc,%esp
  800f1e:	89 1c 24             	mov    %ebx,(%esp)
  800f21:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f25:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f29:	be 00 00 00 00       	mov    $0x0,%esi
  800f2e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800f33:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f36:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f41:	8b 1c 24             	mov    (%esp),%ebx
  800f44:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f48:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f4c:	89 ec                	mov    %ebp,%esp
  800f4e:	5d                   	pop    %ebp
  800f4f:	c3                   	ret    

00800f50 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800f50:	55                   	push   %ebp
  800f51:	89 e5                	mov    %esp,%ebp
  800f53:	83 ec 38             	sub    $0x38,%esp
  800f56:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f59:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f5c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f5f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f64:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6f:	89 df                	mov    %ebx,%edi
  800f71:	89 de                	mov    %ebx,%esi
  800f73:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f75:	85 c0                	test   %eax,%eax
  800f77:	7e 28                	jle    800fa1 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f79:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f7d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f84:	00 
  800f85:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  800f8c:	00 
  800f8d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f94:	00 
  800f95:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  800f9c:	e8 83 f2 ff ff       	call   800224 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800fa1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fa4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fa7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800faa:	89 ec                	mov    %ebp,%esp
  800fac:	5d                   	pop    %ebp
  800fad:	c3                   	ret    

00800fae <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800fae:	55                   	push   %ebp
  800faf:	89 e5                	mov    %esp,%ebp
  800fb1:	83 ec 38             	sub    $0x38,%esp
  800fb4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fb7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fba:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbd:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc2:	b8 09 00 00 00       	mov    $0x9,%eax
  800fc7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fca:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcd:	89 df                	mov    %ebx,%edi
  800fcf:	89 de                	mov    %ebx,%esi
  800fd1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	7e 28                	jle    800fff <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd7:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fdb:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800fe2:	00 
  800fe3:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  800fea:	00 
  800feb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff2:	00 
  800ff3:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  800ffa:	e8 25 f2 ff ff       	call   800224 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800fff:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801002:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801005:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801008:	89 ec                	mov    %ebp,%esp
  80100a:	5d                   	pop    %ebp
  80100b:	c3                   	ret    

0080100c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 38             	sub    $0x38,%esp
  801012:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801015:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801018:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80101b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801020:	b8 08 00 00 00       	mov    $0x8,%eax
  801025:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801028:	8b 55 08             	mov    0x8(%ebp),%edx
  80102b:	89 df                	mov    %ebx,%edi
  80102d:	89 de                	mov    %ebx,%esi
  80102f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801031:	85 c0                	test   %eax,%eax
  801033:	7e 28                	jle    80105d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801035:	89 44 24 10          	mov    %eax,0x10(%esp)
  801039:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801040:	00 
  801041:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  801048:	00 
  801049:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801050:	00 
  801051:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  801058:	e8 c7 f1 ff ff       	call   800224 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80105d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801060:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801063:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801066:	89 ec                	mov    %ebp,%esp
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    

0080106a <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	83 ec 38             	sub    $0x38,%esp
  801070:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801073:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801076:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801079:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107e:	b8 06 00 00 00       	mov    $0x6,%eax
  801083:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801086:	8b 55 08             	mov    0x8(%ebp),%edx
  801089:	89 df                	mov    %ebx,%edi
  80108b:	89 de                	mov    %ebx,%esi
  80108d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80108f:	85 c0                	test   %eax,%eax
  801091:	7e 28                	jle    8010bb <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801093:	89 44 24 10          	mov    %eax,0x10(%esp)
  801097:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80109e:	00 
  80109f:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  8010a6:	00 
  8010a7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010ae:	00 
  8010af:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  8010b6:	e8 69 f1 ff ff       	call   800224 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8010bb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010be:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010c1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010c4:	89 ec                	mov    %ebp,%esp
  8010c6:	5d                   	pop    %ebp
  8010c7:	c3                   	ret    

008010c8 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8010c8:	55                   	push   %ebp
  8010c9:	89 e5                	mov    %esp,%ebp
  8010cb:	83 ec 38             	sub    $0x38,%esp
  8010ce:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010d1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010d4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d7:	b8 05 00 00 00       	mov    $0x5,%eax
  8010dc:	8b 75 18             	mov    0x18(%ebp),%esi
  8010df:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8010eb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010ed:	85 c0                	test   %eax,%eax
  8010ef:	7e 28                	jle    801119 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010f5:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8010fc:	00 
  8010fd:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  801104:	00 
  801105:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80110c:	00 
  80110d:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  801114:	e8 0b f1 ff ff       	call   800224 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801119:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80111c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80111f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801122:	89 ec                	mov    %ebp,%esp
  801124:	5d                   	pop    %ebp
  801125:	c3                   	ret    

00801126 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801126:	55                   	push   %ebp
  801127:	89 e5                	mov    %esp,%ebp
  801129:	83 ec 38             	sub    $0x38,%esp
  80112c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80112f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801132:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801135:	be 00 00 00 00       	mov    $0x0,%esi
  80113a:	b8 04 00 00 00       	mov    $0x4,%eax
  80113f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801142:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801145:	8b 55 08             	mov    0x8(%ebp),%edx
  801148:	89 f7                	mov    %esi,%edi
  80114a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80114c:	85 c0                	test   %eax,%eax
  80114e:	7e 28                	jle    801178 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801150:	89 44 24 10          	mov    %eax,0x10(%esp)
  801154:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80115b:	00 
  80115c:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  801163:	00 
  801164:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80116b:	00 
  80116c:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  801173:	e8 ac f0 ff ff       	call   800224 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801178:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80117b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80117e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801181:	89 ec                	mov    %ebp,%esp
  801183:	5d                   	pop    %ebp
  801184:	c3                   	ret    

00801185 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  801185:	55                   	push   %ebp
  801186:	89 e5                	mov    %esp,%ebp
  801188:	83 ec 0c             	sub    $0xc,%esp
  80118b:	89 1c 24             	mov    %ebx,(%esp)
  80118e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801192:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801196:	ba 00 00 00 00       	mov    $0x0,%edx
  80119b:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011a0:	89 d1                	mov    %edx,%ecx
  8011a2:	89 d3                	mov    %edx,%ebx
  8011a4:	89 d7                	mov    %edx,%edi
  8011a6:	89 d6                	mov    %edx,%esi
  8011a8:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011aa:	8b 1c 24             	mov    (%esp),%ebx
  8011ad:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011b1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011b5:	89 ec                	mov    %ebp,%esp
  8011b7:	5d                   	pop    %ebp
  8011b8:	c3                   	ret    

008011b9 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
  8011bc:	83 ec 0c             	sub    $0xc,%esp
  8011bf:	89 1c 24             	mov    %ebx,(%esp)
  8011c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011c6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8011cf:	b8 02 00 00 00       	mov    $0x2,%eax
  8011d4:	89 d1                	mov    %edx,%ecx
  8011d6:	89 d3                	mov    %edx,%ebx
  8011d8:	89 d7                	mov    %edx,%edi
  8011da:	89 d6                	mov    %edx,%esi
  8011dc:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8011de:	8b 1c 24             	mov    (%esp),%ebx
  8011e1:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011e5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011e9:	89 ec                	mov    %ebp,%esp
  8011eb:	5d                   	pop    %ebp
  8011ec:	c3                   	ret    

008011ed <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	83 ec 38             	sub    $0x38,%esp
  8011f3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011f6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011f9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801201:	b8 03 00 00 00       	mov    $0x3,%eax
  801206:	8b 55 08             	mov    0x8(%ebp),%edx
  801209:	89 cb                	mov    %ecx,%ebx
  80120b:	89 cf                	mov    %ecx,%edi
  80120d:	89 ce                	mov    %ecx,%esi
  80120f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801211:	85 c0                	test   %eax,%eax
  801213:	7e 28                	jle    80123d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801215:	89 44 24 10          	mov    %eax,0x10(%esp)
  801219:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801220:	00 
  801221:	c7 44 24 08 ff 37 80 	movl   $0x8037ff,0x8(%esp)
  801228:	00 
  801229:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801230:	00 
  801231:	c7 04 24 1c 38 80 00 	movl   $0x80381c,(%esp)
  801238:	e8 e7 ef ff ff       	call   800224 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80123d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801240:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801243:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801246:	89 ec                	mov    %ebp,%esp
  801248:	5d                   	pop    %ebp
  801249:	c3                   	ret    
	...

0080124c <sfork>:
}

// Challenge!
int
sfork(void)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801252:	c7 44 24 08 2a 38 80 	movl   $0x80382a,0x8(%esp)
  801259:	00 
  80125a:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  801261:	00 
  801262:	c7 04 24 40 38 80 00 	movl   $0x803840,(%esp)
  801269:	e8 b6 ef ff ff       	call   800224 <_panic>

0080126e <duppage>:
// It is also OK to panic on error.
// 

static int
duppage(envid_t envid, unsigned pn)
{
  80126e:	55                   	push   %ebp
  80126f:	89 e5                	mov    %esp,%ebp
  801271:	83 ec 28             	sub    $0x28,%esp
  801274:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801277:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80127a:	89 c3                	mov    %eax,%ebx
	int r;

	// LAB 4: Your code here.
     pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  80127c:	89 d6                	mov    %edx,%esi
  80127e:	c1 e6 0c             	shl    $0xc,%esi
  801281:	89 f0                	mov    %esi,%eax
  801283:	c1 e8 16             	shr    $0x16,%eax
  801286:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
       
        if( 0 == pgDirEntry )
  80128d:	85 c0                	test   %eax,%eax
  80128f:	0f 84 fc 00 00 00    	je     801391 <duppage+0x123>
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  801295:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80129c:	89 c2                	mov    %eax,%edx
  80129e:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        //cprintf("Below %d",vpt[pn]);
                //if(perm!=0)  //commented nw.
                   // cprintf("perm bit %d",perm);
	
	
	if((perm & PTE_W) && (perm & PTE_SHARE))
  8012a4:	25 02 04 00 00       	and    $0x402,%eax
  8012a9:	3d 02 04 00 00       	cmp    $0x402,%eax
  8012ae:	75 4d                	jne    8012fd <duppage+0x8f>
	{	
		if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_SHARE|(perm & PTE_USER))) < 0)
  8012b0:	81 e2 07 0a 00 00    	and    $0xa07,%edx
  8012b6:	80 ce 04             	or     $0x4,%dh
  8012b9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8012bd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8012c1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012c5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8012d0:	e8 f3 fd ff ff       	call   8010c8 <sys_page_map>
  8012d5:	85 c0                	test   %eax,%eax
  8012d7:	0f 89 bb 00 00 00    	jns    801398 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  8012dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8012e1:	c7 44 24 08 4b 38 80 	movl   $0x80384b,0x8(%esp)
  8012e8:	00 
  8012e9:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  8012f0:	00 
  8012f1:	c7 04 24 40 38 80 00 	movl   $0x803840,(%esp)
  8012f8:	e8 27 ef ff ff       	call   800224 <_panic>
	}	


        else if((perm & PTE_W)!=0 || (perm & PTE_COW)!=0)
  8012fd:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801303:	0f 84 8f 00 00 00    	je     801398 <duppage+0x12a>
         {
          //cprintf("\nInside Setting Cow\n"); 
        if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  801309:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801310:	00 
  801311:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801315:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801319:	89 74 24 04          	mov    %esi,0x4(%esp)
  80131d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801324:	e8 9f fd ff ff       	call   8010c8 <sys_page_map>
  801329:	85 c0                	test   %eax,%eax
  80132b:	79 20                	jns    80134d <duppage+0xdf>
                panic("sys_page_map: %e", r);
  80132d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801331:	c7 44 24 08 4b 38 80 	movl   $0x80384b,0x8(%esp)
  801338:	00 
  801339:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801340:	00 
  801341:	c7 04 24 40 38 80 00 	movl   $0x803840,(%esp)
  801348:	e8 d7 ee ff ff       	call   800224 <_panic>
        if ((r = sys_page_map(envid,(void *)(pn*PGSIZE),0,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  80134d:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801354:	00 
  801355:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801359:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801360:	00 
  801361:	89 74 24 04          	mov    %esi,0x4(%esp)
  801365:	89 1c 24             	mov    %ebx,(%esp)
  801368:	e8 5b fd ff ff       	call   8010c8 <sys_page_map>
  80136d:	85 c0                	test   %eax,%eax
  80136f:	79 27                	jns    801398 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  801371:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801375:	c7 44 24 08 4b 38 80 	movl   $0x80384b,0x8(%esp)
  80137c:	00 
  80137d:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801384:	00 
  801385:	c7 04 24 40 38 80 00 	movl   $0x803840,(%esp)
  80138c:	e8 93 ee ff ff       	call   800224 <_panic>
  801391:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801396:	eb 05                	jmp    80139d <duppage+0x12f>
  801398:	b8 00 00 00 00       	mov    $0x0,%eax
         }


//	panic("duppage not implemented");
	return 0;
}
  80139d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8013a0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8013a3:	89 ec                	mov    %ebp,%esp
  8013a5:	5d                   	pop    %ebp
  8013a6:	c3                   	ret    

008013a7 <fork>:
//


envid_t
fork(void)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	56                   	push   %esi
  8013ab:	53                   	push   %ebx
  8013ac:	83 ec 10             	sub    $0x10,%esp

        envid_t envid;
        uint8_t *addr;
        int r;
        extern unsigned char end[];
        set_pgfault_handler(pgfault);
  8013af:	c7 04 24 be 14 80 00 	movl   $0x8014be,(%esp)
  8013b6:	e8 41 1c 00 00       	call   802ffc <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8013bb:	be 07 00 00 00       	mov    $0x7,%esi
  8013c0:	89 f0                	mov    %esi,%eax
  8013c2:	cd 30                	int    $0x30
  8013c4:	89 c6                	mov    %eax,%esi

        envid = sys_exofork();
        if (envid < 0)
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	79 20                	jns    8013ea <fork+0x43>
                panic("sys_exofork: %e", envid);
  8013ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8013ce:	c7 44 24 08 5c 38 80 	movl   $0x80385c,0x8(%esp)
  8013d5:	00 
  8013d6:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  8013dd:	00 
  8013de:	c7 04 24 40 38 80 00 	movl   $0x803840,(%esp)
  8013e5:	e8 3a ee ff ff       	call   800224 <_panic>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
  8013ea:	bb 00 00 80 00       	mov    $0x800000,%ebx
        set_pgfault_handler(pgfault);

        envid = sys_exofork();
        if (envid < 0)
                panic("sys_exofork: %e", envid);
        if (envid == 0) {
  8013ef:	85 c0                	test   %eax,%eax
  8013f1:	75 1c                	jne    80140f <fork+0x68>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
  8013f3:	e8 c1 fd ff ff       	call   8011b9 <sys_getenvid>
  8013f8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8013fd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801400:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801405:	a3 7c 70 80 00       	mov    %eax,0x80707c
                return 0;
  80140a:	e9 a6 00 00 00       	jmp    8014b5 <fork+0x10e>
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
  80140f:	89 da                	mov    %ebx,%edx
  801411:	c1 ea 0c             	shr    $0xc,%edx
  801414:	89 f0                	mov    %esi,%eax
  801416:	e8 53 fe ff ff       	call   80126e <duppage>
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
  80141b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801421:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801427:	75 e6                	jne    80140f <fork+0x68>
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
                }
              duppage(envid,VPN(USTACKTOP-PGSIZE));
  801429:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80142e:	89 f0                	mov    %esi,%eax
  801430:	e8 39 fe ff ff       	call   80126e <duppage>
        // Also copy the stack we are currently running on.
       //if(sys_page_alloc(envid, (void *)(ROUNDDOWN(&addr, PGSIZE)),PTE_U|PTE_P|PTE_W)<0)
         //                      panic("stack not allocated");
     
   
     sys_env_set_pgfault_upcall(envid,env->env_pgfault_upcall);
  801435:	a1 7c 70 80 00       	mov    0x80707c,%eax
  80143a:	8b 40 64             	mov    0x64(%eax),%eax
  80143d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801441:	89 34 24             	mov    %esi,(%esp)
  801444:	e8 07 fb ff ff       	call   800f50 <sys_env_set_pgfault_upcall>

     if(sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  801449:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801450:	00 
  801451:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801458:	ee 
  801459:	89 34 24             	mov    %esi,(%esp)
  80145c:	e8 c5 fc ff ff       	call   801126 <sys_page_alloc>
  801461:	85 c0                	test   %eax,%eax
  801463:	79 1c                	jns    801481 <fork+0xda>
                          panic("Cant allocate Page");
  801465:	c7 44 24 08 6c 38 80 	movl   $0x80386c,0x8(%esp)
  80146c:	00 
  80146d:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  801474:	00 
  801475:	c7 04 24 40 38 80 00 	movl   $0x803840,(%esp)
  80147c:	e8 a3 ed ff ff       	call   800224 <_panic>

        // Start the child environment running
        if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801481:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801488:	00 
  801489:	89 34 24             	mov    %esi,(%esp)
  80148c:	e8 7b fb ff ff       	call   80100c <sys_env_set_status>
  801491:	85 c0                	test   %eax,%eax
  801493:	79 20                	jns    8014b5 <fork+0x10e>
                panic("sys_env_set_status: %e", r);
  801495:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801499:	c7 44 24 08 7f 38 80 	movl   $0x80387f,0x8(%esp)
  8014a0:	00 
  8014a1:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  8014a8:	00 
  8014a9:	c7 04 24 40 38 80 00 	movl   $0x803840,(%esp)
  8014b0:	e8 6f ed ff ff       	call   800224 <_panic>
         return envid;
           
//panic("fork not implemented");
}
  8014b5:	89 f0                	mov    %esi,%eax
  8014b7:	83 c4 10             	add    $0x10,%esp
  8014ba:	5b                   	pop    %ebx
  8014bb:	5e                   	pop    %esi
  8014bc:	5d                   	pop    %ebp
  8014bd:	c3                   	ret    

008014be <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  8014be:	55                   	push   %ebp
  8014bf:	89 e5                	mov    %esp,%ebp
  8014c1:	53                   	push   %ebx
  8014c2:	83 ec 24             	sub    $0x24,%esp
  8014c5:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8014c8:	8b 18                	mov    (%eax),%ebx
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).
 
         int perm = vpt[VPN(addr)] & 0xFFF;
  8014ca:	89 da                	mov    %ebx,%edx
  8014cc:	c1 ea 0c             	shr    $0xc,%edx
  8014cf:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx

static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
  8014d6:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8014da:	74 21                	je     8014fd <pgfault+0x3f>
 
         int perm = vpt[VPN(addr)] & 0xFFF;
        if((err & FEC_WR)!=0)
           {
//              cprintf("\n>>>>>Due to write\n");
            if((perm & PTE_COW) == 0)
  8014dc:	f6 c6 08             	test   $0x8,%dh
  8014df:	75 1c                	jne    8014fd <pgfault+0x3f>
             {
                   panic("Not Set Cow");
  8014e1:	c7 44 24 08 96 38 80 	movl   $0x803896,0x8(%esp)
  8014e8:	00 
  8014e9:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8014f0:	00 
  8014f1:	c7 04 24 40 38 80 00 	movl   $0x803840,(%esp)
  8014f8:	e8 27 ed ff ff       	call   800224 <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
        if(sys_page_alloc(0,PFTEMP,PTE_P|PTE_U|PTE_W)<0)
  8014fd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801504:	00 
  801505:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80150c:	00 
  80150d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801514:	e8 0d fc ff ff       	call   801126 <sys_page_alloc>
  801519:	85 c0                	test   %eax,%eax
  80151b:	79 1c                	jns    801539 <pgfault+0x7b>
              panic("\nPage not allocated\n");
  80151d:	c7 44 24 08 a2 38 80 	movl   $0x8038a2,0x8(%esp)
  801524:	00 
  801525:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  80152c:	00 
  80152d:	c7 04 24 40 38 80 00 	movl   $0x803840,(%esp)
  801534:	e8 eb ec ff ff       	call   800224 <_panic>
           memmove(PFTEMP,ROUNDDOWN(addr,PGSIZE),PGSIZE);
  801539:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80153f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801546:	00 
  801547:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80154b:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801552:	e8 2e f6 ff ff       	call   800b85 <memmove>
          if(sys_page_map(0,ROUNDDOWN(PFTEMP,PGSIZE),0,ROUNDDOWN(addr,PGSIZE),PTE_U|PTE_P|PTE_W)<0)
  801557:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80155e:	00 
  80155f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801563:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80156a:	00 
  80156b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801572:	00 
  801573:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80157a:	e8 49 fb ff ff       	call   8010c8 <sys_page_map>
  80157f:	85 c0                	test   %eax,%eax
  801581:	79 1c                	jns    80159f <pgfault+0xe1>
                   panic("not mapped properly");
  801583:	c7 44 24 08 b7 38 80 	movl   $0x8038b7,0x8(%esp)
  80158a:	00 
  80158b:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801592:	00 
  801593:	c7 04 24 40 38 80 00 	movl   $0x803840,(%esp)
  80159a:	e8 85 ec ff ff       	call   800224 <_panic>
         if( 0 > sys_page_unmap(0, PFTEMP) )
  80159f:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8015a6:	00 
  8015a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015ae:	e8 b7 fa ff ff       	call   80106a <sys_page_unmap>
  8015b3:	85 c0                	test   %eax,%eax
  8015b5:	79 1c                	jns    8015d3 <pgfault+0x115>
                panic("sys_page_unmap failed\n");
  8015b7:	c7 44 24 08 cb 38 80 	movl   $0x8038cb,0x8(%esp)
  8015be:	00 
  8015bf:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  8015c6:	00 
  8015c7:	c7 04 24 40 38 80 00 	movl   $0x803840,(%esp)
  8015ce:	e8 51 ec ff ff       	call   800224 <_panic>
   
//	panic("pgfault not implemented");
}
  8015d3:	83 c4 24             	add    $0x24,%esp
  8015d6:	5b                   	pop    %ebx
  8015d7:	5d                   	pop    %ebp
  8015d8:	c3                   	ret    
  8015d9:	00 00                	add    %al,(%eax)
  8015db:	00 00                	add    %al,(%eax)
  8015dd:	00 00                	add    %al,(%eax)
	...

008015e0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8015e0:	55                   	push   %ebp
  8015e1:	89 e5                	mov    %esp,%ebp
  8015e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e6:	05 00 00 00 30       	add    $0x30000000,%eax
  8015eb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8015ee:	5d                   	pop    %ebp
  8015ef:	c3                   	ret    

008015f0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f9:	89 04 24             	mov    %eax,(%esp)
  8015fc:	e8 df ff ff ff       	call   8015e0 <fd2num>
  801601:	05 20 00 0d 00       	add    $0xd0020,%eax
  801606:	c1 e0 0c             	shl    $0xc,%eax
}
  801609:	c9                   	leave  
  80160a:	c3                   	ret    

0080160b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80160b:	55                   	push   %ebp
  80160c:	89 e5                	mov    %esp,%ebp
  80160e:	57                   	push   %edi
  80160f:	56                   	push   %esi
  801610:	53                   	push   %ebx
  801611:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801614:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801619:	a8 01                	test   $0x1,%al
  80161b:	74 36                	je     801653 <fd_alloc+0x48>
  80161d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801622:	a8 01                	test   $0x1,%al
  801624:	74 2d                	je     801653 <fd_alloc+0x48>
  801626:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80162b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801630:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801635:	89 c3                	mov    %eax,%ebx
  801637:	89 c2                	mov    %eax,%edx
  801639:	c1 ea 16             	shr    $0x16,%edx
  80163c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80163f:	f6 c2 01             	test   $0x1,%dl
  801642:	74 14                	je     801658 <fd_alloc+0x4d>
  801644:	89 c2                	mov    %eax,%edx
  801646:	c1 ea 0c             	shr    $0xc,%edx
  801649:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80164c:	f6 c2 01             	test   $0x1,%dl
  80164f:	75 10                	jne    801661 <fd_alloc+0x56>
  801651:	eb 05                	jmp    801658 <fd_alloc+0x4d>
  801653:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801658:	89 1f                	mov    %ebx,(%edi)
  80165a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80165f:	eb 17                	jmp    801678 <fd_alloc+0x6d>
  801661:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801666:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80166b:	75 c8                	jne    801635 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80166d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801673:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801678:	5b                   	pop    %ebx
  801679:	5e                   	pop    %esi
  80167a:	5f                   	pop    %edi
  80167b:	5d                   	pop    %ebp
  80167c:	c3                   	ret    

0080167d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801680:	8b 45 08             	mov    0x8(%ebp),%eax
  801683:	83 f8 1f             	cmp    $0x1f,%eax
  801686:	77 36                	ja     8016be <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801688:	05 00 00 0d 00       	add    $0xd0000,%eax
  80168d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801690:	89 c2                	mov    %eax,%edx
  801692:	c1 ea 16             	shr    $0x16,%edx
  801695:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80169c:	f6 c2 01             	test   $0x1,%dl
  80169f:	74 1d                	je     8016be <fd_lookup+0x41>
  8016a1:	89 c2                	mov    %eax,%edx
  8016a3:	c1 ea 0c             	shr    $0xc,%edx
  8016a6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8016ad:	f6 c2 01             	test   $0x1,%dl
  8016b0:	74 0c                	je     8016be <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8016b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b5:	89 02                	mov    %eax,(%edx)
  8016b7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8016bc:	eb 05                	jmp    8016c3 <fd_lookup+0x46>
  8016be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8016c3:	5d                   	pop    %ebp
  8016c4:	c3                   	ret    

008016c5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016cb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8016ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	89 04 24             	mov    %eax,(%esp)
  8016d8:	e8 a0 ff ff ff       	call   80167d <fd_lookup>
  8016dd:	85 c0                	test   %eax,%eax
  8016df:	78 0e                	js     8016ef <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8016e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016e7:	89 50 04             	mov    %edx,0x4(%eax)
  8016ea:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	56                   	push   %esi
  8016f5:	53                   	push   %ebx
  8016f6:	83 ec 10             	sub    $0x10,%esp
  8016f9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8016ff:	b8 0c 70 80 00       	mov    $0x80700c,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801704:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801709:	be 60 39 80 00       	mov    $0x803960,%esi
		if (devtab[i]->dev_id == dev_id) {
  80170e:	39 08                	cmp    %ecx,(%eax)
  801710:	75 10                	jne    801722 <dev_lookup+0x31>
  801712:	eb 04                	jmp    801718 <dev_lookup+0x27>
  801714:	39 08                	cmp    %ecx,(%eax)
  801716:	75 0a                	jne    801722 <dev_lookup+0x31>
			*dev = devtab[i];
  801718:	89 03                	mov    %eax,(%ebx)
  80171a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80171f:	90                   	nop
  801720:	eb 31                	jmp    801753 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801722:	83 c2 01             	add    $0x1,%edx
  801725:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801728:	85 c0                	test   %eax,%eax
  80172a:	75 e8                	jne    801714 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80172c:	a1 7c 70 80 00       	mov    0x80707c,%eax
  801731:	8b 40 4c             	mov    0x4c(%eax),%eax
  801734:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801738:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173c:	c7 04 24 e4 38 80 00 	movl   $0x8038e4,(%esp)
  801743:	e8 a1 eb ff ff       	call   8002e9 <cprintf>
	*dev = 0;
  801748:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80174e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801753:	83 c4 10             	add    $0x10,%esp
  801756:	5b                   	pop    %ebx
  801757:	5e                   	pop    %esi
  801758:	5d                   	pop    %ebp
  801759:	c3                   	ret    

0080175a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	53                   	push   %ebx
  80175e:	83 ec 24             	sub    $0x24,%esp
  801761:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801764:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801767:	89 44 24 04          	mov    %eax,0x4(%esp)
  80176b:	8b 45 08             	mov    0x8(%ebp),%eax
  80176e:	89 04 24             	mov    %eax,(%esp)
  801771:	e8 07 ff ff ff       	call   80167d <fd_lookup>
  801776:	85 c0                	test   %eax,%eax
  801778:	78 53                	js     8017cd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80177a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801781:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801784:	8b 00                	mov    (%eax),%eax
  801786:	89 04 24             	mov    %eax,(%esp)
  801789:	e8 63 ff ff ff       	call   8016f1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80178e:	85 c0                	test   %eax,%eax
  801790:	78 3b                	js     8017cd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801792:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801797:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80179a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80179e:	74 2d                	je     8017cd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017a0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017a3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017aa:	00 00 00 
	stat->st_isdir = 0;
  8017ad:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017b4:	00 00 00 
	stat->st_dev = dev;
  8017b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ba:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017c7:	89 14 24             	mov    %edx,(%esp)
  8017ca:	ff 50 14             	call   *0x14(%eax)
}
  8017cd:	83 c4 24             	add    $0x24,%esp
  8017d0:	5b                   	pop    %ebx
  8017d1:	5d                   	pop    %ebp
  8017d2:	c3                   	ret    

008017d3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	53                   	push   %ebx
  8017d7:	83 ec 24             	sub    $0x24,%esp
  8017da:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017e4:	89 1c 24             	mov    %ebx,(%esp)
  8017e7:	e8 91 fe ff ff       	call   80167d <fd_lookup>
  8017ec:	85 c0                	test   %eax,%eax
  8017ee:	78 5f                	js     80184f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017f0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017fa:	8b 00                	mov    (%eax),%eax
  8017fc:	89 04 24             	mov    %eax,(%esp)
  8017ff:	e8 ed fe ff ff       	call   8016f1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801804:	85 c0                	test   %eax,%eax
  801806:	78 47                	js     80184f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801808:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80180b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80180f:	75 23                	jne    801834 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801811:	a1 7c 70 80 00       	mov    0x80707c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801816:	8b 40 4c             	mov    0x4c(%eax),%eax
  801819:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80181d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801821:	c7 04 24 04 39 80 00 	movl   $0x803904,(%esp)
  801828:	e8 bc ea ff ff       	call   8002e9 <cprintf>
  80182d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801832:	eb 1b                	jmp    80184f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801837:	8b 48 18             	mov    0x18(%eax),%ecx
  80183a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80183f:	85 c9                	test   %ecx,%ecx
  801841:	74 0c                	je     80184f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801843:	8b 45 0c             	mov    0xc(%ebp),%eax
  801846:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184a:	89 14 24             	mov    %edx,(%esp)
  80184d:	ff d1                	call   *%ecx
}
  80184f:	83 c4 24             	add    $0x24,%esp
  801852:	5b                   	pop    %ebx
  801853:	5d                   	pop    %ebp
  801854:	c3                   	ret    

00801855 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	53                   	push   %ebx
  801859:	83 ec 24             	sub    $0x24,%esp
  80185c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80185f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801862:	89 44 24 04          	mov    %eax,0x4(%esp)
  801866:	89 1c 24             	mov    %ebx,(%esp)
  801869:	e8 0f fe ff ff       	call   80167d <fd_lookup>
  80186e:	85 c0                	test   %eax,%eax
  801870:	78 66                	js     8018d8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801872:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801875:	89 44 24 04          	mov    %eax,0x4(%esp)
  801879:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187c:	8b 00                	mov    (%eax),%eax
  80187e:	89 04 24             	mov    %eax,(%esp)
  801881:	e8 6b fe ff ff       	call   8016f1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801886:	85 c0                	test   %eax,%eax
  801888:	78 4e                	js     8018d8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80188a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80188d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801891:	75 23                	jne    8018b6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801893:	a1 7c 70 80 00       	mov    0x80707c,%eax
  801898:	8b 40 4c             	mov    0x4c(%eax),%eax
  80189b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80189f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018a3:	c7 04 24 25 39 80 00 	movl   $0x803925,(%esp)
  8018aa:	e8 3a ea ff ff       	call   8002e9 <cprintf>
  8018af:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8018b4:	eb 22                	jmp    8018d8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8018bc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018c1:	85 c9                	test   %ecx,%ecx
  8018c3:	74 13                	je     8018d8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018d3:	89 14 24             	mov    %edx,(%esp)
  8018d6:	ff d1                	call   *%ecx
}
  8018d8:	83 c4 24             	add    $0x24,%esp
  8018db:	5b                   	pop    %ebx
  8018dc:	5d                   	pop    %ebp
  8018dd:	c3                   	ret    

008018de <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	53                   	push   %ebx
  8018e2:	83 ec 24             	sub    $0x24,%esp
  8018e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ef:	89 1c 24             	mov    %ebx,(%esp)
  8018f2:	e8 86 fd ff ff       	call   80167d <fd_lookup>
  8018f7:	85 c0                	test   %eax,%eax
  8018f9:	78 6b                	js     801966 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801905:	8b 00                	mov    (%eax),%eax
  801907:	89 04 24             	mov    %eax,(%esp)
  80190a:	e8 e2 fd ff ff       	call   8016f1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80190f:	85 c0                	test   %eax,%eax
  801911:	78 53                	js     801966 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801913:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801916:	8b 42 08             	mov    0x8(%edx),%eax
  801919:	83 e0 03             	and    $0x3,%eax
  80191c:	83 f8 01             	cmp    $0x1,%eax
  80191f:	75 23                	jne    801944 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801921:	a1 7c 70 80 00       	mov    0x80707c,%eax
  801926:	8b 40 4c             	mov    0x4c(%eax),%eax
  801929:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80192d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801931:	c7 04 24 42 39 80 00 	movl   $0x803942,(%esp)
  801938:	e8 ac e9 ff ff       	call   8002e9 <cprintf>
  80193d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801942:	eb 22                	jmp    801966 <read+0x88>
	}
	if (!dev->dev_read)
  801944:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801947:	8b 48 08             	mov    0x8(%eax),%ecx
  80194a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80194f:	85 c9                	test   %ecx,%ecx
  801951:	74 13                	je     801966 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801953:	8b 45 10             	mov    0x10(%ebp),%eax
  801956:	89 44 24 08          	mov    %eax,0x8(%esp)
  80195a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801961:	89 14 24             	mov    %edx,(%esp)
  801964:	ff d1                	call   *%ecx
}
  801966:	83 c4 24             	add    $0x24,%esp
  801969:	5b                   	pop    %ebx
  80196a:	5d                   	pop    %ebp
  80196b:	c3                   	ret    

0080196c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	57                   	push   %edi
  801970:	56                   	push   %esi
  801971:	53                   	push   %ebx
  801972:	83 ec 1c             	sub    $0x1c,%esp
  801975:	8b 7d 08             	mov    0x8(%ebp),%edi
  801978:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80197b:	ba 00 00 00 00       	mov    $0x0,%edx
  801980:	bb 00 00 00 00       	mov    $0x0,%ebx
  801985:	b8 00 00 00 00       	mov    $0x0,%eax
  80198a:	85 f6                	test   %esi,%esi
  80198c:	74 29                	je     8019b7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80198e:	89 f0                	mov    %esi,%eax
  801990:	29 d0                	sub    %edx,%eax
  801992:	89 44 24 08          	mov    %eax,0x8(%esp)
  801996:	03 55 0c             	add    0xc(%ebp),%edx
  801999:	89 54 24 04          	mov    %edx,0x4(%esp)
  80199d:	89 3c 24             	mov    %edi,(%esp)
  8019a0:	e8 39 ff ff ff       	call   8018de <read>
		if (m < 0)
  8019a5:	85 c0                	test   %eax,%eax
  8019a7:	78 0e                	js     8019b7 <readn+0x4b>
			return m;
		if (m == 0)
  8019a9:	85 c0                	test   %eax,%eax
  8019ab:	74 08                	je     8019b5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8019ad:	01 c3                	add    %eax,%ebx
  8019af:	89 da                	mov    %ebx,%edx
  8019b1:	39 f3                	cmp    %esi,%ebx
  8019b3:	72 d9                	jb     80198e <readn+0x22>
  8019b5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8019b7:	83 c4 1c             	add    $0x1c,%esp
  8019ba:	5b                   	pop    %ebx
  8019bb:	5e                   	pop    %esi
  8019bc:	5f                   	pop    %edi
  8019bd:	5d                   	pop    %ebp
  8019be:	c3                   	ret    

008019bf <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
  8019c2:	56                   	push   %esi
  8019c3:	53                   	push   %ebx
  8019c4:	83 ec 20             	sub    $0x20,%esp
  8019c7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8019ca:	89 34 24             	mov    %esi,(%esp)
  8019cd:	e8 0e fc ff ff       	call   8015e0 <fd2num>
  8019d2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8019d5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8019d9:	89 04 24             	mov    %eax,(%esp)
  8019dc:	e8 9c fc ff ff       	call   80167d <fd_lookup>
  8019e1:	89 c3                	mov    %eax,%ebx
  8019e3:	85 c0                	test   %eax,%eax
  8019e5:	78 05                	js     8019ec <fd_close+0x2d>
  8019e7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8019ea:	74 0c                	je     8019f8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8019ec:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8019f0:	19 c0                	sbb    %eax,%eax
  8019f2:	f7 d0                	not    %eax
  8019f4:	21 c3                	and    %eax,%ebx
  8019f6:	eb 3d                	jmp    801a35 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8019f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ff:	8b 06                	mov    (%esi),%eax
  801a01:	89 04 24             	mov    %eax,(%esp)
  801a04:	e8 e8 fc ff ff       	call   8016f1 <dev_lookup>
  801a09:	89 c3                	mov    %eax,%ebx
  801a0b:	85 c0                	test   %eax,%eax
  801a0d:	78 16                	js     801a25 <fd_close+0x66>
		if (dev->dev_close)
  801a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a12:	8b 40 10             	mov    0x10(%eax),%eax
  801a15:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a1a:	85 c0                	test   %eax,%eax
  801a1c:	74 07                	je     801a25 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801a1e:	89 34 24             	mov    %esi,(%esp)
  801a21:	ff d0                	call   *%eax
  801a23:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801a25:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a30:	e8 35 f6 ff ff       	call   80106a <sys_page_unmap>
	return r;
}
  801a35:	89 d8                	mov    %ebx,%eax
  801a37:	83 c4 20             	add    $0x20,%esp
  801a3a:	5b                   	pop    %ebx
  801a3b:	5e                   	pop    %esi
  801a3c:	5d                   	pop    %ebp
  801a3d:	c3                   	ret    

00801a3e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
  801a41:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	89 04 24             	mov    %eax,(%esp)
  801a51:	e8 27 fc ff ff       	call   80167d <fd_lookup>
  801a56:	85 c0                	test   %eax,%eax
  801a58:	78 13                	js     801a6d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801a5a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801a61:	00 
  801a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a65:	89 04 24             	mov    %eax,(%esp)
  801a68:	e8 52 ff ff ff       	call   8019bf <fd_close>
}
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
  801a72:	83 ec 18             	sub    $0x18,%esp
  801a75:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801a78:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a7b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a82:	00 
  801a83:	8b 45 08             	mov    0x8(%ebp),%eax
  801a86:	89 04 24             	mov    %eax,(%esp)
  801a89:	e8 a9 03 00 00       	call   801e37 <open>
  801a8e:	89 c3                	mov    %eax,%ebx
  801a90:	85 c0                	test   %eax,%eax
  801a92:	78 1b                	js     801aaf <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801a94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a9b:	89 1c 24             	mov    %ebx,(%esp)
  801a9e:	e8 b7 fc ff ff       	call   80175a <fstat>
  801aa3:	89 c6                	mov    %eax,%esi
	close(fd);
  801aa5:	89 1c 24             	mov    %ebx,(%esp)
  801aa8:	e8 91 ff ff ff       	call   801a3e <close>
  801aad:	89 f3                	mov    %esi,%ebx
	return r;
}
  801aaf:	89 d8                	mov    %ebx,%eax
  801ab1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ab4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ab7:	89 ec                	mov    %ebp,%esp
  801ab9:	5d                   	pop    %ebp
  801aba:	c3                   	ret    

00801abb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801abb:	55                   	push   %ebp
  801abc:	89 e5                	mov    %esp,%ebp
  801abe:	53                   	push   %ebx
  801abf:	83 ec 14             	sub    $0x14,%esp
  801ac2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801ac7:	89 1c 24             	mov    %ebx,(%esp)
  801aca:	e8 6f ff ff ff       	call   801a3e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801acf:	83 c3 01             	add    $0x1,%ebx
  801ad2:	83 fb 20             	cmp    $0x20,%ebx
  801ad5:	75 f0                	jne    801ac7 <close_all+0xc>
		close(i);
}
  801ad7:	83 c4 14             	add    $0x14,%esp
  801ada:	5b                   	pop    %ebx
  801adb:	5d                   	pop    %ebp
  801adc:	c3                   	ret    

00801add <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 58             	sub    $0x58,%esp
  801ae3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ae6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ae9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801aec:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801aef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801af2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	89 04 24             	mov    %eax,(%esp)
  801afc:	e8 7c fb ff ff       	call   80167d <fd_lookup>
  801b01:	89 c3                	mov    %eax,%ebx
  801b03:	85 c0                	test   %eax,%eax
  801b05:	0f 88 e0 00 00 00    	js     801beb <dup+0x10e>
		return r;
	close(newfdnum);
  801b0b:	89 3c 24             	mov    %edi,(%esp)
  801b0e:	e8 2b ff ff ff       	call   801a3e <close>

	newfd = INDEX2FD(newfdnum);
  801b13:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801b19:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801b1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b1f:	89 04 24             	mov    %eax,(%esp)
  801b22:	e8 c9 fa ff ff       	call   8015f0 <fd2data>
  801b27:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801b29:	89 34 24             	mov    %esi,(%esp)
  801b2c:	e8 bf fa ff ff       	call   8015f0 <fd2data>
  801b31:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801b34:	89 da                	mov    %ebx,%edx
  801b36:	89 d8                	mov    %ebx,%eax
  801b38:	c1 e8 16             	shr    $0x16,%eax
  801b3b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801b42:	a8 01                	test   $0x1,%al
  801b44:	74 43                	je     801b89 <dup+0xac>
  801b46:	c1 ea 0c             	shr    $0xc,%edx
  801b49:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801b50:	a8 01                	test   $0x1,%al
  801b52:	74 35                	je     801b89 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801b54:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801b5b:	25 07 0e 00 00       	and    $0xe07,%eax
  801b60:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b64:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801b67:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b72:	00 
  801b73:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b77:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b7e:	e8 45 f5 ff ff       	call   8010c8 <sys_page_map>
  801b83:	89 c3                	mov    %eax,%ebx
  801b85:	85 c0                	test   %eax,%eax
  801b87:	78 3f                	js     801bc8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801b89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b8c:	89 c2                	mov    %eax,%edx
  801b8e:	c1 ea 0c             	shr    $0xc,%edx
  801b91:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801b98:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801b9e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801ba2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801ba6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801bad:	00 
  801bae:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bb2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bb9:	e8 0a f5 ff ff       	call   8010c8 <sys_page_map>
  801bbe:	89 c3                	mov    %eax,%ebx
  801bc0:	85 c0                	test   %eax,%eax
  801bc2:	78 04                	js     801bc8 <dup+0xeb>
  801bc4:	89 fb                	mov    %edi,%ebx
  801bc6:	eb 23                	jmp    801beb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801bc8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bcc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bd3:	e8 92 f4 ff ff       	call   80106a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801bd8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801bdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bdf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801be6:	e8 7f f4 ff ff       	call   80106a <sys_page_unmap>
	return r;
}
  801beb:	89 d8                	mov    %ebx,%eax
  801bed:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801bf0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801bf3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801bf6:	89 ec                	mov    %ebp,%esp
  801bf8:	5d                   	pop    %ebp
  801bf9:	c3                   	ret    
	...

00801bfc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	53                   	push   %ebx
  801c00:	83 ec 14             	sub    $0x14,%esp
  801c03:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801c05:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801c0b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c12:	00 
  801c13:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801c1a:	00 
  801c1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c1f:	89 14 24             	mov    %edx,(%esp)
  801c22:	e8 79 14 00 00       	call   8030a0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801c27:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c2e:	00 
  801c2f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c3a:	e8 c3 14 00 00       	call   803102 <ipc_recv>
}
  801c3f:	83 c4 14             	add    $0x14,%esp
  801c42:	5b                   	pop    %ebx
  801c43:	5d                   	pop    %ebp
  801c44:	c3                   	ret    

00801c45 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
  801c48:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4e:	8b 40 0c             	mov    0xc(%eax),%eax
  801c51:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801c56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c59:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801c5e:	ba 00 00 00 00       	mov    $0x0,%edx
  801c63:	b8 02 00 00 00       	mov    $0x2,%eax
  801c68:	e8 8f ff ff ff       	call   801bfc <fsipc>
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c75:	ba 00 00 00 00       	mov    $0x0,%edx
  801c7a:	b8 08 00 00 00       	mov    $0x8,%eax
  801c7f:	e8 78 ff ff ff       	call   801bfc <fsipc>
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
  801c89:	53                   	push   %ebx
  801c8a:	83 ec 14             	sub    $0x14,%esp
  801c8d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801c90:	8b 45 08             	mov    0x8(%ebp),%eax
  801c93:	8b 40 0c             	mov    0xc(%eax),%eax
  801c96:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801c9b:	ba 00 00 00 00       	mov    $0x0,%edx
  801ca0:	b8 05 00 00 00       	mov    $0x5,%eax
  801ca5:	e8 52 ff ff ff       	call   801bfc <fsipc>
  801caa:	85 c0                	test   %eax,%eax
  801cac:	78 2b                	js     801cd9 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801cae:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801cb5:	00 
  801cb6:	89 1c 24             	mov    %ebx,(%esp)
  801cb9:	e8 0c ed ff ff       	call   8009ca <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801cbe:	a1 80 40 80 00       	mov    0x804080,%eax
  801cc3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801cc9:	a1 84 40 80 00       	mov    0x804084,%eax
  801cce:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801cd4:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801cd9:	83 c4 14             	add    $0x14,%esp
  801cdc:	5b                   	pop    %ebx
  801cdd:	5d                   	pop    %ebp
  801cde:	c3                   	ret    

00801cdf <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801cdf:	55                   	push   %ebp
  801ce0:	89 e5                	mov    %esp,%ebp
  801ce2:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  801ce5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801cec:	00 
  801ced:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cf4:	00 
  801cf5:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801cfc:	e8 25 ee ff ff       	call   800b26 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801d01:	8b 45 08             	mov    0x8(%ebp),%eax
  801d04:	8b 40 0c             	mov    0xc(%eax),%eax
  801d07:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801d0c:	ba 00 00 00 00       	mov    $0x0,%edx
  801d11:	b8 06 00 00 00       	mov    $0x6,%eax
  801d16:	e8 e1 fe ff ff       	call   801bfc <fsipc>
}
  801d1b:	c9                   	leave  
  801d1c:	c3                   	ret    

00801d1d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801d23:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801d2a:	00 
  801d2b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d32:	00 
  801d33:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801d3a:	e8 e7 ed ff ff       	call   800b26 <memset>
  801d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  801d42:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801d47:	76 05                	jbe    801d4e <devfile_write+0x31>
  801d49:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801d4e:	8b 55 08             	mov    0x8(%ebp),%edx
  801d51:	8b 52 0c             	mov    0xc(%edx),%edx
  801d54:	89 15 00 40 80 00    	mov    %edx,0x804000
        fsipcbuf.write.req_n = numberOfBytes;
  801d5a:	a3 04 40 80 00       	mov    %eax,0x804004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  801d5f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d66:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d6a:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801d71:	e8 0f ee ff ff       	call   800b85 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  801d76:	ba 00 00 00 00       	mov    $0x0,%edx
  801d7b:	b8 04 00 00 00       	mov    $0x4,%eax
  801d80:	e8 77 fe ff ff       	call   801bfc <fsipc>
              return r;
        return r;
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	53                   	push   %ebx
  801d8b:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  801d8e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801d95:	00 
  801d96:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801d9d:	00 
  801d9e:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801da5:	e8 7c ed ff ff       	call   800b26 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  801daa:	8b 45 08             	mov    0x8(%ebp),%eax
  801dad:	8b 40 0c             	mov    0xc(%eax),%eax
  801db0:	a3 00 40 80 00       	mov    %eax,0x804000
        fsipcbuf.read.req_n = n;
  801db5:	8b 45 10             	mov    0x10(%ebp),%eax
  801db8:	a3 04 40 80 00       	mov    %eax,0x804004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  801dbd:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc2:	b8 03 00 00 00       	mov    $0x3,%eax
  801dc7:	e8 30 fe ff ff       	call   801bfc <fsipc>
  801dcc:	89 c3                	mov    %eax,%ebx
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	78 17                	js     801de9 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  801dd2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd6:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801ddd:	00 
  801dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de1:	89 04 24             	mov    %eax,(%esp)
  801de4:	e8 9c ed ff ff       	call   800b85 <memmove>
        return r;
}
  801de9:	89 d8                	mov    %ebx,%eax
  801deb:	83 c4 14             	add    $0x14,%esp
  801dee:	5b                   	pop    %ebx
  801def:	5d                   	pop    %ebp
  801df0:	c3                   	ret    

00801df1 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	53                   	push   %ebx
  801df5:	83 ec 14             	sub    $0x14,%esp
  801df8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801dfb:	89 1c 24             	mov    %ebx,(%esp)
  801dfe:	e8 7d eb ff ff       	call   800980 <strlen>
  801e03:	89 c2                	mov    %eax,%edx
  801e05:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801e0a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801e10:	7f 1f                	jg     801e31 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801e12:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e16:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e1d:	e8 a8 eb ff ff       	call   8009ca <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801e22:	ba 00 00 00 00       	mov    $0x0,%edx
  801e27:	b8 07 00 00 00       	mov    $0x7,%eax
  801e2c:	e8 cb fd ff ff       	call   801bfc <fsipc>
}
  801e31:	83 c4 14             	add    $0x14,%esp
  801e34:	5b                   	pop    %ebx
  801e35:	5d                   	pop    %ebp
  801e36:	c3                   	ret    

00801e37 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	56                   	push   %esi
  801e3b:	53                   	push   %ebx
  801e3c:	83 ec 20             	sub    $0x20,%esp
  801e3f:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  801e42:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801e49:	00 
  801e4a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e51:	00 
  801e52:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e59:	e8 c8 ec ff ff       	call   800b26 <memset>
    if(strlen(path)>=MAXPATHLEN)
  801e5e:	89 34 24             	mov    %esi,(%esp)
  801e61:	e8 1a eb ff ff       	call   800980 <strlen>
  801e66:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801e6b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801e70:	0f 8f 84 00 00 00    	jg     801efa <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  801e76:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e79:	89 04 24             	mov    %eax,(%esp)
  801e7c:	e8 8a f7 ff ff       	call   80160b <fd_alloc>
  801e81:	89 c3                	mov    %eax,%ebx
  801e83:	85 c0                	test   %eax,%eax
  801e85:	78 73                	js     801efa <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  801e87:	0f b6 06             	movzbl (%esi),%eax
  801e8a:	84 c0                	test   %al,%al
  801e8c:	74 20                	je     801eae <open+0x77>
  801e8e:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  801e90:	0f be c0             	movsbl %al,%eax
  801e93:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e97:	c7 04 24 74 39 80 00 	movl   $0x803974,(%esp)
  801e9e:	e8 46 e4 ff ff       	call   8002e9 <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  801ea3:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  801ea7:	83 c3 01             	add    $0x1,%ebx
  801eaa:	84 c0                	test   %al,%al
  801eac:	75 e2                	jne    801e90 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  801eae:	89 74 24 04          	mov    %esi,0x4(%esp)
  801eb2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801eb9:	e8 0c eb ff ff       	call   8009ca <strcpy>
    fsipcbuf.open.req_omode = mode;
  801ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec1:	a3 00 44 80 00       	mov    %eax,0x804400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  801ec6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ec9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ece:	e8 29 fd ff ff       	call   801bfc <fsipc>
  801ed3:	89 c3                	mov    %eax,%ebx
  801ed5:	85 c0                	test   %eax,%eax
  801ed7:	79 15                	jns    801eee <open+0xb7>
        {
            fd_close(fd,1);
  801ed9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801ee0:	00 
  801ee1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee4:	89 04 24             	mov    %eax,(%esp)
  801ee7:	e8 d3 fa ff ff       	call   8019bf <fd_close>
             return r;
  801eec:	eb 0c                	jmp    801efa <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  801eee:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801ef1:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  801ef7:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  801efa:	89 d8                	mov    %ebx,%eax
  801efc:	83 c4 20             	add    $0x20,%esp
  801eff:	5b                   	pop    %ebx
  801f00:	5e                   	pop    %esi
  801f01:	5d                   	pop    %ebp
  801f02:	c3                   	ret    
	...

00801f04 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
  801f07:	57                   	push   %edi
  801f08:	56                   	push   %esi
  801f09:	53                   	push   %ebx
  801f0a:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801f10:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f17:	00 
  801f18:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1b:	89 04 24             	mov    %eax,(%esp)
  801f1e:	e8 14 ff ff ff       	call   801e37 <open>
  801f23:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  801f29:	89 c3                	mov    %eax,%ebx
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	0f 88 d1 05 00 00    	js     802504 <spawn+0x600>
	fd = r;
    // cprintf("fd--->%d",fd);
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
	    || elf->e_magic != ELF_MAGIC) {
  801f33:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801f3a:	00 
  801f3b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801f41:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f45:	89 1c 24             	mov    %ebx,(%esp)
  801f48:	e8 91 f9 ff ff       	call   8018de <read>
		return r;
	fd = r;
    // cprintf("fd--->%d",fd);
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801f4d:	3d 00 02 00 00       	cmp    $0x200,%eax
  801f52:	75 0c                	jne    801f60 <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801f54:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801f5b:	45 4c 46 
  801f5e:	74 36                	je     801f96 <spawn+0x92>
		close(fd);
  801f60:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801f66:	89 04 24             	mov    %eax,(%esp)
  801f69:	e8 d0 fa ff ff       	call   801a3e <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801f6e:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801f75:	46 
  801f76:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801f7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f80:	c7 04 24 77 39 80 00 	movl   $0x803977,(%esp)
  801f87:	e8 5d e3 ff ff       	call   8002e9 <cprintf>
  801f8c:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
		return -E_NOT_EXEC;
  801f91:	e9 6e 05 00 00       	jmp    802504 <spawn+0x600>
  801f96:	ba 07 00 00 00       	mov    $0x7,%edx
  801f9b:	89 d0                	mov    %edx,%eax
  801f9d:	cd 30                	int    $0x30
  801f9f:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
	}
     
       // Create new child environment
	if ((r = sys_exofork()) < 0)
  801fa5:	85 c0                	test   %eax,%eax
  801fa7:	0f 88 51 05 00 00    	js     8024fe <spawn+0x5fa>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801fad:	89 c6                	mov    %eax,%esi
  801faf:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801fb5:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801fb8:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801fbe:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801fc4:	b9 11 00 00 00       	mov    $0x11,%ecx
  801fc9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	cprintf("\nelf->entry %x\n",elf->e_entry);
  801fcb:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801fd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fd5:	c7 04 24 91 39 80 00 	movl   $0x803991,(%esp)
  801fdc:	e8 08 e3 ff ff       	call   8002e9 <cprintf>
        child_tf.tf_eip = elf->e_entry;
  801fe1:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801fe7:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801fed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff0:	8b 02                	mov    (%edx),%eax
  801ff2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ff7:	be 00 00 00 00       	mov    $0x0,%esi
  801ffc:	85 c0                	test   %eax,%eax
  801ffe:	75 16                	jne    802016 <spawn+0x112>
  802000:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  802007:	00 00 00 
  80200a:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  802011:	00 00 00 
  802014:	eb 2c                	jmp    802042 <spawn+0x13e>
  802016:	8b 7d 0c             	mov    0xc(%ebp),%edi
		string_size += strlen(argv[argc]) + 1;
  802019:	89 04 24             	mov    %eax,(%esp)
  80201c:	e8 5f e9 ff ff       	call   800980 <strlen>
  802021:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802025:	83 c6 01             	add    $0x1,%esi
  802028:	8d 14 b5 00 00 00 00 	lea    0x0(,%esi,4),%edx
  80202f:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  802032:	85 c0                	test   %eax,%eax
  802034:	75 e3                	jne    802019 <spawn+0x115>
  802036:	89 95 7c fd ff ff    	mov    %edx,-0x284(%ebp)
  80203c:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802042:	f7 db                	neg    %ebx
  802044:	8d bb 00 10 40 00    	lea    0x401000(%ebx),%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80204a:	89 fa                	mov    %edi,%edx
  80204c:	83 e2 fc             	and    $0xfffffffc,%edx
  80204f:	89 f0                	mov    %esi,%eax
  802051:	f7 d0                	not    %eax
  802053:	8d 04 82             	lea    (%edx,%eax,4),%eax
  802056:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80205c:	83 e8 08             	sub    $0x8,%eax
  80205f:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  802065:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80206a:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  80206f:	0f 86 8f 04 00 00    	jbe    802504 <spawn+0x600>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802075:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80207c:	00 
  80207d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802084:	00 
  802085:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80208c:	e8 95 f0 ff ff       	call   801126 <sys_page_alloc>
  802091:	89 c3                	mov    %eax,%ebx
  802093:	85 c0                	test   %eax,%eax
  802095:	0f 88 69 04 00 00    	js     802504 <spawn+0x600>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80209b:	85 f6                	test   %esi,%esi
  80209d:	7e 46                	jle    8020e5 <spawn+0x1e1>
  80209f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8020a4:	89 b5 8c fd ff ff    	mov    %esi,-0x274(%ebp)
  8020aa:	8b 75 0c             	mov    0xc(%ebp),%esi
		argv_store[i] = UTEMP2USTACK(string_store);
  8020ad:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  8020b3:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  8020b9:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
		strcpy(string_store, argv[i]);
  8020bc:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8020bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c3:	89 3c 24             	mov    %edi,(%esp)
  8020c6:	e8 ff e8 ff ff       	call   8009ca <strcpy>
		string_store += strlen(argv[i]) + 1;
  8020cb:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8020ce:	89 04 24             	mov    %eax,(%esp)
  8020d1:	e8 aa e8 ff ff       	call   800980 <strlen>
  8020d6:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8020da:	83 c3 01             	add    $0x1,%ebx
  8020dd:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  8020e3:	7c c8                	jl     8020ad <spawn+0x1a9>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8020e5:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  8020eb:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  8020f1:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8020f8:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8020fe:	74 24                	je     802124 <spawn+0x220>
  802100:	c7 44 24 0c fc 39 80 	movl   $0x8039fc,0xc(%esp)
  802107:	00 
  802108:	c7 44 24 08 a1 39 80 	movl   $0x8039a1,0x8(%esp)
  80210f:	00 
  802110:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  802117:	00 
  802118:	c7 04 24 b6 39 80 00 	movl   $0x8039b6,(%esp)
  80211f:	e8 00 e1 ff ff       	call   800224 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802124:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80212a:	2d 00 30 80 11       	sub    $0x11803000,%eax
  80212f:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802135:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  802138:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  80213e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802144:	89 10                	mov    %edx,(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802146:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80214c:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802151:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802157:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80215e:	00 
  80215f:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802166:	ee 
  802167:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80216d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802171:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802178:	00 
  802179:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802180:	e8 43 ef ff ff       	call   8010c8 <sys_page_map>
  802185:	89 c3                	mov    %eax,%ebx
  802187:	85 c0                	test   %eax,%eax
  802189:	78 1a                	js     8021a5 <spawn+0x2a1>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80218b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802192:	00 
  802193:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80219a:	e8 cb ee ff ff       	call   80106a <sys_page_unmap>
  80219f:	89 c3                	mov    %eax,%ebx
  8021a1:	85 c0                	test   %eax,%eax
  8021a3:	79 19                	jns    8021be <spawn+0x2ba>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  8021a5:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8021ac:	00 
  8021ad:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021b4:	e8 b1 ee ff ff       	call   80106a <sys_page_unmap>
  8021b9:	e9 46 03 00 00       	jmp    802504 <spawn+0x600>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8021be:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8021c4:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  8021cb:	00 
  8021cc:	0f 84 e3 01 00 00    	je     8023b5 <spawn+0x4b1>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8021d2:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  8021d9:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
  8021df:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8021e6:	00 00 00 
	for (i = 0; i < elf->e_phnum; i++, ph++) {
               // cprintf("\nHello\n");
		if (ph->p_type != ELF_PROG_LOAD)
  8021e9:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  8021ef:	83 3a 01             	cmpl   $0x1,(%edx)
  8021f2:	0f 85 9b 01 00 00    	jne    802393 <spawn+0x48f>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8021f8:	8b 42 18             	mov    0x18(%edx),%eax
  8021fb:	83 e0 02             	and    $0x2,%eax
  8021fe:	83 f8 01             	cmp    $0x1,%eax
  802201:	19 c0                	sbb    %eax,%eax
  802203:	83 e0 fe             	and    $0xfffffffe,%eax
  802206:	83 c0 07             	add    $0x7,%eax
  802209:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
  80220f:	8b 52 04             	mov    0x4(%edx),%edx
  802212:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  802218:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  80221e:	8b 58 10             	mov    0x10(%eax),%ebx
  802221:	8b 50 14             	mov    0x14(%eax),%edx
  802224:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
  80222a:	8b 40 08             	mov    0x8(%eax),%eax
  80222d:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802233:	25 ff 0f 00 00       	and    $0xfff,%eax
  802238:	74 16                	je     802250 <spawn+0x34c>
		va -= i;
  80223a:	29 85 90 fd ff ff    	sub    %eax,-0x270(%ebp)
		memsz += i;
  802240:	01 c2                	add    %eax,%edx
  802242:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
		filesz += i;
  802248:	01 c3                	add    %eax,%ebx
		fileoffset -= i;
  80224a:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802250:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  802257:	0f 84 36 01 00 00    	je     802393 <spawn+0x48f>
  80225d:	bf 00 00 00 00       	mov    $0x0,%edi
  802262:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  802267:	39 fb                	cmp    %edi,%ebx
  802269:	77 31                	ja     80229c <spawn+0x398>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80226b:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802271:	89 54 24 08          	mov    %edx,0x8(%esp)
  802275:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  80227b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80227f:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802285:	89 04 24             	mov    %eax,(%esp)
  802288:	e8 99 ee ff ff       	call   801126 <sys_page_alloc>
  80228d:	85 c0                	test   %eax,%eax
  80228f:	0f 89 ea 00 00 00    	jns    80237f <spawn+0x47b>
  802295:	89 c3                	mov    %eax,%ebx
  802297:	e9 44 02 00 00       	jmp    8024e0 <spawn+0x5dc>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80229c:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8022a3:	00 
  8022a4:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8022ab:	00 
  8022ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022b3:	e8 6e ee ff ff       	call   801126 <sys_page_alloc>
  8022b8:	85 c0                	test   %eax,%eax
  8022ba:	0f 88 16 02 00 00    	js     8024d6 <spawn+0x5d2>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8022c0:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  8022c6:	8d 04 16             	lea    (%esi,%edx,1),%eax
  8022c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022cd:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8022d3:	89 04 24             	mov    %eax,(%esp)
  8022d6:	e8 ea f3 ff ff       	call   8016c5 <seek>
  8022db:	85 c0                	test   %eax,%eax
  8022dd:	0f 88 f7 01 00 00    	js     8024da <spawn+0x5d6>
				return r;
			if ((r = read(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8022e3:	89 d8                	mov    %ebx,%eax
  8022e5:	29 f8                	sub    %edi,%eax
  8022e7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8022ec:	76 05                	jbe    8022f3 <spawn+0x3ef>
  8022ee:	b8 00 10 00 00       	mov    $0x1000,%eax
  8022f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022f7:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8022fe:	00 
  8022ff:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  802305:	89 14 24             	mov    %edx,(%esp)
  802308:	e8 d1 f5 ff ff       	call   8018de <read>
  80230d:	85 c0                	test   %eax,%eax
  80230f:	0f 88 c9 01 00 00    	js     8024de <spawn+0x5da>
				return r;
			//cprintf("\nvirtual address----->%x\n",va+i);
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802315:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80231b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80231f:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  802325:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802329:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  80232f:	89 54 24 08          	mov    %edx,0x8(%esp)
  802333:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80233a:	00 
  80233b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802342:	e8 81 ed ff ff       	call   8010c8 <sys_page_map>
  802347:	85 c0                	test   %eax,%eax
  802349:	79 20                	jns    80236b <spawn+0x467>
				panic("spawn: sys_page_map data: %e", r);
  80234b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80234f:	c7 44 24 08 c2 39 80 	movl   $0x8039c2,0x8(%esp)
  802356:	00 
  802357:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  80235e:	00 
  80235f:	c7 04 24 b6 39 80 00 	movl   $0x8039b6,(%esp)
  802366:	e8 b9 de ff ff       	call   800224 <_panic>
			sys_page_unmap(0, UTEMP);
  80236b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802372:	00 
  802373:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80237a:	e8 eb ec ff ff       	call   80106a <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80237f:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802385:	89 f7                	mov    %esi,%edi
  802387:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  80238d:	0f 87 d4 fe ff ff    	ja     802267 <spawn+0x363>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802393:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  80239a:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8023a1:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  8023a7:	7e 0c                	jle    8023b5 <spawn+0x4b1>
  8023a9:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  8023b0:	e9 34 fe ff ff       	jmp    8021e9 <spawn+0x2e5>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  8023b5:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8023bb:	89 04 24             	mov    %eax,(%esp)
  8023be:	e8 7b f6 ff ff       	call   801a3e <close>
  8023c3:	bb 00 00 80 00       	mov    $0x800000,%ebx
duplicateSharepage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
        pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  8023c8:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
       
        if( 0 == pgDirEntry )
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  8023cd:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	// LAB 7: Your code here.
	uint8_t *addr;
	extern unsigned char end[];
	for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
                {    
			duplicateSharepage(child, VPN(addr));
  8023d2:	89 d8                	mov    %ebx,%eax
  8023d4:	c1 e8 0c             	shr    $0xc,%eax
duplicateSharepage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
        pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  8023d7:	89 c2                	mov    %eax,%edx
  8023d9:	c1 e2 0c             	shl    $0xc,%edx
  8023dc:	89 d1                	mov    %edx,%ecx
  8023de:	c1 e9 16             	shr    $0x16,%ecx
  8023e1:	8b 0c 8e             	mov    (%esi,%ecx,4),%ecx
       
        if( 0 == pgDirEntry )
  8023e4:	85 c9                	test   %ecx,%ecx
  8023e6:	74 66                	je     80244e <spawn+0x54a>
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  8023e8:	8b 04 87             	mov    (%edi,%eax,4),%eax
  8023eb:	89 c1                	mov    %eax,%ecx
  8023ed:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
        //cprintf("Below %d",vpt[pn]);
                //if(perm!=0)  //commented nw.
                   // cprintf("perm bit %d",perm);
	//cprintf("\nInside Spawn setting share\n");
	if((perm & PTE_W) && (perm & PTE_SHARE))
  8023f3:	25 02 04 00 00       	and    $0x402,%eax
  8023f8:	3d 02 04 00 00       	cmp    $0x402,%eax
  8023fd:	75 4f                	jne    80244e <spawn+0x54a>
	{
		if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_SHARE|(perm & PTE_USER))) < 0)
  8023ff:	81 e1 07 0a 00 00    	and    $0xa07,%ecx
  802405:	80 cd 04             	or     $0x4,%ch
  802408:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80240c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802410:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802416:	89 44 24 08          	mov    %eax,0x8(%esp)
  80241a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80241e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802425:	e8 9e ec ff ff       	call   8010c8 <sys_page_map>
  80242a:	85 c0                	test   %eax,%eax
  80242c:	79 20                	jns    80244e <spawn+0x54a>
                panic("sys_page_map: %e", r);
  80242e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802432:	c7 44 24 08 4b 38 80 	movl   $0x80384b,0x8(%esp)
  802439:	00 
  80243a:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  802441:	00 
  802442:	c7 04 24 b6 39 80 00 	movl   $0x8039b6,(%esp)
  802449:	e8 d6 dd ff ff       	call   800224 <_panic>
copy_shared_pages(envid_t child)
{
	// LAB 7: Your code here.
	uint8_t *addr;
	extern unsigned char end[];
	for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
  80244e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802454:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80245a:	0f 85 72 ff ff ff    	jne    8023d2 <spawn+0x4ce>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802460:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802466:	89 44 24 04          	mov    %eax,0x4(%esp)
  80246a:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  802470:	89 14 24             	mov    %edx,(%esp)
  802473:	e8 36 eb ff ff       	call   800fae <sys_env_set_trapframe>
  802478:	85 c0                	test   %eax,%eax
  80247a:	79 20                	jns    80249c <spawn+0x598>
		panic("sys_env_set_trapframe: %e", r);
  80247c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802480:	c7 44 24 08 df 39 80 	movl   $0x8039df,0x8(%esp)
  802487:	00 
  802488:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  80248f:	00 
  802490:	c7 04 24 b6 39 80 00 	movl   $0x8039b6,(%esp)
  802497:	e8 88 dd ff ff       	call   800224 <_panic>
                   //    cprintf("\nHello below trpaframe%d\n",elf->e_phnum);
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80249c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8024a3:	00 
  8024a4:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8024aa:	89 04 24             	mov    %eax,(%esp)
  8024ad:	e8 5a eb ff ff       	call   80100c <sys_env_set_status>
  8024b2:	85 c0                	test   %eax,%eax
  8024b4:	79 48                	jns    8024fe <spawn+0x5fa>
		panic("sys_env_set_status: %e", r);
  8024b6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024ba:	c7 44 24 08 7f 38 80 	movl   $0x80387f,0x8(%esp)
  8024c1:	00 
  8024c2:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  8024c9:	00 
  8024ca:	c7 04 24 b6 39 80 00 	movl   $0x8039b6,(%esp)
  8024d1:	e8 4e dd ff ff       	call   800224 <_panic>
  8024d6:	89 c3                	mov    %eax,%ebx
  8024d8:	eb 06                	jmp    8024e0 <spawn+0x5dc>
  8024da:	89 c3                	mov    %eax,%ebx
  8024dc:	eb 02                	jmp    8024e0 <spawn+0x5dc>
  8024de:	89 c3                	mov    %eax,%ebx

	return child;

error:
	sys_env_destroy(child);
  8024e0:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  8024e6:	89 14 24             	mov    %edx,(%esp)
  8024e9:	e8 ff ec ff ff       	call   8011ed <sys_env_destroy>
	close(fd);
  8024ee:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8024f4:	89 04 24             	mov    %eax,(%esp)
  8024f7:	e8 42 f5 ff ff       	call   801a3e <close>
	return r;
  8024fc:	eb 06                	jmp    802504 <spawn+0x600>
  8024fe:	8b 9d 88 fd ff ff    	mov    -0x278(%ebp),%ebx
}
  802504:	89 d8                	mov    %ebx,%eax
  802506:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  80250c:	5b                   	pop    %ebx
  80250d:	5e                   	pop    %esi
  80250e:	5f                   	pop    %edi
  80250f:	5d                   	pop    %ebp
  802510:	c3                   	ret    

00802511 <spawnl>:

// Spawn, taking command-line arguments array directly on the stack.
int
spawnl(const char *prog, const char *arg0, ...)
{
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
  802514:	83 ec 18             	sub    $0x18,%esp
	return spawn(prog, &arg0);
  802517:	8d 45 0c             	lea    0xc(%ebp),%eax
  80251a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80251e:	8b 45 08             	mov    0x8(%ebp),%eax
  802521:	89 04 24             	mov    %eax,(%esp)
  802524:	e8 db f9 ff ff       	call   801f04 <spawn>
}
  802529:	c9                   	leave  
  80252a:	c3                   	ret    
  80252b:	00 00                	add    %al,(%eax)
  80252d:	00 00                	add    %al,(%eax)
	...

00802530 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802530:	55                   	push   %ebp
  802531:	89 e5                	mov    %esp,%ebp
  802533:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802536:	c7 44 24 04 24 3a 80 	movl   $0x803a24,0x4(%esp)
  80253d:	00 
  80253e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802541:	89 04 24             	mov    %eax,(%esp)
  802544:	e8 81 e4 ff ff       	call   8009ca <strcpy>
	return 0;
}
  802549:	b8 00 00 00 00       	mov    $0x0,%eax
  80254e:	c9                   	leave  
  80254f:	c3                   	ret    

00802550 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  802556:	8b 45 08             	mov    0x8(%ebp),%eax
  802559:	8b 40 0c             	mov    0xc(%eax),%eax
  80255c:	89 04 24             	mov    %eax,(%esp)
  80255f:	e8 9e 02 00 00       	call   802802 <nsipc_close>
}
  802564:	c9                   	leave  
  802565:	c3                   	ret    

00802566 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802566:	55                   	push   %ebp
  802567:	89 e5                	mov    %esp,%ebp
  802569:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80256c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802573:	00 
  802574:	8b 45 10             	mov    0x10(%ebp),%eax
  802577:	89 44 24 08          	mov    %eax,0x8(%esp)
  80257b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80257e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802582:	8b 45 08             	mov    0x8(%ebp),%eax
  802585:	8b 40 0c             	mov    0xc(%eax),%eax
  802588:	89 04 24             	mov    %eax,(%esp)
  80258b:	e8 ae 02 00 00       	call   80283e <nsipc_send>
}
  802590:	c9                   	leave  
  802591:	c3                   	ret    

00802592 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802592:	55                   	push   %ebp
  802593:	89 e5                	mov    %esp,%ebp
  802595:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802598:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80259f:	00 
  8025a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8025a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b4:	89 04 24             	mov    %eax,(%esp)
  8025b7:	e8 f5 02 00 00       	call   8028b1 <nsipc_recv>
}
  8025bc:	c9                   	leave  
  8025bd:	c3                   	ret    

008025be <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8025be:	55                   	push   %ebp
  8025bf:	89 e5                	mov    %esp,%ebp
  8025c1:	56                   	push   %esi
  8025c2:	53                   	push   %ebx
  8025c3:	83 ec 20             	sub    $0x20,%esp
  8025c6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8025c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025cb:	89 04 24             	mov    %eax,(%esp)
  8025ce:	e8 38 f0 ff ff       	call   80160b <fd_alloc>
  8025d3:	89 c3                	mov    %eax,%ebx
  8025d5:	85 c0                	test   %eax,%eax
  8025d7:	78 21                	js     8025fa <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  8025d9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8025e0:	00 
  8025e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025ef:	e8 32 eb ff ff       	call   801126 <sys_page_alloc>
  8025f4:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8025f6:	85 c0                	test   %eax,%eax
  8025f8:	79 0a                	jns    802604 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  8025fa:	89 34 24             	mov    %esi,(%esp)
  8025fd:	e8 00 02 00 00       	call   802802 <nsipc_close>
		return r;
  802602:	eb 28                	jmp    80262c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802604:	8b 15 28 70 80 00    	mov    0x807028,%edx
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	89 04 24             	mov    %eax,(%esp)
  802625:	e8 b6 ef ff ff       	call   8015e0 <fd2num>
  80262a:	89 c3                	mov    %eax,%ebx
}
  80262c:	89 d8                	mov    %ebx,%eax
  80262e:	83 c4 20             	add    $0x20,%esp
  802631:	5b                   	pop    %ebx
  802632:	5e                   	pop    %esi
  802633:	5d                   	pop    %ebp
  802634:	c3                   	ret    

00802635 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802635:	55                   	push   %ebp
  802636:	89 e5                	mov    %esp,%ebp
  802638:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80263b:	8b 45 10             	mov    0x10(%ebp),%eax
  80263e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802642:	8b 45 0c             	mov    0xc(%ebp),%eax
  802645:	89 44 24 04          	mov    %eax,0x4(%esp)
  802649:	8b 45 08             	mov    0x8(%ebp),%eax
  80264c:	89 04 24             	mov    %eax,(%esp)
  80264f:	e8 62 01 00 00       	call   8027b6 <nsipc_socket>
  802654:	85 c0                	test   %eax,%eax
  802656:	78 05                	js     80265d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802658:	e8 61 ff ff ff       	call   8025be <alloc_sockfd>
}
  80265d:	c9                   	leave  
  80265e:	66 90                	xchg   %ax,%ax
  802660:	c3                   	ret    

00802661 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802661:	55                   	push   %ebp
  802662:	89 e5                	mov    %esp,%ebp
  802664:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802667:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80266a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80266e:	89 04 24             	mov    %eax,(%esp)
  802671:	e8 07 f0 ff ff       	call   80167d <fd_lookup>
  802676:	85 c0                	test   %eax,%eax
  802678:	78 15                	js     80268f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80267a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80267d:	8b 0a                	mov    (%edx),%ecx
  80267f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802684:	3b 0d 28 70 80 00    	cmp    0x807028,%ecx
  80268a:	75 03                	jne    80268f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80268c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  80268f:	c9                   	leave  
  802690:	c3                   	ret    

00802691 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802691:	55                   	push   %ebp
  802692:	89 e5                	mov    %esp,%ebp
  802694:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802697:	8b 45 08             	mov    0x8(%ebp),%eax
  80269a:	e8 c2 ff ff ff       	call   802661 <fd2sockid>
  80269f:	85 c0                	test   %eax,%eax
  8026a1:	78 0f                	js     8026b2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8026a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026a6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026aa:	89 04 24             	mov    %eax,(%esp)
  8026ad:	e8 2e 01 00 00       	call   8027e0 <nsipc_listen>
}
  8026b2:	c9                   	leave  
  8026b3:	c3                   	ret    

008026b4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8026b4:	55                   	push   %ebp
  8026b5:	89 e5                	mov    %esp,%ebp
  8026b7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bd:	e8 9f ff ff ff       	call   802661 <fd2sockid>
  8026c2:	85 c0                	test   %eax,%eax
  8026c4:	78 16                	js     8026dc <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8026c6:	8b 55 10             	mov    0x10(%ebp),%edx
  8026c9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026d4:	89 04 24             	mov    %eax,(%esp)
  8026d7:	e8 55 02 00 00       	call   802931 <nsipc_connect>
}
  8026dc:	c9                   	leave  
  8026dd:	c3                   	ret    

008026de <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8026de:	55                   	push   %ebp
  8026df:	89 e5                	mov    %esp,%ebp
  8026e1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8026e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e7:	e8 75 ff ff ff       	call   802661 <fd2sockid>
  8026ec:	85 c0                	test   %eax,%eax
  8026ee:	78 0f                	js     8026ff <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8026f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8026f7:	89 04 24             	mov    %eax,(%esp)
  8026fa:	e8 1d 01 00 00       	call   80281c <nsipc_shutdown>
}
  8026ff:	c9                   	leave  
  802700:	c3                   	ret    

00802701 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802701:	55                   	push   %ebp
  802702:	89 e5                	mov    %esp,%ebp
  802704:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802707:	8b 45 08             	mov    0x8(%ebp),%eax
  80270a:	e8 52 ff ff ff       	call   802661 <fd2sockid>
  80270f:	85 c0                	test   %eax,%eax
  802711:	78 16                	js     802729 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802713:	8b 55 10             	mov    0x10(%ebp),%edx
  802716:	89 54 24 08          	mov    %edx,0x8(%esp)
  80271a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80271d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802721:	89 04 24             	mov    %eax,(%esp)
  802724:	e8 47 02 00 00       	call   802970 <nsipc_bind>
}
  802729:	c9                   	leave  
  80272a:	c3                   	ret    

0080272b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80272b:	55                   	push   %ebp
  80272c:	89 e5                	mov    %esp,%ebp
  80272e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802731:	8b 45 08             	mov    0x8(%ebp),%eax
  802734:	e8 28 ff ff ff       	call   802661 <fd2sockid>
  802739:	85 c0                	test   %eax,%eax
  80273b:	78 1f                	js     80275c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80273d:	8b 55 10             	mov    0x10(%ebp),%edx
  802740:	89 54 24 08          	mov    %edx,0x8(%esp)
  802744:	8b 55 0c             	mov    0xc(%ebp),%edx
  802747:	89 54 24 04          	mov    %edx,0x4(%esp)
  80274b:	89 04 24             	mov    %eax,(%esp)
  80274e:	e8 5c 02 00 00       	call   8029af <nsipc_accept>
  802753:	85 c0                	test   %eax,%eax
  802755:	78 05                	js     80275c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802757:	e8 62 fe ff ff       	call   8025be <alloc_sockfd>
}
  80275c:	c9                   	leave  
  80275d:	8d 76 00             	lea    0x0(%esi),%esi
  802760:	c3                   	ret    
	...

00802770 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
  802773:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802776:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  80277c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802783:	00 
  802784:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80278b:	00 
  80278c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802790:	89 14 24             	mov    %edx,(%esp)
  802793:	e8 08 09 00 00       	call   8030a0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802798:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80279f:	00 
  8027a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8027a7:	00 
  8027a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027af:	e8 4e 09 00 00       	call   803102 <ipc_recv>
}
  8027b4:	c9                   	leave  
  8027b5:	c3                   	ret    

008027b6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8027b6:	55                   	push   %ebp
  8027b7:	89 e5                	mov    %esp,%ebp
  8027b9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8027bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8027bf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8027c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027c7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8027cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8027cf:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8027d4:	b8 09 00 00 00       	mov    $0x9,%eax
  8027d9:	e8 92 ff ff ff       	call   802770 <nsipc>
}
  8027de:	c9                   	leave  
  8027df:	c3                   	ret    

008027e0 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8027e0:	55                   	push   %ebp
  8027e1:	89 e5                	mov    %esp,%ebp
  8027e3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8027e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8027ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027f1:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8027f6:	b8 06 00 00 00       	mov    $0x6,%eax
  8027fb:	e8 70 ff ff ff       	call   802770 <nsipc>
}
  802800:	c9                   	leave  
  802801:	c3                   	ret    

00802802 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802802:	55                   	push   %ebp
  802803:	89 e5                	mov    %esp,%ebp
  802805:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802808:	8b 45 08             	mov    0x8(%ebp),%eax
  80280b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802810:	b8 04 00 00 00       	mov    $0x4,%eax
  802815:	e8 56 ff ff ff       	call   802770 <nsipc>
}
  80281a:	c9                   	leave  
  80281b:	c3                   	ret    

0080281c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80281c:	55                   	push   %ebp
  80281d:	89 e5                	mov    %esp,%ebp
  80281f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802822:	8b 45 08             	mov    0x8(%ebp),%eax
  802825:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80282a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80282d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802832:	b8 03 00 00 00       	mov    $0x3,%eax
  802837:	e8 34 ff ff ff       	call   802770 <nsipc>
}
  80283c:	c9                   	leave  
  80283d:	c3                   	ret    

0080283e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80283e:	55                   	push   %ebp
  80283f:	89 e5                	mov    %esp,%ebp
  802841:	53                   	push   %ebx
  802842:	83 ec 14             	sub    $0x14,%esp
  802845:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802848:	8b 45 08             	mov    0x8(%ebp),%eax
  80284b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802850:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802856:	7e 24                	jle    80287c <nsipc_send+0x3e>
  802858:	c7 44 24 0c 30 3a 80 	movl   $0x803a30,0xc(%esp)
  80285f:	00 
  802860:	c7 44 24 08 a1 39 80 	movl   $0x8039a1,0x8(%esp)
  802867:	00 
  802868:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  80286f:	00 
  802870:	c7 04 24 3c 3a 80 00 	movl   $0x803a3c,(%esp)
  802877:	e8 a8 d9 ff ff       	call   800224 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80287c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802880:	8b 45 0c             	mov    0xc(%ebp),%eax
  802883:	89 44 24 04          	mov    %eax,0x4(%esp)
  802887:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80288e:	e8 f2 e2 ff ff       	call   800b85 <memmove>
	nsipcbuf.send.req_size = size;
  802893:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802899:	8b 45 14             	mov    0x14(%ebp),%eax
  80289c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8028a1:	b8 08 00 00 00       	mov    $0x8,%eax
  8028a6:	e8 c5 fe ff ff       	call   802770 <nsipc>
}
  8028ab:	83 c4 14             	add    $0x14,%esp
  8028ae:	5b                   	pop    %ebx
  8028af:	5d                   	pop    %ebp
  8028b0:	c3                   	ret    

008028b1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8028b1:	55                   	push   %ebp
  8028b2:	89 e5                	mov    %esp,%ebp
  8028b4:	56                   	push   %esi
  8028b5:	53                   	push   %ebx
  8028b6:	83 ec 10             	sub    $0x10,%esp
  8028b9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8028bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8028c4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8028ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8028cd:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8028d2:	b8 07 00 00 00       	mov    $0x7,%eax
  8028d7:	e8 94 fe ff ff       	call   802770 <nsipc>
  8028dc:	89 c3                	mov    %eax,%ebx
  8028de:	85 c0                	test   %eax,%eax
  8028e0:	78 46                	js     802928 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8028e2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8028e7:	7f 04                	jg     8028ed <nsipc_recv+0x3c>
  8028e9:	39 c6                	cmp    %eax,%esi
  8028eb:	7d 24                	jge    802911 <nsipc_recv+0x60>
  8028ed:	c7 44 24 0c 48 3a 80 	movl   $0x803a48,0xc(%esp)
  8028f4:	00 
  8028f5:	c7 44 24 08 a1 39 80 	movl   $0x8039a1,0x8(%esp)
  8028fc:	00 
  8028fd:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802904:	00 
  802905:	c7 04 24 3c 3a 80 00 	movl   $0x803a3c,(%esp)
  80290c:	e8 13 d9 ff ff       	call   800224 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802911:	89 44 24 08          	mov    %eax,0x8(%esp)
  802915:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80291c:	00 
  80291d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802920:	89 04 24             	mov    %eax,(%esp)
  802923:	e8 5d e2 ff ff       	call   800b85 <memmove>
	}

	return r;
}
  802928:	89 d8                	mov    %ebx,%eax
  80292a:	83 c4 10             	add    $0x10,%esp
  80292d:	5b                   	pop    %ebx
  80292e:	5e                   	pop    %esi
  80292f:	5d                   	pop    %ebp
  802930:	c3                   	ret    

00802931 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802931:	55                   	push   %ebp
  802932:	89 e5                	mov    %esp,%ebp
  802934:	53                   	push   %ebx
  802935:	83 ec 14             	sub    $0x14,%esp
  802938:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80293b:	8b 45 08             	mov    0x8(%ebp),%eax
  80293e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802943:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802947:	8b 45 0c             	mov    0xc(%ebp),%eax
  80294a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80294e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802955:	e8 2b e2 ff ff       	call   800b85 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80295a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802960:	b8 05 00 00 00       	mov    $0x5,%eax
  802965:	e8 06 fe ff ff       	call   802770 <nsipc>
}
  80296a:	83 c4 14             	add    $0x14,%esp
  80296d:	5b                   	pop    %ebx
  80296e:	5d                   	pop    %ebp
  80296f:	c3                   	ret    

00802970 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802970:	55                   	push   %ebp
  802971:	89 e5                	mov    %esp,%ebp
  802973:	53                   	push   %ebx
  802974:	83 ec 14             	sub    $0x14,%esp
  802977:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80297a:	8b 45 08             	mov    0x8(%ebp),%eax
  80297d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802982:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802986:	8b 45 0c             	mov    0xc(%ebp),%eax
  802989:	89 44 24 04          	mov    %eax,0x4(%esp)
  80298d:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802994:	e8 ec e1 ff ff       	call   800b85 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802999:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80299f:	b8 02 00 00 00       	mov    $0x2,%eax
  8029a4:	e8 c7 fd ff ff       	call   802770 <nsipc>
}
  8029a9:	83 c4 14             	add    $0x14,%esp
  8029ac:	5b                   	pop    %ebx
  8029ad:	5d                   	pop    %ebp
  8029ae:	c3                   	ret    

008029af <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8029af:	55                   	push   %ebp
  8029b0:	89 e5                	mov    %esp,%ebp
  8029b2:	83 ec 18             	sub    $0x18,%esp
  8029b5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8029b8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8029bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029be:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8029c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8029c8:	e8 a3 fd ff ff       	call   802770 <nsipc>
  8029cd:	89 c3                	mov    %eax,%ebx
  8029cf:	85 c0                	test   %eax,%eax
  8029d1:	78 25                	js     8029f8 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8029d3:	be 10 60 80 00       	mov    $0x806010,%esi
  8029d8:	8b 06                	mov    (%esi),%eax
  8029da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029de:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8029e5:	00 
  8029e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029e9:	89 04 24             	mov    %eax,(%esp)
  8029ec:	e8 94 e1 ff ff       	call   800b85 <memmove>
		*addrlen = ret->ret_addrlen;
  8029f1:	8b 16                	mov    (%esi),%edx
  8029f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8029f6:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  8029f8:	89 d8                	mov    %ebx,%eax
  8029fa:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8029fd:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802a00:	89 ec                	mov    %ebp,%esp
  802a02:	5d                   	pop    %ebp
  802a03:	c3                   	ret    
	...

00802a10 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802a10:	55                   	push   %ebp
  802a11:	89 e5                	mov    %esp,%ebp
  802a13:	83 ec 18             	sub    $0x18,%esp
  802a16:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802a19:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802a1c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a22:	89 04 24             	mov    %eax,(%esp)
  802a25:	e8 c6 eb ff ff       	call   8015f0 <fd2data>
  802a2a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802a2c:	c7 44 24 04 5d 3a 80 	movl   $0x803a5d,0x4(%esp)
  802a33:	00 
  802a34:	89 34 24             	mov    %esi,(%esp)
  802a37:	e8 8e df ff ff       	call   8009ca <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802a3c:	8b 43 04             	mov    0x4(%ebx),%eax
  802a3f:	2b 03                	sub    (%ebx),%eax
  802a41:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802a47:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  802a4e:	00 00 00 
	stat->st_dev = &devpipe;
  802a51:	c7 86 88 00 00 00 44 	movl   $0x807044,0x88(%esi)
  802a58:	70 80 00 
	return 0;
}
  802a5b:	b8 00 00 00 00       	mov    $0x0,%eax
  802a60:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802a63:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802a66:	89 ec                	mov    %ebp,%esp
  802a68:	5d                   	pop    %ebp
  802a69:	c3                   	ret    

00802a6a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802a6a:	55                   	push   %ebp
  802a6b:	89 e5                	mov    %esp,%ebp
  802a6d:	53                   	push   %ebx
  802a6e:	83 ec 14             	sub    $0x14,%esp
  802a71:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802a74:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a78:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a7f:	e8 e6 e5 ff ff       	call   80106a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802a84:	89 1c 24             	mov    %ebx,(%esp)
  802a87:	e8 64 eb ff ff       	call   8015f0 <fd2data>
  802a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802a97:	e8 ce e5 ff ff       	call   80106a <sys_page_unmap>
}
  802a9c:	83 c4 14             	add    $0x14,%esp
  802a9f:	5b                   	pop    %ebx
  802aa0:	5d                   	pop    %ebp
  802aa1:	c3                   	ret    

00802aa2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802aa2:	55                   	push   %ebp
  802aa3:	89 e5                	mov    %esp,%ebp
  802aa5:	57                   	push   %edi
  802aa6:	56                   	push   %esi
  802aa7:	53                   	push   %ebx
  802aa8:	83 ec 2c             	sub    $0x2c,%esp
  802aab:	89 c7                	mov    %eax,%edi
  802aad:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802ab0:	a1 7c 70 80 00       	mov    0x80707c,%eax
  802ab5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802ab8:	89 3c 24             	mov    %edi,(%esp)
  802abb:	e8 a8 06 00 00       	call   803168 <pageref>
  802ac0:	89 c6                	mov    %eax,%esi
  802ac2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ac5:	89 04 24             	mov    %eax,(%esp)
  802ac8:	e8 9b 06 00 00       	call   803168 <pageref>
  802acd:	39 c6                	cmp    %eax,%esi
  802acf:	0f 94 c0             	sete   %al
  802ad2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802ad5:	8b 15 7c 70 80 00    	mov    0x80707c,%edx
  802adb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802ade:	39 cb                	cmp    %ecx,%ebx
  802ae0:	75 08                	jne    802aea <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802ae2:	83 c4 2c             	add    $0x2c,%esp
  802ae5:	5b                   	pop    %ebx
  802ae6:	5e                   	pop    %esi
  802ae7:	5f                   	pop    %edi
  802ae8:	5d                   	pop    %ebp
  802ae9:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  802aea:	83 f8 01             	cmp    $0x1,%eax
  802aed:	75 c1                	jne    802ab0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  802aef:	8b 52 58             	mov    0x58(%edx),%edx
  802af2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802af6:	89 54 24 08          	mov    %edx,0x8(%esp)
  802afa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802afe:	c7 04 24 64 3a 80 00 	movl   $0x803a64,(%esp)
  802b05:	e8 df d7 ff ff       	call   8002e9 <cprintf>
  802b0a:	eb a4                	jmp    802ab0 <_pipeisclosed+0xe>

00802b0c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802b0c:	55                   	push   %ebp
  802b0d:	89 e5                	mov    %esp,%ebp
  802b0f:	57                   	push   %edi
  802b10:	56                   	push   %esi
  802b11:	53                   	push   %ebx
  802b12:	83 ec 1c             	sub    $0x1c,%esp
  802b15:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802b18:	89 34 24             	mov    %esi,(%esp)
  802b1b:	e8 d0 ea ff ff       	call   8015f0 <fd2data>
  802b20:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802b22:	bf 00 00 00 00       	mov    $0x0,%edi
  802b27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802b2b:	75 54                	jne    802b81 <devpipe_write+0x75>
  802b2d:	eb 60                	jmp    802b8f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802b2f:	89 da                	mov    %ebx,%edx
  802b31:	89 f0                	mov    %esi,%eax
  802b33:	e8 6a ff ff ff       	call   802aa2 <_pipeisclosed>
  802b38:	85 c0                	test   %eax,%eax
  802b3a:	74 07                	je     802b43 <devpipe_write+0x37>
  802b3c:	b8 00 00 00 00       	mov    $0x0,%eax
  802b41:	eb 53                	jmp    802b96 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802b43:	90                   	nop
  802b44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b48:	e8 38 e6 ff ff       	call   801185 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802b4d:	8b 43 04             	mov    0x4(%ebx),%eax
  802b50:	8b 13                	mov    (%ebx),%edx
  802b52:	83 c2 20             	add    $0x20,%edx
  802b55:	39 d0                	cmp    %edx,%eax
  802b57:	73 d6                	jae    802b2f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802b59:	89 c2                	mov    %eax,%edx
  802b5b:	c1 fa 1f             	sar    $0x1f,%edx
  802b5e:	c1 ea 1b             	shr    $0x1b,%edx
  802b61:	01 d0                	add    %edx,%eax
  802b63:	83 e0 1f             	and    $0x1f,%eax
  802b66:	29 d0                	sub    %edx,%eax
  802b68:	89 c2                	mov    %eax,%edx
  802b6a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802b6d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802b71:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802b75:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802b79:	83 c7 01             	add    $0x1,%edi
  802b7c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  802b7f:	76 13                	jbe    802b94 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802b81:	8b 43 04             	mov    0x4(%ebx),%eax
  802b84:	8b 13                	mov    (%ebx),%edx
  802b86:	83 c2 20             	add    $0x20,%edx
  802b89:	39 d0                	cmp    %edx,%eax
  802b8b:	73 a2                	jae    802b2f <devpipe_write+0x23>
  802b8d:	eb ca                	jmp    802b59 <devpipe_write+0x4d>
  802b8f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802b94:	89 f8                	mov    %edi,%eax
}
  802b96:	83 c4 1c             	add    $0x1c,%esp
  802b99:	5b                   	pop    %ebx
  802b9a:	5e                   	pop    %esi
  802b9b:	5f                   	pop    %edi
  802b9c:	5d                   	pop    %ebp
  802b9d:	c3                   	ret    

00802b9e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802b9e:	55                   	push   %ebp
  802b9f:	89 e5                	mov    %esp,%ebp
  802ba1:	83 ec 28             	sub    $0x28,%esp
  802ba4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802ba7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802baa:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802bad:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802bb0:	89 3c 24             	mov    %edi,(%esp)
  802bb3:	e8 38 ea ff ff       	call   8015f0 <fd2data>
  802bb8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802bba:	be 00 00 00 00       	mov    $0x0,%esi
  802bbf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802bc3:	75 4c                	jne    802c11 <devpipe_read+0x73>
  802bc5:	eb 5b                	jmp    802c22 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802bc7:	89 f0                	mov    %esi,%eax
  802bc9:	eb 5e                	jmp    802c29 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802bcb:	89 da                	mov    %ebx,%edx
  802bcd:	89 f8                	mov    %edi,%eax
  802bcf:	90                   	nop
  802bd0:	e8 cd fe ff ff       	call   802aa2 <_pipeisclosed>
  802bd5:	85 c0                	test   %eax,%eax
  802bd7:	74 07                	je     802be0 <devpipe_read+0x42>
  802bd9:	b8 00 00 00 00       	mov    $0x0,%eax
  802bde:	eb 49                	jmp    802c29 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802be0:	e8 a0 e5 ff ff       	call   801185 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802be5:	8b 03                	mov    (%ebx),%eax
  802be7:	3b 43 04             	cmp    0x4(%ebx),%eax
  802bea:	74 df                	je     802bcb <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802bec:	89 c2                	mov    %eax,%edx
  802bee:	c1 fa 1f             	sar    $0x1f,%edx
  802bf1:	c1 ea 1b             	shr    $0x1b,%edx
  802bf4:	01 d0                	add    %edx,%eax
  802bf6:	83 e0 1f             	and    $0x1f,%eax
  802bf9:	29 d0                	sub    %edx,%eax
  802bfb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802c00:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c03:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802c06:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802c09:	83 c6 01             	add    $0x1,%esi
  802c0c:	39 75 10             	cmp    %esi,0x10(%ebp)
  802c0f:	76 16                	jbe    802c27 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802c11:	8b 03                	mov    (%ebx),%eax
  802c13:	3b 43 04             	cmp    0x4(%ebx),%eax
  802c16:	75 d4                	jne    802bec <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802c18:	85 f6                	test   %esi,%esi
  802c1a:	75 ab                	jne    802bc7 <devpipe_read+0x29>
  802c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c20:	eb a9                	jmp    802bcb <devpipe_read+0x2d>
  802c22:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802c27:	89 f0                	mov    %esi,%eax
}
  802c29:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802c2c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802c2f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802c32:	89 ec                	mov    %ebp,%esp
  802c34:	5d                   	pop    %ebp
  802c35:	c3                   	ret    

00802c36 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802c36:	55                   	push   %ebp
  802c37:	89 e5                	mov    %esp,%ebp
  802c39:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802c3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	89 04 24             	mov    %eax,(%esp)
  802c49:	e8 2f ea ff ff       	call   80167d <fd_lookup>
  802c4e:	85 c0                	test   %eax,%eax
  802c50:	78 15                	js     802c67 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802c52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c55:	89 04 24             	mov    %eax,(%esp)
  802c58:	e8 93 e9 ff ff       	call   8015f0 <fd2data>
	return _pipeisclosed(fd, p);
  802c5d:	89 c2                	mov    %eax,%edx
  802c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c62:	e8 3b fe ff ff       	call   802aa2 <_pipeisclosed>
}
  802c67:	c9                   	leave  
  802c68:	c3                   	ret    

00802c69 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802c69:	55                   	push   %ebp
  802c6a:	89 e5                	mov    %esp,%ebp
  802c6c:	83 ec 48             	sub    $0x48,%esp
  802c6f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802c72:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802c75:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802c78:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802c7b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802c7e:	89 04 24             	mov    %eax,(%esp)
  802c81:	e8 85 e9 ff ff       	call   80160b <fd_alloc>
  802c86:	89 c3                	mov    %eax,%ebx
  802c88:	85 c0                	test   %eax,%eax
  802c8a:	0f 88 42 01 00 00    	js     802dd2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802c90:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802c97:	00 
  802c98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c9b:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c9f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ca6:	e8 7b e4 ff ff       	call   801126 <sys_page_alloc>
  802cab:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802cad:	85 c0                	test   %eax,%eax
  802caf:	0f 88 1d 01 00 00    	js     802dd2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802cb5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802cb8:	89 04 24             	mov    %eax,(%esp)
  802cbb:	e8 4b e9 ff ff       	call   80160b <fd_alloc>
  802cc0:	89 c3                	mov    %eax,%ebx
  802cc2:	85 c0                	test   %eax,%eax
  802cc4:	0f 88 f5 00 00 00    	js     802dbf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cca:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802cd1:	00 
  802cd2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802cd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802cd9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ce0:	e8 41 e4 ff ff       	call   801126 <sys_page_alloc>
  802ce5:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802ce7:	85 c0                	test   %eax,%eax
  802ce9:	0f 88 d0 00 00 00    	js     802dbf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802cef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802cf2:	89 04 24             	mov    %eax,(%esp)
  802cf5:	e8 f6 e8 ff ff       	call   8015f0 <fd2data>
  802cfa:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802cfc:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802d03:	00 
  802d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d08:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d0f:	e8 12 e4 ff ff       	call   801126 <sys_page_alloc>
  802d14:	89 c3                	mov    %eax,%ebx
  802d16:	85 c0                	test   %eax,%eax
  802d18:	0f 88 8e 00 00 00    	js     802dac <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802d1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d21:	89 04 24             	mov    %eax,(%esp)
  802d24:	e8 c7 e8 ff ff       	call   8015f0 <fd2data>
  802d29:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802d30:	00 
  802d31:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802d35:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802d3c:	00 
  802d3d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d41:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802d48:	e8 7b e3 ff ff       	call   8010c8 <sys_page_map>
  802d4d:	89 c3                	mov    %eax,%ebx
  802d4f:	85 c0                	test   %eax,%eax
  802d51:	78 49                	js     802d9c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802d53:	b8 44 70 80 00       	mov    $0x807044,%eax
  802d58:	8b 08                	mov    (%eax),%ecx
  802d5a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d5d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802d5f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d62:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802d69:	8b 10                	mov    (%eax),%edx
  802d6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d6e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802d70:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d73:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  802d7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d7d:	89 04 24             	mov    %eax,(%esp)
  802d80:	e8 5b e8 ff ff       	call   8015e0 <fd2num>
  802d85:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802d87:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802d8a:	89 04 24             	mov    %eax,(%esp)
  802d8d:	e8 4e e8 ff ff       	call   8015e0 <fd2num>
  802d92:	89 47 04             	mov    %eax,0x4(%edi)
  802d95:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  802d9a:	eb 36                	jmp    802dd2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802d9c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802da0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802da7:	e8 be e2 ff ff       	call   80106a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802dac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802daf:	89 44 24 04          	mov    %eax,0x4(%esp)
  802db3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dba:	e8 ab e2 ff ff       	call   80106a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802dbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dc6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802dcd:	e8 98 e2 ff ff       	call   80106a <sys_page_unmap>
    err:
	return r;
}
  802dd2:	89 d8                	mov    %ebx,%eax
  802dd4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802dd7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802dda:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802ddd:	89 ec                	mov    %ebp,%esp
  802ddf:	5d                   	pop    %ebp
  802de0:	c3                   	ret    
  802de1:	00 00                	add    %al,(%eax)
	...

00802de4 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802de4:	55                   	push   %ebp
  802de5:	89 e5                	mov    %esp,%ebp
  802de7:	56                   	push   %esi
  802de8:	53                   	push   %ebx
  802de9:	83 ec 10             	sub    $0x10,%esp
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
	volatile struct Env *e;

	assert(envid != 0);
  802def:	85 c0                	test   %eax,%eax
  802df1:	75 24                	jne    802e17 <wait+0x33>
  802df3:	c7 44 24 0c 7c 3a 80 	movl   $0x803a7c,0xc(%esp)
  802dfa:	00 
  802dfb:	c7 44 24 08 a1 39 80 	movl   $0x8039a1,0x8(%esp)
  802e02:	00 
  802e03:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802e0a:	00 
  802e0b:	c7 04 24 87 3a 80 00 	movl   $0x803a87,(%esp)
  802e12:	e8 0d d4 ff ff       	call   800224 <_panic>
	e = &envs[ENVX(envid)];
  802e17:	89 c3                	mov    %eax,%ebx
  802e19:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802e1f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802e22:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802e28:	8b 73 4c             	mov    0x4c(%ebx),%esi
  802e2b:	39 c6                	cmp    %eax,%esi
  802e2d:	75 1a                	jne    802e49 <wait+0x65>
  802e2f:	8b 43 54             	mov    0x54(%ebx),%eax
  802e32:	85 c0                	test   %eax,%eax
  802e34:	74 13                	je     802e49 <wait+0x65>
		sys_yield();
  802e36:	e8 4a e3 ff ff       	call   801185 <sys_yield>
{
	volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802e3b:	8b 43 4c             	mov    0x4c(%ebx),%eax
  802e3e:	39 f0                	cmp    %esi,%eax
  802e40:	75 07                	jne    802e49 <wait+0x65>
  802e42:	8b 43 54             	mov    0x54(%ebx),%eax
  802e45:	85 c0                	test   %eax,%eax
  802e47:	75 ed                	jne    802e36 <wait+0x52>
		sys_yield();
}
  802e49:	83 c4 10             	add    $0x10,%esp
  802e4c:	5b                   	pop    %ebx
  802e4d:	5e                   	pop    %esi
  802e4e:	5d                   	pop    %ebp
  802e4f:	c3                   	ret    

00802e50 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802e50:	55                   	push   %ebp
  802e51:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802e53:	b8 00 00 00 00       	mov    $0x0,%eax
  802e58:	5d                   	pop    %ebp
  802e59:	c3                   	ret    

00802e5a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802e5a:	55                   	push   %ebp
  802e5b:	89 e5                	mov    %esp,%ebp
  802e5d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802e60:	c7 44 24 04 92 3a 80 	movl   $0x803a92,0x4(%esp)
  802e67:	00 
  802e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  802e6b:	89 04 24             	mov    %eax,(%esp)
  802e6e:	e8 57 db ff ff       	call   8009ca <strcpy>
	return 0;
}
  802e73:	b8 00 00 00 00       	mov    $0x0,%eax
  802e78:	c9                   	leave  
  802e79:	c3                   	ret    

00802e7a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802e7a:	55                   	push   %ebp
  802e7b:	89 e5                	mov    %esp,%ebp
  802e7d:	57                   	push   %edi
  802e7e:	56                   	push   %esi
  802e7f:	53                   	push   %ebx
  802e80:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802e86:	b8 00 00 00 00       	mov    $0x0,%eax
  802e8b:	be 00 00 00 00       	mov    $0x0,%esi
  802e90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802e94:	74 3f                	je     802ed5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802e96:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802e9c:	8b 55 10             	mov    0x10(%ebp),%edx
  802e9f:	29 c2                	sub    %eax,%edx
  802ea1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802ea3:	83 fa 7f             	cmp    $0x7f,%edx
  802ea6:	76 05                	jbe    802ead <devcons_write+0x33>
  802ea8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802ead:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802eb1:	03 45 0c             	add    0xc(%ebp),%eax
  802eb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802eb8:	89 3c 24             	mov    %edi,(%esp)
  802ebb:	e8 c5 dc ff ff       	call   800b85 <memmove>
		sys_cputs(buf, m);
  802ec0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802ec4:	89 3c 24             	mov    %edi,(%esp)
  802ec7:	e8 f4 de ff ff       	call   800dc0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802ecc:	01 de                	add    %ebx,%esi
  802ece:	89 f0                	mov    %esi,%eax
  802ed0:	3b 75 10             	cmp    0x10(%ebp),%esi
  802ed3:	72 c7                	jb     802e9c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802ed5:	89 f0                	mov    %esi,%eax
  802ed7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802edd:	5b                   	pop    %ebx
  802ede:	5e                   	pop    %esi
  802edf:	5f                   	pop    %edi
  802ee0:	5d                   	pop    %ebp
  802ee1:	c3                   	ret    

00802ee2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802ee2:	55                   	push   %ebp
  802ee3:	89 e5                	mov    %esp,%ebp
  802ee5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802eee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802ef5:	00 
  802ef6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802ef9:	89 04 24             	mov    %eax,(%esp)
  802efc:	e8 bf de ff ff       	call   800dc0 <sys_cputs>
}
  802f01:	c9                   	leave  
  802f02:	c3                   	ret    

00802f03 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802f03:	55                   	push   %ebp
  802f04:	89 e5                	mov    %esp,%ebp
  802f06:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802f09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802f0d:	75 07                	jne    802f16 <devcons_read+0x13>
  802f0f:	eb 28                	jmp    802f39 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802f11:	e8 6f e2 ff ff       	call   801185 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802f16:	66 90                	xchg   %ax,%ax
  802f18:	e8 6f de ff ff       	call   800d8c <sys_cgetc>
  802f1d:	85 c0                	test   %eax,%eax
  802f1f:	90                   	nop
  802f20:	74 ef                	je     802f11 <devcons_read+0xe>
  802f22:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802f24:	85 c0                	test   %eax,%eax
  802f26:	78 16                	js     802f3e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802f28:	83 f8 04             	cmp    $0x4,%eax
  802f2b:	74 0c                	je     802f39 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f30:	88 10                	mov    %dl,(%eax)
  802f32:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802f37:	eb 05                	jmp    802f3e <devcons_read+0x3b>
  802f39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f3e:	c9                   	leave  
  802f3f:	c3                   	ret    

00802f40 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802f40:	55                   	push   %ebp
  802f41:	89 e5                	mov    %esp,%ebp
  802f43:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802f46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f49:	89 04 24             	mov    %eax,(%esp)
  802f4c:	e8 ba e6 ff ff       	call   80160b <fd_alloc>
  802f51:	85 c0                	test   %eax,%eax
  802f53:	78 3f                	js     802f94 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802f55:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802f5c:	00 
  802f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f60:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f64:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f6b:	e8 b6 e1 ff ff       	call   801126 <sys_page_alloc>
  802f70:	85 c0                	test   %eax,%eax
  802f72:	78 20                	js     802f94 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802f74:	8b 15 60 70 80 00    	mov    0x807060,%edx
  802f7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f82:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8c:	89 04 24             	mov    %eax,(%esp)
  802f8f:	e8 4c e6 ff ff       	call   8015e0 <fd2num>
}
  802f94:	c9                   	leave  
  802f95:	c3                   	ret    

00802f96 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802f96:	55                   	push   %ebp
  802f97:	89 e5                	mov    %esp,%ebp
  802f99:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f9f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa6:	89 04 24             	mov    %eax,(%esp)
  802fa9:	e8 cf e6 ff ff       	call   80167d <fd_lookup>
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	78 11                	js     802fc3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802fb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb5:	8b 00                	mov    (%eax),%eax
  802fb7:	3b 05 60 70 80 00    	cmp    0x807060,%eax
  802fbd:	0f 94 c0             	sete   %al
  802fc0:	0f b6 c0             	movzbl %al,%eax
}
  802fc3:	c9                   	leave  
  802fc4:	c3                   	ret    

00802fc5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802fc5:	55                   	push   %ebp
  802fc6:	89 e5                	mov    %esp,%ebp
  802fc8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802fcb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802fd2:	00 
  802fd3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802fd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802fda:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802fe1:	e8 f8 e8 ff ff       	call   8018de <read>
	if (r < 0)
  802fe6:	85 c0                	test   %eax,%eax
  802fe8:	78 0f                	js     802ff9 <getchar+0x34>
		return r;
	if (r < 1)
  802fea:	85 c0                	test   %eax,%eax
  802fec:	7f 07                	jg     802ff5 <getchar+0x30>
  802fee:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802ff3:	eb 04                	jmp    802ff9 <getchar+0x34>
		return -E_EOF;
	return c;
  802ff5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802ff9:	c9                   	leave  
  802ffa:	c3                   	ret    
	...

00802ffc <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802ffc:	55                   	push   %ebp
  802ffd:	89 e5                	mov    %esp,%ebp
  802fff:	53                   	push   %ebx
  803000:	83 ec 14             	sub    $0x14,%esp
  803003:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    // cprintf("\nhere outside loading creating page\n");

	if (_pgfault_handler == 0) {
  803006:	83 3d 84 70 80 00 00 	cmpl   $0x0,0x807084
  80300d:	75 58                	jne    803067 <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
           //cprintf("\nhere inside loading creating page\n");    
          if(sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  80300f:	e8 a5 e1 ff ff       	call   8011b9 <sys_getenvid>
  803014:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80301b:	00 
  80301c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  803023:	ee 
  803024:	89 04 24             	mov    %eax,(%esp)
  803027:	e8 fa e0 ff ff       	call   801126 <sys_page_alloc>
  80302c:	85 c0                	test   %eax,%eax
  80302e:	79 1c                	jns    80304c <set_pgfault_handler+0x50>
                          panic("Cant allocate Page");                    
  803030:	c7 44 24 08 6c 38 80 	movl   $0x80386c,0x8(%esp)
  803037:	00 
  803038:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  80303f:	00 
  803040:	c7 04 24 9e 3a 80 00 	movl   $0x803a9e,(%esp)
  803047:	e8 d8 d1 ff ff       	call   800224 <_panic>
                _pgfault_handler=handler;
  80304c:	89 1d 84 70 80 00    	mov    %ebx,0x807084
//entry point _pgfault_handler not pointed to by the kernel bcz after the execution is complete control needs to be returned back to execute the rest...so upcall is there         
             sys_env_set_pgfault_upcall(sys_getenvid(),_pgfault_upcall);
  803052:	e8 62 e1 ff ff       	call   8011b9 <sys_getenvid>
  803057:	c7 44 24 04 74 30 80 	movl   $0x803074,0x4(%esp)
  80305e:	00 
  80305f:	89 04 24             	mov    %eax,(%esp)
  803062:	e8 e9 de ff ff       	call   800f50 <sys_env_set_pgfault_upcall>

	// Save handler pointer for assembly to call.
 //     if(sys_page_alloc(0,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
   //                       panic("Cant allocate Page");

	_pgfault_handler = handler;
  803067:	89 1d 84 70 80 00    	mov    %ebx,0x807084
}
  80306d:	83 c4 14             	add    $0x14,%esp
  803070:	5b                   	pop    %ebx
  803071:	5d                   	pop    %ebp
  803072:	c3                   	ret    
	...

00803074 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  803074:	54                   	push   %esp
	movl _pgfault_handler, %eax
  803075:	a1 84 70 80 00       	mov    0x807084,%eax
	call *%eax
  80307a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80307c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
           addl $8,%esp
  80307f:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
            movl  32(%esp),%ebx
  803082:	8b 5c 24 20          	mov    0x20(%esp),%ebx
            movl  40(%esp),%eax
  803086:	8b 44 24 28          	mov    0x28(%esp),%eax
            subl  $4,%eax
  80308a:	83 e8 04             	sub    $0x4,%eax
            movl  %eax,40(%esp)
  80308d:	89 44 24 28          	mov    %eax,0x28(%esp)
            movl  %ebx,(%eax)
  803091:	89 18                	mov    %ebx,(%eax)
            popal
  803093:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
            
            add $4,%esp            
  803094:	83 c4 04             	add    $0x4,%esp
            popfl
  803097:	9d                   	popf   
             
           popl %esp
  803098:	5c                   	pop    %esp
	// LAB 4: Your code here.
           

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
           ret
  803099:	c3                   	ret    
  80309a:	00 00                	add    %al,(%eax)
  80309c:	00 00                	add    %al,(%eax)
	...

008030a0 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8030a0:	55                   	push   %ebp
  8030a1:	89 e5                	mov    %esp,%ebp
  8030a3:	57                   	push   %edi
  8030a4:	56                   	push   %esi
  8030a5:	53                   	push   %ebx
  8030a6:	83 ec 1c             	sub    $0x1c,%esp
  8030a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8030ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  8030af:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  8030b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8030b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8030b9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8030bd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8030c1:	89 1c 24             	mov    %ebx,(%esp)
  8030c4:	e8 4f de ff ff       	call   800f18 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  8030c9:	85 c0                	test   %eax,%eax
  8030cb:	79 21                	jns    8030ee <ipc_send+0x4e>
  8030cd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8030d0:	74 1c                	je     8030ee <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  8030d2:	c7 44 24 08 ac 3a 80 	movl   $0x803aac,0x8(%esp)
  8030d9:	00 
  8030da:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  8030e1:	00 
  8030e2:	c7 04 24 be 3a 80 00 	movl   $0x803abe,(%esp)
  8030e9:	e8 36 d1 ff ff       	call   800224 <_panic>
          else if(r==-E_IPC_NOT_RECV)
  8030ee:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8030f1:	75 07                	jne    8030fa <ipc_send+0x5a>
           sys_yield();
  8030f3:	e8 8d e0 ff ff       	call   801185 <sys_yield>
          else
            break;
        }
  8030f8:	eb b8                	jmp    8030b2 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  8030fa:	83 c4 1c             	add    $0x1c,%esp
  8030fd:	5b                   	pop    %ebx
  8030fe:	5e                   	pop    %esi
  8030ff:	5f                   	pop    %edi
  803100:	5d                   	pop    %ebp
  803101:	c3                   	ret    

00803102 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803102:	55                   	push   %ebp
  803103:	89 e5                	mov    %esp,%ebp
  803105:	83 ec 18             	sub    $0x18,%esp
  803108:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80310b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80310e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803111:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  803114:	8b 45 0c             	mov    0xc(%ebp),%eax
  803117:	89 04 24             	mov    %eax,(%esp)
  80311a:	e8 9c dd ff ff       	call   800ebb <sys_ipc_recv>
        if(r<0)
  80311f:	85 c0                	test   %eax,%eax
  803121:	79 17                	jns    80313a <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  803123:	85 db                	test   %ebx,%ebx
  803125:	74 06                	je     80312d <ipc_recv+0x2b>
               *from_env_store =0;
  803127:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  80312d:	85 f6                	test   %esi,%esi
  80312f:	90                   	nop
  803130:	74 2c                	je     80315e <ipc_recv+0x5c>
              *perm_store=0;
  803132:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  803138:	eb 24                	jmp    80315e <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  80313a:	85 db                	test   %ebx,%ebx
  80313c:	74 0a                	je     803148 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  80313e:	a1 7c 70 80 00       	mov    0x80707c,%eax
  803143:	8b 40 74             	mov    0x74(%eax),%eax
  803146:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  803148:	85 f6                	test   %esi,%esi
  80314a:	74 0a                	je     803156 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  80314c:	a1 7c 70 80 00       	mov    0x80707c,%eax
  803151:	8b 40 78             	mov    0x78(%eax),%eax
  803154:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  803156:	a1 7c 70 80 00       	mov    0x80707c,%eax
  80315b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80315e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803161:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803164:	89 ec                	mov    %ebp,%esp
  803166:	5d                   	pop    %ebp
  803167:	c3                   	ret    

00803168 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803168:	55                   	push   %ebp
  803169:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80316b:	8b 45 08             	mov    0x8(%ebp),%eax
  80316e:	89 c2                	mov    %eax,%edx
  803170:	c1 ea 16             	shr    $0x16,%edx
  803173:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80317a:	f6 c2 01             	test   $0x1,%dl
  80317d:	74 26                	je     8031a5 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  80317f:	c1 e8 0c             	shr    $0xc,%eax
  803182:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  803189:	a8 01                	test   $0x1,%al
  80318b:	74 18                	je     8031a5 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  80318d:	c1 e8 0c             	shr    $0xc,%eax
  803190:	8d 14 40             	lea    (%eax,%eax,2),%edx
  803193:	c1 e2 02             	shl    $0x2,%edx
  803196:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  80319b:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  8031a0:	0f b7 c0             	movzwl %ax,%eax
  8031a3:	eb 05                	jmp    8031aa <pageref+0x42>
  8031a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8031aa:	5d                   	pop    %ebp
  8031ab:	c3                   	ret    
  8031ac:	00 00                	add    %al,(%eax)
	...

008031b0 <__udivdi3>:
  8031b0:	55                   	push   %ebp
  8031b1:	89 e5                	mov    %esp,%ebp
  8031b3:	57                   	push   %edi
  8031b4:	56                   	push   %esi
  8031b5:	83 ec 10             	sub    $0x10,%esp
  8031b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8031bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8031be:	8b 75 10             	mov    0x10(%ebp),%esi
  8031c1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8031c4:	85 c0                	test   %eax,%eax
  8031c6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8031c9:	75 35                	jne    803200 <__udivdi3+0x50>
  8031cb:	39 fe                	cmp    %edi,%esi
  8031cd:	77 61                	ja     803230 <__udivdi3+0x80>
  8031cf:	85 f6                	test   %esi,%esi
  8031d1:	75 0b                	jne    8031de <__udivdi3+0x2e>
  8031d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8031d8:	31 d2                	xor    %edx,%edx
  8031da:	f7 f6                	div    %esi
  8031dc:	89 c6                	mov    %eax,%esi
  8031de:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8031e1:	31 d2                	xor    %edx,%edx
  8031e3:	89 f8                	mov    %edi,%eax
  8031e5:	f7 f6                	div    %esi
  8031e7:	89 c7                	mov    %eax,%edi
  8031e9:	89 c8                	mov    %ecx,%eax
  8031eb:	f7 f6                	div    %esi
  8031ed:	89 c1                	mov    %eax,%ecx
  8031ef:	89 fa                	mov    %edi,%edx
  8031f1:	89 c8                	mov    %ecx,%eax
  8031f3:	83 c4 10             	add    $0x10,%esp
  8031f6:	5e                   	pop    %esi
  8031f7:	5f                   	pop    %edi
  8031f8:	5d                   	pop    %ebp
  8031f9:	c3                   	ret    
  8031fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803200:	39 f8                	cmp    %edi,%eax
  803202:	77 1c                	ja     803220 <__udivdi3+0x70>
  803204:	0f bd d0             	bsr    %eax,%edx
  803207:	83 f2 1f             	xor    $0x1f,%edx
  80320a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80320d:	75 39                	jne    803248 <__udivdi3+0x98>
  80320f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  803212:	0f 86 a0 00 00 00    	jbe    8032b8 <__udivdi3+0x108>
  803218:	39 f8                	cmp    %edi,%eax
  80321a:	0f 82 98 00 00 00    	jb     8032b8 <__udivdi3+0x108>
  803220:	31 ff                	xor    %edi,%edi
  803222:	31 c9                	xor    %ecx,%ecx
  803224:	89 c8                	mov    %ecx,%eax
  803226:	89 fa                	mov    %edi,%edx
  803228:	83 c4 10             	add    $0x10,%esp
  80322b:	5e                   	pop    %esi
  80322c:	5f                   	pop    %edi
  80322d:	5d                   	pop    %ebp
  80322e:	c3                   	ret    
  80322f:	90                   	nop
  803230:	89 d1                	mov    %edx,%ecx
  803232:	89 fa                	mov    %edi,%edx
  803234:	89 c8                	mov    %ecx,%eax
  803236:	31 ff                	xor    %edi,%edi
  803238:	f7 f6                	div    %esi
  80323a:	89 c1                	mov    %eax,%ecx
  80323c:	89 fa                	mov    %edi,%edx
  80323e:	89 c8                	mov    %ecx,%eax
  803240:	83 c4 10             	add    $0x10,%esp
  803243:	5e                   	pop    %esi
  803244:	5f                   	pop    %edi
  803245:	5d                   	pop    %ebp
  803246:	c3                   	ret    
  803247:	90                   	nop
  803248:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80324c:	89 f2                	mov    %esi,%edx
  80324e:	d3 e0                	shl    %cl,%eax
  803250:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803253:	b8 20 00 00 00       	mov    $0x20,%eax
  803258:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80325b:	89 c1                	mov    %eax,%ecx
  80325d:	d3 ea                	shr    %cl,%edx
  80325f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803263:	0b 55 ec             	or     -0x14(%ebp),%edx
  803266:	d3 e6                	shl    %cl,%esi
  803268:	89 c1                	mov    %eax,%ecx
  80326a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80326d:	89 fe                	mov    %edi,%esi
  80326f:	d3 ee                	shr    %cl,%esi
  803271:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803275:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803278:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80327b:	d3 e7                	shl    %cl,%edi
  80327d:	89 c1                	mov    %eax,%ecx
  80327f:	d3 ea                	shr    %cl,%edx
  803281:	09 d7                	or     %edx,%edi
  803283:	89 f2                	mov    %esi,%edx
  803285:	89 f8                	mov    %edi,%eax
  803287:	f7 75 ec             	divl   -0x14(%ebp)
  80328a:	89 d6                	mov    %edx,%esi
  80328c:	89 c7                	mov    %eax,%edi
  80328e:	f7 65 e8             	mull   -0x18(%ebp)
  803291:	39 d6                	cmp    %edx,%esi
  803293:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803296:	72 30                	jb     8032c8 <__udivdi3+0x118>
  803298:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80329b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80329f:	d3 e2                	shl    %cl,%edx
  8032a1:	39 c2                	cmp    %eax,%edx
  8032a3:	73 05                	jae    8032aa <__udivdi3+0xfa>
  8032a5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8032a8:	74 1e                	je     8032c8 <__udivdi3+0x118>
  8032aa:	89 f9                	mov    %edi,%ecx
  8032ac:	31 ff                	xor    %edi,%edi
  8032ae:	e9 71 ff ff ff       	jmp    803224 <__udivdi3+0x74>
  8032b3:	90                   	nop
  8032b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8032b8:	31 ff                	xor    %edi,%edi
  8032ba:	b9 01 00 00 00       	mov    $0x1,%ecx
  8032bf:	e9 60 ff ff ff       	jmp    803224 <__udivdi3+0x74>
  8032c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8032c8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  8032cb:	31 ff                	xor    %edi,%edi
  8032cd:	89 c8                	mov    %ecx,%eax
  8032cf:	89 fa                	mov    %edi,%edx
  8032d1:	83 c4 10             	add    $0x10,%esp
  8032d4:	5e                   	pop    %esi
  8032d5:	5f                   	pop    %edi
  8032d6:	5d                   	pop    %ebp
  8032d7:	c3                   	ret    
	...

008032e0 <__umoddi3>:
  8032e0:	55                   	push   %ebp
  8032e1:	89 e5                	mov    %esp,%ebp
  8032e3:	57                   	push   %edi
  8032e4:	56                   	push   %esi
  8032e5:	83 ec 20             	sub    $0x20,%esp
  8032e8:	8b 55 14             	mov    0x14(%ebp),%edx
  8032eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8032ee:	8b 7d 10             	mov    0x10(%ebp),%edi
  8032f1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8032f4:	85 d2                	test   %edx,%edx
  8032f6:	89 c8                	mov    %ecx,%eax
  8032f8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8032fb:	75 13                	jne    803310 <__umoddi3+0x30>
  8032fd:	39 f7                	cmp    %esi,%edi
  8032ff:	76 3f                	jbe    803340 <__umoddi3+0x60>
  803301:	89 f2                	mov    %esi,%edx
  803303:	f7 f7                	div    %edi
  803305:	89 d0                	mov    %edx,%eax
  803307:	31 d2                	xor    %edx,%edx
  803309:	83 c4 20             	add    $0x20,%esp
  80330c:	5e                   	pop    %esi
  80330d:	5f                   	pop    %edi
  80330e:	5d                   	pop    %ebp
  80330f:	c3                   	ret    
  803310:	39 f2                	cmp    %esi,%edx
  803312:	77 4c                	ja     803360 <__umoddi3+0x80>
  803314:	0f bd ca             	bsr    %edx,%ecx
  803317:	83 f1 1f             	xor    $0x1f,%ecx
  80331a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80331d:	75 51                	jne    803370 <__umoddi3+0x90>
  80331f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  803322:	0f 87 e0 00 00 00    	ja     803408 <__umoddi3+0x128>
  803328:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80332b:	29 f8                	sub    %edi,%eax
  80332d:	19 d6                	sbb    %edx,%esi
  80332f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803335:	89 f2                	mov    %esi,%edx
  803337:	83 c4 20             	add    $0x20,%esp
  80333a:	5e                   	pop    %esi
  80333b:	5f                   	pop    %edi
  80333c:	5d                   	pop    %ebp
  80333d:	c3                   	ret    
  80333e:	66 90                	xchg   %ax,%ax
  803340:	85 ff                	test   %edi,%edi
  803342:	75 0b                	jne    80334f <__umoddi3+0x6f>
  803344:	b8 01 00 00 00       	mov    $0x1,%eax
  803349:	31 d2                	xor    %edx,%edx
  80334b:	f7 f7                	div    %edi
  80334d:	89 c7                	mov    %eax,%edi
  80334f:	89 f0                	mov    %esi,%eax
  803351:	31 d2                	xor    %edx,%edx
  803353:	f7 f7                	div    %edi
  803355:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803358:	f7 f7                	div    %edi
  80335a:	eb a9                	jmp    803305 <__umoddi3+0x25>
  80335c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803360:	89 c8                	mov    %ecx,%eax
  803362:	89 f2                	mov    %esi,%edx
  803364:	83 c4 20             	add    $0x20,%esp
  803367:	5e                   	pop    %esi
  803368:	5f                   	pop    %edi
  803369:	5d                   	pop    %ebp
  80336a:	c3                   	ret    
  80336b:	90                   	nop
  80336c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803370:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803374:	d3 e2                	shl    %cl,%edx
  803376:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803379:	ba 20 00 00 00       	mov    $0x20,%edx
  80337e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  803381:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803384:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803388:	89 fa                	mov    %edi,%edx
  80338a:	d3 ea                	shr    %cl,%edx
  80338c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803390:	0b 55 f4             	or     -0xc(%ebp),%edx
  803393:	d3 e7                	shl    %cl,%edi
  803395:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803399:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80339c:	89 f2                	mov    %esi,%edx
  80339e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8033a1:	89 c7                	mov    %eax,%edi
  8033a3:	d3 ea                	shr    %cl,%edx
  8033a5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8033a9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8033ac:	89 c2                	mov    %eax,%edx
  8033ae:	d3 e6                	shl    %cl,%esi
  8033b0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8033b4:	d3 ea                	shr    %cl,%edx
  8033b6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8033ba:	09 d6                	or     %edx,%esi
  8033bc:	89 f0                	mov    %esi,%eax
  8033be:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8033c1:	d3 e7                	shl    %cl,%edi
  8033c3:	89 f2                	mov    %esi,%edx
  8033c5:	f7 75 f4             	divl   -0xc(%ebp)
  8033c8:	89 d6                	mov    %edx,%esi
  8033ca:	f7 65 e8             	mull   -0x18(%ebp)
  8033cd:	39 d6                	cmp    %edx,%esi
  8033cf:	72 2b                	jb     8033fc <__umoddi3+0x11c>
  8033d1:	39 c7                	cmp    %eax,%edi
  8033d3:	72 23                	jb     8033f8 <__umoddi3+0x118>
  8033d5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8033d9:	29 c7                	sub    %eax,%edi
  8033db:	19 d6                	sbb    %edx,%esi
  8033dd:	89 f0                	mov    %esi,%eax
  8033df:	89 f2                	mov    %esi,%edx
  8033e1:	d3 ef                	shr    %cl,%edi
  8033e3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8033e7:	d3 e0                	shl    %cl,%eax
  8033e9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8033ed:	09 f8                	or     %edi,%eax
  8033ef:	d3 ea                	shr    %cl,%edx
  8033f1:	83 c4 20             	add    $0x20,%esp
  8033f4:	5e                   	pop    %esi
  8033f5:	5f                   	pop    %edi
  8033f6:	5d                   	pop    %ebp
  8033f7:	c3                   	ret    
  8033f8:	39 d6                	cmp    %edx,%esi
  8033fa:	75 d9                	jne    8033d5 <__umoddi3+0xf5>
  8033fc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8033ff:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  803402:	eb d1                	jmp    8033d5 <__umoddi3+0xf5>
  803404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803408:	39 f2                	cmp    %esi,%edx
  80340a:	0f 82 18 ff ff ff    	jb     803328 <__umoddi3+0x48>
  803410:	e9 1d ff ff ff       	jmp    803332 <__umoddi3+0x52>
