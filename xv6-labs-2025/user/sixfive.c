#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"

void
sixfive(int fd)
{
  int n;
  int num = 0;

  char c[1];

  bool isNum = false;

  // Read the input file a character at the time
  while((n = read(fd, &c[0], 1)) > 0) {
    // Test if a character matches any of the separators using strchr
    if (strchr(&c[0], ' ') || strchr(&c[0], '-') || strchr(&c[0], '\r') || strchr(&c[0], '\t') || strchr(&c[0], '\n') || strchr(&c[0], '.') || strchr(&c[0], '/')) {
      if ((num % 6 == 0 || num % 5 == 0) && isNum == true) {
        fprintf(1, "%d\n", num);
      }
      isNum = false;
      num = 0;
    } else {
      int d = atoi(&c[0]);
      if (d >= 0 && d < 10) {
        if (num == 0) {
          isNum = true;
        }
        num *= 10;
        num += d;
      } else {
        num = 0;
        isNum = false;
      }
    }
  }

  if ((num % 6 == 0 || num % 5 == 0) && isNum == true) {
    fprintf(1, "%d\n", num);
  }
}

int
main(int argc, char *argv[])
{
  int fd, i;

  if(argc <= 1){
    fprintf(2, "usage: sixfive file...\n");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
      fprintf(2, "sixfive: cannot open %s\n", argv[i]);
      exit(1);
    }
    sixfive(fd);
    close(fd);
  }
  exit(0);
}
