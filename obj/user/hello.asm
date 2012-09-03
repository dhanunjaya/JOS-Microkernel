
obj/user/hello:     file format elf32-i386


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
  80002c:	e8 5b 00 00 00       	call   80008c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
           "Hi This is Rihit", 
         };

void
umain(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 10             	sub    $0x10,%esp
	cprintf("hello, world\n");
  80003c:	c7 04 24 40 28 80 00 	movl   $0x802840,(%esp)
  800043:	e8 11 01 00 00       	call   800159 <cprintf>
	cprintf("i am environment %08x\n", env->env_id);
  800048:	a1 a0 60 80 00       	mov    0x8060a0,%eax
  80004d:	8b 40 4c             	mov    0x4c(%eax),%eax
  800050:	89 44 24 04          	mov    %eax,0x4(%esp)
  800054:	c7 04 24 4e 28 80 00 	movl   $0x80284e,(%esp)
  80005b:	e8 f9 00 00 00       	call   800159 <cprintf>
  800060:	bb 00 00 00 00       	mov    $0x0,%ebx
      int i=0; 
      for(;i<11;i++)
      {
         int ret=sys_call_packet_send((void *)data[i],16);    
  800065:	be 00 60 80 00       	mov    $0x806000,%esi
  80006a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  800071:	00 
  800072:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  800075:	89 04 24             	mov    %eax,(%esp)
  800078:	e8 1c 0c 00 00       	call   800c99 <sys_call_packet_send>
umain(void)
{
	cprintf("hello, world\n");
	cprintf("i am environment %08x\n", env->env_id);
      int i=0; 
      for(;i<11;i++)
  80007d:	83 c3 01             	add    $0x1,%ebx
  800080:	83 fb 0b             	cmp    $0xb,%ebx
  800083:	75 e5                	jne    80006a <umain+0x36>
      {
         int ret=sys_call_packet_send((void *)data[i],16);    
      }
}
  800085:	83 c4 10             	add    $0x10,%esp
  800088:	5b                   	pop    %ebx
  800089:	5e                   	pop    %esi
  80008a:	5d                   	pop    %ebp
  80008b:	c3                   	ret    

0080008c <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80008c:	55                   	push   %ebp
  80008d:	89 e5                	mov    %esp,%ebp
  80008f:	83 ec 18             	sub    $0x18,%esp
  800092:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800095:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800098:	8b 75 08             	mov    0x8(%ebp),%esi
  80009b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  80009e:	e8 86 0f 00 00       	call   801029 <sys_getenvid>
  8000a3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000a8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8000ab:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8000b0:	a3 a0 60 80 00       	mov    %eax,0x8060a0

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000b5:	85 f6                	test   %esi,%esi
  8000b7:	7e 07                	jle    8000c0 <libmain+0x34>
		binaryname = argv[0];
  8000b9:	8b 03                	mov    (%ebx),%eax
  8000bb:	a3 2c 60 80 00       	mov    %eax,0x80602c

	// call user main routine
	umain(argc, argv);
  8000c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000c4:	89 34 24             	mov    %esi,(%esp)
  8000c7:	e8 68 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  8000cc:	e8 0b 00 00 00       	call   8000dc <exit>
}
  8000d1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8000d4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8000d7:	89 ec                	mov    %ebp,%esp
  8000d9:	5d                   	pop    %ebp
  8000da:	c3                   	ret    
	...

008000dc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000e2:	e8 b4 14 00 00       	call   80159b <close_all>
	sys_env_destroy(0);
  8000e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ee:	e8 6a 0f 00 00       	call   80105d <sys_env_destroy>
}
  8000f3:	c9                   	leave  
  8000f4:	c3                   	ret    
  8000f5:	00 00                	add    %al,(%eax)
	...

008000f8 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800101:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800108:	00 00 00 
	b.cnt = 0;
  80010b:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800112:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800115:	8b 45 0c             	mov    0xc(%ebp),%eax
  800118:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80011c:	8b 45 08             	mov    0x8(%ebp),%eax
  80011f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800123:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800129:	89 44 24 04          	mov    %eax,0x4(%esp)
  80012d:	c7 04 24 73 01 80 00 	movl   $0x800173,(%esp)
  800134:	e8 d4 01 00 00       	call   80030d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800139:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80013f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800143:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800149:	89 04 24             	mov    %eax,(%esp)
  80014c:	e8 df 0a 00 00       	call   800c30 <sys_cputs>

	return b.cnt;
}
  800151:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800157:	c9                   	leave  
  800158:	c3                   	ret    

00800159 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800159:	55                   	push   %ebp
  80015a:	89 e5                	mov    %esp,%ebp
  80015c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80015f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800162:	89 44 24 04          	mov    %eax,0x4(%esp)
  800166:	8b 45 08             	mov    0x8(%ebp),%eax
  800169:	89 04 24             	mov    %eax,(%esp)
  80016c:	e8 87 ff ff ff       	call   8000f8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800171:	c9                   	leave  
  800172:	c3                   	ret    

00800173 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800173:	55                   	push   %ebp
  800174:	89 e5                	mov    %esp,%ebp
  800176:	53                   	push   %ebx
  800177:	83 ec 14             	sub    $0x14,%esp
  80017a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80017d:	8b 03                	mov    (%ebx),%eax
  80017f:	8b 55 08             	mov    0x8(%ebp),%edx
  800182:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800186:	83 c0 01             	add    $0x1,%eax
  800189:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80018b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800190:	75 19                	jne    8001ab <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800192:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800199:	00 
  80019a:	8d 43 08             	lea    0x8(%ebx),%eax
  80019d:	89 04 24             	mov    %eax,(%esp)
  8001a0:	e8 8b 0a 00 00       	call   800c30 <sys_cputs>
		b->idx = 0;
  8001a5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8001ab:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8001af:	83 c4 14             	add    $0x14,%esp
  8001b2:	5b                   	pop    %ebx
  8001b3:	5d                   	pop    %ebp
  8001b4:	c3                   	ret    
	...

008001c0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c0:	55                   	push   %ebp
  8001c1:	89 e5                	mov    %esp,%ebp
  8001c3:	57                   	push   %edi
  8001c4:	56                   	push   %esi
  8001c5:	53                   	push   %ebx
  8001c6:	83 ec 4c             	sub    $0x4c,%esp
  8001c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8001cc:	89 d6                	mov    %edx,%esi
  8001ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8001da:	8b 45 10             	mov    0x10(%ebp),%eax
  8001dd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8001e0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8001e6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001eb:	39 d1                	cmp    %edx,%ecx
  8001ed:	72 15                	jb     800204 <printnum+0x44>
  8001ef:	77 07                	ja     8001f8 <printnum+0x38>
  8001f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8001f4:	39 d0                	cmp    %edx,%eax
  8001f6:	76 0c                	jbe    800204 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8001f8:	83 eb 01             	sub    $0x1,%ebx
  8001fb:	85 db                	test   %ebx,%ebx
  8001fd:	8d 76 00             	lea    0x0(%esi),%esi
  800200:	7f 61                	jg     800263 <printnum+0xa3>
  800202:	eb 70                	jmp    800274 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800204:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800208:	83 eb 01             	sub    $0x1,%ebx
  80020b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80020f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800213:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800217:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80021b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80021e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800221:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800224:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800228:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80022f:	00 
  800230:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800233:	89 04 24             	mov    %eax,(%esp)
  800236:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800239:	89 54 24 04          	mov    %edx,0x4(%esp)
  80023d:	e8 8e 23 00 00       	call   8025d0 <__udivdi3>
  800242:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800245:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800248:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80024c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800250:	89 04 24             	mov    %eax,(%esp)
  800253:	89 54 24 04          	mov    %edx,0x4(%esp)
  800257:	89 f2                	mov    %esi,%edx
  800259:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80025c:	e8 5f ff ff ff       	call   8001c0 <printnum>
  800261:	eb 11                	jmp    800274 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800263:	89 74 24 04          	mov    %esi,0x4(%esp)
  800267:	89 3c 24             	mov    %edi,(%esp)
  80026a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80026d:	83 eb 01             	sub    $0x1,%ebx
  800270:	85 db                	test   %ebx,%ebx
  800272:	7f ef                	jg     800263 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800274:	89 74 24 04          	mov    %esi,0x4(%esp)
  800278:	8b 74 24 04          	mov    0x4(%esp),%esi
  80027c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80027f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800283:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80028a:	00 
  80028b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80028e:	89 14 24             	mov    %edx,(%esp)
  800291:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800294:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800298:	e8 63 24 00 00       	call   802700 <__umoddi3>
  80029d:	89 74 24 04          	mov    %esi,0x4(%esp)
  8002a1:	0f be 80 37 29 80 00 	movsbl 0x802937(%eax),%eax
  8002a8:	89 04 24             	mov    %eax,(%esp)
  8002ab:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8002ae:	83 c4 4c             	add    $0x4c,%esp
  8002b1:	5b                   	pop    %ebx
  8002b2:	5e                   	pop    %esi
  8002b3:	5f                   	pop    %edi
  8002b4:	5d                   	pop    %ebp
  8002b5:	c3                   	ret    

008002b6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8002b9:	83 fa 01             	cmp    $0x1,%edx
  8002bc:	7e 0e                	jle    8002cc <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8002be:	8b 10                	mov    (%eax),%edx
  8002c0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8002c3:	89 08                	mov    %ecx,(%eax)
  8002c5:	8b 02                	mov    (%edx),%eax
  8002c7:	8b 52 04             	mov    0x4(%edx),%edx
  8002ca:	eb 22                	jmp    8002ee <getuint+0x38>
	else if (lflag)
  8002cc:	85 d2                	test   %edx,%edx
  8002ce:	74 10                	je     8002e0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8002d0:	8b 10                	mov    (%eax),%edx
  8002d2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002d5:	89 08                	mov    %ecx,(%eax)
  8002d7:	8b 02                	mov    (%edx),%eax
  8002d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8002de:	eb 0e                	jmp    8002ee <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8002e0:	8b 10                	mov    (%eax),%edx
  8002e2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8002e5:	89 08                	mov    %ecx,(%eax)
  8002e7:	8b 02                	mov    (%edx),%eax
  8002e9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8002ee:	5d                   	pop    %ebp
  8002ef:	c3                   	ret    

008002f0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002f6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8002fa:	8b 10                	mov    (%eax),%edx
  8002fc:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ff:	73 0a                	jae    80030b <sprintputch+0x1b>
		*b->buf++ = ch;
  800301:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800304:	88 0a                	mov    %cl,(%edx)
  800306:	83 c2 01             	add    $0x1,%edx
  800309:	89 10                	mov    %edx,(%eax)
}
  80030b:	5d                   	pop    %ebp
  80030c:	c3                   	ret    

0080030d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80030d:	55                   	push   %ebp
  80030e:	89 e5                	mov    %esp,%ebp
  800310:	57                   	push   %edi
  800311:	56                   	push   %esi
  800312:	53                   	push   %ebx
  800313:	83 ec 5c             	sub    $0x5c,%esp
  800316:	8b 7d 08             	mov    0x8(%ebp),%edi
  800319:	8b 75 0c             	mov    0xc(%ebp),%esi
  80031c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80031f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800326:	eb 11                	jmp    800339 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800328:	85 c0                	test   %eax,%eax
  80032a:	0f 84 09 04 00 00    	je     800739 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  800330:	89 74 24 04          	mov    %esi,0x4(%esp)
  800334:	89 04 24             	mov    %eax,(%esp)
  800337:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800339:	0f b6 03             	movzbl (%ebx),%eax
  80033c:	83 c3 01             	add    $0x1,%ebx
  80033f:	83 f8 25             	cmp    $0x25,%eax
  800342:	75 e4                	jne    800328 <vprintfmt+0x1b>
  800344:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800348:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80034f:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800356:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80035d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800362:	eb 06                	jmp    80036a <vprintfmt+0x5d>
  800364:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800368:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80036a:	0f b6 13             	movzbl (%ebx),%edx
  80036d:	0f b6 c2             	movzbl %dl,%eax
  800370:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800373:	8d 43 01             	lea    0x1(%ebx),%eax
  800376:	83 ea 23             	sub    $0x23,%edx
  800379:	80 fa 55             	cmp    $0x55,%dl
  80037c:	0f 87 9a 03 00 00    	ja     80071c <vprintfmt+0x40f>
  800382:	0f b6 d2             	movzbl %dl,%edx
  800385:	ff 24 95 80 2a 80 00 	jmp    *0x802a80(,%edx,4)
  80038c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800390:	eb d6                	jmp    800368 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800392:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800395:	83 ea 30             	sub    $0x30,%edx
  800398:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  80039b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80039e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8003a1:	83 fb 09             	cmp    $0x9,%ebx
  8003a4:	77 4c                	ja     8003f2 <vprintfmt+0xe5>
  8003a6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003a9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8003ac:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8003af:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8003b2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8003b6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8003b9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8003bc:	83 fb 09             	cmp    $0x9,%ebx
  8003bf:	76 eb                	jbe    8003ac <vprintfmt+0x9f>
  8003c1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8003c4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003c7:	eb 29                	jmp    8003f2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8003c9:	8b 55 14             	mov    0x14(%ebp),%edx
  8003cc:	8d 5a 04             	lea    0x4(%edx),%ebx
  8003cf:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8003d2:	8b 12                	mov    (%edx),%edx
  8003d4:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  8003d7:	eb 19                	jmp    8003f2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8003d9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003dc:	c1 fa 1f             	sar    $0x1f,%edx
  8003df:	f7 d2                	not    %edx
  8003e1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8003e4:	eb 82                	jmp    800368 <vprintfmt+0x5b>
  8003e6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8003ed:	e9 76 ff ff ff       	jmp    800368 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8003f2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8003f6:	0f 89 6c ff ff ff    	jns    800368 <vprintfmt+0x5b>
  8003fc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8003ff:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800402:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800405:	89 55 cc             	mov    %edx,-0x34(%ebp)
  800408:	e9 5b ff ff ff       	jmp    800368 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80040d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800410:	e9 53 ff ff ff       	jmp    800368 <vprintfmt+0x5b>
  800415:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800418:	8b 45 14             	mov    0x14(%ebp),%eax
  80041b:	8d 50 04             	lea    0x4(%eax),%edx
  80041e:	89 55 14             	mov    %edx,0x14(%ebp)
  800421:	89 74 24 04          	mov    %esi,0x4(%esp)
  800425:	8b 00                	mov    (%eax),%eax
  800427:	89 04 24             	mov    %eax,(%esp)
  80042a:	ff d7                	call   *%edi
  80042c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80042f:	e9 05 ff ff ff       	jmp    800339 <vprintfmt+0x2c>
  800434:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800437:	8b 45 14             	mov    0x14(%ebp),%eax
  80043a:	8d 50 04             	lea    0x4(%eax),%edx
  80043d:	89 55 14             	mov    %edx,0x14(%ebp)
  800440:	8b 00                	mov    (%eax),%eax
  800442:	89 c2                	mov    %eax,%edx
  800444:	c1 fa 1f             	sar    $0x1f,%edx
  800447:	31 d0                	xor    %edx,%eax
  800449:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80044b:	83 f8 0f             	cmp    $0xf,%eax
  80044e:	7f 0b                	jg     80045b <vprintfmt+0x14e>
  800450:	8b 14 85 e0 2b 80 00 	mov    0x802be0(,%eax,4),%edx
  800457:	85 d2                	test   %edx,%edx
  800459:	75 20                	jne    80047b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80045b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80045f:	c7 44 24 08 48 29 80 	movl   $0x802948,0x8(%esp)
  800466:	00 
  800467:	89 74 24 04          	mov    %esi,0x4(%esp)
  80046b:	89 3c 24             	mov    %edi,(%esp)
  80046e:	e8 4e 03 00 00       	call   8007c1 <printfmt>
  800473:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800476:	e9 be fe ff ff       	jmp    800339 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80047b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80047f:	c7 44 24 08 2d 2d 80 	movl   $0x802d2d,0x8(%esp)
  800486:	00 
  800487:	89 74 24 04          	mov    %esi,0x4(%esp)
  80048b:	89 3c 24             	mov    %edi,(%esp)
  80048e:	e8 2e 03 00 00       	call   8007c1 <printfmt>
  800493:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800496:	e9 9e fe ff ff       	jmp    800339 <vprintfmt+0x2c>
  80049b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80049e:	89 c3                	mov    %eax,%ebx
  8004a0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8004a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004a6:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8004a9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ac:	8d 50 04             	lea    0x4(%eax),%edx
  8004af:	89 55 14             	mov    %edx,0x14(%ebp)
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8004b7:	85 c0                	test   %eax,%eax
  8004b9:	75 07                	jne    8004c2 <vprintfmt+0x1b5>
  8004bb:	c7 45 c4 51 29 80 00 	movl   $0x802951,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  8004c2:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8004c6:	7e 06                	jle    8004ce <vprintfmt+0x1c1>
  8004c8:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  8004cc:	75 13                	jne    8004e1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004ce:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004d1:	0f be 02             	movsbl (%edx),%eax
  8004d4:	85 c0                	test   %eax,%eax
  8004d6:	0f 85 99 00 00 00    	jne    800575 <vprintfmt+0x268>
  8004dc:	e9 86 00 00 00       	jmp    800567 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8004e5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8004e8:	89 0c 24             	mov    %ecx,(%esp)
  8004eb:	e8 1b 03 00 00       	call   80080b <strnlen>
  8004f0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8004f3:	29 c2                	sub    %eax,%edx
  8004f5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8004f8:	85 d2                	test   %edx,%edx
  8004fa:	7e d2                	jle    8004ce <vprintfmt+0x1c1>
					putch(padc, putdat);
  8004fc:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  800500:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800503:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  800506:	89 d3                	mov    %edx,%ebx
  800508:	89 74 24 04          	mov    %esi,0x4(%esp)
  80050c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80050f:	89 04 24             	mov    %eax,(%esp)
  800512:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800514:	83 eb 01             	sub    $0x1,%ebx
  800517:	85 db                	test   %ebx,%ebx
  800519:	7f ed                	jg     800508 <vprintfmt+0x1fb>
  80051b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80051e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800525:	eb a7                	jmp    8004ce <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800527:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80052b:	74 18                	je     800545 <vprintfmt+0x238>
  80052d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800530:	83 fa 5e             	cmp    $0x5e,%edx
  800533:	76 10                	jbe    800545 <vprintfmt+0x238>
					putch('?', putdat);
  800535:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800539:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800540:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800543:	eb 0a                	jmp    80054f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800545:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800549:	89 04 24             	mov    %eax,(%esp)
  80054c:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80054f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800553:	0f be 03             	movsbl (%ebx),%eax
  800556:	85 c0                	test   %eax,%eax
  800558:	74 05                	je     80055f <vprintfmt+0x252>
  80055a:	83 c3 01             	add    $0x1,%ebx
  80055d:	eb 29                	jmp    800588 <vprintfmt+0x27b>
  80055f:	89 fe                	mov    %edi,%esi
  800561:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800564:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800567:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80056b:	7f 2e                	jg     80059b <vprintfmt+0x28e>
  80056d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800570:	e9 c4 fd ff ff       	jmp    800339 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800575:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800578:	83 c2 01             	add    $0x1,%edx
  80057b:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80057e:	89 f7                	mov    %esi,%edi
  800580:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800583:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  800586:	89 d3                	mov    %edx,%ebx
  800588:	85 f6                	test   %esi,%esi
  80058a:	78 9b                	js     800527 <vprintfmt+0x21a>
  80058c:	83 ee 01             	sub    $0x1,%esi
  80058f:	79 96                	jns    800527 <vprintfmt+0x21a>
  800591:	89 fe                	mov    %edi,%esi
  800593:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800596:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800599:	eb cc                	jmp    800567 <vprintfmt+0x25a>
  80059b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  80059e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8005a1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005a5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8005ac:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8005ae:	83 eb 01             	sub    $0x1,%ebx
  8005b1:	85 db                	test   %ebx,%ebx
  8005b3:	7f ec                	jg     8005a1 <vprintfmt+0x294>
  8005b5:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8005b8:	e9 7c fd ff ff       	jmp    800339 <vprintfmt+0x2c>
  8005bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8005c0:	83 f9 01             	cmp    $0x1,%ecx
  8005c3:	7e 16                	jle    8005db <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  8005c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c8:	8d 50 08             	lea    0x8(%eax),%edx
  8005cb:	89 55 14             	mov    %edx,0x14(%ebp)
  8005ce:	8b 10                	mov    (%eax),%edx
  8005d0:	8b 48 04             	mov    0x4(%eax),%ecx
  8005d3:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8005d6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005d9:	eb 32                	jmp    80060d <vprintfmt+0x300>
	else if (lflag)
  8005db:	85 c9                	test   %ecx,%ecx
  8005dd:	74 18                	je     8005f7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8005df:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e2:	8d 50 04             	lea    0x4(%eax),%edx
  8005e5:	89 55 14             	mov    %edx,0x14(%ebp)
  8005e8:	8b 00                	mov    (%eax),%eax
  8005ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8005ed:	89 c1                	mov    %eax,%ecx
  8005ef:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8005f5:	eb 16                	jmp    80060d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8005f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8005fa:	8d 50 04             	lea    0x4(%eax),%edx
  8005fd:	89 55 14             	mov    %edx,0x14(%ebp)
  800600:	8b 00                	mov    (%eax),%eax
  800602:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800605:	89 c2                	mov    %eax,%edx
  800607:	c1 fa 1f             	sar    $0x1f,%edx
  80060a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80060d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800610:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800613:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800618:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80061c:	0f 89 b8 00 00 00    	jns    8006da <vprintfmt+0x3cd>
				putch('-', putdat);
  800622:	89 74 24 04          	mov    %esi,0x4(%esp)
  800626:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80062d:	ff d7                	call   *%edi
				num = -(long long) num;
  80062f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800632:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800635:	f7 d9                	neg    %ecx
  800637:	83 d3 00             	adc    $0x0,%ebx
  80063a:	f7 db                	neg    %ebx
  80063c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800641:	e9 94 00 00 00       	jmp    8006da <vprintfmt+0x3cd>
  800646:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800649:	89 ca                	mov    %ecx,%edx
  80064b:	8d 45 14             	lea    0x14(%ebp),%eax
  80064e:	e8 63 fc ff ff       	call   8002b6 <getuint>
  800653:	89 c1                	mov    %eax,%ecx
  800655:	89 d3                	mov    %edx,%ebx
  800657:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80065c:	eb 7c                	jmp    8006da <vprintfmt+0x3cd>
  80065e:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800661:	89 74 24 04          	mov    %esi,0x4(%esp)
  800665:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  80066c:	ff d7                	call   *%edi
			putch('X', putdat);
  80066e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800672:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800679:	ff d7                	call   *%edi
			putch('X', putdat);
  80067b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80067f:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800686:	ff d7                	call   *%edi
  800688:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80068b:	e9 a9 fc ff ff       	jmp    800339 <vprintfmt+0x2c>
  800690:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800693:	89 74 24 04          	mov    %esi,0x4(%esp)
  800697:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80069e:	ff d7                	call   *%edi
			putch('x', putdat);
  8006a0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006a4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8006ab:	ff d7                	call   *%edi
			num = (unsigned long long)
  8006ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b0:	8d 50 04             	lea    0x4(%eax),%edx
  8006b3:	89 55 14             	mov    %edx,0x14(%ebp)
  8006b6:	8b 08                	mov    (%eax),%ecx
  8006b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006bd:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8006c2:	eb 16                	jmp    8006da <vprintfmt+0x3cd>
  8006c4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8006c7:	89 ca                	mov    %ecx,%edx
  8006c9:	8d 45 14             	lea    0x14(%ebp),%eax
  8006cc:	e8 e5 fb ff ff       	call   8002b6 <getuint>
  8006d1:	89 c1                	mov    %eax,%ecx
  8006d3:	89 d3                	mov    %edx,%ebx
  8006d5:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8006da:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  8006de:	89 54 24 10          	mov    %edx,0x10(%esp)
  8006e2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006e5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8006e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006ed:	89 0c 24             	mov    %ecx,(%esp)
  8006f0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8006f4:	89 f2                	mov    %esi,%edx
  8006f6:	89 f8                	mov    %edi,%eax
  8006f8:	e8 c3 fa ff ff       	call   8001c0 <printnum>
  8006fd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800700:	e9 34 fc ff ff       	jmp    800339 <vprintfmt+0x2c>
  800705:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800708:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80070b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80070f:	89 14 24             	mov    %edx,(%esp)
  800712:	ff d7                	call   *%edi
  800714:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800717:	e9 1d fc ff ff       	jmp    800339 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80071c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800720:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800727:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800729:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80072c:	80 38 25             	cmpb   $0x25,(%eax)
  80072f:	0f 84 04 fc ff ff    	je     800339 <vprintfmt+0x2c>
  800735:	89 c3                	mov    %eax,%ebx
  800737:	eb f0                	jmp    800729 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  800739:	83 c4 5c             	add    $0x5c,%esp
  80073c:	5b                   	pop    %ebx
  80073d:	5e                   	pop    %esi
  80073e:	5f                   	pop    %edi
  80073f:	5d                   	pop    %ebp
  800740:	c3                   	ret    

