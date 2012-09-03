
obj/user/sh:     file format elf32-i386


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
  80002c:	e8 5b 0a 00 00       	call   800a8c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <usage>:
}


void
usage(void)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  800046:	c7 04 24 80 3d 80 00 	movl   $0x803d80,(%esp)
  80004d:	e8 6b 0b 00 00       	call   800bbd <cprintf>
	exit();
  800052:	e8 85 0a 00 00       	call   800adc <exit>
}
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	57                   	push   %edi
  80005d:	56                   	push   %esi
  80005e:	53                   	push   %ebx
  80005f:	83 ec 1c             	sub    $0x1c,%esp
  800062:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int t;

	if (s == 0) {
  800065:	85 db                	test   %ebx,%ebx
  800067:	75 23                	jne    80008c <_gettoken+0x33>
		if (debug > 1)
  800069:	83 3d 80 80 80 00 01 	cmpl   $0x1,0x808080
  800070:	0f 8e 42 01 00 00    	jle    8001b8 <_gettoken+0x15f>
			cprintf("GETTOKEN NULL\n");
  800076:	c7 04 24 f2 3d 80 00 	movl   $0x803df2,(%esp)
  80007d:	e8 3b 0b 00 00       	call   800bbd <cprintf>
  800082:	be 00 00 00 00       	mov    $0x0,%esi
  800087:	e9 31 01 00 00       	jmp    8001bd <_gettoken+0x164>
		return 0;
	}

	if (debug > 1)
  80008c:	83 3d 80 80 80 00 01 	cmpl   $0x1,0x808080
  800093:	7e 10                	jle    8000a5 <_gettoken+0x4c>
		cprintf("GETTOKEN: %s\n", s);
  800095:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800099:	c7 04 24 01 3e 80 00 	movl   $0x803e01,(%esp)
  8000a0:	e8 18 0b 00 00       	call   800bbd <cprintf>

	*p1 = 0;
  8000a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*p2 = 0;
  8000ae:	8b 55 10             	mov    0x10(%ebp),%edx
  8000b1:	c7 02 00 00 00 00    	movl   $0x0,(%edx)

	while (strchr(WHITESPACE, *s))
  8000b7:	eb 06                	jmp    8000bf <_gettoken+0x66>
		*s++ = 0;
  8000b9:	c6 03 00             	movb   $0x0,(%ebx)
  8000bc:	83 c3 01             	add    $0x1,%ebx
		cprintf("GETTOKEN: %s\n", s);

	*p1 = 0;
	*p2 = 0;

	while (strchr(WHITESPACE, *s))
  8000bf:	0f be 03             	movsbl (%ebx),%eax
  8000c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000c6:	c7 04 24 0f 3e 80 00 	movl   $0x803e0f,(%esp)
  8000cd:	e8 bc 13 00 00       	call   80148e <strchr>
  8000d2:	85 c0                	test   %eax,%eax
  8000d4:	75 e3                	jne    8000b9 <_gettoken+0x60>
  8000d6:	89 df                	mov    %ebx,%edi
		*s++ = 0;
	if (*s == 0) {
  8000d8:	0f b6 03             	movzbl (%ebx),%eax
  8000db:	84 c0                	test   %al,%al
  8000dd:	75 23                	jne    800102 <_gettoken+0xa9>
		if (debug > 1)
  8000df:	83 3d 80 80 80 00 01 	cmpl   $0x1,0x808080
  8000e6:	0f 8e cc 00 00 00    	jle    8001b8 <_gettoken+0x15f>
			cprintf("EOL\n");
  8000ec:	c7 04 24 14 3e 80 00 	movl   $0x803e14,(%esp)
  8000f3:	e8 c5 0a 00 00       	call   800bbd <cprintf>
  8000f8:	be 00 00 00 00       	mov    $0x0,%esi
  8000fd:	e9 bb 00 00 00       	jmp    8001bd <_gettoken+0x164>
		return 0;
	}
	if (strchr(SYMBOLS, *s)) {
  800102:	0f be c0             	movsbl %al,%eax
  800105:	89 44 24 04          	mov    %eax,0x4(%esp)
  800109:	c7 04 24 25 3e 80 00 	movl   $0x803e25,(%esp)
  800110:	e8 79 13 00 00       	call   80148e <strchr>
  800115:	85 c0                	test   %eax,%eax
  800117:	74 32                	je     80014b <_gettoken+0xf2>
		t = *s;
  800119:	0f be 33             	movsbl (%ebx),%esi
		*p1 = s;
  80011c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80011f:	89 18                	mov    %ebx,(%eax)
		*s++ = 0;
  800121:	c6 03 00             	movb   $0x0,(%ebx)
		*p2 = s;
  800124:	83 c7 01             	add    $0x1,%edi
  800127:	8b 55 10             	mov    0x10(%ebp),%edx
  80012a:	89 3a                	mov    %edi,(%edx)
		if (debug > 1)
  80012c:	83 3d 80 80 80 00 01 	cmpl   $0x1,0x808080
  800133:	0f 8e 84 00 00 00    	jle    8001bd <_gettoken+0x164>
			cprintf("TOK %c\n", t);
  800139:	89 74 24 04          	mov    %esi,0x4(%esp)
  80013d:	c7 04 24 19 3e 80 00 	movl   $0x803e19,(%esp)
  800144:	e8 74 0a 00 00       	call   800bbd <cprintf>
  800149:	eb 72                	jmp    8001bd <_gettoken+0x164>
		return t;
	}
	*p1 = s;
  80014b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80014e:	89 18                	mov    %ebx,(%eax)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800150:	0f b6 03             	movzbl (%ebx),%eax
  800153:	84 c0                	test   %al,%al
  800155:	75 0c                	jne    800163 <_gettoken+0x10a>
  800157:	eb 21                	jmp    80017a <_gettoken+0x121>
		s++;
  800159:	83 c3 01             	add    $0x1,%ebx
		if (debug > 1)
			cprintf("TOK %c\n", t);
		return t;
	}
	*p1 = s;
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80015c:	0f b6 03             	movzbl (%ebx),%eax
  80015f:	84 c0                	test   %al,%al
  800161:	74 17                	je     80017a <_gettoken+0x121>
  800163:	0f be c0             	movsbl %al,%eax
  800166:	89 44 24 04          	mov    %eax,0x4(%esp)
  80016a:	c7 04 24 21 3e 80 00 	movl   $0x803e21,(%esp)
  800171:	e8 18 13 00 00       	call   80148e <strchr>
  800176:	85 c0                	test   %eax,%eax
  800178:	74 df                	je     800159 <_gettoken+0x100>
		s++;
	*p2 = s;
  80017a:	8b 55 10             	mov    0x10(%ebp),%edx
  80017d:	89 1a                	mov    %ebx,(%edx)
	if (debug > 1) {
  80017f:	be 77 00 00 00       	mov    $0x77,%esi
  800184:	83 3d 80 80 80 00 01 	cmpl   $0x1,0x808080
  80018b:	7e 30                	jle    8001bd <_gettoken+0x164>
		t = **p2;
  80018d:	0f b6 33             	movzbl (%ebx),%esi
		**p2 = 0;
  800190:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  800193:	8b 55 0c             	mov    0xc(%ebp),%edx
  800196:	8b 02                	mov    (%edx),%eax
  800198:	89 44 24 04          	mov    %eax,0x4(%esp)
  80019c:	c7 04 24 2d 3e 80 00 	movl   $0x803e2d,(%esp)
  8001a3:	e8 15 0a 00 00       	call   800bbd <cprintf>
		**p2 = t;
  8001a8:	8b 55 10             	mov    0x10(%ebp),%edx
  8001ab:	8b 02                	mov    (%edx),%eax
  8001ad:	89 f2                	mov    %esi,%edx
  8001af:	88 10                	mov    %dl,(%eax)
  8001b1:	be 77 00 00 00       	mov    $0x77,%esi
  8001b6:	eb 05                	jmp    8001bd <_gettoken+0x164>
  8001b8:	be 00 00 00 00       	mov    $0x0,%esi
	}
	return 'w';
}
  8001bd:	89 f0                	mov    %esi,%eax
  8001bf:	83 c4 1c             	add    $0x1c,%esp
  8001c2:	5b                   	pop    %ebx
  8001c3:	5e                   	pop    %esi
  8001c4:	5f                   	pop    %edi
  8001c5:	5d                   	pop    %ebp
  8001c6:	c3                   	ret    

008001c7 <gettoken>:

int
gettoken(char *s, char **p1)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	83 ec 18             	sub    $0x18,%esp
  8001cd:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  8001d0:	85 c0                	test   %eax,%eax
  8001d2:	74 24                	je     8001f8 <gettoken+0x31>
		nc = _gettoken(s, &np1, &np2);
  8001d4:	c7 44 24 08 84 80 80 	movl   $0x808084,0x8(%esp)
  8001db:	00 
  8001dc:	c7 44 24 04 88 80 80 	movl   $0x808088,0x4(%esp)
  8001e3:	00 
  8001e4:	89 04 24             	mov    %eax,(%esp)
  8001e7:	e8 6d fe ff ff       	call   800059 <_gettoken>
  8001ec:	a3 8c 80 80 00       	mov    %eax,0x80808c
  8001f1:	b8 00 00 00 00       	mov    $0x0,%eax
		return 0;
  8001f6:	eb 3c                	jmp    800234 <gettoken+0x6d>
	}
	c = nc;
  8001f8:	a1 8c 80 80 00       	mov    0x80808c,%eax
  8001fd:	a3 90 80 80 00       	mov    %eax,0x808090
	*p1 = np1;
  800202:	8b 15 88 80 80 00    	mov    0x808088,%edx
  800208:	8b 45 0c             	mov    0xc(%ebp),%eax
  80020b:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  80020d:	c7 44 24 08 84 80 80 	movl   $0x808084,0x8(%esp)
  800214:	00 
  800215:	c7 44 24 04 88 80 80 	movl   $0x808088,0x4(%esp)
  80021c:	00 
  80021d:	a1 84 80 80 00       	mov    0x808084,%eax
  800222:	89 04 24             	mov    %eax,(%esp)
  800225:	e8 2f fe ff ff       	call   800059 <_gettoken>
  80022a:	a3 8c 80 80 00       	mov    %eax,0x80808c
	return c;
  80022f:	a1 90 80 80 00       	mov    0x808090,%eax
}
  800234:	c9                   	leave  
  800235:	c3                   	ret    

00800236 <runcmd>:
// runcmd() is called in a forked child,
// so it's OK to manipulate file descriptor state.
#define MAXARGS 16
void
runcmd(char* s)
{
  800236:	55                   	push   %ebp
  800237:	89 e5                	mov    %esp,%ebp
  800239:	57                   	push   %edi
  80023a:	56                   	push   %esi
  80023b:	53                   	push   %ebx
  80023c:	81 ec 6c 04 00 00    	sub    $0x46c,%esp
	char *argv[MAXARGS], *t, argv0buf[BUFSIZ];
	int argc, c, i, r, p[2], fd, pipe_child;

	pipe_child = 0;
	gettoken(s, 0);
  800242:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800249:	00 
  80024a:	8b 45 08             	mov    0x8(%ebp),%eax
  80024d:	89 04 24             	mov    %eax,(%esp)
  800250:	e8 72 ff ff ff       	call   8001c7 <gettoken>
  800255:	be 00 00 00 00       	mov    $0x0,%esi
	
again:
	argc = 0;
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80025a:	8d 5d a4             	lea    -0x5c(%ebp),%ebx
  80025d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800261:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800268:	e8 5a ff ff ff       	call   8001c7 <gettoken>
  80026d:	83 f8 77             	cmp    $0x77,%eax
  800270:	74 3b                	je     8002ad <runcmd+0x77>
  800272:	83 f8 77             	cmp    $0x77,%eax
  800275:	7f 24                	jg     80029b <runcmd+0x65>
  800277:	83 f8 3c             	cmp    $0x3c,%eax
  80027a:	74 53                	je     8002cf <runcmd+0x99>
  80027c:	83 f8 3e             	cmp    $0x3e,%eax
  80027f:	90                   	nop
  800280:	0f 84 cd 00 00 00    	je     800353 <runcmd+0x11d>
		case 0:		// String is complete
			// Run the current command!
			goto runit;
			
		default:
			panic("bad return %d from gettoken", c);
  800286:	bf 00 00 00 00       	mov    $0x0,%edi
	gettoken(s, 0);
	
again:
	argc = 0;
	while (1) {
		switch ((c = gettoken(0, &t))) {
  80028b:	85 c0                	test   %eax,%eax
  80028d:	8d 76 00             	lea    0x0(%esi),%esi
  800290:	0f 84 4b 02 00 00    	je     8004e1 <runcmd+0x2ab>
  800296:	e9 26 02 00 00       	jmp    8004c1 <runcmd+0x28b>
  80029b:	83 f8 7c             	cmp    $0x7c,%eax
  80029e:	66 90                	xchg   %ax,%ax
  8002a0:	0f 85 1b 02 00 00    	jne    8004c1 <runcmd+0x28b>
  8002a6:	66 90                	xchg   %ax,%ax
  8002a8:	e9 27 01 00 00       	jmp    8003d4 <runcmd+0x19e>

		case 'w':	// Add an argument
			if (argc == MAXARGS) {
  8002ad:	83 fe 10             	cmp    $0x10,%esi
  8002b0:	75 11                	jne    8002c3 <runcmd+0x8d>
				cprintf("too many arguments\n");
  8002b2:	c7 04 24 37 3e 80 00 	movl   $0x803e37,(%esp)
  8002b9:	e8 ff 08 00 00       	call   800bbd <cprintf>
				exit();
  8002be:	e8 19 08 00 00       	call   800adc <exit>
			}
			argv[argc++] = t;
  8002c3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8002c6:	89 44 b5 a8          	mov    %eax,-0x58(%ebp,%esi,4)
  8002ca:	83 c6 01             	add    $0x1,%esi
			break;
  8002cd:	eb 8e                	jmp    80025d <runcmd+0x27>
			
		case '<':	// Input redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  8002cf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002da:	e8 e8 fe ff ff       	call   8001c7 <gettoken>
  8002df:	83 f8 77             	cmp    $0x77,%eax
  8002e2:	74 11                	je     8002f5 <runcmd+0xbf>
				cprintf("syntax error: < not followed by word\n");
  8002e4:	c7 04 24 a4 3d 80 00 	movl   $0x803da4,(%esp)
  8002eb:	e8 cd 08 00 00       	call   800bbd <cprintf>
				exit();
  8002f0:	e8 e7 07 00 00       	call   800adc <exit>
			}
			if ((fd = open(t, O_RDONLY)) < 0) {
  8002f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002fc:	00 
  8002fd:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800300:	89 04 24             	mov    %eax,(%esp)
  800303:	e8 ef 24 00 00       	call   8027f7 <open>
  800308:	89 c7                	mov    %eax,%edi
  80030a:	85 c0                	test   %eax,%eax
  80030c:	79 1e                	jns    80032c <runcmd+0xf6>
				cprintf("open %s for read: %e", t, fd);
  80030e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800312:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800315:	89 44 24 04          	mov    %eax,0x4(%esp)
  800319:	c7 04 24 4b 3e 80 00 	movl   $0x803e4b,(%esp)
  800320:	e8 98 08 00 00       	call   800bbd <cprintf>
				exit();
  800325:	e8 b2 07 00 00       	call   800adc <exit>
  80032a:	eb 0a                	jmp    800336 <runcmd+0x100>
			}
			if (fd != 0) {
  80032c:	85 c0                	test   %eax,%eax
  80032e:	66 90                	xchg   %ax,%ax
  800330:	0f 84 27 ff ff ff    	je     80025d <runcmd+0x27>
				dup(fd, 0);
  800336:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80033d:	00 
  80033e:	89 3c 24             	mov    %edi,(%esp)
  800341:	e8 57 21 00 00       	call   80249d <dup>
				close(fd);
  800346:	89 3c 24             	mov    %edi,(%esp)
  800349:	e8 b0 20 00 00       	call   8023fe <close>
  80034e:	e9 0a ff ff ff       	jmp    80025d <runcmd+0x27>
			}
			break;
			
		case '>':	// Output redirection
			// Grab the filename from the argument list
			if (gettoken(0, &t) != 'w') {
  800353:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800357:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80035e:	e8 64 fe ff ff       	call   8001c7 <gettoken>
  800363:	83 f8 77             	cmp    $0x77,%eax
  800366:	74 11                	je     800379 <runcmd+0x143>
				cprintf("syntax error: > not followed by word\n");
  800368:	c7 04 24 cc 3d 80 00 	movl   $0x803dcc,(%esp)
  80036f:	e8 49 08 00 00       	call   800bbd <cprintf>
				exit();
  800374:	e8 63 07 00 00       	call   800adc <exit>
			}
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  800379:	c7 44 24 04 01 03 00 	movl   $0x301,0x4(%esp)
  800380:	00 
  800381:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800384:	89 04 24             	mov    %eax,(%esp)
  800387:	e8 6b 24 00 00       	call   8027f7 <open>
  80038c:	89 c7                	mov    %eax,%edi
  80038e:	85 c0                	test   %eax,%eax
  800390:	79 1c                	jns    8003ae <runcmd+0x178>
				cprintf("open %s for write: %e", t, fd);
  800392:	89 44 24 08          	mov    %eax,0x8(%esp)
  800396:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800399:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039d:	c7 04 24 60 3e 80 00 	movl   $0x803e60,(%esp)
  8003a4:	e8 14 08 00 00       	call   800bbd <cprintf>
				exit();
  8003a9:	e8 2e 07 00 00       	call   800adc <exit>
			}
			if (fd != 1) {
  8003ae:	83 ff 01             	cmp    $0x1,%edi
  8003b1:	0f 84 a6 fe ff ff    	je     80025d <runcmd+0x27>
				dup(fd, 1);
  8003b7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8003be:	00 
  8003bf:	89 3c 24             	mov    %edi,(%esp)
  8003c2:	e8 d6 20 00 00       	call   80249d <dup>
				close(fd);
  8003c7:	89 3c 24             	mov    %edi,(%esp)
  8003ca:	e8 2f 20 00 00       	call   8023fe <close>
  8003cf:	e9 89 fe ff ff       	jmp    80025d <runcmd+0x27>
			}
			break;
			
		case '|':	// Pipe
			if ((r = pipe(p)) < 0) {
  8003d4:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  8003da:	89 04 24             	mov    %eax,(%esp)
  8003dd:	e8 87 33 00 00       	call   803769 <pipe>
  8003e2:	85 c0                	test   %eax,%eax
  8003e4:	79 15                	jns    8003fb <runcmd+0x1c5>
				cprintf("pipe: %e", r);
  8003e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ea:	c7 04 24 76 3e 80 00 	movl   $0x803e76,(%esp)
  8003f1:	e8 c7 07 00 00       	call   800bbd <cprintf>
				exit();
  8003f6:	e8 e1 06 00 00       	call   800adc <exit>
			}
			if (debug)
  8003fb:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  800402:	74 20                	je     800424 <runcmd+0x1ee>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800404:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80040a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80040e:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800414:	89 44 24 04          	mov    %eax,0x4(%esp)
  800418:	c7 04 24 7f 3e 80 00 	movl   $0x803e7f,(%esp)
  80041f:	e8 99 07 00 00       	call   800bbd <cprintf>
			if ((r = fork()) < 0) {
  800424:	e8 3e 19 00 00       	call   801d67 <fork>
  800429:	89 c7                	mov    %eax,%edi
  80042b:	85 c0                	test   %eax,%eax
  80042d:	79 15                	jns    800444 <runcmd+0x20e>
				cprintf("fork: %e", r);
  80042f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800433:	c7 04 24 33 43 80 00 	movl   $0x804333,(%esp)
  80043a:	e8 7e 07 00 00       	call   800bbd <cprintf>
				exit();
  80043f:	e8 98 06 00 00       	call   800adc <exit>
			}
			if (r == 0) {
  800444:	85 ff                	test   %edi,%edi
  800446:	75 40                	jne    800488 <runcmd+0x252>
				if (p[0] != 0) {
  800448:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  80044e:	85 c0                	test   %eax,%eax
  800450:	74 1e                	je     800470 <runcmd+0x23a>
					dup(p[0], 0);
  800452:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800459:	00 
  80045a:	89 04 24             	mov    %eax,(%esp)
  80045d:	e8 3b 20 00 00       	call   80249d <dup>
					close(p[0]);
  800462:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  800468:	89 04 24             	mov    %eax,(%esp)
  80046b:	e8 8e 1f 00 00       	call   8023fe <close>
				}
				close(p[1]);
  800470:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  800476:	89 04 24             	mov    %eax,(%esp)
  800479:	e8 80 1f 00 00       	call   8023fe <close>
  80047e:	be 00 00 00 00       	mov    $0x0,%esi
  800483:	e9 d5 fd ff ff       	jmp    80025d <runcmd+0x27>
				goto again;
			} else {
				pipe_child = r;
				if (p[1] != 1) {
  800488:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80048e:	83 f8 01             	cmp    $0x1,%eax
  800491:	74 1e                	je     8004b1 <runcmd+0x27b>
					dup(p[1], 1);
  800493:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  80049a:	00 
  80049b:	89 04 24             	mov    %eax,(%esp)
  80049e:	e8 fa 1f 00 00       	call   80249d <dup>
					close(p[1]);
  8004a3:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  8004a9:	89 04 24             	mov    %eax,(%esp)
  8004ac:	e8 4d 1f 00 00       	call   8023fe <close>
				}
				close(p[0]);
  8004b1:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  8004b7:	89 04 24             	mov    %eax,(%esp)
  8004ba:	e8 3f 1f 00 00       	call   8023fe <close>
				goto runit;
  8004bf:	eb 20                	jmp    8004e1 <runcmd+0x2ab>
		case 0:		// String is complete
			// Run the current command!
			goto runit;
			
		default:
			panic("bad return %d from gettoken", c);
  8004c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004c5:	c7 44 24 08 8c 3e 80 	movl   $0x803e8c,0x8(%esp)
  8004cc:	00 
  8004cd:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  8004d4:	00 
  8004d5:	c7 04 24 a8 3e 80 00 	movl   $0x803ea8,(%esp)
  8004dc:	e8 17 06 00 00       	call   800af8 <_panic>
		}
	}

runit:
	// Return immediately if command line was empty.
	if(argc == 0) {
  8004e1:	85 f6                	test   %esi,%esi
  8004e3:	75 1e                	jne    800503 <runcmd+0x2cd>
		if (debug)
  8004e5:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  8004ec:	0f 84 7f 01 00 00    	je     800671 <runcmd+0x43b>
			cprintf("EMPTY COMMAND\n");
  8004f2:	c7 04 24 b2 3e 80 00 	movl   $0x803eb2,(%esp)
  8004f9:	e8 bf 06 00 00       	call   800bbd <cprintf>
  8004fe:	e9 6e 01 00 00       	jmp    800671 <runcmd+0x43b>

	// Clean up command line.
	// Read all commands from the filesystem: add an initial '/' to
	// the command name.
	// This essentially acts like 'PATH=/'.
	if (argv[0][0] != '/') {
  800503:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800506:	80 38 2f             	cmpb   $0x2f,(%eax)
  800509:	74 22                	je     80052d <runcmd+0x2f7>
		argv0buf[0] = '/';
  80050b:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  800512:	89 44 24 04          	mov    %eax,0x4(%esp)
  800516:	8d 9d a4 fb ff ff    	lea    -0x45c(%ebp),%ebx
  80051c:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  800522:	89 04 24             	mov    %eax,(%esp)
  800525:	e8 60 0e 00 00       	call   80138a <strcpy>
		argv[0] = argv0buf;
  80052a:	89 5d a8             	mov    %ebx,-0x58(%ebp)
	}
	argv[argc] = 0;
  80052d:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
  800534:	00 
	
	// Print the command.
	if (debug) {
  800535:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  80053c:	74 47                	je     800585 <runcmd+0x34f>
		cprintf("[%08x] SPAWN:", env->env_id);
  80053e:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  800543:	8b 40 4c             	mov    0x4c(%eax),%eax
  800546:	89 44 24 04          	mov    %eax,0x4(%esp)
  80054a:	c7 04 24 c1 3e 80 00 	movl   $0x803ec1,(%esp)
  800551:	e8 67 06 00 00       	call   800bbd <cprintf>
		for (i = 0; argv[i]; i++)
  800556:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800559:	85 c0                	test   %eax,%eax
  80055b:	74 1c                	je     800579 <runcmd+0x343>
  80055d:	8d 5d ac             	lea    -0x54(%ebp),%ebx
			cprintf(" %s", argv[i]);
  800560:	89 44 24 04          	mov    %eax,0x4(%esp)
  800564:	c7 04 24 49 3f 80 00 	movl   $0x803f49,(%esp)
  80056b:	e8 4d 06 00 00       	call   800bbd <cprintf>
	argv[argc] = 0;
	
	// Print the command.
	if (debug) {
		cprintf("[%08x] SPAWN:", env->env_id);
		for (i = 0; argv[i]; i++)
  800570:	8b 03                	mov    (%ebx),%eax
  800572:	83 c3 04             	add    $0x4,%ebx
  800575:	85 c0                	test   %eax,%eax
  800577:	75 e7                	jne    800560 <runcmd+0x32a>
			cprintf(" %s", argv[i]);
		cprintf("\n");
  800579:	c7 04 24 12 3e 80 00 	movl   $0x803e12,(%esp)
  800580:	e8 38 06 00 00       	call   800bbd <cprintf>
	}

	// Spawn the command!
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800585:	8d 45 a8             	lea    -0x58(%ebp),%eax
  800588:	89 44 24 04          	mov    %eax,0x4(%esp)
  80058c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80058f:	89 04 24             	mov    %eax,(%esp)
  800592:	e8 69 24 00 00       	call   802a00 <spawn>
  800597:	89 c3                	mov    %eax,%ebx
  800599:	85 c0                	test   %eax,%eax
  80059b:	79 1e                	jns    8005bb <runcmd+0x385>
		cprintf("spawn %s: %e\n", argv[0], r);
  80059d:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005a1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005a8:	c7 04 24 cf 3e 80 00 	movl   $0x803ecf,(%esp)
  8005af:	e8 09 06 00 00       	call   800bbd <cprintf>

	// In the parent, close all file descriptors and wait for the
	// spawned command to exit.
	close_all();
  8005b4:	e8 c2 1e 00 00       	call   80247b <close_all>
  8005b9:	eb 5f                	jmp    80061a <runcmd+0x3e4>
  8005bb:	90                   	nop
  8005bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8005c0:	e8 b6 1e 00 00       	call   80247b <close_all>
	if (r >= 0) {
		if (debug)
  8005c5:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  8005cc:	74 23                	je     8005f1 <runcmd+0x3bb>
			cprintf("[%08x] WAIT %s %08x\n", env->env_id, argv[0], r);
  8005ce:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  8005d3:	8b 40 4c             	mov    0x4c(%eax),%eax
  8005d6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8005da:	8b 55 a8             	mov    -0x58(%ebp),%edx
  8005dd:	89 54 24 08          	mov    %edx,0x8(%esp)
  8005e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005e5:	c7 04 24 dd 3e 80 00 	movl   $0x803edd,(%esp)
  8005ec:	e8 cc 05 00 00       	call   800bbd <cprintf>
		wait(r);
  8005f1:	89 1c 24             	mov    %ebx,(%esp)
  8005f4:	e8 eb 32 00 00       	call   8038e4 <wait>
		if (debug)
  8005f9:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  800600:	74 18                	je     80061a <runcmd+0x3e4>
			cprintf("[%08x] wait finished\n", env->env_id);
  800602:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  800607:	8b 40 4c             	mov    0x4c(%eax),%eax
  80060a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80060e:	c7 04 24 f2 3e 80 00 	movl   $0x803ef2,(%esp)
  800615:	e8 a3 05 00 00       	call   800bbd <cprintf>
	}

	// If we were the left-hand part of a pipe,
	// wait for the right-hand part to finish.
	if (pipe_child) {
  80061a:	85 ff                	test   %edi,%edi
  80061c:	74 4e                	je     80066c <runcmd+0x436>
		if (debug)
  80061e:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  800625:	74 1c                	je     800643 <runcmd+0x40d>
			cprintf("[%08x] WAIT pipe_child %08x\n", env->env_id, pipe_child);
  800627:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  80062c:	8b 40 4c             	mov    0x4c(%eax),%eax
  80062f:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800633:	89 44 24 04          	mov    %eax,0x4(%esp)
  800637:	c7 04 24 08 3f 80 00 	movl   $0x803f08,(%esp)
  80063e:	e8 7a 05 00 00       	call   800bbd <cprintf>
		wait(pipe_child);
  800643:	89 3c 24             	mov    %edi,(%esp)
  800646:	e8 99 32 00 00       	call   8038e4 <wait>
		if (debug)
  80064b:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  800652:	74 18                	je     80066c <runcmd+0x436>
			cprintf("[%08x] wait finished\n", env->env_id);
  800654:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  800659:	8b 40 4c             	mov    0x4c(%eax),%eax
  80065c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800660:	c7 04 24 f2 3e 80 00 	movl   $0x803ef2,(%esp)
  800667:	e8 51 05 00 00       	call   800bbd <cprintf>
	}

	// Done!
	exit();
  80066c:	e8 6b 04 00 00       	call   800adc <exit>
}
  800671:	81 c4 6c 04 00 00    	add    $0x46c,%esp
  800677:	5b                   	pop    %ebx
  800678:	5e                   	pop    %esi
  800679:	5f                   	pop    %edi
  80067a:	5d                   	pop    %ebp
  80067b:	c3                   	ret    

0080067c <umain>:
	exit();
}

