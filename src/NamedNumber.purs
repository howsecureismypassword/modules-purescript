module NamedNumber where

import Prelude((<<<), (*), (-), (<=), (>), ($), otherwise)
import Math(log, log10e)
import Data.Int(floor)
import Data.String(null)
import Data.List(List, (:), length, filter, fromFoldable, last)
import Data.Maybe(Maybe(..))
import NamedNumbers(NamedNumber, Names)

type Strings = List String

-- creates an empty list
empty :: forall a. List a
empty = fromFoldable []

-- finds the base 10 log using change of base formula (ln x / ln 10)
log10 :: Number -> Number
log10 = (*) log10e <<< log

-- works out the current exponent in base 10 (e.g. hundreds, thousands)
exponent :: Number -> Int
exponent = floor <<< log10

contains :: Int -> NamedNumber -> Boolean
contains x {value} = value <= x

filterNames :: Names -> Int -> Names
filterNames names x | x > 1 = filter (contains x) names
                    | otherwise = empty 

getName :: Maybe NamedNumber -> String
getName n = case n of
    Nothing -> "" 
    Just {name} -> name

getValue :: Maybe NamedNumber -> Int
getValue n = case n of
    Nothing -> 0 
    Just {value} -> value

--------------
-- feels wrong
find' :: Strings -> Names -> Int -> Strings
find' results names x
    | length names > 0 = do
        let
            names' = filterNames names x
            result = last names'
            name = getName result 
            results' = if null name then results else name : results
            x' = (-) x $ getValue result

        find' results' names' x'
    | otherwise = results
-- /feels wrong
---------------


-- starts find' with an empty list
find :: Names -> Int -> Strings
find = find' empty 

-- gets the exponent of the given number, then uses find
namedNumber :: Names -> Number -> List String
namedNumber names x = find names $ exponent x 
