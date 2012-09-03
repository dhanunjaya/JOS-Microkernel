
obj/user/idle:     file format elf32-i386


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
  80002c:	e8 1b 00 00 00       	call   80004c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800034 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(void)
{
  800034:	55                   	push   %ebp
  800035:	89 e5                	mov    %esp,%ebp
  800037:	83 ec 08             	sub    $0x8,%esp
	binaryname = "idle";
  80003a:	c7 05 00 60 80 00 00 	movl   $0x802800,0x806000
  800041:	28 80 00 
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800044:	e8 68 04 00 00       	call   8004b1 <sys_yield>
static __inline uint64_t read_tsc(void) __attribute__((always_inline));

static __inline void
breakpoint(void)
{
	__asm __volatile("int3");
  800049:	cc                   	int3   
  80004a:	eb f8                	jmp    800044 <umain+0x10>

0080004c <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80004c:	55                   	push   %ebp
  80004d:	89 e5                	mov    %esp,%ebp
  80004f:	83 ec 18             	sub    $0x18,%esp
  800052:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800055:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800058:	8b 75 08             	mov    0x8(%ebp),%esi
  80005b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  80005e:	e8 82 04 00 00       	call   8004e5 <sys_getenvid>
  800063:	25 ff 03 00 00       	and    $0x3ff,%eax
  800068:	6b c0 7c             	imul   $0x7c,%eax,%eax
  80006b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800070:	a3 74 60 80 00       	mov    %eax,0x806074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800075:	85 f6                	test   %esi,%esi
  800077:	7e 07                	jle    800080 <libmain+0x34>
		binaryname = argv[0];
  800079:	8b 03                	mov    (%ebx),%eax
  80007b:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800080:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800084:	89 34 24             	mov    %esi,(%esp)
  800087:	e8 a8 ff ff ff       	call   800034 <umain>

	// exit gracefully
	exit();
  80008c:	e8 0b 00 00 00       	call   80009c <exit>
}
  800091:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800094:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800097:	89 ec                	mov    %ebp,%esp
  800099:	5d                   	pop    %ebp
  80009a:	c3                   	ret    
	...

0080009c <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009c:	55                   	push   %ebp
  80009d:	89 e5                	mov    %esp,%ebp
  80009f:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8000a2:	e8 b4 09 00 00       	call   800a5b <close_all>
	sys_env_destroy(0);
  8000a7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8000ae:	e8 66 04 00 00       	call   800519 <sys_env_destroy>
}
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    
  8000b5:	00 00                	add    %al,(%eax)
	...

008000b8 <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  8000b8:	55                   	push   %ebp
  8000b9:	89 e5                	mov    %esp,%ebp
  8000bb:	83 ec 0c             	sub    $0xc,%esp
  8000be:	89 1c 24             	mov    %ebx,(%esp)
  8000c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000c5:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8000ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d3:	89 d1                	mov    %edx,%ecx
  8000d5:	89 d3                	mov    %edx,%ebx
  8000d7:	89 d7                	mov    %edx,%edi
  8000d9:	89 d6                	mov    %edx,%esi
  8000db:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000dd:	8b 1c 24             	mov    (%esp),%ebx
  8000e0:	8b 74 24 04          	mov    0x4(%esp),%esi
  8000e4:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8000e8:	89 ec                	mov    %ebp,%esp
  8000ea:	5d                   	pop    %ebp
  8000eb:	c3                   	ret    

008000ec <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ec:	55                   	push   %ebp
  8000ed:	89 e5                	mov    %esp,%ebp
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	89 1c 24             	mov    %ebx,(%esp)
  8000f5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8000f9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8000fd:	b8 00 00 00 00       	mov    $0x0,%eax
  800102:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800105:	8b 55 08             	mov    0x8(%ebp),%edx
  800108:	89 c3                	mov    %eax,%ebx
  80010a:	89 c7                	mov    %eax,%edi
  80010c:	89 c6                	mov    %eax,%esi
  80010e:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800110:	8b 1c 24             	mov    (%esp),%ebx
  800113:	8b 74 24 04          	mov    0x4(%esp),%esi
  800117:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80011b:	89 ec                	mov    %ebp,%esp
  80011d:	5d                   	pop    %ebp
  80011e:	c3                   	ret    

0080011f <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  80011f:	55                   	push   %ebp
  800120:	89 e5                	mov    %esp,%ebp
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	89 1c 24             	mov    %ebx,(%esp)
  800128:	89 74 24 04          	mov    %esi,0x4(%esp)
  80012c:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800130:	bb 00 00 00 00       	mov    $0x0,%ebx
  800135:	b8 10 00 00 00       	mov    $0x10,%eax
  80013a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80013d:	8b 55 08             	mov    0x8(%ebp),%edx
  800140:	89 df                	mov    %ebx,%edi
  800142:	89 de                	mov    %ebx,%esi
  800144:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800146:	8b 1c 24             	mov    (%esp),%ebx
  800149:	8b 74 24 04          	mov    0x4(%esp),%esi
  80014d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800151:	89 ec                	mov    %ebp,%esp
  800153:	5d                   	pop    %ebp
  800154:	c3                   	ret    

00800155 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  800155:	55                   	push   %ebp
  800156:	89 e5                	mov    %esp,%ebp
  800158:	83 ec 38             	sub    $0x38,%esp
  80015b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80015e:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800161:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800164:	bb 00 00 00 00       	mov    $0x0,%ebx
  800169:	b8 0f 00 00 00       	mov    $0xf,%eax
  80016e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800171:	8b 55 08             	mov    0x8(%ebp),%edx
  800174:	89 df                	mov    %ebx,%edi
  800176:	89 de                	mov    %ebx,%esi
  800178:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80017a:	85 c0                	test   %eax,%eax
  80017c:	7e 28                	jle    8001a6 <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80017e:	89 44 24 10          	mov    %eax,0x10(%esp)
  800182:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  800189:	00 
  80018a:	c7 44 24 08 1c 28 80 	movl   $0x80281c,0x8(%esp)
  800191:	00 
  800192:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800199:	00 
  80019a:	c7 04 24 39 28 80 00 	movl   $0x802839,(%esp)
  8001a1:	e8 76 17 00 00       	call   80191c <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  8001a6:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8001a9:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8001ac:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8001af:	89 ec                	mov    %ebp,%esp
  8001b1:	5d                   	pop    %ebp
  8001b2:	c3                   	ret    

008001b3 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  8001b3:	55                   	push   %ebp
  8001b4:	89 e5                	mov    %esp,%ebp
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	89 1c 24             	mov    %ebx,(%esp)
  8001bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001c0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8001c9:	b8 0e 00 00 00       	mov    $0xe,%eax
  8001ce:	89 d1                	mov    %edx,%ecx
  8001d0:	89 d3                	mov    %edx,%ebx
  8001d2:	89 d7                	mov    %edx,%edi
  8001d4:	89 d6                	mov    %edx,%esi
  8001d6:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8001d8:	8b 1c 24             	mov    (%esp),%ebx
  8001db:	8b 74 24 04          	mov    0x4(%esp),%esi
  8001df:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8001e3:	89 ec                	mov    %ebp,%esp
  8001e5:	5d                   	pop    %ebp
  8001e6:	c3                   	ret    

008001e7 <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8001e7:	55                   	push   %ebp
  8001e8:	89 e5                	mov    %esp,%ebp
  8001ea:	83 ec 38             	sub    $0x38,%esp
  8001ed:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8001f0:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8001f3:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8001f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8001fb:	b8 0d 00 00 00       	mov    $0xd,%eax
  800200:	8b 55 08             	mov    0x8(%ebp),%edx
  800203:	89 cb                	mov    %ecx,%ebx
  800205:	89 cf                	mov    %ecx,%edi
  800207:	89 ce                	mov    %ecx,%esi
  800209:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80020b:	85 c0                	test   %eax,%eax
  80020d:	7e 28                	jle    800237 <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  80020f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800213:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80021a:	00 
  80021b:	c7 44 24 08 1c 28 80 	movl   $0x80281c,0x8(%esp)
  800222:	00 
  800223:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80022a:	00 
  80022b:	c7 04 24 39 28 80 00 	movl   $0x802839,(%esp)
  800232:	e8 e5 16 00 00       	call   80191c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800237:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80023a:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80023d:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800240:	89 ec                	mov    %ebp,%esp
  800242:	5d                   	pop    %ebp
  800243:	c3                   	ret    

00800244 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	89 1c 24             	mov    %ebx,(%esp)
  80024d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800251:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800255:	be 00 00 00 00       	mov    $0x0,%esi
  80025a:	b8 0c 00 00 00       	mov    $0xc,%eax
  80025f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800262:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800265:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800268:	8b 55 08             	mov    0x8(%ebp),%edx
  80026b:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80026d:	8b 1c 24             	mov    (%esp),%ebx
  800270:	8b 74 24 04          	mov    0x4(%esp),%esi
  800274:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800278:	89 ec                	mov    %ebp,%esp
  80027a:	5d                   	pop    %ebp
  80027b:	c3                   	ret    

0080027c <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	83 ec 38             	sub    $0x38,%esp
  800282:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800285:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800288:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80028b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800290:	b8 0a 00 00 00       	mov    $0xa,%eax
  800295:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800298:	8b 55 08             	mov    0x8(%ebp),%edx
  80029b:	89 df                	mov    %ebx,%edi
  80029d:	89 de                	mov    %ebx,%esi
  80029f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8002a1:	85 c0                	test   %eax,%eax
  8002a3:	7e 28                	jle    8002cd <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8002a5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8002a9:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8002b0:	00 
  8002b1:	c7 44 24 08 1c 28 80 	movl   $0x80281c,0x8(%esp)
  8002b8:	00 
  8002b9:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8002c0:	00 
  8002c1:	c7 04 24 39 28 80 00 	movl   $0x802839,(%esp)
  8002c8:	e8 4f 16 00 00       	call   80191c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8002cd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8002d0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8002d3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8002d6:	89 ec                	mov    %ebp,%esp
  8002d8:	5d                   	pop    %ebp
  8002d9:	c3                   	ret    

008002da <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	83 ec 38             	sub    $0x38,%esp
  8002e0:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8002e3:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8002e6:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8002e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ee:	b8 09 00 00 00       	mov    $0x9,%eax
  8002f3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002f9:	89 df                	mov    %ebx,%edi
  8002fb:	89 de                	mov    %ebx,%esi
  8002fd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8002ff:	85 c0                	test   %eax,%eax
  800301:	7e 28                	jle    80032b <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800303:	89 44 24 10          	mov    %eax,0x10(%esp)
  800307:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  80030e:	00 
  80030f:	c7 44 24 08 1c 28 80 	movl   $0x80281c,0x8(%esp)
  800316:	00 
  800317:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80031e:	00 
  80031f:	c7 04 24 39 28 80 00 	movl   $0x802839,(%esp)
  800326:	e8 f1 15 00 00       	call   80191c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80032b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80032e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800331:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800334:	89 ec                	mov    %ebp,%esp
  800336:	5d                   	pop    %ebp
  800337:	c3                   	ret    

00800338 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	83 ec 38             	sub    $0x38,%esp
  80033e:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800341:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800344:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800347:	bb 00 00 00 00       	mov    $0x0,%ebx
  80034c:	b8 08 00 00 00       	mov    $0x8,%eax
  800351:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800354:	8b 55 08             	mov    0x8(%ebp),%edx
  800357:	89 df                	mov    %ebx,%edi
  800359:	89 de                	mov    %ebx,%esi
  80035b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80035d:	85 c0                	test   %eax,%eax
  80035f:	7e 28                	jle    800389 <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800361:	89 44 24 10          	mov    %eax,0x10(%esp)
  800365:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  80036c:	00 
  80036d:	c7 44 24 08 1c 28 80 	movl   $0x80281c,0x8(%esp)
  800374:	00 
  800375:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80037c:	00 
  80037d:	c7 04 24 39 28 80 00 	movl   $0x802839,(%esp)
  800384:	e8 93 15 00 00       	call   80191c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800389:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80038c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80038f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800392:	89 ec                	mov    %ebp,%esp
  800394:	5d                   	pop    %ebp
  800395:	c3                   	ret    

00800396 <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	83 ec 38             	sub    $0x38,%esp
  80039c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80039f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8003a2:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8003a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003aa:	b8 06 00 00 00       	mov    $0x6,%eax
  8003af:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003b2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b5:	89 df                	mov    %ebx,%edi
  8003b7:	89 de                	mov    %ebx,%esi
  8003b9:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8003bb:	85 c0                	test   %eax,%eax
  8003bd:	7e 28                	jle    8003e7 <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8003bf:	89 44 24 10          	mov    %eax,0x10(%esp)
  8003c3:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8003ca:	00 
  8003cb:	c7 44 24 08 1c 28 80 	movl   $0x80281c,0x8(%esp)
  8003d2:	00 
  8003d3:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8003da:	00 
  8003db:	c7 04 24 39 28 80 00 	movl   $0x802839,(%esp)
  8003e2:	e8 35 15 00 00       	call   80191c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8003e7:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8003ea:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8003ed:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8003f0:	89 ec                	mov    %ebp,%esp
  8003f2:	5d                   	pop    %ebp
  8003f3:	c3                   	ret    

008003f4 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	83 ec 38             	sub    $0x38,%esp
  8003fa:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8003fd:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800400:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800403:	b8 05 00 00 00       	mov    $0x5,%eax
  800408:	8b 75 18             	mov    0x18(%ebp),%esi
  80040b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80040e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800411:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800414:	8b 55 08             	mov    0x8(%ebp),%edx
  800417:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800419:	85 c0                	test   %eax,%eax
  80041b:	7e 28                	jle    800445 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  80041d:	89 44 24 10          	mov    %eax,0x10(%esp)
  800421:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  800428:	00 
  800429:	c7 44 24 08 1c 28 80 	movl   $0x80281c,0x8(%esp)
  800430:	00 
  800431:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800438:	00 
  800439:	c7 04 24 39 28 80 00 	movl   $0x802839,(%esp)
  800440:	e8 d7 14 00 00       	call   80191c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800445:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800448:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80044b:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80044e:	89 ec                	mov    %ebp,%esp
  800450:	5d                   	pop    %ebp
  800451:	c3                   	ret    

00800452 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800452:	55                   	push   %ebp
  800453:	89 e5                	mov    %esp,%ebp
  800455:	83 ec 38             	sub    $0x38,%esp
  800458:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80045b:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80045e:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800461:	be 00 00 00 00       	mov    $0x0,%esi
  800466:	b8 04 00 00 00       	mov    $0x4,%eax
  80046b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80046e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800471:	8b 55 08             	mov    0x8(%ebp),%edx
  800474:	89 f7                	mov    %esi,%edi
  800476:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800478:	85 c0                	test   %eax,%eax
  80047a:	7e 28                	jle    8004a4 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  80047c:	89 44 24 10          	mov    %eax,0x10(%esp)
  800480:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800487:	00 
  800488:	c7 44 24 08 1c 28 80 	movl   $0x80281c,0x8(%esp)
  80048f:	00 
  800490:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800497:	00 
  800498:	c7 04 24 39 28 80 00 	movl   $0x802839,(%esp)
  80049f:	e8 78 14 00 00       	call   80191c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8004a4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8004a7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8004aa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8004ad:	89 ec                	mov    %ebp,%esp
  8004af:	5d                   	pop    %ebp
  8004b0:	c3                   	ret    

008004b1 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8004b1:	55                   	push   %ebp
  8004b2:	89 e5                	mov    %esp,%ebp
  8004b4:	83 ec 0c             	sub    $0xc,%esp
  8004b7:	89 1c 24             	mov    %ebx,(%esp)
  8004ba:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004be:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004c7:	b8 0b 00 00 00       	mov    $0xb,%eax
  8004cc:	89 d1                	mov    %edx,%ecx
  8004ce:	89 d3                	mov    %edx,%ebx
  8004d0:	89 d7                	mov    %edx,%edi
  8004d2:	89 d6                	mov    %edx,%esi
  8004d4:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8004d6:	8b 1c 24             	mov    (%esp),%ebx
  8004d9:	8b 74 24 04          	mov    0x4(%esp),%esi
  8004dd:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8004e1:	89 ec                	mov    %ebp,%esp
  8004e3:	5d                   	pop    %ebp
  8004e4:	c3                   	ret    

008004e5 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8004e5:	55                   	push   %ebp
  8004e6:	89 e5                	mov    %esp,%ebp
  8004e8:	83 ec 0c             	sub    $0xc,%esp
  8004eb:	89 1c 24             	mov    %ebx,(%esp)
  8004ee:	89 74 24 04          	mov    %esi,0x4(%esp)
  8004f2:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8004f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8004fb:	b8 02 00 00 00       	mov    $0x2,%eax
  800500:	89 d1                	mov    %edx,%ecx
  800502:	89 d3                	mov    %edx,%ebx
  800504:	89 d7                	mov    %edx,%edi
  800506:	89 d6                	mov    %edx,%esi
  800508:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80050a:	8b 1c 24             	mov    (%esp),%ebx
  80050d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800511:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800515:	89 ec                	mov    %ebp,%esp
  800517:	5d                   	pop    %ebp
  800518:	c3                   	ret    

00800519 <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  800519:	55                   	push   %ebp
  80051a:	89 e5                	mov    %esp,%ebp
  80051c:	83 ec 38             	sub    $0x38,%esp
  80051f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800522:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800525:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800528:	b9 00 00 00 00       	mov    $0x0,%ecx
  80052d:	b8 03 00 00 00       	mov    $0x3,%eax
  800532:	8b 55 08             	mov    0x8(%ebp),%edx
  800535:	89 cb                	mov    %ecx,%ebx
  800537:	89 cf                	mov    %ecx,%edi
  800539:	89 ce                	mov    %ecx,%esi
  80053b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80053d:	85 c0                	test   %eax,%eax
  80053f:	7e 28                	jle    800569 <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800541:	89 44 24 10          	mov    %eax,0x10(%esp)
  800545:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  80054c:	00 
  80054d:	c7 44 24 08 1c 28 80 	movl   $0x80281c,0x8(%esp)
  800554:	00 
  800555:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80055c:	00 
  80055d:	c7 04 24 39 28 80 00 	movl   $0x802839,(%esp)
  800564:	e8 b3 13 00 00       	call   80191c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800569:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80056c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80056f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800572:	89 ec                	mov    %ebp,%esp
  800574:	5d                   	pop    %ebp
  800575:	c3                   	ret    
	...

00800580 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800580:	55                   	push   %ebp
  800581:	89 e5                	mov    %esp,%ebp
  800583:	8b 45 08             	mov    0x8(%ebp),%eax
  800586:	05 00 00 00 30       	add    $0x30000000,%eax
  80058b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80058e:	5d                   	pop    %ebp
  80058f:	c3                   	ret    

