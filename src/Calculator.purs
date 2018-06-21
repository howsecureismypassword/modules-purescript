module Calculator (UnparsedCharacterSet, calculate) where

import Prelude (($), (+), otherwise, map)
import Math (pow)
import Data.Int(toNumber)
import Data.List (List, fromFoldable, foldl)
import Data.String (length)
import Data.String.Regex (Regex, regex, test)
import Data.String.Regex.Flags (global)
import Data.Either (Either(..))

type UnparsedCharacterSet = {
    name :: String,
    matches :: String,
    value :: Int
}

type CharacterSet = {
    name :: String,
    matches :: Regex,
    value :: Number
}

type CharacterSets = List CharacterSet

regex' :: String -> Either String Regex
regex' s = regex s global

safe :: Either String Regex -> Regex
safe (Right a) = a
safe (Left a) = safe $ regex' "//"

parse :: UnparsedCharacterSet -> CharacterSet
parse { name, matches, value } = {
    name: name,
    matches: safe $ regex' matches,
    value: toNumber value
}

check :: String -> Number -> CharacterSet -> Number
check password acc { matches, value }
    | test matches password = acc + value
    | otherwise = acc

foundIn :: CharacterSets -> String -> Number
foundIn sets password = foldl (check password) 0.0 sets

calculate :: Array UnparsedCharacterSet -> String -> Number
calculate sets password = pow (foundIn sets' password) $ toNumber $ length password
    where sets' = map parse (fromFoldable sets)
