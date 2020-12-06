#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char* argv[])
{
	int pid, level;
	pid = atoi(argv[1]);
	level = atoi(argv[2]);
	changeQueue(pid, level);
	printf(1, "The queue of process with pid %d is changed to %d\n", pid, level);
	exit();
}
