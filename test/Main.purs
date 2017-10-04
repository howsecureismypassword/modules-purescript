module Test.Main where

import Prelude
import Control.Monad.Eff (Eff)
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.Console (consoleReporter)
import Test.Spec.Runner (RunnerEffects, run)

import Main(namedNumber')

main :: Eff (RunnerEffects ()) Unit
main = run [consoleReporter] do
    describe "namedNumber'" do
       it "names numbers" do
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

