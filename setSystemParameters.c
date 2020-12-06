#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char* argv[])
{
	int priorityRatio, arrivalTimeRatio, executedCycleRatio;
	priorityRatio = atoi(argv[1]);
	arrivalTimeRatio = atoi(argv[2]);
	executedCycleRatio = atoi(argv[3]);
	setSystemParameters(priorityRatio, arrivalTimeRatio, executedCycleRatio);
	printf(1, "Parameters are changed\n");
	exit();
}