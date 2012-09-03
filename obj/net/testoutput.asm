
obj/net/testoutput:     file format elf32-i386


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
  80002c:	e8 cf 02 00 00       	call   800300 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <umain>:
static struct jif_pkt *pkt = (struct jif_pkt*)REQVA;


void
umain(void)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	56                   	push   %esi
  800044:	53                   	push   %ebx
  800045:	83 ec 10             	sub    $0x10,%esp
	envid_t ns_envid = sys_getenvid();
  800048:	e8 ac 12 00 00       	call   8012f9 <sys_getenvid>
  80004d:	89 c6                	mov    %eax,%esi
	int i, r;

	binaryname = "testoutput";
  80004f:	c7 05 00 70 80 00 e0 	movl   $0x802ee0,0x807000
  800056:	2e 80 00 

	output_envid = fork();
  800059:	e8 89 14 00 00       	call   8014e7 <fork>
  80005e:	a3 74 70 80 00       	mov    %eax,0x807074
	if (output_envid < 0)
  800063:	85 c0                	test   %eax,%eax
  800065:	79 1c                	jns    800083 <umain+0x43>
		panic("error forking");
  800067:	c7 44 24 08 eb 2e 80 	movl   $0x802eeb,0x8(%esp)
  80006e:	00 
  80006f:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
  800076:	00 
  800077:	c7 04 24 f9 2e 80 00 	movl   $0x802ef9,(%esp)
  80007e:	e8 e9 02 00 00       	call   80036c <_panic>
	else if (output_envid == 0) {
		output(ns_envid);
		return;
  800083:	bb 00 00 00 00       	mov    $0x0,%ebx
	binaryname = "testoutput";

	output_envid = fork();
	if (output_envid < 0)
		panic("error forking");
	else if (output_envid == 0) {
  800088:	85 c0                	test   %eax,%eax
  80008a:	75 0d                	jne    800099 <umain+0x59>
		output(ns_envid);
  80008c:	89 34 24             	mov    %esi,(%esp)
  80008f:	e8 28 02 00 00       	call   8002bc <output>
		return;
  800094:	e9 c9 00 00 00       	jmp    800162 <umain+0x122>
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
		if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800099:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8000a0:	00 
  8000a1:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  8000a8:	0f 
  8000a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000b0:	e8 b1 11 00 00       	call   801266 <sys_page_alloc>
  8000b5:	85 c0                	test   %eax,%eax
  8000b7:	79 20                	jns    8000d9 <umain+0x99>
			panic("sys_page_alloc: %e", r);
  8000b9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8000bd:	c7 44 24 08 0a 2f 80 	movl   $0x802f0a,0x8(%esp)
  8000c4:	00 
  8000c5:	c7 44 24 04 1e 00 00 	movl   $0x1e,0x4(%esp)
  8000cc:	00 
  8000cd:	c7 04 24 f9 2e 80 00 	movl   $0x802ef9,(%esp)
  8000d4:	e8 93 02 00 00       	call   80036c <_panic>
		pkt->jp_len = snprintf(pkt->jp_data,
  8000d9:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8000dd:	c7 44 24 08 1d 2f 80 	movl   $0x802f1d,0x8(%esp)
  8000e4:	00 
  8000e5:	c7 44 24 04 fc 0f 00 	movl   $0xffc,0x4(%esp)
  8000ec:	00 
  8000ed:	c7 04 24 04 b0 fe 0f 	movl   $0xffeb004,(%esp)
  8000f4:	e8 70 09 00 00       	call   800a69 <snprintf>
  8000f9:	a3 00 b0 fe 0f       	mov    %eax,0xffeb000
				       PGSIZE - sizeof(pkt->jp_len),
				       "Packet %02d", i);
		cprintf("Transmitting packet %d\n", i);
  8000fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800102:	c7 04 24 29 2f 80 00 	movl   $0x802f29,(%esp)
  800109:	e8 23 03 00 00       	call   800431 <cprintf>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  80010e:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800115:	00 
  800116:	c7 44 24 08 00 b0 fe 	movl   $0xffeb000,0x8(%esp)
  80011d:	0f 
  80011e:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  800125:	00 
  800126:	a1 74 70 80 00       	mov    0x807074,%eax
  80012b:	89 04 24             	mov    %eax,(%esp)
  80012e:	e8 ed 15 00 00       	call   801720 <ipc_send>
		sys_page_unmap(0, pkt);
  800133:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  80013a:	0f 
  80013b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800142:	e8 63 10 00 00       	call   8011aa <sys_page_unmap>
	else if (output_envid == 0) {
		output(ns_envid);
		return;
	}

	for (i = 0; i < TESTOUTPUT_COUNT; i++) {
  800147:	83 c3 01             	add    $0x1,%ebx
  80014a:	83 fb 0a             	cmp    $0xa,%ebx
  80014d:	0f 85 46 ff ff ff    	jne    800099 <umain+0x59>
  800153:	b3 00                	mov    $0x0,%bl
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
		sys_yield();
  800155:	e8 6b 11 00 00       	call   8012c5 <sys_yield>
		ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
		sys_page_unmap(0, pkt);
	}

	// Spin for a while, just in case IPC's or packets need to be flushed
	for (i = 0; i < TESTOUTPUT_COUNT*2; i++)
  80015a:	83 c3 01             	add    $0x1,%ebx
  80015d:	83 fb 14             	cmp    $0x14,%ebx
  800160:	75 f3                	jne    800155 <umain+0x115>
		sys_yield();
}
  800162:	83 c4 10             	add    $0x10,%esp
  800165:	5b                   	pop    %ebx
  800166:	5e                   	pop    %esi
  800167:	5d                   	pop    %ebp
  800168:	c3                   	ret    
  800169:	00 00                	add    %al,(%eax)
  80016b:	00 00                	add    %al,(%eax)
  80016d:	00 00                	add    %al,(%eax)
	...

00800170 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800170:	55                   	push   %ebp
  800171:	89 e5                	mov    %esp,%ebp
  800173:	57                   	push   %edi
  800174:	56                   	push   %esi
  800175:	53                   	push   %ebx
  800176:	83 ec 2c             	sub    $0x2c,%esp
  800179:	8b 75 08             	mov    0x8(%ebp),%esi
	uint32_t stop = sys_time_msec() + initial_to;
  80017c:	e8 46 0e 00 00       	call   800fc7 <sys_time_msec>
  800181:	89 c3                	mov    %eax,%ebx
  800183:	03 5d 0c             	add    0xc(%ebp),%ebx

	binaryname = "ns_timer";
  800186:	c7 05 00 70 80 00 41 	movl   $0x802f41,0x807000
  80018d:	2f 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800190:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800193:	eb 05                	jmp    80019a <timer+0x2a>

	binaryname = "ns_timer";

	while (1) {
		while(sys_time_msec() < stop) {
			sys_yield();
  800195:	e8 2b 11 00 00       	call   8012c5 <sys_yield>
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while(sys_time_msec() < stop) {
  80019a:	e8 28 0e 00 00       	call   800fc7 <sys_time_msec>
  80019f:	39 c3                	cmp    %eax,%ebx
  8001a1:	77 f2                	ja     800195 <timer+0x25>
			sys_yield();
		}

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  8001a3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8001aa:	00 
  8001ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001b2:	00 
  8001b3:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  8001ba:	00 
  8001bb:	89 34 24             	mov    %esi,(%esp)
  8001be:	e8 5d 15 00 00       	call   801720 <ipc_send>

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8001c3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8001ca:	00 
  8001cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8001d2:	00 
  8001d3:	89 3c 24             	mov    %edi,(%esp)
  8001d6:	e8 a7 15 00 00       	call   801782 <ipc_recv>
  8001db:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  8001dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001e0:	39 c6                	cmp    %eax,%esi
  8001e2:	74 12                	je     8001f6 <timer+0x86>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8001e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001e8:	c7 04 24 4c 2f 80 00 	movl   $0x802f4c,(%esp)
  8001ef:	e8 3d 02 00 00       	call   800431 <cprintf>
				continue;
			}

			stop = sys_time_msec() + to;
			break;
		}
  8001f4:	eb cd                	jmp    8001c3 <timer+0x53>
			if (whom != ns_envid) {
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  8001f6:	e8 cc 0d 00 00       	call   800fc7 <sys_time_msec>
  8001fb:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
  8001fe:	66 90                	xchg   %ax,%ax
  800200:	eb 98                	jmp    80019a <timer+0x2a>
	...

00800204 <input>:
extern union Nsipc nsipcbuf;
uint32_t len=0;

void
input(envid_t ns_envid)
{
  800204:	55                   	push   %ebp
  800205:	89 e5                	mov    %esp,%ebp
  800207:	53                   	push   %ebx
  800208:	83 ec 14             	sub    $0x14,%esp
  80020b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	binaryname = "ns_input";
  80020e:	c7 05 00 70 80 00 87 	movl   $0x802f87,0x807000
  800215:	2f 80 00 
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
           
   while(1)
   {
     if(sys_page_alloc(sys_getenvid(),&nsipcbuf,PTE_W|PTE_U|PTE_P)< 0 )
  800218:	e8 dc 10 00 00       	call   8012f9 <sys_getenvid>
  80021d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800224:	00 
  800225:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80022c:	00 
  80022d:	89 04 24             	mov    %eax,(%esp)
  800230:	e8 31 10 00 00       	call   801266 <sys_page_alloc>
  800235:	85 c0                	test   %eax,%eax
  800237:	79 1c                	jns    800255 <input+0x51>
        panic("\nout of pages\n");
  800239:	c7 44 24 08 90 2f 80 	movl   $0x802f90,0x8(%esp)
  800240:	00 
  800241:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  800248:	00 
  800249:	c7 04 24 9f 2f 80 00 	movl   $0x802f9f,(%esp)
  800250:	e8 17 01 00 00       	call   80036c <_panic>
      
       //cprintf("len--->%x",&len);
    	if(sys_call_receive_packet(nsipcbuf.pkt.jp_data,&nsipcbuf.pkt.jp_len)>=0)
  800255:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80025c:	00 
  80025d:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  800264:	e8 ca 0c 00 00       	call   800f33 <sys_call_receive_packet>
  800269:	85 c0                	test   %eax,%eax
  80026b:	78 36                	js     8002a3 <input+0x9f>
	{
        	 //cprintf("\nHere inside input.c -ve\n"); 
		cprintf("\nInside else---->>>>>>\n");
  80026d:	c7 04 24 ab 2f 80 00 	movl   $0x802fab,(%esp)
  800274:	e8 b8 01 00 00       	call   800431 <cprintf>
        	ipc_send(ns_envid,NSREQ_INPUT,&nsipcbuf,PTE_W|PTE_U|PTE_P);
  800279:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800280:	00 
  800281:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  800288:	00 
  800289:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800290:	00 
  800291:	89 1c 24             	mov    %ebx,(%esp)
  800294:	e8 87 14 00 00       	call   801720 <ipc_send>
   		sys_yield();
  800299:	e8 27 10 00 00       	call   8012c5 <sys_yield>
  		sys_yield();
  80029e:	e8 22 10 00 00       	call   8012c5 <sys_yield>
	}

  sys_page_unmap(0,&nsipcbuf);
  8002a3:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8002aa:	00 
  8002ab:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002b2:	e8 f3 0e 00 00       	call   8011aa <sys_page_unmap>

}
  8002b7:	e9 5c ff ff ff       	jmp    800218 <input+0x14>

008002bc <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  8002bc:	55                   	push   %ebp
  8002bd:	89 e5                	mov    %esp,%ebp
  8002bf:	83 ec 18             	sub    $0x18,%esp
	binaryname = "ns_output";
  8002c2:	c7 05 00 70 80 00 c3 	movl   $0x802fc3,0x807000
  8002c9:	2f 80 00 
	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
   while(1)
    {
       ipc_recv(NULL,(void *)&nsipcbuf,NULL);
  8002cc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8002d3:	00 
  8002d4:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8002db:	00 
  8002dc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8002e3:	e8 9a 14 00 00       	call   801782 <ipc_recv>
         {
           cprintf("%c",nsipcbuf.pkt.jp_data[i]);
           i++;
         }
*/
       sys_call_packet_send((void *)nsipcbuf.pkt.jp_data,nsipcbuf.pkt.jp_len); 
  8002e8:	a1 00 60 80 00       	mov    0x806000,%eax
  8002ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002f1:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8002f8:	e8 6c 0c 00 00       	call   800f69 <sys_call_packet_send>
  8002fd:	eb cd                	jmp    8002cc <output+0x10>
	...

00800300 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800300:	55                   	push   %ebp
  800301:	89 e5                	mov    %esp,%ebp
  800303:	83 ec 18             	sub    $0x18,%esp
  800306:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800309:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80030c:	8b 75 08             	mov    0x8(%ebp),%esi
  80030f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  800312:	e8 e2 0f 00 00       	call   8012f9 <sys_getenvid>
  800317:	25 ff 03 00 00       	and    $0x3ff,%eax
  80031c:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80031f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800324:	a3 7c 70 80 00       	mov    %eax,0x80707c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800329:	85 f6                	test   %esi,%esi
  80032b:	7e 07                	jle    800334 <libmain+0x34>
		binaryname = argv[0];
  80032d:	8b 03                	mov    (%ebx),%eax
  80032f:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  800334:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800338:	89 34 24             	mov    %esi,(%esp)
  80033b:	e8 00 fd ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800340:	e8 0b 00 00 00       	call   800350 <exit>
}
  800345:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800348:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80034b:	89 ec                	mov    %ebp,%esp
  80034d:	5d                   	pop    %ebp
  80034e:	c3                   	ret    
	...

00800350 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800350:	55                   	push   %ebp
  800351:	89 e5                	mov    %esp,%ebp
  800353:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800356:	e8 70 19 00 00       	call   801ccb <close_all>
	sys_env_destroy(0);
  80035b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800362:	e8 c6 0f 00 00       	call   80132d <sys_env_destroy>
}
  800367:	c9                   	leave  
  800368:	c3                   	ret    
  800369:	00 00                	add    %al,(%eax)
	...

0080036c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	53                   	push   %ebx
  800370:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  800373:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800376:	a1 80 70 80 00       	mov    0x807080,%eax
  80037b:	85 c0                	test   %eax,%eax
  80037d:	74 10                	je     80038f <_panic+0x23>
		cprintf("%s: ", argv0);
  80037f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800383:	c7 04 24 e4 2f 80 00 	movl   $0x802fe4,(%esp)
  80038a:	e8 a2 00 00 00       	call   800431 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80038f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800392:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800396:	8b 45 08             	mov    0x8(%ebp),%eax
  800399:	89 44 24 08          	mov    %eax,0x8(%esp)
  80039d:	a1 00 70 80 00       	mov    0x807000,%eax
  8003a2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003a6:	c7 04 24 e9 2f 80 00 	movl   $0x802fe9,(%esp)
  8003ad:	e8 7f 00 00 00       	call   800431 <cprintf>
	vcprintf(fmt, ap);
  8003b2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b9:	89 04 24             	mov    %eax,(%esp)
  8003bc:	e8 0f 00 00 00       	call   8003d0 <vcprintf>
	cprintf("\n");
  8003c1:	c7 04 24 c1 2f 80 00 	movl   $0x802fc1,(%esp)
  8003c8:	e8 64 00 00 00       	call   800431 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8003cd:	cc                   	int3   
  8003ce:	eb fd                	jmp    8003cd <_panic+0x61>

008003d0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8003d0:	55                   	push   %ebp
  8003d1:	89 e5                	mov    %esp,%ebp
  8003d3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8003d9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003e0:	00 00 00 
	b.cnt = 0;
  8003e3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8003ea:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8003ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003f0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003fb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800401:	89 44 24 04          	mov    %eax,0x4(%esp)
  800405:	c7 04 24 4b 04 80 00 	movl   $0x80044b,(%esp)
  80040c:	e8 cc 01 00 00       	call   8005dd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800411:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800417:	89 44 24 04          	mov    %eax,0x4(%esp)
  80041b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800421:	89 04 24             	mov    %eax,(%esp)
  800424:	e8 d7 0a 00 00       	call   800f00 <sys_cputs>

	return b.cnt;
}
  800429:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80042f:	c9                   	leave  
  800430:	c3                   	ret    

00800431 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800431:	55                   	push   %ebp
  800432:	89 e5                	mov    %esp,%ebp
  800434:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800437:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80043a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80043e:	8b 45 08             	mov    0x8(%ebp),%eax
  800441:	89 04 24             	mov    %eax,(%esp)
  800444:	e8 87 ff ff ff       	call   8003d0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800449:	c9                   	leave  
  80044a:	c3                   	ret    

0080044b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80044b:	55                   	push   %ebp
  80044c:	89 e5                	mov    %esp,%ebp
  80044e:	53                   	push   %ebx
  80044f:	83 ec 14             	sub    $0x14,%esp
  800452:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800455:	8b 03                	mov    (%ebx),%eax
  800457:	8b 55 08             	mov    0x8(%ebp),%edx
  80045a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80045e:	83 c0 01             	add    $0x1,%eax
  800461:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800463:	3d ff 00 00 00       	cmp    $0xff,%eax
  800468:	75 19                	jne    800483 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80046a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800471:	00 
  800472:	8d 43 08             	lea    0x8(%ebx),%eax
  800475:	89 04 24             	mov    %eax,(%esp)
  800478:	e8 83 0a 00 00       	call   800f00 <sys_cputs>
		b->idx = 0;
  80047d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800483:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800487:	83 c4 14             	add    $0x14,%esp
  80048a:	5b                   	pop    %ebx
  80048b:	5d                   	pop    %ebp
  80048c:	c3                   	ret    
  80048d:	00 00                	add    %al,(%eax)
	...

00800490 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
  800493:	57                   	push   %edi
  800494:	56                   	push   %esi
  800495:	53                   	push   %ebx
  800496:	83 ec 4c             	sub    $0x4c,%esp
  800499:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80049c:	89 d6                	mov    %edx,%esi
  80049e:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8004aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8004ad:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8004b0:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8004bb:	39 d1                	cmp    %edx,%ecx
  8004bd:	72 15                	jb     8004d4 <printnum+0x44>
  8004bf:	77 07                	ja     8004c8 <printnum+0x38>
  8004c1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004c4:	39 d0                	cmp    %edx,%eax
  8004c6:	76 0c                	jbe    8004d4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8004c8:	83 eb 01             	sub    $0x1,%ebx
  8004cb:	85 db                	test   %ebx,%ebx
  8004cd:	8d 76 00             	lea    0x0(%esi),%esi
  8004d0:	7f 61                	jg     800533 <printnum+0xa3>
  8004d2:	eb 70                	jmp    800544 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004d4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8004d8:	83 eb 01             	sub    $0x1,%ebx
  8004db:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8004df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004e3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8004e7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8004eb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8004ee:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8004f1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8004f4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8004f8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8004ff:	00 
  800500:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800503:	89 04 24             	mov    %eax,(%esp)
  800506:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800509:	89 54 24 04          	mov    %edx,0x4(%esp)
  80050d:	e8 5e 27 00 00       	call   802c70 <__udivdi3>
  800512:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800515:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800518:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80051c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800520:	89 04 24             	mov    %eax,(%esp)
  800523:	89 54 24 04          	mov    %edx,0x4(%esp)
  800527:	89 f2                	mov    %esi,%edx
  800529:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80052c:	e8 5f ff ff ff       	call   800490 <printnum>
  800531:	eb 11                	jmp    800544 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800533:	89 74 24 04          	mov    %esi,0x4(%esp)
  800537:	89 3c 24             	mov    %edi,(%esp)
  80053a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80053d:	83 eb 01             	sub    $0x1,%ebx
  800540:	85 db                	test   %ebx,%ebx
  800542:	7f ef                	jg     800533 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800544:	89 74 24 04          	mov    %esi,0x4(%esp)
  800548:	8b 74 24 04          	mov    0x4(%esp),%esi
  80054c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800553:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80055a:	00 
  80055b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80055e:	89 14 24             	mov    %edx,(%esp)
  800561:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800564:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800568:	e8 33 28 00 00       	call   802da0 <__umoddi3>
  80056d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800571:	0f be 80 05 30 80 00 	movsbl 0x803005(%eax),%eax
  800578:	89 04 24             	mov    %eax,(%esp)
  80057b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80057e:	83 c4 4c             	add    $0x4c,%esp
  800581:	5b                   	pop    %ebx
  800582:	5e                   	pop    %esi
  800583:	5f                   	pop    %edi
  800584:	5d                   	pop    %ebp
  800585:	c3                   	ret    

00800586 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800586:	55                   	push   %ebp
  800587:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800589:	83 fa 01             	cmp    $0x1,%edx
  80058c:	7e 0e                	jle    80059c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80058e:	8b 10                	mov    (%eax),%edx
  800590:	8d 4a 08             	lea    0x8(%edx),%ecx
  800593:	89 08                	mov    %ecx,(%eax)
  800595:	8b 02                	mov    (%edx),%eax
  800597:	8b 52 04             	mov    0x4(%edx),%edx
  80059a:	eb 22                	jmp    8005be <getuint+0x38>
	else if (lflag)
  80059c:	85 d2                	test   %edx,%edx
  80059e:	74 10                	je     8005b0 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8005a0:	8b 10                	mov    (%eax),%edx
  8005a2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005a5:	89 08                	mov    %ecx,(%eax)
  8005a7:	8b 02                	mov    (%edx),%eax
  8005a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ae:	eb 0e                	jmp    8005be <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  8005b0:	8b 10                	mov    (%eax),%edx
  8005b2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8005b5:	89 08                	mov    %ecx,(%eax)
  8005b7:	8b 02                	mov    (%edx),%eax
  8005b9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005be:	5d                   	pop    %ebp
  8005bf:	c3                   	ret    

008005c0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005c0:	55                   	push   %ebp
  8005c1:	89 e5                	mov    %esp,%ebp
  8005c3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005c6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8005ca:	8b 10                	mov    (%eax),%edx
  8005cc:	3b 50 04             	cmp    0x4(%eax),%edx
  8005cf:	73 0a                	jae    8005db <sprintputch+0x1b>
		*b->buf++ = ch;
  8005d1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8005d4:	88 0a                	mov    %cl,(%edx)
  8005d6:	83 c2 01             	add    $0x1,%edx
  8005d9:	89 10                	mov    %edx,(%eax)
}
  8005db:	5d                   	pop    %ebp
  8005dc:	c3                   	ret    

