// Public definitions for the POSIX-like file descriptor emulation layer
// that our user-land support library implements for the use of applications.
// See the code in the lib directory for the implementation details.

#ifndef JOS_INC_SWAP_H
#define JOS_INC_SWAP_H

#include <inc/types.h>

// pre-declare for forward references
#define NSWAPBLK_BITSIZE 33
#define NSWAPBLOCKS 1034


struct Swap_Space{
	struct File *swap_file;
	uint32_t bitmap[NSWAPBLK_BITSIZE];
};




struct Swap_Space swap_handler;

void    swap_init(void);
void*   get_free_swap_block(void);
void    check_SwapBlock(void);

extern struct Swap_Out_Page swap_out;
#endif	// not JOS_INC_FD_H
