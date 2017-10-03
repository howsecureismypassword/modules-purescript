module Main where

import Prelude
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE, log)
import NamedNumbers(find, names)
import Data.List(fromFoldable)

main :: forall e. Eff (console :: CONSOLE | e) Unit
main = do
  log $ show $ find 12 names (fromFoldable [])
