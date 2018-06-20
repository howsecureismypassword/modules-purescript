module Main where

import Prelude
import Effect (Effect)
import Effect.Console (log)

-- named number logic
import NamedNumber (namedNumber)

-- dictionaries
import Dictionary.NamedNumbers (names)
import Dictionary.CharacterSets (sets)

-- calculation 
import Calculator (calculate)

-- setup namedNumber
namedNumber' :: Number -> String
namedNumber' = namedNumber names

-- setup calculate
calculate' :: String -> Number
calculate' = calculate sets 

main :: Effect Unit
main = do
  log $ namedNumber' $ calculate' "hello" 
