module Test.Helper (
    unsafeFromMaybe
) where

import Prelude (Unit)
import Data.Maybe (Maybe, fromMaybe')

foreign import maybeCheat :: forall a. (Unit -> a)

unsafeFromMaybe :: forall a. Maybe a -> a
unsafeFromMaybe m = fromMaybe' maybeCheat m
