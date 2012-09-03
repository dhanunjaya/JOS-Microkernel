
obj/user/testfdsharing:     file format elf32-i386


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
  80002c:	e8 cf 03 00 00       	call   800400 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

char buf[512], buf2[512];

void
umain(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	57                   	push   %edi
  800038:	56                   	push   %esi
  800039:	53                   	push   %ebx
  80003a:	83 ec 2c             	sub    $0x2c,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800044:	00 
  800045:	c7 04 24 a3 30 80 00 	movl   $0x8030a3,(%esp)
  80004c:	e8 26 20 00 00       	call   802077 <open>
  800051:	89 c3                	mov    %eax,%ebx
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <umain+0x43>
		panic("open motd: %e", fd);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 40 30 80 	movl   $0x803040,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 4e 30 80 00 	movl   $0x80304e,(%esp)
  800072:	e8 f5 03 00 00       	call   80046c <_panic>
	seek(fd, 0);
  800077:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80007e:	00 
  80007f:	89 04 24             	mov    %eax,(%esp)
  800082:	e8 7e 18 00 00       	call   801905 <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800087:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80008e:	00 
  80008f:	c7 44 24 04 80 72 80 	movl   $0x807280,0x4(%esp)
  800096:	00 
  800097:	89 1c 24             	mov    %ebx,(%esp)
  80009a:	e8 0d 1b 00 00       	call   801bac <readn>
  80009f:	89 c7                	mov    %eax,%edi
  8000a1:	85 c0                	test   %eax,%eax
  8000a3:	7f 20                	jg     8000c5 <umain+0x91>
		panic("readn: %e", n);
  8000a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000a9:	c7 44 24 08 63 30 80 	movl   $0x803063,0x8(%esp)
  8000b0:	00 
  8000b1:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  8000b8:	00 
  8000b9:	c7 04 24 4e 30 80 00 	movl   $0x80304e,(%esp)
  8000c0:	e8 a7 03 00 00       	call   80046c <_panic>

	if ((r = fork()) < 0)
  8000c5:	e8 1d 15 00 00       	call   8015e7 <fork>
  8000ca:	89 c6                	mov    %eax,%esi
  8000cc:	85 c0                	test   %eax,%eax
  8000ce:	79 20                	jns    8000f0 <umain+0xbc>
		panic("fork: %e", r);
  8000d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000d4:	c7 44 24 08 e3 35 80 	movl   $0x8035e3,0x8(%esp)
  8000db:	00 
  8000dc:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  8000e3:	00 
  8000e4:	c7 04 24 4e 30 80 00 	movl   $0x80304e,(%esp)
  8000eb:	e8 7c 03 00 00       	call   80046c <_panic>
	if (r == 0) {
  8000f0:	85 c0                	test   %eax,%eax
  8000f2:	0f 85 bd 00 00 00    	jne    8001b5 <umain+0x181>
		seek(fd, 0);
  8000f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000ff:	00 
  800100:	89 1c 24             	mov    %ebx,(%esp)
  800103:	e8 fd 17 00 00       	call   801905 <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  800108:	c7 04 24 4c 31 80 00 	movl   $0x80314c,(%esp)
  80010f:	e8 1d 04 00 00       	call   800531 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800114:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  80011b:	00 
  80011c:	c7 44 24 04 80 70 80 	movl   $0x807080,0x4(%esp)
  800123:	00 
  800124:	89 1c 24             	mov    %ebx,(%esp)
  800127:	e8 80 1a 00 00       	call   801bac <readn>
  80012c:	39 c7                	cmp    %eax,%edi
  80012e:	74 24                	je     800154 <umain+0x120>
			panic("read in parent got %d, read in child got %d", n, n2);
  800130:	89 44 24 10          	mov    %eax,0x10(%esp)
  800134:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  800138:	c7 44 24 08 90 31 80 	movl   $0x803190,0x8(%esp)
  80013f:	00 
  800140:	c7 44 24 04 17 00 00 	movl   $0x17,0x4(%esp)
  800147:	00 
  800148:	c7 04 24 4e 30 80 00 	movl   $0x80304e,(%esp)
  80014f:	e8 18 03 00 00       	call   80046c <_panic>
		if (memcmp(buf, buf2, n) != 0)
  800154:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800158:	c7 44 24 04 80 70 80 	movl   $0x807080,0x4(%esp)
  80015f:	00 
  800160:	c7 04 24 80 72 80 00 	movl   $0x807280,(%esp)
  800167:	e8 f6 0c 00 00       	call   800e62 <memcmp>
  80016c:	85 c0                	test   %eax,%eax
  80016e:	74 1c                	je     80018c <umain+0x158>
			panic("read in parent got different bytes from read in child");
  800170:	c7 44 24 08 bc 31 80 	movl   $0x8031bc,0x8(%esp)
  800177:	00 
  800178:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80017f:	00 
  800180:	c7 04 24 4e 30 80 00 	movl   $0x80304e,(%esp)
  800187:	e8 e0 02 00 00       	call   80046c <_panic>
		cprintf("read in child succeeded\n");
  80018c:	c7 04 24 6d 30 80 00 	movl   $0x80306d,(%esp)
  800193:	e8 99 03 00 00       	call   800531 <cprintf>
		seek(fd, 0);
  800198:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80019f:	00 
  8001a0:	89 1c 24             	mov    %ebx,(%esp)
  8001a3:	e8 5d 17 00 00       	call   801905 <seek>
		close(fd);
  8001a8:	89 1c 24             	mov    %ebx,(%esp)
  8001ab:	e8 ce 1a 00 00       	call   801c7e <close>
		exit();
  8001b0:	e8 9b 02 00 00       	call   800450 <exit>
	}
	wait(r);
  8001b5:	89 34 24             	mov    %esi,(%esp)
  8001b8:	e8 47 28 00 00       	call   802a04 <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8001bd:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  8001c4:	00 
  8001c5:	c7 44 24 04 80 70 80 	movl   $0x807080,0x4(%esp)
  8001cc:	00 
  8001cd:	89 1c 24             	mov    %ebx,(%esp)
  8001d0:	e8 d7 19 00 00       	call   801bac <readn>
  8001d5:	39 c7                	cmp    %eax,%edi
  8001d7:	74 24                	je     8001fd <umain+0x1c9>
		panic("read in parent got %d, then got %d", n, n2);
  8001d9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001dd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8001e1:	c7 44 24 08 f4 31 80 	movl   $0x8031f4,0x8(%esp)
  8001e8:	00 
  8001e9:	c7 44 24 04 21 00 00 	movl   $0x21,0x4(%esp)
  8001f0:	00 
  8001f1:	c7 04 24 4e 30 80 00 	movl   $0x80304e,(%esp)
  8001f8:	e8 6f 02 00 00       	call   80046c <_panic>
	cprintf("read in parent succeeded\n");		
  8001fd:	c7 04 24 86 30 80 00 	movl   $0x803086,(%esp)
  800204:	e8 28 03 00 00       	call   800531 <cprintf>
	close(fd);
  800209:	89 1c 24             	mov    %ebx,(%esp)
  80020c:	e8 6d 1a 00 00       	call   801c7e <close>

	if ((fd = open("newmotd", O_RDWR)) < 0)
  800211:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  800218:	00 
  800219:	c7 04 24 a0 30 80 00 	movl   $0x8030a0,(%esp)
  800220:	e8 52 1e 00 00       	call   802077 <open>
  800225:	89 c3                	mov    %eax,%ebx
  800227:	85 c0                	test   %eax,%eax
  800229:	79 20                	jns    80024b <umain+0x217>
		panic("open newmotd: %e", fd);
  80022b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80022f:	c7 44 24 08 a8 30 80 	movl   $0x8030a8,0x8(%esp)
  800236:	00 
  800237:	c7 44 24 04 26 00 00 	movl   $0x26,0x4(%esp)
  80023e:	00 
  80023f:	c7 04 24 4e 30 80 00 	movl   $0x80304e,(%esp)
  800246:	e8 21 02 00 00       	call   80046c <_panic>
	seek(fd, 0);
  80024b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800252:	00 
  800253:	89 04 24             	mov    %eax,(%esp)
  800256:	e8 aa 16 00 00       	call   801905 <seek>
	if ((n = write(fd, "hello", 5)) != 5)
  80025b:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
  800262:	00 
  800263:	c7 44 24 04 b9 30 80 	movl   $0x8030b9,0x4(%esp)
  80026a:	00 
  80026b:	89 1c 24             	mov    %ebx,(%esp)
  80026e:	e8 22 18 00 00       	call   801a95 <write>
  800273:	83 f8 05             	cmp    $0x5,%eax
  800276:	74 20                	je     800298 <umain+0x264>
		panic("write: %e", n);
  800278:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80027c:	c7 44 24 08 bf 30 80 	movl   $0x8030bf,0x8(%esp)
  800283:	00 
  800284:	c7 44 24 04 29 00 00 	movl   $0x29,0x4(%esp)
  80028b:	00 
  80028c:	c7 04 24 4e 30 80 00 	movl   $0x80304e,(%esp)
  800293:	e8 d4 01 00 00       	call   80046c <_panic>

	if ((r = fork()) < 0)
  800298:	e8 4a 13 00 00       	call   8015e7 <fork>
  80029d:	89 c6                	mov    %eax,%esi
  80029f:	85 c0                	test   %eax,%eax
  8002a1:	79 20                	jns    8002c3 <umain+0x28f>
		panic("fork: %e", r);
  8002a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002a7:	c7 44 24 08 e3 35 80 	movl   $0x8035e3,0x8(%esp)
  8002ae:	00 
  8002af:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  8002b6:	00 
  8002b7:	c7 04 24 4e 30 80 00 	movl   $0x80304e,(%esp)
  8002be:	e8 a9 01 00 00       	call   80046c <_panic>
	if (r == 0) {
  8002c3:	85 c0                	test   %eax,%eax
  8002c5:	75 72                	jne    800339 <umain+0x305>
		seek(fd, 0);
  8002c7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002ce:	00 
  8002cf:	89 1c 24             	mov    %ebx,(%esp)
  8002d2:	e8 2e 16 00 00       	call   801905 <seek>
		cprintf("going to write in child\n");
  8002d7:	c7 04 24 c9 30 80 00 	movl   $0x8030c9,(%esp)
  8002de:	e8 4e 02 00 00       	call   800531 <cprintf>
		if ((n = write(fd, "world", 5)) != 5)
  8002e3:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
  8002ea:	00 
  8002eb:	c7 44 24 04 e2 30 80 	movl   $0x8030e2,0x4(%esp)
  8002f2:	00 
  8002f3:	89 1c 24             	mov    %ebx,(%esp)
  8002f6:	e8 9a 17 00 00       	call   801a95 <write>
  8002fb:	83 f8 05             	cmp    $0x5,%eax
  8002fe:	74 20                	je     800320 <umain+0x2ec>
			panic("write in child: %e", n);
  800300:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800304:	c7 44 24 08 e8 30 80 	movl   $0x8030e8,0x8(%esp)
  80030b:	00 
  80030c:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
  800313:	00 
  800314:	c7 04 24 4e 30 80 00 	movl   $0x80304e,(%esp)
  80031b:	e8 4c 01 00 00       	call   80046c <_panic>
		cprintf("write in child finished\n");
  800320:	c7 04 24 fb 30 80 00 	movl   $0x8030fb,(%esp)
  800327:	e8 05 02 00 00       	call   800531 <cprintf>
		close(fd);
  80032c:	89 1c 24             	mov    %ebx,(%esp)
  80032f:	e8 4a 19 00 00       	call   801c7e <close>
		exit();
  800334:	e8 17 01 00 00       	call   800450 <exit>
	}
	wait(r);
  800339:	89 34 24             	mov    %esi,(%esp)
  80033c:	e8 c3 26 00 00       	call   802a04 <wait>
	seek(fd, 0);
  800341:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800348:	00 
  800349:	89 1c 24             	mov    %ebx,(%esp)
  80034c:	e8 b4 15 00 00       	call   801905 <seek>
	if ((n = readn(fd, buf, 5)) != 5)
  800351:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
  800358:	00 
  800359:	c7 44 24 04 80 72 80 	movl   $0x807280,0x4(%esp)
  800360:	00 
  800361:	89 1c 24             	mov    %ebx,(%esp)
  800364:	e8 43 18 00 00       	call   801bac <readn>
  800369:	83 f8 05             	cmp    $0x5,%eax
  80036c:	74 20                	je     80038e <umain+0x35a>
		panic("readn: %e", n);
  80036e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800372:	c7 44 24 08 63 30 80 	movl   $0x803063,0x8(%esp)
  800379:	00 
  80037a:	c7 44 24 04 39 00 00 	movl   $0x39,0x4(%esp)
  800381:	00 
  800382:	c7 04 24 4e 30 80 00 	movl   $0x80304e,(%esp)
  800389:	e8 de 00 00 00       	call   80046c <_panic>
	buf[5] = 0;
  80038e:	c6 05 85 72 80 00 00 	movb   $0x0,0x807285
	if (strcmp(buf, "hello") == 0)
  800395:	c7 44 24 04 b9 30 80 	movl   $0x8030b9,0x4(%esp)
  80039c:	00 
  80039d:	c7 04 24 80 72 80 00 	movl   $0x807280,(%esp)
  8003a4:	e8 f0 08 00 00       	call   800c99 <strcmp>
  8003a9:	85 c0                	test   %eax,%eax
  8003ab:	75 0e                	jne    8003bb <umain+0x387>
		cprintf("write to file failed; got old data\n");
  8003ad:	c7 04 24 18 32 80 00 	movl   $0x803218,(%esp)
  8003b4:	e8 78 01 00 00       	call   800531 <cprintf>
  8003b9:	eb 3a                	jmp    8003f5 <umain+0x3c1>
	else if (strcmp(buf, "world") == 0)
  8003bb:	c7 44 24 04 e2 30 80 	movl   $0x8030e2,0x4(%esp)
  8003c2:	00 
  8003c3:	c7 04 24 80 72 80 00 	movl   $0x807280,(%esp)
  8003ca:	e8 ca 08 00 00       	call   800c99 <strcmp>
  8003cf:	85 c0                	test   %eax,%eax
  8003d1:	75 0e                	jne    8003e1 <umain+0x3ad>
		cprintf("write to file succeeded\n");
  8003d3:	c7 04 24 14 31 80 00 	movl   $0x803114,(%esp)
  8003da:	e8 52 01 00 00       	call   800531 <cprintf>
  8003df:	eb 14                	jmp    8003f5 <umain+0x3c1>
	else
		cprintf("write to file failed; got %s\n", buf);
  8003e1:	c7 44 24 04 80 72 80 	movl   $0x807280,0x4(%esp)
  8003e8:	00 
  8003e9:	c7 04 24 2d 31 80 00 	movl   $0x80312d,(%esp)
  8003f0:	e8 3c 01 00 00       	call   800531 <cprintf>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  8003f5:	cc                   	int3   

	breakpoint();
}
  8003f6:	83 c4 2c             	add    $0x2c,%esp
  8003f9:	5b                   	pop    %ebx
  8003fa:	5e                   	pop    %esi
  8003fb:	5f                   	pop    %edi
  8003fc:	5d                   	pop    %ebp
  8003fd:	c3                   	ret    
	...

00800400 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800400:	55                   	push   %ebp
  800401:	89 e5                	mov    %esp,%ebp
  800403:	83 ec 18             	sub    $0x18,%esp
  800406:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800409:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80040c:	8b 75 08             	mov    0x8(%ebp),%esi
  80040f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  800412:	e8 e2 0f 00 00       	call   8013f9 <sys_getenvid>
  800417:	25 ff 03 00 00       	and    $0x3ff,%eax
  80041c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80041f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800424:	a3 80 74 80 00       	mov    %eax,0x807480

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800429:	85 f6                	test   %esi,%esi
  80042b:	7e 07                	jle    800434 <libmain+0x34>
		binaryname = argv[0];
  80042d:	8b 03                	mov    (%ebx),%eax
  80042f:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  800434:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800438:	89 34 24             	mov    %esi,(%esp)
  80043b:	e8 f4 fb ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800440:	e8 0b 00 00 00       	call   800450 <exit>
}
  800445:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800448:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80044b:	89 ec                	mov    %ebp,%esp
  80044d:	5d                   	pop    %ebp
  80044e:	c3                   	ret    
	...

00800450 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800456:	e8 a0 18 00 00       	call   801cfb <close_all>
	sys_env_destroy(0);
  80045b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800462:	e8 c6 0f 00 00       	call   80142d <sys_env_destroy>
}
  800467:	c9                   	leave  
  800468:	c3                   	ret    
  800469:	00 00                	add    %al,(%eax)
	...

0080046c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	53                   	push   %ebx
  800470:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  800473:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800476:	a1 84 74 80 00       	mov    0x807484,%eax
  80047b:	85 c0                	test   %eax,%eax
  80047d:	74 10                	je     80048f <_panic+0x23>
		cprintf("%s: ", argv0);
  80047f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800483:	c7 04 24 53 32 80 00 	movl   $0x803253,(%esp)
  80048a:	e8 a2 00 00 00       	call   800531 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80048f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800492:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800496:	8b 45 08             	mov    0x8(%ebp),%eax
  800499:	89 44 24 08          	mov    %eax,0x8(%esp)
  80049d:	a1 00 70 80 00       	mov    0x807000,%eax
  8004a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004a6:	c7 04 24 58 32 80 00 	movl   $0x803258,(%esp)
  8004ad:	e8 7f 00 00 00       	call   800531 <cprintf>
	vcprintf(fmt, ap);
  8004b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8004b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8004b9:	89 04 24             	mov    %eax,(%esp)
  8004bc:	e8 0f 00 00 00       	call   8004d0 <vcprintf>
	cprintf("\n");
  8004c1:	c7 04 24 84 30 80 00 	movl   $0x803084,(%esp)
  8004c8:	e8 64 00 00 00       	call   800531 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004cd:	cc                   	int3   
  8004ce:	eb fd                	jmp    8004cd <_panic+0x61>

008004d0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8004d0:	55                   	push   %ebp
  8004d1:	89 e5                	mov    %esp,%ebp
  8004d3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8004d9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004e0:	00 00 00 
	b.cnt = 0;
  8004e3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004ea:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8004f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800501:	89 44 24 04          	mov    %eax,0x4(%esp)
  800505:	c7 04 24 4b 05 80 00 	movl   $0x80054b,(%esp)
  80050c:	e8 cc 01 00 00       	call   8006dd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800511:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800517:	89 44 24 04          	mov    %eax,0x4(%esp)
  80051b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800521:	89 04 24             	mov    %eax,(%esp)
  800524:	e8 d7 0a 00 00       	call   801000 <sys_cputs>

	return b.cnt;
}
  800529:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80052f:	c9                   	leave  
  800530:	c3                   	ret    

00800531 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800531:	55                   	push   %ebp
  800532:	89 e5                	mov    %esp,%ebp
  800534:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800537:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80053a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	89 04 24             	mov    %eax,(%esp)
  800544:	e8 87 ff ff ff       	call   8004d0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800549:	c9                   	leave  
  80054a:	c3                   	ret    

0080054b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80054b:	55                   	push   %ebp
  80054c:	89 e5                	mov    %esp,%ebp
  80054e:	53                   	push   %ebx
  80054f:	83 ec 14             	sub    $0x14,%esp
  800552:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800555:	8b 03                	mov    (%ebx),%eax
  800557:	8b 55 08             	mov    0x8(%ebp),%edx
  80055a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80055e:	83 c0 01             	add    $0x1,%eax
  800561:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800563:	3d ff 00 00 00       	cmp    $0xff,%eax
  800568:	75 19                	jne    800583 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80056a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800571:	00 
  800572:	8d 43 08             	lea    0x8(%ebx),%eax
  800575:	89 04 24             	mov    %eax,(%esp)
  800578:	e8 83 0a 00 00       	call   801000 <sys_cputs>
		b->idx = 0;
  80057d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800583:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800587:	83 c4 14             	add    $0x14,%esp
  80058a:	5b                   	pop    %ebx
  80058b:	5d                   	pop    %ebp
  80058c:	c3                   	ret    
  80058d:	00 00                	add    %al,(%eax)
	...

00800590 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	57                   	push   %edi
  800594:	56                   	push   %esi
  800595:	53                   	push   %ebx
  800596:	83 ec 4c             	sub    $0x4c,%esp
  800599:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80059c:	89 d6                	mov    %edx,%esi
  80059e:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8005aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8005b0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005bb:	39 d1                	cmp    %edx,%ecx
  8005bd:	72 15                	jb     8005d4 <printnum+0x44>
  8005bf:	77 07                	ja     8005c8 <printnum+0x38>
  8005c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c4:	39 d0                	cmp    %edx,%eax
  8005c6:	76 0c                	jbe    8005d4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005c8:	83 eb 01             	sub    $0x1,%ebx
  8005cb:	85 db                	test   %ebx,%ebx
  8005cd:	8d 76 00             	lea    0x0(%esi),%esi
  8005d0:	7f 61                	jg     800633 <printnum+0xa3>
  8005d2:	eb 70                	jmp    800644 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005d4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8005d8:	83 eb 01             	sub    $0x1,%ebx
  8005db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8005df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005e3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8005e7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8005eb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8005ee:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8005f1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005f4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8005f8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8005ff:	00 
  800600:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800603:	89 04 24             	mov    %eax,(%esp)
  800606:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800609:	89 54 24 04          	mov    %edx,0x4(%esp)
  80060d:	e8 be 27 00 00       	call   802dd0 <__udivdi3>
  800612:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800615:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800618:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80061c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800620:	89 04 24             	mov    %eax,(%esp)
  800623:	89 54 24 04          	mov    %edx,0x4(%esp)
  800627:	89 f2                	mov    %esi,%edx
  800629:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80062c:	e8 5f ff ff ff       	call   800590 <printnum>
  800631:	eb 11                	jmp    800644 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800633:	89 74 24 04          	mov    %esi,0x4(%esp)
  800637:	89 3c 24             	mov    %edi,(%esp)
  80063a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063d:	83 eb 01             	sub    $0x1,%ebx
  800640:	85 db                	test   %ebx,%ebx
  800642:	7f ef                	jg     800633 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800644:	89 74 24 04          	mov    %esi,0x4(%esp)
  800648:	8b 74 24 04          	mov    0x4(%esp),%esi
  80064c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80064f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800653:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80065a:	00 
  80065b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80065e:	89 14 24             	mov    %edx,(%esp)
  800661:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800664:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800668:	e8 93 28 00 00       	call   802f00 <__umoddi3>
  80066d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800671:	0f be 80 74 32 80 00 	movsbl 0x803274(%eax),%eax
  800678:	89 04 24             	mov    %eax,(%esp)
  80067b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80067e:	83 c4 4c             	add    $0x4c,%esp
  800681:	5b                   	pop    %ebx
  800682:	5e                   	pop    %esi
  800683:	5f                   	pop    %edi
  800684:	5d                   	pop    %ebp
  800685:	c3                   	ret    

