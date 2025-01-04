#include <iostream>

int fact(int n) {
    int result = 1;
    for (int i = 2; i <= n; ++i)
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
    std::cout << "fact(5): " << fact(5) << std::endl;
    std::cout << "f(): " << f() << std::endl;
    std::cout << "f(5): " << f(5) << std::endl;
    std::cout << "f(5): " << f(5) << std::endl;

    return 0;
}
