#include <inc/assert.h>

#include <kern/env.h>
#include <kern/pmap.h>
#include <kern/monitor.h>


// Choose a user environment to run and run it.
void
sched_yield(void)
{
	// Implement simple round-robin scheduling.
	// Search through 'envs' for a runnable environment,
	// in circular fashion starting after the previously running env,
	// and switch to the first such environment found.
	// It's OK to choose the previously running env if no other env
	// is runnable.
	// But never choose envs[0], the idle environment,
	// unless NOTHING else is runnable.

        // LAB 4: Your code here
uint32_t index=0;
uint32_t i=0;
if(curenv!=NULL)
{index=curenv-envs;
i=index+1;
}
else
i=1;
uint32_t end=NENV;

//cprintf("\nIndex %d\n",index);

             for(;i<end;i++)
                       {   
                          
                                   //cprintf("\nStatus %d \n",envs[i].env_status);
                             if(envs[i].env_status==ENV_RUNNABLE)
                                   { 
                                     //cprintf("\nYieldind %d\n",i);
                                        env_run(&envs[i]);
                                         
                                   }
                             if(i==NENV-1)
                               {
                                 //cprintf("\nInside changing i%d\n",i);
                                 i=0;
                                 end=index+1;
                                 //cprintf("\nInside changing i%d\n",i);
                                
                               }
                
                       }


/*
 uint32_t i, n = 0;
  if (curenv)
    i = curenv - envs + 1;
  else
    i = 1;

  for (; n < NENV - 1; n++) {
    if (envs[i].env_status == ENV_RUNNABLE) {
      env_run(&envs[i]);
      return;
    }
    i++;
    if (i == NENV)
      i = 1;
  }
*/


	// Run the special idle environment when nothing else is runnable.
	if (envs[0].env_status == ENV_RUNNABLE)
		env_run(&envs[0]);
	else {
		cprintf("Destroyed all environments - nothing more to do!\n");
		while (1)
			monitor(NULL);
	}
}
