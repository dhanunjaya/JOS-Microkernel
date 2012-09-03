// test user-level fault handler -- just exit when we fault

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
	sys_env_destroy(sys_getenvid());
}

void
umain(void)
{
	       cprintf("\nhere iside user>>>>>>>>>>>>>>\n");
	set_pgfault_handler(handler);
	*(int*)0xDeadBeef = 0;
}