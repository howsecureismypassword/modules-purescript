module Test.Utility where

import Prelude ((>), Unit, discard)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Data.List.NonEmpty (NonEmptyList, fromFoldable, singleton)
import Data.Maybe (Maybe(..), fromMaybe)

-- tested modules
import Utility (findLast)

singletonList :: NonEmptyList Int
singletonList = singleton 1

-- tests
checks :: Spec Unit
checks = describe "Utility (findLast)" do
    it "finds last item" do
       findLast (\x -> x > 5) Nothing (fromMaybe singletonList (fromFoldable [1, 2, 3, 4, 9, 10])) `shouldEqual` Just 4
       findLast (\x -> x > 9) Nothing (fromMaybe singletonList (fromFoldable [1, 2, 3, 4, 9, 10])) `shouldEqual` Just 9
       findLast (\x -> x > 10) Nothing (fromMaybe singletonList (fromFoldable [1, 2, 3, 4, 9, 10])) `shouldEqual` Just 10
