""" 
A function that is not defined for all possible values of its argument is
called a partial function. It’s not really a function in the mathematical
sense, so it doesn’t fit the standard categorical mold. It can, however, be
represented by a function that returns an embellished type optional:

template<class A> class optional {
    bool _isValid;
    A _value;
public:
    optional() : _isValid(false) {}
    optional(A v) : _isValid(true), _value(v) {}
    bool isValid() const { return _isValid; }
    A value() const { return _value; }
};

As an example, here’s the implementation of the embellished function
safe_root:

optional<double> safe_root(double x) {
    if (x >= 0) return optional<double>{sqrt(x)};
        else return optional<double>{};
}

Here’s the challenge:
1. Construct the Kleisli category for partial functions (define com-
position and identity).
Implement the embellished function safe_reciprocal that re-
turns a valid reciprocal of its argument, if it’s different from zero.
3. Compose safe_root and safe_reciprocal to implement
safe_root_reciprocal that calculates sqrt(1/x) whenever pos-
sible. """
from typing import Callable

class Optional:
    def __init__(self, v: float = None):
        self._isValid = v is not None
        self._value = v

    def is_valid(self) -> bool:
        return self._isValid
    def value(self) -> float:
        return self._value

def compose(f: Callable[[float], Optional], g: Callable[[float], Optional]) -> Optional:
    def composed(x):
        if f(x).is_valid():
            return g(f(x).value())
        else:
            return Optional()
    return composed

def identity(x: float) -> Optional:
    return Optional(x)

def safe_reciprocal(x: float) -> Optional:
    if x != 0:
        return Optional(1/x)
    else:
        return Optional()
    
assert safe_reciprocal(4).value() == 0.25
assert safe_reciprocal(0).is_valid() == False
assert safe_reciprocal(-4).is_valid() == True


def safe_root(x: float) -> Optional:
    if x >= 0:
        return Optional(x**0.5)
    else:
        return Optional()
    
assert safe_root(4).value() == 2.0
assert safe_root(0).is_valid() == True
assert safe_root(-4).is_valid() == False
    
safe_root_reciprocal = compose(safe_reciprocal, safe_root)

print(safe_root_reciprocal(4).value()) # 0.5
print(safe_root_reciprocal(0).is_valid()) # False
print(safe_root_reciprocal(-4).is_valid()) # False
print(safe_root_reciprocal(1).value()) # 1.0


