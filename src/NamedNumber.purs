module NamedNumber (
    Names
  , NamedNumber
  , namedNumber
) where

import Prelude ((<>), (<), (-))
import Data.String (length, splitAt)
import Data.BigInt (BigInt, toString)
import Data.List.NonEmpty (NonEmptyList, head)

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

reduce :: Names -> String -> String -> String
reduce names number acc =
    if len - 1 < (head names).value
        then number <> acc
        else reduce names before (" " <> name <> acc)
    where len = length number
          check num = len - 1 < num.value
          { name, value } = findLast check names
          { before } = splitAt (len - value) number

namedNumber :: Names -> BigInt -> String
namedNumber names value = reduce names (toString value) ""
