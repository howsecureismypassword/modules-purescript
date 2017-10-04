module NamedNumbers where

import Data.List(List, fromFoldable)

type NamedNumber = {
    name :: String,
    value :: Int
}

type Names = List NamedNumber

names :: Names 
names = fromFoldable [
    { name: "hundred", value: 2 },
    { name: "thousand", value: 3 },
    { name: "million", value: 6 },
    { name: "billion", value: 9 },
    { name: "trillion", value: 12 },
    { name: "quadrillion", value: 15 }
]
