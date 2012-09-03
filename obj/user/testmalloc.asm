
obj/user/testmalloc:     file format elf32-i386


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
  80002c:	e8 d7 00 00 00       	call   800108 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>
	...

00800040 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800040:	55                   	push   %ebp
  800041:	89 e5                	mov    %esp,%ebp
  800043:	53                   	push   %ebx
  800044:	83 ec 14             	sub    $0x14,%esp
	char *buf;
	int n;
	void *v;

	while (1) {
		buf = readline("> ");
  800047:	c7 04 24 a0 2d 80 00 	movl   $0x802da0,(%esp)
  80004e:	e8 2d 01 00 00       	call   800180 <readline>
  800053:	89 c3                	mov    %eax,%ebx
		if (buf == 0)
  800055:	85 c0                	test   %eax,%eax
  800057:	75 05                	jne    80005e <umain+0x1e>
			exit();
  800059:	e8 fa 00 00 00       	call   800158 <exit>
		if (memcmp(buf, "free ", 5) == 0) {
  80005e:	c7 44 24 08 05 00 00 	movl   $0x5,0x8(%esp)
  800065:	00 
  800066:	c7 44 24 04 a3 2d 80 	movl   $0x802da3,0x4(%esp)
  80006d:	00 
  80006e:	89 1c 24             	mov    %ebx,(%esp)
  800071:	e8 9c 04 00 00       	call   800512 <memcmp>
  800076:	85 c0                	test   %eax,%eax
  800078:	75 25                	jne    80009f <umain+0x5f>
			v = (void*) strtol(buf + 5, 0, 0);
  80007a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800081:	00 
  800082:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800089:	00 
  80008a:	83 c3 05             	add    $0x5,%ebx
  80008d:	89 1c 24             	mov    %ebx,(%esp)
  800090:	e8 f6 04 00 00       	call   80058b <strtol>
			free(v);
  800095:	89 04 24             	mov    %eax,(%esp)
  800098:	e8 e3 19 00 00       	call   801a80 <free>
  80009d:	eb a8                	jmp    800047 <umain+0x7>
		} else if (memcmp(buf, "malloc ", 7) == 0) {
  80009f:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  8000a6:	00 
  8000a7:	c7 44 24 04 a9 2d 80 	movl   $0x802da9,0x4(%esp)
  8000ae:	00 
  8000af:	89 1c 24             	mov    %ebx,(%esp)
  8000b2:	e8 5b 04 00 00       	call   800512 <memcmp>
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	75 38                	jne    8000f3 <umain+0xb3>
			n = strtol(buf + 7, 0, 0);
  8000bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8000c2:	00 
  8000c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8000ca:	00 
  8000cb:	83 c3 07             	add    $0x7,%ebx
  8000ce:	89 1c 24             	mov    %ebx,(%esp)
  8000d1:	e8 b5 04 00 00       	call   80058b <strtol>
			v = malloc(n);
  8000d6:	89 04 24             	mov    %eax,(%esp)
  8000d9:	e8 75 1a 00 00       	call   801b53 <malloc>
			printf("\t0x%x\n", (uintptr_t) v);
  8000de:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000e2:	c7 04 24 b1 2d 80 00 	movl   $0x802db1,(%esp)
  8000e9:	e8 39 14 00 00       	call   801527 <printf>
  8000ee:	e9 54 ff ff ff       	jmp    800047 <umain+0x7>
		} else
			printf("?unknown command\n");
  8000f3:	c7 04 24 b8 2d 80 00 	movl   $0x802db8,(%esp)
  8000fa:	e8 28 14 00 00       	call   801527 <printf>
  8000ff:	90                   	nop
  800100:	e9 42 ff ff ff       	jmp    800047 <umain+0x7>
  800105:	00 00                	add    %al,(%eax)
	...

00800108 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	83 ec 18             	sub    $0x18,%esp
  80010e:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800111:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800114:	8b 75 08             	mov    0x8(%ebp),%esi
  800117:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  80011a:	e8 8a 09 00 00       	call   800aa9 <sys_getenvid>
  80011f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800124:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800127:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80012c:	a3 84 74 80 00       	mov    %eax,0x807484

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800131:	85 f6                	test   %esi,%esi
  800133:	7e 07                	jle    80013c <libmain+0x34>
		binaryname = argv[0];
  800135:	8b 03                	mov    (%ebx),%eax
  800137:	a3 00 70 80 00       	mov    %eax,0x807000

	// call user main routine
	umain(argc, argv);
  80013c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800140:	89 34 24             	mov    %esi,(%esp)
  800143:	e8 f8 fe ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800148:	e8 0b 00 00 00       	call   800158 <exit>
}
  80014d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800150:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800153:	89 ec                	mov    %ebp,%esp
  800155:	5d                   	pop    %ebp
  800156:	c3                   	ret    
	...

00800158 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80015e:	e8 b8 0e 00 00       	call   80101b <close_all>
	sys_env_destroy(0);
  800163:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80016a:	e8 6e 09 00 00       	call   800add <sys_env_destroy>
}
  80016f:	c9                   	leave  
  800170:	c3                   	ret    
	...

00800180 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	57                   	push   %edi
  800184:	56                   	push   %esi
  800185:	53                   	push   %ebx
  800186:	83 ec 1c             	sub    $0x1c,%esp
  800189:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80018c:	85 c0                	test   %eax,%eax
  80018e:	74 18                	je     8001a8 <readline+0x28>
		fprintf(1, "%s", prompt);
  800190:	89 44 24 08          	mov    %eax,0x8(%esp)
  800194:	c7 44 24 04 d9 2e 80 	movl   $0x802ed9,0x4(%esp)
  80019b:	00 
  80019c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001a3:	e8 a1 13 00 00       	call   801549 <fprintf>
#endif

	i = 0;
	echoing = iscons(0);
  8001a8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8001af:	e8 a2 20 00 00       	call   802256 <iscons>
  8001b4:	89 c7                	mov    %eax,%edi
  8001b6:	be 00 00 00 00       	mov    $0x0,%esi
	while (1) {
		c = getchar();
  8001bb:	e8 c5 20 00 00       	call   802285 <getchar>
  8001c0:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  8001c2:	85 c0                	test   %eax,%eax
  8001c4:	79 25                	jns    8001eb <readline+0x6b>
			if (c != -E_EOF)
  8001c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8001cb:	83 fb f8             	cmp    $0xfffffff8,%ebx
  8001ce:	0f 84 8f 00 00 00    	je     800263 <readline+0xe3>
				cprintf("read error: %e\n", c);
  8001d4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8001d8:	c7 04 24 e1 2d 80 00 	movl   $0x802de1,(%esp)
  8001df:	e8 9d 21 00 00       	call   802381 <cprintf>
  8001e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8001e9:	eb 78                	jmp    800263 <readline+0xe3>
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  8001eb:	83 f8 08             	cmp    $0x8,%eax
  8001ee:	74 05                	je     8001f5 <readline+0x75>
  8001f0:	83 f8 7f             	cmp    $0x7f,%eax
  8001f3:	75 1e                	jne    800213 <readline+0x93>
  8001f5:	85 f6                	test   %esi,%esi
  8001f7:	7e 1a                	jle    800213 <readline+0x93>
			if (echoing)
  8001f9:	85 ff                	test   %edi,%edi
  8001fb:	90                   	nop
  8001fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800200:	74 0c                	je     80020e <readline+0x8e>
				cputchar('\b');
  800202:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  800209:	e8 94 1f 00 00       	call   8021a2 <cputchar>
			i--;
  80020e:	83 ee 01             	sub    $0x1,%esi
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return NULL;
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  800211:	eb a8                	jmp    8001bb <readline+0x3b>
			if (echoing)
				cputchar('\b');
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
  800213:	83 fb 1f             	cmp    $0x1f,%ebx
  800216:	7e 21                	jle    800239 <readline+0xb9>
  800218:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  80021e:	66 90                	xchg   %ax,%ax
  800220:	7f 17                	jg     800239 <readline+0xb9>
			if (echoing)
  800222:	85 ff                	test   %edi,%edi
  800224:	74 08                	je     80022e <readline+0xae>
				cputchar(c);
  800226:	89 1c 24             	mov    %ebx,(%esp)
  800229:	e8 74 1f 00 00       	call   8021a2 <cputchar>
			buf[i++] = c;
  80022e:	88 9e 80 70 80 00    	mov    %bl,0x807080(%esi)
  800234:	83 c6 01             	add    $0x1,%esi
  800237:	eb 82                	jmp    8001bb <readline+0x3b>
		} else if (c == '\n' || c == '\r') {
  800239:	83 fb 0a             	cmp    $0xa,%ebx
  80023c:	74 09                	je     800247 <readline+0xc7>
  80023e:	83 fb 0d             	cmp    $0xd,%ebx
  800241:	0f 85 74 ff ff ff    	jne    8001bb <readline+0x3b>
			if (echoing)
  800247:	85 ff                	test   %edi,%edi
  800249:	74 0c                	je     800257 <readline+0xd7>
				cputchar('\n');
  80024b:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800252:	e8 4b 1f 00 00       	call   8021a2 <cputchar>
			buf[i] = 0;
  800257:	c6 86 80 70 80 00 00 	movb   $0x0,0x807080(%esi)
  80025e:	b8 80 70 80 00       	mov    $0x807080,%eax
			return buf;
		}
	}
}
  800263:	83 c4 1c             	add    $0x1c,%esp
  800266:	5b                   	pop    %ebx
  800267:	5e                   	pop    %esi
  800268:	5f                   	pop    %edi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    
  80026b:	00 00                	add    %al,(%eax)
  80026d:	00 00                	add    %al,(%eax)
	...

00800270 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800276:	b8 00 00 00 00       	mov    $0x0,%eax
  80027b:	80 3a 00             	cmpb   $0x0,(%edx)
  80027e:	74 09                	je     800289 <strlen+0x19>
		n++;
  800280:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800283:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800287:	75 f7                	jne    800280 <strlen+0x10>
		n++;
	return n;
}
  800289:	5d                   	pop    %ebp
  80028a:	c3                   	ret    

0080028b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80028b:	55                   	push   %ebp
  80028c:	89 e5                	mov    %esp,%ebp
  80028e:	53                   	push   %ebx
  80028f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800292:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800295:	85 c9                	test   %ecx,%ecx
  800297:	74 19                	je     8002b2 <strnlen+0x27>
  800299:	80 3b 00             	cmpb   $0x0,(%ebx)
  80029c:	74 14                	je     8002b2 <strnlen+0x27>
  80029e:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8002a3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8002a6:	39 c8                	cmp    %ecx,%eax
  8002a8:	74 0d                	je     8002b7 <strnlen+0x2c>
  8002aa:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8002ae:	75 f3                	jne    8002a3 <strnlen+0x18>
  8002b0:	eb 05                	jmp    8002b7 <strnlen+0x2c>
  8002b2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8002b7:	5b                   	pop    %ebx
  8002b8:	5d                   	pop    %ebp
  8002b9:	c3                   	ret    

008002ba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	53                   	push   %ebx
  8002be:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002c4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8002c9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8002cd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8002d0:	83 c2 01             	add    $0x1,%edx
  8002d3:	84 c9                	test   %cl,%cl
  8002d5:	75 f2                	jne    8002c9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8002d7:	5b                   	pop    %ebx
  8002d8:	5d                   	pop    %ebp
  8002d9:	c3                   	ret    

008002da <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8002da:	55                   	push   %ebp
  8002db:	89 e5                	mov    %esp,%ebp
  8002dd:	56                   	push   %esi
  8002de:	53                   	push   %ebx
  8002df:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8002e8:	85 f6                	test   %esi,%esi
  8002ea:	74 18                	je     800304 <strncpy+0x2a>
  8002ec:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  8002f1:	0f b6 1a             	movzbl (%edx),%ebx
  8002f4:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8002f7:	80 3a 01             	cmpb   $0x1,(%edx)
  8002fa:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8002fd:	83 c1 01             	add    $0x1,%ecx
  800300:	39 ce                	cmp    %ecx,%esi
  800302:	77 ed                	ja     8002f1 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800304:	5b                   	pop    %ebx
  800305:	5e                   	pop    %esi
  800306:	5d                   	pop    %ebp
  800307:	c3                   	ret    

00800308 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	56                   	push   %esi
  80030c:	53                   	push   %ebx
  80030d:	8b 75 08             	mov    0x8(%ebp),%esi
  800310:	8b 55 0c             	mov    0xc(%ebp),%edx
  800313:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800316:	89 f0                	mov    %esi,%eax
  800318:	85 c9                	test   %ecx,%ecx
  80031a:	74 27                	je     800343 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  80031c:	83 e9 01             	sub    $0x1,%ecx
  80031f:	74 1d                	je     80033e <strlcpy+0x36>
  800321:	0f b6 1a             	movzbl (%edx),%ebx
  800324:	84 db                	test   %bl,%bl
  800326:	74 16                	je     80033e <strlcpy+0x36>
			*dst++ = *src++;
  800328:	88 18                	mov    %bl,(%eax)
  80032a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80032d:	83 e9 01             	sub    $0x1,%ecx
  800330:	74 0e                	je     800340 <strlcpy+0x38>
			*dst++ = *src++;
  800332:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800335:	0f b6 1a             	movzbl (%edx),%ebx
  800338:	84 db                	test   %bl,%bl
  80033a:	75 ec                	jne    800328 <strlcpy+0x20>
  80033c:	eb 02                	jmp    800340 <strlcpy+0x38>
  80033e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800340:	c6 00 00             	movb   $0x0,(%eax)
  800343:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800345:	5b                   	pop    %ebx
  800346:	5e                   	pop    %esi
  800347:	5d                   	pop    %ebp
  800348:	c3                   	ret    

00800349 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800349:	55                   	push   %ebp
  80034a:	89 e5                	mov    %esp,%ebp
  80034c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80034f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800352:	0f b6 01             	movzbl (%ecx),%eax
  800355:	84 c0                	test   %al,%al
  800357:	74 15                	je     80036e <strcmp+0x25>
  800359:	3a 02                	cmp    (%edx),%al
  80035b:	75 11                	jne    80036e <strcmp+0x25>
		p++, q++;
  80035d:	83 c1 01             	add    $0x1,%ecx
  800360:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800363:	0f b6 01             	movzbl (%ecx),%eax
  800366:	84 c0                	test   %al,%al
  800368:	74 04                	je     80036e <strcmp+0x25>
  80036a:	3a 02                	cmp    (%edx),%al
  80036c:	74 ef                	je     80035d <strcmp+0x14>
  80036e:	0f b6 c0             	movzbl %al,%eax
  800371:	0f b6 12             	movzbl (%edx),%edx
  800374:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800376:	5d                   	pop    %ebp
  800377:	c3                   	ret    

00800378 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	53                   	push   %ebx
  80037c:	8b 55 08             	mov    0x8(%ebp),%edx
  80037f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800382:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800385:	85 c0                	test   %eax,%eax
  800387:	74 23                	je     8003ac <strncmp+0x34>
  800389:	0f b6 1a             	movzbl (%edx),%ebx
  80038c:	84 db                	test   %bl,%bl
  80038e:	74 24                	je     8003b4 <strncmp+0x3c>
  800390:	3a 19                	cmp    (%ecx),%bl
  800392:	75 20                	jne    8003b4 <strncmp+0x3c>
  800394:	83 e8 01             	sub    $0x1,%eax
  800397:	74 13                	je     8003ac <strncmp+0x34>
		n--, p++, q++;
  800399:	83 c2 01             	add    $0x1,%edx
  80039c:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  80039f:	0f b6 1a             	movzbl (%edx),%ebx
  8003a2:	84 db                	test   %bl,%bl
  8003a4:	74 0e                	je     8003b4 <strncmp+0x3c>
  8003a6:	3a 19                	cmp    (%ecx),%bl
  8003a8:	74 ea                	je     800394 <strncmp+0x1c>
  8003aa:	eb 08                	jmp    8003b4 <strncmp+0x3c>
  8003ac:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8003b1:	5b                   	pop    %ebx
  8003b2:	5d                   	pop    %ebp
  8003b3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8003b4:	0f b6 02             	movzbl (%edx),%eax
  8003b7:	0f b6 11             	movzbl (%ecx),%edx
  8003ba:	29 d0                	sub    %edx,%eax
  8003bc:	eb f3                	jmp    8003b1 <strncmp+0x39>

008003be <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8003be:	55                   	push   %ebp
  8003bf:	89 e5                	mov    %esp,%ebp
  8003c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8003c8:	0f b6 10             	movzbl (%eax),%edx
  8003cb:	84 d2                	test   %dl,%dl
  8003cd:	74 15                	je     8003e4 <strchr+0x26>
		if (*s == c)
  8003cf:	38 ca                	cmp    %cl,%dl
  8003d1:	75 07                	jne    8003da <strchr+0x1c>
  8003d3:	eb 14                	jmp    8003e9 <strchr+0x2b>
  8003d5:	38 ca                	cmp    %cl,%dl
  8003d7:	90                   	nop
  8003d8:	74 0f                	je     8003e9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8003da:	83 c0 01             	add    $0x1,%eax
  8003dd:	0f b6 10             	movzbl (%eax),%edx
  8003e0:	84 d2                	test   %dl,%dl
  8003e2:	75 f1                	jne    8003d5 <strchr+0x17>
  8003e4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8003e9:	5d                   	pop    %ebp
  8003ea:	c3                   	ret    

008003eb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8003eb:	55                   	push   %ebp
  8003ec:	89 e5                	mov    %esp,%ebp
  8003ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f1:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8003f5:	0f b6 10             	movzbl (%eax),%edx
  8003f8:	84 d2                	test   %dl,%dl
  8003fa:	74 18                	je     800414 <strfind+0x29>
		if (*s == c)
  8003fc:	38 ca                	cmp    %cl,%dl
  8003fe:	75 0a                	jne    80040a <strfind+0x1f>
  800400:	eb 12                	jmp    800414 <strfind+0x29>
  800402:	38 ca                	cmp    %cl,%dl
  800404:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800408:	74 0a                	je     800414 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80040a:	83 c0 01             	add    $0x1,%eax
  80040d:	0f b6 10             	movzbl (%eax),%edx
  800410:	84 d2                	test   %dl,%dl
  800412:	75 ee                	jne    800402 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800414:	5d                   	pop    %ebp
  800415:	c3                   	ret    

00800416 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800416:	55                   	push   %ebp
  800417:	89 e5                	mov    %esp,%ebp
  800419:	83 ec 0c             	sub    $0xc,%esp
  80041c:	89 1c 24             	mov    %ebx,(%esp)
  80041f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800423:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800427:	8b 7d 08             	mov    0x8(%ebp),%edi
  80042a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80042d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800430:	85 c9                	test   %ecx,%ecx
  800432:	74 30                	je     800464 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800434:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80043a:	75 25                	jne    800461 <memset+0x4b>
  80043c:	f6 c1 03             	test   $0x3,%cl
  80043f:	75 20                	jne    800461 <memset+0x4b>
		c &= 0xFF;
  800441:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800444:	89 d3                	mov    %edx,%ebx
  800446:	c1 e3 08             	shl    $0x8,%ebx
  800449:	89 d6                	mov    %edx,%esi
  80044b:	c1 e6 18             	shl    $0x18,%esi
  80044e:	89 d0                	mov    %edx,%eax
  800450:	c1 e0 10             	shl    $0x10,%eax
  800453:	09 f0                	or     %esi,%eax
  800455:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800457:	09 d8                	or     %ebx,%eax
  800459:	c1 e9 02             	shr    $0x2,%ecx
  80045c:	fc                   	cld    
  80045d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80045f:	eb 03                	jmp    800464 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800461:	fc                   	cld    
  800462:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800464:	89 f8                	mov    %edi,%eax
  800466:	8b 1c 24             	mov    (%esp),%ebx
  800469:	8b 74 24 04          	mov    0x4(%esp),%esi
  80046d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800471:	89 ec                	mov    %ebp,%esp
  800473:	5d                   	pop    %ebp
  800474:	c3                   	ret    

00800475 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	83 ec 08             	sub    $0x8,%esp
  80047b:	89 34 24             	mov    %esi,(%esp)
  80047e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800488:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  80048b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  80048d:	39 c6                	cmp    %eax,%esi
  80048f:	73 35                	jae    8004c6 <memmove+0x51>
  800491:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800494:	39 d0                	cmp    %edx,%eax
  800496:	73 2e                	jae    8004c6 <memmove+0x51>
		s += n;
		d += n;
  800498:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80049a:	f6 c2 03             	test   $0x3,%dl
  80049d:	75 1b                	jne    8004ba <memmove+0x45>
  80049f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8004a5:	75 13                	jne    8004ba <memmove+0x45>
  8004a7:	f6 c1 03             	test   $0x3,%cl
  8004aa:	75 0e                	jne    8004ba <memmove+0x45>
			asm volatile("std; rep movsl\n"
  8004ac:	83 ef 04             	sub    $0x4,%edi
  8004af:	8d 72 fc             	lea    -0x4(%edx),%esi
  8004b2:	c1 e9 02             	shr    $0x2,%ecx
  8004b5:	fd                   	std    
  8004b6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8004b8:	eb 09                	jmp    8004c3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8004ba:	83 ef 01             	sub    $0x1,%edi
  8004bd:	8d 72 ff             	lea    -0x1(%edx),%esi
  8004c0:	fd                   	std    
  8004c1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8004c3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8004c4:	eb 20                	jmp    8004e6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8004c6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8004cc:	75 15                	jne    8004e3 <memmove+0x6e>
  8004ce:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8004d4:	75 0d                	jne    8004e3 <memmove+0x6e>
  8004d6:	f6 c1 03             	test   $0x3,%cl
  8004d9:	75 08                	jne    8004e3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  8004db:	c1 e9 02             	shr    $0x2,%ecx
  8004de:	fc                   	cld    
  8004df:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8004e1:	eb 03                	jmp    8004e6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8004e3:	fc                   	cld    
  8004e4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8004e6:	8b 34 24             	mov    (%esp),%esi
  8004e9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8004ed:	89 ec                	mov    %ebp,%esp
  8004ef:	5d                   	pop    %ebp
  8004f0:	c3                   	ret    

008004f1 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  8004f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fa:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800501:	89 44 24 04          	mov    %eax,0x4(%esp)
  800505:	8b 45 08             	mov    0x8(%ebp),%eax
  800508:	89 04 24             	mov    %eax,(%esp)
  80050b:	e8 65 ff ff ff       	call   800475 <memmove>
}
  800510:	c9                   	leave  
  800511:	c3                   	ret    

