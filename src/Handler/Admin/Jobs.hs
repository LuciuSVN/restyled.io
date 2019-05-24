{-# LANGUAGE TemplateHaskell #-}

-- | List all Jobs in the system
module Handler.Admin.Jobs
    ( getAdminJobsR
    )
where

import Restyled.Prelude

import Foundation
import Models
import Restyled.Yesod
import Settings
import Widgets.Job

getAdminJobsR :: Handler Html
getAdminJobsR = do
    pages <- runDB $ traverse attachJobOutput =<< selectPaginated
        5
        []
        [Desc JobCreatedAt]

    adminLayout $ do
        setTitle "Restyled Admin / Jobs"
        $(widgetFile "jobs")
