#include <inc/mmu.h>
#include <inc/x86.h>
#include <inc/assert.h>

#include <kern/pmap.h>
#include <kern/trap.h>
#include <kern/console.h>
#include <kern/monitor.h>
#include <kern/env.h>
#include <kern/syscall.h>
#include <kern/sched.h>
#include <kern/kclock.h>
#include <kern/picirq.h>
#include <kern/time.h>

static struct Taskstate ts;
       /* extern void divide();
        extern void debug();
        extern void nmi();
        extern void brkpt();
        extern void oflow();
        extern void bound();
        extern void illop();
        extern void device();
        extern void dblflt();
        //extern void trap_coproc();
        extern void tss();
        extern void segnp();
        extern void stack();
        extern void gpflt();
        extern void pgflt();
        //extern void trap_res();
        extern void fperr();
        extern void align();
        extern void mchk();
        extern void simderr();
        extern void tsyscall();
*/


extern void handleDIVIDE(void);
extern void handleDEBUG(void);
extern void handleNMI(void);
extern void handleBRKPT(void);
extern void handleOFLOW(void);
extern void handleBOUND(void);
extern void handleILLOP(void);
extern void handleDEVICE(void);
extern void handleDBLFLT(void);
extern void handleTSS(void);
extern void handleSEGNP(void);
extern void handleSTACK(void);
extern void handleGPFLT(void);
extern void handlePGFLT(void);
extern void handleFPERR(void);
extern void handleALIGN(void);
extern void handleMCHK(void);
extern void handleSIMDERR(void);
extern void handleSYSCALL(void);

extern void handleTIMER(void);
extern void handleKBD(void);
extern void handleSERIAL(void);
extern void handleSPURIOUS(void);
extern void handleIDE(void);
extern void handleERROR(void);



#define IRQ_TIMER        0
#define IRQ_KBD          1
#define IRQ_SERIAL       4
#define IRQ_SPURIOUS     7
#define IRQ_IDE         14
#define IRQ_ERROR       19





/* Interrupt descriptor table.  (Must be built at run time because
 * shifted function addresses can't be represented in relocation records.)
 */
struct Gatedesc idt[256] = { { 0 } };
struct Pseudodesc idt_pd = {
	sizeof(idt) - 1, (uint32_t) idt
};


