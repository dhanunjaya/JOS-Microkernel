#include <inc/string.h>
#include <inc/lib.h>
#include<inc/fs.h>

union Fsipc *fs_req = (union Fsipc *)0x0ffff000;

void swap_in_page()
{
	uint32_t faultva, whom;
	int  perm, isMapped, msgFromFS;
	uint32_t blockva;
	while(1)
	{	// receive the faulting address from the user defined pgfault handler.
		perm = 0;
		isMapped = -1;
		msgFromFS = -1;
		faultva = 0;
		whom = 0;
		blockva = 0;
		//receive faultva from the user environment. 
		if((faultva = ipc_recv((int32_t *) &whom , NULL , &perm)) < 0)
			panic("Fault Address given to swapin env");
		// get the corresponding block no from the kernel swap_store.
		if((blockva = sys_get_swapped_block(faultva,whom)) < 0)
			panic("swap_store does not have entry for this va %e",faultva);
		memset((void *)fs_req,0,PGSIZE);
		fs_req->swap.blockva = blockva;
		// send msg to file system to map the page at the corresponding blockva		
		ipc_send(envs[1].env_id, SWAP_IN_PAGE , fs_req , PTE_P | PTE_U | PTE_W);
		// Return status from the file system whether it was able to map the block at its blockva.
		if((isMapped = ipc_recv(NULL,NULL,NULL)<0)
			sys_yield();  // or continue;
		// Make request to kernel to swap in page in all the env corresponding to this blockva.
		if(sys_page_swap_in(blockva) < 0)
		{
			ipc_send(envs[1].env_id, SWAP_IN_ERROR , fs_req , PTE_P | PTE_U | PTE_W);
		}	
		else	
		{
			ipc_send(envs[1].env_id, SWAP_IN_SUCCESS , fs_req , PTE_P | PTE_U | PTE_W);
		}
		if( msgFromFS = ipc_recv(NULL,NULL,NULL)) < 0)
			panic("FS Failed while handling Swap in");

	}



}



void umain(void)
{
	swap_in_page();
}
