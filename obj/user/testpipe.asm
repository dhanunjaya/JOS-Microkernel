
obj/user/testpipe:     file format elf32-i386


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
  80002c:	e8 e7 02 00 00       	call   800318 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:

char *msg = "Now is the time for all good men to come to the aid of their party.";

void
umain(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 c4 80             	add    $0xffffff80,%esp
	char buf[100];
	int i, pid, p[2];

	argv0 = "pipereadeof";
  80003c:	c7 05 7c 70 80 00 60 	movl   $0x802f60,0x80707c
  800043:	2f 80 00 

	if ((i = pipe(p)) < 0)
  800046:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 58 27 00 00       	call   8027a9 <pipe>
  800051:	89 c6                	mov    %eax,%esi
  800053:	85 c0                	test   %eax,%eax
  800055:	79 20                	jns    800077 <umain+0x43>
		panic("pipe: %e", i);
  800057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80005b:	c7 44 24 08 6c 2f 80 	movl   $0x802f6c,0x8(%esp)
  800062:	00 
  800063:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  80006a:	00 
  80006b:	c7 04 24 75 2f 80 00 	movl   $0x802f75,(%esp)
  800072:	e8 0d 03 00 00       	call   800384 <_panic>

	if ((pid = fork()) < 0)
  800077:	e8 8b 14 00 00       	call   801507 <fork>
  80007c:	89 c3                	mov    %eax,%ebx
  80007e:	85 c0                	test   %eax,%eax
  800080:	79 20                	jns    8000a2 <umain+0x6e>
		panic("fork: %e", i);
  800082:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800086:	c7 44 24 08 43 34 80 	movl   $0x803443,0x8(%esp)
  80008d:	00 
  80008e:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800095:	00 
  800096:	c7 04 24 75 2f 80 00 	movl   $0x802f75,(%esp)
  80009d:	e8 e2 02 00 00       	call   800384 <_panic>

	if (pid == 0) {
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	0f 85 d5 00 00 00    	jne    80017f <umain+0x14b>
		cprintf("[%08x] pipereadeof close %d\n", env->env_id, p[1]);
  8000aa:	a1 78 70 80 00       	mov    0x807078,%eax
  8000af:	8b 40 4c             	mov    0x4c(%eax),%eax
  8000b2:	8b 55 90             	mov    -0x70(%ebp),%edx
  8000b5:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000bd:	c7 04 24 85 2f 80 00 	movl   $0x802f85,(%esp)
  8000c4:	e8 80 03 00 00       	call   800449 <cprintf>
		close(p[1]);
  8000c9:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000cc:	89 04 24             	mov    %eax,(%esp)
  8000cf:	e8 ca 1a 00 00       	call   801b9e <close>
		cprintf("[%08x] pipereadeof readn %d\n", env->env_id, p[0]);
  8000d4:	a1 78 70 80 00       	mov    0x807078,%eax
  8000d9:	8b 40 4c             	mov    0x4c(%eax),%eax
  8000dc:	8b 55 8c             	mov    -0x74(%ebp),%edx
  8000df:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e7:	c7 04 24 a2 2f 80 00 	movl   $0x802fa2,(%esp)
  8000ee:	e8 56 03 00 00       	call   800449 <cprintf>
		i = readn(p[0], buf, sizeof buf-1);
  8000f3:	c7 44 24 08 63 00 00 	movl   $0x63,0x8(%esp)
  8000fa:	00 
  8000fb:	8d 45 94             	lea    -0x6c(%ebp),%eax
  8000fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800102:	8b 45 8c             	mov    -0x74(%ebp),%eax
  800105:	89 04 24             	mov    %eax,(%esp)
  800108:	e8 bf 19 00 00       	call   801acc <readn>
  80010d:	89 c6                	mov    %eax,%esi
		if (i < 0)
  80010f:	85 c0                	test   %eax,%eax
  800111:	79 20                	jns    800133 <umain+0xff>
			panic("read: %e", i);
  800113:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800117:	c7 44 24 08 bf 2f 80 	movl   $0x802fbf,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  800126:	00 
  800127:	c7 04 24 75 2f 80 00 	movl   $0x802f75,(%esp)
  80012e:	e8 51 02 00 00       	call   800384 <_panic>
		buf[i] = 0;
  800133:	c6 44 05 94 00       	movb   $0x0,-0x6c(%ebp,%eax,1)
		if (strcmp(buf, msg) == 0)
  800138:	a1 00 70 80 00       	mov    0x807000,%eax
  80013d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800141:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800144:	89 04 24             	mov    %eax,(%esp)
  800147:	e8 6d 0a 00 00       	call   800bb9 <strcmp>
  80014c:	85 c0                	test   %eax,%eax
  80014e:	75 0e                	jne    80015e <umain+0x12a>
			cprintf("\npipe read closed properly\n");
  800150:	c7 04 24 c8 2f 80 00 	movl   $0x802fc8,(%esp)
  800157:	e8 ed 02 00 00       	call   800449 <cprintf>
  80015c:	eb 17                	jmp    800175 <umain+0x141>
		else
			cprintf("\ngot %d bytes: %s\n", i, buf);
  80015e:	8d 45 94             	lea    -0x6c(%ebp),%eax
  800161:	89 44 24 08          	mov    %eax,0x8(%esp)
  800165:	89 74 24 04          	mov    %esi,0x4(%esp)
  800169:	c7 04 24 e4 2f 80 00 	movl   $0x802fe4,(%esp)
  800170:	e8 d4 02 00 00       	call   800449 <cprintf>
		exit();
  800175:	e8 ee 01 00 00       	call   800368 <exit>
  80017a:	e9 ac 00 00 00       	jmp    80022b <umain+0x1f7>
	} else {
		cprintf("[%08x] pipereadeof close %d\n", env->env_id, p[0]);
  80017f:	a1 78 70 80 00       	mov    0x807078,%eax
  800184:	8b 40 4c             	mov    0x4c(%eax),%eax
  800187:	8b 55 8c             	mov    -0x74(%ebp),%edx
  80018a:	89 54 24 08          	mov    %edx,0x8(%esp)
  80018e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800192:	c7 04 24 85 2f 80 00 	movl   $0x802f85,(%esp)
  800199:	e8 ab 02 00 00       	call   800449 <cprintf>
		close(p[0]);
  80019e:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8001a1:	89 04 24             	mov    %eax,(%esp)
  8001a4:	e8 f5 19 00 00       	call   801b9e <close>
		cprintf("[%08x] pipereadeof write %d\n", env->env_id, p[1]);
  8001a9:	a1 78 70 80 00       	mov    0x807078,%eax
  8001ae:	8b 40 4c             	mov    0x4c(%eax),%eax
  8001b1:	8b 55 90             	mov    -0x70(%ebp),%edx
  8001b4:	89 54 24 08          	mov    %edx,0x8(%esp)
  8001b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001bc:	c7 04 24 f7 2f 80 00 	movl   $0x802ff7,(%esp)
  8001c3:	e8 81 02 00 00       	call   800449 <cprintf>
		if ((i = write(p[1], msg, strlen(msg))) != strlen(msg))
  8001c8:	a1 00 70 80 00       	mov    0x807000,%eax
  8001cd:	89 04 24             	mov    %eax,(%esp)
  8001d0:	e8 0b 09 00 00       	call   800ae0 <strlen>
  8001d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  8001d9:	a1 00 70 80 00       	mov    0x807000,%eax
  8001de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e2:	8b 45 90             	mov    -0x70(%ebp),%eax
  8001e5:	89 04 24             	mov    %eax,(%esp)
  8001e8:	e8 c8 17 00 00       	call   8019b5 <write>
  8001ed:	89 c6                	mov    %eax,%esi
  8001ef:	a1 00 70 80 00       	mov    0x807000,%eax
  8001f4:	89 04 24             	mov    %eax,(%esp)
  8001f7:	e8 e4 08 00 00       	call   800ae0 <strlen>
  8001fc:	39 c6                	cmp    %eax,%esi
  8001fe:	74 20                	je     800220 <umain+0x1ec>
			panic("write: %e", i);
  800200:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800204:	c7 44 24 08 14 30 80 	movl   $0x803014,0x8(%esp)
  80020b:	00 
  80020c:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
  800213:	00 
  800214:	c7 04 24 75 2f 80 00 	movl   $0x802f75,(%esp)
  80021b:	e8 64 01 00 00       	call   800384 <_panic>
		close(p[1]);
  800220:	8b 45 90             	mov    -0x70(%ebp),%eax
  800223:	89 04 24             	mov    %eax,(%esp)
  800226:	e8 73 19 00 00       	call   801b9e <close>
	}
	wait(pid);
  80022b:	89 1c 24             	mov    %ebx,(%esp)
  80022e:	e8 f1 26 00 00       	call   802924 <wait>

	argv0 = "pipewriteeof";
  800233:	c7 05 7c 70 80 00 1e 	movl   $0x80301e,0x80707c
  80023a:	30 80 00 
	if ((i = pipe(p)) < 0)
  80023d:	8d 45 8c             	lea    -0x74(%ebp),%eax
  800240:	89 04 24             	mov    %eax,(%esp)
  800243:	e8 61 25 00 00       	call   8027a9 <pipe>
  800248:	89 c6                	mov    %eax,%esi
  80024a:	85 c0                	test   %eax,%eax
  80024c:	79 20                	jns    80026e <umain+0x23a>
		panic("pipe: %e", i);
  80024e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800252:	c7 44 24 08 6c 2f 80 	movl   $0x802f6c,0x8(%esp)
  800259:	00 
  80025a:	c7 44 24 04 2c 00 00 	movl   $0x2c,0x4(%esp)
  800261:	00 
  800262:	c7 04 24 75 2f 80 00 	movl   $0x802f75,(%esp)
  800269:	e8 16 01 00 00       	call   800384 <_panic>

	if ((pid = fork()) < 0)
  80026e:	e8 94 12 00 00       	call   801507 <fork>
  800273:	89 c3                	mov    %eax,%ebx
  800275:	85 c0                	test   %eax,%eax
  800277:	79 20                	jns    800299 <umain+0x265>
		panic("fork: %e", i);
  800279:	89 74 24 0c          	mov    %esi,0xc(%esp)
  80027d:	c7 44 24 08 43 34 80 	movl   $0x803443,0x8(%esp)
  800284:	00 
  800285:	c7 44 24 04 2f 00 00 	movl   $0x2f,0x4(%esp)
  80028c:	00 
  80028d:	c7 04 24 75 2f 80 00 	movl   $0x802f75,(%esp)
  800294:	e8 eb 00 00 00       	call   800384 <_panic>

	if (pid == 0) {
  800299:	85 c0                	test   %eax,%eax
  80029b:	75 48                	jne    8002e5 <umain+0x2b1>
		close(p[0]);
  80029d:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8002a0:	89 04 24             	mov    %eax,(%esp)
  8002a3:	e8 f6 18 00 00       	call   801b9e <close>
		while (1) {
			cprintf(".");
  8002a8:	c7 04 24 2b 30 80 00 	movl   $0x80302b,(%esp)
  8002af:	e8 95 01 00 00       	call   800449 <cprintf>
			if (write(p[1], "x", 1) != 1)
  8002b4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002bb:	00 
  8002bc:	c7 44 24 04 2d 30 80 	movl   $0x80302d,0x4(%esp)
  8002c3:	00 
  8002c4:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002c7:	89 04 24             	mov    %eax,(%esp)
  8002ca:	e8 e6 16 00 00       	call   8019b5 <write>
  8002cf:	83 f8 01             	cmp    $0x1,%eax
  8002d2:	74 d4                	je     8002a8 <umain+0x274>
				break;
		}
		cprintf("\npipe write closed properly\n");
  8002d4:	c7 04 24 2f 30 80 00 	movl   $0x80302f,(%esp)
  8002db:	e8 69 01 00 00       	call   800449 <cprintf>
		exit();
  8002e0:	e8 83 00 00 00       	call   800368 <exit>
	}
	close(p[0]);
  8002e5:	8b 45 8c             	mov    -0x74(%ebp),%eax
  8002e8:	89 04 24             	mov    %eax,(%esp)
  8002eb:	e8 ae 18 00 00       	call   801b9e <close>
	close(p[1]);
  8002f0:	8b 45 90             	mov    -0x70(%ebp),%eax
  8002f3:	89 04 24             	mov    %eax,(%esp)
  8002f6:	e8 a3 18 00 00       	call   801b9e <close>
	wait(pid);
  8002fb:	89 1c 24             	mov    %ebx,(%esp)
  8002fe:	e8 21 26 00 00       	call   802924 <wait>

	cprintf("pipe tests passed\n");
  800303:	c7 04 24 4c 30 80 00 	movl   $0x80304c,(%esp)
  80030a:	e8 3a 01 00 00       	call   800449 <cprintf>
}
  80030f:	83 ec 80             	sub    $0xffffff80,%esp
  800312:	5b                   	pop    %ebx
  800313:	5e                   	pop    %esi
  800314:	5d                   	pop    %ebp
  800315:	c3                   	ret    
	...

00800318 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 18             	sub    $0x18,%esp
  80031e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800321:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800324:	8b 75 08             	mov    0x8(%ebp),%esi
  800327:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  80032a:	e8 ea 0f 00 00       	call   801319 <sys_getenvid>
  80032f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800334:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800337:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80033c:	a3 78 70 80 00       	mov    %eax,0x807078

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800341:	85 f6                	test   %esi,%esi
  800343:	7e 07                	jle    80034c <libmain+0x34>
		binaryname = argv[0];
  800345:	8b 03                	mov    (%ebx),%eax
  800347:	a3 04 70 80 00       	mov    %eax,0x807004

	// call user main routine
	umain(argc, argv);
  80034c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800350:	89 34 24             	mov    %esi,(%esp)
  800353:	e8 dc fc ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  800358:	e8 0b 00 00 00       	call   800368 <exit>
}
  80035d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800360:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800363:	89 ec                	mov    %ebp,%esp
  800365:	5d                   	pop    %ebp
  800366:	c3                   	ret    
	...

00800368 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80036e:	e8 a8 18 00 00       	call   801c1b <close_all>
	sys_env_destroy(0);
  800373:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80037a:	e8 ce 0f 00 00       	call   80134d <sys_env_destroy>
}
  80037f:	c9                   	leave  
  800380:	c3                   	ret    
  800381:	00 00                	add    %al,(%eax)
	...

00800384 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800384:	55                   	push   %ebp
  800385:	89 e5                	mov    %esp,%ebp
  800387:	53                   	push   %ebx
  800388:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  80038b:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  80038e:	a1 7c 70 80 00       	mov    0x80707c,%eax
  800393:	85 c0                	test   %eax,%eax
  800395:	74 10                	je     8003a7 <_panic+0x23>
		cprintf("%s: ", argv0);
  800397:	89 44 24 04          	mov    %eax,0x4(%esp)
  80039b:	c7 04 24 bb 30 80 00 	movl   $0x8030bb,(%esp)
  8003a2:	e8 a2 00 00 00       	call   800449 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003aa:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003b5:	a1 04 70 80 00       	mov    0x807004,%eax
  8003ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003be:	c7 04 24 c0 30 80 00 	movl   $0x8030c0,(%esp)
  8003c5:	e8 7f 00 00 00       	call   800449 <cprintf>
	vcprintf(fmt, ap);
  8003ca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8003d1:	89 04 24             	mov    %eax,(%esp)
  8003d4:	e8 0f 00 00 00       	call   8003e8 <vcprintf>
	cprintf("\n");
  8003d9:	c7 04 24 a0 2f 80 00 	movl   $0x802fa0,(%esp)
  8003e0:	e8 64 00 00 00       	call   800449 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003e5:	cc                   	int3   
  8003e6:	eb fd                	jmp    8003e5 <_panic+0x61>

008003e8 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8003e8:	55                   	push   %ebp
  8003e9:	89 e5                	mov    %esp,%ebp
  8003eb:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003f1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003f8:	00 00 00 
	b.cnt = 0;
  8003fb:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800402:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800405:	8b 45 0c             	mov    0xc(%ebp),%eax
  800408:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80040c:	8b 45 08             	mov    0x8(%ebp),%eax
  80040f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800413:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800419:	89 44 24 04          	mov    %eax,0x4(%esp)
  80041d:	c7 04 24 63 04 80 00 	movl   $0x800463,(%esp)
  800424:	e8 d4 01 00 00       	call   8005fd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800429:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80042f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800433:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800439:	89 04 24             	mov    %eax,(%esp)
  80043c:	e8 df 0a 00 00       	call   800f20 <sys_cputs>

	return b.cnt;
}
  800441:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800447:	c9                   	leave  
  800448:	c3                   	ret    

00800449 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800449:	55                   	push   %ebp
  80044a:	89 e5                	mov    %esp,%ebp
  80044c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  80044f:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800452:	89 44 24 04          	mov    %eax,0x4(%esp)
  800456:	8b 45 08             	mov    0x8(%ebp),%eax
  800459:	89 04 24             	mov    %eax,(%esp)
  80045c:	e8 87 ff ff ff       	call   8003e8 <vcprintf>
	va_end(ap);

	return cnt;
}
  800461:	c9                   	leave  
  800462:	c3                   	ret    

00800463 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800463:	55                   	push   %ebp
  800464:	89 e5                	mov    %esp,%ebp
  800466:	53                   	push   %ebx
  800467:	83 ec 14             	sub    $0x14,%esp
  80046a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80046d:	8b 03                	mov    (%ebx),%eax
  80046f:	8b 55 08             	mov    0x8(%ebp),%edx
  800472:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  800476:	83 c0 01             	add    $0x1,%eax
  800479:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80047b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800480:	75 19                	jne    80049b <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800482:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800489:	00 
  80048a:	8d 43 08             	lea    0x8(%ebx),%eax
  80048d:	89 04 24             	mov    %eax,(%esp)
  800490:	e8 8b 0a 00 00       	call   800f20 <sys_cputs>
		b->idx = 0;
  800495:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80049b:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  80049f:	83 c4 14             	add    $0x14,%esp
  8004a2:	5b                   	pop    %ebx
  8004a3:	5d                   	pop    %ebp
  8004a4:	c3                   	ret    
	...

008004b0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b0:	55                   	push   %ebp
  8004b1:	89 e5                	mov    %esp,%ebp
  8004b3:	57                   	push   %edi
  8004b4:	56                   	push   %esi
  8004b5:	53                   	push   %ebx
  8004b6:	83 ec 4c             	sub    $0x4c,%esp
  8004b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004bc:	89 d6                	mov    %edx,%esi
  8004be:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8004cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004d0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004d6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004db:	39 d1                	cmp    %edx,%ecx
  8004dd:	72 15                	jb     8004f4 <printnum+0x44>
  8004df:	77 07                	ja     8004e8 <printnum+0x38>
  8004e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e4:	39 d0                	cmp    %edx,%eax
  8004e6:	76 0c                	jbe    8004f4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004e8:	83 eb 01             	sub    $0x1,%ebx
  8004eb:	85 db                	test   %ebx,%ebx
  8004ed:	8d 76 00             	lea    0x0(%esi),%esi
  8004f0:	7f 61                	jg     800553 <printnum+0xa3>
  8004f2:	eb 70                	jmp    800564 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004f4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8004f8:	83 eb 01             	sub    $0x1,%ebx
  8004fb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  800503:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800507:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80050b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80050e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800511:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800514:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800518:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80051f:	00 
  800520:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800523:	89 04 24             	mov    %eax,(%esp)
  800526:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800529:	89 54 24 04          	mov    %edx,0x4(%esp)
  80052d:	e8 be 27 00 00       	call   802cf0 <__udivdi3>
  800532:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800535:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800538:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80053c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800540:	89 04 24             	mov    %eax,(%esp)
  800543:	89 54 24 04          	mov    %edx,0x4(%esp)
  800547:	89 f2                	mov    %esi,%edx
  800549:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80054c:	e8 5f ff ff ff       	call   8004b0 <printnum>
  800551:	eb 11                	jmp    800564 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800553:	89 74 24 04          	mov    %esi,0x4(%esp)
  800557:	89 3c 24             	mov    %edi,(%esp)
  80055a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80055d:	83 eb 01             	sub    $0x1,%ebx
  800560:	85 db                	test   %ebx,%ebx
  800562:	7f ef                	jg     800553 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800564:	89 74 24 04          	mov    %esi,0x4(%esp)
  800568:	8b 74 24 04          	mov    0x4(%esp),%esi
  80056c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80056f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800573:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80057a:	00 
  80057b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80057e:	89 14 24             	mov    %edx,(%esp)
  800581:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800584:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800588:	e8 93 28 00 00       	call   802e20 <__umoddi3>
  80058d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800591:	0f be 80 dc 30 80 00 	movsbl 0x8030dc(%eax),%eax
  800598:	89 04 24             	mov    %eax,(%esp)
  80059b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80059e:	83 c4 4c             	add    $0x4c,%esp
  8005a1:	5b                   	pop    %ebx
  8005a2:	5e                   	pop    %esi
  8005a3:	5f                   	pop    %edi
  8005a4:	5d                   	pop    %ebp
  8005a5:	c3                   	ret    

008005a6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8005a6:	55                   	push   %ebp
  8005a7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005a9:	83 fa 01             	cmp    $0x1,%edx
  8005ac:	7e 0e                	jle    8005bc <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8005ae:	8b 10                	mov    (%eax),%edx
  8005b0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8005b3:	89 08                	mov    %ecx,(%eax)
  8005b5:	8b 02                	mov    (%edx),%eax
  8005b7:	8b 52 04             	mov    0x4(%edx),%edx
  8005ba:	eb 22                	jmp    8005de <getuint+0x38>
	else if (lflag)
  8005bc:	85 d2                	test   %edx,%edx
  8005be:	74 10                	je     8005d0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8005c0:	8b 10                	mov    (%eax),%edx
  8005c2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005c5:	89 08                	mov    %ecx,(%eax)
  8005c7:	8b 02                	mov    (%edx),%eax
  8005c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ce:	eb 0e                	jmp    8005de <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005d0:	8b 10                	mov    (%eax),%edx
  8005d2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005d5:	89 08                	mov    %ecx,(%eax)
  8005d7:	8b 02                	mov    (%edx),%eax
  8005d9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005de:	5d                   	pop    %ebp
  8005df:	c3                   	ret    