00800590 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  800596:	8b 45 08             	mov    0x8(%ebp),%eax
  800599:	89 04 24             	mov    %eax,(%esp)
  80059c:	e8 df ff ff ff       	call   800580 <fd2num>
  8005a1:	05 20 00 0d 00       	add    $0xd0020,%eax
  8005a6:	c1 e0 0c             	shl    $0xc,%eax
}
  8005a9:	c9                   	leave  
  8005aa:	c3                   	ret    

008005ab <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8005ab:	55                   	push   %ebp
  8005ac:	89 e5                	mov    %esp,%ebp
  8005ae:	57                   	push   %edi
  8005af:	56                   	push   %esi
  8005b0:	53                   	push   %ebx
  8005b1:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  8005b4:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  8005b9:	a8 01                	test   $0x1,%al
  8005bb:	74 36                	je     8005f3 <fd_alloc+0x48>
  8005bd:	a1 00 00 74 ef       	mov    0xef740000,%eax
  8005c2:	a8 01                	test   $0x1,%al
  8005c4:	74 2d                	je     8005f3 <fd_alloc+0x48>
  8005c6:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  8005cb:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  8005d0:	be 00 00 40 ef       	mov    $0xef400000,%esi
  8005d5:	89 c3                	mov    %eax,%ebx
  8005d7:	89 c2                	mov    %eax,%edx
  8005d9:	c1 ea 16             	shr    $0x16,%edx
  8005dc:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  8005df:	f6 c2 01             	test   $0x1,%dl
  8005e2:	74 14                	je     8005f8 <fd_alloc+0x4d>
  8005e4:	89 c2                	mov    %eax,%edx
  8005e6:	c1 ea 0c             	shr    $0xc,%edx
  8005e9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  8005ec:	f6 c2 01             	test   $0x1,%dl
  8005ef:	75 10                	jne    800601 <fd_alloc+0x56>
  8005f1:	eb 05                	jmp    8005f8 <fd_alloc+0x4d>
  8005f3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  8005f8:	89 1f                	mov    %ebx,(%edi)
  8005fa:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8005ff:	eb 17                	jmp    800618 <fd_alloc+0x6d>
  800601:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800606:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80060b:	75 c8                	jne    8005d5 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80060d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  800613:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  800618:	5b                   	pop    %ebx
  800619:	5e                   	pop    %esi
  80061a:	5f                   	pop    %edi
  80061b:	5d                   	pop    %ebp
  80061c:	c3                   	ret    

0080061d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80061d:	55                   	push   %ebp
  80061e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800620:	8b 45 08             	mov    0x8(%ebp),%eax
  800623:	83 f8 1f             	cmp    $0x1f,%eax
  800626:	77 36                	ja     80065e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800628:	05 00 00 0d 00       	add    $0xd0000,%eax
  80062d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  800630:	89 c2                	mov    %eax,%edx
  800632:	c1 ea 16             	shr    $0x16,%edx
  800635:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80063c:	f6 c2 01             	test   $0x1,%dl
  80063f:	74 1d                	je     80065e <fd_lookup+0x41>
  800641:	89 c2                	mov    %eax,%edx
  800643:	c1 ea 0c             	shr    $0xc,%edx
  800646:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80064d:	f6 c2 01             	test   $0x1,%dl
  800650:	74 0c                	je     80065e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  800652:	8b 55 0c             	mov    0xc(%ebp),%edx
  800655:	89 02                	mov    %eax,(%edx)
  800657:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80065c:	eb 05                	jmp    800663 <fd_lookup+0x46>
  80065e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800663:	5d                   	pop    %ebp
  800664:	c3                   	ret    

00800665 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  800665:	55                   	push   %ebp
  800666:	89 e5                	mov    %esp,%ebp
  800668:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80066b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80066e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	89 04 24             	mov    %eax,(%esp)
  800678:	e8 a0 ff ff ff       	call   80061d <fd_lookup>
  80067d:	85 c0                	test   %eax,%eax
  80067f:	78 0e                	js     80068f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800681:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800684:	8b 55 0c             	mov    0xc(%ebp),%edx
  800687:	89 50 04             	mov    %edx,0x4(%eax)
  80068a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80068f:	c9                   	leave  
  800690:	c3                   	ret    

00800691 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800691:	55                   	push   %ebp
  800692:	89 e5                	mov    %esp,%ebp
  800694:	56                   	push   %esi
  800695:	53                   	push   %ebx
  800696:	83 ec 10             	sub    $0x10,%esp
  800699:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80069c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80069f:	b8 04 60 80 00       	mov    $0x806004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  8006a4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8006a9:	be c4 28 80 00       	mov    $0x8028c4,%esi
		if (devtab[i]->dev_id == dev_id) {
  8006ae:	39 08                	cmp    %ecx,(%eax)
  8006b0:	75 10                	jne    8006c2 <dev_lookup+0x31>
  8006b2:	eb 04                	jmp    8006b8 <dev_lookup+0x27>
  8006b4:	39 08                	cmp    %ecx,(%eax)
  8006b6:	75 0a                	jne    8006c2 <dev_lookup+0x31>
			*dev = devtab[i];
  8006b8:	89 03                	mov    %eax,(%ebx)
  8006ba:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8006bf:	90                   	nop
  8006c0:	eb 31                	jmp    8006f3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  8006c2:	83 c2 01             	add    $0x1,%edx
  8006c5:	8b 04 96             	mov    (%esi,%edx,4),%eax
  8006c8:	85 c0                	test   %eax,%eax
  8006ca:	75 e8                	jne    8006b4 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  8006cc:	a1 74 60 80 00       	mov    0x806074,%eax
  8006d1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8006d4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8006d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006dc:	c7 04 24 48 28 80 00 	movl   $0x802848,(%esp)
  8006e3:	e8 f9 12 00 00       	call   8019e1 <cprintf>
	*dev = 0;
  8006e8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8006ee:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8006f3:	83 c4 10             	add    $0x10,%esp
  8006f6:	5b                   	pop    %ebx
  8006f7:	5e                   	pop    %esi
  8006f8:	5d                   	pop    %ebp
  8006f9:	c3                   	ret    

008006fa <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8006fa:	55                   	push   %ebp
  8006fb:	89 e5                	mov    %esp,%ebp
  8006fd:	53                   	push   %ebx
  8006fe:	83 ec 24             	sub    $0x24,%esp
  800701:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800704:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800707:	89 44 24 04          	mov    %eax,0x4(%esp)
  80070b:	8b 45 08             	mov    0x8(%ebp),%eax
  80070e:	89 04 24             	mov    %eax,(%esp)
  800711:	e8 07 ff ff ff       	call   80061d <fd_lookup>
  800716:	85 c0                	test   %eax,%eax
  800718:	78 53                	js     80076d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80071a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80071d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	89 04 24             	mov    %eax,(%esp)
  800729:	e8 63 ff ff ff       	call   800691 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80072e:	85 c0                	test   %eax,%eax
  800730:	78 3b                	js     80076d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  800732:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  80073e:	74 2d                	je     80076d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800740:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800743:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80074a:	00 00 00 
	stat->st_isdir = 0;
  80074d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800754:	00 00 00 
	stat->st_dev = dev;
  800757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80075a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800760:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800764:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800767:	89 14 24             	mov    %edx,(%esp)
  80076a:	ff 50 14             	call   *0x14(%eax)
}
  80076d:	83 c4 24             	add    $0x24,%esp
  800770:	5b                   	pop    %ebx
  800771:	5d                   	pop    %ebp
  800772:	c3                   	ret    

00800773 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  800773:	55                   	push   %ebp
  800774:	89 e5                	mov    %esp,%ebp
  800776:	53                   	push   %ebx
  800777:	83 ec 24             	sub    $0x24,%esp
  80077a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80077d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800780:	89 44 24 04          	mov    %eax,0x4(%esp)
  800784:	89 1c 24             	mov    %ebx,(%esp)
  800787:	e8 91 fe ff ff       	call   80061d <fd_lookup>
  80078c:	85 c0                	test   %eax,%eax
  80078e:	78 5f                	js     8007ef <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800790:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800793:	89 44 24 04          	mov    %eax,0x4(%esp)
  800797:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80079a:	8b 00                	mov    (%eax),%eax
  80079c:	89 04 24             	mov    %eax,(%esp)
  80079f:	e8 ed fe ff ff       	call   800691 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007a4:	85 c0                	test   %eax,%eax
  8007a6:	78 47                	js     8007ef <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8007ab:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8007af:	75 23                	jne    8007d4 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  8007b1:	a1 74 60 80 00       	mov    0x806074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8007b6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8007b9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8007bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007c1:	c7 04 24 68 28 80 00 	movl   $0x802868,(%esp)
  8007c8:	e8 14 12 00 00       	call   8019e1 <cprintf>
  8007cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  8007d2:	eb 1b                	jmp    8007ef <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  8007d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d7:	8b 48 18             	mov    0x18(%eax),%ecx
  8007da:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8007df:	85 c9                	test   %ecx,%ecx
  8007e1:	74 0c                	je     8007ef <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8007e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ea:	89 14 24             	mov    %edx,(%esp)
  8007ed:	ff d1                	call   *%ecx
}
  8007ef:	83 c4 24             	add    $0x24,%esp
  8007f2:	5b                   	pop    %ebx
  8007f3:	5d                   	pop    %ebp
  8007f4:	c3                   	ret    

008007f5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
  8007f8:	53                   	push   %ebx
  8007f9:	83 ec 24             	sub    $0x24,%esp
  8007fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007ff:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800802:	89 44 24 04          	mov    %eax,0x4(%esp)
  800806:	89 1c 24             	mov    %ebx,(%esp)
  800809:	e8 0f fe ff ff       	call   80061d <fd_lookup>
  80080e:	85 c0                	test   %eax,%eax
  800810:	78 66                	js     800878 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800812:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800815:	89 44 24 04          	mov    %eax,0x4(%esp)
  800819:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	89 04 24             	mov    %eax,(%esp)
  800821:	e8 6b fe ff ff       	call   800691 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800826:	85 c0                	test   %eax,%eax
  800828:	78 4e                	js     800878 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80082a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80082d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  800831:	75 23                	jne    800856 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  800833:	a1 74 60 80 00       	mov    0x806074,%eax
  800838:	8b 40 4c             	mov    0x4c(%eax),%eax
  80083b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80083f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800843:	c7 04 24 89 28 80 00 	movl   $0x802889,(%esp)
  80084a:	e8 92 11 00 00       	call   8019e1 <cprintf>
  80084f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  800854:	eb 22                	jmp    800878 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800859:	8b 48 0c             	mov    0xc(%eax),%ecx
  80085c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800861:	85 c9                	test   %ecx,%ecx
  800863:	74 13                	je     800878 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800865:	8b 45 10             	mov    0x10(%ebp),%eax
  800868:	89 44 24 08          	mov    %eax,0x8(%esp)
  80086c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80086f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800873:	89 14 24             	mov    %edx,(%esp)
  800876:	ff d1                	call   *%ecx
}
  800878:	83 c4 24             	add    $0x24,%esp
  80087b:	5b                   	pop    %ebx
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    

0080087e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80087e:	55                   	push   %ebp
  80087f:	89 e5                	mov    %esp,%ebp
  800881:	53                   	push   %ebx
  800882:	83 ec 24             	sub    $0x24,%esp
  800885:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800888:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80088b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80088f:	89 1c 24             	mov    %ebx,(%esp)
  800892:	e8 86 fd ff ff       	call   80061d <fd_lookup>
  800897:	85 c0                	test   %eax,%eax
  800899:	78 6b                	js     800906 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80089b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80089e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 04 24             	mov    %eax,(%esp)
  8008aa:	e8 e2 fd ff ff       	call   800691 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008af:	85 c0                	test   %eax,%eax
  8008b1:	78 53                	js     800906 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8008b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8008b6:	8b 42 08             	mov    0x8(%edx),%eax
  8008b9:	83 e0 03             	and    $0x3,%eax
  8008bc:	83 f8 01             	cmp    $0x1,%eax
  8008bf:	75 23                	jne    8008e4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  8008c1:	a1 74 60 80 00       	mov    0x806074,%eax
  8008c6:	8b 40 4c             	mov    0x4c(%eax),%eax
  8008c9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8008cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d1:	c7 04 24 a6 28 80 00 	movl   $0x8028a6,(%esp)
  8008d8:	e8 04 11 00 00       	call   8019e1 <cprintf>
  8008dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  8008e2:	eb 22                	jmp    800906 <read+0x88>
	}
	if (!dev->dev_read)
  8008e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e7:	8b 48 08             	mov    0x8(%eax),%ecx
  8008ea:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008ef:	85 c9                	test   %ecx,%ecx
  8008f1:	74 13                	je     800906 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8008f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8008f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8008fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800901:	89 14 24             	mov    %edx,(%esp)
  800904:	ff d1                	call   *%ecx
}
  800906:	83 c4 24             	add    $0x24,%esp
  800909:	5b                   	pop    %ebx
  80090a:	5d                   	pop    %ebp
  80090b:	c3                   	ret    

0080090c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	57                   	push   %edi
  800910:	56                   	push   %esi
  800911:	53                   	push   %ebx
  800912:	83 ec 1c             	sub    $0x1c,%esp
  800915:	8b 7d 08             	mov    0x8(%ebp),%edi
  800918:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80091b:	ba 00 00 00 00       	mov    $0x0,%edx
  800920:	bb 00 00 00 00       	mov    $0x0,%ebx
  800925:	b8 00 00 00 00       	mov    $0x0,%eax
  80092a:	85 f6                	test   %esi,%esi
  80092c:	74 29                	je     800957 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80092e:	89 f0                	mov    %esi,%eax
  800930:	29 d0                	sub    %edx,%eax
  800932:	89 44 24 08          	mov    %eax,0x8(%esp)
  800936:	03 55 0c             	add    0xc(%ebp),%edx
  800939:	89 54 24 04          	mov    %edx,0x4(%esp)
  80093d:	89 3c 24             	mov    %edi,(%esp)
  800940:	e8 39 ff ff ff       	call   80087e <read>
		if (m < 0)
  800945:	85 c0                	test   %eax,%eax
  800947:	78 0e                	js     800957 <readn+0x4b>
			return m;
		if (m == 0)
  800949:	85 c0                	test   %eax,%eax
  80094b:	74 08                	je     800955 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80094d:	01 c3                	add    %eax,%ebx
  80094f:	89 da                	mov    %ebx,%edx
  800951:	39 f3                	cmp    %esi,%ebx
  800953:	72 d9                	jb     80092e <readn+0x22>
  800955:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800957:	83 c4 1c             	add    $0x1c,%esp
  80095a:	5b                   	pop    %ebx
  80095b:	5e                   	pop    %esi
  80095c:	5f                   	pop    %edi
  80095d:	5d                   	pop    %ebp
  80095e:	c3                   	ret    

0080095f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80095f:	55                   	push   %ebp
  800960:	89 e5                	mov    %esp,%ebp
  800962:	56                   	push   %esi
  800963:	53                   	push   %ebx
  800964:	83 ec 20             	sub    $0x20,%esp
  800967:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80096a:	89 34 24             	mov    %esi,(%esp)
  80096d:	e8 0e fc ff ff       	call   800580 <fd2num>
  800972:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800975:	89 54 24 04          	mov    %edx,0x4(%esp)
  800979:	89 04 24             	mov    %eax,(%esp)
  80097c:	e8 9c fc ff ff       	call   80061d <fd_lookup>
  800981:	89 c3                	mov    %eax,%ebx
  800983:	85 c0                	test   %eax,%eax
  800985:	78 05                	js     80098c <fd_close+0x2d>
  800987:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80098a:	74 0c                	je     800998 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80098c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800990:	19 c0                	sbb    %eax,%eax
  800992:	f7 d0                	not    %eax
  800994:	21 c3                	and    %eax,%ebx
  800996:	eb 3d                	jmp    8009d5 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800998:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80099b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80099f:	8b 06                	mov    (%esi),%eax
  8009a1:	89 04 24             	mov    %eax,(%esp)
  8009a4:	e8 e8 fc ff ff       	call   800691 <dev_lookup>
  8009a9:	89 c3                	mov    %eax,%ebx
  8009ab:	85 c0                	test   %eax,%eax
  8009ad:	78 16                	js     8009c5 <fd_close+0x66>
		if (dev->dev_close)
  8009af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b2:	8b 40 10             	mov    0x10(%eax),%eax
  8009b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8009ba:	85 c0                	test   %eax,%eax
  8009bc:	74 07                	je     8009c5 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  8009be:	89 34 24             	mov    %esi,(%esp)
  8009c1:	ff d0                	call   *%eax
  8009c3:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  8009c5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009c9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8009d0:	e8 c1 f9 ff ff       	call   800396 <sys_page_unmap>
	return r;
}
  8009d5:	89 d8                	mov    %ebx,%eax
  8009d7:	83 c4 20             	add    $0x20,%esp
  8009da:	5b                   	pop    %ebx
  8009db:	5e                   	pop    %esi
  8009dc:	5d                   	pop    %ebp
  8009dd:	c3                   	ret    

008009de <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  8009de:	55                   	push   %ebp
  8009df:	89 e5                	mov    %esp,%ebp
  8009e1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8009e4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ee:	89 04 24             	mov    %eax,(%esp)
  8009f1:	e8 27 fc ff ff       	call   80061d <fd_lookup>
  8009f6:	85 c0                	test   %eax,%eax
  8009f8:	78 13                	js     800a0d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8009fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800a01:	00 
  800a02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a05:	89 04 24             	mov    %eax,(%esp)
  800a08:	e8 52 ff ff ff       	call   80095f <fd_close>
}
  800a0d:	c9                   	leave  
  800a0e:	c3                   	ret    

00800a0f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  800a0f:	55                   	push   %ebp
  800a10:	89 e5                	mov    %esp,%ebp
  800a12:	83 ec 18             	sub    $0x18,%esp
  800a15:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800a18:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800a1b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800a22:	00 
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	89 04 24             	mov    %eax,(%esp)
  800a29:	e8 a9 03 00 00       	call   800dd7 <open>
  800a2e:	89 c3                	mov    %eax,%ebx
  800a30:	85 c0                	test   %eax,%eax
  800a32:	78 1b                	js     800a4f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  800a34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a37:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a3b:	89 1c 24             	mov    %ebx,(%esp)
  800a3e:	e8 b7 fc ff ff       	call   8006fa <fstat>
  800a43:	89 c6                	mov    %eax,%esi
	close(fd);
  800a45:	89 1c 24             	mov    %ebx,(%esp)
  800a48:	e8 91 ff ff ff       	call   8009de <close>
  800a4d:	89 f3                	mov    %esi,%ebx
	return r;
}
  800a4f:	89 d8                	mov    %ebx,%eax
  800a51:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800a54:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800a57:	89 ec                	mov    %ebp,%esp
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    

