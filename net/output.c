#include "ns.h"

extern union Nsipc nsipcbuf;

void
output(envid_t ns_envid)
{
	binaryname = "ns_output";

	// LAB 6: Your code here:
	// 	- read a packet from the network server
	//	- send the packet to the device driver
   while(1)
    {
       ipc_recv(NULL,(void *)&nsipcbuf,NULL);
       int i=0;
    //   cprintf("\nInside ouput--->%d\n",nsipcbuf.pkt.jp_len);
    /*  while(nsipcbuf.pkt.jp_data[i]!='\0')
         {
           cprintf("%c",nsipcbuf.pkt.jp_data[i]);
           i++;
         }
*/
       sys_call_packet_send((void *)nsipcbuf.pkt.jp_data,nsipcbuf.pkt.jp_len); 
        
    }

}