008005dd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8005dd:	55                   	push   %ebp
  8005de:	89 e5                	mov    %esp,%ebp
  8005e0:	57                   	push   %edi
  8005e1:	56                   	push   %esi
  8005e2:	53                   	push   %ebx
  8005e3:	83 ec 5c             	sub    $0x5c,%esp
  8005e6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8005e9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8005ec:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8005ef:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8005f6:	eb 11                	jmp    800609 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8005f8:	85 c0                	test   %eax,%eax
  8005fa:	0f 84 09 04 00 00    	je     800a09 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  800600:	89 74 24 04          	mov    %esi,0x4(%esp)
  800604:	89 04 24             	mov    %eax,(%esp)
  800607:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800609:	0f b6 03             	movzbl (%ebx),%eax
  80060c:	83 c3 01             	add    $0x1,%ebx
  80060f:	83 f8 25             	cmp    $0x25,%eax
  800612:	75 e4                	jne    8005f8 <vprintfmt+0x1b>
  800614:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  800618:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80061f:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800626:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80062d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800632:	eb 06                	jmp    80063a <vprintfmt+0x5d>
  800634:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800638:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80063a:	0f b6 13             	movzbl (%ebx),%edx
  80063d:	0f b6 c2             	movzbl %dl,%eax
  800640:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800643:	8d 43 01             	lea    0x1(%ebx),%eax
  800646:	83 ea 23             	sub    $0x23,%edx
  800649:	80 fa 55             	cmp    $0x55,%dl
  80064c:	0f 87 9a 03 00 00    	ja     8009ec <vprintfmt+0x40f>
  800652:	0f b6 d2             	movzbl %dl,%edx
  800655:	ff 24 95 40 31 80 00 	jmp    *0x803140(,%edx,4)
  80065c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800660:	eb d6                	jmp    800638 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800662:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800665:	83 ea 30             	sub    $0x30,%edx
  800668:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  80066b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80066e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800671:	83 fb 09             	cmp    $0x9,%ebx
  800674:	77 4c                	ja     8006c2 <vprintfmt+0xe5>
  800676:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800679:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80067c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80067f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800682:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800686:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800689:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80068c:	83 fb 09             	cmp    $0x9,%ebx
  80068f:	76 eb                	jbe    80067c <vprintfmt+0x9f>
  800691:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800694:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800697:	eb 29                	jmp    8006c2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800699:	8b 55 14             	mov    0x14(%ebp),%edx
  80069c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80069f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8006a2:	8b 12                	mov    (%edx),%edx
  8006a4:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  8006a7:	eb 19                	jmp    8006c2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8006a9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006ac:	c1 fa 1f             	sar    $0x1f,%edx
  8006af:	f7 d2                	not    %edx
  8006b1:	21 55 e4             	and    %edx,-0x1c(%ebp)
  8006b4:	eb 82                	jmp    800638 <vprintfmt+0x5b>
  8006b6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  8006bd:	e9 76 ff ff ff       	jmp    800638 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8006c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006c6:	0f 89 6c ff ff ff    	jns    800638 <vprintfmt+0x5b>
  8006cc:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8006cf:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8006d2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8006d5:	89 55 cc             	mov    %edx,-0x34(%ebp)
  8006d8:	e9 5b ff ff ff       	jmp    800638 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8006dd:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8006e0:	e9 53 ff ff ff       	jmp    800638 <vprintfmt+0x5b>
  8006e5:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8d 50 04             	lea    0x4(%eax),%edx
  8006ee:	89 55 14             	mov    %edx,0x14(%ebp)
  8006f1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	89 04 24             	mov    %eax,(%esp)
  8006fa:	ff d7                	call   *%edi
  8006fc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8006ff:	e9 05 ff ff ff       	jmp    800609 <vprintfmt+0x2c>
  800704:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	8d 50 04             	lea    0x4(%eax),%edx
  80070d:	89 55 14             	mov    %edx,0x14(%ebp)
  800710:	8b 00                	mov    (%eax),%eax
  800712:	89 c2                	mov    %eax,%edx
  800714:	c1 fa 1f             	sar    $0x1f,%edx
  800717:	31 d0                	xor    %edx,%eax
  800719:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80071b:	83 f8 0f             	cmp    $0xf,%eax
  80071e:	7f 0b                	jg     80072b <vprintfmt+0x14e>
  800720:	8b 14 85 a0 32 80 00 	mov    0x8032a0(,%eax,4),%edx
  800727:	85 d2                	test   %edx,%edx
  800729:	75 20                	jne    80074b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80072b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80072f:	c7 44 24 08 16 30 80 	movl   $0x803016,0x8(%esp)
  800736:	00 
  800737:	89 74 24 04          	mov    %esi,0x4(%esp)
  80073b:	89 3c 24             	mov    %edi,(%esp)
  80073e:	e8 4e 03 00 00       	call   800a91 <printfmt>
  800743:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800746:	e9 be fe ff ff       	jmp    800609 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80074b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80074f:	c7 44 24 08 c1 34 80 	movl   $0x8034c1,0x8(%esp)
  800756:	00 
  800757:	89 74 24 04          	mov    %esi,0x4(%esp)
  80075b:	89 3c 24             	mov    %edi,(%esp)
  80075e:	e8 2e 03 00 00       	call   800a91 <printfmt>
  800763:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800766:	e9 9e fe ff ff       	jmp    800609 <vprintfmt+0x2c>
  80076b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80076e:	89 c3                	mov    %eax,%ebx
  800770:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800776:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800779:	8b 45 14             	mov    0x14(%ebp),%eax
  80077c:	8d 50 04             	lea    0x4(%eax),%edx
  80077f:	89 55 14             	mov    %edx,0x14(%ebp)
  800782:	8b 00                	mov    (%eax),%eax
  800784:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800787:	85 c0                	test   %eax,%eax
  800789:	75 07                	jne    800792 <vprintfmt+0x1b5>
  80078b:	c7 45 c4 1f 30 80 00 	movl   $0x80301f,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800792:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  800796:	7e 06                	jle    80079e <vprintfmt+0x1c1>
  800798:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80079c:	75 13                	jne    8007b1 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80079e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8007a1:	0f be 02             	movsbl (%edx),%eax
  8007a4:	85 c0                	test   %eax,%eax
  8007a6:	0f 85 99 00 00 00    	jne    800845 <vprintfmt+0x268>
  8007ac:	e9 86 00 00 00       	jmp    800837 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8007b5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  8007b8:	89 0c 24             	mov    %ecx,(%esp)
  8007bb:	e8 1b 03 00 00       	call   800adb <strnlen>
  8007c0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  8007c3:	29 c2                	sub    %eax,%edx
  8007c5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8007c8:	85 d2                	test   %edx,%edx
  8007ca:	7e d2                	jle    80079e <vprintfmt+0x1c1>
					putch(padc, putdat);
  8007cc:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  8007d0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8007d3:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  8007d6:	89 d3                	mov    %edx,%ebx
  8007d8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007dc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007df:	89 04 24             	mov    %eax,(%esp)
  8007e2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e4:	83 eb 01             	sub    $0x1,%ebx
  8007e7:	85 db                	test   %ebx,%ebx
  8007e9:	7f ed                	jg     8007d8 <vprintfmt+0x1fb>
  8007eb:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  8007ee:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  8007f5:	eb a7                	jmp    80079e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8007f7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  8007fb:	74 18                	je     800815 <vprintfmt+0x238>
  8007fd:	8d 50 e0             	lea    -0x20(%eax),%edx
  800800:	83 fa 5e             	cmp    $0x5e,%edx
  800803:	76 10                	jbe    800815 <vprintfmt+0x238>
					putch('?', putdat);
  800805:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800809:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800810:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800813:	eb 0a                	jmp    80081f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800815:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800819:	89 04 24             	mov    %eax,(%esp)
  80081c:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80081f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800823:	0f be 03             	movsbl (%ebx),%eax
  800826:	85 c0                	test   %eax,%eax
  800828:	74 05                	je     80082f <vprintfmt+0x252>
  80082a:	83 c3 01             	add    $0x1,%ebx
  80082d:	eb 29                	jmp    800858 <vprintfmt+0x27b>
  80082f:	89 fe                	mov    %edi,%esi
  800831:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800834:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800837:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80083b:	7f 2e                	jg     80086b <vprintfmt+0x28e>
  80083d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800840:	e9 c4 fd ff ff       	jmp    800609 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800845:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800848:	83 c2 01             	add    $0x1,%edx
  80084b:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80084e:	89 f7                	mov    %esi,%edi
  800850:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800853:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  800856:	89 d3                	mov    %edx,%ebx
  800858:	85 f6                	test   %esi,%esi
  80085a:	78 9b                	js     8007f7 <vprintfmt+0x21a>
  80085c:	83 ee 01             	sub    $0x1,%esi
  80085f:	79 96                	jns    8007f7 <vprintfmt+0x21a>
  800861:	89 fe                	mov    %edi,%esi
  800863:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800866:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800869:	eb cc                	jmp    800837 <vprintfmt+0x25a>
  80086b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  80086e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800871:	89 74 24 04          	mov    %esi,0x4(%esp)
  800875:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80087c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087e:	83 eb 01             	sub    $0x1,%ebx
  800881:	85 db                	test   %ebx,%ebx
  800883:	7f ec                	jg     800871 <vprintfmt+0x294>
  800885:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800888:	e9 7c fd ff ff       	jmp    800609 <vprintfmt+0x2c>
  80088d:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800890:	83 f9 01             	cmp    $0x1,%ecx
  800893:	7e 16                	jle    8008ab <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800895:	8b 45 14             	mov    0x14(%ebp),%eax
  800898:	8d 50 08             	lea    0x8(%eax),%edx
  80089b:	89 55 14             	mov    %edx,0x14(%ebp)
  80089e:	8b 10                	mov    (%eax),%edx
  8008a0:	8b 48 04             	mov    0x4(%eax),%ecx
  8008a3:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8008a6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008a9:	eb 32                	jmp    8008dd <vprintfmt+0x300>
	else if (lflag)
  8008ab:	85 c9                	test   %ecx,%ecx
  8008ad:	74 18                	je     8008c7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8008af:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b2:	8d 50 04             	lea    0x4(%eax),%edx
  8008b5:	89 55 14             	mov    %edx,0x14(%ebp)
  8008b8:	8b 00                	mov    (%eax),%eax
  8008ba:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008bd:	89 c1                	mov    %eax,%ecx
  8008bf:	c1 f9 1f             	sar    $0x1f,%ecx
  8008c2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8008c5:	eb 16                	jmp    8008dd <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  8008c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ca:	8d 50 04             	lea    0x4(%eax),%edx
  8008cd:	89 55 14             	mov    %edx,0x14(%ebp)
  8008d0:	8b 00                	mov    (%eax),%eax
  8008d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008d5:	89 c2                	mov    %eax,%edx
  8008d7:	c1 fa 1f             	sar    $0x1f,%edx
  8008da:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8008dd:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8008e0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8008e3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  8008e8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  8008ec:	0f 89 b8 00 00 00    	jns    8009aa <vprintfmt+0x3cd>
				putch('-', putdat);
  8008f2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008f6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008fd:	ff d7                	call   *%edi
				num = -(long long) num;
  8008ff:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800902:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800905:	f7 d9                	neg    %ecx
  800907:	83 d3 00             	adc    $0x0,%ebx
  80090a:	f7 db                	neg    %ebx
  80090c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800911:	e9 94 00 00 00       	jmp    8009aa <vprintfmt+0x3cd>
  800916:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800919:	89 ca                	mov    %ecx,%edx
  80091b:	8d 45 14             	lea    0x14(%ebp),%eax
  80091e:	e8 63 fc ff ff       	call   800586 <getuint>
  800923:	89 c1                	mov    %eax,%ecx
  800925:	89 d3                	mov    %edx,%ebx
  800927:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80092c:	eb 7c                	jmp    8009aa <vprintfmt+0x3cd>
  80092e:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800931:	89 74 24 04          	mov    %esi,0x4(%esp)
  800935:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  80093c:	ff d7                	call   *%edi
			putch('X', putdat);
  80093e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800942:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800949:	ff d7                	call   *%edi
			putch('X', putdat);
  80094b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80094f:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800956:	ff d7                	call   *%edi
  800958:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80095b:	e9 a9 fc ff ff       	jmp    800609 <vprintfmt+0x2c>
  800960:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800963:	89 74 24 04          	mov    %esi,0x4(%esp)
  800967:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  80096e:	ff d7                	call   *%edi
			putch('x', putdat);
  800970:	89 74 24 04          	mov    %esi,0x4(%esp)
  800974:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80097b:	ff d7                	call   *%edi
			num = (unsigned long long)
  80097d:	8b 45 14             	mov    0x14(%ebp),%eax
  800980:	8d 50 04             	lea    0x4(%eax),%edx
  800983:	89 55 14             	mov    %edx,0x14(%ebp)
  800986:	8b 08                	mov    (%eax),%ecx
  800988:	bb 00 00 00 00       	mov    $0x0,%ebx
  80098d:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800992:	eb 16                	jmp    8009aa <vprintfmt+0x3cd>
  800994:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800997:	89 ca                	mov    %ecx,%edx
  800999:	8d 45 14             	lea    0x14(%ebp),%eax
  80099c:	e8 e5 fb ff ff       	call   800586 <getuint>
  8009a1:	89 c1                	mov    %eax,%ecx
  8009a3:	89 d3                	mov    %edx,%ebx
  8009a5:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8009aa:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  8009ae:	89 54 24 10          	mov    %edx,0x10(%esp)
  8009b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8009b5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009bd:	89 0c 24             	mov    %ecx,(%esp)
  8009c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8009c4:	89 f2                	mov    %esi,%edx
  8009c6:	89 f8                	mov    %edi,%eax
  8009c8:	e8 c3 fa ff ff       	call   800490 <printnum>
  8009cd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8009d0:	e9 34 fc ff ff       	jmp    800609 <vprintfmt+0x2c>
  8009d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009d8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009db:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009df:	89 14 24             	mov    %edx,(%esp)
  8009e2:	ff d7                	call   *%edi
  8009e4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8009e7:	e9 1d fc ff ff       	jmp    800609 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009f0:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009f7:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009f9:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8009fc:	80 38 25             	cmpb   $0x25,(%eax)
  8009ff:	0f 84 04 fc ff ff    	je     800609 <vprintfmt+0x2c>
  800a05:	89 c3                	mov    %eax,%ebx
  800a07:	eb f0                	jmp    8009f9 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  800a09:	83 c4 5c             	add    $0x5c,%esp
  800a0c:	5b                   	pop    %ebx
  800a0d:	5e                   	pop    %esi
  800a0e:	5f                   	pop    %edi
  800a0f:	5d                   	pop    %ebp
  800a10:	c3                   	ret    

00800a11 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a11:	55                   	push   %ebp
  800a12:	89 e5                	mov    %esp,%ebp
  800a14:	83 ec 28             	sub    $0x28,%esp
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800a1d:	85 c0                	test   %eax,%eax
  800a1f:	74 04                	je     800a25 <vsnprintf+0x14>
  800a21:	85 d2                	test   %edx,%edx
  800a23:	7f 07                	jg     800a2c <vsnprintf+0x1b>
  800a25:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a2a:	eb 3b                	jmp    800a67 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a2c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a2f:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800a33:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a3d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a40:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a44:	8b 45 10             	mov    0x10(%ebp),%eax
  800a47:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a4b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a52:	c7 04 24 c0 05 80 00 	movl   $0x8005c0,(%esp)
  800a59:	e8 7f fb ff ff       	call   8005dd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800a5e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a61:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a67:	c9                   	leave  
  800a68:	c3                   	ret    

00800a69 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
  800a6c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800a6f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800a72:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a76:	8b 45 10             	mov    0x10(%ebp),%eax
  800a79:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a80:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a84:	8b 45 08             	mov    0x8(%ebp),%eax
  800a87:	89 04 24             	mov    %eax,(%esp)
  800a8a:	e8 82 ff ff ff       	call   800a11 <vsnprintf>
	va_end(ap);

	return rc;
}
  800a8f:	c9                   	leave  
  800a90:	c3                   	ret    

00800a91 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800a97:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800a9a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a9e:	8b 45 10             	mov    0x10(%ebp),%eax
  800aa1:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aa5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aac:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaf:	89 04 24             	mov    %eax,(%esp)
  800ab2:	e8 26 fb ff ff       	call   8005dd <vprintfmt>
	va_end(ap);
}
  800ab7:	c9                   	leave  
  800ab8:	c3                   	ret    
  800ab9:	00 00                	add    %al,(%eax)
  800abb:	00 00                	add    %al,(%eax)
  800abd:	00 00                	add    %al,(%eax)
	...

00800ac0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800ac6:	b8 00 00 00 00       	mov    $0x0,%eax
  800acb:	80 3a 00             	cmpb   $0x0,(%edx)
  800ace:	74 09                	je     800ad9 <strlen+0x19>
		n++;
  800ad0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ad3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800ad7:	75 f7                	jne    800ad0 <strlen+0x10>
		n++;
	return n;
}
  800ad9:	5d                   	pop    %ebp
  800ada:	c3                   	ret    

00800adb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800adb:	55                   	push   %ebp
  800adc:	89 e5                	mov    %esp,%ebp
  800ade:	53                   	push   %ebx
  800adf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800ae2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ae5:	85 c9                	test   %ecx,%ecx
  800ae7:	74 19                	je     800b02 <strnlen+0x27>
  800ae9:	80 3b 00             	cmpb   $0x0,(%ebx)
  800aec:	74 14                	je     800b02 <strnlen+0x27>
  800aee:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800af3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800af6:	39 c8                	cmp    %ecx,%eax
  800af8:	74 0d                	je     800b07 <strnlen+0x2c>
  800afa:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800afe:	75 f3                	jne    800af3 <strnlen+0x18>
  800b00:	eb 05                	jmp    800b07 <strnlen+0x2c>
  800b02:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800b07:	5b                   	pop    %ebx
  800b08:	5d                   	pop    %ebp
  800b09:	c3                   	ret    

00800b0a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	53                   	push   %ebx
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800b14:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b19:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800b1d:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800b20:	83 c2 01             	add    $0x1,%edx
  800b23:	84 c9                	test   %cl,%cl
  800b25:	75 f2                	jne    800b19 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800b27:	5b                   	pop    %ebx
  800b28:	5d                   	pop    %ebp
  800b29:	c3                   	ret    

00800b2a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b2a:	55                   	push   %ebp
  800b2b:	89 e5                	mov    %esp,%ebp
  800b2d:	56                   	push   %esi
  800b2e:	53                   	push   %ebx
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b35:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b38:	85 f6                	test   %esi,%esi
  800b3a:	74 18                	je     800b54 <strncpy+0x2a>
  800b3c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800b41:	0f b6 1a             	movzbl (%edx),%ebx
  800b44:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b47:	80 3a 01             	cmpb   $0x1,(%edx)
  800b4a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b4d:	83 c1 01             	add    $0x1,%ecx
  800b50:	39 ce                	cmp    %ecx,%esi
  800b52:	77 ed                	ja     800b41 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800b54:	5b                   	pop    %ebx
  800b55:	5e                   	pop    %esi
  800b56:	5d                   	pop    %ebp
  800b57:	c3                   	ret    

00800b58 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	56                   	push   %esi
  800b5c:	53                   	push   %ebx
  800b5d:	8b 75 08             	mov    0x8(%ebp),%esi
  800b60:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b63:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b66:	89 f0                	mov    %esi,%eax
  800b68:	85 c9                	test   %ecx,%ecx
  800b6a:	74 27                	je     800b93 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800b6c:	83 e9 01             	sub    $0x1,%ecx
  800b6f:	74 1d                	je     800b8e <strlcpy+0x36>
  800b71:	0f b6 1a             	movzbl (%edx),%ebx
  800b74:	84 db                	test   %bl,%bl
  800b76:	74 16                	je     800b8e <strlcpy+0x36>
			*dst++ = *src++;
  800b78:	88 18                	mov    %bl,(%eax)
  800b7a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b7d:	83 e9 01             	sub    $0x1,%ecx
  800b80:	74 0e                	je     800b90 <strlcpy+0x38>
			*dst++ = *src++;
  800b82:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800b85:	0f b6 1a             	movzbl (%edx),%ebx
  800b88:	84 db                	test   %bl,%bl
  800b8a:	75 ec                	jne    800b78 <strlcpy+0x20>
  800b8c:	eb 02                	jmp    800b90 <strlcpy+0x38>
  800b8e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800b90:	c6 00 00             	movb   $0x0,(%eax)
  800b93:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800b95:	5b                   	pop    %ebx
  800b96:	5e                   	pop    %esi
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    

00800b99 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b99:	55                   	push   %ebp
  800b9a:	89 e5                	mov    %esp,%ebp
  800b9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b9f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800ba2:	0f b6 01             	movzbl (%ecx),%eax
  800ba5:	84 c0                	test   %al,%al
  800ba7:	74 15                	je     800bbe <strcmp+0x25>
  800ba9:	3a 02                	cmp    (%edx),%al
  800bab:	75 11                	jne    800bbe <strcmp+0x25>
		p++, q++;
  800bad:	83 c1 01             	add    $0x1,%ecx
  800bb0:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bb3:	0f b6 01             	movzbl (%ecx),%eax
  800bb6:	84 c0                	test   %al,%al
  800bb8:	74 04                	je     800bbe <strcmp+0x25>
  800bba:	3a 02                	cmp    (%edx),%al
  800bbc:	74 ef                	je     800bad <strcmp+0x14>
  800bbe:	0f b6 c0             	movzbl %al,%eax
  800bc1:	0f b6 12             	movzbl (%edx),%edx
  800bc4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800bc6:	5d                   	pop    %ebp
  800bc7:	c3                   	ret    

