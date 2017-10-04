module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)

-- named number logic
import NamedNumber(namedNumber)

-- named numbers dictionary
import NamedNumbers(names)

main :: forall e. Eff (console :: CONSOLE | e) Unit
main = do
  log $ show $ namedNumber names 800000000.0