00800512 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800512:	55                   	push   %ebp
  800513:	89 e5                	mov    %esp,%ebp
  800515:	57                   	push   %edi
  800516:	56                   	push   %esi
  800517:	53                   	push   %ebx
  800518:	8b 75 08             	mov    0x8(%ebp),%esi
  80051b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80051e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800521:	85 c9                	test   %ecx,%ecx
  800523:	74 36                	je     80055b <memcmp+0x49>
		if (*s1 != *s2)
  800525:	0f b6 06             	movzbl (%esi),%eax
  800528:	0f b6 1f             	movzbl (%edi),%ebx
  80052b:	38 d8                	cmp    %bl,%al
  80052d:	74 20                	je     80054f <memcmp+0x3d>
  80052f:	eb 14                	jmp    800545 <memcmp+0x33>
  800531:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800536:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  80053b:	83 c2 01             	add    $0x1,%edx
  80053e:	83 e9 01             	sub    $0x1,%ecx
  800541:	38 d8                	cmp    %bl,%al
  800543:	74 12                	je     800557 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800545:	0f b6 c0             	movzbl %al,%eax
  800548:	0f b6 db             	movzbl %bl,%ebx
  80054b:	29 d8                	sub    %ebx,%eax
  80054d:	eb 11                	jmp    800560 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80054f:	83 e9 01             	sub    $0x1,%ecx
  800552:	ba 00 00 00 00       	mov    $0x0,%edx
  800557:	85 c9                	test   %ecx,%ecx
  800559:	75 d6                	jne    800531 <memcmp+0x1f>
  80055b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800560:	5b                   	pop    %ebx
  800561:	5e                   	pop    %esi
  800562:	5f                   	pop    %edi
  800563:	5d                   	pop    %ebp
  800564:	c3                   	ret    

00800565 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800565:	55                   	push   %ebp
  800566:	89 e5                	mov    %esp,%ebp
  800568:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80056b:	89 c2                	mov    %eax,%edx
  80056d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800570:	39 d0                	cmp    %edx,%eax
  800572:	73 15                	jae    800589 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800574:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800578:	38 08                	cmp    %cl,(%eax)
  80057a:	75 06                	jne    800582 <memfind+0x1d>
  80057c:	eb 0b                	jmp    800589 <memfind+0x24>
  80057e:	38 08                	cmp    %cl,(%eax)
  800580:	74 07                	je     800589 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800582:	83 c0 01             	add    $0x1,%eax
  800585:	39 c2                	cmp    %eax,%edx
  800587:	77 f5                	ja     80057e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800589:	5d                   	pop    %ebp
  80058a:	c3                   	ret    

0080058b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80058b:	55                   	push   %ebp
  80058c:	89 e5                	mov    %esp,%ebp
  80058e:	57                   	push   %edi
  80058f:	56                   	push   %esi
  800590:	53                   	push   %ebx
  800591:	83 ec 04             	sub    $0x4,%esp
  800594:	8b 55 08             	mov    0x8(%ebp),%edx
  800597:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80059a:	0f b6 02             	movzbl (%edx),%eax
  80059d:	3c 20                	cmp    $0x20,%al
  80059f:	74 04                	je     8005a5 <strtol+0x1a>
  8005a1:	3c 09                	cmp    $0x9,%al
  8005a3:	75 0e                	jne    8005b3 <strtol+0x28>
		s++;
  8005a5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8005a8:	0f b6 02             	movzbl (%edx),%eax
  8005ab:	3c 20                	cmp    $0x20,%al
  8005ad:	74 f6                	je     8005a5 <strtol+0x1a>
  8005af:	3c 09                	cmp    $0x9,%al
  8005b1:	74 f2                	je     8005a5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  8005b3:	3c 2b                	cmp    $0x2b,%al
  8005b5:	75 0c                	jne    8005c3 <strtol+0x38>
		s++;
  8005b7:	83 c2 01             	add    $0x1,%edx
  8005ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005c1:	eb 15                	jmp    8005d8 <strtol+0x4d>
	else if (*s == '-')
  8005c3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005ca:	3c 2d                	cmp    $0x2d,%al
  8005cc:	75 0a                	jne    8005d8 <strtol+0x4d>
		s++, neg = 1;
  8005ce:	83 c2 01             	add    $0x1,%edx
  8005d1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8005d8:	85 db                	test   %ebx,%ebx
  8005da:	0f 94 c0             	sete   %al
  8005dd:	74 05                	je     8005e4 <strtol+0x59>
  8005df:	83 fb 10             	cmp    $0x10,%ebx
  8005e2:	75 18                	jne    8005fc <strtol+0x71>
  8005e4:	80 3a 30             	cmpb   $0x30,(%edx)
  8005e7:	75 13                	jne    8005fc <strtol+0x71>
  8005e9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8005ed:	8d 76 00             	lea    0x0(%esi),%esi
  8005f0:	75 0a                	jne    8005fc <strtol+0x71>
		s += 2, base = 16;
  8005f2:	83 c2 02             	add    $0x2,%edx
  8005f5:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8005fa:	eb 15                	jmp    800611 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8005fc:	84 c0                	test   %al,%al
  8005fe:	66 90                	xchg   %ax,%ax
  800600:	74 0f                	je     800611 <strtol+0x86>
  800602:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800607:	80 3a 30             	cmpb   $0x30,(%edx)
  80060a:	75 05                	jne    800611 <strtol+0x86>
		s++, base = 8;
  80060c:	83 c2 01             	add    $0x1,%edx
  80060f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800611:	b8 00 00 00 00       	mov    $0x0,%eax
  800616:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800618:	0f b6 0a             	movzbl (%edx),%ecx
  80061b:	89 cf                	mov    %ecx,%edi
  80061d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800620:	80 fb 09             	cmp    $0x9,%bl
  800623:	77 08                	ja     80062d <strtol+0xa2>
			dig = *s - '0';
  800625:	0f be c9             	movsbl %cl,%ecx
  800628:	83 e9 30             	sub    $0x30,%ecx
  80062b:	eb 1e                	jmp    80064b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  80062d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800630:	80 fb 19             	cmp    $0x19,%bl
  800633:	77 08                	ja     80063d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800635:	0f be c9             	movsbl %cl,%ecx
  800638:	83 e9 57             	sub    $0x57,%ecx
  80063b:	eb 0e                	jmp    80064b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  80063d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800640:	80 fb 19             	cmp    $0x19,%bl
  800643:	77 15                	ja     80065a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800645:	0f be c9             	movsbl %cl,%ecx
  800648:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80064b:	39 f1                	cmp    %esi,%ecx
  80064d:	7d 0b                	jge    80065a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  80064f:	83 c2 01             	add    $0x1,%edx
  800652:	0f af c6             	imul   %esi,%eax
  800655:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800658:	eb be                	jmp    800618 <strtol+0x8d>
  80065a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80065c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800660:	74 05                	je     800667 <strtol+0xdc>
		*endptr = (char *) s;
  800662:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800665:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800667:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80066b:	74 04                	je     800671 <strtol+0xe6>
  80066d:	89 c8                	mov    %ecx,%eax
  80066f:	f7 d8                	neg    %eax
}
  800671:	83 c4 04             	add    $0x4,%esp
  800674:	5b                   	pop    %ebx
  800675:	5e                   	pop    %esi
  800676:	5f                   	pop    %edi
  800677:	5d                   	pop    %ebp
  800678:	c3                   	ret    
  800679:	00 00                	add    %al,(%eax)
	...

0080067c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  80067c:	55                   	push   %ebp
  80067d:	89 e5                	mov    %esp,%ebp
  80067f:	83 ec 0c             	sub    $0xc,%esp
  800682:	89 1c 24             	mov    %ebx,(%esp)
  800685:	89 74 24 04          	mov    %esi,0x4(%esp)
  800689:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80068d:	ba 00 00 00 00       	mov    $0x0,%edx
  800692:	b8 01 00 00 00       	mov    $0x1,%eax
  800697:	89 d1                	mov    %edx,%ecx
  800699:	89 d3                	mov    %edx,%ebx
  80069b:	89 d7                	mov    %edx,%edi
  80069d:	89 d6                	mov    %edx,%esi
  80069f:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8006a1:	8b 1c 24             	mov    (%esp),%ebx
  8006a4:	8b 74 24 04          	mov    0x4(%esp),%esi
  8006a8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8006ac:	89 ec                	mov    %ebp,%esp
  8006ae:	5d                   	pop    %ebp
  8006af:	c3                   	ret    

008006b0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8006b0:	55                   	push   %ebp
  8006b1:	89 e5                	mov    %esp,%ebp
  8006b3:	83 ec 0c             	sub    $0xc,%esp
  8006b6:	89 1c 24             	mov    %ebx,(%esp)
  8006b9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006bd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8006c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8006c6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006c9:	8b 55 08             	mov    0x8(%ebp),%edx
  8006cc:	89 c3                	mov    %eax,%ebx
  8006ce:	89 c7                	mov    %eax,%edi
  8006d0:	89 c6                	mov    %eax,%esi
  8006d2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8006d4:	8b 1c 24             	mov    (%esp),%ebx
  8006d7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8006db:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8006df:	89 ec                	mov    %ebp,%esp
  8006e1:	5d                   	pop    %ebp
  8006e2:	c3                   	ret    

008006e3 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  8006e3:	55                   	push   %ebp
  8006e4:	89 e5                	mov    %esp,%ebp
  8006e6:	83 ec 0c             	sub    $0xc,%esp
  8006e9:	89 1c 24             	mov    %ebx,(%esp)
  8006ec:	89 74 24 04          	mov    %esi,0x4(%esp)
  8006f0:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8006f4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006f9:	b8 10 00 00 00       	mov    $0x10,%eax
  8006fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800701:	8b 55 08             	mov    0x8(%ebp),%edx
  800704:	89 df                	mov    %ebx,%edi
  800706:	89 de                	mov    %ebx,%esi
  800708:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  80070a:	8b 1c 24             	mov    (%esp),%ebx
  80070d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800711:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800715:	89 ec                	mov    %ebp,%esp
  800717:	5d                   	pop    %ebp
  800718:	c3                   	ret    

00800719 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  800719:	55                   	push   %ebp
  80071a:	89 e5                	mov    %esp,%ebp
  80071c:	83 ec 38             	sub    $0x38,%esp
  80071f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800722:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800725:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800728:	bb 00 00 00 00       	mov    $0x0,%ebx
  80072d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800732:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800735:	8b 55 08             	mov    0x8(%ebp),%edx
  800738:	89 df                	mov    %ebx,%edi
  80073a:	89 de                	mov    %ebx,%esi
  80073c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80073e:	85 c0                	test   %eax,%eax
  800740:	7e 28                	jle    80076a <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800742:	89 44 24 10          	mov    %eax,0x10(%esp)
  800746:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80074d:	00 
  80074e:	c7 44 24 08 f1 2d 80 	movl   $0x802df1,0x8(%esp)
  800755:	00 
  800756:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80075d:	00 
  80075e:	c7 04 24 0e 2e 80 00 	movl   $0x802e0e,(%esp)
  800765:	e8 52 1b 00 00       	call   8022bc <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  80076a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80076d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800770:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800773:	89 ec                	mov    %ebp,%esp
  800775:	5d                   	pop    %ebp
  800776:	c3                   	ret    

00800777 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	83 ec 0c             	sub    $0xc,%esp
  80077d:	89 1c 24             	mov    %ebx,(%esp)
  800780:	89 74 24 04          	mov    %esi,0x4(%esp)
  800784:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800788:	ba 00 00 00 00       	mov    $0x0,%edx
  80078d:	b8 0e 00 00 00       	mov    $0xe,%eax
  800792:	89 d1                	mov    %edx,%ecx
  800794:	89 d3                	mov    %edx,%ebx
  800796:	89 d7                	mov    %edx,%edi
  800798:	89 d6                	mov    %edx,%esi
  80079a:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  80079c:	8b 1c 24             	mov    (%esp),%ebx
  80079f:	8b 74 24 04          	mov    0x4(%esp),%esi
  8007a3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8007a7:	89 ec                	mov    %ebp,%esp
  8007a9:	5d                   	pop    %ebp
  8007aa:	c3                   	ret    

008007ab <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	83 ec 38             	sub    $0x38,%esp
  8007b1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8007b4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8007b7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8007ba:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007bf:	b8 0d 00 00 00       	mov    $0xd,%eax
  8007c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8007c7:	89 cb                	mov    %ecx,%ebx
  8007c9:	89 cf                	mov    %ecx,%edi
  8007cb:	89 ce                	mov    %ecx,%esi
  8007cd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8007cf:	85 c0                	test   %eax,%eax
  8007d1:	7e 28                	jle    8007fb <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8007d3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8007d7:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8007de:	00 
  8007df:	c7 44 24 08 f1 2d 80 	movl   $0x802df1,0x8(%esp)
  8007e6:	00 
  8007e7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8007ee:	00 
  8007ef:	c7 04 24 0e 2e 80 00 	movl   $0x802e0e,(%esp)
  8007f6:	e8 c1 1a 00 00       	call   8022bc <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8007fb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8007fe:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800801:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800804:	89 ec                	mov    %ebp,%esp
  800806:	5d                   	pop    %ebp
  800807:	c3                   	ret    

00800808 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800808:	55                   	push   %ebp
  800809:	89 e5                	mov    %esp,%ebp
  80080b:	83 ec 0c             	sub    $0xc,%esp
  80080e:	89 1c 24             	mov    %ebx,(%esp)
  800811:	89 74 24 04          	mov    %esi,0x4(%esp)
  800815:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800819:	be 00 00 00 00       	mov    $0x0,%esi
  80081e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800823:	8b 7d 14             	mov    0x14(%ebp),%edi
  800826:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800829:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80082c:	8b 55 08             	mov    0x8(%ebp),%edx
  80082f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800831:	8b 1c 24             	mov    (%esp),%ebx
  800834:	8b 74 24 04          	mov    0x4(%esp),%esi
  800838:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80083c:	89 ec                	mov    %ebp,%esp
  80083e:	5d                   	pop    %ebp
  80083f:	c3                   	ret    

00800840 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	83 ec 38             	sub    $0x38,%esp
  800846:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800849:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80084c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80084f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800854:	b8 0a 00 00 00       	mov    $0xa,%eax
  800859:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80085c:	8b 55 08             	mov    0x8(%ebp),%edx
  80085f:	89 df                	mov    %ebx,%edi
  800861:	89 de                	mov    %ebx,%esi
  800863:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800865:	85 c0                	test   %eax,%eax
  800867:	7e 28                	jle    800891 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800869:	89 44 24 10          	mov    %eax,0x10(%esp)
  80086d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800874:	00 
  800875:	c7 44 24 08 f1 2d 80 	movl   $0x802df1,0x8(%esp)
  80087c:	00 
  80087d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800884:	00 
  800885:	c7 04 24 0e 2e 80 00 	movl   $0x802e0e,(%esp)
  80088c:	e8 2b 1a 00 00       	call   8022bc <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800891:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800894:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800897:	8b 7d fc             	mov    -0x4(%ebp),%edi
  80089a:	89 ec                	mov    %ebp,%esp
  80089c:	5d                   	pop    %ebp
  80089d:	c3                   	ret    

0080089e <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80089e:	55                   	push   %ebp
  80089f:	89 e5                	mov    %esp,%ebp
  8008a1:	83 ec 38             	sub    $0x38,%esp
  8008a4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8008a7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8008aa:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8008ad:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008b2:	b8 09 00 00 00       	mov    $0x9,%eax
  8008b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8008bd:	89 df                	mov    %ebx,%edi
  8008bf:	89 de                	mov    %ebx,%esi
  8008c1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8008c3:	85 c0                	test   %eax,%eax
  8008c5:	7e 28                	jle    8008ef <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8008c7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8008cb:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8008d2:	00 
  8008d3:	c7 44 24 08 f1 2d 80 	movl   $0x802df1,0x8(%esp)
  8008da:	00 
  8008db:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8008e2:	00 
  8008e3:	c7 04 24 0e 2e 80 00 	movl   $0x802e0e,(%esp)
  8008ea:	e8 cd 19 00 00       	call   8022bc <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8008ef:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8008f2:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8008f5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8008f8:	89 ec                	mov    %ebp,%esp
  8008fa:	5d                   	pop    %ebp
  8008fb:	c3                   	ret    

008008fc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8008fc:	55                   	push   %ebp
  8008fd:	89 e5                	mov    %esp,%ebp
  8008ff:	83 ec 38             	sub    $0x38,%esp
  800902:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800905:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800908:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80090b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800910:	b8 08 00 00 00       	mov    $0x8,%eax
  800915:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800918:	8b 55 08             	mov    0x8(%ebp),%edx
  80091b:	89 df                	mov    %ebx,%edi
  80091d:	89 de                	mov    %ebx,%esi
  80091f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800921:	85 c0                	test   %eax,%eax
  800923:	7e 28                	jle    80094d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800925:	89 44 24 10          	mov    %eax,0x10(%esp)
  800929:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800930:	00 
  800931:	c7 44 24 08 f1 2d 80 	movl   $0x802df1,0x8(%esp)
  800938:	00 
  800939:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800940:	00 
  800941:	c7 04 24 0e 2e 80 00 	movl   $0x802e0e,(%esp)
  800948:	e8 6f 19 00 00       	call   8022bc <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80094d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800950:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800953:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800956:	89 ec                	mov    %ebp,%esp
  800958:	5d                   	pop    %ebp
  800959:	c3                   	ret    

0080095a <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	83 ec 38             	sub    $0x38,%esp
  800960:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800963:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800966:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800969:	bb 00 00 00 00       	mov    $0x0,%ebx
  80096e:	b8 06 00 00 00       	mov    $0x6,%eax
  800973:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800976:	8b 55 08             	mov    0x8(%ebp),%edx
  800979:	89 df                	mov    %ebx,%edi
  80097b:	89 de                	mov    %ebx,%esi
  80097d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80097f:	85 c0                	test   %eax,%eax
  800981:	7e 28                	jle    8009ab <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800983:	89 44 24 10          	mov    %eax,0x10(%esp)
  800987:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80098e:	00 
  80098f:	c7 44 24 08 f1 2d 80 	movl   $0x802df1,0x8(%esp)
  800996:	00 
  800997:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80099e:	00 
  80099f:	c7 04 24 0e 2e 80 00 	movl   $0x802e0e,(%esp)
  8009a6:	e8 11 19 00 00       	call   8022bc <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8009ab:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8009ae:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8009b1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8009b4:	89 ec                	mov    %ebp,%esp
  8009b6:	5d                   	pop    %ebp
  8009b7:	c3                   	ret    

008009b8 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8009b8:	55                   	push   %ebp
  8009b9:	89 e5                	mov    %esp,%ebp
  8009bb:	83 ec 38             	sub    $0x38,%esp
  8009be:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8009c1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8009c4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8009c7:	b8 05 00 00 00       	mov    $0x5,%eax
  8009cc:	8b 75 18             	mov    0x18(%ebp),%esi
  8009cf:	8b 7d 14             	mov    0x14(%ebp),%edi
  8009d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8009d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8009db:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8009dd:	85 c0                	test   %eax,%eax
  8009df:	7e 28                	jle    800a09 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8009e1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8009e5:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8009ec:	00 
  8009ed:	c7 44 24 08 f1 2d 80 	movl   $0x802df1,0x8(%esp)
  8009f4:	00 
  8009f5:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8009fc:	00 
  8009fd:	c7 04 24 0e 2e 80 00 	movl   $0x802e0e,(%esp)
  800a04:	e8 b3 18 00 00       	call   8022bc <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800a09:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800a0c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a0f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a12:	89 ec                	mov    %ebp,%esp
  800a14:	5d                   	pop    %ebp
  800a15:	c3                   	ret    

00800a16 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800a16:	55                   	push   %ebp
  800a17:	89 e5                	mov    %esp,%ebp
  800a19:	83 ec 38             	sub    $0x38,%esp
  800a1c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800a1f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800a22:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a25:	be 00 00 00 00       	mov    $0x0,%esi
  800a2a:	b8 04 00 00 00       	mov    $0x4,%eax
  800a2f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800a32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a35:	8b 55 08             	mov    0x8(%ebp),%edx
  800a38:	89 f7                	mov    %esi,%edi
  800a3a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800a3c:	85 c0                	test   %eax,%eax
  800a3e:	7e 28                	jle    800a68 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800a40:	89 44 24 10          	mov    %eax,0x10(%esp)
  800a44:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  800a4b:	00 
  800a4c:	c7 44 24 08 f1 2d 80 	movl   $0x802df1,0x8(%esp)
  800a53:	00 
  800a54:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800a5b:	00 
  800a5c:	c7 04 24 0e 2e 80 00 	movl   $0x802e0e,(%esp)
  800a63:	e8 54 18 00 00       	call   8022bc <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800a68:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800a6b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a6e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a71:	89 ec                	mov    %ebp,%esp
  800a73:	5d                   	pop    %ebp
  800a74:	c3                   	ret    

00800a75 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  800a75:	55                   	push   %ebp
  800a76:	89 e5                	mov    %esp,%ebp
  800a78:	83 ec 0c             	sub    $0xc,%esp
  800a7b:	89 1c 24             	mov    %ebx,(%esp)
  800a7e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800a82:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800a86:	ba 00 00 00 00       	mov    $0x0,%edx
  800a8b:	b8 0b 00 00 00       	mov    $0xb,%eax
  800a90:	89 d1                	mov    %edx,%ecx
  800a92:	89 d3                	mov    %edx,%ebx
  800a94:	89 d7                	mov    %edx,%edi
  800a96:	89 d6                	mov    %edx,%esi
  800a98:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800a9a:	8b 1c 24             	mov    (%esp),%ebx
  800a9d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800aa1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800aa5:	89 ec                	mov    %ebp,%esp
  800aa7:	5d                   	pop    %ebp
  800aa8:	c3                   	ret    

00800aa9 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
  800aac:	83 ec 0c             	sub    $0xc,%esp
  800aaf:	89 1c 24             	mov    %ebx,(%esp)
  800ab2:	89 74 24 04          	mov    %esi,0x4(%esp)
  800ab6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800aba:	ba 00 00 00 00       	mov    $0x0,%edx
  800abf:	b8 02 00 00 00       	mov    $0x2,%eax
  800ac4:	89 d1                	mov    %edx,%ecx
  800ac6:	89 d3                	mov    %edx,%ebx
  800ac8:	89 d7                	mov    %edx,%edi
  800aca:	89 d6                	mov    %edx,%esi
  800acc:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ace:	8b 1c 24             	mov    (%esp),%ebx
  800ad1:	8b 74 24 04          	mov    0x4(%esp),%esi
  800ad5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800ad9:	89 ec                	mov    %ebp,%esp
  800adb:	5d                   	pop    %ebp
  800adc:	c3                   	ret    

