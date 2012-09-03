
obj/net/testinput:     file format elf32-i386


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
  80002c:	e8 af 05 00 00       	call   8005e0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <umain>:
	}
}

void
umain(void)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	81 ec ac 00 00 00    	sub    $0xac,%esp
	envid_t ns_envid = sys_getenvid();
  80004c:	e8 88 15 00 00       	call   8015d9 <sys_getenvid>
  800051:	89 c3                	mov    %eax,%ebx
	int i, r;

	binaryname = "testinput";
  800053:	c7 05 00 70 80 00 e0 	movl   $0x8034e0,0x807000
  80005a:	34 80 00 

	output_envid = fork();
  80005d:	e8 65 17 00 00       	call   8017c7 <fork>
  800062:	a3 74 70 80 00       	mov    %eax,0x807074
	if (output_envid < 0)
  800067:	85 c0                	test   %eax,%eax
  800069:	79 1c                	jns    800087 <umain+0x47>
		panic("error forking");
  80006b:	c7 44 24 08 ea 34 80 	movl   $0x8034ea,0x8(%esp)
  800072:	00 
  800073:	c7 44 24 04 4d 00 00 	movl   $0x4d,0x4(%esp)
  80007a:	00 
  80007b:	c7 04 24 f8 34 80 00 	movl   $0x8034f8,(%esp)
  800082:	e8 c5 05 00 00       	call   80064c <_panic>
	else if (output_envid == 0) {
  800087:	85 c0                	test   %eax,%eax
  800089:	75 0d                	jne    800098 <umain+0x58>
		output(ns_envid);
  80008b:	89 1c 24             	mov    %ebx,(%esp)
  80008e:	e8 09 05 00 00       	call   80059c <output>
		return;
  800093:	e9 a6 03 00 00       	jmp    80043e <umain+0x3fe>
	}

	input_envid = fork();
  800098:	e8 2a 17 00 00       	call   8017c7 <fork>
  80009d:	a3 78 70 80 00       	mov    %eax,0x807078
	if (input_envid < 0)
  8000a2:	85 c0                	test   %eax,%eax
  8000a4:	79 1c                	jns    8000c2 <umain+0x82>
		panic("error forking");
  8000a6:	c7 44 24 08 ea 34 80 	movl   $0x8034ea,0x8(%esp)
  8000ad:	00 
  8000ae:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  8000b5:	00 
  8000b6:	c7 04 24 f8 34 80 00 	movl   $0x8034f8,(%esp)
  8000bd:	e8 8a 05 00 00       	call   80064c <_panic>
	else if (input_envid == 0) {
  8000c2:	85 c0                	test   %eax,%eax
  8000c4:	75 0f                	jne    8000d5 <umain+0x95>
		input(ns_envid);
  8000c6:	89 1c 24             	mov    %ebx,(%esp)
  8000c9:	e8 16 04 00 00       	call   8004e4 <input>
  8000ce:	66 90                	xchg   %ax,%ax
  8000d0:	e9 69 03 00 00       	jmp    80043e <umain+0x3fe>
		return;
	}

	cprintf("Sending ARP announcement...\n");
  8000d5:	c7 04 24 08 35 80 00 	movl   $0x803508,(%esp)
  8000dc:	e8 30 06 00 00       	call   800711 <cprintf>
	// with ARP requests.  Ideally, we would use gratuitous ARP
	// for this, but QEMU's ARP implementation is dumb and only
	// listens for very specific ARP requests, such as requests
	// for the gateway IP.

	uint8_t mac[6] = {0x52, 0x54, 0x00, 0x12, 0x34, 0x56};
  8000e1:	c6 45 90 52          	movb   $0x52,-0x70(%ebp)
  8000e5:	c6 45 91 54          	movb   $0x54,-0x6f(%ebp)
  8000e9:	c6 45 92 00          	movb   $0x0,-0x6e(%ebp)
  8000ed:	c6 45 93 12          	movb   $0x12,-0x6d(%ebp)
  8000f1:	c6 45 94 34          	movb   $0x34,-0x6c(%ebp)
  8000f5:	c6 45 95 56          	movb   $0x56,-0x6b(%ebp)
	uint32_t myip = inet_addr(IP);
  8000f9:	c7 04 24 25 35 80 00 	movl   $0x803525,(%esp)
  800100:	e8 33 31 00 00       	call   803238 <inet_addr>
  800105:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	uint32_t gwip = inet_addr(DEFAULT);
  800108:	c7 04 24 2f 35 80 00 	movl   $0x80352f,(%esp)
  80010f:	e8 24 31 00 00       	call   803238 <inet_addr>
  800114:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int r;

	if ((r = sys_page_alloc(0, pkt, PTE_P|PTE_U|PTE_W)) < 0)
  800117:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  80011e:	00 
  80011f:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  800126:	0f 
  800127:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80012e:	e8 13 14 00 00       	call   801546 <sys_page_alloc>
  800133:	85 c0                	test   %eax,%eax
  800135:	79 20                	jns    800157 <umain+0x117>
		panic("sys_page_map: %e", r);
  800137:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013b:	c7 44 24 08 38 35 80 	movl   $0x803538,0x8(%esp)
  800142:	00 
  800143:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
  80014a:	00 
  80014b:	c7 04 24 f8 34 80 00 	movl   $0x8034f8,(%esp)
  800152:	e8 f5 04 00 00       	call   80064c <_panic>

	struct etharp_hdr *arp = (struct etharp_hdr*)pkt->jp_data;
  800157:	bb 04 b0 fe 0f       	mov    $0xffeb004,%ebx
	pkt->jp_len = sizeof(*arp);
  80015c:	c7 05 00 b0 fe 0f 2a 	movl   $0x2a,0xffeb000
  800163:	00 00 00 

	memset(arp->ethhdr.dest.addr, 0xff, ETHARP_HWADDR_LEN);
  800166:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  80016d:	00 
  80016e:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800175:	00 
  800176:	c7 04 24 04 b0 fe 0f 	movl   $0xffeb004,(%esp)
  80017d:	e8 c4 0d 00 00       	call   800f46 <memset>
	memcpy(arp->ethhdr.src.addr,  mac,  ETHARP_HWADDR_LEN);
  800182:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800189:	00 
  80018a:	8d 75 90             	lea    -0x70(%ebp),%esi
  80018d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800191:	c7 04 24 0a b0 fe 0f 	movl   $0xffeb00a,(%esp)
  800198:	e8 84 0e 00 00       	call   801021 <memcpy>
	arp->ethhdr.type = htons(ETHTYPE_ARP);
  80019d:	c7 04 24 06 08 00 00 	movl   $0x806,(%esp)
  8001a4:	e8 6b 2e 00 00       	call   803014 <htons>
  8001a9:	66 89 43 0c          	mov    %ax,0xc(%ebx)
	arp->hwtype = htons(1); // Ethernet
  8001ad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001b4:	e8 5b 2e 00 00       	call   803014 <htons>
  8001b9:	66 89 43 0e          	mov    %ax,0xe(%ebx)
	arp->proto = htons(ETHTYPE_IP);
  8001bd:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  8001c4:	e8 4b 2e 00 00       	call   803014 <htons>
  8001c9:	66 89 43 10          	mov    %ax,0x10(%ebx)
	arp->_hwlen_protolen = htons((ETHARP_HWADDR_LEN << 8) | 4);
  8001cd:	c7 04 24 04 06 00 00 	movl   $0x604,(%esp)
  8001d4:	e8 3b 2e 00 00       	call   803014 <htons>
  8001d9:	66 89 43 12          	mov    %ax,0x12(%ebx)
	arp->opcode = htons(ARP_REQUEST);
  8001dd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001e4:	e8 2b 2e 00 00       	call   803014 <htons>
  8001e9:	66 89 43 14          	mov    %ax,0x14(%ebx)
	memcpy(arp->shwaddr.addr,  mac,   ETHARP_HWADDR_LEN);
  8001ed:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  8001f4:	00 
  8001f5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8001f9:	c7 04 24 1a b0 fe 0f 	movl   $0xffeb01a,(%esp)
  800200:	e8 1c 0e 00 00       	call   801021 <memcpy>
	memcpy(arp->sipaddr.addrw, &myip, 4);
  800205:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  80020c:	00 
  80020d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800210:	89 44 24 04          	mov    %eax,0x4(%esp)
  800214:	c7 04 24 20 b0 fe 0f 	movl   $0xffeb020,(%esp)
  80021b:	e8 01 0e 00 00       	call   801021 <memcpy>
	memset(arp->dhwaddr.addr,  0x00,  ETHARP_HWADDR_LEN);
  800220:	c7 44 24 08 06 00 00 	movl   $0x6,0x8(%esp)
  800227:	00 
  800228:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80022f:	00 
  800230:	c7 04 24 24 b0 fe 0f 	movl   $0xffeb024,(%esp)
  800237:	e8 0a 0d 00 00       	call   800f46 <memset>
	memcpy(arp->dipaddr.addrw, &gwip, 4);
  80023c:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
  800243:	00 
  800244:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800247:	89 44 24 04          	mov    %eax,0x4(%esp)
  80024b:	c7 04 24 2a b0 fe 0f 	movl   $0xffeb02a,(%esp)
  800252:	e8 ca 0d 00 00       	call   801021 <memcpy>

	ipc_send(output_envid, NSREQ_OUTPUT, pkt, PTE_P|PTE_W|PTE_U);
  800257:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  80025e:	00 
  80025f:	c7 44 24 08 00 b0 fe 	movl   $0xffeb000,0x8(%esp)
  800266:	0f 
  800267:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
  80026e:	00 
  80026f:	a1 74 70 80 00       	mov    0x807074,%eax
  800274:	89 04 24             	mov    %eax,(%esp)
  800277:	e8 84 17 00 00       	call   801a00 <ipc_send>
	sys_page_unmap(0, pkt);
  80027c:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  800283:	0f 
  800284:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80028b:	e8 fa 11 00 00       	call   80148a <sys_page_unmap>
	}

	cprintf("Sending ARP announcement...\n");
	announce();

	cprintf("Waiting for packets...\n");
  800290:	c7 04 24 49 35 80 00 	movl   $0x803549,(%esp)
  800297:	e8 75 04 00 00       	call   800711 <cprintf>
	while (1) {
		envid_t whom;
		int perm;

		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  80029c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80029f:	89 85 74 ff ff ff    	mov    %eax,-0x8c(%ebp)
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
		if (i % 16 == 0)
			out = buf + snprintf(buf, end - buf,
  8002a5:	89 b5 70 ff ff ff    	mov    %esi,-0x90(%ebp)
  8002ab:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8002b1:	29 f0                	sub    %esi,%eax
  8002b3:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
	cprintf("Waiting for packets...\n");
	while (1) {
		envid_t whom;
		int perm;

		int32_t req = ipc_recv((int32_t *)&whom, pkt, &perm);
  8002b9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8002bc:	89 44 24 08          	mov    %eax,0x8(%esp)
  8002c0:	c7 44 24 04 00 b0 fe 	movl   $0xffeb000,0x4(%esp)
  8002c7:	0f 
  8002c8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8002cb:	89 04 24             	mov    %eax,(%esp)
  8002ce:	e8 8f 17 00 00       	call   801a62 <ipc_recv>
		if (req < 0)
  8002d3:	85 c0                	test   %eax,%eax
  8002d5:	79 20                	jns    8002f7 <umain+0x2b7>
			panic("ipc_recv: %e", req);
  8002d7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8002db:	c7 44 24 08 61 35 80 	movl   $0x803561,0x8(%esp)
  8002e2:	00 
  8002e3:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
  8002ea:	00 
  8002eb:	c7 04 24 f8 34 80 00 	movl   $0x8034f8,(%esp)
  8002f2:	e8 55 03 00 00       	call   80064c <_panic>
		if (whom != input_envid)
  8002f7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8002fa:	3b 15 78 70 80 00    	cmp    0x807078,%edx
  800300:	74 20                	je     800322 <umain+0x2e2>
			panic("IPC from unexpected environment %08x", whom);
  800302:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800306:	c7 44 24 08 a0 35 80 	movl   $0x8035a0,0x8(%esp)
  80030d:	00 
  80030e:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
  800315:	00 
  800316:	c7 04 24 f8 34 80 00 	movl   $0x8034f8,(%esp)
  80031d:	e8 2a 03 00 00       	call   80064c <_panic>
		if (req != NSREQ_INPUT)
  800322:	83 f8 0a             	cmp    $0xa,%eax
  800325:	74 20                	je     800347 <umain+0x307>
			panic("Unexpected IPC %d", req);
  800327:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80032b:	c7 44 24 08 6e 35 80 	movl   $0x80356e,0x8(%esp)
  800332:	00 
  800333:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
  80033a:	00 
  80033b:	c7 04 24 f8 34 80 00 	movl   $0x8034f8,(%esp)
  800342:	e8 05 03 00 00       	call   80064c <_panic>

		hexdump("input: ", pkt->jp_data, pkt->jp_len);
  800347:	a1 00 b0 fe 0f       	mov    0xffeb000,%eax
  80034c:	89 45 84             	mov    %eax,-0x7c(%ebp)
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
  80034f:	85 c0                	test   %eax,%eax
  800351:	0f 8e d6 00 00 00    	jle    80042d <umain+0x3ed>
  800357:	be 00 00 00 00       	mov    $0x0,%esi
  80035c:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (i % 16 == 0)
			out = buf + snprintf(buf, end - buf,
					     "%s%04x   ", prefix, i);
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
		if (i % 16 == 15 || i == len - 1)
  800361:	83 e8 01             	sub    $0x1,%eax
  800364:	89 45 80             	mov    %eax,-0x80(%ebp)
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
  800367:	89 df                	mov    %ebx,%edi
		if (i % 16 == 0)
  800369:	f6 c3 0f             	test   $0xf,%bl
  80036c:	75 2e                	jne    80039c <umain+0x35c>
			out = buf + snprintf(buf, end - buf,
  80036e:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  800372:	c7 44 24 0c 80 35 80 	movl   $0x803580,0xc(%esp)
  800379:	00 
  80037a:	c7 44 24 08 88 35 80 	movl   $0x803588,0x8(%esp)
  800381:	00 
  800382:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800388:	89 44 24 04          	mov    %eax,0x4(%esp)
  80038c:	8d 45 90             	lea    -0x70(%ebp),%eax
  80038f:	89 04 24             	mov    %eax,(%esp)
  800392:	e8 b2 09 00 00       	call   800d49 <snprintf>
  800397:	8d 75 90             	lea    -0x70(%ebp),%esi
  80039a:	01 c6                	add    %eax,%esi
					     "%s%04x   ", prefix, i);
		out += snprintf(out, end - out, "%02x", ((uint8_t*)data)[i]);
  80039c:	0f b6 87 04 b0 fe 0f 	movzbl 0xffeb004(%edi),%eax
  8003a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8003a7:	c7 44 24 08 92 35 80 	movl   $0x803592,0x8(%esp)
  8003ae:	00 
  8003af:	8b 85 74 ff ff ff    	mov    -0x8c(%ebp),%eax
  8003b5:	29 f0                	sub    %esi,%eax
  8003b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003bb:	89 34 24             	mov    %esi,(%esp)
  8003be:	e8 86 09 00 00       	call   800d49 <snprintf>
  8003c3:	01 c6                	add    %eax,%esi
		if (i % 16 == 15 || i == len - 1)
  8003c5:	89 d8                	mov    %ebx,%eax
  8003c7:	c1 f8 1f             	sar    $0x1f,%eax
  8003ca:	c1 e8 1c             	shr    $0x1c,%eax
  8003cd:	8d 3c 03             	lea    (%ebx,%eax,1),%edi
  8003d0:	83 e7 0f             	and    $0xf,%edi
  8003d3:	29 c7                	sub    %eax,%edi
  8003d5:	83 ff 0f             	cmp    $0xf,%edi
  8003d8:	74 05                	je     8003df <umain+0x39f>
  8003da:	3b 5d 80             	cmp    -0x80(%ebp),%ebx
  8003dd:	75 1f                	jne    8003fe <umain+0x3be>
			cprintf("%.*s\n", out - buf, buf);
  8003df:	8d 45 90             	lea    -0x70(%ebp),%eax
  8003e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8003e6:	89 f0                	mov    %esi,%eax
  8003e8:	2b 85 70 ff ff ff    	sub    -0x90(%ebp),%eax
  8003ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f2:	c7 04 24 97 35 80 00 	movl   $0x803597,(%esp)
  8003f9:	e8 13 03 00 00       	call   800711 <cprintf>
		if (i % 2 == 1)
  8003fe:	89 d8                	mov    %ebx,%eax
  800400:	c1 e8 1f             	shr    $0x1f,%eax
  800403:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800406:	83 e2 01             	and    $0x1,%edx
  800409:	29 c2                	sub    %eax,%edx
  80040b:	83 fa 01             	cmp    $0x1,%edx
  80040e:	75 06                	jne    800416 <umain+0x3d6>
			*(out++) = ' ';
  800410:	c6 06 20             	movb   $0x20,(%esi)
  800413:	83 c6 01             	add    $0x1,%esi
		if (i % 16 == 7)
  800416:	83 ff 07             	cmp    $0x7,%edi
  800419:	75 06                	jne    800421 <umain+0x3e1>
			*(out++) = ' ';
  80041b:	c6 06 20             	movb   $0x20,(%esi)
  80041e:	83 c6 01             	add    $0x1,%esi
{
	int i;
	char buf[80];
	char *end = buf + sizeof(buf);
	char *out = NULL;
	for (i = 0; i < len; i++) {
  800421:	83 c3 01             	add    $0x1,%ebx
  800424:	39 5d 84             	cmp    %ebx,-0x7c(%ebp)
  800427:	0f 8f 3a ff ff ff    	jg     800367 <umain+0x327>
			panic("IPC from unexpected environment %08x", whom);
		if (req != NSREQ_INPUT)
			panic("Unexpected IPC %d", req);

		hexdump("input: ", pkt->jp_data, pkt->jp_len);
		cprintf("\n");
  80042d:	c7 04 24 5f 35 80 00 	movl   $0x80355f,(%esp)
  800434:	e8 d8 02 00 00       	call   800711 <cprintf>
	}
  800439:	e9 7b fe ff ff       	jmp    8002b9 <umain+0x279>
}
  80043e:	81 c4 ac 00 00 00    	add    $0xac,%esp
  800444:	5b                   	pop    %ebx
  800445:	5e                   	pop    %esi
  800446:	5f                   	pop    %edi
  800447:	5d                   	pop    %ebp
  800448:	c3                   	ret    
  800449:	00 00                	add    %al,(%eax)
  80044b:	00 00                	add    %al,(%eax)
  80044d:	00 00                	add    %al,(%eax)
	...

00800450 <timer>:
#include "ns.h"

void
timer(envid_t ns_envid, uint32_t initial_to) {
  800450:	55                   	push   %ebp
  800451:	89 e5                	mov    %esp,%ebp
  800453:	57                   	push   %edi
  800454:	56                   	push   %esi
  800455:	53                   	push   %ebx
  800456:	83 ec 2c             	sub    $0x2c,%esp
  800459:	8b 75 08             	mov    0x8(%ebp),%esi
	uint32_t stop = sys_time_msec() + initial_to;
  80045c:	e8 46 0e 00 00       	call   8012a7 <sys_time_msec>
  800461:	89 c3                	mov    %eax,%ebx
  800463:	03 5d 0c             	add    0xc(%ebp),%ebx

	binaryname = "ns_timer";
  800466:	c7 05 00 70 80 00 c5 	movl   $0x8035c5,0x807000
  80046d:	35 80 00 

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  800470:	8d 7d e4             	lea    -0x1c(%ebp),%edi
  800473:	eb 05                	jmp    80047a <timer+0x2a>

	binaryname = "ns_timer";

	while (1) {
		while(sys_time_msec() < stop) {
			sys_yield();
  800475:	e8 2b 11 00 00       	call   8015a5 <sys_yield>
	uint32_t stop = sys_time_msec() + initial_to;

	binaryname = "ns_timer";

	while (1) {
		while(sys_time_msec() < stop) {
  80047a:	e8 28 0e 00 00       	call   8012a7 <sys_time_msec>
  80047f:	39 c3                	cmp    %eax,%ebx
  800481:	77 f2                	ja     800475 <timer+0x25>
			sys_yield();
		}

		ipc_send(ns_envid, NSREQ_TIMER, 0, 0);
  800483:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80048a:	00 
  80048b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800492:	00 
  800493:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
  80049a:	00 
  80049b:	89 34 24             	mov    %esi,(%esp)
  80049e:	e8 5d 15 00 00       	call   801a00 <ipc_send>

		while (1) {
			uint32_t to, whom;
			to = ipc_recv((int32_t *) &whom, 0, 0);
  8004a3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8004aa:	00 
  8004ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8004b2:	00 
  8004b3:	89 3c 24             	mov    %edi,(%esp)
  8004b6:	e8 a7 15 00 00       	call   801a62 <ipc_recv>
  8004bb:	89 c3                	mov    %eax,%ebx

			if (whom != ns_envid) {
  8004bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004c0:	39 c6                	cmp    %eax,%esi
  8004c2:	74 12                	je     8004d6 <timer+0x86>
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
  8004c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004c8:	c7 04 24 d0 35 80 00 	movl   $0x8035d0,(%esp)
  8004cf:	e8 3d 02 00 00       	call   800711 <cprintf>
				continue;
			}

			stop = sys_time_msec() + to;
			break;
		}
  8004d4:	eb cd                	jmp    8004a3 <timer+0x53>
			if (whom != ns_envid) {
				cprintf("NS TIMER: timer thread got IPC message from env %x not NS\n", whom);
				continue;
			}

			stop = sys_time_msec() + to;
  8004d6:	e8 cc 0d 00 00       	call   8012a7 <sys_time_msec>
  8004db:	8d 1c 18             	lea    (%eax,%ebx,1),%ebx
  8004de:	66 90                	xchg   %ax,%ax
  8004e0:	eb 98                	jmp    80047a <timer+0x2a>
	...

008004e4 <input>:
extern union Nsipc nsipcbuf;
uint32_t len=0;

void
input(envid_t ns_envid)
{
  8004e4:	55                   	push   %ebp
  8004e5:	89 e5                	mov    %esp,%ebp
  8004e7:	53                   	push   %ebx
  8004e8:	83 ec 14             	sub    $0x14,%esp
  8004eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	binaryname = "ns_input";
  8004ee:	c7 05 00 70 80 00 0b 	movl   $0x80360b,0x807000
  8004f5:	36 80 00 
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
           
   while(1)
   {
     if(sys_page_alloc(sys_getenvid(),&nsipcbuf,PTE_W|PTE_U|PTE_P)< 0 )
  8004f8:	e8 dc 10 00 00       	call   8015d9 <sys_getenvid>
  8004fd:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  800504:	00 
  800505:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80050c:	00 
  80050d:	89 04 24             	mov    %eax,(%esp)
  800510:	e8 31 10 00 00       	call   801546 <sys_page_alloc>
  800515:	85 c0                	test   %eax,%eax
  800517:	79 1c                	jns    800535 <input+0x51>
        panic("\nout of pages\n");
  800519:	c7 44 24 08 14 36 80 	movl   $0x803614,0x8(%esp)
  800520:	00 
  800521:	c7 44 24 04 15 00 00 	movl   $0x15,0x4(%esp)
  800528:	00 
  800529:	c7 04 24 23 36 80 00 	movl   $0x803623,(%esp)
  800530:	e8 17 01 00 00       	call   80064c <_panic>
      
       //cprintf("len--->%x",&len);
    	if(sys_call_receive_packet(nsipcbuf.pkt.jp_data,&nsipcbuf.pkt.jp_len)>=0)
  800535:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80053c:	00 
  80053d:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  800544:	e8 ca 0c 00 00       	call   801213 <sys_call_receive_packet>
  800549:	85 c0                	test   %eax,%eax
  80054b:	78 36                	js     800583 <input+0x9f>
	{
        	 //cprintf("\nHere inside input.c -ve\n"); 
		cprintf("\nInside else---->>>>>>\n");
  80054d:	c7 04 24 2f 36 80 00 	movl   $0x80362f,(%esp)
  800554:	e8 b8 01 00 00       	call   800711 <cprintf>
        	ipc_send(ns_envid,NSREQ_INPUT,&nsipcbuf,PTE_W|PTE_U|PTE_P);
  800559:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  800560:	00 
  800561:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  800568:	00 
  800569:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
  800570:	00 
  800571:	89 1c 24             	mov    %ebx,(%esp)
  800574:	e8 87 14 00 00       	call   801a00 <ipc_send>
   		sys_yield();
  800579:	e8 27 10 00 00       	call   8015a5 <sys_yield>
  		sys_yield();
  80057e:	e8 22 10 00 00       	call   8015a5 <sys_yield>
	}

  sys_page_unmap(0,&nsipcbuf);
  800583:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80058a:	00 
  80058b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800592:	e8 f3 0e 00 00       	call   80148a <sys_page_unmap>

}
  800597:	e9 5c ff ff ff       	jmp    8004f8 <input+0x14>

0080059c <output>:

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
  80059c:	55                   	push   %ebp
  80059d:	89 e5                	mov    %esp,%ebp
  80059f:	83 ec 18             	sub    $0x18,%esp
	binaryname = "ns_output";
  8005a2:	c7 05 00 70 80 00 47 	movl   $0x803647,0x807000
  8005a9:	36 80 00 
	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
   while(1)
    {
       ipc_recv(NULL,(void *)&nsipcbuf,NULL);
  8005ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8005b3:	00 
  8005b4:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8005bb:	00 
  8005bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8005c3:	e8 9a 14 00 00       	call   801a62 <ipc_recv>
         {
           cprintf("%c",nsipcbuf.pkt.jp_data[i]);
           i++;
         }
*/
       sys_call_packet_send((void *)nsipcbuf.pkt.jp_data,nsipcbuf.pkt.jp_len); 
  8005c8:	a1 00 60 80 00       	mov    0x806000,%eax
  8005cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005d1:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8005d8:	e8 6c 0c 00 00       	call   801249 <sys_call_packet_send>
  8005dd:	eb cd                	jmp    8005ac <output+0x10>
	...

008005e0 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
  8005e3:	83 ec 18             	sub    $0x18,%esp
  8005e6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8005e9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8005ec:	8b 75 08             	mov    0x8(%ebp),%esi
  8005ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  8005f2:	e8 e2 0f 00 00       	call   8015d9 <sys_getenvid>
  8005f7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005fc:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8005ff:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800604:	a3 90 70 80 00       	mov    %eax,0x807090

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800609:	85 f6                	test   %esi,%esi
  80060b:	7e 07                	jle    800614 <libmain+0x34>
		binaryname = argv[0];
  80060d:	8b 03                	mov    (%ebx),%eax
  80060f:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  800614:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800618:	89 34 24             	mov    %esi,(%esp)
  80061b:	e8 20 fa ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800620:	e8 0b 00 00 00       	call   800630 <exit>
}
  800625:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800628:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80062b:	89 ec                	mov    %ebp,%esp
  80062d:	5d                   	pop    %ebp
  80062e:	c3                   	ret    
	...

00800630 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800630:	55                   	push   %ebp
  800631:	89 e5                	mov    %esp,%ebp
  800633:	83 ec 18             	sub    $0x18,%esp
	close_all();
  800636:	e8 70 19 00 00       	call   801fab <close_all>
	sys_env_destroy(0);
  80063b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800642:	e8 c6 0f 00 00       	call   80160d <sys_env_destroy>
}
  800647:	c9                   	leave  
  800648:	c3                   	ret    
  800649:	00 00                	add    %al,(%eax)
	...

0080064c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80064c:	55                   	push   %ebp
  80064d:	89 e5                	mov    %esp,%ebp
  80064f:	53                   	push   %ebx
  800650:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  800653:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800656:	a1 94 70 80 00       	mov    0x807094,%eax
  80065b:	85 c0                	test   %eax,%eax
  80065d:	74 10                	je     80066f <_panic+0x23>
		cprintf("%s: ", argv0);
  80065f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800663:	c7 04 24 68 36 80 00 	movl   $0x803668,(%esp)
  80066a:	e8 a2 00 00 00       	call   800711 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80066f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800672:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800676:	8b 45 08             	mov    0x8(%ebp),%eax
  800679:	89 44 24 08          	mov    %eax,0x8(%esp)
  80067d:	a1 00 70 80 00       	mov    0x807000,%eax
  800682:	89 44 24 04          	mov    %eax,0x4(%esp)
  800686:	c7 04 24 6d 36 80 00 	movl   $0x80366d,(%esp)
  80068d:	e8 7f 00 00 00       	call   800711 <cprintf>
	vcprintf(fmt, ap);
  800692:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800696:	8b 45 10             	mov    0x10(%ebp),%eax
  800699:	89 04 24             	mov    %eax,(%esp)
  80069c:	e8 0f 00 00 00       	call   8006b0 <vcprintf>
	cprintf("\n");
  8006a1:	c7 04 24 5f 35 80 00 	movl   $0x80355f,(%esp)
  8006a8:	e8 64 00 00 00       	call   800711 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8006ad:	cc                   	int3   
  8006ae:	eb fd                	jmp    8006ad <_panic+0x61>

008006b0 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  8006b9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006c0:	00 00 00 
	b.cnt = 0;
  8006c3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006ca:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006db:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006e5:	c7 04 24 2b 07 80 00 	movl   $0x80072b,(%esp)
  8006ec:	e8 cc 01 00 00       	call   8008bd <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8006f1:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8006f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006fb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800701:	89 04 24             	mov    %eax,(%esp)
  800704:	e8 d7 0a 00 00       	call   8011e0 <sys_cputs>

	return b.cnt;
}
  800709:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80070f:	c9                   	leave  
  800710:	c3                   	ret    

00800711 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800711:	55                   	push   %ebp
  800712:	89 e5                	mov    %esp,%ebp
  800714:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  800717:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80071a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	89 04 24             	mov    %eax,(%esp)
  800724:	e8 87 ff ff ff       	call   8006b0 <vcprintf>
	va_end(ap);

	return cnt;
}
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	53                   	push   %ebx
  80072f:	83 ec 14             	sub    $0x14,%esp
  800732:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800735:	8b 03                	mov    (%ebx),%eax
  800737:	8b 55 08             	mov    0x8(%ebp),%edx
  80073a:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  80073e:	83 c0 01             	add    $0x1,%eax
  800741:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  800743:	3d ff 00 00 00       	cmp    $0xff,%eax
  800748:	75 19                	jne    800763 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  80074a:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  800751:	00 
  800752:	8d 43 08             	lea    0x8(%ebx),%eax
  800755:	89 04 24             	mov    %eax,(%esp)
  800758:	e8 83 0a 00 00       	call   8011e0 <sys_cputs>
		b->idx = 0;
  80075d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  800763:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800767:	83 c4 14             	add    $0x14,%esp
  80076a:	5b                   	pop    %ebx
  80076b:	5d                   	pop    %ebp
  80076c:	c3                   	ret    
  80076d:	00 00                	add    %al,(%eax)
	...

00800770 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800770:	55                   	push   %ebp
  800771:	89 e5                	mov    %esp,%ebp
  800773:	57                   	push   %edi
  800774:	56                   	push   %esi
  800775:	53                   	push   %ebx
  800776:	83 ec 4c             	sub    $0x4c,%esp
  800779:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80077c:	89 d6                	mov    %edx,%esi
  80077e:	8b 45 08             	mov    0x8(%ebp),%eax
  800781:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800784:	8b 55 0c             	mov    0xc(%ebp),%edx
  800787:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80078a:	8b 45 10             	mov    0x10(%ebp),%eax
  80078d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800790:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800793:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800796:	b9 00 00 00 00       	mov    $0x0,%ecx
  80079b:	39 d1                	cmp    %edx,%ecx
  80079d:	72 15                	jb     8007b4 <printnum+0x44>
  80079f:	77 07                	ja     8007a8 <printnum+0x38>
  8007a1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8007a4:	39 d0                	cmp    %edx,%eax
  8007a6:	76 0c                	jbe    8007b4 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8007a8:	83 eb 01             	sub    $0x1,%ebx
  8007ab:	85 db                	test   %ebx,%ebx
  8007ad:	8d 76 00             	lea    0x0(%esi),%esi
  8007b0:	7f 61                	jg     800813 <printnum+0xa3>
  8007b2:	eb 70                	jmp    800824 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007b4:	89 7c 24 10          	mov    %edi,0x10(%esp)
  8007b8:	83 eb 01             	sub    $0x1,%ebx
  8007bb:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8007bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007c3:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  8007c7:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  8007cb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  8007ce:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  8007d1:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  8007d4:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8007d8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8007df:	00 
  8007e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e3:	89 04 24             	mov    %eax,(%esp)
  8007e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007e9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007ed:	e8 7e 2a 00 00       	call   803270 <__udivdi3>
  8007f2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8007f5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8007f8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8007fc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800800:	89 04 24             	mov    %eax,(%esp)
  800803:	89 54 24 04          	mov    %edx,0x4(%esp)
  800807:	89 f2                	mov    %esi,%edx
  800809:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80080c:	e8 5f ff ff ff       	call   800770 <printnum>
  800811:	eb 11                	jmp    800824 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800813:	89 74 24 04          	mov    %esi,0x4(%esp)
  800817:	89 3c 24             	mov    %edi,(%esp)
  80081a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80081d:	83 eb 01             	sub    $0x1,%ebx
  800820:	85 db                	test   %ebx,%ebx
  800822:	7f ef                	jg     800813 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800824:	89 74 24 04          	mov    %esi,0x4(%esp)
  800828:	8b 74 24 04          	mov    0x4(%esp),%esi
  80082c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80082f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800833:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80083a:	00 
  80083b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80083e:	89 14 24             	mov    %edx,(%esp)
  800841:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800844:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800848:	e8 53 2b 00 00       	call   8033a0 <__umoddi3>
  80084d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800851:	0f be 80 89 36 80 00 	movsbl 0x803689(%eax),%eax
  800858:	89 04 24             	mov    %eax,(%esp)
  80085b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80085e:	83 c4 4c             	add    $0x4c,%esp
  800861:	5b                   	pop    %ebx
  800862:	5e                   	pop    %esi
  800863:	5f                   	pop    %edi
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800869:	83 fa 01             	cmp    $0x1,%edx
  80086c:	7e 0e                	jle    80087c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80086e:	8b 10                	mov    (%eax),%edx
  800870:	8d 4a 08             	lea    0x8(%edx),%ecx
  800873:	89 08                	mov    %ecx,(%eax)
  800875:	8b 02                	mov    (%edx),%eax
  800877:	8b 52 04             	mov    0x4(%edx),%edx
  80087a:	eb 22                	jmp    80089e <getuint+0x38>
	else if (lflag)
  80087c:	85 d2                	test   %edx,%edx
  80087e:	74 10                	je     800890 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800880:	8b 10                	mov    (%eax),%edx
  800882:	8d 4a 04             	lea    0x4(%edx),%ecx
  800885:	89 08                	mov    %ecx,(%eax)
  800887:	8b 02                	mov    (%edx),%eax
  800889:	ba 00 00 00 00       	mov    $0x0,%edx
  80088e:	eb 0e                	jmp    80089e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800890:	8b 10                	mov    (%eax),%edx
  800892:	8d 4a 04             	lea    0x4(%edx),%ecx
  800895:	89 08                	mov    %ecx,(%eax)
  800897:	8b 02                	mov    (%edx),%eax
  800899:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80089e:	5d                   	pop    %ebp
  80089f:	c3                   	ret    

008008a0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008a0:	55                   	push   %ebp
  8008a1:	89 e5                	mov    %esp,%ebp
  8008a3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8008a6:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  8008aa:	8b 10                	mov    (%eax),%edx
  8008ac:	3b 50 04             	cmp    0x4(%eax),%edx
  8008af:	73 0a                	jae    8008bb <sprintputch+0x1b>
		*b->buf++ = ch;
  8008b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008b4:	88 0a                	mov    %cl,(%edx)
  8008b6:	83 c2 01             	add    $0x1,%edx
  8008b9:	89 10                	mov    %edx,(%eax)
}
  8008bb:	5d                   	pop    %ebp
  8008bc:	c3                   	ret    

008008bd <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8008bd:	55                   	push   %ebp
  8008be:	89 e5                	mov    %esp,%ebp
  8008c0:	57                   	push   %edi
  8008c1:	56                   	push   %esi
  8008c2:	53                   	push   %ebx
  8008c3:	83 ec 5c             	sub    $0x5c,%esp
  8008c6:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008c9:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008cc:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008cf:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  8008d6:	eb 11                	jmp    8008e9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  8008d8:	85 c0                	test   %eax,%eax
  8008da:	0f 84 09 04 00 00    	je     800ce9 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  8008e0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8008e4:	89 04 24             	mov    %eax,(%esp)
  8008e7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8008e9:	0f b6 03             	movzbl (%ebx),%eax
  8008ec:	83 c3 01             	add    $0x1,%ebx
  8008ef:	83 f8 25             	cmp    $0x25,%eax
  8008f2:	75 e4                	jne    8008d8 <vprintfmt+0x1b>
  8008f4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8008f8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8008ff:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  800906:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80090d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800912:	eb 06                	jmp    80091a <vprintfmt+0x5d>
  800914:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  800918:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80091a:	0f b6 13             	movzbl (%ebx),%edx
  80091d:	0f b6 c2             	movzbl %dl,%eax
  800920:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800923:	8d 43 01             	lea    0x1(%ebx),%eax
  800926:	83 ea 23             	sub    $0x23,%edx
  800929:	80 fa 55             	cmp    $0x55,%dl
  80092c:	0f 87 9a 03 00 00    	ja     800ccc <vprintfmt+0x40f>
  800932:	0f b6 d2             	movzbl %dl,%edx
  800935:	ff 24 95 c0 37 80 00 	jmp    *0x8037c0(,%edx,4)
  80093c:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800940:	eb d6                	jmp    800918 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800942:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800945:	83 ea 30             	sub    $0x30,%edx
  800948:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  80094b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80094e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800951:	83 fb 09             	cmp    $0x9,%ebx
  800954:	77 4c                	ja     8009a2 <vprintfmt+0xe5>
  800956:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800959:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80095c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80095f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800962:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800966:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800969:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80096c:	83 fb 09             	cmp    $0x9,%ebx
  80096f:	76 eb                	jbe    80095c <vprintfmt+0x9f>
  800971:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800974:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800977:	eb 29                	jmp    8009a2 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800979:	8b 55 14             	mov    0x14(%ebp),%edx
  80097c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80097f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800982:	8b 12                	mov    (%edx),%edx
  800984:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  800987:	eb 19                	jmp    8009a2 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800989:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80098c:	c1 fa 1f             	sar    $0x1f,%edx
  80098f:	f7 d2                	not    %edx
  800991:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800994:	eb 82                	jmp    800918 <vprintfmt+0x5b>
  800996:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80099d:	e9 76 ff ff ff       	jmp    800918 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  8009a2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a6:	0f 89 6c ff ff ff    	jns    800918 <vprintfmt+0x5b>
  8009ac:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8009af:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8009b2:	8b 55 c8             	mov    -0x38(%ebp),%edx
  8009b5:	89 55 cc             	mov    %edx,-0x34(%ebp)
  8009b8:	e9 5b ff ff ff       	jmp    800918 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8009bd:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  8009c0:	e9 53 ff ff ff       	jmp    800918 <vprintfmt+0x5b>
  8009c5:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8009c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cb:	8d 50 04             	lea    0x4(%eax),%edx
  8009ce:	89 55 14             	mov    %edx,0x14(%ebp)
  8009d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009d5:	8b 00                	mov    (%eax),%eax
  8009d7:	89 04 24             	mov    %eax,(%esp)
  8009da:	ff d7                	call   *%edi
  8009dc:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8009df:	e9 05 ff ff ff       	jmp    8008e9 <vprintfmt+0x2c>
  8009e4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ea:	8d 50 04             	lea    0x4(%eax),%edx
  8009ed:	89 55 14             	mov    %edx,0x14(%ebp)
  8009f0:	8b 00                	mov    (%eax),%eax
  8009f2:	89 c2                	mov    %eax,%edx
  8009f4:	c1 fa 1f             	sar    $0x1f,%edx
  8009f7:	31 d0                	xor    %edx,%eax
  8009f9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009fb:	83 f8 0f             	cmp    $0xf,%eax
  8009fe:	7f 0b                	jg     800a0b <vprintfmt+0x14e>
  800a00:	8b 14 85 20 39 80 00 	mov    0x803920(,%eax,4),%edx
  800a07:	85 d2                	test   %edx,%edx
  800a09:	75 20                	jne    800a2b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  800a0b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a0f:	c7 44 24 08 9a 36 80 	movl   $0x80369a,0x8(%esp)
  800a16:	00 
  800a17:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a1b:	89 3c 24             	mov    %edi,(%esp)
  800a1e:	e8 4e 03 00 00       	call   800d71 <printfmt>
  800a23:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a26:	e9 be fe ff ff       	jmp    8008e9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800a2b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a2f:	c7 44 24 08 31 3b 80 	movl   $0x803b31,0x8(%esp)
  800a36:	00 
  800a37:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a3b:	89 3c 24             	mov    %edi,(%esp)
  800a3e:	e8 2e 03 00 00       	call   800d71 <printfmt>
  800a43:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800a46:	e9 9e fe ff ff       	jmp    8008e9 <vprintfmt+0x2c>
  800a4b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a4e:	89 c3                	mov    %eax,%ebx
  800a50:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800a53:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a56:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a59:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5c:	8d 50 04             	lea    0x4(%eax),%edx
  800a5f:	89 55 14             	mov    %edx,0x14(%ebp)
  800a62:	8b 00                	mov    (%eax),%eax
  800a64:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800a67:	85 c0                	test   %eax,%eax
  800a69:	75 07                	jne    800a72 <vprintfmt+0x1b5>
  800a6b:	c7 45 c4 a3 36 80 00 	movl   $0x8036a3,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800a72:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  800a76:	7e 06                	jle    800a7e <vprintfmt+0x1c1>
  800a78:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  800a7c:	75 13                	jne    800a91 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a7e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800a81:	0f be 02             	movsbl (%edx),%eax
  800a84:	85 c0                	test   %eax,%eax
  800a86:	0f 85 99 00 00 00    	jne    800b25 <vprintfmt+0x268>
  800a8c:	e9 86 00 00 00       	jmp    800b17 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a91:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800a95:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800a98:	89 0c 24             	mov    %ecx,(%esp)
  800a9b:	e8 1b 03 00 00       	call   800dbb <strnlen>
  800aa0:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800aa3:	29 c2                	sub    %eax,%edx
  800aa5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800aa8:	85 d2                	test   %edx,%edx
  800aaa:	7e d2                	jle    800a7e <vprintfmt+0x1c1>
					putch(padc, putdat);
  800aac:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  800ab0:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800ab3:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  800ab6:	89 d3                	mov    %edx,%ebx
  800ab8:	89 74 24 04          	mov    %esi,0x4(%esp)
  800abc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800abf:	89 04 24             	mov    %eax,(%esp)
  800ac2:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800ac4:	83 eb 01             	sub    $0x1,%ebx
  800ac7:	85 db                	test   %ebx,%ebx
  800ac9:	7f ed                	jg     800ab8 <vprintfmt+0x1fb>
  800acb:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  800ace:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800ad5:	eb a7                	jmp    800a7e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800ad7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  800adb:	74 18                	je     800af5 <vprintfmt+0x238>
  800add:	8d 50 e0             	lea    -0x20(%eax),%edx
  800ae0:	83 fa 5e             	cmp    $0x5e,%edx
  800ae3:	76 10                	jbe    800af5 <vprintfmt+0x238>
					putch('?', putdat);
  800ae5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800ae9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800af0:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800af3:	eb 0a                	jmp    800aff <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  800af5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800af9:	89 04 24             	mov    %eax,(%esp)
  800afc:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800aff:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800b03:	0f be 03             	movsbl (%ebx),%eax
  800b06:	85 c0                	test   %eax,%eax
  800b08:	74 05                	je     800b0f <vprintfmt+0x252>
  800b0a:	83 c3 01             	add    $0x1,%ebx
  800b0d:	eb 29                	jmp    800b38 <vprintfmt+0x27b>
  800b0f:	89 fe                	mov    %edi,%esi
  800b11:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800b14:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b1b:	7f 2e                	jg     800b4b <vprintfmt+0x28e>
  800b1d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800b20:	e9 c4 fd ff ff       	jmp    8008e9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b25:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800b28:	83 c2 01             	add    $0x1,%edx
  800b2b:	89 7d dc             	mov    %edi,-0x24(%ebp)
  800b2e:	89 f7                	mov    %esi,%edi
  800b30:	8b 75 cc             	mov    -0x34(%ebp),%esi
  800b33:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  800b36:	89 d3                	mov    %edx,%ebx
  800b38:	85 f6                	test   %esi,%esi
  800b3a:	78 9b                	js     800ad7 <vprintfmt+0x21a>
  800b3c:	83 ee 01             	sub    $0x1,%esi
  800b3f:	79 96                	jns    800ad7 <vprintfmt+0x21a>
  800b41:	89 fe                	mov    %edi,%esi
  800b43:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800b46:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800b49:	eb cc                	jmp    800b17 <vprintfmt+0x25a>
  800b4b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  800b4e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800b51:	89 74 24 04          	mov    %esi,0x4(%esp)
  800b55:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800b5c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b5e:	83 eb 01             	sub    $0x1,%ebx
  800b61:	85 db                	test   %ebx,%ebx
  800b63:	7f ec                	jg     800b51 <vprintfmt+0x294>
  800b65:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800b68:	e9 7c fd ff ff       	jmp    8008e9 <vprintfmt+0x2c>
  800b6d:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800b70:	83 f9 01             	cmp    $0x1,%ecx
  800b73:	7e 16                	jle    800b8b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800b75:	8b 45 14             	mov    0x14(%ebp),%eax
  800b78:	8d 50 08             	lea    0x8(%eax),%edx
  800b7b:	89 55 14             	mov    %edx,0x14(%ebp)
  800b7e:	8b 10                	mov    (%eax),%edx
  800b80:	8b 48 04             	mov    0x4(%eax),%ecx
  800b83:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800b86:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800b89:	eb 32                	jmp    800bbd <vprintfmt+0x300>
	else if (lflag)
  800b8b:	85 c9                	test   %ecx,%ecx
  800b8d:	74 18                	je     800ba7 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  800b8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b92:	8d 50 04             	lea    0x4(%eax),%edx
  800b95:	89 55 14             	mov    %edx,0x14(%ebp)
  800b98:	8b 00                	mov    (%eax),%eax
  800b9a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b9d:	89 c1                	mov    %eax,%ecx
  800b9f:	c1 f9 1f             	sar    $0x1f,%ecx
  800ba2:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800ba5:	eb 16                	jmp    800bbd <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800ba7:	8b 45 14             	mov    0x14(%ebp),%eax
  800baa:	8d 50 04             	lea    0x4(%eax),%edx
  800bad:	89 55 14             	mov    %edx,0x14(%ebp)
  800bb0:	8b 00                	mov    (%eax),%eax
  800bb2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800bb5:	89 c2                	mov    %eax,%edx
  800bb7:	c1 fa 1f             	sar    $0x1f,%edx
  800bba:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bbd:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800bc0:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800bc3:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800bc8:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  800bcc:	0f 89 b8 00 00 00    	jns    800c8a <vprintfmt+0x3cd>
				putch('-', putdat);
  800bd2:	89 74 24 04          	mov    %esi,0x4(%esp)
  800bd6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800bdd:	ff d7                	call   *%edi
				num = -(long long) num;
  800bdf:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800be2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800be5:	f7 d9                	neg    %ecx
  800be7:	83 d3 00             	adc    $0x0,%ebx
  800bea:	f7 db                	neg    %ebx
  800bec:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bf1:	e9 94 00 00 00       	jmp    800c8a <vprintfmt+0x3cd>
  800bf6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800bf9:	89 ca                	mov    %ecx,%edx
  800bfb:	8d 45 14             	lea    0x14(%ebp),%eax
  800bfe:	e8 63 fc ff ff       	call   800866 <getuint>
  800c03:	89 c1                	mov    %eax,%ecx
  800c05:	89 d3                	mov    %edx,%ebx
  800c07:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  800c0c:	eb 7c                	jmp    800c8a <vprintfmt+0x3cd>
  800c0e:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c11:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c15:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800c1c:	ff d7                	call   *%edi
			putch('X', putdat);
  800c1e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c22:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800c29:	ff d7                	call   *%edi
			putch('X', putdat);
  800c2b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c2f:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  800c36:	ff d7                	call   *%edi
  800c38:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800c3b:	e9 a9 fc ff ff       	jmp    8008e9 <vprintfmt+0x2c>
  800c40:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800c43:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c47:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800c4e:	ff d7                	call   *%edi
			putch('x', putdat);
  800c50:	89 74 24 04          	mov    %esi,0x4(%esp)
  800c54:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800c5b:	ff d7                	call   *%edi
			num = (unsigned long long)
  800c5d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c60:	8d 50 04             	lea    0x4(%eax),%edx
  800c63:	89 55 14             	mov    %edx,0x14(%ebp)
  800c66:	8b 08                	mov    (%eax),%ecx
  800c68:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c6d:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800c72:	eb 16                	jmp    800c8a <vprintfmt+0x3cd>
  800c74:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c77:	89 ca                	mov    %ecx,%edx
  800c79:	8d 45 14             	lea    0x14(%ebp),%eax
  800c7c:	e8 e5 fb ff ff       	call   800866 <getuint>
  800c81:	89 c1                	mov    %eax,%ecx
  800c83:	89 d3                	mov    %edx,%ebx
  800c85:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800c8a:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  800c8e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800c92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800c95:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800c99:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c9d:	89 0c 24             	mov    %ecx,(%esp)
  800ca0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800ca4:	89 f2                	mov    %esi,%edx
  800ca6:	89 f8                	mov    %edi,%eax
  800ca8:	e8 c3 fa ff ff       	call   800770 <printnum>
  800cad:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800cb0:	e9 34 fc ff ff       	jmp    8008e9 <vprintfmt+0x2c>
  800cb5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cb8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cbb:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cbf:	89 14 24             	mov    %edx,(%esp)
  800cc2:	ff d7                	call   *%edi
  800cc4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800cc7:	e9 1d fc ff ff       	jmp    8008e9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ccc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800cd0:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800cd7:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cd9:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800cdc:	80 38 25             	cmpb   $0x25,(%eax)
  800cdf:	0f 84 04 fc ff ff    	je     8008e9 <vprintfmt+0x2c>
  800ce5:	89 c3                	mov    %eax,%ebx
  800ce7:	eb f0                	jmp    800cd9 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  800ce9:	83 c4 5c             	add    $0x5c,%esp
  800cec:	5b                   	pop    %ebx
  800ced:	5e                   	pop    %esi
  800cee:	5f                   	pop    %edi
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
  800cf4:	83 ec 28             	sub    $0x28,%esp
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800cfd:	85 c0                	test   %eax,%eax
  800cff:	74 04                	je     800d05 <vsnprintf+0x14>
  800d01:	85 d2                	test   %edx,%edx
  800d03:	7f 07                	jg     800d0c <vsnprintf+0x1b>
  800d05:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d0a:	eb 3b                	jmp    800d47 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d0c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d0f:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800d13:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d16:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d20:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d24:	8b 45 10             	mov    0x10(%ebp),%eax
  800d27:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d2b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d32:	c7 04 24 a0 08 80 00 	movl   $0x8008a0,(%esp)
  800d39:	e8 7f fb ff ff       	call   8008bd <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d41:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800d47:	c9                   	leave  
  800d48:	c3                   	ret    

00800d49 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800d4f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800d52:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d56:	8b 45 10             	mov    0x10(%ebp),%eax
  800d59:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d60:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	89 04 24             	mov    %eax,(%esp)
  800d6a:	e8 82 ff ff ff       	call   800cf1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800d6f:	c9                   	leave  
  800d70:	c3                   	ret    

00800d71 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d71:	55                   	push   %ebp
  800d72:	89 e5                	mov    %esp,%ebp
  800d74:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800d77:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800d7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d81:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	89 04 24             	mov    %eax,(%esp)
  800d92:	e8 26 fb ff ff       	call   8008bd <vprintfmt>
	va_end(ap);
}
  800d97:	c9                   	leave  
  800d98:	c3                   	ret    
  800d99:	00 00                	add    %al,(%eax)
  800d9b:	00 00                	add    %al,(%eax)
  800d9d:	00 00                	add    %al,(%eax)
	...

00800da0 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
  800da3:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800da6:	b8 00 00 00 00       	mov    $0x0,%eax
  800dab:	80 3a 00             	cmpb   $0x0,(%edx)
  800dae:	74 09                	je     800db9 <strlen+0x19>
		n++;
  800db0:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800db3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800db7:	75 f7                	jne    800db0 <strlen+0x10>
		n++;
	return n;
}
  800db9:	5d                   	pop    %ebp
  800dba:	c3                   	ret    

00800dbb <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	53                   	push   %ebx
  800dbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800dc2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dc5:	85 c9                	test   %ecx,%ecx
  800dc7:	74 19                	je     800de2 <strnlen+0x27>
  800dc9:	80 3b 00             	cmpb   $0x0,(%ebx)
  800dcc:	74 14                	je     800de2 <strnlen+0x27>
  800dce:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800dd3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd6:	39 c8                	cmp    %ecx,%eax
  800dd8:	74 0d                	je     800de7 <strnlen+0x2c>
  800dda:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800dde:	75 f3                	jne    800dd3 <strnlen+0x18>
  800de0:	eb 05                	jmp    800de7 <strnlen+0x2c>
  800de2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800de7:	5b                   	pop    %ebx
  800de8:	5d                   	pop    %ebp
  800de9:	c3                   	ret    

00800dea <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800dea:	55                   	push   %ebp
  800deb:	89 e5                	mov    %esp,%ebp
  800ded:	53                   	push   %ebx
  800dee:	8b 45 08             	mov    0x8(%ebp),%eax
  800df1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800df4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800df9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800dfd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800e00:	83 c2 01             	add    $0x1,%edx
  800e03:	84 c9                	test   %cl,%cl
  800e05:	75 f2                	jne    800df9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800e07:	5b                   	pop    %ebx
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	56                   	push   %esi
  800e0e:	53                   	push   %ebx
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e15:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e18:	85 f6                	test   %esi,%esi
  800e1a:	74 18                	je     800e34 <strncpy+0x2a>
  800e1c:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800e21:	0f b6 1a             	movzbl (%edx),%ebx
  800e24:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800e27:	80 3a 01             	cmpb   $0x1,(%edx)
  800e2a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e2d:	83 c1 01             	add    $0x1,%ecx
  800e30:	39 ce                	cmp    %ecx,%esi
  800e32:	77 ed                	ja     800e21 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800e34:	5b                   	pop    %ebx
  800e35:	5e                   	pop    %esi
  800e36:	5d                   	pop    %ebp
  800e37:	c3                   	ret    

00800e38 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	56                   	push   %esi
  800e3c:	53                   	push   %ebx
  800e3d:	8b 75 08             	mov    0x8(%ebp),%esi
  800e40:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e43:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e46:	89 f0                	mov    %esi,%eax
  800e48:	85 c9                	test   %ecx,%ecx
  800e4a:	74 27                	je     800e73 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800e4c:	83 e9 01             	sub    $0x1,%ecx
  800e4f:	74 1d                	je     800e6e <strlcpy+0x36>
  800e51:	0f b6 1a             	movzbl (%edx),%ebx
  800e54:	84 db                	test   %bl,%bl
  800e56:	74 16                	je     800e6e <strlcpy+0x36>
			*dst++ = *src++;
  800e58:	88 18                	mov    %bl,(%eax)
  800e5a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e5d:	83 e9 01             	sub    $0x1,%ecx
  800e60:	74 0e                	je     800e70 <strlcpy+0x38>
			*dst++ = *src++;
  800e62:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e65:	0f b6 1a             	movzbl (%edx),%ebx
  800e68:	84 db                	test   %bl,%bl
  800e6a:	75 ec                	jne    800e58 <strlcpy+0x20>
  800e6c:	eb 02                	jmp    800e70 <strlcpy+0x38>
  800e6e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800e70:	c6 00 00             	movb   $0x0,(%eax)
  800e73:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800e75:	5b                   	pop    %ebx
  800e76:	5e                   	pop    %esi
  800e77:	5d                   	pop    %ebp
  800e78:	c3                   	ret    

00800e79 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e7f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e82:	0f b6 01             	movzbl (%ecx),%eax
  800e85:	84 c0                	test   %al,%al
  800e87:	74 15                	je     800e9e <strcmp+0x25>
  800e89:	3a 02                	cmp    (%edx),%al
  800e8b:	75 11                	jne    800e9e <strcmp+0x25>
		p++, q++;
  800e8d:	83 c1 01             	add    $0x1,%ecx
  800e90:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e93:	0f b6 01             	movzbl (%ecx),%eax
  800e96:	84 c0                	test   %al,%al
  800e98:	74 04                	je     800e9e <strcmp+0x25>
  800e9a:	3a 02                	cmp    (%edx),%al
  800e9c:	74 ef                	je     800e8d <strcmp+0x14>
  800e9e:	0f b6 c0             	movzbl %al,%eax
  800ea1:	0f b6 12             	movzbl (%edx),%edx
  800ea4:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ea6:	5d                   	pop    %ebp
  800ea7:	c3                   	ret    

00800ea8 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
  800eab:	53                   	push   %ebx
  800eac:	8b 55 08             	mov    0x8(%ebp),%edx
  800eaf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb2:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	74 23                	je     800edc <strncmp+0x34>
  800eb9:	0f b6 1a             	movzbl (%edx),%ebx
  800ebc:	84 db                	test   %bl,%bl
  800ebe:	74 24                	je     800ee4 <strncmp+0x3c>
  800ec0:	3a 19                	cmp    (%ecx),%bl
  800ec2:	75 20                	jne    800ee4 <strncmp+0x3c>
  800ec4:	83 e8 01             	sub    $0x1,%eax
  800ec7:	74 13                	je     800edc <strncmp+0x34>
		n--, p++, q++;
  800ec9:	83 c2 01             	add    $0x1,%edx
  800ecc:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800ecf:	0f b6 1a             	movzbl (%edx),%ebx
  800ed2:	84 db                	test   %bl,%bl
  800ed4:	74 0e                	je     800ee4 <strncmp+0x3c>
  800ed6:	3a 19                	cmp    (%ecx),%bl
  800ed8:	74 ea                	je     800ec4 <strncmp+0x1c>
  800eda:	eb 08                	jmp    800ee4 <strncmp+0x3c>
  800edc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ee1:	5b                   	pop    %ebx
  800ee2:	5d                   	pop    %ebp
  800ee3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ee4:	0f b6 02             	movzbl (%edx),%eax
  800ee7:	0f b6 11             	movzbl (%ecx),%edx
  800eea:	29 d0                	sub    %edx,%eax
  800eec:	eb f3                	jmp    800ee1 <strncmp+0x39>

00800eee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ef8:	0f b6 10             	movzbl (%eax),%edx
  800efb:	84 d2                	test   %dl,%dl
  800efd:	74 15                	je     800f14 <strchr+0x26>
		if (*s == c)
  800eff:	38 ca                	cmp    %cl,%dl
  800f01:	75 07                	jne    800f0a <strchr+0x1c>
  800f03:	eb 14                	jmp    800f19 <strchr+0x2b>
  800f05:	38 ca                	cmp    %cl,%dl
  800f07:	90                   	nop
  800f08:	74 0f                	je     800f19 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f0a:	83 c0 01             	add    $0x1,%eax
  800f0d:	0f b6 10             	movzbl (%eax),%edx
  800f10:	84 d2                	test   %dl,%dl
  800f12:	75 f1                	jne    800f05 <strchr+0x17>
  800f14:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800f19:	5d                   	pop    %ebp
  800f1a:	c3                   	ret    

00800f1b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f21:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800f25:	0f b6 10             	movzbl (%eax),%edx
  800f28:	84 d2                	test   %dl,%dl
  800f2a:	74 18                	je     800f44 <strfind+0x29>
		if (*s == c)
  800f2c:	38 ca                	cmp    %cl,%dl
  800f2e:	75 0a                	jne    800f3a <strfind+0x1f>
  800f30:	eb 12                	jmp    800f44 <strfind+0x29>
  800f32:	38 ca                	cmp    %cl,%dl
  800f34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800f38:	74 0a                	je     800f44 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800f3a:	83 c0 01             	add    $0x1,%eax
  800f3d:	0f b6 10             	movzbl (%eax),%edx
  800f40:	84 d2                	test   %dl,%dl
  800f42:	75 ee                	jne    800f32 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	83 ec 0c             	sub    $0xc,%esp
  800f4c:	89 1c 24             	mov    %ebx,(%esp)
  800f4f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f53:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800f57:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f60:	85 c9                	test   %ecx,%ecx
  800f62:	74 30                	je     800f94 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f64:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800f6a:	75 25                	jne    800f91 <memset+0x4b>
  800f6c:	f6 c1 03             	test   $0x3,%cl
  800f6f:	75 20                	jne    800f91 <memset+0x4b>
		c &= 0xFF;
  800f71:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f74:	89 d3                	mov    %edx,%ebx
  800f76:	c1 e3 08             	shl    $0x8,%ebx
  800f79:	89 d6                	mov    %edx,%esi
  800f7b:	c1 e6 18             	shl    $0x18,%esi
  800f7e:	89 d0                	mov    %edx,%eax
  800f80:	c1 e0 10             	shl    $0x10,%eax
  800f83:	09 f0                	or     %esi,%eax
  800f85:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800f87:	09 d8                	or     %ebx,%eax
  800f89:	c1 e9 02             	shr    $0x2,%ecx
  800f8c:	fc                   	cld    
  800f8d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f8f:	eb 03                	jmp    800f94 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f91:	fc                   	cld    
  800f92:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f94:	89 f8                	mov    %edi,%eax
  800f96:	8b 1c 24             	mov    (%esp),%ebx
  800f99:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f9d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fa1:	89 ec                	mov    %ebp,%esp
  800fa3:	5d                   	pop    %ebp
  800fa4:	c3                   	ret    

00800fa5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800fa5:	55                   	push   %ebp
  800fa6:	89 e5                	mov    %esp,%ebp
  800fa8:	83 ec 08             	sub    $0x8,%esp
  800fab:	89 34 24             	mov    %esi,(%esp)
  800fae:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800fb8:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800fbb:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800fbd:	39 c6                	cmp    %eax,%esi
  800fbf:	73 35                	jae    800ff6 <memmove+0x51>
  800fc1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800fc4:	39 d0                	cmp    %edx,%eax
  800fc6:	73 2e                	jae    800ff6 <memmove+0x51>
		s += n;
		d += n;
  800fc8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fca:	f6 c2 03             	test   $0x3,%dl
  800fcd:	75 1b                	jne    800fea <memmove+0x45>
  800fcf:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800fd5:	75 13                	jne    800fea <memmove+0x45>
  800fd7:	f6 c1 03             	test   $0x3,%cl
  800fda:	75 0e                	jne    800fea <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800fdc:	83 ef 04             	sub    $0x4,%edi
  800fdf:	8d 72 fc             	lea    -0x4(%edx),%esi
  800fe2:	c1 e9 02             	shr    $0x2,%ecx
  800fe5:	fd                   	std    
  800fe6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fe8:	eb 09                	jmp    800ff3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800fea:	83 ef 01             	sub    $0x1,%edi
  800fed:	8d 72 ff             	lea    -0x1(%edx),%esi
  800ff0:	fd                   	std    
  800ff1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800ff3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ff4:	eb 20                	jmp    801016 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ff6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ffc:	75 15                	jne    801013 <memmove+0x6e>
  800ffe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801004:	75 0d                	jne    801013 <memmove+0x6e>
  801006:	f6 c1 03             	test   $0x3,%cl
  801009:	75 08                	jne    801013 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  80100b:	c1 e9 02             	shr    $0x2,%ecx
  80100e:	fc                   	cld    
  80100f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801011:	eb 03                	jmp    801016 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801013:	fc                   	cld    
  801014:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801016:	8b 34 24             	mov    (%esp),%esi
  801019:	8b 7c 24 04          	mov    0x4(%esp),%edi
  80101d:	89 ec                	mov    %ebp,%esp
  80101f:	5d                   	pop    %ebp
  801020:	c3                   	ret    

00801021 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  801021:	55                   	push   %ebp
  801022:	89 e5                	mov    %esp,%ebp
  801024:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  801027:	8b 45 10             	mov    0x10(%ebp),%eax
  80102a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80102e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801031:	89 44 24 04          	mov    %eax,0x4(%esp)
  801035:	8b 45 08             	mov    0x8(%ebp),%eax
  801038:	89 04 24             	mov    %eax,(%esp)
  80103b:	e8 65 ff ff ff       	call   800fa5 <memmove>
}
  801040:	c9                   	leave  
  801041:	c3                   	ret    

00801042 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	57                   	push   %edi
  801046:	56                   	push   %esi
  801047:	53                   	push   %ebx
  801048:	8b 75 08             	mov    0x8(%ebp),%esi
  80104b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80104e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  801051:	85 c9                	test   %ecx,%ecx
  801053:	74 36                	je     80108b <memcmp+0x49>
		if (*s1 != *s2)
  801055:	0f b6 06             	movzbl (%esi),%eax
  801058:	0f b6 1f             	movzbl (%edi),%ebx
  80105b:	38 d8                	cmp    %bl,%al
  80105d:	74 20                	je     80107f <memcmp+0x3d>
  80105f:	eb 14                	jmp    801075 <memcmp+0x33>
  801061:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  801066:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  80106b:	83 c2 01             	add    $0x1,%edx
  80106e:	83 e9 01             	sub    $0x1,%ecx
  801071:	38 d8                	cmp    %bl,%al
  801073:	74 12                	je     801087 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  801075:	0f b6 c0             	movzbl %al,%eax
  801078:	0f b6 db             	movzbl %bl,%ebx
  80107b:	29 d8                	sub    %ebx,%eax
  80107d:	eb 11                	jmp    801090 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80107f:	83 e9 01             	sub    $0x1,%ecx
  801082:	ba 00 00 00 00       	mov    $0x0,%edx
  801087:	85 c9                	test   %ecx,%ecx
  801089:	75 d6                	jne    801061 <memcmp+0x1f>
  80108b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  801090:	5b                   	pop    %ebx
  801091:	5e                   	pop    %esi
  801092:	5f                   	pop    %edi
  801093:	5d                   	pop    %ebp
  801094:	c3                   	ret    

00801095 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80109b:	89 c2                	mov    %eax,%edx
  80109d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8010a0:	39 d0                	cmp    %edx,%eax
  8010a2:	73 15                	jae    8010b9 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010a4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  8010a8:	38 08                	cmp    %cl,(%eax)
  8010aa:	75 06                	jne    8010b2 <memfind+0x1d>
  8010ac:	eb 0b                	jmp    8010b9 <memfind+0x24>
  8010ae:	38 08                	cmp    %cl,(%eax)
  8010b0:	74 07                	je     8010b9 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8010b2:	83 c0 01             	add    $0x1,%eax
  8010b5:	39 c2                	cmp    %eax,%edx
  8010b7:	77 f5                	ja     8010ae <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  8010b9:	5d                   	pop    %ebp
  8010ba:	c3                   	ret    

008010bb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
  8010be:	57                   	push   %edi
  8010bf:	56                   	push   %esi
  8010c0:	53                   	push   %ebx
  8010c1:	83 ec 04             	sub    $0x4,%esp
  8010c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010ca:	0f b6 02             	movzbl (%edx),%eax
  8010cd:	3c 20                	cmp    $0x20,%al
  8010cf:	74 04                	je     8010d5 <strtol+0x1a>
  8010d1:	3c 09                	cmp    $0x9,%al
  8010d3:	75 0e                	jne    8010e3 <strtol+0x28>
		s++;
  8010d5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010d8:	0f b6 02             	movzbl (%edx),%eax
  8010db:	3c 20                	cmp    $0x20,%al
  8010dd:	74 f6                	je     8010d5 <strtol+0x1a>
  8010df:	3c 09                	cmp    $0x9,%al
  8010e1:	74 f2                	je     8010d5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010e3:	3c 2b                	cmp    $0x2b,%al
  8010e5:	75 0c                	jne    8010f3 <strtol+0x38>
		s++;
  8010e7:	83 c2 01             	add    $0x1,%edx
  8010ea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010f1:	eb 15                	jmp    801108 <strtol+0x4d>
	else if (*s == '-')
  8010f3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8010fa:	3c 2d                	cmp    $0x2d,%al
  8010fc:	75 0a                	jne    801108 <strtol+0x4d>
		s++, neg = 1;
  8010fe:	83 c2 01             	add    $0x1,%edx
  801101:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801108:	85 db                	test   %ebx,%ebx
  80110a:	0f 94 c0             	sete   %al
  80110d:	74 05                	je     801114 <strtol+0x59>
  80110f:	83 fb 10             	cmp    $0x10,%ebx
  801112:	75 18                	jne    80112c <strtol+0x71>
  801114:	80 3a 30             	cmpb   $0x30,(%edx)
  801117:	75 13                	jne    80112c <strtol+0x71>
  801119:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  80111d:	8d 76 00             	lea    0x0(%esi),%esi
  801120:	75 0a                	jne    80112c <strtol+0x71>
		s += 2, base = 16;
  801122:	83 c2 02             	add    $0x2,%edx
  801125:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80112a:	eb 15                	jmp    801141 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80112c:	84 c0                	test   %al,%al
  80112e:	66 90                	xchg   %ax,%ax
  801130:	74 0f                	je     801141 <strtol+0x86>
  801132:	bb 0a 00 00 00       	mov    $0xa,%ebx
  801137:	80 3a 30             	cmpb   $0x30,(%edx)
  80113a:	75 05                	jne    801141 <strtol+0x86>
		s++, base = 8;
  80113c:	83 c2 01             	add    $0x1,%edx
  80113f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801141:	b8 00 00 00 00       	mov    $0x0,%eax
  801146:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801148:	0f b6 0a             	movzbl (%edx),%ecx
  80114b:	89 cf                	mov    %ecx,%edi
  80114d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  801150:	80 fb 09             	cmp    $0x9,%bl
  801153:	77 08                	ja     80115d <strtol+0xa2>
			dig = *s - '0';
  801155:	0f be c9             	movsbl %cl,%ecx
  801158:	83 e9 30             	sub    $0x30,%ecx
  80115b:	eb 1e                	jmp    80117b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  80115d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  801160:	80 fb 19             	cmp    $0x19,%bl
  801163:	77 08                	ja     80116d <strtol+0xb2>
			dig = *s - 'a' + 10;
  801165:	0f be c9             	movsbl %cl,%ecx
  801168:	83 e9 57             	sub    $0x57,%ecx
  80116b:	eb 0e                	jmp    80117b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  80116d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  801170:	80 fb 19             	cmp    $0x19,%bl
  801173:	77 15                	ja     80118a <strtol+0xcf>
			dig = *s - 'A' + 10;
  801175:	0f be c9             	movsbl %cl,%ecx
  801178:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80117b:	39 f1                	cmp    %esi,%ecx
  80117d:	7d 0b                	jge    80118a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  80117f:	83 c2 01             	add    $0x1,%edx
  801182:	0f af c6             	imul   %esi,%eax
  801185:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  801188:	eb be                	jmp    801148 <strtol+0x8d>
  80118a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80118c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801190:	74 05                	je     801197 <strtol+0xdc>
		*endptr = (char *) s;
  801192:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801195:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  801197:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80119b:	74 04                	je     8011a1 <strtol+0xe6>
  80119d:	89 c8                	mov    %ecx,%eax
  80119f:	f7 d8                	neg    %eax
}
  8011a1:	83 c4 04             	add    $0x4,%esp
  8011a4:	5b                   	pop    %ebx
  8011a5:	5e                   	pop    %esi
  8011a6:	5f                   	pop    %edi
  8011a7:	5d                   	pop    %ebp
  8011a8:	c3                   	ret    
  8011a9:	00 00                	add    %al,(%eax)
	...

