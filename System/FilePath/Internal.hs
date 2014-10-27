#if __GLASGOW_HASKELL__ >= 704
{-# LANGUAGE Safe #-}
#endif

-- This template expects CPP definitions for:
--     MODULE_NAME = Posix | Windows
--     IS_WINDOWS  = False | True

-- |
-- Module      :  System.FilePath.MODULE_NAME
-- Copyright   :  (c) Neil Mitchell 2005-2014
-- License     :  BSD3
--
-- Maintainer  :  ndmitchell@gmail.com
-- Stability   :  stable
-- Portability :  portable
--
-- A library for FilePath manipulations, using MODULE_NAME style paths on
-- all platforms. Importing "System.FilePath" is usually better.
--
-- Some short examples:
--
-- You are given a C file, you want to figure out the corresponding object (.o) file:
--
-- @'replaceExtension' file \"o\"@
--
-- Haskell module Main imports Test, you have the file named main:
--
-- @['replaceFileName' path_to_main \"Test\" '<.>' ext | ext <- [\"hs\",\"lhs\"] ]@
--
-- You want to download a file from the web and save it to disk:
--
-- @do let file = 'makeValid' url
--   System.IO.createDirectoryIfMissing True ('takeDirectory' file)@
--
-- You want to compile a Haskell file, but put the hi file under \"interface\"
--
-- @'takeDirectory' file '</>' \"interface\" '</>' ('takeFileName' file \`replaceExtension\` \"hi\"@)
--
-- The examples in code format descibed by each function are used to generate
-- tests, and should give clear semantics for the functions.
--
-- References:
-- [1] "Naming Files, Paths, and Namespaces"
-- http://msdn.microsoft.com/en-us/library/windows/desktop/aa365247.aspx
-----------------------------------------------------------------------------

module System.FilePath.MODULE_NAME
    (
    -- * Separator predicates
    FilePath,
    pathSeparator, pathSeparators, isPathSeparator,
    searchPathSeparator, isSearchPathSeparator,
    extSeparator, isExtSeparator,

    -- * Path methods (environment $PATH)
    splitSearchPath, getSearchPath,

    -- * Extension methods
    splitExtension,
    takeExtension, replaceExtension, dropExtension, addExtension, hasExtension, (<.>),
    splitExtensions, dropExtensions, takeExtensions,

    -- * Drive methods
    splitDrive, joinDrive,
    takeDrive, hasDrive, dropDrive, isDrive,

    -- * Operations on a FilePath, as a list of directories
    splitFileName,
    takeFileName, replaceFileName, dropFileName,
    takeBaseName, replaceBaseName,
    takeDirectory, replaceDirectory,
    combine, (</>),
    splitPath, joinPath, splitDirectories,

    -- * Low level FilePath operators
    hasTrailingPathSeparator,
    addTrailingPathSeparator,
    dropTrailingPathSeparator,

    -- * File name manipulators
    normalise, equalFilePath,
    makeRelative,
    isRelative, isAbsolute,
    isValid, makeValid
    )
    where

import Data.Char(toLower, toUpper, isAsciiLower, isAsciiUpper)
import Data.Maybe(isJust, fromJust)

import System.Environment(getEnv)


infixr 7  <.>
infixr 5  </>





---------------------------------------------------------------------
-- Platform Abstraction Methods (private)

-- | Is the operating system Unix or Linux like
isPosix :: Bool
isPosix = not isWindows

-- | Is the operating system Windows like
isWindows :: Bool
isWindows = IS_WINDOWS


---------------------------------------------------------------------
-- The basic functions

-- | The character that separates directories. In the case where more than
--   one character is possible, 'pathSeparator' is the \'ideal\' one.
--
-- > Windows: pathSeparator == '\\'
-- > Posix:   pathSeparator ==  '/'
-- > isPathSeparator pathSeparator
pathSeparator :: Char
pathSeparator = if isWindows then '\\' else '/'

-- | The list of all possible separators.
--
-- > Windows: pathSeparators == ['\\', '/']
-- > Posix:   pathSeparators == ['/']
-- > pathSeparator `elem` pathSeparators
pathSeparators :: [Char]
pathSeparators = if isWindows then "\\/" else "/"

-- | Rather than using @(== 'pathSeparator')@, use this. Test if something
--   is a path separator.
--
-- > isPathSeparator a == (a `elem` pathSeparators)
isPathSeparator :: Char -> Bool
isPathSeparator = (`elem` pathSeparators)


-- | The character that is used to separate the entries in the $PATH environment variable.
--
-- > Windows: searchPathSeparator == ';'
-- > Posix:   searchPathSeparator == ':'
searchPathSeparator :: Char
searchPathSeparator = if isWindows then ';' else ':'

-- | Is the character a file separator?
--
-- > isSearchPathSeparator a == (a == searchPathSeparator)
isSearchPathSeparator :: Char -> Bool
isSearchPathSeparator = (== searchPathSeparator)


-- | File extension character
--
-- > extSeparator == '.'
extSeparator :: Char
extSeparator = '.'

-- | Is the character an extension character?
--
-- > isExtSeparator a == (a == extSeparator)
isExtSeparator :: Char -> Bool
isExtSeparator = (== extSeparator)




---------------------------------------------------------------------
-- Path methods (environment $PATH)

-- | Take a string, split it on the 'searchPathSeparator' character.
--
--   Follows the recommendations in
--   <http://www.opengroup.org/onlinepubs/009695399/basedefs/xbd_chap08.html>
--
-- > Posix:   splitSearchPath "File1:File2:File3"  == ["File1","File2","File3"]
-- > Posix:   splitSearchPath "File1::File2:File3" == ["File1",".","File2","File3"]
-- > Windows: splitSearchPath "File1;File2;File3"  == ["File1","File2","File3"]
-- > Windows: splitSearchPath "File1;;File2;File3" == ["File1","File2","File3"]
splitSearchPath :: String -> [FilePath]
splitSearchPath = f
    where
    f xs = case break isSearchPathSeparator xs of
           (pre, []    ) -> g pre
           (pre, _:post) -> g pre ++ f post

    g "" = ["." | isPosix]
    g x = [x]


-- | Get a list of filepaths in the $PATH.
getSearchPath :: IO [FilePath]
getSearchPath = fmap splitSearchPath (getEnv "PATH")


---------------------------------------------------------------------
-- Extension methods

-- | Split on the extension. 'addExtension' is the inverse.
--
-- > uncurry (++) (splitExtension x) == x
-- > uncurry addExtension (splitExtension x) == x
-- > splitExtension "file.txt" == ("file",".txt")
-- > splitExtension "file" == ("file","")
-- > splitExtension "file/file.txt" == ("file/file",".txt")
-- > splitExtension "file.txt/boris" == ("file.txt/boris","")
-- > splitExtension "file.txt/boris.ext" == ("file.txt/boris",".ext")
-- > splitExtension "file/path.txt.bob.fred" == ("file/path.txt.bob",".fred")
-- > splitExtension "file/path.txt/" == ("file/path.txt/","")
splitExtension :: FilePath -> (String, String)
splitExtension x = case d of
                       "" -> (x,"")
                       (y:ys) -> (a ++ reverse ys, y : reverse c)
    where
        (a,b) = splitFileName_ x
        (c,d) = break isExtSeparator $ reverse b

-- | Get the extension of a file, returns @\"\"@ for no extension, @.ext@ otherwise.
--
-- > takeExtension x == snd (splitExtension x)
-- > Valid x => takeExtension (addExtension x "ext") == ".ext"
-- > Valid x => takeExtension (replaceExtension x "ext") == ".ext"
takeExtension :: FilePath -> String
takeExtension = snd . splitExtension

-- | Set the extension of a file, overwriting one if already present.
--
-- > replaceExtension "file.txt" ".bob" == "file.bob"
-- > replaceExtension "file.txt" "bob" == "file.bob"
-- > replaceExtension "file" ".bob" == "file.bob"
-- > replaceExtension "file.txt" "" == "file"
-- > replaceExtension "file.fred.bob" "txt" == "file.fred.txt"
replaceExtension :: FilePath -> String -> FilePath
replaceExtension x y = dropExtension x <.> y

-- | Alias to 'addExtension', for people who like that sort of thing.
(<.>) :: FilePath -> String -> FilePath
(<.>) = addExtension

-- | Remove last extension, and the \".\" preceding it.
--
-- > dropExtension x == fst (splitExtension x)
dropExtension :: FilePath -> FilePath
dropExtension = fst . splitExtension

-- | Add an extension, even if there is already one there.
--   E.g. @addExtension \"foo.txt\" \"bat\" -> \"foo.txt.bat\"@.
--
-- > addExtension "file.txt" "bib" == "file.txt.bib"
-- > addExtension "file." ".bib" == "file..bib"
-- > addExtension "file" ".bib" == "file.bib"
-- > addExtension "/" "x" == "/.x"
-- > Valid x => takeFileName (addExtension (addTrailingPathSeparator x) "ext") == ".ext"
-- > Windows: addExtension "\\\\share" ".txt" == "\\\\share\\.txt"
addExtension :: FilePath -> String -> FilePath
addExtension file "" = file
addExtension file xs@(x:_) = joinDrive a res
    where
        res = if isExtSeparator x then b ++ xs
              else b ++ [extSeparator] ++ xs

        (a,b) = splitDrive file

-- | Does the given filename have an extension?
--
-- > null (takeExtension x) == not (hasExtension x)
hasExtension :: FilePath -> Bool
hasExtension = any isExtSeparator . takeFileName


-- | Split on all extensions
--
-- > uncurry (++) (splitExtensions x) == x
-- > uncurry addExtension (splitExtensions x) == x
-- > splitExtensions "file.tar.gz" == ("file",".tar.gz")
splitExtensions :: FilePath -> (FilePath, String)
splitExtensions x = (a ++ c, d)
    where
        (a,b) = splitFileName_ x
        (c,d) = break isExtSeparator b

-- | Drop all extensions
--
-- > not $ hasExtension (dropExtensions x)
dropExtensions :: FilePath -> FilePath
dropExtensions = fst . splitExtensions

-- | Get all extensions
--
-- > takeExtensions "file.tar.gz" == ".tar.gz"
takeExtensions :: FilePath -> String
takeExtensions = snd . splitExtensions



---------------------------------------------------------------------
-- Drive methods

-- | Is the given character a valid drive letter?
-- only a-z and A-Z are letters, not isAlpha which is more unicodey
isLetter :: Char -> Bool
isLetter x = isAsciiLower x || isAsciiUpper x


-- | Split a path into a drive and a path.
--   On Unix, \/ is a Drive.
--
-- > uncurry (++) (splitDrive x) == x
-- > Windows: splitDrive "file" == ("","file")
-- > Windows: splitDrive "c:/file" == ("c:/","file")
-- > Windows: splitDrive "c:\\file" == ("c:\\","file")
-- > Windows: splitDrive "\\\\shared\\test" == ("\\\\shared\\","test")
-- > Windows: splitDrive "\\\\shared" == ("\\\\shared","")
-- > Windows: splitDrive "\\\\?\\UNC\\shared\\file" == ("\\\\?\\UNC\\shared\\","file")
-- > Windows: splitDrive "\\\\?\\UNCshared\\file" == ("\\\\?\\","UNCshared\\file")
-- > Windows: splitDrive "\\\\?\\d:\\file" == ("\\\\?\\d:\\","file")
-- > Windows: splitDrive "/d" == ("","/d")
-- > Posix:   splitDrive "/test" == ("/","test")
-- > Posix:   splitDrive "//test" == ("//","test")
-- > Posix:   splitDrive "test/file" == ("","test/file")
-- > Posix:   splitDrive "file" == ("","file")
splitDrive :: FilePath -> (FilePath, FilePath)
splitDrive x | isPosix = span (== '/') x

splitDrive x | isJust y = fromJust y
    where y = readDriveLetter x

splitDrive x | isJust y = fromJust y
    where y = readDriveUNC x

splitDrive x | isJust y = fromJust y
    where y = readDriveShare x

splitDrive x = ("",x)

addSlash :: FilePath -> FilePath -> (FilePath, FilePath)
addSlash a xs = (a++c,d)
    where (c,d) = span isPathSeparator xs

-- See [1].
-- "\\?\D:\<path>" or "\\?\UNC\<server>\<share>"
readDriveUNC :: FilePath -> Maybe (FilePath, FilePath)
readDriveUNC (s1:s2:'?':s3:xs) | all isPathSeparator [s1,s2,s3] =
    case map toUpper xs of
        ('U':'N':'C':s4:_) | isPathSeparator s4 ->
            let (a,b) = readDriveShareName (drop 4 xs)
            in Just (s1:s2:'?':s3:take 4 xs ++ a, b)
        _ -> case readDriveLetter xs of
                 -- Extended-length path.
                 Just (a,b) -> Just (s1:s2:'?':s3:a,b)
                 Nothing -> Nothing
readDriveUNC _ = Nothing

{- c:\ -}
readDriveLetter :: String -> Maybe (FilePath, FilePath)
readDriveLetter (x:':':y:xs) | isLetter x && isPathSeparator y = Just $ addSlash [x,':'] (y:xs)
readDriveLetter (x:':':xs) | isLetter x = Just ([x,':'], xs)
readDriveLetter _ = Nothing

{- \\sharename\ -}
readDriveShare :: String -> Maybe (FilePath, FilePath)
readDriveShare (s1:s2:xs) | isPathSeparator s1 && isPathSeparator s2 =
        Just (s1:s2:a,b)
    where (a,b) = readDriveShareName xs
readDriveShare _ = Nothing

{- assume you have already seen \\ -}
{- share\bob -> "share\", "bob" -}
readDriveShareName :: String -> (FilePath, FilePath)
readDriveShareName name = addSlash a b
    where (a,b) = break isPathSeparator name



-- | Join a drive and the rest of the path.
--
-- >          uncurry joinDrive (splitDrive x) == x
-- > Windows: joinDrive "C:" "foo" == "C:foo"
-- > Windows: joinDrive "C:\\" "bar" == "C:\\bar"
-- > Windows: joinDrive "\\\\share" "foo" == "\\\\share\\foo"
-- > Windows: joinDrive "/:" "foo" == "/:\\foo"
joinDrive :: FilePath -> FilePath -> FilePath
joinDrive = combineAlways

-- | Get the drive from a filepath.
--
-- > takeDrive x == fst (splitDrive x)
takeDrive :: FilePath -> FilePath
takeDrive = fst . splitDrive

-- | Delete the drive, if it exists.
--
-- > dropDrive x == snd (splitDrive x)
dropDrive :: FilePath -> FilePath
dropDrive = snd . splitDrive

-- | Does a path have a drive.
--
-- > not (hasDrive x) == null (takeDrive x)
-- > Posix:   hasDrive "/foo" == True
-- > Windows: hasDrive "C:\\foo" == True
-- > Windows: hasDrive "C:foo" == True
-- >          hasDrive "foo" == False
-- >          hasDrive "" == False
hasDrive :: FilePath -> Bool
hasDrive = not . null . takeDrive


-- | Is an element a drive
--
-- > Posix:   isDrive "/" == True
-- > Posix:   isDrive "/foo" == False
-- > Windows: isDrive "C:\\" == True
-- > Windows: isDrive "C:\\foo" == False
-- >          isDrive "" == False
isDrive :: FilePath -> Bool
isDrive x = not (null x) && null (dropDrive x)


---------------------------------------------------------------------
-- Operations on a filepath, as a list of directories

-- | Split a filename into directory and file. 'combine' is the inverse.
--
-- > Valid x => uncurry (</>) (splitFileName x) == x || fst (splitFileName x) == "./"
-- > Posix:   Valid x => isValid (fst (splitFileName x))
-- > splitFileName "file/bob.txt" == ("file/", "bob.txt")
-- > splitFileName "file/" == ("file/", "")
-- > splitFileName "bob" == ("./", "bob")
-- > Posix:   splitFileName "/" == ("/","")
-- > Windows: splitFileName "c:" == ("c:","")
splitFileName :: FilePath -> (String, String)
splitFileName x = (if null dir then "./" else dir, name)
    where
        (dir, name) = splitFileName_ x

-- version of splitFileName where, if the FilePath has no directory
-- component, the returned directory is "" rather than "./".  This
-- is used in cases where we are going to combine the returned
-- directory to make a valid FilePath, and having a "./" appear would
-- look strange and upset simple equality properties.  See
-- e.g. replaceFileName.
splitFileName_ :: FilePath -> (String, String)
splitFileName_ x = (c ++ reverse b, reverse a)
    where
        (a,b) = break isPathSeparator $ reverse d
        (c,d) = splitDrive x

-- | Set the filename.
--
-- > Valid x => replaceFileName x (takeFileName x) == x
replaceFileName :: FilePath -> String -> FilePath
replaceFileName x y = a </> y where (a,_) = splitFileName_ x

-- | Drop the filename.
--
-- > dropFileName x == fst (splitFileName x)
dropFileName :: FilePath -> FilePath
dropFileName = fst . splitFileName


-- | Get the file name.
--
-- > takeFileName "test/" == ""
-- > takeFileName x `isSuffixOf` x
-- > takeFileName x == snd (splitFileName x)
-- > Valid x => takeFileName (replaceFileName x "fred") == "fred"
-- > Valid x => takeFileName (x </> "fred") == "fred"
-- > Valid x => isRelative (takeFileName x)
takeFileName :: FilePath -> FilePath
takeFileName = snd . splitFileName

-- | Get the base name, without an extension or path.
--
-- > takeBaseName "file/test.txt" == "test"
-- > takeBaseName "dave.ext" == "dave"
-- > takeBaseName "" == ""
-- > takeBaseName "test" == "test"
-- > takeBaseName (addTrailingPathSeparator x) == ""
-- > takeBaseName "file/file.tar.gz" == "file.tar"
takeBaseName :: FilePath -> String
takeBaseName = dropExtension . takeFileName

-- | Set the base name.
--
-- > replaceBaseName "file/test.txt" "bob" == "file/bob.txt"
-- > replaceBaseName "fred" "bill" == "bill"
-- > replaceBaseName "/dave/fred/bob.gz.tar" "new" == "/dave/fred/new.tar"
-- > Valid x => replaceBaseName x (takeBaseName x) == x
replaceBaseName :: FilePath -> String -> FilePath
replaceBaseName pth nam = combineAlways a (nam <.> ext)
    where
        (a,b) = splitFileName_ pth
        ext = takeExtension b

-- | Is an item either a directory or the last character a path separator?
--
-- > hasTrailingPathSeparator "test" == False
-- > hasTrailingPathSeparator "test/" == True
hasTrailingPathSeparator :: FilePath -> Bool
hasTrailingPathSeparator "" = False
hasTrailingPathSeparator x = isPathSeparator (last x)


hasLeadingPathSeparator :: FilePath -> Bool
hasLeadingPathSeparator "" = False
hasLeadingPathSeparator x = isPathSeparator (head x)


-- | Add a trailing file path separator if one is not already present.
--
-- > hasTrailingPathSeparator (addTrailingPathSeparator x)
-- > hasTrailingPathSeparator x ==> addTrailingPathSeparator x == x
-- > Posix:    addTrailingPathSeparator "test/rest" == "test/rest/"
addTrailingPathSeparator :: FilePath -> FilePath
addTrailingPathSeparator x = if hasTrailingPathSeparator x then x else x ++ [pathSeparator]


-- | Remove any trailing path separators
--
-- > dropTrailingPathSeparator "file/test/" == "file/test"
-- >           dropTrailingPathSeparator "/" == "/"
-- > Windows:  dropTrailingPathSeparator "\\" == "\\"
-- > Posix:    not (hasTrailingPathSeparator (dropTrailingPathSeparator x)) || isDrive x
dropTrailingPathSeparator :: FilePath -> FilePath
dropTrailingPathSeparator x =
    if hasTrailingPathSeparator x && not (isDrive x)
    then let x' = reverse $ dropWhile isPathSeparator $ reverse x
         in if null x' then [last x] else x'
    else x


-- | Get the directory name, move up one level.
--
-- >           takeDirectory x `isPrefixOf` x || takeDirectory x == "."
-- >           takeDirectory "foo" == "."
-- >           takeDirectory "/" == "/"
-- >           takeDirectory "/foo" == "/"
-- >           takeDirectory "/foo/bar/baz" == "/foo/bar"
-- >           takeDirectory "/foo/bar/baz/" == "/foo/bar/baz"
-- >           takeDirectory "foo/bar/baz" == "foo/bar"
-- > Windows:  takeDirectory "foo\\bar" == "foo"
-- > Windows:  takeDirectory "foo\\bar\\\\" == "foo\\bar"
-- > Windows:  takeDirectory "C:\\" == "C:\\"
takeDirectory :: FilePath -> FilePath
takeDirectory = dropTrailingPathSeparator . dropFileName

-- | Set the directory, keeping the filename the same.
--
-- > Valid x => replaceDirectory x (takeDirectory x) `equalFilePath` x
replaceDirectory :: FilePath -> String -> FilePath
replaceDirectory x dir = combineAlways dir (takeFileName x)


-- | Combine two paths, if the second path starts with a path separator or a
-- drive letter, then it returns the second.
--
-- > Valid x => combine (takeDirectory x) (takeFileName x) `equalFilePath` x
--
-- Combined:
-- > Posix:   combine "/" "test" == "/test"
-- > Posix:   combine "home" "bob" == "home/bob"
-- > Posix:   combine "x:" "foo" == "x:/foo"
-- > Windows: combine "C:\\foo" "bar" == "C:\\foo\\bar"
-- > Windows: combine "home" "bob" == "home\\bob"
--
-- Not combined:
-- > Posix:   combine "home" "/bob" == "/bob"
-- > Windows: combine "home" "C:\\bob" == "C:\\bob"
--
-- Not combined (tricky):
-- On Windows, if a filepath starts with a single slash, it is relative to the
-- root of the current drive. In [1], this is (confusingly) referred to as an
-- absolute path.
-- The current behavior of @combine@ is to never combine these forms.
--
-- > Windows: combine "home" "/bob" == "/bob"
-- > Windows: combine "home" "\\bob" == "\\bob"
-- > Windows: combine "C:\\home" "\\bob" == "\\bob"
--
-- On Windows, from [1]: "If a file name begins with only a disk designator
-- but not the backslash after the colon, it is interpreted as a relative path
-- to the current directory on the drive with the specified letter."
-- The current behavior of @combine@ is to never combine these forms.
--
-- > Windows: combine "D:\\foo" "C:bar" == "C:bar"
-- > Windows: combine "C:\\foo" "C:bar" == "C:bar"
combine :: FilePath -> FilePath -> FilePath
combine a b | hasLeadingPathSeparator b || hasDrive b = b
            | otherwise = combineAlways a b

-- | Combine two paths, assuming rhs is NOT absolute.
combineAlways :: FilePath -> FilePath -> FilePath
combineAlways a b | null a = b
                  | null b = a
                  | hasTrailingPathSeparator a = a ++ b
                  | otherwise = case a of
                      [a1,':'] | isWindows && isLetter a1 -> a ++ b
                      _ -> a ++ [pathSeparator] ++ b


-- | A nice alias for 'combine'.
(</>) :: FilePath -> FilePath -> FilePath
(</>) = combine


-- | Split a path by the directory separator.
--
-- > concat (splitPath x) == x
-- > splitPath "test//item/" == ["test//","item/"]
-- > splitPath "test/item/file" == ["test/","item/","file"]
-- > splitPath "" == []
-- > Windows: splitPath "c:\\test\\path" == ["c:\\","test\\","path"]
-- > Posix:   splitPath "/file/test" == ["/","file/","test"]
splitPath :: FilePath -> [FilePath]
splitPath x = [drive | drive /= ""] ++ f path
    where
        (drive,path) = splitDrive x

        f "" = []
        f y = (a++c) : f d
            where
                (a,b) = break isPathSeparator y
                (c,d) = span  isPathSeparator b

-- | Just as 'splitPath', but don't add the trailing slashes to each element.
--
-- >          splitDirectories "test/file" == ["test","file"]
-- >          splitDirectories "/test/file" == ["/","test","file"]
-- > Windows: splitDirectories "C:\\test\\file" == ["C:\\", "test", "file"]
-- >          Valid x => joinPath (splitDirectories x) `equalFilePath` x
-- >          splitDirectories "" == []
-- > Windows: splitDirectories "C:\\test\\\\\\file" == ["C:\\", "test", "file"]
-- >          splitDirectories "/test///file" == ["/","test","file"]
splitDirectories :: FilePath -> [FilePath]
splitDirectories = map dropTrailingPathSeparator . splitPath


-- | Join path elements back together.
--
-- > Valid x => joinPath (splitPath x) == x
-- > joinPath [] == ""
-- > Posix: joinPath ["test","file","path"] == "test/file/path"

-- Note that this definition on c:\\c:\\, join then split will give c:\\.
joinPath :: [FilePath] -> FilePath
joinPath = foldr combine ""






---------------------------------------------------------------------
-- File name manipulators

-- | Equality of two 'FilePath's.
--   If you call @System.Directory.canonicalizePath@
--   first this has a much better chance of working.
--   Note that this doesn't follow symlinks or DOSNAM~1s.
--
-- >          x == y ==> equalFilePath x y
-- >          normalise x == normalise y ==> equalFilePath x y
-- >          equalFilePath "foo" "foo/"
-- >          not (equalFilePath "foo" "/foo")
-- > Posix:   not (equalFilePath "foo" "FOO")
-- > Windows: equalFilePath "foo" "FOO"
-- > Windows: not (equalFilePath "C:" "C:/")
equalFilePath :: FilePath -> FilePath -> Bool
equalFilePath a b = f a == f b
    where
        f x | isWindows = dropTrailingPathSeparator $ map toLower $ normalise x
            | otherwise = dropTrailingPathSeparator $ normalise x


-- | Contract a filename, based on a relative path.
--
--   There is no corresponding @makeAbsolute@ function, instead use
--   @System.Directory.canonicalizePath@ which has the same effect.
--
-- >          Valid y => Valid x => equalFilePath x y || (isRelative x && makeRelative y x == x) || equalFilePath (y </> makeRelative y x) x
-- >          makeRelative x x == "."
-- > Windows: makeRelative "C:\\Home" "c:\\home\\bob" == "bob"
-- > Windows: makeRelative "C:\\Home" "c:/home/bob" == "bob"
-- > Windows: makeRelative "C:\\Home" "D:\\Home\\Bob" == "D:\\Home\\Bob"
-- > Windows: makeRelative "C:\\Home" "C:Home\\Bob" == "C:Home\\Bob"
-- > Windows: makeRelative "/Home" "/home/bob" == "bob"
-- > Windows: makeRelative "/" "//" == "//"
-- > Posix:   makeRelative "/Home" "/home/bob" == "/home/bob"
-- > Posix:   makeRelative "/home/" "/home/bob/foo/bar" == "bob/foo/bar"
-- > Posix:   makeRelative "/fred" "bob" == "bob"
-- > Posix:   makeRelative "/file/test" "/file/test/fred" == "fred"
-- > Posix:   makeRelative "/file/test" "/file/test/fred/" == "fred/"
-- > Posix:   makeRelative "some/path" "some/path/a/b/c" == "a/b/c"
makeRelative :: FilePath -> FilePath -> FilePath
makeRelative root path
 | equalFilePath root path = "."
 | takeAbs root /= takeAbs path = path
 | otherwise = f (dropAbs root) (dropAbs path)
    where
        f "" y = dropWhile isPathSeparator y
        f x y = let (x1,x2) = g x
                    (y1,y2) = g y
                in if equalFilePath x1 y1 then f x2 y2 else path

        g x = (dropWhile isPathSeparator a, dropWhile isPathSeparator b)
            where (a,b) = break isPathSeparator $ dropWhile isPathSeparator x

        -- on windows, need to drop '/' which is kind of absolute, but not a drive
        dropAbs x | hasLeadingPathSeparator x && not (hasDrive x) = tail x
        dropAbs x = dropDrive x

        takeAbs x | hasLeadingPathSeparator x && not (hasDrive x) = [pathSeparator]
        takeAbs x = map (\y -> if isPathSeparator y then pathSeparator else toLower y) $ takeDrive x

-- | Normalise a file
--
-- * \/\/ outside of the drive can be made blank
--
-- * \/ -> 'pathSeparator'
--
-- * .\/ -> \"\"
--
-- > Posix:   normalise "/file/\\test////" == "/file/\\test/"
-- > Posix:   normalise "/file/./test" == "/file/test"
-- > Posix:   normalise "/test/file/../bob/fred/" == "/test/file/../bob/fred/"
-- > Posix:   normalise "../bob/fred/" == "../bob/fred/"
-- > Posix:   normalise "./bob/fred/" == "bob/fred/"
-- > Windows: normalise "c:\\file/bob\\" == "C:\\file\\bob\\"
-- > Windows: normalise "c:\\" == "C:\\"
-- > Windows: normalise "\\\\server\\test" == "\\\\server\\test"
-- > Windows: normalise "//server/test" == "\\\\server\\test"
-- > Windows: normalise "c:/file" == "C:\\file"
-- > Windows: normalise "/file" == "\\file"
-- > Windows: normalise "\\" == "\\"
-- > Windows: normalise "/./" == "\\"
-- >          normalise "." == "."
-- > Posix:   normalise "./" == "./"
-- > Posix:   normalise "./." == "./"
-- > Posix:   normalise "/./" == "/"
-- > Posix:   normalise "/" == "/"
-- > Posix:   normalise "bob/fred/." == "bob/fred/"
normalise :: FilePath -> FilePath
normalise path = result ++ [pathSeparator | addPathSeparator]
    where
        (drv,pth) = splitDrive path
        result = joinDrive' (normaliseDrive drv) (f pth)

        joinDrive' "" "" = "."
        joinDrive' d p = joinDrive d p

        addPathSeparator = isDirPath pth
            && not (hasTrailingPathSeparator result)

        isDirPath xs = hasTrailingPathSeparator xs
            || not (null xs) && last xs == '.' && hasTrailingPathSeparator (init xs)

        f = joinPath . dropDots . propSep . splitDirectories

        propSep (x:xs) | all isPathSeparator x = [pathSeparator] : xs
                       | otherwise = x : xs
        propSep [] = []

        dropDots = filter ("." /=)

normaliseDrive :: FilePath -> FilePath
normaliseDrive drive | isPosix = drive
normaliseDrive drive = if isJust $ readDriveLetter x2
                       then map toUpper x2
                       else x2
    where
        x2 = map repSlash drive

        repSlash x = if isPathSeparator x then pathSeparator else x

-- Information for validity functions on Windows. See [1].
badCharacters :: [Char]
badCharacters = ":*?><|\""
badElements :: [FilePath]
badElements = ["CON", "PRN", "AUX", "NUL", "COM1", "COM2", "COM3", "COM4", "COM5", "COM6", "COM7", "COM8", "COM9", "LPT1", "LPT2", "LPT3", "LPT4", "LPT5", "LPT6", "LPT7", "LPT8", "LPT9", "CLOCK$"]


-- | Is a FilePath valid, i.e. could you create a file like it?
--
-- >          isValid "" == False
-- > Posix:   isValid "/random_ path:*" == True
-- > Posix:   isValid x == not (null x)
-- > Windows: isValid "c:\\test" == True
-- > Windows: isValid "c:\\test:of_test" == False
-- > Windows: isValid "test*" == False
-- > Windows: isValid "c:\\test\\nul" == False
-- > Windows: isValid "c:\\test\\prn.txt" == False
-- > Windows: isValid "c:\\nul\\file" == False
-- > Windows: isValid "\\\\" == False
-- > Windows: isValid "\\\\\\foo" == False
isValid :: FilePath -> Bool
isValid "" = False
isValid _ | isPosix = True
isValid path =
        not (any (`elem` badCharacters) x2) &&
        not (any f $ splitDirectories x2) &&
        not (length x1 >= 2 && all isPathSeparator x1)
    where
        x1 = head (splitPath path)
        x2 = dropDrive path
        f x = map toUpper (dropExtensions x) `elem` badElements


-- | Take a FilePath and make it valid; does not change already valid FilePaths.
--
-- > isValid (makeValid x)
-- > isValid x ==> makeValid x == x
-- > makeValid "" == "_"
-- > Windows: makeValid "c:\\already\\/valid" == "c:\\already\\/valid"
-- > Windows: makeValid "c:\\test:of_test" == "c:\\test_of_test"
-- > Windows: makeValid "test*" == "test_"
-- > Windows: makeValid "c:\\test\\nul" == "c:\\test\\nul_"
-- > Windows: makeValid "c:\\test\\prn.txt" == "c:\\test\\prn_.txt"
-- > Windows: makeValid "c:\\test/prn.txt" == "c:\\test/prn_.txt"
-- > Windows: makeValid "c:\\nul\\file" == "c:\\nul_\\file"
-- > Windows: makeValid "\\\\\\foo" == "\\\\drive"
makeValid :: FilePath -> FilePath
makeValid "" = "_"
makeValid path | isPosix = path
makeValid xs | length x >= 2 && all isPathSeparator x = take 2 x ++ "drive"
    where
        x = head (splitPath xs)
makeValid path = joinDrive drv $ validElements $ validChars pth
    where
        (drv,pth) = splitDrive path

        validChars = map f
        f x | x `elem` badCharacters = '_'
            | otherwise = x

        validElements x = joinPath $ map g $ splitPath x
        g x = h a ++ b
            where (a,b) = break isPathSeparator x
        h x = if map toUpper a `elem` badElements then a ++ "_" <.> b else x
            where (a,b) = splitExtensions x


-- | Is a path relative, or is it fixed to the root?
--
-- > Windows: isRelative "path\\test" == True
-- > Windows: isRelative "c:\\test" == False
-- > Windows: isRelative "c:test" == True
-- > Windows: isRelative "c:\\" == False
-- > Windows: isRelative "c:/" == False
-- > Windows: isRelative "c:" == True
-- > Windows: isRelative "\\\\foo" == False
-- > Windows: isRelative "\\\\?\\foo" == False
-- > Windows: isRelative "\\\\?\\UNC\\foo" == False
-- > Windows: isRelative "/foo" == True
-- > Windows: isRelative "\\foo" == True
-- > Posix:   isRelative "test/path" == True
-- > Posix:   isRelative "/test" == False
-- > Posix:   isRelative "/" == False
--
-- According to [1]:
--
-- * "A UNC name of any format [is never relative]."
--
-- * "You cannot use the "\\?\" prefix with a relative path."
isRelative :: FilePath -> Bool
isRelative = isRelativeDrive . takeDrive


{- c:foo -}
-- From [1]: "If a file name begins with only a disk designator but not the
-- backslash after the colon, it is interpreted as a relative path to the
-- current directory on the drive with the specified letter."
isRelativeDrive :: String -> Bool
isRelativeDrive x = null x ||
    maybe False (not . hasTrailingPathSeparator . fst) (readDriveLetter x)


-- | @not . 'isRelative'@
--
-- > isAbsolute x == not (isRelative x)
isAbsolute :: FilePath -> Bool
isAbsolute = not . isRelative
