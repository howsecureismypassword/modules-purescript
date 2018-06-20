module Main where

import Prelude (($), (*), Unit)
import Effect (Effect)
import Effect.Console (log)
import Data.Maybe (Maybe(..))
import Math (pow)

-- dictionaries
import Dictionary.NamedNumbers (names)
import Dictionary.CharacterSets (sets)
import Dictionary.Periods (periods)

-- calculation
import Calculator (calculate)
import NamedNumber (namedNumber)
import Period (Result, period)

import Utility (join)

calcs :: Number
calcs = 4.0 * (10.0 `pow` 10.0)

-- setup namedNumber
namedNumber' :: Number -> String
namedNumber' = namedNumber names

-- setup calculate
calculate' :: String -> Number
calculate' = calculate sets

period' :: Number -> Number -> Maybe Result
period' = period periods

main :: Effect Unit
main = do
    let possibilities = calculate' "Yiejng8GjeDoebgs"
    let time = period' calcs possibilities

    log $ case time of
         Nothing -> "Something's gone wrong"
         Just { value, name } -> join (namedNumber' value) name
