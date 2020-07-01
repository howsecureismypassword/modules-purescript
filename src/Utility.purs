module Utility (
    findLast
  , format
) where

import Data.List.NonEmpty (NonEmptyList, fromFoldable, head, tail)
import Data.Maybe (maybe)

import Data.String.Regex (Regex, replace)
import Data.String.Regex.Unsafe (unsafeRegex)
import Data.String.Regex.Flags (global)

-- find last
findLast' :: forall a. (a -> Boolean) -> a -> NonEmptyList a -> a
findLast' fn prev list = if fn x then prev else maybe x (findLast' fn x) xs
    where x = head list
          xs = fromFoldable (tail list)

findLast :: forall a. (a -> Boolean) -> NonEmptyList a -> a
findLast fn list = findLast' fn (head list) list

-- number formatting
formatRegex :: Regex
formatRegex = unsafeRegex "(\\d)(?=(\\d\\d\\d)+(?!\\d))" global

format :: String -> String
format number = replace formatRegex "$1," number
