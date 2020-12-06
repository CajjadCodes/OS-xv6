// init: The initial user-level program

#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

char *argv[] = { "sh", 0 };

int
main(void)
{
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
    mknod("console", 1, 1);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  dup(0);  // stderr

  trace_syscalls(0);
  trace_syscalls(1);

  for(;;){
    printf(1, "init: starting sh\n");
    printf(1,"Group Members:\n");
    printf(1,"Mohammad Azimpour\n");
    printf(1,"Amirali Ataei Naeini\n");
    printf(1,"Sajjad Gandom Malmiri\n");

    //Adding a new process for printing the number of times each process used system calls
    pid = fork();
    if(pid < 0){
      printf(1, "init: printsyscalls failed\n");
      exit();
    }
    if(pid == 0){
      exec("printsyscalls", argv);
      printf(1, "init: exec printsyscalls failed\n");
      exit();
    }
    
    pid = fork();
    if(pid < 0){
      printf(1, "init: fork failed\n");
      exit();
    }
    if(pid == 0){
      exec("sh", argv);
      printf(1, "init: exec sh failed\n");
      exit();
    }
    while((wpid=wait()) >= 0 && wpid != pid)
      printf(1, "zombie!\n");
  }
}
