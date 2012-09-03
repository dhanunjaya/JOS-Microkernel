
obj/user/echo:     file format elf32-i386


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
  80002c:	e8 e3 00 00 00       	call   800114 <libmain>
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
  800043:	57                   	push   %edi
  800044:	56                   	push   %esi
  800045:	53                   	push   %ebx
  800046:	83 ec 2c             	sub    $0x2c,%esp
  800049:	8b 7d 08             	mov    0x8(%ebp),%edi
  80004c:	8b 75 0c             	mov    0xc(%ebp),%esi
	int i, nflag;

	nflag = 0;
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  80004f:	83 ff 01             	cmp    $0x1,%edi
  800052:	0f 8e 8b 00 00 00    	jle    8000e3 <umain+0xa3>
  800058:	8d 5e 04             	lea    0x4(%esi),%ebx
  80005b:	c7 44 24 04 c0 28 80 	movl   $0x8028c0,0x4(%esp)
  800062:	00 
  800063:	8b 03                	mov    (%ebx),%eax
  800065:	89 04 24             	mov    %eax,(%esp)
  800068:	e8 ec 01 00 00       	call   800259 <strcmp>
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
		write(1, "\n", 1);
}
  80006d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
umain(int argc, char **argv)
{
	int i, nflag;

	nflag = 0;
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
  800074:	85 c0                	test   %eax,%eax
  800076:	0f 85 85 00 00 00    	jne    800101 <umain+0xc1>
		nflag = 1;
		argc--;
  80007c:	83 ef 01             	sub    $0x1,%edi
		argv++;
	}
	for (i = 1; i < argc; i++) {
  80007f:	83 ff 01             	cmp    $0x1,%edi
  800082:	0f 8e 80 00 00 00    	jle    800108 <umain+0xc8>
  800088:	89 de                	mov    %ebx,%esi
  80008a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  800091:	eb 6e                	jmp    800101 <umain+0xc1>
		if (i > 1)
  800093:	83 fb 01             	cmp    $0x1,%ebx
  800096:	7e 1c                	jle    8000b4 <umain+0x74>
			write(1, " ", 1);
  800098:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  80009f:	00 
  8000a0:	c7 44 24 04 33 2a 80 	movl   $0x802a33,0x4(%esp)
  8000a7:	00 
  8000a8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000af:	e8 11 0c 00 00       	call   800cc5 <write>
		write(1, argv[i], strlen(argv[i]));
  8000b4:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8000b7:	89 04 24             	mov    %eax,(%esp)
  8000ba:	e8 c1 00 00 00       	call   800180 <strlen>
  8000bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8000c3:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
  8000c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000d1:	e8 ef 0b 00 00       	call   800cc5 <write>
	if (argc > 1 && strcmp(argv[1], "-n") == 0) {
		nflag = 1;
		argc--;
		argv++;
	}
	for (i = 1; i < argc; i++) {
  8000d6:	83 c3 01             	add    $0x1,%ebx
  8000d9:	39 fb                	cmp    %edi,%ebx
  8000db:	7c b6                	jl     800093 <umain+0x53>
		if (i > 1)
			write(1, " ", 1);
		write(1, argv[i], strlen(argv[i]));
	}
	if (!nflag)
  8000dd:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8000e1:	75 25                	jne    800108 <umain+0xc8>
		write(1, "\n", 1);
  8000e3:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  8000ea:	00 
  8000eb:	c7 44 24 04 01 2a 80 	movl   $0x802a01,0x4(%esp)
  8000f2:	00 
  8000f3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8000fa:	e8 c6 0b 00 00       	call   800cc5 <write>
  8000ff:	eb 07                	jmp    800108 <umain+0xc8>
}
  800101:	bb 01 00 00 00       	mov    $0x1,%ebx
  800106:	eb ac                	jmp    8000b4 <umain+0x74>
  800108:	83 c4 2c             	add    $0x2c,%esp
  80010b:	5b                   	pop    %ebx
  80010c:	5e                   	pop    %esi
  80010d:	5f                   	pop    %edi
  80010e:	5d                   	pop    %ebp
  80010f:	90                   	nop
  800110:	c3                   	ret    
  800111:	00 00                	add    %al,(%eax)
	...

00800114 <libmain>:
volatile struct Env *env;
char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800114:	55                   	push   %ebp
  800115:	89 e5                	mov    %esp,%ebp
  800117:	83 ec 18             	sub    $0x18,%esp
  80011a:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  80011d:	89 75 fc             	mov    %esi,-0x4(%ebp)
  800120:	8b 75 08             	mov    0x8(%ebp),%esi
  800123:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// set env to point at our env structure in envs[].
	// LAB 3: Your code here.
       // uint32_t envid=sys_getenvid();
	env = (envs+ENVX(sys_getenvid()));
  800126:	e8 8e 08 00 00       	call   8009b9 <sys_getenvid>
  80012b:	25 ff 03 00 00       	and    $0x3ff,%eax
  800130:	6b c0 7c             	imul   $0x7c,%eax,%eax
  800133:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800138:	a3 74 60 80 00       	mov    %eax,0x806074

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80013d:	85 f6                	test   %esi,%esi
  80013f:	7e 07                	jle    800148 <libmain+0x34>
		binaryname = argv[0];
  800141:	8b 03                	mov    (%ebx),%eax
  800143:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	umain(argc, argv);
  800148:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80014c:	89 34 24             	mov    %esi,(%esp)
  80014f:	e8 ec fe ff ff       	call   800040 <umain>

	// exit gracefully
	exit();
  800154:	e8 0b 00 00 00       	call   800164 <exit>
}
  800159:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80015c:	8b 75 fc             	mov    -0x4(%ebp),%esi
  80015f:	89 ec                	mov    %ebp,%esp
  800161:	5d                   	pop    %ebp
  800162:	c3                   	ret    
	...

00800164 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800164:	55                   	push   %ebp
  800165:	89 e5                	mov    %esp,%ebp
  800167:	83 ec 18             	sub    $0x18,%esp
	close_all();
  80016a:	e8 bc 0d 00 00       	call   800f2b <close_all>
	sys_env_destroy(0);
  80016f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800176:	e8 72 08 00 00       	call   8009ed <sys_env_destroy>
}
  80017b:	c9                   	leave  
  80017c:	c3                   	ret    
  80017d:	00 00                	add    %al,(%eax)
	...

00800180 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800180:	55                   	push   %ebp
  800181:	89 e5                	mov    %esp,%ebp
  800183:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800186:	b8 00 00 00 00       	mov    $0x0,%eax
  80018b:	80 3a 00             	cmpb   $0x0,(%edx)
  80018e:	74 09                	je     800199 <strlen+0x19>
		n++;
  800190:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800193:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800197:	75 f7                	jne    800190 <strlen+0x10>
		n++;
	return n;
}
  800199:	5d                   	pop    %ebp
  80019a:	c3                   	ret    

0080019b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	53                   	push   %ebx
  80019f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001a2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8001a5:	85 c9                	test   %ecx,%ecx
  8001a7:	74 19                	je     8001c2 <strnlen+0x27>
  8001a9:	80 3b 00             	cmpb   $0x0,(%ebx)
  8001ac:	74 14                	je     8001c2 <strnlen+0x27>
  8001ae:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
  8001b3:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8001b6:	39 c8                	cmp    %ecx,%eax
  8001b8:	74 0d                	je     8001c7 <strnlen+0x2c>
  8001ba:	80 3c 03 00          	cmpb   $0x0,(%ebx,%eax,1)
  8001be:	75 f3                	jne    8001b3 <strnlen+0x18>
  8001c0:	eb 05                	jmp    8001c7 <strnlen+0x2c>
  8001c2:	b8 00 00 00 00       	mov    $0x0,%eax
		n++;
	return n;
}
  8001c7:	5b                   	pop    %ebx
  8001c8:	5d                   	pop    %ebp
  8001c9:	c3                   	ret    

008001ca <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	53                   	push   %ebx
  8001ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8001d4:	ba 00 00 00 00       	mov    $0x0,%edx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8001d9:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
  8001dd:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  8001e0:	83 c2 01             	add    $0x1,%edx
  8001e3:	84 c9                	test   %cl,%cl
  8001e5:	75 f2                	jne    8001d9 <strcpy+0xf>
		/* do nothing */;
	return ret;
}
  8001e7:	5b                   	pop    %ebx
  8001e8:	5d                   	pop    %ebp
  8001e9:	c3                   	ret    

008001ea <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	56                   	push   %esi
  8001ee:	53                   	push   %ebx
  8001ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8001f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001f5:	8b 75 10             	mov    0x10(%ebp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8001f8:	85 f6                	test   %esi,%esi
  8001fa:	74 18                	je     800214 <strncpy+0x2a>
  8001fc:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
  800201:	0f b6 1a             	movzbl (%edx),%ebx
  800204:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800207:	80 3a 01             	cmpb   $0x1,(%edx)
  80020a:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80020d:	83 c1 01             	add    $0x1,%ecx
  800210:	39 ce                	cmp    %ecx,%esi
  800212:	77 ed                	ja     800201 <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    

00800218 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	56                   	push   %esi
  80021c:	53                   	push   %ebx
  80021d:	8b 75 08             	mov    0x8(%ebp),%esi
  800220:	8b 55 0c             	mov    0xc(%ebp),%edx
  800223:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800226:	89 f0                	mov    %esi,%eax
  800228:	85 c9                	test   %ecx,%ecx
  80022a:	74 27                	je     800253 <strlcpy+0x3b>
		while (--size > 0 && *src != '\0')
  80022c:	83 e9 01             	sub    $0x1,%ecx
  80022f:	74 1d                	je     80024e <strlcpy+0x36>
  800231:	0f b6 1a             	movzbl (%edx),%ebx
  800234:	84 db                	test   %bl,%bl
  800236:	74 16                	je     80024e <strlcpy+0x36>
			*dst++ = *src++;
  800238:	88 18                	mov    %bl,(%eax)
  80023a:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80023d:	83 e9 01             	sub    $0x1,%ecx
  800240:	74 0e                	je     800250 <strlcpy+0x38>
			*dst++ = *src++;
  800242:	83 c2 01             	add    $0x1,%edx
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800245:	0f b6 1a             	movzbl (%edx),%ebx
  800248:	84 db                	test   %bl,%bl
  80024a:	75 ec                	jne    800238 <strlcpy+0x20>
  80024c:	eb 02                	jmp    800250 <strlcpy+0x38>
  80024e:	89 f0                	mov    %esi,%eax
			*dst++ = *src++;
		*dst = '\0';
  800250:	c6 00 00             	movb   $0x0,(%eax)
  800253:	29 f0                	sub    %esi,%eax
	}
	return dst - dst_in;
}
  800255:	5b                   	pop    %ebx
  800256:	5e                   	pop    %esi
  800257:	5d                   	pop    %ebp
  800258:	c3                   	ret    

00800259 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800259:	55                   	push   %ebp
  80025a:	89 e5                	mov    %esp,%ebp
  80025c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80025f:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800262:	0f b6 01             	movzbl (%ecx),%eax
  800265:	84 c0                	test   %al,%al
  800267:	74 15                	je     80027e <strcmp+0x25>
  800269:	3a 02                	cmp    (%edx),%al
  80026b:	75 11                	jne    80027e <strcmp+0x25>
		p++, q++;
  80026d:	83 c1 01             	add    $0x1,%ecx
  800270:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800273:	0f b6 01             	movzbl (%ecx),%eax
  800276:	84 c0                	test   %al,%al
  800278:	74 04                	je     80027e <strcmp+0x25>
  80027a:	3a 02                	cmp    (%edx),%al
  80027c:	74 ef                	je     80026d <strcmp+0x14>
  80027e:	0f b6 c0             	movzbl %al,%eax
  800281:	0f b6 12             	movzbl (%edx),%edx
  800284:	29 d0                	sub    %edx,%eax
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
}
  800286:	5d                   	pop    %ebp
  800287:	c3                   	ret    

00800288 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800288:	55                   	push   %ebp
  800289:	89 e5                	mov    %esp,%ebp
  80028b:	53                   	push   %ebx
  80028c:	8b 55 08             	mov    0x8(%ebp),%edx
  80028f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800292:	8b 45 10             	mov    0x10(%ebp),%eax
	while (n > 0 && *p && *p == *q)
  800295:	85 c0                	test   %eax,%eax
  800297:	74 23                	je     8002bc <strncmp+0x34>
  800299:	0f b6 1a             	movzbl (%edx),%ebx
  80029c:	84 db                	test   %bl,%bl
  80029e:	74 24                	je     8002c4 <strncmp+0x3c>
  8002a0:	3a 19                	cmp    (%ecx),%bl
  8002a2:	75 20                	jne    8002c4 <strncmp+0x3c>
  8002a4:	83 e8 01             	sub    $0x1,%eax
  8002a7:	74 13                	je     8002bc <strncmp+0x34>
		n--, p++, q++;
  8002a9:	83 c2 01             	add    $0x1,%edx
  8002ac:	83 c1 01             	add    $0x1,%ecx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
  8002af:	0f b6 1a             	movzbl (%edx),%ebx
  8002b2:	84 db                	test   %bl,%bl
  8002b4:	74 0e                	je     8002c4 <strncmp+0x3c>
  8002b6:	3a 19                	cmp    (%ecx),%bl
  8002b8:	74 ea                	je     8002a4 <strncmp+0x1c>
  8002ba:	eb 08                	jmp    8002c4 <strncmp+0x3c>
  8002bc:	b8 00 00 00 00       	mov    $0x0,%eax
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
  8002c1:	5b                   	pop    %ebx
  8002c2:	5d                   	pop    %ebp
  8002c3:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8002c4:	0f b6 02             	movzbl (%edx),%eax
  8002c7:	0f b6 11             	movzbl (%ecx),%edx
  8002ca:	29 d0                	sub    %edx,%eax
  8002cc:	eb f3                	jmp    8002c1 <strncmp+0x39>

008002ce <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8002ce:	55                   	push   %ebp
  8002cf:	89 e5                	mov    %esp,%ebp
  8002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  8002d8:	0f b6 10             	movzbl (%eax),%edx
  8002db:	84 d2                	test   %dl,%dl
  8002dd:	74 15                	je     8002f4 <strchr+0x26>
		if (*s == c)
  8002df:	38 ca                	cmp    %cl,%dl
  8002e1:	75 07                	jne    8002ea <strchr+0x1c>
  8002e3:	eb 14                	jmp    8002f9 <strchr+0x2b>
  8002e5:	38 ca                	cmp    %cl,%dl
  8002e7:	90                   	nop
  8002e8:	74 0f                	je     8002f9 <strchr+0x2b>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8002ea:	83 c0 01             	add    $0x1,%eax
  8002ed:	0f b6 10             	movzbl (%eax),%edx
  8002f0:	84 d2                	test   %dl,%dl
  8002f2:	75 f1                	jne    8002e5 <strchr+0x17>
  8002f4:	b8 00 00 00 00       	mov    $0x0,%eax
		if (*s == c)
			return (char *) s;
	return 0;
}
  8002f9:	5d                   	pop    %ebp
  8002fa:	c3                   	ret    

008002fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8002fb:	55                   	push   %ebp
  8002fc:	89 e5                	mov    %esp,%ebp
  8002fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800301:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
	for (; *s; s++)
  800305:	0f b6 10             	movzbl (%eax),%edx
  800308:	84 d2                	test   %dl,%dl
  80030a:	74 18                	je     800324 <strfind+0x29>
		if (*s == c)
  80030c:	38 ca                	cmp    %cl,%dl
  80030e:	75 0a                	jne    80031a <strfind+0x1f>
  800310:	eb 12                	jmp    800324 <strfind+0x29>
  800312:	38 ca                	cmp    %cl,%dl
  800314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  800318:	74 0a                	je     800324 <strfind+0x29>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80031a:	83 c0 01             	add    $0x1,%eax
  80031d:	0f b6 10             	movzbl (%eax),%edx
  800320:	84 d2                	test   %dl,%dl
  800322:	75 ee                	jne    800312 <strfind+0x17>
		if (*s == c)
			break;
	return (char *) s;
}
  800324:	5d                   	pop    %ebp
  800325:	c3                   	ret    

