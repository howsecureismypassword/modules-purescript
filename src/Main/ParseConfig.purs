module Main.ParseConfig where

import Prelude (($), (>>=), (<<<), (<>), bind, pure, identity)
import Data.Maybe (Maybe)
import Data.Either (Either, note, either)
import Data.List.NonEmpty (cons, fromFoldable)
import Effect.Exception.Unsafe (unsafeThrow)

import Calculator (Calculation, UnparsedCharacterSet, calculate, parseArray)
import NamedNumber (NamedNumberCalc, NamedNumber, namedNumber)
import Period (PeriodCalc, Period, period)
import Checker (Checker, MessageInput, Pattern, check, parseMessages, checkPatterns, checkDictionary)

-- unparsed config
type CheckConfig = {
    dictionary :: Array String
  , patterns :: Array Pattern
  , messages :: Array MessageInput
}

type TimeConfig = {
    periods :: Array Period
  , namedNumbers :: Array NamedNumber
  , forever :: String
  , instantly :: String
}

type CalculationConfig = {
    calcs :: Number
  , characterSets :: Array UnparsedCharacterSet
}

type UnparsedConfig = {
    calculation :: CalculationConfig
  , time :: TimeConfig
  , checks :: CheckConfig
}

-- parsed config
type FunctionsConfig = {
    calculate :: Calculation
  , period :: PeriodCalc
  , namedNumber :: NamedNumberCalc
  , check :: Checker
}

type VariablesConfig = {
    calcs :: Number
  , forever :: String
  , instantly :: String
}

type ParsedConfig = {
    functions :: FunctionsConfig
  , variables :: VariablesConfig
}

parseConfig :: UnparsedConfig -> ParsedConfig
parseConfig = either unsafeThrow identity <<< parse

invalid :: forall a. String -> Maybe a -> Either String a
invalid name = note ("Invalid " <> name <> " dictionary")

parse :: UnparsedConfig -> Either String ParsedConfig
parse { calculation, time, checks } = do
    -- dictionaries
    periods <- invalid "periods" (fromFoldable time.periods)
    namedNumbers <- invalid "named numbers" (fromFoldable time.namedNumbers)
    characterSets <- invalid "character sets" (parseArray calculation.characterSets)

    -- checks
    dictionary <- invalid "password" (fromFoldable checks.dictionary)
    patterns <- invalid "patterns" (fromFoldable checks.patterns >>= checkPatterns)

    let messages = parseMessages checks.messages

    pure $ {
        functions: {
            calculate: calculate characterSets
          , period: period periods
          , namedNumber: namedNumber namedNumbers
          , check: check (checkDictionary dictionary `cons` patterns) messages
        }
      , variables: {
            calcs: calculation.calcs
          , forever: time.forever
          , instantly: time.instantly
        }
    }
