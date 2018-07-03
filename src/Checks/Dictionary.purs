module Checks.Dictionary where

import Prelude ((<$>), (+), show)
import Data.List (List, elemIndex)
import Data.Maybe (Maybe(Just))

import Checker (Check, Result, Level(Insecure))

result :: Int -> Result
result index = {
    id: "common"
  , level: Insecure
  , value: Just (show (index + 1))
}

check :: List String -> Check
check dictionary password = result <$> elemIndex password dictionary
