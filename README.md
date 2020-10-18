# Pyfuck
A modern dialect of the best programming language ever.

[Hello, World!](example/hello.py)
## Syntax
Pyfuck | Brainfuck
-------|----------
`raise` | `+` 
`break` | `-` 
`pass` | `>`
`return` | `<` 
`print()` | `.` 
`while True:` | `[`
unindent | `]`


## Build
```
stack install
```

## Run
```
pyfuck <source-path>
```

## This Entire Repo Could Have Been a Gist
* Parsing indentation sensitive grammars with Parsec: [Parser](src/Pyfuck/Parser.hs#L29)
* Monad transformers, exception, state and IO monad: [Eval](src/Pyfuck/Eval.hs#L38)