void
umain(int argc, char **argv)
{
  80067c:	55                   	push   %ebp
  80067d:	89 e5                	mov    %esp,%ebp
  80067f:	57                   	push   %edi
  800680:	56                   	push   %esi
  800681:	53                   	push   %ebx
  800682:	83 ec 3c             	sub    $0x3c,%esp
  800685:	8b 45 0c             	mov    0xc(%ebp),%eax
	int r, interactive, echocmds;

	interactive = '?';
	echocmds = 0;
	ARGBEGIN{
  800688:	85 c0                	test   %eax,%eax
  80068a:	75 03                	jne    80068f <umain+0x13>
  80068c:	8d 45 08             	lea    0x8(%ebp),%eax
  80068f:	83 3d a4 84 80 00 00 	cmpl   $0x0,0x8084a4
  800696:	75 08                	jne    8006a0 <umain+0x24>
  800698:	8b 10                	mov    (%eax),%edx
  80069a:	89 15 a4 84 80 00    	mov    %edx,0x8084a4
  8006a0:	83 c0 04             	add    $0x4,%eax
  8006a3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006a6:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  8006aa:	8b 18                	mov    (%eax),%ebx
  8006ac:	85 db                	test   %ebx,%ebx
  8006ae:	0f 84 98 00 00 00    	je     80074c <umain+0xd0>
  8006b4:	80 3b 2d             	cmpb   $0x2d,(%ebx)
  8006b7:	0f 85 8f 00 00 00    	jne    80074c <umain+0xd0>
  8006bd:	83 c3 01             	add    $0x1,%ebx
  8006c0:	0f b6 03             	movzbl (%ebx),%eax
  8006c3:	84 c0                	test   %al,%al
  8006c5:	0f 84 81 00 00 00    	je     80074c <umain+0xd0>
  8006cb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8006d2:	bf 3f 00 00 00       	mov    $0x3f,%edi
  8006d7:	be 01 00 00 00       	mov    $0x1,%esi
  8006dc:	3c 2d                	cmp    $0x2d,%al
  8006de:	75 21                	jne    800701 <umain+0x85>
  8006e0:	80 7b 01 00          	cmpb   $0x0,0x1(%ebx)
  8006e4:	75 1b                	jne    800701 <umain+0x85>
  8006e6:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  8006ea:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
  8006ee:	eb 68                	jmp    800758 <umain+0xdc>
	case 'd':
		debug++;
  8006f0:	83 05 80 80 80 00 01 	addl   $0x1,0x808080
		break;
  8006f7:	eb 05                	jmp    8006fe <umain+0x82>
		break;
	case 'x':
		echocmds = 1;
		break;
	default:
		usage();
  8006f9:	e8 42 f9 ff ff       	call   800040 <usage>
{
	int r, interactive, echocmds;

	interactive = '?';
	echocmds = 0;
	ARGBEGIN{
  8006fe:	83 c3 01             	add    $0x1,%ebx
  800701:	0f b6 03             	movzbl (%ebx),%eax
  800704:	84 c0                	test   %al,%al
  800706:	74 22                	je     80072a <umain+0xae>
  800708:	3c 69                	cmp    $0x69,%al
  80070a:	74 16                	je     800722 <umain+0xa6>
  80070c:	3c 78                	cmp    $0x78,%al
  80070e:	74 0a                	je     80071a <umain+0x9e>
  800710:	3c 64                	cmp    $0x64,%al
  800712:	75 e5                	jne    8006f9 <umain+0x7d>
  800714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800718:	eb d6                	jmp    8006f0 <umain+0x74>
  80071a:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80071d:	8d 76 00             	lea    0x0(%esi),%esi
  800720:	eb dc                	jmp    8006fe <umain+0x82>
  800722:	89 f7                	mov    %esi,%edi
  800724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800728:	eb d4                	jmp    8006fe <umain+0x82>
  80072a:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  80072e:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
  800732:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800735:	8b 18                	mov    (%eax),%ebx
  800737:	85 db                	test   %ebx,%ebx
  800739:	74 1d                	je     800758 <umain+0xdc>
  80073b:	80 3b 2d             	cmpb   $0x2d,(%ebx)
  80073e:	75 18                	jne    800758 <umain+0xdc>
  800740:	83 c3 01             	add    $0x1,%ebx
  800743:	0f b6 03             	movzbl (%ebx),%eax
  800746:	84 c0                	test   %al,%al
  800748:	75 92                	jne    8006dc <umain+0x60>
  80074a:	eb 0c                	jmp    800758 <umain+0xdc>
  80074c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800753:	bf 3f 00 00 00       	mov    $0x3f,%edi
		break;
	default:
		usage();
	}ARGEND

	if (argc > 1)
  800758:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  80075c:	7e 07                	jle    800765 <umain+0xe9>
		usage();
  80075e:	66 90                	xchg   %ax,%ax
  800760:	e8 db f8 ff ff       	call   800040 <usage>
	if (argc == 1) {
  800765:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  800769:	75 76                	jne    8007e1 <umain+0x165>
		close(0);
  80076b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800772:	e8 87 1c 00 00       	call   8023fe <close>
		if ((r = open(argv[0], O_RDONLY)) < 0)
  800777:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80077e:	00 
  80077f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800782:	8b 02                	mov    (%edx),%eax
  800784:	89 04 24             	mov    %eax,(%esp)
  800787:	e8 6b 20 00 00       	call   8027f7 <open>
  80078c:	85 c0                	test   %eax,%eax
  80078e:	79 29                	jns    8007b9 <umain+0x13d>
			panic("open %s: %e", argv[0], r);
  800790:	89 44 24 10          	mov    %eax,0x10(%esp)
  800794:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800797:	8b 02                	mov    (%edx),%eax
  800799:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80079d:	c7 44 24 08 25 3f 80 	movl   $0x803f25,0x8(%esp)
  8007a4:	00 
  8007a5:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  8007ac:	00 
  8007ad:	c7 04 24 a8 3e 80 00 	movl   $0x803ea8,(%esp)
  8007b4:	e8 3f 03 00 00       	call   800af8 <_panic>
		assert(r == 0);
  8007b9:	85 c0                	test   %eax,%eax
  8007bb:	74 24                	je     8007e1 <umain+0x165>
  8007bd:	c7 44 24 0c 31 3f 80 	movl   $0x803f31,0xc(%esp)
  8007c4:	00 
  8007c5:	c7 44 24 08 38 3f 80 	movl   $0x803f38,0x8(%esp)
  8007cc:	00 
  8007cd:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  8007d4:	00 
  8007d5:	c7 04 24 a8 3e 80 00 	movl   $0x803ea8,(%esp)
  8007dc:	e8 17 03 00 00       	call   800af8 <_panic>
	}
	if (interactive == '?')
  8007e1:	83 ff 3f             	cmp    $0x3f,%edi
  8007e4:	75 0e                	jne    8007f4 <umain+0x178>
		interactive = iscons(0);
  8007e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8007ed:	e8 34 02 00 00       	call   800a26 <iscons>
  8007f2:	89 c7                	mov    %eax,%edi
	
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
  8007f4:	83 ff 01             	cmp    $0x1,%edi
  8007f7:	19 c0                	sbb    %eax,%eax
  8007f9:	f7 d0                	not    %eax
  8007fb:	25 4d 3f 80 00       	and    $0x803f4d,%eax
  800800:	89 04 24             	mov    %eax,(%esp)
  800803:	e8 48 0a 00 00       	call   801250 <readline>
  800808:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  80080a:	85 c0                	test   %eax,%eax
  80080c:	75 1a                	jne    800828 <umain+0x1ac>
			if (debug)
  80080e:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  800815:	74 0c                	je     800823 <umain+0x1a7>
				cprintf("EXITING\n");
  800817:	c7 04 24 50 3f 80 00 	movl   $0x803f50,(%esp)
  80081e:	e8 9a 03 00 00       	call   800bbd <cprintf>
			exit();	// end of file
  800823:	e8 b4 02 00 00       	call   800adc <exit>
		}
		if (debug)
  800828:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  80082f:	74 10                	je     800841 <umain+0x1c5>
			cprintf("LINE: %s\n", buf);
  800831:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800835:	c7 04 24 59 3f 80 00 	movl   $0x803f59,(%esp)
  80083c:	e8 7c 03 00 00       	call   800bbd <cprintf>
		if (buf[0] == '#')
  800841:	80 3b 23             	cmpb   $0x23,(%ebx)
  800844:	74 ae                	je     8007f4 <umain+0x178>
			continue;
		if (echocmds)
  800846:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084a:	74 10                	je     80085c <umain+0x1e0>
			printf("# %s\n", buf);
  80084c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800850:	c7 04 24 63 3f 80 00 	movl   $0x803f63,(%esp)
  800857:	e8 2b 21 00 00       	call   802987 <printf>
		if (debug)
  80085c:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  800863:	74 0c                	je     800871 <umain+0x1f5>
			cprintf("BEFORE FORK\n");
  800865:	c7 04 24 69 3f 80 00 	movl   $0x803f69,(%esp)
  80086c:	e8 4c 03 00 00       	call   800bbd <cprintf>
		if ((r = fork()) < 0)
  800871:	e8 f1 14 00 00       	call   801d67 <fork>
  800876:	89 c6                	mov    %eax,%esi
  800878:	85 c0                	test   %eax,%eax
  80087a:	79 20                	jns    80089c <umain+0x220>
			panic("fork: %e", r);
  80087c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800880:	c7 44 24 08 33 43 80 	movl   $0x804333,0x8(%esp)
  800887:	00 
  800888:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  80088f:	00 
  800890:	c7 04 24 a8 3e 80 00 	movl   $0x803ea8,(%esp)
  800897:	e8 5c 02 00 00       	call   800af8 <_panic>
		if (debug)
  80089c:	83 3d 80 80 80 00 00 	cmpl   $0x0,0x808080
  8008a3:	74 10                	je     8008b5 <umain+0x239>
			cprintf("FORK: %d\n", r);
  8008a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a9:	c7 04 24 76 3f 80 00 	movl   $0x803f76,(%esp)
  8008b0:	e8 08 03 00 00       	call   800bbd <cprintf>
		if (r == 0) {
  8008b5:	85 f6                	test   %esi,%esi
  8008b7:	75 12                	jne    8008cb <umain+0x24f>
			runcmd(buf);
  8008b9:	89 1c 24             	mov    %ebx,(%esp)
  8008bc:	e8 75 f9 ff ff       	call   800236 <runcmd>
			exit();
  8008c1:	e8 16 02 00 00       	call   800adc <exit>
  8008c6:	e9 29 ff ff ff       	jmp    8007f4 <umain+0x178>
		} else
			wait(r);
  8008cb:	89 34 24             	mov    %esi,(%esp)
  8008ce:	66 90                	xchg   %ax,%ax
  8008d0:	e8 0f 30 00 00       	call   8038e4 <wait>
  8008d5:	e9 1a ff ff ff       	jmp    8007f4 <umain+0x178>
  8008da:	00 00                	add    %al,(%eax)
  8008dc:	00 00                	add    %al,(%eax)
	...

008008e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8008e0:	55                   	push   %ebp
  8008e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8008e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8008e8:	5d                   	pop    %ebp
  8008e9:	c3                   	ret    

008008ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8008ea:	55                   	push   %ebp
  8008eb:	89 e5                	mov    %esp,%ebp
  8008ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8008f0:	c7 44 24 04 80 3f 80 	movl   $0x803f80,0x4(%esp)
  8008f7:	00 
  8008f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fb:	89 04 24             	mov    %eax,(%esp)
  8008fe:	e8 87 0a 00 00       	call   80138a <strcpy>
	return 0;
}
  800903:	b8 00 00 00 00       	mov    $0x0,%eax
  800908:	c9                   	leave  
  800909:	c3                   	ret    

0080090a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	57                   	push   %edi
  80090e:	56                   	push   %esi
  80090f:	53                   	push   %ebx
  800910:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800916:	b8 00 00 00 00       	mov    $0x0,%eax
  80091b:	be 00 00 00 00       	mov    $0x0,%esi
  800920:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800924:	74 3f                	je     800965 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800926:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80092c:	8b 55 10             	mov    0x10(%ebp),%edx
  80092f:	29 c2                	sub    %eax,%edx
  800931:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  800933:	83 fa 7f             	cmp    $0x7f,%edx
  800936:	76 05                	jbe    80093d <devcons_write+0x33>
  800938:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80093d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800941:	03 45 0c             	add    0xc(%ebp),%eax
  800944:	89 44 24 04          	mov    %eax,0x4(%esp)
  800948:	89 3c 24             	mov    %edi,(%esp)
  80094b:	e8 f5 0b 00 00       	call   801545 <memmove>
		sys_cputs(buf, m);
  800950:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800954:	89 3c 24             	mov    %edi,(%esp)
  800957:	e8 24 0e 00 00       	call   801780 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80095c:	01 de                	add    %ebx,%esi
  80095e:	89 f0                	mov    %esi,%eax
  800960:	3b 75 10             	cmp    0x10(%ebp),%esi
  800963:	72 c7                	jb     80092c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  800965:	89 f0                	mov    %esi,%eax
  800967:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80096d:	5b                   	pop    %ebx
  80096e:	5e                   	pop    %esi
  80096f:	5f                   	pop    %edi
  800970:	5d                   	pop    %ebp
  800971:	c3                   	ret    

00800972 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800972:	55                   	push   %ebp
  800973:	89 e5                	mov    %esp,%ebp
  800975:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80097e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800985:	00 
  800986:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800989:	89 04 24             	mov    %eax,(%esp)
  80098c:	e8 ef 0d 00 00       	call   801780 <sys_cputs>
}
  800991:	c9                   	leave  
  800992:	c3                   	ret    

00800993 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  800999:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80099d:	75 07                	jne    8009a6 <devcons_read+0x13>
  80099f:	eb 28                	jmp    8009c9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8009a1:	e8 9f 11 00 00       	call   801b45 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8009a6:	66 90                	xchg   %ax,%ax
  8009a8:	e8 9f 0d 00 00       	call   80174c <sys_cgetc>
  8009ad:	85 c0                	test   %eax,%eax
  8009af:	90                   	nop
  8009b0:	74 ef                	je     8009a1 <devcons_read+0xe>
  8009b2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8009b4:	85 c0                	test   %eax,%eax
  8009b6:	78 16                	js     8009ce <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8009b8:	83 f8 04             	cmp    $0x4,%eax
  8009bb:	74 0c                	je     8009c9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8009bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c0:	88 10                	mov    %dl,(%eax)
  8009c2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8009c7:	eb 05                	jmp    8009ce <devcons_read+0x3b>
  8009c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009ce:	c9                   	leave  
  8009cf:	c3                   	ret    

008009d0 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8009d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009d9:	89 04 24             	mov    %eax,(%esp)
  8009dc:	e8 ea 15 00 00       	call   801fcb <fd_alloc>
  8009e1:	85 c0                	test   %eax,%eax
  8009e3:	78 3f                	js     800a24 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009e5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8009ec:	00 
  8009ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8009fb:	e8 e6 10 00 00       	call   801ae6 <sys_page_alloc>
  800a00:	85 c0                	test   %eax,%eax
  800a02:	78 20                	js     800a24 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800a04:	8b 15 00 80 80 00    	mov    0x808000,%edx
  800a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a0d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a12:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a1c:	89 04 24             	mov    %eax,(%esp)
  800a1f:	e8 7c 15 00 00       	call   801fa0 <fd2num>
}
  800a24:	c9                   	leave  
  800a25:	c3                   	ret    

00800a26 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800a26:	55                   	push   %ebp
  800a27:	89 e5                	mov    %esp,%ebp
  800a29:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800a2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	89 04 24             	mov    %eax,(%esp)
  800a39:	e8 ff 15 00 00       	call   80203d <fd_lookup>
  800a3e:	85 c0                	test   %eax,%eax
  800a40:	78 11                	js     800a53 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a45:	8b 00                	mov    (%eax),%eax
  800a47:	3b 05 00 80 80 00    	cmp    0x808000,%eax
  800a4d:	0f 94 c0             	sete   %al
  800a50:	0f b6 c0             	movzbl %al,%eax
}
  800a53:	c9                   	leave  
  800a54:	c3                   	ret    

00800a55 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  800a55:	55                   	push   %ebp
  800a56:	89 e5                	mov    %esp,%ebp
  800a58:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  800a5b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800a62:	00 
  800a63:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800a66:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a71:	e8 28 18 00 00       	call   80229e <read>
	if (r < 0)
  800a76:	85 c0                	test   %eax,%eax
  800a78:	78 0f                	js     800a89 <getchar+0x34>
		return r;
	if (r < 1)
  800a7a:	85 c0                	test   %eax,%eax
  800a7c:	7f 07                	jg     800a85 <getchar+0x30>
  800a7e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800a83:	eb 04                	jmp    800a89 <getchar+0x34>
		return -E_EOF;
	return c;
  800a85:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800a89:	c9                   	leave  
  800a8a:	c3                   	ret    
	...

00800a8c <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800a8c:	55                   	push   %ebp
  800a8d:	89 e5                	mov    %esp,%ebp
  800a8f:	83 ec 18             	sub    $0x18,%esp
  800a92:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800a95:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800a98:	8b 75 08             	mov    0x8(%ebp),%esi
  800a9b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  800a9e:	e8 d6 10 00 00       	call   801b79 <sys_getenvid>
  800aa3:	25 ff 03 00 00       	and    $0x3ff,%eax
  800aa8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800aab:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800ab0:	a3 a0 84 80 00       	mov    %eax,0x8084a0

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800ab5:	85 f6                	test   %esi,%esi
  800ab7:	7e 07                	jle    800ac0 <libmain+0x34>
		binaryname = argv[0];
  800ab9:	8b 03                	mov    (%ebx),%eax
  800abb:	a3 1c 80 80 00       	mov    %eax,0x80801c

	// call user main routine
	umain(argc, argv);
  800ac0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ac4:	89 34 24             	mov    %esi,(%esp)
  800ac7:	e8 b0 fb ff ff       	call   80067c <umain>

	// exit gracefully
	exit();
  800acc:	e8 0b 00 00 00       	call   800adc <exit>
}
  800ad1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800ad4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800ad7:	89 ec                	mov    %ebp,%esp
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    
	...

00800adc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800ae2:	e8 94 19 00 00       	call   80247b <close_all>
	sys_env_destroy(0);
  800ae7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800aee:	e8 ba 10 00 00       	call   801bad <sys_env_destroy>
}
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    
  800af5:	00 00                	add    %al,(%eax)
	...

00800af8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	53                   	push   %ebx
  800afc:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  800aff:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800b02:	a1 a4 84 80 00       	mov    0x8084a4,%eax
  800b07:	85 c0                	test   %eax,%eax
  800b09:	74 10                	je     800b1b <_panic+0x23>
		cprintf("%s: ", argv0);
  800b0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b0f:	c7 04 24 a3 3f 80 00 	movl   $0x803fa3,(%esp)
  800b16:	e8 a2 00 00 00       	call   800bbd <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b22:	8b 45 08             	mov    0x8(%ebp),%eax
  800b25:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b29:	a1 1c 80 80 00       	mov    0x80801c,%eax
  800b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b32:	c7 04 24 a8 3f 80 00 	movl   $0x803fa8,(%esp)
  800b39:	e8 7f 00 00 00       	call   800bbd <cprintf>
	vcprintf(fmt, ap);
  800b3e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b42:	8b 45 10             	mov    0x10(%ebp),%eax
  800b45:	89 04 24             	mov    %eax,(%esp)
  800b48:	e8 0f 00 00 00       	call   800b5c <vcprintf>
	cprintf("\n");
  800b4d:	c7 04 24 12 3e 80 00 	movl   $0x803e12,(%esp)
  800b54:	e8 64 00 00 00       	call   800bbd <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800b59:	cc                   	int3   
  800b5a:	eb fd                	jmp    800b59 <_panic+0x61>

00800b5c <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  800b5c:	55                   	push   %ebp
  800b5d:	89 e5                	mov    %esp,%ebp
  800b5f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800b65:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b6c:	00 00 00 
	b.cnt = 0;
  800b6f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b76:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b87:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b91:	c7 04 24 d7 0b 80 00 	movl   $0x800bd7,(%esp)
  800b98:	e8 d0 01 00 00       	call   800d6d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b9d:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ba7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800bad:	89 04 24             	mov    %eax,(%esp)
  800bb0:	e8 cb 0b 00 00       	call   801780 <sys_cputs>

	return b.cnt;
}
  800bb5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800bbb:	c9                   	leave  
  800bbc:	c3                   	ret    

00800bbd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800bbd:	55                   	push   %ebp
  800bbe:	89 e5                	mov    %esp,%ebp
  800bc0:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800bc3:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	89 04 24             	mov    %eax,(%esp)
  800bd0:	e8 87 ff ff ff       	call   800b5c <vcprintf>
	va_end(ap);

	return cnt;
}
  800bd5:	c9                   	leave  
  800bd6:	c3                   	ret    

00800bd7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800bd7:	55                   	push   %ebp
  800bd8:	89 e5                	mov    %esp,%ebp
  800bda:	53                   	push   %ebx
  800bdb:	83 ec 14             	sub    $0x14,%esp
  800bde:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800be1:	8b 03                	mov    (%ebx),%eax
  800be3:	8b 55 08             	mov    0x8(%ebp),%edx
  800be6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800bea:	83 c0 01             	add    $0x1,%eax
  800bed:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800bef:	3d ff 00 00 00       	cmp    $0xff,%eax
  800bf4:	75 19                	jne    800c0f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800bf6:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800bfd:	00 
  800bfe:	8d 43 08             	lea    0x8(%ebx),%eax
  800c01:	89 04 24             	mov    %eax,(%esp)
  800c04:	e8 77 0b 00 00       	call   801780 <sys_cputs>
		b->idx = 0;
  800c09:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800c0f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800c13:	83 c4 14             	add    $0x14,%esp
  800c16:	5b                   	pop    %ebx
  800c17:	5d                   	pop    %ebp
  800c18:	c3                   	ret    
  800c19:	00 00                	add    %al,(%eax)
  800c1b:	00 00                	add    %al,(%eax)
  800c1d:	00 00                	add    %al,(%eax)
	...

00800c20 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	57                   	push   %edi
  800c24:	56                   	push   %esi
  800c25:	53                   	push   %ebx
  800c26:	83 ec 4c             	sub    $0x4c,%esp
  800c29:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c2c:	89 d6                	mov    %edx,%esi
  800c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c31:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c34:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c37:	89 55 e0             	mov    %edx,-0x20(%ebp)
  800c3a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c3d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800c40:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800c43:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800c46:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c4b:	39 d1                	cmp    %edx,%ecx
  800c4d:	72 15                	jb     800c64 <printnum+0x44>
  800c4f:	77 07                	ja     800c58 <printnum+0x38>
  800c51:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800c54:	39 d0                	cmp    %edx,%eax
  800c56:	76 0c                	jbe    800c64 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c58:	83 eb 01             	sub    $0x1,%ebx
  800c5b:	85 db                	test   %ebx,%ebx
  800c5d:	8d 76 00             	lea    0x0(%esi),%esi
  800c60:	7f 61                	jg     800cc3 <printnum+0xa3>
  800c62:	eb 70                	jmp    800cd4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800c64:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800c68:	83 eb 01             	sub    $0x1,%ebx
  800c6b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800c6f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c73:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800c77:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  800c7b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800c7e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800c81:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800c84:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800c88:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800c8f:	00 
  800c90:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c93:	89 04 24             	mov    %eax,(%esp)
  800c96:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c99:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c9d:	e8 5e 2e 00 00       	call   803b00 <__udivdi3>
  800ca2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800ca5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ca8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800cac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800cb0:	89 04 24             	mov    %eax,(%esp)
  800cb3:	89 54 24 04          	mov    %edx,0x4(%esp)
  800cb7:	89 f2                	mov    %esi,%edx
  800cb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800cbc:	e8 5f ff ff ff       	call   800c20 <printnum>
  800cc1:	eb 11                	jmp    800cd4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800cc3:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cc7:	89 3c 24             	mov    %edi,(%esp)
  800cca:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800ccd:	83 eb 01             	sub    $0x1,%ebx
  800cd0:	85 db                	test   %ebx,%ebx
  800cd2:	7f ef                	jg     800cc3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800cd4:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cd8:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cdc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800cdf:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ce3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800cea:	00 
  800ceb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800cee:	89 14 24             	mov    %edx,(%esp)
  800cf1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800cf4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800cf8:	e8 33 2f 00 00       	call   803c30 <__umoddi3>
  800cfd:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d01:	0f be 80 c4 3f 80 00 	movsbl 0x803fc4(%eax),%eax
  800d08:	89 04 24             	mov    %eax,(%esp)
  800d0b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  800d0e:	83 c4 4c             	add    $0x4c,%esp
  800d11:	5b                   	pop    %ebx
  800d12:	5e                   	pop    %esi
  800d13:	5f                   	pop    %edi
  800d14:	5d                   	pop    %ebp
  800d15:	c3                   	ret    

00800d16 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d16:	55                   	push   %ebp
  800d17:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d19:	83 fa 01             	cmp    $0x1,%edx
  800d1c:	7e 0e                	jle    800d2c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  800d1e:	8b 10                	mov    (%eax),%edx
  800d20:	8d 4a 08             	lea    0x8(%edx),%ecx
  800d23:	89 08                	mov    %ecx,(%eax)
  800d25:	8b 02                	mov    (%edx),%eax
  800d27:	8b 52 04             	mov    0x4(%edx),%edx
  800d2a:	eb 22                	jmp    800d4e <getuint+0x38>
	else if (lflag)
  800d2c:	85 d2                	test   %edx,%edx
  800d2e:	74 10                	je     800d40 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800d30:	8b 10                	mov    (%eax),%edx
  800d32:	8d 4a 04             	lea    0x4(%edx),%ecx
  800d35:	89 08                	mov    %ecx,(%eax)
  800d37:	8b 02                	mov    (%edx),%eax
  800d39:	ba 00 00 00 00       	mov    $0x0,%edx
  800d3e:	eb 0e                	jmp    800d4e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800d40:	8b 10                	mov    (%eax),%edx
  800d42:	8d 4a 04             	lea    0x4(%edx),%ecx
  800d45:	89 08                	mov    %ecx,(%eax)
  800d47:	8b 02                	mov    (%edx),%eax
  800d49:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800d4e:	5d                   	pop    %ebp
  800d4f:	c3                   	ret    

00800d50 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800d56:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  800d5a:	8b 10                	mov    (%eax),%edx
  800d5c:	3b 50 04             	cmp    0x4(%eax),%edx
  800d5f:	73 0a                	jae    800d6b <sprintputch+0x1b>
		*b->buf++ = ch;
  800d61:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d64:	88 0a                	mov    %cl,(%edx)
  800d66:	83 c2 01             	add    $0x1,%edx
  800d69:	89 10                	mov    %edx,(%eax)
}
  800d6b:	5d                   	pop    %ebp
  800d6c:	c3                   	ret    

