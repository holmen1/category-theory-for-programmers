import qualified Control.Applicative as bimap
{- Bifunctors
Since functors are morphisms in Cat (the category of categories), a lot
of intuitions about morphisms — and functions in particular — apply to
functors as well. For instance, just like you can have a function of two
arguments, you can have a functor of two arguments, or a bifunctor.
On objects, a bifunctor maps every pair of objects, one from category
C, and one from category D, to an object in category E. Notice that this
is just saying that it’s a mapping from a cartesian product of categories
C×D to E.
That’s pretty straightforward. But functoriality means that a bifunctor
has to map morphisms as well. This time, though, it must map a pair of
morphisms, one from C and one from D, to a morphism in E.
Again, a pair of morphisms is just a single morphism in the product
category C×D. We define a morphism in a cartesian product of cate-
gories as a pair of morphisms which goes from one pair of objects to
another pair of objects. These pairs of morphisms can be composed in
the obvious way:
(f, g) ◦ (f', g') = (f ◦ f', g ◦ g') 

But an easier way to think about bifunctors is that they are functors
in both arguments. So instead of translating functorial laws — associativity
and identity preservation — from functors to bifunctors, it’s
enough to check them separately for each argument.
Let’s define a bifunctor in Haskell. In this case all three categories
are the same: the category of Haskell types. A bifunctor is a type con-
structor that takes two type arguments. Here’s the definition of the
Bifunctor typeclass taken directly from the library Control.Bifunctor:

class Bifunctor f where
bimap :: (a -> c) -> (b -> d) -> f a b -> f c d
bimap g h = first g . second h
first :: (a -> c) -> f a b -> f c b
first g = bimap g id
second :: (b -> d) -> f a b -> f a d
second = bimap id

There is a default implementation
of bimap in terms of first and second, which shows that it’s enough
to have functoriality in each argument separately to be able to define
a bifunctor.
When declaring an instance of Bifunctor, you have a choice of
either implementing bimap and accepting the defaults for first and
second, or implementing both first and second and accepting the de-
fault for bimap.-}

{- Product and Coproduct Bifunctors
An important example of a bifunctor is the categorical product — a
product of two objects that is defined by a universal construction. If the
product exists for any pair of objects, the mapping from those objects
to the product is bifunctorial. Here’s the Bifunctor instance for a
pair constructor — the simplest product type:

instance Bifunctor (,) where
bimap f g (x, y) = (f x, g y)

The action of the bifunctor here is to make pairs of types, for instance:
(,) a b = (a, b)


By duality, a coproduct, if it’s defined for every pair of objects in a
category, is also a bifunctor. In Haskell, this is exemplified by the Either
type constructor being an instance of Bifunctor:

instance Bifunctor Either where
bimap f _ (Left x) = Left (f x)
bimap _ g (Right y) = Right (g y)

This code also writes itself.

A monoidal category defines a binary operator acting on objects, together
with a unit object. What I haven’t mentioned is that one of the requirements
for a monoidal category is that the binary operator be a bifunctor. This is
a very important requirement — we want the monoidal product to be compatible
with the structure of the category, which is defined by morphisms.-}


{- Functorial Algebraic Data Types
We’ve seen several examples of parameterized data types that turned
out to be functors — we were able to define fmap for them. Complex data
types are constructed from simpler data types. In particular, algebraic
data types (ADTs) are created using sums and products. We have just
seen that sums and products are functorial. We also know that functors
compose. So if we can show that the basic building blocks of ADTs are
functorial, we’ll know that parameterized ADTs are functorial too.

So what are the building blocks of parameterized algebraic data
types? First, there are the items that have no dependency on the type
parameter of the functor, like Nothing in Maybe, or Nil in List. They are
equivalent to the Const functor. Remember, the Const functor ignores
its type parameter (really, the second type parameter, which is the one
of interest to us, the first one being kept constant).

Then there are the elements that simply encapsulate the type parameter
itself, like Just in Maybe. They are equivalent to the identity functor.
I mentioned the identity functor previously, as the identity morphism in Cat,
but didn’t give its definition in Haskell. Here it is:

data Identity a = Identity a
instance Functor Identity where
fmap f (Identity x) = Identity (f x)

You can think of Identity as the simplest possible container that al-
ways stores just one (immutable) value of type a.
Everything else in algebraic data structures is constructed from
these two primitives using products and sums.

With this new knowledge, let’s have a fresh look at the Maybe type
constructor:

data Maybe a = Nothing | Just a

It’s a sum of two types, and we now know that the sum is functorial.
The first part, Nothing can be represented as a Const () acting on a.
The second part is just a different name for the identity functor.
We could have defined Maybe, up to isomorphism, as:

type Maybe a = Either (Const () a) (Identity a)

So Maybe is the composition of the bifunctor Either with two functors,
Const () and Identity.

We’ve already seen that a composition of functors is a functor —
we can easily convince ourselves that the same is true of bifunctors.
All we need is to figure out how a composition of a bifunctor with two
functors works on morphisms. Given two morphisms, we simply lift
one with one functor and the other with the other functor. We then lift
the resulting pair of lifted morphisms with the bifunctor.
We can express this composition in Haskell. Let’s define a data type
that is parameterized by a bifunctor bf (it’s a type variable that is a type
constructor that takes two types as arguments), two functors fu and gu
(type constructors that take one type variable each), and two regular
types a and b. We apply fu to a and gu to b, and then apply bf to the
resulting two types:

newtype BiComp bf fu gu a b = BiComp (bf (fu a) (gu b))

If you’re getting a little lost, try applying BiComp to Either,
Const(), Identity, a, and b, in this order. You will recover our bare-bone
version of Maybe b (a is ignored). The new data type BiComp is a bifunctor
in a and b, but only if bf is itself a Bifunctor and fu and gu are Functors.

bimap (fu a -> fu a') -> (gu b -> gu b')
-> bf (fu a) (gu b) -> bf (fu a') (gu b')

Ex
BiComp Either (Const ()) Identity a b =
BiComp (Either (Const () a) (Identity b)) =
Maybe b

 -}