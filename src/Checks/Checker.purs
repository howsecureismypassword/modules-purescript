module Checks.Checker where

import Prelude (($), (<>), (<$>), (<<<), (+), (==), show, pure, bind)

import Data.List.NonEmpty (NonEmptyList, (!!), elemIndex, findIndex)
import Data.Array (catMaybes, fromFoldable)
import Data.Maybe (Maybe(Nothing))
import Data.String (Replacement(Replacement), Pattern(Pattern), replace) as S
import Data.String.Regex (test)

import Utility (roundTo)

import Config.Types (Config, Level(..), Pattern, Check, Checks)

type Message = {
    name :: String
  , level :: Level
  , message :: String
}

type Messages = Array Message

getMessage :: Checks -> String -> Maybe Check
getMessage checks id = do
    messageIndex <- findIndex ((_ == id) <<< (_.id)) checks
    checks !! messageIndex

-- common passwords
rankCommon :: NonEmptyList String -> String -> Maybe Int
rankCommon dic password = roundTo 10 <<< (_ + 1) <$> elemIndex password dic

insertValue :: String -> String -> String
insertValue value name = S.replace (S.Pattern "{{ value }}") (S.Replacement value) name

checkCommon :: Config -> String -> Maybe Message
checkCommon { settings, dictionaries } password = do
    rank <- rankCommon dictionaries.top password
    { name, message } <- getMessage dictionaries.checks "common"
    let name' = insertValue (show rank) name
    pure { name: name', message, level: Insecure }

--patterns
checkPattern :: Config -> String -> Pattern -> Maybe Message
checkPattern { dictionaries } password { id, level, regex } = do
    if test regex password
        then do
            { name, message } <- getMessage dictionaries.checks id
            pure { name, message, level }
        else Nothing

checkPatterns :: Config -> String -> Array (Maybe Message)
checkPatterns config password = fromFoldable (checkPattern config password <$> config.dictionaries.patterns)


-- check
check :: Config -> String -> Messages
check config password = catMaybes $ [checkCommon config password] <> checkPatterns config password
