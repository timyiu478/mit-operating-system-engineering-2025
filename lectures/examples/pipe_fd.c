#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <sys/wait.h>

int main() {
    int pipefd[2];
    pid_t pid;

    if (pipe(pipefd) == -1) {
        perror("pipe");
        return 1;
    }

    printf("After pipe():\n");
    printf("  read end  fd = %d\n", pipefd[0]);
    printf("  write end fd = %d\n", pipefd[1]);
    printf("----------------------------------------\n");

    pid = fork();
    if (pid == -1) {
        perror("fork");
        return 1;
    }

    if (pid == 0) {
        // Child
        printf("Child (PID %d) sees the same fds after fork:\n", getpid());
        printf("  read end  fd = %d\n", pipefd[0]);
        printf("  write end fd = %d\n", pipefd[1]);

        close(pipefd[1]);  // Child closes write end

        char buf[100] = {0};
        read(pipefd[0], buf, sizeof(buf) - 1);
        printf("Child read: %s", buf);

        close(pipefd[0]);
        printf("Child exiting.\n");
    } else {
        // Parent
        printf("Parent (PID %d) sees the same fds after fork:\n", getpid());
        printf("  read end  fd = %d\n", pipefd[0]);
        printf("  write end fd = %d\n", pipefd[1]);

        close(pipefd[0]);  // Parent closes read end

        const char *msg = "Hello from parent!\n";
        write(pipefd[1], msg, strlen(msg));

        close(pipefd[1]);  // Close write end → child gets EOF

        wait(NULL);
        printf("Parent: child finished\n");
    }

    return 0;
}