00800a5b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	53                   	push   %ebx
  800a5f:	83 ec 14             	sub    $0x14,%esp
  800a62:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  800a67:	89 1c 24             	mov    %ebx,(%esp)
  800a6a:	e8 6f ff ff ff       	call   8009de <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800a6f:	83 c3 01             	add    $0x1,%ebx
  800a72:	83 fb 20             	cmp    $0x20,%ebx
  800a75:	75 f0                	jne    800a67 <close_all+0xc>
		close(i);
}
  800a77:	83 c4 14             	add    $0x14,%esp
  800a7a:	5b                   	pop    %ebx
  800a7b:	5d                   	pop    %ebp
  800a7c:	c3                   	ret    

00800a7d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	83 ec 58             	sub    $0x58,%esp
  800a83:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800a86:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800a89:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800a8c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800a8f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800a92:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	89 04 24             	mov    %eax,(%esp)
  800a9c:	e8 7c fb ff ff       	call   80061d <fd_lookup>
  800aa1:	89 c3                	mov    %eax,%ebx
  800aa3:	85 c0                	test   %eax,%eax
  800aa5:	0f 88 e0 00 00 00    	js     800b8b <dup+0x10e>
		return r;
	close(newfdnum);
  800aab:	89 3c 24             	mov    %edi,(%esp)
  800aae:	e8 2b ff ff ff       	call   8009de <close>

	newfd = INDEX2FD(newfdnum);
  800ab3:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  800ab9:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  800abc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800abf:	89 04 24             	mov    %eax,(%esp)
  800ac2:	e8 c9 fa ff ff       	call   800590 <fd2data>
  800ac7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800ac9:	89 34 24             	mov    %esi,(%esp)
  800acc:	e8 bf fa ff ff       	call   800590 <fd2data>
  800ad1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  800ad4:	89 da                	mov    %ebx,%edx
  800ad6:	89 d8                	mov    %ebx,%eax
  800ad8:	c1 e8 16             	shr    $0x16,%eax
  800adb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800ae2:	a8 01                	test   $0x1,%al
  800ae4:	74 43                	je     800b29 <dup+0xac>
  800ae6:	c1 ea 0c             	shr    $0xc,%edx
  800ae9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800af0:	a8 01                	test   $0x1,%al
  800af2:	74 35                	je     800b29 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  800af4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800afb:	25 07 0e 00 00       	and    $0xe07,%eax
  800b00:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b04:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b07:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b0b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800b12:	00 
  800b13:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800b17:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b1e:	e8 d1 f8 ff ff       	call   8003f4 <sys_page_map>
  800b23:	89 c3                	mov    %eax,%ebx
  800b25:	85 c0                	test   %eax,%eax
  800b27:	78 3f                	js     800b68 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  800b29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800b2c:	89 c2                	mov    %eax,%edx
  800b2e:	c1 ea 0c             	shr    $0xc,%edx
  800b31:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800b38:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  800b3e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800b42:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800b46:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800b4d:	00 
  800b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b52:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b59:	e8 96 f8 ff ff       	call   8003f4 <sys_page_map>
  800b5e:	89 c3                	mov    %eax,%ebx
  800b60:	85 c0                	test   %eax,%eax
  800b62:	78 04                	js     800b68 <dup+0xeb>
  800b64:	89 fb                	mov    %edi,%ebx
  800b66:	eb 23                	jmp    800b8b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  800b68:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b6c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b73:	e8 1e f8 ff ff       	call   800396 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800b78:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b7f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800b86:	e8 0b f8 ff ff       	call   800396 <sys_page_unmap>
	return r;
}
  800b8b:	89 d8                	mov    %ebx,%eax
  800b8d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800b90:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800b93:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b96:	89 ec                	mov    %ebp,%esp
  800b98:	5d                   	pop    %ebp
  800b99:	c3                   	ret    
	...

00800b9c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	53                   	push   %ebx
  800ba0:	83 ec 14             	sub    $0x14,%esp
  800ba3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800ba5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  800bab:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800bb2:	00 
  800bb3:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  800bba:	00 
  800bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bbf:	89 14 24             	mov    %edx,(%esp)
  800bc2:	e8 b9 18 00 00       	call   802480 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  800bc7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800bce:	00 
  800bcf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800bd3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800bda:	e8 03 19 00 00       	call   8024e2 <ipc_recv>
}
  800bdf:	83 c4 14             	add    $0x14,%esp
  800be2:	5b                   	pop    %ebx
  800be3:	5d                   	pop    %ebp
  800be4:	c3                   	ret    

00800be5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800be5:	55                   	push   %ebp
  800be6:	89 e5                	mov    %esp,%ebp
  800be8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800beb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bee:	8b 40 0c             	mov    0xc(%eax),%eax
  800bf1:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  800bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf9:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800bfe:	ba 00 00 00 00       	mov    $0x0,%edx
  800c03:	b8 02 00 00 00       	mov    $0x2,%eax
  800c08:	e8 8f ff ff ff       	call   800b9c <fsipc>
}
  800c0d:	c9                   	leave  
  800c0e:	c3                   	ret    

00800c0f <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c15:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1a:	b8 08 00 00 00       	mov    $0x8,%eax
  800c1f:	e8 78 ff ff ff       	call   800b9c <fsipc>
}
  800c24:	c9                   	leave  
  800c25:	c3                   	ret    

00800c26 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  800c26:	55                   	push   %ebp
  800c27:	89 e5                	mov    %esp,%ebp
  800c29:	53                   	push   %ebx
  800c2a:	83 ec 14             	sub    $0x14,%esp
  800c2d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	8b 40 0c             	mov    0xc(%eax),%eax
  800c36:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800c3b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c40:	b8 05 00 00 00       	mov    $0x5,%eax
  800c45:	e8 52 ff ff ff       	call   800b9c <fsipc>
  800c4a:	85 c0                	test   %eax,%eax
  800c4c:	78 2b                	js     800c79 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800c4e:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  800c55:	00 
  800c56:	89 1c 24             	mov    %ebx,(%esp)
  800c59:	e8 5c 14 00 00       	call   8020ba <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800c5e:	a1 80 30 80 00       	mov    0x803080,%eax
  800c63:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  800c69:	a1 84 30 80 00       	mov    0x803084,%eax
  800c6e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  800c74:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  800c79:	83 c4 14             	add    $0x14,%esp
  800c7c:	5b                   	pop    %ebx
  800c7d:	5d                   	pop    %ebp
  800c7e:	c3                   	ret    

00800c7f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  800c85:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800c8c:	00 
  800c8d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800c94:	00 
  800c95:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  800c9c:	e8 75 15 00 00       	call   802216 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	8b 40 0c             	mov    0xc(%eax),%eax
  800ca7:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  800cac:	ba 00 00 00 00       	mov    $0x0,%edx
  800cb1:	b8 06 00 00 00       	mov    $0x6,%eax
  800cb6:	e8 e1 fe ff ff       	call   800b9c <fsipc>
}
  800cbb:	c9                   	leave  
  800cbc:	c3                   	ret    

00800cbd <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  800cbd:	55                   	push   %ebp
  800cbe:	89 e5                	mov    %esp,%ebp
  800cc0:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  800cc3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800cca:	00 
  800ccb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800cd2:	00 
  800cd3:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  800cda:	e8 37 15 00 00       	call   802216 <memset>
  800cdf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ce2:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  800ce7:	76 05                	jbe    800cee <devfile_write+0x31>
  800ce9:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  800cee:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf1:	8b 52 0c             	mov    0xc(%edx),%edx
  800cf4:	89 15 00 30 80 00    	mov    %edx,0x803000
        fsipcbuf.write.req_n = numberOfBytes;
  800cfa:	a3 04 30 80 00       	mov    %eax,0x803004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  800cff:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d06:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d0a:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  800d11:	e8 5f 15 00 00       	call   802275 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  800d16:	ba 00 00 00 00       	mov    $0x0,%edx
  800d1b:	b8 04 00 00 00       	mov    $0x4,%eax
  800d20:	e8 77 fe ff ff       	call   800b9c <fsipc>
              return r;
        return r;
}
  800d25:	c9                   	leave  
  800d26:	c3                   	ret    

00800d27 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	53                   	push   %ebx
  800d2b:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  800d2e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800d35:	00 
  800d36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800d3d:	00 
  800d3e:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  800d45:	e8 cc 14 00 00       	call   802216 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  800d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4d:	8b 40 0c             	mov    0xc(%eax),%eax
  800d50:	a3 00 30 80 00       	mov    %eax,0x803000
        fsipcbuf.read.req_n = n;
  800d55:	8b 45 10             	mov    0x10(%ebp),%eax
  800d58:	a3 04 30 80 00       	mov    %eax,0x803004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  800d5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800d62:	b8 03 00 00 00       	mov    $0x3,%eax
  800d67:	e8 30 fe ff ff       	call   800b9c <fsipc>
  800d6c:	89 c3                	mov    %eax,%ebx
  800d6e:	85 c0                	test   %eax,%eax
  800d70:	78 17                	js     800d89 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  800d72:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d76:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  800d7d:	00 
  800d7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d81:	89 04 24             	mov    %eax,(%esp)
  800d84:	e8 ec 14 00 00       	call   802275 <memmove>
        return r;
}
  800d89:	89 d8                	mov    %ebx,%eax
  800d8b:	83 c4 14             	add    $0x14,%esp
  800d8e:	5b                   	pop    %ebx
  800d8f:	5d                   	pop    %ebp
  800d90:	c3                   	ret    

00800d91 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	53                   	push   %ebx
  800d95:	83 ec 14             	sub    $0x14,%esp
  800d98:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  800d9b:	89 1c 24             	mov    %ebx,(%esp)
  800d9e:	e8 cd 12 00 00       	call   802070 <strlen>
  800da3:	89 c2                	mov    %eax,%edx
  800da5:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  800daa:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  800db0:	7f 1f                	jg     800dd1 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  800db2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800db6:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  800dbd:	e8 f8 12 00 00       	call   8020ba <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  800dc2:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc7:	b8 07 00 00 00       	mov    $0x7,%eax
  800dcc:	e8 cb fd ff ff       	call   800b9c <fsipc>
}
  800dd1:	83 c4 14             	add    $0x14,%esp
  800dd4:	5b                   	pop    %ebx
  800dd5:	5d                   	pop    %ebp
  800dd6:	c3                   	ret    

00800dd7 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  800dd7:	55                   	push   %ebp
  800dd8:	89 e5                	mov    %esp,%ebp
  800dda:	56                   	push   %esi
  800ddb:	53                   	push   %ebx
  800ddc:	83 ec 20             	sub    $0x20,%esp
  800ddf:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  800de2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  800de9:	00 
  800dea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800df1:	00 
  800df2:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  800df9:	e8 18 14 00 00       	call   802216 <memset>
    if(strlen(path)>=MAXPATHLEN)
  800dfe:	89 34 24             	mov    %esi,(%esp)
  800e01:	e8 6a 12 00 00       	call   802070 <strlen>
  800e06:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800e0b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800e10:	0f 8f 84 00 00 00    	jg     800e9a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  800e16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e19:	89 04 24             	mov    %eax,(%esp)
  800e1c:	e8 8a f7 ff ff       	call   8005ab <fd_alloc>
  800e21:	89 c3                	mov    %eax,%ebx
  800e23:	85 c0                	test   %eax,%eax
  800e25:	78 73                	js     800e9a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  800e27:	0f b6 06             	movzbl (%esi),%eax
  800e2a:	84 c0                	test   %al,%al
  800e2c:	74 20                	je     800e4e <open+0x77>
  800e2e:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  800e30:	0f be c0             	movsbl %al,%eax
  800e33:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e37:	c7 04 24 d8 28 80 00 	movl   $0x8028d8,(%esp)
  800e3e:	e8 9e 0b 00 00       	call   8019e1 <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  800e43:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  800e47:	83 c3 01             	add    $0x1,%ebx
  800e4a:	84 c0                	test   %al,%al
  800e4c:	75 e2                	jne    800e30 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  800e4e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e52:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  800e59:	e8 5c 12 00 00       	call   8020ba <strcpy>
    fsipcbuf.open.req_omode = mode;
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	a3 00 34 80 00       	mov    %eax,0x803400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  800e66:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e69:	b8 01 00 00 00       	mov    $0x1,%eax
  800e6e:	e8 29 fd ff ff       	call   800b9c <fsipc>
  800e73:	89 c3                	mov    %eax,%ebx
  800e75:	85 c0                	test   %eax,%eax
  800e77:	79 15                	jns    800e8e <open+0xb7>
        {
            fd_close(fd,1);
  800e79:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800e80:	00 
  800e81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e84:	89 04 24             	mov    %eax,(%esp)
  800e87:	e8 d3 fa ff ff       	call   80095f <fd_close>
             return r;
  800e8c:	eb 0c                	jmp    800e9a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  800e8e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800e91:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  800e97:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  800e9a:	89 d8                	mov    %ebx,%eax
  800e9c:	83 c4 20             	add    $0x20,%esp
  800e9f:	5b                   	pop    %ebx
  800ea0:	5e                   	pop    %esi
  800ea1:	5d                   	pop    %ebp
  800ea2:	c3                   	ret    
	...

00800eb0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  800eb0:	55                   	push   %ebp
  800eb1:	89 e5                	mov    %esp,%ebp
  800eb3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  800eb6:	c7 44 24 04 db 28 80 	movl   $0x8028db,0x4(%esp)
  800ebd:	00 
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	89 04 24             	mov    %eax,(%esp)
  800ec4:	e8 f1 11 00 00       	call   8020ba <strcpy>
	return 0;
}
  800ec9:	b8 00 00 00 00       	mov    $0x0,%eax
  800ece:	c9                   	leave  
  800ecf:	c3                   	ret    

00800ed0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  800ed0:	55                   	push   %ebp
  800ed1:	89 e5                	mov    %esp,%ebp
  800ed3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	8b 40 0c             	mov    0xc(%eax),%eax
  800edc:	89 04 24             	mov    %eax,(%esp)
  800edf:	e8 9e 02 00 00       	call   801182 <nsipc_close>
}
  800ee4:	c9                   	leave  
  800ee5:	c3                   	ret    

00800ee6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
  800ee9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  800eec:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800ef3:	00 
  800ef4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efe:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
  800f05:	8b 40 0c             	mov    0xc(%eax),%eax
  800f08:	89 04 24             	mov    %eax,(%esp)
  800f0b:	e8 ae 02 00 00       	call   8011be <nsipc_send>
}
  800f10:	c9                   	leave  
  800f11:	c3                   	ret    

00800f12 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  800f18:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  800f1f:	00 
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8b 40 0c             	mov    0xc(%eax),%eax
  800f34:	89 04 24             	mov    %eax,(%esp)
  800f37:	e8 f5 02 00 00       	call   801231 <nsipc_recv>
}
  800f3c:	c9                   	leave  
  800f3d:	c3                   	ret    

00800f3e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	56                   	push   %esi
  800f42:	53                   	push   %ebx
  800f43:	83 ec 20             	sub    $0x20,%esp
  800f46:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800f48:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f4b:	89 04 24             	mov    %eax,(%esp)
  800f4e:	e8 58 f6 ff ff       	call   8005ab <fd_alloc>
  800f53:	89 c3                	mov    %eax,%ebx
  800f55:	85 c0                	test   %eax,%eax
  800f57:	78 21                	js     800f7a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  800f59:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800f60:	00 
  800f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f64:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f68:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f6f:	e8 de f4 ff ff       	call   800452 <sys_page_alloc>
  800f74:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  800f76:	85 c0                	test   %eax,%eax
  800f78:	79 0a                	jns    800f84 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  800f7a:	89 34 24             	mov    %esi,(%esp)
  800f7d:	e8 00 02 00 00       	call   801182 <nsipc_close>
		return r;
  800f82:	eb 28                	jmp    800fac <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  800f84:	8b 15 20 60 80 00    	mov    0x806020,%edx
  800f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f8d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  800f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f92:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  800f99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f9c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  800f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa2:	89 04 24             	mov    %eax,(%esp)
  800fa5:	e8 d6 f5 ff ff       	call   800580 <fd2num>
  800faa:	89 c3                	mov    %eax,%ebx
}
  800fac:	89 d8                	mov    %ebx,%eax
  800fae:	83 c4 20             	add    $0x20,%esp
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5d                   	pop    %ebp
  800fb4:	c3                   	ret    

00800fb5 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  800fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  800fbe:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	89 04 24             	mov    %eax,(%esp)
  800fcf:	e8 62 01 00 00       	call   801136 <nsipc_socket>
  800fd4:	85 c0                	test   %eax,%eax
  800fd6:	78 05                	js     800fdd <socket+0x28>
		return r;
	return alloc_sockfd(r);
  800fd8:	e8 61 ff ff ff       	call   800f3e <alloc_sockfd>
}
  800fdd:	c9                   	leave  
  800fde:	66 90                	xchg   %ax,%ax
  800fe0:	c3                   	ret    

00800fe1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  800fe1:	55                   	push   %ebp
  800fe2:	89 e5                	mov    %esp,%ebp
  800fe4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  800fe7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800fea:	89 54 24 04          	mov    %edx,0x4(%esp)
  800fee:	89 04 24             	mov    %eax,(%esp)
  800ff1:	e8 27 f6 ff ff       	call   80061d <fd_lookup>
  800ff6:	85 c0                	test   %eax,%eax
  800ff8:	78 15                	js     80100f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  800ffa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ffd:	8b 0a                	mov    (%edx),%ecx
  800fff:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801004:	3b 0d 20 60 80 00    	cmp    0x806020,%ecx
  80100a:	75 03                	jne    80100f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80100c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  80100f:	c9                   	leave  
  801010:	c3                   	ret    

00801011 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801011:	55                   	push   %ebp
  801012:	89 e5                	mov    %esp,%ebp
  801014:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	e8 c2 ff ff ff       	call   800fe1 <fd2sockid>
  80101f:	85 c0                	test   %eax,%eax
  801021:	78 0f                	js     801032 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801023:	8b 55 0c             	mov    0xc(%ebp),%edx
  801026:	89 54 24 04          	mov    %edx,0x4(%esp)
  80102a:	89 04 24             	mov    %eax,(%esp)
  80102d:	e8 2e 01 00 00       	call   801160 <nsipc_listen>
}
  801032:	c9                   	leave  
  801033:	c3                   	ret    

00801034 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801034:	55                   	push   %ebp
  801035:	89 e5                	mov    %esp,%ebp
  801037:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	e8 9f ff ff ff       	call   800fe1 <fd2sockid>
  801042:	85 c0                	test   %eax,%eax
  801044:	78 16                	js     80105c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801046:	8b 55 10             	mov    0x10(%ebp),%edx
  801049:	89 54 24 08          	mov    %edx,0x8(%esp)
  80104d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801050:	89 54 24 04          	mov    %edx,0x4(%esp)
  801054:	89 04 24             	mov    %eax,(%esp)
  801057:	e8 55 02 00 00       	call   8012b1 <nsipc_connect>
}
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    

