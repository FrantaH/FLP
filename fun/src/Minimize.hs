-- Projekt: FLP - Varianta termínu - 7. simplify-bkg
-- Autor: František Horázný
-- Login: xhoraz02
-- Rok: 2022


module Minimize where

import Types
import Data.Set (fromList,toList)
import ParseInput (isMadeOf)
import Data.List (intersect)
import Data.Char(isAlpha)

simpler :: BKG -> (Bool,BKG)
simpler (BKG _ (Symbols t) s r) = ((isEmptyBKG s newNT), (BKG (Symbols (fromList (s:newNT))) (Symbols t) s newR))
    where (newR,newNT) = (terminatingNt [] [] r)
simpler bkg = (False, bkg)

isEmptyBKG  :: Symbol -> [Symbol] -> Bool
isEmptyBKG s newNT = not (s `elem` newNT)


terminatingNt :: [Symbol] -> [Symbol] -> [Rule] -> ([Rule],[Symbol])
terminatingNt [] [] r = terminatingNt (((map leftSide) . (filter (isWantedRule []))) r) [] r --zavolej sebe se všemi terminály a levé strany od Empty pravidel
terminatingNt inputInfo old r = if inputInfo == old then ((((filter (isWantedRule old))) r),old) 
    else terminatingNt (((map leftSide) . (filter (isWantedRule inputInfo))) r) inputInfo r   --vrať levé strany pravidel


isWantedRule :: [Char] -> Rule -> Bool
isWantedRule _ (Rule _ Empty) = True
isWantedRule symbs (Rule _ (RightSideRule r)) = all (`elem` symbs++['a'..'z']) r     --r má na pravé straně pouze symboly z symbs
isWantedRule _ _ = False



simplest :: (Bool,BKG) -> BKG
simplest (isEmpty, (BKG (Symbols nt) (Symbols t) s r)) = if isEmpty then BKG (Symbols (fromList [s])) (Symbols (fromList [])) s [] 
    else BKG (Symbols (fromList (intersect (toList nt) reachableS))) (Symbols (fromList (intersect (toList t) reachableS))) s (filter (isMadeOf reachableS) r)    
        where reachableS = genSymbs [s] [] r
simplest (_,bkg) = bkg


genSymbs :: [Char] -> [Symbol] -> [Rule] -> [Symbol]
genSymbs inputInfo old ruls = if inputInfo == old then old 
    else genSymbs (((filter isAlpha) . concat . (map show) . (filter (isWantedRule2 inputInfo))) ruls) inputInfo ruls


isWantedRule2 :: [Symbol] -> Rule -> Bool
isWantedRule2 symbs (Rule l _) = l `elem` symbs
isWantedRule2 _ _ = False
