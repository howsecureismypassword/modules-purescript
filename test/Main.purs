module Test.Main where

import Prelude (Unit, discard, ($))
import Effect (Effect)
import Effect.Aff (launchAff_)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (runSpec)

import Test.Config.Parser as Config
import Test.Time.Calculator as Calculator
import Test.Time.NamedNumber as NamedNumber
import Test.Time.Period as Period
import Test.Utility as Utility

-- tests
main :: Effect Unit
main = launchAff_ $ runSpec [consoleReporter] do
    Config.checks
    Calculator.checks
    NamedNumber.checks
    Period.checks
    Utility.checks
