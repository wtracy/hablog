import System.IO
import System.Directory
import Control.Monad

inputIndex = "index"
outputIndex = "index.html"
outputDir = "output"
prevText = "&lt; Prev"
nextText = "Next &gt;"

getEntries :: IO [String]
getEntries = do
  handle <- openFile inputIndex ReadMode
  content <- hGetContents handle
  let entries = lines content
  return (entries)

link :: String -> String -> String
link url text = "<a href=\"" ++ url ++ "\">" ++ text ++ "</a>"

{- builds the "previous" link -}
doPrev :: Maybe String -> String
doPrev Nothing = prevText
doPrev (Just prev) = link prev prevText

{- builds the "next" link -}
doNext :: Maybe String -> String
doNext Nothing = nextText
doNext (Just next) = link next nextText

navigation :: Maybe String -> Maybe String -> String
navigation prev next = "<div class=\"nav\">" ++ (doPrev prev) ++ " | " ++ (doNext next) ++ "</div>"

--publishEntry :: String -> IO ()
publishEntry previous entry next = do
  putStrLn ("Publishing " ++ entry)
  input <- openFile entry ReadMode 
  output <- openFile (outputDir ++ "/" ++ entry) WriteMode
  header <- hGetLine input 
  body <- hGetContents input
  hPutStr output "<!DOCTYPE html>\n<html><head><title>"
  hPutStr output header
  hPutStr output "</title><style type=\"text/css\">.nav {font-family: sans-serif; padding: 5px; background-color: #E0E0E0; margin-left: auto; margin-right: auto; width: 10em; text-align: center; border-radius: 10px; border-style: solid; border-color: #000000; border-width: 0px} pre {background-color: #E0E0E0}</style><body>"
  hPutStr output (navigation previous next)
  hPutStr output body
  hPutStr output (navigation previous next)
  hPutStr output "</body></html>"
  hClose input
  hClose output

getTitle :: String -> IO String
getTitle entry = do
  handle <- openFile entry ReadMode
  hGetLine handle

writeIndexEntry :: Handle -> String -> IO ()
writeIndexEntry handle entry = do
  title <- getTitle entry
  hPutStr handle "<li>"
  hPutStr handle (link entry title)
  hPutStr handle "</li>"

publishIndex :: [String] -> IO ()
publishIndex entries = do
  handle <- openFile (outputDir ++ "/" ++ outputIndex) WriteMode
  hPutStr handle "<html><head><title>Blog Index</title></head><body><ul>"
  forM entries (writeIndexEntry handle)
  hPutStr handle "</ul></body></html>"
  hClose handle

prepOutput :: IO ()
prepOutput = createDirectoryIfMissing True outputDir

doPublish :: Maybe String -> [String] -> IO()
doPublish previous [entry] = publishEntry previous entry Nothing
doPublish previous (entry:next:remainder) = do
  publishEntry previous entry (Just next)
  doPublish (Just entry) (next:remainder)

publish :: [String] -> IO()
publish entries = doPublish Nothing entries

main :: IO()
main = do
  putStrLn "Reading entries ..."
  entries <- getEntries
  putStrLn "Creating output directory ..."
  prepOutput
  putStrLn "Publishing entry pages ..."
  publish entries
  putStrLn "Publishing index ..."
  publishIndex entries
  putStrLn "Done!"
