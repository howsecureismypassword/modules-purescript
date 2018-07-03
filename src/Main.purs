module Main (
    setup
) where

import Prelude (($))
import Data.Maybe (Maybe(..))
import Data.List (List, (:), fromFoldable)
import Data.Array as Array

import Calculator (UnparsedCharacterSet, CharacterSet, calculate, parseArray)
import NamedNumber (NamedNumber, namedNumber)
import Period (Period, period)
import Checker (Check, Result, check)
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
  , periods :: List Period
  , namedNumbers :: List NamedNumber
  , characterSets :: List CharacterSet
  , checks :: List Check
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


setup :: UnparsedConfig -> (String -> Response)
setup { calcs, periods, namedNumbers, characterSets, dictionary, patterns } =
    main {
        calcs,
        periods: fromFoldable periods
      , namedNumbers: fromFoldable namedNumbers
      , characterSets: parseArray characterSets
      , checks: (Dictionary.check (fromFoldable dictionary) : Patterns.patterns (fromFoldable patterns))
    }
