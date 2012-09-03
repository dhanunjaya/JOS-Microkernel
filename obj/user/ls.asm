
obj/user/ls:     file format elf32-i386


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
  80002c:	e8 6b 03 00 00       	call   80039c <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <usage>:
	printf("\n");
}

void
usage(void)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	83 ec 18             	sub    $0x18,%esp
	printf("usage: ls [-dFl] [file...]\n");
  800046:	c7 04 24 80 2c 80 00 	movl   $0x802c80,(%esp)
  80004d:	e8 c5 1d 00 00       	call   801e17 <printf>
	exit();
  800052:	e8 95 03 00 00       	call   8003ec <exit>
}
  800057:	c9                   	leave  
  800058:	c3                   	ret    

00800059 <ls1>:
		panic("error reading directory %s: %e", path, n);
}

void
ls1(const char *prefix, bool isdir, off_t size, const char *name)
{
  800059:	55                   	push   %ebp
  80005a:	89 e5                	mov    %esp,%ebp
  80005c:	56                   	push   %esi
  80005d:	53                   	push   %ebx
  80005e:	83 ec 10             	sub    $0x10,%esp
  800061:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800064:	8b 75 0c             	mov    0xc(%ebp),%esi
	char *sep;

	if(flag['l'])
  800067:	83 3d 30 72 80 00 00 	cmpl   $0x0,0x807230
  80006e:	74 22                	je     800092 <ls1+0x39>
		printf("%11d %c ", size, isdir ? 'd' : '-');
  800070:	83 fe 01             	cmp    $0x1,%esi
  800073:	19 c0                	sbb    %eax,%eax
  800075:	83 e0 c9             	and    $0xffffffc9,%eax
  800078:	83 c0 64             	add    $0x64,%eax
  80007b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80007f:	8b 45 10             	mov    0x10(%ebp),%eax
  800082:	89 44 24 04          	mov    %eax,0x4(%esp)
  800086:	c7 04 24 9c 2c 80 00 	movl   $0x802c9c,(%esp)
  80008d:	e8 85 1d 00 00       	call   801e17 <printf>
	if(prefix) {
  800092:	85 db                	test   %ebx,%ebx
  800094:	74 34                	je     8000ca <ls1+0x71>
		if (prefix[0] && prefix[strlen(prefix)-1] != '/')
  800096:	80 3b 00             	cmpb   $0x0,(%ebx)
  800099:	74 16                	je     8000b1 <ls1+0x58>
  80009b:	89 1c 24             	mov    %ebx,(%esp)
  80009e:	66 90                	xchg   %ax,%ax
  8000a0:	e8 bb 0a 00 00       	call   800b60 <strlen>
  8000a5:	ba a5 2c 80 00       	mov    $0x802ca5,%edx
  8000aa:	80 7c 03 ff 2f       	cmpb   $0x2f,-0x1(%ebx,%eax,1)
  8000af:	75 05                	jne    8000b6 <ls1+0x5d>
  8000b1:	ba 9b 2c 80 00       	mov    $0x802c9b,%edx
			sep = "/";
		else
			sep = "";
		printf("%s%s", prefix, sep);
  8000b6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8000ba:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8000be:	c7 04 24 a7 2c 80 00 	movl   $0x802ca7,(%esp)
  8000c5:	e8 4d 1d 00 00       	call   801e17 <printf>
	}
	printf("%s", name);
  8000ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8000cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000d1:	c7 04 24 2d 31 80 00 	movl   $0x80312d,(%esp)
  8000d8:	e8 3a 1d 00 00       	call   801e17 <printf>
	if(flag['F'] && isdir)
  8000dd:	83 3d 98 71 80 00 00 	cmpl   $0x0,0x807198
  8000e4:	74 10                	je     8000f6 <ls1+0x9d>
  8000e6:	85 f6                	test   %esi,%esi
  8000e8:	74 0c                	je     8000f6 <ls1+0x9d>
		printf("/");
  8000ea:	c7 04 24 a5 2c 80 00 	movl   $0x802ca5,(%esp)
  8000f1:	e8 21 1d 00 00       	call   801e17 <printf>
	printf("\n");
  8000f6:	c7 04 24 9a 2c 80 00 	movl   $0x802c9a,(%esp)
  8000fd:	e8 15 1d 00 00       	call   801e17 <printf>
}
  800102:	83 c4 10             	add    $0x10,%esp
  800105:	5b                   	pop    %ebx
  800106:	5e                   	pop    %esi
  800107:	5d                   	pop    %ebp
  800108:	c3                   	ret    

00800109 <lsdir>:
		ls1(0, st.st_isdir, st.st_size, path);
}

void
lsdir(const char *path, const char *prefix)
{
  800109:	55                   	push   %ebp
  80010a:	89 e5                	mov    %esp,%ebp
  80010c:	57                   	push   %edi
  80010d:	56                   	push   %esi
  80010e:	53                   	push   %ebx
  80010f:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  800115:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
  800118:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80011f:	00 
  800120:	8b 45 08             	mov    0x8(%ebp),%eax
  800123:	89 04 24             	mov    %eax,(%esp)
  800126:	e8 5c 1b 00 00       	call   801c87 <open>
  80012b:	89 c6                	mov    %eax,%esi
  80012d:	85 c0                	test   %eax,%eax
  80012f:	79 59                	jns    80018a <lsdir+0x81>
		panic("open %s: %e", path, fd);
  800131:	89 44 24 10          	mov    %eax,0x10(%esp)
  800135:	8b 45 08             	mov    0x8(%ebp),%eax
  800138:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80013c:	c7 44 24 08 ac 2c 80 	movl   $0x802cac,0x8(%esp)
  800143:	00 
  800144:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  80014b:	00 
  80014c:	c7 04 24 b8 2c 80 00 	movl   $0x802cb8,(%esp)
  800153:	e8 b0 02 00 00       	call   800408 <_panic>
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
		if (f.f_name[0])
  800158:	80 bd e8 fe ff ff 00 	cmpb   $0x0,-0x118(%ebp)
  80015f:	74 2f                	je     800190 <lsdir+0x87>
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
  800161:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800165:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
  80016b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80016f:	83 bd 6c ff ff ff 01 	cmpl   $0x1,-0x94(%ebp)
  800176:	0f 94 c0             	sete   %al
  800179:	0f b6 c0             	movzbl %al,%eax
  80017c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800180:	89 3c 24             	mov    %edi,(%esp)
  800183:	e8 d1 fe ff ff       	call   800059 <ls1>
  800188:	eb 06                	jmp    800190 <lsdir+0x87>
	int fd, n;
	struct File f;

	if ((fd = open(path, O_RDONLY)) < 0)
		panic("open %s: %e", path, fd);
	while ((n = readn(fd, &f, sizeof f)) == sizeof f)
  80018a:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
  800190:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  800197:	00 
  800198:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80019c:	89 34 24             	mov    %esi,(%esp)
  80019f:	e8 18 16 00 00       	call   8017bc <readn>
  8001a4:	3d 00 01 00 00       	cmp    $0x100,%eax
  8001a9:	74 ad                	je     800158 <lsdir+0x4f>
		if (f.f_name[0])
			ls1(prefix, f.f_type==FTYPE_DIR, f.f_size, f.f_name);
	if (n > 0)
  8001ab:	85 c0                	test   %eax,%eax
  8001ad:	7e 23                	jle    8001d2 <lsdir+0xc9>
		panic("short read in directory %s", path);
  8001af:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001b6:	c7 44 24 08 c2 2c 80 	movl   $0x802cc2,0x8(%esp)
  8001bd:	00 
  8001be:	c7 44 24 04 22 00 00 	movl   $0x22,0x4(%esp)
  8001c5:	00 
  8001c6:	c7 04 24 b8 2c 80 00 	movl   $0x802cb8,(%esp)
  8001cd:	e8 36 02 00 00       	call   800408 <_panic>
	if (n < 0)
  8001d2:	85 c0                	test   %eax,%eax
  8001d4:	79 27                	jns    8001fd <lsdir+0xf4>
		panic("error reading directory %s: %e", path, n);
  8001d6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8001da:	8b 45 08             	mov    0x8(%ebp),%eax
  8001dd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8001e1:	c7 44 24 08 ec 2c 80 	movl   $0x802cec,0x8(%esp)
  8001e8:	00 
  8001e9:	c7 44 24 04 24 00 00 	movl   $0x24,0x4(%esp)
  8001f0:	00 
  8001f1:	c7 04 24 b8 2c 80 00 	movl   $0x802cb8,(%esp)
  8001f8:	e8 0b 02 00 00       	call   800408 <_panic>
}
  8001fd:	81 c4 2c 01 00 00    	add    $0x12c,%esp
  800203:	5b                   	pop    %ebx
  800204:	5e                   	pop    %esi
  800205:	5f                   	pop    %edi
  800206:	5d                   	pop    %ebp
  800207:	c3                   	ret    

00800208 <ls>:
void lsdir(const char*, const char*);
void ls1(const char*, bool, off_t, const char*);

void
ls(const char *path, const char *prefix)
{
  800208:	55                   	push   %ebp
  800209:	89 e5                	mov    %esp,%ebp
  80020b:	53                   	push   %ebx
  80020c:	81 ec b4 00 00 00    	sub    $0xb4,%esp
  800212:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
  800215:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
  80021b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80021f:	89 1c 24             	mov    %ebx,(%esp)
  800222:	e8 98 16 00 00       	call   8018bf <stat>
  800227:	85 c0                	test   %eax,%eax
  800229:	79 24                	jns    80024f <ls+0x47>
		panic("stat %s: %e", path, r);
  80022b:	89 44 24 10          	mov    %eax,0x10(%esp)
  80022f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800233:	c7 44 24 08 dd 2c 80 	movl   $0x802cdd,0x8(%esp)
  80023a:	00 
  80023b:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
  800242:	00 
  800243:	c7 04 24 b8 2c 80 00 	movl   $0x802cb8,(%esp)
  80024a:	e8 b9 01 00 00       	call   800408 <_panic>
	if (st.st_isdir && !flag['d'])
  80024f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800252:	85 c0                	test   %eax,%eax
  800254:	74 1a                	je     800270 <ls+0x68>
  800256:	83 3d 10 72 80 00 00 	cmpl   $0x0,0x807210
  80025d:	75 11                	jne    800270 <ls+0x68>
		lsdir(path, prefix);
  80025f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800262:	89 44 24 04          	mov    %eax,0x4(%esp)
  800266:	89 1c 24             	mov    %ebx,(%esp)
  800269:	e8 9b fe ff ff       	call   800109 <lsdir>
	int r;
	struct Stat st;

	if ((r = stat(path, &st)) < 0)
		panic("stat %s: %e", path, r);
	if (st.st_isdir && !flag['d'])
  80026e:	eb 1b                	jmp    80028b <ls+0x83>
		lsdir(path, prefix);
	else
		ls1(0, st.st_isdir, st.st_size, path);
  800270:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800274:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800277:	89 54 24 08          	mov    %edx,0x8(%esp)
  80027b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80027f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800286:	e8 ce fd ff ff       	call   800059 <ls1>
}
  80028b:	81 c4 b4 00 00 00    	add    $0xb4,%esp
  800291:	5b                   	pop    %ebx
  800292:	5d                   	pop    %ebp
  800293:	c3                   	ret    

00800294 <umain>:
	exit();
}

void
umain(int argc, char **argv)
{
  800294:	55                   	push   %ebp
  800295:	89 e5                	mov    %esp,%ebp
  800297:	57                   	push   %edi
  800298:	56                   	push   %esi
  800299:	53                   	push   %ebx
  80029a:	83 ec 2c             	sub    $0x2c,%esp
  80029d:	8b 45 0c             	mov    0xc(%ebp),%eax
	int i;

	ARGBEGIN{
  8002a0:	85 c0                	test   %eax,%eax
  8002a2:	75 03                	jne    8002a7 <umain+0x13>
  8002a4:	8d 45 08             	lea    0x8(%ebp),%eax
  8002a7:	83 3d 84 74 80 00 00 	cmpl   $0x0,0x807484
  8002ae:	75 08                	jne    8002b8 <umain+0x24>
  8002b0:	8b 10                	mov    (%eax),%edx
  8002b2:	89 15 84 74 80 00    	mov    %edx,0x807484
  8002b8:	83 c0 04             	add    $0x4,%eax
  8002bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002be:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  8002c2:	8b 30                	mov    (%eax),%esi
  8002c4:	85 f6                	test   %esi,%esi
  8002c6:	0f 84 84 00 00 00    	je     800350 <umain+0xbc>
  8002cc:	80 3e 2d             	cmpb   $0x2d,(%esi)
  8002cf:	75 7f                	jne    800350 <umain+0xbc>
  8002d1:	83 c6 01             	add    $0x1,%esi
  8002d4:	0f b6 06             	movzbl (%esi),%eax
  8002d7:	84 c0                	test   %al,%al
  8002d9:	74 75                	je     800350 <umain+0xbc>
	default:
		usage();
	case 'd':
	case 'F':
	case 'l':
		flag[(uint8_t)ARGC()]++;
  8002db:	bf 80 70 80 00       	mov    $0x807080,%edi
void
umain(int argc, char **argv)
{
	int i;

	ARGBEGIN{
  8002e0:	3c 2d                	cmp    $0x2d,%al
  8002e2:	74 0c                	je     8002f0 <umain+0x5c>
  8002e4:	0f b6 1e             	movzbl (%esi),%ebx
  8002e7:	84 db                	test   %bl,%bl
  8002e9:	74 45                	je     800330 <umain+0x9c>
  8002eb:	83 c6 01             	add    $0x1,%esi
  8002ee:	eb 12                	jmp    800302 <umain+0x6e>
  8002f0:	80 7e 01 00          	cmpb   $0x0,0x1(%esi)
  8002f4:	75 ee                	jne    8002e4 <umain+0x50>
  8002f6:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  8002fa:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
  8002fe:	66 90                	xchg   %ax,%ax
  800300:	eb 4e                	jmp    800350 <umain+0xbc>
  800302:	80 fb 64             	cmp    $0x64,%bl
  800305:	74 16                	je     80031d <umain+0x89>
  800307:	80 fb 6c             	cmp    $0x6c,%bl
  80030a:	74 11                	je     80031d <umain+0x89>
  80030c:	80 fb 46             	cmp    $0x46,%bl
  80030f:	90                   	nop
  800310:	74 0b                	je     80031d <umain+0x89>
	default:
		usage();
  800312:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  800318:	e8 23 fd ff ff       	call   800040 <usage>
	case 'd':
	case 'F':
	case 'l':
		flag[(uint8_t)ARGC()]++;
  80031d:	0f b6 db             	movzbl %bl,%ebx
  800320:	83 04 9f 01          	addl   $0x1,(%edi,%ebx,4)
void
umain(int argc, char **argv)
{
	int i;

	ARGBEGIN{
  800324:	0f b6 1e             	movzbl (%esi),%ebx
  800327:	84 db                	test   %bl,%bl
  800329:	74 05                	je     800330 <umain+0x9c>
  80032b:	83 c6 01             	add    $0x1,%esi
  80032e:	eb d2                	jmp    800302 <umain+0x6e>
  800330:	83 6d 08 01          	subl   $0x1,0x8(%ebp)
  800334:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
  800338:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80033b:	8b 30                	mov    (%eax),%esi
  80033d:	85 f6                	test   %esi,%esi
  80033f:	74 0f                	je     800350 <umain+0xbc>
  800341:	80 3e 2d             	cmpb   $0x2d,(%esi)
  800344:	75 0a                	jne    800350 <umain+0xbc>
  800346:	83 c6 01             	add    $0x1,%esi
  800349:	0f b6 06             	movzbl (%esi),%eax
  80034c:	84 c0                	test   %al,%al
  80034e:	75 90                	jne    8002e0 <umain+0x4c>
	case 'l':
		flag[(uint8_t)ARGC()]++;
		break;
	}ARGEND

	if (argc == 0)
  800350:	8b 45 08             	mov    0x8(%ebp),%eax
  800353:	85 c0                	test   %eax,%eax
  800355:	74 0b                	je     800362 <umain+0xce>
		ls("/", "");
  800357:	bb 00 00 00 00       	mov    $0x0,%ebx
	else {
		for (i=0; i<argc; i++)
  80035c:	85 c0                	test   %eax,%eax
  80035e:	7f 18                	jg     800378 <umain+0xe4>
  800360:	eb 30                	jmp    800392 <umain+0xfe>
		flag[(uint8_t)ARGC()]++;
		break;
	}ARGEND

	if (argc == 0)
		ls("/", "");
  800362:	c7 44 24 04 9b 2c 80 	movl   $0x802c9b,0x4(%esp)
  800369:	00 
  80036a:	c7 04 24 a5 2c 80 00 	movl   $0x802ca5,(%esp)
  800371:	e8 92 fe ff ff       	call   800208 <ls>
  800376:	eb 1a                	jmp    800392 <umain+0xfe>
	else {
		for (i=0; i<argc; i++)
			ls(argv[i], argv[i]);
  800378:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80037b:	8b 04 9a             	mov    (%edx,%ebx,4),%eax
  80037e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800382:	89 04 24             	mov    %eax,(%esp)
  800385:	e8 7e fe ff ff       	call   800208 <ls>
	}ARGEND

	if (argc == 0)
		ls("/", "");
	else {
		for (i=0; i<argc; i++)
  80038a:	83 c3 01             	add    $0x1,%ebx
  80038d:	39 5d 08             	cmp    %ebx,0x8(%ebp)
  800390:	7f e6                	jg     800378 <umain+0xe4>
			ls(argv[i], argv[i]);
	}
}
  800392:	83 c4 2c             	add    $0x2c,%esp
  800395:	5b                   	pop    %ebx
  800396:	5e                   	pop    %esi
  800397:	5f                   	pop    %edi
  800398:	5d                   	pop    %ebp
  800399:	c3                   	ret    
	...

0080039c <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80039c:	55                   	push   %ebp
  80039d:	89 e5                	mov    %esp,%ebp
  80039f:	83 ec 18             	sub    $0x18,%esp
  8003a2:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8003a5:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8003a8:	8b 75 08             	mov    0x8(%ebp),%esi
  8003ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  8003ae:	e8 e6 0f 00 00       	call   801399 <sys_getenvid>
  8003b3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003b8:	6b c0 7c             	imul   $0x7c,%eax,%eax
  8003bb:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003c0:	a3 80 74 80 00       	mov    %eax,0x807480

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c5:	85 f6                	test   %esi,%esi
  8003c7:	7e 07                	jle    8003d0 <libmain+0x34>
		binaryname = argv[0];
  8003c9:	8b 03                	mov    (%ebx),%eax
  8003cb:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  8003d0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8003d4:	89 34 24             	mov    %esi,(%esp)
  8003d7:	e8 b8 fe ff ff       	call   800294 <umain>

	// exit gracefully
	exit();
  8003dc:	e8 0b 00 00 00       	call   8003ec <exit>
}
  8003e1:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8003e4:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8003e7:	89 ec                	mov    %ebp,%esp
  8003e9:	5d                   	pop    %ebp
  8003ea:	c3                   	ret    
	...

008003ec <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	83 ec 18             	sub    $0x18,%esp
	close_all();
  8003f2:	e8 14 15 00 00       	call   80190b <close_all>
	sys_env_destroy(0);
  8003f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8003fe:	e8 ca 0f 00 00       	call   8013cd <sys_env_destroy>
}
  800403:	c9                   	leave  
  800404:	c3                   	ret    
  800405:	00 00                	add    %al,(%eax)
	...

00800408 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800408:	55                   	push   %ebp
  800409:	89 e5                	mov    %esp,%ebp
  80040b:	53                   	push   %ebx
  80040c:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  80040f:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  800412:	a1 84 74 80 00       	mov    0x807484,%eax
  800417:	85 c0                	test   %eax,%eax
  800419:	74 10                	je     80042b <_panic+0x23>
		cprintf("%s: ", argv0);
  80041b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80041f:	c7 04 24 22 2d 80 00 	movl   $0x802d22,(%esp)
  800426:	e8 a2 00 00 00       	call   8004cd <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80042b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800432:	8b 45 08             	mov    0x8(%ebp),%eax
  800435:	89 44 24 08          	mov    %eax,0x8(%esp)
  800439:	a1 00 70 80 00       	mov    0x807000,%eax
  80043e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800442:	c7 04 24 27 2d 80 00 	movl   $0x802d27,(%esp)
  800449:	e8 7f 00 00 00       	call   8004cd <cprintf>
	vcprintf(fmt, ap);
  80044e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800452:	8b 45 10             	mov    0x10(%ebp),%eax
  800455:	89 04 24             	mov    %eax,(%esp)
  800458:	e8 0f 00 00 00       	call   80046c <vcprintf>
	cprintf("\n");
  80045d:	c7 04 24 9a 2c 80 00 	movl   $0x802c9a,(%esp)
  800464:	e8 64 00 00 00       	call   8004cd <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800469:	cc                   	int3   
  80046a:	eb fd                	jmp    800469 <_panic+0x61>

0080046c <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  80046c:	55                   	push   %ebp
  80046d:	89 e5                	mov    %esp,%ebp
  80046f:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  800475:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80047c:	00 00 00 
	b.cnt = 0;
  80047f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800486:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800490:	8b 45 08             	mov    0x8(%ebp),%eax
  800493:	89 44 24 08          	mov    %eax,0x8(%esp)
  800497:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80049d:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004a1:	c7 04 24 e7 04 80 00 	movl   $0x8004e7,(%esp)
  8004a8:	e8 d0 01 00 00       	call   80067d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004ad:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8004b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004b7:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8004bd:	89 04 24             	mov    %eax,(%esp)
  8004c0:	e8 db 0a 00 00       	call   800fa0 <sys_cputs>

	return b.cnt;
}
  8004c5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8004cb:	c9                   	leave  
  8004cc:	c3                   	ret    

008004cd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8004cd:	55                   	push   %ebp
  8004ce:	89 e5                	mov    %esp,%ebp
  8004d0:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  8004d3:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  8004d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004da:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dd:	89 04 24             	mov    %eax,(%esp)
  8004e0:	e8 87 ff ff ff       	call   80046c <vcprintf>
	va_end(ap);

	return cnt;
}
  8004e5:	c9                   	leave  
  8004e6:	c3                   	ret    

