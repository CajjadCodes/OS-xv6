#include "types.h"
#include "stat.h"
#include "user.h"

unsigned long long semi_factorial(unsigned long long n) {
    unsigned long long answer = 1;
    unsigned long long new_n = n*n*n*n*n*n*n*n*n*n*n*n*n*n*n*n*n*n*n;
    for (int i = 1; i < new_n; i++)
        answer *= i;
    return answer;
}

int main(int argc, char* argv[])
{
    int pid;
    int numberOfChilds = 5;
	for(int i = 0; i < numberOfChilds; i++) {
        pid = fork();
        if (pid == 0) {
            semi_factorial(100);
            exit();
        }
    }
    for(int i = 0; i < numberOfChilds; i++) {
        wait();
    }
	exit();
}