00800bc8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800bc8:	55                   	push   %ebp
  800bc9:	89 e5                	mov    %esp,%ebp
  800bcb:	53                   	push   %ebx
  800bcc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800bd5:	85 c0                	test   %eax,%eax
  800bd7:	74 23                	je     800bfc <strncmp+0x34>
  800bd9:	0f b6 1a             	movzbl (%edx),%ebx
  800bdc:	84 db                	test   %bl,%bl
  800bde:	74 24                	je     800c04 <strncmp+0x3c>
  800be0:	3a 19                	cmp    (%ecx),%bl
  800be2:	75 20                	jne    800c04 <strncmp+0x3c>
  800be4:	83 e8 01             	sub    $0x1,%eax
  800be7:	74 13                	je     800bfc <strncmp+0x34>
		n--, p++, q++;
  800be9:	83 c2 01             	add    $0x1,%edx
  800bec:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800bef:	0f b6 1a             	movzbl (%edx),%ebx
  800bf2:	84 db                	test   %bl,%bl
  800bf4:	74 0e                	je     800c04 <strncmp+0x3c>
  800bf6:	3a 19                	cmp    (%ecx),%bl
  800bf8:	74 ea                	je     800be4 <strncmp+0x1c>
  800bfa:	eb 08                	jmp    800c04 <strncmp+0x3c>
  800bfc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c01:	5b                   	pop    %ebx
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c04:	0f b6 02             	movzbl (%edx),%eax
  800c07:	0f b6 11             	movzbl (%ecx),%edx
  800c0a:	29 d0                	sub    %edx,%eax
  800c0c:	eb f3                	jmp    800c01 <strncmp+0x39>

00800c0e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c18:	0f b6 10             	movzbl (%eax),%edx
  800c1b:	84 d2                	test   %dl,%dl
  800c1d:	74 15                	je     800c34 <strchr+0x26>
		if (*s == c)
  800c1f:	38 ca                	cmp    %cl,%dl
  800c21:	75 07                	jne    800c2a <strchr+0x1c>
  800c23:	eb 14                	jmp    800c39 <strchr+0x2b>
  800c25:	38 ca                	cmp    %cl,%dl
  800c27:	90                   	nop
  800c28:	74 0f                	je     800c39 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c2a:	83 c0 01             	add    $0x1,%eax
  800c2d:	0f b6 10             	movzbl (%eax),%edx
  800c30:	84 d2                	test   %dl,%dl
  800c32:	75 f1                	jne    800c25 <strchr+0x17>
  800c34:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800c39:	5d                   	pop    %ebp
  800c3a:	c3                   	ret    

00800c3b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c41:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800c45:	0f b6 10             	movzbl (%eax),%edx
  800c48:	84 d2                	test   %dl,%dl
  800c4a:	74 18                	je     800c64 <strfind+0x29>
		if (*s == c)
  800c4c:	38 ca                	cmp    %cl,%dl
  800c4e:	75 0a                	jne    800c5a <strfind+0x1f>
  800c50:	eb 12                	jmp    800c64 <strfind+0x29>
  800c52:	38 ca                	cmp    %cl,%dl
  800c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800c58:	74 0a                	je     800c64 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800c5a:	83 c0 01             	add    $0x1,%eax
  800c5d:	0f b6 10             	movzbl (%eax),%edx
  800c60:	84 d2                	test   %dl,%dl
  800c62:	75 ee                	jne    800c52 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800c64:	5d                   	pop    %ebp
  800c65:	c3                   	ret    

00800c66 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c66:	55                   	push   %ebp
  800c67:	89 e5                	mov    %esp,%ebp
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	89 1c 24             	mov    %ebx,(%esp)
  800c6f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c73:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800c77:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c7a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c80:	85 c9                	test   %ecx,%ecx
  800c82:	74 30                	je     800cb4 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c84:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c8a:	75 25                	jne    800cb1 <memset+0x4b>
  800c8c:	f6 c1 03             	test   $0x3,%cl
  800c8f:	75 20                	jne    800cb1 <memset+0x4b>
		c &= 0xFF;
  800c91:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c94:	89 d3                	mov    %edx,%ebx
  800c96:	c1 e3 08             	shl    $0x8,%ebx
  800c99:	89 d6                	mov    %edx,%esi
  800c9b:	c1 e6 18             	shl    $0x18,%esi
  800c9e:	89 d0                	mov    %edx,%eax
  800ca0:	c1 e0 10             	shl    $0x10,%eax
  800ca3:	09 f0                	or     %esi,%eax
  800ca5:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800ca7:	09 d8                	or     %ebx,%eax
  800ca9:	c1 e9 02             	shr    $0x2,%ecx
  800cac:	fc                   	cld    
  800cad:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800caf:	eb 03                	jmp    800cb4 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800cb1:	fc                   	cld    
  800cb2:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800cb4:	89 f8                	mov    %edi,%eax
  800cb6:	8b 1c 24             	mov    (%esp),%ebx
  800cb9:	8b 74 24 04          	mov    0x4(%esp),%esi
  800cbd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800cc1:	89 ec                	mov    %ebp,%esp
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    

00800cc5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	83 ec 08             	sub    $0x8,%esp
  800ccb:	89 34 24             	mov    %esi,(%esp)
  800cce:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800cd8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800cdb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800cdd:	39 c6                	cmp    %eax,%esi
  800cdf:	73 35                	jae    800d16 <memmove+0x51>
  800ce1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ce4:	39 d0                	cmp    %edx,%eax
  800ce6:	73 2e                	jae    800d16 <memmove+0x51>
		s += n;
		d += n;
  800ce8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cea:	f6 c2 03             	test   $0x3,%dl
  800ced:	75 1b                	jne    800d0a <memmove+0x45>
  800cef:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800cf5:	75 13                	jne    800d0a <memmove+0x45>
  800cf7:	f6 c1 03             	test   $0x3,%cl
  800cfa:	75 0e                	jne    800d0a <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800cfc:	83 ef 04             	sub    $0x4,%edi
  800cff:	8d 72 fc             	lea    -0x4(%edx),%esi
  800d02:	c1 e9 02             	shr    $0x2,%ecx
  800d05:	fd                   	std    
  800d06:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d08:	eb 09                	jmp    800d13 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800d0a:	83 ef 01             	sub    $0x1,%edi
  800d0d:	8d 72 ff             	lea    -0x1(%edx),%esi
  800d10:	fd                   	std    
  800d11:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800d13:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d14:	eb 20                	jmp    800d36 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d16:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800d1c:	75 15                	jne    800d33 <memmove+0x6e>
  800d1e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d24:	75 0d                	jne    800d33 <memmove+0x6e>
  800d26:	f6 c1 03             	test   $0x3,%cl
  800d29:	75 08                	jne    800d33 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800d2b:	c1 e9 02             	shr    $0x2,%ecx
  800d2e:	fc                   	cld    
  800d2f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d31:	eb 03                	jmp    800d36 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800d33:	fc                   	cld    
  800d34:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800d36:	8b 34 24             	mov    (%esp),%esi
  800d39:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800d3d:	89 ec                	mov    %ebp,%esp
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800d47:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d51:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	89 04 24             	mov    %eax,(%esp)
  800d5b:	e8 65 ff ff ff       	call   800cc5 <memmove>
}
  800d60:	c9                   	leave  
  800d61:	c3                   	ret    

00800d62 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d62:	55                   	push   %ebp
  800d63:	89 e5                	mov    %esp,%ebp
  800d65:	57                   	push   %edi
  800d66:	56                   	push   %esi
  800d67:	53                   	push   %ebx
  800d68:	8b 75 08             	mov    0x8(%ebp),%esi
  800d6b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800d6e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d71:	85 c9                	test   %ecx,%ecx
  800d73:	74 36                	je     800dab <memcmp+0x49>
		if (*s1 != *s2)
  800d75:	0f b6 06             	movzbl (%esi),%eax
  800d78:	0f b6 1f             	movzbl (%edi),%ebx
  800d7b:	38 d8                	cmp    %bl,%al
  800d7d:	74 20                	je     800d9f <memcmp+0x3d>
  800d7f:	eb 14                	jmp    800d95 <memcmp+0x33>
  800d81:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800d86:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800d8b:	83 c2 01             	add    $0x1,%edx
  800d8e:	83 e9 01             	sub    $0x1,%ecx
  800d91:	38 d8                	cmp    %bl,%al
  800d93:	74 12                	je     800da7 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800d95:	0f b6 c0             	movzbl %al,%eax
  800d98:	0f b6 db             	movzbl %bl,%ebx
  800d9b:	29 d8                	sub    %ebx,%eax
  800d9d:	eb 11                	jmp    800db0 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800d9f:	83 e9 01             	sub    $0x1,%ecx
  800da2:	ba 00 00 00 00       	mov    $0x0,%edx
  800da7:	85 c9                	test   %ecx,%ecx
  800da9:	75 d6                	jne    800d81 <memcmp+0x1f>
  800dab:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800db0:	5b                   	pop    %ebx
  800db1:	5e                   	pop    %esi
  800db2:	5f                   	pop    %edi
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    

00800db5 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800dbb:	89 c2                	mov    %eax,%edx
  800dbd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800dc0:	39 d0                	cmp    %edx,%eax
  800dc2:	73 15                	jae    800dd9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800dc4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800dc8:	38 08                	cmp    %cl,(%eax)
  800dca:	75 06                	jne    800dd2 <memfind+0x1d>
  800dcc:	eb 0b                	jmp    800dd9 <memfind+0x24>
  800dce:	38 08                	cmp    %cl,(%eax)
  800dd0:	74 07                	je     800dd9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800dd2:	83 c0 01             	add    $0x1,%eax
  800dd5:	39 c2                	cmp    %eax,%edx
  800dd7:	77 f5                	ja     800dce <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800dd9:	5d                   	pop    %ebp
  800dda:	c3                   	ret    

00800ddb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ddb:	55                   	push   %ebp
  800ddc:	89 e5                	mov    %esp,%ebp
  800dde:	57                   	push   %edi
  800ddf:	56                   	push   %esi
  800de0:	53                   	push   %ebx
  800de1:	83 ec 04             	sub    $0x4,%esp
  800de4:	8b 55 08             	mov    0x8(%ebp),%edx
  800de7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800dea:	0f b6 02             	movzbl (%edx),%eax
  800ded:	3c 20                	cmp    $0x20,%al
  800def:	74 04                	je     800df5 <strtol+0x1a>
  800df1:	3c 09                	cmp    $0x9,%al
  800df3:	75 0e                	jne    800e03 <strtol+0x28>
		s++;
  800df5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800df8:	0f b6 02             	movzbl (%edx),%eax
  800dfb:	3c 20                	cmp    $0x20,%al
  800dfd:	74 f6                	je     800df5 <strtol+0x1a>
  800dff:	3c 09                	cmp    $0x9,%al
  800e01:	74 f2                	je     800df5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e03:	3c 2b                	cmp    $0x2b,%al
  800e05:	75 0c                	jne    800e13 <strtol+0x38>
		s++;
  800e07:	83 c2 01             	add    $0x1,%edx
  800e0a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e11:	eb 15                	jmp    800e28 <strtol+0x4d>
	else if (*s == '-')
  800e13:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800e1a:	3c 2d                	cmp    $0x2d,%al
  800e1c:	75 0a                	jne    800e28 <strtol+0x4d>
		s++, neg = 1;
  800e1e:	83 c2 01             	add    $0x1,%edx
  800e21:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e28:	85 db                	test   %ebx,%ebx
  800e2a:	0f 94 c0             	sete   %al
  800e2d:	74 05                	je     800e34 <strtol+0x59>
  800e2f:	83 fb 10             	cmp    $0x10,%ebx
  800e32:	75 18                	jne    800e4c <strtol+0x71>
  800e34:	80 3a 30             	cmpb   $0x30,(%edx)
  800e37:	75 13                	jne    800e4c <strtol+0x71>
  800e39:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800e3d:	8d 76 00             	lea    0x0(%esi),%esi
  800e40:	75 0a                	jne    800e4c <strtol+0x71>
		s += 2, base = 16;
  800e42:	83 c2 02             	add    $0x2,%edx
  800e45:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e4a:	eb 15                	jmp    800e61 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e4c:	84 c0                	test   %al,%al
  800e4e:	66 90                	xchg   %ax,%ax
  800e50:	74 0f                	je     800e61 <strtol+0x86>
  800e52:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800e57:	80 3a 30             	cmpb   $0x30,(%edx)
  800e5a:	75 05                	jne    800e61 <strtol+0x86>
		s++, base = 8;
  800e5c:	83 c2 01             	add    $0x1,%edx
  800e5f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e61:	b8 00 00 00 00       	mov    $0x0,%eax
  800e66:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800e68:	0f b6 0a             	movzbl (%edx),%ecx
  800e6b:	89 cf                	mov    %ecx,%edi
  800e6d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800e70:	80 fb 09             	cmp    $0x9,%bl
  800e73:	77 08                	ja     800e7d <strtol+0xa2>
			dig = *s - '0';
  800e75:	0f be c9             	movsbl %cl,%ecx
  800e78:	83 e9 30             	sub    $0x30,%ecx
  800e7b:	eb 1e                	jmp    800e9b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800e7d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800e80:	80 fb 19             	cmp    $0x19,%bl
  800e83:	77 08                	ja     800e8d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800e85:	0f be c9             	movsbl %cl,%ecx
  800e88:	83 e9 57             	sub    $0x57,%ecx
  800e8b:	eb 0e                	jmp    800e9b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800e8d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800e90:	80 fb 19             	cmp    $0x19,%bl
  800e93:	77 15                	ja     800eaa <strtol+0xcf>
			dig = *s - 'A' + 10;
  800e95:	0f be c9             	movsbl %cl,%ecx
  800e98:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800e9b:	39 f1                	cmp    %esi,%ecx
  800e9d:	7d 0b                	jge    800eaa <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800e9f:	83 c2 01             	add    $0x1,%edx
  800ea2:	0f af c6             	imul   %esi,%eax
  800ea5:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800ea8:	eb be                	jmp    800e68 <strtol+0x8d>
  800eaa:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800eac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800eb0:	74 05                	je     800eb7 <strtol+0xdc>
		*endptr = (char *) s;
  800eb2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800eb5:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800eb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800ebb:	74 04                	je     800ec1 <strtol+0xe6>
  800ebd:	89 c8                	mov    %ecx,%eax
  800ebf:	f7 d8                	neg    %eax
}
  800ec1:	83 c4 04             	add    $0x4,%esp
  800ec4:	5b                   	pop    %ebx
  800ec5:	5e                   	pop    %esi
  800ec6:	5f                   	pop    %edi
  800ec7:	5d                   	pop    %ebp
  800ec8:	c3                   	ret    
  800ec9:	00 00                	add    %al,(%eax)
	...

00800ecc <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	83 ec 0c             	sub    $0xc,%esp
  800ed2:	89 1c 24             	mov    %ebx,(%esp)
  800ed5:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ed9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800edd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee2:	b8 01 00 00 00       	mov    $0x1,%eax
  800ee7:	89 d1                	mov    %edx,%ecx
  800ee9:	89 d3                	mov    %edx,%ebx
  800eeb:	89 d7                	mov    %edx,%edi
  800eed:	89 d6                	mov    %edx,%esi
  800eef:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ef1:	8b 1c 24             	mov    (%esp),%ebx
  800ef4:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ef8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800efc:	89 ec                	mov    %ebp,%esp
  800efe:	5d                   	pop    %ebp
  800eff:	c3                   	ret    

00800f00 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
  800f03:	83 ec 0c             	sub    $0xc,%esp
  800f06:	89 1c 24             	mov    %ebx,(%esp)
  800f09:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f0d:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f11:	b8 00 00 00 00       	mov    $0x0,%eax
  800f16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f19:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1c:	89 c3                	mov    %eax,%ebx
  800f1e:	89 c7                	mov    %eax,%edi
  800f20:	89 c6                	mov    %eax,%esi
  800f22:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f24:	8b 1c 24             	mov    (%esp),%ebx
  800f27:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f2b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f2f:	89 ec                	mov    %ebp,%esp
  800f31:	5d                   	pop    %ebp
  800f32:	c3                   	ret    

00800f33 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  800f33:	55                   	push   %ebp
  800f34:	89 e5                	mov    %esp,%ebp
  800f36:	83 ec 0c             	sub    $0xc,%esp
  800f39:	89 1c 24             	mov    %ebx,(%esp)
  800f3c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f40:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f44:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f49:	b8 10 00 00 00       	mov    $0x10,%eax
  800f4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f51:	8b 55 08             	mov    0x8(%ebp),%edx
  800f54:	89 df                	mov    %ebx,%edi
  800f56:	89 de                	mov    %ebx,%esi
  800f58:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800f5a:	8b 1c 24             	mov    (%esp),%ebx
  800f5d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f61:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f65:	89 ec                	mov    %ebp,%esp
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    

00800f69 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  800f69:	55                   	push   %ebp
  800f6a:	89 e5                	mov    %esp,%ebp
  800f6c:	83 ec 38             	sub    $0x38,%esp
  800f6f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f72:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f75:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f78:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f85:	8b 55 08             	mov    0x8(%ebp),%edx
  800f88:	89 df                	mov    %ebx,%edi
  800f8a:	89 de                	mov    %ebx,%esi
  800f8c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800f8e:	85 c0                	test   %eax,%eax
  800f90:	7e 28                	jle    800fba <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800f92:	89 44 24 10          	mov    %eax,0x10(%esp)
  800f96:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800f9d:	00 
  800f9e:	c7 44 24 08 ff 32 80 	movl   $0x8032ff,0x8(%esp)
  800fa5:	00 
  800fa6:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800fad:	00 
  800fae:	c7 04 24 1c 33 80 00 	movl   $0x80331c,(%esp)
  800fb5:	e8 b2 f3 ff ff       	call   80036c <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800fba:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800fbd:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800fc0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800fc3:	89 ec                	mov    %ebp,%esp
  800fc5:	5d                   	pop    %ebp
  800fc6:	c3                   	ret    

00800fc7 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800fc7:	55                   	push   %ebp
  800fc8:	89 e5                	mov    %esp,%ebp
  800fca:	83 ec 0c             	sub    $0xc,%esp
  800fcd:	89 1c 24             	mov    %ebx,(%esp)
  800fd0:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fd4:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fd8:	ba 00 00 00 00       	mov    $0x0,%edx
  800fdd:	b8 0e 00 00 00       	mov    $0xe,%eax
  800fe2:	89 d1                	mov    %edx,%ecx
  800fe4:	89 d3                	mov    %edx,%ebx
  800fe6:	89 d7                	mov    %edx,%edi
  800fe8:	89 d6                	mov    %edx,%esi
  800fea:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  800fec:	8b 1c 24             	mov    (%esp),%ebx
  800fef:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ff3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ff7:	89 ec                	mov    %ebp,%esp
  800ff9:	5d                   	pop    %ebp
  800ffa:	c3                   	ret    

00800ffb <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 38             	sub    $0x38,%esp
  801001:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801004:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801007:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80100a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80100f:	b8 0d 00 00 00       	mov    $0xd,%eax
  801014:	8b 55 08             	mov    0x8(%ebp),%edx
  801017:	89 cb                	mov    %ecx,%ebx
  801019:	89 cf                	mov    %ecx,%edi
  80101b:	89 ce                	mov    %ecx,%esi
  80101d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80101f:	85 c0                	test   %eax,%eax
  801021:	7e 28                	jle    80104b <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801023:	89 44 24 10          	mov    %eax,0x10(%esp)
  801027:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80102e:	00 
  80102f:	c7 44 24 08 ff 32 80 	movl   $0x8032ff,0x8(%esp)
  801036:	00 
  801037:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80103e:	00 
  80103f:	c7 04 24 1c 33 80 00 	movl   $0x80331c,(%esp)
  801046:	e8 21 f3 ff ff       	call   80036c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80104b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80104e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801051:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801054:	89 ec                	mov    %ebp,%esp
  801056:	5d                   	pop    %ebp
  801057:	c3                   	ret    

00801058 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801058:	55                   	push   %ebp
  801059:	89 e5                	mov    %esp,%ebp
  80105b:	83 ec 0c             	sub    $0xc,%esp
  80105e:	89 1c 24             	mov    %ebx,(%esp)
  801061:	89 74 24 04          	mov    %esi,0x4(%esp)
  801065:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801069:	be 00 00 00 00       	mov    $0x0,%esi
  80106e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801073:	8b 7d 14             	mov    0x14(%ebp),%edi
  801076:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801079:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80107c:	8b 55 08             	mov    0x8(%ebp),%edx
  80107f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801081:	8b 1c 24             	mov    (%esp),%ebx
  801084:	8b 74 24 04          	mov    0x4(%esp),%esi
  801088:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80108c:	89 ec                	mov    %ebp,%esp
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    

00801090 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	83 ec 38             	sub    $0x38,%esp
  801096:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801099:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80109c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80109f:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8010a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010ac:	8b 55 08             	mov    0x8(%ebp),%edx
  8010af:	89 df                	mov    %ebx,%edi
  8010b1:	89 de                	mov    %ebx,%esi
  8010b3:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010b5:	85 c0                	test   %eax,%eax
  8010b7:	7e 28                	jle    8010e1 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010b9:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010bd:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8010c4:	00 
  8010c5:	c7 44 24 08 ff 32 80 	movl   $0x8032ff,0x8(%esp)
  8010cc:	00 
  8010cd:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010d4:	00 
  8010d5:	c7 04 24 1c 33 80 00 	movl   $0x80331c,(%esp)
  8010dc:	e8 8b f2 ff ff       	call   80036c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010e1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010e4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010e7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010ea:	89 ec                	mov    %ebp,%esp
  8010ec:	5d                   	pop    %ebp
  8010ed:	c3                   	ret    