00800add <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  800add:	55                   	push   %ebp
  800ade:	89 e5                	mov    %esp,%ebp
  800ae0:	83 ec 38             	sub    $0x38,%esp
  800ae3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800ae6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800ae9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800aec:	b9 00 00 00 00       	mov    $0x0,%ecx
  800af1:	b8 03 00 00 00       	mov    $0x3,%eax
  800af6:	8b 55 08             	mov    0x8(%ebp),%edx
  800af9:	89 cb                	mov    %ecx,%ebx
  800afb:	89 cf                	mov    %ecx,%edi
  800afd:	89 ce                	mov    %ecx,%esi
  800aff:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800b01:	85 c0                	test   %eax,%eax
  800b03:	7e 28                	jle    800b2d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800b05:	89 44 24 10          	mov    %eax,0x10(%esp)
  800b09:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800b10:	00 
  800b11:	c7 44 24 08 f1 2d 80 	movl   $0x802df1,0x8(%esp)
  800b18:	00 
  800b19:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800b20:	00 
  800b21:	c7 04 24 0e 2e 80 00 	movl   $0x802e0e,(%esp)
  800b28:	e8 8f 17 00 00       	call   8022bc <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b2d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800b30:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800b33:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800b36:	89 ec                	mov    %ebp,%esp
  800b38:	5d                   	pop    %ebp
  800b39:	c3                   	ret    
  800b3a:	00 00                	add    %al,(%eax)
  800b3c:	00 00                	add    %al,(%eax)
	...

00800b40 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	05 00 00 00 30       	add    $0x30000000,%eax
  800b4b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  800b4e:	5d                   	pop    %ebp
  800b4f:	c3                   	ret    

00800b50 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800b50:	55                   	push   %ebp
  800b51:	89 e5                	mov    %esp,%ebp
  800b53:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	89 04 24             	mov    %eax,(%esp)
  800b5c:	e8 df ff ff ff       	call   800b40 <fd2num>
  800b61:	05 20 00 0d 00       	add    $0xd0020,%eax
  800b66:	c1 e0 0c             	shl    $0xc,%eax
}
  800b69:	c9                   	leave  
  800b6a:	c3                   	ret    

00800b6b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800b6b:	55                   	push   %ebp
  800b6c:	89 e5                	mov    %esp,%ebp
  800b6e:	57                   	push   %edi
  800b6f:	56                   	push   %esi
  800b70:	53                   	push   %ebx
  800b71:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  800b74:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  800b79:	a8 01                	test   $0x1,%al
  800b7b:	74 36                	je     800bb3 <fd_alloc+0x48>
  800b7d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800b82:	a8 01                	test   $0x1,%al
  800b84:	74 2d                	je     800bb3 <fd_alloc+0x48>
  800b86:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  800b8b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  800b90:	be 00 00 40 ef       	mov    $0xef400000,%esi
  800b95:	89 c3                	mov    %eax,%ebx
  800b97:	89 c2                	mov    %eax,%edx
  800b99:	c1 ea 16             	shr    $0x16,%edx
  800b9c:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  800b9f:	f6 c2 01             	test   $0x1,%dl
  800ba2:	74 14                	je     800bb8 <fd_alloc+0x4d>
  800ba4:	89 c2                	mov    %eax,%edx
  800ba6:	c1 ea 0c             	shr    $0xc,%edx
  800ba9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  800bac:	f6 c2 01             	test   $0x1,%dl
  800baf:	75 10                	jne    800bc1 <fd_alloc+0x56>
  800bb1:	eb 05                	jmp    800bb8 <fd_alloc+0x4d>
  800bb3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  800bb8:	89 1f                	mov    %ebx,(%edi)
  800bba:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  800bbf:	eb 17                	jmp    800bd8 <fd_alloc+0x6d>
  800bc1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800bc6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800bcb:	75 c8                	jne    800b95 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800bcd:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  800bd3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  800bd8:	5b                   	pop    %ebx
  800bd9:	5e                   	pop    %esi
  800bda:	5f                   	pop    %edi
  800bdb:	5d                   	pop    %ebp
  800bdc:	c3                   	ret    

00800bdd <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	83 f8 1f             	cmp    $0x1f,%eax
  800be6:	77 36                	ja     800c1e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800be8:	05 00 00 0d 00       	add    $0xd0000,%eax
  800bed:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  800bf0:	89 c2                	mov    %eax,%edx
  800bf2:	c1 ea 16             	shr    $0x16,%edx
  800bf5:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800bfc:	f6 c2 01             	test   $0x1,%dl
  800bff:	74 1d                	je     800c1e <fd_lookup+0x41>
  800c01:	89 c2                	mov    %eax,%edx
  800c03:	c1 ea 0c             	shr    $0xc,%edx
  800c06:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800c0d:	f6 c2 01             	test   $0x1,%dl
  800c10:	74 0c                	je     800c1e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  800c12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c15:	89 02                	mov    %eax,(%edx)
  800c17:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  800c1c:	eb 05                	jmp    800c23 <fd_lookup+0x46>
  800c1e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800c23:	5d                   	pop    %ebp
  800c24:	c3                   	ret    

00800c25 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800c2b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800c2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c32:	8b 45 08             	mov    0x8(%ebp),%eax
  800c35:	89 04 24             	mov    %eax,(%esp)
  800c38:	e8 a0 ff ff ff       	call   800bdd <fd_lookup>
  800c3d:	85 c0                	test   %eax,%eax
  800c3f:	78 0e                	js     800c4f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800c41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c47:	89 50 04             	mov    %edx,0x4(%eax)
  800c4a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  800c4f:	c9                   	leave  
  800c50:	c3                   	ret    

00800c51 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	56                   	push   %esi
  800c55:	53                   	push   %ebx
  800c56:	83 ec 10             	sub    $0x10,%esp
  800c59:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  800c5f:	b8 04 70 80 00       	mov    $0x807004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  800c64:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800c69:	be 98 2e 80 00       	mov    $0x802e98,%esi
		if (devtab[i]->dev_id == dev_id) {
  800c6e:	39 08                	cmp    %ecx,(%eax)
  800c70:	75 10                	jne    800c82 <dev_lookup+0x31>
  800c72:	eb 04                	jmp    800c78 <dev_lookup+0x27>
  800c74:	39 08                	cmp    %ecx,(%eax)
  800c76:	75 0a                	jne    800c82 <dev_lookup+0x31>
			*dev = devtab[i];
  800c78:	89 03                	mov    %eax,(%ebx)
  800c7a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  800c7f:	90                   	nop
  800c80:	eb 31                	jmp    800cb3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800c82:	83 c2 01             	add    $0x1,%edx
  800c85:	8b 04 96             	mov    (%esi,%edx,4),%eax
  800c88:	85 c0                	test   %eax,%eax
  800c8a:	75 e8                	jne    800c74 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  800c8c:	a1 84 74 80 00       	mov    0x807484,%eax
  800c91:	8b 40 4c             	mov    0x4c(%eax),%eax
  800c94:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800c98:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c9c:	c7 04 24 1c 2e 80 00 	movl   $0x802e1c,(%esp)
  800ca3:	e8 d9 16 00 00       	call   802381 <cprintf>
	*dev = 0;
  800ca8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800cae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  800cb3:	83 c4 10             	add    $0x10,%esp
  800cb6:	5b                   	pop    %ebx
  800cb7:	5e                   	pop    %esi
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	53                   	push   %ebx
  800cbe:	83 ec 24             	sub    $0x24,%esp
  800cc1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cc4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800cc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	89 04 24             	mov    %eax,(%esp)
  800cd1:	e8 07 ff ff ff       	call   800bdd <fd_lookup>
  800cd6:	85 c0                	test   %eax,%eax
  800cd8:	78 53                	js     800d2d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800cda:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ce1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ce4:	8b 00                	mov    (%eax),%eax
  800ce6:	89 04 24             	mov    %eax,(%esp)
  800ce9:	e8 63 ff ff ff       	call   800c51 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cee:	85 c0                	test   %eax,%eax
  800cf0:	78 3b                	js     800d2d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  800cf2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800cf7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800cfa:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  800cfe:	74 2d                	je     800d2d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800d00:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800d03:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800d0a:	00 00 00 
	stat->st_isdir = 0;
  800d0d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800d14:	00 00 00 
	stat->st_dev = dev;
  800d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d1a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800d20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800d24:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800d27:	89 14 24             	mov    %edx,(%esp)
  800d2a:	ff 50 14             	call   *0x14(%eax)
}
  800d2d:	83 c4 24             	add    $0x24,%esp
  800d30:	5b                   	pop    %ebx
  800d31:	5d                   	pop    %ebp
  800d32:	c3                   	ret    

00800d33 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  800d33:	55                   	push   %ebp
  800d34:	89 e5                	mov    %esp,%ebp
  800d36:	53                   	push   %ebx
  800d37:	83 ec 24             	sub    $0x24,%esp
  800d3a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d3d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d40:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d44:	89 1c 24             	mov    %ebx,(%esp)
  800d47:	e8 91 fe ff ff       	call   800bdd <fd_lookup>
  800d4c:	85 c0                	test   %eax,%eax
  800d4e:	78 5f                	js     800daf <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d50:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d53:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d57:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d5a:	8b 00                	mov    (%eax),%eax
  800d5c:	89 04 24             	mov    %eax,(%esp)
  800d5f:	e8 ed fe ff ff       	call   800c51 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d64:	85 c0                	test   %eax,%eax
  800d66:	78 47                	js     800daf <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800d68:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800d6b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  800d6f:	75 23                	jne    800d94 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  800d71:	a1 84 74 80 00       	mov    0x807484,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800d76:	8b 40 4c             	mov    0x4c(%eax),%eax
  800d79:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800d7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d81:	c7 04 24 3c 2e 80 00 	movl   $0x802e3c,(%esp)
  800d88:	e8 f4 15 00 00       	call   802381 <cprintf>
  800d8d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  800d92:	eb 1b                	jmp    800daf <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  800d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d97:	8b 48 18             	mov    0x18(%eax),%ecx
  800d9a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d9f:	85 c9                	test   %ecx,%ecx
  800da1:	74 0c                	je     800daf <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800daa:	89 14 24             	mov    %edx,(%esp)
  800dad:	ff d1                	call   *%ecx
}
  800daf:	83 c4 24             	add    $0x24,%esp
  800db2:	5b                   	pop    %ebx
  800db3:	5d                   	pop    %ebp
  800db4:	c3                   	ret    

00800db5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	53                   	push   %ebx
  800db9:	83 ec 24             	sub    $0x24,%esp
  800dbc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800dbf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800dc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dc6:	89 1c 24             	mov    %ebx,(%esp)
  800dc9:	e8 0f fe ff ff       	call   800bdd <fd_lookup>
  800dce:	85 c0                	test   %eax,%eax
  800dd0:	78 66                	js     800e38 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800dd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800dd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dd9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ddc:	8b 00                	mov    (%eax),%eax
  800dde:	89 04 24             	mov    %eax,(%esp)
  800de1:	e8 6b fe ff ff       	call   800c51 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800de6:	85 c0                	test   %eax,%eax
  800de8:	78 4e                	js     800e38 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800dea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ded:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  800df1:	75 23                	jne    800e16 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  800df3:	a1 84 74 80 00       	mov    0x807484,%eax
  800df8:	8b 40 4c             	mov    0x4c(%eax),%eax
  800dfb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800dff:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e03:	c7 04 24 5d 2e 80 00 	movl   $0x802e5d,(%esp)
  800e0a:	e8 72 15 00 00       	call   802381 <cprintf>
  800e0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  800e14:	eb 22                	jmp    800e38 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800e16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e19:	8b 48 0c             	mov    0xc(%eax),%ecx
  800e1c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800e21:	85 c9                	test   %ecx,%ecx
  800e23:	74 13                	je     800e38 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800e25:	8b 45 10             	mov    0x10(%ebp),%eax
  800e28:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e33:	89 14 24             	mov    %edx,(%esp)
  800e36:	ff d1                	call   *%ecx
}
  800e38:	83 c4 24             	add    $0x24,%esp
  800e3b:	5b                   	pop    %ebx
  800e3c:	5d                   	pop    %ebp
  800e3d:	c3                   	ret    

00800e3e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800e3e:	55                   	push   %ebp
  800e3f:	89 e5                	mov    %esp,%ebp
  800e41:	53                   	push   %ebx
  800e42:	83 ec 24             	sub    $0x24,%esp
  800e45:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e48:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e4b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e4f:	89 1c 24             	mov    %ebx,(%esp)
  800e52:	e8 86 fd ff ff       	call   800bdd <fd_lookup>
  800e57:	85 c0                	test   %eax,%eax
  800e59:	78 6b                	js     800ec6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800e5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e65:	8b 00                	mov    (%eax),%eax
  800e67:	89 04 24             	mov    %eax,(%esp)
  800e6a:	e8 e2 fd ff ff       	call   800c51 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800e6f:	85 c0                	test   %eax,%eax
  800e71:	78 53                	js     800ec6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800e73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800e76:	8b 42 08             	mov    0x8(%edx),%eax
  800e79:	83 e0 03             	and    $0x3,%eax
  800e7c:	83 f8 01             	cmp    $0x1,%eax
  800e7f:	75 23                	jne    800ea4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  800e81:	a1 84 74 80 00       	mov    0x807484,%eax
  800e86:	8b 40 4c             	mov    0x4c(%eax),%eax
  800e89:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800e8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e91:	c7 04 24 7a 2e 80 00 	movl   $0x802e7a,(%esp)
  800e98:	e8 e4 14 00 00       	call   802381 <cprintf>
  800e9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  800ea2:	eb 22                	jmp    800ec6 <read+0x88>
	}
	if (!dev->dev_read)
  800ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ea7:	8b 48 08             	mov    0x8(%eax),%ecx
  800eaa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800eaf:	85 c9                	test   %ecx,%ecx
  800eb1:	74 13                	je     800ec6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb6:	89 44 24 08          	mov    %eax,0x8(%esp)
  800eba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ec1:	89 14 24             	mov    %edx,(%esp)
  800ec4:	ff d1                	call   *%ecx
}
  800ec6:	83 c4 24             	add    $0x24,%esp
  800ec9:	5b                   	pop    %ebx
  800eca:	5d                   	pop    %ebp
  800ecb:	c3                   	ret    

00800ecc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800ecc:	55                   	push   %ebp
  800ecd:	89 e5                	mov    %esp,%ebp
  800ecf:	57                   	push   %edi
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
  800ed2:	83 ec 1c             	sub    $0x1c,%esp
  800ed5:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ed8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800edb:	ba 00 00 00 00       	mov    $0x0,%edx
  800ee0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee5:	b8 00 00 00 00       	mov    $0x0,%eax
  800eea:	85 f6                	test   %esi,%esi
  800eec:	74 29                	je     800f17 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800eee:	89 f0                	mov    %esi,%eax
  800ef0:	29 d0                	sub    %edx,%eax
  800ef2:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ef6:	03 55 0c             	add    0xc(%ebp),%edx
  800ef9:	89 54 24 04          	mov    %edx,0x4(%esp)
  800efd:	89 3c 24             	mov    %edi,(%esp)
  800f00:	e8 39 ff ff ff       	call   800e3e <read>
		if (m < 0)
  800f05:	85 c0                	test   %eax,%eax
  800f07:	78 0e                	js     800f17 <readn+0x4b>
			return m;
		if (m == 0)
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	74 08                	je     800f15 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800f0d:	01 c3                	add    %eax,%ebx
  800f0f:	89 da                	mov    %ebx,%edx
  800f11:	39 f3                	cmp    %esi,%ebx
  800f13:	72 d9                	jb     800eee <readn+0x22>
  800f15:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800f17:	83 c4 1c             	add    $0x1c,%esp
  800f1a:	5b                   	pop    %ebx
  800f1b:	5e                   	pop    %esi
  800f1c:	5f                   	pop    %edi
  800f1d:	5d                   	pop    %ebp
  800f1e:	c3                   	ret    

00800f1f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800f1f:	55                   	push   %ebp
  800f20:	89 e5                	mov    %esp,%ebp
  800f22:	56                   	push   %esi
  800f23:	53                   	push   %ebx
  800f24:	83 ec 20             	sub    $0x20,%esp
  800f27:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f2a:	89 34 24             	mov    %esi,(%esp)
  800f2d:	e8 0e fc ff ff       	call   800b40 <fd2num>
  800f32:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800f35:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f39:	89 04 24             	mov    %eax,(%esp)
  800f3c:	e8 9c fc ff ff       	call   800bdd <fd_lookup>
  800f41:	89 c3                	mov    %eax,%ebx
  800f43:	85 c0                	test   %eax,%eax
  800f45:	78 05                	js     800f4c <fd_close+0x2d>
  800f47:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800f4a:	74 0c                	je     800f58 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  800f4c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800f50:	19 c0                	sbb    %eax,%eax
  800f52:	f7 d0                	not    %eax
  800f54:	21 c3                	and    %eax,%ebx
  800f56:	eb 3d                	jmp    800f95 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f58:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800f5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f5f:	8b 06                	mov    (%esi),%eax
  800f61:	89 04 24             	mov    %eax,(%esp)
  800f64:	e8 e8 fc ff ff       	call   800c51 <dev_lookup>
  800f69:	89 c3                	mov    %eax,%ebx
  800f6b:	85 c0                	test   %eax,%eax
  800f6d:	78 16                	js     800f85 <fd_close+0x66>
		if (dev->dev_close)
  800f6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f72:	8b 40 10             	mov    0x10(%eax),%eax
  800f75:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f7a:	85 c0                	test   %eax,%eax
  800f7c:	74 07                	je     800f85 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  800f7e:	89 34 24             	mov    %esi,(%esp)
  800f81:	ff d0                	call   *%eax
  800f83:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800f85:	89 74 24 04          	mov    %esi,0x4(%esp)
  800f89:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800f90:	e8 c5 f9 ff ff       	call   80095a <sys_page_unmap>
	return r;
}
  800f95:	89 d8                	mov    %ebx,%eax
  800f97:	83 c4 20             	add    $0x20,%esp
  800f9a:	5b                   	pop    %ebx
  800f9b:	5e                   	pop    %esi
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    

00800f9e <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fa4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800fa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	89 04 24             	mov    %eax,(%esp)
  800fb1:	e8 27 fc ff ff       	call   800bdd <fd_lookup>
  800fb6:	85 c0                	test   %eax,%eax
  800fb8:	78 13                	js     800fcd <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  800fba:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800fc1:	00 
  800fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fc5:	89 04 24             	mov    %eax,(%esp)
  800fc8:	e8 52 ff ff ff       	call   800f1f <fd_close>
}
  800fcd:	c9                   	leave  
  800fce:	c3                   	ret    

00800fcf <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  800fcf:	55                   	push   %ebp
  800fd0:	89 e5                	mov    %esp,%ebp
  800fd2:	83 ec 18             	sub    $0x18,%esp
  800fd5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800fd8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800fdb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800fe2:	00 
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	89 04 24             	mov    %eax,(%esp)
  800fe9:	e8 a9 03 00 00       	call   801397 <open>
  800fee:	89 c3                	mov    %eax,%ebx
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	78 1b                	js     80100f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  800ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ff7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ffb:	89 1c 24             	mov    %ebx,(%esp)
  800ffe:	e8 b7 fc ff ff       	call   800cba <fstat>
  801003:	89 c6                	mov    %eax,%esi
	close(fd);
  801005:	89 1c 24             	mov    %ebx,(%esp)
  801008:	e8 91 ff ff ff       	call   800f9e <close>
  80100d:	89 f3                	mov    %esi,%ebx
	return r;
}
  80100f:	89 d8                	mov    %ebx,%eax
  801011:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801014:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801017:	89 ec                	mov    %ebp,%esp
  801019:	5d                   	pop    %ebp
  80101a:	c3                   	ret    

0080101b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  80101b:	55                   	push   %ebp
  80101c:	89 e5                	mov    %esp,%ebp
  80101e:	53                   	push   %ebx
  80101f:	83 ec 14             	sub    $0x14,%esp
  801022:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  801027:	89 1c 24             	mov    %ebx,(%esp)
  80102a:	e8 6f ff ff ff       	call   800f9e <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  80102f:	83 c3 01             	add    $0x1,%ebx
  801032:	83 fb 20             	cmp    $0x20,%ebx
  801035:	75 f0                	jne    801027 <close_all+0xc>
		close(i);
}
  801037:	83 c4 14             	add    $0x14,%esp
  80103a:	5b                   	pop    %ebx
  80103b:	5d                   	pop    %ebp
  80103c:	c3                   	ret    

0080103d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80103d:	55                   	push   %ebp
  80103e:	89 e5                	mov    %esp,%ebp
  801040:	83 ec 58             	sub    $0x58,%esp
  801043:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801046:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801049:	89 7d fc             	mov    %edi,-0x4(%ebp)
  80104c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80104f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801052:	89 44 24 04          	mov    %eax,0x4(%esp)
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	89 04 24             	mov    %eax,(%esp)
  80105c:	e8 7c fb ff ff       	call   800bdd <fd_lookup>
  801061:	89 c3                	mov    %eax,%ebx
  801063:	85 c0                	test   %eax,%eax
  801065:	0f 88 e0 00 00 00    	js     80114b <dup+0x10e>
		return r;
	close(newfdnum);
  80106b:	89 3c 24             	mov    %edi,(%esp)
  80106e:	e8 2b ff ff ff       	call   800f9e <close>

	newfd = INDEX2FD(newfdnum);
  801073:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  801079:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  80107c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80107f:	89 04 24             	mov    %eax,(%esp)
  801082:	e8 c9 fa ff ff       	call   800b50 <fd2data>
  801087:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801089:	89 34 24             	mov    %esi,(%esp)
  80108c:	e8 bf fa ff ff       	call   800b50 <fd2data>
  801091:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  801094:	89 da                	mov    %ebx,%edx
  801096:	89 d8                	mov    %ebx,%eax
  801098:	c1 e8 16             	shr    $0x16,%eax
  80109b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010a2:	a8 01                	test   $0x1,%al
  8010a4:	74 43                	je     8010e9 <dup+0xac>
  8010a6:	c1 ea 0c             	shr    $0xc,%edx
  8010a9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8010b0:	a8 01                	test   $0x1,%al
  8010b2:	74 35                	je     8010e9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  8010b4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  8010bb:	25 07 0e 00 00       	and    $0xe07,%eax
  8010c0:	89 44 24 10          	mov    %eax,0x10(%esp)
  8010c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8010c7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8010cb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8010d2:	00 
  8010d3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010d7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010de:	e8 d5 f8 ff ff       	call   8009b8 <sys_page_map>
  8010e3:	89 c3                	mov    %eax,%ebx
  8010e5:	85 c0                	test   %eax,%eax
  8010e7:	78 3f                	js     801128 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  8010e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8010ec:	89 c2                	mov    %eax,%edx
  8010ee:	c1 ea 0c             	shr    $0xc,%edx
  8010f1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010f8:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  8010fe:	89 54 24 10          	mov    %edx,0x10(%esp)
  801102:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801106:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80110d:	00 
  80110e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801112:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801119:	e8 9a f8 ff ff       	call   8009b8 <sys_page_map>
  80111e:	89 c3                	mov    %eax,%ebx
  801120:	85 c0                	test   %eax,%eax
  801122:	78 04                	js     801128 <dup+0xeb>
  801124:	89 fb                	mov    %edi,%ebx
  801126:	eb 23                	jmp    80114b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801128:	89 74 24 04          	mov    %esi,0x4(%esp)
  80112c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801133:	e8 22 f8 ff ff       	call   80095a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801138:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80113b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80113f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801146:	e8 0f f8 ff ff       	call   80095a <sys_page_unmap>
	return r;
}
  80114b:	89 d8                	mov    %ebx,%eax
  80114d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801150:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801153:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801156:	89 ec                	mov    %ebp,%esp
  801158:	5d                   	pop    %ebp
  801159:	c3                   	ret    
	...

