module Main (
    UnparsedConfig
  , Response
  , JSResult
  , setup
) where

import Prelude (($), (<$>), (>>=), (==), bind, pure, show)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Either (Either(..), note)
import Data.List.NonEmpty (cons, fromFoldable)
import Data.String (joinWith)
import Data.BigInt (BigInt)
import Data.Array as Array
import Data.Nullable (Nullable(), toNullable)

import Calculator (Calculation, UnparsedCharacterSet, calculate, parseArray)
import NamedNumber (NamedNumberCalc, NamedNumber, namedNumber)
import Period (PeriodCalc, Period, period)
import Checker (Checker, Result, MessageInput, check, parseMessages)
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
  , checkMessages :: Array MessageInput
}

type ParsedConfig = {
    calcs :: Number
  , calculate' :: Calculation
  , period' :: PeriodCalc
  , namedNumber' :: NamedNumberCalc
  , check' :: Checker
}

type JSResult = {
    name :: String
  , message :: String
  , level :: String
}

type Response = {
    time :: String
  , level :: Nullable String
  , checks :: Array JSResult
}

main :: ParsedConfig -> String -> Response
main { calcs, calculate', period', namedNumber', check' } password =
    {
        time: time
      , level: toNullable highestLevel
      , checks: checkResults
    }

    where checkResults = checksToJS <$> Array.sortWith (_.level) (Array.fromFoldable (check' password))
          highestLevel = ((_.level) <$> Array.head checkResults)

          time = case highestLevel of
                     Just "insecure" -> "instantly"
                     _ -> parseTime namedNumber' period' calcs (calculate' password)


parseTime :: NamedNumberCalc -> PeriodCalc -> Number -> BigInt -> String
parseTime namedNumber' period' calcs possibilities =
    case period' calcs possibilities of
        Nothing -> "forever"
        Just { value, name } -> joinWith " " [(namedNumber' value), name]

checksToJS :: Result -> JSResult
checksToJS { name, message, level } = {
    name
  , message
  , level: show level
}

setup :: UnparsedConfig -> (String -> Response)
setup config = case parseConfig config of
     Left error -> unsafeThrow error
     Right main' -> main'

parseConfig :: UnparsedConfig -> Either String (String -> Response)
parseConfig { calcs, periods, namedNumbers, characterSets, dictionary, patterns, checkMessages } = do
    -- dictionaries
    periods' <- note "Invalid periods dictionary" (fromFoldable periods)
    namedNumbers' <- note "Invalid named numbers dictionary" (fromFoldable namedNumbers)
    characterSets' <- note "Invalid character sets dictionary" (parseArray characterSets)

    -- checks
    dictionary' <- note "Invalid password dictionary" (fromFoldable dictionary)
    patterns' <- note "Invalid patterns dictionary" (fromFoldable patterns >>= Patterns.patterns)

    let messages = parseMessages checkMessages

    pure $ main {
        calcs
      , calculate': calculate characterSets'
      , period': period periods'
      , namedNumber': namedNumber namedNumbers'
      , check': check (Dictionary.check dictionary' `cons` patterns') messages
    }
