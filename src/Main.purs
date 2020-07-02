module Main where

import Foreign (Foreign)
import Config.Parser (parse)
import Output (Response, response)

setup :: Foreign -> String -> Response
setup config = response (parse config)
