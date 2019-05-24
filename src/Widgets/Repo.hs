{-# LANGUAGE TemplateHaskell #-}

module Widgets.Repo
    ( repoCard
    )
where

import Restyled.Prelude

import Formatting (format)
import Formatting.Time (diff)
import Foundation
import Restyled.Models
import Restyled.Routes
import Restyled.Settings
import Widgets.Job

repoCard :: RepoWithStats -> Widget
repoCard RepoWithStats {..} = do
    now <- liftIO getCurrentTime
    $(widgetFile "widgets/repo-card")
