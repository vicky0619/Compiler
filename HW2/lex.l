%{
#include<stdio.h>
int tab_count=0;
int index;
%}
Left    ^.*\{.*$
Right   ^.*\}.*$
QQ     ^\t*.*$
%%
{Left}  {
    for(index=0;index<tab_count;index++)
        printf("\t");
    for(index=0;index<yyleng;index++)
    {
         if(yytext[index]!='\t')
        {
               break;
        }
    }

            //continue;
    for(;index<yyleng;index++){
        printf("%c",yytext[index]);
    }
    printf("\n");

    tab_count++;
}
{Right} {
    tab_count--;
    for(index=0;index<tab_count;index++)
        printf("\t");
    for(index=0;index<yyleng;index++)
    {
         if(yytext[index]!='\t')
        {
               break;
        }
   }

    for(;index<yyleng;index++){
        printf("%c",yytext[index]);
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
    for(index=0;index<tab_count;index++)
        printf("\t");
    for(index=0;index<yyleng;index++)
        if(yytext[index]!='\t')
            break;
    for(;index<yyleng;index++){
        printf("%c",yytext[index]);
    }
    printf("\n");
}
%%
int main(){
    yylex();
    return 0;
}