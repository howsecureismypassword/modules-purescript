module Test.Calculator where

import Prelude
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

-- named number logic
import Calculator (calculate)

import Dictionary.CharacterSets (sets)

-- setup calculate
calculate' :: String -> Number
calculate' = calculate sets 

spec :: forall r. Spec r Unit
spec = describe "Calculator (calculate)" do
    it "calculates" do
        calculate' "i" `shouldEqual` 26.0 
        calculate' "1" `shouldEqual` 10.0 
        calculate' "hello" `shouldEqual` 11881376.0
