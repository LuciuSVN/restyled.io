module Widgets.JobLogLine
    ( renderJobLogLine
    )
where

import Restyled.Prelude

import qualified Data.Text.Lazy as LT
import Foundation
import Restyled.Models
import Restyled.Yesod
import Text.Blaze.Html.Renderer.Text (renderHtml)
import Widgets.Job

renderJobLogLine :: Entity JobLogLine -> Handler LT.Text
renderJobLogLine logLine = do
    pc <- widgetToPageContent $ colorizedJobLogLine logLine
    renderHtml <$> withUrlRenderer (pageBody pc)