008005e0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
  8005e3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005e6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005ea:	8b 10                	mov    (%eax),%edx
  8005ec:	3b 50 04             	cmp    0x4(%eax),%edx
  8005ef:	73 0a                	jae    8005fb <sprintputch+0x1b>
		*b->buf++ = ch;
  8005f1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005f4:	88 0a                	mov    %cl,(%edx)
  8005f6:	83 c2 01             	add    $0x1,%edx
  8005f9:	89 10                	mov    %edx,(%eax)
}
  8005fb:	5d                   	pop    %ebp
  8005fc:	c3                   	ret    

008005fd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005fd:	55                   	push   %ebp
  8005fe:	89 e5                	mov    %esp,%ebp
  800600:	57                   	push   %edi
  800601:	56                   	push   %esi
  800602:	53                   	push   %ebx
  800603:	83 ec 5c             	sub    $0x5c,%esp
  800606:	8b 7d 08             	mov    0x8(%ebp),%edi
  800609:	8b 75 0c             	mov    0xc(%ebp),%esi
  80060c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80060f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800616:	eb 11                	jmp    800629 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800618:	85 c0                	test   %eax,%eax
  80061a:	0f 84 09 04 00 00    	je     800a29 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  800620:	89 74 24 04          	mov    %esi,0x4(%esp)
  800624:	89 04 24             	mov    %eax,(%esp)
  800627:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800629:	0f b6 03             	movzbl (%ebx),%eax
  80062c:	83 c3 01             	add    $0x1,%ebx
  80062f:	83 f8 25             	cmp    $0x25,%eax
  800632:	75 e4                	jne    800618 <vprintfmt+0x1b>
  800634:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800638:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80063f:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800646:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80064d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800652:	eb 06                	jmp    80065a <vprintfmt+0x5d>
  800654:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800658:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80065a:	0f b6 13             	movzbl (%ebx),%edx
  80065d:	0f b6 c2             	movzbl %dl,%eax
  800660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800663:	8d 43 01             	lea    0x1(%ebx),%eax
  800666:	83 ea 23             	sub    $0x23,%edx
  800669:	80 fa 55             	cmp    $0x55,%dl
  80066c:	0f 87 9a 03 00 00    	ja     800a0c <vprintfmt+0x40f>
  800672:	0f b6 d2             	movzbl %dl,%edx
  800675:	ff 24 95 20 32 80 00 	jmp    *0x803220(,%edx,4)
  80067c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800680:	eb d6                	jmp    800658 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800682:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800685:	83 ea 30             	sub    $0x30,%edx
  800688:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  80068b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80068e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800691:	83 fb 09             	cmp    $0x9,%ebx
  800694:	77 4c                	ja     8006e2 <vprintfmt+0xe5>
  800696:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800699:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80069c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80069f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8006a2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8006a6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8006a9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8006ac:	83 fb 09             	cmp    $0x9,%ebx
  8006af:	76 eb                	jbe    80069c <vprintfmt+0x9f>
  8006b1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8006b4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8006b7:	eb 29                	jmp    8006e2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006b9:	8b 55 14             	mov    0x14(%ebp),%edx
  8006bc:	8d 5a 04             	lea    0x4(%edx),%ebx
  8006bf:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8006c2:	8b 12                	mov    (%edx),%edx
  8006c4:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  8006c7:	eb 19                	jmp    8006e2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8006c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006cc:	c1 fa 1f             	sar    $0x1f,%edx
  8006cf:	f7 d2                	not    %edx
  8006d1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8006d4:	eb 82                	jmp    800658 <vprintfmt+0x5b>
  8006d6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8006dd:	e9 76 ff ff ff       	jmp    800658 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8006e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006e6:	0f 89 6c ff ff ff    	jns    800658 <vprintfmt+0x5b>
  8006ec:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8006ef:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006f2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8006f5:	89 55 cc             	mov    %edx,-0x34(%ebp)
  8006f8:	e9 5b ff ff ff       	jmp    800658 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006fd:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800700:	e9 53 ff ff ff       	jmp    800658 <vprintfmt+0x5b>
  800705:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800708:	8b 45 14             	mov    0x14(%ebp),%eax
  80070b:	8d 50 04             	lea    0x4(%eax),%edx
  80070e:	89 55 14             	mov    %edx,0x14(%ebp)
  800711:	89 74 24 04          	mov    %esi,0x4(%esp)
  800715:	8b 00                	mov    (%eax),%eax
  800717:	89 04 24             	mov    %eax,(%esp)
  80071a:	ff d7                	call   *%edi
  80071c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80071f:	e9 05 ff ff ff       	jmp    800629 <vprintfmt+0x2c>
  800724:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800727:	8b 45 14             	mov    0x14(%ebp),%eax
  80072a:	8d 50 04             	lea    0x4(%eax),%edx
  80072d:	89 55 14             	mov    %edx,0x14(%ebp)
  800730:	8b 00                	mov    (%eax),%eax
  800732:	89 c2                	mov    %eax,%edx
  800734:	c1 fa 1f             	sar    $0x1f,%edx
  800737:	31 d0                	xor    %edx,%eax
  800739:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80073b:	83 f8 0f             	cmp    $0xf,%eax
  80073e:	7f 0b                	jg     80074b <vprintfmt+0x14e>
  800740:	8b 14 85 80 33 80 00 	mov    0x803380(,%eax,4),%edx
  800747:	85 d2                	test   %edx,%edx
  800749:	75 20                	jne    80076b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80074b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80074f:	c7 44 24 08 ed 30 80 	movl   $0x8030ed,0x8(%esp)
  800756:	00 
  800757:	89 74 24 04          	mov    %esi,0x4(%esp)
  80075b:	89 3c 24             	mov    %edi,(%esp)
  80075e:	e8 4e 03 00 00       	call   800ab1 <printfmt>
  800763:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800766:	e9 be fe ff ff       	jmp    800629 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80076b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80076f:	c7 44 24 08 85 35 80 	movl   $0x803585,0x8(%esp)
  800776:	00 
  800777:	89 74 24 04          	mov    %esi,0x4(%esp)
  80077b:	89 3c 24             	mov    %edi,(%esp)
  80077e:	e8 2e 03 00 00       	call   800ab1 <printfmt>
  800783:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800786:	e9 9e fe ff ff       	jmp    800629 <vprintfmt+0x2c>
  80078b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80078e:	89 c3                	mov    %eax,%ebx
  800790:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800796:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800799:	8b 45 14             	mov    0x14(%ebp),%eax
  80079c:	8d 50 04             	lea    0x4(%eax),%edx
  80079f:	89 55 14             	mov    %edx,0x14(%ebp)
  8007a2:	8b 00                	mov    (%eax),%eax
  8007a4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8007a7:	85 c0                	test   %eax,%eax
  8007a9:	75 07                	jne    8007b2 <vprintfmt+0x1b5>
  8007ab:	c7 45 c4 f6 30 80 00 	movl   $0x8030f6,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  8007b2:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8007b6:	7e 06                	jle    8007be <vprintfmt+0x1c1>
  8007b8:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  8007bc:	75 13                	jne    8007d1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007be:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007c1:	0f be 02             	movsbl (%edx),%eax
  8007c4:	85 c0                	test   %eax,%eax
  8007c6:	0f 85 99 00 00 00    	jne    800865 <vprintfmt+0x268>
  8007cc:	e9 86 00 00 00       	jmp    800857 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007d1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007d5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8007d8:	89 0c 24             	mov    %ecx,(%esp)
  8007db:	e8 1b 03 00 00       	call   800afb <strnlen>
  8007e0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8007e3:	29 c2                	sub    %eax,%edx
  8007e5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007e8:	85 d2                	test   %edx,%edx
  8007ea:	7e d2                	jle    8007be <vprintfmt+0x1c1>
					putch(padc, putdat);
  8007ec:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  8007f0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007f3:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  8007f6:	89 d3                	mov    %edx,%ebx
  8007f8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007ff:	89 04 24             	mov    %eax,(%esp)
  800802:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800804:	83 eb 01             	sub    $0x1,%ebx
  800807:	85 db                	test   %ebx,%ebx
  800809:	7f ed                	jg     8007f8 <vprintfmt+0x1fb>
  80080b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80080e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800815:	eb a7                	jmp    8007be <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800817:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80081b:	74 18                	je     800835 <vprintfmt+0x238>
  80081d:	8d 50 e0             	lea    -0x20(%eax),%edx
  800820:	83 fa 5e             	cmp    $0x5e,%edx
  800823:	76 10                	jbe    800835 <vprintfmt+0x238>
					putch('?', putdat);
  800825:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800829:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800830:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800833:	eb 0a                	jmp    80083f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800835:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800839:	89 04 24             	mov    %eax,(%esp)
  80083c:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80083f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800843:	0f be 03             	movsbl (%ebx),%eax
  800846:	85 c0                	test   %eax,%eax
  800848:	74 05                	je     80084f <vprintfmt+0x252>
  80084a:	83 c3 01             	add    $0x1,%ebx
  80084d:	eb 29                	jmp    800878 <vprintfmt+0x27b>
  80084f:	89 fe                	mov    %edi,%esi
  800851:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800854:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800857:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80085b:	7f 2e                	jg     80088b <vprintfmt+0x28e>
  80085d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800860:	e9 c4 fd ff ff       	jmp    800629 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800865:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800868:	83 c2 01             	add    $0x1,%edx
  80086b:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80086e:	89 f7                	mov    %esi,%edi
  800870:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800873:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  800876:	89 d3                	mov    %edx,%ebx
  800878:	85 f6                	test   %esi,%esi
  80087a:	78 9b                	js     800817 <vprintfmt+0x21a>
  80087c:	83 ee 01             	sub    $0x1,%esi
  80087f:	79 96                	jns    800817 <vprintfmt+0x21a>
  800881:	89 fe                	mov    %edi,%esi
  800883:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800886:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800889:	eb cc                	jmp    800857 <vprintfmt+0x25a>
  80088b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  80088e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800891:	89 74 24 04          	mov    %esi,0x4(%esp)
  800895:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80089c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80089e:	83 eb 01             	sub    $0x1,%ebx
  8008a1:	85 db                	test   %ebx,%ebx
  8008a3:	7f ec                	jg     800891 <vprintfmt+0x294>
  8008a5:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8008a8:	e9 7c fd ff ff       	jmp    800629 <vprintfmt+0x2c>
  8008ad:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8008b0:	83 f9 01             	cmp    $0x1,%ecx
  8008b3:	7e 16                	jle    8008cb <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  8008b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b8:	8d 50 08             	lea    0x8(%eax),%edx
  8008bb:	89 55 14             	mov    %edx,0x14(%ebp)
  8008be:	8b 10                	mov    (%eax),%edx
  8008c0:	8b 48 04             	mov    0x4(%eax),%ecx
  8008c3:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8008c6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008c9:	eb 32                	jmp    8008fd <vprintfmt+0x300>
	else if (lflag)
  8008cb:	85 c9                	test   %ecx,%ecx
  8008cd:	74 18                	je     8008e7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8008cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d2:	8d 50 04             	lea    0x4(%eax),%edx
  8008d5:	89 55 14             	mov    %edx,0x14(%ebp)
  8008d8:	8b 00                	mov    (%eax),%eax
  8008da:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008dd:	89 c1                	mov    %eax,%ecx
  8008df:	c1 f9 1f             	sar    $0x1f,%ecx
  8008e2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008e5:	eb 16                	jmp    8008fd <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	8d 50 04             	lea    0x4(%eax),%edx
  8008ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008f5:	89 c2                	mov    %eax,%edx
  8008f7:	c1 fa 1f             	sar    $0x1f,%edx
  8008fa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008fd:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800900:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800903:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800908:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80090c:	0f 89 b8 00 00 00    	jns    8009ca <vprintfmt+0x3cd>
				putch('-', putdat);
  800912:	89 74 24 04          	mov    %esi,0x4(%esp)
  800916:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80091d:	ff d7                	call   *%edi
				num = -(long long) num;
  80091f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800922:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800925:	f7 d9                	neg    %ecx
  800927:	83 d3 00             	adc    $0x0,%ebx
  80092a:	f7 db                	neg    %ebx
  80092c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800931:	e9 94 00 00 00       	jmp    8009ca <vprintfmt+0x3cd>
  800936:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800939:	89 ca                	mov    %ecx,%edx
  80093b:	8d 45 14             	lea    0x14(%ebp),%eax
  80093e:	e8 63 fc ff ff       	call   8005a6 <getuint>
  800943:	89 c1                	mov    %eax,%ecx
  800945:	89 d3                	mov    %edx,%ebx
  800947:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80094c:	eb 7c                	jmp    8009ca <vprintfmt+0x3cd>
  80094e:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800951:	89 74 24 04          	mov    %esi,0x4(%esp)
  800955:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  80095c:	ff d7                	call   *%edi
			putch('X', putdat);
  80095e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800962:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800969:	ff d7                	call   *%edi
			putch('X', putdat);
  80096b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80096f:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800976:	ff d7                	call   *%edi
  800978:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80097b:	e9 a9 fc ff ff       	jmp    800629 <vprintfmt+0x2c>
  800980:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800983:	89 74 24 04          	mov    %esi,0x4(%esp)
  800987:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80098e:	ff d7                	call   *%edi
			putch('x', putdat);
  800990:	89 74 24 04          	mov    %esi,0x4(%esp)
  800994:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80099b:	ff d7                	call   *%edi
			num = (unsigned long long)
  80099d:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a0:	8d 50 04             	lea    0x4(%eax),%edx
  8009a3:	89 55 14             	mov    %edx,0x14(%ebp)
  8009a6:	8b 08                	mov    (%eax),%ecx
  8009a8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009ad:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8009b2:	eb 16                	jmp    8009ca <vprintfmt+0x3cd>
  8009b4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8009b7:	89 ca                	mov    %ecx,%edx
  8009b9:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bc:	e8 e5 fb ff ff       	call   8005a6 <getuint>
  8009c1:	89 c1                	mov    %eax,%ecx
  8009c3:	89 d3                	mov    %edx,%ebx
  8009c5:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009ca:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  8009ce:	89 54 24 10          	mov    %edx,0x10(%esp)
  8009d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009d5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009dd:	89 0c 24             	mov    %ecx,(%esp)
  8009e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8009e4:	89 f2                	mov    %esi,%edx
  8009e6:	89 f8                	mov    %edi,%eax
  8009e8:	e8 c3 fa ff ff       	call   8004b0 <printnum>
  8009ed:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8009f0:	e9 34 fc ff ff       	jmp    800629 <vprintfmt+0x2c>
  8009f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009f8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009fb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009ff:	89 14 24             	mov    %edx,(%esp)
  800a02:	ff d7                	call   *%edi
  800a04:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800a07:	e9 1d fc ff ff       	jmp    800629 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a0c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a10:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800a17:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a19:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800a1c:	80 38 25             	cmpb   $0x25,(%eax)
  800a1f:	0f 84 04 fc ff ff    	je     800629 <vprintfmt+0x2c>
  800a25:	89 c3                	mov    %eax,%ebx
  800a27:	eb f0                	jmp    800a19 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  800a29:	83 c4 5c             	add    $0x5c,%esp
  800a2c:	5b                   	pop    %ebx
  800a2d:	5e                   	pop    %esi
  800a2e:	5f                   	pop    %edi
  800a2f:	5d                   	pop    %ebp
  800a30:	c3                   	ret    

00800a31 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a31:	55                   	push   %ebp
  800a32:	89 e5                	mov    %esp,%ebp
  800a34:	83 ec 28             	sub    $0x28,%esp
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800a3d:	85 c0                	test   %eax,%eax
  800a3f:	74 04                	je     800a45 <vsnprintf+0x14>
  800a41:	85 d2                	test   %edx,%edx
  800a43:	7f 07                	jg     800a4c <vsnprintf+0x1b>
  800a45:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a4a:	eb 3b                	jmp    800a87 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a4c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a4f:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a56:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a60:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a64:	8b 45 10             	mov    0x10(%ebp),%eax
  800a67:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a6b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a72:	c7 04 24 e0 05 80 00 	movl   $0x8005e0,(%esp)
  800a79:	e8 7f fb ff ff       	call   8005fd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a81:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a87:	c9                   	leave  
  800a88:	c3                   	ret    

00800a89 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800a8f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800a92:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a96:	8b 45 10             	mov    0x10(%ebp),%eax
  800a99:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa0:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	89 04 24             	mov    %eax,(%esp)
  800aaa:	e8 82 ff ff ff       	call   800a31 <vsnprintf>
	va_end(ap);

	return rc;
}
  800aaf:	c9                   	leave  
  800ab0:	c3                   	ret    

00800ab1 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800ab7:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800aba:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800abe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ac5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ac8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	89 04 24             	mov    %eax,(%esp)
  800ad2:	e8 26 fb ff ff       	call   8005fd <vprintfmt>
	va_end(ap);
}
  800ad7:	c9                   	leave  
  800ad8:	c3                   	ret    
  800ad9:	00 00                	add    %al,(%eax)
  800adb:	00 00                	add    %al,(%eax)
  800add:	00 00                	add    %al,(%eax)
	...

00800ae0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ae0:	55                   	push   %ebp
  800ae1:	89 e5                	mov    %esp,%ebp
  800ae3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae6:	b8 00 00 00 00       	mov    $0x0,%eax
  800aeb:	80 3a 00             	cmpb   $0x0,(%edx)
  800aee:	74 09                	je     800af9 <strlen+0x19>
		n++;
  800af0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800af3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800af7:	75 f7                	jne    800af0 <strlen+0x10>
		n++;
	return n;
}
  800af9:	5d                   	pop    %ebp
  800afa:	c3                   	ret    

00800afb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800afb:	55                   	push   %ebp
  800afc:	89 e5                	mov    %esp,%ebp
  800afe:	53                   	push   %ebx
  800aff:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b05:	85 c9                	test   %ecx,%ecx
  800b07:	74 19                	je     800b22 <strnlen+0x27>
  800b09:	80 3b 00             	cmpb   $0x0,(%ebx)
  800b0c:	74 14                	je     800b22 <strnlen+0x27>
  800b0e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800b13:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b16:	39 c8                	cmp    %ecx,%eax
  800b18:	74 0d                	je     800b27 <strnlen+0x2c>
  800b1a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800b1e:	75 f3                	jne    800b13 <strnlen+0x18>
  800b20:	eb 05                	jmp    800b27 <strnlen+0x2c>
  800b22:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800b27:	5b                   	pop    %ebx
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	53                   	push   %ebx
  800b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b31:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b34:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b39:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b3d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b40:	83 c2 01             	add    $0x1,%edx
  800b43:	84 c9                	test   %cl,%cl
  800b45:	75 f2                	jne    800b39 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b47:	5b                   	pop    %ebx
  800b48:	5d                   	pop    %ebp
  800b49:	c3                   	ret    

00800b4a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b4a:	55                   	push   %ebp
  800b4b:	89 e5                	mov    %esp,%ebp
  800b4d:	56                   	push   %esi
  800b4e:	53                   	push   %ebx
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b55:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b58:	85 f6                	test   %esi,%esi
  800b5a:	74 18                	je     800b74 <strncpy+0x2a>
  800b5c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800b61:	0f b6 1a             	movzbl (%edx),%ebx
  800b64:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b67:	80 3a 01             	cmpb   $0x1,(%edx)
  800b6a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b6d:	83 c1 01             	add    $0x1,%ecx
  800b70:	39 ce                	cmp    %ecx,%esi
  800b72:	77 ed                	ja     800b61 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b74:	5b                   	pop    %ebx
  800b75:	5e                   	pop    %esi
  800b76:	5d                   	pop    %ebp
  800b77:	c3                   	ret    

00800b78 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b78:	55                   	push   %ebp
  800b79:	89 e5                	mov    %esp,%ebp
  800b7b:	56                   	push   %esi
  800b7c:	53                   	push   %ebx
  800b7d:	8b 75 08             	mov    0x8(%ebp),%esi
  800b80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b83:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b86:	89 f0                	mov    %esi,%eax
  800b88:	85 c9                	test   %ecx,%ecx
  800b8a:	74 27                	je     800bb3 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800b8c:	83 e9 01             	sub    $0x1,%ecx
  800b8f:	74 1d                	je     800bae <strlcpy+0x36>
  800b91:	0f b6 1a             	movzbl (%edx),%ebx
  800b94:	84 db                	test   %bl,%bl
  800b96:	74 16                	je     800bae <strlcpy+0x36>
			*dst++ = *src++;
  800b98:	88 18                	mov    %bl,(%eax)
  800b9a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b9d:	83 e9 01             	sub    $0x1,%ecx
  800ba0:	74 0e                	je     800bb0 <strlcpy+0x38>
			*dst++ = *src++;
  800ba2:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ba5:	0f b6 1a             	movzbl (%edx),%ebx
  800ba8:	84 db                	test   %bl,%bl
  800baa:	75 ec                	jne    800b98 <strlcpy+0x20>
  800bac:	eb 02                	jmp    800bb0 <strlcpy+0x38>
  800bae:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800bb0:	c6 00 00             	movb   $0x0,(%eax)
  800bb3:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800bb5:	5b                   	pop    %ebx
  800bb6:	5e                   	pop    %esi
  800bb7:	5d                   	pop    %ebp
  800bb8:	c3                   	ret    

00800bb9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bb9:	55                   	push   %ebp
  800bba:	89 e5                	mov    %esp,%ebp
  800bbc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bbf:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bc2:	0f b6 01             	movzbl (%ecx),%eax
  800bc5:	84 c0                	test   %al,%al
  800bc7:	74 15                	je     800bde <strcmp+0x25>
  800bc9:	3a 02                	cmp    (%edx),%al
  800bcb:	75 11                	jne    800bde <strcmp+0x25>
		p++, q++;
  800bcd:	83 c1 01             	add    $0x1,%ecx
  800bd0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bd3:	0f b6 01             	movzbl (%ecx),%eax
  800bd6:	84 c0                	test   %al,%al
  800bd8:	74 04                	je     800bde <strcmp+0x25>
  800bda:	3a 02                	cmp    (%edx),%al
  800bdc:	74 ef                	je     800bcd <strcmp+0x14>
  800bde:	0f b6 c0             	movzbl %al,%eax
  800be1:	0f b6 12             	movzbl (%edx),%edx
  800be4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    

