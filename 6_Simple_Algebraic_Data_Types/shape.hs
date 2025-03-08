
data Shape = Circle Float | Rect Float Float | Square Float 
    deriving (Show)

area :: Shape -> Float
area (Circle r) = pi * r * r
area (Rect d h) = d * h
area (Square s) = s * s

circ :: Shape -> Float
circ (Circle r) = 2 * pi * r
circ (Rect d h) = 2 * (d + h)
circ (Square s) = 4 * s

main = do
    let shapes = [Circle 5.0, Rect 4.0 6.0, Square 5.0]
    mapM_ (\shape -> print $ "Area: " ++ show (area shape)
                     ++ ", Circumference: " ++ show (circ shape)) shapes


