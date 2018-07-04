module Main.ParseConfig where

import Prelude (($), (>>=), bind, pure)
import Data.Either (Either(..), note)
import Data.List.NonEmpty (cons, fromFoldable)

import Calculator (Calculation, UnparsedCharacterSet, calculate, parseArray)
import NamedNumber (NamedNumberCalc, NamedNumber, namedNumber)
import Period (PeriodCalc, Period, period)
import Checker (Checker, MessageInput, Pattern, check, parseMessages, checkPatterns, checkDictionary)

foreign import unsafeThrow :: String -> ParsedConfig

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

type ParsedConfig = {
    calcs :: Number
  , calculate' :: Calculation
  , period' :: PeriodCalc
  , namedNumber' :: NamedNumberCalc
  , check' :: Checker
  , forever :: String
  , instantly :: String
}

parseConfig :: UnparsedConfig -> ParsedConfig
parseConfig config = case parseConfig' config of
     Left error -> unsafeThrow error
     Right config' -> config'

parseConfig' :: UnparsedConfig -> Either String ParsedConfig
parseConfig' { calculation, time, checks } = do
    -- dictionaries
    periods' <- note "Invalid periods dictionary" (fromFoldable time.periods)
    namedNumbers' <- note "Invalid named numbers dictionary" (fromFoldable time.namedNumbers)
    characterSets' <- note "Invalid character sets dictionary" (parseArray calculation.characterSets)

    -- checks
    dic' <- note "Invalid password dictionary" (fromFoldable checks.dictionary)
    patterns' <- note "Invalid patterns dictionary" (fromFoldable checks.patterns >>= checkPatterns)

    let messages = parseMessages checks.messages

    pure $ {
        calcs: calculation.calcs
      , calculate': calculate characterSets'
      , period': period periods'
      , namedNumber': namedNumber namedNumbers'
      , check': check (checkDictionary dic' `cons` patterns') messages
      , forever: time.forever
      , instantly: time.instantly
    }
