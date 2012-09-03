
obj/user/testshell:     file format elf32-i386


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
  80002c:	e8 6b 05 00 00       	call   80059c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  80004c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80004f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800052:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800055:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800059:	89 3c 24             	mov    %edi,(%esp)
  80005c:	e8 44 1a 00 00       	call   801aa5 <seek>
	seek(kfd, off);
  800061:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800065:	89 34 24             	mov    %esi,(%esp)
  800068:	e8 38 1a 00 00       	call   801aa5 <seek>

	cprintf("shell produced incorrect output.\n");
  80006d:	c7 04 24 60 36 80 00 	movl   $0x803660,(%esp)
  800074:	e8 54 06 00 00       	call   8006cd <cprintf>
	cprintf("expected:\n===\n");
  800079:	c7 04 24 fb 36 80 00 	movl   $0x8036fb,(%esp)
  800080:	e8 48 06 00 00       	call   8006cd <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800085:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800088:	eb 0c                	jmp    800096 <wrong+0x56>
		sys_cputs(buf, n);
  80008a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80008e:	89 1c 24             	mov    %ebx,(%esp)
  800091:	e8 0a 11 00 00       	call   8011a0 <sys_cputs>
	seek(rfd, off);
	seek(kfd, off);

	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800096:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  80009d:	00 
  80009e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000a2:	89 34 24             	mov    %esi,(%esp)
  8000a5:	e8 14 1c 00 00       	call   801cbe <read>
  8000aa:	85 c0                	test   %eax,%eax
  8000ac:	7f dc                	jg     80008a <wrong+0x4a>
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
  8000ae:	c7 04 24 0a 37 80 00 	movl   $0x80370a,(%esp)
  8000b5:	e8 13 06 00 00       	call   8006cd <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000ba:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000bd:	eb 0c                	jmp    8000cb <wrong+0x8b>
		sys_cputs(buf, n);
  8000bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000c3:	89 1c 24             	mov    %ebx,(%esp)
  8000c6:	e8 d5 10 00 00       	call   8011a0 <sys_cputs>
	cprintf("shell produced incorrect output.\n");
	cprintf("expected:\n===\n");
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
		sys_cputs(buf, n);
	cprintf("===\ngot:\n===\n");
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000cb:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000d2:	00 
  8000d3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000d7:	89 3c 24             	mov    %edi,(%esp)
  8000da:	e8 df 1b 00 00       	call   801cbe <read>
  8000df:	85 c0                	test   %eax,%eax
  8000e1:	7f dc                	jg     8000bf <wrong+0x7f>
		sys_cputs(buf, n);
	cprintf("===\n");
  8000e3:	c7 04 24 05 37 80 00 	movl   $0x803705,(%esp)
  8000ea:	e8 de 05 00 00       	call   8006cd <cprintf>
	exit();
  8000ef:	e8 f8 04 00 00       	call   8005ec <exit>
}
  8000f4:	81 c4 8c 00 00 00    	add    $0x8c,%esp
  8000fa:	5b                   	pop    %ebx
  8000fb:	5e                   	pop    %esi
  8000fc:	5f                   	pop    %edi
  8000fd:	5d                   	pop    %ebp
  8000fe:	c3                   	ret    

008000ff <umain>:

void wrong(int, int, int);

void
umain(void)
{
  8000ff:	55                   	push   %ebp
  800100:	89 e5                	mov    %esp,%ebp
  800102:	57                   	push   %edi
  800103:	56                   	push   %esi
  800104:	53                   	push   %ebx
  800105:	83 ec 3c             	sub    $0x3c,%esp
	char c1, c2;
	int r, rfd, wfd, kfd, n1, n2, off, nloff;

	close(0);
  800108:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80010f:	e8 0a 1d 00 00       	call   801e1e <close>
	close(1);
  800114:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80011b:	e8 fe 1c 00 00       	call   801e1e <close>
	opencons();
  800120:	e8 bb 03 00 00       	call   8004e0 <opencons>
	opencons();
  800125:	e8 b6 03 00 00       	call   8004e0 <opencons>

	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  80012a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800131:	00 
  800132:	c7 04 24 18 37 80 00 	movl   $0x803718,(%esp)
  800139:	e8 d9 20 00 00       	call   802217 <open>
  80013e:	89 c6                	mov    %eax,%esi
  800140:	85 c0                	test   %eax,%eax
  800142:	79 20                	jns    800164 <umain+0x65>
		panic("open testshell.sh: %e", rfd);
  800144:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800148:	c7 44 24 08 25 37 80 	movl   $0x803725,0x8(%esp)
  80014f:	00 
  800150:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  800157:	00 
  800158:	c7 04 24 3b 37 80 00 	movl   $0x80373b,(%esp)
  80015f:	e8 a4 04 00 00       	call   800608 <_panic>
	if ((wfd = open("testshell.out", O_WRONLY|O_CREAT|O_TRUNC)) < 0)
  800164:	c7 44 24 04 01 03 00 	movl   $0x301,0x4(%esp)
  80016b:	00 
  80016c:	c7 04 24 4c 37 80 00 	movl   $0x80374c,(%esp)
  800173:	e8 9f 20 00 00       	call   802217 <open>
  800178:	89 c7                	mov    %eax,%edi
  80017a:	85 c0                	test   %eax,%eax
  80017c:	79 20                	jns    80019e <umain+0x9f>
		panic("open testshell.out: %e", wfd);
  80017e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800182:	c7 44 24 08 5a 37 80 	movl   $0x80375a,0x8(%esp)
  800189:	00 
  80018a:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
  800191:	00 
  800192:	c7 04 24 3b 37 80 00 	movl   $0x80373b,(%esp)
  800199:	e8 6a 04 00 00       	call   800608 <_panic>

	cprintf("running sh -x < testshell.sh > testshell.out\n");
  80019e:	c7 04 24 84 36 80 00 	movl   $0x803684,(%esp)
  8001a5:	e8 23 05 00 00       	call   8006cd <cprintf>
	if ((r = fork()) < 0)
  8001aa:	e8 d8 15 00 00       	call   801787 <fork>
  8001af:	89 c3                	mov    %eax,%ebx
  8001b1:	85 c0                	test   %eax,%eax
  8001b3:	79 20                	jns    8001d5 <umain+0xd6>
		panic("fork: %e", r);
  8001b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b9:	c7 44 24 08 83 3b 80 	movl   $0x803b83,0x8(%esp)
  8001c0:	00 
  8001c1:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
  8001c8:	00 
  8001c9:	c7 04 24 3b 37 80 00 	movl   $0x80373b,(%esp)
  8001d0:	e8 33 04 00 00       	call   800608 <_panic>
	if (r == 0) {
  8001d5:	85 c0                	test   %eax,%eax
  8001d7:	0f 85 9f 00 00 00    	jne    80027c <umain+0x17d>
		dup(rfd, 0);
  8001dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001e4:	00 
  8001e5:	89 34 24             	mov    %esi,(%esp)
  8001e8:	e8 d0 1c 00 00       	call   801ebd <dup>
		dup(wfd, 1);
  8001ed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001f4:	00 
  8001f5:	89 3c 24             	mov    %edi,(%esp)
  8001f8:	e8 c0 1c 00 00       	call   801ebd <dup>
		close(rfd);
  8001fd:	89 34 24             	mov    %esi,(%esp)
  800200:	e8 19 1c 00 00       	call   801e1e <close>
		close(wfd);
  800205:	89 3c 24             	mov    %edi,(%esp)
  800208:	e8 11 1c 00 00       	call   801e1e <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80020d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800214:	00 
  800215:	c7 44 24 08 71 37 80 	movl   $0x803771,0x8(%esp)
  80021c:	00 
  80021d:	c7 44 24 04 22 37 80 	movl   $0x803722,0x4(%esp)
  800224:	00 
  800225:	c7 04 24 74 37 80 00 	movl   $0x803774,(%esp)
  80022c:	e8 c0 26 00 00       	call   8028f1 <spawnl>
  800231:	89 c3                	mov    %eax,%ebx
  800233:	85 c0                	test   %eax,%eax
  800235:	79 20                	jns    800257 <umain+0x158>
			panic("spawn: %e", r);
  800237:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80023b:	c7 44 24 08 78 37 80 	movl   $0x803778,0x8(%esp)
  800242:	00 
  800243:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  80024a:	00 
  80024b:	c7 04 24 3b 37 80 00 	movl   $0x80373b,(%esp)
  800252:	e8 b1 03 00 00       	call   800608 <_panic>
		close(0);
  800257:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80025e:	e8 bb 1b 00 00       	call   801e1e <close>
		close(1);
  800263:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  80026a:	e8 af 1b 00 00       	call   801e1e <close>
		wait(r);
  80026f:	89 1c 24             	mov    %ebx,(%esp)
  800272:	e8 4d 2f 00 00       	call   8031c4 <wait>
		exit();
  800277:	e8 70 03 00 00       	call   8005ec <exit>
	}
	close(rfd);
  80027c:	89 34 24             	mov    %esi,(%esp)
  80027f:	e8 9a 1b 00 00       	call   801e1e <close>
	close(wfd);
  800284:	89 3c 24             	mov    %edi,(%esp)
  800287:	e8 92 1b 00 00       	call   801e1e <close>
	wait(r);
  80028c:	89 1c 24             	mov    %ebx,(%esp)
  80028f:	e8 30 2f 00 00       	call   8031c4 <wait>

	if ((rfd = open("testshell.out", O_RDONLY)) < 0)
  800294:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80029b:	00 
  80029c:	c7 04 24 4c 37 80 00 	movl   $0x80374c,(%esp)
  8002a3:	e8 6f 1f 00 00       	call   802217 <open>
  8002a8:	89 c7                	mov    %eax,%edi
  8002aa:	85 c0                	test   %eax,%eax
  8002ac:	79 20                	jns    8002ce <umain+0x1cf>
		panic("open testshell.out for reading: %e", rfd);
  8002ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002b2:	c7 44 24 08 b4 36 80 	movl   $0x8036b4,0x8(%esp)
  8002b9:	00 
  8002ba:	c7 44 24 04 2a 00 00 	movl   $0x2a,0x4(%esp)
  8002c1:	00 
  8002c2:	c7 04 24 3b 37 80 00 	movl   $0x80373b,(%esp)
  8002c9:	e8 3a 03 00 00       	call   800608 <_panic>
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8002ce:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002d5:	00 
  8002d6:	c7 04 24 82 37 80 00 	movl   $0x803782,(%esp)
  8002dd:	e8 35 1f 00 00       	call   802217 <open>
  8002e2:	89 c6                	mov    %eax,%esi
  8002e4:	85 c0                	test   %eax,%eax
  8002e6:	79 20                	jns    800308 <umain+0x209>
		panic("open testshell.key for reading: %e", kfd);
  8002e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002ec:	c7 44 24 08 d8 36 80 	movl   $0x8036d8,0x8(%esp)
  8002f3:	00 
  8002f4:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8002fb:	00 
  8002fc:	c7 04 24 3b 37 80 00 	movl   $0x80373b,(%esp)
  800303:	e8 00 03 00 00       	call   800608 <_panic>
  800308:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  80030f:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)

	nloff = 0;
	for (off=0;; off++) {
		n1 = read(rfd, &c1, 1);
  800316:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80031d:	00 
  80031e:	8d 45 e7             	lea    -0x19(%ebp),%eax
  800321:	89 44 24 04          	mov    %eax,0x4(%esp)
  800325:	89 3c 24             	mov    %edi,(%esp)
  800328:	e8 91 19 00 00       	call   801cbe <read>
  80032d:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  80032f:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800336:	00 
  800337:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  80033a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80033e:	89 34 24             	mov    %esi,(%esp)
  800341:	e8 78 19 00 00       	call   801cbe <read>
		if (n1 < 0)
  800346:	85 db                	test   %ebx,%ebx
  800348:	79 20                	jns    80036a <umain+0x26b>
			panic("reading testshell.out: %e", n1);
  80034a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80034e:	c7 44 24 08 90 37 80 	movl   $0x803790,0x8(%esp)
  800355:	00 
  800356:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  80035d:	00 
  80035e:	c7 04 24 3b 37 80 00 	movl   $0x80373b,(%esp)
  800365:	e8 9e 02 00 00       	call   800608 <_panic>
		if (n2 < 0)
  80036a:	85 c0                	test   %eax,%eax
  80036c:	79 20                	jns    80038e <umain+0x28f>
			panic("reading testshell.key: %e", n2);
  80036e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800372:	c7 44 24 08 aa 37 80 	movl   $0x8037aa,0x8(%esp)
  800379:	00 
  80037a:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  800381:	00 
  800382:	c7 04 24 3b 37 80 00 	movl   $0x80373b,(%esp)
  800389:	e8 7a 02 00 00       	call   800608 <_panic>
		if (n1 == 0 && n2 == 0)
  80038e:	85 c0                	test   %eax,%eax
  800390:	75 04                	jne    800396 <umain+0x297>
  800392:	85 db                	test   %ebx,%ebx
  800394:	74 3d                	je     8003d3 <umain+0x2d4>
			break;
		if (n1 != 1 || n2 != 1 || c1 != c2)
  800396:	83 fb 01             	cmp    $0x1,%ebx
  800399:	75 10                	jne    8003ab <umain+0x2ac>
  80039b:	83 f8 01             	cmp    $0x1,%eax
  80039e:	66 90                	xchg   %ax,%ax
  8003a0:	75 09                	jne    8003ab <umain+0x2ac>
  8003a2:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  8003a6:	3a 45 e6             	cmp    -0x1a(%ebp),%al
  8003a9:	74 13                	je     8003be <umain+0x2bf>
			wrong(rfd, kfd, nloff);
  8003ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8003b6:	89 3c 24             	mov    %edi,(%esp)
  8003b9:	e8 82 fc ff ff       	call   800040 <wrong>
		if (c1 == '\n')
  8003be:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8003c2:	75 06                	jne    8003ca <umain+0x2cb>
  8003c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8003c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003ca:	83 45 d4 01          	addl   $0x1,-0x2c(%ebp)
			nloff = off+1;
	}
  8003ce:	e9 43 ff ff ff       	jmp    800316 <umain+0x217>
	cprintf("shell ran correctly\n");			
  8003d3:	c7 04 24 c4 37 80 00 	movl   $0x8037c4,(%esp)
  8003da:	e8 ee 02 00 00       	call   8006cd <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8003df:	cc                   	int3   

	breakpoint();
}
  8003e0:	83 c4 3c             	add    $0x3c,%esp
  8003e3:	5b                   	pop    %ebx
  8003e4:	5e                   	pop    %esi
  8003e5:	5f                   	pop    %edi
  8003e6:	5d                   	pop    %ebp
  8003e7:	c3                   	ret    
	...

008003f0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8003f0:	55                   	push   %ebp
  8003f1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8003f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003f8:	5d                   	pop    %ebp
  8003f9:	c3                   	ret    

008003fa <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
  8003fd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800400:	c7 44 24 04 d9 37 80 	movl   $0x8037d9,0x4(%esp)
  800407:	00 
  800408:	8b 45 0c             	mov    0xc(%ebp),%eax
  80040b:	89 04 24             	mov    %eax,(%esp)
  80040e:	e8 97 09 00 00       	call   800daa <strcpy>
	return 0;
}
  800413:	b8 00 00 00 00       	mov    $0x0,%eax
  800418:	c9                   	leave  
  800419:	c3                   	ret    

0080041a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80041a:	55                   	push   %ebp
  80041b:	89 e5                	mov    %esp,%ebp
  80041d:	57                   	push   %edi
  80041e:	56                   	push   %esi
  80041f:	53                   	push   %ebx
  800420:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800426:	b8 00 00 00 00       	mov    $0x0,%eax
  80042b:	be 00 00 00 00       	mov    $0x0,%esi
  800430:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800434:	74 3f                	je     800475 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800436:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80043c:	8b 55 10             	mov    0x10(%ebp),%edx
  80043f:	29 c2                	sub    %eax,%edx
  800441:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  800443:	83 fa 7f             	cmp    $0x7f,%edx
  800446:	76 05                	jbe    80044d <devcons_write+0x33>
  800448:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80044d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800451:	03 45 0c             	add    0xc(%ebp),%eax
  800454:	89 44 24 04          	mov    %eax,0x4(%esp)
  800458:	89 3c 24             	mov    %edi,(%esp)
  80045b:	e8 05 0b 00 00       	call   800f65 <memmove>
		sys_cputs(buf, m);
  800460:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800464:	89 3c 24             	mov    %edi,(%esp)
  800467:	e8 34 0d 00 00       	call   8011a0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80046c:	01 de                	add    %ebx,%esi
  80046e:	89 f0                	mov    %esi,%eax
  800470:	3b 75 10             	cmp    0x10(%ebp),%esi
  800473:	72 c7                	jb     80043c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  800475:	89 f0                	mov    %esi,%eax
  800477:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80047d:	5b                   	pop    %ebx
  80047e:	5e                   	pop    %esi
  80047f:	5f                   	pop    %edi
  800480:	5d                   	pop    %ebp
  800481:	c3                   	ret    

00800482 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  800482:	55                   	push   %ebp
  800483:	89 e5                	mov    %esp,%ebp
  800485:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  800488:	8b 45 08             	mov    0x8(%ebp),%eax
  80048b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80048e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800495:	00 
  800496:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800499:	89 04 24             	mov    %eax,(%esp)
  80049c:	e8 ff 0c 00 00       	call   8011a0 <sys_cputs>
}
  8004a1:	c9                   	leave  
  8004a2:	c3                   	ret    

008004a3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8004a3:	55                   	push   %ebp
  8004a4:	89 e5                	mov    %esp,%ebp
  8004a6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8004a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8004ad:	75 07                	jne    8004b6 <devcons_read+0x13>
  8004af:	eb 28                	jmp    8004d9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8004b1:	e8 af 10 00 00       	call   801565 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8004b6:	66 90                	xchg   %ax,%ax
  8004b8:	e8 af 0c 00 00       	call   80116c <sys_cgetc>
  8004bd:	85 c0                	test   %eax,%eax
  8004bf:	90                   	nop
  8004c0:	74 ef                	je     8004b1 <devcons_read+0xe>
  8004c2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8004c4:	85 c0                	test   %eax,%eax
  8004c6:	78 16                	js     8004de <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8004c8:	83 f8 04             	cmp    $0x4,%eax
  8004cb:	74 0c                	je     8004d9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8004cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d0:	88 10                	mov    %dl,(%eax)
  8004d2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8004d7:	eb 05                	jmp    8004de <devcons_read+0x3b>
  8004d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004de:	c9                   	leave  
  8004df:	c3                   	ret    

008004e0 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  8004e0:	55                   	push   %ebp
  8004e1:	89 e5                	mov    %esp,%ebp
  8004e3:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  8004e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8004e9:	89 04 24             	mov    %eax,(%esp)
  8004ec:	e8 fa 14 00 00       	call   8019eb <fd_alloc>
  8004f1:	85 c0                	test   %eax,%eax
  8004f3:	78 3f                	js     800534 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8004f5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8004fc:	00 
  8004fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800500:	89 44 24 04          	mov    %eax,0x4(%esp)
  800504:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80050b:	e8 f6 0f 00 00       	call   801506 <sys_page_alloc>
  800510:	85 c0                	test   %eax,%eax
  800512:	78 20                	js     800534 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800514:	8b 15 00 70 80 00    	mov    0x807000,%edx
  80051a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80051d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80051f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800522:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052c:	89 04 24             	mov    %eax,(%esp)
  80052f:	e8 8c 14 00 00       	call   8019c0 <fd2num>
}
  800534:	c9                   	leave  
  800535:	c3                   	ret    

00800536 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80053c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80053f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	89 04 24             	mov    %eax,(%esp)
  800549:	e8 0f 15 00 00       	call   801a5d <fd_lookup>
  80054e:	85 c0                	test   %eax,%eax
  800550:	78 11                	js     800563 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800552:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800555:	8b 00                	mov    (%eax),%eax
  800557:	3b 05 00 70 80 00    	cmp    0x807000,%eax
  80055d:	0f 94 c0             	sete   %al
  800560:	0f b6 c0             	movzbl %al,%eax
}
  800563:	c9                   	leave  
  800564:	c3                   	ret    

00800565 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  800565:	55                   	push   %ebp
  800566:	89 e5                	mov    %esp,%ebp
  800568:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80056b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800572:	00 
  800573:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800576:	89 44 24 04          	mov    %eax,0x4(%esp)
  80057a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800581:	e8 38 17 00 00       	call   801cbe <read>
	if (r < 0)
  800586:	85 c0                	test   %eax,%eax
  800588:	78 0f                	js     800599 <getchar+0x34>
		return r;
	if (r < 1)
  80058a:	85 c0                	test   %eax,%eax
  80058c:	7f 07                	jg     800595 <getchar+0x30>
  80058e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800593:	eb 04                	jmp    800599 <getchar+0x34>
		return -E_EOF;
	return c;
  800595:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800599:	c9                   	leave  
  80059a:	c3                   	ret    
	...

0080059c <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80059c:	55                   	push   %ebp
  80059d:	89 e5                	mov    %esp,%ebp
  80059f:	83 ec 18             	sub    $0x18,%esp
  8005a2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8005a5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8005a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  8005ae:	e8 e6 0f 00 00       	call   801599 <sys_getenvid>
  8005b3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005b8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005c0:	a3 74 70 80 00       	mov    %eax,0x807074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005c5:	85 f6                	test   %esi,%esi
  8005c7:	7e 07                	jle    8005d0 <libmain+0x34>
		binaryname = argv[0];
  8005c9:	8b 03                	mov    (%ebx),%eax
  8005cb:	a3 1c 70 80 00       	mov    %eax,0x80701c

	// call user main routine
	umain(argc, argv);
  8005d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8005d4:	89 34 24             	mov    %esi,(%esp)
  8005d7:	e8 23 fb ff ff       	call   8000ff <umain>

	// exit gracefully
	exit();
  8005dc:	e8 0b 00 00 00       	call   8005ec <exit>
}
  8005e1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8005e4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8005e7:	89 ec                	mov    %ebp,%esp
  8005e9:	5d                   	pop    %ebp
  8005ea:	c3                   	ret    
	...

008005ec <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005ec:	55                   	push   %ebp
  8005ed:	89 e5                	mov    %esp,%ebp
  8005ef:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8005f2:	e8 a4 18 00 00       	call   801e9b <close_all>
	sys_env_destroy(0);
  8005f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005fe:	e8 ca 0f 00 00       	call   8015cd <sys_env_destroy>
}
  800603:	c9                   	leave  
  800604:	c3                   	ret    
  800605:	00 00                	add    %al,(%eax)
	...

00800608 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800608:	55                   	push   %ebp
  800609:	89 e5                	mov    %esp,%ebp
  80060b:	53                   	push   %ebx
  80060c:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  80060f:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800612:	a1 78 70 80 00       	mov    0x807078,%eax
  800617:	85 c0                	test   %eax,%eax
  800619:	74 10                	je     80062b <_panic+0x23>
		cprintf("%s: ", argv0);
  80061b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061f:	c7 04 24 fc 37 80 00 	movl   $0x8037fc,(%esp)
  800626:	e8 a2 00 00 00       	call   8006cd <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80062b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800632:	8b 45 08             	mov    0x8(%ebp),%eax
  800635:	89 44 24 08          	mov    %eax,0x8(%esp)
  800639:	a1 1c 70 80 00       	mov    0x80701c,%eax
  80063e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800642:	c7 04 24 01 38 80 00 	movl   $0x803801,(%esp)
  800649:	e8 7f 00 00 00       	call   8006cd <cprintf>
	vcprintf(fmt, ap);
  80064e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800652:	8b 45 10             	mov    0x10(%ebp),%eax
  800655:	89 04 24             	mov    %eax,(%esp)
  800658:	e8 0f 00 00 00       	call   80066c <vcprintf>
	cprintf("\n");
  80065d:	c7 04 24 08 37 80 00 	movl   $0x803708,(%esp)
  800664:	e8 64 00 00 00       	call   8006cd <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800669:	cc                   	int3   
  80066a:	eb fd                	jmp    800669 <_panic+0x61>

0080066c <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  80066c:	55                   	push   %ebp
  80066d:	89 e5                	mov    %esp,%ebp
  80066f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800675:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80067c:	00 00 00 
	b.cnt = 0;
  80067f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800686:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800689:	8b 45 0c             	mov    0xc(%ebp),%eax
  80068c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	89 44 24 08          	mov    %eax,0x8(%esp)
  800697:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80069d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006a1:	c7 04 24 e7 06 80 00 	movl   $0x8006e7,(%esp)
  8006a8:	e8 d0 01 00 00       	call   80087d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006ad:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8006b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006b7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8006bd:	89 04 24             	mov    %eax,(%esp)
  8006c0:	e8 db 0a 00 00       	call   8011a0 <sys_cputs>

	return b.cnt;
}
  8006c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8006cb:	c9                   	leave  
  8006cc:	c3                   	ret    

008006cd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8006cd:	55                   	push   %ebp
  8006ce:	89 e5                	mov    %esp,%ebp
  8006d0:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8006d3:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8006d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006da:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dd:	89 04 24             	mov    %eax,(%esp)
  8006e0:	e8 87 ff ff ff       	call   80066c <vcprintf>
	va_end(ap);

	return cnt;
}
  8006e5:	c9                   	leave  
  8006e6:	c3                   	ret    

