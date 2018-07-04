module Test.Period where

import Prelude (Unit, discard, bind)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Math (pow)
import Data.List.NonEmpty (fromFoldable)
import Data.Maybe (Maybe(..))
import Data.BigInt (BigInt, fromInt)

-- tested modules
import Period (Period, Result, period)

-- dictionaries
foreign import periods :: Array Period

-- helper functions
period' :: Number -> BigInt -> Maybe Result
period' num int = do
    periods' <- fromFoldable periods
    period periods' num int

-- tests
checks :: Spec Unit
checks = describe "Period (periods)" do
    it "works out sub-yoctoseconds" do
        period' (10.0 `pow` 25.0) (fromInt 1) `shouldEqual` Just { value: fromInt 0, name: "yoctoseconds" }

    it "works out yoctoseconds" do
        period' (10.0 `pow` 24.0) (fromInt 1) `shouldEqual` Just { value: fromInt 1, name: "yoctosecond" }

    it "works out attoseconds" do
        period' (10.0 `pow` 18.0) (fromInt 2) `shouldEqual` Just { value: fromInt 2, name: "attoseconds" }

    it "works out seconds" do
        period' 1.0 (fromInt 1) `shouldEqual` Just { value: fromInt 1, name: "second" }

    it "works out minutes" do
        period' 1.0 (fromInt 60) `shouldEqual` Just { value: fromInt 1, name: "minute" }

    it "works out hours" do
        period' 1.0 (fromInt 3600) `shouldEqual` Just { value: fromInt 1, name: "hour" }

    it "works out years" do
        period' 1.0 (fromInt 31557600) `shouldEqual` Just { value: fromInt 1, name: "year" }

    it "works out multiple yoctoseconds" do
        period' (10.0 `pow` 24.0) (fromInt 7) `shouldEqual` Just { value: fromInt 7, name: "yoctoseconds" }

    it "works out multiple seconds" do
        period' 0.5 (fromInt 1) `shouldEqual` Just { value: fromInt 2, name: "seconds" }

    it "works out multiple minutes" do
        period' 0.5 (fromInt 60) `shouldEqual` Just { value: fromInt 2, name: "minutes" }

    it "works out multiple hours" do
        period' 0.5 (fromInt 3600) `shouldEqual` Just { value: fromInt 2, name: "hours" }

    it "works out multiple years" do
        period' 1.0 (fromInt 63115200) `shouldEqual` Just { value: fromInt 2, name: "years" }