00800686 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800686:	55                   	push   %ebp
  800687:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800689:	83 fa 01             	cmp    $0x1,%edx
  80068c:	7e 0e                	jle    80069c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80068e:	8b 10                	mov    (%eax),%edx
  800690:	8d 4a 08             	lea    0x8(%edx),%ecx
  800693:	89 08                	mov    %ecx,(%eax)
  800695:	8b 02                	mov    (%edx),%eax
  800697:	8b 52 04             	mov    0x4(%edx),%edx
  80069a:	eb 22                	jmp    8006be <getuint+0x38>
	else if (lflag)
  80069c:	85 d2                	test   %edx,%edx
  80069e:	74 10                	je     8006b0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8006a0:	8b 10                	mov    (%eax),%edx
  8006a2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8006a5:	89 08                	mov    %ecx,(%eax)
  8006a7:	8b 02                	mov    (%edx),%eax
  8006a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8006ae:	eb 0e                	jmp    8006be <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8006b0:	8b 10                	mov    (%eax),%edx
  8006b2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8006b5:	89 08                	mov    %ecx,(%eax)
  8006b7:	8b 02                	mov    (%edx),%eax
  8006b9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006be:	5d                   	pop    %ebp
  8006bf:	c3                   	ret    

008006c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006c0:	55                   	push   %ebp
  8006c1:	89 e5                	mov    %esp,%ebp
  8006c3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006c6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006ca:	8b 10                	mov    (%eax),%edx
  8006cc:	3b 50 04             	cmp    0x4(%eax),%edx
  8006cf:	73 0a                	jae    8006db <sprintputch+0x1b>
		*b->buf++ = ch;
  8006d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006d4:	88 0a                	mov    %cl,(%edx)
  8006d6:	83 c2 01             	add    $0x1,%edx
  8006d9:	89 10                	mov    %edx,(%eax)
}
  8006db:	5d                   	pop    %ebp
  8006dc:	c3                   	ret    

008006dd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
  8006e0:	57                   	push   %edi
  8006e1:	56                   	push   %esi
  8006e2:	53                   	push   %ebx
  8006e3:	83 ec 5c             	sub    $0x5c,%esp
  8006e6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8006ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006ef:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8006f6:	eb 11                	jmp    800709 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8006f8:	85 c0                	test   %eax,%eax
  8006fa:	0f 84 09 04 00 00    	je     800b09 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  800700:	89 74 24 04          	mov    %esi,0x4(%esp)
  800704:	89 04 24             	mov    %eax,(%esp)
  800707:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800709:	0f b6 03             	movzbl (%ebx),%eax
  80070c:	83 c3 01             	add    $0x1,%ebx
  80070f:	83 f8 25             	cmp    $0x25,%eax
  800712:	75 e4                	jne    8006f8 <vprintfmt+0x1b>
  800714:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800718:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80071f:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800726:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80072d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800732:	eb 06                	jmp    80073a <vprintfmt+0x5d>
  800734:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800738:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073a:	0f b6 13             	movzbl (%ebx),%edx
  80073d:	0f b6 c2             	movzbl %dl,%eax
  800740:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800743:	8d 43 01             	lea    0x1(%ebx),%eax
  800746:	83 ea 23             	sub    $0x23,%edx
  800749:	80 fa 55             	cmp    $0x55,%dl
  80074c:	0f 87 9a 03 00 00    	ja     800aec <vprintfmt+0x40f>
  800752:	0f b6 d2             	movzbl %dl,%edx
  800755:	ff 24 95 c0 33 80 00 	jmp    *0x8033c0(,%edx,4)
  80075c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800760:	eb d6                	jmp    800738 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800762:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800765:	83 ea 30             	sub    $0x30,%edx
  800768:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  80076b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80076e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800771:	83 fb 09             	cmp    $0x9,%ebx
  800774:	77 4c                	ja     8007c2 <vprintfmt+0xe5>
  800776:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800779:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80077c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80077f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800782:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800786:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800789:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80078c:	83 fb 09             	cmp    $0x9,%ebx
  80078f:	76 eb                	jbe    80077c <vprintfmt+0x9f>
  800791:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800794:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800797:	eb 29                	jmp    8007c2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800799:	8b 55 14             	mov    0x14(%ebp),%edx
  80079c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80079f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8007a2:	8b 12                	mov    (%edx),%edx
  8007a4:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  8007a7:	eb 19                	jmp    8007c2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8007a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8007ac:	c1 fa 1f             	sar    $0x1f,%edx
  8007af:	f7 d2                	not    %edx
  8007b1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8007b4:	eb 82                	jmp    800738 <vprintfmt+0x5b>
  8007b6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8007bd:	e9 76 ff ff ff       	jmp    800738 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8007c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007c6:	0f 89 6c ff ff ff    	jns    800738 <vprintfmt+0x5b>
  8007cc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8007cf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007d2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8007d5:	89 55 cc             	mov    %edx,-0x34(%ebp)
  8007d8:	e9 5b ff ff ff       	jmp    800738 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007dd:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8007e0:	e9 53 ff ff ff       	jmp    800738 <vprintfmt+0x5b>
  8007e5:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007eb:	8d 50 04             	lea    0x4(%eax),%edx
  8007ee:	89 55 14             	mov    %edx,0x14(%ebp)
  8007f1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	89 04 24             	mov    %eax,(%esp)
  8007fa:	ff d7                	call   *%edi
  8007fc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8007ff:	e9 05 ff ff ff       	jmp    800709 <vprintfmt+0x2c>
  800804:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800807:	8b 45 14             	mov    0x14(%ebp),%eax
  80080a:	8d 50 04             	lea    0x4(%eax),%edx
  80080d:	89 55 14             	mov    %edx,0x14(%ebp)
  800810:	8b 00                	mov    (%eax),%eax
  800812:	89 c2                	mov    %eax,%edx
  800814:	c1 fa 1f             	sar    $0x1f,%edx
  800817:	31 d0                	xor    %edx,%eax
  800819:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80081b:	83 f8 0f             	cmp    $0xf,%eax
  80081e:	7f 0b                	jg     80082b <vprintfmt+0x14e>
  800820:	8b 14 85 20 35 80 00 	mov    0x803520(,%eax,4),%edx
  800827:	85 d2                	test   %edx,%edx
  800829:	75 20                	jne    80084b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80082b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80082f:	c7 44 24 08 85 32 80 	movl   $0x803285,0x8(%esp)
  800836:	00 
  800837:	89 74 24 04          	mov    %esi,0x4(%esp)
  80083b:	89 3c 24             	mov    %edi,(%esp)
  80083e:	e8 4e 03 00 00       	call   800b91 <printfmt>
  800843:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800846:	e9 be fe ff ff       	jmp    800709 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80084b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80084f:	c7 44 24 08 25 37 80 	movl   $0x803725,0x8(%esp)
  800856:	00 
  800857:	89 74 24 04          	mov    %esi,0x4(%esp)
  80085b:	89 3c 24             	mov    %edi,(%esp)
  80085e:	e8 2e 03 00 00       	call   800b91 <printfmt>
  800863:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800866:	e9 9e fe ff ff       	jmp    800709 <vprintfmt+0x2c>
  80086b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80086e:	89 c3                	mov    %eax,%ebx
  800870:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800873:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800876:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800879:	8b 45 14             	mov    0x14(%ebp),%eax
  80087c:	8d 50 04             	lea    0x4(%eax),%edx
  80087f:	89 55 14             	mov    %edx,0x14(%ebp)
  800882:	8b 00                	mov    (%eax),%eax
  800884:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800887:	85 c0                	test   %eax,%eax
  800889:	75 07                	jne    800892 <vprintfmt+0x1b5>
  80088b:	c7 45 c4 8e 32 80 00 	movl   $0x80328e,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800892:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  800896:	7e 06                	jle    80089e <vprintfmt+0x1c1>
  800898:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80089c:	75 13                	jne    8008b1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80089e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8008a1:	0f be 02             	movsbl (%edx),%eax
  8008a4:	85 c0                	test   %eax,%eax
  8008a6:	0f 85 99 00 00 00    	jne    800945 <vprintfmt+0x268>
  8008ac:	e9 86 00 00 00       	jmp    800937 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8008b5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8008b8:	89 0c 24             	mov    %ecx,(%esp)
  8008bb:	e8 1b 03 00 00       	call   800bdb <strnlen>
  8008c0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8008c3:	29 c2                	sub    %eax,%edx
  8008c5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008c8:	85 d2                	test   %edx,%edx
  8008ca:	7e d2                	jle    80089e <vprintfmt+0x1c1>
					putch(padc, putdat);
  8008cc:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  8008d0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008d3:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  8008d6:	89 d3                	mov    %edx,%ebx
  8008d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008df:	89 04 24             	mov    %eax,(%esp)
  8008e2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e4:	83 eb 01             	sub    $0x1,%ebx
  8008e7:	85 db                	test   %ebx,%ebx
  8008e9:	7f ed                	jg     8008d8 <vprintfmt+0x1fb>
  8008eb:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8008ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8008f5:	eb a7                	jmp    80089e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8008f7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8008fb:	74 18                	je     800915 <vprintfmt+0x238>
  8008fd:	8d 50 e0             	lea    -0x20(%eax),%edx
  800900:	83 fa 5e             	cmp    $0x5e,%edx
  800903:	76 10                	jbe    800915 <vprintfmt+0x238>
					putch('?', putdat);
  800905:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800909:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800910:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800913:	eb 0a                	jmp    80091f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800915:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800919:	89 04 24             	mov    %eax,(%esp)
  80091c:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800923:	0f be 03             	movsbl (%ebx),%eax
  800926:	85 c0                	test   %eax,%eax
  800928:	74 05                	je     80092f <vprintfmt+0x252>
  80092a:	83 c3 01             	add    $0x1,%ebx
  80092d:	eb 29                	jmp    800958 <vprintfmt+0x27b>
  80092f:	89 fe                	mov    %edi,%esi
  800931:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800934:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800937:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093b:	7f 2e                	jg     80096b <vprintfmt+0x28e>
  80093d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800940:	e9 c4 fd ff ff       	jmp    800709 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800945:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800948:	83 c2 01             	add    $0x1,%edx
  80094b:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80094e:	89 f7                	mov    %esi,%edi
  800950:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800953:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  800956:	89 d3                	mov    %edx,%ebx
  800958:	85 f6                	test   %esi,%esi
  80095a:	78 9b                	js     8008f7 <vprintfmt+0x21a>
  80095c:	83 ee 01             	sub    $0x1,%esi
  80095f:	79 96                	jns    8008f7 <vprintfmt+0x21a>
  800961:	89 fe                	mov    %edi,%esi
  800963:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800966:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800969:	eb cc                	jmp    800937 <vprintfmt+0x25a>
  80096b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  80096e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800971:	89 74 24 04          	mov    %esi,0x4(%esp)
  800975:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80097c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80097e:	83 eb 01             	sub    $0x1,%ebx
  800981:	85 db                	test   %ebx,%ebx
  800983:	7f ec                	jg     800971 <vprintfmt+0x294>
  800985:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800988:	e9 7c fd ff ff       	jmp    800709 <vprintfmt+0x2c>
  80098d:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800990:	83 f9 01             	cmp    $0x1,%ecx
  800993:	7e 16                	jle    8009ab <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800995:	8b 45 14             	mov    0x14(%ebp),%eax
  800998:	8d 50 08             	lea    0x8(%eax),%edx
  80099b:	89 55 14             	mov    %edx,0x14(%ebp)
  80099e:	8b 10                	mov    (%eax),%edx
  8009a0:	8b 48 04             	mov    0x4(%eax),%ecx
  8009a3:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8009a6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8009a9:	eb 32                	jmp    8009dd <vprintfmt+0x300>
	else if (lflag)
  8009ab:	85 c9                	test   %ecx,%ecx
  8009ad:	74 18                	je     8009c7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8009af:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b2:	8d 50 04             	lea    0x4(%eax),%edx
  8009b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8009b8:	8b 00                	mov    (%eax),%eax
  8009ba:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009bd:	89 c1                	mov    %eax,%ecx
  8009bf:	c1 f9 1f             	sar    $0x1f,%ecx
  8009c2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8009c5:	eb 16                	jmp    8009dd <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8009c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ca:	8d 50 04             	lea    0x4(%eax),%edx
  8009cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8009d0:	8b 00                	mov    (%eax),%eax
  8009d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009d5:	89 c2                	mov    %eax,%edx
  8009d7:	c1 fa 1f             	sar    $0x1f,%edx
  8009da:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009dd:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8009e0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009e3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8009e8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8009ec:	0f 89 b8 00 00 00    	jns    800aaa <vprintfmt+0x3cd>
				putch('-', putdat);
  8009f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009f6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8009fd:	ff d7                	call   *%edi
				num = -(long long) num;
  8009ff:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800a02:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800a05:	f7 d9                	neg    %ecx
  800a07:	83 d3 00             	adc    $0x0,%ebx
  800a0a:	f7 db                	neg    %ebx
  800a0c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a11:	e9 94 00 00 00       	jmp    800aaa <vprintfmt+0x3cd>
  800a16:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a19:	89 ca                	mov    %ecx,%edx
  800a1b:	8d 45 14             	lea    0x14(%ebp),%eax
  800a1e:	e8 63 fc ff ff       	call   800686 <getuint>
  800a23:	89 c1                	mov    %eax,%ecx
  800a25:	89 d3                	mov    %edx,%ebx
  800a27:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800a2c:	eb 7c                	jmp    800aaa <vprintfmt+0x3cd>
  800a2e:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a31:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a35:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800a3c:	ff d7                	call   *%edi
			putch('X', putdat);
  800a3e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a42:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800a49:	ff d7                	call   *%edi
			putch('X', putdat);
  800a4b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a4f:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800a56:	ff d7                	call   *%edi
  800a58:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800a5b:	e9 a9 fc ff ff       	jmp    800709 <vprintfmt+0x2c>
  800a60:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800a63:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a67:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800a6e:	ff d7                	call   *%edi
			putch('x', putdat);
  800a70:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a74:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a7b:	ff d7                	call   *%edi
			num = (unsigned long long)
  800a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a80:	8d 50 04             	lea    0x4(%eax),%edx
  800a83:	89 55 14             	mov    %edx,0x14(%ebp)
  800a86:	8b 08                	mov    (%eax),%ecx
  800a88:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a8d:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800a92:	eb 16                	jmp    800aaa <vprintfmt+0x3cd>
  800a94:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a97:	89 ca                	mov    %ecx,%edx
  800a99:	8d 45 14             	lea    0x14(%ebp),%eax
  800a9c:	e8 e5 fb ff ff       	call   800686 <getuint>
  800aa1:	89 c1                	mov    %eax,%ecx
  800aa3:	89 d3                	mov    %edx,%ebx
  800aa5:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aaa:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  800aae:	89 54 24 10          	mov    %edx,0x10(%esp)
  800ab2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ab5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800ab9:	89 44 24 08          	mov    %eax,0x8(%esp)
  800abd:	89 0c 24             	mov    %ecx,(%esp)
  800ac0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ac4:	89 f2                	mov    %esi,%edx
  800ac6:	89 f8                	mov    %edi,%eax
  800ac8:	e8 c3 fa ff ff       	call   800590 <printnum>
  800acd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800ad0:	e9 34 fc ff ff       	jmp    800709 <vprintfmt+0x2c>
  800ad5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ad8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800adb:	89 74 24 04          	mov    %esi,0x4(%esp)
  800adf:	89 14 24             	mov    %edx,(%esp)
  800ae2:	ff d7                	call   *%edi
  800ae4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800ae7:	e9 1d fc ff ff       	jmp    800709 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aec:	89 74 24 04          	mov    %esi,0x4(%esp)
  800af0:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800af7:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af9:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800afc:	80 38 25             	cmpb   $0x25,(%eax)
  800aff:	0f 84 04 fc ff ff    	je     800709 <vprintfmt+0x2c>
  800b05:	89 c3                	mov    %eax,%ebx
  800b07:	eb f0                	jmp    800af9 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  800b09:	83 c4 5c             	add    $0x5c,%esp
  800b0c:	5b                   	pop    %ebx
  800b0d:	5e                   	pop    %esi
  800b0e:	5f                   	pop    %edi
  800b0f:	5d                   	pop    %ebp
  800b10:	c3                   	ret    

00800b11 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b11:	55                   	push   %ebp
  800b12:	89 e5                	mov    %esp,%ebp
  800b14:	83 ec 28             	sub    $0x28,%esp
  800b17:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800b1d:	85 c0                	test   %eax,%eax
  800b1f:	74 04                	je     800b25 <vsnprintf+0x14>
  800b21:	85 d2                	test   %edx,%edx
  800b23:	7f 07                	jg     800b2c <vsnprintf+0x1b>
  800b25:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b2a:	eb 3b                	jmp    800b67 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b2f:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800b33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b40:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b44:	8b 45 10             	mov    0x10(%ebp),%eax
  800b47:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b4b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b52:	c7 04 24 c0 06 80 00 	movl   $0x8006c0,(%esp)
  800b59:	e8 7f fb ff ff       	call   8006dd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b61:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b67:	c9                   	leave  
  800b68:	c3                   	ret    

00800b69 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800b6f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800b72:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b76:	8b 45 10             	mov    0x10(%ebp),%eax
  800b79:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b80:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	89 04 24             	mov    %eax,(%esp)
  800b8a:	e8 82 ff ff ff       	call   800b11 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    

00800b91 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800b97:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800b9a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800ba1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	89 04 24             	mov    %eax,(%esp)
  800bb2:	e8 26 fb ff ff       	call   8006dd <vprintfmt>
	va_end(ap);
}
  800bb7:	c9                   	leave  
  800bb8:	c3                   	ret    
  800bb9:	00 00                	add    %al,(%eax)
  800bbb:	00 00                	add    %al,(%eax)
  800bbd:	00 00                	add    %al,(%eax)
	...

00800bc0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bcb:	80 3a 00             	cmpb   $0x0,(%edx)
  800bce:	74 09                	je     800bd9 <strlen+0x19>
		n++;
  800bd0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bd7:	75 f7                	jne    800bd0 <strlen+0x10>
		n++;
	return n;
}
  800bd9:	5d                   	pop    %ebp
  800bda:	c3                   	ret    

00800bdb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	53                   	push   %ebx
  800bdf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800be2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be5:	85 c9                	test   %ecx,%ecx
  800be7:	74 19                	je     800c02 <strnlen+0x27>
  800be9:	80 3b 00             	cmpb   $0x0,(%ebx)
  800bec:	74 14                	je     800c02 <strnlen+0x27>
  800bee:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800bf3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bf6:	39 c8                	cmp    %ecx,%eax
  800bf8:	74 0d                	je     800c07 <strnlen+0x2c>
  800bfa:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800bfe:	75 f3                	jne    800bf3 <strnlen+0x18>
  800c00:	eb 05                	jmp    800c07 <strnlen+0x2c>
  800c02:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800c07:	5b                   	pop    %ebx
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	53                   	push   %ebx
  800c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c11:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800c14:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c19:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800c1d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c20:	83 c2 01             	add    $0x1,%edx
  800c23:	84 c9                	test   %cl,%cl
  800c25:	75 f2                	jne    800c19 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c27:	5b                   	pop    %ebx
  800c28:	5d                   	pop    %ebp
  800c29:	c3                   	ret    

00800c2a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	56                   	push   %esi
  800c2e:	53                   	push   %ebx
  800c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c35:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c38:	85 f6                	test   %esi,%esi
  800c3a:	74 18                	je     800c54 <strncpy+0x2a>
  800c3c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800c41:	0f b6 1a             	movzbl (%edx),%ebx
  800c44:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c47:	80 3a 01             	cmpb   $0x1,(%edx)
  800c4a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c4d:	83 c1 01             	add    $0x1,%ecx
  800c50:	39 ce                	cmp    %ecx,%esi
  800c52:	77 ed                	ja     800c41 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800c54:	5b                   	pop    %ebx
  800c55:	5e                   	pop    %esi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    

00800c58 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	56                   	push   %esi
  800c5c:	53                   	push   %ebx
  800c5d:	8b 75 08             	mov    0x8(%ebp),%esi
  800c60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c63:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c66:	89 f0                	mov    %esi,%eax
  800c68:	85 c9                	test   %ecx,%ecx
  800c6a:	74 27                	je     800c93 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800c6c:	83 e9 01             	sub    $0x1,%ecx
  800c6f:	74 1d                	je     800c8e <strlcpy+0x36>
  800c71:	0f b6 1a             	movzbl (%edx),%ebx
  800c74:	84 db                	test   %bl,%bl
  800c76:	74 16                	je     800c8e <strlcpy+0x36>
			*dst++ = *src++;
  800c78:	88 18                	mov    %bl,(%eax)
  800c7a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c7d:	83 e9 01             	sub    $0x1,%ecx
  800c80:	74 0e                	je     800c90 <strlcpy+0x38>
			*dst++ = *src++;
  800c82:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c85:	0f b6 1a             	movzbl (%edx),%ebx
  800c88:	84 db                	test   %bl,%bl
  800c8a:	75 ec                	jne    800c78 <strlcpy+0x20>
  800c8c:	eb 02                	jmp    800c90 <strlcpy+0x38>
  800c8e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800c90:	c6 00 00             	movb   $0x0,(%eax)
  800c93:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800c95:	5b                   	pop    %ebx
  800c96:	5e                   	pop    %esi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    

