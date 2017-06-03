#include "types.h"
#include "user.h"

int main(int argc, char *argv[])
{
  uint gid;
  char *pn;

  if (argc != 3) {
    printf(2, "ERROR: chgrp expects two args: a GID and a TARGET.\n"); 
    exit(); 
  }

  gid = atoi(argv[1]);
  if (gid < 0 || gid > 32767) {
    printf(2, "A valid GID is expected.\n");
    exit();
  }

  pn = argv[2];
  if (strlen(pn) < 1) {
    printf(2, "A valid length file name is expected.\n");
    exit();
  }

  int rc = chgrp(pn, gid);
  if (rc < 0) {
    printf(2, "ERROR: chgrp failed.\n");
    exit();
  }  
  exit();
}