008004e7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8004e7:	55                   	push   %ebp
  8004e8:	89 e5                	mov    %esp,%ebp
  8004ea:	53                   	push   %ebx
  8004eb:	83 ec 14             	sub    $0x14,%esp
  8004ee:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8004f1:	8b 03                	mov    (%ebx),%eax
  8004f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f6:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8004fa:	83 c0 01             	add    $0x1,%eax
  8004fd:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8004ff:	3d ff 00 00 00       	cmp    $0xff,%eax
  800504:	75 19                	jne    80051f <putch+0x38>
		sys_cputs(b->buf, b->idx);
  800506:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  80050d:	00 
  80050e:	8d 43 08             	lea    0x8(%ebx),%eax
  800511:	89 04 24             	mov    %eax,(%esp)
  800514:	e8 87 0a 00 00       	call   800fa0 <sys_cputs>
		b->idx = 0;
  800519:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  80051f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  800523:	83 c4 14             	add    $0x14,%esp
  800526:	5b                   	pop    %ebx
  800527:	5d                   	pop    %ebp
  800528:	c3                   	ret    
  800529:	00 00                	add    %al,(%eax)
  80052b:	00 00                	add    %al,(%eax)
  80052d:	00 00                	add    %al,(%eax)
	...

00800530 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800530:	55                   	push   %ebp
  800531:	89 e5                	mov    %esp,%ebp
  800533:	57                   	push   %edi
  800534:	56                   	push   %esi
  800535:	53                   	push   %ebx
  800536:	83 ec 4c             	sub    $0x4c,%esp
  800539:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80053c:	89 d6                	mov    %edx,%esi
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800544:	8b 55 0c             	mov    0xc(%ebp),%edx
  800547:	89 55 e0             	mov    %edx,-0x20(%ebp)
  80054a:	8b 45 10             	mov    0x10(%ebp),%eax
  80054d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800550:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800553:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800556:	b9 00 00 00 00       	mov    $0x0,%ecx
  80055b:	39 d1                	cmp    %edx,%ecx
  80055d:	72 15                	jb     800574 <printnum+0x44>
  80055f:	77 07                	ja     800568 <printnum+0x38>
  800561:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800564:	39 d0                	cmp    %edx,%eax
  800566:	76 0c                	jbe    800574 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800568:	83 eb 01             	sub    $0x1,%ebx
  80056b:	85 db                	test   %ebx,%ebx
  80056d:	8d 76 00             	lea    0x0(%esi),%esi
  800570:	7f 61                	jg     8005d3 <printnum+0xa3>
  800572:	eb 70                	jmp    8005e4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800574:	89 7c 24 10          	mov    %edi,0x10(%esp)
  800578:	83 eb 01             	sub    $0x1,%ebx
  80057b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80057f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800583:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  800587:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80058b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80058e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800591:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  800594:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800598:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80059f:	00 
  8005a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8005a3:	89 04 24             	mov    %eax,(%esp)
  8005a6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005ad:	e8 5e 24 00 00       	call   802a10 <__udivdi3>
  8005b2:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8005b5:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8005b8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8005bc:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  8005c0:	89 04 24             	mov    %eax,(%esp)
  8005c3:	89 54 24 04          	mov    %edx,0x4(%esp)
  8005c7:	89 f2                	mov    %esi,%edx
  8005c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005cc:	e8 5f ff ff ff       	call   800530 <printnum>
  8005d1:	eb 11                	jmp    8005e4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005d3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005d7:	89 3c 24             	mov    %edi,(%esp)
  8005da:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005dd:	83 eb 01             	sub    $0x1,%ebx
  8005e0:	85 db                	test   %ebx,%ebx
  8005e2:	7f ef                	jg     8005d3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005e4:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005e8:	8b 74 24 04          	mov    0x4(%esp),%esi
  8005ec:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005ef:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005f3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8005fa:	00 
  8005fb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005fe:	89 14 24             	mov    %edx,(%esp)
  800601:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800604:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800608:	e8 33 25 00 00       	call   802b40 <__umoddi3>
  80060d:	89 74 24 04          	mov    %esi,0x4(%esp)
  800611:	0f be 80 43 2d 80 00 	movsbl 0x802d43(%eax),%eax
  800618:	89 04 24             	mov    %eax,(%esp)
  80061b:	ff 55 e4             	call   *-0x1c(%ebp)
}
  80061e:	83 c4 4c             	add    $0x4c,%esp
  800621:	5b                   	pop    %ebx
  800622:	5e                   	pop    %esi
  800623:	5f                   	pop    %edi
  800624:	5d                   	pop    %ebp
  800625:	c3                   	ret    

00800626 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800629:	83 fa 01             	cmp    $0x1,%edx
  80062c:	7e 0e                	jle    80063c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80062e:	8b 10                	mov    (%eax),%edx
  800630:	8d 4a 08             	lea    0x8(%edx),%ecx
  800633:	89 08                	mov    %ecx,(%eax)
  800635:	8b 02                	mov    (%edx),%eax
  800637:	8b 52 04             	mov    0x4(%edx),%edx
  80063a:	eb 22                	jmp    80065e <getuint+0x38>
	else if (lflag)
  80063c:	85 d2                	test   %edx,%edx
  80063e:	74 10                	je     800650 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  800640:	8b 10                	mov    (%eax),%edx
  800642:	8d 4a 04             	lea    0x4(%edx),%ecx
  800645:	89 08                	mov    %ecx,(%eax)
  800647:	8b 02                	mov    (%edx),%eax
  800649:	ba 00 00 00 00       	mov    $0x0,%edx
  80064e:	eb 0e                	jmp    80065e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  800650:	8b 10                	mov    (%eax),%edx
  800652:	8d 4a 04             	lea    0x4(%edx),%ecx
  800655:	89 08                	mov    %ecx,(%eax)
  800657:	8b 02                	mov    (%edx),%eax
  800659:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80065e:	5d                   	pop    %ebp
  80065f:	c3                   	ret    

00800660 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800660:	55                   	push   %ebp
  800661:	89 e5                	mov    %esp,%ebp
  800663:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800666:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80066a:	8b 10                	mov    (%eax),%edx
  80066c:	3b 50 04             	cmp    0x4(%eax),%edx
  80066f:	73 0a                	jae    80067b <sprintputch+0x1b>
		*b->buf++ = ch;
  800671:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800674:	88 0a                	mov    %cl,(%edx)
  800676:	83 c2 01             	add    $0x1,%edx
  800679:	89 10                	mov    %edx,(%eax)
}
  80067b:	5d                   	pop    %ebp
  80067c:	c3                   	ret    

0080067d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80067d:	55                   	push   %ebp
  80067e:	89 e5                	mov    %esp,%ebp
  800680:	57                   	push   %edi
  800681:	56                   	push   %esi
  800682:	53                   	push   %ebx
  800683:	83 ec 5c             	sub    $0x5c,%esp
  800686:	8b 7d 08             	mov    0x8(%ebp),%edi
  800689:	8b 75 0c             	mov    0xc(%ebp),%esi
  80068c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80068f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  800696:	eb 11                	jmp    8006a9 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  800698:	85 c0                	test   %eax,%eax
  80069a:	0f 84 09 04 00 00    	je     800aa9 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  8006a0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006a4:	89 04 24             	mov    %eax,(%esp)
  8006a7:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006a9:	0f b6 03             	movzbl (%ebx),%eax
  8006ac:	83 c3 01             	add    $0x1,%ebx
  8006af:	83 f8 25             	cmp    $0x25,%eax
  8006b2:	75 e4                	jne    800698 <vprintfmt+0x1b>
  8006b4:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  8006b8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  8006bf:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8006c6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8006cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d2:	eb 06                	jmp    8006da <vprintfmt+0x5d>
  8006d4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8006d8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8006da:	0f b6 13             	movzbl (%ebx),%edx
  8006dd:	0f b6 c2             	movzbl %dl,%eax
  8006e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006e3:	8d 43 01             	lea    0x1(%ebx),%eax
  8006e6:	83 ea 23             	sub    $0x23,%edx
  8006e9:	80 fa 55             	cmp    $0x55,%dl
  8006ec:	0f 87 9a 03 00 00    	ja     800a8c <vprintfmt+0x40f>
  8006f2:	0f b6 d2             	movzbl %dl,%edx
  8006f5:	ff 24 95 80 2e 80 00 	jmp    *0x802e80(,%edx,4)
  8006fc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  800700:	eb d6                	jmp    8006d8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  800702:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800705:	83 ea 30             	sub    $0x30,%edx
  800708:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  80070b:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  80070e:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800711:	83 fb 09             	cmp    $0x9,%ebx
  800714:	77 4c                	ja     800762 <vprintfmt+0xe5>
  800716:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800719:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80071c:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  80071f:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  800722:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  800726:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  800729:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80072c:	83 fb 09             	cmp    $0x9,%ebx
  80072f:	76 eb                	jbe    80071c <vprintfmt+0x9f>
  800731:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800734:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800737:	eb 29                	jmp    800762 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800739:	8b 55 14             	mov    0x14(%ebp),%edx
  80073c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80073f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  800742:	8b 12                	mov    (%edx),%edx
  800744:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  800747:	eb 19                	jmp    800762 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  800749:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80074c:	c1 fa 1f             	sar    $0x1f,%edx
  80074f:	f7 d2                	not    %edx
  800751:	21 55 e4             	and    %edx,-0x1c(%ebp)
  800754:	eb 82                	jmp    8006d8 <vprintfmt+0x5b>
  800756:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80075d:	e9 76 ff ff ff       	jmp    8006d8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  800762:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800766:	0f 89 6c ff ff ff    	jns    8006d8 <vprintfmt+0x5b>
  80076c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80076f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800772:	8b 55 c8             	mov    -0x38(%ebp),%edx
  800775:	89 55 cc             	mov    %edx,-0x34(%ebp)
  800778:	e9 5b ff ff ff       	jmp    8006d8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80077d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  800780:	e9 53 ff ff ff       	jmp    8006d8 <vprintfmt+0x5b>
  800785:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800788:	8b 45 14             	mov    0x14(%ebp),%eax
  80078b:	8d 50 04             	lea    0x4(%eax),%edx
  80078e:	89 55 14             	mov    %edx,0x14(%ebp)
  800791:	89 74 24 04          	mov    %esi,0x4(%esp)
  800795:	8b 00                	mov    (%eax),%eax
  800797:	89 04 24             	mov    %eax,(%esp)
  80079a:	ff d7                	call   *%edi
  80079c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80079f:	e9 05 ff ff ff       	jmp    8006a9 <vprintfmt+0x2c>
  8007a4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	8d 50 04             	lea    0x4(%eax),%edx
  8007ad:	89 55 14             	mov    %edx,0x14(%ebp)
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	89 c2                	mov    %eax,%edx
  8007b4:	c1 fa 1f             	sar    $0x1f,%edx
  8007b7:	31 d0                	xor    %edx,%eax
  8007b9:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007bb:	83 f8 0f             	cmp    $0xf,%eax
  8007be:	7f 0b                	jg     8007cb <vprintfmt+0x14e>
  8007c0:	8b 14 85 e0 2f 80 00 	mov    0x802fe0(,%eax,4),%edx
  8007c7:	85 d2                	test   %edx,%edx
  8007c9:	75 20                	jne    8007eb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8007cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8007cf:	c7 44 24 08 54 2d 80 	movl   $0x802d54,0x8(%esp)
  8007d6:	00 
  8007d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007db:	89 3c 24             	mov    %edi,(%esp)
  8007de:	e8 4e 03 00 00       	call   800b31 <printfmt>
  8007e3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8007e6:	e9 be fe ff ff       	jmp    8006a9 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007eb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8007ef:	c7 44 24 08 2d 31 80 	movl   $0x80312d,0x8(%esp)
  8007f6:	00 
  8007f7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8007fb:	89 3c 24             	mov    %edi,(%esp)
  8007fe:	e8 2e 03 00 00       	call   800b31 <printfmt>
  800803:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800806:	e9 9e fe ff ff       	jmp    8006a9 <vprintfmt+0x2c>
  80080b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80080e:	89 c3                	mov    %eax,%ebx
  800810:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  800813:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800816:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800819:	8b 45 14             	mov    0x14(%ebp),%eax
  80081c:	8d 50 04             	lea    0x4(%eax),%edx
  80081f:	89 55 14             	mov    %edx,0x14(%ebp)
  800822:	8b 00                	mov    (%eax),%eax
  800824:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800827:	85 c0                	test   %eax,%eax
  800829:	75 07                	jne    800832 <vprintfmt+0x1b5>
  80082b:	c7 45 c4 5d 2d 80 00 	movl   $0x802d5d,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  800832:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  800836:	7e 06                	jle    80083e <vprintfmt+0x1c1>
  800838:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80083c:	75 13                	jne    800851 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80083e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800841:	0f be 02             	movsbl (%edx),%eax
  800844:	85 c0                	test   %eax,%eax
  800846:	0f 85 99 00 00 00    	jne    8008e5 <vprintfmt+0x268>
  80084c:	e9 86 00 00 00       	jmp    8008d7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800851:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  800855:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  800858:	89 0c 24             	mov    %ecx,(%esp)
  80085b:	e8 1b 03 00 00       	call   800b7b <strnlen>
  800860:	8b 55 c0             	mov    -0x40(%ebp),%edx
  800863:	29 c2                	sub    %eax,%edx
  800865:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  800868:	85 d2                	test   %edx,%edx
  80086a:	7e d2                	jle    80083e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80086c:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  800870:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800873:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  800876:	89 d3                	mov    %edx,%ebx
  800878:	89 74 24 04          	mov    %esi,0x4(%esp)
  80087c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80087f:	89 04 24             	mov    %eax,(%esp)
  800882:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800884:	83 eb 01             	sub    $0x1,%ebx
  800887:	85 db                	test   %ebx,%ebx
  800889:	7f ed                	jg     800878 <vprintfmt+0x1fb>
  80088b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80088e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  800895:	eb a7                	jmp    80083e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  800897:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80089b:	74 18                	je     8008b5 <vprintfmt+0x238>
  80089d:	8d 50 e0             	lea    -0x20(%eax),%edx
  8008a0:	83 fa 5e             	cmp    $0x5e,%edx
  8008a3:	76 10                	jbe    8008b5 <vprintfmt+0x238>
					putch('?', putdat);
  8008a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008a9:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8008b0:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  8008b3:	eb 0a                	jmp    8008bf <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  8008b5:	89 7c 24 04          	mov    %edi,0x4(%esp)
  8008b9:	89 04 24             	mov    %eax,(%esp)
  8008bc:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008bf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8008c3:	0f be 03             	movsbl (%ebx),%eax
  8008c6:	85 c0                	test   %eax,%eax
  8008c8:	74 05                	je     8008cf <vprintfmt+0x252>
  8008ca:	83 c3 01             	add    $0x1,%ebx
  8008cd:	eb 29                	jmp    8008f8 <vprintfmt+0x27b>
  8008cf:	89 fe                	mov    %edi,%esi
  8008d1:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8008d4:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8008d7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008db:	7f 2e                	jg     80090b <vprintfmt+0x28e>
  8008dd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8008e0:	e9 c4 fd ff ff       	jmp    8006a9 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8008e8:	83 c2 01             	add    $0x1,%edx
  8008eb:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8008ee:	89 f7                	mov    %esi,%edi
  8008f0:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8008f3:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  8008f6:	89 d3                	mov    %edx,%ebx
  8008f8:	85 f6                	test   %esi,%esi
  8008fa:	78 9b                	js     800897 <vprintfmt+0x21a>
  8008fc:	83 ee 01             	sub    $0x1,%esi
  8008ff:	79 96                	jns    800897 <vprintfmt+0x21a>
  800901:	89 fe                	mov    %edi,%esi
  800903:	8b 7d dc             	mov    -0x24(%ebp),%edi
  800906:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  800909:	eb cc                	jmp    8008d7 <vprintfmt+0x25a>
  80090b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  80090e:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  800911:	89 74 24 04          	mov    %esi,0x4(%esp)
  800915:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80091c:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80091e:	83 eb 01             	sub    $0x1,%ebx
  800921:	85 db                	test   %ebx,%ebx
  800923:	7f ec                	jg     800911 <vprintfmt+0x294>
  800925:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  800928:	e9 7c fd ff ff       	jmp    8006a9 <vprintfmt+0x2c>
  80092d:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  800930:	83 f9 01             	cmp    $0x1,%ecx
  800933:	7e 16                	jle    80094b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	8d 50 08             	lea    0x8(%eax),%edx
  80093b:	89 55 14             	mov    %edx,0x14(%ebp)
  80093e:	8b 10                	mov    (%eax),%edx
  800940:	8b 48 04             	mov    0x4(%eax),%ecx
  800943:	89 55 d0             	mov    %edx,-0x30(%ebp)
  800946:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800949:	eb 32                	jmp    80097d <vprintfmt+0x300>
	else if (lflag)
  80094b:	85 c9                	test   %ecx,%ecx
  80094d:	74 18                	je     800967 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	8d 50 04             	lea    0x4(%eax),%edx
  800955:	89 55 14             	mov    %edx,0x14(%ebp)
  800958:	8b 00                	mov    (%eax),%eax
  80095a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80095d:	89 c1                	mov    %eax,%ecx
  80095f:	c1 f9 1f             	sar    $0x1f,%ecx
  800962:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  800965:	eb 16                	jmp    80097d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  800967:	8b 45 14             	mov    0x14(%ebp),%eax
  80096a:	8d 50 04             	lea    0x4(%eax),%edx
  80096d:	89 55 14             	mov    %edx,0x14(%ebp)
  800970:	8b 00                	mov    (%eax),%eax
  800972:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800975:	89 c2                	mov    %eax,%edx
  800977:	c1 fa 1f             	sar    $0x1f,%edx
  80097a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80097d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800980:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  800983:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  800988:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80098c:	0f 89 b8 00 00 00    	jns    800a4a <vprintfmt+0x3cd>
				putch('-', putdat);
  800992:	89 74 24 04          	mov    %esi,0x4(%esp)
  800996:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80099d:	ff d7                	call   *%edi
				num = -(long long) num;
  80099f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  8009a2:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  8009a5:	f7 d9                	neg    %ecx
  8009a7:	83 d3 00             	adc    $0x0,%ebx
  8009aa:	f7 db                	neg    %ebx
  8009ac:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b1:	e9 94 00 00 00       	jmp    800a4a <vprintfmt+0x3cd>
  8009b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b9:	89 ca                	mov    %ecx,%edx
  8009bb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009be:	e8 63 fc ff ff       	call   800626 <getuint>
  8009c3:	89 c1                	mov    %eax,%ecx
  8009c5:	89 d3                	mov    %edx,%ebx
  8009c7:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8009cc:	eb 7c                	jmp    800a4a <vprintfmt+0x3cd>
  8009ce:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009d5:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8009dc:	ff d7                	call   *%edi
			putch('X', putdat);
  8009de:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009e2:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8009e9:	ff d7                	call   *%edi
			putch('X', putdat);
  8009eb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009ef:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8009f6:	ff d7                	call   *%edi
  8009f8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8009fb:	e9 a9 fc ff ff       	jmp    8006a9 <vprintfmt+0x2c>
  800a00:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  800a03:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a07:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800a0e:	ff d7                	call   *%edi
			putch('x', putdat);
  800a10:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a14:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  800a1b:	ff d7                	call   *%edi
			num = (unsigned long long)
  800a1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a20:	8d 50 04             	lea    0x4(%eax),%edx
  800a23:	89 55 14             	mov    %edx,0x14(%ebp)
  800a26:	8b 08                	mov    (%eax),%ecx
  800a28:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a2d:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  800a32:	eb 16                	jmp    800a4a <vprintfmt+0x3cd>
  800a34:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a37:	89 ca                	mov    %ecx,%edx
  800a39:	8d 45 14             	lea    0x14(%ebp),%eax
  800a3c:	e8 e5 fb ff ff       	call   800626 <getuint>
  800a41:	89 c1                	mov    %eax,%ecx
  800a43:	89 d3                	mov    %edx,%ebx
  800a45:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a4a:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  800a4e:	89 54 24 10          	mov    %edx,0x10(%esp)
  800a52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a55:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800a59:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a5d:	89 0c 24             	mov    %ecx,(%esp)
  800a60:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800a64:	89 f2                	mov    %esi,%edx
  800a66:	89 f8                	mov    %edi,%eax
  800a68:	e8 c3 fa ff ff       	call   800530 <printnum>
  800a6d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800a70:	e9 34 fc ff ff       	jmp    8006a9 <vprintfmt+0x2c>
  800a75:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a78:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a7b:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a7f:	89 14 24             	mov    %edx,(%esp)
  800a82:	ff d7                	call   *%edi
  800a84:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  800a87:	e9 1d fc ff ff       	jmp    8006a9 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a8c:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a90:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800a97:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a99:	8d 43 ff             	lea    -0x1(%ebx),%eax
  800a9c:	80 38 25             	cmpb   $0x25,(%eax)
  800a9f:	0f 84 04 fc ff ff    	je     8006a9 <vprintfmt+0x2c>
  800aa5:	89 c3                	mov    %eax,%ebx
  800aa7:	eb f0                	jmp    800a99 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  800aa9:	83 c4 5c             	add    $0x5c,%esp
  800aac:	5b                   	pop    %ebx
  800aad:	5e                   	pop    %esi
  800aae:	5f                   	pop    %edi
  800aaf:	5d                   	pop    %ebp
  800ab0:	c3                   	ret    

