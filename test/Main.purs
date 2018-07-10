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

import Main.Internal (UnparsedConfig, Response, parseConfig)
import Period (Period)
import Data.Nullable (toNullable)
import Data.Maybe (Maybe(Just))

foreign import config :: UnparsedConfig
foreign import catchSetupError :: (UnparsedConfig -> (String -> Response)) -> UnparsedConfig -> String
foreign import catchTimeError :: (String -> Response) -> String -> String
foreign import dodgyPeriod :: Period

-- tests
main :: Effect Unit
main = run [consoleReporter] do
    Calculator.checks
    Checker.checks
    NamedNumber.checks
    Period.checks
    Utility.checks

    describe "Main (parseConfig)" do
        it "parses config" do
            parseConfig config "uekdjeis1" `shouldEqual` {
                level: toNullable (Just "warning"),
                time: "42 minutes",
                checks: [
                    {
                        level: "warning",
                        message: "Your password looks like it might just be a word and a few digits. This is a very common pattern and would be cracked very quickly.",
                        name: "Possibly a Word and a Number"
                    },
                    {
                        level: "warning",
                        message: "Your password is quite short. The longer a password is the more secure it will be.",
                        name: "Length: Short"
                    },
                    {
                        level: "notice",
                        message: "Your password only contains numbers and letters. Adding a symbol can make your password more secure. Don't forget you can often use spaces in passwords.",
                        name: "Character Variety: No Symbols"
                    }
                ]
            }

        it "shows instant for insecure passwords" do
            parseConfig config "password1" `shouldEqual` {
                level: toNullable (Just "insecure"),
                time: "Instantly",
                checks: [
                    {
                        level: "insecure",
                        message: "Your password is very commonly used. It would be cracked almost instantly.",
                        name: "Common Password: In the top 621 most used passwords"
                    },
                    {
                        level: "warning",
                        message: "Your password looks like it might just be a word and a few digits. This is a very common pattern and would be cracked very quickly.",
                        name: "Possibly a Word and a Number"
                    },
                    {
                        level: "warning",
                        message: "Your password is quite short. The longer a password is the more secure it will be.",
                        name: "Length: Short"
                    },
                    {
                        level: "notice",
                        message: "Your password only contains numbers and letters. Adding a symbol can make your password more secure. Don't forget you can often use spaces in passwords.",
                        name: "Character Variety: No Symbols"
                    }
                ]
            }

        it "shows forever for secure passwords" do
            parseConfig {
                calcs: config.calcs,
                time: {
                    periods: [{
                        singular: "blahtosecond",
                        plural: "blahtoseconds",
                        seconds: 0.1
                    }],
                    namedNumbers: config.time.namedNumbers,
                    forever: config.time.forever,
                    instantly: config.time.instantly
                },
                characterSets: config.characterSets,
                checks: config.checks
            } "aVeryLong47&83**AndComplicated(8347)PasswordThatN0OneCouldEverGuess" `shouldEqual` {
                level: toNullable (Just "achievement"),
                time: "Forever",
                checks: [{
                    level: "achievement",
                    message: "Your password is over sixteen characters long.",
                    name: "Length: Long"
                }]
            }


        it "throws parsing errors" do
           catchSetupError parseConfig {
               calcs: config.calcs,
               time: {
                   periods: [],
                   namedNumbers: config.time.namedNumbers,
                   forever: config.time.forever,
                   instantly: config.time.instantly
               },
               characterSets: config.characterSets,
               checks: config.checks
           } `shouldEqual` "Invalid periods dictionary"

           catchSetupError parseConfig {
               calcs: config.calcs,
               time: {
                   periods: config.time.periods,
                   namedNumbers: [],
                   forever: config.time.forever,
                   instantly: config.time.instantly
               },
               characterSets: config.characterSets,
               checks: config.checks
           } `shouldEqual` "Invalid named numbers dictionary"

           catchSetupError parseConfig {
               calcs: config.calcs,
               time: config.time,
               characterSets: [],
               checks: config.checks
           } `shouldEqual` "Invalid character sets dictionary"

           catchSetupError parseConfig {
               calcs: config.calcs,
               time: config.time,
               characterSets: config.characterSets,
               checks: {
                   dictionary: [],
                   patterns: config.checks.patterns,
                   messages: config.checks.messages
               }
           } `shouldEqual` "Invalid password dictionary"

           catchSetupError parseConfig {
               calcs: config.calcs,
               time: config.time,
               characterSets: config.characterSets,
               checks: {
                   dictionary: config.checks.dictionary,
                   patterns: [],
                   messages: config.checks.messages
               }
           } `shouldEqual` "Invalid patterns dictionary"
