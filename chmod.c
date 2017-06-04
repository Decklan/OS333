#include "types.h"
#include "user.h"

int main(int argc, char *argv[])
{
  uint imode = 0;
  char *mode = 0;
  char *file = 0;

  if (argc != 3) {
    printf(2, "ERROR: chmod expects a MODE and a TARGET.\n");
    exit();
  }

  mode = argv[1];
  if (strlen(mode) != 4) {
    printf(2, "ERROR: chmod expects a MODE of length 4.\n");
    exit();
  }

  file = argv[2];
  if (strlen(file) < 1 || !file) {
    printf(2, "ERROR: chmod expects a file as its second arg.\n");
    exit();
  }

  // XV6 code START
  // verify mode in correct range: 0000 - 1777 octal.
  if (!(mode[0] == '0' || mode[0] == '1')) {
    printf(2, "ERROR: Mode is out of acceptable range 0000-1777.\n");
    exit();
  }
  if (!(mode[1] >= '0' && mode[1] <= '7')) {
    printf(2, "ERROR: Mode is out of acceptable range 0000-1777.\n");
    exit();
  }
  if (!(mode[2] >= '0' && mode[2] <= '7')) {
    printf(2, "ERROR: Mode is out of acceptable range 0000-1777.\n");
    exit();
  }
  if (!(mode[3] >= '0' && mode[3] <= '7')) {
    printf(2, "ERROR: Mode is out of acceptable range 0000-1777.\n");
    exit();
  }

  // convert octal to decimal.  we have no pow() function
  imode += ((int)(mode[0] - '0') * (8*8*8));
  imode += ((int)(mode[1] - '0') * (8*8));
  imode += ((int)(mode[2] - '0') * (8));
  imode +=  (int)(mode[3] - '0');
  //XV6 code END

  printf(1, "String in octal is %s and decimal is %d\n", mode, imode);

  int rc = chmod(file, imode);
  if (rc < 0) {
    printf(2, "ERROR: chmod failed.\n");
    exit();
  }
  exit();
}
