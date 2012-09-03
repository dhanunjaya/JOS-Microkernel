
obj/user/init:     file format elf32-i386


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
  80002c:	e8 ab 03 00 00       	call   8003dc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	8b 75 08             	mov    0x8(%ebp),%esi
  800048:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
	for (i = 0; i < n; i++)
  80004b:	b8 00 00 00 00       	mov    $0x0,%eax
  800050:	ba 00 00 00 00       	mov    $0x0,%edx
  800055:	85 db                	test   %ebx,%ebx
  800057:	7e 10                	jle    800069 <sum+0x29>
		tot ^= i * s[i];
  800059:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  80005d:	0f af ca             	imul   %edx,%ecx
  800060:	31 c8                	xor    %ecx,%eax

int
sum(const char *s, int n)
{
	int i, tot = 0;
	for (i = 0; i < n; i++)
  800062:	83 c2 01             	add    $0x1,%edx
  800065:	39 da                	cmp    %ebx,%edx
  800067:	75 f0                	jne    800059 <sum+0x19>
		tot ^= i * s[i];
	return tot;
}
  800069:	5b                   	pop    %ebx
  80006a:	5e                   	pop    %esi
  80006b:	5d                   	pop    %ebp
  80006c:	c3                   	ret    

0080006d <umain>:
		
void
umain(int argc, char **argv)
{
  80006d:	55                   	push   %ebp
  80006e:	89 e5                	mov    %esp,%ebp
  800070:	57                   	push   %edi
  800071:	56                   	push   %esi
  800072:	53                   	push   %ebx
  800073:	83 ec 1c             	sub    $0x1c,%esp
  800076:	8b 7d 08             	mov    0x8(%ebp),%edi
  800079:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, r, x, want;

	cprintf("init: running\n");
  80007c:	c7 04 24 60 30 80 00 	movl   $0x803060,(%esp)
  800083:	e8 85 04 00 00       	call   80050d <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800088:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  80008f:	00 
  800090:	c7 04 24 00 70 80 00 	movl   $0x807000,(%esp)
  800097:	e8 a4 ff ff ff       	call   800040 <sum>
  80009c:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  8000a1:	74 1a                	je     8000bd <umain+0x50>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  8000a3:	c7 44 24 08 9e 98 0f 	movl   $0xf989e,0x8(%esp)
  8000aa:	00 
  8000ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000af:	c7 04 24 28 31 80 00 	movl   $0x803128,(%esp)
  8000b6:	e8 52 04 00 00       	call   80050d <cprintf>
  8000bb:	eb 0c                	jmp    8000c9 <umain+0x5c>
			x, want);
	else
		cprintf("init: data seems okay\n");
  8000bd:	c7 04 24 6f 30 80 00 	movl   $0x80306f,(%esp)
  8000c4:	e8 44 04 00 00       	call   80050d <cprintf>
	if ((x = sum(bss, sizeof bss)) != 0)
  8000c9:	c7 44 24 04 70 17 00 	movl   $0x1770,0x4(%esp)
  8000d0:	00 
  8000d1:	c7 04 24 00 88 80 00 	movl   $0x808800,(%esp)
  8000d8:	e8 63 ff ff ff       	call   800040 <sum>
  8000dd:	85 c0                	test   %eax,%eax
  8000df:	74 12                	je     8000f3 <umain+0x86>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e5:	c7 04 24 64 31 80 00 	movl   $0x803164,(%esp)
  8000ec:	e8 1c 04 00 00       	call   80050d <cprintf>
  8000f1:	eb 0c                	jmp    8000ff <umain+0x92>
	else
		cprintf("init: bss seems okay\n");
  8000f3:	c7 04 24 86 30 80 00 	movl   $0x803086,(%esp)
  8000fa:	e8 0e 04 00 00       	call   80050d <cprintf>

	cprintf("init: args:");
  8000ff:	c7 04 24 9c 30 80 00 	movl   $0x80309c,(%esp)
  800106:	e8 02 04 00 00       	call   80050d <cprintf>
	for (i = 0; i < argc; i++)
  80010b:	85 ff                	test   %edi,%edi
  80010d:	7e 1f                	jle    80012e <umain+0xc1>
  80010f:	bb 00 00 00 00       	mov    $0x0,%ebx
		cprintf(" '%s'", argv[i]);
  800114:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  800117:	89 44 24 04          	mov    %eax,0x4(%esp)
  80011b:	c7 04 24 a8 30 80 00 	movl   $0x8030a8,(%esp)
  800122:	e8 e6 03 00 00       	call   80050d <cprintf>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
	else
		cprintf("init: bss seems okay\n");

	cprintf("init: args:");
	for (i = 0; i < argc; i++)
  800127:	83 c3 01             	add    $0x1,%ebx
  80012a:	39 df                	cmp    %ebx,%edi
  80012c:	7f e6                	jg     800114 <umain+0xa7>
		cprintf(" '%s'", argv[i]);
	cprintf("\n");
  80012e:	c7 04 24 c5 36 80 00 	movl   $0x8036c5,(%esp)
  800135:	e8 d3 03 00 00       	call   80050d <cprintf>

	cprintf("init: running sh\n");
  80013a:	c7 04 24 ae 30 80 00 	movl   $0x8030ae,(%esp)
  800141:	e8 c7 03 00 00       	call   80050d <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  800146:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80014d:	e8 7c 17 00 00       	call   8018ce <close>
	if ((r = opencons()) < 0)
  800152:	e8 c9 01 00 00       	call   800320 <opencons>
  800157:	85 c0                	test   %eax,%eax
  800159:	79 20                	jns    80017b <umain+0x10e>
		panic("opencons: %e", r);
  80015b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80015f:	c7 44 24 08 c0 30 80 	movl   $0x8030c0,0x8(%esp)
  800166:	00 
  800167:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
  80016e:	00 
  80016f:	c7 04 24 cd 30 80 00 	movl   $0x8030cd,(%esp)
  800176:	e8 cd 02 00 00       	call   800448 <_panic>
	if (r != 0)
  80017b:	85 c0                	test   %eax,%eax
  80017d:	74 20                	je     80019f <umain+0x132>
		panic("first opencons used fd %d", r);
  80017f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800183:	c7 44 24 08 d9 30 80 	movl   $0x8030d9,0x8(%esp)
  80018a:	00 
  80018b:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
  800192:	00 
  800193:	c7 04 24 cd 30 80 00 	movl   $0x8030cd,(%esp)
  80019a:	e8 a9 02 00 00       	call   800448 <_panic>
	if ((r = dup(0, 1)) < 0)
  80019f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8001a6:	00 
  8001a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001ae:	e8 ba 17 00 00       	call   80196d <dup>
  8001b3:	85 c0                	test   %eax,%eax
  8001b5:	79 20                	jns    8001d7 <umain+0x16a>
		panic("dup: %e", r);
  8001b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001bb:	c7 44 24 08 f3 30 80 	movl   $0x8030f3,0x8(%esp)
  8001c2:	00 
  8001c3:	c7 44 24 04 36 00 00 	movl   $0x36,0x4(%esp)
  8001ca:	00 
  8001cb:	c7 04 24 cd 30 80 00 	movl   $0x8030cd,(%esp)
  8001d2:	e8 71 02 00 00       	call   800448 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
  8001d7:	c7 04 24 fb 30 80 00 	movl   $0x8030fb,(%esp)
  8001de:	e8 2a 03 00 00       	call   80050d <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001e3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001ea:	00 
  8001eb:	c7 44 24 04 0f 31 80 	movl   $0x80310f,0x4(%esp)
  8001f2:	00 
  8001f3:	c7 04 24 0e 31 80 00 	movl   $0x80310e,(%esp)
  8001fa:	e8 a2 21 00 00       	call   8023a1 <spawnl>
		if (r < 0) {
  8001ff:	85 c0                	test   %eax,%eax
  800201:	79 12                	jns    800215 <umain+0x1a8>
			cprintf("init: spawn sh: %e\n", r);
  800203:	89 44 24 04          	mov    %eax,0x4(%esp)
  800207:	c7 04 24 12 31 80 00 	movl   $0x803112,(%esp)
  80020e:	e8 fa 02 00 00       	call   80050d <cprintf>
			continue;
  800213:	eb c2                	jmp    8001d7 <umain+0x16a>
		}
		wait(r);
  800215:	89 04 24             	mov    %eax,(%esp)
  800218:	e8 57 2a 00 00       	call   802c74 <wait>
  80021d:	8d 76 00             	lea    0x0(%esi),%esi
  800220:	eb b5                	jmp    8001d7 <umain+0x16a>
	...

00800230 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800230:	55                   	push   %ebp
  800231:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800233:	b8 00 00 00 00       	mov    $0x0,%eax
  800238:	5d                   	pop    %ebp
  800239:	c3                   	ret    

0080023a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80023a:	55                   	push   %ebp
  80023b:	89 e5                	mov    %esp,%ebp
  80023d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  800240:	c7 44 24 04 93 31 80 	movl   $0x803193,0x4(%esp)
  800247:	00 
  800248:	8b 45 0c             	mov    0xc(%ebp),%eax
  80024b:	89 04 24             	mov    %eax,(%esp)
  80024e:	e8 97 09 00 00       	call   800bea <strcpy>
	return 0;
}
  800253:	b8 00 00 00 00       	mov    $0x0,%eax
  800258:	c9                   	leave  
  800259:	c3                   	ret    

0080025a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80025a:	55                   	push   %ebp
  80025b:	89 e5                	mov    %esp,%ebp
  80025d:	57                   	push   %edi
  80025e:	56                   	push   %esi
  80025f:	53                   	push   %ebx
  800260:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  800266:	b8 00 00 00 00       	mov    $0x0,%eax
  80026b:	be 00 00 00 00       	mov    $0x0,%esi
  800270:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800274:	74 3f                	je     8002b5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  800276:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80027c:	8b 55 10             	mov    0x10(%ebp),%edx
  80027f:	29 c2                	sub    %eax,%edx
  800281:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  800283:	83 fa 7f             	cmp    $0x7f,%edx
  800286:	76 05                	jbe    80028d <devcons_write+0x33>
  800288:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80028d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800291:	03 45 0c             	add    0xc(%ebp),%eax
  800294:	89 44 24 04          	mov    %eax,0x4(%esp)
  800298:	89 3c 24             	mov    %edi,(%esp)
  80029b:	e8 05 0b 00 00       	call   800da5 <memmove>
		sys_cputs(buf, m);
  8002a0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8002a4:	89 3c 24             	mov    %edi,(%esp)
  8002a7:	e8 34 0d 00 00       	call   800fe0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8002ac:	01 de                	add    %ebx,%esi
  8002ae:	89 f0                	mov    %esi,%eax
  8002b0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8002b3:	72 c7                	jb     80027c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8002b5:	89 f0                	mov    %esi,%eax
  8002b7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8002bd:	5b                   	pop    %ebx
  8002be:	5e                   	pop    %esi
  8002bf:	5f                   	pop    %edi
  8002c0:	5d                   	pop    %ebp
  8002c1:	c3                   	ret    

008002c2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8002c2:	55                   	push   %ebp
  8002c3:	89 e5                	mov    %esp,%ebp
  8002c5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8002cb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8002ce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8002d5:	00 
  8002d6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002d9:	89 04 24             	mov    %eax,(%esp)
  8002dc:	e8 ff 0c 00 00       	call   800fe0 <sys_cputs>
}
  8002e1:	c9                   	leave  
  8002e2:	c3                   	ret    

008002e3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8002e9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002ed:	75 07                	jne    8002f6 <devcons_read+0x13>
  8002ef:	eb 28                	jmp    800319 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8002f1:	e8 af 10 00 00       	call   8013a5 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8002f6:	66 90                	xchg   %ax,%ax
  8002f8:	e8 af 0c 00 00       	call   800fac <sys_cgetc>
  8002fd:	85 c0                	test   %eax,%eax
  8002ff:	90                   	nop
  800300:	74 ef                	je     8002f1 <devcons_read+0xe>
  800302:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  800304:	85 c0                	test   %eax,%eax
  800306:	78 16                	js     80031e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  800308:	83 f8 04             	cmp    $0x4,%eax
  80030b:	74 0c                	je     800319 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800310:	88 10                	mov    %dl,(%eax)
  800312:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  800317:	eb 05                	jmp    80031e <devcons_read+0x3b>
  800319:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80031e:	c9                   	leave  
  80031f:	c3                   	ret    

00800320 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  800320:	55                   	push   %ebp
  800321:	89 e5                	mov    %esp,%ebp
  800323:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  800326:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800329:	89 04 24             	mov    %eax,(%esp)
  80032c:	e8 6a 11 00 00       	call   80149b <fd_alloc>
  800331:	85 c0                	test   %eax,%eax
  800333:	78 3f                	js     800374 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800335:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80033c:	00 
  80033d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800340:	89 44 24 04          	mov    %eax,0x4(%esp)
  800344:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80034b:	e8 f6 0f 00 00       	call   801346 <sys_page_alloc>
  800350:	85 c0                	test   %eax,%eax
  800352:	78 20                	js     800374 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  800354:	8b 15 70 87 80 00    	mov    0x808770,%edx
  80035a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80035d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80035f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800362:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036c:	89 04 24             	mov    %eax,(%esp)
  80036f:	e8 fc 10 00 00       	call   801470 <fd2num>
}
  800374:	c9                   	leave  
  800375:	c3                   	ret    

00800376 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  800376:	55                   	push   %ebp
  800377:	89 e5                	mov    %esp,%ebp
  800379:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80037c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80037f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800383:	8b 45 08             	mov    0x8(%ebp),%eax
  800386:	89 04 24             	mov    %eax,(%esp)
  800389:	e8 7f 11 00 00       	call   80150d <fd_lookup>
  80038e:	85 c0                	test   %eax,%eax
  800390:	78 11                	js     8003a3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  800392:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800395:	8b 00                	mov    (%eax),%eax
  800397:	3b 05 70 87 80 00    	cmp    0x808770,%eax
  80039d:	0f 94 c0             	sete   %al
  8003a0:	0f b6 c0             	movzbl %al,%eax
}
  8003a3:	c9                   	leave  
  8003a4:	c3                   	ret    

008003a5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8003a5:	55                   	push   %ebp
  8003a6:	89 e5                	mov    %esp,%ebp
  8003a8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8003ab:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8003b2:	00 
  8003b3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003ba:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003c1:	e8 a8 13 00 00       	call   80176e <read>
	if (r < 0)
  8003c6:	85 c0                	test   %eax,%eax
  8003c8:	78 0f                	js     8003d9 <getchar+0x34>
		return r;
	if (r < 1)
  8003ca:	85 c0                	test   %eax,%eax
  8003cc:	7f 07                	jg     8003d5 <getchar+0x30>
  8003ce:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8003d3:	eb 04                	jmp    8003d9 <getchar+0x34>
		return -E_EOF;
	return c;
  8003d5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8003d9:	c9                   	leave  
  8003da:	c3                   	ret    
	...

008003dc <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	83 ec 18             	sub    $0x18,%esp
  8003e2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8003e5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8003e8:	8b 75 08             	mov    0x8(%ebp),%esi
  8003eb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  8003ee:	e8 e6 0f 00 00       	call   8013d9 <sys_getenvid>
  8003f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003f8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8003fb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800400:	a3 70 9f 80 00       	mov    %eax,0x809f70

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800405:	85 f6                	test   %esi,%esi
  800407:	7e 07                	jle    800410 <libmain+0x34>
		binaryname = argv[0];
  800409:	8b 03                	mov    (%ebx),%eax
  80040b:	a3 8c 87 80 00       	mov    %eax,0x80878c

	// call user main routine
	umain(argc, argv);
  800410:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800414:	89 34 24             	mov    %esi,(%esp)
  800417:	e8 51 fc ff ff       	call   80006d <umain>

	// exit gracefully
	exit();
  80041c:	e8 0b 00 00 00       	call   80042c <exit>
}
  800421:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800424:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800427:	89 ec                	mov    %ebp,%esp
  800429:	5d                   	pop    %ebp
  80042a:	c3                   	ret    
	...

0080042c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80042c:	55                   	push   %ebp
  80042d:	89 e5                	mov    %esp,%ebp
  80042f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800432:	e8 14 15 00 00       	call   80194b <close_all>
	sys_env_destroy(0);
  800437:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80043e:	e8 ca 0f 00 00       	call   80140d <sys_env_destroy>
}
  800443:	c9                   	leave  
  800444:	c3                   	ret    
  800445:	00 00                	add    %al,(%eax)
	...

00800448 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800448:	55                   	push   %ebp
  800449:	89 e5                	mov    %esp,%ebp
  80044b:	53                   	push   %ebx
  80044c:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  80044f:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800452:	a1 74 9f 80 00       	mov    0x809f74,%eax
  800457:	85 c0                	test   %eax,%eax
  800459:	74 10                	je     80046b <_panic+0x23>
		cprintf("%s: ", argv0);
  80045b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80045f:	c7 04 24 b6 31 80 00 	movl   $0x8031b6,(%esp)
  800466:	e8 a2 00 00 00       	call   80050d <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80046b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800472:	8b 45 08             	mov    0x8(%ebp),%eax
  800475:	89 44 24 08          	mov    %eax,0x8(%esp)
  800479:	a1 8c 87 80 00       	mov    0x80878c,%eax
  80047e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800482:	c7 04 24 bb 31 80 00 	movl   $0x8031bb,(%esp)
  800489:	e8 7f 00 00 00       	call   80050d <cprintf>
	vcprintf(fmt, ap);
  80048e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800492:	8b 45 10             	mov    0x10(%ebp),%eax
  800495:	89 04 24             	mov    %eax,(%esp)
  800498:	e8 0f 00 00 00       	call   8004ac <vcprintf>
	cprintf("\n");
  80049d:	c7 04 24 c5 36 80 00 	movl   $0x8036c5,(%esp)
  8004a4:	e8 64 00 00 00       	call   80050d <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8004a9:	cc                   	int3   
  8004aa:	eb fd                	jmp    8004a9 <_panic+0x61>

008004ac <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8004ac:	55                   	push   %ebp
  8004ad:	89 e5                	mov    %esp,%ebp
  8004af:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8004b5:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004bc:	00 00 00 
	b.cnt = 0;
  8004bf:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004c6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8004d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004d7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004e1:	c7 04 24 27 05 80 00 	movl   $0x800527,(%esp)
  8004e8:	e8 d0 01 00 00       	call   8006bd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004ed:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8004f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004f7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004fd:	89 04 24             	mov    %eax,(%esp)
  800500:	e8 db 0a 00 00       	call   800fe0 <sys_cputs>

	return b.cnt;
}
  800505:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80050b:	c9                   	leave  
  80050c:	c3                   	ret    

0080050d <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80050d:	55                   	push   %ebp
  80050e:	89 e5                	mov    %esp,%ebp
  800510:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800513:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  800516:	89 44 24 04          	mov    %eax,0x4(%esp)
  80051a:	8b 45 08             	mov    0x8(%ebp),%eax
  80051d:	89 04 24             	mov    %eax,(%esp)
  800520:	e8 87 ff ff ff       	call   8004ac <vcprintf>
	va_end(ap);

	return cnt;
}
  800525:	c9                   	leave  
  800526:	c3                   	ret    

00800527 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800527:	55                   	push   %ebp
  800528:	89 e5                	mov    %esp,%ebp
  80052a:	53                   	push   %ebx
  80052b:	83 ec 14             	sub    $0x14,%esp
  80052e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800531:	8b 03                	mov    (%ebx),%eax
  800533:	8b 55 08             	mov    0x8(%ebp),%edx
  800536:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80053a:	83 c0 01             	add    $0x1,%eax
  80053d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  80053f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800544:	75 19                	jne    80055f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800546:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80054d:	00 
  80054e:	8d 43 08             	lea    0x8(%ebx),%eax
  800551:	89 04 24             	mov    %eax,(%esp)
  800554:	e8 87 0a 00 00       	call   800fe0 <sys_cputs>
		b->idx = 0;
  800559:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80055f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800563:	83 c4 14             	add    $0x14,%esp
  800566:	5b                   	pop    %ebx
  800567:	5d                   	pop    %ebp
  800568:	c3                   	ret    
  800569:	00 00                	add    %al,(%eax)
  80056b:	00 00                	add    %al,(%eax)
  80056d:	00 00                	add    %al,(%eax)
	...

00800570 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	57                   	push   %edi
  800574:	56                   	push   %esi
  800575:	53                   	push   %ebx
  800576:	83 ec 4c             	sub    $0x4c,%esp
  800579:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80057c:	89 d6                	mov    %edx,%esi
  80057e:	8b 45 08             	mov    0x8(%ebp),%eax
  800581:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800584:	8b 55 0c             	mov    0xc(%ebp),%edx
  800587:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80058a:	8b 45 10             	mov    0x10(%ebp),%eax
  80058d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800590:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800593:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800596:	b9 00 00 00 00       	mov    $0x0,%ecx
  80059b:	39 d1                	cmp    %edx,%ecx
  80059d:	72 15                	jb     8005b4 <printnum+0x44>
  80059f:	77 07                	ja     8005a8 <printnum+0x38>
  8005a1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a4:	39 d0                	cmp    %edx,%eax
  8005a6:	76 0c                	jbe    8005b4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005a8:	83 eb 01             	sub    $0x1,%ebx
  8005ab:	85 db                	test   %ebx,%ebx
  8005ad:	8d 76 00             	lea    0x0(%esi),%esi
  8005b0:	7f 61                	jg     800613 <printnum+0xa3>
  8005b2:	eb 70                	jmp    800624 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8005b8:	83 eb 01             	sub    $0x1,%ebx
  8005bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8005bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005c3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8005c7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8005cb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8005ce:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8005d1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8005d4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8005d8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8005df:	00 
  8005e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005e3:	89 04 24             	mov    %eax,(%esp)
  8005e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005ed:	e8 fe 27 00 00       	call   802df0 <__udivdi3>
  8005f2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8005f5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005f8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005fc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800600:	89 04 24             	mov    %eax,(%esp)
  800603:	89 54 24 04          	mov    %edx,0x4(%esp)
  800607:	89 f2                	mov    %esi,%edx
  800609:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80060c:	e8 5f ff ff ff       	call   800570 <printnum>
  800611:	eb 11                	jmp    800624 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800613:	89 74 24 04          	mov    %esi,0x4(%esp)
  800617:	89 3c 24             	mov    %edi,(%esp)
  80061a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80061d:	83 eb 01             	sub    $0x1,%ebx
  800620:	85 db                	test   %ebx,%ebx
  800622:	7f ef                	jg     800613 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800624:	89 74 24 04          	mov    %esi,0x4(%esp)
  800628:	8b 74 24 04          	mov    0x4(%esp),%esi
  80062c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80062f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800633:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80063a:	00 
  80063b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80063e:	89 14 24             	mov    %edx,(%esp)
  800641:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800644:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800648:	e8 d3 28 00 00       	call   802f20 <__umoddi3>
  80064d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800651:	0f be 80 d7 31 80 00 	movsbl 0x8031d7(%eax),%eax
  800658:	89 04 24             	mov    %eax,(%esp)
  80065b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80065e:	83 c4 4c             	add    $0x4c,%esp
  800661:	5b                   	pop    %ebx
  800662:	5e                   	pop    %esi
  800663:	5f                   	pop    %edi
  800664:	5d                   	pop    %ebp
  800665:	c3                   	ret    

