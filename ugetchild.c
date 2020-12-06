#include "types.h"
#include "stat.h"
#include "user.h"

int main() {

    int mypid = getpid();

    //Not Recursive

    printf(1, "\n***Part 1: Operating Mode: Not Recursive***\n\n");
    if (fork() > 0) {
        if (fork() > 0) {
            if (fork() > 0) {
                sleep(25);
                get_children(mypid, 0);
                wait(); 
                wait();
                wait();
            }
            else {
                sleep(50);
                exit();
            }
        }
        else {
            sleep(50);
            exit();
        }
    }
    else {
        sleep(50);
        exit();
    }

    //Recursive

    printf(1, "\n\n***Part 2: Operating Mode: Recursive***\n\n");
    if (fork() > 0) {
        if (fork() > 0) {
            if (fork() > 0) {
                sleep(25);
                get_children(mypid, 1);
                wait();
                wait();
                wait();
            }
            else {
                sleep(50);
                exit();
            }
        }
        else {
            sleep(50);
            exit();
        }
    }
    else {
        if (fork() > 0) { // first child creates another child
            if (fork() > 0) {
                wait();
                wait();
                sleep(50);
                exit();
            }
            else {
                sleep(50);
                exit();
            }
        }
        else {
            if (fork() > 0) { // and its child creates a new child itself
                if (fork() > 0) {
                    wait();
                    wait();
                    sleep(50);
                    exit();
                }
                else {
                    sleep(50);
                    exit();
                } 
            }
            else {
                sleep(50);
                exit();
            }
        }
    }
    printf(1, "\n");
    exit();
}