00800c99 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c99:	55                   	push   %ebp
  800c9a:	89 e5                	mov    %esp,%ebp
  800c9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ca2:	0f b6 01             	movzbl (%ecx),%eax
  800ca5:	84 c0                	test   %al,%al
  800ca7:	74 15                	je     800cbe <strcmp+0x25>
  800ca9:	3a 02                	cmp    (%edx),%al
  800cab:	75 11                	jne    800cbe <strcmp+0x25>
		p++, q++;
  800cad:	83 c1 01             	add    $0x1,%ecx
  800cb0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cb3:	0f b6 01             	movzbl (%ecx),%eax
  800cb6:	84 c0                	test   %al,%al
  800cb8:	74 04                	je     800cbe <strcmp+0x25>
  800cba:	3a 02                	cmp    (%edx),%al
  800cbc:	74 ef                	je     800cad <strcmp+0x14>
  800cbe:	0f b6 c0             	movzbl %al,%eax
  800cc1:	0f b6 12             	movzbl (%edx),%edx
  800cc4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800cc6:	5d                   	pop    %ebp
  800cc7:	c3                   	ret    

00800cc8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	53                   	push   %ebx
  800ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ccf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800cd5:	85 c0                	test   %eax,%eax
  800cd7:	74 23                	je     800cfc <strncmp+0x34>
  800cd9:	0f b6 1a             	movzbl (%edx),%ebx
  800cdc:	84 db                	test   %bl,%bl
  800cde:	74 24                	je     800d04 <strncmp+0x3c>
  800ce0:	3a 19                	cmp    (%ecx),%bl
  800ce2:	75 20                	jne    800d04 <strncmp+0x3c>
  800ce4:	83 e8 01             	sub    $0x1,%eax
  800ce7:	74 13                	je     800cfc <strncmp+0x34>
		n--, p++, q++;
  800ce9:	83 c2 01             	add    $0x1,%edx
  800cec:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800cef:	0f b6 1a             	movzbl (%edx),%ebx
  800cf2:	84 db                	test   %bl,%bl
  800cf4:	74 0e                	je     800d04 <strncmp+0x3c>
  800cf6:	3a 19                	cmp    (%ecx),%bl
  800cf8:	74 ea                	je     800ce4 <strncmp+0x1c>
  800cfa:	eb 08                	jmp    800d04 <strncmp+0x3c>
  800cfc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800d01:	5b                   	pop    %ebx
  800d02:	5d                   	pop    %ebp
  800d03:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d04:	0f b6 02             	movzbl (%edx),%eax
  800d07:	0f b6 11             	movzbl (%ecx),%edx
  800d0a:	29 d0                	sub    %edx,%eax
  800d0c:	eb f3                	jmp    800d01 <strncmp+0x39>

00800d0e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d18:	0f b6 10             	movzbl (%eax),%edx
  800d1b:	84 d2                	test   %dl,%dl
  800d1d:	74 15                	je     800d34 <strchr+0x26>
		if (*s == c)
  800d1f:	38 ca                	cmp    %cl,%dl
  800d21:	75 07                	jne    800d2a <strchr+0x1c>
  800d23:	eb 14                	jmp    800d39 <strchr+0x2b>
  800d25:	38 ca                	cmp    %cl,%dl
  800d27:	90                   	nop
  800d28:	74 0f                	je     800d39 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d2a:	83 c0 01             	add    $0x1,%eax
  800d2d:	0f b6 10             	movzbl (%eax),%edx
  800d30:	84 d2                	test   %dl,%dl
  800d32:	75 f1                	jne    800d25 <strchr+0x17>
  800d34:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800d39:	5d                   	pop    %ebp
  800d3a:	c3                   	ret    

00800d3b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d3b:	55                   	push   %ebp
  800d3c:	89 e5                	mov    %esp,%ebp
  800d3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d41:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d45:	0f b6 10             	movzbl (%eax),%edx
  800d48:	84 d2                	test   %dl,%dl
  800d4a:	74 18                	je     800d64 <strfind+0x29>
		if (*s == c)
  800d4c:	38 ca                	cmp    %cl,%dl
  800d4e:	75 0a                	jne    800d5a <strfind+0x1f>
  800d50:	eb 12                	jmp    800d64 <strfind+0x29>
  800d52:	38 ca                	cmp    %cl,%dl
  800d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800d58:	74 0a                	je     800d64 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d5a:	83 c0 01             	add    $0x1,%eax
  800d5d:	0f b6 10             	movzbl (%eax),%edx
  800d60:	84 d2                	test   %dl,%dl
  800d62:	75 ee                	jne    800d52 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800d64:	5d                   	pop    %ebp
  800d65:	c3                   	ret    

00800d66 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	83 ec 0c             	sub    $0xc,%esp
  800d6c:	89 1c 24             	mov    %ebx,(%esp)
  800d6f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d73:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800d77:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d80:	85 c9                	test   %ecx,%ecx
  800d82:	74 30                	je     800db4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d84:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d8a:	75 25                	jne    800db1 <memset+0x4b>
  800d8c:	f6 c1 03             	test   $0x3,%cl
  800d8f:	75 20                	jne    800db1 <memset+0x4b>
		c &= 0xFF;
  800d91:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d94:	89 d3                	mov    %edx,%ebx
  800d96:	c1 e3 08             	shl    $0x8,%ebx
  800d99:	89 d6                	mov    %edx,%esi
  800d9b:	c1 e6 18             	shl    $0x18,%esi
  800d9e:	89 d0                	mov    %edx,%eax
  800da0:	c1 e0 10             	shl    $0x10,%eax
  800da3:	09 f0                	or     %esi,%eax
  800da5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800da7:	09 d8                	or     %ebx,%eax
  800da9:	c1 e9 02             	shr    $0x2,%ecx
  800dac:	fc                   	cld    
  800dad:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800daf:	eb 03                	jmp    800db4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800db1:	fc                   	cld    
  800db2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800db4:	89 f8                	mov    %edi,%eax
  800db6:	8b 1c 24             	mov    (%esp),%ebx
  800db9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800dbd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800dc1:	89 ec                	mov    %ebp,%esp
  800dc3:	5d                   	pop    %ebp
  800dc4:	c3                   	ret    

00800dc5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 08             	sub    $0x8,%esp
  800dcb:	89 34 24             	mov    %esi,(%esp)
  800dce:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800dd8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800ddb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800ddd:	39 c6                	cmp    %eax,%esi
  800ddf:	73 35                	jae    800e16 <memmove+0x51>
  800de1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800de4:	39 d0                	cmp    %edx,%eax
  800de6:	73 2e                	jae    800e16 <memmove+0x51>
		s += n;
		d += n;
  800de8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dea:	f6 c2 03             	test   $0x3,%dl
  800ded:	75 1b                	jne    800e0a <memmove+0x45>
  800def:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800df5:	75 13                	jne    800e0a <memmove+0x45>
  800df7:	f6 c1 03             	test   $0x3,%cl
  800dfa:	75 0e                	jne    800e0a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800dfc:	83 ef 04             	sub    $0x4,%edi
  800dff:	8d 72 fc             	lea    -0x4(%edx),%esi
  800e02:	c1 e9 02             	shr    $0x2,%ecx
  800e05:	fd                   	std    
  800e06:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e08:	eb 09                	jmp    800e13 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800e0a:	83 ef 01             	sub    $0x1,%edi
  800e0d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800e10:	fd                   	std    
  800e11:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800e13:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e14:	eb 20                	jmp    800e36 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e16:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800e1c:	75 15                	jne    800e33 <memmove+0x6e>
  800e1e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e24:	75 0d                	jne    800e33 <memmove+0x6e>
  800e26:	f6 c1 03             	test   $0x3,%cl
  800e29:	75 08                	jne    800e33 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800e2b:	c1 e9 02             	shr    $0x2,%ecx
  800e2e:	fc                   	cld    
  800e2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e31:	eb 03                	jmp    800e36 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e33:	fc                   	cld    
  800e34:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e36:	8b 34 24             	mov    (%esp),%esi
  800e39:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800e3d:	89 ec                	mov    %ebp,%esp
  800e3f:	5d                   	pop    %ebp
  800e40:	c3                   	ret    

00800e41 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e47:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e51:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	89 04 24             	mov    %eax,(%esp)
  800e5b:	e8 65 ff ff ff       	call   800dc5 <memmove>
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	57                   	push   %edi
  800e66:	56                   	push   %esi
  800e67:	53                   	push   %ebx
  800e68:	8b 75 08             	mov    0x8(%ebp),%esi
  800e6b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e71:	85 c9                	test   %ecx,%ecx
  800e73:	74 36                	je     800eab <memcmp+0x49>
		if (*s1 != *s2)
  800e75:	0f b6 06             	movzbl (%esi),%eax
  800e78:	0f b6 1f             	movzbl (%edi),%ebx
  800e7b:	38 d8                	cmp    %bl,%al
  800e7d:	74 20                	je     800e9f <memcmp+0x3d>
  800e7f:	eb 14                	jmp    800e95 <memcmp+0x33>
  800e81:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800e86:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800e8b:	83 c2 01             	add    $0x1,%edx
  800e8e:	83 e9 01             	sub    $0x1,%ecx
  800e91:	38 d8                	cmp    %bl,%al
  800e93:	74 12                	je     800ea7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800e95:	0f b6 c0             	movzbl %al,%eax
  800e98:	0f b6 db             	movzbl %bl,%ebx
  800e9b:	29 d8                	sub    %ebx,%eax
  800e9d:	eb 11                	jmp    800eb0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e9f:	83 e9 01             	sub    $0x1,%ecx
  800ea2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea7:	85 c9                	test   %ecx,%ecx
  800ea9:	75 d6                	jne    800e81 <memcmp+0x1f>
  800eab:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800eb0:	5b                   	pop    %ebx
  800eb1:	5e                   	pop    %esi
  800eb2:	5f                   	pop    %edi
  800eb3:	5d                   	pop    %ebp
  800eb4:	c3                   	ret    

00800eb5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800eb5:	55                   	push   %ebp
  800eb6:	89 e5                	mov    %esp,%ebp
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800ebb:	89 c2                	mov    %eax,%edx
  800ebd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ec0:	39 d0                	cmp    %edx,%eax
  800ec2:	73 15                	jae    800ed9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ec4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800ec8:	38 08                	cmp    %cl,(%eax)
  800eca:	75 06                	jne    800ed2 <memfind+0x1d>
  800ecc:	eb 0b                	jmp    800ed9 <memfind+0x24>
  800ece:	38 08                	cmp    %cl,(%eax)
  800ed0:	74 07                	je     800ed9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ed2:	83 c0 01             	add    $0x1,%eax
  800ed5:	39 c2                	cmp    %eax,%edx
  800ed7:	77 f5                	ja     800ece <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800ed9:	5d                   	pop    %ebp
  800eda:	c3                   	ret    

00800edb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	57                   	push   %edi
  800edf:	56                   	push   %esi
  800ee0:	53                   	push   %ebx
  800ee1:	83 ec 04             	sub    $0x4,%esp
  800ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eea:	0f b6 02             	movzbl (%edx),%eax
  800eed:	3c 20                	cmp    $0x20,%al
  800eef:	74 04                	je     800ef5 <strtol+0x1a>
  800ef1:	3c 09                	cmp    $0x9,%al
  800ef3:	75 0e                	jne    800f03 <strtol+0x28>
		s++;
  800ef5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ef8:	0f b6 02             	movzbl (%edx),%eax
  800efb:	3c 20                	cmp    $0x20,%al
  800efd:	74 f6                	je     800ef5 <strtol+0x1a>
  800eff:	3c 09                	cmp    $0x9,%al
  800f01:	74 f2                	je     800ef5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f03:	3c 2b                	cmp    $0x2b,%al
  800f05:	75 0c                	jne    800f13 <strtol+0x38>
		s++;
  800f07:	83 c2 01             	add    $0x1,%edx
  800f0a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f11:	eb 15                	jmp    800f28 <strtol+0x4d>
	else if (*s == '-')
  800f13:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800f1a:	3c 2d                	cmp    $0x2d,%al
  800f1c:	75 0a                	jne    800f28 <strtol+0x4d>
		s++, neg = 1;
  800f1e:	83 c2 01             	add    $0x1,%edx
  800f21:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f28:	85 db                	test   %ebx,%ebx
  800f2a:	0f 94 c0             	sete   %al
  800f2d:	74 05                	je     800f34 <strtol+0x59>
  800f2f:	83 fb 10             	cmp    $0x10,%ebx
  800f32:	75 18                	jne    800f4c <strtol+0x71>
  800f34:	80 3a 30             	cmpb   $0x30,(%edx)
  800f37:	75 13                	jne    800f4c <strtol+0x71>
  800f39:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f3d:	8d 76 00             	lea    0x0(%esi),%esi
  800f40:	75 0a                	jne    800f4c <strtol+0x71>
		s += 2, base = 16;
  800f42:	83 c2 02             	add    $0x2,%edx
  800f45:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f4a:	eb 15                	jmp    800f61 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f4c:	84 c0                	test   %al,%al
  800f4e:	66 90                	xchg   %ax,%ax
  800f50:	74 0f                	je     800f61 <strtol+0x86>
  800f52:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800f57:	80 3a 30             	cmpb   $0x30,(%edx)
  800f5a:	75 05                	jne    800f61 <strtol+0x86>
		s++, base = 8;
  800f5c:	83 c2 01             	add    $0x1,%edx
  800f5f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f61:	b8 00 00 00 00       	mov    $0x0,%eax
  800f66:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f68:	0f b6 0a             	movzbl (%edx),%ecx
  800f6b:	89 cf                	mov    %ecx,%edi
  800f6d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800f70:	80 fb 09             	cmp    $0x9,%bl
  800f73:	77 08                	ja     800f7d <strtol+0xa2>
			dig = *s - '0';
  800f75:	0f be c9             	movsbl %cl,%ecx
  800f78:	83 e9 30             	sub    $0x30,%ecx
  800f7b:	eb 1e                	jmp    800f9b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800f7d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800f80:	80 fb 19             	cmp    $0x19,%bl
  800f83:	77 08                	ja     800f8d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800f85:	0f be c9             	movsbl %cl,%ecx
  800f88:	83 e9 57             	sub    $0x57,%ecx
  800f8b:	eb 0e                	jmp    800f9b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800f8d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800f90:	80 fb 19             	cmp    $0x19,%bl
  800f93:	77 15                	ja     800faa <strtol+0xcf>
			dig = *s - 'A' + 10;
  800f95:	0f be c9             	movsbl %cl,%ecx
  800f98:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f9b:	39 f1                	cmp    %esi,%ecx
  800f9d:	7d 0b                	jge    800faa <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800f9f:	83 c2 01             	add    $0x1,%edx
  800fa2:	0f af c6             	imul   %esi,%eax
  800fa5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800fa8:	eb be                	jmp    800f68 <strtol+0x8d>
  800faa:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800fac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fb0:	74 05                	je     800fb7 <strtol+0xdc>
		*endptr = (char *) s;
  800fb2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800fb5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800fb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800fbb:	74 04                	je     800fc1 <strtol+0xe6>
  800fbd:	89 c8                	mov    %ecx,%eax
  800fbf:	f7 d8                	neg    %eax
}
  800fc1:	83 c4 04             	add    $0x4,%esp
  800fc4:	5b                   	pop    %ebx
  800fc5:	5e                   	pop    %esi
  800fc6:	5f                   	pop    %edi
  800fc7:	5d                   	pop    %ebp
  800fc8:	c3                   	ret    
  800fc9:	00 00                	add    %al,(%eax)
	...

00800fcc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800fcc:	55                   	push   %ebp
  800fcd:	89 e5                	mov    %esp,%ebp
  800fcf:	83 ec 0c             	sub    $0xc,%esp
  800fd2:	89 1c 24             	mov    %ebx,(%esp)
  800fd5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fd9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fdd:	ba 00 00 00 00       	mov    $0x0,%edx
  800fe2:	b8 01 00 00 00       	mov    $0x1,%eax
  800fe7:	89 d1                	mov    %edx,%ecx
  800fe9:	89 d3                	mov    %edx,%ebx
  800feb:	89 d7                	mov    %edx,%edi
  800fed:	89 d6                	mov    %edx,%esi
  800fef:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ff1:	8b 1c 24             	mov    (%esp),%ebx
  800ff4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ff8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ffc:	89 ec                	mov    %ebp,%esp
  800ffe:	5d                   	pop    %ebp
  800fff:	c3                   	ret    

00801000 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 0c             	sub    $0xc,%esp
  801006:	89 1c 24             	mov    %ebx,(%esp)
  801009:	89 74 24 04          	mov    %esi,0x4(%esp)
  80100d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801011:	b8 00 00 00 00       	mov    $0x0,%eax
  801016:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801019:	8b 55 08             	mov    0x8(%ebp),%edx
  80101c:	89 c3                	mov    %eax,%ebx
  80101e:	89 c7                	mov    %eax,%edi
  801020:	89 c6                	mov    %eax,%esi
  801022:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801024:	8b 1c 24             	mov    (%esp),%ebx
  801027:	8b 74 24 04          	mov    0x4(%esp),%esi
  80102b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80102f:	89 ec                	mov    %ebp,%esp
  801031:	5d                   	pop    %ebp
  801032:	c3                   	ret    

00801033 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	83 ec 0c             	sub    $0xc,%esp
  801039:	89 1c 24             	mov    %ebx,(%esp)
  80103c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801040:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801044:	bb 00 00 00 00       	mov    $0x0,%ebx
  801049:	b8 10 00 00 00       	mov    $0x10,%eax
  80104e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801051:	8b 55 08             	mov    0x8(%ebp),%edx
  801054:	89 df                	mov    %ebx,%edi
  801056:	89 de                	mov    %ebx,%esi
  801058:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  80105a:	8b 1c 24             	mov    (%esp),%ebx
  80105d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801061:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801065:	89 ec                	mov    %ebp,%esp
  801067:	5d                   	pop    %ebp
  801068:	c3                   	ret    

00801069 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
  80106c:	83 ec 38             	sub    $0x38,%esp
  80106f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801072:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801075:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801078:	bb 00 00 00 00       	mov    $0x0,%ebx
  80107d:	b8 0f 00 00 00       	mov    $0xf,%eax
  801082:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801085:	8b 55 08             	mov    0x8(%ebp),%edx
  801088:	89 df                	mov    %ebx,%edi
  80108a:	89 de                	mov    %ebx,%esi
  80108c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80108e:	85 c0                	test   %eax,%eax
  801090:	7e 28                	jle    8010ba <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801092:	89 44 24 10          	mov    %eax,0x10(%esp)
  801096:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80109d:	00 
  80109e:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  8010a5:	00 
  8010a6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010ad:	00 
  8010ae:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  8010b5:	e8 b2 f3 ff ff       	call   80046c <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  8010ba:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010bd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010c0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010c3:	89 ec                	mov    %ebp,%esp
  8010c5:	5d                   	pop    %ebp
  8010c6:	c3                   	ret    

008010c7 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  8010c7:	55                   	push   %ebp
  8010c8:	89 e5                	mov    %esp,%ebp
  8010ca:	83 ec 0c             	sub    $0xc,%esp
  8010cd:	89 1c 24             	mov    %ebx,(%esp)
  8010d0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010d4:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8010dd:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010e2:	89 d1                	mov    %edx,%ecx
  8010e4:	89 d3                	mov    %edx,%ebx
  8010e6:	89 d7                	mov    %edx,%edi
  8010e8:	89 d6                	mov    %edx,%esi
  8010ea:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010ec:	8b 1c 24             	mov    (%esp),%ebx
  8010ef:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010f3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010f7:	89 ec                	mov    %ebp,%esp
  8010f9:	5d                   	pop    %ebp
  8010fa:	c3                   	ret    

008010fb <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	83 ec 38             	sub    $0x38,%esp
  801101:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801104:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801107:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80110a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80110f:	b8 0d 00 00 00       	mov    $0xd,%eax
  801114:	8b 55 08             	mov    0x8(%ebp),%edx
  801117:	89 cb                	mov    %ecx,%ebx
  801119:	89 cf                	mov    %ecx,%edi
  80111b:	89 ce                	mov    %ecx,%esi
  80111d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80111f:	85 c0                	test   %eax,%eax
  801121:	7e 28                	jle    80114b <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801123:	89 44 24 10          	mov    %eax,0x10(%esp)
  801127:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80112e:	00 
  80112f:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  801136:	00 
  801137:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80113e:	00 
  80113f:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  801146:	e8 21 f3 ff ff       	call   80046c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80114b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80114e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801151:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801154:	89 ec                	mov    %ebp,%esp
  801156:	5d                   	pop    %ebp
  801157:	c3                   	ret    

00801158 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	83 ec 0c             	sub    $0xc,%esp
  80115e:	89 1c 24             	mov    %ebx,(%esp)
  801161:	89 74 24 04          	mov    %esi,0x4(%esp)
  801165:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801169:	be 00 00 00 00       	mov    $0x0,%esi
  80116e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801173:	8b 7d 14             	mov    0x14(%ebp),%edi
  801176:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801179:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80117c:	8b 55 08             	mov    0x8(%ebp),%edx
  80117f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801181:	8b 1c 24             	mov    (%esp),%ebx
  801184:	8b 74 24 04          	mov    0x4(%esp),%esi
  801188:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80118c:	89 ec                	mov    %ebp,%esp
  80118e:	5d                   	pop    %ebp
  80118f:	c3                   	ret    

00801190 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801190:	55                   	push   %ebp
  801191:	89 e5                	mov    %esp,%ebp
  801193:	83 ec 38             	sub    $0x38,%esp
  801196:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801199:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80119c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80119f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8011a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8011af:	89 df                	mov    %ebx,%edi
  8011b1:	89 de                	mov    %ebx,%esi
  8011b3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011b5:	85 c0                	test   %eax,%eax
  8011b7:	7e 28                	jle    8011e1 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011bd:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8011c4:	00 
  8011c5:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  8011cc:	00 
  8011cd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011d4:	00 
  8011d5:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  8011dc:	e8 8b f2 ff ff       	call   80046c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011e1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011e4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011e7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011ea:	89 ec                	mov    %ebp,%esp
  8011ec:	5d                   	pop    %ebp
  8011ed:	c3                   	ret    

