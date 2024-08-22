""" 
1. Define a higher-order function (or a function object) memoize in
your favorite language. This function takes a pure function f as
an argument and returns a function that behaves almost exactly
like f, except that it only calls the original function once for every
argument, stores the result internally, and subsequently returns
this stored result every time it’s called with the same argument.
You can tell the memoized function from the original by watch-
ing its performance. For instance, try to memoize a function that
takes a long time to evaluate. You’ll have to wait for the result
the first time you call it, but on subsequent calls, with the same
argument, you should get the result immediately.
2. Try to memoize a function from your standard library that you
normally use to produce random numbers. Does it work?
3. Most random number generators can be initialized with a seed.
Implement a function that takes a seed, calls the random number
generator with that seed, and returns the result. Memoize that
function. Does it work?
4. Which of these C++ functions are pure? Try to memoize them
and observe what happens when you call them multiple times:
memoized and not.
(a) The factorial function from the example in the text.
(b) std::getchar()
(c) bool f() {
        std::cout << "Hello!" << std::endl;
        return true;
    }
(d) int f(int x) {
        static int y = 0;
        y += x;
        return y;
    }
5. How many different functions are there from Bool to Bool? Can
you implement them all?
6. Draw a picture of a category whose only objects are the types
Void, () (unit), and Bool; with arrows corresponding to all pos-
sible functions between these types. Label the arrows with the
names of the functions. """

import time

# 1
def memoize(f):
    memo = {}

    def helper(x):
        if x not in memo:
            memo[x] = f(x)
        return memo[x]
    return helper

def factorial(n):
    if n == 0:
        time.sleep(2)
        return 1
    else:
        return n * factorial(n - 1)
    
memoized_factorial = memoize(factorial)

start_time = time.time()
print(memoized_factorial(5))
print(f"Execution time: {time.time() - start_time:.4f} seconds")
start_time = time.time()
print(memoized_factorial(5))
print(f"Execution time: {time.time() - start_time:.4f} seconds")
# 120
# Execution time: 5.0003 seconds
# 120
# Execution time: 0.0000 seconds

#2
import random

def my_random():
    return random.random()

print(my_random())
# 0.3795568236845458
print(my_random())
# 0.18344727668710903
memoized_random = memoize(my_random)
# print(memoized_random())
# print(memoized_random())
# TypeError: memoize.<locals>.helper() missing 1 required positional argument: 'x'

#3
def seeded_random(seed):
    random.seed(seed)
    return random.random()

memoized_seeded_random = memoize(seeded_random)
print(memoized_seeded_random(905))
# 0.6840807597768621
print(memoized_seeded_random(905))
# 0.6840807597768621

#4
# (a) The factorial function from the example in the text.
# Pure
# (b) std::getchar()
# Impure
# (c) bool f() {
# Impure
# (d) int f(int x) {
# Impure

#5
bool_identity = lambda x: x
bool_inverse = lambda x: not x
bool_true = lambda x: True
bool_false = lambda x: False