00800d6d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d6d:	55                   	push   %ebp
  800d6e:	89 e5                	mov    %esp,%ebp
  800d70:	57                   	push   %edi
  800d71:	56                   	push   %esi
  800d72:	53                   	push   %ebx
  800d73:	83 ec 5c             	sub    $0x5c,%esp
  800d76:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d79:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d7f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800d86:	eb 11                	jmp    800d99 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800d88:	85 c0                	test   %eax,%eax
  800d8a:	0f 84 09 04 00 00    	je     801199 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  800d90:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d94:	89 04 24             	mov    %eax,(%esp)
  800d97:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d99:	0f b6 03             	movzbl (%ebx),%eax
  800d9c:	83 c3 01             	add    $0x1,%ebx
  800d9f:	83 f8 25             	cmp    $0x25,%eax
  800da2:	75 e4                	jne    800d88 <vprintfmt+0x1b>
  800da4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800da8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800daf:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800db6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800dbd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dc2:	eb 06                	jmp    800dca <vprintfmt+0x5d>
  800dc4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800dc8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800dca:	0f b6 13             	movzbl (%ebx),%edx
  800dcd:	0f b6 c2             	movzbl %dl,%eax
  800dd0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800dd3:	8d 43 01             	lea    0x1(%ebx),%eax
  800dd6:	83 ea 23             	sub    $0x23,%edx
  800dd9:	80 fa 55             	cmp    $0x55,%dl
  800ddc:	0f 87 9a 03 00 00    	ja     80117c <vprintfmt+0x40f>
  800de2:	0f b6 d2             	movzbl %dl,%edx
  800de5:	ff 24 95 00 41 80 00 	jmp    *0x804100(,%edx,4)
  800dec:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800df0:	eb d6                	jmp    800dc8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800df2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800df5:	83 ea 30             	sub    $0x30,%edx
  800df8:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  800dfb:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800dfe:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800e01:	83 fb 09             	cmp    $0x9,%ebx
  800e04:	77 4c                	ja     800e52 <vprintfmt+0xe5>
  800e06:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800e09:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800e0c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  800e0f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800e12:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800e16:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800e19:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800e1c:	83 fb 09             	cmp    $0x9,%ebx
  800e1f:	76 eb                	jbe    800e0c <vprintfmt+0x9f>
  800e21:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800e24:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e27:	eb 29                	jmp    800e52 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800e29:	8b 55 14             	mov    0x14(%ebp),%edx
  800e2c:	8d 5a 04             	lea    0x4(%edx),%ebx
  800e2f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800e32:	8b 12                	mov    (%edx),%edx
  800e34:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  800e37:	eb 19                	jmp    800e52 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800e39:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800e3c:	c1 fa 1f             	sar    $0x1f,%edx
  800e3f:	f7 d2                	not    %edx
  800e41:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800e44:	eb 82                	jmp    800dc8 <vprintfmt+0x5b>
  800e46:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  800e4d:	e9 76 ff ff ff       	jmp    800dc8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800e52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e56:	0f 89 6c ff ff ff    	jns    800dc8 <vprintfmt+0x5b>
  800e5c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800e5f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800e62:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800e65:	89 55 cc             	mov    %edx,-0x34(%ebp)
  800e68:	e9 5b ff ff ff       	jmp    800dc8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e6d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800e70:	e9 53 ff ff ff       	jmp    800dc8 <vprintfmt+0x5b>
  800e75:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e78:	8b 45 14             	mov    0x14(%ebp),%eax
  800e7b:	8d 50 04             	lea    0x4(%eax),%edx
  800e7e:	89 55 14             	mov    %edx,0x14(%ebp)
  800e81:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e85:	8b 00                	mov    (%eax),%eax
  800e87:	89 04 24             	mov    %eax,(%esp)
  800e8a:	ff d7                	call   *%edi
  800e8c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800e8f:	e9 05 ff ff ff       	jmp    800d99 <vprintfmt+0x2c>
  800e94:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e97:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9a:	8d 50 04             	lea    0x4(%eax),%edx
  800e9d:	89 55 14             	mov    %edx,0x14(%ebp)
  800ea0:	8b 00                	mov    (%eax),%eax
  800ea2:	89 c2                	mov    %eax,%edx
  800ea4:	c1 fa 1f             	sar    $0x1f,%edx
  800ea7:	31 d0                	xor    %edx,%eax
  800ea9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800eab:	83 f8 0f             	cmp    $0xf,%eax
  800eae:	7f 0b                	jg     800ebb <vprintfmt+0x14e>
  800eb0:	8b 14 85 60 42 80 00 	mov    0x804260(,%eax,4),%edx
  800eb7:	85 d2                	test   %edx,%edx
  800eb9:	75 20                	jne    800edb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  800ebb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ebf:	c7 44 24 08 d5 3f 80 	movl   $0x803fd5,0x8(%esp)
  800ec6:	00 
  800ec7:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ecb:	89 3c 24             	mov    %edi,(%esp)
  800ece:	e8 4e 03 00 00       	call   801221 <printfmt>
  800ed3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ed6:	e9 be fe ff ff       	jmp    800d99 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800edb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800edf:	c7 44 24 08 4a 3f 80 	movl   $0x803f4a,0x8(%esp)
  800ee6:	00 
  800ee7:	89 74 24 04          	mov    %esi,0x4(%esp)
  800eeb:	89 3c 24             	mov    %edi,(%esp)
  800eee:	e8 2e 03 00 00       	call   801221 <printfmt>
  800ef3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800ef6:	e9 9e fe ff ff       	jmp    800d99 <vprintfmt+0x2c>
  800efb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800efe:	89 c3                	mov    %eax,%ebx
  800f00:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800f03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f06:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800f09:	8b 45 14             	mov    0x14(%ebp),%eax
  800f0c:	8d 50 04             	lea    0x4(%eax),%edx
  800f0f:	89 55 14             	mov    %edx,0x14(%ebp)
  800f12:	8b 00                	mov    (%eax),%eax
  800f14:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	75 07                	jne    800f22 <vprintfmt+0x1b5>
  800f1b:	c7 45 c4 de 3f 80 00 	movl   $0x803fde,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800f22:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  800f26:	7e 06                	jle    800f2e <vprintfmt+0x1c1>
  800f28:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  800f2c:	75 13                	jne    800f41 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f2e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800f31:	0f be 02             	movsbl (%edx),%eax
  800f34:	85 c0                	test   %eax,%eax
  800f36:	0f 85 99 00 00 00    	jne    800fd5 <vprintfmt+0x268>
  800f3c:	e9 86 00 00 00       	jmp    800fc7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f41:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800f45:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800f48:	89 0c 24             	mov    %ecx,(%esp)
  800f4b:	e8 0b 04 00 00       	call   80135b <strnlen>
  800f50:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800f53:	29 c2                	sub    %eax,%edx
  800f55:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800f58:	85 d2                	test   %edx,%edx
  800f5a:	7e d2                	jle    800f2e <vprintfmt+0x1c1>
					putch(padc, putdat);
  800f5c:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  800f60:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800f63:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  800f66:	89 d3                	mov    %edx,%ebx
  800f68:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800f6f:	89 04 24             	mov    %eax,(%esp)
  800f72:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f74:	83 eb 01             	sub    $0x1,%ebx
  800f77:	85 db                	test   %ebx,%ebx
  800f79:	7f ed                	jg     800f68 <vprintfmt+0x1fb>
  800f7b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800f7e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800f85:	eb a7                	jmp    800f2e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800f87:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800f8b:	74 18                	je     800fa5 <vprintfmt+0x238>
  800f8d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800f90:	83 fa 5e             	cmp    $0x5e,%edx
  800f93:	76 10                	jbe    800fa5 <vprintfmt+0x238>
					putch('?', putdat);
  800f95:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f99:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800fa0:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800fa3:	eb 0a                	jmp    800faf <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800fa5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800fa9:	89 04 24             	mov    %eax,(%esp)
  800fac:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800faf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800fb3:	0f be 03             	movsbl (%ebx),%eax
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	74 05                	je     800fbf <vprintfmt+0x252>
  800fba:	83 c3 01             	add    $0x1,%ebx
  800fbd:	eb 29                	jmp    800fe8 <vprintfmt+0x27b>
  800fbf:	89 fe                	mov    %edi,%esi
  800fc1:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800fc4:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800fc7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fcb:	7f 2e                	jg     800ffb <vprintfmt+0x28e>
  800fcd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800fd0:	e9 c4 fd ff ff       	jmp    800d99 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800fd5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800fd8:	83 c2 01             	add    $0x1,%edx
  800fdb:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800fde:	89 f7                	mov    %esi,%edi
  800fe0:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800fe3:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  800fe6:	89 d3                	mov    %edx,%ebx
  800fe8:	85 f6                	test   %esi,%esi
  800fea:	78 9b                	js     800f87 <vprintfmt+0x21a>
  800fec:	83 ee 01             	sub    $0x1,%esi
  800fef:	79 96                	jns    800f87 <vprintfmt+0x21a>
  800ff1:	89 fe                	mov    %edi,%esi
  800ff3:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800ff6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800ff9:	eb cc                	jmp    800fc7 <vprintfmt+0x25a>
  800ffb:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800ffe:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801001:	89 74 24 04          	mov    %esi,0x4(%esp)
  801005:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80100c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80100e:	83 eb 01             	sub    $0x1,%ebx
  801011:	85 db                	test   %ebx,%ebx
  801013:	7f ec                	jg     801001 <vprintfmt+0x294>
  801015:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  801018:	e9 7c fd ff ff       	jmp    800d99 <vprintfmt+0x2c>
  80101d:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801020:	83 f9 01             	cmp    $0x1,%ecx
  801023:	7e 16                	jle    80103b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  801025:	8b 45 14             	mov    0x14(%ebp),%eax
  801028:	8d 50 08             	lea    0x8(%eax),%edx
  80102b:	89 55 14             	mov    %edx,0x14(%ebp)
  80102e:	8b 10                	mov    (%eax),%edx
  801030:	8b 48 04             	mov    0x4(%eax),%ecx
  801033:	89 55 d0             	mov    %edx,-0x30(%ebp)
  801036:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801039:	eb 32                	jmp    80106d <vprintfmt+0x300>
	else if (lflag)
  80103b:	85 c9                	test   %ecx,%ecx
  80103d:	74 18                	je     801057 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80103f:	8b 45 14             	mov    0x14(%ebp),%eax
  801042:	8d 50 04             	lea    0x4(%eax),%edx
  801045:	89 55 14             	mov    %edx,0x14(%ebp)
  801048:	8b 00                	mov    (%eax),%eax
  80104a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80104d:	89 c1                	mov    %eax,%ecx
  80104f:	c1 f9 1f             	sar    $0x1f,%ecx
  801052:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801055:	eb 16                	jmp    80106d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  801057:	8b 45 14             	mov    0x14(%ebp),%eax
  80105a:	8d 50 04             	lea    0x4(%eax),%edx
  80105d:	89 55 14             	mov    %edx,0x14(%ebp)
  801060:	8b 00                	mov    (%eax),%eax
  801062:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801065:	89 c2                	mov    %eax,%edx
  801067:	c1 fa 1f             	sar    $0x1f,%edx
  80106a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80106d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801070:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801073:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801078:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80107c:	0f 89 b8 00 00 00    	jns    80113a <vprintfmt+0x3cd>
				putch('-', putdat);
  801082:	89 74 24 04          	mov    %esi,0x4(%esp)
  801086:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80108d:	ff d7                	call   *%edi
				num = -(long long) num;
  80108f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801092:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801095:	f7 d9                	neg    %ecx
  801097:	83 d3 00             	adc    $0x0,%ebx
  80109a:	f7 db                	neg    %ebx
  80109c:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010a1:	e9 94 00 00 00       	jmp    80113a <vprintfmt+0x3cd>
  8010a6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010a9:	89 ca                	mov    %ecx,%edx
  8010ab:	8d 45 14             	lea    0x14(%ebp),%eax
  8010ae:	e8 63 fc ff ff       	call   800d16 <getuint>
  8010b3:	89 c1                	mov    %eax,%ecx
  8010b5:	89 d3                	mov    %edx,%ebx
  8010b7:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8010bc:	eb 7c                	jmp    80113a <vprintfmt+0x3cd>
  8010be:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010c5:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8010cc:	ff d7                	call   *%edi
			putch('X', putdat);
  8010ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010d2:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8010d9:	ff d7                	call   *%edi
			putch('X', putdat);
  8010db:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010df:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8010e6:	ff d7                	call   *%edi
  8010e8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8010eb:	e9 a9 fc ff ff       	jmp    800d99 <vprintfmt+0x2c>
  8010f0:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8010f3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010f7:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8010fe:	ff d7                	call   *%edi
			putch('x', putdat);
  801100:	89 74 24 04          	mov    %esi,0x4(%esp)
  801104:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80110b:	ff d7                	call   *%edi
			num = (unsigned long long)
  80110d:	8b 45 14             	mov    0x14(%ebp),%eax
  801110:	8d 50 04             	lea    0x4(%eax),%edx
  801113:	89 55 14             	mov    %edx,0x14(%ebp)
  801116:	8b 08                	mov    (%eax),%ecx
  801118:	bb 00 00 00 00       	mov    $0x0,%ebx
  80111d:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  801122:	eb 16                	jmp    80113a <vprintfmt+0x3cd>
  801124:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801127:	89 ca                	mov    %ecx,%edx
  801129:	8d 45 14             	lea    0x14(%ebp),%eax
  80112c:	e8 e5 fb ff ff       	call   800d16 <getuint>
  801131:	89 c1                	mov    %eax,%ecx
  801133:	89 d3                	mov    %edx,%ebx
  801135:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80113a:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  80113e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801142:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801145:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801149:	89 44 24 08          	mov    %eax,0x8(%esp)
  80114d:	89 0c 24             	mov    %ecx,(%esp)
  801150:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801154:	89 f2                	mov    %esi,%edx
  801156:	89 f8                	mov    %edi,%eax
  801158:	e8 c3 fa ff ff       	call   800c20 <printnum>
  80115d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  801160:	e9 34 fc ff ff       	jmp    800d99 <vprintfmt+0x2c>
  801165:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801168:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80116b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80116f:	89 14 24             	mov    %edx,(%esp)
  801172:	ff d7                	call   *%edi
  801174:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  801177:	e9 1d fc ff ff       	jmp    800d99 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80117c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801180:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801187:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801189:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80118c:	80 38 25             	cmpb   $0x25,(%eax)
  80118f:	0f 84 04 fc ff ff    	je     800d99 <vprintfmt+0x2c>
  801195:	89 c3                	mov    %eax,%ebx
  801197:	eb f0                	jmp    801189 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  801199:	83 c4 5c             	add    $0x5c,%esp
  80119c:	5b                   	pop    %ebx
  80119d:	5e                   	pop    %esi
  80119e:	5f                   	pop    %edi
  80119f:	5d                   	pop    %ebp
  8011a0:	c3                   	ret    

008011a1 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	83 ec 28             	sub    $0x28,%esp
  8011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011aa:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8011ad:	85 c0                	test   %eax,%eax
  8011af:	74 04                	je     8011b5 <vsnprintf+0x14>
  8011b1:	85 d2                	test   %edx,%edx
  8011b3:	7f 07                	jg     8011bc <vsnprintf+0x1b>
  8011b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011ba:	eb 3b                	jmp    8011f7 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8011bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8011bf:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8011c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8011cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8011d4:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011db:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8011de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011e2:	c7 04 24 50 0d 80 00 	movl   $0x800d50,(%esp)
  8011e9:	e8 7f fb ff ff       	call   800d6d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8011ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8011f1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011f7:	c9                   	leave  
  8011f8:	c3                   	ret    

008011f9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8011ff:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  801202:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801206:	8b 45 10             	mov    0x10(%ebp),%eax
  801209:	89 44 24 08          	mov    %eax,0x8(%esp)
  80120d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801210:	89 44 24 04          	mov    %eax,0x4(%esp)
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	89 04 24             	mov    %eax,(%esp)
  80121a:	e8 82 ff ff ff       	call   8011a1 <vsnprintf>
	va_end(ap);

	return rc;
}
  80121f:	c9                   	leave  
  801220:	c3                   	ret    

00801221 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  801227:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80122a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80122e:	8b 45 10             	mov    0x10(%ebp),%eax
  801231:	89 44 24 08          	mov    %eax,0x8(%esp)
  801235:	8b 45 0c             	mov    0xc(%ebp),%eax
  801238:	89 44 24 04          	mov    %eax,0x4(%esp)
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	89 04 24             	mov    %eax,(%esp)
  801242:	e8 26 fb ff ff       	call   800d6d <vprintfmt>
	va_end(ap);
}
  801247:	c9                   	leave  
  801248:	c3                   	ret    
  801249:	00 00                	add    %al,(%eax)
  80124b:	00 00                	add    %al,(%eax)
  80124d:	00 00                	add    %al,(%eax)
	...

00801250 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	57                   	push   %edi
  801254:	56                   	push   %esi
  801255:	53                   	push   %ebx
  801256:	83 ec 1c             	sub    $0x1c,%esp
  801259:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80125c:	85 c0                	test   %eax,%eax
  80125e:	74 18                	je     801278 <readline+0x28>
		fprintf(1, "%s", prompt);
  801260:	89 44 24 08          	mov    %eax,0x8(%esp)
  801264:	c7 44 24 04 4a 3f 80 	movl   $0x803f4a,0x4(%esp)
  80126b:	00 
  80126c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801273:	e8 31 17 00 00       	call   8029a9 <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  801278:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80127f:	e8 a2 f7 ff ff       	call   800a26 <iscons>
  801284:	89 c7                	mov    %eax,%edi
  801286:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		c = getchar();
  80128b:	e8 c5 f7 ff ff       	call   800a55 <getchar>
  801290:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  801292:	85 c0                	test   %eax,%eax
  801294:	79 25                	jns    8012bb <readline+0x6b>
			if (c != -E_EOF)
  801296:	b8 00 00 00 00       	mov    $0x0,%eax
  80129b:	83 fb f8             	cmp    $0xfffffff8,%ebx
  80129e:	0f 84 8f 00 00 00    	je     801333 <readline+0xe3>
				cprintf("read error: %e\n", c);
  8012a4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8012a8:	c7 04 24 bf 42 80 00 	movl   $0x8042bf,(%esp)
  8012af:	e8 09 f9 ff ff       	call   800bbd <cprintf>
  8012b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012b9:	eb 78                	jmp    801333 <readline+0xe3>
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8012bb:	83 f8 08             	cmp    $0x8,%eax
  8012be:	74 05                	je     8012c5 <readline+0x75>
  8012c0:	83 f8 7f             	cmp    $0x7f,%eax
  8012c3:	75 1e                	jne    8012e3 <readline+0x93>
  8012c5:	85 f6                	test   %esi,%esi
  8012c7:	7e 1a                	jle    8012e3 <readline+0x93>
			if (echoing)
  8012c9:	85 ff                	test   %edi,%edi
  8012cb:	90                   	nop
  8012cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8012d0:	74 0c                	je     8012de <readline+0x8e>
				cputchar('\b');
  8012d2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  8012d9:	e8 94 f6 ff ff       	call   800972 <cputchar>
			i--;
  8012de:	83 ee 01             	sub    $0x1,%esi
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8012e1:	eb a8                	jmp    80128b <readline+0x3b>
			if (echoing)
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
  8012e3:	83 fb 1f             	cmp    $0x1f,%ebx
  8012e6:	7e 21                	jle    801309 <readline+0xb9>
  8012e8:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  8012ee:	66 90                	xchg   %ax,%ax
  8012f0:	7f 17                	jg     801309 <readline+0xb9>
			if (echoing)
  8012f2:	85 ff                	test   %edi,%edi
  8012f4:	74 08                	je     8012fe <readline+0xae>
				cputchar(c);
  8012f6:	89 1c 24             	mov    %ebx,(%esp)
  8012f9:	e8 74 f6 ff ff       	call   800972 <cputchar>
			buf[i++] = c;
  8012fe:	88 9e a0 80 80 00    	mov    %bl,0x8080a0(%esi)
  801304:	83 c6 01             	add    $0x1,%esi
  801307:	eb 82                	jmp    80128b <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  801309:	83 fb 0a             	cmp    $0xa,%ebx
  80130c:	74 09                	je     801317 <readline+0xc7>
  80130e:	83 fb 0d             	cmp    $0xd,%ebx
  801311:	0f 85 74 ff ff ff    	jne    80128b <readline+0x3b>
			if (echoing)
  801317:	85 ff                	test   %edi,%edi
  801319:	74 0c                	je     801327 <readline+0xd7>
				cputchar('\n');
  80131b:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  801322:	e8 4b f6 ff ff       	call   800972 <cputchar>
			buf[i] = 0;
  801327:	c6 86 a0 80 80 00 00 	movb   $0x0,0x8080a0(%esi)
  80132e:	b8 a0 80 80 00       	mov    $0x8080a0,%eax
			return buf;
		}
	}
}
  801333:	83 c4 1c             	add    $0x1c,%esp
  801336:	5b                   	pop    %ebx
  801337:	5e                   	pop    %esi
  801338:	5f                   	pop    %edi
  801339:	5d                   	pop    %ebp
  80133a:	c3                   	ret    
  80133b:	00 00                	add    %al,(%eax)
  80133d:	00 00                	add    %al,(%eax)
	...

00801340 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801346:	b8 00 00 00 00       	mov    $0x0,%eax
  80134b:	80 3a 00             	cmpb   $0x0,(%edx)
  80134e:	74 09                	je     801359 <strlen+0x19>
		n++;
  801350:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801353:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801357:	75 f7                	jne    801350 <strlen+0x10>
		n++;
	return n;
}
  801359:	5d                   	pop    %ebp
  80135a:	c3                   	ret    

0080135b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	53                   	push   %ebx
  80135f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801362:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801365:	85 c9                	test   %ecx,%ecx
  801367:	74 19                	je     801382 <strnlen+0x27>
  801369:	80 3b 00             	cmpb   $0x0,(%ebx)
  80136c:	74 14                	je     801382 <strnlen+0x27>
  80136e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  801373:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801376:	39 c8                	cmp    %ecx,%eax
  801378:	74 0d                	je     801387 <strnlen+0x2c>
  80137a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  80137e:	75 f3                	jne    801373 <strnlen+0x18>
  801380:	eb 05                	jmp    801387 <strnlen+0x2c>
  801382:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  801387:	5b                   	pop    %ebx
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    

0080138a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80138a:	55                   	push   %ebp
  80138b:	89 e5                	mov    %esp,%ebp
  80138d:	53                   	push   %ebx
  80138e:	8b 45 08             	mov    0x8(%ebp),%eax
  801391:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801394:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801399:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  80139d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8013a0:	83 c2 01             	add    $0x1,%edx
  8013a3:	84 c9                	test   %cl,%cl
  8013a5:	75 f2                	jne    801399 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8013a7:	5b                   	pop    %ebx
  8013a8:	5d                   	pop    %ebp
  8013a9:	c3                   	ret    

008013aa <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8013aa:	55                   	push   %ebp
  8013ab:	89 e5                	mov    %esp,%ebp
  8013ad:	56                   	push   %esi
  8013ae:	53                   	push   %ebx
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013b5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013b8:	85 f6                	test   %esi,%esi
  8013ba:	74 18                	je     8013d4 <strncpy+0x2a>
  8013bc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8013c1:	0f b6 1a             	movzbl (%edx),%ebx
  8013c4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8013c7:	80 3a 01             	cmpb   $0x1,(%edx)
  8013ca:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8013cd:	83 c1 01             	add    $0x1,%ecx
  8013d0:	39 ce                	cmp    %ecx,%esi
  8013d2:	77 ed                	ja     8013c1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  8013d4:	5b                   	pop    %ebx
  8013d5:	5e                   	pop    %esi
  8013d6:	5d                   	pop    %ebp
  8013d7:	c3                   	ret    

008013d8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8013d8:	55                   	push   %ebp
  8013d9:	89 e5                	mov    %esp,%ebp
  8013db:	56                   	push   %esi
  8013dc:	53                   	push   %ebx
  8013dd:	8b 75 08             	mov    0x8(%ebp),%esi
  8013e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8013e3:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8013e6:	89 f0                	mov    %esi,%eax
  8013e8:	85 c9                	test   %ecx,%ecx
  8013ea:	74 27                	je     801413 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  8013ec:	83 e9 01             	sub    $0x1,%ecx
  8013ef:	74 1d                	je     80140e <strlcpy+0x36>
  8013f1:	0f b6 1a             	movzbl (%edx),%ebx
  8013f4:	84 db                	test   %bl,%bl
  8013f6:	74 16                	je     80140e <strlcpy+0x36>
			*dst++ = *src++;
  8013f8:	88 18                	mov    %bl,(%eax)
  8013fa:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8013fd:	83 e9 01             	sub    $0x1,%ecx
  801400:	74 0e                	je     801410 <strlcpy+0x38>
			*dst++ = *src++;
  801402:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801405:	0f b6 1a             	movzbl (%edx),%ebx
  801408:	84 db                	test   %bl,%bl
  80140a:	75 ec                	jne    8013f8 <strlcpy+0x20>
  80140c:	eb 02                	jmp    801410 <strlcpy+0x38>
  80140e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  801410:	c6 00 00             	movb   $0x0,(%eax)
  801413:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  801415:	5b                   	pop    %ebx
  801416:	5e                   	pop    %esi
  801417:	5d                   	pop    %ebp
  801418:	c3                   	ret    

00801419 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801419:	55                   	push   %ebp
  80141a:	89 e5                	mov    %esp,%ebp
  80141c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80141f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801422:	0f b6 01             	movzbl (%ecx),%eax
  801425:	84 c0                	test   %al,%al
  801427:	74 15                	je     80143e <strcmp+0x25>
  801429:	3a 02                	cmp    (%edx),%al
  80142b:	75 11                	jne    80143e <strcmp+0x25>
		p++, q++;
  80142d:	83 c1 01             	add    $0x1,%ecx
  801430:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801433:	0f b6 01             	movzbl (%ecx),%eax
  801436:	84 c0                	test   %al,%al
  801438:	74 04                	je     80143e <strcmp+0x25>
  80143a:	3a 02                	cmp    (%edx),%al
  80143c:	74 ef                	je     80142d <strcmp+0x14>
  80143e:	0f b6 c0             	movzbl %al,%eax
  801441:	0f b6 12             	movzbl (%edx),%edx
  801444:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801446:	5d                   	pop    %ebp
  801447:	c3                   	ret    

00801448 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801448:	55                   	push   %ebp
  801449:	89 e5                	mov    %esp,%ebp
  80144b:	53                   	push   %ebx
  80144c:	8b 55 08             	mov    0x8(%ebp),%edx
  80144f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801452:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  801455:	85 c0                	test   %eax,%eax
  801457:	74 23                	je     80147c <strncmp+0x34>
  801459:	0f b6 1a             	movzbl (%edx),%ebx
  80145c:	84 db                	test   %bl,%bl
  80145e:	74 24                	je     801484 <strncmp+0x3c>
  801460:	3a 19                	cmp    (%ecx),%bl
  801462:	75 20                	jne    801484 <strncmp+0x3c>
  801464:	83 e8 01             	sub    $0x1,%eax
  801467:	74 13                	je     80147c <strncmp+0x34>
		n--, p++, q++;
  801469:	83 c2 01             	add    $0x1,%edx
  80146c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80146f:	0f b6 1a             	movzbl (%edx),%ebx
  801472:	84 db                	test   %bl,%bl
  801474:	74 0e                	je     801484 <strncmp+0x3c>
  801476:	3a 19                	cmp    (%ecx),%bl
  801478:	74 ea                	je     801464 <strncmp+0x1c>
  80147a:	eb 08                	jmp    801484 <strncmp+0x3c>
  80147c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  801481:	5b                   	pop    %ebx
  801482:	5d                   	pop    %ebp
  801483:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801484:	0f b6 02             	movzbl (%edx),%eax
  801487:	0f b6 11             	movzbl (%ecx),%edx
  80148a:	29 d0                	sub    %edx,%eax
  80148c:	eb f3                	jmp    801481 <strncmp+0x39>

0080148e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80148e:	55                   	push   %ebp
  80148f:	89 e5                	mov    %esp,%ebp
  801491:	8b 45 08             	mov    0x8(%ebp),%eax
  801494:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  801498:	0f b6 10             	movzbl (%eax),%edx
  80149b:	84 d2                	test   %dl,%dl
  80149d:	74 15                	je     8014b4 <strchr+0x26>
		if (*s == c)
  80149f:	38 ca                	cmp    %cl,%dl
  8014a1:	75 07                	jne    8014aa <strchr+0x1c>
  8014a3:	eb 14                	jmp    8014b9 <strchr+0x2b>
  8014a5:	38 ca                	cmp    %cl,%dl
  8014a7:	90                   	nop
  8014a8:	74 0f                	je     8014b9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8014aa:	83 c0 01             	add    $0x1,%eax
  8014ad:	0f b6 10             	movzbl (%eax),%edx
  8014b0:	84 d2                	test   %dl,%dl
  8014b2:	75 f1                	jne    8014a5 <strchr+0x17>
  8014b4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8014b9:	5d                   	pop    %ebp
  8014ba:	c3                   	ret    

008014bb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8014bb:	55                   	push   %ebp
  8014bc:	89 e5                	mov    %esp,%ebp
  8014be:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8014c5:	0f b6 10             	movzbl (%eax),%edx
  8014c8:	84 d2                	test   %dl,%dl
  8014ca:	74 18                	je     8014e4 <strfind+0x29>
		if (*s == c)
  8014cc:	38 ca                	cmp    %cl,%dl
  8014ce:	75 0a                	jne    8014da <strfind+0x1f>
  8014d0:	eb 12                	jmp    8014e4 <strfind+0x29>
  8014d2:	38 ca                	cmp    %cl,%dl
  8014d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8014d8:	74 0a                	je     8014e4 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8014da:	83 c0 01             	add    $0x1,%eax
  8014dd:	0f b6 10             	movzbl (%eax),%edx
  8014e0:	84 d2                	test   %dl,%dl
  8014e2:	75 ee                	jne    8014d2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  8014e4:	5d                   	pop    %ebp
  8014e5:	c3                   	ret    

008014e6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8014e6:	55                   	push   %ebp
  8014e7:	89 e5                	mov    %esp,%ebp
  8014e9:	83 ec 0c             	sub    $0xc,%esp
  8014ec:	89 1c 24             	mov    %ebx,(%esp)
  8014ef:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014f3:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8014f7:	8b 7d 08             	mov    0x8(%ebp),%edi
  8014fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801500:	85 c9                	test   %ecx,%ecx
  801502:	74 30                	je     801534 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801504:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80150a:	75 25                	jne    801531 <memset+0x4b>
  80150c:	f6 c1 03             	test   $0x3,%cl
  80150f:	75 20                	jne    801531 <memset+0x4b>
		c &= 0xFF;
  801511:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801514:	89 d3                	mov    %edx,%ebx
  801516:	c1 e3 08             	shl    $0x8,%ebx
  801519:	89 d6                	mov    %edx,%esi
  80151b:	c1 e6 18             	shl    $0x18,%esi
  80151e:	89 d0                	mov    %edx,%eax
  801520:	c1 e0 10             	shl    $0x10,%eax
  801523:	09 f0                	or     %esi,%eax
  801525:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  801527:	09 d8                	or     %ebx,%eax
  801529:	c1 e9 02             	shr    $0x2,%ecx
  80152c:	fc                   	cld    
  80152d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80152f:	eb 03                	jmp    801534 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801531:	fc                   	cld    
  801532:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801534:	89 f8                	mov    %edi,%eax
  801536:	8b 1c 24             	mov    (%esp),%ebx
  801539:	8b 74 24 04          	mov    0x4(%esp),%esi
  80153d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801541:	89 ec                	mov    %ebp,%esp
  801543:	5d                   	pop    %ebp
  801544:	c3                   	ret    

00801545 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	83 ec 08             	sub    $0x8,%esp
  80154b:	89 34 24             	mov    %esi,(%esp)
  80154e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  801558:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  80155b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  80155d:	39 c6                	cmp    %eax,%esi
  80155f:	73 35                	jae    801596 <memmove+0x51>
  801561:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801564:	39 d0                	cmp    %edx,%eax
  801566:	73 2e                	jae    801596 <memmove+0x51>
		s += n;
		d += n;
  801568:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80156a:	f6 c2 03             	test   $0x3,%dl
  80156d:	75 1b                	jne    80158a <memmove+0x45>
  80156f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801575:	75 13                	jne    80158a <memmove+0x45>
  801577:	f6 c1 03             	test   $0x3,%cl
  80157a:	75 0e                	jne    80158a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  80157c:	83 ef 04             	sub    $0x4,%edi
  80157f:	8d 72 fc             	lea    -0x4(%edx),%esi
  801582:	c1 e9 02             	shr    $0x2,%ecx
  801585:	fd                   	std    
  801586:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801588:	eb 09                	jmp    801593 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  80158a:	83 ef 01             	sub    $0x1,%edi
  80158d:	8d 72 ff             	lea    -0x1(%edx),%esi
  801590:	fd                   	std    
  801591:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801593:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801594:	eb 20                	jmp    8015b6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801596:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80159c:	75 15                	jne    8015b3 <memmove+0x6e>
  80159e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8015a4:	75 0d                	jne    8015b3 <memmove+0x6e>
  8015a6:	f6 c1 03             	test   $0x3,%cl
  8015a9:	75 08                	jne    8015b3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  8015ab:	c1 e9 02             	shr    $0x2,%ecx
  8015ae:	fc                   	cld    
  8015af:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8015b1:	eb 03                	jmp    8015b6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8015b3:	fc                   	cld    
  8015b4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8015b6:	8b 34 24             	mov    (%esp),%esi
  8015b9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8015bd:	89 ec                	mov    %ebp,%esp
  8015bf:	5d                   	pop    %ebp
  8015c0:	c3                   	ret    

008015c1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  8015c1:	55                   	push   %ebp
  8015c2:	89 e5                	mov    %esp,%ebp
  8015c4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8015c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d8:	89 04 24             	mov    %eax,(%esp)
  8015db:	e8 65 ff ff ff       	call   801545 <memmove>
}
  8015e0:	c9                   	leave  
  8015e1:	c3                   	ret    

