module Utility where

import Prelude ((&&),(<>))
import Data.List.NonEmpty (NonEmptyList, fromFoldable, head, tail)
import Data.Maybe (Maybe(..), isJust)

findLast :: forall a. (a -> Boolean) -> Maybe a -> NonEmptyList a -> Maybe a
findLast fn prev list = do
    let x = head list
        xs = fromFoldable (tail list)

    if isJust prev && fn x
        then prev
        else case xs of
            Nothing -> Just x
            Just nxs -> findLast fn (Just x) nxs

join :: String -> String -> String
join str n = str <> " " <> n
