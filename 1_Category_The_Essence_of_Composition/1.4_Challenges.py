"""
1. Implement, as best as you can, the identity function in your fa-
vorite language (or the second favorite, if your favorite language
happens to be Haskell).
2. Implement the composition function in your favorite language. It
takes two functions as arguments and returns a function that is
their composition.
3. Write a program that tries to test that your composition function
respects identity.
4. Is the world-wide web a category in any sense? Are links mor-
phisms?
5. Is Facebook a category, with people as objects and friendships as
morphisms?
6. When is a directed graph a category?
"""

def identity(x):
    return x

def composition(f, g):
    return lambda x: f(g(x))

# test
f = lambda x: x + 1
g = lambda x: x * 2

print(composition(f, g)(5)) #> 11

assert composition(identity, f)(1) == f(1)
assert composition(f, identity)(1) == f(1)
assert composition(identity, g)(1) == g(1)
assert composition(g, identity)(1) == g(1)
assert composition(f, g)(1) == f(g(1))
assert composition(g, f)(1) == g(f(1))  
print('All tests passed!')