0080105e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	e8 75 ff ff ff       	call   800fe1 <fd2sockid>
  80106c:	85 c0                	test   %eax,%eax
  80106e:	78 0f                	js     80107f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801070:	8b 55 0c             	mov    0xc(%ebp),%edx
  801073:	89 54 24 04          	mov    %edx,0x4(%esp)
  801077:	89 04 24             	mov    %eax,(%esp)
  80107a:	e8 1d 01 00 00       	call   80119c <nsipc_shutdown>
}
  80107f:	c9                   	leave  
  801080:	c3                   	ret    

00801081 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801081:	55                   	push   %ebp
  801082:	89 e5                	mov    %esp,%ebp
  801084:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	e8 52 ff ff ff       	call   800fe1 <fd2sockid>
  80108f:	85 c0                	test   %eax,%eax
  801091:	78 16                	js     8010a9 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801093:	8b 55 10             	mov    0x10(%ebp),%edx
  801096:	89 54 24 08          	mov    %edx,0x8(%esp)
  80109a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80109d:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010a1:	89 04 24             	mov    %eax,(%esp)
  8010a4:	e8 47 02 00 00       	call   8012f0 <nsipc_bind>
}
  8010a9:	c9                   	leave  
  8010aa:	c3                   	ret    

008010ab <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8010ab:	55                   	push   %ebp
  8010ac:	89 e5                	mov    %esp,%ebp
  8010ae:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	e8 28 ff ff ff       	call   800fe1 <fd2sockid>
  8010b9:	85 c0                	test   %eax,%eax
  8010bb:	78 1f                	js     8010dc <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8010bd:	8b 55 10             	mov    0x10(%ebp),%edx
  8010c0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8010c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010c7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8010cb:	89 04 24             	mov    %eax,(%esp)
  8010ce:	e8 5c 02 00 00       	call   80132f <nsipc_accept>
  8010d3:	85 c0                	test   %eax,%eax
  8010d5:	78 05                	js     8010dc <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8010d7:	e8 62 fe ff ff       	call   800f3e <alloc_sockfd>
}
  8010dc:	c9                   	leave  
  8010dd:	8d 76 00             	lea    0x0(%esi),%esi
  8010e0:	c3                   	ret    
	...

008010f0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
  8010f3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8010f6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8010fc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801103:	00 
  801104:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  80110b:	00 
  80110c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801110:	89 14 24             	mov    %edx,(%esp)
  801113:	e8 68 13 00 00       	call   802480 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801118:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80111f:	00 
  801120:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801127:	00 
  801128:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80112f:	e8 ae 13 00 00       	call   8024e2 <ipc_recv>
}
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80113c:	8b 45 08             	mov    0x8(%ebp),%eax
  80113f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801144:	8b 45 0c             	mov    0xc(%ebp),%eax
  801147:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  80114c:	8b 45 10             	mov    0x10(%ebp),%eax
  80114f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801154:	b8 09 00 00 00       	mov    $0x9,%eax
  801159:	e8 92 ff ff ff       	call   8010f0 <nsipc>
}
  80115e:	c9                   	leave  
  80115f:	c3                   	ret    

00801160 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
  801163:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  80116e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801171:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801176:	b8 06 00 00 00       	mov    $0x6,%eax
  80117b:	e8 70 ff ff ff       	call   8010f0 <nsipc>
}
  801180:	c9                   	leave  
  801181:	c3                   	ret    

00801182 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801182:	55                   	push   %ebp
  801183:	89 e5                	mov    %esp,%ebp
  801185:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801190:	b8 04 00 00 00       	mov    $0x4,%eax
  801195:	e8 56 ff ff ff       	call   8010f0 <nsipc>
}
  80119a:	c9                   	leave  
  80119b:	c3                   	ret    

0080119c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8011a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a5:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  8011b2:	b8 03 00 00 00       	mov    $0x3,%eax
  8011b7:	e8 34 ff ff ff       	call   8010f0 <nsipc>
}
  8011bc:	c9                   	leave  
  8011bd:	c3                   	ret    

008011be <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	53                   	push   %ebx
  8011c2:	83 ec 14             	sub    $0x14,%esp
  8011c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8011c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cb:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  8011d0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8011d6:	7e 24                	jle    8011fc <nsipc_send+0x3e>
  8011d8:	c7 44 24 0c e7 28 80 	movl   $0x8028e7,0xc(%esp)
  8011df:	00 
  8011e0:	c7 44 24 08 f3 28 80 	movl   $0x8028f3,0x8(%esp)
  8011e7:	00 
  8011e8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8011ef:	00 
  8011f0:	c7 04 24 08 29 80 00 	movl   $0x802908,(%esp)
  8011f7:	e8 20 07 00 00       	call   80191c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8011fc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801200:	8b 45 0c             	mov    0xc(%ebp),%eax
  801203:	89 44 24 04          	mov    %eax,0x4(%esp)
  801207:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  80120e:	e8 62 10 00 00       	call   802275 <memmove>
	nsipcbuf.send.req_size = size;
  801213:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  801219:	8b 45 14             	mov    0x14(%ebp),%eax
  80121c:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  801221:	b8 08 00 00 00       	mov    $0x8,%eax
  801226:	e8 c5 fe ff ff       	call   8010f0 <nsipc>
}
  80122b:	83 c4 14             	add    $0x14,%esp
  80122e:	5b                   	pop    %ebx
  80122f:	5d                   	pop    %ebp
  801230:	c3                   	ret    

00801231 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801231:	55                   	push   %ebp
  801232:	89 e5                	mov    %esp,%ebp
  801234:	56                   	push   %esi
  801235:	53                   	push   %ebx
  801236:	83 ec 10             	sub    $0x10,%esp
  801239:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80123c:	8b 45 08             	mov    0x8(%ebp),%eax
  80123f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  801244:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  80124a:	8b 45 14             	mov    0x14(%ebp),%eax
  80124d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801252:	b8 07 00 00 00       	mov    $0x7,%eax
  801257:	e8 94 fe ff ff       	call   8010f0 <nsipc>
  80125c:	89 c3                	mov    %eax,%ebx
  80125e:	85 c0                	test   %eax,%eax
  801260:	78 46                	js     8012a8 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801262:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801267:	7f 04                	jg     80126d <nsipc_recv+0x3c>
  801269:	39 c6                	cmp    %eax,%esi
  80126b:	7d 24                	jge    801291 <nsipc_recv+0x60>
  80126d:	c7 44 24 0c 14 29 80 	movl   $0x802914,0xc(%esp)
  801274:	00 
  801275:	c7 44 24 08 f3 28 80 	movl   $0x8028f3,0x8(%esp)
  80127c:	00 
  80127d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801284:	00 
  801285:	c7 04 24 08 29 80 00 	movl   $0x802908,(%esp)
  80128c:	e8 8b 06 00 00       	call   80191c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801291:	89 44 24 08          	mov    %eax,0x8(%esp)
  801295:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80129c:	00 
  80129d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012a0:	89 04 24             	mov    %eax,(%esp)
  8012a3:	e8 cd 0f 00 00       	call   802275 <memmove>
	}

	return r;
}
  8012a8:	89 d8                	mov    %ebx,%eax
  8012aa:	83 c4 10             	add    $0x10,%esp
  8012ad:	5b                   	pop    %ebx
  8012ae:	5e                   	pop    %esi
  8012af:	5d                   	pop    %ebp
  8012b0:	c3                   	ret    

008012b1 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	53                   	push   %ebx
  8012b5:	83 ec 14             	sub    $0x14,%esp
  8012b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8012c3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8012c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ce:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8012d5:	e8 9b 0f 00 00       	call   802275 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8012da:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  8012e0:	b8 05 00 00 00       	mov    $0x5,%eax
  8012e5:	e8 06 fe ff ff       	call   8010f0 <nsipc>
}
  8012ea:	83 c4 14             	add    $0x14,%esp
  8012ed:	5b                   	pop    %ebx
  8012ee:	5d                   	pop    %ebp
  8012ef:	c3                   	ret    

008012f0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8012f0:	55                   	push   %ebp
  8012f1:	89 e5                	mov    %esp,%ebp
  8012f3:	53                   	push   %ebx
  8012f4:	83 ec 14             	sub    $0x14,%esp
  8012f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  801302:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801306:	8b 45 0c             	mov    0xc(%ebp),%eax
  801309:	89 44 24 04          	mov    %eax,0x4(%esp)
  80130d:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  801314:	e8 5c 0f 00 00       	call   802275 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801319:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  80131f:	b8 02 00 00 00       	mov    $0x2,%eax
  801324:	e8 c7 fd ff ff       	call   8010f0 <nsipc>
}
  801329:	83 c4 14             	add    $0x14,%esp
  80132c:	5b                   	pop    %ebx
  80132d:	5d                   	pop    %ebp
  80132e:	c3                   	ret    

0080132f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80132f:	55                   	push   %ebp
  801330:	89 e5                	mov    %esp,%ebp
  801332:	83 ec 18             	sub    $0x18,%esp
  801335:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801338:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80133b:	8b 45 08             	mov    0x8(%ebp),%eax
  80133e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801343:	b8 01 00 00 00       	mov    $0x1,%eax
  801348:	e8 a3 fd ff ff       	call   8010f0 <nsipc>
  80134d:	89 c3                	mov    %eax,%ebx
  80134f:	85 c0                	test   %eax,%eax
  801351:	78 25                	js     801378 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801353:	be 10 50 80 00       	mov    $0x805010,%esi
  801358:	8b 06                	mov    (%esi),%eax
  80135a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80135e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801365:	00 
  801366:	8b 45 0c             	mov    0xc(%ebp),%eax
  801369:	89 04 24             	mov    %eax,(%esp)
  80136c:	e8 04 0f 00 00       	call   802275 <memmove>
		*addrlen = ret->ret_addrlen;
  801371:	8b 16                	mov    (%esi),%edx
  801373:	8b 45 10             	mov    0x10(%ebp),%eax
  801376:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  801378:	89 d8                	mov    %ebx,%eax
  80137a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80137d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801380:	89 ec                	mov    %ebp,%esp
  801382:	5d                   	pop    %ebp
  801383:	c3                   	ret    
	...

00801390 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801390:	55                   	push   %ebp
  801391:	89 e5                	mov    %esp,%ebp
  801393:	83 ec 18             	sub    $0x18,%esp
  801396:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801399:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80139c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	89 04 24             	mov    %eax,(%esp)
  8013a5:	e8 e6 f1 ff ff       	call   800590 <fd2data>
  8013aa:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8013ac:	c7 44 24 04 29 29 80 	movl   $0x802929,0x4(%esp)
  8013b3:	00 
  8013b4:	89 34 24             	mov    %esi,(%esp)
  8013b7:	e8 fe 0c 00 00       	call   8020ba <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8013bc:	8b 43 04             	mov    0x4(%ebx),%eax
  8013bf:	2b 03                	sub    (%ebx),%eax
  8013c1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8013c7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8013ce:	00 00 00 
	stat->st_dev = &devpipe;
  8013d1:	c7 86 88 00 00 00 3c 	movl   $0x80603c,0x88(%esi)
  8013d8:	60 80 00 
	return 0;
}
  8013db:	b8 00 00 00 00       	mov    $0x0,%eax
  8013e0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8013e3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8013e6:	89 ec                	mov    %ebp,%esp
  8013e8:	5d                   	pop    %ebp
  8013e9:	c3                   	ret    

008013ea <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8013ea:	55                   	push   %ebp
  8013eb:	89 e5                	mov    %esp,%ebp
  8013ed:	53                   	push   %ebx
  8013ee:	83 ec 14             	sub    $0x14,%esp
  8013f1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8013f4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8013f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8013ff:	e8 92 ef ff ff       	call   800396 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801404:	89 1c 24             	mov    %ebx,(%esp)
  801407:	e8 84 f1 ff ff       	call   800590 <fd2data>
  80140c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801410:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801417:	e8 7a ef ff ff       	call   800396 <sys_page_unmap>
}
  80141c:	83 c4 14             	add    $0x14,%esp
  80141f:	5b                   	pop    %ebx
  801420:	5d                   	pop    %ebp
  801421:	c3                   	ret    

00801422 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	57                   	push   %edi
  801426:	56                   	push   %esi
  801427:	53                   	push   %ebx
  801428:	83 ec 2c             	sub    $0x2c,%esp
  80142b:	89 c7                	mov    %eax,%edi
  80142d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801430:	a1 74 60 80 00       	mov    0x806074,%eax
  801435:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801438:	89 3c 24             	mov    %edi,(%esp)
  80143b:	e8 08 11 00 00       	call   802548 <pageref>
  801440:	89 c6                	mov    %eax,%esi
  801442:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801445:	89 04 24             	mov    %eax,(%esp)
  801448:	e8 fb 10 00 00       	call   802548 <pageref>
  80144d:	39 c6                	cmp    %eax,%esi
  80144f:	0f 94 c0             	sete   %al
  801452:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  801455:	8b 15 74 60 80 00    	mov    0x806074,%edx
  80145b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80145e:	39 cb                	cmp    %ecx,%ebx
  801460:	75 08                	jne    80146a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  801462:	83 c4 2c             	add    $0x2c,%esp
  801465:	5b                   	pop    %ebx
  801466:	5e                   	pop    %esi
  801467:	5f                   	pop    %edi
  801468:	5d                   	pop    %ebp
  801469:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80146a:	83 f8 01             	cmp    $0x1,%eax
  80146d:	75 c1                	jne    801430 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80146f:	8b 52 58             	mov    0x58(%edx),%edx
  801472:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801476:	89 54 24 08          	mov    %edx,0x8(%esp)
  80147a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80147e:	c7 04 24 30 29 80 00 	movl   $0x802930,(%esp)
  801485:	e8 57 05 00 00       	call   8019e1 <cprintf>
  80148a:	eb a4                	jmp    801430 <_pipeisclosed+0xe>

0080148c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	57                   	push   %edi
  801490:	56                   	push   %esi
  801491:	53                   	push   %ebx
  801492:	83 ec 1c             	sub    $0x1c,%esp
  801495:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801498:	89 34 24             	mov    %esi,(%esp)
  80149b:	e8 f0 f0 ff ff       	call   800590 <fd2data>
  8014a0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014a2:	bf 00 00 00 00       	mov    $0x0,%edi
  8014a7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ab:	75 54                	jne    801501 <devpipe_write+0x75>
  8014ad:	eb 60                	jmp    80150f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8014af:	89 da                	mov    %ebx,%edx
  8014b1:	89 f0                	mov    %esi,%eax
  8014b3:	e8 6a ff ff ff       	call   801422 <_pipeisclosed>
  8014b8:	85 c0                	test   %eax,%eax
  8014ba:	74 07                	je     8014c3 <devpipe_write+0x37>
  8014bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c1:	eb 53                	jmp    801516 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8014c3:	90                   	nop
  8014c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8014c8:	e8 e4 ef ff ff       	call   8004b1 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8014cd:	8b 43 04             	mov    0x4(%ebx),%eax
  8014d0:	8b 13                	mov    (%ebx),%edx
  8014d2:	83 c2 20             	add    $0x20,%edx
  8014d5:	39 d0                	cmp    %edx,%eax
  8014d7:	73 d6                	jae    8014af <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8014d9:	89 c2                	mov    %eax,%edx
  8014db:	c1 fa 1f             	sar    $0x1f,%edx
  8014de:	c1 ea 1b             	shr    $0x1b,%edx
  8014e1:	01 d0                	add    %edx,%eax
  8014e3:	83 e0 1f             	and    $0x1f,%eax
  8014e6:	29 d0                	sub    %edx,%eax
  8014e8:	89 c2                	mov    %eax,%edx
  8014ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014ed:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8014f1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8014f5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8014f9:	83 c7 01             	add    $0x1,%edi
  8014fc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8014ff:	76 13                	jbe    801514 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801501:	8b 43 04             	mov    0x4(%ebx),%eax
  801504:	8b 13                	mov    (%ebx),%edx
  801506:	83 c2 20             	add    $0x20,%edx
  801509:	39 d0                	cmp    %edx,%eax
  80150b:	73 a2                	jae    8014af <devpipe_write+0x23>
  80150d:	eb ca                	jmp    8014d9 <devpipe_write+0x4d>
  80150f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  801514:	89 f8                	mov    %edi,%eax
}
  801516:	83 c4 1c             	add    $0x1c,%esp
  801519:	5b                   	pop    %ebx
  80151a:	5e                   	pop    %esi
  80151b:	5f                   	pop    %edi
  80151c:	5d                   	pop    %ebp
  80151d:	c3                   	ret    

0080151e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  80151e:	55                   	push   %ebp
  80151f:	89 e5                	mov    %esp,%ebp
  801521:	83 ec 28             	sub    $0x28,%esp
  801524:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801527:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80152a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80152d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801530:	89 3c 24             	mov    %edi,(%esp)
  801533:	e8 58 f0 ff ff       	call   800590 <fd2data>
  801538:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80153a:	be 00 00 00 00       	mov    $0x0,%esi
  80153f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801543:	75 4c                	jne    801591 <devpipe_read+0x73>
  801545:	eb 5b                	jmp    8015a2 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801547:	89 f0                	mov    %esi,%eax
  801549:	eb 5e                	jmp    8015a9 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80154b:	89 da                	mov    %ebx,%edx
  80154d:	89 f8                	mov    %edi,%eax
  80154f:	90                   	nop
  801550:	e8 cd fe ff ff       	call   801422 <_pipeisclosed>
  801555:	85 c0                	test   %eax,%eax
  801557:	74 07                	je     801560 <devpipe_read+0x42>
  801559:	b8 00 00 00 00       	mov    $0x0,%eax
  80155e:	eb 49                	jmp    8015a9 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801560:	e8 4c ef ff ff       	call   8004b1 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801565:	8b 03                	mov    (%ebx),%eax
  801567:	3b 43 04             	cmp    0x4(%ebx),%eax
  80156a:	74 df                	je     80154b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80156c:	89 c2                	mov    %eax,%edx
  80156e:	c1 fa 1f             	sar    $0x1f,%edx
  801571:	c1 ea 1b             	shr    $0x1b,%edx
  801574:	01 d0                	add    %edx,%eax
  801576:	83 e0 1f             	and    $0x1f,%eax
  801579:	29 d0                	sub    %edx,%eax
  80157b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801580:	8b 55 0c             	mov    0xc(%ebp),%edx
  801583:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801586:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801589:	83 c6 01             	add    $0x1,%esi
  80158c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80158f:	76 16                	jbe    8015a7 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  801591:	8b 03                	mov    (%ebx),%eax
  801593:	3b 43 04             	cmp    0x4(%ebx),%eax
  801596:	75 d4                	jne    80156c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801598:	85 f6                	test   %esi,%esi
  80159a:	75 ab                	jne    801547 <devpipe_read+0x29>
  80159c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8015a0:	eb a9                	jmp    80154b <devpipe_read+0x2d>
  8015a2:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  8015a7:	89 f0                	mov    %esi,%eax
}
  8015a9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8015ac:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8015af:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8015b2:	89 ec                	mov    %ebp,%esp
  8015b4:	5d                   	pop    %ebp
  8015b5:	c3                   	ret    