00800326 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	83 ec 0c             	sub    $0xc,%esp
  80032c:	89 1c 24             	mov    %ebx,(%esp)
  80032f:	89 74 24 04          	mov    %esi,0x4(%esp)
  800333:	89 7c 24 08          	mov    %edi,0x8(%esp)
  800337:	8b 7d 08             	mov    0x8(%ebp),%edi
  80033a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80033d:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800340:	85 c9                	test   %ecx,%ecx
  800342:	74 30                	je     800374 <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800344:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80034a:	75 25                	jne    800371 <memset+0x4b>
  80034c:	f6 c1 03             	test   $0x3,%cl
  80034f:	75 20                	jne    800371 <memset+0x4b>
		c &= 0xFF;
  800351:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800354:	89 d3                	mov    %edx,%ebx
  800356:	c1 e3 08             	shl    $0x8,%ebx
  800359:	89 d6                	mov    %edx,%esi
  80035b:	c1 e6 18             	shl    $0x18,%esi
  80035e:	89 d0                	mov    %edx,%eax
  800360:	c1 e0 10             	shl    $0x10,%eax
  800363:	09 f0                	or     %esi,%eax
  800365:	09 d0                	or     %edx,%eax
		asm volatile("cld; rep stosl\n"
  800367:	09 d8                	or     %ebx,%eax
  800369:	c1 e9 02             	shr    $0x2,%ecx
  80036c:	fc                   	cld    
  80036d:	f3 ab                	rep stos %eax,%es:(%edi)
{
	char *p;

	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80036f:	eb 03                	jmp    800374 <memset+0x4e>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800371:	fc                   	cld    
  800372:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800374:	89 f8                	mov    %edi,%eax
  800376:	8b 1c 24             	mov    (%esp),%ebx
  800379:	8b 74 24 04          	mov    0x4(%esp),%esi
  80037d:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800381:	89 ec                	mov    %ebp,%esp
  800383:	5d                   	pop    %ebp
  800384:	c3                   	ret    

00800385 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800385:	55                   	push   %ebp
  800386:	89 e5                	mov    %esp,%ebp
  800388:	83 ec 08             	sub    $0x8,%esp
  80038b:	89 34 24             	mov    %esi,(%esp)
  80038e:	89 7c 24 04          	mov    %edi,0x4(%esp)
  800392:	8b 45 08             	mov    0x8(%ebp),%eax
  800395:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;
	
	s = src;
  800398:	8b 75 0c             	mov    0xc(%ebp),%esi
	d = dst;
  80039b:	89 c7                	mov    %eax,%edi
	if (s < d && s + n > d) {
  80039d:	39 c6                	cmp    %eax,%esi
  80039f:	73 35                	jae    8003d6 <memmove+0x51>
  8003a1:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8003a4:	39 d0                	cmp    %edx,%eax
  8003a6:	73 2e                	jae    8003d6 <memmove+0x51>
		s += n;
		d += n;
  8003a8:	01 cf                	add    %ecx,%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8003aa:	f6 c2 03             	test   $0x3,%dl
  8003ad:	75 1b                	jne    8003ca <memmove+0x45>
  8003af:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8003b5:	75 13                	jne    8003ca <memmove+0x45>
  8003b7:	f6 c1 03             	test   $0x3,%cl
  8003ba:	75 0e                	jne    8003ca <memmove+0x45>
			asm volatile("std; rep movsl\n"
  8003bc:	83 ef 04             	sub    $0x4,%edi
  8003bf:	8d 72 fc             	lea    -0x4(%edx),%esi
  8003c2:	c1 e9 02             	shr    $0x2,%ecx
  8003c5:	fd                   	std    
  8003c6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8003c8:	eb 09                	jmp    8003d3 <memmove+0x4e>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
  8003ca:	83 ef 01             	sub    $0x1,%edi
  8003cd:	8d 72 ff             	lea    -0x1(%edx),%esi
  8003d0:	fd                   	std    
  8003d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8003d3:	fc                   	cld    
	const char *s;
	char *d;
	
	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8003d4:	eb 20                	jmp    8003f6 <memmove+0x71>
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8003d6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8003dc:	75 15                	jne    8003f3 <memmove+0x6e>
  8003de:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8003e4:	75 0d                	jne    8003f3 <memmove+0x6e>
  8003e6:	f6 c1 03             	test   $0x3,%cl
  8003e9:	75 08                	jne    8003f3 <memmove+0x6e>
			asm volatile("cld; rep movsl\n"
  8003eb:	c1 e9 02             	shr    $0x2,%ecx
  8003ee:	fc                   	cld    
  8003ef:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8003f1:	eb 03                	jmp    8003f6 <memmove+0x71>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8003f3:	fc                   	cld    
  8003f4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8003f6:	8b 34 24             	mov    (%esp),%esi
  8003f9:	8b 7c 24 04          	mov    0x4(%esp),%edi
  8003fd:	89 ec                	mov    %ebp,%esp
  8003ff:	5d                   	pop    %ebp
  800400:	c3                   	ret    

00800401 <memcpy>:

/* sigh - gcc emits references to this for structure assignments! */
/* it is *not* prototyped in inc/string.h - do not use directly. */
void *
memcpy(void *dst, void *src, size_t n)
{
  800401:	55                   	push   %ebp
  800402:	89 e5                	mov    %esp,%ebp
  800404:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
  800407:	8b 45 10             	mov    0x10(%ebp),%eax
  80040a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80040e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800411:	89 44 24 04          	mov    %eax,0x4(%esp)
  800415:	8b 45 08             	mov    0x8(%ebp),%eax
  800418:	89 04 24             	mov    %eax,(%esp)
  80041b:	e8 65 ff ff ff       	call   800385 <memmove>
}
  800420:	c9                   	leave  
  800421:	c3                   	ret    

00800422 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
  800425:	57                   	push   %edi
  800426:	56                   	push   %esi
  800427:	53                   	push   %ebx
  800428:	8b 75 08             	mov    0x8(%ebp),%esi
  80042b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80042e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  800431:	85 c9                	test   %ecx,%ecx
  800433:	74 36                	je     80046b <memcmp+0x49>
		if (*s1 != *s2)
  800435:	0f b6 06             	movzbl (%esi),%eax
  800438:	0f b6 1f             	movzbl (%edi),%ebx
  80043b:	38 d8                	cmp    %bl,%al
  80043d:	74 20                	je     80045f <memcmp+0x3d>
  80043f:	eb 14                	jmp    800455 <memcmp+0x33>
  800441:	0f b6 44 16 01       	movzbl 0x1(%esi,%edx,1),%eax
  800446:	0f b6 5c 17 01       	movzbl 0x1(%edi,%edx,1),%ebx
  80044b:	83 c2 01             	add    $0x1,%edx
  80044e:	83 e9 01             	sub    $0x1,%ecx
  800451:	38 d8                	cmp    %bl,%al
  800453:	74 12                	je     800467 <memcmp+0x45>
			return (int) *s1 - (int) *s2;
  800455:	0f b6 c0             	movzbl %al,%eax
  800458:	0f b6 db             	movzbl %bl,%ebx
  80045b:	29 d8                	sub    %ebx,%eax
  80045d:	eb 11                	jmp    800470 <memcmp+0x4e>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
  80045f:	83 e9 01             	sub    $0x1,%ecx
  800462:	ba 00 00 00 00       	mov    $0x0,%edx
  800467:	85 c9                	test   %ecx,%ecx
  800469:	75 d6                	jne    800441 <memcmp+0x1f>
  80046b:	b8 00 00 00 00       	mov    $0x0,%eax
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
}
  800470:	5b                   	pop    %ebx
  800471:	5e                   	pop    %esi
  800472:	5f                   	pop    %edi
  800473:	5d                   	pop    %ebp
  800474:	c3                   	ret    

00800475 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800475:	55                   	push   %ebp
  800476:	89 e5                	mov    %esp,%ebp
  800478:	8b 45 08             	mov    0x8(%ebp),%eax
	const void *ends = (const char *) s + n;
  80047b:	89 c2                	mov    %eax,%edx
  80047d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800480:	39 d0                	cmp    %edx,%eax
  800482:	73 15                	jae    800499 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
  800484:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  800488:	38 08                	cmp    %cl,(%eax)
  80048a:	75 06                	jne    800492 <memfind+0x1d>
  80048c:	eb 0b                	jmp    800499 <memfind+0x24>
  80048e:	38 08                	cmp    %cl,(%eax)
  800490:	74 07                	je     800499 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800492:	83 c0 01             	add    $0x1,%eax
  800495:	39 c2                	cmp    %eax,%edx
  800497:	77 f5                	ja     80048e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
  800499:	5d                   	pop    %ebp
  80049a:	c3                   	ret    

0080049b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80049b:	55                   	push   %ebp
  80049c:	89 e5                	mov    %esp,%ebp
  80049e:	57                   	push   %edi
  80049f:	56                   	push   %esi
  8004a0:	53                   	push   %ebx
  8004a1:	83 ec 04             	sub    $0x4,%esp
  8004a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004a7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8004aa:	0f b6 02             	movzbl (%edx),%eax
  8004ad:	3c 20                	cmp    $0x20,%al
  8004af:	74 04                	je     8004b5 <strtol+0x1a>
  8004b1:	3c 09                	cmp    $0x9,%al
  8004b3:	75 0e                	jne    8004c3 <strtol+0x28>
		s++;
  8004b5:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8004b8:	0f b6 02             	movzbl (%edx),%eax
  8004bb:	3c 20                	cmp    $0x20,%al
  8004bd:	74 f6                	je     8004b5 <strtol+0x1a>
  8004bf:	3c 09                	cmp    $0x9,%al
  8004c1:	74 f2                	je     8004b5 <strtol+0x1a>
		s++;

	// plus/minus sign
	if (*s == '+')
  8004c3:	3c 2b                	cmp    $0x2b,%al
  8004c5:	75 0c                	jne    8004d3 <strtol+0x38>
		s++;
  8004c7:	83 c2 01             	add    $0x1,%edx
  8004ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004d1:	eb 15                	jmp    8004e8 <strtol+0x4d>
	else if (*s == '-')
  8004d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8004da:	3c 2d                	cmp    $0x2d,%al
  8004dc:	75 0a                	jne    8004e8 <strtol+0x4d>
		s++, neg = 1;
  8004de:	83 c2 01             	add    $0x1,%edx
  8004e1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8004e8:	85 db                	test   %ebx,%ebx
  8004ea:	0f 94 c0             	sete   %al
  8004ed:	74 05                	je     8004f4 <strtol+0x59>
  8004ef:	83 fb 10             	cmp    $0x10,%ebx
  8004f2:	75 18                	jne    80050c <strtol+0x71>
  8004f4:	80 3a 30             	cmpb   $0x30,(%edx)
  8004f7:	75 13                	jne    80050c <strtol+0x71>
  8004f9:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
  8004fd:	8d 76 00             	lea    0x0(%esi),%esi
  800500:	75 0a                	jne    80050c <strtol+0x71>
		s += 2, base = 16;
  800502:	83 c2 02             	add    $0x2,%edx
  800505:	bb 10 00 00 00       	mov    $0x10,%ebx
		s++;
	else if (*s == '-')
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80050a:	eb 15                	jmp    800521 <strtol+0x86>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  80050c:	84 c0                	test   %al,%al
  80050e:	66 90                	xchg   %ax,%ax
  800510:	74 0f                	je     800521 <strtol+0x86>
  800512:	bb 0a 00 00 00       	mov    $0xa,%ebx
  800517:	80 3a 30             	cmpb   $0x30,(%edx)
  80051a:	75 05                	jne    800521 <strtol+0x86>
		s++, base = 8;
  80051c:	83 c2 01             	add    $0x1,%edx
  80051f:	b3 08                	mov    $0x8,%bl
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800521:	b8 00 00 00 00       	mov    $0x0,%eax
  800526:	89 de                	mov    %ebx,%esi

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800528:	0f b6 0a             	movzbl (%edx),%ecx
  80052b:	89 cf                	mov    %ecx,%edi
  80052d:	8d 59 d0             	lea    -0x30(%ecx),%ebx
  800530:	80 fb 09             	cmp    $0x9,%bl
  800533:	77 08                	ja     80053d <strtol+0xa2>
			dig = *s - '0';
  800535:	0f be c9             	movsbl %cl,%ecx
  800538:	83 e9 30             	sub    $0x30,%ecx
  80053b:	eb 1e                	jmp    80055b <strtol+0xc0>
		else if (*s >= 'a' && *s <= 'z')
  80053d:	8d 5f 9f             	lea    -0x61(%edi),%ebx
  800540:	80 fb 19             	cmp    $0x19,%bl
  800543:	77 08                	ja     80054d <strtol+0xb2>
			dig = *s - 'a' + 10;
  800545:	0f be c9             	movsbl %cl,%ecx
  800548:	83 e9 57             	sub    $0x57,%ecx
  80054b:	eb 0e                	jmp    80055b <strtol+0xc0>
		else if (*s >= 'A' && *s <= 'Z')
  80054d:	8d 5f bf             	lea    -0x41(%edi),%ebx
  800550:	80 fb 19             	cmp    $0x19,%bl
  800553:	77 15                	ja     80056a <strtol+0xcf>
			dig = *s - 'A' + 10;
  800555:	0f be c9             	movsbl %cl,%ecx
  800558:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
  80055b:	39 f1                	cmp    %esi,%ecx
  80055d:	7d 0b                	jge    80056a <strtol+0xcf>
			break;
		s++, val = (val * base) + dig;
  80055f:	83 c2 01             	add    $0x1,%edx
  800562:	0f af c6             	imul   %esi,%eax
  800565:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
  800568:	eb be                	jmp    800528 <strtol+0x8d>
  80056a:	89 c1                	mov    %eax,%ecx

	if (endptr)
  80056c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800570:	74 05                	je     800577 <strtol+0xdc>
		*endptr = (char *) s;
  800572:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800575:	89 13                	mov    %edx,(%ebx)
	return (neg ? -val : val);
  800577:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80057b:	74 04                	je     800581 <strtol+0xe6>
  80057d:	89 c8                	mov    %ecx,%eax
  80057f:	f7 d8                	neg    %eax
}
  800581:	83 c4 04             	add    $0x4,%esp
  800584:	5b                   	pop    %ebx
  800585:	5e                   	pop    %esi
  800586:	5f                   	pop    %edi
  800587:	5d                   	pop    %ebp
  800588:	c3                   	ret    
  800589:	00 00                	add    %al,(%eax)
	...

0080058c <sys_cgetc>:
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}

int
sys_cgetc(void)
{
  80058c:	55                   	push   %ebp
  80058d:	89 e5                	mov    %esp,%ebp
  80058f:	83 ec 0c             	sub    $0xc,%esp
  800592:	89 1c 24             	mov    %ebx,(%esp)
  800595:	89 74 24 04          	mov    %esi,0x4(%esp)
  800599:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80059d:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8005a7:	89 d1                	mov    %edx,%ecx
  8005a9:	89 d3                	mov    %edx,%ebx
  8005ab:	89 d7                	mov    %edx,%edi
  8005ad:	89 d6                	mov    %edx,%esi
  8005af:	cd 30                	int    $0x30

int
sys_cgetc(void)
{
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8005b1:	8b 1c 24             	mov    (%esp),%ebx
  8005b4:	8b 74 24 04          	mov    0x4(%esp),%esi
  8005b8:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8005bc:	89 ec                	mov    %ebp,%esp
  8005be:	5d                   	pop    %ebp
  8005bf:	c3                   	ret    

008005c0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8005c0:	55                   	push   %ebp
  8005c1:	89 e5                	mov    %esp,%ebp
  8005c3:	83 ec 0c             	sub    $0xc,%esp
  8005c6:	89 1c 24             	mov    %ebx,(%esp)
  8005c9:	89 74 24 04          	mov    %esi,0x4(%esp)
  8005cd:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8005d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8005d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8005dc:	89 c3                	mov    %eax,%ebx
  8005de:	89 c7                	mov    %eax,%edi
  8005e0:	89 c6                	mov    %eax,%esi
  8005e2:	cd 30                	int    $0x30

void
sys_cputs(const char *s, size_t len)
{
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8005e4:	8b 1c 24             	mov    (%esp),%ebx
  8005e7:	8b 74 24 04          	mov    0x4(%esp),%esi
  8005eb:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8005ef:	89 ec                	mov    %ebp,%esp
  8005f1:	5d                   	pop    %ebp
  8005f2:	c3                   	ret    

008005f3 <sys_call_receive_packet>:
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}

int sys_call_receive_packet(void *va, void *len)
{
  8005f3:	55                   	push   %ebp
  8005f4:	89 e5                	mov    %esp,%ebp
  8005f6:	83 ec 0c             	sub    $0xc,%esp
  8005f9:	89 1c 24             	mov    %ebx,(%esp)
  8005fc:	89 74 24 04          	mov    %esi,0x4(%esp)
  800600:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800604:	bb 00 00 00 00       	mov    $0x0,%ebx
  800609:	b8 10 00 00 00       	mov    $0x10,%eax
  80060e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800611:	8b 55 08             	mov    0x8(%ebp),%edx
  800614:	89 df                	mov    %ebx,%edi
  800616:	89 de                	mov    %ebx,%esi
  800618:	cd 30                	int    $0x30
}

int sys_call_receive_packet(void *va, void *len)
{
   return syscall(SYS_call_receive_packet,0,(uint32_t)va,(uint32_t)len,0,0,0);
}
  80061a:	8b 1c 24             	mov    (%esp),%ebx
  80061d:	8b 74 24 04          	mov    0x4(%esp),%esi
  800621:	8b 7c 24 08          	mov    0x8(%esp),%edi
  800625:	89 ec                	mov    %ebp,%esp
  800627:	5d                   	pop    %ebp
  800628:	c3                   	ret    

00800629 <sys_call_packet_send>:
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}

int sys_call_packet_send(void *va, size_t len)
{
  800629:	55                   	push   %ebp
  80062a:	89 e5                	mov    %esp,%ebp
  80062c:	83 ec 38             	sub    $0x38,%esp
  80062f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800632:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800635:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800638:	bb 00 00 00 00       	mov    $0x0,%ebx
  80063d:	b8 0f 00 00 00       	mov    $0xf,%eax
  800642:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800645:	8b 55 08             	mov    0x8(%ebp),%edx
  800648:	89 df                	mov    %ebx,%edi
  80064a:	89 de                	mov    %ebx,%esi
  80064c:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80064e:	85 c0                	test   %eax,%eax
  800650:	7e 28                	jle    80067a <sys_call_packet_send+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800652:	89 44 24 10          	mov    %eax,0x10(%esp)
  800656:	c7 44 24 0c 0f 00 00 	movl   $0xf,0xc(%esp)
  80065d:	00 
  80065e:	c7 44 24 08 da 28 80 	movl   $0x8028da,0x8(%esp)
  800665:	00 
  800666:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80066d:	00 
  80066e:	c7 04 24 f7 28 80 00 	movl   $0x8028f7,(%esp)
  800675:	e8 72 17 00 00       	call   801dec <_panic>
}

int sys_call_packet_send(void *va, size_t len)
{
   return syscall(SYS_call_packet_send,1,(uint32_t)va,(uint32_t)len,0,0,0);
}
  80067a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80067d:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800680:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800683:	89 ec                	mov    %ebp,%esp
  800685:	5d                   	pop    %ebp
  800686:	c3                   	ret    

00800687 <sys_time_msec>:
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}

unsigned int
sys_time_msec(void)
{
  800687:	55                   	push   %ebp
  800688:	89 e5                	mov    %esp,%ebp
  80068a:	83 ec 0c             	sub    $0xc,%esp
  80068d:	89 1c 24             	mov    %ebx,(%esp)
  800690:	89 74 24 04          	mov    %esi,0x4(%esp)
  800694:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800698:	ba 00 00 00 00       	mov    $0x0,%edx
  80069d:	b8 0e 00 00 00       	mov    $0xe,%eax
  8006a2:	89 d1                	mov    %edx,%ecx
  8006a4:	89 d3                	mov    %edx,%ebx
  8006a6:	89 d7                	mov    %edx,%edi
  8006a8:	89 d6                	mov    %edx,%esi
  8006aa:	cd 30                	int    $0x30

unsigned int
sys_time_msec(void)
{
	return (unsigned int) syscall(SYS_time_msec, 0, 0, 0, 0, 0, 0);
}
  8006ac:	8b 1c 24             	mov    (%esp),%ebx
  8006af:	8b 74 24 04          	mov    0x4(%esp),%esi
  8006b3:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8006b7:	89 ec                	mov    %ebp,%esp
  8006b9:	5d                   	pop    %ebp
  8006ba:	c3                   	ret    

008006bb <sys_ipc_recv>:
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}

int
sys_ipc_recv(void *dstva)
{
  8006bb:	55                   	push   %ebp
  8006bc:	89 e5                	mov    %esp,%ebp
  8006be:	83 ec 38             	sub    $0x38,%esp
  8006c1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8006c4:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8006c7:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8006ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006cf:	b8 0d 00 00 00       	mov    $0xd,%eax
  8006d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8006d7:	89 cb                	mov    %ecx,%ebx
  8006d9:	89 cf                	mov    %ecx,%edi
  8006db:	89 ce                	mov    %ecx,%esi
  8006dd:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8006df:	85 c0                	test   %eax,%eax
  8006e1:	7e 28                	jle    80070b <sys_ipc_recv+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  8006e3:	89 44 24 10          	mov    %eax,0x10(%esp)
  8006e7:	c7 44 24 0c 0d 00 00 	movl   $0xd,0xc(%esp)
  8006ee:	00 
  8006ef:	c7 44 24 08 da 28 80 	movl   $0x8028da,0x8(%esp)
  8006f6:	00 
  8006f7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8006fe:	00 
  8006ff:	c7 04 24 f7 28 80 00 	movl   $0x8028f7,(%esp)
  800706:	e8 e1 16 00 00       	call   801dec <_panic>

int
sys_ipc_recv(void *dstva)
{
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80070b:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80070e:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800711:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800714:	89 ec                	mov    %ebp,%esp
  800716:	5d                   	pop    %ebp
  800717:	c3                   	ret    

00800718 <sys_ipc_try_send>:
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
  80071b:	83 ec 0c             	sub    $0xc,%esp
  80071e:	89 1c 24             	mov    %ebx,(%esp)
  800721:	89 74 24 04          	mov    %esi,0x4(%esp)
  800725:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800729:	be 00 00 00 00       	mov    $0x0,%esi
  80072e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800733:	8b 7d 14             	mov    0x14(%ebp),%edi
  800736:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800739:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80073c:	8b 55 08             	mov    0x8(%ebp),%edx
  80073f:	cd 30                	int    $0x30

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800741:	8b 1c 24             	mov    (%esp),%ebx
  800744:	8b 74 24 04          	mov    0x4(%esp),%esi
  800748:	8b 7c 24 08          	mov    0x8(%esp),%edi
  80074c:	89 ec                	mov    %ebp,%esp
  80074e:	5d                   	pop    %ebp
  80074f:	c3                   	ret    

00800750 <sys_env_set_pgfault_upcall>:
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	83 ec 38             	sub    $0x38,%esp
  800756:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800759:	89 75 f8             	mov    %esi,-0x8(%ebp)
  80075c:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80075f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800764:	b8 0a 00 00 00       	mov    $0xa,%eax
  800769:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80076c:	8b 55 08             	mov    0x8(%ebp),%edx
  80076f:	89 df                	mov    %ebx,%edi
  800771:	89 de                	mov    %ebx,%esi
  800773:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800775:	85 c0                	test   %eax,%eax
  800777:	7e 28                	jle    8007a1 <sys_env_set_pgfault_upcall+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800779:	89 44 24 10          	mov    %eax,0x10(%esp)
  80077d:	c7 44 24 0c 0a 00 00 	movl   $0xa,0xc(%esp)
  800784:	00 
  800785:	c7 44 24 08 da 28 80 	movl   $0x8028da,0x8(%esp)
  80078c:	00 
  80078d:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800794:	00 
  800795:	c7 04 24 f7 28 80 00 	movl   $0x8028f7,(%esp)
  80079c:	e8 4b 16 00 00       	call   801dec <_panic>

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8007a1:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8007a4:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8007a7:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8007aa:	89 ec                	mov    %ebp,%esp
  8007ac:	5d                   	pop    %ebp
  8007ad:	c3                   	ret    

008007ae <sys_env_set_trapframe>:
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8007ae:	55                   	push   %ebp
  8007af:	89 e5                	mov    %esp,%ebp
  8007b1:	83 ec 38             	sub    $0x38,%esp
  8007b4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8007b7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8007ba:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8007bd:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007c2:	b8 09 00 00 00       	mov    $0x9,%eax
  8007c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8007cd:	89 df                	mov    %ebx,%edi
  8007cf:	89 de                	mov    %ebx,%esi
  8007d1:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8007d3:	85 c0                	test   %eax,%eax
  8007d5:	7e 28                	jle    8007ff <sys_env_set_trapframe+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8007d7:	89 44 24 10          	mov    %eax,0x10(%esp)
  8007db:	c7 44 24 0c 09 00 00 	movl   $0x9,0xc(%esp)
  8007e2:	00 
  8007e3:	c7 44 24 08 da 28 80 	movl   $0x8028da,0x8(%esp)
  8007ea:	00 
  8007eb:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8007f2:	00 
  8007f3:	c7 04 24 f7 28 80 00 	movl   $0x8028f7,(%esp)
  8007fa:	e8 ed 15 00 00       	call   801dec <_panic>

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8007ff:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800802:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800805:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800808:	89 ec                	mov    %ebp,%esp
  80080a:	5d                   	pop    %ebp
  80080b:	c3                   	ret    

0080080c <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80080c:	55                   	push   %ebp
  80080d:	89 e5                	mov    %esp,%ebp
  80080f:	83 ec 38             	sub    $0x38,%esp
  800812:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800815:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800818:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80081b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800820:	b8 08 00 00 00       	mov    $0x8,%eax
  800825:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800828:	8b 55 08             	mov    0x8(%ebp),%edx
  80082b:	89 df                	mov    %ebx,%edi
  80082d:	89 de                	mov    %ebx,%esi
  80082f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800831:	85 c0                	test   %eax,%eax
  800833:	7e 28                	jle    80085d <sys_env_set_status+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800835:	89 44 24 10          	mov    %eax,0x10(%esp)
  800839:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
  800840:	00 
  800841:	c7 44 24 08 da 28 80 	movl   $0x8028da,0x8(%esp)
  800848:	00 
  800849:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800850:	00 
  800851:	c7 04 24 f7 28 80 00 	movl   $0x8028f7,(%esp)
  800858:	e8 8f 15 00 00       	call   801dec <_panic>

int
sys_env_set_status(envid_t envid, int status)
{
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80085d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800860:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800863:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800866:	89 ec                	mov    %ebp,%esp
  800868:	5d                   	pop    %ebp
  800869:	c3                   	ret    

0080086a <sys_page_unmap>:
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}

int
sys_page_unmap(envid_t envid, void *va)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	83 ec 38             	sub    $0x38,%esp
  800870:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800873:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800876:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800879:	bb 00 00 00 00       	mov    $0x0,%ebx
  80087e:	b8 06 00 00 00       	mov    $0x6,%eax
  800883:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800886:	8b 55 08             	mov    0x8(%ebp),%edx
  800889:	89 df                	mov    %ebx,%edi
  80088b:	89 de                	mov    %ebx,%esi
  80088d:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80088f:	85 c0                	test   %eax,%eax
  800891:	7e 28                	jle    8008bb <sys_page_unmap+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  800893:	89 44 24 10          	mov    %eax,0x10(%esp)
  800897:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  80089e:	00 
  80089f:	c7 44 24 08 da 28 80 	movl   $0x8028da,0x8(%esp)
  8008a6:	00 
  8008a7:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  8008ae:	00 
  8008af:	c7 04 24 f7 28 80 00 	movl   $0x8028f7,(%esp)
  8008b6:	e8 31 15 00 00       	call   801dec <_panic>

int
sys_page_unmap(envid_t envid, void *va)
{
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8008bb:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  8008be:	8b 75 f8             	mov    -0x8(%ebp),%esi
  8008c1:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8008c4:	89 ec                	mov    %ebp,%esp
  8008c6:	5d                   	pop    %ebp
  8008c7:	c3                   	ret    

008008c8 <sys_page_map>:
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8008c8:	55                   	push   %ebp
  8008c9:	89 e5                	mov    %esp,%ebp
  8008cb:	83 ec 38             	sub    $0x38,%esp
  8008ce:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8008d1:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8008d4:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8008d7:	b8 05 00 00 00       	mov    $0x5,%eax
  8008dc:	8b 75 18             	mov    0x18(%ebp),%esi
  8008df:	8b 7d 14             	mov    0x14(%ebp),%edi
  8008e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8008e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8008eb:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  8008ed:	85 c0                	test   %eax,%eax
  8008ef:	7e 28                	jle    800919 <sys_page_map+0x51>
		panic("syscall %d returned %d (> 0)", num, ret);
  8008f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  8008f5:	c7 44 24 0c 05 00 00 	movl   $0x5,0xc(%esp)
  8008fc:	00 
  8008fd:	c7 44 24 08 da 28 80 	movl   $0x8028da,0x8(%esp)
  800904:	00 
  800905:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80090c:	00 
  80090d:	c7 04 24 f7 28 80 00 	movl   $0x8028f7,(%esp)
  800914:	e8 d3 14 00 00       	call   801dec <_panic>

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800919:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80091c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80091f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800922:	89 ec                	mov    %ebp,%esp
  800924:	5d                   	pop    %ebp
  800925:	c3                   	ret    

00800926 <sys_page_alloc>:
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800926:	55                   	push   %ebp
  800927:	89 e5                	mov    %esp,%ebp
  800929:	83 ec 38             	sub    $0x38,%esp
  80092c:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  80092f:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800932:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800935:	be 00 00 00 00       	mov    $0x0,%esi
  80093a:	b8 04 00 00 00       	mov    $0x4,%eax
  80093f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800942:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800945:	8b 55 08             	mov    0x8(%ebp),%edx
  800948:	89 f7                	mov    %esi,%edi
  80094a:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  80094c:	85 c0                	test   %eax,%eax
  80094e:	7e 28                	jle    800978 <sys_page_alloc+0x52>
		panic("syscall %d returned %d (> 0)", num, ret);
  800950:	89 44 24 10          	mov    %eax,0x10(%esp)
  800954:	c7 44 24 0c 04 00 00 	movl   $0x4,0xc(%esp)
  80095b:	00 
  80095c:	c7 44 24 08 da 28 80 	movl   $0x8028da,0x8(%esp)
  800963:	00 
  800964:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  80096b:	00 
  80096c:	c7 04 24 f7 28 80 00 	movl   $0x8028f7,(%esp)
  800973:	e8 74 14 00 00       	call   801dec <_panic>

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800978:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  80097b:	8b 75 f8             	mov    -0x8(%ebp),%esi
  80097e:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800981:	89 ec                	mov    %ebp,%esp
  800983:	5d                   	pop    %ebp
  800984:	c3                   	ret    

00800985 <sys_yield>:
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}

void
sys_yield(void)
{
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	83 ec 0c             	sub    $0xc,%esp
  80098b:	89 1c 24             	mov    %ebx,(%esp)
  80098e:	89 74 24 04          	mov    %esi,0x4(%esp)
  800992:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  800996:	ba 00 00 00 00       	mov    $0x0,%edx
  80099b:	b8 0b 00 00 00       	mov    $0xb,%eax
  8009a0:	89 d1                	mov    %edx,%ecx
  8009a2:	89 d3                	mov    %edx,%ebx
  8009a4:	89 d7                	mov    %edx,%edi
  8009a6:	89 d6                	mov    %edx,%esi
  8009a8:	cd 30                	int    $0x30

void
sys_yield(void)
{
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8009aa:	8b 1c 24             	mov    (%esp),%ebx
  8009ad:	8b 74 24 04          	mov    0x4(%esp),%esi
  8009b1:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8009b5:	89 ec                	mov    %ebp,%esp
  8009b7:	5d                   	pop    %ebp
  8009b8:	c3                   	ret    

008009b9 <sys_getenvid>:
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}

envid_t
sys_getenvid(void)
{
  8009b9:	55                   	push   %ebp
  8009ba:	89 e5                	mov    %esp,%ebp
  8009bc:	83 ec 0c             	sub    $0xc,%esp
  8009bf:	89 1c 24             	mov    %ebx,(%esp)
  8009c2:	89 74 24 04          	mov    %esi,0x4(%esp)
  8009c6:	89 7c 24 08          	mov    %edi,0x8(%esp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8009ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8009cf:	b8 02 00 00 00       	mov    $0x2,%eax
  8009d4:	89 d1                	mov    %edx,%ecx
  8009d6:	89 d3                	mov    %edx,%ebx
  8009d8:	89 d7                	mov    %edx,%edi
  8009da:	89 d6                	mov    %edx,%esi
  8009dc:	cd 30                	int    $0x30

envid_t
sys_getenvid(void)
{
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8009de:	8b 1c 24             	mov    (%esp),%ebx
  8009e1:	8b 74 24 04          	mov    0x4(%esp),%esi
  8009e5:	8b 7c 24 08          	mov    0x8(%esp),%edi
  8009e9:	89 ec                	mov    %ebp,%esp
  8009eb:	5d                   	pop    %ebp
  8009ec:	c3                   	ret    

008009ed <sys_env_destroy>:
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}

int
sys_env_destroy(envid_t envid)
{
  8009ed:	55                   	push   %ebp
  8009ee:	89 e5                	mov    %esp,%ebp
  8009f0:	83 ec 38             	sub    $0x38,%esp
  8009f3:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8009f6:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8009f9:	89 7d fc             	mov    %edi,-0x4(%ebp)
	// 
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8009fc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a01:	b8 03 00 00 00       	mov    $0x3,%eax
  800a06:	8b 55 08             	mov    0x8(%ebp),%edx
  800a09:	89 cb                	mov    %ecx,%ebx
  800a0b:	89 cf                	mov    %ecx,%edi
  800a0d:	89 ce                	mov    %ecx,%esi
  800a0f:	cd 30                	int    $0x30
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");
	
	if(check && ret > 0)
  800a11:	85 c0                	test   %eax,%eax
  800a13:	7e 28                	jle    800a3d <sys_env_destroy+0x50>
		panic("syscall %d returned %d (> 0)", num, ret);
  800a15:	89 44 24 10          	mov    %eax,0x10(%esp)
  800a19:	c7 44 24 0c 03 00 00 	movl   $0x3,0xc(%esp)
  800a20:	00 
  800a21:	c7 44 24 08 da 28 80 	movl   $0x8028da,0x8(%esp)
  800a28:	00 
  800a29:	c7 44 24 04 23 00 00 	movl   $0x23,0x4(%esp)
  800a30:	00 
  800a31:	c7 04 24 f7 28 80 00 	movl   $0x8028f7,(%esp)
  800a38:	e8 af 13 00 00       	call   801dec <_panic>

int
sys_env_destroy(envid_t envid)
{
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800a3d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  800a40:	8b 75 f8             	mov    -0x8(%ebp),%esi
  800a43:	8b 7d fc             	mov    -0x4(%ebp),%edi
  800a46:	89 ec                	mov    %ebp,%esp
  800a48:	5d                   	pop    %ebp
  800a49:	c3                   	ret    
  800a4a:	00 00                	add    %al,(%eax)
  800a4c:	00 00                	add    %al,(%eax)
	...

00800a50 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800a50:	55                   	push   %ebp
  800a51:	89 e5                	mov    %esp,%ebp
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	05 00 00 00 30       	add    $0x30000000,%eax
  800a5b:	c1 e8 0c             	shr    $0xc,%eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
}
  800a5e:	5d                   	pop    %ebp
  800a5f:	c3                   	ret    

00800a60 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800a60:	55                   	push   %ebp
  800a61:	89 e5                	mov    %esp,%ebp
  800a63:	83 ec 04             	sub    $0x4,%esp
	return INDEX2DATA(fd2num(fd));
  800a66:	8b 45 08             	mov    0x8(%ebp),%eax
  800a69:	89 04 24             	mov    %eax,(%esp)
  800a6c:	e8 df ff ff ff       	call   800a50 <fd2num>
  800a71:	05 20 00 0d 00       	add    $0xd0020,%eax
  800a76:	c1 e0 0c             	shl    $0xc,%eax
}
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	57                   	push   %edi
  800a7f:	56                   	push   %esi
  800a80:	53                   	push   %ebx
  800a81:	8b 7d 08             	mov    0x8(%ebp),%edi
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
  800a84:	a1 00 dd 7b ef       	mov    0xef7bdd00,%eax
  800a89:	a8 01                	test   $0x1,%al
  800a8b:	74 36                	je     800ac3 <fd_alloc+0x48>
  800a8d:	a1 00 00 74 ef       	mov    0xef740000,%eax
  800a92:	a8 01                	test   $0x1,%al
  800a94:	74 2d                	je     800ac3 <fd_alloc+0x48>
  800a96:	b8 00 10 00 d0       	mov    $0xd0001000,%eax
  800a9b:	b9 00 d0 7b ef       	mov    $0xef7bd000,%ecx
  800aa0:	be 00 00 40 ef       	mov    $0xef400000,%esi
  800aa5:	89 c3                	mov    %eax,%ebx
  800aa7:	89 c2                	mov    %eax,%edx
  800aa9:	c1 ea 16             	shr    $0x16,%edx
  800aac:	8b 14 91             	mov    (%ecx,%edx,4),%edx
  800aaf:	f6 c2 01             	test   $0x1,%dl
  800ab2:	74 14                	je     800ac8 <fd_alloc+0x4d>
  800ab4:	89 c2                	mov    %eax,%edx
  800ab6:	c1 ea 0c             	shr    $0xc,%edx
  800ab9:	8b 14 96             	mov    (%esi,%edx,4),%edx
  800abc:	f6 c2 01             	test   $0x1,%dl
  800abf:	75 10                	jne    800ad1 <fd_alloc+0x56>
  800ac1:	eb 05                	jmp    800ac8 <fd_alloc+0x4d>
  800ac3:	bb 00 00 00 d0       	mov    $0xd0000000,%ebx
			*fd_store = fd;
  800ac8:	89 1f                	mov    %ebx,(%edi)
  800aca:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  800acf:	eb 17                	jmp    800ae8 <fd_alloc+0x6d>
  800ad1:	05 00 10 00 00       	add    $0x1000,%eax
fd_alloc(struct Fd **fd_store)
{
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
  800ad6:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800adb:	75 c8                	jne    800aa5 <fd_alloc+0x2a>
		if ((vpd[PDX(fd)] & PTE_P) == 0 || (vpt[VPN(fd)] & PTE_P) == 0) {
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800add:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  800ae3:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
	return -E_MAX_OPEN;
}
  800ae8:	5b                   	pop    %ebx
  800ae9:	5e                   	pop    %esi
  800aea:	5f                   	pop    %edi
  800aeb:	5d                   	pop    %ebp
  800aec:	c3                   	ret    

00800aed <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800af0:	8b 45 08             	mov    0x8(%ebp),%eax
  800af3:	83 f8 1f             	cmp    $0x1f,%eax
  800af6:	77 36                	ja     800b2e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] bad fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800af8:	05 00 00 0d 00       	add    $0xd0000,%eax
  800afd:	c1 e0 0c             	shl    $0xc,%eax
	if (!(vpd[PDX(fd)] & PTE_P) || !(vpt[VPN(fd)] & PTE_P)) {
  800b00:	89 c2                	mov    %eax,%edx
  800b02:	c1 ea 16             	shr    $0x16,%edx
  800b05:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800b0c:	f6 c2 01             	test   $0x1,%dl
  800b0f:	74 1d                	je     800b2e <fd_lookup+0x41>
  800b11:	89 c2                	mov    %eax,%edx
  800b13:	c1 ea 0c             	shr    $0xc,%edx
  800b16:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800b1d:	f6 c2 01             	test   $0x1,%dl
  800b20:	74 0c                	je     800b2e <fd_lookup+0x41>
		if (debug)
			cprintf("[%08x] closed fd %d\n", env->env_id, fd);
		return -E_INVAL;
	}
	*fd_store = fd;
  800b22:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b25:	89 02                	mov    %eax,(%edx)
  800b27:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
  800b2c:	eb 05                	jmp    800b33 <fd_lookup+0x46>
  800b2e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800b33:	5d                   	pop    %ebp
  800b34:	c3                   	ret    

00800b35 <seek>:
	return (*dev->dev_write)(fd, buf, n);
}

int
seek(int fdnum, off_t offset)
{
  800b35:	55                   	push   %ebp
  800b36:	89 e5                	mov    %esp,%ebp
  800b38:	83 ec 18             	sub    $0x18,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800b3b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800b42:	8b 45 08             	mov    0x8(%ebp),%eax
  800b45:	89 04 24             	mov    %eax,(%esp)
  800b48:	e8 a0 ff ff ff       	call   800aed <fd_lookup>
  800b4d:	85 c0                	test   %eax,%eax
  800b4f:	78 0e                	js     800b5f <seek+0x2a>
		return r;
	fd->fd_offset = offset;
  800b51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b54:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b57:	89 50 04             	mov    %edx,0x4(%eax)
  800b5a:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  800b5f:	c9                   	leave  
  800b60:	c3                   	ret    

00800b61 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800b61:	55                   	push   %ebp
  800b62:	89 e5                	mov    %esp,%ebp
  800b64:	56                   	push   %esi
  800b65:	53                   	push   %ebx
  800b66:	83 ec 10             	sub    $0x10,%esp
  800b69:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b6c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
// File functions
// --------------------------------------------------------------

static struct Dev *devtab[] =
{
	&devfile,
  800b6f:	b8 04 60 80 00       	mov    $0x806004,%eax
{
	int i;
	for (i = 0; devtab[i]; i++)
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
  800b74:	ba 00 00 00 00       	mov    $0x0,%edx

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800b79:	be 84 29 80 00       	mov    $0x802984,%esi
		if (devtab[i]->dev_id == dev_id) {
  800b7e:	39 08                	cmp    %ecx,(%eax)
  800b80:	75 10                	jne    800b92 <dev_lookup+0x31>
  800b82:	eb 04                	jmp    800b88 <dev_lookup+0x27>
  800b84:	39 08                	cmp    %ecx,(%eax)
  800b86:	75 0a                	jne    800b92 <dev_lookup+0x31>
			*dev = devtab[i];
  800b88:	89 03                	mov    %eax,(%ebx)
  800b8a:	b8 00 00 00 00       	mov    $0x0,%eax
			return 0;
  800b8f:	90                   	nop
  800b90:	eb 31                	jmp    800bc3 <dev_lookup+0x62>

int
dev_lookup(int dev_id, struct Dev **dev)
{
	int i;
	for (i = 0; devtab[i]; i++)
  800b92:	83 c2 01             	add    $0x1,%edx
  800b95:	8b 04 96             	mov    (%esi,%edx,4),%eax
  800b98:	85 c0                	test   %eax,%eax
  800b9a:	75 e8                	jne    800b84 <dev_lookup+0x23>
		if (devtab[i]->dev_id == dev_id) {
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", env->env_id, dev_id);
  800b9c:	a1 74 60 80 00       	mov    0x806074,%eax
  800ba1:	8b 40 4c             	mov    0x4c(%eax),%eax
  800ba4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  800ba8:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bac:	c7 04 24 08 29 80 00 	movl   $0x802908,(%esp)
  800bb3:	e8 f9 12 00 00       	call   801eb1 <cprintf>
	*dev = 0;
  800bb8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800bbe:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
	return -E_INVAL;
}
  800bc3:	83 c4 10             	add    $0x10,%esp
  800bc6:	5b                   	pop    %ebx
  800bc7:	5e                   	pop    %esi
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <fstat>:
	return (*dev->dev_trunc)(fd, newsize);
}

int
fstat(int fdnum, struct Stat *stat)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	53                   	push   %ebx
  800bce:	83 ec 24             	sub    $0x24,%esp
  800bd1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bd4:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	89 04 24             	mov    %eax,(%esp)
  800be1:	e8 07 ff ff ff       	call   800aed <fd_lookup>
  800be6:	85 c0                	test   %eax,%eax
  800be8:	78 53                	js     800c3d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800bea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bed:	89 44 24 04          	mov    %eax,0x4(%esp)
  800bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bf4:	8b 00                	mov    (%eax),%eax
  800bf6:	89 04 24             	mov    %eax,(%esp)
  800bf9:	e8 63 ff ff ff       	call   800b61 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800bfe:	85 c0                	test   %eax,%eax
  800c00:	78 3b                	js     800c3d <fstat+0x73>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if (!dev->dev_stat)
  800c02:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800c07:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0a:	83 7a 14 00          	cmpl   $0x0,0x14(%edx)
  800c0e:	74 2d                	je     800c3d <fstat+0x73>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800c10:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800c13:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800c1a:	00 00 00 
	stat->st_isdir = 0;
  800c1d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800c24:	00 00 00 
	stat->st_dev = dev;
  800c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c2a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800c30:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800c34:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800c37:	89 14 24             	mov    %edx,(%esp)
  800c3a:	ff 50 14             	call   *0x14(%eax)
}
  800c3d:	83 c4 24             	add    $0x24,%esp
  800c40:	5b                   	pop    %ebx
  800c41:	5d                   	pop    %ebp
  800c42:	c3                   	ret    

00800c43 <ftruncate>:
	return 0;
}

int
ftruncate(int fdnum, off_t newsize)
{
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	53                   	push   %ebx
  800c47:	83 ec 24             	sub    $0x24,%esp
  800c4a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c4d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800c50:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c54:	89 1c 24             	mov    %ebx,(%esp)
  800c57:	e8 91 fe ff ff       	call   800aed <fd_lookup>
  800c5c:	85 c0                	test   %eax,%eax
  800c5e:	78 5f                	js     800cbf <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800c60:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800c63:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c6a:	8b 00                	mov    (%eax),%eax
  800c6c:	89 04 24             	mov    %eax,(%esp)
  800c6f:	e8 ed fe ff ff       	call   800b61 <dev_lookup>
ftruncate(int fdnum, off_t newsize)
{
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800c74:	85 c0                	test   %eax,%eax
  800c76:	78 47                	js     800cbf <ftruncate+0x7c>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800c78:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800c7b:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  800c7f:	75 23                	jne    800ca4 <ftruncate+0x61>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			env->env_id, fdnum); 
  800c81:	a1 74 60 80 00       	mov    0x806074,%eax
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  800c86:	8b 40 4c             	mov    0x4c(%eax),%eax
  800c89:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800c8d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c91:	c7 04 24 28 29 80 00 	movl   $0x802928,(%esp)
  800c98:	e8 14 12 00 00       	call   801eb1 <cprintf>
  800c9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
			env->env_id, fdnum); 
		return -E_INVAL;
  800ca2:	eb 1b                	jmp    800cbf <ftruncate+0x7c>
	}
	if (!dev->dev_trunc)
  800ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ca7:	8b 48 18             	mov    0x18(%eax),%ecx
  800caa:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800caf:	85 c9                	test   %ecx,%ecx
  800cb1:	74 0c                	je     800cbf <ftruncate+0x7c>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cba:	89 14 24             	mov    %edx,(%esp)
  800cbd:	ff d1                	call   *%ecx
}
  800cbf:	83 c4 24             	add    $0x24,%esp
  800cc2:	5b                   	pop    %ebx
  800cc3:	5d                   	pop    %ebp
  800cc4:	c3                   	ret    

00800cc5 <write>:
	return tot;
}

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	53                   	push   %ebx
  800cc9:	83 ec 24             	sub    $0x24,%esp
  800ccc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800ccf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800cd2:	89 44 24 04          	mov    %eax,0x4(%esp)
  800cd6:	89 1c 24             	mov    %ebx,(%esp)
  800cd9:	e8 0f fe ff ff       	call   800aed <fd_lookup>
  800cde:	85 c0                	test   %eax,%eax
  800ce0:	78 66                	js     800d48 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800ce2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ce9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cec:	8b 00                	mov    (%eax),%eax
  800cee:	89 04 24             	mov    %eax,(%esp)
  800cf1:	e8 6b fe ff ff       	call   800b61 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	78 4e                	js     800d48 <write+0x83>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800cfa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800cfd:	f6 42 08 03          	testb  $0x3,0x8(%edx)
  800d01:	75 23                	jne    800d26 <write+0x61>
		cprintf("[%08x] write %d -- bad mode\n", env->env_id, fdnum);
  800d03:	a1 74 60 80 00       	mov    0x806074,%eax
  800d08:	8b 40 4c             	mov    0x4c(%eax),%eax
  800d0b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d13:	c7 04 24 49 29 80 00 	movl   $0x802949,(%esp)
  800d1a:	e8 92 11 00 00       	call   801eb1 <cprintf>
  800d1f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  800d24:	eb 22                	jmp    800d48 <write+0x83>
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  800d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d29:	8b 48 0c             	mov    0xc(%eax),%ecx
  800d2c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800d31:	85 c9                	test   %ecx,%ecx
  800d33:	74 13                	je     800d48 <write+0x83>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800d35:	8b 45 10             	mov    0x10(%ebp),%eax
  800d38:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d43:	89 14 24             	mov    %edx,(%esp)
  800d46:	ff d1                	call   *%ecx
}
  800d48:	83 c4 24             	add    $0x24,%esp
  800d4b:	5b                   	pop    %ebx
  800d4c:	5d                   	pop    %ebp
  800d4d:	c3                   	ret    

00800d4e <read>:
	return r;
}

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800d4e:	55                   	push   %ebp
  800d4f:	89 e5                	mov    %esp,%ebp
  800d51:	53                   	push   %ebx
  800d52:	83 ec 24             	sub    $0x24,%esp
  800d55:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d58:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d5f:	89 1c 24             	mov    %ebx,(%esp)
  800d62:	e8 86 fd ff ff       	call   800aed <fd_lookup>
  800d67:	85 c0                	test   %eax,%eax
  800d69:	78 6b                	js     800dd6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800d6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d6e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d75:	8b 00                	mov    (%eax),%eax
  800d77:	89 04 24             	mov    %eax,(%esp)
  800d7a:	e8 e2 fd ff ff       	call   800b61 <dev_lookup>
{
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800d7f:	85 c0                	test   %eax,%eax
  800d81:	78 53                	js     800dd6 <read+0x88>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800d83:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800d86:	8b 42 08             	mov    0x8(%edx),%eax
  800d89:	83 e0 03             	and    $0x3,%eax
  800d8c:	83 f8 01             	cmp    $0x1,%eax
  800d8f:	75 23                	jne    800db4 <read+0x66>
		cprintf("[%08x] read %d -- bad mode\n", env->env_id, fdnum); 
  800d91:	a1 74 60 80 00       	mov    0x806074,%eax
  800d96:	8b 40 4c             	mov    0x4c(%eax),%eax
  800d99:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  800d9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800da1:	c7 04 24 66 29 80 00 	movl   $0x802966,(%esp)
  800da8:	e8 04 11 00 00       	call   801eb1 <cprintf>
  800dad:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		return -E_INVAL;
  800db2:	eb 22                	jmp    800dd6 <read+0x88>
	}
	if (!dev->dev_read)
  800db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800db7:	8b 48 08             	mov    0x8(%eax),%ecx
  800dba:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800dbf:	85 c9                	test   %ecx,%ecx
  800dc1:	74 13                	je     800dd6 <read+0x88>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800dc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc6:	89 44 24 08          	mov    %eax,0x8(%esp)
  800dca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800dd1:	89 14 24             	mov    %edx,(%esp)
  800dd4:	ff d1                	call   *%ecx
}
  800dd6:	83 c4 24             	add    $0x24,%esp
  800dd9:	5b                   	pop    %ebx
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
  800ddf:	57                   	push   %edi
  800de0:	56                   	push   %esi
  800de1:	53                   	push   %ebx
  800de2:	83 ec 1c             	sub    $0x1c,%esp
  800de5:	8b 7d 08             	mov    0x8(%ebp),%edi
  800de8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800deb:	ba 00 00 00 00       	mov    $0x0,%edx
  800df0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df5:	b8 00 00 00 00       	mov    $0x0,%eax
  800dfa:	85 f6                	test   %esi,%esi
  800dfc:	74 29                	je     800e27 <readn+0x4b>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800dfe:	89 f0                	mov    %esi,%eax
  800e00:	29 d0                	sub    %edx,%eax
  800e02:	89 44 24 08          	mov    %eax,0x8(%esp)
  800e06:	03 55 0c             	add    0xc(%ebp),%edx
  800e09:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e0d:	89 3c 24             	mov    %edi,(%esp)
  800e10:	e8 39 ff ff ff       	call   800d4e <read>
		if (m < 0)
  800e15:	85 c0                	test   %eax,%eax
  800e17:	78 0e                	js     800e27 <readn+0x4b>
			return m;
		if (m == 0)
  800e19:	85 c0                	test   %eax,%eax
  800e1b:	74 08                	je     800e25 <readn+0x49>
ssize_t
readn(int fdnum, void *buf, size_t n)
{
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800e1d:	01 c3                	add    %eax,%ebx
  800e1f:	89 da                	mov    %ebx,%edx
  800e21:	39 f3                	cmp    %esi,%ebx
  800e23:	72 d9                	jb     800dfe <readn+0x22>
  800e25:	89 d8                	mov    %ebx,%eax
			return m;
		if (m == 0)
			break;
	}
	return tot;
}
  800e27:	83 c4 1c             	add    $0x1c,%esp
  800e2a:	5b                   	pop    %ebx
  800e2b:	5e                   	pop    %esi
  800e2c:	5f                   	pop    %edi
  800e2d:	5d                   	pop    %ebp
  800e2e:	c3                   	ret    

00800e2f <fd_close>:
// If 'must_exist' is 1, then fd_close returns -E_INVAL when passed a
// closed or nonexistent file descriptor.
// Returns 0 on success, < 0 on error.
int
fd_close(struct Fd *fd, bool must_exist)
{
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	56                   	push   %esi
  800e33:	53                   	push   %ebx
  800e34:	83 ec 20             	sub    $0x20,%esp
  800e37:	8b 75 08             	mov    0x8(%ebp),%esi
	struct Fd *fd2;
	struct Dev *dev;
	int r;
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800e3a:	89 34 24             	mov    %esi,(%esp)
  800e3d:	e8 0e fc ff ff       	call   800a50 <fd2num>
  800e42:	8d 55 f4             	lea    -0xc(%ebp),%edx
  800e45:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e49:	89 04 24             	mov    %eax,(%esp)
  800e4c:	e8 9c fc ff ff       	call   800aed <fd_lookup>
  800e51:	89 c3                	mov    %eax,%ebx
  800e53:	85 c0                	test   %eax,%eax
  800e55:	78 05                	js     800e5c <fd_close+0x2d>
  800e57:	3b 75 f4             	cmp    -0xc(%ebp),%esi
  800e5a:	74 0c                	je     800e68 <fd_close+0x39>
	    || fd != fd2)
		return (must_exist ? r : 0);
  800e5c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e60:	19 c0                	sbb    %eax,%eax
  800e62:	f7 d0                	not    %eax
  800e64:	21 c3                	and    %eax,%ebx
  800e66:	eb 3d                	jmp    800ea5 <fd_close+0x76>
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800e68:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e6b:	89 44 24 04          	mov    %eax,0x4(%esp)
  800e6f:	8b 06                	mov    (%esi),%eax
  800e71:	89 04 24             	mov    %eax,(%esp)
  800e74:	e8 e8 fc ff ff       	call   800b61 <dev_lookup>
  800e79:	89 c3                	mov    %eax,%ebx
  800e7b:	85 c0                	test   %eax,%eax
  800e7d:	78 16                	js     800e95 <fd_close+0x66>
		if (dev->dev_close)
  800e7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e82:	8b 40 10             	mov    0x10(%eax),%eax
  800e85:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e8a:	85 c0                	test   %eax,%eax
  800e8c:	74 07                	je     800e95 <fd_close+0x66>
			r = (*dev->dev_close)(fd);
  800e8e:	89 34 24             	mov    %esi,(%esp)
  800e91:	ff d0                	call   *%eax
  800e93:	89 c3                	mov    %eax,%ebx
		else
			r = 0;
	}
	// Make sure fd is unmapped.  Might be a no-op if
	// (*dev->dev_close)(fd) already unmapped it.
	(void) sys_page_unmap(0, fd);
  800e95:	89 74 24 04          	mov    %esi,0x4(%esp)
  800e99:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800ea0:	e8 c5 f9 ff ff       	call   80086a <sys_page_unmap>
	return r;
}
  800ea5:	89 d8                	mov    %ebx,%eax
  800ea7:	83 c4 20             	add    $0x20,%esp
  800eaa:	5b                   	pop    %ebx
  800eab:	5e                   	pop    %esi
  800eac:	5d                   	pop    %ebp
  800ead:	c3                   	ret    

