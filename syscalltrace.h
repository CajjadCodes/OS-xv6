#include "types.h"

#define NSYSCALLS 25
#define LASTSYSCALLIDX (NSYSCALLS+1)

struct systrace {
  char pname[16];
  uchar pid;
  uchar syscallusage[LASTSYSCALLIDX];
};