{-# OPTIONS_GHC -fno-warn-orphans #-}

{-# LANGUAGE PackageImports #-}

module Benchmark.HtomlMegaparsec
       ( decode
       , parse
       , convert
       ) where

import Data.Aeson.Types (ToJSON, parseEither, parseJSON, toJSON)
import Data.Semigroup ((<>))
import Data.Text (Text)

import "htoml-megaparsec" Text.Toml (Node (..), Table, TomlError, parseTomlDoc)

import Benchmark.Type (HaskellType)


-- | Decode toml file to Haskell type.
decode :: Text -> Either String HaskellType
decode txt = case parseTomlDoc "log" txt of
    Left err   -> error $ "'htoml-megaparsec' parsing failed: " <> show err
    Right toml -> convert toml

-- | Wrapper on htoml-megaparsec's parseTomlDoc
parse :: Text -> Either TomlError Table
parse = parseTomlDoc "log"

-- | Convert from already parsed toml to Haskell type.
convert :: Table -> Either String HaskellType
convert = parseEither parseJSON . toJSON

-- | 'ToJSON' instances for the 'Node' type that produce Aeson (JSON)
-- in line with the TOML specification.
instance ToJSON Node where
    toJSON (VTable v)    = toJSON v
    toJSON (VTArray v)   = toJSON v
    toJSON (VString v)   = toJSON v
    toJSON (VInteger v)  = toJSON v
    toJSON (VFloat v)    = toJSON v
    toJSON (VBoolean v)  = toJSON v
    toJSON (VDatetime v) = toJSON v
    toJSON (VArray v)    = toJSON v
