module Pyfuck.Parser where

import Pyfuck.Syntax

import Text.Parsec hiding (State)
import Text.Parsec.Indent
import Control.Monad.Identity (Identity)

type IParser a = ParsecT String () (IndentT Identity) a

iParse :: IParser a -> String -> Either ParseError a
iParse aParser input = runIndentParser aParser () "std" input

parseKW :: String -> Statement -> IParser Statement
parseKW k s = string k >> spaces >> return s

pProgram :: IParser Program
pProgram = Program <$> many statement

statement :: IParser Statement
statement = try (parseKW "pass" Pass)
        <|> try (parseKW "return" Return <?> "return")
        <|> try (parseKW "raise" Raise <?> "raise")
        <|> try (parseKW "break" Break <?> "break")
        <|> try (parseKW "print()" Print <?> "print")
--        <|> try (parseKW "input()" Input <?> "input")
        <|> try pWhile
        where
          pWhile = While <$> withBlock' while statement <?> "while"
          while = string "while True:" >> spaces
