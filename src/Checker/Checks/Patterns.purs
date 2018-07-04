module Checker.Checks.Patterns where

import Prelude (($), (<$>), bind, pure)
import Data.Maybe (Maybe(..))
import Data.List.NonEmpty (NonEmptyList, catMaybes, fromFoldable)
import Data.Either (hush)
import Data.String.Regex (regex, test)
import Data.String.Regex.Flags (noFlags)

import Checker.Internal (Checks, CheckResult, Level, Check, read)

type Pattern = {
    regex :: String
  , id :: String
  , level :: String
}

type Patterns = NonEmptyList Pattern

result :: String -> Level -> CheckResult
result id level = {
    id: id
  , level: level
  , value: Nothing
}

checkPattern :: String -> Level -> String -> Check
checkPattern id level regexString password = do
    rgex <- hush $ regex regexString noFlags

    if test rgex password
        then Just (result id level)
        else Nothing

patternToCheck :: Pattern -> Maybe Check
patternToCheck { id, level, regex } = do
    lev <- read level
    pure $ checkPattern id lev regex

checkPatterns :: Patterns -> Maybe Checks
checkPatterns ps = fromFoldable $ catMaybes (patternToCheck <$> ps)
