module Checker (
    check
  , read
  , Check
  , Checks
  , Result
  , Results
  , Level(..)
) where

import Prelude (($), (<$>), class Show, class Eq)
import Data.List (List)
import Data.List.NonEmpty (NonEmptyList, catMaybes)
import Data.Maybe (Maybe(..))

data Level = Highlight | Insecure | Warning | Achievement | Notice | EasterEgg
derive instance eqLevel :: Eq Level

instance showLevel :: Show Level where
    show Highlight = "highlight"
    show Insecure = "insecure"
    show Warning = "warning"
    show Achievement = "achievement"
    show Notice = "notice"
    show EasterEgg = "easterEgg"

read :: String -> Maybe Level
read "highlight" = Just Highlight
read "insecure" = Just Insecure
read "warning" = Just Warning
read "achievement" = Just Achievement
read "notice" = Just Notice
read "easterEgg" = Just EasterEgg
read _ = Nothing

type Result = {
    id :: String
  , level :: Level
  , value :: Maybe String
}

type Results = List Result
type Check = String -> Maybe Result
type Checks = NonEmptyList Check

check :: Checks -> String -> Results
check checks password = catMaybes $ (_ $ password) <$> checks
