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
