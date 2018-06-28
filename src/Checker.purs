module Checker (
    check
) where

import Prelude (($), (<$>))
import Data.List (List)

import Check (Check, Results)

check :: List Check -> String -> Results
check checks password = (_ $ password) <$> checks
