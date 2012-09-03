
obj/user/testkbd:     file format elf32-i386


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
  80002c:	e8 9b 02 00 00       	call   8002cc <libmain>
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
  800037:	53                   	push   %ebx
  800038:	83 ec 14             	sub    $0x14,%esp
  80003b:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
		sys_yield();
  800040:	e8 40 13 00 00       	call   801385 <sys_yield>
umain(void)
{
	int i, r;

	// Spin for a bit to let the console quiet
	for (i = 0; i < 10; ++i)
  800045:	83 c3 01             	add    $0x1,%ebx
  800048:	83 fb 0a             	cmp    $0xa,%ebx
  80004b:	75 f3                	jne    800040 <umain+0xc>
		sys_yield();

	close(0);
  80004d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800054:	e8 55 18 00 00       	call   8018ae <close>
	if ((r = opencons()) < 0)
  800059:	e8 b2 01 00 00       	call   800210 <opencons>
  80005e:	85 c0                	test   %eax,%eax
  800060:	79 20                	jns    800082 <umain+0x4e>
		panic("opencons: %e", r);
  800062:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800066:	c7 44 24 08 00 2b 80 	movl   $0x802b00,0x8(%esp)
  80006d:	00 
  80006e:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800075:	00 
  800076:	c7 04 24 0d 2b 80 00 	movl   $0x802b0d,(%esp)
  80007d:	e8 b6 02 00 00       	call   800338 <_panic>
	if (r != 0)
  800082:	85 c0                	test   %eax,%eax
  800084:	74 20                	je     8000a6 <umain+0x72>
		panic("first opencons used fd %d", r);
  800086:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80008a:	c7 44 24 08 1c 2b 80 	movl   $0x802b1c,0x8(%esp)
  800091:	00 
  800092:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
  800099:	00 
  80009a:	c7 04 24 0d 2b 80 00 	movl   $0x802b0d,(%esp)
  8000a1:	e8 92 02 00 00       	call   800338 <_panic>
	if ((r = dup(0, 1)) < 0)
  8000a6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8000ad:	00 
  8000ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b5:	e8 93 18 00 00       	call   80194d <dup>
  8000ba:	85 c0                	test   %eax,%eax
  8000bc:	79 20                	jns    8000de <umain+0xaa>
		panic("dup: %e", r);
  8000be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000c2:	c7 44 24 08 36 2b 80 	movl   $0x802b36,0x8(%esp)
  8000c9:	00 
  8000ca:	c7 44 24 04 13 00 00 	movl   $0x13,0x4(%esp)
  8000d1:	00 
  8000d2:	c7 04 24 0d 2b 80 00 	movl   $0x802b0d,(%esp)
  8000d9:	e8 5a 02 00 00       	call   800338 <_panic>

	for(;;){
		char *buf;

		buf = readline("Type a line: ");
  8000de:	c7 04 24 3e 2b 80 00 	movl   $0x802b3e,(%esp)
  8000e5:	e8 a6 09 00 00       	call   800a90 <readline>
		if (buf != NULL)
  8000ea:	85 c0                	test   %eax,%eax
  8000ec:	74 1a                	je     800108 <umain+0xd4>
			fprintf(1, "%s\n", buf);
  8000ee:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000f2:	c7 44 24 04 4c 2b 80 	movl   $0x802b4c,0x4(%esp)
  8000f9:	00 
  8000fa:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800101:	e8 53 1d 00 00       	call   801e59 <fprintf>
  800106:	eb d6                	jmp    8000de <umain+0xaa>
		else
			fprintf(1, "(end of file received)\n");
  800108:	c7 44 24 04 50 2b 80 	movl   $0x802b50,0x4(%esp)
  80010f:	00 
  800110:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800117:	e8 3d 1d 00 00       	call   801e59 <fprintf>
  80011c:	eb c0                	jmp    8000de <umain+0xaa>
	...

00800120 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800120:	55                   	push   %ebp
  800121:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800123:	b8 00 00 00 00       	mov    $0x0,%eax
  800128:	5d                   	pop    %ebp
  800129:	c3                   	ret    

0080012a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80012a:	55                   	push   %ebp
  80012b:	89 e5                	mov    %esp,%ebp
  80012d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800130:	c7 44 24 04 68 2b 80 	movl   $0x802b68,0x4(%esp)
  800137:	00 
  800138:	8b 45 0c             	mov    0xc(%ebp),%eax
  80013b:	89 04 24             	mov    %eax,(%esp)
  80013e:	e8 87 0a 00 00       	call   800bca <strcpy>
	return 0;
}
  800143:	b8 00 00 00 00       	mov    $0x0,%eax
  800148:	c9                   	leave  
  800149:	c3                   	ret    

0080014a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	57                   	push   %edi
  80014e:	56                   	push   %esi
  80014f:	53                   	push   %ebx
  800150:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800156:	b8 00 00 00 00       	mov    $0x0,%eax
  80015b:	be 00 00 00 00       	mov    $0x0,%esi
  800160:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800164:	74 3f                	je     8001a5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800166:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80016c:	8b 55 10             	mov    0x10(%ebp),%edx
  80016f:	29 c2                	sub    %eax,%edx
  800171:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  800173:	83 fa 7f             	cmp    $0x7f,%edx
  800176:	76 05                	jbe    80017d <devcons_write+0x33>
  800178:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80017d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800181:	03 45 0c             	add    0xc(%ebp),%eax
  800184:	89 44 24 04          	mov    %eax,0x4(%esp)
  800188:	89 3c 24             	mov    %edi,(%esp)
  80018b:	e8 f5 0b 00 00       	call   800d85 <memmove>
		sys_cputs(buf, m);
  800190:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800194:	89 3c 24             	mov    %edi,(%esp)
  800197:	e8 24 0e 00 00       	call   800fc0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80019c:	01 de                	add    %ebx,%esi
  80019e:	89 f0                	mov    %esi,%eax
  8001a0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8001a3:	72 c7                	jb     80016c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8001a5:	89 f0                	mov    %esi,%eax
  8001a7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8001ad:	5b                   	pop    %ebx
  8001ae:	5e                   	pop    %esi
  8001af:	5f                   	pop    %edi
  8001b0:	5d                   	pop    %ebp
  8001b1:	c3                   	ret    

008001b2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8001b2:	55                   	push   %ebp
  8001b3:	89 e5                	mov    %esp,%ebp
  8001b5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8001b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001bb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8001be:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001c5:	00 
  8001c6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8001c9:	89 04 24             	mov    %eax,(%esp)
  8001cc:	e8 ef 0d 00 00       	call   800fc0 <sys_cputs>
}
  8001d1:	c9                   	leave  
  8001d2:	c3                   	ret    

008001d3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8001d3:	55                   	push   %ebp
  8001d4:	89 e5                	mov    %esp,%ebp
  8001d6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8001d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8001dd:	75 07                	jne    8001e6 <devcons_read+0x13>
  8001df:	eb 28                	jmp    800209 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8001e1:	e8 9f 11 00 00       	call   801385 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8001e6:	66 90                	xchg   %ax,%ax
  8001e8:	e8 9f 0d 00 00       	call   800f8c <sys_cgetc>
  8001ed:	85 c0                	test   %eax,%eax
  8001ef:	90                   	nop
  8001f0:	74 ef                	je     8001e1 <devcons_read+0xe>
  8001f2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8001f4:	85 c0                	test   %eax,%eax
  8001f6:	78 16                	js     80020e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8001f8:	83 f8 04             	cmp    $0x4,%eax
  8001fb:	74 0c                	je     800209 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8001fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800200:	88 10                	mov    %dl,(%eax)
  800202:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  800207:	eb 05                	jmp    80020e <devcons_read+0x3b>
  800209:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80020e:	c9                   	leave  
  80020f:	c3                   	ret    

00800210 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  800210:	55                   	push   %ebp
  800211:	89 e5                	mov    %esp,%ebp
  800213:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800216:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800219:	89 04 24             	mov    %eax,(%esp)
  80021c:	e8 5a 12 00 00       	call   80147b <fd_alloc>
  800221:	85 c0                	test   %eax,%eax
  800223:	78 3f                	js     800264 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800225:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80022c:	00 
  80022d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800230:	89 44 24 04          	mov    %eax,0x4(%esp)
  800234:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80023b:	e8 e6 10 00 00       	call   801326 <sys_page_alloc>
  800240:	85 c0                	test   %eax,%eax
  800242:	78 20                	js     800264 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800244:	8b 15 00 60 80 00    	mov    0x806000,%edx
  80024a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80024d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80024f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800252:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80025c:	89 04 24             	mov    %eax,(%esp)
  80025f:	e8 ec 11 00 00       	call   801450 <fd2num>
}
  800264:	c9                   	leave  
  800265:	c3                   	ret    

00800266 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800266:	55                   	push   %ebp
  800267:	89 e5                	mov    %esp,%ebp
  800269:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80026c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80026f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800273:	8b 45 08             	mov    0x8(%ebp),%eax
  800276:	89 04 24             	mov    %eax,(%esp)
  800279:	e8 6f 12 00 00       	call   8014ed <fd_lookup>
  80027e:	85 c0                	test   %eax,%eax
  800280:	78 11                	js     800293 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800285:	8b 00                	mov    (%eax),%eax
  800287:	3b 05 00 60 80 00    	cmp    0x806000,%eax
  80028d:	0f 94 c0             	sete   %al
  800290:	0f b6 c0             	movzbl %al,%eax
}
  800293:	c9                   	leave  
  800294:	c3                   	ret    

00800295 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80029b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8002a2:	00 
  8002a3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002b1:	e8 98 14 00 00       	call   80174e <read>
	if (r < 0)
  8002b6:	85 c0                	test   %eax,%eax
  8002b8:	78 0f                	js     8002c9 <getchar+0x34>
		return r;
	if (r < 1)
  8002ba:	85 c0                	test   %eax,%eax
  8002bc:	7f 07                	jg     8002c5 <getchar+0x30>
  8002be:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8002c3:	eb 04                	jmp    8002c9 <getchar+0x34>
		return -E_EOF;
	return c;
  8002c5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8002c9:	c9                   	leave  
  8002ca:	c3                   	ret    
	...

008002cc <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002cc:	55                   	push   %ebp
  8002cd:	89 e5                	mov    %esp,%ebp
  8002cf:	83 ec 18             	sub    $0x18,%esp
  8002d2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8002d5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8002d8:	8b 75 08             	mov    0x8(%ebp),%esi
  8002db:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  8002de:	e8 d6 10 00 00       	call   8013b9 <sys_getenvid>
  8002e3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8002e8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8002eb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002f0:	a3 80 64 80 00       	mov    %eax,0x806480

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002f5:	85 f6                	test   %esi,%esi
  8002f7:	7e 07                	jle    800300 <libmain+0x34>
		binaryname = argv[0];
  8002f9:	8b 03                	mov    (%ebx),%eax
  8002fb:	a3 1c 60 80 00       	mov    %eax,0x80601c

	// call user main routine
	umain(argc, argv);
  800300:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800304:	89 34 24             	mov    %esi,(%esp)
  800307:	e8 28 fd ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80030c:	e8 0b 00 00 00       	call   80031c <exit>
}
  800311:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800314:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800317:	89 ec                	mov    %ebp,%esp
  800319:	5d                   	pop    %ebp
  80031a:	c3                   	ret    
	...

0080031c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800322:	e8 04 16 00 00       	call   80192b <close_all>
	sys_env_destroy(0);
  800327:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80032e:	e8 ba 10 00 00       	call   8013ed <sys_env_destroy>
}
  800333:	c9                   	leave  
  800334:	c3                   	ret    
  800335:	00 00                	add    %al,(%eax)
	...

00800338 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	53                   	push   %ebx
  80033c:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  80033f:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800342:	a1 84 64 80 00       	mov    0x806484,%eax
  800347:	85 c0                	test   %eax,%eax
  800349:	74 10                	je     80035b <_panic+0x23>
		cprintf("%s: ", argv0);
  80034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80034f:	c7 04 24 8b 2b 80 00 	movl   $0x802b8b,(%esp)
  800356:	e8 a2 00 00 00       	call   8003fd <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80035b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80035e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800362:	8b 45 08             	mov    0x8(%ebp),%eax
  800365:	89 44 24 08          	mov    %eax,0x8(%esp)
  800369:	a1 1c 60 80 00       	mov    0x80601c,%eax
  80036e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800372:	c7 04 24 90 2b 80 00 	movl   $0x802b90,(%esp)
  800379:	e8 7f 00 00 00       	call   8003fd <cprintf>
	vcprintf(fmt, ap);
  80037e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800382:	8b 45 10             	mov    0x10(%ebp),%eax
  800385:	89 04 24             	mov    %eax,(%esp)
  800388:	e8 0f 00 00 00       	call   80039c <vcprintf>
	cprintf("\n");
  80038d:	c7 04 24 66 2b 80 00 	movl   $0x802b66,(%esp)
  800394:	e8 64 00 00 00       	call   8003fd <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800399:	cc                   	int3   
  80039a:	eb fd                	jmp    800399 <_panic+0x61>

0080039c <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003a5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ac:	00 00 00 
	b.cnt = 0;
  8003af:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003b6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003c7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8003cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003d1:	c7 04 24 17 04 80 00 	movl   $0x800417,(%esp)
  8003d8:	e8 d0 01 00 00       	call   8005ad <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8003dd:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8003e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003e7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8003ed:	89 04 24             	mov    %eax,(%esp)
  8003f0:	e8 cb 0b 00 00       	call   800fc0 <sys_cputs>

	return b.cnt;
}
  8003f5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8003fb:	c9                   	leave  
  8003fc:	c3                   	ret    

008003fd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8003fd:	55                   	push   %ebp
  8003fe:	89 e5                	mov    %esp,%ebp
  800400:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800403:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800406:	89 44 24 04          	mov    %eax,0x4(%esp)
  80040a:	8b 45 08             	mov    0x8(%ebp),%eax
  80040d:	89 04 24             	mov    %eax,(%esp)
  800410:	e8 87 ff ff ff       	call   80039c <vcprintf>
	va_end(ap);

	return cnt;
}
  800415:	c9                   	leave  
  800416:	c3                   	ret    

00800417 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800417:	55                   	push   %ebp
  800418:	89 e5                	mov    %esp,%ebp
  80041a:	53                   	push   %ebx
  80041b:	83 ec 14             	sub    $0x14,%esp
  80041e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800421:	8b 03                	mov    (%ebx),%eax
  800423:	8b 55 08             	mov    0x8(%ebp),%edx
  800426:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80042a:	83 c0 01             	add    $0x1,%eax
  80042d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80042f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800434:	75 19                	jne    80044f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800436:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80043d:	00 
  80043e:	8d 43 08             	lea    0x8(%ebx),%eax
  800441:	89 04 24             	mov    %eax,(%esp)
  800444:	e8 77 0b 00 00       	call   800fc0 <sys_cputs>
		b->idx = 0;
  800449:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80044f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800453:	83 c4 14             	add    $0x14,%esp
  800456:	5b                   	pop    %ebx
  800457:	5d                   	pop    %ebp
  800458:	c3                   	ret    
  800459:	00 00                	add    %al,(%eax)
  80045b:	00 00                	add    %al,(%eax)
  80045d:	00 00                	add    %al,(%eax)
	...

00800460 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800460:	55                   	push   %ebp
  800461:	89 e5                	mov    %esp,%ebp
  800463:	57                   	push   %edi
  800464:	56                   	push   %esi
  800465:	53                   	push   %ebx
  800466:	83 ec 4c             	sub    $0x4c,%esp
  800469:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80046c:	89 d6                	mov    %edx,%esi
  80046e:	8b 45 08             	mov    0x8(%ebp),%eax
  800471:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800474:	8b 55 0c             	mov    0xc(%ebp),%edx
  800477:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80047a:	8b 45 10             	mov    0x10(%ebp),%eax
  80047d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800480:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800483:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800486:	b9 00 00 00 00       	mov    $0x0,%ecx
  80048b:	39 d1                	cmp    %edx,%ecx
  80048d:	72 15                	jb     8004a4 <printnum+0x44>
  80048f:	77 07                	ja     800498 <printnum+0x38>
  800491:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800494:	39 d0                	cmp    %edx,%eax
  800496:	76 0c                	jbe    8004a4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800498:	83 eb 01             	sub    $0x1,%ebx
  80049b:	85 db                	test   %ebx,%ebx
  80049d:	8d 76 00             	lea    0x0(%esi),%esi
  8004a0:	7f 61                	jg     800503 <printnum+0xa3>
  8004a2:	eb 70                	jmp    800514 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004a4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8004a8:	83 eb 01             	sub    $0x1,%ebx
  8004ab:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004af:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004b3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8004b7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8004bb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8004be:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8004c1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8004c4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8004c8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004cf:	00 
  8004d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004d3:	89 04 24             	mov    %eax,(%esp)
  8004d6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004dd:	e8 9e 23 00 00       	call   802880 <__udivdi3>
  8004e2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8004e5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8004e8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8004ec:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004f0:	89 04 24             	mov    %eax,(%esp)
  8004f3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004f7:	89 f2                	mov    %esi,%edx
  8004f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004fc:	e8 5f ff ff ff       	call   800460 <printnum>
  800501:	eb 11                	jmp    800514 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800503:	89 74 24 04          	mov    %esi,0x4(%esp)
  800507:	89 3c 24             	mov    %edi,(%esp)
  80050a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80050d:	83 eb 01             	sub    $0x1,%ebx
  800510:	85 db                	test   %ebx,%ebx
  800512:	7f ef                	jg     800503 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800514:	89 74 24 04          	mov    %esi,0x4(%esp)
  800518:	8b 74 24 04          	mov    0x4(%esp),%esi
  80051c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80051f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800523:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80052a:	00 
  80052b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80052e:	89 14 24             	mov    %edx,(%esp)
  800531:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800534:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800538:	e8 73 24 00 00       	call   8029b0 <__umoddi3>
  80053d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800541:	0f be 80 ac 2b 80 00 	movsbl 0x802bac(%eax),%eax
  800548:	89 04 24             	mov    %eax,(%esp)
  80054b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80054e:	83 c4 4c             	add    $0x4c,%esp
  800551:	5b                   	pop    %ebx
  800552:	5e                   	pop    %esi
  800553:	5f                   	pop    %edi
  800554:	5d                   	pop    %ebp
  800555:	c3                   	ret    

00800556 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800559:	83 fa 01             	cmp    $0x1,%edx
  80055c:	7e 0e                	jle    80056c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80055e:	8b 10                	mov    (%eax),%edx
  800560:	8d 4a 08             	lea    0x8(%edx),%ecx
  800563:	89 08                	mov    %ecx,(%eax)
  800565:	8b 02                	mov    (%edx),%eax
  800567:	8b 52 04             	mov    0x4(%edx),%edx
  80056a:	eb 22                	jmp    80058e <getuint+0x38>
	else if (lflag)
  80056c:	85 d2                	test   %edx,%edx
  80056e:	74 10                	je     800580 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800570:	8b 10                	mov    (%eax),%edx
  800572:	8d 4a 04             	lea    0x4(%edx),%ecx
  800575:	89 08                	mov    %ecx,(%eax)
  800577:	8b 02                	mov    (%edx),%eax
  800579:	ba 00 00 00 00       	mov    $0x0,%edx
  80057e:	eb 0e                	jmp    80058e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800580:	8b 10                	mov    (%eax),%edx
  800582:	8d 4a 04             	lea    0x4(%edx),%ecx
  800585:	89 08                	mov    %ecx,(%eax)
  800587:	8b 02                	mov    (%edx),%eax
  800589:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80058e:	5d                   	pop    %ebp
  80058f:	c3                   	ret    

