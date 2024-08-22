#include <iostream>

int fact(int n) {
    int i;
    int result = 1;
    for (i = 2; i <= n; ++i)
        result *= i;
    return result;
}

bool f() {
    std::cout << "Hello!" << std::endl;
    return true;
}

int f(int x) {
    static int y = 0;
    y += x;
    return y;
}

int main() {
    std::cout << "fact(6) = " << fact(6) << std::endl;
    std::cout << "f() = " << f() << std::endl;
    std::cout << "f(2) = " << f(2) << std::endl;
    std::cout << "f(3) = " << f(3) << std::endl;
    std::cout << "f(2) = " << f(2) << std::endl;
    return 0;
}

// fact(6) = 720
// f() = Hello!
// 1
// f(2) = 2
// f(3) = 5
// f(2) = 7