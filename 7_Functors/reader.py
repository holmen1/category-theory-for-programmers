# We have to solve the following puzzle: given a function f::a->b and a
# function g::r->a, create a function r->b.

def reader(f):
    return lambda r: f(r)

# The function reader is a functor. It takes a function f and returns a
# function that takes a value r and applies f to it. This is a simple
# function composition.

# Let's test it with a simple example. We have a function that reads a string
# and returns an integer. We also have a function that reads an integer and
# returns a float. We want to create a function that reads a string and
# returns a float.

def read_int(s):
    return int(s)

def int_to_float(i):
    return float(i)

read_float = lambda s: int_to_float(reader(read_int)(s))
print(read_float("42")) # 42.0


