module Test.Checker where

import Prelude (Unit, discard)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Data.List (fromFoldable)
import Data.Maybe (Maybe(..))

-- tested modules
import Checker (Results, Level(..), check)

import Checks.Dictionary as Dictionary
import Checks.Pattern as Pattern
import Checks.Patterns as Patterns

-- dictionaries
foreign import top10 :: Array String
foreign import top10k :: Array String
foreign import patterns :: Array Patterns.Pattern

check' :: String -> Results
check' = check (fromFoldable [
    Dictionary.check (fromFoldable top10)
  , Pattern.check "length.short" Warning "^.{7,9}$"
])

check10k :: String -> Results
check10k = check (fromFoldable [
    Dictionary.check (fromFoldable top10k)
])

patternsCheck :: String -> Results
patternsCheck = check (Patterns.patterns (fromFoldable patterns))


-- tests
checks :: Spec Unit
checks = describe "Checks (checks)" do
    it "checks" do
        check' "password" `shouldEqual` fromFoldable [{
            id: "common",
            level: Insecure,
            value: Just "1"
        }, {
            id: "length.short",
            level: Warning,
            value: Nothing
        }]

        check' "qwerty" `shouldEqual` fromFoldable [{
            id: "common",
            level: Insecure,
            value: Just "5"
        }]

        check10k "gocats" `shouldEqual` fromFoldable [{
            id: "common",
            level: Insecure,
            value: Just "9918"
        }]

        check' "abcd1234" `shouldEqual` fromFoldable [{
            id: "length.short",
            level: Warning,
            value: Nothing
        }]

        patternsCheck "abcd1234" `shouldEqual` fromFoldable [{
            id: "just.alphanumeric",
            level: Warning,
            value: Nothing
        }, {
            id: "length.short",
            level: Warning,
            value: Nothing
        }, {
            id: "no.symbols",
            level: Notice,
            value: Nothing
        }]

        patternsCheck "correcthorsebatterystaple" `shouldEqual` fromFoldable [{
            id: "xkcd",
            level: EasterEgg,
            value: Nothing
        }, {
            id: "just.letters",
            level: Notice,
            value: Nothing
        }, {
            id: "length.long",
            level: Achievement,
            value: Nothing
        }]
