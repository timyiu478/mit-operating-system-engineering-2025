#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if(argc != 2){
    fprintf(2, "Usage: sleep second\n");
    exit(1);
  }
  
  int second = atoi(argv[1]);

  // 10 tick per second
  pause(second * 10);

  exit(0);
}
