import Data.Void (Void, absurd)

{- Consider the definition of a factorial function in Haskell, which is a
language quite amenable to denotational semantics:

The expression [1..n] is a list of integers from 1 to n -}

fact n = product [1..n]
-- ghci> fact 6
-- 720

{- You can define a function that takes
Void, but you can never call it. To call it, you would have to provide
a value of the type Void, and there just aren’t any. As for what this
function can return, there are no restrictions whatsoever. It can return
any type (although it never will, because it can’t be called). In other
words it’s a function that’s polymorphic in the return type. Haskellers
have a name for it: -}

f :: Void -> a
f x = absurd x

{- Next is the type that corresponds to a singleton set. It’s a type that
has only one possible value.
Conceptually, it takes a dummy value of which there is only one instance
ever, so we don’t have to mention it explicitly. In Haskell, however,
there is a symbol for this value: an empty pair of parentheses, (). -}

f44 :: () -> Integer
f44 () = 44

fInt :: Integer -> ()
fInt _ = ()
-- ghci> fInt 3
-- ()
-- ghci> fInt 'a'
-- <interactive>:25:6: error:

{- Notice that the implementation of this function not only doesn’t depend
on the value passed to it, but it doesn’t even depend on the type of the
argument.
Functions that can be implemented with the same formula for any
type are called parametrically polymorphic. You can implement a whole
family of such functions with one equation using a type parameter in-
stead of a concrete type. What should we call a polymorphic function
from any type to unit type? Of course we’ll call it unit: -}

unit :: a -> ()
unit _ = ()
-- ghci> unit 'a'
-- ()