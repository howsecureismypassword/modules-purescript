module NamedNumber (
    Names
  , NamedNumber
  , namedNumber
) where

import Prelude ((<>), (<), (-), otherwise)
import Data.String (length, splitAt)
import Data.BigInt (BigInt, toString)
import Data.List.NonEmpty (NonEmptyList, head)
import Data.Maybe(Maybe(..))

import Utility (findLast)

type NamedNumber = {
    name :: String
  , value :: Int
}

type Names = NonEmptyList NamedNumber

type Strings = NonEmptyList String

type Result = {
    value :: Int
  , names :: Strings
}

next :: Names -> String -> String -> String
next names number acc =
    case findLast check Nothing names of
        Just { name, value } ->
            let { before } = splitAt (len - value) number
            in reduce names before (" " <> name <> acc)
        Nothing -> number <> acc
    where len = length number
          check num = len - 1 < num.value

getLimit :: Names -> Int
getLimit names = (head names).value

reduce :: Names -> String -> String -> String
reduce names number acc
    | length number - 1 < getLimit names = number <> acc
    | otherwise = next names number acc


namedNumber :: Names -> BigInt -> String
namedNumber names value = reduce names (toString value) ""
