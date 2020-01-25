{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

-- | Data structures pertaining to Discord Embed
module Discord.Internal.Types.Embed where

import Data.Aeson
import Data.Time.Clock
--import Data.Default (Default, def)
import Data.Text (Text)
import qualified Data.Text as T

-- data EmbedSend = EmbedSend
--   { embedSendAuthor      :: Maybe EmbedSendAuthor
--   , embedSendTitle       :: Maybe Text
--   , embedSendUrl         :: Maybe Text
--   , embedSendDescription :: Maybe Text
--   , embedSendFields      :: [EmbedField]
--   , embedSendImage       :: Maybe EmbedSendImage
--   , embedSendFooter      :: Maybe Text
--   , embedSendColor       :: Maybe Text
--   , embedSendTimestamp   :: Maybe Text
--   } deriving (Show, Eq, Ord)
--
-- data CreateEmbedImage = CreateEmbedImageUrl T.Text
--                  {-   | CreateEmbedImageUpload B.Bytestring   -}
--   deriving (Show, Eq, Ord)
--
-- instance ToJSON EmbedSend where
--   toJSON EmbedSend{..} = object
--     [ "title" .= embedSendTitle
--     , "description" .= embedSendDescription
--     ]

--instance Default EmbedSend where
--  def = EmbedSend Nothing Nothing

-- | An embed attached to a message.
data Embed = Embed
  { embedAuthor      :: Maybe EmbedAuthor
  , embedTitle       :: Maybe T.Text     -- ^ Title of the embed
  , embedUrl         :: Maybe T.Text     -- ^ URL of embed
  , embedDescription :: Maybe T.Text     -- ^ Description of embed
  , embedFields      :: [EmbedField]     -- ^ Fields of the embed
  , embedImage       :: Maybe EmbedImage
  , embedFooter      :: Maybe EmbedFooter

  , embedColor       :: Maybe Integer    -- ^ The embed color
  , embedTimestamp   :: Maybe UTCTime    -- ^ The time of the embed content
  , embedType        :: Maybe T.Text     -- ^ Type of embed (Always "rich" for users)
  , embedVideo       :: Maybe EmbedVideo -- ^ Only present for "video" types
  , embedProvider    :: Maybe EmbedProvider -- ^ Only present for "video" types
  } deriving (Show, Eq, Ord)

instance FromJSON Embed where
  parseJSON = withObject "embed" $ \o ->
    Embed <$> o .:? "author"
                 <*> o .:? "title"
                 <*> o .:? "url"
                 <*> o .:? "description"
                 <*> o .:? "fields" .!= []
                 <*> o .:? "image"
                 <*> o .:? "footer"
                 <*> o .:? "color"
                 <*> o .:? "timestamp"
                 <*> o .:? "type"
                 <*> o .:? "video"
                 <*> o .:? "provider"


data EmbedThumbnail = EmbedThumbnail
  { embedThumbnailUrl :: Maybe T.Text
  , embedThumbnailProxyUrl :: Maybe T.Text
  , embedThumbnailHeight :: Maybe Integer
  , embedThumbnailWidth :: Maybe Integer
  } deriving (Show, Eq, Ord)

instance FromJSON EmbedThumbnail where
  parseJSON = withObject "thumbnail" $ \o ->
    EmbedThumbnail <$> o .:? "url"
                   <*> o .:? "proxy_url"
                   <*> o .:? "height"
                   <*> o .:? "width"

data EmbedVideo = EmbedVideo
  { embedVideoUrl :: Maybe T.Text
  , embedVideoHeight :: Maybe Integer
  , embedVideoWidth :: Maybe Integer
  } deriving (Show, Eq, Ord)

instance FromJSON EmbedVideo where
  parseJSON = withObject "video" $ \o ->
    EmbedVideo <$> o .:? "url"
               <*> o .:? "height"
               <*> o .:? "width"

data EmbedImage = EmbedImage
  { embedImageUrl :: Maybe T.Text
  , embedImageProxyUrl :: Maybe T.Text
  , embedImageHeight :: Maybe Integer
  , embedImageWidth :: Maybe Integer
  } deriving (Show, Eq, Ord)

instance FromJSON EmbedImage where
  parseJSON = withObject "image" $ \o ->
    EmbedImage <$> o .:? "url"
               <*> o .:? "proxy_url"
               <*> o .:? "height"
               <*> o .:? "width"

data EmbedProvider = EmbedProvider
  { embedProviderName :: Maybe T.Text
  , embedProviderUrl :: Maybe T.Text
  } deriving (Show, Eq, Ord)

instance FromJSON EmbedProvider where
  parseJSON = withObject "provider" $ \o ->
    EmbedProvider <$> o .:? "name"
                  <*> o .:? "url"

data EmbedAuthor = EmbedAuthor
  { embedAuthorName :: Maybe T.Text
  , embedAuthorUrl :: Maybe T.Text
  , embedAuthorIconUrl :: Maybe T.Text
  , embedAuthorProxyIconUrl :: Maybe T.Text
  } deriving (Show, Eq, Ord)

instance FromJSON EmbedAuthor where
  parseJSON = withObject "author" $ \o ->
    EmbedAuthor <$> o .:? "name"
                <*> o .:? "url"
                <*> o .:? "icon_url"
                <*> o .:? "proxy_icon_url"

data EmbedFooter = EmbedFooter
  { embedFooterText :: T.Text
  , embedFooterIconUrl :: Maybe T.Text
  , embedFooterProxyIconUrl :: Maybe T.Text
  } deriving (Show, Eq, Ord)

instance FromJSON EmbedFooter where
  parseJSON = withObject "footer" $ \o ->
    EmbedFooter <$> o .:  "text"
                <*> o .:  "icon_url"
                <*> o .:? "proxy_icon_url"

data EmbedField = EmbedField
  { embedFieldName :: T.Text
  , embedFieldValue :: T.Text
  , embedFieldInline :: Maybe Bool
  } deriving (Show, Eq, Ord)

instance FromJSON EmbedField where
  parseJSON = withObject "field" $ \o ->
    EmbedField <$> o .:  "name"
               <*> o .:  "value"
               <*> o .:? "inline"