00800741 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800741:	55                   	push   %ebp
  800742:	89 e5                	mov    %esp,%ebp
  800744:	83 ec 28             	sub    $0x28,%esp
  800747:	8b 45 08             	mov    0x8(%ebp),%eax
  80074a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  80074d:	85 c0                	test   %eax,%eax
  80074f:	74 04                	je     800755 <vsnprintf+0x14>
  800751:	85 d2                	test   %edx,%edx
  800753:	7f 07                	jg     80075c <vsnprintf+0x1b>
  800755:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80075a:	eb 3b                	jmp    800797 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80075c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80075f:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800763:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800766:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80076d:	8b 45 14             	mov    0x14(%ebp),%eax
  800770:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800774:	8b 45 10             	mov    0x10(%ebp),%eax
  800777:	89 44 24 08          	mov    %eax,0x8(%esp)
  80077b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80077e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800782:	c7 04 24 f0 02 80 00 	movl   $0x8002f0,(%esp)
  800789:	e8 7f fb ff ff       	call   80030d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80078e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800791:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800794:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800797:	c9                   	leave  
  800798:	c3                   	ret    

00800799 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80079f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8007a2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	89 04 24             	mov    %eax,(%esp)
  8007ba:	e8 82 ff ff ff       	call   800741 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007bf:	c9                   	leave  
  8007c0:	c3                   	ret    

008007c1 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8007c1:	55                   	push   %ebp
  8007c2:	89 e5                	mov    %esp,%ebp
  8007c4:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8007c7:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8007ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	89 04 24             	mov    %eax,(%esp)
  8007e2:	e8 26 fb ff ff       	call   80030d <vprintfmt>
	va_end(ap);
}
  8007e7:	c9                   	leave  
  8007e8:	c3                   	ret    
  8007e9:	00 00                	add    %al,(%eax)
  8007eb:	00 00                	add    %al,(%eax)
  8007ed:	00 00                	add    %al,(%eax)
	...

008007f0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007f0:	55                   	push   %ebp
  8007f1:	89 e5                	mov    %esp,%ebp
  8007f3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007f6:	b8 00 00 00 00       	mov    $0x0,%eax
  8007fb:	80 3a 00             	cmpb   $0x0,(%edx)
  8007fe:	74 09                	je     800809 <strlen+0x19>
		n++;
  800800:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800803:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800807:	75 f7                	jne    800800 <strlen+0x10>
		n++;
	return n;
}
  800809:	5d                   	pop    %ebp
  80080a:	c3                   	ret    

0080080b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80080b:	55                   	push   %ebp
  80080c:	89 e5                	mov    %esp,%ebp
  80080e:	53                   	push   %ebx
  80080f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800812:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800815:	85 c9                	test   %ecx,%ecx
  800817:	74 19                	je     800832 <strnlen+0x27>
  800819:	80 3b 00             	cmpb   $0x0,(%ebx)
  80081c:	74 14                	je     800832 <strnlen+0x27>
  80081e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800823:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800826:	39 c8                	cmp    %ecx,%eax
  800828:	74 0d                	je     800837 <strnlen+0x2c>
  80082a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80082e:	75 f3                	jne    800823 <strnlen+0x18>
  800830:	eb 05                	jmp    800837 <strnlen+0x2c>
  800832:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800837:	5b                   	pop    %ebx
  800838:	5d                   	pop    %ebp
  800839:	c3                   	ret    

0080083a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	53                   	push   %ebx
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800844:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800849:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80084d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800850:	83 c2 01             	add    $0x1,%edx
  800853:	84 c9                	test   %cl,%cl
  800855:	75 f2                	jne    800849 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800857:	5b                   	pop    %ebx
  800858:	5d                   	pop    %ebp
  800859:	c3                   	ret    

0080085a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80085a:	55                   	push   %ebp
  80085b:	89 e5                	mov    %esp,%ebp
  80085d:	56                   	push   %esi
  80085e:	53                   	push   %ebx
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	8b 55 0c             	mov    0xc(%ebp),%edx
  800865:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800868:	85 f6                	test   %esi,%esi
  80086a:	74 18                	je     800884 <strncpy+0x2a>
  80086c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800871:	0f b6 1a             	movzbl (%edx),%ebx
  800874:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800877:	80 3a 01             	cmpb   $0x1,(%edx)
  80087a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80087d:	83 c1 01             	add    $0x1,%ecx
  800880:	39 ce                	cmp    %ecx,%esi
  800882:	77 ed                	ja     800871 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800884:	5b                   	pop    %ebx
  800885:	5e                   	pop    %esi
  800886:	5d                   	pop    %ebp
  800887:	c3                   	ret    

00800888 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	56                   	push   %esi
  80088c:	53                   	push   %ebx
  80088d:	8b 75 08             	mov    0x8(%ebp),%esi
  800890:	8b 55 0c             	mov    0xc(%ebp),%edx
  800893:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800896:	89 f0                	mov    %esi,%eax
  800898:	85 c9                	test   %ecx,%ecx
  80089a:	74 27                	je     8008c3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  80089c:	83 e9 01             	sub    $0x1,%ecx
  80089f:	74 1d                	je     8008be <strlcpy+0x36>
  8008a1:	0f b6 1a             	movzbl (%edx),%ebx
  8008a4:	84 db                	test   %bl,%bl
  8008a6:	74 16                	je     8008be <strlcpy+0x36>
			*dst++ = *src++;
  8008a8:	88 18                	mov    %bl,(%eax)
  8008aa:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008ad:	83 e9 01             	sub    $0x1,%ecx
  8008b0:	74 0e                	je     8008c0 <strlcpy+0x38>
			*dst++ = *src++;
  8008b2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8008b5:	0f b6 1a             	movzbl (%edx),%ebx
  8008b8:	84 db                	test   %bl,%bl
  8008ba:	75 ec                	jne    8008a8 <strlcpy+0x20>
  8008bc:	eb 02                	jmp    8008c0 <strlcpy+0x38>
  8008be:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  8008c0:	c6 00 00             	movb   $0x0,(%eax)
  8008c3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  8008c5:	5b                   	pop    %ebx
  8008c6:	5e                   	pop    %esi
  8008c7:	5d                   	pop    %ebp
  8008c8:	c3                   	ret    

008008c9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008c9:	55                   	push   %ebp
  8008ca:	89 e5                	mov    %esp,%ebp
  8008cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008cf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008d2:	0f b6 01             	movzbl (%ecx),%eax
  8008d5:	84 c0                	test   %al,%al
  8008d7:	74 15                	je     8008ee <strcmp+0x25>
  8008d9:	3a 02                	cmp    (%edx),%al
  8008db:	75 11                	jne    8008ee <strcmp+0x25>
		p++, q++;
  8008dd:	83 c1 01             	add    $0x1,%ecx
  8008e0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8008e3:	0f b6 01             	movzbl (%ecx),%eax
  8008e6:	84 c0                	test   %al,%al
  8008e8:	74 04                	je     8008ee <strcmp+0x25>
  8008ea:	3a 02                	cmp    (%edx),%al
  8008ec:	74 ef                	je     8008dd <strcmp+0x14>
  8008ee:	0f b6 c0             	movzbl %al,%eax
  8008f1:	0f b6 12             	movzbl (%edx),%edx
  8008f4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8008f6:	5d                   	pop    %ebp
  8008f7:	c3                   	ret    

008008f8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	53                   	push   %ebx
  8008fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8008ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800902:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800905:	85 c0                	test   %eax,%eax
  800907:	74 23                	je     80092c <strncmp+0x34>
  800909:	0f b6 1a             	movzbl (%edx),%ebx
  80090c:	84 db                	test   %bl,%bl
  80090e:	74 24                	je     800934 <strncmp+0x3c>
  800910:	3a 19                	cmp    (%ecx),%bl
  800912:	75 20                	jne    800934 <strncmp+0x3c>
  800914:	83 e8 01             	sub    $0x1,%eax
  800917:	74 13                	je     80092c <strncmp+0x34>
		n--, p++, q++;
  800919:	83 c2 01             	add    $0x1,%edx
  80091c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80091f:	0f b6 1a             	movzbl (%edx),%ebx
  800922:	84 db                	test   %bl,%bl
  800924:	74 0e                	je     800934 <strncmp+0x3c>
  800926:	3a 19                	cmp    (%ecx),%bl
  800928:	74 ea                	je     800914 <strncmp+0x1c>
  80092a:	eb 08                	jmp    800934 <strncmp+0x3c>
  80092c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800931:	5b                   	pop    %ebx
  800932:	5d                   	pop    %ebp
  800933:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800934:	0f b6 02             	movzbl (%edx),%eax
  800937:	0f b6 11             	movzbl (%ecx),%edx
  80093a:	29 d0                	sub    %edx,%eax
  80093c:	eb f3                	jmp    800931 <strncmp+0x39>

0080093e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80093e:	55                   	push   %ebp
  80093f:	89 e5                	mov    %esp,%ebp
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800948:	0f b6 10             	movzbl (%eax),%edx
  80094b:	84 d2                	test   %dl,%dl
  80094d:	74 15                	je     800964 <strchr+0x26>
		if (*s == c)
  80094f:	38 ca                	cmp    %cl,%dl
  800951:	75 07                	jne    80095a <strchr+0x1c>
  800953:	eb 14                	jmp    800969 <strchr+0x2b>
  800955:	38 ca                	cmp    %cl,%dl
  800957:	90                   	nop
  800958:	74 0f                	je     800969 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80095a:	83 c0 01             	add    $0x1,%eax
  80095d:	0f b6 10             	movzbl (%eax),%edx
  800960:	84 d2                	test   %dl,%dl
  800962:	75 f1                	jne    800955 <strchr+0x17>
  800964:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800969:	5d                   	pop    %ebp
  80096a:	c3                   	ret    

0080096b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80096b:	55                   	push   %ebp
  80096c:	89 e5                	mov    %esp,%ebp
  80096e:	8b 45 08             	mov    0x8(%ebp),%eax
  800971:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800975:	0f b6 10             	movzbl (%eax),%edx
  800978:	84 d2                	test   %dl,%dl
  80097a:	74 18                	je     800994 <strfind+0x29>
		if (*s == c)
  80097c:	38 ca                	cmp    %cl,%dl
  80097e:	75 0a                	jne    80098a <strfind+0x1f>
  800980:	eb 12                	jmp    800994 <strfind+0x29>
  800982:	38 ca                	cmp    %cl,%dl
  800984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800988:	74 0a                	je     800994 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80098a:	83 c0 01             	add    $0x1,%eax
  80098d:	0f b6 10             	movzbl (%eax),%edx
  800990:	84 d2                	test   %dl,%dl
  800992:	75 ee                	jne    800982 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800994:	5d                   	pop    %ebp
  800995:	c3                   	ret    

