module TestGen(tests) where
import TestUtil
import qualified System.FilePath.Windows as W
import qualified System.FilePath.Posix as P
tests :: IO ()
tests = do
 block1
 block2
 block3
 block4
 block5
 block6
 block7
 block8
 block9
 block10
 block11
 block12
 block13
 block14
block1 = do
 putStrLn "Test 1, from line 120"
 test (W.pathSeparator == '\\')
 putStrLn "Test 2, from line 121"
 test (P.pathSeparator == '/')
 putStrLn "Test 3, from line 122"
 test (W.isPathSeparator W.pathSeparator)
 putStrLn "Test 4, from line 122"
 test (P.isPathSeparator P.pathSeparator)
 putStrLn "Test 5, from line 128"
 test (W.pathSeparators == [ '\\' , '/' ])
 putStrLn "Test 6, from line 129"
 test (P.pathSeparators == [ '/' ])
 putStrLn "Test 7, from line 130"
 test (W.pathSeparator ` elem ` W.pathSeparators)
 putStrLn "Test 8, from line 130"
 test (P.pathSeparator ` elem ` P.pathSeparators)
 putStrLn "Test 9, from line 144"
 test (W.searchPathSeparator == ';')
 putStrLn "Test 10, from line 145"
 test (P.searchPathSeparator == ':')
 putStrLn "Test 11, from line 158"
 test (W.extSeparator == '.')
 putStrLn "Test 12, from line 158"
 test (P.extSeparator == '.')
 putStrLn "Test 13, from line 179"
 test (P.splitSearchPath "File1:File2:File3" == [ "File1" , "File2" , "File3" ])
 putStrLn "Test 14, from line 180"
 test (P.splitSearchPath "File1::File2:File3" == [ "File1" , "." , "File2" , "File3" ])
 putStrLn "Test 15, from line 181"
 test (W.splitSearchPath "File1;File2;File3" == [ "File1" , "File2" , "File3" ])
 putStrLn "Test 16, from line 182"
 test (W.splitSearchPath "File1;;File2;File3" == [ "File1" , "File2" , "File3" ])
 putStrLn "Test 17, from line 183"
 test (W.splitSearchPath "File1;\"File2\";File3" == [ "File1" , "File2" , "File3" ])
 putStrLn "Test 18, from line 208"
 test (W.splitExtension "file.txt" == ( "file" , ".txt" ))
 putStrLn "Test 19, from line 208"
 test (P.splitExtension "file.txt" == ( "file" , ".txt" ))
 putStrLn "Test 20, from line 209"
 test (W.splitExtension "file" == ( "file" , "" ))
 putStrLn "Test 21, from line 209"
 test (P.splitExtension "file" == ( "file" , "" ))
 putStrLn "Test 22, from line 210"
 test (W.splitExtension "file/file.txt" == ( "file/file" , ".txt" ))
 putStrLn "Test 23, from line 210"
 test (P.splitExtension "file/file.txt" == ( "file/file" , ".txt" ))
 putStrLn "Test 24, from line 211"
 test (W.splitExtension "file.txt/boris" == ( "file.txt/boris" , "" ))
 putStrLn "Test 25, from line 211"
 test (P.splitExtension "file.txt/boris" == ( "file.txt/boris" , "" ))
block2 = do
 putStrLn "Test 26, from line 212"
 test (W.splitExtension "file.txt/boris.ext" == ( "file.txt/boris" , ".ext" ))
 putStrLn "Test 27, from line 212"
 test (P.splitExtension "file.txt/boris.ext" == ( "file.txt/boris" , ".ext" ))
 putStrLn "Test 28, from line 213"
 test (W.splitExtension "file/path.txt.bob.fred" == ( "file/path.txt.bob" , ".fred" ))
 putStrLn "Test 29, from line 213"
 test (P.splitExtension "file/path.txt.bob.fred" == ( "file/path.txt.bob" , ".fred" ))
 putStrLn "Test 30, from line 214"
 test (W.splitExtension "file/path.txt/" == ( "file/path.txt/" , "" ))
 putStrLn "Test 31, from line 214"
 test (P.splitExtension "file/path.txt/" == ( "file/path.txt/" , "" ))
 putStrLn "Test 32, from line 233"
 test (W.replaceExtension "file.txt" ".bob" == "file.bob")
 putStrLn "Test 33, from line 233"
 test (P.replaceExtension "file.txt" ".bob" == "file.bob")
 putStrLn "Test 34, from line 234"
 test (W.replaceExtension "file.txt" "bob" == "file.bob")
 putStrLn "Test 35, from line 234"
 test (P.replaceExtension "file.txt" "bob" == "file.bob")
 putStrLn "Test 36, from line 235"
 test (W.replaceExtension "file" ".bob" == "file.bob")
 putStrLn "Test 37, from line 235"
 test (P.replaceExtension "file" ".bob" == "file.bob")
 putStrLn "Test 38, from line 236"
 test (W.replaceExtension "file.txt" "" == "file")
 putStrLn "Test 39, from line 236"
 test (P.replaceExtension "file.txt" "" == "file")
 putStrLn "Test 40, from line 237"
 test (W.replaceExtension "file.fred.bob" "txt" == "file.fred.txt")
 putStrLn "Test 41, from line 237"
 test (P.replaceExtension "file.fred.bob" "txt" == "file.fred.txt")
 putStrLn "Test 42, from line 254"
 test (W.addExtension "file.txt" "bib" == "file.txt.bib")
 putStrLn "Test 43, from line 254"
 test (P.addExtension "file.txt" "bib" == "file.txt.bib")
 putStrLn "Test 44, from line 255"
 test (W.addExtension "file." ".bib" == "file..bib")
 putStrLn "Test 45, from line 255"
 test (P.addExtension "file." ".bib" == "file..bib")
 putStrLn "Test 46, from line 256"
 test (W.addExtension "file" ".bib" == "file.bib")
 putStrLn "Test 47, from line 256"
 test (P.addExtension "file" ".bib" == "file.bib")
 putStrLn "Test 48, from line 257"
 test (W.addExtension "/" "x" == "/.x")
 putStrLn "Test 49, from line 257"
 test (P.addExtension "/" "x" == "/.x")
 putStrLn "Test 50, from line 259"
 test (W.addExtension "\\\\share" ".txt" == "\\\\share\\.txt")
