%{
#include<stdio.h>
int idx;
%}
INTERGER    ^[0-9]+$
FLOAT    ^[0-9]+\.[0-9]+$
STRING     ^("([^"\n]|')*"|'([^'\n]|")*')$
BOOLEAN   ^[true|false]$
OPERATION   ^[0-9]+[0-9+\-*/]*[+\-*/][0-9+\-*/]*$
INVALID ^\t*.*$
%%
{INTERGER}  {
    for(idx=0;idx<yyleng;idx++){
        if(yytext[idx]=='\t' || yytext[idx]=='\n') break;
        printf("%c",yytext[idx]);
    }
    printf(" INTERGER\n");
}
{FLOAT}  {
    for(idx=0;idx<yyleng;idx++){
        if(yytext[idx]=='\t' || yytext[idx]=='\n') break;
        printf("%c",yytext[idx]);
    }
    printf(" FLOAT\n");
}
{STRING}  {
    for(idx=0;idx<yyleng;idx++){
        if(yytext[idx]=='\t' || yytext[idx]=='\n') break;
        printf("%c",yytext[idx]);
    }
    printf(" STRING\n");
}
{BOOLEAN}  {
    for(idx=0;idx<yyleng;idx++){
        if(yytext[idx]=='\t' ||yytext[idx]=='\n') break;
        printf("%c",yytext[idx]);
    }
    printf(" BOOLEAN\n");
}
{OPERATION}  {
    for(idx=0;idx<yyleng;idx++){
        if(yytext[idx]=='\t' ||yytext[idx]=='\n') break;
        printf("%c",yytext[idx]);
    }
    printf(" OPERATION\n");
}
{INVALID}  {
    for(idx=0;idx<yyleng;idx++){
        printf("%c",yytext[idx]);
    }
    printf(" INVALID\n");
}
%%
int main(){
    yylex();
    return 0;
}