008006e7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8006e7:	55                   	push   %ebp
  8006e8:	89 e5                	mov    %esp,%ebp
  8006ea:	53                   	push   %ebx
  8006eb:	83 ec 14             	sub    $0x14,%esp
  8006ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8006f1:	8b 03                	mov    (%ebx),%eax
  8006f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8006f6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8006fa:	83 c0 01             	add    $0x1,%eax
  8006fd:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8006ff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800704:	75 19                	jne    80071f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800706:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80070d:	00 
  80070e:	8d 43 08             	lea    0x8(%ebx),%eax
  800711:	89 04 24             	mov    %eax,(%esp)
  800714:	e8 87 0a 00 00       	call   8011a0 <sys_cputs>
		b->idx = 0;
  800719:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80071f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800723:	83 c4 14             	add    $0x14,%esp
  800726:	5b                   	pop    %ebx
  800727:	5d                   	pop    %ebp
  800728:	c3                   	ret    
  800729:	00 00                	add    %al,(%eax)
  80072b:	00 00                	add    %al,(%eax)
  80072d:	00 00                	add    %al,(%eax)
	...

00800730 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800730:	55                   	push   %ebp
  800731:	89 e5                	mov    %esp,%ebp
  800733:	57                   	push   %edi
  800734:	56                   	push   %esi
  800735:	53                   	push   %ebx
  800736:	83 ec 4c             	sub    $0x4c,%esp
  800739:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80073c:	89 d6                	mov    %edx,%esi
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800744:	8b 55 0c             	mov    0xc(%ebp),%edx
  800747:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80074a:	8b 45 10             	mov    0x10(%ebp),%eax
  80074d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800750:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800753:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800756:	b9 00 00 00 00       	mov    $0x0,%ecx
  80075b:	39 d1                	cmp    %edx,%ecx
  80075d:	72 15                	jb     800774 <printnum+0x44>
  80075f:	77 07                	ja     800768 <printnum+0x38>
  800761:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800764:	39 d0                	cmp    %edx,%eax
  800766:	76 0c                	jbe    800774 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800768:	83 eb 01             	sub    $0x1,%ebx
  80076b:	85 db                	test   %ebx,%ebx
  80076d:	8d 76 00             	lea    0x0(%esi),%esi
  800770:	7f 61                	jg     8007d3 <printnum+0xa3>
  800772:	eb 70                	jmp    8007e4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800774:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800778:	83 eb 01             	sub    $0x1,%ebx
  80077b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80077f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800783:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800787:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80078b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80078e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800791:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800794:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800798:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80079f:	00 
  8007a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007a3:	89 04 24             	mov    %eax,(%esp)
  8007a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007ad:	e8 2e 2c 00 00       	call   8033e0 <__udivdi3>
  8007b2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8007b5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007b8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007bc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8007c0:	89 04 24             	mov    %eax,(%esp)
  8007c3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007c7:	89 f2                	mov    %esi,%edx
  8007c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007cc:	e8 5f ff ff ff       	call   800730 <printnum>
  8007d1:	eb 11                	jmp    8007e4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8007d3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007d7:	89 3c 24             	mov    %edi,(%esp)
  8007da:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007dd:	83 eb 01             	sub    $0x1,%ebx
  8007e0:	85 db                	test   %ebx,%ebx
  8007e2:	7f ef                	jg     8007d3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007e4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007e8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8007ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8007fa:	00 
  8007fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007fe:	89 14 24             	mov    %edx,(%esp)
  800801:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800804:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800808:	e8 03 2d 00 00       	call   803510 <__umoddi3>
  80080d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800811:	0f be 80 1d 38 80 00 	movsbl 0x80381d(%eax),%eax
  800818:	89 04 24             	mov    %eax,(%esp)
  80081b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80081e:	83 c4 4c             	add    $0x4c,%esp
  800821:	5b                   	pop    %ebx
  800822:	5e                   	pop    %esi
  800823:	5f                   	pop    %edi
  800824:	5d                   	pop    %ebp
  800825:	c3                   	ret    

00800826 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800826:	55                   	push   %ebp
  800827:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800829:	83 fa 01             	cmp    $0x1,%edx
  80082c:	7e 0e                	jle    80083c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80082e:	8b 10                	mov    (%eax),%edx
  800830:	8d 4a 08             	lea    0x8(%edx),%ecx
  800833:	89 08                	mov    %ecx,(%eax)
  800835:	8b 02                	mov    (%edx),%eax
  800837:	8b 52 04             	mov    0x4(%edx),%edx
  80083a:	eb 22                	jmp    80085e <getuint+0x38>
	else if (lflag)
  80083c:	85 d2                	test   %edx,%edx
  80083e:	74 10                	je     800850 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800840:	8b 10                	mov    (%eax),%edx
  800842:	8d 4a 04             	lea    0x4(%edx),%ecx
  800845:	89 08                	mov    %ecx,(%eax)
  800847:	8b 02                	mov    (%edx),%eax
  800849:	ba 00 00 00 00       	mov    $0x0,%edx
  80084e:	eb 0e                	jmp    80085e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800850:	8b 10                	mov    (%eax),%edx
  800852:	8d 4a 04             	lea    0x4(%edx),%ecx
  800855:	89 08                	mov    %ecx,(%eax)
  800857:	8b 02                	mov    (%edx),%eax
  800859:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80085e:	5d                   	pop    %ebp
  80085f:	c3                   	ret    

00800860 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800860:	55                   	push   %ebp
  800861:	89 e5                	mov    %esp,%ebp
  800863:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800866:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80086a:	8b 10                	mov    (%eax),%edx
  80086c:	3b 50 04             	cmp    0x4(%eax),%edx
  80086f:	73 0a                	jae    80087b <sprintputch+0x1b>
		*b->buf++ = ch;
  800871:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800874:	88 0a                	mov    %cl,(%edx)
  800876:	83 c2 01             	add    $0x1,%edx
  800879:	89 10                	mov    %edx,(%eax)
}
  80087b:	5d                   	pop    %ebp
  80087c:	c3                   	ret    

0080087d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80087d:	55                   	push   %ebp
  80087e:	89 e5                	mov    %esp,%ebp
  800880:	57                   	push   %edi
  800881:	56                   	push   %esi
  800882:	53                   	push   %ebx
  800883:	83 ec 5c             	sub    $0x5c,%esp
  800886:	8b 7d 08             	mov    0x8(%ebp),%edi
  800889:	8b 75 0c             	mov    0xc(%ebp),%esi
  80088c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80088f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800896:	eb 11                	jmp    8008a9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800898:	85 c0                	test   %eax,%eax
  80089a:	0f 84 09 04 00 00    	je     800ca9 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  8008a0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008a4:	89 04 24             	mov    %eax,(%esp)
  8008a7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008a9:	0f b6 03             	movzbl (%ebx),%eax
  8008ac:	83 c3 01             	add    $0x1,%ebx
  8008af:	83 f8 25             	cmp    $0x25,%eax
  8008b2:	75 e4                	jne    800898 <vprintfmt+0x1b>
  8008b4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8008b8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8008bf:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8008c6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8008cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008d2:	eb 06                	jmp    8008da <vprintfmt+0x5d>
  8008d4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8008d8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008da:	0f b6 13             	movzbl (%ebx),%edx
  8008dd:	0f b6 c2             	movzbl %dl,%eax
  8008e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008e3:	8d 43 01             	lea    0x1(%ebx),%eax
  8008e6:	83 ea 23             	sub    $0x23,%edx
  8008e9:	80 fa 55             	cmp    $0x55,%dl
  8008ec:	0f 87 9a 03 00 00    	ja     800c8c <vprintfmt+0x40f>
  8008f2:	0f b6 d2             	movzbl %dl,%edx
  8008f5:	ff 24 95 60 39 80 00 	jmp    *0x803960(,%edx,4)
  8008fc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800900:	eb d6                	jmp    8008d8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800902:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800905:	83 ea 30             	sub    $0x30,%edx
  800908:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  80090b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80090e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800911:	83 fb 09             	cmp    $0x9,%ebx
  800914:	77 4c                	ja     800962 <vprintfmt+0xe5>
  800916:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800919:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80091c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80091f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800922:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800926:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800929:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80092c:	83 fb 09             	cmp    $0x9,%ebx
  80092f:	76 eb                	jbe    80091c <vprintfmt+0x9f>
  800931:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800934:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800937:	eb 29                	jmp    800962 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800939:	8b 55 14             	mov    0x14(%ebp),%edx
  80093c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80093f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800942:	8b 12                	mov    (%edx),%edx
  800944:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  800947:	eb 19                	jmp    800962 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800949:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80094c:	c1 fa 1f             	sar    $0x1f,%edx
  80094f:	f7 d2                	not    %edx
  800951:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800954:	eb 82                	jmp    8008d8 <vprintfmt+0x5b>
  800956:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80095d:	e9 76 ff ff ff       	jmp    8008d8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800962:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800966:	0f 89 6c ff ff ff    	jns    8008d8 <vprintfmt+0x5b>
  80096c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80096f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800972:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800975:	89 55 cc             	mov    %edx,-0x34(%ebp)
  800978:	e9 5b ff ff ff       	jmp    8008d8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80097d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800980:	e9 53 ff ff ff       	jmp    8008d8 <vprintfmt+0x5b>
  800985:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800988:	8b 45 14             	mov    0x14(%ebp),%eax
  80098b:	8d 50 04             	lea    0x4(%eax),%edx
  80098e:	89 55 14             	mov    %edx,0x14(%ebp)
  800991:	89 74 24 04          	mov    %esi,0x4(%esp)
  800995:	8b 00                	mov    (%eax),%eax
  800997:	89 04 24             	mov    %eax,(%esp)
  80099a:	ff d7                	call   *%edi
  80099c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80099f:	e9 05 ff ff ff       	jmp    8008a9 <vprintfmt+0x2c>
  8009a4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009aa:	8d 50 04             	lea    0x4(%eax),%edx
  8009ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	89 c2                	mov    %eax,%edx
  8009b4:	c1 fa 1f             	sar    $0x1f,%edx
  8009b7:	31 d0                	xor    %edx,%eax
  8009b9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009bb:	83 f8 0f             	cmp    $0xf,%eax
  8009be:	7f 0b                	jg     8009cb <vprintfmt+0x14e>
  8009c0:	8b 14 85 c0 3a 80 00 	mov    0x803ac0(,%eax,4),%edx
  8009c7:	85 d2                	test   %edx,%edx
  8009c9:	75 20                	jne    8009eb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8009cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009cf:	c7 44 24 08 2e 38 80 	movl   $0x80382e,0x8(%esp)
  8009d6:	00 
  8009d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009db:	89 3c 24             	mov    %edi,(%esp)
  8009de:	e8 4e 03 00 00       	call   800d31 <printfmt>
  8009e3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009e6:	e9 be fe ff ff       	jmp    8008a9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009ef:	c7 44 24 08 d3 3c 80 	movl   $0x803cd3,0x8(%esp)
  8009f6:	00 
  8009f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009fb:	89 3c 24             	mov    %edi,(%esp)
  8009fe:	e8 2e 03 00 00       	call   800d31 <printfmt>
  800a03:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a06:	e9 9e fe ff ff       	jmp    8008a9 <vprintfmt+0x2c>
  800a0b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a0e:	89 c3                	mov    %eax,%ebx
  800a10:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a16:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a19:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1c:	8d 50 04             	lea    0x4(%eax),%edx
  800a1f:	89 55 14             	mov    %edx,0x14(%ebp)
  800a22:	8b 00                	mov    (%eax),%eax
  800a24:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800a27:	85 c0                	test   %eax,%eax
  800a29:	75 07                	jne    800a32 <vprintfmt+0x1b5>
  800a2b:	c7 45 c4 37 38 80 00 	movl   $0x803837,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800a32:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  800a36:	7e 06                	jle    800a3e <vprintfmt+0x1c1>
  800a38:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  800a3c:	75 13                	jne    800a51 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a3e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800a41:	0f be 02             	movsbl (%edx),%eax
  800a44:	85 c0                	test   %eax,%eax
  800a46:	0f 85 99 00 00 00    	jne    800ae5 <vprintfmt+0x268>
  800a4c:	e9 86 00 00 00       	jmp    800ad7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a51:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a55:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800a58:	89 0c 24             	mov    %ecx,(%esp)
  800a5b:	e8 1b 03 00 00       	call   800d7b <strnlen>
  800a60:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800a63:	29 c2                	sub    %eax,%edx
  800a65:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800a68:	85 d2                	test   %edx,%edx
  800a6a:	7e d2                	jle    800a3e <vprintfmt+0x1c1>
					putch(padc, putdat);
  800a6c:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  800a70:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a73:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  800a76:	89 d3                	mov    %edx,%ebx
  800a78:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800a7f:	89 04 24             	mov    %eax,(%esp)
  800a82:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a84:	83 eb 01             	sub    $0x1,%ebx
  800a87:	85 db                	test   %ebx,%ebx
  800a89:	7f ed                	jg     800a78 <vprintfmt+0x1fb>
  800a8b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800a8e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800a95:	eb a7                	jmp    800a3e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800a97:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800a9b:	74 18                	je     800ab5 <vprintfmt+0x238>
  800a9d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800aa0:	83 fa 5e             	cmp    $0x5e,%edx
  800aa3:	76 10                	jbe    800ab5 <vprintfmt+0x238>
					putch('?', putdat);
  800aa5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800aa9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800ab0:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800ab3:	eb 0a                	jmp    800abf <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800ab5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ab9:	89 04 24             	mov    %eax,(%esp)
  800abc:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800abf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800ac3:	0f be 03             	movsbl (%ebx),%eax
  800ac6:	85 c0                	test   %eax,%eax
  800ac8:	74 05                	je     800acf <vprintfmt+0x252>
  800aca:	83 c3 01             	add    $0x1,%ebx
  800acd:	eb 29                	jmp    800af8 <vprintfmt+0x27b>
  800acf:	89 fe                	mov    %edi,%esi
  800ad1:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800ad4:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800ad7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800adb:	7f 2e                	jg     800b0b <vprintfmt+0x28e>
  800add:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800ae0:	e9 c4 fd ff ff       	jmp    8008a9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ae5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800ae8:	83 c2 01             	add    $0x1,%edx
  800aeb:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800aee:	89 f7                	mov    %esi,%edi
  800af0:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800af3:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  800af6:	89 d3                	mov    %edx,%ebx
  800af8:	85 f6                	test   %esi,%esi
  800afa:	78 9b                	js     800a97 <vprintfmt+0x21a>
  800afc:	83 ee 01             	sub    $0x1,%esi
  800aff:	79 96                	jns    800a97 <vprintfmt+0x21a>
  800b01:	89 fe                	mov    %edi,%esi
  800b03:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800b06:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800b09:	eb cc                	jmp    800ad7 <vprintfmt+0x25a>
  800b0b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800b0e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800b11:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b15:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800b1c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b1e:	83 eb 01             	sub    $0x1,%ebx
  800b21:	85 db                	test   %ebx,%ebx
  800b23:	7f ec                	jg     800b11 <vprintfmt+0x294>
  800b25:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800b28:	e9 7c fd ff ff       	jmp    8008a9 <vprintfmt+0x2c>
  800b2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800b30:	83 f9 01             	cmp    $0x1,%ecx
  800b33:	7e 16                	jle    800b4b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800b35:	8b 45 14             	mov    0x14(%ebp),%eax
  800b38:	8d 50 08             	lea    0x8(%eax),%edx
  800b3b:	89 55 14             	mov    %edx,0x14(%ebp)
  800b3e:	8b 10                	mov    (%eax),%edx
  800b40:	8b 48 04             	mov    0x4(%eax),%ecx
  800b43:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b46:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800b49:	eb 32                	jmp    800b7d <vprintfmt+0x300>
	else if (lflag)
  800b4b:	85 c9                	test   %ecx,%ecx
  800b4d:	74 18                	je     800b67 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  800b4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b52:	8d 50 04             	lea    0x4(%eax),%edx
  800b55:	89 55 14             	mov    %edx,0x14(%ebp)
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b5d:	89 c1                	mov    %eax,%ecx
  800b5f:	c1 f9 1f             	sar    $0x1f,%ecx
  800b62:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800b65:	eb 16                	jmp    800b7d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800b67:	8b 45 14             	mov    0x14(%ebp),%eax
  800b6a:	8d 50 04             	lea    0x4(%eax),%edx
  800b6d:	89 55 14             	mov    %edx,0x14(%ebp)
  800b70:	8b 00                	mov    (%eax),%eax
  800b72:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	c1 fa 1f             	sar    $0x1f,%edx
  800b7a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b7d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800b80:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800b83:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800b88:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800b8c:	0f 89 b8 00 00 00    	jns    800c4a <vprintfmt+0x3cd>
				putch('-', putdat);
  800b92:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b96:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800b9d:	ff d7                	call   *%edi
				num = -(long long) num;
  800b9f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800ba2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800ba5:	f7 d9                	neg    %ecx
  800ba7:	83 d3 00             	adc    $0x0,%ebx
  800baa:	f7 db                	neg    %ebx
  800bac:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bb1:	e9 94 00 00 00       	jmp    800c4a <vprintfmt+0x3cd>
  800bb6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bb9:	89 ca                	mov    %ecx,%edx
  800bbb:	8d 45 14             	lea    0x14(%ebp),%eax
  800bbe:	e8 63 fc ff ff       	call   800826 <getuint>
  800bc3:	89 c1                	mov    %eax,%ecx
  800bc5:	89 d3                	mov    %edx,%ebx
  800bc7:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800bcc:	eb 7c                	jmp    800c4a <vprintfmt+0x3cd>
  800bce:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800bd1:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bd5:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800bdc:	ff d7                	call   *%edi
			putch('X', putdat);
  800bde:	89 74 24 04          	mov    %esi,0x4(%esp)
  800be2:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800be9:	ff d7                	call   *%edi
			putch('X', putdat);
  800beb:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bef:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800bf6:	ff d7                	call   *%edi
  800bf8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800bfb:	e9 a9 fc ff ff       	jmp    8008a9 <vprintfmt+0x2c>
  800c00:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800c03:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c07:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800c0e:	ff d7                	call   *%edi
			putch('x', putdat);
  800c10:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c14:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800c1b:	ff d7                	call   *%edi
			num = (unsigned long long)
  800c1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c20:	8d 50 04             	lea    0x4(%eax),%edx
  800c23:	89 55 14             	mov    %edx,0x14(%ebp)
  800c26:	8b 08                	mov    (%eax),%ecx
  800c28:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c2d:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800c32:	eb 16                	jmp    800c4a <vprintfmt+0x3cd>
  800c34:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c37:	89 ca                	mov    %ecx,%edx
  800c39:	8d 45 14             	lea    0x14(%ebp),%eax
  800c3c:	e8 e5 fb ff ff       	call   800826 <getuint>
  800c41:	89 c1                	mov    %eax,%ecx
  800c43:	89 d3                	mov    %edx,%ebx
  800c45:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c4a:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  800c4e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800c52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c55:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c59:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c5d:	89 0c 24             	mov    %ecx,(%esp)
  800c60:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c64:	89 f2                	mov    %esi,%edx
  800c66:	89 f8                	mov    %edi,%eax
  800c68:	e8 c3 fa ff ff       	call   800730 <printnum>
  800c6d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800c70:	e9 34 fc ff ff       	jmp    8008a9 <vprintfmt+0x2c>
  800c75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c78:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800c7b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c7f:	89 14 24             	mov    %edx,(%esp)
  800c82:	ff d7                	call   *%edi
  800c84:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800c87:	e9 1d fc ff ff       	jmp    8008a9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c8c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c90:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800c97:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c99:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800c9c:	80 38 25             	cmpb   $0x25,(%eax)
  800c9f:	0f 84 04 fc ff ff    	je     8008a9 <vprintfmt+0x2c>
  800ca5:	89 c3                	mov    %eax,%ebx
  800ca7:	eb f0                	jmp    800c99 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  800ca9:	83 c4 5c             	add    $0x5c,%esp
  800cac:	5b                   	pop    %ebx
  800cad:	5e                   	pop    %esi
  800cae:	5f                   	pop    %edi
  800caf:	5d                   	pop    %ebp
  800cb0:	c3                   	ret    

00800cb1 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	83 ec 28             	sub    $0x28,%esp
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800cbd:	85 c0                	test   %eax,%eax
  800cbf:	74 04                	je     800cc5 <vsnprintf+0x14>
  800cc1:	85 d2                	test   %edx,%edx
  800cc3:	7f 07                	jg     800ccc <vsnprintf+0x1b>
  800cc5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cca:	eb 3b                	jmp    800d07 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ccc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ccf:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800cd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cd6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cdd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ce4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ceb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cee:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cf2:	c7 04 24 60 08 80 00 	movl   $0x800860,(%esp)
  800cf9:	e8 7f fb ff ff       	call   80087d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800cfe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d01:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d04:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800d0f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800d12:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d16:	8b 45 10             	mov    0x10(%ebp),%eax
  800d19:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d20:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	89 04 24             	mov    %eax,(%esp)
  800d2a:	e8 82 ff ff ff       	call   800cb1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d2f:	c9                   	leave  
  800d30:	c3                   	ret    

00800d31 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
  800d34:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800d37:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800d3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d41:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4f:	89 04 24             	mov    %eax,(%esp)
  800d52:	e8 26 fb ff ff       	call   80087d <vprintfmt>
	va_end(ap);
}
  800d57:	c9                   	leave  
  800d58:	c3                   	ret    
  800d59:	00 00                	add    %al,(%eax)
  800d5b:	00 00                	add    %al,(%eax)
  800d5d:	00 00                	add    %al,(%eax)
	...

00800d60 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800d60:	55                   	push   %ebp
  800d61:	89 e5                	mov    %esp,%ebp
  800d63:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800d66:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6b:	80 3a 00             	cmpb   $0x0,(%edx)
  800d6e:	74 09                	je     800d79 <strlen+0x19>
		n++;
  800d70:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d77:	75 f7                	jne    800d70 <strlen+0x10>
		n++;
	return n;
}
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    

00800d7b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	53                   	push   %ebx
  800d7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800d82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d85:	85 c9                	test   %ecx,%ecx
  800d87:	74 19                	je     800da2 <strnlen+0x27>
  800d89:	80 3b 00             	cmpb   $0x0,(%ebx)
  800d8c:	74 14                	je     800da2 <strnlen+0x27>
  800d8e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800d93:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d96:	39 c8                	cmp    %ecx,%eax
  800d98:	74 0d                	je     800da7 <strnlen+0x2c>
  800d9a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800d9e:	75 f3                	jne    800d93 <strnlen+0x18>
  800da0:	eb 05                	jmp    800da7 <strnlen+0x2c>
  800da2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800da7:	5b                   	pop    %ebx
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	53                   	push   %ebx
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800db4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800db9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800dbd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800dc0:	83 c2 01             	add    $0x1,%edx
  800dc3:	84 c9                	test   %cl,%cl
  800dc5:	75 f2                	jne    800db9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800dc7:	5b                   	pop    %ebx
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    

00800dca <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
  800dcd:	56                   	push   %esi
  800dce:	53                   	push   %ebx
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dd8:	85 f6                	test   %esi,%esi
  800dda:	74 18                	je     800df4 <strncpy+0x2a>
  800ddc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800de1:	0f b6 1a             	movzbl (%edx),%ebx
  800de4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800de7:	80 3a 01             	cmpb   $0x1,(%edx)
  800dea:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ded:	83 c1 01             	add    $0x1,%ecx
  800df0:	39 ce                	cmp    %ecx,%esi
  800df2:	77 ed                	ja     800de1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800df4:	5b                   	pop    %ebx
  800df5:	5e                   	pop    %esi
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	56                   	push   %esi
  800dfc:	53                   	push   %ebx
  800dfd:	8b 75 08             	mov    0x8(%ebp),%esi
  800e00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e03:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e06:	89 f0                	mov    %esi,%eax
  800e08:	85 c9                	test   %ecx,%ecx
  800e0a:	74 27                	je     800e33 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800e0c:	83 e9 01             	sub    $0x1,%ecx
  800e0f:	74 1d                	je     800e2e <strlcpy+0x36>
  800e11:	0f b6 1a             	movzbl (%edx),%ebx
  800e14:	84 db                	test   %bl,%bl
  800e16:	74 16                	je     800e2e <strlcpy+0x36>
			*dst++ = *src++;
  800e18:	88 18                	mov    %bl,(%eax)
  800e1a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e1d:	83 e9 01             	sub    $0x1,%ecx
  800e20:	74 0e                	je     800e30 <strlcpy+0x38>
			*dst++ = *src++;
  800e22:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e25:	0f b6 1a             	movzbl (%edx),%ebx
  800e28:	84 db                	test   %bl,%bl
  800e2a:	75 ec                	jne    800e18 <strlcpy+0x20>
  800e2c:	eb 02                	jmp    800e30 <strlcpy+0x38>
  800e2e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800e30:	c6 00 00             	movb   $0x0,(%eax)
  800e33:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800e35:	5b                   	pop    %ebx
  800e36:	5e                   	pop    %esi
  800e37:	5d                   	pop    %ebp
  800e38:	c3                   	ret    

