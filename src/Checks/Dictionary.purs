module Checks.Dictionary where

import Prelude ((<$>), (+), show)
import Data.List (elemIndex, fromFoldable)
import Data.Maybe (Maybe(Just))

import Check (Check, Result, Level(Insecure))

result :: String -> Int -> Result
result id index = {
    id: id
  , level: Insecure
  , value: Just (show (index + 1))
}

check :: Array String -> String -> Check
check dictionary id password = result id <$> elemIndex password (fromFoldable dictionary)
