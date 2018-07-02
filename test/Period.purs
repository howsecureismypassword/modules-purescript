module Test.Period where

import Prelude (Unit, discard)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Math (pow)
import Data.Maybe (Maybe(..))

-- tested modules
import Period (Period, Result, period)

-- dictionaries
foreign import periods :: Array Period

-- helper functions
period' :: Number -> Number -> Maybe Result
period' = period periods

-- tests
checks :: Spec Unit
checks = describe "Period (periods)" do
    it "works out sub-yoctoseconds" do
        period' (10.0 `pow` 25.0) 1.0 `shouldEqual` Just { value: 0.0, name: "yoctoseconds" }

    it "works out yoctoseconds" do
        period' (10.0 `pow` 24.0) 1.0 `shouldEqual` Just { value: 1.0, name: "yoctosecond" }

    it "works out seconds" do
        period' 1.0 1.0 `shouldEqual` Just { value: 1.0, name: "second" }

    it "works out minutes" do
        period' 1.0 60.0 `shouldEqual` Just { value: 1.0, name: "minute" }

    it "works out hours" do
        period' 1.0 3600.0 `shouldEqual` Just { value: 1.0, name: "hour" }

    it "works out years" do
        period' 0.01 315576.0 `shouldEqual` Just { value: 1.0, name: "year" }

    it "works out multiple yoctoseconds" do
        period' (10.0 `pow` 24.0) 7.0 `shouldEqual` Just { value: 7.0, name: "yoctoseconds" }

    it "works out multiple seconds" do
        period' 0.5 1.0 `shouldEqual` Just { value: 2.0, name: "seconds" }

    it "works out multiple minutes" do
        period' 0.5 60.0 `shouldEqual` Just { value: 2.0, name: "minutes" }

    it "works out multiple hours" do
        period' 0.5 3600.0 `shouldEqual` Just { value: 2.0, name: "hours" }

    it "works out multiple years" do
        period' 0.005 315576.0 `shouldEqual` Just { value: 2.0, name: "years" }