00800666 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800666:	55                   	push   %ebp
  800667:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800669:	83 fa 01             	cmp    $0x1,%edx
  80066c:	7e 0e                	jle    80067c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80066e:	8b 10                	mov    (%eax),%edx
  800670:	8d 4a 08             	lea    0x8(%edx),%ecx
  800673:	89 08                	mov    %ecx,(%eax)
  800675:	8b 02                	mov    (%edx),%eax
  800677:	8b 52 04             	mov    0x4(%edx),%edx
  80067a:	eb 22                	jmp    80069e <getuint+0x38>
	else if (lflag)
  80067c:	85 d2                	test   %edx,%edx
  80067e:	74 10                	je     800690 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800680:	8b 10                	mov    (%eax),%edx
  800682:	8d 4a 04             	lea    0x4(%edx),%ecx
  800685:	89 08                	mov    %ecx,(%eax)
  800687:	8b 02                	mov    (%edx),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	eb 0e                	jmp    80069e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800690:	8b 10                	mov    (%eax),%edx
  800692:	8d 4a 04             	lea    0x4(%edx),%ecx
  800695:	89 08                	mov    %ecx,(%eax)
  800697:	8b 02                	mov    (%edx),%eax
  800699:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80069e:	5d                   	pop    %ebp
  80069f:	c3                   	ret    

008006a0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
  8006a3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006a6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8006aa:	8b 10                	mov    (%eax),%edx
  8006ac:	3b 50 04             	cmp    0x4(%eax),%edx
  8006af:	73 0a                	jae    8006bb <sprintputch+0x1b>
		*b->buf++ = ch;
  8006b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8006b4:	88 0a                	mov    %cl,(%edx)
  8006b6:	83 c2 01             	add    $0x1,%edx
  8006b9:	89 10                	mov    %edx,(%eax)
}
  8006bb:	5d                   	pop    %ebp
  8006bc:	c3                   	ret    

008006bd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
  8006c0:	57                   	push   %edi
  8006c1:	56                   	push   %esi
  8006c2:	53                   	push   %ebx
  8006c3:	83 ec 5c             	sub    $0x5c,%esp
  8006c6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8006c9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8006cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8006cf:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8006d6:	eb 11                	jmp    8006e9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8006d8:	85 c0                	test   %eax,%eax
  8006da:	0f 84 09 04 00 00    	je     800ae9 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  8006e0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006e4:	89 04 24             	mov    %eax,(%esp)
  8006e7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006e9:	0f b6 03             	movzbl (%ebx),%eax
  8006ec:	83 c3 01             	add    $0x1,%ebx
  8006ef:	83 f8 25             	cmp    $0x25,%eax
  8006f2:	75 e4                	jne    8006d8 <vprintfmt+0x1b>
  8006f4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8006f8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8006ff:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800706:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80070d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800712:	eb 06                	jmp    80071a <vprintfmt+0x5d>
  800714:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800718:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80071a:	0f b6 13             	movzbl (%ebx),%edx
  80071d:	0f b6 c2             	movzbl %dl,%eax
  800720:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800723:	8d 43 01             	lea    0x1(%ebx),%eax
  800726:	83 ea 23             	sub    $0x23,%edx
  800729:	80 fa 55             	cmp    $0x55,%dl
  80072c:	0f 87 9a 03 00 00    	ja     800acc <vprintfmt+0x40f>
  800732:	0f b6 d2             	movzbl %dl,%edx
  800735:	ff 24 95 20 33 80 00 	jmp    *0x803320(,%edx,4)
  80073c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800740:	eb d6                	jmp    800718 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800742:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800745:	83 ea 30             	sub    $0x30,%edx
  800748:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  80074b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80074e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800751:	83 fb 09             	cmp    $0x9,%ebx
  800754:	77 4c                	ja     8007a2 <vprintfmt+0xe5>
  800756:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800759:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80075c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80075f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800762:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800766:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800769:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80076c:	83 fb 09             	cmp    $0x9,%ebx
  80076f:	76 eb                	jbe    80075c <vprintfmt+0x9f>
  800771:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800774:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800777:	eb 29                	jmp    8007a2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800779:	8b 55 14             	mov    0x14(%ebp),%edx
  80077c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80077f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800782:	8b 12                	mov    (%edx),%edx
  800784:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  800787:	eb 19                	jmp    8007a2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800789:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80078c:	c1 fa 1f             	sar    $0x1f,%edx
  80078f:	f7 d2                	not    %edx
  800791:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800794:	eb 82                	jmp    800718 <vprintfmt+0x5b>
  800796:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80079d:	e9 76 ff ff ff       	jmp    800718 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8007a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a6:	0f 89 6c ff ff ff    	jns    800718 <vprintfmt+0x5b>
  8007ac:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8007af:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007b2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8007b5:	89 55 cc             	mov    %edx,-0x34(%ebp)
  8007b8:	e9 5b ff ff ff       	jmp    800718 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007bd:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8007c0:	e9 53 ff ff ff       	jmp    800718 <vprintfmt+0x5b>
  8007c5:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cb:	8d 50 04             	lea    0x4(%eax),%edx
  8007ce:	89 55 14             	mov    %edx,0x14(%ebp)
  8007d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007d5:	8b 00                	mov    (%eax),%eax
  8007d7:	89 04 24             	mov    %eax,(%esp)
  8007da:	ff d7                	call   *%edi
  8007dc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8007df:	e9 05 ff ff ff       	jmp    8006e9 <vprintfmt+0x2c>
  8007e4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ea:	8d 50 04             	lea    0x4(%eax),%edx
  8007ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8007f0:	8b 00                	mov    (%eax),%eax
  8007f2:	89 c2                	mov    %eax,%edx
  8007f4:	c1 fa 1f             	sar    $0x1f,%edx
  8007f7:	31 d0                	xor    %edx,%eax
  8007f9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007fb:	83 f8 0f             	cmp    $0xf,%eax
  8007fe:	7f 0b                	jg     80080b <vprintfmt+0x14e>
  800800:	8b 14 85 80 34 80 00 	mov    0x803480(,%eax,4),%edx
  800807:	85 d2                	test   %edx,%edx
  800809:	75 20                	jne    80082b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80080b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80080f:	c7 44 24 08 e8 31 80 	movl   $0x8031e8,0x8(%esp)
  800816:	00 
  800817:	89 74 24 04          	mov    %esi,0x4(%esp)
  80081b:	89 3c 24             	mov    %edi,(%esp)
  80081e:	e8 4e 03 00 00       	call   800b71 <printfmt>
  800823:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800826:	e9 be fe ff ff       	jmp    8006e9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80082b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80082f:	c7 44 24 08 db 35 80 	movl   $0x8035db,0x8(%esp)
  800836:	00 
  800837:	89 74 24 04          	mov    %esi,0x4(%esp)
  80083b:	89 3c 24             	mov    %edi,(%esp)
  80083e:	e8 2e 03 00 00       	call   800b71 <printfmt>
  800843:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800846:	e9 9e fe ff ff       	jmp    8006e9 <vprintfmt+0x2c>
  80084b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80084e:	89 c3                	mov    %eax,%ebx
  800850:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800853:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800856:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	8d 50 04             	lea    0x4(%eax),%edx
  80085f:	89 55 14             	mov    %edx,0x14(%ebp)
  800862:	8b 00                	mov    (%eax),%eax
  800864:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800867:	85 c0                	test   %eax,%eax
  800869:	75 07                	jne    800872 <vprintfmt+0x1b5>
  80086b:	c7 45 c4 f1 31 80 00 	movl   $0x8031f1,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800872:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  800876:	7e 06                	jle    80087e <vprintfmt+0x1c1>
  800878:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80087c:	75 13                	jne    800891 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80087e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800881:	0f be 02             	movsbl (%edx),%eax
  800884:	85 c0                	test   %eax,%eax
  800886:	0f 85 99 00 00 00    	jne    800925 <vprintfmt+0x268>
  80088c:	e9 86 00 00 00       	jmp    800917 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800891:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800895:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800898:	89 0c 24             	mov    %ecx,(%esp)
  80089b:	e8 1b 03 00 00       	call   800bbb <strnlen>
  8008a0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8008a3:	29 c2                	sub    %eax,%edx
  8008a5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8008a8:	85 d2                	test   %edx,%edx
  8008aa:	7e d2                	jle    80087e <vprintfmt+0x1c1>
					putch(padc, putdat);
  8008ac:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  8008b0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008b3:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  8008b6:	89 d3                	mov    %edx,%ebx
  8008b8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008bf:	89 04 24             	mov    %eax,(%esp)
  8008c2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c4:	83 eb 01             	sub    $0x1,%ebx
  8008c7:	85 db                	test   %ebx,%ebx
  8008c9:	7f ed                	jg     8008b8 <vprintfmt+0x1fb>
  8008cb:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8008ce:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8008d5:	eb a7                	jmp    80087e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8008d7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8008db:	74 18                	je     8008f5 <vprintfmt+0x238>
  8008dd:	8d 50 e0             	lea    -0x20(%eax),%edx
  8008e0:	83 fa 5e             	cmp    $0x5e,%edx
  8008e3:	76 10                	jbe    8008f5 <vprintfmt+0x238>
					putch('?', putdat);
  8008e5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008e9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8008f0:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8008f3:	eb 0a                	jmp    8008ff <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8008f5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008f9:	89 04 24             	mov    %eax,(%esp)
  8008fc:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ff:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800903:	0f be 03             	movsbl (%ebx),%eax
  800906:	85 c0                	test   %eax,%eax
  800908:	74 05                	je     80090f <vprintfmt+0x252>
  80090a:	83 c3 01             	add    $0x1,%ebx
  80090d:	eb 29                	jmp    800938 <vprintfmt+0x27b>
  80090f:	89 fe                	mov    %edi,%esi
  800911:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800914:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800917:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80091b:	7f 2e                	jg     80094b <vprintfmt+0x28e>
  80091d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800920:	e9 c4 fd ff ff       	jmp    8006e9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800925:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800928:	83 c2 01             	add    $0x1,%edx
  80092b:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80092e:	89 f7                	mov    %esi,%edi
  800930:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800933:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  800936:	89 d3                	mov    %edx,%ebx
  800938:	85 f6                	test   %esi,%esi
  80093a:	78 9b                	js     8008d7 <vprintfmt+0x21a>
  80093c:	83 ee 01             	sub    $0x1,%esi
  80093f:	79 96                	jns    8008d7 <vprintfmt+0x21a>
  800941:	89 fe                	mov    %edi,%esi
  800943:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800946:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800949:	eb cc                	jmp    800917 <vprintfmt+0x25a>
  80094b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  80094e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800951:	89 74 24 04          	mov    %esi,0x4(%esp)
  800955:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80095c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80095e:	83 eb 01             	sub    $0x1,%ebx
  800961:	85 db                	test   %ebx,%ebx
  800963:	7f ec                	jg     800951 <vprintfmt+0x294>
  800965:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800968:	e9 7c fd ff ff       	jmp    8006e9 <vprintfmt+0x2c>
  80096d:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800970:	83 f9 01             	cmp    $0x1,%ecx
  800973:	7e 16                	jle    80098b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800975:	8b 45 14             	mov    0x14(%ebp),%eax
  800978:	8d 50 08             	lea    0x8(%eax),%edx
  80097b:	89 55 14             	mov    %edx,0x14(%ebp)
  80097e:	8b 10                	mov    (%eax),%edx
  800980:	8b 48 04             	mov    0x4(%eax),%ecx
  800983:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800986:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800989:	eb 32                	jmp    8009bd <vprintfmt+0x300>
	else if (lflag)
  80098b:	85 c9                	test   %ecx,%ecx
  80098d:	74 18                	je     8009a7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80098f:	8b 45 14             	mov    0x14(%ebp),%eax
  800992:	8d 50 04             	lea    0x4(%eax),%edx
  800995:	89 55 14             	mov    %edx,0x14(%ebp)
  800998:	8b 00                	mov    (%eax),%eax
  80099a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80099d:	89 c1                	mov    %eax,%ecx
  80099f:	c1 f9 1f             	sar    $0x1f,%ecx
  8009a2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8009a5:	eb 16                	jmp    8009bd <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8009a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009aa:	8d 50 04             	lea    0x4(%eax),%edx
  8009ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8009b0:	8b 00                	mov    (%eax),%eax
  8009b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009b5:	89 c2                	mov    %eax,%edx
  8009b7:	c1 fa 1f             	sar    $0x1f,%edx
  8009ba:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009bd:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8009c0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009c3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8009c8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8009cc:	0f 89 b8 00 00 00    	jns    800a8a <vprintfmt+0x3cd>
				putch('-', putdat);
  8009d2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009d6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8009dd:	ff d7                	call   *%edi
				num = -(long long) num;
  8009df:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8009e2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009e5:	f7 d9                	neg    %ecx
  8009e7:	83 d3 00             	adc    $0x0,%ebx
  8009ea:	f7 db                	neg    %ebx
  8009ec:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009f1:	e9 94 00 00 00       	jmp    800a8a <vprintfmt+0x3cd>
  8009f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009f9:	89 ca                	mov    %ecx,%edx
  8009fb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009fe:	e8 63 fc ff ff       	call   800666 <getuint>
  800a03:	89 c1                	mov    %eax,%ecx
  800a05:	89 d3                	mov    %edx,%ebx
  800a07:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800a0c:	eb 7c                	jmp    800a8a <vprintfmt+0x3cd>
  800a0e:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a11:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a15:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800a1c:	ff d7                	call   *%edi
			putch('X', putdat);
  800a1e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a22:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800a29:	ff d7                	call   *%edi
			putch('X', putdat);
  800a2b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a2f:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800a36:	ff d7                	call   *%edi
  800a38:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800a3b:	e9 a9 fc ff ff       	jmp    8006e9 <vprintfmt+0x2c>
  800a40:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800a43:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a47:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800a4e:	ff d7                	call   *%edi
			putch('x', putdat);
  800a50:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a54:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a5b:	ff d7                	call   *%edi
			num = (unsigned long long)
  800a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a60:	8d 50 04             	lea    0x4(%eax),%edx
  800a63:	89 55 14             	mov    %edx,0x14(%ebp)
  800a66:	8b 08                	mov    (%eax),%ecx
  800a68:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a6d:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800a72:	eb 16                	jmp    800a8a <vprintfmt+0x3cd>
  800a74:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a77:	89 ca                	mov    %ecx,%edx
  800a79:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7c:	e8 e5 fb ff ff       	call   800666 <getuint>
  800a81:	89 c1                	mov    %eax,%ecx
  800a83:	89 d3                	mov    %edx,%ebx
  800a85:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a8a:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  800a8e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800a92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a95:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a99:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a9d:	89 0c 24             	mov    %ecx,(%esp)
  800aa0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800aa4:	89 f2                	mov    %esi,%edx
  800aa6:	89 f8                	mov    %edi,%eax
  800aa8:	e8 c3 fa ff ff       	call   800570 <printnum>
  800aad:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800ab0:	e9 34 fc ff ff       	jmp    8006e9 <vprintfmt+0x2c>
  800ab5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ab8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800abb:	89 74 24 04          	mov    %esi,0x4(%esp)
  800abf:	89 14 24             	mov    %edx,(%esp)
  800ac2:	ff d7                	call   *%edi
  800ac4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800ac7:	e9 1d fc ff ff       	jmp    8006e9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800acc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ad0:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800ad7:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ad9:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800adc:	80 38 25             	cmpb   $0x25,(%eax)
  800adf:	0f 84 04 fc ff ff    	je     8006e9 <vprintfmt+0x2c>
  800ae5:	89 c3                	mov    %eax,%ebx
  800ae7:	eb f0                	jmp    800ad9 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  800ae9:	83 c4 5c             	add    $0x5c,%esp
  800aec:	5b                   	pop    %ebx
  800aed:	5e                   	pop    %esi
  800aee:	5f                   	pop    %edi
  800aef:	5d                   	pop    %ebp
  800af0:	c3                   	ret    

00800af1 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800af1:	55                   	push   %ebp
  800af2:	89 e5                	mov    %esp,%ebp
  800af4:	83 ec 28             	sub    $0x28,%esp
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800afd:	85 c0                	test   %eax,%eax
  800aff:	74 04                	je     800b05 <vsnprintf+0x14>
  800b01:	85 d2                	test   %edx,%edx
  800b03:	7f 07                	jg     800b0c <vsnprintf+0x1b>
  800b05:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800b0a:	eb 3b                	jmp    800b47 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b0f:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b20:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b24:	8b 45 10             	mov    0x10(%ebp),%eax
  800b27:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b2b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b32:	c7 04 24 a0 06 80 00 	movl   $0x8006a0,(%esp)
  800b39:	e8 7f fb ff ff       	call   8006bd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800b3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b41:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b47:	c9                   	leave  
  800b48:	c3                   	ret    

00800b49 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b49:	55                   	push   %ebp
  800b4a:	89 e5                	mov    %esp,%ebp
  800b4c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800b4f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800b52:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b56:	8b 45 10             	mov    0x10(%ebp),%eax
  800b59:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b60:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	89 04 24             	mov    %eax,(%esp)
  800b6a:	e8 82 ff ff ff       	call   800af1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b6f:	c9                   	leave  
  800b70:	c3                   	ret    

00800b71 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800b77:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800b7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b81:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b88:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8f:	89 04 24             	mov    %eax,(%esp)
  800b92:	e8 26 fb ff ff       	call   8006bd <vprintfmt>
	va_end(ap);
}
  800b97:	c9                   	leave  
  800b98:	c3                   	ret    
  800b99:	00 00                	add    %al,(%eax)
  800b9b:	00 00                	add    %al,(%eax)
  800b9d:	00 00                	add    %al,(%eax)
	...

00800ba0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ba0:	55                   	push   %ebp
  800ba1:	89 e5                	mov    %esp,%ebp
  800ba3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba6:	b8 00 00 00 00       	mov    $0x0,%eax
  800bab:	80 3a 00             	cmpb   $0x0,(%edx)
  800bae:	74 09                	je     800bb9 <strlen+0x19>
		n++;
  800bb0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800bb7:	75 f7                	jne    800bb0 <strlen+0x10>
		n++;
	return n;
}
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    

00800bbb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	53                   	push   %ebx
  800bbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800bc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc5:	85 c9                	test   %ecx,%ecx
  800bc7:	74 19                	je     800be2 <strnlen+0x27>
  800bc9:	80 3b 00             	cmpb   $0x0,(%ebx)
  800bcc:	74 14                	je     800be2 <strnlen+0x27>
  800bce:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800bd3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd6:	39 c8                	cmp    %ecx,%eax
  800bd8:	74 0d                	je     800be7 <strnlen+0x2c>
  800bda:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800bde:	75 f3                	jne    800bd3 <strnlen+0x18>
  800be0:	eb 05                	jmp    800be7 <strnlen+0x2c>
  800be2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800be7:	5b                   	pop    %ebx
  800be8:	5d                   	pop    %ebp
  800be9:	c3                   	ret    

00800bea <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bea:	55                   	push   %ebp
  800beb:	89 e5                	mov    %esp,%ebp
  800bed:	53                   	push   %ebx
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bf4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bf9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bfd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800c00:	83 c2 01             	add    $0x1,%edx
  800c03:	84 c9                	test   %cl,%cl
  800c05:	75 f2                	jne    800bf9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800c07:	5b                   	pop    %ebx
  800c08:	5d                   	pop    %ebp
  800c09:	c3                   	ret    

00800c0a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c0a:	55                   	push   %ebp
  800c0b:	89 e5                	mov    %esp,%ebp
  800c0d:	56                   	push   %esi
  800c0e:	53                   	push   %ebx
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c15:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c18:	85 f6                	test   %esi,%esi
  800c1a:	74 18                	je     800c34 <strncpy+0x2a>
  800c1c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800c21:	0f b6 1a             	movzbl (%edx),%ebx
  800c24:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c27:	80 3a 01             	cmpb   $0x1,(%edx)
  800c2a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c2d:	83 c1 01             	add    $0x1,%ecx
  800c30:	39 ce                	cmp    %ecx,%esi
  800c32:	77 ed                	ja     800c21 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800c34:	5b                   	pop    %ebx
  800c35:	5e                   	pop    %esi
  800c36:	5d                   	pop    %ebp
  800c37:	c3                   	ret    

00800c38 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c38:	55                   	push   %ebp
  800c39:	89 e5                	mov    %esp,%ebp
  800c3b:	56                   	push   %esi
  800c3c:	53                   	push   %ebx
  800c3d:	8b 75 08             	mov    0x8(%ebp),%esi
  800c40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c43:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c46:	89 f0                	mov    %esi,%eax
  800c48:	85 c9                	test   %ecx,%ecx
  800c4a:	74 27                	je     800c73 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800c4c:	83 e9 01             	sub    $0x1,%ecx
  800c4f:	74 1d                	je     800c6e <strlcpy+0x36>
  800c51:	0f b6 1a             	movzbl (%edx),%ebx
  800c54:	84 db                	test   %bl,%bl
  800c56:	74 16                	je     800c6e <strlcpy+0x36>
			*dst++ = *src++;
  800c58:	88 18                	mov    %bl,(%eax)
  800c5a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c5d:	83 e9 01             	sub    $0x1,%ecx
  800c60:	74 0e                	je     800c70 <strlcpy+0x38>
			*dst++ = *src++;
  800c62:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c65:	0f b6 1a             	movzbl (%edx),%ebx
  800c68:	84 db                	test   %bl,%bl
  800c6a:	75 ec                	jne    800c58 <strlcpy+0x20>
  800c6c:	eb 02                	jmp    800c70 <strlcpy+0x38>
  800c6e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800c70:	c6 00 00             	movb   $0x0,(%eax)
  800c73:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5d                   	pop    %ebp
  800c78:	c3                   	ret    

00800c79 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c7f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c82:	0f b6 01             	movzbl (%ecx),%eax
  800c85:	84 c0                	test   %al,%al
  800c87:	74 15                	je     800c9e <strcmp+0x25>
  800c89:	3a 02                	cmp    (%edx),%al
  800c8b:	75 11                	jne    800c9e <strcmp+0x25>
		p++, q++;
  800c8d:	83 c1 01             	add    $0x1,%ecx
  800c90:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c93:	0f b6 01             	movzbl (%ecx),%eax
  800c96:	84 c0                	test   %al,%al
  800c98:	74 04                	je     800c9e <strcmp+0x25>
  800c9a:	3a 02                	cmp    (%edx),%al
  800c9c:	74 ef                	je     800c8d <strcmp+0x14>
  800c9e:	0f b6 c0             	movzbl %al,%eax
  800ca1:	0f b6 12             	movzbl (%edx),%edx
  800ca4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ca6:	5d                   	pop    %ebp
  800ca7:	c3                   	ret    