00800996 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800996:	55                   	push   %ebp
  800997:	89 e5                	mov    %esp,%ebp
  800999:	83 ec 0c             	sub    $0xc,%esp
  80099c:	89 1c 24             	mov    %ebx,(%esp)
  80099f:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009a3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8009a7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ad:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009b0:	85 c9                	test   %ecx,%ecx
  8009b2:	74 30                	je     8009e4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009b4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009ba:	75 25                	jne    8009e1 <memset+0x4b>
  8009bc:	f6 c1 03             	test   $0x3,%cl
  8009bf:	75 20                	jne    8009e1 <memset+0x4b>
		c &= 0xFF;
  8009c1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009c4:	89 d3                	mov    %edx,%ebx
  8009c6:	c1 e3 08             	shl    $0x8,%ebx
  8009c9:	89 d6                	mov    %edx,%esi
  8009cb:	c1 e6 18             	shl    $0x18,%esi
  8009ce:	89 d0                	mov    %edx,%eax
  8009d0:	c1 e0 10             	shl    $0x10,%eax
  8009d3:	09 f0                	or     %esi,%eax
  8009d5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  8009d7:	09 d8                	or     %ebx,%eax
  8009d9:	c1 e9 02             	shr    $0x2,%ecx
  8009dc:	fc                   	cld    
  8009dd:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009df:	eb 03                	jmp    8009e4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009e1:	fc                   	cld    
  8009e2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009e4:	89 f8                	mov    %edi,%eax
  8009e6:	8b 1c 24             	mov    (%esp),%ebx
  8009e9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8009ed:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8009f1:	89 ec                	mov    %ebp,%esp
  8009f3:	5d                   	pop    %ebp
  8009f4:	c3                   	ret    

008009f5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009f5:	55                   	push   %ebp
  8009f6:	89 e5                	mov    %esp,%ebp
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	89 34 24             	mov    %esi,(%esp)
  8009fe:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800a02:	8b 45 08             	mov    0x8(%ebp),%eax
  800a05:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800a08:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800a0b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800a0d:	39 c6                	cmp    %eax,%esi
  800a0f:	73 35                	jae    800a46 <memmove+0x51>
  800a11:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a14:	39 d0                	cmp    %edx,%eax
  800a16:	73 2e                	jae    800a46 <memmove+0x51>
		s += n;
		d += n;
  800a18:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a1a:	f6 c2 03             	test   $0x3,%dl
  800a1d:	75 1b                	jne    800a3a <memmove+0x45>
  800a1f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a25:	75 13                	jne    800a3a <memmove+0x45>
  800a27:	f6 c1 03             	test   $0x3,%cl
  800a2a:	75 0e                	jne    800a3a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800a2c:	83 ef 04             	sub    $0x4,%edi
  800a2f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a32:	c1 e9 02             	shr    $0x2,%ecx
  800a35:	fd                   	std    
  800a36:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a38:	eb 09                	jmp    800a43 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800a3a:	83 ef 01             	sub    $0x1,%edi
  800a3d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800a40:	fd                   	std    
  800a41:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a43:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a44:	eb 20                	jmp    800a66 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a46:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a4c:	75 15                	jne    800a63 <memmove+0x6e>
  800a4e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a54:	75 0d                	jne    800a63 <memmove+0x6e>
  800a56:	f6 c1 03             	test   $0x3,%cl
  800a59:	75 08                	jne    800a63 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800a5b:	c1 e9 02             	shr    $0x2,%ecx
  800a5e:	fc                   	cld    
  800a5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a61:	eb 03                	jmp    800a66 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a63:	fc                   	cld    
  800a64:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a66:	8b 34 24             	mov    (%esp),%esi
  800a69:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800a6d:	89 ec                	mov    %ebp,%esp
  800a6f:	5d                   	pop    %ebp
  800a70:	c3                   	ret    

00800a71 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800a77:	8b 45 10             	mov    0x10(%ebp),%eax
  800a7a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a81:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a85:	8b 45 08             	mov    0x8(%ebp),%eax
  800a88:	89 04 24             	mov    %eax,(%esp)
  800a8b:	e8 65 ff ff ff       	call   8009f5 <memmove>
}
  800a90:	c9                   	leave  
  800a91:	c3                   	ret    

00800a92 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a92:	55                   	push   %ebp
  800a93:	89 e5                	mov    %esp,%ebp
  800a95:	57                   	push   %edi
  800a96:	56                   	push   %esi
  800a97:	53                   	push   %ebx
  800a98:	8b 75 08             	mov    0x8(%ebp),%esi
  800a9b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a9e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800aa1:	85 c9                	test   %ecx,%ecx
  800aa3:	74 36                	je     800adb <memcmp+0x49>
		if (*s1 != *s2)
  800aa5:	0f b6 06             	movzbl (%esi),%eax
  800aa8:	0f b6 1f             	movzbl (%edi),%ebx
  800aab:	38 d8                	cmp    %bl,%al
  800aad:	74 20                	je     800acf <memcmp+0x3d>
  800aaf:	eb 14                	jmp    800ac5 <memcmp+0x33>
  800ab1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800ab6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800abb:	83 c2 01             	add    $0x1,%edx
  800abe:	83 e9 01             	sub    $0x1,%ecx
  800ac1:	38 d8                	cmp    %bl,%al
  800ac3:	74 12                	je     800ad7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800ac5:	0f b6 c0             	movzbl %al,%eax
  800ac8:	0f b6 db             	movzbl %bl,%ebx
  800acb:	29 d8                	sub    %ebx,%eax
  800acd:	eb 11                	jmp    800ae0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800acf:	83 e9 01             	sub    $0x1,%ecx
  800ad2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ad7:	85 c9                	test   %ecx,%ecx
  800ad9:	75 d6                	jne    800ab1 <memcmp+0x1f>
  800adb:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800ae0:	5b                   	pop    %ebx
  800ae1:	5e                   	pop    %esi
  800ae2:	5f                   	pop    %edi
  800ae3:	5d                   	pop    %ebp
  800ae4:	c3                   	ret    

00800ae5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800ae5:	55                   	push   %ebp
  800ae6:	89 e5                	mov    %esp,%ebp
  800ae8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800aeb:	89 c2                	mov    %eax,%edx
  800aed:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800af0:	39 d0                	cmp    %edx,%eax
  800af2:	73 15                	jae    800b09 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800af4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800af8:	38 08                	cmp    %cl,(%eax)
  800afa:	75 06                	jne    800b02 <memfind+0x1d>
  800afc:	eb 0b                	jmp    800b09 <memfind+0x24>
  800afe:	38 08                	cmp    %cl,(%eax)
  800b00:	74 07                	je     800b09 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800b02:	83 c0 01             	add    $0x1,%eax
  800b05:	39 c2                	cmp    %eax,%edx
  800b07:	77 f5                	ja     800afe <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800b09:	5d                   	pop    %ebp
  800b0a:	c3                   	ret    

00800b0b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b0b:	55                   	push   %ebp
  800b0c:	89 e5                	mov    %esp,%ebp
  800b0e:	57                   	push   %edi
  800b0f:	56                   	push   %esi
  800b10:	53                   	push   %ebx
  800b11:	83 ec 04             	sub    $0x4,%esp
  800b14:	8b 55 08             	mov    0x8(%ebp),%edx
  800b17:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b1a:	0f b6 02             	movzbl (%edx),%eax
  800b1d:	3c 20                	cmp    $0x20,%al
  800b1f:	74 04                	je     800b25 <strtol+0x1a>
  800b21:	3c 09                	cmp    $0x9,%al
  800b23:	75 0e                	jne    800b33 <strtol+0x28>
		s++;
  800b25:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b28:	0f b6 02             	movzbl (%edx),%eax
  800b2b:	3c 20                	cmp    $0x20,%al
  800b2d:	74 f6                	je     800b25 <strtol+0x1a>
  800b2f:	3c 09                	cmp    $0x9,%al
  800b31:	74 f2                	je     800b25 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800b33:	3c 2b                	cmp    $0x2b,%al
  800b35:	75 0c                	jne    800b43 <strtol+0x38>
		s++;
  800b37:	83 c2 01             	add    $0x1,%edx
  800b3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b41:	eb 15                	jmp    800b58 <strtol+0x4d>
	else if (*s == '-')
  800b43:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b4a:	3c 2d                	cmp    $0x2d,%al
  800b4c:	75 0a                	jne    800b58 <strtol+0x4d>
		s++, neg = 1;
  800b4e:	83 c2 01             	add    $0x1,%edx
  800b51:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b58:	85 db                	test   %ebx,%ebx
  800b5a:	0f 94 c0             	sete   %al
  800b5d:	74 05                	je     800b64 <strtol+0x59>
  800b5f:	83 fb 10             	cmp    $0x10,%ebx
  800b62:	75 18                	jne    800b7c <strtol+0x71>
  800b64:	80 3a 30             	cmpb   $0x30,(%edx)
  800b67:	75 13                	jne    800b7c <strtol+0x71>
  800b69:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800b6d:	8d 76 00             	lea    0x0(%esi),%esi
  800b70:	75 0a                	jne    800b7c <strtol+0x71>
		s += 2, base = 16;
  800b72:	83 c2 02             	add    $0x2,%edx
  800b75:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b7a:	eb 15                	jmp    800b91 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b7c:	84 c0                	test   %al,%al
  800b7e:	66 90                	xchg   %ax,%ax
  800b80:	74 0f                	je     800b91 <strtol+0x86>
  800b82:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800b87:	80 3a 30             	cmpb   $0x30,(%edx)
  800b8a:	75 05                	jne    800b91 <strtol+0x86>
		s++, base = 8;
  800b8c:	83 c2 01             	add    $0x1,%edx
  800b8f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b91:	b8 00 00 00 00       	mov    $0x0,%eax
  800b96:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800b98:	0f b6 0a             	movzbl (%edx),%ecx
  800b9b:	89 cf                	mov    %ecx,%edi
  800b9d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800ba0:	80 fb 09             	cmp    $0x9,%bl
  800ba3:	77 08                	ja     800bad <strtol+0xa2>
			dig = *s - '0';
  800ba5:	0f be c9             	movsbl %cl,%ecx
  800ba8:	83 e9 30             	sub    $0x30,%ecx
  800bab:	eb 1e                	jmp    800bcb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800bad:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800bb0:	80 fb 19             	cmp    $0x19,%bl
  800bb3:	77 08                	ja     800bbd <strtol+0xb2>
			dig = *s - 'a' + 10;
  800bb5:	0f be c9             	movsbl %cl,%ecx
  800bb8:	83 e9 57             	sub    $0x57,%ecx
  800bbb:	eb 0e                	jmp    800bcb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800bbd:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800bc0:	80 fb 19             	cmp    $0x19,%bl
  800bc3:	77 15                	ja     800bda <strtol+0xcf>
			dig = *s - 'A' + 10;
  800bc5:	0f be c9             	movsbl %cl,%ecx
  800bc8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800bcb:	39 f1                	cmp    %esi,%ecx
  800bcd:	7d 0b                	jge    800bda <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800bcf:	83 c2 01             	add    $0x1,%edx
  800bd2:	0f af c6             	imul   %esi,%eax
  800bd5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800bd8:	eb be                	jmp    800b98 <strtol+0x8d>
  800bda:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800bdc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be0:	74 05                	je     800be7 <strtol+0xdc>
		*endptr = (char *) s;
  800be2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800be5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800be7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800beb:	74 04                	je     800bf1 <strtol+0xe6>
  800bed:	89 c8                	mov    %ecx,%eax
  800bef:	f7 d8                	neg    %eax
}
  800bf1:	83 c4 04             	add    $0x4,%esp
  800bf4:	5b                   	pop    %ebx
  800bf5:	5e                   	pop    %esi
  800bf6:	5f                   	pop    %edi
  800bf7:	5d                   	pop    %ebp
  800bf8:	c3                   	ret    
  800bf9:	00 00                	add    %al,(%eax)
	...

00800bfc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 0c             	sub    $0xc,%esp
  800c02:	89 1c 24             	mov    %ebx,(%esp)
  800c05:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c09:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800c12:	b8 01 00 00 00       	mov    $0x1,%eax
  800c17:	89 d1                	mov    %edx,%ecx
  800c19:	89 d3                	mov    %edx,%ebx
  800c1b:	89 d7                	mov    %edx,%edi
  800c1d:	89 d6                	mov    %edx,%esi
  800c1f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c21:	8b 1c 24             	mov    (%esp),%ebx
  800c24:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c28:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c2c:	89 ec                	mov    %ebp,%esp
  800c2e:	5d                   	pop    %ebp
  800c2f:	c3                   	ret    

00800c30 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	83 ec 0c             	sub    $0xc,%esp
  800c36:	89 1c 24             	mov    %ebx,(%esp)
  800c39:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c3d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c41:	b8 00 00 00 00       	mov    $0x0,%eax
  800c46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c49:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4c:	89 c3                	mov    %eax,%ebx
  800c4e:	89 c7                	mov    %eax,%edi
  800c50:	89 c6                	mov    %eax,%esi
  800c52:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c54:	8b 1c 24             	mov    (%esp),%ebx
  800c57:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c5b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c5f:	89 ec                	mov    %ebp,%esp
  800c61:	5d                   	pop    %ebp
  800c62:	c3                   	ret    

00800c63 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  800c63:	55                   	push   %ebp
  800c64:	89 e5                	mov    %esp,%ebp
  800c66:	83 ec 0c             	sub    $0xc,%esp
  800c69:	89 1c 24             	mov    %ebx,(%esp)
  800c6c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c70:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800c74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c79:	b8 10 00 00 00       	mov    $0x10,%eax
  800c7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c81:	8b 55 08             	mov    0x8(%ebp),%edx
  800c84:	89 df                	mov    %ebx,%edi
  800c86:	89 de                	mov    %ebx,%esi
  800c88:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800c8a:	8b 1c 24             	mov    (%esp),%ebx
  800c8d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800c91:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800c95:	89 ec                	mov    %ebp,%esp
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	83 ec 38             	sub    $0x38,%esp
  800c9f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ca2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ca5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ca8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cad:	b8 0f 00 00 00       	mov    $0xf,%eax
  800cb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb8:	89 df                	mov    %ebx,%edi
  800cba:	89 de                	mov    %ebx,%esi
  800cbc:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800cbe:	85 c0                	test   %eax,%eax
  800cc0:	7e 28                	jle    800cea <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800cc6:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800ccd:	00 
  800cce:	c7 44 24 08 3f 2c 80 	movl   $0x802c3f,0x8(%esp)
  800cd5:	00 
  800cd6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800cdd:	00 
  800cde:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  800ce5:	e8 72 17 00 00       	call   80245c <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800cea:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ced:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800cf0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800cf3:	89 ec                	mov    %ebp,%esp
  800cf5:	5d                   	pop    %ebp
  800cf6:	c3                   	ret    

00800cf7 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800cf7:	55                   	push   %ebp
  800cf8:	89 e5                	mov    %esp,%ebp
  800cfa:	83 ec 0c             	sub    $0xc,%esp
  800cfd:	89 1c 24             	mov    %ebx,(%esp)
  800d00:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d04:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d08:	ba 00 00 00 00       	mov    $0x0,%edx
  800d0d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d12:	89 d1                	mov    %edx,%ecx
  800d14:	89 d3                	mov    %edx,%ebx
  800d16:	89 d7                	mov    %edx,%edi
  800d18:	89 d6                	mov    %edx,%esi
  800d1a:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800d1c:	8b 1c 24             	mov    (%esp),%ebx
  800d1f:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d23:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d27:	89 ec                	mov    %ebp,%esp
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	83 ec 38             	sub    $0x38,%esp
  800d31:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800d34:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800d37:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d3a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d3f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d44:	8b 55 08             	mov    0x8(%ebp),%edx
  800d47:	89 cb                	mov    %ecx,%ebx
  800d49:	89 cf                	mov    %ecx,%edi
  800d4b:	89 ce                	mov    %ecx,%esi
  800d4d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	7e 28                	jle    800d7b <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800d53:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d57:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  800d5e:	00 
  800d5f:	c7 44 24 08 3f 2c 80 	movl   $0x802c3f,0x8(%esp)
  800d66:	00 
  800d67:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800d6e:	00 
  800d6f:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  800d76:	e8 e1 16 00 00       	call   80245c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d7b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800d7e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800d81:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800d84:	89 ec                	mov    %ebp,%esp
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    

00800d88 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 0c             	sub    $0xc,%esp
  800d8e:	89 1c 24             	mov    %ebx,(%esp)
  800d91:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d95:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800d99:	be 00 00 00 00       	mov    $0x0,%esi
  800d9e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800da3:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dac:	8b 55 08             	mov    0x8(%ebp),%edx
  800daf:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800db1:	8b 1c 24             	mov    (%esp),%ebx
  800db4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800db8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dbc:	89 ec                	mov    %ebp,%esp
  800dbe:	5d                   	pop    %ebp
  800dbf:	c3                   	ret    

00800dc0 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dc0:	55                   	push   %ebp
  800dc1:	89 e5                	mov    %esp,%ebp
  800dc3:	83 ec 38             	sub    $0x38,%esp
  800dc6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800dc9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800dcc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800dcf:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddf:	89 df                	mov    %ebx,%edi
  800de1:	89 de                	mov    %ebx,%esi
  800de3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800de5:	85 c0                	test   %eax,%eax
  800de7:	7e 28                	jle    800e11 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800de9:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ded:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800df4:	00 
  800df5:	c7 44 24 08 3f 2c 80 	movl   $0x802c3f,0x8(%esp)
  800dfc:	00 
  800dfd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e04:	00 
  800e05:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  800e0c:	e8 4b 16 00 00       	call   80245c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e11:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e14:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e17:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e1a:	89 ec                	mov    %ebp,%esp
  800e1c:	5d                   	pop    %ebp
  800e1d:	c3                   	ret    

00800e1e <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 38             	sub    $0x38,%esp
  800e24:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e27:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e2a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e32:	b8 09 00 00 00       	mov    $0x9,%eax
  800e37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3d:	89 df                	mov    %ebx,%edi
  800e3f:	89 de                	mov    %ebx,%esi
  800e41:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800e43:	85 c0                	test   %eax,%eax
  800e45:	7e 28                	jle    800e6f <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800e47:	89 44 24 10          	mov    %eax,0x10(%esp)
  800e4b:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  800e52:	00 
  800e53:	c7 44 24 08 3f 2c 80 	movl   $0x802c3f,0x8(%esp)
  800e5a:	00 
  800e5b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800e62:	00 
  800e63:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  800e6a:	e8 ed 15 00 00       	call   80245c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e6f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e72:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800e75:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800e78:	89 ec                	mov    %ebp,%esp
  800e7a:	5d                   	pop    %ebp
  800e7b:	c3                   	ret    

