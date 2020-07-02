module Test.Config.Parser where

import Prelude (Unit, discard)
import Test.Spec (Spec, describe, it)
import Test.Spec.Assertions (shouldEqual)

import Data.List.NonEmpty (length)

import Config.Types (Settings)

-- tested modules
import Config.Parser (parse)

-- test data
import Test.Data (configF)

-- results
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
    let parsed = parse configF
    it "parses config" do
        parsed.settings `shouldEqual` settings
        length parsed.dictionaries.characterSets `shouldEqual` 14
        length parsed.dictionaries.periods `shouldEqual` 15
        length parsed.dictionaries.namedNumbers `shouldEqual` 72
        length parsed.dictionaries.top `shouldEqual` 9999
        length parsed.dictionaries.patterns `shouldEqual` 13
        length parsed.dictionaries.checks `shouldEqual` 14
