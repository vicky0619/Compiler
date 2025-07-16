%{
    #include "rsp.tab.h"
%}


%option noyywrap

real_number [1-9][0-9]*

%%

"0" return END;
{real_number} { yylval.dval = atof(yytext); return NUMBER;}
[ \t\n] {}
. {}

%%