0080115c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80115c:	55                   	push   %ebp
  80115d:	89 e5                	mov    %esp,%ebp
  80115f:	53                   	push   %ebx
  801160:	83 ec 14             	sub    $0x14,%esp
  801163:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801165:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80116b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801172:	00 
  801173:	c7 44 24 08 00 40 80 	movl   $0x804000,0x8(%esp)
  80117a:	00 
  80117b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80117f:	89 14 24             	mov    %edx,(%esp)
  801182:	e8 89 18 00 00       	call   802a10 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801187:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80118e:	00 
  80118f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801193:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80119a:	e8 d3 18 00 00       	call   802a72 <ipc_recv>
}
  80119f:	83 c4 14             	add    $0x14,%esp
  8011a2:	5b                   	pop    %ebx
  8011a3:	5d                   	pop    %ebp
  8011a4:	c3                   	ret    

008011a5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8011ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8011b1:	a3 00 40 80 00       	mov    %eax,0x804000
	fsipcbuf.set_size.req_size = newsize;
  8011b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b9:	a3 04 40 80 00       	mov    %eax,0x804004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8011be:	ba 00 00 00 00       	mov    $0x0,%edx
  8011c3:	b8 02 00 00 00       	mov    $0x2,%eax
  8011c8:	e8 8f ff ff ff       	call   80115c <fsipc>
}
  8011cd:	c9                   	leave  
  8011ce:	c3                   	ret    

008011cf <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8011d5:	ba 00 00 00 00       	mov    $0x0,%edx
  8011da:	b8 08 00 00 00       	mov    $0x8,%eax
  8011df:	e8 78 ff ff ff       	call   80115c <fsipc>
}
  8011e4:	c9                   	leave  
  8011e5:	c3                   	ret    

008011e6 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	53                   	push   %ebx
  8011ea:	83 ec 14             	sub    $0x14,%esp
  8011ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8011f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8011f6:	a3 00 40 80 00       	mov    %eax,0x804000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8011fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801200:	b8 05 00 00 00       	mov    $0x5,%eax
  801205:	e8 52 ff ff ff       	call   80115c <fsipc>
  80120a:	85 c0                	test   %eax,%eax
  80120c:	78 2b                	js     801239 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80120e:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  801215:	00 
  801216:	89 1c 24             	mov    %ebx,(%esp)
  801219:	e8 9c f0 ff ff       	call   8002ba <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80121e:	a1 80 40 80 00       	mov    0x804080,%eax
  801223:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801229:	a1 84 40 80 00       	mov    0x804084,%eax
  80122e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801234:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801239:	83 c4 14             	add    $0x14,%esp
  80123c:	5b                   	pop    %ebx
  80123d:	5d                   	pop    %ebp
  80123e:	c3                   	ret    

0080123f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80123f:	55                   	push   %ebp
  801240:	89 e5                	mov    %esp,%ebp
  801242:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  801245:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80124c:	00 
  80124d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801254:	00 
  801255:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  80125c:	e8 b5 f1 ff ff       	call   800416 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8b 40 0c             	mov    0xc(%eax),%eax
  801267:	a3 00 40 80 00       	mov    %eax,0x804000
	return fsipc(FSREQ_FLUSH, NULL);
  80126c:	ba 00 00 00 00       	mov    $0x0,%edx
  801271:	b8 06 00 00 00       	mov    $0x6,%eax
  801276:	e8 e1 fe ff ff       	call   80115c <fsipc>
}
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    

0080127d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801283:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80128a:	00 
  80128b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801292:	00 
  801293:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  80129a:	e8 77 f1 ff ff       	call   800416 <memset>
  80129f:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a2:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8012a7:	76 05                	jbe    8012ae <devfile_write+0x31>
  8012a9:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8012ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b1:	8b 52 0c             	mov    0xc(%edx),%edx
  8012b4:	89 15 00 40 80 00    	mov    %edx,0x804000
        fsipcbuf.write.req_n = numberOfBytes;
  8012ba:	a3 04 40 80 00       	mov    %eax,0x804004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  8012bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8012c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8012ca:	c7 04 24 08 40 80 00 	movl   $0x804008,(%esp)
  8012d1:	e8 9f f1 ff ff       	call   800475 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  8012d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8012db:	b8 04 00 00 00       	mov    $0x4,%eax
  8012e0:	e8 77 fe ff ff       	call   80115c <fsipc>
              return r;
        return r;
}
  8012e5:	c9                   	leave  
  8012e6:	c3                   	ret    

008012e7 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8012e7:	55                   	push   %ebp
  8012e8:	89 e5                	mov    %esp,%ebp
  8012ea:	53                   	push   %ebx
  8012eb:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  8012ee:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8012f5:	00 
  8012f6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8012fd:	00 
  8012fe:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801305:	e8 0c f1 ff ff       	call   800416 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
  80130d:	8b 40 0c             	mov    0xc(%eax),%eax
  801310:	a3 00 40 80 00       	mov    %eax,0x804000
        fsipcbuf.read.req_n = n;
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	a3 04 40 80 00       	mov    %eax,0x804004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  80131d:	ba 00 00 00 00       	mov    $0x0,%edx
  801322:	b8 03 00 00 00       	mov    $0x3,%eax
  801327:	e8 30 fe ff ff       	call   80115c <fsipc>
  80132c:	89 c3                	mov    %eax,%ebx
  80132e:	85 c0                	test   %eax,%eax
  801330:	78 17                	js     801349 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  801332:	89 44 24 08          	mov    %eax,0x8(%esp)
  801336:	c7 44 24 04 00 40 80 	movl   $0x804000,0x4(%esp)
  80133d:	00 
  80133e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801341:	89 04 24             	mov    %eax,(%esp)
  801344:	e8 2c f1 ff ff       	call   800475 <memmove>
        return r;
}
  801349:	89 d8                	mov    %ebx,%eax
  80134b:	83 c4 14             	add    $0x14,%esp
  80134e:	5b                   	pop    %ebx
  80134f:	5d                   	pop    %ebp
  801350:	c3                   	ret    

00801351 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801351:	55                   	push   %ebp
  801352:	89 e5                	mov    %esp,%ebp
  801354:	53                   	push   %ebx
  801355:	83 ec 14             	sub    $0x14,%esp
  801358:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  80135b:	89 1c 24             	mov    %ebx,(%esp)
  80135e:	e8 0d ef ff ff       	call   800270 <strlen>
  801363:	89 c2                	mov    %eax,%edx
  801365:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80136a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801370:	7f 1f                	jg     801391 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801372:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801376:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  80137d:	e8 38 ef ff ff       	call   8002ba <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801382:	ba 00 00 00 00       	mov    $0x0,%edx
  801387:	b8 07 00 00 00       	mov    $0x7,%eax
  80138c:	e8 cb fd ff ff       	call   80115c <fsipc>
}
  801391:	83 c4 14             	add    $0x14,%esp
  801394:	5b                   	pop    %ebx
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    

00801397 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  801397:	55                   	push   %ebp
  801398:	89 e5                	mov    %esp,%ebp
  80139a:	56                   	push   %esi
  80139b:	53                   	push   %ebx
  80139c:	83 ec 20             	sub    $0x20,%esp
  80139f:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  8013a2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8013a9:	00 
  8013aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8013b1:	00 
  8013b2:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  8013b9:	e8 58 f0 ff ff       	call   800416 <memset>
    if(strlen(path)>=MAXPATHLEN)
  8013be:	89 34 24             	mov    %esi,(%esp)
  8013c1:	e8 aa ee ff ff       	call   800270 <strlen>
  8013c6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8013cb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8013d0:	0f 8f 84 00 00 00    	jg     80145a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  8013d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d9:	89 04 24             	mov    %eax,(%esp)
  8013dc:	e8 8a f7 ff ff       	call   800b6b <fd_alloc>
  8013e1:	89 c3                	mov    %eax,%ebx
  8013e3:	85 c0                	test   %eax,%eax
  8013e5:	78 73                	js     80145a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  8013e7:	0f b6 06             	movzbl (%esi),%eax
  8013ea:	84 c0                	test   %al,%al
  8013ec:	74 20                	je     80140e <open+0x77>
  8013ee:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  8013f0:	0f be c0             	movsbl %al,%eax
  8013f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013f7:	c7 04 24 ac 2e 80 00 	movl   $0x802eac,(%esp)
  8013fe:	e8 7e 0f 00 00       	call   802381 <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  801403:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  801407:	83 c3 01             	add    $0x1,%ebx
  80140a:	84 c0                	test   %al,%al
  80140c:	75 e2                	jne    8013f0 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  80140e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801412:	c7 04 24 00 40 80 00 	movl   $0x804000,(%esp)
  801419:	e8 9c ee ff ff       	call   8002ba <strcpy>
    fsipcbuf.open.req_omode = mode;
  80141e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801421:	a3 00 44 80 00       	mov    %eax,0x804400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  801426:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801429:	b8 01 00 00 00       	mov    $0x1,%eax
  80142e:	e8 29 fd ff ff       	call   80115c <fsipc>
  801433:	89 c3                	mov    %eax,%ebx
  801435:	85 c0                	test   %eax,%eax
  801437:	79 15                	jns    80144e <open+0xb7>
        {
            fd_close(fd,1);
  801439:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801440:	00 
  801441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801444:	89 04 24             	mov    %eax,(%esp)
  801447:	e8 d3 fa ff ff       	call   800f1f <fd_close>
             return r;
  80144c:	eb 0c                	jmp    80145a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  80144e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801451:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  801457:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  80145a:	89 d8                	mov    %ebx,%eax
  80145c:	83 c4 20             	add    $0x20,%esp
  80145f:	5b                   	pop    %ebx
  801460:	5e                   	pop    %esi
  801461:	5d                   	pop    %ebp
  801462:	c3                   	ret    
	...

00801464 <writebuf>:
};


static void
writebuf(struct printbuf *b)
{
  801464:	55                   	push   %ebp
  801465:	89 e5                	mov    %esp,%ebp
  801467:	53                   	push   %ebx
  801468:	83 ec 14             	sub    $0x14,%esp
  80146b:	89 c3                	mov    %eax,%ebx
	if (b->error > 0) {
  80146d:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801471:	7e 34                	jle    8014a7 <writebuf+0x43>
		ssize_t result = write(b->fd, b->buf, b->idx);
  801473:	8b 40 04             	mov    0x4(%eax),%eax
  801476:	89 44 24 08          	mov    %eax,0x8(%esp)
  80147a:	8d 43 10             	lea    0x10(%ebx),%eax
  80147d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801481:	8b 03                	mov    (%ebx),%eax
  801483:	89 04 24             	mov    %eax,(%esp)
  801486:	e8 2a f9 ff ff       	call   800db5 <write>
		if (result > 0)
  80148b:	85 c0                	test   %eax,%eax
  80148d:	7e 03                	jle    801492 <writebuf+0x2e>
			b->result += result;
  80148f:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801492:	3b 43 04             	cmp    0x4(%ebx),%eax
  801495:	74 10                	je     8014a7 <writebuf+0x43>
			b->error = (result < 0 ? result : 0);
  801497:	85 c0                	test   %eax,%eax
  801499:	0f 9f c2             	setg   %dl
  80149c:	0f b6 d2             	movzbl %dl,%edx
  80149f:	83 ea 01             	sub    $0x1,%edx
  8014a2:	21 d0                	and    %edx,%eax
  8014a4:	89 43 0c             	mov    %eax,0xc(%ebx)
	}
}
  8014a7:	83 c4 14             	add    $0x14,%esp
  8014aa:	5b                   	pop    %ebx
  8014ab:	5d                   	pop    %ebp
  8014ac:	c3                   	ret    

008014ad <vfprintf>:
	}
}

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8014ad:	55                   	push   %ebp
  8014ae:	89 e5                	mov    %esp,%ebp
  8014b0:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.fd = fd;
  8014b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b9:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8014bf:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8014c6:	00 00 00 
	b.result = 0;
  8014c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8014d0:	00 00 00 
	b.error = 1;
  8014d3:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8014da:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8014dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8014e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8014eb:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8014f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8014f5:	c7 04 24 6a 15 80 00 	movl   $0x80156a,(%esp)
  8014fc:	e8 2c 10 00 00       	call   80252d <vprintfmt>
	if (b.idx > 0)
  801501:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801508:	7e 0b                	jle    801515 <vfprintf+0x68>
		writebuf(&b);
  80150a:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801510:	e8 4f ff ff ff       	call   801464 <writebuf>

	return (b.result ? b.result : b.error);
  801515:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80151b:	85 c0                	test   %eax,%eax
  80151d:	75 06                	jne    801525 <vfprintf+0x78>
  80151f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801525:	c9                   	leave  
  801526:	c3                   	ret    

00801527 <printf>:
	return cnt;
}

int
printf(const char *fmt, ...)
{
  801527:	55                   	push   %ebp
  801528:	89 e5                	mov    %esp,%ebp
  80152a:	83 ec 18             	sub    $0x18,%esp

	return cnt;
}

int
printf(const char *fmt, ...)
  80152d:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(1, fmt, ap);
  801530:	89 44 24 08          	mov    %eax,0x8(%esp)
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	89 44 24 04          	mov    %eax,0x4(%esp)
  80153b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  801542:	e8 66 ff ff ff       	call   8014ad <vfprintf>
	va_end(ap);

	return cnt;
}
  801547:	c9                   	leave  
  801548:	c3                   	ret    

00801549 <fprintf>:
	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
{
  801549:	55                   	push   %ebp
  80154a:	89 e5                	mov    %esp,%ebp
  80154c:	83 ec 18             	sub    $0x18,%esp

	return (b.result ? b.result : b.error);
}

int
fprintf(int fd, const char *fmt, ...)
  80154f:	8d 45 10             	lea    0x10(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vfprintf(fd, fmt, ap);
  801552:	89 44 24 08          	mov    %eax,0x8(%esp)
  801556:	8b 45 0c             	mov    0xc(%ebp),%eax
  801559:	89 44 24 04          	mov    %eax,0x4(%esp)
  80155d:	8b 45 08             	mov    0x8(%ebp),%eax
  801560:	89 04 24             	mov    %eax,(%esp)
  801563:	e8 45 ff ff ff       	call   8014ad <vfprintf>
	va_end(ap);

	return cnt;
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <putch>:
	}
}

static void
putch(int ch, void *thunk)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	53                   	push   %ebx
  80156e:	83 ec 04             	sub    $0x4,%esp
	struct printbuf *b = (struct printbuf *) thunk;
  801571:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801574:	8b 43 04             	mov    0x4(%ebx),%eax
  801577:	8b 55 08             	mov    0x8(%ebp),%edx
  80157a:	88 54 03 10          	mov    %dl,0x10(%ebx,%eax,1)
  80157e:	83 c0 01             	add    $0x1,%eax
  801581:	89 43 04             	mov    %eax,0x4(%ebx)
	if (b->idx == 256) {
  801584:	3d 00 01 00 00       	cmp    $0x100,%eax
  801589:	75 0e                	jne    801599 <putch+0x2f>
		writebuf(b);
  80158b:	89 d8                	mov    %ebx,%eax
  80158d:	e8 d2 fe ff ff       	call   801464 <writebuf>
		b->idx = 0;
  801592:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
	}
}
  801599:	83 c4 04             	add    $0x4,%esp
  80159c:	5b                   	pop    %ebx
  80159d:	5d                   	pop    %ebp
  80159e:	c3                   	ret    
	...

008015a0 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  8015a6:	c7 44 24 04 af 2e 80 	movl   $0x802eaf,0x4(%esp)
  8015ad:	00 
  8015ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b1:	89 04 24             	mov    %eax,(%esp)
  8015b4:	e8 01 ed ff ff       	call   8002ba <strcpy>
	return 0;
}
  8015b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015be:	c9                   	leave  
  8015bf:	c3                   	ret    

008015c0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  8015c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8015cc:	89 04 24             	mov    %eax,(%esp)
  8015cf:	e8 9e 02 00 00       	call   801872 <nsipc_close>
}
  8015d4:	c9                   	leave  
  8015d5:	c3                   	ret    

008015d6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8015d6:	55                   	push   %ebp
  8015d7:	89 e5                	mov    %esp,%ebp
  8015d9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8015dc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8015e3:	00 
  8015e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8015e7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8015eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8015f8:	89 04 24             	mov    %eax,(%esp)
  8015fb:	e8 ae 02 00 00       	call   8018ae <nsipc_send>
}
  801600:	c9                   	leave  
  801601:	c3                   	ret    

00801602 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  801602:	55                   	push   %ebp
  801603:	89 e5                	mov    %esp,%ebp
  801605:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  801608:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80160f:	00 
  801610:	8b 45 10             	mov    0x10(%ebp),%eax
  801613:	89 44 24 08          	mov    %eax,0x8(%esp)
  801617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80161a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80161e:	8b 45 08             	mov    0x8(%ebp),%eax
  801621:	8b 40 0c             	mov    0xc(%eax),%eax
  801624:	89 04 24             	mov    %eax,(%esp)
  801627:	e8 f5 02 00 00       	call   801921 <nsipc_recv>
}
  80162c:	c9                   	leave  
  80162d:	c3                   	ret    

0080162e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  80162e:	55                   	push   %ebp
  80162f:	89 e5                	mov    %esp,%ebp
  801631:	56                   	push   %esi
  801632:	53                   	push   %ebx
  801633:	83 ec 20             	sub    $0x20,%esp
  801636:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801638:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80163b:	89 04 24             	mov    %eax,(%esp)
  80163e:	e8 28 f5 ff ff       	call   800b6b <fd_alloc>
  801643:	89 c3                	mov    %eax,%ebx
  801645:	85 c0                	test   %eax,%eax
  801647:	78 21                	js     80166a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801649:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801650:	00 
  801651:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801654:	89 44 24 04          	mov    %eax,0x4(%esp)
  801658:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80165f:	e8 b2 f3 ff ff       	call   800a16 <sys_page_alloc>
  801664:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801666:	85 c0                	test   %eax,%eax
  801668:	79 0a                	jns    801674 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80166a:	89 34 24             	mov    %esi,(%esp)
  80166d:	e8 00 02 00 00       	call   801872 <nsipc_close>
		return r;
  801672:	eb 28                	jmp    80169c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801674:	8b 15 20 70 80 00    	mov    0x807020,%edx
  80167a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80167d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80167f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801682:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80168c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80168f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801692:	89 04 24             	mov    %eax,(%esp)
  801695:	e8 a6 f4 ff ff       	call   800b40 <fd2num>
  80169a:	89 c3                	mov    %eax,%ebx
}
  80169c:	89 d8                	mov    %ebx,%eax
  80169e:	83 c4 20             	add    $0x20,%esp
  8016a1:	5b                   	pop    %ebx
  8016a2:	5e                   	pop    %esi
  8016a3:	5d                   	pop    %ebp
  8016a4:	c3                   	ret    

008016a5 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  8016a5:	55                   	push   %ebp
  8016a6:	89 e5                	mov    %esp,%ebp
  8016a8:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  8016ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ae:	89 44 24 08          	mov    %eax,0x8(%esp)
  8016b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	89 04 24             	mov    %eax,(%esp)
  8016bf:	e8 62 01 00 00       	call   801826 <nsipc_socket>
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	78 05                	js     8016cd <socket+0x28>
		return r;
	return alloc_sockfd(r);
  8016c8:	e8 61 ff ff ff       	call   80162e <alloc_sockfd>
}
  8016cd:	c9                   	leave  
  8016ce:	66 90                	xchg   %ax,%ax
  8016d0:	c3                   	ret    

008016d1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8016d7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8016da:	89 54 24 04          	mov    %edx,0x4(%esp)
  8016de:	89 04 24             	mov    %eax,(%esp)
  8016e1:	e8 f7 f4 ff ff       	call   800bdd <fd_lookup>
  8016e6:	85 c0                	test   %eax,%eax
  8016e8:	78 15                	js     8016ff <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8016ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016ed:	8b 0a                	mov    (%edx),%ecx
  8016ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016f4:	3b 0d 20 70 80 00    	cmp    0x807020,%ecx
  8016fa:	75 03                	jne    8016ff <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8016fc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	e8 c2 ff ff ff       	call   8016d1 <fd2sockid>
  80170f:	85 c0                	test   %eax,%eax
  801711:	78 0f                	js     801722 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  801713:	8b 55 0c             	mov    0xc(%ebp),%edx
  801716:	89 54 24 04          	mov    %edx,0x4(%esp)
  80171a:	89 04 24             	mov    %eax,(%esp)
  80171d:	e8 2e 01 00 00       	call   801850 <nsipc_listen>
}
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
  801727:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	e8 9f ff ff ff       	call   8016d1 <fd2sockid>
  801732:	85 c0                	test   %eax,%eax
  801734:	78 16                	js     80174c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801736:	8b 55 10             	mov    0x10(%ebp),%edx
  801739:	89 54 24 08          	mov    %edx,0x8(%esp)
  80173d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801740:	89 54 24 04          	mov    %edx,0x4(%esp)
  801744:	89 04 24             	mov    %eax,(%esp)
  801747:	e8 55 02 00 00       	call   8019a1 <nsipc_connect>
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801754:	8b 45 08             	mov    0x8(%ebp),%eax
  801757:	e8 75 ff ff ff       	call   8016d1 <fd2sockid>
  80175c:	85 c0                	test   %eax,%eax
  80175e:	78 0f                	js     80176f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801760:	8b 55 0c             	mov    0xc(%ebp),%edx
  801763:	89 54 24 04          	mov    %edx,0x4(%esp)
  801767:	89 04 24             	mov    %eax,(%esp)
  80176a:	e8 1d 01 00 00       	call   80188c <nsipc_shutdown>
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801777:	8b 45 08             	mov    0x8(%ebp),%eax
  80177a:	e8 52 ff ff ff       	call   8016d1 <fd2sockid>
  80177f:	85 c0                	test   %eax,%eax
  801781:	78 16                	js     801799 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801783:	8b 55 10             	mov    0x10(%ebp),%edx
  801786:	89 54 24 08          	mov    %edx,0x8(%esp)
  80178a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801791:	89 04 24             	mov    %eax,(%esp)
  801794:	e8 47 02 00 00       	call   8019e0 <nsipc_bind>
}
  801799:	c9                   	leave  
  80179a:	c3                   	ret    

