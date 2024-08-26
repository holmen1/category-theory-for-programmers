""" 
1. Show that the terminal object is unique up to unique isomorphism.
2. What is a product of two objects in a poset? Hint: Use the uni-
versal construction.
3. What is a coproduct of two objects in a poset?
4. Implement the equivalent of Haskell Either as a generic type in
your favorite language (other than Haskell).
5. Show that Either is a “better” coproduct than int equipped with
two injections:
int i(int n) { return n; }
int j(bool b) { return b? 0: 1; }
Hint: Define a function
int m(Either const & e);
that factorizes i and j.
6. Continuing the previous problem: How would you argue that int
with the two injections i and j cannot be “better” than Either?
7. Still continuing: What about these injections?
int i(int n) {
    if (n < 0) return n;
    return n + 2;
}
int j(bool b) { return b? 0: 1; }
8. Come up with an inferior candidate for a coproduct of int and
bool that cannot be better than Either because it allows multiple
acceptable morphisms from it to Either. """

#1. Show that the terminal object is unique up to unique isomorphism.
#https://statusfailed.com/blog/2019/04/25/what-does-unique-up-to-isomorphism-really-mean.html

#4. Implement the equivalent of Haskell Either as a generic type in python

class Either:
    def __init__(self, left=None, right=None):
        self.left = left
        self.right = right

    @staticmethod
    def make_left(value):
        return Either(left=value)

    @staticmethod
    def make_right(value):
        return Either(right=value)

    @property
    def is_left(self):
        return self.left is not None

    @property
    def is_right(self):
        return self.right is not None

        
# Testing
el = Either.make_left(5)
print(el.is_left)   # True
print(el.left)      # 5

er = Either.make_right(1729)
print(er.is_left)   # False
print(er.right)     # 1729


#5. Show that Either is a “better” coproduct than int equipped with two injections:

def i(n: int) -> int:
    return n

def j(b: bool) -> int:
    return 0 if b else 1

def m(e: Either) -> int:
    if e.is_left:
        return e.left
    return 0 if e.right else 1

#Testing
e = Either.make_left(5)
print(m(e)) # 5

    

 
    