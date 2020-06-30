module Time.NamedNumber where

import Prelude ((<>), (<), (-))
import Data.String (length, splitAt)
import Data.BigInt (BigInt, toString)
import Data.List.NonEmpty (head)

import Config.Types (NamedNumbers)

import Utility (findLast)

reduce :: NamedNumbers -> String -> String -> String
reduce names number acc =
    if len - 1 < (head names).value
        then number <> acc
        else reduce names before (" " <> name <> acc)
    where len = length number
          check num = len - 1 < num.value
          { name, value } = findLast check names
          { before } = splitAt (len - value) number

namedNumber :: NamedNumbers -> BigInt -> String
namedNumber names value = reduce names (toString value) ""