0080179b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80179b:	55                   	push   %ebp
  80179c:	89 e5                	mov    %esp,%ebp
  80179e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8017a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a4:	e8 28 ff ff ff       	call   8016d1 <fd2sockid>
  8017a9:	85 c0                	test   %eax,%eax
  8017ab:	78 1f                	js     8017cc <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  8017ad:	8b 55 10             	mov    0x10(%ebp),%edx
  8017b0:	89 54 24 08          	mov    %edx,0x8(%esp)
  8017b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b7:	89 54 24 04          	mov    %edx,0x4(%esp)
  8017bb:	89 04 24             	mov    %eax,(%esp)
  8017be:	e8 5c 02 00 00       	call   801a1f <nsipc_accept>
  8017c3:	85 c0                	test   %eax,%eax
  8017c5:	78 05                	js     8017cc <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8017c7:	e8 62 fe ff ff       	call   80162e <alloc_sockfd>
}
  8017cc:	c9                   	leave  
  8017cd:	8d 76 00             	lea    0x0(%esi),%esi
  8017d0:	c3                   	ret    
	...

008017e0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8017e6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8017ec:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8017f3:	00 
  8017f4:	c7 44 24 08 00 60 80 	movl   $0x806000,0x8(%esp)
  8017fb:	00 
  8017fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  801800:	89 14 24             	mov    %edx,(%esp)
  801803:	e8 08 12 00 00       	call   802a10 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  801808:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80180f:	00 
  801810:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801817:	00 
  801818:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80181f:	e8 4e 12 00 00       	call   802a72 <ipc_recv>
}
  801824:	c9                   	leave  
  801825:	c3                   	ret    

00801826 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.socket.req_type = type;
  801834:	8b 45 0c             	mov    0xc(%ebp),%eax
  801837:	a3 04 60 80 00       	mov    %eax,0x806004
	nsipcbuf.socket.req_protocol = protocol;
  80183c:	8b 45 10             	mov    0x10(%ebp),%eax
  80183f:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SOCKET);
  801844:	b8 09 00 00 00       	mov    $0x9,%eax
  801849:	e8 92 ff ff ff       	call   8017e0 <nsipc>
}
  80184e:	c9                   	leave  
  80184f:	c3                   	ret    

00801850 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.listen.req_backlog = backlog;
  80185e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801861:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_LISTEN);
  801866:	b8 06 00 00 00       	mov    $0x6,%eax
  80186b:	e8 70 ff ff ff       	call   8017e0 <nsipc>
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
  801875:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801878:	8b 45 08             	mov    0x8(%ebp),%eax
  80187b:	a3 00 60 80 00       	mov    %eax,0x806000
	return nsipc(NSREQ_CLOSE);
  801880:	b8 04 00 00 00       	mov    $0x4,%eax
  801885:	e8 56 ff ff ff       	call   8017e0 <nsipc>
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
  80188f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801892:	8b 45 08             	mov    0x8(%ebp),%eax
  801895:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.shutdown.req_how = how;
  80189a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80189d:	a3 04 60 80 00       	mov    %eax,0x806004
	return nsipc(NSREQ_SHUTDOWN);
  8018a2:	b8 03 00 00 00       	mov    $0x3,%eax
  8018a7:	e8 34 ff ff ff       	call   8017e0 <nsipc>
}
  8018ac:	c9                   	leave  
  8018ad:	c3                   	ret    

008018ae <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  8018ae:	55                   	push   %ebp
  8018af:	89 e5                	mov    %esp,%ebp
  8018b1:	53                   	push   %ebx
  8018b2:	83 ec 14             	sub    $0x14,%esp
  8018b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  8018b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bb:	a3 00 60 80 00       	mov    %eax,0x806000
	assert(size < 1600);
  8018c0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8018c6:	7e 24                	jle    8018ec <nsipc_send+0x3e>
  8018c8:	c7 44 24 0c bb 2e 80 	movl   $0x802ebb,0xc(%esp)
  8018cf:	00 
  8018d0:	c7 44 24 08 c7 2e 80 	movl   $0x802ec7,0x8(%esp)
  8018d7:	00 
  8018d8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8018df:	00 
  8018e0:	c7 04 24 dc 2e 80 00 	movl   $0x802edc,(%esp)
  8018e7:	e8 d0 09 00 00       	call   8022bc <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8018ec:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8018f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018f7:	c7 04 24 0c 60 80 00 	movl   $0x80600c,(%esp)
  8018fe:	e8 72 eb ff ff       	call   800475 <memmove>
	nsipcbuf.send.req_size = size;
  801903:	89 1d 04 60 80 00    	mov    %ebx,0x806004
	nsipcbuf.send.req_flags = flags;
  801909:	8b 45 14             	mov    0x14(%ebp),%eax
  80190c:	a3 08 60 80 00       	mov    %eax,0x806008
	return nsipc(NSREQ_SEND);
  801911:	b8 08 00 00 00       	mov    $0x8,%eax
  801916:	e8 c5 fe ff ff       	call   8017e0 <nsipc>
}
  80191b:	83 c4 14             	add    $0x14,%esp
  80191e:	5b                   	pop    %ebx
  80191f:	5d                   	pop    %ebp
  801920:	c3                   	ret    

00801921 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	56                   	push   %esi
  801925:	53                   	push   %ebx
  801926:	83 ec 10             	sub    $0x10,%esp
  801929:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80192c:	8b 45 08             	mov    0x8(%ebp),%eax
  80192f:	a3 00 60 80 00       	mov    %eax,0x806000
	nsipcbuf.recv.req_len = len;
  801934:	89 35 04 60 80 00    	mov    %esi,0x806004
	nsipcbuf.recv.req_flags = flags;
  80193a:	8b 45 14             	mov    0x14(%ebp),%eax
  80193d:	a3 08 60 80 00       	mov    %eax,0x806008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801942:	b8 07 00 00 00       	mov    $0x7,%eax
  801947:	e8 94 fe ff ff       	call   8017e0 <nsipc>
  80194c:	89 c3                	mov    %eax,%ebx
  80194e:	85 c0                	test   %eax,%eax
  801950:	78 46                	js     801998 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801952:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801957:	7f 04                	jg     80195d <nsipc_recv+0x3c>
  801959:	39 c6                	cmp    %eax,%esi
  80195b:	7d 24                	jge    801981 <nsipc_recv+0x60>
  80195d:	c7 44 24 0c e8 2e 80 	movl   $0x802ee8,0xc(%esp)
  801964:	00 
  801965:	c7 44 24 08 c7 2e 80 	movl   $0x802ec7,0x8(%esp)
  80196c:	00 
  80196d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801974:	00 
  801975:	c7 04 24 dc 2e 80 00 	movl   $0x802edc,(%esp)
  80197c:	e8 3b 09 00 00       	call   8022bc <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801981:	89 44 24 08          	mov    %eax,0x8(%esp)
  801985:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  80198c:	00 
  80198d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801990:	89 04 24             	mov    %eax,(%esp)
  801993:	e8 dd ea ff ff       	call   800475 <memmove>
	}

	return r;
}
  801998:	89 d8                	mov    %ebx,%eax
  80199a:	83 c4 10             	add    $0x10,%esp
  80199d:	5b                   	pop    %ebx
  80199e:	5e                   	pop    %esi
  80199f:	5d                   	pop    %ebp
  8019a0:	c3                   	ret    

008019a1 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  8019a1:	55                   	push   %ebp
  8019a2:	89 e5                	mov    %esp,%ebp
  8019a4:	53                   	push   %ebx
  8019a5:	83 ec 14             	sub    $0x14,%esp
  8019a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  8019b3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019be:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  8019c5:	e8 ab ea ff ff       	call   800475 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8019ca:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_CONNECT);
  8019d0:	b8 05 00 00 00       	mov    $0x5,%eax
  8019d5:	e8 06 fe ff ff       	call   8017e0 <nsipc>
}
  8019da:	83 c4 14             	add    $0x14,%esp
  8019dd:	5b                   	pop    %ebx
  8019de:	5d                   	pop    %ebp
  8019df:	c3                   	ret    

008019e0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	53                   	push   %ebx
  8019e4:	83 ec 14             	sub    $0x14,%esp
  8019e7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8019ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ed:	a3 00 60 80 00       	mov    %eax,0x806000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8019f2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8019f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8019fd:	c7 04 24 04 60 80 00 	movl   $0x806004,(%esp)
  801a04:	e8 6c ea ff ff       	call   800475 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  801a09:	89 1d 14 60 80 00    	mov    %ebx,0x806014
	return nsipc(NSREQ_BIND);
  801a0f:	b8 02 00 00 00       	mov    $0x2,%eax
  801a14:	e8 c7 fd ff ff       	call   8017e0 <nsipc>
}
  801a19:	83 c4 14             	add    $0x14,%esp
  801a1c:	5b                   	pop    %ebx
  801a1d:	5d                   	pop    %ebp
  801a1e:	c3                   	ret    

00801a1f <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	83 ec 18             	sub    $0x18,%esp
  801a25:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801a28:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801a33:	b8 01 00 00 00       	mov    $0x1,%eax
  801a38:	e8 a3 fd ff ff       	call   8017e0 <nsipc>
  801a3d:	89 c3                	mov    %eax,%ebx
  801a3f:	85 c0                	test   %eax,%eax
  801a41:	78 25                	js     801a68 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801a43:	be 10 60 80 00       	mov    $0x806010,%esi
  801a48:	8b 06                	mov    (%esi),%eax
  801a4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  801a4e:	c7 44 24 04 00 60 80 	movl   $0x806000,0x4(%esp)
  801a55:	00 
  801a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a59:	89 04 24             	mov    %eax,(%esp)
  801a5c:	e8 14 ea ff ff       	call   800475 <memmove>
		*addrlen = ret->ret_addrlen;
  801a61:	8b 16                	mov    (%esi),%edx
  801a63:	8b 45 10             	mov    0x10(%ebp),%eax
  801a66:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  801a68:	89 d8                	mov    %ebx,%eax
  801a6a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801a6d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801a70:	89 ec                	mov    %ebp,%esp
  801a72:	5d                   	pop    %ebp
  801a73:	c3                   	ret    
	...

00801a80 <free>:
	return v;
}

void
free(void *v)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
  801a83:	56                   	push   %esi
  801a84:	53                   	push   %ebx
  801a85:	83 ec 10             	sub    $0x10,%esp
  801a88:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint8_t *c;
	uint32_t *ref;

	if (v == 0)
  801a8b:	85 db                	test   %ebx,%ebx
  801a8d:	0f 84 b9 00 00 00    	je     801b4c <free+0xcc>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);
  801a93:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  801a99:	76 08                	jbe    801aa3 <free+0x23>
  801a9b:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  801aa1:	76 24                	jbe    801ac7 <free+0x47>
  801aa3:	c7 44 24 0c 00 2f 80 	movl   $0x802f00,0xc(%esp)
  801aaa:	00 
  801aab:	c7 44 24 08 c7 2e 80 	movl   $0x802ec7,0x8(%esp)
  801ab2:	00 
  801ab3:	c7 44 24 04 7a 00 00 	movl   $0x7a,0x4(%esp)
  801aba:	00 
  801abb:	c7 04 24 2e 2f 80 00 	movl   $0x802f2e,(%esp)
  801ac2:	e8 f5 07 00 00       	call   8022bc <_panic>

	c = ROUNDDOWN(v, PGSIZE);
  801ac7:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx

	while (vpt[VPN(c)] & PTE_CONTINUED) {
  801acd:	be 00 00 40 ef       	mov    $0xef400000,%esi
  801ad2:	eb 4a                	jmp    801b1e <free+0x9e>
		sys_page_unmap(0, c);
  801ad4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801ad8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801adf:	e8 76 ee ff ff       	call   80095a <sys_page_unmap>
		c += PGSIZE;
  801ae4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		assert(mbegin <= c && c < mend);
  801aea:	81 fb ff ff ff 07    	cmp    $0x7ffffff,%ebx
  801af0:	76 08                	jbe    801afa <free+0x7a>
  801af2:	81 fb ff ff ff 0f    	cmp    $0xfffffff,%ebx
  801af8:	76 24                	jbe    801b1e <free+0x9e>
  801afa:	c7 44 24 0c 3b 2f 80 	movl   $0x802f3b,0xc(%esp)
  801b01:	00 
  801b02:	c7 44 24 08 c7 2e 80 	movl   $0x802ec7,0x8(%esp)
  801b09:	00 
  801b0a:	c7 44 24 04 81 00 00 	movl   $0x81,0x4(%esp)
  801b11:	00 
  801b12:	c7 04 24 2e 2f 80 00 	movl   $0x802f2e,(%esp)
  801b19:	e8 9e 07 00 00       	call   8022bc <_panic>
		return;
	assert(mbegin <= (uint8_t*) v && (uint8_t*) v < mend);

	c = ROUNDDOWN(v, PGSIZE);

	while (vpt[VPN(c)] & PTE_CONTINUED) {
  801b1e:	89 d8                	mov    %ebx,%eax
  801b20:	c1 e8 0c             	shr    $0xc,%eax
  801b23:	8b 04 86             	mov    (%esi,%eax,4),%eax
  801b26:	f6 c4 04             	test   $0x4,%ah
  801b29:	75 a9                	jne    801ad4 <free+0x54>

	/*
	 * c is just a piece of this page, so dec the ref count
	 * and maybe free the page.
	 */
	ref = (uint32_t*) (c + PGSIZE - 4);
  801b2b:	8d 93 fc 0f 00 00    	lea    0xffc(%ebx),%edx
	if (--(*ref) == 0)
  801b31:	8b 02                	mov    (%edx),%eax
  801b33:	83 e8 01             	sub    $0x1,%eax
  801b36:	89 02                	mov    %eax,(%edx)
  801b38:	85 c0                	test   %eax,%eax
  801b3a:	75 10                	jne    801b4c <free+0xcc>
		sys_page_unmap(0, c);	
  801b3c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801b40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b47:	e8 0e ee ff ff       	call   80095a <sys_page_unmap>
}
  801b4c:	83 c4 10             	add    $0x10,%esp
  801b4f:	5b                   	pop    %ebx
  801b50:	5e                   	pop    %esi
  801b51:	5d                   	pop    %ebp
  801b52:	c3                   	ret    

00801b53 <malloc>:
	return 1;
}

void*
malloc(size_t n)
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	57                   	push   %edi
  801b57:	56                   	push   %esi
  801b58:	53                   	push   %ebx
  801b59:	83 ec 3c             	sub    $0x3c,%esp
	int i, cont;
	int nwrap;
	uint32_t *ref;
	void *v;

	if (mptr == 0)
  801b5c:	83 3d 80 74 80 00 00 	cmpl   $0x0,0x807480
  801b63:	75 0a                	jne    801b6f <malloc+0x1c>
		mptr = mbegin;
  801b65:	c7 05 80 74 80 00 00 	movl   $0x8000000,0x807480
  801b6c:	00 00 08 

	n = ROUNDUP(n, 4);
  801b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b72:	83 c0 03             	add    $0x3,%eax
  801b75:	83 e0 fc             	and    $0xfffffffc,%eax
  801b78:	89 45 d8             	mov    %eax,-0x28(%ebp)

	if (n >= MAXMALLOC)
  801b7b:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
  801b80:	0f 87 97 01 00 00    	ja     801d1d <malloc+0x1ca>
		return 0;

	if ((uintptr_t) mptr % PGSIZE){
  801b86:	a1 80 74 80 00       	mov    0x807480,%eax
  801b8b:	89 c2                	mov    %eax,%edx
  801b8d:	a9 ff 0f 00 00       	test   $0xfff,%eax
  801b92:	74 4d                	je     801be1 <malloc+0x8e>
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
  801b94:	89 c3                	mov    %eax,%ebx
  801b96:	c1 eb 0c             	shr    $0xc,%ebx
  801b99:	8b 75 d8             	mov    -0x28(%ebp),%esi
  801b9c:	8d 4c 30 03          	lea    0x3(%eax,%esi,1),%ecx
  801ba0:	c1 e9 0c             	shr    $0xc,%ecx
  801ba3:	39 cb                	cmp    %ecx,%ebx
  801ba5:	75 1e                	jne    801bc5 <malloc+0x72>
		/*
		 * we're in the middle of a partially
		 * allocated page - can we add this chunk?
		 * the +4 below is for the ref count.
		 */
		ref = (uint32_t*) (ROUNDUP(mptr, PGSIZE) - 4);
  801ba7:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
  801bad:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
		if ((uintptr_t) mptr / PGSIZE == (uintptr_t) (mptr + n - 1 + 4) / PGSIZE) {
			(*ref)++;
  801bb3:	83 42 fc 01          	addl   $0x1,-0x4(%edx)
			v = mptr;
			mptr += n;
  801bb7:	8d 14 30             	lea    (%eax,%esi,1),%edx
  801bba:	89 15 80 74 80 00    	mov    %edx,0x807480
			return v;
  801bc0:	e9 5d 01 00 00       	jmp    801d22 <malloc+0x1cf>
		}
		/*
		 * stop working on this page and move on.
		 */
		free(mptr);	/* drop reference to this page */
  801bc5:	89 04 24             	mov    %eax,(%esp)
  801bc8:	e8 b3 fe ff ff       	call   801a80 <free>
		mptr = ROUNDDOWN(mptr + PGSIZE, PGSIZE);
  801bcd:	a1 80 74 80 00       	mov    0x807480,%eax
  801bd2:	05 00 10 00 00       	add    $0x1000,%eax
  801bd7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bdc:	a3 80 74 80 00       	mov    %eax,0x807480
  801be1:	8b 3d 80 74 80 00    	mov    0x807480,%edi
  801be7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
			return 0;
	return 1;
}

void*
malloc(size_t n)
  801bee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801bf1:	83 c0 04             	add    $0x4,%eax
  801bf4:	89 45 dc             	mov    %eax,-0x24(%ebp)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
		if (va >= (uintptr_t) mend
		    || ((vpd[PDX(va)] & PTE_P) && (vpt[VPN(va)] & PTE_P)))
  801bf7:	bb 00 d0 7b ef       	mov    $0xef7bd000,%ebx
  801bfc:	be 00 00 40 ef       	mov    $0xef400000,%esi
			return 0;
	return 1;
}