008010ee <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8010ee:	55                   	push   %ebp
  8010ef:	89 e5                	mov    %esp,%ebp
  8010f1:	83 ec 38             	sub    $0x38,%esp
  8010f4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010f7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010fa:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010fd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801102:	b8 09 00 00 00       	mov    $0x9,%eax
  801107:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80110a:	8b 55 08             	mov    0x8(%ebp),%edx
  80110d:	89 df                	mov    %ebx,%edi
  80110f:	89 de                	mov    %ebx,%esi
  801111:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801113:	85 c0                	test   %eax,%eax
  801115:	7e 28                	jle    80113f <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801117:	89 44 24 10          	mov    %eax,0x10(%esp)
  80111b:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801122:	00 
  801123:	c7 44 24 08 ff 32 80 	movl   $0x8032ff,0x8(%esp)
  80112a:	00 
  80112b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801132:	00 
  801133:	c7 04 24 1c 33 80 00 	movl   $0x80331c,(%esp)
  80113a:	e8 2d f2 ff ff       	call   80036c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80113f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801142:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801145:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801148:	89 ec                	mov    %ebp,%esp
  80114a:	5d                   	pop    %ebp
  80114b:	c3                   	ret    

0080114c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 38             	sub    $0x38,%esp
  801152:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801155:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801158:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80115b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801160:	b8 08 00 00 00       	mov    $0x8,%eax
  801165:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801168:	8b 55 08             	mov    0x8(%ebp),%edx
  80116b:	89 df                	mov    %ebx,%edi
  80116d:	89 de                	mov    %ebx,%esi
  80116f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801171:	85 c0                	test   %eax,%eax
  801173:	7e 28                	jle    80119d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801175:	89 44 24 10          	mov    %eax,0x10(%esp)
  801179:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801180:	00 
  801181:	c7 44 24 08 ff 32 80 	movl   $0x8032ff,0x8(%esp)
  801188:	00 
  801189:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801190:	00 
  801191:	c7 04 24 1c 33 80 00 	movl   $0x80331c,(%esp)
  801198:	e8 cf f1 ff ff       	call   80036c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80119d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011a0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011a3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011a6:	89 ec                	mov    %ebp,%esp
  8011a8:	5d                   	pop    %ebp
  8011a9:	c3                   	ret    

008011aa <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  8011aa:	55                   	push   %ebp
  8011ab:	89 e5                	mov    %esp,%ebp
  8011ad:	83 ec 38             	sub    $0x38,%esp
  8011b0:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011b3:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011b6:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011b9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011be:	b8 06 00 00 00       	mov    $0x6,%eax
  8011c3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c9:	89 df                	mov    %ebx,%edi
  8011cb:	89 de                	mov    %ebx,%esi
  8011cd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011cf:	85 c0                	test   %eax,%eax
  8011d1:	7e 28                	jle    8011fb <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011d3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011d7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8011de:	00 
  8011df:	c7 44 24 08 ff 32 80 	movl   $0x8032ff,0x8(%esp)
  8011e6:	00 
  8011e7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011ee:	00 
  8011ef:	c7 04 24 1c 33 80 00 	movl   $0x80331c,(%esp)
  8011f6:	e8 71 f1 ff ff       	call   80036c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8011fb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011fe:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801201:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801204:	89 ec                	mov    %ebp,%esp
  801206:	5d                   	pop    %ebp
  801207:	c3                   	ret    

00801208 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801208:	55                   	push   %ebp
  801209:	89 e5                	mov    %esp,%ebp
  80120b:	83 ec 38             	sub    $0x38,%esp
  80120e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801211:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801214:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801217:	b8 05 00 00 00       	mov    $0x5,%eax
  80121c:	8b 75 18             	mov    0x18(%ebp),%esi
  80121f:	8b 7d 14             	mov    0x14(%ebp),%edi
  801222:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801225:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801228:	8b 55 08             	mov    0x8(%ebp),%edx
  80122b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80122d:	85 c0                	test   %eax,%eax
  80122f:	7e 28                	jle    801259 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801231:	89 44 24 10          	mov    %eax,0x10(%esp)
  801235:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80123c:	00 
  80123d:	c7 44 24 08 ff 32 80 	movl   $0x8032ff,0x8(%esp)
  801244:	00 
  801245:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80124c:	00 
  80124d:	c7 04 24 1c 33 80 00 	movl   $0x80331c,(%esp)
  801254:	e8 13 f1 ff ff       	call   80036c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801259:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80125c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80125f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801262:	89 ec                	mov    %ebp,%esp
  801264:	5d                   	pop    %ebp
  801265:	c3                   	ret    

00801266 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801266:	55                   	push   %ebp
  801267:	89 e5                	mov    %esp,%ebp
  801269:	83 ec 38             	sub    $0x38,%esp
  80126c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80126f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801272:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801275:	be 00 00 00 00       	mov    $0x0,%esi
  80127a:	b8 04 00 00 00       	mov    $0x4,%eax
  80127f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801282:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801285:	8b 55 08             	mov    0x8(%ebp),%edx
  801288:	89 f7                	mov    %esi,%edi
  80128a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80128c:	85 c0                	test   %eax,%eax
  80128e:	7e 28                	jle    8012b8 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801290:	89 44 24 10          	mov    %eax,0x10(%esp)
  801294:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80129b:	00 
  80129c:	c7 44 24 08 ff 32 80 	movl   $0x8032ff,0x8(%esp)
  8012a3:	00 
  8012a4:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012ab:	00 
  8012ac:	c7 04 24 1c 33 80 00 	movl   $0x80331c,(%esp)
  8012b3:	e8 b4 f0 ff ff       	call   80036c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8012b8:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012bb:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012be:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012c1:	89 ec                	mov    %ebp,%esp
  8012c3:	5d                   	pop    %ebp
  8012c4:	c3                   	ret    

008012c5 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8012c5:	55                   	push   %ebp
  8012c6:	89 e5                	mov    %esp,%ebp
  8012c8:	83 ec 0c             	sub    $0xc,%esp
  8012cb:	89 1c 24             	mov    %ebx,(%esp)
  8012ce:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012d2:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8012db:	b8 0b 00 00 00       	mov    $0xb,%eax
  8012e0:	89 d1                	mov    %edx,%ecx
  8012e2:	89 d3                	mov    %edx,%ebx
  8012e4:	89 d7                	mov    %edx,%edi
  8012e6:	89 d6                	mov    %edx,%esi
  8012e8:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8012ea:	8b 1c 24             	mov    (%esp),%ebx
  8012ed:	8b 74 24 04          	mov    0x4(%esp),%esi
  8012f1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8012f5:	89 ec                	mov    %ebp,%esp
  8012f7:	5d                   	pop    %ebp
  8012f8:	c3                   	ret    

008012f9 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8012f9:	55                   	push   %ebp
  8012fa:	89 e5                	mov    %esp,%ebp
  8012fc:	83 ec 0c             	sub    $0xc,%esp
  8012ff:	89 1c 24             	mov    %ebx,(%esp)
  801302:	89 74 24 04          	mov    %esi,0x4(%esp)
  801306:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80130a:	ba 00 00 00 00       	mov    $0x0,%edx
  80130f:	b8 02 00 00 00       	mov    $0x2,%eax
  801314:	89 d1                	mov    %edx,%ecx
  801316:	89 d3                	mov    %edx,%ebx
  801318:	89 d7                	mov    %edx,%edi
  80131a:	89 d6                	mov    %edx,%esi
  80131c:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80131e:	8b 1c 24             	mov    (%esp),%ebx
  801321:	8b 74 24 04          	mov    0x4(%esp),%esi
  801325:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801329:	89 ec                	mov    %ebp,%esp
  80132b:	5d                   	pop    %ebp
  80132c:	c3                   	ret    

0080132d <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	83 ec 38             	sub    $0x38,%esp
  801333:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801336:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801339:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80133c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801341:	b8 03 00 00 00       	mov    $0x3,%eax
  801346:	8b 55 08             	mov    0x8(%ebp),%edx
  801349:	89 cb                	mov    %ecx,%ebx
  80134b:	89 cf                	mov    %ecx,%edi
  80134d:	89 ce                	mov    %ecx,%esi
  80134f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801351:	85 c0                	test   %eax,%eax
  801353:	7e 28                	jle    80137d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801355:	89 44 24 10          	mov    %eax,0x10(%esp)
  801359:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801360:	00 
  801361:	c7 44 24 08 ff 32 80 	movl   $0x8032ff,0x8(%esp)
  801368:	00 
  801369:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801370:	00 
  801371:	c7 04 24 1c 33 80 00 	movl   $0x80331c,(%esp)
  801378:	e8 ef ef ff ff       	call   80036c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80137d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801380:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801383:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801386:	89 ec                	mov    %ebp,%esp
  801388:	5d                   	pop    %ebp
  801389:	c3                   	ret    
	...

0080138c <sfork>:
}

// Challenge!
int
sfork(void)
{
  80138c:	55                   	push   %ebp
  80138d:	89 e5                	mov    %esp,%ebp
  80138f:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801392:	c7 44 24 08 2a 33 80 	movl   $0x80332a,0x8(%esp)
  801399:	00 
  80139a:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  8013a1:	00 
  8013a2:	c7 04 24 40 33 80 00 	movl   $0x803340,(%esp)
  8013a9:	e8 be ef ff ff       	call   80036c <_panic>

008013ae <duppage>:
// It is also OK to panic on error.
// 

static int
duppage(envid_t envid, unsigned pn)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	83 ec 28             	sub    $0x28,%esp
  8013b4:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8013b7:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8013ba:	89 c3                	mov    %eax,%ebx
	int r;

	// LAB 4: Your code here.
     pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  8013bc:	89 d6                	mov    %edx,%esi
  8013be:	c1 e6 0c             	shl    $0xc,%esi
  8013c1:	89 f0                	mov    %esi,%eax
  8013c3:	c1 e8 16             	shr    $0x16,%eax
  8013c6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
       
        if( 0 == pgDirEntry )
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	0f 84 fc 00 00 00    	je     8014d1 <duppage+0x123>
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  8013d5:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8013dc:	89 c2                	mov    %eax,%edx
  8013de:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        //cprintf("Below %d",vpt[pn]);
                //if(perm!=0)  //commented nw.
                   // cprintf("perm bit %d",perm);
	
	
	if((perm & PTE_W) && (perm & PTE_SHARE))
  8013e4:	25 02 04 00 00       	and    $0x402,%eax
  8013e9:	3d 02 04 00 00       	cmp    $0x402,%eax
  8013ee:	75 4d                	jne    80143d <duppage+0x8f>
	{	
		if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_SHARE|(perm & PTE_USER))) < 0)
  8013f0:	81 e2 07 0a 00 00    	and    $0xa07,%edx
  8013f6:	80 ce 04             	or     $0x4,%dh
  8013f9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8013fd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801401:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801405:	89 74 24 04          	mov    %esi,0x4(%esp)
  801409:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801410:	e8 f3 fd ff ff       	call   801208 <sys_page_map>
  801415:	85 c0                	test   %eax,%eax
  801417:	0f 89 bb 00 00 00    	jns    8014d8 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  80141d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801421:	c7 44 24 08 4b 33 80 	movl   $0x80334b,0x8(%esp)
  801428:	00 
  801429:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  801430:	00 
  801431:	c7 04 24 40 33 80 00 	movl   $0x803340,(%esp)
  801438:	e8 2f ef ff ff       	call   80036c <_panic>
	}	


        else if((perm & PTE_W)!=0 || (perm & PTE_COW)!=0)
  80143d:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801443:	0f 84 8f 00 00 00    	je     8014d8 <duppage+0x12a>
         {
          //cprintf("\nInside Setting Cow\n"); 
        if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  801449:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801450:	00 
  801451:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801455:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801459:	89 74 24 04          	mov    %esi,0x4(%esp)
  80145d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801464:	e8 9f fd ff ff       	call   801208 <sys_page_map>
  801469:	85 c0                	test   %eax,%eax
  80146b:	79 20                	jns    80148d <duppage+0xdf>
                panic("sys_page_map: %e", r);
  80146d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801471:	c7 44 24 08 4b 33 80 	movl   $0x80334b,0x8(%esp)
  801478:	00 
  801479:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801480:	00 
  801481:	c7 04 24 40 33 80 00 	movl   $0x803340,(%esp)
  801488:	e8 df ee ff ff       	call   80036c <_panic>
        if ((r = sys_page_map(envid,(void *)(pn*PGSIZE),0,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  80148d:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801494:	00 
  801495:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801499:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8014a0:	00 
  8014a1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8014a5:	89 1c 24             	mov    %ebx,(%esp)
  8014a8:	e8 5b fd ff ff       	call   801208 <sys_page_map>
  8014ad:	85 c0                	test   %eax,%eax
  8014af:	79 27                	jns    8014d8 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  8014b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014b5:	c7 44 24 08 4b 33 80 	movl   $0x80334b,0x8(%esp)
  8014bc:	00 
  8014bd:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8014c4:	00 
  8014c5:	c7 04 24 40 33 80 00 	movl   $0x803340,(%esp)
  8014cc:	e8 9b ee ff ff       	call   80036c <_panic>
  8014d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8014d6:	eb 05                	jmp    8014dd <duppage+0x12f>
  8014d8:	b8 00 00 00 00       	mov    $0x0,%eax
         }


//	panic("duppage not implemented");
	return 0;
}
  8014dd:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8014e0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8014e3:	89 ec                	mov    %ebp,%esp
  8014e5:	5d                   	pop    %ebp
  8014e6:	c3                   	ret    

008014e7 <fork>:
//


envid_t
fork(void)
{
  8014e7:	55                   	push   %ebp
  8014e8:	89 e5                	mov    %esp,%ebp
  8014ea:	56                   	push   %esi
  8014eb:	53                   	push   %ebx
  8014ec:	83 ec 10             	sub    $0x10,%esp

        envid_t envid;
        uint8_t *addr;
        int r;
        extern unsigned char end[];
        set_pgfault_handler(pgfault);
  8014ef:	c7 04 24 fe 15 80 00 	movl   $0x8015fe,(%esp)
  8014f6:	e8 91 16 00 00       	call   802b8c <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8014fb:	be 07 00 00 00       	mov    $0x7,%esi
  801500:	89 f0                	mov    %esi,%eax
  801502:	cd 30                	int    $0x30
  801504:	89 c6                	mov    %eax,%esi

        envid = sys_exofork();
        if (envid < 0)
  801506:	85 c0                	test   %eax,%eax
  801508:	79 20                	jns    80152a <fork+0x43>
                panic("sys_exofork: %e", envid);
  80150a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80150e:	c7 44 24 08 5c 33 80 	movl   $0x80335c,0x8(%esp)
  801515:	00 
  801516:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  80151d:	00 
  80151e:	c7 04 24 40 33 80 00 	movl   $0x803340,(%esp)
  801525:	e8 42 ee ff ff       	call   80036c <_panic>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
  80152a:	bb 00 00 80 00       	mov    $0x800000,%ebx
        set_pgfault_handler(pgfault);

        envid = sys_exofork();
        if (envid < 0)
                panic("sys_exofork: %e", envid);
        if (envid == 0) {
  80152f:	85 c0                	test   %eax,%eax
  801531:	75 1c                	jne    80154f <fork+0x68>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
  801533:	e8 c1 fd ff ff       	call   8012f9 <sys_getenvid>
  801538:	25 ff 03 00 00       	and    $0x3ff,%eax
  80153d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801540:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801545:	a3 7c 70 80 00       	mov    %eax,0x80707c
                return 0;
  80154a:	e9 a6 00 00 00       	jmp    8015f5 <fork+0x10e>
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
  80154f:	89 da                	mov    %ebx,%edx
  801551:	c1 ea 0c             	shr    $0xc,%edx
  801554:	89 f0                	mov    %esi,%eax
  801556:	e8 53 fe ff ff       	call   8013ae <duppage>
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
  80155b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801561:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801567:	75 e6                	jne    80154f <fork+0x68>
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
                }
              duppage(envid,VPN(USTACKTOP-PGSIZE));
  801569:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80156e:	89 f0                	mov    %esi,%eax
  801570:	e8 39 fe ff ff       	call   8013ae <duppage>
        // Also copy the stack we are currently running on.
       //if(sys_page_alloc(envid, (void *)(ROUNDDOWN(&addr, PGSIZE)),PTE_U|PTE_P|PTE_W)<0)
         //                      panic("stack not allocated");
     
   
     sys_env_set_pgfault_upcall(envid,env->env_pgfault_upcall);
  801575:	a1 7c 70 80 00       	mov    0x80707c,%eax
  80157a:	8b 40 64             	mov    0x64(%eax),%eax
  80157d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801581:	89 34 24             	mov    %esi,(%esp)
  801584:	e8 07 fb ff ff       	call   801090 <sys_env_set_pgfault_upcall>

     if(sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  801589:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801590:	00 
  801591:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801598:	ee 
  801599:	89 34 24             	mov    %esi,(%esp)
  80159c:	e8 c5 fc ff ff       	call   801266 <sys_page_alloc>
  8015a1:	85 c0                	test   %eax,%eax
  8015a3:	79 1c                	jns    8015c1 <fork+0xda>
                          panic("Cant allocate Page");
  8015a5:	c7 44 24 08 6c 33 80 	movl   $0x80336c,0x8(%esp)
  8015ac:	00 
  8015ad:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  8015b4:	00 
  8015b5:	c7 04 24 40 33 80 00 	movl   $0x803340,(%esp)
  8015bc:	e8 ab ed ff ff       	call   80036c <_panic>

        // Start the child environment running
        if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8015c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8015c8:	00 
  8015c9:	89 34 24             	mov    %esi,(%esp)
  8015cc:	e8 7b fb ff ff       	call   80114c <sys_env_set_status>
  8015d1:	85 c0                	test   %eax,%eax
  8015d3:	79 20                	jns    8015f5 <fork+0x10e>
                panic("sys_env_set_status: %e", r);
  8015d5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8015d9:	c7 44 24 08 7f 33 80 	movl   $0x80337f,0x8(%esp)
  8015e0:	00 
  8015e1:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  8015e8:	00 
  8015e9:	c7 04 24 40 33 80 00 	movl   $0x803340,(%esp)
  8015f0:	e8 77 ed ff ff       	call   80036c <_panic>
         return envid;
           
//panic("fork not implemented");
}
  8015f5:	89 f0                	mov    %esi,%eax
  8015f7:	83 c4 10             	add    $0x10,%esp
  8015fa:	5b                   	pop    %ebx
  8015fb:	5e                   	pop    %esi
  8015fc:	5d                   	pop    %ebp
  8015fd:	c3                   	ret    

008015fe <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  8015fe:	55                   	push   %ebp
  8015ff:	89 e5                	mov    %esp,%ebp
  801601:	53                   	push   %ebx
  801602:	83 ec 24             	sub    $0x24,%esp
  801605:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801608:	8b 18                	mov    (%eax),%ebx
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).
 
         int perm = vpt[VPN(addr)] & 0xFFF;
  80160a:	89 da                	mov    %ebx,%edx
  80160c:	c1 ea 0c             	shr    $0xc,%edx
  80160f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx

static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
  801616:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80161a:	74 21                	je     80163d <pgfault+0x3f>
 
         int perm = vpt[VPN(addr)] & 0xFFF;
        if((err & FEC_WR)!=0)
           {
//              cprintf("\n>>>>>Due to write\n");
            if((perm & PTE_COW) == 0)
  80161c:	f6 c6 08             	test   $0x8,%dh
  80161f:	75 1c                	jne    80163d <pgfault+0x3f>
             {
                   panic("Not Set Cow");
  801621:	c7 44 24 08 96 33 80 	movl   $0x803396,0x8(%esp)
  801628:	00 
  801629:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801630:	00 
  801631:	c7 04 24 40 33 80 00 	movl   $0x803340,(%esp)
  801638:	e8 2f ed ff ff       	call   80036c <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
        if(sys_page_alloc(0,PFTEMP,PTE_P|PTE_U|PTE_W)<0)
  80163d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801644:	00 
  801645:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80164c:	00 
  80164d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801654:	e8 0d fc ff ff       	call   801266 <sys_page_alloc>
  801659:	85 c0                	test   %eax,%eax
  80165b:	79 1c                	jns    801679 <pgfault+0x7b>
              panic("\nPage not allocated\n");
  80165d:	c7 44 24 08 a2 33 80 	movl   $0x8033a2,0x8(%esp)
  801664:	00 
  801665:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  80166c:	00 
  80166d:	c7 04 24 40 33 80 00 	movl   $0x803340,(%esp)
  801674:	e8 f3 ec ff ff       	call   80036c <_panic>
           memmove(PFTEMP,ROUNDDOWN(addr,PGSIZE),PGSIZE);
  801679:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80167f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801686:	00 
  801687:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80168b:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801692:	e8 2e f6 ff ff       	call   800cc5 <memmove>
          if(sys_page_map(0,ROUNDDOWN(PFTEMP,PGSIZE),0,ROUNDDOWN(addr,PGSIZE),PTE_U|PTE_P|PTE_W)<0)
  801697:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80169e:	00 
  80169f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8016a3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016aa:	00 
  8016ab:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8016b2:	00 
  8016b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016ba:	e8 49 fb ff ff       	call   801208 <sys_page_map>
  8016bf:	85 c0                	test   %eax,%eax
  8016c1:	79 1c                	jns    8016df <pgfault+0xe1>
                   panic("not mapped properly");
  8016c3:	c7 44 24 08 b7 33 80 	movl   $0x8033b7,0x8(%esp)
  8016ca:	00 
  8016cb:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8016d2:	00 
  8016d3:	c7 04 24 40 33 80 00 	movl   $0x803340,(%esp)
  8016da:	e8 8d ec ff ff       	call   80036c <_panic>
         if( 0 > sys_page_unmap(0, PFTEMP) )
  8016df:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8016e6:	00 
  8016e7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016ee:	e8 b7 fa ff ff       	call   8011aa <sys_page_unmap>
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	79 1c                	jns    801713 <pgfault+0x115>
                panic("sys_page_unmap failed\n");
  8016f7:	c7 44 24 08 cb 33 80 	movl   $0x8033cb,0x8(%esp)
  8016fe:	00 
  8016ff:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  801706:	00 
  801707:	c7 04 24 40 33 80 00 	movl   $0x803340,(%esp)
  80170e:	e8 59 ec ff ff       	call   80036c <_panic>
   
//	panic("pgfault not implemented");
}
  801713:	83 c4 24             	add    $0x24,%esp
  801716:	5b                   	pop    %ebx
  801717:	5d                   	pop    %ebp
  801718:	c3                   	ret    
  801719:	00 00                	add    %al,(%eax)
  80171b:	00 00                	add    %al,(%eax)
  80171d:	00 00                	add    %al,(%eax)
	...

00801720 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	57                   	push   %edi
  801724:	56                   	push   %esi
  801725:	53                   	push   %ebx
  801726:	83 ec 1c             	sub    $0x1c,%esp
  801729:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80172c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80172f:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  801732:	8b 45 14             	mov    0x14(%ebp),%eax
  801735:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801739:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80173d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801741:	89 1c 24             	mov    %ebx,(%esp)
  801744:	e8 0f f9 ff ff       	call   801058 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  801749:	85 c0                	test   %eax,%eax
  80174b:	79 21                	jns    80176e <ipc_send+0x4e>
  80174d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801750:	74 1c                	je     80176e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  801752:	c7 44 24 08 e2 33 80 	movl   $0x8033e2,0x8(%esp)
  801759:	00 
  80175a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  801761:	00 
  801762:	c7 04 24 f4 33 80 00 	movl   $0x8033f4,(%esp)
  801769:	e8 fe eb ff ff       	call   80036c <_panic>
          else if(r==-E_IPC_NOT_RECV)
  80176e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801771:	75 07                	jne    80177a <ipc_send+0x5a>
           sys_yield();
  801773:	e8 4d fb ff ff       	call   8012c5 <sys_yield>
          else
            break;
        }
  801778:	eb b8                	jmp    801732 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  80177a:	83 c4 1c             	add    $0x1c,%esp
  80177d:	5b                   	pop    %ebx
  80177e:	5e                   	pop    %esi
  80177f:	5f                   	pop    %edi
  801780:	5d                   	pop    %ebp
  801781:	c3                   	ret    

00801782 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801782:	55                   	push   %ebp
  801783:	89 e5                	mov    %esp,%ebp
  801785:	83 ec 18             	sub    $0x18,%esp
  801788:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80178b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80178e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801791:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  801794:	8b 45 0c             	mov    0xc(%ebp),%eax
  801797:	89 04 24             	mov    %eax,(%esp)
  80179a:	e8 5c f8 ff ff       	call   800ffb <sys_ipc_recv>
        if(r<0)
  80179f:	85 c0                	test   %eax,%eax
  8017a1:	79 17                	jns    8017ba <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  8017a3:	85 db                	test   %ebx,%ebx
  8017a5:	74 06                	je     8017ad <ipc_recv+0x2b>
               *from_env_store =0;
  8017a7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  8017ad:	85 f6                	test   %esi,%esi
  8017af:	90                   	nop
  8017b0:	74 2c                	je     8017de <ipc_recv+0x5c>
              *perm_store=0;
  8017b2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8017b8:	eb 24                	jmp    8017de <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  8017ba:	85 db                	test   %ebx,%ebx
  8017bc:	74 0a                	je     8017c8 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  8017be:	a1 7c 70 80 00       	mov    0x80707c,%eax
  8017c3:	8b 40 74             	mov    0x74(%eax),%eax
  8017c6:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  8017c8:	85 f6                	test   %esi,%esi
  8017ca:	74 0a                	je     8017d6 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  8017cc:	a1 7c 70 80 00       	mov    0x80707c,%eax
  8017d1:	8b 40 78             	mov    0x78(%eax),%eax
  8017d4:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  8017d6:	a1 7c 70 80 00       	mov    0x80707c,%eax
  8017db:	8b 40 70             	mov    0x70(%eax),%eax
}
  8017de:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8017e1:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8017e4:	89 ec                	mov    %ebp,%esp
  8017e6:	5d                   	pop    %ebp
  8017e7:	c3                   	ret    
	...

008017f0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8017f0:	55                   	push   %ebp
  8017f1:	89 e5                	mov    %esp,%ebp
  8017f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f6:	05 00 00 00 30       	add    $0x30000000,%eax
  8017fb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  8017fe:	5d                   	pop    %ebp
  8017ff:	c3                   	ret    

00801800 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	89 04 24             	mov    %eax,(%esp)
  80180c:	e8 df ff ff ff       	call   8017f0 <fd2num>
  801811:	05 20 00 0d 00       	add    $0xd0020,%eax
  801816:	c1 e0 0c             	shl    $0xc,%eax
}
  801819:	c9                   	leave  
  80181a:	c3                   	ret    

