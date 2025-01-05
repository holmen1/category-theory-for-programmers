# category-theory-for-programmers

This repository contains my solutions to the exercises in the book "Category Theory for Programmers" by Bartosz Milewski

## 0. Set up a Haskell development environment

GHCup makes it easy to install specific versions of GHC and Cabal. It also installs the Haskell Language Server (HLS) which provides IDE-like features for Haskell development
[install](https://www.haskell.org/ghcup/install/)


Sets GHC and cabal to 'recommended' versions:
```bash
$ ghcup set ghc
$ ghcup set cabal
```

### Writing your first Haskell program

In your editor, create a new file named hello.hs. Write the following in it:
```haskell
main :: IO ()
main = do
  putStrLn "Hello, everybody!"
  putStrLn ("Please look at my favorite odd numbers: " ++ show (filter odd [10..20]))
```

You can now compile it with ghc to produce an executable called hello that we will then run:
```bash
$ ghc -o hello hello.hs 
[1 of 2] Compiling Main             ( hello.hs, hello.o )
[2 of 2] Linking hello
$ ./hello
Hello, everybody!
Please look at my favorite odd numbers: [11,13,15,17,19]
```
Alternatively, we can skip the compilation phase by using the command `runghc`:
```bash
$ runghc hello.hs
Hello, everybody!
Please look at my favorite odd numbers: [11,13,15,17,19]
```
this interprets the source file instead of compiling it and does not create build artifacts

Or, you can load your file directly into ghci, which will enable you to play with any functions and other definitions you defined in it
```bash
$ ghci hello.hs 
GHCi, version 9.4.8: https://www.haskell.org/ghc/  :? for help
[1 of 2] Compiling Main             ( hello.hs, interpreted )
Ok, one module loaded.
ghci> main
Hello, everybody!
Please look at my favorite odd numbers: [11,13,15,17,19]
ghci> :l hello.hs
[1 of 2] Compiling Main             ( hello.hs, interpreted )
Ok, one module loaded.
```
`:l hello.hs` is a shortcut for `:load hello.hs` which loads the source file into the interpreter

## 1. Category: The Essence of Composition

### Arrows as Functions
Think of arrows, which are also called morphisms, as functions. You have
a function f that takes an argument of type A and returns a type B. You have
another function g that takes a type B and returns a type C.

You can compose them by passing the result of f to g. You have just defined
a new function h that takes an A and returns a C

```haskell
data A
data B
data C

f :: A -> B
f = undefined

g :: B -> C
g = undefined

h :: A -> C
h = g . f
```

### Properties of Composition
- Composition is associative
```haskell
data D
k :: C -> D
k = undefined

l :: A -> D
l = k . (g . f)

l' :: A -> D
l' = (k . g) . f

l'' :: A -> D
l'' = k . g . f

l == l' == l''
```
- For every object A there is an arrow which is a unit of composition
This arrow loops from the object to itself. Being a unit of composition means
that, when composed with any arrow that either starts at A or ends at A,
respectively, it gives back the same arrow.

[identity.hs](1_Category_The_Essence_of_Composition/identity.hs)
```haskell
data E = EValue
data F = FValue deriving (Eq)

d :: E -> F
d _ = FValue

-- Test the property
testProperty :: E -> Bool
testProperty x = (id . d) x == (d . id) x && (d . id) x == d x

main :: IO ()
main = do
  putStrLn $ show $ testProperty EValue
```

```bash
$ runghc identity.hs 
True
```

To summarize: A category consists of objects and arrows (morphisms). Arrows can be composed, and the composition is associative. Every object has an identity arrow that serves as a unit under composition.

### Composition is the Essence of Programming
We are solving a non-trivial problem (if it were trivial, we wouldn’t need the help of the computer). And how do we solve problems? We decompose bigger problems into smaller problems. If the smaller problems are still too big, we decompose them further, and so on. Finally, we write code that solves all the small problems. And then comes the essence of programming: we compose those pieces of code to create solutions to larger problems.


## 2. Types and Functions

### Types Are About Composability
Category theory is about composing arrows. But not any two arrows can be composed. The target object of one arrow must be the same as the source source object of the next arrow. In programming we pass the results on one function to another. The program will not work if the target function is not able to correctly interpret the data produced by the source function. The two ends must fit for the composition to work. The stronger the type system of the language, the better this match can be described and mechanically verified.

### Why Do We Need a Mathematical Model?
Consider the definition of a factorial function in Haskell, which is a language quite amenable to denotational semantics:

```haskell
fact n = product [1..n]
```

The expression [1..n] is a list of integers from 1 to n.
The function product multiplies all elements of a list. That’s just like a definition of
factorial taken from a math text. Compare this with C:

```c
int fact(int n) {
  int i;
  int result = 1;
  for (i = 2; i <= n; ++i)
    result *= i;
  return result;
}
```

One of the important advantages of having a mathematical model
for programming is that it’s possible to perform formal proofs of correctness of software.

### Pure and Dirty Functions

In programming languages, functions that always produce the same
result given the same input and have no side effects are called pure functions.
In a pure functional language like Haskell all functions are pure.
Because of that, it’s easier to give these languages denotational semantics and model them using category theory.

### Examples of Types

You can define a function that takes Void, but you can never call it.
To call it, you would have to provide a value of the type Void, and there just aren’t any.
As for what this function can return, there are no restrictions whatsoever. It can return
any type (although it never will, because it can’t be called). In other words it’s a function
that’s polymorphic in the return type. Haskellers have a name for it:
```haskell
f :: Void -> a
f x = absurd x
```

Next is the type that corresponds to a singleton set. It’s a type that has only one possible value.
Conceptually, it takes a dummy value of which there is only one instance
ever, so we don’t have to mention it explicitly. In Haskell, however,
there is a symbol for this value: an empty pair of parentheses, ().
```haskell
f44 :: () -> Integer
f44 () = 44

fInt :: Integer -> ()
fInt _ = ()
```

Notice that the implementation of this function not only doesn’t depend
on the value passed to it, but it doesn’t even depend on the type of the argument.
Functions that can be implemented with the same formula for any
type are called parametrically polymorphic. You can implement a whole
family of such functions with one equation using a type parameter instead of a concrete type. What should we call a polymorphic function from any type to unit type? Of course we’ll call it unit:

```haskell
unit :: a -> ()
unit _ = ()
```

Next in the typology of types is a two-element set. In C++ it’s called
bool and in Haskell, predictably, Bool. The difference is that in C++
bool is a built-in type, whereas in Haskell it can be defined as follows:

```haskell
data Bool = True | False
```

## 3. Categories Great and Small
### Simple graphs
In mathematics, the free category or path category generated by a directed graph is the category that results from freely concatenating arrows together, whenever the target of one arrow is the source of the next.

### Orders
A set with a relation like a <= b and b <= c then a <= c is called a preorder, so a preorder is indeed a category. You can also have a stronger relation, that satisfies an additional condition that, if a <= b and b <= a then a must be the same as b.  That’s called a partial order.

You can also have a stronger relation, that satisfies an additional condition that, if a <= b and b <= a then a must be the same as b. That’s called a partial order Finally, you can impose the condition that any two objects are in a relation with each other, one way or another; and that gives you a linear order or total order.
Let’s characterize these ordered sets as categories. A preorder is a category where there is at most one morphism going from any object a to any object b. Another name for such a category is “thin.” A preorder is a thin category.
A set of morphisms from object a to object b in a category C is called a hom-set and is written as C(a, b) (or, sometimes, HomC (a, b)). So every hom-set in a preorder is either empty or a singleton. That includes the hom-set C(a, a), the set of morphisms from a to a, which must be a singleton, containing only the identity, in any preorder. You may, however, have cycles in a preorder. Cycles are forbidden in a partial order.

It’s very important to be able to recognize preorders, partial orders, and total orders because of sorting. Sorting algorithms, such as quicksort, bubble sort, merge sort, etc., can only work correctly on total orders. Partial orders can be sorted using topological sort.

### Monoid as Set

Traditionally, a monoid is defined as a set with a binary operation.
All that’s required from this operation is that it’s associative, and that
there is one special element that behaves like a unit with respect to it.

In Haskell we can define a type class for monoids — a type for which
there is a neutral element called mempty and a binary operation called
mappend:
```haskell
class Monoid m where
    mempty :: m
    mappend :: m -> m -> m
```
As an example, let’s declare String to be a
monoid by providing the implementation of mempty and mappend:
```haskell
instance Monoid String where
    mempty = ""
    mappend = (++)
```

### Monoid as Category
A monoid is a single object category.  
Every monoid can be described as a single object category with a set
of morphisms that follow appropriate rules of composition.

It turns out that we can always extract a set from a single-object category. This set is the set of morphisms — the adders in our example.
In other words, we have the hom-set M(m, m) of the single object m in
the category M.

A lot of interesting phenomena in category theory have their root
in the fact that elements of a hom-set can be seen both as morphisms,
which follow the rules of composition, and as points in a set. Here,
composition of morphisms in M translates into monoidal product in
the set M(m, m).

## 4. Kleisli Categories
You’ve seen how to model types and pure functions as a category. I also mentioned that there is a way to model side effects, or non-pure functions, in category theory. Let’s have a look at one such example: functions that log or trace their execution. Something that, in an imperative language, would likely be implemented by mutating some global state, as in:

```c++
string logger;
bool negate(bool b) {
  logger += "Not so! ";
  return !b;
}
```


You know that this is not a pure function, because its memoized version
would fail to produce a log. This function has side effects


### The Writer Category
The idea of embellishing the return types of a bunch of functions in
order to piggyback some additional functionality turns out to be very
fruitful. We’ll see many more examples of it. The starting point is our
regular category of types and functions. We’ll leave the types as objects,
but redefine our morphisms to be the embellished functions.

### Writer in Haskell
The same thing in Haskell is a little more terse, and we also get a lot
more help from the compiler. Let’s start by defining the Writer type:

```haskell
type Writer a = (a, String)
```

Our morphisms are functions from an arbitrary type to some Writer type: a -> Writer b  
We’ll declare the composition as a funny infix operator, sometimes called the “fish”. It’s a function of two arguments, each being a function on its own, and returning a function. The first argument is of the type (a->Writer b), the second is (b->Writer c), and the result is (a->Writer c).  
Here’s the definition of this infix operator — the two arguments m1 and m2 appearing on either side of the fishy symbol:

```haskell
(>=>) :: (a -> Writer b) -> (b -> Writer c) -> (a -> Writer c)
m1 >=> m2 = \x ->
    let (y, s1) = m1 x
        (z, s2) = m2 y
    in (z, s1 ++ s2)
```
I will also define the identity morphism for our category, but for reasons that will become clear much later, I will call it return.

```haskell
return :: a -> Writer a
return x = (x, "")
```