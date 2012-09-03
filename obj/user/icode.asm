
obj/user/icode:     file format elf32-i386


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
  80002c:	e8 2b 01 00 00       	call   80015c <libmain>
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
  800039:	81 ec 30 02 00 00    	sub    $0x230,%esp
	int fd, n, r;
	char buf[512+1];

	binaryname = "icode";
  80003f:	c7 05 00 70 80 00 40 	movl   $0x802f40,0x807000
  800046:	2f 80 00 

	cprintf("icode startup\n");
  800049:	c7 04 24 46 2f 80 00 	movl   $0x802f46,(%esp)
  800050:	e8 38 02 00 00       	call   80028d <cprintf>

	cprintf("icode: open /motd\n");
  800055:	c7 04 24 55 2f 80 00 	movl   $0x802f55,(%esp)
  80005c:	e8 2c 02 00 00       	call   80028d <cprintf>
	
       

      
 if ((fd = open("/motd", O_RDONLY)) < 0)
  800061:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800068:	00 
  800069:	c7 04 24 68 2f 80 00 	movl   $0x802f68,(%esp)
  800070:	e8 d2 19 00 00       	call   801a47 <open>
  800075:	89 c6                	mov    %eax,%esi
  800077:	85 c0                	test   %eax,%eax
  800079:	79 20                	jns    80009b <umain+0x67>
		panic("icode: open /motd: %e", fd);
  80007b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80007f:	c7 44 24 08 6e 2f 80 	movl   $0x802f6e,0x8(%esp)
  800086:	00 
  800087:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  80008e:	00 
  80008f:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  800096:	e8 2d 01 00 00       	call   8001c8 <_panic>
      cprintf("icode: read /motd\n");
  80009b:	c7 04 24 91 2f 80 00 	movl   $0x802f91,(%esp)
  8000a2:	e8 e6 01 00 00       	call   80028d <cprintf>
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000a7:	8d 9d f7 fd ff ff    	lea    -0x209(%ebp),%ebx
  8000ad:	eb 0c                	jmp    8000bb <umain+0x87>
		sys_cputs(buf, n);
  8000af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b3:	89 1c 24             	mov    %ebx,(%esp)
  8000b6:	e8 a5 0c 00 00       	call   800d60 <sys_cputs>

      
 if ((fd = open("/motd", O_RDONLY)) < 0)
		panic("icode: open /motd: %e", fd);
      cprintf("icode: read /motd\n");
	while ((n = read(fd, buf, sizeof buf-1)) > 0)
  8000bb:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8000c2:	00 
  8000c3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000c7:	89 34 24             	mov    %esi,(%esp)
  8000ca:	e8 1f 14 00 00       	call   8014ee <read>
  8000cf:	85 c0                	test   %eax,%eax
  8000d1:	7f dc                	jg     8000af <umain+0x7b>
		sys_cputs(buf, n);

	cprintf("icode: close /motd\n");
  8000d3:	c7 04 24 a4 2f 80 00 	movl   $0x802fa4,(%esp)
  8000da:	e8 ae 01 00 00       	call   80028d <cprintf>
	close(fd);
  8000df:	89 34 24             	mov    %esi,(%esp)
  8000e2:	e8 67 15 00 00       	call   80164e <close>

	cprintf("icode: spawn /init\n");
  8000e7:	c7 04 24 b8 2f 80 00 	movl   $0x802fb8,(%esp)
  8000ee:	e8 9a 01 00 00       	call   80028d <cprintf>
	if ((r = spawnl("/init", "init", "initarg1", "initarg2", (char*)0)) < 0)
  8000f3:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
  8000fa:	00 
  8000fb:	c7 44 24 0c cc 2f 80 	movl   $0x802fcc,0xc(%esp)
  800102:	00 
  800103:	c7 44 24 08 d5 2f 80 	movl   $0x802fd5,0x8(%esp)
  80010a:	00 
  80010b:	c7 44 24 04 df 2f 80 	movl   $0x802fdf,0x4(%esp)
  800112:	00 
  800113:	c7 04 24 de 2f 80 00 	movl   $0x802fde,(%esp)
  80011a:	e8 02 20 00 00       	call   802121 <spawnl>
  80011f:	85 c0                	test   %eax,%eax
  800121:	79 20                	jns    800143 <umain+0x10f>
		panic("icode: spawn /init: %e", r);
  800123:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800127:	c7 44 24 08 e4 2f 80 	movl   $0x802fe4,0x8(%esp)
  80012e:	00 
  80012f:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  800136:	00 
  800137:	c7 04 24 84 2f 80 00 	movl   $0x802f84,(%esp)
  80013e:	e8 85 00 00 00       	call   8001c8 <_panic>

	cprintf("icode: exiting\n");
  800143:	c7 04 24 fb 2f 80 00 	movl   $0x802ffb,(%esp)
  80014a:	e8 3e 01 00 00       	call   80028d <cprintf>
}
  80014f:	81 c4 30 02 00 00    	add    $0x230,%esp
  800155:	5b                   	pop    %ebx
  800156:	5e                   	pop    %esi
  800157:	5d                   	pop    %ebp
  800158:	c3                   	ret    
  800159:	00 00                	add    %al,(%eax)
	...

0080015c <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	83 ec 18             	sub    $0x18,%esp
  800162:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800165:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800168:	8b 75 08             	mov    0x8(%ebp),%esi
  80016b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  80016e:	e8 e6 0f 00 00       	call   801159 <sys_getenvid>
  800173:	25 ff 03 00 00       	and    $0x3ff,%eax
  800178:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80017b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800180:	a3 74 70 80 00       	mov    %eax,0x807074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800185:	85 f6                	test   %esi,%esi
  800187:	7e 07                	jle    800190 <libmain+0x34>
		binaryname = argv[0];
  800189:	8b 03                	mov    (%ebx),%eax
  80018b:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  800190:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800194:	89 34 24             	mov    %esi,(%esp)
  800197:	e8 98 fe ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80019c:	e8 0b 00 00 00       	call   8001ac <exit>
}
  8001a1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8001a4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8001a7:	89 ec                	mov    %ebp,%esp
  8001a9:	5d                   	pop    %ebp
  8001aa:	c3                   	ret    
	...

008001ac <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001ac:	55                   	push   %ebp
  8001ad:	89 e5                	mov    %esp,%ebp
  8001af:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8001b2:	e8 14 15 00 00       	call   8016cb <close_all>
	sys_env_destroy(0);
  8001b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001be:	e8 ca 0f 00 00       	call   80118d <sys_env_destroy>
}
  8001c3:	c9                   	leave  
  8001c4:	c3                   	ret    
  8001c5:	00 00                	add    %al,(%eax)
	...

008001c8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8001c8:	55                   	push   %ebp
  8001c9:	89 e5                	mov    %esp,%ebp
  8001cb:	53                   	push   %ebx
  8001cc:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  8001cf:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  8001d2:	a1 78 70 80 00       	mov    0x807078,%eax
  8001d7:	85 c0                	test   %eax,%eax
  8001d9:	74 10                	je     8001eb <_panic+0x23>
		cprintf("%s: ", argv0);
  8001db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001df:	c7 04 24 22 30 80 00 	movl   $0x803022,(%esp)
  8001e6:	e8 a2 00 00 00       	call   80028d <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8001eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ee:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001f9:	a1 00 70 80 00       	mov    0x807000,%eax
  8001fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800202:	c7 04 24 27 30 80 00 	movl   $0x803027,(%esp)
  800209:	e8 7f 00 00 00       	call   80028d <cprintf>
	vcprintf(fmt, ap);
  80020e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800212:	8b 45 10             	mov    0x10(%ebp),%eax
  800215:	89 04 24             	mov    %eax,(%esp)
  800218:	e8 0f 00 00 00       	call   80022c <vcprintf>
	cprintf("\n");
  80021d:	c7 04 24 25 35 80 00 	movl   $0x803525,(%esp)
  800224:	e8 64 00 00 00       	call   80028d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800229:	cc                   	int3   
  80022a:	eb fd                	jmp    800229 <_panic+0x61>

0080022c <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  80022c:	55                   	push   %ebp
  80022d:	89 e5                	mov    %esp,%ebp
  80022f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800235:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80023c:	00 00 00 
	b.cnt = 0;
  80023f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800246:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800249:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800250:	8b 45 08             	mov    0x8(%ebp),%eax
  800253:	89 44 24 08          	mov    %eax,0x8(%esp)
  800257:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80025d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800261:	c7 04 24 a7 02 80 00 	movl   $0x8002a7,(%esp)
  800268:	e8 d0 01 00 00       	call   80043d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80026d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800273:	89 44 24 04          	mov    %eax,0x4(%esp)
  800277:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80027d:	89 04 24             	mov    %eax,(%esp)
  800280:	e8 db 0a 00 00       	call   800d60 <sys_cputs>

	return b.cnt;
}
  800285:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80028b:	c9                   	leave  
  80028c:	c3                   	ret    

0080028d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80028d:	55                   	push   %ebp
  80028e:	89 e5                	mov    %esp,%ebp
  800290:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800293:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800296:	89 44 24 04          	mov    %eax,0x4(%esp)
  80029a:	8b 45 08             	mov    0x8(%ebp),%eax
  80029d:	89 04 24             	mov    %eax,(%esp)
  8002a0:	e8 87 ff ff ff       	call   80022c <vcprintf>
	va_end(ap);

	return cnt;
}
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	53                   	push   %ebx
  8002ab:	83 ec 14             	sub    $0x14,%esp
  8002ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002b1:	8b 03                	mov    (%ebx),%eax
  8002b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8002ba:	83 c0 01             	add    $0x1,%eax
  8002bd:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8002bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c4:	75 19                	jne    8002df <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8002c6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8002cd:	00 
  8002ce:	8d 43 08             	lea    0x8(%ebx),%eax
  8002d1:	89 04 24             	mov    %eax,(%esp)
  8002d4:	e8 87 0a 00 00       	call   800d60 <sys_cputs>
		b->idx = 0;
  8002d9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8002df:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8002e3:	83 c4 14             	add    $0x14,%esp
  8002e6:	5b                   	pop    %ebx
  8002e7:	5d                   	pop    %ebp
  8002e8:	c3                   	ret    
  8002e9:	00 00                	add    %al,(%eax)
  8002eb:	00 00                	add    %al,(%eax)
  8002ed:	00 00                	add    %al,(%eax)
	...

008002f0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	57                   	push   %edi
  8002f4:	56                   	push   %esi
  8002f5:	53                   	push   %ebx
  8002f6:	83 ec 4c             	sub    $0x4c,%esp
  8002f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002fc:	89 d6                	mov    %edx,%esi
  8002fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800301:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800304:	8b 55 0c             	mov    0xc(%ebp),%edx
  800307:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80030a:	8b 45 10             	mov    0x10(%ebp),%eax
  80030d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800310:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800313:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800316:	b9 00 00 00 00       	mov    $0x0,%ecx
  80031b:	39 d1                	cmp    %edx,%ecx
  80031d:	72 15                	jb     800334 <printnum+0x44>
  80031f:	77 07                	ja     800328 <printnum+0x38>
  800321:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800324:	39 d0                	cmp    %edx,%eax
  800326:	76 0c                	jbe    800334 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800328:	83 eb 01             	sub    $0x1,%ebx
  80032b:	85 db                	test   %ebx,%ebx
  80032d:	8d 76 00             	lea    0x0(%esi),%esi
  800330:	7f 61                	jg     800393 <printnum+0xa3>
  800332:	eb 70                	jmp    8003a4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800334:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800338:	83 eb 01             	sub    $0x1,%ebx
  80033b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80033f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800343:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800347:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80034b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80034e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800351:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800354:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800358:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80035f:	00 
  800360:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800363:	89 04 24             	mov    %eax,(%esp)
  800366:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800369:	89 54 24 04          	mov    %edx,0x4(%esp)
  80036d:	e8 4e 29 00 00       	call   802cc0 <__udivdi3>
  800372:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800375:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800378:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80037c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800380:	89 04 24             	mov    %eax,(%esp)
  800383:	89 54 24 04          	mov    %edx,0x4(%esp)
  800387:	89 f2                	mov    %esi,%edx
  800389:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80038c:	e8 5f ff ff ff       	call   8002f0 <printnum>
  800391:	eb 11                	jmp    8003a4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800393:	89 74 24 04          	mov    %esi,0x4(%esp)
  800397:	89 3c 24             	mov    %edi,(%esp)
  80039a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80039d:	83 eb 01             	sub    $0x1,%ebx
  8003a0:	85 db                	test   %ebx,%ebx
  8003a2:	7f ef                	jg     800393 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003a4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003a8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8003ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8003ba:	00 
  8003bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003be:	89 14 24             	mov    %edx,(%esp)
  8003c1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003c4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8003c8:	e8 23 2a 00 00       	call   802df0 <__umoddi3>
  8003cd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003d1:	0f be 80 43 30 80 00 	movsbl 0x803043(%eax),%eax
  8003d8:	89 04 24             	mov    %eax,(%esp)
  8003db:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8003de:	83 c4 4c             	add    $0x4c,%esp
  8003e1:	5b                   	pop    %ebx
  8003e2:	5e                   	pop    %esi
  8003e3:	5f                   	pop    %edi
  8003e4:	5d                   	pop    %ebp
  8003e5:	c3                   	ret    

008003e6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8003e6:	55                   	push   %ebp
  8003e7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8003e9:	83 fa 01             	cmp    $0x1,%edx
  8003ec:	7e 0e                	jle    8003fc <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8003ee:	8b 10                	mov    (%eax),%edx
  8003f0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8003f3:	89 08                	mov    %ecx,(%eax)
  8003f5:	8b 02                	mov    (%edx),%eax
  8003f7:	8b 52 04             	mov    0x4(%edx),%edx
  8003fa:	eb 22                	jmp    80041e <getuint+0x38>
	else if (lflag)
  8003fc:	85 d2                	test   %edx,%edx
  8003fe:	74 10                	je     800410 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800400:	8b 10                	mov    (%eax),%edx
  800402:	8d 4a 04             	lea    0x4(%edx),%ecx
  800405:	89 08                	mov    %ecx,(%eax)
  800407:	8b 02                	mov    (%edx),%eax
  800409:	ba 00 00 00 00       	mov    $0x0,%edx
  80040e:	eb 0e                	jmp    80041e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800410:	8b 10                	mov    (%eax),%edx
  800412:	8d 4a 04             	lea    0x4(%edx),%ecx
  800415:	89 08                	mov    %ecx,(%eax)
  800417:	8b 02                	mov    (%edx),%eax
  800419:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80041e:	5d                   	pop    %ebp
  80041f:	c3                   	ret    

00800420 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800420:	55                   	push   %ebp
  800421:	89 e5                	mov    %esp,%ebp
  800423:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800426:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80042a:	8b 10                	mov    (%eax),%edx
  80042c:	3b 50 04             	cmp    0x4(%eax),%edx
  80042f:	73 0a                	jae    80043b <sprintputch+0x1b>
		*b->buf++ = ch;
  800431:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800434:	88 0a                	mov    %cl,(%edx)
  800436:	83 c2 01             	add    $0x1,%edx
  800439:	89 10                	mov    %edx,(%eax)
}
  80043b:	5d                   	pop    %ebp
  80043c:	c3                   	ret    

