import Data.List (isPrefixOf)
{- Simple Algebraic Data Types
Many properties of data structures are composable. For instance, if
you know how to compare values of basic types for equality, and you
know how to generalize these comparisons to product and coproduct types,
you can automatethe derivation of equality operators for composite types. -}

{- Product Types
You can combine an arbitrary number of types into a product by
nesting pairs inside pairs, but there is an easier way: nested pairs are
equivalent to tuples. It’s the consequence of the fact that different ways
of nesting pairs are isomorphic. If you want to combine three types in
a product, a, b, and c, in this order, you can do it in two ways:

((a, b), c)
or
(a, (b, c))

These types are different — you can’t pass one to a function that expects
the other — but their elements are in one-to-one correspondence. There
is a function that maps one to another:-}
alpha :: ((a, b), c) -> (a, (b, c))
alpha ((x, y), z) = (x, (y, z))
--and this function is invertible:
alphaInv :: (a, (b, c)) -> ((a, b), c)
alphaInv (x, (y, z)) = ((x, y), z)
--so it’s an isomorphism.

{-You can interpret the creation of a product type as a binary oper-
ation on types. From that perspective, the above isomorphism looks
very much like the associativity law we’ve seen in monoids:
(a * b) * c = a * (b * c)
Except that, in the monoid case, the two ways of composing products
were equal, whereas here they are only equal “up to isomorphism.” -}

{-If we can live with isomorphisms, and don’t insist on strict equality,
we can go even further and show that the unit type, (), is the unit of the
product.
The type: (a, ()) is isomorphic to a. Here’s the isomorphism: -}
rho :: (a, ()) -> a
rho (x, ()) = x
rhoInv :: a -> (a, ())
rhoInv x = (x, ())
-- ghci> rho ("hello", ())
-- "hello"

-- There is a more general way of defining product types in Haskell —

data Pair a b = P a b

stmt :: Pair String Bool
stmt = P "This statements is" False
--or
stmt' = ("This statements is", False)

--Instead of using generic pairs or tuples, you can also define specific
--named product types, as in:
data Stmt = Stmt String Bool
stmt'' = Stmt "This statements is" False

{- Records
Programming with tuples and multi-argument constructors can get
messy and error prone — keeping track of which component represents
what. It’s often preferable to give names to components. A product type
with named fields is called a record in Haskell, and a struct in C. -}

startsWithSymbol :: (String, String, Int) -> Bool
startsWithSymbol (name, symbol, _) = isPrefixOf symbol name
-- ghci> startsWithSymbol ("Helium", "He", 2)
-- True

{- This code is error prone, and is hard to read and maintain. It’s much
better to define a record: -}
data Element = Element { name :: String
                       , symbol :: String
                       , atomicNumber :: Int }

-- The two representations are isomorphic, as witnessed by these two con-
-- version functions, which are the inverse of each other:
tupleToElem :: (String, String, Int) -> Element
tupleToElem (n, s, a) = Element { name = n
                                , symbol = s
                                , atomicNumber = a }
elemToTuple :: Element -> (String, String, Int)
elemToTuple e = (name e, symbol e, atomicNumber e)

{- With the record syntax for Element, our function startsWithSymbol
becomes more readable: -}
startsWithSymbol' :: Element -> Bool
startsWithSymbol' e = isPrefixOf (symbol e) (name e)
-- ghci> startsWithSymbol' $ tupleToElem ("Helium", "He", 2)
-- True


{- Sum Types
The dual of a product type is a coproduct type. A coproduct type
combines two types into one, but instead of having both types at the
same time, it has one of them.
ust as the product in the category of sets gives rise to product types,
the coproduct gives rise to sum types. The canonical implementation
of a sum type in Haskell is:-}
--data Either a b = Left a | Right b
{-And like pairs, Eithers are commutative (up to isomorphism), can be
nested, and the nesting order is irrelevant (up to isomorphism). So we
can, for instance, define a sum equivalent of a triple:-}
data OneOfThree a b c = Sinistral a | Medial b | Dextral c

{- Simple sum types that encode the presence or absence of a value
is expressed in Haskell using the Maybe type: -}
-- Maybe a = Nothing | Just a

--We could have encoded Maybe as:
data Maybe' a = Either () a

{- For instance, a Haskell list type, which can be defined as a (recursive)
sum type: -}
data List a = Nil | Cons a (List a)

{- The List data type has two constructors, so the deconstruction of
an arbitrary List uses two patterns corresponding to those construc-
tors. One matches the empty Nil list, and the other a Cons-constructed
list. For instance, here’s the definition of a simple function on Lists: -}
maybeTail :: List a -> Maybe (List a)
maybeTail Nil = Nothing
maybeTail (Cons _ t) = Just t

{- Notice that the two constructors Nil and Cons are translated
into two overloaded List constructors with analogous arguments (none,
for Nil; and a value and a list for Cons). -}


{- Algebra of Types
Let’s summarize what we’ve discovered so far. We’ve seen two
commutative monoidal structures underlying the type system: We have
the sum types with Void as the neutral element, and the product types
with the unit type, (), as the neutral element. We’d like to think of
them as analogous to addition and multiplication. In this analogy, Void
would correspond to zero, and unit, (), to one. -}

{- Another thing that links addition and multiplication is the distribu-
tive property:
a * (b + c) = a * b + a * c
Does it also hold for product and sum types? Yes, it does — up to
isomorphisms, as usual. The left hand side corresponds to the type:
(a, Either b c)
and the right hand side corresponds to the type:
Either (a, b) (a, c)

Here’s the function that converts them one way: -}
prodToSum :: (a, Either b c) -> Either (a, b) (a, c)
prodToSum (x, e) =
    case e of
        Left y -> Left (x, y)
        Right z -> Right (x, z)

--and here’s one that goes the other way:
sumToProd :: Either (a, b) (a, c) -> (a, Either b c)
sumToProd e =
    case e of
        Left (x, y) -> (x, Left y)
        Right (x, z) -> (x, Right z)

--Example:
prod1 :: (Int, Either String Float)
prod1 = (2, Left "Hi!")
-- ghci> prodToSum prod1
-- Left (2,"Hi!")

{- Mathematicians have a name for such two intertwined monoids: it’s
called a semiring. It’s not a full ring, because we can’t define subtraction
of types. That’s why a semiring is sometimes called a rig, which is a
pun on “ring without an n” (negative). But barring that, we can get a
lot of mileage from translating statements about, say, natural numbers,
which form a rig, to statements about types. Here’s a translation table
with some entries of interest:

Numbers Types
0       Void
1       ()
a+b     Either a b = Left a | Right b
a*b     (a, b) or Pair a b = Pair a b
2=1+1   data Bool = True | False
1+a     data Maybe = Nothing | Just a

The list type is quite interesting, because it’s defined as a solution to
an equation. The type we are defining appears on both sides of the
equation:
List a = Nil | Cons a (List a)
If we do our usual substitutions, and also replace List a with x, we get
the equation:
x = 1 + a * x

This leads to the following series:
x = 1 + a*x
x = 1 + a*(1 + a*x) = 1 + a + a*a*x
x = 1 + a + a*a*(1 + a*x) = 1 + a + a*a + a*a*a*x
...
x = 1 + a + a*a + a*a*a + a*a*a*a...
We end up with an infinite sum of products (tuples), which can be in-
terpreted as: A list is either empty, 1; or a singleton, a; or a pair, a*a;
or a triple, a*a*a; etc... -}

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

