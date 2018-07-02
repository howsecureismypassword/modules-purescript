module Test.Calculator where

import Prelude (Unit, discard)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

-- tested modules
import Calculator (UnparsedCharacterSet, calculate)

-- dictionaries
foreign import characterSets :: Array UnparsedCharacterSet

-- helper functions
calculate' :: String -> Number
calculate' = calculate characterSets

-- tests
checks :: Spec Unit
checks = describe "Calculator (calculate)" do
    it "calculates" do
        calculate' "i" `shouldEqual` 26.0
        calculate' "1" `shouldEqual` 10.0
        calculate' "hello" `shouldEqual` 11881376.0
        calculate' "abc123ABC" `shouldEqual` 13537086546263552.0

        calculate' "skdkfkdkfkekfkekfudkfieifidifieifieifiri" `shouldEqual` 3.971311183896361e56
