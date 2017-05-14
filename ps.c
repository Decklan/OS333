#include "uproc.h"
#include "user.h"
#define MAX 64

int main()
{
  struct uproc* table = malloc(MAX*sizeof(struct uproc));

  if (!table) 
  {
    printf(2, "Error. Malloc call failed.");
    exit();
  }
 
  printf(1, "Max value: %d\n", MAX); 
  int status = getprocs(MAX, table);
  if (status < 0)
    printf(2, "Error. Not enough memory for the table.\n");
  else
  {
    printf(1, "PID\t Name\t UID\t GID\t PPID\t Prio\t Elapsed  CPU\t State\t Size\n");
    for (int i = 0; i < status; ++i)
    {
      int elapsed_secs = table[i].elapsed_ticks/100;
      int partial_elapsed_secs = table[i].elapsed_ticks%100;
      int total_cpu_secs = table[i].CPU_total_ticks/100;
      int partial_cpu_secs = table[i].CPU_total_ticks%100;
      printf(1, "%d\t %s\t %d\t %d\t %d\t %d\t", table[i].pid, table[i].name, table[i].uid, 
            table[i].gid, table[i].ppid, table[i].priority);
    
      if (partial_elapsed_secs < 10)
        printf(1, " %d.0%d", elapsed_secs, partial_elapsed_secs);
      else
        printf(1, " %d.%d", elapsed_secs, partial_elapsed_secs);

      if (partial_cpu_secs < 10)
        printf(1, "     %d.0%d\t", total_cpu_secs, partial_cpu_secs);
      else
        printf(1, "     %d.%d\t", total_cpu_secs, partial_cpu_secs);

      printf(1, " %s\t %d\n", table[i].state, table[i].size);
    }
  }
  exit();
}