008015e2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8015e2:	55                   	push   %ebp
  8015e3:	89 e5                	mov    %esp,%ebp
  8015e5:	57                   	push   %edi
  8015e6:	56                   	push   %esi
  8015e7:	53                   	push   %ebx
  8015e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8015eb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8015ee:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  8015f1:	85 c9                	test   %ecx,%ecx
  8015f3:	74 36                	je     80162b <memcmp+0x49>
		if (*s1 != *s2)
  8015f5:	0f b6 06             	movzbl (%esi),%eax
  8015f8:	0f b6 1f             	movzbl (%edi),%ebx
  8015fb:	38 d8                	cmp    %bl,%al
  8015fd:	74 20                	je     80161f <memcmp+0x3d>
  8015ff:	eb 14                	jmp    801615 <memcmp+0x33>
  801601:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  801606:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  80160b:	83 c2 01             	add    $0x1,%edx
  80160e:	83 e9 01             	sub    $0x1,%ecx
  801611:	38 d8                	cmp    %bl,%al
  801613:	74 12                	je     801627 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  801615:	0f b6 c0             	movzbl %al,%eax
  801618:	0f b6 db             	movzbl %bl,%ebx
  80161b:	29 d8                	sub    %ebx,%eax
  80161d:	eb 11                	jmp    801630 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80161f:	83 e9 01             	sub    $0x1,%ecx
  801622:	ba 00 00 00 00       	mov    $0x0,%edx
  801627:	85 c9                	test   %ecx,%ecx
  801629:	75 d6                	jne    801601 <memcmp+0x1f>
  80162b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  801630:	5b                   	pop    %ebx
  801631:	5e                   	pop    %esi
  801632:	5f                   	pop    %edi
  801633:	5d                   	pop    %ebp
  801634:	c3                   	ret    

00801635 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801635:	55                   	push   %ebp
  801636:	89 e5                	mov    %esp,%ebp
  801638:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80163b:	89 c2                	mov    %eax,%edx
  80163d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801640:	39 d0                	cmp    %edx,%eax
  801642:	73 15                	jae    801659 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  801644:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  801648:	38 08                	cmp    %cl,(%eax)
  80164a:	75 06                	jne    801652 <memfind+0x1d>
  80164c:	eb 0b                	jmp    801659 <memfind+0x24>
  80164e:	38 08                	cmp    %cl,(%eax)
  801650:	74 07                	je     801659 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801652:	83 c0 01             	add    $0x1,%eax
  801655:	39 c2                	cmp    %eax,%edx
  801657:	77 f5                	ja     80164e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801659:	5d                   	pop    %ebp
  80165a:	c3                   	ret    

0080165b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80165b:	55                   	push   %ebp
  80165c:	89 e5                	mov    %esp,%ebp
  80165e:	57                   	push   %edi
  80165f:	56                   	push   %esi
  801660:	53                   	push   %ebx
  801661:	83 ec 04             	sub    $0x4,%esp
  801664:	8b 55 08             	mov    0x8(%ebp),%edx
  801667:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80166a:	0f b6 02             	movzbl (%edx),%eax
  80166d:	3c 20                	cmp    $0x20,%al
  80166f:	74 04                	je     801675 <strtol+0x1a>
  801671:	3c 09                	cmp    $0x9,%al
  801673:	75 0e                	jne    801683 <strtol+0x28>
		s++;
  801675:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801678:	0f b6 02             	movzbl (%edx),%eax
  80167b:	3c 20                	cmp    $0x20,%al
  80167d:	74 f6                	je     801675 <strtol+0x1a>
  80167f:	3c 09                	cmp    $0x9,%al
  801681:	74 f2                	je     801675 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  801683:	3c 2b                	cmp    $0x2b,%al
  801685:	75 0c                	jne    801693 <strtol+0x38>
		s++;
  801687:	83 c2 01             	add    $0x1,%edx
  80168a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801691:	eb 15                	jmp    8016a8 <strtol+0x4d>
	else if (*s == '-')
  801693:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80169a:	3c 2d                	cmp    $0x2d,%al
  80169c:	75 0a                	jne    8016a8 <strtol+0x4d>
		s++, neg = 1;
  80169e:	83 c2 01             	add    $0x1,%edx
  8016a1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016a8:	85 db                	test   %ebx,%ebx
  8016aa:	0f 94 c0             	sete   %al
  8016ad:	74 05                	je     8016b4 <strtol+0x59>
  8016af:	83 fb 10             	cmp    $0x10,%ebx
  8016b2:	75 18                	jne    8016cc <strtol+0x71>
  8016b4:	80 3a 30             	cmpb   $0x30,(%edx)
  8016b7:	75 13                	jne    8016cc <strtol+0x71>
  8016b9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8016bd:	8d 76 00             	lea    0x0(%esi),%esi
  8016c0:	75 0a                	jne    8016cc <strtol+0x71>
		s += 2, base = 16;
  8016c2:	83 c2 02             	add    $0x2,%edx
  8016c5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8016ca:	eb 15                	jmp    8016e1 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8016cc:	84 c0                	test   %al,%al
  8016ce:	66 90                	xchg   %ax,%ax
  8016d0:	74 0f                	je     8016e1 <strtol+0x86>
  8016d2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  8016d7:	80 3a 30             	cmpb   $0x30,(%edx)
  8016da:	75 05                	jne    8016e1 <strtol+0x86>
		s++, base = 8;
  8016dc:	83 c2 01             	add    $0x1,%edx
  8016df:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8016e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e6:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8016e8:	0f b6 0a             	movzbl (%edx),%ecx
  8016eb:	89 cf                	mov    %ecx,%edi
  8016ed:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8016f0:	80 fb 09             	cmp    $0x9,%bl
  8016f3:	77 08                	ja     8016fd <strtol+0xa2>
			dig = *s - '0';
  8016f5:	0f be c9             	movsbl %cl,%ecx
  8016f8:	83 e9 30             	sub    $0x30,%ecx
  8016fb:	eb 1e                	jmp    80171b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  8016fd:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  801700:	80 fb 19             	cmp    $0x19,%bl
  801703:	77 08                	ja     80170d <strtol+0xb2>
			dig = *s - 'a' + 10;
  801705:	0f be c9             	movsbl %cl,%ecx
  801708:	83 e9 57             	sub    $0x57,%ecx
  80170b:	eb 0e                	jmp    80171b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  80170d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  801710:	80 fb 19             	cmp    $0x19,%bl
  801713:	77 15                	ja     80172a <strtol+0xcf>
			dig = *s - 'A' + 10;
  801715:	0f be c9             	movsbl %cl,%ecx
  801718:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80171b:	39 f1                	cmp    %esi,%ecx
  80171d:	7d 0b                	jge    80172a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  80171f:	83 c2 01             	add    $0x1,%edx
  801722:	0f af c6             	imul   %esi,%eax
  801725:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  801728:	eb be                	jmp    8016e8 <strtol+0x8d>
  80172a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80172c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801730:	74 05                	je     801737 <strtol+0xdc>
		*endptr = (char *) s;
  801732:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801735:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801737:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80173b:	74 04                	je     801741 <strtol+0xe6>
  80173d:	89 c8                	mov    %ecx,%eax
  80173f:	f7 d8                	neg    %eax
}
  801741:	83 c4 04             	add    $0x4,%esp
  801744:	5b                   	pop    %ebx
  801745:	5e                   	pop    %esi
  801746:	5f                   	pop    %edi
  801747:	5d                   	pop    %ebp
  801748:	c3                   	ret    
  801749:	00 00                	add    %al,(%eax)
	...

0080174c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  80174c:	55                   	push   %ebp
  80174d:	89 e5                	mov    %esp,%ebp
  80174f:	83 ec 0c             	sub    $0xc,%esp
  801752:	89 1c 24             	mov    %ebx,(%esp)
  801755:	89 74 24 04          	mov    %esi,0x4(%esp)
  801759:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80175d:	ba 00 00 00 00       	mov    $0x0,%edx
  801762:	b8 01 00 00 00       	mov    $0x1,%eax
  801767:	89 d1                	mov    %edx,%ecx
  801769:	89 d3                	mov    %edx,%ebx
  80176b:	89 d7                	mov    %edx,%edi
  80176d:	89 d6                	mov    %edx,%esi
  80176f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801771:	8b 1c 24             	mov    (%esp),%ebx
  801774:	8b 74 24 04          	mov    0x4(%esp),%esi
  801778:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80177c:	89 ec                	mov    %ebp,%esp
  80177e:	5d                   	pop    %ebp
  80177f:	c3                   	ret    

00801780 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
  801783:	83 ec 0c             	sub    $0xc,%esp
  801786:	89 1c 24             	mov    %ebx,(%esp)
  801789:	89 74 24 04          	mov    %esi,0x4(%esp)
  80178d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801791:	b8 00 00 00 00       	mov    $0x0,%eax
  801796:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801799:	8b 55 08             	mov    0x8(%ebp),%edx
  80179c:	89 c3                	mov    %eax,%ebx
  80179e:	89 c7                	mov    %eax,%edi
  8017a0:	89 c6                	mov    %eax,%esi
  8017a2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8017a4:	8b 1c 24             	mov    (%esp),%ebx
  8017a7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8017ab:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8017af:	89 ec                	mov    %ebp,%esp
  8017b1:	5d                   	pop    %ebp
  8017b2:	c3                   	ret    

008017b3 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 0c             	sub    $0xc,%esp
  8017b9:	89 1c 24             	mov    %ebx,(%esp)
  8017bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8017c0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017c9:	b8 10 00 00 00       	mov    $0x10,%eax
  8017ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d4:	89 df                	mov    %ebx,%edi
  8017d6:	89 de                	mov    %ebx,%esi
  8017d8:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  8017da:	8b 1c 24             	mov    (%esp),%ebx
  8017dd:	8b 74 24 04          	mov    0x4(%esp),%esi
  8017e1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8017e5:	89 ec                	mov    %ebp,%esp
  8017e7:	5d                   	pop    %ebp
  8017e8:	c3                   	ret    

008017e9 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  8017e9:	55                   	push   %ebp
  8017ea:	89 e5                	mov    %esp,%ebp
  8017ec:	83 ec 38             	sub    $0x38,%esp
  8017ef:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8017f2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8017f5:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017f8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017fd:	b8 0f 00 00 00       	mov    $0xf,%eax
  801802:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801805:	8b 55 08             	mov    0x8(%ebp),%edx
  801808:	89 df                	mov    %ebx,%edi
  80180a:	89 de                	mov    %ebx,%esi
  80180c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80180e:	85 c0                	test   %eax,%eax
  801810:	7e 28                	jle    80183a <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801812:	89 44 24 10          	mov    %eax,0x10(%esp)
  801816:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80181d:	00 
  80181e:	c7 44 24 08 cf 42 80 	movl   $0x8042cf,0x8(%esp)
  801825:	00 
  801826:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80182d:	00 
  80182e:	c7 04 24 ec 42 80 00 	movl   $0x8042ec,(%esp)
  801835:	e8 be f2 ff ff       	call   800af8 <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  80183a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80183d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801840:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801843:	89 ec                	mov    %ebp,%esp
  801845:	5d                   	pop    %ebp
  801846:	c3                   	ret    

00801847 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 0c             	sub    $0xc,%esp
  80184d:	89 1c 24             	mov    %ebx,(%esp)
  801850:	89 74 24 04          	mov    %esi,0x4(%esp)
  801854:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801858:	ba 00 00 00 00       	mov    $0x0,%edx
  80185d:	b8 0e 00 00 00       	mov    $0xe,%eax
  801862:	89 d1                	mov    %edx,%ecx
  801864:	89 d3                	mov    %edx,%ebx
  801866:	89 d7                	mov    %edx,%edi
  801868:	89 d6                	mov    %edx,%esi
  80186a:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80186c:	8b 1c 24             	mov    (%esp),%ebx
  80186f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801873:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801877:	89 ec                	mov    %ebp,%esp
  801879:	5d                   	pop    %ebp
  80187a:	c3                   	ret    

0080187b <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  80187b:	55                   	push   %ebp
  80187c:	89 e5                	mov    %esp,%ebp
  80187e:	83 ec 38             	sub    $0x38,%esp
  801881:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801884:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801887:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80188a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80188f:	b8 0d 00 00 00       	mov    $0xd,%eax
  801894:	8b 55 08             	mov    0x8(%ebp),%edx
  801897:	89 cb                	mov    %ecx,%ebx
  801899:	89 cf                	mov    %ecx,%edi
  80189b:	89 ce                	mov    %ecx,%esi
  80189d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80189f:	85 c0                	test   %eax,%eax
  8018a1:	7e 28                	jle    8018cb <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8018a3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8018a7:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8018ae:	00 
  8018af:	c7 44 24 08 cf 42 80 	movl   $0x8042cf,0x8(%esp)
  8018b6:	00 
  8018b7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8018be:	00 
  8018bf:	c7 04 24 ec 42 80 00 	movl   $0x8042ec,(%esp)
  8018c6:	e8 2d f2 ff ff       	call   800af8 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8018cb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8018ce:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8018d1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8018d4:	89 ec                	mov    %ebp,%esp
  8018d6:	5d                   	pop    %ebp
  8018d7:	c3                   	ret    

008018d8 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	83 ec 0c             	sub    $0xc,%esp
  8018de:	89 1c 24             	mov    %ebx,(%esp)
  8018e1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018e5:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018e9:	be 00 00 00 00       	mov    $0x0,%esi
  8018ee:	b8 0c 00 00 00       	mov    $0xc,%eax
  8018f3:	8b 7d 14             	mov    0x14(%ebp),%edi
  8018f6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8018ff:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801901:	8b 1c 24             	mov    (%esp),%ebx
  801904:	8b 74 24 04          	mov    0x4(%esp),%esi
  801908:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80190c:	89 ec                	mov    %ebp,%esp
  80190e:	5d                   	pop    %ebp
  80190f:	c3                   	ret    

00801910 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801910:	55                   	push   %ebp
  801911:	89 e5                	mov    %esp,%ebp
  801913:	83 ec 38             	sub    $0x38,%esp
  801916:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801919:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80191c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80191f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801924:	b8 0a 00 00 00       	mov    $0xa,%eax
  801929:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80192c:	8b 55 08             	mov    0x8(%ebp),%edx
  80192f:	89 df                	mov    %ebx,%edi
  801931:	89 de                	mov    %ebx,%esi
  801933:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801935:	85 c0                	test   %eax,%eax
  801937:	7e 28                	jle    801961 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801939:	89 44 24 10          	mov    %eax,0x10(%esp)
  80193d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801944:	00 
  801945:	c7 44 24 08 cf 42 80 	movl   $0x8042cf,0x8(%esp)
  80194c:	00 
  80194d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801954:	00 
  801955:	c7 04 24 ec 42 80 00 	movl   $0x8042ec,(%esp)
  80195c:	e8 97 f1 ff ff       	call   800af8 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801961:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801964:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801967:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80196a:	89 ec                	mov    %ebp,%esp
  80196c:	5d                   	pop    %ebp
  80196d:	c3                   	ret    

0080196e <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
  801971:	83 ec 38             	sub    $0x38,%esp
  801974:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801977:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80197a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80197d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801982:	b8 09 00 00 00       	mov    $0x9,%eax
  801987:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80198a:	8b 55 08             	mov    0x8(%ebp),%edx
  80198d:	89 df                	mov    %ebx,%edi
  80198f:	89 de                	mov    %ebx,%esi
  801991:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801993:	85 c0                	test   %eax,%eax
  801995:	7e 28                	jle    8019bf <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801997:	89 44 24 10          	mov    %eax,0x10(%esp)
  80199b:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8019a2:	00 
  8019a3:	c7 44 24 08 cf 42 80 	movl   $0x8042cf,0x8(%esp)
  8019aa:	00 
  8019ab:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8019b2:	00 
  8019b3:	c7 04 24 ec 42 80 00 	movl   $0x8042ec,(%esp)
  8019ba:	e8 39 f1 ff ff       	call   800af8 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8019bf:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8019c2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8019c5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8019c8:	89 ec                	mov    %ebp,%esp
  8019ca:	5d                   	pop    %ebp
  8019cb:	c3                   	ret    

008019cc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	83 ec 38             	sub    $0x38,%esp
  8019d2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019d5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8019d8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019e0:	b8 08 00 00 00       	mov    $0x8,%eax
  8019e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8019eb:	89 df                	mov    %ebx,%edi
  8019ed:	89 de                	mov    %ebx,%esi
  8019ef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8019f1:	85 c0                	test   %eax,%eax
  8019f3:	7e 28                	jle    801a1d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8019f5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019f9:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801a00:	00 
  801a01:	c7 44 24 08 cf 42 80 	movl   $0x8042cf,0x8(%esp)
  801a08:	00 
  801a09:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801a10:	00 
  801a11:	c7 04 24 ec 42 80 00 	movl   $0x8042ec,(%esp)
  801a18:	e8 db f0 ff ff       	call   800af8 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  801a1d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a20:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a23:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a26:	89 ec                	mov    %ebp,%esp
  801a28:	5d                   	pop    %ebp
  801a29:	c3                   	ret    

00801a2a <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
  801a2d:	83 ec 38             	sub    $0x38,%esp
  801a30:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a33:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a36:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a39:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a3e:	b8 06 00 00 00       	mov    $0x6,%eax
  801a43:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a46:	8b 55 08             	mov    0x8(%ebp),%edx
  801a49:	89 df                	mov    %ebx,%edi
  801a4b:	89 de                	mov    %ebx,%esi
  801a4d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801a4f:	85 c0                	test   %eax,%eax
  801a51:	7e 28                	jle    801a7b <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801a53:	89 44 24 10          	mov    %eax,0x10(%esp)
  801a57:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  801a5e:	00 
  801a5f:	c7 44 24 08 cf 42 80 	movl   $0x8042cf,0x8(%esp)
  801a66:	00 
  801a67:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801a6e:	00 
  801a6f:	c7 04 24 ec 42 80 00 	movl   $0x8042ec,(%esp)
  801a76:	e8 7d f0 ff ff       	call   800af8 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801a7b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a7e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a81:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a84:	89 ec                	mov    %ebp,%esp
  801a86:	5d                   	pop    %ebp
  801a87:	c3                   	ret    

00801a88 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	83 ec 38             	sub    $0x38,%esp
  801a8e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801a91:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801a94:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801a97:	b8 05 00 00 00       	mov    $0x5,%eax
  801a9c:	8b 75 18             	mov    0x18(%ebp),%esi
  801a9f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801aa2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801aa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801aa8:	8b 55 08             	mov    0x8(%ebp),%edx
  801aab:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801aad:	85 c0                	test   %eax,%eax
  801aaf:	7e 28                	jle    801ad9 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801ab1:	89 44 24 10          	mov    %eax,0x10(%esp)
  801ab5:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  801abc:	00 
  801abd:	c7 44 24 08 cf 42 80 	movl   $0x8042cf,0x8(%esp)
  801ac4:	00 
  801ac5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801acc:	00 
  801acd:	c7 04 24 ec 42 80 00 	movl   $0x8042ec,(%esp)
  801ad4:	e8 1f f0 ff ff       	call   800af8 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801ad9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801adc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801adf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801ae2:	89 ec                	mov    %ebp,%esp
  801ae4:	5d                   	pop    %ebp
  801ae5:	c3                   	ret    

00801ae6 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
  801ae9:	83 ec 38             	sub    $0x38,%esp
  801aec:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801aef:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801af2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801af5:	be 00 00 00 00       	mov    $0x0,%esi
  801afa:	b8 04 00 00 00       	mov    $0x4,%eax
  801aff:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b05:	8b 55 08             	mov    0x8(%ebp),%edx
  801b08:	89 f7                	mov    %esi,%edi
  801b0a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801b0c:	85 c0                	test   %eax,%eax
  801b0e:	7e 28                	jle    801b38 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801b10:	89 44 24 10          	mov    %eax,0x10(%esp)
  801b14:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  801b1b:	00 
  801b1c:	c7 44 24 08 cf 42 80 	movl   $0x8042cf,0x8(%esp)
  801b23:	00 
  801b24:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801b2b:	00 
  801b2c:	c7 04 24 ec 42 80 00 	movl   $0x8042ec,(%esp)
  801b33:	e8 c0 ef ff ff       	call   800af8 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801b38:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801b3b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801b3e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801b41:	89 ec                	mov    %ebp,%esp
  801b43:	5d                   	pop    %ebp
  801b44:	c3                   	ret    

00801b45 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  801b45:	55                   	push   %ebp
  801b46:	89 e5                	mov    %esp,%ebp
  801b48:	83 ec 0c             	sub    $0xc,%esp
  801b4b:	89 1c 24             	mov    %ebx,(%esp)
  801b4e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b52:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b56:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801b60:	89 d1                	mov    %edx,%ecx
  801b62:	89 d3                	mov    %edx,%ebx
  801b64:	89 d7                	mov    %edx,%edi
  801b66:	89 d6                	mov    %edx,%esi
  801b68:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801b6a:	8b 1c 24             	mov    (%esp),%ebx
  801b6d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801b71:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801b75:	89 ec                	mov    %ebp,%esp
  801b77:	5d                   	pop    %ebp
  801b78:	c3                   	ret    

00801b79 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801b79:	55                   	push   %ebp
  801b7a:	89 e5                	mov    %esp,%ebp
  801b7c:	83 ec 0c             	sub    $0xc,%esp
  801b7f:	89 1c 24             	mov    %ebx,(%esp)
  801b82:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b86:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801b8a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b8f:	b8 02 00 00 00       	mov    $0x2,%eax
  801b94:	89 d1                	mov    %edx,%ecx
  801b96:	89 d3                	mov    %edx,%ebx
  801b98:	89 d7                	mov    %edx,%edi
  801b9a:	89 d6                	mov    %edx,%esi
  801b9c:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801b9e:	8b 1c 24             	mov    (%esp),%ebx
  801ba1:	8b 74 24 04          	mov    0x4(%esp),%esi
  801ba5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801ba9:	89 ec                	mov    %ebp,%esp
  801bab:	5d                   	pop    %ebp
  801bac:	c3                   	ret    

00801bad <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
  801bb0:	83 ec 38             	sub    $0x38,%esp
  801bb3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801bb6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801bb9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801bbc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801bc1:	b8 03 00 00 00       	mov    $0x3,%eax
  801bc6:	8b 55 08             	mov    0x8(%ebp),%edx
  801bc9:	89 cb                	mov    %ecx,%ebx
  801bcb:	89 cf                	mov    %ecx,%edi
  801bcd:	89 ce                	mov    %ecx,%esi
  801bcf:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801bd1:	85 c0                	test   %eax,%eax
  801bd3:	7e 28                	jle    801bfd <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801bd5:	89 44 24 10          	mov    %eax,0x10(%esp)
  801bd9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801be0:	00 
  801be1:	c7 44 24 08 cf 42 80 	movl   $0x8042cf,0x8(%esp)
  801be8:	00 
  801be9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801bf0:	00 
  801bf1:	c7 04 24 ec 42 80 00 	movl   $0x8042ec,(%esp)
  801bf8:	e8 fb ee ff ff       	call   800af8 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801bfd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c00:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c03:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c06:	89 ec                	mov    %ebp,%esp
  801c08:	5d                   	pop    %ebp
  801c09:	c3                   	ret    
	...

00801c0c <sfork>:
}

