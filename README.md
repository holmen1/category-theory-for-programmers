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
fruitful. We’ll see many more examples of it. The starting point is our regular category of types and functions. We’ll leave the types as objects, but redefine our morphisms to be the embellished functions.  
See [writer.cpp](4_Kleisli_Categories/writer.cpp)


### Writer in Haskell
The same thing in Haskell is a little more terse, and we also get a lot
more help from the compiler:

```haskell
type Writer a = (a, String)

(>=>) :: (a -> Writer b) -> (b -> Writer c) -> (a -> Writer c)
m1 >=> m2 = \x ->
    let (y, s1) = m1 x
        (z, s2) = m2 y
    in (z, s1 ++ s2)

return :: a -> Writer a
return x = (x, "")
```

Our morphisms are functions from an arbitrary type to some Writer type: a -> Writer b  
We’ll declare the composition as a funny infix operator, sometimes called the “fish”. It’s a function of two arguments, each being a function on its own, and returning a function. The first argument is of the type (a->Writer b), the second is (b->Writer c), and the result is (a->Writer c).  
See [writer.hs](4_Kleisli_Categories/writer.hs) for the full implementation.

### Maybe as a Kleisli Category
This Optional type is Maybe renamed. It’s a type constructor that takes a type and returns a new type. It’s a type-level function. It’s a functor. It’s a monad.

```haskell
data Optional a = None | Some a
    deriving (Show, Eq)

(>=>) :: (a -> Optional b) -> (b -> Optional c) -> (a -> Optional c)
f >=> g = \x -> case f x of
    None   -> None
    Some y -> g y
```

See [optional.hs](4_Kleisli_Categories/optional.hs) for the full implementation.

### Kleisli Categories
For our limited purposes, a Kleisli category has, as objects, the types of the underlying programming language. Morphisms from type A to type B are functions that go from
A to a type derived from B using the particular embellishment. Each
Kleisli category defines its own way of composing such morphisms, as
well as the identity morphisms with respect to that composition.  

Kleisli categories are a generalization of the concept of a category. They are categories where the hom-sets are not just sets but monads. The composition of morphisms is defined by the monadic bind operation, and the identity morphism is defined by the monadic return operation.

Make sure you understand the difference between the regular composition of functions and the composition of Kleisli arrows. The former is a binary operation on functions, while the latter is a binary operation on morphisms in a category. The composition of functions is associative, while the composition of Kleisli arrows is associative only up to a natural transformation.

Haskell's type system and functional programming features allow us to define and work with custom types like Optional in an elegant and expressive way. The Optional type, similar to Maybe, provides a way to handle optional values, and the composition of functions returning Optional values showcases the power of Haskell's functional composition.


## 5. Products and Coproducts
### Initial Object
The initial object is the object that has one and only one
morphism going to any object in the category.
For example, in the category of sets and functions, the initial object is the empty set. Remember, an empty set corresponds to the Haskell type Void
and the unique polymorphic function from Void to any other type is called absurd:
```haskell 
absurd = undefined :: Void -> a
```

### Terminal Object
The terminal object is the object with one and only one morphism coming to it from any object in the category.
```haskell
unit :: a -> ()
unit _ = ()
```

### Duality
It turns out that for any category C we can define the opposite category
Cop just by reversing all the arrows. The opposite category automatically
satisfies all the requirements of a category, as long as we simultaneously
redefine composition. If original morphisms `f::a->b` and `g::b->c` composed
to `h::a->c` with `h = g◦f`, then the reversed morphisms `fop::b->a` and `gop::c->b` will compose to `hop::c->a` with `hop=fop◦gop`.

### Isomorphisms
An isomorphism is an invertible morphism; or a pair of
morphisms, one being the inverse of the other.
We understand the inverse in terms of composition and identity:
Morphism g is the inverse of morphism f if their composition is the
identity morphism. These are actually two equations because there are
two ways of composing two morphisms:
```haskell
f . g = id
g . f = id
```

### Products
The next universal construction is that of a product.
In Haskell, these two functions
are called fst and snd and they pick, respectively, the first and the
second component of a pair:
```haskell
fst :: (a, b) -> a
fst (x, _) = x
snd :: (a, b) -> b
snd (_, y) = y
```

A product of two objects a and b is the object c equipped
with two projections such that for any other object c’ equipped
with two projections there is a unique morphism m from
c’ to c that factorizes those projections.
```haskell
p :: c -> a
p = undefined
q :: c -> b
q = undefined

m :: c -> (a, b)
m x = (p x, q x)
```
then m is the unique factorizing morphism:
```haskell
p' = fst . m
q' = snd . m
```

### Coproducts
A coproduct of two objects a and b is the object c equipped
with two injections such that for any other object c’ equipped
with two injections there is a unique morphism m from c
to c’ that factorizes those injections.

Unlike the canonical implementation of the product that is built into
Haskell as the primitive pair, the canonical implementation of the coproduct is a data type called Either, which is defined in the standard
Prelude as:
```haskell
Either a b = Left a | Right b
```

Just as we’ve defined the factorizer for a product, we can define one
for the coproduct. Given a candidate type c and two candidate injections i and j, the factorizer for Either produces the factoring function:

```haskell
factorizer :: (a -> c) -> (b -> c) -> Either a b -> c
factorizer i j (Left a) = i a
factorizer i j (Right b) = j b
```

In Haskell, you can combine any data types into a tagged union by
separating data constructors with a vertical bar.
```haskell
data LockerState = Taken | Free deriving (Show, Eq)
type Code = String
type LockerMap = Map.Map Int (LockerState, Code)

lockerLookup :: Int -> LockerMap -> Either String Code  
lockerLookup lockerNumber map = 
    case Map.lookup lockerNumber map of  
        Nothing -> Left $ "Locker number " ++ show lockerNumber ++ " doesn't exist!"  
        Just (state, code) -> if state /= Taken  
                                then Right code  
                                else Left $ "Locker " ++ show lockerNumber ++ " is already taken!"

lockers :: LockerMap  
lockers = Map.fromList  
    [(100,(Taken,"ZD39I"))  
    ,(101,(Free,"JAH3I"))  
    ,(103,(Free,"IQSA9"))  
    ,(105,(Free,"QOTSA"))  
    ,(109,(Taken,"893JJ"))  
    ,(110,(Taken,"99292"))  
    ]
```
```haskell
ghci> lockerLookup 101 lockers
Right "JAH3I"
ghci> lockerLookup 102 lockers
Left "Locker number 102 doesn't exist!"
ghci> lockerLookup 105 lockers
Right "QOTSA"
ghci> lockerLookup 110 lockers
Left "Locker 110 is already taken!"
```

## 6. Simple Algebraic Data Types
Many properties of data structures are composable. For instance, if
you know how to compare values of basic types for equality, and you
know how to generalize these comparisons to product and coproduct types,
you can automate the derivation of equality operators for composite types.

### Product Types
You can combine an arbitrary number of types into a product by
nesting pairs inside pairs, but there is an easier way: nested pairs are
equivalent to tuples. It’s the consequence of the fact that different ways
of nesting pairs are isomorphic. If you want to combine three types in
a product, a, b, and c, in this order, you can do it in two ways:
```haskell
((a, b), c)
or
(a, (b, c))
```

These types are different — you can’t pass one to a function that expects
the other — but their elements are in one-to-one correspondence. There
is a function that maps one to another:
```haskell
alpha :: ((a, b), c) -> (a, (b, c))
alpha ((x, y), z) = (x, (y, z))
```
and this function is invertible:
```haskell
alphaInv :: (a, (b, c)) -> ((a, b), c)
alphaInv (x, (y, z)) = ((x, y), z)
```
so it’s an isomorphism.

You can interpret the creation of a product type as a binary operation on types. From that perspective, the above isomorphism looks very much like the associativity law we’ve seen in monoids:
```(a * b) * c = a * (b * c)```
Except that, in the monoid case, the two ways of composing products
were equal, whereas here they are only equal “up to isomorphism.”

If we can live with isomorphisms, and don’t insist on strict equality,
we can go even further and show that the unit type, (), is the unit of the
product.
The type: (a, ()) is isomorphic to a. Here’s the isomorphism:
```haskell
rho :: (a, ()) -> a
rho (x, ()) = x
rhoInv :: a -> (a, ())
rhoInv x = (x, ())
```

There is a more general way of defining product types in Haskell
```haskell
data Pair a b = P a b
```
```haskell
stmt :: Pair String Bool
stmt = P "This statements is" False
--or
stmt' = ("This statements is", False)
```

Instead of using generic pairs or tuples, you can also define specific
named product types, as in:
```haskell
data Stmt = Stmt String Bool
stmt'' = Stmt "This statements is" False
```

### Records
Programming with tuples and multi-argument constructors can get
messy and error prone — keeping track of which component represents
what. It’s often preferable to give names to components. A product type
with named fields is called a record in Haskell, and a struct in C.

```haskell
startsWithSymbol :: (String, String, Int) -> Bool
startsWithSymbol (name, symbol, _) = isPrefixOf symbol name
```
ghci> startsWithSymbol ("Helium", "He", 2)  
True

This code is error prone, and is hard to read and maintain. It’s much
better to define a record:
```haskell
data Element = Element { name :: String
                       , symbol :: String
                       , atomicNumber :: Int }
```

The two representations are isomorphic, as witnessed by these two conversion functions, which are the inverse of each other:
```haskell
tupleToElem :: (String, String, Int) -> Element
tupleToElem (n, s, a) = Element { name = n
                                , symbol = s
                                , atomicNumber = a }
elemToTuple :: Element -> (String, String, Int)
elemToTuple e = (name e, symbol e, atomicNumber e)
```

With the record syntax for Element, our function startsWithSymbol
becomes more readable:
```haskell
startsWithSymbol' :: Element -> Bool
startsWithSymbol' e = isPrefixOf (symbol e) (name e)
```
ghci> startsWithSymbol' $ tupleToElem ("Helium", "He", 2)  
True