00800590 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800596:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80059a:	8b 10                	mov    (%eax),%edx
  80059c:	3b 50 04             	cmp    0x4(%eax),%edx
  80059f:	73 0a                	jae    8005ab <sprintputch+0x1b>
		*b->buf++ = ch;
  8005a1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005a4:	88 0a                	mov    %cl,(%edx)
  8005a6:	83 c2 01             	add    $0x1,%edx
  8005a9:	89 10                	mov    %edx,(%eax)
}
  8005ab:	5d                   	pop    %ebp
  8005ac:	c3                   	ret    

008005ad <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	57                   	push   %edi
  8005b1:	56                   	push   %esi
  8005b2:	53                   	push   %ebx
  8005b3:	83 ec 5c             	sub    $0x5c,%esp
  8005b6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8005b9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005bf:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8005c6:	eb 11                	jmp    8005d9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8005c8:	85 c0                	test   %eax,%eax
  8005ca:	0f 84 09 04 00 00    	je     8009d9 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  8005d0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005d4:	89 04 24             	mov    %eax,(%esp)
  8005d7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8005d9:	0f b6 03             	movzbl (%ebx),%eax
  8005dc:	83 c3 01             	add    $0x1,%ebx
  8005df:	83 f8 25             	cmp    $0x25,%eax
  8005e2:	75 e4                	jne    8005c8 <vprintfmt+0x1b>
  8005e4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8005e8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8005ef:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8005f6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8005fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800602:	eb 06                	jmp    80060a <vprintfmt+0x5d>
  800604:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800608:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80060a:	0f b6 13             	movzbl (%ebx),%edx
  80060d:	0f b6 c2             	movzbl %dl,%eax
  800610:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800613:	8d 43 01             	lea    0x1(%ebx),%eax
  800616:	83 ea 23             	sub    $0x23,%edx
  800619:	80 fa 55             	cmp    $0x55,%dl
  80061c:	0f 87 9a 03 00 00    	ja     8009bc <vprintfmt+0x40f>
  800622:	0f b6 d2             	movzbl %dl,%edx
  800625:	ff 24 95 e0 2c 80 00 	jmp    *0x802ce0(,%edx,4)
  80062c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800630:	eb d6                	jmp    800608 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800632:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800635:	83 ea 30             	sub    $0x30,%edx
  800638:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  80063b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80063e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800641:	83 fb 09             	cmp    $0x9,%ebx
  800644:	77 4c                	ja     800692 <vprintfmt+0xe5>
  800646:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800649:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80064c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80064f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800652:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800656:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800659:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80065c:	83 fb 09             	cmp    $0x9,%ebx
  80065f:	76 eb                	jbe    80064c <vprintfmt+0x9f>
  800661:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800664:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800667:	eb 29                	jmp    800692 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800669:	8b 55 14             	mov    0x14(%ebp),%edx
  80066c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80066f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800672:	8b 12                	mov    (%edx),%edx
  800674:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  800677:	eb 19                	jmp    800692 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800679:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80067c:	c1 fa 1f             	sar    $0x1f,%edx
  80067f:	f7 d2                	not    %edx
  800681:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800684:	eb 82                	jmp    800608 <vprintfmt+0x5b>
  800686:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80068d:	e9 76 ff ff ff       	jmp    800608 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800692:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800696:	0f 89 6c ff ff ff    	jns    800608 <vprintfmt+0x5b>
  80069c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80069f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006a2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8006a5:	89 55 cc             	mov    %edx,-0x34(%ebp)
  8006a8:	e9 5b ff ff ff       	jmp    800608 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006ad:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8006b0:	e9 53 ff ff ff       	jmp    800608 <vprintfmt+0x5b>
  8006b5:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bb:	8d 50 04             	lea    0x4(%eax),%edx
  8006be:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	89 04 24             	mov    %eax,(%esp)
  8006ca:	ff d7                	call   *%edi
  8006cc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8006cf:	e9 05 ff ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  8006d4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8006d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006da:	8d 50 04             	lea    0x4(%eax),%edx
  8006dd:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	89 c2                	mov    %eax,%edx
  8006e4:	c1 fa 1f             	sar    $0x1f,%edx
  8006e7:	31 d0                	xor    %edx,%eax
  8006e9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006eb:	83 f8 0f             	cmp    $0xf,%eax
  8006ee:	7f 0b                	jg     8006fb <vprintfmt+0x14e>
  8006f0:	8b 14 85 40 2e 80 00 	mov    0x802e40(,%eax,4),%edx
  8006f7:	85 d2                	test   %edx,%edx
  8006f9:	75 20                	jne    80071b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8006fb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006ff:	c7 44 24 08 bd 2b 80 	movl   $0x802bbd,0x8(%esp)
  800706:	00 
  800707:	89 74 24 04          	mov    %esi,0x4(%esp)
  80070b:	89 3c 24             	mov    %edi,(%esp)
  80070e:	e8 4e 03 00 00       	call   800a61 <printfmt>
  800713:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800716:	e9 be fe ff ff       	jmp    8005d9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80071b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80071f:	c7 44 24 08 9d 2f 80 	movl   $0x802f9d,0x8(%esp)
  800726:	00 
  800727:	89 74 24 04          	mov    %esi,0x4(%esp)
  80072b:	89 3c 24             	mov    %edi,(%esp)
  80072e:	e8 2e 03 00 00       	call   800a61 <printfmt>
  800733:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800736:	e9 9e fe ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  80073b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80073e:	89 c3                	mov    %eax,%ebx
  800740:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800746:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800749:	8b 45 14             	mov    0x14(%ebp),%eax
  80074c:	8d 50 04             	lea    0x4(%eax),%edx
  80074f:	89 55 14             	mov    %edx,0x14(%ebp)
  800752:	8b 00                	mov    (%eax),%eax
  800754:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800757:	85 c0                	test   %eax,%eax
  800759:	75 07                	jne    800762 <vprintfmt+0x1b5>
  80075b:	c7 45 c4 c6 2b 80 00 	movl   $0x802bc6,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800762:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  800766:	7e 06                	jle    80076e <vprintfmt+0x1c1>
  800768:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80076c:	75 13                	jne    800781 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800771:	0f be 02             	movsbl (%edx),%eax
  800774:	85 c0                	test   %eax,%eax
  800776:	0f 85 99 00 00 00    	jne    800815 <vprintfmt+0x268>
  80077c:	e9 86 00 00 00       	jmp    800807 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800781:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800785:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800788:	89 0c 24             	mov    %ecx,(%esp)
  80078b:	e8 0b 04 00 00       	call   800b9b <strnlen>
  800790:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800793:	29 c2                	sub    %eax,%edx
  800795:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800798:	85 d2                	test   %edx,%edx
  80079a:	7e d2                	jle    80076e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80079c:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  8007a0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007a3:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  8007a6:	89 d3                	mov    %edx,%ebx
  8007a8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007af:	89 04 24             	mov    %eax,(%esp)
  8007b2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b4:	83 eb 01             	sub    $0x1,%ebx
  8007b7:	85 db                	test   %ebx,%ebx
  8007b9:	7f ed                	jg     8007a8 <vprintfmt+0x1fb>
  8007bb:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8007be:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8007c5:	eb a7                	jmp    80076e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007c7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007cb:	74 18                	je     8007e5 <vprintfmt+0x238>
  8007cd:	8d 50 e0             	lea    -0x20(%eax),%edx
  8007d0:	83 fa 5e             	cmp    $0x5e,%edx
  8007d3:	76 10                	jbe    8007e5 <vprintfmt+0x238>
					putch('?', putdat);
  8007d5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007d9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007e0:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007e3:	eb 0a                	jmp    8007ef <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8007e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8007e9:	89 04 24             	mov    %eax,(%esp)
  8007ec:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007ef:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8007f3:	0f be 03             	movsbl (%ebx),%eax
  8007f6:	85 c0                	test   %eax,%eax
  8007f8:	74 05                	je     8007ff <vprintfmt+0x252>
  8007fa:	83 c3 01             	add    $0x1,%ebx
  8007fd:	eb 29                	jmp    800828 <vprintfmt+0x27b>
  8007ff:	89 fe                	mov    %edi,%esi
  800801:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800804:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800807:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080b:	7f 2e                	jg     80083b <vprintfmt+0x28e>
  80080d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800810:	e9 c4 fd ff ff       	jmp    8005d9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800815:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800818:	83 c2 01             	add    $0x1,%edx
  80081b:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80081e:	89 f7                	mov    %esi,%edi
  800820:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800823:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  800826:	89 d3                	mov    %edx,%ebx
  800828:	85 f6                	test   %esi,%esi
  80082a:	78 9b                	js     8007c7 <vprintfmt+0x21a>
  80082c:	83 ee 01             	sub    $0x1,%esi
  80082f:	79 96                	jns    8007c7 <vprintfmt+0x21a>
  800831:	89 fe                	mov    %edi,%esi
  800833:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800836:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800839:	eb cc                	jmp    800807 <vprintfmt+0x25a>
  80083b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  80083e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800841:	89 74 24 04          	mov    %esi,0x4(%esp)
  800845:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80084c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80084e:	83 eb 01             	sub    $0x1,%ebx
  800851:	85 db                	test   %ebx,%ebx
  800853:	7f ec                	jg     800841 <vprintfmt+0x294>
  800855:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800858:	e9 7c fd ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  80085d:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800860:	83 f9 01             	cmp    $0x1,%ecx
  800863:	7e 16                	jle    80087b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800865:	8b 45 14             	mov    0x14(%ebp),%eax
  800868:	8d 50 08             	lea    0x8(%eax),%edx
  80086b:	89 55 14             	mov    %edx,0x14(%ebp)
  80086e:	8b 10                	mov    (%eax),%edx
  800870:	8b 48 04             	mov    0x4(%eax),%ecx
  800873:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800876:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800879:	eb 32                	jmp    8008ad <vprintfmt+0x300>
	else if (lflag)
  80087b:	85 c9                	test   %ecx,%ecx
  80087d:	74 18                	je     800897 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	8d 50 04             	lea    0x4(%eax),%edx
  800885:	89 55 14             	mov    %edx,0x14(%ebp)
  800888:	8b 00                	mov    (%eax),%eax
  80088a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80088d:	89 c1                	mov    %eax,%ecx
  80088f:	c1 f9 1f             	sar    $0x1f,%ecx
  800892:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800895:	eb 16                	jmp    8008ad <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800897:	8b 45 14             	mov    0x14(%ebp),%eax
  80089a:	8d 50 04             	lea    0x4(%eax),%edx
  80089d:	89 55 14             	mov    %edx,0x14(%ebp)
  8008a0:	8b 00                	mov    (%eax),%eax
  8008a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008a5:	89 c2                	mov    %eax,%edx
  8008a7:	c1 fa 1f             	sar    $0x1f,%edx
  8008aa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008ad:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8008b0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8008b3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8008b8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008bc:	0f 89 b8 00 00 00    	jns    80097a <vprintfmt+0x3cd>
				putch('-', putdat);
  8008c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008c6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008cd:	ff d7                	call   *%edi
				num = -(long long) num;
  8008cf:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8008d2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8008d5:	f7 d9                	neg    %ecx
  8008d7:	83 d3 00             	adc    $0x0,%ebx
  8008da:	f7 db                	neg    %ebx
  8008dc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008e1:	e9 94 00 00 00       	jmp    80097a <vprintfmt+0x3cd>
  8008e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008e9:	89 ca                	mov    %ecx,%edx
  8008eb:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ee:	e8 63 fc ff ff       	call   800556 <getuint>
  8008f3:	89 c1                	mov    %eax,%ecx
  8008f5:	89 d3                	mov    %edx,%ebx
  8008f7:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8008fc:	eb 7c                	jmp    80097a <vprintfmt+0x3cd>
  8008fe:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800901:	89 74 24 04          	mov    %esi,0x4(%esp)
  800905:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  80090c:	ff d7                	call   *%edi
			putch('X', putdat);
  80090e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800912:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800919:	ff d7                	call   *%edi
			putch('X', putdat);
  80091b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80091f:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800926:	ff d7                	call   *%edi
  800928:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80092b:	e9 a9 fc ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  800930:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800933:	89 74 24 04          	mov    %esi,0x4(%esp)
  800937:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80093e:	ff d7                	call   *%edi
			putch('x', putdat);
  800940:	89 74 24 04          	mov    %esi,0x4(%esp)
  800944:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80094b:	ff d7                	call   *%edi
			num = (unsigned long long)
  80094d:	8b 45 14             	mov    0x14(%ebp),%eax
  800950:	8d 50 04             	lea    0x4(%eax),%edx
  800953:	89 55 14             	mov    %edx,0x14(%ebp)
  800956:	8b 08                	mov    (%eax),%ecx
  800958:	bb 00 00 00 00       	mov    $0x0,%ebx
  80095d:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800962:	eb 16                	jmp    80097a <vprintfmt+0x3cd>
  800964:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800967:	89 ca                	mov    %ecx,%edx
  800969:	8d 45 14             	lea    0x14(%ebp),%eax
  80096c:	e8 e5 fb ff ff       	call   800556 <getuint>
  800971:	89 c1                	mov    %eax,%ecx
  800973:	89 d3                	mov    %edx,%ebx
  800975:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80097a:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  80097e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800982:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800985:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800989:	89 44 24 08          	mov    %eax,0x8(%esp)
  80098d:	89 0c 24             	mov    %ecx,(%esp)
  800990:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800994:	89 f2                	mov    %esi,%edx
  800996:	89 f8                	mov    %edi,%eax
  800998:	e8 c3 fa ff ff       	call   800460 <printnum>
  80099d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8009a0:	e9 34 fc ff ff       	jmp    8005d9 <vprintfmt+0x2c>
  8009a5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009ab:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009af:	89 14 24             	mov    %edx,(%esp)
  8009b2:	ff d7                	call   *%edi
  8009b4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8009b7:	e9 1d fc ff ff       	jmp    8005d9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009c0:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009c7:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009c9:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8009cc:	80 38 25             	cmpb   $0x25,(%eax)
  8009cf:	0f 84 04 fc ff ff    	je     8005d9 <vprintfmt+0x2c>
  8009d5:	89 c3                	mov    %eax,%ebx
  8009d7:	eb f0                	jmp    8009c9 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  8009d9:	83 c4 5c             	add    $0x5c,%esp
  8009dc:	5b                   	pop    %ebx
  8009dd:	5e                   	pop    %esi
  8009de:	5f                   	pop    %edi
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    

008009e1 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8009e1:	55                   	push   %ebp
  8009e2:	89 e5                	mov    %esp,%ebp
  8009e4:	83 ec 28             	sub    $0x28,%esp
  8009e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ea:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  8009ed:	85 c0                	test   %eax,%eax
  8009ef:	74 04                	je     8009f5 <vsnprintf+0x14>
  8009f1:	85 d2                	test   %edx,%edx
  8009f3:	7f 07                	jg     8009fc <vsnprintf+0x1b>
  8009f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8009fa:	eb 3b                	jmp    800a37 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8009fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8009ff:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800a03:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a0d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a10:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a14:	8b 45 10             	mov    0x10(%ebp),%eax
  800a17:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a1b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a22:	c7 04 24 90 05 80 00 	movl   $0x800590,(%esp)
  800a29:	e8 7f fb ff ff       	call   8005ad <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a31:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a37:	c9                   	leave  
  800a38:	c3                   	ret    

00800a39 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800a3f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800a42:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a46:	8b 45 10             	mov    0x10(%ebp),%eax
  800a49:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a50:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a54:	8b 45 08             	mov    0x8(%ebp),%eax
  800a57:	89 04 24             	mov    %eax,(%esp)
  800a5a:	e8 82 ff ff ff       	call   8009e1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a5f:	c9                   	leave  
  800a60:	c3                   	ret    

00800a61 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a61:	55                   	push   %ebp
  800a62:	89 e5                	mov    %esp,%ebp
  800a64:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800a67:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800a6a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a6e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a71:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a78:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7f:	89 04 24             	mov    %eax,(%esp)
  800a82:	e8 26 fb ff ff       	call   8005ad <vprintfmt>
	va_end(ap);
}
  800a87:	c9                   	leave  
  800a88:	c3                   	ret    
  800a89:	00 00                	add    %al,(%eax)
  800a8b:	00 00                	add    %al,(%eax)
  800a8d:	00 00                	add    %al,(%eax)
	...

00800a90 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800a90:	55                   	push   %ebp
  800a91:	89 e5                	mov    %esp,%ebp
  800a93:	57                   	push   %edi
  800a94:	56                   	push   %esi
  800a95:	53                   	push   %ebx
  800a96:	83 ec 1c             	sub    $0x1c,%esp
  800a99:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  800a9c:	85 c0                	test   %eax,%eax
  800a9e:	74 18                	je     800ab8 <readline+0x28>
		fprintf(1, "%s", prompt);
  800aa0:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aa4:	c7 44 24 04 9d 2f 80 	movl   $0x802f9d,0x4(%esp)
  800aab:	00 
  800aac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800ab3:	e8 a1 13 00 00       	call   801e59 <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  800ab8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800abf:	e8 a2 f7 ff ff       	call   800266 <iscons>
  800ac4:	89 c7                	mov    %eax,%edi
  800ac6:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		c = getchar();
  800acb:	e8 c5 f7 ff ff       	call   800295 <getchar>
  800ad0:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  800ad2:	85 c0                	test   %eax,%eax
  800ad4:	79 25                	jns    800afb <readline+0x6b>
			if (c != -E_EOF)
  800ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  800adb:	83 fb f8             	cmp    $0xfffffff8,%ebx
  800ade:	0f 84 8f 00 00 00    	je     800b73 <readline+0xe3>
				cprintf("read error: %e\n", c);
  800ae4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ae8:	c7 04 24 9f 2e 80 00 	movl   $0x802e9f,(%esp)
  800aef:	e8 09 f9 ff ff       	call   8003fd <cprintf>
  800af4:	b8 00 00 00 00       	mov    $0x0,%eax
  800af9:	eb 78                	jmp    800b73 <readline+0xe3>
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800afb:	83 f8 08             	cmp    $0x8,%eax
  800afe:	74 05                	je     800b05 <readline+0x75>
  800b00:	83 f8 7f             	cmp    $0x7f,%eax
  800b03:	75 1e                	jne    800b23 <readline+0x93>
  800b05:	85 f6                	test   %esi,%esi
  800b07:	7e 1a                	jle    800b23 <readline+0x93>
			if (echoing)
  800b09:	85 ff                	test   %edi,%edi
  800b0b:	90                   	nop
  800b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800b10:	74 0c                	je     800b1e <readline+0x8e>
				cputchar('\b');
  800b12:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  800b19:	e8 94 f6 ff ff       	call   8001b2 <cputchar>
			i--;
  800b1e:	83 ee 01             	sub    $0x1,%esi
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800b21:	eb a8                	jmp    800acb <readline+0x3b>
			if (echoing)
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
  800b23:	83 fb 1f             	cmp    $0x1f,%ebx
  800b26:	7e 21                	jle    800b49 <readline+0xb9>
  800b28:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  800b2e:	66 90                	xchg   %ax,%ax
  800b30:	7f 17                	jg     800b49 <readline+0xb9>
			if (echoing)
  800b32:	85 ff                	test   %edi,%edi
  800b34:	74 08                	je     800b3e <readline+0xae>
				cputchar(c);
  800b36:	89 1c 24             	mov    %ebx,(%esp)
  800b39:	e8 74 f6 ff ff       	call   8001b2 <cputchar>
			buf[i++] = c;
  800b3e:	88 9e 80 60 80 00    	mov    %bl,0x806080(%esi)
  800b44:	83 c6 01             	add    $0x1,%esi
  800b47:	eb 82                	jmp    800acb <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  800b49:	83 fb 0a             	cmp    $0xa,%ebx
  800b4c:	74 09                	je     800b57 <readline+0xc7>
  800b4e:	83 fb 0d             	cmp    $0xd,%ebx
  800b51:	0f 85 74 ff ff ff    	jne    800acb <readline+0x3b>
			if (echoing)
  800b57:	85 ff                	test   %edi,%edi
  800b59:	74 0c                	je     800b67 <readline+0xd7>
				cputchar('\n');
  800b5b:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800b62:	e8 4b f6 ff ff       	call   8001b2 <cputchar>
			buf[i] = 0;
  800b67:	c6 86 80 60 80 00 00 	movb   $0x0,0x806080(%esi)
  800b6e:	b8 80 60 80 00       	mov    $0x806080,%eax
			return buf;
		}
	}
}
  800b73:	83 c4 1c             	add    $0x1c,%esp
  800b76:	5b                   	pop    %ebx
  800b77:	5e                   	pop    %esi
  800b78:	5f                   	pop    %edi
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    
  800b7b:	00 00                	add    %al,(%eax)
  800b7d:	00 00                	add    %al,(%eax)
	...

