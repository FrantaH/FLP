-- Projekt: FLP - Varianta termínu - 7. simplify-bkg
-- Autor: František Horázný
-- Login: xhoraz02
-- Rok: 2022


module Types where


import Data.Set (Set, toList)



type Symbol = Char
data Symbols = Symbols (Set Symbol) deriving (Eq)

instance Show Symbols where
    show (Symbols s) = t (toList s) 
        where
        t [x] = [x]
        t (x:xs) = [x] ++ "," ++ t xs
        t [] = ""

data RightSideRule = Empty | RightSideRule String deriving (Eq)

instance Show RightSideRule where
    show Empty = "#"
    show (RightSideRule x) = x

data Rule = BadRule | Rule {leftSide :: Symbol, rightSide :: RightSideRule} deriving (Eq)

instance Show Rule where
    show (Rule l r)= l : "->" ++ (show r)
    show BadRule = "corrupt rule"

data BKG = None | BKG 
    { nterminals :: Symbols
    , terminals :: Symbols
    , startingNT :: Symbol
    , rules :: [Rule]
    } deriving (Eq)

instance Show BKG where
    show (BKG nt t s r) = show nt ++ "\n" ++ show t ++ "\n" ++ [s] ++ "\n" ++ unlines (map show r)
    show None = "None"
