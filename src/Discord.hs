{-# LANGUAGE RankNTypes #-}

module Discord
  ( module Discord.Rest.Requests
  , module Discord.Types
  , Resp(..)
  , RestPart(..)
  , Discord(..)
  , Cache(..)
  , login
  , rest
  , nextEvent
  , cache
  ) where

import System.IO.Unsafe (unsafePerformIO)
import Control.Concurrent.Chan
import Control.Concurrent.MVar
import Data.Map.Strict as M
import Data.Aeson

import Discord.Rest
import Discord.Rest.Requests
import Discord.Types
import Discord.Gateway
import Discord.Gateway.Cache

newtype RestPart = RestPart { restPart :: forall a. FromJSON a => Request a -> IO (Resp a) }

data Discord = Discord
  { _discordRest :: RestChan
  , _discordEvents :: Chan Event
  , _discordCache :: MVar Cache
  }

rest :: FromJSON a => Discord -> Request a -> IO (Resp a)
rest d = writeRestCall (_discordRest d)

nextEvent :: Discord -> IO Event
nextEvent d = readChan (_discordEvents d)

cache :: Discord -> IO Cache
cache d = readMVar (_discordCache d)

login :: Auth -> IO Discord
login auth = do
  logins <- takeMVar discordLogins
  case M.lookup auth logins of
    Just d -> putMVar discordLogins logins >> pure d
    Nothing -> do
      restHandler <- createHandler auth
      (chan,info) <- chanWebSocket auth
      let nextDisc = Discord restHandler chan info
      putMVar discordLogins (M.insert auth nextDisc logins)
      pure nextDisc


discordLogins :: MVar (M.Map Auth Discord)
discordLogins = unsafePerformIO (newMVar M.empty)
{-# NOINLINE discordLogins #-}