00800e39 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e3f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e42:	0f b6 01             	movzbl (%ecx),%eax
  800e45:	84 c0                	test   %al,%al
  800e47:	74 15                	je     800e5e <strcmp+0x25>
  800e49:	3a 02                	cmp    (%edx),%al
  800e4b:	75 11                	jne    800e5e <strcmp+0x25>
		p++, q++;
  800e4d:	83 c1 01             	add    $0x1,%ecx
  800e50:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e53:	0f b6 01             	movzbl (%ecx),%eax
  800e56:	84 c0                	test   %al,%al
  800e58:	74 04                	je     800e5e <strcmp+0x25>
  800e5a:	3a 02                	cmp    (%edx),%al
  800e5c:	74 ef                	je     800e4d <strcmp+0x14>
  800e5e:	0f b6 c0             	movzbl %al,%eax
  800e61:	0f b6 12             	movzbl (%edx),%edx
  800e64:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800e66:	5d                   	pop    %ebp
  800e67:	c3                   	ret    

00800e68 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
  800e6b:	53                   	push   %ebx
  800e6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e72:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800e75:	85 c0                	test   %eax,%eax
  800e77:	74 23                	je     800e9c <strncmp+0x34>
  800e79:	0f b6 1a             	movzbl (%edx),%ebx
  800e7c:	84 db                	test   %bl,%bl
  800e7e:	74 24                	je     800ea4 <strncmp+0x3c>
  800e80:	3a 19                	cmp    (%ecx),%bl
  800e82:	75 20                	jne    800ea4 <strncmp+0x3c>
  800e84:	83 e8 01             	sub    $0x1,%eax
  800e87:	74 13                	je     800e9c <strncmp+0x34>
		n--, p++, q++;
  800e89:	83 c2 01             	add    $0x1,%edx
  800e8c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800e8f:	0f b6 1a             	movzbl (%edx),%ebx
  800e92:	84 db                	test   %bl,%bl
  800e94:	74 0e                	je     800ea4 <strncmp+0x3c>
  800e96:	3a 19                	cmp    (%ecx),%bl
  800e98:	74 ea                	je     800e84 <strncmp+0x1c>
  800e9a:	eb 08                	jmp    800ea4 <strncmp+0x3c>
  800e9c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ea1:	5b                   	pop    %ebx
  800ea2:	5d                   	pop    %ebp
  800ea3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ea4:	0f b6 02             	movzbl (%edx),%eax
  800ea7:	0f b6 11             	movzbl (%ecx),%edx
  800eaa:	29 d0                	sub    %edx,%eax
  800eac:	eb f3                	jmp    800ea1 <strncmp+0x39>

00800eae <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800eb8:	0f b6 10             	movzbl (%eax),%edx
  800ebb:	84 d2                	test   %dl,%dl
  800ebd:	74 15                	je     800ed4 <strchr+0x26>
		if (*s == c)
  800ebf:	38 ca                	cmp    %cl,%dl
  800ec1:	75 07                	jne    800eca <strchr+0x1c>
  800ec3:	eb 14                	jmp    800ed9 <strchr+0x2b>
  800ec5:	38 ca                	cmp    %cl,%dl
  800ec7:	90                   	nop
  800ec8:	74 0f                	je     800ed9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800eca:	83 c0 01             	add    $0x1,%eax
  800ecd:	0f b6 10             	movzbl (%eax),%edx
  800ed0:	84 d2                	test   %dl,%dl
  800ed2:	75 f1                	jne    800ec5 <strchr+0x17>
  800ed4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800ed9:	5d                   	pop    %ebp
  800eda:	c3                   	ret    

00800edb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ee5:	0f b6 10             	movzbl (%eax),%edx
  800ee8:	84 d2                	test   %dl,%dl
  800eea:	74 18                	je     800f04 <strfind+0x29>
		if (*s == c)
  800eec:	38 ca                	cmp    %cl,%dl
  800eee:	75 0a                	jne    800efa <strfind+0x1f>
  800ef0:	eb 12                	jmp    800f04 <strfind+0x29>
  800ef2:	38 ca                	cmp    %cl,%dl
  800ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800ef8:	74 0a                	je     800f04 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800efa:	83 c0 01             	add    $0x1,%eax
  800efd:	0f b6 10             	movzbl (%eax),%edx
  800f00:	84 d2                	test   %dl,%dl
  800f02:	75 ee                	jne    800ef2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800f04:	5d                   	pop    %ebp
  800f05:	c3                   	ret    

00800f06 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f06:	55                   	push   %ebp
  800f07:	89 e5                	mov    %esp,%ebp
  800f09:	83 ec 0c             	sub    $0xc,%esp
  800f0c:	89 1c 24             	mov    %ebx,(%esp)
  800f0f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f13:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f17:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f20:	85 c9                	test   %ecx,%ecx
  800f22:	74 30                	je     800f54 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f24:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800f2a:	75 25                	jne    800f51 <memset+0x4b>
  800f2c:	f6 c1 03             	test   $0x3,%cl
  800f2f:	75 20                	jne    800f51 <memset+0x4b>
		c &= 0xFF;
  800f31:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f34:	89 d3                	mov    %edx,%ebx
  800f36:	c1 e3 08             	shl    $0x8,%ebx
  800f39:	89 d6                	mov    %edx,%esi
  800f3b:	c1 e6 18             	shl    $0x18,%esi
  800f3e:	89 d0                	mov    %edx,%eax
  800f40:	c1 e0 10             	shl    $0x10,%eax
  800f43:	09 f0                	or     %esi,%eax
  800f45:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800f47:	09 d8                	or     %ebx,%eax
  800f49:	c1 e9 02             	shr    $0x2,%ecx
  800f4c:	fc                   	cld    
  800f4d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f4f:	eb 03                	jmp    800f54 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f51:	fc                   	cld    
  800f52:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f54:	89 f8                	mov    %edi,%eax
  800f56:	8b 1c 24             	mov    (%esp),%ebx
  800f59:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f5d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f61:	89 ec                	mov    %ebp,%esp
  800f63:	5d                   	pop    %ebp
  800f64:	c3                   	ret    

00800f65 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f65:	55                   	push   %ebp
  800f66:	89 e5                	mov    %esp,%ebp
  800f68:	83 ec 08             	sub    $0x8,%esp
  800f6b:	89 34 24             	mov    %esi,(%esp)
  800f6e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800f72:	8b 45 08             	mov    0x8(%ebp),%eax
  800f75:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800f78:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800f7b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800f7d:	39 c6                	cmp    %eax,%esi
  800f7f:	73 35                	jae    800fb6 <memmove+0x51>
  800f81:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f84:	39 d0                	cmp    %edx,%eax
  800f86:	73 2e                	jae    800fb6 <memmove+0x51>
		s += n;
		d += n;
  800f88:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f8a:	f6 c2 03             	test   $0x3,%dl
  800f8d:	75 1b                	jne    800faa <memmove+0x45>
  800f8f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800f95:	75 13                	jne    800faa <memmove+0x45>
  800f97:	f6 c1 03             	test   $0x3,%cl
  800f9a:	75 0e                	jne    800faa <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800f9c:	83 ef 04             	sub    $0x4,%edi
  800f9f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800fa2:	c1 e9 02             	shr    $0x2,%ecx
  800fa5:	fd                   	std    
  800fa6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fa8:	eb 09                	jmp    800fb3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800faa:	83 ef 01             	sub    $0x1,%edi
  800fad:	8d 72 ff             	lea    -0x1(%edx),%esi
  800fb0:	fd                   	std    
  800fb1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800fb3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fb4:	eb 20                	jmp    800fd6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fb6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800fbc:	75 15                	jne    800fd3 <memmove+0x6e>
  800fbe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800fc4:	75 0d                	jne    800fd3 <memmove+0x6e>
  800fc6:	f6 c1 03             	test   $0x3,%cl
  800fc9:	75 08                	jne    800fd3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800fcb:	c1 e9 02             	shr    $0x2,%ecx
  800fce:	fc                   	cld    
  800fcf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fd1:	eb 03                	jmp    800fd6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800fd3:	fc                   	cld    
  800fd4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800fd6:	8b 34 24             	mov    (%esp),%esi
  800fd9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800fdd:	89 ec                	mov    %ebp,%esp
  800fdf:	5d                   	pop    %ebp
  800fe0:	c3                   	ret    

00800fe1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fea:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	89 04 24             	mov    %eax,(%esp)
  800ffb:	e8 65 ff ff ff       	call   800f65 <memmove>
}
  801000:	c9                   	leave  
  801001:	c3                   	ret    

00801002 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801002:	55                   	push   %ebp
  801003:	89 e5                	mov    %esp,%ebp
  801005:	57                   	push   %edi
  801006:	56                   	push   %esi
  801007:	53                   	push   %ebx
  801008:	8b 75 08             	mov    0x8(%ebp),%esi
  80100b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80100e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801011:	85 c9                	test   %ecx,%ecx
  801013:	74 36                	je     80104b <memcmp+0x49>
		if (*s1 != *s2)
  801015:	0f b6 06             	movzbl (%esi),%eax
  801018:	0f b6 1f             	movzbl (%edi),%ebx
  80101b:	38 d8                	cmp    %bl,%al
  80101d:	74 20                	je     80103f <memcmp+0x3d>
  80101f:	eb 14                	jmp    801035 <memcmp+0x33>
  801021:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  801026:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  80102b:	83 c2 01             	add    $0x1,%edx
  80102e:	83 e9 01             	sub    $0x1,%ecx
  801031:	38 d8                	cmp    %bl,%al
  801033:	74 12                	je     801047 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  801035:	0f b6 c0             	movzbl %al,%eax
  801038:	0f b6 db             	movzbl %bl,%ebx
  80103b:	29 d8                	sub    %ebx,%eax
  80103d:	eb 11                	jmp    801050 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80103f:	83 e9 01             	sub    $0x1,%ecx
  801042:	ba 00 00 00 00       	mov    $0x0,%edx
  801047:	85 c9                	test   %ecx,%ecx
  801049:	75 d6                	jne    801021 <memcmp+0x1f>
  80104b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  801050:	5b                   	pop    %ebx
  801051:	5e                   	pop    %esi
  801052:	5f                   	pop    %edi
  801053:	5d                   	pop    %ebp
  801054:	c3                   	ret    

00801055 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801055:	55                   	push   %ebp
  801056:	89 e5                	mov    %esp,%ebp
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80105b:	89 c2                	mov    %eax,%edx
  80105d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801060:	39 d0                	cmp    %edx,%eax
  801062:	73 15                	jae    801079 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  801064:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  801068:	38 08                	cmp    %cl,(%eax)
  80106a:	75 06                	jne    801072 <memfind+0x1d>
  80106c:	eb 0b                	jmp    801079 <memfind+0x24>
  80106e:	38 08                	cmp    %cl,(%eax)
  801070:	74 07                	je     801079 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801072:	83 c0 01             	add    $0x1,%eax
  801075:	39 c2                	cmp    %eax,%edx
  801077:	77 f5                	ja     80106e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  801079:	5d                   	pop    %ebp
  80107a:	c3                   	ret    

0080107b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	57                   	push   %edi
  80107f:	56                   	push   %esi
  801080:	53                   	push   %ebx
  801081:	83 ec 04             	sub    $0x4,%esp
  801084:	8b 55 08             	mov    0x8(%ebp),%edx
  801087:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80108a:	0f b6 02             	movzbl (%edx),%eax
  80108d:	3c 20                	cmp    $0x20,%al
  80108f:	74 04                	je     801095 <strtol+0x1a>
  801091:	3c 09                	cmp    $0x9,%al
  801093:	75 0e                	jne    8010a3 <strtol+0x28>
		s++;
  801095:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801098:	0f b6 02             	movzbl (%edx),%eax
  80109b:	3c 20                	cmp    $0x20,%al
  80109d:	74 f6                	je     801095 <strtol+0x1a>
  80109f:	3c 09                	cmp    $0x9,%al
  8010a1:	74 f2                	je     801095 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010a3:	3c 2b                	cmp    $0x2b,%al
  8010a5:	75 0c                	jne    8010b3 <strtol+0x38>
		s++;
  8010a7:	83 c2 01             	add    $0x1,%edx
  8010aa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010b1:	eb 15                	jmp    8010c8 <strtol+0x4d>
	else if (*s == '-')
  8010b3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010ba:	3c 2d                	cmp    $0x2d,%al
  8010bc:	75 0a                	jne    8010c8 <strtol+0x4d>
		s++, neg = 1;
  8010be:	83 c2 01             	add    $0x1,%edx
  8010c1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010c8:	85 db                	test   %ebx,%ebx
  8010ca:	0f 94 c0             	sete   %al
  8010cd:	74 05                	je     8010d4 <strtol+0x59>
  8010cf:	83 fb 10             	cmp    $0x10,%ebx
  8010d2:	75 18                	jne    8010ec <strtol+0x71>
  8010d4:	80 3a 30             	cmpb   $0x30,(%edx)
  8010d7:	75 13                	jne    8010ec <strtol+0x71>
  8010d9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8010dd:	8d 76 00             	lea    0x0(%esi),%esi
  8010e0:	75 0a                	jne    8010ec <strtol+0x71>
		s += 2, base = 16;
  8010e2:	83 c2 02             	add    $0x2,%edx
  8010e5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ea:	eb 15                	jmp    801101 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8010ec:	84 c0                	test   %al,%al
  8010ee:	66 90                	xchg   %ax,%ax
  8010f0:	74 0f                	je     801101 <strtol+0x86>
  8010f2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  8010f7:	80 3a 30             	cmpb   $0x30,(%edx)
  8010fa:	75 05                	jne    801101 <strtol+0x86>
		s++, base = 8;
  8010fc:	83 c2 01             	add    $0x1,%edx
  8010ff:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801101:	b8 00 00 00 00       	mov    $0x0,%eax
  801106:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801108:	0f b6 0a             	movzbl (%edx),%ecx
  80110b:	89 cf                	mov    %ecx,%edi
  80110d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  801110:	80 fb 09             	cmp    $0x9,%bl
  801113:	77 08                	ja     80111d <strtol+0xa2>
			dig = *s - '0';
  801115:	0f be c9             	movsbl %cl,%ecx
  801118:	83 e9 30             	sub    $0x30,%ecx
  80111b:	eb 1e                	jmp    80113b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  80111d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  801120:	80 fb 19             	cmp    $0x19,%bl
  801123:	77 08                	ja     80112d <strtol+0xb2>
			dig = *s - 'a' + 10;
  801125:	0f be c9             	movsbl %cl,%ecx
  801128:	83 e9 57             	sub    $0x57,%ecx
  80112b:	eb 0e                	jmp    80113b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  80112d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  801130:	80 fb 19             	cmp    $0x19,%bl
  801133:	77 15                	ja     80114a <strtol+0xcf>
			dig = *s - 'A' + 10;
  801135:	0f be c9             	movsbl %cl,%ecx
  801138:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80113b:	39 f1                	cmp    %esi,%ecx
  80113d:	7d 0b                	jge    80114a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  80113f:	83 c2 01             	add    $0x1,%edx
  801142:	0f af c6             	imul   %esi,%eax
  801145:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  801148:	eb be                	jmp    801108 <strtol+0x8d>
  80114a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80114c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801150:	74 05                	je     801157 <strtol+0xdc>
		*endptr = (char *) s;
  801152:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801155:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801157:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80115b:	74 04                	je     801161 <strtol+0xe6>
  80115d:	89 c8                	mov    %ecx,%eax
  80115f:	f7 d8                	neg    %eax
}
  801161:	83 c4 04             	add    $0x4,%esp
  801164:	5b                   	pop    %ebx
  801165:	5e                   	pop    %esi
  801166:	5f                   	pop    %edi
  801167:	5d                   	pop    %ebp
  801168:	c3                   	ret    
  801169:	00 00                	add    %al,(%eax)
	...

0080116c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 0c             	sub    $0xc,%esp
  801172:	89 1c 24             	mov    %ebx,(%esp)
  801175:	89 74 24 04          	mov    %esi,0x4(%esp)
  801179:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80117d:	ba 00 00 00 00       	mov    $0x0,%edx
  801182:	b8 01 00 00 00       	mov    $0x1,%eax
  801187:	89 d1                	mov    %edx,%ecx
  801189:	89 d3                	mov    %edx,%ebx
  80118b:	89 d7                	mov    %edx,%edi
  80118d:	89 d6                	mov    %edx,%esi
  80118f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801191:	8b 1c 24             	mov    (%esp),%ebx
  801194:	8b 74 24 04          	mov    0x4(%esp),%esi
  801198:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80119c:	89 ec                	mov    %ebp,%esp
  80119e:	5d                   	pop    %ebp
  80119f:	c3                   	ret    

008011a0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8011a0:	55                   	push   %ebp
  8011a1:	89 e5                	mov    %esp,%ebp
  8011a3:	83 ec 0c             	sub    $0xc,%esp
  8011a6:	89 1c 24             	mov    %ebx,(%esp)
  8011a9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011ad:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011b1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011bc:	89 c3                	mov    %eax,%ebx
  8011be:	89 c7                	mov    %eax,%edi
  8011c0:	89 c6                	mov    %eax,%esi
  8011c2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8011c4:	8b 1c 24             	mov    (%esp),%ebx
  8011c7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011cb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011cf:	89 ec                	mov    %ebp,%esp
  8011d1:	5d                   	pop    %ebp
  8011d2:	c3                   	ret    

008011d3 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 0c             	sub    $0xc,%esp
  8011d9:	89 1c 24             	mov    %ebx,(%esp)
  8011dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011e0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011e4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e9:	b8 10 00 00 00       	mov    $0x10,%eax
  8011ee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f4:	89 df                	mov    %ebx,%edi
  8011f6:	89 de                	mov    %ebx,%esi
  8011f8:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  8011fa:	8b 1c 24             	mov    (%esp),%ebx
  8011fd:	8b 74 24 04          	mov    0x4(%esp),%esi
  801201:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801205:	89 ec                	mov    %ebp,%esp
  801207:	5d                   	pop    %ebp
  801208:	c3                   	ret    

00801209 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 38             	sub    $0x38,%esp
  80120f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801212:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801215:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801218:	bb 00 00 00 00       	mov    $0x0,%ebx
  80121d:	b8 0f 00 00 00       	mov    $0xf,%eax
  801222:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801225:	8b 55 08             	mov    0x8(%ebp),%edx
  801228:	89 df                	mov    %ebx,%edi
  80122a:	89 de                	mov    %ebx,%esi
  80122c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80122e:	85 c0                	test   %eax,%eax
  801230:	7e 28                	jle    80125a <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801232:	89 44 24 10          	mov    %eax,0x10(%esp)
  801236:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80123d:	00 
  80123e:	c7 44 24 08 1f 3b 80 	movl   $0x803b1f,0x8(%esp)
  801245:	00 
  801246:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80124d:	00 
  80124e:	c7 04 24 3c 3b 80 00 	movl   $0x803b3c,(%esp)
  801255:	e8 ae f3 ff ff       	call   800608 <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  80125a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80125d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801260:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801263:	89 ec                	mov    %ebp,%esp
  801265:	5d                   	pop    %ebp
  801266:	c3                   	ret    

00801267 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  801267:	55                   	push   %ebp
  801268:	89 e5                	mov    %esp,%ebp
  80126a:	83 ec 0c             	sub    $0xc,%esp
  80126d:	89 1c 24             	mov    %ebx,(%esp)
  801270:	89 74 24 04          	mov    %esi,0x4(%esp)
  801274:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801278:	ba 00 00 00 00       	mov    $0x0,%edx
  80127d:	b8 0e 00 00 00       	mov    $0xe,%eax
  801282:	89 d1                	mov    %edx,%ecx
  801284:	89 d3                	mov    %edx,%ebx
  801286:	89 d7                	mov    %edx,%edi
  801288:	89 d6                	mov    %edx,%esi
  80128a:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80128c:	8b 1c 24             	mov    (%esp),%ebx
  80128f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801293:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801297:	89 ec                	mov    %ebp,%esp
  801299:	5d                   	pop    %ebp
  80129a:	c3                   	ret    

0080129b <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  80129b:	55                   	push   %ebp
  80129c:	89 e5                	mov    %esp,%ebp
  80129e:	83 ec 38             	sub    $0x38,%esp
  8012a1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012a4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012a7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012af:	b8 0d 00 00 00       	mov    $0xd,%eax
  8012b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b7:	89 cb                	mov    %ecx,%ebx
  8012b9:	89 cf                	mov    %ecx,%edi
  8012bb:	89 ce                	mov    %ecx,%esi
  8012bd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	7e 28                	jle    8012eb <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012c3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012c7:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8012ce:	00 
  8012cf:	c7 44 24 08 1f 3b 80 	movl   $0x803b1f,0x8(%esp)
  8012d6:	00 
  8012d7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012de:	00 
  8012df:	c7 04 24 3c 3b 80 00 	movl   $0x803b3c,(%esp)
  8012e6:	e8 1d f3 ff ff       	call   800608 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8012eb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012ee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012f1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012f4:	89 ec                	mov    %ebp,%esp
  8012f6:	5d                   	pop    %ebp
  8012f7:	c3                   	ret    

008012f8 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012f8:	55                   	push   %ebp
  8012f9:	89 e5                	mov    %esp,%ebp
  8012fb:	83 ec 0c             	sub    $0xc,%esp
  8012fe:	89 1c 24             	mov    %ebx,(%esp)
  801301:	89 74 24 04          	mov    %esi,0x4(%esp)
  801305:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801309:	be 00 00 00 00       	mov    $0x0,%esi
  80130e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801313:	8b 7d 14             	mov    0x14(%ebp),%edi
  801316:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801319:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80131c:	8b 55 08             	mov    0x8(%ebp),%edx
  80131f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801321:	8b 1c 24             	mov    (%esp),%ebx
  801324:	8b 74 24 04          	mov    0x4(%esp),%esi
  801328:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80132c:	89 ec                	mov    %ebp,%esp
  80132e:	5d                   	pop    %ebp
  80132f:	c3                   	ret    

00801330 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801330:	55                   	push   %ebp
  801331:	89 e5                	mov    %esp,%ebp
  801333:	83 ec 38             	sub    $0x38,%esp
  801336:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801339:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80133c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80133f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801344:	b8 0a 00 00 00       	mov    $0xa,%eax
  801349:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80134c:	8b 55 08             	mov    0x8(%ebp),%edx
  80134f:	89 df                	mov    %ebx,%edi
  801351:	89 de                	mov    %ebx,%esi
  801353:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801355:	85 c0                	test   %eax,%eax
  801357:	7e 28                	jle    801381 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801359:	89 44 24 10          	mov    %eax,0x10(%esp)
  80135d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801364:	00 
  801365:	c7 44 24 08 1f 3b 80 	movl   $0x803b1f,0x8(%esp)
  80136c:	00 
  80136d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801374:	00 
  801375:	c7 04 24 3c 3b 80 00 	movl   $0x803b3c,(%esp)
  80137c:	e8 87 f2 ff ff       	call   800608 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801381:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801384:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801387:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80138a:	89 ec                	mov    %ebp,%esp
  80138c:	5d                   	pop    %ebp
  80138d:	c3                   	ret    

0080138e <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	83 ec 38             	sub    $0x38,%esp
  801394:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801397:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80139a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80139d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013a2:	b8 09 00 00 00       	mov    $0x9,%eax
  8013a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ad:	89 df                	mov    %ebx,%edi
  8013af:	89 de                	mov    %ebx,%esi
  8013b1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	7e 28                	jle    8013df <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013b7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013bb:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8013c2:	00 
  8013c3:	c7 44 24 08 1f 3b 80 	movl   $0x803b1f,0x8(%esp)
  8013ca:	00 
  8013cb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013d2:	00 
  8013d3:	c7 04 24 3c 3b 80 00 	movl   $0x803b3c,(%esp)
  8013da:	e8 29 f2 ff ff       	call   800608 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8013df:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013e2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013e5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013e8:	89 ec                	mov    %ebp,%esp
  8013ea:	5d                   	pop    %ebp
  8013eb:	c3                   	ret    

008013ec <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8013ec:	55                   	push   %ebp
  8013ed:	89 e5                	mov    %esp,%ebp
  8013ef:	83 ec 38             	sub    $0x38,%esp
  8013f2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013f5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013f8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801400:	b8 08 00 00 00       	mov    $0x8,%eax
  801405:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801408:	8b 55 08             	mov    0x8(%ebp),%edx
  80140b:	89 df                	mov    %ebx,%edi
  80140d:	89 de                	mov    %ebx,%esi
  80140f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801411:	85 c0                	test   %eax,%eax
  801413:	7e 28                	jle    80143d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801415:	89 44 24 10          	mov    %eax,0x10(%esp)
  801419:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801420:	00 
  801421:	c7 44 24 08 1f 3b 80 	movl   $0x803b1f,0x8(%esp)
  801428:	00 
  801429:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801430:	00 
  801431:	c7 04 24 3c 3b 80 00 	movl   $0x803b3c,(%esp)
  801438:	e8 cb f1 ff ff       	call   800608 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80143d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801440:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801443:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801446:	89 ec                	mov    %ebp,%esp
  801448:	5d                   	pop    %ebp
  801449:	c3                   	ret    