00800eae <close>:
	return -E_INVAL;
}

int
close(int fdnum)
{
  800eae:	55                   	push   %ebp
  800eaf:	89 e5                	mov    %esp,%ebp
  800eb1:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800eb4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800eb7:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	89 04 24             	mov    %eax,(%esp)
  800ec1:	e8 27 fc ff ff       	call   800aed <fd_lookup>
  800ec6:	85 c0                	test   %eax,%eax
  800ec8:	78 13                	js     800edd <close+0x2f>
		return r;
	else
		return fd_close(fd, 1);
  800eca:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  800ed1:	00 
  800ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed5:	89 04 24             	mov    %eax,(%esp)
  800ed8:	e8 52 ff ff ff       	call   800e2f <fd_close>
}
  800edd:	c9                   	leave  
  800ede:	c3                   	ret    

00800edf <stat>:
	return (*dev->dev_stat)(fd, stat);
}

int
stat(const char *path, struct Stat *stat)
{
  800edf:	55                   	push   %ebp
  800ee0:	89 e5                	mov    %esp,%ebp
  800ee2:	83 ec 18             	sub    $0x18,%esp
  800ee5:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  800ee8:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800eeb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800ef2:	00 
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	89 04 24             	mov    %eax,(%esp)
  800ef9:	e8 a9 03 00 00       	call   8012a7 <open>
  800efe:	89 c3                	mov    %eax,%ebx
  800f00:	85 c0                	test   %eax,%eax
  800f02:	78 1b                	js     800f1f <stat+0x40>
		return fd;
	r = fstat(fd, stat);
  800f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f07:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f0b:	89 1c 24             	mov    %ebx,(%esp)
  800f0e:	e8 b7 fc ff ff       	call   800bca <fstat>
  800f13:	89 c6                	mov    %eax,%esi
	close(fd);
  800f15:	89 1c 24             	mov    %ebx,(%esp)
  800f18:	e8 91 ff ff ff       	call   800eae <close>
  800f1d:	89 f3                	mov    %esi,%ebx
	return r;
}
  800f1f:	89 d8                	mov    %ebx,%eax
  800f21:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  800f24:	8b 75 fc             	mov    -0x4(%ebp),%esi
  800f27:	89 ec                	mov    %ebp,%esp
  800f29:	5d                   	pop    %ebp
  800f2a:	c3                   	ret    

00800f2b <close_all>:
		return fd_close(fd, 1);
}