0080181b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80181b:	55                   	push   %ebp
  80181c:	89 e5                	mov    %esp,%ebp
  80181e:	57                   	push   %edi
  80181f:	56                   	push   %esi
  801820:	53                   	push   %ebx
  801821:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801824:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801829:	a8 01                	test   $0x1,%al
  80182b:	74 36                	je     801863 <fd_alloc+0x48>
  80182d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801832:	a8 01                	test   $0x1,%al
  801834:	74 2d                	je     801863 <fd_alloc+0x48>
  801836:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80183b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801840:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801845:	89 c3                	mov    %eax,%ebx
  801847:	89 c2                	mov    %eax,%edx
  801849:	c1 ea 16             	shr    $0x16,%edx
  80184c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80184f:	f6 c2 01             	test   $0x1,%dl
  801852:	74 14                	je     801868 <fd_alloc+0x4d>
  801854:	89 c2                	mov    %eax,%edx
  801856:	c1 ea 0c             	shr    $0xc,%edx
  801859:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80185c:	f6 c2 01             	test   $0x1,%dl
  80185f:	75 10                	jne    801871 <fd_alloc+0x56>
  801861:	eb 05                	jmp    801868 <fd_alloc+0x4d>
  801863:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801868:	89 1f                	mov    %ebx,(%edi)
  80186a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80186f:	eb 17                	jmp    801888 <fd_alloc+0x6d>
  801871:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801876:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80187b:	75 c8                	jne    801845 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80187d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801883:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801888:	5b                   	pop    %ebx
  801889:	5e                   	pop    %esi
  80188a:	5f                   	pop    %edi
  80188b:	5d                   	pop    %ebp
  80188c:	c3                   	ret    

0080188d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80188d:	55                   	push   %ebp
  80188e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	83 f8 1f             	cmp    $0x1f,%eax
  801896:	77 36                	ja     8018ce <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801898:	05 00 00 0d 00       	add    $0xd0000,%eax
  80189d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8018a0:	89 c2                	mov    %eax,%edx
  8018a2:	c1 ea 16             	shr    $0x16,%edx
  8018a5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8018ac:	f6 c2 01             	test   $0x1,%dl
  8018af:	74 1d                	je     8018ce <fd_lookup+0x41>
  8018b1:	89 c2                	mov    %eax,%edx
  8018b3:	c1 ea 0c             	shr    $0xc,%edx
  8018b6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8018bd:	f6 c2 01             	test   $0x1,%dl
  8018c0:	74 0c                	je     8018ce <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  8018c2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018c5:	89 02                	mov    %eax,(%edx)
  8018c7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  8018cc:	eb 05                	jmp    8018d3 <fd_lookup+0x46>
  8018ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8018d3:	5d                   	pop    %ebp
  8018d4:	c3                   	ret    

008018d5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018db:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8018de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	89 04 24             	mov    %eax,(%esp)
  8018e8:	e8 a0 ff ff ff       	call   80188d <fd_lookup>
  8018ed:	85 c0                	test   %eax,%eax
  8018ef:	78 0e                	js     8018ff <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  8018f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8018f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f7:	89 50 04             	mov    %edx,0x4(%eax)
  8018fa:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8018ff:	c9                   	leave  
  801900:	c3                   	ret    

00801901 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	56                   	push   %esi
  801905:	53                   	push   %ebx
  801906:	83 ec 10             	sub    $0x10,%esp
  801909:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80190c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80190f:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801914:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801919:	be 80 34 80 00       	mov    $0x803480,%esi
		if (devtab[i]->dev_id == dev_id) {
  80191e:	39 08                	cmp    %ecx,(%eax)
  801920:	75 10                	jne    801932 <dev_lookup+0x31>
  801922:	eb 04                	jmp    801928 <dev_lookup+0x27>
  801924:	39 08                	cmp    %ecx,(%eax)
  801926:	75 0a                	jne    801932 <dev_lookup+0x31>
			*dev = devtab[i];
  801928:	89 03                	mov    %eax,(%ebx)
  80192a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80192f:	90                   	nop
  801930:	eb 31                	jmp    801963 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801932:	83 c2 01             	add    $0x1,%edx
  801935:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801938:	85 c0                	test   %eax,%eax
  80193a:	75 e8                	jne    801924 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80193c:	a1 7c 70 80 00       	mov    0x80707c,%eax
  801941:	8b 40 4c             	mov    0x4c(%eax),%eax
  801944:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801948:	89 44 24 04          	mov    %eax,0x4(%esp)
  80194c:	c7 04 24 00 34 80 00 	movl   $0x803400,(%esp)
  801953:	e8 d9 ea ff ff       	call   800431 <cprintf>
	*dev = 0;
  801958:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80195e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801963:	83 c4 10             	add    $0x10,%esp
  801966:	5b                   	pop    %ebx
  801967:	5e                   	pop    %esi
  801968:	5d                   	pop    %ebp
  801969:	c3                   	ret    

0080196a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	53                   	push   %ebx
  80196e:	83 ec 24             	sub    $0x24,%esp
  801971:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801974:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801977:	89 44 24 04          	mov    %eax,0x4(%esp)
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	89 04 24             	mov    %eax,(%esp)
  801981:	e8 07 ff ff ff       	call   80188d <fd_lookup>
  801986:	85 c0                	test   %eax,%eax
  801988:	78 53                	js     8019dd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80198a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801991:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801994:	8b 00                	mov    (%eax),%eax
  801996:	89 04 24             	mov    %eax,(%esp)
  801999:	e8 63 ff ff ff       	call   801901 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80199e:	85 c0                	test   %eax,%eax
  8019a0:	78 3b                	js     8019dd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8019a2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019aa:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8019ae:	74 2d                	je     8019dd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8019b0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8019b3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8019ba:	00 00 00 
	stat->st_isdir = 0;
  8019bd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8019c4:	00 00 00 
	stat->st_dev = dev;
  8019c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ca:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8019d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8019d7:	89 14 24             	mov    %edx,(%esp)
  8019da:	ff 50 14             	call   *0x14(%eax)
}
  8019dd:	83 c4 24             	add    $0x24,%esp
  8019e0:	5b                   	pop    %ebx
  8019e1:	5d                   	pop    %ebp
  8019e2:	c3                   	ret    

008019e3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  8019e3:	55                   	push   %ebp
  8019e4:	89 e5                	mov    %esp,%ebp
  8019e6:	53                   	push   %ebx
  8019e7:	83 ec 24             	sub    $0x24,%esp
  8019ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019f4:	89 1c 24             	mov    %ebx,(%esp)
  8019f7:	e8 91 fe ff ff       	call   80188d <fd_lookup>
  8019fc:	85 c0                	test   %eax,%eax
  8019fe:	78 5f                	js     801a5f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a00:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a03:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0a:	8b 00                	mov    (%eax),%eax
  801a0c:	89 04 24             	mov    %eax,(%esp)
  801a0f:	e8 ed fe ff ff       	call   801901 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a14:	85 c0                	test   %eax,%eax
  801a16:	78 47                	js     801a5f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a18:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a1b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801a1f:	75 23                	jne    801a44 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801a21:	a1 7c 70 80 00       	mov    0x80707c,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a26:	8b 40 4c             	mov    0x4c(%eax),%eax
  801a29:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a31:	c7 04 24 20 34 80 00 	movl   $0x803420,(%esp)
  801a38:	e8 f4 e9 ff ff       	call   800431 <cprintf>
  801a3d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801a42:	eb 1b                	jmp    801a5f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a47:	8b 48 18             	mov    0x18(%eax),%ecx
  801a4a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a4f:	85 c9                	test   %ecx,%ecx
  801a51:	74 0c                	je     801a5f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a53:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a56:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a5a:	89 14 24             	mov    %edx,(%esp)
  801a5d:	ff d1                	call   *%ecx
}
  801a5f:	83 c4 24             	add    $0x24,%esp
  801a62:	5b                   	pop    %ebx
  801a63:	5d                   	pop    %ebp
  801a64:	c3                   	ret    

00801a65 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
  801a68:	53                   	push   %ebx
  801a69:	83 ec 24             	sub    $0x24,%esp
  801a6c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a6f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a72:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a76:	89 1c 24             	mov    %ebx,(%esp)
  801a79:	e8 0f fe ff ff       	call   80188d <fd_lookup>
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	78 66                	js     801ae8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a82:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a85:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8c:	8b 00                	mov    (%eax),%eax
  801a8e:	89 04 24             	mov    %eax,(%esp)
  801a91:	e8 6b fe ff ff       	call   801901 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a96:	85 c0                	test   %eax,%eax
  801a98:	78 4e                	js     801ae8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a9a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a9d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801aa1:	75 23                	jne    801ac6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801aa3:	a1 7c 70 80 00       	mov    0x80707c,%eax
  801aa8:	8b 40 4c             	mov    0x4c(%eax),%eax
  801aab:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ab3:	c7 04 24 44 34 80 00 	movl   $0x803444,(%esp)
  801aba:	e8 72 e9 ff ff       	call   800431 <cprintf>
  801abf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801ac4:	eb 22                	jmp    801ae8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac9:	8b 48 0c             	mov    0xc(%eax),%ecx
  801acc:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ad1:	85 c9                	test   %ecx,%ecx
  801ad3:	74 13                	je     801ae8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801ad5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801adf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ae3:	89 14 24             	mov    %edx,(%esp)
  801ae6:	ff d1                	call   *%ecx
}
  801ae8:	83 c4 24             	add    $0x24,%esp
  801aeb:	5b                   	pop    %ebx
  801aec:	5d                   	pop    %ebp
  801aed:	c3                   	ret    

00801aee <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	53                   	push   %ebx
  801af2:	83 ec 24             	sub    $0x24,%esp
  801af5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801af8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801afb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aff:	89 1c 24             	mov    %ebx,(%esp)
  801b02:	e8 86 fd ff ff       	call   80188d <fd_lookup>
  801b07:	85 c0                	test   %eax,%eax
  801b09:	78 6b                	js     801b76 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801b0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b15:	8b 00                	mov    (%eax),%eax
  801b17:	89 04 24             	mov    %eax,(%esp)
  801b1a:	e8 e2 fd ff ff       	call   801901 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801b1f:	85 c0                	test   %eax,%eax
  801b21:	78 53                	js     801b76 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801b23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b26:	8b 42 08             	mov    0x8(%edx),%eax
  801b29:	83 e0 03             	and    $0x3,%eax
  801b2c:	83 f8 01             	cmp    $0x1,%eax
  801b2f:	75 23                	jne    801b54 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801b31:	a1 7c 70 80 00       	mov    0x80707c,%eax
  801b36:	8b 40 4c             	mov    0x4c(%eax),%eax
  801b39:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b3d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b41:	c7 04 24 61 34 80 00 	movl   $0x803461,(%esp)
  801b48:	e8 e4 e8 ff ff       	call   800431 <cprintf>
  801b4d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801b52:	eb 22                	jmp    801b76 <read+0x88>
	}
	if (!dev->dev_read)
  801b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b57:	8b 48 08             	mov    0x8(%eax),%ecx
  801b5a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801b5f:	85 c9                	test   %ecx,%ecx
  801b61:	74 13                	je     801b76 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801b63:	8b 45 10             	mov    0x10(%ebp),%eax
  801b66:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b71:	89 14 24             	mov    %edx,(%esp)
  801b74:	ff d1                	call   *%ecx
}
  801b76:	83 c4 24             	add    $0x24,%esp
  801b79:	5b                   	pop    %ebx
  801b7a:	5d                   	pop    %ebp
  801b7b:	c3                   	ret    

00801b7c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	57                   	push   %edi
  801b80:	56                   	push   %esi
  801b81:	53                   	push   %ebx
  801b82:	83 ec 1c             	sub    $0x1c,%esp
  801b85:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b88:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801b8b:	ba 00 00 00 00       	mov    $0x0,%edx
  801b90:	bb 00 00 00 00       	mov    $0x0,%ebx
  801b95:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9a:	85 f6                	test   %esi,%esi
  801b9c:	74 29                	je     801bc7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801b9e:	89 f0                	mov    %esi,%eax
  801ba0:	29 d0                	sub    %edx,%eax
  801ba2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ba6:	03 55 0c             	add    0xc(%ebp),%edx
  801ba9:	89 54 24 04          	mov    %edx,0x4(%esp)
  801bad:	89 3c 24             	mov    %edi,(%esp)
  801bb0:	e8 39 ff ff ff       	call   801aee <read>
		if (m < 0)
  801bb5:	85 c0                	test   %eax,%eax
  801bb7:	78 0e                	js     801bc7 <readn+0x4b>
			return m;
		if (m == 0)
  801bb9:	85 c0                	test   %eax,%eax
  801bbb:	74 08                	je     801bc5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801bbd:	01 c3                	add    %eax,%ebx
  801bbf:	89 da                	mov    %ebx,%edx
  801bc1:	39 f3                	cmp    %esi,%ebx
  801bc3:	72 d9                	jb     801b9e <readn+0x22>
  801bc5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801bc7:	83 c4 1c             	add    $0x1c,%esp
  801bca:	5b                   	pop    %ebx
  801bcb:	5e                   	pop    %esi
  801bcc:	5f                   	pop    %edi
  801bcd:	5d                   	pop    %ebp
  801bce:	c3                   	ret    

00801bcf <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
  801bd2:	56                   	push   %esi
  801bd3:	53                   	push   %ebx
  801bd4:	83 ec 20             	sub    $0x20,%esp
  801bd7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801bda:	89 34 24             	mov    %esi,(%esp)
  801bdd:	e8 0e fc ff ff       	call   8017f0 <fd2num>
  801be2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801be5:	89 54 24 04          	mov    %edx,0x4(%esp)
  801be9:	89 04 24             	mov    %eax,(%esp)
  801bec:	e8 9c fc ff ff       	call   80188d <fd_lookup>
  801bf1:	89 c3                	mov    %eax,%ebx
  801bf3:	85 c0                	test   %eax,%eax
  801bf5:	78 05                	js     801bfc <fd_close+0x2d>
  801bf7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801bfa:	74 0c                	je     801c08 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801bfc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801c00:	19 c0                	sbb    %eax,%eax
  801c02:	f7 d0                	not    %eax
  801c04:	21 c3                	and    %eax,%ebx
  801c06:	eb 3d                	jmp    801c45 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801c08:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c0f:	8b 06                	mov    (%esi),%eax
  801c11:	89 04 24             	mov    %eax,(%esp)
  801c14:	e8 e8 fc ff ff       	call   801901 <dev_lookup>
  801c19:	89 c3                	mov    %eax,%ebx
  801c1b:	85 c0                	test   %eax,%eax
  801c1d:	78 16                	js     801c35 <fd_close+0x66>
		if (dev->dev_close)
  801c1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c22:	8b 40 10             	mov    0x10(%eax),%eax
  801c25:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c2a:	85 c0                	test   %eax,%eax
  801c2c:	74 07                	je     801c35 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801c2e:	89 34 24             	mov    %esi,(%esp)
  801c31:	ff d0                	call   *%eax
  801c33:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801c35:	89 74 24 04          	mov    %esi,0x4(%esp)
  801c39:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c40:	e8 65 f5 ff ff       	call   8011aa <sys_page_unmap>
	return r;
}
  801c45:	89 d8                	mov    %ebx,%eax
  801c47:	83 c4 20             	add    $0x20,%esp
  801c4a:	5b                   	pop    %ebx
  801c4b:	5e                   	pop    %esi
  801c4c:	5d                   	pop    %ebp
  801c4d:	c3                   	ret    

00801c4e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801c4e:	55                   	push   %ebp
  801c4f:	89 e5                	mov    %esp,%ebp
  801c51:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c54:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	89 04 24             	mov    %eax,(%esp)
  801c61:	e8 27 fc ff ff       	call   80188d <fd_lookup>
  801c66:	85 c0                	test   %eax,%eax
  801c68:	78 13                	js     801c7d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801c6a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801c71:	00 
  801c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c75:	89 04 24             	mov    %eax,(%esp)
  801c78:	e8 52 ff ff ff       	call   801bcf <fd_close>
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
  801c82:	83 ec 18             	sub    $0x18,%esp
  801c85:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801c88:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801c8b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801c92:	00 
  801c93:	8b 45 08             	mov    0x8(%ebp),%eax
  801c96:	89 04 24             	mov    %eax,(%esp)
  801c99:	e8 a9 03 00 00       	call   802047 <open>
  801c9e:	89 c3                	mov    %eax,%ebx
  801ca0:	85 c0                	test   %eax,%eax
  801ca2:	78 1b                	js     801cbf <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ca7:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cab:	89 1c 24             	mov    %ebx,(%esp)
  801cae:	e8 b7 fc ff ff       	call   80196a <fstat>
  801cb3:	89 c6                	mov    %eax,%esi
	close(fd);
  801cb5:	89 1c 24             	mov    %ebx,(%esp)
  801cb8:	e8 91 ff ff ff       	call   801c4e <close>
  801cbd:	89 f3                	mov    %esi,%ebx
	return r;
}
  801cbf:	89 d8                	mov    %ebx,%eax
  801cc1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801cc4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801cc7:	89 ec                	mov    %ebp,%esp
  801cc9:	5d                   	pop    %ebp
  801cca:	c3                   	ret    

00801ccb <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
  801cce:	53                   	push   %ebx
  801ccf:	83 ec 14             	sub    $0x14,%esp
  801cd2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801cd7:	89 1c 24             	mov    %ebx,(%esp)
  801cda:	e8 6f ff ff ff       	call   801c4e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801cdf:	83 c3 01             	add    $0x1,%ebx
  801ce2:	83 fb 20             	cmp    $0x20,%ebx
  801ce5:	75 f0                	jne    801cd7 <close_all+0xc>
		close(i);
}
  801ce7:	83 c4 14             	add    $0x14,%esp
  801cea:	5b                   	pop    %ebx
  801ceb:	5d                   	pop    %ebp
  801cec:	c3                   	ret    

