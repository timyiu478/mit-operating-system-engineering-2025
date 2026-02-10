#include <unistd.h>
#include <sys/wait.h>

int main() {
  int pid;
  int ping_fds[2];
  int pong_fds[2];

  pipe(ping_fds);
  pipe(pong_fds);

  // write ping bytes
  write(ping_fds[1], "p", 1);
  close(ping_fds[1]); // done write

  pid = fork();

  if (pid == 0) {
    // close unused fds
    close(pong_fds[0]);

    // read ping bytes
    char buf[4];
    int n = read(ping_fds[0], buf, 1);
    close(ping_fds[0]); // done read

    // write to STDOUT
    write(1, buf, n);
    // write pong bytes
    write(pong_fds[1], "g", 1);
    close(pong_fds[1]); // done write

    _exit(0);
  }

  // close unused fds
  close(ping_fds[0]);
  close(pong_fds[1]);

  // wait child process
  wait(NULL);

  // read pong bytes
  char buf[4];
  int n = read(pong_fds[0], buf, 1);
  close(pong_fds[0]); // done read
  // write to STDOUT
  write(1, buf, n);
}
