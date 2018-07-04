module Main.Internal where

import Prelude ((<$>), show)
import Data.Maybe (Maybe(..))
import Data.String (joinWith)
import Data.BigInt (BigInt)
import Data.Array as Array
import Data.Nullable (Nullable(), toNullable)

import NamedNumber (NamedNumberCalc)
import Period (PeriodCalc)
import Checker (Result)

import Main.ParseConfig (ParsedConfig)

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