block3 = do
 putStrLn "Test 51, from line 280"
 test (W.splitExtensions "file.tar.gz" == ( "file" , ".tar.gz" ))
 putStrLn "Test 52, from line 280"
 test (P.splitExtensions "file.tar.gz" == ( "file" , ".tar.gz" ))
 putStrLn "Test 53, from line 295"
 test (W.takeExtensions "file.tar.gz" == ".tar.gz")
 putStrLn "Test 54, from line 295"
 test (P.takeExtensions "file.tar.gz" == ".tar.gz")
 putStrLn "Test 55, from line 314"
 test (W.splitDrive "file" == ( "" , "file" ))
 putStrLn "Test 56, from line 315"
 test (W.splitDrive "c:/file" == ( "c:/" , "file" ))
 putStrLn "Test 57, from line 316"
 test (W.splitDrive "c:\\file" == ( "c:\\" , "file" ))
 putStrLn "Test 58, from line 317"
 test (W.splitDrive "\\\\shared\\test" == ( "\\\\shared\\" , "test" ))
 putStrLn "Test 59, from line 318"
 test (W.splitDrive "\\\\shared" == ( "\\\\shared" , "" ))
 putStrLn "Test 60, from line 319"
 test (W.splitDrive "\\\\?\\UNC\\shared\\file" == ( "\\\\?\\UNC\\shared\\" , "file" ))
 putStrLn "Test 61, from line 320"
 test (W.splitDrive "\\\\?\\UNCshared\\file" == ( "\\\\?\\" , "UNCshared\\file" ))
 putStrLn "Test 62, from line 321"
 test (W.splitDrive "\\\\?\\d:\\file" == ( "\\\\?\\d:\\" , "file" ))
 putStrLn "Test 63, from line 322"
 test (W.splitDrive "/d" == ( "" , "/d" ))
 putStrLn "Test 64, from line 323"
 test (P.splitDrive "/test" == ( "/" , "test" ))
 putStrLn "Test 65, from line 324"
 test (P.splitDrive "//test" == ( "//" , "test" ))
 putStrLn "Test 66, from line 325"
 test (P.splitDrive "test/file" == ( "" , "test/file" ))
 putStrLn "Test 67, from line 326"
 test (P.splitDrive "file" == ( "" , "file" ))
 putStrLn "Test 68, from line 383"
 test (W.joinDrive "C:" "foo" == "C:foo")
 putStrLn "Test 69, from line 384"
 test (W.joinDrive "C:\\" "bar" == "C:\\bar")
 putStrLn "Test 70, from line 385"
 test (W.joinDrive "\\\\share" "foo" == "\\\\share\\foo")
 putStrLn "Test 71, from line 386"
 test (W.joinDrive "/:" "foo" == "/:\\foo")
 putStrLn "Test 72, from line 405"
 test (P.hasDrive "/foo" == True)
 putStrLn "Test 73, from line 406"
 test (W.hasDrive "C:\\foo" == True)
 putStrLn "Test 74, from line 407"
 test (W.hasDrive "C:foo" == True)
 putStrLn "Test 75, from line 408"
 test (W.hasDrive "foo" == False)
block4 = do
 putStrLn "Test 76, from line 408"
 test (P.hasDrive "foo" == False)
 putStrLn "Test 77, from line 409"
 test (W.hasDrive "" == False)
 putStrLn "Test 78, from line 409"
 test (P.hasDrive "" == False)
 putStrLn "Test 79, from line 416"
 test (P.isDrive "/" == True)
 putStrLn "Test 80, from line 417"
 test (P.isDrive "/foo" == False)
 putStrLn "Test 81, from line 418"
 test (W.isDrive "C:\\" == True)
 putStrLn "Test 82, from line 419"
 test (W.isDrive "C:\\foo" == False)
 putStrLn "Test 83, from line 420"
 test (W.isDrive "" == False)
 putStrLn "Test 84, from line 420"
 test (P.isDrive "" == False)
 putStrLn "Test 85, from line 432"
 test (W.splitFileName "file/bob.txt" == ( "file/" , "bob.txt" ))
 putStrLn "Test 86, from line 432"
 test (P.splitFileName "file/bob.txt" == ( "file/" , "bob.txt" ))
 putStrLn "Test 87, from line 433"
 test (W.splitFileName "file/" == ( "file/" , "" ))
 putStrLn "Test 88, from line 433"
 test (P.splitFileName "file/" == ( "file/" , "" ))
 putStrLn "Test 89, from line 434"
 test (W.splitFileName "bob" == ( "./" , "bob" ))
 putStrLn "Test 90, from line 434"
 test (P.splitFileName "bob" == ( "./" , "bob" ))
 putStrLn "Test 91, from line 435"
 test (P.splitFileName "/" == ( "/" , "" ))
 putStrLn "Test 92, from line 436"
 test (W.splitFileName "c:" == ( "c:" , "" ))
 putStrLn "Test 93, from line 469"
 test (W.takeFileName "test/" == "")
 putStrLn "Test 94, from line 469"
 test (P.takeFileName "test/" == "")
 putStrLn "Test 95, from line 480"
 test (W.takeBaseName "file/test.txt" == "test")
 putStrLn "Test 96, from line 480"
 test (P.takeBaseName "file/test.txt" == "test")
 putStrLn "Test 97, from line 481"
 test (W.takeBaseName "dave.ext" == "dave")
 putStrLn "Test 98, from line 481"
 test (P.takeBaseName "dave.ext" == "dave")
 putStrLn "Test 99, from line 482"
 test (W.takeBaseName "" == "")
 putStrLn "Test 100, from line 482"
 test (P.takeBaseName "" == "")
