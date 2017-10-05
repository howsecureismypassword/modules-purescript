module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

-- named number logic
import NamedNumber (namedNumber)

-- named numbers dictionary
import Dictionary.NamedNumbers (names)

-- calculation 
import Calculator (calculate)

-- setup namedNumber
namedNumber' :: Number -> String
namedNumber' = namedNumber names

-- setup calculate
calculate' :: String -> Number
calculate' = calculate 26.0

main :: forall e. Eff (console :: CONSOLE | e) Unit
main = do
  log $ namedNumber' $ calculate' "hello" 
