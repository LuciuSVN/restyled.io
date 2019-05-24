module Restyled.Handlers.Admin
    ( getAdminR
    )
where

import Restyled.Prelude

import Foundation
import Restyled.Yesod

getAdminR :: Handler Html
getAdminR = redirect $ AdminP $ AdminJobsP AdminJobsR