00800be8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	53                   	push   %ebx
  800bec:	8b 55 08             	mov    0x8(%ebp),%edx
  800bef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bf2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800bf5:	85 c0                	test   %eax,%eax
  800bf7:	74 23                	je     800c1c <strncmp+0x34>
  800bf9:	0f b6 1a             	movzbl (%edx),%ebx
  800bfc:	84 db                	test   %bl,%bl
  800bfe:	74 24                	je     800c24 <strncmp+0x3c>
  800c00:	3a 19                	cmp    (%ecx),%bl
  800c02:	75 20                	jne    800c24 <strncmp+0x3c>
  800c04:	83 e8 01             	sub    $0x1,%eax
  800c07:	74 13                	je     800c1c <strncmp+0x34>
		n--, p++, q++;
  800c09:	83 c2 01             	add    $0x1,%edx
  800c0c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c0f:	0f b6 1a             	movzbl (%edx),%ebx
  800c12:	84 db                	test   %bl,%bl
  800c14:	74 0e                	je     800c24 <strncmp+0x3c>
  800c16:	3a 19                	cmp    (%ecx),%bl
  800c18:	74 ea                	je     800c04 <strncmp+0x1c>
  800c1a:	eb 08                	jmp    800c24 <strncmp+0x3c>
  800c1c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c21:	5b                   	pop    %ebx
  800c22:	5d                   	pop    %ebp
  800c23:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c24:	0f b6 02             	movzbl (%edx),%eax
  800c27:	0f b6 11             	movzbl (%ecx),%edx
  800c2a:	29 d0                	sub    %edx,%eax
  800c2c:	eb f3                	jmp    800c21 <strncmp+0x39>

00800c2e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c2e:	55                   	push   %ebp
  800c2f:	89 e5                	mov    %esp,%ebp
  800c31:	8b 45 08             	mov    0x8(%ebp),%eax
  800c34:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c38:	0f b6 10             	movzbl (%eax),%edx
  800c3b:	84 d2                	test   %dl,%dl
  800c3d:	74 15                	je     800c54 <strchr+0x26>
		if (*s == c)
  800c3f:	38 ca                	cmp    %cl,%dl
  800c41:	75 07                	jne    800c4a <strchr+0x1c>
  800c43:	eb 14                	jmp    800c59 <strchr+0x2b>
  800c45:	38 ca                	cmp    %cl,%dl
  800c47:	90                   	nop
  800c48:	74 0f                	je     800c59 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c4a:	83 c0 01             	add    $0x1,%eax
  800c4d:	0f b6 10             	movzbl (%eax),%edx
  800c50:	84 d2                	test   %dl,%dl
  800c52:	75 f1                	jne    800c45 <strchr+0x17>
  800c54:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800c59:	5d                   	pop    %ebp
  800c5a:	c3                   	ret    

00800c5b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c5b:	55                   	push   %ebp
  800c5c:	89 e5                	mov    %esp,%ebp
  800c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c61:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c65:	0f b6 10             	movzbl (%eax),%edx
  800c68:	84 d2                	test   %dl,%dl
  800c6a:	74 18                	je     800c84 <strfind+0x29>
		if (*s == c)
  800c6c:	38 ca                	cmp    %cl,%dl
  800c6e:	75 0a                	jne    800c7a <strfind+0x1f>
  800c70:	eb 12                	jmp    800c84 <strfind+0x29>
  800c72:	38 ca                	cmp    %cl,%dl
  800c74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800c78:	74 0a                	je     800c84 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c7a:	83 c0 01             	add    $0x1,%eax
  800c7d:	0f b6 10             	movzbl (%eax),%edx
  800c80:	84 d2                	test   %dl,%dl
  800c82:	75 ee                	jne    800c72 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800c84:	5d                   	pop    %ebp
  800c85:	c3                   	ret    

00800c86 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c86:	55                   	push   %ebp
  800c87:	89 e5                	mov    %esp,%ebp
  800c89:	83 ec 0c             	sub    $0xc,%esp
  800c8c:	89 1c 24             	mov    %ebx,(%esp)
  800c8f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c93:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800c97:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ca0:	85 c9                	test   %ecx,%ecx
  800ca2:	74 30                	je     800cd4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ca4:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800caa:	75 25                	jne    800cd1 <memset+0x4b>
  800cac:	f6 c1 03             	test   $0x3,%cl
  800caf:	75 20                	jne    800cd1 <memset+0x4b>
		c &= 0xFF;
  800cb1:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800cb4:	89 d3                	mov    %edx,%ebx
  800cb6:	c1 e3 08             	shl    $0x8,%ebx
  800cb9:	89 d6                	mov    %edx,%esi
  800cbb:	c1 e6 18             	shl    $0x18,%esi
  800cbe:	89 d0                	mov    %edx,%eax
  800cc0:	c1 e0 10             	shl    $0x10,%eax
  800cc3:	09 f0                	or     %esi,%eax
  800cc5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800cc7:	09 d8                	or     %ebx,%eax
  800cc9:	c1 e9 02             	shr    $0x2,%ecx
  800ccc:	fc                   	cld    
  800ccd:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ccf:	eb 03                	jmp    800cd4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cd1:	fc                   	cld    
  800cd2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cd4:	89 f8                	mov    %edi,%eax
  800cd6:	8b 1c 24             	mov    (%esp),%ebx
  800cd9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cdd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ce1:	89 ec                	mov    %ebp,%esp
  800ce3:	5d                   	pop    %ebp
  800ce4:	c3                   	ret    

00800ce5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ce5:	55                   	push   %ebp
  800ce6:	89 e5                	mov    %esp,%ebp
  800ce8:	83 ec 08             	sub    $0x8,%esp
  800ceb:	89 34 24             	mov    %esi,(%esp)
  800cee:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800cf8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800cfb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800cfd:	39 c6                	cmp    %eax,%esi
  800cff:	73 35                	jae    800d36 <memmove+0x51>
  800d01:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d04:	39 d0                	cmp    %edx,%eax
  800d06:	73 2e                	jae    800d36 <memmove+0x51>
		s += n;
		d += n;
  800d08:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d0a:	f6 c2 03             	test   $0x3,%dl
  800d0d:	75 1b                	jne    800d2a <memmove+0x45>
  800d0f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d15:	75 13                	jne    800d2a <memmove+0x45>
  800d17:	f6 c1 03             	test   $0x3,%cl
  800d1a:	75 0e                	jne    800d2a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800d1c:	83 ef 04             	sub    $0x4,%edi
  800d1f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d22:	c1 e9 02             	shr    $0x2,%ecx
  800d25:	fd                   	std    
  800d26:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d28:	eb 09                	jmp    800d33 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d2a:	83 ef 01             	sub    $0x1,%edi
  800d2d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800d30:	fd                   	std    
  800d31:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d33:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d34:	eb 20                	jmp    800d56 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d36:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d3c:	75 15                	jne    800d53 <memmove+0x6e>
  800d3e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d44:	75 0d                	jne    800d53 <memmove+0x6e>
  800d46:	f6 c1 03             	test   $0x3,%cl
  800d49:	75 08                	jne    800d53 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800d4b:	c1 e9 02             	shr    $0x2,%ecx
  800d4e:	fc                   	cld    
  800d4f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d51:	eb 03                	jmp    800d56 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d53:	fc                   	cld    
  800d54:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d56:	8b 34 24             	mov    (%esp),%esi
  800d59:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800d5d:	89 ec                	mov    %ebp,%esp
  800d5f:	5d                   	pop    %ebp
  800d60:	c3                   	ret    

00800d61 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800d61:	55                   	push   %ebp
  800d62:	89 e5                	mov    %esp,%ebp
  800d64:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d67:	8b 45 10             	mov    0x10(%ebp),%eax
  800d6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d71:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d75:	8b 45 08             	mov    0x8(%ebp),%eax
  800d78:	89 04 24             	mov    %eax,(%esp)
  800d7b:	e8 65 ff ff ff       	call   800ce5 <memmove>
}
  800d80:	c9                   	leave  
  800d81:	c3                   	ret    

00800d82 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
  800d88:	8b 75 08             	mov    0x8(%ebp),%esi
  800d8b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800d8e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d91:	85 c9                	test   %ecx,%ecx
  800d93:	74 36                	je     800dcb <memcmp+0x49>
		if (*s1 != *s2)
  800d95:	0f b6 06             	movzbl (%esi),%eax
  800d98:	0f b6 1f             	movzbl (%edi),%ebx
  800d9b:	38 d8                	cmp    %bl,%al
  800d9d:	74 20                	je     800dbf <memcmp+0x3d>
  800d9f:	eb 14                	jmp    800db5 <memcmp+0x33>
  800da1:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800da6:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800dab:	83 c2 01             	add    $0x1,%edx
  800dae:	83 e9 01             	sub    $0x1,%ecx
  800db1:	38 d8                	cmp    %bl,%al
  800db3:	74 12                	je     800dc7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800db5:	0f b6 c0             	movzbl %al,%eax
  800db8:	0f b6 db             	movzbl %bl,%ebx
  800dbb:	29 d8                	sub    %ebx,%eax
  800dbd:	eb 11                	jmp    800dd0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800dbf:	83 e9 01             	sub    $0x1,%ecx
  800dc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc7:	85 c9                	test   %ecx,%ecx
  800dc9:	75 d6                	jne    800da1 <memcmp+0x1f>
  800dcb:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    

00800dd5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800ddb:	89 c2                	mov    %eax,%edx
  800ddd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800de0:	39 d0                	cmp    %edx,%eax
  800de2:	73 15                	jae    800df9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800de4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800de8:	38 08                	cmp    %cl,(%eax)
  800dea:	75 06                	jne    800df2 <memfind+0x1d>
  800dec:	eb 0b                	jmp    800df9 <memfind+0x24>
  800dee:	38 08                	cmp    %cl,(%eax)
  800df0:	74 07                	je     800df9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800df2:	83 c0 01             	add    $0x1,%eax
  800df5:	39 c2                	cmp    %eax,%edx
  800df7:	77 f5                	ja     800dee <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800df9:	5d                   	pop    %ebp
  800dfa:	c3                   	ret    

00800dfb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800dfb:	55                   	push   %ebp
  800dfc:	89 e5                	mov    %esp,%ebp
  800dfe:	57                   	push   %edi
  800dff:	56                   	push   %esi
  800e00:	53                   	push   %ebx
  800e01:	83 ec 04             	sub    $0x4,%esp
  800e04:	8b 55 08             	mov    0x8(%ebp),%edx
  800e07:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e0a:	0f b6 02             	movzbl (%edx),%eax
  800e0d:	3c 20                	cmp    $0x20,%al
  800e0f:	74 04                	je     800e15 <strtol+0x1a>
  800e11:	3c 09                	cmp    $0x9,%al
  800e13:	75 0e                	jne    800e23 <strtol+0x28>
		s++;
  800e15:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e18:	0f b6 02             	movzbl (%edx),%eax
  800e1b:	3c 20                	cmp    $0x20,%al
  800e1d:	74 f6                	je     800e15 <strtol+0x1a>
  800e1f:	3c 09                	cmp    $0x9,%al
  800e21:	74 f2                	je     800e15 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e23:	3c 2b                	cmp    $0x2b,%al
  800e25:	75 0c                	jne    800e33 <strtol+0x38>
		s++;
  800e27:	83 c2 01             	add    $0x1,%edx
  800e2a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e31:	eb 15                	jmp    800e48 <strtol+0x4d>
	else if (*s == '-')
  800e33:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e3a:	3c 2d                	cmp    $0x2d,%al
  800e3c:	75 0a                	jne    800e48 <strtol+0x4d>
		s++, neg = 1;
  800e3e:	83 c2 01             	add    $0x1,%edx
  800e41:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e48:	85 db                	test   %ebx,%ebx
  800e4a:	0f 94 c0             	sete   %al
  800e4d:	74 05                	je     800e54 <strtol+0x59>
  800e4f:	83 fb 10             	cmp    $0x10,%ebx
  800e52:	75 18                	jne    800e6c <strtol+0x71>
  800e54:	80 3a 30             	cmpb   $0x30,(%edx)
  800e57:	75 13                	jne    800e6c <strtol+0x71>
  800e59:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e5d:	8d 76 00             	lea    0x0(%esi),%esi
  800e60:	75 0a                	jne    800e6c <strtol+0x71>
		s += 2, base = 16;
  800e62:	83 c2 02             	add    $0x2,%edx
  800e65:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e6a:	eb 15                	jmp    800e81 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e6c:	84 c0                	test   %al,%al
  800e6e:	66 90                	xchg   %ax,%ax
  800e70:	74 0f                	je     800e81 <strtol+0x86>
  800e72:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800e77:	80 3a 30             	cmpb   $0x30,(%edx)
  800e7a:	75 05                	jne    800e81 <strtol+0x86>
		s++, base = 8;
  800e7c:	83 c2 01             	add    $0x1,%edx
  800e7f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e81:	b8 00 00 00 00       	mov    $0x0,%eax
  800e86:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e88:	0f b6 0a             	movzbl (%edx),%ecx
  800e8b:	89 cf                	mov    %ecx,%edi
  800e8d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800e90:	80 fb 09             	cmp    $0x9,%bl
  800e93:	77 08                	ja     800e9d <strtol+0xa2>
			dig = *s - '0';
  800e95:	0f be c9             	movsbl %cl,%ecx
  800e98:	83 e9 30             	sub    $0x30,%ecx
  800e9b:	eb 1e                	jmp    800ebb <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800e9d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800ea0:	80 fb 19             	cmp    $0x19,%bl
  800ea3:	77 08                	ja     800ead <strtol+0xb2>
			dig = *s - 'a' + 10;
  800ea5:	0f be c9             	movsbl %cl,%ecx
  800ea8:	83 e9 57             	sub    $0x57,%ecx
  800eab:	eb 0e                	jmp    800ebb <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800ead:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800eb0:	80 fb 19             	cmp    $0x19,%bl
  800eb3:	77 15                	ja     800eca <strtol+0xcf>
			dig = *s - 'A' + 10;
  800eb5:	0f be c9             	movsbl %cl,%ecx
  800eb8:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800ebb:	39 f1                	cmp    %esi,%ecx
  800ebd:	7d 0b                	jge    800eca <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800ebf:	83 c2 01             	add    $0x1,%edx
  800ec2:	0f af c6             	imul   %esi,%eax
  800ec5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800ec8:	eb be                	jmp    800e88 <strtol+0x8d>
  800eca:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800ecc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ed0:	74 05                	je     800ed7 <strtol+0xdc>
		*endptr = (char *) s;
  800ed2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ed5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800ed7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800edb:	74 04                	je     800ee1 <strtol+0xe6>
  800edd:	89 c8                	mov    %ecx,%eax
  800edf:	f7 d8                	neg    %eax
}
  800ee1:	83 c4 04             	add    $0x4,%esp
  800ee4:	5b                   	pop    %ebx
  800ee5:	5e                   	pop    %esi
  800ee6:	5f                   	pop    %edi
  800ee7:	5d                   	pop    %ebp
  800ee8:	c3                   	ret    
  800ee9:	00 00                	add    %al,(%eax)
	...

00800eec <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800eec:	55                   	push   %ebp
  800eed:	89 e5                	mov    %esp,%ebp
  800eef:	83 ec 0c             	sub    $0xc,%esp
  800ef2:	89 1c 24             	mov    %ebx,(%esp)
  800ef5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ef9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800efd:	ba 00 00 00 00       	mov    $0x0,%edx
  800f02:	b8 01 00 00 00       	mov    $0x1,%eax
  800f07:	89 d1                	mov    %edx,%ecx
  800f09:	89 d3                	mov    %edx,%ebx
  800f0b:	89 d7                	mov    %edx,%edi
  800f0d:	89 d6                	mov    %edx,%esi
  800f0f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f11:	8b 1c 24             	mov    (%esp),%ebx
  800f14:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f18:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f1c:	89 ec                	mov    %ebp,%esp
  800f1e:	5d                   	pop    %ebp
  800f1f:	c3                   	ret    

00800f20 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 0c             	sub    $0xc,%esp
  800f26:	89 1c 24             	mov    %ebx,(%esp)
  800f29:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f2d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f31:	b8 00 00 00 00       	mov    $0x0,%eax
  800f36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f39:	8b 55 08             	mov    0x8(%ebp),%edx
  800f3c:	89 c3                	mov    %eax,%ebx
  800f3e:	89 c7                	mov    %eax,%edi
  800f40:	89 c6                	mov    %eax,%esi
  800f42:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f44:	8b 1c 24             	mov    (%esp),%ebx
  800f47:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f4b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f4f:	89 ec                	mov    %ebp,%esp
  800f51:	5d                   	pop    %ebp
  800f52:	c3                   	ret    

00800f53 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 0c             	sub    $0xc,%esp
  800f59:	89 1c 24             	mov    %ebx,(%esp)
  800f5c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f60:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f64:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f69:	b8 10 00 00 00       	mov    $0x10,%eax
  800f6e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f71:	8b 55 08             	mov    0x8(%ebp),%edx
  800f74:	89 df                	mov    %ebx,%edi
  800f76:	89 de                	mov    %ebx,%esi
  800f78:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800f7a:	8b 1c 24             	mov    (%esp),%ebx
  800f7d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f81:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f85:	89 ec                	mov    %ebp,%esp
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    

00800f89 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  800f89:	55                   	push   %ebp
  800f8a:	89 e5                	mov    %esp,%ebp
  800f8c:	83 ec 38             	sub    $0x38,%esp
  800f8f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f92:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f95:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f98:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f9d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fa2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fa5:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa8:	89 df                	mov    %ebx,%edi
  800faa:	89 de                	mov    %ebx,%esi
  800fac:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800fae:	85 c0                	test   %eax,%eax
  800fb0:	7e 28                	jle    800fda <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800fb2:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fb6:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800fbd:	00 
  800fbe:	c7 44 24 08 df 33 80 	movl   $0x8033df,0x8(%esp)
  800fc5:	00 
  800fc6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fcd:	00 
  800fce:	c7 04 24 fc 33 80 00 	movl   $0x8033fc,(%esp)
  800fd5:	e8 aa f3 ff ff       	call   800384 <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800fda:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fdd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fe0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fe3:	89 ec                	mov    %ebp,%esp
  800fe5:	5d                   	pop    %ebp
  800fe6:	c3                   	ret    

00800fe7 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800fe7:	55                   	push   %ebp
  800fe8:	89 e5                	mov    %esp,%ebp
  800fea:	83 ec 0c             	sub    $0xc,%esp
  800fed:	89 1c 24             	mov    %ebx,(%esp)
  800ff0:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ff4:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ffd:	b8 0e 00 00 00       	mov    $0xe,%eax
  801002:	89 d1                	mov    %edx,%ecx
  801004:	89 d3                	mov    %edx,%ebx
  801006:	89 d7                	mov    %edx,%edi
  801008:	89 d6                	mov    %edx,%esi
  80100a:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80100c:	8b 1c 24             	mov    (%esp),%ebx
  80100f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801013:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801017:	89 ec                	mov    %ebp,%esp
  801019:	5d                   	pop    %ebp
  80101a:	c3                   	ret    

0080101b <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	83 ec 38             	sub    $0x38,%esp
  801021:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801024:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801027:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80102a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80102f:	b8 0d 00 00 00       	mov    $0xd,%eax
  801034:	8b 55 08             	mov    0x8(%ebp),%edx
  801037:	89 cb                	mov    %ecx,%ebx
  801039:	89 cf                	mov    %ecx,%edi
  80103b:	89 ce                	mov    %ecx,%esi
  80103d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80103f:	85 c0                	test   %eax,%eax
  801041:	7e 28                	jle    80106b <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801043:	89 44 24 10          	mov    %eax,0x10(%esp)
  801047:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80104e:	00 
  80104f:	c7 44 24 08 df 33 80 	movl   $0x8033df,0x8(%esp)
  801056:	00 
  801057:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80105e:	00 
  80105f:	c7 04 24 fc 33 80 00 	movl   $0x8033fc,(%esp)
  801066:	e8 19 f3 ff ff       	call   800384 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80106b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80106e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801071:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801074:	89 ec                	mov    %ebp,%esp
  801076:	5d                   	pop    %ebp
  801077:	c3                   	ret    

00801078 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	83 ec 0c             	sub    $0xc,%esp
  80107e:	89 1c 24             	mov    %ebx,(%esp)
  801081:	89 74 24 04          	mov    %esi,0x4(%esp)
  801085:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801089:	be 00 00 00 00       	mov    $0x0,%esi
  80108e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801093:	8b 7d 14             	mov    0x14(%ebp),%edi
  801096:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801099:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80109c:	8b 55 08             	mov    0x8(%ebp),%edx
  80109f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010a1:	8b 1c 24             	mov    (%esp),%ebx
  8010a4:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010a8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010ac:	89 ec                	mov    %ebp,%esp
  8010ae:	5d                   	pop    %ebp
  8010af:	c3                   	ret    

008010b0 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8010b0:	55                   	push   %ebp
  8010b1:	89 e5                	mov    %esp,%ebp
  8010b3:	83 ec 38             	sub    $0x38,%esp
  8010b6:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010b9:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010bc:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010c4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8010cf:	89 df                	mov    %ebx,%edi
  8010d1:	89 de                	mov    %ebx,%esi
  8010d3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010d5:	85 c0                	test   %eax,%eax
  8010d7:	7e 28                	jle    801101 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010d9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010dd:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8010e4:	00 
  8010e5:	c7 44 24 08 df 33 80 	movl   $0x8033df,0x8(%esp)
  8010ec:	00 
  8010ed:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010f4:	00 
  8010f5:	c7 04 24 fc 33 80 00 	movl   $0x8033fc,(%esp)
  8010fc:	e8 83 f2 ff ff       	call   800384 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801101:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801104:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801107:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80110a:	89 ec                	mov    %ebp,%esp
  80110c:	5d                   	pop    %ebp
  80110d:	c3                   	ret    

0080110e <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80110e:	55                   	push   %ebp
  80110f:	89 e5                	mov    %esp,%ebp
  801111:	83 ec 38             	sub    $0x38,%esp
  801114:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801117:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80111a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80111d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801122:	b8 09 00 00 00       	mov    $0x9,%eax
  801127:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80112a:	8b 55 08             	mov    0x8(%ebp),%edx
  80112d:	89 df                	mov    %ebx,%edi
  80112f:	89 de                	mov    %ebx,%esi
  801131:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801133:	85 c0                	test   %eax,%eax
  801135:	7e 28                	jle    80115f <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801137:	89 44 24 10          	mov    %eax,0x10(%esp)
  80113b:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801142:	00 
  801143:	c7 44 24 08 df 33 80 	movl   $0x8033df,0x8(%esp)
  80114a:	00 
  80114b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801152:	00 
  801153:	c7 04 24 fc 33 80 00 	movl   $0x8033fc,(%esp)
  80115a:	e8 25 f2 ff ff       	call   800384 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80115f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801162:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801165:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801168:	89 ec                	mov    %ebp,%esp
  80116a:	5d                   	pop    %ebp
  80116b:	c3                   	ret    

