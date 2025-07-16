%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int yylex();
void semantic_error(int col);
void yyerror(const char *message);
%}
%union {
	int ivalue;
    struct def{
        int i;
        int j;
    }matr;
}
%type <matr> matrix
%type <matr> expr
%token <ivalue> NUM 

%left<ivalue> ADD_MINUS
%left<ivalue> MUL
%right TRS



%%
input : expr { printf( "Accepted\n"); return 0; /*printf("%d %d\n",$1.i,$1.j); */}
	; 

expr : expr ADD_MINUS expr	
		{ 
			if($1.i==$3.i && $1.j == $3.j)
			{
				$$=$1;
			}
			else{
				semantic_error($2);
				return 0;
			}
	 	}
	| expr MUL expr	{ 
			if($1.j==$3.i)
			{
				$$.i=$1.i;
				$$.j=$3.j;
			}
			else{
				semantic_error($2);
				return 0;
			}
		}
	| expr TRS	{ $$.i=$1.j; $$.j=$1.i; }
	| '(' expr ')' {$$=$2; }
	| matrix
   ; 
matrix : '[' NUM ',' NUM ']'  { $$.i= $2; $$.j=$4;}
	;
%%
void yyerror ( const char *message )
{
	//correct = 0;
    fprintf (stderr, "%s\n",message);
	
}
void semantic_error(int col){
    printf("Semantic error on col %d\n", col);
}
int main(int argc, char *argv[]) {
    yyparse();
    return(0);
}