008011ac <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  8011ac:	55                   	push   %ebp
  8011ad:	89 e5                	mov    %esp,%ebp
  8011af:	83 ec 0c             	sub    $0xc,%esp
  8011b2:	89 1c 24             	mov    %ebx,(%esp)
  8011b5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011b9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8011c7:	89 d1                	mov    %edx,%ecx
  8011c9:	89 d3                	mov    %edx,%ebx
  8011cb:	89 d7                	mov    %edx,%edi
  8011cd:	89 d6                	mov    %edx,%esi
  8011cf:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8011d1:	8b 1c 24             	mov    (%esp),%ebx
  8011d4:	8b 74 24 04          	mov    0x4(%esp),%esi
  8011d8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8011dc:	89 ec                	mov    %ebp,%esp
  8011de:	5d                   	pop    %ebp
  8011df:	c3                   	ret    

008011e0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8011e0:	55                   	push   %ebp
  8011e1:	89 e5                	mov    %esp,%ebp
  8011e3:	83 ec 0c             	sub    $0xc,%esp
  8011e6:	89 1c 24             	mov    %ebx,(%esp)
  8011e9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8011ed:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fc:	89 c3                	mov    %eax,%ebx
  8011fe:	89 c7                	mov    %eax,%edi
  801200:	89 c6                	mov    %eax,%esi
  801202:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801204:	8b 1c 24             	mov    (%esp),%ebx
  801207:	8b 74 24 04          	mov    0x4(%esp),%esi
  80120b:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80120f:	89 ec                	mov    %ebp,%esp
  801211:	5d                   	pop    %ebp
  801212:	c3                   	ret    