void
close_all(void)
{
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	53                   	push   %ebx
  800f2f:	83 ec 14             	sub    $0x14,%esp
  800f32:	bb 00 00 00 00       	mov    $0x0,%ebx
	int i;
	for (i = 0; i < MAXFD; i++)
		close(i);
  800f37:	89 1c 24             	mov    %ebx,(%esp)
  800f3a:	e8 6f ff ff ff       	call   800eae <close>

void
close_all(void)
{
	int i;
	for (i = 0; i < MAXFD; i++)
  800f3f:	83 c3 01             	add    $0x1,%ebx
  800f42:	83 fb 20             	cmp    $0x20,%ebx
  800f45:	75 f0                	jne    800f37 <close_all+0xc>
		close(i);
}
  800f47:	83 c4 14             	add    $0x14,%esp
  800f4a:	5b                   	pop    %ebx
  800f4b:	5d                   	pop    %ebp
  800f4c:	c3                   	ret    

00800f4d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800f4d:	55                   	push   %ebp
  800f4e:	89 e5                	mov    %esp,%ebp
  800f50:	83 ec 58             	sub    $0x58,%esp
  800f53:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  800f56:	89 75 f8             	mov    %esi,-0x8(%ebp)
  800f59:	89 7d fc             	mov    %edi,-0x4(%ebp)
  800f5c:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800f5f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f62:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f66:	8b 45 08             	mov    0x8(%ebp),%eax
  800f69:	89 04 24             	mov    %eax,(%esp)
  800f6c:	e8 7c fb ff ff       	call   800aed <fd_lookup>
  800f71:	89 c3                	mov    %eax,%ebx
  800f73:	85 c0                	test   %eax,%eax
  800f75:	0f 88 e0 00 00 00    	js     80105b <dup+0x10e>
		return r;
	close(newfdnum);
  800f7b:	89 3c 24             	mov    %edi,(%esp)
  800f7e:	e8 2b ff ff ff       	call   800eae <close>

	newfd = INDEX2FD(newfdnum);
  800f83:	8d b7 00 00 0d 00    	lea    0xd0000(%edi),%esi
  800f89:	c1 e6 0c             	shl    $0xc,%esi
	ova = fd2data(oldfd);
  800f8c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f8f:	89 04 24             	mov    %eax,(%esp)
  800f92:	e8 c9 fa ff ff       	call   800a60 <fd2data>
  800f97:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800f99:	89 34 24             	mov    %esi,(%esp)
  800f9c:	e8 bf fa ff ff       	call   800a60 <fd2data>
  800fa1:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if ((vpd[PDX(ova)] & PTE_P) && (vpt[VPN(ova)] & PTE_P))
  800fa4:	89 da                	mov    %ebx,%edx
  800fa6:	89 d8                	mov    %ebx,%eax
  800fa8:	c1 e8 16             	shr    $0x16,%eax
  800fab:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fb2:	a8 01                	test   $0x1,%al
  800fb4:	74 43                	je     800ff9 <dup+0xac>
  800fb6:	c1 ea 0c             	shr    $0xc,%edx
  800fb9:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800fc0:	a8 01                	test   $0x1,%al
  800fc2:	74 35                	je     800ff9 <dup+0xac>
		if ((r = sys_page_map(0, ova, 0, nva, vpt[VPN(ova)] & PTE_USER)) < 0)
  800fc4:	8b 04 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%eax
  800fcb:	25 07 0e 00 00       	and    $0xe07,%eax
  800fd0:	89 44 24 10          	mov    %eax,0x10(%esp)
  800fd4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800fd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800fdb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800fe2:	00 
  800fe3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  800fe7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800fee:	e8 d5 f8 ff ff       	call   8008c8 <sys_page_map>
  800ff3:	89 c3                	mov    %eax,%ebx
  800ff5:	85 c0                	test   %eax,%eax
  800ff7:	78 3f                	js     801038 <dup+0xeb>
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, vpt[VPN(oldfd)] & PTE_USER)) < 0)
  800ff9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ffc:	89 c2                	mov    %eax,%edx
  800ffe:	c1 ea 0c             	shr    $0xc,%edx
  801001:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801008:	81 e2 07 0e 00 00    	and    $0xe07,%edx
  80100e:	89 54 24 10          	mov    %edx,0x10(%esp)
  801012:	89 74 24 0c          	mov    %esi,0xc(%esp)
  801016:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80101d:	00 
  80101e:	89 44 24 04          	mov    %eax,0x4(%esp)
  801022:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801029:	e8 9a f8 ff ff       	call   8008c8 <sys_page_map>
  80102e:	89 c3                	mov    %eax,%ebx
  801030:	85 c0                	test   %eax,%eax
  801032:	78 04                	js     801038 <dup+0xeb>
  801034:	89 fb                	mov    %edi,%ebx
  801036:	eb 23                	jmp    80105b <dup+0x10e>
		goto err;

	return newfdnum;

err:
	sys_page_unmap(0, newfd);
  801038:	89 74 24 04          	mov    %esi,0x4(%esp)
  80103c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801043:	e8 22 f8 ff ff       	call   80086a <sys_page_unmap>
	sys_page_unmap(0, nva);
  801048:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80104b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80104f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801056:	e8 0f f8 ff ff       	call   80086a <sys_page_unmap>
	return r;
}
  80105b:	89 d8                	mov    %ebx,%eax
  80105d:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801060:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801063:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801066:	89 ec                	mov    %ebp,%esp
  801068:	5d                   	pop    %ebp
  801069:	c3                   	ret    
	...

0080106c <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	53                   	push   %ebx
  801070:	83 ec 14             	sub    $0x14,%esp
  801073:	89 d3                	mov    %edx,%ebx
	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", env->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(envs[1].env_id, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801075:	8b 15 c8 00 c0 ee    	mov    0xeec000c8,%edx
  80107b:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  801082:	00 
  801083:	c7 44 24 08 00 30 80 	movl   $0x803000,0x8(%esp)
  80108a:	00 
  80108b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80108f:	89 14 24             	mov    %edx,(%esp)
  801092:	e8 a9 14 00 00       	call   802540 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801097:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  80109e:	00 
  80109f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8010a3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8010aa:	e8 f3 14 00 00       	call   8025a2 <ipc_recv>
}
  8010af:	83 c4 14             	add    $0x14,%esp
  8010b2:	5b                   	pop    %ebx
  8010b3:	5d                   	pop    %ebp
  8010b4:	c3                   	ret    

008010b5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8010b5:	55                   	push   %ebp
  8010b6:	89 e5                	mov    %esp,%ebp
  8010b8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010be:	8b 40 0c             	mov    0xc(%eax),%eax
  8010c1:	a3 00 30 80 00       	mov    %eax,0x803000
	fsipcbuf.set_size.req_size = newsize;
  8010c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010c9:	a3 04 30 80 00       	mov    %eax,0x803004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8010ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8010d3:	b8 02 00 00 00       	mov    $0x2,%eax
  8010d8:	e8 8f ff ff ff       	call   80106c <fsipc>
}
  8010dd:	c9                   	leave  
  8010de:	c3                   	ret    

008010df <sync>:
}

// Synchronize disk with buffer cache
int
sync(void)
{
  8010df:	55                   	push   %ebp
  8010e0:	89 e5                	mov    %esp,%ebp
  8010e2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8010e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8010ea:	b8 08 00 00 00       	mov    $0x8,%eax
  8010ef:	e8 78 ff ff ff       	call   80106c <fsipc>
}
  8010f4:	c9                   	leave  
  8010f5:	c3                   	ret    

008010f6 <devfile_stat>:
}


static int
devfile_stat(struct Fd *fd, struct Stat *st)
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	53                   	push   %ebx
  8010fa:	83 ec 14             	sub    $0x14,%esp
  8010fd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;

	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801100:	8b 45 08             	mov    0x8(%ebp),%eax
  801103:	8b 40 0c             	mov    0xc(%eax),%eax
  801106:	a3 00 30 80 00       	mov    %eax,0x803000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80110b:	ba 00 00 00 00       	mov    $0x0,%edx
  801110:	b8 05 00 00 00       	mov    $0x5,%eax
  801115:	e8 52 ff ff ff       	call   80106c <fsipc>
  80111a:	85 c0                	test   %eax,%eax
  80111c:	78 2b                	js     801149 <devfile_stat+0x53>
		return r;
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80111e:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  801125:	00 
  801126:	89 1c 24             	mov    %ebx,(%esp)
  801129:	e8 9c f0 ff ff       	call   8001ca <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80112e:	a1 80 30 80 00       	mov    0x803080,%eax
  801133:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_isdir = fsipcbuf.statRet.ret_isdir;
  801139:	a1 84 30 80 00       	mov    0x803084,%eax
  80113e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
  801144:	b8 00 00 00 00       	mov    $0x0,%eax
	return 0;
}
  801149:	83 c4 14             	add    $0x14,%esp
  80114c:	5b                   	pop    %ebx
  80114d:	5d                   	pop    %ebp
  80114e:	c3                   	ret    

0080114f <devfile_flush>:
// open, unmapping it is enough to free up server-side resources.
// Other than that, we just have to make sure our changes are flushed
// to disk.
static int
devfile_flush(struct Fd *fd)
{
  80114f:	55                   	push   %ebp
  801150:	89 e5                	mov    %esp,%ebp
  801152:	83 ec 18             	sub    $0x18,%esp
        memset(&fsipcbuf,0,PGSIZE);
  801155:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80115c:	00 
  80115d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  801164:	00 
  801165:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  80116c:	e8 b5 f1 ff ff       	call   800326 <memset>
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801171:	8b 45 08             	mov    0x8(%ebp),%eax
  801174:	8b 40 0c             	mov    0xc(%eax),%eax
  801177:	a3 00 30 80 00       	mov    %eax,0x803000
	return fsipc(FSREQ_FLUSH, NULL);
  80117c:	ba 00 00 00 00       	mov    $0x0,%edx
  801181:	b8 06 00 00 00       	mov    $0x6,%eax
  801186:	e8 e1 fe ff ff       	call   80106c <fsipc>
}
  80118b:	c9                   	leave  
  80118c:	c3                   	ret    

0080118d <devfile_write>:
//	 The number of bytes successfully written.
//	 < 0 on error.

static ssize_t
devfile_write(struct Fd *fd, const void *buf, size_t n)
{
  80118d:	55                   	push   %ebp
  80118e:	89 e5                	mov    %esp,%ebp
  801190:	83 ec 18             	sub    $0x18,%esp
	// remember that write is always allowed to write *fewer*
	// bytes than requested.
	// LAB 5: Your code here
       int r=0;
      uint32_t numberOfBytes;
      memset(&fsipcbuf,0,PGSIZE);
  801193:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  80119a:	00 
  80119b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8011a2:	00 
  8011a3:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  8011aa:	e8 77 f1 ff ff       	call   800326 <memset>
  8011af:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b2:	3d f8 0f 00 00       	cmp    $0xff8,%eax
  8011b7:	76 05                	jbe    8011be <devfile_write+0x31>
  8011b9:	b8 f8 0f 00 00       	mov    $0xff8,%eax
       if(n > PGSIZE - (sizeof(int) + sizeof(size_t)))
          numberOfBytes=PGSIZE - (sizeof(int) + sizeof(size_t));
       else
          numberOfBytes = n; 
        fsipcbuf.write.req_fileid = fd->fd_file.id;
  8011be:	8b 55 08             	mov    0x8(%ebp),%edx
  8011c1:	8b 52 0c             	mov    0xc(%edx),%edx
  8011c4:	89 15 00 30 80 00    	mov    %edx,0x803000
        fsipcbuf.write.req_n = numberOfBytes;
  8011ca:	a3 04 30 80 00       	mov    %eax,0x803004
     //  strcpy(fsipcbuf.write.req_buf,buf);   
     memmove(fsipcbuf.write.req_buf,buf,numberOfBytes);        
  8011cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  8011d3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8011da:	c7 04 24 08 30 80 00 	movl   $0x803008,(%esp)
  8011e1:	e8 9f f1 ff ff       	call   800385 <memmove>
       if((r = fsipc(FSREQ_WRITE,NULL))<0)
  8011e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8011eb:	b8 04 00 00 00       	mov    $0x4,%eax
  8011f0:	e8 77 fe ff ff       	call   80106c <fsipc>
              return r;
        return r;
}
  8011f5:	c9                   	leave  
  8011f6:	c3                   	ret    

008011f7 <devfile_read>:
// 	The number of bytes successfully read.
// 	< 0 on error.

static ssize_t
devfile_read(struct Fd *fd, void *buf, size_t n)
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	53                   	push   %ebx
  8011fb:	83 ec 14             	sub    $0x14,%esp
	// filling fsipcbuf.read with the request arguments.  The
	// bytes read will be written back to fsipcbuf by the file
	// system server.
	// LAB 5: Your code here
        int r=0;
        memset(&fsipcbuf,0,PGSIZE); 
  8011fe:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  801205:	00 
  801206:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  80120d:	00 
  80120e:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801215:	e8 0c f1 ff ff       	call   800326 <memset>
        fsipcbuf.read.req_fileid = fd->fd_file.id;
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8b 40 0c             	mov    0xc(%eax),%eax
  801220:	a3 00 30 80 00       	mov    %eax,0x803000
        fsipcbuf.read.req_n = n;
  801225:	8b 45 10             	mov    0x10(%ebp),%eax
  801228:	a3 04 30 80 00       	mov    %eax,0x803004
       
        if((r = fsipc(FSREQ_READ,NULL))<0)
  80122d:	ba 00 00 00 00       	mov    $0x0,%edx
  801232:	b8 03 00 00 00       	mov    $0x3,%eax
  801237:	e8 30 fe ff ff       	call   80106c <fsipc>
  80123c:	89 c3                	mov    %eax,%ebx
  80123e:	85 c0                	test   %eax,%eax
  801240:	78 17                	js     801259 <devfile_read+0x62>
              return r;
        //strcpy(buf,fsipcbuf.readRet.ret_buf);
     // cprintf("\n---->n=%d r=%d buffersize=%d\n",n,r,sizeof(buf));
        memmove(buf,fsipcbuf.readRet.ret_buf,r);
  801242:	89 44 24 08          	mov    %eax,0x8(%esp)
  801246:	c7 44 24 04 00 30 80 	movl   $0x803000,0x4(%esp)
  80124d:	00 
  80124e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801251:	89 04 24             	mov    %eax,(%esp)
  801254:	e8 2c f1 ff ff       	call   800385 <memmove>
        return r;
}
  801259:	89 d8                	mov    %ebx,%eax
  80125b:	83 c4 14             	add    $0x14,%esp
  80125e:	5b                   	pop    %ebx
  80125f:	5d                   	pop    %ebp
  801260:	c3                   	ret    

00801261 <remove>:
}

// Delete a file
int
remove(const char *path)
{
  801261:	55                   	push   %ebp
  801262:	89 e5                	mov    %esp,%ebp
  801264:	53                   	push   %ebx
  801265:	83 ec 14             	sub    $0x14,%esp
  801268:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (strlen(path) >= MAXPATHLEN)
  80126b:	89 1c 24             	mov    %ebx,(%esp)
  80126e:	e8 0d ef ff ff       	call   800180 <strlen>
  801273:	89 c2                	mov    %eax,%edx
  801275:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  80127a:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  801280:	7f 1f                	jg     8012a1 <remove+0x40>
		return -E_BAD_PATH;
	strcpy(fsipcbuf.remove.req_path, path);
  801282:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801286:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  80128d:	e8 38 ef ff ff       	call   8001ca <strcpy>
	return fsipc(FSREQ_REMOVE, NULL);
  801292:	ba 00 00 00 00       	mov    $0x0,%edx
  801297:	b8 07 00 00 00       	mov    $0x7,%eax
  80129c:	e8 cb fd ff ff       	call   80106c <fsipc>
}
  8012a1:	83 c4 14             	add    $0x14,%esp
  8012a4:	5b                   	pop    %ebx
  8012a5:	5d                   	pop    %ebp
  8012a6:	c3                   	ret    

008012a7 <open>:
// 	< 0 for other errors.


int
open(const char *path, int mode)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	56                   	push   %esi
  8012ab:	53                   	push   %ebx
  8012ac:	83 ec 20             	sub    $0x20,%esp
  8012af:	8b 75 08             	mov    0x8(%ebp),%esi

	// LAB 5: Your code here.

      struct Fd *fd;
       int r;        
 memset(&fsipcbuf,0,PGSIZE);
  8012b2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  8012b9:	00 
  8012ba:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8012c1:	00 
  8012c2:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  8012c9:	e8 58 f0 ff ff       	call   800326 <memset>
    if(strlen(path)>=MAXPATHLEN)
  8012ce:	89 34 24             	mov    %esi,(%esp)
  8012d1:	e8 aa ee ff ff       	call   800180 <strlen>
  8012d6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8012db:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8012e0:	0f 8f 84 00 00 00    	jg     80136a <open+0xc3>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
  8012e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012e9:	89 04 24             	mov    %eax,(%esp)
  8012ec:	e8 8a f7 ff ff       	call   800a7b <fd_alloc>
  8012f1:	89 c3                	mov    %eax,%ebx
  8012f3:	85 c0                	test   %eax,%eax
  8012f5:	78 73                	js     80136a <open+0xc3>
           return r;
 int i=0;
  while(path[i]!='\0')
  8012f7:	0f b6 06             	movzbl (%esi),%eax
  8012fa:	84 c0                	test   %al,%al
  8012fc:	74 20                	je     80131e <open+0x77>
  8012fe:	89 f3                	mov    %esi,%ebx
    {
       cprintf("%c",path[i]);
  801300:	0f be c0             	movsbl %al,%eax
  801303:	89 44 24 04          	mov    %eax,0x4(%esp)
  801307:	c7 04 24 98 29 80 00 	movl   $0x802998,(%esp)
  80130e:	e8 9e 0b 00 00       	call   801eb1 <cprintf>
            return -E_BAD_PATH;

       if((r = fd_alloc(&fd))<0)
           return r;
 int i=0;
  while(path[i]!='\0')
  801313:	0f b6 43 01          	movzbl 0x1(%ebx),%eax
  801317:	83 c3 01             	add    $0x1,%ebx
  80131a:	84 c0                	test   %al,%al
  80131c:	75 e2                	jne    801300 <open+0x59>
    {
       cprintf("%c",path[i]);
        i++;
    }
    strcpy(fsipcbuf.open.req_path, path);
  80131e:	89 74 24 04          	mov    %esi,0x4(%esp)
  801322:	c7 04 24 00 30 80 00 	movl   $0x803000,(%esp)
  801329:	e8 9c ee ff ff       	call   8001ca <strcpy>
    fsipcbuf.open.req_omode = mode;
  80132e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801331:	a3 00 34 80 00       	mov    %eax,0x803400
    if((r = fsipc(FSREQ_OPEN,fd))<0)
  801336:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801339:	b8 01 00 00 00       	mov    $0x1,%eax
  80133e:	e8 29 fd ff ff       	call   80106c <fsipc>
  801343:	89 c3                	mov    %eax,%ebx
  801345:	85 c0                	test   %eax,%eax
  801347:	79 15                	jns    80135e <open+0xb7>
        {
            fd_close(fd,1);
  801349:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801350:	00 
  801351:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801354:	89 04 24             	mov    %eax,(%esp)
  801357:	e8 d3 fa ff ff       	call   800e2f <fd_close>
             return r;
  80135c:	eb 0c                	jmp    80136a <open+0xc3>
        }
     int fdindex = ((uint32_t)fd-0xD0000000)/PGSIZE;       
  80135e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801361:	81 c3 00 00 00 30    	add    $0x30000000,%ebx
  801367:	c1 eb 0c             	shr    $0xc,%ebx
             return fdindex; 

	//panic("open not implemented");
}
  80136a:	89 d8                	mov    %ebx,%eax
  80136c:	83 c4 20             	add    $0x20,%esp
  80136f:	5b                   	pop    %ebx
  801370:	5e                   	pop    %esi
  801371:	5d                   	pop    %ebp
  801372:	c3                   	ret    
	...

00801380 <devsock_stat>:
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
}

static int
devsock_stat(struct Fd *fd, struct Stat *stat)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<sock>");
  801386:	c7 44 24 04 9b 29 80 	movl   $0x80299b,0x4(%esp)
  80138d:	00 
  80138e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801391:	89 04 24             	mov    %eax,(%esp)
  801394:	e8 31 ee ff ff       	call   8001ca <strcpy>
	return 0;
}
  801399:	b8 00 00 00 00       	mov    $0x0,%eax
  80139e:	c9                   	leave  
  80139f:	c3                   	ret    

008013a0 <devsock_close>:
	return nsipc_shutdown(r, how);
}

static int
devsock_close(struct Fd *fd)
{
  8013a0:	55                   	push   %ebp
  8013a1:	89 e5                	mov    %esp,%ebp
  8013a3:	83 ec 18             	sub    $0x18,%esp
	return nsipc_close(fd->fd_sock.sockid);
  8013a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8013ac:	89 04 24             	mov    %eax,(%esp)
  8013af:	e8 9e 02 00 00       	call   801652 <nsipc_close>
}
  8013b4:	c9                   	leave  
  8013b5:	c3                   	ret    

008013b6 <devsock_write>:
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
}

static ssize_t
devsock_write(struct Fd *fd, const void *buf, size_t n)
{
  8013b6:	55                   	push   %ebp
  8013b7:	89 e5                	mov    %esp,%ebp
  8013b9:	83 ec 18             	sub    $0x18,%esp
	return nsipc_send(fd->fd_sock.sockid, buf, n, 0);
  8013bc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8013c3:	00 
  8013c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8013c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8013d8:	89 04 24             	mov    %eax,(%esp)
  8013db:	e8 ae 02 00 00       	call   80168e <nsipc_send>
}
  8013e0:	c9                   	leave  
  8013e1:	c3                   	ret    

008013e2 <devsock_read>:
	return nsipc_listen(r, backlog);
}

static ssize_t
devsock_read(struct Fd *fd, void *buf, size_t n)
{
  8013e2:	55                   	push   %ebp
  8013e3:	89 e5                	mov    %esp,%ebp
  8013e5:	83 ec 18             	sub    $0x18,%esp
	return nsipc_recv(fd->fd_sock.sockid, buf, n, 0);
  8013e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  8013ef:	00 
  8013f0:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8013f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  8013fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801401:	8b 40 0c             	mov    0xc(%eax),%eax
  801404:	89 04 24             	mov    %eax,(%esp)
  801407:	e8 f5 02 00 00       	call   801701 <nsipc_recv>
}
  80140c:	c9                   	leave  
  80140d:	c3                   	ret    

0080140e <alloc_sockfd>:
	return sfd->fd_sock.sockid;
}

static int
alloc_sockfd(int sockid)
{
  80140e:	55                   	push   %ebp
  80140f:	89 e5                	mov    %esp,%ebp
  801411:	56                   	push   %esi
  801412:	53                   	push   %ebx
  801413:	83 ec 20             	sub    $0x20,%esp
  801416:	89 c6                	mov    %eax,%esi
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801418:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80141b:	89 04 24             	mov    %eax,(%esp)
  80141e:	e8 58 f6 ff ff       	call   800a7b <fd_alloc>
  801423:	89 c3                	mov    %eax,%ebx
  801425:	85 c0                	test   %eax,%eax
  801427:	78 21                	js     80144a <alloc_sockfd+0x3c>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
  801429:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
  801430:	00 
  801431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801434:	89 44 24 04          	mov    %eax,0x4(%esp)
  801438:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80143f:	e8 e2 f4 ff ff       	call   800926 <sys_page_alloc>
  801444:	89 c3                	mov    %eax,%ebx
alloc_sockfd(int sockid)
{
	struct Fd *sfd;
	int r;

	if ((r = fd_alloc(&sfd)) < 0
  801446:	85 c0                	test   %eax,%eax
  801448:	79 0a                	jns    801454 <alloc_sockfd+0x46>
	    || (r = sys_page_alloc(0, sfd, PTE_P|PTE_W|PTE_U)) < 0) {
		nsipc_close(sockid);
  80144a:	89 34 24             	mov    %esi,(%esp)
  80144d:	e8 00 02 00 00       	call   801652 <nsipc_close>
		return r;
  801452:	eb 28                	jmp    80147c <alloc_sockfd+0x6e>
	}

	sfd->fd_dev_id = devsock.dev_id;
  801454:	8b 15 20 60 80 00    	mov    0x806020,%edx
  80145a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80145d:	89 10                	mov    %edx,(%eax)
	sfd->fd_omode = O_RDWR;
  80145f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801462:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	sfd->fd_sock.sockid = sockid;
  801469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80146c:	89 70 0c             	mov    %esi,0xc(%eax)
	return fd2num(sfd);
  80146f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801472:	89 04 24             	mov    %eax,(%esp)
  801475:	e8 d6 f5 ff ff       	call   800a50 <fd2num>
  80147a:	89 c3                	mov    %eax,%ebx
}
  80147c:	89 d8                	mov    %ebx,%eax
  80147e:	83 c4 20             	add    $0x20,%esp
  801481:	5b                   	pop    %ebx
  801482:	5e                   	pop    %esi
  801483:	5d                   	pop    %ebp
  801484:	c3                   	ret    

00801485 <socket>:
	return 0;
}

int
socket(int domain, int type, int protocol)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = nsipc_socket(domain, type, protocol)) < 0)
  80148b:	8b 45 10             	mov    0x10(%ebp),%eax
  80148e:	89 44 24 08          	mov    %eax,0x8(%esp)
  801492:	8b 45 0c             	mov    0xc(%ebp),%eax
  801495:	89 44 24 04          	mov    %eax,0x4(%esp)
  801499:	8b 45 08             	mov    0x8(%ebp),%eax
  80149c:	89 04 24             	mov    %eax,(%esp)
  80149f:	e8 62 01 00 00       	call   801606 <nsipc_socket>
  8014a4:	85 c0                	test   %eax,%eax
  8014a6:	78 05                	js     8014ad <socket+0x28>
		return r;
	return alloc_sockfd(r);
  8014a8:	e8 61 ff ff ff       	call   80140e <alloc_sockfd>
}
  8014ad:	c9                   	leave  
  8014ae:	66 90                	xchg   %ax,%ax
  8014b0:	c3                   	ret    

