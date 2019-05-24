{-# LANGUAGE TemplateHaskell #-}

module Handler.Home
    ( getHomeR
    )
where

import Restyled.Prelude

import Foundation
import Restyled.Yesod
import Settings

getHomeR :: Handler Html
getHomeR = defaultLayout $ do
    setTitle "Restyled"
    $(widgetFile "homepage")