0080144a <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
  80144d:	83 ec 38             	sub    $0x38,%esp
  801450:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801453:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801456:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801459:	bb 00 00 00 00       	mov    $0x0,%ebx
  80145e:	b8 06 00 00 00       	mov    $0x6,%eax
  801463:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801466:	8b 55 08             	mov    0x8(%ebp),%edx
  801469:	89 df                	mov    %ebx,%edi
  80146b:	89 de                	mov    %ebx,%esi
  80146d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80146f:	85 c0                	test   %eax,%eax
  801471:	7e 28                	jle    80149b <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801473:	89 44 24 10          	mov    %eax,0x10(%esp)
  801477:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80147e:	00 
  80147f:	c7 44 24 08 1f 3b 80 	movl   $0x803b1f,0x8(%esp)
  801486:	00 
  801487:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80148e:	00 
  80148f:	c7 04 24 3c 3b 80 00 	movl   $0x803b3c,(%esp)
  801496:	e8 6d f1 ff ff       	call   800608 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80149b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80149e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014a1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014a4:	89 ec                	mov    %ebp,%esp
  8014a6:	5d                   	pop    %ebp
  8014a7:	c3                   	ret    

008014a8 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8014a8:	55                   	push   %ebp
  8014a9:	89 e5                	mov    %esp,%ebp
  8014ab:	83 ec 38             	sub    $0x38,%esp
  8014ae:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014b1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8014b4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014b7:	b8 05 00 00 00       	mov    $0x5,%eax
  8014bc:	8b 75 18             	mov    0x18(%ebp),%esi
  8014bf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8014c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014cb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	7e 28                	jle    8014f9 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014d5:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8014dc:	00 
  8014dd:	c7 44 24 08 1f 3b 80 	movl   $0x803b1f,0x8(%esp)
  8014e4:	00 
  8014e5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014ec:	00 
  8014ed:	c7 04 24 3c 3b 80 00 	movl   $0x803b3c,(%esp)
  8014f4:	e8 0f f1 ff ff       	call   800608 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8014f9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014fc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014ff:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801502:	89 ec                	mov    %ebp,%esp
  801504:	5d                   	pop    %ebp
  801505:	c3                   	ret    

00801506 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801506:	55                   	push   %ebp
  801507:	89 e5                	mov    %esp,%ebp
  801509:	83 ec 38             	sub    $0x38,%esp
  80150c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80150f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801512:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801515:	be 00 00 00 00       	mov    $0x0,%esi
  80151a:	b8 04 00 00 00       	mov    $0x4,%eax
  80151f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801522:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801525:	8b 55 08             	mov    0x8(%ebp),%edx
  801528:	89 f7                	mov    %esi,%edi
  80152a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80152c:	85 c0                	test   %eax,%eax
  80152e:	7e 28                	jle    801558 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801530:	89 44 24 10          	mov    %eax,0x10(%esp)
  801534:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80153b:	00 
  80153c:	c7 44 24 08 1f 3b 80 	movl   $0x803b1f,0x8(%esp)
  801543:	00 
  801544:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80154b:	00 
  80154c:	c7 04 24 3c 3b 80 00 	movl   $0x803b3c,(%esp)
  801553:	e8 b0 f0 ff ff       	call   800608 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801558:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80155b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80155e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801561:	89 ec                	mov    %ebp,%esp
  801563:	5d                   	pop    %ebp
  801564:	c3                   	ret    

00801565 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  801565:	55                   	push   %ebp
  801566:	89 e5                	mov    %esp,%ebp
  801568:	83 ec 0c             	sub    $0xc,%esp
  80156b:	89 1c 24             	mov    %ebx,(%esp)
  80156e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801572:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801576:	ba 00 00 00 00       	mov    $0x0,%edx
  80157b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801580:	89 d1                	mov    %edx,%ecx
  801582:	89 d3                	mov    %edx,%ebx
  801584:	89 d7                	mov    %edx,%edi
  801586:	89 d6                	mov    %edx,%esi
  801588:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80158a:	8b 1c 24             	mov    (%esp),%ebx
  80158d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801591:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801595:	89 ec                	mov    %ebp,%esp
  801597:	5d                   	pop    %ebp
  801598:	c3                   	ret    

00801599 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801599:	55                   	push   %ebp
  80159a:	89 e5                	mov    %esp,%ebp
  80159c:	83 ec 0c             	sub    $0xc,%esp
  80159f:	89 1c 24             	mov    %ebx,(%esp)
  8015a2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015a6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8015af:	b8 02 00 00 00       	mov    $0x2,%eax
  8015b4:	89 d1                	mov    %edx,%ecx
  8015b6:	89 d3                	mov    %edx,%ebx
  8015b8:	89 d7                	mov    %edx,%edi
  8015ba:	89 d6                	mov    %edx,%esi
  8015bc:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8015be:	8b 1c 24             	mov    (%esp),%ebx
  8015c1:	8b 74 24 04          	mov    0x4(%esp),%esi
  8015c5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8015c9:	89 ec                	mov    %ebp,%esp
  8015cb:	5d                   	pop    %ebp
  8015cc:	c3                   	ret    

008015cd <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8015cd:	55                   	push   %ebp
  8015ce:	89 e5                	mov    %esp,%ebp
  8015d0:	83 ec 38             	sub    $0x38,%esp
  8015d3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015d6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015d9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015e1:	b8 03 00 00 00       	mov    $0x3,%eax
  8015e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e9:	89 cb                	mov    %ecx,%ebx
  8015eb:	89 cf                	mov    %ecx,%edi
  8015ed:	89 ce                	mov    %ecx,%esi
  8015ef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8015f1:	85 c0                	test   %eax,%eax
  8015f3:	7e 28                	jle    80161d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8015f5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8015f9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801600:	00 
  801601:	c7 44 24 08 1f 3b 80 	movl   $0x803b1f,0x8(%esp)
  801608:	00 
  801609:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801610:	00 
  801611:	c7 04 24 3c 3b 80 00 	movl   $0x803b3c,(%esp)
  801618:	e8 eb ef ff ff       	call   800608 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80161d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801620:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801623:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801626:	89 ec                	mov    %ebp,%esp
  801628:	5d                   	pop    %ebp
  801629:	c3                   	ret    
	...

0080162c <sfork>:
}

// Challenge!
int
sfork(void)
{
  80162c:	55                   	push   %ebp
  80162d:	89 e5                	mov    %esp,%ebp
  80162f:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801632:	c7 44 24 08 4a 3b 80 	movl   $0x803b4a,0x8(%esp)
  801639:	00 
  80163a:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  801641:	00 
  801642:	c7 04 24 60 3b 80 00 	movl   $0x803b60,(%esp)
  801649:	e8 ba ef ff ff       	call   800608 <_panic>

0080164e <duppage>:
// It is also OK to panic on error.
// 

static int
duppage(envid_t envid, unsigned pn)
{
  80164e:	55                   	push   %ebp
  80164f:	89 e5                	mov    %esp,%ebp
  801651:	83 ec 28             	sub    $0x28,%esp
  801654:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801657:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80165a:	89 c3                	mov    %eax,%ebx
	int r;

	// LAB 4: Your code here.
     pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  80165c:	89 d6                	mov    %edx,%esi
  80165e:	c1 e6 0c             	shl    $0xc,%esi
  801661:	89 f0                	mov    %esi,%eax
  801663:	c1 e8 16             	shr    $0x16,%eax
  801666:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
       
        if( 0 == pgDirEntry )
  80166d:	85 c0                	test   %eax,%eax
  80166f:	0f 84 fc 00 00 00    	je     801771 <duppage+0x123>
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  801675:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80167c:	89 c2                	mov    %eax,%edx
  80167e:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        //cprintf("Below %d",vpt[pn]);
                //if(perm!=0)  //commented nw.
                   // cprintf("perm bit %d",perm);
	
	
	if((perm & PTE_W) && (perm & PTE_SHARE))
  801684:	25 02 04 00 00       	and    $0x402,%eax
  801689:	3d 02 04 00 00       	cmp    $0x402,%eax
  80168e:	75 4d                	jne    8016dd <duppage+0x8f>
	{	
		if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_SHARE|(perm & PTE_USER))) < 0)
  801690:	81 e2 07 0a 00 00    	and    $0xa07,%edx
  801696:	80 ce 04             	or     $0x4,%dh
  801699:	89 54 24 10          	mov    %edx,0x10(%esp)
  80169d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8016a1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016a5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016b0:	e8 f3 fd ff ff       	call   8014a8 <sys_page_map>
  8016b5:	85 c0                	test   %eax,%eax
  8016b7:	0f 89 bb 00 00 00    	jns    801778 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  8016bd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016c1:	c7 44 24 08 6b 3b 80 	movl   $0x803b6b,0x8(%esp)
  8016c8:	00 
  8016c9:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  8016d0:	00 
  8016d1:	c7 04 24 60 3b 80 00 	movl   $0x803b60,(%esp)
  8016d8:	e8 2b ef ff ff       	call   800608 <_panic>
	}	


        else if((perm & PTE_W)!=0 || (perm & PTE_COW)!=0)
  8016dd:	f7 c2 02 08 00 00    	test   $0x802,%edx
  8016e3:	0f 84 8f 00 00 00    	je     801778 <duppage+0x12a>
         {
          //cprintf("\nInside Setting Cow\n"); 
        if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  8016e9:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8016f0:	00 
  8016f1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8016f5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016f9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016fd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801704:	e8 9f fd ff ff       	call   8014a8 <sys_page_map>
  801709:	85 c0                	test   %eax,%eax
  80170b:	79 20                	jns    80172d <duppage+0xdf>
                panic("sys_page_map: %e", r);
  80170d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801711:	c7 44 24 08 6b 3b 80 	movl   $0x803b6b,0x8(%esp)
  801718:	00 
  801719:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801720:	00 
  801721:	c7 04 24 60 3b 80 00 	movl   $0x803b60,(%esp)
  801728:	e8 db ee ff ff       	call   800608 <_panic>
        if ((r = sys_page_map(envid,(void *)(pn*PGSIZE),0,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  80172d:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801734:	00 
  801735:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801739:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801740:	00 
  801741:	89 74 24 04          	mov    %esi,0x4(%esp)
  801745:	89 1c 24             	mov    %ebx,(%esp)
  801748:	e8 5b fd ff ff       	call   8014a8 <sys_page_map>
  80174d:	85 c0                	test   %eax,%eax
  80174f:	79 27                	jns    801778 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  801751:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801755:	c7 44 24 08 6b 3b 80 	movl   $0x803b6b,0x8(%esp)
  80175c:	00 
  80175d:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  801764:	00 
  801765:	c7 04 24 60 3b 80 00 	movl   $0x803b60,(%esp)
  80176c:	e8 97 ee ff ff       	call   800608 <_panic>
  801771:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801776:	eb 05                	jmp    80177d <duppage+0x12f>
  801778:	b8 00 00 00 00       	mov    $0x0,%eax
         }


//	panic("duppage not implemented");
	return 0;
}
  80177d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801780:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801783:	89 ec                	mov    %ebp,%esp
  801785:	5d                   	pop    %ebp
  801786:	c3                   	ret    

00801787 <fork>:
//


envid_t
fork(void)
{
  801787:	55                   	push   %ebp
  801788:	89 e5                	mov    %esp,%ebp
  80178a:	56                   	push   %esi
  80178b:	53                   	push   %ebx
  80178c:	83 ec 10             	sub    $0x10,%esp

        envid_t envid;
        uint8_t *addr;
        int r;
        extern unsigned char end[];
        set_pgfault_handler(pgfault);
  80178f:	c7 04 24 9e 18 80 00 	movl   $0x80189e,(%esp)
  801796:	e8 95 1a 00 00       	call   803230 <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80179b:	be 07 00 00 00       	mov    $0x7,%esi
  8017a0:	89 f0                	mov    %esi,%eax
  8017a2:	cd 30                	int    $0x30
  8017a4:	89 c6                	mov    %eax,%esi

        envid = sys_exofork();
        if (envid < 0)
  8017a6:	85 c0                	test   %eax,%eax
  8017a8:	79 20                	jns    8017ca <fork+0x43>
                panic("sys_exofork: %e", envid);
  8017aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017ae:	c7 44 24 08 7c 3b 80 	movl   $0x803b7c,0x8(%esp)
  8017b5:	00 
  8017b6:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  8017bd:	00 
  8017be:	c7 04 24 60 3b 80 00 	movl   $0x803b60,(%esp)
  8017c5:	e8 3e ee ff ff       	call   800608 <_panic>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
  8017ca:	bb 00 00 80 00       	mov    $0x800000,%ebx
        set_pgfault_handler(pgfault);

        envid = sys_exofork();
        if (envid < 0)
                panic("sys_exofork: %e", envid);
        if (envid == 0) {
  8017cf:	85 c0                	test   %eax,%eax
  8017d1:	75 1c                	jne    8017ef <fork+0x68>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
  8017d3:	e8 c1 fd ff ff       	call   801599 <sys_getenvid>
  8017d8:	25 ff 03 00 00       	and    $0x3ff,%eax
  8017dd:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8017e0:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8017e5:	a3 74 70 80 00       	mov    %eax,0x807074
                return 0;
  8017ea:	e9 a6 00 00 00       	jmp    801895 <fork+0x10e>
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
  8017ef:	89 da                	mov    %ebx,%edx
  8017f1:	c1 ea 0c             	shr    $0xc,%edx
  8017f4:	89 f0                	mov    %esi,%eax
  8017f6:	e8 53 fe ff ff       	call   80164e <duppage>
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
  8017fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801801:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801807:	75 e6                	jne    8017ef <fork+0x68>
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
                }
              duppage(envid,VPN(USTACKTOP-PGSIZE));
  801809:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80180e:	89 f0                	mov    %esi,%eax
  801810:	e8 39 fe ff ff       	call   80164e <duppage>
        // Also copy the stack we are currently running on.
       //if(sys_page_alloc(envid, (void *)(ROUNDDOWN(&addr, PGSIZE)),PTE_U|PTE_P|PTE_W)<0)
         //                      panic("stack not allocated");
     
   
     sys_env_set_pgfault_upcall(envid,env->env_pgfault_upcall);
  801815:	a1 74 70 80 00       	mov    0x807074,%eax
  80181a:	8b 40 64             	mov    0x64(%eax),%eax
  80181d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801821:	89 34 24             	mov    %esi,(%esp)
  801824:	e8 07 fb ff ff       	call   801330 <sys_env_set_pgfault_upcall>

     if(sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  801829:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801830:	00 
  801831:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801838:	ee 
  801839:	89 34 24             	mov    %esi,(%esp)
  80183c:	e8 c5 fc ff ff       	call   801506 <sys_page_alloc>
  801841:	85 c0                	test   %eax,%eax
  801843:	79 1c                	jns    801861 <fork+0xda>
                          panic("Cant allocate Page");
  801845:	c7 44 24 08 8c 3b 80 	movl   $0x803b8c,0x8(%esp)
  80184c:	00 
  80184d:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  801854:	00 
  801855:	c7 04 24 60 3b 80 00 	movl   $0x803b60,(%esp)
  80185c:	e8 a7 ed ff ff       	call   800608 <_panic>

        // Start the child environment running
        if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  801861:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801868:	00 
  801869:	89 34 24             	mov    %esi,(%esp)
  80186c:	e8 7b fb ff ff       	call   8013ec <sys_env_set_status>
  801871:	85 c0                	test   %eax,%eax
  801873:	79 20                	jns    801895 <fork+0x10e>
                panic("sys_env_set_status: %e", r);
  801875:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801879:	c7 44 24 08 9f 3b 80 	movl   $0x803b9f,0x8(%esp)
  801880:	00 
  801881:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  801888:	00 
  801889:	c7 04 24 60 3b 80 00 	movl   $0x803b60,(%esp)
  801890:	e8 73 ed ff ff       	call   800608 <_panic>
         return envid;
           
//panic("fork not implemented");
}
  801895:	89 f0                	mov    %esi,%eax
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	5b                   	pop    %ebx
  80189b:	5e                   	pop    %esi
  80189c:	5d                   	pop    %ebp
  80189d:	c3                   	ret    

0080189e <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	53                   	push   %ebx
  8018a2:	83 ec 24             	sub    $0x24,%esp
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8018a8:	8b 18                	mov    (%eax),%ebx
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).
 
         int perm = vpt[VPN(addr)] & 0xFFF;
  8018aa:	89 da                	mov    %ebx,%edx
  8018ac:	c1 ea 0c             	shr    $0xc,%edx
  8018af:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx

static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
  8018b6:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8018ba:	74 21                	je     8018dd <pgfault+0x3f>
 
         int perm = vpt[VPN(addr)] & 0xFFF;
        if((err & FEC_WR)!=0)
           {
//              cprintf("\n>>>>>Due to write\n");
            if((perm & PTE_COW) == 0)
  8018bc:	f6 c6 08             	test   $0x8,%dh
  8018bf:	75 1c                	jne    8018dd <pgfault+0x3f>
             {
                   panic("Not Set Cow");
  8018c1:	c7 44 24 08 b6 3b 80 	movl   $0x803bb6,0x8(%esp)
  8018c8:	00 
  8018c9:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8018d0:	00 
  8018d1:	c7 04 24 60 3b 80 00 	movl   $0x803b60,(%esp)
  8018d8:	e8 2b ed ff ff       	call   800608 <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
        if(sys_page_alloc(0,PFTEMP,PTE_P|PTE_U|PTE_W)<0)
  8018dd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8018e4:	00 
  8018e5:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8018ec:	00 
  8018ed:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018f4:	e8 0d fc ff ff       	call   801506 <sys_page_alloc>
  8018f9:	85 c0                	test   %eax,%eax
  8018fb:	79 1c                	jns    801919 <pgfault+0x7b>
              panic("\nPage not allocated\n");
  8018fd:	c7 44 24 08 c2 3b 80 	movl   $0x803bc2,0x8(%esp)
  801904:	00 
  801905:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  80190c:	00 
  80190d:	c7 04 24 60 3b 80 00 	movl   $0x803b60,(%esp)
  801914:	e8 ef ec ff ff       	call   800608 <_panic>
           memmove(PFTEMP,ROUNDDOWN(addr,PGSIZE),PGSIZE);
  801919:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80191f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801926:	00 
  801927:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80192b:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801932:	e8 2e f6 ff ff       	call   800f65 <memmove>
          if(sys_page_map(0,ROUNDDOWN(PFTEMP,PGSIZE),0,ROUNDDOWN(addr,PGSIZE),PTE_U|PTE_P|PTE_W)<0)
  801937:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80193e:	00 
  80193f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801943:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80194a:	00 
  80194b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801952:	00 
  801953:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80195a:	e8 49 fb ff ff       	call   8014a8 <sys_page_map>
  80195f:	85 c0                	test   %eax,%eax
  801961:	79 1c                	jns    80197f <pgfault+0xe1>
                   panic("not mapped properly");
  801963:	c7 44 24 08 d7 3b 80 	movl   $0x803bd7,0x8(%esp)
  80196a:	00 
  80196b:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  801972:	00 
  801973:	c7 04 24 60 3b 80 00 	movl   $0x803b60,(%esp)
  80197a:	e8 89 ec ff ff       	call   800608 <_panic>
         if( 0 > sys_page_unmap(0, PFTEMP) )
  80197f:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801986:	00 
  801987:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80198e:	e8 b7 fa ff ff       	call   80144a <sys_page_unmap>
  801993:	85 c0                	test   %eax,%eax
  801995:	79 1c                	jns    8019b3 <pgfault+0x115>
                panic("sys_page_unmap failed\n");
  801997:	c7 44 24 08 eb 3b 80 	movl   $0x803beb,0x8(%esp)
  80199e:	00 
  80199f:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  8019a6:	00 
  8019a7:	c7 04 24 60 3b 80 00 	movl   $0x803b60,(%esp)
  8019ae:	e8 55 ec ff ff       	call   800608 <_panic>
   
//	panic("pgfault not implemented");
}
  8019b3:	83 c4 24             	add    $0x24,%esp
  8019b6:	5b                   	pop    %ebx
  8019b7:	5d                   	pop    %ebp
  8019b8:	c3                   	ret    
  8019b9:	00 00                	add    %al,(%eax)
  8019bb:	00 00                	add    %al,(%eax)
  8019bd:	00 00                	add    %al,(%eax)
	...

008019c0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c6:	05 00 00 00 30       	add    $0x30000000,%eax
  8019cb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8019ce:	5d                   	pop    %ebp
  8019cf:	c3                   	ret    

008019d0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  8019d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d9:	89 04 24             	mov    %eax,(%esp)
  8019dc:	e8 df ff ff ff       	call   8019c0 <fd2num>
  8019e1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8019e6:	c1 e0 0c             	shl    $0xc,%eax
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	57                   	push   %edi
  8019ef:	56                   	push   %esi
  8019f0:	53                   	push   %ebx
  8019f1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8019f4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8019f9:	a8 01                	test   $0x1,%al
  8019fb:	74 36                	je     801a33 <fd_alloc+0x48>
  8019fd:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801a02:	a8 01                	test   $0x1,%al
  801a04:	74 2d                	je     801a33 <fd_alloc+0x48>
  801a06:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  801a0b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801a10:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801a15:	89 c3                	mov    %eax,%ebx
  801a17:	89 c2                	mov    %eax,%edx
  801a19:	c1 ea 16             	shr    $0x16,%edx
  801a1c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  801a1f:	f6 c2 01             	test   $0x1,%dl
  801a22:	74 14                	je     801a38 <fd_alloc+0x4d>
  801a24:	89 c2                	mov    %eax,%edx
  801a26:	c1 ea 0c             	shr    $0xc,%edx
  801a29:	8b 14 96             	mov    (%esi,%edx,4),%edx
  801a2c:	f6 c2 01             	test   $0x1,%dl
  801a2f:	75 10                	jne    801a41 <fd_alloc+0x56>
  801a31:	eb 05                	jmp    801a38 <fd_alloc+0x4d>
  801a33:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801a38:	89 1f                	mov    %ebx,(%edi)
  801a3a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801a3f:	eb 17                	jmp    801a58 <fd_alloc+0x6d>
  801a41:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801a46:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801a4b:	75 c8                	jne    801a15 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801a4d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801a53:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801a58:	5b                   	pop    %ebx
  801a59:	5e                   	pop    %esi
  801a5a:	5f                   	pop    %edi
  801a5b:	5d                   	pop    %ebp
  801a5c:	c3                   	ret    

00801a5d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801a60:	8b 45 08             	mov    0x8(%ebp),%eax
  801a63:	83 f8 1f             	cmp    $0x1f,%eax
  801a66:	77 36                	ja     801a9e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801a68:	05 00 00 0d 00       	add    $0xd0000,%eax
  801a6d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801a70:	89 c2                	mov    %eax,%edx
  801a72:	c1 ea 16             	shr    $0x16,%edx
  801a75:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801a7c:	f6 c2 01             	test   $0x1,%dl
  801a7f:	74 1d                	je     801a9e <fd_lookup+0x41>
  801a81:	89 c2                	mov    %eax,%edx
  801a83:	c1 ea 0c             	shr    $0xc,%edx
  801a86:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a8d:	f6 c2 01             	test   $0x1,%dl
  801a90:	74 0c                	je     801a9e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801a92:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a95:	89 02                	mov    %eax,(%edx)
  801a97:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  801a9c:	eb 05                	jmp    801aa3 <fd_lookup+0x46>
  801a9e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801aa3:	5d                   	pop    %ebp
  801aa4:	c3                   	ret    

00801aa5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801aa5:	55                   	push   %ebp
  801aa6:	89 e5                	mov    %esp,%ebp
  801aa8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aab:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801aae:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab5:	89 04 24             	mov    %eax,(%esp)
  801ab8:	e8 a0 ff ff ff       	call   801a5d <fd_lookup>
  801abd:	85 c0                	test   %eax,%eax
  801abf:	78 0e                	js     801acf <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801ac1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ac4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ac7:	89 50 04             	mov    %edx,0x4(%eax)
  801aca:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
  801ad4:	56                   	push   %esi
  801ad5:	53                   	push   %ebx
  801ad6:	83 ec 10             	sub    $0x10,%esp
  801ad9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801adc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  801adf:	b8 20 70 80 00       	mov    $0x807020,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801ae4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801ae9:	be 80 3c 80 00       	mov    $0x803c80,%esi
		if (devtab[i]->dev_id == dev_id) {
  801aee:	39 08                	cmp    %ecx,(%eax)
  801af0:	75 10                	jne    801b02 <dev_lookup+0x31>
  801af2:	eb 04                	jmp    801af8 <dev_lookup+0x27>
  801af4:	39 08                	cmp    %ecx,(%eax)
  801af6:	75 0a                	jne    801b02 <dev_lookup+0x31>
			*dev = devtab[i];
  801af8:	89 03                	mov    %eax,(%ebx)
  801afa:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801aff:	90                   	nop
  801b00:	eb 31                	jmp    801b33 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801b02:	83 c2 01             	add    $0x1,%edx
  801b05:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801b08:	85 c0                	test   %eax,%eax
  801b0a:	75 e8                	jne    801af4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801b0c:	a1 74 70 80 00       	mov    0x807074,%eax
  801b11:	8b 40 4c             	mov    0x4c(%eax),%eax
  801b14:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801b18:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b1c:	c7 04 24 04 3c 80 00 	movl   $0x803c04,(%esp)
  801b23:	e8 a5 eb ff ff       	call   8006cd <cprintf>
	*dev = 0;
  801b28:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801b2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801b33:	83 c4 10             	add    $0x10,%esp
  801b36:	5b                   	pop    %ebx
  801b37:	5e                   	pop    %esi
  801b38:	5d                   	pop    %ebp
  801b39:	c3                   	ret    

00801b3a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
  801b3d:	53                   	push   %ebx
  801b3e:	83 ec 24             	sub    $0x24,%esp
  801b41:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b44:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	89 04 24             	mov    %eax,(%esp)
  801b51:	e8 07 ff ff ff       	call   801a5d <fd_lookup>
  801b56:	85 c0                	test   %eax,%eax
  801b58:	78 53                	js     801bad <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b5a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b64:	8b 00                	mov    (%eax),%eax
  801b66:	89 04 24             	mov    %eax,(%esp)
  801b69:	e8 63 ff ff ff       	call   801ad1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b6e:	85 c0                	test   %eax,%eax
  801b70:	78 3b                	js     801bad <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801b72:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b77:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b7a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801b7e:	74 2d                	je     801bad <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801b80:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801b83:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801b8a:	00 00 00 
	stat->st_isdir = 0;
  801b8d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801b94:	00 00 00 
	stat->st_dev = dev;
  801b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ba0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ba4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ba7:	89 14 24             	mov    %edx,(%esp)
  801baa:	ff 50 14             	call   *0x14(%eax)
}
  801bad:	83 c4 24             	add    $0x24,%esp
  801bb0:	5b                   	pop    %ebx
  801bb1:	5d                   	pop    %ebp
  801bb2:	c3                   	ret    

00801bb3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801bb3:	55                   	push   %ebp
  801bb4:	89 e5                	mov    %esp,%ebp
  801bb6:	53                   	push   %ebx
  801bb7:	83 ec 24             	sub    $0x24,%esp
  801bba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801bbd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc4:	89 1c 24             	mov    %ebx,(%esp)
  801bc7:	e8 91 fe ff ff       	call   801a5d <fd_lookup>
  801bcc:	85 c0                	test   %eax,%eax
  801bce:	78 5f                	js     801c2f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801bd0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bda:	8b 00                	mov    (%eax),%eax
  801bdc:	89 04 24             	mov    %eax,(%esp)
  801bdf:	e8 ed fe ff ff       	call   801ad1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801be4:	85 c0                	test   %eax,%eax
  801be6:	78 47                	js     801c2f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801be8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801beb:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801bef:	75 23                	jne    801c14 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801bf1:	a1 74 70 80 00       	mov    0x807074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801bf6:	8b 40 4c             	mov    0x4c(%eax),%eax
  801bf9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c01:	c7 04 24 24 3c 80 00 	movl   $0x803c24,(%esp)
  801c08:	e8 c0 ea ff ff       	call   8006cd <cprintf>
  801c0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801c12:	eb 1b                	jmp    801c2f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c17:	8b 48 18             	mov    0x18(%eax),%ecx
  801c1a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c1f:	85 c9                	test   %ecx,%ecx
  801c21:	74 0c                	je     801c2f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c26:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c2a:	89 14 24             	mov    %edx,(%esp)
  801c2d:	ff d1                	call   *%ecx
}
  801c2f:	83 c4 24             	add    $0x24,%esp
  801c32:	5b                   	pop    %ebx
  801c33:	5d                   	pop    %ebp
  801c34:	c3                   	ret    

00801c35 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801c35:	55                   	push   %ebp
  801c36:	89 e5                	mov    %esp,%ebp
  801c38:	53                   	push   %ebx
  801c39:	83 ec 24             	sub    $0x24,%esp
  801c3c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c3f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c42:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c46:	89 1c 24             	mov    %ebx,(%esp)
  801c49:	e8 0f fe ff ff       	call   801a5d <fd_lookup>
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	78 66                	js     801cb8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c52:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c55:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c5c:	8b 00                	mov    (%eax),%eax
  801c5e:	89 04 24             	mov    %eax,(%esp)
  801c61:	e8 6b fe ff ff       	call   801ad1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c66:	85 c0                	test   %eax,%eax
  801c68:	78 4e                	js     801cb8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801c6a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c6d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801c71:	75 23                	jne    801c96 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801c73:	a1 74 70 80 00       	mov    0x807074,%eax
  801c78:	8b 40 4c             	mov    0x4c(%eax),%eax
  801c7b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c83:	c7 04 24 45 3c 80 00 	movl   $0x803c45,(%esp)
  801c8a:	e8 3e ea ff ff       	call   8006cd <cprintf>
  801c8f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801c94:	eb 22                	jmp    801cb8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801c96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c99:	8b 48 0c             	mov    0xc(%eax),%ecx
  801c9c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ca1:	85 c9                	test   %ecx,%ecx
  801ca3:	74 13                	je     801cb8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ca8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801caf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cb3:	89 14 24             	mov    %edx,(%esp)
  801cb6:	ff d1                	call   *%ecx
}
  801cb8:	83 c4 24             	add    $0x24,%esp
  801cbb:	5b                   	pop    %ebx
  801cbc:	5d                   	pop    %ebp
  801cbd:	c3                   	ret    

00801cbe <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801cbe:	55                   	push   %ebp
  801cbf:	89 e5                	mov    %esp,%ebp
  801cc1:	53                   	push   %ebx
  801cc2:	83 ec 24             	sub    $0x24,%esp
  801cc5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cc8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ccb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ccf:	89 1c 24             	mov    %ebx,(%esp)
  801cd2:	e8 86 fd ff ff       	call   801a5d <fd_lookup>
  801cd7:	85 c0                	test   %eax,%eax
  801cd9:	78 6b                	js     801d46 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801cdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cde:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ce5:	8b 00                	mov    (%eax),%eax
  801ce7:	89 04 24             	mov    %eax,(%esp)
  801cea:	e8 e2 fd ff ff       	call   801ad1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cef:	85 c0                	test   %eax,%eax
  801cf1:	78 53                	js     801d46 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801cf3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cf6:	8b 42 08             	mov    0x8(%edx),%eax
  801cf9:	83 e0 03             	and    $0x3,%eax
  801cfc:	83 f8 01             	cmp    $0x1,%eax
  801cff:	75 23                	jne    801d24 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801d01:	a1 74 70 80 00       	mov    0x807074,%eax
  801d06:	8b 40 4c             	mov    0x4c(%eax),%eax
  801d09:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d11:	c7 04 24 62 3c 80 00 	movl   $0x803c62,(%esp)
  801d18:	e8 b0 e9 ff ff       	call   8006cd <cprintf>
  801d1d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801d22:	eb 22                	jmp    801d46 <read+0x88>
	}
	if (!dev->dev_read)
  801d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d27:	8b 48 08             	mov    0x8(%eax),%ecx
  801d2a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d2f:	85 c9                	test   %ecx,%ecx
  801d31:	74 13                	je     801d46 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801d33:	8b 45 10             	mov    0x10(%ebp),%eax
  801d36:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d41:	89 14 24             	mov    %edx,(%esp)
  801d44:	ff d1                	call   *%ecx
}
  801d46:	83 c4 24             	add    $0x24,%esp
  801d49:	5b                   	pop    %ebx
  801d4a:	5d                   	pop    %ebp
  801d4b:	c3                   	ret    

