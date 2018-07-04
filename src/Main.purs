module Main (setup) where

import Main.Internal (Response, main)
import Main.ParseConfig (UnparsedConfig, parseConfig)

setup :: UnparsedConfig -> String -> Response
setup config = main (parseConfig config)
