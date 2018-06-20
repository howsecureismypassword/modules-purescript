module Test.Main where

import Prelude
import Effect (Effect)
import Test.Spec (describe, it)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (run)
import Test.Spec.Assertions (shouldEqual)
import Math (pow)

import Calculator (calculate)
import NamedNumber (namedNumber)

import Dictionary.CharacterSets (sets)
import Dictionary.NamedNumbers (names)

calculate' :: String -> Number
calculate' = calculate sets 

namedNumber' :: Number -> String
namedNumber' = namedNumber names

main :: Effect Unit
main = run [consoleReporter] do
    describe "Calculator (calculate)" do
        it "calculates" do
            calculate' "i" `shouldEqual` 26.0 
            calculate' "1" `shouldEqual` 10.0 
            calculate' "hello" `shouldEqual` 11881376.0
            calculate' "abc123ABC" `shouldEqual` 13537086546263552.0

            calculate' "skdkfkdkfkekfkekfudkfieifidifieifieifiri" `shouldEqual` 3.971311183896361e56

    describe "NamedNumber (namedNumber)" do
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
