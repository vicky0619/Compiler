%{
#include "3B.tab.h"
int col=0;
%}

%%
\n        {}
[ \t]+	  {col+=yyleng;}
[0-9]+	{ col+=yyleng; yylval.ivalue = atoi(yytext); return( NUM ); }
"^T" {col+=yyleng; return TRS;}
"+"|"-" {col+=yyleng; yylval.ivalue=col; return ADD_MINUS;}
"*" {col+=yyleng; yylval.ivalue=col; return MUL;}
"["|"]"|"("|")"|","	{ col+=yyleng; return yytext[0]; }
.		{ return( yytext[0] ); }
%%