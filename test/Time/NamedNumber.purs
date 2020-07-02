module Test.Time.NamedNumber where

import Prelude (Unit, discard)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Data.BigInt (BigInt, fromInt, pow)

-- tested modules
import Time.NamedNumber (namedNumber)

-- test data
import Test.Data (config)

namedNumber' :: BigInt -> String
namedNumber' = namedNumber (config.dictionaries.namedNumbers)

-- tests
checks :: Spec Unit
checks = describe "NamedNumber (namedNumber)" do
    it "names numbers" do
        namedNumber' (fromInt 0) `shouldEqual` "0"
        namedNumber' (fromInt 1) `shouldEqual` "1"
        namedNumber' (fromInt 12) `shouldEqual` "12"
        namedNumber' (fromInt 220) `shouldEqual` "2 hundred"
        namedNumber' (fromInt 3200) `shouldEqual` "3 thousand"
        namedNumber' (fromInt 42000) `shouldEqual` "42 thousand"
        namedNumber' (fromInt 520000) `shouldEqual` "5 hundred thousand"
        namedNumber' (fromInt 6200000) `shouldEqual` "6 million"
        namedNumber' (fromInt 72000000) `shouldEqual` "72 million"
        namedNumber' (fromInt 25 `pow` fromInt 6) `shouldEqual` "2 hundred million"
        namedNumber' (fromInt 20 `pow` fromInt 6) `shouldEqual` "64 million"
        namedNumber' (fromInt 20 `pow` fromInt 7) `shouldEqual` "1 billion"
        namedNumber' (fromInt 20 `pow` fromInt 8) `shouldEqual` "25 billion"
        namedNumber' (fromInt 20 `pow` fromInt 10) `shouldEqual` "10 trillion"
        namedNumber' (fromInt 20 `pow` fromInt 99) `shouldEqual` "6 hundred thousand quadragintillion"
        namedNumber' (fromInt 20 `pow` fromInt 117) `shouldEqual` "1 hundred octillion quadragintillion"
        namedNumber' (fromInt 10 `pow` fromInt 308) `shouldEqual` "1 hundred uncentillion"
        namedNumber' (fromInt 10 `pow` fromInt 309) `shouldEqual` "1 duocentillion"
        namedNumber' (fromInt 10 `pow` fromInt 3003) `shouldEqual` "1 millinillion"