00801ced <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
  801cf0:	83 ec 58             	sub    $0x58,%esp
  801cf3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801cf6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801cf9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801cfc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801cff:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801d02:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d06:	8b 45 08             	mov    0x8(%ebp),%eax
  801d09:	89 04 24             	mov    %eax,(%esp)
  801d0c:	e8 7c fb ff ff       	call   80188d <fd_lookup>
  801d11:	89 c3                	mov    %eax,%ebx
  801d13:	85 c0                	test   %eax,%eax
  801d15:	0f 88 e0 00 00 00    	js     801dfb <dup+0x10e>
		return r;
	close(newfdnum);
  801d1b:	89 3c 24             	mov    %edi,(%esp)
  801d1e:	e8 2b ff ff ff       	call   801c4e <close>

	newfd = INDEX2FD(newfdnum);
  801d23:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801d29:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  801d2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d2f:	89 04 24             	mov    %eax,(%esp)
  801d32:	e8 c9 fa ff ff       	call   801800 <fd2data>
  801d37:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801d39:	89 34 24             	mov    %esi,(%esp)
  801d3c:	e8 bf fa ff ff       	call   801800 <fd2data>
  801d41:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801d44:	89 da                	mov    %ebx,%edx
  801d46:	89 d8                	mov    %ebx,%eax
  801d48:	c1 e8 16             	shr    $0x16,%eax
  801d4b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d52:	a8 01                	test   $0x1,%al
  801d54:	74 43                	je     801d99 <dup+0xac>
  801d56:	c1 ea 0c             	shr    $0xc,%edx
  801d59:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d60:	a8 01                	test   $0x1,%al
  801d62:	74 35                	je     801d99 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  801d64:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  801d6b:	25 07 0e 00 00       	and    $0xe07,%eax
  801d70:	89 44 24 10          	mov    %eax,0x10(%esp)
  801d74:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801d77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d7b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801d82:	00 
  801d83:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d87:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d8e:	e8 75 f4 ff ff       	call   801208 <sys_page_map>
  801d93:	89 c3                	mov    %eax,%ebx
  801d95:	85 c0                	test   %eax,%eax
  801d97:	78 3f                	js     801dd8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  801d99:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d9c:	89 c2                	mov    %eax,%edx
  801d9e:	c1 ea 0c             	shr    $0xc,%edx
  801da1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801da8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  801dae:	89 54 24 10          	mov    %edx,0x10(%esp)
  801db2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801db6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801dbd:	00 
  801dbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dc9:	e8 3a f4 ff ff       	call   801208 <sys_page_map>
  801dce:	89 c3                	mov    %eax,%ebx
  801dd0:	85 c0                	test   %eax,%eax
  801dd2:	78 04                	js     801dd8 <dup+0xeb>
  801dd4:	89 fb                	mov    %edi,%ebx
  801dd6:	eb 23                	jmp    801dfb <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801dd8:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ddc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801de3:	e8 c2 f3 ff ff       	call   8011aa <sys_page_unmap>
	sys_page_unmap(0, nva);
  801de8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801deb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801def:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801df6:	e8 af f3 ff ff       	call   8011aa <sys_page_unmap>
	return r;
}
  801dfb:	89 d8                	mov    %ebx,%eax
  801dfd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801e00:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801e03:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801e06:	89 ec                	mov    %ebp,%esp
  801e08:	5d                   	pop    %ebp
  801e09:	c3                   	ret    
	...

00801e0c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801e0c:	55                   	push   %ebp
  801e0d:	89 e5                	mov    %esp,%ebp
  801e0f:	53                   	push   %ebx
  801e10:	83 ec 14             	sub    $0x14,%esp
  801e13:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801e15:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801e1b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801e22:	00 
  801e23:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801e2a:	00 
  801e2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e2f:	89 14 24             	mov    %edx,(%esp)
  801e32:	e8 e9 f8 ff ff       	call   801720 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801e37:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801e3e:	00 
  801e3f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e43:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801e4a:	e8 33 f9 ff ff       	call   801782 <ipc_recv>
}
  801e4f:	83 c4 14             	add    $0x14,%esp
  801e52:	5b                   	pop    %ebx
  801e53:	5d                   	pop    %ebp
  801e54:	c3                   	ret    

00801e55 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
  801e58:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5e:	8b 40 0c             	mov    0xc(%eax),%eax
  801e61:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801e66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e69:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801e6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801e73:	b8 02 00 00 00       	mov    $0x2,%eax
  801e78:	e8 8f ff ff ff       	call   801e0c <fsipc>
}
  801e7d:	c9                   	leave  
  801e7e:	c3                   	ret    

00801e7f <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801e7f:	55                   	push   %ebp
  801e80:	89 e5                	mov    %esp,%ebp
  801e82:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801e85:	ba 00 00 00 00       	mov    $0x0,%edx
  801e8a:	b8 08 00 00 00       	mov    $0x8,%eax
  801e8f:	e8 78 ff ff ff       	call   801e0c <fsipc>
}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
  801e99:	53                   	push   %ebx
  801e9a:	83 ec 14             	sub    $0x14,%esp
  801e9d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ea6:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801eab:	ba 00 00 00 00       	mov    $0x0,%edx
  801eb0:	b8 05 00 00 00       	mov    $0x5,%eax
  801eb5:	e8 52 ff ff ff       	call   801e0c <fsipc>
  801eba:	85 c0                	test   %eax,%eax
  801ebc:	78 2b                	js     801ee9 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801ebe:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801ec5:	00 
  801ec6:	89 1c 24             	mov    %ebx,(%esp)
  801ec9:	e8 3c ec ff ff       	call   800b0a <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801ece:	a1 80 40 80 00       	mov    0x804080,%eax
  801ed3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801ed9:	a1 84 40 80 00       	mov    0x804084,%eax
  801ede:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801ee4:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801ee9:	83 c4 14             	add    $0x14,%esp
  801eec:	5b                   	pop    %ebx
  801eed:	5d                   	pop    %ebp
  801eee:	c3                   	ret    

00801eef <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  801ef5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801efc:	00 
  801efd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f04:	00 
  801f05:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801f0c:	e8 55 ed ff ff       	call   800c66 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	8b 40 0c             	mov    0xc(%eax),%eax
  801f17:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801f1c:	ba 00 00 00 00       	mov    $0x0,%edx
  801f21:	b8 06 00 00 00       	mov    $0x6,%eax
  801f26:	e8 e1 fe ff ff       	call   801e0c <fsipc>
}
  801f2b:	c9                   	leave  
  801f2c:	c3                   	ret    

00801f2d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801f2d:	55                   	push   %ebp
  801f2e:	89 e5                	mov    %esp,%ebp
  801f30:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801f33:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801f3a:	00 
  801f3b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f42:	00 
  801f43:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801f4a:	e8 17 ed ff ff       	call   800c66 <memset>
  801f4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801f52:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801f57:	76 05                	jbe    801f5e <devfile_write+0x31>
  801f59:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801f5e:	8b 55 08             	mov    0x8(%ebp),%edx
  801f61:	8b 52 0c             	mov    0xc(%edx),%edx
  801f64:	89 15 00 40 80 00    	mov    %edx,0x804000
        fsipcbuf.write.req_n = numberOfBytes;
  801f6a:	a3 04 40 80 00       	mov    %eax,0x804004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  801f6f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f73:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f76:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f7a:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801f81:	e8 3f ed ff ff       	call   800cc5 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  801f86:	ba 00 00 00 00       	mov    $0x0,%edx
  801f8b:	b8 04 00 00 00       	mov    $0x4,%eax
  801f90:	e8 77 fe ff ff       	call   801e0c <fsipc>
              return r;
        return r;
}
  801f95:	c9                   	leave  
  801f96:	c3                   	ret    

00801f97 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801f97:	55                   	push   %ebp
  801f98:	89 e5                	mov    %esp,%ebp
  801f9a:	53                   	push   %ebx
  801f9b:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  801f9e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801fa5:	00 
  801fa6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801fad:	00 
  801fae:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801fb5:	e8 ac ec ff ff       	call   800c66 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  801fba:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbd:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc0:	a3 00 40 80 00       	mov    %eax,0x804000
        fsipcbuf.read.req_n = n;
  801fc5:	8b 45 10             	mov    0x10(%ebp),%eax
  801fc8:	a3 04 40 80 00       	mov    %eax,0x804004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  801fcd:	ba 00 00 00 00       	mov    $0x0,%edx
  801fd2:	b8 03 00 00 00       	mov    $0x3,%eax
  801fd7:	e8 30 fe ff ff       	call   801e0c <fsipc>
  801fdc:	89 c3                	mov    %eax,%ebx
  801fde:	85 c0                	test   %eax,%eax
  801fe0:	78 17                	js     801ff9 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  801fe2:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fe6:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801fed:	00 
  801fee:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ff1:	89 04 24             	mov    %eax,(%esp)
  801ff4:	e8 cc ec ff ff       	call   800cc5 <memmove>
        return r;
}
  801ff9:	89 d8                	mov    %ebx,%eax
  801ffb:	83 c4 14             	add    $0x14,%esp
  801ffe:	5b                   	pop    %ebx
  801fff:	5d                   	pop    %ebp
  802000:	c3                   	ret    

00802001 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  802001:	55                   	push   %ebp
  802002:	89 e5                	mov    %esp,%ebp
  802004:	53                   	push   %ebx
  802005:	83 ec 14             	sub    $0x14,%esp
  802008:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  80200b:	89 1c 24             	mov    %ebx,(%esp)
  80200e:	e8 ad ea ff ff       	call   800ac0 <strlen>
  802013:	89 c2                	mov    %eax,%edx
  802015:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80201a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  802020:	7f 1f                	jg     802041 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  802022:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802026:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  80202d:	e8 d8 ea ff ff       	call   800b0a <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  802032:	ba 00 00 00 00       	mov    $0x0,%edx
  802037:	b8 07 00 00 00       	mov    $0x7,%eax
  80203c:	e8 cb fd ff ff       	call   801e0c <fsipc>
}
  802041:	83 c4 14             	add    $0x14,%esp
  802044:	5b                   	pop    %ebx
  802045:	5d                   	pop    %ebp
  802046:	c3                   	ret    

00802047 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
  80204a:	56                   	push   %esi
  80204b:	53                   	push   %ebx
  80204c:	83 ec 20             	sub    $0x20,%esp
  80204f:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  802052:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802059:	00 
  80205a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802061:	00 
  802062:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  802069:	e8 f8 eb ff ff       	call   800c66 <memset>
    if(strlen(path)>=MAXPATHLEN)
  80206e:	89 34 24             	mov    %esi,(%esp)
  802071:	e8 4a ea ff ff       	call   800ac0 <strlen>
  802076:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80207b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802080:	0f 8f 84 00 00 00    	jg     80210a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  802086:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802089:	89 04 24             	mov    %eax,(%esp)
  80208c:	e8 8a f7 ff ff       	call   80181b <fd_alloc>
  802091:	89 c3                	mov    %eax,%ebx
  802093:	85 c0                	test   %eax,%eax
  802095:	78 73                	js     80210a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  802097:	0f b6 06             	movzbl (%esi),%eax
  80209a:	84 c0                	test   %al,%al
  80209c:	74 20                	je     8020be <open+0x77>
  80209e:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  8020a0:	0f be c0             	movsbl %al,%eax
  8020a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a7:	c7 04 24 94 34 80 00 	movl   $0x803494,(%esp)
  8020ae:	e8 7e e3 ff ff       	call   800431 <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  8020b3:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  8020b7:	83 c3 01             	add    $0x1,%ebx
  8020ba:	84 c0                	test   %al,%al
  8020bc:	75 e2                	jne    8020a0 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  8020be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020c2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  8020c9:	e8 3c ea ff ff       	call   800b0a <strcpy>
    fsipcbuf.open.req_omode = mode;
  8020ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d1:	a3 00 44 80 00       	mov    %eax,0x804400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  8020d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020de:	e8 29 fd ff ff       	call   801e0c <fsipc>
  8020e3:	89 c3                	mov    %eax,%ebx
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	79 15                	jns    8020fe <open+0xb7>
        {
            fd_close(fd,1);
  8020e9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8020f0:	00 
  8020f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f4:	89 04 24             	mov    %eax,(%esp)
  8020f7:	e8 d3 fa ff ff       	call   801bcf <fd_close>
             return r;
  8020fc:	eb 0c                	jmp    80210a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  8020fe:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802101:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  802107:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  80210a:	89 d8                	mov    %ebx,%eax
  80210c:	83 c4 20             	add    $0x20,%esp
  80210f:	5b                   	pop    %ebx
  802110:	5e                   	pop    %esi
  802111:	5d                   	pop    %ebp
  802112:	c3                   	ret    
	...

00802120 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802126:	c7 44 24 04 97 34 80 	movl   $0x803497,0x4(%esp)
  80212d:	00 
  80212e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802131:	89 04 24             	mov    %eax,(%esp)
  802134:	e8 d1 e9 ff ff       	call   800b0a <strcpy>
	return 0;
}
  802139:	b8 00 00 00 00       	mov    $0x0,%eax
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	8b 40 0c             	mov    0xc(%eax),%eax
  80214c:	89 04 24             	mov    %eax,(%esp)
  80214f:	e8 9e 02 00 00       	call   8023f2 <nsipc_close>
}
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80215c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802163:	00 
  802164:	8b 45 10             	mov    0x10(%ebp),%eax
  802167:	89 44 24 08          	mov    %eax,0x8(%esp)
  80216b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80216e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802172:	8b 45 08             	mov    0x8(%ebp),%eax
  802175:	8b 40 0c             	mov    0xc(%eax),%eax
  802178:	89 04 24             	mov    %eax,(%esp)
  80217b:	e8 ae 02 00 00       	call   80242e <nsipc_send>
}
  802180:	c9                   	leave  
  802181:	c3                   	ret    

00802182 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802182:	55                   	push   %ebp
  802183:	89 e5                	mov    %esp,%ebp
  802185:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802188:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80218f:	00 
  802190:	8b 45 10             	mov    0x10(%ebp),%eax
  802193:	89 44 24 08          	mov    %eax,0x8(%esp)
  802197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80219a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80219e:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8021a4:	89 04 24             	mov    %eax,(%esp)
  8021a7:	e8 f5 02 00 00       	call   8024a1 <nsipc_recv>
}
  8021ac:	c9                   	leave  
  8021ad:	c3                   	ret    

008021ae <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  8021ae:	55                   	push   %ebp
  8021af:	89 e5                	mov    %esp,%ebp
  8021b1:	56                   	push   %esi
  8021b2:	53                   	push   %ebx
  8021b3:	83 ec 20             	sub    $0x20,%esp
  8021b6:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8021b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021bb:	89 04 24             	mov    %eax,(%esp)
  8021be:	e8 58 f6 ff ff       	call   80181b <fd_alloc>
  8021c3:	89 c3                	mov    %eax,%ebx
  8021c5:	85 c0                	test   %eax,%eax
  8021c7:	78 21                	js     8021ea <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  8021c9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8021d0:	00 
  8021d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8021df:	e8 82 f0 ff ff       	call   801266 <sys_page_alloc>
  8021e4:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8021e6:	85 c0                	test   %eax,%eax
  8021e8:	79 0a                	jns    8021f4 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  8021ea:	89 34 24             	mov    %esi,(%esp)
  8021ed:	e8 00 02 00 00       	call   8023f2 <nsipc_close>
		return r;
  8021f2:	eb 28                	jmp    80221c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8021f4:	8b 15 20 70 80 00    	mov    0x807020,%edx
  8021fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8021ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802202:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  802209:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80220c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80220f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802212:	89 04 24             	mov    %eax,(%esp)
  802215:	e8 d6 f5 ff ff       	call   8017f0 <fd2num>
  80221a:	89 c3                	mov    %eax,%ebx
}
  80221c:	89 d8                	mov    %ebx,%eax
  80221e:	83 c4 20             	add    $0x20,%esp
  802221:	5b                   	pop    %ebx
  802222:	5e                   	pop    %esi
  802223:	5d                   	pop    %ebp
  802224:	c3                   	ret    

00802225 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802225:	55                   	push   %ebp
  802226:	89 e5                	mov    %esp,%ebp
  802228:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80222b:	8b 45 10             	mov    0x10(%ebp),%eax
  80222e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802232:	8b 45 0c             	mov    0xc(%ebp),%eax
  802235:	89 44 24 04          	mov    %eax,0x4(%esp)
  802239:	8b 45 08             	mov    0x8(%ebp),%eax
  80223c:	89 04 24             	mov    %eax,(%esp)
  80223f:	e8 62 01 00 00       	call   8023a6 <nsipc_socket>
  802244:	85 c0                	test   %eax,%eax
  802246:	78 05                	js     80224d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802248:	e8 61 ff ff ff       	call   8021ae <alloc_sockfd>
}
  80224d:	c9                   	leave  
  80224e:	66 90                	xchg   %ax,%ax
  802250:	c3                   	ret    

00802251 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802251:	55                   	push   %ebp
  802252:	89 e5                	mov    %esp,%ebp
  802254:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802257:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80225a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80225e:	89 04 24             	mov    %eax,(%esp)
  802261:	e8 27 f6 ff ff       	call   80188d <fd_lookup>
  802266:	85 c0                	test   %eax,%eax
  802268:	78 15                	js     80227f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80226a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80226d:	8b 0a                	mov    (%edx),%ecx
  80226f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802274:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  80227a:	75 03                	jne    80227f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80227c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  80227f:	c9                   	leave  
  802280:	c3                   	ret    

00802281 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
  802284:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	e8 c2 ff ff ff       	call   802251 <fd2sockid>
  80228f:	85 c0                	test   %eax,%eax
  802291:	78 0f                	js     8022a2 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  802293:	8b 55 0c             	mov    0xc(%ebp),%edx
  802296:	89 54 24 04          	mov    %edx,0x4(%esp)
  80229a:	89 04 24             	mov    %eax,(%esp)
  80229d:	e8 2e 01 00 00       	call   8023d0 <nsipc_listen>
}
  8022a2:	c9                   	leave  
  8022a3:	c3                   	ret    

008022a4 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8022a4:	55                   	push   %ebp
  8022a5:	89 e5                	mov    %esp,%ebp
  8022a7:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	e8 9f ff ff ff       	call   802251 <fd2sockid>
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	78 16                	js     8022cc <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  8022b6:	8b 55 10             	mov    0x10(%ebp),%edx
  8022b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  8022bd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022c0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022c4:	89 04 24             	mov    %eax,(%esp)
  8022c7:	e8 55 02 00 00       	call   802521 <nsipc_connect>
}
  8022cc:	c9                   	leave  
  8022cd:	c3                   	ret    

008022ce <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8022ce:	55                   	push   %ebp
  8022cf:	89 e5                	mov    %esp,%ebp
  8022d1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	e8 75 ff ff ff       	call   802251 <fd2sockid>
  8022dc:	85 c0                	test   %eax,%eax
  8022de:	78 0f                	js     8022ef <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8022e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8022e3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022e7:	89 04 24             	mov    %eax,(%esp)
  8022ea:	e8 1d 01 00 00       	call   80240c <nsipc_shutdown>
}
  8022ef:	c9                   	leave  
  8022f0:	c3                   	ret    

008022f1 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	e8 52 ff ff ff       	call   802251 <fd2sockid>
  8022ff:	85 c0                	test   %eax,%eax
  802301:	78 16                	js     802319 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802303:	8b 55 10             	mov    0x10(%ebp),%edx
  802306:	89 54 24 08          	mov    %edx,0x8(%esp)
  80230a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802311:	89 04 24             	mov    %eax,(%esp)
  802314:	e8 47 02 00 00       	call   802560 <nsipc_bind>
}
  802319:	c9                   	leave  
  80231a:	c3                   	ret    

0080231b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80231b:	55                   	push   %ebp
  80231c:	89 e5                	mov    %esp,%ebp
  80231e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802321:	8b 45 08             	mov    0x8(%ebp),%eax
  802324:	e8 28 ff ff ff       	call   802251 <fd2sockid>
  802329:	85 c0                	test   %eax,%eax
  80232b:	78 1f                	js     80234c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80232d:	8b 55 10             	mov    0x10(%ebp),%edx
  802330:	89 54 24 08          	mov    %edx,0x8(%esp)
  802334:	8b 55 0c             	mov    0xc(%ebp),%edx
  802337:	89 54 24 04          	mov    %edx,0x4(%esp)
  80233b:	89 04 24             	mov    %eax,(%esp)
  80233e:	e8 5c 02 00 00       	call   80259f <nsipc_accept>
  802343:	85 c0                	test   %eax,%eax
  802345:	78 05                	js     80234c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802347:	e8 62 fe ff ff       	call   8021ae <alloc_sockfd>
}
  80234c:	c9                   	leave  
  80234d:	8d 76 00             	lea    0x0(%esi),%esi
  802350:	c3                   	ret    
	...

00802360 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802360:	55                   	push   %ebp
  802361:	89 e5                	mov    %esp,%ebp
  802363:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802366:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  80236c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802373:	00 
  802374:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80237b:	00 
  80237c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802380:	89 14 24             	mov    %edx,(%esp)
  802383:	e8 98 f3 ff ff       	call   801720 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802388:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80238f:	00 
  802390:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802397:	00 
  802398:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80239f:	e8 de f3 ff ff       	call   801782 <ipc_recv>
}
  8023a4:	c9                   	leave  
  8023a5:	c3                   	ret    

008023a6 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  8023a6:	55                   	push   %ebp
  8023a7:	89 e5                	mov    %esp,%ebp
  8023a9:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  8023ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8023af:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  8023b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b7:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  8023bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8023bf:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8023c4:	b8 09 00 00 00       	mov    $0x9,%eax
  8023c9:	e8 92 ff ff ff       	call   802360 <nsipc>
}
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
  8023d3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8023de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023e1:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8023e6:	b8 06 00 00 00       	mov    $0x6,%eax
  8023eb:	e8 70 ff ff ff       	call   802360 <nsipc>
}
  8023f0:	c9                   	leave  
  8023f1:	c3                   	ret    

