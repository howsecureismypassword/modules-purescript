module Period (Period, Result, period) where

import Prelude ((<), (/), (==), (<$>))
import Data.Maybe (Maybe(..))
import Data.List (List, fromFoldable)
import Math (floor)
import Utility (findLast)

type Period = {
    singular :: String,
    plural :: String,
    seconds :: Number
}

type Periods = List Period

type Result = {
    value :: Number,
    name :: String
}

result :: Number -> Period -> Result
result time per = { value, name }
    where value = floor (time / per.seconds)
          name = if value == 1.0 then per.singular else per.plural

check :: Number -> Period -> Boolean
check time per = time < per.seconds

find' :: Periods -> Number -> Maybe Result
find' periods time = result time <$> findLast (check time) Nothing periods

perSecond :: Number -> Number -> Number
perSecond cps poss = poss / cps

period :: Array Period -> Number -> Number -> Maybe Result
period periods calculationsPerSecond possibilities = find' (fromFoldable periods) (possibilities / calculationsPerSecond)
