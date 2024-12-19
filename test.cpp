#include "MyClass.h"
#include <cassert>

int main() {
    MyClass obj;
    double result = obj.FuncA();
    // Basic test - we expect a non-zero result for default params
    assert(result != 0.0);
    return 0;
}