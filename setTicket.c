#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char* argv[])
{
	int pid, ticket;
	pid = atoi(argv[1]);
	ticket = atoi(argv[2]);
	setTicket(pid, ticket);
	printf(1, "The ticket of process %d is set to %d\n", pid, ticket);
	exit();
}