0080043d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80043d:	55                   	push   %ebp
  80043e:	89 e5                	mov    %esp,%ebp
  800440:	57                   	push   %edi
  800441:	56                   	push   %esi
  800442:	53                   	push   %ebx
  800443:	83 ec 5c             	sub    $0x5c,%esp
  800446:	8b 7d 08             	mov    0x8(%ebp),%edi
  800449:	8b 75 0c             	mov    0xc(%ebp),%esi
  80044c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80044f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800456:	eb 11                	jmp    800469 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800458:	85 c0                	test   %eax,%eax
  80045a:	0f 84 09 04 00 00    	je     800869 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  800460:	89 74 24 04          	mov    %esi,0x4(%esp)
  800464:	89 04 24             	mov    %eax,(%esp)
  800467:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800469:	0f b6 03             	movzbl (%ebx),%eax
  80046c:	83 c3 01             	add    $0x1,%ebx
  80046f:	83 f8 25             	cmp    $0x25,%eax
  800472:	75 e4                	jne    800458 <vprintfmt+0x1b>
  800474:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800478:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80047f:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800486:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80048d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800492:	eb 06                	jmp    80049a <vprintfmt+0x5d>
  800494:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800498:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	0f b6 13             	movzbl (%ebx),%edx
  80049d:	0f b6 c2             	movzbl %dl,%eax
  8004a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004a3:	8d 43 01             	lea    0x1(%ebx),%eax
  8004a6:	83 ea 23             	sub    $0x23,%edx
  8004a9:	80 fa 55             	cmp    $0x55,%dl
  8004ac:	0f 87 9a 03 00 00    	ja     80084c <vprintfmt+0x40f>
  8004b2:	0f b6 d2             	movzbl %dl,%edx
  8004b5:	ff 24 95 80 31 80 00 	jmp    *0x803180(,%edx,4)
  8004bc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8004c0:	eb d6                	jmp    800498 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8004c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c5:	83 ea 30             	sub    $0x30,%edx
  8004c8:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  8004cb:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8004ce:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8004d1:	83 fb 09             	cmp    $0x9,%ebx
  8004d4:	77 4c                	ja     800522 <vprintfmt+0xe5>
  8004d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004d9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8004dc:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8004df:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8004e2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8004e6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8004e9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8004ec:	83 fb 09             	cmp    $0x9,%ebx
  8004ef:	76 eb                	jbe    8004dc <vprintfmt+0x9f>
  8004f1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8004f4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004f7:	eb 29                	jmp    800522 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8004f9:	8b 55 14             	mov    0x14(%ebp),%edx
  8004fc:	8d 5a 04             	lea    0x4(%edx),%ebx
  8004ff:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800502:	8b 12                	mov    (%edx),%edx
  800504:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  800507:	eb 19                	jmp    800522 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800509:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80050c:	c1 fa 1f             	sar    $0x1f,%edx
  80050f:	f7 d2                	not    %edx
  800511:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800514:	eb 82                	jmp    800498 <vprintfmt+0x5b>
  800516:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80051d:	e9 76 ff ff ff       	jmp    800498 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800522:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800526:	0f 89 6c ff ff ff    	jns    800498 <vprintfmt+0x5b>
  80052c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80052f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800532:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800535:	89 55 cc             	mov    %edx,-0x34(%ebp)
  800538:	e9 5b ff ff ff       	jmp    800498 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80053d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800540:	e9 53 ff ff ff       	jmp    800498 <vprintfmt+0x5b>
  800545:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800548:	8b 45 14             	mov    0x14(%ebp),%eax
  80054b:	8d 50 04             	lea    0x4(%eax),%edx
  80054e:	89 55 14             	mov    %edx,0x14(%ebp)
  800551:	89 74 24 04          	mov    %esi,0x4(%esp)
  800555:	8b 00                	mov    (%eax),%eax
  800557:	89 04 24             	mov    %eax,(%esp)
  80055a:	ff d7                	call   *%edi
  80055c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80055f:	e9 05 ff ff ff       	jmp    800469 <vprintfmt+0x2c>
  800564:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800567:	8b 45 14             	mov    0x14(%ebp),%eax
  80056a:	8d 50 04             	lea    0x4(%eax),%edx
  80056d:	89 55 14             	mov    %edx,0x14(%ebp)
  800570:	8b 00                	mov    (%eax),%eax
  800572:	89 c2                	mov    %eax,%edx
  800574:	c1 fa 1f             	sar    $0x1f,%edx
  800577:	31 d0                	xor    %edx,%eax
  800579:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80057b:	83 f8 0f             	cmp    $0xf,%eax
  80057e:	7f 0b                	jg     80058b <vprintfmt+0x14e>
  800580:	8b 14 85 e0 32 80 00 	mov    0x8032e0(,%eax,4),%edx
  800587:	85 d2                	test   %edx,%edx
  800589:	75 20                	jne    8005ab <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80058b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80058f:	c7 44 24 08 54 30 80 	movl   $0x803054,0x8(%esp)
  800596:	00 
  800597:	89 74 24 04          	mov    %esi,0x4(%esp)
  80059b:	89 3c 24             	mov    %edi,(%esp)
  80059e:	e8 4e 03 00 00       	call   8008f1 <printfmt>
  8005a3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8005a6:	e9 be fe ff ff       	jmp    800469 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8005ab:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8005af:	c7 44 24 08 3b 34 80 	movl   $0x80343b,0x8(%esp)
  8005b6:	00 
  8005b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005bb:	89 3c 24             	mov    %edi,(%esp)
  8005be:	e8 2e 03 00 00       	call   8008f1 <printfmt>
  8005c3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8005c6:	e9 9e fe ff ff       	jmp    800469 <vprintfmt+0x2c>
  8005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005ce:	89 c3                	mov    %eax,%ebx
  8005d0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8005d3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005d6:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	8d 50 04             	lea    0x4(%eax),%edx
  8005df:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e2:	8b 00                	mov    (%eax),%eax
  8005e4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8005e7:	85 c0                	test   %eax,%eax
  8005e9:	75 07                	jne    8005f2 <vprintfmt+0x1b5>
  8005eb:	c7 45 c4 5d 30 80 00 	movl   $0x80305d,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  8005f2:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8005f6:	7e 06                	jle    8005fe <vprintfmt+0x1c1>
  8005f8:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  8005fc:	75 13                	jne    800611 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8005fe:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800601:	0f be 02             	movsbl (%edx),%eax
  800604:	85 c0                	test   %eax,%eax
  800606:	0f 85 99 00 00 00    	jne    8006a5 <vprintfmt+0x268>
  80060c:	e9 86 00 00 00       	jmp    800697 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800611:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800615:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800618:	89 0c 24             	mov    %ecx,(%esp)
  80061b:	e8 1b 03 00 00       	call   80093b <strnlen>
  800620:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800623:	29 c2                	sub    %eax,%edx
  800625:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800628:	85 d2                	test   %edx,%edx
  80062a:	7e d2                	jle    8005fe <vprintfmt+0x1c1>
					putch(padc, putdat);
  80062c:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  800630:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800633:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  800636:	89 d3                	mov    %edx,%ebx
  800638:	89 74 24 04          	mov    %esi,0x4(%esp)
  80063c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80063f:	89 04 24             	mov    %eax,(%esp)
  800642:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800644:	83 eb 01             	sub    $0x1,%ebx
  800647:	85 db                	test   %ebx,%ebx
  800649:	7f ed                	jg     800638 <vprintfmt+0x1fb>
  80064b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80064e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800655:	eb a7                	jmp    8005fe <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800657:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80065b:	74 18                	je     800675 <vprintfmt+0x238>
  80065d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800660:	83 fa 5e             	cmp    $0x5e,%edx
  800663:	76 10                	jbe    800675 <vprintfmt+0x238>
					putch('?', putdat);
  800665:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800669:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800670:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800673:	eb 0a                	jmp    80067f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800675:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800679:	89 04 24             	mov    %eax,(%esp)
  80067c:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80067f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800683:	0f be 03             	movsbl (%ebx),%eax
  800686:	85 c0                	test   %eax,%eax
  800688:	74 05                	je     80068f <vprintfmt+0x252>
  80068a:	83 c3 01             	add    $0x1,%ebx
  80068d:	eb 29                	jmp    8006b8 <vprintfmt+0x27b>
  80068f:	89 fe                	mov    %edi,%esi
  800691:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800694:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800697:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80069b:	7f 2e                	jg     8006cb <vprintfmt+0x28e>
  80069d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8006a0:	e9 c4 fd ff ff       	jmp    800469 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8006a5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8006a8:	83 c2 01             	add    $0x1,%edx
  8006ab:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8006ae:	89 f7                	mov    %esi,%edi
  8006b0:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8006b3:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  8006b6:	89 d3                	mov    %edx,%ebx
  8006b8:	85 f6                	test   %esi,%esi
  8006ba:	78 9b                	js     800657 <vprintfmt+0x21a>
  8006bc:	83 ee 01             	sub    $0x1,%esi
  8006bf:	79 96                	jns    800657 <vprintfmt+0x21a>
  8006c1:	89 fe                	mov    %edi,%esi
  8006c3:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8006c6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8006c9:	eb cc                	jmp    800697 <vprintfmt+0x25a>
  8006cb:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8006ce:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8006d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006d5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8006dc:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8006de:	83 eb 01             	sub    $0x1,%ebx
  8006e1:	85 db                	test   %ebx,%ebx
  8006e3:	7f ec                	jg     8006d1 <vprintfmt+0x294>
  8006e5:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8006e8:	e9 7c fd ff ff       	jmp    800469 <vprintfmt+0x2c>
  8006ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8006f0:	83 f9 01             	cmp    $0x1,%ecx
  8006f3:	7e 16                	jle    80070b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  8006f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f8:	8d 50 08             	lea    0x8(%eax),%edx
  8006fb:	89 55 14             	mov    %edx,0x14(%ebp)
  8006fe:	8b 10                	mov    (%eax),%edx
  800700:	8b 48 04             	mov    0x4(%eax),%ecx
  800703:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800706:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800709:	eb 32                	jmp    80073d <vprintfmt+0x300>
	else if (lflag)
  80070b:	85 c9                	test   %ecx,%ecx
  80070d:	74 18                	je     800727 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80070f:	8b 45 14             	mov    0x14(%ebp),%eax
  800712:	8d 50 04             	lea    0x4(%eax),%edx
  800715:	89 55 14             	mov    %edx,0x14(%ebp)
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80071d:	89 c1                	mov    %eax,%ecx
  80071f:	c1 f9 1f             	sar    $0x1f,%ecx
  800722:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800725:	eb 16                	jmp    80073d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8d 50 04             	lea    0x4(%eax),%edx
  80072d:	89 55 14             	mov    %edx,0x14(%ebp)
  800730:	8b 00                	mov    (%eax),%eax
  800732:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800735:	89 c2                	mov    %eax,%edx
  800737:	c1 fa 1f             	sar    $0x1f,%edx
  80073a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80073d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800740:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800743:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800748:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80074c:	0f 89 b8 00 00 00    	jns    80080a <vprintfmt+0x3cd>
				putch('-', putdat);
  800752:	89 74 24 04          	mov    %esi,0x4(%esp)
  800756:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80075d:	ff d7                	call   *%edi
				num = -(long long) num;
  80075f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800762:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800765:	f7 d9                	neg    %ecx
  800767:	83 d3 00             	adc    $0x0,%ebx
  80076a:	f7 db                	neg    %ebx
  80076c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800771:	e9 94 00 00 00       	jmp    80080a <vprintfmt+0x3cd>
  800776:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800779:	89 ca                	mov    %ecx,%edx
  80077b:	8d 45 14             	lea    0x14(%ebp),%eax
  80077e:	e8 63 fc ff ff       	call   8003e6 <getuint>
  800783:	89 c1                	mov    %eax,%ecx
  800785:	89 d3                	mov    %edx,%ebx
  800787:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80078c:	eb 7c                	jmp    80080a <vprintfmt+0x3cd>
  80078e:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800791:	89 74 24 04          	mov    %esi,0x4(%esp)
  800795:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  80079c:	ff d7                	call   *%edi
			putch('X', putdat);
  80079e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007a2:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8007a9:	ff d7                	call   *%edi
			putch('X', putdat);
  8007ab:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007af:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8007b6:	ff d7                	call   *%edi
  8007b8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8007bb:	e9 a9 fc ff ff       	jmp    800469 <vprintfmt+0x2c>
  8007c0:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8007c3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007c7:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8007ce:	ff d7                	call   *%edi
			putch('x', putdat);
  8007d0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007d4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8007db:	ff d7                	call   *%edi
			num = (unsigned long long)
  8007dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007e0:	8d 50 04             	lea    0x4(%eax),%edx
  8007e3:	89 55 14             	mov    %edx,0x14(%ebp)
  8007e6:	8b 08                	mov    (%eax),%ecx
  8007e8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007ed:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8007f2:	eb 16                	jmp    80080a <vprintfmt+0x3cd>
  8007f4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8007f7:	89 ca                	mov    %ecx,%edx
  8007f9:	8d 45 14             	lea    0x14(%ebp),%eax
  8007fc:	e8 e5 fb ff ff       	call   8003e6 <getuint>
  800801:	89 c1                	mov    %eax,%ecx
  800803:	89 d3                	mov    %edx,%ebx
  800805:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80080a:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  80080e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800812:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800815:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800819:	89 44 24 08          	mov    %eax,0x8(%esp)
  80081d:	89 0c 24             	mov    %ecx,(%esp)
  800820:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800824:	89 f2                	mov    %esi,%edx
  800826:	89 f8                	mov    %edi,%eax
  800828:	e8 c3 fa ff ff       	call   8002f0 <printnum>
  80082d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800830:	e9 34 fc ff ff       	jmp    800469 <vprintfmt+0x2c>
  800835:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800838:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80083b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80083f:	89 14 24             	mov    %edx,(%esp)
  800842:	ff d7                	call   *%edi
  800844:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800847:	e9 1d fc ff ff       	jmp    800469 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80084c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800850:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800857:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800859:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80085c:	80 38 25             	cmpb   $0x25,(%eax)
  80085f:	0f 84 04 fc ff ff    	je     800469 <vprintfmt+0x2c>
  800865:	89 c3                	mov    %eax,%ebx
  800867:	eb f0                	jmp    800859 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  800869:	83 c4 5c             	add    $0x5c,%esp
  80086c:	5b                   	pop    %ebx
  80086d:	5e                   	pop    %esi
  80086e:	5f                   	pop    %edi
  80086f:	5d                   	pop    %ebp
  800870:	c3                   	ret    

00800871 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800871:	55                   	push   %ebp
  800872:	89 e5                	mov    %esp,%ebp
  800874:	83 ec 28             	sub    $0x28,%esp
  800877:	8b 45 08             	mov    0x8(%ebp),%eax
  80087a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  80087d:	85 c0                	test   %eax,%eax
  80087f:	74 04                	je     800885 <vsnprintf+0x14>
  800881:	85 d2                	test   %edx,%edx
  800883:	7f 07                	jg     80088c <vsnprintf+0x1b>
  800885:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80088a:	eb 3b                	jmp    8008c7 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80088c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80088f:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800893:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800896:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80089d:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008ab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b2:	c7 04 24 20 04 80 00 	movl   $0x800420,(%esp)
  8008b9:	e8 7f fb ff ff       	call   80043d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8008c7:	c9                   	leave  
  8008c8:	c3                   	ret    

008008c9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8008cf:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8008d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8008d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	89 04 24             	mov    %eax,(%esp)
  8008ea:	e8 82 ff ff ff       	call   800871 <vsnprintf>
	va_end(ap);

	return rc;
}
  8008ef:	c9                   	leave  
  8008f0:	c3                   	ret    

008008f1 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8008f7:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8008fa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8008fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800901:	89 44 24 08          	mov    %eax,0x8(%esp)
  800905:	8b 45 0c             	mov    0xc(%ebp),%eax
  800908:	89 44 24 04          	mov    %eax,0x4(%esp)
  80090c:	8b 45 08             	mov    0x8(%ebp),%eax
  80090f:	89 04 24             	mov    %eax,(%esp)
  800912:	e8 26 fb ff ff       	call   80043d <vprintfmt>
	va_end(ap);
}
  800917:	c9                   	leave  
  800918:	c3                   	ret    
  800919:	00 00                	add    %al,(%eax)
  80091b:	00 00                	add    %al,(%eax)
  80091d:	00 00                	add    %al,(%eax)
	...

00800920 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800920:	55                   	push   %ebp
  800921:	89 e5                	mov    %esp,%ebp
  800923:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800926:	b8 00 00 00 00       	mov    $0x0,%eax
  80092b:	80 3a 00             	cmpb   $0x0,(%edx)
  80092e:	74 09                	je     800939 <strlen+0x19>
		n++;
  800930:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800933:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800937:	75 f7                	jne    800930 <strlen+0x10>
		n++;
	return n;
}
  800939:	5d                   	pop    %ebp
  80093a:	c3                   	ret    

0080093b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
  80093e:	53                   	push   %ebx
  80093f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800942:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800945:	85 c9                	test   %ecx,%ecx
  800947:	74 19                	je     800962 <strnlen+0x27>
  800949:	80 3b 00             	cmpb   $0x0,(%ebx)
  80094c:	74 14                	je     800962 <strnlen+0x27>
  80094e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800953:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800956:	39 c8                	cmp    %ecx,%eax
  800958:	74 0d                	je     800967 <strnlen+0x2c>
  80095a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80095e:	75 f3                	jne    800953 <strnlen+0x18>
  800960:	eb 05                	jmp    800967 <strnlen+0x2c>
  800962:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800967:	5b                   	pop    %ebx
  800968:	5d                   	pop    %ebp
  800969:	c3                   	ret    

0080096a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80096a:	55                   	push   %ebp
  80096b:	89 e5                	mov    %esp,%ebp
  80096d:	53                   	push   %ebx
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800974:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800979:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80097d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800980:	83 c2 01             	add    $0x1,%edx
  800983:	84 c9                	test   %cl,%cl
  800985:	75 f2                	jne    800979 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800987:	5b                   	pop    %ebx
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	56                   	push   %esi
  80098e:	53                   	push   %ebx
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	8b 55 0c             	mov    0xc(%ebp),%edx
  800995:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800998:	85 f6                	test   %esi,%esi
  80099a:	74 18                	je     8009b4 <strncpy+0x2a>
  80099c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8009a1:	0f b6 1a             	movzbl (%edx),%ebx
  8009a4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009a7:	80 3a 01             	cmpb   $0x1,(%edx)
  8009aa:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009ad:	83 c1 01             	add    $0x1,%ecx
  8009b0:	39 ce                	cmp    %ecx,%esi
  8009b2:	77 ed                	ja     8009a1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8009b4:	5b                   	pop    %ebx
  8009b5:	5e                   	pop    %esi
  8009b6:	5d                   	pop    %ebp
  8009b7:	c3                   	ret    

008009b8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	56                   	push   %esi
  8009bc:	53                   	push   %ebx
  8009bd:	8b 75 08             	mov    0x8(%ebp),%esi
  8009c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009c6:	89 f0                	mov    %esi,%eax
  8009c8:	85 c9                	test   %ecx,%ecx
  8009ca:	74 27                	je     8009f3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  8009cc:	83 e9 01             	sub    $0x1,%ecx
  8009cf:	74 1d                	je     8009ee <strlcpy+0x36>
  8009d1:	0f b6 1a             	movzbl (%edx),%ebx
  8009d4:	84 db                	test   %bl,%bl
  8009d6:	74 16                	je     8009ee <strlcpy+0x36>
			*dst++ = *src++;
  8009d8:	88 18                	mov    %bl,(%eax)
  8009da:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009dd:	83 e9 01             	sub    $0x1,%ecx
  8009e0:	74 0e                	je     8009f0 <strlcpy+0x38>
			*dst++ = *src++;
  8009e2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8009e5:	0f b6 1a             	movzbl (%edx),%ebx
  8009e8:	84 db                	test   %bl,%bl
  8009ea:	75 ec                	jne    8009d8 <strlcpy+0x20>
  8009ec:	eb 02                	jmp    8009f0 <strlcpy+0x38>
  8009ee:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8009f0:	c6 00 00             	movb   $0x0,(%eax)
  8009f3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8009f5:	5b                   	pop    %ebx
  8009f6:	5e                   	pop    %esi
  8009f7:	5d                   	pop    %ebp
  8009f8:	c3                   	ret    

008009f9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009f9:	55                   	push   %ebp
  8009fa:	89 e5                	mov    %esp,%ebp
  8009fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009ff:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a02:	0f b6 01             	movzbl (%ecx),%eax
  800a05:	84 c0                	test   %al,%al
  800a07:	74 15                	je     800a1e <strcmp+0x25>
  800a09:	3a 02                	cmp    (%edx),%al
  800a0b:	75 11                	jne    800a1e <strcmp+0x25>
		p++, q++;
  800a0d:	83 c1 01             	add    $0x1,%ecx
  800a10:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800a13:	0f b6 01             	movzbl (%ecx),%eax
  800a16:	84 c0                	test   %al,%al
  800a18:	74 04                	je     800a1e <strcmp+0x25>
  800a1a:	3a 02                	cmp    (%edx),%al
  800a1c:	74 ef                	je     800a0d <strcmp+0x14>
  800a1e:	0f b6 c0             	movzbl %al,%eax
  800a21:	0f b6 12             	movzbl (%edx),%edx
  800a24:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a26:	5d                   	pop    %ebp
  800a27:	c3                   	ret    

00800a28 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a28:	55                   	push   %ebp
  800a29:	89 e5                	mov    %esp,%ebp
  800a2b:	53                   	push   %ebx
  800a2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800a2f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a32:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800a35:	85 c0                	test   %eax,%eax
  800a37:	74 23                	je     800a5c <strncmp+0x34>
  800a39:	0f b6 1a             	movzbl (%edx),%ebx
  800a3c:	84 db                	test   %bl,%bl
  800a3e:	74 24                	je     800a64 <strncmp+0x3c>
  800a40:	3a 19                	cmp    (%ecx),%bl
  800a42:	75 20                	jne    800a64 <strncmp+0x3c>
  800a44:	83 e8 01             	sub    $0x1,%eax
  800a47:	74 13                	je     800a5c <strncmp+0x34>
		n--, p++, q++;
  800a49:	83 c2 01             	add    $0x1,%edx
  800a4c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800a4f:	0f b6 1a             	movzbl (%edx),%ebx
  800a52:	84 db                	test   %bl,%bl
  800a54:	74 0e                	je     800a64 <strncmp+0x3c>
  800a56:	3a 19                	cmp    (%ecx),%bl
  800a58:	74 ea                	je     800a44 <strncmp+0x1c>
  800a5a:	eb 08                	jmp    800a64 <strncmp+0x3c>
  800a5c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800a61:	5b                   	pop    %ebx
  800a62:	5d                   	pop    %ebp
  800a63:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a64:	0f b6 02             	movzbl (%edx),%eax
  800a67:	0f b6 11             	movzbl (%ecx),%edx
  800a6a:	29 d0                	sub    %edx,%eax
  800a6c:	eb f3                	jmp    800a61 <strncmp+0x39>

00800a6e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	8b 45 08             	mov    0x8(%ebp),%eax
  800a74:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800a78:	0f b6 10             	movzbl (%eax),%edx
  800a7b:	84 d2                	test   %dl,%dl
  800a7d:	74 15                	je     800a94 <strchr+0x26>
		if (*s == c)
  800a7f:	38 ca                	cmp    %cl,%dl
  800a81:	75 07                	jne    800a8a <strchr+0x1c>
  800a83:	eb 14                	jmp    800a99 <strchr+0x2b>
  800a85:	38 ca                	cmp    %cl,%dl
  800a87:	90                   	nop
  800a88:	74 0f                	je     800a99 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800a8a:	83 c0 01             	add    $0x1,%eax
  800a8d:	0f b6 10             	movzbl (%eax),%edx
  800a90:	84 d2                	test   %dl,%dl
  800a92:	75 f1                	jne    800a85 <strchr+0x17>
  800a94:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800a99:	5d                   	pop    %ebp
  800a9a:	c3                   	ret    

00800a9b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a9b:	55                   	push   %ebp
  800a9c:	89 e5                	mov    %esp,%ebp
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800aa5:	0f b6 10             	movzbl (%eax),%edx
  800aa8:	84 d2                	test   %dl,%dl
  800aaa:	74 18                	je     800ac4 <strfind+0x29>
		if (*s == c)
  800aac:	38 ca                	cmp    %cl,%dl
  800aae:	75 0a                	jne    800aba <strfind+0x1f>
  800ab0:	eb 12                	jmp    800ac4 <strfind+0x29>
  800ab2:	38 ca                	cmp    %cl,%dl
  800ab4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ab8:	74 0a                	je     800ac4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800aba:	83 c0 01             	add    $0x1,%eax
  800abd:	0f b6 10             	movzbl (%eax),%edx
  800ac0:	84 d2                	test   %dl,%dl
  800ac2:	75 ee                	jne    800ab2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800ac4:	5d                   	pop    %ebp
  800ac5:	c3                   	ret    

00800ac6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ac6:	55                   	push   %ebp
  800ac7:	89 e5                	mov    %esp,%ebp
  800ac9:	83 ec 0c             	sub    $0xc,%esp
  800acc:	89 1c 24             	mov    %ebx,(%esp)
  800acf:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ad3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800ad7:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ada:	8b 45 0c             	mov    0xc(%ebp),%eax
  800add:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ae0:	85 c9                	test   %ecx,%ecx
  800ae2:	74 30                	je     800b14 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ae4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800aea:	75 25                	jne    800b11 <memset+0x4b>
  800aec:	f6 c1 03             	test   $0x3,%cl
  800aef:	75 20                	jne    800b11 <memset+0x4b>
		c &= 0xFF;
  800af1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800af4:	89 d3                	mov    %edx,%ebx
  800af6:	c1 e3 08             	shl    $0x8,%ebx
  800af9:	89 d6                	mov    %edx,%esi
  800afb:	c1 e6 18             	shl    $0x18,%esi
  800afe:	89 d0                	mov    %edx,%eax
  800b00:	c1 e0 10             	shl    $0x10,%eax
  800b03:	09 f0                	or     %esi,%eax
  800b05:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800b07:	09 d8                	or     %ebx,%eax
  800b09:	c1 e9 02             	shr    $0x2,%ecx
  800b0c:	fc                   	cld    
  800b0d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800b0f:	eb 03                	jmp    800b14 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800b11:	fc                   	cld    
  800b12:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800b14:	89 f8                	mov    %edi,%eax
  800b16:	8b 1c 24             	mov    (%esp),%ebx
  800b19:	8b 74 24 04          	mov    0x4(%esp),%esi
  800b1d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800b21:	89 ec                	mov    %ebp,%esp
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	89 34 24             	mov    %esi,(%esp)
  800b2e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800b38:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800b3b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800b3d:	39 c6                	cmp    %eax,%esi
  800b3f:	73 35                	jae    800b76 <memmove+0x51>
  800b41:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b44:	39 d0                	cmp    %edx,%eax
  800b46:	73 2e                	jae    800b76 <memmove+0x51>
		s += n;
		d += n;
  800b48:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b4a:	f6 c2 03             	test   $0x3,%dl
  800b4d:	75 1b                	jne    800b6a <memmove+0x45>
  800b4f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b55:	75 13                	jne    800b6a <memmove+0x45>
  800b57:	f6 c1 03             	test   $0x3,%cl
  800b5a:	75 0e                	jne    800b6a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800b5c:	83 ef 04             	sub    $0x4,%edi
  800b5f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b62:	c1 e9 02             	shr    $0x2,%ecx
  800b65:	fd                   	std    
  800b66:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b68:	eb 09                	jmp    800b73 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800b6a:	83 ef 01             	sub    $0x1,%edi
  800b6d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800b70:	fd                   	std    
  800b71:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b73:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b74:	eb 20                	jmp    800b96 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b76:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b7c:	75 15                	jne    800b93 <memmove+0x6e>
  800b7e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800b84:	75 0d                	jne    800b93 <memmove+0x6e>
  800b86:	f6 c1 03             	test   $0x3,%cl
  800b89:	75 08                	jne    800b93 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800b8b:	c1 e9 02             	shr    $0x2,%ecx
  800b8e:	fc                   	cld    
  800b8f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b91:	eb 03                	jmp    800b96 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b93:	fc                   	cld    
  800b94:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b96:	8b 34 24             	mov    (%esp),%esi
  800b99:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800b9d:	89 ec                	mov    %ebp,%esp
  800b9f:	5d                   	pop    %ebp
  800ba0:	c3                   	ret    

