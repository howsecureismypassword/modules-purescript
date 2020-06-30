module Config.Parser where

import Prelude ((>>=), (<$>), ($), pure, bind, flip)
import Foreign (F, Foreign, ForeignError(ForeignError), MultipleErrors, fail, renderForeignError, readBoolean, readNumber, readString, readInt, readArray)
import Foreign.Index (readProp)
import Data.Bifunctor (lmap)
import Data.List.NonEmpty (intercalate)
import Control.Monad.Except (runExcept)
import Data.Either (Either(Right, Left))
import Data.String.Regex (regex)
import Data.String.Regex.Flags (global)
import Data.Traversable (sequence)

import Config.Types

-- dictionaries
readPattern :: Foreign -> F Pattern
readPattern ps = do
    level <- "level" `readProp` ps >>= readString
    id <- "id" `readProp` ps >>= readString
    regex' <- flip regex global <$> ("regex" `readProp` ps >>= readString)
    case regex' of
         Left _ -> fail $ ForeignError "Invalid regex"
         Right regex -> pure { level, id, regex }

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
    matches' <- flip regex global <$> ("matches" `readProp` cs >>= readString)
    value <- "value" `readProp` cs >>= readInt
    case matches' of
         Left _ -> fail $ ForeignError "Invalid regex"
         Right matches -> pure { name, matches, value }

readNamedNumbers :: Foreign -> F (Array NamedNumber)
readNamedNumbers config = do
    namedNumbers <- "time" `readProp` config >>= readProp "namedNumbers" >>= readArray
    sequence $ readNamedNumber <$> namedNumbers

readPeriods :: Foreign -> F (Array Period)
readPeriods config = do
    periods <- "time" `readProp` config >>= readProp "periods" >>= readArray
    sequence $ readPeriod <$> periods

readCharacterSets :: Foreign -> F (Array CharacterSet)
readCharacterSets config = do
    characterSets <- "calculation" `readProp` config >>= readProp "characterSets" >>= readArray
    sequence $ readCharacterSet <$> characterSets

readTop :: Foreign -> F (Array String)
readTop config = do
    top <- "checks" `readProp` config >>= readProp "dictionary" >>= readArray
    sequence $ (readString <$> top)

readPatterns :: Foreign -> F (Array Pattern)
readPatterns config = do
    patterns <- "checks" `readProp` config >>= readProp "patterns" >>= readArray
    sequence $ readPattern <$> patterns

readChecks :: Foreign -> F (Array Check)
readChecks config = do
    checks <- "checks" `readProp` config >>= readProp "messages" >>= readArray
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
    calcs <- "calculation" `readProp` config >>= readProp "calcs" >>= readNumber
    time <- "time" `readProp` config
    forever <- "forever" `readProp` time >>= readString
    instantly <- "instantly" `readProp` time >>= readString
    namedNumbers <- "output" `readProp` config >>= readProp "namedNumbers" >>= readBoolean
    pure { namedNumbers, calcs, forever, instantly }

readConfig :: Foreign -> F Config
readConfig config = do
    settings <- readSettings config
    dictionaries <- readDictionaries config
    pure { settings, dictionaries }

-- parse
errors :: MultipleErrors -> String
errors errs = intercalate ";" (renderForeignError <$> errs)

parse :: Foreign -> Either String Config
parse config = errors `lmap` runExcept (readConfig config)