00800ca8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ca8:	55                   	push   %ebp
  800ca9:	89 e5                	mov    %esp,%ebp
  800cab:	53                   	push   %ebx
  800cac:	8b 55 08             	mov    0x8(%ebp),%edx
  800caf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800cb5:	85 c0                	test   %eax,%eax
  800cb7:	74 23                	je     800cdc <strncmp+0x34>
  800cb9:	0f b6 1a             	movzbl (%edx),%ebx
  800cbc:	84 db                	test   %bl,%bl
  800cbe:	74 24                	je     800ce4 <strncmp+0x3c>
  800cc0:	3a 19                	cmp    (%ecx),%bl
  800cc2:	75 20                	jne    800ce4 <strncmp+0x3c>
  800cc4:	83 e8 01             	sub    $0x1,%eax
  800cc7:	74 13                	je     800cdc <strncmp+0x34>
		n--, p++, q++;
  800cc9:	83 c2 01             	add    $0x1,%edx
  800ccc:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ccf:	0f b6 1a             	movzbl (%edx),%ebx
  800cd2:	84 db                	test   %bl,%bl
  800cd4:	74 0e                	je     800ce4 <strncmp+0x3c>
  800cd6:	3a 19                	cmp    (%ecx),%bl
  800cd8:	74 ea                	je     800cc4 <strncmp+0x1c>
  800cda:	eb 08                	jmp    800ce4 <strncmp+0x3c>
  800cdc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ce1:	5b                   	pop    %ebx
  800ce2:	5d                   	pop    %ebp
  800ce3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce4:	0f b6 02             	movzbl (%edx),%eax
  800ce7:	0f b6 11             	movzbl (%ecx),%edx
  800cea:	29 d0                	sub    %edx,%eax
  800cec:	eb f3                	jmp    800ce1 <strncmp+0x39>

00800cee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cee:	55                   	push   %ebp
  800cef:	89 e5                	mov    %esp,%ebp
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cf8:	0f b6 10             	movzbl (%eax),%edx
  800cfb:	84 d2                	test   %dl,%dl
  800cfd:	74 15                	je     800d14 <strchr+0x26>
		if (*s == c)
  800cff:	38 ca                	cmp    %cl,%dl
  800d01:	75 07                	jne    800d0a <strchr+0x1c>
  800d03:	eb 14                	jmp    800d19 <strchr+0x2b>
  800d05:	38 ca                	cmp    %cl,%dl
  800d07:	90                   	nop
  800d08:	74 0f                	je     800d19 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d0a:	83 c0 01             	add    $0x1,%eax
  800d0d:	0f b6 10             	movzbl (%eax),%edx
  800d10:	84 d2                	test   %dl,%dl
  800d12:	75 f1                	jne    800d05 <strchr+0x17>
  800d14:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800d19:	5d                   	pop    %ebp
  800d1a:	c3                   	ret    

00800d1b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d1b:	55                   	push   %ebp
  800d1c:	89 e5                	mov    %esp,%ebp
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800d25:	0f b6 10             	movzbl (%eax),%edx
  800d28:	84 d2                	test   %dl,%dl
  800d2a:	74 18                	je     800d44 <strfind+0x29>
		if (*s == c)
  800d2c:	38 ca                	cmp    %cl,%dl
  800d2e:	75 0a                	jne    800d3a <strfind+0x1f>
  800d30:	eb 12                	jmp    800d44 <strfind+0x29>
  800d32:	38 ca                	cmp    %cl,%dl
  800d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800d38:	74 0a                	je     800d44 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d3a:	83 c0 01             	add    $0x1,%eax
  800d3d:	0f b6 10             	movzbl (%eax),%edx
  800d40:	84 d2                	test   %dl,%dl
  800d42:	75 ee                	jne    800d32 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800d44:	5d                   	pop    %ebp
  800d45:	c3                   	ret    

00800d46 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	83 ec 0c             	sub    $0xc,%esp
  800d4c:	89 1c 24             	mov    %ebx,(%esp)
  800d4f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d53:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800d57:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d60:	85 c9                	test   %ecx,%ecx
  800d62:	74 30                	je     800d94 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d64:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d6a:	75 25                	jne    800d91 <memset+0x4b>
  800d6c:	f6 c1 03             	test   $0x3,%cl
  800d6f:	75 20                	jne    800d91 <memset+0x4b>
		c &= 0xFF;
  800d71:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d74:	89 d3                	mov    %edx,%ebx
  800d76:	c1 e3 08             	shl    $0x8,%ebx
  800d79:	89 d6                	mov    %edx,%esi
  800d7b:	c1 e6 18             	shl    $0x18,%esi
  800d7e:	89 d0                	mov    %edx,%eax
  800d80:	c1 e0 10             	shl    $0x10,%eax
  800d83:	09 f0                	or     %esi,%eax
  800d85:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800d87:	09 d8                	or     %ebx,%eax
  800d89:	c1 e9 02             	shr    $0x2,%ecx
  800d8c:	fc                   	cld    
  800d8d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d8f:	eb 03                	jmp    800d94 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d91:	fc                   	cld    
  800d92:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d94:	89 f8                	mov    %edi,%eax
  800d96:	8b 1c 24             	mov    (%esp),%ebx
  800d99:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d9d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800da1:	89 ec                	mov    %ebp,%esp
  800da3:	5d                   	pop    %ebp
  800da4:	c3                   	ret    

00800da5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800da5:	55                   	push   %ebp
  800da6:	89 e5                	mov    %esp,%ebp
  800da8:	83 ec 08             	sub    $0x8,%esp
  800dab:	89 34 24             	mov    %esi,(%esp)
  800dae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800db2:	8b 45 08             	mov    0x8(%ebp),%eax
  800db5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800db8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800dbb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800dbd:	39 c6                	cmp    %eax,%esi
  800dbf:	73 35                	jae    800df6 <memmove+0x51>
  800dc1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800dc4:	39 d0                	cmp    %edx,%eax
  800dc6:	73 2e                	jae    800df6 <memmove+0x51>
		s += n;
		d += n;
  800dc8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dca:	f6 c2 03             	test   $0x3,%dl
  800dcd:	75 1b                	jne    800dea <memmove+0x45>
  800dcf:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800dd5:	75 13                	jne    800dea <memmove+0x45>
  800dd7:	f6 c1 03             	test   $0x3,%cl
  800dda:	75 0e                	jne    800dea <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800ddc:	83 ef 04             	sub    $0x4,%edi
  800ddf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800de2:	c1 e9 02             	shr    $0x2,%ecx
  800de5:	fd                   	std    
  800de6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800de8:	eb 09                	jmp    800df3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800dea:	83 ef 01             	sub    $0x1,%edi
  800ded:	8d 72 ff             	lea    -0x1(%edx),%esi
  800df0:	fd                   	std    
  800df1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800df3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800df4:	eb 20                	jmp    800e16 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800df6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dfc:	75 15                	jne    800e13 <memmove+0x6e>
  800dfe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e04:	75 0d                	jne    800e13 <memmove+0x6e>
  800e06:	f6 c1 03             	test   $0x3,%cl
  800e09:	75 08                	jne    800e13 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800e0b:	c1 e9 02             	shr    $0x2,%ecx
  800e0e:	fc                   	cld    
  800e0f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800e11:	eb 03                	jmp    800e16 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800e13:	fc                   	cld    
  800e14:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800e16:	8b 34 24             	mov    (%esp),%esi
  800e19:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800e1d:	89 ec                	mov    %ebp,%esp
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    

00800e21 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800e27:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e31:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e35:	8b 45 08             	mov    0x8(%ebp),%eax
  800e38:	89 04 24             	mov    %eax,(%esp)
  800e3b:	e8 65 ff ff ff       	call   800da5 <memmove>
}
  800e40:	c9                   	leave  
  800e41:	c3                   	ret    

00800e42 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
  800e45:	57                   	push   %edi
  800e46:	56                   	push   %esi
  800e47:	53                   	push   %ebx
  800e48:	8b 75 08             	mov    0x8(%ebp),%esi
  800e4b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e51:	85 c9                	test   %ecx,%ecx
  800e53:	74 36                	je     800e8b <memcmp+0x49>
		if (*s1 != *s2)
  800e55:	0f b6 06             	movzbl (%esi),%eax
  800e58:	0f b6 1f             	movzbl (%edi),%ebx
  800e5b:	38 d8                	cmp    %bl,%al
  800e5d:	74 20                	je     800e7f <memcmp+0x3d>
  800e5f:	eb 14                	jmp    800e75 <memcmp+0x33>
  800e61:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800e66:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800e6b:	83 c2 01             	add    $0x1,%edx
  800e6e:	83 e9 01             	sub    $0x1,%ecx
  800e71:	38 d8                	cmp    %bl,%al
  800e73:	74 12                	je     800e87 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800e75:	0f b6 c0             	movzbl %al,%eax
  800e78:	0f b6 db             	movzbl %bl,%ebx
  800e7b:	29 d8                	sub    %ebx,%eax
  800e7d:	eb 11                	jmp    800e90 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e7f:	83 e9 01             	sub    $0x1,%ecx
  800e82:	ba 00 00 00 00       	mov    $0x0,%edx
  800e87:	85 c9                	test   %ecx,%ecx
  800e89:	75 d6                	jne    800e61 <memcmp+0x1f>
  800e8b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800e90:	5b                   	pop    %ebx
  800e91:	5e                   	pop    %esi
  800e92:	5f                   	pop    %edi
  800e93:	5d                   	pop    %ebp
  800e94:	c3                   	ret    

00800e95 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800e9b:	89 c2                	mov    %eax,%edx
  800e9d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800ea0:	39 d0                	cmp    %edx,%eax
  800ea2:	73 15                	jae    800eb9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ea4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800ea8:	38 08                	cmp    %cl,(%eax)
  800eaa:	75 06                	jne    800eb2 <memfind+0x1d>
  800eac:	eb 0b                	jmp    800eb9 <memfind+0x24>
  800eae:	38 08                	cmp    %cl,(%eax)
  800eb0:	74 07                	je     800eb9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800eb2:	83 c0 01             	add    $0x1,%eax
  800eb5:	39 c2                	cmp    %eax,%edx
  800eb7:	77 f5                	ja     800eae <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800eb9:	5d                   	pop    %ebp
  800eba:	c3                   	ret    

00800ebb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ebb:	55                   	push   %ebp
  800ebc:	89 e5                	mov    %esp,%ebp
  800ebe:	57                   	push   %edi
  800ebf:	56                   	push   %esi
  800ec0:	53                   	push   %ebx
  800ec1:	83 ec 04             	sub    $0x4,%esp
  800ec4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800eca:	0f b6 02             	movzbl (%edx),%eax
  800ecd:	3c 20                	cmp    $0x20,%al
  800ecf:	74 04                	je     800ed5 <strtol+0x1a>
  800ed1:	3c 09                	cmp    $0x9,%al
  800ed3:	75 0e                	jne    800ee3 <strtol+0x28>
		s++;
  800ed5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ed8:	0f b6 02             	movzbl (%edx),%eax
  800edb:	3c 20                	cmp    $0x20,%al
  800edd:	74 f6                	je     800ed5 <strtol+0x1a>
  800edf:	3c 09                	cmp    $0x9,%al
  800ee1:	74 f2                	je     800ed5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ee3:	3c 2b                	cmp    $0x2b,%al
  800ee5:	75 0c                	jne    800ef3 <strtol+0x38>
		s++;
  800ee7:	83 c2 01             	add    $0x1,%edx
  800eea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ef1:	eb 15                	jmp    800f08 <strtol+0x4d>
	else if (*s == '-')
  800ef3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800efa:	3c 2d                	cmp    $0x2d,%al
  800efc:	75 0a                	jne    800f08 <strtol+0x4d>
		s++, neg = 1;
  800efe:	83 c2 01             	add    $0x1,%edx
  800f01:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f08:	85 db                	test   %ebx,%ebx
  800f0a:	0f 94 c0             	sete   %al
  800f0d:	74 05                	je     800f14 <strtol+0x59>
  800f0f:	83 fb 10             	cmp    $0x10,%ebx
  800f12:	75 18                	jne    800f2c <strtol+0x71>
  800f14:	80 3a 30             	cmpb   $0x30,(%edx)
  800f17:	75 13                	jne    800f2c <strtol+0x71>
  800f19:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800f1d:	8d 76 00             	lea    0x0(%esi),%esi
  800f20:	75 0a                	jne    800f2c <strtol+0x71>
		s += 2, base = 16;
  800f22:	83 c2 02             	add    $0x2,%edx
  800f25:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f2a:	eb 15                	jmp    800f41 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f2c:	84 c0                	test   %al,%al
  800f2e:	66 90                	xchg   %ax,%ax
  800f30:	74 0f                	je     800f41 <strtol+0x86>
  800f32:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800f37:	80 3a 30             	cmpb   $0x30,(%edx)
  800f3a:	75 05                	jne    800f41 <strtol+0x86>
		s++, base = 8;
  800f3c:	83 c2 01             	add    $0x1,%edx
  800f3f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f41:	b8 00 00 00 00       	mov    $0x0,%eax
  800f46:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f48:	0f b6 0a             	movzbl (%edx),%ecx
  800f4b:	89 cf                	mov    %ecx,%edi
  800f4d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800f50:	80 fb 09             	cmp    $0x9,%bl
  800f53:	77 08                	ja     800f5d <strtol+0xa2>
			dig = *s - '0';
  800f55:	0f be c9             	movsbl %cl,%ecx
  800f58:	83 e9 30             	sub    $0x30,%ecx
  800f5b:	eb 1e                	jmp    800f7b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800f5d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800f60:	80 fb 19             	cmp    $0x19,%bl
  800f63:	77 08                	ja     800f6d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800f65:	0f be c9             	movsbl %cl,%ecx
  800f68:	83 e9 57             	sub    $0x57,%ecx
  800f6b:	eb 0e                	jmp    800f7b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800f6d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800f70:	80 fb 19             	cmp    $0x19,%bl
  800f73:	77 15                	ja     800f8a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800f75:	0f be c9             	movsbl %cl,%ecx
  800f78:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f7b:	39 f1                	cmp    %esi,%ecx
  800f7d:	7d 0b                	jge    800f8a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800f7f:	83 c2 01             	add    $0x1,%edx
  800f82:	0f af c6             	imul   %esi,%eax
  800f85:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800f88:	eb be                	jmp    800f48 <strtol+0x8d>
  800f8a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800f8c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f90:	74 05                	je     800f97 <strtol+0xdc>
		*endptr = (char *) s;
  800f92:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800f95:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800f97:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f9b:	74 04                	je     800fa1 <strtol+0xe6>
  800f9d:	89 c8                	mov    %ecx,%eax
  800f9f:	f7 d8                	neg    %eax
}
  800fa1:	83 c4 04             	add    $0x4,%esp
  800fa4:	5b                   	pop    %ebx
  800fa5:	5e                   	pop    %esi
  800fa6:	5f                   	pop    %edi
  800fa7:	5d                   	pop    %ebp
  800fa8:	c3                   	ret    
  800fa9:	00 00                	add    %al,(%eax)
	...

00800fac <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800fac:	55                   	push   %ebp
  800fad:	89 e5                	mov    %esp,%ebp
  800faf:	83 ec 0c             	sub    $0xc,%esp
  800fb2:	89 1c 24             	mov    %ebx,(%esp)
  800fb5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fb9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc2:	b8 01 00 00 00       	mov    $0x1,%eax
  800fc7:	89 d1                	mov    %edx,%ecx
  800fc9:	89 d3                	mov    %edx,%ebx
  800fcb:	89 d7                	mov    %edx,%edi
  800fcd:	89 d6                	mov    %edx,%esi
  800fcf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800fd1:	8b 1c 24             	mov    (%esp),%ebx
  800fd4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fd8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fdc:	89 ec                	mov    %ebp,%esp
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    

00800fe0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	83 ec 0c             	sub    $0xc,%esp
  800fe6:	89 1c 24             	mov    %ebx,(%esp)
  800fe9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fed:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800ff1:	b8 00 00 00 00       	mov    $0x0,%eax
  800ff6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff9:	8b 55 08             	mov    0x8(%ebp),%edx
  800ffc:	89 c3                	mov    %eax,%ebx
  800ffe:	89 c7                	mov    %eax,%edi
  801000:	89 c6                	mov    %eax,%esi
  801002:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801004:	8b 1c 24             	mov    (%esp),%ebx
  801007:	8b 74 24 04          	mov    0x4(%esp),%esi
  80100b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80100f:	89 ec                	mov    %ebp,%esp
  801011:	5d                   	pop    %ebp
  801012:	c3                   	ret    

00801013 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  801013:	55                   	push   %ebp
  801014:	89 e5                	mov    %esp,%ebp
  801016:	83 ec 0c             	sub    $0xc,%esp
  801019:	89 1c 24             	mov    %ebx,(%esp)
  80101c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801020:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801024:	bb 00 00 00 00       	mov    $0x0,%ebx
  801029:	b8 10 00 00 00       	mov    $0x10,%eax
  80102e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801031:	8b 55 08             	mov    0x8(%ebp),%edx
  801034:	89 df                	mov    %ebx,%edi
  801036:	89 de                	mov    %ebx,%esi
  801038:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  80103a:	8b 1c 24             	mov    (%esp),%ebx
  80103d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801041:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801045:	89 ec                	mov    %ebp,%esp
  801047:	5d                   	pop    %ebp
  801048:	c3                   	ret    

00801049 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  801049:	55                   	push   %ebp
  80104a:	89 e5                	mov    %esp,%ebp
  80104c:	83 ec 38             	sub    $0x38,%esp
  80104f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801052:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801055:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801058:	bb 00 00 00 00       	mov    $0x0,%ebx
  80105d:	b8 0f 00 00 00       	mov    $0xf,%eax
  801062:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801065:	8b 55 08             	mov    0x8(%ebp),%edx
  801068:	89 df                	mov    %ebx,%edi
  80106a:	89 de                	mov    %ebx,%esi
  80106c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80106e:	85 c0                	test   %eax,%eax
  801070:	7e 28                	jle    80109a <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801072:	89 44 24 10          	mov    %eax,0x10(%esp)
  801076:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80107d:	00 
  80107e:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  801085:	00 
  801086:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80108d:	00 
  80108e:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  801095:	e8 ae f3 ff ff       	call   800448 <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  80109a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80109d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010a0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010a3:	89 ec                	mov    %ebp,%esp
  8010a5:	5d                   	pop    %ebp
  8010a6:	c3                   	ret    

008010a7 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  8010a7:	55                   	push   %ebp
  8010a8:	89 e5                	mov    %esp,%ebp
  8010aa:	83 ec 0c             	sub    $0xc,%esp
  8010ad:	89 1c 24             	mov    %ebx,(%esp)
  8010b0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8010b4:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8010bd:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010c2:	89 d1                	mov    %edx,%ecx
  8010c4:	89 d3                	mov    %edx,%ebx
  8010c6:	89 d7                	mov    %edx,%edi
  8010c8:	89 d6                	mov    %edx,%esi
  8010ca:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8010cc:	8b 1c 24             	mov    (%esp),%ebx
  8010cf:	8b 74 24 04          	mov    0x4(%esp),%esi
  8010d3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8010d7:	89 ec                	mov    %ebp,%esp
  8010d9:	5d                   	pop    %ebp
  8010da:	c3                   	ret    

008010db <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8010db:	55                   	push   %ebp
  8010dc:	89 e5                	mov    %esp,%ebp
  8010de:	83 ec 38             	sub    $0x38,%esp
  8010e1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010e4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010e7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010ef:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f7:	89 cb                	mov    %ecx,%ebx
  8010f9:	89 cf                	mov    %ecx,%edi
  8010fb:	89 ce                	mov    %ecx,%esi
  8010fd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010ff:	85 c0                	test   %eax,%eax
  801101:	7e 28                	jle    80112b <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801103:	89 44 24 10          	mov    %eax,0x10(%esp)
  801107:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80110e:	00 
  80110f:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  801116:	00 
  801117:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80111e:	00 
  80111f:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  801126:	e8 1d f3 ff ff       	call   800448 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80112b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80112e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801131:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801134:	89 ec                	mov    %ebp,%esp
  801136:	5d                   	pop    %ebp
  801137:	c3                   	ret    

00801138 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801138:	55                   	push   %ebp
  801139:	89 e5                	mov    %esp,%ebp
  80113b:	83 ec 0c             	sub    $0xc,%esp
  80113e:	89 1c 24             	mov    %ebx,(%esp)
  801141:	89 74 24 04          	mov    %esi,0x4(%esp)
  801145:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801149:	be 00 00 00 00       	mov    $0x0,%esi
  80114e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801153:	8b 7d 14             	mov    0x14(%ebp),%edi
  801156:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801159:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115c:	8b 55 08             	mov    0x8(%ebp),%edx
  80115f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801161:	8b 1c 24             	mov    (%esp),%ebx
  801164:	8b 74 24 04          	mov    0x4(%esp),%esi
  801168:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80116c:	89 ec                	mov    %ebp,%esp
  80116e:	5d                   	pop    %ebp
  80116f:	c3                   	ret    

00801170 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801170:	55                   	push   %ebp
  801171:	89 e5                	mov    %esp,%ebp
  801173:	83 ec 38             	sub    $0x38,%esp
  801176:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801179:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80117c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80117f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801184:	b8 0a 00 00 00       	mov    $0xa,%eax
  801189:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80118c:	8b 55 08             	mov    0x8(%ebp),%edx
  80118f:	89 df                	mov    %ebx,%edi
  801191:	89 de                	mov    %ebx,%esi
  801193:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801195:	85 c0                	test   %eax,%eax
  801197:	7e 28                	jle    8011c1 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801199:	89 44 24 10          	mov    %eax,0x10(%esp)
  80119d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8011a4:	00 
  8011a5:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  8011ac:	00 
  8011ad:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011b4:	00 
  8011b5:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  8011bc:	e8 87 f2 ff ff       	call   800448 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011c1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011c4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011c7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011ca:	89 ec                	mov    %ebp,%esp
  8011cc:	5d                   	pop    %ebp
  8011cd:	c3                   	ret    

