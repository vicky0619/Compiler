%{
    int indent = 0;
%}

%x SINGLE_COMMENT
%x MULTI_COMMENT
%x PRINT_STATE

%%

"# " {
    BEGIN SINGLE_COMMENT; 
    printf("// ");
}

<SINGLE_COMMENT>. {
    ECHO;
}

<SINGLE_COMMENT>\n[\t]* {
    BEGIN INITIAL;
    if (yyleng - 1 == indent) {
        ECHO;
    } else {
        while (yyleng - 1 < indent) {
            indent -= 1;
            for (int i = 0; i < indent; i++) {
                printf("\t");
            }
            printf("}\n");
        }
    }
}

"\"\"\"" {
    BEGIN MULTI_COMMENT; 
    printf("/*");
}

<MULTI_COMMENT>.|\n {
    ECHO;
}

<MULTI_COMMENT>"\"\"\"" {
    BEGIN INITIAL; 
    printf("*/");
}

"print(" {
    BEGIN PRINT_STATE; 
    printf("cout << ");
}

<PRINT_STATE>\"[^\"\n]*\" {
    ECHO;
}

<PRINT_STATE>[0-9]+ {
    ECHO;
}

<PRINT_STATE>")" {
    BEGIN INITIAL; 
    printf(" << endl;");
}

"if True:\n" {
    indent += 1; 
    printf("if(true) {\n");
}

"if False:\n" {
    indent += 1; 
    printf("if(false) {\n");
}

\n[\t]* {
    if (yyleng - 1 == indent) {
        ECHO;
    } else {
        int new_indent = yyleng - 1;
        printf("\n");
        while (yyleng - 1 < indent) {
            indent -= 1;
            for (int i = 0; i < indent; i++) {
                printf("\t");
            }
            printf("}\n");
        }
        for (int i = 0; i < new_indent; i++) {
            printf("\t");
        }
    }
}

%%

int main(int argc, char *argv[]) {
    yylex();
    return 0;
}
