module NamedNumber (NamedNumber, namedNumber) where

import Prelude ((<>), (<), (-), otherwise)
import Data.String (length, splitAt)
import Data.BigInt (BigInt, toString)
import Data.List (List, fromFoldable)
import Data.Maybe(Maybe(..))

import Utility (findLast)

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

reduce :: Names -> String -> String -> String
reduce names number acc
    | length number - 1 < 2 = number <> acc -- shouldn't hardcode 2
    | otherwise = case findLast (\num -> length number - 1 < num.value) Nothing names of
        Nothing -> number <> acc
        Just { name, value } ->
            let { before, after } = splitAt (length number - value) number
            in reduce names before ( " " <> name <> acc)


namedNumber :: Array NamedNumber -> BigInt -> String
namedNumber names value = reduce (fromFoldable names) (toString value) ""
