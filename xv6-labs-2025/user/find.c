#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"
#include "kernel/fs.h"
#include "kernel/fcntl.h"


// Find all the files in a directory tree with a specific name
void find(char *dir, char *name) {
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
          find(buf, name);
        } else if (strcmp(de.name, name) == 0) {
          printf("%s\n", buf);
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
  if(argc != 3){
    printf("Usage: find <directory> <name>\n");
    exit(1);
  }

  find(argv[1], argv[2]);

  exit(0);
}
