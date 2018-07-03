module Period (Period, Result, period) where

import Prelude ((/), (<), (==), (<$>), (>>=), bind)
import Data.Maybe (Maybe(..))
import Data.List (List, last)
import Data.BigInt (BigInt, quot, fromInt, fromNumber, toNumber)
import Utility (findLast)

type Period = {
    singular :: String
  , plural :: String
  , seconds :: Number
}

type Periods = List Period

type Result = {
    value :: BigInt
  , name :: String
}

result :: Maybe BigInt -> Period -> Maybe Result
result val per = do
    value <- val
    let name = if value == (fromInt 1) then per.singular else per.plural
    Just { value, name }

bigPeriod :: BigInt -> Period -> Maybe Result
bigPeriod time per = result ((time `quot` _) <$> fromNumber per.seconds) per

smallPeriod :: Number -> Period -> Maybe Result
smallPeriod time per = result (fromNumber (time / per.seconds)) per

check :: Number -> Period -> Boolean
check time per = time < per.seconds

find' :: Periods -> Number -> Maybe Result
find' periods time = findLast (check time) Nothing periods >>= smallPeriod time

period :: List Period -> Number -> BigInt -> Maybe Result
period periods calculationsPerSecond possibilities = do
    lst <- last periods
    calcs <- fromNumber calculationsPerSecond

    let time = toNumber possibilities / calculationsPerSecond

    if lst.seconds < time
        then bigPeriod (possibilities `quot` calcs) lst
        else find' periods time