void*
malloc(size_t n)
  801c01:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801c04:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  801c07:	8d 0c 0f             	lea    (%edi,%ecx,1),%ecx
  801c0a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  801c0d:	39 cf                	cmp    %ecx,%edi
  801c0f:	0f 83 d7 00 00 00    	jae    801cec <malloc+0x199>
		if (va >= (uintptr_t) mend
  801c15:	89 f8                	mov    %edi,%eax
  801c17:	81 ff ff ff ff 0f    	cmp    $0xfffffff,%edi
  801c1d:	76 09                	jbe    801c28 <malloc+0xd5>
  801c1f:	eb 38                	jmp    801c59 <malloc+0x106>
  801c21:	3d ff ff ff 0f       	cmp    $0xfffffff,%eax
  801c26:	77 31                	ja     801c59 <malloc+0x106>
		    || ((vpd[PDX(va)] & PTE_P) && (vpt[VPN(va)] & PTE_P)))
  801c28:	89 c2                	mov    %eax,%edx
  801c2a:	c1 ea 16             	shr    $0x16,%edx
  801c2d:	8b 14 93             	mov    (%ebx,%edx,4),%edx
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
		if (va >= (uintptr_t) mend
  801c30:	f6 c2 01             	test   $0x1,%dl
  801c33:	74 0d                	je     801c42 <malloc+0xef>
		    || ((vpd[PDX(va)] & PTE_P) && (vpt[VPN(va)] & PTE_P)))
  801c35:	89 c2                	mov    %eax,%edx
  801c37:	c1 ea 0c             	shr    $0xc,%edx
  801c3a:	8b 14 96             	mov    (%esi,%edx,4),%edx
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
		if (va >= (uintptr_t) mend
  801c3d:	f6 c2 01             	test   $0x1,%dl
  801c40:	75 17                	jne    801c59 <malloc+0x106>
static int
isfree(void *v, size_t n)
{
	uintptr_t va, end_va = (uintptr_t) v + n;

	for (va = (uintptr_t) v; va < end_va; va += PGSIZE)
  801c42:	05 00 10 00 00       	add    $0x1000,%eax
  801c47:	39 c8                	cmp    %ecx,%eax
  801c49:	72 d6                	jb     801c21 <malloc+0xce>
  801c4b:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  801c4e:	89 35 80 74 80 00    	mov    %esi,0x807480
  801c54:	e9 9b 00 00 00       	jmp    801cf4 <malloc+0x1a1>
  801c59:	81 c7 00 10 00 00    	add    $0x1000,%edi
  801c5f:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	nwrap = 0;
	while (1) {
		if (isfree(mptr, n + 4))
			break;
		mptr += PGSIZE;
		if (mptr == mend) {
  801c65:	81 ff 00 00 00 10    	cmp    $0x10000000,%edi
  801c6b:	75 9d                	jne    801c0a <malloc+0xb7>
			mptr = mbegin;
			if (++nwrap == 2)
  801c6d:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  801c71:	83 7d e0 02          	cmpl   $0x2,-0x20(%ebp)
  801c75:	74 07                	je     801c7e <malloc+0x12b>
  801c77:	bf 00 00 00 08       	mov    $0x8000000,%edi
  801c7c:	eb 83                	jmp    801c01 <malloc+0xae>
  801c7e:	c7 05 80 74 80 00 00 	movl   $0x8000000,0x807480
  801c85:	00 00 08 
  801c88:	b8 00 00 00 00       	mov    $0x0,%eax
  801c8d:	e9 90 00 00 00       	jmp    801d22 <malloc+0x1cf>

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
  801c92:	8d b3 00 10 00 00    	lea    0x1000(%ebx),%esi
  801c98:	39 fe                	cmp    %edi,%esi
  801c9a:	19 c0                	sbb    %eax,%eax
  801c9c:	25 00 04 00 00       	and    $0x400,%eax
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
  801ca1:	83 c8 07             	or     $0x7,%eax
  801ca4:	89 44 24 08          	mov    %eax,0x8(%esp)
  801ca8:	03 15 80 74 80 00    	add    0x807480,%edx
  801cae:	89 54 24 04          	mov    %edx,0x4(%esp)
  801cb2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cb9:	e8 58 ed ff ff       	call   800a16 <sys_page_alloc>
  801cbe:	85 c0                	test   %eax,%eax
  801cc0:	78 04                	js     801cc6 <malloc+0x173>
  801cc2:	89 f3                	mov    %esi,%ebx
  801cc4:	eb 36                	jmp    801cfc <malloc+0x1a9>
			for (; i >= 0; i -= PGSIZE)
  801cc6:	85 db                	test   %ebx,%ebx
  801cc8:	78 53                	js     801d1d <malloc+0x1ca>
				sys_page_unmap(0, mptr + i);
  801cca:	89 d8                	mov    %ebx,%eax
  801ccc:	03 05 80 74 80 00    	add    0x807480,%eax
  801cd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801cdd:	e8 78 ec ff ff       	call   80095a <sys_page_unmap>
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
		cont = (i + PGSIZE < n + 4) ? PTE_CONTINUED : 0;
		if (sys_page_alloc(0, mptr + i, PTE_P|PTE_U|PTE_W|cont) < 0){
			for (; i >= 0; i -= PGSIZE)
  801ce2:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  801ce8:	79 e0                	jns    801cca <malloc+0x177>
  801cea:	eb 31                	jmp    801d1d <malloc+0x1ca>
  801cec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801cef:	a3 80 74 80 00       	mov    %eax,0x807480
  801cf4:	bb 00 00 00 00       	mov    $0x0,%ebx
  801cf9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801cfc:	89 da                	mov    %ebx,%edx
	}

	/*
	 * allocate at mptr - the +4 makes sure we allocate a ref count.
	 */
	for (i = 0; i < n + 4; i += PGSIZE){
  801cfe:	39 fb                	cmp    %edi,%ebx
  801d00:	72 90                	jb     801c92 <malloc+0x13f>
				sys_page_unmap(0, mptr + i);
			return 0;	/* out of physical memory */
		}
	}

	ref = (uint32_t*) (mptr + i - 4);
  801d02:	a1 80 74 80 00       	mov    0x807480,%eax
	*ref = 2;	/* reference for mptr, reference for returned block */
  801d07:	c7 44 18 fc 02 00 00 	movl   $0x2,-0x4(%eax,%ebx,1)
  801d0e:	00 
	v = mptr;
	mptr += n;
  801d0f:	8b 4d d8             	mov    -0x28(%ebp),%ecx
  801d12:	8d 14 08             	lea    (%eax,%ecx,1),%edx
  801d15:	89 15 80 74 80 00    	mov    %edx,0x807480
	return v;
  801d1b:	eb 05                	jmp    801d22 <malloc+0x1cf>
  801d1d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d22:	83 c4 3c             	add    $0x3c,%esp
  801d25:	5b                   	pop    %ebx
  801d26:	5e                   	pop    %esi
  801d27:	5f                   	pop    %edi
  801d28:	5d                   	pop    %ebp
  801d29:	c3                   	ret    
  801d2a:	00 00                	add    %al,(%eax)
  801d2c:	00 00                	add    %al,(%eax)
	...

00801d30 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	83 ec 18             	sub    $0x18,%esp
  801d36:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801d39:	89 75 fc             	mov    %esi,-0x4(%ebp)
  801d3c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d42:	89 04 24             	mov    %eax,(%esp)
  801d45:	e8 06 ee ff ff       	call   800b50 <fd2data>
  801d4a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  801d4c:	c7 44 24 04 53 2f 80 	movl   $0x802f53,0x4(%esp)
  801d53:	00 
  801d54:	89 34 24             	mov    %esi,(%esp)
  801d57:	e8 5e e5 ff ff       	call   8002ba <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d5c:	8b 43 04             	mov    0x4(%ebx),%eax
  801d5f:	2b 03                	sub    (%ebx),%eax
  801d61:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801d67:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  801d6e:	00 00 00 
	stat->st_dev = &devpipe;
  801d71:	c7 86 88 00 00 00 3c 	movl   $0x80703c,0x88(%esi)
  801d78:	70 80 00 
	return 0;
}
  801d7b:	b8 00 00 00 00       	mov    $0x0,%eax
  801d80:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  801d83:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801d86:	89 ec                	mov    %ebp,%esp
  801d88:	5d                   	pop    %ebp
  801d89:	c3                   	ret    

00801d8a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d8a:	55                   	push   %ebp
  801d8b:	89 e5                	mov    %esp,%ebp
  801d8d:	53                   	push   %ebx
  801d8e:	83 ec 14             	sub    $0x14,%esp
  801d91:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d94:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d98:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d9f:	e8 b6 eb ff ff       	call   80095a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801da4:	89 1c 24             	mov    %ebx,(%esp)
  801da7:	e8 a4 ed ff ff       	call   800b50 <fd2data>
  801dac:	89 44 24 04          	mov    %eax,0x4(%esp)
  801db0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801db7:	e8 9e eb ff ff       	call   80095a <sys_page_unmap>
}
  801dbc:	83 c4 14             	add    $0x14,%esp
  801dbf:	5b                   	pop    %ebx
  801dc0:	5d                   	pop    %ebp
  801dc1:	c3                   	ret    

00801dc2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	57                   	push   %edi
  801dc6:	56                   	push   %esi
  801dc7:	53                   	push   %ebx
  801dc8:	83 ec 2c             	sub    $0x2c,%esp
  801dcb:	89 c7                	mov    %eax,%edi
  801dcd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801dd0:	a1 84 74 80 00       	mov    0x807484,%eax
  801dd5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dd8:	89 3c 24             	mov    %edi,(%esp)
  801ddb:	e8 f8 0c 00 00       	call   802ad8 <pageref>
  801de0:	89 c6                	mov    %eax,%esi
  801de2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801de5:	89 04 24             	mov    %eax,(%esp)
  801de8:	e8 eb 0c 00 00       	call   802ad8 <pageref>
  801ded:	39 c6                	cmp    %eax,%esi
  801def:	0f 94 c0             	sete   %al
  801df2:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  801df5:	8b 15 84 74 80 00    	mov    0x807484,%edx
  801dfb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801dfe:	39 cb                	cmp    %ecx,%ebx
  801e00:	75 08                	jne    801e0a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  801e02:	83 c4 2c             	add    $0x2c,%esp
  801e05:	5b                   	pop    %ebx
  801e06:	5e                   	pop    %esi
  801e07:	5f                   	pop    %edi
  801e08:	5d                   	pop    %ebp
  801e09:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  801e0a:	83 f8 01             	cmp    $0x1,%eax
  801e0d:	75 c1                	jne    801dd0 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  801e0f:	8b 52 58             	mov    0x58(%edx),%edx
  801e12:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e16:	89 54 24 08          	mov    %edx,0x8(%esp)
  801e1a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e1e:	c7 04 24 5a 2f 80 00 	movl   $0x802f5a,(%esp)
  801e25:	e8 57 05 00 00       	call   802381 <cprintf>
  801e2a:	eb a4                	jmp    801dd0 <_pipeisclosed+0xe>

00801e2c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	57                   	push   %edi
  801e30:	56                   	push   %esi
  801e31:	53                   	push   %ebx
  801e32:	83 ec 1c             	sub    $0x1c,%esp
  801e35:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801e38:	89 34 24             	mov    %esi,(%esp)
  801e3b:	e8 10 ed ff ff       	call   800b50 <fd2data>
  801e40:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e42:	bf 00 00 00 00       	mov    $0x0,%edi
  801e47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e4b:	75 54                	jne    801ea1 <devpipe_write+0x75>
  801e4d:	eb 60                	jmp    801eaf <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  801e4f:	89 da                	mov    %ebx,%edx
  801e51:	89 f0                	mov    %esi,%eax
  801e53:	e8 6a ff ff ff       	call   801dc2 <_pipeisclosed>
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	74 07                	je     801e63 <devpipe_write+0x37>
  801e5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e61:	eb 53                	jmp    801eb6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801e63:	90                   	nop
  801e64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801e68:	e8 08 ec ff ff       	call   800a75 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e6d:	8b 43 04             	mov    0x4(%ebx),%eax
  801e70:	8b 13                	mov    (%ebx),%edx
  801e72:	83 c2 20             	add    $0x20,%edx
  801e75:	39 d0                	cmp    %edx,%eax
  801e77:	73 d6                	jae    801e4f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e79:	89 c2                	mov    %eax,%edx
  801e7b:	c1 fa 1f             	sar    $0x1f,%edx
  801e7e:	c1 ea 1b             	shr    $0x1b,%edx
  801e81:	01 d0                	add    %edx,%eax
  801e83:	83 e0 1f             	and    $0x1f,%eax
  801e86:	29 d0                	sub    %edx,%eax
  801e88:	89 c2                	mov    %eax,%edx
  801e8a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801e8d:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  801e91:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  801e95:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801e99:	83 c7 01             	add    $0x1,%edi
  801e9c:	39 7d 10             	cmp    %edi,0x10(%ebp)
  801e9f:	76 13                	jbe    801eb4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801ea1:	8b 43 04             	mov    0x4(%ebx),%eax
  801ea4:	8b 13                	mov    (%ebx),%edx
  801ea6:	83 c2 20             	add    $0x20,%edx
  801ea9:	39 d0                	cmp    %edx,%eax
  801eab:	73 a2                	jae    801e4f <devpipe_write+0x23>
  801ead:	eb ca                	jmp    801e79 <devpipe_write+0x4d>
  801eaf:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  801eb4:	89 f8                	mov    %edi,%eax
}
  801eb6:	83 c4 1c             	add    $0x1c,%esp
  801eb9:	5b                   	pop    %ebx
  801eba:	5e                   	pop    %esi
  801ebb:	5f                   	pop    %edi
  801ebc:	5d                   	pop    %ebp
  801ebd:	c3                   	ret    

00801ebe <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 28             	sub    $0x28,%esp
  801ec4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ec7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801eca:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801ecd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801ed0:	89 3c 24             	mov    %edi,(%esp)
  801ed3:	e8 78 ec ff ff       	call   800b50 <fd2data>
  801ed8:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801eda:	be 00 00 00 00       	mov    $0x0,%esi
  801edf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ee3:	75 4c                	jne    801f31 <devpipe_read+0x73>
  801ee5:	eb 5b                	jmp    801f42 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801ee7:	89 f0                	mov    %esi,%eax
  801ee9:	eb 5e                	jmp    801f49 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801eeb:	89 da                	mov    %ebx,%edx
  801eed:	89 f8                	mov    %edi,%eax
  801eef:	90                   	nop
  801ef0:	e8 cd fe ff ff       	call   801dc2 <_pipeisclosed>
  801ef5:	85 c0                	test   %eax,%eax
  801ef7:	74 07                	je     801f00 <devpipe_read+0x42>
  801ef9:	b8 00 00 00 00       	mov    $0x0,%eax
  801efe:	eb 49                	jmp    801f49 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801f00:	e8 70 eb ff ff       	call   800a75 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801f05:	8b 03                	mov    (%ebx),%eax
  801f07:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f0a:	74 df                	je     801eeb <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f0c:	89 c2                	mov    %eax,%edx
  801f0e:	c1 fa 1f             	sar    $0x1f,%edx
  801f11:	c1 ea 1b             	shr    $0x1b,%edx
  801f14:	01 d0                	add    %edx,%eax
  801f16:	83 e0 1f             	and    $0x1f,%eax
  801f19:	29 d0                	sub    %edx,%eax
  801f1b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801f20:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f23:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801f26:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801f29:	83 c6 01             	add    $0x1,%esi
  801f2c:	39 75 10             	cmp    %esi,0x10(%ebp)
  801f2f:	76 16                	jbe    801f47 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  801f31:	8b 03                	mov    (%ebx),%eax
  801f33:	3b 43 04             	cmp    0x4(%ebx),%eax
  801f36:	75 d4                	jne    801f0c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801f38:	85 f6                	test   %esi,%esi
  801f3a:	75 ab                	jne    801ee7 <devpipe_read+0x29>
  801f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801f40:	eb a9                	jmp    801eeb <devpipe_read+0x2d>
  801f42:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801f47:	89 f0                	mov    %esi,%eax
}
  801f49:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801f4c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801f4f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801f52:	89 ec                	mov    %ebp,%esp
  801f54:	5d                   	pop    %ebp
  801f55:	c3                   	ret    

00801f56 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	89 04 24             	mov    %eax,(%esp)
  801f69:	e8 6f ec ff ff       	call   800bdd <fd_lookup>
  801f6e:	85 c0                	test   %eax,%eax
  801f70:	78 15                	js     801f87 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f75:	89 04 24             	mov    %eax,(%esp)
  801f78:	e8 d3 eb ff ff       	call   800b50 <fd2data>
	return _pipeisclosed(fd, p);
  801f7d:	89 c2                	mov    %eax,%edx
  801f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f82:	e8 3b fe ff ff       	call   801dc2 <_pipeisclosed>
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 48             	sub    $0x48,%esp
  801f8f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801f92:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801f95:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801f98:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801f9b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801f9e:	89 04 24             	mov    %eax,(%esp)
  801fa1:	e8 c5 eb ff ff       	call   800b6b <fd_alloc>
  801fa6:	89 c3                	mov    %eax,%ebx
  801fa8:	85 c0                	test   %eax,%eax
  801faa:	0f 88 42 01 00 00    	js     8020f2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fb0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801fb7:	00 
  801fb8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801fbf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801fc6:	e8 4b ea ff ff       	call   800a16 <sys_page_alloc>
  801fcb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801fcd:	85 c0                	test   %eax,%eax
  801fcf:	0f 88 1d 01 00 00    	js     8020f2 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801fd5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801fd8:	89 04 24             	mov    %eax,(%esp)
  801fdb:	e8 8b eb ff ff       	call   800b6b <fd_alloc>
  801fe0:	89 c3                	mov    %eax,%ebx
  801fe2:	85 c0                	test   %eax,%eax
  801fe4:	0f 88 f5 00 00 00    	js     8020df <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fea:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ff1:	00 
  801ff2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ff5:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ff9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802000:	e8 11 ea ff ff       	call   800a16 <sys_page_alloc>
  802005:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  802007:	85 c0                	test   %eax,%eax
  802009:	0f 88 d0 00 00 00    	js     8020df <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  80200f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802012:	89 04 24             	mov    %eax,(%esp)
  802015:	e8 36 eb ff ff       	call   800b50 <fd2data>
  80201a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80201c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  802023:	00 
  802024:	89 44 24 04          	mov    %eax,0x4(%esp)
  802028:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80202f:	e8 e2 e9 ff ff       	call   800a16 <sys_page_alloc>
  802034:	89 c3                	mov    %eax,%ebx
  802036:	85 c0                	test   %eax,%eax
  802038:	0f 88 8e 00 00 00    	js     8020cc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80203e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802041:	89 04 24             	mov    %eax,(%esp)
  802044:	e8 07 eb ff ff       	call   800b50 <fd2data>
  802049:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  802050:	00 
  802051:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802055:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80205c:	00 
  80205d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802061:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  802068:	e8 4b e9 ff ff       	call   8009b8 <sys_page_map>
  80206d:	89 c3                	mov    %eax,%ebx
  80206f:	85 c0                	test   %eax,%eax
  802071:	78 49                	js     8020bc <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  802073:	b8 3c 70 80 00       	mov    $0x80703c,%eax
  802078:	8b 08                	mov    (%eax),%ecx
  80207a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80207d:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  80207f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802082:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  802089:	8b 10                	mov    (%eax),%edx
  80208b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80208e:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802090:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802093:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  80209a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80209d:	89 04 24             	mov    %eax,(%esp)
  8020a0:	e8 9b ea ff ff       	call   800b40 <fd2num>
  8020a5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  8020a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020aa:	89 04 24             	mov    %eax,(%esp)
  8020ad:	e8 8e ea ff ff       	call   800b40 <fd2num>
  8020b2:	89 47 04             	mov    %eax,0x4(%edi)
  8020b5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  8020ba:	eb 36                	jmp    8020f2 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  8020bc:	89 74 24 04          	mov    %esi,0x4(%esp)
  8020c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020c7:	e8 8e e8 ff ff       	call   80095a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  8020cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8020cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020d3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020da:	e8 7b e8 ff ff       	call   80095a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  8020df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8020e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8020e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8020ed:	e8 68 e8 ff ff       	call   80095a <sys_page_unmap>
    err:
	return r;
}
  8020f2:	89 d8                	mov    %ebx,%eax
  8020f4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8020f7:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8020fa:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8020fd:	89 ec                	mov    %ebp,%esp
  8020ff:	5d                   	pop    %ebp
  802100:	c3                   	ret    
	...

00802110 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  802110:	55                   	push   %ebp
  802111:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  802113:	b8 00 00 00 00       	mov    $0x0,%eax
  802118:	5d                   	pop    %ebp
  802119:	c3                   	ret    

0080211a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80211a:	55                   	push   %ebp
  80211b:	89 e5                	mov    %esp,%ebp
  80211d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  802120:	c7 44 24 04 72 2f 80 	movl   $0x802f72,0x4(%esp)
  802127:	00 
  802128:	8b 45 0c             	mov    0xc(%ebp),%eax
  80212b:	89 04 24             	mov    %eax,(%esp)
  80212e:	e8 87 e1 ff ff       	call   8002ba <strcpy>
	return 0;
}
  802133:	b8 00 00 00 00       	mov    $0x0,%eax
  802138:	c9                   	leave  
  802139:	c3                   	ret    

0080213a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80213a:	55                   	push   %ebp
  80213b:	89 e5                	mov    %esp,%ebp
  80213d:	57                   	push   %edi
  80213e:	56                   	push   %esi
  80213f:	53                   	push   %ebx
  802140:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  802146:	b8 00 00 00 00       	mov    $0x0,%eax
  80214b:	be 00 00 00 00       	mov    $0x0,%esi
  802150:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802154:	74 3f                	je     802195 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  802156:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  80215c:	8b 55 10             	mov    0x10(%ebp),%edx
  80215f:	29 c2                	sub    %eax,%edx
  802161:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  802163:	83 fa 7f             	cmp    $0x7f,%edx
  802166:	76 05                	jbe    80216d <devcons_write+0x33>
  802168:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  80216d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802171:	03 45 0c             	add    0xc(%ebp),%eax
  802174:	89 44 24 04          	mov    %eax,0x4(%esp)
  802178:	89 3c 24             	mov    %edi,(%esp)
  80217b:	e8 f5 e2 ff ff       	call   800475 <memmove>
		sys_cputs(buf, m);
  802180:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802184:	89 3c 24             	mov    %edi,(%esp)
  802187:	e8 24 e5 ff ff       	call   8006b0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  80218c:	01 de                	add    %ebx,%esi
  80218e:	89 f0                	mov    %esi,%eax
  802190:	3b 75 10             	cmp    0x10(%ebp),%esi
  802193:	72 c7                	jb     80215c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  802195:	89 f0                	mov    %esi,%eax
  802197:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  80219d:	5b                   	pop    %ebx
  80219e:	5e                   	pop    %esi
  80219f:	5f                   	pop    %edi
  8021a0:	5d                   	pop    %ebp
  8021a1:	c3                   	ret    

008021a2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  8021a2:	55                   	push   %ebp
  8021a3:	89 e5                	mov    %esp,%ebp
  8021a5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  8021a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ab:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  8021ae:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  8021b5:	00 
  8021b6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021b9:	89 04 24             	mov    %eax,(%esp)
  8021bc:	e8 ef e4 ff ff       	call   8006b0 <sys_cputs>
}
  8021c1:	c9                   	leave  
  8021c2:	c3                   	ret    

008021c3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  8021c3:	55                   	push   %ebp
  8021c4:	89 e5                	mov    %esp,%ebp
  8021c6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  8021c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021cd:	75 07                	jne    8021d6 <devcons_read+0x13>
  8021cf:	eb 28                	jmp    8021f9 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  8021d1:	e8 9f e8 ff ff       	call   800a75 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  8021d6:	66 90                	xchg   %ax,%ax
  8021d8:	e8 9f e4 ff ff       	call   80067c <sys_cgetc>
  8021dd:	85 c0                	test   %eax,%eax
  8021df:	90                   	nop
  8021e0:	74 ef                	je     8021d1 <devcons_read+0xe>
  8021e2:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  8021e4:	85 c0                	test   %eax,%eax
  8021e6:	78 16                	js     8021fe <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  8021e8:	83 f8 04             	cmp    $0x4,%eax
  8021eb:	74 0c                	je     8021f9 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  8021ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021f0:	88 10                	mov    %dl,(%eax)
  8021f2:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  8021f7:	eb 05                	jmp    8021fe <devcons_read+0x3b>
  8021f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    

00802200 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  802200:	55                   	push   %ebp
  802201:	89 e5                	mov    %esp,%ebp
  802203:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  802206:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802209:	89 04 24             	mov    %eax,(%esp)
  80220c:	e8 5a e9 ff ff       	call   800b6b <fd_alloc>
  802211:	85 c0                	test   %eax,%eax
  802213:	78 3f                	js     802254 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802215:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  80221c:	00 
  80221d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802220:	89 44 24 04          	mov    %eax,0x4(%esp)
  802224:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80222b:	e8 e6 e7 ff ff       	call   800a16 <sys_page_alloc>
  802230:	85 c0                	test   %eax,%eax
  802232:	78 20                	js     802254 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  802234:	8b 15 58 70 80 00    	mov    0x807058,%edx
  80223a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80223f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802242:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802249:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80224c:	89 04 24             	mov    %eax,(%esp)
  80224f:	e8 ec e8 ff ff       	call   800b40 <fd2num>
}
  802254:	c9                   	leave  
  802255:	c3                   	ret    