static const char *trapname(int trapno)
{
	static const char * const excnames[] = {
		"Divide error",
		"Debug",
		"Non-Maskable Interrupt",
		"Breakpoint",
		"Overflow",
		"BOUND Range Exceeded",
		"Invalid Opcode",
		"Device Not Available",
		"Double Fault",
		"Coprocessor Segment Overrun",
		"Invalid TSS",
		"Segment Not Present",
		"Stack Fault",
		"General Protection",
		"Page Fault",
		"(unknown trap)",
		"x87 FPU Floating-Point Error",
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
		return "Hardware Interrupt";
	return "(unknown trap)";
}


void
idt_init(void)
{
	extern struct Segdesc gdt[];
/*	
	// LAB 3: Your code here.
        SETGATE(idt[T_DIVIDE], 1, GD_KT, divide, 0);
        SETGATE(idt[T_DEBUG], 1, GD_KT, debug, 0);
        SETGATE(idt[T_NMI], 0, GD_KT, nmi, 0);
        SETGATE(idt[T_BRKPT], 1, GD_KT,brkpt, 3);
        SETGATE(idt[T_OFLOW], 1, GD_KT,oflow, 0);
        SETGATE(idt[T_BOUND], 1, GD_KT,bound, 0);
        SETGATE(idt[T_ILLOP], 1, GD_KT,illop, 0);
        SETGATE(idt[T_DEVICE], 1, GD_KT,device, 0);
        SETGATE(idt[T_DBLFLT], 1, GD_KT,dblflt, 0);
    
        SETGATE(idt[T_TSS], 1, GD_KT, tss, 0);
        SETGATE(idt[T_SEGNP], 1, GD_KT, segnp, 0);
        SETGATE(idt[T_STACK], 1, GD_KT, stack, 0);
        SETGATE(idt[T_GPFLT], 1, GD_KT, gpflt, 0);
        SETGATE(idt[T_PGFLT], 1, GD_KT, pgflt, 0);
     
        SETGATE(idt[T_FPERR], 1, GD_KT, fperr, 0);
        SETGATE(idt[T_ALIGN], 1, GD_KT, align, 0);
        SETGATE(idt[T_MCHK], 1, GD_KT, mchk, 0);
        SETGATE(idt[T_SIMDERR], 1, GD_KT,simderr, 0);

        //Initial system call entry
        SETGATE(idt[T_SYSCALL], 1, GD_KT,tsyscall, 3);
*/

        SETGATE(idt[IRQ_TIMER+IRQ_OFFSET],  0, GD_KT, handleTIMER,  0)
        SETGATE(idt[IRQ_KBD+IRQ_OFFSET],  0, GD_KT, handleKBD,  0)
        SETGATE(idt[IRQ_SERIAL+IRQ_OFFSET],  0, GD_KT, handleSERIAL,  0)
        SETGATE(idt[IRQ_SPURIOUS+IRQ_OFFSET],  0, GD_KT, handleSPURIOUS,  0)
        SETGATE(idt[IRQ_IDE+IRQ_OFFSET],  0, GD_KT, handleIDE,  0)
        SETGATE(idt[IRQ_ERROR+IRQ_OFFSET],  0, GD_KT, handleERROR, 0)
       
        SETGATE(idt[T_DIVIDE],  0, GD_KT, handleDIVIDE,  0)
        SETGATE(idt[T_DEBUG],   0, GD_KT, handleDEBUG,   0)
        SETGATE(idt[T_NMI],     0, GD_KT, handleNMI,     0)
        SETGATE(idt[T_BRKPT],   0, GD_KT, handleBRKPT,   3)
        SETGATE(idt[T_OFLOW],   1, GD_KT, handleOFLOW,   0)
        SETGATE(idt[T_BOUND],   0, GD_KT, handleBOUND,   0)
        SETGATE(idt[T_ILLOP],   0, GD_KT, handleILLOP,   0)
        SETGATE(idt[T_DEVICE],  0, GD_KT, handleDEVICE,  0)
        SETGATE(idt[T_DBLFLT],  0, GD_KT, handleDBLFLT,  0)
        SETGATE(idt[T_TSS],     0, GD_KT, handleTSS,     0)
        SETGATE(idt[T_SEGNP],   0, GD_KT, handleSEGNP,   0)
        SETGATE(idt[T_STACK],   0, GD_KT, handleSTACK,   0)
        SETGATE(idt[T_GPFLT],   0, GD_KT, handleGPFLT,   0)
        SETGATE(idt[T_PGFLT],   0, GD_KT, handlePGFLT,   0)
        SETGATE(idt[T_FPERR],   0, GD_KT, handleFPERR,   0)
        SETGATE(idt[T_ALIGN],   0, GD_KT, handleALIGN,   0)
        SETGATE(idt[T_MCHK],    0, GD_KT, handleMCHK,    0)
        SETGATE(idt[T_SIMDERR], 0, GD_KT, handleSIMDERR, 0)
        SETGATE(idt[T_SYSCALL], 0, GD_KT, handleSYSCALL, 3)
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	ts.ts_esp0 = KSTACKTOP;
	ts.ts_ss0 = GD_KD;
	// Initialize the TSS field of the gdt.
	gdt[GD_TSS >> 3] = SEG16(STS_T32A, (uint32_t) (&ts),
					sizeof(struct Taskstate), 0);
	gdt[GD_TSS >> 3].sd_s = 0;

	// Load the TSS
	ltr(GD_TSS);

	// Load the IDT
	asm volatile("lidt idt_pd");
}

void
print_trapframe(struct Trapframe *tf)
{
	cprintf("TRAP frame at %p\n", tf);
	print_regs(&tf->tf_regs);
	cprintf("  es   0x----%04x\n", tf->tf_es);
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
	cprintf("  err  0x%08x\n", tf->tf_err);
	cprintf("  eip  0x%08x\n", tf->tf_eip);
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
	cprintf("  esp  0x%08x\n", tf->tf_esp);
	cprintf("  ss   0x----%04x\n", tf->tf_ss);
}

void
print_regs(struct PushRegs *regs)
{
	cprintf("  edi  0x%08x\n", regs->reg_edi);
	cprintf("  esi  0x%08x\n", regs->reg_esi);
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
	cprintf("  edx  0x%08x\n", regs->reg_edx);
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
	cprintf("  eax  0x%08x\n", regs->reg_eax);
}

static void
trap_dispatch(struct Trapframe *tf)
{
	// Handle processor exceptions.
	// LAB 3: Your code here.

	
	// Handle clock interrupts.
	// LAB 4: Your code here.
        if(tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER)
             {
                time_tick();
                //if(((time_msec())%100) == 0)
                  //update_page_access_reference();
                sched_yield();                             
             }
         


	// Add time tick increment to clock interrupts.
	// LAB 6: Your code here.

	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
		cprintf("Spurious interrupt on irq 7\n");
		print_trapframe(tf);
		return;
	}

          if(tf->tf_trapno==T_PGFLT)
              { page_fault_handler(tf);	
               return;
              } 

             if(tf->tf_trapno==T_BRKPT)
                    {
                        monitor(tf);
                return;
      //asm volatile("int3");

                    }

             if(tf->tf_trapno==T_SYSCALL)
                    {
                     int i=0;
                     //cprintf("Size of %d",sizeof(struct UTrapframe));
//                      cprintf("\nvalue of cs%x\n",tf->tf_cs);
                     //for(;i<(tf->tf_regs).reg_ecx;i++)
                       // cprintf("\nValues eax%d  edx%d  ecx%x\n ",(tf->tf_regs).reg_eax,(tf->tf_regs).reg_edx,((char *)(tf->tf_regs).reg_ecx));
                       // cprintf("%c",*(((char *)((tf->tf_regs).reg_edx))+i));
      uint32_t ret = syscall((tf->tf_regs).reg_eax,(tf->tf_regs).reg_edx,(tf->tf_regs).reg_ecx,(tf->tf_regs).reg_ebx,(tf->tf_regs).reg_edi,(tf->tf_regs).reg_esi);
                      (tf->tf_regs).reg_eax=ret;
                      return;
                    }
           



	// Handle keyboard and serial interrupts.
	// LAB 7: Your code here.

	if(tf->tf_trapno == IRQ_KBD+IRQ_OFFSET)
	{
		kbd_intr();
		return;
	}


	if(tf->tf_trapno == IRQ_SERIAL+IRQ_OFFSET)
	{
		serial_intr();
		return;
	}

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
	if (tf->tf_cs == GD_KT)
		panic("unhandled trap in kernel");
	else {
		env_destroy(curenv);
		return;
	}
}

