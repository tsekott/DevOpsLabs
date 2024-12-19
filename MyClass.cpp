#include "MyClass.h"
#include <cmath>
double MyClass::FuncA() {
    double result = 0.0;
    for (int i = 1; i <= 3; ++i) {
        // Example calculation for first 3 elements.
        result += std::pow(-1, i) * std::pow(x, 2*i-1) / (2*i - 1);
    }
    return result;
}