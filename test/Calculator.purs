module Test.Calculator where

import Prelude (Unit, discard)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Test.Helper (unsafeFromMaybe)

import Data.Maybe (fromMaybe)
import Data.BigInt (BigInt, fromInt, fromNumber, fromString)

-- tested modules
import Calculator (UnparsedCharacterSet, calculate, parseArray)

-- dictionaries
foreign import characterSets :: Array UnparsedCharacterSet

-- helper functions
calculate' :: String -> BigInt
calculate' = calculate (unsafeFromMaybe (parseArray characterSets))

-- tests
checks :: Spec Unit
checks = describe "Calculator (calculate)" do
    it "calculates" do
        calculate' "i" `shouldEqual`  (fromInt 26)
        calculate' "1" `shouldEqual`  (fromInt 10)
        calculate' "hello" `shouldEqual`  (fromInt 11881376)
        calculate' "abc123ABC" `shouldEqual`  (fromMaybe (fromInt 0) (fromNumber 13537086546263552.0))

        calculate' "skdkfkdkfkekfkekfudkfieifidifieifieifiri" `shouldEqual`  (fromMaybe (fromInt 0) (fromString "397131118389635994560666234198316439032157304558637285376"))