00802256 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  802256:	55                   	push   %ebp
  802257:	89 e5                	mov    %esp,%ebp
  802259:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80225c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80225f:	89 44 24 04          	mov    %eax,0x4(%esp)
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	89 04 24             	mov    %eax,(%esp)
  802269:	e8 6f e9 ff ff       	call   800bdd <fd_lookup>
  80226e:	85 c0                	test   %eax,%eax
  802270:	78 11                	js     802283 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  802272:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802275:	8b 00                	mov    (%eax),%eax
  802277:	3b 05 58 70 80 00    	cmp    0x807058,%eax
  80227d:	0f 94 c0             	sete   %al
  802280:	0f b6 c0             	movzbl %al,%eax
}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  80228b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  802292:	00 
  802293:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802296:	89 44 24 04          	mov    %eax,0x4(%esp)
  80229a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8022a1:	e8 98 eb ff ff       	call   800e3e <read>
	if (r < 0)
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	78 0f                	js     8022b9 <getchar+0x34>
		return r;
	if (r < 1)
  8022aa:	85 c0                	test   %eax,%eax
  8022ac:	7f 07                	jg     8022b5 <getchar+0x30>
  8022ae:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8022b3:	eb 04                	jmp    8022b9 <getchar+0x34>
		return -E_EOF;
	return c;
  8022b5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8022b9:	c9                   	leave  
  8022ba:	c3                   	ret    
	...

008022bc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8022bc:	55                   	push   %ebp
  8022bd:	89 e5                	mov    %esp,%ebp
  8022bf:	53                   	push   %ebx
  8022c0:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  8022c3:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  8022c6:	a1 88 74 80 00       	mov    0x807488,%eax
  8022cb:	85 c0                	test   %eax,%eax
  8022cd:	74 10                	je     8022df <_panic+0x23>
		cprintf("%s: ", argv0);
  8022cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022d3:	c7 04 24 7e 2f 80 00 	movl   $0x802f7e,(%esp)
  8022da:	e8 a2 00 00 00       	call   802381 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8022df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022e2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8022e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8022ed:	a1 00 70 80 00       	mov    0x807000,%eax
  8022f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8022f6:	c7 04 24 83 2f 80 00 	movl   $0x802f83,(%esp)
  8022fd:	e8 7f 00 00 00       	call   802381 <cprintf>
	vcprintf(fmt, ap);
  802302:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802306:	8b 45 10             	mov    0x10(%ebp),%eax
  802309:	89 04 24             	mov    %eax,(%esp)
  80230c:	e8 0f 00 00 00       	call   802320 <vcprintf>
	cprintf("\n");
  802311:	c7 04 24 6b 2f 80 00 	movl   $0x802f6b,(%esp)
  802318:	e8 64 00 00 00       	call   802381 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80231d:	cc                   	int3   
  80231e:	eb fd                	jmp    80231d <_panic+0x61>

00802320 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  802320:	55                   	push   %ebp
  802321:	89 e5                	mov    %esp,%ebp
  802323:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  802329:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  802330:	00 00 00 
	b.cnt = 0;
  802333:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80233a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80233d:	8b 45 0c             	mov    0xc(%ebp),%eax
  802340:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802344:	8b 45 08             	mov    0x8(%ebp),%eax
  802347:	89 44 24 08          	mov    %eax,0x8(%esp)
  80234b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  802351:	89 44 24 04          	mov    %eax,0x4(%esp)
  802355:	c7 04 24 9b 23 80 00 	movl   $0x80239b,(%esp)
  80235c:	e8 cc 01 00 00       	call   80252d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  802361:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  802367:	89 44 24 04          	mov    %eax,0x4(%esp)
  80236b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  802371:	89 04 24             	mov    %eax,(%esp)
  802374:	e8 37 e3 ff ff       	call   8006b0 <sys_cputs>

	return b.cnt;
}
  802379:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  802387:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  80238a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	89 04 24             	mov    %eax,(%esp)
  802394:	e8 87 ff ff ff       	call   802320 <vcprintf>
	va_end(ap);

	return cnt;
}
  802399:	c9                   	leave  
  80239a:	c3                   	ret    

0080239b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80239b:	55                   	push   %ebp
  80239c:	89 e5                	mov    %esp,%ebp
  80239e:	53                   	push   %ebx
  80239f:	83 ec 14             	sub    $0x14,%esp
  8023a2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8023a5:	8b 03                	mov    (%ebx),%eax
  8023a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8023aa:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  8023ae:	83 c0 01             	add    $0x1,%eax
  8023b1:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  8023b3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8023b8:	75 19                	jne    8023d3 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  8023ba:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  8023c1:	00 
  8023c2:	8d 43 08             	lea    0x8(%ebx),%eax
  8023c5:	89 04 24             	mov    %eax,(%esp)
  8023c8:	e8 e3 e2 ff ff       	call   8006b0 <sys_cputs>
		b->idx = 0;
  8023cd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  8023d3:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  8023d7:	83 c4 14             	add    $0x14,%esp
  8023da:	5b                   	pop    %ebx
  8023db:	5d                   	pop    %ebp
  8023dc:	c3                   	ret    
  8023dd:	00 00                	add    %al,(%eax)
	...

008023e0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
  8023e3:	57                   	push   %edi
  8023e4:	56                   	push   %esi
  8023e5:	53                   	push   %ebx
  8023e6:	83 ec 4c             	sub    $0x4c,%esp
  8023e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023ec:	89 d6                	mov    %edx,%esi
  8023ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8023f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8023f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023f7:	89 55 e0             	mov    %edx,-0x20(%ebp)
  8023fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8023fd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802400:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  802403:	89 45 dc             	mov    %eax,-0x24(%ebp)
  802406:	b9 00 00 00 00       	mov    $0x0,%ecx
  80240b:	39 d1                	cmp    %edx,%ecx
  80240d:	72 15                	jb     802424 <printnum+0x44>
  80240f:	77 07                	ja     802418 <printnum+0x38>
  802411:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802414:	39 d0                	cmp    %edx,%eax
  802416:	76 0c                	jbe    802424 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  802418:	83 eb 01             	sub    $0x1,%ebx
  80241b:	85 db                	test   %ebx,%ebx
  80241d:	8d 76 00             	lea    0x0(%esi),%esi
  802420:	7f 61                	jg     802483 <printnum+0xa3>
  802422:	eb 70                	jmp    802494 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  802424:	89 7c 24 10          	mov    %edi,0x10(%esp)
  802428:	83 eb 01             	sub    $0x1,%ebx
  80242b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  80242f:	89 44 24 08          	mov    %eax,0x8(%esp)
  802433:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  802437:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  80243b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80243e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  802441:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  802444:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802448:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  80244f:	00 
  802450:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802453:	89 04 24             	mov    %eax,(%esp)
  802456:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802459:	89 54 24 04          	mov    %edx,0x4(%esp)
  80245d:	e8 be 06 00 00       	call   802b20 <__udivdi3>
  802462:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  802465:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802468:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80246c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  802470:	89 04 24             	mov    %eax,(%esp)
  802473:	89 54 24 04          	mov    %edx,0x4(%esp)
  802477:	89 f2                	mov    %esi,%edx
  802479:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80247c:	e8 5f ff ff ff       	call   8023e0 <printnum>
  802481:	eb 11                	jmp    802494 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  802483:	89 74 24 04          	mov    %esi,0x4(%esp)
  802487:	89 3c 24             	mov    %edi,(%esp)
  80248a:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80248d:	83 eb 01             	sub    $0x1,%ebx
  802490:	85 db                	test   %ebx,%ebx
  802492:	7f ef                	jg     802483 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  802494:	89 74 24 04          	mov    %esi,0x4(%esp)
  802498:	8b 74 24 04          	mov    0x4(%esp),%esi
  80249c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80249f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024a3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8024aa:	00 
  8024ab:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8024ae:	89 14 24             	mov    %edx,(%esp)
  8024b1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8024b4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024b8:	e8 93 07 00 00       	call   802c50 <__umoddi3>
  8024bd:	89 74 24 04          	mov    %esi,0x4(%esp)
  8024c1:	0f be 80 9f 2f 80 00 	movsbl 0x802f9f(%eax),%eax
  8024c8:	89 04 24             	mov    %eax,(%esp)
  8024cb:	ff 55 e4             	call   *-0x1c(%ebp)
}
  8024ce:	83 c4 4c             	add    $0x4c,%esp
  8024d1:	5b                   	pop    %ebx
  8024d2:	5e                   	pop    %esi
  8024d3:	5f                   	pop    %edi
  8024d4:	5d                   	pop    %ebp
  8024d5:	c3                   	ret    

008024d6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8024d6:	55                   	push   %ebp
  8024d7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8024d9:	83 fa 01             	cmp    $0x1,%edx
  8024dc:	7e 0e                	jle    8024ec <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  8024de:	8b 10                	mov    (%eax),%edx
  8024e0:	8d 4a 08             	lea    0x8(%edx),%ecx
  8024e3:	89 08                	mov    %ecx,(%eax)
  8024e5:	8b 02                	mov    (%edx),%eax
  8024e7:	8b 52 04             	mov    0x4(%edx),%edx
  8024ea:	eb 22                	jmp    80250e <getuint+0x38>
	else if (lflag)
  8024ec:	85 d2                	test   %edx,%edx
  8024ee:	74 10                	je     802500 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  8024f0:	8b 10                	mov    (%eax),%edx
  8024f2:	8d 4a 04             	lea    0x4(%edx),%ecx
  8024f5:	89 08                	mov    %ecx,(%eax)
  8024f7:	8b 02                	mov    (%edx),%eax
  8024f9:	ba 00 00 00 00       	mov    $0x0,%edx
  8024fe:	eb 0e                	jmp    80250e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  802500:	8b 10                	mov    (%eax),%edx
  802502:	8d 4a 04             	lea    0x4(%edx),%ecx
  802505:	89 08                	mov    %ecx,(%eax)
  802507:	8b 02                	mov    (%edx),%eax
  802509:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80250e:	5d                   	pop    %ebp
  80250f:	c3                   	ret    

00802510 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  802516:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80251a:	8b 10                	mov    (%eax),%edx
  80251c:	3b 50 04             	cmp    0x4(%eax),%edx
  80251f:	73 0a                	jae    80252b <sprintputch+0x1b>
		*b->buf++ = ch;
  802521:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802524:	88 0a                	mov    %cl,(%edx)
  802526:	83 c2 01             	add    $0x1,%edx
  802529:	89 10                	mov    %edx,(%eax)
}
  80252b:	5d                   	pop    %ebp
  80252c:	c3                   	ret    

0080252d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80252d:	55                   	push   %ebp
  80252e:	89 e5                	mov    %esp,%ebp
  802530:	57                   	push   %edi
  802531:	56                   	push   %esi
  802532:	53                   	push   %ebx
  802533:	83 ec 5c             	sub    $0x5c,%esp
  802536:	8b 7d 08             	mov    0x8(%ebp),%edi
  802539:	8b 75 0c             	mov    0xc(%ebp),%esi
  80253c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80253f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  802546:	eb 11                	jmp    802559 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  802548:	85 c0                	test   %eax,%eax
  80254a:	0f 84 09 04 00 00    	je     802959 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  802550:	89 74 24 04          	mov    %esi,0x4(%esp)
  802554:	89 04 24             	mov    %eax,(%esp)
  802557:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802559:	0f b6 03             	movzbl (%ebx),%eax
  80255c:	83 c3 01             	add    $0x1,%ebx
  80255f:	83 f8 25             	cmp    $0x25,%eax
  802562:	75 e4                	jne    802548 <vprintfmt+0x1b>
  802564:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  802568:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80256f:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  802576:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80257d:	b9 00 00 00 00       	mov    $0x0,%ecx
  802582:	eb 06                	jmp    80258a <vprintfmt+0x5d>
  802584:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  802588:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80258a:	0f b6 13             	movzbl (%ebx),%edx
  80258d:	0f b6 c2             	movzbl %dl,%eax
  802590:	89 45 e0             	mov    %eax,-0x20(%ebp)
  802593:	8d 43 01             	lea    0x1(%ebx),%eax
  802596:	83 ea 23             	sub    $0x23,%edx
  802599:	80 fa 55             	cmp    $0x55,%dl
  80259c:	0f 87 9a 03 00 00    	ja     80293c <vprintfmt+0x40f>
  8025a2:	0f b6 d2             	movzbl %dl,%edx
  8025a5:	ff 24 95 e0 30 80 00 	jmp    *0x8030e0(,%edx,4)
  8025ac:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8025b0:	eb d6                	jmp    802588 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8025b2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8025b5:	83 ea 30             	sub    $0x30,%edx
  8025b8:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  8025bb:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8025be:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8025c1:	83 fb 09             	cmp    $0x9,%ebx
  8025c4:	77 4c                	ja     802612 <vprintfmt+0xe5>
  8025c6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8025c9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8025cc:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8025cf:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  8025d2:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  8025d6:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8025d9:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8025dc:	83 fb 09             	cmp    $0x9,%ebx
  8025df:	76 eb                	jbe    8025cc <vprintfmt+0x9f>
  8025e1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8025e4:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8025e7:	eb 29                	jmp    802612 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8025e9:	8b 55 14             	mov    0x14(%ebp),%edx
  8025ec:	8d 5a 04             	lea    0x4(%edx),%ebx
  8025ef:	89 5d 14             	mov    %ebx,0x14(%ebp)
  8025f2:	8b 12                	mov    (%edx),%edx
  8025f4:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  8025f7:	eb 19                	jmp    802612 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  8025f9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8025fc:	c1 fa 1f             	sar    $0x1f,%edx
  8025ff:	f7 d2                	not    %edx
  802601:	21 55 e4             	and    %edx,-0x1c(%ebp)
  802604:	eb 82                	jmp    802588 <vprintfmt+0x5b>
  802606:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80260d:	e9 76 ff ff ff       	jmp    802588 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  802612:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802616:	0f 89 6c ff ff ff    	jns    802588 <vprintfmt+0x5b>
  80261c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80261f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802622:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802625:	89 55 cc             	mov    %edx,-0x34(%ebp)
  802628:	e9 5b ff ff ff       	jmp    802588 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80262d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  802630:	e9 53 ff ff ff       	jmp    802588 <vprintfmt+0x5b>
  802635:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  802638:	8b 45 14             	mov    0x14(%ebp),%eax
  80263b:	8d 50 04             	lea    0x4(%eax),%edx
  80263e:	89 55 14             	mov    %edx,0x14(%ebp)
  802641:	89 74 24 04          	mov    %esi,0x4(%esp)
  802645:	8b 00                	mov    (%eax),%eax
  802647:	89 04 24             	mov    %eax,(%esp)
  80264a:	ff d7                	call   *%edi
  80264c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80264f:	e9 05 ff ff ff       	jmp    802559 <vprintfmt+0x2c>
  802654:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  802657:	8b 45 14             	mov    0x14(%ebp),%eax
  80265a:	8d 50 04             	lea    0x4(%eax),%edx
  80265d:	89 55 14             	mov    %edx,0x14(%ebp)
  802660:	8b 00                	mov    (%eax),%eax
  802662:	89 c2                	mov    %eax,%edx
  802664:	c1 fa 1f             	sar    $0x1f,%edx
  802667:	31 d0                	xor    %edx,%eax
  802669:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80266b:	83 f8 0f             	cmp    $0xf,%eax
  80266e:	7f 0b                	jg     80267b <vprintfmt+0x14e>
  802670:	8b 14 85 40 32 80 00 	mov    0x803240(,%eax,4),%edx
  802677:	85 d2                	test   %edx,%edx
  802679:	75 20                	jne    80269b <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  80267b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80267f:	c7 44 24 08 b0 2f 80 	movl   $0x802fb0,0x8(%esp)
  802686:	00 
  802687:	89 74 24 04          	mov    %esi,0x4(%esp)
  80268b:	89 3c 24             	mov    %edi,(%esp)
  80268e:	e8 4e 03 00 00       	call   8029e1 <printfmt>
  802693:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  802696:	e9 be fe ff ff       	jmp    802559 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80269b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80269f:	c7 44 24 08 d9 2e 80 	movl   $0x802ed9,0x8(%esp)
  8026a6:	00 
  8026a7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8026ab:	89 3c 24             	mov    %edi,(%esp)
  8026ae:	e8 2e 03 00 00       	call   8029e1 <printfmt>
  8026b3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8026b6:	e9 9e fe ff ff       	jmp    802559 <vprintfmt+0x2c>
  8026bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8026be:	89 c3                	mov    %eax,%ebx
  8026c0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8026c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8026c6:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8026c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8026cc:	8d 50 04             	lea    0x4(%eax),%edx
  8026cf:	89 55 14             	mov    %edx,0x14(%ebp)
  8026d2:	8b 00                	mov    (%eax),%eax
  8026d4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  8026d7:	85 c0                	test   %eax,%eax
  8026d9:	75 07                	jne    8026e2 <vprintfmt+0x1b5>
  8026db:	c7 45 c4 b9 2f 80 00 	movl   $0x802fb9,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  8026e2:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  8026e6:	7e 06                	jle    8026ee <vprintfmt+0x1c1>
  8026e8:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  8026ec:	75 13                	jne    802701 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8026ee:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8026f1:	0f be 02             	movsbl (%edx),%eax
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	0f 85 99 00 00 00    	jne    802795 <vprintfmt+0x268>
  8026fc:	e9 86 00 00 00       	jmp    802787 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802701:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802705:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  802708:	89 0c 24             	mov    %ecx,(%esp)
  80270b:	e8 7b db ff ff       	call   80028b <strnlen>
  802710:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802713:	29 c2                	sub    %eax,%edx
  802715:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802718:	85 d2                	test   %edx,%edx
  80271a:	7e d2                	jle    8026ee <vprintfmt+0x1c1>
					putch(padc, putdat);
  80271c:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  802720:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  802723:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  802726:	89 d3                	mov    %edx,%ebx
  802728:	89 74 24 04          	mov    %esi,0x4(%esp)
  80272c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80272f:	89 04 24             	mov    %eax,(%esp)
  802732:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802734:	83 eb 01             	sub    $0x1,%ebx
  802737:	85 db                	test   %ebx,%ebx
  802739:	7f ed                	jg     802728 <vprintfmt+0x1fb>
  80273b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80273e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802745:	eb a7                	jmp    8026ee <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802747:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80274b:	74 18                	je     802765 <vprintfmt+0x238>
  80274d:	8d 50 e0             	lea    -0x20(%eax),%edx
  802750:	83 fa 5e             	cmp    $0x5e,%edx
  802753:	76 10                	jbe    802765 <vprintfmt+0x238>
					putch('?', putdat);
  802755:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802759:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  802760:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802763:	eb 0a                	jmp    80276f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  802765:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802769:	89 04 24             	mov    %eax,(%esp)
  80276c:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80276f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  802773:	0f be 03             	movsbl (%ebx),%eax
  802776:	85 c0                	test   %eax,%eax
  802778:	74 05                	je     80277f <vprintfmt+0x252>
  80277a:	83 c3 01             	add    $0x1,%ebx
  80277d:	eb 29                	jmp    8027a8 <vprintfmt+0x27b>
  80277f:	89 fe                	mov    %edi,%esi
  802781:	8b 7d dc             	mov    -0x24(%ebp),%edi
  802784:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  802787:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80278b:	7f 2e                	jg     8027bb <vprintfmt+0x28e>
  80278d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  802790:	e9 c4 fd ff ff       	jmp    802559 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  802795:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802798:	83 c2 01             	add    $0x1,%edx
  80279b:	89 7d dc             	mov    %edi,-0x24(%ebp)
  80279e:	89 f7                	mov    %esi,%edi
  8027a0:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8027a3:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  8027a6:	89 d3                	mov    %edx,%ebx
  8027a8:	85 f6                	test   %esi,%esi
  8027aa:	78 9b                	js     802747 <vprintfmt+0x21a>
  8027ac:	83 ee 01             	sub    $0x1,%esi
  8027af:	79 96                	jns    802747 <vprintfmt+0x21a>
  8027b1:	89 fe                	mov    %edi,%esi
  8027b3:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8027b6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8027b9:	eb cc                	jmp    802787 <vprintfmt+0x25a>
  8027bb:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8027be:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8027c1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8027c5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8027cc:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8027ce:	83 eb 01             	sub    $0x1,%ebx
  8027d1:	85 db                	test   %ebx,%ebx
  8027d3:	7f ec                	jg     8027c1 <vprintfmt+0x294>
  8027d5:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  8027d8:	e9 7c fd ff ff       	jmp    802559 <vprintfmt+0x2c>
  8027dd:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  8027e0:	83 f9 01             	cmp    $0x1,%ecx
  8027e3:	7e 16                	jle    8027fb <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  8027e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8027e8:	8d 50 08             	lea    0x8(%eax),%edx
  8027eb:	89 55 14             	mov    %edx,0x14(%ebp)
  8027ee:	8b 10                	mov    (%eax),%edx
  8027f0:	8b 48 04             	mov    0x4(%eax),%ecx
  8027f3:	89 55 d0             	mov    %edx,-0x30(%ebp)
  8027f6:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  8027f9:	eb 32                	jmp    80282d <vprintfmt+0x300>
	else if (lflag)
  8027fb:	85 c9                	test   %ecx,%ecx
  8027fd:	74 18                	je     802817 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  8027ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802802:	8d 50 04             	lea    0x4(%eax),%edx
  802805:	89 55 14             	mov    %edx,0x14(%ebp)
  802808:	8b 00                	mov    (%eax),%eax
  80280a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80280d:	89 c1                	mov    %eax,%ecx
  80280f:	c1 f9 1f             	sar    $0x1f,%ecx
  802812:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  802815:	eb 16                	jmp    80282d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  802817:	8b 45 14             	mov    0x14(%ebp),%eax
  80281a:	8d 50 04             	lea    0x4(%eax),%edx
  80281d:	89 55 14             	mov    %edx,0x14(%ebp)
  802820:	8b 00                	mov    (%eax),%eax
  802822:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802825:	89 c2                	mov    %eax,%edx
  802827:	c1 fa 1f             	sar    $0x1f,%edx
  80282a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80282d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  802830:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802833:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  802838:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80283c:	0f 89 b8 00 00 00    	jns    8028fa <vprintfmt+0x3cd>
				putch('-', putdat);
  802842:	89 74 24 04          	mov    %esi,0x4(%esp)
  802846:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80284d:	ff d7                	call   *%edi
				num = -(long long) num;
  80284f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  802852:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802855:	f7 d9                	neg    %ecx
  802857:	83 d3 00             	adc    $0x0,%ebx
  80285a:	f7 db                	neg    %ebx
  80285c:	b8 0a 00 00 00       	mov    $0xa,%eax
  802861:	e9 94 00 00 00       	jmp    8028fa <vprintfmt+0x3cd>
  802866:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  802869:	89 ca                	mov    %ecx,%edx
  80286b:	8d 45 14             	lea    0x14(%ebp),%eax
  80286e:	e8 63 fc ff ff       	call   8024d6 <getuint>
  802873:	89 c1                	mov    %eax,%ecx
  802875:	89 d3                	mov    %edx,%ebx
  802877:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  80287c:	eb 7c                	jmp    8028fa <vprintfmt+0x3cd>
  80287e:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  802881:	89 74 24 04          	mov    %esi,0x4(%esp)
  802885:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  80288c:	ff d7                	call   *%edi
			putch('X', putdat);
  80288e:	89 74 24 04          	mov    %esi,0x4(%esp)
  802892:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  802899:	ff d7                	call   *%edi
			putch('X', putdat);
  80289b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80289f:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8028a6:	ff d7                	call   *%edi
  8028a8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8028ab:	e9 a9 fc ff ff       	jmp    802559 <vprintfmt+0x2c>
  8028b0:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8028b3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028b7:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8028be:	ff d7                	call   *%edi
			putch('x', putdat);
  8028c0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8028c4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8028cb:	ff d7                	call   *%edi
			num = (unsigned long long)
  8028cd:	8b 45 14             	mov    0x14(%ebp),%eax
  8028d0:	8d 50 04             	lea    0x4(%eax),%edx
  8028d3:	89 55 14             	mov    %edx,0x14(%ebp)
  8028d6:	8b 08                	mov    (%eax),%ecx
  8028d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8028dd:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  8028e2:	eb 16                	jmp    8028fa <vprintfmt+0x3cd>
  8028e4:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  8028e7:	89 ca                	mov    %ecx,%edx
  8028e9:	8d 45 14             	lea    0x14(%ebp),%eax
  8028ec:	e8 e5 fb ff ff       	call   8024d6 <getuint>
  8028f1:	89 c1                	mov    %eax,%ecx
  8028f3:	89 d3                	mov    %edx,%ebx
  8028f5:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  8028fa:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  8028fe:	89 54 24 10          	mov    %edx,0x10(%esp)
  802902:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802905:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802909:	89 44 24 08          	mov    %eax,0x8(%esp)
  80290d:	89 0c 24             	mov    %ecx,(%esp)
  802910:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802914:	89 f2                	mov    %esi,%edx
  802916:	89 f8                	mov    %edi,%eax
  802918:	e8 c3 fa ff ff       	call   8023e0 <printnum>
  80291d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  802920:	e9 34 fc ff ff       	jmp    802559 <vprintfmt+0x2c>
  802925:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802928:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80292b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80292f:	89 14 24             	mov    %edx,(%esp)
  802932:	ff d7                	call   *%edi
  802934:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  802937:	e9 1d fc ff ff       	jmp    802559 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80293c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802940:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  802947:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  802949:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80294c:	80 38 25             	cmpb   $0x25,(%eax)
  80294f:	0f 84 04 fc ff ff    	je     802559 <vprintfmt+0x2c>
  802955:	89 c3                	mov    %eax,%ebx
  802957:	eb f0                	jmp    802949 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  802959:	83 c4 5c             	add    $0x5c,%esp
  80295c:	5b                   	pop    %ebx
  80295d:	5e                   	pop    %esi
  80295e:	5f                   	pop    %edi
  80295f:	5d                   	pop    %ebp
  802960:	c3                   	ret    

