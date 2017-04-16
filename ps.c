#include "uproc.h"
#include "user.h"
#define MAX 32

int main()
{
  struct uproc* table = malloc(MAX*sizeof(struct uproc));

  if (!table) 
  {
    printf(2, "Error. Malloc call failed.");
    return -1;
  }  
  int status = getprocs(MAX, table);
  printf(1, "PID  UID  GID  PPID  Elapsed  Total Ticks  Size     State       Name\n");
  for (int i = 0; i < status; ++i)
  {
    printf(1, "%d    %d   %d   %d     %d        %d            %d    %s       %s\n", table[i].pid, table[i].uid, 
          table[i].gid, table[i].ppid, table[i].elapsed_ticks, table[i].CPU_total_ticks, table[i].size, table[i].state, table[i].name);
  }
  printf(1, "%d system calls used.\n", status);
  exit();
}