0080116c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 38             	sub    $0x38,%esp
  801172:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801175:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801178:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80117b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801180:	b8 08 00 00 00       	mov    $0x8,%eax
  801185:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801188:	8b 55 08             	mov    0x8(%ebp),%edx
  80118b:	89 df                	mov    %ebx,%edi
  80118d:	89 de                	mov    %ebx,%esi
  80118f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801191:	85 c0                	test   %eax,%eax
  801193:	7e 28                	jle    8011bd <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801195:	89 44 24 10          	mov    %eax,0x10(%esp)
  801199:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  8011a0:	00 
  8011a1:	c7 44 24 08 df 33 80 	movl   $0x8033df,0x8(%esp)
  8011a8:	00 
  8011a9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011b0:	00 
  8011b1:	c7 04 24 fc 33 80 00 	movl   $0x8033fc,(%esp)
  8011b8:	e8 c7 f1 ff ff       	call   800384 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011bd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011c0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011c3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011c6:	89 ec                	mov    %ebp,%esp
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    

008011ca <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	83 ec 38             	sub    $0x38,%esp
  8011d0:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011d3:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011d6:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011de:	b8 06 00 00 00       	mov    $0x6,%eax
  8011e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e9:	89 df                	mov    %ebx,%edi
  8011eb:	89 de                	mov    %ebx,%esi
  8011ed:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	7e 28                	jle    80121b <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011f3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011f7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8011fe:	00 
  8011ff:	c7 44 24 08 df 33 80 	movl   $0x8033df,0x8(%esp)
  801206:	00 
  801207:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80120e:	00 
  80120f:	c7 04 24 fc 33 80 00 	movl   $0x8033fc,(%esp)
  801216:	e8 69 f1 ff ff       	call   800384 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80121b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80121e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801221:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801224:	89 ec                	mov    %ebp,%esp
  801226:	5d                   	pop    %ebp
  801227:	c3                   	ret    

00801228 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	83 ec 38             	sub    $0x38,%esp
  80122e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801231:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801234:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801237:	b8 05 00 00 00       	mov    $0x5,%eax
  80123c:	8b 75 18             	mov    0x18(%ebp),%esi
  80123f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801242:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801245:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801248:	8b 55 08             	mov    0x8(%ebp),%edx
  80124b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80124d:	85 c0                	test   %eax,%eax
  80124f:	7e 28                	jle    801279 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801251:	89 44 24 10          	mov    %eax,0x10(%esp)
  801255:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80125c:	00 
  80125d:	c7 44 24 08 df 33 80 	movl   $0x8033df,0x8(%esp)
  801264:	00 
  801265:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80126c:	00 
  80126d:	c7 04 24 fc 33 80 00 	movl   $0x8033fc,(%esp)
  801274:	e8 0b f1 ff ff       	call   800384 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801279:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80127c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80127f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801282:	89 ec                	mov    %ebp,%esp
  801284:	5d                   	pop    %ebp
  801285:	c3                   	ret    

00801286 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801286:	55                   	push   %ebp
  801287:	89 e5                	mov    %esp,%ebp
  801289:	83 ec 38             	sub    $0x38,%esp
  80128c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80128f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801292:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801295:	be 00 00 00 00       	mov    $0x0,%esi
  80129a:	b8 04 00 00 00       	mov    $0x4,%eax
  80129f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a8:	89 f7                	mov    %esi,%edi
  8012aa:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8012ac:	85 c0                	test   %eax,%eax
  8012ae:	7e 28                	jle    8012d8 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012b0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012b4:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  8012bb:	00 
  8012bc:	c7 44 24 08 df 33 80 	movl   $0x8033df,0x8(%esp)
  8012c3:	00 
  8012c4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012cb:	00 
  8012cc:	c7 04 24 fc 33 80 00 	movl   $0x8033fc,(%esp)
  8012d3:	e8 ac f0 ff ff       	call   800384 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8012d8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012db:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012de:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012e1:	89 ec                	mov    %ebp,%esp
  8012e3:	5d                   	pop    %ebp
  8012e4:	c3                   	ret    

008012e5 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8012e5:	55                   	push   %ebp
  8012e6:	89 e5                	mov    %esp,%ebp
  8012e8:	83 ec 0c             	sub    $0xc,%esp
  8012eb:	89 1c 24             	mov    %ebx,(%esp)
  8012ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012f2:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8012fb:	b8 0b 00 00 00       	mov    $0xb,%eax
  801300:	89 d1                	mov    %edx,%ecx
  801302:	89 d3                	mov    %edx,%ebx
  801304:	89 d7                	mov    %edx,%edi
  801306:	89 d6                	mov    %edx,%esi
  801308:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80130a:	8b 1c 24             	mov    (%esp),%ebx
  80130d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801311:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801315:	89 ec                	mov    %ebp,%esp
  801317:	5d                   	pop    %ebp
  801318:	c3                   	ret    

00801319 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	83 ec 0c             	sub    $0xc,%esp
  80131f:	89 1c 24             	mov    %ebx,(%esp)
  801322:	89 74 24 04          	mov    %esi,0x4(%esp)
  801326:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80132a:	ba 00 00 00 00       	mov    $0x0,%edx
  80132f:	b8 02 00 00 00       	mov    $0x2,%eax
  801334:	89 d1                	mov    %edx,%ecx
  801336:	89 d3                	mov    %edx,%ebx
  801338:	89 d7                	mov    %edx,%edi
  80133a:	89 d6                	mov    %edx,%esi
  80133c:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80133e:	8b 1c 24             	mov    (%esp),%ebx
  801341:	8b 74 24 04          	mov    0x4(%esp),%esi
  801345:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801349:	89 ec                	mov    %ebp,%esp
  80134b:	5d                   	pop    %ebp
  80134c:	c3                   	ret    

0080134d <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  80134d:	55                   	push   %ebp
  80134e:	89 e5                	mov    %esp,%ebp
  801350:	83 ec 38             	sub    $0x38,%esp
  801353:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801356:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801359:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80135c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801361:	b8 03 00 00 00       	mov    $0x3,%eax
  801366:	8b 55 08             	mov    0x8(%ebp),%edx
  801369:	89 cb                	mov    %ecx,%ebx
  80136b:	89 cf                	mov    %ecx,%edi
  80136d:	89 ce                	mov    %ecx,%esi
  80136f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801371:	85 c0                	test   %eax,%eax
  801373:	7e 28                	jle    80139d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801375:	89 44 24 10          	mov    %eax,0x10(%esp)
  801379:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801380:	00 
  801381:	c7 44 24 08 df 33 80 	movl   $0x8033df,0x8(%esp)
  801388:	00 
  801389:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801390:	00 
  801391:	c7 04 24 fc 33 80 00 	movl   $0x8033fc,(%esp)
  801398:	e8 e7 ef ff ff       	call   800384 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80139d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013a0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013a3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013a6:	89 ec                	mov    %ebp,%esp
  8013a8:	5d                   	pop    %ebp
  8013a9:	c3                   	ret    
	...

008013ac <sfork>:
}

// Challenge!
int
sfork(void)
{
  8013ac:	55                   	push   %ebp
  8013ad:	89 e5                	mov    %esp,%ebp
  8013af:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  8013b2:	c7 44 24 08 0a 34 80 	movl   $0x80340a,0x8(%esp)
  8013b9:	00 
  8013ba:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  8013c1:	00 
  8013c2:	c7 04 24 20 34 80 00 	movl   $0x803420,(%esp)
  8013c9:	e8 b6 ef ff ff       	call   800384 <_panic>

008013ce <duppage>:
// It is also OK to panic on error.
// 

static int
duppage(envid_t envid, unsigned pn)
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 28             	sub    $0x28,%esp
  8013d4:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8013d7:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8013da:	89 c3                	mov    %eax,%ebx
	int r;

	// LAB 4: Your code here.
     pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  8013dc:	89 d6                	mov    %edx,%esi
  8013de:	c1 e6 0c             	shl    $0xc,%esi
  8013e1:	89 f0                	mov    %esi,%eax
  8013e3:	c1 e8 16             	shr    $0x16,%eax
  8013e6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
       
        if( 0 == pgDirEntry )
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	0f 84 fc 00 00 00    	je     8014f1 <duppage+0x123>
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  8013f5:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8013fc:	89 c2                	mov    %eax,%edx
  8013fe:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        //cprintf("Below %d",vpt[pn]);
                //if(perm!=0)  //commented nw.
                   // cprintf("perm bit %d",perm);
	
	
	if((perm & PTE_W) && (perm & PTE_SHARE))
  801404:	25 02 04 00 00       	and    $0x402,%eax
  801409:	3d 02 04 00 00       	cmp    $0x402,%eax
  80140e:	75 4d                	jne    80145d <duppage+0x8f>
	{	
		if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_SHARE|(perm & PTE_USER))) < 0)
  801410:	81 e2 07 0a 00 00    	and    $0xa07,%edx
  801416:	80 ce 04             	or     $0x4,%dh
  801419:	89 54 24 10          	mov    %edx,0x10(%esp)
  80141d:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801421:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801425:	89 74 24 04          	mov    %esi,0x4(%esp)
  801429:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801430:	e8 f3 fd ff ff       	call   801228 <sys_page_map>
  801435:	85 c0                	test   %eax,%eax
  801437:	0f 89 bb 00 00 00    	jns    8014f8 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  80143d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801441:	c7 44 24 08 2b 34 80 	movl   $0x80342b,0x8(%esp)
  801448:	00 
  801449:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  801450:	00 
  801451:	c7 04 24 20 34 80 00 	movl   $0x803420,(%esp)
  801458:	e8 27 ef ff ff       	call   800384 <_panic>
	}	


        else if((perm & PTE_W)!=0 || (perm & PTE_COW)!=0)
  80145d:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801463:	0f 84 8f 00 00 00    	je     8014f8 <duppage+0x12a>
         {
          //cprintf("\nInside Setting Cow\n"); 
        if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  801469:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801470:	00 
  801471:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801475:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801479:	89 74 24 04          	mov    %esi,0x4(%esp)
  80147d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801484:	e8 9f fd ff ff       	call   801228 <sys_page_map>
  801489:	85 c0                	test   %eax,%eax
  80148b:	79 20                	jns    8014ad <duppage+0xdf>
                panic("sys_page_map: %e", r);
  80148d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801491:	c7 44 24 08 2b 34 80 	movl   $0x80342b,0x8(%esp)
  801498:	00 
  801499:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  8014a0:	00 
  8014a1:	c7 04 24 20 34 80 00 	movl   $0x803420,(%esp)
  8014a8:	e8 d7 ee ff ff       	call   800384 <_panic>
        if ((r = sys_page_map(envid,(void *)(pn*PGSIZE),0,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  8014ad:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  8014b4:	00 
  8014b5:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8014b9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014c0:	00 
  8014c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014c5:	89 1c 24             	mov    %ebx,(%esp)
  8014c8:	e8 5b fd ff ff       	call   801228 <sys_page_map>
  8014cd:	85 c0                	test   %eax,%eax
  8014cf:	79 27                	jns    8014f8 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  8014d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014d5:	c7 44 24 08 2b 34 80 	movl   $0x80342b,0x8(%esp)
  8014dc:	00 
  8014dd:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8014e4:	00 
  8014e5:	c7 04 24 20 34 80 00 	movl   $0x803420,(%esp)
  8014ec:	e8 93 ee ff ff       	call   800384 <_panic>
  8014f1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8014f6:	eb 05                	jmp    8014fd <duppage+0x12f>
  8014f8:	b8 00 00 00 00       	mov    $0x0,%eax
         }


//	panic("duppage not implemented");
	return 0;
}
  8014fd:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801500:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801503:	89 ec                	mov    %ebp,%esp
  801505:	5d                   	pop    %ebp
  801506:	c3                   	ret    

00801507 <fork>:
//


envid_t
fork(void)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	56                   	push   %esi
  80150b:	53                   	push   %ebx
  80150c:	83 ec 10             	sub    $0x10,%esp

        envid_t envid;
        uint8_t *addr;
        int r;
        extern unsigned char end[];
        set_pgfault_handler(pgfault);
  80150f:	c7 04 24 1e 16 80 00 	movl   $0x80161e,(%esp)
  801516:	e8 21 16 00 00       	call   802b3c <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  80151b:	be 07 00 00 00       	mov    $0x7,%esi
  801520:	89 f0                	mov    %esi,%eax
  801522:	cd 30                	int    $0x30
  801524:	89 c6                	mov    %eax,%esi

        envid = sys_exofork();
        if (envid < 0)
  801526:	85 c0                	test   %eax,%eax
  801528:	79 20                	jns    80154a <fork+0x43>
                panic("sys_exofork: %e", envid);
  80152a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80152e:	c7 44 24 08 3c 34 80 	movl   $0x80343c,0x8(%esp)
  801535:	00 
  801536:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  80153d:	00 
  80153e:	c7 04 24 20 34 80 00 	movl   $0x803420,(%esp)
  801545:	e8 3a ee ff ff       	call   800384 <_panic>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
  80154a:	bb 00 00 80 00       	mov    $0x800000,%ebx
        set_pgfault_handler(pgfault);

        envid = sys_exofork();
        if (envid < 0)
                panic("sys_exofork: %e", envid);
        if (envid == 0) {
  80154f:	85 c0                	test   %eax,%eax
  801551:	75 1c                	jne    80156f <fork+0x68>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
  801553:	e8 c1 fd ff ff       	call   801319 <sys_getenvid>
  801558:	25 ff 03 00 00       	and    $0x3ff,%eax
  80155d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801560:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801565:	a3 78 70 80 00       	mov    %eax,0x807078
                return 0;
  80156a:	e9 a6 00 00 00       	jmp    801615 <fork+0x10e>
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
  80156f:	89 da                	mov    %ebx,%edx
  801571:	c1 ea 0c             	shr    $0xc,%edx
  801574:	89 f0                	mov    %esi,%eax
  801576:	e8 53 fe ff ff       	call   8013ce <duppage>
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
  80157b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801581:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801587:	75 e6                	jne    80156f <fork+0x68>
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
                }
              duppage(envid,VPN(USTACKTOP-PGSIZE));
  801589:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80158e:	89 f0                	mov    %esi,%eax
  801590:	e8 39 fe ff ff       	call   8013ce <duppage>
        // Also copy the stack we are currently running on.
       //if(sys_page_alloc(envid, (void *)(ROUNDDOWN(&addr, PGSIZE)),PTE_U|PTE_P|PTE_W)<0)
         //                      panic("stack not allocated");
     
   
     sys_env_set_pgfault_upcall(envid,env->env_pgfault_upcall);
  801595:	a1 78 70 80 00       	mov    0x807078,%eax
  80159a:	8b 40 64             	mov    0x64(%eax),%eax
  80159d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015a1:	89 34 24             	mov    %esi,(%esp)
  8015a4:	e8 07 fb ff ff       	call   8010b0 <sys_env_set_pgfault_upcall>

     if(sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  8015a9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8015b0:	00 
  8015b1:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  8015b8:	ee 
  8015b9:	89 34 24             	mov    %esi,(%esp)
  8015bc:	e8 c5 fc ff ff       	call   801286 <sys_page_alloc>
  8015c1:	85 c0                	test   %eax,%eax
  8015c3:	79 1c                	jns    8015e1 <fork+0xda>
                          panic("Cant allocate Page");
  8015c5:	c7 44 24 08 4c 34 80 	movl   $0x80344c,0x8(%esp)
  8015cc:	00 
  8015cd:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  8015d4:	00 
  8015d5:	c7 04 24 20 34 80 00 	movl   $0x803420,(%esp)
  8015dc:	e8 a3 ed ff ff       	call   800384 <_panic>

        // Start the child environment running
        if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8015e1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015e8:	00 
  8015e9:	89 34 24             	mov    %esi,(%esp)
  8015ec:	e8 7b fb ff ff       	call   80116c <sys_env_set_status>
  8015f1:	85 c0                	test   %eax,%eax
  8015f3:	79 20                	jns    801615 <fork+0x10e>
                panic("sys_env_set_status: %e", r);
  8015f5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015f9:	c7 44 24 08 5f 34 80 	movl   $0x80345f,0x8(%esp)
  801600:	00 
  801601:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  801608:	00 
  801609:	c7 04 24 20 34 80 00 	movl   $0x803420,(%esp)
  801610:	e8 6f ed ff ff       	call   800384 <_panic>
         return envid;
           
//panic("fork not implemented");
}
  801615:	89 f0                	mov    %esi,%eax
  801617:	83 c4 10             	add    $0x10,%esp
  80161a:	5b                   	pop    %ebx
  80161b:	5e                   	pop    %esi
  80161c:	5d                   	pop    %ebp
  80161d:	c3                   	ret    

0080161e <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  80161e:	55                   	push   %ebp
  80161f:	89 e5                	mov    %esp,%ebp
  801621:	53                   	push   %ebx
  801622:	83 ec 24             	sub    $0x24,%esp
  801625:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801628:	8b 18                	mov    (%eax),%ebx
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).
 
         int perm = vpt[VPN(addr)] & 0xFFF;
  80162a:	89 da                	mov    %ebx,%edx
  80162c:	c1 ea 0c             	shr    $0xc,%edx
  80162f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx

static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
  801636:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80163a:	74 21                	je     80165d <pgfault+0x3f>
 
         int perm = vpt[VPN(addr)] & 0xFFF;
        if((err & FEC_WR)!=0)
           {
//              cprintf("\n>>>>>Due to write\n");
            if((perm & PTE_COW) == 0)
  80163c:	f6 c6 08             	test   $0x8,%dh
  80163f:	75 1c                	jne    80165d <pgfault+0x3f>
             {
                   panic("Not Set Cow");
  801641:	c7 44 24 08 76 34 80 	movl   $0x803476,0x8(%esp)
  801648:	00 
  801649:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801650:	00 
  801651:	c7 04 24 20 34 80 00 	movl   $0x803420,(%esp)
  801658:	e8 27 ed ff ff       	call   800384 <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
        if(sys_page_alloc(0,PFTEMP,PTE_P|PTE_U|PTE_W)<0)
  80165d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801664:	00 
  801665:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80166c:	00 
  80166d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801674:	e8 0d fc ff ff       	call   801286 <sys_page_alloc>
  801679:	85 c0                	test   %eax,%eax
  80167b:	79 1c                	jns    801699 <pgfault+0x7b>
              panic("\nPage not allocated\n");
  80167d:	c7 44 24 08 82 34 80 	movl   $0x803482,0x8(%esp)
  801684:	00 
  801685:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  80168c:	00 
  80168d:	c7 04 24 20 34 80 00 	movl   $0x803420,(%esp)
  801694:	e8 eb ec ff ff       	call   800384 <_panic>
           memmove(PFTEMP,ROUNDDOWN(addr,PGSIZE),PGSIZE);
  801699:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80169f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8016a6:	00 
  8016a7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8016ab:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  8016b2:	e8 2e f6 ff ff       	call   800ce5 <memmove>
          if(sys_page_map(0,ROUNDDOWN(PFTEMP,PGSIZE),0,ROUNDDOWN(addr,PGSIZE),PTE_U|PTE_P|PTE_W)<0)
  8016b7:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  8016be:	00 
  8016bf:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8016c3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016ca:	00 
  8016cb:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8016d2:	00 
  8016d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016da:	e8 49 fb ff ff       	call   801228 <sys_page_map>
  8016df:	85 c0                	test   %eax,%eax
  8016e1:	79 1c                	jns    8016ff <pgfault+0xe1>
                   panic("not mapped properly");
  8016e3:	c7 44 24 08 97 34 80 	movl   $0x803497,0x8(%esp)
  8016ea:	00 
  8016eb:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8016f2:	00 
  8016f3:	c7 04 24 20 34 80 00 	movl   $0x803420,(%esp)
  8016fa:	e8 85 ec ff ff       	call   800384 <_panic>
         if( 0 > sys_page_unmap(0, PFTEMP) )
  8016ff:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801706:	00 
  801707:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80170e:	e8 b7 fa ff ff       	call   8011ca <sys_page_unmap>
  801713:	85 c0                	test   %eax,%eax
  801715:	79 1c                	jns    801733 <pgfault+0x115>
                panic("sys_page_unmap failed\n");
  801717:	c7 44 24 08 ab 34 80 	movl   $0x8034ab,0x8(%esp)
  80171e:	00 
  80171f:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  801726:	00 
  801727:	c7 04 24 20 34 80 00 	movl   $0x803420,(%esp)
  80172e:	e8 51 ec ff ff       	call   800384 <_panic>
   
//	panic("pgfault not implemented");
}
  801733:	83 c4 24             	add    $0x24,%esp
  801736:	5b                   	pop    %ebx
  801737:	5d                   	pop    %ebp
  801738:	c3                   	ret    
  801739:	00 00                	add    %al,(%eax)
  80173b:	00 00                	add    %al,(%eax)
  80173d:	00 00                	add    %al,(%eax)
	...

00801740 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801740:	55                   	push   %ebp
  801741:	89 e5                	mov    %esp,%ebp
  801743:	8b 45 08             	mov    0x8(%ebp),%eax
  801746:	05 00 00 00 30       	add    $0x30000000,%eax
  80174b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80174e:	5d                   	pop    %ebp
  80174f:	c3                   	ret    

00801750 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801756:	8b 45 08             	mov    0x8(%ebp),%eax
  801759:	89 04 24             	mov    %eax,(%esp)
  80175c:	e8 df ff ff ff       	call   801740 <fd2num>
  801761:	05 20 00 0d 00       	add    $0xd0020,%eax
  801766:	c1 e0 0c             	shl    $0xc,%eax
}
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	57                   	push   %edi
  80176f:	56                   	push   %esi
  801770:	53                   	push   %ebx
  801771:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801774:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801779:	a8 01                	test   $0x1,%al
  80177b:	74 36                	je     8017b3 <fd_alloc+0x48>
  80177d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801782:	a8 01                	test   $0x1,%al
  801784:	74 2d                	je     8017b3 <fd_alloc+0x48>
  801786:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80178b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801790:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801795:	89 c3                	mov    %eax,%ebx
  801797:	89 c2                	mov    %eax,%edx
  801799:	c1 ea 16             	shr    $0x16,%edx
  80179c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80179f:	f6 c2 01             	test   $0x1,%dl
  8017a2:	74 14                	je     8017b8 <fd_alloc+0x4d>
  8017a4:	89 c2                	mov    %eax,%edx
  8017a6:	c1 ea 0c             	shr    $0xc,%edx
  8017a9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  8017ac:	f6 c2 01             	test   $0x1,%dl
  8017af:	75 10                	jne    8017c1 <fd_alloc+0x56>
  8017b1:	eb 05                	jmp    8017b8 <fd_alloc+0x4d>
  8017b3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  8017b8:	89 1f                	mov    %ebx,(%edi)
  8017ba:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8017bf:	eb 17                	jmp    8017d8 <fd_alloc+0x6d>
  8017c1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8017c6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8017cb:	75 c8                	jne    801795 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8017cd:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8017d3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8017d8:	5b                   	pop    %ebx
  8017d9:	5e                   	pop    %esi
  8017da:	5f                   	pop    %edi
  8017db:	5d                   	pop    %ebp
  8017dc:	c3                   	ret    

008017dd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	83 f8 1f             	cmp    $0x1f,%eax
  8017e6:	77 36                	ja     80181e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8017e8:	05 00 00 0d 00       	add    $0xd0000,%eax
  8017ed:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8017f0:	89 c2                	mov    %eax,%edx
  8017f2:	c1 ea 16             	shr    $0x16,%edx
  8017f5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8017fc:	f6 c2 01             	test   $0x1,%dl
  8017ff:	74 1d                	je     80181e <fd_lookup+0x41>
  801801:	89 c2                	mov    %eax,%edx
  801803:	c1 ea 0c             	shr    $0xc,%edx
  801806:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80180d:	f6 c2 01             	test   $0x1,%dl
  801810:	74 0c                	je     80181e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801812:	8b 55 0c             	mov    0xc(%ebp),%edx
  801815:	89 02                	mov    %eax,(%edx)
  801817:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80181c:	eb 05                	jmp    801823 <fd_lookup+0x46>
  80181e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801823:	5d                   	pop    %ebp
  801824:	c3                   	ret    

00801825 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80182b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80182e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801832:	8b 45 08             	mov    0x8(%ebp),%eax
  801835:	89 04 24             	mov    %eax,(%esp)
  801838:	e8 a0 ff ff ff       	call   8017dd <fd_lookup>
  80183d:	85 c0                	test   %eax,%eax
  80183f:	78 0e                	js     80184f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801841:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801844:	8b 55 0c             	mov    0xc(%ebp),%edx
  801847:	89 50 04             	mov    %edx,0x4(%eax)
  80184a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80184f:	c9                   	leave  
  801850:	c3                   	ret    

00801851 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801851:	55                   	push   %ebp
  801852:	89 e5                	mov    %esp,%ebp
  801854:	56                   	push   %esi
  801855:	53                   	push   %ebx
  801856:	83 ec 10             	sub    $0x10,%esp
  801859:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80185c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80185f:	b8 08 70 80 00       	mov    $0x807008,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801864:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801869:	be 44 35 80 00       	mov    $0x803544,%esi
		if (devtab[i]->dev_id == dev_id) {
  80186e:	39 08                	cmp    %ecx,(%eax)
  801870:	75 10                	jne    801882 <dev_lookup+0x31>
  801872:	eb 04                	jmp    801878 <dev_lookup+0x27>
  801874:	39 08                	cmp    %ecx,(%eax)
  801876:	75 0a                	jne    801882 <dev_lookup+0x31>
			*dev = devtab[i];
  801878:	89 03                	mov    %eax,(%ebx)
  80187a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80187f:	90                   	nop
  801880:	eb 31                	jmp    8018b3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801882:	83 c2 01             	add    $0x1,%edx
  801885:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801888:	85 c0                	test   %eax,%eax
  80188a:	75 e8                	jne    801874 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80188c:	a1 78 70 80 00       	mov    0x807078,%eax
  801891:	8b 40 4c             	mov    0x4c(%eax),%eax
  801894:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801898:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189c:	c7 04 24 c4 34 80 00 	movl   $0x8034c4,(%esp)
  8018a3:	e8 a1 eb ff ff       	call   800449 <cprintf>
	*dev = 0;
  8018a8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8018ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8018b3:	83 c4 10             	add    $0x10,%esp
  8018b6:	5b                   	pop    %ebx
  8018b7:	5e                   	pop    %esi
  8018b8:	5d                   	pop    %ebp
  8018b9:	c3                   	ret    

008018ba <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	53                   	push   %ebx
  8018be:	83 ec 24             	sub    $0x24,%esp
  8018c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	89 04 24             	mov    %eax,(%esp)
  8018d1:	e8 07 ff ff ff       	call   8017dd <fd_lookup>
  8018d6:	85 c0                	test   %eax,%eax
  8018d8:	78 53                	js     80192d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018da:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e4:	8b 00                	mov    (%eax),%eax
  8018e6:	89 04 24             	mov    %eax,(%esp)
  8018e9:	e8 63 ff ff ff       	call   801851 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018ee:	85 c0                	test   %eax,%eax
  8018f0:	78 3b                	js     80192d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8018f2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018fa:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8018fe:	74 2d                	je     80192d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801900:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801903:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80190a:	00 00 00 
	stat->st_isdir = 0;
  80190d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801914:	00 00 00 
	stat->st_dev = dev;
  801917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801920:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801924:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801927:	89 14 24             	mov    %edx,(%esp)
  80192a:	ff 50 14             	call   *0x14(%eax)
}
  80192d:	83 c4 24             	add    $0x24,%esp
  801930:	5b                   	pop    %ebx
  801931:	5d                   	pop    %ebp
  801932:	c3                   	ret    

00801933 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	53                   	push   %ebx
  801937:	83 ec 24             	sub    $0x24,%esp
  80193a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80193d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801940:	89 44 24 04          	mov    %eax,0x4(%esp)
  801944:	89 1c 24             	mov    %ebx,(%esp)
  801947:	e8 91 fe ff ff       	call   8017dd <fd_lookup>
  80194c:	85 c0                	test   %eax,%eax
  80194e:	78 5f                	js     8019af <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801950:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801953:	89 44 24 04          	mov    %eax,0x4(%esp)
  801957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80195a:	8b 00                	mov    (%eax),%eax
  80195c:	89 04 24             	mov    %eax,(%esp)
  80195f:	e8 ed fe ff ff       	call   801851 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801964:	85 c0                	test   %eax,%eax
  801966:	78 47                	js     8019af <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801968:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80196b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80196f:	75 23                	jne    801994 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801971:	a1 78 70 80 00       	mov    0x807078,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801976:	8b 40 4c             	mov    0x4c(%eax),%eax
  801979:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80197d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801981:	c7 04 24 e4 34 80 00 	movl   $0x8034e4,(%esp)
  801988:	e8 bc ea ff ff       	call   800449 <cprintf>
  80198d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801992:	eb 1b                	jmp    8019af <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801994:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801997:	8b 48 18             	mov    0x18(%eax),%ecx
  80199a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80199f:	85 c9                	test   %ecx,%ecx
  8019a1:	74 0c                	je     8019af <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019aa:	89 14 24             	mov    %edx,(%esp)
  8019ad:	ff d1                	call   *%ecx
}
  8019af:	83 c4 24             	add    $0x24,%esp
  8019b2:	5b                   	pop    %ebx
  8019b3:	5d                   	pop    %ebp
  8019b4:	c3                   	ret    