008011ee <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 38             	sub    $0x38,%esp
  8011f4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011f7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011fa:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801202:	b8 09 00 00 00       	mov    $0x9,%eax
  801207:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80120a:	8b 55 08             	mov    0x8(%ebp),%edx
  80120d:	89 df                	mov    %ebx,%edi
  80120f:	89 de                	mov    %ebx,%esi
  801211:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801213:	85 c0                	test   %eax,%eax
  801215:	7e 28                	jle    80123f <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801217:	89 44 24 10          	mov    %eax,0x10(%esp)
  80121b:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801222:	00 
  801223:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  80122a:	00 
  80122b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801232:	00 
  801233:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  80123a:	e8 2d f2 ff ff       	call   80046c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80123f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801242:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801245:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801248:	89 ec                	mov    %ebp,%esp
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    

0080124c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
  80124f:	83 ec 38             	sub    $0x38,%esp
  801252:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801255:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801258:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80125b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801260:	b8 08 00 00 00       	mov    $0x8,%eax
  801265:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801268:	8b 55 08             	mov    0x8(%ebp),%edx
  80126b:	89 df                	mov    %ebx,%edi
  80126d:	89 de                	mov    %ebx,%esi
  80126f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801271:	85 c0                	test   %eax,%eax
  801273:	7e 28                	jle    80129d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801275:	89 44 24 10          	mov    %eax,0x10(%esp)
  801279:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801280:	00 
  801281:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  801288:	00 
  801289:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801290:	00 
  801291:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  801298:	e8 cf f1 ff ff       	call   80046c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80129d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012a0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012a3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012a6:	89 ec                	mov    %ebp,%esp
  8012a8:	5d                   	pop    %ebp
  8012a9:	c3                   	ret    

008012aa <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8012aa:	55                   	push   %ebp
  8012ab:	89 e5                	mov    %esp,%ebp
  8012ad:	83 ec 38             	sub    $0x38,%esp
  8012b0:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012b3:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012b6:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012be:	b8 06 00 00 00       	mov    $0x6,%eax
  8012c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012c9:	89 df                	mov    %ebx,%edi
  8012cb:	89 de                	mov    %ebx,%esi
  8012cd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8012cf:	85 c0                	test   %eax,%eax
  8012d1:	7e 28                	jle    8012fb <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012d3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012d7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8012de:	00 
  8012df:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  8012e6:	00 
  8012e7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012ee:	00 
  8012ef:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  8012f6:	e8 71 f1 ff ff       	call   80046c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012fb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012fe:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801301:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801304:	89 ec                	mov    %ebp,%esp
  801306:	5d                   	pop    %ebp
  801307:	c3                   	ret    

00801308 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801308:	55                   	push   %ebp
  801309:	89 e5                	mov    %esp,%ebp
  80130b:	83 ec 38             	sub    $0x38,%esp
  80130e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801311:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801314:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801317:	b8 05 00 00 00       	mov    $0x5,%eax
  80131c:	8b 75 18             	mov    0x18(%ebp),%esi
  80131f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801322:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801325:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801328:	8b 55 08             	mov    0x8(%ebp),%edx
  80132b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80132d:	85 c0                	test   %eax,%eax
  80132f:	7e 28                	jle    801359 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801331:	89 44 24 10          	mov    %eax,0x10(%esp)
  801335:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80133c:	00 
  80133d:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  801344:	00 
  801345:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80134c:	00 
  80134d:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  801354:	e8 13 f1 ff ff       	call   80046c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801359:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80135c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80135f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801362:	89 ec                	mov    %ebp,%esp
  801364:	5d                   	pop    %ebp
  801365:	c3                   	ret    

00801366 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801366:	55                   	push   %ebp
  801367:	89 e5                	mov    %esp,%ebp
  801369:	83 ec 38             	sub    $0x38,%esp
  80136c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80136f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801372:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801375:	be 00 00 00 00       	mov    $0x0,%esi
  80137a:	b8 04 00 00 00       	mov    $0x4,%eax
  80137f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801382:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801385:	8b 55 08             	mov    0x8(%ebp),%edx
  801388:	89 f7                	mov    %esi,%edi
  80138a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80138c:	85 c0                	test   %eax,%eax
  80138e:	7e 28                	jle    8013b8 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801390:	89 44 24 10          	mov    %eax,0x10(%esp)
  801394:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80139b:	00 
  80139c:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  8013a3:	00 
  8013a4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013ab:	00 
  8013ac:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  8013b3:	e8 b4 f0 ff ff       	call   80046c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8013b8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013bb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013be:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013c1:	89 ec                	mov    %ebp,%esp
  8013c3:	5d                   	pop    %ebp
  8013c4:	c3                   	ret    

008013c5 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8013c5:	55                   	push   %ebp
  8013c6:	89 e5                	mov    %esp,%ebp
  8013c8:	83 ec 0c             	sub    $0xc,%esp
  8013cb:	89 1c 24             	mov    %ebx,(%esp)
  8013ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013d2:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8013db:	b8 0b 00 00 00       	mov    $0xb,%eax
  8013e0:	89 d1                	mov    %edx,%ecx
  8013e2:	89 d3                	mov    %edx,%ebx
  8013e4:	89 d7                	mov    %edx,%edi
  8013e6:	89 d6                	mov    %edx,%esi
  8013e8:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8013ea:	8b 1c 24             	mov    (%esp),%ebx
  8013ed:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013f1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013f5:	89 ec                	mov    %ebp,%esp
  8013f7:	5d                   	pop    %ebp
  8013f8:	c3                   	ret    

008013f9 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 0c             	sub    $0xc,%esp
  8013ff:	89 1c 24             	mov    %ebx,(%esp)
  801402:	89 74 24 04          	mov    %esi,0x4(%esp)
  801406:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80140a:	ba 00 00 00 00       	mov    $0x0,%edx
  80140f:	b8 02 00 00 00       	mov    $0x2,%eax
  801414:	89 d1                	mov    %edx,%ecx
  801416:	89 d3                	mov    %edx,%ebx
  801418:	89 d7                	mov    %edx,%edi
  80141a:	89 d6                	mov    %edx,%esi
  80141c:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80141e:	8b 1c 24             	mov    (%esp),%ebx
  801421:	8b 74 24 04          	mov    0x4(%esp),%esi
  801425:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801429:	89 ec                	mov    %ebp,%esp
  80142b:	5d                   	pop    %ebp
  80142c:	c3                   	ret    

0080142d <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  80142d:	55                   	push   %ebp
  80142e:	89 e5                	mov    %esp,%ebp
  801430:	83 ec 38             	sub    $0x38,%esp
  801433:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801436:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801439:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80143c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801441:	b8 03 00 00 00       	mov    $0x3,%eax
  801446:	8b 55 08             	mov    0x8(%ebp),%edx
  801449:	89 cb                	mov    %ecx,%ebx
  80144b:	89 cf                	mov    %ecx,%edi
  80144d:	89 ce                	mov    %ecx,%esi
  80144f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801451:	85 c0                	test   %eax,%eax
  801453:	7e 28                	jle    80147d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801455:	89 44 24 10          	mov    %eax,0x10(%esp)
  801459:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801460:	00 
  801461:	c7 44 24 08 7f 35 80 	movl   $0x80357f,0x8(%esp)
  801468:	00 
  801469:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801470:	00 
  801471:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  801478:	e8 ef ef ff ff       	call   80046c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80147d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801480:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801483:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801486:	89 ec                	mov    %ebp,%esp
  801488:	5d                   	pop    %ebp
  801489:	c3                   	ret    
	...

0080148c <sfork>:
}

// Challenge!
int
sfork(void)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801492:	c7 44 24 08 aa 35 80 	movl   $0x8035aa,0x8(%esp)
  801499:	00 
  80149a:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  8014a1:	00 
  8014a2:	c7 04 24 c0 35 80 00 	movl   $0x8035c0,(%esp)
  8014a9:	e8 be ef ff ff       	call   80046c <_panic>

008014ae <duppage>:
// It is also OK to panic on error.
// 

static int
duppage(envid_t envid, unsigned pn)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	83 ec 28             	sub    $0x28,%esp
  8014b4:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8014b7:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8014ba:	89 c3                	mov    %eax,%ebx
	int r;

	// LAB 4: Your code here.
     pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  8014bc:	89 d6                	mov    %edx,%esi
  8014be:	c1 e6 0c             	shl    $0xc,%esi
  8014c1:	89 f0                	mov    %esi,%eax
  8014c3:	c1 e8 16             	shr    $0x16,%eax
  8014c6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
       
        if( 0 == pgDirEntry )
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	0f 84 fc 00 00 00    	je     8015d1 <duppage+0x123>
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  8014d5:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8014dc:	89 c2                	mov    %eax,%edx
  8014de:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        //cprintf("Below %d",vpt[pn]);
                //if(perm!=0)  //commented nw.
                   // cprintf("perm bit %d",perm);
	
	
	if((perm & PTE_W) && (perm & PTE_SHARE))
  8014e4:	25 02 04 00 00       	and    $0x402,%eax
  8014e9:	3d 02 04 00 00       	cmp    $0x402,%eax
  8014ee:	75 4d                	jne    80153d <duppage+0x8f>
	{	
		if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_SHARE|(perm & PTE_USER))) < 0)
  8014f0:	81 e2 07 0a 00 00    	and    $0xa07,%edx
  8014f6:	80 ce 04             	or     $0x4,%dh
  8014f9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8014fd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801501:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801505:	89 74 24 04          	mov    %esi,0x4(%esp)
  801509:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801510:	e8 f3 fd ff ff       	call   801308 <sys_page_map>
  801515:	85 c0                	test   %eax,%eax
  801517:	0f 89 bb 00 00 00    	jns    8015d8 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  80151d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801521:	c7 44 24 08 cb 35 80 	movl   $0x8035cb,0x8(%esp)
  801528:	00 
  801529:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  801530:	00 
  801531:	c7 04 24 c0 35 80 00 	movl   $0x8035c0,(%esp)
  801538:	e8 2f ef ff ff       	call   80046c <_panic>
	}	


        else if((perm & PTE_W)!=0 || (perm & PTE_COW)!=0)
  80153d:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801543:	0f 84 8f 00 00 00    	je     8015d8 <duppage+0x12a>
         {
          //cprintf("\nInside Setting Cow\n"); 
        if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  801549:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801550:	00 
  801551:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801555:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801559:	89 74 24 04          	mov    %esi,0x4(%esp)
  80155d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801564:	e8 9f fd ff ff       	call   801308 <sys_page_map>
  801569:	85 c0                	test   %eax,%eax
  80156b:	79 20                	jns    80158d <duppage+0xdf>
                panic("sys_page_map: %e", r);
  80156d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801571:	c7 44 24 08 cb 35 80 	movl   $0x8035cb,0x8(%esp)
  801578:	00 
  801579:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801580:	00 
  801581:	c7 04 24 c0 35 80 00 	movl   $0x8035c0,(%esp)
  801588:	e8 df ee ff ff       	call   80046c <_panic>
        if ((r = sys_page_map(envid,(void *)(pn*PGSIZE),0,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  80158d:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801594:	00 
  801595:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801599:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015a0:	00 
  8015a1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015a5:	89 1c 24             	mov    %ebx,(%esp)
  8015a8:	e8 5b fd ff ff       	call   801308 <sys_page_map>
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	79 27                	jns    8015d8 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  8015b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015b5:	c7 44 24 08 cb 35 80 	movl   $0x8035cb,0x8(%esp)
  8015bc:	00 
  8015bd:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8015c4:	00 
  8015c5:	c7 04 24 c0 35 80 00 	movl   $0x8035c0,(%esp)
  8015cc:	e8 9b ee ff ff       	call   80046c <_panic>
  8015d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8015d6:	eb 05                	jmp    8015dd <duppage+0x12f>
  8015d8:	b8 00 00 00 00       	mov    $0x0,%eax
         }


//	panic("duppage not implemented");
	return 0;
}
  8015dd:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8015e0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8015e3:	89 ec                	mov    %ebp,%esp
  8015e5:	5d                   	pop    %ebp
  8015e6:	c3                   	ret    

008015e7 <fork>:
//


envid_t
fork(void)
{
  8015e7:	55                   	push   %ebp
  8015e8:	89 e5                	mov    %esp,%ebp
  8015ea:	56                   	push   %esi
  8015eb:	53                   	push   %ebx
  8015ec:	83 ec 10             	sub    $0x10,%esp

        envid_t envid;
        uint8_t *addr;
        int r;
        extern unsigned char end[];
        set_pgfault_handler(pgfault);
  8015ef:	c7 04 24 fe 16 80 00 	movl   $0x8016fe,(%esp)
  8015f6:	e8 21 16 00 00       	call   802c1c <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8015fb:	be 07 00 00 00       	mov    $0x7,%esi
  801600:	89 f0                	mov    %esi,%eax
  801602:	cd 30                	int    $0x30
  801604:	89 c6                	mov    %eax,%esi

        envid = sys_exofork();
        if (envid < 0)
  801606:	85 c0                	test   %eax,%eax
  801608:	79 20                	jns    80162a <fork+0x43>
                panic("sys_exofork: %e", envid);
  80160a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80160e:	c7 44 24 08 dc 35 80 	movl   $0x8035dc,0x8(%esp)
  801615:	00 
  801616:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  80161d:	00 
  80161e:	c7 04 24 c0 35 80 00 	movl   $0x8035c0,(%esp)
  801625:	e8 42 ee ff ff       	call   80046c <_panic>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
  80162a:	bb 00 00 80 00       	mov    $0x800000,%ebx
        set_pgfault_handler(pgfault);

        envid = sys_exofork();
        if (envid < 0)
                panic("sys_exofork: %e", envid);
        if (envid == 0) {
  80162f:	85 c0                	test   %eax,%eax
  801631:	75 1c                	jne    80164f <fork+0x68>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
  801633:	e8 c1 fd ff ff       	call   8013f9 <sys_getenvid>
  801638:	25 ff 03 00 00       	and    $0x3ff,%eax
  80163d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801640:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801645:	a3 80 74 80 00       	mov    %eax,0x807480
                return 0;
  80164a:	e9 a6 00 00 00       	jmp    8016f5 <fork+0x10e>
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
  80164f:	89 da                	mov    %ebx,%edx
  801651:	c1 ea 0c             	shr    $0xc,%edx
  801654:	89 f0                	mov    %esi,%eax
  801656:	e8 53 fe ff ff       	call   8014ae <duppage>
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
  80165b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801661:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801667:	75 e6                	jne    80164f <fork+0x68>
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
                }
              duppage(envid,VPN(USTACKTOP-PGSIZE));
  801669:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80166e:	89 f0                	mov    %esi,%eax
  801670:	e8 39 fe ff ff       	call   8014ae <duppage>
        // Also copy the stack we are currently running on.
       //if(sys_page_alloc(envid, (void *)(ROUNDDOWN(&addr, PGSIZE)),PTE_U|PTE_P|PTE_W)<0)
         //                      panic("stack not allocated");
     
   
     sys_env_set_pgfault_upcall(envid,env->env_pgfault_upcall);
  801675:	a1 80 74 80 00       	mov    0x807480,%eax
  80167a:	8b 40 64             	mov    0x64(%eax),%eax
  80167d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801681:	89 34 24             	mov    %esi,(%esp)
  801684:	e8 07 fb ff ff       	call   801190 <sys_env_set_pgfault_upcall>

     if(sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  801689:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801690:	00 
  801691:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801698:	ee 
  801699:	89 34 24             	mov    %esi,(%esp)
  80169c:	e8 c5 fc ff ff       	call   801366 <sys_page_alloc>
  8016a1:	85 c0                	test   %eax,%eax
  8016a3:	79 1c                	jns    8016c1 <fork+0xda>
                          panic("Cant allocate Page");
  8016a5:	c7 44 24 08 ec 35 80 	movl   $0x8035ec,0x8(%esp)
  8016ac:	00 
  8016ad:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  8016b4:	00 
  8016b5:	c7 04 24 c0 35 80 00 	movl   $0x8035c0,(%esp)
  8016bc:	e8 ab ed ff ff       	call   80046c <_panic>

        // Start the child environment running
        if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8016c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8016c8:	00 
  8016c9:	89 34 24             	mov    %esi,(%esp)
  8016cc:	e8 7b fb ff ff       	call   80124c <sys_env_set_status>
  8016d1:	85 c0                	test   %eax,%eax
  8016d3:	79 20                	jns    8016f5 <fork+0x10e>
                panic("sys_env_set_status: %e", r);
  8016d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016d9:	c7 44 24 08 ff 35 80 	movl   $0x8035ff,0x8(%esp)
  8016e0:	00 
  8016e1:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  8016e8:	00 
  8016e9:	c7 04 24 c0 35 80 00 	movl   $0x8035c0,(%esp)
  8016f0:	e8 77 ed ff ff       	call   80046c <_panic>
         return envid;
           
//panic("fork not implemented");
}
  8016f5:	89 f0                	mov    %esi,%eax
  8016f7:	83 c4 10             	add    $0x10,%esp
  8016fa:	5b                   	pop    %ebx
  8016fb:	5e                   	pop    %esi
  8016fc:	5d                   	pop    %ebp
  8016fd:	c3                   	ret    

008016fe <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	53                   	push   %ebx
  801702:	83 ec 24             	sub    $0x24,%esp
  801705:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801708:	8b 18                	mov    (%eax),%ebx
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).
 
         int perm = vpt[VPN(addr)] & 0xFFF;
  80170a:	89 da                	mov    %ebx,%edx
  80170c:	c1 ea 0c             	shr    $0xc,%edx
  80170f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx

static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
  801716:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80171a:	74 21                	je     80173d <pgfault+0x3f>
 
         int perm = vpt[VPN(addr)] & 0xFFF;
        if((err & FEC_WR)!=0)
           {
//              cprintf("\n>>>>>Due to write\n");
            if((perm & PTE_COW) == 0)
  80171c:	f6 c6 08             	test   $0x8,%dh
  80171f:	75 1c                	jne    80173d <pgfault+0x3f>
             {
                   panic("Not Set Cow");
  801721:	c7 44 24 08 16 36 80 	movl   $0x803616,0x8(%esp)
  801728:	00 
  801729:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801730:	00 
  801731:	c7 04 24 c0 35 80 00 	movl   $0x8035c0,(%esp)
  801738:	e8 2f ed ff ff       	call   80046c <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
        if(sys_page_alloc(0,PFTEMP,PTE_P|PTE_U|PTE_W)<0)
  80173d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801744:	00 
  801745:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80174c:	00 
  80174d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801754:	e8 0d fc ff ff       	call   801366 <sys_page_alloc>
  801759:	85 c0                	test   %eax,%eax
  80175b:	79 1c                	jns    801779 <pgfault+0x7b>
              panic("\nPage not allocated\n");
  80175d:	c7 44 24 08 22 36 80 	movl   $0x803622,0x8(%esp)
  801764:	00 
  801765:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  80176c:	00 
  80176d:	c7 04 24 c0 35 80 00 	movl   $0x8035c0,(%esp)
  801774:	e8 f3 ec ff ff       	call   80046c <_panic>
           memmove(PFTEMP,ROUNDDOWN(addr,PGSIZE),PGSIZE);
  801779:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80177f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801786:	00 
  801787:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80178b:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801792:	e8 2e f6 ff ff       	call   800dc5 <memmove>
          if(sys_page_map(0,ROUNDDOWN(PFTEMP,PGSIZE),0,ROUNDDOWN(addr,PGSIZE),PTE_U|PTE_P|PTE_W)<0)
  801797:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80179e:	00 
  80179f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8017a3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8017aa:	00 
  8017ab:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8017b2:	00 
  8017b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017ba:	e8 49 fb ff ff       	call   801308 <sys_page_map>
  8017bf:	85 c0                	test   %eax,%eax
  8017c1:	79 1c                	jns    8017df <pgfault+0xe1>
                   panic("not mapped properly");
  8017c3:	c7 44 24 08 37 36 80 	movl   $0x803637,0x8(%esp)
  8017ca:	00 
  8017cb:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8017d2:	00 
  8017d3:	c7 04 24 c0 35 80 00 	movl   $0x8035c0,(%esp)
  8017da:	e8 8d ec ff ff       	call   80046c <_panic>
         if( 0 > sys_page_unmap(0, PFTEMP) )
  8017df:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8017e6:	00 
  8017e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8017ee:	e8 b7 fa ff ff       	call   8012aa <sys_page_unmap>
  8017f3:	85 c0                	test   %eax,%eax
  8017f5:	79 1c                	jns    801813 <pgfault+0x115>
                panic("sys_page_unmap failed\n");
  8017f7:	c7 44 24 08 4b 36 80 	movl   $0x80364b,0x8(%esp)
  8017fe:	00 
  8017ff:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  801806:	00 
  801807:	c7 04 24 c0 35 80 00 	movl   $0x8035c0,(%esp)
  80180e:	e8 59 ec ff ff       	call   80046c <_panic>
   
//	panic("pgfault not implemented");
}
  801813:	83 c4 24             	add    $0x24,%esp
  801816:	5b                   	pop    %ebx
  801817:	5d                   	pop    %ebp
  801818:	c3                   	ret    
  801819:	00 00                	add    %al,(%eax)
  80181b:	00 00                	add    %al,(%eax)
  80181d:	00 00                	add    %al,(%eax)
	...

00801820 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	8b 45 08             	mov    0x8(%ebp),%eax
  801826:	05 00 00 00 30       	add    $0x30000000,%eax
  80182b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80182e:	5d                   	pop    %ebp
  80182f:	c3                   	ret    

00801830 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801836:	8b 45 08             	mov    0x8(%ebp),%eax
  801839:	89 04 24             	mov    %eax,(%esp)
  80183c:	e8 df ff ff ff       	call   801820 <fd2num>
  801841:	05 20 00 0d 00       	add    $0xd0020,%eax
  801846:	c1 e0 0c             	shl    $0xc,%eax
}
  801849:	c9                   	leave  
  80184a:	c3                   	ret    

0080184b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	57                   	push   %edi
  80184f:	56                   	push   %esi
  801850:	53                   	push   %ebx
  801851:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801854:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801859:	a8 01                	test   $0x1,%al
  80185b:	74 36                	je     801893 <fd_alloc+0x48>
  80185d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801862:	a8 01                	test   $0x1,%al
  801864:	74 2d                	je     801893 <fd_alloc+0x48>
  801866:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80186b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801870:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801875:	89 c3                	mov    %eax,%ebx
  801877:	89 c2                	mov    %eax,%edx
  801879:	c1 ea 16             	shr    $0x16,%edx
  80187c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80187f:	f6 c2 01             	test   $0x1,%dl
  801882:	74 14                	je     801898 <fd_alloc+0x4d>
  801884:	89 c2                	mov    %eax,%edx
  801886:	c1 ea 0c             	shr    $0xc,%edx
  801889:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80188c:	f6 c2 01             	test   $0x1,%dl
  80188f:	75 10                	jne    8018a1 <fd_alloc+0x56>
  801891:	eb 05                	jmp    801898 <fd_alloc+0x4d>
  801893:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801898:	89 1f                	mov    %ebx,(%edi)
  80189a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80189f:	eb 17                	jmp    8018b8 <fd_alloc+0x6d>
  8018a1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8018a6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8018ab:	75 c8                	jne    801875 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8018ad:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8018b3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8018b8:	5b                   	pop    %ebx
  8018b9:	5e                   	pop    %esi
  8018ba:	5f                   	pop    %edi
  8018bb:	5d                   	pop    %ebp
  8018bc:	c3                   	ret    

008018bd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8018c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c3:	83 f8 1f             	cmp    $0x1f,%eax
  8018c6:	77 36                	ja     8018fe <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8018c8:	05 00 00 0d 00       	add    $0xd0000,%eax
  8018cd:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8018d0:	89 c2                	mov    %eax,%edx
  8018d2:	c1 ea 16             	shr    $0x16,%edx
  8018d5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8018dc:	f6 c2 01             	test   $0x1,%dl
  8018df:	74 1d                	je     8018fe <fd_lookup+0x41>
  8018e1:	89 c2                	mov    %eax,%edx
  8018e3:	c1 ea 0c             	shr    $0xc,%edx
  8018e6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018ed:	f6 c2 01             	test   $0x1,%dl
  8018f0:	74 0c                	je     8018fe <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f5:	89 02                	mov    %eax,(%edx)
  8018f7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8018fc:	eb 05                	jmp    801903 <fd_lookup+0x46>
  8018fe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801903:	5d                   	pop    %ebp
  801904:	c3                   	ret    

00801905 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801905:	55                   	push   %ebp
  801906:	89 e5                	mov    %esp,%ebp
  801908:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80190b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80190e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	89 04 24             	mov    %eax,(%esp)
  801918:	e8 a0 ff ff ff       	call   8018bd <fd_lookup>
  80191d:	85 c0                	test   %eax,%eax
  80191f:	78 0e                	js     80192f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801921:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801924:	8b 55 0c             	mov    0xc(%ebp),%edx
  801927:	89 50 04             	mov    %edx,0x4(%eax)
  80192a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
  801934:	56                   	push   %esi
  801935:	53                   	push   %ebx
  801936:	83 ec 10             	sub    $0x10,%esp
  801939:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80193c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80193f:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801944:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801949:	be e4 36 80 00       	mov    $0x8036e4,%esi
		if (devtab[i]->dev_id == dev_id) {
  80194e:	39 08                	cmp    %ecx,(%eax)
  801950:	75 10                	jne    801962 <dev_lookup+0x31>
  801952:	eb 04                	jmp    801958 <dev_lookup+0x27>
  801954:	39 08                	cmp    %ecx,(%eax)
  801956:	75 0a                	jne    801962 <dev_lookup+0x31>
			*dev = devtab[i];
  801958:	89 03                	mov    %eax,(%ebx)
  80195a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80195f:	90                   	nop
  801960:	eb 31                	jmp    801993 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801962:	83 c2 01             	add    $0x1,%edx
  801965:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801968:	85 c0                	test   %eax,%eax
  80196a:	75 e8                	jne    801954 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80196c:	a1 80 74 80 00       	mov    0x807480,%eax
  801971:	8b 40 4c             	mov    0x4c(%eax),%eax
  801974:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801978:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197c:	c7 04 24 64 36 80 00 	movl   $0x803664,(%esp)
  801983:	e8 a9 eb ff ff       	call   800531 <cprintf>
	*dev = 0;
  801988:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80198e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801993:	83 c4 10             	add    $0x10,%esp
  801996:	5b                   	pop    %ebx
  801997:	5e                   	pop    %esi
  801998:	5d                   	pop    %ebp
  801999:	c3                   	ret    

0080199a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	53                   	push   %ebx
  80199e:	83 ec 24             	sub    $0x24,%esp
  8019a1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	89 04 24             	mov    %eax,(%esp)
  8019b1:	e8 07 ff ff ff       	call   8018bd <fd_lookup>
  8019b6:	85 c0                	test   %eax,%eax
  8019b8:	78 53                	js     801a0d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019ba:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019c4:	8b 00                	mov    (%eax),%eax
  8019c6:	89 04 24             	mov    %eax,(%esp)
  8019c9:	e8 63 ff ff ff       	call   801931 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	78 3b                	js     801a0d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8019d2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019da:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8019de:	74 2d                	je     801a0d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019e0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019e3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019ea:	00 00 00 
	stat->st_isdir = 0;
  8019ed:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019f4:	00 00 00 
	stat->st_dev = dev;
  8019f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019fa:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a00:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a04:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a07:	89 14 24             	mov    %edx,(%esp)
  801a0a:	ff 50 14             	call   *0x14(%eax)
}
  801a0d:	83 c4 24             	add    $0x24,%esp
  801a10:	5b                   	pop    %ebx
  801a11:	5d                   	pop    %ebp
  801a12:	c3                   	ret    

00801a13 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
  801a16:	53                   	push   %ebx
  801a17:	83 ec 24             	sub    $0x24,%esp
  801a1a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a1d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a20:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a24:	89 1c 24             	mov    %ebx,(%esp)
  801a27:	e8 91 fe ff ff       	call   8018bd <fd_lookup>
  801a2c:	85 c0                	test   %eax,%eax
  801a2e:	78 5f                	js     801a8f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a30:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a33:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a37:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a3a:	8b 00                	mov    (%eax),%eax
  801a3c:	89 04 24             	mov    %eax,(%esp)
  801a3f:	e8 ed fe ff ff       	call   801931 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a44:	85 c0                	test   %eax,%eax
  801a46:	78 47                	js     801a8f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a48:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a4b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801a4f:	75 23                	jne    801a74 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801a51:	a1 80 74 80 00       	mov    0x807480,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a56:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a59:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a61:	c7 04 24 84 36 80 00 	movl   $0x803684,(%esp)
  801a68:	e8 c4 ea ff ff       	call   800531 <cprintf>
  801a6d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801a72:	eb 1b                	jmp    801a8f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a77:	8b 48 18             	mov    0x18(%eax),%ecx
  801a7a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a7f:	85 c9                	test   %ecx,%ecx
  801a81:	74 0c                	je     801a8f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a86:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8a:	89 14 24             	mov    %edx,(%esp)
  801a8d:	ff d1                	call   *%ecx
}
  801a8f:	83 c4 24             	add    $0x24,%esp
  801a92:	5b                   	pop    %ebx
  801a93:	5d                   	pop    %ebp
  801a94:	c3                   	ret    

00801a95 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	53                   	push   %ebx
  801a99:	83 ec 24             	sub    $0x24,%esp
  801a9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a9f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aa6:	89 1c 24             	mov    %ebx,(%esp)
  801aa9:	e8 0f fe ff ff       	call   8018bd <fd_lookup>
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	78 66                	js     801b18 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ab2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ab5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801abc:	8b 00                	mov    (%eax),%eax
  801abe:	89 04 24             	mov    %eax,(%esp)
  801ac1:	e8 6b fe ff ff       	call   801931 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ac6:	85 c0                	test   %eax,%eax
  801ac8:	78 4e                	js     801b18 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801aca:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801acd:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801ad1:	75 23                	jne    801af6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801ad3:	a1 80 74 80 00       	mov    0x807480,%eax
  801ad8:	8b 40 4c             	mov    0x4c(%eax),%eax
  801adb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801adf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae3:	c7 04 24 a8 36 80 00 	movl   $0x8036a8,(%esp)
  801aea:	e8 42 ea ff ff       	call   800531 <cprintf>
  801aef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801af4:	eb 22                	jmp    801b18 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af9:	8b 48 0c             	mov    0xc(%eax),%ecx
  801afc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b01:	85 c9                	test   %ecx,%ecx
  801b03:	74 13                	je     801b18 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801b05:	8b 45 10             	mov    0x10(%ebp),%eax
  801b08:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b13:	89 14 24             	mov    %edx,(%esp)
  801b16:	ff d1                	call   *%ecx
}
  801b18:	83 c4 24             	add    $0x24,%esp
  801b1b:	5b                   	pop    %ebx
  801b1c:	5d                   	pop    %ebp
  801b1d:	c3                   	ret    

