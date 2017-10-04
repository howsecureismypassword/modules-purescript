module Test.Main where

import Prelude
import Control.Monad.Eff (Eff)
import Test.Spec.Runner (RunnerEffects)

import Test.NamedNumber (test) as NamedNumber

main :: Eff (RunnerEffects ()) Unit
main = do
    NamedNumber.test
