module Checker.Internal where

import Prelude (($), (<$>), class Show, class Eq, class Ord, bind, pure)
import Data.String (Replacement(Replacement), Pattern(Pattern), replace)
import Data.List as List
import Data.List.NonEmpty (NonEmptyList, catMaybes)
import Data.Maybe (Maybe(..))
import Data.Map (Map, fromFoldable, lookup)
import Data.Tuple (Tuple(Tuple))

data Level = Insecure | Warning | EasterEgg | Notice | Achievement | Highlight
derive instance eqLevel :: Eq Level
derive instance ordLevel :: Ord Level

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

type CheckResult = {
    id :: String
  , level :: Level
  , value :: Maybe String
}

type MessageInput = {
    id :: String
  , name :: String
  , message :: String
}

type Message = {
    name :: String
  , message :: String
}

type Result = {
    name :: String
  , level :: Level
  , message :: String
}

type Messages = Map String Message
type Results = List.List Result

type CheckResults = List.List CheckResult
type Check = String -> Maybe CheckResult
type Checks = NonEmptyList Check

type Checker = String -> Results

checkResults :: Checks -> String -> CheckResults
checkResults checks password = catMaybes $ (_ $ password) <$> checks

check :: Checks -> Messages -> Checker
check checks msgs password = messages msgs (checkResults checks password)

parseName :: Maybe String -> String -> String
parseName Nothing name = name
parseName (Just value) name = replace (Pattern "{{ value }}") (Replacement value) name

toResult :: Messages -> CheckResult -> Maybe Result
toResult mgs { id, level, value } = do
    msg <- lookup id mgs
    pure {
        name: parseName value msg.name
      , message: msg.message
      , level: level
    }

messages :: Messages -> CheckResults -> Results
messages mgs chks = List.catMaybes $ toResult mgs <$> chks

parseMessages :: Array MessageInput -> Messages
parseMessages mgs = fromFoldable $ convert <$> mgs
    where convert { id, name, message } = Tuple id { name, message }