008015b6 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  8015b6:	55                   	push   %ebp
  8015b7:	89 e5                	mov    %esp,%ebp
  8015b9:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	89 04 24             	mov    %eax,(%esp)
  8015c9:	e8 4f f0 ff ff       	call   80061d <fd_lookup>
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	78 15                	js     8015e7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8015d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015d5:	89 04 24             	mov    %eax,(%esp)
  8015d8:	e8 b3 ef ff ff       	call   800590 <fd2data>
	return _pipeisclosed(fd, p);
  8015dd:	89 c2                	mov    %eax,%edx
  8015df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e2:	e8 3b fe ff ff       	call   801422 <_pipeisclosed>
}
  8015e7:	c9                   	leave  
  8015e8:	c3                   	ret    

008015e9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8015e9:	55                   	push   %ebp
  8015ea:	89 e5                	mov    %esp,%ebp
  8015ec:	83 ec 48             	sub    $0x48,%esp
  8015ef:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8015f2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8015f5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8015f8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8015fb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015fe:	89 04 24             	mov    %eax,(%esp)
  801601:	e8 a5 ef ff ff       	call   8005ab <fd_alloc>
  801606:	89 c3                	mov    %eax,%ebx
  801608:	85 c0                	test   %eax,%eax
  80160a:	0f 88 42 01 00 00    	js     801752 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801610:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801617:	00 
  801618:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80161b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801626:	e8 27 ee ff ff       	call   800452 <sys_page_alloc>
  80162b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80162d:	85 c0                	test   %eax,%eax
  80162f:	0f 88 1d 01 00 00    	js     801752 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801635:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801638:	89 04 24             	mov    %eax,(%esp)
  80163b:	e8 6b ef ff ff       	call   8005ab <fd_alloc>
  801640:	89 c3                	mov    %eax,%ebx
  801642:	85 c0                	test   %eax,%eax
  801644:	0f 88 f5 00 00 00    	js     80173f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80164a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801651:	00 
  801652:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801655:	89 44 24 04          	mov    %eax,0x4(%esp)
  801659:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801660:	e8 ed ed ff ff       	call   800452 <sys_page_alloc>
  801665:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801667:	85 c0                	test   %eax,%eax
  801669:	0f 88 d0 00 00 00    	js     80173f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80166f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801672:	89 04 24             	mov    %eax,(%esp)
  801675:	e8 16 ef ff ff       	call   800590 <fd2data>
  80167a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80167c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801683:	00 
  801684:	89 44 24 04          	mov    %eax,0x4(%esp)
  801688:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80168f:	e8 be ed ff ff       	call   800452 <sys_page_alloc>
  801694:	89 c3                	mov    %eax,%ebx
  801696:	85 c0                	test   %eax,%eax
  801698:	0f 88 8e 00 00 00    	js     80172c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80169e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016a1:	89 04 24             	mov    %eax,(%esp)
  8016a4:	e8 e7 ee ff ff       	call   800590 <fd2data>
  8016a9:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  8016b0:	00 
  8016b1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8016b5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8016bc:	00 
  8016bd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016c1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016c8:	e8 27 ed ff ff       	call   8003f4 <sys_page_map>
  8016cd:	89 c3                	mov    %eax,%ebx
  8016cf:	85 c0                	test   %eax,%eax
  8016d1:	78 49                	js     80171c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8016d3:	b8 3c 60 80 00       	mov    $0x80603c,%eax
  8016d8:	8b 08                	mov    (%eax),%ecx
  8016da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016dd:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8016df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8016e2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8016e9:	8b 10                	mov    (%eax),%edx
  8016eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016ee:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8016f0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016f3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8016fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8016fd:	89 04 24             	mov    %eax,(%esp)
  801700:	e8 7b ee ff ff       	call   800580 <fd2num>
  801705:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801707:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80170a:	89 04 24             	mov    %eax,(%esp)
  80170d:	e8 6e ee ff ff       	call   800580 <fd2num>
  801712:	89 47 04             	mov    %eax,0x4(%edi)
  801715:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  80171a:	eb 36                	jmp    801752 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  80171c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801720:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801727:	e8 6a ec ff ff       	call   800396 <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80172c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80172f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801733:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80173a:	e8 57 ec ff ff       	call   800396 <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80173f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801742:	89 44 24 04          	mov    %eax,0x4(%esp)
  801746:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80174d:	e8 44 ec ff ff       	call   800396 <sys_page_unmap>
    err:
	return r;
}
  801752:	89 d8                	mov    %ebx,%eax
  801754:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801757:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80175a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80175d:	89 ec                	mov    %ebp,%esp
  80175f:	5d                   	pop    %ebp
  801760:	c3                   	ret    
	...

00801770 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801770:	55                   	push   %ebp
  801771:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801773:	b8 00 00 00 00       	mov    $0x0,%eax
  801778:	5d                   	pop    %ebp
  801779:	c3                   	ret    

0080177a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801780:	c7 44 24 04 48 29 80 	movl   $0x802948,0x4(%esp)
  801787:	00 
  801788:	8b 45 0c             	mov    0xc(%ebp),%eax
  80178b:	89 04 24             	mov    %eax,(%esp)
  80178e:	e8 27 09 00 00       	call   8020ba <strcpy>
	return 0;
}
  801793:	b8 00 00 00 00       	mov    $0x0,%eax
  801798:	c9                   	leave  
  801799:	c3                   	ret    

0080179a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80179a:	55                   	push   %ebp
  80179b:	89 e5                	mov    %esp,%ebp
  80179d:	57                   	push   %edi
  80179e:	56                   	push   %esi
  80179f:	53                   	push   %ebx
  8017a0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8017a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ab:	be 00 00 00 00       	mov    $0x0,%esi
  8017b0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b4:	74 3f                	je     8017f5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8017b6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  8017bc:	8b 55 10             	mov    0x10(%ebp),%edx
  8017bf:	29 c2                	sub    %eax,%edx
  8017c1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  8017c3:	83 fa 7f             	cmp    $0x7f,%edx
  8017c6:	76 05                	jbe    8017cd <devcons_write+0x33>
  8017c8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8017cd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017d1:	03 45 0c             	add    0xc(%ebp),%eax
  8017d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017d8:	89 3c 24             	mov    %edi,(%esp)
  8017db:	e8 95 0a 00 00       	call   802275 <memmove>
		sys_cputs(buf, m);
  8017e0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8017e4:	89 3c 24             	mov    %edi,(%esp)
  8017e7:	e8 00 e9 ff ff       	call   8000ec <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8017ec:	01 de                	add    %ebx,%esi
  8017ee:	89 f0                	mov    %esi,%eax
  8017f0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8017f3:	72 c7                	jb     8017bc <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8017f5:	89 f0                	mov    %esi,%eax
  8017f7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8017fd:	5b                   	pop    %ebx
  8017fe:	5e                   	pop    %esi
  8017ff:	5f                   	pop    %edi
  801800:	5d                   	pop    %ebp
  801801:	c3                   	ret    

00801802 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801808:	8b 45 08             	mov    0x8(%ebp),%eax
  80180b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  80180e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801815:	00 
  801816:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801819:	89 04 24             	mov    %eax,(%esp)
  80181c:	e8 cb e8 ff ff       	call   8000ec <sys_cputs>
}
  801821:	c9                   	leave  
  801822:	c3                   	ret    

00801823 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801823:	55                   	push   %ebp
  801824:	89 e5                	mov    %esp,%ebp
  801826:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  801829:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80182d:	75 07                	jne    801836 <devcons_read+0x13>
  80182f:	eb 28                	jmp    801859 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801831:	e8 7b ec ff ff       	call   8004b1 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801836:	66 90                	xchg   %ax,%ax
  801838:	e8 7b e8 ff ff       	call   8000b8 <sys_cgetc>
  80183d:	85 c0                	test   %eax,%eax
  80183f:	90                   	nop
  801840:	74 ef                	je     801831 <devcons_read+0xe>
  801842:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801844:	85 c0                	test   %eax,%eax
  801846:	78 16                	js     80185e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801848:	83 f8 04             	cmp    $0x4,%eax
  80184b:	74 0c                	je     801859 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80184d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801850:	88 10                	mov    %dl,(%eax)
  801852:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  801857:	eb 05                	jmp    80185e <devcons_read+0x3b>
  801859:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80185e:	c9                   	leave  
  80185f:	c3                   	ret    

00801860 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801866:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801869:	89 04 24             	mov    %eax,(%esp)
  80186c:	e8 3a ed ff ff       	call   8005ab <fd_alloc>
  801871:	85 c0                	test   %eax,%eax
  801873:	78 3f                	js     8018b4 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801875:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80187c:	00 
  80187d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801880:	89 44 24 04          	mov    %eax,0x4(%esp)
  801884:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80188b:	e8 c2 eb ff ff       	call   800452 <sys_page_alloc>
  801890:	85 c0                	test   %eax,%eax
  801892:	78 20                	js     8018b4 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801894:	8b 15 58 60 80 00    	mov    0x806058,%edx
  80189a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80189f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8018a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018ac:	89 04 24             	mov    %eax,(%esp)
  8018af:	e8 cc ec ff ff       	call   800580 <fd2num>
}
  8018b4:	c9                   	leave  
  8018b5:	c3                   	ret    

008018b6 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8018bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c6:	89 04 24             	mov    %eax,(%esp)
  8018c9:	e8 4f ed ff ff       	call   80061d <fd_lookup>
  8018ce:	85 c0                	test   %eax,%eax
  8018d0:	78 11                	js     8018e3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8018d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018d5:	8b 00                	mov    (%eax),%eax
  8018d7:	3b 05 58 60 80 00    	cmp    0x806058,%eax
  8018dd:	0f 94 c0             	sete   %al
  8018e0:	0f b6 c0             	movzbl %al,%eax
}
  8018e3:	c9                   	leave  
  8018e4:	c3                   	ret    

008018e5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8018e5:	55                   	push   %ebp
  8018e6:	89 e5                	mov    %esp,%ebp
  8018e8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8018eb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8018f2:	00 
  8018f3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8018f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801901:	e8 78 ef ff ff       	call   80087e <read>
	if (r < 0)
  801906:	85 c0                	test   %eax,%eax
  801908:	78 0f                	js     801919 <getchar+0x34>
		return r;
	if (r < 1)
  80190a:	85 c0                	test   %eax,%eax
  80190c:	7f 07                	jg     801915 <getchar+0x30>
  80190e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801913:	eb 04                	jmp    801919 <getchar+0x34>
		return -E_EOF;
	return c;
  801915:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801919:	c9                   	leave  
  80191a:	c3                   	ret    
	...

0080191c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	53                   	push   %ebx
  801920:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  801923:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  801926:	a1 78 60 80 00       	mov    0x806078,%eax
  80192b:	85 c0                	test   %eax,%eax
  80192d:	74 10                	je     80193f <_panic+0x23>
		cprintf("%s: ", argv0);
  80192f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801933:	c7 04 24 54 29 80 00 	movl   $0x802954,(%esp)
  80193a:	e8 a2 00 00 00       	call   8019e1 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80193f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801942:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	89 44 24 08          	mov    %eax,0x8(%esp)
  80194d:	a1 00 60 80 00       	mov    0x806000,%eax
  801952:	89 44 24 04          	mov    %eax,0x4(%esp)
  801956:	c7 04 24 59 29 80 00 	movl   $0x802959,(%esp)
  80195d:	e8 7f 00 00 00       	call   8019e1 <cprintf>
	vcprintf(fmt, ap);
  801962:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801966:	8b 45 10             	mov    0x10(%ebp),%eax
  801969:	89 04 24             	mov    %eax,(%esp)
  80196c:	e8 0f 00 00 00       	call   801980 <vcprintf>
	cprintf("\n");
  801971:	c7 04 24 41 29 80 00 	movl   $0x802941,(%esp)
  801978:	e8 64 00 00 00       	call   8019e1 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80197d:	cc                   	int3   
  80197e:	eb fd                	jmp    80197d <_panic+0x61>

00801980 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  801980:	55                   	push   %ebp
  801981:	89 e5                	mov    %esp,%ebp
  801983:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801989:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801990:	00 00 00 
	b.cnt = 0;
  801993:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80199a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80199d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8019ab:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8019b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019b5:	c7 04 24 fb 19 80 00 	movl   $0x8019fb,(%esp)
  8019bc:	e8 cc 01 00 00       	call   801b8d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8019c1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8019c7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019cb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8019d1:	89 04 24             	mov    %eax,(%esp)
  8019d4:	e8 13 e7 ff ff       	call   8000ec <sys_cputs>

	return b.cnt;
}
  8019d9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8019df:	c9                   	leave  
  8019e0:	c3                   	ret    

008019e1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8019e1:	55                   	push   %ebp
  8019e2:	89 e5                	mov    %esp,%ebp
  8019e4:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8019e7:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8019ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f1:	89 04 24             	mov    %eax,(%esp)
  8019f4:	e8 87 ff ff ff       	call   801980 <vcprintf>
	va_end(ap);

	return cnt;
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
  8019fe:	53                   	push   %ebx
  8019ff:	83 ec 14             	sub    $0x14,%esp
  801a02:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801a05:	8b 03                	mov    (%ebx),%eax
  801a07:	8b 55 08             	mov    0x8(%ebp),%edx
  801a0a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  801a0e:	83 c0 01             	add    $0x1,%eax
  801a11:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  801a13:	3d ff 00 00 00       	cmp    $0xff,%eax
  801a18:	75 19                	jne    801a33 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801a1a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801a21:	00 
  801a22:	8d 43 08             	lea    0x8(%ebx),%eax
  801a25:	89 04 24             	mov    %eax,(%esp)
  801a28:	e8 bf e6 ff ff       	call   8000ec <sys_cputs>
		b->idx = 0;
  801a2d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801a33:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801a37:	83 c4 14             	add    $0x14,%esp
  801a3a:	5b                   	pop    %ebx
  801a3b:	5d                   	pop    %ebp
  801a3c:	c3                   	ret    
  801a3d:	00 00                	add    %al,(%eax)
	...

00801a40 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
  801a43:	57                   	push   %edi
  801a44:	56                   	push   %esi
  801a45:	53                   	push   %ebx
  801a46:	83 ec 4c             	sub    $0x4c,%esp
  801a49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a4c:	89 d6                	mov    %edx,%esi
  801a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a51:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801a54:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a57:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801a5a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a5d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a60:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801a63:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801a66:	b9 00 00 00 00       	mov    $0x0,%ecx
  801a6b:	39 d1                	cmp    %edx,%ecx
  801a6d:	72 15                	jb     801a84 <printnum+0x44>
  801a6f:	77 07                	ja     801a78 <printnum+0x38>
  801a71:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801a74:	39 d0                	cmp    %edx,%eax
  801a76:	76 0c                	jbe    801a84 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801a78:	83 eb 01             	sub    $0x1,%ebx
  801a7b:	85 db                	test   %ebx,%ebx
  801a7d:	8d 76 00             	lea    0x0(%esi),%esi
  801a80:	7f 61                	jg     801ae3 <printnum+0xa3>
  801a82:	eb 70                	jmp    801af4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801a84:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801a88:	83 eb 01             	sub    $0x1,%ebx
  801a8b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801a8f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a93:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801a97:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  801a9b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  801a9e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  801aa1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  801aa4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801aa8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801aaf:	00 
  801ab0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ab3:	89 04 24             	mov    %eax,(%esp)
  801ab6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ab9:	89 54 24 04          	mov    %edx,0x4(%esp)
  801abd:	e8 ce 0a 00 00       	call   802590 <__udivdi3>
  801ac2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801ac5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801ac8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801acc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801ad0:	89 04 24             	mov    %eax,(%esp)
  801ad3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ad7:	89 f2                	mov    %esi,%edx
  801ad9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801adc:	e8 5f ff ff ff       	call   801a40 <printnum>
  801ae1:	eb 11                	jmp    801af4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801ae3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ae7:	89 3c 24             	mov    %edi,(%esp)
  801aea:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801aed:	83 eb 01             	sub    $0x1,%ebx
  801af0:	85 db                	test   %ebx,%ebx
  801af2:	7f ef                	jg     801ae3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801af4:	89 74 24 04          	mov    %esi,0x4(%esp)
  801af8:	8b 74 24 04          	mov    0x4(%esp),%esi
  801afc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801aff:	89 44 24 08          	mov    %eax,0x8(%esp)
  801b03:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801b0a:	00 
  801b0b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b0e:	89 14 24             	mov    %edx,(%esp)
  801b11:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801b14:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801b18:	e8 a3 0b 00 00       	call   8026c0 <__umoddi3>
  801b1d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b21:	0f be 80 75 29 80 00 	movsbl 0x802975(%eax),%eax
  801b28:	89 04 24             	mov    %eax,(%esp)
  801b2b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  801b2e:	83 c4 4c             	add    $0x4c,%esp
  801b31:	5b                   	pop    %ebx
  801b32:	5e                   	pop    %esi
  801b33:	5f                   	pop    %edi
  801b34:	5d                   	pop    %ebp
  801b35:	c3                   	ret    

00801b36 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  801b39:	83 fa 01             	cmp    $0x1,%edx
  801b3c:	7e 0e                	jle    801b4c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  801b3e:	8b 10                	mov    (%eax),%edx
  801b40:	8d 4a 08             	lea    0x8(%edx),%ecx
  801b43:	89 08                	mov    %ecx,(%eax)
  801b45:	8b 02                	mov    (%edx),%eax
  801b47:	8b 52 04             	mov    0x4(%edx),%edx
  801b4a:	eb 22                	jmp    801b6e <getuint+0x38>
	else if (lflag)
  801b4c:	85 d2                	test   %edx,%edx
  801b4e:	74 10                	je     801b60 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  801b50:	8b 10                	mov    (%eax),%edx
  801b52:	8d 4a 04             	lea    0x4(%edx),%ecx
  801b55:	89 08                	mov    %ecx,(%eax)
  801b57:	8b 02                	mov    (%edx),%eax
  801b59:	ba 00 00 00 00       	mov    $0x0,%edx
  801b5e:	eb 0e                	jmp    801b6e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  801b60:	8b 10                	mov    (%eax),%edx
  801b62:	8d 4a 04             	lea    0x4(%edx),%ecx
  801b65:	89 08                	mov    %ecx,(%eax)
  801b67:	8b 02                	mov    (%edx),%eax
  801b69:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801b6e:	5d                   	pop    %ebp
  801b6f:	c3                   	ret    

