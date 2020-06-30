module Test.Config.Parser where

import Prelude ((<$>), (<<<), Unit, discard)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Foreign (Foreign)
import Data.List.NonEmpty (length)
import Data.Either (Either(Right), isLeft)

import Config.Parser (parse)
import Config.Types (Settings)

foreign import config :: Foreign
foreign import dodgy :: Foreign

settings :: Settings
settings = {
        calcs: 40000000000.0
      , namedNumbers: true
      , forever: "Forever"
      , instantly: "Instantly"
    }

-- tests
checks :: Spec Unit
checks = describe "Parser.Config" do
    let parsed = parse config
    it "parses config" do
        ((\p -> p.settings) <$> parsed) `shouldEqual` Right settings
        (length <<< (\p -> p.dictionaries.characterSets) <$> parsed) `shouldEqual` Right 14
        (length <<< (\p -> p.dictionaries.periods) <$> parsed) `shouldEqual` Right 15
        (length <<< (\p -> p.dictionaries.namedNumbers) <$> parsed) `shouldEqual` Right 72
        (length <<< (\p -> p.dictionaries.top) <$> parsed) `shouldEqual` Right 9999
        (length <<< (\p -> p.dictionaries.patterns) <$> parsed) `shouldEqual` Right 13
        (length <<< (\p -> p.dictionaries.checks) <$> parsed) `shouldEqual` Right 14

    it "errors when properties are missing" do
       isLeft (parse dodgy) `shouldEqual` true
