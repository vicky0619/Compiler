%{
#include<stdio.h>
%}

ATMd   [$][1-9][0-9][0-9][0-9][0-9][0-9]+
ATMa   [$][1-9][0-9]{0,4}
ATMc   [$]0
Datea  \+[1-9][0-9][0-9][0-9]+|\+[4-9][0-9][0-9]|\+[3][7-9][0-9]|\+[3][6][6-9]
Dateb   \+[1-9]|\+[1-9][0-9]|\+[1-2][0-9][0-9]|\+[3][0-5][0-9]|\+[3][6][0-5]
Time  [0-1][0-9][:][0-5][0-9]|[2][0-3][:][0-5][0-9]
Place [A-Z][a-z.-]+[A-Z]
%%
{ATMd} {
    if(yytext=="100000")
    {
        printf("transfer %s\n",yytext);
    }
}
{ATMa} {printf("transfer %s\n",yytext); }
{ATMc} {printf("transfer %s\n",yytext); }
{Datea} {}
{Dateb} {printf("after %s\n",yytext);}
{Place} {printf("at %s\n",yytext);}
{Time} {printf("at %s\n",yytext);}
.
\n

%%

int main(void)
{
    yylex();
    return 0;
}