008023f2 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  8023f2:	55                   	push   %ebp
  8023f3:	89 e5                	mov    %esp,%ebp
  8023f5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8023f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fb:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802400:	b8 04 00 00 00       	mov    $0x4,%eax
  802405:	e8 56 ff ff ff       	call   802360 <nsipc>
}
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
  80240f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802412:	8b 45 08             	mov    0x8(%ebp),%eax
  802415:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80241a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80241d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802422:	b8 03 00 00 00       	mov    $0x3,%eax
  802427:	e8 34 ff ff ff       	call   802360 <nsipc>
}
  80242c:	c9                   	leave  
  80242d:	c3                   	ret    

0080242e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80242e:	55                   	push   %ebp
  80242f:	89 e5                	mov    %esp,%ebp
  802431:	53                   	push   %ebx
  802432:	83 ec 14             	sub    $0x14,%esp
  802435:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802438:	8b 45 08             	mov    0x8(%ebp),%eax
  80243b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802440:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802446:	7e 24                	jle    80246c <nsipc_send+0x3e>
  802448:	c7 44 24 0c a3 34 80 	movl   $0x8034a3,0xc(%esp)
  80244f:	00 
  802450:	c7 44 24 08 af 34 80 	movl   $0x8034af,0x8(%esp)
  802457:	00 
  802458:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  80245f:	00 
  802460:	c7 04 24 c4 34 80 00 	movl   $0x8034c4,(%esp)
  802467:	e8 00 df ff ff       	call   80036c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80246c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802470:	8b 45 0c             	mov    0xc(%ebp),%eax
  802473:	89 44 24 04          	mov    %eax,0x4(%esp)
  802477:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80247e:	e8 42 e8 ff ff       	call   800cc5 <memmove>
	nsipcbuf.send.req_size = size;
  802483:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802489:	8b 45 14             	mov    0x14(%ebp),%eax
  80248c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802491:	b8 08 00 00 00       	mov    $0x8,%eax
  802496:	e8 c5 fe ff ff       	call   802360 <nsipc>
}
  80249b:	83 c4 14             	add    $0x14,%esp
  80249e:	5b                   	pop    %ebx
  80249f:	5d                   	pop    %ebp
  8024a0:	c3                   	ret    

008024a1 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  8024a1:	55                   	push   %ebp
  8024a2:	89 e5                	mov    %esp,%ebp
  8024a4:	56                   	push   %esi
  8024a5:	53                   	push   %ebx
  8024a6:	83 ec 10             	sub    $0x10,%esp
  8024a9:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  8024ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8024af:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  8024b4:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  8024ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8024bd:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8024c2:	b8 07 00 00 00       	mov    $0x7,%eax
  8024c7:	e8 94 fe ff ff       	call   802360 <nsipc>
  8024cc:	89 c3                	mov    %eax,%ebx
  8024ce:	85 c0                	test   %eax,%eax
  8024d0:	78 46                	js     802518 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8024d2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8024d7:	7f 04                	jg     8024dd <nsipc_recv+0x3c>
  8024d9:	39 c6                	cmp    %eax,%esi
  8024db:	7d 24                	jge    802501 <nsipc_recv+0x60>
  8024dd:	c7 44 24 0c d0 34 80 	movl   $0x8034d0,0xc(%esp)
  8024e4:	00 
  8024e5:	c7 44 24 08 af 34 80 	movl   $0x8034af,0x8(%esp)
  8024ec:	00 
  8024ed:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  8024f4:	00 
  8024f5:	c7 04 24 c4 34 80 00 	movl   $0x8034c4,(%esp)
  8024fc:	e8 6b de ff ff       	call   80036c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802501:	89 44 24 08          	mov    %eax,0x8(%esp)
  802505:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80250c:	00 
  80250d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802510:	89 04 24             	mov    %eax,(%esp)
  802513:	e8 ad e7 ff ff       	call   800cc5 <memmove>
	}

	return r;
}
  802518:	89 d8                	mov    %ebx,%eax
  80251a:	83 c4 10             	add    $0x10,%esp
  80251d:	5b                   	pop    %ebx
  80251e:	5e                   	pop    %esi
  80251f:	5d                   	pop    %ebp
  802520:	c3                   	ret    

00802521 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802521:	55                   	push   %ebp
  802522:	89 e5                	mov    %esp,%ebp
  802524:	53                   	push   %ebx
  802525:	83 ec 14             	sub    $0x14,%esp
  802528:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80252b:	8b 45 08             	mov    0x8(%ebp),%eax
  80252e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802533:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802537:	8b 45 0c             	mov    0xc(%ebp),%eax
  80253a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80253e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802545:	e8 7b e7 ff ff       	call   800cc5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80254a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802550:	b8 05 00 00 00       	mov    $0x5,%eax
  802555:	e8 06 fe ff ff       	call   802360 <nsipc>
}
  80255a:	83 c4 14             	add    $0x14,%esp
  80255d:	5b                   	pop    %ebx
  80255e:	5d                   	pop    %ebp
  80255f:	c3                   	ret    

00802560 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
  802563:	53                   	push   %ebx
  802564:	83 ec 14             	sub    $0x14,%esp
  802567:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80256a:	8b 45 08             	mov    0x8(%ebp),%eax
  80256d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802572:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802576:	8b 45 0c             	mov    0xc(%ebp),%eax
  802579:	89 44 24 04          	mov    %eax,0x4(%esp)
  80257d:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802584:	e8 3c e7 ff ff       	call   800cc5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802589:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80258f:	b8 02 00 00 00       	mov    $0x2,%eax
  802594:	e8 c7 fd ff ff       	call   802360 <nsipc>
}
  802599:	83 c4 14             	add    $0x14,%esp
  80259c:	5b                   	pop    %ebx
  80259d:	5d                   	pop    %ebp
  80259e:	c3                   	ret    

0080259f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80259f:	55                   	push   %ebp
  8025a0:	89 e5                	mov    %esp,%ebp
  8025a2:	83 ec 18             	sub    $0x18,%esp
  8025a5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8025a8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  8025ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8025ae:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  8025b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b8:	e8 a3 fd ff ff       	call   802360 <nsipc>
  8025bd:	89 c3                	mov    %eax,%ebx
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	78 25                	js     8025e8 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8025c3:	be 10 60 80 00       	mov    $0x806010,%esi
  8025c8:	8b 06                	mov    (%esi),%eax
  8025ca:	89 44 24 08          	mov    %eax,0x8(%esp)
  8025ce:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8025d5:	00 
  8025d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025d9:	89 04 24             	mov    %eax,(%esp)
  8025dc:	e8 e4 e6 ff ff       	call   800cc5 <memmove>
		*addrlen = ret->ret_addrlen;
  8025e1:	8b 16                	mov    (%esi),%edx
  8025e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8025e6:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  8025e8:	89 d8                	mov    %ebx,%eax
  8025ea:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8025ed:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8025f0:	89 ec                	mov    %ebp,%esp
  8025f2:	5d                   	pop    %ebp
  8025f3:	c3                   	ret    
	...

00802600 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802600:	55                   	push   %ebp
  802601:	89 e5                	mov    %esp,%ebp
  802603:	83 ec 18             	sub    $0x18,%esp
  802606:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802609:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80260c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80260f:	8b 45 08             	mov    0x8(%ebp),%eax
  802612:	89 04 24             	mov    %eax,(%esp)
  802615:	e8 e6 f1 ff ff       	call   801800 <fd2data>
  80261a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80261c:	c7 44 24 04 e5 34 80 	movl   $0x8034e5,0x4(%esp)
  802623:	00 
  802624:	89 34 24             	mov    %esi,(%esp)
  802627:	e8 de e4 ff ff       	call   800b0a <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80262c:	8b 43 04             	mov    0x4(%ebx),%eax
  80262f:	2b 03                	sub    (%ebx),%eax
  802631:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802637:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80263e:	00 00 00 
	stat->st_dev = &devpipe;
  802641:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  802648:	70 80 00 
	return 0;
}
  80264b:	b8 00 00 00 00       	mov    $0x0,%eax
  802650:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802653:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802656:	89 ec                	mov    %ebp,%esp
  802658:	5d                   	pop    %ebp
  802659:	c3                   	ret    

0080265a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80265a:	55                   	push   %ebp
  80265b:	89 e5                	mov    %esp,%ebp
  80265d:	53                   	push   %ebx
  80265e:	83 ec 14             	sub    $0x14,%esp
  802661:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802664:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802668:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80266f:	e8 36 eb ff ff       	call   8011aa <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802674:	89 1c 24             	mov    %ebx,(%esp)
  802677:	e8 84 f1 ff ff       	call   801800 <fd2data>
  80267c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802680:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802687:	e8 1e eb ff ff       	call   8011aa <sys_page_unmap>
}
  80268c:	83 c4 14             	add    $0x14,%esp
  80268f:	5b                   	pop    %ebx
  802690:	5d                   	pop    %ebp
  802691:	c3                   	ret    

00802692 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802692:	55                   	push   %ebp
  802693:	89 e5                	mov    %esp,%ebp
  802695:	57                   	push   %edi
  802696:	56                   	push   %esi
  802697:	53                   	push   %ebx
  802698:	83 ec 2c             	sub    $0x2c,%esp
  80269b:	89 c7                	mov    %eax,%edi
  80269d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  8026a0:	a1 7c 70 80 00       	mov    0x80707c,%eax
  8026a5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8026a8:	89 3c 24             	mov    %edi,(%esp)
  8026ab:	e8 7c 05 00 00       	call   802c2c <pageref>
  8026b0:	89 c6                	mov    %eax,%esi
  8026b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026b5:	89 04 24             	mov    %eax,(%esp)
  8026b8:	e8 6f 05 00 00       	call   802c2c <pageref>
  8026bd:	39 c6                	cmp    %eax,%esi
  8026bf:	0f 94 c0             	sete   %al
  8026c2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  8026c5:	8b 15 7c 70 80 00    	mov    0x80707c,%edx
  8026cb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8026ce:	39 cb                	cmp    %ecx,%ebx
  8026d0:	75 08                	jne    8026da <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  8026d2:	83 c4 2c             	add    $0x2c,%esp
  8026d5:	5b                   	pop    %ebx
  8026d6:	5e                   	pop    %esi
  8026d7:	5f                   	pop    %edi
  8026d8:	5d                   	pop    %ebp
  8026d9:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8026da:	83 f8 01             	cmp    $0x1,%eax
  8026dd:	75 c1                	jne    8026a0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  8026df:	8b 52 58             	mov    0x58(%edx),%edx
  8026e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8026e6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8026ea:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8026ee:	c7 04 24 ec 34 80 00 	movl   $0x8034ec,(%esp)
  8026f5:	e8 37 dd ff ff       	call   800431 <cprintf>
  8026fa:	eb a4                	jmp    8026a0 <_pipeisclosed+0xe>

008026fc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8026fc:	55                   	push   %ebp
  8026fd:	89 e5                	mov    %esp,%ebp
  8026ff:	57                   	push   %edi
  802700:	56                   	push   %esi
  802701:	53                   	push   %ebx
  802702:	83 ec 1c             	sub    $0x1c,%esp
  802705:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802708:	89 34 24             	mov    %esi,(%esp)
  80270b:	e8 f0 f0 ff ff       	call   801800 <fd2data>
  802710:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802712:	bf 00 00 00 00       	mov    $0x0,%edi
  802717:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80271b:	75 54                	jne    802771 <devpipe_write+0x75>
  80271d:	eb 60                	jmp    80277f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80271f:	89 da                	mov    %ebx,%edx
  802721:	89 f0                	mov    %esi,%eax
  802723:	e8 6a ff ff ff       	call   802692 <_pipeisclosed>
  802728:	85 c0                	test   %eax,%eax
  80272a:	74 07                	je     802733 <devpipe_write+0x37>
  80272c:	b8 00 00 00 00       	mov    $0x0,%eax
  802731:	eb 53                	jmp    802786 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802733:	90                   	nop
  802734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802738:	e8 88 eb ff ff       	call   8012c5 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80273d:	8b 43 04             	mov    0x4(%ebx),%eax
  802740:	8b 13                	mov    (%ebx),%edx
  802742:	83 c2 20             	add    $0x20,%edx
  802745:	39 d0                	cmp    %edx,%eax
  802747:	73 d6                	jae    80271f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802749:	89 c2                	mov    %eax,%edx
  80274b:	c1 fa 1f             	sar    $0x1f,%edx
  80274e:	c1 ea 1b             	shr    $0x1b,%edx
  802751:	01 d0                	add    %edx,%eax
  802753:	83 e0 1f             	and    $0x1f,%eax
  802756:	29 d0                	sub    %edx,%eax
  802758:	89 c2                	mov    %eax,%edx
  80275a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80275d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802761:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802765:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802769:	83 c7 01             	add    $0x1,%edi
  80276c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  80276f:	76 13                	jbe    802784 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802771:	8b 43 04             	mov    0x4(%ebx),%eax
  802774:	8b 13                	mov    (%ebx),%edx
  802776:	83 c2 20             	add    $0x20,%edx
  802779:	39 d0                	cmp    %edx,%eax
  80277b:	73 a2                	jae    80271f <devpipe_write+0x23>
  80277d:	eb ca                	jmp    802749 <devpipe_write+0x4d>
  80277f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802784:	89 f8                	mov    %edi,%eax
}
  802786:	83 c4 1c             	add    $0x1c,%esp
  802789:	5b                   	pop    %ebx
  80278a:	5e                   	pop    %esi
  80278b:	5f                   	pop    %edi
  80278c:	5d                   	pop    %ebp
  80278d:	c3                   	ret    

0080278e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80278e:	55                   	push   %ebp
  80278f:	89 e5                	mov    %esp,%ebp
  802791:	83 ec 28             	sub    $0x28,%esp
  802794:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802797:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80279a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80279d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  8027a0:	89 3c 24             	mov    %edi,(%esp)
  8027a3:	e8 58 f0 ff ff       	call   801800 <fd2data>
  8027a8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027aa:	be 00 00 00 00       	mov    $0x0,%esi
  8027af:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8027b3:	75 4c                	jne    802801 <devpipe_read+0x73>
  8027b5:	eb 5b                	jmp    802812 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  8027b7:	89 f0                	mov    %esi,%eax
  8027b9:	eb 5e                	jmp    802819 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  8027bb:	89 da                	mov    %ebx,%edx
  8027bd:	89 f8                	mov    %edi,%eax
  8027bf:	90                   	nop
  8027c0:	e8 cd fe ff ff       	call   802692 <_pipeisclosed>
  8027c5:	85 c0                	test   %eax,%eax
  8027c7:	74 07                	je     8027d0 <devpipe_read+0x42>
  8027c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8027ce:	eb 49                	jmp    802819 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  8027d0:	e8 f0 ea ff ff       	call   8012c5 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  8027d5:	8b 03                	mov    (%ebx),%eax
  8027d7:	3b 43 04             	cmp    0x4(%ebx),%eax
  8027da:	74 df                	je     8027bb <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8027dc:	89 c2                	mov    %eax,%edx
  8027de:	c1 fa 1f             	sar    $0x1f,%edx
  8027e1:	c1 ea 1b             	shr    $0x1b,%edx
  8027e4:	01 d0                	add    %edx,%eax
  8027e6:	83 e0 1f             	and    $0x1f,%eax
  8027e9:	29 d0                	sub    %edx,%eax
  8027eb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  8027f0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f3:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  8027f6:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8027f9:	83 c6 01             	add    $0x1,%esi
  8027fc:	39 75 10             	cmp    %esi,0x10(%ebp)
  8027ff:	76 16                	jbe    802817 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802801:	8b 03                	mov    (%ebx),%eax
  802803:	3b 43 04             	cmp    0x4(%ebx),%eax
  802806:	75 d4                	jne    8027dc <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802808:	85 f6                	test   %esi,%esi
  80280a:	75 ab                	jne    8027b7 <devpipe_read+0x29>
  80280c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802810:	eb a9                	jmp    8027bb <devpipe_read+0x2d>
  802812:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802817:	89 f0                	mov    %esi,%eax
}
  802819:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80281c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80281f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802822:	89 ec                	mov    %ebp,%esp
  802824:	5d                   	pop    %ebp
  802825:	c3                   	ret    

00802826 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802826:	55                   	push   %ebp
  802827:	89 e5                	mov    %esp,%ebp
  802829:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80282c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80282f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802833:	8b 45 08             	mov    0x8(%ebp),%eax
  802836:	89 04 24             	mov    %eax,(%esp)
  802839:	e8 4f f0 ff ff       	call   80188d <fd_lookup>
  80283e:	85 c0                	test   %eax,%eax
  802840:	78 15                	js     802857 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802845:	89 04 24             	mov    %eax,(%esp)
  802848:	e8 b3 ef ff ff       	call   801800 <fd2data>
	return _pipeisclosed(fd, p);
  80284d:	89 c2                	mov    %eax,%edx
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	e8 3b fe ff ff       	call   802692 <_pipeisclosed>
}
  802857:	c9                   	leave  
  802858:	c3                   	ret    

00802859 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802859:	55                   	push   %ebp
  80285a:	89 e5                	mov    %esp,%ebp
  80285c:	83 ec 48             	sub    $0x48,%esp
  80285f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802862:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802865:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802868:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80286b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80286e:	89 04 24             	mov    %eax,(%esp)
  802871:	e8 a5 ef ff ff       	call   80181b <fd_alloc>
  802876:	89 c3                	mov    %eax,%ebx
  802878:	85 c0                	test   %eax,%eax
  80287a:	0f 88 42 01 00 00    	js     8029c2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802880:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802887:	00 
  802888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80288b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80288f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802896:	e8 cb e9 ff ff       	call   801266 <sys_page_alloc>
  80289b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80289d:	85 c0                	test   %eax,%eax
  80289f:	0f 88 1d 01 00 00    	js     8029c2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8028a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8028a8:	89 04 24             	mov    %eax,(%esp)
  8028ab:	e8 6b ef ff ff       	call   80181b <fd_alloc>
  8028b0:	89 c3                	mov    %eax,%ebx
  8028b2:	85 c0                	test   %eax,%eax
  8028b4:	0f 88 f5 00 00 00    	js     8029af <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028ba:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028c1:	00 
  8028c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028d0:	e8 91 e9 ff ff       	call   801266 <sys_page_alloc>
  8028d5:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	0f 88 d0 00 00 00    	js     8029af <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  8028df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8028e2:	89 04 24             	mov    %eax,(%esp)
  8028e5:	e8 16 ef ff ff       	call   801800 <fd2data>
  8028ea:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8028ec:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8028f3:	00 
  8028f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028ff:	e8 62 e9 ff ff       	call   801266 <sys_page_alloc>
  802904:	89 c3                	mov    %eax,%ebx
  802906:	85 c0                	test   %eax,%eax
  802908:	0f 88 8e 00 00 00    	js     80299c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80290e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802911:	89 04 24             	mov    %eax,(%esp)
  802914:	e8 e7 ee ff ff       	call   801800 <fd2data>
  802919:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802920:	00 
  802921:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802925:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80292c:	00 
  80292d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802931:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802938:	e8 cb e8 ff ff       	call   801208 <sys_page_map>
  80293d:	89 c3                	mov    %eax,%ebx
  80293f:	85 c0                	test   %eax,%eax
  802941:	78 49                	js     80298c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802943:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  802948:	8b 08                	mov    (%eax),%ecx
  80294a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80294d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80294f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802952:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802959:	8b 10                	mov    (%eax),%edx
  80295b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80295e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802960:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802963:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80296a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80296d:	89 04 24             	mov    %eax,(%esp)
  802970:	e8 7b ee ff ff       	call   8017f0 <fd2num>
  802975:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802977:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80297a:	89 04 24             	mov    %eax,(%esp)
  80297d:	e8 6e ee ff ff       	call   8017f0 <fd2num>
  802982:	89 47 04             	mov    %eax,0x4(%edi)
  802985:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80298a:	eb 36                	jmp    8029c2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80298c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802990:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802997:	e8 0e e8 ff ff       	call   8011aa <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80299c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80299f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029aa:	e8 fb e7 ff ff       	call   8011aa <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8029af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029b6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8029bd:	e8 e8 e7 ff ff       	call   8011aa <sys_page_unmap>
    err:
	return r;
}
  8029c2:	89 d8                	mov    %ebx,%eax
  8029c4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8029c7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8029ca:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8029cd:	89 ec                	mov    %ebp,%esp
  8029cf:	5d                   	pop    %ebp
  8029d0:	c3                   	ret    
	...

008029e0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8029e0:	55                   	push   %ebp
  8029e1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8029e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8029e8:	5d                   	pop    %ebp
  8029e9:	c3                   	ret    

008029ea <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8029ea:	55                   	push   %ebp
  8029eb:	89 e5                	mov    %esp,%ebp
  8029ed:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  8029f0:	c7 44 24 04 04 35 80 	movl   $0x803504,0x4(%esp)
  8029f7:	00 
  8029f8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029fb:	89 04 24             	mov    %eax,(%esp)
  8029fe:	e8 07 e1 ff ff       	call   800b0a <strcpy>
	return 0;
}
  802a03:	b8 00 00 00 00       	mov    $0x0,%eax
  802a08:	c9                   	leave  
  802a09:	c3                   	ret    

