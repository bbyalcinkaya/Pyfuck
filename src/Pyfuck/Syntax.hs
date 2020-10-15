module Pyfuck.Syntax where

newtype Program = Program [Statement] deriving Show

data Statement
  = Pass
  | Return
  | Raise
  | Break
  | Print
--  | Input
  | While [Statement]
  deriving Show