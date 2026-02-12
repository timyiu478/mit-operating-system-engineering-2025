#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"
#include "kernel/param.h"
#include <stddef.h>


// Find all the files in a directory tree with a specific name
// argc: # of arguments of the -exec
// argv: the arguments of the -exec
void find(char *dir, char *name, int argc, char *argv[]) {
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(dir, O_RDONLY)) < 0){
    fprintf(2, "find: cannot open %s\n", dir);
    return;
  }

  if(fstat(fd, &st) < 0){
    fprintf(2, "find: cannot stat %s\n", dir);
    close(fd);
    return;
  }

  switch(st.type){
    case T_DIR:
      // Read each director entry
      while(read(fd, &de, sizeof(de)) == sizeof(de)){
        // skip empty slot or "." or ".."
        if (de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
          continue;
        
        strcpy(buf, dir);
        p = buf+strlen(buf);
        *p++ = '/';
        memmove(p, de.name, DIRSIZ);
        p[DIRSIZ] = 0;

        if (stat(buf, &st) < 0) {
          printf("find: cannot stat %s\n", buf);
          continue;
        }

        // Call find recursively
        if (st.type == T_DIR) {
          find(buf, name, argc, argv);
        } else if (strcmp(de.name, name) == 0) {
          // no -exec arugment
          if (argc == 0) {
            printf("%s\n", buf);
            continue;
          }

          char *a[argc+2];
          for (int i=0; i < argc; i++){
            a[i] = argv[i]; 
          }
          a[argc] = buf;
          a[argc+1] = NULL;

          int pid = fork();

          if (pid == 0) {
            // execute command
            int ret = exec(a[0], a);
            if (ret != 0) {
              fprintf(2, "find: failed to execute command - %s\n", argv[0]);
            }
          } else {
            wait(0);
          }
        }
      }

      break;
    default:
      fprintf(2, "find: invalid argument - %s is not directory\n", dir);
  }

  close(fd);
}

int
main(int argc, char *argv[])
{
  if (argc < 3) {
    printf("Usage: find <directory> <name> [-exec command]\n");
    exit(1);
  }
  
  if (argc == 3) {
    find(argv[1], argv[2], 0, argv);
    exit(0);
  }

  if (argc >= 5 && strcmp(argv[3], "-exec") == 0 && strlen(argv[4]) > 0) {
    find(argv[1], argv[2], argc - 4, argv+4);
  } else {
    printf("Usage: find <directory> <name> [-exec command]\n");
    exit(1);
  }

  exit(0);
}
