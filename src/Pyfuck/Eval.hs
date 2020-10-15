{-# Language LambdaCase #-}
module Pyfuck.Eval where
  
import Pyfuck.Syntax

import Data.Word (Word8)
import Control.Monad.State
import Control.Monad.Trans.Except
data Tape = Tape [Word8] Word8 [Word8] deriving Show


emptyTape :: Tape
emptyTape = Tape [] 0 (replicate 29999 0)

tapeLeft, tapeRight :: Tape -> Either [Char] Tape
tapeLeft t@(Tape [] _ _) = Left $ "cannot go left " ++ show t
tapeLeft (Tape (x:xs) y ys) = Right $ Tape xs x (y:ys)
tapeRight t@(Tape _ _ []) = Left $ "cannot go right " ++ show t
tapeRight (Tape xs x (y:ys)) = Right $ Tape (x:xs) y ys

tapeModify :: (Word8 -> Word8) -> Tape -> Tape
tapeModify f (Tape l x r) = Tape l (f x) r

tapeGet :: Tape -> Word8
tapeGet (Tape _ x _) = x

toChar :: Word8 -> Char
toChar = toEnum . fromIntegral

run :: Program -> IO ()
run (Program sts) = do
  let execution = evalStateT . runExceptT $ mapM_ eval sts
  res <- execution emptyTape
  case res of
    Left err -> putStrLn $ "ERROR: " <> err
    Right _ -> return ()

type InterpM = ExceptT String (StateT Tape IO) ()

eval :: Statement -> InterpM
eval = \case
  Pass -> get >>= except . tapeRight >>= put
  Return -> get >>= except . tapeLeft >>= put
  Raise -> modify $ tapeModify (+1)
  Break -> modify $ tapeModify (+ (-1)) -- :@
  Print -> gets tapeGet >>= lift . lift . putChar . toChar
  --Print -> gets tapeGet >>= lift . lift . print
  s@(While sts) -> do
    x <- gets tapeGet
    if x == 0 
      then return ()
      else mapM_ eval sts >> eval s