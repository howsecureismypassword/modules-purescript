module Test.Data where

-- tested modules
import Config.Parser (parse)
import Config.Types (Config)
import Foreign (Foreign)

-- dictionaries
foreign import configF :: Foreign

config :: Config
config = parse configF