00800e7c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e7c:	55                   	push   %ebp
  800e7d:	89 e5                	mov    %esp,%ebp
  800e7f:	83 ec 38             	sub    $0x38,%esp
  800e82:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800e85:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800e88:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800e8b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e90:	b8 08 00 00 00       	mov    $0x8,%eax
  800e95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e98:	8b 55 08             	mov    0x8(%ebp),%edx
  800e9b:	89 df                	mov    %ebx,%edi
  800e9d:	89 de                	mov    %ebx,%esi
  800e9f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800ea1:	85 c0                	test   %eax,%eax
  800ea3:	7e 28                	jle    800ecd <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea5:	89 44 24 10          	mov    %eax,0x10(%esp)
  800ea9:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800eb0:	00 
  800eb1:	c7 44 24 08 3f 2c 80 	movl   $0x802c3f,0x8(%esp)
  800eb8:	00 
  800eb9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800ec0:	00 
  800ec1:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  800ec8:	e8 8f 15 00 00       	call   80245c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ecd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800ed0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800ed3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ed6:	89 ec                	mov    %ebp,%esp
  800ed8:	5d                   	pop    %ebp
  800ed9:	c3                   	ret    

00800eda <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	83 ec 38             	sub    $0x38,%esp
  800ee0:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ee3:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ee6:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ee9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eee:	b8 06 00 00 00       	mov    $0x6,%eax
  800ef3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ef6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef9:	89 df                	mov    %ebx,%edi
  800efb:	89 de                	mov    %ebx,%esi
  800efd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800eff:	85 c0                	test   %eax,%eax
  800f01:	7e 28                	jle    800f2b <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f03:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f07:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  800f0e:	00 
  800f0f:	c7 44 24 08 3f 2c 80 	movl   $0x802c3f,0x8(%esp)
  800f16:	00 
  800f17:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f1e:	00 
  800f1f:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  800f26:	e8 31 15 00 00       	call   80245c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f2b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f2e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f31:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f34:	89 ec                	mov    %ebp,%esp
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 38             	sub    $0x38,%esp
  800f3e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f41:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f44:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f47:	b8 05 00 00 00       	mov    $0x5,%eax
  800f4c:	8b 75 18             	mov    0x18(%ebp),%esi
  800f4f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f52:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f55:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f58:	8b 55 08             	mov    0x8(%ebp),%edx
  800f5b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f5d:	85 c0                	test   %eax,%eax
  800f5f:	7e 28                	jle    800f89 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f61:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f65:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800f6c:	00 
  800f6d:	c7 44 24 08 3f 2c 80 	movl   $0x802c3f,0x8(%esp)
  800f74:	00 
  800f75:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800f7c:	00 
  800f7d:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  800f84:	e8 d3 14 00 00       	call   80245c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f89:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800f8c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800f8f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800f92:	89 ec                	mov    %ebp,%esp
  800f94:	5d                   	pop    %ebp
  800f95:	c3                   	ret    

00800f96 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800f96:	55                   	push   %ebp
  800f97:	89 e5                	mov    %esp,%ebp
  800f99:	83 ec 38             	sub    $0x38,%esp
  800f9c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f9f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800fa2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fa5:	be 00 00 00 00       	mov    $0x0,%esi
  800faa:	b8 04 00 00 00       	mov    $0x4,%eax
  800faf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fb2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb8:	89 f7                	mov    %esi,%edi
  800fba:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fbc:	85 c0                	test   %eax,%eax
  800fbe:	7e 28                	jle    800fe8 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fc0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fc4:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800fcb:	00 
  800fcc:	c7 44 24 08 3f 2c 80 	movl   $0x802c3f,0x8(%esp)
  800fd3:	00 
  800fd4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fdb:	00 
  800fdc:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  800fe3:	e8 74 14 00 00       	call   80245c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800fe8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800feb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fee:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800ff1:	89 ec                	mov    %ebp,%esp
  800ff3:	5d                   	pop    %ebp
  800ff4:	c3                   	ret    

00800ff5 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
  800ff8:	83 ec 0c             	sub    $0xc,%esp
  800ffb:	89 1c 24             	mov    %ebx,(%esp)
  800ffe:	89 74 24 04          	mov    %esi,0x4(%esp)
  801002:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801006:	ba 00 00 00 00       	mov    $0x0,%edx
  80100b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801010:	89 d1                	mov    %edx,%ecx
  801012:	89 d3                	mov    %edx,%ebx
  801014:	89 d7                	mov    %edx,%edi
  801016:	89 d6                	mov    %edx,%esi
  801018:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80101a:	8b 1c 24             	mov    (%esp),%ebx
  80101d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801021:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801025:	89 ec                	mov    %ebp,%esp
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 0c             	sub    $0xc,%esp
  80102f:	89 1c 24             	mov    %ebx,(%esp)
  801032:	89 74 24 04          	mov    %esi,0x4(%esp)
  801036:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80103a:	ba 00 00 00 00       	mov    $0x0,%edx
  80103f:	b8 02 00 00 00       	mov    $0x2,%eax
  801044:	89 d1                	mov    %edx,%ecx
  801046:	89 d3                	mov    %edx,%ebx
  801048:	89 d7                	mov    %edx,%edi
  80104a:	89 d6                	mov    %edx,%esi
  80104c:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80104e:	8b 1c 24             	mov    (%esp),%ebx
  801051:	8b 74 24 04          	mov    0x4(%esp),%esi
  801055:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801059:	89 ec                	mov    %ebp,%esp
  80105b:	5d                   	pop    %ebp
  80105c:	c3                   	ret    

0080105d <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	83 ec 38             	sub    $0x38,%esp
  801063:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801066:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801069:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80106c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801071:	b8 03 00 00 00       	mov    $0x3,%eax
  801076:	8b 55 08             	mov    0x8(%ebp),%edx
  801079:	89 cb                	mov    %ecx,%ebx
  80107b:	89 cf                	mov    %ecx,%edi
  80107d:	89 ce                	mov    %ecx,%esi
  80107f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801081:	85 c0                	test   %eax,%eax
  801083:	7e 28                	jle    8010ad <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801085:	89 44 24 10          	mov    %eax,0x10(%esp)
  801089:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801090:	00 
  801091:	c7 44 24 08 3f 2c 80 	movl   $0x802c3f,0x8(%esp)
  801098:	00 
  801099:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010a0:	00 
  8010a1:	c7 04 24 5c 2c 80 00 	movl   $0x802c5c,(%esp)
  8010a8:	e8 af 13 00 00       	call   80245c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8010ad:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010b0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010b3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010b6:	89 ec                	mov    %ebp,%esp
  8010b8:	5d                   	pop    %ebp
  8010b9:	c3                   	ret    
  8010ba:	00 00                	add    %al,(%eax)
  8010bc:	00 00                	add    %al,(%eax)
	...

008010c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010c0:	55                   	push   %ebp
  8010c1:	89 e5                	mov    %esp,%ebp
  8010c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c6:	05 00 00 00 30       	add    $0x30000000,%eax
  8010cb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8010ce:	5d                   	pop    %ebp
  8010cf:	c3                   	ret    

008010d0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010d0:	55                   	push   %ebp
  8010d1:	89 e5                	mov    %esp,%ebp
  8010d3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8010d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d9:	89 04 24             	mov    %eax,(%esp)
  8010dc:	e8 df ff ff ff       	call   8010c0 <fd2num>
  8010e1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8010e6:	c1 e0 0c             	shl    $0xc,%eax
}
  8010e9:	c9                   	leave  
  8010ea:	c3                   	ret    

008010eb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	57                   	push   %edi
  8010ef:	56                   	push   %esi
  8010f0:	53                   	push   %ebx
  8010f1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8010f4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8010f9:	a8 01                	test   $0x1,%al
  8010fb:	74 36                	je     801133 <fd_alloc+0x48>
  8010fd:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801102:	a8 01                	test   $0x1,%al
  801104:	74 2d                	je     801133 <fd_alloc+0x48>
  801106:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80110b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801110:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801115:	89 c3                	mov    %eax,%ebx
  801117:	89 c2                	mov    %eax,%edx
  801119:	c1 ea 16             	shr    $0x16,%edx
  80111c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80111f:	f6 c2 01             	test   $0x1,%dl
  801122:	74 14                	je     801138 <fd_alloc+0x4d>
  801124:	89 c2                	mov    %eax,%edx
  801126:	c1 ea 0c             	shr    $0xc,%edx
  801129:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80112c:	f6 c2 01             	test   $0x1,%dl
  80112f:	75 10                	jne    801141 <fd_alloc+0x56>
  801131:	eb 05                	jmp    801138 <fd_alloc+0x4d>
  801133:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801138:	89 1f                	mov    %ebx,(%edi)
  80113a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80113f:	eb 17                	jmp    801158 <fd_alloc+0x6d>
  801141:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801146:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80114b:	75 c8                	jne    801115 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80114d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801153:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801158:	5b                   	pop    %ebx
  801159:	5e                   	pop    %esi
  80115a:	5f                   	pop    %edi
  80115b:	5d                   	pop    %ebp
  80115c:	c3                   	ret    

0080115d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80115d:	55                   	push   %ebp
  80115e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801160:	8b 45 08             	mov    0x8(%ebp),%eax
  801163:	83 f8 1f             	cmp    $0x1f,%eax
  801166:	77 36                	ja     80119e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801168:	05 00 00 0d 00       	add    $0xd0000,%eax
  80116d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801170:	89 c2                	mov    %eax,%edx
  801172:	c1 ea 16             	shr    $0x16,%edx
  801175:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80117c:	f6 c2 01             	test   $0x1,%dl
  80117f:	74 1d                	je     80119e <fd_lookup+0x41>
  801181:	89 c2                	mov    %eax,%edx
  801183:	c1 ea 0c             	shr    $0xc,%edx
  801186:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80118d:	f6 c2 01             	test   $0x1,%dl
  801190:	74 0c                	je     80119e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801192:	8b 55 0c             	mov    0xc(%ebp),%edx
  801195:	89 02                	mov    %eax,(%edx)
  801197:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80119c:	eb 05                	jmp    8011a3 <fd_lookup+0x46>
  80119e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011a3:	5d                   	pop    %ebp
  8011a4:	c3                   	ret    

008011a5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011ab:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8011ae:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b5:	89 04 24             	mov    %eax,(%esp)
  8011b8:	e8 a0 ff ff ff       	call   80115d <fd_lookup>
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	78 0e                	js     8011cf <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8011c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011c7:	89 50 04             	mov    %edx,0x4(%eax)
  8011ca:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8011cf:	c9                   	leave  
  8011d0:	c3                   	ret    

008011d1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011d1:	55                   	push   %ebp
  8011d2:	89 e5                	mov    %esp,%ebp
  8011d4:	56                   	push   %esi
  8011d5:	53                   	push   %ebx
  8011d6:	83 ec 10             	sub    $0x10,%esp
  8011d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8011df:	b8 30 60 80 00       	mov    $0x806030,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  8011e4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8011e9:	be ec 2c 80 00       	mov    $0x802cec,%esi
		if (devtab[i]->dev_id == dev_id) {
  8011ee:	39 08                	cmp    %ecx,(%eax)
  8011f0:	75 10                	jne    801202 <dev_lookup+0x31>
  8011f2:	eb 04                	jmp    8011f8 <dev_lookup+0x27>
  8011f4:	39 08                	cmp    %ecx,(%eax)
  8011f6:	75 0a                	jne    801202 <dev_lookup+0x31>
			*dev = devtab[i];
  8011f8:	89 03                	mov    %eax,(%ebx)
  8011fa:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8011ff:	90                   	nop
  801200:	eb 31                	jmp    801233 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801202:	83 c2 01             	add    $0x1,%edx
  801205:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801208:	85 c0                	test   %eax,%eax
  80120a:	75 e8                	jne    8011f4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80120c:	a1 a0 60 80 00       	mov    0x8060a0,%eax
  801211:	8b 40 4c             	mov    0x4c(%eax),%eax
  801214:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801218:	89 44 24 04          	mov    %eax,0x4(%esp)
  80121c:	c7 04 24 6c 2c 80 00 	movl   $0x802c6c,(%esp)
  801223:	e8 31 ef ff ff       	call   800159 <cprintf>
	*dev = 0;
  801228:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80122e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801233:	83 c4 10             	add    $0x10,%esp
  801236:	5b                   	pop    %ebx
  801237:	5e                   	pop    %esi
  801238:	5d                   	pop    %ebp
  801239:	c3                   	ret    

0080123a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80123a:	55                   	push   %ebp
  80123b:	89 e5                	mov    %esp,%ebp
  80123d:	53                   	push   %ebx
  80123e:	83 ec 24             	sub    $0x24,%esp
  801241:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801244:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801247:	89 44 24 04          	mov    %eax,0x4(%esp)
  80124b:	8b 45 08             	mov    0x8(%ebp),%eax
  80124e:	89 04 24             	mov    %eax,(%esp)
  801251:	e8 07 ff ff ff       	call   80115d <fd_lookup>
  801256:	85 c0                	test   %eax,%eax
  801258:	78 53                	js     8012ad <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80125a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80125d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801261:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801264:	8b 00                	mov    (%eax),%eax
  801266:	89 04 24             	mov    %eax,(%esp)
  801269:	e8 63 ff ff ff       	call   8011d1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80126e:	85 c0                	test   %eax,%eax
  801270:	78 3b                	js     8012ad <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801272:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801277:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80127a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80127e:	74 2d                	je     8012ad <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801280:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801283:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80128a:	00 00 00 
	stat->st_isdir = 0;
  80128d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801294:	00 00 00 
	stat->st_dev = dev;
  801297:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80129a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012a7:	89 14 24             	mov    %edx,(%esp)
  8012aa:	ff 50 14             	call   *0x14(%eax)
}
  8012ad:	83 c4 24             	add    $0x24,%esp
  8012b0:	5b                   	pop    %ebx
  8012b1:	5d                   	pop    %ebp
  8012b2:	c3                   	ret    

008012b3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
  8012b6:	53                   	push   %ebx
  8012b7:	83 ec 24             	sub    $0x24,%esp
  8012ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012c4:	89 1c 24             	mov    %ebx,(%esp)
  8012c7:	e8 91 fe ff ff       	call   80115d <fd_lookup>
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	78 5f                	js     80132f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012da:	8b 00                	mov    (%eax),%eax
  8012dc:	89 04 24             	mov    %eax,(%esp)
  8012df:	e8 ed fe ff ff       	call   8011d1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	78 47                	js     80132f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012e8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8012eb:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8012ef:	75 23                	jne    801314 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8012f1:	a1 a0 60 80 00       	mov    0x8060a0,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8012f6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8012f9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801301:	c7 04 24 8c 2c 80 00 	movl   $0x802c8c,(%esp)
  801308:	e8 4c ee ff ff       	call   800159 <cprintf>
  80130d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801312:	eb 1b                	jmp    80132f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801317:	8b 48 18             	mov    0x18(%eax),%ecx
  80131a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80131f:	85 c9                	test   %ecx,%ecx
  801321:	74 0c                	je     80132f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801323:	8b 45 0c             	mov    0xc(%ebp),%eax
  801326:	89 44 24 04          	mov    %eax,0x4(%esp)
  80132a:	89 14 24             	mov    %edx,(%esp)
  80132d:	ff d1                	call   *%ecx
}
  80132f:	83 c4 24             	add    $0x24,%esp
  801332:	5b                   	pop    %ebx
  801333:	5d                   	pop    %ebp
  801334:	c3                   	ret    

00801335 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	53                   	push   %ebx
  801339:	83 ec 24             	sub    $0x24,%esp
  80133c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80133f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801342:	89 44 24 04          	mov    %eax,0x4(%esp)
  801346:	89 1c 24             	mov    %ebx,(%esp)
  801349:	e8 0f fe ff ff       	call   80115d <fd_lookup>
  80134e:	85 c0                	test   %eax,%eax
  801350:	78 66                	js     8013b8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801352:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801355:	89 44 24 04          	mov    %eax,0x4(%esp)
  801359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135c:	8b 00                	mov    (%eax),%eax
  80135e:	89 04 24             	mov    %eax,(%esp)
  801361:	e8 6b fe ff ff       	call   8011d1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801366:	85 c0                	test   %eax,%eax
  801368:	78 4e                	js     8013b8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80136a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80136d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801371:	75 23                	jne    801396 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801373:	a1 a0 60 80 00       	mov    0x8060a0,%eax
  801378:	8b 40 4c             	mov    0x4c(%eax),%eax
  80137b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80137f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801383:	c7 04 24 b0 2c 80 00 	movl   $0x802cb0,(%esp)
  80138a:	e8 ca ed ff ff       	call   800159 <cprintf>
  80138f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801394:	eb 22                	jmp    8013b8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801399:	8b 48 0c             	mov    0xc(%eax),%ecx
  80139c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013a1:	85 c9                	test   %ecx,%ecx
  8013a3:	74 13                	je     8013b8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013a8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013b3:	89 14 24             	mov    %edx,(%esp)
  8013b6:	ff d1                	call   *%ecx
}
  8013b8:	83 c4 24             	add    $0x24,%esp
  8013bb:	5b                   	pop    %ebx
  8013bc:	5d                   	pop    %ebp
  8013bd:	c3                   	ret    