00801b70 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801b76:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  801b7a:	8b 10                	mov    (%eax),%edx
  801b7c:	3b 50 04             	cmp    0x4(%eax),%edx
  801b7f:	73 0a                	jae    801b8b <sprintputch+0x1b>
		*b->buf++ = ch;
  801b81:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b84:	88 0a                	mov    %cl,(%edx)
  801b86:	83 c2 01             	add    $0x1,%edx
  801b89:	89 10                	mov    %edx,(%eax)
}
  801b8b:	5d                   	pop    %ebp
  801b8c:	c3                   	ret    

00801b8d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
  801b90:	57                   	push   %edi
  801b91:	56                   	push   %esi
  801b92:	53                   	push   %ebx
  801b93:	83 ec 5c             	sub    $0x5c,%esp
  801b96:	8b 7d 08             	mov    0x8(%ebp),%edi
  801b99:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b9c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801b9f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  801ba6:	eb 11                	jmp    801bb9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  801ba8:	85 c0                	test   %eax,%eax
  801baa:	0f 84 09 04 00 00    	je     801fb9 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  801bb0:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bb4:	89 04 24             	mov    %eax,(%esp)
  801bb7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801bb9:	0f b6 03             	movzbl (%ebx),%eax
  801bbc:	83 c3 01             	add    $0x1,%ebx
  801bbf:	83 f8 25             	cmp    $0x25,%eax
  801bc2:	75 e4                	jne    801ba8 <vprintfmt+0x1b>
  801bc4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  801bc8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  801bcf:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  801bd6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801bdd:	b9 00 00 00 00       	mov    $0x0,%ecx
  801be2:	eb 06                	jmp    801bea <vprintfmt+0x5d>
  801be4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  801be8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  801bea:	0f b6 13             	movzbl (%ebx),%edx
  801bed:	0f b6 c2             	movzbl %dl,%eax
  801bf0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801bf3:	8d 43 01             	lea    0x1(%ebx),%eax
  801bf6:	83 ea 23             	sub    $0x23,%edx
  801bf9:	80 fa 55             	cmp    $0x55,%dl
  801bfc:	0f 87 9a 03 00 00    	ja     801f9c <vprintfmt+0x40f>
  801c02:	0f b6 d2             	movzbl %dl,%edx
  801c05:	ff 24 95 c0 2a 80 00 	jmp    *0x802ac0(,%edx,4)
  801c0c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  801c10:	eb d6                	jmp    801be8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  801c12:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801c15:	83 ea 30             	sub    $0x30,%edx
  801c18:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  801c1b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  801c1e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801c21:	83 fb 09             	cmp    $0x9,%ebx
  801c24:	77 4c                	ja     801c72 <vprintfmt+0xe5>
  801c26:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801c29:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801c2c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  801c2f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  801c32:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  801c36:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  801c39:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801c3c:	83 fb 09             	cmp    $0x9,%ebx
  801c3f:	76 eb                	jbe    801c2c <vprintfmt+0x9f>
  801c41:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  801c44:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801c47:	eb 29                	jmp    801c72 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  801c49:	8b 55 14             	mov    0x14(%ebp),%edx
  801c4c:	8d 5a 04             	lea    0x4(%edx),%ebx
  801c4f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  801c52:	8b 12                	mov    (%edx),%edx
  801c54:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  801c57:	eb 19                	jmp    801c72 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  801c59:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801c5c:	c1 fa 1f             	sar    $0x1f,%edx
  801c5f:	f7 d2                	not    %edx
  801c61:	21 55 e4             	and    %edx,-0x1c(%ebp)
  801c64:	eb 82                	jmp    801be8 <vprintfmt+0x5b>
  801c66:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  801c6d:	e9 76 ff ff ff       	jmp    801be8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  801c72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c76:	0f 89 6c ff ff ff    	jns    801be8 <vprintfmt+0x5b>
  801c7c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801c7f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801c82:	8b 55 c8             	mov    -0x38(%ebp),%edx
  801c85:	89 55 cc             	mov    %edx,-0x34(%ebp)
  801c88:	e9 5b ff ff ff       	jmp    801be8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  801c8d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  801c90:	e9 53 ff ff ff       	jmp    801be8 <vprintfmt+0x5b>
  801c95:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801c98:	8b 45 14             	mov    0x14(%ebp),%eax
  801c9b:	8d 50 04             	lea    0x4(%eax),%edx
  801c9e:	89 55 14             	mov    %edx,0x14(%ebp)
  801ca1:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ca5:	8b 00                	mov    (%eax),%eax
  801ca7:	89 04 24             	mov    %eax,(%esp)
  801caa:	ff d7                	call   *%edi
  801cac:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  801caf:	e9 05 ff ff ff       	jmp    801bb9 <vprintfmt+0x2c>
  801cb4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  801cb7:	8b 45 14             	mov    0x14(%ebp),%eax
  801cba:	8d 50 04             	lea    0x4(%eax),%edx
  801cbd:	89 55 14             	mov    %edx,0x14(%ebp)
  801cc0:	8b 00                	mov    (%eax),%eax
  801cc2:	89 c2                	mov    %eax,%edx
  801cc4:	c1 fa 1f             	sar    $0x1f,%edx
  801cc7:	31 d0                	xor    %edx,%eax
  801cc9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801ccb:	83 f8 0f             	cmp    $0xf,%eax
  801cce:	7f 0b                	jg     801cdb <vprintfmt+0x14e>
  801cd0:	8b 14 85 20 2c 80 00 	mov    0x802c20(,%eax,4),%edx
  801cd7:	85 d2                	test   %edx,%edx
  801cd9:	75 20                	jne    801cfb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  801cdb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801cdf:	c7 44 24 08 86 29 80 	movl   $0x802986,0x8(%esp)
  801ce6:	00 
  801ce7:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ceb:	89 3c 24             	mov    %edi,(%esp)
  801cee:	e8 4e 03 00 00       	call   802041 <printfmt>
  801cf3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801cf6:	e9 be fe ff ff       	jmp    801bb9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801cfb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801cff:	c7 44 24 08 05 29 80 	movl   $0x802905,0x8(%esp)
  801d06:	00 
  801d07:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d0b:	89 3c 24             	mov    %edi,(%esp)
  801d0e:	e8 2e 03 00 00       	call   802041 <printfmt>
  801d13:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801d16:	e9 9e fe ff ff       	jmp    801bb9 <vprintfmt+0x2c>
  801d1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801d1e:	89 c3                	mov    %eax,%ebx
  801d20:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  801d23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801d26:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801d29:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2c:	8d 50 04             	lea    0x4(%eax),%edx
  801d2f:	89 55 14             	mov    %edx,0x14(%ebp)
  801d32:	8b 00                	mov    (%eax),%eax
  801d34:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  801d37:	85 c0                	test   %eax,%eax
  801d39:	75 07                	jne    801d42 <vprintfmt+0x1b5>
  801d3b:	c7 45 c4 8f 29 80 00 	movl   $0x80298f,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  801d42:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  801d46:	7e 06                	jle    801d4e <vprintfmt+0x1c1>
  801d48:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  801d4c:	75 13                	jne    801d61 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801d4e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801d51:	0f be 02             	movsbl (%edx),%eax
  801d54:	85 c0                	test   %eax,%eax
  801d56:	0f 85 99 00 00 00    	jne    801df5 <vprintfmt+0x268>
  801d5c:	e9 86 00 00 00       	jmp    801de7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801d61:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d65:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  801d68:	89 0c 24             	mov    %ecx,(%esp)
  801d6b:	e8 1b 03 00 00       	call   80208b <strnlen>
  801d70:	8b 55 c0             	mov    -0x40(%ebp),%edx
  801d73:	29 c2                	sub    %eax,%edx
  801d75:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  801d78:	85 d2                	test   %edx,%edx
  801d7a:	7e d2                	jle    801d4e <vprintfmt+0x1c1>
					putch(padc, putdat);
  801d7c:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  801d80:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801d83:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  801d86:	89 d3                	mov    %edx,%ebx
  801d88:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d8c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801d8f:	89 04 24             	mov    %eax,(%esp)
  801d92:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801d94:	83 eb 01             	sub    $0x1,%ebx
  801d97:	85 db                	test   %ebx,%ebx
  801d99:	7f ed                	jg     801d88 <vprintfmt+0x1fb>
  801d9b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  801d9e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  801da5:	eb a7                	jmp    801d4e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801da7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  801dab:	74 18                	je     801dc5 <vprintfmt+0x238>
  801dad:	8d 50 e0             	lea    -0x20(%eax),%edx
  801db0:	83 fa 5e             	cmp    $0x5e,%edx
  801db3:	76 10                	jbe    801dc5 <vprintfmt+0x238>
					putch('?', putdat);
  801db5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801db9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  801dc0:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  801dc3:	eb 0a                	jmp    801dcf <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  801dc5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  801dc9:	89 04 24             	mov    %eax,(%esp)
  801dcc:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801dcf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  801dd3:	0f be 03             	movsbl (%ebx),%eax
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	74 05                	je     801ddf <vprintfmt+0x252>
  801dda:	83 c3 01             	add    $0x1,%ebx
  801ddd:	eb 29                	jmp    801e08 <vprintfmt+0x27b>
  801ddf:	89 fe                	mov    %edi,%esi
  801de1:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801de4:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801de7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801deb:	7f 2e                	jg     801e1b <vprintfmt+0x28e>
  801ded:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  801df0:	e9 c4 fd ff ff       	jmp    801bb9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801df5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801df8:	83 c2 01             	add    $0x1,%edx
  801dfb:	89 7d dc             	mov    %edi,-0x24(%ebp)
  801dfe:	89 f7                	mov    %esi,%edi
  801e00:	8b 75 cc             	mov    -0x34(%ebp),%esi
  801e03:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  801e06:	89 d3                	mov    %edx,%ebx
  801e08:	85 f6                	test   %esi,%esi
  801e0a:	78 9b                	js     801da7 <vprintfmt+0x21a>
  801e0c:	83 ee 01             	sub    $0x1,%esi
  801e0f:	79 96                	jns    801da7 <vprintfmt+0x21a>
  801e11:	89 fe                	mov    %edi,%esi
  801e13:	8b 7d dc             	mov    -0x24(%ebp),%edi
  801e16:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  801e19:	eb cc                	jmp    801de7 <vprintfmt+0x25a>
  801e1b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  801e1e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  801e21:	89 74 24 04          	mov    %esi,0x4(%esp)
  801e25:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  801e2c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801e2e:	83 eb 01             	sub    $0x1,%ebx
  801e31:	85 db                	test   %ebx,%ebx
  801e33:	7f ec                	jg     801e21 <vprintfmt+0x294>
  801e35:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  801e38:	e9 7c fd ff ff       	jmp    801bb9 <vprintfmt+0x2c>
  801e3d:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  801e40:	83 f9 01             	cmp    $0x1,%ecx
  801e43:	7e 16                	jle    801e5b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  801e45:	8b 45 14             	mov    0x14(%ebp),%eax
  801e48:	8d 50 08             	lea    0x8(%eax),%edx
  801e4b:	89 55 14             	mov    %edx,0x14(%ebp)
  801e4e:	8b 10                	mov    (%eax),%edx
  801e50:	8b 48 04             	mov    0x4(%eax),%ecx
  801e53:	89 55 d0             	mov    %edx,-0x30(%ebp)
  801e56:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801e59:	eb 32                	jmp    801e8d <vprintfmt+0x300>
	else if (lflag)
  801e5b:	85 c9                	test   %ecx,%ecx
  801e5d:	74 18                	je     801e77 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  801e5f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e62:	8d 50 04             	lea    0x4(%eax),%edx
  801e65:	89 55 14             	mov    %edx,0x14(%ebp)
  801e68:	8b 00                	mov    (%eax),%eax
  801e6a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e6d:	89 c1                	mov    %eax,%ecx
  801e6f:	c1 f9 1f             	sar    $0x1f,%ecx
  801e72:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801e75:	eb 16                	jmp    801e8d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  801e77:	8b 45 14             	mov    0x14(%ebp),%eax
  801e7a:	8d 50 04             	lea    0x4(%eax),%edx
  801e7d:	89 55 14             	mov    %edx,0x14(%ebp)
  801e80:	8b 00                	mov    (%eax),%eax
  801e82:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801e85:	89 c2                	mov    %eax,%edx
  801e87:	c1 fa 1f             	sar    $0x1f,%edx
  801e8a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801e8d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801e90:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801e93:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  801e98:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  801e9c:	0f 89 b8 00 00 00    	jns    801f5a <vprintfmt+0x3cd>
				putch('-', putdat);
  801ea2:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ea6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801ead:	ff d7                	call   *%edi
				num = -(long long) num;
  801eaf:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801eb2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801eb5:	f7 d9                	neg    %ecx
  801eb7:	83 d3 00             	adc    $0x0,%ebx
  801eba:	f7 db                	neg    %ebx
  801ebc:	b8 0a 00 00 00       	mov    $0xa,%eax
  801ec1:	e9 94 00 00 00       	jmp    801f5a <vprintfmt+0x3cd>
  801ec6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801ec9:	89 ca                	mov    %ecx,%edx
  801ecb:	8d 45 14             	lea    0x14(%ebp),%eax
  801ece:	e8 63 fc ff ff       	call   801b36 <getuint>
  801ed3:	89 c1                	mov    %eax,%ecx
  801ed5:	89 d3                	mov    %edx,%ebx
  801ed7:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  801edc:	eb 7c                	jmp    801f5a <vprintfmt+0x3cd>
  801ede:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801ee1:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ee5:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  801eec:	ff d7                	call   *%edi
			putch('X', putdat);
  801eee:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ef2:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  801ef9:	ff d7                	call   *%edi
			putch('X', putdat);
  801efb:	89 74 24 04          	mov    %esi,0x4(%esp)
  801eff:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  801f06:	ff d7                	call   *%edi
  801f08:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  801f0b:	e9 a9 fc ff ff       	jmp    801bb9 <vprintfmt+0x2c>
  801f10:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  801f13:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f17:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  801f1e:	ff d7                	call   *%edi
			putch('x', putdat);
  801f20:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f24:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  801f2b:	ff d7                	call   *%edi
			num = (unsigned long long)
  801f2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801f30:	8d 50 04             	lea    0x4(%eax),%edx
  801f33:	89 55 14             	mov    %edx,0x14(%ebp)
  801f36:	8b 08                	mov    (%eax),%ecx
  801f38:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f3d:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  801f42:	eb 16                	jmp    801f5a <vprintfmt+0x3cd>
  801f44:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801f47:	89 ca                	mov    %ecx,%edx
  801f49:	8d 45 14             	lea    0x14(%ebp),%eax
  801f4c:	e8 e5 fb ff ff       	call   801b36 <getuint>
  801f51:	89 c1                	mov    %eax,%ecx
  801f53:	89 d3                	mov    %edx,%ebx
  801f55:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  801f5a:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  801f5e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801f62:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f65:	89 54 24 0c          	mov    %edx,0xc(%esp)
  801f69:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f6d:	89 0c 24             	mov    %ecx,(%esp)
  801f70:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801f74:	89 f2                	mov    %esi,%edx
  801f76:	89 f8                	mov    %edi,%eax
  801f78:	e8 c3 fa ff ff       	call   801a40 <printnum>
  801f7d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  801f80:	e9 34 fc ff ff       	jmp    801bb9 <vprintfmt+0x2c>
  801f85:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f88:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801f8b:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f8f:	89 14 24             	mov    %edx,(%esp)
  801f92:	ff d7                	call   *%edi
  801f94:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  801f97:	e9 1d fc ff ff       	jmp    801bb9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801f9c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fa0:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  801fa7:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801fa9:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801fac:	80 38 25             	cmpb   $0x25,(%eax)
  801faf:	0f 84 04 fc ff ff    	je     801bb9 <vprintfmt+0x2c>
  801fb5:	89 c3                	mov    %eax,%ebx
  801fb7:	eb f0                	jmp    801fa9 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  801fb9:	83 c4 5c             	add    $0x5c,%esp
  801fbc:	5b                   	pop    %ebx
  801fbd:	5e                   	pop    %esi
  801fbe:	5f                   	pop    %edi
  801fbf:	5d                   	pop    %ebp
  801fc0:	c3                   	ret    

00801fc1 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	83 ec 28             	sub    $0x28,%esp
  801fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fca:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  801fcd:	85 c0                	test   %eax,%eax
  801fcf:	74 04                	je     801fd5 <vsnprintf+0x14>
  801fd1:	85 d2                	test   %edx,%edx
  801fd3:	7f 07                	jg     801fdc <vsnprintf+0x1b>
  801fd5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801fda:	eb 3b                	jmp    802017 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  801fdc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801fdf:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  801fe3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801fe6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801fed:	8b 45 14             	mov    0x14(%ebp),%eax
  801ff0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ff4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ff7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ffb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ffe:	89 44 24 04          	mov    %eax,0x4(%esp)
  802002:	c7 04 24 70 1b 80 00 	movl   $0x801b70,(%esp)
  802009:	e8 7f fb ff ff       	call   801b8d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80200e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802011:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  802014:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  802017:	c9                   	leave  
  802018:	c3                   	ret    

00802019 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  802019:	55                   	push   %ebp
  80201a:	89 e5                	mov    %esp,%ebp
  80201c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  80201f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  802022:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802026:	8b 45 10             	mov    0x10(%ebp),%eax
  802029:	89 44 24 08          	mov    %eax,0x8(%esp)
  80202d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802030:	89 44 24 04          	mov    %eax,0x4(%esp)
  802034:	8b 45 08             	mov    0x8(%ebp),%eax
  802037:	89 04 24             	mov    %eax,(%esp)
  80203a:	e8 82 ff ff ff       	call   801fc1 <vsnprintf>
	va_end(ap);

	return rc;
}
  80203f:	c9                   	leave  
  802040:	c3                   	ret    

00802041 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802041:	55                   	push   %ebp
  802042:	89 e5                	mov    %esp,%ebp
  802044:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  802047:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80204a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80204e:	8b 45 10             	mov    0x10(%ebp),%eax
  802051:	89 44 24 08          	mov    %eax,0x8(%esp)
  802055:	8b 45 0c             	mov    0xc(%ebp),%eax
  802058:	89 44 24 04          	mov    %eax,0x4(%esp)
  80205c:	8b 45 08             	mov    0x8(%ebp),%eax
  80205f:	89 04 24             	mov    %eax,(%esp)
  802062:	e8 26 fb ff ff       	call   801b8d <vprintfmt>
	va_end(ap);
}
  802067:	c9                   	leave  
  802068:	c3                   	ret    
  802069:	00 00                	add    %al,(%eax)
  80206b:	00 00                	add    %al,(%eax)
  80206d:	00 00                	add    %al,(%eax)
	...

00802070 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  802070:	55                   	push   %ebp
  802071:	89 e5                	mov    %esp,%ebp
  802073:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  802076:	b8 00 00 00 00       	mov    $0x0,%eax
  80207b:	80 3a 00             	cmpb   $0x0,(%edx)
  80207e:	74 09                	je     802089 <strlen+0x19>
		n++;
  802080:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  802083:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  802087:	75 f7                	jne    802080 <strlen+0x10>
		n++;
	return n;
}
  802089:	5d                   	pop    %ebp
  80208a:	c3                   	ret    