008011ce <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8011ce:	55                   	push   %ebp
  8011cf:	89 e5                	mov    %esp,%ebp
  8011d1:	83 ec 38             	sub    $0x38,%esp
  8011d4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011d7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011da:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011e2:	b8 09 00 00 00       	mov    $0x9,%eax
  8011e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ed:	89 df                	mov    %ebx,%edi
  8011ef:	89 de                	mov    %ebx,%esi
  8011f1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011f3:	85 c0                	test   %eax,%eax
  8011f5:	7e 28                	jle    80121f <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011f7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011fb:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801202:	00 
  801203:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  80120a:	00 
  80120b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801212:	00 
  801213:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  80121a:	e8 29 f2 ff ff       	call   800448 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80121f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801222:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801225:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801228:	89 ec                	mov    %ebp,%esp
  80122a:	5d                   	pop    %ebp
  80122b:	c3                   	ret    

0080122c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	83 ec 38             	sub    $0x38,%esp
  801232:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801235:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801238:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80123b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801240:	b8 08 00 00 00       	mov    $0x8,%eax
  801245:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801248:	8b 55 08             	mov    0x8(%ebp),%edx
  80124b:	89 df                	mov    %ebx,%edi
  80124d:	89 de                	mov    %ebx,%esi
  80124f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801251:	85 c0                	test   %eax,%eax
  801253:	7e 28                	jle    80127d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801255:	89 44 24 10          	mov    %eax,0x10(%esp)
  801259:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801260:	00 
  801261:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  801268:	00 
  801269:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801270:	00 
  801271:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  801278:	e8 cb f1 ff ff       	call   800448 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80127d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801280:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801283:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801286:	89 ec                	mov    %ebp,%esp
  801288:	5d                   	pop    %ebp
  801289:	c3                   	ret    

0080128a <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80128a:	55                   	push   %ebp
  80128b:	89 e5                	mov    %esp,%ebp
  80128d:	83 ec 38             	sub    $0x38,%esp
  801290:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801293:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801296:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801299:	bb 00 00 00 00       	mov    $0x0,%ebx
  80129e:	b8 06 00 00 00       	mov    $0x6,%eax
  8012a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a9:	89 df                	mov    %ebx,%edi
  8012ab:	89 de                	mov    %ebx,%esi
  8012ad:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8012af:	85 c0                	test   %eax,%eax
  8012b1:	7e 28                	jle    8012db <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012b3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012b7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8012be:	00 
  8012bf:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  8012c6:	00 
  8012c7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012ce:	00 
  8012cf:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  8012d6:	e8 6d f1 ff ff       	call   800448 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012db:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012de:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012e1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012e4:	89 ec                	mov    %ebp,%esp
  8012e6:	5d                   	pop    %ebp
  8012e7:	c3                   	ret    

008012e8 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8012e8:	55                   	push   %ebp
  8012e9:	89 e5                	mov    %esp,%ebp
  8012eb:	83 ec 38             	sub    $0x38,%esp
  8012ee:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012f1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012f4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012f7:	b8 05 00 00 00       	mov    $0x5,%eax
  8012fc:	8b 75 18             	mov    0x18(%ebp),%esi
  8012ff:	8b 7d 14             	mov    0x14(%ebp),%edi
  801302:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801305:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801308:	8b 55 08             	mov    0x8(%ebp),%edx
  80130b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80130d:	85 c0                	test   %eax,%eax
  80130f:	7e 28                	jle    801339 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801311:	89 44 24 10          	mov    %eax,0x10(%esp)
  801315:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80131c:	00 
  80131d:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  801324:	00 
  801325:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80132c:	00 
  80132d:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  801334:	e8 0f f1 ff ff       	call   800448 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801339:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80133c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80133f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801342:	89 ec                	mov    %ebp,%esp
  801344:	5d                   	pop    %ebp
  801345:	c3                   	ret    

00801346 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801346:	55                   	push   %ebp
  801347:	89 e5                	mov    %esp,%ebp
  801349:	83 ec 38             	sub    $0x38,%esp
  80134c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80134f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801352:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801355:	be 00 00 00 00       	mov    $0x0,%esi
  80135a:	b8 04 00 00 00       	mov    $0x4,%eax
  80135f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801362:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801365:	8b 55 08             	mov    0x8(%ebp),%edx
  801368:	89 f7                	mov    %esi,%edi
  80136a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80136c:	85 c0                	test   %eax,%eax
  80136e:	7e 28                	jle    801398 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801370:	89 44 24 10          	mov    %eax,0x10(%esp)
  801374:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80137b:	00 
  80137c:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  801383:	00 
  801384:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80138b:	00 
  80138c:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  801393:	e8 b0 f0 ff ff       	call   800448 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801398:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80139b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80139e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013a1:	89 ec                	mov    %ebp,%esp
  8013a3:	5d                   	pop    %ebp
  8013a4:	c3                   	ret    

008013a5 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
  8013a8:	83 ec 0c             	sub    $0xc,%esp
  8013ab:	89 1c 24             	mov    %ebx,(%esp)
  8013ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013b2:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8013bb:	b8 0b 00 00 00       	mov    $0xb,%eax
  8013c0:	89 d1                	mov    %edx,%ecx
  8013c2:	89 d3                	mov    %edx,%ebx
  8013c4:	89 d7                	mov    %edx,%edi
  8013c6:	89 d6                	mov    %edx,%esi
  8013c8:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8013ca:	8b 1c 24             	mov    (%esp),%ebx
  8013cd:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013d1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013d5:	89 ec                	mov    %ebp,%esp
  8013d7:	5d                   	pop    %ebp
  8013d8:	c3                   	ret    

008013d9 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 0c             	sub    $0xc,%esp
  8013df:	89 1c 24             	mov    %ebx,(%esp)
  8013e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013e6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8013ef:	b8 02 00 00 00       	mov    $0x2,%eax
  8013f4:	89 d1                	mov    %edx,%ecx
  8013f6:	89 d3                	mov    %edx,%ebx
  8013f8:	89 d7                	mov    %edx,%edi
  8013fa:	89 d6                	mov    %edx,%esi
  8013fc:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8013fe:	8b 1c 24             	mov    (%esp),%ebx
  801401:	8b 74 24 04          	mov    0x4(%esp),%esi
  801405:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801409:	89 ec                	mov    %ebp,%esp
  80140b:	5d                   	pop    %ebp
  80140c:	c3                   	ret    

0080140d <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
  801410:	83 ec 38             	sub    $0x38,%esp
  801413:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801416:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801419:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80141c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801421:	b8 03 00 00 00       	mov    $0x3,%eax
  801426:	8b 55 08             	mov    0x8(%ebp),%edx
  801429:	89 cb                	mov    %ecx,%ebx
  80142b:	89 cf                	mov    %ecx,%edi
  80142d:	89 ce                	mov    %ecx,%esi
  80142f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801431:	85 c0                	test   %eax,%eax
  801433:	7e 28                	jle    80145d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801435:	89 44 24 10          	mov    %eax,0x10(%esp)
  801439:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801440:	00 
  801441:	c7 44 24 08 df 34 80 	movl   $0x8034df,0x8(%esp)
  801448:	00 
  801449:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801450:	00 
  801451:	c7 04 24 fc 34 80 00 	movl   $0x8034fc,(%esp)
  801458:	e8 eb ef ff ff       	call   800448 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80145d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801460:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801463:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801466:	89 ec                	mov    %ebp,%esp
  801468:	5d                   	pop    %ebp
  801469:	c3                   	ret    
  80146a:	00 00                	add    %al,(%eax)
  80146c:	00 00                	add    %al,(%eax)
	...

00801470 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801470:	55                   	push   %ebp
  801471:	89 e5                	mov    %esp,%ebp
  801473:	8b 45 08             	mov    0x8(%ebp),%eax
  801476:	05 00 00 00 30       	add    $0x30000000,%eax
  80147b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80147e:	5d                   	pop    %ebp
  80147f:	c3                   	ret    

00801480 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	89 04 24             	mov    %eax,(%esp)
  80148c:	e8 df ff ff ff       	call   801470 <fd2num>
  801491:	05 20 00 0d 00       	add    $0xd0020,%eax
  801496:	c1 e0 0c             	shl    $0xc,%eax
}
  801499:	c9                   	leave  
  80149a:	c3                   	ret    

0080149b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	57                   	push   %edi
  80149f:	56                   	push   %esi
  8014a0:	53                   	push   %ebx
  8014a1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8014a4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8014a9:	a8 01                	test   $0x1,%al
  8014ab:	74 36                	je     8014e3 <fd_alloc+0x48>
  8014ad:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8014b2:	a8 01                	test   $0x1,%al
  8014b4:	74 2d                	je     8014e3 <fd_alloc+0x48>
  8014b6:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  8014bb:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8014c0:	be 00 00 40 ef       	mov    $0xef400000,%esi
  8014c5:	89 c3                	mov    %eax,%ebx
  8014c7:	89 c2                	mov    %eax,%edx
  8014c9:	c1 ea 16             	shr    $0x16,%edx
  8014cc:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8014cf:	f6 c2 01             	test   $0x1,%dl
  8014d2:	74 14                	je     8014e8 <fd_alloc+0x4d>
  8014d4:	89 c2                	mov    %eax,%edx
  8014d6:	c1 ea 0c             	shr    $0xc,%edx
  8014d9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  8014dc:	f6 c2 01             	test   $0x1,%dl
  8014df:	75 10                	jne    8014f1 <fd_alloc+0x56>
  8014e1:	eb 05                	jmp    8014e8 <fd_alloc+0x4d>
  8014e3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  8014e8:	89 1f                	mov    %ebx,(%edi)
  8014ea:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8014ef:	eb 17                	jmp    801508 <fd_alloc+0x6d>
  8014f1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8014f6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014fb:	75 c8                	jne    8014c5 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014fd:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801503:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801508:	5b                   	pop    %ebx
  801509:	5e                   	pop    %esi
  80150a:	5f                   	pop    %edi
  80150b:	5d                   	pop    %ebp
  80150c:	c3                   	ret    

0080150d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80150d:	55                   	push   %ebp
  80150e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801510:	8b 45 08             	mov    0x8(%ebp),%eax
  801513:	83 f8 1f             	cmp    $0x1f,%eax
  801516:	77 36                	ja     80154e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801518:	05 00 00 0d 00       	add    $0xd0000,%eax
  80151d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801520:	89 c2                	mov    %eax,%edx
  801522:	c1 ea 16             	shr    $0x16,%edx
  801525:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80152c:	f6 c2 01             	test   $0x1,%dl
  80152f:	74 1d                	je     80154e <fd_lookup+0x41>
  801531:	89 c2                	mov    %eax,%edx
  801533:	c1 ea 0c             	shr    $0xc,%edx
  801536:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80153d:	f6 c2 01             	test   $0x1,%dl
  801540:	74 0c                	je     80154e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801542:	8b 55 0c             	mov    0xc(%ebp),%edx
  801545:	89 02                	mov    %eax,(%edx)
  801547:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80154c:	eb 05                	jmp    801553 <fd_lookup+0x46>
  80154e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801553:	5d                   	pop    %ebp
  801554:	c3                   	ret    

00801555 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801555:	55                   	push   %ebp
  801556:	89 e5                	mov    %esp,%ebp
  801558:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80155b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80155e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801562:	8b 45 08             	mov    0x8(%ebp),%eax
  801565:	89 04 24             	mov    %eax,(%esp)
  801568:	e8 a0 ff ff ff       	call   80150d <fd_lookup>
  80156d:	85 c0                	test   %eax,%eax
  80156f:	78 0e                	js     80157f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801571:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801574:	8b 55 0c             	mov    0xc(%ebp),%edx
  801577:	89 50 04             	mov    %edx,0x4(%eax)
  80157a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80157f:	c9                   	leave  
  801580:	c3                   	ret    

00801581 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	56                   	push   %esi
  801585:	53                   	push   %ebx
  801586:	83 ec 10             	sub    $0x10,%esp
  801589:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80158c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80158f:	b8 90 87 80 00       	mov    $0x808790,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801594:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801599:	be 88 35 80 00       	mov    $0x803588,%esi
		if (devtab[i]->dev_id == dev_id) {
  80159e:	39 08                	cmp    %ecx,(%eax)
  8015a0:	75 10                	jne    8015b2 <dev_lookup+0x31>
  8015a2:	eb 04                	jmp    8015a8 <dev_lookup+0x27>
  8015a4:	39 08                	cmp    %ecx,(%eax)
  8015a6:	75 0a                	jne    8015b2 <dev_lookup+0x31>
			*dev = devtab[i];
  8015a8:	89 03                	mov    %eax,(%ebx)
  8015aa:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8015af:	90                   	nop
  8015b0:	eb 31                	jmp    8015e3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8015b2:	83 c2 01             	add    $0x1,%edx
  8015b5:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8015b8:	85 c0                	test   %eax,%eax
  8015ba:	75 e8                	jne    8015a4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8015bc:	a1 70 9f 80 00       	mov    0x809f70,%eax
  8015c1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8015c4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8015c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015cc:	c7 04 24 0c 35 80 00 	movl   $0x80350c,(%esp)
  8015d3:	e8 35 ef ff ff       	call   80050d <cprintf>
	*dev = 0;
  8015d8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8015de:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8015e3:	83 c4 10             	add    $0x10,%esp
  8015e6:	5b                   	pop    %ebx
  8015e7:	5e                   	pop    %esi
  8015e8:	5d                   	pop    %ebp
  8015e9:	c3                   	ret    

008015ea <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
  8015ed:	53                   	push   %ebx
  8015ee:	83 ec 24             	sub    $0x24,%esp
  8015f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	89 04 24             	mov    %eax,(%esp)
  801601:	e8 07 ff ff ff       	call   80150d <fd_lookup>
  801606:	85 c0                	test   %eax,%eax
  801608:	78 53                	js     80165d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80160a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801611:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801614:	8b 00                	mov    (%eax),%eax
  801616:	89 04 24             	mov    %eax,(%esp)
  801619:	e8 63 ff ff ff       	call   801581 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80161e:	85 c0                	test   %eax,%eax
  801620:	78 3b                	js     80165d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801622:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801627:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80162a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80162e:	74 2d                	je     80165d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801630:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801633:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80163a:	00 00 00 
	stat->st_isdir = 0;
  80163d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801644:	00 00 00 
	stat->st_dev = dev;
  801647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80164a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801650:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801654:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801657:	89 14 24             	mov    %edx,(%esp)
  80165a:	ff 50 14             	call   *0x14(%eax)
}
  80165d:	83 c4 24             	add    $0x24,%esp
  801660:	5b                   	pop    %ebx
  801661:	5d                   	pop    %ebp
  801662:	c3                   	ret    

00801663 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801663:	55                   	push   %ebp
  801664:	89 e5                	mov    %esp,%ebp
  801666:	53                   	push   %ebx
  801667:	83 ec 24             	sub    $0x24,%esp
  80166a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80166d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801670:	89 44 24 04          	mov    %eax,0x4(%esp)
  801674:	89 1c 24             	mov    %ebx,(%esp)
  801677:	e8 91 fe ff ff       	call   80150d <fd_lookup>
  80167c:	85 c0                	test   %eax,%eax
  80167e:	78 5f                	js     8016df <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801680:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801683:	89 44 24 04          	mov    %eax,0x4(%esp)
  801687:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168a:	8b 00                	mov    (%eax),%eax
  80168c:	89 04 24             	mov    %eax,(%esp)
  80168f:	e8 ed fe ff ff       	call   801581 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801694:	85 c0                	test   %eax,%eax
  801696:	78 47                	js     8016df <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801698:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80169b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80169f:	75 23                	jne    8016c4 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8016a1:	a1 70 9f 80 00       	mov    0x809f70,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016a6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8016a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b1:	c7 04 24 2c 35 80 00 	movl   $0x80352c,(%esp)
  8016b8:	e8 50 ee ff ff       	call   80050d <cprintf>
  8016bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  8016c2:	eb 1b                	jmp    8016df <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8016c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c7:	8b 48 18             	mov    0x18(%eax),%ecx
  8016ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016cf:	85 c9                	test   %ecx,%ecx
  8016d1:	74 0c                	je     8016df <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016da:	89 14 24             	mov    %edx,(%esp)
  8016dd:	ff d1                	call   *%ecx
}
  8016df:	83 c4 24             	add    $0x24,%esp
  8016e2:	5b                   	pop    %ebx
  8016e3:	5d                   	pop    %ebp
  8016e4:	c3                   	ret    

008016e5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
  8016e8:	53                   	push   %ebx
  8016e9:	83 ec 24             	sub    $0x24,%esp
  8016ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f6:	89 1c 24             	mov    %ebx,(%esp)
  8016f9:	e8 0f fe ff ff       	call   80150d <fd_lookup>
  8016fe:	85 c0                	test   %eax,%eax
  801700:	78 66                	js     801768 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801702:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801705:	89 44 24 04          	mov    %eax,0x4(%esp)
  801709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170c:	8b 00                	mov    (%eax),%eax
  80170e:	89 04 24             	mov    %eax,(%esp)
  801711:	e8 6b fe ff ff       	call   801581 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801716:	85 c0                	test   %eax,%eax
  801718:	78 4e                	js     801768 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80171a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80171d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801721:	75 23                	jne    801746 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801723:	a1 70 9f 80 00       	mov    0x809f70,%eax
  801728:	8b 40 4c             	mov    0x4c(%eax),%eax
  80172b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80172f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801733:	c7 04 24 4d 35 80 00 	movl   $0x80354d,(%esp)
  80173a:	e8 ce ed ff ff       	call   80050d <cprintf>
  80173f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801744:	eb 22                	jmp    801768 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801749:	8b 48 0c             	mov    0xc(%eax),%ecx
  80174c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801751:	85 c9                	test   %ecx,%ecx
  801753:	74 13                	je     801768 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801755:	8b 45 10             	mov    0x10(%ebp),%eax
  801758:	89 44 24 08          	mov    %eax,0x8(%esp)
  80175c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80175f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801763:	89 14 24             	mov    %edx,(%esp)
  801766:	ff d1                	call   *%ecx
}
  801768:	83 c4 24             	add    $0x24,%esp
  80176b:	5b                   	pop    %ebx
  80176c:	5d                   	pop    %ebp
  80176d:	c3                   	ret    

0080176e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80176e:	55                   	push   %ebp
  80176f:	89 e5                	mov    %esp,%ebp
  801771:	53                   	push   %ebx
  801772:	83 ec 24             	sub    $0x24,%esp
  801775:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801778:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80177b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80177f:	89 1c 24             	mov    %ebx,(%esp)
  801782:	e8 86 fd ff ff       	call   80150d <fd_lookup>
  801787:	85 c0                	test   %eax,%eax
  801789:	78 6b                	js     8017f6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80178b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80178e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801792:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801795:	8b 00                	mov    (%eax),%eax
  801797:	89 04 24             	mov    %eax,(%esp)
  80179a:	e8 e2 fd ff ff       	call   801581 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80179f:	85 c0                	test   %eax,%eax
  8017a1:	78 53                	js     8017f6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8017a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017a6:	8b 42 08             	mov    0x8(%edx),%eax
  8017a9:	83 e0 03             	and    $0x3,%eax
  8017ac:	83 f8 01             	cmp    $0x1,%eax
  8017af:	75 23                	jne    8017d4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8017b1:	a1 70 9f 80 00       	mov    0x809f70,%eax
  8017b6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8017b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017c1:	c7 04 24 6a 35 80 00 	movl   $0x80356a,(%esp)
  8017c8:	e8 40 ed ff ff       	call   80050d <cprintf>
  8017cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8017d2:	eb 22                	jmp    8017f6 <read+0x88>
	}
	if (!dev->dev_read)
  8017d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d7:	8b 48 08             	mov    0x8(%eax),%ecx
  8017da:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017df:	85 c9                	test   %ecx,%ecx
  8017e1:	74 13                	je     8017f6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017f1:	89 14 24             	mov    %edx,(%esp)
  8017f4:	ff d1                	call   *%ecx
}
  8017f6:	83 c4 24             	add    $0x24,%esp
  8017f9:	5b                   	pop    %ebx
  8017fa:	5d                   	pop    %ebp
  8017fb:	c3                   	ret    

008017fc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017fc:	55                   	push   %ebp
  8017fd:	89 e5                	mov    %esp,%ebp
  8017ff:	57                   	push   %edi
  801800:	56                   	push   %esi
  801801:	53                   	push   %ebx
  801802:	83 ec 1c             	sub    $0x1c,%esp
  801805:	8b 7d 08             	mov    0x8(%ebp),%edi
  801808:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80180b:	ba 00 00 00 00       	mov    $0x0,%edx
  801810:	bb 00 00 00 00       	mov    $0x0,%ebx
  801815:	b8 00 00 00 00       	mov    $0x0,%eax
  80181a:	85 f6                	test   %esi,%esi
  80181c:	74 29                	je     801847 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80181e:	89 f0                	mov    %esi,%eax
  801820:	29 d0                	sub    %edx,%eax
  801822:	89 44 24 08          	mov    %eax,0x8(%esp)
  801826:	03 55 0c             	add    0xc(%ebp),%edx
  801829:	89 54 24 04          	mov    %edx,0x4(%esp)
  80182d:	89 3c 24             	mov    %edi,(%esp)
  801830:	e8 39 ff ff ff       	call   80176e <read>
		if (m < 0)
  801835:	85 c0                	test   %eax,%eax
  801837:	78 0e                	js     801847 <readn+0x4b>
			return m;
		if (m == 0)
  801839:	85 c0                	test   %eax,%eax
  80183b:	74 08                	je     801845 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80183d:	01 c3                	add    %eax,%ebx
  80183f:	89 da                	mov    %ebx,%edx
  801841:	39 f3                	cmp    %esi,%ebx
  801843:	72 d9                	jb     80181e <readn+0x22>
  801845:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801847:	83 c4 1c             	add    $0x1c,%esp
  80184a:	5b                   	pop    %ebx
  80184b:	5e                   	pop    %esi
  80184c:	5f                   	pop    %edi
  80184d:	5d                   	pop    %ebp
  80184e:	c3                   	ret    

