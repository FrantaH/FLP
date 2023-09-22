-- Projekt: FLP - Varianta termínu - 7. simplify-bkg
-- Autor: František Horázný
-- Login: xhoraz02
-- Rok: 2022


module Main (main)  where

import System.Environment (getArgs)
import System.Exit (die)
-- import System.IO (readFile, getLine, putStr, putStrLn, hFlush, stdout)


import Minimize (simpler,simplest)
import ParseInput (parseBKG)
import Types (BKG(..))


main :: IO ()
main = do
    (action, input) <- procArgs =<< getArgs
    either die action (parseBKG input)


-- Zpracování příkazového řádku
procArgs :: [FilePath] -> IO (BKG -> IO (), String)
procArgs [x,y] = do
    input <- readFile y
    return (procFstArg x, input)
procArgs [x] = do
    input <- getContents
    return (procFstArg x, input)
procArgs _ = die "expecting 1 or 2 arguments: -i|-1|-2 [FILE]"

procFstArg :: [Char] -> BKG -> IO ()
procFstArg x = 
    case x of
     "-i" -> dumpBKG
     "-1" -> halfSimpleBKG
     "-2" -> simpleBKG
     _ -> return (die ("unknown option " ++ x))

-- Výpis na stdout při volbě '-i'
dumpBKG :: BKG -> IO ()
dumpBKG bkg = do
    -- putStrLn "dumping BKG ..."
    putStr (show bkg)

halfSimpleBKG :: BKG -> IO ()
halfSimpleBKG bkg = do
    -- putStrLn "printing simpler bkg"
    putStr (show ((\(_,y) -> y)(simpler bkg)))

simpleBKG :: BKG -> IO ()
simpleBKG bkg = do
    -- putStrLn "the simplest bkg"
    putStr (show (simplest (simpler bkg)))