00800ba1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800ba1:	55                   	push   %ebp
  800ba2:	89 e5                	mov    %esp,%ebp
  800ba4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800ba7:	8b 45 10             	mov    0x10(%ebp),%eax
  800baa:	89 44 24 08          	mov    %eax,0x8(%esp)
  800bae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	89 04 24             	mov    %eax,(%esp)
  800bbb:	e8 65 ff ff ff       	call   800b25 <memmove>
}
  800bc0:	c9                   	leave  
  800bc1:	c3                   	ret    

00800bc2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800bc2:	55                   	push   %ebp
  800bc3:	89 e5                	mov    %esp,%ebp
  800bc5:	57                   	push   %edi
  800bc6:	56                   	push   %esi
  800bc7:	53                   	push   %ebx
  800bc8:	8b 75 08             	mov    0x8(%ebp),%esi
  800bcb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800bce:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bd1:	85 c9                	test   %ecx,%ecx
  800bd3:	74 36                	je     800c0b <memcmp+0x49>
		if (*s1 != *s2)
  800bd5:	0f b6 06             	movzbl (%esi),%eax
  800bd8:	0f b6 1f             	movzbl (%edi),%ebx
  800bdb:	38 d8                	cmp    %bl,%al
  800bdd:	74 20                	je     800bff <memcmp+0x3d>
  800bdf:	eb 14                	jmp    800bf5 <memcmp+0x33>
  800be1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800be6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800beb:	83 c2 01             	add    $0x1,%edx
  800bee:	83 e9 01             	sub    $0x1,%ecx
  800bf1:	38 d8                	cmp    %bl,%al
  800bf3:	74 12                	je     800c07 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800bf5:	0f b6 c0             	movzbl %al,%eax
  800bf8:	0f b6 db             	movzbl %bl,%ebx
  800bfb:	29 d8                	sub    %ebx,%eax
  800bfd:	eb 11                	jmp    800c10 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800bff:	83 e9 01             	sub    $0x1,%ecx
  800c02:	ba 00 00 00 00       	mov    $0x0,%edx
  800c07:	85 c9                	test   %ecx,%ecx
  800c09:	75 d6                	jne    800be1 <memcmp+0x1f>
  800c0b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800c10:	5b                   	pop    %ebx
  800c11:	5e                   	pop    %esi
  800c12:	5f                   	pop    %edi
  800c13:	5d                   	pop    %ebp
  800c14:	c3                   	ret    

00800c15 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800c1b:	89 c2                	mov    %eax,%edx
  800c1d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800c20:	39 d0                	cmp    %edx,%eax
  800c22:	73 15                	jae    800c39 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800c24:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800c28:	38 08                	cmp    %cl,(%eax)
  800c2a:	75 06                	jne    800c32 <memfind+0x1d>
  800c2c:	eb 0b                	jmp    800c39 <memfind+0x24>
  800c2e:	38 08                	cmp    %cl,(%eax)
  800c30:	74 07                	je     800c39 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800c32:	83 c0 01             	add    $0x1,%eax
  800c35:	39 c2                	cmp    %eax,%edx
  800c37:	77 f5                	ja     800c2e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800c39:	5d                   	pop    %ebp
  800c3a:	c3                   	ret    

00800c3b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	57                   	push   %edi
  800c3f:	56                   	push   %esi
  800c40:	53                   	push   %ebx
  800c41:	83 ec 04             	sub    $0x4,%esp
  800c44:	8b 55 08             	mov    0x8(%ebp),%edx
  800c47:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c4a:	0f b6 02             	movzbl (%edx),%eax
  800c4d:	3c 20                	cmp    $0x20,%al
  800c4f:	74 04                	je     800c55 <strtol+0x1a>
  800c51:	3c 09                	cmp    $0x9,%al
  800c53:	75 0e                	jne    800c63 <strtol+0x28>
		s++;
  800c55:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800c58:	0f b6 02             	movzbl (%edx),%eax
  800c5b:	3c 20                	cmp    $0x20,%al
  800c5d:	74 f6                	je     800c55 <strtol+0x1a>
  800c5f:	3c 09                	cmp    $0x9,%al
  800c61:	74 f2                	je     800c55 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800c63:	3c 2b                	cmp    $0x2b,%al
  800c65:	75 0c                	jne    800c73 <strtol+0x38>
		s++;
  800c67:	83 c2 01             	add    $0x1,%edx
  800c6a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c71:	eb 15                	jmp    800c88 <strtol+0x4d>
	else if (*s == '-')
  800c73:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800c7a:	3c 2d                	cmp    $0x2d,%al
  800c7c:	75 0a                	jne    800c88 <strtol+0x4d>
		s++, neg = 1;
  800c7e:	83 c2 01             	add    $0x1,%edx
  800c81:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c88:	85 db                	test   %ebx,%ebx
  800c8a:	0f 94 c0             	sete   %al
  800c8d:	74 05                	je     800c94 <strtol+0x59>
  800c8f:	83 fb 10             	cmp    $0x10,%ebx
  800c92:	75 18                	jne    800cac <strtol+0x71>
  800c94:	80 3a 30             	cmpb   $0x30,(%edx)
  800c97:	75 13                	jne    800cac <strtol+0x71>
  800c99:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800c9d:	8d 76 00             	lea    0x0(%esi),%esi
  800ca0:	75 0a                	jne    800cac <strtol+0x71>
		s += 2, base = 16;
  800ca2:	83 c2 02             	add    $0x2,%edx
  800ca5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800caa:	eb 15                	jmp    800cc1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cac:	84 c0                	test   %al,%al
  800cae:	66 90                	xchg   %ax,%ax
  800cb0:	74 0f                	je     800cc1 <strtol+0x86>
  800cb2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800cb7:	80 3a 30             	cmpb   $0x30,(%edx)
  800cba:	75 05                	jne    800cc1 <strtol+0x86>
		s++, base = 8;
  800cbc:	83 c2 01             	add    $0x1,%edx
  800cbf:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800cc1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cc6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800cc8:	0f b6 0a             	movzbl (%edx),%ecx
  800ccb:	89 cf                	mov    %ecx,%edi
  800ccd:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800cd0:	80 fb 09             	cmp    $0x9,%bl
  800cd3:	77 08                	ja     800cdd <strtol+0xa2>
			dig = *s - '0';
  800cd5:	0f be c9             	movsbl %cl,%ecx
  800cd8:	83 e9 30             	sub    $0x30,%ecx
  800cdb:	eb 1e                	jmp    800cfb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800cdd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800ce0:	80 fb 19             	cmp    $0x19,%bl
  800ce3:	77 08                	ja     800ced <strtol+0xb2>
			dig = *s - 'a' + 10;
  800ce5:	0f be c9             	movsbl %cl,%ecx
  800ce8:	83 e9 57             	sub    $0x57,%ecx
  800ceb:	eb 0e                	jmp    800cfb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800ced:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800cf0:	80 fb 19             	cmp    $0x19,%bl
  800cf3:	77 15                	ja     800d0a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800cf5:	0f be c9             	movsbl %cl,%ecx
  800cf8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800cfb:	39 f1                	cmp    %esi,%ecx
  800cfd:	7d 0b                	jge    800d0a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800cff:	83 c2 01             	add    $0x1,%edx
  800d02:	0f af c6             	imul   %esi,%eax
  800d05:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800d08:	eb be                	jmp    800cc8 <strtol+0x8d>
  800d0a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800d0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d10:	74 05                	je     800d17 <strtol+0xdc>
		*endptr = (char *) s;
  800d12:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800d15:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800d17:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800d1b:	74 04                	je     800d21 <strtol+0xe6>
  800d1d:	89 c8                	mov    %ecx,%eax
  800d1f:	f7 d8                	neg    %eax
}
  800d21:	83 c4 04             	add    $0x4,%esp
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    
  800d29:	00 00                	add    %al,(%eax)
	...

00800d2c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800d2c:	55                   	push   %ebp
  800d2d:	89 e5                	mov    %esp,%ebp
  800d2f:	83 ec 0c             	sub    $0xc,%esp
  800d32:	89 1c 24             	mov    %ebx,(%esp)
  800d35:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d39:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d42:	b8 01 00 00 00       	mov    $0x1,%eax
  800d47:	89 d1                	mov    %edx,%ecx
  800d49:	89 d3                	mov    %edx,%ebx
  800d4b:	89 d7                	mov    %edx,%edi
  800d4d:	89 d6                	mov    %edx,%esi
  800d4f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800d51:	8b 1c 24             	mov    (%esp),%ebx
  800d54:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d58:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d5c:	89 ec                	mov    %ebp,%esp
  800d5e:	5d                   	pop    %ebp
  800d5f:	c3                   	ret    

00800d60 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	83 ec 0c             	sub    $0xc,%esp
  800d66:	89 1c 24             	mov    %ebx,(%esp)
  800d69:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d6d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d71:	b8 00 00 00 00       	mov    $0x0,%eax
  800d76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d79:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7c:	89 c3                	mov    %eax,%ebx
  800d7e:	89 c7                	mov    %eax,%edi
  800d80:	89 c6                	mov    %eax,%esi
  800d82:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800d84:	8b 1c 24             	mov    (%esp),%ebx
  800d87:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d8b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d8f:	89 ec                	mov    %ebp,%esp
  800d91:	5d                   	pop    %ebp
  800d92:	c3                   	ret    

00800d93 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	83 ec 0c             	sub    $0xc,%esp
  800d99:	89 1c 24             	mov    %ebx,(%esp)
  800d9c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800da0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800da4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da9:	b8 10 00 00 00       	mov    $0x10,%eax
  800dae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800db1:	8b 55 08             	mov    0x8(%ebp),%edx
  800db4:	89 df                	mov    %ebx,%edi
  800db6:	89 de                	mov    %ebx,%esi
  800db8:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800dba:	8b 1c 24             	mov    (%esp),%ebx
  800dbd:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dc1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dc5:	89 ec                	mov    %ebp,%esp
  800dc7:	5d                   	pop    %ebp
  800dc8:	c3                   	ret    

00800dc9 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	83 ec 38             	sub    $0x38,%esp
  800dcf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dd2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dd5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ddd:	b8 0f 00 00 00       	mov    $0xf,%eax
  800de2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de5:	8b 55 08             	mov    0x8(%ebp),%edx
  800de8:	89 df                	mov    %ebx,%edi
  800dea:	89 de                	mov    %ebx,%esi
  800dec:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800dee:	85 c0                	test   %eax,%eax
  800df0:	7e 28                	jle    800e1a <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800df2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800df6:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800dfd:	00 
  800dfe:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  800e05:	00 
  800e06:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e0d:	00 
  800e0e:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  800e15:	e8 ae f3 ff ff       	call   8001c8 <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800e1a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e1d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e20:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e23:	89 ec                	mov    %ebp,%esp
  800e25:	5d                   	pop    %ebp
  800e26:	c3                   	ret    

00800e27 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800e27:	55                   	push   %ebp
  800e28:	89 e5                	mov    %esp,%ebp
  800e2a:	83 ec 0c             	sub    $0xc,%esp
  800e2d:	89 1c 24             	mov    %ebx,(%esp)
  800e30:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e34:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e38:	ba 00 00 00 00       	mov    $0x0,%edx
  800e3d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e42:	89 d1                	mov    %edx,%ecx
  800e44:	89 d3                	mov    %edx,%ebx
  800e46:	89 d7                	mov    %edx,%edi
  800e48:	89 d6                	mov    %edx,%esi
  800e4a:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800e4c:	8b 1c 24             	mov    (%esp),%ebx
  800e4f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800e53:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800e57:	89 ec                	mov    %ebp,%esp
  800e59:	5d                   	pop    %ebp
  800e5a:	c3                   	ret    

00800e5b <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	83 ec 38             	sub    $0x38,%esp
  800e61:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e64:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e67:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e6a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e6f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e74:	8b 55 08             	mov    0x8(%ebp),%edx
  800e77:	89 cb                	mov    %ecx,%ebx
  800e79:	89 cf                	mov    %ecx,%edi
  800e7b:	89 ce                	mov    %ecx,%esi
  800e7d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e7f:	85 c0                	test   %eax,%eax
  800e81:	7e 28                	jle    800eab <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e83:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e87:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800e8e:	00 
  800e8f:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  800e96:	00 
  800e97:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e9e:	00 
  800e9f:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  800ea6:	e8 1d f3 ff ff       	call   8001c8 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800eab:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800eae:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800eb1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800eb4:	89 ec                	mov    %ebp,%esp
  800eb6:	5d                   	pop    %ebp
  800eb7:	c3                   	ret    

00800eb8 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	83 ec 0c             	sub    $0xc,%esp
  800ebe:	89 1c 24             	mov    %ebx,(%esp)
  800ec1:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ec5:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ec9:	be 00 00 00 00       	mov    $0x0,%esi
  800ece:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ed3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800ed6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ed9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800edc:	8b 55 08             	mov    0x8(%ebp),%edx
  800edf:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800ee1:	8b 1c 24             	mov    (%esp),%ebx
  800ee4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ee8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800eec:	89 ec                	mov    %ebp,%esp
  800eee:	5d                   	pop    %ebp
  800eef:	c3                   	ret    

00800ef0 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ef0:	55                   	push   %ebp
  800ef1:	89 e5                	mov    %esp,%ebp
  800ef3:	83 ec 38             	sub    $0x38,%esp
  800ef6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ef9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800efc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800eff:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f04:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0f:	89 df                	mov    %ebx,%edi
  800f11:	89 de                	mov    %ebx,%esi
  800f13:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f15:	85 c0                	test   %eax,%eax
  800f17:	7e 28                	jle    800f41 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f19:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f1d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800f24:	00 
  800f25:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  800f2c:	00 
  800f2d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f34:	00 
  800f35:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  800f3c:	e8 87 f2 ff ff       	call   8001c8 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f41:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f44:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f47:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f4a:	89 ec                	mov    %ebp,%esp
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    

00800f4e <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	83 ec 38             	sub    $0x38,%esp
  800f54:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f57:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f5a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f5d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f62:	b8 09 00 00 00       	mov    $0x9,%eax
  800f67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6d:	89 df                	mov    %ebx,%edi
  800f6f:	89 de                	mov    %ebx,%esi
  800f71:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f73:	85 c0                	test   %eax,%eax
  800f75:	7e 28                	jle    800f9f <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f77:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f7b:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800f82:	00 
  800f83:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  800f8a:	00 
  800f8b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f92:	00 
  800f93:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  800f9a:	e8 29 f2 ff ff       	call   8001c8 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800f9f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fa2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fa5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fa8:	89 ec                	mov    %ebp,%esp
  800faa:	5d                   	pop    %ebp
  800fab:	c3                   	ret    

00800fac <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fac:	55                   	push   %ebp
  800fad:	89 e5                	mov    %esp,%ebp
  800faf:	83 ec 38             	sub    $0x38,%esp
  800fb2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800fb5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fb8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fc0:	b8 08 00 00 00       	mov    $0x8,%eax
  800fc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fc8:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcb:	89 df                	mov    %ebx,%edi
  800fcd:	89 de                	mov    %ebx,%esi
  800fcf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	7e 28                	jle    800ffd <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fd5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd9:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800fe0:	00 
  800fe1:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  800fe8:	00 
  800fe9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ff0:	00 
  800ff1:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  800ff8:	e8 cb f1 ff ff       	call   8001c8 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ffd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801000:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801003:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801006:	89 ec                	mov    %ebp,%esp
  801008:	5d                   	pop    %ebp
  801009:	c3                   	ret    

0080100a <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80100a:	55                   	push   %ebp
  80100b:	89 e5                	mov    %esp,%ebp
  80100d:	83 ec 38             	sub    $0x38,%esp
  801010:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801013:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801016:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801019:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101e:	b8 06 00 00 00       	mov    $0x6,%eax
  801023:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801026:	8b 55 08             	mov    0x8(%ebp),%edx
  801029:	89 df                	mov    %ebx,%edi
  80102b:	89 de                	mov    %ebx,%esi
  80102d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80102f:	85 c0                	test   %eax,%eax
  801031:	7e 28                	jle    80105b <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801033:	89 44 24 10          	mov    %eax,0x10(%esp)
  801037:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80103e:	00 
  80103f:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  801046:	00 
  801047:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80104e:	00 
  80104f:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  801056:	e8 6d f1 ff ff       	call   8001c8 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80105b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80105e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801061:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801064:	89 ec                	mov    %ebp,%esp
  801066:	5d                   	pop    %ebp
  801067:	c3                   	ret    

00801068 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801068:	55                   	push   %ebp
  801069:	89 e5                	mov    %esp,%ebp
  80106b:	83 ec 38             	sub    $0x38,%esp
  80106e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801071:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801074:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801077:	b8 05 00 00 00       	mov    $0x5,%eax
  80107c:	8b 75 18             	mov    0x18(%ebp),%esi
  80107f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801082:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801085:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801088:	8b 55 08             	mov    0x8(%ebp),%edx
  80108b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80108d:	85 c0                	test   %eax,%eax
  80108f:	7e 28                	jle    8010b9 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801091:	89 44 24 10          	mov    %eax,0x10(%esp)
  801095:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80109c:	00 
  80109d:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  8010a4:	00 
  8010a5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010ac:	00 
  8010ad:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  8010b4:	e8 0f f1 ff ff       	call   8001c8 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8010b9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010bc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010bf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010c2:	89 ec                	mov    %ebp,%esp
  8010c4:	5d                   	pop    %ebp
  8010c5:	c3                   	ret    

008010c6 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	83 ec 38             	sub    $0x38,%esp
  8010cc:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010cf:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010d2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d5:	be 00 00 00 00       	mov    $0x0,%esi
  8010da:	b8 04 00 00 00       	mov    $0x4,%eax
  8010df:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8010e8:	89 f7                	mov    %esi,%edi
  8010ea:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	7e 28                	jle    801118 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010f0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010f4:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8010fb:	00 
  8010fc:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  801103:	00 
  801104:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80110b:	00 
  80110c:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  801113:	e8 b0 f0 ff ff       	call   8001c8 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801118:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80111b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80111e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801121:	89 ec                	mov    %ebp,%esp
  801123:	5d                   	pop    %ebp
  801124:	c3                   	ret    

00801125 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  801125:	55                   	push   %ebp
  801126:	89 e5                	mov    %esp,%ebp
  801128:	83 ec 0c             	sub    $0xc,%esp
  80112b:	89 1c 24             	mov    %ebx,(%esp)
  80112e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801132:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801136:	ba 00 00 00 00       	mov    $0x0,%edx
  80113b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801140:	89 d1                	mov    %edx,%ecx
  801142:	89 d3                	mov    %edx,%ebx
  801144:	89 d7                	mov    %edx,%edi
  801146:	89 d6                	mov    %edx,%esi
  801148:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80114a:	8b 1c 24             	mov    (%esp),%ebx
  80114d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801151:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801155:	89 ec                	mov    %ebp,%esp
  801157:	5d                   	pop    %ebp
  801158:	c3                   	ret    