// Challenge!
int
sfork(void)
{
  801c0c:	55                   	push   %ebp
  801c0d:	89 e5                	mov    %esp,%ebp
  801c0f:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801c12:	c7 44 24 08 fa 42 80 	movl   $0x8042fa,0x8(%esp)
  801c19:	00 
  801c1a:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  801c21:	00 
  801c22:	c7 04 24 10 43 80 00 	movl   $0x804310,(%esp)
  801c29:	e8 ca ee ff ff       	call   800af8 <_panic>

00801c2e <duppage>:
// It is also OK to panic on error.
// 

static int
duppage(envid_t envid, unsigned pn)
{
  801c2e:	55                   	push   %ebp
  801c2f:	89 e5                	mov    %esp,%ebp
  801c31:	83 ec 28             	sub    $0x28,%esp
  801c34:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801c37:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801c3a:	89 c3                	mov    %eax,%ebx
	int r;

	// LAB 4: Your code here.
     pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  801c3c:	89 d6                	mov    %edx,%esi
  801c3e:	c1 e6 0c             	shl    $0xc,%esi
  801c41:	89 f0                	mov    %esi,%eax
  801c43:	c1 e8 16             	shr    $0x16,%eax
  801c46:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
       
        if( 0 == pgDirEntry )
  801c4d:	85 c0                	test   %eax,%eax
  801c4f:	0f 84 fc 00 00 00    	je     801d51 <duppage+0x123>
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  801c55:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801c5c:	89 c2                	mov    %eax,%edx
  801c5e:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        //cprintf("Below %d",vpt[pn]);
                //if(perm!=0)  //commented nw.
                   // cprintf("perm bit %d",perm);
	
	
	if((perm & PTE_W) && (perm & PTE_SHARE))
  801c64:	25 02 04 00 00       	and    $0x402,%eax
  801c69:	3d 02 04 00 00       	cmp    $0x402,%eax
  801c6e:	75 4d                	jne    801cbd <duppage+0x8f>
	{	
		if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_SHARE|(perm & PTE_USER))) < 0)
  801c70:	81 e2 07 0a 00 00    	and    $0xa07,%edx
  801c76:	80 ce 04             	or     $0x4,%dh
  801c79:	89 54 24 10          	mov    %edx,0x10(%esp)
  801c7d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801c81:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c85:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c89:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c90:	e8 f3 fd ff ff       	call   801a88 <sys_page_map>
  801c95:	85 c0                	test   %eax,%eax
  801c97:	0f 89 bb 00 00 00    	jns    801d58 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  801c9d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ca1:	c7 44 24 08 1b 43 80 	movl   $0x80431b,0x8(%esp)
  801ca8:	00 
  801ca9:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  801cb0:	00 
  801cb1:	c7 04 24 10 43 80 00 	movl   $0x804310,(%esp)
  801cb8:	e8 3b ee ff ff       	call   800af8 <_panic>
	}	


        else if((perm & PTE_W)!=0 || (perm & PTE_COW)!=0)
  801cbd:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801cc3:	0f 84 8f 00 00 00    	je     801d58 <duppage+0x12a>
         {
          //cprintf("\nInside Setting Cow\n"); 
        if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  801cc9:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801cd0:	00 
  801cd1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801cd5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801cd9:	89 74 24 04          	mov    %esi,0x4(%esp)
  801cdd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ce4:	e8 9f fd ff ff       	call   801a88 <sys_page_map>
  801ce9:	85 c0                	test   %eax,%eax
  801ceb:	79 20                	jns    801d0d <duppage+0xdf>
                panic("sys_page_map: %e", r);
  801ced:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cf1:	c7 44 24 08 1b 43 80 	movl   $0x80431b,0x8(%esp)
  801cf8:	00 
  801cf9:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801d00:	00 
  801d01:	c7 04 24 10 43 80 00 	movl   $0x804310,(%esp)
  801d08:	e8 eb ed ff ff       	call   800af8 <_panic>
        if ((r = sys_page_map(envid,(void *)(pn*PGSIZE),0,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  801d0d:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801d14:	00 
  801d15:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801d19:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d20:	00 
  801d21:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d25:	89 1c 24             	mov    %ebx,(%esp)
  801d28:	e8 5b fd ff ff       	call   801a88 <sys_page_map>
  801d2d:	85 c0                	test   %eax,%eax
  801d2f:	79 27                	jns    801d58 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  801d31:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d35:	c7 44 24 08 1b 43 80 	movl   $0x80431b,0x8(%esp)
  801d3c:	00 
  801d3d:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801d44:	00 
  801d45:	c7 04 24 10 43 80 00 	movl   $0x804310,(%esp)
  801d4c:	e8 a7 ed ff ff       	call   800af8 <_panic>
  801d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801d56:	eb 05                	jmp    801d5d <duppage+0x12f>
  801d58:	b8 00 00 00 00       	mov    $0x0,%eax
         }


//	panic("duppage not implemented");
	return 0;
}
  801d5d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801d60:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801d63:	89 ec                	mov    %ebp,%esp
  801d65:	5d                   	pop    %ebp
  801d66:	c3                   	ret    

00801d67 <fork>:
//


envid_t
fork(void)
{
  801d67:	55                   	push   %ebp
  801d68:	89 e5                	mov    %esp,%ebp
  801d6a:	56                   	push   %esi
  801d6b:	53                   	push   %ebx
  801d6c:	83 ec 10             	sub    $0x10,%esp

        envid_t envid;
        uint8_t *addr;
        int r;
        extern unsigned char end[];
        set_pgfault_handler(pgfault);
  801d6f:	c7 04 24 7e 1e 80 00 	movl   $0x801e7e,(%esp)
  801d76:	e8 d5 1b 00 00       	call   803950 <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801d7b:	be 07 00 00 00       	mov    $0x7,%esi
  801d80:	89 f0                	mov    %esi,%eax
  801d82:	cd 30                	int    $0x30
  801d84:	89 c6                	mov    %eax,%esi

        envid = sys_exofork();
        if (envid < 0)
  801d86:	85 c0                	test   %eax,%eax
  801d88:	79 20                	jns    801daa <fork+0x43>
                panic("sys_exofork: %e", envid);
  801d8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d8e:	c7 44 24 08 2c 43 80 	movl   $0x80432c,0x8(%esp)
  801d95:	00 
  801d96:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  801d9d:	00 
  801d9e:	c7 04 24 10 43 80 00 	movl   $0x804310,(%esp)
  801da5:	e8 4e ed ff ff       	call   800af8 <_panic>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
  801daa:	bb 00 00 80 00       	mov    $0x800000,%ebx
        set_pgfault_handler(pgfault);

        envid = sys_exofork();
        if (envid < 0)
                panic("sys_exofork: %e", envid);
        if (envid == 0) {
  801daf:	85 c0                	test   %eax,%eax
  801db1:	75 1c                	jne    801dcf <fork+0x68>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
  801db3:	e8 c1 fd ff ff       	call   801b79 <sys_getenvid>
  801db8:	25 ff 03 00 00       	and    $0x3ff,%eax
  801dbd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801dc0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801dc5:	a3 a0 84 80 00       	mov    %eax,0x8084a0
                return 0;
  801dca:	e9 a6 00 00 00       	jmp    801e75 <fork+0x10e>
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
  801dcf:	89 da                	mov    %ebx,%edx
  801dd1:	c1 ea 0c             	shr    $0xc,%edx
  801dd4:	89 f0                	mov    %esi,%eax
  801dd6:	e8 53 fe ff ff       	call   801c2e <duppage>
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
  801ddb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801de1:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801de7:	75 e6                	jne    801dcf <fork+0x68>
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
                }
              duppage(envid,VPN(USTACKTOP-PGSIZE));
  801de9:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  801dee:	89 f0                	mov    %esi,%eax
  801df0:	e8 39 fe ff ff       	call   801c2e <duppage>
        // Also copy the stack we are currently running on.
       //if(sys_page_alloc(envid, (void *)(ROUNDDOWN(&addr, PGSIZE)),PTE_U|PTE_P|PTE_W)<0)
         //                      panic("stack not allocated");
     
   
     sys_env_set_pgfault_upcall(envid,env->env_pgfault_upcall);
  801df5:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  801dfa:	8b 40 64             	mov    0x64(%eax),%eax
  801dfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e01:	89 34 24             	mov    %esi,(%esp)
  801e04:	e8 07 fb ff ff       	call   801910 <sys_env_set_pgfault_upcall>

     if(sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  801e09:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801e10:	00 
  801e11:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801e18:	ee 
  801e19:	89 34 24             	mov    %esi,(%esp)
  801e1c:	e8 c5 fc ff ff       	call   801ae6 <sys_page_alloc>
  801e21:	85 c0                	test   %eax,%eax
  801e23:	79 1c                	jns    801e41 <fork+0xda>
                          panic("Cant allocate Page");
  801e25:	c7 44 24 08 3c 43 80 	movl   $0x80433c,0x8(%esp)
  801e2c:	00 
  801e2d:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  801e34:	00 
  801e35:	c7 04 24 10 43 80 00 	movl   $0x804310,(%esp)
  801e3c:	e8 b7 ec ff ff       	call   800af8 <_panic>

        // Start the child environment running
        if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801e41:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801e48:	00 
  801e49:	89 34 24             	mov    %esi,(%esp)
  801e4c:	e8 7b fb ff ff       	call   8019cc <sys_env_set_status>
  801e51:	85 c0                	test   %eax,%eax
  801e53:	79 20                	jns    801e75 <fork+0x10e>
                panic("sys_env_set_status: %e", r);
  801e55:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e59:	c7 44 24 08 4f 43 80 	movl   $0x80434f,0x8(%esp)
  801e60:	00 
  801e61:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  801e68:	00 
  801e69:	c7 04 24 10 43 80 00 	movl   $0x804310,(%esp)
  801e70:	e8 83 ec ff ff       	call   800af8 <_panic>
         return envid;
           
//panic("fork not implemented");
}
  801e75:	89 f0                	mov    %esi,%eax
  801e77:	83 c4 10             	add    $0x10,%esp
  801e7a:	5b                   	pop    %ebx
  801e7b:	5e                   	pop    %esi
  801e7c:	5d                   	pop    %ebp
  801e7d:	c3                   	ret    

00801e7e <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  801e7e:	55                   	push   %ebp
  801e7f:	89 e5                	mov    %esp,%ebp
  801e81:	53                   	push   %ebx
  801e82:	83 ec 24             	sub    $0x24,%esp
  801e85:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801e88:	8b 18                	mov    (%eax),%ebx
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).
 
         int perm = vpt[VPN(addr)] & 0xFFF;
  801e8a:	89 da                	mov    %ebx,%edx
  801e8c:	c1 ea 0c             	shr    $0xc,%edx
  801e8f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx

static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
  801e96:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801e9a:	74 21                	je     801ebd <pgfault+0x3f>
 
         int perm = vpt[VPN(addr)] & 0xFFF;
        if((err & FEC_WR)!=0)
           {
//              cprintf("\n>>>>>Due to write\n");
            if((perm & PTE_COW) == 0)
  801e9c:	f6 c6 08             	test   $0x8,%dh
  801e9f:	75 1c                	jne    801ebd <pgfault+0x3f>
             {
                   panic("Not Set Cow");
  801ea1:	c7 44 24 08 66 43 80 	movl   $0x804366,0x8(%esp)
  801ea8:	00 
  801ea9:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801eb0:	00 
  801eb1:	c7 04 24 10 43 80 00 	movl   $0x804310,(%esp)
  801eb8:	e8 3b ec ff ff       	call   800af8 <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
        if(sys_page_alloc(0,PFTEMP,PTE_P|PTE_U|PTE_W)<0)
  801ebd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801ec4:	00 
  801ec5:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801ecc:	00 
  801ecd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801ed4:	e8 0d fc ff ff       	call   801ae6 <sys_page_alloc>
  801ed9:	85 c0                	test   %eax,%eax
  801edb:	79 1c                	jns    801ef9 <pgfault+0x7b>
              panic("\nPage not allocated\n");
  801edd:	c7 44 24 08 72 43 80 	movl   $0x804372,0x8(%esp)
  801ee4:	00 
  801ee5:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  801eec:	00 
  801eed:	c7 04 24 10 43 80 00 	movl   $0x804310,(%esp)
  801ef4:	e8 ff eb ff ff       	call   800af8 <_panic>
           memmove(PFTEMP,ROUNDDOWN(addr,PGSIZE),PGSIZE);
  801ef9:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  801eff:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801f06:	00 
  801f07:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f0b:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801f12:	e8 2e f6 ff ff       	call   801545 <memmove>
          if(sys_page_map(0,ROUNDDOWN(PFTEMP,PGSIZE),0,ROUNDDOWN(addr,PGSIZE),PTE_U|PTE_P|PTE_W)<0)
  801f17:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801f1e:	00 
  801f1f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801f23:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f2a:	00 
  801f2b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801f32:	00 
  801f33:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f3a:	e8 49 fb ff ff       	call   801a88 <sys_page_map>
  801f3f:	85 c0                	test   %eax,%eax
  801f41:	79 1c                	jns    801f5f <pgfault+0xe1>
                   panic("not mapped properly");
  801f43:	c7 44 24 08 87 43 80 	movl   $0x804387,0x8(%esp)
  801f4a:	00 
  801f4b:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801f52:	00 
  801f53:	c7 04 24 10 43 80 00 	movl   $0x804310,(%esp)
  801f5a:	e8 99 eb ff ff       	call   800af8 <_panic>
         if( 0 > sys_page_unmap(0, PFTEMP) )
  801f5f:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801f66:	00 
  801f67:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f6e:	e8 b7 fa ff ff       	call   801a2a <sys_page_unmap>
  801f73:	85 c0                	test   %eax,%eax
  801f75:	79 1c                	jns    801f93 <pgfault+0x115>
                panic("sys_page_unmap failed\n");
  801f77:	c7 44 24 08 9b 43 80 	movl   $0x80439b,0x8(%esp)
  801f7e:	00 
  801f7f:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  801f86:	00 
  801f87:	c7 04 24 10 43 80 00 	movl   $0x804310,(%esp)
  801f8e:	e8 65 eb ff ff       	call   800af8 <_panic>
   
//	panic("pgfault not implemented");
}
  801f93:	83 c4 24             	add    $0x24,%esp
  801f96:	5b                   	pop    %ebx
  801f97:	5d                   	pop    %ebp
  801f98:	c3                   	ret    
  801f99:	00 00                	add    %al,(%eax)
  801f9b:	00 00                	add    %al,(%eax)
  801f9d:	00 00                	add    %al,(%eax)
	...

00801fa0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa6:	05 00 00 00 30       	add    $0x30000000,%eax
  801fab:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  801fae:	5d                   	pop    %ebp
  801faf:	c3                   	ret    

00801fb0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	89 04 24             	mov    %eax,(%esp)
  801fbc:	e8 df ff ff ff       	call   801fa0 <fd2num>
  801fc1:	05 20 00 0d 00       	add    $0xd0020,%eax
  801fc6:	c1 e0 0c             	shl    $0xc,%eax
}
  801fc9:	c9                   	leave  
  801fca:	c3                   	ret    

00801fcb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801fcb:	55                   	push   %ebp
  801fcc:	89 e5                	mov    %esp,%ebp
  801fce:	57                   	push   %edi
  801fcf:	56                   	push   %esi
  801fd0:	53                   	push   %ebx
  801fd1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801fd4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801fd9:	a8 01                	test   $0x1,%al
  801fdb:	74 36                	je     802013 <fd_alloc+0x48>
  801fdd:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801fe2:	a8 01                	test   $0x1,%al
  801fe4:	74 2d                	je     802013 <fd_alloc+0x48>
  801fe6:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  801feb:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801ff0:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801ff5:	89 c3                	mov    %eax,%ebx
  801ff7:	89 c2                	mov    %eax,%edx
  801ff9:	c1 ea 16             	shr    $0x16,%edx
  801ffc:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  801fff:	f6 c2 01             	test   $0x1,%dl
  802002:	74 14                	je     802018 <fd_alloc+0x4d>
  802004:	89 c2                	mov    %eax,%edx
  802006:	c1 ea 0c             	shr    $0xc,%edx
  802009:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80200c:	f6 c2 01             	test   $0x1,%dl
  80200f:	75 10                	jne    802021 <fd_alloc+0x56>
  802011:	eb 05                	jmp    802018 <fd_alloc+0x4d>
  802013:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  802018:	89 1f                	mov    %ebx,(%edi)
  80201a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80201f:	eb 17                	jmp    802038 <fd_alloc+0x6d>
  802021:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  802026:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80202b:	75 c8                	jne    801ff5 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80202d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  802033:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  802038:	5b                   	pop    %ebx
  802039:	5e                   	pop    %esi
  80203a:	5f                   	pop    %edi
  80203b:	5d                   	pop    %ebp
  80203c:	c3                   	ret    

0080203d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  802040:	8b 45 08             	mov    0x8(%ebp),%eax
  802043:	83 f8 1f             	cmp    $0x1f,%eax
  802046:	77 36                	ja     80207e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  802048:	05 00 00 0d 00       	add    $0xd0000,%eax
  80204d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  802050:	89 c2                	mov    %eax,%edx
  802052:	c1 ea 16             	shr    $0x16,%edx
  802055:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80205c:	f6 c2 01             	test   $0x1,%dl
  80205f:	74 1d                	je     80207e <fd_lookup+0x41>
  802061:	89 c2                	mov    %eax,%edx
  802063:	c1 ea 0c             	shr    $0xc,%edx
  802066:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80206d:	f6 c2 01             	test   $0x1,%dl
  802070:	74 0c                	je     80207e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  802072:	8b 55 0c             	mov    0xc(%ebp),%edx
  802075:	89 02                	mov    %eax,(%edx)
  802077:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80207c:	eb 05                	jmp    802083 <fd_lookup+0x46>
  80207e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  802083:	5d                   	pop    %ebp
  802084:	c3                   	ret    

00802085 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  802085:	55                   	push   %ebp
  802086:	89 e5                	mov    %esp,%ebp
  802088:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80208b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80208e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	89 04 24             	mov    %eax,(%esp)
  802098:	e8 a0 ff ff ff       	call   80203d <fd_lookup>
  80209d:	85 c0                	test   %eax,%eax
  80209f:	78 0e                	js     8020af <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8020a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a7:	89 50 04             	mov    %edx,0x4(%eax)
  8020aa:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8020af:	c9                   	leave  
  8020b0:	c3                   	ret    

008020b1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8020b1:	55                   	push   %ebp
  8020b2:	89 e5                	mov    %esp,%ebp
  8020b4:	56                   	push   %esi
  8020b5:	53                   	push   %ebx
  8020b6:	83 ec 10             	sub    $0x10,%esp
  8020b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8020bc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  8020bf:	b8 20 80 80 00       	mov    $0x808020,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  8020c4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8020c9:	be 30 44 80 00       	mov    $0x804430,%esi
		if (devtab[i]->dev_id == dev_id) {
  8020ce:	39 08                	cmp    %ecx,(%eax)
  8020d0:	75 10                	jne    8020e2 <dev_lookup+0x31>
  8020d2:	eb 04                	jmp    8020d8 <dev_lookup+0x27>
  8020d4:	39 08                	cmp    %ecx,(%eax)
  8020d6:	75 0a                	jne    8020e2 <dev_lookup+0x31>
			*dev = devtab[i];
  8020d8:	89 03                	mov    %eax,(%ebx)
  8020da:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8020df:	90                   	nop
  8020e0:	eb 31                	jmp    802113 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8020e2:	83 c2 01             	add    $0x1,%edx
  8020e5:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8020e8:	85 c0                	test   %eax,%eax
  8020ea:	75 e8                	jne    8020d4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8020ec:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  8020f1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8020f4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020fc:	c7 04 24 b4 43 80 00 	movl   $0x8043b4,(%esp)
  802103:	e8 b5 ea ff ff       	call   800bbd <cprintf>
	*dev = 0;
  802108:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80210e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  802113:	83 c4 10             	add    $0x10,%esp
  802116:	5b                   	pop    %ebx
  802117:	5e                   	pop    %esi
  802118:	5d                   	pop    %ebp
  802119:	c3                   	ret    

0080211a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	53                   	push   %ebx
  80211e:	83 ec 24             	sub    $0x24,%esp
  802121:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802124:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802127:	89 44 24 04          	mov    %eax,0x4(%esp)
  80212b:	8b 45 08             	mov    0x8(%ebp),%eax
  80212e:	89 04 24             	mov    %eax,(%esp)
  802131:	e8 07 ff ff ff       	call   80203d <fd_lookup>
  802136:	85 c0                	test   %eax,%eax
  802138:	78 53                	js     80218d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80213a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80213d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802141:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802144:	8b 00                	mov    (%eax),%eax
  802146:	89 04 24             	mov    %eax,(%esp)
  802149:	e8 63 ff ff ff       	call   8020b1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80214e:	85 c0                	test   %eax,%eax
  802150:	78 3b                	js     80218d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  802152:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802157:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80215e:	74 2d                	je     80218d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802160:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802163:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80216a:	00 00 00 
	stat->st_isdir = 0;
  80216d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802174:	00 00 00 
	stat->st_dev = dev;
  802177:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802180:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802184:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802187:	89 14 24             	mov    %edx,(%esp)
  80218a:	ff 50 14             	call   *0x14(%eax)
}
  80218d:	83 c4 24             	add    $0x24,%esp
  802190:	5b                   	pop    %ebx
  802191:	5d                   	pop    %ebp
  802192:	c3                   	ret    

00802193 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  802193:	55                   	push   %ebp
  802194:	89 e5                	mov    %esp,%ebp
  802196:	53                   	push   %ebx
  802197:	83 ec 24             	sub    $0x24,%esp
  80219a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80219d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a4:	89 1c 24             	mov    %ebx,(%esp)
  8021a7:	e8 91 fe ff ff       	call   80203d <fd_lookup>
  8021ac:	85 c0                	test   %eax,%eax
  8021ae:	78 5f                	js     80220f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021ba:	8b 00                	mov    (%eax),%eax
  8021bc:	89 04 24             	mov    %eax,(%esp)
  8021bf:	e8 ed fe ff ff       	call   8020b1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021c4:	85 c0                	test   %eax,%eax
  8021c6:	78 47                	js     80220f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8021c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8021cb:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8021cf:	75 23                	jne    8021f4 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8021d1:	a1 a0 84 80 00       	mov    0x8084a0,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8021d6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8021d9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e1:	c7 04 24 d4 43 80 00 	movl   $0x8043d4,(%esp)
  8021e8:	e8 d0 e9 ff ff       	call   800bbd <cprintf>
  8021ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  8021f2:	eb 1b                	jmp    80220f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8021f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f7:	8b 48 18             	mov    0x18(%eax),%ecx
  8021fa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021ff:	85 c9                	test   %ecx,%ecx
  802201:	74 0c                	je     80220f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802203:	8b 45 0c             	mov    0xc(%ebp),%eax
  802206:	89 44 24 04          	mov    %eax,0x4(%esp)
  80220a:	89 14 24             	mov    %edx,(%esp)
  80220d:	ff d1                	call   *%ecx
}
  80220f:	83 c4 24             	add    $0x24,%esp
  802212:	5b                   	pop    %ebx
  802213:	5d                   	pop    %ebp
  802214:	c3                   	ret    

00802215 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802215:	55                   	push   %ebp
  802216:	89 e5                	mov    %esp,%ebp
  802218:	53                   	push   %ebx
  802219:	83 ec 24             	sub    $0x24,%esp
  80221c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80221f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802222:	89 44 24 04          	mov    %eax,0x4(%esp)
  802226:	89 1c 24             	mov    %ebx,(%esp)
  802229:	e8 0f fe ff ff       	call   80203d <fd_lookup>
  80222e:	85 c0                	test   %eax,%eax
  802230:	78 66                	js     802298 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802232:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802235:	89 44 24 04          	mov    %eax,0x4(%esp)
  802239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223c:	8b 00                	mov    (%eax),%eax
  80223e:	89 04 24             	mov    %eax,(%esp)
  802241:	e8 6b fe ff ff       	call   8020b1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802246:	85 c0                	test   %eax,%eax
  802248:	78 4e                	js     802298 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80224a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80224d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  802251:	75 23                	jne    802276 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  802253:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  802258:	8b 40 4c             	mov    0x4c(%eax),%eax
  80225b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80225f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802263:	c7 04 24 f5 43 80 00 	movl   $0x8043f5,(%esp)
  80226a:	e8 4e e9 ff ff       	call   800bbd <cprintf>
  80226f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  802274:	eb 22                	jmp    802298 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802276:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802279:	8b 48 0c             	mov    0xc(%eax),%ecx
  80227c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802281:	85 c9                	test   %ecx,%ecx
  802283:	74 13                	je     802298 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802285:	8b 45 10             	mov    0x10(%ebp),%eax
  802288:	89 44 24 08          	mov    %eax,0x8(%esp)
  80228c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80228f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802293:	89 14 24             	mov    %edx,(%esp)
  802296:	ff d1                	call   *%ecx
}
  802298:	83 c4 24             	add    $0x24,%esp
  80229b:	5b                   	pop    %ebx
  80229c:	5d                   	pop    %ebp
  80229d:	c3                   	ret    

0080229e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80229e:	55                   	push   %ebp
  80229f:	89 e5                	mov    %esp,%ebp
  8022a1:	53                   	push   %ebx
  8022a2:	83 ec 24             	sub    $0x24,%esp
  8022a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022a8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8022ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022af:	89 1c 24             	mov    %ebx,(%esp)
  8022b2:	e8 86 fd ff ff       	call   80203d <fd_lookup>
  8022b7:	85 c0                	test   %eax,%eax
  8022b9:	78 6b                	js     802326 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8022bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022c5:	8b 00                	mov    (%eax),%eax
  8022c7:	89 04 24             	mov    %eax,(%esp)
  8022ca:	e8 e2 fd ff ff       	call   8020b1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8022cf:	85 c0                	test   %eax,%eax
  8022d1:	78 53                	js     802326 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8022d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d6:	8b 42 08             	mov    0x8(%edx),%eax
  8022d9:	83 e0 03             	and    $0x3,%eax
  8022dc:	83 f8 01             	cmp    $0x1,%eax
  8022df:	75 23                	jne    802304 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8022e1:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  8022e6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8022e9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f1:	c7 04 24 12 44 80 00 	movl   $0x804412,(%esp)
  8022f8:	e8 c0 e8 ff ff       	call   800bbd <cprintf>
  8022fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  802302:	eb 22                	jmp    802326 <read+0x88>
	}
	if (!dev->dev_read)
  802304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802307:	8b 48 08             	mov    0x8(%eax),%ecx
  80230a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80230f:	85 c9                	test   %ecx,%ecx
  802311:	74 13                	je     802326 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802313:	8b 45 10             	mov    0x10(%ebp),%eax
  802316:	89 44 24 08          	mov    %eax,0x8(%esp)
  80231a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80231d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802321:	89 14 24             	mov    %edx,(%esp)
  802324:	ff d1                	call   *%ecx
}
  802326:	83 c4 24             	add    $0x24,%esp
  802329:	5b                   	pop    %ebx
  80232a:	5d                   	pop    %ebp
  80232b:	c3                   	ret    

0080232c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
  80232f:	57                   	push   %edi
  802330:	56                   	push   %esi
  802331:	53                   	push   %ebx
  802332:	83 ec 1c             	sub    $0x1c,%esp
  802335:	8b 7d 08             	mov    0x8(%ebp),%edi
  802338:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80233b:	ba 00 00 00 00       	mov    $0x0,%edx
  802340:	bb 00 00 00 00       	mov    $0x0,%ebx
  802345:	b8 00 00 00 00       	mov    $0x0,%eax
  80234a:	85 f6                	test   %esi,%esi
  80234c:	74 29                	je     802377 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80234e:	89 f0                	mov    %esi,%eax
  802350:	29 d0                	sub    %edx,%eax
  802352:	89 44 24 08          	mov    %eax,0x8(%esp)
  802356:	03 55 0c             	add    0xc(%ebp),%edx
  802359:	89 54 24 04          	mov    %edx,0x4(%esp)
  80235d:	89 3c 24             	mov    %edi,(%esp)
  802360:	e8 39 ff ff ff       	call   80229e <read>
		if (m < 0)
  802365:	85 c0                	test   %eax,%eax
  802367:	78 0e                	js     802377 <readn+0x4b>
			return m;
		if (m == 0)
  802369:	85 c0                	test   %eax,%eax
  80236b:	74 08                	je     802375 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80236d:	01 c3                	add    %eax,%ebx
  80236f:	89 da                	mov    %ebx,%edx
  802371:	39 f3                	cmp    %esi,%ebx
  802373:	72 d9                	jb     80234e <readn+0x22>
  802375:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  802377:	83 c4 1c             	add    $0x1c,%esp
  80237a:	5b                   	pop    %ebx
  80237b:	5e                   	pop    %esi
  80237c:	5f                   	pop    %edi
  80237d:	5d                   	pop    %ebp
  80237e:	c3                   	ret    

0080237f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
  802382:	56                   	push   %esi
  802383:	53                   	push   %ebx
  802384:	83 ec 20             	sub    $0x20,%esp
  802387:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80238a:	89 34 24             	mov    %esi,(%esp)
  80238d:	e8 0e fc ff ff       	call   801fa0 <fd2num>
  802392:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802395:	89 54 24 04          	mov    %edx,0x4(%esp)
  802399:	89 04 24             	mov    %eax,(%esp)
  80239c:	e8 9c fc ff ff       	call   80203d <fd_lookup>
  8023a1:	89 c3                	mov    %eax,%ebx
  8023a3:	85 c0                	test   %eax,%eax
  8023a5:	78 05                	js     8023ac <fd_close+0x2d>
  8023a7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  8023aa:	74 0c                	je     8023b8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  8023ac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8023b0:	19 c0                	sbb    %eax,%eax
  8023b2:	f7 d0                	not    %eax
  8023b4:	21 c3                	and    %eax,%ebx
  8023b6:	eb 3d                	jmp    8023f5 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8023b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8023bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023bf:	8b 06                	mov    (%esi),%eax
  8023c1:	89 04 24             	mov    %eax,(%esp)
  8023c4:	e8 e8 fc ff ff       	call   8020b1 <dev_lookup>
  8023c9:	89 c3                	mov    %eax,%ebx
  8023cb:	85 c0                	test   %eax,%eax
  8023cd:	78 16                	js     8023e5 <fd_close+0x66>
		if (dev->dev_close)
  8023cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d2:	8b 40 10             	mov    0x10(%eax),%eax
  8023d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023da:	85 c0                	test   %eax,%eax
  8023dc:	74 07                	je     8023e5 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  8023de:	89 34 24             	mov    %esi,(%esp)
  8023e1:	ff d0                	call   *%eax
  8023e3:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8023e5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023f0:	e8 35 f6 ff ff       	call   801a2a <sys_page_unmap>
	return r;
}
  8023f5:	89 d8                	mov    %ebx,%eax
  8023f7:	83 c4 20             	add    $0x20,%esp
  8023fa:	5b                   	pop    %ebx
  8023fb:	5e                   	pop    %esi
  8023fc:	5d                   	pop    %ebp
  8023fd:	c3                   	ret    

008023fe <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
  802401:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802404:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802407:	89 44 24 04          	mov    %eax,0x4(%esp)
  80240b:	8b 45 08             	mov    0x8(%ebp),%eax
  80240e:	89 04 24             	mov    %eax,(%esp)
  802411:	e8 27 fc ff ff       	call   80203d <fd_lookup>
  802416:	85 c0                	test   %eax,%eax
  802418:	78 13                	js     80242d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  80241a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802421:	00 
  802422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802425:	89 04 24             	mov    %eax,(%esp)
  802428:	e8 52 ff ff ff       	call   80237f <fd_close>
}
  80242d:	c9                   	leave  
  80242e:	c3                   	ret    

0080242f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  80242f:	55                   	push   %ebp
  802430:	89 e5                	mov    %esp,%ebp
  802432:	83 ec 18             	sub    $0x18,%esp
  802435:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802438:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80243b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802442:	00 
  802443:	8b 45 08             	mov    0x8(%ebp),%eax
  802446:	89 04 24             	mov    %eax,(%esp)
  802449:	e8 a9 03 00 00       	call   8027f7 <open>
  80244e:	89 c3                	mov    %eax,%ebx
  802450:	85 c0                	test   %eax,%eax
  802452:	78 1b                	js     80246f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  802454:	8b 45 0c             	mov    0xc(%ebp),%eax
  802457:	89 44 24 04          	mov    %eax,0x4(%esp)
  80245b:	89 1c 24             	mov    %ebx,(%esp)
  80245e:	e8 b7 fc ff ff       	call   80211a <fstat>
  802463:	89 c6                	mov    %eax,%esi
	close(fd);
  802465:	89 1c 24             	mov    %ebx,(%esp)
  802468:	e8 91 ff ff ff       	call   8023fe <close>
  80246d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80246f:	89 d8                	mov    %ebx,%eax
  802471:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802474:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802477:	89 ec                	mov    %ebp,%esp
  802479:	5d                   	pop    %ebp
  80247a:	c3                   	ret    

0080247b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80247b:	55                   	push   %ebp
  80247c:	89 e5                	mov    %esp,%ebp
  80247e:	53                   	push   %ebx
  80247f:	83 ec 14             	sub    $0x14,%esp
  802482:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  802487:	89 1c 24             	mov    %ebx,(%esp)
  80248a:	e8 6f ff ff ff       	call   8023fe <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80248f:	83 c3 01             	add    $0x1,%ebx
  802492:	83 fb 20             	cmp    $0x20,%ebx
  802495:	75 f0                	jne    802487 <close_all+0xc>
		close(i);
}
  802497:	83 c4 14             	add    $0x14,%esp
  80249a:	5b                   	pop    %ebx
  80249b:	5d                   	pop    %ebp
  80249c:	c3                   	ret    

0080249d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80249d:	55                   	push   %ebp
  80249e:	89 e5                	mov    %esp,%ebp
  8024a0:	83 ec 58             	sub    $0x58,%esp
  8024a3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8024a6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8024a9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8024ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8024af:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8024b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8024b9:	89 04 24             	mov    %eax,(%esp)
  8024bc:	e8 7c fb ff ff       	call   80203d <fd_lookup>
  8024c1:	89 c3                	mov    %eax,%ebx
  8024c3:	85 c0                	test   %eax,%eax
  8024c5:	0f 88 e0 00 00 00    	js     8025ab <dup+0x10e>
		return r;
	close(newfdnum);
  8024cb:	89 3c 24             	mov    %edi,(%esp)
  8024ce:	e8 2b ff ff ff       	call   8023fe <close>

	newfd = INDEX2FD(newfdnum);
  8024d3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8024d9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8024dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024df:	89 04 24             	mov    %eax,(%esp)
  8024e2:	e8 c9 fa ff ff       	call   801fb0 <fd2data>
  8024e7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8024e9:	89 34 24             	mov    %esi,(%esp)
  8024ec:	e8 bf fa ff ff       	call   801fb0 <fd2data>
  8024f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  8024f4:	89 da                	mov    %ebx,%edx
  8024f6:	89 d8                	mov    %ebx,%eax
  8024f8:	c1 e8 16             	shr    $0x16,%eax
  8024fb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802502:	a8 01                	test   $0x1,%al
  802504:	74 43                	je     802549 <dup+0xac>
  802506:	c1 ea 0c             	shr    $0xc,%edx
  802509:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802510:	a8 01                	test   $0x1,%al
  802512:	74 35                	je     802549 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  802514:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80251b:	25 07 0e 00 00       	and    $0xe07,%eax
  802520:	89 44 24 10          	mov    %eax,0x10(%esp)
  802524:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802527:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80252b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802532:	00 
  802533:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802537:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80253e:	e8 45 f5 ff ff       	call   801a88 <sys_page_map>
  802543:	89 c3                	mov    %eax,%ebx
  802545:	85 c0                	test   %eax,%eax
  802547:	78 3f                	js     802588 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  802549:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80254c:	89 c2                	mov    %eax,%edx
  80254e:	c1 ea 0c             	shr    $0xc,%edx
  802551:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802558:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80255e:	89 54 24 10          	mov    %edx,0x10(%esp)
  802562:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802566:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80256d:	00 
  80256e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802572:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802579:	e8 0a f5 ff ff       	call   801a88 <sys_page_map>
  80257e:	89 c3                	mov    %eax,%ebx
  802580:	85 c0                	test   %eax,%eax
  802582:	78 04                	js     802588 <dup+0xeb>
  802584:	89 fb                	mov    %edi,%ebx
  802586:	eb 23                	jmp    8025ab <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  802588:	89 74 24 04          	mov    %esi,0x4(%esp)
  80258c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802593:	e8 92 f4 ff ff       	call   801a2a <sys_page_unmap>
	sys_page_unmap(0, nva);
  802598:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80259b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80259f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025a6:	e8 7f f4 ff ff       	call   801a2a <sys_page_unmap>
	return r;
}
  8025ab:	89 d8                	mov    %ebx,%eax
  8025ad:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8025b0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8025b3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8025b6:	89 ec                	mov    %ebp,%esp
  8025b8:	5d                   	pop    %ebp
  8025b9:	c3                   	ret    
	...

008025bc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8025bc:	55                   	push   %ebp
  8025bd:	89 e5                	mov    %esp,%ebp
  8025bf:	53                   	push   %ebx
  8025c0:	83 ec 14             	sub    $0x14,%esp
  8025c3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8025c5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  8025cb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8025d2:	00 
  8025d3:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8025da:	00 
  8025db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025df:	89 14 24             	mov    %edx,(%esp)
  8025e2:	e8 09 14 00 00       	call   8039f0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8025e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8025ee:	00 
  8025ef:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025fa:	e8 53 14 00 00       	call   803a52 <ipc_recv>
}
  8025ff:	83 c4 14             	add    $0x14,%esp
  802602:	5b                   	pop    %ebx
  802603:	5d                   	pop    %ebp
  802604:	c3                   	ret    

00802605 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
  802608:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	8b 40 0c             	mov    0xc(%eax),%eax
  802611:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  802616:	8b 45 0c             	mov    0xc(%ebp),%eax
  802619:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80261e:	ba 00 00 00 00       	mov    $0x0,%edx
  802623:	b8 02 00 00 00       	mov    $0x2,%eax
  802628:	e8 8f ff ff ff       	call   8025bc <fsipc>
}
  80262d:	c9                   	leave  
  80262e:	c3                   	ret    

