module Test.Checker where

import Prelude (Unit, discard)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Data.List as List
import Data.Maybe (Maybe(..))
import Data.List.NonEmpty (fromFoldable)

import Test.Helper (unsafeFromMaybe)

-- tested modules
import Checker.Internal (CheckResults, MessageInput, Level(..), checkResults)

import Checker.Checks.Dictionary as Dictionary
import Checker.Checks.Patterns as Patterns

-- dictionaries
foreign import top10 :: Array String
foreign import top10k :: Array String
foreign import patterns :: Array Patterns.Pattern
foreign import checkMessages :: Array MessageInput

check' :: String -> CheckResults
check' = checkResults checks'
    where dictionary = unsafeFromMaybe (fromFoldable top10)
          checks' = unsafeFromMaybe (fromFoldable [
                  Dictionary.checkDictionary dictionary
                , Patterns.checkPattern "length.short" Warning "^.{7,9}$"
              ])

check10k :: String -> CheckResults
check10k = checkResults checks'
    where dictionary = unsafeFromMaybe (fromFoldable top10k)
          checks' = unsafeFromMaybe (fromFoldable [Dictionary.checkDictionary dictionary])

patternsCheck :: String -> CheckResults
patternsCheck = checkResults checks'
    where patterns' = unsafeFromMaybe (fromFoldable patterns)
          checks' = unsafeFromMaybe (Patterns.checkPatterns patterns')


-- tests
checks :: Spec Unit
checks = describe "Checks (checks)" do
    it "checks" do
        check' "password" `shouldEqual` List.fromFoldable [{
            id: "common",
            level: Insecure,
            value: Just "10"
        }, {
            id: "length.short",
            level: Warning,
            value: Nothing
        }]

        check' "qwerty" `shouldEqual` List.fromFoldable [{
            id: "common",
            level: Insecure,
            value: Just "10"
        }]

        check10k "gocats" `shouldEqual` List.fromFoldable [{
            id: "common",
            level: Insecure,
            value: Just "9920"
        }]

        check' "abcd1234" `shouldEqual` List.fromFoldable [{
            id: "length.short",
            level: Warning,
            value: Nothing
        }]

        patternsCheck "abcd1234" `shouldEqual` List.fromFoldable [{
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

        patternsCheck "correcthorsebatterystaple" `shouldEqual` List.fromFoldable [{
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