void
trap(struct Trapframe *tf)
{
	// The environment may have set DF and some versions
	// of GCC rely on DF being clear
	asm volatile("cld" ::: "cc");

	// Check that interrupts are disabled.  If this assertion
	// fails, DO NOT be tempted to fix it by inserting a "cli" in
	// the interrupt path.
	assert(!(read_eflags() & FL_IF));
        
//	cprintf("Incoming TRAP frame at %p\n", tf);

       //print_trapframe(tf);


// only here we map the trapframe of a process or environment from the kernel stack, so that read below....
	if ((tf->tf_cs & 3) == 3) {
		// Trapped from user mode.
		// Copy trap frame (which is currently on the stack)
		// into 'curenv->env_tf', so that running the environment
		// will restart at the trap point.
		assert(curenv);
		curenv->env_tf = *tf;
		// The trapframe on the stack should be ignored from here on.
		tf = &curenv->env_tf;
            // cprintf("here inside trap fail%p\n",tf);
	}
	
	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);


	// If we made it to this point, then no other environment was
	// scheduled, so we should return to the current environment
	// if doing so makes sense.
	if (curenv && curenv->env_status == ENV_RUNNABLE)
		env_run(curenv);
	else
		sched_yield();

          //cprintf("after destruction");
	// Return to the current environment, which should be runnable.
	assert(curenv && curenv->env_status == ENV_RUNNABLE);
	env_run(curenv);
}