0080184f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
  801852:	56                   	push   %esi
  801853:	53                   	push   %ebx
  801854:	83 ec 20             	sub    $0x20,%esp
  801857:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80185a:	89 34 24             	mov    %esi,(%esp)
  80185d:	e8 0e fc ff ff       	call   801470 <fd2num>
  801862:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801865:	89 54 24 04          	mov    %edx,0x4(%esp)
  801869:	89 04 24             	mov    %eax,(%esp)
  80186c:	e8 9c fc ff ff       	call   80150d <fd_lookup>
  801871:	89 c3                	mov    %eax,%ebx
  801873:	85 c0                	test   %eax,%eax
  801875:	78 05                	js     80187c <fd_close+0x2d>
  801877:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80187a:	74 0c                	je     801888 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80187c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801880:	19 c0                	sbb    %eax,%eax
  801882:	f7 d0                	not    %eax
  801884:	21 c3                	and    %eax,%ebx
  801886:	eb 3d                	jmp    8018c5 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801888:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80188b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80188f:	8b 06                	mov    (%esi),%eax
  801891:	89 04 24             	mov    %eax,(%esp)
  801894:	e8 e8 fc ff ff       	call   801581 <dev_lookup>
  801899:	89 c3                	mov    %eax,%ebx
  80189b:	85 c0                	test   %eax,%eax
  80189d:	78 16                	js     8018b5 <fd_close+0x66>
		if (dev->dev_close)
  80189f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a2:	8b 40 10             	mov    0x10(%eax),%eax
  8018a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018aa:	85 c0                	test   %eax,%eax
  8018ac:	74 07                	je     8018b5 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  8018ae:	89 34 24             	mov    %esi,(%esp)
  8018b1:	ff d0                	call   *%eax
  8018b3:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8018b5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8018b9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018c0:	e8 c5 f9 ff ff       	call   80128a <sys_page_unmap>
	return r;
}
  8018c5:	89 d8                	mov    %ebx,%eax
  8018c7:	83 c4 20             	add    $0x20,%esp
  8018ca:	5b                   	pop    %ebx
  8018cb:	5e                   	pop    %esi
  8018cc:	5d                   	pop    %ebp
  8018cd:	c3                   	ret    

008018ce <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8018ce:	55                   	push   %ebp
  8018cf:	89 e5                	mov    %esp,%ebp
  8018d1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	89 04 24             	mov    %eax,(%esp)
  8018e1:	e8 27 fc ff ff       	call   80150d <fd_lookup>
  8018e6:	85 c0                	test   %eax,%eax
  8018e8:	78 13                	js     8018fd <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8018ea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8018f1:	00 
  8018f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018f5:	89 04 24             	mov    %eax,(%esp)
  8018f8:	e8 52 ff ff ff       	call   80184f <fd_close>
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	83 ec 18             	sub    $0x18,%esp
  801905:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801908:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80190b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801912:	00 
  801913:	8b 45 08             	mov    0x8(%ebp),%eax
  801916:	89 04 24             	mov    %eax,(%esp)
  801919:	e8 a9 03 00 00       	call   801cc7 <open>
  80191e:	89 c3                	mov    %eax,%ebx
  801920:	85 c0                	test   %eax,%eax
  801922:	78 1b                	js     80193f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801924:	8b 45 0c             	mov    0xc(%ebp),%eax
  801927:	89 44 24 04          	mov    %eax,0x4(%esp)
  80192b:	89 1c 24             	mov    %ebx,(%esp)
  80192e:	e8 b7 fc ff ff       	call   8015ea <fstat>
  801933:	89 c6                	mov    %eax,%esi
	close(fd);
  801935:	89 1c 24             	mov    %ebx,(%esp)
  801938:	e8 91 ff ff ff       	call   8018ce <close>
  80193d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80193f:	89 d8                	mov    %ebx,%eax
  801941:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801944:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801947:	89 ec                	mov    %ebp,%esp
  801949:	5d                   	pop    %ebp
  80194a:	c3                   	ret    

0080194b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	53                   	push   %ebx
  80194f:	83 ec 14             	sub    $0x14,%esp
  801952:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801957:	89 1c 24             	mov    %ebx,(%esp)
  80195a:	e8 6f ff ff ff       	call   8018ce <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80195f:	83 c3 01             	add    $0x1,%ebx
  801962:	83 fb 20             	cmp    $0x20,%ebx
  801965:	75 f0                	jne    801957 <close_all+0xc>
		close(i);
}
  801967:	83 c4 14             	add    $0x14,%esp
  80196a:	5b                   	pop    %ebx
  80196b:	5d                   	pop    %ebp
  80196c:	c3                   	ret    

0080196d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	83 ec 58             	sub    $0x58,%esp
  801973:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801976:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801979:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80197c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80197f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801982:	89 44 24 04          	mov    %eax,0x4(%esp)
  801986:	8b 45 08             	mov    0x8(%ebp),%eax
  801989:	89 04 24             	mov    %eax,(%esp)
  80198c:	e8 7c fb ff ff       	call   80150d <fd_lookup>
  801991:	89 c3                	mov    %eax,%ebx
  801993:	85 c0                	test   %eax,%eax
  801995:	0f 88 e0 00 00 00    	js     801a7b <dup+0x10e>
		return r;
	close(newfdnum);
  80199b:	89 3c 24             	mov    %edi,(%esp)
  80199e:	e8 2b ff ff ff       	call   8018ce <close>

	newfd = INDEX2FD(newfdnum);
  8019a3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  8019a9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  8019ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019af:	89 04 24             	mov    %eax,(%esp)
  8019b2:	e8 c9 fa ff ff       	call   801480 <fd2data>
  8019b7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8019b9:	89 34 24             	mov    %esi,(%esp)
  8019bc:	e8 bf fa ff ff       	call   801480 <fd2data>
  8019c1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  8019c4:	89 da                	mov    %ebx,%edx
  8019c6:	89 d8                	mov    %ebx,%eax
  8019c8:	c1 e8 16             	shr    $0x16,%eax
  8019cb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8019d2:	a8 01                	test   $0x1,%al
  8019d4:	74 43                	je     801a19 <dup+0xac>
  8019d6:	c1 ea 0c             	shr    $0xc,%edx
  8019d9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8019e0:	a8 01                	test   $0x1,%al
  8019e2:	74 35                	je     801a19 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  8019e4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8019eb:	25 07 0e 00 00       	and    $0xe07,%eax
  8019f0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019fb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a02:	00 
  801a03:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a07:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a0e:	e8 d5 f8 ff ff       	call   8012e8 <sys_page_map>
  801a13:	89 c3                	mov    %eax,%ebx
  801a15:	85 c0                	test   %eax,%eax
  801a17:	78 3f                	js     801a58 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801a19:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a1c:	89 c2                	mov    %eax,%edx
  801a1e:	c1 ea 0c             	shr    $0xc,%edx
  801a21:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801a28:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801a2e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801a32:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801a36:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a3d:	00 
  801a3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a42:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a49:	e8 9a f8 ff ff       	call   8012e8 <sys_page_map>
  801a4e:	89 c3                	mov    %eax,%ebx
  801a50:	85 c0                	test   %eax,%eax
  801a52:	78 04                	js     801a58 <dup+0xeb>
  801a54:	89 fb                	mov    %edi,%ebx
  801a56:	eb 23                	jmp    801a7b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801a58:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a5c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a63:	e8 22 f8 ff ff       	call   80128a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a68:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a76:	e8 0f f8 ff ff       	call   80128a <sys_page_unmap>
	return r;
}
  801a7b:	89 d8                	mov    %ebx,%eax
  801a7d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a80:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a83:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a86:	89 ec                	mov    %ebp,%esp
  801a88:	5d                   	pop    %ebp
  801a89:	c3                   	ret    
	...

00801a8c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a8c:	55                   	push   %ebp
  801a8d:	89 e5                	mov    %esp,%ebp
  801a8f:	53                   	push   %ebx
  801a90:	83 ec 14             	sub    $0x14,%esp
  801a93:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a95:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801a9b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801aa2:	00 
  801aa3:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801aaa:	00 
  801aab:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aaf:	89 14 24             	mov    %edx,(%esp)
  801ab2:	e8 29 12 00 00       	call   802ce0 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ab7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801abe:	00 
  801abf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ac3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801aca:	e8 73 12 00 00       	call   802d42 <ipc_recv>
}
  801acf:	83 c4 14             	add    $0x14,%esp
  801ad2:	5b                   	pop    %ebx
  801ad3:	5d                   	pop    %ebp
  801ad4:	c3                   	ret    

00801ad5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae1:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae9:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801aee:	ba 00 00 00 00       	mov    $0x0,%edx
  801af3:	b8 02 00 00 00       	mov    $0x2,%eax
  801af8:	e8 8f ff ff ff       	call   801a8c <fsipc>
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801b05:	ba 00 00 00 00       	mov    $0x0,%edx
  801b0a:	b8 08 00 00 00       	mov    $0x8,%eax
  801b0f:	e8 78 ff ff ff       	call   801a8c <fsipc>
}
  801b14:	c9                   	leave  
  801b15:	c3                   	ret    

00801b16 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801b16:	55                   	push   %ebp
  801b17:	89 e5                	mov    %esp,%ebp
  801b19:	53                   	push   %ebx
  801b1a:	83 ec 14             	sub    $0x14,%esp
  801b1d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	8b 40 0c             	mov    0xc(%eax),%eax
  801b26:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b2b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b30:	b8 05 00 00 00       	mov    $0x5,%eax
  801b35:	e8 52 ff ff ff       	call   801a8c <fsipc>
  801b3a:	85 c0                	test   %eax,%eax
  801b3c:	78 2b                	js     801b69 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b3e:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801b45:	00 
  801b46:	89 1c 24             	mov    %ebx,(%esp)
  801b49:	e8 9c f0 ff ff       	call   800bea <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b4e:	a1 80 40 80 00       	mov    0x804080,%eax
  801b53:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b59:	a1 84 40 80 00       	mov    0x804084,%eax
  801b5e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801b64:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801b69:	83 c4 14             	add    $0x14,%esp
  801b6c:	5b                   	pop    %ebx
  801b6d:	5d                   	pop    %ebp
  801b6e:	c3                   	ret    

00801b6f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b6f:	55                   	push   %ebp
  801b70:	89 e5                	mov    %esp,%ebp
  801b72:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  801b75:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801b7c:	00 
  801b7d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b84:	00 
  801b85:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801b8c:	e8 b5 f1 ff ff       	call   800d46 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b91:	8b 45 08             	mov    0x8(%ebp),%eax
  801b94:	8b 40 0c             	mov    0xc(%eax),%eax
  801b97:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801b9c:	ba 00 00 00 00       	mov    $0x0,%edx
  801ba1:	b8 06 00 00 00       	mov    $0x6,%eax
  801ba6:	e8 e1 fe ff ff       	call   801a8c <fsipc>
}
  801bab:	c9                   	leave  
  801bac:	c3                   	ret    

00801bad <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801bad:	55                   	push   %ebp
  801bae:	89 e5                	mov    %esp,%ebp
  801bb0:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801bb3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801bba:	00 
  801bbb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bc2:	00 
  801bc3:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801bca:	e8 77 f1 ff ff       	call   800d46 <memset>
  801bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd2:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801bd7:	76 05                	jbe    801bde <devfile_write+0x31>
  801bd9:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801bde:	8b 55 08             	mov    0x8(%ebp),%edx
  801be1:	8b 52 0c             	mov    0xc(%edx),%edx
  801be4:	89 15 00 40 80 00    	mov    %edx,0x804000
        fsipcbuf.write.req_n = numberOfBytes;
  801bea:	a3 04 40 80 00       	mov    %eax,0x804004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  801bef:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bf3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bfa:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801c01:	e8 9f f1 ff ff       	call   800da5 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  801c06:	ba 00 00 00 00       	mov    $0x0,%edx
  801c0b:	b8 04 00 00 00       	mov    $0x4,%eax
  801c10:	e8 77 fe ff ff       	call   801a8c <fsipc>
              return r;
        return r;
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	53                   	push   %ebx
  801c1b:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  801c1e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801c25:	00 
  801c26:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c2d:	00 
  801c2e:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801c35:	e8 0c f1 ff ff       	call   800d46 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c40:	a3 00 40 80 00       	mov    %eax,0x804000
        fsipcbuf.read.req_n = n;
  801c45:	8b 45 10             	mov    0x10(%ebp),%eax
  801c48:	a3 04 40 80 00       	mov    %eax,0x804004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  801c4d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c52:	b8 03 00 00 00       	mov    $0x3,%eax
  801c57:	e8 30 fe ff ff       	call   801a8c <fsipc>
  801c5c:	89 c3                	mov    %eax,%ebx
  801c5e:	85 c0                	test   %eax,%eax
  801c60:	78 17                	js     801c79 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  801c62:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c66:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801c6d:	00 
  801c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c71:	89 04 24             	mov    %eax,(%esp)
  801c74:	e8 2c f1 ff ff       	call   800da5 <memmove>
        return r;
}
  801c79:	89 d8                	mov    %ebx,%eax
  801c7b:	83 c4 14             	add    $0x14,%esp
  801c7e:	5b                   	pop    %ebx
  801c7f:	5d                   	pop    %ebp
  801c80:	c3                   	ret    

00801c81 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	53                   	push   %ebx
  801c85:	83 ec 14             	sub    $0x14,%esp
  801c88:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801c8b:	89 1c 24             	mov    %ebx,(%esp)
  801c8e:	e8 0d ef ff ff       	call   800ba0 <strlen>
  801c93:	89 c2                	mov    %eax,%edx
  801c95:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801c9a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801ca0:	7f 1f                	jg     801cc1 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801ca2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ca6:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801cad:	e8 38 ef ff ff       	call   800bea <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801cb2:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb7:	b8 07 00 00 00       	mov    $0x7,%eax
  801cbc:	e8 cb fd ff ff       	call   801a8c <fsipc>
}
  801cc1:	83 c4 14             	add    $0x14,%esp
  801cc4:	5b                   	pop    %ebx
  801cc5:	5d                   	pop    %ebp
  801cc6:	c3                   	ret    