0080262f <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  80262f:	55                   	push   %ebp
  802630:	89 e5                	mov    %esp,%ebp
  802632:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802635:	ba 00 00 00 00       	mov    $0x0,%edx
  80263a:	b8 08 00 00 00       	mov    $0x8,%eax
  80263f:	e8 78 ff ff ff       	call   8025bc <fsipc>
}
  802644:	c9                   	leave  
  802645:	c3                   	ret    

00802646 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802646:	55                   	push   %ebp
  802647:	89 e5                	mov    %esp,%ebp
  802649:	53                   	push   %ebx
  80264a:	83 ec 14             	sub    $0x14,%esp
  80264d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802650:	8b 45 08             	mov    0x8(%ebp),%eax
  802653:	8b 40 0c             	mov    0xc(%eax),%eax
  802656:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80265b:	ba 00 00 00 00       	mov    $0x0,%edx
  802660:	b8 05 00 00 00       	mov    $0x5,%eax
  802665:	e8 52 ff ff ff       	call   8025bc <fsipc>
  80266a:	85 c0                	test   %eax,%eax
  80266c:	78 2b                	js     802699 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80266e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  802675:	00 
  802676:	89 1c 24             	mov    %ebx,(%esp)
  802679:	e8 0c ed ff ff       	call   80138a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80267e:	a1 80 50 80 00       	mov    0x805080,%eax
  802683:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  802689:	a1 84 50 80 00       	mov    0x805084,%eax
  80268e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  802694:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  802699:	83 c4 14             	add    $0x14,%esp
  80269c:	5b                   	pop    %ebx
  80269d:	5d                   	pop    %ebp
  80269e:	c3                   	ret    

0080269f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80269f:	55                   	push   %ebp
  8026a0:	89 e5                	mov    %esp,%ebp
  8026a2:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  8026a5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8026ac:	00 
  8026ad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8026b4:	00 
  8026b5:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8026bc:	e8 25 ee ff ff       	call   8014e6 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8026c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8026c7:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8026cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8026d1:	b8 06 00 00 00       	mov    $0x6,%eax
  8026d6:	e8 e1 fe ff ff       	call   8025bc <fsipc>
}
  8026db:	c9                   	leave  
  8026dc:	c3                   	ret    

008026dd <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8026dd:	55                   	push   %ebp
  8026de:	89 e5                	mov    %esp,%ebp
  8026e0:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  8026e3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8026ea:	00 
  8026eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8026f2:	00 
  8026f3:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8026fa:	e8 e7 ed ff ff       	call   8014e6 <memset>
  8026ff:	8b 45 10             	mov    0x10(%ebp),%eax
  802702:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  802707:	76 05                	jbe    80270e <devfile_write+0x31>
  802709:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80270e:	8b 55 08             	mov    0x8(%ebp),%edx
  802711:	8b 52 0c             	mov    0xc(%edx),%edx
  802714:	89 15 00 50 80 00    	mov    %edx,0x805000
        fsipcbuf.write.req_n = numberOfBytes;
  80271a:	a3 04 50 80 00       	mov    %eax,0x805004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  80271f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802723:	8b 45 0c             	mov    0xc(%ebp),%eax
  802726:	89 44 24 04          	mov    %eax,0x4(%esp)
  80272a:	c7 04 24 08 50 80 00 	movl   $0x805008,(%esp)
  802731:	e8 0f ee ff ff       	call   801545 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  802736:	ba 00 00 00 00       	mov    $0x0,%edx
  80273b:	b8 04 00 00 00       	mov    $0x4,%eax
  802740:	e8 77 fe ff ff       	call   8025bc <fsipc>
              return r;
        return r;
}
  802745:	c9                   	leave  
  802746:	c3                   	ret    

00802747 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802747:	55                   	push   %ebp
  802748:	89 e5                	mov    %esp,%ebp
  80274a:	53                   	push   %ebx
  80274b:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  80274e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802755:	00 
  802756:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80275d:	00 
  80275e:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  802765:	e8 7c ed ff ff       	call   8014e6 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  80276a:	8b 45 08             	mov    0x8(%ebp),%eax
  80276d:	8b 40 0c             	mov    0xc(%eax),%eax
  802770:	a3 00 50 80 00       	mov    %eax,0x805000
        fsipcbuf.read.req_n = n;
  802775:	8b 45 10             	mov    0x10(%ebp),%eax
  802778:	a3 04 50 80 00       	mov    %eax,0x805004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  80277d:	ba 00 00 00 00       	mov    $0x0,%edx
  802782:	b8 03 00 00 00       	mov    $0x3,%eax
  802787:	e8 30 fe ff ff       	call   8025bc <fsipc>
  80278c:	89 c3                	mov    %eax,%ebx
  80278e:	85 c0                	test   %eax,%eax
  802790:	78 17                	js     8027a9 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  802792:	89 44 24 08          	mov    %eax,0x8(%esp)
  802796:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80279d:	00 
  80279e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027a1:	89 04 24             	mov    %eax,(%esp)
  8027a4:	e8 9c ed ff ff       	call   801545 <memmove>
        return r;
}
  8027a9:	89 d8                	mov    %ebx,%eax
  8027ab:	83 c4 14             	add    $0x14,%esp
  8027ae:	5b                   	pop    %ebx
  8027af:	5d                   	pop    %ebp
  8027b0:	c3                   	ret    

008027b1 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  8027b1:	55                   	push   %ebp
  8027b2:	89 e5                	mov    %esp,%ebp
  8027b4:	53                   	push   %ebx
  8027b5:	83 ec 14             	sub    $0x14,%esp
  8027b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  8027bb:	89 1c 24             	mov    %ebx,(%esp)
  8027be:	e8 7d eb ff ff       	call   801340 <strlen>
  8027c3:	89 c2                	mov    %eax,%edx
  8027c5:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8027ca:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  8027d0:	7f 1f                	jg     8027f1 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  8027d2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027d6:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  8027dd:	e8 a8 eb ff ff       	call   80138a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  8027e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8027e7:	b8 07 00 00 00       	mov    $0x7,%eax
  8027ec:	e8 cb fd ff ff       	call   8025bc <fsipc>
}
  8027f1:	83 c4 14             	add    $0x14,%esp
  8027f4:	5b                   	pop    %ebx
  8027f5:	5d                   	pop    %ebp
  8027f6:	c3                   	ret    

008027f7 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  8027f7:	55                   	push   %ebp
  8027f8:	89 e5                	mov    %esp,%ebp
  8027fa:	56                   	push   %esi
  8027fb:	53                   	push   %ebx
  8027fc:	83 ec 20             	sub    $0x20,%esp
  8027ff:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  802802:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802809:	00 
  80280a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802811:	00 
  802812:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  802819:	e8 c8 ec ff ff       	call   8014e6 <memset>
    if(strlen(path)>=MAXPATHLEN)
  80281e:	89 34 24             	mov    %esi,(%esp)
  802821:	e8 1a eb ff ff       	call   801340 <strlen>
  802826:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80282b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802830:	0f 8f 84 00 00 00    	jg     8028ba <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  802836:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802839:	89 04 24             	mov    %eax,(%esp)
  80283c:	e8 8a f7 ff ff       	call   801fcb <fd_alloc>
  802841:	89 c3                	mov    %eax,%ebx
  802843:	85 c0                	test   %eax,%eax
  802845:	78 73                	js     8028ba <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  802847:	0f b6 06             	movzbl (%esi),%eax
  80284a:	84 c0                	test   %al,%al
  80284c:	74 20                	je     80286e <open+0x77>
  80284e:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  802850:	0f be c0             	movsbl %al,%eax
  802853:	89 44 24 04          	mov    %eax,0x4(%esp)
  802857:	c7 04 24 44 44 80 00 	movl   $0x804444,(%esp)
  80285e:	e8 5a e3 ff ff       	call   800bbd <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  802863:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  802867:	83 c3 01             	add    $0x1,%ebx
  80286a:	84 c0                	test   %al,%al
  80286c:	75 e2                	jne    802850 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  80286e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802872:	c7 04 24 00 50 80 00 	movl   $0x805000,(%esp)
  802879:	e8 0c eb ff ff       	call   80138a <strcpy>
    fsipcbuf.open.req_omode = mode;
  80287e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802881:	a3 00 54 80 00       	mov    %eax,0x805400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  802886:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802889:	b8 01 00 00 00       	mov    $0x1,%eax
  80288e:	e8 29 fd ff ff       	call   8025bc <fsipc>
  802893:	89 c3                	mov    %eax,%ebx
  802895:	85 c0                	test   %eax,%eax
  802897:	79 15                	jns    8028ae <open+0xb7>
        {
            fd_close(fd,1);
  802899:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8028a0:	00 
  8028a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a4:	89 04 24             	mov    %eax,(%esp)
  8028a7:	e8 d3 fa ff ff       	call   80237f <fd_close>
             return r;
  8028ac:	eb 0c                	jmp    8028ba <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  8028ae:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8028b1:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  8028b7:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  8028ba:	89 d8                	mov    %ebx,%eax
  8028bc:	83 c4 20             	add    $0x20,%esp
  8028bf:	5b                   	pop    %ebx
  8028c0:	5e                   	pop    %esi
  8028c1:	5d                   	pop    %ebp
  8028c2:	c3                   	ret    
	...

008028c4 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  8028c4:	55                   	push   %ebp
  8028c5:	89 e5                	mov    %esp,%ebp
  8028c7:	53                   	push   %ebx
  8028c8:	83 ec 14             	sub    $0x14,%esp
  8028cb:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  8028cd:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8028d1:	7e 34                	jle    802907 <writebuf+0x43>
		ssize_t result = write(b->fd, b->buf, b->idx);
  8028d3:	8b 40 04             	mov    0x4(%eax),%eax
  8028d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028da:	8d 43 10             	lea    0x10(%ebx),%eax
  8028dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028e1:	8b 03                	mov    (%ebx),%eax
  8028e3:	89 04 24             	mov    %eax,(%esp)
  8028e6:	e8 2a f9 ff ff       	call   802215 <write>
		if (result > 0)
  8028eb:	85 c0                	test   %eax,%eax
  8028ed:	7e 03                	jle    8028f2 <writebuf+0x2e>
			b->result += result;
  8028ef:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8028f2:	3b 43 04             	cmp    0x4(%ebx),%eax
  8028f5:	74 10                	je     802907 <writebuf+0x43>
			b->error = (result < 0 ? result : 0);
  8028f7:	85 c0                	test   %eax,%eax
  8028f9:	0f 9f c2             	setg   %dl
  8028fc:	0f b6 d2             	movzbl %dl,%edx
  8028ff:	83 ea 01             	sub    $0x1,%edx
  802902:	21 d0                	and    %edx,%eax
  802904:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  802907:	83 c4 14             	add    $0x14,%esp
  80290a:	5b                   	pop    %ebx
  80290b:	5d                   	pop    %ebp
  80290c:	c3                   	ret    

0080290d <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  80290d:	55                   	push   %ebp
  80290e:	89 e5                	mov    %esp,%ebp
  802910:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  802916:	8b 45 08             	mov    0x8(%ebp),%eax
  802919:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  80291f:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  802926:	00 00 00 
	b.result = 0;
  802929:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802930:	00 00 00 
	b.error = 1;
  802933:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  80293a:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  80293d:	8b 45 10             	mov    0x10(%ebp),%eax
  802940:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802944:	8b 45 0c             	mov    0xc(%ebp),%eax
  802947:	89 44 24 08          	mov    %eax,0x8(%esp)
  80294b:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802951:	89 44 24 04          	mov    %eax,0x4(%esp)
  802955:	c7 04 24 ca 29 80 00 	movl   $0x8029ca,(%esp)
  80295c:	e8 0c e4 ff ff       	call   800d6d <vprintfmt>
	if (b.idx > 0)
  802961:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  802968:	7e 0b                	jle    802975 <vfprintf+0x68>
		writebuf(&b);
  80296a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  802970:	e8 4f ff ff ff       	call   8028c4 <writebuf>

	return (b.result ? b.result : b.error);
  802975:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80297b:	85 c0                	test   %eax,%eax
  80297d:	75 06                	jne    802985 <vfprintf+0x78>
  80297f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  802985:	c9                   	leave  
  802986:	c3                   	ret    

00802987 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  802987:	55                   	push   %ebp
  802988:	89 e5                	mov    %esp,%ebp
  80298a:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  80298d:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  802990:	89 44 24 08          	mov    %eax,0x8(%esp)
  802994:	8b 45 08             	mov    0x8(%ebp),%eax
  802997:	89 44 24 04          	mov    %eax,0x4(%esp)
  80299b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8029a2:	e8 66 ff ff ff       	call   80290d <vfprintf>
	va_end(ap);

	return cnt;
}
  8029a7:	c9                   	leave  
  8029a8:	c3                   	ret    

008029a9 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  8029a9:	55                   	push   %ebp
  8029aa:	89 e5                	mov    %esp,%ebp
  8029ac:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  8029af:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  8029b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c0:	89 04 24             	mov    %eax,(%esp)
  8029c3:	e8 45 ff ff ff       	call   80290d <vfprintf>
	va_end(ap);

	return cnt;
}
  8029c8:	c9                   	leave  
  8029c9:	c3                   	ret    

008029ca <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  8029ca:	55                   	push   %ebp
  8029cb:	89 e5                	mov    %esp,%ebp
  8029cd:	53                   	push   %ebx
  8029ce:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  8029d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8029d4:	8b 43 04             	mov    0x4(%ebx),%eax
  8029d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029da:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  8029de:	83 c0 01             	add    $0x1,%eax
  8029e1:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  8029e4:	3d 00 01 00 00       	cmp    $0x100,%eax
  8029e9:	75 0e                	jne    8029f9 <putch+0x2f>
		writebuf(b);
  8029eb:	89 d8                	mov    %ebx,%eax
  8029ed:	e8 d2 fe ff ff       	call   8028c4 <writebuf>
		b->idx = 0;
  8029f2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  8029f9:	83 c4 04             	add    $0x4,%esp
  8029fc:	5b                   	pop    %ebx
  8029fd:	5d                   	pop    %ebp
  8029fe:	c3                   	ret    
	...

00802a00 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802a00:	55                   	push   %ebp
  802a01:	89 e5                	mov    %esp,%ebp
  802a03:	57                   	push   %edi
  802a04:	56                   	push   %esi
  802a05:	53                   	push   %ebx
  802a06:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802a0c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802a13:	00 
  802a14:	8b 45 08             	mov    0x8(%ebp),%eax
  802a17:	89 04 24             	mov    %eax,(%esp)
  802a1a:	e8 d8 fd ff ff       	call   8027f7 <open>
  802a1f:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  802a25:	89 c3                	mov    %eax,%ebx
  802a27:	85 c0                	test   %eax,%eax
  802a29:	0f 88 d1 05 00 00    	js     803000 <spawn+0x600>
	fd = r;
    // cprintf("fd--->%d",fd);
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
	    || elf->e_magic != ELF_MAGIC) {
  802a2f:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  802a36:	00 
  802a37:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802a3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a41:	89 1c 24             	mov    %ebx,(%esp)
  802a44:	e8 55 f8 ff ff       	call   80229e <read>
		return r;
	fd = r;
    // cprintf("fd--->%d",fd);
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  802a49:	3d 00 02 00 00       	cmp    $0x200,%eax
  802a4e:	75 0c                	jne    802a5c <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  802a50:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802a57:	45 4c 46 
  802a5a:	74 36                	je     802a92 <spawn+0x92>
		close(fd);
  802a5c:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802a62:	89 04 24             	mov    %eax,(%esp)
  802a65:	e8 94 f9 ff ff       	call   8023fe <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802a6a:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802a71:	46 
  802a72:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  802a78:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a7c:	c7 04 24 47 44 80 00 	movl   $0x804447,(%esp)
  802a83:	e8 35 e1 ff ff       	call   800bbd <cprintf>
  802a88:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
		return -E_NOT_EXEC;
  802a8d:	e9 6e 05 00 00       	jmp    803000 <spawn+0x600>
  802a92:	ba 07 00 00 00       	mov    $0x7,%edx
  802a97:	89 d0                	mov    %edx,%eax
  802a99:	cd 30                	int    $0x30
  802a9b:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
	}
     
       // Create new child environment
	if ((r = sys_exofork()) < 0)
  802aa1:	85 c0                	test   %eax,%eax
  802aa3:	0f 88 51 05 00 00    	js     802ffa <spawn+0x5fa>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  802aa9:	89 c6                	mov    %eax,%esi
  802aab:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  802ab1:	6b f6 7c             	imul   $0x7c,%esi,%esi
  802ab4:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  802aba:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  802ac0:	b9 11 00 00 00       	mov    $0x11,%ecx
  802ac5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	cprintf("\nelf->entry %x\n",elf->e_entry);
  802ac7:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802acd:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ad1:	c7 04 24 61 44 80 00 	movl   $0x804461,(%esp)
  802ad8:	e8 e0 e0 ff ff       	call   800bbd <cprintf>
        child_tf.tf_eip = elf->e_entry;
  802add:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  802ae3:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802ae9:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aec:	8b 02                	mov    (%edx),%eax
  802aee:	bb 00 00 00 00       	mov    $0x0,%ebx
  802af3:	be 00 00 00 00       	mov    $0x0,%esi
  802af8:	85 c0                	test   %eax,%eax
  802afa:	75 16                	jne    802b12 <spawn+0x112>
  802afc:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  802b03:	00 00 00 
  802b06:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  802b0d:	00 00 00 
  802b10:	eb 2c                	jmp    802b3e <spawn+0x13e>
  802b12:	8b 7d 0c             	mov    0xc(%ebp),%edi
		string_size += strlen(argv[argc]) + 1;
  802b15:	89 04 24             	mov    %eax,(%esp)
  802b18:	e8 23 e8 ff ff       	call   801340 <strlen>
  802b1d:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802b21:	83 c6 01             	add    $0x1,%esi
  802b24:	8d 14 b5 00 00 00 00 	lea    0x0(,%esi,4),%edx
  802b2b:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  802b2e:	85 c0                	test   %eax,%eax
  802b30:	75 e3                	jne    802b15 <spawn+0x115>
  802b32:	89 95 7c fd ff ff    	mov    %edx,-0x284(%ebp)
  802b38:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802b3e:	f7 db                	neg    %ebx
  802b40:	8d bb 00 10 40 00    	lea    0x401000(%ebx),%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802b46:	89 fa                	mov    %edi,%edx
  802b48:	83 e2 fc             	and    $0xfffffffc,%edx
  802b4b:	89 f0                	mov    %esi,%eax
  802b4d:	f7 d0                	not    %eax
  802b4f:	8d 04 82             	lea    (%edx,%eax,4),%eax
  802b52:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802b58:	83 e8 08             	sub    $0x8,%eax
  802b5b:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  802b61:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802b66:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  802b6b:	0f 86 8f 04 00 00    	jbe    803000 <spawn+0x600>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802b71:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802b78:	00 
  802b79:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802b80:	00 
  802b81:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b88:	e8 59 ef ff ff       	call   801ae6 <sys_page_alloc>
  802b8d:	89 c3                	mov    %eax,%ebx
  802b8f:	85 c0                	test   %eax,%eax
  802b91:	0f 88 69 04 00 00    	js     803000 <spawn+0x600>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802b97:	85 f6                	test   %esi,%esi
  802b99:	7e 46                	jle    802be1 <spawn+0x1e1>
  802b9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ba0:	89 b5 8c fd ff ff    	mov    %esi,-0x274(%ebp)
  802ba6:	8b 75 0c             	mov    0xc(%ebp),%esi
		argv_store[i] = UTEMP2USTACK(string_store);
  802ba9:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802baf:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802bb5:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
		strcpy(string_store, argv[i]);
  802bb8:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  802bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bbf:	89 3c 24             	mov    %edi,(%esp)
  802bc2:	e8 c3 e7 ff ff       	call   80138a <strcpy>
		string_store += strlen(argv[i]) + 1;
  802bc7:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  802bca:	89 04 24             	mov    %eax,(%esp)
  802bcd:	e8 6e e7 ff ff       	call   801340 <strlen>
  802bd2:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  802bd6:	83 c3 01             	add    $0x1,%ebx
  802bd9:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  802bdf:	7c c8                	jl     802ba9 <spawn+0x1a9>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  802be1:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802be7:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802bed:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  802bf4:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  802bfa:	74 24                	je     802c20 <spawn+0x220>
  802bfc:	c7 44 24 0c b4 44 80 	movl   $0x8044b4,0xc(%esp)
  802c03:	00 
  802c04:	c7 44 24 08 38 3f 80 	movl   $0x803f38,0x8(%esp)
  802c0b:	00 
  802c0c:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  802c13:	00 
  802c14:	c7 04 24 71 44 80 00 	movl   $0x804471,(%esp)
  802c1b:	e8 d8 de ff ff       	call   800af8 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802c20:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802c26:	2d 00 30 80 11       	sub    $0x11803000,%eax
  802c2b:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802c31:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  802c34:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  802c3a:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802c40:	89 10                	mov    %edx,(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802c42:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802c48:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802c4d:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802c53:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  802c5a:	00 
  802c5b:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802c62:	ee 
  802c63:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802c69:	89 44 24 08          	mov    %eax,0x8(%esp)
  802c6d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802c74:	00 
  802c75:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c7c:	e8 07 ee ff ff       	call   801a88 <sys_page_map>
  802c81:	89 c3                	mov    %eax,%ebx
  802c83:	85 c0                	test   %eax,%eax
  802c85:	78 1a                	js     802ca1 <spawn+0x2a1>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  802c87:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802c8e:	00 
  802c8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c96:	e8 8f ed ff ff       	call   801a2a <sys_page_unmap>
  802c9b:	89 c3                	mov    %eax,%ebx
  802c9d:	85 c0                	test   %eax,%eax
  802c9f:	79 19                	jns    802cba <spawn+0x2ba>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802ca1:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802ca8:	00 
  802ca9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802cb0:	e8 75 ed ff ff       	call   801a2a <sys_page_unmap>
  802cb5:	e9 46 03 00 00       	jmp    803000 <spawn+0x600>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802cba:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802cc0:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  802cc7:	00 
  802cc8:	0f 84 e3 01 00 00    	je     802eb1 <spawn+0x4b1>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802cce:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  802cd5:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
  802cdb:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  802ce2:	00 00 00 
	for (i = 0; i < elf->e_phnum; i++, ph++) {
               // cprintf("\nHello\n");
		if (ph->p_type != ELF_PROG_LOAD)
  802ce5:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  802ceb:	83 3a 01             	cmpl   $0x1,(%edx)
  802cee:	0f 85 9b 01 00 00    	jne    802e8f <spawn+0x48f>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802cf4:	8b 42 18             	mov    0x18(%edx),%eax
  802cf7:	83 e0 02             	and    $0x2,%eax
  802cfa:	83 f8 01             	cmp    $0x1,%eax
  802cfd:	19 c0                	sbb    %eax,%eax
  802cff:	83 e0 fe             	and    $0xfffffffe,%eax
  802d02:	83 c0 07             	add    $0x7,%eax
  802d05:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
  802d0b:	8b 52 04             	mov    0x4(%edx),%edx
  802d0e:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  802d14:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802d1a:	8b 58 10             	mov    0x10(%eax),%ebx
  802d1d:	8b 50 14             	mov    0x14(%eax),%edx
  802d20:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
  802d26:	8b 40 08             	mov    0x8(%eax),%eax
  802d29:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802d2f:	25 ff 0f 00 00       	and    $0xfff,%eax
  802d34:	74 16                	je     802d4c <spawn+0x34c>
		va -= i;
  802d36:	29 85 90 fd ff ff    	sub    %eax,-0x270(%ebp)
		memsz += i;
  802d3c:	01 c2                	add    %eax,%edx
  802d3e:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
		filesz += i;
  802d44:	01 c3                	add    %eax,%ebx
		fileoffset -= i;
  802d46:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802d4c:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  802d53:	0f 84 36 01 00 00    	je     802e8f <spawn+0x48f>
  802d59:	bf 00 00 00 00       	mov    $0x0,%edi
  802d5e:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  802d63:	39 fb                	cmp    %edi,%ebx
  802d65:	77 31                	ja     802d98 <spawn+0x398>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802d67:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802d6d:	89 54 24 08          	mov    %edx,0x8(%esp)
  802d71:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  802d77:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802d7b:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802d81:	89 04 24             	mov    %eax,(%esp)
  802d84:	e8 5d ed ff ff       	call   801ae6 <sys_page_alloc>
  802d89:	85 c0                	test   %eax,%eax
  802d8b:	0f 89 ea 00 00 00    	jns    802e7b <spawn+0x47b>
  802d91:	89 c3                	mov    %eax,%ebx
  802d93:	e9 44 02 00 00       	jmp    802fdc <spawn+0x5dc>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802d98:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802d9f:	00 
  802da0:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802da7:	00 
  802da8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802daf:	e8 32 ed ff ff       	call   801ae6 <sys_page_alloc>
  802db4:	85 c0                	test   %eax,%eax
  802db6:	0f 88 16 02 00 00    	js     802fd2 <spawn+0x5d2>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802dbc:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  802dc2:	8d 04 16             	lea    (%esi,%edx,1),%eax
  802dc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dc9:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802dcf:	89 04 24             	mov    %eax,(%esp)
  802dd2:	e8 ae f2 ff ff       	call   802085 <seek>
  802dd7:	85 c0                	test   %eax,%eax
  802dd9:	0f 88 f7 01 00 00    	js     802fd6 <spawn+0x5d6>
				return r;
			if ((r = read(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802ddf:	89 d8                	mov    %ebx,%eax
  802de1:	29 f8                	sub    %edi,%eax
  802de3:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802de8:	76 05                	jbe    802def <spawn+0x3ef>
  802dea:	b8 00 10 00 00       	mov    $0x1000,%eax
  802def:	89 44 24 08          	mov    %eax,0x8(%esp)
  802df3:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802dfa:	00 
  802dfb:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  802e01:	89 14 24             	mov    %edx,(%esp)
  802e04:	e8 95 f4 ff ff       	call   80229e <read>
  802e09:	85 c0                	test   %eax,%eax
  802e0b:	0f 88 c9 01 00 00    	js     802fda <spawn+0x5da>
				return r;
			//cprintf("\nvirtual address----->%x\n",va+i);
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802e11:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802e17:	89 44 24 10          	mov    %eax,0x10(%esp)
  802e1b:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  802e21:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802e25:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  802e2b:	89 54 24 08          	mov    %edx,0x8(%esp)
  802e2f:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802e36:	00 
  802e37:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e3e:	e8 45 ec ff ff       	call   801a88 <sys_page_map>
  802e43:	85 c0                	test   %eax,%eax
  802e45:	79 20                	jns    802e67 <spawn+0x467>
				panic("spawn: sys_page_map data: %e", r);
  802e47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802e4b:	c7 44 24 08 7d 44 80 	movl   $0x80447d,0x8(%esp)
  802e52:	00 
  802e53:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  802e5a:	00 
  802e5b:	c7 04 24 71 44 80 00 	movl   $0x804471,(%esp)
  802e62:	e8 91 dc ff ff       	call   800af8 <_panic>
			sys_page_unmap(0, UTEMP);
  802e67:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802e6e:	00 
  802e6f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e76:	e8 af eb ff ff       	call   801a2a <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802e7b:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802e81:	89 f7                	mov    %esi,%edi
  802e83:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  802e89:	0f 87 d4 fe ff ff    	ja     802d63 <spawn+0x363>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802e8f:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  802e96:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802e9d:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  802ea3:	7e 0c                	jle    802eb1 <spawn+0x4b1>
  802ea5:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  802eac:	e9 34 fe ff ff       	jmp    802ce5 <spawn+0x2e5>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802eb1:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802eb7:	89 04 24             	mov    %eax,(%esp)
  802eba:	e8 3f f5 ff ff       	call   8023fe <close>
  802ebf:	bb 00 00 80 00       	mov    $0x800000,%ebx
duplicateSharepage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
        pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  802ec4:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
       
        if( 0 == pgDirEntry )
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  802ec9:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	// LAB 7: Your code here.
	uint8_t *addr;
	extern unsigned char end[];
	for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
                {    
			duplicateSharepage(child, VPN(addr));
  802ece:	89 d8                	mov    %ebx,%eax
  802ed0:	c1 e8 0c             	shr    $0xc,%eax
duplicateSharepage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
        pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  802ed3:	89 c2                	mov    %eax,%edx
  802ed5:	c1 e2 0c             	shl    $0xc,%edx
  802ed8:	89 d1                	mov    %edx,%ecx
  802eda:	c1 e9 16             	shr    $0x16,%ecx
  802edd:	8b 0c 8e             	mov    (%esi,%ecx,4),%ecx
       
        if( 0 == pgDirEntry )
  802ee0:	85 c9                	test   %ecx,%ecx
  802ee2:	74 66                	je     802f4a <spawn+0x54a>
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  802ee4:	8b 04 87             	mov    (%edi,%eax,4),%eax
  802ee7:	89 c1                	mov    %eax,%ecx
  802ee9:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
        //cprintf("Below %d",vpt[pn]);
                //if(perm!=0)  //commented nw.
                   // cprintf("perm bit %d",perm);
	//cprintf("\nInside Spawn setting share\n");
	if((perm & PTE_W) && (perm & PTE_SHARE))
  802eef:	25 02 04 00 00       	and    $0x402,%eax
  802ef4:	3d 02 04 00 00       	cmp    $0x402,%eax
  802ef9:	75 4f                	jne    802f4a <spawn+0x54a>
	{
		if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_SHARE|(perm & PTE_USER))) < 0)
  802efb:	81 e1 07 0a 00 00    	and    $0xa07,%ecx
  802f01:	80 cd 04             	or     $0x4,%ch
  802f04:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  802f08:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802f0c:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802f12:	89 44 24 08          	mov    %eax,0x8(%esp)
  802f16:	89 54 24 04          	mov    %edx,0x4(%esp)
  802f1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802f21:	e8 62 eb ff ff       	call   801a88 <sys_page_map>
  802f26:	85 c0                	test   %eax,%eax
  802f28:	79 20                	jns    802f4a <spawn+0x54a>
                panic("sys_page_map: %e", r);
  802f2a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f2e:	c7 44 24 08 1b 43 80 	movl   $0x80431b,0x8(%esp)
  802f35:	00 
  802f36:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  802f3d:	00 
  802f3e:	c7 04 24 71 44 80 00 	movl   $0x804471,(%esp)
  802f45:	e8 ae db ff ff       	call   800af8 <_panic>
copy_shared_pages(envid_t child)
{
	// LAB 7: Your code here.
	uint8_t *addr;
	extern unsigned char end[];
	for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
  802f4a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802f50:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  802f56:	0f 85 72 ff ff ff    	jne    802ece <spawn+0x4ce>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802f5c:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802f62:	89 44 24 04          	mov    %eax,0x4(%esp)
  802f66:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  802f6c:	89 14 24             	mov    %edx,(%esp)
  802f6f:	e8 fa e9 ff ff       	call   80196e <sys_env_set_trapframe>
  802f74:	85 c0                	test   %eax,%eax
  802f76:	79 20                	jns    802f98 <spawn+0x598>
		panic("sys_env_set_trapframe: %e", r);
  802f78:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802f7c:	c7 44 24 08 9a 44 80 	movl   $0x80449a,0x8(%esp)
  802f83:	00 
  802f84:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  802f8b:	00 
  802f8c:	c7 04 24 71 44 80 00 	movl   $0x804471,(%esp)
  802f93:	e8 60 db ff ff       	call   800af8 <_panic>
                   //    cprintf("\nHello below trpaframe%d\n",elf->e_phnum);
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802f98:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802f9f:	00 
  802fa0:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802fa6:	89 04 24             	mov    %eax,(%esp)
  802fa9:	e8 1e ea ff ff       	call   8019cc <sys_env_set_status>
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	79 48                	jns    802ffa <spawn+0x5fa>
		panic("sys_env_set_status: %e", r);
  802fb2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802fb6:	c7 44 24 08 4f 43 80 	movl   $0x80434f,0x8(%esp)
  802fbd:	00 
  802fbe:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  802fc5:	00 
  802fc6:	c7 04 24 71 44 80 00 	movl   $0x804471,(%esp)
  802fcd:	e8 26 db ff ff       	call   800af8 <_panic>
  802fd2:	89 c3                	mov    %eax,%ebx
  802fd4:	eb 06                	jmp    802fdc <spawn+0x5dc>
  802fd6:	89 c3                	mov    %eax,%ebx
  802fd8:	eb 02                	jmp    802fdc <spawn+0x5dc>
  802fda:	89 c3                	mov    %eax,%ebx

	return child;

error:
	sys_env_destroy(child);
  802fdc:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  802fe2:	89 14 24             	mov    %edx,(%esp)
  802fe5:	e8 c3 eb ff ff       	call   801bad <sys_env_destroy>
	close(fd);
  802fea:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802ff0:	89 04 24             	mov    %eax,(%esp)
  802ff3:	e8 06 f4 ff ff       	call   8023fe <close>
	return r;
  802ff8:	eb 06                	jmp    803000 <spawn+0x600>
  802ffa:	8b 9d 88 fd ff ff    	mov    -0x278(%ebp),%ebx
}
  803000:	89 d8                	mov    %ebx,%eax
  803002:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  803008:	5b                   	pop    %ebx
  803009:	5e                   	pop    %esi
  80300a:	5f                   	pop    %edi
  80300b:	5d                   	pop    %ebp
  80300c:	c3                   	ret    

0080300d <spawnl>:

// Spawn, taking command-line arguments array directly on the stack.
int
spawnl(const char *prog, const char *arg0, ...)
{
  80300d:	55                   	push   %ebp
  80300e:	89 e5                	mov    %esp,%ebp
  803010:	83 ec 18             	sub    $0x18,%esp
	return spawn(prog, &arg0);
  803013:	8d 45 0c             	lea    0xc(%ebp),%eax
  803016:	89 44 24 04          	mov    %eax,0x4(%esp)
  80301a:	8b 45 08             	mov    0x8(%ebp),%eax
  80301d:	89 04 24             	mov    %eax,(%esp)
  803020:	e8 db f9 ff ff       	call   802a00 <spawn>
}
  803025:	c9                   	leave  
  803026:	c3                   	ret    
	...

00803030 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  803030:	55                   	push   %ebp
  803031:	89 e5                	mov    %esp,%ebp
  803033:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  803036:	c7 44 24 04 dc 44 80 	movl   $0x8044dc,0x4(%esp)
  80303d:	00 
  80303e:	8b 45 0c             	mov    0xc(%ebp),%eax
  803041:	89 04 24             	mov    %eax,(%esp)
  803044:	e8 41 e3 ff ff       	call   80138a <strcpy>
	return 0;
}
  803049:	b8 00 00 00 00       	mov    $0x0,%eax
  80304e:	c9                   	leave  
  80304f:	c3                   	ret    

00803050 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  803050:	55                   	push   %ebp
  803051:	89 e5                	mov    %esp,%ebp
  803053:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  803056:	8b 45 08             	mov    0x8(%ebp),%eax
  803059:	8b 40 0c             	mov    0xc(%eax),%eax
  80305c:	89 04 24             	mov    %eax,(%esp)
  80305f:	e8 9e 02 00 00       	call   803302 <nsipc_close>
}
  803064:	c9                   	leave  
  803065:	c3                   	ret    

00803066 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  803066:	55                   	push   %ebp
  803067:	89 e5                	mov    %esp,%ebp
  803069:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80306c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  803073:	00 
  803074:	8b 45 10             	mov    0x10(%ebp),%eax
  803077:	89 44 24 08          	mov    %eax,0x8(%esp)
  80307b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80307e:	89 44 24 04          	mov    %eax,0x4(%esp)
  803082:	8b 45 08             	mov    0x8(%ebp),%eax
  803085:	8b 40 0c             	mov    0xc(%eax),%eax
  803088:	89 04 24             	mov    %eax,(%esp)
  80308b:	e8 ae 02 00 00       	call   80333e <nsipc_send>
}
  803090:	c9                   	leave  
  803091:	c3                   	ret    

00803092 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  803092:	55                   	push   %ebp
  803093:	89 e5                	mov    %esp,%ebp
  803095:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  803098:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80309f:	00 
  8030a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8030a3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8030a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8030b4:	89 04 24             	mov    %eax,(%esp)
  8030b7:	e8 f5 02 00 00       	call   8033b1 <nsipc_recv>
}
  8030bc:	c9                   	leave  
  8030bd:	c3                   	ret    

