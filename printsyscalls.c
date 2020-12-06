#include "types.h"
#include "stat.h"
#include "user.h"
#include "param.h"
#include "syscall.h"
#include "syscalltrace.h"

int main() {
    // trace_syscalls(0); //initialize struct
    struct systrace syscallstrace[NPROC];
    
    while(1) {
        sleep(500);
        if (get_syscallstrace(syscallstrace) == 1) {
            printf(1, "\n=============\n");
            for (int i = 0; i < NPROC; i++) {
                if (strcmp(syscallstrace[i].pname, "\0") == 0)
                    continue;
                printf(1, "%s:\n", syscallstrace[i].pname);
                for (int j = 1; j < LASTSYSCALLIDX; j++) {
                    if (syscallstrace[i].syscallusage[j] == 0)
                        continue;
                    
                    printf(1, "    ");    
                    switch (j)
                    {
                        case SYS_fork:
                            printf(1, "Fork: ");
                            break;
                        case SYS_exit:
                            printf(1, "Exit: ");
                            break;
                        case SYS_wait:
                            printf(1, "Wait: ");
                            break;
                        case SYS_pipe:
                            printf(1, "Pipe: ");
                            break;
                        case SYS_read:
                            printf(1, "Read: ");
                            break;
                        case SYS_kill:
                            printf(1, "Kill: ");
                            break;
                        case SYS_exec:
                            printf(1, "Exec: ");
                            break;
                        case SYS_fstat:
                            printf(1, "Fstat: ");
                            break;
                        case SYS_chdir:
                            printf(1, "Chdir: ");
                            break;
                        case SYS_dup:
                            printf(1, "Dup: ");
                            break;
                        case SYS_getpid:
                            printf(1, "Getpid: ");
                            break;
                        case SYS_sbrk:
                            printf(1, "Sbrk: ");
                            break;
                        case SYS_sleep:
                            printf(1, "Sleep: ");
                            break;
                        case SYS_uptime:
                            printf(1, "Uptime: ");
                            break;
                        case SYS_open:
                            printf(1, "Open: ");
                            break;
                        case SYS_write:
                            printf(1, "Write: ");
                            break;
                        case SYS_mknod:
                            printf(1, "Mknod: ");
                            break;
                        case SYS_unlink:
                            printf(1, "Unlink: ");
                            break;
                        case SYS_link:
                            printf(1, "Link: ");
                            break;
                        case SYS_mkdir:
                            printf(1, "Mkdir: ");
                            break;
                        case SYS_close:
                            printf(1, "Close: ");
                            break;
                        case SYS_get_children:
                            printf(1, "GetChildren: ");
                            break;
                        case SYS_trace_syscalls:
                            printf(1, "TraceSysCalls: ");
                            break;
                        case SYS_get_syscallstrace:
                            printf(1, "GetSysCallTrace: ");
                            break;
                        case SYS_reverse_number:
                            printf(1, "ReverseNumber: ");
                            break;
                        default:
                            break;
                    }
                    printf(1, "%d\n", syscallstrace[i].syscallusage[j]);
                }
                printf(1, "\n");
            }
            printf(1, "=============\n");
        }
    }
    
    exit();
}