00800b80 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b80:	55                   	push   %ebp
  800b81:	89 e5                	mov    %esp,%ebp
  800b83:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b86:	b8 00 00 00 00       	mov    $0x0,%eax
  800b8b:	80 3a 00             	cmpb   $0x0,(%edx)
  800b8e:	74 09                	je     800b99 <strlen+0x19>
		n++;
  800b90:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b93:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b97:	75 f7                	jne    800b90 <strlen+0x10>
		n++;
	return n;
}
  800b99:	5d                   	pop    %ebp
  800b9a:	c3                   	ret    

00800b9b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	53                   	push   %ebx
  800b9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ba2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ba5:	85 c9                	test   %ecx,%ecx
  800ba7:	74 19                	je     800bc2 <strnlen+0x27>
  800ba9:	80 3b 00             	cmpb   $0x0,(%ebx)
  800bac:	74 14                	je     800bc2 <strnlen+0x27>
  800bae:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800bb3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bb6:	39 c8                	cmp    %ecx,%eax
  800bb8:	74 0d                	je     800bc7 <strnlen+0x2c>
  800bba:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800bbe:	75 f3                	jne    800bb3 <strnlen+0x18>
  800bc0:	eb 05                	jmp    800bc7 <strnlen+0x2c>
  800bc2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	53                   	push   %ebx
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bd4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bd9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bdd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800be0:	83 c2 01             	add    $0x1,%edx
  800be3:	84 c9                	test   %cl,%cl
  800be5:	75 f2                	jne    800bd9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800be7:	5b                   	pop    %ebx
  800be8:	5d                   	pop    %ebp
  800be9:	c3                   	ret    

00800bea <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	56                   	push   %esi
  800bee:	53                   	push   %ebx
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bf8:	85 f6                	test   %esi,%esi
  800bfa:	74 18                	je     800c14 <strncpy+0x2a>
  800bfc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800c01:	0f b6 1a             	movzbl (%edx),%ebx
  800c04:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c07:	80 3a 01             	cmpb   $0x1,(%edx)
  800c0a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c0d:	83 c1 01             	add    $0x1,%ecx
  800c10:	39 ce                	cmp    %ecx,%esi
  800c12:	77 ed                	ja     800c01 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800c14:	5b                   	pop    %ebx
  800c15:	5e                   	pop    %esi
  800c16:	5d                   	pop    %ebp
  800c17:	c3                   	ret    

00800c18 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c18:	55                   	push   %ebp
  800c19:	89 e5                	mov    %esp,%ebp
  800c1b:	56                   	push   %esi
  800c1c:	53                   	push   %ebx
  800c1d:	8b 75 08             	mov    0x8(%ebp),%esi
  800c20:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c23:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c26:	89 f0                	mov    %esi,%eax
  800c28:	85 c9                	test   %ecx,%ecx
  800c2a:	74 27                	je     800c53 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800c2c:	83 e9 01             	sub    $0x1,%ecx
  800c2f:	74 1d                	je     800c4e <strlcpy+0x36>
  800c31:	0f b6 1a             	movzbl (%edx),%ebx
  800c34:	84 db                	test   %bl,%bl
  800c36:	74 16                	je     800c4e <strlcpy+0x36>
			*dst++ = *src++;
  800c38:	88 18                	mov    %bl,(%eax)
  800c3a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c3d:	83 e9 01             	sub    $0x1,%ecx
  800c40:	74 0e                	je     800c50 <strlcpy+0x38>
			*dst++ = *src++;
  800c42:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c45:	0f b6 1a             	movzbl (%edx),%ebx
  800c48:	84 db                	test   %bl,%bl
  800c4a:	75 ec                	jne    800c38 <strlcpy+0x20>
  800c4c:	eb 02                	jmp    800c50 <strlcpy+0x38>
  800c4e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800c50:	c6 00 00             	movb   $0x0,(%eax)
  800c53:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800c55:	5b                   	pop    %ebx
  800c56:	5e                   	pop    %esi
  800c57:	5d                   	pop    %ebp
  800c58:	c3                   	ret    

00800c59 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c59:	55                   	push   %ebp
  800c5a:	89 e5                	mov    %esp,%ebp
  800c5c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c5f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c62:	0f b6 01             	movzbl (%ecx),%eax
  800c65:	84 c0                	test   %al,%al
  800c67:	74 15                	je     800c7e <strcmp+0x25>
  800c69:	3a 02                	cmp    (%edx),%al
  800c6b:	75 11                	jne    800c7e <strcmp+0x25>
		p++, q++;
  800c6d:	83 c1 01             	add    $0x1,%ecx
  800c70:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c73:	0f b6 01             	movzbl (%ecx),%eax
  800c76:	84 c0                	test   %al,%al
  800c78:	74 04                	je     800c7e <strcmp+0x25>
  800c7a:	3a 02                	cmp    (%edx),%al
  800c7c:	74 ef                	je     800c6d <strcmp+0x14>
  800c7e:	0f b6 c0             	movzbl %al,%eax
  800c81:	0f b6 12             	movzbl (%edx),%edx
  800c84:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	53                   	push   %ebx
  800c8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c92:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800c95:	85 c0                	test   %eax,%eax
  800c97:	74 23                	je     800cbc <strncmp+0x34>
  800c99:	0f b6 1a             	movzbl (%edx),%ebx
  800c9c:	84 db                	test   %bl,%bl
  800c9e:	74 24                	je     800cc4 <strncmp+0x3c>
  800ca0:	3a 19                	cmp    (%ecx),%bl
  800ca2:	75 20                	jne    800cc4 <strncmp+0x3c>
  800ca4:	83 e8 01             	sub    $0x1,%eax
  800ca7:	74 13                	je     800cbc <strncmp+0x34>
		n--, p++, q++;
  800ca9:	83 c2 01             	add    $0x1,%edx
  800cac:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800caf:	0f b6 1a             	movzbl (%edx),%ebx
  800cb2:	84 db                	test   %bl,%bl
  800cb4:	74 0e                	je     800cc4 <strncmp+0x3c>
  800cb6:	3a 19                	cmp    (%ecx),%bl
  800cb8:	74 ea                	je     800ca4 <strncmp+0x1c>
  800cba:	eb 08                	jmp    800cc4 <strncmp+0x3c>
  800cbc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800cc1:	5b                   	pop    %ebx
  800cc2:	5d                   	pop    %ebp
  800cc3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800cc4:	0f b6 02             	movzbl (%edx),%eax
  800cc7:	0f b6 11             	movzbl (%ecx),%edx
  800cca:	29 d0                	sub    %edx,%eax
  800ccc:	eb f3                	jmp    800cc1 <strncmp+0x39>

00800cce <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cd8:	0f b6 10             	movzbl (%eax),%edx
  800cdb:	84 d2                	test   %dl,%dl
  800cdd:	74 15                	je     800cf4 <strchr+0x26>
		if (*s == c)
  800cdf:	38 ca                	cmp    %cl,%dl
  800ce1:	75 07                	jne    800cea <strchr+0x1c>
  800ce3:	eb 14                	jmp    800cf9 <strchr+0x2b>
  800ce5:	38 ca                	cmp    %cl,%dl
  800ce7:	90                   	nop
  800ce8:	74 0f                	je     800cf9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cea:	83 c0 01             	add    $0x1,%eax
  800ced:	0f b6 10             	movzbl (%eax),%edx
  800cf0:	84 d2                	test   %dl,%dl
  800cf2:	75 f1                	jne    800ce5 <strchr+0x17>
  800cf4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800cf9:	5d                   	pop    %ebp
  800cfa:	c3                   	ret    

00800cfb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d05:	0f b6 10             	movzbl (%eax),%edx
  800d08:	84 d2                	test   %dl,%dl
  800d0a:	74 18                	je     800d24 <strfind+0x29>
		if (*s == c)
  800d0c:	38 ca                	cmp    %cl,%dl
  800d0e:	75 0a                	jne    800d1a <strfind+0x1f>
  800d10:	eb 12                	jmp    800d24 <strfind+0x29>
  800d12:	38 ca                	cmp    %cl,%dl
  800d14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800d18:	74 0a                	je     800d24 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d1a:	83 c0 01             	add    $0x1,%eax
  800d1d:	0f b6 10             	movzbl (%eax),%edx
  800d20:	84 d2                	test   %dl,%dl
  800d22:	75 ee                	jne    800d12 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800d24:	5d                   	pop    %ebp
  800d25:	c3                   	ret    

00800d26 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 0c             	sub    $0xc,%esp
  800d2c:	89 1c 24             	mov    %ebx,(%esp)
  800d2f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d33:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800d37:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d40:	85 c9                	test   %ecx,%ecx
  800d42:	74 30                	je     800d74 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d44:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d4a:	75 25                	jne    800d71 <memset+0x4b>
  800d4c:	f6 c1 03             	test   $0x3,%cl
  800d4f:	75 20                	jne    800d71 <memset+0x4b>
		c &= 0xFF;
  800d51:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d54:	89 d3                	mov    %edx,%ebx
  800d56:	c1 e3 08             	shl    $0x8,%ebx
  800d59:	89 d6                	mov    %edx,%esi
  800d5b:	c1 e6 18             	shl    $0x18,%esi
  800d5e:	89 d0                	mov    %edx,%eax
  800d60:	c1 e0 10             	shl    $0x10,%eax
  800d63:	09 f0                	or     %esi,%eax
  800d65:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800d67:	09 d8                	or     %ebx,%eax
  800d69:	c1 e9 02             	shr    $0x2,%ecx
  800d6c:	fc                   	cld    
  800d6d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d6f:	eb 03                	jmp    800d74 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d71:	fc                   	cld    
  800d72:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d74:	89 f8                	mov    %edi,%eax
  800d76:	8b 1c 24             	mov    (%esp),%ebx
  800d79:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d7d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d81:	89 ec                	mov    %ebp,%esp
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	83 ec 08             	sub    $0x8,%esp
  800d8b:	89 34 24             	mov    %esi,(%esp)
  800d8e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800d98:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800d9b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800d9d:	39 c6                	cmp    %eax,%esi
  800d9f:	73 35                	jae    800dd6 <memmove+0x51>
  800da1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800da4:	39 d0                	cmp    %edx,%eax
  800da6:	73 2e                	jae    800dd6 <memmove+0x51>
		s += n;
		d += n;
  800da8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800daa:	f6 c2 03             	test   $0x3,%dl
  800dad:	75 1b                	jne    800dca <memmove+0x45>
  800daf:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800db5:	75 13                	jne    800dca <memmove+0x45>
  800db7:	f6 c1 03             	test   $0x3,%cl
  800dba:	75 0e                	jne    800dca <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800dbc:	83 ef 04             	sub    $0x4,%edi
  800dbf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800dc2:	c1 e9 02             	shr    $0x2,%ecx
  800dc5:	fd                   	std    
  800dc6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dc8:	eb 09                	jmp    800dd3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800dca:	83 ef 01             	sub    $0x1,%edi
  800dcd:	8d 72 ff             	lea    -0x1(%edx),%esi
  800dd0:	fd                   	std    
  800dd1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800dd3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800dd4:	eb 20                	jmp    800df6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dd6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ddc:	75 15                	jne    800df3 <memmove+0x6e>
  800dde:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800de4:	75 0d                	jne    800df3 <memmove+0x6e>
  800de6:	f6 c1 03             	test   $0x3,%cl
  800de9:	75 08                	jne    800df3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800deb:	c1 e9 02             	shr    $0x2,%ecx
  800dee:	fc                   	cld    
  800def:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800df1:	eb 03                	jmp    800df6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800df3:	fc                   	cld    
  800df4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800df6:	8b 34 24             	mov    (%esp),%esi
  800df9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800dfd:	89 ec                	mov    %ebp,%esp
  800dff:	5d                   	pop    %ebp
  800e00:	c3                   	ret    

00800e01 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e07:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e11:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	89 04 24             	mov    %eax,(%esp)
  800e1b:	e8 65 ff ff ff       	call   800d85 <memmove>
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	57                   	push   %edi
  800e26:	56                   	push   %esi
  800e27:	53                   	push   %ebx
  800e28:	8b 75 08             	mov    0x8(%ebp),%esi
  800e2b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e2e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e31:	85 c9                	test   %ecx,%ecx
  800e33:	74 36                	je     800e6b <memcmp+0x49>
		if (*s1 != *s2)
  800e35:	0f b6 06             	movzbl (%esi),%eax
  800e38:	0f b6 1f             	movzbl (%edi),%ebx
  800e3b:	38 d8                	cmp    %bl,%al
  800e3d:	74 20                	je     800e5f <memcmp+0x3d>
  800e3f:	eb 14                	jmp    800e55 <memcmp+0x33>
  800e41:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800e46:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800e4b:	83 c2 01             	add    $0x1,%edx
  800e4e:	83 e9 01             	sub    $0x1,%ecx
  800e51:	38 d8                	cmp    %bl,%al
  800e53:	74 12                	je     800e67 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800e55:	0f b6 c0             	movzbl %al,%eax
  800e58:	0f b6 db             	movzbl %bl,%ebx
  800e5b:	29 d8                	sub    %ebx,%eax
  800e5d:	eb 11                	jmp    800e70 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e5f:	83 e9 01             	sub    $0x1,%ecx
  800e62:	ba 00 00 00 00       	mov    $0x0,%edx
  800e67:	85 c9                	test   %ecx,%ecx
  800e69:	75 d6                	jne    800e41 <memcmp+0x1f>
  800e6b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800e70:	5b                   	pop    %ebx
  800e71:	5e                   	pop    %esi
  800e72:	5f                   	pop    %edi
  800e73:	5d                   	pop    %ebp
  800e74:	c3                   	ret    

00800e75 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e75:	55                   	push   %ebp
  800e76:	89 e5                	mov    %esp,%ebp
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800e7b:	89 c2                	mov    %eax,%edx
  800e7d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e80:	39 d0                	cmp    %edx,%eax
  800e82:	73 15                	jae    800e99 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e84:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800e88:	38 08                	cmp    %cl,(%eax)
  800e8a:	75 06                	jne    800e92 <memfind+0x1d>
  800e8c:	eb 0b                	jmp    800e99 <memfind+0x24>
  800e8e:	38 08                	cmp    %cl,(%eax)
  800e90:	74 07                	je     800e99 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e92:	83 c0 01             	add    $0x1,%eax
  800e95:	39 c2                	cmp    %eax,%edx
  800e97:	77 f5                	ja     800e8e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e99:	5d                   	pop    %ebp
  800e9a:	c3                   	ret    

00800e9b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	57                   	push   %edi
  800e9f:	56                   	push   %esi
  800ea0:	53                   	push   %ebx
  800ea1:	83 ec 04             	sub    $0x4,%esp
  800ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eaa:	0f b6 02             	movzbl (%edx),%eax
  800ead:	3c 20                	cmp    $0x20,%al
  800eaf:	74 04                	je     800eb5 <strtol+0x1a>
  800eb1:	3c 09                	cmp    $0x9,%al
  800eb3:	75 0e                	jne    800ec3 <strtol+0x28>
		s++;
  800eb5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eb8:	0f b6 02             	movzbl (%edx),%eax
  800ebb:	3c 20                	cmp    $0x20,%al
  800ebd:	74 f6                	je     800eb5 <strtol+0x1a>
  800ebf:	3c 09                	cmp    $0x9,%al
  800ec1:	74 f2                	je     800eb5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ec3:	3c 2b                	cmp    $0x2b,%al
  800ec5:	75 0c                	jne    800ed3 <strtol+0x38>
		s++;
  800ec7:	83 c2 01             	add    $0x1,%edx
  800eca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ed1:	eb 15                	jmp    800ee8 <strtol+0x4d>
	else if (*s == '-')
  800ed3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800eda:	3c 2d                	cmp    $0x2d,%al
  800edc:	75 0a                	jne    800ee8 <strtol+0x4d>
		s++, neg = 1;
  800ede:	83 c2 01             	add    $0x1,%edx
  800ee1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ee8:	85 db                	test   %ebx,%ebx
  800eea:	0f 94 c0             	sete   %al
  800eed:	74 05                	je     800ef4 <strtol+0x59>
  800eef:	83 fb 10             	cmp    $0x10,%ebx
  800ef2:	75 18                	jne    800f0c <strtol+0x71>
  800ef4:	80 3a 30             	cmpb   $0x30,(%edx)
  800ef7:	75 13                	jne    800f0c <strtol+0x71>
  800ef9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800efd:	8d 76 00             	lea    0x0(%esi),%esi
  800f00:	75 0a                	jne    800f0c <strtol+0x71>
		s += 2, base = 16;
  800f02:	83 c2 02             	add    $0x2,%edx
  800f05:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f0a:	eb 15                	jmp    800f21 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f0c:	84 c0                	test   %al,%al
  800f0e:	66 90                	xchg   %ax,%ax
  800f10:	74 0f                	je     800f21 <strtol+0x86>
  800f12:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800f17:	80 3a 30             	cmpb   $0x30,(%edx)
  800f1a:	75 05                	jne    800f21 <strtol+0x86>
		s++, base = 8;
  800f1c:	83 c2 01             	add    $0x1,%edx
  800f1f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f21:	b8 00 00 00 00       	mov    $0x0,%eax
  800f26:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f28:	0f b6 0a             	movzbl (%edx),%ecx
  800f2b:	89 cf                	mov    %ecx,%edi
  800f2d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800f30:	80 fb 09             	cmp    $0x9,%bl
  800f33:	77 08                	ja     800f3d <strtol+0xa2>
			dig = *s - '0';
  800f35:	0f be c9             	movsbl %cl,%ecx
  800f38:	83 e9 30             	sub    $0x30,%ecx
  800f3b:	eb 1e                	jmp    800f5b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800f3d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800f40:	80 fb 19             	cmp    $0x19,%bl
  800f43:	77 08                	ja     800f4d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800f45:	0f be c9             	movsbl %cl,%ecx
  800f48:	83 e9 57             	sub    $0x57,%ecx
  800f4b:	eb 0e                	jmp    800f5b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800f4d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800f50:	80 fb 19             	cmp    $0x19,%bl
  800f53:	77 15                	ja     800f6a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800f55:	0f be c9             	movsbl %cl,%ecx
  800f58:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f5b:	39 f1                	cmp    %esi,%ecx
  800f5d:	7d 0b                	jge    800f6a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800f5f:	83 c2 01             	add    $0x1,%edx
  800f62:	0f af c6             	imul   %esi,%eax
  800f65:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800f68:	eb be                	jmp    800f28 <strtol+0x8d>
  800f6a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800f6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f70:	74 05                	je     800f77 <strtol+0xdc>
		*endptr = (char *) s;
  800f72:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800f75:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800f77:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f7b:	74 04                	je     800f81 <strtol+0xe6>
  800f7d:	89 c8                	mov    %ecx,%eax
  800f7f:	f7 d8                	neg    %eax
}
  800f81:	83 c4 04             	add    $0x4,%esp
  800f84:	5b                   	pop    %ebx
  800f85:	5e                   	pop    %esi
  800f86:	5f                   	pop    %edi
  800f87:	5d                   	pop    %ebp
  800f88:	c3                   	ret    
  800f89:	00 00                	add    %al,(%eax)
	...

