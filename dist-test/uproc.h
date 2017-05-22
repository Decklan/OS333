#include "types.h"
#define STRMAX 32
struct uproc 
{
  uint pid;
  uint uid;
  uint gid;
  uint ppid;
  uint priority;
  uint elapsed_ticks;
  uint CPU_total_ticks;
  char state[STRMAX];
  uint size;
  char name[STRMAX];
};

// Helper function for getprocs system call
int getproc_helper(int m, struct uproc* table);