00800ab1 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800ab1:	55                   	push   %ebp
  800ab2:	89 e5                	mov    %esp,%ebp
  800ab4:	83 ec 28             	sub    $0x28,%esp
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  800abd:	85 c0                	test   %eax,%eax
  800abf:	74 04                	je     800ac5 <vsnprintf+0x14>
  800ac1:	85 d2                	test   %edx,%edx
  800ac3:	7f 07                	jg     800acc <vsnprintf+0x1b>
  800ac5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800aca:	eb 3b                	jmp    800b07 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  800acc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800acf:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  800ad3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800add:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ae4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae7:	89 44 24 08          	mov    %eax,0x8(%esp)
  800aeb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aee:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af2:	c7 04 24 60 06 80 00 	movl   $0x800660,(%esp)
  800af9:	e8 7f fb ff ff       	call   80067d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800afe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b01:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b07:	c9                   	leave  
  800b08:	c3                   	ret    

00800b09 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
  800b0c:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  800b0f:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  800b12:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b16:	8b 45 10             	mov    0x10(%ebp),%eax
  800b19:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b20:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b24:	8b 45 08             	mov    0x8(%ebp),%eax
  800b27:	89 04 24             	mov    %eax,(%esp)
  800b2a:	e8 82 ff ff ff       	call   800ab1 <vsnprintf>
	va_end(ap);

	return rc;
}
  800b2f:	c9                   	leave  
  800b30:	c3                   	ret    

00800b31 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b31:	55                   	push   %ebp
  800b32:	89 e5                	mov    %esp,%ebp
  800b34:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  800b37:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  800b3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800b3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800b41:	89 44 24 08          	mov    %eax,0x8(%esp)
  800b45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b48:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4f:	89 04 24             	mov    %eax,(%esp)
  800b52:	e8 26 fb ff ff       	call   80067d <vprintfmt>
	va_end(ap);
}
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    
  800b59:	00 00                	add    %al,(%eax)
  800b5b:	00 00                	add    %al,(%eax)
  800b5d:	00 00                	add    %al,(%eax)
	...

00800b60 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800b60:	55                   	push   %ebp
  800b61:	89 e5                	mov    %esp,%ebp
  800b63:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800b66:	b8 00 00 00 00       	mov    $0x0,%eax
  800b6b:	80 3a 00             	cmpb   $0x0,(%edx)
  800b6e:	74 09                	je     800b79 <strlen+0x19>
		n++;
  800b70:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800b73:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b77:	75 f7                	jne    800b70 <strlen+0x10>
		n++;
	return n;
}
  800b79:	5d                   	pop    %ebp
  800b7a:	c3                   	ret    

00800b7b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	53                   	push   %ebx
  800b7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800b82:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b85:	85 c9                	test   %ecx,%ecx
  800b87:	74 19                	je     800ba2 <strnlen+0x27>
  800b89:	80 3b 00             	cmpb   $0x0,(%ebx)
  800b8c:	74 14                	je     800ba2 <strnlen+0x27>
  800b8e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  800b93:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b96:	39 c8                	cmp    %ecx,%eax
  800b98:	74 0d                	je     800ba7 <strnlen+0x2c>
  800b9a:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  800b9e:	75 f3                	jne    800b93 <strnlen+0x18>
  800ba0:	eb 05                	jmp    800ba7 <strnlen+0x2c>
  800ba2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  800ba7:	5b                   	pop    %ebx
  800ba8:	5d                   	pop    %ebp
  800ba9:	c3                   	ret    

00800baa <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800baa:	55                   	push   %ebp
  800bab:	89 e5                	mov    %esp,%ebp
  800bad:	53                   	push   %ebx
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800bb4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800bb9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  800bbd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  800bc0:	83 c2 01             	add    $0x1,%edx
  800bc3:	84 c9                	test   %cl,%cl
  800bc5:	75 f2                	jne    800bb9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  800bc7:	5b                   	pop    %ebx
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	56                   	push   %esi
  800bce:	53                   	push   %ebx
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bd8:	85 f6                	test   %esi,%esi
  800bda:	74 18                	je     800bf4 <strncpy+0x2a>
  800bdc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800be1:	0f b6 1a             	movzbl (%edx),%ebx
  800be4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800be7:	80 3a 01             	cmpb   $0x1,(%edx)
  800bea:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800bed:	83 c1 01             	add    $0x1,%ecx
  800bf0:	39 ce                	cmp    %ecx,%esi
  800bf2:	77 ed                	ja     800be1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800bf4:	5b                   	pop    %ebx
  800bf5:	5e                   	pop    %esi
  800bf6:	5d                   	pop    %ebp
  800bf7:	c3                   	ret    

00800bf8 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800bf8:	55                   	push   %ebp
  800bf9:	89 e5                	mov    %esp,%ebp
  800bfb:	56                   	push   %esi
  800bfc:	53                   	push   %ebx
  800bfd:	8b 75 08             	mov    0x8(%ebp),%esi
  800c00:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c03:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c06:	89 f0                	mov    %esi,%eax
  800c08:	85 c9                	test   %ecx,%ecx
  800c0a:	74 27                	je     800c33 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  800c0c:	83 e9 01             	sub    $0x1,%ecx
  800c0f:	74 1d                	je     800c2e <strlcpy+0x36>
  800c11:	0f b6 1a             	movzbl (%edx),%ebx
  800c14:	84 db                	test   %bl,%bl
  800c16:	74 16                	je     800c2e <strlcpy+0x36>
			*dst++ = *src++;
  800c18:	88 18                	mov    %bl,(%eax)
  800c1a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c1d:	83 e9 01             	sub    $0x1,%ecx
  800c20:	74 0e                	je     800c30 <strlcpy+0x38>
			*dst++ = *src++;
  800c22:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c25:	0f b6 1a             	movzbl (%edx),%ebx
  800c28:	84 db                	test   %bl,%bl
  800c2a:	75 ec                	jne    800c18 <strlcpy+0x20>
  800c2c:	eb 02                	jmp    800c30 <strlcpy+0x38>
  800c2e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800c30:	c6 00 00             	movb   $0x0,(%eax)
  800c33:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800c35:	5b                   	pop    %ebx
  800c36:	5e                   	pop    %esi
  800c37:	5d                   	pop    %ebp
  800c38:	c3                   	ret    

00800c39 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c39:	55                   	push   %ebp
  800c3a:	89 e5                	mov    %esp,%ebp
  800c3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c3f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800c42:	0f b6 01             	movzbl (%ecx),%eax
  800c45:	84 c0                	test   %al,%al
  800c47:	74 15                	je     800c5e <strcmp+0x25>
  800c49:	3a 02                	cmp    (%edx),%al
  800c4b:	75 11                	jne    800c5e <strcmp+0x25>
		p++, q++;
  800c4d:	83 c1 01             	add    $0x1,%ecx
  800c50:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800c53:	0f b6 01             	movzbl (%ecx),%eax
  800c56:	84 c0                	test   %al,%al
  800c58:	74 04                	je     800c5e <strcmp+0x25>
  800c5a:	3a 02                	cmp    (%edx),%al
  800c5c:	74 ef                	je     800c4d <strcmp+0x14>
  800c5e:	0f b6 c0             	movzbl %al,%eax
  800c61:	0f b6 12             	movzbl (%edx),%edx
  800c64:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800c66:	5d                   	pop    %ebp
  800c67:	c3                   	ret    

00800c68 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800c68:	55                   	push   %ebp
  800c69:	89 e5                	mov    %esp,%ebp
  800c6b:	53                   	push   %ebx
  800c6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c72:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800c75:	85 c0                	test   %eax,%eax
  800c77:	74 23                	je     800c9c <strncmp+0x34>
  800c79:	0f b6 1a             	movzbl (%edx),%ebx
  800c7c:	84 db                	test   %bl,%bl
  800c7e:	74 24                	je     800ca4 <strncmp+0x3c>
  800c80:	3a 19                	cmp    (%ecx),%bl
  800c82:	75 20                	jne    800ca4 <strncmp+0x3c>
  800c84:	83 e8 01             	sub    $0x1,%eax
  800c87:	74 13                	je     800c9c <strncmp+0x34>
		n--, p++, q++;
  800c89:	83 c2 01             	add    $0x1,%edx
  800c8c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  800c8f:	0f b6 1a             	movzbl (%edx),%ebx
  800c92:	84 db                	test   %bl,%bl
  800c94:	74 0e                	je     800ca4 <strncmp+0x3c>
  800c96:	3a 19                	cmp    (%ecx),%bl
  800c98:	74 ea                	je     800c84 <strncmp+0x1c>
  800c9a:	eb 08                	jmp    800ca4 <strncmp+0x3c>
  800c9c:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800ca1:	5b                   	pop    %ebx
  800ca2:	5d                   	pop    %ebp
  800ca3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ca4:	0f b6 02             	movzbl (%edx),%eax
  800ca7:	0f b6 11             	movzbl (%ecx),%edx
  800caa:	29 d0                	sub    %edx,%eax
  800cac:	eb f3                	jmp    800ca1 <strncmp+0x39>

00800cae <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800cae:	55                   	push   %ebp
  800caf:	89 e5                	mov    %esp,%ebp
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800cb8:	0f b6 10             	movzbl (%eax),%edx
  800cbb:	84 d2                	test   %dl,%dl
  800cbd:	74 15                	je     800cd4 <strchr+0x26>
		if (*s == c)
  800cbf:	38 ca                	cmp    %cl,%dl
  800cc1:	75 07                	jne    800cca <strchr+0x1c>
  800cc3:	eb 14                	jmp    800cd9 <strchr+0x2b>
  800cc5:	38 ca                	cmp    %cl,%dl
  800cc7:	90                   	nop
  800cc8:	74 0f                	je     800cd9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800cca:	83 c0 01             	add    $0x1,%eax
  800ccd:	0f b6 10             	movzbl (%eax),%edx
  800cd0:	84 d2                	test   %dl,%dl
  800cd2:	75 f1                	jne    800cc5 <strchr+0x17>
  800cd4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    

00800cdb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800cdb:	55                   	push   %ebp
  800cdc:	89 e5                	mov    %esp,%ebp
  800cde:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800ce5:	0f b6 10             	movzbl (%eax),%edx
  800ce8:	84 d2                	test   %dl,%dl
  800cea:	74 18                	je     800d04 <strfind+0x29>
		if (*s == c)
  800cec:	38 ca                	cmp    %cl,%dl
  800cee:	75 0a                	jne    800cfa <strfind+0x1f>
  800cf0:	eb 12                	jmp    800d04 <strfind+0x29>
  800cf2:	38 ca                	cmp    %cl,%dl
  800cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800cf8:	74 0a                	je     800d04 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cfa:	83 c0 01             	add    $0x1,%eax
  800cfd:	0f b6 10             	movzbl (%eax),%edx
  800d00:	84 d2                	test   %dl,%dl
  800d02:	75 ee                	jne    800cf2 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800d04:	5d                   	pop    %ebp
  800d05:	c3                   	ret    

00800d06 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d06:	55                   	push   %ebp
  800d07:	89 e5                	mov    %esp,%ebp
  800d09:	83 ec 0c             	sub    $0xc,%esp
  800d0c:	89 1c 24             	mov    %ebx,(%esp)
  800d0f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800d13:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800d17:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d20:	85 c9                	test   %ecx,%ecx
  800d22:	74 30                	je     800d54 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d24:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d2a:	75 25                	jne    800d51 <memset+0x4b>
  800d2c:	f6 c1 03             	test   $0x3,%cl
  800d2f:	75 20                	jne    800d51 <memset+0x4b>
		c &= 0xFF;
  800d31:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d34:	89 d3                	mov    %edx,%ebx
  800d36:	c1 e3 08             	shl    $0x8,%ebx
  800d39:	89 d6                	mov    %edx,%esi
  800d3b:	c1 e6 18             	shl    $0x18,%esi
  800d3e:	89 d0                	mov    %edx,%eax
  800d40:	c1 e0 10             	shl    $0x10,%eax
  800d43:	09 f0                	or     %esi,%eax
  800d45:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800d47:	09 d8                	or     %ebx,%eax
  800d49:	c1 e9 02             	shr    $0x2,%ecx
  800d4c:	fc                   	cld    
  800d4d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d4f:	eb 03                	jmp    800d54 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d51:	fc                   	cld    
  800d52:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d54:	89 f8                	mov    %edi,%eax
  800d56:	8b 1c 24             	mov    (%esp),%ebx
  800d59:	8b 74 24 04          	mov    0x4(%esp),%esi
  800d5d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800d61:	89 ec                	mov    %ebp,%esp
  800d63:	5d                   	pop    %ebp
  800d64:	c3                   	ret    

00800d65 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d65:	55                   	push   %ebp
  800d66:	89 e5                	mov    %esp,%ebp
  800d68:	83 ec 08             	sub    $0x8,%esp
  800d6b:	89 34 24             	mov    %esi,(%esp)
  800d6e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800d78:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  800d7b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  800d7d:	39 c6                	cmp    %eax,%esi
  800d7f:	73 35                	jae    800db6 <memmove+0x51>
  800d81:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800d84:	39 d0                	cmp    %edx,%eax
  800d86:	73 2e                	jae    800db6 <memmove+0x51>
		s += n;
		d += n;
  800d88:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800d8a:	f6 c2 03             	test   $0x3,%dl
  800d8d:	75 1b                	jne    800daa <memmove+0x45>
  800d8f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d95:	75 13                	jne    800daa <memmove+0x45>
  800d97:	f6 c1 03             	test   $0x3,%cl
  800d9a:	75 0e                	jne    800daa <memmove+0x45>
			asm volatile("std; rep movsl\n"
  800d9c:	83 ef 04             	sub    $0x4,%edi
  800d9f:	8d 72 fc             	lea    -0x4(%edx),%esi
  800da2:	c1 e9 02             	shr    $0x2,%ecx
  800da5:	fd                   	std    
  800da6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800da8:	eb 09                	jmp    800db3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  800daa:	83 ef 01             	sub    $0x1,%edi
  800dad:	8d 72 ff             	lea    -0x1(%edx),%esi
  800db0:	fd                   	std    
  800db1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800db3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800db4:	eb 20                	jmp    800dd6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800db6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dbc:	75 15                	jne    800dd3 <memmove+0x6e>
  800dbe:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800dc4:	75 0d                	jne    800dd3 <memmove+0x6e>
  800dc6:	f6 c1 03             	test   $0x3,%cl
  800dc9:	75 08                	jne    800dd3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  800dcb:	c1 e9 02             	shr    $0x2,%ecx
  800dce:	fc                   	cld    
  800dcf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dd1:	eb 03                	jmp    800dd6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800dd3:	fc                   	cld    
  800dd4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dd6:	8b 34 24             	mov    (%esp),%esi
  800dd9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  800ddd:	89 ec                	mov    %ebp,%esp
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    

00800de1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800de7:	8b 45 10             	mov    0x10(%ebp),%eax
  800dea:	89 44 24 08          	mov    %eax,0x8(%esp)
  800dee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	89 04 24             	mov    %eax,(%esp)
  800dfb:	e8 65 ff ff ff       	call   800d65 <memmove>
}
  800e00:	c9                   	leave  
  800e01:	c3                   	ret    

00800e02 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e02:	55                   	push   %ebp
  800e03:	89 e5                	mov    %esp,%ebp
  800e05:	57                   	push   %edi
  800e06:	56                   	push   %esi
  800e07:	53                   	push   %ebx
  800e08:	8b 75 08             	mov    0x8(%ebp),%esi
  800e0b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800e0e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e11:	85 c9                	test   %ecx,%ecx
  800e13:	74 36                	je     800e4b <memcmp+0x49>
		if (*s1 != *s2)
  800e15:	0f b6 06             	movzbl (%esi),%eax
  800e18:	0f b6 1f             	movzbl (%edi),%ebx
  800e1b:	38 d8                	cmp    %bl,%al
  800e1d:	74 20                	je     800e3f <memcmp+0x3d>
  800e1f:	eb 14                	jmp    800e35 <memcmp+0x33>
  800e21:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800e26:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  800e2b:	83 c2 01             	add    $0x1,%edx
  800e2e:	83 e9 01             	sub    $0x1,%ecx
  800e31:	38 d8                	cmp    %bl,%al
  800e33:	74 12                	je     800e47 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800e35:	0f b6 c0             	movzbl %al,%eax
  800e38:	0f b6 db             	movzbl %bl,%ebx
  800e3b:	29 d8                	sub    %ebx,%eax
  800e3d:	eb 11                	jmp    800e50 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800e3f:	83 e9 01             	sub    $0x1,%ecx
  800e42:	ba 00 00 00 00       	mov    $0x0,%edx
  800e47:	85 c9                	test   %ecx,%ecx
  800e49:	75 d6                	jne    800e21 <memcmp+0x1f>
  800e4b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800e50:	5b                   	pop    %ebx
  800e51:	5e                   	pop    %esi
  800e52:	5f                   	pop    %edi
  800e53:	5d                   	pop    %ebp
  800e54:	c3                   	ret    

00800e55 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e55:	55                   	push   %ebp
  800e56:	89 e5                	mov    %esp,%ebp
  800e58:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  800e5b:	89 c2                	mov    %eax,%edx
  800e5d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e60:	39 d0                	cmp    %edx,%eax
  800e62:	73 15                	jae    800e79 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e64:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800e68:	38 08                	cmp    %cl,(%eax)
  800e6a:	75 06                	jne    800e72 <memfind+0x1d>
  800e6c:	eb 0b                	jmp    800e79 <memfind+0x24>
  800e6e:	38 08                	cmp    %cl,(%eax)
  800e70:	74 07                	je     800e79 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e72:	83 c0 01             	add    $0x1,%eax
  800e75:	39 c2                	cmp    %eax,%edx
  800e77:	77 f5                	ja     800e6e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800e79:	5d                   	pop    %ebp
  800e7a:	c3                   	ret    

