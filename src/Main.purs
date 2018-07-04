module Main (
    setup
) where

import Prelude (($), (>>=), bind, pure)
import Data.Maybe (Maybe(..))
import Data.List.NonEmpty (cons, fromFoldable)
import Data.Array as Array

import Calculator (UnparsedCharacterSet, CharacterSets, calculate, parseArray)
import NamedNumber (NamedNumber, Names, namedNumber)
import Period (Period, Periods, period)
import Checker (Checks, Result, check)
import Checks.Dictionary as Dictionary
import Checks.Patterns as Patterns
import Utility (join)

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

type Response = {
    time :: String
  , checks :: Array Result
}

main :: ParsedConfig -> String -> Response
main { calcs, periods, namedNumbers, characterSets, checks } password =
    { time, checks: Array.fromFoldable $ check checks password }
    where possibilities = calculate characterSets password
          time = case period periods calcs possibilities of
              Nothing -> "Something's gone wrong"
              Just { value, name } -> join (namedNumber namedNumbers value) name


setup :: UnparsedConfig -> Maybe (String -> Response)
setup { calcs, periods, namedNumbers, characterSets, dictionary, patterns } = do

    -- dictionaries
    periods' <- fromFoldable periods
    namedNumbers' <- fromFoldable namedNumbers
    characterSets' <- parseArray characterSets

    -- checks
    dictionary' <- fromFoldable dictionary
    patterns' <- fromFoldable patterns >>= Patterns.patterns

    pure $ main {
        calcs
      , periods: periods'
      , namedNumbers: namedNumbers'
      , characterSets: characterSets'
      , checks: (Dictionary.check dictionary' `cons` patterns')
    }