008019b5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	53                   	push   %ebx
  8019b9:	83 ec 24             	sub    $0x24,%esp
  8019bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019c6:	89 1c 24             	mov    %ebx,(%esp)
  8019c9:	e8 0f fe ff ff       	call   8017dd <fd_lookup>
  8019ce:	85 c0                	test   %eax,%eax
  8019d0:	78 66                	js     801a38 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019dc:	8b 00                	mov    (%eax),%eax
  8019de:	89 04 24             	mov    %eax,(%esp)
  8019e1:	e8 6b fe ff ff       	call   801851 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019e6:	85 c0                	test   %eax,%eax
  8019e8:	78 4e                	js     801a38 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8019ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019ed:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8019f1:	75 23                	jne    801a16 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8019f3:	a1 78 70 80 00       	mov    0x807078,%eax
  8019f8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8019fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a03:	c7 04 24 08 35 80 00 	movl   $0x803508,(%esp)
  801a0a:	e8 3a ea ff ff       	call   800449 <cprintf>
  801a0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801a14:	eb 22                	jmp    801a38 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a19:	8b 48 0c             	mov    0xc(%eax),%ecx
  801a1c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a21:	85 c9                	test   %ecx,%ecx
  801a23:	74 13                	je     801a38 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801a25:	8b 45 10             	mov    0x10(%ebp),%eax
  801a28:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a33:	89 14 24             	mov    %edx,(%esp)
  801a36:	ff d1                	call   *%ecx
}
  801a38:	83 c4 24             	add    $0x24,%esp
  801a3b:	5b                   	pop    %ebx
  801a3c:	5d                   	pop    %ebp
  801a3d:	c3                   	ret    

00801a3e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801a3e:	55                   	push   %ebp
  801a3f:	89 e5                	mov    %esp,%ebp
  801a41:	53                   	push   %ebx
  801a42:	83 ec 24             	sub    $0x24,%esp
  801a45:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a48:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4f:	89 1c 24             	mov    %ebx,(%esp)
  801a52:	e8 86 fd ff ff       	call   8017dd <fd_lookup>
  801a57:	85 c0                	test   %eax,%eax
  801a59:	78 6b                	js     801ac6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a65:	8b 00                	mov    (%eax),%eax
  801a67:	89 04 24             	mov    %eax,(%esp)
  801a6a:	e8 e2 fd ff ff       	call   801851 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	78 53                	js     801ac6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801a73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a76:	8b 42 08             	mov    0x8(%edx),%eax
  801a79:	83 e0 03             	and    $0x3,%eax
  801a7c:	83 f8 01             	cmp    $0x1,%eax
  801a7f:	75 23                	jne    801aa4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801a81:	a1 78 70 80 00       	mov    0x807078,%eax
  801a86:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a89:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a91:	c7 04 24 25 35 80 00 	movl   $0x803525,(%esp)
  801a98:	e8 ac e9 ff ff       	call   800449 <cprintf>
  801a9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801aa2:	eb 22                	jmp    801ac6 <read+0x88>
	}
	if (!dev->dev_read)
  801aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa7:	8b 48 08             	mov    0x8(%eax),%ecx
  801aaa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801aaf:	85 c9                	test   %ecx,%ecx
  801ab1:	74 13                	je     801ac6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801ab3:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab6:	89 44 24 08          	mov    %eax,0x8(%esp)
  801aba:	8b 45 0c             	mov    0xc(%ebp),%eax
  801abd:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ac1:	89 14 24             	mov    %edx,(%esp)
  801ac4:	ff d1                	call   *%ecx
}
  801ac6:	83 c4 24             	add    $0x24,%esp
  801ac9:	5b                   	pop    %ebx
  801aca:	5d                   	pop    %ebp
  801acb:	c3                   	ret    

00801acc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
  801acf:	57                   	push   %edi
  801ad0:	56                   	push   %esi
  801ad1:	53                   	push   %ebx
  801ad2:	83 ec 1c             	sub    $0x1c,%esp
  801ad5:	8b 7d 08             	mov    0x8(%ebp),%edi
  801ad8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801adb:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae0:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ae5:	b8 00 00 00 00       	mov    $0x0,%eax
  801aea:	85 f6                	test   %esi,%esi
  801aec:	74 29                	je     801b17 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801aee:	89 f0                	mov    %esi,%eax
  801af0:	29 d0                	sub    %edx,%eax
  801af2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801af6:	03 55 0c             	add    0xc(%ebp),%edx
  801af9:	89 54 24 04          	mov    %edx,0x4(%esp)
  801afd:	89 3c 24             	mov    %edi,(%esp)
  801b00:	e8 39 ff ff ff       	call   801a3e <read>
		if (m < 0)
  801b05:	85 c0                	test   %eax,%eax
  801b07:	78 0e                	js     801b17 <readn+0x4b>
			return m;
		if (m == 0)
  801b09:	85 c0                	test   %eax,%eax
  801b0b:	74 08                	je     801b15 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b0d:	01 c3                	add    %eax,%ebx
  801b0f:	89 da                	mov    %ebx,%edx
  801b11:	39 f3                	cmp    %esi,%ebx
  801b13:	72 d9                	jb     801aee <readn+0x22>
  801b15:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801b17:	83 c4 1c             	add    $0x1c,%esp
  801b1a:	5b                   	pop    %ebx
  801b1b:	5e                   	pop    %esi
  801b1c:	5f                   	pop    %edi
  801b1d:	5d                   	pop    %ebp
  801b1e:	c3                   	ret    

00801b1f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801b1f:	55                   	push   %ebp
  801b20:	89 e5                	mov    %esp,%ebp
  801b22:	56                   	push   %esi
  801b23:	53                   	push   %ebx
  801b24:	83 ec 20             	sub    $0x20,%esp
  801b27:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801b2a:	89 34 24             	mov    %esi,(%esp)
  801b2d:	e8 0e fc ff ff       	call   801740 <fd2num>
  801b32:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801b35:	89 54 24 04          	mov    %edx,0x4(%esp)
  801b39:	89 04 24             	mov    %eax,(%esp)
  801b3c:	e8 9c fc ff ff       	call   8017dd <fd_lookup>
  801b41:	89 c3                	mov    %eax,%ebx
  801b43:	85 c0                	test   %eax,%eax
  801b45:	78 05                	js     801b4c <fd_close+0x2d>
  801b47:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801b4a:	74 0c                	je     801b58 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801b4c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801b50:	19 c0                	sbb    %eax,%eax
  801b52:	f7 d0                	not    %eax
  801b54:	21 c3                	and    %eax,%ebx
  801b56:	eb 3d                	jmp    801b95 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801b58:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b5f:	8b 06                	mov    (%esi),%eax
  801b61:	89 04 24             	mov    %eax,(%esp)
  801b64:	e8 e8 fc ff ff       	call   801851 <dev_lookup>
  801b69:	89 c3                	mov    %eax,%ebx
  801b6b:	85 c0                	test   %eax,%eax
  801b6d:	78 16                	js     801b85 <fd_close+0x66>
		if (dev->dev_close)
  801b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b72:	8b 40 10             	mov    0x10(%eax),%eax
  801b75:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b7a:	85 c0                	test   %eax,%eax
  801b7c:	74 07                	je     801b85 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801b7e:	89 34 24             	mov    %esi,(%esp)
  801b81:	ff d0                	call   *%eax
  801b83:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801b85:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b89:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b90:	e8 35 f6 ff ff       	call   8011ca <sys_page_unmap>
	return r;
}
  801b95:	89 d8                	mov    %ebx,%eax
  801b97:	83 c4 20             	add    $0x20,%esp
  801b9a:	5b                   	pop    %ebx
  801b9b:	5e                   	pop    %esi
  801b9c:	5d                   	pop    %ebp
  801b9d:	c3                   	ret    

00801b9e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
  801ba1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ba4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ba7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	89 04 24             	mov    %eax,(%esp)
  801bb1:	e8 27 fc ff ff       	call   8017dd <fd_lookup>
  801bb6:	85 c0                	test   %eax,%eax
  801bb8:	78 13                	js     801bcd <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801bba:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801bc1:	00 
  801bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bc5:	89 04 24             	mov    %eax,(%esp)
  801bc8:	e8 52 ff ff ff       	call   801b1f <fd_close>
}
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	83 ec 18             	sub    $0x18,%esp
  801bd5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801bd8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801bdb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801be2:	00 
  801be3:	8b 45 08             	mov    0x8(%ebp),%eax
  801be6:	89 04 24             	mov    %eax,(%esp)
  801be9:	e8 a9 03 00 00       	call   801f97 <open>
  801bee:	89 c3                	mov    %eax,%ebx
  801bf0:	85 c0                	test   %eax,%eax
  801bf2:	78 1b                	js     801c0f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bfb:	89 1c 24             	mov    %ebx,(%esp)
  801bfe:	e8 b7 fc ff ff       	call   8018ba <fstat>
  801c03:	89 c6                	mov    %eax,%esi
	close(fd);
  801c05:	89 1c 24             	mov    %ebx,(%esp)
  801c08:	e8 91 ff ff ff       	call   801b9e <close>
  801c0d:	89 f3                	mov    %esi,%ebx
	return r;
}
  801c0f:	89 d8                	mov    %ebx,%eax
  801c11:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801c14:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801c17:	89 ec                	mov    %ebp,%esp
  801c19:	5d                   	pop    %ebp
  801c1a:	c3                   	ret    

00801c1b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
  801c1e:	53                   	push   %ebx
  801c1f:	83 ec 14             	sub    $0x14,%esp
  801c22:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801c27:	89 1c 24             	mov    %ebx,(%esp)
  801c2a:	e8 6f ff ff ff       	call   801b9e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801c2f:	83 c3 01             	add    $0x1,%ebx
  801c32:	83 fb 20             	cmp    $0x20,%ebx
  801c35:	75 f0                	jne    801c27 <close_all+0xc>
		close(i);
}
  801c37:	83 c4 14             	add    $0x14,%esp
  801c3a:	5b                   	pop    %ebx
  801c3b:	5d                   	pop    %ebp
  801c3c:	c3                   	ret    

00801c3d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	83 ec 58             	sub    $0x58,%esp
  801c43:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801c46:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801c49:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801c4c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801c4f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801c52:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	89 04 24             	mov    %eax,(%esp)
  801c5c:	e8 7c fb ff ff       	call   8017dd <fd_lookup>
  801c61:	89 c3                	mov    %eax,%ebx
  801c63:	85 c0                	test   %eax,%eax
  801c65:	0f 88 e0 00 00 00    	js     801d4b <dup+0x10e>
		return r;
	close(newfdnum);
  801c6b:	89 3c 24             	mov    %edi,(%esp)
  801c6e:	e8 2b ff ff ff       	call   801b9e <close>

	newfd = INDEX2FD(newfdnum);
  801c73:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801c79:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801c7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c7f:	89 04 24             	mov    %eax,(%esp)
  801c82:	e8 c9 fa ff ff       	call   801750 <fd2data>
  801c87:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801c89:	89 34 24             	mov    %esi,(%esp)
  801c8c:	e8 bf fa ff ff       	call   801750 <fd2data>
  801c91:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801c94:	89 da                	mov    %ebx,%edx
  801c96:	89 d8                	mov    %ebx,%eax
  801c98:	c1 e8 16             	shr    $0x16,%eax
  801c9b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ca2:	a8 01                	test   $0x1,%al
  801ca4:	74 43                	je     801ce9 <dup+0xac>
  801ca6:	c1 ea 0c             	shr    $0xc,%edx
  801ca9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801cb0:	a8 01                	test   $0x1,%al
  801cb2:	74 35                	je     801ce9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801cb4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801cbb:	25 07 0e 00 00       	and    $0xe07,%eax
  801cc0:	89 44 24 10          	mov    %eax,0x10(%esp)
  801cc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801cc7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ccb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801cd2:	00 
  801cd3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cd7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cde:	e8 45 f5 ff ff       	call   801228 <sys_page_map>
  801ce3:	89 c3                	mov    %eax,%ebx
  801ce5:	85 c0                	test   %eax,%eax
  801ce7:	78 3f                	js     801d28 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801ce9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cec:	89 c2                	mov    %eax,%edx
  801cee:	c1 ea 0c             	shr    $0xc,%edx
  801cf1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801cf8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801cfe:	89 54 24 10          	mov    %edx,0x10(%esp)
  801d02:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801d06:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d0d:	00 
  801d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d12:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d19:	e8 0a f5 ff ff       	call   801228 <sys_page_map>
  801d1e:	89 c3                	mov    %eax,%ebx
  801d20:	85 c0                	test   %eax,%eax
  801d22:	78 04                	js     801d28 <dup+0xeb>
  801d24:	89 fb                	mov    %edi,%ebx
  801d26:	eb 23                	jmp    801d4b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801d28:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d2c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d33:	e8 92 f4 ff ff       	call   8011ca <sys_page_unmap>
	sys_page_unmap(0, nva);
  801d38:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d3b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d3f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d46:	e8 7f f4 ff ff       	call   8011ca <sys_page_unmap>
	return r;
}
  801d4b:	89 d8                	mov    %ebx,%eax
  801d4d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801d50:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801d53:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801d56:	89 ec                	mov    %ebp,%esp
  801d58:	5d                   	pop    %ebp
  801d59:	c3                   	ret    
	...

00801d5c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
  801d5f:	53                   	push   %ebx
  801d60:	83 ec 14             	sub    $0x14,%esp
  801d63:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801d65:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801d6b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801d72:	00 
  801d73:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801d7a:	00 
  801d7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d7f:	89 14 24             	mov    %edx,(%esp)
  801d82:	e8 59 0e 00 00       	call   802be0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801d87:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d8e:	00 
  801d8f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d93:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d9a:	e8 a3 0e 00 00       	call   802c42 <ipc_recv>
}
  801d9f:	83 c4 14             	add    $0x14,%esp
  801da2:	5b                   	pop    %ebx
  801da3:	5d                   	pop    %ebp
  801da4:	c3                   	ret    

00801da5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
  801da8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	8b 40 0c             	mov    0xc(%eax),%eax
  801db1:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801db6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801db9:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801dbe:	ba 00 00 00 00       	mov    $0x0,%edx
  801dc3:	b8 02 00 00 00       	mov    $0x2,%eax
  801dc8:	e8 8f ff ff ff       	call   801d5c <fsipc>
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801dd5:	ba 00 00 00 00       	mov    $0x0,%edx
  801dda:	b8 08 00 00 00       	mov    $0x8,%eax
  801ddf:	e8 78 ff ff ff       	call   801d5c <fsipc>
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
  801de9:	53                   	push   %ebx
  801dea:	83 ec 14             	sub    $0x14,%esp
  801ded:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801df0:	8b 45 08             	mov    0x8(%ebp),%eax
  801df3:	8b 40 0c             	mov    0xc(%eax),%eax
  801df6:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801dfb:	ba 00 00 00 00       	mov    $0x0,%edx
  801e00:	b8 05 00 00 00       	mov    $0x5,%eax
  801e05:	e8 52 ff ff ff       	call   801d5c <fsipc>
  801e0a:	85 c0                	test   %eax,%eax
  801e0c:	78 2b                	js     801e39 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801e0e:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801e15:	00 
  801e16:	89 1c 24             	mov    %ebx,(%esp)
  801e19:	e8 0c ed ff ff       	call   800b2a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801e1e:	a1 80 40 80 00       	mov    0x804080,%eax
  801e23:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801e29:	a1 84 40 80 00       	mov    0x804084,%eax
  801e2e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801e34:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801e39:	83 c4 14             	add    $0x14,%esp
  801e3c:	5b                   	pop    %ebx
  801e3d:	5d                   	pop    %ebp
  801e3e:	c3                   	ret    

