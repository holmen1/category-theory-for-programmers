

-- A simple function that takes two variables
add a b = a + b

--ghci> add 2 3
--5

-- Fibonacci using recursion and pattern matching
fib 0 = 0
fib 1 = 1
fib n = fib (n-1) + fib (n-2)

--ghci> fib 10
--55

-- Another Fibonacci using guards
fib2 n
    | n == 0 = 0
    | n == 1 = 1
    | otherwise = fib2 (n-1) + fib2 (n-2)

--ghci> fib2 10
--55

-- Anonymous functions (lambda)
-- ghci> map (\x -> x + 2) [1..5]
-- [3,4,5,6,7]


-- Accumulate list from left or right
-- ghci> foldl (/) 1 [1..3]
-- 0.16666666666666666 = 1/(2/(1/3))

-- ghci> foldr (/) 1 [1..3]
-- 1.5 = 1/(2/(3/1))

divisible :: Integral a => a -> a -> Bool
divisible m n = rem m n == 0
nosevens = filter (\x -> not (divisible x 7)) [1..]
-- ghci> nosevens !! 100
-- 117