module Config.Types where

import Prelude (class Eq, class Ord, class Show)
import Data.String.Regex (Regex)
import Data.List.NonEmpty (NonEmptyList)

-- dictionaries
type CharacterSet = {
    name :: String
  , matches :: Regex
  , value :: Int
}

type CharacterSets = NonEmptyList CharacterSet

type Period = {
    singular :: String
  , plural :: String
  , seconds :: Number
}

type Periods = NonEmptyList Period

type NamedNumber = {
    name :: String
  , value :: Int
}

type NamedNumbers = NonEmptyList NamedNumber

data Level = Insecure | Warning | EasterEgg | Notice | Achievement
derive instance eqLevel :: Eq Level
derive instance ordLevel :: Ord Level

instance showLevel :: Show Level where
    show Insecure = "insecure"
    show Warning = "warning"
    show EasterEgg = "easter-egg"
    show Notice = "notice"
    show Achievement = "achievement"

type Pattern = {
    level :: Level
  , id :: String
  , regex :: Regex
}

type Patterns = NonEmptyList Pattern

type Check = {
    id :: String
  , name :: String
  , message:: String
}

type Checks = NonEmptyList Check

-- config
type Settings = {
    calcs :: Number
  , namedNumbers :: Boolean
  , forever :: String
  , instantly :: String
}

type Dictionaries = {
    characterSets :: CharacterSets
  , periods :: Periods
  , namedNumbers :: NonEmptyList NamedNumber
  , top :: NonEmptyList String
  , patterns :: NonEmptyList Pattern
  , checks :: NonEmptyList Check
}

type Config = {
    settings :: Settings
  , dictionaries :: Dictionaries
}
