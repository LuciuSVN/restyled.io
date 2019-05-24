module Handler.PrivacyPolicy
    ( getPrivacyPolicyR
    )
where

import Restyled.Prelude

import Foundation
import Restyled.Yesod

getPrivacyPolicyR :: Handler Html
getPrivacyPolicyR = redirect @_ @Text
    "https://github.com/restyled-io/restyled.io/wiki/Privacy-Policy"
