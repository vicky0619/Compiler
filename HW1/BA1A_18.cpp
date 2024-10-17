/*
Productions
1 program → stmts
2 stmts → stmt stmts
3 stmts → λ
4 stmt → exp SEMICOLON
5 exp → primary
6 exp → STRLIT
7 exp → λ
8 primary → ID primary_tail
9 primary_tail → DOT ID primary_tail
10 primary_tail → LBR exp RBR primary_tail
11 primary_tail → λ
*/
#include <iostream>
#include <cstdio>
#include <queue>
#include <iterator>
#include <sstream>
#include <vector>

typedef struct
{
    std::string value;
    std::string type;
} Token;

std::queue<Token> Scan(void);
bool is_digit(char);
bool is_letter(char);
void Match(const Token &, const std::string &);
void Program(std::queue<Token> &);
void Stmts(std::queue<Token> &);
void Stmt(std::queue<Token> &);
void Exp(std::queue<Token> &);
void Primary(std::queue<Token> &);
void Primary_Tail(std::queue<Token> &);
void Error(const std::string &);

bool has_error = false;
char codes[1000000];
int codes_idx;
std::vector<Token> ans;

int main(void)
{
    std::string word;
    Token ts;
    std::queue<Token> tokens;
    int i = 0;
    codes_idx = 0;
    while (std::scanf("%c", &codes[i++]) != EOF)
        ;
    tokens = Scan();

    Program(tokens);

    if (!has_error)
        for (auto ts : ans)
            std::cout << ts.type << " " << ts.value << std::endl;

    return 0;
}

std::queue<Token> Scan(void)
{
    std::queue<Token> res;
    Token ts;
    while (codes[codes_idx] != '\0')
    {
        if (codes[codes_idx] <= ' ' || codes[codes_idx] == '\n')
            codes_idx++;
        else if (codes[codes_idx] == '(')
        {
            ts.value = '(';
            ts.type = "LBR";
            res.push(ts);
            codes_idx++;
        }
        else if (codes[codes_idx] == ')')
        {
            ts.value = ')';
            ts.type = "RBR";
            res.push(ts);
            codes_idx++;
        }
        else if (codes[codes_idx] == '.')
        {
            ts.value = '.';
            ts.type = "Dot";
            res.push(ts);
            codes_idx++;
        }
        else if (codes[codes_idx] == ';')
        {
            ts.value = ';';
            ts.type = "SEMICOLON";
            res.push(ts);
            codes_idx++;
        }
        else if (codes[codes_idx] == '\"')
        {
            codes_idx++;
            std::string s = "";
            while (codes[codes_idx] != '\"' && codes[codes_idx] != '\0')
            {
                s += codes[codes_idx];
                codes_idx++;
            }
            if (codes[codes_idx] == '\"')
            {
                codes_idx++;
                ts.value = "\" " + s + " \"";
                ts.type = "STRLIT";
            }
            else
            {
                ts.value = "\" " + s;
                ts.type = "err";
            }
            res.push(ts);
        }
        else if (is_letter(codes[codes_idx]) || codes[codes_idx] == '_')
        {
            std::string s = "";
            s += codes[codes_idx];
            codes_idx++;
            while (is_digit(codes[codes_idx]) || is_letter(codes[codes_idx]) || codes[codes_idx] == '_')
            {
                s += codes[codes_idx];
                codes_idx++;
            }
            ts.value = s;
            ts.type = "ID";
            res.push(ts);
        }
        else
        {
            ts.value = codes[codes_idx];
            ts.type = "err";
            res.push(ts);
            codes_idx++;
        }
    }
    return res;
}

bool is_digit(char c)
{
    return (c >= '0' && c <= '9');
}

bool is_letter(char c)
{
    return ((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z'));
}

void Match(const Token &ts, const std::string &type_name)
{
    if (ts.type != type_name && !has_error)
        Error("Match");
    else
        ans.push_back(ts);
}

void Program(std::queue<Token> &tokens)
{
    if (tokens.empty())
        return;
    if (tokens.front().type == "STRLIT" || tokens.front().type == "ID" || tokens.front().type == "SEMICOLON")
        Stmts(tokens);
    else
        Error("Program");
}
void Stmts(std::queue<Token> &tokens)
{
    if (tokens.empty())
        return;
    if (tokens.front().type == "STRLIT" || tokens.front().type == "ID" || tokens.front().type == "SEMICOLON")
    {
        Stmt(tokens);
        Stmts(tokens);
    }
    else
    {
        Error("Stmts");
    }
}
void Stmt(std::queue<Token> &tokens)
{
    if (tokens.front().type == "STRLIT" || tokens.front().type == "ID" || tokens.front().type == "SEMICOLON")
    {
        Exp(tokens);
        if (tokens.empty())
        {
            Error("EMPTY");
            return;
        }
        Match(tokens.front(), "SEMICOLON");
        tokens.pop();
    }
    else
        Error("Stmt");
}
void Exp(std::queue<Token> &tokens)
{
    if (tokens.empty())
        return;
    else if (tokens.front().type == "STRLIT")
    {
        Match(tokens.front(), "STRLIT");
        tokens.pop();
    }
    else if (tokens.front().type == "ID")
    {
        Primary(tokens);
    }
    else if (tokens.front().type == "err")
        Error("Exp");
}
void Primary(std::queue<Token> &tokens)
{
    if (tokens.front().type == "ID")
    {
        Match(tokens.front(), "ID");
        tokens.pop();
        Primary_Tail(tokens);
    }
    else
        Error("Primary");
}
void Primary_Tail(std::queue<Token> &tokens)
{
    if (tokens.empty())
        return;
    if (tokens.front().type == "Dot")
    {
        Match(tokens.front(), "Dot");
        tokens.pop();
        if (tokens.empty())
        {
            Error("EMPTY");
            return;
        }
        Match(tokens.front(), "ID");
        tokens.pop();
        Primary_Tail(tokens);
    }
    else if (tokens.front().type == "LBR")
    {
        Match(tokens.front(), "LBR");
        tokens.pop();
        Exp(tokens);
        if (tokens.empty())
        {
            Error("EMPTY");
            return;
        }
        Match(tokens.front(), "RBR");
        tokens.pop();
        Primary_Tail(tokens);
    }
    else if (tokens.front().type == "err")
        Error("Primary_Tail");
}
void Error(const std::string &msg)
{
    if (!has_error)
    {
        has_error = true;
        std::cout << "invalid input" << std::endl;
        exit (EXIT_SUCCESS);
    }
}
