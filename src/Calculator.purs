module Calculator (UnparsedCharacterSet, calculate) where

import Prelude (($), (+), (<$>), otherwise, bind, pure)
import Math (pow)
import Data.Int(toNumber)
import Data.List (List, fromFoldable, foldl, catMaybes)
import Data.String (length)
import Data.String.Regex (Regex, regex, test)
import Data.String.Regex.Flags (global)
import Data.Maybe (Maybe)
import Data.Either (hush)

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

parse :: UnparsedCharacterSet -> Maybe CharacterSet
parse { name, matches, value } = do
    matches' <- hush (regex matches global)
    pure {
        name,
        matches: matches',
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
    where sets' = catMaybes $ parse <$> (fromFoldable sets)
