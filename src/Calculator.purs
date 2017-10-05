module Calculator (calculate) where

import Prelude (($), (+), otherwise)
import Math (pow)
import Data.List(foldl)
import Data.Int(toNumber)
import Data.String (length)
import Data.String.Regex (test) as Regex

import Dictionary.CharacterSets (CharacterSets, CharacterSet)

check :: String -> Number -> CharacterSet -> Number
check password acc { test, value }
    | Regex.test test password = acc + value
    | otherwise = acc

foundIn :: CharacterSets -> String -> Number
foundIn sets password = foldl (check password) 0.0 sets

calculate :: CharacterSets -> String -> Number
calculate sets password = pow (foundIn sets password) $ toNumber $ length password
