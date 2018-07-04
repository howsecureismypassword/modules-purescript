module Test.Main where

import Prelude (Unit, discard)
import Effect (Effect)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (run)

import Test.Checker as Checker
import Test.Period as Period
import Test.NamedNumber as NamedNumber
import Test.Calculator as Calculator
import Test.Utility as Utility
import Test.Main.ParseConfig as ParseConfig

-- tests
main :: Effect Unit
main = run [consoleReporter] do
    Calculator.checks
    Checker.checks
    NamedNumber.checks
    Period.checks
    Utility.checks
    ParseConfig.checks
