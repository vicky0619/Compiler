

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
    primary();
}

void stmts(){
    while(inputText[pos]!='$'){
        stmt();
    }
}

int main(){
    string line;
    while(getline(cin,line)){
        inputText+= line+' ';
    }
    inputText+="$";
    stmts();
    if(isValid){
        cout<<ans;
    }
    else{
        cout<<"invalid output"<<endl;
    }

    return 0;
}