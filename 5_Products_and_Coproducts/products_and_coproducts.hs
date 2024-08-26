import Data.Void


{- Initial object
The initial object is the object that has one and only one
morphism going to any object in the category -}
absurd = undefined :: Void -> a

{- Terminal object
The terminal object is the object with one and only one mor-
phism coming to it from any object in the category -}
unit :: a -> ()
unit _ = ()

{- Duality 
It turns out that for any category C we can define the opposite category
Cop just by reversing all the arrows. The opposite category automatically
satisfies all the requirements of a category, as long as we simultaneously
redefine composition. If original morphismsf::a->b and g::b->c composed
to h::a->c with h=g◦f, then the reversed morphisms fop ::b->a and gop ::c->b
will compose to hop ::c->a with hop =fop◦gop -}

{- Isomorphisms
An isomorphism is an invertible morphism; or a pair of
morphisms, one being the inverse of the other.
We understand the inverse in terms of composition and identity:
Morphism g is the inverse of morphism f if their composition is the
identity morphism. These are actually two equations because there are
two ways of composing two morphisms: -}
-- f . g = id
-- g . f = id

{- Products
The next universal construction is that of a product.
In Haskell, these two functions
are called fst and snd and they pick, respectively, the first and the
second component of a pair: -}
fst :: (a, b) -> a
fst (x, _) = x
snd :: (a, b) -> b
snd (_, y) = y

{- A product of two objects a and b is the object c equipped
with two projections such that for any other object c’ equipped
with two projections there is a unique morphism m from
c’ to c that factorizes those projections. -}
p :: c -> a
p = undefined
q :: c -> b
q = undefined


m :: c -> (a, b)
m x = (p x, q x)

-- then m is the unique factorizing morphism:
-- p' = fst . m
-- q' = snd . m

{- Coproducts
A coproduct of two objects a and b is the object c equipped
with two injections such that for any other object c’ equipped
with two injections there is a unique morphism m from c
to c’ that factorizes those injections -}

{- Unlike the canonical implementation of the product that is built into
Haskell as the primitive pair, the canonical implementation of the co-
product is a data type called Either, which is defined in the standard
Prelude as: -}
-- Either a b = Left a | Right b

{- In Haskell, you can combine any data types into a tagged union by
separating data constructors with a vertical bar. The Contact example
translates into the declaration: -}
data Contact = PhoneNum Int | EmailAddr String

helpdesk :: Contact
helpdesk = PhoneNum 2222222




