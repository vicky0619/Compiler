#include <iostream>
#include <string>

using namespace std;

string ans = "";
bool isValid = true;

void stmt();
void mail();
void uri();
void error();

void error() {
    ans = "";
    isValid = false;
}

bool isPhoneStart(char a, char b) {
    return (a == '0' && b == '9');
}

bool isPhoneChar(char c) {
    return (c >= '0' && c <= '9');
}

bool isPath(char c) {
    return (c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9');
}

bool isMailDomain(string domain) {
    return (domain == "gmail" || domain == "yahoo" || domain == "iCloud" || domain == "outlook");
}

bool isDomain(string domain) {
    return (domain == "org" || domain == "com");
}

bool isScheme(string scheme) {
    return (scheme == "https" || scheme == "tel" || scheme == "mailto");
}

void mail() {
    char c = cin.get();
    string path = "";

    // Parse the path part before @
    if (isPath(c)) {
        path += c;
        while (isPath(cin.peek())) {
            path += cin.get();
        }
        ans += path + " PATH\n";
    } else {
        error();
        return;
    }

    c = cin.get();
    if (c == '@') {
        ans += "@ AT\n";
    } else {
        error();
        return;
    }

    string mailDomain = "";
    c = cin.get();
    if (isPath(c)) {
        mailDomain += c;
        while (isPath(cin.peek())) {
            mailDomain += cin.get();
        }
        if (isMailDomain(mailDomain)) {
            ans += mailDomain + " MAILDOMAIN\n";
        } else {
            error();
            return;
        }
    } else {
        error();
        return;
    }

    c = cin.get();
    if (c == '.') {
        ans += ". DOT\n";
    } else {
        error();
        return;
    }

    string domain = "";
    c = cin.get();
    if (isPath(c)) {
        domain += c;
        while (isPath(cin.peek())) {
            domain += cin.get();
        }
        if (isDomain(domain)) {
            ans += domain + " DOMAIN\n";
        } else {
            error();
            return;
        }
    } else {
        error();
    }
}

void stmt() {
    char c = cin.get();

    if (isPath(c)) {
        string path = "";
        path += c;
        while (isPath(cin.peek())) {
            path += cin.get();
        }
        ans += path + " PATH\n";

        c = cin.get();
        if (c == '@') {
            ans += "@ AT\n";
            mail();
        } else {
            error(); 
        }
    }
    else {
        error();
    }
}

int main() {
    stmt();
    if (isValid) {
        cout << ans;
    } else {
        cout << "Invalid input\n";
    }
    return 0;
}
