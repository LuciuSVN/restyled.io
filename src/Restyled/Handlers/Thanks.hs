{-# LANGUAGE TemplateHaskell #-}

module Handler.Thanks
    ( getThanksGitHubR
    , getThanksGitHubSetupR
    )
where

import Restyled.Prelude

import Foundation
import Restyled.Yesod
import Restyled.Settings

-- brittany-disable-next-binding

getThanksGitHubR :: Handler Html
getThanksGitHubR = defaultLayout $ do
    setTitle "Thanks"
    $(widgetFile "thanks/github")

getThanksGitHubSetupR :: Handler ()
getThanksGitHubSetupR = do
    setUltDest ThanksGitHubR
    redirect $ AuthR $ oauth2Url "github"