00801cc7 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	56                   	push   %esi
  801ccb:	53                   	push   %ebx
  801ccc:	83 ec 20             	sub    $0x20,%esp
  801ccf:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  801cd2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801cd9:	00 
  801cda:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ce1:	00 
  801ce2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801ce9:	e8 58 f0 ff ff       	call   800d46 <memset>
    if(strlen(path)>=MAXPATHLEN)
  801cee:	89 34 24             	mov    %esi,(%esp)
  801cf1:	e8 aa ee ff ff       	call   800ba0 <strlen>
  801cf6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801cfb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d00:	0f 8f 84 00 00 00    	jg     801d8a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  801d06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d09:	89 04 24             	mov    %eax,(%esp)
  801d0c:	e8 8a f7 ff ff       	call   80149b <fd_alloc>
  801d11:	89 c3                	mov    %eax,%ebx
  801d13:	85 c0                	test   %eax,%eax
  801d15:	78 73                	js     801d8a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  801d17:	0f b6 06             	movzbl (%esi),%eax
  801d1a:	84 c0                	test   %al,%al
  801d1c:	74 20                	je     801d3e <open+0x77>
  801d1e:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  801d20:	0f be c0             	movsbl %al,%eax
  801d23:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d27:	c7 04 24 9c 35 80 00 	movl   $0x80359c,(%esp)
  801d2e:	e8 da e7 ff ff       	call   80050d <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  801d33:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  801d37:	83 c3 01             	add    $0x1,%ebx
  801d3a:	84 c0                	test   %al,%al
  801d3c:	75 e2                	jne    801d20 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  801d3e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d42:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801d49:	e8 9c ee ff ff       	call   800bea <strcpy>
    fsipcbuf.open.req_omode = mode;
  801d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d51:	a3 00 44 80 00       	mov    %eax,0x804400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  801d56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d59:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5e:	e8 29 fd ff ff       	call   801a8c <fsipc>
  801d63:	89 c3                	mov    %eax,%ebx
  801d65:	85 c0                	test   %eax,%eax
  801d67:	79 15                	jns    801d7e <open+0xb7>
        {
            fd_close(fd,1);
  801d69:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801d70:	00 
  801d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d74:	89 04 24             	mov    %eax,(%esp)
  801d77:	e8 d3 fa ff ff       	call   80184f <fd_close>
             return r;
  801d7c:	eb 0c                	jmp    801d8a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  801d7e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801d81:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  801d87:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  801d8a:	89 d8                	mov    %ebx,%eax
  801d8c:	83 c4 20             	add    $0x20,%esp
  801d8f:	5b                   	pop    %ebx
  801d90:	5e                   	pop    %esi
  801d91:	5d                   	pop    %ebp
  801d92:	c3                   	ret    
	...

00801d94 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801d94:	55                   	push   %ebp
  801d95:	89 e5                	mov    %esp,%ebp
  801d97:	57                   	push   %edi
  801d98:	56                   	push   %esi
  801d99:	53                   	push   %ebx
  801d9a:	81 ec 9c 02 00 00    	sub    $0x29c,%esp
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801da0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801da7:	00 
  801da8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dab:	89 04 24             	mov    %eax,(%esp)
  801dae:	e8 14 ff ff ff       	call   801cc7 <open>
  801db3:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
  801db9:	89 c3                	mov    %eax,%ebx
  801dbb:	85 c0                	test   %eax,%eax
  801dbd:	0f 88 d1 05 00 00    	js     802394 <spawn+0x600>
	fd = r;
    // cprintf("fd--->%d",fd);
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
	    || elf->e_magic != ELF_MAGIC) {
  801dc3:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
  801dca:	00 
  801dcb:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801dd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dd5:	89 1c 24             	mov    %ebx,(%esp)
  801dd8:	e8 91 f9 ff ff       	call   80176e <read>
		return r;
	fd = r;
    // cprintf("fd--->%d",fd);
	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (read(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801ddd:	3d 00 02 00 00       	cmp    $0x200,%eax
  801de2:	75 0c                	jne    801df0 <spawn+0x5c>
	    || elf->e_magic != ELF_MAGIC) {
  801de4:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801deb:	45 4c 46 
  801dee:	74 36                	je     801e26 <spawn+0x92>
		close(fd);
  801df0:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  801df6:	89 04 24             	mov    %eax,(%esp)
  801df9:	e8 d0 fa ff ff       	call   8018ce <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801dfe:	c7 44 24 08 7f 45 4c 	movl   $0x464c457f,0x8(%esp)
  801e05:	46 
  801e06:	8b 85 e8 fd ff ff    	mov    -0x218(%ebp),%eax
  801e0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e10:	c7 04 24 9f 35 80 00 	movl   $0x80359f,(%esp)
  801e17:	e8 f1 e6 ff ff       	call   80050d <cprintf>
  801e1c:	bb f2 ff ff ff       	mov    $0xfffffff2,%ebx
		return -E_NOT_EXEC;
  801e21:	e9 6e 05 00 00       	jmp    802394 <spawn+0x600>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  801e26:	ba 07 00 00 00       	mov    $0x7,%edx
  801e2b:	89 d0                	mov    %edx,%eax
  801e2d:	cd 30                	int    $0x30
  801e2f:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
	}
     
       // Create new child environment
	if ((r = sys_exofork()) < 0)
  801e35:	85 c0                	test   %eax,%eax
  801e37:	0f 88 51 05 00 00    	js     80238e <spawn+0x5fa>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801e3d:	89 c6                	mov    %eax,%esi
  801e3f:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
  801e45:	6b f6 7c             	imul   $0x7c,%esi,%esi
  801e48:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801e4e:	81 c6 00 00 c0 ee    	add    $0xeec00000,%esi
  801e54:	b9 11 00 00 00       	mov    $0x11,%ecx
  801e59:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	cprintf("\nelf->entry %x\n",elf->e_entry);
  801e5b:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801e61:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e65:	c7 04 24 b9 35 80 00 	movl   $0x8035b9,(%esp)
  801e6c:	e8 9c e6 ff ff       	call   80050d <cprintf>
        child_tf.tf_eip = elf->e_entry;
  801e71:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801e77:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801e7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e80:	8b 02                	mov    (%edx),%eax
  801e82:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e87:	be 00 00 00 00       	mov    $0x0,%esi
  801e8c:	85 c0                	test   %eax,%eax
  801e8e:	75 16                	jne    801ea6 <spawn+0x112>
  801e90:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  801e97:	00 00 00 
  801e9a:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801ea1:	00 00 00 
  801ea4:	eb 2c                	jmp    801ed2 <spawn+0x13e>
  801ea6:	8b 7d 0c             	mov    0xc(%ebp),%edi
		string_size += strlen(argv[argc]) + 1;
  801ea9:	89 04 24             	mov    %eax,(%esp)
  801eac:	e8 ef ec ff ff       	call   800ba0 <strlen>
  801eb1:	8d 5c 18 01          	lea    0x1(%eax,%ebx,1),%ebx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801eb5:	83 c6 01             	add    $0x1,%esi
  801eb8:	8d 14 b5 00 00 00 00 	lea    0x0(,%esi,4),%edx
  801ebf:	8b 04 b7             	mov    (%edi,%esi,4),%eax
  801ec2:	85 c0                	test   %eax,%eax
  801ec4:	75 e3                	jne    801ea9 <spawn+0x115>
  801ec6:	89 95 7c fd ff ff    	mov    %edx,-0x284(%ebp)
  801ecc:	89 b5 78 fd ff ff    	mov    %esi,-0x288(%ebp)
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801ed2:	f7 db                	neg    %ebx
  801ed4:	8d bb 00 10 40 00    	lea    0x401000(%ebx),%edi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801eda:	89 fa                	mov    %edi,%edx
  801edc:	83 e2 fc             	and    $0xfffffffc,%edx
  801edf:	89 f0                	mov    %esi,%eax
  801ee1:	f7 d0                	not    %eax
  801ee3:	8d 04 82             	lea    (%edx,%eax,4),%eax
  801ee6:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801eec:	83 e8 08             	sub    $0x8,%eax
  801eef:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
	return child;

error:
	sys_env_destroy(child);
	close(fd);
	return r;
  801ef5:	bb fc ff ff ff       	mov    $0xfffffffc,%ebx
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
	
	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801efa:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801eff:	0f 86 8f 04 00 00    	jbe    802394 <spawn+0x600>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801f05:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801f0c:	00 
  801f0d:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  801f14:	00 
  801f15:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f1c:	e8 25 f4 ff ff       	call   801346 <sys_page_alloc>
  801f21:	89 c3                	mov    %eax,%ebx
  801f23:	85 c0                	test   %eax,%eax
  801f25:	0f 88 69 04 00 00    	js     802394 <spawn+0x600>
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801f2b:	85 f6                	test   %esi,%esi
  801f2d:	7e 46                	jle    801f75 <spawn+0x1e1>
  801f2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f34:	89 b5 8c fd ff ff    	mov    %esi,-0x274(%ebp)
  801f3a:	8b 75 0c             	mov    0xc(%ebp),%esi
		argv_store[i] = UTEMP2USTACK(string_store);
  801f3d:	8d 87 00 d0 7f ee    	lea    -0x11803000(%edi),%eax
  801f43:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801f49:	89 04 9a             	mov    %eax,(%edx,%ebx,4)
		strcpy(string_store, argv[i]);
  801f4c:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801f4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f53:	89 3c 24             	mov    %edi,(%esp)
  801f56:	e8 8f ec ff ff       	call   800bea <strcpy>
		string_store += strlen(argv[i]) + 1;
  801f5b:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  801f5e:	89 04 24             	mov    %eax,(%esp)
  801f61:	e8 3a ec ff ff       	call   800ba0 <strlen>
  801f66:	8d 7c 07 01          	lea    0x1(%edi,%eax,1),%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801f6a:	83 c3 01             	add    $0x1,%ebx
  801f6d:	3b 9d 8c fd ff ff    	cmp    -0x274(%ebp),%ebx
  801f73:	7c c8                	jl     801f3d <spawn+0x1a9>
		argv_store[i] = UTEMP2USTACK(string_store);
		strcpy(string_store, argv[i]);
		string_store += strlen(argv[i]) + 1;
	}
	argv_store[argc] = 0;
  801f75:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801f7b:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801f81:	c7 04 02 00 00 00 00 	movl   $0x0,(%edx,%eax,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801f88:	81 ff 00 10 40 00    	cmp    $0x401000,%edi
  801f8e:	74 24                	je     801fb4 <spawn+0x220>
  801f90:	c7 44 24 0c 4c 36 80 	movl   $0x80364c,0xc(%esp)
  801f97:	00 
  801f98:	c7 44 24 08 c9 35 80 	movl   $0x8035c9,0x8(%esp)
  801f9f:	00 
  801fa0:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  801fa7:	00 
  801fa8:	c7 04 24 de 35 80 00 	movl   $0x8035de,(%esp)
  801faf:	e8 94 e4 ff ff       	call   800448 <_panic>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801fb4:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801fba:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801fbf:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  801fc5:	89 42 fc             	mov    %eax,-0x4(%edx)
	argv_store[-2] = argc;
  801fc8:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  801fce:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801fd4:	89 10                	mov    %edx,(%eax)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801fd6:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801fdc:	2d 08 30 80 11       	sub    $0x11803008,%eax
  801fe1:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801fe7:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  801fee:	00 
  801fef:	c7 44 24 0c 00 d0 bf 	movl   $0xeebfd000,0xc(%esp)
  801ff6:	ee 
  801ff7:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801ffd:	89 44 24 08          	mov    %eax,0x8(%esp)
  802001:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802008:	00 
  802009:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802010:	e8 d3 f2 ff ff       	call   8012e8 <sys_page_map>
  802015:	89 c3                	mov    %eax,%ebx
  802017:	85 c0                	test   %eax,%eax
  802019:	78 1a                	js     802035 <spawn+0x2a1>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80201b:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802022:	00 
  802023:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80202a:	e8 5b f2 ff ff       	call   80128a <sys_page_unmap>
  80202f:	89 c3                	mov    %eax,%ebx
  802031:	85 c0                	test   %eax,%eax
  802033:	79 19                	jns    80204e <spawn+0x2ba>
		goto error;

	return 0;

error:
	sys_page_unmap(0, UTEMP);
  802035:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80203c:	00 
  80203d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802044:	e8 41 f2 ff ff       	call   80128a <sys_page_unmap>
  802049:	e9 46 03 00 00       	jmp    802394 <spawn+0x600>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  80204e:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802054:	66 83 bd 14 fe ff ff 	cmpw   $0x0,-0x1ec(%ebp)
  80205b:	00 
  80205c:	0f 84 e3 01 00 00    	je     802245 <spawn+0x4b1>

	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802062:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  802069:	89 85 80 fd ff ff    	mov    %eax,-0x280(%ebp)
  80206f:	c7 85 7c fd ff ff 00 	movl   $0x0,-0x284(%ebp)
  802076:	00 00 00 
	for (i = 0; i < elf->e_phnum; i++, ph++) {
               // cprintf("\nHello\n");
		if (ph->p_type != ELF_PROG_LOAD)
  802079:	8b 95 80 fd ff ff    	mov    -0x280(%ebp),%edx
  80207f:	83 3a 01             	cmpl   $0x1,(%edx)
  802082:	0f 85 9b 01 00 00    	jne    802223 <spawn+0x48f>
			continue;
		perm = PTE_P | PTE_U;
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802088:	8b 42 18             	mov    0x18(%edx),%eax
  80208b:	83 e0 02             	and    $0x2,%eax
  80208e:	83 f8 01             	cmp    $0x1,%eax
  802091:	19 c0                	sbb    %eax,%eax
  802093:	83 e0 fe             	and    $0xfffffffe,%eax
  802096:	83 c0 07             	add    $0x7,%eax
  802099:	89 85 94 fd ff ff    	mov    %eax,-0x26c(%ebp)
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
  80209f:	8b 52 04             	mov    0x4(%edx),%edx
  8020a2:	89 95 78 fd ff ff    	mov    %edx,-0x288(%ebp)
  8020a8:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8020ae:	8b 58 10             	mov    0x10(%eax),%ebx
  8020b1:	8b 50 14             	mov    0x14(%eax),%edx
  8020b4:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
  8020ba:	8b 40 08             	mov    0x8(%eax),%eax
  8020bd:	89 85 90 fd ff ff    	mov    %eax,-0x270(%ebp)
	int i, r;
	void *blk;

	//cprintf("map_segment %x+%x\n", va, memsz);

	if ((i = PGOFF(va))) {
  8020c3:	25 ff 0f 00 00       	and    $0xfff,%eax
  8020c8:	74 16                	je     8020e0 <spawn+0x34c>
		va -= i;
  8020ca:	29 85 90 fd ff ff    	sub    %eax,-0x270(%ebp)
		memsz += i;
  8020d0:	01 c2                	add    %eax,%edx
  8020d2:	89 95 8c fd ff ff    	mov    %edx,-0x274(%ebp)
		filesz += i;
  8020d8:	01 c3                	add    %eax,%ebx
		fileoffset -= i;
  8020da:	29 85 78 fd ff ff    	sub    %eax,-0x288(%ebp)
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  8020e0:	83 bd 8c fd ff ff 00 	cmpl   $0x0,-0x274(%ebp)
  8020e7:	0f 84 36 01 00 00    	je     802223 <spawn+0x48f>
  8020ed:	bf 00 00 00 00       	mov    $0x0,%edi
  8020f2:	be 00 00 00 00       	mov    $0x0,%esi
		if (i >= filesz) {
  8020f7:	39 fb                	cmp    %edi,%ebx
  8020f9:	77 31                	ja     80212c <spawn+0x398>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  8020fb:	8b 95 94 fd ff ff    	mov    -0x26c(%ebp),%edx
  802101:	89 54 24 08          	mov    %edx,0x8(%esp)
  802105:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  80210b:	89 7c 24 04          	mov    %edi,0x4(%esp)
  80210f:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802115:	89 04 24             	mov    %eax,(%esp)
  802118:	e8 29 f2 ff ff       	call   801346 <sys_page_alloc>
  80211d:	85 c0                	test   %eax,%eax
  80211f:	0f 89 ea 00 00 00    	jns    80220f <spawn+0x47b>
  802125:	89 c3                	mov    %eax,%ebx
  802127:	e9 44 02 00 00       	jmp    802370 <spawn+0x5dc>
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  80212c:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802133:	00 
  802134:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80213b:	00 
  80213c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802143:	e8 fe f1 ff ff       	call   801346 <sys_page_alloc>
  802148:	85 c0                	test   %eax,%eax
  80214a:	0f 88 16 02 00 00    	js     802366 <spawn+0x5d2>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  802150:	8b 95 78 fd ff ff    	mov    -0x288(%ebp),%edx
  802156:	8d 04 16             	lea    (%esi,%edx,1),%eax
  802159:	89 44 24 04          	mov    %eax,0x4(%esp)
  80215d:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802163:	89 04 24             	mov    %eax,(%esp)
  802166:	e8 ea f3 ff ff       	call   801555 <seek>
  80216b:	85 c0                	test   %eax,%eax
  80216d:	0f 88 f7 01 00 00    	js     80236a <spawn+0x5d6>
				return r;
			if ((r = read(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  802173:	89 d8                	mov    %ebx,%eax
  802175:	29 f8                	sub    %edi,%eax
  802177:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80217c:	76 05                	jbe    802183 <spawn+0x3ef>
  80217e:	b8 00 10 00 00       	mov    $0x1000,%eax
  802183:	89 44 24 08          	mov    %eax,0x8(%esp)
  802187:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  80218e:	00 
  80218f:	8b 95 84 fd ff ff    	mov    -0x27c(%ebp),%edx
  802195:	89 14 24             	mov    %edx,(%esp)
  802198:	e8 d1 f5 ff ff       	call   80176e <read>
  80219d:	85 c0                	test   %eax,%eax
  80219f:	0f 88 c9 01 00 00    	js     80236e <spawn+0x5da>
				return r;
			//cprintf("\nvirtual address----->%x\n",va+i);
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  8021a5:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8021ab:	89 44 24 10          	mov    %eax,0x10(%esp)
  8021af:	03 bd 90 fd ff ff    	add    -0x270(%ebp),%edi
  8021b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8021b9:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  8021bf:	89 54 24 08          	mov    %edx,0x8(%esp)
  8021c3:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  8021ca:	00 
  8021cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021d2:	e8 11 f1 ff ff       	call   8012e8 <sys_page_map>
  8021d7:	85 c0                	test   %eax,%eax
  8021d9:	79 20                	jns    8021fb <spawn+0x467>
				panic("spawn: sys_page_map data: %e", r);
  8021db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021df:	c7 44 24 08 ea 35 80 	movl   $0x8035ea,0x8(%esp)
  8021e6:	00 
  8021e7:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  8021ee:	00 
  8021ef:	c7 04 24 de 35 80 00 	movl   $0x8035de,(%esp)
  8021f6:	e8 4d e2 ff ff       	call   800448 <_panic>
			sys_page_unmap(0, UTEMP);
  8021fb:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
  802202:	00 
  802203:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80220a:	e8 7b f0 ff ff       	call   80128a <sys_page_unmap>
		memsz += i;
		filesz += i;
		fileoffset -= i;
	}

	for (i = 0; i < memsz; i += PGSIZE) {
  80220f:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802215:	89 f7                	mov    %esi,%edi
  802217:	39 b5 8c fd ff ff    	cmp    %esi,-0x274(%ebp)
  80221d:	0f 87 d4 fe ff ff    	ja     8020f7 <spawn+0x363>
	if ((r = init_stack(child, argv, &child_tf.tf_esp)) < 0)
		return r;

	// Set up program segments as defined in ELF header.
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  802223:	83 85 7c fd ff ff 01 	addl   $0x1,-0x284(%ebp)
  80222a:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  802231:	3b 85 7c fd ff ff    	cmp    -0x284(%ebp),%eax
  802237:	7e 0c                	jle    802245 <spawn+0x4b1>
  802239:	83 85 80 fd ff ff 20 	addl   $0x20,-0x280(%ebp)
  802240:	e9 34 fe ff ff       	jmp    802079 <spawn+0x2e5>
			perm |= PTE_W;
		if ((r = map_segment(child, ph->p_va, ph->p_memsz, 
				     fd, ph->p_filesz, ph->p_offset, perm)) < 0)
			goto error;
	}
	close(fd);
  802245:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  80224b:	89 04 24             	mov    %eax,(%esp)
  80224e:	e8 7b f6 ff ff       	call   8018ce <close>
  802253:	bb 00 00 80 00       	mov    $0x800000,%ebx
duplicateSharepage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
        pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  802258:	be 00 d0 7b ef       	mov    $0xef7bd000,%esi
       
        if( 0 == pgDirEntry )
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  80225d:	bf 00 00 40 ef       	mov    $0xef400000,%edi
	// LAB 7: Your code here.
	uint8_t *addr;
	extern unsigned char end[];
	for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
                {    
			duplicateSharepage(child, VPN(addr));
  802262:	89 d8                	mov    %ebx,%eax
  802264:	c1 e8 0c             	shr    $0xc,%eax
duplicateSharepage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
        pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  802267:	89 c2                	mov    %eax,%edx
  802269:	c1 e2 0c             	shl    $0xc,%edx
  80226c:	89 d1                	mov    %edx,%ecx
  80226e:	c1 e9 16             	shr    $0x16,%ecx
  802271:	8b 0c 8e             	mov    (%esi,%ecx,4),%ecx
       
        if( 0 == pgDirEntry )
  802274:	85 c9                	test   %ecx,%ecx
  802276:	74 66                	je     8022de <spawn+0x54a>
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  802278:	8b 04 87             	mov    (%edi,%eax,4),%eax
  80227b:	89 c1                	mov    %eax,%ecx
  80227d:	81 e1 ff 0f 00 00    	and    $0xfff,%ecx
        //cprintf("Below %d",vpt[pn]);
                //if(perm!=0)  //commented nw.
                   // cprintf("perm bit %d",perm);
	//cprintf("\nInside Spawn setting share\n");
	if((perm & PTE_W) && (perm & PTE_SHARE))
  802283:	25 02 04 00 00       	and    $0x402,%eax
  802288:	3d 02 04 00 00       	cmp    $0x402,%eax
  80228d:	75 4f                	jne    8022de <spawn+0x54a>
	{
		if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_SHARE|(perm & PTE_USER))) < 0)
  80228f:	81 e1 07 0a 00 00    	and    $0xa07,%ecx
  802295:	80 cd 04             	or     $0x4,%ch
  802298:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  80229c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8022a0:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  8022a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022ae:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022b5:	e8 2e f0 ff ff       	call   8012e8 <sys_page_map>
  8022ba:	85 c0                	test   %eax,%eax
  8022bc:	79 20                	jns    8022de <spawn+0x54a>
                panic("sys_page_map: %e", r);
  8022be:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022c2:	c7 44 24 08 07 36 80 	movl   $0x803607,0x8(%esp)
  8022c9:	00 
  8022ca:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  8022d1:	00 
  8022d2:	c7 04 24 de 35 80 00 	movl   $0x8035de,(%esp)
  8022d9:	e8 6a e1 ff ff       	call   800448 <_panic>
copy_shared_pages(envid_t child)
{
	// LAB 7: Your code here.
	uint8_t *addr;
	extern unsigned char end[];
	for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
  8022de:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8022e4:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  8022ea:	0f 85 72 ff ff ff    	jne    802262 <spawn+0x4ce>

	// Copy shared library state.
	if ((r = copy_shared_pages(child)) < 0)
		panic("copy_shared_pages: %e", r);

	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  8022f0:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  8022f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022fa:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  802300:	89 14 24             	mov    %edx,(%esp)
  802303:	e8 c6 ee ff ff       	call   8011ce <sys_env_set_trapframe>
  802308:	85 c0                	test   %eax,%eax
  80230a:	79 20                	jns    80232c <spawn+0x598>
		panic("sys_env_set_trapframe: %e", r);
  80230c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802310:	c7 44 24 08 18 36 80 	movl   $0x803618,0x8(%esp)
  802317:	00 
  802318:	c7 44 24 04 87 00 00 	movl   $0x87,0x4(%esp)
  80231f:	00 
  802320:	c7 04 24 de 35 80 00 	movl   $0x8035de,(%esp)
  802327:	e8 1c e1 ff ff       	call   800448 <_panic>
                   //    cprintf("\nHello below trpaframe%d\n",elf->e_phnum);
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  80232c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802333:	00 
  802334:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  80233a:	89 04 24             	mov    %eax,(%esp)
  80233d:	e8 ea ee ff ff       	call   80122c <sys_env_set_status>
  802342:	85 c0                	test   %eax,%eax
  802344:	79 48                	jns    80238e <spawn+0x5fa>
		panic("sys_env_set_status: %e", r);
  802346:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80234a:	c7 44 24 08 32 36 80 	movl   $0x803632,0x8(%esp)
  802351:	00 
  802352:	c7 44 24 04 8a 00 00 	movl   $0x8a,0x4(%esp)
  802359:	00 
  80235a:	c7 04 24 de 35 80 00 	movl   $0x8035de,(%esp)
  802361:	e8 e2 e0 ff ff       	call   800448 <_panic>
  802366:	89 c3                	mov    %eax,%ebx
  802368:	eb 06                	jmp    802370 <spawn+0x5dc>
  80236a:	89 c3                	mov    %eax,%ebx
  80236c:	eb 02                	jmp    802370 <spawn+0x5dc>
  80236e:	89 c3                	mov    %eax,%ebx

	return child;

error:
	sys_env_destroy(child);
  802370:	8b 95 88 fd ff ff    	mov    -0x278(%ebp),%edx
  802376:	89 14 24             	mov    %edx,(%esp)
  802379:	e8 8f f0 ff ff       	call   80140d <sys_env_destroy>
	close(fd);
  80237e:	8b 85 84 fd ff ff    	mov    -0x27c(%ebp),%eax
  802384:	89 04 24             	mov    %eax,(%esp)
  802387:	e8 42 f5 ff ff       	call   8018ce <close>
	return r;
  80238c:	eb 06                	jmp    802394 <spawn+0x600>
  80238e:	8b 9d 88 fd ff ff    	mov    -0x278(%ebp),%ebx
}
  802394:	89 d8                	mov    %ebx,%eax
  802396:	81 c4 9c 02 00 00    	add    $0x29c,%esp
  80239c:	5b                   	pop    %ebx
  80239d:	5e                   	pop    %esi
  80239e:	5f                   	pop    %edi
  80239f:	5d                   	pop    %ebp
  8023a0:	c3                   	ret    

008023a1 <spawnl>:

// Spawn, taking command-line arguments array directly on the stack.
int
spawnl(const char *prog, const char *arg0, ...)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
  8023a4:	83 ec 18             	sub    $0x18,%esp
	return spawn(prog, &arg0);
  8023a7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8023aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	89 04 24             	mov    %eax,(%esp)
  8023b4:	e8 db f9 ff ff       	call   801d94 <spawn>
}
  8023b9:	c9                   	leave  
  8023ba:	c3                   	ret    
  8023bb:	00 00                	add    %al,(%eax)
  8023bd:	00 00                	add    %al,(%eax)
	...

008023c0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8023c0:	55                   	push   %ebp
  8023c1:	89 e5                	mov    %esp,%ebp
  8023c3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8023c6:	c7 44 24 04 74 36 80 	movl   $0x803674,0x4(%esp)
  8023cd:	00 
  8023ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023d1:	89 04 24             	mov    %eax,(%esp)
  8023d4:	e8 11 e8 ff ff       	call   800bea <strcpy>
	return 0;
}
  8023d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
  8023e3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  8023e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e9:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ec:	89 04 24             	mov    %eax,(%esp)
  8023ef:	e8 9e 02 00 00       	call   802692 <nsipc_close>
}
  8023f4:	c9                   	leave  
  8023f5:	c3                   	ret    

008023f6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8023f6:	55                   	push   %ebp
  8023f7:	89 e5                	mov    %esp,%ebp
  8023f9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8023fc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802403:	00 
  802404:	8b 45 10             	mov    0x10(%ebp),%eax
  802407:	89 44 24 08          	mov    %eax,0x8(%esp)
  80240b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80240e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	8b 40 0c             	mov    0xc(%eax),%eax
  802418:	89 04 24             	mov    %eax,(%esp)
  80241b:	e8 ae 02 00 00       	call   8026ce <nsipc_send>
}
  802420:	c9                   	leave  
  802421:	c3                   	ret    

00802422 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802422:	55                   	push   %ebp
  802423:	89 e5                	mov    %esp,%ebp
  802425:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802428:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80242f:	00 
  802430:	8b 45 10             	mov    0x10(%ebp),%eax
  802433:	89 44 24 08          	mov    %eax,0x8(%esp)
  802437:	8b 45 0c             	mov    0xc(%ebp),%eax
  80243a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80243e:	8b 45 08             	mov    0x8(%ebp),%eax
  802441:	8b 40 0c             	mov    0xc(%eax),%eax
  802444:	89 04 24             	mov    %eax,(%esp)
  802447:	e8 f5 02 00 00       	call   802741 <nsipc_recv>
}
  80244c:	c9                   	leave  
  80244d:	c3                   	ret    

0080244e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  80244e:	55                   	push   %ebp
  80244f:	89 e5                	mov    %esp,%ebp
  802451:	56                   	push   %esi
  802452:	53                   	push   %ebx
  802453:	83 ec 20             	sub    $0x20,%esp
  802456:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802458:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80245b:	89 04 24             	mov    %eax,(%esp)
  80245e:	e8 38 f0 ff ff       	call   80149b <fd_alloc>
  802463:	89 c3                	mov    %eax,%ebx
  802465:	85 c0                	test   %eax,%eax
  802467:	78 21                	js     80248a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  802469:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802470:	00 
  802471:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802474:	89 44 24 04          	mov    %eax,0x4(%esp)
  802478:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80247f:	e8 c2 ee ff ff       	call   801346 <sys_page_alloc>
  802484:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802486:	85 c0                	test   %eax,%eax
  802488:	79 0a                	jns    802494 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80248a:	89 34 24             	mov    %esi,(%esp)
  80248d:	e8 00 02 00 00       	call   802692 <nsipc_close>
		return r;
  802492:	eb 28                	jmp    8024bc <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  802494:	8b 15 ac 87 80 00    	mov    0x8087ac,%edx
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8024af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b2:	89 04 24             	mov    %eax,(%esp)
  8024b5:	e8 b6 ef ff ff       	call   801470 <fd2num>
  8024ba:	89 c3                	mov    %eax,%ebx
}
  8024bc:	89 d8                	mov    %ebx,%eax
  8024be:	83 c4 20             	add    $0x20,%esp
  8024c1:	5b                   	pop    %ebx
  8024c2:	5e                   	pop    %esi
  8024c3:	5d                   	pop    %ebp
  8024c4:	c3                   	ret    

008024c5 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8024c5:	55                   	push   %ebp
  8024c6:	89 e5                	mov    %esp,%ebp
  8024c8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8024cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8024ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8024dc:	89 04 24             	mov    %eax,(%esp)
  8024df:	e8 62 01 00 00       	call   802646 <nsipc_socket>
  8024e4:	85 c0                	test   %eax,%eax
  8024e6:	78 05                	js     8024ed <socket+0x28>
		return r;
	return alloc_sockfd(r);
  8024e8:	e8 61 ff ff ff       	call   80244e <alloc_sockfd>
}
  8024ed:	c9                   	leave  
  8024ee:	66 90                	xchg   %ax,%ax
  8024f0:	c3                   	ret    

008024f1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8024f1:	55                   	push   %ebp
  8024f2:	89 e5                	mov    %esp,%ebp
  8024f4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8024f7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8024fa:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024fe:	89 04 24             	mov    %eax,(%esp)
  802501:	e8 07 f0 ff ff       	call   80150d <fd_lookup>
  802506:	85 c0                	test   %eax,%eax
  802508:	78 15                	js     80251f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80250a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250d:	8b 0a                	mov    (%edx),%ecx
  80250f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802514:	3b 0d ac 87 80 00    	cmp    0x8087ac,%ecx
  80251a:	75 03                	jne    80251f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80251c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  80251f:	c9                   	leave  
  802520:	c3                   	ret    

00802521 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
  802524:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802527:	8b 45 08             	mov    0x8(%ebp),%eax
  80252a:	e8 c2 ff ff ff       	call   8024f1 <fd2sockid>
  80252f:	85 c0                	test   %eax,%eax
  802531:	78 0f                	js     802542 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  802533:	8b 55 0c             	mov    0xc(%ebp),%edx
  802536:	89 54 24 04          	mov    %edx,0x4(%esp)
  80253a:	89 04 24             	mov    %eax,(%esp)
  80253d:	e8 2e 01 00 00       	call   802670 <nsipc_listen>
}
  802542:	c9                   	leave  
  802543:	c3                   	ret    

