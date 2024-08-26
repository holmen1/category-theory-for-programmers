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

class Either:

 
    