module Output where

import Prelude ((<$>), ($), show)
import Data.Maybe (Maybe(..))
import Data.String (joinWith)
import Data.Array (sortWith, head)
import Data.BigInt (toString)
import Data.Nullable (Nullable(), toNullable)

import Time.Period (period)
import Time.Calculator (calculate)
import Time.NamedNumber (namedNumber)
import Utility (formatNumber)

import Checks.Checker (Message, check)
import Config.Types (Config, Level(Insecure))

type Response = {
    time :: String
  , level :: Nullable String
  , checks :: Array Result
}

type Result = {
    name :: String
  , level :: String
  , message :: String
}

messageToResult :: Message -> Result
messageToResult { name, level, message } = { name, level: show level, message }

calculateTime :: Config -> String -> String
calculateTime { settings, dictionaries } password = time
    where calculations = calculate dictionaries.characterSets password
          time = case period dictionaries.periods settings.calcs calculations of
                     Nothing -> settings.forever
                     Just { value, name } -> joinWith " " [if settings.namedNumbers then (namedNumber dictionaries.namedNumbers value) else formatNumber (toString value), name]

response :: Config -> String -> Response
response config password = {
        time
      , level: toNullable (show <$> highestLevel)
      , checks: messageToResult <$> checks
    }

    where checks = sortWith (_.level) $ check config password
          highestLevel = (_.level) <$> head checks
          time = case highestLevel of
                      Just Insecure -> config.settings.instantly
                      _ -> calculateTime config password