00801213 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  801213:	55                   	push   %ebp
  801214:	89 e5                	mov    %esp,%ebp
  801216:	83 ec 0c             	sub    $0xc,%esp
  801219:	89 1c 24             	mov    %ebx,(%esp)
  80121c:	89 74 24 04          	mov    %esi,0x4(%esp)
  801220:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801224:	bb 00 00 00 00       	mov    $0x0,%ebx
  801229:	b8 10 00 00 00       	mov    $0x10,%eax
  80122e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801231:	8b 55 08             	mov    0x8(%ebp),%edx
  801234:	89 df                	mov    %ebx,%edi
  801236:	89 de                	mov    %ebx,%esi
  801238:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  80123a:	8b 1c 24             	mov    (%esp),%ebx
  80123d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801241:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801245:	89 ec                	mov    %ebp,%esp
  801247:	5d                   	pop    %ebp
  801248:	c3                   	ret    

00801249 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	83 ec 38             	sub    $0x38,%esp
  80124f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801252:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801255:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801258:	bb 00 00 00 00       	mov    $0x0,%ebx
  80125d:	b8 0f 00 00 00       	mov    $0xf,%eax
  801262:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801265:	8b 55 08             	mov    0x8(%ebp),%edx
  801268:	89 df                	mov    %ebx,%edi
  80126a:	89 de                	mov    %ebx,%esi
  80126c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80126e:	85 c0                	test   %eax,%eax
  801270:	7e 28                	jle    80129a <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801272:	89 44 24 10          	mov    %eax,0x10(%esp)
  801276:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80127d:	00 
  80127e:	c7 44 24 08 7f 39 80 	movl   $0x80397f,0x8(%esp)
  801285:	00 
  801286:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80128d:	00 
  80128e:	c7 04 24 9c 39 80 00 	movl   $0x80399c,(%esp)
  801295:	e8 b2 f3 ff ff       	call   80064c <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  80129a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80129d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012a0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012a3:	89 ec                	mov    %ebp,%esp
  8012a5:	5d                   	pop    %ebp
  8012a6:	c3                   	ret    

008012a7 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	83 ec 0c             	sub    $0xc,%esp
  8012ad:	89 1c 24             	mov    %ebx,(%esp)
  8012b0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8012b4:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8012bd:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012c2:	89 d1                	mov    %edx,%ecx
  8012c4:	89 d3                	mov    %edx,%ebx
  8012c6:	89 d7                	mov    %edx,%edi
  8012c8:	89 d6                	mov    %edx,%esi
  8012ca:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8012cc:	8b 1c 24             	mov    (%esp),%ebx
  8012cf:	8b 74 24 04          	mov    0x4(%esp),%esi
  8012d3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8012d7:	89 ec                	mov    %ebp,%esp
  8012d9:	5d                   	pop    %ebp
  8012da:	c3                   	ret    

008012db <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8012db:	55                   	push   %ebp
  8012dc:	89 e5                	mov    %esp,%ebp
  8012de:	83 ec 38             	sub    $0x38,%esp
  8012e1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012e4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012e7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012ea:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012ef:	b8 0d 00 00 00       	mov    $0xd,%eax
  8012f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8012f7:	89 cb                	mov    %ecx,%ebx
  8012f9:	89 cf                	mov    %ecx,%edi
  8012fb:	89 ce                	mov    %ecx,%esi
  8012fd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8012ff:	85 c0                	test   %eax,%eax
  801301:	7e 28                	jle    80132b <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801303:	89 44 24 10          	mov    %eax,0x10(%esp)
  801307:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  80130e:	00 
  80130f:	c7 44 24 08 7f 39 80 	movl   $0x80397f,0x8(%esp)
  801316:	00 
  801317:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80131e:	00 
  80131f:	c7 04 24 9c 39 80 00 	movl   $0x80399c,(%esp)
  801326:	e8 21 f3 ff ff       	call   80064c <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80132b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80132e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801331:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801334:	89 ec                	mov    %ebp,%esp
  801336:	5d                   	pop    %ebp
  801337:	c3                   	ret    

00801338 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801338:	55                   	push   %ebp
  801339:	89 e5                	mov    %esp,%ebp
  80133b:	83 ec 0c             	sub    $0xc,%esp
  80133e:	89 1c 24             	mov    %ebx,(%esp)
  801341:	89 74 24 04          	mov    %esi,0x4(%esp)
  801345:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801349:	be 00 00 00 00       	mov    $0x0,%esi
  80134e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801353:	8b 7d 14             	mov    0x14(%ebp),%edi
  801356:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801359:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80135c:	8b 55 08             	mov    0x8(%ebp),%edx
  80135f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801361:	8b 1c 24             	mov    (%esp),%ebx
  801364:	8b 74 24 04          	mov    0x4(%esp),%esi
  801368:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80136c:	89 ec                	mov    %ebp,%esp
  80136e:	5d                   	pop    %ebp
  80136f:	c3                   	ret    

00801370 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801370:	55                   	push   %ebp
  801371:	89 e5                	mov    %esp,%ebp
  801373:	83 ec 38             	sub    $0x38,%esp
  801376:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801379:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80137c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80137f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801384:	b8 0a 00 00 00       	mov    $0xa,%eax
  801389:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80138c:	8b 55 08             	mov    0x8(%ebp),%edx
  80138f:	89 df                	mov    %ebx,%edi
  801391:	89 de                	mov    %ebx,%esi
  801393:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801395:	85 c0                	test   %eax,%eax
  801397:	7e 28                	jle    8013c1 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801399:	89 44 24 10          	mov    %eax,0x10(%esp)
  80139d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  8013a4:	00 
  8013a5:	c7 44 24 08 7f 39 80 	movl   $0x80397f,0x8(%esp)
  8013ac:	00 
  8013ad:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8013b4:	00 
  8013b5:	c7 04 24 9c 39 80 00 	movl   $0x80399c,(%esp)
  8013bc:	e8 8b f2 ff ff       	call   80064c <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8013c1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8013c4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8013c7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8013ca:	89 ec                	mov    %ebp,%esp
  8013cc:	5d                   	pop    %ebp
  8013cd:	c3                   	ret    

008013ce <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 38             	sub    $0x38,%esp
  8013d4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013d7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013da:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013dd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013e2:	b8 09 00 00 00       	mov    $0x9,%eax
  8013e7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8013ed:	89 df                	mov    %ebx,%edi
  8013ef:	89 de                	mov    %ebx,%esi
  8013f1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	7e 28                	jle    80141f <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013f7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013fb:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  801402:	00 
  801403:	c7 44 24 08 7f 39 80 	movl   $0x80397f,0x8(%esp)
  80140a:	00 
  80140b:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801412:	00 
  801413:	c7 04 24 9c 39 80 00 	movl   $0x80399c,(%esp)
  80141a:	e8 2d f2 ff ff       	call   80064c <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80141f:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801422:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801425:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801428:	89 ec                	mov    %ebp,%esp
  80142a:	5d                   	pop    %ebp
  80142b:	c3                   	ret    

0080142c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80142c:	55                   	push   %ebp
  80142d:	89 e5                	mov    %esp,%ebp
  80142f:	83 ec 38             	sub    $0x38,%esp
  801432:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801435:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801438:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80143b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801440:	b8 08 00 00 00       	mov    $0x8,%eax
  801445:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801448:	8b 55 08             	mov    0x8(%ebp),%edx
  80144b:	89 df                	mov    %ebx,%edi
  80144d:	89 de                	mov    %ebx,%esi
  80144f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801451:	85 c0                	test   %eax,%eax
  801453:	7e 28                	jle    80147d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801455:	89 44 24 10          	mov    %eax,0x10(%esp)
  801459:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801460:	00 
  801461:	c7 44 24 08 7f 39 80 	movl   $0x80397f,0x8(%esp)
  801468:	00 
  801469:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801470:	00 
  801471:	c7 04 24 9c 39 80 00 	movl   $0x80399c,(%esp)
  801478:	e8 cf f1 ff ff       	call   80064c <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80147d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801480:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801483:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801486:	89 ec                	mov    %ebp,%esp
  801488:	5d                   	pop    %ebp
  801489:	c3                   	ret    

