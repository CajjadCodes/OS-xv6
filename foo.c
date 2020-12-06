#include "types.h"
#include "stat.h"
#include "user.h"

int factorial(int n) {
    if (n <= 1)
        return 1;
    return n * factorial(n-1);
}

int main(int argc, char* argv[])
{
    int pid;
    int numberOfChilds = 5;
	for(int i = 0; i < numberOfChilds; i++) {
        pid = fork();
        if (pid == 0) {
            factorial(100);
            exit();
        }
    }

    for(int i = 0; i < numberOfChilds; i++) {
        wait();
    }
	exit();
}