00801159 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801159:	55                   	push   %ebp
  80115a:	89 e5                	mov    %esp,%ebp
  80115c:	83 ec 0c             	sub    $0xc,%esp
  80115f:	89 1c 24             	mov    %ebx,(%esp)
  801162:	89 74 24 04          	mov    %esi,0x4(%esp)
  801166:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80116a:	ba 00 00 00 00       	mov    $0x0,%edx
  80116f:	b8 02 00 00 00       	mov    $0x2,%eax
  801174:	89 d1                	mov    %edx,%ecx
  801176:	89 d3                	mov    %edx,%ebx
  801178:	89 d7                	mov    %edx,%edi
  80117a:	89 d6                	mov    %edx,%esi
  80117c:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80117e:	8b 1c 24             	mov    (%esp),%ebx
  801181:	8b 74 24 04          	mov    0x4(%esp),%esi
  801185:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801189:	89 ec                	mov    %ebp,%esp
  80118b:	5d                   	pop    %ebp
  80118c:	c3                   	ret    

0080118d <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	83 ec 38             	sub    $0x38,%esp
  801193:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801196:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801199:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80119c:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011a1:	b8 03 00 00 00       	mov    $0x3,%eax
  8011a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011a9:	89 cb                	mov    %ecx,%ebx
  8011ab:	89 cf                	mov    %ecx,%edi
  8011ad:	89 ce                	mov    %ecx,%esi
  8011af:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011b1:	85 c0                	test   %eax,%eax
  8011b3:	7e 28                	jle    8011dd <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011b9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  8011c0:	00 
  8011c1:	c7 44 24 08 3f 33 80 	movl   $0x80333f,0x8(%esp)
  8011c8:	00 
  8011c9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011d0:	00 
  8011d1:	c7 04 24 5c 33 80 00 	movl   $0x80335c,(%esp)
  8011d8:	e8 eb ef ff ff       	call   8001c8 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8011dd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011e0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011e3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011e6:	89 ec                	mov    %ebp,%esp
  8011e8:	5d                   	pop    %ebp
  8011e9:	c3                   	ret    
  8011ea:	00 00                	add    %al,(%eax)
  8011ec:	00 00                	add    %al,(%eax)
	...

008011f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8011f0:	55                   	push   %ebp
  8011f1:	89 e5                	mov    %esp,%ebp
  8011f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8011fb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8011fe:	5d                   	pop    %ebp
  8011ff:	c3                   	ret    

00801200 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801200:	55                   	push   %ebp
  801201:	89 e5                	mov    %esp,%ebp
  801203:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	89 04 24             	mov    %eax,(%esp)
  80120c:	e8 df ff ff ff       	call   8011f0 <fd2num>
  801211:	05 20 00 0d 00       	add    $0xd0020,%eax
  801216:	c1 e0 0c             	shl    $0xc,%eax
}
  801219:	c9                   	leave  
  80121a:	c3                   	ret    

0080121b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80121b:	55                   	push   %ebp
  80121c:	89 e5                	mov    %esp,%ebp
  80121e:	57                   	push   %edi
  80121f:	56                   	push   %esi
  801220:	53                   	push   %ebx
  801221:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801224:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801229:	a8 01                	test   $0x1,%al
  80122b:	74 36                	je     801263 <fd_alloc+0x48>
  80122d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801232:	a8 01                	test   $0x1,%al
  801234:	74 2d                	je     801263 <fd_alloc+0x48>
  801236:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80123b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801240:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801245:	89 c3                	mov    %eax,%ebx
  801247:	89 c2                	mov    %eax,%edx
  801249:	c1 ea 16             	shr    $0x16,%edx
  80124c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80124f:	f6 c2 01             	test   $0x1,%dl
  801252:	74 14                	je     801268 <fd_alloc+0x4d>
  801254:	89 c2                	mov    %eax,%edx
  801256:	c1 ea 0c             	shr    $0xc,%edx
  801259:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80125c:	f6 c2 01             	test   $0x1,%dl
  80125f:	75 10                	jne    801271 <fd_alloc+0x56>
  801261:	eb 05                	jmp    801268 <fd_alloc+0x4d>
  801263:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801268:	89 1f                	mov    %ebx,(%edi)
  80126a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80126f:	eb 17                	jmp    801288 <fd_alloc+0x6d>
  801271:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801276:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80127b:	75 c8                	jne    801245 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80127d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801283:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801288:	5b                   	pop    %ebx
  801289:	5e                   	pop    %esi
  80128a:	5f                   	pop    %edi
  80128b:	5d                   	pop    %ebp
  80128c:	c3                   	ret    

0080128d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80128d:	55                   	push   %ebp
  80128e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
  801293:	83 f8 1f             	cmp    $0x1f,%eax
  801296:	77 36                	ja     8012ce <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801298:	05 00 00 0d 00       	add    $0xd0000,%eax
  80129d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8012a0:	89 c2                	mov    %eax,%edx
  8012a2:	c1 ea 16             	shr    $0x16,%edx
  8012a5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012ac:	f6 c2 01             	test   $0x1,%dl
  8012af:	74 1d                	je     8012ce <fd_lookup+0x41>
  8012b1:	89 c2                	mov    %eax,%edx
  8012b3:	c1 ea 0c             	shr    $0xc,%edx
  8012b6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012bd:	f6 c2 01             	test   $0x1,%dl
  8012c0:	74 0c                	je     8012ce <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c5:	89 02                	mov    %eax,(%edx)
  8012c7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8012cc:	eb 05                	jmp    8012d3 <fd_lookup+0x46>
  8012ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012d3:	5d                   	pop    %ebp
  8012d4:	c3                   	ret    

008012d5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8012d5:	55                   	push   %ebp
  8012d6:	89 e5                	mov    %esp,%ebp
  8012d8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012db:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	89 04 24             	mov    %eax,(%esp)
  8012e8:	e8 a0 ff ff ff       	call   80128d <fd_lookup>
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	78 0e                	js     8012ff <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8012f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012f7:	89 50 04             	mov    %edx,0x4(%eax)
  8012fa:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8012ff:	c9                   	leave  
  801300:	c3                   	ret    

00801301 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801301:	55                   	push   %ebp
  801302:	89 e5                	mov    %esp,%ebp
  801304:	56                   	push   %esi
  801305:	53                   	push   %ebx
  801306:	83 ec 10             	sub    $0x10,%esp
  801309:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80130c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80130f:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801314:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801319:	be e8 33 80 00       	mov    $0x8033e8,%esi
		if (devtab[i]->dev_id == dev_id) {
  80131e:	39 08                	cmp    %ecx,(%eax)
  801320:	75 10                	jne    801332 <dev_lookup+0x31>
  801322:	eb 04                	jmp    801328 <dev_lookup+0x27>
  801324:	39 08                	cmp    %ecx,(%eax)
  801326:	75 0a                	jne    801332 <dev_lookup+0x31>
			*dev = devtab[i];
  801328:	89 03                	mov    %eax,(%ebx)
  80132a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80132f:	90                   	nop
  801330:	eb 31                	jmp    801363 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801332:	83 c2 01             	add    $0x1,%edx
  801335:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801338:	85 c0                	test   %eax,%eax
  80133a:	75 e8                	jne    801324 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80133c:	a1 74 70 80 00       	mov    0x807074,%eax
  801341:	8b 40 4c             	mov    0x4c(%eax),%eax
  801344:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801348:	89 44 24 04          	mov    %eax,0x4(%esp)
  80134c:	c7 04 24 6c 33 80 00 	movl   $0x80336c,(%esp)
  801353:	e8 35 ef ff ff       	call   80028d <cprintf>
	*dev = 0;
  801358:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80135e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801363:	83 c4 10             	add    $0x10,%esp
  801366:	5b                   	pop    %ebx
  801367:	5e                   	pop    %esi
  801368:	5d                   	pop    %ebp
  801369:	c3                   	ret    

0080136a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80136a:	55                   	push   %ebp
  80136b:	89 e5                	mov    %esp,%ebp
  80136d:	53                   	push   %ebx
  80136e:	83 ec 24             	sub    $0x24,%esp
  801371:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801374:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801377:	89 44 24 04          	mov    %eax,0x4(%esp)
  80137b:	8b 45 08             	mov    0x8(%ebp),%eax
  80137e:	89 04 24             	mov    %eax,(%esp)
  801381:	e8 07 ff ff ff       	call   80128d <fd_lookup>
  801386:	85 c0                	test   %eax,%eax
  801388:	78 53                	js     8013dd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80138a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80138d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801394:	8b 00                	mov    (%eax),%eax
  801396:	89 04 24             	mov    %eax,(%esp)
  801399:	e8 63 ff ff ff       	call   801301 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	78 3b                	js     8013dd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8013a2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013aa:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8013ae:	74 2d                	je     8013dd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013b0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013b3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013ba:	00 00 00 
	stat->st_isdir = 0;
  8013bd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013c4:	00 00 00 
	stat->st_dev = dev;
  8013c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013ca:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013d7:	89 14 24             	mov    %edx,(%esp)
  8013da:	ff 50 14             	call   *0x14(%eax)
}
  8013dd:	83 c4 24             	add    $0x24,%esp
  8013e0:	5b                   	pop    %ebx
  8013e1:	5d                   	pop    %ebp
  8013e2:	c3                   	ret    

008013e3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8013e3:	55                   	push   %ebp
  8013e4:	89 e5                	mov    %esp,%ebp
  8013e6:	53                   	push   %ebx
  8013e7:	83 ec 24             	sub    $0x24,%esp
  8013ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f4:	89 1c 24             	mov    %ebx,(%esp)
  8013f7:	e8 91 fe ff ff       	call   80128d <fd_lookup>
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	78 5f                	js     80145f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801400:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801403:	89 44 24 04          	mov    %eax,0x4(%esp)
  801407:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80140a:	8b 00                	mov    (%eax),%eax
  80140c:	89 04 24             	mov    %eax,(%esp)
  80140f:	e8 ed fe ff ff       	call   801301 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801414:	85 c0                	test   %eax,%eax
  801416:	78 47                	js     80145f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801418:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80141b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80141f:	75 23                	jne    801444 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801421:	a1 74 70 80 00       	mov    0x807074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801426:	8b 40 4c             	mov    0x4c(%eax),%eax
  801429:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80142d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801431:	c7 04 24 8c 33 80 00 	movl   $0x80338c,(%esp)
  801438:	e8 50 ee ff ff       	call   80028d <cprintf>
  80143d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801442:	eb 1b                	jmp    80145f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801444:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801447:	8b 48 18             	mov    0x18(%eax),%ecx
  80144a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80144f:	85 c9                	test   %ecx,%ecx
  801451:	74 0c                	je     80145f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801453:	8b 45 0c             	mov    0xc(%ebp),%eax
  801456:	89 44 24 04          	mov    %eax,0x4(%esp)
  80145a:	89 14 24             	mov    %edx,(%esp)
  80145d:	ff d1                	call   *%ecx
}
  80145f:	83 c4 24             	add    $0x24,%esp
  801462:	5b                   	pop    %ebx
  801463:	5d                   	pop    %ebp
  801464:	c3                   	ret    

00801465 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801465:	55                   	push   %ebp
  801466:	89 e5                	mov    %esp,%ebp
  801468:	53                   	push   %ebx
  801469:	83 ec 24             	sub    $0x24,%esp
  80146c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80146f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801472:	89 44 24 04          	mov    %eax,0x4(%esp)
  801476:	89 1c 24             	mov    %ebx,(%esp)
  801479:	e8 0f fe ff ff       	call   80128d <fd_lookup>
  80147e:	85 c0                	test   %eax,%eax
  801480:	78 66                	js     8014e8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801482:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801485:	89 44 24 04          	mov    %eax,0x4(%esp)
  801489:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148c:	8b 00                	mov    (%eax),%eax
  80148e:	89 04 24             	mov    %eax,(%esp)
  801491:	e8 6b fe ff ff       	call   801301 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801496:	85 c0                	test   %eax,%eax
  801498:	78 4e                	js     8014e8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80149a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80149d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8014a1:	75 23                	jne    8014c6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8014a3:	a1 74 70 80 00       	mov    0x807074,%eax
  8014a8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8014ab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8014af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014b3:	c7 04 24 ad 33 80 00 	movl   $0x8033ad,(%esp)
  8014ba:	e8 ce ed ff ff       	call   80028d <cprintf>
  8014bf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8014c4:	eb 22                	jmp    8014e8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014c9:	8b 48 0c             	mov    0xc(%eax),%ecx
  8014cc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014d1:	85 c9                	test   %ecx,%ecx
  8014d3:	74 13                	je     8014e8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014e3:	89 14 24             	mov    %edx,(%esp)
  8014e6:	ff d1                	call   *%ecx
}
  8014e8:	83 c4 24             	add    $0x24,%esp
  8014eb:	5b                   	pop    %ebx
  8014ec:	5d                   	pop    %ebp
  8014ed:	c3                   	ret    

008014ee <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8014ee:	55                   	push   %ebp
  8014ef:	89 e5                	mov    %esp,%ebp
  8014f1:	53                   	push   %ebx
  8014f2:	83 ec 24             	sub    $0x24,%esp
  8014f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014f8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014ff:	89 1c 24             	mov    %ebx,(%esp)
  801502:	e8 86 fd ff ff       	call   80128d <fd_lookup>
  801507:	85 c0                	test   %eax,%eax
  801509:	78 6b                	js     801576 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80150b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80150e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801512:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801515:	8b 00                	mov    (%eax),%eax
  801517:	89 04 24             	mov    %eax,(%esp)
  80151a:	e8 e2 fd ff ff       	call   801301 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80151f:	85 c0                	test   %eax,%eax
  801521:	78 53                	js     801576 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801523:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801526:	8b 42 08             	mov    0x8(%edx),%eax
  801529:	83 e0 03             	and    $0x3,%eax
  80152c:	83 f8 01             	cmp    $0x1,%eax
  80152f:	75 23                	jne    801554 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801531:	a1 74 70 80 00       	mov    0x807074,%eax
  801536:	8b 40 4c             	mov    0x4c(%eax),%eax
  801539:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80153d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801541:	c7 04 24 ca 33 80 00 	movl   $0x8033ca,(%esp)
  801548:	e8 40 ed ff ff       	call   80028d <cprintf>
  80154d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801552:	eb 22                	jmp    801576 <read+0x88>
	}
	if (!dev->dev_read)
  801554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801557:	8b 48 08             	mov    0x8(%eax),%ecx
  80155a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80155f:	85 c9                	test   %ecx,%ecx
  801561:	74 13                	je     801576 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801563:	8b 45 10             	mov    0x10(%ebp),%eax
  801566:	89 44 24 08          	mov    %eax,0x8(%esp)
  80156a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80156d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801571:	89 14 24             	mov    %edx,(%esp)
  801574:	ff d1                	call   *%ecx
}
  801576:	83 c4 24             	add    $0x24,%esp
  801579:	5b                   	pop    %ebx
  80157a:	5d                   	pop    %ebp
  80157b:	c3                   	ret    

0080157c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	57                   	push   %edi
  801580:	56                   	push   %esi
  801581:	53                   	push   %ebx
  801582:	83 ec 1c             	sub    $0x1c,%esp
  801585:	8b 7d 08             	mov    0x8(%ebp),%edi
  801588:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80158b:	ba 00 00 00 00       	mov    $0x0,%edx
  801590:	bb 00 00 00 00       	mov    $0x0,%ebx
  801595:	b8 00 00 00 00       	mov    $0x0,%eax
  80159a:	85 f6                	test   %esi,%esi
  80159c:	74 29                	je     8015c7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80159e:	89 f0                	mov    %esi,%eax
  8015a0:	29 d0                	sub    %edx,%eax
  8015a2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015a6:	03 55 0c             	add    0xc(%ebp),%edx
  8015a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015ad:	89 3c 24             	mov    %edi,(%esp)
  8015b0:	e8 39 ff ff ff       	call   8014ee <read>
		if (m < 0)
  8015b5:	85 c0                	test   %eax,%eax
  8015b7:	78 0e                	js     8015c7 <readn+0x4b>
			return m;
		if (m == 0)
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	74 08                	je     8015c5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015bd:	01 c3                	add    %eax,%ebx
  8015bf:	89 da                	mov    %ebx,%edx
  8015c1:	39 f3                	cmp    %esi,%ebx
  8015c3:	72 d9                	jb     80159e <readn+0x22>
  8015c5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  8015c7:	83 c4 1c             	add    $0x1c,%esp
  8015ca:	5b                   	pop    %ebx
  8015cb:	5e                   	pop    %esi
  8015cc:	5f                   	pop    %edi
  8015cd:	5d                   	pop    %ebp
  8015ce:	c3                   	ret    

008015cf <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  8015cf:	55                   	push   %ebp
  8015d0:	89 e5                	mov    %esp,%ebp
  8015d2:	56                   	push   %esi
  8015d3:	53                   	push   %ebx
  8015d4:	83 ec 20             	sub    $0x20,%esp
  8015d7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8015da:	89 34 24             	mov    %esi,(%esp)
  8015dd:	e8 0e fc ff ff       	call   8011f0 <fd2num>
  8015e2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8015e5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8015e9:	89 04 24             	mov    %eax,(%esp)
  8015ec:	e8 9c fc ff ff       	call   80128d <fd_lookup>
  8015f1:	89 c3                	mov    %eax,%ebx
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	78 05                	js     8015fc <fd_close+0x2d>
  8015f7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8015fa:	74 0c                	je     801608 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8015fc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801600:	19 c0                	sbb    %eax,%eax
  801602:	f7 d0                	not    %eax
  801604:	21 c3                	and    %eax,%ebx
  801606:	eb 3d                	jmp    801645 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801608:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80160b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80160f:	8b 06                	mov    (%esi),%eax
  801611:	89 04 24             	mov    %eax,(%esp)
  801614:	e8 e8 fc ff ff       	call   801301 <dev_lookup>
  801619:	89 c3                	mov    %eax,%ebx
  80161b:	85 c0                	test   %eax,%eax
  80161d:	78 16                	js     801635 <fd_close+0x66>
		if (dev->dev_close)
  80161f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801622:	8b 40 10             	mov    0x10(%eax),%eax
  801625:	bb 00 00 00 00       	mov    $0x0,%ebx
  80162a:	85 c0                	test   %eax,%eax
  80162c:	74 07                	je     801635 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80162e:	89 34 24             	mov    %esi,(%esp)
  801631:	ff d0                	call   *%eax
  801633:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801635:	89 74 24 04          	mov    %esi,0x4(%esp)
  801639:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801640:	e8 c5 f9 ff ff       	call   80100a <sys_page_unmap>
	return r;
}
  801645:	89 d8                	mov    %ebx,%eax
  801647:	83 c4 20             	add    $0x20,%esp
  80164a:	5b                   	pop    %ebx
  80164b:	5e                   	pop    %esi
  80164c:	5d                   	pop    %ebp
  80164d:	c3                   	ret    

0080164e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801654:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801657:	89 44 24 04          	mov    %eax,0x4(%esp)
  80165b:	8b 45 08             	mov    0x8(%ebp),%eax
  80165e:	89 04 24             	mov    %eax,(%esp)
  801661:	e8 27 fc ff ff       	call   80128d <fd_lookup>
  801666:	85 c0                	test   %eax,%eax
  801668:	78 13                	js     80167d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80166a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801671:	00 
  801672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801675:	89 04 24             	mov    %eax,(%esp)
  801678:	e8 52 ff ff ff       	call   8015cf <fd_close>
}
  80167d:	c9                   	leave  
  80167e:	c3                   	ret    

0080167f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80167f:	55                   	push   %ebp
  801680:	89 e5                	mov    %esp,%ebp
  801682:	83 ec 18             	sub    $0x18,%esp
  801685:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801688:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80168b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801692:	00 
  801693:	8b 45 08             	mov    0x8(%ebp),%eax
  801696:	89 04 24             	mov    %eax,(%esp)
  801699:	e8 a9 03 00 00       	call   801a47 <open>
  80169e:	89 c3                	mov    %eax,%ebx
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	78 1b                	js     8016bf <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8016a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ab:	89 1c 24             	mov    %ebx,(%esp)
  8016ae:	e8 b7 fc ff ff       	call   80136a <fstat>
  8016b3:	89 c6                	mov    %eax,%esi
	close(fd);
  8016b5:	89 1c 24             	mov    %ebx,(%esp)
  8016b8:	e8 91 ff ff ff       	call   80164e <close>
  8016bd:	89 f3                	mov    %esi,%ebx
	return r;
}
  8016bf:	89 d8                	mov    %ebx,%eax
  8016c1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8016c4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8016c7:	89 ec                	mov    %ebp,%esp
  8016c9:	5d                   	pop    %ebp
  8016ca:	c3                   	ret    

008016cb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
  8016ce:	53                   	push   %ebx
  8016cf:	83 ec 14             	sub    $0x14,%esp
  8016d2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  8016d7:	89 1c 24             	mov    %ebx,(%esp)
  8016da:	e8 6f ff ff ff       	call   80164e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8016df:	83 c3 01             	add    $0x1,%ebx
  8016e2:	83 fb 20             	cmp    $0x20,%ebx
  8016e5:	75 f0                	jne    8016d7 <close_all+0xc>
		close(i);
}
  8016e7:	83 c4 14             	add    $0x14,%esp
  8016ea:	5b                   	pop    %ebx
  8016eb:	5d                   	pop    %ebp
  8016ec:	c3                   	ret    

