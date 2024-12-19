#include "MyClass.h"
#include <cmath>
double MyClass::FuncA(int n) {
    /**
     * Calculates the sum of the first n elements of the infinite sequence.
     * @param n The number of terms to calculate in the series.
     * @return The sum of the first n elements.
     */
    double result = 0.0;
    for (int i = 1; i <= n; ++i) {
        // Example calculation using the given sequence formula.
        result += std::pow(-1, i) * std::pow(x, 2*i-1) / (2*i - 1);
    }
    return result;
}