00801d4c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801d4c:	55                   	push   %ebp
  801d4d:	89 e5                	mov    %esp,%ebp
  801d4f:	57                   	push   %edi
  801d50:	56                   	push   %esi
  801d51:	53                   	push   %ebx
  801d52:	83 ec 1c             	sub    $0x1c,%esp
  801d55:	8b 7d 08             	mov    0x8(%ebp),%edi
  801d58:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801d5b:	ba 00 00 00 00       	mov    $0x0,%edx
  801d60:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d65:	b8 00 00 00 00       	mov    $0x0,%eax
  801d6a:	85 f6                	test   %esi,%esi
  801d6c:	74 29                	je     801d97 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801d6e:	89 f0                	mov    %esi,%eax
  801d70:	29 d0                	sub    %edx,%eax
  801d72:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d76:	03 55 0c             	add    0xc(%ebp),%edx
  801d79:	89 54 24 04          	mov    %edx,0x4(%esp)
  801d7d:	89 3c 24             	mov    %edi,(%esp)
  801d80:	e8 39 ff ff ff       	call   801cbe <read>
		if (m < 0)
  801d85:	85 c0                	test   %eax,%eax
  801d87:	78 0e                	js     801d97 <readn+0x4b>
			return m;
		if (m == 0)
  801d89:	85 c0                	test   %eax,%eax
  801d8b:	74 08                	je     801d95 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801d8d:	01 c3                	add    %eax,%ebx
  801d8f:	89 da                	mov    %ebx,%edx
  801d91:	39 f3                	cmp    %esi,%ebx
  801d93:	72 d9                	jb     801d6e <readn+0x22>
  801d95:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801d97:	83 c4 1c             	add    $0x1c,%esp
  801d9a:	5b                   	pop    %ebx
  801d9b:	5e                   	pop    %esi
  801d9c:	5f                   	pop    %edi
  801d9d:	5d                   	pop    %ebp
  801d9e:	c3                   	ret    

00801d9f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
  801da2:	56                   	push   %esi
  801da3:	53                   	push   %ebx
  801da4:	83 ec 20             	sub    $0x20,%esp
  801da7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801daa:	89 34 24             	mov    %esi,(%esp)
  801dad:	e8 0e fc ff ff       	call   8019c0 <fd2num>
  801db2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801db5:	89 54 24 04          	mov    %edx,0x4(%esp)
  801db9:	89 04 24             	mov    %eax,(%esp)
  801dbc:	e8 9c fc ff ff       	call   801a5d <fd_lookup>
  801dc1:	89 c3                	mov    %eax,%ebx
  801dc3:	85 c0                	test   %eax,%eax
  801dc5:	78 05                	js     801dcc <fd_close+0x2d>
  801dc7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801dca:	74 0c                	je     801dd8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801dcc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801dd0:	19 c0                	sbb    %eax,%eax
  801dd2:	f7 d0                	not    %eax
  801dd4:	21 c3                	and    %eax,%ebx
  801dd6:	eb 3d                	jmp    801e15 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801dd8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ddb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ddf:	8b 06                	mov    (%esi),%eax
  801de1:	89 04 24             	mov    %eax,(%esp)
  801de4:	e8 e8 fc ff ff       	call   801ad1 <dev_lookup>
  801de9:	89 c3                	mov    %eax,%ebx
  801deb:	85 c0                	test   %eax,%eax
  801ded:	78 16                	js     801e05 <fd_close+0x66>
		if (dev->dev_close)
  801def:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df2:	8b 40 10             	mov    0x10(%eax),%eax
  801df5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dfa:	85 c0                	test   %eax,%eax
  801dfc:	74 07                	je     801e05 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801dfe:	89 34 24             	mov    %esi,(%esp)
  801e01:	ff d0                	call   *%eax
  801e03:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801e05:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e10:	e8 35 f6 ff ff       	call   80144a <sys_page_unmap>
	return r;
}
  801e15:	89 d8                	mov    %ebx,%eax
  801e17:	83 c4 20             	add    $0x20,%esp
  801e1a:	5b                   	pop    %ebx
  801e1b:	5e                   	pop    %esi
  801e1c:	5d                   	pop    %ebp
  801e1d:	c3                   	ret    

00801e1e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801e1e:	55                   	push   %ebp
  801e1f:	89 e5                	mov    %esp,%ebp
  801e21:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e24:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2e:	89 04 24             	mov    %eax,(%esp)
  801e31:	e8 27 fc ff ff       	call   801a5d <fd_lookup>
  801e36:	85 c0                	test   %eax,%eax
  801e38:	78 13                	js     801e4d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801e3a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801e41:	00 
  801e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e45:	89 04 24             	mov    %eax,(%esp)
  801e48:	e8 52 ff ff ff       	call   801d9f <fd_close>
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
  801e52:	83 ec 18             	sub    $0x18,%esp
  801e55:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801e58:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801e5b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e62:	00 
  801e63:	8b 45 08             	mov    0x8(%ebp),%eax
  801e66:	89 04 24             	mov    %eax,(%esp)
  801e69:	e8 a9 03 00 00       	call   802217 <open>
  801e6e:	89 c3                	mov    %eax,%ebx
  801e70:	85 c0                	test   %eax,%eax
  801e72:	78 1b                	js     801e8f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e77:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e7b:	89 1c 24             	mov    %ebx,(%esp)
  801e7e:	e8 b7 fc ff ff       	call   801b3a <fstat>
  801e83:	89 c6                	mov    %eax,%esi
	close(fd);
  801e85:	89 1c 24             	mov    %ebx,(%esp)
  801e88:	e8 91 ff ff ff       	call   801e1e <close>
  801e8d:	89 f3                	mov    %esi,%ebx
	return r;
}
  801e8f:	89 d8                	mov    %ebx,%eax
  801e91:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801e94:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801e97:	89 ec                	mov    %ebp,%esp
  801e99:	5d                   	pop    %ebp
  801e9a:	c3                   	ret    

00801e9b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	53                   	push   %ebx
  801e9f:	83 ec 14             	sub    $0x14,%esp
  801ea2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801ea7:	89 1c 24             	mov    %ebx,(%esp)
  801eaa:	e8 6f ff ff ff       	call   801e1e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801eaf:	83 c3 01             	add    $0x1,%ebx
  801eb2:	83 fb 20             	cmp    $0x20,%ebx
  801eb5:	75 f0                	jne    801ea7 <close_all+0xc>
		close(i);
}
  801eb7:	83 c4 14             	add    $0x14,%esp
  801eba:	5b                   	pop    %ebx
  801ebb:	5d                   	pop    %ebp
  801ebc:	c3                   	ret    

00801ebd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 58             	sub    $0x58,%esp
  801ec3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ec6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ec9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801ecc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801ecf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ed2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed9:	89 04 24             	mov    %eax,(%esp)
  801edc:	e8 7c fb ff ff       	call   801a5d <fd_lookup>
  801ee1:	89 c3                	mov    %eax,%ebx
  801ee3:	85 c0                	test   %eax,%eax
  801ee5:	0f 88 e0 00 00 00    	js     801fcb <dup+0x10e>
		return r;
	close(newfdnum);
  801eeb:	89 3c 24             	mov    %edi,(%esp)
  801eee:	e8 2b ff ff ff       	call   801e1e <close>

	newfd = INDEX2FD(newfdnum);
  801ef3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801ef9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801efc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801eff:	89 04 24             	mov    %eax,(%esp)
  801f02:	e8 c9 fa ff ff       	call   8019d0 <fd2data>
  801f07:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801f09:	89 34 24             	mov    %esi,(%esp)
  801f0c:	e8 bf fa ff ff       	call   8019d0 <fd2data>
  801f11:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801f14:	89 da                	mov    %ebx,%edx
  801f16:	89 d8                	mov    %ebx,%eax
  801f18:	c1 e8 16             	shr    $0x16,%eax
  801f1b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801f22:	a8 01                	test   $0x1,%al
  801f24:	74 43                	je     801f69 <dup+0xac>
  801f26:	c1 ea 0c             	shr    $0xc,%edx
  801f29:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801f30:	a8 01                	test   $0x1,%al
  801f32:	74 35                	je     801f69 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801f34:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801f3b:	25 07 0e 00 00       	and    $0xe07,%eax
  801f40:	89 44 24 10          	mov    %eax,0x10(%esp)
  801f44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801f47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f52:	00 
  801f53:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f57:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f5e:	e8 45 f5 ff ff       	call   8014a8 <sys_page_map>
  801f63:	89 c3                	mov    %eax,%ebx
  801f65:	85 c0                	test   %eax,%eax
  801f67:	78 3f                	js     801fa8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801f69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801f6c:	89 c2                	mov    %eax,%edx
  801f6e:	c1 ea 0c             	shr    $0xc,%edx
  801f71:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801f78:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801f7e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801f82:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801f86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801f8d:	00 
  801f8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f99:	e8 0a f5 ff ff       	call   8014a8 <sys_page_map>
  801f9e:	89 c3                	mov    %eax,%ebx
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	78 04                	js     801fa8 <dup+0xeb>
  801fa4:	89 fb                	mov    %edi,%ebx
  801fa6:	eb 23                	jmp    801fcb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801fa8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fb3:	e8 92 f4 ff ff       	call   80144a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801fb8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801fbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fbf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fc6:	e8 7f f4 ff ff       	call   80144a <sys_page_unmap>
	return r;
}
  801fcb:	89 d8                	mov    %ebx,%eax
  801fcd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801fd0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801fd3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801fd6:	89 ec                	mov    %ebp,%esp
  801fd8:	5d                   	pop    %ebp
  801fd9:	c3                   	ret    
	...

00801fdc <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801fdc:	55                   	push   %ebp
  801fdd:	89 e5                	mov    %esp,%ebp
  801fdf:	53                   	push   %ebx
  801fe0:	83 ec 14             	sub    $0x14,%esp
  801fe3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801fe5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801feb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801ff2:	00 
  801ff3:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801ffa:	00 
  801ffb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fff:	89 14 24             	mov    %edx,(%esp)
  802002:	e8 c9 12 00 00       	call   8032d0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802007:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80200e:	00 
  80200f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802013:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80201a:	e8 13 13 00 00       	call   803332 <ipc_recv>
}
  80201f:	83 c4 14             	add    $0x14,%esp
  802022:	5b                   	pop    %ebx
  802023:	5d                   	pop    %ebp
  802024:	c3                   	ret    

00802025 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802025:	55                   	push   %ebp
  802026:	89 e5                	mov    %esp,%ebp
  802028:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80202b:	8b 45 08             	mov    0x8(%ebp),%eax
  80202e:	8b 40 0c             	mov    0xc(%eax),%eax
  802031:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  802036:	8b 45 0c             	mov    0xc(%ebp),%eax
  802039:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80203e:	ba 00 00 00 00       	mov    $0x0,%edx
  802043:	b8 02 00 00 00       	mov    $0x2,%eax
  802048:	e8 8f ff ff ff       	call   801fdc <fsipc>
}
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802055:	ba 00 00 00 00       	mov    $0x0,%edx
  80205a:	b8 08 00 00 00       	mov    $0x8,%eax
  80205f:	e8 78 ff ff ff       	call   801fdc <fsipc>
}
  802064:	c9                   	leave  
  802065:	c3                   	ret    

00802066 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802066:	55                   	push   %ebp
  802067:	89 e5                	mov    %esp,%ebp
  802069:	53                   	push   %ebx
  80206a:	83 ec 14             	sub    $0x14,%esp
  80206d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802070:	8b 45 08             	mov    0x8(%ebp),%eax
  802073:	8b 40 0c             	mov    0xc(%eax),%eax
  802076:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80207b:	ba 00 00 00 00       	mov    $0x0,%edx
  802080:	b8 05 00 00 00       	mov    $0x5,%eax
  802085:	e8 52 ff ff ff       	call   801fdc <fsipc>
  80208a:	85 c0                	test   %eax,%eax
  80208c:	78 2b                	js     8020b9 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80208e:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  802095:	00 
  802096:	89 1c 24             	mov    %ebx,(%esp)
  802099:	e8 0c ed ff ff       	call   800daa <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80209e:	a1 80 40 80 00       	mov    0x804080,%eax
  8020a3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8020a9:	a1 84 40 80 00       	mov    0x804084,%eax
  8020ae:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  8020b4:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8020b9:	83 c4 14             	add    $0x14,%esp
  8020bc:	5b                   	pop    %ebx
  8020bd:	5d                   	pop    %ebp
  8020be:	c3                   	ret    

008020bf <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  8020c5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8020cc:	00 
  8020cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8020d4:	00 
  8020d5:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  8020dc:	e8 25 ee ff ff       	call   800f06 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8020e7:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  8020ec:	ba 00 00 00 00       	mov    $0x0,%edx
  8020f1:	b8 06 00 00 00       	mov    $0x6,%eax
  8020f6:	e8 e1 fe ff ff       	call   801fdc <fsipc>
}
  8020fb:	c9                   	leave  
  8020fc:	c3                   	ret    

008020fd <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  8020fd:	55                   	push   %ebp
  8020fe:	89 e5                	mov    %esp,%ebp
  802100:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  802103:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80210a:	00 
  80210b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802112:	00 
  802113:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  80211a:	e8 e7 ed ff ff       	call   800f06 <memset>
  80211f:	8b 45 10             	mov    0x10(%ebp),%eax
  802122:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  802127:	76 05                	jbe    80212e <devfile_write+0x31>
  802129:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80212e:	8b 55 08             	mov    0x8(%ebp),%edx
  802131:	8b 52 0c             	mov    0xc(%edx),%edx
  802134:	89 15 00 40 80 00    	mov    %edx,0x804000
        fsipcbuf.write.req_n = numberOfBytes;
  80213a:	a3 04 40 80 00       	mov    %eax,0x804004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  80213f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802143:	8b 45 0c             	mov    0xc(%ebp),%eax
  802146:	89 44 24 04          	mov    %eax,0x4(%esp)
  80214a:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  802151:	e8 0f ee ff ff       	call   800f65 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  802156:	ba 00 00 00 00       	mov    $0x0,%edx
  80215b:	b8 04 00 00 00       	mov    $0x4,%eax
  802160:	e8 77 fe ff ff       	call   801fdc <fsipc>
              return r;
        return r;
}
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	53                   	push   %ebx
  80216b:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  80216e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802175:	00 
  802176:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80217d:	00 
  80217e:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  802185:	e8 7c ed ff ff       	call   800f06 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	8b 40 0c             	mov    0xc(%eax),%eax
  802190:	a3 00 40 80 00       	mov    %eax,0x804000
        fsipcbuf.read.req_n = n;
  802195:	8b 45 10             	mov    0x10(%ebp),%eax
  802198:	a3 04 40 80 00       	mov    %eax,0x804004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  80219d:	ba 00 00 00 00       	mov    $0x0,%edx
  8021a2:	b8 03 00 00 00       	mov    $0x3,%eax
  8021a7:	e8 30 fe ff ff       	call   801fdc <fsipc>
  8021ac:	89 c3                	mov    %eax,%ebx
  8021ae:	85 c0                	test   %eax,%eax
  8021b0:	78 17                	js     8021c9 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  8021b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021b6:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  8021bd:	00 
  8021be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021c1:	89 04 24             	mov    %eax,(%esp)
  8021c4:	e8 9c ed ff ff       	call   800f65 <memmove>
        return r;
}
  8021c9:	89 d8                	mov    %ebx,%eax
  8021cb:	83 c4 14             	add    $0x14,%esp
  8021ce:	5b                   	pop    %ebx
  8021cf:	5d                   	pop    %ebp
  8021d0:	c3                   	ret    

008021d1 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	53                   	push   %ebx
  8021d5:	83 ec 14             	sub    $0x14,%esp
  8021d8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  8021db:	89 1c 24             	mov    %ebx,(%esp)
  8021de:	e8 7d eb ff ff       	call   800d60 <strlen>
  8021e3:	89 c2                	mov    %eax,%edx
  8021e5:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8021ea:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  8021f0:	7f 1f                	jg     802211 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  8021f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8021f6:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  8021fd:	e8 a8 eb ff ff       	call   800daa <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  802202:	ba 00 00 00 00       	mov    $0x0,%edx
  802207:	b8 07 00 00 00       	mov    $0x7,%eax
  80220c:	e8 cb fd ff ff       	call   801fdc <fsipc>
}
  802211:	83 c4 14             	add    $0x14,%esp
  802214:	5b                   	pop    %ebx
  802215:	5d                   	pop    %ebp
  802216:	c3                   	ret    