008013be <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013be:	55                   	push   %ebp
  8013bf:	89 e5                	mov    %esp,%ebp
  8013c1:	53                   	push   %ebx
  8013c2:	83 ec 24             	sub    $0x24,%esp
  8013c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013c8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013cf:	89 1c 24             	mov    %ebx,(%esp)
  8013d2:	e8 86 fd ff ff       	call   80115d <fd_lookup>
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	78 6b                	js     801446 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013db:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e5:	8b 00                	mov    (%eax),%eax
  8013e7:	89 04 24             	mov    %eax,(%esp)
  8013ea:	e8 e2 fd ff ff       	call   8011d1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013ef:	85 c0                	test   %eax,%eax
  8013f1:	78 53                	js     801446 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013f6:	8b 42 08             	mov    0x8(%edx),%eax
  8013f9:	83 e0 03             	and    $0x3,%eax
  8013fc:	83 f8 01             	cmp    $0x1,%eax
  8013ff:	75 23                	jne    801424 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801401:	a1 a0 60 80 00       	mov    0x8060a0,%eax
  801406:	8b 40 4c             	mov    0x4c(%eax),%eax
  801409:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80140d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801411:	c7 04 24 cd 2c 80 00 	movl   $0x802ccd,(%esp)
  801418:	e8 3c ed ff ff       	call   800159 <cprintf>
  80141d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801422:	eb 22                	jmp    801446 <read+0x88>
	}
	if (!dev->dev_read)
  801424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801427:	8b 48 08             	mov    0x8(%eax),%ecx
  80142a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80142f:	85 c9                	test   %ecx,%ecx
  801431:	74 13                	je     801446 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801433:	8b 45 10             	mov    0x10(%ebp),%eax
  801436:	89 44 24 08          	mov    %eax,0x8(%esp)
  80143a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801441:	89 14 24             	mov    %edx,(%esp)
  801444:	ff d1                	call   *%ecx
}
  801446:	83 c4 24             	add    $0x24,%esp
  801449:	5b                   	pop    %ebx
  80144a:	5d                   	pop    %ebp
  80144b:	c3                   	ret    

0080144c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	57                   	push   %edi
  801450:	56                   	push   %esi
  801451:	53                   	push   %ebx
  801452:	83 ec 1c             	sub    $0x1c,%esp
  801455:	8b 7d 08             	mov    0x8(%ebp),%edi
  801458:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80145b:	ba 00 00 00 00       	mov    $0x0,%edx
  801460:	bb 00 00 00 00       	mov    $0x0,%ebx
  801465:	b8 00 00 00 00       	mov    $0x0,%eax
  80146a:	85 f6                	test   %esi,%esi
  80146c:	74 29                	je     801497 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80146e:	89 f0                	mov    %esi,%eax
  801470:	29 d0                	sub    %edx,%eax
  801472:	89 44 24 08          	mov    %eax,0x8(%esp)
  801476:	03 55 0c             	add    0xc(%ebp),%edx
  801479:	89 54 24 04          	mov    %edx,0x4(%esp)
  80147d:	89 3c 24             	mov    %edi,(%esp)
  801480:	e8 39 ff ff ff       	call   8013be <read>
		if (m < 0)
  801485:	85 c0                	test   %eax,%eax
  801487:	78 0e                	js     801497 <readn+0x4b>
			return m;
		if (m == 0)
  801489:	85 c0                	test   %eax,%eax
  80148b:	74 08                	je     801495 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80148d:	01 c3                	add    %eax,%ebx
  80148f:	89 da                	mov    %ebx,%edx
  801491:	39 f3                	cmp    %esi,%ebx
  801493:	72 d9                	jb     80146e <readn+0x22>
  801495:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801497:	83 c4 1c             	add    $0x1c,%esp
  80149a:	5b                   	pop    %ebx
  80149b:	5e                   	pop    %esi
  80149c:	5f                   	pop    %edi
  80149d:	5d                   	pop    %ebp
  80149e:	c3                   	ret    

0080149f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80149f:	55                   	push   %ebp
  8014a0:	89 e5                	mov    %esp,%ebp
  8014a2:	56                   	push   %esi
  8014a3:	53                   	push   %ebx
  8014a4:	83 ec 20             	sub    $0x20,%esp
  8014a7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014aa:	89 34 24             	mov    %esi,(%esp)
  8014ad:	e8 0e fc ff ff       	call   8010c0 <fd2num>
  8014b2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8014b5:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014b9:	89 04 24             	mov    %eax,(%esp)
  8014bc:	e8 9c fc ff ff       	call   80115d <fd_lookup>
  8014c1:	89 c3                	mov    %eax,%ebx
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	78 05                	js     8014cc <fd_close+0x2d>
  8014c7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8014ca:	74 0c                	je     8014d8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8014cc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8014d0:	19 c0                	sbb    %eax,%eax
  8014d2:	f7 d0                	not    %eax
  8014d4:	21 c3                	and    %eax,%ebx
  8014d6:	eb 3d                	jmp    801515 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8014d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014df:	8b 06                	mov    (%esi),%eax
  8014e1:	89 04 24             	mov    %eax,(%esp)
  8014e4:	e8 e8 fc ff ff       	call   8011d1 <dev_lookup>
  8014e9:	89 c3                	mov    %eax,%ebx
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	78 16                	js     801505 <fd_close+0x66>
		if (dev->dev_close)
  8014ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f2:	8b 40 10             	mov    0x10(%eax),%eax
  8014f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8014fa:	85 c0                	test   %eax,%eax
  8014fc:	74 07                	je     801505 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  8014fe:	89 34 24             	mov    %esi,(%esp)
  801501:	ff d0                	call   *%eax
  801503:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801505:	89 74 24 04          	mov    %esi,0x4(%esp)
  801509:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801510:	e8 c5 f9 ff ff       	call   800eda <sys_page_unmap>
	return r;
}
  801515:	89 d8                	mov    %ebx,%eax
  801517:	83 c4 20             	add    $0x20,%esp
  80151a:	5b                   	pop    %ebx
  80151b:	5e                   	pop    %esi
  80151c:	5d                   	pop    %ebp
  80151d:	c3                   	ret    

0080151e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801524:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801527:	89 44 24 04          	mov    %eax,0x4(%esp)
  80152b:	8b 45 08             	mov    0x8(%ebp),%eax
  80152e:	89 04 24             	mov    %eax,(%esp)
  801531:	e8 27 fc ff ff       	call   80115d <fd_lookup>
  801536:	85 c0                	test   %eax,%eax
  801538:	78 13                	js     80154d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80153a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801541:	00 
  801542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801545:	89 04 24             	mov    %eax,(%esp)
  801548:	e8 52 ff ff ff       	call   80149f <fd_close>
}
  80154d:	c9                   	leave  
  80154e:	c3                   	ret    

0080154f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	83 ec 18             	sub    $0x18,%esp
  801555:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801558:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80155b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801562:	00 
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	89 04 24             	mov    %eax,(%esp)
  801569:	e8 a9 03 00 00       	call   801917 <open>
  80156e:	89 c3                	mov    %eax,%ebx
  801570:	85 c0                	test   %eax,%eax
  801572:	78 1b                	js     80158f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801574:	8b 45 0c             	mov    0xc(%ebp),%eax
  801577:	89 44 24 04          	mov    %eax,0x4(%esp)
  80157b:	89 1c 24             	mov    %ebx,(%esp)
  80157e:	e8 b7 fc ff ff       	call   80123a <fstat>
  801583:	89 c6                	mov    %eax,%esi
	close(fd);
  801585:	89 1c 24             	mov    %ebx,(%esp)
  801588:	e8 91 ff ff ff       	call   80151e <close>
  80158d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80158f:	89 d8                	mov    %ebx,%eax
  801591:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801594:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801597:	89 ec                	mov    %ebp,%esp
  801599:	5d                   	pop    %ebp
  80159a:	c3                   	ret    

0080159b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	53                   	push   %ebx
  80159f:	83 ec 14             	sub    $0x14,%esp
  8015a2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  8015a7:	89 1c 24             	mov    %ebx,(%esp)
  8015aa:	e8 6f ff ff ff       	call   80151e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  8015af:	83 c3 01             	add    $0x1,%ebx
  8015b2:	83 fb 20             	cmp    $0x20,%ebx
  8015b5:	75 f0                	jne    8015a7 <close_all+0xc>
		close(i);
}
  8015b7:	83 c4 14             	add    $0x14,%esp
  8015ba:	5b                   	pop    %ebx
  8015bb:	5d                   	pop    %ebp
  8015bc:	c3                   	ret    

008015bd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 58             	sub    $0x58,%esp
  8015c3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015c6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015c9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8015cc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015cf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d9:	89 04 24             	mov    %eax,(%esp)
  8015dc:	e8 7c fb ff ff       	call   80115d <fd_lookup>
  8015e1:	89 c3                	mov    %eax,%ebx
  8015e3:	85 c0                	test   %eax,%eax
  8015e5:	0f 88 e0 00 00 00    	js     8016cb <dup+0x10e>
		return r;
	close(newfdnum);
  8015eb:	89 3c 24             	mov    %edi,(%esp)
  8015ee:	e8 2b ff ff ff       	call   80151e <close>

	newfd = INDEX2FD(newfdnum);
  8015f3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8015f9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8015fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8015ff:	89 04 24             	mov    %eax,(%esp)
  801602:	e8 c9 fa ff ff       	call   8010d0 <fd2data>
  801607:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801609:	89 34 24             	mov    %esi,(%esp)
  80160c:	e8 bf fa ff ff       	call   8010d0 <fd2data>
  801611:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801614:	89 da                	mov    %ebx,%edx
  801616:	89 d8                	mov    %ebx,%eax
  801618:	c1 e8 16             	shr    $0x16,%eax
  80161b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801622:	a8 01                	test   $0x1,%al
  801624:	74 43                	je     801669 <dup+0xac>
  801626:	c1 ea 0c             	shr    $0xc,%edx
  801629:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801630:	a8 01                	test   $0x1,%al
  801632:	74 35                	je     801669 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801634:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80163b:	25 07 0e 00 00       	and    $0xe07,%eax
  801640:	89 44 24 10          	mov    %eax,0x10(%esp)
  801644:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801647:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80164b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801652:	00 
  801653:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801657:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80165e:	e8 d5 f8 ff ff       	call   800f38 <sys_page_map>
  801663:	89 c3                	mov    %eax,%ebx
  801665:	85 c0                	test   %eax,%eax
  801667:	78 3f                	js     8016a8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801669:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80166c:	89 c2                	mov    %eax,%edx
  80166e:	c1 ea 0c             	shr    $0xc,%edx
  801671:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801678:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80167e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801682:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801686:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80168d:	00 
  80168e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801692:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801699:	e8 9a f8 ff ff       	call   800f38 <sys_page_map>
  80169e:	89 c3                	mov    %eax,%ebx
  8016a0:	85 c0                	test   %eax,%eax
  8016a2:	78 04                	js     8016a8 <dup+0xeb>
  8016a4:	89 fb                	mov    %edi,%ebx
  8016a6:	eb 23                	jmp    8016cb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8016a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016ac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016b3:	e8 22 f8 ff ff       	call   800eda <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016b8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8016bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016c6:	e8 0f f8 ff ff       	call   800eda <sys_page_unmap>
	return r;
}
  8016cb:	89 d8                	mov    %ebx,%eax
  8016cd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8016d0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8016d3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8016d6:	89 ec                	mov    %ebp,%esp
  8016d8:	5d                   	pop    %ebp
  8016d9:	c3                   	ret    
	...

008016dc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8016dc:	55                   	push   %ebp
  8016dd:	89 e5                	mov    %esp,%ebp
  8016df:	53                   	push   %ebx
  8016e0:	83 ec 14             	sub    $0x14,%esp
  8016e3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8016e5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  8016eb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8016f2:	00 
  8016f3:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  8016fa:	00 
  8016fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ff:	89 14 24             	mov    %edx,(%esp)
  801702:	e8 b9 0d 00 00       	call   8024c0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801707:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80170e:	00 
  80170f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801713:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80171a:	e8 03 0e 00 00       	call   802522 <ipc_recv>
}
  80171f:	83 c4 14             	add    $0x14,%esp
  801722:	5b                   	pop    %ebx
  801723:	5d                   	pop    %ebp
  801724:	c3                   	ret    

00801725 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80172b:	8b 45 08             	mov    0x8(%ebp),%eax
  80172e:	8b 40 0c             	mov    0xc(%eax),%eax
  801731:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  801736:	8b 45 0c             	mov    0xc(%ebp),%eax
  801739:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80173e:	ba 00 00 00 00       	mov    $0x0,%edx
  801743:	b8 02 00 00 00       	mov    $0x2,%eax
  801748:	e8 8f ff ff ff       	call   8016dc <fsipc>
}
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
  801752:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801755:	ba 00 00 00 00       	mov    $0x0,%edx
  80175a:	b8 08 00 00 00       	mov    $0x8,%eax
  80175f:	e8 78 ff ff ff       	call   8016dc <fsipc>
}
  801764:	c9                   	leave  
  801765:	c3                   	ret    

00801766 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801766:	55                   	push   %ebp
  801767:	89 e5                	mov    %esp,%ebp
  801769:	53                   	push   %ebx
  80176a:	83 ec 14             	sub    $0x14,%esp
  80176d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801770:	8b 45 08             	mov    0x8(%ebp),%eax
  801773:	8b 40 0c             	mov    0xc(%eax),%eax
  801776:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80177b:	ba 00 00 00 00       	mov    $0x0,%edx
  801780:	b8 05 00 00 00       	mov    $0x5,%eax
  801785:	e8 52 ff ff ff       	call   8016dc <fsipc>
  80178a:	85 c0                	test   %eax,%eax
  80178c:	78 2b                	js     8017b9 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80178e:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801795:	00 
  801796:	89 1c 24             	mov    %ebx,(%esp)
  801799:	e8 9c f0 ff ff       	call   80083a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80179e:	a1 80 30 80 00       	mov    0x803080,%eax
  8017a3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8017a9:	a1 84 30 80 00       	mov    0x803084,%eax
  8017ae:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  8017b4:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8017b9:	83 c4 14             	add    $0x14,%esp
  8017bc:	5b                   	pop    %ebx
  8017bd:	5d                   	pop    %ebp
  8017be:	c3                   	ret    

008017bf <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
  8017c2:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  8017c5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8017cc:	00 
  8017cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8017d4:	00 
  8017d5:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  8017dc:	e8 b5 f1 ff ff       	call   800996 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8017e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8017e7:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  8017ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f1:	b8 06 00 00 00       	mov    $0x6,%eax
  8017f6:	e8 e1 fe ff ff       	call   8016dc <fsipc>
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    

008017fd <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801803:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80180a:	00 
  80180b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801812:	00 
  801813:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  80181a:	e8 77 f1 ff ff       	call   800996 <memset>
  80181f:	8b 45 10             	mov    0x10(%ebp),%eax
  801822:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801827:	76 05                	jbe    80182e <devfile_write+0x31>
  801829:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80182e:	8b 55 08             	mov    0x8(%ebp),%edx
  801831:	8b 52 0c             	mov    0xc(%edx),%edx
  801834:	89 15 00 30 80 00    	mov    %edx,0x803000
        fsipcbuf.write.req_n = numberOfBytes;
  80183a:	a3 04 30 80 00       	mov    %eax,0x803004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  80183f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801843:	8b 45 0c             	mov    0xc(%ebp),%eax
  801846:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184a:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  801851:	e8 9f f1 ff ff       	call   8009f5 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  801856:	ba 00 00 00 00       	mov    $0x0,%edx
  80185b:	b8 04 00 00 00       	mov    $0x4,%eax
  801860:	e8 77 fe ff ff       	call   8016dc <fsipc>
              return r;
        return r;
}
  801865:	c9                   	leave  
  801866:	c3                   	ret    

00801867 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	53                   	push   %ebx
  80186b:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  80186e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801875:	00 
  801876:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80187d:	00 
  80187e:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801885:	e8 0c f1 ff ff       	call   800996 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	8b 40 0c             	mov    0xc(%eax),%eax
  801890:	a3 00 30 80 00       	mov    %eax,0x803000
        fsipcbuf.read.req_n = n;
  801895:	8b 45 10             	mov    0x10(%ebp),%eax
  801898:	a3 04 30 80 00       	mov    %eax,0x803004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  80189d:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a2:	b8 03 00 00 00       	mov    $0x3,%eax
  8018a7:	e8 30 fe ff ff       	call   8016dc <fsipc>
  8018ac:	89 c3                	mov    %eax,%ebx
  8018ae:	85 c0                	test   %eax,%eax
  8018b0:	78 17                	js     8018c9 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  8018b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8018b6:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  8018bd:	00 
  8018be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c1:	89 04 24             	mov    %eax,(%esp)
  8018c4:	e8 2c f1 ff ff       	call   8009f5 <memmove>
        return r;
}
  8018c9:	89 d8                	mov    %ebx,%eax
  8018cb:	83 c4 14             	add    $0x14,%esp
  8018ce:	5b                   	pop    %ebx
  8018cf:	5d                   	pop    %ebp
  8018d0:	c3                   	ret    

008018d1 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
  8018d4:	53                   	push   %ebx
  8018d5:	83 ec 14             	sub    $0x14,%esp
  8018d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  8018db:	89 1c 24             	mov    %ebx,(%esp)
  8018de:	e8 0d ef ff ff       	call   8007f0 <strlen>
  8018e3:	89 c2                	mov    %eax,%edx
  8018e5:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8018ea:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  8018f0:	7f 1f                	jg     801911 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  8018f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018f6:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  8018fd:	e8 38 ef ff ff       	call   80083a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801902:	ba 00 00 00 00       	mov    $0x0,%edx
  801907:	b8 07 00 00 00       	mov    $0x7,%eax
  80190c:	e8 cb fd ff ff       	call   8016dc <fsipc>
}
  801911:	83 c4 14             	add    $0x14,%esp
  801914:	5b                   	pop    %ebx
  801915:	5d                   	pop    %ebp
  801916:	c3                   	ret    

