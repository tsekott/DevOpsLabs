#include "MyClass.h"
#include <cmath>

double MyClass::FuncA(int n) {
    double result = 0.0;
    double x = 1.0; // Example value for x, you can change it as needed
    for (int i = 1; i <= n; ++i) {
        result += std::pow(-1, i) * std::pow(x, 2*i-1) / (2*i - 1);
    }
    return result;
}