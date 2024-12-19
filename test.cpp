#include "MyClass.h"
#include <cassert>
#include <chrono>
#include <vector>
#include <random>
#include <algorithm>

int main() {
    // Basic functionality test
    MyClass obj;
    double result = obj.FuncA();
    assert(result != 0.0);

    // Performance test
    auto t1 = std::chrono::high_resolution_clock::now();

    MyClass calculator;
    std::vector<double> aValues;
    std::random_device rd;
    std::mt19937 mtre(rd());
    std::uniform_real_distribution<double> distr(-100.0, 100.0);

    // Generate and process values
    for (int i = 0; i < 2000000; i++) {
        double val = distr(mtre);
        aValues.push_back(calculator.FuncA(val));
    }

    // Apply FuncA and sort
    for (int i = 0; i < 500; i++) {
        for (auto& val : aValues) {
            val = calculator.FuncA(val);
        }
        std::sort(aValues.begin(), aValues.end());
    }

    auto t2 = std::chrono::high_resolution_clock::now();
    auto duration = std::chrono::duration_cast<std::chrono::milliseconds>(t2 - t1);
    int ms = duration.count();

    // Assert execution time between 5-20 seconds
    assert(ms >= 5000 && ms <= 20000);
    
    return 0;
}