00800f8c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	83 ec 0c             	sub    $0xc,%esp
  800f92:	89 1c 24             	mov    %ebx,(%esp)
  800f95:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f99:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f9d:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa2:	b8 01 00 00 00       	mov    $0x1,%eax
  800fa7:	89 d1                	mov    %edx,%ecx
  800fa9:	89 d3                	mov    %edx,%ebx
  800fab:	89 d7                	mov    %edx,%edi
  800fad:	89 d6                	mov    %edx,%esi
  800faf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fb1:	8b 1c 24             	mov    (%esp),%ebx
  800fb4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fb8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fbc:	89 ec                	mov    %ebp,%esp
  800fbe:	5d                   	pop    %ebp
  800fbf:	c3                   	ret    

00800fc0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fc0:	55                   	push   %ebp
  800fc1:	89 e5                	mov    %esp,%ebp
  800fc3:	83 ec 0c             	sub    $0xc,%esp
  800fc6:	89 1c 24             	mov    %ebx,(%esp)
  800fc9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fcd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fdc:	89 c3                	mov    %eax,%ebx
  800fde:	89 c7                	mov    %eax,%edi
  800fe0:	89 c6                	mov    %eax,%esi
  800fe2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800fe4:	8b 1c 24             	mov    (%esp),%ebx
  800fe7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800feb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fef:	89 ec                	mov    %ebp,%esp
  800ff1:	5d                   	pop    %ebp
  800ff2:	c3                   	ret    

00800ff3 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  800ff3:	55                   	push   %ebp
  800ff4:	89 e5                	mov    %esp,%ebp
  800ff6:	83 ec 0c             	sub    $0xc,%esp
  800ff9:	89 1c 24             	mov    %ebx,(%esp)
  800ffc:	89 74 24 04          	mov    %esi,0x4(%esp)
  801000:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801004:	bb 00 00 00 00       	mov    $0x0,%ebx
  801009:	b8 10 00 00 00       	mov    $0x10,%eax
  80100e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801011:	8b 55 08             	mov    0x8(%ebp),%edx
  801014:	89 df                	mov    %ebx,%edi
  801016:	89 de                	mov    %ebx,%esi
  801018:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  80101a:	8b 1c 24             	mov    (%esp),%ebx
  80101d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801021:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801025:	89 ec                	mov    %ebp,%esp
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    

00801029 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  801029:	55                   	push   %ebp
  80102a:	89 e5                	mov    %esp,%ebp
  80102c:	83 ec 38             	sub    $0x38,%esp
  80102f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801032:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801035:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801038:	bb 00 00 00 00       	mov    $0x0,%ebx
  80103d:	b8 0f 00 00 00       	mov    $0xf,%eax
  801042:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801045:	8b 55 08             	mov    0x8(%ebp),%edx
  801048:	89 df                	mov    %ebx,%edi
  80104a:	89 de                	mov    %ebx,%esi
  80104c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80104e:	85 c0                	test   %eax,%eax
  801050:	7e 28                	jle    80107a <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801052:	89 44 24 10          	mov    %eax,0x10(%esp)
  801056:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80105d:	00 
  80105e:	c7 44 24 08 af 2e 80 	movl   $0x802eaf,0x8(%esp)
  801065:	00 
  801066:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80106d:	00 
  80106e:	c7 04 24 cc 2e 80 00 	movl   $0x802ecc,(%esp)
  801075:	e8 be f2 ff ff       	call   800338 <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  80107a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80107d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801080:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801083:	89 ec                	mov    %ebp,%esp
  801085:	5d                   	pop    %ebp
  801086:	c3                   	ret    

00801087 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 0c             	sub    $0xc,%esp
  80108d:	89 1c 24             	mov    %ebx,(%esp)
  801090:	89 74 24 04          	mov    %esi,0x4(%esp)
  801094:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801098:	ba 00 00 00 00       	mov    $0x0,%edx
  80109d:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010a2:	89 d1                	mov    %edx,%ecx
  8010a4:	89 d3                	mov    %edx,%ebx
  8010a6:	89 d7                	mov    %edx,%edi
  8010a8:	89 d6                	mov    %edx,%esi
  8010aa:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010ac:	8b 1c 24             	mov    (%esp),%ebx
  8010af:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010b3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010b7:	89 ec                	mov    %ebp,%esp
  8010b9:	5d                   	pop    %ebp
  8010ba:	c3                   	ret    

008010bb <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
  8010be:	83 ec 38             	sub    $0x38,%esp
  8010c1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010c4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010c7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010cf:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d7:	89 cb                	mov    %ecx,%ebx
  8010d9:	89 cf                	mov    %ecx,%edi
  8010db:	89 ce                	mov    %ecx,%esi
  8010dd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010df:	85 c0                	test   %eax,%eax
  8010e1:	7e 28                	jle    80110b <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010e7:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8010ee:	00 
  8010ef:	c7 44 24 08 af 2e 80 	movl   $0x802eaf,0x8(%esp)
  8010f6:	00 
  8010f7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010fe:	00 
  8010ff:	c7 04 24 cc 2e 80 00 	movl   $0x802ecc,(%esp)
  801106:	e8 2d f2 ff ff       	call   800338 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80110b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80110e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801111:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801114:	89 ec                	mov    %ebp,%esp
  801116:	5d                   	pop    %ebp
  801117:	c3                   	ret    

00801118 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801118:	55                   	push   %ebp
  801119:	89 e5                	mov    %esp,%ebp
  80111b:	83 ec 0c             	sub    $0xc,%esp
  80111e:	89 1c 24             	mov    %ebx,(%esp)
  801121:	89 74 24 04          	mov    %esi,0x4(%esp)
  801125:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801129:	be 00 00 00 00       	mov    $0x0,%esi
  80112e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801133:	8b 7d 14             	mov    0x14(%ebp),%edi
  801136:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801139:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113c:	8b 55 08             	mov    0x8(%ebp),%edx
  80113f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801141:	8b 1c 24             	mov    (%esp),%ebx
  801144:	8b 74 24 04          	mov    0x4(%esp),%esi
  801148:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80114c:	89 ec                	mov    %ebp,%esp
  80114e:	5d                   	pop    %ebp
  80114f:	c3                   	ret    

00801150 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801150:	55                   	push   %ebp
  801151:	89 e5                	mov    %esp,%ebp
  801153:	83 ec 38             	sub    $0x38,%esp
  801156:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801159:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80115c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80115f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801164:	b8 0a 00 00 00       	mov    $0xa,%eax
  801169:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80116c:	8b 55 08             	mov    0x8(%ebp),%edx
  80116f:	89 df                	mov    %ebx,%edi
  801171:	89 de                	mov    %ebx,%esi
  801173:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801175:	85 c0                	test   %eax,%eax
  801177:	7e 28                	jle    8011a1 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801179:	89 44 24 10          	mov    %eax,0x10(%esp)
  80117d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801184:	00 
  801185:	c7 44 24 08 af 2e 80 	movl   $0x802eaf,0x8(%esp)
  80118c:	00 
  80118d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801194:	00 
  801195:	c7 04 24 cc 2e 80 00 	movl   $0x802ecc,(%esp)
  80119c:	e8 97 f1 ff ff       	call   800338 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011a1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011a4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011a7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011aa:	89 ec                	mov    %ebp,%esp
  8011ac:	5d                   	pop    %ebp
  8011ad:	c3                   	ret    

008011ae <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011ae:	55                   	push   %ebp
  8011af:	89 e5                	mov    %esp,%ebp
  8011b1:	83 ec 38             	sub    $0x38,%esp
  8011b4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011b7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011ba:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011c2:	b8 09 00 00 00       	mov    $0x9,%eax
  8011c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8011cd:	89 df                	mov    %ebx,%edi
  8011cf:	89 de                	mov    %ebx,%esi
  8011d1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011d3:	85 c0                	test   %eax,%eax
  8011d5:	7e 28                	jle    8011ff <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011db:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8011e2:	00 
  8011e3:	c7 44 24 08 af 2e 80 	movl   $0x802eaf,0x8(%esp)
  8011ea:	00 
  8011eb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011f2:	00 
  8011f3:	c7 04 24 cc 2e 80 00 	movl   $0x802ecc,(%esp)
  8011fa:	e8 39 f1 ff ff       	call   800338 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011ff:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801202:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801205:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801208:	89 ec                	mov    %ebp,%esp
  80120a:	5d                   	pop    %ebp
  80120b:	c3                   	ret    

0080120c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80120c:	55                   	push   %ebp
  80120d:	89 e5                	mov    %esp,%ebp
  80120f:	83 ec 38             	sub    $0x38,%esp
  801212:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801215:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801218:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80121b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801220:	b8 08 00 00 00       	mov    $0x8,%eax
  801225:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801228:	8b 55 08             	mov    0x8(%ebp),%edx
  80122b:	89 df                	mov    %ebx,%edi
  80122d:	89 de                	mov    %ebx,%esi
  80122f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801231:	85 c0                	test   %eax,%eax
  801233:	7e 28                	jle    80125d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801235:	89 44 24 10          	mov    %eax,0x10(%esp)
  801239:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801240:	00 
  801241:	c7 44 24 08 af 2e 80 	movl   $0x802eaf,0x8(%esp)
  801248:	00 
  801249:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801250:	00 
  801251:	c7 04 24 cc 2e 80 00 	movl   $0x802ecc,(%esp)
  801258:	e8 db f0 ff ff       	call   800338 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80125d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801260:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801263:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801266:	89 ec                	mov    %ebp,%esp
  801268:	5d                   	pop    %ebp
  801269:	c3                   	ret    

0080126a <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	83 ec 38             	sub    $0x38,%esp
  801270:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801273:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801276:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801279:	bb 00 00 00 00       	mov    $0x0,%ebx
  80127e:	b8 06 00 00 00       	mov    $0x6,%eax
  801283:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801286:	8b 55 08             	mov    0x8(%ebp),%edx
  801289:	89 df                	mov    %ebx,%edi
  80128b:	89 de                	mov    %ebx,%esi
  80128d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80128f:	85 c0                	test   %eax,%eax
  801291:	7e 28                	jle    8012bb <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801293:	89 44 24 10          	mov    %eax,0x10(%esp)
  801297:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80129e:	00 
  80129f:	c7 44 24 08 af 2e 80 	movl   $0x802eaf,0x8(%esp)
  8012a6:	00 
  8012a7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012ae:	00 
  8012af:	c7 04 24 cc 2e 80 00 	movl   $0x802ecc,(%esp)
  8012b6:	e8 7d f0 ff ff       	call   800338 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012bb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012be:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012c1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012c4:	89 ec                	mov    %ebp,%esp
  8012c6:	5d                   	pop    %ebp
  8012c7:	c3                   	ret    

008012c8 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8012c8:	55                   	push   %ebp
  8012c9:	89 e5                	mov    %esp,%ebp
  8012cb:	83 ec 38             	sub    $0x38,%esp
  8012ce:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012d1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012d4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d7:	b8 05 00 00 00       	mov    $0x5,%eax
  8012dc:	8b 75 18             	mov    0x18(%ebp),%esi
  8012df:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8012eb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	7e 28                	jle    801319 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012f5:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8012fc:	00 
  8012fd:	c7 44 24 08 af 2e 80 	movl   $0x802eaf,0x8(%esp)
  801304:	00 
  801305:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80130c:	00 
  80130d:	c7 04 24 cc 2e 80 00 	movl   $0x802ecc,(%esp)
  801314:	e8 1f f0 ff ff       	call   800338 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801319:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80131c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80131f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801322:	89 ec                	mov    %ebp,%esp
  801324:	5d                   	pop    %ebp
  801325:	c3                   	ret    

00801326 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801326:	55                   	push   %ebp
  801327:	89 e5                	mov    %esp,%ebp
  801329:	83 ec 38             	sub    $0x38,%esp
  80132c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80132f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801332:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801335:	be 00 00 00 00       	mov    $0x0,%esi
  80133a:	b8 04 00 00 00       	mov    $0x4,%eax
  80133f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801342:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801345:	8b 55 08             	mov    0x8(%ebp),%edx
  801348:	89 f7                	mov    %esi,%edi
  80134a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80134c:	85 c0                	test   %eax,%eax
  80134e:	7e 28                	jle    801378 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801350:	89 44 24 10          	mov    %eax,0x10(%esp)
  801354:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80135b:	00 
  80135c:	c7 44 24 08 af 2e 80 	movl   $0x802eaf,0x8(%esp)
  801363:	00 
  801364:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80136b:	00 
  80136c:	c7 04 24 cc 2e 80 00 	movl   $0x802ecc,(%esp)
  801373:	e8 c0 ef ff ff       	call   800338 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801378:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80137b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80137e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801381:	89 ec                	mov    %ebp,%esp
  801383:	5d                   	pop    %ebp
  801384:	c3                   	ret    

00801385 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  801385:	55                   	push   %ebp
  801386:	89 e5                	mov    %esp,%ebp
  801388:	83 ec 0c             	sub    $0xc,%esp
  80138b:	89 1c 24             	mov    %ebx,(%esp)
  80138e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801392:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801396:	ba 00 00 00 00       	mov    $0x0,%edx
  80139b:	b8 0b 00 00 00       	mov    $0xb,%eax
  8013a0:	89 d1                	mov    %edx,%ecx
  8013a2:	89 d3                	mov    %edx,%ebx
  8013a4:	89 d7                	mov    %edx,%edi
  8013a6:	89 d6                	mov    %edx,%esi
  8013a8:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8013aa:	8b 1c 24             	mov    (%esp),%ebx
  8013ad:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013b1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013b5:	89 ec                	mov    %ebp,%esp
  8013b7:	5d                   	pop    %ebp
  8013b8:	c3                   	ret    

008013b9 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8013b9:	55                   	push   %ebp
  8013ba:	89 e5                	mov    %esp,%ebp
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	89 1c 24             	mov    %ebx,(%esp)
  8013c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013c6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8013cf:	b8 02 00 00 00       	mov    $0x2,%eax
  8013d4:	89 d1                	mov    %edx,%ecx
  8013d6:	89 d3                	mov    %edx,%ebx
  8013d8:	89 d7                	mov    %edx,%edi
  8013da:	89 d6                	mov    %edx,%esi
  8013dc:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8013de:	8b 1c 24             	mov    (%esp),%ebx
  8013e1:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013e5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013e9:	89 ec                	mov    %ebp,%esp
  8013eb:	5d                   	pop    %ebp
  8013ec:	c3                   	ret    

008013ed <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8013ed:	55                   	push   %ebp
  8013ee:	89 e5                	mov    %esp,%ebp
  8013f0:	83 ec 38             	sub    $0x38,%esp
  8013f3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013f6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013f9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  801401:	b8 03 00 00 00       	mov    $0x3,%eax
  801406:	8b 55 08             	mov    0x8(%ebp),%edx
  801409:	89 cb                	mov    %ecx,%ebx
  80140b:	89 cf                	mov    %ecx,%edi
  80140d:	89 ce                	mov    %ecx,%esi
  80140f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801411:	85 c0                	test   %eax,%eax
  801413:	7e 28                	jle    80143d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801415:	89 44 24 10          	mov    %eax,0x10(%esp)
  801419:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801420:	00 
  801421:	c7 44 24 08 af 2e 80 	movl   $0x802eaf,0x8(%esp)
  801428:	00 
  801429:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801430:	00 
  801431:	c7 04 24 cc 2e 80 00 	movl   $0x802ecc,(%esp)
  801438:	e8 fb ee ff ff       	call   800338 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80143d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801440:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801443:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801446:	89 ec                	mov    %ebp,%esp
  801448:	5d                   	pop    %ebp
  801449:	c3                   	ret    
  80144a:	00 00                	add    %al,(%eax)
  80144c:	00 00                	add    %al,(%eax)
	...

00801450 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	05 00 00 00 30       	add    $0x30000000,%eax
  80145b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80145e:	5d                   	pop    %ebp
  80145f:	c3                   	ret    

00801460 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801460:	55                   	push   %ebp
  801461:	89 e5                	mov    %esp,%ebp
  801463:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	89 04 24             	mov    %eax,(%esp)
  80146c:	e8 df ff ff ff       	call   801450 <fd2num>
  801471:	05 20 00 0d 00       	add    $0xd0020,%eax
  801476:	c1 e0 0c             	shl    $0xc,%eax
}
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
  80147e:	57                   	push   %edi
  80147f:	56                   	push   %esi
  801480:	53                   	push   %ebx
  801481:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801484:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801489:	a8 01                	test   $0x1,%al
  80148b:	74 36                	je     8014c3 <fd_alloc+0x48>
  80148d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801492:	a8 01                	test   $0x1,%al
  801494:	74 2d                	je     8014c3 <fd_alloc+0x48>
  801496:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80149b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8014a0:	be 00 00 40 ef       	mov    $0xef400000,%esi
  8014a5:	89 c3                	mov    %eax,%ebx
  8014a7:	89 c2                	mov    %eax,%edx
  8014a9:	c1 ea 16             	shr    $0x16,%edx
  8014ac:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8014af:	f6 c2 01             	test   $0x1,%dl
  8014b2:	74 14                	je     8014c8 <fd_alloc+0x4d>
  8014b4:	89 c2                	mov    %eax,%edx
  8014b6:	c1 ea 0c             	shr    $0xc,%edx
  8014b9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  8014bc:	f6 c2 01             	test   $0x1,%dl
  8014bf:	75 10                	jne    8014d1 <fd_alloc+0x56>
  8014c1:	eb 05                	jmp    8014c8 <fd_alloc+0x4d>
  8014c3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  8014c8:	89 1f                	mov    %ebx,(%edi)
  8014ca:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8014cf:	eb 17                	jmp    8014e8 <fd_alloc+0x6d>
  8014d1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8014d6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014db:	75 c8                	jne    8014a5 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014dd:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8014e3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8014e8:	5b                   	pop    %ebx
  8014e9:	5e                   	pop    %esi
  8014ea:	5f                   	pop    %edi
  8014eb:	5d                   	pop    %ebp
  8014ec:	c3                   	ret    

008014ed <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014ed:	55                   	push   %ebp
  8014ee:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	83 f8 1f             	cmp    $0x1f,%eax
  8014f6:	77 36                	ja     80152e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014f8:	05 00 00 0d 00       	add    $0xd0000,%eax
  8014fd:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801500:	89 c2                	mov    %eax,%edx
  801502:	c1 ea 16             	shr    $0x16,%edx
  801505:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80150c:	f6 c2 01             	test   $0x1,%dl
  80150f:	74 1d                	je     80152e <fd_lookup+0x41>
  801511:	89 c2                	mov    %eax,%edx
  801513:	c1 ea 0c             	shr    $0xc,%edx
  801516:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80151d:	f6 c2 01             	test   $0x1,%dl
  801520:	74 0c                	je     80152e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801522:	8b 55 0c             	mov    0xc(%ebp),%edx
  801525:	89 02                	mov    %eax,(%edx)
  801527:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80152c:	eb 05                	jmp    801533 <fd_lookup+0x46>
  80152e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801533:	5d                   	pop    %ebp
  801534:	c3                   	ret    

