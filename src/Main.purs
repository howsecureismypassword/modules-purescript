module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

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

main :: forall e. Eff (console :: CONSOLE | e) Unit
main = do
  log $ namedNumber' $ calculate' "hello" 
