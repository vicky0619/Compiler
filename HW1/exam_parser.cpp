#include <iostream>

using namespace std;

bool correct = true;
int index = 0;
string texts = "";
string answer = "";
string input = "";

void stmt();
void Class();
void Func();
void args();
void arg();
void error()
{
    correct = false;
}

bool idU(char c)
{
    return (c >= 'A' && c <= 'Z');
}

bool idL(char c)
{
    return (c >= 'a' && c <= 'z');
}

bool isnum(char c)
{
    return (c >= '0' && c <= '9');
}

int main()
{
    while (cin >> input)
        texts += input;
    texts += '$';
    // cout << texts << endl;
    stmt();
    if (correct)
    {
        cout << answer;
    }
    else
        cout << "Invalid input" << endl;
}

void stmt()
{
    // cout << index << " " << answer;
    if (idU(texts[index]))
    {
        Class();
    }
    else if (texts[index] == '(')
    {
        // cout << 1 << endl;
        Func();
    }
    else
    {
        error();
    }
}

void Class()
{
    answer += "className ";
    answer += texts[index];
    answer += '\n';
    // cout<<answer<<endl;
    index++;
    if (texts[index] == '(')
    {
        answer += "leftParen (\n";
        index++;
        if (texts[index] == ')')
        {
            answer += "rightParen )\n";
            index++;
        }
        else
            error();
        args();
    }
    else
    {
        if (texts[index] == '$')
            ;
        else
            error();
    }
}
void Func()
{
    // cout<<"funcstart"<<answer<<endl;
    if (texts[index] == '(' || isnum(texts[index]))
    {
        if (texts[index] == '(')
        {
            answer += "leftParen (\n";
            index++;
        }
        // cout<<"add(:\n"<<answer<<endl;
        if (idL(texts[index]))
        {
            answer += "funcName ";
            answer += texts[index];
            answer += '\n';
            index++;
        }
        else
            error();
        // cout<<"addfuncname\n"<<answer<<endl;
        if ((isnum(texts[index]))||texts[index]=='(')
        {
            args();
        }
        // cout<<"addnum\n"<<answer<<endl;
        if (texts[index] == ')')
        {
            answer += "rightParen )\n";
            // cout<<1<<endl;
            index++;
            if(texts[index-1]=='(')
            {
                error();
            }
        }
        // if (texts[index] == '('&&idL(texts[index-1]))
        // {
        //     error();
        // }
    }
    else if (texts[index] == ')')
    {
        answer += "rightParen )\n";
        index++;
    }
    else
    {
        if (texts[index] == '$')
            ;
        else
            error();
    }
}
void args()
{
    if (texts[index] == ')' || isnum(texts[index]) || texts[index] == '(')
    {
        arg();
        args();
    }
    else
    {
        if (texts[index] == '$')
            ;
        else
            error();
    }
}

void arg()
{
    if (isnum(texts[index]))
    {
        answer += "num ";
        answer += texts[index];
        answer += '\n';
        index++;
    }
    else{
        Func();
    }
    // cout<<"hi"<<endl;
    
}