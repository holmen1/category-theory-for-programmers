
eitherToPair :: Either a a -> (Bool, a)
eitherToPair (Left x) = (False, x)
eitherToPair (Right x) = (True, x)

pairToEither :: (Bool, a) -> Either a a
pairToEither (False, x) = Left x
pairtoEither (True, x) = Right x

main :: IO ()
main = do
    print $ (pairToEither . eitherToPair) (Left 42)
