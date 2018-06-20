module Utility where

import Prelude ((&&), (>>=), otherwise, bind)
import Data.List (List, head, tail, null)
import Data.Maybe (Maybe(..), isJust)

findLast :: forall a. (a -> Boolean) -> Maybe a -> List a -> Maybe a
findLast fn prev list = do
    x <- head list
    xs <- tail list
    let val | isJust prev && fn x = prev
            | null xs = Just x
            | otherwise = findLast fn (Just x) xs
    val