00802217 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
  80221a:	56                   	push   %esi
  80221b:	53                   	push   %ebx
  80221c:	83 ec 20             	sub    $0x20,%esp
  80221f:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  802222:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802229:	00 
  80222a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802231:	00 
  802232:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  802239:	e8 c8 ec ff ff       	call   800f06 <memset>
    if(strlen(path)>=MAXPATHLEN)
  80223e:	89 34 24             	mov    %esi,(%esp)
  802241:	e8 1a eb ff ff       	call   800d60 <strlen>
  802246:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80224b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802250:	0f 8f 84 00 00 00    	jg     8022da <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  802256:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802259:	89 04 24             	mov    %eax,(%esp)
  80225c:	e8 8a f7 ff ff       	call   8019eb <fd_alloc>
  802261:	89 c3                	mov    %eax,%ebx
  802263:	85 c0                	test   %eax,%eax
  802265:	78 73                	js     8022da <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  802267:	0f b6 06             	movzbl (%esi),%eax
  80226a:	84 c0                	test   %al,%al
  80226c:	74 20                	je     80228e <open+0x77>
  80226e:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  802270:	0f be c0             	movsbl %al,%eax
  802273:	89 44 24 04          	mov    %eax,0x4(%esp)
  802277:	c7 04 24 94 3c 80 00 	movl   $0x803c94,(%esp)
  80227e:	e8 4a e4 ff ff       	call   8006cd <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  802283:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  802287:	83 c3 01             	add    $0x1,%ebx
  80228a:	84 c0                	test   %al,%al
  80228c:	75 e2                	jne    802270 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  80228e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802292:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  802299:	e8 0c eb ff ff       	call   800daa <strcpy>
    fsipcbuf.open.req_omode = mode;
  80229e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a1:	a3 00 44 80 00       	mov    %eax,0x804400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  8022a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022a9:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ae:	e8 29 fd ff ff       	call   801fdc <fsipc>
  8022b3:	89 c3                	mov    %eax,%ebx
  8022b5:	85 c0                	test   %eax,%eax
  8022b7:	79 15                	jns    8022ce <open+0xb7>
        {
            fd_close(fd,1);
  8022b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8022c0:	00 
  8022c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c4:	89 04 24             	mov    %eax,(%esp)
  8022c7:	e8 d3 fa ff ff       	call   801d9f <fd_close>
             return r;
  8022cc:	eb 0c                	jmp    8022da <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  8022ce:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8022d1:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  8022d7:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  8022da:	89 d8                	mov    %ebx,%eax
  8022dc:	83 c4 20             	add    $0x20,%esp
  8022df:	5b                   	pop    %ebx
  8022e0:	5e                   	pop    %esi
  8022e1:	5d                   	pop    %ebp
  8022e2:	c3                   	ret    
	...

008022e4 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
  8022e7:	57                   	push   %edi
  8022e8:	56                   	push   %esi
  8022e9:	53                   	push   %ebx
  8022ea:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8022f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8022f7:	00 
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	89 04 24             	mov    %eax,(%esp)
  8022fe:	e8 14 ff ff ff       	call   802217 <open>
  802303:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  802309:	89 c3                	mov    %eax,%ebx
  80230b:	85 c0                	test   %eax,%eax
  80230d:	0f 88 d1 05 00 00    	js     8028e4 <spawn+0x600>
	fd = r;
    // cprintf("fd--->%d",fd);
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
	    || elf->e_magic != ELF_MAGIC) {
  802313:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80231a:	00 
  80231b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  802321:	89 44 24 04          	mov    %eax,0x4(%esp)
  802325:	89 1c 24             	mov    %ebx,(%esp)
  802328:	e8 91 f9 ff ff       	call   801cbe <read>
		return r;
	fd = r;
    // cprintf("fd--->%d",fd);
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80232d:	3d 00 02 00 00       	cmp    $0x200,%eax
  802332:	75 0c                	jne    802340 <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  802334:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  80233b:	45 4c 46 
  80233e:	74 36                	je     802376 <spawn+0x92>
		close(fd);
  802340:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802346:	89 04 24             	mov    %eax,(%esp)
  802349:	e8 d0 fa ff ff       	call   801e1e <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  80234e:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  802355:	46 
  802356:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  80235c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802360:	c7 04 24 97 3c 80 00 	movl   $0x803c97,(%esp)
  802367:	e8 61 e3 ff ff       	call   8006cd <cprintf>
  80236c:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
		return -E_NOT_EXEC;
  802371:	e9 6e 05 00 00       	jmp    8028e4 <spawn+0x600>
  802376:	ba 07 00 00 00       	mov    $0x7,%edx
  80237b:	89 d0                	mov    %edx,%eax
  80237d:	cd 30                	int    $0x30
  80237f:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
	}
     
       // Create new child environment
	if ((r = sys_exofork()) < 0)
  802385:	85 c0                	test   %eax,%eax
  802387:	0f 88 51 05 00 00    	js     8028de <spawn+0x5fa>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  80238d:	89 c6                	mov    %eax,%esi
  80238f:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  802395:	6b f6 7c             	imul   $0x7c,%esi,%esi
  802398:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  80239e:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  8023a4:	b9 11 00 00 00       	mov    $0x11,%ecx
  8023a9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	cprintf("\nelf->entry %x\n",elf->e_entry);
  8023ab:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8023b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b5:	c7 04 24 b1 3c 80 00 	movl   $0x803cb1,(%esp)
  8023bc:	e8 0c e3 ff ff       	call   8006cd <cprintf>
        child_tf.tf_eip = elf->e_entry;
  8023c1:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8023c7:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8023cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d0:	8b 02                	mov    (%edx),%eax
  8023d2:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023d7:	be 00 00 00 00       	mov    $0x0,%esi
  8023dc:	85 c0                	test   %eax,%eax
  8023de:	75 16                	jne    8023f6 <spawn+0x112>
  8023e0:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8023e7:	00 00 00 
  8023ea:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  8023f1:	00 00 00 
  8023f4:	eb 2c                	jmp    802422 <spawn+0x13e>
  8023f6:	8b 7d 0c             	mov    0xc(%ebp),%edi
		string_size += strlen(argv[argc]) + 1;
  8023f9:	89 04 24             	mov    %eax,(%esp)
  8023fc:	e8 5f e9 ff ff       	call   800d60 <strlen>
  802401:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  802405:	83 c6 01             	add    $0x1,%esi
  802408:	8d 14 b5 00 00 00 00 	lea    0x0(,%esi,4),%edx
  80240f:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  802412:	85 c0                	test   %eax,%eax
  802414:	75 e3                	jne    8023f9 <spawn+0x115>
  802416:	89 95 7c fd ff ff    	mov    %edx,-0x284(%ebp)
  80241c:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  802422:	f7 db                	neg    %ebx
  802424:	8d bb 00 10 40 00    	lea    0x401000(%ebx),%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  80242a:	89 fa                	mov    %edi,%edx
  80242c:	83 e2 fc             	and    $0xfffffffc,%edx
  80242f:	89 f0                	mov    %esi,%eax
  802431:	f7 d0                	not    %eax
  802433:	8d 04 82             	lea    (%edx,%eax,4),%eax
  802436:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80243c:	83 e8 08             	sub    $0x8,%eax
  80243f:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  802445:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  80244a:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  80244f:	0f 86 8f 04 00 00    	jbe    8028e4 <spawn+0x600>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802455:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80245c:	00 
  80245d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802464:	00 
  802465:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80246c:	e8 95 f0 ff ff       	call   801506 <sys_page_alloc>
  802471:	89 c3                	mov    %eax,%ebx
  802473:	85 c0                	test   %eax,%eax
  802475:	0f 88 69 04 00 00    	js     8028e4 <spawn+0x600>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  80247b:	85 f6                	test   %esi,%esi
  80247d:	7e 46                	jle    8024c5 <spawn+0x1e1>
  80247f:	bb 00 00 00 00       	mov    $0x0,%ebx
  802484:	89 b5 8c fd ff ff    	mov    %esi,-0x274(%ebp)
  80248a:	8b 75 0c             	mov    0xc(%ebp),%esi
		argv_store[i] = UTEMP2USTACK(string_store);
  80248d:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  802493:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802499:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
		strcpy(string_store, argv[i]);
  80249c:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  80249f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a3:	89 3c 24             	mov    %edi,(%esp)
  8024a6:	e8 ff e8 ff ff       	call   800daa <strcpy>
		string_store += strlen(argv[i]) + 1;
  8024ab:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8024ae:	89 04 24             	mov    %eax,(%esp)
  8024b1:	e8 aa e8 ff ff       	call   800d60 <strlen>
  8024b6:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8024ba:	83 c3 01             	add    $0x1,%ebx
  8024bd:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  8024c3:	7c c8                	jl     80248d <spawn+0x1a9>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  8024c5:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  8024cb:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  8024d1:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8024d8:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  8024de:	74 24                	je     802504 <spawn+0x220>
  8024e0:	c7 44 24 0c 1c 3d 80 	movl   $0x803d1c,0xc(%esp)
  8024e7:	00 
  8024e8:	c7 44 24 08 c1 3c 80 	movl   $0x803cc1,0x8(%esp)
  8024ef:	00 
  8024f0:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  8024f7:	00 
  8024f8:	c7 04 24 d6 3c 80 00 	movl   $0x803cd6,(%esp)
  8024ff:	e8 04 e1 ff ff       	call   800608 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  802504:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80250a:	2d 00 30 80 11       	sub    $0x11803000,%eax
  80250f:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802515:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  802518:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  80251e:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  802524:	89 10                	mov    %edx,(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802526:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  80252c:	2d 08 30 80 11       	sub    $0x11803008,%eax
  802531:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802537:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80253e:	00 
  80253f:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  802546:	ee 
  802547:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80254d:	89 44 24 08          	mov    %eax,0x8(%esp)
  802551:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802558:	00 
  802559:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802560:	e8 43 ef ff ff       	call   8014a8 <sys_page_map>
  802565:	89 c3                	mov    %eax,%ebx
  802567:	85 c0                	test   %eax,%eax
  802569:	78 1a                	js     802585 <spawn+0x2a1>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80256b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802572:	00 
  802573:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80257a:	e8 cb ee ff ff       	call   80144a <sys_page_unmap>
  80257f:	89 c3                	mov    %eax,%ebx
  802581:	85 c0                	test   %eax,%eax
  802583:	79 19                	jns    80259e <spawn+0x2ba>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802585:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80258c:	00 
  80258d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802594:	e8 b1 ee ff ff       	call   80144a <sys_page_unmap>
  802599:	e9 46 03 00 00       	jmp    8028e4 <spawn+0x600>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80259e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8025a4:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  8025ab:	00 
  8025ac:	0f 84 e3 01 00 00    	je     802795 <spawn+0x4b1>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  8025b2:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  8025b9:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
  8025bf:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  8025c6:	00 00 00 
	for (i = 0; i < elf->e_phnum; i++, ph++) {
               // cprintf("\nHello\n");
		if (ph->p_type != ELF_PROG_LOAD)
  8025c9:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  8025cf:	83 3a 01             	cmpl   $0x1,(%edx)
  8025d2:	0f 85 9b 01 00 00    	jne    802773 <spawn+0x48f>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8025d8:	8b 42 18             	mov    0x18(%edx),%eax
  8025db:	83 e0 02             	and    $0x2,%eax
  8025de:	83 f8 01             	cmp    $0x1,%eax
  8025e1:	19 c0                	sbb    %eax,%eax
  8025e3:	83 e0 fe             	and    $0xfffffffe,%eax
  8025e6:	83 c0 07             	add    $0x7,%eax
  8025e9:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
  8025ef:	8b 52 04             	mov    0x4(%edx),%edx
  8025f2:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  8025f8:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8025fe:	8b 58 10             	mov    0x10(%eax),%ebx
  802601:	8b 50 14             	mov    0x14(%eax),%edx
  802604:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
  80260a:	8b 40 08             	mov    0x8(%eax),%eax
  80260d:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  802613:	25 ff 0f 00 00       	and    $0xfff,%eax
  802618:	74 16                	je     802630 <spawn+0x34c>
		va -= i;
  80261a:	29 85 90 fd ff ff    	sub    %eax,-0x270(%ebp)
		memsz += i;
  802620:	01 c2                	add    %eax,%edx
  802622:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
		filesz += i;
  802628:	01 c3                	add    %eax,%ebx
		fileoffset -= i;
  80262a:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  802630:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  802637:	0f 84 36 01 00 00    	je     802773 <spawn+0x48f>
  80263d:	bf 00 00 00 00       	mov    $0x0,%edi
  802642:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  802647:	39 fb                	cmp    %edi,%ebx
  802649:	77 31                	ja     80267c <spawn+0x398>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80264b:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802651:	89 54 24 08          	mov    %edx,0x8(%esp)
  802655:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  80265b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80265f:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802665:	89 04 24             	mov    %eax,(%esp)
  802668:	e8 99 ee ff ff       	call   801506 <sys_page_alloc>
  80266d:	85 c0                	test   %eax,%eax
  80266f:	0f 89 ea 00 00 00    	jns    80275f <spawn+0x47b>
  802675:	89 c3                	mov    %eax,%ebx
  802677:	e9 44 02 00 00       	jmp    8028c0 <spawn+0x5dc>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80267c:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802683:	00 
  802684:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80268b:	00 
  80268c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802693:	e8 6e ee ff ff       	call   801506 <sys_page_alloc>
  802698:	85 c0                	test   %eax,%eax
  80269a:	0f 88 16 02 00 00    	js     8028b6 <spawn+0x5d2>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8026a0:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  8026a6:	8d 04 16             	lea    (%esi,%edx,1),%eax
  8026a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026ad:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8026b3:	89 04 24             	mov    %eax,(%esp)
  8026b6:	e8 ea f3 ff ff       	call   801aa5 <seek>
  8026bb:	85 c0                	test   %eax,%eax
  8026bd:	0f 88 f7 01 00 00    	js     8028ba <spawn+0x5d6>
				return r;
			if ((r = read(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8026c3:	89 d8                	mov    %ebx,%eax
  8026c5:	29 f8                	sub    %edi,%eax
  8026c7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8026cc:	76 05                	jbe    8026d3 <spawn+0x3ef>
  8026ce:	b8 00 10 00 00       	mov    $0x1000,%eax
  8026d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8026d7:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8026de:	00 
  8026df:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  8026e5:	89 14 24             	mov    %edx,(%esp)
  8026e8:	e8 d1 f5 ff ff       	call   801cbe <read>
  8026ed:	85 c0                	test   %eax,%eax
  8026ef:	0f 88 c9 01 00 00    	js     8028be <spawn+0x5da>
				return r;
			//cprintf("\nvirtual address----->%x\n",va+i);
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8026f5:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8026fb:	89 44 24 10          	mov    %eax,0x10(%esp)
  8026ff:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  802705:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802709:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  80270f:	89 54 24 08          	mov    %edx,0x8(%esp)
  802713:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80271a:	00 
  80271b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802722:	e8 81 ed ff ff       	call   8014a8 <sys_page_map>
  802727:	85 c0                	test   %eax,%eax
  802729:	79 20                	jns    80274b <spawn+0x467>
				panic("spawn: sys_page_map data: %e", r);
  80272b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80272f:	c7 44 24 08 e2 3c 80 	movl   $0x803ce2,0x8(%esp)
  802736:	00 
  802737:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  80273e:	00 
  80273f:	c7 04 24 d6 3c 80 00 	movl   $0x803cd6,(%esp)
  802746:	e8 bd de ff ff       	call   800608 <_panic>
			sys_page_unmap(0, UTEMP);
  80274b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802752:	00 
  802753:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80275a:	e8 eb ec ff ff       	call   80144a <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80275f:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802765:	89 f7                	mov    %esi,%edi
  802767:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  80276d:	0f 87 d4 fe ff ff    	ja     802647 <spawn+0x363>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802773:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  80277a:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802781:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  802787:	7e 0c                	jle    802795 <spawn+0x4b1>
  802789:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  802790:	e9 34 fe ff ff       	jmp    8025c9 <spawn+0x2e5>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802795:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  80279b:	89 04 24             	mov    %eax,(%esp)
  80279e:	e8 7b f6 ff ff       	call   801e1e <close>
  8027a3:	bb 00 00 80 00       	mov    $0x800000,%ebx
duplicateSharepage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
        pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  8027a8:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
       
        if( 0 == pgDirEntry )
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  8027ad:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	// LAB 7: Your code here.
	uint8_t *addr;
	extern unsigned char end[];
	for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
                {    
			duplicateSharepage(child, VPN(addr));
  8027b2:	89 d8                	mov    %ebx,%eax
  8027b4:	c1 e8 0c             	shr    $0xc,%eax
duplicateSharepage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
        pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  8027b7:	89 c2                	mov    %eax,%edx
  8027b9:	c1 e2 0c             	shl    $0xc,%edx
  8027bc:	89 d1                	mov    %edx,%ecx
  8027be:	c1 e9 16             	shr    $0x16,%ecx
  8027c1:	8b 0c 8e             	mov    (%esi,%ecx,4),%ecx
       
        if( 0 == pgDirEntry )
  8027c4:	85 c9                	test   %ecx,%ecx
  8027c6:	74 66                	je     80282e <spawn+0x54a>
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  8027c8:	8b 04 87             	mov    (%edi,%eax,4),%eax
  8027cb:	89 c1                	mov    %eax,%ecx
  8027cd:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
        //cprintf("Below %d",vpt[pn]);
                //if(perm!=0)  //commented nw.
                   // cprintf("perm bit %d",perm);
	//cprintf("\nInside Spawn setting share\n");
	if((perm & PTE_W) && (perm & PTE_SHARE))
  8027d3:	25 02 04 00 00       	and    $0x402,%eax
  8027d8:	3d 02 04 00 00       	cmp    $0x402,%eax
  8027dd:	75 4f                	jne    80282e <spawn+0x54a>
	{
		if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_SHARE|(perm & PTE_USER))) < 0)
  8027df:	81 e1 07 0a 00 00    	and    $0xa07,%ecx
  8027e5:	80 cd 04             	or     $0x4,%ch
  8027e8:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  8027ec:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8027f0:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8027f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027fa:	89 54 24 04          	mov    %edx,0x4(%esp)
  8027fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802805:	e8 9e ec ff ff       	call   8014a8 <sys_page_map>
  80280a:	85 c0                	test   %eax,%eax
  80280c:	79 20                	jns    80282e <spawn+0x54a>
                panic("sys_page_map: %e", r);
  80280e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802812:	c7 44 24 08 6b 3b 80 	movl   $0x803b6b,0x8(%esp)
  802819:	00 
  80281a:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  802821:	00 
  802822:	c7 04 24 d6 3c 80 00 	movl   $0x803cd6,(%esp)
  802829:	e8 da dd ff ff       	call   800608 <_panic>
copy_shared_pages(envid_t child)
{
	// LAB 7: Your code here.
	uint8_t *addr;
	extern unsigned char end[];
	for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
  80282e:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802834:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  80283a:	0f 85 72 ff ff ff    	jne    8027b2 <spawn+0x4ce>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802840:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802846:	89 44 24 04          	mov    %eax,0x4(%esp)
  80284a:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  802850:	89 14 24             	mov    %edx,(%esp)
  802853:	e8 36 eb ff ff       	call   80138e <sys_env_set_trapframe>
  802858:	85 c0                	test   %eax,%eax
  80285a:	79 20                	jns    80287c <spawn+0x598>
		panic("sys_env_set_trapframe: %e", r);
  80285c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802860:	c7 44 24 08 ff 3c 80 	movl   $0x803cff,0x8(%esp)
  802867:	00 
  802868:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  80286f:	00 
  802870:	c7 04 24 d6 3c 80 00 	movl   $0x803cd6,(%esp)
  802877:	e8 8c dd ff ff       	call   800608 <_panic>
                   //    cprintf("\nHello below trpaframe%d\n",elf->e_phnum);
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80287c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802883:	00 
  802884:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80288a:	89 04 24             	mov    %eax,(%esp)
  80288d:	e8 5a eb ff ff       	call   8013ec <sys_env_set_status>
  802892:	85 c0                	test   %eax,%eax
  802894:	79 48                	jns    8028de <spawn+0x5fa>
		panic("sys_env_set_status: %e", r);
  802896:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80289a:	c7 44 24 08 9f 3b 80 	movl   $0x803b9f,0x8(%esp)
  8028a1:	00 
  8028a2:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  8028a9:	00 
  8028aa:	c7 04 24 d6 3c 80 00 	movl   $0x803cd6,(%esp)
  8028b1:	e8 52 dd ff ff       	call   800608 <_panic>
  8028b6:	89 c3                	mov    %eax,%ebx
  8028b8:	eb 06                	jmp    8028c0 <spawn+0x5dc>
  8028ba:	89 c3                	mov    %eax,%ebx
  8028bc:	eb 02                	jmp    8028c0 <spawn+0x5dc>
  8028be:	89 c3                	mov    %eax,%ebx

	return child;

error:
	sys_env_destroy(child);
  8028c0:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  8028c6:	89 14 24             	mov    %edx,(%esp)
  8028c9:	e8 ff ec ff ff       	call   8015cd <sys_env_destroy>
	close(fd);
  8028ce:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  8028d4:	89 04 24             	mov    %eax,(%esp)
  8028d7:	e8 42 f5 ff ff       	call   801e1e <close>
	return r;
  8028dc:	eb 06                	jmp    8028e4 <spawn+0x600>
  8028de:	8b 9d 88 fd ff ff    	mov    -0x278(%ebp),%ebx
}
  8028e4:	89 d8                	mov    %ebx,%eax
  8028e6:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  8028ec:	5b                   	pop    %ebx
  8028ed:	5e                   	pop    %esi
  8028ee:	5f                   	pop    %edi
  8028ef:	5d                   	pop    %ebp
  8028f0:	c3                   	ret    

008028f1 <spawnl>:

// Spawn, taking command-line arguments array directly on the stack.
int
spawnl(const char *prog, const char *arg0, ...)
{
  8028f1:	55                   	push   %ebp
  8028f2:	89 e5                	mov    %esp,%ebp
  8028f4:	83 ec 18             	sub    $0x18,%esp
	return spawn(prog, &arg0);
  8028f7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8028fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802901:	89 04 24             	mov    %eax,(%esp)
  802904:	e8 db f9 ff ff       	call   8022e4 <spawn>
}
  802909:	c9                   	leave  
  80290a:	c3                   	ret    
  80290b:	00 00                	add    %al,(%eax)
  80290d:	00 00                	add    %al,(%eax)
	...

00802910 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802910:	55                   	push   %ebp
  802911:	89 e5                	mov    %esp,%ebp
  802913:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802916:	c7 44 24 04 44 3d 80 	movl   $0x803d44,0x4(%esp)
  80291d:	00 
  80291e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802921:	89 04 24             	mov    %eax,(%esp)
  802924:	e8 81 e4 ff ff       	call   800daa <strcpy>
	return 0;
}
  802929:	b8 00 00 00 00       	mov    $0x0,%eax
  80292e:	c9                   	leave  
  80292f:	c3                   	ret    

00802930 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802930:	55                   	push   %ebp
  802931:	89 e5                	mov    %esp,%ebp
  802933:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  802936:	8b 45 08             	mov    0x8(%ebp),%eax
  802939:	8b 40 0c             	mov    0xc(%eax),%eax
  80293c:	89 04 24             	mov    %eax,(%esp)
  80293f:	e8 9e 02 00 00       	call   802be2 <nsipc_close>
}
  802944:	c9                   	leave  
  802945:	c3                   	ret    

00802946 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802946:	55                   	push   %ebp
  802947:	89 e5                	mov    %esp,%ebp
  802949:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80294c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802953:	00 
  802954:	8b 45 10             	mov    0x10(%ebp),%eax
  802957:	89 44 24 08          	mov    %eax,0x8(%esp)
  80295b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80295e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802962:	8b 45 08             	mov    0x8(%ebp),%eax
  802965:	8b 40 0c             	mov    0xc(%eax),%eax
  802968:	89 04 24             	mov    %eax,(%esp)
  80296b:	e8 ae 02 00 00       	call   802c1e <nsipc_send>
}
  802970:	c9                   	leave  
  802971:	c3                   	ret    

00802972 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802972:	55                   	push   %ebp
  802973:	89 e5                	mov    %esp,%ebp
  802975:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802978:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80297f:	00 
  802980:	8b 45 10             	mov    0x10(%ebp),%eax
  802983:	89 44 24 08          	mov    %eax,0x8(%esp)
  802987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80298a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80298e:	8b 45 08             	mov    0x8(%ebp),%eax
  802991:	8b 40 0c             	mov    0xc(%eax),%eax
  802994:	89 04 24             	mov    %eax,(%esp)
  802997:	e8 f5 02 00 00       	call   802c91 <nsipc_recv>
}
  80299c:	c9                   	leave  
  80299d:	c3                   	ret    

0080299e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  80299e:	55                   	push   %ebp
  80299f:	89 e5                	mov    %esp,%ebp
  8029a1:	56                   	push   %esi
  8029a2:	53                   	push   %ebx
  8029a3:	83 ec 20             	sub    $0x20,%esp
  8029a6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8029a8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8029ab:	89 04 24             	mov    %eax,(%esp)
  8029ae:	e8 38 f0 ff ff       	call   8019eb <fd_alloc>
  8029b3:	89 c3                	mov    %eax,%ebx
  8029b5:	85 c0                	test   %eax,%eax
  8029b7:	78 21                	js     8029da <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  8029b9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8029c0:	00 
  8029c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029cf:	e8 32 eb ff ff       	call   801506 <sys_page_alloc>
  8029d4:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8029d6:	85 c0                	test   %eax,%eax
  8029d8:	79 0a                	jns    8029e4 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  8029da:	89 34 24             	mov    %esi,(%esp)
  8029dd:	e8 00 02 00 00       	call   802be2 <nsipc_close>
		return r;
  8029e2:	eb 28                	jmp    802a0c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8029e4:	8b 15 3c 70 80 00    	mov    0x80703c,%edx
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8029f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fc:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8029ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a02:	89 04 24             	mov    %eax,(%esp)
  802a05:	e8 b6 ef ff ff       	call   8019c0 <fd2num>
  802a0a:	89 c3                	mov    %eax,%ebx
}
  802a0c:	89 d8                	mov    %ebx,%eax
  802a0e:	83 c4 20             	add    $0x20,%esp
  802a11:	5b                   	pop    %ebx
  802a12:	5e                   	pop    %esi
  802a13:	5d                   	pop    %ebp
  802a14:	c3                   	ret    

00802a15 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802a15:	55                   	push   %ebp
  802a16:	89 e5                	mov    %esp,%ebp
  802a18:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  802a1b:	8b 45 10             	mov    0x10(%ebp),%eax
  802a1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a25:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	89 04 24             	mov    %eax,(%esp)
  802a2f:	e8 62 01 00 00       	call   802b96 <nsipc_socket>
  802a34:	85 c0                	test   %eax,%eax
  802a36:	78 05                	js     802a3d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802a38:	e8 61 ff ff ff       	call   80299e <alloc_sockfd>
}
  802a3d:	c9                   	leave  
  802a3e:	66 90                	xchg   %ax,%ax
  802a40:	c3                   	ret    