00801b1e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
  801b21:	53                   	push   %ebx
  801b22:	83 ec 24             	sub    $0x24,%esp
  801b25:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b28:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b2f:	89 1c 24             	mov    %ebx,(%esp)
  801b32:	e8 86 fd ff ff       	call   8018bd <fd_lookup>
  801b37:	85 c0                	test   %eax,%eax
  801b39:	78 6b                	js     801ba6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b45:	8b 00                	mov    (%eax),%eax
  801b47:	89 04 24             	mov    %eax,(%esp)
  801b4a:	e8 e2 fd ff ff       	call   801931 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b4f:	85 c0                	test   %eax,%eax
  801b51:	78 53                	js     801ba6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b56:	8b 42 08             	mov    0x8(%edx),%eax
  801b59:	83 e0 03             	and    $0x3,%eax
  801b5c:	83 f8 01             	cmp    $0x1,%eax
  801b5f:	75 23                	jne    801b84 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801b61:	a1 80 74 80 00       	mov    0x807480,%eax
  801b66:	8b 40 4c             	mov    0x4c(%eax),%eax
  801b69:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b71:	c7 04 24 c5 36 80 00 	movl   $0x8036c5,(%esp)
  801b78:	e8 b4 e9 ff ff       	call   800531 <cprintf>
  801b7d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801b82:	eb 22                	jmp    801ba6 <read+0x88>
	}
	if (!dev->dev_read)
  801b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b87:	8b 48 08             	mov    0x8(%eax),%ecx
  801b8a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b8f:	85 c9                	test   %ecx,%ecx
  801b91:	74 13                	je     801ba6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b93:	8b 45 10             	mov    0x10(%ebp),%eax
  801b96:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ba1:	89 14 24             	mov    %edx,(%esp)
  801ba4:	ff d1                	call   *%ecx
}
  801ba6:	83 c4 24             	add    $0x24,%esp
  801ba9:	5b                   	pop    %ebx
  801baa:	5d                   	pop    %ebp
  801bab:	c3                   	ret    

00801bac <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
  801baf:	57                   	push   %edi
  801bb0:	56                   	push   %esi
  801bb1:	53                   	push   %ebx
  801bb2:	83 ec 1c             	sub    $0x1c,%esp
  801bb5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801bb8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bbb:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bc5:	b8 00 00 00 00       	mov    $0x0,%eax
  801bca:	85 f6                	test   %esi,%esi
  801bcc:	74 29                	je     801bf7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801bce:	89 f0                	mov    %esi,%eax
  801bd0:	29 d0                	sub    %edx,%eax
  801bd2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bd6:	03 55 0c             	add    0xc(%ebp),%edx
  801bd9:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bdd:	89 3c 24             	mov    %edi,(%esp)
  801be0:	e8 39 ff ff ff       	call   801b1e <read>
		if (m < 0)
  801be5:	85 c0                	test   %eax,%eax
  801be7:	78 0e                	js     801bf7 <readn+0x4b>
			return m;
		if (m == 0)
  801be9:	85 c0                	test   %eax,%eax
  801beb:	74 08                	je     801bf5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bed:	01 c3                	add    %eax,%ebx
  801bef:	89 da                	mov    %ebx,%edx
  801bf1:	39 f3                	cmp    %esi,%ebx
  801bf3:	72 d9                	jb     801bce <readn+0x22>
  801bf5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801bf7:	83 c4 1c             	add    $0x1c,%esp
  801bfa:	5b                   	pop    %ebx
  801bfb:	5e                   	pop    %esi
  801bfc:	5f                   	pop    %edi
  801bfd:	5d                   	pop    %ebp
  801bfe:	c3                   	ret    

00801bff <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801bff:	55                   	push   %ebp
  801c00:	89 e5                	mov    %esp,%ebp
  801c02:	56                   	push   %esi
  801c03:	53                   	push   %ebx
  801c04:	83 ec 20             	sub    $0x20,%esp
  801c07:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801c0a:	89 34 24             	mov    %esi,(%esp)
  801c0d:	e8 0e fc ff ff       	call   801820 <fd2num>
  801c12:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801c15:	89 54 24 04          	mov    %edx,0x4(%esp)
  801c19:	89 04 24             	mov    %eax,(%esp)
  801c1c:	e8 9c fc ff ff       	call   8018bd <fd_lookup>
  801c21:	89 c3                	mov    %eax,%ebx
  801c23:	85 c0                	test   %eax,%eax
  801c25:	78 05                	js     801c2c <fd_close+0x2d>
  801c27:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801c2a:	74 0c                	je     801c38 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801c2c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801c30:	19 c0                	sbb    %eax,%eax
  801c32:	f7 d0                	not    %eax
  801c34:	21 c3                	and    %eax,%ebx
  801c36:	eb 3d                	jmp    801c75 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801c38:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c3f:	8b 06                	mov    (%esi),%eax
  801c41:	89 04 24             	mov    %eax,(%esp)
  801c44:	e8 e8 fc ff ff       	call   801931 <dev_lookup>
  801c49:	89 c3                	mov    %eax,%ebx
  801c4b:	85 c0                	test   %eax,%eax
  801c4d:	78 16                	js     801c65 <fd_close+0x66>
		if (dev->dev_close)
  801c4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c52:	8b 40 10             	mov    0x10(%eax),%eax
  801c55:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c5a:	85 c0                	test   %eax,%eax
  801c5c:	74 07                	je     801c65 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801c5e:	89 34 24             	mov    %esi,(%esp)
  801c61:	ff d0                	call   *%eax
  801c63:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801c65:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c69:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c70:	e8 35 f6 ff ff       	call   8012aa <sys_page_unmap>
	return r;
}
  801c75:	89 d8                	mov    %ebx,%eax
  801c77:	83 c4 20             	add    $0x20,%esp
  801c7a:	5b                   	pop    %ebx
  801c7b:	5e                   	pop    %esi
  801c7c:	5d                   	pop    %ebp
  801c7d:	c3                   	ret    

00801c7e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c84:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c87:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8e:	89 04 24             	mov    %eax,(%esp)
  801c91:	e8 27 fc ff ff       	call   8018bd <fd_lookup>
  801c96:	85 c0                	test   %eax,%eax
  801c98:	78 13                	js     801cad <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801c9a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801ca1:	00 
  801ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ca5:	89 04 24             	mov    %eax,(%esp)
  801ca8:	e8 52 ff ff ff       	call   801bff <fd_close>
}
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	83 ec 18             	sub    $0x18,%esp
  801cb5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801cb8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801cbb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cc2:	00 
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	89 04 24             	mov    %eax,(%esp)
  801cc9:	e8 a9 03 00 00       	call   802077 <open>
  801cce:	89 c3                	mov    %eax,%ebx
  801cd0:	85 c0                	test   %eax,%eax
  801cd2:	78 1b                	js     801cef <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cdb:	89 1c 24             	mov    %ebx,(%esp)
  801cde:	e8 b7 fc ff ff       	call   80199a <fstat>
  801ce3:	89 c6                	mov    %eax,%esi
	close(fd);
  801ce5:	89 1c 24             	mov    %ebx,(%esp)
  801ce8:	e8 91 ff ff ff       	call   801c7e <close>
  801ced:	89 f3                	mov    %esi,%ebx
	return r;
}
  801cef:	89 d8                	mov    %ebx,%eax
  801cf1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801cf4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801cf7:	89 ec                	mov    %ebp,%esp
  801cf9:	5d                   	pop    %ebp
  801cfa:	c3                   	ret    

00801cfb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801cfb:	55                   	push   %ebp
  801cfc:	89 e5                	mov    %esp,%ebp
  801cfe:	53                   	push   %ebx
  801cff:	83 ec 14             	sub    $0x14,%esp
  801d02:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801d07:	89 1c 24             	mov    %ebx,(%esp)
  801d0a:	e8 6f ff ff ff       	call   801c7e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801d0f:	83 c3 01             	add    $0x1,%ebx
  801d12:	83 fb 20             	cmp    $0x20,%ebx
  801d15:	75 f0                	jne    801d07 <close_all+0xc>
		close(i);
}
  801d17:	83 c4 14             	add    $0x14,%esp
  801d1a:	5b                   	pop    %ebx
  801d1b:	5d                   	pop    %ebp
  801d1c:	c3                   	ret    

00801d1d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	83 ec 58             	sub    $0x58,%esp
  801d23:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801d26:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801d29:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801d2c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801d2f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801d32:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d36:	8b 45 08             	mov    0x8(%ebp),%eax
  801d39:	89 04 24             	mov    %eax,(%esp)
  801d3c:	e8 7c fb ff ff       	call   8018bd <fd_lookup>
  801d41:	89 c3                	mov    %eax,%ebx
  801d43:	85 c0                	test   %eax,%eax
  801d45:	0f 88 e0 00 00 00    	js     801e2b <dup+0x10e>
		return r;
	close(newfdnum);
  801d4b:	89 3c 24             	mov    %edi,(%esp)
  801d4e:	e8 2b ff ff ff       	call   801c7e <close>

	newfd = INDEX2FD(newfdnum);
  801d53:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801d59:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801d5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d5f:	89 04 24             	mov    %eax,(%esp)
  801d62:	e8 c9 fa ff ff       	call   801830 <fd2data>
  801d67:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801d69:	89 34 24             	mov    %esi,(%esp)
  801d6c:	e8 bf fa ff ff       	call   801830 <fd2data>
  801d71:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801d74:	89 da                	mov    %ebx,%edx
  801d76:	89 d8                	mov    %ebx,%eax
  801d78:	c1 e8 16             	shr    $0x16,%eax
  801d7b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d82:	a8 01                	test   $0x1,%al
  801d84:	74 43                	je     801dc9 <dup+0xac>
  801d86:	c1 ea 0c             	shr    $0xc,%edx
  801d89:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d90:	a8 01                	test   $0x1,%al
  801d92:	74 35                	je     801dc9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801d94:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d9b:	25 07 0e 00 00       	and    $0xe07,%eax
  801da0:	89 44 24 10          	mov    %eax,0x10(%esp)
  801da4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801da7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801db2:	00 
  801db3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801db7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dbe:	e8 45 f5 ff ff       	call   801308 <sys_page_map>
  801dc3:	89 c3                	mov    %eax,%ebx
  801dc5:	85 c0                	test   %eax,%eax
  801dc7:	78 3f                	js     801e08 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801dcc:	89 c2                	mov    %eax,%edx
  801dce:	c1 ea 0c             	shr    $0xc,%edx
  801dd1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801dd8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801dde:	89 54 24 10          	mov    %edx,0x10(%esp)
  801de2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801de6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801ded:	00 
  801dee:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801df9:	e8 0a f5 ff ff       	call   801308 <sys_page_map>
  801dfe:	89 c3                	mov    %eax,%ebx
  801e00:	85 c0                	test   %eax,%eax
  801e02:	78 04                	js     801e08 <dup+0xeb>
  801e04:	89 fb                	mov    %edi,%ebx
  801e06:	eb 23                	jmp    801e2b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801e08:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e0c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e13:	e8 92 f4 ff ff       	call   8012aa <sys_page_unmap>
	sys_page_unmap(0, nva);
  801e18:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801e1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e1f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e26:	e8 7f f4 ff ff       	call   8012aa <sys_page_unmap>
	return r;
}
  801e2b:	89 d8                	mov    %ebx,%eax
  801e2d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801e30:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801e33:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801e36:	89 ec                	mov    %ebp,%esp
  801e38:	5d                   	pop    %ebp
  801e39:	c3                   	ret    
	...

00801e3c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801e3c:	55                   	push   %ebp
  801e3d:	89 e5                	mov    %esp,%ebp
  801e3f:	53                   	push   %ebx
  801e40:	83 ec 14             	sub    $0x14,%esp
  801e43:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e45:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801e4b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e52:	00 
  801e53:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801e5a:	00 
  801e5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e5f:	89 14 24             	mov    %edx,(%esp)
  801e62:	e8 59 0e 00 00       	call   802cc0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e67:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e6e:	00 
  801e6f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e73:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e7a:	e8 a3 0e 00 00       	call   802d22 <ipc_recv>
}
  801e7f:	83 c4 14             	add    $0x14,%esp
  801e82:	5b                   	pop    %ebx
  801e83:	5d                   	pop    %ebp
  801e84:	c3                   	ret    

00801e85 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
  801e88:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8e:	8b 40 0c             	mov    0xc(%eax),%eax
  801e91:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801e96:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e99:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e9e:	ba 00 00 00 00       	mov    $0x0,%edx
  801ea3:	b8 02 00 00 00       	mov    $0x2,%eax
  801ea8:	e8 8f ff ff ff       	call   801e3c <fsipc>
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801eb5:	ba 00 00 00 00       	mov    $0x0,%edx
  801eba:	b8 08 00 00 00       	mov    $0x8,%eax
  801ebf:	e8 78 ff ff ff       	call   801e3c <fsipc>
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	53                   	push   %ebx
  801eca:	83 ec 14             	sub    $0x14,%esp
  801ecd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ed6:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801edb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ee0:	b8 05 00 00 00       	mov    $0x5,%eax
  801ee5:	e8 52 ff ff ff       	call   801e3c <fsipc>
  801eea:	85 c0                	test   %eax,%eax
  801eec:	78 2b                	js     801f19 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801eee:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801ef5:	00 
  801ef6:	89 1c 24             	mov    %ebx,(%esp)
  801ef9:	e8 0c ed ff ff       	call   800c0a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801efe:	a1 80 40 80 00       	mov    0x804080,%eax
  801f03:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801f09:	a1 84 40 80 00       	mov    0x804084,%eax
  801f0e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801f14:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801f19:	83 c4 14             	add    $0x14,%esp
  801f1c:	5b                   	pop    %ebx
  801f1d:	5d                   	pop    %ebp
  801f1e:	c3                   	ret    

