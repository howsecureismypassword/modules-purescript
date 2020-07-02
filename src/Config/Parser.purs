module Config.Parser where

import Prelude ((>>=), (<$>), ($), pure, bind, flip)

import Control.Monad.Except (runExcept)
import Effect.Exception.Unsafe (unsafeThrow)

import Foreign (F, Foreign, ForeignError(ForeignError), MultipleErrors, fail, renderForeignError, readBoolean, readNumber, readString, readInt, readArray)
import Foreign.Index (readProp)

import Data.Either (Either(Right, Left))
import Data.List.NonEmpty (NonEmptyList, intercalate, fromFoldable)
import Data.Maybe (Maybe(Nothing, Just))
import Data.String.Regex (Regex, regex)
import Data.String.Regex.Flags (global)
import Data.Traversable (sequence)

import Config.Types

readNonEmptyList :: Foreign -> F (NonEmptyList Foreign)
readNonEmptyList f = do
    arr <- readArray f
    case fromFoldable arr of
        Nothing -> fail $ ForeignError "Empty array"
        Just nel -> pure nel

readRegex :: Foreign -> F Regex
readRegex f = do
    rgx' <- flip regex global <$> readString f
    case rgx' of
         Left _ -> fail $ ForeignError "Invalid regex"
         Right rgx -> pure rgx

-- dictionaries
readLevel :: Foreign -> F Level
readLevel f = do
    level <- readString f
    case level of
         "insecure" -> pure Insecure
         "warning" -> pure Warning
         "easter-egg" -> pure EasterEgg
         "notice" -> pure Notice
         "achievement" -> pure Achievement
         _ -> fail $ ForeignError "Invalid level"

readPattern :: Foreign -> F Pattern
readPattern ps = do
    level <- "level" `readProp` ps >>= readLevel
    id <- "id" `readProp` ps >>= readString
    rgx <- "regex" `readProp` ps >>= readRegex
    pure { level, id, regex: rgx }

readCheck :: Foreign -> F Check
readCheck cs = do
    id <- "id" `readProp` cs >>= readString
    name <- "name" `readProp` cs >>= readString
    message <- "message" `readProp` cs >>= readString
    pure { id, name, message }

readNamedNumber :: Foreign -> F NamedNumber
readNamedNumber ns = do
    name <- "name" `readProp` ns >>= readString
    value <- "value" `readProp` ns >>= readInt
    pure { name, value }

readPeriod :: Foreign -> F Period
readPeriod ps = do
    singular <- "singular" `readProp` ps >>= readString
    plural <- "plural" `readProp` ps >>= readString
    seconds <- "seconds" `readProp` ps >>= readNumber
    pure { singular, plural, seconds }

readCharacterSet :: Foreign -> F CharacterSet
readCharacterSet cs = do
    name <- "name" `readProp` cs >>= readString
    matches <- "matches" `readProp` cs >>= readRegex
    value <- "value" `readProp` cs >>= readInt
    pure { name, matches, value }

readNamedNumbers :: Foreign -> F (NonEmptyList NamedNumber)
readNamedNumbers config = do
    namedNumbers <- "language" `readProp` config >>= readProp "numbers" >>= readNonEmptyList
    sequence $ readNamedNumber <$> namedNumbers

readPeriods :: Foreign -> F (NonEmptyList Period)
readPeriods config = do
    periods <- "language" `readProp` config >>= readProp "periods" >>= readNonEmptyList
    sequence $ readPeriod <$> periods

readCharacterSets :: Foreign -> F (NonEmptyList CharacterSet)
readCharacterSets config = do
    characterSets <- "checks" `readProp` config >>= readProp "characterSets" >>= readNonEmptyList
    sequence $ readCharacterSet <$> characterSets

readTop :: Foreign -> F (NonEmptyList String)
readTop config = do
    top <- "checks" `readProp` config >>= readProp "common" >>= readNonEmptyList
    sequence $ (readString <$> top)

readPatterns :: Foreign -> F (NonEmptyList Pattern)
readPatterns config = do
    patterns <- "checks" `readProp` config >>= readProp "patterns" >>= readNonEmptyList
    sequence $ readPattern <$> patterns

readChecks :: Foreign -> F (NonEmptyList Check)
readChecks config = do
    checks <- "language" `readProp` config >>= readProp "checks" >>= readNonEmptyList
    sequence $ readCheck <$> checks

-- config
readDictionaries :: Foreign -> F Dictionaries
readDictionaries config = do
    characterSets <- readCharacterSets config
    periods <- readPeriods config
    namedNumbers <- readNamedNumbers config
    top <- readTop config
    patterns <- readPatterns config
    checks <- readChecks config
    pure { characterSets, periods, namedNumbers, top, patterns, checks }

readSettings :: Foreign -> F Settings
readSettings config = do
    calcs <- "calculationsPerSecond" `readProp` config >>= readNumber
    namedNumbers <- "namedNumbers" `readProp` config >>= readBoolean
    language <- "language" `readProp` config
    forever <- "forever" `readProp` language >>= readString
    instantly <- "instantly" `readProp` language >>= readString
    pure { namedNumbers, calcs, forever, instantly }

readConfig :: Foreign -> F Config
readConfig config = do
    settings <- readSettings config
    dictionaries <- readDictionaries config
    pure { settings, dictionaries }

-- parse
errors :: MultipleErrors -> String
errors errs = intercalate ";" (renderForeignError <$> errs)

parse :: Foreign -> Config
parse config = case runExcept (readConfig config) of
    Left errs -> unsafeThrow (errors errs)
    Right cfg -> cfg
