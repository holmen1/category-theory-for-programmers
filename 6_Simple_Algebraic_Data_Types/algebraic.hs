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
data Either a b = Left a | Right b
{-And like pairs, Eithers are commutative (up to isomorphism), can be
nested, and the nesting order is irrelevant (up to isomorphism). So we
can, for instance, define a sum equivalent of a triple:-}
data OneOfThree a b c = Sinistral a | Medial b | Dextral c