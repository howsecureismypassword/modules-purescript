module Test.Checker where

import Prelude (($), Unit, discard, bind, pure)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Data.List as List
import Data.List.NonEmpty (fromFoldable)
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

check' :: String -> Maybe Results
check' password = do
    dictionary <- fromFoldable top10
    checks' <- fromFoldable [
            Dictionary.check dictionary
          , Pattern.check "length.short" Warning "^.{7,9}$"
        ]
    pure $ check checks' password

check10k :: String -> Maybe Results
check10k password = do
    dictionary <- fromFoldable top10k
    checks' <- fromFoldable [Dictionary.check dictionary]
    pure $ check checks' password

patternsCheck :: String -> Maybe Results
patternsCheck password = do
    patterns' <- fromFoldable patterns
    checks' <- Patterns.patterns patterns'
    pure $ check checks' password


-- tests
checks :: Spec Unit
checks = describe "Checks (checks)" do
    it "checks" do
        check' "password" `shouldEqual` Just (List.fromFoldable [{
            id: "common",
            level: Insecure,
            value: Just "1"
        }, {
            id: "length.short",
            level: Warning,
            value: Nothing
        }])

        check' "qwerty" `shouldEqual` Just (List.fromFoldable [{
            id: "common",
            level: Insecure,
            value: Just "5"
        }])

        check10k "gocats" `shouldEqual` Just (List.fromFoldable [{
            id: "common",
            level: Insecure,
            value: Just "9918"
        }])

        check' "abcd1234" `shouldEqual` Just (List.fromFoldable [{
            id: "length.short",
            level: Warning,
            value: Nothing
        }])

        patternsCheck "abcd1234" `shouldEqual` Just (List.fromFoldable [{
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
        }])

        patternsCheck "correcthorsebatterystaple" `shouldEqual` Just (List.fromFoldable [{
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
        }])