00801e3f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
  801e42:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  801e45:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801e4c:	00 
  801e4d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e54:	00 
  801e55:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e5c:	e8 25 ee ff ff       	call   800c86 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801e61:	8b 45 08             	mov    0x8(%ebp),%eax
  801e64:	8b 40 0c             	mov    0xc(%eax),%eax
  801e67:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801e6c:	ba 00 00 00 00       	mov    $0x0,%edx
  801e71:	b8 06 00 00 00       	mov    $0x6,%eax
  801e76:	e8 e1 fe ff ff       	call   801d5c <fsipc>
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801e83:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801e8a:	00 
  801e8b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801e92:	00 
  801e93:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801e9a:	e8 e7 ed ff ff       	call   800c86 <memset>
  801e9f:	8b 45 10             	mov    0x10(%ebp),%eax
  801ea2:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801ea7:	76 05                	jbe    801eae <devfile_write+0x31>
  801ea9:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801eae:	8b 55 08             	mov    0x8(%ebp),%edx
  801eb1:	8b 52 0c             	mov    0xc(%edx),%edx
  801eb4:	89 15 00 40 80 00    	mov    %edx,0x804000
        fsipcbuf.write.req_n = numberOfBytes;
  801eba:	a3 04 40 80 00       	mov    %eax,0x804004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  801ebf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ec3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eca:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801ed1:	e8 0f ee ff ff       	call   800ce5 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  801ed6:	ba 00 00 00 00       	mov    $0x0,%edx
  801edb:	b8 04 00 00 00       	mov    $0x4,%eax
  801ee0:	e8 77 fe ff ff       	call   801d5c <fsipc>
              return r;
        return r;
}
  801ee5:	c9                   	leave  
  801ee6:	c3                   	ret    

00801ee7 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801ee7:	55                   	push   %ebp
  801ee8:	89 e5                	mov    %esp,%ebp
  801eea:	53                   	push   %ebx
  801eeb:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  801eee:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801ef5:	00 
  801ef6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801efd:	00 
  801efe:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801f05:	e8 7c ed ff ff       	call   800c86 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  801f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0d:	8b 40 0c             	mov    0xc(%eax),%eax
  801f10:	a3 00 40 80 00       	mov    %eax,0x804000
        fsipcbuf.read.req_n = n;
  801f15:	8b 45 10             	mov    0x10(%ebp),%eax
  801f18:	a3 04 40 80 00       	mov    %eax,0x804004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  801f1d:	ba 00 00 00 00       	mov    $0x0,%edx
  801f22:	b8 03 00 00 00       	mov    $0x3,%eax
  801f27:	e8 30 fe ff ff       	call   801d5c <fsipc>
  801f2c:	89 c3                	mov    %eax,%ebx
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	78 17                	js     801f49 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  801f32:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f36:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801f3d:	00 
  801f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f41:	89 04 24             	mov    %eax,(%esp)
  801f44:	e8 9c ed ff ff       	call   800ce5 <memmove>
        return r;
}
  801f49:	89 d8                	mov    %ebx,%eax
  801f4b:	83 c4 14             	add    $0x14,%esp
  801f4e:	5b                   	pop    %ebx
  801f4f:	5d                   	pop    %ebp
  801f50:	c3                   	ret    

00801f51 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801f51:	55                   	push   %ebp
  801f52:	89 e5                	mov    %esp,%ebp
  801f54:	53                   	push   %ebx
  801f55:	83 ec 14             	sub    $0x14,%esp
  801f58:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801f5b:	89 1c 24             	mov    %ebx,(%esp)
  801f5e:	e8 7d eb ff ff       	call   800ae0 <strlen>
  801f63:	89 c2                	mov    %eax,%edx
  801f65:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801f6a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801f70:	7f 1f                	jg     801f91 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801f72:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f76:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801f7d:	e8 a8 eb ff ff       	call   800b2a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801f82:	ba 00 00 00 00       	mov    $0x0,%edx
  801f87:	b8 07 00 00 00       	mov    $0x7,%eax
  801f8c:	e8 cb fd ff ff       	call   801d5c <fsipc>
}
  801f91:	83 c4 14             	add    $0x14,%esp
  801f94:	5b                   	pop    %ebx
  801f95:	5d                   	pop    %ebp
  801f96:	c3                   	ret    

00801f97 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	56                   	push   %esi
  801f9b:	53                   	push   %ebx
  801f9c:	83 ec 20             	sub    $0x20,%esp
  801f9f:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  801fa2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801fa9:	00 
  801faa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fb1:	00 
  801fb2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801fb9:	e8 c8 ec ff ff       	call   800c86 <memset>
    if(strlen(path)>=MAXPATHLEN)
  801fbe:	89 34 24             	mov    %esi,(%esp)
  801fc1:	e8 1a eb ff ff       	call   800ae0 <strlen>
  801fc6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801fcb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801fd0:	0f 8f 84 00 00 00    	jg     80205a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  801fd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fd9:	89 04 24             	mov    %eax,(%esp)
  801fdc:	e8 8a f7 ff ff       	call   80176b <fd_alloc>
  801fe1:	89 c3                	mov    %eax,%ebx
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	78 73                	js     80205a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  801fe7:	0f b6 06             	movzbl (%esi),%eax
  801fea:	84 c0                	test   %al,%al
  801fec:	74 20                	je     80200e <open+0x77>
  801fee:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  801ff0:	0f be c0             	movsbl %al,%eax
  801ff3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff7:	c7 04 24 58 35 80 00 	movl   $0x803558,(%esp)
  801ffe:	e8 46 e4 ff ff       	call   800449 <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  802003:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  802007:	83 c3 01             	add    $0x1,%ebx
  80200a:	84 c0                	test   %al,%al
  80200c:	75 e2                	jne    801ff0 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  80200e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802012:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  802019:	e8 0c eb ff ff       	call   800b2a <strcpy>
    fsipcbuf.open.req_omode = mode;
  80201e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802021:	a3 00 44 80 00       	mov    %eax,0x804400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  802026:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802029:	b8 01 00 00 00       	mov    $0x1,%eax
  80202e:	e8 29 fd ff ff       	call   801d5c <fsipc>
  802033:	89 c3                	mov    %eax,%ebx
  802035:	85 c0                	test   %eax,%eax
  802037:	79 15                	jns    80204e <open+0xb7>
        {
            fd_close(fd,1);
  802039:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802040:	00 
  802041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802044:	89 04 24             	mov    %eax,(%esp)
  802047:	e8 d3 fa ff ff       	call   801b1f <fd_close>
             return r;
  80204c:	eb 0c                	jmp    80205a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  80204e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802051:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  802057:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  80205a:	89 d8                	mov    %ebx,%eax
  80205c:	83 c4 20             	add    $0x20,%esp
  80205f:	5b                   	pop    %ebx
  802060:	5e                   	pop    %esi
  802061:	5d                   	pop    %ebp
  802062:	c3                   	ret    
	...

00802070 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802076:	c7 44 24 04 5b 35 80 	movl   $0x80355b,0x4(%esp)
  80207d:	00 
  80207e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802081:	89 04 24             	mov    %eax,(%esp)
  802084:	e8 a1 ea ff ff       	call   800b2a <strcpy>
	return 0;
}
  802089:	b8 00 00 00 00       	mov    $0x0,%eax
  80208e:	c9                   	leave  
  80208f:	c3                   	ret    

00802090 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  802096:	8b 45 08             	mov    0x8(%ebp),%eax
  802099:	8b 40 0c             	mov    0xc(%eax),%eax
  80209c:	89 04 24             	mov    %eax,(%esp)
  80209f:	e8 9e 02 00 00       	call   802342 <nsipc_close>
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8020ac:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020b3:	00 
  8020b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8020b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c5:	8b 40 0c             	mov    0xc(%eax),%eax
  8020c8:	89 04 24             	mov    %eax,(%esp)
  8020cb:	e8 ae 02 00 00       	call   80237e <nsipc_send>
}
  8020d0:	c9                   	leave  
  8020d1:	c3                   	ret    

008020d2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8020d2:	55                   	push   %ebp
  8020d3:	89 e5                	mov    %esp,%ebp
  8020d5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8020d8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8020df:	00 
  8020e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8020e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8020e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8020f4:	89 04 24             	mov    %eax,(%esp)
  8020f7:	e8 f5 02 00 00       	call   8023f1 <nsipc_recv>
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	56                   	push   %esi
  802102:	53                   	push   %ebx
  802103:	83 ec 20             	sub    $0x20,%esp
  802106:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802108:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80210b:	89 04 24             	mov    %eax,(%esp)
  80210e:	e8 58 f6 ff ff       	call   80176b <fd_alloc>
  802113:	89 c3                	mov    %eax,%ebx
  802115:	85 c0                	test   %eax,%eax
  802117:	78 21                	js     80213a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  802119:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802120:	00 
  802121:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802124:	89 44 24 04          	mov    %eax,0x4(%esp)
  802128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80212f:	e8 52 f1 ff ff       	call   801286 <sys_page_alloc>
  802134:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802136:	85 c0                	test   %eax,%eax
  802138:	79 0a                	jns    802144 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80213a:	89 34 24             	mov    %esi,(%esp)
  80213d:	e8 00 02 00 00       	call   802342 <nsipc_close>
		return r;
  802142:	eb 28                	jmp    80216c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802144:	8b 15 24 70 80 00    	mov    0x807024,%edx
  80214a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802159:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80215f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802162:	89 04 24             	mov    %eax,(%esp)
  802165:	e8 d6 f5 ff ff       	call   801740 <fd2num>
  80216a:	89 c3                	mov    %eax,%ebx
}
  80216c:	89 d8                	mov    %ebx,%eax
  80216e:	83 c4 20             	add    $0x20,%esp
  802171:	5b                   	pop    %ebx
  802172:	5e                   	pop    %esi
  802173:	5d                   	pop    %ebp
  802174:	c3                   	ret    

00802175 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802175:	55                   	push   %ebp
  802176:	89 e5                	mov    %esp,%ebp
  802178:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80217b:	8b 45 10             	mov    0x10(%ebp),%eax
  80217e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802182:	8b 45 0c             	mov    0xc(%ebp),%eax
  802185:	89 44 24 04          	mov    %eax,0x4(%esp)
  802189:	8b 45 08             	mov    0x8(%ebp),%eax
  80218c:	89 04 24             	mov    %eax,(%esp)
  80218f:	e8 62 01 00 00       	call   8022f6 <nsipc_socket>
  802194:	85 c0                	test   %eax,%eax
  802196:	78 05                	js     80219d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802198:	e8 61 ff ff ff       	call   8020fe <alloc_sockfd>
}
  80219d:	c9                   	leave  
  80219e:	66 90                	xchg   %ax,%ax
  8021a0:	c3                   	ret    

008021a1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8021a1:	55                   	push   %ebp
  8021a2:	89 e5                	mov    %esp,%ebp
  8021a4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8021a7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8021aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021ae:	89 04 24             	mov    %eax,(%esp)
  8021b1:	e8 27 f6 ff ff       	call   8017dd <fd_lookup>
  8021b6:	85 c0                	test   %eax,%eax
  8021b8:	78 15                	js     8021cf <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8021ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021bd:	8b 0a                	mov    (%edx),%ecx
  8021bf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021c4:	3b 0d 24 70 80 00    	cmp    0x807024,%ecx
  8021ca:	75 03                	jne    8021cf <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8021cc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8021cf:	c9                   	leave  
  8021d0:	c3                   	ret    

008021d1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8021d1:	55                   	push   %ebp
  8021d2:	89 e5                	mov    %esp,%ebp
  8021d4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021da:	e8 c2 ff ff ff       	call   8021a1 <fd2sockid>
  8021df:	85 c0                	test   %eax,%eax
  8021e1:	78 0f                	js     8021f2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8021e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021e6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021ea:	89 04 24             	mov    %eax,(%esp)
  8021ed:	e8 2e 01 00 00       	call   802320 <nsipc_listen>
}
  8021f2:	c9                   	leave  
  8021f3:	c3                   	ret    

008021f4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8021f4:	55                   	push   %ebp
  8021f5:	89 e5                	mov    %esp,%ebp
  8021f7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8021fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fd:	e8 9f ff ff ff       	call   8021a1 <fd2sockid>
  802202:	85 c0                	test   %eax,%eax
  802204:	78 16                	js     80221c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802206:	8b 55 10             	mov    0x10(%ebp),%edx
  802209:	89 54 24 08          	mov    %edx,0x8(%esp)
  80220d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802210:	89 54 24 04          	mov    %edx,0x4(%esp)
  802214:	89 04 24             	mov    %eax,(%esp)
  802217:	e8 55 02 00 00       	call   802471 <nsipc_connect>
}
  80221c:	c9                   	leave  
  80221d:	c3                   	ret    

0080221e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80221e:	55                   	push   %ebp
  80221f:	89 e5                	mov    %esp,%ebp
  802221:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802224:	8b 45 08             	mov    0x8(%ebp),%eax
  802227:	e8 75 ff ff ff       	call   8021a1 <fd2sockid>
  80222c:	85 c0                	test   %eax,%eax
  80222e:	78 0f                	js     80223f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802230:	8b 55 0c             	mov    0xc(%ebp),%edx
  802233:	89 54 24 04          	mov    %edx,0x4(%esp)
  802237:	89 04 24             	mov    %eax,(%esp)
  80223a:	e8 1d 01 00 00       	call   80235c <nsipc_shutdown>
}
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	e8 52 ff ff ff       	call   8021a1 <fd2sockid>
  80224f:	85 c0                	test   %eax,%eax
  802251:	78 16                	js     802269 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802253:	8b 55 10             	mov    0x10(%ebp),%edx
  802256:	89 54 24 08          	mov    %edx,0x8(%esp)
  80225a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802261:	89 04 24             	mov    %eax,(%esp)
  802264:	e8 47 02 00 00       	call   8024b0 <nsipc_bind>
}
  802269:	c9                   	leave  
  80226a:	c3                   	ret    

0080226b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80226b:	55                   	push   %ebp
  80226c:	89 e5                	mov    %esp,%ebp
  80226e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802271:	8b 45 08             	mov    0x8(%ebp),%eax
  802274:	e8 28 ff ff ff       	call   8021a1 <fd2sockid>
  802279:	85 c0                	test   %eax,%eax
  80227b:	78 1f                	js     80229c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80227d:	8b 55 10             	mov    0x10(%ebp),%edx
  802280:	89 54 24 08          	mov    %edx,0x8(%esp)
  802284:	8b 55 0c             	mov    0xc(%ebp),%edx
  802287:	89 54 24 04          	mov    %edx,0x4(%esp)
  80228b:	89 04 24             	mov    %eax,(%esp)
  80228e:	e8 5c 02 00 00       	call   8024ef <nsipc_accept>
  802293:	85 c0                	test   %eax,%eax
  802295:	78 05                	js     80229c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802297:	e8 62 fe ff ff       	call   8020fe <alloc_sockfd>
}
  80229c:	c9                   	leave  
  80229d:	8d 76 00             	lea    0x0(%esi),%esi
  8022a0:	c3                   	ret    
	...

008022b0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8022b0:	55                   	push   %ebp
  8022b1:	89 e5                	mov    %esp,%ebp
  8022b3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8022b6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8022bc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8022c3:	00 
  8022c4:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8022cb:	00 
  8022cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d0:	89 14 24             	mov    %edx,(%esp)
  8022d3:	e8 08 09 00 00       	call   802be0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8022d8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8022df:	00 
  8022e0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8022e7:	00 
  8022e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022ef:	e8 4e 09 00 00       	call   802c42 <ipc_recv>
}
  8022f4:	c9                   	leave  
  8022f5:	c3                   	ret    

008022f6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8022f6:	55                   	push   %ebp
  8022f7:	89 e5                	mov    %esp,%ebp
  8022f9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8022fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ff:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802304:	8b 45 0c             	mov    0xc(%ebp),%eax
  802307:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80230c:	8b 45 10             	mov    0x10(%ebp),%eax
  80230f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802314:	b8 09 00 00 00       	mov    $0x9,%eax
  802319:	e8 92 ff ff ff       	call   8022b0 <nsipc>
}
  80231e:	c9                   	leave  
  80231f:	c3                   	ret    

00802320 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80232e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802331:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802336:	b8 06 00 00 00       	mov    $0x6,%eax
  80233b:	e8 70 ff ff ff       	call   8022b0 <nsipc>
}
  802340:	c9                   	leave  
  802341:	c3                   	ret    

00802342 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802342:	55                   	push   %ebp
  802343:	89 e5                	mov    %esp,%ebp
  802345:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802348:	8b 45 08             	mov    0x8(%ebp),%eax
  80234b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802350:	b8 04 00 00 00       	mov    $0x4,%eax
  802355:	e8 56 ff ff ff       	call   8022b0 <nsipc>
}
  80235a:	c9                   	leave  
  80235b:	c3                   	ret    

0080235c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80235c:	55                   	push   %ebp
  80235d:	89 e5                	mov    %esp,%ebp
  80235f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802362:	8b 45 08             	mov    0x8(%ebp),%eax
  802365:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80236a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80236d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802372:	b8 03 00 00 00       	mov    $0x3,%eax
  802377:	e8 34 ff ff ff       	call   8022b0 <nsipc>
}
  80237c:	c9                   	leave  
  80237d:	c3                   	ret    

0080237e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80237e:	55                   	push   %ebp
  80237f:	89 e5                	mov    %esp,%ebp
  802381:	53                   	push   %ebx
  802382:	83 ec 14             	sub    $0x14,%esp
  802385:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802388:	8b 45 08             	mov    0x8(%ebp),%eax
  80238b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802390:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802396:	7e 24                	jle    8023bc <nsipc_send+0x3e>
  802398:	c7 44 24 0c 67 35 80 	movl   $0x803567,0xc(%esp)
  80239f:	00 
  8023a0:	c7 44 24 08 73 35 80 	movl   $0x803573,0x8(%esp)
  8023a7:	00 
  8023a8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8023af:	00 
  8023b0:	c7 04 24 88 35 80 00 	movl   $0x803588,(%esp)
  8023b7:	e8 c8 df ff ff       	call   800384 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8023bc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8023c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023c3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023c7:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8023ce:	e8 12 e9 ff ff       	call   800ce5 <memmove>
	nsipcbuf.send.req_size = size;
  8023d3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8023d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8023dc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  8023e1:	b8 08 00 00 00       	mov    $0x8,%eax
  8023e6:	e8 c5 fe ff ff       	call   8022b0 <nsipc>
}
  8023eb:	83 c4 14             	add    $0x14,%esp
  8023ee:	5b                   	pop    %ebx
  8023ef:	5d                   	pop    %ebp
  8023f0:	c3                   	ret    

008023f1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8023f1:	55                   	push   %ebp
  8023f2:	89 e5                	mov    %esp,%ebp
  8023f4:	56                   	push   %esi
  8023f5:	53                   	push   %ebx
  8023f6:	83 ec 10             	sub    $0x10,%esp
  8023f9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8023fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ff:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802404:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80240a:	8b 45 14             	mov    0x14(%ebp),%eax
  80240d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802412:	b8 07 00 00 00       	mov    $0x7,%eax
  802417:	e8 94 fe ff ff       	call   8022b0 <nsipc>
  80241c:	89 c3                	mov    %eax,%ebx
  80241e:	85 c0                	test   %eax,%eax
  802420:	78 46                	js     802468 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802422:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802427:	7f 04                	jg     80242d <nsipc_recv+0x3c>
  802429:	39 c6                	cmp    %eax,%esi
  80242b:	7d 24                	jge    802451 <nsipc_recv+0x60>
  80242d:	c7 44 24 0c 94 35 80 	movl   $0x803594,0xc(%esp)
  802434:	00 
  802435:	c7 44 24 08 73 35 80 	movl   $0x803573,0x8(%esp)
  80243c:	00 
  80243d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802444:	00 
  802445:	c7 04 24 88 35 80 00 	movl   $0x803588,(%esp)
  80244c:	e8 33 df ff ff       	call   800384 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802451:	89 44 24 08          	mov    %eax,0x8(%esp)
  802455:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80245c:	00 
  80245d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802460:	89 04 24             	mov    %eax,(%esp)
  802463:	e8 7d e8 ff ff       	call   800ce5 <memmove>
	}

	return r;
}
  802468:	89 d8                	mov    %ebx,%eax
  80246a:	83 c4 10             	add    $0x10,%esp
  80246d:	5b                   	pop    %ebx
  80246e:	5e                   	pop    %esi
  80246f:	5d                   	pop    %ebp
  802470:	c3                   	ret    

00802471 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802471:	55                   	push   %ebp
  802472:	89 e5                	mov    %esp,%ebp
  802474:	53                   	push   %ebx
  802475:	83 ec 14             	sub    $0x14,%esp
  802478:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80247b:	8b 45 08             	mov    0x8(%ebp),%eax
  80247e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802483:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802487:	8b 45 0c             	mov    0xc(%ebp),%eax
  80248a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80248e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802495:	e8 4b e8 ff ff       	call   800ce5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80249a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8024a0:	b8 05 00 00 00       	mov    $0x5,%eax
  8024a5:	e8 06 fe ff ff       	call   8022b0 <nsipc>
}
  8024aa:	83 c4 14             	add    $0x14,%esp
  8024ad:	5b                   	pop    %ebx
  8024ae:	5d                   	pop    %ebp
  8024af:	c3                   	ret    

008024b0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8024b0:	55                   	push   %ebp
  8024b1:	89 e5                	mov    %esp,%ebp
  8024b3:	53                   	push   %ebx
  8024b4:	83 ec 14             	sub    $0x14,%esp
  8024b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8024ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8024bd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8024c2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8024c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024c9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024cd:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8024d4:	e8 0c e8 ff ff       	call   800ce5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8024d9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8024df:	b8 02 00 00 00       	mov    $0x2,%eax
  8024e4:	e8 c7 fd ff ff       	call   8022b0 <nsipc>
}
  8024e9:	83 c4 14             	add    $0x14,%esp
  8024ec:	5b                   	pop    %ebx
  8024ed:	5d                   	pop    %ebp
  8024ee:	c3                   	ret    