008014b1 <fd2sockid>:
	.dev_stat =	devsock_stat,
};

static int
fd2sockid(int fd)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	83 ec 28             	sub    $0x28,%esp
	struct Fd *sfd;
	int r;

	if ((r = fd_lookup(fd, &sfd)) < 0)
  8014b7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8014ba:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014be:	89 04 24             	mov    %eax,(%esp)
  8014c1:	e8 27 f6 ff ff       	call   800aed <fd_lookup>
  8014c6:	85 c0                	test   %eax,%eax
  8014c8:	78 15                	js     8014df <fd2sockid+0x2e>
		return r;
	if (sfd->fd_dev_id != devsock.dev_id)
  8014ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014cd:	8b 0a                	mov    (%edx),%ecx
  8014cf:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014d4:	3b 0d 20 60 80 00    	cmp    0x806020,%ecx
  8014da:	75 03                	jne    8014df <fd2sockid+0x2e>
		return -E_NOT_SUPP;
	return sfd->fd_sock.sockid;
  8014dc:	8b 42 0c             	mov    0xc(%edx),%eax
}
  8014df:	c9                   	leave  
  8014e0:	c3                   	ret    

008014e1 <listen>:
	return nsipc_connect(r, name, namelen);
}

int
listen(int s, int backlog)
{
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
  8014e4:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	e8 c2 ff ff ff       	call   8014b1 <fd2sockid>
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	78 0f                	js     801502 <listen+0x21>
		return r;
	return nsipc_listen(r, backlog);
  8014f3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f6:	89 54 24 04          	mov    %edx,0x4(%esp)
  8014fa:	89 04 24             	mov    %eax,(%esp)
  8014fd:	e8 2e 01 00 00       	call   801630 <nsipc_listen>
}
  801502:	c9                   	leave  
  801503:	c3                   	ret    

00801504 <connect>:
	return nsipc_close(fd->fd_sock.sockid);
}

int
connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801504:	55                   	push   %ebp
  801505:	89 e5                	mov    %esp,%ebp
  801507:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  80150a:	8b 45 08             	mov    0x8(%ebp),%eax
  80150d:	e8 9f ff ff ff       	call   8014b1 <fd2sockid>
  801512:	85 c0                	test   %eax,%eax
  801514:	78 16                	js     80152c <connect+0x28>
		return r;
	return nsipc_connect(r, name, namelen);
  801516:	8b 55 10             	mov    0x10(%ebp),%edx
  801519:	89 54 24 08          	mov    %edx,0x8(%esp)
  80151d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801520:	89 54 24 04          	mov    %edx,0x4(%esp)
  801524:	89 04 24             	mov    %eax,(%esp)
  801527:	e8 55 02 00 00       	call   801781 <nsipc_connect>
}
  80152c:	c9                   	leave  
  80152d:	c3                   	ret    

0080152e <shutdown>:
	return nsipc_bind(r, name, namelen);
}

int
shutdown(int s, int how)
{
  80152e:	55                   	push   %ebp
  80152f:	89 e5                	mov    %esp,%ebp
  801531:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801534:	8b 45 08             	mov    0x8(%ebp),%eax
  801537:	e8 75 ff ff ff       	call   8014b1 <fd2sockid>
  80153c:	85 c0                	test   %eax,%eax
  80153e:	78 0f                	js     80154f <shutdown+0x21>
		return r;
	return nsipc_shutdown(r, how);
  801540:	8b 55 0c             	mov    0xc(%ebp),%edx
  801543:	89 54 24 04          	mov    %edx,0x4(%esp)
  801547:	89 04 24             	mov    %eax,(%esp)
  80154a:	e8 1d 01 00 00       	call   80166c <nsipc_shutdown>
}
  80154f:	c9                   	leave  
  801550:	c3                   	ret    

00801551 <bind>:
	return alloc_sockfd(r);
}

int
bind(int s, struct sockaddr *name, socklen_t namelen)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801557:	8b 45 08             	mov    0x8(%ebp),%eax
  80155a:	e8 52 ff ff ff       	call   8014b1 <fd2sockid>
  80155f:	85 c0                	test   %eax,%eax
  801561:	78 16                	js     801579 <bind+0x28>
		return r;
	return nsipc_bind(r, name, namelen);
  801563:	8b 55 10             	mov    0x10(%ebp),%edx
  801566:	89 54 24 08          	mov    %edx,0x8(%esp)
  80156a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801571:	89 04 24             	mov    %eax,(%esp)
  801574:	e8 47 02 00 00       	call   8017c0 <nsipc_bind>
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <accept>:
	return fd2num(sfd);
}

int
accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	83 ec 18             	sub    $0x18,%esp
	int r;
	if ((r = fd2sockid(s)) < 0)
  801581:	8b 45 08             	mov    0x8(%ebp),%eax
  801584:	e8 28 ff ff ff       	call   8014b1 <fd2sockid>
  801589:	85 c0                	test   %eax,%eax
  80158b:	78 1f                	js     8015ac <accept+0x31>
		return r;
	if ((r = nsipc_accept(r, addr, addrlen)) < 0)
  80158d:	8b 55 10             	mov    0x10(%ebp),%edx
  801590:	89 54 24 08          	mov    %edx,0x8(%esp)
  801594:	8b 55 0c             	mov    0xc(%ebp),%edx
  801597:	89 54 24 04          	mov    %edx,0x4(%esp)
  80159b:	89 04 24             	mov    %eax,(%esp)
  80159e:	e8 5c 02 00 00       	call   8017ff <nsipc_accept>
  8015a3:	85 c0                	test   %eax,%eax
  8015a5:	78 05                	js     8015ac <accept+0x31>
		return r;
	return alloc_sockfd(r);
  8015a7:	e8 62 fe ff ff       	call   80140e <alloc_sockfd>
}
  8015ac:	c9                   	leave  
  8015ad:	8d 76 00             	lea    0x0(%esi),%esi
  8015b0:	c3                   	ret    
	...

008015c0 <nsipc>:
// may be written back to nsipcbuf.
// type: request code, passed as the simple integer IPC value.
// Returns 0 if successful, < 0 on failure.
static int
nsipc(unsigned type)
{
  8015c0:	55                   	push   %ebp
  8015c1:	89 e5                	mov    %esp,%ebp
  8015c3:	83 ec 18             	sub    $0x18,%esp
	if (debug)
		cprintf("[%08x] nsipc %d\n", env->env_id, type);

	ipc_send(envs[2].env_id, type, &nsipcbuf, PTE_P|PTE_W|PTE_U);
  8015c6:	8b 15 44 01 c0 ee    	mov    0xeec00144,%edx
  8015cc:	c7 44 24 0c 07 00 00 	movl   $0x7,0xc(%esp)
  8015d3:	00 
  8015d4:	c7 44 24 08 00 50 80 	movl   $0x805000,0x8(%esp)
  8015db:	00 
  8015dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8015e0:	89 14 24             	mov    %edx,(%esp)
  8015e3:	e8 58 0f 00 00       	call   802540 <ipc_send>
	return ipc_recv(NULL, NULL, NULL);
  8015e8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  8015ef:	00 
  8015f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8015f7:	00 
  8015f8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8015ff:	e8 9e 0f 00 00       	call   8025a2 <ipc_recv>
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <nsipc_socket>:
	return nsipc(NSREQ_SEND);
}

int
nsipc_socket(int domain, int type, int protocol)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.socket.req_domain = domain;
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.socket.req_type = type;
  801614:	8b 45 0c             	mov    0xc(%ebp),%eax
  801617:	a3 04 50 80 00       	mov    %eax,0x805004
	nsipcbuf.socket.req_protocol = protocol;
  80161c:	8b 45 10             	mov    0x10(%ebp),%eax
  80161f:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SOCKET);
  801624:	b8 09 00 00 00       	mov    $0x9,%eax
  801629:	e8 92 ff ff ff       	call   8015c0 <nsipc>
}
  80162e:	c9                   	leave  
  80162f:	c3                   	ret    

00801630 <nsipc_listen>:
	return nsipc(NSREQ_CONNECT);
}

int
nsipc_listen(int s, int backlog)
{
  801630:	55                   	push   %ebp
  801631:	89 e5                	mov    %esp,%ebp
  801633:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.listen.req_s = s;
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.listen.req_backlog = backlog;
  80163e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801641:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_LISTEN);
  801646:	b8 06 00 00 00       	mov    $0x6,%eax
  80164b:	e8 70 ff ff ff       	call   8015c0 <nsipc>
}
  801650:	c9                   	leave  
  801651:	c3                   	ret    

00801652 <nsipc_close>:
	return nsipc(NSREQ_SHUTDOWN);
}

int
nsipc_close(int s)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.close.req_s = s;
  801658:	8b 45 08             	mov    0x8(%ebp),%eax
  80165b:	a3 00 50 80 00       	mov    %eax,0x805000
	return nsipc(NSREQ_CLOSE);
  801660:	b8 04 00 00 00       	mov    $0x4,%eax
  801665:	e8 56 ff ff ff       	call   8015c0 <nsipc>
}
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <nsipc_shutdown>:
	return nsipc(NSREQ_BIND);
}

int
nsipc_shutdown(int s, int how)
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	83 ec 08             	sub    $0x8,%esp
	nsipcbuf.shutdown.req_s = s;
  801672:	8b 45 08             	mov    0x8(%ebp),%eax
  801675:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.shutdown.req_how = how;
  80167a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80167d:	a3 04 50 80 00       	mov    %eax,0x805004
	return nsipc(NSREQ_SHUTDOWN);
  801682:	b8 03 00 00 00       	mov    $0x3,%eax
  801687:	e8 34 ff ff ff       	call   8015c0 <nsipc>
}
  80168c:	c9                   	leave  
  80168d:	c3                   	ret    

0080168e <nsipc_send>:
	return r;
}

int
nsipc_send(int s, const void *buf, int size, unsigned int flags)
{
  80168e:	55                   	push   %ebp
  80168f:	89 e5                	mov    %esp,%ebp
  801691:	53                   	push   %ebx
  801692:	83 ec 14             	sub    $0x14,%esp
  801695:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.send.req_s = s;
  801698:	8b 45 08             	mov    0x8(%ebp),%eax
  80169b:	a3 00 50 80 00       	mov    %eax,0x805000
	assert(size < 1600);
  8016a0:	81 fb 3f 06 00 00    	cmp    $0x63f,%ebx
  8016a6:	7e 24                	jle    8016cc <nsipc_send+0x3e>
  8016a8:	c7 44 24 0c a7 29 80 	movl   $0x8029a7,0xc(%esp)
  8016af:	00 
  8016b0:	c7 44 24 08 b3 29 80 	movl   $0x8029b3,0x8(%esp)
  8016b7:	00 
  8016b8:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
  8016bf:	00 
  8016c0:	c7 04 24 c8 29 80 00 	movl   $0x8029c8,(%esp)
  8016c7:	e8 20 07 00 00       	call   801dec <_panic>
	memmove(&nsipcbuf.send.req_buf, buf, size);
  8016cc:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8016d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8016d7:	c7 04 24 0c 50 80 00 	movl   $0x80500c,(%esp)
  8016de:	e8 a2 ec ff ff       	call   800385 <memmove>
	nsipcbuf.send.req_size = size;
  8016e3:	89 1d 04 50 80 00    	mov    %ebx,0x805004
	nsipcbuf.send.req_flags = flags;
  8016e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ec:	a3 08 50 80 00       	mov    %eax,0x805008
	return nsipc(NSREQ_SEND);
  8016f1:	b8 08 00 00 00       	mov    $0x8,%eax
  8016f6:	e8 c5 fe ff ff       	call   8015c0 <nsipc>
}
  8016fb:	83 c4 14             	add    $0x14,%esp
  8016fe:	5b                   	pop    %ebx
  8016ff:	5d                   	pop    %ebp
  801700:	c3                   	ret    

00801701 <nsipc_recv>:
	return nsipc(NSREQ_LISTEN);
}

int
nsipc_recv(int s, void *mem, int len, unsigned int flags)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	56                   	push   %esi
  801705:	53                   	push   %ebx
  801706:	83 ec 10             	sub    $0x10,%esp
  801709:	8b 75 10             	mov    0x10(%ebp),%esi
	int r;

	nsipcbuf.recv.req_s = s;
  80170c:	8b 45 08             	mov    0x8(%ebp),%eax
  80170f:	a3 00 50 80 00       	mov    %eax,0x805000
	nsipcbuf.recv.req_len = len;
  801714:	89 35 04 50 80 00    	mov    %esi,0x805004
	nsipcbuf.recv.req_flags = flags;
  80171a:	8b 45 14             	mov    0x14(%ebp),%eax
  80171d:	a3 08 50 80 00       	mov    %eax,0x805008

	if ((r = nsipc(NSREQ_RECV)) >= 0) {
  801722:	b8 07 00 00 00       	mov    $0x7,%eax
  801727:	e8 94 fe ff ff       	call   8015c0 <nsipc>
  80172c:	89 c3                	mov    %eax,%ebx
  80172e:	85 c0                	test   %eax,%eax
  801730:	78 46                	js     801778 <nsipc_recv+0x77>
		assert(r < 1600 && r <= len);
  801732:	3d 3f 06 00 00       	cmp    $0x63f,%eax
  801737:	7f 04                	jg     80173d <nsipc_recv+0x3c>
  801739:	39 c6                	cmp    %eax,%esi
  80173b:	7d 24                	jge    801761 <nsipc_recv+0x60>
  80173d:	c7 44 24 0c d4 29 80 	movl   $0x8029d4,0xc(%esp)
  801744:	00 
  801745:	c7 44 24 08 b3 29 80 	movl   $0x8029b3,0x8(%esp)
  80174c:	00 
  80174d:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
  801754:	00 
  801755:	c7 04 24 c8 29 80 00 	movl   $0x8029c8,(%esp)
  80175c:	e8 8b 06 00 00       	call   801dec <_panic>
		memmove(mem, nsipcbuf.recvRet.ret_buf, r);
  801761:	89 44 24 08          	mov    %eax,0x8(%esp)
  801765:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  80176c:	00 
  80176d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801770:	89 04 24             	mov    %eax,(%esp)
  801773:	e8 0d ec ff ff       	call   800385 <memmove>
	}

	return r;
}
  801778:	89 d8                	mov    %ebx,%eax
  80177a:	83 c4 10             	add    $0x10,%esp
  80177d:	5b                   	pop    %ebx
  80177e:	5e                   	pop    %esi
  80177f:	5d                   	pop    %ebp
  801780:	c3                   	ret    

00801781 <nsipc_connect>:
	return nsipc(NSREQ_CLOSE);
}

int
nsipc_connect(int s, const struct sockaddr *name, socklen_t namelen)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
  801784:	53                   	push   %ebx
  801785:	83 ec 14             	sub    $0x14,%esp
  801788:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.connect.req_s = s;
  80178b:	8b 45 08             	mov    0x8(%ebp),%eax
  80178e:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.connect.req_name, name, namelen);
  801793:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801797:	8b 45 0c             	mov    0xc(%ebp),%eax
  80179a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80179e:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8017a5:	e8 db eb ff ff       	call   800385 <memmove>
	nsipcbuf.connect.req_namelen = namelen;
  8017aa:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_CONNECT);
  8017b0:	b8 05 00 00 00       	mov    $0x5,%eax
  8017b5:	e8 06 fe ff ff       	call   8015c0 <nsipc>
}
  8017ba:	83 c4 14             	add    $0x14,%esp
  8017bd:	5b                   	pop    %ebx
  8017be:	5d                   	pop    %ebp
  8017bf:	c3                   	ret    

008017c0 <nsipc_bind>:
	return r;
}

int
nsipc_bind(int s, struct sockaddr *name, socklen_t namelen)
{
  8017c0:	55                   	push   %ebp
  8017c1:	89 e5                	mov    %esp,%ebp
  8017c3:	53                   	push   %ebx
  8017c4:	83 ec 14             	sub    $0x14,%esp
  8017c7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	nsipcbuf.bind.req_s = s;
  8017ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8017cd:	a3 00 50 80 00       	mov    %eax,0x805000
	memmove(&nsipcbuf.bind.req_name, name, namelen);
  8017d2:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8017d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8017dd:	c7 04 24 04 50 80 00 	movl   $0x805004,(%esp)
  8017e4:	e8 9c eb ff ff       	call   800385 <memmove>
	nsipcbuf.bind.req_namelen = namelen;
  8017e9:	89 1d 14 50 80 00    	mov    %ebx,0x805014
	return nsipc(NSREQ_BIND);
  8017ef:	b8 02 00 00 00       	mov    $0x2,%eax
  8017f4:	e8 c7 fd ff ff       	call   8015c0 <nsipc>
}
  8017f9:	83 c4 14             	add    $0x14,%esp
  8017fc:	5b                   	pop    %ebx
  8017fd:	5d                   	pop    %ebp
  8017fe:	c3                   	ret    

008017ff <nsipc_accept>:
	return ipc_recv(NULL, NULL, NULL);
}

int
nsipc_accept(int s, struct sockaddr *addr, socklen_t *addrlen)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 18             	sub    $0x18,%esp
  801805:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801808:	89 75 fc             	mov    %esi,-0x4(%ebp)
	int r;
	
	nsipcbuf.accept.req_s = s;
  80180b:	8b 45 08             	mov    0x8(%ebp),%eax
  80180e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = nsipc(NSREQ_ACCEPT)) >= 0) {
  801813:	b8 01 00 00 00       	mov    $0x1,%eax
  801818:	e8 a3 fd ff ff       	call   8015c0 <nsipc>
  80181d:	89 c3                	mov    %eax,%ebx
  80181f:	85 c0                	test   %eax,%eax
  801821:	78 25                	js     801848 <nsipc_accept+0x49>
		struct Nsret_accept *ret = &nsipcbuf.acceptRet;
		memmove(addr, &ret->ret_addr, ret->ret_addrlen);
  801823:	be 10 50 80 00       	mov    $0x805010,%esi
  801828:	8b 06                	mov    (%esi),%eax
  80182a:	89 44 24 08          	mov    %eax,0x8(%esp)
  80182e:	c7 44 24 04 00 50 80 	movl   $0x805000,0x4(%esp)
  801835:	00 
  801836:	8b 45 0c             	mov    0xc(%ebp),%eax
  801839:	89 04 24             	mov    %eax,(%esp)
  80183c:	e8 44 eb ff ff       	call   800385 <memmove>
		*addrlen = ret->ret_addrlen;
  801841:	8b 16                	mov    (%esi),%edx
  801843:	8b 45 10             	mov    0x10(%ebp),%eax
  801846:	89 10                	mov    %edx,(%eax)
	}
	return r;
}
  801848:	89 d8                	mov    %ebx,%eax
  80184a:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  80184d:	8b 75 fc             	mov    -0x4(%ebp),%esi
  801850:	89 ec                	mov    %ebp,%esp
  801852:	5d                   	pop    %ebp
  801853:	c3                   	ret    
	...

00801860 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	83 ec 18             	sub    $0x18,%esp
  801866:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  801869:	89 75 fc             	mov    %esi,-0x4(%ebp)
  80186c:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80186f:	8b 45 08             	mov    0x8(%ebp),%eax
  801872:	89 04 24             	mov    %eax,(%esp)
  801875:	e8 e6 f1 ff ff       	call   800a60 <fd2data>
  80187a:	89 c3                	mov    %eax,%ebx
	strcpy(stat->st_name, "<pipe>");
  80187c:	c7 44 24 04 e9 29 80 	movl   $0x8029e9,0x4(%esp)
  801883:	00 
  801884:	89 34 24             	mov    %esi,(%esp)
  801887:	e8 3e e9 ff ff       	call   8001ca <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80188c:	8b 43 04             	mov    0x4(%ebx),%eax
  80188f:	2b 03                	sub    (%ebx),%eax
  801891:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	stat->st_isdir = 0;
  801897:	c7 86 84 00 00 00 00 	movl   $0x0,0x84(%esi)
  80189e:	00 00 00 
	stat->st_dev = &devpipe;
  8018a1:	c7 86 88 00 00 00 3c 	movl   $0x80603c,0x88(%esi)
  8018a8:	60 80 00 
	return 0;
}
  8018ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b0:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  8018b3:	8b 75 fc             	mov    -0x4(%ebp),%esi
  8018b6:	89 ec                	mov    %ebp,%esp
  8018b8:	5d                   	pop    %ebp
  8018b9:	c3                   	ret    

008018ba <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
  8018bd:	53                   	push   %ebx
  8018be:	83 ec 14             	sub    $0x14,%esp
  8018c1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8018c4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8018c8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018cf:	e8 96 ef ff ff       	call   80086a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8018d4:	89 1c 24             	mov    %ebx,(%esp)
  8018d7:	e8 84 f1 ff ff       	call   800a60 <fd2data>
  8018dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8018e7:	e8 7e ef ff ff       	call   80086a <sys_page_unmap>
}
  8018ec:	83 c4 14             	add    $0x14,%esp
  8018ef:	5b                   	pop    %ebx
  8018f0:	5d                   	pop    %ebp
  8018f1:	c3                   	ret    

008018f2 <_pipeisclosed>:
	return r;
}

static int
_pipeisclosed(struct Fd *fd, struct Pipe *p)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	57                   	push   %edi
  8018f6:	56                   	push   %esi
  8018f7:	53                   	push   %ebx
  8018f8:	83 ec 2c             	sub    $0x2c,%esp
  8018fb:	89 c7                	mov    %eax,%edi
  8018fd:	89 55 e4             	mov    %edx,-0x1c(%ebp)
	int n, nn, ret;

	while (1) {
		n = env->env_runs;
  801900:	a1 74 60 80 00       	mov    0x806074,%eax
  801905:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801908:	89 3c 24             	mov    %edi,(%esp)
  80190b:	e8 f8 0c 00 00       	call   802608 <pageref>
  801910:	89 c6                	mov    %eax,%esi
  801912:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801915:	89 04 24             	mov    %eax,(%esp)
  801918:	e8 eb 0c 00 00       	call   802608 <pageref>
  80191d:	39 c6                	cmp    %eax,%esi
  80191f:	0f 94 c0             	sete   %al
  801922:	0f b6 c0             	movzbl %al,%eax
		nn = env->env_runs;
  801925:	8b 15 74 60 80 00    	mov    0x806074,%edx
  80192b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80192e:	39 cb                	cmp    %ecx,%ebx
  801930:	75 08                	jne    80193a <_pipeisclosed+0x48>
			return ret;
		if (n != nn && ret == 1)
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
	}
}
  801932:	83 c4 2c             	add    $0x2c,%esp
  801935:	5b                   	pop    %ebx
  801936:	5e                   	pop    %esi
  801937:	5f                   	pop    %edi
  801938:	5d                   	pop    %ebp
  801939:	c3                   	ret    
		n = env->env_runs;
		ret = pageref(fd) == pageref(p);
		nn = env->env_runs;
		if (n == nn)
			return ret;
		if (n != nn && ret == 1)
  80193a:	83 f8 01             	cmp    $0x1,%eax
  80193d:	75 c1                	jne    801900 <_pipeisclosed+0xe>
			cprintf("pipe race avoided\n", n, env->env_runs, ret);
  80193f:	8b 52 58             	mov    0x58(%edx),%edx
  801942:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801946:	89 54 24 08          	mov    %edx,0x8(%esp)
  80194a:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80194e:	c7 04 24 f0 29 80 00 	movl   $0x8029f0,(%esp)
  801955:	e8 57 05 00 00       	call   801eb1 <cprintf>
  80195a:	eb a4                	jmp    801900 <_pipeisclosed+0xe>

0080195c <devpipe_write>:
	return i;
}