008016ed <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016ed:	55                   	push   %ebp
  8016ee:	89 e5                	mov    %esp,%ebp
  8016f0:	83 ec 58             	sub    $0x58,%esp
  8016f3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8016f6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8016f9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8016fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016ff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801702:	89 44 24 04          	mov    %eax,0x4(%esp)
  801706:	8b 45 08             	mov    0x8(%ebp),%eax
  801709:	89 04 24             	mov    %eax,(%esp)
  80170c:	e8 7c fb ff ff       	call   80128d <fd_lookup>
  801711:	89 c3                	mov    %eax,%ebx
  801713:	85 c0                	test   %eax,%eax
  801715:	0f 88 e0 00 00 00    	js     8017fb <dup+0x10e>
		return r;
	close(newfdnum);
  80171b:	89 3c 24             	mov    %edi,(%esp)
  80171e:	e8 2b ff ff ff       	call   80164e <close>

	newfd = INDEX2FD(newfdnum);
  801723:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801729:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80172c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80172f:	89 04 24             	mov    %eax,(%esp)
  801732:	e8 c9 fa ff ff       	call   801200 <fd2data>
  801737:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801739:	89 34 24             	mov    %esi,(%esp)
  80173c:	e8 bf fa ff ff       	call   801200 <fd2data>
  801741:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801744:	89 da                	mov    %ebx,%edx
  801746:	89 d8                	mov    %ebx,%eax
  801748:	c1 e8 16             	shr    $0x16,%eax
  80174b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801752:	a8 01                	test   $0x1,%al
  801754:	74 43                	je     801799 <dup+0xac>
  801756:	c1 ea 0c             	shr    $0xc,%edx
  801759:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801760:	a8 01                	test   $0x1,%al
  801762:	74 35                	je     801799 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801764:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80176b:	25 07 0e 00 00       	and    $0xe07,%eax
  801770:	89 44 24 10          	mov    %eax,0x10(%esp)
  801774:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801777:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80177b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801782:	00 
  801783:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801787:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80178e:	e8 d5 f8 ff ff       	call   801068 <sys_page_map>
  801793:	89 c3                	mov    %eax,%ebx
  801795:	85 c0                	test   %eax,%eax
  801797:	78 3f                	js     8017d8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80179c:	89 c2                	mov    %eax,%edx
  80179e:	c1 ea 0c             	shr    $0xc,%edx
  8017a1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8017a8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8017ae:	89 54 24 10          	mov    %edx,0x10(%esp)
  8017b2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8017b6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017bd:	00 
  8017be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017c9:	e8 9a f8 ff ff       	call   801068 <sys_page_map>
  8017ce:	89 c3                	mov    %eax,%ebx
  8017d0:	85 c0                	test   %eax,%eax
  8017d2:	78 04                	js     8017d8 <dup+0xeb>
  8017d4:	89 fb                	mov    %edi,%ebx
  8017d6:	eb 23                	jmp    8017fb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8017d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017e3:	e8 22 f8 ff ff       	call   80100a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8017eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017ef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017f6:	e8 0f f8 ff ff       	call   80100a <sys_page_unmap>
	return r;
}
  8017fb:	89 d8                	mov    %ebx,%eax
  8017fd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801800:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801803:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801806:	89 ec                	mov    %ebp,%esp
  801808:	5d                   	pop    %ebp
  801809:	c3                   	ret    
	...

0080180c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	53                   	push   %ebx
  801810:	83 ec 14             	sub    $0x14,%esp
  801813:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801815:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80181b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801822:	00 
  801823:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  80182a:	00 
  80182b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80182f:	89 14 24             	mov    %edx,(%esp)
  801832:	e8 79 13 00 00       	call   802bb0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801837:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80183e:	00 
  80183f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801843:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80184a:	e8 c3 13 00 00       	call   802c12 <ipc_recv>
}
  80184f:	83 c4 14             	add    $0x14,%esp
  801852:	5b                   	pop    %ebx
  801853:	5d                   	pop    %ebp
  801854:	c3                   	ret    

00801855 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801855:	55                   	push   %ebp
  801856:	89 e5                	mov    %esp,%ebp
  801858:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80185b:	8b 45 08             	mov    0x8(%ebp),%eax
  80185e:	8b 40 0c             	mov    0xc(%eax),%eax
  801861:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801866:	8b 45 0c             	mov    0xc(%ebp),%eax
  801869:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80186e:	ba 00 00 00 00       	mov    $0x0,%edx
  801873:	b8 02 00 00 00       	mov    $0x2,%eax
  801878:	e8 8f ff ff ff       	call   80180c <fsipc>
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801885:	ba 00 00 00 00       	mov    $0x0,%edx
  80188a:	b8 08 00 00 00       	mov    $0x8,%eax
  80188f:	e8 78 ff ff ff       	call   80180c <fsipc>
}
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
  801899:	53                   	push   %ebx
  80189a:	83 ec 14             	sub    $0x14,%esp
  80189d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8018a6:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8018b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8018b5:	e8 52 ff ff ff       	call   80180c <fsipc>
  8018ba:	85 c0                	test   %eax,%eax
  8018bc:	78 2b                	js     8018e9 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8018be:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  8018c5:	00 
  8018c6:	89 1c 24             	mov    %ebx,(%esp)
  8018c9:	e8 9c f0 ff ff       	call   80096a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8018ce:	a1 80 40 80 00       	mov    0x804080,%eax
  8018d3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8018d9:	a1 84 40 80 00       	mov    0x804084,%eax
  8018de:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  8018e4:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8018e9:	83 c4 14             	add    $0x14,%esp
  8018ec:	5b                   	pop    %ebx
  8018ed:	5d                   	pop    %ebp
  8018ee:	c3                   	ret    

008018ef <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
  8018f2:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  8018f5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8018fc:	00 
  8018fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801904:	00 
  801905:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  80190c:	e8 b5 f1 ff ff       	call   800ac6 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	8b 40 0c             	mov    0xc(%eax),%eax
  801917:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  80191c:	ba 00 00 00 00       	mov    $0x0,%edx
  801921:	b8 06 00 00 00       	mov    $0x6,%eax
  801926:	e8 e1 fe ff ff       	call   80180c <fsipc>
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801933:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80193a:	00 
  80193b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801942:	00 
  801943:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  80194a:	e8 77 f1 ff ff       	call   800ac6 <memset>
  80194f:	8b 45 10             	mov    0x10(%ebp),%eax
  801952:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801957:	76 05                	jbe    80195e <devfile_write+0x31>
  801959:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80195e:	8b 55 08             	mov    0x8(%ebp),%edx
  801961:	8b 52 0c             	mov    0xc(%edx),%edx
  801964:	89 15 00 40 80 00    	mov    %edx,0x804000
        fsipcbuf.write.req_n = numberOfBytes;
  80196a:	a3 04 40 80 00       	mov    %eax,0x804004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  80196f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801973:	8b 45 0c             	mov    0xc(%ebp),%eax
  801976:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197a:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801981:	e8 9f f1 ff ff       	call   800b25 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  801986:	ba 00 00 00 00       	mov    $0x0,%edx
  80198b:	b8 04 00 00 00       	mov    $0x4,%eax
  801990:	e8 77 fe ff ff       	call   80180c <fsipc>
              return r;
        return r;
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
  80199a:	53                   	push   %ebx
  80199b:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  80199e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8019a5:	00 
  8019a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8019ad:	00 
  8019ae:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  8019b5:	e8 0c f1 ff ff       	call   800ac6 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8019bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8019c0:	a3 00 40 80 00       	mov    %eax,0x804000
        fsipcbuf.read.req_n = n;
  8019c5:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c8:	a3 04 40 80 00       	mov    %eax,0x804004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  8019cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8019d2:	b8 03 00 00 00       	mov    $0x3,%eax
  8019d7:	e8 30 fe ff ff       	call   80180c <fsipc>
  8019dc:	89 c3                	mov    %eax,%ebx
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	78 17                	js     8019f9 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  8019e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019e6:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  8019ed:	00 
  8019ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f1:	89 04 24             	mov    %eax,(%esp)
  8019f4:	e8 2c f1 ff ff       	call   800b25 <memmove>
        return r;
}
  8019f9:	89 d8                	mov    %ebx,%eax
  8019fb:	83 c4 14             	add    $0x14,%esp
  8019fe:	5b                   	pop    %ebx
  8019ff:	5d                   	pop    %ebp
  801a00:	c3                   	ret    

00801a01 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
  801a04:	53                   	push   %ebx
  801a05:	83 ec 14             	sub    $0x14,%esp
  801a08:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801a0b:	89 1c 24             	mov    %ebx,(%esp)
  801a0e:	e8 0d ef ff ff       	call   800920 <strlen>
  801a13:	89 c2                	mov    %eax,%edx
  801a15:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801a1a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801a20:	7f 1f                	jg     801a41 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801a22:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a26:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801a2d:	e8 38 ef ff ff       	call   80096a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801a32:	ba 00 00 00 00       	mov    $0x0,%edx
  801a37:	b8 07 00 00 00       	mov    $0x7,%eax
  801a3c:	e8 cb fd ff ff       	call   80180c <fsipc>
}
  801a41:	83 c4 14             	add    $0x14,%esp
  801a44:	5b                   	pop    %ebx
  801a45:	5d                   	pop    %ebp
  801a46:	c3                   	ret    

00801a47 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	56                   	push   %esi
  801a4b:	53                   	push   %ebx
  801a4c:	83 ec 20             	sub    $0x20,%esp
  801a4f:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  801a52:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801a59:	00 
  801a5a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801a61:	00 
  801a62:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801a69:	e8 58 f0 ff ff       	call   800ac6 <memset>
    if(strlen(path)>=MAXPATHLEN)
  801a6e:	89 34 24             	mov    %esi,(%esp)
  801a71:	e8 aa ee ff ff       	call   800920 <strlen>
  801a76:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a7b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a80:	0f 8f 84 00 00 00    	jg     801b0a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  801a86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a89:	89 04 24             	mov    %eax,(%esp)
  801a8c:	e8 8a f7 ff ff       	call   80121b <fd_alloc>
  801a91:	89 c3                	mov    %eax,%ebx
  801a93:	85 c0                	test   %eax,%eax
  801a95:	78 73                	js     801b0a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  801a97:	0f b6 06             	movzbl (%esi),%eax
  801a9a:	84 c0                	test   %al,%al
  801a9c:	74 20                	je     801abe <open+0x77>
  801a9e:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  801aa0:	0f be c0             	movsbl %al,%eax
  801aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa7:	c7 04 24 fc 33 80 00 	movl   $0x8033fc,(%esp)
  801aae:	e8 da e7 ff ff       	call   80028d <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  801ab3:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  801ab7:	83 c3 01             	add    $0x1,%ebx
  801aba:	84 c0                	test   %al,%al
  801abc:	75 e2                	jne    801aa0 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  801abe:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ac2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801ac9:	e8 9c ee ff ff       	call   80096a <strcpy>
    fsipcbuf.open.req_omode = mode;
  801ace:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ad1:	a3 00 44 80 00       	mov    %eax,0x804400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  801ad6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ad9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ade:	e8 29 fd ff ff       	call   80180c <fsipc>
  801ae3:	89 c3                	mov    %eax,%ebx
  801ae5:	85 c0                	test   %eax,%eax
  801ae7:	79 15                	jns    801afe <open+0xb7>
        {
            fd_close(fd,1);
  801ae9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801af0:	00 
  801af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af4:	89 04 24             	mov    %eax,(%esp)
  801af7:	e8 d3 fa ff ff       	call   8015cf <fd_close>
             return r;
  801afc:	eb 0c                	jmp    801b0a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  801afe:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b01:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  801b07:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  801b0a:	89 d8                	mov    %ebx,%eax
  801b0c:	83 c4 20             	add    $0x20,%esp
  801b0f:	5b                   	pop    %ebx
  801b10:	5e                   	pop    %esi
  801b11:	5d                   	pop    %ebp
  801b12:	c3                   	ret    
	...

00801b14 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
  801b17:	57                   	push   %edi
  801b18:	56                   	push   %esi
  801b19:	53                   	push   %ebx
  801b1a:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801b20:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b27:	00 
  801b28:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2b:	89 04 24             	mov    %eax,(%esp)
  801b2e:	e8 14 ff ff ff       	call   801a47 <open>
  801b33:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  801b39:	89 c3                	mov    %eax,%ebx
  801b3b:	85 c0                	test   %eax,%eax
  801b3d:	0f 88 d1 05 00 00    	js     802114 <spawn+0x600>
	fd = r;
    // cprintf("fd--->%d",fd);
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
	    || elf->e_magic != ELF_MAGIC) {
  801b43:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801b4a:	00 
  801b4b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801b51:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b55:	89 1c 24             	mov    %ebx,(%esp)
  801b58:	e8 91 f9 ff ff       	call   8014ee <read>
		return r;
	fd = r;
    // cprintf("fd--->%d",fd);
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801b5d:	3d 00 02 00 00       	cmp    $0x200,%eax
  801b62:	75 0c                	jne    801b70 <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801b64:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801b6b:	45 4c 46 
  801b6e:	74 36                	je     801ba6 <spawn+0x92>
		close(fd);
  801b70:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801b76:	89 04 24             	mov    %eax,(%esp)
  801b79:	e8 d0 fa ff ff       	call   80164e <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801b7e:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801b85:	46 
  801b86:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801b8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b90:	c7 04 24 ff 33 80 00 	movl   $0x8033ff,(%esp)
  801b97:	e8 f1 e6 ff ff       	call   80028d <cprintf>
  801b9c:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
		return -E_NOT_EXEC;
  801ba1:	e9 6e 05 00 00       	jmp    802114 <spawn+0x600>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801ba6:	ba 07 00 00 00       	mov    $0x7,%edx
  801bab:	89 d0                	mov    %edx,%eax
  801bad:	cd 30                	int    $0x30
  801baf:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
	}
     
       // Create new child environment
	if ((r = sys_exofork()) < 0)
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	0f 88 51 05 00 00    	js     80210e <spawn+0x5fa>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801bbd:	89 c6                	mov    %eax,%esi
  801bbf:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801bc5:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801bc8:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801bce:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801bd4:	b9 11 00 00 00       	mov    $0x11,%ecx
  801bd9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	cprintf("\nelf->entry %x\n",elf->e_entry);
  801bdb:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801be1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801be5:	c7 04 24 19 34 80 00 	movl   $0x803419,(%esp)
  801bec:	e8 9c e6 ff ff       	call   80028d <cprintf>
        child_tf.tf_eip = elf->e_entry;
  801bf1:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801bf7:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801bfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c00:	8b 02                	mov    (%edx),%eax
  801c02:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c07:	be 00 00 00 00       	mov    $0x0,%esi
  801c0c:	85 c0                	test   %eax,%eax
  801c0e:	75 16                	jne    801c26 <spawn+0x112>
  801c10:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801c17:	00 00 00 
  801c1a:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801c21:	00 00 00 
  801c24:	eb 2c                	jmp    801c52 <spawn+0x13e>
  801c26:	8b 7d 0c             	mov    0xc(%ebp),%edi
		string_size += strlen(argv[argc]) + 1;
  801c29:	89 04 24             	mov    %eax,(%esp)
  801c2c:	e8 ef ec ff ff       	call   800920 <strlen>
  801c31:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801c35:	83 c6 01             	add    $0x1,%esi
  801c38:	8d 14 b5 00 00 00 00 	lea    0x0(,%esi,4),%edx
  801c3f:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801c42:	85 c0                	test   %eax,%eax
  801c44:	75 e3                	jne    801c29 <spawn+0x115>
  801c46:	89 95 7c fd ff ff    	mov    %edx,-0x284(%ebp)
  801c4c:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801c52:	f7 db                	neg    %ebx
  801c54:	8d bb 00 10 40 00    	lea    0x401000(%ebx),%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801c5a:	89 fa                	mov    %edi,%edx
  801c5c:	83 e2 fc             	and    $0xfffffffc,%edx
  801c5f:	89 f0                	mov    %esi,%eax
  801c61:	f7 d0                	not    %eax
  801c63:	8d 04 82             	lea    (%edx,%eax,4),%eax
  801c66:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801c6c:	83 e8 08             	sub    $0x8,%eax
  801c6f:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  801c75:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801c7a:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801c7f:	0f 86 8f 04 00 00    	jbe    802114 <spawn+0x600>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c85:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801c8c:	00 
  801c8d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801c94:	00 
  801c95:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c9c:	e8 25 f4 ff ff       	call   8010c6 <sys_page_alloc>
  801ca1:	89 c3                	mov    %eax,%ebx
  801ca3:	85 c0                	test   %eax,%eax
  801ca5:	0f 88 69 04 00 00    	js     802114 <spawn+0x600>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801cab:	85 f6                	test   %esi,%esi
  801cad:	7e 46                	jle    801cf5 <spawn+0x1e1>
  801caf:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cb4:	89 b5 8c fd ff ff    	mov    %esi,-0x274(%ebp)
  801cba:	8b 75 0c             	mov    0xc(%ebp),%esi
		argv_store[i] = UTEMP2USTACK(string_store);
  801cbd:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801cc3:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801cc9:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
		strcpy(string_store, argv[i]);
  801ccc:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd3:	89 3c 24             	mov    %edi,(%esp)
  801cd6:	e8 8f ec ff ff       	call   80096a <strcpy>
		string_store += strlen(argv[i]) + 1;
  801cdb:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801cde:	89 04 24             	mov    %eax,(%esp)
  801ce1:	e8 3a ec ff ff       	call   800920 <strlen>
  801ce6:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801cea:	83 c3 01             	add    $0x1,%ebx
  801ced:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  801cf3:	7c c8                	jl     801cbd <spawn+0x1a9>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801cf5:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801cfb:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801d01:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801d08:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801d0e:	74 24                	je     801d34 <spawn+0x220>
  801d10:	c7 44 24 0c ac 34 80 	movl   $0x8034ac,0xc(%esp)
  801d17:	00 
  801d18:	c7 44 24 08 29 34 80 	movl   $0x803429,0x8(%esp)
  801d1f:	00 
  801d20:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  801d27:	00 
  801d28:	c7 04 24 3e 34 80 00 	movl   $0x80343e,(%esp)
  801d2f:	e8 94 e4 ff ff       	call   8001c8 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801d34:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801d3a:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801d3f:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801d45:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801d48:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  801d4e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801d54:	89 10                	mov    %edx,(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801d56:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801d5c:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801d61:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801d67:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801d6e:	00 
  801d6f:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801d76:	ee 
  801d77:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801d7d:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d81:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801d88:	00 
  801d89:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d90:	e8 d3 f2 ff ff       	call   801068 <sys_page_map>
  801d95:	89 c3                	mov    %eax,%ebx
  801d97:	85 c0                	test   %eax,%eax
  801d99:	78 1a                	js     801db5 <spawn+0x2a1>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801d9b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801da2:	00 
  801da3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801daa:	e8 5b f2 ff ff       	call   80100a <sys_page_unmap>
  801daf:	89 c3                	mov    %eax,%ebx
  801db1:	85 c0                	test   %eax,%eax
  801db3:	79 19                	jns    801dce <spawn+0x2ba>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  801db5:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801dbc:	00 
  801dbd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dc4:	e8 41 f2 ff ff       	call   80100a <sys_page_unmap>
  801dc9:	e9 46 03 00 00       	jmp    802114 <spawn+0x600>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801dce:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801dd4:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  801ddb:	00 
  801ddc:	0f 84 e3 01 00 00    	je     801fc5 <spawn+0x4b1>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801de2:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801de9:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
  801def:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801df6:	00 00 00 
	for (i = 0; i < elf->e_phnum; i++, ph++) {
               // cprintf("\nHello\n");
		if (ph->p_type != ELF_PROG_LOAD)
  801df9:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  801dff:	83 3a 01             	cmpl   $0x1,(%edx)
  801e02:	0f 85 9b 01 00 00    	jne    801fa3 <spawn+0x48f>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801e08:	8b 42 18             	mov    0x18(%edx),%eax
  801e0b:	83 e0 02             	and    $0x2,%eax
  801e0e:	83 f8 01             	cmp    $0x1,%eax
  801e11:	19 c0                	sbb    %eax,%eax
  801e13:	83 e0 fe             	and    $0xfffffffe,%eax
  801e16:	83 c0 07             	add    $0x7,%eax
  801e19:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
  801e1f:	8b 52 04             	mov    0x4(%edx),%edx
  801e22:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  801e28:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801e2e:	8b 58 10             	mov    0x10(%eax),%ebx
  801e31:	8b 50 14             	mov    0x14(%eax),%edx
  801e34:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
  801e3a:	8b 40 08             	mov    0x8(%eax),%eax
  801e3d:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  801e43:	25 ff 0f 00 00       	and    $0xfff,%eax
  801e48:	74 16                	je     801e60 <spawn+0x34c>
		va -= i;
  801e4a:	29 85 90 fd ff ff    	sub    %eax,-0x270(%ebp)
		memsz += i;
  801e50:	01 c2                	add    %eax,%edx
  801e52:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
		filesz += i;
  801e58:	01 c3                	add    %eax,%ebx
		fileoffset -= i;
  801e5a:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801e60:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  801e67:	0f 84 36 01 00 00    	je     801fa3 <spawn+0x48f>
  801e6d:	bf 00 00 00 00       	mov    $0x0,%edi
  801e72:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  801e77:	39 fb                	cmp    %edi,%ebx
  801e79:	77 31                	ja     801eac <spawn+0x398>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801e7b:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801e81:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e85:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  801e8b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801e8f:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801e95:	89 04 24             	mov    %eax,(%esp)
  801e98:	e8 29 f2 ff ff       	call   8010c6 <sys_page_alloc>
  801e9d:	85 c0                	test   %eax,%eax
  801e9f:	0f 89 ea 00 00 00    	jns    801f8f <spawn+0x47b>
  801ea5:	89 c3                	mov    %eax,%ebx
  801ea7:	e9 44 02 00 00       	jmp    8020f0 <spawn+0x5dc>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801eac:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801eb3:	00 
  801eb4:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801ebb:	00 
  801ebc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ec3:	e8 fe f1 ff ff       	call   8010c6 <sys_page_alloc>
  801ec8:	85 c0                	test   %eax,%eax
  801eca:	0f 88 16 02 00 00    	js     8020e6 <spawn+0x5d2>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801ed0:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  801ed6:	8d 04 16             	lea    (%esi,%edx,1),%eax
  801ed9:	89 44 24 04          	mov    %eax,0x4(%esp)
  801edd:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801ee3:	89 04 24             	mov    %eax,(%esp)
  801ee6:	e8 ea f3 ff ff       	call   8012d5 <seek>
  801eeb:	85 c0                	test   %eax,%eax
  801eed:	0f 88 f7 01 00 00    	js     8020ea <spawn+0x5d6>
				return r;
			if ((r = read(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801ef3:	89 d8                	mov    %ebx,%eax
  801ef5:	29 f8                	sub    %edi,%eax
  801ef7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801efc:	76 05                	jbe    801f03 <spawn+0x3ef>
  801efe:	b8 00 10 00 00       	mov    $0x1000,%eax
  801f03:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f07:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f0e:	00 
  801f0f:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  801f15:	89 14 24             	mov    %edx,(%esp)
  801f18:	e8 d1 f5 ff ff       	call   8014ee <read>
  801f1d:	85 c0                	test   %eax,%eax
  801f1f:	0f 88 c9 01 00 00    	js     8020ee <spawn+0x5da>
				return r;
			//cprintf("\nvirtual address----->%x\n",va+i);
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801f25:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801f2b:	89 44 24 10          	mov    %eax,0x10(%esp)
  801f2f:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  801f35:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f39:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  801f3f:	89 54 24 08          	mov    %edx,0x8(%esp)
  801f43:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f4a:	00 
  801f4b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f52:	e8 11 f1 ff ff       	call   801068 <sys_page_map>
  801f57:	85 c0                	test   %eax,%eax
  801f59:	79 20                	jns    801f7b <spawn+0x467>
				panic("spawn: sys_page_map data: %e", r);
  801f5b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f5f:	c7 44 24 08 4a 34 80 	movl   $0x80344a,0x8(%esp)
  801f66:	00 
  801f67:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  801f6e:	00 
  801f6f:	c7 04 24 3e 34 80 00 	movl   $0x80343e,(%esp)
  801f76:	e8 4d e2 ff ff       	call   8001c8 <_panic>
			sys_page_unmap(0, UTEMP);
  801f7b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f82:	00 
  801f83:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f8a:	e8 7b f0 ff ff       	call   80100a <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  801f8f:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801f95:	89 f7                	mov    %esi,%edi
  801f97:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  801f9d:	0f 87 d4 fe ff ff    	ja     801e77 <spawn+0x363>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801fa3:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  801faa:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801fb1:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  801fb7:	7e 0c                	jle    801fc5 <spawn+0x4b1>
  801fb9:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  801fc0:	e9 34 fe ff ff       	jmp    801df9 <spawn+0x2e5>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  801fc5:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801fcb:	89 04 24             	mov    %eax,(%esp)
  801fce:	e8 7b f6 ff ff       	call   80164e <close>
  801fd3:	bb 00 00 80 00       	mov    $0x800000,%ebx
duplicateSharepage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
        pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  801fd8:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
       
        if( 0 == pgDirEntry )
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  801fdd:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	// LAB 7: Your code here.
	uint8_t *addr;
	extern unsigned char end[];
	for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
                {    
			duplicateSharepage(child, VPN(addr));
  801fe2:	89 d8                	mov    %ebx,%eax
  801fe4:	c1 e8 0c             	shr    $0xc,%eax
duplicateSharepage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
        pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  801fe7:	89 c2                	mov    %eax,%edx
  801fe9:	c1 e2 0c             	shl    $0xc,%edx
  801fec:	89 d1                	mov    %edx,%ecx
  801fee:	c1 e9 16             	shr    $0x16,%ecx
  801ff1:	8b 0c 8e             	mov    (%esi,%ecx,4),%ecx
       
        if( 0 == pgDirEntry )
  801ff4:	85 c9                	test   %ecx,%ecx
  801ff6:	74 66                	je     80205e <spawn+0x54a>
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  801ff8:	8b 04 87             	mov    (%edi,%eax,4),%eax
  801ffb:	89 c1                	mov    %eax,%ecx
  801ffd:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
        //cprintf("Below %d",vpt[pn]);
                //if(perm!=0)  //commented nw.
                   // cprintf("perm bit %d",perm);
	//cprintf("\nInside Spawn setting share\n");
	if((perm & PTE_W) && (perm & PTE_SHARE))
  802003:	25 02 04 00 00       	and    $0x402,%eax
  802008:	3d 02 04 00 00       	cmp    $0x402,%eax
  80200d:	75 4f                	jne    80205e <spawn+0x54a>
	{
		if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_SHARE|(perm & PTE_USER))) < 0)
  80200f:	81 e1 07 0a 00 00    	and    $0xa07,%ecx
  802015:	80 cd 04             	or     $0x4,%ch
  802018:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80201c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802020:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802026:	89 44 24 08          	mov    %eax,0x8(%esp)
  80202a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80202e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802035:	e8 2e f0 ff ff       	call   801068 <sys_page_map>
  80203a:	85 c0                	test   %eax,%eax
  80203c:	79 20                	jns    80205e <spawn+0x54a>
                panic("sys_page_map: %e", r);
  80203e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802042:	c7 44 24 08 67 34 80 	movl   $0x803467,0x8(%esp)
  802049:	00 
  80204a:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  802051:	00 
  802052:	c7 04 24 3e 34 80 00 	movl   $0x80343e,(%esp)
  802059:	e8 6a e1 ff ff       	call   8001c8 <_panic>
copy_shared_pages(envid_t child)
{
	// LAB 7: Your code here.
	uint8_t *addr;
	extern unsigned char end[];
	for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
  80205e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802064:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80206a:	0f 85 72 ff ff ff    	jne    801fe2 <spawn+0x4ce>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802070:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802076:	89 44 24 04          	mov    %eax,0x4(%esp)
  80207a:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  802080:	89 14 24             	mov    %edx,(%esp)
  802083:	e8 c6 ee ff ff       	call   800f4e <sys_env_set_trapframe>
  802088:	85 c0                	test   %eax,%eax
  80208a:	79 20                	jns    8020ac <spawn+0x598>
		panic("sys_env_set_trapframe: %e", r);
  80208c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802090:	c7 44 24 08 78 34 80 	movl   $0x803478,0x8(%esp)
  802097:	00 
  802098:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  80209f:	00 
  8020a0:	c7 04 24 3e 34 80 00 	movl   $0x80343e,(%esp)
  8020a7:	e8 1c e1 ff ff       	call   8001c8 <_panic>
                   //    cprintf("\nHello below trpaframe%d\n",elf->e_phnum);
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  8020ac:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8020b3:	00 
  8020b4:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8020ba:	89 04 24             	mov    %eax,(%esp)
  8020bd:	e8 ea ee ff ff       	call   800fac <sys_env_set_status>
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	79 48                	jns    80210e <spawn+0x5fa>
		panic("sys_env_set_status: %e", r);
  8020c6:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020ca:	c7 44 24 08 92 34 80 	movl   $0x803492,0x8(%esp)
  8020d1:	00 
  8020d2:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  8020d9:	00 
  8020da:	c7 04 24 3e 34 80 00 	movl   $0x80343e,(%esp)
  8020e1:	e8 e2 e0 ff ff       	call   8001c8 <_panic>
  8020e6:	89 c3                	mov    %eax,%ebx
  8020e8:	eb 06                	jmp    8020f0 <spawn+0x5dc>
  8020ea:	89 c3                	mov    %eax,%ebx
  8020ec:	eb 02                	jmp    8020f0 <spawn+0x5dc>
  8020ee:	89 c3                	mov    %eax,%ebx

	return child;

error:
	sys_env_destroy(child);
  8020f0:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  8020f6:	89 14 24             	mov    %edx,(%esp)
  8020f9:	e8 8f f0 ff ff       	call   80118d <sys_env_destroy>
	close(fd);
  8020fe:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802104:	89 04 24             	mov    %eax,(%esp)
  802107:	e8 42 f5 ff ff       	call   80164e <close>
	return r;
  80210c:	eb 06                	jmp    802114 <spawn+0x600>
  80210e:	8b 9d 88 fd ff ff    	mov    -0x278(%ebp),%ebx
}
  802114:	89 d8                	mov    %ebx,%eax
  802116:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  80211c:	5b                   	pop    %ebx
  80211d:	5e                   	pop    %esi
  80211e:	5f                   	pop    %edi
  80211f:	5d                   	pop    %ebp
  802120:	c3                   	ret    

00802121 <spawnl>:

// Spawn, taking command-line arguments array directly on the stack.
int
spawnl(const char *prog, const char *arg0, ...)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
  802124:	83 ec 18             	sub    $0x18,%esp
	return spawn(prog, &arg0);
  802127:	8d 45 0c             	lea    0xc(%ebp),%eax
  80212a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212e:	8b 45 08             	mov    0x8(%ebp),%eax
  802131:	89 04 24             	mov    %eax,(%esp)
  802134:	e8 db f9 ff ff       	call   801b14 <spawn>
}
  802139:	c9                   	leave  
  80213a:	c3                   	ret    
  80213b:	00 00                	add    %al,(%eax)
  80213d:	00 00                	add    %al,(%eax)
	...

00802140 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802146:	c7 44 24 04 d4 34 80 	movl   $0x8034d4,0x4(%esp)
  80214d:	00 
  80214e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802151:	89 04 24             	mov    %eax,(%esp)
  802154:	e8 11 e8 ff ff       	call   80096a <strcpy>
	return 0;
}
  802159:	b8 00 00 00 00       	mov    $0x0,%eax
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	8b 40 0c             	mov    0xc(%eax),%eax
  80216c:	89 04 24             	mov    %eax,(%esp)
  80216f:	e8 9e 02 00 00       	call   802412 <nsipc_close>
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80217c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802183:	00 
  802184:	8b 45 10             	mov    0x10(%ebp),%eax
  802187:	89 44 24 08          	mov    %eax,0x8(%esp)
  80218b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802192:	8b 45 08             	mov    0x8(%ebp),%eax
  802195:	8b 40 0c             	mov    0xc(%eax),%eax
  802198:	89 04 24             	mov    %eax,(%esp)
  80219b:	e8 ae 02 00 00       	call   80244e <nsipc_send>
}
  8021a0:	c9                   	leave  
  8021a1:	c3                   	ret    

008021a2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
  8021a5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8021a8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8021af:	00 
  8021b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8021b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021be:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8021c4:	89 04 24             	mov    %eax,(%esp)
  8021c7:	e8 f5 02 00 00       	call   8024c1 <nsipc_recv>
}
  8021cc:	c9                   	leave  
  8021cd:	c3                   	ret    