00800e7b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e7b:	55                   	push   %ebp
  800e7c:	89 e5                	mov    %esp,%ebp
  800e7e:	57                   	push   %edi
  800e7f:	56                   	push   %esi
  800e80:	53                   	push   %ebx
  800e81:	83 ec 04             	sub    $0x4,%esp
  800e84:	8b 55 08             	mov    0x8(%ebp),%edx
  800e87:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e8a:	0f b6 02             	movzbl (%edx),%eax
  800e8d:	3c 20                	cmp    $0x20,%al
  800e8f:	74 04                	je     800e95 <strtol+0x1a>
  800e91:	3c 09                	cmp    $0x9,%al
  800e93:	75 0e                	jne    800ea3 <strtol+0x28>
		s++;
  800e95:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e98:	0f b6 02             	movzbl (%edx),%eax
  800e9b:	3c 20                	cmp    $0x20,%al
  800e9d:	74 f6                	je     800e95 <strtol+0x1a>
  800e9f:	3c 09                	cmp    $0x9,%al
  800ea1:	74 f2                	je     800e95 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ea3:	3c 2b                	cmp    $0x2b,%al
  800ea5:	75 0c                	jne    800eb3 <strtol+0x38>
		s++;
  800ea7:	83 c2 01             	add    $0x1,%edx
  800eaa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800eb1:	eb 15                	jmp    800ec8 <strtol+0x4d>
	else if (*s == '-')
  800eb3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800eba:	3c 2d                	cmp    $0x2d,%al
  800ebc:	75 0a                	jne    800ec8 <strtol+0x4d>
		s++, neg = 1;
  800ebe:	83 c2 01             	add    $0x1,%edx
  800ec1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ec8:	85 db                	test   %ebx,%ebx
  800eca:	0f 94 c0             	sete   %al
  800ecd:	74 05                	je     800ed4 <strtol+0x59>
  800ecf:	83 fb 10             	cmp    $0x10,%ebx
  800ed2:	75 18                	jne    800eec <strtol+0x71>
  800ed4:	80 3a 30             	cmpb   $0x30,(%edx)
  800ed7:	75 13                	jne    800eec <strtol+0x71>
  800ed9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  800edd:	8d 76 00             	lea    0x0(%esi),%esi
  800ee0:	75 0a                	jne    800eec <strtol+0x71>
		s += 2, base = 16;
  800ee2:	83 c2 02             	add    $0x2,%edx
  800ee5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eea:	eb 15                	jmp    800f01 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800eec:	84 c0                	test   %al,%al
  800eee:	66 90                	xchg   %ax,%ax
  800ef0:	74 0f                	je     800f01 <strtol+0x86>
  800ef2:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800ef7:	80 3a 30             	cmpb   $0x30,(%edx)
  800efa:	75 05                	jne    800f01 <strtol+0x86>
		s++, base = 8;
  800efc:	83 c2 01             	add    $0x1,%edx
  800eff:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f01:	b8 00 00 00 00       	mov    $0x0,%eax
  800f06:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f08:	0f b6 0a             	movzbl (%edx),%ecx
  800f0b:	89 cf                	mov    %ecx,%edi
  800f0d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800f10:	80 fb 09             	cmp    $0x9,%bl
  800f13:	77 08                	ja     800f1d <strtol+0xa2>
			dig = *s - '0';
  800f15:	0f be c9             	movsbl %cl,%ecx
  800f18:	83 e9 30             	sub    $0x30,%ecx
  800f1b:	eb 1e                	jmp    800f3b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  800f1d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800f20:	80 fb 19             	cmp    $0x19,%bl
  800f23:	77 08                	ja     800f2d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800f25:	0f be c9             	movsbl %cl,%ecx
  800f28:	83 e9 57             	sub    $0x57,%ecx
  800f2b:	eb 0e                	jmp    800f3b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  800f2d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800f30:	80 fb 19             	cmp    $0x19,%bl
  800f33:	77 15                	ja     800f4a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800f35:	0f be c9             	movsbl %cl,%ecx
  800f38:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  800f3b:	39 f1                	cmp    %esi,%ecx
  800f3d:	7d 0b                	jge    800f4a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  800f3f:	83 c2 01             	add    $0x1,%edx
  800f42:	0f af c6             	imul   %esi,%eax
  800f45:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800f48:	eb be                	jmp    800f08 <strtol+0x8d>
  800f4a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  800f4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f50:	74 05                	je     800f57 <strtol+0xdc>
		*endptr = (char *) s;
  800f52:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800f55:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800f57:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800f5b:	74 04                	je     800f61 <strtol+0xe6>
  800f5d:	89 c8                	mov    %ecx,%eax
  800f5f:	f7 d8                	neg    %eax
}
  800f61:	83 c4 04             	add    $0x4,%esp
  800f64:	5b                   	pop    %ebx
  800f65:	5e                   	pop    %esi
  800f66:	5f                   	pop    %edi
  800f67:	5d                   	pop    %ebp
  800f68:	c3                   	ret    
  800f69:	00 00                	add    %al,(%eax)
	...

00800f6c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  800f6c:	55                   	push   %ebp
  800f6d:	89 e5                	mov    %esp,%ebp
  800f6f:	83 ec 0c             	sub    $0xc,%esp
  800f72:	89 1c 24             	mov    %ebx,(%esp)
  800f75:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f79:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800f7d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f82:	b8 01 00 00 00       	mov    $0x1,%eax
  800f87:	89 d1                	mov    %edx,%ecx
  800f89:	89 d3                	mov    %edx,%ebx
  800f8b:	89 d7                	mov    %edx,%edi
  800f8d:	89 d6                	mov    %edx,%esi
  800f8f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f91:	8b 1c 24             	mov    (%esp),%ebx
  800f94:	8b 74 24 04          	mov    0x4(%esp),%esi
  800f98:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800f9c:	89 ec                	mov    %ebp,%esp
  800f9e:	5d                   	pop    %ebp
  800f9f:	c3                   	ret    

00800fa0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	83 ec 0c             	sub    $0xc,%esp
  800fa6:	89 1c 24             	mov    %ebx,(%esp)
  800fa9:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fad:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800fbc:	89 c3                	mov    %eax,%ebx
  800fbe:	89 c7                	mov    %eax,%edi
  800fc0:	89 c6                	mov    %eax,%esi
  800fc2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800fc4:	8b 1c 24             	mov    (%esp),%ebx
  800fc7:	8b 74 24 04          	mov    0x4(%esp),%esi
  800fcb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800fcf:	89 ec                	mov    %ebp,%esp
  800fd1:	5d                   	pop    %ebp
  800fd2:	c3                   	ret    

00800fd3 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  800fd3:	55                   	push   %ebp
  800fd4:	89 e5                	mov    %esp,%ebp
  800fd6:	83 ec 0c             	sub    $0xc,%esp
  800fd9:	89 1c 24             	mov    %ebx,(%esp)
  800fdc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800fe0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800fe4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fe9:	b8 10 00 00 00       	mov    $0x10,%eax
  800fee:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ff1:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff4:	89 df                	mov    %ebx,%edi
  800ff6:	89 de                	mov    %ebx,%esi
  800ff8:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  800ffa:	8b 1c 24             	mov    (%esp),%ebx
  800ffd:	8b 74 24 04          	mov    0x4(%esp),%esi
  801001:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801005:	89 ec                	mov    %ebp,%esp
  801007:	5d                   	pop    %ebp
  801008:	c3                   	ret    

00801009 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  801009:	55                   	push   %ebp
  80100a:	89 e5                	mov    %esp,%ebp
  80100c:	83 ec 38             	sub    $0x38,%esp
  80100f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801012:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801015:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801018:	bb 00 00 00 00       	mov    $0x0,%ebx
  80101d:	b8 0f 00 00 00       	mov    $0xf,%eax
  801022:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801025:	8b 55 08             	mov    0x8(%ebp),%edx
  801028:	89 df                	mov    %ebx,%edi
  80102a:	89 de                	mov    %ebx,%esi
  80102c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80102e:	85 c0                	test   %eax,%eax
  801030:	7e 28                	jle    80105a <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801032:	89 44 24 10          	mov    %eax,0x10(%esp)
  801036:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80103d:	00 
  80103e:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  801045:	00 
  801046:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80104d:	00 
  80104e:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  801055:	e8 ae f3 ff ff       	call   800408 <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  80105a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80105d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801060:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801063:	89 ec                	mov    %ebp,%esp
  801065:	5d                   	pop    %ebp
  801066:	c3                   	ret    

00801067 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	83 ec 0c             	sub    $0xc,%esp
  80106d:	89 1c 24             	mov    %ebx,(%esp)
  801070:	89 74 24 04          	mov    %esi,0x4(%esp)
  801074:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801078:	ba 00 00 00 00       	mov    $0x0,%edx
  80107d:	b8 0e 00 00 00       	mov    $0xe,%eax
  801082:	89 d1                	mov    %edx,%ecx
  801084:	89 d3                	mov    %edx,%ebx
  801086:	89 d7                	mov    %edx,%edi
  801088:	89 d6                	mov    %edx,%esi
  80108a:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80108c:	8b 1c 24             	mov    (%esp),%ebx
  80108f:	8b 74 24 04          	mov    0x4(%esp),%esi
  801093:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801097:	89 ec                	mov    %ebp,%esp
  801099:	5d                   	pop    %ebp
  80109a:	c3                   	ret    

0080109b <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  80109b:	55                   	push   %ebp
  80109c:	89 e5                	mov    %esp,%ebp
  80109e:	83 ec 38             	sub    $0x38,%esp
  8010a1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8010a4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8010a7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8010aa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010af:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b7:	89 cb                	mov    %ecx,%ebx
  8010b9:	89 cf                	mov    %ecx,%edi
  8010bb:	89 ce                	mov    %ecx,%esi
  8010bd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8010bf:	85 c0                	test   %eax,%eax
  8010c1:	7e 28                	jle    8010eb <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8010c3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c7:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8010ce:	00 
  8010cf:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  8010d6:	00 
  8010d7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8010de:	00 
  8010df:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  8010e6:	e8 1d f3 ff ff       	call   800408 <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8010eb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8010ee:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8010f1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8010f4:	89 ec                	mov    %ebp,%esp
  8010f6:	5d                   	pop    %ebp
  8010f7:	c3                   	ret    

008010f8 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010f8:	55                   	push   %ebp
  8010f9:	89 e5                	mov    %esp,%ebp
  8010fb:	83 ec 0c             	sub    $0xc,%esp
  8010fe:	89 1c 24             	mov    %ebx,(%esp)
  801101:	89 74 24 04          	mov    %esi,0x4(%esp)
  801105:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801109:	be 00 00 00 00       	mov    $0x0,%esi
  80110e:	b8 0c 00 00 00       	mov    $0xc,%eax
  801113:	8b 7d 14             	mov    0x14(%ebp),%edi
  801116:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801119:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80111c:	8b 55 08             	mov    0x8(%ebp),%edx
  80111f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801121:	8b 1c 24             	mov    (%esp),%ebx
  801124:	8b 74 24 04          	mov    0x4(%esp),%esi
  801128:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80112c:	89 ec                	mov    %ebp,%esp
  80112e:	5d                   	pop    %ebp
  80112f:	c3                   	ret    

00801130 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801130:	55                   	push   %ebp
  801131:	89 e5                	mov    %esp,%ebp
  801133:	83 ec 38             	sub    $0x38,%esp
  801136:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801139:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80113c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80113f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801144:	b8 0a 00 00 00       	mov    $0xa,%eax
  801149:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80114c:	8b 55 08             	mov    0x8(%ebp),%edx
  80114f:	89 df                	mov    %ebx,%edi
  801151:	89 de                	mov    %ebx,%esi
  801153:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801155:	85 c0                	test   %eax,%eax
  801157:	7e 28                	jle    801181 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801159:	89 44 24 10          	mov    %eax,0x10(%esp)
  80115d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  801164:	00 
  801165:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  80116c:	00 
  80116d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801174:	00 
  801175:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  80117c:	e8 87 f2 ff ff       	call   800408 <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801181:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801184:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801187:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80118a:	89 ec                	mov    %ebp,%esp
  80118c:	5d                   	pop    %ebp
  80118d:	c3                   	ret    

0080118e <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80118e:	55                   	push   %ebp
  80118f:	89 e5                	mov    %esp,%ebp
  801191:	83 ec 38             	sub    $0x38,%esp
  801194:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801197:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80119a:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80119d:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011a2:	b8 09 00 00 00       	mov    $0x9,%eax
  8011a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011aa:	8b 55 08             	mov    0x8(%ebp),%edx
  8011ad:	89 df                	mov    %ebx,%edi
  8011af:	89 de                	mov    %ebx,%esi
  8011b1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8011b3:	85 c0                	test   %eax,%eax
  8011b5:	7e 28                	jle    8011df <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8011b7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8011bb:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8011c2:	00 
  8011c3:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  8011ca:	00 
  8011cb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8011d2:	00 
  8011d3:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  8011da:	e8 29 f2 ff ff       	call   800408 <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8011df:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8011e2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8011e5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8011e8:	89 ec                	mov    %ebp,%esp
  8011ea:	5d                   	pop    %ebp
  8011eb:	c3                   	ret    

008011ec <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
  8011ef:	83 ec 38             	sub    $0x38,%esp
  8011f2:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8011f5:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8011f8:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8011fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801200:	b8 08 00 00 00       	mov    $0x8,%eax
  801205:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801208:	8b 55 08             	mov    0x8(%ebp),%edx
  80120b:	89 df                	mov    %ebx,%edi
  80120d:	89 de                	mov    %ebx,%esi
  80120f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  801211:	85 c0                	test   %eax,%eax
  801213:	7e 28                	jle    80123d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801215:	89 44 24 10          	mov    %eax,0x10(%esp)
  801219:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  801220:	00 
  801221:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  801228:	00 
  801229:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801230:	00 
  801231:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  801238:	e8 cb f1 ff ff       	call   800408 <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80123d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801240:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801243:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801246:	89 ec                	mov    %ebp,%esp
  801248:	5d                   	pop    %ebp
  801249:	c3                   	ret    

0080124a <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80124a:	55                   	push   %ebp
  80124b:	89 e5                	mov    %esp,%ebp
  80124d:	83 ec 38             	sub    $0x38,%esp
  801250:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801253:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801256:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801259:	bb 00 00 00 00       	mov    $0x0,%ebx
  80125e:	b8 06 00 00 00       	mov    $0x6,%eax
  801263:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801266:	8b 55 08             	mov    0x8(%ebp),%edx
  801269:	89 df                	mov    %ebx,%edi
  80126b:	89 de                	mov    %ebx,%esi
  80126d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80126f:	85 c0                	test   %eax,%eax
  801271:	7e 28                	jle    80129b <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  801273:	89 44 24 10          	mov    %eax,0x10(%esp)
  801277:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80127e:	00 
  80127f:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  801286:	00 
  801287:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80128e:	00 
  80128f:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  801296:	e8 6d f1 ff ff       	call   800408 <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80129b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80129e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012a1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8012a4:	89 ec                	mov    %ebp,%esp
  8012a6:	5d                   	pop    %ebp
  8012a7:	c3                   	ret    

008012a8 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	83 ec 38             	sub    $0x38,%esp
  8012ae:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8012b1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8012b4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8012b7:	b8 05 00 00 00       	mov    $0x5,%eax
  8012bc:	8b 75 18             	mov    0x18(%ebp),%esi
  8012bf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012c2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8012cb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	7e 28                	jle    8012f9 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8012d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8012d5:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8012dc:	00 
  8012dd:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  8012e4:	00 
  8012e5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8012ec:	00 
  8012ed:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  8012f4:	e8 0f f1 ff ff       	call   800408 <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8012f9:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8012fc:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8012ff:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801302:	89 ec                	mov    %ebp,%esp
  801304:	5d                   	pop    %ebp
  801305:	c3                   	ret    

00801306 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801306:	55                   	push   %ebp
  801307:	89 e5                	mov    %esp,%ebp
  801309:	83 ec 38             	sub    $0x38,%esp
  80130c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80130f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801312:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801315:	be 00 00 00 00       	mov    $0x0,%esi
  80131a:	b8 04 00 00 00       	mov    $0x4,%eax
  80131f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801322:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801325:	8b 55 08             	mov    0x8(%ebp),%edx
  801328:	89 f7                	mov    %esi,%edi
  80132a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80132c:	85 c0                	test   %eax,%eax
  80132e:	7e 28                	jle    801358 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  801330:	89 44 24 10          	mov    %eax,0x10(%esp)
  801334:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80133b:	00 
  80133c:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  801343:	00 
  801344:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80134b:	00 
  80134c:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  801353:	e8 b0 f0 ff ff       	call   800408 <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801358:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80135b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80135e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801361:	89 ec                	mov    %ebp,%esp
  801363:	5d                   	pop    %ebp
  801364:	c3                   	ret    

00801365 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  801365:	55                   	push   %ebp
  801366:	89 e5                	mov    %esp,%ebp
  801368:	83 ec 0c             	sub    $0xc,%esp
  80136b:	89 1c 24             	mov    %ebx,(%esp)
  80136e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801372:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801376:	ba 00 00 00 00       	mov    $0x0,%edx
  80137b:	b8 0b 00 00 00       	mov    $0xb,%eax
  801380:	89 d1                	mov    %edx,%ecx
  801382:	89 d3                	mov    %edx,%ebx
  801384:	89 d7                	mov    %edx,%edi
  801386:	89 d6                	mov    %edx,%esi
  801388:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80138a:	8b 1c 24             	mov    (%esp),%ebx
  80138d:	8b 74 24 04          	mov    0x4(%esp),%esi
  801391:	8b 7c 24 08          	mov    0x8(%esp),%edi
  801395:	89 ec                	mov    %ebp,%esp
  801397:	5d                   	pop    %ebp
  801398:	c3                   	ret    

00801399 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	83 ec 0c             	sub    $0xc,%esp
  80139f:	89 1c 24             	mov    %ebx,(%esp)
  8013a2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8013a6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013aa:	ba 00 00 00 00       	mov    $0x0,%edx
  8013af:	b8 02 00 00 00       	mov    $0x2,%eax
  8013b4:	89 d1                	mov    %edx,%ecx
  8013b6:	89 d3                	mov    %edx,%ebx
  8013b8:	89 d7                	mov    %edx,%edi
  8013ba:	89 d6                	mov    %edx,%esi
  8013bc:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8013be:	8b 1c 24             	mov    (%esp),%ebx
  8013c1:	8b 74 24 04          	mov    0x4(%esp),%esi
  8013c5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8013c9:	89 ec                	mov    %ebp,%esp
  8013cb:	5d                   	pop    %ebp
  8013cc:	c3                   	ret    

008013cd <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8013cd:	55                   	push   %ebp
  8013ce:	89 e5                	mov    %esp,%ebp
  8013d0:	83 ec 38             	sub    $0x38,%esp
  8013d3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8013d6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8013d9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8013dc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013e1:	b8 03 00 00 00       	mov    $0x3,%eax
  8013e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8013e9:	89 cb                	mov    %ecx,%ebx
  8013eb:	89 cf                	mov    %ecx,%edi
  8013ed:	89 ce                	mov    %ecx,%esi
  8013ef:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8013f1:	85 c0                	test   %eax,%eax
  8013f3:	7e 28                	jle    80141d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8013f5:	89 44 24 10          	mov    %eax,0x10(%esp)
  8013f9:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  801400:	00 
  801401:	c7 44 24 08 3f 30 80 	movl   $0x80303f,0x8(%esp)
  801408:	00 
  801409:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  801410:	00 
  801411:	c7 04 24 5c 30 80 00 	movl   $0x80305c,(%esp)
  801418:	e8 eb ef ff ff       	call   800408 <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80141d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801420:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801423:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801426:	89 ec                	mov    %ebp,%esp
  801428:	5d                   	pop    %ebp
  801429:	c3                   	ret    
  80142a:	00 00                	add    %al,(%eax)
  80142c:	00 00                	add    %al,(%eax)
	...

00801430 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801430:	55                   	push   %ebp
  801431:	89 e5                	mov    %esp,%ebp
  801433:	8b 45 08             	mov    0x8(%ebp),%eax
  801436:	05 00 00 00 30       	add    $0x30000000,%eax
  80143b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  80143e:	5d                   	pop    %ebp
  80143f:	c3                   	ret    

00801440 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801440:	55                   	push   %ebp
  801441:	89 e5                	mov    %esp,%ebp
  801443:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  801446:	8b 45 08             	mov    0x8(%ebp),%eax
  801449:	89 04 24             	mov    %eax,(%esp)
  80144c:	e8 df ff ff ff       	call   801430 <fd2num>
  801451:	05 20 00 0d 00       	add    $0xd0020,%eax
  801456:	c1 e0 0c             	shl    $0xc,%eax
}
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	57                   	push   %edi
  80145f:	56                   	push   %esi
  801460:	53                   	push   %ebx
  801461:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  801464:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  801469:	a8 01                	test   $0x1,%al
  80146b:	74 36                	je     8014a3 <fd_alloc+0x48>
  80146d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  801472:	a8 01                	test   $0x1,%al
  801474:	74 2d                	je     8014a3 <fd_alloc+0x48>
  801476:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  80147b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  801480:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801485:	89 c3                	mov    %eax,%ebx
  801487:	89 c2                	mov    %eax,%edx
  801489:	c1 ea 16             	shr    $0x16,%edx
  80148c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  80148f:	f6 c2 01             	test   $0x1,%dl
  801492:	74 14                	je     8014a8 <fd_alloc+0x4d>
  801494:	89 c2                	mov    %eax,%edx
  801496:	c1 ea 0c             	shr    $0xc,%edx
  801499:	8b 14 96             	mov    (%esi,%edx,4),%edx
  80149c:	f6 c2 01             	test   $0x1,%dl
  80149f:	75 10                	jne    8014b1 <fd_alloc+0x56>
  8014a1:	eb 05                	jmp    8014a8 <fd_alloc+0x4d>
  8014a3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  8014a8:	89 1f                	mov    %ebx,(%edi)
  8014aa:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  8014af:	eb 17                	jmp    8014c8 <fd_alloc+0x6d>
  8014b1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  8014b6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8014bb:	75 c8                	jne    801485 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8014bd:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  8014c3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  8014c8:	5b                   	pop    %ebx
  8014c9:	5e                   	pop    %esi
  8014ca:	5f                   	pop    %edi
  8014cb:	5d                   	pop    %ebp
  8014cc:	c3                   	ret    

008014cd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8014d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d3:	83 f8 1f             	cmp    $0x1f,%eax
  8014d6:	77 36                	ja     80150e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8014d8:	05 00 00 0d 00       	add    $0xd0000,%eax
  8014dd:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  8014e0:	89 c2                	mov    %eax,%edx
  8014e2:	c1 ea 16             	shr    $0x16,%edx
  8014e5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8014ec:	f6 c2 01             	test   $0x1,%dl
  8014ef:	74 1d                	je     80150e <fd_lookup+0x41>
  8014f1:	89 c2                	mov    %eax,%edx
  8014f3:	c1 ea 0c             	shr    $0xc,%edx
  8014f6:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014fd:	f6 c2 01             	test   $0x1,%dl
  801500:	74 0c                	je     80150e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  801502:	8b 55 0c             	mov    0xc(%ebp),%edx
  801505:	89 02                	mov    %eax,(%edx)
  801507:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  80150c:	eb 05                	jmp    801513 <fd_lookup+0x46>
  80150e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801513:	5d                   	pop    %ebp
  801514:	c3                   	ret    