00802544 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802544:	55                   	push   %ebp
  802545:	89 e5                	mov    %esp,%ebp
  802547:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80254a:	8b 45 08             	mov    0x8(%ebp),%eax
  80254d:	e8 9f ff ff ff       	call   8024f1 <fd2sockid>
  802552:	85 c0                	test   %eax,%eax
  802554:	78 16                	js     80256c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802556:	8b 55 10             	mov    0x10(%ebp),%edx
  802559:	89 54 24 08          	mov    %edx,0x8(%esp)
  80255d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802560:	89 54 24 04          	mov    %edx,0x4(%esp)
  802564:	89 04 24             	mov    %eax,(%esp)
  802567:	e8 55 02 00 00       	call   8027c1 <nsipc_connect>
}
  80256c:	c9                   	leave  
  80256d:	c3                   	ret    

0080256e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80256e:	55                   	push   %ebp
  80256f:	89 e5                	mov    %esp,%ebp
  802571:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802574:	8b 45 08             	mov    0x8(%ebp),%eax
  802577:	e8 75 ff ff ff       	call   8024f1 <fd2sockid>
  80257c:	85 c0                	test   %eax,%eax
  80257e:	78 0f                	js     80258f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802580:	8b 55 0c             	mov    0xc(%ebp),%edx
  802583:	89 54 24 04          	mov    %edx,0x4(%esp)
  802587:	89 04 24             	mov    %eax,(%esp)
  80258a:	e8 1d 01 00 00       	call   8026ac <nsipc_shutdown>
}
  80258f:	c9                   	leave  
  802590:	c3                   	ret    

00802591 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802591:	55                   	push   %ebp
  802592:	89 e5                	mov    %esp,%ebp
  802594:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802597:	8b 45 08             	mov    0x8(%ebp),%eax
  80259a:	e8 52 ff ff ff       	call   8024f1 <fd2sockid>
  80259f:	85 c0                	test   %eax,%eax
  8025a1:	78 16                	js     8025b9 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8025a3:	8b 55 10             	mov    0x10(%ebp),%edx
  8025a6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ad:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025b1:	89 04 24             	mov    %eax,(%esp)
  8025b4:	e8 47 02 00 00       	call   802800 <nsipc_bind>
}
  8025b9:	c9                   	leave  
  8025ba:	c3                   	ret    

008025bb <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8025bb:	55                   	push   %ebp
  8025bc:	89 e5                	mov    %esp,%ebp
  8025be:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8025c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c4:	e8 28 ff ff ff       	call   8024f1 <fd2sockid>
  8025c9:	85 c0                	test   %eax,%eax
  8025cb:	78 1f                	js     8025ec <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8025cd:	8b 55 10             	mov    0x10(%ebp),%edx
  8025d0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025d7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025db:	89 04 24             	mov    %eax,(%esp)
  8025de:	e8 5c 02 00 00       	call   80283f <nsipc_accept>
  8025e3:	85 c0                	test   %eax,%eax
  8025e5:	78 05                	js     8025ec <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8025e7:	e8 62 fe ff ff       	call   80244e <alloc_sockfd>
}
  8025ec:	c9                   	leave  
  8025ed:	8d 76 00             	lea    0x0(%esi),%esi
  8025f0:	c3                   	ret    
	...

00802600 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802600:	55                   	push   %ebp
  802601:	89 e5                	mov    %esp,%ebp
  802603:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802606:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  80260c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802613:	00 
  802614:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80261b:	00 
  80261c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802620:	89 14 24             	mov    %edx,(%esp)
  802623:	e8 b8 06 00 00       	call   802ce0 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802628:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80262f:	00 
  802630:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802637:	00 
  802638:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80263f:	e8 fe 06 00 00       	call   802d42 <ipc_recv>
}
  802644:	c9                   	leave  
  802645:	c3                   	ret    

00802646 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  802646:	55                   	push   %ebp
  802647:	89 e5                	mov    %esp,%ebp
  802649:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80264c:	8b 45 08             	mov    0x8(%ebp),%eax
  80264f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802654:	8b 45 0c             	mov    0xc(%ebp),%eax
  802657:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80265c:	8b 45 10             	mov    0x10(%ebp),%eax
  80265f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802664:	b8 09 00 00 00       	mov    $0x9,%eax
  802669:	e8 92 ff ff ff       	call   802600 <nsipc>
}
  80266e:	c9                   	leave  
  80266f:	c3                   	ret    

00802670 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802670:	55                   	push   %ebp
  802671:	89 e5                	mov    %esp,%ebp
  802673:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802676:	8b 45 08             	mov    0x8(%ebp),%eax
  802679:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80267e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802681:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802686:	b8 06 00 00 00       	mov    $0x6,%eax
  80268b:	e8 70 ff ff ff       	call   802600 <nsipc>
}
  802690:	c9                   	leave  
  802691:	c3                   	ret    

00802692 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802692:	55                   	push   %ebp
  802693:	89 e5                	mov    %esp,%ebp
  802695:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802698:	8b 45 08             	mov    0x8(%ebp),%eax
  80269b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8026a0:	b8 04 00 00 00       	mov    $0x4,%eax
  8026a5:	e8 56 ff ff ff       	call   802600 <nsipc>
}
  8026aa:	c9                   	leave  
  8026ab:	c3                   	ret    

008026ac <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  8026ac:	55                   	push   %ebp
  8026ad:	89 e5                	mov    %esp,%ebp
  8026af:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8026b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8026ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026bd:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8026c2:	b8 03 00 00 00       	mov    $0x3,%eax
  8026c7:	e8 34 ff ff ff       	call   802600 <nsipc>
}
  8026cc:	c9                   	leave  
  8026cd:	c3                   	ret    

008026ce <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8026ce:	55                   	push   %ebp
  8026cf:	89 e5                	mov    %esp,%ebp
  8026d1:	53                   	push   %ebx
  8026d2:	83 ec 14             	sub    $0x14,%esp
  8026d5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8026d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026db:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8026e0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8026e6:	7e 24                	jle    80270c <nsipc_send+0x3e>
  8026e8:	c7 44 24 0c 80 36 80 	movl   $0x803680,0xc(%esp)
  8026ef:	00 
  8026f0:	c7 44 24 08 c9 35 80 	movl   $0x8035c9,0x8(%esp)
  8026f7:	00 
  8026f8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8026ff:	00 
  802700:	c7 04 24 8c 36 80 00 	movl   $0x80368c,(%esp)
  802707:	e8 3c dd ff ff       	call   800448 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80270c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802710:	8b 45 0c             	mov    0xc(%ebp),%eax
  802713:	89 44 24 04          	mov    %eax,0x4(%esp)
  802717:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80271e:	e8 82 e6 ff ff       	call   800da5 <memmove>
	nsipcbuf.send.req_size = size;
  802723:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802729:	8b 45 14             	mov    0x14(%ebp),%eax
  80272c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802731:	b8 08 00 00 00       	mov    $0x8,%eax
  802736:	e8 c5 fe ff ff       	call   802600 <nsipc>
}
  80273b:	83 c4 14             	add    $0x14,%esp
  80273e:	5b                   	pop    %ebx
  80273f:	5d                   	pop    %ebp
  802740:	c3                   	ret    

00802741 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802741:	55                   	push   %ebp
  802742:	89 e5                	mov    %esp,%ebp
  802744:	56                   	push   %esi
  802745:	53                   	push   %ebx
  802746:	83 ec 10             	sub    $0x10,%esp
  802749:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80274c:	8b 45 08             	mov    0x8(%ebp),%eax
  80274f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802754:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80275a:	8b 45 14             	mov    0x14(%ebp),%eax
  80275d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802762:	b8 07 00 00 00       	mov    $0x7,%eax
  802767:	e8 94 fe ff ff       	call   802600 <nsipc>
  80276c:	89 c3                	mov    %eax,%ebx
  80276e:	85 c0                	test   %eax,%eax
  802770:	78 46                	js     8027b8 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802772:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802777:	7f 04                	jg     80277d <nsipc_recv+0x3c>
  802779:	39 c6                	cmp    %eax,%esi
  80277b:	7d 24                	jge    8027a1 <nsipc_recv+0x60>
  80277d:	c7 44 24 0c 98 36 80 	movl   $0x803698,0xc(%esp)
  802784:	00 
  802785:	c7 44 24 08 c9 35 80 	movl   $0x8035c9,0x8(%esp)
  80278c:	00 
  80278d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802794:	00 
  802795:	c7 04 24 8c 36 80 00 	movl   $0x80368c,(%esp)
  80279c:	e8 a7 dc ff ff       	call   800448 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8027a1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027a5:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8027ac:	00 
  8027ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027b0:	89 04 24             	mov    %eax,(%esp)
  8027b3:	e8 ed e5 ff ff       	call   800da5 <memmove>
	}

	return r;
}
  8027b8:	89 d8                	mov    %ebx,%eax
  8027ba:	83 c4 10             	add    $0x10,%esp
  8027bd:	5b                   	pop    %ebx
  8027be:	5e                   	pop    %esi
  8027bf:	5d                   	pop    %ebp
  8027c0:	c3                   	ret    

008027c1 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8027c1:	55                   	push   %ebp
  8027c2:	89 e5                	mov    %esp,%ebp
  8027c4:	53                   	push   %ebx
  8027c5:	83 ec 14             	sub    $0x14,%esp
  8027c8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8027cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ce:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8027d3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027da:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027de:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8027e5:	e8 bb e5 ff ff       	call   800da5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8027ea:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8027f0:	b8 05 00 00 00       	mov    $0x5,%eax
  8027f5:	e8 06 fe ff ff       	call   802600 <nsipc>
}
  8027fa:	83 c4 14             	add    $0x14,%esp
  8027fd:	5b                   	pop    %ebx
  8027fe:	5d                   	pop    %ebp
  8027ff:	c3                   	ret    

00802800 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802800:	55                   	push   %ebp
  802801:	89 e5                	mov    %esp,%ebp
  802803:	53                   	push   %ebx
  802804:	83 ec 14             	sub    $0x14,%esp
  802807:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80280a:	8b 45 08             	mov    0x8(%ebp),%eax
  80280d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802812:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802816:	8b 45 0c             	mov    0xc(%ebp),%eax
  802819:	89 44 24 04          	mov    %eax,0x4(%esp)
  80281d:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802824:	e8 7c e5 ff ff       	call   800da5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802829:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80282f:	b8 02 00 00 00       	mov    $0x2,%eax
  802834:	e8 c7 fd ff ff       	call   802600 <nsipc>
}
  802839:	83 c4 14             	add    $0x14,%esp
  80283c:	5b                   	pop    %ebx
  80283d:	5d                   	pop    %ebp
  80283e:	c3                   	ret    

0080283f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80283f:	55                   	push   %ebp
  802840:	89 e5                	mov    %esp,%ebp
  802842:	83 ec 18             	sub    $0x18,%esp
  802845:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802848:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80284b:	8b 45 08             	mov    0x8(%ebp),%eax
  80284e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802853:	b8 01 00 00 00       	mov    $0x1,%eax
  802858:	e8 a3 fd ff ff       	call   802600 <nsipc>
  80285d:	89 c3                	mov    %eax,%ebx
  80285f:	85 c0                	test   %eax,%eax
  802861:	78 25                	js     802888 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802863:	be 10 60 80 00       	mov    $0x806010,%esi
  802868:	8b 06                	mov    (%esi),%eax
  80286a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80286e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802875:	00 
  802876:	8b 45 0c             	mov    0xc(%ebp),%eax
  802879:	89 04 24             	mov    %eax,(%esp)
  80287c:	e8 24 e5 ff ff       	call   800da5 <memmove>
		*addrlen = ret->ret_addrlen;
  802881:	8b 16                	mov    (%esi),%edx
  802883:	8b 45 10             	mov    0x10(%ebp),%eax
  802886:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802888:	89 d8                	mov    %ebx,%eax
  80288a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80288d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802890:	89 ec                	mov    %ebp,%esp
  802892:	5d                   	pop    %ebp
  802893:	c3                   	ret    
	...

008028a0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8028a0:	55                   	push   %ebp
  8028a1:	89 e5                	mov    %esp,%ebp
  8028a3:	83 ec 18             	sub    $0x18,%esp
  8028a6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8028a9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8028ac:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8028af:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b2:	89 04 24             	mov    %eax,(%esp)
  8028b5:	e8 c6 eb ff ff       	call   801480 <fd2data>
  8028ba:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8028bc:	c7 44 24 04 ad 36 80 	movl   $0x8036ad,0x4(%esp)
  8028c3:	00 
  8028c4:	89 34 24             	mov    %esi,(%esp)
  8028c7:	e8 1e e3 ff ff       	call   800bea <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8028cc:	8b 43 04             	mov    0x4(%ebx),%eax
  8028cf:	2b 03                	sub    (%ebx),%eax
  8028d1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8028d7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8028de:	00 00 00 
	stat->st_dev = &devpipe;
  8028e1:	c7 86 88 00 00 00 c8 	movl   $0x8087c8,0x88(%esi)
  8028e8:	87 80 00 
	return 0;
}
  8028eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8028f0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8028f3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8028f6:	89 ec                	mov    %ebp,%esp
  8028f8:	5d                   	pop    %ebp
  8028f9:	c3                   	ret    

008028fa <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8028fa:	55                   	push   %ebp
  8028fb:	89 e5                	mov    %esp,%ebp
  8028fd:	53                   	push   %ebx
  8028fe:	83 ec 14             	sub    $0x14,%esp
  802901:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802904:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802908:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80290f:	e8 76 e9 ff ff       	call   80128a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802914:	89 1c 24             	mov    %ebx,(%esp)
  802917:	e8 64 eb ff ff       	call   801480 <fd2data>
  80291c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802920:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802927:	e8 5e e9 ff ff       	call   80128a <sys_page_unmap>
}
  80292c:	83 c4 14             	add    $0x14,%esp
  80292f:	5b                   	pop    %ebx
  802930:	5d                   	pop    %ebp
  802931:	c3                   	ret    

00802932 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802932:	55                   	push   %ebp
  802933:	89 e5                	mov    %esp,%ebp
  802935:	57                   	push   %edi
  802936:	56                   	push   %esi
  802937:	53                   	push   %ebx
  802938:	83 ec 2c             	sub    $0x2c,%esp
  80293b:	89 c7                	mov    %eax,%edi
  80293d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802940:	a1 70 9f 80 00       	mov    0x809f70,%eax
  802945:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802948:	89 3c 24             	mov    %edi,(%esp)
  80294b:	e8 58 04 00 00       	call   802da8 <pageref>
  802950:	89 c6                	mov    %eax,%esi
  802952:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802955:	89 04 24             	mov    %eax,(%esp)
  802958:	e8 4b 04 00 00       	call   802da8 <pageref>
  80295d:	39 c6                	cmp    %eax,%esi
  80295f:	0f 94 c0             	sete   %al
  802962:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802965:	8b 15 70 9f 80 00    	mov    0x809f70,%edx
  80296b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80296e:	39 cb                	cmp    %ecx,%ebx
  802970:	75 08                	jne    80297a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802972:	83 c4 2c             	add    $0x2c,%esp
  802975:	5b                   	pop    %ebx
  802976:	5e                   	pop    %esi
  802977:	5f                   	pop    %edi
  802978:	5d                   	pop    %ebp
  802979:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80297a:	83 f8 01             	cmp    $0x1,%eax
  80297d:	75 c1                	jne    802940 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80297f:	8b 52 58             	mov    0x58(%edx),%edx
  802982:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802986:	89 54 24 08          	mov    %edx,0x8(%esp)
  80298a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80298e:	c7 04 24 b4 36 80 00 	movl   $0x8036b4,(%esp)
  802995:	e8 73 db ff ff       	call   80050d <cprintf>
  80299a:	eb a4                	jmp    802940 <_pipeisclosed+0xe>

0080299c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80299c:	55                   	push   %ebp
  80299d:	89 e5                	mov    %esp,%ebp
  80299f:	57                   	push   %edi
  8029a0:	56                   	push   %esi
  8029a1:	53                   	push   %ebx
  8029a2:	83 ec 1c             	sub    $0x1c,%esp
  8029a5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8029a8:	89 34 24             	mov    %esi,(%esp)
  8029ab:	e8 d0 ea ff ff       	call   801480 <fd2data>
  8029b0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8029b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8029b7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8029bb:	75 54                	jne    802a11 <devpipe_write+0x75>
  8029bd:	eb 60                	jmp    802a1f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8029bf:	89 da                	mov    %ebx,%edx
  8029c1:	89 f0                	mov    %esi,%eax
  8029c3:	e8 6a ff ff ff       	call   802932 <_pipeisclosed>
  8029c8:	85 c0                	test   %eax,%eax
  8029ca:	74 07                	je     8029d3 <devpipe_write+0x37>
  8029cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8029d1:	eb 53                	jmp    802a26 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8029d3:	90                   	nop
  8029d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8029d8:	e8 c8 e9 ff ff       	call   8013a5 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8029dd:	8b 43 04             	mov    0x4(%ebx),%eax
  8029e0:	8b 13                	mov    (%ebx),%edx
  8029e2:	83 c2 20             	add    $0x20,%edx
  8029e5:	39 d0                	cmp    %edx,%eax
  8029e7:	73 d6                	jae    8029bf <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8029e9:	89 c2                	mov    %eax,%edx
  8029eb:	c1 fa 1f             	sar    $0x1f,%edx
  8029ee:	c1 ea 1b             	shr    $0x1b,%edx
  8029f1:	01 d0                	add    %edx,%eax
  8029f3:	83 e0 1f             	and    $0x1f,%eax
  8029f6:	29 d0                	sub    %edx,%eax
  8029f8:	89 c2                	mov    %eax,%edx
  8029fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8029fd:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802a01:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802a05:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a09:	83 c7 01             	add    $0x1,%edi
  802a0c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  802a0f:	76 13                	jbe    802a24 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802a11:	8b 43 04             	mov    0x4(%ebx),%eax
  802a14:	8b 13                	mov    (%ebx),%edx
  802a16:	83 c2 20             	add    $0x20,%edx
  802a19:	39 d0                	cmp    %edx,%eax
  802a1b:	73 a2                	jae    8029bf <devpipe_write+0x23>
  802a1d:	eb ca                	jmp    8029e9 <devpipe_write+0x4d>
  802a1f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802a24:	89 f8                	mov    %edi,%eax
}
  802a26:	83 c4 1c             	add    $0x1c,%esp
  802a29:	5b                   	pop    %ebx
  802a2a:	5e                   	pop    %esi
  802a2b:	5f                   	pop    %edi
  802a2c:	5d                   	pop    %ebp
  802a2d:	c3                   	ret    

00802a2e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a2e:	55                   	push   %ebp
  802a2f:	89 e5                	mov    %esp,%ebp
  802a31:	83 ec 28             	sub    $0x28,%esp
  802a34:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802a37:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802a3a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802a3d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802a40:	89 3c 24             	mov    %edi,(%esp)
  802a43:	e8 38 ea ff ff       	call   801480 <fd2data>
  802a48:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a4a:	be 00 00 00 00       	mov    $0x0,%esi
  802a4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a53:	75 4c                	jne    802aa1 <devpipe_read+0x73>
  802a55:	eb 5b                	jmp    802ab2 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802a57:	89 f0                	mov    %esi,%eax
  802a59:	eb 5e                	jmp    802ab9 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802a5b:	89 da                	mov    %ebx,%edx
  802a5d:	89 f8                	mov    %edi,%eax
  802a5f:	90                   	nop
  802a60:	e8 cd fe ff ff       	call   802932 <_pipeisclosed>
  802a65:	85 c0                	test   %eax,%eax
  802a67:	74 07                	je     802a70 <devpipe_read+0x42>
  802a69:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6e:	eb 49                	jmp    802ab9 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802a70:	e8 30 e9 ff ff       	call   8013a5 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802a75:	8b 03                	mov    (%ebx),%eax
  802a77:	3b 43 04             	cmp    0x4(%ebx),%eax
  802a7a:	74 df                	je     802a5b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802a7c:	89 c2                	mov    %eax,%edx
  802a7e:	c1 fa 1f             	sar    $0x1f,%edx
  802a81:	c1 ea 1b             	shr    $0x1b,%edx
  802a84:	01 d0                	add    %edx,%eax
  802a86:	83 e0 1f             	and    $0x1f,%eax
  802a89:	29 d0                	sub    %edx,%eax
  802a8b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802a90:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a93:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802a96:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a99:	83 c6 01             	add    $0x1,%esi
  802a9c:	39 75 10             	cmp    %esi,0x10(%ebp)
  802a9f:	76 16                	jbe    802ab7 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802aa1:	8b 03                	mov    (%ebx),%eax
  802aa3:	3b 43 04             	cmp    0x4(%ebx),%eax
  802aa6:	75 d4                	jne    802a7c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802aa8:	85 f6                	test   %esi,%esi
  802aaa:	75 ab                	jne    802a57 <devpipe_read+0x29>
  802aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ab0:	eb a9                	jmp    802a5b <devpipe_read+0x2d>
  802ab2:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802ab7:	89 f0                	mov    %esi,%eax
}
  802ab9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802abc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802abf:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802ac2:	89 ec                	mov    %ebp,%esp
  802ac4:	5d                   	pop    %ebp
  802ac5:	c3                   	ret    

00802ac6 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802ac6:	55                   	push   %ebp
  802ac7:	89 e5                	mov    %esp,%ebp
  802ac9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802acc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802acf:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad6:	89 04 24             	mov    %eax,(%esp)
  802ad9:	e8 2f ea ff ff       	call   80150d <fd_lookup>
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	78 15                	js     802af7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae5:	89 04 24             	mov    %eax,(%esp)
  802ae8:	e8 93 e9 ff ff       	call   801480 <fd2data>
	return _pipeisclosed(fd, p);
  802aed:	89 c2                	mov    %eax,%edx
  802aef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af2:	e8 3b fe ff ff       	call   802932 <_pipeisclosed>
}
  802af7:	c9                   	leave  
  802af8:	c3                   	ret    

