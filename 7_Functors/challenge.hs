{- 
1. Can we turn the Maybe type constructor into a functor by defining:
fmap _ _ = Nothing
which ignores both of its arguments? (Hint: Check the functor
laws.)
2. Prove functor laws for the reader functor. Hint: it’s really simple.
3. Implement the reader functor in your second favorite language
(the first being Haskell, of course).
4. Prove the functor laws for the list functor. Assume that the laws
are true for the tail part of the list you’re applying it to (in other
words, use induction). -}

-- 1.
-- fmap id Nothing = Nothing = id Nothing
-- fmap id (Just x) = Nothing /= Just x = id (Just x)

-- 2.
-- fmap id f = id . g
--           = g
--           = id g
-- fmap (g . h) f = (g . h) . f
--                = g . (h . f)
--                = fmap g (h . f)
--                = fmap g (fmap h f)
--                = (fmap g . fmap h) f

-- 4.
-- fmap _ Nil = Nil
-- fmap f (Cons x t) = Cons (f x) (fmap f t)

-- fmap id Nil = Nil = id Nil
-- fmap id (Cons x t) = Cons (id x) (fmap id t)
--                    = Cons x (fmap id t)
--                    = Cons x t
--                    = id (Cons x t)

-- fmap (g . h) Nil = Nil = fmap g (fmap h Nil) = (fmap g . fmap h) Nil
-- fmap (g . h) (Cons x t) = Cons ((g . h) x) (fmap (g . h) t)
--                         = Cons ((g . h) x) ((fmap g . fmap h) t)
--                         = Cons (g (h x)) (fmap g (fmap h t))
--                         = fmap g (Cons (h x) (fmap h t))
--                         = fmap g (fmap h (Cons x t))
--                         = (fmap g . fmap h) (Cons x t)
