module Checks.Pattern where

import Prelude (($), bind)
import Data.Maybe (Maybe(..))
import Data.Either (hush)
import Data.String.Regex (regex, test)
import Data.String.Regex.Flags (noFlags)

import Checker (Check, Result, Level)

result :: String -> Level -> Result
result id level = {
    id: id
  , level: level
  , value: Nothing
}

check :: String -> Level -> String -> Check
check id level regexString password = do
    rgex <- hush $ regex regexString noFlags

    if test rgex password
        then Just (result id level)
        else Nothing