00802af9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802af9:	55                   	push   %ebp
  802afa:	89 e5                	mov    %esp,%ebp
  802afc:	83 ec 48             	sub    $0x48,%esp
  802aff:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802b02:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802b05:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802b08:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802b0b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802b0e:	89 04 24             	mov    %eax,(%esp)
  802b11:	e8 85 e9 ff ff       	call   80149b <fd_alloc>
  802b16:	89 c3                	mov    %eax,%ebx
  802b18:	85 c0                	test   %eax,%eax
  802b1a:	0f 88 42 01 00 00    	js     802c62 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b20:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b27:	00 
  802b28:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b36:	e8 0b e8 ff ff       	call   801346 <sys_page_alloc>
  802b3b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802b3d:	85 c0                	test   %eax,%eax
  802b3f:	0f 88 1d 01 00 00    	js     802c62 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802b45:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802b48:	89 04 24             	mov    %eax,(%esp)
  802b4b:	e8 4b e9 ff ff       	call   80149b <fd_alloc>
  802b50:	89 c3                	mov    %eax,%ebx
  802b52:	85 c0                	test   %eax,%eax
  802b54:	0f 88 f5 00 00 00    	js     802c4f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b5a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b61:	00 
  802b62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802b65:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b69:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b70:	e8 d1 e7 ff ff       	call   801346 <sys_page_alloc>
  802b75:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802b77:	85 c0                	test   %eax,%eax
  802b79:	0f 88 d0 00 00 00    	js     802c4f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802b7f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b82:	89 04 24             	mov    %eax,(%esp)
  802b85:	e8 f6 e8 ff ff       	call   801480 <fd2data>
  802b8a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b8c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b93:	00 
  802b94:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b98:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b9f:	e8 a2 e7 ff ff       	call   801346 <sys_page_alloc>
  802ba4:	89 c3                	mov    %eax,%ebx
  802ba6:	85 c0                	test   %eax,%eax
  802ba8:	0f 88 8e 00 00 00    	js     802c3c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bb1:	89 04 24             	mov    %eax,(%esp)
  802bb4:	e8 c7 e8 ff ff       	call   801480 <fd2data>
  802bb9:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802bc0:	00 
  802bc1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802bc5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802bcc:	00 
  802bcd:	89 74 24 04          	mov    %esi,0x4(%esp)
  802bd1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bd8:	e8 0b e7 ff ff       	call   8012e8 <sys_page_map>
  802bdd:	89 c3                	mov    %eax,%ebx
  802bdf:	85 c0                	test   %eax,%eax
  802be1:	78 49                	js     802c2c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802be3:	b8 c8 87 80 00       	mov    $0x8087c8,%eax
  802be8:	8b 08                	mov    (%eax),%ecx
  802bea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bed:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802bef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802bf2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802bf9:	8b 10                	mov    (%eax),%edx
  802bfb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bfe:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802c00:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c03:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  802c0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c0d:	89 04 24             	mov    %eax,(%esp)
  802c10:	e8 5b e8 ff ff       	call   801470 <fd2num>
  802c15:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802c17:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c1a:	89 04 24             	mov    %eax,(%esp)
  802c1d:	e8 4e e8 ff ff       	call   801470 <fd2num>
  802c22:	89 47 04             	mov    %eax,0x4(%edi)
  802c25:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  802c2a:	eb 36                	jmp    802c62 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802c2c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c37:	e8 4e e6 ff ff       	call   80128a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802c3c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c43:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c4a:	e8 3b e6 ff ff       	call   80128a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802c4f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c52:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c56:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c5d:	e8 28 e6 ff ff       	call   80128a <sys_page_unmap>
    err:
	return r;
}
  802c62:	89 d8                	mov    %ebx,%eax
  802c64:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802c67:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802c6a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802c6d:	89 ec                	mov    %ebp,%esp
  802c6f:	5d                   	pop    %ebp
  802c70:	c3                   	ret    
  802c71:	00 00                	add    %al,(%eax)
	...

00802c74 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802c74:	55                   	push   %ebp
  802c75:	89 e5                	mov    %esp,%ebp
  802c77:	56                   	push   %esi
  802c78:	53                   	push   %ebx
  802c79:	83 ec 10             	sub    $0x10,%esp
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
	volatile struct Env *e;

	assert(envid != 0);
  802c7f:	85 c0                	test   %eax,%eax
  802c81:	75 24                	jne    802ca7 <wait+0x33>
  802c83:	c7 44 24 0c cc 36 80 	movl   $0x8036cc,0xc(%esp)
  802c8a:	00 
  802c8b:	c7 44 24 08 c9 35 80 	movl   $0x8035c9,0x8(%esp)
  802c92:	00 
  802c93:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  802c9a:	00 
  802c9b:	c7 04 24 d7 36 80 00 	movl   $0x8036d7,(%esp)
  802ca2:	e8 a1 d7 ff ff       	call   800448 <_panic>
	e = &envs[ENVX(envid)];
  802ca7:	89 c3                	mov    %eax,%ebx
  802ca9:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  802caf:	6b db 7c             	imul   $0x7c,%ebx,%ebx
  802cb2:	81 c3 00 00 c0 ee    	add    $0xeec00000,%ebx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802cb8:	8b 73 4c             	mov    0x4c(%ebx),%esi
  802cbb:	39 c6                	cmp    %eax,%esi
  802cbd:	75 1a                	jne    802cd9 <wait+0x65>
  802cbf:	8b 43 54             	mov    0x54(%ebx),%eax
  802cc2:	85 c0                	test   %eax,%eax
  802cc4:	74 13                	je     802cd9 <wait+0x65>
		sys_yield();
  802cc6:	e8 da e6 ff ff       	call   8013a5 <sys_yield>
{
	volatile struct Env *e;

	assert(envid != 0);
	e = &envs[ENVX(envid)];
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802ccb:	8b 43 4c             	mov    0x4c(%ebx),%eax
  802cce:	39 f0                	cmp    %esi,%eax
  802cd0:	75 07                	jne    802cd9 <wait+0x65>
  802cd2:	8b 43 54             	mov    0x54(%ebx),%eax
  802cd5:	85 c0                	test   %eax,%eax
  802cd7:	75 ed                	jne    802cc6 <wait+0x52>
		sys_yield();
}
  802cd9:	83 c4 10             	add    $0x10,%esp
  802cdc:	5b                   	pop    %ebx
  802cdd:	5e                   	pop    %esi
  802cde:	5d                   	pop    %ebp
  802cdf:	c3                   	ret    

00802ce0 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802ce0:	55                   	push   %ebp
  802ce1:	89 e5                	mov    %esp,%ebp
  802ce3:	57                   	push   %edi
  802ce4:	56                   	push   %esi
  802ce5:	53                   	push   %ebx
  802ce6:	83 ec 1c             	sub    $0x1c,%esp
  802ce9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802cec:	8b 75 0c             	mov    0xc(%ebp),%esi
  802cef:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  802cf2:	8b 45 14             	mov    0x14(%ebp),%eax
  802cf5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802cf9:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802cfd:	89 74 24 04          	mov    %esi,0x4(%esp)
  802d01:	89 1c 24             	mov    %ebx,(%esp)
  802d04:	e8 2f e4 ff ff       	call   801138 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  802d09:	85 c0                	test   %eax,%eax
  802d0b:	79 21                	jns    802d2e <ipc_send+0x4e>
  802d0d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802d10:	74 1c                	je     802d2e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  802d12:	c7 44 24 08 e2 36 80 	movl   $0x8036e2,0x8(%esp)
  802d19:	00 
  802d1a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  802d21:	00 
  802d22:	c7 04 24 f4 36 80 00 	movl   $0x8036f4,(%esp)
  802d29:	e8 1a d7 ff ff       	call   800448 <_panic>
          else if(r==-E_IPC_NOT_RECV)
  802d2e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802d31:	75 07                	jne    802d3a <ipc_send+0x5a>
           sys_yield();
  802d33:	e8 6d e6 ff ff       	call   8013a5 <sys_yield>
          else
            break;
        }
  802d38:	eb b8                	jmp    802cf2 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  802d3a:	83 c4 1c             	add    $0x1c,%esp
  802d3d:	5b                   	pop    %ebx
  802d3e:	5e                   	pop    %esi
  802d3f:	5f                   	pop    %edi
  802d40:	5d                   	pop    %ebp
  802d41:	c3                   	ret    

00802d42 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802d42:	55                   	push   %ebp
  802d43:	89 e5                	mov    %esp,%ebp
  802d45:	83 ec 18             	sub    $0x18,%esp
  802d48:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802d4b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802d4e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802d51:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  802d54:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d57:	89 04 24             	mov    %eax,(%esp)
  802d5a:	e8 7c e3 ff ff       	call   8010db <sys_ipc_recv>
        if(r<0)
  802d5f:	85 c0                	test   %eax,%eax
  802d61:	79 17                	jns    802d7a <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  802d63:	85 db                	test   %ebx,%ebx
  802d65:	74 06                	je     802d6d <ipc_recv+0x2b>
               *from_env_store =0;
  802d67:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  802d6d:	85 f6                	test   %esi,%esi
  802d6f:	90                   	nop
  802d70:	74 2c                	je     802d9e <ipc_recv+0x5c>
              *perm_store=0;
  802d72:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802d78:	eb 24                	jmp    802d9e <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  802d7a:	85 db                	test   %ebx,%ebx
  802d7c:	74 0a                	je     802d88 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  802d7e:	a1 70 9f 80 00       	mov    0x809f70,%eax
  802d83:	8b 40 74             	mov    0x74(%eax),%eax
  802d86:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  802d88:	85 f6                	test   %esi,%esi
  802d8a:	74 0a                	je     802d96 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  802d8c:	a1 70 9f 80 00       	mov    0x809f70,%eax
  802d91:	8b 40 78             	mov    0x78(%eax),%eax
  802d94:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  802d96:	a1 70 9f 80 00       	mov    0x809f70,%eax
  802d9b:	8b 40 70             	mov    0x70(%eax),%eax
}
  802d9e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802da1:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802da4:	89 ec                	mov    %ebp,%esp
  802da6:	5d                   	pop    %ebp
  802da7:	c3                   	ret    

00802da8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802da8:	55                   	push   %ebp
  802da9:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802dab:	8b 45 08             	mov    0x8(%ebp),%eax
  802dae:	89 c2                	mov    %eax,%edx
  802db0:	c1 ea 16             	shr    $0x16,%edx
  802db3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802dba:	f6 c2 01             	test   $0x1,%dl
  802dbd:	74 26                	je     802de5 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802dbf:	c1 e8 0c             	shr    $0xc,%eax
  802dc2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802dc9:	a8 01                	test   $0x1,%al
  802dcb:	74 18                	je     802de5 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802dcd:	c1 e8 0c             	shr    $0xc,%eax
  802dd0:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802dd3:	c1 e2 02             	shl    $0x2,%edx
  802dd6:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802ddb:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802de0:	0f b7 c0             	movzwl %ax,%eax
  802de3:	eb 05                	jmp    802dea <pageref+0x42>
  802de5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dea:	5d                   	pop    %ebp
  802deb:	c3                   	ret    
  802dec:	00 00                	add    %al,(%eax)
	...

00802df0 <__udivdi3>:
  802df0:	55                   	push   %ebp
  802df1:	89 e5                	mov    %esp,%ebp
  802df3:	57                   	push   %edi
  802df4:	56                   	push   %esi
  802df5:	83 ec 10             	sub    $0x10,%esp
  802df8:	8b 45 14             	mov    0x14(%ebp),%eax
  802dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dfe:	8b 75 10             	mov    0x10(%ebp),%esi
  802e01:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802e04:	85 c0                	test   %eax,%eax
  802e06:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802e09:	75 35                	jne    802e40 <__udivdi3+0x50>
  802e0b:	39 fe                	cmp    %edi,%esi
  802e0d:	77 61                	ja     802e70 <__udivdi3+0x80>
  802e0f:	85 f6                	test   %esi,%esi
  802e11:	75 0b                	jne    802e1e <__udivdi3+0x2e>
  802e13:	b8 01 00 00 00       	mov    $0x1,%eax
  802e18:	31 d2                	xor    %edx,%edx
  802e1a:	f7 f6                	div    %esi
  802e1c:	89 c6                	mov    %eax,%esi
  802e1e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802e21:	31 d2                	xor    %edx,%edx
  802e23:	89 f8                	mov    %edi,%eax
  802e25:	f7 f6                	div    %esi
  802e27:	89 c7                	mov    %eax,%edi
  802e29:	89 c8                	mov    %ecx,%eax
  802e2b:	f7 f6                	div    %esi
  802e2d:	89 c1                	mov    %eax,%ecx
  802e2f:	89 fa                	mov    %edi,%edx
  802e31:	89 c8                	mov    %ecx,%eax
  802e33:	83 c4 10             	add    $0x10,%esp
  802e36:	5e                   	pop    %esi
  802e37:	5f                   	pop    %edi
  802e38:	5d                   	pop    %ebp
  802e39:	c3                   	ret    
  802e3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802e40:	39 f8                	cmp    %edi,%eax
  802e42:	77 1c                	ja     802e60 <__udivdi3+0x70>
  802e44:	0f bd d0             	bsr    %eax,%edx
  802e47:	83 f2 1f             	xor    $0x1f,%edx
  802e4a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e4d:	75 39                	jne    802e88 <__udivdi3+0x98>
  802e4f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802e52:	0f 86 a0 00 00 00    	jbe    802ef8 <__udivdi3+0x108>
  802e58:	39 f8                	cmp    %edi,%eax
  802e5a:	0f 82 98 00 00 00    	jb     802ef8 <__udivdi3+0x108>
  802e60:	31 ff                	xor    %edi,%edi
  802e62:	31 c9                	xor    %ecx,%ecx
  802e64:	89 c8                	mov    %ecx,%eax
  802e66:	89 fa                	mov    %edi,%edx
  802e68:	83 c4 10             	add    $0x10,%esp
  802e6b:	5e                   	pop    %esi
  802e6c:	5f                   	pop    %edi
  802e6d:	5d                   	pop    %ebp
  802e6e:	c3                   	ret    
  802e6f:	90                   	nop
  802e70:	89 d1                	mov    %edx,%ecx
  802e72:	89 fa                	mov    %edi,%edx
  802e74:	89 c8                	mov    %ecx,%eax
  802e76:	31 ff                	xor    %edi,%edi
  802e78:	f7 f6                	div    %esi
  802e7a:	89 c1                	mov    %eax,%ecx
  802e7c:	89 fa                	mov    %edi,%edx
  802e7e:	89 c8                	mov    %ecx,%eax
  802e80:	83 c4 10             	add    $0x10,%esp
  802e83:	5e                   	pop    %esi
  802e84:	5f                   	pop    %edi
  802e85:	5d                   	pop    %ebp
  802e86:	c3                   	ret    
  802e87:	90                   	nop
  802e88:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802e8c:	89 f2                	mov    %esi,%edx
  802e8e:	d3 e0                	shl    %cl,%eax
  802e90:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802e93:	b8 20 00 00 00       	mov    $0x20,%eax
  802e98:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802e9b:	89 c1                	mov    %eax,%ecx
  802e9d:	d3 ea                	shr    %cl,%edx
  802e9f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802ea3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802ea6:	d3 e6                	shl    %cl,%esi
  802ea8:	89 c1                	mov    %eax,%ecx
  802eaa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802ead:	89 fe                	mov    %edi,%esi
  802eaf:	d3 ee                	shr    %cl,%esi
  802eb1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802eb5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802eb8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802ebb:	d3 e7                	shl    %cl,%edi
  802ebd:	89 c1                	mov    %eax,%ecx
  802ebf:	d3 ea                	shr    %cl,%edx
  802ec1:	09 d7                	or     %edx,%edi
  802ec3:	89 f2                	mov    %esi,%edx
  802ec5:	89 f8                	mov    %edi,%eax
  802ec7:	f7 75 ec             	divl   -0x14(%ebp)
  802eca:	89 d6                	mov    %edx,%esi
  802ecc:	89 c7                	mov    %eax,%edi
  802ece:	f7 65 e8             	mull   -0x18(%ebp)
  802ed1:	39 d6                	cmp    %edx,%esi
  802ed3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ed6:	72 30                	jb     802f08 <__udivdi3+0x118>
  802ed8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802edb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802edf:	d3 e2                	shl    %cl,%edx
  802ee1:	39 c2                	cmp    %eax,%edx
  802ee3:	73 05                	jae    802eea <__udivdi3+0xfa>
  802ee5:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802ee8:	74 1e                	je     802f08 <__udivdi3+0x118>
  802eea:	89 f9                	mov    %edi,%ecx
  802eec:	31 ff                	xor    %edi,%edi
  802eee:	e9 71 ff ff ff       	jmp    802e64 <__udivdi3+0x74>
  802ef3:	90                   	nop
  802ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ef8:	31 ff                	xor    %edi,%edi
  802efa:	b9 01 00 00 00       	mov    $0x1,%ecx
  802eff:	e9 60 ff ff ff       	jmp    802e64 <__udivdi3+0x74>
  802f04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802f08:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802f0b:	31 ff                	xor    %edi,%edi
  802f0d:	89 c8                	mov    %ecx,%eax
  802f0f:	89 fa                	mov    %edi,%edx
  802f11:	83 c4 10             	add    $0x10,%esp
  802f14:	5e                   	pop    %esi
  802f15:	5f                   	pop    %edi
  802f16:	5d                   	pop    %ebp
  802f17:	c3                   	ret    
	...

00802f20 <__umoddi3>:
  802f20:	55                   	push   %ebp
  802f21:	89 e5                	mov    %esp,%ebp
  802f23:	57                   	push   %edi
  802f24:	56                   	push   %esi
  802f25:	83 ec 20             	sub    $0x20,%esp
  802f28:	8b 55 14             	mov    0x14(%ebp),%edx
  802f2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802f2e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802f31:	8b 75 0c             	mov    0xc(%ebp),%esi
  802f34:	85 d2                	test   %edx,%edx
  802f36:	89 c8                	mov    %ecx,%eax
  802f38:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802f3b:	75 13                	jne    802f50 <__umoddi3+0x30>
  802f3d:	39 f7                	cmp    %esi,%edi
  802f3f:	76 3f                	jbe    802f80 <__umoddi3+0x60>
  802f41:	89 f2                	mov    %esi,%edx
  802f43:	f7 f7                	div    %edi
  802f45:	89 d0                	mov    %edx,%eax
  802f47:	31 d2                	xor    %edx,%edx
  802f49:	83 c4 20             	add    $0x20,%esp
  802f4c:	5e                   	pop    %esi
  802f4d:	5f                   	pop    %edi
  802f4e:	5d                   	pop    %ebp
  802f4f:	c3                   	ret    
  802f50:	39 f2                	cmp    %esi,%edx
  802f52:	77 4c                	ja     802fa0 <__umoddi3+0x80>
  802f54:	0f bd ca             	bsr    %edx,%ecx
  802f57:	83 f1 1f             	xor    $0x1f,%ecx
  802f5a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802f5d:	75 51                	jne    802fb0 <__umoddi3+0x90>
  802f5f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802f62:	0f 87 e0 00 00 00    	ja     803048 <__umoddi3+0x128>
  802f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6b:	29 f8                	sub    %edi,%eax
  802f6d:	19 d6                	sbb    %edx,%esi
  802f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f75:	89 f2                	mov    %esi,%edx
  802f77:	83 c4 20             	add    $0x20,%esp
  802f7a:	5e                   	pop    %esi
  802f7b:	5f                   	pop    %edi
  802f7c:	5d                   	pop    %ebp
  802f7d:	c3                   	ret    
  802f7e:	66 90                	xchg   %ax,%ax
  802f80:	85 ff                	test   %edi,%edi
  802f82:	75 0b                	jne    802f8f <__umoddi3+0x6f>
  802f84:	b8 01 00 00 00       	mov    $0x1,%eax
  802f89:	31 d2                	xor    %edx,%edx
  802f8b:	f7 f7                	div    %edi
  802f8d:	89 c7                	mov    %eax,%edi
  802f8f:	89 f0                	mov    %esi,%eax
  802f91:	31 d2                	xor    %edx,%edx
  802f93:	f7 f7                	div    %edi
  802f95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f98:	f7 f7                	div    %edi
  802f9a:	eb a9                	jmp    802f45 <__umoddi3+0x25>
  802f9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802fa0:	89 c8                	mov    %ecx,%eax
  802fa2:	89 f2                	mov    %esi,%edx
  802fa4:	83 c4 20             	add    $0x20,%esp
  802fa7:	5e                   	pop    %esi
  802fa8:	5f                   	pop    %edi
  802fa9:	5d                   	pop    %ebp
  802faa:	c3                   	ret    
  802fab:	90                   	nop
  802fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802fb0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802fb4:	d3 e2                	shl    %cl,%edx
  802fb6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802fb9:	ba 20 00 00 00       	mov    $0x20,%edx
  802fbe:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802fc1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802fc4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802fc8:	89 fa                	mov    %edi,%edx
  802fca:	d3 ea                	shr    %cl,%edx
  802fcc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802fd0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802fd3:	d3 e7                	shl    %cl,%edi
  802fd5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802fd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802fdc:	89 f2                	mov    %esi,%edx
  802fde:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802fe1:	89 c7                	mov    %eax,%edi
  802fe3:	d3 ea                	shr    %cl,%edx
  802fe5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802fe9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802fec:	89 c2                	mov    %eax,%edx
  802fee:	d3 e6                	shl    %cl,%esi
  802ff0:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ff4:	d3 ea                	shr    %cl,%edx
  802ff6:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ffa:	09 d6                	or     %edx,%esi
  802ffc:	89 f0                	mov    %esi,%eax
  802ffe:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  803001:	d3 e7                	shl    %cl,%edi
  803003:	89 f2                	mov    %esi,%edx
  803005:	f7 75 f4             	divl   -0xc(%ebp)
  803008:	89 d6                	mov    %edx,%esi
  80300a:	f7 65 e8             	mull   -0x18(%ebp)
  80300d:	39 d6                	cmp    %edx,%esi
  80300f:	72 2b                	jb     80303c <__umoddi3+0x11c>
  803011:	39 c7                	cmp    %eax,%edi
  803013:	72 23                	jb     803038 <__umoddi3+0x118>
  803015:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803019:	29 c7                	sub    %eax,%edi
  80301b:	19 d6                	sbb    %edx,%esi
  80301d:	89 f0                	mov    %esi,%eax
  80301f:	89 f2                	mov    %esi,%edx
  803021:	d3 ef                	shr    %cl,%edi
  803023:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803027:	d3 e0                	shl    %cl,%eax
  803029:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80302d:	09 f8                	or     %edi,%eax
  80302f:	d3 ea                	shr    %cl,%edx
  803031:	83 c4 20             	add    $0x20,%esp
  803034:	5e                   	pop    %esi
  803035:	5f                   	pop    %edi
  803036:	5d                   	pop    %ebp
  803037:	c3                   	ret    
  803038:	39 d6                	cmp    %edx,%esi
  80303a:	75 d9                	jne    803015 <__umoddi3+0xf5>
  80303c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80303f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  803042:	eb d1                	jmp    803015 <__umoddi3+0xf5>
  803044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803048:	39 f2                	cmp    %esi,%edx
  80304a:	0f 82 18 ff ff ff    	jb     802f68 <__umoddi3+0x48>
  803050:	e9 1d ff ff ff       	jmp    802f72 <__umoddi3+0x52>
