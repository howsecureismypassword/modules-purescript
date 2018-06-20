module Dictionary.Periods where

import Prelude (negate)
import Math (pow)
import Data.List (List, fromFoldable)

type Period = {
    singular :: String,
    plural :: String,
    seconds :: Number
}

type Periods = List Period

periods :: Periods 
periods = fromFoldable [
    {
        singular: "yoctosecond",
        plural: "yoctoseconds",
        seconds: 10.0 `pow` (negate 24.0)
    },
    {
        singular: "zeptosecond",
        plural: "zeptoseconds",
        seconds: 10.0 `pow` (negate 21.0)
    },
    {
        singular: "attosecond",
        plural: "attoseconds",
        seconds: 10.0 `pow` (negate 18.0)
    },
    {
        singular: "femtosecond",
        plural: "femtoseconds",
        seconds: 10.0 `pow` (negate 15.0)
    },
    {
        singular: "picosecond",
        plural: "picoseconds",
        seconds: 10.0 `pow` (negate 12.0)
    },
    {
        singular: "nanosecond",
        plural: "nanoseconds",
        seconds: 10.0 `pow` (negate 9.0)
    },
    {
        singular: "microsecond",
        plural: "microseconds",
        seconds: 10.0 `pow` (negate 6.0)
    },
    {
        singular: "millisecond",
        plural: "milliseconds",
        seconds: 10.0 `pow` (negate 3.0)
    },
    {
        singular: "second",
        plural: "seconds",
        seconds: 1.0
    },
    {
        singular: "minute",
        plural: "minutes",
        seconds: 60.0
    },
    {
        singular: "hour",
        plural: "hours",
        seconds: 3600.0
    },
    {
        singular: "day",
        plural: "days",
        seconds: 86400.0
    },
    {
        singular: "week",
        plural: "weeks",
        seconds: 604800.0
    },
    {
        singular: "month",
        plural: "months",
        seconds: 2626560.0
    },
    {
        singular: "year",
        plural: "years",
        seconds: 31557600.0
    }
]
