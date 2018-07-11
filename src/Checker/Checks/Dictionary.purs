module Checker.Checks.Dictionary where

import Prelude ((<$>), (+), (*), show)
import Data.List.NonEmpty (NonEmptyList, elemIndex)
import Data.Maybe (Maybe(Just))
import Data.Int (quot)

import Checker.Internal (Check, CheckResult, Level(Insecure))

round :: Int -> Int
round index = 10 * (((index + 1) `quot` 10) + 1)

result :: Int -> CheckResult
result index = {
    id: "common"
  , level: Insecure
  , value: Just (show (round index))
}

checkDictionary :: NonEmptyList String -> Check
checkDictionary dic password = result <$> elemIndex password dic
