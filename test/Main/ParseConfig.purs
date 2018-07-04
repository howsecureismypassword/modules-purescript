module Test.Main.ParseConfig where

import Prelude (Unit, discard)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Main.ParseConfig (UnparsedConfig, ParsedConfig, parseConfig)
import Period (Period)

foreign import config :: UnparsedConfig
foreign import catchSetupError :: (UnparsedConfig -> ParsedConfig) -> UnparsedConfig -> String
foreign import dodgyPeriod :: Period

-- tests
checks :: Spec Unit
checks = describe "Main.ParseConfig (parseConfig)" do
    it "throws parsing errors" do
       catchSetupError parseConfig {
           calculation: config.calculation,
           time: {
               periods: [],
               namedNumbers: config.time.namedNumbers,
               forever: config.time.forever,
               instantly: config.time.instantly
           },
           checks: config.checks
       } `shouldEqual` "Invalid periods dictionary"

       catchSetupError parseConfig {
           calculation: config.calculation,
           time: {
               periods: config.time.periods,
               namedNumbers: [],
               forever: config.time.forever,
               instantly: config.time.instantly
           },
           checks: config.checks
       } `shouldEqual` "Invalid named numbers dictionary"

       catchSetupError parseConfig {
           calculation: {
               calcs: config.calculation.calcs,
               characterSets: []
           },
           time: config.time,
           checks: config.checks
       } `shouldEqual` "Invalid character sets dictionary"

       catchSetupError parseConfig {
           calculation: config.calculation,
           time: config.time,
           checks: {
               dictionary: [],
               patterns: config.checks.patterns,
               messages: config.checks.messages
           }
       } `shouldEqual` "Invalid password dictionary"

       catchSetupError parseConfig {
           calculation: config.calculation,
           time: config.time,
           checks: {
               dictionary: config.checks.dictionary,
               patterns: [],
               messages: config.checks.messages
           }
       } `shouldEqual` "Invalid patterns dictionary"
