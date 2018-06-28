module Checker (
    check
) where

import Prelude (($), (<$>))
import Data.List (List, catMaybes)

import Check (Check, Results)

check :: List Check -> String -> Results
check checks password = catMaybes $ (_ $ password) <$> checks