block5 = do
 putStrLn "Test 101, from line 483"
 test (W.takeBaseName "test" == "test")
 putStrLn "Test 102, from line 483"
 test (P.takeBaseName "test" == "test")
 putStrLn "Test 103, from line 485"
 test (W.takeBaseName "file/file.tar.gz" == "file.tar")
 putStrLn "Test 104, from line 485"
 test (P.takeBaseName "file/file.tar.gz" == "file.tar")
 putStrLn "Test 105, from line 491"
 test (W.replaceBaseName "file/test.txt" "bob" == "file/bob.txt")
 putStrLn "Test 106, from line 491"
 test (P.replaceBaseName "file/test.txt" "bob" == "file/bob.txt")
 putStrLn "Test 107, from line 492"
 test (W.replaceBaseName "fred" "bill" == "bill")
 putStrLn "Test 108, from line 492"
 test (P.replaceBaseName "fred" "bill" == "bill")
 putStrLn "Test 109, from line 493"
 test (W.replaceBaseName "/dave/fred/bob.gz.tar" "new" == "/dave/fred/new.tar")
 putStrLn "Test 110, from line 493"
 test (P.replaceBaseName "/dave/fred/bob.gz.tar" "new" == "/dave/fred/new.tar")
 putStrLn "Test 111, from line 503"
 test (W.hasTrailingPathSeparator "test" == False)
 putStrLn "Test 112, from line 503"
 test (P.hasTrailingPathSeparator "test" == False)
 putStrLn "Test 113, from line 504"
 test (W.hasTrailingPathSeparator "test/" == True)
 putStrLn "Test 114, from line 504"
 test (P.hasTrailingPathSeparator "test/" == True)
 putStrLn "Test 115, from line 519"
 test (P.addTrailingPathSeparator "test/rest" == "test/rest/")
 putStrLn "Test 116, from line 526"
 test (W.dropTrailingPathSeparator "file/test/" == "file/test")
 putStrLn "Test 117, from line 526"
 test (P.dropTrailingPathSeparator "file/test/" == "file/test")
 putStrLn "Test 118, from line 527"
 test (W.dropTrailingPathSeparator "/" == "/")
 putStrLn "Test 119, from line 527"
 test (P.dropTrailingPathSeparator "/" == "/")
 putStrLn "Test 120, from line 528"
 test (W.dropTrailingPathSeparator "\\" == "\\")
 putStrLn "Test 121, from line 541"
 test (W.takeDirectory "foo" == ".")
 putStrLn "Test 122, from line 541"
 test (P.takeDirectory "foo" == ".")
 putStrLn "Test 123, from line 542"
 test (W.takeDirectory "/" == "/")
 putStrLn "Test 124, from line 542"
 test (P.takeDirectory "/" == "/")
 putStrLn "Test 125, from line 543"
 test (W.takeDirectory "/foo" == "/")
block6 = do
 putStrLn "Test 126, from line 543"
 test (P.takeDirectory "/foo" == "/")
 putStrLn "Test 127, from line 544"
 test (W.takeDirectory "/foo/bar/baz" == "/foo/bar")
 putStrLn "Test 128, from line 544"
 test (P.takeDirectory "/foo/bar/baz" == "/foo/bar")
 putStrLn "Test 129, from line 545"
 test (W.takeDirectory "/foo/bar/baz/" == "/foo/bar/baz")
 putStrLn "Test 130, from line 545"
 test (P.takeDirectory "/foo/bar/baz/" == "/foo/bar/baz")
 putStrLn "Test 131, from line 546"
 test (W.takeDirectory "foo/bar/baz" == "foo/bar")
 putStrLn "Test 132, from line 546"
 test (P.takeDirectory "foo/bar/baz" == "foo/bar")
 putStrLn "Test 133, from line 547"
 test (W.takeDirectory "foo\\bar" == "foo")
 putStrLn "Test 134, from line 548"
 test (W.takeDirectory "foo\\bar\\\\" == "foo\\bar")
 putStrLn "Test 135, from line 549"
 test (W.takeDirectory "C:\\" == "C:\\")
 putStrLn "Test 136, from line 566"
 test (P.combine "/" "test" == "/test")
 putStrLn "Test 137, from line 567"
 test (P.combine "home" "bob" == "home/bob")
 putStrLn "Test 138, from line 568"
 test (P.combine "x:" "foo" == "x:/foo")
 putStrLn "Test 139, from line 569"
 test (W.combine "C:\\foo" "bar" == "C:\\foo\\bar")
 putStrLn "Test 140, from line 570"
 test (W.combine "home" "bob" == "home\\bob")
 putStrLn "Test 141, from line 573"
 test (P.combine "home" "/bob" == "/bob")
 putStrLn "Test 142, from line 574"
 test (W.combine "home" "C:\\bob" == "C:\\bob")
 putStrLn "Test 143, from line 582"
 test (W.combine "home" "/bob" == "/bob")
 putStrLn "Test 144, from line 583"
 test (W.combine "home" "\\bob" == "\\bob")
 putStrLn "Test 145, from line 584"
 test (W.combine "C:\\home" "\\bob" == "\\bob")
 putStrLn "Test 146, from line 591"
 test (W.combine "D:\\foo" "C:bar" == "C:bar")
 putStrLn "Test 147, from line 592"
 test (W.combine "C:\\foo" "C:bar" == "C:bar")
 putStrLn "Test 148, from line 615"
 test (W.splitPath "test//item/" == [ "test//" , "item/" ])
 putStrLn "Test 149, from line 615"
 test (P.splitPath "test//item/" == [ "test//" , "item/" ])
 putStrLn "Test 150, from line 616"
 test (W.splitPath "test/item/file" == [ "test/" , "item/" , "file" ])