00802a41 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802a41:	55                   	push   %ebp
  802a42:	89 e5                	mov    %esp,%ebp
  802a44:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802a47:	8d 55 f4             	lea    -0xc(%ebp),%edx
  802a4a:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a4e:	89 04 24             	mov    %eax,(%esp)
  802a51:	e8 07 f0 ff ff       	call   801a5d <fd_lookup>
  802a56:	85 c0                	test   %eax,%eax
  802a58:	78 15                	js     802a6f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  802a5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a5d:	8b 0a                	mov    (%edx),%ecx
  802a5f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802a64:	3b 0d 3c 70 80 00    	cmp    0x80703c,%ecx
  802a6a:	75 03                	jne    802a6f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  802a6c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  802a6f:	c9                   	leave  
  802a70:	c3                   	ret    

00802a71 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802a71:	55                   	push   %ebp
  802a72:	89 e5                	mov    %esp,%ebp
  802a74:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	e8 c2 ff ff ff       	call   802a41 <fd2sockid>
  802a7f:	85 c0                	test   %eax,%eax
  802a81:	78 0f                	js     802a92 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  802a83:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a86:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a8a:	89 04 24             	mov    %eax,(%esp)
  802a8d:	e8 2e 01 00 00       	call   802bc0 <nsipc_listen>
}
  802a92:	c9                   	leave  
  802a93:	c3                   	ret    

00802a94 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802a94:	55                   	push   %ebp
  802a95:	89 e5                	mov    %esp,%ebp
  802a97:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	e8 9f ff ff ff       	call   802a41 <fd2sockid>
  802aa2:	85 c0                	test   %eax,%eax
  802aa4:	78 16                	js     802abc <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802aa6:	8b 55 10             	mov    0x10(%ebp),%edx
  802aa9:	89 54 24 08          	mov    %edx,0x8(%esp)
  802aad:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ab0:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ab4:	89 04 24             	mov    %eax,(%esp)
  802ab7:	e8 55 02 00 00       	call   802d11 <nsipc_connect>
}
  802abc:	c9                   	leave  
  802abd:	c3                   	ret    

00802abe <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  802abe:	55                   	push   %ebp
  802abf:	89 e5                	mov    %esp,%ebp
  802ac1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac7:	e8 75 ff ff ff       	call   802a41 <fd2sockid>
  802acc:	85 c0                	test   %eax,%eax
  802ace:	78 0f                	js     802adf <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802ad0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ad3:	89 54 24 04          	mov    %edx,0x4(%esp)
  802ad7:	89 04 24             	mov    %eax,(%esp)
  802ada:	e8 1d 01 00 00       	call   802bfc <nsipc_shutdown>
}
  802adf:	c9                   	leave  
  802ae0:	c3                   	ret    

00802ae1 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802ae1:	55                   	push   %ebp
  802ae2:	89 e5                	mov    %esp,%ebp
  802ae4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	e8 52 ff ff ff       	call   802a41 <fd2sockid>
  802aef:	85 c0                	test   %eax,%eax
  802af1:	78 16                	js     802b09 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802af3:	8b 55 10             	mov    0x10(%ebp),%edx
  802af6:	89 54 24 08          	mov    %edx,0x8(%esp)
  802afa:	8b 55 0c             	mov    0xc(%ebp),%edx
  802afd:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b01:	89 04 24             	mov    %eax,(%esp)
  802b04:	e8 47 02 00 00       	call   802d50 <nsipc_bind>
}
  802b09:	c9                   	leave  
  802b0a:	c3                   	ret    

00802b0b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802b0b:	55                   	push   %ebp
  802b0c:	89 e5                	mov    %esp,%ebp
  802b0e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	e8 28 ff ff ff       	call   802a41 <fd2sockid>
  802b19:	85 c0                	test   %eax,%eax
  802b1b:	78 1f                	js     802b3c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  802b1d:	8b 55 10             	mov    0x10(%ebp),%edx
  802b20:	89 54 24 08          	mov    %edx,0x8(%esp)
  802b24:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b27:	89 54 24 04          	mov    %edx,0x4(%esp)
  802b2b:	89 04 24             	mov    %eax,(%esp)
  802b2e:	e8 5c 02 00 00       	call   802d8f <nsipc_accept>
  802b33:	85 c0                	test   %eax,%eax
  802b35:	78 05                	js     802b3c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802b37:	e8 62 fe ff ff       	call   80299e <alloc_sockfd>
}
  802b3c:	c9                   	leave  
  802b3d:	8d 76 00             	lea    0x0(%esi),%esi
  802b40:	c3                   	ret    
	...

00802b50 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802b50:	55                   	push   %ebp
  802b51:	89 e5                	mov    %esp,%ebp
  802b53:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802b56:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  802b5c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802b63:	00 
  802b64:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  802b6b:	00 
  802b6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b70:	89 14 24             	mov    %edx,(%esp)
  802b73:	e8 58 07 00 00       	call   8032d0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802b78:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802b7f:	00 
  802b80:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802b87:	00 
  802b88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b8f:	e8 9e 07 00 00       	call   803332 <ipc_recv>
}
  802b94:	c9                   	leave  
  802b95:	c3                   	ret    

00802b96 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  802b96:	55                   	push   %ebp
  802b97:	89 e5                	mov    %esp,%ebp
  802b99:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  802b9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802ba4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ba7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  802bac:	8b 45 10             	mov    0x10(%ebp),%eax
  802baf:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802bb4:	b8 09 00 00 00       	mov    $0x9,%eax
  802bb9:	e8 92 ff ff ff       	call   802b50 <nsipc>
}
  802bbe:	c9                   	leave  
  802bbf:	c3                   	ret    

00802bc0 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802bc0:	55                   	push   %ebp
  802bc1:	89 e5                	mov    %esp,%ebp
  802bc3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  802bce:	8b 45 0c             	mov    0xc(%ebp),%eax
  802bd1:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802bd6:	b8 06 00 00 00       	mov    $0x6,%eax
  802bdb:	e8 70 ff ff ff       	call   802b50 <nsipc>
}
  802be0:	c9                   	leave  
  802be1:	c3                   	ret    

00802be2 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802be2:	55                   	push   %ebp
  802be3:	89 e5                	mov    %esp,%ebp
  802be5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802bf0:	b8 04 00 00 00       	mov    $0x4,%eax
  802bf5:	e8 56 ff ff ff       	call   802b50 <nsipc>
}
  802bfa:	c9                   	leave  
  802bfb:	c3                   	ret    

00802bfc <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  802bfc:	55                   	push   %ebp
  802bfd:	89 e5                	mov    %esp,%ebp
  802bff:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  802c0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c0d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802c12:	b8 03 00 00 00       	mov    $0x3,%eax
  802c17:	e8 34 ff ff ff       	call   802b50 <nsipc>
}
  802c1c:	c9                   	leave  
  802c1d:	c3                   	ret    

00802c1e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  802c1e:	55                   	push   %ebp
  802c1f:	89 e5                	mov    %esp,%ebp
  802c21:	53                   	push   %ebx
  802c22:	83 ec 14             	sub    $0x14,%esp
  802c25:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802c28:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802c30:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802c36:	7e 24                	jle    802c5c <nsipc_send+0x3e>
  802c38:	c7 44 24 0c 50 3d 80 	movl   $0x803d50,0xc(%esp)
  802c3f:	00 
  802c40:	c7 44 24 08 c1 3c 80 	movl   $0x803cc1,0x8(%esp)
  802c47:	00 
  802c48:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  802c4f:	00 
  802c50:	c7 04 24 5c 3d 80 00 	movl   $0x803d5c,(%esp)
  802c57:	e8 ac d9 ff ff       	call   800608 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  802c5c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c63:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c67:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  802c6e:	e8 f2 e2 ff ff       	call   800f65 <memmove>
	nsipcbuf.send.req_size = size;
  802c73:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802c79:	8b 45 14             	mov    0x14(%ebp),%eax
  802c7c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802c81:	b8 08 00 00 00       	mov    $0x8,%eax
  802c86:	e8 c5 fe ff ff       	call   802b50 <nsipc>
}
  802c8b:	83 c4 14             	add    $0x14,%esp
  802c8e:	5b                   	pop    %ebx
  802c8f:	5d                   	pop    %ebp
  802c90:	c3                   	ret    

00802c91 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802c91:	55                   	push   %ebp
  802c92:	89 e5                	mov    %esp,%ebp
  802c94:	56                   	push   %esi
  802c95:	53                   	push   %ebx
  802c96:	83 ec 10             	sub    $0x10,%esp
  802c99:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  802c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802ca4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  802caa:	8b 45 14             	mov    0x14(%ebp),%eax
  802cad:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802cb2:	b8 07 00 00 00       	mov    $0x7,%eax
  802cb7:	e8 94 fe ff ff       	call   802b50 <nsipc>
  802cbc:	89 c3                	mov    %eax,%ebx
  802cbe:	85 c0                	test   %eax,%eax
  802cc0:	78 46                	js     802d08 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802cc2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802cc7:	7f 04                	jg     802ccd <nsipc_recv+0x3c>
  802cc9:	39 c6                	cmp    %eax,%esi
  802ccb:	7d 24                	jge    802cf1 <nsipc_recv+0x60>
  802ccd:	c7 44 24 0c 68 3d 80 	movl   $0x803d68,0xc(%esp)
  802cd4:	00 
  802cd5:	c7 44 24 08 c1 3c 80 	movl   $0x803cc1,0x8(%esp)
  802cdc:	00 
  802cdd:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802ce4:	00 
  802ce5:	c7 04 24 5c 3d 80 00 	movl   $0x803d5c,(%esp)
  802cec:	e8 17 d9 ff ff       	call   800608 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802cf1:	89 44 24 08          	mov    %eax,0x8(%esp)
  802cf5:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802cfc:	00 
  802cfd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d00:	89 04 24             	mov    %eax,(%esp)
  802d03:	e8 5d e2 ff ff       	call   800f65 <memmove>
	}

	return r;
}
  802d08:	89 d8                	mov    %ebx,%eax
  802d0a:	83 c4 10             	add    $0x10,%esp
  802d0d:	5b                   	pop    %ebx
  802d0e:	5e                   	pop    %esi
  802d0f:	5d                   	pop    %ebp
  802d10:	c3                   	ret    

00802d11 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802d11:	55                   	push   %ebp
  802d12:	89 e5                	mov    %esp,%ebp
  802d14:	53                   	push   %ebx
  802d15:	83 ec 14             	sub    $0x14,%esp
  802d18:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802d23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d2e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802d35:	e8 2b e2 ff ff       	call   800f65 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  802d3a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802d40:	b8 05 00 00 00       	mov    $0x5,%eax
  802d45:	e8 06 fe ff ff       	call   802b50 <nsipc>
}
  802d4a:	83 c4 14             	add    $0x14,%esp
  802d4d:	5b                   	pop    %ebx
  802d4e:	5d                   	pop    %ebp
  802d4f:	c3                   	ret    

00802d50 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802d50:	55                   	push   %ebp
  802d51:	89 e5                	mov    %esp,%ebp
  802d53:	53                   	push   %ebx
  802d54:	83 ec 14             	sub    $0x14,%esp
  802d57:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802d62:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d66:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d69:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d6d:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802d74:	e8 ec e1 ff ff       	call   800f65 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802d79:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  802d7f:	b8 02 00 00 00       	mov    $0x2,%eax
  802d84:	e8 c7 fd ff ff       	call   802b50 <nsipc>
}
  802d89:	83 c4 14             	add    $0x14,%esp
  802d8c:	5b                   	pop    %ebx
  802d8d:	5d                   	pop    %ebp
  802d8e:	c3                   	ret    

00802d8f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  802d8f:	55                   	push   %ebp
  802d90:	89 e5                	mov    %esp,%ebp
  802d92:	83 ec 18             	sub    $0x18,%esp
  802d95:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802d98:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  802d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802da3:	b8 01 00 00 00       	mov    $0x1,%eax
  802da8:	e8 a3 fd ff ff       	call   802b50 <nsipc>
  802dad:	89 c3                	mov    %eax,%ebx
  802daf:	85 c0                	test   %eax,%eax
  802db1:	78 25                	js     802dd8 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802db3:	be 10 60 80 00       	mov    $0x806010,%esi
  802db8:	8b 06                	mov    (%esi),%eax
  802dba:	89 44 24 08          	mov    %eax,0x8(%esp)
  802dbe:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802dc5:	00 
  802dc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  802dc9:	89 04 24             	mov    %eax,(%esp)
  802dcc:	e8 94 e1 ff ff       	call   800f65 <memmove>
		*addrlen = ret->ret_addrlen;
  802dd1:	8b 16                	mov    (%esi),%edx
  802dd3:	8b 45 10             	mov    0x10(%ebp),%eax
  802dd6:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802dd8:	89 d8                	mov    %ebx,%eax
  802dda:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802ddd:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802de0:	89 ec                	mov    %ebp,%esp
  802de2:	5d                   	pop    %ebp
  802de3:	c3                   	ret    
	...

00802df0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802df0:	55                   	push   %ebp
  802df1:	89 e5                	mov    %esp,%ebp
  802df3:	83 ec 18             	sub    $0x18,%esp
  802df6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802df9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802dfc:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	89 04 24             	mov    %eax,(%esp)
  802e05:	e8 c6 eb ff ff       	call   8019d0 <fd2data>
  802e0a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  802e0c:	c7 44 24 04 7d 3d 80 	movl   $0x803d7d,0x4(%esp)
  802e13:	00 
  802e14:	89 34 24             	mov    %esi,(%esp)
  802e17:	e8 8e df ff ff       	call   800daa <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802e1c:	8b 43 04             	mov    0x4(%ebx),%eax
  802e1f:	2b 03                	sub    (%ebx),%eax
  802e21:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802e27:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  802e2e:	00 00 00 
	stat->st_dev = &devpipe;
  802e31:	c7 86 88 00 00 00 58 	movl   $0x807058,0x88(%esi)
  802e38:	70 80 00 
	return 0;
}
  802e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  802e40:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802e43:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802e46:	89 ec                	mov    %ebp,%esp
  802e48:	5d                   	pop    %ebp
  802e49:	c3                   	ret    

00802e4a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802e4a:	55                   	push   %ebp
  802e4b:	89 e5                	mov    %esp,%ebp
  802e4d:	53                   	push   %ebx
  802e4e:	83 ec 14             	sub    $0x14,%esp
  802e51:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802e54:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802e58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e5f:	e8 e6 e5 ff ff       	call   80144a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802e64:	89 1c 24             	mov    %ebx,(%esp)
  802e67:	e8 64 eb ff ff       	call   8019d0 <fd2data>
  802e6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e77:	e8 ce e5 ff ff       	call   80144a <sys_page_unmap>
}
  802e7c:	83 c4 14             	add    $0x14,%esp
  802e7f:	5b                   	pop    %ebx
  802e80:	5d                   	pop    %ebp
  802e81:	c3                   	ret    

00802e82 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802e82:	55                   	push   %ebp
  802e83:	89 e5                	mov    %esp,%ebp
  802e85:	57                   	push   %edi
  802e86:	56                   	push   %esi
  802e87:	53                   	push   %ebx
  802e88:	83 ec 2c             	sub    $0x2c,%esp
  802e8b:	89 c7                	mov    %eax,%edi
  802e8d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802e90:	a1 74 70 80 00       	mov    0x807074,%eax
  802e95:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802e98:	89 3c 24             	mov    %edi,(%esp)
  802e9b:	e8 f8 04 00 00       	call   803398 <pageref>
  802ea0:	89 c6                	mov    %eax,%esi
  802ea2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea5:	89 04 24             	mov    %eax,(%esp)
  802ea8:	e8 eb 04 00 00       	call   803398 <pageref>
  802ead:	39 c6                	cmp    %eax,%esi
  802eaf:	0f 94 c0             	sete   %al
  802eb2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802eb5:	8b 15 74 70 80 00    	mov    0x807074,%edx
  802ebb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802ebe:	39 cb                	cmp    %ecx,%ebx
  802ec0:	75 08                	jne    802eca <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802ec2:	83 c4 2c             	add    $0x2c,%esp
  802ec5:	5b                   	pop    %ebx
  802ec6:	5e                   	pop    %esi
  802ec7:	5f                   	pop    %edi
  802ec8:	5d                   	pop    %ebp
  802ec9:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  802eca:	83 f8 01             	cmp    $0x1,%eax
  802ecd:	75 c1                	jne    802e90 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  802ecf:	8b 52 58             	mov    0x58(%edx),%edx
  802ed2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802ed6:	89 54 24 08          	mov    %edx,0x8(%esp)
  802eda:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802ede:	c7 04 24 84 3d 80 00 	movl   $0x803d84,(%esp)
  802ee5:	e8 e3 d7 ff ff       	call   8006cd <cprintf>
  802eea:	eb a4                	jmp    802e90 <_pipeisclosed+0xe>

00802eec <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802eec:	55                   	push   %ebp
  802eed:	89 e5                	mov    %esp,%ebp
  802eef:	57                   	push   %edi
  802ef0:	56                   	push   %esi
  802ef1:	53                   	push   %ebx
  802ef2:	83 ec 1c             	sub    $0x1c,%esp
  802ef5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802ef8:	89 34 24             	mov    %esi,(%esp)
  802efb:	e8 d0 ea ff ff       	call   8019d0 <fd2data>
  802f00:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f02:	bf 00 00 00 00       	mov    $0x0,%edi
  802f07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802f0b:	75 54                	jne    802f61 <devpipe_write+0x75>
  802f0d:	eb 60                	jmp    802f6f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  802f0f:	89 da                	mov    %ebx,%edx
  802f11:	89 f0                	mov    %esi,%eax
  802f13:	e8 6a ff ff ff       	call   802e82 <_pipeisclosed>
  802f18:	85 c0                	test   %eax,%eax
  802f1a:	74 07                	je     802f23 <devpipe_write+0x37>
  802f1c:	b8 00 00 00 00       	mov    $0x0,%eax
  802f21:	eb 53                	jmp    802f76 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802f23:	90                   	nop
  802f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f28:	e8 38 e6 ff ff       	call   801565 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802f2d:	8b 43 04             	mov    0x4(%ebx),%eax
  802f30:	8b 13                	mov    (%ebx),%edx
  802f32:	83 c2 20             	add    $0x20,%edx
  802f35:	39 d0                	cmp    %edx,%eax
  802f37:	73 d6                	jae    802f0f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802f39:	89 c2                	mov    %eax,%edx
  802f3b:	c1 fa 1f             	sar    $0x1f,%edx
  802f3e:	c1 ea 1b             	shr    $0x1b,%edx
  802f41:	01 d0                	add    %edx,%eax
  802f43:	83 e0 1f             	and    $0x1f,%eax
  802f46:	29 d0                	sub    %edx,%eax
  802f48:	89 c2                	mov    %eax,%edx
  802f4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802f4d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802f51:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802f55:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f59:	83 c7 01             	add    $0x1,%edi
  802f5c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  802f5f:	76 13                	jbe    802f74 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802f61:	8b 43 04             	mov    0x4(%ebx),%eax
  802f64:	8b 13                	mov    (%ebx),%edx
  802f66:	83 c2 20             	add    $0x20,%edx
  802f69:	39 d0                	cmp    %edx,%eax
  802f6b:	73 a2                	jae    802f0f <devpipe_write+0x23>
  802f6d:	eb ca                	jmp    802f39 <devpipe_write+0x4d>
  802f6f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802f74:	89 f8                	mov    %edi,%eax
}
  802f76:	83 c4 1c             	add    $0x1c,%esp
  802f79:	5b                   	pop    %ebx
  802f7a:	5e                   	pop    %esi
  802f7b:	5f                   	pop    %edi
  802f7c:	5d                   	pop    %ebp
  802f7d:	c3                   	ret    

00802f7e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802f7e:	55                   	push   %ebp
  802f7f:	89 e5                	mov    %esp,%ebp
  802f81:	83 ec 28             	sub    $0x28,%esp
  802f84:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802f87:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802f8a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802f8d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802f90:	89 3c 24             	mov    %edi,(%esp)
  802f93:	e8 38 ea ff ff       	call   8019d0 <fd2data>
  802f98:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802f9a:	be 00 00 00 00       	mov    $0x0,%esi
  802f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802fa3:	75 4c                	jne    802ff1 <devpipe_read+0x73>
  802fa5:	eb 5b                	jmp    803002 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802fa7:	89 f0                	mov    %esi,%eax
  802fa9:	eb 5e                	jmp    803009 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802fab:	89 da                	mov    %ebx,%edx
  802fad:	89 f8                	mov    %edi,%eax
  802faf:	90                   	nop
  802fb0:	e8 cd fe ff ff       	call   802e82 <_pipeisclosed>
  802fb5:	85 c0                	test   %eax,%eax
  802fb7:	74 07                	je     802fc0 <devpipe_read+0x42>
  802fb9:	b8 00 00 00 00       	mov    $0x0,%eax
  802fbe:	eb 49                	jmp    803009 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802fc0:	e8 a0 e5 ff ff       	call   801565 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802fc5:	8b 03                	mov    (%ebx),%eax
  802fc7:	3b 43 04             	cmp    0x4(%ebx),%eax
  802fca:	74 df                	je     802fab <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802fcc:	89 c2                	mov    %eax,%edx
  802fce:	c1 fa 1f             	sar    $0x1f,%edx
  802fd1:	c1 ea 1b             	shr    $0x1b,%edx
  802fd4:	01 d0                	add    %edx,%eax
  802fd6:	83 e0 1f             	and    $0x1f,%eax
  802fd9:	29 d0                	sub    %edx,%eax
  802fdb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802fe0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802fe3:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802fe6:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802fe9:	83 c6 01             	add    $0x1,%esi
  802fec:	39 75 10             	cmp    %esi,0x10(%ebp)
  802fef:	76 16                	jbe    803007 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802ff1:	8b 03                	mov    (%ebx),%eax
  802ff3:	3b 43 04             	cmp    0x4(%ebx),%eax
  802ff6:	75 d4                	jne    802fcc <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802ff8:	85 f6                	test   %esi,%esi
  802ffa:	75 ab                	jne    802fa7 <devpipe_read+0x29>
  802ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803000:	eb a9                	jmp    802fab <devpipe_read+0x2d>
  803002:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  803007:	89 f0                	mov    %esi,%eax
}
  803009:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80300c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80300f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  803012:	89 ec                	mov    %ebp,%esp
  803014:	5d                   	pop    %ebp
  803015:	c3                   	ret    

00803016 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  803016:	55                   	push   %ebp
  803017:	89 e5                	mov    %esp,%ebp
  803019:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80301c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80301f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803023:	8b 45 08             	mov    0x8(%ebp),%eax
  803026:	89 04 24             	mov    %eax,(%esp)
  803029:	e8 2f ea ff ff       	call   801a5d <fd_lookup>
  80302e:	85 c0                	test   %eax,%eax
  803030:	78 15                	js     803047 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  803032:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803035:	89 04 24             	mov    %eax,(%esp)
  803038:	e8 93 e9 ff ff       	call   8019d0 <fd2data>
	return _pipeisclosed(fd, p);
  80303d:	89 c2                	mov    %eax,%edx
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	e8 3b fe ff ff       	call   802e82 <_pipeisclosed>
}
  803047:	c9                   	leave  
  803048:	c3                   	ret    