0080148a <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80148a:	55                   	push   %ebp
  80148b:	89 e5                	mov    %esp,%ebp
  80148d:	83 ec 38             	sub    $0x38,%esp
  801490:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801493:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801496:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801499:	bb 00 00 00 00       	mov    $0x0,%ebx
  80149e:	b8 06 00 00 00       	mov    $0x6,%eax
  8014a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a9:	89 df                	mov    %ebx,%edi
  8014ab:	89 de                	mov    %ebx,%esi
  8014ad:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8014af:	85 c0                	test   %eax,%eax
  8014b1:	7e 28                	jle    8014db <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8014b3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8014b7:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  8014be:	00 
  8014bf:	c7 44 24 08 7f 39 80 	movl   $0x80397f,0x8(%esp)
  8014c6:	00 
  8014c7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8014ce:	00 
  8014cf:	c7 04 24 9c 39 80 00 	movl   $0x80399c,(%esp)
  8014d6:	e8 71 f1 ff ff       	call   80064c <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8014db:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8014de:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8014e1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8014e4:	89 ec                	mov    %ebp,%esp
  8014e6:	5d                   	pop    %ebp
  8014e7:	c3                   	ret    

008014e8 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	83 ec 38             	sub    $0x38,%esp
  8014ee:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8014f1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8014f4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014f7:	b8 05 00 00 00       	mov    $0x5,%eax
  8014fc:	8b 75 18             	mov    0x18(%ebp),%esi
  8014ff:	8b 7d 14             	mov    0x14(%ebp),%edi
  801502:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801505:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801508:	8b 55 08             	mov    0x8(%ebp),%edx
  80150b:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80150d:	85 c0                	test   %eax,%eax
  80150f:	7e 28                	jle    801539 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801511:	89 44 24 10          	mov    %eax,0x10(%esp)
  801515:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  80151c:	00 
  80151d:	c7 44 24 08 7f 39 80 	movl   $0x80397f,0x8(%esp)
  801524:	00 
  801525:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80152c:	00 
  80152d:	c7 04 24 9c 39 80 00 	movl   $0x80399c,(%esp)
  801534:	e8 13 f1 ff ff       	call   80064c <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801539:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80153c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80153f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801542:	89 ec                	mov    %ebp,%esp
  801544:	5d                   	pop    %ebp
  801545:	c3                   	ret    

00801546 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801546:	55                   	push   %ebp
  801547:	89 e5                	mov    %esp,%ebp
  801549:	83 ec 38             	sub    $0x38,%esp
  80154c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80154f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801552:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801555:	be 00 00 00 00       	mov    $0x0,%esi
  80155a:	b8 04 00 00 00       	mov    $0x4,%eax
  80155f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801562:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801565:	8b 55 08             	mov    0x8(%ebp),%edx
  801568:	89 f7                	mov    %esi,%edi
  80156a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80156c:	85 c0                	test   %eax,%eax
  80156e:	7e 28                	jle    801598 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801570:	89 44 24 10          	mov    %eax,0x10(%esp)
  801574:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80157b:	00 
  80157c:	c7 44 24 08 7f 39 80 	movl   $0x80397f,0x8(%esp)
  801583:	00 
  801584:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80158b:	00 
  80158c:	c7 04 24 9c 39 80 00 	movl   $0x80399c,(%esp)
  801593:	e8 b4 f0 ff ff       	call   80064c <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801598:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80159b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80159e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8015a1:	89 ec                	mov    %ebp,%esp
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    

008015a5 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
  8015a8:	83 ec 0c             	sub    $0xc,%esp
  8015ab:	89 1c 24             	mov    %ebx,(%esp)
  8015ae:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015b2:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015b6:	ba 00 00 00 00       	mov    $0x0,%edx
  8015bb:	b8 0b 00 00 00       	mov    $0xb,%eax
  8015c0:	89 d1                	mov    %edx,%ecx
  8015c2:	89 d3                	mov    %edx,%ebx
  8015c4:	89 d7                	mov    %edx,%edi
  8015c6:	89 d6                	mov    %edx,%esi
  8015c8:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8015ca:	8b 1c 24             	mov    (%esp),%ebx
  8015cd:	8b 74 24 04          	mov    0x4(%esp),%esi
  8015d1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8015d5:	89 ec                	mov    %ebp,%esp
  8015d7:	5d                   	pop    %ebp
  8015d8:	c3                   	ret    

008015d9 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8015d9:	55                   	push   %ebp
  8015da:	89 e5                	mov    %esp,%ebp
  8015dc:	83 ec 0c             	sub    $0xc,%esp
  8015df:	89 1c 24             	mov    %ebx,(%esp)
  8015e2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8015e6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8015ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ef:	b8 02 00 00 00       	mov    $0x2,%eax
  8015f4:	89 d1                	mov    %edx,%ecx
  8015f6:	89 d3                	mov    %edx,%ebx
  8015f8:	89 d7                	mov    %edx,%edi
  8015fa:	89 d6                	mov    %edx,%esi
  8015fc:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8015fe:	8b 1c 24             	mov    (%esp),%ebx
  801601:	8b 74 24 04          	mov    0x4(%esp),%esi
  801605:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801609:	89 ec                	mov    %ebp,%esp
  80160b:	5d                   	pop    %ebp
  80160c:	c3                   	ret    

0080160d <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  80160d:	55                   	push   %ebp
  80160e:	89 e5                	mov    %esp,%ebp
  801610:	83 ec 38             	sub    $0x38,%esp
  801613:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801616:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801619:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80161c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801621:	b8 03 00 00 00       	mov    $0x3,%eax
  801626:	8b 55 08             	mov    0x8(%ebp),%edx
  801629:	89 cb                	mov    %ecx,%ebx
  80162b:	89 cf                	mov    %ecx,%edi
  80162d:	89 ce                	mov    %ecx,%esi
  80162f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801631:	85 c0                	test   %eax,%eax
  801633:	7e 28                	jle    80165d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  801635:	89 44 24 10          	mov    %eax,0x10(%esp)
  801639:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801640:	00 
  801641:	c7 44 24 08 7f 39 80 	movl   $0x80397f,0x8(%esp)
  801648:	00 
  801649:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801650:	00 
  801651:	c7 04 24 9c 39 80 00 	movl   $0x80399c,(%esp)
  801658:	e8 ef ef ff ff       	call   80064c <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80165d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801660:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801663:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801666:	89 ec                	mov    %ebp,%esp
  801668:	5d                   	pop    %ebp
  801669:	c3                   	ret    
	...

0080166c <sfork>:
}

// Challenge!
int
sfork(void)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 18             	sub    $0x18,%esp
	panic("sfork not implemented");
  801672:	c7 44 24 08 aa 39 80 	movl   $0x8039aa,0x8(%esp)
  801679:	00 
  80167a:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  801681:	00 
  801682:	c7 04 24 c0 39 80 00 	movl   $0x8039c0,(%esp)
  801689:	e8 be ef ff ff       	call   80064c <_panic>

0080168e <duppage>:
// It is also OK to panic on error.
// 

static int
duppage(envid_t envid, unsigned pn)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	83 ec 28             	sub    $0x28,%esp
  801694:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801697:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80169a:	89 c3                	mov    %eax,%ebx
	int r;

	// LAB 4: Your code here.
     pde_t pgDirEntry = vpd[PDX(pn*PGSIZE)];
  80169c:	89 d6                	mov    %edx,%esi
  80169e:	c1 e6 0c             	shl    $0xc,%esi
  8016a1:	89 f0                	mov    %esi,%eax
  8016a3:	c1 e8 16             	shr    $0x16,%eax
  8016a6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
       
        if( 0 == pgDirEntry )
  8016ad:	85 c0                	test   %eax,%eax
  8016af:	0f 84 fc 00 00 00    	je     8017b1 <duppage+0x123>
                return -1;
     
       int perm = vpt[pn] & 0xFFF;
  8016b5:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8016bc:	89 c2                	mov    %eax,%edx
  8016be:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
        //cprintf("Below %d",vpt[pn]);
                //if(perm!=0)  //commented nw.
                   // cprintf("perm bit %d",perm);
	
	
	if((perm & PTE_W) && (perm & PTE_SHARE))
  8016c4:	25 02 04 00 00       	and    $0x402,%eax
  8016c9:	3d 02 04 00 00       	cmp    $0x402,%eax
  8016ce:	75 4d                	jne    80171d <duppage+0x8f>
	{	
		if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_SHARE|(perm & PTE_USER))) < 0)
  8016d0:	81 e2 07 0a 00 00    	and    $0xa07,%edx
  8016d6:	80 ce 04             	or     $0x4,%dh
  8016d9:	89 54 24 10          	mov    %edx,0x10(%esp)
  8016dd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8016e1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016e5:	89 74 24 04          	mov    %esi,0x4(%esp)
  8016e9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8016f0:	e8 f3 fd ff ff       	call   8014e8 <sys_page_map>
  8016f5:	85 c0                	test   %eax,%eax
  8016f7:	0f 89 bb 00 00 00    	jns    8017b8 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  8016fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801701:	c7 44 24 08 38 35 80 	movl   $0x803538,0x8(%esp)
  801708:	00 
  801709:	c7 44 24 04 5c 00 00 	movl   $0x5c,0x4(%esp)
  801710:	00 
  801711:	c7 04 24 c0 39 80 00 	movl   $0x8039c0,(%esp)
  801718:	e8 2f ef ff ff       	call   80064c <_panic>
	}	


        else if((perm & PTE_W)!=0 || (perm & PTE_COW)!=0)
  80171d:	f7 c2 02 08 00 00    	test   $0x802,%edx
  801723:	0f 84 8f 00 00 00    	je     8017b8 <duppage+0x12a>
         {
          //cprintf("\nInside Setting Cow\n"); 
        if ((r = sys_page_map(0,(void *)(pn*PGSIZE),envid,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  801729:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801730:	00 
  801731:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801735:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801739:	89 74 24 04          	mov    %esi,0x4(%esp)
  80173d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801744:	e8 9f fd ff ff       	call   8014e8 <sys_page_map>
  801749:	85 c0                	test   %eax,%eax
  80174b:	79 20                	jns    80176d <duppage+0xdf>
                panic("sys_page_map: %e", r);
  80174d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801751:	c7 44 24 08 38 35 80 	movl   $0x803538,0x8(%esp)
  801758:	00 
  801759:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  801760:	00 
  801761:	c7 04 24 c0 39 80 00 	movl   $0x8039c0,(%esp)
  801768:	e8 df ee ff ff       	call   80064c <_panic>
        if ((r = sys_page_map(envid,(void *)(pn*PGSIZE),0,(void *)(pn*PGSIZE),PTE_P|PTE_U|PTE_COW)) < 0)
  80176d:	c7 44 24 10 05 08 00 	movl   $0x805,0x10(%esp)
  801774:	00 
  801775:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801779:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801780:	00 
  801781:	89 74 24 04          	mov    %esi,0x4(%esp)
  801785:	89 1c 24             	mov    %ebx,(%esp)
  801788:	e8 5b fd ff ff       	call   8014e8 <sys_page_map>
  80178d:	85 c0                	test   %eax,%eax
  80178f:	79 27                	jns    8017b8 <duppage+0x12a>
                panic("sys_page_map: %e", r);
  801791:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801795:	c7 44 24 08 38 35 80 	movl   $0x803538,0x8(%esp)
  80179c:	00 
  80179d:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8017a4:	00 
  8017a5:	c7 04 24 c0 39 80 00 	movl   $0x8039c0,(%esp)
  8017ac:	e8 9b ee ff ff       	call   80064c <_panic>
  8017b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8017b6:	eb 05                	jmp    8017bd <duppage+0x12f>
  8017b8:	b8 00 00 00 00       	mov    $0x0,%eax
         }


//	panic("duppage not implemented");
	return 0;
}
  8017bd:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8017c0:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8017c3:	89 ec                	mov    %ebp,%esp
  8017c5:	5d                   	pop    %ebp
  8017c6:	c3                   	ret    

008017c7 <fork>:
//


envid_t
fork(void)
{
  8017c7:	55                   	push   %ebp
  8017c8:	89 e5                	mov    %esp,%ebp
  8017ca:	56                   	push   %esi
  8017cb:	53                   	push   %ebx
  8017cc:	83 ec 10             	sub    $0x10,%esp

        envid_t envid;
        uint8_t *addr;
        int r;
        extern unsigned char end[];
        set_pgfault_handler(pgfault);
  8017cf:	c7 04 24 de 18 80 00 	movl   $0x8018de,(%esp)
  8017d6:	e8 91 16 00 00       	call   802e6c <set_pgfault_handler>
static __inline envid_t sys_exofork(void) __attribute__((always_inline));
static __inline envid_t
sys_exofork(void)
{
	envid_t ret;
	__asm __volatile("int %2"
  8017db:	be 07 00 00 00       	mov    $0x7,%esi
  8017e0:	89 f0                	mov    %esi,%eax
  8017e2:	cd 30                	int    $0x30
  8017e4:	89 c6                	mov    %eax,%esi

        envid = sys_exofork();
        if (envid < 0)
  8017e6:	85 c0                	test   %eax,%eax
  8017e8:	79 20                	jns    80180a <fork+0x43>
                panic("sys_exofork: %e", envid);
  8017ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8017ee:	c7 44 24 08 cb 39 80 	movl   $0x8039cb,0x8(%esp)
  8017f5:	00 
  8017f6:	c7 44 24 04 8f 00 00 	movl   $0x8f,0x4(%esp)
  8017fd:	00 
  8017fe:	c7 04 24 c0 39 80 00 	movl   $0x8039c0,(%esp)
  801805:	e8 42 ee ff ff       	call   80064c <_panic>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
  80180a:	bb 00 00 80 00       	mov    $0x800000,%ebx
        set_pgfault_handler(pgfault);

        envid = sys_exofork();
        if (envid < 0)
                panic("sys_exofork: %e", envid);
        if (envid == 0) {
  80180f:	85 c0                	test   %eax,%eax
  801811:	75 1c                	jne    80182f <fork+0x68>
                // We're the child.
                // The copied value of the global variable 'env'
                // is no longer valid (it refers to the parent!).
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
  801813:	e8 c1 fd ff ff       	call   8015d9 <sys_getenvid>
  801818:	25 ff 03 00 00       	and    $0x3ff,%eax
  80181d:	6b c0 7c             	imul   $0x7c,%eax,%eax
  801820:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  801825:	a3 90 70 80 00       	mov    %eax,0x807090
                return 0;
  80182a:	e9 a6 00 00 00       	jmp    8018d5 <fork+0x10e>
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
  80182f:	89 da                	mov    %ebx,%edx
  801831:	c1 ea 0c             	shr    $0xc,%edx
  801834:	89 f0                	mov    %esi,%eax
  801836:	e8 53 fe ff ff       	call   80168e <duppage>
                // Fix it and return 0.
                env = &envs[ENVX(sys_getenvid())];
                return 0;
        }
	//cprintf("\nEnd------------>%x\n",end);
       for (addr = (uint8_t*) UTEXT; addr < (uint8_t*)(USTACKTOP-PGSIZE); addr += PGSIZE)
  80183b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801841:	81 fb 00 d0 bf ee    	cmp    $0xeebfd000,%ebx
  801847:	75 e6                	jne    80182f <fork+0x68>
                {  //  cprintf("\nADDress %x ROUND %x\n",addr,ROUNDDOWN(addr,PGSIZE));
			//cprintf("\nAddr------------>%x\n",addr);                     
			duppage(envid, VPN(addr));
                }
              duppage(envid,VPN(USTACKTOP-PGSIZE));
  801849:	ba fd eb 0e 00       	mov    $0xeebfd,%edx
  80184e:	89 f0                	mov    %esi,%eax
  801850:	e8 39 fe ff ff       	call   80168e <duppage>
        // Also copy the stack we are currently running on.
       //if(sys_page_alloc(envid, (void *)(ROUNDDOWN(&addr, PGSIZE)),PTE_U|PTE_P|PTE_W)<0)
         //                      panic("stack not allocated");
     
   
     sys_env_set_pgfault_upcall(envid,env->env_pgfault_upcall);
  801855:	a1 90 70 80 00       	mov    0x807090,%eax
  80185a:	8b 40 64             	mov    0x64(%eax),%eax
  80185d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801861:	89 34 24             	mov    %esi,(%esp)
  801864:	e8 07 fb ff ff       	call   801370 <sys_env_set_pgfault_upcall>

     if(sys_page_alloc(envid,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  801869:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801870:	00 
  801871:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  801878:	ee 
  801879:	89 34 24             	mov    %esi,(%esp)
  80187c:	e8 c5 fc ff ff       	call   801546 <sys_page_alloc>
  801881:	85 c0                	test   %eax,%eax
  801883:	79 1c                	jns    8018a1 <fork+0xda>
                          panic("Cant allocate Page");
  801885:	c7 44 24 08 db 39 80 	movl   $0x8039db,0x8(%esp)
  80188c:	00 
  80188d:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  801894:	00 
  801895:	c7 04 24 c0 39 80 00 	movl   $0x8039c0,(%esp)
  80189c:	e8 ab ed ff ff       	call   80064c <_panic>

        // Start the child environment running
        if ((r = sys_env_set_status(envid, ENV_RUNNABLE)) < 0)
  8018a1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8018a8:	00 
  8018a9:	89 34 24             	mov    %esi,(%esp)
  8018ac:	e8 7b fb ff ff       	call   80142c <sys_env_set_status>
  8018b1:	85 c0                	test   %eax,%eax
  8018b3:	79 20                	jns    8018d5 <fork+0x10e>
                panic("sys_env_set_status: %e", r);
  8018b5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8018b9:	c7 44 24 08 ee 39 80 	movl   $0x8039ee,0x8(%esp)
  8018c0:	00 
  8018c1:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
  8018c8:	00 
  8018c9:	c7 04 24 c0 39 80 00 	movl   $0x8039c0,(%esp)
  8018d0:	e8 77 ed ff ff       	call   80064c <_panic>
         return envid;
           
//panic("fork not implemented");
}
  8018d5:	89 f0                	mov    %esi,%eax
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	5b                   	pop    %ebx
  8018db:	5e                   	pop    %esi
  8018dc:	5d                   	pop    %ebp
  8018dd:	c3                   	ret    

008018de <pgfault>:
// map in our own private writable copy.
//

static void
pgfault(struct UTrapframe *utf)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	53                   	push   %ebx
  8018e2:	83 ec 24             	sub    $0x24,%esp
  8018e5:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  8018e8:	8b 18                	mov    (%eax),%ebx
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at vpt
	//   (see <inc/memlayout.h>).
 
         int perm = vpt[VPN(addr)] & 0xFFF;
  8018ea:	89 da                	mov    %ebx,%edx
  8018ec:	c1 ea 0c             	shr    $0xc,%edx
  8018ef:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx

static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
  8018f6:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  8018fa:	74 21                	je     80191d <pgfault+0x3f>
 
         int perm = vpt[VPN(addr)] & 0xFFF;
        if((err & FEC_WR)!=0)
           {
//              cprintf("\n>>>>>Due to write\n");
            if((perm & PTE_COW) == 0)
  8018fc:	f6 c6 08             	test   $0x8,%dh
  8018ff:	75 1c                	jne    80191d <pgfault+0x3f>
             {
                   panic("Not Set Cow");
  801901:	c7 44 24 08 05 3a 80 	movl   $0x803a05,0x8(%esp)
  801908:	00 
  801909:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  801910:	00 
  801911:	c7 04 24 c0 39 80 00 	movl   $0x8039c0,(%esp)
  801918:	e8 2f ed ff ff       	call   80064c <_panic>
	// Hint:
	//   You should make three system calls.
	//   No need to explicitly delete the old page's mapping.

	// LAB 4: Your code here.
        if(sys_page_alloc(0,PFTEMP,PTE_P|PTE_U|PTE_W)<0)
  80191d:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801924:	00 
  801925:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  80192c:	00 
  80192d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801934:	e8 0d fc ff ff       	call   801546 <sys_page_alloc>
  801939:	85 c0                	test   %eax,%eax
  80193b:	79 1c                	jns    801959 <pgfault+0x7b>
              panic("\nPage not allocated\n");
  80193d:	c7 44 24 08 11 3a 80 	movl   $0x803a11,0x8(%esp)
  801944:	00 
  801945:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  80194c:	00 
  80194d:	c7 04 24 c0 39 80 00 	movl   $0x8039c0,(%esp)
  801954:	e8 f3 ec ff ff       	call   80064c <_panic>
           memmove(PFTEMP,ROUNDDOWN(addr,PGSIZE),PGSIZE);
  801959:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  80195f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801966:	00 
  801967:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80196b:	c7 04 24 00 f0 7f 00 	movl   $0x7ff000,(%esp)
  801972:	e8 2e f6 ff ff       	call   800fa5 <memmove>
          if(sys_page_map(0,ROUNDDOWN(PFTEMP,PGSIZE),0,ROUNDDOWN(addr,PGSIZE),PTE_U|PTE_P|PTE_W)<0)
  801977:	c7 44 24 10 07 00 00 	movl   $0x7,0x10(%esp)
  80197e:	00 
  80197f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801983:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80198a:	00 
  80198b:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  801992:	00 
  801993:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80199a:	e8 49 fb ff ff       	call   8014e8 <sys_page_map>
  80199f:	85 c0                	test   %eax,%eax
  8019a1:	79 1c                	jns    8019bf <pgfault+0xe1>
                   panic("not mapped properly");
  8019a3:	c7 44 24 08 26 3a 80 	movl   $0x803a26,0x8(%esp)
  8019aa:	00 
  8019ab:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
  8019b2:	00 
  8019b3:	c7 04 24 c0 39 80 00 	movl   $0x8039c0,(%esp)
  8019ba:	e8 8d ec ff ff       	call   80064c <_panic>
         if( 0 > sys_page_unmap(0, PFTEMP) )
  8019bf:	c7 44 24 04 00 f0 7f 	movl   $0x7ff000,0x4(%esp)
  8019c6:	00 
  8019c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019ce:	e8 b7 fa ff ff       	call   80148a <sys_page_unmap>
  8019d3:	85 c0                	test   %eax,%eax
  8019d5:	79 1c                	jns    8019f3 <pgfault+0x115>
                panic("sys_page_unmap failed\n");
  8019d7:	c7 44 24 08 3a 3a 80 	movl   $0x803a3a,0x8(%esp)
  8019de:	00 
  8019df:	c7 44 24 04 35 00 00 	movl   $0x35,0x4(%esp)
  8019e6:	00 
  8019e7:	c7 04 24 c0 39 80 00 	movl   $0x8039c0,(%esp)
  8019ee:	e8 59 ec ff ff       	call   80064c <_panic>
   
//	panic("pgfault not implemented");
}
  8019f3:	83 c4 24             	add    $0x24,%esp
  8019f6:	5b                   	pop    %ebx
  8019f7:	5d                   	pop    %ebp
  8019f8:	c3                   	ret    
  8019f9:	00 00                	add    %al,(%eax)
  8019fb:	00 00                	add    %al,(%eax)
  8019fd:	00 00                	add    %al,(%eax)
	...

00801a00 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	57                   	push   %edi
  801a04:	56                   	push   %esi
  801a05:	53                   	push   %ebx
  801a06:	83 ec 1c             	sub    $0x1c,%esp
  801a09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801a0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  801a0f:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  801a12:	8b 45 14             	mov    0x14(%ebp),%eax
  801a15:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801a19:	89 7c 24 08          	mov    %edi,0x8(%esp)
  801a1d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a21:	89 1c 24             	mov    %ebx,(%esp)
  801a24:	e8 0f f9 ff ff       	call   801338 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  801a29:	85 c0                	test   %eax,%eax
  801a2b:	79 21                	jns    801a4e <ipc_send+0x4e>
  801a2d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801a30:	74 1c                	je     801a4e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  801a32:	c7 44 24 08 51 3a 80 	movl   $0x803a51,0x8(%esp)
  801a39:	00 
  801a3a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  801a41:	00 
  801a42:	c7 04 24 63 3a 80 00 	movl   $0x803a63,(%esp)
  801a49:	e8 fe eb ff ff       	call   80064c <_panic>
          else if(r==-E_IPC_NOT_RECV)
  801a4e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801a51:	75 07                	jne    801a5a <ipc_send+0x5a>
           sys_yield();
  801a53:	e8 4d fb ff ff       	call   8015a5 <sys_yield>
          else
            break;
        }
  801a58:	eb b8                	jmp    801a12 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  801a5a:	83 c4 1c             	add    $0x1c,%esp
  801a5d:	5b                   	pop    %ebx
  801a5e:	5e                   	pop    %esi
  801a5f:	5f                   	pop    %edi
  801a60:	5d                   	pop    %ebp
  801a61:	c3                   	ret    

00801a62 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	83 ec 18             	sub    $0x18,%esp
  801a68:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801a6b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801a6e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801a71:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  801a74:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a77:	89 04 24             	mov    %eax,(%esp)
  801a7a:	e8 5c f8 ff ff       	call   8012db <sys_ipc_recv>
        if(r<0)
  801a7f:	85 c0                	test   %eax,%eax
  801a81:	79 17                	jns    801a9a <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  801a83:	85 db                	test   %ebx,%ebx
  801a85:	74 06                	je     801a8d <ipc_recv+0x2b>
               *from_env_store =0;
  801a87:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  801a8d:	85 f6                	test   %esi,%esi
  801a8f:	90                   	nop
  801a90:	74 2c                	je     801abe <ipc_recv+0x5c>
              *perm_store=0;
  801a92:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  801a98:	eb 24                	jmp    801abe <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  801a9a:	85 db                	test   %ebx,%ebx
  801a9c:	74 0a                	je     801aa8 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  801a9e:	a1 90 70 80 00       	mov    0x807090,%eax
  801aa3:	8b 40 74             	mov    0x74(%eax),%eax
  801aa6:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  801aa8:	85 f6                	test   %esi,%esi
  801aaa:	74 0a                	je     801ab6 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  801aac:	a1 90 70 80 00       	mov    0x807090,%eax
  801ab1:	8b 40 78             	mov    0x78(%eax),%eax
  801ab4:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  801ab6:	a1 90 70 80 00       	mov    0x807090,%eax
  801abb:	8b 40 70             	mov    0x70(%eax),%eax
}
  801abe:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801ac1:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801ac4:	89 ec                	mov    %ebp,%esp
  801ac6:	5d                   	pop    %ebp
  801ac7:	c3                   	ret    
	...

00801ad0 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad6:	05 00 00 00 30       	add    $0x30000000,%eax
  801adb:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  801ade:	5d                   	pop    %ebp
  801adf:	c3                   	ret    

00801ae0 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	89 04 24             	mov    %eax,(%esp)
  801aec:	e8 df ff ff ff       	call   801ad0 <fd2num>
  801af1:	05 20 00 0d 00       	add    $0xd0020,%eax
  801af6:	c1 e0 0c             	shl    $0xc,%eax
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	57                   	push   %edi
  801aff:	56                   	push   %esi
  801b00:	53                   	push   %ebx
  801b01:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801b04:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801b09:	a8 01                	test   $0x1,%al
  801b0b:	74 36                	je     801b43 <fd_alloc+0x48>
  801b0d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801b12:	a8 01                	test   $0x1,%al
  801b14:	74 2d                	je     801b43 <fd_alloc+0x48>
  801b16:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  801b1b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801b20:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801b25:	89 c3                	mov    %eax,%ebx
  801b27:	89 c2                	mov    %eax,%edx
  801b29:	c1 ea 16             	shr    $0x16,%edx
  801b2c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  801b2f:	f6 c2 01             	test   $0x1,%dl
  801b32:	74 14                	je     801b48 <fd_alloc+0x4d>
  801b34:	89 c2                	mov    %eax,%edx
  801b36:	c1 ea 0c             	shr    $0xc,%edx
  801b39:	8b 14 96             	mov    (%esi,%edx,4),%edx
  801b3c:	f6 c2 01             	test   $0x1,%dl
  801b3f:	75 10                	jne    801b51 <fd_alloc+0x56>
  801b41:	eb 05                	jmp    801b48 <fd_alloc+0x4d>
  801b43:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  801b48:	89 1f                	mov    %ebx,(%edi)
  801b4a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801b4f:	eb 17                	jmp    801b68 <fd_alloc+0x6d>
  801b51:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  801b56:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801b5b:	75 c8                	jne    801b25 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801b5d:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  801b63:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  801b68:	5b                   	pop    %ebx
  801b69:	5e                   	pop    %esi
  801b6a:	5f                   	pop    %edi
  801b6b:	5d                   	pop    %ebp
  801b6c:	c3                   	ret    

00801b6d <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801b70:	8b 45 08             	mov    0x8(%ebp),%eax
  801b73:	83 f8 1f             	cmp    $0x1f,%eax
  801b76:	77 36                	ja     801bae <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801b78:	05 00 00 0d 00       	add    $0xd0000,%eax
  801b7d:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  801b80:	89 c2                	mov    %eax,%edx
  801b82:	c1 ea 16             	shr    $0x16,%edx
  801b85:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801b8c:	f6 c2 01             	test   $0x1,%dl
  801b8f:	74 1d                	je     801bae <fd_lookup+0x41>
  801b91:	89 c2                	mov    %eax,%edx
  801b93:	c1 ea 0c             	shr    $0xc,%edx
  801b96:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801b9d:	f6 c2 01             	test   $0x1,%dl
  801ba0:	74 0c                	je     801bae <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801ba2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba5:	89 02                	mov    %eax,(%edx)
  801ba7:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  801bac:	eb 05                	jmp    801bb3 <fd_lookup+0x46>
  801bae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801bb3:	5d                   	pop    %ebp
  801bb4:	c3                   	ret    

00801bb5 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801bb5:	55                   	push   %ebp
  801bb6:	89 e5                	mov    %esp,%ebp
  801bb8:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bbb:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801bbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc5:	89 04 24             	mov    %eax,(%esp)
  801bc8:	e8 a0 ff ff ff       	call   801b6d <fd_lookup>
  801bcd:	85 c0                	test   %eax,%eax
  801bcf:	78 0e                	js     801bdf <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801bd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801bd4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd7:	89 50 04             	mov    %edx,0x4(%eax)
  801bda:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801bdf:	c9                   	leave  
  801be0:	c3                   	ret    

00801be1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801be1:	55                   	push   %ebp
  801be2:	89 e5                	mov    %esp,%ebp
  801be4:	56                   	push   %esi
  801be5:	53                   	push   %ebx
  801be6:	83 ec 10             	sub    $0x10,%esp
  801be9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  801bef:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801bf4:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801bf9:	be f0 3a 80 00       	mov    $0x803af0,%esi
		if (devtab[i]->dev_id == dev_id) {
  801bfe:	39 08                	cmp    %ecx,(%eax)
  801c00:	75 10                	jne    801c12 <dev_lookup+0x31>
  801c02:	eb 04                	jmp    801c08 <dev_lookup+0x27>
  801c04:	39 08                	cmp    %ecx,(%eax)
  801c06:	75 0a                	jne    801c12 <dev_lookup+0x31>
			*dev = devtab[i];
  801c08:	89 03                	mov    %eax,(%ebx)
  801c0a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  801c0f:	90                   	nop
  801c10:	eb 31                	jmp    801c43 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801c12:	83 c2 01             	add    $0x1,%edx
  801c15:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	75 e8                	jne    801c04 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  801c1c:	a1 90 70 80 00       	mov    0x807090,%eax
  801c21:	8b 40 4c             	mov    0x4c(%eax),%eax
  801c24:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c28:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c2c:	c7 04 24 70 3a 80 00 	movl   $0x803a70,(%esp)
  801c33:	e8 d9 ea ff ff       	call   800711 <cprintf>
	*dev = 0;
  801c38:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801c3e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  801c43:	83 c4 10             	add    $0x10,%esp
  801c46:	5b                   	pop    %ebx
  801c47:	5e                   	pop    %esi
  801c48:	5d                   	pop    %ebp
  801c49:	c3                   	ret    

00801c4a <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	53                   	push   %ebx
  801c4e:	83 ec 24             	sub    $0x24,%esp
  801c51:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c54:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c57:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5e:	89 04 24             	mov    %eax,(%esp)
  801c61:	e8 07 ff ff ff       	call   801b6d <fd_lookup>
  801c66:	85 c0                	test   %eax,%eax
  801c68:	78 53                	js     801cbd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801c6a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c74:	8b 00                	mov    (%eax),%eax
  801c76:	89 04 24             	mov    %eax,(%esp)
  801c79:	e8 63 ff ff ff       	call   801be1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801c7e:	85 c0                	test   %eax,%eax
  801c80:	78 3b                	js     801cbd <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  801c82:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801c87:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c8a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  801c8e:	74 2d                	je     801cbd <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801c90:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801c93:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801c9a:	00 00 00 
	stat->st_isdir = 0;
  801c9d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801ca4:	00 00 00 
	stat->st_dev = dev;
  801ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801caa:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801cb0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cb4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cb7:	89 14 24             	mov    %edx,(%esp)
  801cba:	ff 50 14             	call   *0x14(%eax)
}
  801cbd:	83 c4 24             	add    $0x24,%esp
  801cc0:	5b                   	pop    %ebx
  801cc1:	5d                   	pop    %ebp
  801cc2:	c3                   	ret    

00801cc3 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	53                   	push   %ebx
  801cc7:	83 ec 24             	sub    $0x24,%esp
  801cca:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801ccd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd4:	89 1c 24             	mov    %ebx,(%esp)
  801cd7:	e8 91 fe ff ff       	call   801b6d <fd_lookup>
  801cdc:	85 c0                	test   %eax,%eax
  801cde:	78 5f                	js     801d3f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801ce0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ce3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cea:	8b 00                	mov    (%eax),%eax
  801cec:	89 04 24             	mov    %eax,(%esp)
  801cef:	e8 ed fe ff ff       	call   801be1 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801cf4:	85 c0                	test   %eax,%eax
  801cf6:	78 47                	js     801d3f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801cf8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801cfb:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801cff:	75 23                	jne    801d24 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801d01:	a1 90 70 80 00       	mov    0x807090,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801d06:	8b 40 4c             	mov    0x4c(%eax),%eax
  801d09:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d11:	c7 04 24 90 3a 80 00 	movl   $0x803a90,(%esp)
  801d18:	e8 f4 e9 ff ff       	call   800711 <cprintf>
  801d1d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801d22:	eb 1b                	jmp    801d3f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801d24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d27:	8b 48 18             	mov    0x18(%eax),%ecx
  801d2a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801d2f:	85 c9                	test   %ecx,%ecx
  801d31:	74 0c                	je     801d3f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801d33:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d36:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d3a:	89 14 24             	mov    %edx,(%esp)
  801d3d:	ff d1                	call   *%ecx
}
  801d3f:	83 c4 24             	add    $0x24,%esp
  801d42:	5b                   	pop    %ebx
  801d43:	5d                   	pop    %ebp
  801d44:	c3                   	ret    

00801d45 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801d45:	55                   	push   %ebp
  801d46:	89 e5                	mov    %esp,%ebp
  801d48:	53                   	push   %ebx
  801d49:	83 ec 24             	sub    $0x24,%esp
  801d4c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d4f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801d52:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d56:	89 1c 24             	mov    %ebx,(%esp)
  801d59:	e8 0f fe ff ff       	call   801b6d <fd_lookup>
  801d5e:	85 c0                	test   %eax,%eax
  801d60:	78 66                	js     801dc8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801d62:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d65:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d6c:	8b 00                	mov    (%eax),%eax
  801d6e:	89 04 24             	mov    %eax,(%esp)
  801d71:	e8 6b fe ff ff       	call   801be1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801d76:	85 c0                	test   %eax,%eax
  801d78:	78 4e                	js     801dc8 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801d7a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801d7d:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  801d81:	75 23                	jne    801da6 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  801d83:	a1 90 70 80 00       	mov    0x807090,%eax
  801d88:	8b 40 4c             	mov    0x4c(%eax),%eax
  801d8b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d93:	c7 04 24 b4 3a 80 00 	movl   $0x803ab4,(%esp)
  801d9a:	e8 72 e9 ff ff       	call   800711 <cprintf>
  801d9f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801da4:	eb 22                	jmp    801dc8 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da9:	8b 48 0c             	mov    0xc(%eax),%ecx
  801dac:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801db1:	85 c9                	test   %ecx,%ecx
  801db3:	74 13                	je     801dc8 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801db5:	8b 45 10             	mov    0x10(%ebp),%eax
  801db8:	89 44 24 08          	mov    %eax,0x8(%esp)
  801dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dc3:	89 14 24             	mov    %edx,(%esp)
  801dc6:	ff d1                	call   *%ecx
}
  801dc8:	83 c4 24             	add    $0x24,%esp
  801dcb:	5b                   	pop    %ebx
  801dcc:	5d                   	pop    %ebp
  801dcd:	c3                   	ret    

00801dce <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	53                   	push   %ebx
  801dd2:	83 ec 24             	sub    $0x24,%esp
  801dd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801dd8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ddb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ddf:	89 1c 24             	mov    %ebx,(%esp)
  801de2:	e8 86 fd ff ff       	call   801b6d <fd_lookup>
  801de7:	85 c0                	test   %eax,%eax
  801de9:	78 6b                	js     801e56 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801deb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dee:	89 44 24 04          	mov    %eax,0x4(%esp)
  801df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df5:	8b 00                	mov    (%eax),%eax
  801df7:	89 04 24             	mov    %eax,(%esp)
  801dfa:	e8 e2 fd ff ff       	call   801be1 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801dff:	85 c0                	test   %eax,%eax
  801e01:	78 53                	js     801e56 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801e03:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e06:	8b 42 08             	mov    0x8(%edx),%eax
  801e09:	83 e0 03             	and    $0x3,%eax
  801e0c:	83 f8 01             	cmp    $0x1,%eax
  801e0f:	75 23                	jne    801e34 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801e11:	a1 90 70 80 00       	mov    0x807090,%eax
  801e16:	8b 40 4c             	mov    0x4c(%eax),%eax
  801e19:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e21:	c7 04 24 d1 3a 80 00 	movl   $0x803ad1,(%esp)
  801e28:	e8 e4 e8 ff ff       	call   800711 <cprintf>
  801e2d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801e32:	eb 22                	jmp    801e56 <read+0x88>
	}
	if (!dev->dev_read)
  801e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e37:	8b 48 08             	mov    0x8(%eax),%ecx
  801e3a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801e3f:	85 c9                	test   %ecx,%ecx
  801e41:	74 13                	je     801e56 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801e43:	8b 45 10             	mov    0x10(%ebp),%eax
  801e46:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e51:	89 14 24             	mov    %edx,(%esp)
  801e54:	ff d1                	call   *%ecx
}
  801e56:	83 c4 24             	add    $0x24,%esp
  801e59:	5b                   	pop    %ebx
  801e5a:	5d                   	pop    %ebp
  801e5b:	c3                   	ret    

00801e5c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	57                   	push   %edi
  801e60:	56                   	push   %esi
  801e61:	53                   	push   %ebx
  801e62:	83 ec 1c             	sub    $0x1c,%esp
  801e65:	8b 7d 08             	mov    0x8(%ebp),%edi
  801e68:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801e6b:	ba 00 00 00 00       	mov    $0x0,%edx
  801e70:	bb 00 00 00 00       	mov    $0x0,%ebx
  801e75:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7a:	85 f6                	test   %esi,%esi
  801e7c:	74 29                	je     801ea7 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801e7e:	89 f0                	mov    %esi,%eax
  801e80:	29 d0                	sub    %edx,%eax
  801e82:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e86:	03 55 0c             	add    0xc(%ebp),%edx
  801e89:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e8d:	89 3c 24             	mov    %edi,(%esp)
  801e90:	e8 39 ff ff ff       	call   801dce <read>
		if (m < 0)
  801e95:	85 c0                	test   %eax,%eax
  801e97:	78 0e                	js     801ea7 <readn+0x4b>
			return m;
		if (m == 0)
  801e99:	85 c0                	test   %eax,%eax
  801e9b:	74 08                	je     801ea5 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801e9d:	01 c3                	add    %eax,%ebx
  801e9f:	89 da                	mov    %ebx,%edx
  801ea1:	39 f3                	cmp    %esi,%ebx
  801ea3:	72 d9                	jb     801e7e <readn+0x22>
  801ea5:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801ea7:	83 c4 1c             	add    $0x1c,%esp
  801eaa:	5b                   	pop    %ebx
  801eab:	5e                   	pop    %esi
  801eac:	5f                   	pop    %edi
  801ead:	5d                   	pop    %ebp
  801eae:	c3                   	ret    

00801eaf <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
  801eb2:	56                   	push   %esi
  801eb3:	53                   	push   %ebx
  801eb4:	83 ec 20             	sub    $0x20,%esp
  801eb7:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801eba:	89 34 24             	mov    %esi,(%esp)
  801ebd:	e8 0e fc ff ff       	call   801ad0 <fd2num>
  801ec2:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801ec5:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ec9:	89 04 24             	mov    %eax,(%esp)
  801ecc:	e8 9c fc ff ff       	call   801b6d <fd_lookup>
  801ed1:	89 c3                	mov    %eax,%ebx
  801ed3:	85 c0                	test   %eax,%eax
  801ed5:	78 05                	js     801edc <fd_close+0x2d>
  801ed7:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  801eda:	74 0c                	je     801ee8 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  801edc:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801ee0:	19 c0                	sbb    %eax,%eax
  801ee2:	f7 d0                	not    %eax
  801ee4:	21 c3                	and    %eax,%ebx
  801ee6:	eb 3d                	jmp    801f25 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801ee8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801eeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801eef:	8b 06                	mov    (%esi),%eax
  801ef1:	89 04 24             	mov    %eax,(%esp)
  801ef4:	e8 e8 fc ff ff       	call   801be1 <dev_lookup>
  801ef9:	89 c3                	mov    %eax,%ebx
  801efb:	85 c0                	test   %eax,%eax
  801efd:	78 16                	js     801f15 <fd_close+0x66>
		if (dev->dev_close)
  801eff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f02:	8b 40 10             	mov    0x10(%eax),%eax
  801f05:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f0a:	85 c0                	test   %eax,%eax
  801f0c:	74 07                	je     801f15 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  801f0e:	89 34 24             	mov    %esi,(%esp)
  801f11:	ff d0                	call   *%eax
  801f13:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801f15:	89 74 24 04          	mov    %esi,0x4(%esp)
  801f19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f20:	e8 65 f5 ff ff       	call   80148a <sys_page_unmap>
	return r;
}
  801f25:	89 d8                	mov    %ebx,%eax
  801f27:	83 c4 20             	add    $0x20,%esp
  801f2a:	5b                   	pop    %ebx
  801f2b:	5e                   	pop    %esi
  801f2c:	5d                   	pop    %ebp
  801f2d:	c3                   	ret    

