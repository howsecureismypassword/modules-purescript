module Main (
    main
) where

import Data.Maybe (Maybe(..))

import Calculator (UnparsedCharacterSet, calculate)
import NamedNumber (NamedNumber, namedNumber)
import Period (Period, period)
import Utility (join)

type Config = {
    periods :: Array Period,
    namedNumbers :: Array NamedNumber,
    characterSets :: Array UnparsedCharacterSet,
    calcs :: Number
}

main :: Config -> String -> String
main { periods, namedNumbers, characterSets, calcs } password =
    case time of
         Nothing -> "Something's gone wrong"
         Just { value, name } -> join (namedNumber namedNumbers value) name
    where possibilities = calculate characterSets password
          time = period periods calcs possibilities
