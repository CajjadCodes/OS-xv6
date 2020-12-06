#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char* argv[])
{
	int pid, priorityRatio, arrivalTimeRatio, executedCycleRatio;
	pid = atoi(argv[1]);
	priorityRatio = atoi(argv[2]);
	arrivalTimeRatio = atoi(argv[3]);
	executedCycleRatio = atoi(argv[4]);
	setProcessParameters(pid, priorityRatio, arrivalTimeRatio, executedCycleRatio);
	printf(1, "Parameters are changed\n");
	exit();
}