0080208b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	53                   	push   %ebx
  80208f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802092:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  802095:	85 c9                	test   %ecx,%ecx
  802097:	74 19                	je     8020b2 <strnlen+0x27>
  802099:	80 3b 00             	cmpb   $0x0,(%ebx)
  80209c:	74 14                	je     8020b2 <strnlen+0x27>
  80209e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8020a3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8020a6:	39 c8                	cmp    %ecx,%eax
  8020a8:	74 0d                	je     8020b7 <strnlen+0x2c>
  8020aa:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8020ae:	75 f3                	jne    8020a3 <strnlen+0x18>
  8020b0:	eb 05                	jmp    8020b7 <strnlen+0x2c>
  8020b2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8020b7:	5b                   	pop    %ebx
  8020b8:	5d                   	pop    %ebp
  8020b9:	c3                   	ret    

008020ba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8020ba:	55                   	push   %ebp
  8020bb:	89 e5                	mov    %esp,%ebp
  8020bd:	53                   	push   %ebx
  8020be:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8020c4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8020c9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8020cd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8020d0:	83 c2 01             	add    $0x1,%edx
  8020d3:	84 c9                	test   %cl,%cl
  8020d5:	75 f2                	jne    8020c9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8020d7:	5b                   	pop    %ebx
  8020d8:	5d                   	pop    %ebp
  8020d9:	c3                   	ret    

008020da <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8020da:	55                   	push   %ebp
  8020db:	89 e5                	mov    %esp,%ebp
  8020dd:	56                   	push   %esi
  8020de:	53                   	push   %ebx
  8020df:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020e5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8020e8:	85 f6                	test   %esi,%esi
  8020ea:	74 18                	je     802104 <strncpy+0x2a>
  8020ec:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8020f1:	0f b6 1a             	movzbl (%edx),%ebx
  8020f4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8020f7:	80 3a 01             	cmpb   $0x1,(%edx)
  8020fa:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8020fd:	83 c1 01             	add    $0x1,%ecx
  802100:	39 ce                	cmp    %ecx,%esi
  802102:	77 ed                	ja     8020f1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  802104:	5b                   	pop    %ebx
  802105:	5e                   	pop    %esi
  802106:	5d                   	pop    %ebp
  802107:	c3                   	ret    

00802108 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	56                   	push   %esi
  80210c:	53                   	push   %ebx
  80210d:	8b 75 08             	mov    0x8(%ebp),%esi
  802110:	8b 55 0c             	mov    0xc(%ebp),%edx
  802113:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  802116:	89 f0                	mov    %esi,%eax
  802118:	85 c9                	test   %ecx,%ecx
  80211a:	74 27                	je     802143 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  80211c:	83 e9 01             	sub    $0x1,%ecx
  80211f:	74 1d                	je     80213e <strlcpy+0x36>
  802121:	0f b6 1a             	movzbl (%edx),%ebx
  802124:	84 db                	test   %bl,%bl
  802126:	74 16                	je     80213e <strlcpy+0x36>
			*dst++ = *src++;
  802128:	88 18                	mov    %bl,(%eax)
  80212a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80212d:	83 e9 01             	sub    $0x1,%ecx
  802130:	74 0e                	je     802140 <strlcpy+0x38>
			*dst++ = *src++;
  802132:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  802135:	0f b6 1a             	movzbl (%edx),%ebx
  802138:	84 db                	test   %bl,%bl
  80213a:	75 ec                	jne    802128 <strlcpy+0x20>
  80213c:	eb 02                	jmp    802140 <strlcpy+0x38>
  80213e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  802140:	c6 00 00             	movb   $0x0,(%eax)
  802143:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  802145:	5b                   	pop    %ebx
  802146:	5e                   	pop    %esi
  802147:	5d                   	pop    %ebp
  802148:	c3                   	ret    

00802149 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  802149:	55                   	push   %ebp
  80214a:	89 e5                	mov    %esp,%ebp
  80214c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80214f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  802152:	0f b6 01             	movzbl (%ecx),%eax
  802155:	84 c0                	test   %al,%al
  802157:	74 15                	je     80216e <strcmp+0x25>
  802159:	3a 02                	cmp    (%edx),%al
  80215b:	75 11                	jne    80216e <strcmp+0x25>
		p++, q++;
  80215d:	83 c1 01             	add    $0x1,%ecx
  802160:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  802163:	0f b6 01             	movzbl (%ecx),%eax
  802166:	84 c0                	test   %al,%al
  802168:	74 04                	je     80216e <strcmp+0x25>
  80216a:	3a 02                	cmp    (%edx),%al
  80216c:	74 ef                	je     80215d <strcmp+0x14>
  80216e:	0f b6 c0             	movzbl %al,%eax
  802171:	0f b6 12             	movzbl (%edx),%edx
  802174:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  802176:	5d                   	pop    %ebp
  802177:	c3                   	ret    

00802178 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802178:	55                   	push   %ebp
  802179:	89 e5                	mov    %esp,%ebp
  80217b:	53                   	push   %ebx
  80217c:	8b 55 08             	mov    0x8(%ebp),%edx
  80217f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802182:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  802185:	85 c0                	test   %eax,%eax
  802187:	74 23                	je     8021ac <strncmp+0x34>
  802189:	0f b6 1a             	movzbl (%edx),%ebx
  80218c:	84 db                	test   %bl,%bl
  80218e:	74 24                	je     8021b4 <strncmp+0x3c>
  802190:	3a 19                	cmp    (%ecx),%bl
  802192:	75 20                	jne    8021b4 <strncmp+0x3c>
  802194:	83 e8 01             	sub    $0x1,%eax
  802197:	74 13                	je     8021ac <strncmp+0x34>
		n--, p++, q++;
  802199:	83 c2 01             	add    $0x1,%edx
  80219c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80219f:	0f b6 1a             	movzbl (%edx),%ebx
  8021a2:	84 db                	test   %bl,%bl
  8021a4:	74 0e                	je     8021b4 <strncmp+0x3c>
  8021a6:	3a 19                	cmp    (%ecx),%bl
  8021a8:	74 ea                	je     802194 <strncmp+0x1c>
  8021aa:	eb 08                	jmp    8021b4 <strncmp+0x3c>
  8021ac:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8021b1:	5b                   	pop    %ebx
  8021b2:	5d                   	pop    %ebp
  8021b3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8021b4:	0f b6 02             	movzbl (%edx),%eax
  8021b7:	0f b6 11             	movzbl (%ecx),%edx
  8021ba:	29 d0                	sub    %edx,%eax
  8021bc:	eb f3                	jmp    8021b1 <strncmp+0x39>

008021be <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8021be:	55                   	push   %ebp
  8021bf:	89 e5                	mov    %esp,%ebp
  8021c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8021c8:	0f b6 10             	movzbl (%eax),%edx
  8021cb:	84 d2                	test   %dl,%dl
  8021cd:	74 15                	je     8021e4 <strchr+0x26>
		if (*s == c)
  8021cf:	38 ca                	cmp    %cl,%dl
  8021d1:	75 07                	jne    8021da <strchr+0x1c>
  8021d3:	eb 14                	jmp    8021e9 <strchr+0x2b>
  8021d5:	38 ca                	cmp    %cl,%dl
  8021d7:	90                   	nop
  8021d8:	74 0f                	je     8021e9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8021da:	83 c0 01             	add    $0x1,%eax
  8021dd:	0f b6 10             	movzbl (%eax),%edx
  8021e0:	84 d2                	test   %dl,%dl
  8021e2:	75 f1                	jne    8021d5 <strchr+0x17>
  8021e4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8021e9:	5d                   	pop    %ebp
  8021ea:	c3                   	ret    

008021eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8021eb:	55                   	push   %ebp
  8021ec:	89 e5                	mov    %esp,%ebp
  8021ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8021f5:	0f b6 10             	movzbl (%eax),%edx
  8021f8:	84 d2                	test   %dl,%dl
  8021fa:	74 18                	je     802214 <strfind+0x29>
		if (*s == c)
  8021fc:	38 ca                	cmp    %cl,%dl
  8021fe:	75 0a                	jne    80220a <strfind+0x1f>
  802200:	eb 12                	jmp    802214 <strfind+0x29>
  802202:	38 ca                	cmp    %cl,%dl
  802204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802208:	74 0a                	je     802214 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80220a:	83 c0 01             	add    $0x1,%eax
  80220d:	0f b6 10             	movzbl (%eax),%edx
  802210:	84 d2                	test   %dl,%dl
  802212:	75 ee                	jne    802202 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  802214:	5d                   	pop    %ebp
  802215:	c3                   	ret    

00802216 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802216:	55                   	push   %ebp
  802217:	89 e5                	mov    %esp,%ebp
  802219:	83 ec 0c             	sub    $0xc,%esp
  80221c:	89 1c 24             	mov    %ebx,(%esp)
  80221f:	89 74 24 04          	mov    %esi,0x4(%esp)
  802223:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802227:	8b 7d 08             	mov    0x8(%ebp),%edi
  80222a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80222d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  802230:	85 c9                	test   %ecx,%ecx
  802232:	74 30                	je     802264 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802234:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80223a:	75 25                	jne    802261 <memset+0x4b>
  80223c:	f6 c1 03             	test   $0x3,%cl
  80223f:	75 20                	jne    802261 <memset+0x4b>
		c &= 0xFF;
  802241:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  802244:	89 d3                	mov    %edx,%ebx
  802246:	c1 e3 08             	shl    $0x8,%ebx
  802249:	89 d6                	mov    %edx,%esi
  80224b:	c1 e6 18             	shl    $0x18,%esi
  80224e:	89 d0                	mov    %edx,%eax
  802250:	c1 e0 10             	shl    $0x10,%eax
  802253:	09 f0                	or     %esi,%eax
  802255:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  802257:	09 d8                	or     %ebx,%eax
  802259:	c1 e9 02             	shr    $0x2,%ecx
  80225c:	fc                   	cld    
  80225d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80225f:	eb 03                	jmp    802264 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  802261:	fc                   	cld    
  802262:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  802264:	89 f8                	mov    %edi,%eax
  802266:	8b 1c 24             	mov    (%esp),%ebx
  802269:	8b 74 24 04          	mov    0x4(%esp),%esi
  80226d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  802271:	89 ec                	mov    %ebp,%esp
  802273:	5d                   	pop    %ebp
  802274:	c3                   	ret    

00802275 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  802275:	55                   	push   %ebp
  802276:	89 e5                	mov    %esp,%ebp
  802278:	83 ec 08             	sub    $0x8,%esp
  80227b:	89 34 24             	mov    %esi,(%esp)
  80227e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802282:	8b 45 08             	mov    0x8(%ebp),%eax
  802285:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  802288:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  80228b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  80228d:	39 c6                	cmp    %eax,%esi
  80228f:	73 35                	jae    8022c6 <memmove+0x51>
  802291:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  802294:	39 d0                	cmp    %edx,%eax
  802296:	73 2e                	jae    8022c6 <memmove+0x51>
		s += n;
		d += n;
  802298:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80229a:	f6 c2 03             	test   $0x3,%dl
  80229d:	75 1b                	jne    8022ba <memmove+0x45>
  80229f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8022a5:	75 13                	jne    8022ba <memmove+0x45>
  8022a7:	f6 c1 03             	test   $0x3,%cl
  8022aa:	75 0e                	jne    8022ba <memmove+0x45>
			asm volatile("std; rep movsl\n"
  8022ac:	83 ef 04             	sub    $0x4,%edi
  8022af:	8d 72 fc             	lea    -0x4(%edx),%esi
  8022b2:	c1 e9 02             	shr    $0x2,%ecx
  8022b5:	fd                   	std    
  8022b6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8022b8:	eb 09                	jmp    8022c3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8022ba:	83 ef 01             	sub    $0x1,%edi
  8022bd:	8d 72 ff             	lea    -0x1(%edx),%esi
  8022c0:	fd                   	std    
  8022c1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8022c3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8022c4:	eb 20                	jmp    8022e6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8022c6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8022cc:	75 15                	jne    8022e3 <memmove+0x6e>
  8022ce:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8022d4:	75 0d                	jne    8022e3 <memmove+0x6e>
  8022d6:	f6 c1 03             	test   $0x3,%cl
  8022d9:	75 08                	jne    8022e3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  8022db:	c1 e9 02             	shr    $0x2,%ecx
  8022de:	fc                   	cld    
  8022df:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8022e1:	eb 03                	jmp    8022e6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8022e3:	fc                   	cld    
  8022e4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8022e6:	8b 34 24             	mov    (%esp),%esi
  8022e9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8022ed:	89 ec                	mov    %ebp,%esp
  8022ef:	5d                   	pop    %ebp
  8022f0:	c3                   	ret    

008022f1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  8022f1:	55                   	push   %ebp
  8022f2:	89 e5                	mov    %esp,%ebp
  8022f4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8022f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8022fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  802301:	89 44 24 04          	mov    %eax,0x4(%esp)
  802305:	8b 45 08             	mov    0x8(%ebp),%eax
  802308:	89 04 24             	mov    %eax,(%esp)
  80230b:	e8 65 ff ff ff       	call   802275 <memmove>
}
  802310:	c9                   	leave  
  802311:	c3                   	ret    

00802312 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802312:	55                   	push   %ebp
  802313:	89 e5                	mov    %esp,%ebp
  802315:	57                   	push   %edi
  802316:	56                   	push   %esi
  802317:	53                   	push   %ebx
  802318:	8b 75 08             	mov    0x8(%ebp),%esi
  80231b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80231e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  802321:	85 c9                	test   %ecx,%ecx
  802323:	74 36                	je     80235b <memcmp+0x49>
		if (*s1 != *s2)
  802325:	0f b6 06             	movzbl (%esi),%eax
  802328:	0f b6 1f             	movzbl (%edi),%ebx
  80232b:	38 d8                	cmp    %bl,%al
  80232d:	74 20                	je     80234f <memcmp+0x3d>
  80232f:	eb 14                	jmp    802345 <memcmp+0x33>
  802331:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  802336:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  80233b:	83 c2 01             	add    $0x1,%edx
  80233e:	83 e9 01             	sub    $0x1,%ecx
  802341:	38 d8                	cmp    %bl,%al
  802343:	74 12                	je     802357 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  802345:	0f b6 c0             	movzbl %al,%eax
  802348:	0f b6 db             	movzbl %bl,%ebx
  80234b:	29 d8                	sub    %ebx,%eax
  80234d:	eb 11                	jmp    802360 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80234f:	83 e9 01             	sub    $0x1,%ecx
  802352:	ba 00 00 00 00       	mov    $0x0,%edx
  802357:	85 c9                	test   %ecx,%ecx
  802359:	75 d6                	jne    802331 <memcmp+0x1f>
  80235b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  802360:	5b                   	pop    %ebx
  802361:	5e                   	pop    %esi
  802362:	5f                   	pop    %edi
  802363:	5d                   	pop    %ebp
  802364:	c3                   	ret    

00802365 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
  802368:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80236b:	89 c2                	mov    %eax,%edx
  80236d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802370:	39 d0                	cmp    %edx,%eax
  802372:	73 15                	jae    802389 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  802374:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  802378:	38 08                	cmp    %cl,(%eax)
  80237a:	75 06                	jne    802382 <memfind+0x1d>
  80237c:	eb 0b                	jmp    802389 <memfind+0x24>
  80237e:	38 08                	cmp    %cl,(%eax)
  802380:	74 07                	je     802389 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  802382:	83 c0 01             	add    $0x1,%eax
  802385:	39 c2                	cmp    %eax,%edx
  802387:	77 f5                	ja     80237e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  802389:	5d                   	pop    %ebp
  80238a:	c3                   	ret    

0080238b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	57                   	push   %edi
  80238f:	56                   	push   %esi
  802390:	53                   	push   %ebx
  802391:	83 ec 04             	sub    $0x4,%esp
  802394:	8b 55 08             	mov    0x8(%ebp),%edx
  802397:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80239a:	0f b6 02             	movzbl (%edx),%eax
  80239d:	3c 20                	cmp    $0x20,%al
  80239f:	74 04                	je     8023a5 <strtol+0x1a>
  8023a1:	3c 09                	cmp    $0x9,%al
  8023a3:	75 0e                	jne    8023b3 <strtol+0x28>
		s++;
  8023a5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8023a8:	0f b6 02             	movzbl (%edx),%eax
  8023ab:	3c 20                	cmp    $0x20,%al
  8023ad:	74 f6                	je     8023a5 <strtol+0x1a>
  8023af:	3c 09                	cmp    $0x9,%al
  8023b1:	74 f2                	je     8023a5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  8023b3:	3c 2b                	cmp    $0x2b,%al
  8023b5:	75 0c                	jne    8023c3 <strtol+0x38>
		s++;
  8023b7:	83 c2 01             	add    $0x1,%edx
  8023ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8023c1:	eb 15                	jmp    8023d8 <strtol+0x4d>
	else if (*s == '-')
  8023c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8023ca:	3c 2d                	cmp    $0x2d,%al
  8023cc:	75 0a                	jne    8023d8 <strtol+0x4d>
		s++, neg = 1;
  8023ce:	83 c2 01             	add    $0x1,%edx
  8023d1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8023d8:	85 db                	test   %ebx,%ebx
  8023da:	0f 94 c0             	sete   %al
  8023dd:	74 05                	je     8023e4 <strtol+0x59>
  8023df:	83 fb 10             	cmp    $0x10,%ebx
  8023e2:	75 18                	jne    8023fc <strtol+0x71>
  8023e4:	80 3a 30             	cmpb   $0x30,(%edx)
  8023e7:	75 13                	jne    8023fc <strtol+0x71>
  8023e9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8023ed:	8d 76 00             	lea    0x0(%esi),%esi
  8023f0:	75 0a                	jne    8023fc <strtol+0x71>
		s += 2, base = 16;
  8023f2:	83 c2 02             	add    $0x2,%edx
  8023f5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8023fa:	eb 15                	jmp    802411 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8023fc:	84 c0                	test   %al,%al
  8023fe:	66 90                	xchg   %ax,%ax
  802400:	74 0f                	je     802411 <strtol+0x86>
  802402:	bb 0a 00 00 00       	mov    $0xa,%ebx
  802407:	80 3a 30             	cmpb   $0x30,(%edx)
  80240a:	75 05                	jne    802411 <strtol+0x86>
		s++, base = 8;
  80240c:	83 c2 01             	add    $0x1,%edx
  80240f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  802411:	b8 00 00 00 00       	mov    $0x0,%eax
  802416:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  802418:	0f b6 0a             	movzbl (%edx),%ecx
  80241b:	89 cf                	mov    %ecx,%edi
  80241d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  802420:	80 fb 09             	cmp    $0x9,%bl
  802423:	77 08                	ja     80242d <strtol+0xa2>
			dig = *s - '0';
  802425:	0f be c9             	movsbl %cl,%ecx
  802428:	83 e9 30             	sub    $0x30,%ecx
  80242b:	eb 1e                	jmp    80244b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  80242d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  802430:	80 fb 19             	cmp    $0x19,%bl
  802433:	77 08                	ja     80243d <strtol+0xb2>
			dig = *s - 'a' + 10;
  802435:	0f be c9             	movsbl %cl,%ecx
  802438:	83 e9 57             	sub    $0x57,%ecx
  80243b:	eb 0e                	jmp    80244b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  80243d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  802440:	80 fb 19             	cmp    $0x19,%bl
  802443:	77 15                	ja     80245a <strtol+0xcf>
			dig = *s - 'A' + 10;
  802445:	0f be c9             	movsbl %cl,%ecx
  802448:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80244b:	39 f1                	cmp    %esi,%ecx
  80244d:	7d 0b                	jge    80245a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  80244f:	83 c2 01             	add    $0x1,%edx
  802452:	0f af c6             	imul   %esi,%eax
  802455:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  802458:	eb be                	jmp    802418 <strtol+0x8d>
  80245a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80245c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802460:	74 05                	je     802467 <strtol+0xdc>
		*endptr = (char *) s;
  802462:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  802465:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  802467:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80246b:	74 04                	je     802471 <strtol+0xe6>
  80246d:	89 c8                	mov    %ecx,%eax
  80246f:	f7 d8                	neg    %eax
}
  802471:	83 c4 04             	add    $0x4,%esp
  802474:	5b                   	pop    %ebx
  802475:	5e                   	pop    %esi
  802476:	5f                   	pop    %edi
  802477:	5d                   	pop    %ebp
  802478:	c3                   	ret    
  802479:	00 00                	add    %al,(%eax)
  80247b:	00 00                	add    %al,(%eax)
  80247d:	00 00                	add    %al,(%eax)
	...

