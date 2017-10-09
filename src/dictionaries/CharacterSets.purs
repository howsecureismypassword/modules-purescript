module Dictionary.CharacterSets where

import Prelude (($), map)
import Data.Int (toNumber)
import Data.List (List, fromFoldable)
import Data.String.Regex (Regex, regex)
import Data.String.Regex.Flags (global)
import Data.Either (Either(..))

type UnparsedCharacterSet = {
    name :: String,
    test :: String,
    value :: Int 
}

type CharacterSet = {
    name :: String,
    test :: Regex,
    value :: Number 
}

type CharacterSets = List CharacterSet

regex' :: String -> Either String Regex
regex' s = regex s global

safe :: Either String Regex -> Regex
safe (Right a) = a
safe (Left a) = safe $ regex' "//"

parse :: UnparsedCharacterSet -> CharacterSet
parse { name, test, value } = {
    name: name,
    test: safe $ regex' test,
    value: toNumber value
}

sets :: CharacterSets 
sets = map parse $ fromFoldable [
    {
        name: "ASCII Control Character",
        test: "[\\u0000-\\u001F]",
        value: 32
    },
    {
        name: "ASCII Lowercase",
        test: "[a-z]",
        value: 26
    },
    {
        name: "ASCII Uppercase",
        test: "[A-Z]",
        value: 26
    },
    {
        name: "ASCII Numbers",
        test: "\\d",
        value: 10
    },
    {
        name: "ASCII Top Row Symbols",
        test: "[-!@£#$%^&*()=+_]",
        value: 15
    },
    {
        name: "ASCII Other Symbols",
        test: "[\\s\\?\\/\\.>,<`~\\|;:\\]}\\[{'\"\\\\]", value: 19
    },

    {
        name: "Unicode Latin 1 Supplement",
        test: "[\\u00A1-\\u00A2\\u00A4-\\u00FF]",
        value: 93
    },
    {
        name: "Unicode Latin 1 Supplement Non Standard",
        test: "[\\u0080-\\u00A0]",
        value: 33
    },
    {
        name: "Unicode Latin Extended A",
        test: "[\\u0100-\\u017F]",
        value: 128
    },
    {
        name: "Unicode Latin Extended B",
        test: "[\\u0180-\\u024F]",
        value: 208
    },
    {
        name: "Unicode Latin Extended C",
        test: "[\\u2C60-\\u2C7F]",
        value: 32
    },
    {
        name: "Unicode Latin Extended D",
        test: "[\\uA720-\\uA7FF]",
        value: 29
    },

    {
        name: "Unicode Cyrillic Uppercase",
        test: "[\\u0410-\\u042F]",
        value: 32
    },
    {
        name: "Unicode Cyrillic Lowercase",
        test: "[\\u0430-\\u044F]",
        value: 32
    }
]
