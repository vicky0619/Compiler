%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <math.h>     

    int yylex();
    void yyerror(char *s);
%}

%union{
    double dval;
}

%type <dval> expr term
%token <num> NUMBER 
%token FFUNC GFUNC HFUNC LPAREN RPAREN COMMA

%%

program : line { 
                if(top == 0)
                    printf("%.1f\n", peek());
                else
                    yyerror();
            }
        ;

line : terms

terms : term terms
        | term
        ;
        
term :  FFUNC { $$ = $1; }
        | LPAREN expr RPAREN {$$ = $2*4 -1; }
        | LPAREN expr COMMA expr RPAREN {$$ = $2*2 + $4 -5; }
        | LPAREN expr COMMA expr COMMA expr RPAREN {$$ = $2*3 - $4*5 + $6; }
        ;
%%

void yyerror(char *s){
    fprintf(stderr, "%s\n", s);
}

int main(){
    yyparse();
    return 0;
}