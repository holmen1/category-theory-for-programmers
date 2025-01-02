# category-theory-for-programmers

This repository contains my solutions to the exercises in the book "Category Theory for Programmers" by Bartosz Milewski

## 0 Set up a Haskell development environment

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
