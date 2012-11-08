import System.IO
import System.Directory
import Control.Monad

inputIndex = "index"
outputIndex = "index.html"
outputDir = "output"

getEntries :: IO [String]
getEntries = do
  handle <- openFile inputIndex ReadMode
  content <- hGetContents handle
  let entries = lines content
  return (entries)

 
publishEntry :: String -> IO ()
publishEntry entry = do
  input <- openFile entry ReadMode 
  output <- openFile (outputDir ++ "/" ++ entry) WriteMode
  header <- hGetLine input 
  body <- hGetContents input
  hPutStr output body
  hClose input
  hClose output

publishIndex :: [String] -> IO ()
publishIndex entries = do
  handle <- openFile (outputDir ++ "/" ++ outputIndex) WriteMode
  forM entries (hPutStrLn handle)
  hClose handle

prepOutput :: IO ()
prepOutput = createDirectoryIfMissing True outputDir

main :: IO()
main = do
  entries <- getEntries
  prepOutput
  mapM publishEntry entries
  publishIndex entries
  putStr "Done!\n"
