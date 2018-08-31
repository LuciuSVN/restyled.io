{-# OPTIONS_GHC -fno-warn-orphans #-}

module SVCS.Names
    ( OwnerName
    , mkOwnerName
    , RepoName
    , mkRepoName
    , InstallationId
    , PullRequestNum
    , mkPullRequestNum
    , GitHubUserId
    , GitHubUserName
    , RepoAccessToken(..)
    , RepoSVCS(..)
    ) where

import Prelude

import Data.Proxy
import Data.Text (Text)
import Database.Persist.Sql
import GitHub.Data
import GitHub.Data.Apps
import Text.Blaze (ToMarkup(..))
import Text.Read
import Yesod.Core (PathPiece(..))

type OwnerName = Name Owner
type RepoName = Name Repo
type InstallationId = Id Installation

type PullRequestNum = Id PullRequest

mkPullRequestNum :: Int -> PullRequestNum
mkPullRequestNum = mkId Proxy

type GitHubUserId = Id User
type GitHubUserName = Name User

newtype RepoAccessToken = RepoAccessToken { unRepoAccessToken :: Text }

data RepoSVCS = GitHubSVCS
    deriving Eq

instance Show RepoSVCS where
    show GitHubSVCS = "GitHub"

instance Read (Id a) where
    readPrec = mkId Proxy <$> readPrec

instance PathPiece (Id a) where
    toPathPiece = toPathPiece . untagId
    fromPathPiece = (mkId Proxy <$>) . fromPathPiece

instance PersistField (Id a) where
    toPersistValue = toPersistValue . untagId
    fromPersistValue = (mkId Proxy <$>) . fromPersistValue

instance PersistFieldSql (Id a) where
    sqlType _ = sqlType (Proxy :: Proxy Int)

instance ToMarkup (Id a) where
    toMarkup = toMarkup . untagId

instance Read (Name a) where
    readsPrec n = map (\(x, s) -> (mkName Proxy x, s)) . readsPrec n

instance PathPiece (Name  a) where
    toPathPiece = toPathPiece . untagName
    fromPathPiece = (mkName Proxy <$>) . fromPathPiece

instance PersistField (Name a) where
    toPersistValue = toPersistValue . untagName
    fromPersistValue = (mkName Proxy <$>) . fromPersistValue

instance PersistFieldSql (Name a) where
    sqlType _ = sqlType (Proxy :: Proxy Text)

instance ToMarkup (Name a) where
    toMarkup = toMarkup . untagName

instance Num (Id a) where
    fromInteger = mkId Proxy . fromInteger

    (+) = errSneakyNum
    (-) = errSneakyNum
    (*) = errSneakyNum
    abs = errSneakyNum
    signum = errSneakyNum

errSneakyNum :: a
errSneakyNum = error "Num instance only present for `fromInteger'"