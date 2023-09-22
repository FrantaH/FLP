-- Projekt: FLP - Varianta termínu - 7. simplify-bkg
-- Autor: František Horázný
-- Login: xhoraz02
-- Rok: 2022


module ParseInput (parseBKG,isMadeOf)  where


import Types (BKG(..), Symbols(..),Rule(..),RightSideRule(..))
import Data.Set (toList,fromList, member)
import Data.Char(isSpace)

-- BKG (Symbols fromList ['A','B']) (Symbols fromList ['a','b']) 'A' [(Rule 'A' (RightSideRule "AbcA")),(Rule 'A' (RightSideRule "a"))]


isntSpace :: Char -> Bool
isntSpace n = not (isSpace n)


parseBKG :: String -> Either String BKG
parseBKG input = (validate . parsers . (map (filter isntSpace)) . lines) input


parsers :: [[Char]] -> BKG
parsers (nts:ts:strt:[]) = 
            BKG 
            (Symbols (fromList (parseNT nts))) 
            (Symbols (fromList (parseT ts))) 
            (parseStart strt)
            []
parsers (nts:ts:strt:ruls) = 
            BKG 
            (Symbols (fromList (parseNT nts))) 
            (Symbols (fromList (parseT ts))) 
            (parseStart strt)
            (parseRules ruls)
parsers _ = BKG (Symbols (fromList [' '])) (Symbols (fromList [' '])) ' ' []


parseNT :: [Char] -> [Char]
parseNT [] = [' ']      --(err input)
parseNT (nt:',':ntt:[]) = nt:(ntt:[])
parseNT (nt:',':xs) = nt : (parseNT xs)
parseNT _ = [' ']       --(err input)


parseT :: [Char] -> [Char]
parseT [] = [' ']      --(err input)
parseT (nt:',':ntt:[]) = nt:(ntt:[])
parseT (nt:',':xs) = nt : (parseNT xs)
parseT _ = [' ']        --(err input)


parseStart :: [Char] -> Char
parseStart [x] = x
parseStart _ = ' '      --(err input)


parseRules :: [[Char]] -> [Rule]
parseRules [x] = [parseRule x]
parseRules [] = []
parseRules (line:xs) = parseRule line:(parseRules xs)


parseRule :: [Char] -> Rule
parseRule (n:'-':'>':[])= Rule n (Empty)
parseRule (n:'-':'>':'#':[])= Rule n (Empty)
parseRule (n:'-':'>':xs)= Rule n (RightSideRule xs)
parseRule _ = BadRule      --(err input)


validate :: BKG -> Either String BKG
validate bkg@(BKG (Symbols nt) (Symbols t) s r)  = if allOk then Right bkg else Left "invalid Input BKG"
    where
    allOk = not (' ' `member` nt)
         && not (' ' `member` t)
         && all (`elem` ['A'..'Z']) (toList nt)
         && all (`elem` ['a'..'z']) (toList t)
         && not (' ' == s)
         && not (BadRule `elem` r)
         && s `member` nt
         && all (isMadeOf (toList nt ++ toList t)) r
validate _ = Left "invalid Input BKG"


isMadeOf :: [Char] -> Rule -> Bool 
isMadeOf _ BadRule = False
isMadeOf symbs (Rule l Empty) = l `elem` symbs
isMadeOf symbs (Rule l (RightSideRule r)) = l `elem` symbs && (all (`elem` symbs) r) 


