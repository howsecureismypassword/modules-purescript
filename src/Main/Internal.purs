module Main.Internal where

import Prelude (($), (<$>), (>>=), bind, pure, show)
import Data.Maybe (Maybe(..))
import Data.Either (Either(..), note)
import Data.List.NonEmpty (cons, fromFoldable)
import Data.String (joinWith)
import Data.BigInt (BigInt)
import Data.Array as Array
import Data.Nullable (Nullable(), toNullable)

import Calculator (Calculation, UnparsedCharacterSet, calculate, parseArray)
import NamedNumber (NamedNumberCalc, NamedNumber, namedNumber)
import Period (PeriodCalc, Period, period)
import Checker (Checker, Result, MessageInput, Pattern, check, parseMessages, checkPatterns, checkDictionary)

foreign import unsafeThrow :: String -> (String -> Response)

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

type UnparsedConfig = {
    calcs :: Number
  , characterSets :: Array UnparsedCharacterSet
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
main { calcs, calculate', period', namedNumber', check', forever, instantly } password =
    {
        time: time
      , level: toNullable highestLevel
      , checks: checkResults
    }

    where checkResults = checksToJS <$> Array.sortWith (_.level) (Array.fromFoldable (check' password))
          highestLevel = ((_.level) <$> Array.head checkResults)

          time = case highestLevel of
                     Just "insecure" -> instantly
                     _ -> parseTime forever namedNumber' period' calcs (calculate' password)


parseTime :: String -> NamedNumberCalc -> PeriodCalc -> Number -> BigInt -> String
parseTime forever namedNumber' period' calcs possibilities =
    case period' calcs possibilities of
        Nothing -> forever
        Just { value, name } -> joinWith " " [(namedNumber' value), name]

checksToJS :: Result -> JSResult
checksToJS { name, message, level } = {
    name
  , message
  , level: show level
}

type ParseConfig = UnparsedConfig -> (String -> Response)

parseConfig :: UnparsedConfig -> (String -> Response)
parseConfig config = case parseConfig' config of
     Left error -> unsafeThrow error
     Right main' -> main'

parseConfig' :: UnparsedConfig -> Either String (String -> Response)
parseConfig' { calcs, characterSets, time, checks } = do
    -- dictionaries
    periods' <- note "Invalid periods dictionary" (fromFoldable time.periods)
    namedNumbers' <- note "Invalid named numbers dictionary" (fromFoldable time.namedNumbers)
    characterSets' <- note "Invalid character sets dictionary" (parseArray characterSets)

    -- checks
    dic' <- note "Invalid password dictionary" (fromFoldable checks.dictionary)
    patterns' <- note "Invalid patterns dictionary" (fromFoldable checks.patterns >>= checkPatterns)

    let messages = parseMessages checks.messages

    pure $ main {
        calcs
      , calculate': calculate characterSets'
      , period': period periods'
      , namedNumber': namedNumber namedNumbers'
      , check': check (checkDictionary dic' `cons` patterns') messages
      , forever: time.forever
      , instantly: time.instantly
    }
