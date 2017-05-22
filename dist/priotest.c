#include "types.h"
#include "user.h"

int main(int argc, char *argv[])
{
  if (argc < 3 || argc > 3) {
    printf(2, "ERROR: priotest expects exactly 2 args.\n");
    exit();
  }

  int pid = atoi(argv[1]);
  int prio = atoi(argv[2]);
  int rc = setpriority(pid, prio);
  if (rc == -1) {
    printf(2, "INVALID PID.\n");
    exit();
  } else if (rc == 0) {
    printf(1, "Success!\n");
    exit();
  } else if (rc == 1){
    printf(1, "Process already has priority %d.\n", prio);
    exit();
  } else if (rc == -2) {
    printf(2, "INVALID PRIORITY VALUE.\n");
    exit();
  } else {
    printf(2, "PID: %d not found.\n", pid);
    exit();
  }
}
