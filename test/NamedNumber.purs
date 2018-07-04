module Test.NamedNumber where

import Prelude (($), Unit, discard, bind, pure)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Data.BigInt (BigInt, fromInt, pow)
import Data.List.NonEmpty (fromFoldable)
import Data.Maybe (Maybe(..))

-- tested modules
import NamedNumber (NamedNumber, namedNumber)

-- dictionaries
foreign import namedNumbers :: Array NamedNumber

-- helper functions
namedNumber' :: BigInt -> Maybe String
namedNumber' int = do
    names <- fromFoldable namedNumbers
    pure $ namedNumber names int

-- tests
checks :: Spec Unit
checks = describe "NamedNumber (namedNumber)" do
    it "names numbers" do
        namedNumber' (fromInt 0) `shouldEqual` Just "0"
        namedNumber' (fromInt 1) `shouldEqual` Just "1"
        namedNumber' (fromInt 12) `shouldEqual` Just "12"
        namedNumber' (fromInt 220) `shouldEqual` Just "2 hundred"
        namedNumber' (fromInt 3200) `shouldEqual` Just "3 thousand"
        namedNumber' (fromInt 42000) `shouldEqual` Just "42 thousand"
        namedNumber' (fromInt 520000) `shouldEqual` Just "5 hundred thousand"
        namedNumber' (fromInt 6200000) `shouldEqual` Just "6 million"
        namedNumber' (fromInt 72000000) `shouldEqual` Just "72 million"
        namedNumber' (fromInt 25 `pow` fromInt 6) `shouldEqual` Just "2 hundred million"
        namedNumber' (fromInt 20 `pow` fromInt 6) `shouldEqual` Just "64 million"
        namedNumber' (fromInt 20 `pow` fromInt 7) `shouldEqual` Just "1 billion"
        namedNumber' (fromInt 20 `pow` fromInt 8) `shouldEqual` Just "25 billion"
        namedNumber' (fromInt 20 `pow` fromInt 10) `shouldEqual` Just "10 trillion"
        namedNumber' (fromInt 20 `pow` fromInt 99) `shouldEqual` Just "6 hundred thousand quadragintillion"
        namedNumber' (fromInt 20 `pow` fromInt 117) `shouldEqual` Just "1 hundred octillion quadragintillion"
        namedNumber' (fromInt 10 `pow` fromInt 308) `shouldEqual` Just "1 hundred uncentillion"
        namedNumber' (fromInt 10 `pow` fromInt 309) `shouldEqual` Just "1 duocentillion"
        namedNumber' (fromInt 10 `pow` fromInt 3003) `shouldEqual` Just "1 millinillion"
