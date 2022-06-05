{- HLINT ignore "Unused LANGUAGE pragma" -}
{-# LANGUAGE TypeApplications #-}
-- This template expects CPP definitions for:
--     MODULE_NAME = Posix | Windows
--     IS_WINDOWS  = False | True

module System.OsString.MODULE_NAME
  (
  -- * Types
#ifdef WINDOWS
    WindowsString
  , WindowsChar
#else
    PosixString
  , PosixChar
#endif

  -- * String construction
  , toPlatformString
  , toPlatformStringEnc
  , toPlatformStringIO
  , bsToPlatformString
  , pstr
  , packPlatformString

  -- * String deconstruction
  , fromPlatformString
  , fromPlatformStringEnc
  , fromPlatformStringIO
  , unpackPlatformString

  -- * Word construction
  , unsafeFromChar

  -- * Word deconstruction
  , toChar
  )
where



import System.AbstractFilePath.Data.ByteString.Short.Encode
  (
#ifdef WINDOWS
    encodeUtf16LE
#else
    encodeUtf8
#endif
  )
import System.AbstractFilePath.Data.ByteString.Short.Decode
    (
      UnicodeException (..)
    )
import System.OsString.Internal.Types (
#ifdef WINDOWS
  WindowsString(..), WindowsChar(..)
#else
  PosixString(..), PosixChar(..)
#endif
  )

import Data.Char
import Control.Monad.Catch
    ( MonadThrow, throwM )
import Data.ByteString.Internal
    ( ByteString )
import Control.Exception
    ( SomeException, try, displayException )
import Control.DeepSeq ( force )
import Data.Bifunctor ( first )
import GHC.IO
    ( evaluate, unsafePerformIO )
import qualified GHC.Foreign as GHC
import System.IO
    ( TextEncoding )
import Language.Haskell.TH
import Language.Haskell.TH.Quote
    ( QuasiQuoter (..) )
import Language.Haskell.TH.Syntax
    ( Lift (..), lift )


#ifdef WINDOWS
import System.IO
    ( utf16le )
import System.AbstractFilePath.Data.ByteString.Short.Word16 as BS
import qualified System.AbstractFilePath.Data.ByteString.Short as BS8
#else
import System.IO
    ( utf8 )
import System.AbstractFilePath.Data.ByteString.Short as BS
import GHC.IO.Encoding
    ( getFileSystemEncoding )
#endif



-- | Total Unicode-friendly encoding.
--
-- On windows this encodes as UTF16, which is expected.
-- On unix this encodes as UTF8, which is a good guess.
toPlatformString :: String -> PLATFORM_STRING
toPlatformString str = unsafePerformIO $ do
#ifdef WINDOWS
  GHC.withCStringLen utf16le str $ \cstr -> WS <$> BS8.packCStringLen cstr
#else
  GHC.withCStringLen utf8 str $ \cstr -> PS <$> BS.packCStringLen cstr
#endif

-- | Like 'toPlatformString', except allows to provide an encoding.
toPlatformStringEnc :: String
                    -> TextEncoding
                    -> Either UnicodeException PLATFORM_STRING
toPlatformStringEnc str enc = unsafePerformIO $ do
#ifdef WINDOWS
  r <- try @SomeException $ GHC.withCStringLen enc str $ \cstr -> WS <$> BS8.packCStringLen cstr
  evaluate $ force $ first (flip DecodeError Nothing . displayException) r
#else
  r <- try @SomeException $ GHC.withCStringLen enc str $ \cstr -> PS <$> BS.packCStringLen cstr
  evaluate $ force $ first (flip DecodeError Nothing . displayException) r
#endif

-- | Like 'toPlatformString', except on unix this uses the current
-- locale for encoding instead of always UTF8.
--
-- Looking up the locale requires IO. If you're not worried about calls
-- to 'setFileSystemEncoding', then 'unsafePerformIO' may be feasible.
toPlatformStringIO :: String -> IO PLATFORM_STRING
#ifdef WINDOWS
toPlatformStringIO str = GHC.withCStringLen utf16le str $ \cstr -> WS <$> BS8.packCStringLen cstr
#else
toPlatformStringIO str = do
  enc <- getFileSystemEncoding
  GHC.withCStringLen enc str $ \cstr -> PS <$> BS.packCStringLen cstr
#endif


-- | Partial unicode friendly decoding.
--
-- On windows this decodes as UTF16 (which is the expected filename encoding).
-- On unix this decodes as UTF8 (which is a good guess). Note that
-- filenames on unix are encoding agnostic char arrays.
--
-- Throws a 'UnicodeException' if decoding fails.
fromPlatformString :: MonadThrow m => PLATFORM_STRING -> m String
#ifdef WINDOWS
fromPlatformString ps = either throwM pure (fromPlatformStringEnc ps utf16le)
#else
fromPlatformString ps = either throwM pure (fromPlatformStringEnc ps utf8)
#endif

-- | Like 'fromPlatformString', except allows to provide a text encoding.
--
-- The String is forced into memory to catch all exceptions.
fromPlatformStringEnc :: PLATFORM_STRING
                      -> TextEncoding
                      -> Either UnicodeException String
#ifdef WINDOWS
fromPlatformStringEnc (WS ba) winEnc = unsafePerformIO $ do
  r <- try @SomeException $ BS8.useAsCStringLen ba $ \fp -> GHC.peekCStringLen winEnc fp
  evaluate $ force $ first (flip DecodeError Nothing . displayException) r
#else
fromPlatformStringEnc (PS ba) unixEnc = unsafePerformIO $ do
  r <- try @SomeException $ BS.useAsCStringLen ba $ \fp -> GHC.peekCStringLen unixEnc fp
  evaluate $ force $ first (flip DecodeError Nothing . displayException) r
#endif


-- | Like 'fromPlatformString', except on unix this uses the current
-- locale for decoding instead of always UTF8. On windows, uses UTF-16LE.
--
-- Looking up the locale requires IO. If you're not worried about calls
-- to 'setFileSystemEncoding', then 'unsafePerformIO' may be feasible.
--
-- Throws 'UnicodeException' if decoding fails.
fromPlatformStringIO :: PLATFORM_STRING -> IO String
#ifdef WINDOWS
fromPlatformStringIO (WS ba) =
  BS8.useAsCStringLen ba $ \fp -> GHC.peekCStringLen utf16le fp
#else
fromPlatformStringIO (PS ba) = do
  enc <- getFileSystemEncoding
  BS.useAsCStringLen ba $ \fp -> GHC.peekCStringLen enc fp
#endif


-- | Constructs an platform string from a ByteString.
--
-- On windows, this ensures valid UTF16, on unix it is passed unchanged/unchecked.
--
-- Throws 'UnicodeException' on invalid UTF16 on windows.
bsToPlatformString :: MonadThrow m
             => ByteString
             -> m PLATFORM_STRING
#ifdef WINDOWS
bsToPlatformString bs =
  let ws = WS . toShort $ bs
  in either throwM (const . pure $ ws) $ fromPlatformStringEnc ws utf16le
#else
bsToPlatformString = pure . PS . toShort
#endif


qq :: (ByteString -> Q Exp) -> QuasiQuoter
qq quoteExp' =
  QuasiQuoter
#ifdef WINDOWS
  { quoteExp  = quoteExp' . fromShort . encodeUtf16LE
  , quotePat  = \_ ->
      fail "illegal QuasiQuote (allowed as expression only, used as a pattern)"
  , quoteType = \_ ->
      fail "illegal QuasiQuote (allowed as expression only, used as a type)"
  , quoteDec  = \_ ->
      fail "illegal QuasiQuote (allowed as expression only, used as a declaration)"
  }
#else
  { quoteExp  = quoteExp' . fromShort . encodeUtf8
  , quotePat  = \_ ->
      fail "illegal QuasiQuote (allowed as expression only, used as a pattern)"
  , quoteType = \_ ->
      fail "illegal QuasiQuote (allowed as expression only, used as a type)"
  , quoteDec  = \_ ->
      fail "illegal QuasiQuote (allowed as expression only, used as a declaration)"
  }
#endif

mkPlatformString :: ByteString -> Q Exp
mkPlatformString bs = 
  case bsToPlatformString bs of
    Just afp -> lift afp
    Nothing -> error "invalid encoding"

#ifdef WINDOWS
-- | QuasiQuote a 'WindowsString'. This accepts Unicode characters
-- and encodes as UTF-16 on windows.
#else
-- | QuasiQuote a 'PosixString'. This accepts Unicode characters
-- and encodes as UTF-8 on unix.
#endif
pstr :: QuasiQuoter
pstr = qq mkPlatformString


unpackPlatformString :: PLATFORM_STRING -> [PLATFORM_WORD]
#ifdef WINDOWS
unpackPlatformString (WS ba) = WW <$> BS.unpack ba
#else
unpackPlatformString (PS ba) = PW <$> BS.unpack ba
#endif


packPlatformString :: [PLATFORM_WORD] -> PLATFORM_STRING
#ifdef WINDOWS
packPlatformString = WS . BS.pack . fmap (\(WW w) -> w)
#else
packPlatformString = PS . BS.pack . fmap (\(PW w) -> w)
#endif


#ifdef WINDOWS
-- | Truncates to 2 octets.
unsafeFromChar :: Char -> PLATFORM_WORD
unsafeFromChar = WW . fromIntegral . fromEnum
#else
-- | Truncates to 1 octet.
unsafeFromChar :: Char -> PLATFORM_WORD
unsafeFromChar = PW . fromIntegral . fromEnum
#endif

-- | Converts back to a unicode codepoint (total).
toChar :: PLATFORM_WORD -> Char
#ifdef WINDOWS
toChar (WW w) = chr $ fromIntegral w
#else
toChar (PW w) = chr $ fromIntegral w
#endif
