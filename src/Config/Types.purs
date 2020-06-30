module Config.Types where

import Data.String.Regex (Regex)

-- dictionaries
type CharacterSet = {
    name :: String
  , matches :: Regex
  , value :: Int
}

type Period = {
    singular :: String
  , plural :: String
  , seconds :: Number
}

type NamedNumber = {
    name :: String
  , value :: Int
}

type Pattern = {
    level :: String
  , id :: String
  , regex :: Regex
}

type Check = {
    id :: String
  , name :: String
  , message:: String
}

-- config
type Settings = {
    calcs :: Number
  , namedNumbers :: Boolean
  , forever :: String
  , instantly :: String
}

type Dictionaries = {
    characterSets :: Array CharacterSet
  , periods :: Array Period
  , namedNumbers :: Array NamedNumber
  , top :: Array String
  , patterns :: Array Pattern
  , checks :: Array Check
}

type Config = {
    settings :: Settings
  , dictionaries :: Dictionaries
}
