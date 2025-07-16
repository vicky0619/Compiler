#include <bits/stdc++.h>
using namespace std;

bool isIDStart(char c){
    return (c>='A' && c<='Z') || (c>='a' && c<='z');
}

bool isIDChar(char c){
    return (c>='A' && c<='Z') || (c>='a' && c<='z') || (c>='0' && c<='9');
}

bool isSymbol(char c){
    return (c=='+' || c=='-' || c=='*' || c=='/' || c=='=' || c=='(' || c==')' || c=='{' || c=='}' || c=='<' || c=='>' || c==';');
}

void tokenizeAndPrint() {
    char c;
    while (cin.get(c)) {
        //cout << "c is:" << c << endl;
        if (isspace(c)) {
            continue;
        }
        if (c=='0'){
            cout << "NUM \"0\"\n";
            continue;
        }
        if (isdigit(c)) {
            string number;
            number += c;
            while (cin.peek() != EOF && isdigit(cin.peek())) {
                number += cin.get();
            }
            cout << "NUM \"" << number << "\"\n";
        } 
        else if(c=='w'){
            //cout << "c is w:" << c << endl;
            if(cin.peek()=='h'){
                cin.get();
                if(cin.peek()=='i'){
                    cin.get();
                    if(cin.peek()=='l'){
                        cin.get();
                        if(cin.peek()=='e'){
                            cin.get();
                            cout << "KEYWORD \"while\"" << "\n";
                        }
                        else{
                            string id;
                            id += "whil";
                            while(cin.peek() != EOF && isIDChar(cin.peek())){
                                id += cin.get();
                            }
                        cout << "IDENTIFIER \"" << id << "\"\n";
                        }
                    }
                    else{
                        string id;
                        id += "whi";
                        while(cin.peek() != EOF && isIDChar(cin.peek())){
                            id += cin.get();
                        }
                        cout << "IDENTIFIER \"" << id << "\"\n";
                    }
                }
                else{
                    string id;
                    id += "wh";
                    while(cin.peek() != EOF && isIDChar(cin.peek())){
                        id += cin.get();
                    }
                    cout << "IDENTIFIER \"" << id << "\"\n";
                }
            }
            else{
                string id;
                id += "w";
                while(cin.peek() != EOF && isIDChar(cin.peek())){
                    id += cin.get();
                }
                cout << "IDENTIFIER \"" << id << "\"\n";
            }
        }
        else if(c=='i'){
            if(cin.peek()=='f'){
                cout << "KEYWORD \"if\"" << "\n";
                cin.get();
            }
            else{
                cout << "IDENTIFIER \"i\"" << "\n";
            }
        }
        
        else if(isIDStart(c)){
            string id;
            id += c;
            while(cin.peek() != EOF && isIDChar(cin.peek())){
                id += cin.get();
            }
            cout << "IDENTIFIER \"" << id << "\"\n";
        }
        else if(isSymbol(c)){
            cout << "SYMBOL \"" << c << "\"\n";
        }
        else{
            cout << "Invalid\n";
        }
    }
}

int main() {
    tokenizeAndPrint();
    return 0;
}
