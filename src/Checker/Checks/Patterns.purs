module Checker.Checks.Patterns where

import Prelude (($), (<$>), bind, pure)
import Data.Maybe (Maybe)
import Data.List.NonEmpty (NonEmptyList, catMaybes, fromFoldable)

import Checker.Internal (Checks, Check, read)
import Checker.Checks.Pattern (checkPattern)

type Pattern = {
    regex :: String
  , id :: String
  , level :: String
}

type Patterns = NonEmptyList Pattern

patternToCheck :: Pattern -> Maybe Check
patternToCheck { id, level, regex } = do
    lev <- read level
    pure $ checkPattern id lev regex

checkPatterns :: Patterns -> Maybe Checks
checkPatterns ps = fromFoldable $ catMaybes (patternToCheck <$> ps)