008024ef <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8024ef:	55                   	push   %ebp
  8024f0:	89 e5                	mov    %esp,%ebp
  8024f2:	83 ec 18             	sub    $0x18,%esp
  8024f5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8024f8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8024fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8024fe:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802503:	b8 01 00 00 00       	mov    $0x1,%eax
  802508:	e8 a3 fd ff ff       	call   8022b0 <nsipc>
  80250d:	89 c3                	mov    %eax,%ebx
  80250f:	85 c0                	test   %eax,%eax
  802511:	78 25                	js     802538 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802513:	be 10 60 80 00       	mov    $0x806010,%esi
  802518:	8b 06                	mov    (%esi),%eax
  80251a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80251e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802525:	00 
  802526:	8b 45 0c             	mov    0xc(%ebp),%eax
  802529:	89 04 24             	mov    %eax,(%esp)
  80252c:	e8 b4 e7 ff ff       	call   800ce5 <memmove>
		*addrlen = ret->ret_addrlen;
  802531:	8b 16                	mov    (%esi),%edx
  802533:	8b 45 10             	mov    0x10(%ebp),%eax
  802536:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802538:	89 d8                	mov    %ebx,%eax
  80253a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80253d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802540:	89 ec                	mov    %ebp,%esp
  802542:	5d                   	pop    %ebp
  802543:	c3                   	ret    
	...

00802550 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802550:	55                   	push   %ebp
  802551:	89 e5                	mov    %esp,%ebp
  802553:	83 ec 18             	sub    $0x18,%esp
  802556:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802559:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80255c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80255f:	8b 45 08             	mov    0x8(%ebp),%eax
  802562:	89 04 24             	mov    %eax,(%esp)
  802565:	e8 e6 f1 ff ff       	call   801750 <fd2data>
  80256a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80256c:	c7 44 24 04 a9 35 80 	movl   $0x8035a9,0x4(%esp)
  802573:	00 
  802574:	89 34 24             	mov    %esi,(%esp)
  802577:	e8 ae e5 ff ff       	call   800b2a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80257c:	8b 43 04             	mov    0x4(%ebx),%eax
  80257f:	2b 03                	sub    (%ebx),%eax
  802581:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802587:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80258e:	00 00 00 
	stat->st_dev = &devpipe;
  802591:	c7 86 88 00 00 00 40 	movl   $0x807040,0x88(%esi)
  802598:	70 80 00 
	return 0;
}
  80259b:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8025a3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8025a6:	89 ec                	mov    %ebp,%esp
  8025a8:	5d                   	pop    %ebp
  8025a9:	c3                   	ret    

008025aa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8025aa:	55                   	push   %ebp
  8025ab:	89 e5                	mov    %esp,%ebp
  8025ad:	53                   	push   %ebx
  8025ae:	83 ec 14             	sub    $0x14,%esp
  8025b1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8025b4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8025b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025bf:	e8 06 ec ff ff       	call   8011ca <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8025c4:	89 1c 24             	mov    %ebx,(%esp)
  8025c7:	e8 84 f1 ff ff       	call   801750 <fd2data>
  8025cc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025d0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8025d7:	e8 ee eb ff ff       	call   8011ca <sys_page_unmap>
}
  8025dc:	83 c4 14             	add    $0x14,%esp
  8025df:	5b                   	pop    %ebx
  8025e0:	5d                   	pop    %ebp
  8025e1:	c3                   	ret    

008025e2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8025e2:	55                   	push   %ebp
  8025e3:	89 e5                	mov    %esp,%ebp
  8025e5:	57                   	push   %edi
  8025e6:	56                   	push   %esi
  8025e7:	53                   	push   %ebx
  8025e8:	83 ec 2c             	sub    $0x2c,%esp
  8025eb:	89 c7                	mov    %eax,%edi
  8025ed:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8025f0:	a1 78 70 80 00       	mov    0x807078,%eax
  8025f5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8025f8:	89 3c 24             	mov    %edi,(%esp)
  8025fb:	e8 a8 06 00 00       	call   802ca8 <pageref>
  802600:	89 c6                	mov    %eax,%esi
  802602:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802605:	89 04 24             	mov    %eax,(%esp)
  802608:	e8 9b 06 00 00       	call   802ca8 <pageref>
  80260d:	39 c6                	cmp    %eax,%esi
  80260f:	0f 94 c0             	sete   %al
  802612:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802615:	8b 15 78 70 80 00    	mov    0x807078,%edx
  80261b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80261e:	39 cb                	cmp    %ecx,%ebx
  802620:	75 08                	jne    80262a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802622:	83 c4 2c             	add    $0x2c,%esp
  802625:	5b                   	pop    %ebx
  802626:	5e                   	pop    %esi
  802627:	5f                   	pop    %edi
  802628:	5d                   	pop    %ebp
  802629:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80262a:	83 f8 01             	cmp    $0x1,%eax
  80262d:	75 c1                	jne    8025f0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80262f:	8b 52 58             	mov    0x58(%edx),%edx
  802632:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802636:	89 54 24 08          	mov    %edx,0x8(%esp)
  80263a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80263e:	c7 04 24 b0 35 80 00 	movl   $0x8035b0,(%esp)
  802645:	e8 ff dd ff ff       	call   800449 <cprintf>
  80264a:	eb a4                	jmp    8025f0 <_pipeisclosed+0xe>

0080264c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80264c:	55                   	push   %ebp
  80264d:	89 e5                	mov    %esp,%ebp
  80264f:	57                   	push   %edi
  802650:	56                   	push   %esi
  802651:	53                   	push   %ebx
  802652:	83 ec 1c             	sub    $0x1c,%esp
  802655:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802658:	89 34 24             	mov    %esi,(%esp)
  80265b:	e8 f0 f0 ff ff       	call   801750 <fd2data>
  802660:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802662:	bf 00 00 00 00       	mov    $0x0,%edi
  802667:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80266b:	75 54                	jne    8026c1 <devpipe_write+0x75>
  80266d:	eb 60                	jmp    8026cf <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80266f:	89 da                	mov    %ebx,%edx
  802671:	89 f0                	mov    %esi,%eax
  802673:	e8 6a ff ff ff       	call   8025e2 <_pipeisclosed>
  802678:	85 c0                	test   %eax,%eax
  80267a:	74 07                	je     802683 <devpipe_write+0x37>
  80267c:	b8 00 00 00 00       	mov    $0x0,%eax
  802681:	eb 53                	jmp    8026d6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802683:	90                   	nop
  802684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802688:	e8 58 ec ff ff       	call   8012e5 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80268d:	8b 43 04             	mov    0x4(%ebx),%eax
  802690:	8b 13                	mov    (%ebx),%edx
  802692:	83 c2 20             	add    $0x20,%edx
  802695:	39 d0                	cmp    %edx,%eax
  802697:	73 d6                	jae    80266f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802699:	89 c2                	mov    %eax,%edx
  80269b:	c1 fa 1f             	sar    $0x1f,%edx
  80269e:	c1 ea 1b             	shr    $0x1b,%edx
  8026a1:	01 d0                	add    %edx,%eax
  8026a3:	83 e0 1f             	and    $0x1f,%eax
  8026a6:	29 d0                	sub    %edx,%eax
  8026a8:	89 c2                	mov    %eax,%edx
  8026aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8026ad:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8026b1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8026b5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026b9:	83 c7 01             	add    $0x1,%edi
  8026bc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8026bf:	76 13                	jbe    8026d4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8026c1:	8b 43 04             	mov    0x4(%ebx),%eax
  8026c4:	8b 13                	mov    (%ebx),%edx
  8026c6:	83 c2 20             	add    $0x20,%edx
  8026c9:	39 d0                	cmp    %edx,%eax
  8026cb:	73 a2                	jae    80266f <devpipe_write+0x23>
  8026cd:	eb ca                	jmp    802699 <devpipe_write+0x4d>
  8026cf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8026d4:	89 f8                	mov    %edi,%eax
}
  8026d6:	83 c4 1c             	add    $0x1c,%esp
  8026d9:	5b                   	pop    %ebx
  8026da:	5e                   	pop    %esi
  8026db:	5f                   	pop    %edi
  8026dc:	5d                   	pop    %ebp
  8026dd:	c3                   	ret    

008026de <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8026de:	55                   	push   %ebp
  8026df:	89 e5                	mov    %esp,%ebp
  8026e1:	83 ec 28             	sub    $0x28,%esp
  8026e4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8026e7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8026ea:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8026ed:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8026f0:	89 3c 24             	mov    %edi,(%esp)
  8026f3:	e8 58 f0 ff ff       	call   801750 <fd2data>
  8026f8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8026fa:	be 00 00 00 00       	mov    $0x0,%esi
  8026ff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802703:	75 4c                	jne    802751 <devpipe_read+0x73>
  802705:	eb 5b                	jmp    802762 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802707:	89 f0                	mov    %esi,%eax
  802709:	eb 5e                	jmp    802769 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80270b:	89 da                	mov    %ebx,%edx
  80270d:	89 f8                	mov    %edi,%eax
  80270f:	90                   	nop
  802710:	e8 cd fe ff ff       	call   8025e2 <_pipeisclosed>
  802715:	85 c0                	test   %eax,%eax
  802717:	74 07                	je     802720 <devpipe_read+0x42>
  802719:	b8 00 00 00 00       	mov    $0x0,%eax
  80271e:	eb 49                	jmp    802769 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802720:	e8 c0 eb ff ff       	call   8012e5 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802725:	8b 03                	mov    (%ebx),%eax
  802727:	3b 43 04             	cmp    0x4(%ebx),%eax
  80272a:	74 df                	je     80270b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80272c:	89 c2                	mov    %eax,%edx
  80272e:	c1 fa 1f             	sar    $0x1f,%edx
  802731:	c1 ea 1b             	shr    $0x1b,%edx
  802734:	01 d0                	add    %edx,%eax
  802736:	83 e0 1f             	and    $0x1f,%eax
  802739:	29 d0                	sub    %edx,%eax
  80273b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802740:	8b 55 0c             	mov    0xc(%ebp),%edx
  802743:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802746:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802749:	83 c6 01             	add    $0x1,%esi
  80274c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80274f:	76 16                	jbe    802767 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802751:	8b 03                	mov    (%ebx),%eax
  802753:	3b 43 04             	cmp    0x4(%ebx),%eax
  802756:	75 d4                	jne    80272c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802758:	85 f6                	test   %esi,%esi
  80275a:	75 ab                	jne    802707 <devpipe_read+0x29>
  80275c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802760:	eb a9                	jmp    80270b <devpipe_read+0x2d>
  802762:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802767:	89 f0                	mov    %esi,%eax
}
  802769:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80276c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80276f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802772:	89 ec                	mov    %ebp,%esp
  802774:	5d                   	pop    %ebp
  802775:	c3                   	ret    

00802776 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802776:	55                   	push   %ebp
  802777:	89 e5                	mov    %esp,%ebp
  802779:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80277c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80277f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802783:	8b 45 08             	mov    0x8(%ebp),%eax
  802786:	89 04 24             	mov    %eax,(%esp)
  802789:	e8 4f f0 ff ff       	call   8017dd <fd_lookup>
  80278e:	85 c0                	test   %eax,%eax
  802790:	78 15                	js     8027a7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802795:	89 04 24             	mov    %eax,(%esp)
  802798:	e8 b3 ef ff ff       	call   801750 <fd2data>
	return _pipeisclosed(fd, p);
  80279d:	89 c2                	mov    %eax,%edx
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	e8 3b fe ff ff       	call   8025e2 <_pipeisclosed>
}
  8027a7:	c9                   	leave  
  8027a8:	c3                   	ret    

008027a9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8027a9:	55                   	push   %ebp
  8027aa:	89 e5                	mov    %esp,%ebp
  8027ac:	83 ec 48             	sub    $0x48,%esp
  8027af:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8027b2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8027b5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8027b8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8027bb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8027be:	89 04 24             	mov    %eax,(%esp)
  8027c1:	e8 a5 ef ff ff       	call   80176b <fd_alloc>
  8027c6:	89 c3                	mov    %eax,%ebx
  8027c8:	85 c0                	test   %eax,%eax
  8027ca:	0f 88 42 01 00 00    	js     802912 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8027d0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8027d7:	00 
  8027d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8027db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027df:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8027e6:	e8 9b ea ff ff       	call   801286 <sys_page_alloc>
  8027eb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8027ed:	85 c0                	test   %eax,%eax
  8027ef:	0f 88 1d 01 00 00    	js     802912 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8027f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8027f8:	89 04 24             	mov    %eax,(%esp)
  8027fb:	e8 6b ef ff ff       	call   80176b <fd_alloc>
  802800:	89 c3                	mov    %eax,%ebx
  802802:	85 c0                	test   %eax,%eax
  802804:	0f 88 f5 00 00 00    	js     8028ff <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80280a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802811:	00 
  802812:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802815:	89 44 24 04          	mov    %eax,0x4(%esp)
  802819:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802820:	e8 61 ea ff ff       	call   801286 <sys_page_alloc>
  802825:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802827:	85 c0                	test   %eax,%eax
  802829:	0f 88 d0 00 00 00    	js     8028ff <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80282f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802832:	89 04 24             	mov    %eax,(%esp)
  802835:	e8 16 ef ff ff       	call   801750 <fd2data>
  80283a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80283c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802843:	00 
  802844:	89 44 24 04          	mov    %eax,0x4(%esp)
  802848:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80284f:	e8 32 ea ff ff       	call   801286 <sys_page_alloc>
  802854:	89 c3                	mov    %eax,%ebx
  802856:	85 c0                	test   %eax,%eax
  802858:	0f 88 8e 00 00 00    	js     8028ec <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80285e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802861:	89 04 24             	mov    %eax,(%esp)
  802864:	e8 e7 ee ff ff       	call   801750 <fd2data>
  802869:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802870:	00 
  802871:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802875:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80287c:	00 
  80287d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802881:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802888:	e8 9b e9 ff ff       	call   801228 <sys_page_map>
  80288d:	89 c3                	mov    %eax,%ebx
  80288f:	85 c0                	test   %eax,%eax
  802891:	78 49                	js     8028dc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802893:	b8 40 70 80 00       	mov    $0x807040,%eax
  802898:	8b 08                	mov    (%eax),%ecx
  80289a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80289d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80289f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8028a2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8028a9:	8b 10                	mov    (%eax),%edx
  8028ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ae:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8028b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028b3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8028ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028bd:	89 04 24             	mov    %eax,(%esp)
  8028c0:	e8 7b ee ff ff       	call   801740 <fd2num>
  8028c5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8028c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ca:	89 04 24             	mov    %eax,(%esp)
  8028cd:	e8 6e ee ff ff       	call   801740 <fd2num>
  8028d2:	89 47 04             	mov    %eax,0x4(%edi)
  8028d5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8028da:	eb 36                	jmp    802912 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8028dc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028e7:	e8 de e8 ff ff       	call   8011ca <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8028ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028fa:	e8 cb e8 ff ff       	call   8011ca <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8028ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802902:	89 44 24 04          	mov    %eax,0x4(%esp)
  802906:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80290d:	e8 b8 e8 ff ff       	call   8011ca <sys_page_unmap>
    err:
	return r;
}
  802912:	89 d8                	mov    %ebx,%eax
  802914:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802917:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80291a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80291d:	89 ec                	mov    %ebp,%esp
  80291f:	5d                   	pop    %ebp
  802920:	c3                   	ret    
  802921:	00 00                	add    %al,(%eax)
	...

00802924 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802924:	55                   	push   %ebp
  802925:	89 e5                	mov    %esp,%ebp
  802927:	56                   	push   %esi
  802928:	53                   	push   %ebx
  802929:	83 ec 10             	sub    $0x10,%esp
  80292c:	8b 45 08             	mov    0x8(%ebp),%eax
	volatile struct Env *e;

	assert(envid != 0);
  80292f:	85 c0                	test   %eax,%eax
  802931:	75 24                	jne    802957 <wait+0x33>
  802933:	c7 44 24 0c c8 35 80 	movl   $0x8035c8,0xc(%esp)
  80293a:	00 
  80293b:	c7 44 24 08 73 35 80 	movl   $0x803573,0x8(%esp)
  802942:	00 
  802943:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  80294a:	00 
  80294b:	c7 04 24 d3 35 80 00 	movl   $0x8035d3,(%esp)
  802952:	e8 2d da ff ff       	call   800384 <_panic>
	e = &envs[ENVX(envid)];
  802957:	89 c3                	mov    %eax,%ebx
  802959:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  80295f:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802962:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802968:	8b 73 4c             	mov    0x4c(%ebx),%esi
  80296b:	39 c6                	cmp    %eax,%esi
  80296d:	75 1a                	jne    802989 <wait+0x65>
  80296f:	8b 43 54             	mov    0x54(%ebx),%eax
  802972:	85 c0                	test   %eax,%eax
  802974:	74 13                	je     802989 <wait+0x65>
		sys_yield();
  802976:	e8 6a e9 ff ff       	call   8012e5 <sys_yield>
{
	volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80297b:	8b 43 4c             	mov    0x4c(%ebx),%eax
  80297e:	39 f0                	cmp    %esi,%eax
  802980:	75 07                	jne    802989 <wait+0x65>
  802982:	8b 43 54             	mov    0x54(%ebx),%eax
  802985:	85 c0                	test   %eax,%eax
  802987:	75 ed                	jne    802976 <wait+0x52>
		sys_yield();
}
  802989:	83 c4 10             	add    $0x10,%esp
  80298c:	5b                   	pop    %ebx
  80298d:	5e                   	pop    %esi
  80298e:	5d                   	pop    %ebp
  80298f:	c3                   	ret    

00802990 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802990:	55                   	push   %ebp
  802991:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802993:	b8 00 00 00 00       	mov    $0x0,%eax
  802998:	5d                   	pop    %ebp
  802999:	c3                   	ret    

0080299a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80299a:	55                   	push   %ebp
  80299b:	89 e5                	mov    %esp,%ebp
  80299d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8029a0:	c7 44 24 04 de 35 80 	movl   $0x8035de,0x4(%esp)
  8029a7:	00 
  8029a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029ab:	89 04 24             	mov    %eax,(%esp)
  8029ae:	e8 77 e1 ff ff       	call   800b2a <strcpy>
	return 0;
}
  8029b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029b8:	c9                   	leave  
  8029b9:	c3                   	ret    

008029ba <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8029ba:	55                   	push   %ebp
  8029bb:	89 e5                	mov    %esp,%ebp
  8029bd:	57                   	push   %edi
  8029be:	56                   	push   %esi
  8029bf:	53                   	push   %ebx
  8029c0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8029c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8029cb:	be 00 00 00 00       	mov    $0x0,%esi
  8029d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8029d4:	74 3f                	je     802a15 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8029d6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8029dc:	8b 55 10             	mov    0x10(%ebp),%edx
  8029df:	29 c2                	sub    %eax,%edx
  8029e1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  8029e3:	83 fa 7f             	cmp    $0x7f,%edx
  8029e6:	76 05                	jbe    8029ed <devcons_write+0x33>
  8029e8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8029ed:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8029f1:	03 45 0c             	add    0xc(%ebp),%eax
  8029f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029f8:	89 3c 24             	mov    %edi,(%esp)
  8029fb:	e8 e5 e2 ff ff       	call   800ce5 <memmove>
		sys_cputs(buf, m);
  802a00:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a04:	89 3c 24             	mov    %edi,(%esp)
  802a07:	e8 14 e5 ff ff       	call   800f20 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a0c:	01 de                	add    %ebx,%esi
  802a0e:	89 f0                	mov    %esi,%eax
  802a10:	3b 75 10             	cmp    0x10(%ebp),%esi
  802a13:	72 c7                	jb     8029dc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802a15:	89 f0                	mov    %esi,%eax
  802a17:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802a1d:	5b                   	pop    %ebx
  802a1e:	5e                   	pop    %esi
  802a1f:	5f                   	pop    %edi
  802a20:	5d                   	pop    %ebp
  802a21:	c3                   	ret    

00802a22 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802a22:	55                   	push   %ebp
  802a23:	89 e5                	mov    %esp,%ebp
  802a25:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802a28:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802a2e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802a35:	00 
  802a36:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a39:	89 04 24             	mov    %eax,(%esp)
  802a3c:	e8 df e4 ff ff       	call   800f20 <sys_cputs>
}
  802a41:	c9                   	leave  
  802a42:	c3                   	ret    

00802a43 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a43:	55                   	push   %ebp
  802a44:	89 e5                	mov    %esp,%ebp
  802a46:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802a49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a4d:	75 07                	jne    802a56 <devcons_read+0x13>
  802a4f:	eb 28                	jmp    802a79 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802a51:	e8 8f e8 ff ff       	call   8012e5 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802a56:	66 90                	xchg   %ax,%ax
  802a58:	e8 8f e4 ff ff       	call   800eec <sys_cgetc>
  802a5d:	85 c0                	test   %eax,%eax
  802a5f:	90                   	nop
  802a60:	74 ef                	je     802a51 <devcons_read+0xe>
  802a62:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802a64:	85 c0                	test   %eax,%eax
  802a66:	78 16                	js     802a7e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802a68:	83 f8 04             	cmp    $0x4,%eax
  802a6b:	74 0c                	je     802a79 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802a6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a70:	88 10                	mov    %dl,(%eax)
  802a72:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802a77:	eb 05                	jmp    802a7e <devcons_read+0x3b>
  802a79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a7e:	c9                   	leave  
  802a7f:	c3                   	ret    

00802a80 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802a80:	55                   	push   %ebp
  802a81:	89 e5                	mov    %esp,%ebp
  802a83:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802a86:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a89:	89 04 24             	mov    %eax,(%esp)
  802a8c:	e8 da ec ff ff       	call   80176b <fd_alloc>
  802a91:	85 c0                	test   %eax,%eax
  802a93:	78 3f                	js     802ad4 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802a95:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802a9c:	00 
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802aa4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802aab:	e8 d6 e7 ff ff       	call   801286 <sys_page_alloc>
  802ab0:	85 c0                	test   %eax,%eax
  802ab2:	78 20                	js     802ad4 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802ab4:	8b 15 5c 70 80 00    	mov    0x80705c,%edx
  802aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802abd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acc:	89 04 24             	mov    %eax,(%esp)
  802acf:	e8 6c ec ff ff       	call   801740 <fd2num>
}
  802ad4:	c9                   	leave  
  802ad5:	c3                   	ret    

