/*
波蘭表示法
*/

#include <iostream>
#include <queue>

typedef struct
{
    std::string value;
    std::string type;
} Token;

bool is_digit(char);
bool is_operation(char);
void Error(std::string);
std::queue<Token> ReadFormula(std::string);
int EvalFormula(std::queue<Token> &);
int Prog(std::queue<Token> &);
int Exps(std::queue<Token> &);
int Exp(std::queue<Token> &);

bool has_error = false;

int main(void)
{
    std::cout << "Welcome use our calculator!" << std::endl;
    std::string line;
    std::cout << "> ";
    while (std::getline(std::cin, line))
    {
        if (line.empty())
        {
            has_error = false;
            std::cout << "> ";
            continue;
        }

        auto tokens = ReadFormula(line);

        if (!has_error)
        {
            if (!tokens.empty())
            {
                auto result = EvalFormula(tokens);
                if (!tokens.empty())
                    Error("Illegal formula!");
                if (!has_error)
                    std::cout << result << std::endl;
            }
        }
        if (std::cin.eof())
            break;
        has_error = false;
        std::cout << "> ";
    }
    std::cout << "ByeBye~" << std::endl;
    return 0;
}

std::queue<Token> ReadFormula(std::string line)
{
    std::queue<Token> res;
    Token ts;
    std::string::size_type i = 0;
    while (i < line.size())
    {
        if (line[i] <= ' ')
        {
            i++;
            continue;
        }
        else if ((line[i] == '+' && is_digit(line[i + 1])) || (line[i] == '-' && is_digit(line[i + 1])) || is_digit(line[i]))
        {
            std::string s = "";

            s += line[i++];
            while (is_digit(line[i]))
                s += line[i++];
            if (!(is_operation(line[i]) || line[i] <= ' '))
            {
                while (i < line.size() && line[i] > ' ' && line[i] <= '~')
                    s += line[i++];
                Error("Unknown token " + s);
                continue;
            }
            ts.value = s;
            ts.type = "INT";
            res.push(ts);
            continue;
        }
        else if (is_operation(line[i]))
        {
            ts.value = line[i];
            ts.type = "OPERATOR";
            res.push(ts);
            i++;
            continue;
        }
        else if (line[i] == '\n')
        {
            ts.value = line[i];
            ts.type = "LINEENTER";
            res.push(ts);
            i++;
            continue;
        }
        else
        {
            std::string s = "";
            while (i < line.size() && line[i] > ' ')
                s += line[i++];
            Error("Unknown token " + s);
        }
    }
    return res;
}

int EvalFormula(std::queue<Token> &tokens)
{
    return Prog(tokens);
}

int Prog(std::queue<Token> &tokens)
{
    return Exps(tokens);
}

int Exps(std::queue<Token> &tokens)
{
    return Exp(tokens);
}

int Exp(std::queue<Token> &tokens)
{
    if (tokens.empty())
    {
        Error("Illegal formula!");
        return 99999;
    }
    if (tokens.front().type == "INT")
    {
        int num = std::stoi(tokens.front().value);
        tokens.pop();
        return num;
    }
    if (tokens.front().type == "OPERATOR")
    {
        if (tokens.front().value == "+")
        {
            tokens.pop();
            return Exp(tokens) + Exp(tokens);
        }
        if (tokens.front().value == "-")
        {
            tokens.pop();
            return Exp(tokens) - Exp(tokens);
        }
        if (tokens.front().value == "*")
        {
            tokens.pop();
            return Exp(tokens) * Exp(tokens);
        }

        // divisor case
        tokens.pop();
        int first = Exp(tokens);
        int second = Exp(tokens);
        if (second == 0)
        {
            Error("Divide by ZERO!");
            return 99999;
        }
        return first / second;
    }
    Error("Illegal formula!");
    return 99999;
}

bool is_digit(char c)
{
    return (c >= '0' && c <= '9');
}
bool is_operation(char c)
{
    return (c == '+' || c == '-' || c == '*' || c == '/');
}
void Error(std::string msg)
{
    if (!has_error)
        std::cout << "Error: " << msg << std::endl;
    has_error = true;
}