static ssize_t
devpipe_write(struct Fd *fd, const void *vbuf, size_t n)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	57                   	push   %edi
  801960:	56                   	push   %esi
  801961:	53                   	push   %ebx
  801962:	83 ec 1c             	sub    $0x1c,%esp
  801965:	8b 75 08             	mov    0x8(%ebp),%esi
	const uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*) fd2data(fd);
  801968:	89 34 24             	mov    %esi,(%esp)
  80196b:	e8 f0 f0 ff ff       	call   800a60 <fd2data>
  801970:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801972:	bf 00 00 00 00       	mov    $0x0,%edi
  801977:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80197b:	75 54                	jne    8019d1 <devpipe_write+0x75>
  80197d:	eb 60                	jmp    8019df <devpipe_write+0x83>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
			// pipe is full
			// if all the readers are gone
			// (it's only writers like us now),
			// note eof
			if (_pipeisclosed(fd, p))
  80197f:	89 da                	mov    %ebx,%edx
  801981:	89 f0                	mov    %esi,%eax
  801983:	e8 6a ff ff ff       	call   8018f2 <_pipeisclosed>
  801988:	85 c0                	test   %eax,%eax
  80198a:	74 07                	je     801993 <devpipe_write+0x37>
  80198c:	b8 00 00 00 00       	mov    $0x0,%eax
  801991:	eb 53                	jmp    8019e6 <devpipe_write+0x8a>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_write yield\n");
			sys_yield();
  801993:	90                   	nop
  801994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801998:	e8 e8 ef ff ff       	call   800985 <sys_yield>
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  80199d:	8b 43 04             	mov    0x4(%ebx),%eax
  8019a0:	8b 13                	mov    (%ebx),%edx
  8019a2:	83 c2 20             	add    $0x20,%edx
  8019a5:	39 d0                	cmp    %edx,%eax
  8019a7:	73 d6                	jae    80197f <devpipe_write+0x23>
				cprintf("devpipe_write yield\n");
			sys_yield();
		}
		// there's room for a byte.  store it.
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8019a9:	89 c2                	mov    %eax,%edx
  8019ab:	c1 fa 1f             	sar    $0x1f,%edx
  8019ae:	c1 ea 1b             	shr    $0x1b,%edx
  8019b1:	01 d0                	add    %edx,%eax
  8019b3:	83 e0 1f             	and    $0x1f,%eax
  8019b6:	29 d0                	sub    %edx,%eax
  8019b8:	89 c2                	mov    %eax,%edx
  8019ba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019bd:	0f b6 04 39          	movzbl (%ecx,%edi,1),%eax
  8019c1:	88 44 13 08          	mov    %al,0x8(%ebx,%edx,1)
		p->p_wpos++;
  8019c5:	83 43 04 01          	addl   $0x1,0x4(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_write %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  8019c9:	83 c7 01             	add    $0x1,%edi
  8019cc:	39 7d 10             	cmp    %edi,0x10(%ebp)
  8019cf:	76 13                	jbe    8019e4 <devpipe_write+0x88>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019d1:	8b 43 04             	mov    0x4(%ebx),%eax
  8019d4:	8b 13                	mov    (%ebx),%edx
  8019d6:	83 c2 20             	add    $0x20,%edx
  8019d9:	39 d0                	cmp    %edx,%eax
  8019db:	73 a2                	jae    80197f <devpipe_write+0x23>
  8019dd:	eb ca                	jmp    8019a9 <devpipe_write+0x4d>
  8019df:	bf 00 00 00 00       	mov    $0x0,%edi
		// wait to increment wpos until the byte is stored!
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
		p->p_wpos++;
	}
	
	return i;
  8019e4:	89 f8                	mov    %edi,%eax
}
  8019e6:	83 c4 1c             	add    $0x1c,%esp
  8019e9:	5b                   	pop    %ebx
  8019ea:	5e                   	pop    %esi
  8019eb:	5f                   	pop    %edi
  8019ec:	5d                   	pop    %ebp
  8019ed:	c3                   	ret    

008019ee <devpipe_read>:
	return _pipeisclosed(fd, p);
}

static ssize_t
devpipe_read(struct Fd *fd, void *vbuf, size_t n)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	83 ec 28             	sub    $0x28,%esp
  8019f4:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  8019f7:	89 75 f8             	mov    %esi,-0x8(%ebp)
  8019fa:	89 7d fc             	mov    %edi,-0x4(%ebp)
  8019fd:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint8_t *buf;
	size_t i;
	struct Pipe *p;

	p = (struct Pipe*)fd2data(fd);
  801a00:	89 3c 24             	mov    %edi,(%esp)
  801a03:	e8 58 f0 ff ff       	call   800a60 <fd2data>
  801a08:	89 c3                	mov    %eax,%ebx
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a0a:	be 00 00 00 00       	mov    $0x0,%esi
  801a0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a13:	75 4c                	jne    801a61 <devpipe_read+0x73>
  801a15:	eb 5b                	jmp    801a72 <devpipe_read+0x84>
		while (p->p_rpos == p->p_wpos) {
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
				return i;
  801a17:	89 f0                	mov    %esi,%eax
  801a19:	eb 5e                	jmp    801a79 <devpipe_read+0x8b>
			// if all the writers are gone, note eof
			if (_pipeisclosed(fd, p))
  801a1b:	89 da                	mov    %ebx,%edx
  801a1d:	89 f8                	mov    %edi,%eax
  801a1f:	90                   	nop
  801a20:	e8 cd fe ff ff       	call   8018f2 <_pipeisclosed>
  801a25:	85 c0                	test   %eax,%eax
  801a27:	74 07                	je     801a30 <devpipe_read+0x42>
  801a29:	b8 00 00 00 00       	mov    $0x0,%eax
  801a2e:	eb 49                	jmp    801a79 <devpipe_read+0x8b>
				return 0;
			// yield and see what happens
			if (debug)
				cprintf("devpipe_read yield\n");
			sys_yield();
  801a30:	e8 50 ef ff ff       	call   800985 <sys_yield>
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
		while (p->p_rpos == p->p_wpos) {
  801a35:	8b 03                	mov    (%ebx),%eax
  801a37:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a3a:	74 df                	je     801a1b <devpipe_read+0x2d>
				cprintf("devpipe_read yield\n");
			sys_yield();
		}
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a3c:	89 c2                	mov    %eax,%edx
  801a3e:	c1 fa 1f             	sar    $0x1f,%edx
  801a41:	c1 ea 1b             	shr    $0x1b,%edx
  801a44:	01 d0                	add    %edx,%eax
  801a46:	83 e0 1f             	and    $0x1f,%eax
  801a49:	29 d0                	sub    %edx,%eax
  801a4b:	0f b6 44 03 08       	movzbl 0x8(%ebx,%eax,1),%eax
  801a50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a53:	88 04 32             	mov    %al,(%edx,%esi,1)
		p->p_rpos++;
  801a56:	83 03 01             	addl   $0x1,(%ebx)
	if (debug)
		cprintf("[%08x] devpipe_read %08x %d rpos %d wpos %d\n",
			env->env_id, vpt[VPN(p)], n, p->p_rpos, p->p_wpos);

	buf = vbuf;
	for (i = 0; i < n; i++) {
  801a59:	83 c6 01             	add    $0x1,%esi
  801a5c:	39 75 10             	cmp    %esi,0x10(%ebp)
  801a5f:	76 16                	jbe    801a77 <devpipe_read+0x89>
		while (p->p_rpos == p->p_wpos) {
  801a61:	8b 03                	mov    (%ebx),%eax
  801a63:	3b 43 04             	cmp    0x4(%ebx),%eax
  801a66:	75 d4                	jne    801a3c <devpipe_read+0x4e>
			// pipe is empty
			// if we got any data, return it
			if (i > 0)
  801a68:	85 f6                	test   %esi,%esi
  801a6a:	75 ab                	jne    801a17 <devpipe_read+0x29>
  801a6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  801a70:	eb a9                	jmp    801a1b <devpipe_read+0x2d>
  801a72:	be 00 00 00 00       	mov    $0x0,%esi
		// there's a byte.  take it.
		// wait to increment rpos until the byte is taken!
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
		p->p_rpos++;
	}
	return i;
  801a77:	89 f0                	mov    %esi,%eax
}
  801a79:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801a7c:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801a7f:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801a82:	89 ec                	mov    %ebp,%esp
  801a84:	5d                   	pop    %ebp
  801a85:	c3                   	ret    

00801a86 <pipeisclosed>:
	}
}

int
pipeisclosed(int fdnum)
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
  801a89:	83 ec 28             	sub    $0x28,%esp
	struct Fd *fd;
	struct Pipe *p;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801a93:	8b 45 08             	mov    0x8(%ebp),%eax
  801a96:	89 04 24             	mov    %eax,(%esp)
  801a99:	e8 4f f0 ff ff       	call   800aed <fd_lookup>
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	78 15                	js     801ab7 <pipeisclosed+0x31>
		return r;
	p = (struct Pipe*) fd2data(fd);
  801aa2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aa5:	89 04 24             	mov    %eax,(%esp)
  801aa8:	e8 b3 ef ff ff       	call   800a60 <fd2data>
	return _pipeisclosed(fd, p);
  801aad:	89 c2                	mov    %eax,%edx
  801aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab2:	e8 3b fe ff ff       	call   8018f2 <_pipeisclosed>
}
  801ab7:	c9                   	leave  
  801ab8:	c3                   	ret    

00801ab9 <pipe>:
	uint8_t p_buf[PIPEBUFSIZ];	// data buffer
};

int
pipe(int pfd[2])
{
  801ab9:	55                   	push   %ebp
  801aba:	89 e5                	mov    %esp,%ebp
  801abc:	83 ec 48             	sub    $0x48,%esp
  801abf:	89 5d f4             	mov    %ebx,-0xc(%ebp)
  801ac2:	89 75 f8             	mov    %esi,-0x8(%ebp)
  801ac5:	89 7d fc             	mov    %edi,-0x4(%ebp)
  801ac8:	8b 7d 08             	mov    0x8(%ebp),%edi
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801acb:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ace:	89 04 24             	mov    %eax,(%esp)
  801ad1:	e8 a5 ef ff ff       	call   800a7b <fd_alloc>
  801ad6:	89 c3                	mov    %eax,%ebx
  801ad8:	85 c0                	test   %eax,%eax
  801ada:	0f 88 42 01 00 00    	js     801c22 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ae0:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801ae7:	00 
  801ae8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801aeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  801aef:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801af6:	e8 2b ee ff ff       	call   800926 <sys_page_alloc>
  801afb:	89 c3                	mov    %eax,%ebx
	int r;
	struct Fd *fd0, *fd1;
	void *va;

	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
  801afd:	85 c0                	test   %eax,%eax
  801aff:	0f 88 1d 01 00 00    	js     801c22 <pipe+0x169>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801b05:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801b08:	89 04 24             	mov    %eax,(%esp)
  801b0b:	e8 6b ef ff ff       	call   800a7b <fd_alloc>
  801b10:	89 c3                	mov    %eax,%ebx
  801b12:	85 c0                	test   %eax,%eax
  801b14:	0f 88 f5 00 00 00    	js     801c0f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b1a:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b21:	00 
  801b22:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b25:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b29:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b30:	e8 f1 ed ff ff       	call   800926 <sys_page_alloc>
  801b35:	89 c3                	mov    %eax,%ebx
	// allocate the file descriptor table entries
	if ((r = fd_alloc(&fd0)) < 0
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err;

	if ((r = fd_alloc(&fd1)) < 0
  801b37:	85 c0                	test   %eax,%eax
  801b39:	0f 88 d0 00 00 00    	js     801c0f <pipe+0x156>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
		goto err1;

	// allocate the pipe structure as first data page in both
	va = fd2data(fd0);
  801b3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b42:	89 04 24             	mov    %eax,(%esp)
  801b45:	e8 16 ef ff ff       	call   800a60 <fd2data>
  801b4a:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b4c:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801b53:	00 
  801b54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801b58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b5f:	e8 c2 ed ff ff       	call   800926 <sys_page_alloc>
  801b64:	89 c3                	mov    %eax,%ebx
  801b66:	85 c0                	test   %eax,%eax
  801b68:	0f 88 8e 00 00 00    	js     801bfc <pipe+0x143>
		goto err2;
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801b71:	89 04 24             	mov    %eax,(%esp)
  801b74:	e8 e7 ee ff ff       	call   800a60 <fd2data>
  801b79:	c7 44 24 10 07 04 00 	movl   $0x407,0x10(%esp)
  801b80:	00 
  801b81:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801b85:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  801b8c:	00 
  801b8d:	89 74 24 04          	mov    %esi,0x4(%esp)
  801b91:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801b98:	e8 2b ed ff ff       	call   8008c8 <sys_page_map>
  801b9d:	89 c3                	mov    %eax,%ebx
  801b9f:	85 c0                	test   %eax,%eax
  801ba1:	78 49                	js     801bec <pipe+0x133>
		goto err3;

	// set up fd structures
	fd0->fd_dev_id = devpipe.dev_id;
  801ba3:	b8 3c 60 80 00       	mov    $0x80603c,%eax
  801ba8:	8b 08                	mov    (%eax),%ecx
  801baa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bad:	89 0a                	mov    %ecx,(%edx)
	fd0->fd_omode = O_RDONLY;
  801baf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801bb2:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)

	fd1->fd_dev_id = devpipe.dev_id;
  801bb9:	8b 10                	mov    (%eax),%edx
  801bbb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bbe:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801bc0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bc3:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)

	if (debug)
		cprintf("[%08x] pipecreate %08x\n", env->env_id, vpt[VPN(va)]);

	pfd[0] = fd2num(fd0);
  801bca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801bcd:	89 04 24             	mov    %eax,(%esp)
  801bd0:	e8 7b ee ff ff       	call   800a50 <fd2num>
  801bd5:	89 07                	mov    %eax,(%edi)
	pfd[1] = fd2num(fd1);
  801bd7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bda:	89 04 24             	mov    %eax,(%esp)
  801bdd:	e8 6e ee ff ff       	call   800a50 <fd2num>
  801be2:	89 47 04             	mov    %eax,0x4(%edi)
  801be5:	bb 00 00 00 00       	mov    $0x0,%ebx
	return 0;
  801bea:	eb 36                	jmp    801c22 <pipe+0x169>

    err3:
	sys_page_unmap(0, va);
  801bec:	89 74 24 04          	mov    %esi,0x4(%esp)
  801bf0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801bf7:	e8 6e ec ff ff       	call   80086a <sys_page_unmap>
    err2:
	sys_page_unmap(0, fd1);
  801bfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c0a:	e8 5b ec ff ff       	call   80086a <sys_page_unmap>
    err1:
	sys_page_unmap(0, fd0);
  801c0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801c12:	89 44 24 04          	mov    %eax,0x4(%esp)
  801c16:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801c1d:	e8 48 ec ff ff       	call   80086a <sys_page_unmap>
    err:
	return r;
}
  801c22:	89 d8                	mov    %ebx,%eax
  801c24:	8b 5d f4             	mov    -0xc(%ebp),%ebx
  801c27:	8b 75 f8             	mov    -0x8(%ebp),%esi
  801c2a:	8b 7d fc             	mov    -0x4(%ebp),%edi
  801c2d:	89 ec                	mov    %ebp,%esp
  801c2f:	5d                   	pop    %ebp
  801c30:	c3                   	ret    
	...

00801c40 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801c43:	b8 00 00 00 00       	mov    $0x0,%eax
  801c48:	5d                   	pop    %ebp
  801c49:	c3                   	ret    

00801c4a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c4a:	55                   	push   %ebp
  801c4b:	89 e5                	mov    %esp,%ebp
  801c4d:	83 ec 18             	sub    $0x18,%esp
	strcpy(stat->st_name, "<cons>");
  801c50:	c7 44 24 04 08 2a 80 	movl   $0x802a08,0x4(%esp)
  801c57:	00 
  801c58:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c5b:	89 04 24             	mov    %eax,(%esp)
  801c5e:	e8 67 e5 ff ff       	call   8001ca <strcpy>
	return 0;
}
  801c63:	b8 00 00 00 00       	mov    $0x0,%eax
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <devcons_write>:
	return 1;
}

static ssize_t
devcons_write(struct Fd *fd, const void *vbuf, size_t n)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
  801c6d:	57                   	push   %edi
  801c6e:	56                   	push   %esi
  801c6f:	53                   	push   %ebx
  801c70:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801c76:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7b:	be 00 00 00 00       	mov    $0x0,%esi
  801c80:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c84:	74 3f                	je     801cc5 <devcons_write+0x5b>
		m = n - tot;
		if (m > sizeof(buf) - 1)
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801c86:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
		m = n - tot;
  801c8c:	8b 55 10             	mov    0x10(%ebp),%edx
  801c8f:	29 c2                	sub    %eax,%edx
  801c91:	89 d3                	mov    %edx,%ebx
		if (m > sizeof(buf) - 1)
  801c93:	83 fa 7f             	cmp    $0x7f,%edx
  801c96:	76 05                	jbe    801c9d <devcons_write+0x33>
  801c98:	bb 7f 00 00 00       	mov    $0x7f,%ebx
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
  801c9d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ca1:	03 45 0c             	add    0xc(%ebp),%eax
  801ca4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ca8:	89 3c 24             	mov    %edi,(%esp)
  801cab:	e8 d5 e6 ff ff       	call   800385 <memmove>
		sys_cputs(buf, m);
  801cb0:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cb4:	89 3c 24             	mov    %edi,(%esp)
  801cb7:	e8 04 e9 ff ff       	call   8005c0 <sys_cputs>
	int tot, m;
	char buf[128];

	// mistake: have to nul-terminate arg to sys_cputs, 
	// so we have to copy vbuf into buf in chunks and nul-terminate.
	for (tot = 0; tot < n; tot += m) {
  801cbc:	01 de                	add    %ebx,%esi
  801cbe:	89 f0                	mov    %esi,%eax
  801cc0:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cc3:	72 c7                	jb     801c8c <devcons_write+0x22>
			m = sizeof(buf) - 1;
		memmove(buf, (char*)vbuf + tot, m);
		sys_cputs(buf, m);
	}
	return tot;
}
  801cc5:	89 f0                	mov    %esi,%eax
  801cc7:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  801ccd:	5b                   	pop    %ebx
  801cce:	5e                   	pop    %esi
  801ccf:	5f                   	pop    %edi
  801cd0:	5d                   	pop    %ebp
  801cd1:	c3                   	ret    

00801cd2 <cputchar>:
#include <inc/string.h>
#include <inc/lib.h>

void
cputchar(int ch)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
  801cd5:	83 ec 28             	sub    $0x28,%esp
	char c = ch;
  801cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdb:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	sys_cputs(&c, 1);
  801cde:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  801ce5:	00 
  801ce6:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ce9:	89 04 24             	mov    %eax,(%esp)
  801cec:	e8 cf e8 ff ff       	call   8005c0 <sys_cputs>
}
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <devcons_read>:
	return fd2num(fd);
}

static ssize_t
devcons_read(struct Fd *fd, void *vbuf, size_t n)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
  801cf6:	83 ec 08             	sub    $0x8,%esp
	int c;

	if (n == 0)
  801cf9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cfd:	75 07                	jne    801d06 <devcons_read+0x13>
  801cff:	eb 28                	jmp    801d29 <devcons_read+0x36>
		return 0;

	while ((c = sys_cgetc()) == 0)
		sys_yield();
  801d01:	e8 7f ec ff ff       	call   800985 <sys_yield>
	int c;

	if (n == 0)
		return 0;

	while ((c = sys_cgetc()) == 0)
  801d06:	66 90                	xchg   %ax,%ax
  801d08:	e8 7f e8 ff ff       	call   80058c <sys_cgetc>
  801d0d:	85 c0                	test   %eax,%eax
  801d0f:	90                   	nop
  801d10:	74 ef                	je     801d01 <devcons_read+0xe>
  801d12:	89 c2                	mov    %eax,%edx
		sys_yield();
	if (c < 0)
  801d14:	85 c0                	test   %eax,%eax
  801d16:	78 16                	js     801d2e <devcons_read+0x3b>
		return c;
	if (c == 0x04)	// ctl-d is eof
  801d18:	83 f8 04             	cmp    $0x4,%eax
  801d1b:	74 0c                	je     801d29 <devcons_read+0x36>
		return 0;
	*(char*)vbuf = c;
  801d1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d20:	88 10                	mov    %dl,(%eax)
  801d22:	b8 01 00 00 00       	mov    $0x1,%eax
	return 1;
  801d27:	eb 05                	jmp    801d2e <devcons_read+0x3b>
  801d29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2e:	c9                   	leave  
  801d2f:	c3                   	ret    

00801d30 <opencons>:
	return fd->fd_dev_id == devcons.dev_id;
}

int
opencons(void)
{
  801d30:	55                   	push   %ebp
  801d31:	89 e5                	mov    %esp,%ebp
  801d33:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd* fd;

	if ((r = fd_alloc(&fd)) < 0)
  801d36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d39:	89 04 24             	mov    %eax,(%esp)
  801d3c:	e8 3a ed ff ff       	call   800a7b <fd_alloc>
  801d41:	85 c0                	test   %eax,%eax
  801d43:	78 3f                	js     801d84 <opencons+0x54>
		return r;
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d45:	c7 44 24 08 07 04 00 	movl   $0x407,0x8(%esp)
  801d4c:	00 
  801d4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d50:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d54:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801d5b:	e8 c6 eb ff ff       	call   800926 <sys_page_alloc>
  801d60:	85 c0                	test   %eax,%eax
  801d62:	78 20                	js     801d84 <opencons+0x54>
		return r;
	fd->fd_dev_id = devcons.dev_id;
  801d64:	8b 15 58 60 80 00    	mov    0x806058,%edx
  801d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6d:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d72:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7c:	89 04 24             	mov    %eax,(%esp)
  801d7f:	e8 cc ec ff ff       	call   800a50 <fd2num>
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <iscons>:
	.dev_stat =	devcons_stat
};

int
iscons(int fdnum)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 28             	sub    $0x28,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d8c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d93:	8b 45 08             	mov    0x8(%ebp),%eax
  801d96:	89 04 24             	mov    %eax,(%esp)
  801d99:	e8 4f ed ff ff       	call   800aed <fd_lookup>
  801d9e:	85 c0                	test   %eax,%eax
  801da0:	78 11                	js     801db3 <iscons+0x2d>
		return r;
	return fd->fd_dev_id == devcons.dev_id;
  801da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801da5:	8b 00                	mov    (%eax),%eax
  801da7:	3b 05 58 60 80 00    	cmp    0x806058,%eax
  801dad:	0f 94 c0             	sete   %al
  801db0:	0f b6 c0             	movzbl %al,%eax
}
  801db3:	c9                   	leave  
  801db4:	c3                   	ret    

00801db5 <getchar>:
	sys_cputs(&c, 1);
}

int
getchar(void)
{
  801db5:	55                   	push   %ebp
  801db6:	89 e5                	mov    %esp,%ebp
  801db8:	83 ec 28             	sub    $0x28,%esp
	int r;

	// JOS does, however, support standard _input_ redirection,
	// allowing the user to redirect script files to the shell and such.
	// getchar() reads a character from file descriptor 0.
	r = read(0, &c, 1);
  801dbb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  801dc2:	00 
  801dc3:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801dc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  801dca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  801dd1:	e8 78 ef ff ff       	call   800d4e <read>
	if (r < 0)
  801dd6:	85 c0                	test   %eax,%eax
  801dd8:	78 0f                	js     801de9 <getchar+0x34>
		return r;
	if (r < 1)
  801dda:	85 c0                	test   %eax,%eax
  801ddc:	7f 07                	jg     801de5 <getchar+0x30>
  801dde:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801de3:	eb 04                	jmp    801de9 <getchar+0x34>
		return -E_EOF;
	return c;
  801de5:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    
	...

00801dec <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
  801def:	53                   	push   %ebx
  801df0:	83 ec 14             	sub    $0x14,%esp
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
  801df3:	8d 5d 14             	lea    0x14(%ebp),%ebx
	va_list ap;

	va_start(ap, fmt);

	// Print the panic message
	if (argv0)
  801df6:	a1 78 60 80 00       	mov    0x806078,%eax
  801dfb:	85 c0                	test   %eax,%eax
  801dfd:	74 10                	je     801e0f <_panic+0x23>
		cprintf("%s: ", argv0);
  801dff:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e03:	c7 04 24 14 2a 80 00 	movl   $0x802a14,(%esp)
  801e0a:	e8 a2 00 00 00       	call   801eb1 <cprintf>
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801e0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e12:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e16:	8b 45 08             	mov    0x8(%ebp),%eax
  801e19:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e1d:	a1 00 60 80 00       	mov    0x806000,%eax
  801e22:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e26:	c7 04 24 19 2a 80 00 	movl   $0x802a19,(%esp)
  801e2d:	e8 7f 00 00 00       	call   801eb1 <cprintf>
	vcprintf(fmt, ap);
  801e32:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e36:	8b 45 10             	mov    0x10(%ebp),%eax
  801e39:	89 04 24             	mov    %eax,(%esp)
  801e3c:	e8 0f 00 00 00       	call   801e50 <vcprintf>
	cprintf("\n");
  801e41:	c7 04 24 01 2a 80 00 	movl   $0x802a01,(%esp)
  801e48:	e8 64 00 00 00       	call   801eb1 <cprintf>

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801e4d:	cc                   	int3   
  801e4e:	eb fd                	jmp    801e4d <_panic+0x61>

00801e50 <vcprintf>:
	b->cnt++;
}

int
vcprintf(const char *fmt, va_list ap)
{
  801e50:	55                   	push   %ebp
  801e51:	89 e5                	mov    %esp,%ebp
  801e53:	81 ec 28 01 00 00    	sub    $0x128,%esp
	struct printbuf b;

	b.idx = 0;
  801e59:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801e60:	00 00 00 
	b.cnt = 0;
  801e63:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801e6a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801e6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e70:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e74:	8b 45 08             	mov    0x8(%ebp),%eax
  801e77:	89 44 24 08          	mov    %eax,0x8(%esp)
  801e7b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801e81:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e85:	c7 04 24 cb 1e 80 00 	movl   $0x801ecb,(%esp)
  801e8c:	e8 cc 01 00 00       	call   80205d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801e91:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801e97:	89 44 24 04          	mov    %eax,0x4(%esp)
  801e9b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801ea1:	89 04 24             	mov    %eax,(%esp)
  801ea4:	e8 17 e7 ff ff       	call   8005c0 <sys_cputs>

	return b.cnt;
}
  801ea9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
