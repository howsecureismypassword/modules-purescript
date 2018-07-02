module Checks.Patterns (
    Pattern
  , patterns
) where

import Prelude (($), (<$>), bind, pure)
import Data.Maybe (Maybe)
import Data.List (List, fromFoldable, catMaybes)

import Checker (Check, read)
import Checks.Pattern (check)

type Pattern = {
    regex :: String
  , id :: String
  , level :: String
}

patternToCheck :: Pattern -> Maybe Check
patternToCheck { id, level, regex } = do
    lev <- read level
    pure $ check id lev regex

patterns :: Array Pattern -> List Check
patterns ps = catMaybes $ patternToCheck <$> fromFoldable ps