008021ce <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8021ce:	55                   	push   %ebp
  8021cf:	89 e5                	mov    %esp,%ebp
  8021d1:	56                   	push   %esi
  8021d2:	53                   	push   %ebx
  8021d3:	83 ec 20             	sub    $0x20,%esp
  8021d6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8021d8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021db:	89 04 24             	mov    %eax,(%esp)
  8021de:	e8 38 f0 ff ff       	call   80121b <fd_alloc>
  8021e3:	89 c3                	mov    %eax,%ebx
  8021e5:	85 c0                	test   %eax,%eax
  8021e7:	78 21                	js     80220a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  8021e9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8021f0:	00 
  8021f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021ff:	e8 c2 ee ff ff       	call   8010c6 <sys_page_alloc>
  802204:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802206:	85 c0                	test   %eax,%eax
  802208:	79 0a                	jns    802214 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80220a:	89 34 24             	mov    %esi,(%esp)
  80220d:	e8 00 02 00 00       	call   802412 <nsipc_close>
		return r;
  802212:	eb 28                	jmp    80223c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802214:	8b 15 20 70 80 00    	mov    0x807020,%edx
  80221a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80221f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802222:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802229:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802232:	89 04 24             	mov    %eax,(%esp)
  802235:	e8 b6 ef ff ff       	call   8011f0 <fd2num>
  80223a:	89 c3                	mov    %eax,%ebx
}
  80223c:	89 d8                	mov    %ebx,%eax
  80223e:	83 c4 20             	add    $0x20,%esp
  802241:	5b                   	pop    %ebx
  802242:	5e                   	pop    %esi
  802243:	5d                   	pop    %ebp
  802244:	c3                   	ret    

00802245 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802245:	55                   	push   %ebp
  802246:	89 e5                	mov    %esp,%ebp
  802248:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80224b:	8b 45 10             	mov    0x10(%ebp),%eax
  80224e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802252:	8b 45 0c             	mov    0xc(%ebp),%eax
  802255:	89 44 24 04          	mov    %eax,0x4(%esp)
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	89 04 24             	mov    %eax,(%esp)
  80225f:	e8 62 01 00 00       	call   8023c6 <nsipc_socket>
  802264:	85 c0                	test   %eax,%eax
  802266:	78 05                	js     80226d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802268:	e8 61 ff ff ff       	call   8021ce <alloc_sockfd>
}
  80226d:	c9                   	leave  
  80226e:	66 90                	xchg   %ax,%ax
  802270:	c3                   	ret    

00802271 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802271:	55                   	push   %ebp
  802272:	89 e5                	mov    %esp,%ebp
  802274:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802277:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80227a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80227e:	89 04 24             	mov    %eax,(%esp)
  802281:	e8 07 f0 ff ff       	call   80128d <fd_lookup>
  802286:	85 c0                	test   %eax,%eax
  802288:	78 15                	js     80229f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80228a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80228d:	8b 0a                	mov    (%edx),%ecx
  80228f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802294:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  80229a:	75 03                	jne    80229f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80229c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  80229f:	c9                   	leave  
  8022a0:	c3                   	ret    

008022a1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8022a1:	55                   	push   %ebp
  8022a2:	89 e5                	mov    %esp,%ebp
  8022a4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	e8 c2 ff ff ff       	call   802271 <fd2sockid>
  8022af:	85 c0                	test   %eax,%eax
  8022b1:	78 0f                	js     8022c2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8022b3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022b6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022ba:	89 04 24             	mov    %eax,(%esp)
  8022bd:	e8 2e 01 00 00       	call   8023f0 <nsipc_listen>
}
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    

008022c4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
  8022c7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	e8 9f ff ff ff       	call   802271 <fd2sockid>
  8022d2:	85 c0                	test   %eax,%eax
  8022d4:	78 16                	js     8022ec <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8022d6:	8b 55 10             	mov    0x10(%ebp),%edx
  8022d9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022e4:	89 04 24             	mov    %eax,(%esp)
  8022e7:	e8 55 02 00 00       	call   802541 <nsipc_connect>
}
  8022ec:	c9                   	leave  
  8022ed:	c3                   	ret    

008022ee <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8022ee:	55                   	push   %ebp
  8022ef:	89 e5                	mov    %esp,%ebp
  8022f1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f7:	e8 75 ff ff ff       	call   802271 <fd2sockid>
  8022fc:	85 c0                	test   %eax,%eax
  8022fe:	78 0f                	js     80230f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802300:	8b 55 0c             	mov    0xc(%ebp),%edx
  802303:	89 54 24 04          	mov    %edx,0x4(%esp)
  802307:	89 04 24             	mov    %eax,(%esp)
  80230a:	e8 1d 01 00 00       	call   80242c <nsipc_shutdown>
}
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
  802314:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	e8 52 ff ff ff       	call   802271 <fd2sockid>
  80231f:	85 c0                	test   %eax,%eax
  802321:	78 16                	js     802339 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802323:	8b 55 10             	mov    0x10(%ebp),%edx
  802326:	89 54 24 08          	mov    %edx,0x8(%esp)
  80232a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802331:	89 04 24             	mov    %eax,(%esp)
  802334:	e8 47 02 00 00       	call   802580 <nsipc_bind>
}
  802339:	c9                   	leave  
  80233a:	c3                   	ret    

0080233b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80233b:	55                   	push   %ebp
  80233c:	89 e5                	mov    %esp,%ebp
  80233e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802341:	8b 45 08             	mov    0x8(%ebp),%eax
  802344:	e8 28 ff ff ff       	call   802271 <fd2sockid>
  802349:	85 c0                	test   %eax,%eax
  80234b:	78 1f                	js     80236c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80234d:	8b 55 10             	mov    0x10(%ebp),%edx
  802350:	89 54 24 08          	mov    %edx,0x8(%esp)
  802354:	8b 55 0c             	mov    0xc(%ebp),%edx
  802357:	89 54 24 04          	mov    %edx,0x4(%esp)
  80235b:	89 04 24             	mov    %eax,(%esp)
  80235e:	e8 5c 02 00 00       	call   8025bf <nsipc_accept>
  802363:	85 c0                	test   %eax,%eax
  802365:	78 05                	js     80236c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802367:	e8 62 fe ff ff       	call   8021ce <alloc_sockfd>
}
  80236c:	c9                   	leave  
  80236d:	8d 76 00             	lea    0x0(%esi),%esi
  802370:	c3                   	ret    
	...

00802380 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802380:	55                   	push   %ebp
  802381:	89 e5                	mov    %esp,%ebp
  802383:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802386:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  80238c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802393:	00 
  802394:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80239b:	00 
  80239c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023a0:	89 14 24             	mov    %edx,(%esp)
  8023a3:	e8 08 08 00 00       	call   802bb0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8023a8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023af:	00 
  8023b0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8023b7:	00 
  8023b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023bf:	e8 4e 08 00 00       	call   802c12 <ipc_recv>
}
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    

008023c6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8023c6:	55                   	push   %ebp
  8023c7:	89 e5                	mov    %esp,%ebp
  8023c9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8023d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8023dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8023df:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8023e4:	b8 09 00 00 00       	mov    $0x9,%eax
  8023e9:	e8 92 ff ff ff       	call   802380 <nsipc>
}
  8023ee:	c9                   	leave  
  8023ef:	c3                   	ret    

008023f0 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8023f0:	55                   	push   %ebp
  8023f1:	89 e5                	mov    %esp,%ebp
  8023f3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8023fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802401:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802406:	b8 06 00 00 00       	mov    $0x6,%eax
  80240b:	e8 70 ff ff ff       	call   802380 <nsipc>
}
  802410:	c9                   	leave  
  802411:	c3                   	ret    

00802412 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802412:	55                   	push   %ebp
  802413:	89 e5                	mov    %esp,%ebp
  802415:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802420:	b8 04 00 00 00       	mov    $0x4,%eax
  802425:	e8 56 ff ff ff       	call   802380 <nsipc>
}
  80242a:	c9                   	leave  
  80242b:	c3                   	ret    

0080242c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80242c:	55                   	push   %ebp
  80242d:	89 e5                	mov    %esp,%ebp
  80242f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802432:	8b 45 08             	mov    0x8(%ebp),%eax
  802435:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80243a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802442:	b8 03 00 00 00       	mov    $0x3,%eax
  802447:	e8 34 ff ff ff       	call   802380 <nsipc>
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
  802451:	53                   	push   %ebx
  802452:	83 ec 14             	sub    $0x14,%esp
  802455:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802458:	8b 45 08             	mov    0x8(%ebp),%eax
  80245b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802460:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802466:	7e 24                	jle    80248c <nsipc_send+0x3e>
  802468:	c7 44 24 0c e0 34 80 	movl   $0x8034e0,0xc(%esp)
  80246f:	00 
  802470:	c7 44 24 08 29 34 80 	movl   $0x803429,0x8(%esp)
  802477:	00 
  802478:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  80247f:	00 
  802480:	c7 04 24 ec 34 80 00 	movl   $0x8034ec,(%esp)
  802487:	e8 3c dd ff ff       	call   8001c8 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80248c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802490:	8b 45 0c             	mov    0xc(%ebp),%eax
  802493:	89 44 24 04          	mov    %eax,0x4(%esp)
  802497:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80249e:	e8 82 e6 ff ff       	call   800b25 <memmove>
	nsipcbuf.send.req_size = size;
  8024a3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8024a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ac:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8024b1:	b8 08 00 00 00       	mov    $0x8,%eax
  8024b6:	e8 c5 fe ff ff       	call   802380 <nsipc>
}
  8024bb:	83 c4 14             	add    $0x14,%esp
  8024be:	5b                   	pop    %ebx
  8024bf:	5d                   	pop    %ebp
  8024c0:	c3                   	ret    

