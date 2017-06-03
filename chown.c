#include "types.h"
#include "user.h"

int main(int argc, char *argv[])
{
  uint uid;
  char *pn;

  if (argc != 3) {
    printf(2, "ERROR: chown expects two args: a UID and a TARGET.\n"); 
    exit(); 
  }

  uid = atoi(argv[1]);
  if (uid < 0 || uid > 32767) {
    printf(2, "A valid UID is expected.\n");
    exit();
  }

  pn = argv[2];
  if (strlen(pn) < 1) {
    printf(2, "A valid length file name is expected.\n");
    exit();
  }

  int rc = chown(pn, uid);
  if (rc < 0) {
    printf(2, "ERROR: chown failed.\n");
    exit();
  }  
  exit();
}
