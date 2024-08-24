import Data.Char (toUpper)


-- The same thing in Haskell is a little more terse, and we also get a lot
-- more help from the compiler. Let’s start by defining the Writer type:
-- The type Writer is parameterized by a type variable a and is equivalent to a pair of a and String
type Writer a = (a, String)

-- Our morphisms are functions from an arbitrary type to some Writer
-- type: a -> Writer b
-- We’ll declare the composition as a funny infix operator, sometimes
-- called the “fish”.
-- It’s a function of two arguments, each being a function on its own, and
-- returning a function. The first argument is of the type (a->Writer b),
-- the second is (b->Writer c), and the result is (a->Writer c).
-- Here’s the definition of this infix operator — the two arguments m1
-- and m2 appearing on either side of the fishy symbol:
(>=>) :: (a -> Writer b) -> (b -> Writer c) -> (a -> Writer c)
m1 >=> m2 = \x ->
    let (y, s1) = m1 x
        (z, s2) = m2 y
    in (z, s1 ++ s2)

-- I will also define the identity morphism for our category, but for
-- reasons that will become clear much later, I will call it return.
return :: a -> Writer a
return x = (x, "")

-- For completeness, let’s have the Haskell versions of the embellished
-- functions upCase and toWords:
upCase :: String -> Writer String
upCase s = (map toUpper s, "upCase ")

toWords :: String -> Writer [String]
toWords s = (words s, "toWords ")

-- Finally, the composition of the two functions is accomplished with
-- the help of the fish operator:
process :: String -> Writer [String]
process = upCase >=> toWords

-- ghci> process "hello world"
-- (["HELLO","WORLD"],"upCase toWords ")

{- PS
No, you don't always need to implement the fish operator (>=>) yourself.
The (>=>) operator is already defined in the Control.Monad module in Haskell.
You can simply import it and use it directly. -}