00801f2e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f34:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f37:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3e:	89 04 24             	mov    %eax,(%esp)
  801f41:	e8 27 fc ff ff       	call   801b6d <fd_lookup>
  801f46:	85 c0                	test   %eax,%eax
  801f48:	78 13                	js     801f5d <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  801f4a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801f51:	00 
  801f52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f55:	89 04 24             	mov    %eax,(%esp)
  801f58:	e8 52 ff ff ff       	call   801eaf <fd_close>
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
  801f62:	83 ec 18             	sub    $0x18,%esp
  801f65:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801f68:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801f6b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801f72:	00 
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	89 04 24             	mov    %eax,(%esp)
  801f79:	e8 a9 03 00 00       	call   802327 <open>
  801f7e:	89 c3                	mov    %eax,%ebx
  801f80:	85 c0                	test   %eax,%eax
  801f82:	78 1b                	js     801f9f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  801f84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f87:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f8b:	89 1c 24             	mov    %ebx,(%esp)
  801f8e:	e8 b7 fc ff ff       	call   801c4a <fstat>
  801f93:	89 c6                	mov    %eax,%esi
	close(fd);
  801f95:	89 1c 24             	mov    %ebx,(%esp)
  801f98:	e8 91 ff ff ff       	call   801f2e <close>
  801f9d:	89 f3                	mov    %esi,%ebx
	return r;
}
  801f9f:	89 d8                	mov    %ebx,%eax
  801fa1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801fa4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801fa7:	89 ec                	mov    %ebp,%esp
  801fa9:	5d                   	pop    %ebp
  801faa:	c3                   	ret    

00801fab <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  801fab:	55                   	push   %ebp
  801fac:	89 e5                	mov    %esp,%ebp
  801fae:	53                   	push   %ebx
  801faf:	83 ec 14             	sub    $0x14,%esp
  801fb2:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801fb7:	89 1c 24             	mov    %ebx,(%esp)
  801fba:	e8 6f ff ff ff       	call   801f2e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  801fbf:	83 c3 01             	add    $0x1,%ebx
  801fc2:	83 fb 20             	cmp    $0x20,%ebx
  801fc5:	75 f0                	jne    801fb7 <close_all+0xc>
		close(i);
}
  801fc7:	83 c4 14             	add    $0x14,%esp
  801fca:	5b                   	pop    %ebx
  801fcb:	5d                   	pop    %ebp
  801fcc:	c3                   	ret    

00801fcd <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	83 ec 58             	sub    $0x58,%esp
  801fd3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801fd6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801fd9:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801fdc:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801fdf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801fe2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fe6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fe9:	89 04 24             	mov    %eax,(%esp)
  801fec:	e8 7c fb ff ff       	call   801b6d <fd_lookup>
  801ff1:	89 c3                	mov    %eax,%ebx
  801ff3:	85 c0                	test   %eax,%eax
  801ff5:	0f 88 e0 00 00 00    	js     8020db <dup+0x10e>
		return r;
	close(newfdnum);
  801ffb:	89 3c 24             	mov    %edi,(%esp)
  801ffe:	e8 2b ff ff ff       	call   801f2e <close>

	newfd = INDEX2FD(newfdnum);
  802003:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  802009:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80200c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80200f:	89 04 24             	mov    %eax,(%esp)
  802012:	e8 c9 fa ff ff       	call   801ae0 <fd2data>
  802017:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802019:	89 34 24             	mov    %esi,(%esp)
  80201c:	e8 bf fa ff ff       	call   801ae0 <fd2data>
  802021:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  802024:	89 da                	mov    %ebx,%edx
  802026:	89 d8                	mov    %ebx,%eax
  802028:	c1 e8 16             	shr    $0x16,%eax
  80202b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802032:	a8 01                	test   $0x1,%al
  802034:	74 43                	je     802079 <dup+0xac>
  802036:	c1 ea 0c             	shr    $0xc,%edx
  802039:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  802040:	a8 01                	test   $0x1,%al
  802042:	74 35                	je     802079 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  802044:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  80204b:	25 07 0e 00 00       	and    $0xe07,%eax
  802050:	89 44 24 10          	mov    %eax,0x10(%esp)
  802054:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  802057:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80205b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802062:	00 
  802063:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802067:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80206e:	e8 75 f4 ff ff       	call   8014e8 <sys_page_map>
  802073:	89 c3                	mov    %eax,%ebx
  802075:	85 c0                	test   %eax,%eax
  802077:	78 3f                	js     8020b8 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  802079:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80207c:	89 c2                	mov    %eax,%edx
  80207e:	c1 ea 0c             	shr    $0xc,%edx
  802081:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802088:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80208e:	89 54 24 10          	mov    %edx,0x10(%esp)
  802092:	89 74 24 0c          	mov    %esi,0xc(%esp)
  802096:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80209d:	00 
  80209e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020a2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020a9:	e8 3a f4 ff ff       	call   8014e8 <sys_page_map>
  8020ae:	89 c3                	mov    %eax,%ebx
  8020b0:	85 c0                	test   %eax,%eax
  8020b2:	78 04                	js     8020b8 <dup+0xeb>
  8020b4:	89 fb                	mov    %edi,%ebx
  8020b6:	eb 23                	jmp    8020db <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  8020b8:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020c3:	e8 c2 f3 ff ff       	call   80148a <sys_page_unmap>
	sys_page_unmap(0, nva);
  8020c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8020cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020cf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020d6:	e8 af f3 ff ff       	call   80148a <sys_page_unmap>
	return r;
}
  8020db:	89 d8                	mov    %ebx,%eax
  8020dd:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8020e0:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8020e3:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8020e6:	89 ec                	mov    %ebp,%esp
  8020e8:	5d                   	pop    %ebp
  8020e9:	c3                   	ret    
	...

008020ec <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	53                   	push   %ebx
  8020f0:	83 ec 14             	sub    $0x14,%esp
  8020f3:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8020f5:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  8020fb:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802102:	00 
  802103:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  80210a:	00 
  80210b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80210f:	89 14 24             	mov    %edx,(%esp)
  802112:	e8 e9 f8 ff ff       	call   801a00 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802117:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80211e:	00 
  80211f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802123:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80212a:	e8 33 f9 ff ff       	call   801a62 <ipc_recv>
}
  80212f:	83 c4 14             	add    $0x14,%esp
  802132:	5b                   	pop    %ebx
  802133:	5d                   	pop    %ebp
  802134:	c3                   	ret    

00802135 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802135:	55                   	push   %ebp
  802136:	89 e5                	mov    %esp,%ebp
  802138:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	8b 40 0c             	mov    0xc(%eax),%eax
  802141:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  802146:	8b 45 0c             	mov    0xc(%ebp),%eax
  802149:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80214e:	ba 00 00 00 00       	mov    $0x0,%edx
  802153:	b8 02 00 00 00       	mov    $0x2,%eax
  802158:	e8 8f ff ff ff       	call   8020ec <fsipc>
}
  80215d:	c9                   	leave  
  80215e:	c3                   	ret    

0080215f <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  80215f:	55                   	push   %ebp
  802160:	89 e5                	mov    %esp,%ebp
  802162:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802165:	ba 00 00 00 00       	mov    $0x0,%edx
  80216a:	b8 08 00 00 00       	mov    $0x8,%eax
  80216f:	e8 78 ff ff ff       	call   8020ec <fsipc>
}
  802174:	c9                   	leave  
  802175:	c3                   	ret    

00802176 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  802176:	55                   	push   %ebp
  802177:	89 e5                	mov    %esp,%ebp
  802179:	53                   	push   %ebx
  80217a:	83 ec 14             	sub    $0x14,%esp
  80217d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802180:	8b 45 08             	mov    0x8(%ebp),%eax
  802183:	8b 40 0c             	mov    0xc(%eax),%eax
  802186:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80218b:	ba 00 00 00 00       	mov    $0x0,%edx
  802190:	b8 05 00 00 00       	mov    $0x5,%eax
  802195:	e8 52 ff ff ff       	call   8020ec <fsipc>
  80219a:	85 c0                	test   %eax,%eax
  80219c:	78 2b                	js     8021c9 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80219e:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  8021a5:	00 
  8021a6:	89 1c 24             	mov    %ebx,(%esp)
  8021a9:	e8 3c ec ff ff       	call   800dea <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8021ae:	a1 80 40 80 00       	mov    0x804080,%eax
  8021b3:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  8021b9:	a1 84 40 80 00       	mov    0x804084,%eax
  8021be:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  8021c4:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  8021c9:	83 c4 14             	add    $0x14,%esp
  8021cc:	5b                   	pop    %ebx
  8021cd:	5d                   	pop    %ebp
  8021ce:	c3                   	ret    

008021cf <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  8021cf:	55                   	push   %ebp
  8021d0:	89 e5                	mov    %esp,%ebp
  8021d2:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  8021d5:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8021dc:	00 
  8021dd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8021e4:	00 
  8021e5:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  8021ec:	e8 55 ed ff ff       	call   800f46 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8021f7:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  8021fc:	ba 00 00 00 00       	mov    $0x0,%edx
  802201:	b8 06 00 00 00       	mov    $0x6,%eax
  802206:	e8 e1 fe ff ff       	call   8020ec <fsipc>
}
  80220b:	c9                   	leave  
  80220c:	c3                   	ret    

0080220d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80220d:	55                   	push   %ebp
  80220e:	89 e5                	mov    %esp,%ebp
  802210:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  802213:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80221a:	00 
  80221b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802222:	00 
  802223:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  80222a:	e8 17 ed ff ff       	call   800f46 <memset>
  80222f:	8b 45 10             	mov    0x10(%ebp),%eax
  802232:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  802237:	76 05                	jbe    80223e <devfile_write+0x31>
  802239:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  80223e:	8b 55 08             	mov    0x8(%ebp),%edx
  802241:	8b 52 0c             	mov    0xc(%edx),%edx
  802244:	89 15 00 40 80 00    	mov    %edx,0x804000
        fsipcbuf.write.req_n = numberOfBytes;
  80224a:	a3 04 40 80 00       	mov    %eax,0x804004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  80224f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802253:	8b 45 0c             	mov    0xc(%ebp),%eax
  802256:	89 44 24 04          	mov    %eax,0x4(%esp)
  80225a:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  802261:	e8 3f ed ff ff       	call   800fa5 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  802266:	ba 00 00 00 00       	mov    $0x0,%edx
  80226b:	b8 04 00 00 00       	mov    $0x4,%eax
  802270:	e8 77 fe ff ff       	call   8020ec <fsipc>
              return r;
        return r;
}
  802275:	c9                   	leave  
  802276:	c3                   	ret    

00802277 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  802277:	55                   	push   %ebp
  802278:	89 e5                	mov    %esp,%ebp
  80227a:	53                   	push   %ebx
  80227b:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  80227e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802285:	00 
  802286:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80228d:	00 
  80228e:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  802295:	e8 ac ec ff ff       	call   800f46 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  80229a:	8b 45 08             	mov    0x8(%ebp),%eax
  80229d:	8b 40 0c             	mov    0xc(%eax),%eax
  8022a0:	a3 00 40 80 00       	mov    %eax,0x804000
        fsipcbuf.read.req_n = n;
  8022a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8022a8:	a3 04 40 80 00       	mov    %eax,0x804004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  8022ad:	ba 00 00 00 00       	mov    $0x0,%edx
  8022b2:	b8 03 00 00 00       	mov    $0x3,%eax
  8022b7:	e8 30 fe ff ff       	call   8020ec <fsipc>
  8022bc:	89 c3                	mov    %eax,%ebx
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	78 17                	js     8022d9 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  8022c2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022c6:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  8022cd:	00 
  8022ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d1:	89 04 24             	mov    %eax,(%esp)
  8022d4:	e8 cc ec ff ff       	call   800fa5 <memmove>
        return r;
}
  8022d9:	89 d8                	mov    %ebx,%eax
  8022db:	83 c4 14             	add    $0x14,%esp
  8022de:	5b                   	pop    %ebx
  8022df:	5d                   	pop    %ebp
  8022e0:	c3                   	ret    

