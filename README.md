# Compiler Construction: Coursework & Final Project

## Introduction

This repository documents my journey through the principles of compiler construction, from foundational concepts to the implementation of a complete, multi-stage compiler. It contains a series of homework assignments that build upon each other, culminating in a final project that compiles a custom Lisp-like language.

## Learning Path & Project Structure

The repository is structured as a progression of complexity, demonstrating a systematic approach to learning compiler design.

```
Compiler/
├── HW1/    # Manual implementation of core parsing concepts
├── HW2/    # Practical lexical analysis using Flex
├── HW3/    # Advanced parsing with Lex/Yacc
└── final/  # A complete, multi-stage compiler
```

-----

## Detailed Breakdown

### HW1: Manual Parser & Evaluator

This assignment focused on understanding parsing fundamentals without relying on generator tools.

  * **Part A: Recursive Descent Parser**

      * Manually implemented a top-down, recursive descent parser in C++ for a given grammar.
      * Includes a hand-written lexical scanner to tokenize the input stream.
      * Demonstrates a foundational understanding of how to implement context-free grammars and parsing logic from scratch.

  * **Part B: Polish Notation Calculator**

      * Developed an evaluator for mathematical expressions written in Polish (prefix) notation.
      * This exercise showcases the ability to process and evaluate expression trees recursively, a core concept in the semantic analysis phase of a compiler.

### HW2: Lexical Analysis with Flex

This assignment explored the power of lexer-generator tools.

  * **Part A: Data Type Recognizer**
      * Used Flex to write regular expressions for recognizing various data types, such as `INTEGER`, `FLOAT`, and `STRING`.
  * **Part B: Python-to-C++ Translator**
      * Implemented a simple source-to-source translator using Flex to convert basic Python syntax (like `print`, comments, and indentation-based blocks) into equivalent C++ code.

### HW3: Advanced Parsing with Lex/Yacc

This set of assignments involved using Flex and Bison (Yacc) together to solve more complex problems, including:

  * A stack-based machine simulator.
  * A matrix and function calculator.
  * Solving logic problems like the "Rails Station Problem".

This demonstrates experience in combining lexical and syntax analysis to build functional applications.

### `final`: A Complete Mini-Lisp Compiler

The final project integrates all learned concepts into a single, cohesive compiler for a custom "Mini-Lisp" language.

#### **Architecture**

```mermaid
graph TD
    A[Source Code (.lsp)] --> B(1. Lexer)
    B --> C(2. Parser)
    C --> D(3. Semantic Analyzer)
    D --> E(4. Code Generator)
    E --> F[Final Output]
```

#### **Modules**

1.  **Lexer**: Scans source code and produces tokens (implemented with Flex).
2.  **Parser**: Validates syntax against the language grammar and builds an Abstract Syntax Tree (AST) (implemented with Bison).
3.  **Semantic Analyzer**: Traverses the AST to perform type checking and scope resolution.
4.  **Code Generator**: Takes the validated AST and translates it into a lower-level representation.

#### **How to Run the Final Project**

```bash
# Navigate to the 'final' directory
cd final

# Generate and compile the source files (a Makefile would automate this)
bison -d -o final.tab.c final.y
gcc -c -g -I.. final.tab.c
flex -o lex.yy.c final.l
gcc -c -g -I.. lex.yy.c
gcc -o final final.tab.o lex.yy.o

# Run the compiler on an example file
./final < your_program.lsp
```

#### **Example Mini-Lisp Program**

```lisp
; Define a global variable
(define pi 3)

; Define a function to calculate the area of a circle
(fun circleArea (r)
  (* pi (* r r))
)

; Call the function and print the result
(print-num (circleArea 10))
```