00802480 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802480:	55                   	push   %ebp
  802481:	89 e5                	mov    %esp,%ebp
  802483:	57                   	push   %edi
  802484:	56                   	push   %esi
  802485:	53                   	push   %ebx
  802486:	83 ec 1c             	sub    $0x1c,%esp
  802489:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80248c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80248f:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  802492:	8b 45 14             	mov    0x14(%ebp),%eax
  802495:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802499:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80249d:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024a1:	89 1c 24             	mov    %ebx,(%esp)
  8024a4:	e8 9b dd ff ff       	call   800244 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  8024a9:	85 c0                	test   %eax,%eax
  8024ab:	79 21                	jns    8024ce <ipc_send+0x4e>
  8024ad:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024b0:	74 1c                	je     8024ce <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  8024b2:	c7 44 24 08 80 2c 80 	movl   $0x802c80,0x8(%esp)
  8024b9:	00 
  8024ba:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  8024c1:	00 
  8024c2:	c7 04 24 92 2c 80 00 	movl   $0x802c92,(%esp)
  8024c9:	e8 4e f4 ff ff       	call   80191c <_panic>
          else if(r==-E_IPC_NOT_RECV)
  8024ce:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8024d1:	75 07                	jne    8024da <ipc_send+0x5a>
           sys_yield();
  8024d3:	e8 d9 df ff ff       	call   8004b1 <sys_yield>
          else
            break;
        }
  8024d8:	eb b8                	jmp    802492 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  8024da:	83 c4 1c             	add    $0x1c,%esp
  8024dd:	5b                   	pop    %ebx
  8024de:	5e                   	pop    %esi
  8024df:	5f                   	pop    %edi
  8024e0:	5d                   	pop    %ebp
  8024e1:	c3                   	ret    

008024e2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8024e2:	55                   	push   %ebp
  8024e3:	89 e5                	mov    %esp,%ebp
  8024e5:	83 ec 18             	sub    $0x18,%esp
  8024e8:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8024eb:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8024ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8024f1:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  8024f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024f7:	89 04 24             	mov    %eax,(%esp)
  8024fa:	e8 e8 dc ff ff       	call   8001e7 <sys_ipc_recv>
        if(r<0)
  8024ff:	85 c0                	test   %eax,%eax
  802501:	79 17                	jns    80251a <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  802503:	85 db                	test   %ebx,%ebx
  802505:	74 06                	je     80250d <ipc_recv+0x2b>
               *from_env_store =0;
  802507:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  80250d:	85 f6                	test   %esi,%esi
  80250f:	90                   	nop
  802510:	74 2c                	je     80253e <ipc_recv+0x5c>
              *perm_store=0;
  802512:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802518:	eb 24                	jmp    80253e <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  80251a:	85 db                	test   %ebx,%ebx
  80251c:	74 0a                	je     802528 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  80251e:	a1 74 60 80 00       	mov    0x806074,%eax
  802523:	8b 40 74             	mov    0x74(%eax),%eax
  802526:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  802528:	85 f6                	test   %esi,%esi
  80252a:	74 0a                	je     802536 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  80252c:	a1 74 60 80 00       	mov    0x806074,%eax
  802531:	8b 40 78             	mov    0x78(%eax),%eax
  802534:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  802536:	a1 74 60 80 00       	mov    0x806074,%eax
  80253b:	8b 40 70             	mov    0x70(%eax),%eax
}
  80253e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802541:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802544:	89 ec                	mov    %ebp,%esp
  802546:	5d                   	pop    %ebp
  802547:	c3                   	ret    

00802548 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802548:	55                   	push   %ebp
  802549:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80254b:	8b 45 08             	mov    0x8(%ebp),%eax
  80254e:	89 c2                	mov    %eax,%edx
  802550:	c1 ea 16             	shr    $0x16,%edx
  802553:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80255a:	f6 c2 01             	test   $0x1,%dl
  80255d:	74 26                	je     802585 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  80255f:	c1 e8 0c             	shr    $0xc,%eax
  802562:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802569:	a8 01                	test   $0x1,%al
  80256b:	74 18                	je     802585 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  80256d:	c1 e8 0c             	shr    $0xc,%eax
  802570:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802573:	c1 e2 02             	shl    $0x2,%edx
  802576:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  80257b:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802580:	0f b7 c0             	movzwl %ax,%eax
  802583:	eb 05                	jmp    80258a <pageref+0x42>
  802585:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80258a:	5d                   	pop    %ebp
  80258b:	c3                   	ret    
  80258c:	00 00                	add    %al,(%eax)
	...

00802590 <__udivdi3>:
  802590:	55                   	push   %ebp
  802591:	89 e5                	mov    %esp,%ebp
  802593:	57                   	push   %edi
  802594:	56                   	push   %esi
  802595:	83 ec 10             	sub    $0x10,%esp
  802598:	8b 45 14             	mov    0x14(%ebp),%eax
  80259b:	8b 55 08             	mov    0x8(%ebp),%edx
  80259e:	8b 75 10             	mov    0x10(%ebp),%esi
  8025a1:	8b 7d 0c             	mov    0xc(%ebp),%edi
  8025a4:	85 c0                	test   %eax,%eax
  8025a6:	89 55 f0             	mov    %edx,-0x10(%ebp)
  8025a9:	75 35                	jne    8025e0 <__udivdi3+0x50>
  8025ab:	39 fe                	cmp    %edi,%esi
  8025ad:	77 61                	ja     802610 <__udivdi3+0x80>
  8025af:	85 f6                	test   %esi,%esi
  8025b1:	75 0b                	jne    8025be <__udivdi3+0x2e>
  8025b3:	b8 01 00 00 00       	mov    $0x1,%eax
  8025b8:	31 d2                	xor    %edx,%edx
  8025ba:	f7 f6                	div    %esi
  8025bc:	89 c6                	mov    %eax,%esi
  8025be:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8025c1:	31 d2                	xor    %edx,%edx
  8025c3:	89 f8                	mov    %edi,%eax
  8025c5:	f7 f6                	div    %esi
  8025c7:	89 c7                	mov    %eax,%edi
  8025c9:	89 c8                	mov    %ecx,%eax
  8025cb:	f7 f6                	div    %esi
  8025cd:	89 c1                	mov    %eax,%ecx
  8025cf:	89 fa                	mov    %edi,%edx
  8025d1:	89 c8                	mov    %ecx,%eax
  8025d3:	83 c4 10             	add    $0x10,%esp
  8025d6:	5e                   	pop    %esi
  8025d7:	5f                   	pop    %edi
  8025d8:	5d                   	pop    %ebp
  8025d9:	c3                   	ret    
  8025da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8025e0:	39 f8                	cmp    %edi,%eax
  8025e2:	77 1c                	ja     802600 <__udivdi3+0x70>
  8025e4:	0f bd d0             	bsr    %eax,%edx
  8025e7:	83 f2 1f             	xor    $0x1f,%edx
  8025ea:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8025ed:	75 39                	jne    802628 <__udivdi3+0x98>
  8025ef:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8025f2:	0f 86 a0 00 00 00    	jbe    802698 <__udivdi3+0x108>
  8025f8:	39 f8                	cmp    %edi,%eax
  8025fa:	0f 82 98 00 00 00    	jb     802698 <__udivdi3+0x108>
  802600:	31 ff                	xor    %edi,%edi
  802602:	31 c9                	xor    %ecx,%ecx
  802604:	89 c8                	mov    %ecx,%eax
  802606:	89 fa                	mov    %edi,%edx
  802608:	83 c4 10             	add    $0x10,%esp
  80260b:	5e                   	pop    %esi
  80260c:	5f                   	pop    %edi
  80260d:	5d                   	pop    %ebp
  80260e:	c3                   	ret    
  80260f:	90                   	nop
  802610:	89 d1                	mov    %edx,%ecx
  802612:	89 fa                	mov    %edi,%edx
  802614:	89 c8                	mov    %ecx,%eax
  802616:	31 ff                	xor    %edi,%edi
  802618:	f7 f6                	div    %esi
  80261a:	89 c1                	mov    %eax,%ecx
  80261c:	89 fa                	mov    %edi,%edx
  80261e:	89 c8                	mov    %ecx,%eax
  802620:	83 c4 10             	add    $0x10,%esp
  802623:	5e                   	pop    %esi
  802624:	5f                   	pop    %edi
  802625:	5d                   	pop    %ebp
  802626:	c3                   	ret    
  802627:	90                   	nop
  802628:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80262c:	89 f2                	mov    %esi,%edx
  80262e:	d3 e0                	shl    %cl,%eax
  802630:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802633:	b8 20 00 00 00       	mov    $0x20,%eax
  802638:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80263b:	89 c1                	mov    %eax,%ecx
  80263d:	d3 ea                	shr    %cl,%edx
  80263f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802643:	0b 55 ec             	or     -0x14(%ebp),%edx
  802646:	d3 e6                	shl    %cl,%esi
  802648:	89 c1                	mov    %eax,%ecx
  80264a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80264d:	89 fe                	mov    %edi,%esi
  80264f:	d3 ee                	shr    %cl,%esi
  802651:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802655:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802658:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80265b:	d3 e7                	shl    %cl,%edi
  80265d:	89 c1                	mov    %eax,%ecx
  80265f:	d3 ea                	shr    %cl,%edx
  802661:	09 d7                	or     %edx,%edi
  802663:	89 f2                	mov    %esi,%edx
  802665:	89 f8                	mov    %edi,%eax
  802667:	f7 75 ec             	divl   -0x14(%ebp)
  80266a:	89 d6                	mov    %edx,%esi
  80266c:	89 c7                	mov    %eax,%edi
  80266e:	f7 65 e8             	mull   -0x18(%ebp)
  802671:	39 d6                	cmp    %edx,%esi
  802673:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802676:	72 30                	jb     8026a8 <__udivdi3+0x118>
  802678:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80267b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80267f:	d3 e2                	shl    %cl,%edx
  802681:	39 c2                	cmp    %eax,%edx
  802683:	73 05                	jae    80268a <__udivdi3+0xfa>
  802685:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802688:	74 1e                	je     8026a8 <__udivdi3+0x118>
  80268a:	89 f9                	mov    %edi,%ecx
  80268c:	31 ff                	xor    %edi,%edi
  80268e:	e9 71 ff ff ff       	jmp    802604 <__udivdi3+0x74>
  802693:	90                   	nop
  802694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802698:	31 ff                	xor    %edi,%edi
  80269a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80269f:	e9 60 ff ff ff       	jmp    802604 <__udivdi3+0x74>
  8026a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8026a8:	8d 4f ff             	lea    -0x1(%edi),%ecx
  8026ab:	31 ff                	xor    %edi,%edi
  8026ad:	89 c8                	mov    %ecx,%eax
  8026af:	89 fa                	mov    %edi,%edx
  8026b1:	83 c4 10             	add    $0x10,%esp
  8026b4:	5e                   	pop    %esi
  8026b5:	5f                   	pop    %edi
  8026b6:	5d                   	pop    %ebp
  8026b7:	c3                   	ret    
	...

008026c0 <__umoddi3>:
  8026c0:	55                   	push   %ebp
  8026c1:	89 e5                	mov    %esp,%ebp
  8026c3:	57                   	push   %edi
  8026c4:	56                   	push   %esi
  8026c5:	83 ec 20             	sub    $0x20,%esp
  8026c8:	8b 55 14             	mov    0x14(%ebp),%edx
  8026cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8026ce:	8b 7d 10             	mov    0x10(%ebp),%edi
  8026d1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026d4:	85 d2                	test   %edx,%edx
  8026d6:	89 c8                	mov    %ecx,%eax
  8026d8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8026db:	75 13                	jne    8026f0 <__umoddi3+0x30>
  8026dd:	39 f7                	cmp    %esi,%edi
  8026df:	76 3f                	jbe    802720 <__umoddi3+0x60>
  8026e1:	89 f2                	mov    %esi,%edx
  8026e3:	f7 f7                	div    %edi
  8026e5:	89 d0                	mov    %edx,%eax
  8026e7:	31 d2                	xor    %edx,%edx
  8026e9:	83 c4 20             	add    $0x20,%esp
  8026ec:	5e                   	pop    %esi
  8026ed:	5f                   	pop    %edi
  8026ee:	5d                   	pop    %ebp
  8026ef:	c3                   	ret    
  8026f0:	39 f2                	cmp    %esi,%edx
  8026f2:	77 4c                	ja     802740 <__umoddi3+0x80>
  8026f4:	0f bd ca             	bsr    %edx,%ecx
  8026f7:	83 f1 1f             	xor    $0x1f,%ecx
  8026fa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8026fd:	75 51                	jne    802750 <__umoddi3+0x90>
  8026ff:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802702:	0f 87 e0 00 00 00    	ja     8027e8 <__umoddi3+0x128>
  802708:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270b:	29 f8                	sub    %edi,%eax
  80270d:	19 d6                	sbb    %edx,%esi
  80270f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	89 f2                	mov    %esi,%edx
  802717:	83 c4 20             	add    $0x20,%esp
  80271a:	5e                   	pop    %esi
  80271b:	5f                   	pop    %edi
  80271c:	5d                   	pop    %ebp
  80271d:	c3                   	ret    
  80271e:	66 90                	xchg   %ax,%ax
  802720:	85 ff                	test   %edi,%edi
  802722:	75 0b                	jne    80272f <__umoddi3+0x6f>
  802724:	b8 01 00 00 00       	mov    $0x1,%eax
  802729:	31 d2                	xor    %edx,%edx
  80272b:	f7 f7                	div    %edi
  80272d:	89 c7                	mov    %eax,%edi
  80272f:	89 f0                	mov    %esi,%eax
  802731:	31 d2                	xor    %edx,%edx
  802733:	f7 f7                	div    %edi
  802735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802738:	f7 f7                	div    %edi
  80273a:	eb a9                	jmp    8026e5 <__umoddi3+0x25>
  80273c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802740:	89 c8                	mov    %ecx,%eax
  802742:	89 f2                	mov    %esi,%edx
  802744:	83 c4 20             	add    $0x20,%esp
  802747:	5e                   	pop    %esi
  802748:	5f                   	pop    %edi
  802749:	5d                   	pop    %ebp
  80274a:	c3                   	ret    
  80274b:	90                   	nop
  80274c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802750:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802754:	d3 e2                	shl    %cl,%edx
  802756:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802759:	ba 20 00 00 00       	mov    $0x20,%edx
  80275e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802761:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802764:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802768:	89 fa                	mov    %edi,%edx
  80276a:	d3 ea                	shr    %cl,%edx
  80276c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802770:	0b 55 f4             	or     -0xc(%ebp),%edx
  802773:	d3 e7                	shl    %cl,%edi
  802775:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802779:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80277c:	89 f2                	mov    %esi,%edx
  80277e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802781:	89 c7                	mov    %eax,%edi
  802783:	d3 ea                	shr    %cl,%edx
  802785:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802789:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80278c:	89 c2                	mov    %eax,%edx
  80278e:	d3 e6                	shl    %cl,%esi
  802790:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802794:	d3 ea                	shr    %cl,%edx
  802796:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80279a:	09 d6                	or     %edx,%esi
  80279c:	89 f0                	mov    %esi,%eax
  80279e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  8027a1:	d3 e7                	shl    %cl,%edi
  8027a3:	89 f2                	mov    %esi,%edx
  8027a5:	f7 75 f4             	divl   -0xc(%ebp)
  8027a8:	89 d6                	mov    %edx,%esi
  8027aa:	f7 65 e8             	mull   -0x18(%ebp)
  8027ad:	39 d6                	cmp    %edx,%esi
  8027af:	72 2b                	jb     8027dc <__umoddi3+0x11c>
  8027b1:	39 c7                	cmp    %eax,%edi
  8027b3:	72 23                	jb     8027d8 <__umoddi3+0x118>
  8027b5:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027b9:	29 c7                	sub    %eax,%edi
  8027bb:	19 d6                	sbb    %edx,%esi
  8027bd:	89 f0                	mov    %esi,%eax
  8027bf:	89 f2                	mov    %esi,%edx
  8027c1:	d3 ef                	shr    %cl,%edi
  8027c3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8027c7:	d3 e0                	shl    %cl,%eax
  8027c9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8027cd:	09 f8                	or     %edi,%eax
  8027cf:	d3 ea                	shr    %cl,%edx
  8027d1:	83 c4 20             	add    $0x20,%esp
  8027d4:	5e                   	pop    %esi
  8027d5:	5f                   	pop    %edi
  8027d6:	5d                   	pop    %ebp
  8027d7:	c3                   	ret    
  8027d8:	39 d6                	cmp    %edx,%esi
  8027da:	75 d9                	jne    8027b5 <__umoddi3+0xf5>
  8027dc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8027df:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8027e2:	eb d1                	jmp    8027b5 <__umoddi3+0xf5>
  8027e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8027e8:	39 f2                	cmp    %esi,%edx
  8027ea:	0f 82 18 ff ff ff    	jb     802708 <__umoddi3+0x48>
  8027f0:	e9 1d ff ff ff       	jmp    802712 <__umoddi3+0x52>