00801535 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801535:	55                   	push   %ebp
  801536:	89 e5                	mov    %esp,%ebp
  801538:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80153b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80153e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801542:	8b 45 08             	mov    0x8(%ebp),%eax
  801545:	89 04 24             	mov    %eax,(%esp)
  801548:	e8 a0 ff ff ff       	call   8014ed <fd_lookup>
  80154d:	85 c0                	test   %eax,%eax
  80154f:	78 0e                	js     80155f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801551:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801554:	8b 55 0c             	mov    0xc(%ebp),%edx
  801557:	89 50 04             	mov    %edx,0x4(%eax)
  80155a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80155f:	c9                   	leave  
  801560:	c3                   	ret    

00801561 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	56                   	push   %esi
  801565:	53                   	push   %ebx
  801566:	83 ec 10             	sub    $0x10,%esp
  801569:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80156c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80156f:	b8 20 60 80 00       	mov    $0x806020,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801574:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801579:	be 5c 2f 80 00       	mov    $0x802f5c,%esi
		if (devtab[i]->dev_id == dev_id) {
  80157e:	39 08                	cmp    %ecx,(%eax)
  801580:	75 10                	jne    801592 <dev_lookup+0x31>
  801582:	eb 04                	jmp    801588 <dev_lookup+0x27>
  801584:	39 08                	cmp    %ecx,(%eax)
  801586:	75 0a                	jne    801592 <dev_lookup+0x31>
			*dev = devtab[i];
  801588:	89 03                	mov    %eax,(%ebx)
  80158a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80158f:	90                   	nop
  801590:	eb 31                	jmp    8015c3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801592:	83 c2 01             	add    $0x1,%edx
  801595:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801598:	85 c0                	test   %eax,%eax
  80159a:	75 e8                	jne    801584 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80159c:	a1 80 64 80 00       	mov    0x806480,%eax
  8015a1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8015a4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015ac:	c7 04 24 dc 2e 80 00 	movl   $0x802edc,(%esp)
  8015b3:	e8 45 ee ff ff       	call   8003fd <cprintf>
	*dev = 0;
  8015b8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8015be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8015c3:	83 c4 10             	add    $0x10,%esp
  8015c6:	5b                   	pop    %ebx
  8015c7:	5e                   	pop    %esi
  8015c8:	5d                   	pop    %ebp
  8015c9:	c3                   	ret    

008015ca <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8015ca:	55                   	push   %ebp
  8015cb:	89 e5                	mov    %esp,%ebp
  8015cd:	53                   	push   %ebx
  8015ce:	83 ec 24             	sub    $0x24,%esp
  8015d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	89 04 24             	mov    %eax,(%esp)
  8015e1:	e8 07 ff ff ff       	call   8014ed <fd_lookup>
  8015e6:	85 c0                	test   %eax,%eax
  8015e8:	78 53                	js     80163d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f4:	8b 00                	mov    (%eax),%eax
  8015f6:	89 04 24             	mov    %eax,(%esp)
  8015f9:	e8 63 ff ff ff       	call   801561 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015fe:	85 c0                	test   %eax,%eax
  801600:	78 3b                	js     80163d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801602:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801607:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80160a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80160e:	74 2d                	je     80163d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801610:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801613:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80161a:	00 00 00 
	stat->st_isdir = 0;
  80161d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801624:	00 00 00 
	stat->st_dev = dev;
  801627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80162a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801630:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801634:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801637:	89 14 24             	mov    %edx,(%esp)
  80163a:	ff 50 14             	call   *0x14(%eax)
}
  80163d:	83 c4 24             	add    $0x24,%esp
  801640:	5b                   	pop    %ebx
  801641:	5d                   	pop    %ebp
  801642:	c3                   	ret    

00801643 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801643:	55                   	push   %ebp
  801644:	89 e5                	mov    %esp,%ebp
  801646:	53                   	push   %ebx
  801647:	83 ec 24             	sub    $0x24,%esp
  80164a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80164d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801650:	89 44 24 04          	mov    %eax,0x4(%esp)
  801654:	89 1c 24             	mov    %ebx,(%esp)
  801657:	e8 91 fe ff ff       	call   8014ed <fd_lookup>
  80165c:	85 c0                	test   %eax,%eax
  80165e:	78 5f                	js     8016bf <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801660:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801663:	89 44 24 04          	mov    %eax,0x4(%esp)
  801667:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166a:	8b 00                	mov    (%eax),%eax
  80166c:	89 04 24             	mov    %eax,(%esp)
  80166f:	e8 ed fe ff ff       	call   801561 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801674:	85 c0                	test   %eax,%eax
  801676:	78 47                	js     8016bf <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801678:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80167b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80167f:	75 23                	jne    8016a4 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801681:	a1 80 64 80 00       	mov    0x806480,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801686:	8b 40 4c             	mov    0x4c(%eax),%eax
  801689:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80168d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801691:	c7 04 24 fc 2e 80 00 	movl   $0x802efc,(%esp)
  801698:	e8 60 ed ff ff       	call   8003fd <cprintf>
  80169d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  8016a2:	eb 1b                	jmp    8016bf <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8016a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016a7:	8b 48 18             	mov    0x18(%eax),%ecx
  8016aa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016af:	85 c9                	test   %ecx,%ecx
  8016b1:	74 0c                	je     8016bf <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016ba:	89 14 24             	mov    %edx,(%esp)
  8016bd:	ff d1                	call   *%ecx
}
  8016bf:	83 c4 24             	add    $0x24,%esp
  8016c2:	5b                   	pop    %ebx
  8016c3:	5d                   	pop    %ebp
  8016c4:	c3                   	ret    

008016c5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016c5:	55                   	push   %ebp
  8016c6:	89 e5                	mov    %esp,%ebp
  8016c8:	53                   	push   %ebx
  8016c9:	83 ec 24             	sub    $0x24,%esp
  8016cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016cf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d6:	89 1c 24             	mov    %ebx,(%esp)
  8016d9:	e8 0f fe ff ff       	call   8014ed <fd_lookup>
  8016de:	85 c0                	test   %eax,%eax
  8016e0:	78 66                	js     801748 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016e2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016e5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ec:	8b 00                	mov    (%eax),%eax
  8016ee:	89 04 24             	mov    %eax,(%esp)
  8016f1:	e8 6b fe ff ff       	call   801561 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	78 4e                	js     801748 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016fd:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801701:	75 23                	jne    801726 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801703:	a1 80 64 80 00       	mov    0x806480,%eax
  801708:	8b 40 4c             	mov    0x4c(%eax),%eax
  80170b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80170f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801713:	c7 04 24 20 2f 80 00 	movl   $0x802f20,(%esp)
  80171a:	e8 de ec ff ff       	call   8003fd <cprintf>
  80171f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801724:	eb 22                	jmp    801748 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801729:	8b 48 0c             	mov    0xc(%eax),%ecx
  80172c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801731:	85 c9                	test   %ecx,%ecx
  801733:	74 13                	je     801748 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801735:	8b 45 10             	mov    0x10(%ebp),%eax
  801738:	89 44 24 08          	mov    %eax,0x8(%esp)
  80173c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80173f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801743:	89 14 24             	mov    %edx,(%esp)
  801746:	ff d1                	call   *%ecx
}
  801748:	83 c4 24             	add    $0x24,%esp
  80174b:	5b                   	pop    %ebx
  80174c:	5d                   	pop    %ebp
  80174d:	c3                   	ret    

0080174e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	53                   	push   %ebx
  801752:	83 ec 24             	sub    $0x24,%esp
  801755:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801758:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80175b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80175f:	89 1c 24             	mov    %ebx,(%esp)
  801762:	e8 86 fd ff ff       	call   8014ed <fd_lookup>
  801767:	85 c0                	test   %eax,%eax
  801769:	78 6b                	js     8017d6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80176b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80176e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801772:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801775:	8b 00                	mov    (%eax),%eax
  801777:	89 04 24             	mov    %eax,(%esp)
  80177a:	e8 e2 fd ff ff       	call   801561 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80177f:	85 c0                	test   %eax,%eax
  801781:	78 53                	js     8017d6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801783:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801786:	8b 42 08             	mov    0x8(%edx),%eax
  801789:	83 e0 03             	and    $0x3,%eax
  80178c:	83 f8 01             	cmp    $0x1,%eax
  80178f:	75 23                	jne    8017b4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801791:	a1 80 64 80 00       	mov    0x806480,%eax
  801796:	8b 40 4c             	mov    0x4c(%eax),%eax
  801799:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80179d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017a1:	c7 04 24 3d 2f 80 00 	movl   $0x802f3d,(%esp)
  8017a8:	e8 50 ec ff ff       	call   8003fd <cprintf>
  8017ad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8017b2:	eb 22                	jmp    8017d6 <read+0x88>
	}
	if (!dev->dev_read)
  8017b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b7:	8b 48 08             	mov    0x8(%eax),%ecx
  8017ba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017bf:	85 c9                	test   %ecx,%ecx
  8017c1:	74 13                	je     8017d6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d1:	89 14 24             	mov    %edx,(%esp)
  8017d4:	ff d1                	call   *%ecx
}
  8017d6:	83 c4 24             	add    $0x24,%esp
  8017d9:	5b                   	pop    %ebx
  8017da:	5d                   	pop    %ebp
  8017db:	c3                   	ret    

008017dc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	57                   	push   %edi
  8017e0:	56                   	push   %esi
  8017e1:	53                   	push   %ebx
  8017e2:	83 ec 1c             	sub    $0x1c,%esp
  8017e5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017e8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017eb:	ba 00 00 00 00       	mov    $0x0,%edx
  8017f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017fa:	85 f6                	test   %esi,%esi
  8017fc:	74 29                	je     801827 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017fe:	89 f0                	mov    %esi,%eax
  801800:	29 d0                	sub    %edx,%eax
  801802:	89 44 24 08          	mov    %eax,0x8(%esp)
  801806:	03 55 0c             	add    0xc(%ebp),%edx
  801809:	89 54 24 04          	mov    %edx,0x4(%esp)
  80180d:	89 3c 24             	mov    %edi,(%esp)
  801810:	e8 39 ff ff ff       	call   80174e <read>
		if (m < 0)
  801815:	85 c0                	test   %eax,%eax
  801817:	78 0e                	js     801827 <readn+0x4b>
			return m;
		if (m == 0)
  801819:	85 c0                	test   %eax,%eax
  80181b:	74 08                	je     801825 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80181d:	01 c3                	add    %eax,%ebx
  80181f:	89 da                	mov    %ebx,%edx
  801821:	39 f3                	cmp    %esi,%ebx
  801823:	72 d9                	jb     8017fe <readn+0x22>
  801825:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801827:	83 c4 1c             	add    $0x1c,%esp
  80182a:	5b                   	pop    %ebx
  80182b:	5e                   	pop    %esi
  80182c:	5f                   	pop    %edi
  80182d:	5d                   	pop    %ebp
  80182e:	c3                   	ret    

0080182f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
  801832:	56                   	push   %esi
  801833:	53                   	push   %ebx
  801834:	83 ec 20             	sub    $0x20,%esp
  801837:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80183a:	89 34 24             	mov    %esi,(%esp)
  80183d:	e8 0e fc ff ff       	call   801450 <fd2num>
  801842:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801845:	89 54 24 04          	mov    %edx,0x4(%esp)
  801849:	89 04 24             	mov    %eax,(%esp)
  80184c:	e8 9c fc ff ff       	call   8014ed <fd_lookup>
  801851:	89 c3                	mov    %eax,%ebx
  801853:	85 c0                	test   %eax,%eax
  801855:	78 05                	js     80185c <fd_close+0x2d>
  801857:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80185a:	74 0c                	je     801868 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80185c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801860:	19 c0                	sbb    %eax,%eax
  801862:	f7 d0                	not    %eax
  801864:	21 c3                	and    %eax,%ebx
  801866:	eb 3d                	jmp    8018a5 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801868:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80186b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80186f:	8b 06                	mov    (%esi),%eax
  801871:	89 04 24             	mov    %eax,(%esp)
  801874:	e8 e8 fc ff ff       	call   801561 <dev_lookup>
  801879:	89 c3                	mov    %eax,%ebx
  80187b:	85 c0                	test   %eax,%eax
  80187d:	78 16                	js     801895 <fd_close+0x66>
		if (dev->dev_close)
  80187f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801882:	8b 40 10             	mov    0x10(%eax),%eax
  801885:	bb 00 00 00 00       	mov    $0x0,%ebx
  80188a:	85 c0                	test   %eax,%eax
  80188c:	74 07                	je     801895 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80188e:	89 34 24             	mov    %esi,(%esp)
  801891:	ff d0                	call   *%eax
  801893:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801895:	89 74 24 04          	mov    %esi,0x4(%esp)
  801899:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018a0:	e8 c5 f9 ff ff       	call   80126a <sys_page_unmap>
	return r;
}
  8018a5:	89 d8                	mov    %ebx,%eax
  8018a7:	83 c4 20             	add    $0x20,%esp
  8018aa:	5b                   	pop    %ebx
  8018ab:	5e                   	pop    %esi
  8018ac:	5d                   	pop    %ebp
  8018ad:	c3                   	ret    

008018ae <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	89 04 24             	mov    %eax,(%esp)
  8018c1:	e8 27 fc ff ff       	call   8014ed <fd_lookup>
  8018c6:	85 c0                	test   %eax,%eax
  8018c8:	78 13                	js     8018dd <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8018ca:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8018d1:	00 
  8018d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d5:	89 04 24             	mov    %eax,(%esp)
  8018d8:	e8 52 ff ff ff       	call   80182f <fd_close>
}
  8018dd:	c9                   	leave  
  8018de:	c3                   	ret    

008018df <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8018df:	55                   	push   %ebp
  8018e0:	89 e5                	mov    %esp,%ebp
  8018e2:	83 ec 18             	sub    $0x18,%esp
  8018e5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8018e8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018f2:	00 
  8018f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f6:	89 04 24             	mov    %eax,(%esp)
  8018f9:	e8 a9 03 00 00       	call   801ca7 <open>
  8018fe:	89 c3                	mov    %eax,%ebx
  801900:	85 c0                	test   %eax,%eax
  801902:	78 1b                	js     80191f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801904:	8b 45 0c             	mov    0xc(%ebp),%eax
  801907:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190b:	89 1c 24             	mov    %ebx,(%esp)
  80190e:	e8 b7 fc ff ff       	call   8015ca <fstat>
  801913:	89 c6                	mov    %eax,%esi
	close(fd);
  801915:	89 1c 24             	mov    %ebx,(%esp)
  801918:	e8 91 ff ff ff       	call   8018ae <close>
  80191d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80191f:	89 d8                	mov    %ebx,%eax
  801921:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801924:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801927:	89 ec                	mov    %ebp,%esp
  801929:	5d                   	pop    %ebp
  80192a:	c3                   	ret    

0080192b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	53                   	push   %ebx
  80192f:	83 ec 14             	sub    $0x14,%esp
  801932:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801937:	89 1c 24             	mov    %ebx,(%esp)
  80193a:	e8 6f ff ff ff       	call   8018ae <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80193f:	83 c3 01             	add    $0x1,%ebx
  801942:	83 fb 20             	cmp    $0x20,%ebx
  801945:	75 f0                	jne    801937 <close_all+0xc>
		close(i);
}
  801947:	83 c4 14             	add    $0x14,%esp
  80194a:	5b                   	pop    %ebx
  80194b:	5d                   	pop    %ebp
  80194c:	c3                   	ret    

0080194d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
  801950:	83 ec 58             	sub    $0x58,%esp
  801953:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801956:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801959:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80195c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80195f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801962:	89 44 24 04          	mov    %eax,0x4(%esp)
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	89 04 24             	mov    %eax,(%esp)
  80196c:	e8 7c fb ff ff       	call   8014ed <fd_lookup>
  801971:	89 c3                	mov    %eax,%ebx
  801973:	85 c0                	test   %eax,%eax
  801975:	0f 88 e0 00 00 00    	js     801a5b <dup+0x10e>
		return r;
	close(newfdnum);
  80197b:	89 3c 24             	mov    %edi,(%esp)
  80197e:	e8 2b ff ff ff       	call   8018ae <close>

	newfd = INDEX2FD(newfdnum);
  801983:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801989:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80198c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80198f:	89 04 24             	mov    %eax,(%esp)
  801992:	e8 c9 fa ff ff       	call   801460 <fd2data>
  801997:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801999:	89 34 24             	mov    %esi,(%esp)
  80199c:	e8 bf fa ff ff       	call   801460 <fd2data>
  8019a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  8019a4:	89 da                	mov    %ebx,%edx
  8019a6:	89 d8                	mov    %ebx,%eax
  8019a8:	c1 e8 16             	shr    $0x16,%eax
  8019ab:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019b2:	a8 01                	test   $0x1,%al
  8019b4:	74 43                	je     8019f9 <dup+0xac>
  8019b6:	c1 ea 0c             	shr    $0xc,%edx
  8019b9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8019c0:	a8 01                	test   $0x1,%al
  8019c2:	74 35                	je     8019f9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  8019c4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8019cb:	25 07 0e 00 00       	and    $0xe07,%eax
  8019d0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019d4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019db:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019e2:	00 
  8019e3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019ee:	e8 d5 f8 ff ff       	call   8012c8 <sys_page_map>
  8019f3:	89 c3                	mov    %eax,%ebx
  8019f5:	85 c0                	test   %eax,%eax
  8019f7:	78 3f                	js     801a38 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  8019f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019fc:	89 c2                	mov    %eax,%edx
  8019fe:	c1 ea 0c             	shr    $0xc,%edx
  801a01:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a08:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a0e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a12:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801a16:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a1d:	00 
  801a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a22:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a29:	e8 9a f8 ff ff       	call   8012c8 <sys_page_map>
  801a2e:	89 c3                	mov    %eax,%ebx
  801a30:	85 c0                	test   %eax,%eax
  801a32:	78 04                	js     801a38 <dup+0xeb>
  801a34:	89 fb                	mov    %edi,%ebx
  801a36:	eb 23                	jmp    801a5b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801a38:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a3c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a43:	e8 22 f8 ff ff       	call   80126a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a48:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a4f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a56:	e8 0f f8 ff ff       	call   80126a <sys_page_unmap>
	return r;
}
  801a5b:	89 d8                	mov    %ebx,%eax
  801a5d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a60:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a63:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a66:	89 ec                	mov    %ebp,%esp
  801a68:	5d                   	pop    %ebp
  801a69:	c3                   	ret    
	...

00801a6c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a6c:	55                   	push   %ebp
  801a6d:	89 e5                	mov    %esp,%ebp
  801a6f:	53                   	push   %ebx
  801a70:	83 ec 14             	sub    $0x14,%esp
  801a73:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a75:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801a7b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a82:	00 
  801a83:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  801a8a:	00 
  801a8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a8f:	89 14 24             	mov    %edx,(%esp)
  801a92:	e8 d9 0c 00 00       	call   802770 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a97:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a9e:	00 
  801a9f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801aa3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aaa:	e8 23 0d 00 00       	call   8027d2 <ipc_recv>
}
  801aaf:	83 c4 14             	add    $0x14,%esp
  801ab2:	5b                   	pop    %ebx
  801ab3:	5d                   	pop    %ebp
  801ab4:	c3                   	ret    

