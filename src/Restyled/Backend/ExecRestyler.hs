-- | Execution of the Restyler process
module Restyled.Backend.ExecRestyler
    ( ExecRestyler(..)
    , tryExecRestyler
    )
where

import Restyled.Backend.Import

import Restyled.Backend.AcceptedJob

-- | Execution of the Restyler process
--
-- TODO: try not to need @'Entity'@s, try not to need @'Repo'@.
--
newtype ExecRestyler m = ExecRestyler
    { unExecRestyler :: Entity Repo -> Entity Job -> m ExitCode
    }

-- | Run the @'ExecRestyler'@ and capture exceptions to @'ExceptT'@
tryExecRestyler
    :: MonadUnliftIO m
    => ExecRestyler m
    -> AcceptedJob
    -> ExceptT SomeException m ExitCode
tryExecRestyler (ExecRestyler execRestyler) AcceptedJob {..} =
    ExceptT $ tryAny $ execRestyler ajRepo ajJob