00801515 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  801515:	55                   	push   %ebp
  801516:	89 e5                	mov    %esp,%ebp
  801518:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80151b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80151e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801522:	8b 45 08             	mov    0x8(%ebp),%eax
  801525:	89 04 24             	mov    %eax,(%esp)
  801528:	e8 a0 ff ff ff       	call   8014cd <fd_lookup>
  80152d:	85 c0                	test   %eax,%eax
  80152f:	78 0e                	js     80153f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  801531:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801534:	8b 55 0c             	mov    0xc(%ebp),%edx
  801537:	89 50 04             	mov    %edx,0x4(%eax)
  80153a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	56                   	push   %esi
  801545:	53                   	push   %ebx
  801546:	83 ec 10             	sub    $0x10,%esp
  801549:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80154c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  80154f:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  801554:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801559:	be ec 30 80 00       	mov    $0x8030ec,%esi
		if (devtab[i]->dev_id == dev_id) {
  80155e:	39 08                	cmp    %ecx,(%eax)
  801560:	75 10                	jne    801572 <dev_lookup+0x31>
  801562:	eb 04                	jmp    801568 <dev_lookup+0x27>
  801564:	39 08                	cmp    %ecx,(%eax)
  801566:	75 0a                	jne    801572 <dev_lookup+0x31>
			*dev = devtab[i];
  801568:	89 03                	mov    %eax,(%ebx)
  80156a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  80156f:	90                   	nop
  801570:	eb 31                	jmp    8015a3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  801572:	83 c2 01             	add    $0x1,%edx
  801575:	8b 04 96             	mov    (%esi,%edx,4),%eax
  801578:	85 c0                	test   %eax,%eax
  80157a:	75 e8                	jne    801564 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  80157c:	a1 80 74 80 00       	mov    0x807480,%eax
  801581:	8b 40 4c             	mov    0x4c(%eax),%eax
  801584:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801588:	89 44 24 04          	mov    %eax,0x4(%esp)
  80158c:	c7 04 24 6c 30 80 00 	movl   $0x80306c,(%esp)
  801593:	e8 35 ef ff ff       	call   8004cd <cprintf>
	*dev = 0;
  801598:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80159e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  8015a3:	83 c4 10             	add    $0x10,%esp
  8015a6:	5b                   	pop    %ebx
  8015a7:	5e                   	pop    %esi
  8015a8:	5d                   	pop    %ebp
  8015a9:	c3                   	ret    

008015aa <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  8015aa:	55                   	push   %ebp
  8015ab:	89 e5                	mov    %esp,%ebp
  8015ad:	53                   	push   %ebx
  8015ae:	83 ec 24             	sub    $0x24,%esp
  8015b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015be:	89 04 24             	mov    %eax,(%esp)
  8015c1:	e8 07 ff ff ff       	call   8014cd <fd_lookup>
  8015c6:	85 c0                	test   %eax,%eax
  8015c8:	78 53                	js     80161d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d4:	8b 00                	mov    (%eax),%eax
  8015d6:	89 04 24             	mov    %eax,(%esp)
  8015d9:	e8 63 ff ff ff       	call   801541 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015de:	85 c0                	test   %eax,%eax
  8015e0:	78 3b                	js     80161d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  8015e2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ea:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  8015ee:	74 2d                	je     80161d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015f0:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015f3:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015fa:	00 00 00 
	stat->st_isdir = 0;
  8015fd:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801604:	00 00 00 
	stat->st_dev = dev;
  801607:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80160a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801610:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801614:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801617:	89 14 24             	mov    %edx,(%esp)
  80161a:	ff 50 14             	call   *0x14(%eax)
}
  80161d:	83 c4 24             	add    $0x24,%esp
  801620:	5b                   	pop    %ebx
  801621:	5d                   	pop    %ebp
  801622:	c3                   	ret    

00801623 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	53                   	push   %ebx
  801627:	83 ec 24             	sub    $0x24,%esp
  80162a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80162d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801630:	89 44 24 04          	mov    %eax,0x4(%esp)
  801634:	89 1c 24             	mov    %ebx,(%esp)
  801637:	e8 91 fe ff ff       	call   8014cd <fd_lookup>
  80163c:	85 c0                	test   %eax,%eax
  80163e:	78 5f                	js     80169f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801640:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801643:	89 44 24 04          	mov    %eax,0x4(%esp)
  801647:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164a:	8b 00                	mov    (%eax),%eax
  80164c:	89 04 24             	mov    %eax,(%esp)
  80164f:	e8 ed fe ff ff       	call   801541 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801654:	85 c0                	test   %eax,%eax
  801656:	78 47                	js     80169f <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801658:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80165b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  80165f:	75 23                	jne    801684 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  801661:	a1 80 74 80 00       	mov    0x807480,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801666:	8b 40 4c             	mov    0x4c(%eax),%eax
  801669:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80166d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801671:	c7 04 24 8c 30 80 00 	movl   $0x80308c,(%esp)
  801678:	e8 50 ee ff ff       	call   8004cd <cprintf>
  80167d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  801682:	eb 1b                	jmp    80169f <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  801684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801687:	8b 48 18             	mov    0x18(%eax),%ecx
  80168a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80168f:	85 c9                	test   %ecx,%ecx
  801691:	74 0c                	je     80169f <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801693:	8b 45 0c             	mov    0xc(%ebp),%eax
  801696:	89 44 24 04          	mov    %eax,0x4(%esp)
  80169a:	89 14 24             	mov    %edx,(%esp)
  80169d:	ff d1                	call   *%ecx
}
  80169f:	83 c4 24             	add    $0x24,%esp
  8016a2:	5b                   	pop    %ebx
  8016a3:	5d                   	pop    %ebp
  8016a4:	c3                   	ret    

008016a5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	53                   	push   %ebx
  8016a9:	83 ec 24             	sub    $0x24,%esp
  8016ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b6:	89 1c 24             	mov    %ebx,(%esp)
  8016b9:	e8 0f fe ff ff       	call   8014cd <fd_lookup>
  8016be:	85 c0                	test   %eax,%eax
  8016c0:	78 66                	js     801728 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cc:	8b 00                	mov    (%eax),%eax
  8016ce:	89 04 24             	mov    %eax,(%esp)
  8016d1:	e8 6b fe ff ff       	call   801541 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	78 4e                	js     801728 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016da:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016dd:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  8016e1:	75 23                	jne    801706 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  8016e3:	a1 80 74 80 00       	mov    0x807480,%eax
  8016e8:	8b 40 4c             	mov    0x4c(%eax),%eax
  8016eb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016f3:	c7 04 24 b0 30 80 00 	movl   $0x8030b0,(%esp)
  8016fa:	e8 ce ed ff ff       	call   8004cd <cprintf>
  8016ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801704:	eb 22                	jmp    801728 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801709:	8b 48 0c             	mov    0xc(%eax),%ecx
  80170c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801711:	85 c9                	test   %ecx,%ecx
  801713:	74 13                	je     801728 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801715:	8b 45 10             	mov    0x10(%ebp),%eax
  801718:	89 44 24 08          	mov    %eax,0x8(%esp)
  80171c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801723:	89 14 24             	mov    %edx,(%esp)
  801726:	ff d1                	call   *%ecx
}
  801728:	83 c4 24             	add    $0x24,%esp
  80172b:	5b                   	pop    %ebx
  80172c:	5d                   	pop    %ebp
  80172d:	c3                   	ret    

0080172e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	53                   	push   %ebx
  801732:	83 ec 24             	sub    $0x24,%esp
  801735:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801738:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80173b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80173f:	89 1c 24             	mov    %ebx,(%esp)
  801742:	e8 86 fd ff ff       	call   8014cd <fd_lookup>
  801747:	85 c0                	test   %eax,%eax
  801749:	78 6b                	js     8017b6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80174b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80174e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801752:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801755:	8b 00                	mov    (%eax),%eax
  801757:	89 04 24             	mov    %eax,(%esp)
  80175a:	e8 e2 fd ff ff       	call   801541 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80175f:	85 c0                	test   %eax,%eax
  801761:	78 53                	js     8017b6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801763:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801766:	8b 42 08             	mov    0x8(%edx),%eax
  801769:	83 e0 03             	and    $0x3,%eax
  80176c:	83 f8 01             	cmp    $0x1,%eax
  80176f:	75 23                	jne    801794 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  801771:	a1 80 74 80 00       	mov    0x807480,%eax
  801776:	8b 40 4c             	mov    0x4c(%eax),%eax
  801779:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80177d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801781:	c7 04 24 cd 30 80 00 	movl   $0x8030cd,(%esp)
  801788:	e8 40 ed ff ff       	call   8004cd <cprintf>
  80178d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  801792:	eb 22                	jmp    8017b6 <read+0x88>
	}
	if (!dev->dev_read)
  801794:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801797:	8b 48 08             	mov    0x8(%eax),%ecx
  80179a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80179f:	85 c9                	test   %ecx,%ecx
  8017a1:	74 13                	je     8017b6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8017a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017b1:	89 14 24             	mov    %edx,(%esp)
  8017b4:	ff d1                	call   *%ecx
}
  8017b6:	83 c4 24             	add    $0x24,%esp
  8017b9:	5b                   	pop    %ebx
  8017ba:	5d                   	pop    %ebp
  8017bb:	c3                   	ret    

008017bc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8017bc:	55                   	push   %ebp
  8017bd:	89 e5                	mov    %esp,%ebp
  8017bf:	57                   	push   %edi
  8017c0:	56                   	push   %esi
  8017c1:	53                   	push   %ebx
  8017c2:	83 ec 1c             	sub    $0x1c,%esp
  8017c5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8017c8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017cb:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017da:	85 f6                	test   %esi,%esi
  8017dc:	74 29                	je     801807 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017de:	89 f0                	mov    %esi,%eax
  8017e0:	29 d0                	sub    %edx,%eax
  8017e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8017e6:	03 55 0c             	add    0xc(%ebp),%edx
  8017e9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8017ed:	89 3c 24             	mov    %edi,(%esp)
  8017f0:	e8 39 ff ff ff       	call   80172e <read>
		if (m < 0)
  8017f5:	85 c0                	test   %eax,%eax
  8017f7:	78 0e                	js     801807 <readn+0x4b>
			return m;
		if (m == 0)
  8017f9:	85 c0                	test   %eax,%eax
  8017fb:	74 08                	je     801805 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8017fd:	01 c3                	add    %eax,%ebx
  8017ff:	89 da                	mov    %ebx,%edx
  801801:	39 f3                	cmp    %esi,%ebx
  801803:	72 d9                	jb     8017de <readn+0x22>
  801805:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  801807:	83 c4 1c             	add    $0x1c,%esp
  80180a:	5b                   	pop    %ebx
  80180b:	5e                   	pop    %esi
  80180c:	5f                   	pop    %edi
  80180d:	5d                   	pop    %ebp
  80180e:	c3                   	ret    

0080180f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  80180f:	55                   	push   %ebp
  801810:	89 e5                	mov    %esp,%ebp
  801812:	56                   	push   %esi
  801813:	53                   	push   %ebx
  801814:	83 ec 20             	sub    $0x20,%esp
  801817:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80181a:	89 34 24             	mov    %esi,(%esp)
  80181d:	e8 0e fc ff ff       	call   801430 <fd2num>
  801822:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801825:	89 54 24 04          	mov    %edx,0x4(%esp)
  801829:	89 04 24             	mov    %eax,(%esp)
  80182c:	e8 9c fc ff ff       	call   8014cd <fd_lookup>
  801831:	89 c3                	mov    %eax,%ebx
  801833:	85 c0                	test   %eax,%eax
  801835:	78 05                	js     80183c <fd_close+0x2d>
  801837:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  80183a:	74 0c                	je     801848 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  80183c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  801840:	19 c0                	sbb    %eax,%eax
  801842:	f7 d0                	not    %eax
  801844:	21 c3                	and    %eax,%ebx
  801846:	eb 3d                	jmp    801885 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801848:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80184b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80184f:	8b 06                	mov    (%esi),%eax
  801851:	89 04 24             	mov    %eax,(%esp)
  801854:	e8 e8 fc ff ff       	call   801541 <dev_lookup>
  801859:	89 c3                	mov    %eax,%ebx
  80185b:	85 c0                	test   %eax,%eax
  80185d:	78 16                	js     801875 <fd_close+0x66>
		if (dev->dev_close)
  80185f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801862:	8b 40 10             	mov    0x10(%eax),%eax
  801865:	bb 00 00 00 00       	mov    $0x0,%ebx
  80186a:	85 c0                	test   %eax,%eax
  80186c:	74 07                	je     801875 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  80186e:	89 34 24             	mov    %esi,(%esp)
  801871:	ff d0                	call   *%eax
  801873:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  801875:	89 74 24 04          	mov    %esi,0x4(%esp)
  801879:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801880:	e8 c5 f9 ff ff       	call   80124a <sys_page_unmap>
	return r;
}
  801885:	89 d8                	mov    %ebx,%eax
  801887:	83 c4 20             	add    $0x20,%esp
  80188a:	5b                   	pop    %ebx
  80188b:	5e                   	pop    %esi
  80188c:	5d                   	pop    %ebp
  80188d:	c3                   	ret    

0080188e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801894:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801897:	89 44 24 04          	mov    %eax,0x4(%esp)
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	89 04 24             	mov    %eax,(%esp)
  8018a1:	e8 27 fc ff ff       	call   8014cd <fd_lookup>
  8018a6:	85 c0                	test   %eax,%eax
  8018a8:	78 13                	js     8018bd <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  8018aa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8018b1:	00 
  8018b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018b5:	89 04 24             	mov    %eax,(%esp)
  8018b8:	e8 52 ff ff ff       	call   80180f <fd_close>
}
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	83 ec 18             	sub    $0x18,%esp
  8018c5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8018c8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8018d2:	00 
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	89 04 24             	mov    %eax,(%esp)
  8018d9:	e8 a9 03 00 00       	call   801c87 <open>
  8018de:	89 c3                	mov    %eax,%ebx
  8018e0:	85 c0                	test   %eax,%eax
  8018e2:	78 1b                	js     8018ff <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  8018e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018eb:	89 1c 24             	mov    %ebx,(%esp)
  8018ee:	e8 b7 fc ff ff       	call   8015aa <fstat>
  8018f3:	89 c6                	mov    %eax,%esi
	close(fd);
  8018f5:	89 1c 24             	mov    %ebx,(%esp)
  8018f8:	e8 91 ff ff ff       	call   80188e <close>
  8018fd:	89 f3                	mov    %esi,%ebx
	return r;
}
  8018ff:	89 d8                	mov    %ebx,%eax
  801901:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801904:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801907:	89 ec                	mov    %ebp,%esp
  801909:	5d                   	pop    %ebp
  80190a:	c3                   	ret    

0080190b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
  80190e:	53                   	push   %ebx
  80190f:	83 ec 14             	sub    $0x14,%esp
  801912:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801917:	89 1c 24             	mov    %ebx,(%esp)
  80191a:	e8 6f ff ff ff       	call   80188e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80191f:	83 c3 01             	add    $0x1,%ebx
  801922:	83 fb 20             	cmp    $0x20,%ebx
  801925:	75 f0                	jne    801917 <close_all+0xc>
		close(i);
}
  801927:	83 c4 14             	add    $0x14,%esp
  80192a:	5b                   	pop    %ebx
  80192b:	5d                   	pop    %ebp
  80192c:	c3                   	ret    

0080192d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	83 ec 58             	sub    $0x58,%esp
  801933:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801936:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801939:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80193c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80193f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801942:	89 44 24 04          	mov    %eax,0x4(%esp)
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	89 04 24             	mov    %eax,(%esp)
  80194c:	e8 7c fb ff ff       	call   8014cd <fd_lookup>
  801951:	89 c3                	mov    %eax,%ebx
  801953:	85 c0                	test   %eax,%eax
  801955:	0f 88 e0 00 00 00    	js     801a3b <dup+0x10e>
		return r;
	close(newfdnum);
  80195b:	89 3c 24             	mov    %edi,(%esp)
  80195e:	e8 2b ff ff ff       	call   80188e <close>

	newfd = INDEX2FD(newfdnum);
  801963:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801969:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80196c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80196f:	89 04 24             	mov    %eax,(%esp)
  801972:	e8 c9 fa ff ff       	call   801440 <fd2data>
  801977:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801979:	89 34 24             	mov    %esi,(%esp)
  80197c:	e8 bf fa ff ff       	call   801440 <fd2data>
  801981:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801984:	89 da                	mov    %ebx,%edx
  801986:	89 d8                	mov    %ebx,%eax
  801988:	c1 e8 16             	shr    $0x16,%eax
  80198b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801992:	a8 01                	test   $0x1,%al
  801994:	74 43                	je     8019d9 <dup+0xac>
  801996:	c1 ea 0c             	shr    $0xc,%edx
  801999:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8019a0:	a8 01                	test   $0x1,%al
  8019a2:	74 35                	je     8019d9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  8019a4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8019ab:	25 07 0e 00 00       	and    $0xe07,%eax
  8019b0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8019b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8019b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8019bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019c2:	00 
  8019c3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8019c7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8019ce:	e8 d5 f8 ff ff       	call   8012a8 <sys_page_map>
  8019d3:	89 c3                	mov    %eax,%ebx
  8019d5:	85 c0                	test   %eax,%eax
  8019d7:	78 3f                	js     801a18 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  8019d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8019dc:	89 c2                	mov    %eax,%edx
  8019de:	c1 ea 0c             	shr    $0xc,%edx
  8019e1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8019e8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8019ee:	89 54 24 10          	mov    %edx,0x10(%esp)
  8019f2:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8019f6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8019fd:	00 
  8019fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a02:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a09:	e8 9a f8 ff ff       	call   8012a8 <sys_page_map>
  801a0e:	89 c3                	mov    %eax,%ebx
  801a10:	85 c0                	test   %eax,%eax
  801a12:	78 04                	js     801a18 <dup+0xeb>
  801a14:	89 fb                	mov    %edi,%ebx
  801a16:	eb 23                	jmp    801a3b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801a18:	89 74 24 04          	mov    %esi,0x4(%esp)
  801a1c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a23:	e8 22 f8 ff ff       	call   80124a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801a28:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801a2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a2f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a36:	e8 0f f8 ff ff       	call   80124a <sys_page_unmap>
	return r;
}
  801a3b:	89 d8                	mov    %ebx,%eax
  801a3d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a40:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a43:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a46:	89 ec                	mov    %ebp,%esp
  801a48:	5d                   	pop    %ebp
  801a49:	c3                   	ret    
	...

00801a4c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a4c:	55                   	push   %ebp
  801a4d:	89 e5                	mov    %esp,%ebp
  801a4f:	53                   	push   %ebx
  801a50:	83 ec 14             	sub    $0x14,%esp
  801a53:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a55:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  801a5b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801a62:	00 
  801a63:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  801a6a:	00 
  801a6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a6f:	89 14 24             	mov    %edx,(%esp)
  801a72:	e8 89 0e 00 00       	call   802900 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801a77:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801a7e:	00 
  801a7f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801a83:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801a8a:	e8 d3 0e 00 00       	call   802962 <ipc_recv>
}
  801a8f:	83 c4 14             	add    $0x14,%esp
  801a92:	5b                   	pop    %ebx
  801a93:	5d                   	pop    %ebp
  801a94:	c3                   	ret    

00801a95 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
  801a98:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9e:	8b 40 0c             	mov    0xc(%eax),%eax
  801aa1:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  801aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aa9:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801aae:	ba 00 00 00 00       	mov    $0x0,%edx
  801ab3:	b8 02 00 00 00       	mov    $0x2,%eax
  801ab8:	e8 8f ff ff ff       	call   801a4c <fsipc>
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801ac5:	ba 00 00 00 00       	mov    $0x0,%edx
  801aca:	b8 08 00 00 00       	mov    $0x8,%eax
  801acf:	e8 78 ff ff ff       	call   801a4c <fsipc>
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	53                   	push   %ebx
  801ada:	83 ec 14             	sub    $0x14,%esp
  801add:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae3:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae6:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  801af0:	b8 05 00 00 00       	mov    $0x5,%eax
  801af5:	e8 52 ff ff ff       	call   801a4c <fsipc>
  801afa:	85 c0                	test   %eax,%eax
  801afc:	78 2b                	js     801b29 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801afe:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801b05:	00 
  801b06:	89 1c 24             	mov    %ebx,(%esp)
  801b09:	e8 9c f0 ff ff       	call   800baa <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b0e:	a1 80 40 80 00       	mov    0x804080,%eax
  801b13:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801b19:	a1 84 40 80 00       	mov    0x804084,%eax
  801b1e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801b24:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801b29:	83 c4 14             	add    $0x14,%esp
  801b2c:	5b                   	pop    %ebx
  801b2d:	5d                   	pop    %ebp
  801b2e:	c3                   	ret    

