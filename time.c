#include "types.h"
#include "user.h"

// Take in commandline args to process
int main(int argc, char *argv[])
{
  int before = uptime();
  int f = fork(); 
  int after = 0;
  if (f < 0)
    printf(2, "Fork failed.");
  else if (f == 0)
  {
    argv++;
    exec(argv[0], argv);
    printf(2, "ERROR: exec failed.\n");
  } else {
    wait();
    after = uptime();
    int secs = (after-before)/100;
    int p_secs = (after-before)%100;
    if (p_secs < 10)
      printf(1, "%s ran in %d.0%d seconds\n", argv[1], secs, p_secs);
    else 
      printf(1, "%s ran in %d.%d seconds\n", argv[1], secs, p_secs); 
  } 
  exit();
}
