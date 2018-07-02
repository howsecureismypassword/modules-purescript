module Test.Utility where

import Prelude ((>), Unit, discard)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Data.List (fromFoldable)
import Data.Maybe (Maybe(..))

-- tested modules
import Utility (findLast)

-- tests
checks :: Spec Unit
checks = describe "Utility (findLast)" do
    it "finds last item" do
       findLast (\x -> x > 5) Nothing (fromFoldable [1, 2, 3, 4, 9, 10]) `shouldEqual` Just 4
       findLast (\x -> x > 9) Nothing (fromFoldable [1, 2, 3, 4, 9, 10]) `shouldEqual` Just 9
       findLast (\x -> x > 10) Nothing (fromFoldable [1, 2, 3, 4, 9, 10]) `shouldEqual` Just 10
