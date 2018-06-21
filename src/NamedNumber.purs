module NamedNumber (NamedNumber, namedNumber) where

import Prelude ((<>), (<<<), (*), (+), (-), (/), (<=), (>), ($), otherwise)
import Math (log, log10e, pow)
import Data.Int (floor, toNumber, decimal, toStringAs)
import Data.Number (isFinite)
import Data.List (List, (:), length, filter, fromFoldable, last, foldl)
import Data.Maybe (Maybe(..))

import Utility (join)

type NamedNumber = {
    name :: String,
    value :: Int
}

type Names = List NamedNumber

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
contains x { value } = value <= x

filterNames :: Names -> Int -> Names
filterNames names x | x > 1 = filter (contains x) names
                    | otherwise = empty

latest :: Result -> String -> Int -> Result
latest previous name value = {
    value: previous.value + value,
    names: name : previous.names
}

findNames :: Result -> Names -> Int -> Result
findNames results names x =
    case last names' of
        Nothing -> results
        Just { name, value } -> find (latest results name value) names' (x - value)
    where names' = filterNames names x

find :: Result -> Names -> Int -> Result
find results names x
    | length names > 0 = findNames results names x
    | otherwise = results

toString :: Int -> String
toString = toStringAs decimal

significand :: Number -> Int -> Int
significand value exp = floor $ value / pow 10.0 (toNumber exp)

-- gets the exponent of the given number, then uses find
getName :: Names -> Number -> String
getName names x = toString (significand x value) <> foldl join "" names
    where initial = { value: 0, names: empty }
          {value, names} = find initial names $ exponent x

namedNumber :: Array NamedNumber -> Number -> String
namedNumber names x
    | isFinite x = getName (fromFoldable names) x
    | otherwise = "Infinity"
