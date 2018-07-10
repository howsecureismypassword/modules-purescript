module Main.Internal where

import Prelude ((<$>), show)
import Data.Maybe (Maybe(..))
import Data.String (joinWith)
import Data.Array (fromFoldable, sortWith, head)
import Data.Nullable (Nullable(), toNullable)

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
main { functions, variables } password = { time: time , level: toNullable highestLevel , checks: checkResults }

    where checks = functions.check password
          calculations = functions.calculate password
          checkResults = checksToJS <$> sortWith (_.level) (fromFoldable checks)
          highestLevel = ((_.level) <$> head checkResults)

          time = case highestLevel of
                     Just "insecure" -> variables.instantly
                     _ -> case functions.period variables.calcs calculations of
                         Nothing -> variables.forever
                         Just { value, name } -> joinWith " " [(functions.namedNumber value), name]

checksToJS :: Result -> JSResult
checksToJS { name, message, level } = {
    name
  , message
  , level: show level
}
