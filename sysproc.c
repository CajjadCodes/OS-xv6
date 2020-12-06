#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "syscalltrace.h"

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

int 
sys_get_children(void)
{
  int parent_id;
  int is_recursive;

  if ((argint(0, &parent_id) < 0) || (argint(1, &is_recursive) < 0))
    return -1;

  int childs[NPROC];
  int childsno;
  childsno = getchilds(parent_id, childs, NPROC);

  cprintf("children of process %d: ", parent_id);
  for (int i = 0; i < childsno; i++) {
    cprintf("%d", childs[i]);
    if (i != childsno - 1)
      cprintf(",");
  }
  if (childsno == 0)
    cprintf("No Children");
  cprintf("\n");

  if (is_recursive) {
    char buf[100];
    int i = 4;
    for (i = 0; i < 4* is_recursive - 2; i++)
      buf[i] = ' ';
    buf[i++] = '_';
    buf[i++] = '_';
    buf[i] = '\0';
    for (i = 1; i < 4* is_recursive; i += 4)
      buf[i] = '|';
    is_recursive++;
    for (i = 0; i < childsno; i++) {
      cprintf(buf);
      *(int*)((myproc()->tf->esp) + 4) = childs[i];
      *(int*)((myproc()->tf->esp) + 8) = is_recursive;
      sys_get_children();
    }
  }

  return 0;
}


int
sys_trace_syscalls(void)
{
  int state;

  if (argint(0, &state) < 0)
    return -1;

  if (state == 0) {
    set_tracing_syscalls(0);
    reset_syscalls_trace();
  }
  else if (state == 1) {
    update_syscalls_trace_names();
    set_tracing_syscalls(1);
  }
  return 0;
}

int
sys_get_syscallstrace(void)
{
  if (is_tracing_syscalls() != 1)
    return 0;
  struct systrace* userspace_systrace;
  if (argptr(0, (void*)&userspace_systrace, sizeof(*userspace_systrace)) < 0)
    return -1;


  get_syscalls_struct(userspace_systrace);

  update_syscalls_trace_names();

  return 1;
}

int
sys_reverse_number(void)
{
  int a;
  asm volatile("mov %%edi, %0;":"=r"(a));
  int out = 0;
  while(a != 0)
  {
    int r = a % 10;
    out = out * 10 + r;
    a /= 10;
  }
  return out;
}