void
page_fault_handler(struct Trapframe *tf)
{
 uint32_t fault_va;

	// Read processor's CR2 register to find the faulting address
	fault_va = rcr2();

	// Handle kernel-mode page faults.
	
	// LAB 3: Your code here.
              
            //fault_va

        /* generally, the page fault in the kernel does not happen,,,,,if some exception happens the processor automatically pushes the flags,cs,eip on the stack(but thats not a page fault, its simply the nested backtrace),,,,,so, this function wont be called and there will be no exception or interrupt,,,as no pagefault only some runtime exception in the kernel which wud be handled by some other trap........If the pagefault happens in kernel,,,then the JOS doesnot handle that and panics,,,,
          */ 
                uint16_t CPL = tf->tf_cs & 0x0003;
                 if(CPL==0)
                    panic("kernel mode fault");
                

	// We've already handled kernel-mode exceptions, so if we get here,
	// the page fault happened in user mode.

	// Call the environment's page fault upcall, if one exists.  Set up a
	// page fault stack frame on the user exception stack (below
	// UXSTACKTOP), then branch to curenv->env_pgfault_upcall.
                        
                                       
                                  
	//
	// The page fault upcall might cause another page fault, in which case
	// we branch to the page fault upcall recursively, pushing another
	// page fault stack frame on top of the user exception stack.
	//
	// The trap handler needs one word of scratch space at the top of the
	// trap-time stack in order to return.  In the non-recursive case, we
	// don't have to worry about this because the top of the regular user
	// stack is free.  In the recursive case, this means we have to leave
	// an extra word between the current top of the exception stack and
	// the new stack frame because the exception stack _is_ the trap-time
	// stack.
	//
	// If there's no page fault upcall, the environment didn't allocate a
	// page for its exception stack or can't write to it, or the exception
	// stack overflows, then destroy the environment that caused the fault.
	// Note that the grade script assumes you will first check for the page
	// fault upcall and print the "user fault va" message below if there is
	// none.  The remaining three checks can be combined into a single test.
	//
	// Hints:
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.

//if(sys_page_alloc(curenv->env_id,(void *)UXSTACKTOP-PGSIZE,PTE_P|PTE_U|PTE_W)<0)
                          
    if(curenv->env_pgfault_upcall!=NULL)
      {
        
       struct UTrapframe *utf;
       //uint32_t espValue =*(curenv->env_tf.tf_esp); 

//      user_mem_assert(curenv, (void *)(UXSTACKTOP-4), 4, 0);

           if(!(tf->tf_esp > UXSTACKTOP-PGSIZE && tf->tf_esp < UXSTACKTOP))
                        { 
                           utf=(struct UTrapframe *)(((uint32_t *)UXSTACKTOP) - (sizeof(struct UTrapframe)/4));
                          //   cprintf("\nesp in IF>>>> %x\n",tf->tf_esp);        
                        // cprintf("\nHere in if esp %x   TOP %x  UTF  %x\n",(((uint32_t *)UXSTACKTOP) - (sizeof(struct UTrapframe)/4)),UXSTACKTOP,utf);
                        }
                    else
                        {
                          utf=(struct UTrapframe *)(((uint32_t *)tf->tf_esp) - ((sizeof(struct UTrapframe)/4)+1));
                        // cprintf("\nHere in else\n");
                        // cprintf("esp in else ----> %x",tf->tf_esp);
                        // cprintf("\nHere in else esp %x   TOP %x  UTF  %x\n",tf->tf_esp,UXSTACKTOP,utf);
                        }
        

      /* if(tf->tf_esp > USTACKTOP){
                      
                 utf = (struct UTrapframe *)((void *)(tf->tf_esp) - sizeof(struct UTrapframe) - 4);
                    cprintf("\nHere in if utf %x   TOP %x  UTF  %x\n",(((uint32_t *)UXSTACKTOP) - (sizeof(struct UTrapframe)/4)),UXSTACKTOP,utf);

                    }else{
                          cprintf("\nHere in else\n");
                          utf = (struct UTrapframe *)((void *)UXSTACKTOP - sizeof(struct UTrapframe));
                }
*/
           // user_mem_assert(curenv,(void *)UXSTACKTOP-PGSIZE,400,PTE_P|PTE_U|PTE_W);
      //cprintf("\nva22222 = %x    faultva=%x",utf,fault_va);
    // cprintf("Before assert in kern pgfault trap>>>>>>>>>\n");  
     user_mem_assert(curenv,(void *)utf,sizeof(utf),0);  
        utf->utf_fault_va =fault_va;
        utf->utf_err = tf->tf_err; 
        /* trap-time return state */
        utf->utf_regs = tf->tf_regs;
        utf->utf_eip = tf->tf_eip;
        utf->utf_eflags = tf->tf_eflags;
        /* the trap-time stack to return to */
        utf->utf_esp = tf->tf_esp;
//        cprintf("\nabove curenv");
        curenv->env_tf.tf_eip =(uintptr_t)curenv->env_pgfault_upcall;
        curenv->env_tf.tf_esp =(uintptr_t)utf;
  //      cprintf("\n below allocation of trap frame");           
        env_run(curenv);
                  
                        }

	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
		curenv->env_id, fault_va, tf->tf_eip);
	print_trapframe(tf);
	env_destroy(curenv);

}