00801917 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	56                   	push   %esi
  80191b:	53                   	push   %ebx
  80191c:	83 ec 20             	sub    $0x20,%esp
  80191f:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  801922:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801929:	00 
  80192a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801931:	00 
  801932:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801939:	e8 58 f0 ff ff       	call   800996 <memset>
    if(strlen(path)>=MAXPATHLEN)
  80193e:	89 34 24             	mov    %esi,(%esp)
  801941:	e8 aa ee ff ff       	call   8007f0 <strlen>
  801946:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80194b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801950:	0f 8f 84 00 00 00    	jg     8019da <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  801956:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801959:	89 04 24             	mov    %eax,(%esp)
  80195c:	e8 8a f7 ff ff       	call   8010eb <fd_alloc>
  801961:	89 c3                	mov    %eax,%ebx
  801963:	85 c0                	test   %eax,%eax
  801965:	78 73                	js     8019da <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  801967:	0f b6 06             	movzbl (%esi),%eax
  80196a:	84 c0                	test   %al,%al
  80196c:	74 20                	je     80198e <open+0x77>
  80196e:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  801970:	0f be c0             	movsbl %al,%eax
  801973:	89 44 24 04          	mov    %eax,0x4(%esp)
  801977:	c7 04 24 00 2d 80 00 	movl   $0x802d00,(%esp)
  80197e:	e8 d6 e7 ff ff       	call   800159 <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  801983:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  801987:	83 c3 01             	add    $0x1,%ebx
  80198a:	84 c0                	test   %al,%al
  80198c:	75 e2                	jne    801970 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  80198e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801992:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801999:	e8 9c ee ff ff       	call   80083a <strcpy>
    fsipcbuf.open.req_omode = mode;
  80199e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a1:	a3 00 34 80 00       	mov    %eax,0x803400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  8019a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ae:	e8 29 fd ff ff       	call   8016dc <fsipc>
  8019b3:	89 c3                	mov    %eax,%ebx
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	79 15                	jns    8019ce <open+0xb7>
        {
            fd_close(fd,1);
  8019b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8019c0:	00 
  8019c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c4:	89 04 24             	mov    %eax,(%esp)
  8019c7:	e8 d3 fa ff ff       	call   80149f <fd_close>
             return r;
  8019cc:	eb 0c                	jmp    8019da <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  8019ce:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8019d1:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  8019d7:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  8019da:	89 d8                	mov    %ebx,%eax
  8019dc:	83 c4 20             	add    $0x20,%esp
  8019df:	5b                   	pop    %ebx
  8019e0:	5e                   	pop    %esi
  8019e1:	5d                   	pop    %ebp
  8019e2:	c3                   	ret    
	...

008019f0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
  8019f3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8019f6:	c7 44 24 04 03 2d 80 	movl   $0x802d03,0x4(%esp)
  8019fd:	00 
  8019fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a01:	89 04 24             	mov    %eax,(%esp)
  801a04:	e8 31 ee ff ff       	call   80083a <strcpy>
	return 0;
}
  801a09:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	8b 40 0c             	mov    0xc(%eax),%eax
  801a1c:	89 04 24             	mov    %eax,(%esp)
  801a1f:	e8 9e 02 00 00       	call   801cc2 <nsipc_close>
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
  801a29:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801a2c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a33:	00 
  801a34:	8b 45 10             	mov    0x10(%ebp),%eax
  801a37:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	8b 40 0c             	mov    0xc(%eax),%eax
  801a48:	89 04 24             	mov    %eax,(%esp)
  801a4b:	e8 ae 02 00 00       	call   801cfe <nsipc_send>
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    

00801a52 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801a52:	55                   	push   %ebp
  801a53:	89 e5                	mov    %esp,%ebp
  801a55:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801a58:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801a5f:	00 
  801a60:	8b 45 10             	mov    0x10(%ebp),%eax
  801a63:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	8b 40 0c             	mov    0xc(%eax),%eax
  801a74:	89 04 24             	mov    %eax,(%esp)
  801a77:	e8 f5 02 00 00       	call   801d71 <nsipc_recv>
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
  801a81:	56                   	push   %esi
  801a82:	53                   	push   %ebx
  801a83:	83 ec 20             	sub    $0x20,%esp
  801a86:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801a88:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a8b:	89 04 24             	mov    %eax,(%esp)
  801a8e:	e8 58 f6 ff ff       	call   8010eb <fd_alloc>
  801a93:	89 c3                	mov    %eax,%ebx
  801a95:	85 c0                	test   %eax,%eax
  801a97:	78 21                	js     801aba <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801a99:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801aa0:	00 
  801aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aaf:	e8 e2 f4 ff ff       	call   800f96 <sys_page_alloc>
  801ab4:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801ab6:	85 c0                	test   %eax,%eax
  801ab8:	79 0a                	jns    801ac4 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801aba:	89 34 24             	mov    %esi,(%esp)
  801abd:	e8 00 02 00 00       	call   801cc2 <nsipc_close>
		return r;
  801ac2:	eb 28                	jmp    801aec <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801ac4:	8b 15 4c 60 80 00    	mov    0x80604c,%edx
  801aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801acd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ad2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801adc:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ae2:	89 04 24             	mov    %eax,(%esp)
  801ae5:	e8 d6 f5 ff ff       	call   8010c0 <fd2num>
  801aea:	89 c3                	mov    %eax,%ebx
}
  801aec:	89 d8                	mov    %ebx,%eax
  801aee:	83 c4 20             	add    $0x20,%esp
  801af1:	5b                   	pop    %ebx
  801af2:	5e                   	pop    %esi
  801af3:	5d                   	pop    %ebp
  801af4:	c3                   	ret    

00801af5 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
  801af8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801afb:	8b 45 10             	mov    0x10(%ebp),%eax
  801afe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b02:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b05:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b09:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0c:	89 04 24             	mov    %eax,(%esp)
  801b0f:	e8 62 01 00 00       	call   801c76 <nsipc_socket>
  801b14:	85 c0                	test   %eax,%eax
  801b16:	78 05                	js     801b1d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801b18:	e8 61 ff ff ff       	call   801a7e <alloc_sockfd>
}
  801b1d:	c9                   	leave  
  801b1e:	66 90                	xchg   %ax,%ax
  801b20:	c3                   	ret    

00801b21 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801b27:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b2a:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b2e:	89 04 24             	mov    %eax,(%esp)
  801b31:	e8 27 f6 ff ff       	call   80115d <fd_lookup>
  801b36:	85 c0                	test   %eax,%eax
  801b38:	78 15                	js     801b4f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801b3a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b3d:	8b 0a                	mov    (%edx),%ecx
  801b3f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b44:	3b 0d 4c 60 80 00    	cmp    0x80604c,%ecx
  801b4a:	75 03                	jne    801b4f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801b4c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	e8 c2 ff ff ff       	call   801b21 <fd2sockid>
  801b5f:	85 c0                	test   %eax,%eax
  801b61:	78 0f                	js     801b72 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801b63:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b66:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b6a:	89 04 24             	mov    %eax,(%esp)
  801b6d:	e8 2e 01 00 00       	call   801ca0 <nsipc_listen>
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
  801b77:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	e8 9f ff ff ff       	call   801b21 <fd2sockid>
  801b82:	85 c0                	test   %eax,%eax
  801b84:	78 16                	js     801b9c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801b86:	8b 55 10             	mov    0x10(%ebp),%edx
  801b89:	89 54 24 08          	mov    %edx,0x8(%esp)
  801b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b90:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b94:	89 04 24             	mov    %eax,(%esp)
  801b97:	e8 55 02 00 00       	call   801df1 <nsipc_connect>
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	e8 75 ff ff ff       	call   801b21 <fd2sockid>
  801bac:	85 c0                	test   %eax,%eax
  801bae:	78 0f                	js     801bbf <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801bb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bb7:	89 04 24             	mov    %eax,(%esp)
  801bba:	e8 1d 01 00 00       	call   801cdc <nsipc_shutdown>
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bca:	e8 52 ff ff ff       	call   801b21 <fd2sockid>
  801bcf:	85 c0                	test   %eax,%eax
  801bd1:	78 16                	js     801be9 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801bd3:	8b 55 10             	mov    0x10(%ebp),%edx
  801bd6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801bda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bdd:	89 54 24 04          	mov    %edx,0x4(%esp)
  801be1:	89 04 24             	mov    %eax,(%esp)
  801be4:	e8 47 02 00 00       	call   801e30 <nsipc_bind>
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
  801bee:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf4:	e8 28 ff ff ff       	call   801b21 <fd2sockid>
  801bf9:	85 c0                	test   %eax,%eax
  801bfb:	78 1f                	js     801c1c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  801bfd:	8b 55 10             	mov    0x10(%ebp),%edx
  801c00:	89 54 24 08          	mov    %edx,0x8(%esp)
  801c04:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c07:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c0b:	89 04 24             	mov    %eax,(%esp)
  801c0e:	e8 5c 02 00 00       	call   801e6f <nsipc_accept>
  801c13:	85 c0                	test   %eax,%eax
  801c15:	78 05                	js     801c1c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  801c17:	e8 62 fe ff ff       	call   801a7e <alloc_sockfd>
}
  801c1c:	c9                   	leave  
  801c1d:	8d 76 00             	lea    0x0(%esi),%esi
  801c20:	c3                   	ret    
	...

00801c30 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  801c36:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  801c3c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801c43:	00 
  801c44:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  801c4b:	00 
  801c4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c50:	89 14 24             	mov    %edx,(%esp)
  801c53:	e8 68 08 00 00       	call   8024c0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801c58:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801c5f:	00 
  801c60:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c67:	00 
  801c68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c6f:	e8 ae 08 00 00       	call   802522 <ipc_recv>
}
  801c74:	c9                   	leave  
  801c75:	c3                   	ret    

00801c76 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801c76:	55                   	push   %ebp
  801c77:	89 e5                	mov    %esp,%ebp
  801c79:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  801c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c87:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  801c8c:	8b 45 10             	mov    0x10(%ebp),%eax
  801c8f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801c94:	b8 09 00 00 00       	mov    $0x9,%eax
  801c99:	e8 92 ff ff ff       	call   801c30 <nsipc>
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
  801ca3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca9:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  801cae:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb1:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801cb6:	b8 06 00 00 00       	mov    $0x6,%eax
  801cbb:	e8 70 ff ff ff       	call   801c30 <nsipc>
}
  801cc0:	c9                   	leave  
  801cc1:	c3                   	ret    

00801cc2 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801cc2:	55                   	push   %ebp
  801cc3:	89 e5                	mov    %esp,%ebp
  801cc5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ccb:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801cd0:	b8 04 00 00 00       	mov    $0x4,%eax
  801cd5:	e8 56 ff ff ff       	call   801c30 <nsipc>
}
  801cda:	c9                   	leave  
  801cdb:	c3                   	ret    

00801cdc <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  801cdc:	55                   	push   %ebp
  801cdd:	89 e5                	mov    %esp,%ebp
  801cdf:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce5:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  801cea:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ced:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801cf2:	b8 03 00 00 00       	mov    $0x3,%eax
  801cf7:	e8 34 ff ff ff       	call   801c30 <nsipc>
}
  801cfc:	c9                   	leave  
  801cfd:	c3                   	ret    

00801cfe <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  801cfe:	55                   	push   %ebp
  801cff:	89 e5                	mov    %esp,%ebp
  801d01:	53                   	push   %ebx
  801d02:	83 ec 14             	sub    $0x14,%esp
  801d05:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801d08:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0b:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  801d10:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  801d16:	7e 24                	jle    801d3c <nsipc_send+0x3e>
  801d18:	c7 44 24 0c 0f 2d 80 	movl   $0x802d0f,0xc(%esp)
  801d1f:	00 
  801d20:	c7 44 24 08 1b 2d 80 	movl   $0x802d1b,0x8(%esp)
  801d27:	00 
  801d28:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801d2f:	00 
  801d30:	c7 04 24 30 2d 80 00 	movl   $0x802d30,(%esp)
  801d37:	e8 20 07 00 00       	call   80245c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  801d3c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d43:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d47:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  801d4e:	e8 a2 ec ff ff       	call   8009f5 <memmove>
	nsipcbuf.send.req_size = size;
  801d53:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  801d59:	8b 45 14             	mov    0x14(%ebp),%eax
  801d5c:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  801d61:	b8 08 00 00 00       	mov    $0x8,%eax
  801d66:	e8 c5 fe ff ff       	call   801c30 <nsipc>
}
  801d6b:	83 c4 14             	add    $0x14,%esp
  801d6e:	5b                   	pop    %ebx
  801d6f:	5d                   	pop    %ebp
  801d70:	c3                   	ret    

00801d71 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801d71:	55                   	push   %ebp
  801d72:	89 e5                	mov    %esp,%ebp
  801d74:	56                   	push   %esi
  801d75:	53                   	push   %ebx
  801d76:	83 ec 10             	sub    $0x10,%esp
  801d79:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  801d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  801d84:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  801d8a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d8d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801d92:	b8 07 00 00 00       	mov    $0x7,%eax
  801d97:	e8 94 fe ff ff       	call   801c30 <nsipc>
  801d9c:	89 c3                	mov    %eax,%ebx
  801d9e:	85 c0                	test   %eax,%eax
  801da0:	78 46                	js     801de8 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801da2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801da7:	7f 04                	jg     801dad <nsipc_recv+0x3c>
  801da9:	39 c6                	cmp    %eax,%esi
  801dab:	7d 24                	jge    801dd1 <nsipc_recv+0x60>
  801dad:	c7 44 24 0c 3c 2d 80 	movl   $0x802d3c,0xc(%esp)
  801db4:	00 
  801db5:	c7 44 24 08 1b 2d 80 	movl   $0x802d1b,0x8(%esp)
  801dbc:	00 
  801dbd:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801dc4:	00 
  801dc5:	c7 04 24 30 2d 80 00 	movl   $0x802d30,(%esp)
  801dcc:	e8 8b 06 00 00       	call   80245c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801dd1:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dd5:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801ddc:	00 
  801ddd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801de0:	89 04 24             	mov    %eax,(%esp)
  801de3:	e8 0d ec ff ff       	call   8009f5 <memmove>
	}

	return r;
}
  801de8:	89 d8                	mov    %ebx,%eax
  801dea:	83 c4 10             	add    $0x10,%esp
  801ded:	5b                   	pop    %ebx
  801dee:	5e                   	pop    %esi
  801def:	5d                   	pop    %ebp
  801df0:	c3                   	ret    

00801df1 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801df1:	55                   	push   %ebp
  801df2:	89 e5                	mov    %esp,%ebp
  801df4:	53                   	push   %ebx
  801df5:	83 ec 14             	sub    $0x14,%esp
  801df8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  801dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfe:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801e03:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e0e:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801e15:	e8 db eb ff ff       	call   8009f5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  801e1a:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  801e20:	b8 05 00 00 00       	mov    $0x5,%eax
  801e25:	e8 06 fe ff ff       	call   801c30 <nsipc>
}
  801e2a:	83 c4 14             	add    $0x14,%esp
  801e2d:	5b                   	pop    %ebx
  801e2e:	5d                   	pop    %ebp
  801e2f:	c3                   	ret    

00801e30 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	53                   	push   %ebx
  801e34:	83 ec 14             	sub    $0x14,%esp
  801e37:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  801e3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3d:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801e42:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4d:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801e54:	e8 9c eb ff ff       	call   8009f5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801e59:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  801e5f:	b8 02 00 00 00       	mov    $0x2,%eax
  801e64:	e8 c7 fd ff ff       	call   801c30 <nsipc>
}
  801e69:	83 c4 14             	add    $0x14,%esp
  801e6c:	5b                   	pop    %ebx
  801e6d:	5d                   	pop    %ebp
  801e6e:	c3                   	ret    

00801e6f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801e6f:	55                   	push   %ebp
  801e70:	89 e5                	mov    %esp,%ebp
  801e72:	83 ec 18             	sub    $0x18,%esp
  801e75:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e78:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  801e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e7e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801e83:	b8 01 00 00 00       	mov    $0x1,%eax
  801e88:	e8 a3 fd ff ff       	call   801c30 <nsipc>
  801e8d:	89 c3                	mov    %eax,%ebx
  801e8f:	85 c0                	test   %eax,%eax
  801e91:	78 25                	js     801eb8 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801e93:	be 10 50 80 00       	mov    $0x805010,%esi
  801e98:	8b 06                	mov    (%esi),%eax
  801e9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e9e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801ea5:	00 
  801ea6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea9:	89 04 24             	mov    %eax,(%esp)
  801eac:	e8 44 eb ff ff       	call   8009f5 <memmove>
		*addrlen = ret->ret_addrlen;
  801eb1:	8b 16                	mov    (%esi),%edx
  801eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  801eb6:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  801eb8:	89 d8                	mov    %ebx,%eax
  801eba:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ebd:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ec0:	89 ec                	mov    %ebp,%esp
  801ec2:	5d                   	pop    %ebp
  801ec3:	c3                   	ret    
	...

00801ed0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 18             	sub    $0x18,%esp
  801ed6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801ed9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801edc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801edf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee2:	89 04 24             	mov    %eax,(%esp)
  801ee5:	e8 e6 f1 ff ff       	call   8010d0 <fd2data>
  801eea:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801eec:	c7 44 24 04 51 2d 80 	movl   $0x802d51,0x4(%esp)
  801ef3:	00 
  801ef4:	89 34 24             	mov    %esi,(%esp)
  801ef7:	e8 3e e9 ff ff       	call   80083a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801efc:	8b 43 04             	mov    0x4(%ebx),%eax
  801eff:	2b 03                	sub    (%ebx),%eax
  801f01:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801f07:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801f0e:	00 00 00 
	stat->st_dev = &devpipe;
  801f11:	c7 86 88 00 00 00 68 	movl   $0x806068,0x88(%esi)
  801f18:	60 80 00 
	return 0;
}
  801f1b:	b8 00 00 00 00       	mov    $0x0,%eax
  801f20:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801f23:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801f26:	89 ec                	mov    %ebp,%esp
  801f28:	5d                   	pop    %ebp
  801f29:	c3                   	ret    

00801f2a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801f2a:	55                   	push   %ebp
  801f2b:	89 e5                	mov    %esp,%ebp
  801f2d:	53                   	push   %ebx
  801f2e:	83 ec 14             	sub    $0x14,%esp
  801f31:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801f34:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f3f:	e8 96 ef ff ff       	call   800eda <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801f44:	89 1c 24             	mov    %ebx,(%esp)
  801f47:	e8 84 f1 ff ff       	call   8010d0 <fd2data>
  801f4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f50:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f57:	e8 7e ef ff ff       	call   800eda <sys_page_unmap>
}
  801f5c:	83 c4 14             	add    $0x14,%esp
  801f5f:	5b                   	pop    %ebx
  801f60:	5d                   	pop    %ebp
  801f61:	c3                   	ret    

