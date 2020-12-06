#include "types.h"
#include "stat.h"
#include "user.h"

int
main(int argc, char* argv[])
{
	int num = atoi(argv[argc - 1]);
	asm volatile("movl %0, %%edi"::"r"(num));
	printf(1, "%d\n", reverse_number());
	exit();
}