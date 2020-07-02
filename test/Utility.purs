module Test.Utility where

import Prelude ((>), Unit, discard)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Data.List.NonEmpty (NonEmptyList, fromFoldable, singleton)
import Data.Maybe (fromMaybe)

-- tested modules
import Utility (findLast, formatNumber)

singletonList :: NonEmptyList Int
singletonList = singleton 1

-- tests
checks :: Spec Unit
checks = describe "Utility" do
    it "finds last item" do
       findLast (\x -> x > 5) (fromMaybe singletonList (fromFoldable [1, 2, 3, 4, 9, 10])) `shouldEqual` 4
       findLast (\x -> x > 9) (fromMaybe singletonList (fromFoldable [1, 2, 3, 4, 9, 10])) `shouldEqual` 9
       findLast (\x -> x > 10) (fromMaybe singletonList (fromFoldable [1, 2, 3, 4, 9, 10])) `shouldEqual` 10

    it "formats numbers" do
       formatNumber "1" `shouldEqual` "1"
       formatNumber "12" `shouldEqual` "12"
       formatNumber "123" `shouldEqual` "123"
       formatNumber "1234" `shouldEqual` "1,234"
       formatNumber "12345" `shouldEqual` "12,345"
       formatNumber "123456" `shouldEqual` "123,456"
       formatNumber "1234567" `shouldEqual` "1,234,567"
       formatNumber "12345.67" `shouldEqual` "12,345.67"
       formatNumber "12345678909876543211234567890987654321" `shouldEqual` "12,345,678,909,876,543,211,234,567,890,987,654,321"