cprintf(const char *fmt, ...)
  801eb7:	8d 45 0c             	lea    0xc(%ebp),%eax
{
	va_list ap;
	int cnt;

	va_start(ap, fmt);
	cnt = vcprintf(fmt, ap);
  801eba:	89 44 24 04          	mov    %eax,0x4(%esp)
  801ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec1:	89 04 24             	mov    %eax,(%esp)
  801ec4:	e8 87 ff ff ff       	call   801e50 <vcprintf>
	va_end(ap);

	return cnt;
}
  801ec9:	c9                   	leave  
  801eca:	c3                   	ret    

00801ecb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801ecb:	55                   	push   %ebp
  801ecc:	89 e5                	mov    %esp,%ebp
  801ece:	53                   	push   %ebx
  801ecf:	83 ec 14             	sub    $0x14,%esp
  801ed2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801ed5:	8b 03                	mov    (%ebx),%eax
  801ed7:	8b 55 08             	mov    0x8(%ebp),%edx
  801eda:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
  801ede:	83 c0 01             	add    $0x1,%eax
  801ee1:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
  801ee3:	3d ff 00 00 00       	cmp    $0xff,%eax
  801ee8:	75 19                	jne    801f03 <putch+0x38>
		sys_cputs(b->buf, b->idx);
  801eea:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
  801ef1:	00 
  801ef2:	8d 43 08             	lea    0x8(%ebx),%eax
  801ef5:	89 04 24             	mov    %eax,(%esp)
  801ef8:	e8 c3 e6 ff ff       	call   8005c0 <sys_cputs>
		b->idx = 0;
  801efd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
  801f03:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
  801f07:	83 c4 14             	add    $0x14,%esp
  801f0a:	5b                   	pop    %ebx
  801f0b:	5d                   	pop    %ebp
  801f0c:	c3                   	ret    
  801f0d:	00 00                	add    %al,(%eax)
	...

00801f10 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	57                   	push   %edi
  801f14:	56                   	push   %esi
  801f15:	53                   	push   %ebx
  801f16:	83 ec 4c             	sub    $0x4c,%esp
  801f19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801f1c:	89 d6                	mov    %edx,%esi
  801f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801f21:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801f24:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f27:	89 55 e0             	mov    %edx,-0x20(%ebp)
  801f2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801f2d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f30:	8b 7d 18             	mov    0x18(%ebp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801f33:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801f36:	b9 00 00 00 00       	mov    $0x0,%ecx
  801f3b:	39 d1                	cmp    %edx,%ecx
  801f3d:	72 15                	jb     801f54 <printnum+0x44>
  801f3f:	77 07                	ja     801f48 <printnum+0x38>
  801f41:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801f44:	39 d0                	cmp    %edx,%eax
  801f46:	76 0c                	jbe    801f54 <printnum+0x44>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801f48:	83 eb 01             	sub    $0x1,%ebx
  801f4b:	85 db                	test   %ebx,%ebx
  801f4d:	8d 76 00             	lea    0x0(%esi),%esi
  801f50:	7f 61                	jg     801fb3 <printnum+0xa3>
  801f52:	eb 70                	jmp    801fc4 <printnum+0xb4>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801f54:	89 7c 24 10          	mov    %edi,0x10(%esp)
  801f58:	83 eb 01             	sub    $0x1,%ebx
  801f5b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801f5f:	89 44 24 08          	mov    %eax,0x8(%esp)
  801f63:	8b 4c 24 08          	mov    0x8(%esp),%ecx
  801f67:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
  801f6b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  801f6e:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  801f71:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  801f74:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f78:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801f7f:	00 
  801f80:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801f83:	89 04 24             	mov    %eax,(%esp)
  801f86:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801f89:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f8d:	e8 be 06 00 00       	call   802650 <__udivdi3>
  801f92:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801f95:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  801f98:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f9c:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  801fa0:	89 04 24             	mov    %eax,(%esp)
  801fa3:	89 54 24 04          	mov    %edx,0x4(%esp)
  801fa7:	89 f2                	mov    %esi,%edx
  801fa9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801fac:	e8 5f ff ff ff       	call   801f10 <printnum>
  801fb1:	eb 11                	jmp    801fc4 <printnum+0xb4>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801fb3:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fb7:	89 3c 24             	mov    %edi,(%esp)
  801fba:	ff 55 e4             	call   *-0x1c(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  801fbd:	83 eb 01             	sub    $0x1,%ebx
  801fc0:	85 db                	test   %ebx,%ebx
  801fc2:	7f ef                	jg     801fb3 <printnum+0xa3>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  801fc4:	89 74 24 04          	mov    %esi,0x4(%esp)
  801fc8:	8b 74 24 04          	mov    0x4(%esp),%esi
  801fcc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801fcf:	89 44 24 08          	mov    %eax,0x8(%esp)
  801fd3:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  801fda:	00 
  801fdb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801fde:	89 14 24             	mov    %edx,(%esp)
  801fe1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801fe4:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fe8:	e8 93 07 00 00       	call   802780 <__umoddi3>
  801fed:	89 74 24 04          	mov    %esi,0x4(%esp)
  801ff1:	0f be 80 35 2a 80 00 	movsbl 0x802a35(%eax),%eax
  801ff8:	89 04 24             	mov    %eax,(%esp)
  801ffb:	ff 55 e4             	call   *-0x1c(%ebp)
}
  801ffe:	83 c4 4c             	add    $0x4c,%esp
  802001:	5b                   	pop    %ebx
  802002:	5e                   	pop    %esi
  802003:	5f                   	pop    %edi
  802004:	5d                   	pop    %ebp
  802005:	c3                   	ret    

00802006 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  802009:	83 fa 01             	cmp    $0x1,%edx
  80200c:	7e 0e                	jle    80201c <getuint+0x16>
		return va_arg(*ap, unsigned long long);
  80200e:	8b 10                	mov    (%eax),%edx
  802010:	8d 4a 08             	lea    0x8(%edx),%ecx
  802013:	89 08                	mov    %ecx,(%eax)
  802015:	8b 02                	mov    (%edx),%eax
  802017:	8b 52 04             	mov    0x4(%edx),%edx
  80201a:	eb 22                	jmp    80203e <getuint+0x38>
	else if (lflag)
  80201c:	85 d2                	test   %edx,%edx
  80201e:	74 10                	je     802030 <getuint+0x2a>
		return va_arg(*ap, unsigned long);
  802020:	8b 10                	mov    (%eax),%edx
  802022:	8d 4a 04             	lea    0x4(%edx),%ecx
  802025:	89 08                	mov    %ecx,(%eax)
  802027:	8b 02                	mov    (%edx),%eax
  802029:	ba 00 00 00 00       	mov    $0x0,%edx
  80202e:	eb 0e                	jmp    80203e <getuint+0x38>
	else
		return va_arg(*ap, unsigned int);
  802030:	8b 10                	mov    (%eax),%edx
  802032:	8d 4a 04             	lea    0x4(%edx),%ecx
  802035:	89 08                	mov    %ecx,(%eax)
  802037:	8b 02                	mov    (%edx),%eax
  802039:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80203e:	5d                   	pop    %ebp
  80203f:	c3                   	ret    

00802040 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  802040:	55                   	push   %ebp
  802041:	89 e5                	mov    %esp,%ebp
  802043:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  802046:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
  80204a:	8b 10                	mov    (%eax),%edx
  80204c:	3b 50 04             	cmp    0x4(%eax),%edx
  80204f:	73 0a                	jae    80205b <sprintputch+0x1b>
		*b->buf++ = ch;
  802051:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802054:	88 0a                	mov    %cl,(%edx)
  802056:	83 c2 01             	add    $0x1,%edx
  802059:	89 10                	mov    %edx,(%eax)
}
  80205b:	5d                   	pop    %ebp
  80205c:	c3                   	ret    

0080205d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80205d:	55                   	push   %ebp
  80205e:	89 e5                	mov    %esp,%ebp
  802060:	57                   	push   %edi
  802061:	56                   	push   %esi
  802062:	53                   	push   %ebx
  802063:	83 ec 5c             	sub    $0x5c,%esp
  802066:	8b 7d 08             	mov    0x8(%ebp),%edi
  802069:	8b 75 0c             	mov    0xc(%ebp),%esi
  80206c:	8b 5d 10             	mov    0x10(%ebp),%ebx
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80206f:	c7 45 c8 ff ff ff ff 	movl   $0xffffffff,-0x38(%ebp)
  802076:	eb 11                	jmp    802089 <vprintfmt+0x2c>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
  802078:	85 c0                	test   %eax,%eax
  80207a:	0f 84 09 04 00 00    	je     802489 <vprintfmt+0x42c>
				return;
			putch(ch, putdat);
  802080:	89 74 24 04          	mov    %esi,0x4(%esp)
  802084:	89 04 24             	mov    %eax,(%esp)
  802087:	ff d7                	call   *%edi
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  802089:	0f b6 03             	movzbl (%ebx),%eax
  80208c:	83 c3 01             	add    $0x1,%ebx
  80208f:	83 f8 25             	cmp    $0x25,%eax
  802092:	75 e4                	jne    802078 <vprintfmt+0x1b>
  802094:	c6 45 dc 20          	movb   $0x20,-0x24(%ebp)
  802098:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  80209f:	c7 45 cc ff ff ff ff 	movl   $0xffffffff,-0x34(%ebp)
  8020a6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8020ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8020b2:	eb 06                	jmp    8020ba <vprintfmt+0x5d>
  8020b4:	c6 45 dc 2d          	movb   $0x2d,-0x24(%ebp)
  8020b8:	89 c3                	mov    %eax,%ebx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8020ba:	0f b6 13             	movzbl (%ebx),%edx
  8020bd:	0f b6 c2             	movzbl %dl,%eax
  8020c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8020c3:	8d 43 01             	lea    0x1(%ebx),%eax
  8020c6:	83 ea 23             	sub    $0x23,%edx
  8020c9:	80 fa 55             	cmp    $0x55,%dl
  8020cc:	0f 87 9a 03 00 00    	ja     80246c <vprintfmt+0x40f>
  8020d2:	0f b6 d2             	movzbl %dl,%edx
  8020d5:	ff 24 95 80 2b 80 00 	jmp    *0x802b80(,%edx,4)
  8020dc:	c6 45 dc 30          	movb   $0x30,-0x24(%ebp)
  8020e0:	eb d6                	jmp    8020b8 <vprintfmt+0x5b>
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
  8020e2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8020e5:	83 ea 30             	sub    $0x30,%edx
  8020e8:	89 55 cc             	mov    %edx,-0x34(%ebp)
				ch = *fmt;
  8020eb:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  8020ee:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8020f1:	83 fb 09             	cmp    $0x9,%ebx
  8020f4:	77 4c                	ja     802142 <vprintfmt+0xe5>
  8020f6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8020f9:	8b 4d cc             	mov    -0x34(%ebp),%ecx
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8020fc:	83 c0 01             	add    $0x1,%eax
				precision = precision * 10 + ch - '0';
  8020ff:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
  802102:	8d 4c 4a d0          	lea    -0x30(%edx,%ecx,2),%ecx
				ch = *fmt;
  802106:	0f be 10             	movsbl (%eax),%edx
				if (ch < '0' || ch > '9')
  802109:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80210c:	83 fb 09             	cmp    $0x9,%ebx
  80210f:	76 eb                	jbe    8020fc <vprintfmt+0x9f>
  802111:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  802114:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  802117:	eb 29                	jmp    802142 <vprintfmt+0xe5>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  802119:	8b 55 14             	mov    0x14(%ebp),%edx
  80211c:	8d 5a 04             	lea    0x4(%edx),%ebx
  80211f:	89 5d 14             	mov    %ebx,0x14(%ebp)
  802122:	8b 12                	mov    (%edx),%edx
  802124:	89 55 cc             	mov    %edx,-0x34(%ebp)
			goto process_precision;
  802127:	eb 19                	jmp    802142 <vprintfmt+0xe5>

		case '.':
			if (width < 0)
  802129:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80212c:	c1 fa 1f             	sar    $0x1f,%edx
  80212f:	f7 d2                	not    %edx
  802131:	21 55 e4             	and    %edx,-0x1c(%ebp)
  802134:	eb 82                	jmp    8020b8 <vprintfmt+0x5b>
  802136:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
			goto reswitch;
  80213d:	e9 76 ff ff ff       	jmp    8020b8 <vprintfmt+0x5b>

		process_precision:
			if (width < 0)
  802142:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802146:	0f 89 6c ff ff ff    	jns    8020b8 <vprintfmt+0x5b>
  80214c:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80214f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802152:	8b 55 c8             	mov    -0x38(%ebp),%edx
  802155:	89 55 cc             	mov    %edx,-0x34(%ebp)
  802158:	e9 5b ff ff ff       	jmp    8020b8 <vprintfmt+0x5b>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80215d:	83 c1 01             	add    $0x1,%ecx
			goto reswitch;
  802160:	e9 53 ff ff ff       	jmp    8020b8 <vprintfmt+0x5b>
  802165:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  802168:	8b 45 14             	mov    0x14(%ebp),%eax
  80216b:	8d 50 04             	lea    0x4(%eax),%edx
  80216e:	89 55 14             	mov    %edx,0x14(%ebp)
  802171:	89 74 24 04          	mov    %esi,0x4(%esp)
  802175:	8b 00                	mov    (%eax),%eax
  802177:	89 04 24             	mov    %eax,(%esp)
  80217a:	ff d7                	call   *%edi
  80217c:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  80217f:	e9 05 ff ff ff       	jmp    802089 <vprintfmt+0x2c>
  802184:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// error message
		case 'e':
			err = va_arg(ap, int);
  802187:	8b 45 14             	mov    0x14(%ebp),%eax
  80218a:	8d 50 04             	lea    0x4(%eax),%edx
  80218d:	89 55 14             	mov    %edx,0x14(%ebp)
  802190:	8b 00                	mov    (%eax),%eax
  802192:	89 c2                	mov    %eax,%edx
  802194:	c1 fa 1f             	sar    $0x1f,%edx
  802197:	31 d0                	xor    %edx,%eax
  802199:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80219b:	83 f8 0f             	cmp    $0xf,%eax
  80219e:	7f 0b                	jg     8021ab <vprintfmt+0x14e>
  8021a0:	8b 14 85 e0 2c 80 00 	mov    0x802ce0(,%eax,4),%edx
  8021a7:	85 d2                	test   %edx,%edx
  8021a9:	75 20                	jne    8021cb <vprintfmt+0x16e>
				printfmt(putch, putdat, "error %d", err);
  8021ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021af:	c7 44 24 08 46 2a 80 	movl   $0x802a46,0x8(%esp)
  8021b6:	00 
  8021b7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021bb:	89 3c 24             	mov    %edi,(%esp)
  8021be:	e8 4e 03 00 00       	call   802511 <printfmt>
  8021c3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
		// error message
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8021c6:	e9 be fe ff ff       	jmp    802089 <vprintfmt+0x2c>
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8021cb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8021cf:	c7 44 24 08 c5 29 80 	movl   $0x8029c5,0x8(%esp)
  8021d6:	00 
  8021d7:	89 74 24 04          	mov    %esi,0x4(%esp)
  8021db:	89 3c 24             	mov    %edi,(%esp)
  8021de:	e8 2e 03 00 00       	call   802511 <printfmt>
  8021e3:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8021e6:	e9 9e fe ff ff       	jmp    802089 <vprintfmt+0x2c>
  8021eb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8021ee:	89 c3                	mov    %eax,%ebx
  8021f0:	8b 4d cc             	mov    -0x34(%ebp),%ecx
  8021f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8021f6:	89 45 c0             	mov    %eax,-0x40(%ebp)
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8021f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8021fc:	8d 50 04             	lea    0x4(%eax),%edx
  8021ff:	89 55 14             	mov    %edx,0x14(%ebp)
  802202:	8b 00                	mov    (%eax),%eax
  802204:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  802207:	85 c0                	test   %eax,%eax
  802209:	75 07                	jne    802212 <vprintfmt+0x1b5>
  80220b:	c7 45 c4 4f 2a 80 00 	movl   $0x802a4f,-0x3c(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
  802212:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
  802216:	7e 06                	jle    80221e <vprintfmt+0x1c1>
  802218:	80 7d dc 2d          	cmpb   $0x2d,-0x24(%ebp)
  80221c:	75 13                	jne    802231 <vprintfmt+0x1d4>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80221e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  802221:	0f be 02             	movsbl (%edx),%eax
  802224:	85 c0                	test   %eax,%eax
  802226:	0f 85 99 00 00 00    	jne    8022c5 <vprintfmt+0x268>
  80222c:	e9 86 00 00 00       	jmp    8022b7 <vprintfmt+0x25a>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802231:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802235:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  802238:	89 0c 24             	mov    %ecx,(%esp)
  80223b:	e8 5b df ff ff       	call   80019b <strnlen>
  802240:	8b 55 c0             	mov    -0x40(%ebp),%edx
  802243:	29 c2                	sub    %eax,%edx
  802245:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  802248:	85 d2                	test   %edx,%edx
  80224a:	7e d2                	jle    80221e <vprintfmt+0x1c1>
					putch(padc, putdat);
  80224c:	0f be 4d dc          	movsbl -0x24(%ebp),%ecx
  802250:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  802253:	89 5d c0             	mov    %ebx,-0x40(%ebp)
  802256:	89 d3                	mov    %edx,%ebx
  802258:	89 74 24 04          	mov    %esi,0x4(%esp)
  80225c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80225f:	89 04 24             	mov    %eax,(%esp)
  802262:	ff d7                	call   *%edi
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  802264:	83 eb 01             	sub    $0x1,%ebx
  802267:	85 db                	test   %ebx,%ebx
  802269:	7f ed                	jg     802258 <vprintfmt+0x1fb>
  80226b:	8b 5d c0             	mov    -0x40(%ebp),%ebx
  80226e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  802275:	eb a7                	jmp    80221e <vprintfmt+0x1c1>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802277:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
  80227b:	74 18                	je     802295 <vprintfmt+0x238>
  80227d:	8d 50 e0             	lea    -0x20(%eax),%edx
  802280:	83 fa 5e             	cmp    $0x5e,%edx
  802283:	76 10                	jbe    802295 <vprintfmt+0x238>
					putch('?', putdat);
  802285:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802289:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  802290:	ff 55 dc             	call   *-0x24(%ebp)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
  802293:	eb 0a                	jmp    80229f <vprintfmt+0x242>
					putch('?', putdat);
				else
					putch(ch, putdat);
  802295:	89 7c 24 04          	mov    %edi,0x4(%esp)
  802299:	89 04 24             	mov    %eax,(%esp)
  80229c:	ff 55 dc             	call   *-0x24(%ebp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80229f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8022a3:	0f be 03             	movsbl (%ebx),%eax
  8022a6:	85 c0                	test   %eax,%eax
  8022a8:	74 05                	je     8022af <vprintfmt+0x252>
  8022aa:	83 c3 01             	add    $0x1,%ebx
  8022ad:	eb 29                	jmp    8022d8 <vprintfmt+0x27b>
  8022af:	89 fe                	mov    %edi,%esi
  8022b1:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8022b4:	8b 5d cc             	mov    -0x34(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8022b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8022bb:	7f 2e                	jg     8022eb <vprintfmt+0x28e>
  8022bd:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8022c0:	e9 c4 fd ff ff       	jmp    802089 <vprintfmt+0x2c>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8022c5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8022c8:	83 c2 01             	add    $0x1,%edx
  8022cb:	89 7d dc             	mov    %edi,-0x24(%ebp)
  8022ce:	89 f7                	mov    %esi,%edi
  8022d0:	8b 75 cc             	mov    -0x34(%ebp),%esi
  8022d3:	89 5d cc             	mov    %ebx,-0x34(%ebp)
  8022d6:	89 d3                	mov    %edx,%ebx
  8022d8:	85 f6                	test   %esi,%esi
  8022da:	78 9b                	js     802277 <vprintfmt+0x21a>
  8022dc:	83 ee 01             	sub    $0x1,%esi
  8022df:	79 96                	jns    802277 <vprintfmt+0x21a>
  8022e1:	89 fe                	mov    %edi,%esi
  8022e3:	8b 7d dc             	mov    -0x24(%ebp),%edi
  8022e6:	8b 5d cc             	mov    -0x34(%ebp),%ebx
  8022e9:	eb cc                	jmp    8022b7 <vprintfmt+0x25a>
  8022eb:	89 5d d0             	mov    %ebx,-0x30(%ebp)
  8022ee:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
  8022f1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8022f5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  8022fc:	ff d7                	call   *%edi
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8022fe:	83 eb 01             	sub    $0x1,%ebx
  802301:	85 db                	test   %ebx,%ebx
  802303:	7f ec                	jg     8022f1 <vprintfmt+0x294>
  802305:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  802308:	e9 7c fd ff ff       	jmp    802089 <vprintfmt+0x2c>
  80230d:	89 45 e0             	mov    %eax,-0x20(%ebp)
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
  802310:	83 f9 01             	cmp    $0x1,%ecx
  802313:	7e 16                	jle    80232b <vprintfmt+0x2ce>
		return va_arg(*ap, long long);
  802315:	8b 45 14             	mov    0x14(%ebp),%eax
  802318:	8d 50 08             	lea    0x8(%eax),%edx
  80231b:	89 55 14             	mov    %edx,0x14(%ebp)
  80231e:	8b 10                	mov    (%eax),%edx
  802320:	8b 48 04             	mov    0x4(%eax),%ecx
  802323:	89 55 d0             	mov    %edx,-0x30(%ebp)
  802326:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  802329:	eb 32                	jmp    80235d <vprintfmt+0x300>
	else if (lflag)
  80232b:	85 c9                	test   %ecx,%ecx
  80232d:	74 18                	je     802347 <vprintfmt+0x2ea>
		return va_arg(*ap, long);
  80232f:	8b 45 14             	mov    0x14(%ebp),%eax
  802332:	8d 50 04             	lea    0x4(%eax),%edx
  802335:	89 55 14             	mov    %edx,0x14(%ebp)
  802338:	8b 00                	mov    (%eax),%eax
  80233a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80233d:	89 c1                	mov    %eax,%ecx
  80233f:	c1 f9 1f             	sar    $0x1f,%ecx
  802342:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  802345:	eb 16                	jmp    80235d <vprintfmt+0x300>
	else
		return va_arg(*ap, int);
  802347:	8b 45 14             	mov    0x14(%ebp),%eax
  80234a:	8d 50 04             	lea    0x4(%eax),%edx
  80234d:	89 55 14             	mov    %edx,0x14(%ebp)
  802350:	8b 00                	mov    (%eax),%eax
  802352:	89 45 d0             	mov    %eax,-0x30(%ebp)
  802355:	89 c2                	mov    %eax,%edx
  802357:	c1 fa 1f             	sar    $0x1f,%edx
  80235a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
				putch(' ', putdat);
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80235d:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  802360:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802363:	b8 0a 00 00 00       	mov    $0xa,%eax
			if ((long long) num < 0) {
  802368:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80236c:	0f 89 b8 00 00 00    	jns    80242a <vprintfmt+0x3cd>
				putch('-', putdat);
  802372:	89 74 24 04          	mov    %esi,0x4(%esp)
  802376:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  80237d:	ff d7                	call   *%edi
				num = -(long long) num;
  80237f:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  802382:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  802385:	f7 d9                	neg    %ecx
  802387:	83 d3 00             	adc    $0x0,%ebx
  80238a:	f7 db                	neg    %ebx
  80238c:	b8 0a 00 00 00       	mov    $0xa,%eax
  802391:	e9 94 00 00 00       	jmp    80242a <vprintfmt+0x3cd>
  802396:	89 45 e0             	mov    %eax,-0x20(%ebp)
			base = 10;
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  802399:	89 ca                	mov    %ecx,%edx
  80239b:	8d 45 14             	lea    0x14(%ebp),%eax
  80239e:	e8 63 fc ff ff       	call   802006 <getuint>
  8023a3:	89 c1                	mov    %eax,%ecx
  8023a5:	89 d3                	mov    %edx,%ebx
  8023a7:	b8 0a 00 00 00       	mov    $0xa,%eax
			base = 10;
			goto number;
  8023ac:	eb 7c                	jmp    80242a <vprintfmt+0x3cd>
  8023ae:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8023b1:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023b5:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8023bc:	ff d7                	call   *%edi
			putch('X', putdat);
  8023be:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023c2:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8023c9:	ff d7                	call   *%edi
			putch('X', putdat);
  8023cb:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023cf:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
  8023d6:	ff d7                	call   *%edi
  8023d8:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  8023db:	e9 a9 fc ff ff       	jmp    802089 <vprintfmt+0x2c>
  8023e0:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// pointer
		case 'p':
			putch('0', putdat);
  8023e3:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023e7:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8023ee:	ff d7                	call   *%edi
			putch('x', putdat);
  8023f0:	89 74 24 04          	mov    %esi,0x4(%esp)
  8023f4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8023fb:	ff d7                	call   *%edi
			num = (unsigned long long)
  8023fd:	8b 45 14             	mov    0x14(%ebp),%eax
  802400:	8d 50 04             	lea    0x4(%eax),%edx
  802403:	89 55 14             	mov    %edx,0x14(%ebp)
  802406:	8b 08                	mov    (%eax),%ecx
  802408:	bb 00 00 00 00       	mov    $0x0,%ebx
  80240d:	b8 10 00 00 00       	mov    $0x10,%eax
				(uintptr_t) va_arg(ap, void *);
			base = 16;
			goto number;
  802412:	eb 16                	jmp    80242a <vprintfmt+0x3cd>
  802414:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  802417:	89 ca                	mov    %ecx,%edx
  802419:	8d 45 14             	lea    0x14(%ebp),%eax
  80241c:	e8 e5 fb ff ff       	call   802006 <getuint>
  802421:	89 c1                	mov    %eax,%ecx
  802423:	89 d3                	mov    %edx,%ebx
  802425:	b8 10 00 00 00       	mov    $0x10,%eax
			base = 16;
		number:
			printnum(putch, putdat, num, base, width, padc);
  80242a:	0f be 55 dc          	movsbl -0x24(%ebp),%edx
  80242e:	89 54 24 10          	mov    %edx,0x10(%esp)
  802432:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802435:	89 54 24 0c          	mov    %edx,0xc(%esp)
  802439:	89 44 24 08          	mov    %eax,0x8(%esp)
  80243d:	89 0c 24             	mov    %ecx,(%esp)
  802440:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802444:	89 f2                	mov    %esi,%edx
  802446:	89 f8                	mov    %edi,%eax
  802448:	e8 c3 fa ff ff       	call   801f10 <printnum>
  80244d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  802450:	e9 34 fc ff ff       	jmp    802089 <vprintfmt+0x2c>
  802455:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802458:	89 45 e0             	mov    %eax,-0x20(%ebp)

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  80245b:	89 74 24 04          	mov    %esi,0x4(%esp)
  80245f:	89 14 24             	mov    %edx,(%esp)
  802462:	ff d7                	call   *%edi
  802464:	8b 5d e0             	mov    -0x20(%ebp),%ebx
			break;
  802467:	e9 1d fc ff ff       	jmp    802089 <vprintfmt+0x2c>
			
		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  80246c:	89 74 24 04          	mov    %esi,0x4(%esp)
  802470:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  802477:	ff d7                	call   *%edi
			for (fmt--; fmt[-1] != '%'; fmt--)
  802479:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80247c:	80 38 25             	cmpb   $0x25,(%eax)
  80247f:	0f 84 04 fc ff ff    	je     802089 <vprintfmt+0x2c>
  802485:	89 c3                	mov    %eax,%ebx
  802487:	eb f0                	jmp    802479 <vprintfmt+0x41c>
				/* do nothing */;
			break;
		}
	}
}
  802489:	83 c4 5c             	add    $0x5c,%esp
  80248c:	5b                   	pop    %ebx
  80248d:	5e                   	pop    %esi
  80248e:	5f                   	pop    %edi
  80248f:	5d                   	pop    %ebp
  802490:	c3                   	ret    

00802491 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  802491:	55                   	push   %ebp
  802492:	89 e5                	mov    %esp,%ebp
  802494:	83 ec 28             	sub    $0x28,%esp
  802497:	8b 45 08             	mov    0x8(%ebp),%eax
  80249a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
  80249d:	85 c0                	test   %eax,%eax
  80249f:	74 04                	je     8024a5 <vsnprintf+0x14>
  8024a1:	85 d2                	test   %edx,%edx
  8024a3:	7f 07                	jg     8024ac <vsnprintf+0x1b>
  8024a5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8024aa:	eb 3b                	jmp    8024e7 <vsnprintf+0x56>
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};
  8024ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8024af:	8d 44 10 ff          	lea    -0x1(%eax,%edx,1),%eax
  8024b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8024b6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8024bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8024c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8024c7:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8024ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8024d2:	c7 04 24 40 20 80 00 	movl   $0x802040,(%esp)
  8024d9:	e8 7f fb ff ff       	call   80205d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8024de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8024e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8024e7:	c9                   	leave  
  8024e8:	c3                   	ret    

