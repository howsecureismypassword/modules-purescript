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
    show Highlight = "Highlight"
    show Insecure = "Insecure"
    show Warning = "Warning"
    show Achievement = "Achievement"
    show Notice = "Notice"
    show EasterEgg = "EasterEgg"

read :: String -> Maybe Level
read "Highlight" = Just Highlight
read "Insecure" = Just Insecure
read "Warning" = Just Warning
read "Achievement" = Just Achievement
read "Notice" = Just Notice
read "EasterEgg" = Just EasterEgg
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
