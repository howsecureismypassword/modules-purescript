module Calculator.Internal where

import Prelude (($), (+), (<$>), otherwise, bind, pure)
import Data.BigInt (BigInt, fromInt, pow)
import Data.List.NonEmpty (NonEmptyList, fromFoldable, foldl, catMaybes)
import Data.String (length)
import Data.String.Regex (Regex, regex, test)
import Data.String.Regex.Flags (global)
import Data.Maybe (Maybe)
import Data.Either (hush)

type UnparsedCharacterSet = {
    name :: String
  , matches :: String
  , value :: Int
}

type CharacterSet = {
    name :: String
  , matches :: Regex
  , value :: Int
}

type CharacterSets = NonEmptyList CharacterSet

-- unparsed array
parse :: UnparsedCharacterSet -> Maybe CharacterSet
parse { name, matches, value } = do
    matches' <- hush (regex matches global)
    pure { name, matches: matches', value }

parseArray :: Array UnparsedCharacterSet -> Maybe CharacterSets
parseArray sets = do
    sets' <- fromFoldable sets
    fromFoldable $ catMaybes (parse <$> sets')

-- checks
check :: String -> Int -> CharacterSet -> Int
check password acc { matches, value }
    | test matches password = acc + value
    | otherwise = acc

foundIn :: CharacterSets -> String -> Int
foundIn sets password = foldl (check password) 0 sets

type Calculation = String -> BigInt

calculate :: CharacterSets -> Calculation
calculate sets password = (fromInt $ foundIn sets password) `pow` (fromInt $ length password)
