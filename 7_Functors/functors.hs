
{- A functor is a
mapping between categories. Given two categories, C and D, a functor
F maps objects in C to objects in D — it’s a function on objects. If a is
an object in C, we’ll write its image in D as F a .
A functor also maps morphisms — it’s a function on morphisms.
It preserves connections.
So if a morphism f in C connects object a to object b,
f :: a -> b
the image of f in D, F f, will connect the image of a to the image of b:
F f :: F a -> F b -}

{- But
there’s something more to the structure of a category: there’s also the
composition of morphisms. If h is a composition of f and g:
h = g . f
we want its image under F to be a composition of the images of f and
g:
F h = F g . F f
Finally, we want all identity morphisms in C to be mapped to identity
morphisms in D:
F ida = idFa -}

{- The Maybe Functor
The definition of Maybe is a mapping from type a to type Maybe a:
data Maybe a = Nothing | Just a
Here’s an important subtlety: Maybe itself is not a type, it’s a type con-
structor.

But can we turn Maybe into a functor?
For any function from a to b:
f :: a -> b
we would like to produce a function from Maybe a to Maybe b.
So the image of f under Maybe is the function:
f' :: Maybe a -> Maybe b
f' Nothing = Nothing
f' (Just x) = Just (f x)

In Haskell, we implement the
morphism-mapping part of a functor as a higher order function called
fmap. In the case of Maybe, it has the following signature:
fmap :: (a -> b) -> (Maybe a -> Maybe b)

Based on our previous discussion, this is how we implement fmap for
Maybe:
fmap _ Nothing = Nothing
fmap f (Just x) = Just (f x)
-}

{- Equational Reasoning
To prove the functor laws, I will use equational reasoning, which is a
common proof technique in Haskell.
Let’s start with the preservation of identity:
fmap id = id
There are two cases to consider: Nothing and Just. Here’s the first case:
fmap id Nothing = Nothing = id Nothing
The second case is also easy:
fmap id (Just x) = Just (id x) = Just x = id (Just x)

Now, lets show that fmap preserves composition:
fmap (g . f) = fmap g . fmap f
First the Nothing case:
fmap (g . f) Nothing = Nothing
                     = fmap g Nothing
                     = fmap g (fmap f Nothing)

And then the Just case:
fmap (g . f) (Just x) = Just ((g . f) x)
                      = Just (g (f x))
                      = fmap g (Just (f x))
                      = fmap g (fmap f (Just x))
                      = (fmap g . fmap f) (Just x) -}


{- Typeclasses
So how does Haskell deal with abstracting the functor? It uses the type-
class mechanism. A typeclass defines a family of types that support a
common interface. For instance, the class of objects that support equal-
ity is defined as follows:

class Eq a where
    (==) :: a -> a -> Bool

If you want to tell Haskell that a particular type is Eq, you have to
declare it an instance of this class and provide the implementation of
(==). For example, given the definition of a 2D Point (a product type
of two Floats): data Point = Pt Float Float
you can define the equality of points:

instance Eq Point where
    (Pt x y) == (Pt x' y') = x == x' && y == y'

We need a typeclass that’s not a family of types, as was the case with Eq,
but a family of type constructors. Fortunately a Haskell typeclass works
with type constructors as well as with types.
So here’s the definition of the Functor class:

class Functor f where
    fmap :: (a -> b) -> f a -> f b

It stipulates that f is a Functor if there exists a function fmap with the
specified type signature.

Accordingly, when declaring an instance of Functor, you have to give it a
type constructor, as is the case with Maybe:

instance Functor Maybe where
    fmap _ Nothing = Nothing
    fmap f (Just x) = Just (f x)
 -}


