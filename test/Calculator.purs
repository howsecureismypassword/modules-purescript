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
        calculate' "abc123ABC" `shouldEqual` 13537086546263552.0

        calculate' "skdkfkdkfkekfkekfudkfieifidifieifieifiri" `shouldEqual` 3.971311183896361e56