block7 = do
 putStrLn "Test 151, from line 616"
 test (P.splitPath "test/item/file" == [ "test/" , "item/" , "file" ])
 putStrLn "Test 152, from line 617"
 test (W.splitPath "" == [ ])
 putStrLn "Test 153, from line 617"
 test (P.splitPath "" == [ ])
 putStrLn "Test 154, from line 618"
 test (W.splitPath "c:\\test\\path" == [ "c:\\" , "test\\" , "path" ])
 putStrLn "Test 155, from line 619"
 test (P.splitPath "/file/test" == [ "/" , "file/" , "test" ])
 putStrLn "Test 156, from line 633"
 test (W.splitDirectories "test/file" == [ "test" , "file" ])
 putStrLn "Test 157, from line 633"
 test (P.splitDirectories "test/file" == [ "test" , "file" ])
 putStrLn "Test 158, from line 634"
 test (W.splitDirectories "/test/file" == [ "/" , "test" , "file" ])
 putStrLn "Test 159, from line 634"
 test (P.splitDirectories "/test/file" == [ "/" , "test" , "file" ])
 putStrLn "Test 160, from line 635"
 test (W.splitDirectories "C:\\test\\file" == [ "C:\\" , "test" , "file" ])
 putStrLn "Test 161, from line 637"
 test (W.splitDirectories "" == [ ])
 putStrLn "Test 162, from line 637"
 test (P.splitDirectories "" == [ ])
 putStrLn "Test 163, from line 638"
 test (W.splitDirectories "C:\\test\\\\\\file" == [ "C:\\" , "test" , "file" ])
 putStrLn "Test 164, from line 639"
 test (W.splitDirectories "/test///file" == [ "/" , "test" , "file" ])
 putStrLn "Test 165, from line 639"
 test (P.splitDirectories "/test///file" == [ "/" , "test" , "file" ])
 putStrLn "Test 166, from line 647"
 test (W.joinPath [ ] == "")
 putStrLn "Test 167, from line 647"
 test (P.joinPath [ ] == "")
 putStrLn "Test 168, from line 648"
 test (P.joinPath [ "test" , "file" , "path" ] == "test/file/path")
 putStrLn "Test 169, from line 669"
 test (W.equalFilePath "foo" "foo/")
 putStrLn "Test 170, from line 669"
 test (P.equalFilePath "foo" "foo/")
 putStrLn "Test 171, from line 670"
 test (not ( W.equalFilePath "foo" "/foo" ))
 putStrLn "Test 172, from line 670"
 test (not ( P.equalFilePath "foo" "/foo" ))
 putStrLn "Test 173, from line 671"
 test (not ( P.equalFilePath "foo" "FOO" ))
 putStrLn "Test 174, from line 672"
 test (W.equalFilePath "foo" "FOO")
 putStrLn "Test 175, from line 673"
 test (not ( W.equalFilePath "C:" "C:/" ))
block8 = do
 putStrLn "Test 176, from line 688"
 test (W.makeRelative "C:\\Home" "c:\\home\\bob" == "bob")
 putStrLn "Test 177, from line 689"
 test (W.makeRelative "C:\\Home" "c:/home/bob" == "bob")
 putStrLn "Test 178, from line 690"
 test (W.makeRelative "C:\\Home" "D:\\Home\\Bob" == "D:\\Home\\Bob")
 putStrLn "Test 179, from line 691"
 test (W.makeRelative "C:\\Home" "C:Home\\Bob" == "C:Home\\Bob")
 putStrLn "Test 180, from line 692"
 test (W.makeRelative "/Home" "/home/bob" == "bob")
 putStrLn "Test 181, from line 693"
 test (W.makeRelative "/" "//" == "//")
 putStrLn "Test 182, from line 694"
 test (P.makeRelative "/Home" "/home/bob" == "/home/bob")
 putStrLn "Test 183, from line 695"
 test (P.makeRelative "/home/" "/home/bob/foo/bar" == "bob/foo/bar")
 putStrLn "Test 184, from line 696"
 test (P.makeRelative "/fred" "bob" == "bob")
 putStrLn "Test 185, from line 697"
 test (P.makeRelative "/file/test" "/file/test/fred" == "fred")
 putStrLn "Test 186, from line 698"
 test (P.makeRelative "/file/test" "/file/test/fred/" == "fred/")
 putStrLn "Test 187, from line 699"
 test (P.makeRelative "some/path" "some/path/a/b/c" == "a/b/c")
 putStrLn "Test 188, from line 729"
 test (P.normalise "/file/\\test////" == "/file/\\test/")
 putStrLn "Test 189, from line 730"
 test (P.normalise "/file/./test" == "/file/test")
 putStrLn "Test 190, from line 731"
 test (P.normalise "/test/file/../bob/fred/" == "/test/file/../bob/fred/")
 putStrLn "Test 191, from line 732"
 test (P.normalise "../bob/fred/" == "../bob/fred/")
 putStrLn "Test 192, from line 733"
 test (P.normalise "./bob/fred/" == "bob/fred/")
 putStrLn "Test 193, from line 734"
 test (W.normalise "c:\\file/bob\\" == "C:\\file\\bob\\")
 putStrLn "Test 194, from line 735"
 test (W.normalise "c:\\" == "C:\\")
 putStrLn "Test 195, from line 736"
 test (W.normalise "C:.\\" == "C:")
 putStrLn "Test 196, from line 737"
 test (W.normalise "\\\\server\\test" == "\\\\server\\test")
 putStrLn "Test 197, from line 738"
 test (W.normalise "//server/test" == "\\\\server\\test")
 putStrLn "Test 198, from line 739"
 test (W.normalise "c:/file" == "C:\\file")
 putStrLn "Test 199, from line 740"
 test (W.normalise "/file" == "\\file")
 putStrLn "Test 200, from line 741"
 test (W.normalise "\\" == "\\")