008024e9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8024e9:	55                   	push   %ebp
  8024ea:	89 e5                	mov    %esp,%ebp
  8024ec:	83 ec 18             	sub    $0x18,%esp

	return b.cnt;
}

int
snprintf(char *buf, int n, const char *fmt, ...)
  8024ef:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;
	int rc;

	va_start(ap, fmt);
	rc = vsnprintf(buf, n, fmt, ap);
  8024f2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8024f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8024f9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8024fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  802500:	89 44 24 04          	mov    %eax,0x4(%esp)
  802504:	8b 45 08             	mov    0x8(%ebp),%eax
  802507:	89 04 24             	mov    %eax,(%esp)
  80250a:	e8 82 ff ff ff       	call   802491 <vsnprintf>
	va_end(ap);

	return rc;
}
  80250f:	c9                   	leave  
  802510:	c3                   	ret    

00802511 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  802511:	55                   	push   %ebp
  802512:	89 e5                	mov    %esp,%ebp
  802514:	83 ec 18             	sub    $0x18,%esp
		}
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
  802517:	8d 45 14             	lea    0x14(%ebp),%eax
{
	va_list ap;

	va_start(ap, fmt);
	vprintfmt(putch, putdat, fmt, ap);
  80251a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80251e:	8b 45 10             	mov    0x10(%ebp),%eax
  802521:	89 44 24 08          	mov    %eax,0x8(%esp)
  802525:	8b 45 0c             	mov    0xc(%ebp),%eax
  802528:	89 44 24 04          	mov    %eax,0x4(%esp)
  80252c:	8b 45 08             	mov    0x8(%ebp),%eax
  80252f:	89 04 24             	mov    %eax,(%esp)
  802532:	e8 26 fb ff ff       	call   80205d <vprintfmt>
	va_end(ap);
}
  802537:	c9                   	leave  
  802538:	c3                   	ret    
  802539:	00 00                	add    %al,(%eax)
  80253b:	00 00                	add    %al,(%eax)
  80253d:	00 00                	add    %al,(%eax)
	...

00802540 <ipc_send>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)

void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802540:	55                   	push   %ebp
  802541:	89 e5                	mov    %esp,%ebp
  802543:	57                   	push   %edi
  802544:	56                   	push   %esi
  802545:	53                   	push   %ebx
  802546:	83 ec 1c             	sub    $0x1c,%esp
  802549:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80254c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80254f:	8b 7d 10             	mov    0x10(%ebp),%edi
           int r;
       // if(pg==NULL)
         //  pg=(void *)UTOP;
       while(1)
        { 
          r = sys_ipc_try_send(to_env,val,pg,perm);
  802552:	8b 45 14             	mov    0x14(%ebp),%eax
  802555:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802559:	89 7c 24 08          	mov    %edi,0x8(%esp)
  80255d:	89 74 24 04          	mov    %esi,0x4(%esp)
  802561:	89 1c 24             	mov    %ebx,(%esp)
  802564:	e8 af e1 ff ff       	call   800718 <sys_ipc_try_send>
           if(r<0 && r!=-E_IPC_NOT_RECV)
  802569:	85 c0                	test   %eax,%eax
  80256b:	79 21                	jns    80258e <ipc_send+0x4e>
  80256d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802570:	74 1c                	je     80258e <ipc_send+0x4e>
                    panic("Panic at ipc_send");
  802572:	c7 44 24 08 40 2d 80 	movl   $0x802d40,0x8(%esp)
  802579:	00 
  80257a:	c7 44 24 04 43 00 00 	movl   $0x43,0x4(%esp)
  802581:	00 
  802582:	c7 04 24 52 2d 80 00 	movl   $0x802d52,(%esp)
  802589:	e8 5e f8 ff ff       	call   801dec <_panic>
          else if(r==-E_IPC_NOT_RECV)
  80258e:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802591:	75 07                	jne    80259a <ipc_send+0x5a>
           sys_yield();
  802593:	e8 ed e3 ff ff       	call   800985 <sys_yield>
          else
            break;
        }
  802598:	eb b8                	jmp    802552 <ipc_send+0x12>
//	panic("ipc_send not implemented");
}
  80259a:	83 c4 1c             	add    $0x1c,%esp
  80259d:	5b                   	pop    %ebx
  80259e:	5e                   	pop    %esi
  80259f:	5f                   	pop    %edi
  8025a0:	5d                   	pop    %ebp
  8025a1:	c3                   	ret    

008025a2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  8025a2:	55                   	push   %ebp
  8025a3:	89 e5                	mov    %esp,%ebp
  8025a5:	83 ec 18             	sub    $0x18,%esp
  8025a8:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  8025ab:	89 75 fc             	mov    %esi,-0x4(%ebp)
  8025ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8025b1:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
     int r; 
     r= sys_ipc_recv(pg);
  8025b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8025b7:	89 04 24             	mov    %eax,(%esp)
  8025ba:	e8 fc e0 ff ff       	call   8006bb <sys_ipc_recv>
        if(r<0)
  8025bf:	85 c0                	test   %eax,%eax
  8025c1:	79 17                	jns    8025da <ipc_recv+0x38>
        {
          if(from_env_store!=NULL)
  8025c3:	85 db                	test   %ebx,%ebx
  8025c5:	74 06                	je     8025cd <ipc_recv+0x2b>
               *from_env_store =0;
  8025c7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
          if(perm_store!=NULL)
  8025cd:	85 f6                	test   %esi,%esi
  8025cf:	90                   	nop
  8025d0:	74 2c                	je     8025fe <ipc_recv+0x5c>
              *perm_store=0;
  8025d2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  8025d8:	eb 24                	jmp    8025fe <ipc_recv+0x5c>
          return r;
       }

      if(from_env_store!=NULL)
  8025da:	85 db                	test   %ebx,%ebx
  8025dc:	74 0a                	je     8025e8 <ipc_recv+0x46>
       *from_env_store = env->env_ipc_from;
  8025de:	a1 74 60 80 00       	mov    0x806074,%eax
  8025e3:	8b 40 74             	mov    0x74(%eax),%eax
  8025e6:	89 03                	mov    %eax,(%ebx)

      if(perm_store!=NULL)
  8025e8:	85 f6                	test   %esi,%esi
  8025ea:	74 0a                	je     8025f6 <ipc_recv+0x54>
         *perm_store =env->env_ipc_perm; 
  8025ec:	a1 74 60 80 00       	mov    0x806074,%eax
  8025f1:	8b 40 78             	mov    0x78(%eax),%eax
  8025f4:	89 06                	mov    %eax,(%esi)

//env->env_tf.tf_eflags = 0;   
      return env->env_ipc_value;
  8025f6:	a1 74 60 80 00       	mov    0x806074,%eax
  8025fb:	8b 40 70             	mov    0x70(%eax),%eax
}
  8025fe:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  802601:	8b 75 fc             	mov    -0x4(%ebp),%esi
  802604:	89 ec                	mov    %ebp,%esp
  802606:	5d                   	pop    %ebp
  802607:	c3                   	ret    

00802608 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802608:	55                   	push   %ebp
  802609:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(vpd[PDX(v)] & PTE_P))
  80260b:	8b 45 08             	mov    0x8(%ebp),%eax
  80260e:	89 c2                	mov    %eax,%edx
  802610:	c1 ea 16             	shr    $0x16,%edx
  802613:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80261a:	f6 c2 01             	test   $0x1,%dl
  80261d:	74 26                	je     802645 <pageref+0x3d>
		return 0;
	pte = vpt[VPN(v)];
  80261f:	c1 e8 0c             	shr    $0xc,%eax
  802622:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802629:	a8 01                	test   $0x1,%al
  80262b:	74 18                	je     802645 <pageref+0x3d>
		return 0;
	return pages[PPN(pte)].pp_ref;
  80262d:	c1 e8 0c             	shr    $0xc,%eax
  802630:	8d 14 40             	lea    (%eax,%eax,2),%edx
  802633:	c1 e2 02             	shl    $0x2,%edx
  802636:	b8 00 00 00 ef       	mov    $0xef000000,%eax
  80263b:	0f b7 44 02 08       	movzwl 0x8(%edx,%eax,1),%eax
  802640:	0f b7 c0             	movzwl %ax,%eax
  802643:	eb 05                	jmp    80264a <pageref+0x42>
  802645:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80264a:	5d                   	pop    %ebp
  80264b:	c3                   	ret    
  80264c:	00 00                	add    %al,(%eax)
	...

00802650 <__udivdi3>:
  802650:	55                   	push   %ebp
  802651:	89 e5                	mov    %esp,%ebp
  802653:	57                   	push   %edi
  802654:	56                   	push   %esi
  802655:	83 ec 10             	sub    $0x10,%esp
  802658:	8b 45 14             	mov    0x14(%ebp),%eax
  80265b:	8b 55 08             	mov    0x8(%ebp),%edx
  80265e:	8b 75 10             	mov    0x10(%ebp),%esi
  802661:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802664:	85 c0                	test   %eax,%eax
  802666:	89 55 f0             	mov    %edx,-0x10(%ebp)
  802669:	75 35                	jne    8026a0 <__udivdi3+0x50>
  80266b:	39 fe                	cmp    %edi,%esi
  80266d:	77 61                	ja     8026d0 <__udivdi3+0x80>
  80266f:	85 f6                	test   %esi,%esi
  802671:	75 0b                	jne    80267e <__udivdi3+0x2e>
  802673:	b8 01 00 00 00       	mov    $0x1,%eax
  802678:	31 d2                	xor    %edx,%edx
  80267a:	f7 f6                	div    %esi
  80267c:	89 c6                	mov    %eax,%esi
  80267e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  802681:	31 d2                	xor    %edx,%edx
  802683:	89 f8                	mov    %edi,%eax
  802685:	f7 f6                	div    %esi
  802687:	89 c7                	mov    %eax,%edi
  802689:	89 c8                	mov    %ecx,%eax
  80268b:	f7 f6                	div    %esi
  80268d:	89 c1                	mov    %eax,%ecx
  80268f:	89 fa                	mov    %edi,%edx
  802691:	89 c8                	mov    %ecx,%eax
  802693:	83 c4 10             	add    $0x10,%esp
  802696:	5e                   	pop    %esi
  802697:	5f                   	pop    %edi
  802698:	5d                   	pop    %ebp
  802699:	c3                   	ret    
  80269a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  8026a0:	39 f8                	cmp    %edi,%eax
  8026a2:	77 1c                	ja     8026c0 <__udivdi3+0x70>
  8026a4:	0f bd d0             	bsr    %eax,%edx
  8026a7:	83 f2 1f             	xor    $0x1f,%edx
  8026aa:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8026ad:	75 39                	jne    8026e8 <__udivdi3+0x98>
  8026af:	3b 75 f0             	cmp    -0x10(%ebp),%esi
  8026b2:	0f 86 a0 00 00 00    	jbe    802758 <__udivdi3+0x108>
  8026b8:	39 f8                	cmp    %edi,%eax
  8026ba:	0f 82 98 00 00 00    	jb     802758 <__udivdi3+0x108>
  8026c0:	31 ff                	xor    %edi,%edi
  8026c2:	31 c9                	xor    %ecx,%ecx
  8026c4:	89 c8                	mov    %ecx,%eax
  8026c6:	89 fa                	mov    %edi,%edx
  8026c8:	83 c4 10             	add    $0x10,%esp
  8026cb:	5e                   	pop    %esi
  8026cc:	5f                   	pop    %edi
  8026cd:	5d                   	pop    %ebp
  8026ce:	c3                   	ret    
  8026cf:	90                   	nop
  8026d0:	89 d1                	mov    %edx,%ecx
  8026d2:	89 fa                	mov    %edi,%edx
  8026d4:	89 c8                	mov    %ecx,%eax
  8026d6:	31 ff                	xor    %edi,%edi
  8026d8:	f7 f6                	div    %esi
  8026da:	89 c1                	mov    %eax,%ecx
  8026dc:	89 fa                	mov    %edi,%edx
  8026de:	89 c8                	mov    %ecx,%eax
  8026e0:	83 c4 10             	add    $0x10,%esp
  8026e3:	5e                   	pop    %esi
  8026e4:	5f                   	pop    %edi
  8026e5:	5d                   	pop    %ebp
  8026e6:	c3                   	ret    
  8026e7:	90                   	nop
  8026e8:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  8026ec:	89 f2                	mov    %esi,%edx
  8026ee:	d3 e0                	shl    %cl,%eax
  8026f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8026f3:	b8 20 00 00 00       	mov    $0x20,%eax
  8026f8:	2b 45 f4             	sub    -0xc(%ebp),%eax
  8026fb:	89 c1                	mov    %eax,%ecx
  8026fd:	d3 ea                	shr    %cl,%edx
  8026ff:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802703:	0b 55 ec             	or     -0x14(%ebp),%edx
  802706:	d3 e6                	shl    %cl,%esi
  802708:	89 c1                	mov    %eax,%ecx
  80270a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  80270d:	89 fe                	mov    %edi,%esi
  80270f:	d3 ee                	shr    %cl,%esi
  802711:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  802715:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802718:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80271b:	d3 e7                	shl    %cl,%edi
  80271d:	89 c1                	mov    %eax,%ecx
  80271f:	d3 ea                	shr    %cl,%edx
  802721:	09 d7                	or     %edx,%edi
  802723:	89 f2                	mov    %esi,%edx
  802725:	89 f8                	mov    %edi,%eax
  802727:	f7 75 ec             	divl   -0x14(%ebp)
  80272a:	89 d6                	mov    %edx,%esi
  80272c:	89 c7                	mov    %eax,%edi
  80272e:	f7 65 e8             	mull   -0x18(%ebp)
  802731:	39 d6                	cmp    %edx,%esi
  802733:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802736:	72 30                	jb     802768 <__udivdi3+0x118>
  802738:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80273b:	0f b6 4d f4          	movzbl -0xc(%ebp),%ecx
  80273f:	d3 e2                	shl    %cl,%edx
  802741:	39 c2                	cmp    %eax,%edx
  802743:	73 05                	jae    80274a <__udivdi3+0xfa>
  802745:	3b 75 ec             	cmp    -0x14(%ebp),%esi
  802748:	74 1e                	je     802768 <__udivdi3+0x118>
  80274a:	89 f9                	mov    %edi,%ecx
  80274c:	31 ff                	xor    %edi,%edi
  80274e:	e9 71 ff ff ff       	jmp    8026c4 <__udivdi3+0x74>
  802753:	90                   	nop
  802754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802758:	31 ff                	xor    %edi,%edi
  80275a:	b9 01 00 00 00       	mov    $0x1,%ecx
  80275f:	e9 60 ff ff ff       	jmp    8026c4 <__udivdi3+0x74>
  802764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802768:	8d 4f ff             	lea    -0x1(%edi),%ecx
  80276b:	31 ff                	xor    %edi,%edi
  80276d:	89 c8                	mov    %ecx,%eax
  80276f:	89 fa                	mov    %edi,%edx
  802771:	83 c4 10             	add    $0x10,%esp
  802774:	5e                   	pop    %esi
  802775:	5f                   	pop    %edi
  802776:	5d                   	pop    %ebp
  802777:	c3                   	ret    
	...

00802780 <__umoddi3>:
  802780:	55                   	push   %ebp
  802781:	89 e5                	mov    %esp,%ebp
  802783:	57                   	push   %edi
  802784:	56                   	push   %esi
  802785:	83 ec 20             	sub    $0x20,%esp
  802788:	8b 55 14             	mov    0x14(%ebp),%edx
  80278b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80278e:	8b 7d 10             	mov    0x10(%ebp),%edi
  802791:	8b 75 0c             	mov    0xc(%ebp),%esi
  802794:	85 d2                	test   %edx,%edx
  802796:	89 c8                	mov    %ecx,%eax
  802798:	89 4d f4             	mov    %ecx,-0xc(%ebp)
  80279b:	75 13                	jne    8027b0 <__umoddi3+0x30>
  80279d:	39 f7                	cmp    %esi,%edi
  80279f:	76 3f                	jbe    8027e0 <__umoddi3+0x60>
  8027a1:	89 f2                	mov    %esi,%edx
  8027a3:	f7 f7                	div    %edi
  8027a5:	89 d0                	mov    %edx,%eax
  8027a7:	31 d2                	xor    %edx,%edx
  8027a9:	83 c4 20             	add    $0x20,%esp
  8027ac:	5e                   	pop    %esi
  8027ad:	5f                   	pop    %edi
  8027ae:	5d                   	pop    %ebp
  8027af:	c3                   	ret    
  8027b0:	39 f2                	cmp    %esi,%edx
  8027b2:	77 4c                	ja     802800 <__umoddi3+0x80>
  8027b4:	0f bd ca             	bsr    %edx,%ecx
  8027b7:	83 f1 1f             	xor    $0x1f,%ecx
  8027ba:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8027bd:	75 51                	jne    802810 <__umoddi3+0x90>
  8027bf:	3b 7d f4             	cmp    -0xc(%ebp),%edi
  8027c2:	0f 87 e0 00 00 00    	ja     8028a8 <__umoddi3+0x128>
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	29 f8                	sub    %edi,%eax
  8027cd:	19 d6                	sbb    %edx,%esi
  8027cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d5:	89 f2                	mov    %esi,%edx
  8027d7:	83 c4 20             	add    $0x20,%esp
  8027da:	5e                   	pop    %esi
  8027db:	5f                   	pop    %edi
  8027dc:	5d                   	pop    %ebp
  8027dd:	c3                   	ret    
  8027de:	66 90                	xchg   %ax,%ax
  8027e0:	85 ff                	test   %edi,%edi
  8027e2:	75 0b                	jne    8027ef <__umoddi3+0x6f>
  8027e4:	b8 01 00 00 00       	mov    $0x1,%eax
  8027e9:	31 d2                	xor    %edx,%edx
  8027eb:	f7 f7                	div    %edi
  8027ed:	89 c7                	mov    %eax,%edi
  8027ef:	89 f0                	mov    %esi,%eax
  8027f1:	31 d2                	xor    %edx,%edx
  8027f3:	f7 f7                	div    %edi
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	f7 f7                	div    %edi
  8027fa:	eb a9                	jmp    8027a5 <__umoddi3+0x25>
  8027fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802800:	89 c8                	mov    %ecx,%eax
  802802:	89 f2                	mov    %esi,%edx
  802804:	83 c4 20             	add    $0x20,%esp
  802807:	5e                   	pop    %esi
  802808:	5f                   	pop    %edi
  802809:	5d                   	pop    %ebp
  80280a:	c3                   	ret    
  80280b:	90                   	nop
  80280c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  802810:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802814:	d3 e2                	shl    %cl,%edx
  802816:	89 55 f4             	mov    %edx,-0xc(%ebp)
  802819:	ba 20 00 00 00       	mov    $0x20,%edx
  80281e:	2b 55 f0             	sub    -0x10(%ebp),%edx
  802821:	89 55 ec             	mov    %edx,-0x14(%ebp)
  802824:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802828:	89 fa                	mov    %edi,%edx
  80282a:	d3 ea                	shr    %cl,%edx
  80282c:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802830:	0b 55 f4             	or     -0xc(%ebp),%edx
  802833:	d3 e7                	shl    %cl,%edi
  802835:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802839:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80283c:	89 f2                	mov    %esi,%edx
  80283e:	89 7d e8             	mov    %edi,-0x18(%ebp)
  802841:	89 c7                	mov    %eax,%edi
  802843:	d3 ea                	shr    %cl,%edx
  802845:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802849:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  80284c:	89 c2                	mov    %eax,%edx
  80284e:	d3 e6                	shl    %cl,%esi
  802850:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802854:	d3 ea                	shr    %cl,%edx
  802856:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80285a:	09 d6                	or     %edx,%esi
  80285c:	89 f0                	mov    %esi,%eax
  80285e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  802861:	d3 e7                	shl    %cl,%edi
  802863:	89 f2                	mov    %esi,%edx
  802865:	f7 75 f4             	divl   -0xc(%ebp)
  802868:	89 d6                	mov    %edx,%esi
  80286a:	f7 65 e8             	mull   -0x18(%ebp)
  80286d:	39 d6                	cmp    %edx,%esi
  80286f:	72 2b                	jb     80289c <__umoddi3+0x11c>
  802871:	39 c7                	cmp    %eax,%edi
  802873:	72 23                	jb     802898 <__umoddi3+0x118>
  802875:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  802879:	29 c7                	sub    %eax,%edi
  80287b:	19 d6                	sbb    %edx,%esi
  80287d:	89 f0                	mov    %esi,%eax
  80287f:	89 f2                	mov    %esi,%edx
  802881:	d3 ef                	shr    %cl,%edi
  802883:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
  802887:	d3 e0                	shl    %cl,%eax
  802889:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
  80288d:	09 f8                	or     %edi,%eax
  80288f:	d3 ea                	shr    %cl,%edx
  802891:	83 c4 20             	add    $0x20,%esp
  802894:	5e                   	pop    %esi
  802895:	5f                   	pop    %edi
  802896:	5d                   	pop    %ebp
  802897:	c3                   	ret    
  802898:	39 d6                	cmp    %edx,%esi
  80289a:	75 d9                	jne    802875 <__umoddi3+0xf5>
  80289c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80289f:	1b 55 f4             	sbb    -0xc(%ebp),%edx
  8028a2:	eb d1                	jmp    802875 <__umoddi3+0xf5>
  8028a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  8028a8:	39 f2                	cmp    %esi,%edx
  8028aa:	0f 82 18 ff ff ff    	jb     8027c8 <__umoddi3+0x48>
  8028b0:	e9 1d ff ff ff       	jmp    8027d2 <__umoddi3+0x52>