00802a0a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802a0a:	55                   	push   %ebp
  802a0b:	89 e5                	mov    %esp,%ebp
  802a0d:	57                   	push   %edi
  802a0e:	56                   	push   %esi
  802a0f:	53                   	push   %ebx
  802a10:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a16:	b8 00 00 00 00       	mov    $0x0,%eax
  802a1b:	be 00 00 00 00       	mov    $0x0,%esi
  802a20:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a24:	74 3f                	je     802a65 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802a26:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802a2c:	8b 55 10             	mov    0x10(%ebp),%edx
  802a2f:	29 c2                	sub    %eax,%edx
  802a31:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802a33:	83 fa 7f             	cmp    $0x7f,%edx
  802a36:	76 05                	jbe    802a3d <devcons_write+0x33>
  802a38:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802a3d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a41:	03 45 0c             	add    0xc(%ebp),%eax
  802a44:	89 44 24 04          	mov    %eax,0x4(%esp)
  802a48:	89 3c 24             	mov    %edi,(%esp)
  802a4b:	e8 75 e2 ff ff       	call   800cc5 <memmove>
		sys_cputs(buf, m);
  802a50:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802a54:	89 3c 24             	mov    %edi,(%esp)
  802a57:	e8 a4 e4 ff ff       	call   800f00 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802a5c:	01 de                	add    %ebx,%esi
  802a5e:	89 f0                	mov    %esi,%eax
  802a60:	3b 75 10             	cmp    0x10(%ebp),%esi
  802a63:	72 c7                	jb     802a2c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802a65:	89 f0                	mov    %esi,%eax
  802a67:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802a6d:	5b                   	pop    %ebx
  802a6e:	5e                   	pop    %esi
  802a6f:	5f                   	pop    %edi
  802a70:	5d                   	pop    %ebp
  802a71:	c3                   	ret    

00802a72 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802a72:	55                   	push   %ebp
  802a73:	89 e5                	mov    %esp,%ebp
  802a75:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802a78:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802a7e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802a85:	00 
  802a86:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802a89:	89 04 24             	mov    %eax,(%esp)
  802a8c:	e8 6f e4 ff ff       	call   800f00 <sys_cputs>
}
  802a91:	c9                   	leave  
  802a92:	c3                   	ret    

00802a93 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a93:	55                   	push   %ebp
  802a94:	89 e5                	mov    %esp,%ebp
  802a96:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802a99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a9d:	75 07                	jne    802aa6 <devcons_read+0x13>
  802a9f:	eb 28                	jmp    802ac9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802aa1:	e8 1f e8 ff ff       	call   8012c5 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802aa6:	66 90                	xchg   %ax,%ax
  802aa8:	e8 1f e4 ff ff       	call   800ecc <sys_cgetc>
  802aad:	85 c0                	test   %eax,%eax
  802aaf:	90                   	nop
  802ab0:	74 ef                	je     802aa1 <devcons_read+0xe>
  802ab2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802ab4:	85 c0                	test   %eax,%eax
  802ab6:	78 16                	js     802ace <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802ab8:	83 f8 04             	cmp    $0x4,%eax
  802abb:	74 0c                	je     802ac9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802abd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802ac0:	88 10                	mov    %dl,(%eax)
  802ac2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802ac7:	eb 05                	jmp    802ace <devcons_read+0x3b>
  802ac9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ace:	c9                   	leave  
  802acf:	c3                   	ret    

00802ad0 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802ad0:	55                   	push   %ebp
  802ad1:	89 e5                	mov    %esp,%ebp
  802ad3:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802ad6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802ad9:	89 04 24             	mov    %eax,(%esp)
  802adc:	e8 3a ed ff ff       	call   80181b <fd_alloc>
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	78 3f                	js     802b24 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802ae5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802aec:	00 
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802af4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802afb:	e8 66 e7 ff ff       	call   801266 <sys_page_alloc>
  802b00:	85 c0                	test   %eax,%eax
  802b02:	78 20                	js     802b24 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802b04:	8b 15 58 70 80 00    	mov    0x807058,%edx
  802b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	89 04 24             	mov    %eax,(%esp)
  802b1f:	e8 cc ec ff ff       	call   8017f0 <fd2num>
}
  802b24:	c9                   	leave  
  802b25:	c3                   	ret    

00802b26 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802b26:	55                   	push   %ebp
  802b27:	89 e5                	mov    %esp,%ebp
  802b29:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b33:	8b 45 08             	mov    0x8(%ebp),%eax
  802b36:	89 04 24             	mov    %eax,(%esp)
  802b39:	e8 4f ed ff ff       	call   80188d <fd_lookup>
  802b3e:	85 c0                	test   %eax,%eax
  802b40:	78 11                	js     802b53 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802b42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b45:	8b 00                	mov    (%eax),%eax
  802b47:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  802b4d:	0f 94 c0             	sete   %al
  802b50:	0f b6 c0             	movzbl %al,%eax
}
  802b53:	c9                   	leave  
  802b54:	c3                   	ret    

00802b55 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802b55:	55                   	push   %ebp
  802b56:	89 e5                	mov    %esp,%ebp
  802b58:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802b5b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802b62:	00 
  802b63:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802b66:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b71:	e8 78 ef ff ff       	call   801aee <read>
	if (r < 0)
  802b76:	85 c0                	test   %eax,%eax
  802b78:	78 0f                	js     802b89 <getchar+0x34>
		return r;
	if (r < 1)
  802b7a:	85 c0                	test   %eax,%eax
  802b7c:	7f 07                	jg     802b85 <getchar+0x30>
  802b7e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802b83:	eb 04                	jmp    802b89 <getchar+0x34>
		return -E_EOF;
	return c;
  802b85:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802b89:	c9                   	leave  
  802b8a:	c3                   	ret    
	...

00802b8c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802b8c:	55                   	push   %ebp
  802b8d:	89 e5                	mov    %esp,%ebp
  802b8f:	53                   	push   %ebx
  802b90:	83 ec 14             	sub    $0x14,%esp
  802b93:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    // cprintf("\nhere outside loading creating page\n");

	if (_pgfault_handler == 0) {
  802b96:	83 3d 84 70 80 00 00 	cmpl   $0x0,0x807084
  802b9d:	75 58                	jne    802bf7 <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
           //cprintf("\nhere inside loading creating page\n");    
          if(sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  802b9f:	e8 55 e7 ff ff       	call   8012f9 <sys_getenvid>
  802ba4:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802bab:	00 
  802bac:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802bb3:	ee 
  802bb4:	89 04 24             	mov    %eax,(%esp)
  802bb7:	e8 aa e6 ff ff       	call   801266 <sys_page_alloc>
  802bbc:	85 c0                	test   %eax,%eax
  802bbe:	79 1c                	jns    802bdc <set_pgfault_handler+0x50>
                          panic("Cant allocate Page");                    
  802bc0:	c7 44 24 08 6c 33 80 	movl   $0x80336c,0x8(%esp)
  802bc7:	00 
  802bc8:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802bcf:	00 
  802bd0:	c7 04 24 10 35 80 00 	movl   $0x803510,(%esp)
  802bd7:	e8 90 d7 ff ff       	call   80036c <_panic>
                _pgfault_handler=handler;
  802bdc:	89 1d 84 70 80 00    	mov    %ebx,0x807084
//entry point _pgfault_handler not pointed to by the kernel bcz after the execution is complete control needs to be returned back to execute the rest...so upcall is there         
             sys_env_set_pgfault_upcall(sys_getenvid(),_pgfault_upcall);
  802be2:	e8 12 e7 ff ff       	call   8012f9 <sys_getenvid>
  802be7:	c7 44 24 04 04 2c 80 	movl   $0x802c04,0x4(%esp)
  802bee:	00 
  802bef:	89 04 24             	mov    %eax,(%esp)
  802bf2:	e8 99 e4 ff ff       	call   801090 <sys_env_set_pgfault_upcall>

	// Save handler pointer for assembly to call.
 //     if(sys_page_alloc(0,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
   //                       panic("Cant allocate Page");

	_pgfault_handler = handler;
  802bf7:	89 1d 84 70 80 00    	mov    %ebx,0x807084
}
  802bfd:	83 c4 14             	add    $0x14,%esp
  802c00:	5b                   	pop    %ebx
  802c01:	5d                   	pop    %ebp
  802c02:	c3                   	ret    
	...

00802c04 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802c04:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802c05:	a1 84 70 80 00       	mov    0x807084,%eax
	call *%eax
  802c0a:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802c0c:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
           addl $8,%esp
  802c0f:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
            movl  32(%esp),%ebx
  802c12:	8b 5c 24 20          	mov    0x20(%esp),%ebx
            movl  40(%esp),%eax
  802c16:	8b 44 24 28          	mov    0x28(%esp),%eax
            subl  $4,%eax
  802c1a:	83 e8 04             	sub    $0x4,%eax
            movl  %eax,40(%esp)
  802c1d:	89 44 24 28          	mov    %eax,0x28(%esp)
            movl  %ebx,(%eax)
  802c21:	89 18                	mov    %ebx,(%eax)
            popal
  802c23:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
            
            add $4,%esp            
  802c24:	83 c4 04             	add    $0x4,%esp
            popfl
  802c27:	9d                   	popf   
             
           popl %esp
  802c28:	5c                   	pop    %esp
	// LAB 4: Your code here.
           

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
           ret
  802c29:	c3                   	ret    
	...

00802c2c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802c2c:	55                   	push   %ebp
  802c2d:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c32:	89 c2                	mov    %eax,%edx
  802c34:	c1 ea 16             	shr    $0x16,%edx
  802c37:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802c3e:	f6 c2 01             	test   $0x1,%dl
  802c41:	74 26                	je     802c69 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802c43:	c1 e8 0c             	shr    $0xc,%eax
  802c46:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802c4d:	a8 01                	test   $0x1,%al
  802c4f:	74 18                	je     802c69 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802c51:	c1 e8 0c             	shr    $0xc,%eax
  802c54:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802c57:	c1 e2 02             	shl    $0x2,%edx
  802c5a:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802c5f:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802c64:	0f b7 c0             	movzwl %ax,%eax
  802c67:	eb 05                	jmp    802c6e <pageref+0x42>
  802c69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802c6e:	5d                   	pop    %ebp
  802c6f:	c3                   	ret    

00802c70 <__udivdi3>:
  802c70:	55                   	push   %ebp
  802c71:	89 e5                	mov    %esp,%ebp
  802c73:	57                   	push   %edi
  802c74:	56                   	push   %esi
  802c75:	83 ec 10             	sub    $0x10,%esp
  802c78:	8b 45 14             	mov    0x14(%ebp),%eax
  802c7b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7e:	8b 75 10             	mov    0x10(%ebp),%esi
  802c81:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802c84:	85 c0                	test   %eax,%eax
  802c86:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802c89:	75 35                	jne    802cc0 <__udivdi3+0x50>
  802c8b:	39 fe                	cmp    %edi,%esi
  802c8d:	77 61                	ja     802cf0 <__udivdi3+0x80>
  802c8f:	85 f6                	test   %esi,%esi
  802c91:	75 0b                	jne    802c9e <__udivdi3+0x2e>
  802c93:	b8 01 00 00 00       	mov    $0x1,%eax
  802c98:	31 d2                	xor    %edx,%edx
  802c9a:	f7 f6                	div    %esi
  802c9c:	89 c6                	mov    %eax,%esi
  802c9e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802ca1:	31 d2                	xor    %edx,%edx
  802ca3:	89 f8                	mov    %edi,%eax
  802ca5:	f7 f6                	div    %esi
  802ca7:	89 c7                	mov    %eax,%edi
  802ca9:	89 c8                	mov    %ecx,%eax
  802cab:	f7 f6                	div    %esi
  802cad:	89 c1                	mov    %eax,%ecx
  802caf:	89 fa                	mov    %edi,%edx
  802cb1:	89 c8                	mov    %ecx,%eax
  802cb3:	83 c4 10             	add    $0x10,%esp
  802cb6:	5e                   	pop    %esi
  802cb7:	5f                   	pop    %edi
  802cb8:	5d                   	pop    %ebp
  802cb9:	c3                   	ret    
  802cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802cc0:	39 f8                	cmp    %edi,%eax
  802cc2:	77 1c                	ja     802ce0 <__udivdi3+0x70>
  802cc4:	0f bd d0             	bsr    %eax,%edx
  802cc7:	83 f2 1f             	xor    $0x1f,%edx
  802cca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802ccd:	75 39                	jne    802d08 <__udivdi3+0x98>
  802ccf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802cd2:	0f 86 a0 00 00 00    	jbe    802d78 <__udivdi3+0x108>
  802cd8:	39 f8                	cmp    %edi,%eax
  802cda:	0f 82 98 00 00 00    	jb     802d78 <__udivdi3+0x108>
  802ce0:	31 ff                	xor    %edi,%edi
  802ce2:	31 c9                	xor    %ecx,%ecx
  802ce4:	89 c8                	mov    %ecx,%eax
  802ce6:	89 fa                	mov    %edi,%edx
  802ce8:	83 c4 10             	add    $0x10,%esp
  802ceb:	5e                   	pop    %esi
  802cec:	5f                   	pop    %edi
  802ced:	5d                   	pop    %ebp
  802cee:	c3                   	ret    
  802cef:	90                   	nop
  802cf0:	89 d1                	mov    %edx,%ecx
  802cf2:	89 fa                	mov    %edi,%edx
  802cf4:	89 c8                	mov    %ecx,%eax
  802cf6:	31 ff                	xor    %edi,%edi
  802cf8:	f7 f6                	div    %esi
  802cfa:	89 c1                	mov    %eax,%ecx
  802cfc:	89 fa                	mov    %edi,%edx
  802cfe:	89 c8                	mov    %ecx,%eax
  802d00:	83 c4 10             	add    $0x10,%esp
  802d03:	5e                   	pop    %esi
  802d04:	5f                   	pop    %edi
  802d05:	5d                   	pop    %ebp
  802d06:	c3                   	ret    
  802d07:	90                   	nop
  802d08:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d0c:	89 f2                	mov    %esi,%edx
  802d0e:	d3 e0                	shl    %cl,%eax
  802d10:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802d13:	b8 20 00 00 00       	mov    $0x20,%eax
  802d18:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802d1b:	89 c1                	mov    %eax,%ecx
  802d1d:	d3 ea                	shr    %cl,%edx
  802d1f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d23:	0b 55 ec             	or     -0x14(%ebp),%edx
  802d26:	d3 e6                	shl    %cl,%esi
  802d28:	89 c1                	mov    %eax,%ecx
  802d2a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802d2d:	89 fe                	mov    %edi,%esi
  802d2f:	d3 ee                	shr    %cl,%esi
  802d31:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d35:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d38:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d3b:	d3 e7                	shl    %cl,%edi
  802d3d:	89 c1                	mov    %eax,%ecx
  802d3f:	d3 ea                	shr    %cl,%edx
  802d41:	09 d7                	or     %edx,%edi
  802d43:	89 f2                	mov    %esi,%edx
  802d45:	89 f8                	mov    %edi,%eax
  802d47:	f7 75 ec             	divl   -0x14(%ebp)
  802d4a:	89 d6                	mov    %edx,%esi
  802d4c:	89 c7                	mov    %eax,%edi
  802d4e:	f7 65 e8             	mull   -0x18(%ebp)
  802d51:	39 d6                	cmp    %edx,%esi
  802d53:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802d56:	72 30                	jb     802d88 <__udivdi3+0x118>
  802d58:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802d5b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802d5f:	d3 e2                	shl    %cl,%edx
  802d61:	39 c2                	cmp    %eax,%edx
  802d63:	73 05                	jae    802d6a <__udivdi3+0xfa>
  802d65:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802d68:	74 1e                	je     802d88 <__udivdi3+0x118>
  802d6a:	89 f9                	mov    %edi,%ecx
  802d6c:	31 ff                	xor    %edi,%edi
  802d6e:	e9 71 ff ff ff       	jmp    802ce4 <__udivdi3+0x74>
  802d73:	90                   	nop
  802d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d78:	31 ff                	xor    %edi,%edi
  802d7a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802d7f:	e9 60 ff ff ff       	jmp    802ce4 <__udivdi3+0x74>
  802d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d88:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802d8b:	31 ff                	xor    %edi,%edi
  802d8d:	89 c8                	mov    %ecx,%eax
  802d8f:	89 fa                	mov    %edi,%edx
  802d91:	83 c4 10             	add    $0x10,%esp
  802d94:	5e                   	pop    %esi
  802d95:	5f                   	pop    %edi
  802d96:	5d                   	pop    %ebp
  802d97:	c3                   	ret    
	...

00802da0 <__umoddi3>:
  802da0:	55                   	push   %ebp
  802da1:	89 e5                	mov    %esp,%ebp
  802da3:	57                   	push   %edi
  802da4:	56                   	push   %esi
  802da5:	83 ec 20             	sub    $0x20,%esp
  802da8:	8b 55 14             	mov    0x14(%ebp),%edx
  802dab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802dae:	8b 7d 10             	mov    0x10(%ebp),%edi
  802db1:	8b 75 0c             	mov    0xc(%ebp),%esi
  802db4:	85 d2                	test   %edx,%edx
  802db6:	89 c8                	mov    %ecx,%eax
  802db8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802dbb:	75 13                	jne    802dd0 <__umoddi3+0x30>
  802dbd:	39 f7                	cmp    %esi,%edi
  802dbf:	76 3f                	jbe    802e00 <__umoddi3+0x60>
  802dc1:	89 f2                	mov    %esi,%edx
  802dc3:	f7 f7                	div    %edi
  802dc5:	89 d0                	mov    %edx,%eax
  802dc7:	31 d2                	xor    %edx,%edx
  802dc9:	83 c4 20             	add    $0x20,%esp
  802dcc:	5e                   	pop    %esi
  802dcd:	5f                   	pop    %edi
  802dce:	5d                   	pop    %ebp
  802dcf:	c3                   	ret    
  802dd0:	39 f2                	cmp    %esi,%edx
  802dd2:	77 4c                	ja     802e20 <__umoddi3+0x80>
  802dd4:	0f bd ca             	bsr    %edx,%ecx
  802dd7:	83 f1 1f             	xor    $0x1f,%ecx
  802dda:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802ddd:	75 51                	jne    802e30 <__umoddi3+0x90>
  802ddf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802de2:	0f 87 e0 00 00 00    	ja     802ec8 <__umoddi3+0x128>
  802de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802deb:	29 f8                	sub    %edi,%eax
  802ded:	19 d6                	sbb    %edx,%esi
  802def:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df5:	89 f2                	mov    %esi,%edx
  802df7:	83 c4 20             	add    $0x20,%esp
  802dfa:	5e                   	pop    %esi
  802dfb:	5f                   	pop    %edi
  802dfc:	5d                   	pop    %ebp
  802dfd:	c3                   	ret    
  802dfe:	66 90                	xchg   %ax,%ax
  802e00:	85 ff                	test   %edi,%edi
  802e02:	75 0b                	jne    802e0f <__umoddi3+0x6f>
  802e04:	b8 01 00 00 00       	mov    $0x1,%eax
  802e09:	31 d2                	xor    %edx,%edx
  802e0b:	f7 f7                	div    %edi
  802e0d:	89 c7                	mov    %eax,%edi
  802e0f:	89 f0                	mov    %esi,%eax
  802e11:	31 d2                	xor    %edx,%edx
  802e13:	f7 f7                	div    %edi
  802e15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e18:	f7 f7                	div    %edi
  802e1a:	eb a9                	jmp    802dc5 <__umoddi3+0x25>
  802e1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e20:	89 c8                	mov    %ecx,%eax
  802e22:	89 f2                	mov    %esi,%edx
  802e24:	83 c4 20             	add    $0x20,%esp
  802e27:	5e                   	pop    %esi
  802e28:	5f                   	pop    %edi
  802e29:	5d                   	pop    %ebp
  802e2a:	c3                   	ret    
  802e2b:	90                   	nop
  802e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802e30:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e34:	d3 e2                	shl    %cl,%edx
  802e36:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e39:	ba 20 00 00 00       	mov    $0x20,%edx
  802e3e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802e41:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802e44:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e48:	89 fa                	mov    %edi,%edx
  802e4a:	d3 ea                	shr    %cl,%edx
  802e4c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e50:	0b 55 f4             	or     -0xc(%ebp),%edx
  802e53:	d3 e7                	shl    %cl,%edi
  802e55:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e59:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802e5c:	89 f2                	mov    %esi,%edx
  802e5e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802e61:	89 c7                	mov    %eax,%edi
  802e63:	d3 ea                	shr    %cl,%edx
  802e65:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e69:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802e6c:	89 c2                	mov    %eax,%edx
  802e6e:	d3 e6                	shl    %cl,%esi
  802e70:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802e74:	d3 ea                	shr    %cl,%edx
  802e76:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e7a:	09 d6                	or     %edx,%esi
  802e7c:	89 f0                	mov    %esi,%eax
  802e7e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802e81:	d3 e7                	shl    %cl,%edi
  802e83:	89 f2                	mov    %esi,%edx
  802e85:	f7 75 f4             	divl   -0xc(%ebp)
  802e88:	89 d6                	mov    %edx,%esi
  802e8a:	f7 65 e8             	mull   -0x18(%ebp)
  802e8d:	39 d6                	cmp    %edx,%esi
  802e8f:	72 2b                	jb     802ebc <__umoddi3+0x11c>
  802e91:	39 c7                	cmp    %eax,%edi
  802e93:	72 23                	jb     802eb8 <__umoddi3+0x118>
  802e95:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802e99:	29 c7                	sub    %eax,%edi
  802e9b:	19 d6                	sbb    %edx,%esi
  802e9d:	89 f0                	mov    %esi,%eax
  802e9f:	89 f2                	mov    %esi,%edx
  802ea1:	d3 ef                	shr    %cl,%edi
  802ea3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802ea7:	d3 e0                	shl    %cl,%eax
  802ea9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ead:	09 f8                	or     %edi,%eax
  802eaf:	d3 ea                	shr    %cl,%edx
  802eb1:	83 c4 20             	add    $0x20,%esp
  802eb4:	5e                   	pop    %esi
  802eb5:	5f                   	pop    %edi
  802eb6:	5d                   	pop    %ebp
  802eb7:	c3                   	ret    
  802eb8:	39 d6                	cmp    %edx,%esi
  802eba:	75 d9                	jne    802e95 <__umoddi3+0xf5>
  802ebc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802ebf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802ec2:	eb d1                	jmp    802e95 <__umoddi3+0xf5>
  802ec4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ec8:	39 f2                	cmp    %esi,%edx
  802eca:	0f 82 18 ff ff ff    	jb     802de8 <__umoddi3+0x48>
  802ed0:	e9 1d ff ff ff       	jmp    802df2 <__umoddi3+0x52>