block9 = do
 putStrLn "Test 201, from line 742"
 test (W.normalise "/./" == "\\")
 putStrLn "Test 202, from line 743"
 test (W.normalise "." == ".")
 putStrLn "Test 203, from line 743"
 test (P.normalise "." == ".")
 putStrLn "Test 204, from line 744"
 test (P.normalise "./" == "./")
 putStrLn "Test 205, from line 745"
 test (P.normalise "./." == "./")
 putStrLn "Test 206, from line 746"
 test (P.normalise "/./" == "/")
 putStrLn "Test 207, from line 747"
 test (P.normalise "/" == "/")
 putStrLn "Test 208, from line 748"
 test (P.normalise "bob/fred/." == "bob/fred/")
 putStrLn "Test 209, from line 749"
 test (P.normalise "//home" == "/home")
 putStrLn "Test 210, from line 794"
 test (W.isValid "" == False)
 putStrLn "Test 211, from line 794"
 test (P.isValid "" == False)
 putStrLn "Test 212, from line 795"
 test (P.isValid "/random_ path:*" == True)
 putStrLn "Test 213, from line 797"
 test (W.isValid "c:\\test" == True)
 putStrLn "Test 214, from line 798"
 test (W.isValid "c:\\test:of_test" == False)
 putStrLn "Test 215, from line 799"
 test (W.isValid "test*" == False)
 putStrLn "Test 216, from line 800"
 test (W.isValid "c:\\test\\nul" == False)
 putStrLn "Test 217, from line 801"
 test (W.isValid "c:\\test\\prn.txt" == False)
 putStrLn "Test 218, from line 802"
 test (W.isValid "c:\\nul\\file" == False)
 putStrLn "Test 219, from line 803"
 test (W.isValid "\\\\" == False)
 putStrLn "Test 220, from line 804"
 test (W.isValid "\\\\\\foo" == False)
 putStrLn "Test 221, from line 805"
 test (W.isValid "\\\\?\\D:file" == False)
 putStrLn "Test 222, from line 823"
 test (W.makeValid "" == "_")
 putStrLn "Test 223, from line 823"
 test (P.makeValid "" == "_")
 putStrLn "Test 224, from line 824"
 test (W.makeValid "c:\\already\\/valid" == "c:\\already\\/valid")
 putStrLn "Test 225, from line 825"
 test (W.makeValid "c:\\test:of_test" == "c:\\test_of_test")
block10 = do
 putStrLn "Test 226, from line 826"
 test (W.makeValid "test*" == "test_")
 putStrLn "Test 227, from line 827"
 test (W.makeValid "c:\\test\\nul" == "c:\\test\\nul_")
 putStrLn "Test 228, from line 828"
 test (W.makeValid "c:\\test\\prn.txt" == "c:\\test\\prn_.txt")
 putStrLn "Test 229, from line 829"
 test (W.makeValid "c:\\test/prn.txt" == "c:\\test/prn_.txt")
 putStrLn "Test 230, from line 830"
 test (W.makeValid "c:\\nul\\file" == "c:\\nul_\\file")
 putStrLn "Test 231, from line 831"
 test (W.makeValid "\\\\\\foo" == "\\\\drive")
 putStrLn "Test 232, from line 832"
 test (W.makeValid "\\\\?\\D:file" == "\\\\?\\D:\\file")
 putStrLn "Test 233, from line 857"
 test (W.isRelative "path\\test" == True)
 putStrLn "Test 234, from line 858"
 test (W.isRelative "c:\\test" == False)
 putStrLn "Test 235, from line 859"
 test (W.isRelative "c:test" == True)
 putStrLn "Test 236, from line 860"
 test (W.isRelative "c:\\" == False)
 putStrLn "Test 237, from line 861"
 test (W.isRelative "c:/" == False)
 putStrLn "Test 238, from line 862"
 test (W.isRelative "c:" == True)
 putStrLn "Test 239, from line 863"
 test (W.isRelative "\\\\foo" == False)
 putStrLn "Test 240, from line 864"
 test (W.isRelative "\\\\?\\foo" == False)
 putStrLn "Test 241, from line 865"
 test (W.isRelative "\\\\?\\UNC\\foo" == False)
 putStrLn "Test 242, from line 866"
 test (W.isRelative "/foo" == True)
 putStrLn "Test 243, from line 867"
 test (W.isRelative "\\foo" == True)
 putStrLn "Test 244, from line 868"
 test (P.isRelative "test/path" == True)
 putStrLn "Test 245, from line 869"
 test (P.isRelative "/test" == False)
 putStrLn "Test 246, from line 870"
 test (P.isRelative "/" == False)
 putStrLn "Test 247, from line 137"
 test (\ a -> (W.isPathSeparator a == ( a ` elem ` W.pathSeparators )))
 putStrLn "Test 248, from line 137"
 test (\ a -> (P.isPathSeparator a == ( a ` elem ` P.pathSeparators )))
 putStrLn "Test 249, from line 151"
 test (\ a -> (W.isSearchPathSeparator a == ( a == W.searchPathSeparator )))
 putStrLn "Test 250, from line 151"
 test (\ a -> (P.isSearchPathSeparator a == ( a == P.searchPathSeparator )))