008022e1 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
  8022e4:	53                   	push   %ebx
  8022e5:	83 ec 14             	sub    $0x14,%esp
  8022e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  8022eb:	89 1c 24             	mov    %ebx,(%esp)
  8022ee:	e8 ad ea ff ff       	call   800da0 <strlen>
  8022f3:	89 c2                	mov    %eax,%edx
  8022f5:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8022fa:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  802300:	7f 1f                	jg     802321 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  802302:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802306:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  80230d:	e8 d8 ea ff ff       	call   800dea <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  802312:	ba 00 00 00 00       	mov    $0x0,%edx
  802317:	b8 07 00 00 00       	mov    $0x7,%eax
  80231c:	e8 cb fd ff ff       	call   8020ec <fsipc>
}
  802321:	83 c4 14             	add    $0x14,%esp
  802324:	5b                   	pop    %ebx
  802325:	5d                   	pop    %ebp
  802326:	c3                   	ret    

00802327 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
  80232a:	56                   	push   %esi
  80232b:	53                   	push   %ebx
  80232c:	83 ec 20             	sub    $0x20,%esp
  80232f:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  802332:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  802339:	00 
  80233a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802341:	00 
  802342:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  802349:	e8 f8 eb ff ff       	call   800f46 <memset>
    if(strlen(path)>=MAXPATHLEN)
  80234e:	89 34 24             	mov    %esi,(%esp)
  802351:	e8 4a ea ff ff       	call   800da0 <strlen>
  802356:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  80235b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802360:	0f 8f 84 00 00 00    	jg     8023ea <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  802366:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802369:	89 04 24             	mov    %eax,(%esp)
  80236c:	e8 8a f7 ff ff       	call   801afb <fd_alloc>
  802371:	89 c3                	mov    %eax,%ebx
  802373:	85 c0                	test   %eax,%eax
  802375:	78 73                	js     8023ea <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  802377:	0f b6 06             	movzbl (%esi),%eax
  80237a:	84 c0                	test   %al,%al
  80237c:	74 20                	je     80239e <open+0x77>
  80237e:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  802380:	0f be c0             	movsbl %al,%eax
  802383:	89 44 24 04          	mov    %eax,0x4(%esp)
  802387:	c7 04 24 04 3b 80 00 	movl   $0x803b04,(%esp)
  80238e:	e8 7e e3 ff ff       	call   800711 <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  802393:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  802397:	83 c3 01             	add    $0x1,%ebx
  80239a:	84 c0                	test   %al,%al
  80239c:	75 e2                	jne    802380 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  80239e:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023a2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  8023a9:	e8 3c ea ff ff       	call   800dea <strcpy>
    fsipcbuf.open.req_omode = mode;
  8023ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8023b1:	a3 00 44 80 00       	mov    %eax,0x804400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  8023b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8023be:	e8 29 fd ff ff       	call   8020ec <fsipc>
  8023c3:	89 c3                	mov    %eax,%ebx
  8023c5:	85 c0                	test   %eax,%eax
  8023c7:	79 15                	jns    8023de <open+0xb7>
        {
            fd_close(fd,1);
  8023c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8023d0:	00 
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	89 04 24             	mov    %eax,(%esp)
  8023d7:	e8 d3 fa ff ff       	call   801eaf <fd_close>
             return r;
  8023dc:	eb 0c                	jmp    8023ea <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  8023de:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8023e1:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  8023e7:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  8023ea:	89 d8                	mov    %ebx,%eax
  8023ec:	83 c4 20             	add    $0x20,%esp
  8023ef:	5b                   	pop    %ebx
  8023f0:	5e                   	pop    %esi
  8023f1:	5d                   	pop    %ebp
  8023f2:	c3                   	ret    
	...

00802400 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  802400:	55                   	push   %ebp
  802401:	89 e5                	mov    %esp,%ebp
  802403:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  802406:	c7 44 24 04 07 3b 80 	movl   $0x803b07,0x4(%esp)
  80240d:	00 
  80240e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802411:	89 04 24             	mov    %eax,(%esp)
  802414:	e8 d1 e9 ff ff       	call   800dea <strcpy>
	return 0;
}
  802419:	b8 00 00 00 00       	mov    $0x0,%eax
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
  802423:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  802426:	8b 45 08             	mov    0x8(%ebp),%eax
  802429:	8b 40 0c             	mov    0xc(%eax),%eax
  80242c:	89 04 24             	mov    %eax,(%esp)
  80242f:	e8 9e 02 00 00       	call   8026d2 <nsipc_close>
}
  802434:	c9                   	leave  
  802435:	c3                   	ret    

00802436 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  802436:	55                   	push   %ebp
  802437:	89 e5                	mov    %esp,%ebp
  802439:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  80243c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  802443:	00 
  802444:	8b 45 10             	mov    0x10(%ebp),%eax
  802447:	89 44 24 08          	mov    %eax,0x8(%esp)
  80244b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80244e:	89 44 24 04          	mov    %eax,0x4(%esp)
  802452:	8b 45 08             	mov    0x8(%ebp),%eax
  802455:	8b 40 0c             	mov    0xc(%eax),%eax
  802458:	89 04 24             	mov    %eax,(%esp)
  80245b:	e8 ae 02 00 00       	call   80270e <nsipc_send>
}
  802460:	c9                   	leave  
  802461:	c3                   	ret    

00802462 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  802462:	55                   	push   %ebp
  802463:	89 e5                	mov    %esp,%ebp
  802465:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  802468:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80246f:	00 
  802470:	8b 45 10             	mov    0x10(%ebp),%eax
  802473:	89 44 24 08          	mov    %eax,0x8(%esp)
  802477:	8b 45 0c             	mov    0xc(%ebp),%eax
  80247a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80247e:	8b 45 08             	mov    0x8(%ebp),%eax
  802481:	8b 40 0c             	mov    0xc(%eax),%eax
  802484:	89 04 24             	mov    %eax,(%esp)
  802487:	e8 f5 02 00 00       	call   802781 <nsipc_recv>
}
  80248c:	c9                   	leave  
  80248d:	c3                   	ret    

0080248e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  80248e:	55                   	push   %ebp
  80248f:	89 e5                	mov    %esp,%ebp
  802491:	56                   	push   %esi
  802492:	53                   	push   %ebx
  802493:	83 ec 20             	sub    $0x20,%esp
  802496:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  802498:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80249b:	89 04 24             	mov    %eax,(%esp)
  80249e:	e8 58 f6 ff ff       	call   801afb <fd_alloc>
  8024a3:	89 c3                	mov    %eax,%ebx
  8024a5:	85 c0                	test   %eax,%eax
  8024a7:	78 21                	js     8024ca <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  8024a9:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8024b0:	00 
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024b8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8024bf:	e8 82 f0 ff ff       	call   801546 <sys_page_alloc>
  8024c4:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  8024c6:	85 c0                	test   %eax,%eax
  8024c8:	79 0a                	jns    8024d4 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  8024ca:	89 34 24             	mov    %esi,(%esp)
  8024cd:	e8 00 02 00 00       	call   8026d2 <nsipc_close>
		return r;
  8024d2:	eb 28                	jmp    8024fc <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  8024d4:	8b 15 20 70 80 00    	mov    0x807020,%edx
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  8024e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ec:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  8024ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f2:	89 04 24             	mov    %eax,(%esp)
  8024f5:	e8 d6 f5 ff ff       	call   801ad0 <fd2num>
  8024fa:	89 c3                	mov    %eax,%ebx
}
  8024fc:	89 d8                	mov    %ebx,%eax
  8024fe:	83 c4 20             	add    $0x20,%esp
  802501:	5b                   	pop    %ebx
  802502:	5e                   	pop    %esi
  802503:	5d                   	pop    %ebp
  802504:	c3                   	ret    

00802505 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  802505:	55                   	push   %ebp
  802506:	89 e5                	mov    %esp,%ebp
  802508:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80250b:	8b 45 10             	mov    0x10(%ebp),%eax
  80250e:	89 44 24 08          	mov    %eax,0x8(%esp)
  802512:	8b 45 0c             	mov    0xc(%ebp),%eax
  802515:	89 44 24 04          	mov    %eax,0x4(%esp)
  802519:	8b 45 08             	mov    0x8(%ebp),%eax
  80251c:	89 04 24             	mov    %eax,(%esp)
  80251f:	e8 62 01 00 00       	call   802686 <nsipc_socket>
  802524:	85 c0                	test   %eax,%eax
  802526:	78 05                	js     80252d <socket+0x28>
		return r;
	return alloc_sockfd(r);
  802528:	e8 61 ff ff ff       	call   80248e <alloc_sockfd>
}
  80252d:	c9                   	leave  
  80252e:	66 90                	xchg   %ax,%ax
  802530:	c3                   	ret    

00802531 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  802531:	55                   	push   %ebp
  802532:	89 e5                	mov    %esp,%ebp
  802534:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  802537:	8d 55 f4             	lea    -0xc(%ebp),%edx
  80253a:	89 54 24 04          	mov    %edx,0x4(%esp)
  80253e:	89 04 24             	mov    %eax,(%esp)
  802541:	e8 27 f6 ff ff       	call   801b6d <fd_lookup>
  802546:	85 c0                	test   %eax,%eax
  802548:	78 15                	js     80255f <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  80254a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254d:	8b 0a                	mov    (%edx),%ecx
  80254f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802554:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  80255a:	75 03                	jne    80255f <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  80255c:	8b 42 0c             	mov    0xc(%edx),%eax
}
  80255f:	c9                   	leave  
  802560:	c3                   	ret    

00802561 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  802561:	55                   	push   %ebp
  802562:	89 e5                	mov    %esp,%ebp
  802564:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802567:	8b 45 08             	mov    0x8(%ebp),%eax
  80256a:	e8 c2 ff ff ff       	call   802531 <fd2sockid>
  80256f:	85 c0                	test   %eax,%eax
  802571:	78 0f                	js     802582 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  802573:	8b 55 0c             	mov    0xc(%ebp),%edx
  802576:	89 54 24 04          	mov    %edx,0x4(%esp)
  80257a:	89 04 24             	mov    %eax,(%esp)
  80257d:	e8 2e 01 00 00       	call   8026b0 <nsipc_listen>
}
  802582:	c9                   	leave  
  802583:	c3                   	ret    

00802584 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802584:	55                   	push   %ebp
  802585:	89 e5                	mov    %esp,%ebp
  802587:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80258a:	8b 45 08             	mov    0x8(%ebp),%eax
  80258d:	e8 9f ff ff ff       	call   802531 <fd2sockid>
  802592:	85 c0                	test   %eax,%eax
  802594:	78 16                	js     8025ac <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802596:	8b 55 10             	mov    0x10(%ebp),%edx
  802599:	89 54 24 08          	mov    %edx,0x8(%esp)
  80259d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025a0:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025a4:	89 04 24             	mov    %eax,(%esp)
  8025a7:	e8 55 02 00 00       	call   802801 <nsipc_connect>
}
  8025ac:	c9                   	leave  
  8025ad:	c3                   	ret    

008025ae <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  8025ae:	55                   	push   %ebp
  8025af:	89 e5                	mov    %esp,%ebp
  8025b1:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8025b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025b7:	e8 75 ff ff ff       	call   802531 <fd2sockid>
  8025bc:	85 c0                	test   %eax,%eax
  8025be:	78 0f                	js     8025cf <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  8025c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025c3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025c7:	89 04 24             	mov    %eax,(%esp)
  8025ca:	e8 1d 01 00 00       	call   8026ec <nsipc_shutdown>
}
  8025cf:	c9                   	leave  
  8025d0:	c3                   	ret    

008025d1 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8025d1:	55                   	push   %ebp
  8025d2:	89 e5                	mov    %esp,%ebp
  8025d4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8025d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8025da:	e8 52 ff ff ff       	call   802531 <fd2sockid>
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	78 16                	js     8025f9 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  8025e3:	8b 55 10             	mov    0x10(%ebp),%edx
  8025e6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8025ea:	8b 55 0c             	mov    0xc(%ebp),%edx
  8025ed:	89 54 24 04          	mov    %edx,0x4(%esp)
  8025f1:	89 04 24             	mov    %eax,(%esp)
  8025f4:	e8 47 02 00 00       	call   802840 <nsipc_bind>
}
  8025f9:	c9                   	leave  
  8025fa:	c3                   	ret    

008025fb <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8025fb:	55                   	push   %ebp
  8025fc:	89 e5                	mov    %esp,%ebp
  8025fe:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802601:	8b 45 08             	mov    0x8(%ebp),%eax
  802604:	e8 28 ff ff ff       	call   802531 <fd2sockid>
  802609:	85 c0                	test   %eax,%eax
  80260b:	78 1f                	js     80262c <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80260d:	8b 55 10             	mov    0x10(%ebp),%edx
  802610:	89 54 24 08          	mov    %edx,0x8(%esp)
  802614:	8b 55 0c             	mov    0xc(%ebp),%edx
  802617:	89 54 24 04          	mov    %edx,0x4(%esp)
  80261b:	89 04 24             	mov    %eax,(%esp)
  80261e:	e8 5c 02 00 00       	call   80287f <nsipc_accept>
  802623:	85 c0                	test   %eax,%eax
  802625:	78 05                	js     80262c <accept+0x31>
		return r;
	return alloc_sockfd(r);
  802627:	e8 62 fe ff ff       	call   80248e <alloc_sockfd>
}
  80262c:	c9                   	leave  
  80262d:	8d 76 00             	lea    0x0(%esi),%esi
  802630:	c3                   	ret    
	...

00802640 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  802640:	55                   	push   %ebp
  802641:	89 e5                	mov    %esp,%ebp
  802643:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  802646:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  80264c:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  802653:	00 
  802654:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  80265b:	00 
  80265c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802660:	89 14 24             	mov    %edx,(%esp)
  802663:	e8 98 f3 ff ff       	call   801a00 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  802668:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80266f:	00 
  802670:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802677:	00 
  802678:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80267f:	e8 de f3 ff ff       	call   801a62 <ipc_recv>
}
  802684:	c9                   	leave  
  802685:	c3                   	ret    

00802686 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  802686:	55                   	push   %ebp
  802687:	89 e5                	mov    %esp,%ebp
  802689:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80268c:	8b 45 08             	mov    0x8(%ebp),%eax
  80268f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802694:	8b 45 0c             	mov    0xc(%ebp),%eax
  802697:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80269c:	8b 45 10             	mov    0x10(%ebp),%eax
  80269f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  8026a4:	b8 09 00 00 00       	mov    $0x9,%eax
  8026a9:	e8 92 ff ff ff       	call   802640 <nsipc>
}
  8026ae:	c9                   	leave  
  8026af:	c3                   	ret    

008026b0 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  8026b0:	55                   	push   %ebp
  8026b1:	89 e5                	mov    %esp,%ebp
  8026b3:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  8026b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026b9:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  8026be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026c1:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  8026c6:	b8 06 00 00 00       	mov    $0x6,%eax
  8026cb:	e8 70 ff ff ff       	call   802640 <nsipc>
}
  8026d0:	c9                   	leave  
  8026d1:	c3                   	ret    

008026d2 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  8026d2:	55                   	push   %ebp
  8026d3:	89 e5                	mov    %esp,%ebp
  8026d5:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  8026d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8026db:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  8026e0:	b8 04 00 00 00       	mov    $0x4,%eax
  8026e5:	e8 56 ff ff ff       	call   802640 <nsipc>
}
  8026ea:	c9                   	leave  
  8026eb:	c3                   	ret    

008026ec <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  8026ec:	55                   	push   %ebp
  8026ed:	89 e5                	mov    %esp,%ebp
  8026ef:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  8026f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f5:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  8026fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026fd:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802702:	b8 03 00 00 00       	mov    $0x3,%eax
  802707:	e8 34 ff ff ff       	call   802640 <nsipc>
}
  80270c:	c9                   	leave  
  80270d:	c3                   	ret    

0080270e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80270e:	55                   	push   %ebp
  80270f:	89 e5                	mov    %esp,%ebp
  802711:	53                   	push   %ebx
  802712:	83 ec 14             	sub    $0x14,%esp
  802715:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  802718:	8b 45 08             	mov    0x8(%ebp),%eax
  80271b:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  802720:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  802726:	7e 24                	jle    80274c <nsipc_send+0x3e>
  802728:	c7 44 24 0c 13 3b 80 	movl   $0x803b13,0xc(%esp)
  80272f:	00 
  802730:	c7 44 24 08 1f 3b 80 	movl   $0x803b1f,0x8(%esp)
  802737:	00 
  802738:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  80273f:	00 
  802740:	c7 04 24 34 3b 80 00 	movl   $0x803b34,(%esp)
  802747:	e8 00 df ff ff       	call   80064c <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  80274c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802750:	8b 45 0c             	mov    0xc(%ebp),%eax
  802753:	89 44 24 04          	mov    %eax,0x4(%esp)
  802757:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  80275e:	e8 42 e8 ff ff       	call   800fa5 <memmove>
	nsipcbuf.send.req_size = size;
  802763:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  802769:	8b 45 14             	mov    0x14(%ebp),%eax
  80276c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802771:	b8 08 00 00 00       	mov    $0x8,%eax
  802776:	e8 c5 fe ff ff       	call   802640 <nsipc>
}
  80277b:	83 c4 14             	add    $0x14,%esp
  80277e:	5b                   	pop    %ebx
  80277f:	5d                   	pop    %ebp
  802780:	c3                   	ret    

00802781 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802781:	55                   	push   %ebp
  802782:	89 e5                	mov    %esp,%ebp
  802784:	56                   	push   %esi
  802785:	53                   	push   %ebx
  802786:	83 ec 10             	sub    $0x10,%esp
  802789:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80278c:	8b 45 08             	mov    0x8(%ebp),%eax
  80278f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802794:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80279a:	8b 45 14             	mov    0x14(%ebp),%eax
  80279d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  8027a2:	b8 07 00 00 00       	mov    $0x7,%eax
  8027a7:	e8 94 fe ff ff       	call   802640 <nsipc>
  8027ac:	89 c3                	mov    %eax,%ebx
  8027ae:	85 c0                	test   %eax,%eax
  8027b0:	78 46                	js     8027f8 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  8027b2:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  8027b7:	7f 04                	jg     8027bd <nsipc_recv+0x3c>
  8027b9:	39 c6                	cmp    %eax,%esi
  8027bb:	7d 24                	jge    8027e1 <nsipc_recv+0x60>
  8027bd:	c7 44 24 0c 40 3b 80 	movl   $0x803b40,0xc(%esp)
  8027c4:	00 
  8027c5:	c7 44 24 08 1f 3b 80 	movl   $0x803b1f,0x8(%esp)
  8027cc:	00 
  8027cd:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  8027d4:	00 
  8027d5:	c7 04 24 34 3b 80 00 	movl   $0x803b34,(%esp)
  8027dc:	e8 6b de ff ff       	call   80064c <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  8027e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8027e5:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8027ec:	00 
  8027ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8027f0:	89 04 24             	mov    %eax,(%esp)
  8027f3:	e8 ad e7 ff ff       	call   800fa5 <memmove>
	}

	return r;
}
  8027f8:	89 d8                	mov    %ebx,%eax
  8027fa:	83 c4 10             	add    $0x10,%esp
  8027fd:	5b                   	pop    %ebx
  8027fe:	5e                   	pop    %esi
  8027ff:	5d                   	pop    %ebp
  802800:	c3                   	ret    

00802801 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802801:	55                   	push   %ebp
  802802:	89 e5                	mov    %esp,%ebp
  802804:	53                   	push   %ebx
  802805:	83 ec 14             	sub    $0x14,%esp
  802808:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80280b:	8b 45 08             	mov    0x8(%ebp),%eax
  80280e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  802813:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802817:	8b 45 0c             	mov    0xc(%ebp),%eax
  80281a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80281e:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802825:	e8 7b e7 ff ff       	call   800fa5 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  80282a:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  802830:	b8 05 00 00 00       	mov    $0x5,%eax
  802835:	e8 06 fe ff ff       	call   802640 <nsipc>
}
  80283a:	83 c4 14             	add    $0x14,%esp
  80283d:	5b                   	pop    %ebx
  80283e:	5d                   	pop    %ebp
  80283f:	c3                   	ret    

00802840 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802840:	55                   	push   %ebp
  802841:	89 e5                	mov    %esp,%ebp
  802843:	53                   	push   %ebx
  802844:	83 ec 14             	sub    $0x14,%esp
  802847:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  80284a:	8b 45 08             	mov    0x8(%ebp),%eax
  80284d:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  802852:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802856:	8b 45 0c             	mov    0xc(%ebp),%eax
  802859:	89 44 24 04          	mov    %eax,0x4(%esp)
  80285d:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  802864:	e8 3c e7 ff ff       	call   800fa5 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  802869:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  80286f:	b8 02 00 00 00       	mov    $0x2,%eax
  802874:	e8 c7 fd ff ff       	call   802640 <nsipc>
}
  802879:	83 c4 14             	add    $0x14,%esp
  80287c:	5b                   	pop    %ebx
  80287d:	5d                   	pop    %ebp
  80287e:	c3                   	ret    

0080287f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80287f:	55                   	push   %ebp
  802880:	89 e5                	mov    %esp,%ebp
  802882:	83 ec 18             	sub    $0x18,%esp
  802885:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802888:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80288b:	8b 45 08             	mov    0x8(%ebp),%eax
  80288e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802893:	b8 01 00 00 00       	mov    $0x1,%eax
  802898:	e8 a3 fd ff ff       	call   802640 <nsipc>
  80289d:	89 c3                	mov    %eax,%ebx
  80289f:	85 c0                	test   %eax,%eax
  8028a1:	78 25                	js     8028c8 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  8028a3:	be 10 60 80 00       	mov    $0x806010,%esi
  8028a8:	8b 06                	mov    (%esi),%eax
  8028aa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8028ae:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  8028b5:	00 
  8028b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8028b9:	89 04 24             	mov    %eax,(%esp)
  8028bc:	e8 e4 e6 ff ff       	call   800fa5 <memmove>
		*addrlen = ret->ret_addrlen;
  8028c1:	8b 16                	mov    (%esi),%edx
  8028c3:	8b 45 10             	mov    0x10(%ebp),%eax
  8028c6:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  8028c8:	89 d8                	mov    %ebx,%eax
  8028ca:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8028cd:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8028d0:	89 ec                	mov    %ebp,%esp
  8028d2:	5d                   	pop    %ebp
  8028d3:	c3                   	ret    
	...

008028e0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8028e0:	55                   	push   %ebp
  8028e1:	89 e5                	mov    %esp,%ebp
  8028e3:	83 ec 18             	sub    $0x18,%esp
  8028e6:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8028e9:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8028ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f2:	89 04 24             	mov    %eax,(%esp)
  8028f5:	e8 e6 f1 ff ff       	call   801ae0 <fd2data>
  8028fa:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  8028fc:	c7 44 24 04 55 3b 80 	movl   $0x803b55,0x4(%esp)
  802903:	00 
  802904:	89 34 24             	mov    %esi,(%esp)
  802907:	e8 de e4 ff ff       	call   800dea <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80290c:	8b 43 04             	mov    0x4(%ebx),%eax
  80290f:	2b 03                	sub    (%ebx),%eax
  802911:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  802917:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80291e:	00 00 00 
	stat->st_dev = &devpipe;
  802921:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  802928:	70 80 00 
	return 0;
}
  80292b:	b8 00 00 00 00       	mov    $0x0,%eax
  802930:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802933:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802936:	89 ec                	mov    %ebp,%esp
  802938:	5d                   	pop    %ebp
  802939:	c3                   	ret    

0080293a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80293a:	55                   	push   %ebp
  80293b:	89 e5                	mov    %esp,%ebp
  80293d:	53                   	push   %ebx
  80293e:	83 ec 14             	sub    $0x14,%esp
  802941:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802944:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802948:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80294f:	e8 36 eb ff ff       	call   80148a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802954:	89 1c 24             	mov    %ebx,(%esp)
  802957:	e8 84 f1 ff ff       	call   801ae0 <fd2data>
  80295c:	89 44 24 04          	mov    %eax,0x4(%esp)
  802960:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802967:	e8 1e eb ff ff       	call   80148a <sys_page_unmap>
}
  80296c:	83 c4 14             	add    $0x14,%esp
  80296f:	5b                   	pop    %ebx
  802970:	5d                   	pop    %ebp
  802971:	c3                   	ret    

00802972 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802972:	55                   	push   %ebp
  802973:	89 e5                	mov    %esp,%ebp
  802975:	57                   	push   %edi
  802976:	56                   	push   %esi
  802977:	53                   	push   %ebx
  802978:	83 ec 2c             	sub    $0x2c,%esp
  80297b:	89 c7                	mov    %eax,%edi
  80297d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802980:	a1 90 70 80 00       	mov    0x807090,%eax
  802985:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802988:	89 3c 24             	mov    %edi,(%esp)
  80298b:	e8 7c 05 00 00       	call   802f0c <pageref>
  802990:	89 c6                	mov    %eax,%esi
  802992:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802995:	89 04 24             	mov    %eax,(%esp)
  802998:	e8 6f 05 00 00       	call   802f0c <pageref>
  80299d:	39 c6                	cmp    %eax,%esi
  80299f:	0f 94 c0             	sete   %al
  8029a2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  8029a5:	8b 15 90 70 80 00    	mov    0x807090,%edx
  8029ab:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8029ae:	39 cb                	cmp    %ecx,%ebx
  8029b0:	75 08                	jne    8029ba <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  8029b2:	83 c4 2c             	add    $0x2c,%esp
  8029b5:	5b                   	pop    %ebx
  8029b6:	5e                   	pop    %esi
  8029b7:	5f                   	pop    %edi
  8029b8:	5d                   	pop    %ebp
  8029b9:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  8029ba:	83 f8 01             	cmp    $0x1,%eax
  8029bd:	75 c1                	jne    802980 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  8029bf:	8b 52 58             	mov    0x58(%edx),%edx
  8029c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029c6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8029ca:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8029ce:	c7 04 24 5c 3b 80 00 	movl   $0x803b5c,(%esp)
  8029d5:	e8 37 dd ff ff       	call   800711 <cprintf>
  8029da:	eb a4                	jmp    802980 <_pipeisclosed+0xe>

