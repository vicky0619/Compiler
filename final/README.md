# README

## Introduction

This repository contains two files, `final.l` and `final.y`, which together form a lexer and parser for a simple programming language. The language supports basic arithmetic operations, logical operations, variable assignment, function definition, function calls, conditional statements, and print statements.

## Files

### 1. `final.l`

This file contains the lexer specifications written in Flex. It defines patterns for tokens such as numbers, keywords, operators, and identifiers. The lexer passes the recognized tokens to the parser (`final.y`) for further processing.

### 2. `final.y`

This file contains the parser specifications written in Bison (Yacc). It defines the grammar rules for the programming language, including statements, expressions, function definitions, and conditional statements. The parser generates an Abstract Syntax Tree (AST) during the parsing process.

## Language Features

The programming language defined by these files includes the following features:

1. **Arithmetic Operations:** Addition, subtraction, multiplication, division, modulus.
2. **Logical Operations:** AND, OR, NOT.
3. **Variables:** Declaration and usage of variables.
4. **Functions:** Function definition using the `fun` keyword, function calls, and parameter passing.
5. **Conditional Statements:** `if` statements with optional `else` clauses.
6. **Print Statements:** Printing numeric and boolean values.

## AST Structure

The Abstract Syntax Tree (AST) is structured using the `N` (node) struct, which contains information about the type of node (e.g., number, variable, operation), the name of the variable, the numerical value (if applicable), and pointers to the left and right children.

## How to Run

To compile and run the lexer and parser, use the following steps:

```bash
bison -d -o final.tab.c final.y
gcc -c -g -I.. final.tab.c
flex -o lex.yy.c final.l
gcc -c -g -I.. lex.yy.c
gcc -o final final.tab.o lex.yy.o
./final < filename.lsp
```

This will generate an executable `final` that can be run to parse and evaluate programs written in the defined language.

## Example Programs

Below are some example programs written in the defined language:

```plaintext
(define x 10)             ; Variable declaration
(define y 20)
(print-num (+ x y))        ; Print the sum of x and y

(fun add (a b)             ; Function definition
  (+ a b)
)

(define result (add 5 7))  ; Function call
(print-num result)         ; Print the result

(if (> x y)               ; Conditional statement
  (print-bool #t)
  (print-bool #f)
)
```

Feel free to modify and create your own programs using the defined language features.

## Error Handling

The parser includes basic error handling using the `yyerror` function, which prints a syntax error message when an error is encountered during parsing.

## Notes

- The language is case-sensitive.
- Ensure that you have Flex and Bison installed on your system before attempting to compile the lexer and parser.

