%{
#include<stdio.h>
int tab_count=0;
int idx;
%}
Left    ^.*\{.*$
Right   ^.*\}.*$
QQ     ^\t*.*$
%%
{Left}  {
    for(idx=0;idx<tab_count;idx++)
        printf("\t");
    for(idx=0;idx<yyleng;idx++)
    {
         if(yytext[idx]!='\t')
        {
               break;
        }
    }

            //continue;
    for(;idx<yyleng;idx++){
        printf("%c",yytext[idx]);
    }
    printf("\n");

    tab_count++;
}
{Right} {
    tab_count--;
    for(idx=0;idx<tab_count;idx++)
        printf("\t");
    for(idx=0;idx<yyleng;idx++)
    {
         if(yytext[idx]!='\t')
        {
               break;
        }
   }

    for(;idx<yyleng;idx++){
        printf("%c",yytext[idx]);
    }
    printf("\n");
}
\n  {
    if(yyleng==1 && yytext[0]=='\n')
    {  
        //printf("match%s","$$");   
        //printf("\n");
    }        
}
{QQ} {
    for(idx=0;idx<tab_count;idx++)
        printf("\t");
    for(idx=0;idx<yyleng;idx++)
        if(yytext[idx]!='\t')
            break;
    for(;idx<yyleng;idx++){
        printf("%c",yytext[idx]);
    }
    printf("\n");
}
%%
int main(){
    yylex();
    return 0;
}
