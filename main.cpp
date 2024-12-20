#include "MyClass.h"
#include "HTTP_Server.h"
#include <iostream>
#include <sys/wait.h>

void sigchldHandler(int s) {
    printf("SIGCHLD received\n");
    pid_t pid;
    int status;

    while((pid = waitpid(-1, &status, WNOHANG)) > 0);
    {
        if (WIFEXITED(status)) {
            printf("Child %d terminated with status: %d\n", pid, WEXITSTATUS(status));
        } else {
            printf("Child %d terminated abnormally\n", pid);
        }
    }
}

void siginHandler(int s) {
    printf("Caught signal %d\n", s);
    pid_t pid;
    int status;
    while((pid = waitpid(-1, &status, 0)) > 0);
    {
        if (WIFEXITED(status)) {
            printf("Child %d terminated with status: %d\n", pid, WEXITSTATUS(status));
        } else {
            printf("Child %d terminated abnormally\n", pid);
        }
        if (pid == -1) {
            printf("No more child processes\n");
        }
    }
}



int main() {
    signal(SIGCHLD, sigchldHandler);
    signal(SIGINT, siginHandler);
    
    std::cout << "Starting HTTP server on port 8081..." << std::endl;
    
    // Create and run the HTTP server
    int result = CreateHTTPserver();
    
    if (result != 0) {
        std::cerr << "Server failed to start" << std::endl;
        return 1;
    }
    
    return 0;
}