008024c1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
  8024c4:	56                   	push   %esi
  8024c5:	53                   	push   %ebx
  8024c6:	83 ec 10             	sub    $0x10,%esp
  8024c9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8024cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024cf:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8024d4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8024da:	8b 45 14             	mov    0x14(%ebp),%eax
  8024dd:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8024e2:	b8 07 00 00 00       	mov    $0x7,%eax
  8024e7:	e8 94 fe ff ff       	call   802380 <nsipc>
  8024ec:	89 c3                	mov    %eax,%ebx
  8024ee:	85 c0                	test   %eax,%eax
  8024f0:	78 46                	js     802538 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8024f2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8024f7:	7f 04                	jg     8024fd <nsipc_recv+0x3c>
  8024f9:	39 c6                	cmp    %eax,%esi
  8024fb:	7d 24                	jge    802521 <nsipc_recv+0x60>
  8024fd:	c7 44 24 0c f8 34 80 	movl   $0x8034f8,0xc(%esp)
  802504:	00 
  802505:	c7 44 24 08 29 34 80 	movl   $0x803429,0x8(%esp)
  80250c:	00 
  80250d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802514:	00 
  802515:	c7 04 24 ec 34 80 00 	movl   $0x8034ec,(%esp)
  80251c:	e8 a7 dc ff ff       	call   8001c8 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802521:	89 44 24 08          	mov    %eax,0x8(%esp)
  802525:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80252c:	00 
  80252d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802530:	89 04 24             	mov    %eax,(%esp)
  802533:	e8 ed e5 ff ff       	call   800b25 <memmove>
	}

	return r;
}
  802538:	89 d8                	mov    %ebx,%eax
  80253a:	83 c4 10             	add    $0x10,%esp
  80253d:	5b                   	pop    %ebx
  80253e:	5e                   	pop    %esi
  80253f:	5d                   	pop    %ebp
  802540:	c3                   	ret    

00802541 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802541:	55                   	push   %ebp
  802542:	89 e5                	mov    %esp,%ebp
  802544:	53                   	push   %ebx
  802545:	83 ec 14             	sub    $0x14,%esp
  802548:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802553:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802557:	8b 45 0c             	mov    0xc(%ebp),%eax
  80255a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80255e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802565:	e8 bb e5 ff ff       	call   800b25 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80256a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802570:	b8 05 00 00 00       	mov    $0x5,%eax
  802575:	e8 06 fe ff ff       	call   802380 <nsipc>
}
  80257a:	83 c4 14             	add    $0x14,%esp
  80257d:	5b                   	pop    %ebx
  80257e:	5d                   	pop    %ebp
  80257f:	c3                   	ret    

00802580 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802580:	55                   	push   %ebp
  802581:	89 e5                	mov    %esp,%ebp
  802583:	53                   	push   %ebx
  802584:	83 ec 14             	sub    $0x14,%esp
  802587:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80258a:	8b 45 08             	mov    0x8(%ebp),%eax
  80258d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802592:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802596:	8b 45 0c             	mov    0xc(%ebp),%eax
  802599:	89 44 24 04          	mov    %eax,0x4(%esp)
  80259d:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8025a4:	e8 7c e5 ff ff       	call   800b25 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8025a9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8025af:	b8 02 00 00 00       	mov    $0x2,%eax
  8025b4:	e8 c7 fd ff ff       	call   802380 <nsipc>
}
  8025b9:	83 c4 14             	add    $0x14,%esp
  8025bc:	5b                   	pop    %ebx
  8025bd:	5d                   	pop    %ebp
  8025be:	c3                   	ret    

008025bf <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8025bf:	55                   	push   %ebp
  8025c0:	89 e5                	mov    %esp,%ebp
  8025c2:	83 ec 18             	sub    $0x18,%esp
  8025c5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8025c8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8025cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ce:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8025d3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025d8:	e8 a3 fd ff ff       	call   802380 <nsipc>
  8025dd:	89 c3                	mov    %eax,%ebx
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	78 25                	js     802608 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8025e3:	be 10 60 80 00       	mov    $0x806010,%esi
  8025e8:	8b 06                	mov    (%esi),%eax
  8025ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025ee:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8025f5:	00 
  8025f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025f9:	89 04 24             	mov    %eax,(%esp)
  8025fc:	e8 24 e5 ff ff       	call   800b25 <memmove>
		*addrlen = ret->ret_addrlen;
  802601:	8b 16                	mov    (%esi),%edx
  802603:	8b 45 10             	mov    0x10(%ebp),%eax
  802606:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802608:	89 d8                	mov    %ebx,%eax
  80260a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80260d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802610:	89 ec                	mov    %ebp,%esp
  802612:	5d                   	pop    %ebp
  802613:	c3                   	ret    
	...

00802620 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802620:	55                   	push   %ebp
  802621:	89 e5                	mov    %esp,%ebp
  802623:	83 ec 18             	sub    $0x18,%esp
  802626:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802629:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80262c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80262f:	8b 45 08             	mov    0x8(%ebp),%eax
  802632:	89 04 24             	mov    %eax,(%esp)
  802635:	e8 c6 eb ff ff       	call   801200 <fd2data>
  80263a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80263c:	c7 44 24 04 0d 35 80 	movl   $0x80350d,0x4(%esp)
  802643:	00 
  802644:	89 34 24             	mov    %esi,(%esp)
  802647:	e8 1e e3 ff ff       	call   80096a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80264c:	8b 43 04             	mov    0x4(%ebx),%eax
  80264f:	2b 03                	sub    (%ebx),%eax
  802651:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802657:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80265e:	00 00 00 
	stat->st_dev = &devpipe;
  802661:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  802668:	70 80 00 
	return 0;
}
  80266b:	b8 00 00 00 00       	mov    $0x0,%eax
  802670:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802673:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802676:	89 ec                	mov    %ebp,%esp
  802678:	5d                   	pop    %ebp
  802679:	c3                   	ret    

0080267a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80267a:	55                   	push   %ebp
  80267b:	89 e5                	mov    %esp,%ebp
  80267d:	53                   	push   %ebx
  80267e:	83 ec 14             	sub    $0x14,%esp
  802681:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802684:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802688:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80268f:	e8 76 e9 ff ff       	call   80100a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802694:	89 1c 24             	mov    %ebx,(%esp)
  802697:	e8 64 eb ff ff       	call   801200 <fd2data>
  80269c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a7:	e8 5e e9 ff ff       	call   80100a <sys_page_unmap>
}
  8026ac:	83 c4 14             	add    $0x14,%esp
  8026af:	5b                   	pop    %ebx
  8026b0:	5d                   	pop    %ebp
  8026b1:	c3                   	ret    

008026b2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8026b2:	55                   	push   %ebp
  8026b3:	89 e5                	mov    %esp,%ebp
  8026b5:	57                   	push   %edi
  8026b6:	56                   	push   %esi
  8026b7:	53                   	push   %ebx
  8026b8:	83 ec 2c             	sub    $0x2c,%esp
  8026bb:	89 c7                	mov    %eax,%edi
  8026bd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8026c0:	a1 74 70 80 00       	mov    0x807074,%eax
  8026c5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8026c8:	89 3c 24             	mov    %edi,(%esp)
  8026cb:	e8 a8 05 00 00       	call   802c78 <pageref>
  8026d0:	89 c6                	mov    %eax,%esi
  8026d2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026d5:	89 04 24             	mov    %eax,(%esp)
  8026d8:	e8 9b 05 00 00       	call   802c78 <pageref>
  8026dd:	39 c6                	cmp    %eax,%esi
  8026df:	0f 94 c0             	sete   %al
  8026e2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  8026e5:	8b 15 74 70 80 00    	mov    0x807074,%edx
  8026eb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8026ee:	39 cb                	cmp    %ecx,%ebx
  8026f0:	75 08                	jne    8026fa <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  8026f2:	83 c4 2c             	add    $0x2c,%esp
  8026f5:	5b                   	pop    %ebx
  8026f6:	5e                   	pop    %esi
  8026f7:	5f                   	pop    %edi
  8026f8:	5d                   	pop    %ebp
  8026f9:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8026fa:	83 f8 01             	cmp    $0x1,%eax
  8026fd:	75 c1                	jne    8026c0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  8026ff:	8b 52 58             	mov    0x58(%edx),%edx
  802702:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802706:	89 54 24 08          	mov    %edx,0x8(%esp)
  80270a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80270e:	c7 04 24 14 35 80 00 	movl   $0x803514,(%esp)
  802715:	e8 73 db ff ff       	call   80028d <cprintf>
  80271a:	eb a4                	jmp    8026c0 <_pipeisclosed+0xe>

0080271c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80271c:	55                   	push   %ebp
  80271d:	89 e5                	mov    %esp,%ebp
  80271f:	57                   	push   %edi
  802720:	56                   	push   %esi
  802721:	53                   	push   %ebx
  802722:	83 ec 1c             	sub    $0x1c,%esp
  802725:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802728:	89 34 24             	mov    %esi,(%esp)
  80272b:	e8 d0 ea ff ff       	call   801200 <fd2data>
  802730:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802732:	bf 00 00 00 00       	mov    $0x0,%edi
  802737:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80273b:	75 54                	jne    802791 <devpipe_write+0x75>
  80273d:	eb 60                	jmp    80279f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80273f:	89 da                	mov    %ebx,%edx
  802741:	89 f0                	mov    %esi,%eax
  802743:	e8 6a ff ff ff       	call   8026b2 <_pipeisclosed>
  802748:	85 c0                	test   %eax,%eax
  80274a:	74 07                	je     802753 <devpipe_write+0x37>
  80274c:	b8 00 00 00 00       	mov    $0x0,%eax
  802751:	eb 53                	jmp    8027a6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802753:	90                   	nop
  802754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802758:	e8 c8 e9 ff ff       	call   801125 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80275d:	8b 43 04             	mov    0x4(%ebx),%eax
  802760:	8b 13                	mov    (%ebx),%edx
  802762:	83 c2 20             	add    $0x20,%edx
  802765:	39 d0                	cmp    %edx,%eax
  802767:	73 d6                	jae    80273f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802769:	89 c2                	mov    %eax,%edx
  80276b:	c1 fa 1f             	sar    $0x1f,%edx
  80276e:	c1 ea 1b             	shr    $0x1b,%edx
  802771:	01 d0                	add    %edx,%eax
  802773:	83 e0 1f             	and    $0x1f,%eax
  802776:	29 d0                	sub    %edx,%eax
  802778:	89 c2                	mov    %eax,%edx
  80277a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80277d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802781:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802785:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802789:	83 c7 01             	add    $0x1,%edi
  80278c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80278f:	76 13                	jbe    8027a4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802791:	8b 43 04             	mov    0x4(%ebx),%eax
  802794:	8b 13                	mov    (%ebx),%edx
  802796:	83 c2 20             	add    $0x20,%edx
  802799:	39 d0                	cmp    %edx,%eax
  80279b:	73 a2                	jae    80273f <devpipe_write+0x23>
  80279d:	eb ca                	jmp    802769 <devpipe_write+0x4d>
  80279f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8027a4:	89 f8                	mov    %edi,%eax
}
  8027a6:	83 c4 1c             	add    $0x1c,%esp
  8027a9:	5b                   	pop    %ebx
  8027aa:	5e                   	pop    %esi
  8027ab:	5f                   	pop    %edi
  8027ac:	5d                   	pop    %ebp
  8027ad:	c3                   	ret    

008027ae <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
  8027b1:	83 ec 28             	sub    $0x28,%esp
  8027b4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8027b7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8027ba:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8027bd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8027c0:	89 3c 24             	mov    %edi,(%esp)
  8027c3:	e8 38 ea ff ff       	call   801200 <fd2data>
  8027c8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027ca:	be 00 00 00 00       	mov    $0x0,%esi
  8027cf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027d3:	75 4c                	jne    802821 <devpipe_read+0x73>
  8027d5:	eb 5b                	jmp    802832 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8027d7:	89 f0                	mov    %esi,%eax
  8027d9:	eb 5e                	jmp    802839 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8027db:	89 da                	mov    %ebx,%edx
  8027dd:	89 f8                	mov    %edi,%eax
  8027df:	90                   	nop
  8027e0:	e8 cd fe ff ff       	call   8026b2 <_pipeisclosed>
  8027e5:	85 c0                	test   %eax,%eax
  8027e7:	74 07                	je     8027f0 <devpipe_read+0x42>
  8027e9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ee:	eb 49                	jmp    802839 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8027f0:	e8 30 e9 ff ff       	call   801125 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8027f5:	8b 03                	mov    (%ebx),%eax
  8027f7:	3b 43 04             	cmp    0x4(%ebx),%eax
  8027fa:	74 df                	je     8027db <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8027fc:	89 c2                	mov    %eax,%edx
  8027fe:	c1 fa 1f             	sar    $0x1f,%edx
  802801:	c1 ea 1b             	shr    $0x1b,%edx
  802804:	01 d0                	add    %edx,%eax
  802806:	83 e0 1f             	and    $0x1f,%eax
  802809:	29 d0                	sub    %edx,%eax
  80280b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802810:	8b 55 0c             	mov    0xc(%ebp),%edx
  802813:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802816:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802819:	83 c6 01             	add    $0x1,%esi
  80281c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80281f:	76 16                	jbe    802837 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802821:	8b 03                	mov    (%ebx),%eax
  802823:	3b 43 04             	cmp    0x4(%ebx),%eax
  802826:	75 d4                	jne    8027fc <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802828:	85 f6                	test   %esi,%esi
  80282a:	75 ab                	jne    8027d7 <devpipe_read+0x29>
  80282c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802830:	eb a9                	jmp    8027db <devpipe_read+0x2d>
  802832:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802837:	89 f0                	mov    %esi,%eax
}
  802839:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80283c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80283f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802842:	89 ec                	mov    %ebp,%esp
  802844:	5d                   	pop    %ebp
  802845:	c3                   	ret    

00802846 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802846:	55                   	push   %ebp
  802847:	89 e5                	mov    %esp,%ebp
  802849:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80284c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80284f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802853:	8b 45 08             	mov    0x8(%ebp),%eax
  802856:	89 04 24             	mov    %eax,(%esp)
  802859:	e8 2f ea ff ff       	call   80128d <fd_lookup>
  80285e:	85 c0                	test   %eax,%eax
  802860:	78 15                	js     802877 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802862:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802865:	89 04 24             	mov    %eax,(%esp)
  802868:	e8 93 e9 ff ff       	call   801200 <fd2data>
	return _pipeisclosed(fd, p);
  80286d:	89 c2                	mov    %eax,%edx
  80286f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802872:	e8 3b fe ff ff       	call   8026b2 <_pipeisclosed>
}
  802877:	c9                   	leave  
  802878:	c3                   	ret    

00802879 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802879:	55                   	push   %ebp
  80287a:	89 e5                	mov    %esp,%ebp
  80287c:	83 ec 48             	sub    $0x48,%esp
  80287f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802882:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802885:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802888:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80288b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80288e:	89 04 24             	mov    %eax,(%esp)
  802891:	e8 85 e9 ff ff       	call   80121b <fd_alloc>
  802896:	89 c3                	mov    %eax,%ebx
  802898:	85 c0                	test   %eax,%eax
  80289a:	0f 88 42 01 00 00    	js     8029e2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028a0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028a7:	00 
  8028a8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028b6:	e8 0b e8 ff ff       	call   8010c6 <sys_page_alloc>
  8028bb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8028bd:	85 c0                	test   %eax,%eax
  8028bf:	0f 88 1d 01 00 00    	js     8029e2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8028c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8028c8:	89 04 24             	mov    %eax,(%esp)
  8028cb:	e8 4b e9 ff ff       	call   80121b <fd_alloc>
  8028d0:	89 c3                	mov    %eax,%ebx
  8028d2:	85 c0                	test   %eax,%eax
  8028d4:	0f 88 f5 00 00 00    	js     8029cf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028da:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028e1:	00 
  8028e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028f0:	e8 d1 e7 ff ff       	call   8010c6 <sys_page_alloc>
  8028f5:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8028f7:	85 c0                	test   %eax,%eax
  8028f9:	0f 88 d0 00 00 00    	js     8029cf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8028ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802902:	89 04 24             	mov    %eax,(%esp)
  802905:	e8 f6 e8 ff ff       	call   801200 <fd2data>
  80290a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80290c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802913:	00 
  802914:	89 44 24 04          	mov    %eax,0x4(%esp)
  802918:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80291f:	e8 a2 e7 ff ff       	call   8010c6 <sys_page_alloc>
  802924:	89 c3                	mov    %eax,%ebx
  802926:	85 c0                	test   %eax,%eax
  802928:	0f 88 8e 00 00 00    	js     8029bc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80292e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802931:	89 04 24             	mov    %eax,(%esp)
  802934:	e8 c7 e8 ff ff       	call   801200 <fd2data>
  802939:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802940:	00 
  802941:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802945:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80294c:	00 
  80294d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802951:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802958:	e8 0b e7 ff ff       	call   801068 <sys_page_map>
  80295d:	89 c3                	mov    %eax,%ebx
  80295f:	85 c0                	test   %eax,%eax
  802961:	78 49                	js     8029ac <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802963:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  802968:	8b 08                	mov    (%eax),%ecx
  80296a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80296d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80296f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802972:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802979:	8b 10                	mov    (%eax),%edx
  80297b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80297e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802980:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802983:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80298a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80298d:	89 04 24             	mov    %eax,(%esp)
  802990:	e8 5b e8 ff ff       	call   8011f0 <fd2num>
  802995:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802997:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80299a:	89 04 24             	mov    %eax,(%esp)
  80299d:	e8 4e e8 ff ff       	call   8011f0 <fd2num>
  8029a2:	89 47 04             	mov    %eax,0x4(%edi)
  8029a5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8029aa:	eb 36                	jmp    8029e2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8029ac:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029b7:	e8 4e e6 ff ff       	call   80100a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8029bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029ca:	e8 3b e6 ff ff       	call   80100a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8029cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029dd:	e8 28 e6 ff ff       	call   80100a <sys_page_unmap>
    err:
	return r;
}
  8029e2:	89 d8                	mov    %ebx,%eax
  8029e4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8029e7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8029ea:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8029ed:	89 ec                	mov    %ebp,%esp
  8029ef:	5d                   	pop    %ebp
  8029f0:	c3                   	ret    
	...

00802a00 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802a00:	55                   	push   %ebp
  802a01:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802a03:	b8 00 00 00 00       	mov    $0x0,%eax
  802a08:	5d                   	pop    %ebp
  802a09:	c3                   	ret    

00802a0a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802a0a:	55                   	push   %ebp
  802a0b:	89 e5                	mov    %esp,%ebp
  802a0d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802a10:	c7 44 24 04 2c 35 80 	movl   $0x80352c,0x4(%esp)
  802a17:	00 
  802a18:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a1b:	89 04 24             	mov    %eax,(%esp)
  802a1e:	e8 47 df ff ff       	call   80096a <strcpy>
	return 0;
}
  802a23:	b8 00 00 00 00       	mov    $0x0,%eax
  802a28:	c9                   	leave  
  802a29:	c3                   	ret    

00802a2a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802a2a:	55                   	push   %ebp
  802a2b:	89 e5                	mov    %esp,%ebp
  802a2d:	57                   	push   %edi
  802a2e:	56                   	push   %esi
  802a2f:	53                   	push   %ebx
  802a30:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a36:	b8 00 00 00 00       	mov    $0x0,%eax
  802a3b:	be 00 00 00 00       	mov    $0x0,%esi
  802a40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a44:	74 3f                	je     802a85 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802a46:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802a4c:	8b 55 10             	mov    0x10(%ebp),%edx
  802a4f:	29 c2                	sub    %eax,%edx
  802a51:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802a53:	83 fa 7f             	cmp    $0x7f,%edx
  802a56:	76 05                	jbe    802a5d <devcons_write+0x33>
  802a58:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802a5d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a61:	03 45 0c             	add    0xc(%ebp),%eax
  802a64:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a68:	89 3c 24             	mov    %edi,(%esp)
  802a6b:	e8 b5 e0 ff ff       	call   800b25 <memmove>
		sys_cputs(buf, m);
  802a70:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a74:	89 3c 24             	mov    %edi,(%esp)
  802a77:	e8 e4 e2 ff ff       	call   800d60 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a7c:	01 de                	add    %ebx,%esi
  802a7e:	89 f0                	mov    %esi,%eax
  802a80:	3b 75 10             	cmp    0x10(%ebp),%esi
  802a83:	72 c7                	jb     802a4c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802a85:	89 f0                	mov    %esi,%eax
  802a87:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802a8d:	5b                   	pop    %ebx
  802a8e:	5e                   	pop    %esi
  802a8f:	5f                   	pop    %edi
  802a90:	5d                   	pop    %ebp
  802a91:	c3                   	ret    