00801ab5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
  801ab8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801abb:	8b 45 08             	mov    0x8(%ebp),%eax
  801abe:	8b 40 0c             	mov    0xc(%eax),%eax
  801ac1:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  801ac6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ac9:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801ace:	ba 00 00 00 00       	mov    $0x0,%edx
  801ad3:	b8 02 00 00 00       	mov    $0x2,%eax
  801ad8:	e8 8f ff ff ff       	call   801a6c <fsipc>
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
  801ae2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ae5:	ba 00 00 00 00       	mov    $0x0,%edx
  801aea:	b8 08 00 00 00       	mov    $0x8,%eax
  801aef:	e8 78 ff ff ff       	call   801a6c <fsipc>
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	53                   	push   %ebx
  801afa:	83 ec 14             	sub    $0x14,%esp
  801afd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b00:	8b 45 08             	mov    0x8(%ebp),%eax
  801b03:	8b 40 0c             	mov    0xc(%eax),%eax
  801b06:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b0b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b10:	b8 05 00 00 00       	mov    $0x5,%eax
  801b15:	e8 52 ff ff ff       	call   801a6c <fsipc>
  801b1a:	85 c0                	test   %eax,%eax
  801b1c:	78 2b                	js     801b49 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b1e:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801b25:	00 
  801b26:	89 1c 24             	mov    %ebx,(%esp)
  801b29:	e8 9c f0 ff ff       	call   800bca <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b2e:	a1 80 30 80 00       	mov    0x803080,%eax
  801b33:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b39:	a1 84 30 80 00       	mov    0x803084,%eax
  801b3e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801b44:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801b49:	83 c4 14             	add    $0x14,%esp
  801b4c:	5b                   	pop    %ebx
  801b4d:	5d                   	pop    %ebp
  801b4e:	c3                   	ret    

00801b4f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b4f:	55                   	push   %ebp
  801b50:	89 e5                	mov    %esp,%ebp
  801b52:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  801b55:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801b5c:	00 
  801b5d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b64:	00 
  801b65:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801b6c:	e8 b5 f1 ff ff       	call   800d26 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	8b 40 0c             	mov    0xc(%eax),%eax
  801b77:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  801b7c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b81:	b8 06 00 00 00       	mov    $0x6,%eax
  801b86:	e8 e1 fe ff ff       	call   801a6c <fsipc>
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801b93:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801b9a:	00 
  801b9b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ba2:	00 
  801ba3:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801baa:	e8 77 f1 ff ff       	call   800d26 <memset>
  801baf:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb2:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801bb7:	76 05                	jbe    801bbe <devfile_write+0x31>
  801bb9:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bbe:	8b 55 08             	mov    0x8(%ebp),%edx
  801bc1:	8b 52 0c             	mov    0xc(%edx),%edx
  801bc4:	89 15 00 30 80 00    	mov    %edx,0x803000
        fsipcbuf.write.req_n = numberOfBytes;
  801bca:	a3 04 30 80 00       	mov    %eax,0x803004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  801bcf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bda:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  801be1:	e8 9f f1 ff ff       	call   800d85 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  801be6:	ba 00 00 00 00       	mov    $0x0,%edx
  801beb:	b8 04 00 00 00       	mov    $0x4,%eax
  801bf0:	e8 77 fe ff ff       	call   801a6c <fsipc>
              return r;
        return r;
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
  801bfa:	53                   	push   %ebx
  801bfb:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  801bfe:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801c05:	00 
  801c06:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c0d:	00 
  801c0e:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801c15:	e8 0c f1 ff ff       	call   800d26 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c20:	a3 00 30 80 00       	mov    %eax,0x803000
        fsipcbuf.read.req_n = n;
  801c25:	8b 45 10             	mov    0x10(%ebp),%eax
  801c28:	a3 04 30 80 00       	mov    %eax,0x803004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  801c2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c32:	b8 03 00 00 00       	mov    $0x3,%eax
  801c37:	e8 30 fe ff ff       	call   801a6c <fsipc>
  801c3c:	89 c3                	mov    %eax,%ebx
  801c3e:	85 c0                	test   %eax,%eax
  801c40:	78 17                	js     801c59 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  801c42:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c46:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801c4d:	00 
  801c4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c51:	89 04 24             	mov    %eax,(%esp)
  801c54:	e8 2c f1 ff ff       	call   800d85 <memmove>
        return r;
}
  801c59:	89 d8                	mov    %ebx,%eax
  801c5b:	83 c4 14             	add    $0x14,%esp
  801c5e:	5b                   	pop    %ebx
  801c5f:	5d                   	pop    %ebp
  801c60:	c3                   	ret    

00801c61 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
  801c64:	53                   	push   %ebx
  801c65:	83 ec 14             	sub    $0x14,%esp
  801c68:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801c6b:	89 1c 24             	mov    %ebx,(%esp)
  801c6e:	e8 0d ef ff ff       	call   800b80 <strlen>
  801c73:	89 c2                	mov    %eax,%edx
  801c75:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801c7a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801c80:	7f 1f                	jg     801ca1 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801c82:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c86:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801c8d:	e8 38 ef ff ff       	call   800bca <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801c92:	ba 00 00 00 00       	mov    $0x0,%edx
  801c97:	b8 07 00 00 00       	mov    $0x7,%eax
  801c9c:	e8 cb fd ff ff       	call   801a6c <fsipc>
}
  801ca1:	83 c4 14             	add    $0x14,%esp
  801ca4:	5b                   	pop    %ebx
  801ca5:	5d                   	pop    %ebp
  801ca6:	c3                   	ret    

00801ca7 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
  801caa:	56                   	push   %esi
  801cab:	53                   	push   %ebx
  801cac:	83 ec 20             	sub    $0x20,%esp
  801caf:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  801cb2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801cb9:	00 
  801cba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801cc1:	00 
  801cc2:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801cc9:	e8 58 f0 ff ff       	call   800d26 <memset>
    if(strlen(path)>=MAXPATHLEN)
  801cce:	89 34 24             	mov    %esi,(%esp)
  801cd1:	e8 aa ee ff ff       	call   800b80 <strlen>
  801cd6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801cdb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ce0:	0f 8f 84 00 00 00    	jg     801d6a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  801ce6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce9:	89 04 24             	mov    %eax,(%esp)
  801cec:	e8 8a f7 ff ff       	call   80147b <fd_alloc>
  801cf1:	89 c3                	mov    %eax,%ebx
  801cf3:	85 c0                	test   %eax,%eax
  801cf5:	78 73                	js     801d6a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  801cf7:	0f b6 06             	movzbl (%esi),%eax
  801cfa:	84 c0                	test   %al,%al
  801cfc:	74 20                	je     801d1e <open+0x77>
  801cfe:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  801d00:	0f be c0             	movsbl %al,%eax
  801d03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d07:	c7 04 24 70 2f 80 00 	movl   $0x802f70,(%esp)
  801d0e:	e8 ea e6 ff ff       	call   8003fd <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  801d13:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  801d17:	83 c3 01             	add    $0x1,%ebx
  801d1a:	84 c0                	test   %al,%al
  801d1c:	75 e2                	jne    801d00 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  801d1e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d22:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801d29:	e8 9c ee ff ff       	call   800bca <strcpy>
    fsipcbuf.open.req_omode = mode;
  801d2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d31:	a3 00 34 80 00       	mov    %eax,0x803400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  801d36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d39:	b8 01 00 00 00       	mov    $0x1,%eax
  801d3e:	e8 29 fd ff ff       	call   801a6c <fsipc>
  801d43:	89 c3                	mov    %eax,%ebx
  801d45:	85 c0                	test   %eax,%eax
  801d47:	79 15                	jns    801d5e <open+0xb7>
        {
            fd_close(fd,1);
  801d49:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801d50:	00 
  801d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d54:	89 04 24             	mov    %eax,(%esp)
  801d57:	e8 d3 fa ff ff       	call   80182f <fd_close>
             return r;
  801d5c:	eb 0c                	jmp    801d6a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  801d5e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801d61:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  801d67:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  801d6a:	89 d8                	mov    %ebx,%eax
  801d6c:	83 c4 20             	add    $0x20,%esp
  801d6f:	5b                   	pop    %ebx
  801d70:	5e                   	pop    %esi
  801d71:	5d                   	pop    %ebp
  801d72:	c3                   	ret    
	...

00801d74 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801d74:	55                   	push   %ebp
  801d75:	89 e5                	mov    %esp,%ebp
  801d77:	53                   	push   %ebx
  801d78:	83 ec 14             	sub    $0x14,%esp
  801d7b:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801d7d:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801d81:	7e 34                	jle    801db7 <writebuf+0x43>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801d83:	8b 40 04             	mov    0x4(%eax),%eax
  801d86:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d8a:	8d 43 10             	lea    0x10(%ebx),%eax
  801d8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d91:	8b 03                	mov    (%ebx),%eax
  801d93:	89 04 24             	mov    %eax,(%esp)
  801d96:	e8 2a f9 ff ff       	call   8016c5 <write>
		if (result > 0)
  801d9b:	85 c0                	test   %eax,%eax
  801d9d:	7e 03                	jle    801da2 <writebuf+0x2e>
			b->result += result;
  801d9f:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801da2:	3b 43 04             	cmp    0x4(%ebx),%eax
  801da5:	74 10                	je     801db7 <writebuf+0x43>
			b->error = (result < 0 ? result : 0);
  801da7:	85 c0                	test   %eax,%eax
  801da9:	0f 9f c2             	setg   %dl
  801dac:	0f b6 d2             	movzbl %dl,%edx
  801daf:	83 ea 01             	sub    $0x1,%edx
  801db2:	21 d0                	and    %edx,%eax
  801db4:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801db7:	83 c4 14             	add    $0x14,%esp
  801dba:	5b                   	pop    %ebx
  801dbb:	5d                   	pop    %ebp
  801dbc:	c3                   	ret    

00801dbd <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
  801dc0:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc9:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801dcf:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801dd6:	00 00 00 
	b.result = 0;
  801dd9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801de0:	00 00 00 
	b.error = 1;
  801de3:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801dea:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801ded:	8b 45 10             	mov    0x10(%ebp),%eax
  801df0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801df7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dfb:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801e01:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e05:	c7 04 24 7a 1e 80 00 	movl   $0x801e7a,(%esp)
  801e0c:	e8 9c e7 ff ff       	call   8005ad <vprintfmt>
	if (b.idx > 0)
  801e11:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801e18:	7e 0b                	jle    801e25 <vfprintf+0x68>
		writebuf(&b);
  801e1a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801e20:	e8 4f ff ff ff       	call   801d74 <writebuf>

	return (b.result ? b.result : b.error);
  801e25:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801e2b:	85 c0                	test   %eax,%eax
  801e2d:	75 06                	jne    801e35 <vfprintf+0x78>
  801e2f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801e35:	c9                   	leave  
  801e36:	c3                   	ret    

00801e37 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  801e37:	55                   	push   %ebp
  801e38:	89 e5                	mov    %esp,%ebp
  801e3a:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  801e3d:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  801e40:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e44:	8b 45 08             	mov    0x8(%ebp),%eax
  801e47:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801e52:	e8 66 ff ff ff       	call   801dbd <vfprintf>
	va_end(ap);

	return cnt;
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
  801e5c:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  801e5f:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  801e62:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e69:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e70:	89 04 24             	mov    %eax,(%esp)
  801e73:	e8 45 ff ff ff       	call   801dbd <vfprintf>
	va_end(ap);

	return cnt;
}
  801e78:	c9                   	leave  
  801e79:	c3                   	ret    

00801e7a <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  801e7a:	55                   	push   %ebp
  801e7b:	89 e5                	mov    %esp,%ebp
  801e7d:	53                   	push   %ebx
  801e7e:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  801e81:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801e84:	8b 43 04             	mov    0x4(%ebx),%eax
  801e87:	8b 55 08             	mov    0x8(%ebp),%edx
  801e8a:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801e8e:	83 c0 01             	add    $0x1,%eax
  801e91:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801e94:	3d 00 01 00 00       	cmp    $0x100,%eax
  801e99:	75 0e                	jne    801ea9 <putch+0x2f>
		writebuf(b);
  801e9b:	89 d8                	mov    %ebx,%eax
  801e9d:	e8 d2 fe ff ff       	call   801d74 <writebuf>
		b->idx = 0;
  801ea2:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801ea9:	83 c4 04             	add    $0x4,%esp
  801eac:	5b                   	pop    %ebx
  801ead:	5d                   	pop    %ebp
  801eae:	c3                   	ret    
	...

00801eb0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801eb6:	c7 44 24 04 73 2f 80 	movl   $0x802f73,0x4(%esp)
  801ebd:	00 
  801ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec1:	89 04 24             	mov    %eax,(%esp)
  801ec4:	e8 01 ed ff ff       	call   800bca <strcpy>
	return 0;
}
  801ec9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ece:	c9                   	leave  
  801ecf:	c3                   	ret    

00801ed0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801ed0:	55                   	push   %ebp
  801ed1:	89 e5                	mov    %esp,%ebp
  801ed3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed9:	8b 40 0c             	mov    0xc(%eax),%eax
  801edc:	89 04 24             	mov    %eax,(%esp)
  801edf:	e8 9e 02 00 00       	call   802182 <nsipc_close>
}
  801ee4:	c9                   	leave  
  801ee5:	c3                   	ret    

00801ee6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ee6:	55                   	push   %ebp
  801ee7:	89 e5                	mov    %esp,%ebp
  801ee9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801eec:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801ef3:	00 
  801ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ef7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	8b 40 0c             	mov    0xc(%eax),%eax
  801f08:	89 04 24             	mov    %eax,(%esp)
  801f0b:	e8 ae 02 00 00       	call   8021be <nsipc_send>
}
  801f10:	c9                   	leave  
  801f11:	c3                   	ret    

00801f12 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801f12:	55                   	push   %ebp
  801f13:	89 e5                	mov    %esp,%ebp
  801f15:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801f18:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f1f:	00 
  801f20:	8b 45 10             	mov    0x10(%ebp),%eax
  801f23:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f31:	8b 40 0c             	mov    0xc(%eax),%eax
  801f34:	89 04 24             	mov    %eax,(%esp)
  801f37:	e8 f5 02 00 00       	call   802231 <nsipc_recv>
}
  801f3c:	c9                   	leave  
  801f3d:	c3                   	ret    

00801f3e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801f3e:	55                   	push   %ebp
  801f3f:	89 e5                	mov    %esp,%ebp
  801f41:	56                   	push   %esi
  801f42:	53                   	push   %ebx
  801f43:	83 ec 20             	sub    $0x20,%esp
  801f46:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f4b:	89 04 24             	mov    %eax,(%esp)
  801f4e:	e8 28 f5 ff ff       	call   80147b <fd_alloc>
  801f53:	89 c3                	mov    %eax,%ebx
  801f55:	85 c0                	test   %eax,%eax
  801f57:	78 21                	js     801f7a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801f59:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801f60:	00 
  801f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f64:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f6f:	e8 b2 f3 ff ff       	call   801326 <sys_page_alloc>
  801f74:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f76:	85 c0                	test   %eax,%eax
  801f78:	79 0a                	jns    801f84 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801f7a:	89 34 24             	mov    %esi,(%esp)
  801f7d:	e8 00 02 00 00       	call   802182 <nsipc_close>
		return r;
  801f82:	eb 28                	jmp    801fac <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f84:	8b 15 3c 60 80 00    	mov    0x80603c,%edx
  801f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa2:	89 04 24             	mov    %eax,(%esp)
  801fa5:	e8 a6 f4 ff ff       	call   801450 <fd2num>
  801faa:	89 c3                	mov    %eax,%ebx
}
  801fac:	89 d8                	mov    %ebx,%eax
  801fae:	83 c4 20             	add    $0x20,%esp
  801fb1:	5b                   	pop    %ebx
  801fb2:	5e                   	pop    %esi
  801fb3:	5d                   	pop    %ebp
  801fb4:	c3                   	ret    

00801fb5 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801fb5:	55                   	push   %ebp
  801fb6:	89 e5                	mov    %esp,%ebp
  801fb8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fbe:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcc:	89 04 24             	mov    %eax,(%esp)
  801fcf:	e8 62 01 00 00       	call   802136 <nsipc_socket>
  801fd4:	85 c0                	test   %eax,%eax
  801fd6:	78 05                	js     801fdd <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801fd8:	e8 61 ff ff ff       	call   801f3e <alloc_sockfd>
}
  801fdd:	c9                   	leave  
  801fde:	66 90                	xchg   %ax,%ax
  801fe0:	c3                   	ret    

00801fe1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801fe1:	55                   	push   %ebp
  801fe2:	89 e5                	mov    %esp,%ebp
  801fe4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fe7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fea:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fee:	89 04 24             	mov    %eax,(%esp)
  801ff1:	e8 f7 f4 ff ff       	call   8014ed <fd_lookup>
  801ff6:	85 c0                	test   %eax,%eax
  801ff8:	78 15                	js     80200f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801ffa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffd:	8b 0a                	mov    (%edx),%ecx
  801fff:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802004:	3b 0d 3c 60 80 00    	cmp    0x80603c,%ecx
  80200a:	75 03                	jne    80200f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80200c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  80200f:	c9                   	leave  
  802010:	c3                   	ret    

00802011 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802011:	55                   	push   %ebp
  802012:	89 e5                	mov    %esp,%ebp
  802014:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802017:	8b 45 08             	mov    0x8(%ebp),%eax
  80201a:	e8 c2 ff ff ff       	call   801fe1 <fd2sockid>
  80201f:	85 c0                	test   %eax,%eax
  802021:	78 0f                	js     802032 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  802023:	8b 55 0c             	mov    0xc(%ebp),%edx
  802026:	89 54 24 04          	mov    %edx,0x4(%esp)
  80202a:	89 04 24             	mov    %eax,(%esp)
  80202d:	e8 2e 01 00 00       	call   802160 <nsipc_listen>
}
  802032:	c9                   	leave  
  802033:	c3                   	ret    

00802034 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80203a:	8b 45 08             	mov    0x8(%ebp),%eax
  80203d:	e8 9f ff ff ff       	call   801fe1 <fd2sockid>
  802042:	85 c0                	test   %eax,%eax
  802044:	78 16                	js     80205c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802046:	8b 55 10             	mov    0x10(%ebp),%edx
  802049:	89 54 24 08          	mov    %edx,0x8(%esp)
  80204d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802050:	89 54 24 04          	mov    %edx,0x4(%esp)
  802054:	89 04 24             	mov    %eax,(%esp)
  802057:	e8 55 02 00 00       	call   8022b1 <nsipc_connect>
}
  80205c:	c9                   	leave  
  80205d:	c3                   	ret    

0080205e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80205e:	55                   	push   %ebp
  80205f:	89 e5                	mov    %esp,%ebp
  802061:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802064:	8b 45 08             	mov    0x8(%ebp),%eax
  802067:	e8 75 ff ff ff       	call   801fe1 <fd2sockid>
  80206c:	85 c0                	test   %eax,%eax
  80206e:	78 0f                	js     80207f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802070:	8b 55 0c             	mov    0xc(%ebp),%edx
  802073:	89 54 24 04          	mov    %edx,0x4(%esp)
  802077:	89 04 24             	mov    %eax,(%esp)
  80207a:	e8 1d 01 00 00       	call   80219c <nsipc_shutdown>
}
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
  802084:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802087:	8b 45 08             	mov    0x8(%ebp),%eax
  80208a:	e8 52 ff ff ff       	call   801fe1 <fd2sockid>
  80208f:	85 c0                	test   %eax,%eax
  802091:	78 16                	js     8020a9 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802093:	8b 55 10             	mov    0x10(%ebp),%edx
  802096:	89 54 24 08          	mov    %edx,0x8(%esp)
  80209a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80209d:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020a1:	89 04 24             	mov    %eax,(%esp)
  8020a4:	e8 47 02 00 00       	call   8022f0 <nsipc_bind>
}
  8020a9:	c9                   	leave  
  8020aa:	c3                   	ret    

