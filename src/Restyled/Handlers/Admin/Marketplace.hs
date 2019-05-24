{-# LANGUAGE TemplateHaskell #-}

module Restyled.Handlers.Admin.Marketplace
    ( getAdminMarketplaceR
    )
where

import Restyled.Prelude

import Data.List (nub)
import Restyled.Backend.Marketplace (isPrivateRepoPlan)
import Restyled.Foundation
import Restyled.Models
import Restyled.Settings
import Restyled.Yesod

data MarketplacePlanWithAccounts = MarketplacePlanWithAccounts
    { mpwaPlan :: Entity MarketplacePlan
    , mpwaAccounts :: [Entity MarketplaceAccount]
    }

getAdminMarketplaceR :: Handler Html
getAdminMarketplaceR = do
    (pages, noPlanRepoOwners) <- runDB $ do
        plans <- selectPaginated 5 [] [Asc MarketplacePlanGithubId]
        pages <- for plans $ \plan ->
            MarketplacePlanWithAccounts plan <$> selectList
                [MarketplaceAccountMarketplacePlan ==. entityKey plan]
                [Asc MarketplaceAccountGithubId]

        let
            planOwners =
                marketplacePlanWithAccountsOwners $ pageItems $ pagesCurrent
                    pages

        (pages, ) <$> fetchUniqueRepoOwnersExcept planOwners

    adminLayout $ do
        setTitle "Admin - Marketplace"
        $(widgetFile "admin/marketplace")

fetchUniqueRepoOwnersExcept
    :: MonadIO m => [OwnerName] -> SqlPersistT m [OwnerName]
fetchUniqueRepoOwnersExcept exceptOwners = do
    owners <- repoOwner . entityVal <$$> selectList
        [RepoOwner /<-. exceptOwners]
        [Asc RepoOwner]
    pure $ nub owners

marketplacePlanWithAccountsOwners
    :: [MarketplacePlanWithAccounts] -> [OwnerName]
marketplacePlanWithAccountsOwners =
    map (marketplaceAccountGithubOwner . entityVal) . concatMap mpwaAccounts

marketplaceAccountGithubOwner :: MarketplaceAccount -> OwnerName
marketplaceAccountGithubOwner = userToOwnerName . marketplaceAccountGithubLogin

accountsList :: [OwnerName] -> Widget
accountsList owners = $(widgetFile "admin/marketplace/accounts-list")
