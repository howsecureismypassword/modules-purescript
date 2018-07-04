module Test.Main where

import Prelude (Unit, discard)
import Effect (Effect)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (run)
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)

import Test.Checker as Checker
import Test.Period as Period
import Test.NamedNumber as NamedNumber
import Test.Calculator as Calculator
import Test.Utility as Utility

import Main (UnparsedConfig, Response, setup)

foreign import config :: UnparsedConfig
foreign import catchError :: (UnparsedConfig -> (String -> Response)) -> UnparsedConfig -> String

-- tests
main :: Effect Unit
main = run [consoleReporter] do
    Calculator.checks
    Checker.checks
    NamedNumber.checks
    Period.checks
    Utility.checks

    describe "Main (setup)" do
        it "parses config" do
            setup config "password1" `shouldEqual` {
                time: "42 minutes"
              , level: "insecure"
              , checks: [
                     { id: "common", level: "insecure", value: "621" }
                   , { id: "just.alphanumeric", level: "warning", value: "" }
                   , { id: "length.short", level: "warning", value: "" }
                   , { id: "no.symbols", level: "notice", value: "" }
                ]
            }

        it "throws errors" do
           catchError setup {
               calcs: config.calcs,
               periods: [],
               namedNumbers: config.namedNumbers,
               characterSets: config.characterSets,
               dictionary: config.dictionary,
               patterns: config.patterns
           } `shouldEqual` "Invalid periods dictionary"

           catchError setup {
               calcs: config.calcs,
               periods: config.periods,
               namedNumbers: [],
               characterSets: config.characterSets,
               dictionary: config.dictionary,
               patterns: config.patterns
           } `shouldEqual` "Invalid named numbers dictionary"

           catchError setup {
               calcs: config.calcs,
               periods: config.periods,
               namedNumbers: config.namedNumbers,
               characterSets: [],
               dictionary: config.dictionary,
               patterns: config.patterns
           } `shouldEqual` "Invalid character sets dictionary"

           catchError setup {
               calcs: config.calcs,
               periods: config.periods,
               namedNumbers: config.namedNumbers,
               characterSets: config.characterSets,
               dictionary: [],
               patterns: config.patterns
           } `shouldEqual` "Invalid password dictionary"

           catchError setup {
               calcs: config.calcs,
               periods: config.periods,
               namedNumbers: config.namedNumbers,
               characterSets: config.characterSets,
               dictionary: config.dictionary,
               patterns: []
           } `shouldEqual` "Invalid patterns dictionary"
