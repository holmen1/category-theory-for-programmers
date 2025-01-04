#include <iostream>
#include <map>

auto memoize(int (*func)(int)) {
    std::map<int, int> memo;

    return [func, &memo](int n) -> int {
        if (memo.find(n) != memo.end()) {
            return memo[n];
        }

        int result = func(n);
        memo[n] = result;

        return result;
    };
}

int fact(int n) {
    int result = 1;
    for (int i = 2; i <= n; ++i)
        result *= i;
    return result;
}


int main() {
    auto memoized_fact = memoize(fact);
    std::cout << memoized_fact(5) << std::endl;

    return 0;
}
