module Main (
    setup
) where

import Prelude (($), (<$>), (>>=), bind, pure, show)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Either (Either(..), note)
import Data.List.NonEmpty (cons, fromFoldable)
import Data.String (joinWith)
import Data.Array as Array

import Calculator (UnparsedCharacterSet, CharacterSets, calculate, parseArray)
import NamedNumber (NamedNumber, Names, namedNumber)
import Period (Period, Periods, period)
import Checker (Checks, Result, check)
import Checks.Dictionary as Dictionary
import Checks.Patterns as Patterns

foreign import unsafeThrow :: String -> (String -> Response)

type UnparsedConfig = {
    calcs :: Number
  , periods :: Array Period
  , namedNumbers :: Array NamedNumber
  , characterSets :: Array UnparsedCharacterSet
  , dictionary :: Array String
  , patterns :: Array Patterns.Pattern
}

type ParsedConfig = {
    calcs :: Number
  , periods :: Periods
  , namedNumbers :: Names
  , characterSets :: CharacterSets
  , checks :: Checks
}

type JSResult = {
    id :: String
  , level :: String
  , value :: String
}

type Response = {
    time :: String
  , checks :: Array JSResult
}

main :: ParsedConfig -> String -> Response
main { calcs, periods, namedNumbers, characterSets, checks } password =
    { time, checks: Array.fromFoldable $ checksToJS <$> check checks password }
    where possibilities = calculate characterSets password
          time = case period periods calcs possibilities of
              Nothing -> "Something's gone wrong"
              Just { value, name } -> joinWith " " [(namedNumber namedNumbers value), name]

checksToJS :: Result -> JSResult
checksToJS { id, level, value } = {
    id
  , level: show level
  , value: fromMaybe "" value
}

setup :: UnparsedConfig -> (String -> Response)
setup config = case parseConfig config of
     Left error -> unsafeThrow error
     Right main' -> main'

parseConfig :: UnparsedConfig -> Either String (String -> Response)
parseConfig { calcs, periods, namedNumbers, characterSets, dictionary, patterns } = do
    -- dictionaries
    periods' <- note "Invalid periods dictionary" (fromFoldable periods)
    namedNumbers' <- note "Invalid named numbers dictionary" (fromFoldable namedNumbers)
    characterSets' <- note "Invalid character sets dictionary" (parseArray characterSets)

    -- checks
    dictionary' <- note "Invalid password dictionary" (fromFoldable dictionary)
    patterns' <- note "Invalid patterns dictionary" (fromFoldable patterns >>= Patterns.patterns)

    pure $ main {
        calcs
      , periods: periods'
      , namedNumbers: namedNumbers'
      , characterSets: characterSets'
      , checks: (Dictionary.check dictionary' `cons` patterns')
    }
