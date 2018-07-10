module Test.Period where

import Prelude (Unit, discard)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Math as Math
import Data.List.NonEmpty (fromFoldable)
import Data.Maybe (Maybe(..))
import Data.BigInt (BigInt, fromInt, fromNumber, pow)

import Test.Helper (unsafeFromMaybe)

-- tested modules
import Period.Internal (Period, Result, period)

-- dictionaries
foreign import periods :: Array Period
foreign import dodgyPeriods :: Array Period

-- helper functions
period' :: Number -> BigInt -> Maybe Result
period' = period (unsafeFromMaybe (fromFoldable periods))

dodgyPeriod :: Number -> BigInt -> Maybe Result
dodgyPeriod = period (unsafeFromMaybe (fromFoldable dodgyPeriods))

-- tests
checks :: Spec Unit
checks = describe "Period (periods)" do
    it "works out sub-yoctoseconds" do
        period' (10.0 `Math.pow` 25.0) (fromInt 1) `shouldEqual` Just { value: unsafeFromMaybe (fromNumber 0.1), name: "yoctoseconds" }

    it "works out sub-seconds" do
        period' (10.0 `Math.pow` 24.0) (fromInt 1) `shouldEqual` Just { value: fromInt 1, name: "yoctosecond" }
        period' (10.0 `Math.pow` 24.0) (fromInt 7) `shouldEqual` Just { value: fromInt 7, name: "yoctoseconds" }
        period' (10.0 `Math.pow` 21.0) (fromInt 2) `shouldEqual` Just { value: fromInt 2, name: "zeptoseconds" }
        period' (10.0 `Math.pow` 18.0) (fromInt 2) `shouldEqual` Just { value: fromInt 2, name: "attoseconds" }
        period' (10.0 `Math.pow` 3.0) (fromInt 500) `shouldEqual` Just { value: fromInt 500, name: "milliseconds" }

    it "works out seconds" do
        period' 1.0 (fromInt 1) `shouldEqual` Just { value: fromInt 1, name: "second" }
        period' 0.5 (fromInt 1) `shouldEqual` Just { value: fromInt 2, name: "seconds" }

    it "works out minutes" do
        period' 1.0 (fromInt 60) `shouldEqual` Just { value: fromInt 1, name: "minute" }
        period' 0.5 (fromInt 60) `shouldEqual` Just { value: fromInt 2, name: "minutes" }

    it "works out hours" do
        period' 1.0 (fromInt 3600) `shouldEqual` Just { value: fromInt 1, name: "hour" }
        period' 0.5 (fromInt 3600) `shouldEqual` Just { value: fromInt 2, name: "hours" }

    it "works out years" do
        period' 1.0 (fromInt 31557600) `shouldEqual` Just { value: fromInt 1, name: "year" }
        period' 1.0 (fromInt 63115200) `shouldEqual` Just { value: fromInt 2, name: "years" }
        period' 1.0 (fromInt 10 `pow` fromInt 20) `shouldEqual` Just { value: unsafeFromMaybe (fromNumber 3168808781402.0), name: "years" }
        period' 1.0 (fromInt 31557600 `pow` fromInt 20) `shouldEqual` Just { value: (fromInt 31557600 `pow` fromInt 19), name: "years" }
        period' 1.0 (fromInt 31557600 `pow` fromInt 200) `shouldEqual` Just { value: (fromInt 31557600 `pow` fromInt 199), name: "years" }

    it "works out years with fractional calculation times" do
        period' 0.5 (fromInt 31557600) `shouldEqual` Just { value: fromInt 2, name: "years" }
        period' 0.1 (fromInt 31557600) `shouldEqual` Just { value: fromInt 10, name: "years" }
        period' 0.1 (fromInt 10 `pow` fromInt 19) `shouldEqual` Just { value: unsafeFromMaybe (fromNumber 3168808781402.0), name: "years" }

    it "handles Infinity" do
        period' 0.1 (fromInt 10 `pow` fromInt 1000) `shouldEqual` Nothing

    it "handles division by 0" do
       dodgyPeriod 1.0 (fromInt 10 `pow` fromInt 20) `shouldEqual` Nothing
