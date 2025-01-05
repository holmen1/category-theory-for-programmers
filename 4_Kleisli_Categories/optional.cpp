#include <cmath>
#include <functional>
#include <iostream>

// Implemented in C++17, here is a simple implementation of the optional class
template <typename T> class optional {
    bool _isValid;
    T _value;
public:
    optional() : _isValid(false) {}
    optional(T value) : _isValid(true), _value(value) {}
    bool isValid() const { return _isValid; }
    T value() const { return _value; }
};


// Function to calculate the square root safely
optional<double> safe_root(double x) {
    if (x < 0) {
        return optional<double>{}; // Return an empty optional if the input is negative
    }
    return optional<double>{std::sqrt(x)}; // Return the square root if the input is non-negative
}

// Function to calculate the inverse safely
optional<double> safe_inverse(double x) {
    if (x == 0) {
        return optional<double>{}; // Return an empty optional if the input is zero
    }
    return optional<double>{1.0 / x}; // Return the inverse if the input is non-zero
}

std::function<optional<double>(double)> compose(
    std::function<optional<double>(double)> f,
    std::function<optional<double>(double)> g) {
    return [f, g](double x) {
        optional<double> result = f(x);
        if (result.isValid()) {
            return g(result.value());
        }
        return optional<double>{};
    };
}

optional<double> safe_root_inverse(double x) {
    return compose(safe_inverse, safe_root)(x);
}

int main() {
    double values[] = {4.0, -1.0, 9.0, 0.0, 16.0};

    for (double value : values) {
        optional<double> result = safe_root_inverse(value);

        if (result.isValid()) {
            std::cout << "The square root inverse of " << value << " is " << result.value() << std::endl;
        } else {
            std::cout << "Cannot calculate square root inverse of " << value << std::endl;
        }
    }

    return 0;
}