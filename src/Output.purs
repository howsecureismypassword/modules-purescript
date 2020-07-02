module Output where

import Prelude ((<$>), show)
import Data.Maybe (Maybe(..))
import Data.String (joinWith)
import Data.Array (fromFoldable, sortWith, head)
import Data.Nullable (Nullable(), toNullable)
import Foreign (Foreign)

import Time.Period (period)
import Time.Calculator (calculate)
import Time.NamedNumber (namedNumber)

import Config.Parser (parse)
import Config.Types (Config)

type Response = {
    time :: String
}

calculateTime :: Config -> String -> String
calculateTime { settings, dictionaries } password = time
    where calculations = calculate dictionaries.characterSets password
          time = case period dictionaries.periods settings.calcs calculations of
                     Nothing -> settings.forever
                     Just { value, name } -> joinWith " " [(namedNumber dictionaries.namedNumbers value), name]

response :: Config -> String -> Response
response config password = {
    time: calculateTime config password
}
