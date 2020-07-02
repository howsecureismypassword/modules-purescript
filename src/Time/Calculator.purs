module Time.Calculator where

import Prelude (($), (+), otherwise)
import Data.BigInt (BigInt, fromInt, pow)
import Data.List.NonEmpty (foldl)
import Data.String (length)
import Config.Types (CharacterSet, CharacterSets)
import Data.String.Regex (test)

check :: String -> Int -> CharacterSet -> Int
check password acc { matches, value }
    | test matches password = acc + value
    | otherwise = acc

foundIn :: CharacterSets -> String -> Int
foundIn sets password = foldl (check password) 0 sets

calculate :: CharacterSets -> String -> BigInt
calculate sets password = (fromInt $ foundIn sets password) `pow` (fromInt $ length password)