00801f62 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801f62:	55                   	push   %ebp
  801f63:	89 e5                	mov    %esp,%ebp
  801f65:	57                   	push   %edi
  801f66:	56                   	push   %esi
  801f67:	53                   	push   %ebx
  801f68:	83 ec 2c             	sub    $0x2c,%esp
  801f6b:	89 c7                	mov    %eax,%edi
  801f6d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801f70:	a1 a0 60 80 00       	mov    0x8060a0,%eax
  801f75:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801f78:	89 3c 24             	mov    %edi,(%esp)
  801f7b:	e8 08 06 00 00       	call   802588 <pageref>
  801f80:	89 c6                	mov    %eax,%esi
  801f82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f85:	89 04 24             	mov    %eax,(%esp)
  801f88:	e8 fb 05 00 00       	call   802588 <pageref>
  801f8d:	39 c6                	cmp    %eax,%esi
  801f8f:	0f 94 c0             	sete   %al
  801f92:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  801f95:	8b 15 a0 60 80 00    	mov    0x8060a0,%edx
  801f9b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801f9e:	39 cb                	cmp    %ecx,%ebx
  801fa0:	75 08                	jne    801faa <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  801fa2:	83 c4 2c             	add    $0x2c,%esp
  801fa5:	5b                   	pop    %ebx
  801fa6:	5e                   	pop    %esi
  801fa7:	5f                   	pop    %edi
  801fa8:	5d                   	pop    %ebp
  801fa9:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801faa:	83 f8 01             	cmp    $0x1,%eax
  801fad:	75 c1                	jne    801f70 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  801faf:	8b 52 58             	mov    0x58(%edx),%edx
  801fb2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fb6:	89 54 24 08          	mov    %edx,0x8(%esp)
  801fba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801fbe:	c7 04 24 58 2d 80 00 	movl   $0x802d58,(%esp)
  801fc5:	e8 8f e1 ff ff       	call   800159 <cprintf>
  801fca:	eb a4                	jmp    801f70 <_pipeisclosed+0xe>

00801fcc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801fcc:	55                   	push   %ebp
  801fcd:	89 e5                	mov    %esp,%ebp
  801fcf:	57                   	push   %edi
  801fd0:	56                   	push   %esi
  801fd1:	53                   	push   %ebx
  801fd2:	83 ec 1c             	sub    $0x1c,%esp
  801fd5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801fd8:	89 34 24             	mov    %esi,(%esp)
  801fdb:	e8 f0 f0 ff ff       	call   8010d0 <fd2data>
  801fe0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801fe2:	bf 00 00 00 00       	mov    $0x0,%edi
  801fe7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801feb:	75 54                	jne    802041 <devpipe_write+0x75>
  801fed:	eb 60                	jmp    80204f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801fef:	89 da                	mov    %ebx,%edx
  801ff1:	89 f0                	mov    %esi,%eax
  801ff3:	e8 6a ff ff ff       	call   801f62 <_pipeisclosed>
  801ff8:	85 c0                	test   %eax,%eax
  801ffa:	74 07                	je     802003 <devpipe_write+0x37>
  801ffc:	b8 00 00 00 00       	mov    $0x0,%eax
  802001:	eb 53                	jmp    802056 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802003:	90                   	nop
  802004:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802008:	e8 e8 ef ff ff       	call   800ff5 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80200d:	8b 43 04             	mov    0x4(%ebx),%eax
  802010:	8b 13                	mov    (%ebx),%edx
  802012:	83 c2 20             	add    $0x20,%edx
  802015:	39 d0                	cmp    %edx,%eax
  802017:	73 d6                	jae    801fef <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802019:	89 c2                	mov    %eax,%edx
  80201b:	c1 fa 1f             	sar    $0x1f,%edx
  80201e:	c1 ea 1b             	shr    $0x1b,%edx
  802021:	01 d0                	add    %edx,%eax
  802023:	83 e0 1f             	and    $0x1f,%eax
  802026:	29 d0                	sub    %edx,%eax
  802028:	89 c2                	mov    %eax,%edx
  80202a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80202d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802031:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802035:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802039:	83 c7 01             	add    $0x1,%edi
  80203c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80203f:	76 13                	jbe    802054 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802041:	8b 43 04             	mov    0x4(%ebx),%eax
  802044:	8b 13                	mov    (%ebx),%edx
  802046:	83 c2 20             	add    $0x20,%edx
  802049:	39 d0                	cmp    %edx,%eax
  80204b:	73 a2                	jae    801fef <devpipe_write+0x23>
  80204d:	eb ca                	jmp    802019 <devpipe_write+0x4d>
  80204f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802054:	89 f8                	mov    %edi,%eax
}
  802056:	83 c4 1c             	add    $0x1c,%esp
  802059:	5b                   	pop    %ebx
  80205a:	5e                   	pop    %esi
  80205b:	5f                   	pop    %edi
  80205c:	5d                   	pop    %ebp
  80205d:	c3                   	ret    

0080205e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	83 ec 28             	sub    $0x28,%esp
  802064:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802067:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80206a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80206d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802070:	89 3c 24             	mov    %edi,(%esp)
  802073:	e8 58 f0 ff ff       	call   8010d0 <fd2data>
  802078:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80207a:	be 00 00 00 00       	mov    $0x0,%esi
  80207f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802083:	75 4c                	jne    8020d1 <devpipe_read+0x73>
  802085:	eb 5b                	jmp    8020e2 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802087:	89 f0                	mov    %esi,%eax
  802089:	eb 5e                	jmp    8020e9 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80208b:	89 da                	mov    %ebx,%edx
  80208d:	89 f8                	mov    %edi,%eax
  80208f:	90                   	nop
  802090:	e8 cd fe ff ff       	call   801f62 <_pipeisclosed>
  802095:	85 c0                	test   %eax,%eax
  802097:	74 07                	je     8020a0 <devpipe_read+0x42>
  802099:	b8 00 00 00 00       	mov    $0x0,%eax
  80209e:	eb 49                	jmp    8020e9 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8020a0:	e8 50 ef ff ff       	call   800ff5 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8020a5:	8b 03                	mov    (%ebx),%eax
  8020a7:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020aa:	74 df                	je     80208b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8020ac:	89 c2                	mov    %eax,%edx
  8020ae:	c1 fa 1f             	sar    $0x1f,%edx
  8020b1:	c1 ea 1b             	shr    $0x1b,%edx
  8020b4:	01 d0                	add    %edx,%eax
  8020b6:	83 e0 1f             	and    $0x1f,%eax
  8020b9:	29 d0                	sub    %edx,%eax
  8020bb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8020c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c3:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8020c6:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8020c9:	83 c6 01             	add    $0x1,%esi
  8020cc:	39 75 10             	cmp    %esi,0x10(%ebp)
  8020cf:	76 16                	jbe    8020e7 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  8020d1:	8b 03                	mov    (%ebx),%eax
  8020d3:	3b 43 04             	cmp    0x4(%ebx),%eax
  8020d6:	75 d4                	jne    8020ac <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  8020d8:	85 f6                	test   %esi,%esi
  8020da:	75 ab                	jne    802087 <devpipe_read+0x29>
  8020dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8020e0:	eb a9                	jmp    80208b <devpipe_read+0x2d>
  8020e2:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8020e7:	89 f0                	mov    %esi,%eax
}
  8020e9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8020ec:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8020ef:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8020f2:	89 ec                	mov    %ebp,%esp
  8020f4:	5d                   	pop    %ebp
  8020f5:	c3                   	ret    

008020f6 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8020f6:	55                   	push   %ebp
  8020f7:	89 e5                	mov    %esp,%ebp
  8020f9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  802103:	8b 45 08             	mov    0x8(%ebp),%eax
  802106:	89 04 24             	mov    %eax,(%esp)
  802109:	e8 4f f0 ff ff       	call   80115d <fd_lookup>
  80210e:	85 c0                	test   %eax,%eax
  802110:	78 15                	js     802127 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802112:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802115:	89 04 24             	mov    %eax,(%esp)
  802118:	e8 b3 ef ff ff       	call   8010d0 <fd2data>
	return _pipeisclosed(fd, p);
  80211d:	89 c2                	mov    %eax,%edx
  80211f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802122:	e8 3b fe ff ff       	call   801f62 <_pipeisclosed>
}
  802127:	c9                   	leave  
  802128:	c3                   	ret    

00802129 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802129:	55                   	push   %ebp
  80212a:	89 e5                	mov    %esp,%ebp
  80212c:	83 ec 48             	sub    $0x48,%esp
  80212f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802132:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802135:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802138:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80213b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80213e:	89 04 24             	mov    %eax,(%esp)
  802141:	e8 a5 ef ff ff       	call   8010eb <fd_alloc>
  802146:	89 c3                	mov    %eax,%ebx
  802148:	85 c0                	test   %eax,%eax
  80214a:	0f 88 42 01 00 00    	js     802292 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802150:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802157:	00 
  802158:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80215b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80215f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802166:	e8 2b ee ff ff       	call   800f96 <sys_page_alloc>
  80216b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80216d:	85 c0                	test   %eax,%eax
  80216f:	0f 88 1d 01 00 00    	js     802292 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802175:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802178:	89 04 24             	mov    %eax,(%esp)
  80217b:	e8 6b ef ff ff       	call   8010eb <fd_alloc>
  802180:	89 c3                	mov    %eax,%ebx
  802182:	85 c0                	test   %eax,%eax
  802184:	0f 88 f5 00 00 00    	js     80227f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80218a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802191:	00 
  802192:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802195:	89 44 24 04          	mov    %eax,0x4(%esp)
  802199:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021a0:	e8 f1 ed ff ff       	call   800f96 <sys_page_alloc>
  8021a5:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8021a7:	85 c0                	test   %eax,%eax
  8021a9:	0f 88 d0 00 00 00    	js     80227f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8021af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021b2:	89 04 24             	mov    %eax,(%esp)
  8021b5:	e8 16 ef ff ff       	call   8010d0 <fd2data>
  8021ba:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021bc:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8021c3:	00 
  8021c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021cf:	e8 c2 ed ff ff       	call   800f96 <sys_page_alloc>
  8021d4:	89 c3                	mov    %eax,%ebx
  8021d6:	85 c0                	test   %eax,%eax
  8021d8:	0f 88 8e 00 00 00    	js     80226c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021e1:	89 04 24             	mov    %eax,(%esp)
  8021e4:	e8 e7 ee ff ff       	call   8010d0 <fd2data>
  8021e9:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8021f0:	00 
  8021f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021f5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8021fc:	00 
  8021fd:	89 74 24 04          	mov    %esi,0x4(%esp)
  802201:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802208:	e8 2b ed ff ff       	call   800f38 <sys_page_map>
  80220d:	89 c3                	mov    %eax,%ebx
  80220f:	85 c0                	test   %eax,%eax
  802211:	78 49                	js     80225c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802213:	b8 68 60 80 00       	mov    $0x806068,%eax
  802218:	8b 08                	mov    (%eax),%ecx
  80221a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80221d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80221f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802222:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802229:	8b 10                	mov    (%eax),%edx
  80222b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80222e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802230:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802233:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80223a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80223d:	89 04 24             	mov    %eax,(%esp)
  802240:	e8 7b ee ff ff       	call   8010c0 <fd2num>
  802245:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802247:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80224a:	89 04 24             	mov    %eax,(%esp)
  80224d:	e8 6e ee ff ff       	call   8010c0 <fd2num>
  802252:	89 47 04             	mov    %eax,0x4(%edi)
  802255:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80225a:	eb 36                	jmp    802292 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80225c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802260:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802267:	e8 6e ec ff ff       	call   800eda <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80226c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80226f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802273:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80227a:	e8 5b ec ff ff       	call   800eda <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80227f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802282:	89 44 24 04          	mov    %eax,0x4(%esp)
  802286:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80228d:	e8 48 ec ff ff       	call   800eda <sys_page_unmap>
    err:
	return r;
}
  802292:	89 d8                	mov    %ebx,%eax
  802294:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802297:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80229a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80229d:	89 ec                	mov    %ebp,%esp
  80229f:	5d                   	pop    %ebp
  8022a0:	c3                   	ret    
	...

008022b0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8022b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022b8:	5d                   	pop    %ebp
  8022b9:	c3                   	ret    

008022ba <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8022c0:	c7 44 24 04 70 2d 80 	movl   $0x802d70,0x4(%esp)
  8022c7:	00 
  8022c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022cb:	89 04 24             	mov    %eax,(%esp)
  8022ce:	e8 67 e5 ff ff       	call   80083a <strcpy>
	return 0;
}
  8022d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8022d8:	c9                   	leave  
  8022d9:	c3                   	ret    

008022da <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8022da:	55                   	push   %ebp
  8022db:	89 e5                	mov    %esp,%ebp
  8022dd:	57                   	push   %edi
  8022de:	56                   	push   %esi
  8022df:	53                   	push   %ebx
  8022e0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8022e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8022eb:	be 00 00 00 00       	mov    $0x0,%esi
  8022f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8022f4:	74 3f                	je     802335 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8022f6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8022fc:	8b 55 10             	mov    0x10(%ebp),%edx
  8022ff:	29 c2                	sub    %eax,%edx
  802301:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802303:	83 fa 7f             	cmp    $0x7f,%edx
  802306:	76 05                	jbe    80230d <devcons_write+0x33>
  802308:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80230d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802311:	03 45 0c             	add    0xc(%ebp),%eax
  802314:	89 44 24 04          	mov    %eax,0x4(%esp)
  802318:	89 3c 24             	mov    %edi,(%esp)
  80231b:	e8 d5 e6 ff ff       	call   8009f5 <memmove>
		sys_cputs(buf, m);
  802320:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802324:	89 3c 24             	mov    %edi,(%esp)
  802327:	e8 04 e9 ff ff       	call   800c30 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80232c:	01 de                	add    %ebx,%esi
  80232e:	89 f0                	mov    %esi,%eax
  802330:	3b 75 10             	cmp    0x10(%ebp),%esi
  802333:	72 c7                	jb     8022fc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802335:	89 f0                	mov    %esi,%eax
  802337:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80233d:	5b                   	pop    %ebx
  80233e:	5e                   	pop    %esi
  80233f:	5f                   	pop    %edi
  802340:	5d                   	pop    %ebp
  802341:	c3                   	ret    

00802342 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
  802345:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80234e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802355:	00 
  802356:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802359:	89 04 24             	mov    %eax,(%esp)
  80235c:	e8 cf e8 ff ff       	call   800c30 <sys_cputs>
}
  802361:	c9                   	leave  
  802362:	c3                   	ret    

00802363 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802363:	55                   	push   %ebp
  802364:	89 e5                	mov    %esp,%ebp
  802366:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802369:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80236d:	75 07                	jne    802376 <devcons_read+0x13>
  80236f:	eb 28                	jmp    802399 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802371:	e8 7f ec ff ff       	call   800ff5 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802376:	66 90                	xchg   %ax,%ax
  802378:	e8 7f e8 ff ff       	call   800bfc <sys_cgetc>
  80237d:	85 c0                	test   %eax,%eax
  80237f:	90                   	nop
  802380:	74 ef                	je     802371 <devcons_read+0xe>
  802382:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802384:	85 c0                	test   %eax,%eax
  802386:	78 16                	js     80239e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802388:	83 f8 04             	cmp    $0x4,%eax
  80238b:	74 0c                	je     802399 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80238d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802390:	88 10                	mov    %dl,(%eax)
  802392:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802397:	eb 05                	jmp    80239e <devcons_read+0x3b>
  802399:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80239e:	c9                   	leave  
  80239f:	c3                   	ret    

008023a0 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
  8023a3:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8023a6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023a9:	89 04 24             	mov    %eax,(%esp)
  8023ac:	e8 3a ed ff ff       	call   8010eb <fd_alloc>
  8023b1:	85 c0                	test   %eax,%eax
  8023b3:	78 3f                	js     8023f4 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8023b5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8023bc:	00 
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023cb:	e8 c6 eb ff ff       	call   800f96 <sys_page_alloc>
  8023d0:	85 c0                	test   %eax,%eax
  8023d2:	78 20                	js     8023f4 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  8023d4:	8b 15 84 60 80 00    	mov    0x806084,%edx
  8023da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023dd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8023df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8023e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ec:	89 04 24             	mov    %eax,(%esp)
  8023ef:	e8 cc ec ff ff       	call   8010c0 <fd2num>
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
  8023f9:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8023fc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8023ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  802403:	8b 45 08             	mov    0x8(%ebp),%eax
  802406:	89 04 24             	mov    %eax,(%esp)
  802409:	e8 4f ed ff ff       	call   80115d <fd_lookup>
  80240e:	85 c0                	test   %eax,%eax
  802410:	78 11                	js     802423 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802415:	8b 00                	mov    (%eax),%eax
  802417:	3b 05 84 60 80 00    	cmp    0x806084,%eax
  80241d:	0f 94 c0             	sete   %al
  802420:	0f b6 c0             	movzbl %al,%eax
}
  802423:	c9                   	leave  
  802424:	c3                   	ret    

00802425 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802425:	55                   	push   %ebp
  802426:	89 e5                	mov    %esp,%ebp
  802428:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80242b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802432:	00 
  802433:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802436:	89 44 24 04          	mov    %eax,0x4(%esp)
  80243a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802441:	e8 78 ef ff ff       	call   8013be <read>
	if (r < 0)
  802446:	85 c0                	test   %eax,%eax
  802448:	78 0f                	js     802459 <getchar+0x34>
		return r;
	if (r < 1)
  80244a:	85 c0                	test   %eax,%eax
  80244c:	7f 07                	jg     802455 <getchar+0x30>
  80244e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802453:	eb 04                	jmp    802459 <getchar+0x34>
		return -E_EOF;
	return c;
  802455:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    
	...