008029dc <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  8029dc:	55                   	push   %ebp
  8029dd:	89 e5                	mov    %esp,%ebp
  8029df:	57                   	push   %edi
  8029e0:	56                   	push   %esi
  8029e1:	53                   	push   %ebx
  8029e2:	83 ec 1c             	sub    $0x1c,%esp
  8029e5:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  8029e8:	89 34 24             	mov    %esi,(%esp)
  8029eb:	e8 f0 f0 ff ff       	call   801ae0 <fd2data>
  8029f0:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8029f2:	bf 00 00 00 00       	mov    $0x0,%edi
  8029f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8029fb:	75 54                	jne    802a51 <devpipe_write+0x75>
  8029fd:	eb 60                	jmp    802a5f <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  8029ff:	89 da                	mov    %ebx,%edx
  802a01:	89 f0                	mov    %esi,%eax
  802a03:	e8 6a ff ff ff       	call   802972 <_pipeisclosed>
  802a08:	85 c0                	test   %eax,%eax
  802a0a:	74 07                	je     802a13 <devpipe_write+0x37>
  802a0c:	b8 00 00 00 00       	mov    $0x0,%eax
  802a11:	eb 53                	jmp    802a66 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  802a13:	90                   	nop
  802a14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802a18:	e8 88 eb ff ff       	call   8015a5 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802a1d:	8b 43 04             	mov    0x4(%ebx),%eax
  802a20:	8b 13                	mov    (%ebx),%edx
  802a22:	83 c2 20             	add    $0x20,%edx
  802a25:	39 d0                	cmp    %edx,%eax
  802a27:	73 d6                	jae    8029ff <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802a29:	89 c2                	mov    %eax,%edx
  802a2b:	c1 fa 1f             	sar    $0x1f,%edx
  802a2e:	c1 ea 1b             	shr    $0x1b,%edx
  802a31:	01 d0                	add    %edx,%eax
  802a33:	83 e0 1f             	and    $0x1f,%eax
  802a36:	29 d0                	sub    %edx,%eax
  802a38:	89 c2                	mov    %eax,%edx
  802a3a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802a3d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  802a41:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  802a45:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a49:	83 c7 01             	add    $0x1,%edi
  802a4c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  802a4f:	76 13                	jbe    802a64 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802a51:	8b 43 04             	mov    0x4(%ebx),%eax
  802a54:	8b 13                	mov    (%ebx),%edx
  802a56:	83 c2 20             	add    $0x20,%edx
  802a59:	39 d0                	cmp    %edx,%eax
  802a5b:	73 a2                	jae    8029ff <devpipe_write+0x23>
  802a5d:	eb ca                	jmp    802a29 <devpipe_write+0x4d>
  802a5f:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  802a64:	89 f8                	mov    %edi,%eax
}
  802a66:	83 c4 1c             	add    $0x1c,%esp
  802a69:	5b                   	pop    %ebx
  802a6a:	5e                   	pop    %esi
  802a6b:	5f                   	pop    %edi
  802a6c:	5d                   	pop    %ebp
  802a6d:	c3                   	ret    

00802a6e <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  802a6e:	55                   	push   %ebp
  802a6f:	89 e5                	mov    %esp,%ebp
  802a71:	83 ec 28             	sub    $0x28,%esp
  802a74:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802a77:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802a7a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802a7d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802a80:	89 3c 24             	mov    %edi,(%esp)
  802a83:	e8 58 f0 ff ff       	call   801ae0 <fd2data>
  802a88:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802a8a:	be 00 00 00 00       	mov    $0x0,%esi
  802a8f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802a93:	75 4c                	jne    802ae1 <devpipe_read+0x73>
  802a95:	eb 5b                	jmp    802af2 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802a97:	89 f0                	mov    %esi,%eax
  802a99:	eb 5e                	jmp    802af9 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  802a9b:	89 da                	mov    %ebx,%edx
  802a9d:	89 f8                	mov    %edi,%eax
  802a9f:	90                   	nop
  802aa0:	e8 cd fe ff ff       	call   802972 <_pipeisclosed>
  802aa5:	85 c0                	test   %eax,%eax
  802aa7:	74 07                	je     802ab0 <devpipe_read+0x42>
  802aa9:	b8 00 00 00 00       	mov    $0x0,%eax
  802aae:	eb 49                	jmp    802af9 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802ab0:	e8 f0 ea ff ff       	call   8015a5 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802ab5:	8b 03                	mov    (%ebx),%eax
  802ab7:	3b 43 04             	cmp    0x4(%ebx),%eax
  802aba:	74 df                	je     802a9b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802abc:	89 c2                	mov    %eax,%edx
  802abe:	c1 fa 1f             	sar    $0x1f,%edx
  802ac1:	c1 ea 1b             	shr    $0x1b,%edx
  802ac4:	01 d0                	add    %edx,%eax
  802ac6:	83 e0 1f             	and    $0x1f,%eax
  802ac9:	29 d0                	sub    %edx,%eax
  802acb:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802ad0:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ad3:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802ad6:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802ad9:	83 c6 01             	add    $0x1,%esi
  802adc:	39 75 10             	cmp    %esi,0x10(%ebp)
  802adf:	76 16                	jbe    802af7 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802ae1:	8b 03                	mov    (%ebx),%eax
  802ae3:	3b 43 04             	cmp    0x4(%ebx),%eax
  802ae6:	75 d4                	jne    802abc <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802ae8:	85 f6                	test   %esi,%esi
  802aea:	75 ab                	jne    802a97 <devpipe_read+0x29>
  802aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802af0:	eb a9                	jmp    802a9b <devpipe_read+0x2d>
  802af2:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802af7:	89 f0                	mov    %esi,%eax
}
  802af9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802afc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802aff:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802b02:	89 ec                	mov    %ebp,%esp
  802b04:	5d                   	pop    %ebp
  802b05:	c3                   	ret    

00802b06 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802b06:	55                   	push   %ebp
  802b07:	89 e5                	mov    %esp,%ebp
  802b09:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b13:	8b 45 08             	mov    0x8(%ebp),%eax
  802b16:	89 04 24             	mov    %eax,(%esp)
  802b19:	e8 4f f0 ff ff       	call   801b6d <fd_lookup>
  802b1e:	85 c0                	test   %eax,%eax
  802b20:	78 15                	js     802b37 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  802b22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b25:	89 04 24             	mov    %eax,(%esp)
  802b28:	e8 b3 ef ff ff       	call   801ae0 <fd2data>
	return _pipeisclosed(fd, p);
  802b2d:	89 c2                	mov    %eax,%edx
  802b2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b32:	e8 3b fe ff ff       	call   802972 <_pipeisclosed>
}
  802b37:	c9                   	leave  
  802b38:	c3                   	ret    

00802b39 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  802b39:	55                   	push   %ebp
  802b3a:	89 e5                	mov    %esp,%ebp
  802b3c:	83 ec 48             	sub    $0x48,%esp
  802b3f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802b42:	89 75 f8             	mov    %esi,-0x8(%ebp)
  802b45:	89 7d fc             	mov    %edi,-0x4(%ebp)
  802b48:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802b4b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  802b4e:	89 04 24             	mov    %eax,(%esp)
  802b51:	e8 a5 ef ff ff       	call   801afb <fd_alloc>
  802b56:	89 c3                	mov    %eax,%ebx
  802b58:	85 c0                	test   %eax,%eax
  802b5a:	0f 88 42 01 00 00    	js     802ca2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b60:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802b67:	00 
  802b68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802b6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  802b6f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802b76:	e8 cb e9 ff ff       	call   801546 <sys_page_alloc>
  802b7b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  802b7d:	85 c0                	test   %eax,%eax
  802b7f:	0f 88 1d 01 00 00    	js     802ca2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802b85:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802b88:	89 04 24             	mov    %eax,(%esp)
  802b8b:	e8 6b ef ff ff       	call   801afb <fd_alloc>
  802b90:	89 c3                	mov    %eax,%ebx
  802b92:	85 c0                	test   %eax,%eax
  802b94:	0f 88 f5 00 00 00    	js     802c8f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802b9a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802ba1:	00 
  802ba2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ba5:	89 44 24 04          	mov    %eax,0x4(%esp)
  802ba9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bb0:	e8 91 e9 ff ff       	call   801546 <sys_page_alloc>
  802bb5:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802bb7:	85 c0                	test   %eax,%eax
  802bb9:	0f 88 d0 00 00 00    	js     802c8f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  802bbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc2:	89 04 24             	mov    %eax,(%esp)
  802bc5:	e8 16 ef ff ff       	call   801ae0 <fd2data>
  802bca:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bcc:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802bd3:	00 
  802bd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  802bd8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802bdf:	e8 62 e9 ff ff       	call   801546 <sys_page_alloc>
  802be4:	89 c3                	mov    %eax,%ebx
  802be6:	85 c0                	test   %eax,%eax
  802be8:	0f 88 8e 00 00 00    	js     802c7c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802bee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802bf1:	89 04 24             	mov    %eax,(%esp)
  802bf4:	e8 e7 ee ff ff       	call   801ae0 <fd2data>
  802bf9:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802c00:	00 
  802c01:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802c05:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  802c0c:	00 
  802c0d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c18:	e8 cb e8 ff ff       	call   8014e8 <sys_page_map>
  802c1d:	89 c3                	mov    %eax,%ebx
  802c1f:	85 c0                	test   %eax,%eax
  802c21:	78 49                	js     802c6c <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802c23:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  802c28:	8b 08                	mov    (%eax),%ecx
  802c2a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c2d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  802c2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802c32:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802c39:	8b 10                	mov    (%eax),%edx
  802c3b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c3e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802c40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c43:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  802c4a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c4d:	89 04 24             	mov    %eax,(%esp)
  802c50:	e8 7b ee ff ff       	call   801ad0 <fd2num>
  802c55:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  802c57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c5a:	89 04 24             	mov    %eax,(%esp)
  802c5d:	e8 6e ee ff ff       	call   801ad0 <fd2num>
  802c62:	89 47 04             	mov    %eax,0x4(%edi)
  802c65:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  802c6a:	eb 36                	jmp    802ca2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  802c6c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802c70:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c77:	e8 0e e8 ff ff       	call   80148a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  802c7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802c7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c83:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c8a:	e8 fb e7 ff ff       	call   80148a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  802c8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802c92:	89 44 24 04          	mov    %eax,0x4(%esp)
  802c96:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802c9d:	e8 e8 e7 ff ff       	call   80148a <sys_page_unmap>
    err:
	return r;
}
  802ca2:	89 d8                	mov    %ebx,%eax
  802ca4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802ca7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  802caa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802cad:	89 ec                	mov    %ebp,%esp
  802caf:	5d                   	pop    %ebp
  802cb0:	c3                   	ret    
	...

00802cc0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802cc0:	55                   	push   %ebp
  802cc1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  802cc8:	5d                   	pop    %ebp
  802cc9:	c3                   	ret    

00802cca <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802cca:	55                   	push   %ebp
  802ccb:	89 e5                	mov    %esp,%ebp
  802ccd:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802cd0:	c7 44 24 04 74 3b 80 	movl   $0x803b74,0x4(%esp)
  802cd7:	00 
  802cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  802cdb:	89 04 24             	mov    %eax,(%esp)
  802cde:	e8 07 e1 ff ff       	call   800dea <strcpy>
	return 0;
}
  802ce3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ce8:	c9                   	leave  
  802ce9:	c3                   	ret    

00802cea <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  802cea:	55                   	push   %ebp
  802ceb:	89 e5                	mov    %esp,%ebp
  802ced:	57                   	push   %edi
  802cee:	56                   	push   %esi
  802cef:	53                   	push   %ebx
  802cf0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802cf6:	b8 00 00 00 00       	mov    $0x0,%eax
  802cfb:	be 00 00 00 00       	mov    $0x0,%esi
  802d00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802d04:	74 3f                	je     802d45 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802d06:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  802d0c:	8b 55 10             	mov    0x10(%ebp),%edx
  802d0f:	29 c2                	sub    %eax,%edx
  802d11:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802d13:	83 fa 7f             	cmp    $0x7f,%edx
  802d16:	76 05                	jbe    802d1d <devcons_write+0x33>
  802d18:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802d1d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802d21:	03 45 0c             	add    0xc(%ebp),%eax
  802d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  802d28:	89 3c 24             	mov    %edi,(%esp)
  802d2b:	e8 75 e2 ff ff       	call   800fa5 <memmove>
		sys_cputs(buf, m);
  802d30:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802d34:	89 3c 24             	mov    %edi,(%esp)
  802d37:	e8 a4 e4 ff ff       	call   8011e0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802d3c:	01 de                	add    %ebx,%esi
  802d3e:	89 f0                	mov    %esi,%eax
  802d40:	3b 75 10             	cmp    0x10(%ebp),%esi
  802d43:	72 c7                	jb     802d0c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802d45:	89 f0                	mov    %esi,%eax
  802d47:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  802d4d:	5b                   	pop    %ebx
  802d4e:	5e                   	pop    %esi
  802d4f:	5f                   	pop    %edi
  802d50:	5d                   	pop    %ebp
  802d51:	c3                   	ret    

00802d52 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  802d52:	55                   	push   %ebp
  802d53:	89 e5                	mov    %esp,%ebp
  802d55:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  802d58:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5b:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  802d5e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  802d65:	00 
  802d66:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802d69:	89 04 24             	mov    %eax,(%esp)
  802d6c:	e8 6f e4 ff ff       	call   8011e0 <sys_cputs>
}
  802d71:	c9                   	leave  
  802d72:	c3                   	ret    

00802d73 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802d73:	55                   	push   %ebp
  802d74:	89 e5                	mov    %esp,%ebp
  802d76:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802d79:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802d7d:	75 07                	jne    802d86 <devcons_read+0x13>
  802d7f:	eb 28                	jmp    802da9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802d81:	e8 1f e8 ff ff       	call   8015a5 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802d86:	66 90                	xchg   %ax,%ax
  802d88:	e8 1f e4 ff ff       	call   8011ac <sys_cgetc>
  802d8d:	85 c0                	test   %eax,%eax
  802d8f:	90                   	nop
  802d90:	74 ef                	je     802d81 <devcons_read+0xe>
  802d92:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802d94:	85 c0                	test   %eax,%eax
  802d96:	78 16                	js     802dae <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802d98:	83 f8 04             	cmp    $0x4,%eax
  802d9b:	74 0c                	je     802da9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  802d9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802da0:	88 10                	mov    %dl,(%eax)
  802da2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802da7:	eb 05                	jmp    802dae <devcons_read+0x3b>
  802da9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dae:	c9                   	leave  
  802daf:	c3                   	ret    

00802db0 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802db0:	55                   	push   %ebp
  802db1:	89 e5                	mov    %esp,%ebp
  802db3:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802db6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802db9:	89 04 24             	mov    %eax,(%esp)
  802dbc:	e8 3a ed ff ff       	call   801afb <fd_alloc>
  802dc1:	85 c0                	test   %eax,%eax
  802dc3:	78 3f                	js     802e04 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802dc5:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802dcc:	00 
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  802dd4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802ddb:	e8 66 e7 ff ff       	call   801546 <sys_page_alloc>
  802de0:	85 c0                	test   %eax,%eax
  802de2:	78 20                	js     802e04 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802de4:	8b 15 58 70 80 00    	mov    0x807058,%edx
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  802def:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802df9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfc:	89 04 24             	mov    %eax,(%esp)
  802dff:	e8 cc ec ff ff       	call   801ad0 <fd2num>
}
  802e04:	c9                   	leave  
  802e05:	c3                   	ret    

00802e06 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802e06:	55                   	push   %ebp
  802e07:	89 e5                	mov    %esp,%ebp
  802e09:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802e0c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802e0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	89 04 24             	mov    %eax,(%esp)
  802e19:	e8 4f ed ff ff       	call   801b6d <fd_lookup>
  802e1e:	85 c0                	test   %eax,%eax
  802e20:	78 11                	js     802e33 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	8b 00                	mov    (%eax),%eax
  802e27:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  802e2d:	0f 94 c0             	sete   %al
  802e30:	0f b6 c0             	movzbl %al,%eax
}
  802e33:	c9                   	leave  
  802e34:	c3                   	ret    

00802e35 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802e35:	55                   	push   %ebp
  802e36:	89 e5                	mov    %esp,%ebp
  802e38:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  802e3b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802e42:	00 
  802e43:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802e46:	89 44 24 04          	mov    %eax,0x4(%esp)
  802e4a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802e51:	e8 78 ef ff ff       	call   801dce <read>
	if (r < 0)
  802e56:	85 c0                	test   %eax,%eax
  802e58:	78 0f                	js     802e69 <getchar+0x34>
		return r;
	if (r < 1)
  802e5a:	85 c0                	test   %eax,%eax
  802e5c:	7f 07                	jg     802e65 <getchar+0x30>
  802e5e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802e63:	eb 04                	jmp    802e69 <getchar+0x34>
		return -E_EOF;
	return c;
  802e65:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802e69:	c9                   	leave  
  802e6a:	c3                   	ret    
	...

