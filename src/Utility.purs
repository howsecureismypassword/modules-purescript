module Utility (
    findLast
  , formatNumber
  , roundTo
) where

import Prelude ((=<<), (<<<), (+), (*), not)

import Data.Int (quot)
import Data.List.NonEmpty (NonEmptyList, head, findLastIndex, index)
import Data.Maybe (fromMaybe)

import Data.String.Regex (Regex, replace)
import Data.String.Regex.Unsafe (unsafeRegex)
import Data.String.Regex.Flags (global)

-- find last
findLast :: forall a. (a -> Boolean) -> NonEmptyList a -> a
findLast fn list = fromMaybe (head list) last
        where last = index list =<< findLastIndex (not <<< fn) list

-- number formatting
formatRegex :: Regex
formatRegex = unsafeRegex "(\\d)(?=(\\d\\d\\d)+(?!\\d))" global

formatNumber :: String -> String
formatNumber number = replace formatRegex "$1," number

-- round to
roundTo :: Int -> Int -> Int
roundTo to value = 10 * ((value `quot` to) + 1)
