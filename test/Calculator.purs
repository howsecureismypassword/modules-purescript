module Test.Calculator where

import Prelude (($), Unit, discard, pure, bind)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Data.Maybe (Maybe(..), fromMaybe)
import Data.BigInt (BigInt, fromInt, fromNumber, fromString)

-- tested modules
import Calculator (UnparsedCharacterSet, calculate, parseArray)

-- dictionaries
foreign import characterSets :: Array UnparsedCharacterSet

-- helper functions
calculate' :: String -> Maybe BigInt
calculate' password = do
    sets <- parseArray characterSets
    pure $ calculate sets password

-- tests
checks :: Spec Unit
checks = describe "Calculator (calculate)" do
    it "calculates" do
        calculate' "i" `shouldEqual` Just (fromInt 26)
        calculate' "1" `shouldEqual` Just (fromInt 10)
        calculate' "hello" `shouldEqual` Just (fromInt 11881376)
        calculate' "abc123ABC" `shouldEqual` Just (fromMaybe (fromInt 0) (fromNumber 13537086546263552.0))

        calculate' "skdkfkdkfkekfkekfudkfieifidifieifieifiri" `shouldEqual` Just (fromMaybe (fromInt 0) (fromString "397131118389635994560666234198316439032157304558637285376"))