008030be <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8030be:	55                   	push   %ebp
  8030bf:	89 e5                	mov    %esp,%ebp
  8030c1:	56                   	push   %esi
  8030c2:	53                   	push   %ebx
  8030c3:	83 ec 20             	sub    $0x20,%esp
  8030c6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8030c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8030cb:	89 04 24             	mov    %eax,(%esp)
  8030ce:	e8 f8 ee ff ff       	call   801fcb <fd_alloc>
  8030d3:	89 c3                	mov    %eax,%ebx
  8030d5:	85 c0                	test   %eax,%eax
  8030d7:	78 21                	js     8030fa <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  8030d9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8030e0:	00 
  8030e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030ef:	e8 f2 e9 ff ff       	call   801ae6 <sys_page_alloc>
  8030f4:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	79 0a                	jns    803104 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  8030fa:	89 34 24             	mov    %esi,(%esp)
  8030fd:	e8 00 02 00 00       	call   803302 <nsipc_close>
		return r;
  803102:	eb 28                	jmp    80312c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  803104:	8b 15 3c 80 80 00    	mov    0x80803c,%edx
  80310a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80310d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803112:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  803119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80311f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803122:	89 04 24             	mov    %eax,(%esp)
  803125:	e8 76 ee ff ff       	call   801fa0 <fd2num>
  80312a:	89 c3                	mov    %eax,%ebx
}
  80312c:	89 d8                	mov    %ebx,%eax
  80312e:	83 c4 20             	add    $0x20,%esp
  803131:	5b                   	pop    %ebx
  803132:	5e                   	pop    %esi
  803133:	5d                   	pop    %ebp
  803134:	c3                   	ret    

00803135 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  803135:	55                   	push   %ebp
  803136:	89 e5                	mov    %esp,%ebp
  803138:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80313b:	8b 45 10             	mov    0x10(%ebp),%eax
  80313e:	89 44 24 08          	mov    %eax,0x8(%esp)
  803142:	8b 45 0c             	mov    0xc(%ebp),%eax
  803145:	89 44 24 04          	mov    %eax,0x4(%esp)
  803149:	8b 45 08             	mov    0x8(%ebp),%eax
  80314c:	89 04 24             	mov    %eax,(%esp)
  80314f:	e8 62 01 00 00       	call   8032b6 <nsipc_socket>
  803154:	85 c0                	test   %eax,%eax
  803156:	78 05                	js     80315d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  803158:	e8 61 ff ff ff       	call   8030be <alloc_sockfd>
}
  80315d:	c9                   	leave  
  80315e:	66 90                	xchg   %ax,%ax
  803160:	c3                   	ret    

00803161 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  803161:	55                   	push   %ebp
  803162:	89 e5                	mov    %esp,%ebp
  803164:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  803167:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80316a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80316e:	89 04 24             	mov    %eax,(%esp)
  803171:	e8 c7 ee ff ff       	call   80203d <fd_lookup>
  803176:	85 c0                	test   %eax,%eax
  803178:	78 15                	js     80318f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80317a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80317d:	8b 0a                	mov    (%edx),%ecx
  80317f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  803184:	3b 0d 3c 80 80 00    	cmp    0x80803c,%ecx
  80318a:	75 03                	jne    80318f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80318c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  80318f:	c9                   	leave  
  803190:	c3                   	ret    

00803191 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  803191:	55                   	push   %ebp
  803192:	89 e5                	mov    %esp,%ebp
  803194:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803197:	8b 45 08             	mov    0x8(%ebp),%eax
  80319a:	e8 c2 ff ff ff       	call   803161 <fd2sockid>
  80319f:	85 c0                	test   %eax,%eax
  8031a1:	78 0f                	js     8031b2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8031a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031a6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8031aa:	89 04 24             	mov    %eax,(%esp)
  8031ad:	e8 2e 01 00 00       	call   8032e0 <nsipc_listen>
}
  8031b2:	c9                   	leave  
  8031b3:	c3                   	ret    

008031b4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8031b4:	55                   	push   %ebp
  8031b5:	89 e5                	mov    %esp,%ebp
  8031b7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8031bd:	e8 9f ff ff ff       	call   803161 <fd2sockid>
  8031c2:	85 c0                	test   %eax,%eax
  8031c4:	78 16                	js     8031dc <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8031c6:	8b 55 10             	mov    0x10(%ebp),%edx
  8031c9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8031cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031d0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8031d4:	89 04 24             	mov    %eax,(%esp)
  8031d7:	e8 55 02 00 00       	call   803431 <nsipc_connect>
}
  8031dc:	c9                   	leave  
  8031dd:	c3                   	ret    

008031de <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8031de:	55                   	push   %ebp
  8031df:	89 e5                	mov    %esp,%ebp
  8031e1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8031e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e7:	e8 75 ff ff ff       	call   803161 <fd2sockid>
  8031ec:	85 c0                	test   %eax,%eax
  8031ee:	78 0f                	js     8031ff <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8031f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8031f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8031f7:	89 04 24             	mov    %eax,(%esp)
  8031fa:	e8 1d 01 00 00       	call   80331c <nsipc_shutdown>
}
  8031ff:	c9                   	leave  
  803200:	c3                   	ret    

00803201 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803201:	55                   	push   %ebp
  803202:	89 e5                	mov    %esp,%ebp
  803204:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803207:	8b 45 08             	mov    0x8(%ebp),%eax
  80320a:	e8 52 ff ff ff       	call   803161 <fd2sockid>
  80320f:	85 c0                	test   %eax,%eax
  803211:	78 16                	js     803229 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  803213:	8b 55 10             	mov    0x10(%ebp),%edx
  803216:	89 54 24 08          	mov    %edx,0x8(%esp)
  80321a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80321d:	89 54 24 04          	mov    %edx,0x4(%esp)
  803221:	89 04 24             	mov    %eax,(%esp)
  803224:	e8 47 02 00 00       	call   803470 <nsipc_bind>
}
  803229:	c9                   	leave  
  80322a:	c3                   	ret    

0080322b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80322b:	55                   	push   %ebp
  80322c:	89 e5                	mov    %esp,%ebp
  80322e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  803231:	8b 45 08             	mov    0x8(%ebp),%eax
  803234:	e8 28 ff ff ff       	call   803161 <fd2sockid>
  803239:	85 c0                	test   %eax,%eax
  80323b:	78 1f                	js     80325c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80323d:	8b 55 10             	mov    0x10(%ebp),%edx
  803240:	89 54 24 08          	mov    %edx,0x8(%esp)
  803244:	8b 55 0c             	mov    0xc(%ebp),%edx
  803247:	89 54 24 04          	mov    %edx,0x4(%esp)
  80324b:	89 04 24             	mov    %eax,(%esp)
  80324e:	e8 5c 02 00 00       	call   8034af <nsipc_accept>
  803253:	85 c0                	test   %eax,%eax
  803255:	78 05                	js     80325c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  803257:	e8 62 fe ff ff       	call   8030be <alloc_sockfd>
}
  80325c:	c9                   	leave  
  80325d:	8d 76 00             	lea    0x0(%esi),%esi
  803260:	c3                   	ret    
	...

00803270 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  803270:	55                   	push   %ebp
  803271:	89 e5                	mov    %esp,%ebp
  803273:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  803276:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  80327c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  803283:	00 
  803284:	c7 44 24 08 00 70 80 	movl   $0x807000,0x8(%esp)
  80328b:	00 
  80328c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803290:	89 14 24             	mov    %edx,(%esp)
  803293:	e8 58 07 00 00       	call   8039f0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  803298:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80329f:	00 
  8032a0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8032a7:	00 
  8032a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8032af:	e8 9e 07 00 00       	call   803a52 <ipc_recv>
}
  8032b4:	c9                   	leave  
  8032b5:	c3                   	ret    

008032b6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8032b6:	55                   	push   %ebp
  8032b7:	89 e5                	mov    %esp,%ebp
  8032b9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.socket.req_type = type;
  8032c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032c7:	a3 04 70 80 00       	mov    %eax,0x807004
	nsipcbuf.socket.req_protocol = protocol;
  8032cc:	8b 45 10             	mov    0x10(%ebp),%eax
  8032cf:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SOCKET);
  8032d4:	b8 09 00 00 00       	mov    $0x9,%eax
  8032d9:	e8 92 ff ff ff       	call   803270 <nsipc>
}
  8032de:	c9                   	leave  
  8032df:	c3                   	ret    

008032e0 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8032e0:	55                   	push   %ebp
  8032e1:	89 e5                	mov    %esp,%ebp
  8032e3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8032e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e9:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.listen.req_backlog = backlog;
  8032ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8032f1:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_LISTEN);
  8032f6:	b8 06 00 00 00       	mov    $0x6,%eax
  8032fb:	e8 70 ff ff ff       	call   803270 <nsipc>
}
  803300:	c9                   	leave  
  803301:	c3                   	ret    

00803302 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  803302:	55                   	push   %ebp
  803303:	89 e5                	mov    %esp,%ebp
  803305:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  803308:	8b 45 08             	mov    0x8(%ebp),%eax
  80330b:	a3 00 70 80 00       	mov    %eax,0x807000
	return nsipc(NSREQ_CLOSE);
  803310:	b8 04 00 00 00       	mov    $0x4,%eax
  803315:	e8 56 ff ff ff       	call   803270 <nsipc>
}
  80331a:	c9                   	leave  
  80331b:	c3                   	ret    

0080331c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80331c:	55                   	push   %ebp
  80331d:	89 e5                	mov    %esp,%ebp
  80331f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  803322:	8b 45 08             	mov    0x8(%ebp),%eax
  803325:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.shutdown.req_how = how;
  80332a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80332d:	a3 04 70 80 00       	mov    %eax,0x807004
	return nsipc(NSREQ_SHUTDOWN);
  803332:	b8 03 00 00 00       	mov    $0x3,%eax
  803337:	e8 34 ff ff ff       	call   803270 <nsipc>
}
  80333c:	c9                   	leave  
  80333d:	c3                   	ret    

0080333e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80333e:	55                   	push   %ebp
  80333f:	89 e5                	mov    %esp,%ebp
  803341:	53                   	push   %ebx
  803342:	83 ec 14             	sub    $0x14,%esp
  803345:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  803348:	8b 45 08             	mov    0x8(%ebp),%eax
  80334b:	a3 00 70 80 00       	mov    %eax,0x807000
	assert(size < 1600);
  803350:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  803356:	7e 24                	jle    80337c <nsipc_send+0x3e>
  803358:	c7 44 24 0c e8 44 80 	movl   $0x8044e8,0xc(%esp)
  80335f:	00 
  803360:	c7 44 24 08 38 3f 80 	movl   $0x803f38,0x8(%esp)
  803367:	00 
  803368:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  80336f:	00 
  803370:	c7 04 24 f4 44 80 00 	movl   $0x8044f4,(%esp)
  803377:	e8 7c d7 ff ff       	call   800af8 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80337c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803380:	8b 45 0c             	mov    0xc(%ebp),%eax
  803383:	89 44 24 04          	mov    %eax,0x4(%esp)
  803387:	c7 04 24 0c 70 80 00 	movl   $0x80700c,(%esp)
  80338e:	e8 b2 e1 ff ff       	call   801545 <memmove>
	nsipcbuf.send.req_size = size;
  803393:	89 1d 04 70 80 00    	mov    %ebx,0x807004
	nsipcbuf.send.req_flags = flags;
  803399:	8b 45 14             	mov    0x14(%ebp),%eax
  80339c:	a3 08 70 80 00       	mov    %eax,0x807008
	return nsipc(NSREQ_SEND);
  8033a1:	b8 08 00 00 00       	mov    $0x8,%eax
  8033a6:	e8 c5 fe ff ff       	call   803270 <nsipc>
}
  8033ab:	83 c4 14             	add    $0x14,%esp
  8033ae:	5b                   	pop    %ebx
  8033af:	5d                   	pop    %ebp
  8033b0:	c3                   	ret    

008033b1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8033b1:	55                   	push   %ebp
  8033b2:	89 e5                	mov    %esp,%ebp
  8033b4:	56                   	push   %esi
  8033b5:	53                   	push   %ebx
  8033b6:	83 ec 10             	sub    $0x10,%esp
  8033b9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8033bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033bf:	a3 00 70 80 00       	mov    %eax,0x807000
	nsipcbuf.recv.req_len = len;
  8033c4:	89 35 04 70 80 00    	mov    %esi,0x807004
	nsipcbuf.recv.req_flags = flags;
  8033ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8033cd:	a3 08 70 80 00       	mov    %eax,0x807008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8033d2:	b8 07 00 00 00       	mov    $0x7,%eax
  8033d7:	e8 94 fe ff ff       	call   803270 <nsipc>
  8033dc:	89 c3                	mov    %eax,%ebx
  8033de:	85 c0                	test   %eax,%eax
  8033e0:	78 46                	js     803428 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8033e2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8033e7:	7f 04                	jg     8033ed <nsipc_recv+0x3c>
  8033e9:	39 c6                	cmp    %eax,%esi
  8033eb:	7d 24                	jge    803411 <nsipc_recv+0x60>
  8033ed:	c7 44 24 0c 00 45 80 	movl   $0x804500,0xc(%esp)
  8033f4:	00 
  8033f5:	c7 44 24 08 38 3f 80 	movl   $0x803f38,0x8(%esp)
  8033fc:	00 
  8033fd:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  803404:	00 
  803405:	c7 04 24 f4 44 80 00 	movl   $0x8044f4,(%esp)
  80340c:	e8 e7 d6 ff ff       	call   800af8 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  803411:	89 44 24 08          	mov    %eax,0x8(%esp)
  803415:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  80341c:	00 
  80341d:	8b 45 0c             	mov    0xc(%ebp),%eax
  803420:	89 04 24             	mov    %eax,(%esp)
  803423:	e8 1d e1 ff ff       	call   801545 <memmove>
	}

	return r;
}
  803428:	89 d8                	mov    %ebx,%eax
  80342a:	83 c4 10             	add    $0x10,%esp
  80342d:	5b                   	pop    %ebx
  80342e:	5e                   	pop    %esi
  80342f:	5d                   	pop    %ebp
  803430:	c3                   	ret    

00803431 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  803431:	55                   	push   %ebp
  803432:	89 e5                	mov    %esp,%ebp
  803434:	53                   	push   %ebx
  803435:	83 ec 14             	sub    $0x14,%esp
  803438:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80343b:	8b 45 08             	mov    0x8(%ebp),%eax
  80343e:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  803443:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803447:	8b 45 0c             	mov    0xc(%ebp),%eax
  80344a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80344e:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803455:	e8 eb e0 ff ff       	call   801545 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80345a:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_CONNECT);
  803460:	b8 05 00 00 00       	mov    $0x5,%eax
  803465:	e8 06 fe ff ff       	call   803270 <nsipc>
}
  80346a:	83 c4 14             	add    $0x14,%esp
  80346d:	5b                   	pop    %ebx
  80346e:	5d                   	pop    %ebp
  80346f:	c3                   	ret    

00803470 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  803470:	55                   	push   %ebp
  803471:	89 e5                	mov    %esp,%ebp
  803473:	53                   	push   %ebx
  803474:	83 ec 14             	sub    $0x14,%esp
  803477:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80347a:	8b 45 08             	mov    0x8(%ebp),%eax
  80347d:	a3 00 70 80 00       	mov    %eax,0x807000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  803482:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803486:	8b 45 0c             	mov    0xc(%ebp),%eax
  803489:	89 44 24 04          	mov    %eax,0x4(%esp)
  80348d:	c7 04 24 04 70 80 00 	movl   $0x807004,(%esp)
  803494:	e8 ac e0 ff ff       	call   801545 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  803499:	89 1d 14 70 80 00    	mov    %ebx,0x807014
	return nsipc(NSREQ_BIND);
  80349f:	b8 02 00 00 00       	mov    $0x2,%eax
  8034a4:	e8 c7 fd ff ff       	call   803270 <nsipc>
}
  8034a9:	83 c4 14             	add    $0x14,%esp
  8034ac:	5b                   	pop    %ebx
  8034ad:	5d                   	pop    %ebp
  8034ae:	c3                   	ret    

008034af <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8034af:	55                   	push   %ebp
  8034b0:	89 e5                	mov    %esp,%ebp
  8034b2:	83 ec 18             	sub    $0x18,%esp
  8034b5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8034b8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8034bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034be:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8034c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8034c8:	e8 a3 fd ff ff       	call   803270 <nsipc>
  8034cd:	89 c3                	mov    %eax,%ebx
  8034cf:	85 c0                	test   %eax,%eax
  8034d1:	78 25                	js     8034f8 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8034d3:	be 10 70 80 00       	mov    $0x807010,%esi
  8034d8:	8b 06                	mov    (%esi),%eax
  8034da:	89 44 24 08          	mov    %eax,0x8(%esp)
  8034de:	c7 44 24 04 00 70 80 	movl   $0x807000,0x4(%esp)
  8034e5:	00 
  8034e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8034e9:	89 04 24             	mov    %eax,(%esp)
  8034ec:	e8 54 e0 ff ff       	call   801545 <memmove>
		*addrlen = ret->ret_addrlen;
  8034f1:	8b 16                	mov    (%esi),%edx
  8034f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8034f6:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  8034f8:	89 d8                	mov    %ebx,%eax
  8034fa:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8034fd:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803500:	89 ec                	mov    %ebp,%esp
  803502:	5d                   	pop    %ebp
  803503:	c3                   	ret    
	...

00803510 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  803510:	55                   	push   %ebp
  803511:	89 e5                	mov    %esp,%ebp
  803513:	83 ec 18             	sub    $0x18,%esp
  803516:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803519:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80351c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80351f:	8b 45 08             	mov    0x8(%ebp),%eax
  803522:	89 04 24             	mov    %eax,(%esp)
  803525:	e8 86 ea ff ff       	call   801fb0 <fd2data>
  80352a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80352c:	c7 44 24 04 15 45 80 	movl   $0x804515,0x4(%esp)
  803533:	00 
  803534:	89 34 24             	mov    %esi,(%esp)
  803537:	e8 4e de ff ff       	call   80138a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80353c:	8b 43 04             	mov    0x4(%ebx),%eax
  80353f:	2b 03                	sub    (%ebx),%eax
  803541:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  803547:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80354e:	00 00 00 
	stat->st_dev = &devpipe;
  803551:	c7 86 88 00 00 00 58 	movl   $0x808058,0x88(%esi)
  803558:	80 80 00 
	return 0;
}
  80355b:	b8 00 00 00 00       	mov    $0x0,%eax
  803560:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803563:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803566:	89 ec                	mov    %ebp,%esp
  803568:	5d                   	pop    %ebp
  803569:	c3                   	ret    

0080356a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80356a:	55                   	push   %ebp
  80356b:	89 e5                	mov    %esp,%ebp
  80356d:	53                   	push   %ebx
  80356e:	83 ec 14             	sub    $0x14,%esp
  803571:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  803574:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  803578:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80357f:	e8 a6 e4 ff ff       	call   801a2a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803584:	89 1c 24             	mov    %ebx,(%esp)
  803587:	e8 24 ea ff ff       	call   801fb0 <fd2data>
  80358c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803590:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803597:	e8 8e e4 ff ff       	call   801a2a <sys_page_unmap>
}
  80359c:	83 c4 14             	add    $0x14,%esp
  80359f:	5b                   	pop    %ebx
  8035a0:	5d                   	pop    %ebp
  8035a1:	c3                   	ret    

008035a2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8035a2:	55                   	push   %ebp
  8035a3:	89 e5                	mov    %esp,%ebp
  8035a5:	57                   	push   %edi
  8035a6:	56                   	push   %esi
  8035a7:	53                   	push   %ebx
  8035a8:	83 ec 2c             	sub    $0x2c,%esp
  8035ab:	89 c7                	mov    %eax,%edi
  8035ad:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8035b0:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  8035b5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8035b8:	89 3c 24             	mov    %edi,(%esp)
  8035bb:	e8 f8 04 00 00       	call   803ab8 <pageref>
  8035c0:	89 c6                	mov    %eax,%esi
  8035c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035c5:	89 04 24             	mov    %eax,(%esp)
  8035c8:	e8 eb 04 00 00       	call   803ab8 <pageref>
  8035cd:	39 c6                	cmp    %eax,%esi
  8035cf:	0f 94 c0             	sete   %al
  8035d2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  8035d5:	8b 15 a0 84 80 00    	mov    0x8084a0,%edx
  8035db:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8035de:	39 cb                	cmp    %ecx,%ebx
  8035e0:	75 08                	jne    8035ea <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  8035e2:	83 c4 2c             	add    $0x2c,%esp
  8035e5:	5b                   	pop    %ebx
  8035e6:	5e                   	pop    %esi
  8035e7:	5f                   	pop    %edi
  8035e8:	5d                   	pop    %ebp
  8035e9:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8035ea:	83 f8 01             	cmp    $0x1,%eax
  8035ed:	75 c1                	jne    8035b0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  8035ef:	8b 52 58             	mov    0x58(%edx),%edx
  8035f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035f6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8035fa:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8035fe:	c7 04 24 1c 45 80 00 	movl   $0x80451c,(%esp)
  803605:	e8 b3 d5 ff ff       	call   800bbd <cprintf>
  80360a:	eb a4                	jmp    8035b0 <_pipeisclosed+0xe>

0080360c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80360c:	55                   	push   %ebp
  80360d:	89 e5                	mov    %esp,%ebp
  80360f:	57                   	push   %edi
  803610:	56                   	push   %esi
  803611:	53                   	push   %ebx
  803612:	83 ec 1c             	sub    $0x1c,%esp
  803615:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  803618:	89 34 24             	mov    %esi,(%esp)
  80361b:	e8 90 e9 ff ff       	call   801fb0 <fd2data>
  803620:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803622:	bf 00 00 00 00       	mov    $0x0,%edi
  803627:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80362b:	75 54                	jne    803681 <devpipe_write+0x75>
  80362d:	eb 60                	jmp    80368f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80362f:	89 da                	mov    %ebx,%edx
  803631:	89 f0                	mov    %esi,%eax
  803633:	e8 6a ff ff ff       	call   8035a2 <_pipeisclosed>
  803638:	85 c0                	test   %eax,%eax
  80363a:	74 07                	je     803643 <devpipe_write+0x37>
  80363c:	b8 00 00 00 00       	mov    $0x0,%eax
  803641:	eb 53                	jmp    803696 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  803643:	90                   	nop
  803644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803648:	e8 f8 e4 ff ff       	call   801b45 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80364d:	8b 43 04             	mov    0x4(%ebx),%eax
  803650:	8b 13                	mov    (%ebx),%edx
  803652:	83 c2 20             	add    $0x20,%edx
  803655:	39 d0                	cmp    %edx,%eax
  803657:	73 d6                	jae    80362f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  803659:	89 c2                	mov    %eax,%edx
  80365b:	c1 fa 1f             	sar    $0x1f,%edx
  80365e:	c1 ea 1b             	shr    $0x1b,%edx
  803661:	01 d0                	add    %edx,%eax
  803663:	83 e0 1f             	and    $0x1f,%eax
  803666:	29 d0                	sub    %edx,%eax
  803668:	89 c2                	mov    %eax,%edx
  80366a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80366d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  803671:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  803675:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803679:	83 c7 01             	add    $0x1,%edi
  80367c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80367f:	76 13                	jbe    803694 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  803681:	8b 43 04             	mov    0x4(%ebx),%eax
  803684:	8b 13                	mov    (%ebx),%edx
  803686:	83 c2 20             	add    $0x20,%edx
  803689:	39 d0                	cmp    %edx,%eax
  80368b:	73 a2                	jae    80362f <devpipe_write+0x23>
  80368d:	eb ca                	jmp    803659 <devpipe_write+0x4d>
  80368f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  803694:	89 f8                	mov    %edi,%eax
}
  803696:	83 c4 1c             	add    $0x1c,%esp
  803699:	5b                   	pop    %ebx
  80369a:	5e                   	pop    %esi
  80369b:	5f                   	pop    %edi
  80369c:	5d                   	pop    %ebp
  80369d:	c3                   	ret    