00802a92 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802a92:	55                   	push   %ebp
  802a93:	89 e5                	mov    %esp,%ebp
  802a95:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802a98:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802a9e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802aa5:	00 
  802aa6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802aa9:	89 04 24             	mov    %eax,(%esp)
  802aac:	e8 af e2 ff ff       	call   800d60 <sys_cputs>
}
  802ab1:	c9                   	leave  
  802ab2:	c3                   	ret    

00802ab3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802ab3:	55                   	push   %ebp
  802ab4:	89 e5                	mov    %esp,%ebp
  802ab6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802ab9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802abd:	75 07                	jne    802ac6 <devcons_read+0x13>
  802abf:	eb 28                	jmp    802ae9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802ac1:	e8 5f e6 ff ff       	call   801125 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802ac6:	66 90                	xchg   %ax,%ax
  802ac8:	e8 5f e2 ff ff       	call   800d2c <sys_cgetc>
  802acd:	85 c0                	test   %eax,%eax
  802acf:	90                   	nop
  802ad0:	74 ef                	je     802ac1 <devcons_read+0xe>
  802ad2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802ad4:	85 c0                	test   %eax,%eax
  802ad6:	78 16                	js     802aee <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802ad8:	83 f8 04             	cmp    $0x4,%eax
  802adb:	74 0c                	je     802ae9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802add:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ae0:	88 10                	mov    %dl,(%eax)
  802ae2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802ae7:	eb 05                	jmp    802aee <devcons_read+0x3b>
  802ae9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802aee:	c9                   	leave  
  802aef:	c3                   	ret    

00802af0 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802af0:	55                   	push   %ebp
  802af1:	89 e5                	mov    %esp,%ebp
  802af3:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802af6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802af9:	89 04 24             	mov    %eax,(%esp)
  802afc:	e8 1a e7 ff ff       	call   80121b <fd_alloc>
  802b01:	85 c0                	test   %eax,%eax
  802b03:	78 3f                	js     802b44 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802b05:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b0c:	00 
  802b0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b10:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b14:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b1b:	e8 a6 e5 ff ff       	call   8010c6 <sys_page_alloc>
  802b20:	85 c0                	test   %eax,%eax
  802b22:	78 20                	js     802b44 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802b24:	8b 15 58 70 80 00    	mov    0x807058,%edx
  802b2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3c:	89 04 24             	mov    %eax,(%esp)
  802b3f:	e8 ac e6 ff ff       	call   8011f0 <fd2num>
}
  802b44:	c9                   	leave  
  802b45:	c3                   	ret    

00802b46 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802b46:	55                   	push   %ebp
  802b47:	89 e5                	mov    %esp,%ebp
  802b49:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b4c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	89 04 24             	mov    %eax,(%esp)
  802b59:	e8 2f e7 ff ff       	call   80128d <fd_lookup>
  802b5e:	85 c0                	test   %eax,%eax
  802b60:	78 11                	js     802b73 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802b62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b65:	8b 00                	mov    (%eax),%eax
  802b67:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  802b6d:	0f 94 c0             	sete   %al
  802b70:	0f b6 c0             	movzbl %al,%eax
}
  802b73:	c9                   	leave  
  802b74:	c3                   	ret    

00802b75 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802b75:	55                   	push   %ebp
  802b76:	89 e5                	mov    %esp,%ebp
  802b78:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802b7b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802b82:	00 
  802b83:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802b86:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b8a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b91:	e8 58 e9 ff ff       	call   8014ee <read>
	if (r < 0)
  802b96:	85 c0                	test   %eax,%eax
  802b98:	78 0f                	js     802ba9 <getchar+0x34>
		return r;
	if (r < 1)
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	7f 07                	jg     802ba5 <getchar+0x30>
  802b9e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802ba3:	eb 04                	jmp    802ba9 <getchar+0x34>
		return -E_EOF;
	return c;
  802ba5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802ba9:	c9                   	leave  
  802baa:	c3                   	ret    
  802bab:	00 00                	add    %al,(%eax)
  802bad:	00 00                	add    %al,(%eax)
	...

00802bb0 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802bb0:	55                   	push   %ebp
  802bb1:	89 e5                	mov    %esp,%ebp
  802bb3:	57                   	push   %edi
  802bb4:	56                   	push   %esi
  802bb5:	53                   	push   %ebx
  802bb6:	83 ec 1c             	sub    $0x1c,%esp
  802bb9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802bbc:	8b 75 0c             	mov    0xc(%ebp),%esi
  802bbf:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  802bc2:	8b 45 14             	mov    0x14(%ebp),%eax
  802bc5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bc9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802bcd:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bd1:	89 1c 24             	mov    %ebx,(%esp)
  802bd4:	e8 df e2 ff ff       	call   800eb8 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  802bd9:	85 c0                	test   %eax,%eax
  802bdb:	79 21                	jns    802bfe <ipc_send+0x4e>
  802bdd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802be0:	74 1c                	je     802bfe <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  802be2:	c7 44 24 08 38 35 80 	movl   $0x803538,0x8(%esp)
  802be9:	00 
  802bea:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  802bf1:	00 
  802bf2:	c7 04 24 4a 35 80 00 	movl   $0x80354a,(%esp)
  802bf9:	e8 ca d5 ff ff       	call   8001c8 <_panic>
          else if(r==-E_IPC_NOT_RECV)
  802bfe:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802c01:	75 07                	jne    802c0a <ipc_send+0x5a>
           sys_yield();
  802c03:	e8 1d e5 ff ff       	call   801125 <sys_yield>
          else
            break;
        }
  802c08:	eb b8                	jmp    802bc2 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  802c0a:	83 c4 1c             	add    $0x1c,%esp
  802c0d:	5b                   	pop    %ebx
  802c0e:	5e                   	pop    %esi
  802c0f:	5f                   	pop    %edi
  802c10:	5d                   	pop    %ebp
  802c11:	c3                   	ret    

00802c12 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c12:	55                   	push   %ebp
  802c13:	89 e5                	mov    %esp,%ebp
  802c15:	83 ec 18             	sub    $0x18,%esp
  802c18:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802c1b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802c1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802c21:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  802c24:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c27:	89 04 24             	mov    %eax,(%esp)
  802c2a:	e8 2c e2 ff ff       	call   800e5b <sys_ipc_recv>
        if(r<0)
  802c2f:	85 c0                	test   %eax,%eax
  802c31:	79 17                	jns    802c4a <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  802c33:	85 db                	test   %ebx,%ebx
  802c35:	74 06                	je     802c3d <ipc_recv+0x2b>
               *from_env_store =0;
  802c37:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  802c3d:	85 f6                	test   %esi,%esi
  802c3f:	90                   	nop
  802c40:	74 2c                	je     802c6e <ipc_recv+0x5c>
              *perm_store=0;
  802c42:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802c48:	eb 24                	jmp    802c6e <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  802c4a:	85 db                	test   %ebx,%ebx
  802c4c:	74 0a                	je     802c58 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  802c4e:	a1 74 70 80 00       	mov    0x807074,%eax
  802c53:	8b 40 74             	mov    0x74(%eax),%eax
  802c56:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  802c58:	85 f6                	test   %esi,%esi
  802c5a:	74 0a                	je     802c66 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  802c5c:	a1 74 70 80 00       	mov    0x807074,%eax
  802c61:	8b 40 78             	mov    0x78(%eax),%eax
  802c64:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  802c66:	a1 74 70 80 00       	mov    0x807074,%eax
  802c6b:	8b 40 70             	mov    0x70(%eax),%eax
}
  802c6e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802c71:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802c74:	89 ec                	mov    %ebp,%esp
  802c76:	5d                   	pop    %ebp
  802c77:	c3                   	ret    

00802c78 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802c78:	55                   	push   %ebp
  802c79:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7e:	89 c2                	mov    %eax,%edx
  802c80:	c1 ea 16             	shr    $0x16,%edx
  802c83:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802c8a:	f6 c2 01             	test   $0x1,%dl
  802c8d:	74 26                	je     802cb5 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802c8f:	c1 e8 0c             	shr    $0xc,%eax
  802c92:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802c99:	a8 01                	test   $0x1,%al
  802c9b:	74 18                	je     802cb5 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802c9d:	c1 e8 0c             	shr    $0xc,%eax
  802ca0:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802ca3:	c1 e2 02             	shl    $0x2,%edx
  802ca6:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802cab:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802cb0:	0f b7 c0             	movzwl %ax,%eax
  802cb3:	eb 05                	jmp    802cba <pageref+0x42>
  802cb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cba:	5d                   	pop    %ebp
  802cbb:	c3                   	ret    
  802cbc:	00 00                	add    %al,(%eax)
	...

00802cc0 <__udivdi3>:
  802cc0:	55                   	push   %ebp
  802cc1:	89 e5                	mov    %esp,%ebp
  802cc3:	57                   	push   %edi
  802cc4:	56                   	push   %esi
  802cc5:	83 ec 10             	sub    $0x10,%esp
  802cc8:	8b 45 14             	mov    0x14(%ebp),%eax
  802ccb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cce:	8b 75 10             	mov    0x10(%ebp),%esi
  802cd1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802cd4:	85 c0                	test   %eax,%eax
  802cd6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802cd9:	75 35                	jne    802d10 <__udivdi3+0x50>
  802cdb:	39 fe                	cmp    %edi,%esi
  802cdd:	77 61                	ja     802d40 <__udivdi3+0x80>
  802cdf:	85 f6                	test   %esi,%esi
  802ce1:	75 0b                	jne    802cee <__udivdi3+0x2e>
  802ce3:	b8 01 00 00 00       	mov    $0x1,%eax
  802ce8:	31 d2                	xor    %edx,%edx
  802cea:	f7 f6                	div    %esi
  802cec:	89 c6                	mov    %eax,%esi
  802cee:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802cf1:	31 d2                	xor    %edx,%edx
  802cf3:	89 f8                	mov    %edi,%eax
  802cf5:	f7 f6                	div    %esi
  802cf7:	89 c7                	mov    %eax,%edi
  802cf9:	89 c8                	mov    %ecx,%eax
  802cfb:	f7 f6                	div    %esi
  802cfd:	89 c1                	mov    %eax,%ecx
  802cff:	89 fa                	mov    %edi,%edx
  802d01:	89 c8                	mov    %ecx,%eax
  802d03:	83 c4 10             	add    $0x10,%esp
  802d06:	5e                   	pop    %esi
  802d07:	5f                   	pop    %edi
  802d08:	5d                   	pop    %ebp
  802d09:	c3                   	ret    
  802d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d10:	39 f8                	cmp    %edi,%eax
  802d12:	77 1c                	ja     802d30 <__udivdi3+0x70>
  802d14:	0f bd d0             	bsr    %eax,%edx
  802d17:	83 f2 1f             	xor    $0x1f,%edx
  802d1a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d1d:	75 39                	jne    802d58 <__udivdi3+0x98>
  802d1f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802d22:	0f 86 a0 00 00 00    	jbe    802dc8 <__udivdi3+0x108>
  802d28:	39 f8                	cmp    %edi,%eax
  802d2a:	0f 82 98 00 00 00    	jb     802dc8 <__udivdi3+0x108>
  802d30:	31 ff                	xor    %edi,%edi
  802d32:	31 c9                	xor    %ecx,%ecx
  802d34:	89 c8                	mov    %ecx,%eax
  802d36:	89 fa                	mov    %edi,%edx
  802d38:	83 c4 10             	add    $0x10,%esp
  802d3b:	5e                   	pop    %esi
  802d3c:	5f                   	pop    %edi
  802d3d:	5d                   	pop    %ebp
  802d3e:	c3                   	ret    
  802d3f:	90                   	nop
  802d40:	89 d1                	mov    %edx,%ecx
  802d42:	89 fa                	mov    %edi,%edx
  802d44:	89 c8                	mov    %ecx,%eax
  802d46:	31 ff                	xor    %edi,%edi
  802d48:	f7 f6                	div    %esi
  802d4a:	89 c1                	mov    %eax,%ecx
  802d4c:	89 fa                	mov    %edi,%edx
  802d4e:	89 c8                	mov    %ecx,%eax
  802d50:	83 c4 10             	add    $0x10,%esp
  802d53:	5e                   	pop    %esi
  802d54:	5f                   	pop    %edi
  802d55:	5d                   	pop    %ebp
  802d56:	c3                   	ret    
  802d57:	90                   	nop
  802d58:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d5c:	89 f2                	mov    %esi,%edx
  802d5e:	d3 e0                	shl    %cl,%eax
  802d60:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d63:	b8 20 00 00 00       	mov    $0x20,%eax
  802d68:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802d6b:	89 c1                	mov    %eax,%ecx
  802d6d:	d3 ea                	shr    %cl,%edx
  802d6f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d73:	0b 55 ec             	or     -0x14(%ebp),%edx
  802d76:	d3 e6                	shl    %cl,%esi
  802d78:	89 c1                	mov    %eax,%ecx
  802d7a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802d7d:	89 fe                	mov    %edi,%esi
  802d7f:	d3 ee                	shr    %cl,%esi
  802d81:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d85:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d88:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d8b:	d3 e7                	shl    %cl,%edi
  802d8d:	89 c1                	mov    %eax,%ecx
  802d8f:	d3 ea                	shr    %cl,%edx
  802d91:	09 d7                	or     %edx,%edi
  802d93:	89 f2                	mov    %esi,%edx
  802d95:	89 f8                	mov    %edi,%eax
  802d97:	f7 75 ec             	divl   -0x14(%ebp)
  802d9a:	89 d6                	mov    %edx,%esi
  802d9c:	89 c7                	mov    %eax,%edi
  802d9e:	f7 65 e8             	mull   -0x18(%ebp)
  802da1:	39 d6                	cmp    %edx,%esi
  802da3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802da6:	72 30                	jb     802dd8 <__udivdi3+0x118>
  802da8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dab:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802daf:	d3 e2                	shl    %cl,%edx
  802db1:	39 c2                	cmp    %eax,%edx
  802db3:	73 05                	jae    802dba <__udivdi3+0xfa>
  802db5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802db8:	74 1e                	je     802dd8 <__udivdi3+0x118>
  802dba:	89 f9                	mov    %edi,%ecx
  802dbc:	31 ff                	xor    %edi,%edi
  802dbe:	e9 71 ff ff ff       	jmp    802d34 <__udivdi3+0x74>
  802dc3:	90                   	nop
  802dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802dc8:	31 ff                	xor    %edi,%edi
  802dca:	b9 01 00 00 00       	mov    $0x1,%ecx
  802dcf:	e9 60 ff ff ff       	jmp    802d34 <__udivdi3+0x74>
  802dd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802dd8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802ddb:	31 ff                	xor    %edi,%edi
  802ddd:	89 c8                	mov    %ecx,%eax
  802ddf:	89 fa                	mov    %edi,%edx
  802de1:	83 c4 10             	add    $0x10,%esp
  802de4:	5e                   	pop    %esi
  802de5:	5f                   	pop    %edi
  802de6:	5d                   	pop    %ebp
  802de7:	c3                   	ret    
	...

00802df0 <__umoddi3>:
  802df0:	55                   	push   %ebp
  802df1:	89 e5                	mov    %esp,%ebp
  802df3:	57                   	push   %edi
  802df4:	56                   	push   %esi
  802df5:	83 ec 20             	sub    $0x20,%esp
  802df8:	8b 55 14             	mov    0x14(%ebp),%edx
  802dfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dfe:	8b 7d 10             	mov    0x10(%ebp),%edi
  802e01:	8b 75 0c             	mov    0xc(%ebp),%esi
  802e04:	85 d2                	test   %edx,%edx
  802e06:	89 c8                	mov    %ecx,%eax
  802e08:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802e0b:	75 13                	jne    802e20 <__umoddi3+0x30>
  802e0d:	39 f7                	cmp    %esi,%edi
  802e0f:	76 3f                	jbe    802e50 <__umoddi3+0x60>
  802e11:	89 f2                	mov    %esi,%edx
  802e13:	f7 f7                	div    %edi
  802e15:	89 d0                	mov    %edx,%eax
  802e17:	31 d2                	xor    %edx,%edx
  802e19:	83 c4 20             	add    $0x20,%esp
  802e1c:	5e                   	pop    %esi
  802e1d:	5f                   	pop    %edi
  802e1e:	5d                   	pop    %ebp
  802e1f:	c3                   	ret    
  802e20:	39 f2                	cmp    %esi,%edx
  802e22:	77 4c                	ja     802e70 <__umoddi3+0x80>
  802e24:	0f bd ca             	bsr    %edx,%ecx
  802e27:	83 f1 1f             	xor    $0x1f,%ecx
  802e2a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802e2d:	75 51                	jne    802e80 <__umoddi3+0x90>
  802e2f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802e32:	0f 87 e0 00 00 00    	ja     802f18 <__umoddi3+0x128>
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	29 f8                	sub    %edi,%eax
  802e3d:	19 d6                	sbb    %edx,%esi
  802e3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	89 f2                	mov    %esi,%edx
  802e47:	83 c4 20             	add    $0x20,%esp
  802e4a:	5e                   	pop    %esi
  802e4b:	5f                   	pop    %edi
  802e4c:	5d                   	pop    %ebp
  802e4d:	c3                   	ret    
  802e4e:	66 90                	xchg   %ax,%ax
  802e50:	85 ff                	test   %edi,%edi
  802e52:	75 0b                	jne    802e5f <__umoddi3+0x6f>
  802e54:	b8 01 00 00 00       	mov    $0x1,%eax
  802e59:	31 d2                	xor    %edx,%edx
  802e5b:	f7 f7                	div    %edi
  802e5d:	89 c7                	mov    %eax,%edi
  802e5f:	89 f0                	mov    %esi,%eax
  802e61:	31 d2                	xor    %edx,%edx
  802e63:	f7 f7                	div    %edi
  802e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e68:	f7 f7                	div    %edi
  802e6a:	eb a9                	jmp    802e15 <__umoddi3+0x25>
  802e6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e70:	89 c8                	mov    %ecx,%eax
  802e72:	89 f2                	mov    %esi,%edx
  802e74:	83 c4 20             	add    $0x20,%esp
  802e77:	5e                   	pop    %esi
  802e78:	5f                   	pop    %edi
  802e79:	5d                   	pop    %ebp
  802e7a:	c3                   	ret    
  802e7b:	90                   	nop
  802e7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e80:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e84:	d3 e2                	shl    %cl,%edx
  802e86:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e89:	ba 20 00 00 00       	mov    $0x20,%edx
  802e8e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802e91:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802e94:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e98:	89 fa                	mov    %edi,%edx
  802e9a:	d3 ea                	shr    %cl,%edx
  802e9c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ea0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802ea3:	d3 e7                	shl    %cl,%edi
  802ea5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ea9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802eac:	89 f2                	mov    %esi,%edx
  802eae:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802eb1:	89 c7                	mov    %eax,%edi
  802eb3:	d3 ea                	shr    %cl,%edx
  802eb5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802eb9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802ebc:	89 c2                	mov    %eax,%edx
  802ebe:	d3 e6                	shl    %cl,%esi
  802ec0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ec4:	d3 ea                	shr    %cl,%edx
  802ec6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802eca:	09 d6                	or     %edx,%esi
  802ecc:	89 f0                	mov    %esi,%eax
  802ece:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802ed1:	d3 e7                	shl    %cl,%edi
  802ed3:	89 f2                	mov    %esi,%edx
  802ed5:	f7 75 f4             	divl   -0xc(%ebp)
  802ed8:	89 d6                	mov    %edx,%esi
  802eda:	f7 65 e8             	mull   -0x18(%ebp)
  802edd:	39 d6                	cmp    %edx,%esi
  802edf:	72 2b                	jb     802f0c <__umoddi3+0x11c>
  802ee1:	39 c7                	cmp    %eax,%edi
  802ee3:	72 23                	jb     802f08 <__umoddi3+0x118>
  802ee5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ee9:	29 c7                	sub    %eax,%edi
  802eeb:	19 d6                	sbb    %edx,%esi
  802eed:	89 f0                	mov    %esi,%eax
  802eef:	89 f2                	mov    %esi,%edx
  802ef1:	d3 ef                	shr    %cl,%edi
  802ef3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ef7:	d3 e0                	shl    %cl,%eax
  802ef9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802efd:	09 f8                	or     %edi,%eax
  802eff:	d3 ea                	shr    %cl,%edx
  802f01:	83 c4 20             	add    $0x20,%esp
  802f04:	5e                   	pop    %esi
  802f05:	5f                   	pop    %edi
  802f06:	5d                   	pop    %ebp
  802f07:	c3                   	ret    
  802f08:	39 d6                	cmp    %edx,%esi
  802f0a:	75 d9                	jne    802ee5 <__umoddi3+0xf5>
  802f0c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802f0f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802f12:	eb d1                	jmp    802ee5 <__umoddi3+0xf5>
  802f14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f18:	39 f2                	cmp    %esi,%edx
  802f1a:	0f 82 18 ff ff ff    	jb     802e38 <__umoddi3+0x48>
  802f20:	e9 1d ff ff ff       	jmp    802e42 <__umoddi3+0x52>
