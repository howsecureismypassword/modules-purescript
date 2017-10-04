module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

-- named number logic
import NamedNumber(namedNumber)

-- named numbers dictionary
import NamedNumbers(names)

-- setup namedNumber
namedNumber' :: Number -> String
namedNumber' = namedNumber names

main :: forall e. Eff (console :: CONSOLE | e) Unit
main = do
  log $ namedNumber' 820000000.0
