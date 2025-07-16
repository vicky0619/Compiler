%{
#include<stdio.h>
int count = 0;
int hash = 0;
int indexs = 0;
char url_name[100];
int start = 0;
%}

hashtag [#]+[^\n]*
hr ---[\n]*
img ^![^\n]*$
choice ^.*\-[ ]\[.*$
url ^.*\[[^\n]*$
quote ^>[^\n]*$
list ^\*[ ][^\n]*$
eol \n

%%

{hashtag} {
    hash=0;
    count=0;
    while(1)
    {
        if(yytext[count]!='#')
        {
            break;
        }
        count++;
    }
    hash=count;
    printf("<h%d>",hash);
    for(indexs = count+1;indexs<yyleng;indexs++)
    {
        printf("%c",yytext[indexs]);
    }
    printf("</h%d>",hash);
    }
{hr} {
       if(start==1)
       {
               start=0;
               printf("</ul>\n");
       }
       else if(start==2)
      {
                start=0;
               printf("</blockquote>\n");
       }
      printf("<hr />\n"); 
      start=0;
}
{img} {
    printf("<img alt=\"");
    for(indexs =2;yytext[indexs]!=']';indexs++)
    {
        printf("%c",yytext[indexs]);
    }
    printf("\" src=\"");
    for(indexs =indexs+2;yytext[indexs]!=')';indexs++)
    {
        printf("%c",yytext[indexs]);
    }
    printf("\">");
}
{choice} {
    printf("<p>\n\t<input ");
    if(yytext[3]=='X')
    {
        printf("checked=\"checked\" ");
    }
    printf("type=\"checkbox\" /> ");
    for(indexs =6;indexs<yyleng;indexs++)
    {
        printf("%c",yytext[indexs]);
    }
    printf("\n</p>");
}
{url} {
    for(indexs = 0;indexs<100;indexs++)
    {
        url_name[indexs]='$';
    }
    for(indexs =1;yytext[indexs]!=']';indexs++)
    {
          url_name[indexs-1]=yytext[indexs];
    }
    printf("<a href=\"");
    for(indexs=indexs+1;yytext[indexs]!=')';indexs++)
    {
        printf("%c",yytext[indexs]);
    }
    printf("\">\n");
    printf("\t<span>");
    for(count=0;url_name[count]!='$';count++)
    {
        printf("%c",url_name[count]);
    }
    printf("</span>\n");
    printf("</a>");
}
{list} {
     if(start==0)
     {
           printf("<ul>\n");
           start = 1;
     }
     printf("\t<li>");
     for(indexs =1;indexs<yyleng;indexs++)
    {
            printf("%c",yytext[indexs]);
    }
    printf("</li>");
}
{quote} {
    if(start==0)
    {
        printf("<blockquote>\n");
        start = 2;    
    }
     count=0;
     for(indexs=2; indexs<yyleng;indexs++)
      {
             if(yytext[indexs]=='*')
             {
                       count+=1;
                        if(count==2)
                        {
                                  printf("<strong>");
                         }
                        else if(count==4)
                        {
                                  printf("</strong>");
                        } 
              }
              else
              {
                      printf("%c",yytext[indexs]);
               }
      }
    // printf("\n");
}
{eol} {
    printf("\n");
}
. {}


%%

int main(void)
{
    yylex();
    return 0;
}