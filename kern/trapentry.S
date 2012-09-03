/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

#include <kern/picirq.h>


###################################################################
# exceptions/interrupts
###################################################################

/* The TRAPHANDLER macro defines a globally-visible function for handling
 * a trap.  It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 */ 
#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */
#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text
TRAPHANDLER_NOEC(handleDIVIDE, T_DIVIDE)
TRAPHANDLER_NOEC(handleDEBUG, T_DEBUG)
TRAPHANDLER_NOEC(handleNMI, T_NMI)
TRAPHANDLER_NOEC(handleBRKPT, T_BRKPT)
TRAPHANDLER_NOEC(handleOFLOW, T_OFLOW)
TRAPHANDLER_NOEC(handleBOUND, T_BOUND)
TRAPHANDLER_NOEC(handleILLOP, T_ILLOP)
TRAPHANDLER_NOEC(handleDEVICE, T_DEVICE)
TRAPHANDLER_NOEC(handleFPERR, T_FPERR)
TRAPHANDLER_NOEC(handleMCHK, T_MCHK)
TRAPHANDLER_NOEC(handleSIMDERR, T_SIMDERR)
TRAPHANDLER_NOEC(handleSYSCALL, T_SYSCALL)
TRAPHANDLER_NOEC(handleTIMER,IRQ_TIMER+IRQ_OFFSET)
TRAPHANDLER_NOEC(handleKBD,IRQ_KBD+IRQ_OFFSET)
TRAPHANDLER_NOEC(handleSERIAL,IRQ_SERIAL+IRQ_OFFSET)
TRAPHANDLER_NOEC(handleSPURIOUS,IRQ_SPURIOUS+IRQ_OFFSET)
TRAPHANDLER_NOEC(handleIDE,IRQ_IDE+IRQ_OFFSET)
TRAPHANDLER_NOEC(handleERROR,IRQ_ERROR+IRQ_OFFSET)
TRAPHANDLER(handleDBLFLT, T_DBLFLT)
TRAPHANDLER(handleTSS, T_TSS)
TRAPHANDLER(handleSEGNP, T_SEGNP)
TRAPHANDLER(handleSTACK, T_STACK)
TRAPHANDLER(handleGPFLT, T_GPFLT)
TRAPHANDLER(handlePGFLT, T_PGFLT)
TRAPHANDLER(handleALIGN, T_ALIGN)

/*
 * Lab 3: Your code here for _alltraps
 */
_alltraps:
pushl %ds
pushl %es
pushal
movw $GD_KD,%ax
movw %ax,%ds
movw %ax,%es
pushl %esp
call trap
popal
popl %es
popl %ds
iret
