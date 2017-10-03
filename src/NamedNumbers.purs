module NamedNumbers where

import Prelude
import Math(log, log10e)
import Data.Int(floor)
import Data.List(List, (:), length, filter, fromFoldable, last)
import Data.Maybe(Maybe(..))

type NamedNumber = {
    name :: String,
    value :: Int
}

type Names = List NamedNumber
type Strings = List String

names :: Names 
names = fromFoldable [
    { name: "hundred", value: 2 },
    { name: "thousand", value: 3 },
    { name: "million", value: 6 },
    { name: "billion", value: 9 },
    { name: "trillion", value: 12 },
    { name: "quadrillion", value: 15 }
]

-- finds the base 10 log using change of base formula (ln x / ln 10)
log10 :: Number -> Number
log10 = (*) log10e <<< log

-- works out the current exponent in base 10 (e.g. hundreds, thousands)
exponent :: Number -> Int
exponent = floor <<< log10

contains :: Int -> NamedNumber -> Boolean
contains x {value} = value <= x

filterNames :: Names -> Int -> Names
filterNames values x | x > 1 = filter (contains x) values
                     | otherwise = (fromFoldable [])

--------------
-- feels wrong
getArray :: Strings -> Maybe NamedNumber -> Strings
getArray ns n = case n of
    Nothing -> ns
    Just {name} -> name : ns

getValue :: Int -> Maybe NamedNumber -> Int
getValue x n = case n of
    Nothing -> 0 
    Just {value} -> x - value

find :: Int -> Names -> Strings -> Strings
find x values arr
    | length values > 0 = do
        let
            vals = filterNames values x
            l = last vals
            a = getArray arr l
            y = getValue x l

        find y vals a
    | otherwise = arr
-- /feels wrong
---------------

namedNumber :: Number -> Int
namedNumber x = exponent x 