0080369e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80369e:	55                   	push   %ebp
  80369f:	89 e5                	mov    %esp,%ebp
  8036a1:	83 ec 28             	sub    $0x28,%esp
  8036a4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8036a7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8036aa:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8036ad:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8036b0:	89 3c 24             	mov    %edi,(%esp)
  8036b3:	e8 f8 e8 ff ff       	call   801fb0 <fd2data>
  8036b8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8036ba:	be 00 00 00 00       	mov    $0x0,%esi
  8036bf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8036c3:	75 4c                	jne    803711 <devpipe_read+0x73>
  8036c5:	eb 5b                	jmp    803722 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8036c7:	89 f0                	mov    %esi,%eax
  8036c9:	eb 5e                	jmp    803729 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8036cb:	89 da                	mov    %ebx,%edx
  8036cd:	89 f8                	mov    %edi,%eax
  8036cf:	90                   	nop
  8036d0:	e8 cd fe ff ff       	call   8035a2 <_pipeisclosed>
  8036d5:	85 c0                	test   %eax,%eax
  8036d7:	74 07                	je     8036e0 <devpipe_read+0x42>
  8036d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8036de:	eb 49                	jmp    803729 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8036e0:	e8 60 e4 ff ff       	call   801b45 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8036e5:	8b 03                	mov    (%ebx),%eax
  8036e7:	3b 43 04             	cmp    0x4(%ebx),%eax
  8036ea:	74 df                	je     8036cb <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8036ec:	89 c2                	mov    %eax,%edx
  8036ee:	c1 fa 1f             	sar    $0x1f,%edx
  8036f1:	c1 ea 1b             	shr    $0x1b,%edx
  8036f4:	01 d0                	add    %edx,%eax
  8036f6:	83 e0 1f             	and    $0x1f,%eax
  8036f9:	29 d0                	sub    %edx,%eax
  8036fb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  803700:	8b 55 0c             	mov    0xc(%ebp),%edx
  803703:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  803706:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  803709:	83 c6 01             	add    $0x1,%esi
  80370c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80370f:	76 16                	jbe    803727 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  803711:	8b 03                	mov    (%ebx),%eax
  803713:	3b 43 04             	cmp    0x4(%ebx),%eax
  803716:	75 d4                	jne    8036ec <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  803718:	85 f6                	test   %esi,%esi
  80371a:	75 ab                	jne    8036c7 <devpipe_read+0x29>
  80371c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803720:	eb a9                	jmp    8036cb <devpipe_read+0x2d>
  803722:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803727:	89 f0                	mov    %esi,%eax
}
  803729:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80372c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80372f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803732:	89 ec                	mov    %ebp,%esp
  803734:	5d                   	pop    %ebp
  803735:	c3                   	ret    

00803736 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  803736:	55                   	push   %ebp
  803737:	89 e5                	mov    %esp,%ebp
  803739:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80373c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80373f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803743:	8b 45 08             	mov    0x8(%ebp),%eax
  803746:	89 04 24             	mov    %eax,(%esp)
  803749:	e8 ef e8 ff ff       	call   80203d <fd_lookup>
  80374e:	85 c0                	test   %eax,%eax
  803750:	78 15                	js     803767 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803755:	89 04 24             	mov    %eax,(%esp)
  803758:	e8 53 e8 ff ff       	call   801fb0 <fd2data>
	return _pipeisclosed(fd, p);
  80375d:	89 c2                	mov    %eax,%edx
  80375f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803762:	e8 3b fe ff ff       	call   8035a2 <_pipeisclosed>
}
  803767:	c9                   	leave  
  803768:	c3                   	ret    

00803769 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803769:	55                   	push   %ebp
  80376a:	89 e5                	mov    %esp,%ebp
  80376c:	83 ec 48             	sub    $0x48,%esp
  80376f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803772:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803775:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803778:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80377b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80377e:	89 04 24             	mov    %eax,(%esp)
  803781:	e8 45 e8 ff ff       	call   801fcb <fd_alloc>
  803786:	89 c3                	mov    %eax,%ebx
  803788:	85 c0                	test   %eax,%eax
  80378a:	0f 88 42 01 00 00    	js     8038d2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803790:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803797:	00 
  803798:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80379b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80379f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8037a6:	e8 3b e3 ff ff       	call   801ae6 <sys_page_alloc>
  8037ab:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8037ad:	85 c0                	test   %eax,%eax
  8037af:	0f 88 1d 01 00 00    	js     8038d2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8037b5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8037b8:	89 04 24             	mov    %eax,(%esp)
  8037bb:	e8 0b e8 ff ff       	call   801fcb <fd_alloc>
  8037c0:	89 c3                	mov    %eax,%ebx
  8037c2:	85 c0                	test   %eax,%eax
  8037c4:	0f 88 f5 00 00 00    	js     8038bf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037ca:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8037d1:	00 
  8037d2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8037d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8037d9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8037e0:	e8 01 e3 ff ff       	call   801ae6 <sys_page_alloc>
  8037e5:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8037e7:	85 c0                	test   %eax,%eax
  8037e9:	0f 88 d0 00 00 00    	js     8038bf <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8037ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037f2:	89 04 24             	mov    %eax,(%esp)
  8037f5:	e8 b6 e7 ff ff       	call   801fb0 <fd2data>
  8037fa:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8037fc:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803803:	00 
  803804:	89 44 24 04          	mov    %eax,0x4(%esp)
  803808:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80380f:	e8 d2 e2 ff ff       	call   801ae6 <sys_page_alloc>
  803814:	89 c3                	mov    %eax,%ebx
  803816:	85 c0                	test   %eax,%eax
  803818:	0f 88 8e 00 00 00    	js     8038ac <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80381e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803821:	89 04 24             	mov    %eax,(%esp)
  803824:	e8 87 e7 ff ff       	call   801fb0 <fd2data>
  803829:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803830:	00 
  803831:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803835:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80383c:	00 
  80383d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803841:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803848:	e8 3b e2 ff ff       	call   801a88 <sys_page_map>
  80384d:	89 c3                	mov    %eax,%ebx
  80384f:	85 c0                	test   %eax,%eax
  803851:	78 49                	js     80389c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803853:	b8 58 80 80 00       	mov    $0x808058,%eax
  803858:	8b 08                	mov    (%eax),%ecx
  80385a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80385d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80385f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803862:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  803869:	8b 10                	mov    (%eax),%edx
  80386b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80386e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803870:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803873:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80387a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80387d:	89 04 24             	mov    %eax,(%esp)
  803880:	e8 1b e7 ff ff       	call   801fa0 <fd2num>
  803885:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  803887:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80388a:	89 04 24             	mov    %eax,(%esp)
  80388d:	e8 0e e7 ff ff       	call   801fa0 <fd2num>
  803892:	89 47 04             	mov    %eax,0x4(%edi)
  803895:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80389a:	eb 36                	jmp    8038d2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80389c:	89 74 24 04          	mov    %esi,0x4(%esp)
  8038a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038a7:	e8 7e e1 ff ff       	call   801a2a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8038ac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8038af:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038ba:	e8 6b e1 ff ff       	call   801a2a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8038bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8038c6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8038cd:	e8 58 e1 ff ff       	call   801a2a <sys_page_unmap>
    err:
	return r;
}
  8038d2:	89 d8                	mov    %ebx,%eax
  8038d4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8038d7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8038da:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8038dd:	89 ec                	mov    %ebp,%esp
  8038df:	5d                   	pop    %ebp
  8038e0:	c3                   	ret    
  8038e1:	00 00                	add    %al,(%eax)
	...

008038e4 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8038e4:	55                   	push   %ebp
  8038e5:	89 e5                	mov    %esp,%ebp
  8038e7:	56                   	push   %esi
  8038e8:	53                   	push   %ebx
  8038e9:	83 ec 10             	sub    $0x10,%esp
  8038ec:	8b 45 08             	mov    0x8(%ebp),%eax
	volatile struct Env *e;

	assert(envid != 0);
  8038ef:	85 c0                	test   %eax,%eax
  8038f1:	75 24                	jne    803917 <wait+0x33>
  8038f3:	c7 44 24 0c 34 45 80 	movl   $0x804534,0xc(%esp)
  8038fa:	00 
  8038fb:	c7 44 24 08 38 3f 80 	movl   $0x803f38,0x8(%esp)
  803902:	00 
  803903:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  80390a:	00 
  80390b:	c7 04 24 3f 45 80 00 	movl   $0x80453f,(%esp)
  803912:	e8 e1 d1 ff ff       	call   800af8 <_panic>
	e = &envs[ENVX(envid)];
  803917:	89 c3                	mov    %eax,%ebx
  803919:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  80391f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  803922:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803928:	8b 73 4c             	mov    0x4c(%ebx),%esi
  80392b:	39 c6                	cmp    %eax,%esi
  80392d:	75 1a                	jne    803949 <wait+0x65>
  80392f:	8b 43 54             	mov    0x54(%ebx),%eax
  803932:	85 c0                	test   %eax,%eax
  803934:	74 13                	je     803949 <wait+0x65>
		sys_yield();
  803936:	e8 0a e2 ff ff       	call   801b45 <sys_yield>
{
	volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80393b:	8b 43 4c             	mov    0x4c(%ebx),%eax
  80393e:	39 f0                	cmp    %esi,%eax
  803940:	75 07                	jne    803949 <wait+0x65>
  803942:	8b 43 54             	mov    0x54(%ebx),%eax
  803945:	85 c0                	test   %eax,%eax
  803947:	75 ed                	jne    803936 <wait+0x52>
		sys_yield();
}
  803949:	83 c4 10             	add    $0x10,%esp
  80394c:	5b                   	pop    %ebx
  80394d:	5e                   	pop    %esi
  80394e:	5d                   	pop    %ebp
  80394f:	c3                   	ret    

00803950 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803950:	55                   	push   %ebp
  803951:	89 e5                	mov    %esp,%ebp
  803953:	53                   	push   %ebx
  803954:	83 ec 14             	sub    $0x14,%esp
  803957:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    // cprintf("\nhere outside loading creating page\n");

	if (_pgfault_handler == 0) {
  80395a:	83 3d a8 84 80 00 00 	cmpl   $0x0,0x8084a8
  803961:	75 58                	jne    8039bb <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
           //cprintf("\nhere inside loading creating page\n");    
          if(sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  803963:	e8 11 e2 ff ff       	call   801b79 <sys_getenvid>
  803968:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80396f:	00 
  803970:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  803977:	ee 
  803978:	89 04 24             	mov    %eax,(%esp)
  80397b:	e8 66 e1 ff ff       	call   801ae6 <sys_page_alloc>
  803980:	85 c0                	test   %eax,%eax
  803982:	79 1c                	jns    8039a0 <set_pgfault_handler+0x50>
                          panic("Cant allocate Page");                    
  803984:	c7 44 24 08 3c 43 80 	movl   $0x80433c,0x8(%esp)
  80398b:	00 
  80398c:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  803993:	00 
  803994:	c7 04 24 4a 45 80 00 	movl   $0x80454a,(%esp)
  80399b:	e8 58 d1 ff ff       	call   800af8 <_panic>
                _pgfault_handler=handler;
  8039a0:	89 1d a8 84 80 00    	mov    %ebx,0x8084a8
//entry point _pgfault_handler not pointed to by the kernel bcz after the execution is complete control needs to be returned back to execute the rest...so upcall is there         
             sys_env_set_pgfault_upcall(sys_getenvid(),_pgfault_upcall);
  8039a6:	e8 ce e1 ff ff       	call   801b79 <sys_getenvid>
  8039ab:	c7 44 24 04 c8 39 80 	movl   $0x8039c8,0x4(%esp)
  8039b2:	00 
  8039b3:	89 04 24             	mov    %eax,(%esp)
  8039b6:	e8 55 df ff ff       	call   801910 <sys_env_set_pgfault_upcall>

	// Save handler pointer for assembly to call.
 //     if(sys_page_alloc(0,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
   //                       panic("Cant allocate Page");

	_pgfault_handler = handler;
  8039bb:	89 1d a8 84 80 00    	mov    %ebx,0x8084a8
}
  8039c1:	83 c4 14             	add    $0x14,%esp
  8039c4:	5b                   	pop    %ebx
  8039c5:	5d                   	pop    %ebp
  8039c6:	c3                   	ret    
	...

008039c8 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8039c8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8039c9:	a1 a8 84 80 00       	mov    0x8084a8,%eax
	call *%eax
  8039ce:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8039d0:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
           addl $8,%esp
  8039d3:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
            movl  32(%esp),%ebx
  8039d6:	8b 5c 24 20          	mov    0x20(%esp),%ebx
            movl  40(%esp),%eax
  8039da:	8b 44 24 28          	mov    0x28(%esp),%eax
            subl  $4,%eax
  8039de:	83 e8 04             	sub    $0x4,%eax
            movl  %eax,40(%esp)
  8039e1:	89 44 24 28          	mov    %eax,0x28(%esp)
            movl  %ebx,(%eax)
  8039e5:	89 18                	mov    %ebx,(%eax)
            popal
  8039e7:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
            
            add $4,%esp            
  8039e8:	83 c4 04             	add    $0x4,%esp
            popfl
  8039eb:	9d                   	popf   
             
           popl %esp
  8039ec:	5c                   	pop    %esp
	// LAB 4: Your code here.
           

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
           ret
  8039ed:	c3                   	ret    
	...

008039f0 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8039f0:	55                   	push   %ebp
  8039f1:	89 e5                	mov    %esp,%ebp
  8039f3:	57                   	push   %edi
  8039f4:	56                   	push   %esi
  8039f5:	53                   	push   %ebx
  8039f6:	83 ec 1c             	sub    $0x1c,%esp
  8039f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8039fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8039ff:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  803a02:	8b 45 14             	mov    0x14(%ebp),%eax
  803a05:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a09:	89 7c 24 08          	mov    %edi,0x8(%esp)
  803a0d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803a11:	89 1c 24             	mov    %ebx,(%esp)
  803a14:	e8 bf de ff ff       	call   8018d8 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  803a19:	85 c0                	test   %eax,%eax
  803a1b:	79 21                	jns    803a3e <ipc_send+0x4e>
  803a1d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803a20:	74 1c                	je     803a3e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  803a22:	c7 44 24 08 58 45 80 	movl   $0x804558,0x8(%esp)
  803a29:	00 
  803a2a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  803a31:	00 
  803a32:	c7 04 24 6a 45 80 00 	movl   $0x80456a,(%esp)
  803a39:	e8 ba d0 ff ff       	call   800af8 <_panic>
          else if(r==-E_IPC_NOT_RECV)
  803a3e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803a41:	75 07                	jne    803a4a <ipc_send+0x5a>
           sys_yield();
  803a43:	e8 fd e0 ff ff       	call   801b45 <sys_yield>
          else
            break;
        }
  803a48:	eb b8                	jmp    803a02 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  803a4a:	83 c4 1c             	add    $0x1c,%esp
  803a4d:	5b                   	pop    %ebx
  803a4e:	5e                   	pop    %esi
  803a4f:	5f                   	pop    %edi
  803a50:	5d                   	pop    %ebp
  803a51:	c3                   	ret    

00803a52 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803a52:	55                   	push   %ebp
  803a53:	89 e5                	mov    %esp,%ebp
  803a55:	83 ec 18             	sub    $0x18,%esp
  803a58:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  803a5b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  803a5e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803a61:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  803a64:	8b 45 0c             	mov    0xc(%ebp),%eax
  803a67:	89 04 24             	mov    %eax,(%esp)
  803a6a:	e8 0c de ff ff       	call   80187b <sys_ipc_recv>
        if(r<0)
  803a6f:	85 c0                	test   %eax,%eax
  803a71:	79 17                	jns    803a8a <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  803a73:	85 db                	test   %ebx,%ebx
  803a75:	74 06                	je     803a7d <ipc_recv+0x2b>
               *from_env_store =0;
  803a77:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  803a7d:	85 f6                	test   %esi,%esi
  803a7f:	90                   	nop
  803a80:	74 2c                	je     803aae <ipc_recv+0x5c>
              *perm_store=0;
  803a82:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  803a88:	eb 24                	jmp    803aae <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  803a8a:	85 db                	test   %ebx,%ebx
  803a8c:	74 0a                	je     803a98 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  803a8e:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  803a93:	8b 40 74             	mov    0x74(%eax),%eax
  803a96:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  803a98:	85 f6                	test   %esi,%esi
  803a9a:	74 0a                	je     803aa6 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  803a9c:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  803aa1:	8b 40 78             	mov    0x78(%eax),%eax
  803aa4:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  803aa6:	a1 a0 84 80 00       	mov    0x8084a0,%eax
  803aab:	8b 40 70             	mov    0x70(%eax),%eax
}
  803aae:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803ab1:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803ab4:	89 ec                	mov    %ebp,%esp
  803ab6:	5d                   	pop    %ebp
  803ab7:	c3                   	ret    

00803ab8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803ab8:	55                   	push   %ebp
  803ab9:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  803abb:	8b 45 08             	mov    0x8(%ebp),%eax
  803abe:	89 c2                	mov    %eax,%edx
  803ac0:	c1 ea 16             	shr    $0x16,%edx
  803ac3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  803aca:	f6 c2 01             	test   $0x1,%dl
  803acd:	74 26                	je     803af5 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  803acf:	c1 e8 0c             	shr    $0xc,%eax
  803ad2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  803ad9:	a8 01                	test   $0x1,%al
  803adb:	74 18                	je     803af5 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  803add:	c1 e8 0c             	shr    $0xc,%eax
  803ae0:	8d 14 40             	lea    (%eax,%eax,2),%edx
  803ae3:	c1 e2 02             	shl    $0x2,%edx
  803ae6:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  803aeb:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  803af0:	0f b7 c0             	movzwl %ax,%eax
  803af3:	eb 05                	jmp    803afa <pageref+0x42>
  803af5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803afa:	5d                   	pop    %ebp
  803afb:	c3                   	ret    
  803afc:	00 00                	add    %al,(%eax)
	...

00803b00 <__udivdi3>:
  803b00:	55                   	push   %ebp
  803b01:	89 e5                	mov    %esp,%ebp
  803b03:	57                   	push   %edi
  803b04:	56                   	push   %esi
  803b05:	83 ec 10             	sub    $0x10,%esp
  803b08:	8b 45 14             	mov    0x14(%ebp),%eax
  803b0b:	8b 55 08             	mov    0x8(%ebp),%edx
  803b0e:	8b 75 10             	mov    0x10(%ebp),%esi
  803b11:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803b14:	85 c0                	test   %eax,%eax
  803b16:	89 55 f0             	mov    %edx,-0x10(%ebp)
  803b19:	75 35                	jne    803b50 <__udivdi3+0x50>
  803b1b:	39 fe                	cmp    %edi,%esi
  803b1d:	77 61                	ja     803b80 <__udivdi3+0x80>
  803b1f:	85 f6                	test   %esi,%esi
  803b21:	75 0b                	jne    803b2e <__udivdi3+0x2e>
  803b23:	b8 01 00 00 00       	mov    $0x1,%eax
  803b28:	31 d2                	xor    %edx,%edx
  803b2a:	f7 f6                	div    %esi
  803b2c:	89 c6                	mov    %eax,%esi
  803b2e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803b31:	31 d2                	xor    %edx,%edx
  803b33:	89 f8                	mov    %edi,%eax
  803b35:	f7 f6                	div    %esi
  803b37:	89 c7                	mov    %eax,%edi
  803b39:	89 c8                	mov    %ecx,%eax
  803b3b:	f7 f6                	div    %esi
  803b3d:	89 c1                	mov    %eax,%ecx
  803b3f:	89 fa                	mov    %edi,%edx
  803b41:	89 c8                	mov    %ecx,%eax
  803b43:	83 c4 10             	add    $0x10,%esp
  803b46:	5e                   	pop    %esi
  803b47:	5f                   	pop    %edi
  803b48:	5d                   	pop    %ebp
  803b49:	c3                   	ret    
  803b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803b50:	39 f8                	cmp    %edi,%eax
  803b52:	77 1c                	ja     803b70 <__udivdi3+0x70>
  803b54:	0f bd d0             	bsr    %eax,%edx
  803b57:	83 f2 1f             	xor    $0x1f,%edx
  803b5a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803b5d:	75 39                	jne    803b98 <__udivdi3+0x98>
  803b5f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  803b62:	0f 86 a0 00 00 00    	jbe    803c08 <__udivdi3+0x108>
  803b68:	39 f8                	cmp    %edi,%eax
  803b6a:	0f 82 98 00 00 00    	jb     803c08 <__udivdi3+0x108>
  803b70:	31 ff                	xor    %edi,%edi
  803b72:	31 c9                	xor    %ecx,%ecx
  803b74:	89 c8                	mov    %ecx,%eax
  803b76:	89 fa                	mov    %edi,%edx
  803b78:	83 c4 10             	add    $0x10,%esp
  803b7b:	5e                   	pop    %esi
  803b7c:	5f                   	pop    %edi
  803b7d:	5d                   	pop    %ebp
  803b7e:	c3                   	ret    
  803b7f:	90                   	nop
  803b80:	89 d1                	mov    %edx,%ecx
  803b82:	89 fa                	mov    %edi,%edx
  803b84:	89 c8                	mov    %ecx,%eax
  803b86:	31 ff                	xor    %edi,%edi
  803b88:	f7 f6                	div    %esi
  803b8a:	89 c1                	mov    %eax,%ecx
  803b8c:	89 fa                	mov    %edi,%edx
  803b8e:	89 c8                	mov    %ecx,%eax
  803b90:	83 c4 10             	add    $0x10,%esp
  803b93:	5e                   	pop    %esi
  803b94:	5f                   	pop    %edi
  803b95:	5d                   	pop    %ebp
  803b96:	c3                   	ret    
  803b97:	90                   	nop
  803b98:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803b9c:	89 f2                	mov    %esi,%edx
  803b9e:	d3 e0                	shl    %cl,%eax
  803ba0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803ba3:	b8 20 00 00 00       	mov    $0x20,%eax
  803ba8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  803bab:	89 c1                	mov    %eax,%ecx
  803bad:	d3 ea                	shr    %cl,%edx
  803baf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803bb3:	0b 55 ec             	or     -0x14(%ebp),%edx
  803bb6:	d3 e6                	shl    %cl,%esi
  803bb8:	89 c1                	mov    %eax,%ecx
  803bba:	89 75 e8             	mov    %esi,-0x18(%ebp)
  803bbd:	89 fe                	mov    %edi,%esi
  803bbf:	d3 ee                	shr    %cl,%esi
  803bc1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803bc5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803bc8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803bcb:	d3 e7                	shl    %cl,%edi
  803bcd:	89 c1                	mov    %eax,%ecx
  803bcf:	d3 ea                	shr    %cl,%edx
  803bd1:	09 d7                	or     %edx,%edi
  803bd3:	89 f2                	mov    %esi,%edx
  803bd5:	89 f8                	mov    %edi,%eax
  803bd7:	f7 75 ec             	divl   -0x14(%ebp)
  803bda:	89 d6                	mov    %edx,%esi
  803bdc:	89 c7                	mov    %eax,%edi
  803bde:	f7 65 e8             	mull   -0x18(%ebp)
  803be1:	39 d6                	cmp    %edx,%esi
  803be3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803be6:	72 30                	jb     803c18 <__udivdi3+0x118>
  803be8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  803beb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803bef:	d3 e2                	shl    %cl,%edx
  803bf1:	39 c2                	cmp    %eax,%edx
  803bf3:	73 05                	jae    803bfa <__udivdi3+0xfa>
  803bf5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  803bf8:	74 1e                	je     803c18 <__udivdi3+0x118>
  803bfa:	89 f9                	mov    %edi,%ecx
  803bfc:	31 ff                	xor    %edi,%edi
  803bfe:	e9 71 ff ff ff       	jmp    803b74 <__udivdi3+0x74>
  803c03:	90                   	nop
  803c04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803c08:	31 ff                	xor    %edi,%edi
  803c0a:	b9 01 00 00 00       	mov    $0x1,%ecx
  803c0f:	e9 60 ff ff ff       	jmp    803b74 <__udivdi3+0x74>
  803c14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803c18:	8d 4f ff             	lea    -0x1(%edi),%ecx
  803c1b:	31 ff                	xor    %edi,%edi
  803c1d:	89 c8                	mov    %ecx,%eax
  803c1f:	89 fa                	mov    %edi,%edx
  803c21:	83 c4 10             	add    $0x10,%esp
  803c24:	5e                   	pop    %esi
  803c25:	5f                   	pop    %edi
  803c26:	5d                   	pop    %ebp
  803c27:	c3                   	ret    
	...

00803c30 <__umoddi3>:
  803c30:	55                   	push   %ebp
  803c31:	89 e5                	mov    %esp,%ebp
  803c33:	57                   	push   %edi
  803c34:	56                   	push   %esi
  803c35:	83 ec 20             	sub    $0x20,%esp
  803c38:	8b 55 14             	mov    0x14(%ebp),%edx
  803c3b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803c3e:	8b 7d 10             	mov    0x10(%ebp),%edi
  803c41:	8b 75 0c             	mov    0xc(%ebp),%esi
  803c44:	85 d2                	test   %edx,%edx
  803c46:	89 c8                	mov    %ecx,%eax
  803c48:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  803c4b:	75 13                	jne    803c60 <__umoddi3+0x30>
  803c4d:	39 f7                	cmp    %esi,%edi
  803c4f:	76 3f                	jbe    803c90 <__umoddi3+0x60>
  803c51:	89 f2                	mov    %esi,%edx
  803c53:	f7 f7                	div    %edi
  803c55:	89 d0                	mov    %edx,%eax
  803c57:	31 d2                	xor    %edx,%edx
  803c59:	83 c4 20             	add    $0x20,%esp
  803c5c:	5e                   	pop    %esi
  803c5d:	5f                   	pop    %edi
  803c5e:	5d                   	pop    %ebp
  803c5f:	c3                   	ret    
  803c60:	39 f2                	cmp    %esi,%edx
  803c62:	77 4c                	ja     803cb0 <__umoddi3+0x80>
  803c64:	0f bd ca             	bsr    %edx,%ecx
  803c67:	83 f1 1f             	xor    $0x1f,%ecx
  803c6a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  803c6d:	75 51                	jne    803cc0 <__umoddi3+0x90>
  803c6f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  803c72:	0f 87 e0 00 00 00    	ja     803d58 <__umoddi3+0x128>
  803c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c7b:	29 f8                	sub    %edi,%eax
  803c7d:	19 d6                	sbb    %edx,%esi
  803c7f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c85:	89 f2                	mov    %esi,%edx
  803c87:	83 c4 20             	add    $0x20,%esp
  803c8a:	5e                   	pop    %esi
  803c8b:	5f                   	pop    %edi
  803c8c:	5d                   	pop    %ebp
  803c8d:	c3                   	ret    
  803c8e:	66 90                	xchg   %ax,%ax
  803c90:	85 ff                	test   %edi,%edi
  803c92:	75 0b                	jne    803c9f <__umoddi3+0x6f>
  803c94:	b8 01 00 00 00       	mov    $0x1,%eax
  803c99:	31 d2                	xor    %edx,%edx
  803c9b:	f7 f7                	div    %edi
  803c9d:	89 c7                	mov    %eax,%edi
  803c9f:	89 f0                	mov    %esi,%eax
  803ca1:	31 d2                	xor    %edx,%edx
  803ca3:	f7 f7                	div    %edi
  803ca5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ca8:	f7 f7                	div    %edi
  803caa:	eb a9                	jmp    803c55 <__umoddi3+0x25>
  803cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803cb0:	89 c8                	mov    %ecx,%eax
  803cb2:	89 f2                	mov    %esi,%edx
  803cb4:	83 c4 20             	add    $0x20,%esp
  803cb7:	5e                   	pop    %esi
  803cb8:	5f                   	pop    %edi
  803cb9:	5d                   	pop    %ebp
  803cba:	c3                   	ret    
  803cbb:	90                   	nop
  803cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803cc0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803cc4:	d3 e2                	shl    %cl,%edx
  803cc6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803cc9:	ba 20 00 00 00       	mov    $0x20,%edx
  803cce:	2b 55 f0             	sub    -0x10(%ebp),%edx
  803cd1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803cd4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803cd8:	89 fa                	mov    %edi,%edx
  803cda:	d3 ea                	shr    %cl,%edx
  803cdc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803ce0:	0b 55 f4             	or     -0xc(%ebp),%edx
  803ce3:	d3 e7                	shl    %cl,%edi
  803ce5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803ce9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803cec:	89 f2                	mov    %esi,%edx
  803cee:	89 7d e8             	mov    %edi,-0x18(%ebp)
  803cf1:	89 c7                	mov    %eax,%edi
  803cf3:	d3 ea                	shr    %cl,%edx
  803cf5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803cf9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  803cfc:	89 c2                	mov    %eax,%edx
  803cfe:	d3 e6                	shl    %cl,%esi
  803d00:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803d04:	d3 ea                	shr    %cl,%edx
  803d06:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803d0a:	09 d6                	or     %edx,%esi
  803d0c:	89 f0                	mov    %esi,%eax
  803d0e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  803d11:	d3 e7                	shl    %cl,%edi
  803d13:	89 f2                	mov    %esi,%edx
  803d15:	f7 75 f4             	divl   -0xc(%ebp)
  803d18:	89 d6                	mov    %edx,%esi
  803d1a:	f7 65 e8             	mull   -0x18(%ebp)
  803d1d:	39 d6                	cmp    %edx,%esi
  803d1f:	72 2b                	jb     803d4c <__umoddi3+0x11c>
  803d21:	39 c7                	cmp    %eax,%edi
  803d23:	72 23                	jb     803d48 <__umoddi3+0x118>
  803d25:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803d29:	29 c7                	sub    %eax,%edi
  803d2b:	19 d6                	sbb    %edx,%esi
  803d2d:	89 f0                	mov    %esi,%eax
  803d2f:	89 f2                	mov    %esi,%edx
  803d31:	d3 ef                	shr    %cl,%edi
  803d33:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803d37:	d3 e0                	shl    %cl,%eax
  803d39:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803d3d:	09 f8                	or     %edi,%eax
  803d3f:	d3 ea                	shr    %cl,%edx
  803d41:	83 c4 20             	add    $0x20,%esp
  803d44:	5e                   	pop    %esi
  803d45:	5f                   	pop    %edi
  803d46:	5d                   	pop    %ebp
  803d47:	c3                   	ret    
  803d48:	39 d6                	cmp    %edx,%esi
  803d4a:	75 d9                	jne    803d25 <__umoddi3+0xf5>
  803d4c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  803d4f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  803d52:	eb d1                	jmp    803d25 <__umoddi3+0xf5>
  803d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803d58:	39 f2                	cmp    %esi,%edx
  803d5a:	0f 82 18 ff ff ff    	jb     803c78 <__umoddi3+0x48>
  803d60:	e9 1d ff ff ff       	jmp    803c82 <__umoddi3+0x52>