00801f1f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801f1f:	55                   	push   %ebp
  801f20:	89 e5                	mov    %esp,%ebp
  801f22:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  801f25:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801f2c:	00 
  801f2d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f34:	00 
  801f35:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801f3c:	e8 25 ee ff ff       	call   800d66 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f41:	8b 45 08             	mov    0x8(%ebp),%eax
  801f44:	8b 40 0c             	mov    0xc(%eax),%eax
  801f47:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801f4c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f51:	b8 06 00 00 00       	mov    $0x6,%eax
  801f56:	e8 e1 fe ff ff       	call   801e3c <fsipc>
}
  801f5b:	c9                   	leave  
  801f5c:	c3                   	ret    

00801f5d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801f5d:	55                   	push   %ebp
  801f5e:	89 e5                	mov    %esp,%ebp
  801f60:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801f63:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801f6a:	00 
  801f6b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f72:	00 
  801f73:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801f7a:	e8 e7 ed ff ff       	call   800d66 <memset>
  801f7f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f82:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801f87:	76 05                	jbe    801f8e <devfile_write+0x31>
  801f89:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f8e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f91:	8b 52 0c             	mov    0xc(%edx),%edx
  801f94:	89 15 00 40 80 00    	mov    %edx,0x804000
        fsipcbuf.write.req_n = numberOfBytes;
  801f9a:	a3 04 40 80 00       	mov    %eax,0x804004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  801f9f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801faa:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801fb1:	e8 0f ee ff ff       	call   800dc5 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  801fb6:	ba 00 00 00 00       	mov    $0x0,%edx
  801fbb:	b8 04 00 00 00       	mov    $0x4,%eax
  801fc0:	e8 77 fe ff ff       	call   801e3c <fsipc>
              return r;
        return r;
}
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
  801fca:	53                   	push   %ebx
  801fcb:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  801fce:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801fd5:	00 
  801fd6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fdd:	00 
  801fde:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801fe5:	e8 7c ed ff ff       	call   800d66 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  801fea:	8b 45 08             	mov    0x8(%ebp),%eax
  801fed:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff0:	a3 00 40 80 00       	mov    %eax,0x804000
        fsipcbuf.read.req_n = n;
  801ff5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff8:	a3 04 40 80 00       	mov    %eax,0x804004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  801ffd:	ba 00 00 00 00       	mov    $0x0,%edx
  802002:	b8 03 00 00 00       	mov    $0x3,%eax
  802007:	e8 30 fe ff ff       	call   801e3c <fsipc>
  80200c:	89 c3                	mov    %eax,%ebx
  80200e:	85 c0                	test   %eax,%eax
  802010:	78 17                	js     802029 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  802012:	89 44 24 08          	mov    %eax,0x8(%esp)
  802016:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  80201d:	00 
  80201e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802021:	89 04 24             	mov    %eax,(%esp)
  802024:	e8 9c ed ff ff       	call   800dc5 <memmove>
        return r;
}
  802029:	89 d8                	mov    %ebx,%eax
  80202b:	83 c4 14             	add    $0x14,%esp
  80202e:	5b                   	pop    %ebx
  80202f:	5d                   	pop    %ebp
  802030:	c3                   	ret    

00802031 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  802031:	55                   	push   %ebp
  802032:	89 e5                	mov    %esp,%ebp
  802034:	53                   	push   %ebx
  802035:	83 ec 14             	sub    $0x14,%esp
  802038:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  80203b:	89 1c 24             	mov    %ebx,(%esp)
  80203e:	e8 7d eb ff ff       	call   800bc0 <strlen>
  802043:	89 c2                	mov    %eax,%edx
  802045:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80204a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  802050:	7f 1f                	jg     802071 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  802052:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802056:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  80205d:	e8 a8 eb ff ff       	call   800c0a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  802062:	ba 00 00 00 00       	mov    $0x0,%edx
  802067:	b8 07 00 00 00       	mov    $0x7,%eax
  80206c:	e8 cb fd ff ff       	call   801e3c <fsipc>
}
  802071:	83 c4 14             	add    $0x14,%esp
  802074:	5b                   	pop    %ebx
  802075:	5d                   	pop    %ebp
  802076:	c3                   	ret    

00802077 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  802077:	55                   	push   %ebp
  802078:	89 e5                	mov    %esp,%ebp
  80207a:	56                   	push   %esi
  80207b:	53                   	push   %ebx
  80207c:	83 ec 20             	sub    $0x20,%esp
  80207f:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  802082:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802089:	00 
  80208a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802091:	00 
  802092:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  802099:	e8 c8 ec ff ff       	call   800d66 <memset>
    if(strlen(path)>=MAXPATHLEN)
  80209e:	89 34 24             	mov    %esi,(%esp)
  8020a1:	e8 1a eb ff ff       	call   800bc0 <strlen>
  8020a6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8020ab:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8020b0:	0f 8f 84 00 00 00    	jg     80213a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  8020b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020b9:	89 04 24             	mov    %eax,(%esp)
  8020bc:	e8 8a f7 ff ff       	call   80184b <fd_alloc>
  8020c1:	89 c3                	mov    %eax,%ebx
  8020c3:	85 c0                	test   %eax,%eax
  8020c5:	78 73                	js     80213a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  8020c7:	0f b6 06             	movzbl (%esi),%eax
  8020ca:	84 c0                	test   %al,%al
  8020cc:	74 20                	je     8020ee <open+0x77>
  8020ce:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  8020d0:	0f be c0             	movsbl %al,%eax
  8020d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d7:	c7 04 24 f8 36 80 00 	movl   $0x8036f8,(%esp)
  8020de:	e8 4e e4 ff ff       	call   800531 <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  8020e3:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  8020e7:	83 c3 01             	add    $0x1,%ebx
  8020ea:	84 c0                	test   %al,%al
  8020ec:	75 e2                	jne    8020d0 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  8020ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020f2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  8020f9:	e8 0c eb ff ff       	call   800c0a <strcpy>
    fsipcbuf.open.req_omode = mode;
  8020fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802101:	a3 00 44 80 00       	mov    %eax,0x804400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  802106:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802109:	b8 01 00 00 00       	mov    $0x1,%eax
  80210e:	e8 29 fd ff ff       	call   801e3c <fsipc>
  802113:	89 c3                	mov    %eax,%ebx
  802115:	85 c0                	test   %eax,%eax
  802117:	79 15                	jns    80212e <open+0xb7>
        {
            fd_close(fd,1);
  802119:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802120:	00 
  802121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802124:	89 04 24             	mov    %eax,(%esp)
  802127:	e8 d3 fa ff ff       	call   801bff <fd_close>
             return r;
  80212c:	eb 0c                	jmp    80213a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  80212e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802131:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  802137:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  80213a:	89 d8                	mov    %ebx,%eax
  80213c:	83 c4 20             	add    $0x20,%esp
  80213f:	5b                   	pop    %ebx
  802140:	5e                   	pop    %esi
  802141:	5d                   	pop    %ebp
  802142:	c3                   	ret    
	...

00802150 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802150:	55                   	push   %ebp
  802151:	89 e5                	mov    %esp,%ebp
  802153:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802156:	c7 44 24 04 fb 36 80 	movl   $0x8036fb,0x4(%esp)
  80215d:	00 
  80215e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802161:	89 04 24             	mov    %eax,(%esp)
  802164:	e8 a1 ea ff ff       	call   800c0a <strcpy>
	return 0;
}
  802169:	b8 00 00 00 00       	mov    $0x0,%eax
  80216e:	c9                   	leave  
  80216f:	c3                   	ret    

00802170 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802170:	55                   	push   %ebp
  802171:	89 e5                	mov    %esp,%ebp
  802173:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  802176:	8b 45 08             	mov    0x8(%ebp),%eax
  802179:	8b 40 0c             	mov    0xc(%eax),%eax
  80217c:	89 04 24             	mov    %eax,(%esp)
  80217f:	e8 9e 02 00 00       	call   802422 <nsipc_close>
}
  802184:	c9                   	leave  
  802185:	c3                   	ret    

00802186 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802186:	55                   	push   %ebp
  802187:	89 e5                	mov    %esp,%ebp
  802189:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80218c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802193:	00 
  802194:	8b 45 10             	mov    0x10(%ebp),%eax
  802197:	89 44 24 08          	mov    %eax,0x8(%esp)
  80219b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a8:	89 04 24             	mov    %eax,(%esp)
  8021ab:	e8 ae 02 00 00       	call   80245e <nsipc_send>
}
  8021b0:	c9                   	leave  
  8021b1:	c3                   	ret    

008021b2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8021b2:	55                   	push   %ebp
  8021b3:	89 e5                	mov    %esp,%ebp
  8021b5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8021b8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8021bf:	00 
  8021c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8021c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8021c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8021d4:	89 04 24             	mov    %eax,(%esp)
  8021d7:	e8 f5 02 00 00       	call   8024d1 <nsipc_recv>
}
  8021dc:	c9                   	leave  
  8021dd:	c3                   	ret    

008021de <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8021de:	55                   	push   %ebp
  8021df:	89 e5                	mov    %esp,%ebp
  8021e1:	56                   	push   %esi
  8021e2:	53                   	push   %ebx
  8021e3:	83 ec 20             	sub    $0x20,%esp
  8021e6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8021e8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021eb:	89 04 24             	mov    %eax,(%esp)
  8021ee:	e8 58 f6 ff ff       	call   80184b <fd_alloc>
  8021f3:	89 c3                	mov    %eax,%ebx
  8021f5:	85 c0                	test   %eax,%eax
  8021f7:	78 21                	js     80221a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  8021f9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802200:	00 
  802201:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802204:	89 44 24 04          	mov    %eax,0x4(%esp)
  802208:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80220f:	e8 52 f1 ff ff       	call   801366 <sys_page_alloc>
  802214:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802216:	85 c0                	test   %eax,%eax
  802218:	79 0a                	jns    802224 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80221a:	89 34 24             	mov    %esi,(%esp)
  80221d:	e8 00 02 00 00       	call   802422 <nsipc_close>
		return r;
  802222:	eb 28                	jmp    80224c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802224:	8b 15 20 70 80 00    	mov    0x807020,%edx
  80222a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80222d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80222f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802232:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80223f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802242:	89 04 24             	mov    %eax,(%esp)
  802245:	e8 d6 f5 ff ff       	call   801820 <fd2num>
  80224a:	89 c3                	mov    %eax,%ebx
}
  80224c:	89 d8                	mov    %ebx,%eax
  80224e:	83 c4 20             	add    $0x20,%esp
  802251:	5b                   	pop    %ebx
  802252:	5e                   	pop    %esi
  802253:	5d                   	pop    %ebp
  802254:	c3                   	ret    

00802255 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802255:	55                   	push   %ebp
  802256:	89 e5                	mov    %esp,%ebp
  802258:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80225b:	8b 45 10             	mov    0x10(%ebp),%eax
  80225e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802262:	8b 45 0c             	mov    0xc(%ebp),%eax
  802265:	89 44 24 04          	mov    %eax,0x4(%esp)
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	89 04 24             	mov    %eax,(%esp)
  80226f:	e8 62 01 00 00       	call   8023d6 <nsipc_socket>
  802274:	85 c0                	test   %eax,%eax
  802276:	78 05                	js     80227d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802278:	e8 61 ff ff ff       	call   8021de <alloc_sockfd>
}
  80227d:	c9                   	leave  
  80227e:	66 90                	xchg   %ax,%ax
  802280:	c3                   	ret    

00802281 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
  802284:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802287:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80228a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80228e:	89 04 24             	mov    %eax,(%esp)
  802291:	e8 27 f6 ff ff       	call   8018bd <fd_lookup>
  802296:	85 c0                	test   %eax,%eax
  802298:	78 15                	js     8022af <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80229a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80229d:	8b 0a                	mov    (%edx),%ecx
  80229f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8022a4:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  8022aa:	75 03                	jne    8022af <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8022ac:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8022af:	c9                   	leave  
  8022b0:	c3                   	ret    

008022b1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	e8 c2 ff ff ff       	call   802281 <fd2sockid>
  8022bf:	85 c0                	test   %eax,%eax
  8022c1:	78 0f                	js     8022d2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8022c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022ca:	89 04 24             	mov    %eax,(%esp)
  8022cd:	e8 2e 01 00 00       	call   802400 <nsipc_listen>
}
  8022d2:	c9                   	leave  
  8022d3:	c3                   	ret    

008022d4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022d4:	55                   	push   %ebp
  8022d5:	89 e5                	mov    %esp,%ebp
  8022d7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	e8 9f ff ff ff       	call   802281 <fd2sockid>
  8022e2:	85 c0                	test   %eax,%eax
  8022e4:	78 16                	js     8022fc <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8022e6:	8b 55 10             	mov    0x10(%ebp),%edx
  8022e9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022f4:	89 04 24             	mov    %eax,(%esp)
  8022f7:	e8 55 02 00 00       	call   802551 <nsipc_connect>
}
  8022fc:	c9                   	leave  
  8022fd:	c3                   	ret    

008022fe <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8022fe:	55                   	push   %ebp
  8022ff:	89 e5                	mov    %esp,%ebp
  802301:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802304:	8b 45 08             	mov    0x8(%ebp),%eax
  802307:	e8 75 ff ff ff       	call   802281 <fd2sockid>
  80230c:	85 c0                	test   %eax,%eax
  80230e:	78 0f                	js     80231f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802310:	8b 55 0c             	mov    0xc(%ebp),%edx
  802313:	89 54 24 04          	mov    %edx,0x4(%esp)
  802317:	89 04 24             	mov    %eax,(%esp)
  80231a:	e8 1d 01 00 00       	call   80243c <nsipc_shutdown>
}
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	e8 52 ff ff ff       	call   802281 <fd2sockid>
  80232f:	85 c0                	test   %eax,%eax
  802331:	78 16                	js     802349 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802333:	8b 55 10             	mov    0x10(%ebp),%edx
  802336:	89 54 24 08          	mov    %edx,0x8(%esp)
  80233a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80233d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802341:	89 04 24             	mov    %eax,(%esp)
  802344:	e8 47 02 00 00       	call   802590 <nsipc_bind>
}
  802349:	c9                   	leave  
  80234a:	c3                   	ret    

0080234b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80234b:	55                   	push   %ebp
  80234c:	89 e5                	mov    %esp,%ebp
  80234e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802351:	8b 45 08             	mov    0x8(%ebp),%eax
  802354:	e8 28 ff ff ff       	call   802281 <fd2sockid>
  802359:	85 c0                	test   %eax,%eax
  80235b:	78 1f                	js     80237c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80235d:	8b 55 10             	mov    0x10(%ebp),%edx
  802360:	89 54 24 08          	mov    %edx,0x8(%esp)
  802364:	8b 55 0c             	mov    0xc(%ebp),%edx
  802367:	89 54 24 04          	mov    %edx,0x4(%esp)
  80236b:	89 04 24             	mov    %eax,(%esp)
  80236e:	e8 5c 02 00 00       	call   8025cf <nsipc_accept>
  802373:	85 c0                	test   %eax,%eax
  802375:	78 05                	js     80237c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802377:	e8 62 fe ff ff       	call   8021de <alloc_sockfd>
}
  80237c:	c9                   	leave  
  80237d:	8d 76 00             	lea    0x0(%esi),%esi
  802380:	c3                   	ret    
	...

00802390 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802396:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  80239c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8023a3:	00 
  8023a4:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8023ab:	00 
  8023ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023b0:	89 14 24             	mov    %edx,(%esp)
  8023b3:	e8 08 09 00 00       	call   802cc0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8023b8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8023bf:	00 
  8023c0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8023c7:	00 
  8023c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023cf:	e8 4e 09 00 00       	call   802d22 <ipc_recv>
}
  8023d4:	c9                   	leave  
  8023d5:	c3                   	ret    

008023d6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8023d6:	55                   	push   %ebp
  8023d7:	89 e5                	mov    %esp,%ebp
  8023d9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023df:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8023e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8023ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ef:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8023f4:	b8 09 00 00 00       	mov    $0x9,%eax
  8023f9:	e8 92 ff ff ff       	call   802390 <nsipc>
}
  8023fe:	c9                   	leave  
  8023ff:	c3                   	ret    

00802400 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
  802403:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80240e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802411:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802416:	b8 06 00 00 00       	mov    $0x6,%eax
  80241b:	e8 70 ff ff ff       	call   802390 <nsipc>
}
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
  802425:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802428:	8b 45 08             	mov    0x8(%ebp),%eax
  80242b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802430:	b8 04 00 00 00       	mov    $0x4,%eax
  802435:	e8 56 ff ff ff       	call   802390 <nsipc>
}
  80243a:	c9                   	leave  
  80243b:	c3                   	ret    

0080243c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80243c:	55                   	push   %ebp
  80243d:	89 e5                	mov    %esp,%ebp
  80243f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802442:	8b 45 08             	mov    0x8(%ebp),%eax
  802445:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80244a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802452:	b8 03 00 00 00       	mov    $0x3,%eax
  802457:	e8 34 ff ff ff       	call   802390 <nsipc>
}
  80245c:	c9                   	leave  
  80245d:	c3                   	ret    

0080245e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80245e:	55                   	push   %ebp
  80245f:	89 e5                	mov    %esp,%ebp
  802461:	53                   	push   %ebx
  802462:	83 ec 14             	sub    $0x14,%esp
  802465:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802470:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802476:	7e 24                	jle    80249c <nsipc_send+0x3e>
  802478:	c7 44 24 0c 07 37 80 	movl   $0x803707,0xc(%esp)
  80247f:	00 
  802480:	c7 44 24 08 13 37 80 	movl   $0x803713,0x8(%esp)
  802487:	00 
  802488:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  80248f:	00 
  802490:	c7 04 24 28 37 80 00 	movl   $0x803728,(%esp)
  802497:	e8 d0 df ff ff       	call   80046c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80249c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024a7:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8024ae:	e8 12 e9 ff ff       	call   800dc5 <memmove>
	nsipcbuf.send.req_size = size;
  8024b3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8024b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8024bc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8024c1:	b8 08 00 00 00       	mov    $0x8,%eax
  8024c6:	e8 c5 fe ff ff       	call   802390 <nsipc>
}
  8024cb:	83 c4 14             	add    $0x14,%esp
  8024ce:	5b                   	pop    %ebx
  8024cf:	5d                   	pop    %ebp
  8024d0:	c3                   	ret    

008024d1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8024d1:	55                   	push   %ebp
  8024d2:	89 e5                	mov    %esp,%ebp
  8024d4:	56                   	push   %esi
  8024d5:	53                   	push   %ebx
  8024d6:	83 ec 10             	sub    $0x10,%esp
  8024d9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8024dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8024df:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8024e4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8024ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8024ed:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8024f2:	b8 07 00 00 00       	mov    $0x7,%eax
  8024f7:	e8 94 fe ff ff       	call   802390 <nsipc>
  8024fc:	89 c3                	mov    %eax,%ebx
  8024fe:	85 c0                	test   %eax,%eax
  802500:	78 46                	js     802548 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802502:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802507:	7f 04                	jg     80250d <nsipc_recv+0x3c>
  802509:	39 c6                	cmp    %eax,%esi
  80250b:	7d 24                	jge    802531 <nsipc_recv+0x60>
  80250d:	c7 44 24 0c 34 37 80 	movl   $0x803734,0xc(%esp)
  802514:	00 
  802515:	c7 44 24 08 13 37 80 	movl   $0x803713,0x8(%esp)
  80251c:	00 
  80251d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802524:	00 
  802525:	c7 04 24 28 37 80 00 	movl   $0x803728,(%esp)
  80252c:	e8 3b df ff ff       	call   80046c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802531:	89 44 24 08          	mov    %eax,0x8(%esp)
  802535:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80253c:	00 
  80253d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802540:	89 04 24             	mov    %eax,(%esp)
  802543:	e8 7d e8 ff ff       	call   800dc5 <memmove>
	}

	return r;
}
  802548:	89 d8                	mov    %ebx,%eax
  80254a:	83 c4 10             	add    $0x10,%esp
  80254d:	5b                   	pop    %ebx
  80254e:	5e                   	pop    %esi
  80254f:	5d                   	pop    %ebp
  802550:	c3                   	ret    

00802551 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
  802554:	53                   	push   %ebx
  802555:	83 ec 14             	sub    $0x14,%esp
  802558:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80255b:	8b 45 08             	mov    0x8(%ebp),%eax
  80255e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802563:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802567:	8b 45 0c             	mov    0xc(%ebp),%eax
  80256a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80256e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802575:	e8 4b e8 ff ff       	call   800dc5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80257a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802580:	b8 05 00 00 00       	mov    $0x5,%eax
  802585:	e8 06 fe ff ff       	call   802390 <nsipc>
}
  80258a:	83 c4 14             	add    $0x14,%esp
  80258d:	5b                   	pop    %ebx
  80258e:	5d                   	pop    %ebp
  80258f:	c3                   	ret    

00802590 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
  802593:	53                   	push   %ebx
  802594:	83 ec 14             	sub    $0x14,%esp
  802597:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80259a:	8b 45 08             	mov    0x8(%ebp),%eax
  80259d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8025a2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8025a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ad:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8025b4:	e8 0c e8 ff ff       	call   800dc5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8025b9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8025bf:	b8 02 00 00 00       	mov    $0x2,%eax
  8025c4:	e8 c7 fd ff ff       	call   802390 <nsipc>
}
  8025c9:	83 c4 14             	add    $0x14,%esp
  8025cc:	5b                   	pop    %ebx
  8025cd:	5d                   	pop    %ebp
  8025ce:	c3                   	ret    

