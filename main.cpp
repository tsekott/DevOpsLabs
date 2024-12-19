#include "MyClass.h"
#include "HTTP_Server.h"
#include <iostream>

int main() {
    std::cout << "Starting HTTP server on port 8081..." << std::endl;
    
    // Create and run the HTTP server
    int result = CreateHTTPserver();
    
    if (result != 0) {
        std::cerr << "Server failed to start" << std::endl;
        return 1;
    }
    
    return 0;
}