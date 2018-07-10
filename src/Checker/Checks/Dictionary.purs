module Checker.Checks.Dictionary where

import Prelude ((<$>), (+), show)
import Data.List.NonEmpty (NonEmptyList, elemIndex)
import Data.Maybe (Maybe(Just))

import Checker.Internal (Check, CheckResult, Level(Insecure))

result :: Int -> CheckResult
result index = {
    id: "common"
  , level: Insecure
  , value: Just (show (index + 1))
}

checkDictionary :: NonEmptyList String -> Check
checkDictionary dic password = result <$> elemIndex password dic
