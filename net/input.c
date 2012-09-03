#include "ns.h"

extern union Nsipc nsipcbuf;
uint32_t len=0;

void
input(envid_t ns_envid)
{
	binaryname = "ns_input";

	// LAB 6: Your code here:
	// 	- read a packet from the device driver
	//	- send it to the network server
	// Hint: When you IPC a page to the network server, it will be
	// reading from it for a while, so don't immediately receive
	// another packet in to the same physical page.
           
   while(1)
   {
     if(sys_page_alloc(sys_getenvid(),&nsipcbuf,PTE_W|PTE_U|PTE_P)< 0 )
        panic("\nout of pages\n");
      
       //cprintf("len--->%x",&len);
    	if(sys_call_receive_packet(nsipcbuf.pkt.jp_data,&nsipcbuf.pkt.jp_len)>=0)
	{
        	 //cprintf("\nHere inside input.c -ve\n"); 
		cprintf("\nInside else---->>>>>>\n");
        	ipc_send(ns_envid,NSREQ_INPUT,&nsipcbuf,PTE_W|PTE_U|PTE_P);
   		sys_yield();
  		sys_yield();
	}

  sys_page_unmap(0,&nsipcbuf);

}

}



