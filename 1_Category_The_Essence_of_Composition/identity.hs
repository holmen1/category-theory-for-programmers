data E = EValue
data F = FValue deriving (Eq)

d :: E -> F
d _ = FValue

-- Test the property
testProperty :: E -> Bool
testProperty x = (id . d) x == (d . id) x && (d . id) x == d x

main :: IO ()
main = do
  putStrLn $ show $ testProperty EValue