008025cf <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8025cf:	55                   	push   %ebp
  8025d0:	89 e5                	mov    %esp,%ebp
  8025d2:	83 ec 18             	sub    $0x18,%esp
  8025d5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8025d8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8025db:	8b 45 08             	mov    0x8(%ebp),%eax
  8025de:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8025e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025e8:	e8 a3 fd ff ff       	call   802390 <nsipc>
  8025ed:	89 c3                	mov    %eax,%ebx
  8025ef:	85 c0                	test   %eax,%eax
  8025f1:	78 25                	js     802618 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8025f3:	be 10 60 80 00       	mov    $0x806010,%esi
  8025f8:	8b 06                	mov    (%esi),%eax
  8025fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025fe:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802605:	00 
  802606:	8b 45 0c             	mov    0xc(%ebp),%eax
  802609:	89 04 24             	mov    %eax,(%esp)
  80260c:	e8 b4 e7 ff ff       	call   800dc5 <memmove>
		*addrlen = ret->ret_addrlen;
  802611:	8b 16                	mov    (%esi),%edx
  802613:	8b 45 10             	mov    0x10(%ebp),%eax
  802616:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802618:	89 d8                	mov    %ebx,%eax
  80261a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80261d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802620:	89 ec                	mov    %ebp,%esp
  802622:	5d                   	pop    %ebp
  802623:	c3                   	ret    
	...

00802630 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802630:	55                   	push   %ebp
  802631:	89 e5                	mov    %esp,%ebp
  802633:	83 ec 18             	sub    $0x18,%esp
  802636:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802639:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80263c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80263f:	8b 45 08             	mov    0x8(%ebp),%eax
  802642:	89 04 24             	mov    %eax,(%esp)
  802645:	e8 e6 f1 ff ff       	call   801830 <fd2data>
  80264a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80264c:	c7 44 24 04 49 37 80 	movl   $0x803749,0x4(%esp)
  802653:	00 
  802654:	89 34 24             	mov    %esi,(%esp)
  802657:	e8 ae e5 ff ff       	call   800c0a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80265c:	8b 43 04             	mov    0x4(%ebx),%eax
  80265f:	2b 03                	sub    (%ebx),%eax
  802661:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802667:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80266e:	00 00 00 
	stat->st_dev = &devpipe;
  802671:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  802678:	70 80 00 
	return 0;
}
  80267b:	b8 00 00 00 00       	mov    $0x0,%eax
  802680:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802683:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802686:	89 ec                	mov    %ebp,%esp
  802688:	5d                   	pop    %ebp
  802689:	c3                   	ret    

0080268a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80268a:	55                   	push   %ebp
  80268b:	89 e5                	mov    %esp,%ebp
  80268d:	53                   	push   %ebx
  80268e:	83 ec 14             	sub    $0x14,%esp
  802691:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802694:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802698:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80269f:	e8 06 ec ff ff       	call   8012aa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8026a4:	89 1c 24             	mov    %ebx,(%esp)
  8026a7:	e8 84 f1 ff ff       	call   801830 <fd2data>
  8026ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8026b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026b7:	e8 ee eb ff ff       	call   8012aa <sys_page_unmap>
}
  8026bc:	83 c4 14             	add    $0x14,%esp
  8026bf:	5b                   	pop    %ebx
  8026c0:	5d                   	pop    %ebp
  8026c1:	c3                   	ret    

008026c2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8026c2:	55                   	push   %ebp
  8026c3:	89 e5                	mov    %esp,%ebp
  8026c5:	57                   	push   %edi
  8026c6:	56                   	push   %esi
  8026c7:	53                   	push   %ebx
  8026c8:	83 ec 2c             	sub    $0x2c,%esp
  8026cb:	89 c7                	mov    %eax,%edi
  8026cd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8026d0:	a1 80 74 80 00       	mov    0x807480,%eax
  8026d5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8026d8:	89 3c 24             	mov    %edi,(%esp)
  8026db:	e8 a8 06 00 00       	call   802d88 <pageref>
  8026e0:	89 c6                	mov    %eax,%esi
  8026e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026e5:	89 04 24             	mov    %eax,(%esp)
  8026e8:	e8 9b 06 00 00       	call   802d88 <pageref>
  8026ed:	39 c6                	cmp    %eax,%esi
  8026ef:	0f 94 c0             	sete   %al
  8026f2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  8026f5:	8b 15 80 74 80 00    	mov    0x807480,%edx
  8026fb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8026fe:	39 cb                	cmp    %ecx,%ebx
  802700:	75 08                	jne    80270a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802702:	83 c4 2c             	add    $0x2c,%esp
  802705:	5b                   	pop    %ebx
  802706:	5e                   	pop    %esi
  802707:	5f                   	pop    %edi
  802708:	5d                   	pop    %ebp
  802709:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80270a:	83 f8 01             	cmp    $0x1,%eax
  80270d:	75 c1                	jne    8026d0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80270f:	8b 52 58             	mov    0x58(%edx),%edx
  802712:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802716:	89 54 24 08          	mov    %edx,0x8(%esp)
  80271a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80271e:	c7 04 24 50 37 80 00 	movl   $0x803750,(%esp)
  802725:	e8 07 de ff ff       	call   800531 <cprintf>
  80272a:	eb a4                	jmp    8026d0 <_pipeisclosed+0xe>

0080272c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80272c:	55                   	push   %ebp
  80272d:	89 e5                	mov    %esp,%ebp
  80272f:	57                   	push   %edi
  802730:	56                   	push   %esi
  802731:	53                   	push   %ebx
  802732:	83 ec 1c             	sub    $0x1c,%esp
  802735:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802738:	89 34 24             	mov    %esi,(%esp)
  80273b:	e8 f0 f0 ff ff       	call   801830 <fd2data>
  802740:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802742:	bf 00 00 00 00       	mov    $0x0,%edi
  802747:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80274b:	75 54                	jne    8027a1 <devpipe_write+0x75>
  80274d:	eb 60                	jmp    8027af <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80274f:	89 da                	mov    %ebx,%edx
  802751:	89 f0                	mov    %esi,%eax
  802753:	e8 6a ff ff ff       	call   8026c2 <_pipeisclosed>
  802758:	85 c0                	test   %eax,%eax
  80275a:	74 07                	je     802763 <devpipe_write+0x37>
  80275c:	b8 00 00 00 00       	mov    $0x0,%eax
  802761:	eb 53                	jmp    8027b6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802763:	90                   	nop
  802764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802768:	e8 58 ec ff ff       	call   8013c5 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80276d:	8b 43 04             	mov    0x4(%ebx),%eax
  802770:	8b 13                	mov    (%ebx),%edx
  802772:	83 c2 20             	add    $0x20,%edx
  802775:	39 d0                	cmp    %edx,%eax
  802777:	73 d6                	jae    80274f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802779:	89 c2                	mov    %eax,%edx
  80277b:	c1 fa 1f             	sar    $0x1f,%edx
  80277e:	c1 ea 1b             	shr    $0x1b,%edx
  802781:	01 d0                	add    %edx,%eax
  802783:	83 e0 1f             	and    $0x1f,%eax
  802786:	29 d0                	sub    %edx,%eax
  802788:	89 c2                	mov    %eax,%edx
  80278a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80278d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802791:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802795:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802799:	83 c7 01             	add    $0x1,%edi
  80279c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80279f:	76 13                	jbe    8027b4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8027a1:	8b 43 04             	mov    0x4(%ebx),%eax
  8027a4:	8b 13                	mov    (%ebx),%edx
  8027a6:	83 c2 20             	add    $0x20,%edx
  8027a9:	39 d0                	cmp    %edx,%eax
  8027ab:	73 a2                	jae    80274f <devpipe_write+0x23>
  8027ad:	eb ca                	jmp    802779 <devpipe_write+0x4d>
  8027af:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8027b4:	89 f8                	mov    %edi,%eax
}
  8027b6:	83 c4 1c             	add    $0x1c,%esp
  8027b9:	5b                   	pop    %ebx
  8027ba:	5e                   	pop    %esi
  8027bb:	5f                   	pop    %edi
  8027bc:	5d                   	pop    %ebp
  8027bd:	c3                   	ret    

008027be <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8027be:	55                   	push   %ebp
  8027bf:	89 e5                	mov    %esp,%ebp
  8027c1:	83 ec 28             	sub    $0x28,%esp
  8027c4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8027c7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8027ca:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8027cd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8027d0:	89 3c 24             	mov    %edi,(%esp)
  8027d3:	e8 58 f0 ff ff       	call   801830 <fd2data>
  8027d8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027da:	be 00 00 00 00       	mov    $0x0,%esi
  8027df:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027e3:	75 4c                	jne    802831 <devpipe_read+0x73>
  8027e5:	eb 5b                	jmp    802842 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8027e7:	89 f0                	mov    %esi,%eax
  8027e9:	eb 5e                	jmp    802849 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8027eb:	89 da                	mov    %ebx,%edx
  8027ed:	89 f8                	mov    %edi,%eax
  8027ef:	90                   	nop
  8027f0:	e8 cd fe ff ff       	call   8026c2 <_pipeisclosed>
  8027f5:	85 c0                	test   %eax,%eax
  8027f7:	74 07                	je     802800 <devpipe_read+0x42>
  8027f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027fe:	eb 49                	jmp    802849 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802800:	e8 c0 eb ff ff       	call   8013c5 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802805:	8b 03                	mov    (%ebx),%eax
  802807:	3b 43 04             	cmp    0x4(%ebx),%eax
  80280a:	74 df                	je     8027eb <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80280c:	89 c2                	mov    %eax,%edx
  80280e:	c1 fa 1f             	sar    $0x1f,%edx
  802811:	c1 ea 1b             	shr    $0x1b,%edx
  802814:	01 d0                	add    %edx,%eax
  802816:	83 e0 1f             	and    $0x1f,%eax
  802819:	29 d0                	sub    %edx,%eax
  80281b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802820:	8b 55 0c             	mov    0xc(%ebp),%edx
  802823:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802826:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802829:	83 c6 01             	add    $0x1,%esi
  80282c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80282f:	76 16                	jbe    802847 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802831:	8b 03                	mov    (%ebx),%eax
  802833:	3b 43 04             	cmp    0x4(%ebx),%eax
  802836:	75 d4                	jne    80280c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802838:	85 f6                	test   %esi,%esi
  80283a:	75 ab                	jne    8027e7 <devpipe_read+0x29>
  80283c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802840:	eb a9                	jmp    8027eb <devpipe_read+0x2d>
  802842:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802847:	89 f0                	mov    %esi,%eax
}
  802849:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80284c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80284f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802852:	89 ec                	mov    %ebp,%esp
  802854:	5d                   	pop    %ebp
  802855:	c3                   	ret    

00802856 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802856:	55                   	push   %ebp
  802857:	89 e5                	mov    %esp,%ebp
  802859:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80285c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80285f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802863:	8b 45 08             	mov    0x8(%ebp),%eax
  802866:	89 04 24             	mov    %eax,(%esp)
  802869:	e8 4f f0 ff ff       	call   8018bd <fd_lookup>
  80286e:	85 c0                	test   %eax,%eax
  802870:	78 15                	js     802887 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	89 04 24             	mov    %eax,(%esp)
  802878:	e8 b3 ef ff ff       	call   801830 <fd2data>
	return _pipeisclosed(fd, p);
  80287d:	89 c2                	mov    %eax,%edx
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	e8 3b fe ff ff       	call   8026c2 <_pipeisclosed>
}
  802887:	c9                   	leave  
  802888:	c3                   	ret    

00802889 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802889:	55                   	push   %ebp
  80288a:	89 e5                	mov    %esp,%ebp
  80288c:	83 ec 48             	sub    $0x48,%esp
  80288f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802892:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802895:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802898:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80289b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80289e:	89 04 24             	mov    %eax,(%esp)
  8028a1:	e8 a5 ef ff ff       	call   80184b <fd_alloc>
  8028a6:	89 c3                	mov    %eax,%ebx
  8028a8:	85 c0                	test   %eax,%eax
  8028aa:	0f 88 42 01 00 00    	js     8029f2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028b0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028b7:	00 
  8028b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028bf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028c6:	e8 9b ea ff ff       	call   801366 <sys_page_alloc>
  8028cb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8028cd:	85 c0                	test   %eax,%eax
  8028cf:	0f 88 1d 01 00 00    	js     8029f2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8028d5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8028d8:	89 04 24             	mov    %eax,(%esp)
  8028db:	e8 6b ef ff ff       	call   80184b <fd_alloc>
  8028e0:	89 c3                	mov    %eax,%ebx
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	0f 88 f5 00 00 00    	js     8029df <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028ea:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028f1:	00 
  8028f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802900:	e8 61 ea ff ff       	call   801366 <sys_page_alloc>
  802905:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802907:	85 c0                	test   %eax,%eax
  802909:	0f 88 d0 00 00 00    	js     8029df <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80290f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802912:	89 04 24             	mov    %eax,(%esp)
  802915:	e8 16 ef ff ff       	call   801830 <fd2data>
  80291a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80291c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802923:	00 
  802924:	89 44 24 04          	mov    %eax,0x4(%esp)
  802928:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80292f:	e8 32 ea ff ff       	call   801366 <sys_page_alloc>
  802934:	89 c3                	mov    %eax,%ebx
  802936:	85 c0                	test   %eax,%eax
  802938:	0f 88 8e 00 00 00    	js     8029cc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80293e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802941:	89 04 24             	mov    %eax,(%esp)
  802944:	e8 e7 ee ff ff       	call   801830 <fd2data>
  802949:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802950:	00 
  802951:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802955:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80295c:	00 
  80295d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802961:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802968:	e8 9b e9 ff ff       	call   801308 <sys_page_map>
  80296d:	89 c3                	mov    %eax,%ebx
  80296f:	85 c0                	test   %eax,%eax
  802971:	78 49                	js     8029bc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802973:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  802978:	8b 08                	mov    (%eax),%ecx
  80297a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80297d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80297f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802982:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802989:	8b 10                	mov    (%eax),%edx
  80298b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80298e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802990:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802993:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80299a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80299d:	89 04 24             	mov    %eax,(%esp)
  8029a0:	e8 7b ee ff ff       	call   801820 <fd2num>
  8029a5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8029a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029aa:	89 04 24             	mov    %eax,(%esp)
  8029ad:	e8 6e ee ff ff       	call   801820 <fd2num>
  8029b2:	89 47 04             	mov    %eax,0x4(%edi)
  8029b5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8029ba:	eb 36                	jmp    8029f2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8029bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8029c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029c7:	e8 de e8 ff ff       	call   8012aa <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8029cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8029cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029da:	e8 cb e8 ff ff       	call   8012aa <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8029df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029ed:	e8 b8 e8 ff ff       	call   8012aa <sys_page_unmap>
    err:
	return r;
}
  8029f2:	89 d8                	mov    %ebx,%eax
  8029f4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8029f7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8029fa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8029fd:	89 ec                	mov    %ebp,%esp
  8029ff:	5d                   	pop    %ebp
  802a00:	c3                   	ret    
  802a01:	00 00                	add    %al,(%eax)
	...

00802a04 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802a04:	55                   	push   %ebp
  802a05:	89 e5                	mov    %esp,%ebp
  802a07:	56                   	push   %esi
  802a08:	53                   	push   %ebx
  802a09:	83 ec 10             	sub    $0x10,%esp
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
	volatile struct Env *e;

	assert(envid != 0);
  802a0f:	85 c0                	test   %eax,%eax
  802a11:	75 24                	jne    802a37 <wait+0x33>
  802a13:	c7 44 24 0c 68 37 80 	movl   $0x803768,0xc(%esp)
  802a1a:	00 
  802a1b:	c7 44 24 08 13 37 80 	movl   $0x803713,0x8(%esp)
  802a22:	00 
  802a23:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802a2a:	00 
  802a2b:	c7 04 24 73 37 80 00 	movl   $0x803773,(%esp)
  802a32:	e8 35 da ff ff       	call   80046c <_panic>
	e = &envs[ENVX(envid)];
  802a37:	89 c3                	mov    %eax,%ebx
  802a39:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802a3f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802a42:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802a48:	8b 73 4c             	mov    0x4c(%ebx),%esi
  802a4b:	39 c6                	cmp    %eax,%esi
  802a4d:	75 1a                	jne    802a69 <wait+0x65>
  802a4f:	8b 43 54             	mov    0x54(%ebx),%eax
  802a52:	85 c0                	test   %eax,%eax
  802a54:	74 13                	je     802a69 <wait+0x65>
		sys_yield();
  802a56:	e8 6a e9 ff ff       	call   8013c5 <sys_yield>
{
	volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802a5b:	8b 43 4c             	mov    0x4c(%ebx),%eax
  802a5e:	39 f0                	cmp    %esi,%eax
  802a60:	75 07                	jne    802a69 <wait+0x65>
  802a62:	8b 43 54             	mov    0x54(%ebx),%eax
  802a65:	85 c0                	test   %eax,%eax
  802a67:	75 ed                	jne    802a56 <wait+0x52>
		sys_yield();
}
  802a69:	83 c4 10             	add    $0x10,%esp
  802a6c:	5b                   	pop    %ebx
  802a6d:	5e                   	pop    %esi
  802a6e:	5d                   	pop    %ebp
  802a6f:	c3                   	ret    

00802a70 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802a70:	55                   	push   %ebp
  802a71:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802a73:	b8 00 00 00 00       	mov    $0x0,%eax
  802a78:	5d                   	pop    %ebp
  802a79:	c3                   	ret    

00802a7a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802a7a:	55                   	push   %ebp
  802a7b:	89 e5                	mov    %esp,%ebp
  802a7d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802a80:	c7 44 24 04 7e 37 80 	movl   $0x80377e,0x4(%esp)
  802a87:	00 
  802a88:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a8b:	89 04 24             	mov    %eax,(%esp)
  802a8e:	e8 77 e1 ff ff       	call   800c0a <strcpy>
	return 0;
}
  802a93:	b8 00 00 00 00       	mov    $0x0,%eax
  802a98:	c9                   	leave  
  802a99:	c3                   	ret    

00802a9a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802a9a:	55                   	push   %ebp
  802a9b:	89 e5                	mov    %esp,%ebp
  802a9d:	57                   	push   %edi
  802a9e:	56                   	push   %esi
  802a9f:	53                   	push   %ebx
  802aa0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802aa6:	b8 00 00 00 00       	mov    $0x0,%eax
  802aab:	be 00 00 00 00       	mov    $0x0,%esi
  802ab0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802ab4:	74 3f                	je     802af5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802ab6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802abc:	8b 55 10             	mov    0x10(%ebp),%edx
  802abf:	29 c2                	sub    %eax,%edx
  802ac1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802ac3:	83 fa 7f             	cmp    $0x7f,%edx
  802ac6:	76 05                	jbe    802acd <devcons_write+0x33>
  802ac8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802acd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802ad1:	03 45 0c             	add    0xc(%ebp),%eax
  802ad4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ad8:	89 3c 24             	mov    %edi,(%esp)
  802adb:	e8 e5 e2 ff ff       	call   800dc5 <memmove>
		sys_cputs(buf, m);
  802ae0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802ae4:	89 3c 24             	mov    %edi,(%esp)
  802ae7:	e8 14 e5 ff ff       	call   801000 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802aec:	01 de                	add    %ebx,%esi
  802aee:	89 f0                	mov    %esi,%eax
  802af0:	3b 75 10             	cmp    0x10(%ebp),%esi
  802af3:	72 c7                	jb     802abc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802af5:	89 f0                	mov    %esi,%eax
  802af7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802afd:	5b                   	pop    %ebx
  802afe:	5e                   	pop    %esi
  802aff:	5f                   	pop    %edi
  802b00:	5d                   	pop    %ebp
  802b01:	c3                   	ret    

00802b02 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802b02:	55                   	push   %ebp
  802b03:	89 e5                	mov    %esp,%ebp
  802b05:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802b08:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802b0e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802b15:	00 
  802b16:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802b19:	89 04 24             	mov    %eax,(%esp)
  802b1c:	e8 df e4 ff ff       	call   801000 <sys_cputs>
}
  802b21:	c9                   	leave  
  802b22:	c3                   	ret    

00802b23 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802b23:	55                   	push   %ebp
  802b24:	89 e5                	mov    %esp,%ebp
  802b26:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802b29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802b2d:	75 07                	jne    802b36 <devcons_read+0x13>
  802b2f:	eb 28                	jmp    802b59 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802b31:	e8 8f e8 ff ff       	call   8013c5 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802b36:	66 90                	xchg   %ax,%ax
  802b38:	e8 8f e4 ff ff       	call   800fcc <sys_cgetc>
  802b3d:	85 c0                	test   %eax,%eax
  802b3f:	90                   	nop
  802b40:	74 ef                	je     802b31 <devcons_read+0xe>
  802b42:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802b44:	85 c0                	test   %eax,%eax
  802b46:	78 16                	js     802b5e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802b48:	83 f8 04             	cmp    $0x4,%eax
  802b4b:	74 0c                	je     802b59 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802b50:	88 10                	mov    %dl,(%eax)
  802b52:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802b57:	eb 05                	jmp    802b5e <devcons_read+0x3b>
  802b59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b5e:	c9                   	leave  
  802b5f:	c3                   	ret    

00802b60 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802b60:	55                   	push   %ebp
  802b61:	89 e5                	mov    %esp,%ebp
  802b63:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802b66:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b69:	89 04 24             	mov    %eax,(%esp)
  802b6c:	e8 da ec ff ff       	call   80184b <fd_alloc>
  802b71:	85 c0                	test   %eax,%eax
  802b73:	78 3f                	js     802bb4 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802b75:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b7c:	00 
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b84:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b8b:	e8 d6 e7 ff ff       	call   801366 <sys_page_alloc>
  802b90:	85 c0                	test   %eax,%eax
  802b92:	78 20                	js     802bb4 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802b94:	8b 15 58 70 80 00    	mov    0x807058,%edx
  802b9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802ba9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bac:	89 04 24             	mov    %eax,(%esp)
  802baf:	e8 6c ec ff ff       	call   801820 <fd2num>
}
  802bb4:	c9                   	leave  
  802bb5:	c3                   	ret    

