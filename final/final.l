%{
#include "final.tab.h"
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

%}
letter [a-z]
digit  [0-9]
%%
0|[1-9]{digit}*|-[1-9]{digit}*              {yylval.ival=atoi(yytext);return NUMBER;}
"#t"                                        {yylval.ival=1; return BOOL;}
"#f"                                        {yylval.ival=0; return BOOL;}
"define"                                    {return DEFINE;}
"fun"                                    	{return LAMBDA;}
"if"                                        {return IF;}
"print-num"                                 {return PRINTNUM;}
"print-bool"                                {return PRINTBOOL;}
"mod"                                       {return yytext[0];}
"and"                                       {return yytext[0];}
"or"                                        {return yytext[0];}
"not"                                       {return yytext[0];}
{letter}({letter}|{digit}|\-)*              {yylval.id=strdup(yytext);return ID;}
[\+\-\*\/\(\)\>\<\=]                        {return yytext[0];}
[\t\n\r ]                                   {}
.                                           {}
%%
int yywrap(void){
    return 1;
}
