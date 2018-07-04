module Utility (
    findLast
) where

import Data.List.NonEmpty (NonEmptyList, fromFoldable, head, tail)
import Data.Maybe (maybe)

findLast' :: forall a. (a -> Boolean) -> a -> NonEmptyList a -> a
findLast' fn prev list = if fn x then prev else maybe x (findLast' fn x) xs
    where x = head list
          xs = fromFoldable (tail list)

findLast :: forall a. (a -> Boolean) -> NonEmptyList a -> a
findLast fn list = findLast' fn (head list) list