00802bb6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802bb6:	55                   	push   %ebp
  802bb7:	89 e5                	mov    %esp,%ebp
  802bb9:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802bbc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802bbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc6:	89 04 24             	mov    %eax,(%esp)
  802bc9:	e8 ef ec ff ff       	call   8018bd <fd_lookup>
  802bce:	85 c0                	test   %eax,%eax
  802bd0:	78 11                	js     802be3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  802bdd:	0f 94 c0             	sete   %al
  802be0:	0f b6 c0             	movzbl %al,%eax
}
  802be3:	c9                   	leave  
  802be4:	c3                   	ret    

00802be5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802be5:	55                   	push   %ebp
  802be6:	89 e5                	mov    %esp,%ebp
  802be8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802beb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802bf2:	00 
  802bf3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bfa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c01:	e8 18 ef ff ff       	call   801b1e <read>
	if (r < 0)
  802c06:	85 c0                	test   %eax,%eax
  802c08:	78 0f                	js     802c19 <getchar+0x34>
		return r;
	if (r < 1)
  802c0a:	85 c0                	test   %eax,%eax
  802c0c:	7f 07                	jg     802c15 <getchar+0x30>
  802c0e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802c13:	eb 04                	jmp    802c19 <getchar+0x34>
		return -E_EOF;
	return c;
  802c15:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802c19:	c9                   	leave  
  802c1a:	c3                   	ret    
	...

00802c1c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802c1c:	55                   	push   %ebp
  802c1d:	89 e5                	mov    %esp,%ebp
  802c1f:	53                   	push   %ebx
  802c20:	83 ec 14             	sub    $0x14,%esp
  802c23:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    // cprintf("\nhere outside loading creating page\n");

	if (_pgfault_handler == 0) {
  802c26:	83 3d 88 74 80 00 00 	cmpl   $0x0,0x807488
  802c2d:	75 58                	jne    802c87 <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
           //cprintf("\nhere inside loading creating page\n");    
          if(sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  802c2f:	e8 c5 e7 ff ff       	call   8013f9 <sys_getenvid>
  802c34:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802c3b:	00 
  802c3c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802c43:	ee 
  802c44:	89 04 24             	mov    %eax,(%esp)
  802c47:	e8 1a e7 ff ff       	call   801366 <sys_page_alloc>
  802c4c:	85 c0                	test   %eax,%eax
  802c4e:	79 1c                	jns    802c6c <set_pgfault_handler+0x50>
                          panic("Cant allocate Page");                    
  802c50:	c7 44 24 08 ec 35 80 	movl   $0x8035ec,0x8(%esp)
  802c57:	00 
  802c58:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802c5f:	00 
  802c60:	c7 04 24 8a 37 80 00 	movl   $0x80378a,(%esp)
  802c67:	e8 00 d8 ff ff       	call   80046c <_panic>
                _pgfault_handler=handler;
  802c6c:	89 1d 88 74 80 00    	mov    %ebx,0x807488
//entry point _pgfault_handler not pointed to by the kernel bcz after the execution is complete control needs to be returned back to execute the rest...so upcall is there         
             sys_env_set_pgfault_upcall(sys_getenvid(),_pgfault_upcall);
  802c72:	e8 82 e7 ff ff       	call   8013f9 <sys_getenvid>
  802c77:	c7 44 24 04 94 2c 80 	movl   $0x802c94,0x4(%esp)
  802c7e:	00 
  802c7f:	89 04 24             	mov    %eax,(%esp)
  802c82:	e8 09 e5 ff ff       	call   801190 <sys_env_set_pgfault_upcall>

	// Save handler pointer for assembly to call.
 //     if(sys_page_alloc(0,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
   //                       panic("Cant allocate Page");

	_pgfault_handler = handler;
  802c87:	89 1d 88 74 80 00    	mov    %ebx,0x807488
}
  802c8d:	83 c4 14             	add    $0x14,%esp
  802c90:	5b                   	pop    %ebx
  802c91:	5d                   	pop    %ebp
  802c92:	c3                   	ret    
	...

00802c94 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802c94:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802c95:	a1 88 74 80 00       	mov    0x807488,%eax
	call *%eax
  802c9a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802c9c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
           addl $8,%esp
  802c9f:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
            movl  32(%esp),%ebx
  802ca2:	8b 5c 24 20          	mov    0x20(%esp),%ebx
            movl  40(%esp),%eax
  802ca6:	8b 44 24 28          	mov    0x28(%esp),%eax
            subl  $4,%eax
  802caa:	83 e8 04             	sub    $0x4,%eax
            movl  %eax,40(%esp)
  802cad:	89 44 24 28          	mov    %eax,0x28(%esp)
            movl  %ebx,(%eax)
  802cb1:	89 18                	mov    %ebx,(%eax)
            popal
  802cb3:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
            
            add $4,%esp            
  802cb4:	83 c4 04             	add    $0x4,%esp
            popfl
  802cb7:	9d                   	popf   
             
           popl %esp
  802cb8:	5c                   	pop    %esp
	// LAB 4: Your code here.
           

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
           ret
  802cb9:	c3                   	ret    
  802cba:	00 00                	add    %al,(%eax)
  802cbc:	00 00                	add    %al,(%eax)
	...

00802cc0 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802cc0:	55                   	push   %ebp
  802cc1:	89 e5                	mov    %esp,%ebp
  802cc3:	57                   	push   %edi
  802cc4:	56                   	push   %esi
  802cc5:	53                   	push   %ebx
  802cc6:	83 ec 1c             	sub    $0x1c,%esp
  802cc9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802ccc:	8b 75 0c             	mov    0xc(%ebp),%esi
  802ccf:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  802cd2:	8b 45 14             	mov    0x14(%ebp),%eax
  802cd5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802cd9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802cdd:	89 74 24 04          	mov    %esi,0x4(%esp)
  802ce1:	89 1c 24             	mov    %ebx,(%esp)
  802ce4:	e8 6f e4 ff ff       	call   801158 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	79 21                	jns    802d0e <ipc_send+0x4e>
  802ced:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802cf0:	74 1c                	je     802d0e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  802cf2:	c7 44 24 08 98 37 80 	movl   $0x803798,0x8(%esp)
  802cf9:	00 
  802cfa:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  802d01:	00 
  802d02:	c7 04 24 aa 37 80 00 	movl   $0x8037aa,(%esp)
  802d09:	e8 5e d7 ff ff       	call   80046c <_panic>
          else if(r==-E_IPC_NOT_RECV)
  802d0e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802d11:	75 07                	jne    802d1a <ipc_send+0x5a>
           sys_yield();
  802d13:	e8 ad e6 ff ff       	call   8013c5 <sys_yield>
          else
            break;
        }
  802d18:	eb b8                	jmp    802cd2 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  802d1a:	83 c4 1c             	add    $0x1c,%esp
  802d1d:	5b                   	pop    %ebx
  802d1e:	5e                   	pop    %esi
  802d1f:	5f                   	pop    %edi
  802d20:	5d                   	pop    %ebp
  802d21:	c3                   	ret    

00802d22 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802d22:	55                   	push   %ebp
  802d23:	89 e5                	mov    %esp,%ebp
  802d25:	83 ec 18             	sub    $0x18,%esp
  802d28:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802d2b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802d2e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802d31:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  802d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d37:	89 04 24             	mov    %eax,(%esp)
  802d3a:	e8 bc e3 ff ff       	call   8010fb <sys_ipc_recv>
        if(r<0)
  802d3f:	85 c0                	test   %eax,%eax
  802d41:	79 17                	jns    802d5a <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  802d43:	85 db                	test   %ebx,%ebx
  802d45:	74 06                	je     802d4d <ipc_recv+0x2b>
               *from_env_store =0;
  802d47:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  802d4d:	85 f6                	test   %esi,%esi
  802d4f:	90                   	nop
  802d50:	74 2c                	je     802d7e <ipc_recv+0x5c>
              *perm_store=0;
  802d52:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802d58:	eb 24                	jmp    802d7e <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  802d5a:	85 db                	test   %ebx,%ebx
  802d5c:	74 0a                	je     802d68 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  802d5e:	a1 80 74 80 00       	mov    0x807480,%eax
  802d63:	8b 40 74             	mov    0x74(%eax),%eax
  802d66:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  802d68:	85 f6                	test   %esi,%esi
  802d6a:	74 0a                	je     802d76 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  802d6c:	a1 80 74 80 00       	mov    0x807480,%eax
  802d71:	8b 40 78             	mov    0x78(%eax),%eax
  802d74:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  802d76:	a1 80 74 80 00       	mov    0x807480,%eax
  802d7b:	8b 40 70             	mov    0x70(%eax),%eax
}
  802d7e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802d81:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802d84:	89 ec                	mov    %ebp,%esp
  802d86:	5d                   	pop    %ebp
  802d87:	c3                   	ret    

00802d88 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802d88:	55                   	push   %ebp
  802d89:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8e:	89 c2                	mov    %eax,%edx
  802d90:	c1 ea 16             	shr    $0x16,%edx
  802d93:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802d9a:	f6 c2 01             	test   $0x1,%dl
  802d9d:	74 26                	je     802dc5 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802d9f:	c1 e8 0c             	shr    $0xc,%eax
  802da2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802da9:	a8 01                	test   $0x1,%al
  802dab:	74 18                	je     802dc5 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802dad:	c1 e8 0c             	shr    $0xc,%eax
  802db0:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802db3:	c1 e2 02             	shl    $0x2,%edx
  802db6:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802dbb:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802dc0:	0f b7 c0             	movzwl %ax,%eax
  802dc3:	eb 05                	jmp    802dca <pageref+0x42>
  802dc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dca:	5d                   	pop    %ebp
  802dcb:	c3                   	ret    
  802dcc:	00 00                	add    %al,(%eax)
	...

00802dd0 <__udivdi3>:
  802dd0:	55                   	push   %ebp
  802dd1:	89 e5                	mov    %esp,%ebp
  802dd3:	57                   	push   %edi
  802dd4:	56                   	push   %esi
  802dd5:	83 ec 10             	sub    $0x10,%esp
  802dd8:	8b 45 14             	mov    0x14(%ebp),%eax
  802ddb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dde:	8b 75 10             	mov    0x10(%ebp),%esi
  802de1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802de4:	85 c0                	test   %eax,%eax
  802de6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802de9:	75 35                	jne    802e20 <__udivdi3+0x50>
  802deb:	39 fe                	cmp    %edi,%esi
  802ded:	77 61                	ja     802e50 <__udivdi3+0x80>
  802def:	85 f6                	test   %esi,%esi
  802df1:	75 0b                	jne    802dfe <__udivdi3+0x2e>
  802df3:	b8 01 00 00 00       	mov    $0x1,%eax
  802df8:	31 d2                	xor    %edx,%edx
  802dfa:	f7 f6                	div    %esi
  802dfc:	89 c6                	mov    %eax,%esi
  802dfe:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802e01:	31 d2                	xor    %edx,%edx
  802e03:	89 f8                	mov    %edi,%eax
  802e05:	f7 f6                	div    %esi
  802e07:	89 c7                	mov    %eax,%edi
  802e09:	89 c8                	mov    %ecx,%eax
  802e0b:	f7 f6                	div    %esi
  802e0d:	89 c1                	mov    %eax,%ecx
  802e0f:	89 fa                	mov    %edi,%edx
  802e11:	89 c8                	mov    %ecx,%eax
  802e13:	83 c4 10             	add    $0x10,%esp
  802e16:	5e                   	pop    %esi
  802e17:	5f                   	pop    %edi
  802e18:	5d                   	pop    %ebp
  802e19:	c3                   	ret    
  802e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802e20:	39 f8                	cmp    %edi,%eax
  802e22:	77 1c                	ja     802e40 <__udivdi3+0x70>
  802e24:	0f bd d0             	bsr    %eax,%edx
  802e27:	83 f2 1f             	xor    $0x1f,%edx
  802e2a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e2d:	75 39                	jne    802e68 <__udivdi3+0x98>
  802e2f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802e32:	0f 86 a0 00 00 00    	jbe    802ed8 <__udivdi3+0x108>
  802e38:	39 f8                	cmp    %edi,%eax
  802e3a:	0f 82 98 00 00 00    	jb     802ed8 <__udivdi3+0x108>
  802e40:	31 ff                	xor    %edi,%edi
  802e42:	31 c9                	xor    %ecx,%ecx
  802e44:	89 c8                	mov    %ecx,%eax
  802e46:	89 fa                	mov    %edi,%edx
  802e48:	83 c4 10             	add    $0x10,%esp
  802e4b:	5e                   	pop    %esi
  802e4c:	5f                   	pop    %edi
  802e4d:	5d                   	pop    %ebp
  802e4e:	c3                   	ret    
  802e4f:	90                   	nop
  802e50:	89 d1                	mov    %edx,%ecx
  802e52:	89 fa                	mov    %edi,%edx
  802e54:	89 c8                	mov    %ecx,%eax
  802e56:	31 ff                	xor    %edi,%edi
  802e58:	f7 f6                	div    %esi
  802e5a:	89 c1                	mov    %eax,%ecx
  802e5c:	89 fa                	mov    %edi,%edx
  802e5e:	89 c8                	mov    %ecx,%eax
  802e60:	83 c4 10             	add    $0x10,%esp
  802e63:	5e                   	pop    %esi
  802e64:	5f                   	pop    %edi
  802e65:	5d                   	pop    %ebp
  802e66:	c3                   	ret    
  802e67:	90                   	nop
  802e68:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802e6c:	89 f2                	mov    %esi,%edx
  802e6e:	d3 e0                	shl    %cl,%eax
  802e70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e73:	b8 20 00 00 00       	mov    $0x20,%eax
  802e78:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802e7b:	89 c1                	mov    %eax,%ecx
  802e7d:	d3 ea                	shr    %cl,%edx
  802e7f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802e83:	0b 55 ec             	or     -0x14(%ebp),%edx
  802e86:	d3 e6                	shl    %cl,%esi
  802e88:	89 c1                	mov    %eax,%ecx
  802e8a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802e8d:	89 fe                	mov    %edi,%esi
  802e8f:	d3 ee                	shr    %cl,%esi
  802e91:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802e95:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802e98:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802e9b:	d3 e7                	shl    %cl,%edi
  802e9d:	89 c1                	mov    %eax,%ecx
  802e9f:	d3 ea                	shr    %cl,%edx
  802ea1:	09 d7                	or     %edx,%edi
  802ea3:	89 f2                	mov    %esi,%edx
  802ea5:	89 f8                	mov    %edi,%eax
  802ea7:	f7 75 ec             	divl   -0x14(%ebp)
  802eaa:	89 d6                	mov    %edx,%esi
  802eac:	89 c7                	mov    %eax,%edi
  802eae:	f7 65 e8             	mull   -0x18(%ebp)
  802eb1:	39 d6                	cmp    %edx,%esi
  802eb3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802eb6:	72 30                	jb     802ee8 <__udivdi3+0x118>
  802eb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ebb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802ebf:	d3 e2                	shl    %cl,%edx
  802ec1:	39 c2                	cmp    %eax,%edx
  802ec3:	73 05                	jae    802eca <__udivdi3+0xfa>
  802ec5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802ec8:	74 1e                	je     802ee8 <__udivdi3+0x118>
  802eca:	89 f9                	mov    %edi,%ecx
  802ecc:	31 ff                	xor    %edi,%edi
  802ece:	e9 71 ff ff ff       	jmp    802e44 <__udivdi3+0x74>
  802ed3:	90                   	nop
  802ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ed8:	31 ff                	xor    %edi,%edi
  802eda:	b9 01 00 00 00       	mov    $0x1,%ecx
  802edf:	e9 60 ff ff ff       	jmp    802e44 <__udivdi3+0x74>
  802ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ee8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802eeb:	31 ff                	xor    %edi,%edi
  802eed:	89 c8                	mov    %ecx,%eax
  802eef:	89 fa                	mov    %edi,%edx
  802ef1:	83 c4 10             	add    $0x10,%esp
  802ef4:	5e                   	pop    %esi
  802ef5:	5f                   	pop    %edi
  802ef6:	5d                   	pop    %ebp
  802ef7:	c3                   	ret    
	...

00802f00 <__umoddi3>:
  802f00:	55                   	push   %ebp
  802f01:	89 e5                	mov    %esp,%ebp
  802f03:	57                   	push   %edi
  802f04:	56                   	push   %esi
  802f05:	83 ec 20             	sub    $0x20,%esp
  802f08:	8b 55 14             	mov    0x14(%ebp),%edx
  802f0b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f0e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802f11:	8b 75 0c             	mov    0xc(%ebp),%esi
  802f14:	85 d2                	test   %edx,%edx
  802f16:	89 c8                	mov    %ecx,%eax
  802f18:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802f1b:	75 13                	jne    802f30 <__umoddi3+0x30>
  802f1d:	39 f7                	cmp    %esi,%edi
  802f1f:	76 3f                	jbe    802f60 <__umoddi3+0x60>
  802f21:	89 f2                	mov    %esi,%edx
  802f23:	f7 f7                	div    %edi
  802f25:	89 d0                	mov    %edx,%eax
  802f27:	31 d2                	xor    %edx,%edx
  802f29:	83 c4 20             	add    $0x20,%esp
  802f2c:	5e                   	pop    %esi
  802f2d:	5f                   	pop    %edi
  802f2e:	5d                   	pop    %ebp
  802f2f:	c3                   	ret    
  802f30:	39 f2                	cmp    %esi,%edx
  802f32:	77 4c                	ja     802f80 <__umoddi3+0x80>
  802f34:	0f bd ca             	bsr    %edx,%ecx
  802f37:	83 f1 1f             	xor    $0x1f,%ecx
  802f3a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802f3d:	75 51                	jne    802f90 <__umoddi3+0x90>
  802f3f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802f42:	0f 87 e0 00 00 00    	ja     803028 <__umoddi3+0x128>
  802f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4b:	29 f8                	sub    %edi,%eax
  802f4d:	19 d6                	sbb    %edx,%esi
  802f4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f55:	89 f2                	mov    %esi,%edx
  802f57:	83 c4 20             	add    $0x20,%esp
  802f5a:	5e                   	pop    %esi
  802f5b:	5f                   	pop    %edi
  802f5c:	5d                   	pop    %ebp
  802f5d:	c3                   	ret    
  802f5e:	66 90                	xchg   %ax,%ax
  802f60:	85 ff                	test   %edi,%edi
  802f62:	75 0b                	jne    802f6f <__umoddi3+0x6f>
  802f64:	b8 01 00 00 00       	mov    $0x1,%eax
  802f69:	31 d2                	xor    %edx,%edx
  802f6b:	f7 f7                	div    %edi
  802f6d:	89 c7                	mov    %eax,%edi
  802f6f:	89 f0                	mov    %esi,%eax
  802f71:	31 d2                	xor    %edx,%edx
  802f73:	f7 f7                	div    %edi
  802f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f78:	f7 f7                	div    %edi
  802f7a:	eb a9                	jmp    802f25 <__umoddi3+0x25>
  802f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f80:	89 c8                	mov    %ecx,%eax
  802f82:	89 f2                	mov    %esi,%edx
  802f84:	83 c4 20             	add    $0x20,%esp
  802f87:	5e                   	pop    %esi
  802f88:	5f                   	pop    %edi
  802f89:	5d                   	pop    %ebp
  802f8a:	c3                   	ret    
  802f8b:	90                   	nop
  802f8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f90:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802f94:	d3 e2                	shl    %cl,%edx
  802f96:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802f99:	ba 20 00 00 00       	mov    $0x20,%edx
  802f9e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802fa1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802fa4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802fa8:	89 fa                	mov    %edi,%edx
  802faa:	d3 ea                	shr    %cl,%edx
  802fac:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802fb0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802fb3:	d3 e7                	shl    %cl,%edi
  802fb5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802fb9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802fbc:	89 f2                	mov    %esi,%edx
  802fbe:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802fc1:	89 c7                	mov    %eax,%edi
  802fc3:	d3 ea                	shr    %cl,%edx
  802fc5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802fc9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802fcc:	89 c2                	mov    %eax,%edx
  802fce:	d3 e6                	shl    %cl,%esi
  802fd0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802fd4:	d3 ea                	shr    %cl,%edx
  802fd6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802fda:	09 d6                	or     %edx,%esi
  802fdc:	89 f0                	mov    %esi,%eax
  802fde:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802fe1:	d3 e7                	shl    %cl,%edi
  802fe3:	89 f2                	mov    %esi,%edx
  802fe5:	f7 75 f4             	divl   -0xc(%ebp)
  802fe8:	89 d6                	mov    %edx,%esi
  802fea:	f7 65 e8             	mull   -0x18(%ebp)
  802fed:	39 d6                	cmp    %edx,%esi
  802fef:	72 2b                	jb     80301c <__umoddi3+0x11c>
  802ff1:	39 c7                	cmp    %eax,%edi
  802ff3:	72 23                	jb     803018 <__umoddi3+0x118>
  802ff5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ff9:	29 c7                	sub    %eax,%edi
  802ffb:	19 d6                	sbb    %edx,%esi
  802ffd:	89 f0                	mov    %esi,%eax
  802fff:	89 f2                	mov    %esi,%edx
  803001:	d3 ef                	shr    %cl,%edi
  803003:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803007:	d3 e0                	shl    %cl,%eax
  803009:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80300d:	09 f8                	or     %edi,%eax
  80300f:	d3 ea                	shr    %cl,%edx
  803011:	83 c4 20             	add    $0x20,%esp
  803014:	5e                   	pop    %esi
  803015:	5f                   	pop    %edi
  803016:	5d                   	pop    %ebp
  803017:	c3                   	ret    
  803018:	39 d6                	cmp    %edx,%esi
  80301a:	75 d9                	jne    802ff5 <__umoddi3+0xf5>
  80301c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80301f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  803022:	eb d1                	jmp    802ff5 <__umoddi3+0xf5>
  803024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803028:	39 f2                	cmp    %esi,%edx
  80302a:	0f 82 18 ff ff ff    	jb     802f48 <__umoddi3+0x48>
  803030:	e9 1d ff ff ff       	jmp    802f52 <__umoddi3+0x52>
