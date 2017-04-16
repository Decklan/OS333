#include "uproc.h"
#include "user.h"
#define MAX 32

int main()
{
  struct uproc* uproc_table = malloc(MAX*sizeof(struct uproc));
  if (!uproc_table) 
  {
    printf(2, "Error. Malloc call failed.");
    return -1;
  }  
  int status = getprocs(MAX, uproc_table);
  printf(1, "%d system calls used.\n", status);
  exit();
}
