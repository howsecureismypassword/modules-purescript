module NamedNumber (namedNumber) where

import Prelude ((==), (<>), (<<<), (*), (+), (-), (/), (<=), (>), ($), otherwise)
import Math (log, log10e, pow)
import Data.Int (floor, toNumber, decimal, toStringAs)
import Data.Number (isFinite)
import Data.List (List, (:), length, filter, fromFoldable, last, foldl)
import Data.Maybe (Maybe(..))

import Dictionary.NamedNumbers (NamedNumber, Names)

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

safe :: Maybe NamedNumber -> NamedNumber
safe n = case n of
    Nothing -> { name: "", value: 0 } 
    Just a -> a

result :: Int -> Strings -> Result
result x ns = { value: x, names: ns }

latest :: Result -> String -> Int -> Result
latest old name value
    | value == 0 = old
    | otherwise = result (old.value + value) (name: old.names)

findNames :: Result -> Names -> Int -> Result
findNames results names x = do
    let names' = filterNames names x
        {name, value} = safe $ last names'

    find' (latest results name value) names' (x - value)

find' :: Result -> Names -> Int -> Result
find' results names x
    | length names > 0 = findNames results names x
    | otherwise = results

-- starts find' with an empty list
find :: Names -> Int -> Result
find = find' (result 0 empty)

join :: String -> String -> String
join str n = str <> " " <> n

getName :: Names -> Number -> String
getName names x = do
    let {value, names} = find names $ exponent x 
        val = floor $ x / pow 10.0 (toNumber value)
    toStringAs decimal val <> foldl join "" names

-- gets the exponent of the given number, then uses find
namedNumber :: Names -> Number -> String
namedNumber names x
    | isFinite x = getName names x
    | otherwise = "Infinity"
