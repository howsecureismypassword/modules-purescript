module Calculator (calculate) where

import Prelude ((<<<))
import Math (pow)
import Data.Int(toNumber)
import Data.String (length)

calculate :: Number -> String -> Number
calculate chars = pow chars <<< toNumber <<< length
