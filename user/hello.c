// hello, world
#include <inc/lib.h>

char *data[]=

         { "Hi This is Mohit",
           "Hi This is Rohit",
           "Hi This is Rahit",
           "Hi This is Rbhit",
           "Hi This is Rchit",
           "Hi This is Rdhit",
           "Hi This is Rehit",
           "Hi This is Rfhit",
           "Hi This is Rghit",
           "Hi This is Rhhit", 
           "Hi This is Rihit", 
         };

void
umain(void)
{
	cprintf("hello, world\n");
	cprintf("i am environment %08x\n", env->env_id);
      int i=0; 
      for(;i<11;i++)
      {
         int ret=sys_call_packet_send((void *)data[i],16);    
      }
}
