module Main where

import Pyfuck.Parser
import Pyfuck.Eval

import System.Environment (getArgs)
import System.IO (hPutStrLn, stderr)

main' :: String -> IO ()
main' input = do
  case iParse pProgram input of
    Left  err    -> print err
    Right result -> run result

main = do
  args <- getArgs
  case args of
    f:_   -> readFile f >>= main'
    []    -> hPutStrLn stderr usage

usage = "pyfuck <file-path>" 