00801b2f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  801b35:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801b3c:	00 
  801b3d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b44:	00 
  801b45:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801b4c:	e8 b5 f1 ff ff       	call   800d06 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	8b 40 0c             	mov    0xc(%eax),%eax
  801b57:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  801b5c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b61:	b8 06 00 00 00       	mov    $0x6,%eax
  801b66:	e8 e1 fe ff ff       	call   801a4c <fsipc>
}
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
  801b70:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801b73:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801b7a:	00 
  801b7b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801b82:	00 
  801b83:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801b8a:	e8 77 f1 ff ff       	call   800d06 <memset>
  801b8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b92:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  801b97:	76 05                	jbe    801b9e <devfile_write+0x31>
  801b99:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b9e:	8b 55 08             	mov    0x8(%ebp),%edx
  801ba1:	8b 52 0c             	mov    0xc(%edx),%edx
  801ba4:	89 15 00 40 80 00    	mov    %edx,0x804000
        fsipcbuf.write.req_n = numberOfBytes;
  801baa:	a3 04 40 80 00       	mov    %eax,0x804004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  801baf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801bb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801bba:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  801bc1:	e8 9f f1 ff ff       	call   800d65 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  801bc6:	ba 00 00 00 00       	mov    $0x0,%edx
  801bcb:	b8 04 00 00 00       	mov    $0x4,%eax
  801bd0:	e8 77 fe ff ff       	call   801a4c <fsipc>
              return r;
        return r;
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
  801bda:	53                   	push   %ebx
  801bdb:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  801bde:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801be5:	00 
  801be6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801bed:	00 
  801bee:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801bf5:	e8 0c f1 ff ff       	call   800d06 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  801bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfd:	8b 40 0c             	mov    0xc(%eax),%eax
  801c00:	a3 00 40 80 00       	mov    %eax,0x804000
        fsipcbuf.read.req_n = n;
  801c05:	8b 45 10             	mov    0x10(%ebp),%eax
  801c08:	a3 04 40 80 00       	mov    %eax,0x804004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  801c0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801c12:	b8 03 00 00 00       	mov    $0x3,%eax
  801c17:	e8 30 fe ff ff       	call   801a4c <fsipc>
  801c1c:	89 c3                	mov    %eax,%ebx
  801c1e:	85 c0                	test   %eax,%eax
  801c20:	78 17                	js     801c39 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  801c22:	89 44 24 08          	mov    %eax,0x8(%esp)
  801c26:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801c2d:	00 
  801c2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c31:	89 04 24             	mov    %eax,(%esp)
  801c34:	e8 2c f1 ff ff       	call   800d65 <memmove>
        return r;
}
  801c39:	89 d8                	mov    %ebx,%eax
  801c3b:	83 c4 14             	add    $0x14,%esp
  801c3e:	5b                   	pop    %ebx
  801c3f:	5d                   	pop    %ebp
  801c40:	c3                   	ret    

00801c41 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801c41:	55                   	push   %ebp
  801c42:	89 e5                	mov    %esp,%ebp
  801c44:	53                   	push   %ebx
  801c45:	83 ec 14             	sub    $0x14,%esp
  801c48:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  801c4b:	89 1c 24             	mov    %ebx,(%esp)
  801c4e:	e8 0d ef ff ff       	call   800b60 <strlen>
  801c53:	89 c2                	mov    %eax,%edx
  801c55:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  801c5a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801c60:	7f 1f                	jg     801c81 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801c62:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801c66:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801c6d:	e8 38 ef ff ff       	call   800baa <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801c72:	ba 00 00 00 00       	mov    $0x0,%edx
  801c77:	b8 07 00 00 00       	mov    $0x7,%eax
  801c7c:	e8 cb fd ff ff       	call   801a4c <fsipc>
}
  801c81:	83 c4 14             	add    $0x14,%esp
  801c84:	5b                   	pop    %ebx
  801c85:	5d                   	pop    %ebp
  801c86:	c3                   	ret    

00801c87 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	56                   	push   %esi
  801c8b:	53                   	push   %ebx
  801c8c:	83 ec 20             	sub    $0x20,%esp
  801c8f:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  801c92:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801c99:	00 
  801c9a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801ca1:	00 
  801ca2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801ca9:	e8 58 f0 ff ff       	call   800d06 <memset>
    if(strlen(path)>=MAXPATHLEN)
  801cae:	89 34 24             	mov    %esi,(%esp)
  801cb1:	e8 aa ee ff ff       	call   800b60 <strlen>
  801cb6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801cbb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cc0:	0f 8f 84 00 00 00    	jg     801d4a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  801cc6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cc9:	89 04 24             	mov    %eax,(%esp)
  801ccc:	e8 8a f7 ff ff       	call   80145b <fd_alloc>
  801cd1:	89 c3                	mov    %eax,%ebx
  801cd3:	85 c0                	test   %eax,%eax
  801cd5:	78 73                	js     801d4a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  801cd7:	0f b6 06             	movzbl (%esi),%eax
  801cda:	84 c0                	test   %al,%al
  801cdc:	74 20                	je     801cfe <open+0x77>
  801cde:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  801ce0:	0f be c0             	movsbl %al,%eax
  801ce3:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ce7:	c7 04 24 00 31 80 00 	movl   $0x803100,(%esp)
  801cee:	e8 da e7 ff ff       	call   8004cd <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  801cf3:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  801cf7:	83 c3 01             	add    $0x1,%ebx
  801cfa:	84 c0                	test   %al,%al
  801cfc:	75 e2                	jne    801ce0 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  801cfe:	89 74 24 04          	mov    %esi,0x4(%esp)
  801d02:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801d09:	e8 9c ee ff ff       	call   800baa <strcpy>
    fsipcbuf.open.req_omode = mode;
  801d0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d11:	a3 00 44 80 00       	mov    %eax,0x804400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  801d16:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d19:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1e:	e8 29 fd ff ff       	call   801a4c <fsipc>
  801d23:	89 c3                	mov    %eax,%ebx
  801d25:	85 c0                	test   %eax,%eax
  801d27:	79 15                	jns    801d3e <open+0xb7>
        {
            fd_close(fd,1);
  801d29:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801d30:	00 
  801d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d34:	89 04 24             	mov    %eax,(%esp)
  801d37:	e8 d3 fa ff ff       	call   80180f <fd_close>
             return r;
  801d3c:	eb 0c                	jmp    801d4a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  801d3e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801d41:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  801d47:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  801d4a:	89 d8                	mov    %ebx,%eax
  801d4c:	83 c4 20             	add    $0x20,%esp
  801d4f:	5b                   	pop    %ebx
  801d50:	5e                   	pop    %esi
  801d51:	5d                   	pop    %ebp
  801d52:	c3                   	ret    
	...

00801d54 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
  801d57:	53                   	push   %ebx
  801d58:	83 ec 14             	sub    $0x14,%esp
  801d5b:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  801d5d:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801d61:	7e 34                	jle    801d97 <writebuf+0x43>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801d63:	8b 40 04             	mov    0x4(%eax),%eax
  801d66:	89 44 24 08          	mov    %eax,0x8(%esp)
  801d6a:	8d 43 10             	lea    0x10(%ebx),%eax
  801d6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d71:	8b 03                	mov    (%ebx),%eax
  801d73:	89 04 24             	mov    %eax,(%esp)
  801d76:	e8 2a f9 ff ff       	call   8016a5 <write>
		if (result > 0)
  801d7b:	85 c0                	test   %eax,%eax
  801d7d:	7e 03                	jle    801d82 <writebuf+0x2e>
			b->result += result;
  801d7f:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801d82:	3b 43 04             	cmp    0x4(%ebx),%eax
  801d85:	74 10                	je     801d97 <writebuf+0x43>
			b->error = (result < 0 ? result : 0);
  801d87:	85 c0                	test   %eax,%eax
  801d89:	0f 9f c2             	setg   %dl
  801d8c:	0f b6 d2             	movzbl %dl,%edx
  801d8f:	83 ea 01             	sub    $0x1,%edx
  801d92:	21 d0                	and    %edx,%eax
  801d94:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  801d97:	83 c4 14             	add    $0x14,%esp
  801d9a:	5b                   	pop    %ebx
  801d9b:	5d                   	pop    %ebp
  801d9c:	c3                   	ret    

00801d9d <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  801da6:	8b 45 08             	mov    0x8(%ebp),%eax
  801da9:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801daf:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801db6:	00 00 00 
	b.result = 0;
  801db9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801dc0:	00 00 00 
	b.error = 1;
  801dc3:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  801dca:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801dcd:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dd7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ddb:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801de1:	89 44 24 04          	mov    %eax,0x4(%esp)
  801de5:	c7 04 24 5a 1e 80 00 	movl   $0x801e5a,(%esp)
  801dec:	e8 8c e8 ff ff       	call   80067d <vprintfmt>
	if (b.idx > 0)
  801df1:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801df8:	7e 0b                	jle    801e05 <vfprintf+0x68>
		writebuf(&b);
  801dfa:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801e00:	e8 4f ff ff ff       	call   801d54 <writebuf>

	return (b.result ? b.result : b.error);
  801e05:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801e0b:	85 c0                	test   %eax,%eax
  801e0d:	75 06                	jne    801e15 <vfprintf+0x78>
  801e0f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801e15:	c9                   	leave  
  801e16:	c3                   	ret    

00801e17 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  801e17:	55                   	push   %ebp
  801e18:	89 e5                	mov    %esp,%ebp
  801e1a:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  801e1d:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  801e20:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e24:	8b 45 08             	mov    0x8(%ebp),%eax
  801e27:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e2b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801e32:	e8 66 ff ff ff       	call   801d9d <vfprintf>
	va_end(ap);

	return cnt;
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
  801e3c:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  801e3f:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  801e42:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e46:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e49:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e50:	89 04 24             	mov    %eax,(%esp)
  801e53:	e8 45 ff ff ff       	call   801d9d <vfprintf>
	va_end(ap);

	return cnt;
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	53                   	push   %ebx
  801e5e:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  801e61:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801e64:	8b 43 04             	mov    0x4(%ebx),%eax
  801e67:	8b 55 08             	mov    0x8(%ebp),%edx
  801e6a:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  801e6e:	83 c0 01             	add    $0x1,%eax
  801e71:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801e74:	3d 00 01 00 00       	cmp    $0x100,%eax
  801e79:	75 0e                	jne    801e89 <putch+0x2f>
		writebuf(b);
  801e7b:	89 d8                	mov    %ebx,%eax
  801e7d:	e8 d2 fe ff ff       	call   801d54 <writebuf>
		b->idx = 0;
  801e82:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801e89:	83 c4 04             	add    $0x4,%esp
  801e8c:	5b                   	pop    %ebx
  801e8d:	5d                   	pop    %ebp
  801e8e:	c3                   	ret    
	...

00801e90 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801e90:	55                   	push   %ebp
  801e91:	89 e5                	mov    %esp,%ebp
  801e93:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801e96:	c7 44 24 04 03 31 80 	movl   $0x803103,0x4(%esp)
  801e9d:	00 
  801e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ea1:	89 04 24             	mov    %eax,(%esp)
  801ea4:	e8 01 ed ff ff       	call   800baa <strcpy>
	return 0;
}
  801ea9:	b8 00 00 00 00       	mov    $0x0,%eax
  801eae:	c9                   	leave  
  801eaf:	c3                   	ret    

00801eb0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  801eb0:	55                   	push   %ebp
  801eb1:	89 e5                	mov    %esp,%ebp
  801eb3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  801eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb9:	8b 40 0c             	mov    0xc(%eax),%eax
  801ebc:	89 04 24             	mov    %eax,(%esp)
  801ebf:	e8 9e 02 00 00       	call   802162 <nsipc_close>
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
  801ec9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  801ecc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801ed3:	00 
  801ed4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ed7:	89 44 24 08          	mov    %eax,0x8(%esp)
  801edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ede:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee5:	8b 40 0c             	mov    0xc(%eax),%eax
  801ee8:	89 04 24             	mov    %eax,(%esp)
  801eeb:	e8 ae 02 00 00       	call   80219e <nsipc_send>
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801ef8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801eff:	00 
  801f00:	8b 45 10             	mov    0x10(%ebp),%eax
  801f03:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f07:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f11:	8b 40 0c             	mov    0xc(%eax),%eax
  801f14:	89 04 24             	mov    %eax,(%esp)
  801f17:	e8 f5 02 00 00       	call   802211 <nsipc_recv>
}
  801f1c:	c9                   	leave  
  801f1d:	c3                   	ret    

00801f1e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  801f1e:	55                   	push   %ebp
  801f1f:	89 e5                	mov    %esp,%ebp
  801f21:	56                   	push   %esi
  801f22:	53                   	push   %ebx
  801f23:	83 ec 20             	sub    $0x20,%esp
  801f26:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f28:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f2b:	89 04 24             	mov    %eax,(%esp)
  801f2e:	e8 28 f5 ff ff       	call   80145b <fd_alloc>
  801f33:	89 c3                	mov    %eax,%ebx
  801f35:	85 c0                	test   %eax,%eax
  801f37:	78 21                	js     801f5a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801f39:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801f40:	00 
  801f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f44:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801f4f:	e8 b2 f3 ff ff       	call   801306 <sys_page_alloc>
  801f54:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801f56:	85 c0                	test   %eax,%eax
  801f58:	79 0a                	jns    801f64 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  801f5a:	89 34 24             	mov    %esi,(%esp)
  801f5d:	e8 00 02 00 00       	call   802162 <nsipc_close>
		return r;
  801f62:	eb 28                	jmp    801f8c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801f64:	8b 15 20 70 80 00    	mov    0x807020,%edx
  801f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  801f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f72:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  801f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f82:	89 04 24             	mov    %eax,(%esp)
  801f85:	e8 a6 f4 ff ff       	call   801430 <fd2num>
  801f8a:	89 c3                	mov    %eax,%ebx
}
  801f8c:	89 d8                	mov    %ebx,%eax
  801f8e:	83 c4 20             	add    $0x20,%esp
  801f91:	5b                   	pop    %ebx
  801f92:	5e                   	pop    %esi
  801f93:	5d                   	pop    %ebp
  801f94:	c3                   	ret    

00801f95 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801f95:	55                   	push   %ebp
  801f96:	89 e5                	mov    %esp,%ebp
  801f98:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  801f9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801f9e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fa9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fac:	89 04 24             	mov    %eax,(%esp)
  801faf:	e8 62 01 00 00       	call   802116 <nsipc_socket>
  801fb4:	85 c0                	test   %eax,%eax
  801fb6:	78 05                	js     801fbd <socket+0x28>
		return r;
	return alloc_sockfd(r);
  801fb8:	e8 61 ff ff ff       	call   801f1e <alloc_sockfd>
}
  801fbd:	c9                   	leave  
  801fbe:	66 90                	xchg   %ax,%ax
  801fc0:	c3                   	ret    

00801fc1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  801fc1:	55                   	push   %ebp
  801fc2:	89 e5                	mov    %esp,%ebp
  801fc4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  801fc7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  801fca:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fce:	89 04 24             	mov    %eax,(%esp)
  801fd1:	e8 f7 f4 ff ff       	call   8014cd <fd_lookup>
  801fd6:	85 c0                	test   %eax,%eax
  801fd8:	78 15                	js     801fef <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  801fda:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fdd:	8b 0a                	mov    (%edx),%ecx
  801fdf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801fe4:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  801fea:	75 03                	jne    801fef <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  801fec:	8b 42 0c             	mov    0xc(%edx),%eax
}
  801fef:	c9                   	leave  
  801ff0:	c3                   	ret    

00801ff1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
  801ff4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffa:	e8 c2 ff ff ff       	call   801fc1 <fd2sockid>
  801fff:	85 c0                	test   %eax,%eax
  802001:	78 0f                	js     802012 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  802003:	8b 55 0c             	mov    0xc(%ebp),%edx
  802006:	89 54 24 04          	mov    %edx,0x4(%esp)
  80200a:	89 04 24             	mov    %eax,(%esp)
  80200d:	e8 2e 01 00 00       	call   802140 <nsipc_listen>
}
  802012:	c9                   	leave  
  802013:	c3                   	ret    

00802014 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802014:	55                   	push   %ebp
  802015:	89 e5                	mov    %esp,%ebp
  802017:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80201a:	8b 45 08             	mov    0x8(%ebp),%eax
  80201d:	e8 9f ff ff ff       	call   801fc1 <fd2sockid>
  802022:	85 c0                	test   %eax,%eax
  802024:	78 16                	js     80203c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  802026:	8b 55 10             	mov    0x10(%ebp),%edx
  802029:	89 54 24 08          	mov    %edx,0x8(%esp)
  80202d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802030:	89 54 24 04          	mov    %edx,0x4(%esp)
  802034:	89 04 24             	mov    %eax,(%esp)
  802037:	e8 55 02 00 00       	call   802291 <nsipc_connect>
}
  80203c:	c9                   	leave  
  80203d:	c3                   	ret    

0080203e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80203e:	55                   	push   %ebp
  80203f:	89 e5                	mov    %esp,%ebp
  802041:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802044:	8b 45 08             	mov    0x8(%ebp),%eax
  802047:	e8 75 ff ff ff       	call   801fc1 <fd2sockid>
  80204c:	85 c0                	test   %eax,%eax
  80204e:	78 0f                	js     80205f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  802050:	8b 55 0c             	mov    0xc(%ebp),%edx
  802053:	89 54 24 04          	mov    %edx,0x4(%esp)
  802057:	89 04 24             	mov    %eax,(%esp)
  80205a:	e8 1d 01 00 00       	call   80217c <nsipc_shutdown>
}
  80205f:	c9                   	leave  
  802060:	c3                   	ret    

00802061 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  802061:	55                   	push   %ebp
  802062:	89 e5                	mov    %esp,%ebp
  802064:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802067:	8b 45 08             	mov    0x8(%ebp),%eax
  80206a:	e8 52 ff ff ff       	call   801fc1 <fd2sockid>
  80206f:	85 c0                	test   %eax,%eax
  802071:	78 16                	js     802089 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  802073:	8b 55 10             	mov    0x10(%ebp),%edx
  802076:	89 54 24 08          	mov    %edx,0x8(%esp)
  80207a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80207d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802081:	89 04 24             	mov    %eax,(%esp)
  802084:	e8 47 02 00 00       	call   8022d0 <nsipc_bind>
}
  802089:	c9                   	leave  
  80208a:	c3                   	ret    

0080208b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  802091:	8b 45 08             	mov    0x8(%ebp),%eax
  802094:	e8 28 ff ff ff       	call   801fc1 <fd2sockid>
  802099:	85 c0                	test   %eax,%eax
  80209b:	78 1f                	js     8020bc <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80209d:	8b 55 10             	mov    0x10(%ebp),%edx
  8020a0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8020a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020a7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8020ab:	89 04 24             	mov    %eax,(%esp)
  8020ae:	e8 5c 02 00 00       	call   80230f <nsipc_accept>
  8020b3:	85 c0                	test   %eax,%eax
  8020b5:	78 05                	js     8020bc <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8020b7:	e8 62 fe ff ff       	call   801f1e <alloc_sockfd>
}
  8020bc:	c9                   	leave  
  8020bd:	8d 76 00             	lea    0x0(%esi),%esi
  8020c0:	c3                   	ret    
	...

008020d0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8020d0:	55                   	push   %ebp
  8020d1:	89 e5                	mov    %esp,%ebp
  8020d3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8020d6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8020dc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8020e3:	00 
  8020e4:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8020eb:	00 
  8020ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020f0:	89 14 24             	mov    %edx,(%esp)
  8020f3:	e8 08 08 00 00       	call   802900 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8020f8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8020ff:	00 
  802100:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  802107:	00 
  802108:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80210f:	e8 4e 08 00 00       	call   802962 <ipc_recv>
}
  802114:	c9                   	leave  
  802115:	c3                   	ret    

00802116 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  802116:	55                   	push   %ebp
  802117:	89 e5                	mov    %esp,%ebp
  802119:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80211c:	8b 45 08             	mov    0x8(%ebp),%eax
  80211f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  802124:	8b 45 0c             	mov    0xc(%ebp),%eax
  802127:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80212c:	8b 45 10             	mov    0x10(%ebp),%eax
  80212f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  802134:	b8 09 00 00 00       	mov    $0x9,%eax
  802139:	e8 92 ff ff ff       	call   8020d0 <nsipc>
}
  80213e:	c9                   	leave  
  80213f:	c3                   	ret    

00802140 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80214e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802151:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  802156:	b8 06 00 00 00       	mov    $0x6,%eax
  80215b:	e8 70 ff ff ff       	call   8020d0 <nsipc>
}
  802160:	c9                   	leave  
  802161:	c3                   	ret    

00802162 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  802162:	55                   	push   %ebp
  802163:	89 e5                	mov    %esp,%ebp
  802165:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  802170:	b8 04 00 00 00       	mov    $0x4,%eax
  802175:	e8 56 ff ff ff       	call   8020d0 <nsipc>
}
  80217a:	c9                   	leave  
  80217b:	c3                   	ret    

