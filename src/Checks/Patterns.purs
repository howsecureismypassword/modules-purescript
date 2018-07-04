module Checks.Patterns (
    Pattern
  , patterns
) where

import Prelude (($), (<$>), bind, pure)
import Data.Maybe (Maybe)
import Data.List.NonEmpty (NonEmptyList, catMaybes, fromFoldable)

import Checker (Checks, Check, read)
import Checks.Pattern (check)

type Pattern = {
    regex :: String
  , id :: String
  , level :: String
}

type Patterns = NonEmptyList Pattern

patternToCheck :: Pattern -> Maybe Check
patternToCheck { id, level, regex } = do
    lev <- read level
    pure $ check id lev regex

patterns :: Patterns -> Maybe Checks
patterns ps = fromFoldable $ catMaybes (patternToCheck <$> ps)
