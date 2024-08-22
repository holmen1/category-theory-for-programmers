
{- Think of arrows, which are also called morphisms, as functions. You have
a function f that takes an argument of type A and returns a B. You have
another function g that takes a B and returns a C.

You can compose them by passing the result of f to g. You have just defined
a new function h that takes an A and returns a C -}

data A
data B
data C

f :: A -> B
f = undefined
g :: B -> C
g = undefined
-- Their composition is:
c :: A -> C
c = g . f

-- Composition is associative
data D
h :: C -> D
h = undefined

c1 :: A -> D
c1 = h . (g . f)

c2 :: A -> D
c2 = (h . g) . f

c3 :: A -> D
c3 = h . g . f

{- 
For every object A there is an arrow which is a unit of composition. This
arrow loops from the object to itself. Being a unit of composition means
that, when composed with any arrow that either starts at A or ends at A,
respectively, it gives back the same arrow
 -}

data E = EValue deriving (Show)
data F = FValue deriving (Show, Eq)

d :: E -> F
d _ = FValue

-- Test the property
testProperty :: E -> Bool
testProperty x = (id . d) x == (d . id) x && (d . id) x == d x
-- ghci> testProperty EValue
-- True

{- 
To summarize: A category consists of objects and arrows (morphisms).
Arrows can be composed, and the composition is associative.Every object
has an identity arrow that serves as a unit under composition-}

 {- 1.3_Composition_is_the_Essence_of_Programming
"Elegant code creates chunks that are just the right size and come in
just the right number for our mental digestive system to assimilate them.
So what are the right chunks for the composition of programs? Their surface
area has to increase slower than their volume. (I like this analogy because
of the intuition that the surface area of a geometric object grows with the
square of its size — slower than the volume, which grows with the cube of
its size.)
The surface area is the information we need in order to compose chunks. The
volume is the information we need in order to implement them" CTfP p. 9 -}
