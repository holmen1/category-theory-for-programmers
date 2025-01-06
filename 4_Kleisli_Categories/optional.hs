-- Define the Optional type
data Optional a = None | Some a
    deriving (Show, Eq)

-- Identity morphism for Optional
return :: a -> Optional a
return = Some

-- Function to compose two functions that return Optional values
(>=>) :: (a -> Optional b) -> (b -> Optional c) -> (a -> Optional c)
f >=> g = \x -> case f x of
    None   -> None
    Some y -> g y

-- Function to safely calculate the square root
safeRoot :: (Ord a, Floating a) => a -> Optional a
safeRoot x
    | x < 0     = None
    | otherwise = Some (sqrt x)

-- Function to safely calculate the inverse
safeInverse :: (Eq a, Fractional a) => a -> Optional a
safeInverse x
    | x == 0    = None
    | otherwise = Some (1 / x)

-- Example usage
main :: IO ()
main = do
    let values = [4.0, -1.0, 9.0, 0.0, 16.0]
    let safeRootInverse = safeRoot >=> safeInverse
    mapM_ (printResult safeRootInverse) values

-- Helper function to print the result
printResult :: (Show a, Show b) => (a -> Optional b) -> a -> IO ()
printResult f x = case f x of
    None   -> putStrLn $ "Cannot calculate the result for " ++ show x
    Some y -> putStrLn $ "The result for " ++ show x ++ " is " ++ show y