008020ab <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8020ab:	55                   	push   %ebp
  8020ac:	89 e5                	mov    %esp,%ebp
  8020ae:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	e8 28 ff ff ff       	call   801fe1 <fd2sockid>
  8020b9:	85 c0                	test   %eax,%eax
  8020bb:	78 1f                	js     8020dc <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8020bd:	8b 55 10             	mov    0x10(%ebp),%edx
  8020c0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020c7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020cb:	89 04 24             	mov    %eax,(%esp)
  8020ce:	e8 5c 02 00 00       	call   80232f <nsipc_accept>
  8020d3:	85 c0                	test   %eax,%eax
  8020d5:	78 05                	js     8020dc <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8020d7:	e8 62 fe ff ff       	call   801f3e <alloc_sockfd>
}
  8020dc:	c9                   	leave  
  8020dd:	8d 76 00             	lea    0x0(%esi),%esi
  8020e0:	c3                   	ret    
	...

008020f0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
  8020f3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020f6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8020fc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802103:	00 
  802104:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  80210b:	00 
  80210c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802110:	89 14 24             	mov    %edx,(%esp)
  802113:	e8 58 06 00 00       	call   802770 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802118:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80211f:	00 
  802120:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802127:	00 
  802128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80212f:	e8 9e 06 00 00       	call   8027d2 <ipc_recv>
}
  802134:	c9                   	leave  
  802135:	c3                   	ret    

00802136 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  802136:	55                   	push   %ebp
  802137:	89 e5                	mov    %esp,%ebp
  802139:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  802144:	8b 45 0c             	mov    0xc(%ebp),%eax
  802147:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  80214c:	8b 45 10             	mov    0x10(%ebp),%eax
  80214f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  802154:	b8 09 00 00 00       	mov    $0x9,%eax
  802159:	e8 92 ff ff ff       	call   8020f0 <nsipc>
}
  80215e:	c9                   	leave  
  80215f:	c3                   	ret    

00802160 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802160:	55                   	push   %ebp
  802161:	89 e5                	mov    %esp,%ebp
  802163:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802166:	8b 45 08             	mov    0x8(%ebp),%eax
  802169:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  80216e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802171:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  802176:	b8 06 00 00 00       	mov    $0x6,%eax
  80217b:	e8 70 ff ff ff       	call   8020f0 <nsipc>
}
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802188:	8b 45 08             	mov    0x8(%ebp),%eax
  80218b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  802190:	b8 04 00 00 00       	mov    $0x4,%eax
  802195:	e8 56 ff ff ff       	call   8020f0 <nsipc>
}
  80219a:	c9                   	leave  
  80219b:	c3                   	ret    

0080219c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80219c:	55                   	push   %ebp
  80219d:	89 e5                	mov    %esp,%ebp
  80219f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8021a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a5:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  8021aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ad:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  8021b2:	b8 03 00 00 00       	mov    $0x3,%eax
  8021b7:	e8 34 ff ff ff       	call   8020f0 <nsipc>
}
  8021bc:	c9                   	leave  
  8021bd:	c3                   	ret    

008021be <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	53                   	push   %ebx
  8021c2:	83 ec 14             	sub    $0x14,%esp
  8021c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  8021d0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021d6:	7e 24                	jle    8021fc <nsipc_send+0x3e>
  8021d8:	c7 44 24 0c 7f 2f 80 	movl   $0x802f7f,0xc(%esp)
  8021df:	00 
  8021e0:	c7 44 24 08 8b 2f 80 	movl   $0x802f8b,0x8(%esp)
  8021e7:	00 
  8021e8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8021ef:	00 
  8021f0:	c7 04 24 a0 2f 80 00 	movl   $0x802fa0,(%esp)
  8021f7:	e8 3c e1 ff ff       	call   800338 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021fc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802200:	8b 45 0c             	mov    0xc(%ebp),%eax
  802203:	89 44 24 04          	mov    %eax,0x4(%esp)
  802207:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  80220e:	e8 72 eb ff ff       	call   800d85 <memmove>
	nsipcbuf.send.req_size = size;
  802213:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  802219:	8b 45 14             	mov    0x14(%ebp),%eax
  80221c:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  802221:	b8 08 00 00 00       	mov    $0x8,%eax
  802226:	e8 c5 fe ff ff       	call   8020f0 <nsipc>
}
  80222b:	83 c4 14             	add    $0x14,%esp
  80222e:	5b                   	pop    %ebx
  80222f:	5d                   	pop    %ebp
  802230:	c3                   	ret    

00802231 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802231:	55                   	push   %ebp
  802232:	89 e5                	mov    %esp,%ebp
  802234:	56                   	push   %esi
  802235:	53                   	push   %ebx
  802236:	83 ec 10             	sub    $0x10,%esp
  802239:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80223c:	8b 45 08             	mov    0x8(%ebp),%eax
  80223f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  802244:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  80224a:	8b 45 14             	mov    0x14(%ebp),%eax
  80224d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802252:	b8 07 00 00 00       	mov    $0x7,%eax
  802257:	e8 94 fe ff ff       	call   8020f0 <nsipc>
  80225c:	89 c3                	mov    %eax,%ebx
  80225e:	85 c0                	test   %eax,%eax
  802260:	78 46                	js     8022a8 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802262:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802267:	7f 04                	jg     80226d <nsipc_recv+0x3c>
  802269:	39 c6                	cmp    %eax,%esi
  80226b:	7d 24                	jge    802291 <nsipc_recv+0x60>
  80226d:	c7 44 24 0c ac 2f 80 	movl   $0x802fac,0xc(%esp)
  802274:	00 
  802275:	c7 44 24 08 8b 2f 80 	movl   $0x802f8b,0x8(%esp)
  80227c:	00 
  80227d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802284:	00 
  802285:	c7 04 24 a0 2f 80 00 	movl   $0x802fa0,(%esp)
  80228c:	e8 a7 e0 ff ff       	call   800338 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802291:	89 44 24 08          	mov    %eax,0x8(%esp)
  802295:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80229c:	00 
  80229d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022a0:	89 04 24             	mov    %eax,(%esp)
  8022a3:	e8 dd ea ff ff       	call   800d85 <memmove>
	}

	return r;
}
  8022a8:	89 d8                	mov    %ebx,%eax
  8022aa:	83 c4 10             	add    $0x10,%esp
  8022ad:	5b                   	pop    %ebx
  8022ae:	5e                   	pop    %esi
  8022af:	5d                   	pop    %ebp
  8022b0:	c3                   	ret    

008022b1 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022b1:	55                   	push   %ebp
  8022b2:	89 e5                	mov    %esp,%ebp
  8022b4:	53                   	push   %ebx
  8022b5:	83 ec 14             	sub    $0x14,%esp
  8022b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ce:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8022d5:	e8 ab ea ff ff       	call   800d85 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022da:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  8022e0:	b8 05 00 00 00       	mov    $0x5,%eax
  8022e5:	e8 06 fe ff ff       	call   8020f0 <nsipc>
}
  8022ea:	83 c4 14             	add    $0x14,%esp
  8022ed:	5b                   	pop    %ebx
  8022ee:	5d                   	pop    %ebp
  8022ef:	c3                   	ret    

008022f0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022f0:	55                   	push   %ebp
  8022f1:	89 e5                	mov    %esp,%ebp
  8022f3:	53                   	push   %ebx
  8022f4:	83 ec 14             	sub    $0x14,%esp
  8022f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802302:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802306:	8b 45 0c             	mov    0xc(%ebp),%eax
  802309:	89 44 24 04          	mov    %eax,0x4(%esp)
  80230d:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  802314:	e8 6c ea ff ff       	call   800d85 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802319:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  80231f:	b8 02 00 00 00       	mov    $0x2,%eax
  802324:	e8 c7 fd ff ff       	call   8020f0 <nsipc>
}
  802329:	83 c4 14             	add    $0x14,%esp
  80232c:	5b                   	pop    %ebx
  80232d:	5d                   	pop    %ebp
  80232e:	c3                   	ret    

0080232f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
  802332:	83 ec 18             	sub    $0x18,%esp
  802335:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802338:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80233b:	8b 45 08             	mov    0x8(%ebp),%eax
  80233e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802343:	b8 01 00 00 00       	mov    $0x1,%eax
  802348:	e8 a3 fd ff ff       	call   8020f0 <nsipc>
  80234d:	89 c3                	mov    %eax,%ebx
  80234f:	85 c0                	test   %eax,%eax
  802351:	78 25                	js     802378 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802353:	be 10 50 80 00       	mov    $0x805010,%esi
  802358:	8b 06                	mov    (%esi),%eax
  80235a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80235e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  802365:	00 
  802366:	8b 45 0c             	mov    0xc(%ebp),%eax
  802369:	89 04 24             	mov    %eax,(%esp)
  80236c:	e8 14 ea ff ff       	call   800d85 <memmove>
		*addrlen = ret->ret_addrlen;
  802371:	8b 16                	mov    (%esi),%edx
  802373:	8b 45 10             	mov    0x10(%ebp),%eax
  802376:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802378:	89 d8                	mov    %ebx,%eax
  80237a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80237d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802380:	89 ec                	mov    %ebp,%esp
  802382:	5d                   	pop    %ebp
  802383:	c3                   	ret    
	...

00802390 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802390:	55                   	push   %ebp
  802391:	89 e5                	mov    %esp,%ebp
  802393:	83 ec 18             	sub    $0x18,%esp
  802396:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802399:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80239c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80239f:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a2:	89 04 24             	mov    %eax,(%esp)
  8023a5:	e8 b6 f0 ff ff       	call   801460 <fd2data>
  8023aa:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8023ac:	c7 44 24 04 c1 2f 80 	movl   $0x802fc1,0x4(%esp)
  8023b3:	00 
  8023b4:	89 34 24             	mov    %esi,(%esp)
  8023b7:	e8 0e e8 ff ff       	call   800bca <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8023bc:	8b 43 04             	mov    0x4(%ebx),%eax
  8023bf:	2b 03                	sub    (%ebx),%eax
  8023c1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8023c7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8023ce:	00 00 00 
	stat->st_dev = &devpipe;
  8023d1:	c7 86 88 00 00 00 58 	movl   $0x806058,0x88(%esi)
  8023d8:	60 80 00 
	return 0;
}
  8023db:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8023e3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8023e6:	89 ec                	mov    %ebp,%esp
  8023e8:	5d                   	pop    %ebp
  8023e9:	c3                   	ret    

008023ea <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023ea:	55                   	push   %ebp
  8023eb:	89 e5                	mov    %esp,%ebp
  8023ed:	53                   	push   %ebx
  8023ee:	83 ec 14             	sub    $0x14,%esp
  8023f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023f4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023ff:	e8 66 ee ff ff       	call   80126a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802404:	89 1c 24             	mov    %ebx,(%esp)
  802407:	e8 54 f0 ff ff       	call   801460 <fd2data>
  80240c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802410:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802417:	e8 4e ee ff ff       	call   80126a <sys_page_unmap>
}
  80241c:	83 c4 14             	add    $0x14,%esp
  80241f:	5b                   	pop    %ebx
  802420:	5d                   	pop    %ebp
  802421:	c3                   	ret    

00802422 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
  802425:	57                   	push   %edi
  802426:	56                   	push   %esi
  802427:	53                   	push   %ebx
  802428:	83 ec 2c             	sub    $0x2c,%esp
  80242b:	89 c7                	mov    %eax,%edi
  80242d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802430:	a1 80 64 80 00       	mov    0x806480,%eax
  802435:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802438:	89 3c 24             	mov    %edi,(%esp)
  80243b:	e8 f8 03 00 00       	call   802838 <pageref>
  802440:	89 c6                	mov    %eax,%esi
  802442:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802445:	89 04 24             	mov    %eax,(%esp)
  802448:	e8 eb 03 00 00       	call   802838 <pageref>
  80244d:	39 c6                	cmp    %eax,%esi
  80244f:	0f 94 c0             	sete   %al
  802452:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802455:	8b 15 80 64 80 00    	mov    0x806480,%edx
  80245b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80245e:	39 cb                	cmp    %ecx,%ebx
  802460:	75 08                	jne    80246a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802462:	83 c4 2c             	add    $0x2c,%esp
  802465:	5b                   	pop    %ebx
  802466:	5e                   	pop    %esi
  802467:	5f                   	pop    %edi
  802468:	5d                   	pop    %ebp
  802469:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80246a:	83 f8 01             	cmp    $0x1,%eax
  80246d:	75 c1                	jne    802430 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80246f:	8b 52 58             	mov    0x58(%edx),%edx
  802472:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802476:	89 54 24 08          	mov    %edx,0x8(%esp)
  80247a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80247e:	c7 04 24 c8 2f 80 00 	movl   $0x802fc8,(%esp)
  802485:	e8 73 df ff ff       	call   8003fd <cprintf>
  80248a:	eb a4                	jmp    802430 <_pipeisclosed+0xe>

0080248c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80248c:	55                   	push   %ebp
  80248d:	89 e5                	mov    %esp,%ebp
  80248f:	57                   	push   %edi
  802490:	56                   	push   %esi
  802491:	53                   	push   %ebx
  802492:	83 ec 1c             	sub    $0x1c,%esp
  802495:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802498:	89 34 24             	mov    %esi,(%esp)
  80249b:	e8 c0 ef ff ff       	call   801460 <fd2data>
  8024a0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8024a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8024ab:	75 54                	jne    802501 <devpipe_write+0x75>
  8024ad:	eb 60                	jmp    80250f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8024af:	89 da                	mov    %ebx,%edx
  8024b1:	89 f0                	mov    %esi,%eax
  8024b3:	e8 6a ff ff ff       	call   802422 <_pipeisclosed>
  8024b8:	85 c0                	test   %eax,%eax
  8024ba:	74 07                	je     8024c3 <devpipe_write+0x37>
  8024bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8024c1:	eb 53                	jmp    802516 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8024c3:	90                   	nop
  8024c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024c8:	e8 b8 ee ff ff       	call   801385 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024cd:	8b 43 04             	mov    0x4(%ebx),%eax
  8024d0:	8b 13                	mov    (%ebx),%edx
  8024d2:	83 c2 20             	add    $0x20,%edx
  8024d5:	39 d0                	cmp    %edx,%eax
  8024d7:	73 d6                	jae    8024af <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024d9:	89 c2                	mov    %eax,%edx
  8024db:	c1 fa 1f             	sar    $0x1f,%edx
  8024de:	c1 ea 1b             	shr    $0x1b,%edx
  8024e1:	01 d0                	add    %edx,%eax
  8024e3:	83 e0 1f             	and    $0x1f,%eax
  8024e6:	29 d0                	sub    %edx,%eax
  8024e8:	89 c2                	mov    %eax,%edx
  8024ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024ed:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8024f1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024f5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024f9:	83 c7 01             	add    $0x1,%edi
  8024fc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8024ff:	76 13                	jbe    802514 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802501:	8b 43 04             	mov    0x4(%ebx),%eax
  802504:	8b 13                	mov    (%ebx),%edx
  802506:	83 c2 20             	add    $0x20,%edx
  802509:	39 d0                	cmp    %edx,%eax
  80250b:	73 a2                	jae    8024af <devpipe_write+0x23>
  80250d:	eb ca                	jmp    8024d9 <devpipe_write+0x4d>
  80250f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802514:	89 f8                	mov    %edi,%eax
}
  802516:	83 c4 1c             	add    $0x1c,%esp
  802519:	5b                   	pop    %ebx
  80251a:	5e                   	pop    %esi
  80251b:	5f                   	pop    %edi
  80251c:	5d                   	pop    %ebp
  80251d:	c3                   	ret    

0080251e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80251e:	55                   	push   %ebp
  80251f:	89 e5                	mov    %esp,%ebp
  802521:	83 ec 28             	sub    $0x28,%esp
  802524:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802527:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80252a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80252d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802530:	89 3c 24             	mov    %edi,(%esp)
  802533:	e8 28 ef ff ff       	call   801460 <fd2data>
  802538:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80253a:	be 00 00 00 00       	mov    $0x0,%esi
  80253f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802543:	75 4c                	jne    802591 <devpipe_read+0x73>
  802545:	eb 5b                	jmp    8025a2 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802547:	89 f0                	mov    %esi,%eax
  802549:	eb 5e                	jmp    8025a9 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80254b:	89 da                	mov    %ebx,%edx
  80254d:	89 f8                	mov    %edi,%eax
  80254f:	90                   	nop
  802550:	e8 cd fe ff ff       	call   802422 <_pipeisclosed>
  802555:	85 c0                	test   %eax,%eax
  802557:	74 07                	je     802560 <devpipe_read+0x42>
  802559:	b8 00 00 00 00       	mov    $0x0,%eax
  80255e:	eb 49                	jmp    8025a9 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802560:	e8 20 ee ff ff       	call   801385 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802565:	8b 03                	mov    (%ebx),%eax
  802567:	3b 43 04             	cmp    0x4(%ebx),%eax
  80256a:	74 df                	je     80254b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80256c:	89 c2                	mov    %eax,%edx
  80256e:	c1 fa 1f             	sar    $0x1f,%edx
  802571:	c1 ea 1b             	shr    $0x1b,%edx
  802574:	01 d0                	add    %edx,%eax
  802576:	83 e0 1f             	and    $0x1f,%eax
  802579:	29 d0                	sub    %edx,%eax
  80257b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802580:	8b 55 0c             	mov    0xc(%ebp),%edx
  802583:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802586:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802589:	83 c6 01             	add    $0x1,%esi
  80258c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80258f:	76 16                	jbe    8025a7 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802591:	8b 03                	mov    (%ebx),%eax
  802593:	3b 43 04             	cmp    0x4(%ebx),%eax
  802596:	75 d4                	jne    80256c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802598:	85 f6                	test   %esi,%esi
  80259a:	75 ab                	jne    802547 <devpipe_read+0x29>
  80259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8025a0:	eb a9                	jmp    80254b <devpipe_read+0x2d>
  8025a2:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8025a7:	89 f0                	mov    %esi,%eax
}
  8025a9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8025ac:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8025af:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8025b2:	89 ec                	mov    %ebp,%esp
  8025b4:	5d                   	pop    %ebp
  8025b5:	c3                   	ret    

008025b6 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8025b6:	55                   	push   %ebp
  8025b7:	89 e5                	mov    %esp,%ebp
  8025b9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8025bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8025bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c6:	89 04 24             	mov    %eax,(%esp)
  8025c9:	e8 1f ef ff ff       	call   8014ed <fd_lookup>
  8025ce:	85 c0                	test   %eax,%eax
  8025d0:	78 15                	js     8025e7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	89 04 24             	mov    %eax,(%esp)
  8025d8:	e8 83 ee ff ff       	call   801460 <fd2data>
	return _pipeisclosed(fd, p);
  8025dd:	89 c2                	mov    %eax,%edx
  8025df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e2:	e8 3b fe ff ff       	call   802422 <_pipeisclosed>
}
  8025e7:	c9                   	leave  
  8025e8:	c3                   	ret    

