module Test.NamedNumber where

import Prelude
import Math (pow)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

-- named number logic
import NamedNumber (namedNumber)

-- named numbers dictionary
import Dictionary.NamedNumbers (names)

-- setup namedNumber
namedNumber' :: Number -> String
namedNumber' = namedNumber names

spec :: forall r. Spec r Unit
spec = describe "NamedNumber (namedNumber)" do
    it "names numbers" do
        namedNumber' 1.0 `shouldEqual` "1"
        namedNumber' 0.0 `shouldEqual` "0"
        namedNumber' 12.0 `shouldEqual` "12"
        namedNumber' 220.0 `shouldEqual` "2 hundred"
        namedNumber' 3200.0 `shouldEqual` "3 thousand"
        namedNumber' 42000.0 `shouldEqual` "42 thousand"
        namedNumber' 520000.0 `shouldEqual` "5 hundred thousand"
        namedNumber' 6200000.0 `shouldEqual` "6 million"
        namedNumber' 72000000.0 `shouldEqual` "72 million"
        namedNumber' 820000000.0 `shouldEqual` "8 hundred million"
        namedNumber' 9200000000.0 `shouldEqual` "9 billion"
        namedNumber' 12000000000.0 `shouldEqual` "12 billion"
        namedNumber' 220000000000.0 `shouldEqual` "2 hundred billion"
        namedNumber' (200.0 * (10.0 `pow` 123.0)) `shouldEqual` "2 hundred quadragintillion"
        namedNumber' (2.0 * (10.0 `pow` 152.0)) `shouldEqual` "2 hundred octillion quadragintillion"
        namedNumber' (10.0 `pow` 308.0) `shouldEqual` "1 hundred uncentillion"
        namedNumber' (100.0 `pow` 308.0) `shouldEqual` "Infinity"
