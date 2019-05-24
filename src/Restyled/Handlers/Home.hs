{-# LANGUAGE TemplateHaskell #-}

module Restyled.Handlers.Home
    ( getHomeR
    )
where

import Restyled.Prelude

import Foundation
import Restyled.Yesod
import Restyled.Settings

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    setTitle "Restyled"
    $(widgetFile "homepage")
