module NamedNumber (NamedNumber, namedNumber) where

import Prelude ((<$>), (<>), (<), (-), otherwise)
import Data.String (length, splitAt)
import Data.BigInt (BigInt, toString)
import Data.List (List, head)
import Data.Maybe(Maybe(..), fromMaybe)

import Utility (findLast)

type NamedNumber = {
    name :: String
  , value :: Int
}

type Names = List NamedNumber

type Strings = List String

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
getLimit names = fromMaybe 2 ((\h -> h.value) <$> head names)

reduce :: Names -> String -> String -> String
reduce names number acc
    | length number - 1 < getLimit names = number <> acc
    | otherwise = next names number acc


namedNumber :: List NamedNumber -> BigInt -> String
namedNumber names value = reduce names (toString value) ""
