// buggy program - faults with a read from location zero

#include <inc/lib.h>
#include <inc/memlayout.h>

void
umain(void)
{
        //cprintf("I read from location %x 0!",*((uint32_t *)UVPT));
	cprintf("I read %08x from location 0!\n", *(unsigned*)0);
}