00802961 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802961:	55                   	push   %ebp
  802962:	89 e5                	mov    %esp,%ebp
  802964:	83 ec 28             	sub    $0x28,%esp
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  80296d:	85 c0                	test   %eax,%eax
  80296f:	74 04                	je     802975 <vsnprintf+0x14>
  802971:	85 d2                	test   %edx,%edx
  802973:	7f 07                	jg     80297c <vsnprintf+0x1b>
  802975:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80297a:	eb 3b                	jmp    8029b7 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  80297c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80297f:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  802983:	89 45 f0             	mov    %eax,-0x10(%ebp)
  802986:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80298d:	8b 45 14             	mov    0x14(%ebp),%eax
  802990:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802994:	8b 45 10             	mov    0x10(%ebp),%eax
  802997:	89 44 24 08          	mov    %eax,0x8(%esp)
  80299b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80299e:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029a2:	c7 04 24 10 25 80 00 	movl   $0x802510,(%esp)
  8029a9:	e8 7f fb ff ff       	call   80252d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8029ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8029b1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8029b7:	c9                   	leave  
  8029b8:	c3                   	ret    

008029b9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8029b9:	55                   	push   %ebp
  8029ba:	89 e5                	mov    %esp,%ebp
  8029bc:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8029bf:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8029c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8029c9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d7:	89 04 24             	mov    %eax,(%esp)
  8029da:	e8 82 ff ff ff       	call   802961 <vsnprintf>
	va_end(ap);

	return rc;
}
  8029df:	c9                   	leave  
  8029e0:	c3                   	ret    

008029e1 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8029e1:	55                   	push   %ebp
  8029e2:	89 e5                	mov    %esp,%ebp
  8029e4:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  8029e7:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  8029ea:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8029f1:	89 44 24 08          	mov    %eax,0x8(%esp)
  8029f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8029f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8029fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ff:	89 04 24             	mov    %eax,(%esp)
  802a02:	e8 26 fb ff ff       	call   80252d <vprintfmt>
	va_end(ap);
}
  802a07:	c9                   	leave  
  802a08:	c3                   	ret    
  802a09:	00 00                	add    %al,(%eax)
  802a0b:	00 00                	add    %al,(%eax)
  802a0d:	00 00                	add    %al,(%eax)
	...

00802a10 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802a10:	55                   	push   %ebp
  802a11:	89 e5                	mov    %esp,%ebp
  802a13:	57                   	push   %edi
  802a14:	56                   	push   %esi
  802a15:	53                   	push   %ebx
  802a16:	83 ec 1c             	sub    $0x1c,%esp
  802a19:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802a1c:	8b 75 0c             	mov    0xc(%ebp),%esi
  802a1f:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  802a22:	8b 45 14             	mov    0x14(%ebp),%eax
  802a25:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802a29:	89 7c 24 08          	mov    %edi,0x8(%esp)
  802a2d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802a31:	89 1c 24             	mov    %ebx,(%esp)
  802a34:	e8 cf dd ff ff       	call   800808 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  802a39:	85 c0                	test   %eax,%eax
  802a3b:	79 21                	jns    802a5e <ipc_send+0x4e>
  802a3d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a40:	74 1c                	je     802a5e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  802a42:	c7 44 24 08 a0 32 80 	movl   $0x8032a0,0x8(%esp)
  802a49:	00 
  802a4a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  802a51:	00 
  802a52:	c7 04 24 b2 32 80 00 	movl   $0x8032b2,(%esp)
  802a59:	e8 5e f8 ff ff       	call   8022bc <_panic>
          else if(r==-E_IPC_NOT_RECV)
  802a5e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802a61:	75 07                	jne    802a6a <ipc_send+0x5a>
           sys_yield();
  802a63:	e8 0d e0 ff ff       	call   800a75 <sys_yield>
          else
            break;
        }
  802a68:	eb b8                	jmp    802a22 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  802a6a:	83 c4 1c             	add    $0x1c,%esp
  802a6d:	5b                   	pop    %ebx
  802a6e:	5e                   	pop    %esi
  802a6f:	5f                   	pop    %edi
  802a70:	5d                   	pop    %ebp
  802a71:	c3                   	ret    

00802a72 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802a72:	55                   	push   %ebp
  802a73:	89 e5                	mov    %esp,%ebp
  802a75:	83 ec 18             	sub    $0x18,%esp
  802a78:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  802a7b:	89 75 fc             	mov    %esi,-0x4(%ebp)
  802a7e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802a81:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  802a84:	8b 45 0c             	mov    0xc(%ebp),%eax
  802a87:	89 04 24             	mov    %eax,(%esp)
  802a8a:	e8 1c dd ff ff       	call   8007ab <sys_ipc_recv>
        if(r<0)
  802a8f:	85 c0                	test   %eax,%eax
  802a91:	79 17                	jns    802aaa <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  802a93:	85 db                	test   %ebx,%ebx
  802a95:	74 06                	je     802a9d <ipc_recv+0x2b>
               *from_env_store =0;
  802a97:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  802a9d:	85 f6                	test   %esi,%esi
  802a9f:	90                   	nop
  802aa0:	74 2c                	je     802ace <ipc_recv+0x5c>
              *perm_store=0;
  802aa2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  802aa8:	eb 24                	jmp    802ace <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  802aaa:	85 db                	test   %ebx,%ebx
  802aac:	74 0a                	je     802ab8 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  802aae:	a1 84 74 80 00       	mov    0x807484,%eax
  802ab3:	8b 40 74             	mov    0x74(%eax),%eax
  802ab6:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  802ab8:	85 f6                	test   %esi,%esi
  802aba:	74 0a                	je     802ac6 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  802abc:	a1 84 74 80 00       	mov    0x807484,%eax
  802ac1:	8b 40 78             	mov    0x78(%eax),%eax
  802ac4:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  802ac6:	a1 84 74 80 00       	mov    0x807484,%eax
  802acb:	8b 40 70             	mov    0x70(%eax),%eax
}
  802ace:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802ad1:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802ad4:	89 ec                	mov    %ebp,%esp
  802ad6:	5d                   	pop    %ebp
  802ad7:	c3                   	ret    

00802ad8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802ad8:	55                   	push   %ebp
  802ad9:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	89 c2                	mov    %eax,%edx
  802ae0:	c1 ea 16             	shr    $0x16,%edx
  802ae3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802aea:	f6 c2 01             	test   $0x1,%dl
  802aed:	74 26                	je     802b15 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  802aef:	c1 e8 0c             	shr    $0xc,%eax
  802af2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802af9:	a8 01                	test   $0x1,%al
  802afb:	74 18                	je     802b15 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  802afd:	c1 e8 0c             	shr    $0xc,%eax
  802b00:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802b03:	c1 e2 02             	shl    $0x2,%edx
  802b06:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  802b0b:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802b10:	0f b7 c0             	movzwl %ax,%eax
  802b13:	eb 05                	jmp    802b1a <pageref+0x42>
  802b15:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b1a:	5d                   	pop    %ebp
  802b1b:	c3                   	ret    
  802b1c:	00 00                	add    %al,(%eax)
	...

00802b20 <__udivdi3>:
  802b20:	55                   	push   %ebp
  802b21:	89 e5                	mov    %esp,%ebp
  802b23:	57                   	push   %edi
  802b24:	56                   	push   %esi
  802b25:	83 ec 10             	sub    $0x10,%esp
  802b28:	8b 45 14             	mov    0x14(%ebp),%eax
  802b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2e:	8b 75 10             	mov    0x10(%ebp),%esi
  802b31:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802b34:	85 c0                	test   %eax,%eax
  802b36:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802b39:	75 35                	jne    802b70 <__udivdi3+0x50>
  802b3b:	39 fe                	cmp    %edi,%esi
  802b3d:	77 61                	ja     802ba0 <__udivdi3+0x80>
  802b3f:	85 f6                	test   %esi,%esi
  802b41:	75 0b                	jne    802b4e <__udivdi3+0x2e>
  802b43:	b8 01 00 00 00       	mov    $0x1,%eax
  802b48:	31 d2                	xor    %edx,%edx
  802b4a:	f7 f6                	div    %esi
  802b4c:	89 c6                	mov    %eax,%esi
  802b4e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802b51:	31 d2                	xor    %edx,%edx
  802b53:	89 f8                	mov    %edi,%eax
  802b55:	f7 f6                	div    %esi
  802b57:	89 c7                	mov    %eax,%edi
  802b59:	89 c8                	mov    %ecx,%eax
  802b5b:	f7 f6                	div    %esi
  802b5d:	89 c1                	mov    %eax,%ecx
  802b5f:	89 fa                	mov    %edi,%edx
  802b61:	89 c8                	mov    %ecx,%eax
  802b63:	83 c4 10             	add    $0x10,%esp
  802b66:	5e                   	pop    %esi
  802b67:	5f                   	pop    %edi
  802b68:	5d                   	pop    %ebp
  802b69:	c3                   	ret    
  802b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  802b70:	39 f8                	cmp    %edi,%eax
  802b72:	77 1c                	ja     802b90 <__udivdi3+0x70>
  802b74:	0f bd d0             	bsr    %eax,%edx
  802b77:	83 f2 1f             	xor    $0x1f,%edx
  802b7a:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802b7d:	75 39                	jne    802bb8 <__udivdi3+0x98>
  802b7f:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  802b82:	0f 86 a0 00 00 00    	jbe    802c28 <__udivdi3+0x108>
  802b88:	39 f8                	cmp    %edi,%eax
  802b8a:	0f 82 98 00 00 00    	jb     802c28 <__udivdi3+0x108>
  802b90:	31 ff                	xor    %edi,%edi
  802b92:	31 c9                	xor    %ecx,%ecx
  802b94:	89 c8                	mov    %ecx,%eax
  802b96:	89 fa                	mov    %edi,%edx
  802b98:	83 c4 10             	add    $0x10,%esp
  802b9b:	5e                   	pop    %esi
  802b9c:	5f                   	pop    %edi
  802b9d:	5d                   	pop    %ebp
  802b9e:	c3                   	ret    
  802b9f:	90                   	nop
  802ba0:	89 d1                	mov    %edx,%ecx
  802ba2:	89 fa                	mov    %edi,%edx
  802ba4:	89 c8                	mov    %ecx,%eax
  802ba6:	31 ff                	xor    %edi,%edi
  802ba8:	f7 f6                	div    %esi
  802baa:	89 c1                	mov    %eax,%ecx
  802bac:	89 fa                	mov    %edi,%edx
  802bae:	89 c8                	mov    %ecx,%eax
  802bb0:	83 c4 10             	add    $0x10,%esp
  802bb3:	5e                   	pop    %esi
  802bb4:	5f                   	pop    %edi
  802bb5:	5d                   	pop    %ebp
  802bb6:	c3                   	ret    
  802bb7:	90                   	nop
  802bb8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802bbc:	89 f2                	mov    %esi,%edx
  802bbe:	d3 e0                	shl    %cl,%eax
  802bc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802bc3:	b8 20 00 00 00       	mov    $0x20,%eax
  802bc8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  802bcb:	89 c1                	mov    %eax,%ecx
  802bcd:	d3 ea                	shr    %cl,%edx
  802bcf:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802bd3:	0b 55 ec             	or     -0x14(%ebp),%edx
  802bd6:	d3 e6                	shl    %cl,%esi
  802bd8:	89 c1                	mov    %eax,%ecx
  802bda:	89 75 e8             	mov    %esi,-0x18(%ebp)
  802bdd:	89 fe                	mov    %edi,%esi
  802bdf:	d3 ee                	shr    %cl,%esi
  802be1:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802be5:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802be8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802beb:	d3 e7                	shl    %cl,%edi
  802bed:	89 c1                	mov    %eax,%ecx
  802bef:	d3 ea                	shr    %cl,%edx
  802bf1:	09 d7                	or     %edx,%edi
  802bf3:	89 f2                	mov    %esi,%edx
  802bf5:	89 f8                	mov    %edi,%eax
  802bf7:	f7 75 ec             	divl   -0x14(%ebp)
  802bfa:	89 d6                	mov    %edx,%esi
  802bfc:	89 c7                	mov    %eax,%edi
  802bfe:	f7 65 e8             	mull   -0x18(%ebp)
  802c01:	39 d6                	cmp    %edx,%esi
  802c03:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802c06:	72 30                	jb     802c38 <__udivdi3+0x118>
  802c08:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802c0b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802c0f:	d3 e2                	shl    %cl,%edx
  802c11:	39 c2                	cmp    %eax,%edx
  802c13:	73 05                	jae    802c1a <__udivdi3+0xfa>
  802c15:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802c18:	74 1e                	je     802c38 <__udivdi3+0x118>
  802c1a:	89 f9                	mov    %edi,%ecx
  802c1c:	31 ff                	xor    %edi,%edi
  802c1e:	e9 71 ff ff ff       	jmp    802b94 <__udivdi3+0x74>
  802c23:	90                   	nop
  802c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c28:	31 ff                	xor    %edi,%edi
  802c2a:	b9 01 00 00 00       	mov    $0x1,%ecx
  802c2f:	e9 60 ff ff ff       	jmp    802b94 <__udivdi3+0x74>
  802c34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802c38:	8d 4f ff             	lea    -0x1(%edi),%ecx
  802c3b:	31 ff                	xor    %edi,%edi
  802c3d:	89 c8                	mov    %ecx,%eax
  802c3f:	89 fa                	mov    %edi,%edx
  802c41:	83 c4 10             	add    $0x10,%esp
  802c44:	5e                   	pop    %esi
  802c45:	5f                   	pop    %edi
  802c46:	5d                   	pop    %ebp
  802c47:	c3                   	ret    
	...

00802c50 <__umoddi3>:
  802c50:	55                   	push   %ebp
  802c51:	89 e5                	mov    %esp,%ebp
  802c53:	57                   	push   %edi
  802c54:	56                   	push   %esi
  802c55:	83 ec 20             	sub    $0x20,%esp
  802c58:	8b 55 14             	mov    0x14(%ebp),%edx
  802c5b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802c5e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802c61:	8b 75 0c             	mov    0xc(%ebp),%esi
  802c64:	85 d2                	test   %edx,%edx
  802c66:	89 c8                	mov    %ecx,%eax
  802c68:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  802c6b:	75 13                	jne    802c80 <__umoddi3+0x30>
  802c6d:	39 f7                	cmp    %esi,%edi
  802c6f:	76 3f                	jbe    802cb0 <__umoddi3+0x60>
  802c71:	89 f2                	mov    %esi,%edx
  802c73:	f7 f7                	div    %edi
  802c75:	89 d0                	mov    %edx,%eax
  802c77:	31 d2                	xor    %edx,%edx
  802c79:	83 c4 20             	add    $0x20,%esp
  802c7c:	5e                   	pop    %esi
  802c7d:	5f                   	pop    %edi
  802c7e:	5d                   	pop    %ebp
  802c7f:	c3                   	ret    
  802c80:	39 f2                	cmp    %esi,%edx
  802c82:	77 4c                	ja     802cd0 <__umoddi3+0x80>
  802c84:	0f bd ca             	bsr    %edx,%ecx
  802c87:	83 f1 1f             	xor    $0x1f,%ecx
  802c8a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  802c8d:	75 51                	jne    802ce0 <__umoddi3+0x90>
  802c8f:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  802c92:	0f 87 e0 00 00 00    	ja     802d78 <__umoddi3+0x128>
  802c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9b:	29 f8                	sub    %edi,%eax
  802c9d:	19 d6                	sbb    %edx,%esi
  802c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	89 f2                	mov    %esi,%edx
  802ca7:	83 c4 20             	add    $0x20,%esp
  802caa:	5e                   	pop    %esi
  802cab:	5f                   	pop    %edi
  802cac:	5d                   	pop    %ebp
  802cad:	c3                   	ret    
  802cae:	66 90                	xchg   %ax,%ax
  802cb0:	85 ff                	test   %edi,%edi
  802cb2:	75 0b                	jne    802cbf <__umoddi3+0x6f>
  802cb4:	b8 01 00 00 00       	mov    $0x1,%eax
  802cb9:	31 d2                	xor    %edx,%edx
  802cbb:	f7 f7                	div    %edi
  802cbd:	89 c7                	mov    %eax,%edi
  802cbf:	89 f0                	mov    %esi,%eax
  802cc1:	31 d2                	xor    %edx,%edx
  802cc3:	f7 f7                	div    %edi
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	f7 f7                	div    %edi
  802cca:	eb a9                	jmp    802c75 <__umoddi3+0x25>
  802ccc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802cd0:	89 c8                	mov    %ecx,%eax
  802cd2:	89 f2                	mov    %esi,%edx
  802cd4:	83 c4 20             	add    $0x20,%esp
  802cd7:	5e                   	pop    %esi
  802cd8:	5f                   	pop    %edi
  802cd9:	5d                   	pop    %ebp
  802cda:	c3                   	ret    
  802cdb:	90                   	nop
  802cdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802ce0:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802ce4:	d3 e2                	shl    %cl,%edx
  802ce6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802ce9:	ba 20 00 00 00       	mov    $0x20,%edx
  802cee:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802cf1:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802cf4:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802cf8:	89 fa                	mov    %edi,%edx
  802cfa:	d3 ea                	shr    %cl,%edx
  802cfc:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d00:	0b 55 f4             	or     -0xc(%ebp),%edx
  802d03:	d3 e7                	shl    %cl,%edi
  802d05:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d09:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802d0c:	89 f2                	mov    %esi,%edx
  802d0e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802d11:	89 c7                	mov    %eax,%edi
  802d13:	d3 ea                	shr    %cl,%edx
  802d15:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d19:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802d1c:	89 c2                	mov    %eax,%edx
  802d1e:	d3 e6                	shl    %cl,%esi
  802d20:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d24:	d3 ea                	shr    %cl,%edx
  802d26:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d2a:	09 d6                	or     %edx,%esi
  802d2c:	89 f0                	mov    %esi,%eax
  802d2e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802d31:	d3 e7                	shl    %cl,%edi
  802d33:	89 f2                	mov    %esi,%edx
  802d35:	f7 75 f4             	divl   -0xc(%ebp)
  802d38:	89 d6                	mov    %edx,%esi
  802d3a:	f7 65 e8             	mull   -0x18(%ebp)
  802d3d:	39 d6                	cmp    %edx,%esi
  802d3f:	72 2b                	jb     802d6c <__umoddi3+0x11c>
  802d41:	39 c7                	cmp    %eax,%edi
  802d43:	72 23                	jb     802d68 <__umoddi3+0x118>
  802d45:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d49:	29 c7                	sub    %eax,%edi
  802d4b:	19 d6                	sbb    %edx,%esi
  802d4d:	89 f0                	mov    %esi,%eax
  802d4f:	89 f2                	mov    %esi,%edx
  802d51:	d3 ef                	shr    %cl,%edi
  802d53:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802d57:	d3 e0                	shl    %cl,%eax
  802d59:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802d5d:	09 f8                	or     %edi,%eax
  802d5f:	d3 ea                	shr    %cl,%edx
  802d61:	83 c4 20             	add    $0x20,%esp
  802d64:	5e                   	pop    %esi
  802d65:	5f                   	pop    %edi
  802d66:	5d                   	pop    %ebp
  802d67:	c3                   	ret    
  802d68:	39 d6                	cmp    %edx,%esi
  802d6a:	75 d9                	jne    802d45 <__umoddi3+0xf5>
  802d6c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  802d6f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  802d72:	eb d1                	jmp    802d45 <__umoddi3+0xf5>
  802d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802d78:	39 f2                	cmp    %esi,%edx
  802d7a:	0f 82 18 ff ff ff    	jb     802c98 <__umoddi3+0x48>
  802d80:	e9 1d ff ff ff       	jmp    802ca2 <__umoddi3+0x52>