block11 = do
 putStrLn "Test 251, from line 164"
 test (\ a -> (W.isExtSeparator a == ( a == W.extSeparator )))
 putStrLn "Test 252, from line 164"
 test (\ a -> (P.isExtSeparator a == ( a == P.extSeparator )))
 putStrLn "Test 253, from line 206"
 test (\ (QFilePath x) -> (uncurry ( ++ ) ( W.splitExtension x ) == x))
 putStrLn "Test 254, from line 206"
 test (\ (QFilePath x) -> (uncurry ( ++ ) ( P.splitExtension x ) == x))
 putStrLn "Test 255, from line 207"
 test (\ (QFilePath x) -> ((\ x -> uncurry W.addExtension ( W.splitExtension x ) == x ) ( W.makeValid x )))
 putStrLn "Test 256, from line 207"
 test (\ (QFilePath x) -> ((\ x -> uncurry P.addExtension ( P.splitExtension x ) == x ) ( P.makeValid x )))
 putStrLn "Test 257, from line 225"
 test (\ (QFilePath x) -> (W.takeExtension x == snd ( W.splitExtension x )))
 putStrLn "Test 258, from line 225"
 test (\ (QFilePath x) -> (P.takeExtension x == snd ( P.splitExtension x )))
 putStrLn "Test 259, from line 226"
 test (\ (QFilePath x) -> ((\ x -> W.takeExtension ( W.addExtension x "ext" ) == ".ext" ) ( W.makeValid x )))
 putStrLn "Test 260, from line 226"
 test (\ (QFilePath x) -> ((\ x -> P.takeExtension ( P.addExtension x "ext" ) == ".ext" ) ( P.makeValid x )))
 putStrLn "Test 261, from line 227"
 test (\ (QFilePath x) -> ((\ x -> W.takeExtension ( W.replaceExtension x "ext" ) == ".ext" ) ( W.makeValid x )))
 putStrLn "Test 262, from line 227"
 test (\ (QFilePath x) -> ((\ x -> P.takeExtension ( P.replaceExtension x "ext" ) == ".ext" ) ( P.makeValid x )))
 putStrLn "Test 263, from line 247"
 test (\ (QFilePath x) -> (W.dropExtension x == fst ( W.splitExtension x )))
 putStrLn "Test 264, from line 247"
 test (\ (QFilePath x) -> (P.dropExtension x == fst ( P.splitExtension x )))
 putStrLn "Test 265, from line 258"
 test (\ (QFilePath x) -> ((\ x -> W.takeFileName ( W.addExtension ( W.addTrailingPathSeparator x ) "ext" ) == ".ext" ) ( W.makeValid x )))
 putStrLn "Test 266, from line 258"
 test (\ (QFilePath x) -> ((\ x -> P.takeFileName ( P.addExtension ( P.addTrailingPathSeparator x ) "ext" ) == ".ext" ) ( P.makeValid x )))
 putStrLn "Test 267, from line 271"
 test (\ (QFilePath x) -> (null ( W.takeExtension x ) == not ( W.hasExtension x )))
 putStrLn "Test 268, from line 271"
 test (\ (QFilePath x) -> (null ( P.takeExtension x ) == not ( P.hasExtension x )))
 putStrLn "Test 269, from line 278"
 test (\ (QFilePath x) -> (uncurry ( ++ ) ( W.splitExtensions x ) == x))
 putStrLn "Test 270, from line 278"
 test (\ (QFilePath x) -> (uncurry ( ++ ) ( P.splitExtensions x ) == x))
 putStrLn "Test 271, from line 279"
 test (\ (QFilePath x) -> ((\ x -> uncurry W.addExtension ( W.splitExtensions x ) == x ) ( W.makeValid x )))
 putStrLn "Test 272, from line 279"
 test (\ (QFilePath x) -> ((\ x -> uncurry P.addExtension ( P.splitExtensions x ) == x ) ( P.makeValid x )))
 putStrLn "Test 273, from line 289"
 test (\ (QFilePath x) -> (not $ W.hasExtension ( W.dropExtensions x )))
 putStrLn "Test 274, from line 289"
 test (\ (QFilePath x) -> (not $ P.hasExtension ( P.dropExtensions x )))
 putStrLn "Test 275, from line 313"
 test (\ (QFilePath x) -> (uncurry ( ++ ) ( W.splitDrive x ) == x))
