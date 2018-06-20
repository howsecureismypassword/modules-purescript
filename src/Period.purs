module Period where

import Prelude ((<), (/), (==), (<$>))
import Data.Maybe (Maybe(..))
import Data.Int (toNumber)
import Dictionary.Periods (Period, periods)
import Math (floor)
import Utility (findLast)

type Result = {
    value :: Number,
    name :: String
}

result :: Number -> Period -> Result
result time period = { value, name }
    where value = floor (time / period.seconds)
          name = if value == 1.0 then period.singular else period.plural 

check :: Number -> Period -> Boolean
check time per = time < per.seconds

find' :: Number -> Maybe Result
find' time = result time <$> findLast (check time) Nothing periods

perSecond :: Number -> Int -> Number
perSecond cps poss = toNumber poss / cps

period :: Number -> Int -> Maybe Result
period calculationsPerSecond possibilities = find' (perSecond calculationsPerSecond possibilities)
