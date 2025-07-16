%{
#include <stdio.h>
#include <string.h>
#include <math.h>

int consequence;
int correct = 1;
int yylex();
void yyerror(const char *message);
%}
%union {
	int ivalue;
}
%token LOAD
%token ADD
%token SUB
%token MUL
%token MOD
%token INC
%token DEC
%token <ivalue> INUMBER
%type <ivalue> exp

%%
input : exp { consequence = $1; }
	; 
exp : LOAD INUMBER	{ $$ = $2; }
	| exp exp ADD	{ $$ = $2 + $1; }
	| exp exp SUB	{ $$ = $2 - $1; }
	| exp exp MUL	{ $$ = $2 * $1; }
	| exp exp MOD	{ $$ = $2 % $1; }
	| exp INC	{ $$ = $1 + 1 ; }
	| exp DEC	{ $$ = $1 - 1 ; }
   ; 
%%
void yyerror ( const char *message )
{
	correct  = 0;
}
int main(int argc, char *argv[]) {
    yyparse();
	if ( correct  == 1 ) {
		printf( "%d\n", consequence);
	}
	else {
		printf ( "Invalid format\n" );
	} 
    return(0);
}