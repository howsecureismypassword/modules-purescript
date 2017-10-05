module Test.Calculator where

import Prelude
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

-- named number logic
import Calculator (calculate)

-- setup calculate
calculate' :: String -> Number
calculate' = calculate 26.0

spec :: forall r. Spec r Unit
spec = describe "Calculator (calculate)" do
    it "calculates" do
        calculate' "i" `shouldEqual` 26.0 
        calculate' "hello" `shouldEqual` 11881376.0
