module NamedNumber (namedNumber) where

import Prelude ((<>), (<<<), (*), (+), (-), (/), (<=), (>), ($), otherwise)
import Math (log, log10e, pow)
import Data.Int (floor, toNumber, decimal, toStringAs)
import Data.String (null)
import Data.List (List, (:), length, filter, fromFoldable, last, foldl)
import Data.Maybe (Maybe(..))
import NamedNumbers (NamedNumber, Names)

type Strings = List String

type Result = {
    value :: Int,
    names :: Strings
}

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

result :: Int -> Strings -> Result
result x ns = { value: x, names: ns }

--------------
-- feels wrong
find' :: Result -> Names -> Int -> Result
find' results names x
    | length names > 0 = do
        let
            names' = filterNames names x
            lNN = last names'
            name = getName lNN 
            value = getValue lNN
            exp = results.value + value

            results' = if null name then results else result exp (name : results.names)
            x' = (-) x $ getValue lNN

        find' results' names' x'
    | otherwise = results
-- /feels wrong
---------------


-- starts find' with an empty list
find :: Names -> Int -> Result
find = find' (result 0 empty)

join :: String -> String -> String
join str n = str <> " " <> n

-- gets the exponent of the given number, then uses find
namedNumber :: Names -> Number -> String
namedNumber names x = do
    let {value, names} = find names $ exponent x 
    let val = floor $ x / pow 10.0 (toNumber value)
    toStringAs decimal val <> foldl join "" names
