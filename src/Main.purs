module Main (
    main
) where

import Prelude (($))
import Data.Maybe (Maybe(..))
import Data.List ((:))
import Data.Array (fromFoldable)

import Calculator (UnparsedCharacterSet, calculate)
import NamedNumber (NamedNumber, namedNumber)
import Period (Period, period)
import Checker (Result, check)
import Checks.Dictionary as Dictionary
import Checks.Patterns as Patterns
import Utility (join)

type Config = {
    calcs :: Number
  , periods :: Array Period
  , namedNumbers :: Array NamedNumber
  , characterSets :: Array UnparsedCharacterSet
  , dictionary :: Array String
  , patterns :: Array Patterns.Pattern
}

type Response = {
    time :: String
  , checks :: Array Result
}

main :: Config -> String -> Response
main { calcs, periods, namedNumbers, characterSets, dictionary, patterns } password = { time, checks }
    where possibilities = calculate characterSets password

          time = case period periods calcs possibilities of
              Nothing -> "Something's gone wrong"
              Just { value, name } -> join (namedNumber namedNumbers value) name

          checks = fromFoldable $ check (Dictionary.check dictionary : Patterns.patterns patterns) password
