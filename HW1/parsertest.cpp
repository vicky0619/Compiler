#include <iostream>
#include <string>

using namespace std;

bool isValid = true;
int pos=0;
string inputText="";
string ans="";

void stmts();
void stmt();
void primary();
void primary_tail();
void error();

void error(){
    isValid=false;
}

bool isIDstart(char c){
    return (c=='_' || (c>='A' && c<='Z') || (c>='a' && c<='z'));
}

bool isIDchar(char c){
    return (c=='_' || (c>='A' && c<='Z') || (c>='a' && c<='z') || (c>='0' && c<='9'));
}

void primary_tail(){
    if(inputText[pos]=='.'){
        ans += "DOT .\n";
        pos++;
        if(inputText[pos]!='.'){
            ans+="ID ";
            while(isIDchar(inputText[pos])){
                ans+=inputText[pos];
                pos++;
            }
            ans+="\n";
            primary_tail();
        }
        else error();
    }
    else if((inputText[pos]=='(')){
            ans+="LBR (\n";
            pos++;
            stmt();
            ans+="RBR )\n";
            pos++;
            primary_tail();
    }
    else if(inputText[pos]=='$' || inputText[pos]==')' ||inputText[pos]=='"' ||inputText[pos]==' ') ;
    else error();
}

void primary(){
    ans+="ID ";
    while(isIDchar(inputText[pos])){
        ans+=inputText[pos];
        pos++;
    }
    ans+="\n";
    primary_tail();
}

void stmt(){
    if(isIDstart(inputText[pos])){
        primary();
    }
    else if(inputText[pos]==' ') pos++;
    else if(inputText[pos]=='"'){
        ans+="STRLIT \"";
        pos++;
        while(inputText[pos]!='"'){
            ans += inputText[pos];
            pos++;
        }
        ans+="\"\n";
        pos++;
    }
    else if(inputText[pos]=='$' || inputText[pos]==')' ||inputText[pos]=='"' ) ;
    else error();
}

void stmts(){
    if(isIDstart(inputText[pos]) || inputText[pos]=='"'){
        stmt();
        stmts();
    }
    else if(inputText[pos]==' '){
        pos++;
        stmts();
    }
    else if(inputText[pos]=='$' || inputText[pos]==')' || inputText[pos]=='"') ;
    else error();
}

int main(){
    string line;
    while(getline(cin, line)){
        inputText+= line + " ";
    }
    inputText+="$";
    stmts();
    if(isValid) cout << ans;
    else cout << "invalid input\n";
    return 0;
}