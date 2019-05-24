{-# OPTIONS_GHC -fno-warn-orphans #-}

module RIO.Handler
    ( runHandlerRIO
    )
where

import RIO

import RIO.DB
import RIO.Redis
import Yesod (HandlerFor, getYesod)
import Yesod.Core.Types (HandlerData(..), RunHandlerEnv(..))

runHandlerRIO :: RIO env a -> HandlerFor env a
runHandlerRIO f = do
    app <- getYesod
    runRIO app f

instance HasDB env => HasDB (HandlerData child env) where
    dbConnectionPoolL = handlerEnvL . siteL . dbConnectionPoolL

instance HasRedis env => HasRedis (HandlerData child env) where
    redisConnectionL = handlerEnvL . siteL . redisConnectionL

handlerEnvL :: Lens' (HandlerData child site) (RunHandlerEnv child site)
handlerEnvL = lens handlerEnv $ \x y -> x { handlerEnv = y }

siteL :: Lens' (RunHandlerEnv child site) site
siteL = lens rheSite $ \x y -> x { rheSite = y }
