#include "types.h"
#include "user.h"

// Take in commandline args to process
int main(int argc, char *argv[])
{
  int f = fork(); 
  int before = uptime();
  int after = 0;
  if (f < 0)
    printf(2, "Fork failed.");
  else if (f == 0)
  {
    argv++;
    exec(argv[0], argv);
  } else {
    wait();
    after = uptime();
    int secs = (after-before)/100;
    int p_secs = (after-before)%100;
    printf(1, "%s ran in %d.%d seconds\n", argv[1], secs, p_secs); 
  } 
  exit();
}