0080245c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80245c:	55                   	push   %ebp
  80245d:	89 e5                	mov    %esp,%ebp
  80245f:	53                   	push   %ebx
  802460:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  802463:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  802466:	a1 a4 60 80 00       	mov    0x8060a4,%eax
  80246b:	85 c0                	test   %eax,%eax
  80246d:	74 10                	je     80247f <_panic+0x23>
		cprintf("%s: ", argv0);
  80246f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802473:	c7 04 24 7c 2d 80 00 	movl   $0x802d7c,(%esp)
  80247a:	e8 da dc ff ff       	call   800159 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80247f:	8b 45 0c             	mov    0xc(%ebp),%eax
  802482:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802486:	8b 45 08             	mov    0x8(%ebp),%eax
  802489:	89 44 24 08          	mov    %eax,0x8(%esp)
  80248d:	a1 2c 60 80 00       	mov    0x80602c,%eax
  802492:	89 44 24 04          	mov    %eax,0x4(%esp)
  802496:	c7 04 24 81 2d 80 00 	movl   $0x802d81,(%esp)
  80249d:	e8 b7 dc ff ff       	call   800159 <cprintf>
	vcprintf(fmt, ap);
  8024a2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024a9:	89 04 24             	mov    %eax,(%esp)
  8024ac:	e8 47 dc ff ff       	call   8000f8 <vcprintf>
	cprintf("\n");
  8024b1:	c7 04 24 69 2d 80 00 	movl   $0x802d69,(%esp)
  8024b8:	e8 9c dc ff ff       	call   800159 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8024bd:	cc                   	int3   
  8024be:	eb fd                	jmp    8024bd <_panic+0x61>

008024c0 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
  8024c3:	57                   	push   %edi
  8024c4:	56                   	push   %esi
  8024c5:	53                   	push   %ebx
  8024c6:	83 ec 1c             	sub    $0x1c,%esp
  8024c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8024cc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8024cf:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  8024d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8024d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024d9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8024dd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024e1:	89 1c 24             	mov    %ebx,(%esp)
  8024e4:	e8 9f e8 ff ff       	call   800d88 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  8024e9:	85 c0                	test   %eax,%eax
  8024eb:	79 21                	jns    80250e <ipc_send+0x4e>
  8024ed:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024f0:	74 1c                	je     80250e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  8024f2:	c7 44 24 08 9d 2d 80 	movl   $0x802d9d,0x8(%esp)
  8024f9:	00 
  8024fa:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  802501:	00 
  802502:	c7 04 24 af 2d 80 00 	movl   $0x802daf,(%esp)
  802509:	e8 4e ff ff ff       	call   80245c <_panic>
          else if(r==-E_IPC_NOT_RECV)
  80250e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802511:	75 07                	jne    80251a <ipc_send+0x5a>
           sys_yield();
  802513:	e8 dd ea ff ff       	call   800ff5 <sys_yield>
          else
            break;
        }
  802518:	eb b8                	jmp    8024d2 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  80251a:	83 c4 1c             	add    $0x1c,%esp
  80251d:	5b                   	pop    %ebx
  80251e:	5e                   	pop    %esi
  80251f:	5f                   	pop    %edi
  802520:	5d                   	pop    %ebp
  802521:	c3                   	ret    

00802522 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802522:	55                   	push   %ebp
  802523:	89 e5                	mov    %esp,%ebp
  802525:	83 ec 18             	sub    $0x18,%esp
  802528:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80252b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80252e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802531:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  802534:	8b 45 0c             	mov    0xc(%ebp),%eax
  802537:	89 04 24             	mov    %eax,(%esp)
  80253a:	e8 ec e7 ff ff       	call   800d2b <sys_ipc_recv>
        if(r<0)
  80253f:	85 c0                	test   %eax,%eax
  802541:	79 17                	jns    80255a <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  802543:	85 db                	test   %ebx,%ebx
  802545:	74 06                	je     80254d <ipc_recv+0x2b>
               *from_env_store =0;
  802547:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  80254d:	85 f6                	test   %esi,%esi
  80254f:	90                   	nop
  802550:	74 2c                	je     80257e <ipc_recv+0x5c>
              *perm_store=0;
  802552:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802558:	eb 24                	jmp    80257e <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  80255a:	85 db                	test   %ebx,%ebx
  80255c:	74 0a                	je     802568 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  80255e:	a1 a0 60 80 00       	mov    0x8060a0,%eax
  802563:	8b 40 74             	mov    0x74(%eax),%eax
  802566:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  802568:	85 f6                	test   %esi,%esi
  80256a:	74 0a                	je     802576 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  80256c:	a1 a0 60 80 00       	mov    0x8060a0,%eax
  802571:	8b 40 78             	mov    0x78(%eax),%eax
  802574:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  802576:	a1 a0 60 80 00       	mov    0x8060a0,%eax
  80257b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80257e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802581:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802584:	89 ec                	mov    %ebp,%esp
  802586:	5d                   	pop    %ebp
  802587:	c3                   	ret    

00802588 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802588:	55                   	push   %ebp
  802589:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80258b:	8b 45 08             	mov    0x8(%ebp),%eax
  80258e:	89 c2                	mov    %eax,%edx
  802590:	c1 ea 16             	shr    $0x16,%edx
  802593:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80259a:	f6 c2 01             	test   $0x1,%dl
  80259d:	74 26                	je     8025c5 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  80259f:	c1 e8 0c             	shr    $0xc,%eax
  8025a2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8025a9:	a8 01                	test   $0x1,%al
  8025ab:	74 18                	je     8025c5 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  8025ad:	c1 e8 0c             	shr    $0xc,%eax
  8025b0:	8d 14 40             	lea    (%eax,%eax,2),%edx
  8025b3:	c1 e2 02             	shl    $0x2,%edx
  8025b6:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8025bb:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  8025c0:	0f b7 c0             	movzwl %ax,%eax
  8025c3:	eb 05                	jmp    8025ca <pageref+0x42>
  8025c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025ca:	5d                   	pop    %ebp
  8025cb:	c3                   	ret    
  8025cc:	00 00                	add    %al,(%eax)
	...

008025d0 <__udivdi3>:
  8025d0:	55                   	push   %ebp
  8025d1:	89 e5                	mov    %esp,%ebp
  8025d3:	57                   	push   %edi
  8025d4:	56                   	push   %esi
  8025d5:	83 ec 10             	sub    $0x10,%esp
  8025d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8025db:	8b 55 08             	mov    0x8(%ebp),%edx
  8025de:	8b 75 10             	mov    0x10(%ebp),%esi
  8025e1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8025e4:	85 c0                	test   %eax,%eax
  8025e6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8025e9:	75 35                	jne    802620 <__udivdi3+0x50>
  8025eb:	39 fe                	cmp    %edi,%esi
  8025ed:	77 61                	ja     802650 <__udivdi3+0x80>
  8025ef:	85 f6                	test   %esi,%esi
  8025f1:	75 0b                	jne    8025fe <__udivdi3+0x2e>
  8025f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025f8:	31 d2                	xor    %edx,%edx
  8025fa:	f7 f6                	div    %esi
  8025fc:	89 c6                	mov    %eax,%esi
  8025fe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802601:	31 d2                	xor    %edx,%edx
  802603:	89 f8                	mov    %edi,%eax
  802605:	f7 f6                	div    %esi
  802607:	89 c7                	mov    %eax,%edi
  802609:	89 c8                	mov    %ecx,%eax
  80260b:	f7 f6                	div    %esi
  80260d:	89 c1                	mov    %eax,%ecx
  80260f:	89 fa                	mov    %edi,%edx
  802611:	89 c8                	mov    %ecx,%eax
  802613:	83 c4 10             	add    $0x10,%esp
  802616:	5e                   	pop    %esi
  802617:	5f                   	pop    %edi
  802618:	5d                   	pop    %ebp
  802619:	c3                   	ret    
  80261a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802620:	39 f8                	cmp    %edi,%eax
  802622:	77 1c                	ja     802640 <__udivdi3+0x70>
  802624:	0f bd d0             	bsr    %eax,%edx
  802627:	83 f2 1f             	xor    $0x1f,%edx
  80262a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80262d:	75 39                	jne    802668 <__udivdi3+0x98>
  80262f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802632:	0f 86 a0 00 00 00    	jbe    8026d8 <__udivdi3+0x108>
  802638:	39 f8                	cmp    %edi,%eax
  80263a:	0f 82 98 00 00 00    	jb     8026d8 <__udivdi3+0x108>
  802640:	31 ff                	xor    %edi,%edi
  802642:	31 c9                	xor    %ecx,%ecx
  802644:	89 c8                	mov    %ecx,%eax
  802646:	89 fa                	mov    %edi,%edx
  802648:	83 c4 10             	add    $0x10,%esp
  80264b:	5e                   	pop    %esi
  80264c:	5f                   	pop    %edi
  80264d:	5d                   	pop    %ebp
  80264e:	c3                   	ret    
  80264f:	90                   	nop
  802650:	89 d1                	mov    %edx,%ecx
  802652:	89 fa                	mov    %edi,%edx
  802654:	89 c8                	mov    %ecx,%eax
  802656:	31 ff                	xor    %edi,%edi
  802658:	f7 f6                	div    %esi
  80265a:	89 c1                	mov    %eax,%ecx
  80265c:	89 fa                	mov    %edi,%edx
  80265e:	89 c8                	mov    %ecx,%eax
  802660:	83 c4 10             	add    $0x10,%esp
  802663:	5e                   	pop    %esi
  802664:	5f                   	pop    %edi
  802665:	5d                   	pop    %ebp
  802666:	c3                   	ret    
  802667:	90                   	nop
  802668:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80266c:	89 f2                	mov    %esi,%edx
  80266e:	d3 e0                	shl    %cl,%eax
  802670:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802673:	b8 20 00 00 00       	mov    $0x20,%eax
  802678:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80267b:	89 c1                	mov    %eax,%ecx
  80267d:	d3 ea                	shr    %cl,%edx
  80267f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802683:	0b 55 ec             	or     -0x14(%ebp),%edx
  802686:	d3 e6                	shl    %cl,%esi
  802688:	89 c1                	mov    %eax,%ecx
  80268a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80268d:	89 fe                	mov    %edi,%esi
  80268f:	d3 ee                	shr    %cl,%esi
  802691:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802695:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802698:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80269b:	d3 e7                	shl    %cl,%edi
  80269d:	89 c1                	mov    %eax,%ecx
  80269f:	d3 ea                	shr    %cl,%edx
  8026a1:	09 d7                	or     %edx,%edi
  8026a3:	89 f2                	mov    %esi,%edx
  8026a5:	89 f8                	mov    %edi,%eax
  8026a7:	f7 75 ec             	divl   -0x14(%ebp)
  8026aa:	89 d6                	mov    %edx,%esi
  8026ac:	89 c7                	mov    %eax,%edi
  8026ae:	f7 65 e8             	mull   -0x18(%ebp)
  8026b1:	39 d6                	cmp    %edx,%esi
  8026b3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8026b6:	72 30                	jb     8026e8 <__udivdi3+0x118>
  8026b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8026bb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8026bf:	d3 e2                	shl    %cl,%edx
  8026c1:	39 c2                	cmp    %eax,%edx
  8026c3:	73 05                	jae    8026ca <__udivdi3+0xfa>
  8026c5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8026c8:	74 1e                	je     8026e8 <__udivdi3+0x118>
  8026ca:	89 f9                	mov    %edi,%ecx
  8026cc:	31 ff                	xor    %edi,%edi
  8026ce:	e9 71 ff ff ff       	jmp    802644 <__udivdi3+0x74>
  8026d3:	90                   	nop
  8026d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026d8:	31 ff                	xor    %edi,%edi
  8026da:	b9 01 00 00 00       	mov    $0x1,%ecx
  8026df:	e9 60 ff ff ff       	jmp    802644 <__udivdi3+0x74>
  8026e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026e8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  8026eb:	31 ff                	xor    %edi,%edi
  8026ed:	89 c8                	mov    %ecx,%eax
  8026ef:	89 fa                	mov    %edi,%edx
  8026f1:	83 c4 10             	add    $0x10,%esp
  8026f4:	5e                   	pop    %esi
  8026f5:	5f                   	pop    %edi
  8026f6:	5d                   	pop    %ebp
  8026f7:	c3                   	ret    
	...

00802700 <__umoddi3>:
  802700:	55                   	push   %ebp
  802701:	89 e5                	mov    %esp,%ebp
  802703:	57                   	push   %edi
  802704:	56                   	push   %esi
  802705:	83 ec 20             	sub    $0x20,%esp
  802708:	8b 55 14             	mov    0x14(%ebp),%edx
  80270b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80270e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802711:	8b 75 0c             	mov    0xc(%ebp),%esi
  802714:	85 d2                	test   %edx,%edx
  802716:	89 c8                	mov    %ecx,%eax
  802718:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80271b:	75 13                	jne    802730 <__umoddi3+0x30>
  80271d:	39 f7                	cmp    %esi,%edi
  80271f:	76 3f                	jbe    802760 <__umoddi3+0x60>
  802721:	89 f2                	mov    %esi,%edx
  802723:	f7 f7                	div    %edi
  802725:	89 d0                	mov    %edx,%eax
  802727:	31 d2                	xor    %edx,%edx
  802729:	83 c4 20             	add    $0x20,%esp
  80272c:	5e                   	pop    %esi
  80272d:	5f                   	pop    %edi
  80272e:	5d                   	pop    %ebp
  80272f:	c3                   	ret    
  802730:	39 f2                	cmp    %esi,%edx
  802732:	77 4c                	ja     802780 <__umoddi3+0x80>
  802734:	0f bd ca             	bsr    %edx,%ecx
  802737:	83 f1 1f             	xor    $0x1f,%ecx
  80273a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80273d:	75 51                	jne    802790 <__umoddi3+0x90>
  80273f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802742:	0f 87 e0 00 00 00    	ja     802828 <__umoddi3+0x128>
  802748:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274b:	29 f8                	sub    %edi,%eax
  80274d:	19 d6                	sbb    %edx,%esi
  80274f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	89 f2                	mov    %esi,%edx
  802757:	83 c4 20             	add    $0x20,%esp
  80275a:	5e                   	pop    %esi
  80275b:	5f                   	pop    %edi
  80275c:	5d                   	pop    %ebp
  80275d:	c3                   	ret    
  80275e:	66 90                	xchg   %ax,%ax
  802760:	85 ff                	test   %edi,%edi
  802762:	75 0b                	jne    80276f <__umoddi3+0x6f>
  802764:	b8 01 00 00 00       	mov    $0x1,%eax
  802769:	31 d2                	xor    %edx,%edx
  80276b:	f7 f7                	div    %edi
  80276d:	89 c7                	mov    %eax,%edi
  80276f:	89 f0                	mov    %esi,%eax
  802771:	31 d2                	xor    %edx,%edx
  802773:	f7 f7                	div    %edi
  802775:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802778:	f7 f7                	div    %edi
  80277a:	eb a9                	jmp    802725 <__umoddi3+0x25>
  80277c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802780:	89 c8                	mov    %ecx,%eax
  802782:	89 f2                	mov    %esi,%edx
  802784:	83 c4 20             	add    $0x20,%esp
  802787:	5e                   	pop    %esi
  802788:	5f                   	pop    %edi
  802789:	5d                   	pop    %ebp
  80278a:	c3                   	ret    
  80278b:	90                   	nop
  80278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802790:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802794:	d3 e2                	shl    %cl,%edx
  802796:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802799:	ba 20 00 00 00       	mov    $0x20,%edx
  80279e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8027a1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8027a4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8027a8:	89 fa                	mov    %edi,%edx
  8027aa:	d3 ea                	shr    %cl,%edx
  8027ac:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027b0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8027b3:	d3 e7                	shl    %cl,%edi
  8027b5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8027b9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8027bc:	89 f2                	mov    %esi,%edx
  8027be:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8027c1:	89 c7                	mov    %eax,%edi
  8027c3:	d3 ea                	shr    %cl,%edx
  8027c5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027c9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8027cc:	89 c2                	mov    %eax,%edx
  8027ce:	d3 e6                	shl    %cl,%esi
  8027d0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8027d4:	d3 ea                	shr    %cl,%edx
  8027d6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027da:	09 d6                	or     %edx,%esi
  8027dc:	89 f0                	mov    %esi,%eax
  8027de:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8027e1:	d3 e7                	shl    %cl,%edi
  8027e3:	89 f2                	mov    %esi,%edx
  8027e5:	f7 75 f4             	divl   -0xc(%ebp)
  8027e8:	89 d6                	mov    %edx,%esi
  8027ea:	f7 65 e8             	mull   -0x18(%ebp)
  8027ed:	39 d6                	cmp    %edx,%esi
  8027ef:	72 2b                	jb     80281c <__umoddi3+0x11c>
  8027f1:	39 c7                	cmp    %eax,%edi
  8027f3:	72 23                	jb     802818 <__umoddi3+0x118>
  8027f5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027f9:	29 c7                	sub    %eax,%edi
  8027fb:	19 d6                	sbb    %edx,%esi
  8027fd:	89 f0                	mov    %esi,%eax
  8027ff:	89 f2                	mov    %esi,%edx
  802801:	d3 ef                	shr    %cl,%edi
  802803:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802807:	d3 e0                	shl    %cl,%eax
  802809:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80280d:	09 f8                	or     %edi,%eax
  80280f:	d3 ea                	shr    %cl,%edx
  802811:	83 c4 20             	add    $0x20,%esp
  802814:	5e                   	pop    %esi
  802815:	5f                   	pop    %edi
  802816:	5d                   	pop    %ebp
  802817:	c3                   	ret    
  802818:	39 d6                	cmp    %edx,%esi
  80281a:	75 d9                	jne    8027f5 <__umoddi3+0xf5>
  80281c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80281f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802822:	eb d1                	jmp    8027f5 <__umoddi3+0xf5>
  802824:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802828:	39 f2                	cmp    %esi,%edx
  80282a:	0f 82 18 ff ff ff    	jb     802748 <__umoddi3+0x48>
  802830:	e9 1d ff ff ff       	jmp    802752 <__umoddi3+0x52>
