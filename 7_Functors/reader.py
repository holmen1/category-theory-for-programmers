"""
To define a Reader functor in Python, we need to follow the Functor laws and ensure that
our implementation is as strict and correct as possible. The Reader functor can be represented
as a class that encapsulates a function and provides a map method to apply a function to the
result of the encapsulated function.

Here's a step-by-step plan:

Define the Reader class.
Implement the __init__ method to store the function.
Implement the map method to apply a function to the result of the stored function.
Ensure the map method follows the Functor laws:
Identity: reader.map(lambda x: x) == reader
Composition: reader.map(f).map(g) == reader.map(lambda x: g(f(x))) """

class Reader:
    def __init__(self, run):
        self.run = run

    def map(self, func):
        return Reader(lambda r: func(self.run(r)))

# Example usage
def read_int(s):
    return int(s)

def int_to_float(i):
    return float(i)

read_float = Reader(read_int).map(int_to_float)

# Testing the Reader functor
print(read_float.run("42"))  # Output: 42.0

# Functor laws verification
reader = Reader(read_int)

# Identity law
assert reader.map(lambda x: x).run("42") == reader.run("42")

# Composition law
f = int_to_float
g = lambda x: x * 2
assert reader.map(f).map(g).run("42") == reader.map(lambda x: g(f(x))).run("42")
print("All tests passed.")
print('reader.map(lambda x: g(f(x))).run("42")', str(reader.map(lambda x: g(f(x))).run("42")))
# 84.0