module Dictionary.CharacterSets where

import Data.List(List, fromFoldable)

type CharacterSet = {
    name :: String,
    regex :: String,
    value :: Int 
}

type CharacterSets = List CharacterSet

sets :: CharacterSets 
sets = fromFoldable [
    {
        name: "ASCII Control Character",
        regex: "[\\u0000-\\u001F]",
        value: 32
    },
    {
        name: "ASCII Lowercase",
        regex: "[a-z]",
        value: 26
    },
    {
        name: "ASCII Uppercase",
        regex: "[A-Z]",
        value: 26
    },
    {
        name: "ASCII Numbers",
        regex: "\\d",
        value: 10
    },
    {
        name: "ASCII Top Row Symbols",
        regex: "[-!@£#$%^&*()=+_]",
        value: 15
    },
    {
        name: "ASCII Other Symbols",
        regex: "[\\s\\?\\/\\.>,<`~\\|;:\\]}\\[{'\"\\\\]", value: 19
    },

    {
        name: "Unicode Latin 1 Supplement",
        regex: "[\\u00A1-\\u00A2\\u00A4-\\u00FF]",
        value: 93
    },
    {
        name: "Unicode Latin 1 Supplement Non Standard",
        regex: "[\\u0080-\\u00A0]",
        value: 33
    },
    {
        name: "Unicode Latin Extended A",
        regex: "[\\u0100-\\u017F]",
        value: 128
    },
    {
        name: "Unicode Latin Extended B",
        regex: "[\\u0180-\\u024F]",
        value: 208
    },
    {
        name: "Unicode Latin Extended C",
        regex: "[\\u2C60-\\u2C7F]",
        value: 32
    },
    {
        name: "Unicode Latin Extended D",
        regex: "[\\uA720-\\uA7FF]",
        value: 29
    },

    {
        name: "Unicode Cyrillic Uppercase",
        regex: "[\\u0410-\\u042F]",
        value: 32
    },
    {
        name: "Unicode Cyrillic Lowercase",
        regex: "[\\u0430-\\u044F]",
        value: 32
    }
]
