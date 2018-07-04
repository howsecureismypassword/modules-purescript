module Test.Utility where

import Prelude ((>), Unit, discard)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Data.List.NonEmpty (NonEmptyList, fromFoldable, singleton)
import Data.Maybe (fromMaybe)

-- tested modules
import Utility (findLast)

singletonList :: NonEmptyList Int
singletonList = singleton 1

-- tests
checks :: Spec Unit
checks = describe "Utility (findLast)" do
    it "finds last item" do
       findLast (\x -> x > 5) (fromMaybe singletonList (fromFoldable [1, 2, 3, 4, 9, 10])) `shouldEqual` 4
       findLast (\x -> x > 9) (fromMaybe singletonList (fromFoldable [1, 2, 3, 4, 9, 10])) `shouldEqual` 9
       findLast (\x -> x > 10) (fromMaybe singletonList (fromFoldable [1, 2, 3, 4, 9, 10])) `shouldEqual` 10
