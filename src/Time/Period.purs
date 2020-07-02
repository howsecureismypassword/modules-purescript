module Time.Period where

import Prelude ((<$>), (>>=), (||), (/), (<), (==), bind, otherwise)
import Data.Maybe (Maybe(..))
import Data.List.NonEmpty (last)
import Data.BigInt (BigInt, quot, fromInt, fromNumber, toNumber)
import Utility (findLast)

import Config.Types (Period, Periods)

foreign import max :: Number

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

period :: Periods -> Number -> BigInt -> Maybe Result
period periods calculationsPerSecond possibilities = do
    let lst = last periods
    calcs <- fromNumber calculationsPerSecond

    let time = toNumber possibilities / calculationsPerSecond

    if time < max || calculationsPerSecond < 1.0
        then smallPeriod time (findLast (check time) periods)
        else bigPeriod (possibilities `quot` calcs) lst