00802ad6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802ad6:	55                   	push   %ebp
  802ad7:	89 e5                	mov    %esp,%ebp
  802ad9:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802adc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802adf:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	89 04 24             	mov    %eax,(%esp)
  802ae9:	e8 ef ec ff ff       	call   8017dd <fd_lookup>
  802aee:	85 c0                	test   %eax,%eax
  802af0:	78 11                	js     802b03 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af5:	8b 00                	mov    (%eax),%eax
  802af7:	3b 05 5c 70 80 00    	cmp    0x80705c,%eax
  802afd:	0f 94 c0             	sete   %al
  802b00:	0f b6 c0             	movzbl %al,%eax
}
  802b03:	c9                   	leave  
  802b04:	c3                   	ret    

00802b05 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802b05:	55                   	push   %ebp
  802b06:	89 e5                	mov    %esp,%ebp
  802b08:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802b0b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802b12:	00 
  802b13:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802b16:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b1a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b21:	e8 18 ef ff ff       	call   801a3e <read>
	if (r < 0)
  802b26:	85 c0                	test   %eax,%eax
  802b28:	78 0f                	js     802b39 <getchar+0x34>
		return r;
	if (r < 1)
  802b2a:	85 c0                	test   %eax,%eax
  802b2c:	7f 07                	jg     802b35 <getchar+0x30>
  802b2e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802b33:	eb 04                	jmp    802b39 <getchar+0x34>
		return -E_EOF;
	return c;
  802b35:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802b39:	c9                   	leave  
  802b3a:	c3                   	ret    
	...

00802b3c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802b3c:	55                   	push   %ebp
  802b3d:	89 e5                	mov    %esp,%ebp
  802b3f:	53                   	push   %ebx
  802b40:	83 ec 14             	sub    $0x14,%esp
  802b43:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    // cprintf("\nhere outside loading creating page\n");

	if (_pgfault_handler == 0) {
  802b46:	83 3d 80 70 80 00 00 	cmpl   $0x0,0x807080
  802b4d:	75 58                	jne    802ba7 <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
           //cprintf("\nhere inside loading creating page\n");    
          if(sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  802b4f:	e8 c5 e7 ff ff       	call   801319 <sys_getenvid>
  802b54:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802b5b:	00 
  802b5c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802b63:	ee 
  802b64:	89 04 24             	mov    %eax,(%esp)
  802b67:	e8 1a e7 ff ff       	call   801286 <sys_page_alloc>
  802b6c:	85 c0                	test   %eax,%eax
  802b6e:	79 1c                	jns    802b8c <set_pgfault_handler+0x50>
                          panic("Cant allocate Page");                    
  802b70:	c7 44 24 08 4c 34 80 	movl   $0x80344c,0x8(%esp)
  802b77:	00 
  802b78:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802b7f:	00 
  802b80:	c7 04 24 ea 35 80 00 	movl   $0x8035ea,(%esp)
  802b87:	e8 f8 d7 ff ff       	call   800384 <_panic>
                _pgfault_handler=handler;
  802b8c:	89 1d 80 70 80 00    	mov    %ebx,0x807080
//entry point _pgfault_handler not pointed to by the kernel bcz after the execution is complete control needs to be returned back to execute the rest...so upcall is there         
             sys_env_set_pgfault_upcall(sys_getenvid(),_pgfault_upcall);
  802b92:	e8 82 e7 ff ff       	call   801319 <sys_getenvid>
  802b97:	c7 44 24 04 b4 2b 80 	movl   $0x802bb4,0x4(%esp)
  802b9e:	00 
  802b9f:	89 04 24             	mov    %eax,(%esp)
  802ba2:	e8 09 e5 ff ff       	call   8010b0 <sys_env_set_pgfault_upcall>

	// Save handler pointer for assembly to call.
 //     if(sys_page_alloc(0,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
   //                       panic("Cant allocate Page");

	_pgfault_handler = handler;
  802ba7:	89 1d 80 70 80 00    	mov    %ebx,0x807080
}
  802bad:	83 c4 14             	add    $0x14,%esp
  802bb0:	5b                   	pop    %ebx
  802bb1:	5d                   	pop    %ebp
  802bb2:	c3                   	ret    
	...

00802bb4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802bb4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802bb5:	a1 80 70 80 00       	mov    0x807080,%eax
	call *%eax
  802bba:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802bbc:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
           addl $8,%esp
  802bbf:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
            movl  32(%esp),%ebx
  802bc2:	8b 5c 24 20          	mov    0x20(%esp),%ebx
            movl  40(%esp),%eax
  802bc6:	8b 44 24 28          	mov    0x28(%esp),%eax
            subl  $4,%eax
  802bca:	83 e8 04             	sub    $0x4,%eax
            movl  %eax,40(%esp)
  802bcd:	89 44 24 28          	mov    %eax,0x28(%esp)
            movl  %ebx,(%eax)
  802bd1:	89 18                	mov    %ebx,(%eax)
            popal
  802bd3:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
            
            add $4,%esp            
  802bd4:	83 c4 04             	add    $0x4,%esp
            popfl
  802bd7:	9d                   	popf   
             
           popl %esp
  802bd8:	5c                   	pop    %esp
	// LAB 4: Your code here.
           

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
           ret
  802bd9:	c3                   	ret    
  802bda:	00 00                	add    %al,(%eax)
  802bdc:	00 00                	add    %al,(%eax)
	...

00802be0 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802be0:	55                   	push   %ebp
  802be1:	89 e5                	mov    %esp,%ebp
  802be3:	57                   	push   %edi
  802be4:	56                   	push   %esi
  802be5:	53                   	push   %ebx
  802be6:	83 ec 1c             	sub    $0x1c,%esp
  802be9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802bec:	8b 75 0c             	mov    0xc(%ebp),%esi
  802bef:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  802bf2:	8b 45 14             	mov    0x14(%ebp),%eax
  802bf5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bf9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802bfd:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c01:	89 1c 24             	mov    %ebx,(%esp)
  802c04:	e8 6f e4 ff ff       	call   801078 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  802c09:	85 c0                	test   %eax,%eax
  802c0b:	79 21                	jns    802c2e <ipc_send+0x4e>
  802c0d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802c10:	74 1c                	je     802c2e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  802c12:	c7 44 24 08 f8 35 80 	movl   $0x8035f8,0x8(%esp)
  802c19:	00 
  802c1a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  802c21:	00 
  802c22:	c7 04 24 0a 36 80 00 	movl   $0x80360a,(%esp)
  802c29:	e8 56 d7 ff ff       	call   800384 <_panic>
          else if(r==-E_IPC_NOT_RECV)
  802c2e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802c31:	75 07                	jne    802c3a <ipc_send+0x5a>
           sys_yield();
  802c33:	e8 ad e6 ff ff       	call   8012e5 <sys_yield>
          else
            break;
        }
  802c38:	eb b8                	jmp    802bf2 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  802c3a:	83 c4 1c             	add    $0x1c,%esp
  802c3d:	5b                   	pop    %ebx
  802c3e:	5e                   	pop    %esi
  802c3f:	5f                   	pop    %edi
  802c40:	5d                   	pop    %ebp
  802c41:	c3                   	ret    

00802c42 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802c42:	55                   	push   %ebp
  802c43:	89 e5                	mov    %esp,%ebp
  802c45:	83 ec 18             	sub    $0x18,%esp
  802c48:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802c4b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802c4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802c51:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  802c54:	8b 45 0c             	mov    0xc(%ebp),%eax
  802c57:	89 04 24             	mov    %eax,(%esp)
  802c5a:	e8 bc e3 ff ff       	call   80101b <sys_ipc_recv>
        if(r<0)
  802c5f:	85 c0                	test   %eax,%eax
  802c61:	79 17                	jns    802c7a <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  802c63:	85 db                	test   %ebx,%ebx
  802c65:	74 06                	je     802c6d <ipc_recv+0x2b>
               *from_env_store =0;
  802c67:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  802c6d:	85 f6                	test   %esi,%esi
  802c6f:	90                   	nop
  802c70:	74 2c                	je     802c9e <ipc_recv+0x5c>
              *perm_store=0;
  802c72:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802c78:	eb 24                	jmp    802c9e <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  802c7a:	85 db                	test   %ebx,%ebx
  802c7c:	74 0a                	je     802c88 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  802c7e:	a1 78 70 80 00       	mov    0x807078,%eax
  802c83:	8b 40 74             	mov    0x74(%eax),%eax
  802c86:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  802c88:	85 f6                	test   %esi,%esi
  802c8a:	74 0a                	je     802c96 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  802c8c:	a1 78 70 80 00       	mov    0x807078,%eax
  802c91:	8b 40 78             	mov    0x78(%eax),%eax
  802c94:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  802c96:	a1 78 70 80 00       	mov    0x807078,%eax
  802c9b:	8b 40 70             	mov    0x70(%eax),%eax
}
  802c9e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802ca1:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802ca4:	89 ec                	mov    %ebp,%esp
  802ca6:	5d                   	pop    %ebp
  802ca7:	c3                   	ret    

00802ca8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802ca8:	55                   	push   %ebp
  802ca9:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	89 c2                	mov    %eax,%edx
  802cb0:	c1 ea 16             	shr    $0x16,%edx
  802cb3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802cba:	f6 c2 01             	test   $0x1,%dl
  802cbd:	74 26                	je     802ce5 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802cbf:	c1 e8 0c             	shr    $0xc,%eax
  802cc2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802cc9:	a8 01                	test   $0x1,%al
  802ccb:	74 18                	je     802ce5 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802ccd:	c1 e8 0c             	shr    $0xc,%eax
  802cd0:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802cd3:	c1 e2 02             	shl    $0x2,%edx
  802cd6:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802cdb:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802ce0:	0f b7 c0             	movzwl %ax,%eax
  802ce3:	eb 05                	jmp    802cea <pageref+0x42>
  802ce5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802cea:	5d                   	pop    %ebp
  802ceb:	c3                   	ret    
  802cec:	00 00                	add    %al,(%eax)
	...

00802cf0 <__udivdi3>:
  802cf0:	55                   	push   %ebp
  802cf1:	89 e5                	mov    %esp,%ebp
  802cf3:	57                   	push   %edi
  802cf4:	56                   	push   %esi
  802cf5:	83 ec 10             	sub    $0x10,%esp
  802cf8:	8b 45 14             	mov    0x14(%ebp),%eax
  802cfb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cfe:	8b 75 10             	mov    0x10(%ebp),%esi
  802d01:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802d04:	85 c0                	test   %eax,%eax
  802d06:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802d09:	75 35                	jne    802d40 <__udivdi3+0x50>
  802d0b:	39 fe                	cmp    %edi,%esi
  802d0d:	77 61                	ja     802d70 <__udivdi3+0x80>
  802d0f:	85 f6                	test   %esi,%esi
  802d11:	75 0b                	jne    802d1e <__udivdi3+0x2e>
  802d13:	b8 01 00 00 00       	mov    $0x1,%eax
  802d18:	31 d2                	xor    %edx,%edx
  802d1a:	f7 f6                	div    %esi
  802d1c:	89 c6                	mov    %eax,%esi
  802d1e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802d21:	31 d2                	xor    %edx,%edx
  802d23:	89 f8                	mov    %edi,%eax
  802d25:	f7 f6                	div    %esi
  802d27:	89 c7                	mov    %eax,%edi
  802d29:	89 c8                	mov    %ecx,%eax
  802d2b:	f7 f6                	div    %esi
  802d2d:	89 c1                	mov    %eax,%ecx
  802d2f:	89 fa                	mov    %edi,%edx
  802d31:	89 c8                	mov    %ecx,%eax
  802d33:	83 c4 10             	add    $0x10,%esp
  802d36:	5e                   	pop    %esi
  802d37:	5f                   	pop    %edi
  802d38:	5d                   	pop    %ebp
  802d39:	c3                   	ret    
  802d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802d40:	39 f8                	cmp    %edi,%eax
  802d42:	77 1c                	ja     802d60 <__udivdi3+0x70>
  802d44:	0f bd d0             	bsr    %eax,%edx
  802d47:	83 f2 1f             	xor    $0x1f,%edx
  802d4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d4d:	75 39                	jne    802d88 <__udivdi3+0x98>
  802d4f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802d52:	0f 86 a0 00 00 00    	jbe    802df8 <__udivdi3+0x108>
  802d58:	39 f8                	cmp    %edi,%eax
  802d5a:	0f 82 98 00 00 00    	jb     802df8 <__udivdi3+0x108>
  802d60:	31 ff                	xor    %edi,%edi
  802d62:	31 c9                	xor    %ecx,%ecx
  802d64:	89 c8                	mov    %ecx,%eax
  802d66:	89 fa                	mov    %edi,%edx
  802d68:	83 c4 10             	add    $0x10,%esp
  802d6b:	5e                   	pop    %esi
  802d6c:	5f                   	pop    %edi
  802d6d:	5d                   	pop    %ebp
  802d6e:	c3                   	ret    
  802d6f:	90                   	nop
  802d70:	89 d1                	mov    %edx,%ecx
  802d72:	89 fa                	mov    %edi,%edx
  802d74:	89 c8                	mov    %ecx,%eax
  802d76:	31 ff                	xor    %edi,%edi
  802d78:	f7 f6                	div    %esi
  802d7a:	89 c1                	mov    %eax,%ecx
  802d7c:	89 fa                	mov    %edi,%edx
  802d7e:	89 c8                	mov    %ecx,%eax
  802d80:	83 c4 10             	add    $0x10,%esp
  802d83:	5e                   	pop    %esi
  802d84:	5f                   	pop    %edi
  802d85:	5d                   	pop    %ebp
  802d86:	c3                   	ret    
  802d87:	90                   	nop
  802d88:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d8c:	89 f2                	mov    %esi,%edx
  802d8e:	d3 e0                	shl    %cl,%eax
  802d90:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d93:	b8 20 00 00 00       	mov    $0x20,%eax
  802d98:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802d9b:	89 c1                	mov    %eax,%ecx
  802d9d:	d3 ea                	shr    %cl,%edx
  802d9f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802da3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802da6:	d3 e6                	shl    %cl,%esi
  802da8:	89 c1                	mov    %eax,%ecx
  802daa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802dad:	89 fe                	mov    %edi,%esi
  802daf:	d3 ee                	shr    %cl,%esi
  802db1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802db5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802db8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802dbb:	d3 e7                	shl    %cl,%edi
  802dbd:	89 c1                	mov    %eax,%ecx
  802dbf:	d3 ea                	shr    %cl,%edx
  802dc1:	09 d7                	or     %edx,%edi
  802dc3:	89 f2                	mov    %esi,%edx
  802dc5:	89 f8                	mov    %edi,%eax
  802dc7:	f7 75 ec             	divl   -0x14(%ebp)
  802dca:	89 d6                	mov    %edx,%esi
  802dcc:	89 c7                	mov    %eax,%edi
  802dce:	f7 65 e8             	mull   -0x18(%ebp)
  802dd1:	39 d6                	cmp    %edx,%esi
  802dd3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802dd6:	72 30                	jb     802e08 <__udivdi3+0x118>
  802dd8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ddb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802ddf:	d3 e2                	shl    %cl,%edx
  802de1:	39 c2                	cmp    %eax,%edx
  802de3:	73 05                	jae    802dea <__udivdi3+0xfa>
  802de5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802de8:	74 1e                	je     802e08 <__udivdi3+0x118>
  802dea:	89 f9                	mov    %edi,%ecx
  802dec:	31 ff                	xor    %edi,%edi
  802dee:	e9 71 ff ff ff       	jmp    802d64 <__udivdi3+0x74>
  802df3:	90                   	nop
  802df4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802df8:	31 ff                	xor    %edi,%edi
  802dfa:	b9 01 00 00 00       	mov    $0x1,%ecx
  802dff:	e9 60 ff ff ff       	jmp    802d64 <__udivdi3+0x74>
  802e04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e08:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802e0b:	31 ff                	xor    %edi,%edi
  802e0d:	89 c8                	mov    %ecx,%eax
  802e0f:	89 fa                	mov    %edi,%edx
  802e11:	83 c4 10             	add    $0x10,%esp
  802e14:	5e                   	pop    %esi
  802e15:	5f                   	pop    %edi
  802e16:	5d                   	pop    %ebp
  802e17:	c3                   	ret    
	...

00802e20 <__umoddi3>:
  802e20:	55                   	push   %ebp
  802e21:	89 e5                	mov    %esp,%ebp
  802e23:	57                   	push   %edi
  802e24:	56                   	push   %esi
  802e25:	83 ec 20             	sub    $0x20,%esp
  802e28:	8b 55 14             	mov    0x14(%ebp),%edx
  802e2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e2e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802e31:	8b 75 0c             	mov    0xc(%ebp),%esi
  802e34:	85 d2                	test   %edx,%edx
  802e36:	89 c8                	mov    %ecx,%eax
  802e38:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802e3b:	75 13                	jne    802e50 <__umoddi3+0x30>
  802e3d:	39 f7                	cmp    %esi,%edi
  802e3f:	76 3f                	jbe    802e80 <__umoddi3+0x60>
  802e41:	89 f2                	mov    %esi,%edx
  802e43:	f7 f7                	div    %edi
  802e45:	89 d0                	mov    %edx,%eax
  802e47:	31 d2                	xor    %edx,%edx
  802e49:	83 c4 20             	add    $0x20,%esp
  802e4c:	5e                   	pop    %esi
  802e4d:	5f                   	pop    %edi
  802e4e:	5d                   	pop    %ebp
  802e4f:	c3                   	ret    
  802e50:	39 f2                	cmp    %esi,%edx
  802e52:	77 4c                	ja     802ea0 <__umoddi3+0x80>
  802e54:	0f bd ca             	bsr    %edx,%ecx
  802e57:	83 f1 1f             	xor    $0x1f,%ecx
  802e5a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802e5d:	75 51                	jne    802eb0 <__umoddi3+0x90>
  802e5f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802e62:	0f 87 e0 00 00 00    	ja     802f48 <__umoddi3+0x128>
  802e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6b:	29 f8                	sub    %edi,%eax
  802e6d:	19 d6                	sbb    %edx,%esi
  802e6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e75:	89 f2                	mov    %esi,%edx
  802e77:	83 c4 20             	add    $0x20,%esp
  802e7a:	5e                   	pop    %esi
  802e7b:	5f                   	pop    %edi
  802e7c:	5d                   	pop    %ebp
  802e7d:	c3                   	ret    
  802e7e:	66 90                	xchg   %ax,%ax
  802e80:	85 ff                	test   %edi,%edi
  802e82:	75 0b                	jne    802e8f <__umoddi3+0x6f>
  802e84:	b8 01 00 00 00       	mov    $0x1,%eax
  802e89:	31 d2                	xor    %edx,%edx
  802e8b:	f7 f7                	div    %edi
  802e8d:	89 c7                	mov    %eax,%edi
  802e8f:	89 f0                	mov    %esi,%eax
  802e91:	31 d2                	xor    %edx,%edx
  802e93:	f7 f7                	div    %edi
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	f7 f7                	div    %edi
  802e9a:	eb a9                	jmp    802e45 <__umoddi3+0x25>
  802e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ea0:	89 c8                	mov    %ecx,%eax
  802ea2:	89 f2                	mov    %esi,%edx
  802ea4:	83 c4 20             	add    $0x20,%esp
  802ea7:	5e                   	pop    %esi
  802ea8:	5f                   	pop    %edi
  802ea9:	5d                   	pop    %ebp
  802eaa:	c3                   	ret    
  802eab:	90                   	nop
  802eac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802eb0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802eb4:	d3 e2                	shl    %cl,%edx
  802eb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802eb9:	ba 20 00 00 00       	mov    $0x20,%edx
  802ebe:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802ec1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ec4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ec8:	89 fa                	mov    %edi,%edx
  802eca:	d3 ea                	shr    %cl,%edx
  802ecc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ed0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802ed3:	d3 e7                	shl    %cl,%edi
  802ed5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ed9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802edc:	89 f2                	mov    %esi,%edx
  802ede:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802ee1:	89 c7                	mov    %eax,%edi
  802ee3:	d3 ea                	shr    %cl,%edx
  802ee5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ee9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802eec:	89 c2                	mov    %eax,%edx
  802eee:	d3 e6                	shl    %cl,%esi
  802ef0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ef4:	d3 ea                	shr    %cl,%edx
  802ef6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802efa:	09 d6                	or     %edx,%esi
  802efc:	89 f0                	mov    %esi,%eax
  802efe:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802f01:	d3 e7                	shl    %cl,%edi
  802f03:	89 f2                	mov    %esi,%edx
  802f05:	f7 75 f4             	divl   -0xc(%ebp)
  802f08:	89 d6                	mov    %edx,%esi
  802f0a:	f7 65 e8             	mull   -0x18(%ebp)
  802f0d:	39 d6                	cmp    %edx,%esi
  802f0f:	72 2b                	jb     802f3c <__umoddi3+0x11c>
  802f11:	39 c7                	cmp    %eax,%edi
  802f13:	72 23                	jb     802f38 <__umoddi3+0x118>
  802f15:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802f19:	29 c7                	sub    %eax,%edi
  802f1b:	19 d6                	sbb    %edx,%esi
  802f1d:	89 f0                	mov    %esi,%eax
  802f1f:	89 f2                	mov    %esi,%edx
  802f21:	d3 ef                	shr    %cl,%edi
  802f23:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802f27:	d3 e0                	shl    %cl,%eax
  802f29:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802f2d:	09 f8                	or     %edi,%eax
  802f2f:	d3 ea                	shr    %cl,%edx
  802f31:	83 c4 20             	add    $0x20,%esp
  802f34:	5e                   	pop    %esi
  802f35:	5f                   	pop    %edi
  802f36:	5d                   	pop    %ebp
  802f37:	c3                   	ret    
  802f38:	39 d6                	cmp    %edx,%esi
  802f3a:	75 d9                	jne    802f15 <__umoddi3+0xf5>
  802f3c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802f3f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802f42:	eb d1                	jmp    802f15 <__umoddi3+0xf5>
  802f44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f48:	39 f2                	cmp    %esi,%edx
  802f4a:	0f 82 18 ff ff ff    	jb     802e68 <__umoddi3+0x48>
  802f50:	e9 1d ff ff ff       	jmp    802e72 <__umoddi3+0x52>
