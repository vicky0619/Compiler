#include <bits/stdc++.h>
using namespace std;

// Function to tokenize and print each character immediately
void tokenizeAndPrint() {
    char c;
    while (cin.get(c)) {
        // Skip spaces and newlines
        if (isspace(c)) {
            continue;
        }

        // Handle single digits as NUM tokens
        if (isdigit(c)) {
            string number;
            number += c;

            // Read all subsequent digits to form the full number
            while (cin.peek() != EOF && isdigit(cin.peek())) {
                number += cin.get();
            }
            cout << "NUM " << number << endl;
        } else {
            // Handle other single-character tokens
            switch (c) {
                case '+':
                    cout << "PLUS" << endl;
                    break;
                case '-':
                    cout << "MINUS" << endl;
                    break;
                case '*':
                    cout << "MUL" << endl;
                    break;
                case '/':
                    cout << "DIV" << endl;
                    break;
                case '(':
                    cout << "LPR" << endl;
                    break;
                case ')':
                    cout << "RPR" << endl;
                    break;
                default:
                    cerr << "Unexpected character: " << c << endl;
                    break;
            }
        }
    }
}

int main() {
    // Directly read and tokenize input as it is encountered
    tokenizeAndPrint();
    return 0;
}
