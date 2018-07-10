module Checker (
    module Checker.Internal
  , module Checker.Checks.Dictionary
  , module Checker.Checks.Patterns
) where

import Checker.Internal (
    check
  , read
  , parseMessages
  , Checker
  , Check
  , CheckResult
  , CheckResults
  , Checks
  , Results
  , Result
  , MessageInput
  , Level(..)
)

import Checker.Checks.Dictionary (
    checkDictionary
)

import Checker.Checks.Patterns (
    Pattern
  , checkPatterns
)