/*
//still to save lcr3 and reload in the end
void update_page_access_reference()
{	
	uint32_t page_index = 0;
        struct vma *head;
        struct *env=NULL;
        pte_t pgTableEntry=NULL;
        uint32_t perm=0; 
	for(;page_index<NPAGES;page_index++)
	{
		//We only have to check for the pages which have been allocated i.e there ref count should be >0).
		if(pages[page_index]->pg_ref>0)
		{
                	//checking whether there is any vma allocated i.e eliminating pages of kernel
                        //They will not have vma's bcz they dont use page_alloc.
			if((head = pages[page_index]->head)!=NULL)
			{
				if(envid2env(head->envid_t,&env,0)<0)
                                    continue;
                                 We want to get the permissions corresponding to the page.
                                   But the page would be mapped in env's page directory.
                                   So, we need to change the pgdir.
				
                                if(head->va!=NULL)
				{
					lcr3(env->env_pgdir);
					pgTableEntry = vpt[VPN(head->va)];
                                }
                                else
                                	continue;	
  			
                        	perm = pgTableEntry & 0xFFF;
				pageTableEntry = pageTableEntry & 0xFFFFF000;
				// if access bit set, unset it in env Page Table.
				if(perm & PTE_A == PTE_A)
				{
					vpt[VPN(head->va)] = pgTableEntry|(perm &(~PTE_A));
                                       //Checking the access bit.If set, update reference count.  
                                       // Check the access bit then update the access reference count field in page struct.                  
                       			pages[page_index]->access_ref_count = (pages[page_index]->access_ref_count>>1)|0x80;                                  
	                        }
                                else
                                {
                                 	pages[page_index]->access_ref_count = (pages[page_index]->access_ref_count>>1); 
                                }
			}
		}             
	}                   
}*/	