block12 = do
 putStrLn "Test 276, from line 313"
 test (\ (QFilePath x) -> (uncurry ( ++ ) ( P.splitDrive x ) == x))
 putStrLn "Test 277, from line 382"
 test (\ (QFilePath x) -> ((\ x -> uncurry W.joinDrive ( W.splitDrive x ) == x ) ( W.makeValid x )))
 putStrLn "Test 278, from line 382"
 test (\ (QFilePath x) -> ((\ x -> uncurry P.joinDrive ( P.splitDrive x ) == x ) ( P.makeValid x )))
 putStrLn "Test 279, from line 392"
 test (\ (QFilePath x) -> (W.takeDrive x == fst ( W.splitDrive x )))
 putStrLn "Test 280, from line 392"
 test (\ (QFilePath x) -> (P.takeDrive x == fst ( P.splitDrive x )))
 putStrLn "Test 281, from line 398"
 test (\ (QFilePath x) -> (W.dropDrive x == snd ( W.splitDrive x )))
 putStrLn "Test 282, from line 398"
 test (\ (QFilePath x) -> (P.dropDrive x == snd ( P.splitDrive x )))
 putStrLn "Test 283, from line 404"
 test (\ (QFilePath x) -> (not ( W.hasDrive x ) == null ( W.takeDrive x )))
 putStrLn "Test 284, from line 404"
 test (\ (QFilePath x) -> (not ( P.hasDrive x ) == null ( P.takeDrive x )))
 putStrLn "Test 285, from line 430"
 test (\ (QFilePath x) -> ((\ x -> uncurry ( W.</> ) ( W.splitFileName x ) == x || fst ( W.splitFileName x ) == "./" ) ( W.makeValid x )))
 putStrLn "Test 286, from line 430"
 test (\ (QFilePath x) -> ((\ x -> uncurry ( P.</> ) ( P.splitFileName x ) == x || fst ( P.splitFileName x ) == "./" ) ( P.makeValid x )))
 putStrLn "Test 287, from line 431"
 test (\ (QFilePath x) -> ((\ x -> W.isValid ( fst ( W.splitFileName x ) ) ) ( W.makeValid x )))
 putStrLn "Test 288, from line 431"
 test (\ (QFilePath x) -> ((\ x -> P.isValid ( fst ( P.splitFileName x ) ) ) ( P.makeValid x )))
 putStrLn "Test 289, from line 456"
 test (\ (QFilePath x) -> ((\ x -> W.replaceFileName x ( W.takeFileName x ) == x ) ( W.makeValid x )))
 putStrLn "Test 290, from line 456"
 test (\ (QFilePath x) -> ((\ x -> P.replaceFileName x ( P.takeFileName x ) == x ) ( P.makeValid x )))
 putStrLn "Test 291, from line 462"
 test (\ (QFilePath x) -> (W.dropFileName x == fst ( W.splitFileName x )))
 putStrLn "Test 292, from line 462"
 test (\ (QFilePath x) -> (P.dropFileName x == fst ( P.splitFileName x )))
 putStrLn "Test 293, from line 470"
 test (\ (QFilePath x) -> (W.takeFileName x ` isSuffixOf ` x))
 putStrLn "Test 294, from line 470"
 test (\ (QFilePath x) -> (P.takeFileName x ` isSuffixOf ` x))
 putStrLn "Test 295, from line 471"
 test (\ (QFilePath x) -> (W.takeFileName x == snd ( W.splitFileName x )))
 putStrLn "Test 296, from line 471"
 test (\ (QFilePath x) -> (P.takeFileName x == snd ( P.splitFileName x )))
 putStrLn "Test 297, from line 472"
 test (\ (QFilePath x) -> ((\ x -> W.takeFileName ( W.replaceFileName x "fred" ) == "fred" ) ( W.makeValid x )))
 putStrLn "Test 298, from line 472"
 test (\ (QFilePath x) -> ((\ x -> P.takeFileName ( P.replaceFileName x "fred" ) == "fred" ) ( P.makeValid x )))
 putStrLn "Test 299, from line 473"
 test (\ (QFilePath x) -> ((\ x -> W.takeFileName ( x W.</> "fred" ) == "fred" ) ( W.makeValid x )))
 putStrLn "Test 300, from line 473"
 test (\ (QFilePath x) -> ((\ x -> P.takeFileName ( x P.</> "fred" ) == "fred" ) ( P.makeValid x )))
