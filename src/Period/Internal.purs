module Period.Internal where

import Prelude ((<$>), (>>=), (||), (/), (<), (==), bind, otherwise)
import Data.Maybe (Maybe(..))
import Data.List.NonEmpty (NonEmptyList, last)
import Data.BigInt (BigInt, quot, fromInt, fromNumber, toNumber)
import Utility (findLast)

foreign import max :: Number

type Period = {
    singular :: String
  , plural :: String
  , seconds :: Number
}

type Periods = NonEmptyList Period

type Result = {
    value :: BigInt
  , name :: String
}

one :: BigInt
one = fromInt 1

result :: Maybe BigInt -> Period -> Maybe Result
result val per = do
    value <- val
    let name = if value == one then per.singular else per.plural
    Just { value, name }

zeroCheck :: Number -> Maybe Number
zeroCheck n | n < 1.0 = Nothing | otherwise = Just n

bigPeriod :: BigInt -> Period -> Maybe Result
bigPeriod time per = do
    let value = (time `quot` _) <$> (zeroCheck per.seconds >>= fromNumber)
    result value per

smallPeriod :: Number -> Period -> Maybe Result
smallPeriod time per = result (fromNumber (time / per.seconds)) per

check :: Number -> Period -> Boolean
check time per = time < per.seconds

type PeriodCalc = Number -> BigInt -> Maybe Result

period :: Periods -> PeriodCalc
period periods calculationsPerSecond possibilities = do
    let lst = last periods
    calcs <- fromNumber calculationsPerSecond

    let time = toNumber possibilities / calculationsPerSecond

    if time < max || calculationsPerSecond < 1.0
        then smallPeriod time (findLast (check time) periods)
        else bigPeriod (possibilities `quot` calcs) lst