### Sum Types
The dual of a product type is a coproduct type. A coproduct type
combines two types into one, but instead of having both types at the
same time, it has one of them.
Just as the product in the category of sets gives rise to product types,
the coproduct gives rise to sum types. The canonical implementation
of a sum type in Haskell is:
```haskell
data Either a b = Left a | Right b
```
And like pairs, Eithers are commutative (up to isomorphism), can be
nested, and the nesting order is irrelevant (up to isomorphism). So we
can, for instance, define a sum equivalent of a triple:
```haskell
data OneOfThree a b c = Sinistral a | Medial b | Dextral c
```

Simple sum types that encode the presence or absence of a value
is expressed in Haskell using the Maybe type:
```haskell
data Maybe a = Nothing | Just a
```

We could have encoded Maybe as:
```haskell
data Maybe' a = Either () a
```

For instance, a Haskell list type, which can be defined as a (recursive)
sum type:
```haskell
data List a = Nil | Cons a (List a)
```

The List data type has two constructors, so the deconstruction of
an arbitrary List uses two patterns corresponding to those constructors. One matches the empty Nil list, and the other a Cons-constructed
list. For instance, here’s the definition of a simple function on Lists:
```haskell
maybeTail :: List a -> Maybe (List a)
maybeTail Nil = Nothing
maybeTail (Cons _ t) = Just t
```

Notice that the two constructors Nil and Cons are translated
into two overloaded List constructors with analogous arguments (none,
for Nil; and a value and a list for Cons).


### Algebra of Types
Let’s summarize what we’ve discovered so far. We’ve seen two
commutative monoidal structures underlying the type system: We have
the sum types with Void as the neutral element, and the product types
with the unit type, (), as the neutral element. We’d like to think of
them as analogous to addition and multiplication. In this analogy, Void
would correspond to zero, and unit, (), to one.

Another thing that links addition and multiplication is the distributive property:
```haskell
a * (b + c) = a * b + a * c
```
Does it also hold for product and sum types? Yes, it does — up to
isomorphisms, as usual. The left hand side corresponds to the type:
```(a, Either b c)```
and the right hand side corresponds to the type:
```Either (a, b) (a, c)```

Here’s the function that converts them one way:
```haskell
prodToSum :: (a, Either b c) -> Either (a, b) (a, c)
prodToSum (x, e) =
    case e of
        Left y -> Left (x, y)
        Right z -> Right (x, z)
```

and here’s one that goes the other way:
```haskell
sumToProd :: Either (a, b) (a, c) -> (a, Either b c)
sumToProd e =
    case e of
        Left (x, y) -> (x, Left y)
        Right (x, z) -> (x, Right z)
```

Example:
```haskell
prod1 :: (Int, Either String Float)
prod1 = (2, Left "Hi!")
```
ghci> prodToSum prod1  
Left (2,"Hi!")

Mathematicians have a name for such two intertwined monoids: it’s
called a semiring. It’s not a full ring, because we can’t define subtraction
of types. That’s why a semiring is sometimes called a rig, which is a
pun on “ring without an n” (negative). But barring that, we can get a
lot of mileage from translating statements about, say, natural numbers,
which form a rig, to statements about types. Here’s a translation table
with some entries of interest:

| Numbers | Types                         |
|---------|-------------------------------|
| 0       | Void                          |
| 1       | ()                            |
| a + b     | Either a b = Left a \| Right b |
| a * b     | (a, b) or Pair a b = Pair a b |
| 2 = 1 + 1   | data Bool = True \| False      |
| 1 + a     | data Maybe = Nothing \| Just a |

The list type is quite interesting, because it’s defined as a solution to
an equation. The type we are defining appears on both sides of the
equation:
```haskell
List a = Nil | Cons a (List a)
```
If we do our usual substitutions, and also replace List a with x, we get
the equation: ```x = 1 + a * x```

This leads to the following series:
```
x = 1 + a * x
x = 1 + a * (1 + a * x) = 1 + a + a * a* x
x = 1 + a + a *a * (1 + a * x) = 1 + a + a * a + a * a * a * x
...
x = 1 + a + a * a + a * a * a + a * a * a * a...
```
We end up with an infinite sum of products (tuples), which can be in-
terpreted as: A list is either empty, 1; or a singleton, a; or a pair, a*a;
or a triple, a*a*a; etc...

{- Challenges
Here’s a sum type defined in Haskell: -}
data Shape = Circle Float | Rect Float Float
--When we want to define a function like area that acts on a Shape,
--we do it by pattern matching on the two constructors:
area :: Shape -> Float
area (Circle r) = pi * r * r
area (Rect d h) = d * h
circ :: Shape -> Float
circ (Circle r) = 2.0 * pi * r
circ (Rect d h) = 2.0 * (d + h)

c = Circle 2.0
r = Rect 4.0 3.0
main :: IO ()
main = do
    print $ "Circle area: " ++ show (area c)
    print $ "Rectangle area: " ++ show (area r)
    print $ "Circle circumference: " ++ show (circ c)
    print $ "Rectangle perimeter: " ++ show (circ r)
-- ghci> main
-- "Circle area: 12.566371"
-- "Rectangle area: 12.0"
-- "Circle circumference: 12.566371"
-- "Rectangle perimeter: 14.0"

