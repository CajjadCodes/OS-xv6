#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

int sys_changeQueue(void)
{
  int pid, level;
  argint(0, &pid);
  argint(1, &level);
  changeQueue(pid, level);
  return 1;
}

int 
sys_setTicket(void)
{
  int pid, ticket;
  argint(0, &pid);
  argint(1, &ticket);
  setTicket(pid, ticket);
  return 1;
}

int
sys_setProcessParameters(void)
{
  int pid;
  int priorityRatio, arrivalTimeRatio, executedCycleRatio;
  argint(0, &pid);
  argint(1, &priorityRatio);
  argint(2, &arrivalTimeRatio);
  argint(3, &executedCycleRatio);
  setProcessParameters(pid, priorityRatio, arrivalTimeRatio, executedCycleRatio);
  return 1;
}

int
sys_setSystemParameters(void)
{
  int priorityRatio, arrivalTimeRatio, executedCycleRatio;
  argint(1, &priorityRatio);
  argint(2, &arrivalTimeRatio);
  argint(3, &executedCycleRatio);
  setSystemParameters(priorityRatio, arrivalTimeRatio, executedCycleRatio);
  return 1;
}

int
sys_showInfo(void)
{
  return 1;
}