0080217c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80217c:	55                   	push   %ebp
  80217d:	89 e5                	mov    %esp,%ebp
  80217f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  802182:	8b 45 08             	mov    0x8(%ebp),%eax
  802185:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80218a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80218d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  802192:	b8 03 00 00 00       	mov    $0x3,%eax
  802197:	e8 34 ff ff ff       	call   8020d0 <nsipc>
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
  8021a1:	53                   	push   %ebx
  8021a2:	83 ec 14             	sub    $0x14,%esp
  8021a5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8021b0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8021b6:	7e 24                	jle    8021dc <nsipc_send+0x3e>
  8021b8:	c7 44 24 0c 0f 31 80 	movl   $0x80310f,0xc(%esp)
  8021bf:	00 
  8021c0:	c7 44 24 08 1b 31 80 	movl   $0x80311b,0x8(%esp)
  8021c7:	00 
  8021c8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8021cf:	00 
  8021d0:	c7 04 24 30 31 80 00 	movl   $0x803130,(%esp)
  8021d7:	e8 2c e2 ff ff       	call   800408 <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8021dc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8021e7:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8021ee:	e8 72 eb ff ff       	call   800d65 <memmove>
	nsipcbuf.send.req_size = size;
  8021f3:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  8021f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8021fc:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  802201:	b8 08 00 00 00       	mov    $0x8,%eax
  802206:	e8 c5 fe ff ff       	call   8020d0 <nsipc>
}
  80220b:	83 c4 14             	add    $0x14,%esp
  80220e:	5b                   	pop    %ebx
  80220f:	5d                   	pop    %ebp
  802210:	c3                   	ret    

00802211 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  802211:	55                   	push   %ebp
  802212:	89 e5                	mov    %esp,%ebp
  802214:	56                   	push   %esi
  802215:	53                   	push   %ebx
  802216:	83 ec 10             	sub    $0x10,%esp
  802219:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  802224:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80222a:	8b 45 14             	mov    0x14(%ebp),%eax
  80222d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  802232:	b8 07 00 00 00       	mov    $0x7,%eax
  802237:	e8 94 fe ff ff       	call   8020d0 <nsipc>
  80223c:	89 c3                	mov    %eax,%ebx
  80223e:	85 c0                	test   %eax,%eax
  802240:	78 46                	js     802288 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  802242:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  802247:	7f 04                	jg     80224d <nsipc_recv+0x3c>
  802249:	39 c6                	cmp    %eax,%esi
  80224b:	7d 24                	jge    802271 <nsipc_recv+0x60>
  80224d:	c7 44 24 0c 3c 31 80 	movl   $0x80313c,0xc(%esp)
  802254:	00 
  802255:	c7 44 24 08 1b 31 80 	movl   $0x80311b,0x8(%esp)
  80225c:	00 
  80225d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  802264:	00 
  802265:	c7 04 24 30 31 80 00 	movl   $0x803130,(%esp)
  80226c:	e8 97 e1 ff ff       	call   800408 <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  802271:	89 44 24 08          	mov    %eax,0x8(%esp)
  802275:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80227c:	00 
  80227d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802280:	89 04 24             	mov    %eax,(%esp)
  802283:	e8 dd ea ff ff       	call   800d65 <memmove>
	}

	return r;
}
  802288:	89 d8                	mov    %ebx,%eax
  80228a:	83 c4 10             	add    $0x10,%esp
  80228d:	5b                   	pop    %ebx
  80228e:	5e                   	pop    %esi
  80228f:	5d                   	pop    %ebp
  802290:	c3                   	ret    

00802291 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	53                   	push   %ebx
  802295:	83 ec 14             	sub    $0x14,%esp
  802298:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80229b:	8b 45 08             	mov    0x8(%ebp),%eax
  80229e:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8022a3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ae:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8022b5:	e8 ab ea ff ff       	call   800d65 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8022ba:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8022c0:	b8 05 00 00 00       	mov    $0x5,%eax
  8022c5:	e8 06 fe ff ff       	call   8020d0 <nsipc>
}
  8022ca:	83 c4 14             	add    $0x14,%esp
  8022cd:	5b                   	pop    %ebx
  8022ce:	5d                   	pop    %ebp
  8022cf:	c3                   	ret    

008022d0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8022d0:	55                   	push   %ebp
  8022d1:	89 e5                	mov    %esp,%ebp
  8022d3:	53                   	push   %ebx
  8022d4:	83 ec 14             	sub    $0x14,%esp
  8022d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8022e2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022ed:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8022f4:	e8 6c ea ff ff       	call   800d65 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8022f9:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  8022ff:	b8 02 00 00 00       	mov    $0x2,%eax
  802304:	e8 c7 fd ff ff       	call   8020d0 <nsipc>
}
  802309:	83 c4 14             	add    $0x14,%esp
  80230c:	5b                   	pop    %ebx
  80230d:	5d                   	pop    %ebp
  80230e:	c3                   	ret    

0080230f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80230f:	55                   	push   %ebp
  802310:	89 e5                	mov    %esp,%ebp
  802312:	83 ec 18             	sub    $0x18,%esp
  802315:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802318:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  802323:	b8 01 00 00 00       	mov    $0x1,%eax
  802328:	e8 a3 fd ff ff       	call   8020d0 <nsipc>
  80232d:	89 c3                	mov    %eax,%ebx
  80232f:	85 c0                	test   %eax,%eax
  802331:	78 25                	js     802358 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  802333:	be 10 60 80 00       	mov    $0x806010,%esi
  802338:	8b 06                	mov    (%esi),%eax
  80233a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80233e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  802345:	00 
  802346:	8b 45 0c             	mov    0xc(%ebp),%eax
  802349:	89 04 24             	mov    %eax,(%esp)
  80234c:	e8 14 ea ff ff       	call   800d65 <memmove>
		*addrlen = ret->ret_addrlen;
  802351:	8b 16                	mov    (%esi),%edx
  802353:	8b 45 10             	mov    0x10(%ebp),%eax
  802356:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  802358:	89 d8                	mov    %ebx,%eax
  80235a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80235d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802360:	89 ec                	mov    %ebp,%esp
  802362:	5d                   	pop    %ebp
  802363:	c3                   	ret    
	...

00802370 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	83 ec 18             	sub    $0x18,%esp
  802376:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802379:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80237c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	89 04 24             	mov    %eax,(%esp)
  802385:	e8 b6 f0 ff ff       	call   801440 <fd2data>
  80238a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80238c:	c7 44 24 04 51 31 80 	movl   $0x803151,0x4(%esp)
  802393:	00 
  802394:	89 34 24             	mov    %esi,(%esp)
  802397:	e8 0e e8 ff ff       	call   800baa <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80239c:	8b 43 04             	mov    0x4(%ebx),%eax
  80239f:	2b 03                	sub    (%ebx),%eax
  8023a1:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  8023a7:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  8023ae:	00 00 00 
	stat->st_dev = &devpipe;
  8023b1:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  8023b8:	70 80 00 
	return 0;
}
  8023bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8023c0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8023c3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8023c6:	89 ec                	mov    %ebp,%esp
  8023c8:	5d                   	pop    %ebp
  8023c9:	c3                   	ret    

008023ca <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8023ca:	55                   	push   %ebp
  8023cb:	89 e5                	mov    %esp,%ebp
  8023cd:	53                   	push   %ebx
  8023ce:	83 ec 14             	sub    $0x14,%esp
  8023d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8023d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8023d8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023df:	e8 66 ee ff ff       	call   80124a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8023e4:	89 1c 24             	mov    %ebx,(%esp)
  8023e7:	e8 54 f0 ff ff       	call   801440 <fd2data>
  8023ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8023f0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8023f7:	e8 4e ee ff ff       	call   80124a <sys_page_unmap>
}
  8023fc:	83 c4 14             	add    $0x14,%esp
  8023ff:	5b                   	pop    %ebx
  802400:	5d                   	pop    %ebp
  802401:	c3                   	ret    

00802402 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  802402:	55                   	push   %ebp
  802403:	89 e5                	mov    %esp,%ebp
  802405:	57                   	push   %edi
  802406:	56                   	push   %esi
  802407:	53                   	push   %ebx
  802408:	83 ec 2c             	sub    $0x2c,%esp
  80240b:	89 c7                	mov    %eax,%edi
  80240d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  802410:	a1 80 74 80 00       	mov    0x807480,%eax
  802415:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802418:	89 3c 24             	mov    %edi,(%esp)
  80241b:	e8 a8 05 00 00       	call   8029c8 <pageref>
  802420:	89 c6                	mov    %eax,%esi
  802422:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802425:	89 04 24             	mov    %eax,(%esp)
  802428:	e8 9b 05 00 00       	call   8029c8 <pageref>
  80242d:	39 c6                	cmp    %eax,%esi
  80242f:	0f 94 c0             	sete   %al
  802432:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  802435:	8b 15 80 74 80 00    	mov    0x807480,%edx
  80243b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80243e:	39 cb                	cmp    %ecx,%ebx
  802440:	75 08                	jne    80244a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  802442:	83 c4 2c             	add    $0x2c,%esp
  802445:	5b                   	pop    %ebx
  802446:	5e                   	pop    %esi
  802447:	5f                   	pop    %edi
  802448:	5d                   	pop    %ebp
  802449:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80244a:	83 f8 01             	cmp    $0x1,%eax
  80244d:	75 c1                	jne    802410 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80244f:	8b 52 58             	mov    0x58(%edx),%edx
  802452:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802456:	89 54 24 08          	mov    %edx,0x8(%esp)
  80245a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80245e:	c7 04 24 58 31 80 00 	movl   $0x803158,(%esp)
  802465:	e8 63 e0 ff ff       	call   8004cd <cprintf>
  80246a:	eb a4                	jmp    802410 <_pipeisclosed+0xe>

0080246c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80246c:	55                   	push   %ebp
  80246d:	89 e5                	mov    %esp,%ebp
  80246f:	57                   	push   %edi
  802470:	56                   	push   %esi
  802471:	53                   	push   %ebx
  802472:	83 ec 1c             	sub    $0x1c,%esp
  802475:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  802478:	89 34 24             	mov    %esi,(%esp)
  80247b:	e8 c0 ef ff ff       	call   801440 <fd2data>
  802480:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802482:	bf 00 00 00 00       	mov    $0x0,%edi
  802487:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80248b:	75 54                	jne    8024e1 <devpipe_write+0x75>
  80248d:	eb 60                	jmp    8024ef <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80248f:	89 da                	mov    %ebx,%edx
  802491:	89 f0                	mov    %esi,%eax
  802493:	e8 6a ff ff ff       	call   802402 <_pipeisclosed>
  802498:	85 c0                	test   %eax,%eax
  80249a:	74 07                	je     8024a3 <devpipe_write+0x37>
  80249c:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a1:	eb 53                	jmp    8024f6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  8024a3:	90                   	nop
  8024a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8024a8:	e8 b8 ee ff ff       	call   801365 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024ad:	8b 43 04             	mov    0x4(%ebx),%eax
  8024b0:	8b 13                	mov    (%ebx),%edx
  8024b2:	83 c2 20             	add    $0x20,%edx
  8024b5:	39 d0                	cmp    %edx,%eax
  8024b7:	73 d6                	jae    80248f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8024b9:	89 c2                	mov    %eax,%edx
  8024bb:	c1 fa 1f             	sar    $0x1f,%edx
  8024be:	c1 ea 1b             	shr    $0x1b,%edx
  8024c1:	01 d0                	add    %edx,%eax
  8024c3:	83 e0 1f             	and    $0x1f,%eax
  8024c6:	29 d0                	sub    %edx,%eax
  8024c8:	89 c2                	mov    %eax,%edx
  8024ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024cd:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8024d1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8024d5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8024d9:	83 c7 01             	add    $0x1,%edi
  8024dc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8024df:	76 13                	jbe    8024f4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8024e1:	8b 43 04             	mov    0x4(%ebx),%eax
  8024e4:	8b 13                	mov    (%ebx),%edx
  8024e6:	83 c2 20             	add    $0x20,%edx
  8024e9:	39 d0                	cmp    %edx,%eax
  8024eb:	73 a2                	jae    80248f <devpipe_write+0x23>
  8024ed:	eb ca                	jmp    8024b9 <devpipe_write+0x4d>
  8024ef:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8024f4:	89 f8                	mov    %edi,%eax
}
  8024f6:	83 c4 1c             	add    $0x1c,%esp
  8024f9:	5b                   	pop    %ebx
  8024fa:	5e                   	pop    %esi
  8024fb:	5f                   	pop    %edi
  8024fc:	5d                   	pop    %ebp
  8024fd:	c3                   	ret    

008024fe <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8024fe:	55                   	push   %ebp
  8024ff:	89 e5                	mov    %esp,%ebp
  802501:	83 ec 28             	sub    $0x28,%esp
  802504:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  802507:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80250a:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80250d:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  802510:	89 3c 24             	mov    %edi,(%esp)
  802513:	e8 28 ef ff ff       	call   801440 <fd2data>
  802518:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  80251a:	be 00 00 00 00       	mov    $0x0,%esi
  80251f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802523:	75 4c                	jne    802571 <devpipe_read+0x73>
  802525:	eb 5b                	jmp    802582 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  802527:	89 f0                	mov    %esi,%eax
  802529:	eb 5e                	jmp    802589 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  80252b:	89 da                	mov    %ebx,%edx
  80252d:	89 f8                	mov    %edi,%eax
  80252f:	90                   	nop
  802530:	e8 cd fe ff ff       	call   802402 <_pipeisclosed>
  802535:	85 c0                	test   %eax,%eax
  802537:	74 07                	je     802540 <devpipe_read+0x42>
  802539:	b8 00 00 00 00       	mov    $0x0,%eax
  80253e:	eb 49                	jmp    802589 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  802540:	e8 20 ee ff ff       	call   801365 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  802545:	8b 03                	mov    (%ebx),%eax
  802547:	3b 43 04             	cmp    0x4(%ebx),%eax
  80254a:	74 df                	je     80252b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80254c:	89 c2                	mov    %eax,%edx
  80254e:	c1 fa 1f             	sar    $0x1f,%edx
  802551:	c1 ea 1b             	shr    $0x1b,%edx
  802554:	01 d0                	add    %edx,%eax
  802556:	83 e0 1f             	and    $0x1f,%eax
  802559:	29 d0                	sub    %edx,%eax
  80255b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  802560:	8b 55 0c             	mov    0xc(%ebp),%edx
  802563:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  802566:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  802569:	83 c6 01             	add    $0x1,%esi
  80256c:	39 75 10             	cmp    %esi,0x10(%ebp)
  80256f:	76 16                	jbe    802587 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  802571:	8b 03                	mov    (%ebx),%eax
  802573:	3b 43 04             	cmp    0x4(%ebx),%eax
  802576:	75 d4                	jne    80254c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  802578:	85 f6                	test   %esi,%esi
  80257a:	75 ab                	jne    802527 <devpipe_read+0x29>
  80257c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802580:	eb a9                	jmp    80252b <devpipe_read+0x2d>
  802582:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  802587:	89 f0                	mov    %esi,%eax
}
  802589:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80258c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80258f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  802592:	89 ec                	mov    %ebp,%esp
  802594:	5d                   	pop    %ebp
  802595:	c3                   	ret    

00802596 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  802596:	55                   	push   %ebp
  802597:	89 e5                	mov    %esp,%ebp
  802599:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80259c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80259f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a6:	89 04 24             	mov    %eax,(%esp)
  8025a9:	e8 1f ef ff ff       	call   8014cd <fd_lookup>
  8025ae:	85 c0                	test   %eax,%eax
  8025b0:	78 15                	js     8025c7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	89 04 24             	mov    %eax,(%esp)
  8025b8:	e8 83 ee ff ff       	call   801440 <fd2data>
	return _pipeisclosed(fd, p);
  8025bd:	89 c2                	mov    %eax,%edx
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	e8 3b fe ff ff       	call   802402 <_pipeisclosed>
}
  8025c7:	c9                   	leave  
  8025c8:	c3                   	ret    

008025c9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  8025c9:	55                   	push   %ebp
  8025ca:	89 e5                	mov    %esp,%ebp
  8025cc:	83 ec 48             	sub    $0x48,%esp
  8025cf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8025d2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8025d5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8025d8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  8025db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8025de:	89 04 24             	mov    %eax,(%esp)
  8025e1:	e8 75 ee ff ff       	call   80145b <fd_alloc>
  8025e6:	89 c3                	mov    %eax,%ebx
  8025e8:	85 c0                	test   %eax,%eax
  8025ea:	0f 88 42 01 00 00    	js     802732 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8025f0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  8025f7:	00 
  8025f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8025ff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802606:	e8 fb ec ff ff       	call   801306 <sys_page_alloc>
  80260b:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  80260d:	85 c0                	test   %eax,%eax
  80260f:	0f 88 1d 01 00 00    	js     802732 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802615:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802618:	89 04 24             	mov    %eax,(%esp)
  80261b:	e8 3b ee ff ff       	call   80145b <fd_alloc>
  802620:	89 c3                	mov    %eax,%ebx
  802622:	85 c0                	test   %eax,%eax
  802624:	0f 88 f5 00 00 00    	js     80271f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80262a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802631:	00 
  802632:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802635:	89 44 24 04          	mov    %eax,0x4(%esp)
  802639:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802640:	e8 c1 ec ff ff       	call   801306 <sys_page_alloc>
  802645:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802647:	85 c0                	test   %eax,%eax
  802649:	0f 88 d0 00 00 00    	js     80271f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80264f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802652:	89 04 24             	mov    %eax,(%esp)
  802655:	e8 e6 ed ff ff       	call   801440 <fd2data>
  80265a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80265c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802663:	00 
  802664:	89 44 24 04          	mov    %eax,0x4(%esp)
  802668:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80266f:	e8 92 ec ff ff       	call   801306 <sys_page_alloc>
  802674:	89 c3                	mov    %eax,%ebx
  802676:	85 c0                	test   %eax,%eax
  802678:	0f 88 8e 00 00 00    	js     80270c <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80267e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802681:	89 04 24             	mov    %eax,(%esp)
  802684:	e8 b7 ed ff ff       	call   801440 <fd2data>
  802689:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802690:	00 
  802691:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802695:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80269c:	00 
  80269d:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026a1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8026a8:	e8 fb eb ff ff       	call   8012a8 <sys_page_map>
  8026ad:	89 c3                	mov    %eax,%ebx
  8026af:	85 c0                	test   %eax,%eax
  8026b1:	78 49                	js     8026fc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  8026b3:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  8026b8:	8b 08                	mov    (%eax),%ecx
  8026ba:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026bd:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  8026bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8026c2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  8026c9:	8b 10                	mov    (%eax),%edx
  8026cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ce:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8026d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026d3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  8026da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026dd:	89 04 24             	mov    %eax,(%esp)
  8026e0:	e8 4b ed ff ff       	call   801430 <fd2num>
  8026e5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8026e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8026ea:	89 04 24             	mov    %eax,(%esp)
  8026ed:	e8 3e ed ff ff       	call   801430 <fd2num>
  8026f2:	89 47 04             	mov    %eax,0x4(%edi)
  8026f5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8026fa:	eb 36                	jmp    802732 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8026fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  802700:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802707:	e8 3e eb ff ff       	call   80124a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  80270c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80270f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802713:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80271a:	e8 2b eb ff ff       	call   80124a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  80271f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802722:	89 44 24 04          	mov    %eax,0x4(%esp)
  802726:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80272d:	e8 18 eb ff ff       	call   80124a <sys_page_unmap>
    err:
	return r;
}
  802732:	89 d8                	mov    %ebx,%eax
  802734:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  802737:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80273a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80273d:	89 ec                	mov    %ebp,%esp
  80273f:	5d                   	pop    %ebp
  802740:	c3                   	ret    
	...

00802750 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802750:	55                   	push   %ebp
  802751:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802753:	b8 00 00 00 00       	mov    $0x0,%eax
  802758:	5d                   	pop    %ebp
  802759:	c3                   	ret    

0080275a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80275a:	55                   	push   %ebp
  80275b:	89 e5                	mov    %esp,%ebp
  80275d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802760:	c7 44 24 04 70 31 80 	movl   $0x803170,0x4(%esp)
  802767:	00 
  802768:	8b 45 0c             	mov    0xc(%ebp),%eax
  80276b:	89 04 24             	mov    %eax,(%esp)
  80276e:	e8 37 e4 ff ff       	call   800baa <strcpy>
	return 0;
}
  802773:	b8 00 00 00 00       	mov    $0x0,%eax
  802778:	c9                   	leave  
  802779:	c3                   	ret    

0080277a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80277a:	55                   	push   %ebp
  80277b:	89 e5                	mov    %esp,%ebp
  80277d:	57                   	push   %edi
  80277e:	56                   	push   %esi
  80277f:	53                   	push   %ebx
  802780:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802786:	b8 00 00 00 00       	mov    $0x0,%eax
  80278b:	be 00 00 00 00       	mov    $0x0,%esi
  802790:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802794:	74 3f                	je     8027d5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802796:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80279c:	8b 55 10             	mov    0x10(%ebp),%edx
  80279f:	29 c2                	sub    %eax,%edx
  8027a1:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  8027a3:	83 fa 7f             	cmp    $0x7f,%edx
  8027a6:	76 05                	jbe    8027ad <devcons_write+0x33>
  8027a8:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  8027ad:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8027b1:	03 45 0c             	add    0xc(%ebp),%eax
  8027b4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8027b8:	89 3c 24             	mov    %edi,(%esp)
  8027bb:	e8 a5 e5 ff ff       	call   800d65 <memmove>
		sys_cputs(buf, m);
  8027c0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8027c4:	89 3c 24             	mov    %edi,(%esp)
  8027c7:	e8 d4 e7 ff ff       	call   800fa0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  8027cc:	01 de                	add    %ebx,%esi
  8027ce:	89 f0                	mov    %esi,%eax
  8027d0:	3b 75 10             	cmp    0x10(%ebp),%esi
  8027d3:	72 c7                	jb     80279c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  8027d5:	89 f0                	mov    %esi,%eax
  8027d7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  8027dd:	5b                   	pop    %ebx
  8027de:	5e                   	pop    %esi
  8027df:	5f                   	pop    %edi
  8027e0:	5d                   	pop    %ebp
  8027e1:	c3                   	ret    