00803049 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  803049:	55                   	push   %ebp
  80304a:	89 e5                	mov    %esp,%ebp
  80304c:	83 ec 48             	sub    $0x48,%esp
  80304f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  803052:	89 75 f8             	mov    %esi,-0x8(%ebp)
  803055:	89 7d fc             	mov    %edi,-0x4(%ebp)
  803058:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80305b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80305e:	89 04 24             	mov    %eax,(%esp)
  803061:	e8 85 e9 ff ff       	call   8019eb <fd_alloc>
  803066:	89 c3                	mov    %eax,%ebx
  803068:	85 c0                	test   %eax,%eax
  80306a:	0f 88 42 01 00 00    	js     8031b2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803070:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  803077:	00 
  803078:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80307b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80307f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803086:	e8 7b e4 ff ff       	call   801506 <sys_page_alloc>
  80308b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80308d:	85 c0                	test   %eax,%eax
  80308f:	0f 88 1d 01 00 00    	js     8031b2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  803095:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803098:	89 04 24             	mov    %eax,(%esp)
  80309b:	e8 4b e9 ff ff       	call   8019eb <fd_alloc>
  8030a0:	89 c3                	mov    %eax,%ebx
  8030a2:	85 c0                	test   %eax,%eax
  8030a4:	0f 88 f5 00 00 00    	js     80319f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030aa:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8030b1:	00 
  8030b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030c0:	e8 41 e4 ff ff       	call   801506 <sys_page_alloc>
  8030c5:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8030c7:	85 c0                	test   %eax,%eax
  8030c9:	0f 88 d0 00 00 00    	js     80319f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8030cf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d2:	89 04 24             	mov    %eax,(%esp)
  8030d5:	e8 f6 e8 ff ff       	call   8019d0 <fd2data>
  8030da:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030dc:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8030e3:	00 
  8030e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8030e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8030ef:	e8 12 e4 ff ff       	call   801506 <sys_page_alloc>
  8030f4:	89 c3                	mov    %eax,%ebx
  8030f6:	85 c0                	test   %eax,%eax
  8030f8:	0f 88 8e 00 00 00    	js     80318c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8030fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803101:	89 04 24             	mov    %eax,(%esp)
  803104:	e8 c7 e8 ff ff       	call   8019d0 <fd2data>
  803109:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  803110:	00 
  803111:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803115:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80311c:	00 
  80311d:	89 74 24 04          	mov    %esi,0x4(%esp)
  803121:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803128:	e8 7b e3 ff ff       	call   8014a8 <sys_page_map>
  80312d:	89 c3                	mov    %eax,%ebx
  80312f:	85 c0                	test   %eax,%eax
  803131:	78 49                	js     80317c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  803133:	b8 58 70 80 00       	mov    $0x807058,%eax
  803138:	8b 08                	mov    (%eax),%ecx
  80313a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80313d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80313f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803142:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  803149:	8b 10                	mov    (%eax),%edx
  80314b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80314e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  803150:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803153:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80315a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80315d:	89 04 24             	mov    %eax,(%esp)
  803160:	e8 5b e8 ff ff       	call   8019c0 <fd2num>
  803165:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  803167:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80316a:	89 04 24             	mov    %eax,(%esp)
  80316d:	e8 4e e8 ff ff       	call   8019c0 <fd2num>
  803172:	89 47 04             	mov    %eax,0x4(%edi)
  803175:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80317a:	eb 36                	jmp    8031b2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80317c:	89 74 24 04          	mov    %esi,0x4(%esp)
  803180:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  803187:	e8 be e2 ff ff       	call   80144a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80318c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80318f:	89 44 24 04          	mov    %eax,0x4(%esp)
  803193:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80319a:	e8 ab e2 ff ff       	call   80144a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80319f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8031a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031a6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8031ad:	e8 98 e2 ff ff       	call   80144a <sys_page_unmap>
    err:
	return r;
}
  8031b2:	89 d8                	mov    %ebx,%eax
  8031b4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8031b7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8031ba:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8031bd:	89 ec                	mov    %ebp,%esp
  8031bf:	5d                   	pop    %ebp
  8031c0:	c3                   	ret    
  8031c1:	00 00                	add    %al,(%eax)
	...

008031c4 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8031c4:	55                   	push   %ebp
  8031c5:	89 e5                	mov    %esp,%ebp
  8031c7:	56                   	push   %esi
  8031c8:	53                   	push   %ebx
  8031c9:	83 ec 10             	sub    $0x10,%esp
  8031cc:	8b 45 08             	mov    0x8(%ebp),%eax
	volatile struct Env *e;

	assert(envid != 0);
  8031cf:	85 c0                	test   %eax,%eax
  8031d1:	75 24                	jne    8031f7 <wait+0x33>
  8031d3:	c7 44 24 0c 9c 3d 80 	movl   $0x803d9c,0xc(%esp)
  8031da:	00 
  8031db:	c7 44 24 08 c1 3c 80 	movl   $0x803cc1,0x8(%esp)
  8031e2:	00 
  8031e3:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8031ea:	00 
  8031eb:	c7 04 24 a7 3d 80 00 	movl   $0x803da7,(%esp)
  8031f2:	e8 11 d4 ff ff       	call   800608 <_panic>
	e = &envs[ENVX(envid)];
  8031f7:	89 c3                	mov    %eax,%ebx
  8031f9:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  8031ff:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  803202:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  803208:	8b 73 4c             	mov    0x4c(%ebx),%esi
  80320b:	39 c6                	cmp    %eax,%esi
  80320d:	75 1a                	jne    803229 <wait+0x65>
  80320f:	8b 43 54             	mov    0x54(%ebx),%eax
  803212:	85 c0                	test   %eax,%eax
  803214:	74 13                	je     803229 <wait+0x65>
		sys_yield();
  803216:	e8 4a e3 ff ff       	call   801565 <sys_yield>
{
	volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80321b:	8b 43 4c             	mov    0x4c(%ebx),%eax
  80321e:	39 f0                	cmp    %esi,%eax
  803220:	75 07                	jne    803229 <wait+0x65>
  803222:	8b 43 54             	mov    0x54(%ebx),%eax
  803225:	85 c0                	test   %eax,%eax
  803227:	75 ed                	jne    803216 <wait+0x52>
		sys_yield();
}
  803229:	83 c4 10             	add    $0x10,%esp
  80322c:	5b                   	pop    %ebx
  80322d:	5e                   	pop    %esi
  80322e:	5d                   	pop    %ebp
  80322f:	c3                   	ret    

00803230 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  803230:	55                   	push   %ebp
  803231:	89 e5                	mov    %esp,%ebp
  803233:	53                   	push   %ebx
  803234:	83 ec 14             	sub    $0x14,%esp
  803237:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    // cprintf("\nhere outside loading creating page\n");

	if (_pgfault_handler == 0) {
  80323a:	83 3d 7c 70 80 00 00 	cmpl   $0x0,0x80707c
  803241:	75 58                	jne    80329b <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
           //cprintf("\nhere inside loading creating page\n");    
          if(sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  803243:	e8 51 e3 ff ff       	call   801599 <sys_getenvid>
  803248:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80324f:	00 
  803250:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  803257:	ee 
  803258:	89 04 24             	mov    %eax,(%esp)
  80325b:	e8 a6 e2 ff ff       	call   801506 <sys_page_alloc>
  803260:	85 c0                	test   %eax,%eax
  803262:	79 1c                	jns    803280 <set_pgfault_handler+0x50>
                          panic("Cant allocate Page");                    
  803264:	c7 44 24 08 8c 3b 80 	movl   $0x803b8c,0x8(%esp)
  80326b:	00 
  80326c:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  803273:	00 
  803274:	c7 04 24 b2 3d 80 00 	movl   $0x803db2,(%esp)
  80327b:	e8 88 d3 ff ff       	call   800608 <_panic>
                _pgfault_handler=handler;
  803280:	89 1d 7c 70 80 00    	mov    %ebx,0x80707c
//entry point _pgfault_handler not pointed to by the kernel bcz after the execution is complete control needs to be returned back to execute the rest...so upcall is there         
             sys_env_set_pgfault_upcall(sys_getenvid(),_pgfault_upcall);
  803286:	e8 0e e3 ff ff       	call   801599 <sys_getenvid>
  80328b:	c7 44 24 04 a8 32 80 	movl   $0x8032a8,0x4(%esp)
  803292:	00 
  803293:	89 04 24             	mov    %eax,(%esp)
  803296:	e8 95 e0 ff ff       	call   801330 <sys_env_set_pgfault_upcall>

	// Save handler pointer for assembly to call.
 //     if(sys_page_alloc(0,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
   //                       panic("Cant allocate Page");

	_pgfault_handler = handler;
  80329b:	89 1d 7c 70 80 00    	mov    %ebx,0x80707c
}
  8032a1:	83 c4 14             	add    $0x14,%esp
  8032a4:	5b                   	pop    %ebx
  8032a5:	5d                   	pop    %ebp
  8032a6:	c3                   	ret    
	...

008032a8 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8032a8:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8032a9:	a1 7c 70 80 00       	mov    0x80707c,%eax
	call *%eax
  8032ae:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8032b0:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
           addl $8,%esp
  8032b3:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
            movl  32(%esp),%ebx
  8032b6:	8b 5c 24 20          	mov    0x20(%esp),%ebx
            movl  40(%esp),%eax
  8032ba:	8b 44 24 28          	mov    0x28(%esp),%eax
            subl  $4,%eax
  8032be:	83 e8 04             	sub    $0x4,%eax
            movl  %eax,40(%esp)
  8032c1:	89 44 24 28          	mov    %eax,0x28(%esp)
            movl  %ebx,(%eax)
  8032c5:	89 18                	mov    %ebx,(%eax)
            popal
  8032c7:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
            
            add $4,%esp            
  8032c8:	83 c4 04             	add    $0x4,%esp
            popfl
  8032cb:	9d                   	popf   
             
           popl %esp
  8032cc:	5c                   	pop    %esp
	// LAB 4: Your code here.
           

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
           ret
  8032cd:	c3                   	ret    
	...

008032d0 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8032d0:	55                   	push   %ebp
  8032d1:	89 e5                	mov    %esp,%ebp
  8032d3:	57                   	push   %edi
  8032d4:	56                   	push   %esi
  8032d5:	53                   	push   %ebx
  8032d6:	83 ec 1c             	sub    $0x1c,%esp
  8032d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8032dc:	8b 75 0c             	mov    0xc(%ebp),%esi
  8032df:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  8032e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8032e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032e9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  8032ed:	89 74 24 04          	mov    %esi,0x4(%esp)
  8032f1:	89 1c 24             	mov    %ebx,(%esp)
  8032f4:	e8 ff df ff ff       	call   8012f8 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  8032f9:	85 c0                	test   %eax,%eax
  8032fb:	79 21                	jns    80331e <ipc_send+0x4e>
  8032fd:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803300:	74 1c                	je     80331e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  803302:	c7 44 24 08 c0 3d 80 	movl   $0x803dc0,0x8(%esp)
  803309:	00 
  80330a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  803311:	00 
  803312:	c7 04 24 d2 3d 80 00 	movl   $0x803dd2,(%esp)
  803319:	e8 ea d2 ff ff       	call   800608 <_panic>
          else if(r==-E_IPC_NOT_RECV)
  80331e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  803321:	75 07                	jne    80332a <ipc_send+0x5a>
           sys_yield();
  803323:	e8 3d e2 ff ff       	call   801565 <sys_yield>
          else
            break;
        }
  803328:	eb b8                	jmp    8032e2 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  80332a:	83 c4 1c             	add    $0x1c,%esp
  80332d:	5b                   	pop    %ebx
  80332e:	5e                   	pop    %esi
  80332f:	5f                   	pop    %edi
  803330:	5d                   	pop    %ebp
  803331:	c3                   	ret    

00803332 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803332:	55                   	push   %ebp
  803333:	89 e5                	mov    %esp,%ebp
  803335:	83 ec 18             	sub    $0x18,%esp
  803338:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80333b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80333e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  803341:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  803344:	8b 45 0c             	mov    0xc(%ebp),%eax
  803347:	89 04 24             	mov    %eax,(%esp)
  80334a:	e8 4c df ff ff       	call   80129b <sys_ipc_recv>
        if(r<0)
  80334f:	85 c0                	test   %eax,%eax
  803351:	79 17                	jns    80336a <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  803353:	85 db                	test   %ebx,%ebx
  803355:	74 06                	je     80335d <ipc_recv+0x2b>
               *from_env_store =0;
  803357:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  80335d:	85 f6                	test   %esi,%esi
  80335f:	90                   	nop
  803360:	74 2c                	je     80338e <ipc_recv+0x5c>
              *perm_store=0;
  803362:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  803368:	eb 24                	jmp    80338e <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  80336a:	85 db                	test   %ebx,%ebx
  80336c:	74 0a                	je     803378 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  80336e:	a1 74 70 80 00       	mov    0x807074,%eax
  803373:	8b 40 74             	mov    0x74(%eax),%eax
  803376:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  803378:	85 f6                	test   %esi,%esi
  80337a:	74 0a                	je     803386 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  80337c:	a1 74 70 80 00       	mov    0x807074,%eax
  803381:	8b 40 78             	mov    0x78(%eax),%eax
  803384:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  803386:	a1 74 70 80 00       	mov    0x807074,%eax
  80338b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80338e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  803391:	8b 75 fc             	mov    -0x4(%ebp),%esi
  803394:	89 ec                	mov    %ebp,%esp
  803396:	5d                   	pop    %ebp
  803397:	c3                   	ret    

00803398 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803398:	55                   	push   %ebp
  803399:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80339b:	8b 45 08             	mov    0x8(%ebp),%eax
  80339e:	89 c2                	mov    %eax,%edx
  8033a0:	c1 ea 16             	shr    $0x16,%edx
  8033a3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8033aa:	f6 c2 01             	test   $0x1,%dl
  8033ad:	74 26                	je     8033d5 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  8033af:	c1 e8 0c             	shr    $0xc,%eax
  8033b2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8033b9:	a8 01                	test   $0x1,%al
  8033bb:	74 18                	je     8033d5 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  8033bd:	c1 e8 0c             	shr    $0xc,%eax
  8033c0:	8d 14 40             	lea    (%eax,%eax,2),%edx
  8033c3:	c1 e2 02             	shl    $0x2,%edx
  8033c6:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8033cb:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  8033d0:	0f b7 c0             	movzwl %ax,%eax
  8033d3:	eb 05                	jmp    8033da <pageref+0x42>
  8033d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8033da:	5d                   	pop    %ebp
  8033db:	c3                   	ret    
  8033dc:	00 00                	add    %al,(%eax)
	...

008033e0 <__udivdi3>:
  8033e0:	55                   	push   %ebp
  8033e1:	89 e5                	mov    %esp,%ebp
  8033e3:	57                   	push   %edi
  8033e4:	56                   	push   %esi
  8033e5:	83 ec 10             	sub    $0x10,%esp
  8033e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8033eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8033ee:	8b 75 10             	mov    0x10(%ebp),%esi
  8033f1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8033f4:	85 c0                	test   %eax,%eax
  8033f6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8033f9:	75 35                	jne    803430 <__udivdi3+0x50>
  8033fb:	39 fe                	cmp    %edi,%esi
  8033fd:	77 61                	ja     803460 <__udivdi3+0x80>
  8033ff:	85 f6                	test   %esi,%esi
  803401:	75 0b                	jne    80340e <__udivdi3+0x2e>
  803403:	b8 01 00 00 00       	mov    $0x1,%eax
  803408:	31 d2                	xor    %edx,%edx
  80340a:	f7 f6                	div    %esi
  80340c:	89 c6                	mov    %eax,%esi
  80340e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  803411:	31 d2                	xor    %edx,%edx
  803413:	89 f8                	mov    %edi,%eax
  803415:	f7 f6                	div    %esi
  803417:	89 c7                	mov    %eax,%edi
  803419:	89 c8                	mov    %ecx,%eax
  80341b:	f7 f6                	div    %esi
  80341d:	89 c1                	mov    %eax,%ecx
  80341f:	89 fa                	mov    %edi,%edx
  803421:	89 c8                	mov    %ecx,%eax
  803423:	83 c4 10             	add    $0x10,%esp
  803426:	5e                   	pop    %esi
  803427:	5f                   	pop    %edi
  803428:	5d                   	pop    %ebp
  803429:	c3                   	ret    
  80342a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  803430:	39 f8                	cmp    %edi,%eax
  803432:	77 1c                	ja     803450 <__udivdi3+0x70>
  803434:	0f bd d0             	bsr    %eax,%edx
  803437:	83 f2 1f             	xor    $0x1f,%edx
  80343a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80343d:	75 39                	jne    803478 <__udivdi3+0x98>
  80343f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  803442:	0f 86 a0 00 00 00    	jbe    8034e8 <__udivdi3+0x108>
  803448:	39 f8                	cmp    %edi,%eax
  80344a:	0f 82 98 00 00 00    	jb     8034e8 <__udivdi3+0x108>
  803450:	31 ff                	xor    %edi,%edi
  803452:	31 c9                	xor    %ecx,%ecx
  803454:	89 c8                	mov    %ecx,%eax
  803456:	89 fa                	mov    %edi,%edx
  803458:	83 c4 10             	add    $0x10,%esp
  80345b:	5e                   	pop    %esi
  80345c:	5f                   	pop    %edi
  80345d:	5d                   	pop    %ebp
  80345e:	c3                   	ret    
  80345f:	90                   	nop
  803460:	89 d1                	mov    %edx,%ecx
  803462:	89 fa                	mov    %edi,%edx
  803464:	89 c8                	mov    %ecx,%eax
  803466:	31 ff                	xor    %edi,%edi
  803468:	f7 f6                	div    %esi
  80346a:	89 c1                	mov    %eax,%ecx
  80346c:	89 fa                	mov    %edi,%edx
  80346e:	89 c8                	mov    %ecx,%eax
  803470:	83 c4 10             	add    $0x10,%esp
  803473:	5e                   	pop    %esi
  803474:	5f                   	pop    %edi
  803475:	5d                   	pop    %ebp
  803476:	c3                   	ret    
  803477:	90                   	nop
  803478:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80347c:	89 f2                	mov    %esi,%edx
  80347e:	d3 e0                	shl    %cl,%eax
  803480:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803483:	b8 20 00 00 00       	mov    $0x20,%eax
  803488:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80348b:	89 c1                	mov    %eax,%ecx
  80348d:	d3 ea                	shr    %cl,%edx
  80348f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803493:	0b 55 ec             	or     -0x14(%ebp),%edx
  803496:	d3 e6                	shl    %cl,%esi
  803498:	89 c1                	mov    %eax,%ecx
  80349a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80349d:	89 fe                	mov    %edi,%esi
  80349f:	d3 ee                	shr    %cl,%esi
  8034a1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8034a5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8034a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034ab:	d3 e7                	shl    %cl,%edi
  8034ad:	89 c1                	mov    %eax,%ecx
  8034af:	d3 ea                	shr    %cl,%edx
  8034b1:	09 d7                	or     %edx,%edi
  8034b3:	89 f2                	mov    %esi,%edx
  8034b5:	89 f8                	mov    %edi,%eax
  8034b7:	f7 75 ec             	divl   -0x14(%ebp)
  8034ba:	89 d6                	mov    %edx,%esi
  8034bc:	89 c7                	mov    %eax,%edi
  8034be:	f7 65 e8             	mull   -0x18(%ebp)
  8034c1:	39 d6                	cmp    %edx,%esi
  8034c3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8034c6:	72 30                	jb     8034f8 <__udivdi3+0x118>
  8034c8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8034cb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8034cf:	d3 e2                	shl    %cl,%edx
  8034d1:	39 c2                	cmp    %eax,%edx
  8034d3:	73 05                	jae    8034da <__udivdi3+0xfa>
  8034d5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  8034d8:	74 1e                	je     8034f8 <__udivdi3+0x118>
  8034da:	89 f9                	mov    %edi,%ecx
  8034dc:	31 ff                	xor    %edi,%edi
  8034de:	e9 71 ff ff ff       	jmp    803454 <__udivdi3+0x74>
  8034e3:	90                   	nop
  8034e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8034e8:	31 ff                	xor    %edi,%edi
  8034ea:	b9 01 00 00 00       	mov    $0x1,%ecx
  8034ef:	e9 60 ff ff ff       	jmp    803454 <__udivdi3+0x74>
  8034f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8034f8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  8034fb:	31 ff                	xor    %edi,%edi
  8034fd:	89 c8                	mov    %ecx,%eax
  8034ff:	89 fa                	mov    %edi,%edx
  803501:	83 c4 10             	add    $0x10,%esp
  803504:	5e                   	pop    %esi
  803505:	5f                   	pop    %edi
  803506:	5d                   	pop    %ebp
  803507:	c3                   	ret    
	...

00803510 <__umoddi3>:
  803510:	55                   	push   %ebp
  803511:	89 e5                	mov    %esp,%ebp
  803513:	57                   	push   %edi
  803514:	56                   	push   %esi
  803515:	83 ec 20             	sub    $0x20,%esp
  803518:	8b 55 14             	mov    0x14(%ebp),%edx
  80351b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80351e:	8b 7d 10             	mov    0x10(%ebp),%edi
  803521:	8b 75 0c             	mov    0xc(%ebp),%esi
  803524:	85 d2                	test   %edx,%edx
  803526:	89 c8                	mov    %ecx,%eax
  803528:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80352b:	75 13                	jne    803540 <__umoddi3+0x30>
  80352d:	39 f7                	cmp    %esi,%edi
  80352f:	76 3f                	jbe    803570 <__umoddi3+0x60>
  803531:	89 f2                	mov    %esi,%edx
  803533:	f7 f7                	div    %edi
  803535:	89 d0                	mov    %edx,%eax
  803537:	31 d2                	xor    %edx,%edx
  803539:	83 c4 20             	add    $0x20,%esp
  80353c:	5e                   	pop    %esi
  80353d:	5f                   	pop    %edi
  80353e:	5d                   	pop    %ebp
  80353f:	c3                   	ret    
  803540:	39 f2                	cmp    %esi,%edx
  803542:	77 4c                	ja     803590 <__umoddi3+0x80>
  803544:	0f bd ca             	bsr    %edx,%ecx
  803547:	83 f1 1f             	xor    $0x1f,%ecx
  80354a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80354d:	75 51                	jne    8035a0 <__umoddi3+0x90>
  80354f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  803552:	0f 87 e0 00 00 00    	ja     803638 <__umoddi3+0x128>
  803558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80355b:	29 f8                	sub    %edi,%eax
  80355d:	19 d6                	sbb    %edx,%esi
  80355f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803562:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803565:	89 f2                	mov    %esi,%edx
  803567:	83 c4 20             	add    $0x20,%esp
  80356a:	5e                   	pop    %esi
  80356b:	5f                   	pop    %edi
  80356c:	5d                   	pop    %ebp
  80356d:	c3                   	ret    
  80356e:	66 90                	xchg   %ax,%ax
  803570:	85 ff                	test   %edi,%edi
  803572:	75 0b                	jne    80357f <__umoddi3+0x6f>
  803574:	b8 01 00 00 00       	mov    $0x1,%eax
  803579:	31 d2                	xor    %edx,%edx
  80357b:	f7 f7                	div    %edi
  80357d:	89 c7                	mov    %eax,%edi
  80357f:	89 f0                	mov    %esi,%eax
  803581:	31 d2                	xor    %edx,%edx
  803583:	f7 f7                	div    %edi
  803585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803588:	f7 f7                	div    %edi
  80358a:	eb a9                	jmp    803535 <__umoddi3+0x25>
  80358c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803590:	89 c8                	mov    %ecx,%eax
  803592:	89 f2                	mov    %esi,%edx
  803594:	83 c4 20             	add    $0x20,%esp
  803597:	5e                   	pop    %esi
  803598:	5f                   	pop    %edi
  803599:	5d                   	pop    %ebp
  80359a:	c3                   	ret    
  80359b:	90                   	nop
  80359c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8035a0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8035a4:	d3 e2                	shl    %cl,%edx
  8035a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8035a9:	ba 20 00 00 00       	mov    $0x20,%edx
  8035ae:	2b 55 f0             	sub    -0x10(%ebp),%edx
  8035b1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  8035b4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8035b8:	89 fa                	mov    %edi,%edx
  8035ba:	d3 ea                	shr    %cl,%edx
  8035bc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8035c0:	0b 55 f4             	or     -0xc(%ebp),%edx
  8035c3:	d3 e7                	shl    %cl,%edi
  8035c5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8035c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8035cc:	89 f2                	mov    %esi,%edx
  8035ce:	89 7d e8             	mov    %edi,-0x18(%ebp)
  8035d1:	89 c7                	mov    %eax,%edi
  8035d3:	d3 ea                	shr    %cl,%edx
  8035d5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8035d9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8035dc:	89 c2                	mov    %eax,%edx
  8035de:	d3 e6                	shl    %cl,%esi
  8035e0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8035e4:	d3 ea                	shr    %cl,%edx
  8035e6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8035ea:	09 d6                	or     %edx,%esi
  8035ec:	89 f0                	mov    %esi,%eax
  8035ee:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8035f1:	d3 e7                	shl    %cl,%edi
  8035f3:	89 f2                	mov    %esi,%edx
  8035f5:	f7 75 f4             	divl   -0xc(%ebp)
  8035f8:	89 d6                	mov    %edx,%esi
  8035fa:	f7 65 e8             	mull   -0x18(%ebp)
  8035fd:	39 d6                	cmp    %edx,%esi
  8035ff:	72 2b                	jb     80362c <__umoddi3+0x11c>
  803601:	39 c7                	cmp    %eax,%edi
  803603:	72 23                	jb     803628 <__umoddi3+0x118>
  803605:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803609:	29 c7                	sub    %eax,%edi
  80360b:	19 d6                	sbb    %edx,%esi
  80360d:	89 f0                	mov    %esi,%eax
  80360f:	89 f2                	mov    %esi,%edx
  803611:	d3 ef                	shr    %cl,%edi
  803613:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803617:	d3 e0                	shl    %cl,%eax
  803619:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80361d:	09 f8                	or     %edi,%eax
  80361f:	d3 ea                	shr    %cl,%edx
  803621:	83 c4 20             	add    $0x20,%esp
  803624:	5e                   	pop    %esi
  803625:	5f                   	pop    %edi
  803626:	5d                   	pop    %ebp
  803627:	c3                   	ret    
  803628:	39 d6                	cmp    %edx,%esi
  80362a:	75 d9                	jne    803605 <__umoddi3+0xf5>
  80362c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80362f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  803632:	eb d1                	jmp    803605 <__umoddi3+0xf5>
  803634:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803638:	39 f2                	cmp    %esi,%edx
  80363a:	0f 82 18 ff ff ff    	jb     803558 <__umoddi3+0x48>
  803640:	e9 1d ff ff ff       	jmp    803562 <__umoddi3+0x52>
