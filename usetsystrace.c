#include "types.h"
#include "stat.h"
#include "user.h"
#include "param.h"
#include "syscall.h"

int main(int argc, char* argv[]){

    if (argc > 1) {
        int newstate = atoi(argv[1]);
        if (newstate == 0)
            trace_syscalls(0);
        else if (newstate == 1)
            trace_syscalls(1);
    }
    exit();
}