008025e9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8025e9:	55                   	push   %ebp
  8025ea:	89 e5                	mov    %esp,%ebp
  8025ec:	83 ec 48             	sub    $0x48,%esp
  8025ef:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8025f2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8025f5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8025f8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8025fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8025fe:	89 04 24             	mov    %eax,(%esp)
  802601:	e8 75 ee ff ff       	call   80147b <fd_alloc>
  802606:	89 c3                	mov    %eax,%ebx
  802608:	85 c0                	test   %eax,%eax
  80260a:	0f 88 42 01 00 00    	js     802752 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802610:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802617:	00 
  802618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80261b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80261f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802626:	e8 fb ec ff ff       	call   801326 <sys_page_alloc>
  80262b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80262d:	85 c0                	test   %eax,%eax
  80262f:	0f 88 1d 01 00 00    	js     802752 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802635:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802638:	89 04 24             	mov    %eax,(%esp)
  80263b:	e8 3b ee ff ff       	call   80147b <fd_alloc>
  802640:	89 c3                	mov    %eax,%ebx
  802642:	85 c0                	test   %eax,%eax
  802644:	0f 88 f5 00 00 00    	js     80273f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80264a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802651:	00 
  802652:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802655:	89 44 24 04          	mov    %eax,0x4(%esp)
  802659:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802660:	e8 c1 ec ff ff       	call   801326 <sys_page_alloc>
  802665:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802667:	85 c0                	test   %eax,%eax
  802669:	0f 88 d0 00 00 00    	js     80273f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80266f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802672:	89 04 24             	mov    %eax,(%esp)
  802675:	e8 e6 ed ff ff       	call   801460 <fd2data>
  80267a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80267c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802683:	00 
  802684:	89 44 24 04          	mov    %eax,0x4(%esp)
  802688:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80268f:	e8 92 ec ff ff       	call   801326 <sys_page_alloc>
  802694:	89 c3                	mov    %eax,%ebx
  802696:	85 c0                	test   %eax,%eax
  802698:	0f 88 8e 00 00 00    	js     80272c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80269e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026a1:	89 04 24             	mov    %eax,(%esp)
  8026a4:	e8 b7 ed ff ff       	call   801460 <fd2data>
  8026a9:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8026b0:	00 
  8026b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8026bc:	00 
  8026bd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026c8:	e8 fb eb ff ff       	call   8012c8 <sys_page_map>
  8026cd:	89 c3                	mov    %eax,%ebx
  8026cf:	85 c0                	test   %eax,%eax
  8026d1:	78 49                	js     80271c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8026d3:	b8 58 60 80 00       	mov    $0x806058,%eax
  8026d8:	8b 08                	mov    (%eax),%ecx
  8026da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026dd:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026e2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8026e9:	8b 10                	mov    (%eax),%edx
  8026eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ee:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8026f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026f3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8026fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026fd:	89 04 24             	mov    %eax,(%esp)
  802700:	e8 4b ed ff ff       	call   801450 <fd2num>
  802705:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802707:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270a:	89 04 24             	mov    %eax,(%esp)
  80270d:	e8 3e ed ff ff       	call   801450 <fd2num>
  802712:	89 47 04             	mov    %eax,0x4(%edi)
  802715:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80271a:	eb 36                	jmp    802752 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80271c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802720:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802727:	e8 3e eb ff ff       	call   80126a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80272c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80272f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802733:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80273a:	e8 2b eb ff ff       	call   80126a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80273f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802742:	89 44 24 04          	mov    %eax,0x4(%esp)
  802746:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80274d:	e8 18 eb ff ff       	call   80126a <sys_page_unmap>
    err:
	return r;
}
  802752:	89 d8                	mov    %ebx,%eax
  802754:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802757:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80275a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80275d:	89 ec                	mov    %ebp,%esp
  80275f:	5d                   	pop    %ebp
  802760:	c3                   	ret    
	...

00802770 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802770:	55                   	push   %ebp
  802771:	89 e5                	mov    %esp,%ebp
  802773:	57                   	push   %edi
  802774:	56                   	push   %esi
  802775:	53                   	push   %ebx
  802776:	83 ec 1c             	sub    $0x1c,%esp
  802779:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80277c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80277f:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  802782:	8b 45 14             	mov    0x14(%ebp),%eax
  802785:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802789:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80278d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802791:	89 1c 24             	mov    %ebx,(%esp)
  802794:	e8 7f e9 ff ff       	call   801118 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  802799:	85 c0                	test   %eax,%eax
  80279b:	79 21                	jns    8027be <ipc_send+0x4e>
  80279d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8027a0:	74 1c                	je     8027be <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  8027a2:	c7 44 24 08 e0 2f 80 	movl   $0x802fe0,0x8(%esp)
  8027a9:	00 
  8027aa:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  8027b1:	00 
  8027b2:	c7 04 24 f2 2f 80 00 	movl   $0x802ff2,(%esp)
  8027b9:	e8 7a db ff ff       	call   800338 <_panic>
          else if(r==-E_IPC_NOT_RECV)
  8027be:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8027c1:	75 07                	jne    8027ca <ipc_send+0x5a>
           sys_yield();
  8027c3:	e8 bd eb ff ff       	call   801385 <sys_yield>
          else
            break;
        }
  8027c8:	eb b8                	jmp    802782 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  8027ca:	83 c4 1c             	add    $0x1c,%esp
  8027cd:	5b                   	pop    %ebx
  8027ce:	5e                   	pop    %esi
  8027cf:	5f                   	pop    %edi
  8027d0:	5d                   	pop    %ebp
  8027d1:	c3                   	ret    

008027d2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8027d2:	55                   	push   %ebp
  8027d3:	89 e5                	mov    %esp,%ebp
  8027d5:	83 ec 18             	sub    $0x18,%esp
  8027d8:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8027db:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8027de:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8027e1:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  8027e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027e7:	89 04 24             	mov    %eax,(%esp)
  8027ea:	e8 cc e8 ff ff       	call   8010bb <sys_ipc_recv>
        if(r<0)
  8027ef:	85 c0                	test   %eax,%eax
  8027f1:	79 17                	jns    80280a <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  8027f3:	85 db                	test   %ebx,%ebx
  8027f5:	74 06                	je     8027fd <ipc_recv+0x2b>
               *from_env_store =0;
  8027f7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  8027fd:	85 f6                	test   %esi,%esi
  8027ff:	90                   	nop
  802800:	74 2c                	je     80282e <ipc_recv+0x5c>
              *perm_store=0;
  802802:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802808:	eb 24                	jmp    80282e <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  80280a:	85 db                	test   %ebx,%ebx
  80280c:	74 0a                	je     802818 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  80280e:	a1 80 64 80 00       	mov    0x806480,%eax
  802813:	8b 40 74             	mov    0x74(%eax),%eax
  802816:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  802818:	85 f6                	test   %esi,%esi
  80281a:	74 0a                	je     802826 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  80281c:	a1 80 64 80 00       	mov    0x806480,%eax
  802821:	8b 40 78             	mov    0x78(%eax),%eax
  802824:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  802826:	a1 80 64 80 00       	mov    0x806480,%eax
  80282b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80282e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802831:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802834:	89 ec                	mov    %ebp,%esp
  802836:	5d                   	pop    %ebp
  802837:	c3                   	ret    

00802838 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802838:	55                   	push   %ebp
  802839:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80283b:	8b 45 08             	mov    0x8(%ebp),%eax
  80283e:	89 c2                	mov    %eax,%edx
  802840:	c1 ea 16             	shr    $0x16,%edx
  802843:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80284a:	f6 c2 01             	test   $0x1,%dl
  80284d:	74 26                	je     802875 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  80284f:	c1 e8 0c             	shr    $0xc,%eax
  802852:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802859:	a8 01                	test   $0x1,%al
  80285b:	74 18                	je     802875 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  80285d:	c1 e8 0c             	shr    $0xc,%eax
  802860:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802863:	c1 e2 02             	shl    $0x2,%edx
  802866:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  80286b:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802870:	0f b7 c0             	movzwl %ax,%eax
  802873:	eb 05                	jmp    80287a <pageref+0x42>
  802875:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80287a:	5d                   	pop    %ebp
  80287b:	c3                   	ret    
  80287c:	00 00                	add    %al,(%eax)
	...

00802880 <__udivdi3>:
  802880:	55                   	push   %ebp
  802881:	89 e5                	mov    %esp,%ebp
  802883:	57                   	push   %edi
  802884:	56                   	push   %esi
  802885:	83 ec 10             	sub    $0x10,%esp
  802888:	8b 45 14             	mov    0x14(%ebp),%eax
  80288b:	8b 55 08             	mov    0x8(%ebp),%edx
  80288e:	8b 75 10             	mov    0x10(%ebp),%esi
  802891:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802894:	85 c0                	test   %eax,%eax
  802896:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802899:	75 35                	jne    8028d0 <__udivdi3+0x50>
  80289b:	39 fe                	cmp    %edi,%esi
  80289d:	77 61                	ja     802900 <__udivdi3+0x80>
  80289f:	85 f6                	test   %esi,%esi
  8028a1:	75 0b                	jne    8028ae <__udivdi3+0x2e>
  8028a3:	b8 01 00 00 00       	mov    $0x1,%eax
  8028a8:	31 d2                	xor    %edx,%edx
  8028aa:	f7 f6                	div    %esi
  8028ac:	89 c6                	mov    %eax,%esi
  8028ae:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8028b1:	31 d2                	xor    %edx,%edx
  8028b3:	89 f8                	mov    %edi,%eax
  8028b5:	f7 f6                	div    %esi
  8028b7:	89 c7                	mov    %eax,%edi
  8028b9:	89 c8                	mov    %ecx,%eax
  8028bb:	f7 f6                	div    %esi
  8028bd:	89 c1                	mov    %eax,%ecx
  8028bf:	89 fa                	mov    %edi,%edx
  8028c1:	89 c8                	mov    %ecx,%eax
  8028c3:	83 c4 10             	add    $0x10,%esp
  8028c6:	5e                   	pop    %esi
  8028c7:	5f                   	pop    %edi
  8028c8:	5d                   	pop    %ebp
  8028c9:	c3                   	ret    
  8028ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8028d0:	39 f8                	cmp    %edi,%eax
  8028d2:	77 1c                	ja     8028f0 <__udivdi3+0x70>
  8028d4:	0f bd d0             	bsr    %eax,%edx
  8028d7:	83 f2 1f             	xor    $0x1f,%edx
  8028da:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8028dd:	75 39                	jne    802918 <__udivdi3+0x98>
  8028df:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8028e2:	0f 86 a0 00 00 00    	jbe    802988 <__udivdi3+0x108>
  8028e8:	39 f8                	cmp    %edi,%eax
  8028ea:	0f 82 98 00 00 00    	jb     802988 <__udivdi3+0x108>
  8028f0:	31 ff                	xor    %edi,%edi
  8028f2:	31 c9                	xor    %ecx,%ecx
  8028f4:	89 c8                	mov    %ecx,%eax
  8028f6:	89 fa                	mov    %edi,%edx
  8028f8:	83 c4 10             	add    $0x10,%esp
  8028fb:	5e                   	pop    %esi
  8028fc:	5f                   	pop    %edi
  8028fd:	5d                   	pop    %ebp
  8028fe:	c3                   	ret    
  8028ff:	90                   	nop
  802900:	89 d1                	mov    %edx,%ecx
  802902:	89 fa                	mov    %edi,%edx
  802904:	89 c8                	mov    %ecx,%eax
  802906:	31 ff                	xor    %edi,%edi
  802908:	f7 f6                	div    %esi
  80290a:	89 c1                	mov    %eax,%ecx
  80290c:	89 fa                	mov    %edi,%edx
  80290e:	89 c8                	mov    %ecx,%eax
  802910:	83 c4 10             	add    $0x10,%esp
  802913:	5e                   	pop    %esi
  802914:	5f                   	pop    %edi
  802915:	5d                   	pop    %ebp
  802916:	c3                   	ret    
  802917:	90                   	nop
  802918:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80291c:	89 f2                	mov    %esi,%edx
  80291e:	d3 e0                	shl    %cl,%eax
  802920:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802923:	b8 20 00 00 00       	mov    $0x20,%eax
  802928:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80292b:	89 c1                	mov    %eax,%ecx
  80292d:	d3 ea                	shr    %cl,%edx
  80292f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802933:	0b 55 ec             	or     -0x14(%ebp),%edx
  802936:	d3 e6                	shl    %cl,%esi
  802938:	89 c1                	mov    %eax,%ecx
  80293a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80293d:	89 fe                	mov    %edi,%esi
  80293f:	d3 ee                	shr    %cl,%esi
  802941:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802945:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802948:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80294b:	d3 e7                	shl    %cl,%edi
  80294d:	89 c1                	mov    %eax,%ecx
  80294f:	d3 ea                	shr    %cl,%edx
  802951:	09 d7                	or     %edx,%edi
  802953:	89 f2                	mov    %esi,%edx
  802955:	89 f8                	mov    %edi,%eax
  802957:	f7 75 ec             	divl   -0x14(%ebp)
  80295a:	89 d6                	mov    %edx,%esi
  80295c:	89 c7                	mov    %eax,%edi
  80295e:	f7 65 e8             	mull   -0x18(%ebp)
  802961:	39 d6                	cmp    %edx,%esi
  802963:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802966:	72 30                	jb     802998 <__udivdi3+0x118>
  802968:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80296b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80296f:	d3 e2                	shl    %cl,%edx
  802971:	39 c2                	cmp    %eax,%edx
  802973:	73 05                	jae    80297a <__udivdi3+0xfa>
  802975:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802978:	74 1e                	je     802998 <__udivdi3+0x118>
  80297a:	89 f9                	mov    %edi,%ecx
  80297c:	31 ff                	xor    %edi,%edi
  80297e:	e9 71 ff ff ff       	jmp    8028f4 <__udivdi3+0x74>
  802983:	90                   	nop
  802984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802988:	31 ff                	xor    %edi,%edi
  80298a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80298f:	e9 60 ff ff ff       	jmp    8028f4 <__udivdi3+0x74>
  802994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802998:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80299b:	31 ff                	xor    %edi,%edi
  80299d:	89 c8                	mov    %ecx,%eax
  80299f:	89 fa                	mov    %edi,%edx
  8029a1:	83 c4 10             	add    $0x10,%esp
  8029a4:	5e                   	pop    %esi
  8029a5:	5f                   	pop    %edi
  8029a6:	5d                   	pop    %ebp
  8029a7:	c3                   	ret    
	...

008029b0 <__umoddi3>:
  8029b0:	55                   	push   %ebp
  8029b1:	89 e5                	mov    %esp,%ebp
  8029b3:	57                   	push   %edi
  8029b4:	56                   	push   %esi
  8029b5:	83 ec 20             	sub    $0x20,%esp
  8029b8:	8b 55 14             	mov    0x14(%ebp),%edx
  8029bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8029be:	8b 7d 10             	mov    0x10(%ebp),%edi
  8029c1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8029c4:	85 d2                	test   %edx,%edx
  8029c6:	89 c8                	mov    %ecx,%eax
  8029c8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8029cb:	75 13                	jne    8029e0 <__umoddi3+0x30>
  8029cd:	39 f7                	cmp    %esi,%edi
  8029cf:	76 3f                	jbe    802a10 <__umoddi3+0x60>
  8029d1:	89 f2                	mov    %esi,%edx
  8029d3:	f7 f7                	div    %edi
  8029d5:	89 d0                	mov    %edx,%eax
  8029d7:	31 d2                	xor    %edx,%edx
  8029d9:	83 c4 20             	add    $0x20,%esp
  8029dc:	5e                   	pop    %esi
  8029dd:	5f                   	pop    %edi
  8029de:	5d                   	pop    %ebp
  8029df:	c3                   	ret    
  8029e0:	39 f2                	cmp    %esi,%edx
  8029e2:	77 4c                	ja     802a30 <__umoddi3+0x80>
  8029e4:	0f bd ca             	bsr    %edx,%ecx
  8029e7:	83 f1 1f             	xor    $0x1f,%ecx
  8029ea:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8029ed:	75 51                	jne    802a40 <__umoddi3+0x90>
  8029ef:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8029f2:	0f 87 e0 00 00 00    	ja     802ad8 <__umoddi3+0x128>
  8029f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029fb:	29 f8                	sub    %edi,%eax
  8029fd:	19 d6                	sbb    %edx,%esi
  8029ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a05:	89 f2                	mov    %esi,%edx
  802a07:	83 c4 20             	add    $0x20,%esp
  802a0a:	5e                   	pop    %esi
  802a0b:	5f                   	pop    %edi
  802a0c:	5d                   	pop    %ebp
  802a0d:	c3                   	ret    
  802a0e:	66 90                	xchg   %ax,%ax
  802a10:	85 ff                	test   %edi,%edi
  802a12:	75 0b                	jne    802a1f <__umoddi3+0x6f>
  802a14:	b8 01 00 00 00       	mov    $0x1,%eax
  802a19:	31 d2                	xor    %edx,%edx
  802a1b:	f7 f7                	div    %edi
  802a1d:	89 c7                	mov    %eax,%edi
  802a1f:	89 f0                	mov    %esi,%eax
  802a21:	31 d2                	xor    %edx,%edx
  802a23:	f7 f7                	div    %edi
  802a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a28:	f7 f7                	div    %edi
  802a2a:	eb a9                	jmp    8029d5 <__umoddi3+0x25>
  802a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a30:	89 c8                	mov    %ecx,%eax
  802a32:	89 f2                	mov    %esi,%edx
  802a34:	83 c4 20             	add    $0x20,%esp
  802a37:	5e                   	pop    %esi
  802a38:	5f                   	pop    %edi
  802a39:	5d                   	pop    %ebp
  802a3a:	c3                   	ret    
  802a3b:	90                   	nop
  802a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a40:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a44:	d3 e2                	shl    %cl,%edx
  802a46:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802a49:	ba 20 00 00 00       	mov    $0x20,%edx
  802a4e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802a51:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802a54:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a58:	89 fa                	mov    %edi,%edx
  802a5a:	d3 ea                	shr    %cl,%edx
  802a5c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a60:	0b 55 f4             	or     -0xc(%ebp),%edx
  802a63:	d3 e7                	shl    %cl,%edi
  802a65:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a69:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802a6c:	89 f2                	mov    %esi,%edx
  802a6e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802a71:	89 c7                	mov    %eax,%edi
  802a73:	d3 ea                	shr    %cl,%edx
  802a75:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a79:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802a7c:	89 c2                	mov    %eax,%edx
  802a7e:	d3 e6                	shl    %cl,%esi
  802a80:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802a84:	d3 ea                	shr    %cl,%edx
  802a86:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802a8a:	09 d6                	or     %edx,%esi
  802a8c:	89 f0                	mov    %esi,%eax
  802a8e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802a91:	d3 e7                	shl    %cl,%edi
  802a93:	89 f2                	mov    %esi,%edx
  802a95:	f7 75 f4             	divl   -0xc(%ebp)
  802a98:	89 d6                	mov    %edx,%esi
  802a9a:	f7 65 e8             	mull   -0x18(%ebp)
  802a9d:	39 d6                	cmp    %edx,%esi
  802a9f:	72 2b                	jb     802acc <__umoddi3+0x11c>
  802aa1:	39 c7                	cmp    %eax,%edi
  802aa3:	72 23                	jb     802ac8 <__umoddi3+0x118>
  802aa5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802aa9:	29 c7                	sub    %eax,%edi
  802aab:	19 d6                	sbb    %edx,%esi
  802aad:	89 f0                	mov    %esi,%eax
  802aaf:	89 f2                	mov    %esi,%edx
  802ab1:	d3 ef                	shr    %cl,%edi
  802ab3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ab7:	d3 e0                	shl    %cl,%eax
  802ab9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802abd:	09 f8                	or     %edi,%eax
  802abf:	d3 ea                	shr    %cl,%edx
  802ac1:	83 c4 20             	add    $0x20,%esp
  802ac4:	5e                   	pop    %esi
  802ac5:	5f                   	pop    %edi
  802ac6:	5d                   	pop    %ebp
  802ac7:	c3                   	ret    
  802ac8:	39 d6                	cmp    %edx,%esi
  802aca:	75 d9                	jne    802aa5 <__umoddi3+0xf5>
  802acc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802acf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802ad2:	eb d1                	jmp    802aa5 <__umoddi3+0xf5>
  802ad4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ad8:	39 f2                	cmp    %esi,%edx
  802ada:	0f 82 18 ff ff ff    	jb     8029f8 <__umoddi3+0x48>
  802ae0:	e9 1d ff ff ff       	jmp    802a02 <__umoddi3+0x52>
