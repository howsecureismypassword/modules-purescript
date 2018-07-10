module Checker.Checks.Pattern where

import Prelude (($), bind)
import Data.Maybe (Maybe(..))
import Data.Either (hush)
import Data.String.Regex (regex, test)
import Data.String.Regex.Flags (noFlags)

import Checker.Internal (Check, CheckResult, Level)

result :: String -> Level -> CheckResult
result id level = {
    id: id
  , level: level
  , value: Nothing
}

checkPattern :: String -> Level -> String -> Check
checkPattern id level regexString password = do
    rgex <- hush $ regex regexString noFlags

    if test rgex password
        then Just (result id level)
        else Nothing