block13 = do
 putStrLn "Test 301, from line 474"
 test (\ (QFilePath x) -> ((\ x -> W.isRelative ( W.takeFileName x ) ) ( W.makeValid x )))
 putStrLn "Test 302, from line 474"
 test (\ (QFilePath x) -> ((\ x -> P.isRelative ( P.takeFileName x ) ) ( P.makeValid x )))
 putStrLn "Test 303, from line 484"
 test (\ (QFilePath x) -> (W.takeBaseName ( W.addTrailingPathSeparator x ) == ""))
 putStrLn "Test 304, from line 484"
 test (\ (QFilePath x) -> (P.takeBaseName ( P.addTrailingPathSeparator x ) == ""))
 putStrLn "Test 305, from line 494"
 test (\ (QFilePath x) -> ((\ x -> W.replaceBaseName x ( W.takeBaseName x ) == x ) ( W.makeValid x )))
 putStrLn "Test 306, from line 494"
 test (\ (QFilePath x) -> ((\ x -> P.replaceBaseName x ( P.takeBaseName x ) == x ) ( P.makeValid x )))
 putStrLn "Test 307, from line 517"
 test (\ (QFilePath x) -> (W.hasTrailingPathSeparator ( W.addTrailingPathSeparator x )))
 putStrLn "Test 308, from line 517"
 test (\ (QFilePath x) -> (P.hasTrailingPathSeparator ( P.addTrailingPathSeparator x )))
 putStrLn "Test 309, from line 518"
 test (\ (QFilePath x) -> (W.hasTrailingPathSeparator x ==> W.addTrailingPathSeparator x == x))
 putStrLn "Test 310, from line 518"
 test (\ (QFilePath x) -> (P.hasTrailingPathSeparator x ==> P.addTrailingPathSeparator x == x))
 putStrLn "Test 311, from line 529"
 test (\ (QFilePath x) -> (not ( P.hasTrailingPathSeparator ( P.dropTrailingPathSeparator x ) ) || P.isDrive x))
 putStrLn "Test 312, from line 540"
 test (\ (QFilePath x) -> (W.takeDirectory x ` isPrefixOf ` x || W.takeDirectory x == "."))
 putStrLn "Test 313, from line 540"
 test (\ (QFilePath x) -> (P.takeDirectory x ` isPrefixOf ` x || P.takeDirectory x == "."))
 putStrLn "Test 314, from line 555"
 test (\ (QFilePath x) -> ((\ x -> W.replaceDirectory x ( W.takeDirectory x ) ` W.equalFilePath ` x ) ( W.makeValid x )))
 putStrLn "Test 315, from line 555"
 test (\ (QFilePath x) -> ((\ x -> P.replaceDirectory x ( P.takeDirectory x ) ` P.equalFilePath ` x ) ( P.makeValid x )))
 putStrLn "Test 316, from line 563"
 test (\ (QFilePath x) -> ((\ x -> W.combine ( W.takeDirectory x ) ( W.takeFileName x ) ` W.equalFilePath ` x ) ( W.makeValid x )))
 putStrLn "Test 317, from line 563"
 test (\ (QFilePath x) -> ((\ x -> P.combine ( P.takeDirectory x ) ( P.takeFileName x ) ` P.equalFilePath ` x ) ( P.makeValid x )))
 putStrLn "Test 318, from line 614"
 test (\ (QFilePath x) -> (concat ( W.splitPath x ) == x))
 putStrLn "Test 319, from line 614"
 test (\ (QFilePath x) -> (concat ( P.splitPath x ) == x))
 putStrLn "Test 320, from line 636"
 test (\ (QFilePath x) -> ((\ x -> W.joinPath ( W.splitDirectories x ) ` W.equalFilePath ` x ) ( W.makeValid x )))
 putStrLn "Test 321, from line 636"
 test (\ (QFilePath x) -> ((\ x -> P.joinPath ( P.splitDirectories x ) ` P.equalFilePath ` x ) ( P.makeValid x )))
 putStrLn "Test 322, from line 646"
 test (\ (QFilePath x) -> ((\ x -> W.joinPath ( W.splitPath x ) == x ) ( W.makeValid x )))
 putStrLn "Test 323, from line 646"
 test (\ (QFilePath x) -> ((\ x -> P.joinPath ( P.splitPath x ) == x ) ( P.makeValid x )))
 putStrLn "Test 324, from line 667"
 test (\ (QFilePath x) (QFilePath y) -> (x == y ==> W.equalFilePath x y))
 putStrLn "Test 325, from line 667"
 test (\ (QFilePath x) (QFilePath y) -> (x == y ==> P.equalFilePath x y))
block14 = do
 putStrLn "Test 326, from line 668"
 test (\ (QFilePath x) (QFilePath y) -> (W.normalise x == W.normalise y ==> W.equalFilePath x y))
 putStrLn "Test 327, from line 668"
 test (\ (QFilePath x) (QFilePath y) -> (P.normalise x == P.normalise y ==> P.equalFilePath x y))
 putStrLn "Test 328, from line 686"
 test (\ (QFilePath x) (QFilePath y) -> ((\ y -> (\ x -> W.equalFilePath x y || ( W.isRelative x && W.makeRelative y x == x ) || W.equalFilePath ( y W.</> W.makeRelative y x ) x ) ( W.makeValid x ) ) ( W.makeValid y )))
 putStrLn "Test 329, from line 686"
 test (\ (QFilePath x) (QFilePath y) -> ((\ y -> (\ x -> P.equalFilePath x y || ( P.isRelative x && P.makeRelative y x == x ) || P.equalFilePath ( y P.</> P.makeRelative y x ) x ) ( P.makeValid x ) ) ( P.makeValid y )))
 putStrLn "Test 330, from line 687"
 test (\ (QFilePath x) -> (W.makeRelative x x == "."))
 putStrLn "Test 331, from line 687"
 test (\ (QFilePath x) -> (P.makeRelative x x == "."))
 putStrLn "Test 332, from line 796"
 test (\ (QFilePath x) -> (P.isValid x == not ( null x )))
 putStrLn "Test 333, from line 821"
 test (\ (QFilePath x) -> (W.isValid ( W.makeValid x )))
 putStrLn "Test 334, from line 821"
 test (\ (QFilePath x) -> (P.isValid ( P.makeValid x )))
 putStrLn "Test 335, from line 822"
 test (\ (QFilePath x) -> (W.isValid x ==> W.makeValid x == x))
 putStrLn "Test 336, from line 822"
 test (\ (QFilePath x) -> (P.isValid x ==> P.makeValid x == x))
 putStrLn "Test 337, from line 893"
 test (\ (QFilePath x) -> (W.isAbsolute x == not ( W.isRelative x )))
 putStrLn "Test 338, from line 893"
 test (\ (QFilePath x) -> (P.isAbsolute x == not ( P.isRelative x )))