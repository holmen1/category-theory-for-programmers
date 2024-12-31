# category-theory-for-programmers

This repository contains my solutions to the exercises in the book "Category Theory for Programmers" by Bartosz Milewski

## Set up a Haskell development environment

GHCup makes it easy to install specific versions of GHC and Cabal. It also installs the Haskell Language Server (HLS) which provides IDE-like features for Haskell development
[install](https://www.haskell.org/ghcup/install/)


Sets GHC and cabal to 'recommended' versions:
```bash
$ ghcup set ghc
$ ghcup set cabal
```

### Writing your first Haskell program

In your editor, create a new file named hello.hs. Write the following in it:
```haskell
main :: IO ()
main = do
  putStrLn "Hello, everybody!"
  putStrLn ("Please look at my favorite odd numbers: " ++ show (filter odd [10..20]))
```

You can now compile it with ghc to produce an executable called hello that we will then run:
```bash
$ ghc -o hello hello.hs 
[1 of 2] Compiling Main             ( hello.hs, hello.o )
[2 of 2] Linking hello
$ ./hello
Hello, everybody!
Please look at my favorite odd numbers: [11,13,15,17,19]
```
Alternatively, we can skip the compilation phase by using the command `runghc`:
```bash
$ runghc hello.hs
Hello, everybody!
Please look at my favorite odd numbers: [11,13,15,17,19]
```
this interprets the source file instead of compiling it and does not create build artifacts

Or, you can load your file directly into ghci, which will enable you to play with any functions and other definitions you defined in it
```bash
$ ghci hello.hs 
GHCi, version 9.4.8: https://www.haskell.org/ghc/  :? for help
[1 of 2] Compiling Main             ( hello.hs, interpreted )
Ok, one module loaded.
ghci> main
Hello, everybody!
Please look at my favorite odd numbers: [11,13,15,17,19]
ghci> :l hello.hs
[1 of 2] Compiling Main             ( hello.hs, interpreted )
Ok, one module loaded.
```
`:l hello.hs` is a shortcut for `:load hello.hs` which loads the source file into the interpreter