00802e6c <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802e6c:	55                   	push   %ebp
  802e6d:	89 e5                	mov    %esp,%ebp
  802e6f:	53                   	push   %ebx
  802e70:	83 ec 14             	sub    $0x14,%esp
  802e73:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
    // cprintf("\nhere outside loading creating page\n");

	if (_pgfault_handler == 0) {
  802e76:	83 3d 98 70 80 00 00 	cmpl   $0x0,0x807098
  802e7d:	75 58                	jne    802ed7 <set_pgfault_handler+0x6b>
		// First time through!
		// LAB 4: Your code here.
           //cprintf("\nhere inside loading creating page\n");    
          if(sys_page_alloc(sys_getenvid(),(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
  802e7f:	e8 55 e7 ff ff       	call   8015d9 <sys_getenvid>
  802e84:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  802e8b:	00 
  802e8c:	c7 44 24 04 00 f0 bf 	movl   $0xeebff000,0x4(%esp)
  802e93:	ee 
  802e94:	89 04 24             	mov    %eax,(%esp)
  802e97:	e8 aa e6 ff ff       	call   801546 <sys_page_alloc>
  802e9c:	85 c0                	test   %eax,%eax
  802e9e:	79 1c                	jns    802ebc <set_pgfault_handler+0x50>
                          panic("Cant allocate Page");                    
  802ea0:	c7 44 24 08 db 39 80 	movl   $0x8039db,0x8(%esp)
  802ea7:	00 
  802ea8:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  802eaf:	00 
  802eb0:	c7 04 24 80 3b 80 00 	movl   $0x803b80,(%esp)
  802eb7:	e8 90 d7 ff ff       	call   80064c <_panic>
                _pgfault_handler=handler;
  802ebc:	89 1d 98 70 80 00    	mov    %ebx,0x807098
//entry point _pgfault_handler not pointed to by the kernel bcz after the execution is complete control needs to be returned back to execute the rest...so upcall is there         
             sys_env_set_pgfault_upcall(sys_getenvid(),_pgfault_upcall);
  802ec2:	e8 12 e7 ff ff       	call   8015d9 <sys_getenvid>
  802ec7:	c7 44 24 04 e4 2e 80 	movl   $0x802ee4,0x4(%esp)
  802ece:	00 
  802ecf:	89 04 24             	mov    %eax,(%esp)
  802ed2:	e8 99 e4 ff ff       	call   801370 <sys_env_set_pgfault_upcall>

	// Save handler pointer for assembly to call.
 //     if(sys_page_alloc(0,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
   //                       panic("Cant allocate Page");

	_pgfault_handler = handler;
  802ed7:	89 1d 98 70 80 00    	mov    %ebx,0x807098
}
  802edd:	83 c4 14             	add    $0x14,%esp
  802ee0:	5b                   	pop    %ebx
  802ee1:	5d                   	pop    %ebp
  802ee2:	c3                   	ret    
	...

00802ee4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802ee4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802ee5:	a1 98 70 80 00       	mov    0x807098,%eax
	call *%eax
  802eea:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802eec:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
           addl $8,%esp
  802eef:	83 c4 08             	add    $0x8,%esp

	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
            movl  32(%esp),%ebx
  802ef2:	8b 5c 24 20          	mov    0x20(%esp),%ebx
            movl  40(%esp),%eax
  802ef6:	8b 44 24 28          	mov    0x28(%esp),%eax
            subl  $4,%eax
  802efa:	83 e8 04             	sub    $0x4,%eax
            movl  %eax,40(%esp)
  802efd:	89 44 24 28          	mov    %eax,0x28(%esp)
            movl  %ebx,(%eax)
  802f01:	89 18                	mov    %ebx,(%eax)
            popal
  802f03:	61                   	popa   
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
            
            add $4,%esp            
  802f04:	83 c4 04             	add    $0x4,%esp
            popfl
  802f07:	9d                   	popf   
             
           popl %esp
  802f08:	5c                   	pop    %esp
	// LAB 4: Your code here.
           

	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
           ret
  802f09:	c3                   	ret    
	...

00802f0c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802f0c:	55                   	push   %ebp
  802f0d:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	89 c2                	mov    %eax,%edx
  802f14:	c1 ea 16             	shr    $0x16,%edx
  802f17:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802f1e:	f6 c2 01             	test   $0x1,%dl
  802f21:	74 26                	je     802f49 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802f23:	c1 e8 0c             	shr    $0xc,%eax
  802f26:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802f2d:	a8 01                	test   $0x1,%al
  802f2f:	74 18                	je     802f49 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802f31:	c1 e8 0c             	shr    $0xc,%eax
  802f34:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802f37:	c1 e2 02             	shl    $0x2,%edx
  802f3a:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802f3f:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802f44:	0f b7 c0             	movzwl %ax,%eax
  802f47:	eb 05                	jmp    802f4e <pageref+0x42>
  802f49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f4e:	5d                   	pop    %ebp
  802f4f:	c3                   	ret    

00802f50 <inet_ntoa>:
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
{
  802f50:	55                   	push   %ebp
  802f51:	89 e5                	mov    %esp,%ebp
  802f53:	57                   	push   %edi
  802f54:	56                   	push   %esi
  802f55:	53                   	push   %ebx
  802f56:	83 ec 1c             	sub    $0x1c,%esp
  static char str[16];
  u32_t s_addr = addr.s_addr;
  802f59:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  u8_t rem;
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  802f5f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802f62:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  802f65:	8d 45 f3             	lea    -0xd(%ebp),%eax
  802f68:	89 45 d8             	mov    %eax,-0x28(%ebp)
  802f6b:	b9 80 70 80 00       	mov    $0x807080,%ecx
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  802f70:	ba cd ff ff ff       	mov    $0xffffffcd,%edx
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  802f75:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802f78:	0f b6 18             	movzbl (%eax),%ebx
  802f7b:	be 00 00 00 00       	mov    $0x0,%esi
  802f80:	89 f0                	mov    %esi,%eax
  802f82:	89 ce                	mov    %ecx,%esi
  802f84:	89 c1                	mov    %eax,%ecx
  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
    i = 0;
    do {
      rem = *ap % (u8_t)10;
  802f86:	89 d8                	mov    %ebx,%eax
  802f88:	f6 e2                	mul    %dl
  802f8a:	66 c1 e8 08          	shr    $0x8,%ax
  802f8e:	c0 e8 03             	shr    $0x3,%al
  802f91:	89 c7                	mov    %eax,%edi
  802f93:	8d 04 80             	lea    (%eax,%eax,4),%eax
  802f96:	01 c0                	add    %eax,%eax
  802f98:	28 c3                	sub    %al,%bl
  802f9a:	89 d8                	mov    %ebx,%eax
      *ap /= (u8_t)10;
  802f9c:	89 fb                	mov    %edi,%ebx
      inv[i++] = '0' + rem;
  802f9e:	0f b6 f9             	movzbl %cl,%edi
  802fa1:	83 c0 30             	add    $0x30,%eax
  802fa4:	88 44 3d ed          	mov    %al,-0x13(%ebp,%edi,1)
  802fa8:	83 c1 01             	add    $0x1,%ecx
    } while(*ap);
  802fab:	84 db                	test   %bl,%bl
  802fad:	75 d7                	jne    802f86 <inet_ntoa+0x36>
  802faf:	89 c8                	mov    %ecx,%eax
  802fb1:	89 f1                	mov    %esi,%ecx
  802fb3:	89 c6                	mov    %eax,%esi
  802fb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802fb8:	88 18                	mov    %bl,(%eax)
    while(i--)
  802fba:	89 f0                	mov    %esi,%eax
  802fbc:	84 c0                	test   %al,%al
  802fbe:	74 2c                	je     802fec <inet_ntoa+0x9c>
  802fc0:	8d 5e ff             	lea    -0x1(%esi),%ebx
 * @param addr ip address in network order to convert
 * @return pointer to a global static (!) buffer that holds the ASCII
 *         represenation of addr
 */
char *
inet_ntoa(struct in_addr addr)
  802fc3:	0f b6 c3             	movzbl %bl,%eax
  802fc6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802fc9:	8d 7c 01 01          	lea    0x1(%ecx,%eax,1),%edi
  802fcd:	89 c8                	mov    %ecx,%eax
  802fcf:	89 ce                	mov    %ecx,%esi
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
  802fd1:	0f b6 cb             	movzbl %bl,%ecx
  802fd4:	0f b6 4c 0d ed       	movzbl -0x13(%ebp,%ecx,1),%ecx
  802fd9:	88 08                	mov    %cl,(%eax)
  802fdb:	83 c0 01             	add    $0x1,%eax
    do {
      rem = *ap % (u8_t)10;
      *ap /= (u8_t)10;
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
  802fde:	83 eb 01             	sub    $0x1,%ebx
  802fe1:	39 f8                	cmp    %edi,%eax
  802fe3:	75 ec                	jne    802fd1 <inet_ntoa+0x81>
  802fe5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802fe8:	8d 4c 06 01          	lea    0x1(%esi,%eax,1),%ecx
      *rp++ = inv[i];
    *rp++ = '.';
  802fec:	c6 01 2e             	movb   $0x2e,(%ecx)
  802fef:	83 c1 01             	add    $0x1,%ecx
  u8_t n;
  u8_t i;

  rp = str;
  ap = (u8_t *)&s_addr;
  for(n = 0; n < 4; n++) {
  802ff2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802ff5:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  802ff8:	74 09                	je     803003 <inet_ntoa+0xb3>
      inv[i++] = '0' + rem;
    } while(*ap);
    while(i--)
      *rp++ = inv[i];
    *rp++ = '.';
    ap++;
  802ffa:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  802ffe:	e9 72 ff ff ff       	jmp    802f75 <inet_ntoa+0x25>
  }
  *--rp = 0;
  803003:	c6 41 ff 00          	movb   $0x0,-0x1(%ecx)
  return str;
}
  803007:	b8 80 70 80 00       	mov    $0x807080,%eax
  80300c:	83 c4 1c             	add    $0x1c,%esp
  80300f:	5b                   	pop    %ebx
  803010:	5e                   	pop    %esi
  803011:	5f                   	pop    %edi
  803012:	5d                   	pop    %ebp
  803013:	c3                   	ret    

00803014 <htons>:
 * @param n u16_t in host byte order
 * @return n in network byte order
 */
u16_t
htons(u16_t n)
{
  803014:	55                   	push   %ebp
  803015:	89 e5                	mov    %esp,%ebp
  803017:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80301b:	66 c1 c0 08          	rol    $0x8,%ax
  return ((n & 0xff) << 8) | ((n & 0xff00) >> 8);
}
  80301f:	5d                   	pop    %ebp
  803020:	c3                   	ret    

00803021 <ntohs>:
 * @param n u16_t in network byte order
 * @return n in host byte order
 */
u16_t
ntohs(u16_t n)
{
  803021:	55                   	push   %ebp
  803022:	89 e5                	mov    %esp,%ebp
  803024:	83 ec 04             	sub    $0x4,%esp
  return htons(n);
  803027:	0f b7 45 08          	movzwl 0x8(%ebp),%eax
  80302b:	89 04 24             	mov    %eax,(%esp)
  80302e:	e8 e1 ff ff ff       	call   803014 <htons>
}
  803033:	c9                   	leave  
  803034:	c3                   	ret    

00803035 <htonl>:
 * @param n u32_t in host byte order
 * @return n in network byte order
 */
u32_t
htonl(u32_t n)
{
  803035:	55                   	push   %ebp
  803036:	89 e5                	mov    %esp,%ebp
  803038:	8b 55 08             	mov    0x8(%ebp),%edx
  80303b:	89 d1                	mov    %edx,%ecx
  80303d:	c1 e9 18             	shr    $0x18,%ecx
  803040:	89 d0                	mov    %edx,%eax
  803042:	c1 e0 18             	shl    $0x18,%eax
  803045:	09 c8                	or     %ecx,%eax
  803047:	89 d1                	mov    %edx,%ecx
  803049:	81 e1 00 ff 00 00    	and    $0xff00,%ecx
  80304f:	c1 e1 08             	shl    $0x8,%ecx
  803052:	09 c8                	or     %ecx,%eax
  803054:	81 e2 00 00 ff 00    	and    $0xff0000,%edx
  80305a:	c1 ea 08             	shr    $0x8,%edx
  80305d:	09 d0                	or     %edx,%eax
  return ((n & 0xff) << 24) |
    ((n & 0xff00) << 8) |
    ((n & 0xff0000UL) >> 8) |
    ((n & 0xff000000UL) >> 24);
}
  80305f:	5d                   	pop    %ebp
  803060:	c3                   	ret    

00803061 <inet_aton>:
 * @param addr pointer to which to save the ip address in network order
 * @return 1 if cp could be converted to addr, 0 on failure
 */
int
inet_aton(const char *cp, struct in_addr *addr)
{
  803061:	55                   	push   %ebp
  803062:	89 e5                	mov    %esp,%ebp
  803064:	57                   	push   %edi
  803065:	56                   	push   %esi
  803066:	53                   	push   %ebx
  803067:	83 ec 28             	sub    $0x28,%esp
  80306a:	8b 45 08             	mov    0x8(%ebp),%eax
  u32_t val;
  int base, n, c;
  u32_t parts[4];
  u32_t *pp = parts;

  c = *cp;
  80306d:	0f be 10             	movsbl (%eax),%edx
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  803070:	8d 4a d0             	lea    -0x30(%edx),%ecx
  803073:	80 f9 09             	cmp    $0x9,%cl
  803076:	0f 87 af 01 00 00    	ja     80322b <inet_aton+0x1ca>
  80307c:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  80307f:	89 4d d8             	mov    %ecx,-0x28(%ebp)
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  803082:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  803085:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
     */
    if (!isdigit(c))
      return (0);
    val = 0;
    base = 10;
    if (c == '0') {
  803088:	c7 45 e0 0a 00 00 00 	movl   $0xa,-0x20(%ebp)
  80308f:	83 fa 30             	cmp    $0x30,%edx
  803092:	75 24                	jne    8030b8 <inet_aton+0x57>
      c = *++cp;
  803094:	83 c0 01             	add    $0x1,%eax
  803097:	0f be 10             	movsbl (%eax),%edx
      if (c == 'x' || c == 'X') {
  80309a:	83 fa 78             	cmp    $0x78,%edx
  80309d:	74 0c                	je     8030ab <inet_aton+0x4a>
  80309f:	c7 45 e0 08 00 00 00 	movl   $0x8,-0x20(%ebp)
  8030a6:	83 fa 58             	cmp    $0x58,%edx
  8030a9:	75 0d                	jne    8030b8 <inet_aton+0x57>
        base = 16;
        c = *++cp;
  8030ab:	83 c0 01             	add    $0x1,%eax
  8030ae:	0f be 10             	movsbl (%eax),%edx
  8030b1:	c7 45 e0 10 00 00 00 	movl   $0x10,-0x20(%ebp)
  8030b8:	83 c0 01             	add    $0x1,%eax
  8030bb:	be 00 00 00 00       	mov    $0x0,%esi
  8030c0:	eb 03                	jmp    8030c5 <inet_aton+0x64>
  8030c2:	83 c0 01             	add    $0x1,%eax
  8030c5:	8d 78 ff             	lea    -0x1(%eax),%edi
      } else
        base = 8;
    }
    for (;;) {
      if (isdigit(c)) {
  8030c8:	89 d1                	mov    %edx,%ecx
  8030ca:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  8030cd:	80 fb 09             	cmp    $0x9,%bl
  8030d0:	77 0d                	ja     8030df <inet_aton+0x7e>
        val = (val * base) + (int)(c - '0');
  8030d2:	0f af 75 e0          	imul   -0x20(%ebp),%esi
  8030d6:	8d 74 32 d0          	lea    -0x30(%edx,%esi,1),%esi
        c = *++cp;
  8030da:	0f be 10             	movsbl (%eax),%edx
  8030dd:	eb e3                	jmp    8030c2 <inet_aton+0x61>
      } else if (base == 16 && isxdigit(c)) {
  8030df:	83 7d e0 10          	cmpl   $0x10,-0x20(%ebp)
  8030e3:	75 2b                	jne    803110 <inet_aton+0xaf>
  8030e5:	8d 59 9f             	lea    -0x61(%ecx),%ebx
  8030e8:	88 5d d3             	mov    %bl,-0x2d(%ebp)
  8030eb:	80 fb 05             	cmp    $0x5,%bl
  8030ee:	76 08                	jbe    8030f8 <inet_aton+0x97>
  8030f0:	8d 59 bf             	lea    -0x41(%ecx),%ebx
  8030f3:	80 fb 05             	cmp    $0x5,%bl
  8030f6:	77 18                	ja     803110 <inet_aton+0xaf>
        val = (val << 4) | (int)(c + 10 - (islower(c) ? 'a' : 'A'));
  8030f8:	80 7d d3 1a          	cmpb   $0x1a,-0x2d(%ebp)
  8030fc:	19 c9                	sbb    %ecx,%ecx
  8030fe:	83 e1 20             	and    $0x20,%ecx
  803101:	c1 e6 04             	shl    $0x4,%esi
  803104:	29 ca                	sub    %ecx,%edx
  803106:	8d 52 c9             	lea    -0x37(%edx),%edx
  803109:	09 d6                	or     %edx,%esi
        c = *++cp;
  80310b:	0f be 10             	movsbl (%eax),%edx
  80310e:	eb b2                	jmp    8030c2 <inet_aton+0x61>
      } else
        break;
    }
    if (c == '.') {
  803110:	83 fa 2e             	cmp    $0x2e,%edx
  803113:	75 2c                	jne    803141 <inet_aton+0xe0>
       * Internet format:
       *  a.b.c.d
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
  803115:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  803118:	39 55 d8             	cmp    %edx,-0x28(%ebp)
  80311b:	0f 83 0a 01 00 00    	jae    80322b <inet_aton+0x1ca>
        return (0);
      *pp++ = val;
  803121:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  803124:	89 31                	mov    %esi,(%ecx)
      c = *++cp;
  803126:	8d 47 01             	lea    0x1(%edi),%eax
  803129:	0f be 10             	movsbl (%eax),%edx
    /*
     * Collect number up to ``.''.
     * Values are specified as for C:
     * 0x=hex, 0=octal, 1-9=decimal.
     */
    if (!isdigit(c))
  80312c:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80312f:	80 f9 09             	cmp    $0x9,%cl
  803132:	0f 87 f3 00 00 00    	ja     80322b <inet_aton+0x1ca>
       *  a.b.c   (with c treated as 16 bits)
       *  a.b (with b treated as 24 bits)
       */
      if (pp >= parts + 3)
        return (0);
      *pp++ = val;
  803138:	83 45 d8 04          	addl   $0x4,-0x28(%ebp)
  80313c:	e9 47 ff ff ff       	jmp    803088 <inet_aton+0x27>
  803141:	89 f3                	mov    %esi,%ebx
  803143:	89 f0                	mov    %esi,%eax
      break;
  }
  /*
   * Check for trailing characters.
   */
  if (c != '\0' && (!isprint(c) || !isspace(c)))
  803145:	85 d2                	test   %edx,%edx
  803147:	74 37                	je     803180 <inet_aton+0x11f>
  803149:	80 f9 1f             	cmp    $0x1f,%cl
  80314c:	0f 86 d9 00 00 00    	jbe    80322b <inet_aton+0x1ca>
  803152:	84 d2                	test   %dl,%dl
  803154:	0f 88 d1 00 00 00    	js     80322b <inet_aton+0x1ca>
  80315a:	83 fa 20             	cmp    $0x20,%edx
  80315d:	8d 76 00             	lea    0x0(%esi),%esi
  803160:	74 1e                	je     803180 <inet_aton+0x11f>
  803162:	83 fa 0c             	cmp    $0xc,%edx
  803165:	74 19                	je     803180 <inet_aton+0x11f>
  803167:	83 fa 0a             	cmp    $0xa,%edx
  80316a:	74 14                	je     803180 <inet_aton+0x11f>
  80316c:	83 fa 0d             	cmp    $0xd,%edx
  80316f:	90                   	nop
  803170:	74 0e                	je     803180 <inet_aton+0x11f>
  803172:	83 fa 09             	cmp    $0x9,%edx
  803175:	74 09                	je     803180 <inet_aton+0x11f>
  803177:	83 fa 0b             	cmp    $0xb,%edx
  80317a:	0f 85 ab 00 00 00    	jne    80322b <inet_aton+0x1ca>
  /*
   * Concoct the address according to
   * the number of parts specified.
   */
  n = pp - parts + 1;
  switch (n) {
  803180:	8d 55 e4             	lea    -0x1c(%ebp),%edx
  803183:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  803186:	29 d1                	sub    %edx,%ecx
  803188:	89 ca                	mov    %ecx,%edx
  80318a:	c1 fa 02             	sar    $0x2,%edx
  80318d:	83 c2 01             	add    $0x1,%edx
  803190:	83 fa 02             	cmp    $0x2,%edx
  803193:	74 2d                	je     8031c2 <inet_aton+0x161>
  803195:	83 fa 02             	cmp    $0x2,%edx
  803198:	7f 10                	jg     8031aa <inet_aton+0x149>
  80319a:	85 d2                	test   %edx,%edx
  80319c:	0f 84 89 00 00 00    	je     80322b <inet_aton+0x1ca>
  8031a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8031a8:	eb 62                	jmp    80320c <inet_aton+0x1ab>
  8031aa:	83 fa 03             	cmp    $0x3,%edx
  8031ad:	8d 76 00             	lea    0x0(%esi),%esi
  8031b0:	74 22                	je     8031d4 <inet_aton+0x173>
  8031b2:	83 fa 04             	cmp    $0x4,%edx
  8031b5:	8d 76 00             	lea    0x0(%esi),%esi
  8031b8:	75 52                	jne    80320c <inet_aton+0x1ab>
  8031ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8031c0:	eb 2b                	jmp    8031ed <inet_aton+0x18c>

  case 1:             /* a -- 32 bits */
    break;

  case 2:             /* a.b -- 8.24 bits */
    if (val > 0xffffffUL)
  8031c2:	3d ff ff ff 00       	cmp    $0xffffff,%eax
  8031c7:	90                   	nop
  8031c8:	77 61                	ja     80322b <inet_aton+0x1ca>
      return (0);
    val |= parts[0] << 24;
  8031ca:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  8031cd:	c1 e3 18             	shl    $0x18,%ebx
  8031d0:	09 c3                	or     %eax,%ebx
    break;
  8031d2:	eb 38                	jmp    80320c <inet_aton+0x1ab>

  case 3:             /* a.b.c -- 8.8.16 bits */
    if (val > 0xffff)
  8031d4:	3d ff ff 00 00       	cmp    $0xffff,%eax
  8031d9:	77 50                	ja     80322b <inet_aton+0x1ca>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16);
  8031db:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8031de:	c1 e3 10             	shl    $0x10,%ebx
  8031e1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031e4:	c1 e2 18             	shl    $0x18,%edx
  8031e7:	09 d3                	or     %edx,%ebx
  8031e9:	09 c3                	or     %eax,%ebx
    break;
  8031eb:	eb 1f                	jmp    80320c <inet_aton+0x1ab>

  case 4:             /* a.b.c.d -- 8.8.8.8 bits */
    if (val > 0xff)
  8031ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8031f2:	77 37                	ja     80322b <inet_aton+0x1ca>
      return (0);
    val |= (parts[0] << 24) | (parts[1] << 16) | (parts[2] << 8);
  8031f4:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8031f7:	c1 e3 10             	shl    $0x10,%ebx
  8031fa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8031fd:	c1 e2 18             	shl    $0x18,%edx
  803200:	09 d3                	or     %edx,%ebx
  803202:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803205:	c1 e2 08             	shl    $0x8,%edx
  803208:	09 d3                	or     %edx,%ebx
  80320a:	09 c3                	or     %eax,%ebx
    break;
  }
  if (addr)
  80320c:	b8 01 00 00 00       	mov    $0x1,%eax
  803211:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  803215:	74 19                	je     803230 <inet_aton+0x1cf>
    addr->s_addr = htonl(val);
  803217:	89 1c 24             	mov    %ebx,(%esp)
  80321a:	e8 16 fe ff ff       	call   803035 <htonl>
  80321f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  803222:	89 03                	mov    %eax,(%ebx)
  803224:	b8 01 00 00 00       	mov    $0x1,%eax
  803229:	eb 05                	jmp    803230 <inet_aton+0x1cf>
  80322b:	b8 00 00 00 00       	mov    $0x0,%eax
  return (1);
}
  803230:	83 c4 28             	add    $0x28,%esp
  803233:	5b                   	pop    %ebx
  803234:	5e                   	pop    %esi
  803235:	5f                   	pop    %edi
  803236:	5d                   	pop    %ebp
  803237:	c3                   	ret    

00803238 <inet_addr>:
 * @param cp IP address in ascii represenation (e.g. "127.0.0.1")
 * @return ip address in network order
 */
u32_t
inet_addr(const char *cp)
{
  803238:	55                   	push   %ebp
  803239:	89 e5                	mov    %esp,%ebp
  80323b:	83 ec 18             	sub    $0x18,%esp
  struct in_addr val;

  if (inet_aton(cp, &val)) {
  80323e:	8d 45 fc             	lea    -0x4(%ebp),%eax
  803241:	89 44 24 04          	mov    %eax,0x4(%esp)
  803245:	8b 45 08             	mov    0x8(%ebp),%eax
  803248:	89 04 24             	mov    %eax,(%esp)
  80324b:	e8 11 fe ff ff       	call   803061 <inet_aton>
  803250:	83 f8 01             	cmp    $0x1,%eax
  803253:	19 c0                	sbb    %eax,%eax
  803255:	0b 45 fc             	or     -0x4(%ebp),%eax
    return (val.s_addr);
  }
  return (INADDR_NONE);
}
  803258:	c9                   	leave  
  803259:	c3                   	ret    

0080325a <ntohl>:
 * @param n u32_t in network byte order
 * @return n in host byte order
 */
u32_t
ntohl(u32_t n)
{
  80325a:	55                   	push   %ebp
  80325b:	89 e5                	mov    %esp,%ebp
  80325d:	83 ec 04             	sub    $0x4,%esp
  return htonl(n);
  803260:	8b 45 08             	mov    0x8(%ebp),%eax
  803263:	89 04 24             	mov    %eax,(%esp)
  803266:	e8 ca fd ff ff       	call   803035 <htonl>
}
  80326b:	c9                   	leave  
  80326c:	c3                   	ret    
  80326d:	00 00                	add    %al,(%eax)
	...

00803270 <__udivdi3>:
  803270:	55                   	push   %ebp
  803271:	89 e5                	mov    %esp,%ebp
  803273:	57                   	push   %edi
  803274:	56                   	push   %esi
  803275:	83 ec 10             	sub    $0x10,%esp
  803278:	8b 45 14             	mov    0x14(%ebp),%eax
  80327b:	8b 55 08             	mov    0x8(%ebp),%edx
  80327e:	8b 75 10             	mov    0x10(%ebp),%esi
  803281:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803284:	85 c0                	test   %eax,%eax
  803286:	89 55 f0             	mov    %edx,-0x10(%ebp)
  803289:	75 35                	jne    8032c0 <__udivdi3+0x50>
  80328b:	39 fe                	cmp    %edi,%esi
  80328d:	77 61                	ja     8032f0 <__udivdi3+0x80>
  80328f:	85 f6                	test   %esi,%esi
  803291:	75 0b                	jne    80329e <__udivdi3+0x2e>
  803293:	b8 01 00 00 00       	mov    $0x1,%eax
  803298:	31 d2                	xor    %edx,%edx
  80329a:	f7 f6                	div    %esi
  80329c:	89 c6                	mov    %eax,%esi
  80329e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8032a1:	31 d2                	xor    %edx,%edx
  8032a3:	89 f8                	mov    %edi,%eax
  8032a5:	f7 f6                	div    %esi
  8032a7:	89 c7                	mov    %eax,%edi
  8032a9:	89 c8                	mov    %ecx,%eax
  8032ab:	f7 f6                	div    %esi
  8032ad:	89 c1                	mov    %eax,%ecx
  8032af:	89 fa                	mov    %edi,%edx
  8032b1:	89 c8                	mov    %ecx,%eax
  8032b3:	83 c4 10             	add    $0x10,%esp
  8032b6:	5e                   	pop    %esi
  8032b7:	5f                   	pop    %edi
  8032b8:	5d                   	pop    %ebp
  8032b9:	c3                   	ret    
  8032ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8032c0:	39 f8                	cmp    %edi,%eax
  8032c2:	77 1c                	ja     8032e0 <__udivdi3+0x70>
  8032c4:	0f bd d0             	bsr    %eax,%edx
  8032c7:	83 f2 1f             	xor    $0x1f,%edx
  8032ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8032cd:	75 39                	jne    803308 <__udivdi3+0x98>
  8032cf:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8032d2:	0f 86 a0 00 00 00    	jbe    803378 <__udivdi3+0x108>
  8032d8:	39 f8                	cmp    %edi,%eax
  8032da:	0f 82 98 00 00 00    	jb     803378 <__udivdi3+0x108>
  8032e0:	31 ff                	xor    %edi,%edi
  8032e2:	31 c9                	xor    %ecx,%ecx
  8032e4:	89 c8                	mov    %ecx,%eax
  8032e6:	89 fa                	mov    %edi,%edx
  8032e8:	83 c4 10             	add    $0x10,%esp
  8032eb:	5e                   	pop    %esi
  8032ec:	5f                   	pop    %edi
  8032ed:	5d                   	pop    %ebp
  8032ee:	c3                   	ret    
  8032ef:	90                   	nop
  8032f0:	89 d1                	mov    %edx,%ecx
  8032f2:	89 fa                	mov    %edi,%edx
  8032f4:	89 c8                	mov    %ecx,%eax
  8032f6:	31 ff                	xor    %edi,%edi
  8032f8:	f7 f6                	div    %esi
  8032fa:	89 c1                	mov    %eax,%ecx
  8032fc:	89 fa                	mov    %edi,%edx
  8032fe:	89 c8                	mov    %ecx,%eax
  803300:	83 c4 10             	add    $0x10,%esp
  803303:	5e                   	pop    %esi
  803304:	5f                   	pop    %edi
  803305:	5d                   	pop    %ebp
  803306:	c3                   	ret    
  803307:	90                   	nop
  803308:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80330c:	89 f2                	mov    %esi,%edx
  80330e:	d3 e0                	shl    %cl,%eax
  803310:	89 45 ec             	mov    %eax,-0x14(%ebp)
  803313:	b8 20 00 00 00       	mov    $0x20,%eax
  803318:	2b 45 f4             	sub    -0xc(%ebp),%eax
  80331b:	89 c1                	mov    %eax,%ecx
  80331d:	d3 ea                	shr    %cl,%edx
  80331f:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803323:	0b 55 ec             	or     -0x14(%ebp),%edx
  803326:	d3 e6                	shl    %cl,%esi
  803328:	89 c1                	mov    %eax,%ecx
  80332a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80332d:	89 fe                	mov    %edi,%esi
  80332f:	d3 ee                	shr    %cl,%esi
  803331:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  803335:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803338:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80333b:	d3 e7                	shl    %cl,%edi
  80333d:	89 c1                	mov    %eax,%ecx
  80333f:	d3 ea                	shr    %cl,%edx
  803341:	09 d7                	or     %edx,%edi
  803343:	89 f2                	mov    %esi,%edx
  803345:	89 f8                	mov    %edi,%eax
  803347:	f7 75 ec             	divl   -0x14(%ebp)
  80334a:	89 d6                	mov    %edx,%esi
  80334c:	89 c7                	mov    %eax,%edi
  80334e:	f7 65 e8             	mull   -0x18(%ebp)
  803351:	39 d6                	cmp    %edx,%esi
  803353:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803356:	72 30                	jb     803388 <__udivdi3+0x118>
  803358:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80335b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80335f:	d3 e2                	shl    %cl,%edx
  803361:	39 c2                	cmp    %eax,%edx
  803363:	73 05                	jae    80336a <__udivdi3+0xfa>
  803365:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  803368:	74 1e                	je     803388 <__udivdi3+0x118>
  80336a:	89 f9                	mov    %edi,%ecx
  80336c:	31 ff                	xor    %edi,%edi
  80336e:	e9 71 ff ff ff       	jmp    8032e4 <__udivdi3+0x74>
  803373:	90                   	nop
  803374:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803378:	31 ff                	xor    %edi,%edi
  80337a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80337f:	e9 60 ff ff ff       	jmp    8032e4 <__udivdi3+0x74>
  803384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803388:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80338b:	31 ff                	xor    %edi,%edi
  80338d:	89 c8                	mov    %ecx,%eax
  80338f:	89 fa                	mov    %edi,%edx
  803391:	83 c4 10             	add    $0x10,%esp
  803394:	5e                   	pop    %esi
  803395:	5f                   	pop    %edi
  803396:	5d                   	pop    %ebp
  803397:	c3                   	ret    
	...

008033a0 <__umoddi3>:
  8033a0:	55                   	push   %ebp
  8033a1:	89 e5                	mov    %esp,%ebp
  8033a3:	57                   	push   %edi
  8033a4:	56                   	push   %esi
  8033a5:	83 ec 20             	sub    $0x20,%esp
  8033a8:	8b 55 14             	mov    0x14(%ebp),%edx
  8033ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8033ae:	8b 7d 10             	mov    0x10(%ebp),%edi
  8033b1:	8b 75 0c             	mov    0xc(%ebp),%esi
  8033b4:	85 d2                	test   %edx,%edx
  8033b6:	89 c8                	mov    %ecx,%eax
  8033b8:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  8033bb:	75 13                	jne    8033d0 <__umoddi3+0x30>
  8033bd:	39 f7                	cmp    %esi,%edi
  8033bf:	76 3f                	jbe    803400 <__umoddi3+0x60>
  8033c1:	89 f2                	mov    %esi,%edx
  8033c3:	f7 f7                	div    %edi
  8033c5:	89 d0                	mov    %edx,%eax
  8033c7:	31 d2                	xor    %edx,%edx
  8033c9:	83 c4 20             	add    $0x20,%esp
  8033cc:	5e                   	pop    %esi
  8033cd:	5f                   	pop    %edi
  8033ce:	5d                   	pop    %ebp
  8033cf:	c3                   	ret    
  8033d0:	39 f2                	cmp    %esi,%edx
  8033d2:	77 4c                	ja     803420 <__umoddi3+0x80>
  8033d4:	0f bd ca             	bsr    %edx,%ecx
  8033d7:	83 f1 1f             	xor    $0x1f,%ecx
  8033da:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8033dd:	75 51                	jne    803430 <__umoddi3+0x90>
  8033df:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8033e2:	0f 87 e0 00 00 00    	ja     8034c8 <__umoddi3+0x128>
  8033e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033eb:	29 f8                	sub    %edi,%eax
  8033ed:	19 d6                	sbb    %edx,%esi
  8033ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8033f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f5:	89 f2                	mov    %esi,%edx
  8033f7:	83 c4 20             	add    $0x20,%esp
  8033fa:	5e                   	pop    %esi
  8033fb:	5f                   	pop    %edi
  8033fc:	5d                   	pop    %ebp
  8033fd:	c3                   	ret    
  8033fe:	66 90                	xchg   %ax,%ax
  803400:	85 ff                	test   %edi,%edi
  803402:	75 0b                	jne    80340f <__umoddi3+0x6f>
  803404:	b8 01 00 00 00       	mov    $0x1,%eax
  803409:	31 d2                	xor    %edx,%edx
  80340b:	f7 f7                	div    %edi
  80340d:	89 c7                	mov    %eax,%edi
  80340f:	89 f0                	mov    %esi,%eax
  803411:	31 d2                	xor    %edx,%edx
  803413:	f7 f7                	div    %edi
  803415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803418:	f7 f7                	div    %edi
  80341a:	eb a9                	jmp    8033c5 <__umoddi3+0x25>
  80341c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803420:	89 c8                	mov    %ecx,%eax
  803422:	89 f2                	mov    %esi,%edx
  803424:	83 c4 20             	add    $0x20,%esp
  803427:	5e                   	pop    %esi
  803428:	5f                   	pop    %edi
  803429:	5d                   	pop    %ebp
  80342a:	c3                   	ret    
  80342b:	90                   	nop
  80342c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  803430:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803434:	d3 e2                	shl    %cl,%edx
  803436:	89 55 f4             	mov    %edx,-0xc(%ebp)
  803439:	ba 20 00 00 00       	mov    $0x20,%edx
  80343e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  803441:	89 55 ec             	mov    %edx,-0x14(%ebp)
  803444:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803448:	89 fa                	mov    %edi,%edx
  80344a:	d3 ea                	shr    %cl,%edx
  80344c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803450:	0b 55 f4             	or     -0xc(%ebp),%edx
  803453:	d3 e7                	shl    %cl,%edi
  803455:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803459:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80345c:	89 f2                	mov    %esi,%edx
  80345e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  803461:	89 c7                	mov    %eax,%edi
  803463:	d3 ea                	shr    %cl,%edx
  803465:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803469:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80346c:	89 c2                	mov    %eax,%edx
  80346e:	d3 e6                	shl    %cl,%esi
  803470:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  803474:	d3 ea                	shr    %cl,%edx
  803476:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80347a:	09 d6                	or     %edx,%esi
  80347c:	89 f0                	mov    %esi,%eax
  80347e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  803481:	d3 e7                	shl    %cl,%edi
  803483:	89 f2                	mov    %esi,%edx
  803485:	f7 75 f4             	divl   -0xc(%ebp)
  803488:	89 d6                	mov    %edx,%esi
  80348a:	f7 65 e8             	mull   -0x18(%ebp)
  80348d:	39 d6                	cmp    %edx,%esi
  80348f:	72 2b                	jb     8034bc <__umoddi3+0x11c>
  803491:	39 c7                	cmp    %eax,%edi
  803493:	72 23                	jb     8034b8 <__umoddi3+0x118>
  803495:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  803499:	29 c7                	sub    %eax,%edi
  80349b:	19 d6                	sbb    %edx,%esi
  80349d:	89 f0                	mov    %esi,%eax
  80349f:	89 f2                	mov    %esi,%edx
  8034a1:	d3 ef                	shr    %cl,%edi
  8034a3:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  8034a7:	d3 e0                	shl    %cl,%eax
  8034a9:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  8034ad:	09 f8                	or     %edi,%eax
  8034af:	d3 ea                	shr    %cl,%edx
  8034b1:	83 c4 20             	add    $0x20,%esp
  8034b4:	5e                   	pop    %esi
  8034b5:	5f                   	pop    %edi
  8034b6:	5d                   	pop    %ebp
  8034b7:	c3                   	ret    
  8034b8:	39 d6                	cmp    %edx,%esi
  8034ba:	75 d9                	jne    803495 <__umoddi3+0xf5>
  8034bc:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8034bf:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8034c2:	eb d1                	jmp    803495 <__umoddi3+0xf5>
  8034c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8034c8:	39 f2                	cmp    %esi,%edx
  8034ca:	0f 82 18 ff ff ff    	jb     8033e8 <__umoddi3+0x48>
  8034d0:	e9 1d ff ff ff       	jmp    8033f2 <__umoddi3+0x52>