{- The List Functor
Any type that is parameterized by another type is a candidate for a functor.
Generic containers are parameterized by the type of the elements they store,
so let’s look at a very simple container, the list:
data List a = Nil | Cons a (List a)

To show that List is a functor we have to define the lifting of functions:
Given a function a->b define a function List a -> List b:
fmap :: (a -> b) -> (List a -> List b)

A function acting on List a must consider two cases corresponding
to the two list constructors. The Nil case is trivial — just return Nil
The Cons case is a bit tricky, because it involves recursion. We have a
list of a, a function f that turns a to b, and we want to generate a list
of b. The obvious thing is to use f to turn each element of the list from
a to b. We apply f to the head and apply the lifted (fmapped) fto the tail.
This is a recursive definition, because we are defining lifted f in terms
of lifted f:
fmap f (Cons x t) = Cons (f x) (fmap f t)
We recurse towards shorter and shorter lists, so we are bound to
eventually reach the empty list, or Nil. Putting it all together, here’s
the instance declaration for the list functor:

instance Functor List where
    fmap _ Nil = Nil
    fmap f (Cons x t) = Cons (f x) (fmap f t)

P.S.
Ah, interesting! It takes a function from one type to another and a list of one type
and returns a list of another type. My friends, I think we have ourselves a functor!
In fact, map is just a fmap that works only on lists. Here's how the list is an instance
of the Functor typeclass.

instance Functor [] where
    fmap = map
 -}


{- The Reader Functor
Consider a mapping of type a to the type of a function returning a. In Haskell,
a function type is constructed using the arrow type constructor (->) which takes
two types: the argument type and the result type. You’ve already seen it in infix
form, a->b, but it can equally well be used in prefix form, when parenthesized:
(->) a b
Just like with regular functions, type functions of more than one argument can
be partially applied. So when we provide just one type argument to the arrow,
it still expects another one. That’s why:
(->) a
is a type constructor. It needs one more type b to produce a complete
type a->b.

Let’s call the argument type r and the result type a, in line with our previous
functor definitions. So our type constructor takes any type a and maps it into
the type r->a

To show that it’s a functor, we want to lift a function a->b to a function that
takes r->a and returns r->b. These are the types that are formed using the type
constructor (->) r acting on, respectively, a and b. Here’s the type signature of
fmap applied to this case:
fmap :: (a -> b) -> (r -> a) -> (r -> b)

We have to solve the following puzzle: given a function f::a->b and a
function g::r->a, create a function r->b. There is only one way we can
compose the two functions, and the result is exactly what we need. So
here’s the implementation of our fmap:

instance Functor ((->) r) where
    fmap f g = f . g

This combination of the type constructor (->) r with the above implementation
of fmap is called the reader functor.
-}

--Example usung the Reader Functor
str2Float :: String -> Float
str2Float = read

float2Int :: Float -> Int
float2Int = round

str2Int :: String -> Int
str2Int = float2Int . str2Float
-- ghci> str2Int "3.7"
-- 4





{- Functors as Containers
Ex nats :: [Integer] nats = [1..]
Haskell effectively blurs the distinction between data and code. A list
could be considered a function, and a function could be considered a table that
maps arguments to results.
As programmers, we don’t like infinities, but in category theory you learn to eat
infinities for breakfast. -}

{- Functor Composition
It’s not hard to convince yourself that functors between categories
compose, just like functions between sets compose. A composition of
two functors, when acting on objects, is just the composition of their
respective object mappings; and similarly when acting on morphisms.

Remember the function maybeTail?
I’ll rewrite it using the Haskell’s built in implementation of lists:
maybeTail :: [a] -> Maybe [a]
maybeTail [] = Nothing
maybeTail (x:xs) = Just xs

The result of maybeTail is of a type that’s a composition of two functors,
Maybe and [], acting on a. maybeTail :: List a -> Maybe (List a)
Each of these functors is equipped with its own version of fmap, but what if
we want to apply some function f to the contents of the composite: a Maybe list?
For instance, let’s see how we can square the elements of a Maybe list of integers:-}
square x = x * x
mis :: Maybe [Int]
mis = Just [1, 2, 3]
mis2 = fmap (fmap square) mis
-- ghci> mis2
-- Just [1,4,9]

mis2' = (fmap . fmap) square mis
-- ghci> mis2'
-- Just [1,4,9]

{- The compiler, after analyzing the types, will figure out that, for the
outer fmap, it should use the implementation from the Maybe instance,
and for the inner one, the list functor implementation. It may not be
immediately obvious that the above code may be rewritten as:
mis2 = (fmap . fmap) square mis
But remember that fmap may be considered a function of just one argument:
fmap :: (a -> b) -> (f a -> f b)
In our case, the second fmap in (fmap . fmap) takes as its argument:
square :: Int -> Int
and returns a function of the type:
[Int] -> [Int]
The first fmap then takes that function and returns a function:
Maybe [Int] -> Maybe [Int] -}
