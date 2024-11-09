#include <iostream>
#include <vector>
#include <map>
#include <set>

using namespace std;

map<char, vector<string>> grammar;
map<char, set<char>> first_set;
char here;

bool nonterminal(char c)
{
    return (c >= 'A' && c <= 'Z');
}

bool terminal(char c)
{
    return (c >= 'a' && c <= 'z');
}

void FindFirstSet(char chr)
{
    for (int i = 0; i < grammar[chr].size(); i++)
    {
        set<char> tmp_grammar;
        for (int j = 0; j < grammar[chr][i].size(); j++)
        {
            set<char> tmp_first;
            char here = grammar[chr][i][j];
            if (terminal(here) || here == '$' || here == ';')
            {
                tmp_first.insert(here);
            }
            else if (nonterminal(here))
            {
                if (first_set.find(here) == first_set.end())
                    FindFirstSet(here);
                tmp_first.insert(first_set[here].begin(), first_set[here].end());
            }
            tmp_grammar.insert(tmp_first.begin(), tmp_first.end());
            if (tmp_first.find(';') != tmp_first.begin())
            {
                tmp_grammar.erase(';');
                break;
            }
        }
        first_set[chr].insert(tmp_grammar.begin(), tmp_grammar.end());
    }
}

int main()
{
    char chr;
    string ipt;
    string text;
    string tmp;
    while (1)
    {
        cin >> chr >> ipt;
        if (ipt == "ND_OF_GRAMMAR")
        {
            break;
        }
        for (int index = 0; index < ipt.length(); index++)
        {
            if (ipt[index] != '|')
            {
                tmp += ipt[index];
            }
            else
            {
                grammar[chr].push_back(tmp);
                tmp = "";
            }
        }
        grammar[chr].push_back(tmp);
        tmp = "";
    }
    for (char chr = 'A'; chr <= 'Z'; chr++)
    {
        if (first_set.find(chr) == first_set.end())
        {
            FindFirstSet(chr);
        }
    }
    for (char chr = 'A'; chr <= 'Z'; chr++)
    {
        if (first_set.find(chr) != first_set.end())
        {
            cout << chr << " ";
            for (set<char>::iterator i = first_set[chr].begin(); i != first_set[chr].end(); i++)
                cout << *i;
            cout << endl;
        }
    }
    cout << "END_OF_FIRST" << endl;
}
