%{
    #include "fc.tab.h"    
%}

%option noyywrap

number -?[0-9]+(.[0-9]+)?

%%

"f" return FFUNC;
"g" return GFUNC;
"h" return HFUNC;
{number} {yylval.dval = atof(yytext); return NUMBER;}
"(" return LPAREN;
")" return RPAREN;
"," return COMMA;

%%