008027e2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8027e2:	55                   	push   %ebp
  8027e3:	89 e5                	mov    %esp,%ebp
  8027e5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8027ee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8027f5:	00 
  8027f6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8027f9:	89 04 24             	mov    %eax,(%esp)
  8027fc:	e8 9f e7 ff ff       	call   800fa0 <sys_cputs>
}
  802801:	c9                   	leave  
  802802:	c3                   	ret    

00802803 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  802803:	55                   	push   %ebp
  802804:	89 e5                	mov    %esp,%ebp
  802806:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  802809:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80280d:	75 07                	jne    802816 <devcons_read+0x13>
  80280f:	eb 28                	jmp    802839 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  802811:	e8 4f eb ff ff       	call   801365 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  802816:	66 90                	xchg   %ax,%ax
  802818:	e8 4f e7 ff ff       	call   800f6c <sys_cgetc>
  80281d:	85 c0                	test   %eax,%eax
  80281f:	90                   	nop
  802820:	74 ef                	je     802811 <devcons_read+0xe>
  802822:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  802824:	85 c0                	test   %eax,%eax
  802826:	78 16                	js     80283e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  802828:	83 f8 04             	cmp    $0x4,%eax
  80282b:	74 0c                	je     802839 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  80282d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802830:	88 10                	mov    %dl,(%eax)
  802832:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  802837:	eb 05                	jmp    80283e <devcons_read+0x3b>
  802839:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80283e:	c9                   	leave  
  80283f:	c3                   	ret    

00802840 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802840:	55                   	push   %ebp
  802841:	89 e5                	mov    %esp,%ebp
  802843:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802846:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802849:	89 04 24             	mov    %eax,(%esp)
  80284c:	e8 0a ec ff ff       	call   80145b <fd_alloc>
  802851:	85 c0                	test   %eax,%eax
  802853:	78 3f                	js     802894 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802855:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80285c:	00 
  80285d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802860:	89 44 24 04          	mov    %eax,0x4(%esp)
  802864:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80286b:	e8 96 ea ff ff       	call   801306 <sys_page_alloc>
  802870:	85 c0                	test   %eax,%eax
  802872:	78 20                	js     802894 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802874:	8b 15 58 70 80 00    	mov    0x807058,%edx
  80287a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288c:	89 04 24             	mov    %eax,(%esp)
  80288f:	e8 9c eb ff ff       	call   801430 <fd2num>
}
  802894:	c9                   	leave  
  802895:	c3                   	ret    

00802896 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802896:	55                   	push   %ebp
  802897:	89 e5                	mov    %esp,%ebp
  802899:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80289c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80289f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a6:	89 04 24             	mov    %eax,(%esp)
  8028a9:	e8 1f ec ff ff       	call   8014cd <fd_lookup>
  8028ae:	85 c0                	test   %eax,%eax
  8028b0:	78 11                	js     8028c3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  8028b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b5:	8b 00                	mov    (%eax),%eax
  8028b7:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  8028bd:	0f 94 c0             	sete   %al
  8028c0:	0f b6 c0             	movzbl %al,%eax
}
  8028c3:	c9                   	leave  
  8028c4:	c3                   	ret    

008028c5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  8028c5:	55                   	push   %ebp
  8028c6:	89 e5                	mov    %esp,%ebp
  8028c8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  8028cb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8028d2:	00 
  8028d3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8028d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8028da:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8028e1:	e8 48 ee ff ff       	call   80172e <read>
	if (r < 0)
  8028e6:	85 c0                	test   %eax,%eax
  8028e8:	78 0f                	js     8028f9 <getchar+0x34>
		return r;
	if (r < 1)
  8028ea:	85 c0                	test   %eax,%eax
  8028ec:	7f 07                	jg     8028f5 <getchar+0x30>
  8028ee:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8028f3:	eb 04                	jmp    8028f9 <getchar+0x34>
		return -E_EOF;
	return c;
  8028f5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8028f9:	c9                   	leave  
  8028fa:	c3                   	ret    
  8028fb:	00 00                	add    %al,(%eax)
  8028fd:	00 00                	add    %al,(%eax)
	...

00802900 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802900:	55                   	push   %ebp
  802901:	89 e5                	mov    %esp,%ebp
  802903:	57                   	push   %edi
  802904:	56                   	push   %esi
  802905:	53                   	push   %ebx
  802906:	83 ec 1c             	sub    $0x1c,%esp
  802909:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80290c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80290f:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  802912:	8b 45 14             	mov    0x14(%ebp),%eax
  802915:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802919:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80291d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802921:	89 1c 24             	mov    %ebx,(%esp)
  802924:	e8 cf e7 ff ff       	call   8010f8 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  802929:	85 c0                	test   %eax,%eax
  80292b:	79 21                	jns    80294e <ipc_send+0x4e>
  80292d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802930:	74 1c                	je     80294e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  802932:	c7 44 24 08 7c 31 80 	movl   $0x80317c,0x8(%esp)
  802939:	00 
  80293a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  802941:	00 
  802942:	c7 04 24 8e 31 80 00 	movl   $0x80318e,(%esp)
  802949:	e8 ba da ff ff       	call   800408 <_panic>
          else if(r==-E_IPC_NOT_RECV)
  80294e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802951:	75 07                	jne    80295a <ipc_send+0x5a>
           sys_yield();
  802953:	e8 0d ea ff ff       	call   801365 <sys_yield>
          else
            break;
        }
  802958:	eb b8                	jmp    802912 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  80295a:	83 c4 1c             	add    $0x1c,%esp
  80295d:	5b                   	pop    %ebx
  80295e:	5e                   	pop    %esi
  80295f:	5f                   	pop    %edi
  802960:	5d                   	pop    %ebp
  802961:	c3                   	ret    

00802962 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802962:	55                   	push   %ebp
  802963:	89 e5                	mov    %esp,%ebp
  802965:	83 ec 18             	sub    $0x18,%esp
  802968:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80296b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80296e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802971:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  802974:	8b 45 0c             	mov    0xc(%ebp),%eax
  802977:	89 04 24             	mov    %eax,(%esp)
  80297a:	e8 1c e7 ff ff       	call   80109b <sys_ipc_recv>
        if(r<0)
  80297f:	85 c0                	test   %eax,%eax
  802981:	79 17                	jns    80299a <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  802983:	85 db                	test   %ebx,%ebx
  802985:	74 06                	je     80298d <ipc_recv+0x2b>
               *from_env_store =0;
  802987:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  80298d:	85 f6                	test   %esi,%esi
  80298f:	90                   	nop
  802990:	74 2c                	je     8029be <ipc_recv+0x5c>
              *perm_store=0;
  802992:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802998:	eb 24                	jmp    8029be <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  80299a:	85 db                	test   %ebx,%ebx
  80299c:	74 0a                	je     8029a8 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  80299e:	a1 80 74 80 00       	mov    0x807480,%eax
  8029a3:	8b 40 74             	mov    0x74(%eax),%eax
  8029a6:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  8029a8:	85 f6                	test   %esi,%esi
  8029aa:	74 0a                	je     8029b6 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  8029ac:	a1 80 74 80 00       	mov    0x807480,%eax
  8029b1:	8b 40 78             	mov    0x78(%eax),%eax
  8029b4:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  8029b6:	a1 80 74 80 00       	mov    0x807480,%eax
  8029bb:	8b 40 70             	mov    0x70(%eax),%eax
}
  8029be:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8029c1:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8029c4:	89 ec                	mov    %ebp,%esp
  8029c6:	5d                   	pop    %ebp
  8029c7:	c3                   	ret    

008029c8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8029c8:	55                   	push   %ebp
  8029c9:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	89 c2                	mov    %eax,%edx
  8029d0:	c1 ea 16             	shr    $0x16,%edx
  8029d3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8029da:	f6 c2 01             	test   $0x1,%dl
  8029dd:	74 26                	je     802a05 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  8029df:	c1 e8 0c             	shr    $0xc,%eax
  8029e2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8029e9:	a8 01                	test   $0x1,%al
  8029eb:	74 18                	je     802a05 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  8029ed:	c1 e8 0c             	shr    $0xc,%eax
  8029f0:	8d 14 40             	lea    (%eax,%eax,2),%edx
  8029f3:	c1 e2 02             	shl    $0x2,%edx
  8029f6:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  8029fb:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802a00:	0f b7 c0             	movzwl %ax,%eax
  802a03:	eb 05                	jmp    802a0a <pageref+0x42>
  802a05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802a0a:	5d                   	pop    %ebp
  802a0b:	c3                   	ret    
  802a0c:	00 00                	add    %al,(%eax)
	...

00802a10 <__udivdi3>:
  802a10:	55                   	push   %ebp
  802a11:	89 e5                	mov    %esp,%ebp
  802a13:	57                   	push   %edi
  802a14:	56                   	push   %esi
  802a15:	83 ec 10             	sub    $0x10,%esp
  802a18:	8b 45 14             	mov    0x14(%ebp),%eax
  802a1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a1e:	8b 75 10             	mov    0x10(%ebp),%esi
  802a21:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802a24:	85 c0                	test   %eax,%eax
  802a26:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802a29:	75 35                	jne    802a60 <__udivdi3+0x50>
  802a2b:	39 fe                	cmp    %edi,%esi
  802a2d:	77 61                	ja     802a90 <__udivdi3+0x80>
  802a2f:	85 f6                	test   %esi,%esi
  802a31:	75 0b                	jne    802a3e <__udivdi3+0x2e>
  802a33:	b8 01 00 00 00       	mov    $0x1,%eax
  802a38:	31 d2                	xor    %edx,%edx
  802a3a:	f7 f6                	div    %esi
  802a3c:	89 c6                	mov    %eax,%esi
  802a3e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802a41:	31 d2                	xor    %edx,%edx
  802a43:	89 f8                	mov    %edi,%eax
  802a45:	f7 f6                	div    %esi
  802a47:	89 c7                	mov    %eax,%edi
  802a49:	89 c8                	mov    %ecx,%eax
  802a4b:	f7 f6                	div    %esi
  802a4d:	89 c1                	mov    %eax,%ecx
  802a4f:	89 fa                	mov    %edi,%edx
  802a51:	89 c8                	mov    %ecx,%eax
  802a53:	83 c4 10             	add    $0x10,%esp
  802a56:	5e                   	pop    %esi
  802a57:	5f                   	pop    %edi
  802a58:	5d                   	pop    %ebp
  802a59:	c3                   	ret    
  802a5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802a60:	39 f8                	cmp    %edi,%eax
  802a62:	77 1c                	ja     802a80 <__udivdi3+0x70>
  802a64:	0f bd d0             	bsr    %eax,%edx
  802a67:	83 f2 1f             	xor    $0x1f,%edx
  802a6a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802a6d:	75 39                	jne    802aa8 <__udivdi3+0x98>
  802a6f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802a72:	0f 86 a0 00 00 00    	jbe    802b18 <__udivdi3+0x108>
  802a78:	39 f8                	cmp    %edi,%eax
  802a7a:	0f 82 98 00 00 00    	jb     802b18 <__udivdi3+0x108>
  802a80:	31 ff                	xor    %edi,%edi
  802a82:	31 c9                	xor    %ecx,%ecx
  802a84:	89 c8                	mov    %ecx,%eax
  802a86:	89 fa                	mov    %edi,%edx
  802a88:	83 c4 10             	add    $0x10,%esp
  802a8b:	5e                   	pop    %esi
  802a8c:	5f                   	pop    %edi
  802a8d:	5d                   	pop    %ebp
  802a8e:	c3                   	ret    
  802a8f:	90                   	nop
  802a90:	89 d1                	mov    %edx,%ecx
  802a92:	89 fa                	mov    %edi,%edx
  802a94:	89 c8                	mov    %ecx,%eax
  802a96:	31 ff                	xor    %edi,%edi
  802a98:	f7 f6                	div    %esi
  802a9a:	89 c1                	mov    %eax,%ecx
  802a9c:	89 fa                	mov    %edi,%edx
  802a9e:	89 c8                	mov    %ecx,%eax
  802aa0:	83 c4 10             	add    $0x10,%esp
  802aa3:	5e                   	pop    %esi
  802aa4:	5f                   	pop    %edi
  802aa5:	5d                   	pop    %ebp
  802aa6:	c3                   	ret    
  802aa7:	90                   	nop
  802aa8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802aac:	89 f2                	mov    %esi,%edx
  802aae:	d3 e0                	shl    %cl,%eax
  802ab0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802ab3:	b8 20 00 00 00       	mov    $0x20,%eax
  802ab8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802abb:	89 c1                	mov    %eax,%ecx
  802abd:	d3 ea                	shr    %cl,%edx
  802abf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802ac3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802ac6:	d3 e6                	shl    %cl,%esi
  802ac8:	89 c1                	mov    %eax,%ecx
  802aca:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802acd:	89 fe                	mov    %edi,%esi
  802acf:	d3 ee                	shr    %cl,%esi
  802ad1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802ad5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802ad8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802adb:	d3 e7                	shl    %cl,%edi
  802add:	89 c1                	mov    %eax,%ecx
  802adf:	d3 ea                	shr    %cl,%edx
  802ae1:	09 d7                	or     %edx,%edi
  802ae3:	89 f2                	mov    %esi,%edx
  802ae5:	89 f8                	mov    %edi,%eax
  802ae7:	f7 75 ec             	divl   -0x14(%ebp)
  802aea:	89 d6                	mov    %edx,%esi
  802aec:	89 c7                	mov    %eax,%edi
  802aee:	f7 65 e8             	mull   -0x18(%ebp)
  802af1:	39 d6                	cmp    %edx,%esi
  802af3:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802af6:	72 30                	jb     802b28 <__udivdi3+0x118>
  802af8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802afb:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802aff:	d3 e2                	shl    %cl,%edx
  802b01:	39 c2                	cmp    %eax,%edx
  802b03:	73 05                	jae    802b0a <__udivdi3+0xfa>
  802b05:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802b08:	74 1e                	je     802b28 <__udivdi3+0x118>
  802b0a:	89 f9                	mov    %edi,%ecx
  802b0c:	31 ff                	xor    %edi,%edi
  802b0e:	e9 71 ff ff ff       	jmp    802a84 <__udivdi3+0x74>
  802b13:	90                   	nop
  802b14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b18:	31 ff                	xor    %edi,%edi
  802b1a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802b1f:	e9 60 ff ff ff       	jmp    802a84 <__udivdi3+0x74>
  802b24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802b28:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802b2b:	31 ff                	xor    %edi,%edi
  802b2d:	89 c8                	mov    %ecx,%eax
  802b2f:	89 fa                	mov    %edi,%edx
  802b31:	83 c4 10             	add    $0x10,%esp
  802b34:	5e                   	pop    %esi
  802b35:	5f                   	pop    %edi
  802b36:	5d                   	pop    %ebp
  802b37:	c3                   	ret    
	...

00802b40 <__umoddi3>:
  802b40:	55                   	push   %ebp
  802b41:	89 e5                	mov    %esp,%ebp
  802b43:	57                   	push   %edi
  802b44:	56                   	push   %esi
  802b45:	83 ec 20             	sub    $0x20,%esp
  802b48:	8b 55 14             	mov    0x14(%ebp),%edx
  802b4b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802b4e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802b51:	8b 75 0c             	mov    0xc(%ebp),%esi
  802b54:	85 d2                	test   %edx,%edx
  802b56:	89 c8                	mov    %ecx,%eax
  802b58:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802b5b:	75 13                	jne    802b70 <__umoddi3+0x30>
  802b5d:	39 f7                	cmp    %esi,%edi
  802b5f:	76 3f                	jbe    802ba0 <__umoddi3+0x60>
  802b61:	89 f2                	mov    %esi,%edx
  802b63:	f7 f7                	div    %edi
  802b65:	89 d0                	mov    %edx,%eax
  802b67:	31 d2                	xor    %edx,%edx
  802b69:	83 c4 20             	add    $0x20,%esp
  802b6c:	5e                   	pop    %esi
  802b6d:	5f                   	pop    %edi
  802b6e:	5d                   	pop    %ebp
  802b6f:	c3                   	ret    
  802b70:	39 f2                	cmp    %esi,%edx
  802b72:	77 4c                	ja     802bc0 <__umoddi3+0x80>
  802b74:	0f bd ca             	bsr    %edx,%ecx
  802b77:	83 f1 1f             	xor    $0x1f,%ecx
  802b7a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802b7d:	75 51                	jne    802bd0 <__umoddi3+0x90>
  802b7f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802b82:	0f 87 e0 00 00 00    	ja     802c68 <__umoddi3+0x128>
  802b88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8b:	29 f8                	sub    %edi,%eax
  802b8d:	19 d6                	sbb    %edx,%esi
  802b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b95:	89 f2                	mov    %esi,%edx
  802b97:	83 c4 20             	add    $0x20,%esp
  802b9a:	5e                   	pop    %esi
  802b9b:	5f                   	pop    %edi
  802b9c:	5d                   	pop    %ebp
  802b9d:	c3                   	ret    
  802b9e:	66 90                	xchg   %ax,%ax
  802ba0:	85 ff                	test   %edi,%edi
  802ba2:	75 0b                	jne    802baf <__umoddi3+0x6f>
  802ba4:	b8 01 00 00 00       	mov    $0x1,%eax
  802ba9:	31 d2                	xor    %edx,%edx
  802bab:	f7 f7                	div    %edi
  802bad:	89 c7                	mov    %eax,%edi
  802baf:	89 f0                	mov    %esi,%eax
  802bb1:	31 d2                	xor    %edx,%edx
  802bb3:	f7 f7                	div    %edi
  802bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb8:	f7 f7                	div    %edi
  802bba:	eb a9                	jmp    802b65 <__umoddi3+0x25>
  802bbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bc0:	89 c8                	mov    %ecx,%eax
  802bc2:	89 f2                	mov    %esi,%edx
  802bc4:	83 c4 20             	add    $0x20,%esp
  802bc7:	5e                   	pop    %esi
  802bc8:	5f                   	pop    %edi
  802bc9:	5d                   	pop    %ebp
  802bca:	c3                   	ret    
  802bcb:	90                   	nop
  802bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802bd0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802bd4:	d3 e2                	shl    %cl,%edx
  802bd6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802bd9:	ba 20 00 00 00       	mov    $0x20,%edx
  802bde:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802be1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802be4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802be8:	89 fa                	mov    %edi,%edx
  802bea:	d3 ea                	shr    %cl,%edx
  802bec:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802bf0:	0b 55 f4             	or     -0xc(%ebp),%edx
  802bf3:	d3 e7                	shl    %cl,%edi
  802bf5:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802bf9:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802bfc:	89 f2                	mov    %esi,%edx
  802bfe:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802c01:	89 c7                	mov    %eax,%edi
  802c03:	d3 ea                	shr    %cl,%edx
  802c05:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c09:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802c0c:	89 c2                	mov    %eax,%edx
  802c0e:	d3 e6                	shl    %cl,%esi
  802c10:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802c14:	d3 ea                	shr    %cl,%edx
  802c16:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c1a:	09 d6                	or     %edx,%esi
  802c1c:	89 f0                	mov    %esi,%eax
  802c1e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802c21:	d3 e7                	shl    %cl,%edi
  802c23:	89 f2                	mov    %esi,%edx
  802c25:	f7 75 f4             	divl   -0xc(%ebp)
  802c28:	89 d6                	mov    %edx,%esi
  802c2a:	f7 65 e8             	mull   -0x18(%ebp)
  802c2d:	39 d6                	cmp    %edx,%esi
  802c2f:	72 2b                	jb     802c5c <__umoddi3+0x11c>
  802c31:	39 c7                	cmp    %eax,%edi
  802c33:	72 23                	jb     802c58 <__umoddi3+0x118>
  802c35:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c39:	29 c7                	sub    %eax,%edi
  802c3b:	19 d6                	sbb    %edx,%esi
  802c3d:	89 f0                	mov    %esi,%eax
  802c3f:	89 f2                	mov    %esi,%edx
  802c41:	d3 ef                	shr    %cl,%edi
  802c43:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802c47:	d3 e0                	shl    %cl,%eax
  802c49:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802c4d:	09 f8                	or     %edi,%eax
  802c4f:	d3 ea                	shr    %cl,%edx
  802c51:	83 c4 20             	add    $0x20,%esp
  802c54:	5e                   	pop    %esi
  802c55:	5f                   	pop    %edi
  802c56:	5d                   	pop    %ebp
  802c57:	c3                   	ret    
  802c58:	39 d6                	cmp    %edx,%esi
  802c5a:	75 d9                	jne    802c35 <__umoddi3+0xf5>
  802c5c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802c5f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802c62:	eb d1                	jmp    802c35 <__umoddi3+0xf5>
  802c64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c68:	39 f2                	cmp    %esi,%edx
  802c6a:	0f 82 18 ff ff ff    	jb     802b88 <__umoddi3+0x48>
  802c70:	e9 1d ff ff ff       	jmp    802b92 <__umoddi3+0x52>
